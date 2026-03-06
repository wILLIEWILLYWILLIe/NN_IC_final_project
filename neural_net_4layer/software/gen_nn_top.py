import os

def generate_nn_pkg():
    with open("../hardware/frontend/sv/nn_pkg.sv", "w") as f:
        f.write("""// =============================================================
// Neural Network Parameter Package (4-Layer)
// =============================================================
package nn_pkg;

    // --- Quantization ---
    parameter BITS       = 14;
    parameter QUANT_VAL  = (1 << BITS);

    // --- Data Width ---
    parameter DATA_WIDTH = 32;

    // --- Network Topology ---
    parameter NUM_LAYERS   = 4;
    parameter NUM_INPUTS   = 784;
    parameter NUM_OUTPUTS  = 10;

    // Layer sizes
    parameter LAYER0_IN  = 784;
    parameter LAYER0_OUT = 128;
    parameter LAYER1_IN  = 128;
    parameter LAYER1_OUT = 64;
    parameter LAYER2_IN  = 64;
    parameter LAYER2_OUT = 32;
    parameter LAYER3_IN  = 32;
    parameter LAYER3_OUT = 10;

    // --- FIFO ---
    parameter FIFO_DEPTH = 16;
    parameter DEBUG = 1;

    // --- Dequantize function (match C arithmetic right shift exactly) ---
    function automatic signed [DATA_WIDTH-1:0] dequantize;
        input signed [2*DATA_WIDTH-1:0] product;
        begin
            dequantize = product >>> BITS;
        end
    endfunction

endpackage
""")

