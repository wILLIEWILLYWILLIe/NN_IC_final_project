// =============================================================
// NPU MAC Cell & Lane (Time-Multiplexed 4-Stage Pipeline)
// =============================================================

module mac_cell
    import nn_pkg::*;
(
    input  logic                          clk,
    input  logic                          reset,
    input  logic                          start,       // Asserted with first valid_in
    input  logic                          valid_in,
    input  logic                          last_in,
    input  logic                          relu_en,
    input  logic signed [DATA_WIDTH-1:0]  data_in,
    input  logic signed [DATA_WIDTH-1:0]  weight_in,
    input  logic signed [DATA_WIDTH-1:0]  bias_in,
    output logic                          valid_out,   // Pulses 1 cycle when sum is ready
    output logic signed [DATA_WIDTH-1:0]  out
);
    // Stage 1
    logic signed [DATA_WIDTH-1:0] data_r, weight_r, bias_r;
    logic valid_r1, start_r1, last_r1, relu_en_r1;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            valid_r1 <= 0; start_r1 <= 0; last_r1 <= 0; relu_en_r1 <= 0;
            data_r <= '0; weight_r <= '0; bias_r <= '0;
        end else begin
            valid_r1 <= valid_in;
            start_r1 <= start;
            last_r1  <= last_in;
            relu_en_r1 <= relu_en;
            data_r <= data_in;
            weight_r <= weight_in;
            if (start && valid_in) bias_r <= bias_in; // Sample bias once at start
        end
    end

    // Stage 2
    logic signed [2*DATA_WIDTH-1:0] product_r;
    logic valid_r2, start_r2, last_r2, relu_en_r2;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            valid_r2 <= 0; start_r2 <= 0; last_r2 <= 0; relu_en_r2 <= 0;
            product_r <= '0;
        end else begin
            valid_r2 <= valid_r1;
            start_r2 <= start_r1;
            last_r2  <= last_r1;
            relu_en_r2 <= relu_en_r1;
            product_r <= data_r * weight_r;
        end
    end

    // Stage 3 (Accumulator)
    logic signed [63:0] acc;
    logic last_r3, relu_en_r3;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            acc <= '0;
            last_r3 <= 0;
            relu_en_r3 <= 0;
        end else begin
            last_r3 <= 0; // default
            if (valid_r2) begin
                if (start_r2) acc <= {{32{bias_r[31]}}, bias_r} + product_r;
                else          acc <= acc + product_r;
                last_r3 <= last_r2;
                relu_en_r3 <= relu_en_r2;
            end
        end
    end

    // Stage 4 (Dequantize & ReLU)
    logic signed [DATA_WIDTH-1:0] dq;
    assign dq = dequantize(acc);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            valid_out <= 0;
            out <= '0;
        end else begin
            valid_out <= last_r3;
            if (last_r3) begin
                if (!relu_en_r3) out <= dq;
                else if (dq > 0) out <= dq;
                else out <= '0;
                // DEBUG
                $display("MAC Output: acc=%0d, dq=%0d, out=%0d", acc, dq, (!relu_en_r3 || dq>0)? dq : 0);
            end
        end
    end
endmodule

module mac_lane
    import nn_pkg::*;
#(
    parameter LANE_ID = 0
)(
    input  logic clk, reset,
    input  logic start_in, valid_in, last_in, relu_en,
    input  logic signed [DATA_WIDTH-1:0] data_in,     // Delayed 1-cycle from buffer automatically by BRAM
    input  logic [11:0] weight_addr,                  // Asserts cycle 0 -> mem cycle 1
    input  logic [3:0]  bias_addr,                    // Asserts cycle 0 -> mem cycle 1
    output logic valid_out,
    output logic signed [DATA_WIDTH-1:0] out
);
    logic signed [DATA_WIDTH-1:0] weight_out, bias_out;
    
    // BRAMs
    logic signed [DATA_WIDTH-1:0] weight_mem [0:4095];
    logic signed [DATA_WIDTH-1:0] bias_mem   [0:15]; 

    initial begin
        $readmemh($sformatf("../../../source/npu_weights/bank%0d_weights.txt", LANE_ID), weight_mem);
        $readmemh($sformatf("../../../source/npu_weights/bank%0d_biases.txt", LANE_ID), bias_mem);
    end

    always_ff @(posedge clk) begin
        weight_out <= weight_mem[weight_addr];
        bias_out   <= bias_mem[bias_addr];
    end

    // Delay controls by 1 cycle to match BRAM read latency
    logic start_d, valid_d, last_d, relu_d;
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            start_d <= 0; valid_d <= 0; last_d <= 0; relu_d <= 0;
        end else begin
            start_d <= start_in;
            valid_d <= valid_in;
            last_d  <= last_in;
            relu_d  <= relu_en;
        end
    end

    mac_cell u_mac (
        .clk(clk), .reset(reset),
        .start(start_d), .valid_in(valid_d), .last_in(last_d), .relu_en(relu_d),
        .data_in(data_in), .weight_in(weight_out), .bias_in(bias_out),
        .valid_out(valid_out), .out(out)
    );
endmodule
