// =============================================================
// Neuron Module — 3-Stage Pipelined MAC with dequantization
// =============================================================
// Pipeline stages (per MAC iteration):
//   Stage 0: weight_reg <= weights[cnt], data_reg <= data_in
//   Stage 1: product_reg <= data_reg * weight_reg        (DSP)
//   Stage 2: acc <= acc + dequantize(product_reg)         (LUT)
//
// Latency = INPUT_SIZE + 3 cycles
// =============================================================
module neuron
    import nn_pkg::*;
#(
    parameter INPUT_SIZE   = 784,
    parameter WEIGHT_FILE  = "weights.txt"
)
(
    input  logic                          clk,
    input  logic                          reset,
    input  logic                          start,      // pulse: begin new inference
    input  logic signed [DATA_WIDTH-1:0]  bias,       // bias value for this neuron
    input  logic                          valid_in,   // input data valid
    input  logic signed [DATA_WIDTH-1:0]  data_in,    // streaming input
    output logic                          valid_out,  // output ready
    output logic signed [DATA_WIDTH-1:0]  data_out    // neuron output
);

    // Weight ROM
    logic signed [DATA_WIDTH-1:0] weights [0:INPUT_SIZE-1];
    initial $readmemh(WEIGHT_FILE, weights);

    // ---------------------------------------------------------
    // State registers
    // ---------------------------------------------------------
    // Stage 0 control (input capture)
    logic [$clog2(INPUT_SIZE+1)-1:0] cnt,          cnt_next;
    logic                            active,       active_next;

    // Stage 0 → 1 pipeline registers
    logic signed [DATA_WIDTH-1:0]    weight_reg,   weight_reg_next;
    logic signed [DATA_WIDTH-1:0]    data_reg,     data_reg_next;
    logic                            s0_valid,     s0_valid_next;
    logic                            s0_last,      s0_last_next;

    // Stage 1 → 2 pipeline registers
    logic signed [2*DATA_WIDTH-1:0]  product_reg,  product_reg_next;
    logic                            s1_valid,     s1_valid_next;
    logic                            s1_last,      s1_last_next;

    // Stage 2 (accumulate)
    logic signed [DATA_WIDTH-1:0]    acc,          acc_next;

    // Output
    logic                            done_pending, done_pending_next;
    logic                            valid_out_r,  valid_out_next;
    logic signed [DATA_WIDTH-1:0]    data_out_r,   data_out_next;

    // ---------------------------------------------------------
    // Process 1: Combinational next-state logic
    // ---------------------------------------------------------
    always_comb begin
        // Defaults: hold current values
        cnt_next          = cnt;
        active_next       = active;
        weight_reg_next   = weight_reg;
        data_reg_next     = data_reg;
        s0_valid_next     = 1'b0;
        s0_last_next      = 1'b0;
        product_reg_next  = product_reg;
        s1_valid_next     = 1'b0;
        s1_last_next      = 1'b0;
        acc_next          = acc;
        done_pending_next = done_pending;
        valid_out_next    = 1'b0;
        data_out_next     = data_out_r;

        // Start: initialize accumulator with bias
        if (start) begin
            acc_next          = bias;
            cnt_next          = '0;
            active_next       = 1'b1;
            done_pending_next = 1'b0;
        end

        // Stage 0: Capture weight and data into registers
        if (active && valid_in) begin
            weight_reg_next = weights[cnt];
            data_reg_next   = data_in;
            s0_valid_next   = 1'b1;
            cnt_next        = cnt + 1;

            if (cnt == INPUT_SIZE - 1) begin
                active_next = 1'b0;
                s0_last_next = 1'b1;
            end
        end

        // Stage 1: Multiply (uses registered weight and data)
        if (s0_valid) begin
            product_reg_next = $signed(data_reg) * $signed(weight_reg);
            s1_valid_next    = 1'b1;
            s1_last_next     = s0_last;
        end

        // Stage 2: Dequantize + Accumulate
        if (s1_valid) begin
            acc_next = acc + dequantize(product_reg);

            if (s1_last) begin
                done_pending_next = 1'b1;
            end
        end

        // Output: emit final result
        if (done_pending) begin
            data_out_next     = acc;
            valid_out_next    = 1'b1;
            done_pending_next = 1'b0;
        end
    end

    // ---------------------------------------------------------
    // Process 2: Sequential state register update
    // ---------------------------------------------------------
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            cnt          <= '0;
            active       <= 1'b0;
            weight_reg   <= '0;
            data_reg     <= '0;
            s0_valid     <= 1'b0;
            s0_last      <= 1'b0;
            product_reg  <= '0;
            s1_valid     <= 1'b0;
            s1_last      <= 1'b0;
            acc          <= '0;
            done_pending <= 1'b0;
            valid_out_r  <= 1'b0;
            data_out_r   <= '0;
        end else begin
            cnt          <= cnt_next;
            active       <= active_next;
            weight_reg   <= weight_reg_next;
            data_reg     <= data_reg_next;
            s0_valid     <= s0_valid_next;
            s0_last      <= s0_last_next;
            product_reg  <= product_reg_next;
            s1_valid     <= s1_valid_next;
            s1_last      <= s1_last_next;
            acc          <= acc_next;
            done_pending <= done_pending_next;
            valid_out_r  <= valid_out_next;
            data_out_r   <= data_out_next;
        end
    end

    assign valid_out = valid_out_r;
    assign data_out  = data_out_r;

endmodule