def generate_nn_top():
    layers = [
        (0, "LAYER0_IN", "LAYER0_OUT", "../../../source/layer0_biases.txt"),
        (1, "LAYER1_IN", "LAYER1_OUT", "../../../source/layer1_biases.txt"),
        (2, "LAYER2_IN", "LAYER2_OUT", "../../../source/layer2_biases.txt"),
        (3, "LAYER3_IN", "LAYER3_OUT", "../../../source/layer3_biases.txt")
    ]
    
    with open("../hardware/frontend/sv/nn_top.sv", "w") as f:
        f.write("""// =============================================================
// Neural Network Top Module (4-Layer, Two-Process FSM)
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

    logic                          fifo_rd_en;
    logic signed [DATA_WIDTH-1:0]  fifo_dout;
    logic signed [DATA_WIDTH-1:0]  fifo_dout_reg;
    logic                          fifo_empty;

    fifo #(.FIFO_DATA_WIDTH(DATA_WIDTH), .FIFO_BUFFER_SIZE(16)) u_input_fifo (
        .reset(reset), .wr_clk(clk), .wr_en(wr_en), .din(din), .full(in_full),
        .rd_clk(clk), .rd_en(fifo_rd_en), .dout(fifo_dout), .empty(fifo_empty)
    );

    always_ff @(posedge clk or posedge reset) begin
        if (reset) fifo_dout_reg <= '0;
        else fifo_dout_reg <= fifo_dout;
    end
""")

        # Generate layer instantiations
        for id, l_in, l_out, l_bias in layers:
            f.write(f"""
    // --- Layer {id} ---
    logic                          l{id}_start;
    logic                          l{id}_valid_in;
    logic signed [DATA_WIDTH-1:0]  l{id}_data_in;
    logic                          l{id}_valid_out;
    logic signed [DATA_WIDTH-1:0]  l{id}_relu [{l_out}];

    layer #(.NUM_NEURONS({l_out}), .INPUT_SIZE({l_in}), .LAYER_ID({id}), .BIAS_FILE("{l_bias}")) u_layer{id} (
        .clk(clk), .reset(reset), .start(l{id}_start), .valid_in(l{id}_valid_in),
        .data_in(l{id}_data_in), .valid_out(l{id}_valid_out), .results(l{id}_relu)
    );
""")

        f.write("""
    // --- Argmax ---
    logic                          argmax_start;
    logic signed [DATA_WIDTH-1:0]  argmax_scores [LAYER3_OUT];
    logic                          argmax_valid_out;
    logic [3:0]                    argmax_class;
    logic signed [DATA_WIDTH-1:0]  argmax_score;

    argmax #(.NUM_CLASSES(10)) u_argmax (
        .clk(clk), .reset(reset), .start(argmax_start), .scores(argmax_scores),
        .valid_out(argmax_valid_out), .predicted_class(argmax_class), .max_score(argmax_score)
    );

    // --- FSM ---
    typedef enum logic [4:0] {
        S_IDLE,
""")
        for i in range(4):
            f.write(f"        S_START_L{i}, S_RUN_L{i}, S_WAIT_L{i},\n")
        f.write("""        S_ARGMAX, S_DONE
    } state_t;

    state_t state, state_next;
""")
        for id, l_in, l_out, _ in layers:
            f.write(f"    logic [$clog2({l_in}+1)-1:0] l{id}_cnt, l{id}_cnt_next;\n")
            f.write(f"    logic signed [DATA_WIDTH-1:0] l{id}_result [{l_out}], l{id}_result_next [{l_out}];\n")

        f.write("""
    logic inf_done_r, inf_done_next;
    logic [3:0] pred_r, pred_next;
    logic signed [DATA_WIDTH-1:0] mscore_r, mscore_next;

    // --- FSM Comb ---
    always_comb begin
        state_next      = state;
        inf_done_next   = 1'b0;
        pred_next       = pred_r;
        mscore_next     = mscore_r;
        fifo_rd_en      = 1'b0;
        argmax_start    = 1'b0;

""")
        for id, l_in, l_out, _ in layers:
            f.write(f"        l{id}_cnt_next = l{id}_cnt;\n")
            f.write(f"        l{id}_start = 1'b0;\n")
            f.write(f"        l{id}_valid_in = 1'b0;\n")
            f.write(f"        l{id}_data_in = '0;\n")
            f.write(f"        for (int i=0; i<{l_out}; i++) l{id}_result_next[i] = l{id}_result[i];\n")
            
        f.write(f"        for (int i=0; i<10; i++) argmax_scores[i] = l3_result[i];\n\n")
        f.write("        case (state)\n")
        f.write("            S_IDLE: if (!fifo_empty) state_next = S_START_L0;\n\n")

        for i in range(4):
            prev_result = "fifo_dout_reg" if i == 0 else f"l{i-1}_result[l{i}_cnt]"
            fifo_logic = ""
            if i == 0:
                fifo_logic = f"""
                if (l0_cnt < LAYER0_IN - 1) fifo_rd_en = 1'b1;"""

            next_state = f"S_START_L{i+1}" if i < 3 else "S_ARGMAX"
            f.write(f"""
            S_START_L{i}: begin
                l{i}_start = 1'b1;
                l{i}_cnt_next = '0;
                if ({i} == 0) fifo_rd_en = 1'b1;
                state_next = S_RUN_L{i};
            end
            S_RUN_L{i}: begin
                l{i}_valid_in = 1'b1;
                l{i}_data_in = {prev_result};
                l{i}_cnt_next = l{i}_cnt + 1;{fifo_logic}
                if (l{i}_cnt == LAYER{i}_IN - 1) state_next = S_WAIT_L{i};
            end
            S_WAIT_L{i}: begin
                if (l{i}_valid_out) begin
                    for (int j=0; j<LAYER{i}_OUT; j++) l{i}_result_next[j] = l{i}_relu[j];
                    state_next = {next_state};
                end
            end
""")

        f.write("""
            S_ARGMAX: begin
                argmax_start = 1'b1;
                for (int i=0; i<10; i++) argmax_scores[i] = l3_result[i];
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

    // --- FSM Seq ---
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S_IDLE;
            inf_done_r <= 1'b0;
            pred_r <= '0;
            mscore_r <= '0;
""")
        for id, l_in, l_out, _ in layers:
            f.write(f"            l{id}_cnt <= '0;\n")
            f.write(f"            for (int i=0; i<{l_out}; i++) l{id}_result[i] <= '0;\n")
        f.write("""        end else begin
            state <= state_next;
            inf_done_r <= inf_done_next;
            pred_r <= pred_next;
            mscore_r <= mscore_next;
""")
        for id, l_in, l_out, _ in layers:
            f.write(f"            l{id}_cnt <= l{id}_cnt_next;\n")
            f.write(f"            for (int i=0; i<{l_out}; i++) l{id}_result[i] <= l{id}_result_next[i];\n")
        f.write("""        end
    end

    assign inference_done = inf_done_r;
    assign predicted_class = pred_r;
    assign max_score = mscore_r;

endmodule
""")

if __name__ == "__main__":
    generate_nn_pkg()
    generate_nn_top()
    print("nn_pkg.sv and nn_top.sv generated successfully")
