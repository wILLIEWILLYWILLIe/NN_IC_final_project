// =============================================================
// Resource-Sharing NPU Top Module
// =============================================================
module nn_top
    import nn_pkg::*;
(
    input  logic                          clk,
    input  logic                          reset,
    input  logic                          wr_en,
    input  logic signed [DATA_WIDTH-1:0]  din,
    output logic                          in_full,
    output logic                          inference_done,
    output logic [3:0]                    predicted_class,
    output logic signed [DATA_WIDTH-1:0]  max_score
);

    // --- Input FIFO ---
    logic                          fifo_rd_en;
    logic signed [DATA_WIDTH-1:0]  fifo_dout;
    logic                          fifo_empty;

    fifo #(.FIFO_DATA_WIDTH(DATA_WIDTH), .FIFO_BUFFER_SIZE(1024)) u_input_fifo (
        .reset(reset), .clk(clk), .wr_en(wr_en), .din(din), .full(in_full),
        .rd_en(fifo_rd_en), .dout(fifo_dout), .empty(fifo_empty)
    );

    // --- Activation RAM (1024 x 32) ---
    logic [9:0]                    act_raddr;
    logic signed [DATA_WIDTH-1:0]  act_rdata;
    logic                          act_we;
    logic [9:0]                    act_waddr;
    logic signed [DATA_WIDTH-1:0]  act_wdata;

    logic signed [DATA_WIDTH-1:0]  act_ram [0:1023];

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            act_rdata <= '0;
            for (int i = 0; i < 1024; i++)
                act_ram[i] <= '0;
        end else begin
            act_rdata <= act_ram[act_raddr];
            if (act_we) begin
                act_ram[act_waddr] <= act_wdata;
            end
        end
    end

    // Constants for memory map (16-bit data)
    localparam ACT_ADDR_IN  = 10'd0;    // size 784
    localparam ACT_ADDR_L0  = 10'd784;  // size 32
    localparam ACT_ADDR_L1  = 10'd816;  // size 16
    localparam ACT_ADDR_L2  = 10'd832;  // size 16
    localparam ACT_ADDR_L3  = 10'd848;  // size 10

    // --- FSM Types and Variables ---
    typedef enum logic [3:0] {
        S_IDLE,
        S_LOAD_IMG_RUN,
        S_MAC_PASS,
        S_WAIT_MAC,
        S_DRAIN,
        S_ARGMAX,
        S_DONE
    } state_t;

    state_t state, state_next;
    logic [9:0] img_cnt, img_cnt_next;
    logic [1:0] layer_idx, layer_idx_next;
    logic [2:0] pass_idx, pass_idx_next;
    logic [9:0] in_cnt, in_cnt_next;
    logic [5:0] drain_cnt, drain_cnt_next;

    logic inf_done_r, inf_done_next;
    logic [3:0] pred_r, pred_next;
    logic signed [DATA_WIDTH-1:0] mscore_r, mscore_next;

    logic [9:0] src_offset;
    logic [9:0] dst_offset;
    logic [9:0] input_size;
    logic [2:0] num_pass;
    logic       layer_relu_val;
    logic [11:0] w_offset;

    always_comb begin
        case (layer_idx)
            2'd0: begin
                src_offset = ACT_ADDR_IN;
                dst_offset = ACT_ADDR_L0;
                input_size = 10'd784;
                num_pass   = 3'd1;
                layer_relu_val = 1'b1;
                w_offset   = 12'd0;
            end
            2'd1: begin
                src_offset = ACT_ADDR_L0;
                dst_offset = ACT_ADDR_L1;
                input_size = 10'd32;
                num_pass   = 3'd1;
                layer_relu_val = 1'b1;
                w_offset   = 12'd784;
            end
            2'd2: begin
                src_offset = ACT_ADDR_L1;
                dst_offset = ACT_ADDR_L2;
                input_size = 10'd16;
                num_pass   = 3'd1;
                layer_relu_val = 1'b1;
                w_offset   = 12'd816;
            end
            2'd3: begin
                src_offset = ACT_ADDR_L2;
                dst_offset = ACT_ADDR_L3;
                input_size = 10'd16;
                num_pass   = 3'd1;
                layer_relu_val = 1'b0;
                w_offset   = 12'd832;
            end
            default: begin
                src_offset = ACT_ADDR_IN;
                dst_offset = ACT_ADDR_L0;
                input_size = 10'd784;
                num_pass   = 3'd1;
                layer_relu_val = 1'b1;
                w_offset   = 12'd0;
            end
        endcase
    end

    // --- MAC Array ---
    logic                          mac_start_in;
    logic                          mac_valid_in;
    logic                          mac_last_in;
    logic                          mac_relu_en;
    logic [11:0]                   global_w_addr;
    logic [3:0]                    mac_bias_addr;

    logic                          mac_valid_out [32];
    logic signed [DATA_WIDTH-1:0]  mac_outs [32];
    logic signed [DATA_WIDTH-1:0]  mac_outs_latched [32];

    for (genvar i = 0; i < 32; i++) begin : gen_mac_lanes
        mac_lane #(.LANE_ID(i)) u_lane (
            .clk(clk),
            .reset(reset),
            .start_in(mac_start_in),
            .valid_in(mac_valid_in),
            .last_in(mac_last_in),
            .relu_en(mac_relu_en),
            .data_in(act_rdata),
            .weight_addr(global_w_addr),
            .bias_addr(mac_bias_addr),
            .valid_out(mac_valid_out[i]),
            .out(mac_outs[i])
        );
    end

    // Capture MAC outputs
    always_ff @(posedge clk) begin
        if (mac_valid_out[0]) begin
            for (int i=0; i<32; i++) mac_outs_latched[i] <= mac_outs[i];
        end
    end

    // --- Argmax ---
    logic                          argmax_start;
    logic signed [DATA_WIDTH-1:0]  argmax_scores [10];
    logic                          argmax_valid_out;
    logic [3:0]                    argmax_class;
    logic signed [DATA_WIDTH-1:0]  argmax_score;

    for (genvar i=0; i<10; i++) begin : gen_argmax_in
        assign argmax_scores[i] = mac_outs_latched[i];
    end

    argmax #(.NUM_CLASSES(10)) u_argmax (
        .clk(clk), .reset(reset), .start(argmax_start), .scores(argmax_scores),
        .valid_out(argmax_valid_out), .predicted_class(argmax_class), .max_score(argmax_score)
    );

    // --- FSM ---

    // Real-time calculation of weight and bias addresses
    assign global_w_addr = w_offset + in_cnt;
    assign mac_bias_addr = {2'b0, layer_idx};

    logic [5:0] drain_limit;
    always_comb begin
        case (layer_idx)
            0: drain_limit = 6'd32;
            1: drain_limit = 6'd16;
            2: drain_limit = 6'd16;
            3: drain_limit = 6'd10;
            default: drain_limit = 6'd32;
        endcase
    end

    always_comb begin
        state_next     = state;
        img_cnt_next   = img_cnt;
        layer_idx_next = layer_idx;
        pass_idx_next  = pass_idx;
        in_cnt_next    = in_cnt;
        drain_cnt_next = drain_cnt;
        
        inf_done_next  = 1'b0;
        pred_next      = pred_r;
        mscore_next    = mscore_r;

        fifo_rd_en     = 1'b0;
        act_we         = 1'b0;
        act_waddr      = '0;
        act_wdata      = '0;
        act_raddr      = '0;

        mac_start_in   = 1'b0;
        mac_valid_in   = 1'b0;
        mac_last_in    = 1'b0;
        mac_relu_en    = 1'b0;

        argmax_start   = 1'b0;

        case (state)
            S_IDLE: begin
                if (!fifo_empty) begin
                    state_next = S_LOAD_IMG_RUN;
                    layer_idx_next = 0;
                    pass_idx_next = 0;
                    img_cnt_next = 0;
                end
            end
            
            S_LOAD_IMG_RUN: begin
                act_we = 1'b1;
                act_waddr = ACT_ADDR_IN + img_cnt;
                act_wdata = fifo_dout;
                img_cnt_next = img_cnt + 1;
                
                fifo_rd_en = 1'b1;
                
                if (img_cnt == 784 - 1) begin
                    state_next = S_MAC_PASS;
                    in_cnt_next = 0;
                end
            end
            
            S_MAC_PASS: begin
                act_raddr = src_offset + in_cnt;
                
                mac_start_in = (in_cnt == 0);
                mac_valid_in = 1'b1;
                mac_last_in  = (in_cnt == input_size - 1);
                mac_relu_en  = layer_relu_val;
                
                in_cnt_next = in_cnt + 1;
                
                if (in_cnt == input_size - 1) begin
                    state_next = S_WAIT_MAC;
                end
            end
            
            S_WAIT_MAC: begin
                if (mac_valid_out[0]) begin
                    state_next = S_DRAIN;
                    drain_cnt_next = 0;
                end
            end
            
            S_DRAIN: begin
                act_we = 1'b1;
                act_waddr = dst_offset + (pass_idx * 32) + drain_cnt;
                act_wdata = mac_outs_latched[drain_cnt];
                
                drain_cnt_next = drain_cnt + 1;
                
                if (drain_cnt == drain_limit - 1) begin
                    if (pass_idx == num_pass - 1) begin
                        if (layer_idx == 3) begin
                            state_next = S_ARGMAX;
                        end else begin
                            layer_idx_next = layer_idx + 1;
                            pass_idx_next = 0;
                            in_cnt_next = 0;
                            state_next = S_MAC_PASS;
                        end
                    end else begin
                        pass_idx_next = pass_idx + 1;
                        in_cnt_next = 0;
                        state_next = S_MAC_PASS;
                    end
                end
            end
            
            S_ARGMAX: begin
                argmax_start = 1'b1;
                state_next = S_DONE;
            end
            
            S_DONE: begin
                if (argmax_valid_out) begin
                    pred_next = argmax_class;
                    mscore_next = argmax_score;
                    inf_done_next = 1'b1;
                    state_next = S_IDLE;
                end
            end
            
            default: state_next = S_IDLE;
        endcase
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S_IDLE;
            img_cnt <= '0;
            layer_idx <= '0;
            pass_idx <= '0;
            in_cnt <= '0;
            drain_cnt <= '0;
            inf_done_r <= 1'b0;
            pred_r <= '0;
            mscore_r <= '0;
        end else begin
            state <= state_next;
            img_cnt <= img_cnt_next;
            layer_idx <= layer_idx_next;
            pass_idx <= pass_idx_next;
            in_cnt <= in_cnt_next;
            drain_cnt <= drain_cnt_next;
            inf_done_r <= inf_done_next;
            pred_r <= pred_next;
            mscore_r <= mscore_next;
        end
    end

    assign inference_done = inf_done_r;
    assign predicted_class = pred_r;
    assign max_score = mscore_r;

endmodule
