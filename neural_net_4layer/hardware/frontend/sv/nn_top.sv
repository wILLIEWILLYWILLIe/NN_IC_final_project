// =============================================================
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

    // --- Layer 0 ---
    logic                          l0_start;
    logic                          l0_valid_in;
    logic signed [DATA_WIDTH-1:0]  l0_data_in;
    logic                          l0_valid_out;
    logic signed [DATA_WIDTH-1:0]  l0_relu [LAYER0_OUT];

    layer #(.NUM_NEURONS(LAYER0_OUT), .INPUT_SIZE(LAYER0_IN), .LAYER_ID(0), .BIAS_FILE("../../../source/layer0_biases.txt")) u_layer0 (
        .clk(clk), .reset(reset), .start(l0_start), .valid_in(l0_valid_in),
        .data_in(l0_data_in), .valid_out(l0_valid_out), .results(l0_relu)
    );

    // --- Layer 1 ---
    logic                          l1_start;
    logic                          l1_valid_in;
    logic signed [DATA_WIDTH-1:0]  l1_data_in;
    logic                          l1_valid_out;
    logic signed [DATA_WIDTH-1:0]  l1_relu [LAYER1_OUT];

    layer #(.NUM_NEURONS(LAYER1_OUT), .INPUT_SIZE(LAYER1_IN), .LAYER_ID(1), .BIAS_FILE("../../../source/layer1_biases.txt")) u_layer1 (
        .clk(clk), .reset(reset), .start(l1_start), .valid_in(l1_valid_in),
        .data_in(l1_data_in), .valid_out(l1_valid_out), .results(l1_relu)
    );

    // --- Layer 2 ---
    logic                          l2_start;
    logic                          l2_valid_in;
    logic signed [DATA_WIDTH-1:0]  l2_data_in;
    logic                          l2_valid_out;
    logic signed [DATA_WIDTH-1:0]  l2_relu [LAYER2_OUT];

    layer #(.NUM_NEURONS(LAYER2_OUT), .INPUT_SIZE(LAYER2_IN), .LAYER_ID(2), .BIAS_FILE("../../../source/layer2_biases.txt")) u_layer2 (
        .clk(clk), .reset(reset), .start(l2_start), .valid_in(l2_valid_in),
        .data_in(l2_data_in), .valid_out(l2_valid_out), .results(l2_relu)
    );

    // --- Layer 3 ---
    logic                          l3_start;
    logic                          l3_valid_in;
    logic signed [DATA_WIDTH-1:0]  l3_data_in;
    logic                          l3_valid_out;
    logic signed [DATA_WIDTH-1:0]  l3_relu [LAYER3_OUT];

    layer #(.NUM_NEURONS(LAYER3_OUT), .INPUT_SIZE(LAYER3_IN), .LAYER_ID(3), .BIAS_FILE("../../../source/layer3_biases.txt")) u_layer3 (
        .clk(clk), .reset(reset), .start(l3_start), .valid_in(l3_valid_in),
        .data_in(l3_data_in), .valid_out(l3_valid_out), .results(l3_relu)
    );

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
        S_START_L0, S_RUN_L0, S_WAIT_L0,
        S_START_L1, S_RUN_L1, S_WAIT_L1,
        S_START_L2, S_RUN_L2, S_WAIT_L2,
        S_START_L3, S_RUN_L3, S_WAIT_L3,
        S_ARGMAX, S_DONE
    } state_t;

    state_t state, state_next;
    logic [$clog2(LAYER0_IN+1)-1:0] l0_cnt, l0_cnt_next;
    logic signed [DATA_WIDTH-1:0] l0_result [LAYER0_OUT], l0_result_next [LAYER0_OUT];
    logic [$clog2(LAYER1_IN+1)-1:0] l1_cnt, l1_cnt_next;
    logic signed [DATA_WIDTH-1:0] l1_result [LAYER1_OUT], l1_result_next [LAYER1_OUT];
    logic [$clog2(LAYER2_IN+1)-1:0] l2_cnt, l2_cnt_next;
    logic signed [DATA_WIDTH-1:0] l2_result [LAYER2_OUT], l2_result_next [LAYER2_OUT];
    logic [$clog2(LAYER3_IN+1)-1:0] l3_cnt, l3_cnt_next;
    logic signed [DATA_WIDTH-1:0] l3_result [LAYER3_OUT], l3_result_next [LAYER3_OUT];

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

        l0_cnt_next = l0_cnt;
        l0_start = 1'b0;
        l0_valid_in = 1'b0;
        l0_data_in = '0;
        for (int i=0; i<LAYER0_OUT; i++) l0_result_next[i] = l0_result[i];
        l1_cnt_next = l1_cnt;
        l1_start = 1'b0;
        l1_valid_in = 1'b0;
        l1_data_in = '0;
        for (int i=0; i<LAYER1_OUT; i++) l1_result_next[i] = l1_result[i];
        l2_cnt_next = l2_cnt;
        l2_start = 1'b0;
        l2_valid_in = 1'b0;
        l2_data_in = '0;
        for (int i=0; i<LAYER2_OUT; i++) l2_result_next[i] = l2_result[i];
        l3_cnt_next = l3_cnt;
        l3_start = 1'b0;
        l3_valid_in = 1'b0;
        l3_data_in = '0;
        for (int i=0; i<LAYER3_OUT; i++) l3_result_next[i] = l3_result[i];
        for (int i=0; i<10; i++) argmax_scores[i] = l3_result[i];

        case (state)
            S_IDLE: if (!fifo_empty) state_next = S_START_L0;


            S_START_L0: begin
                l0_start = 1'b1;
                l0_cnt_next = '0;
                if (0 == 0) fifo_rd_en = 1'b1;
                state_next = S_RUN_L0;
            end
            S_RUN_L0: begin
                l0_valid_in = 1'b1;
                l0_data_in = fifo_dout_reg;
                l0_cnt_next = l0_cnt + 1;
                if (l0_cnt < LAYER0_IN - 1) fifo_rd_en = 1'b1;
                if (l0_cnt == LAYER0_IN - 1) state_next = S_WAIT_L0;
            end
            S_WAIT_L0: begin
                if (l0_valid_out) begin
                    for (int j=0; j<LAYER0_OUT; j++) l0_result_next[j] = l0_relu[j];
                    state_next = S_START_L1;
                end
            end

            S_START_L1: begin
                l1_start = 1'b1;
                l1_cnt_next = '0;
                if (1 == 0) fifo_rd_en = 1'b1;
                state_next = S_RUN_L1;
            end
            S_RUN_L1: begin
                l1_valid_in = 1'b1;
                l1_data_in = l0_result[l1_cnt];
                l1_cnt_next = l1_cnt + 1;
                if (l1_cnt == LAYER1_IN - 1) state_next = S_WAIT_L1;
            end
            S_WAIT_L1: begin
                if (l1_valid_out) begin
                    for (int j=0; j<LAYER1_OUT; j++) l1_result_next[j] = l1_relu[j];
                    state_next = S_START_L2;
                end
            end

            S_START_L2: begin
                l2_start = 1'b1;
                l2_cnt_next = '0;
                if (2 == 0) fifo_rd_en = 1'b1;
                state_next = S_RUN_L2;
            end
            S_RUN_L2: begin
                l2_valid_in = 1'b1;
                l2_data_in = l1_result[l2_cnt];
                l2_cnt_next = l2_cnt + 1;
                if (l2_cnt == LAYER2_IN - 1) state_next = S_WAIT_L2;
            end
            S_WAIT_L2: begin
                if (l2_valid_out) begin
                    for (int j=0; j<LAYER2_OUT; j++) l2_result_next[j] = l2_relu[j];
                    state_next = S_START_L3;
                end
            end

            S_START_L3: begin
                l3_start = 1'b1;
                l3_cnt_next = '0;
                if (3 == 0) fifo_rd_en = 1'b1;
                state_next = S_RUN_L3;
            end
            S_RUN_L3: begin
                l3_valid_in = 1'b1;
                l3_data_in = l2_result[l3_cnt];
                l3_cnt_next = l3_cnt + 1;
                if (l3_cnt == LAYER3_IN - 1) state_next = S_WAIT_L3;
            end
            S_WAIT_L3: begin
                if (l3_valid_out) begin
                    for (int j=0; j<LAYER3_OUT; j++) l3_result_next[j] = l3_relu[j];
                    state_next = S_ARGMAX;
                end
            end

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
            l0_cnt <= '0;
            for (int i=0; i<LAYER0_OUT; i++) l0_result[i] <= '0;
            l1_cnt <= '0;
            for (int i=0; i<LAYER1_OUT; i++) l1_result[i] <= '0;
            l2_cnt <= '0;
            for (int i=0; i<LAYER2_OUT; i++) l2_result[i] <= '0;
            l3_cnt <= '0;
            for (int i=0; i<LAYER3_OUT; i++) l3_result[i] <= '0;
        end else begin
            state <= state_next;
            inf_done_r <= inf_done_next;
            pred_r <= pred_next;
            mscore_r <= mscore_next;
            l0_cnt <= l0_cnt_next;
            for (int i=0; i<LAYER0_OUT; i++) l0_result[i] <= l0_result_next[i];
            l1_cnt <= l1_cnt_next;
            for (int i=0; i<LAYER1_OUT; i++) l1_result[i] <= l1_result_next[i];
            l2_cnt <= l2_cnt_next;
            for (int i=0; i<LAYER2_OUT; i++) l2_result[i] <= l2_result_next[i];
            l3_cnt <= l3_cnt_next;
            for (int i=0; i<LAYER3_OUT; i++) l3_result[i] <= l3_result_next[i];
        end
    end

    assign inference_done = inf_done_r;
    assign predicted_class = pred_r;
    assign max_score = mscore_r;

endmodule
