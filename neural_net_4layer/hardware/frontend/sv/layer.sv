// =============================================================
// Auto-generated Parameterized Dense Layer Module (4 Layers)
// =============================================================
module layer
    import nn_pkg::*;
#(
    parameter int    NUM_NEURONS   = 10,
    parameter int    INPUT_SIZE    = 784,
    parameter int    LAYER_ID      = 0,
    parameter string BIAS_FILE     = ""
)
(
    input  logic                          clk,
    input  logic                          reset,
    input  logic                          start,
    input  logic                          valid_in,
    input  logic signed [DATA_WIDTH-1:0]  data_in,
    output logic                          valid_out,
    output logic signed [DATA_WIDTH-1:0]  results [0:NUM_NEURONS-1]
);

    // ---------------------------------------------------------
    // Bias ROM
    // ---------------------------------------------------------
    logic signed [DATA_WIDTH-1:0] biases [0:200]; // Max size to prevent out of bounds
    initial begin
        if (BIAS_FILE != "") $readmemh(BIAS_FILE, biases);
    end

    // ---------------------------------------------------------
    // Neuron array (generate loop)
    // ---------------------------------------------------------
    logic                          neuron_valid [NUM_NEURONS];
    logic signed [DATA_WIDTH-1:0]  neuron_out   [NUM_NEURONS];

    genvar i;
    generate
        for (i = 0; i < NUM_NEURONS; i++) begin : gen_neurons
            if (LAYER_ID == 0) begin : l0
                if (i == 0) begin : n0
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron0_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 1) begin : n1
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron1_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 2) begin : n2
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron2_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 3) begin : n3
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron3_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 4) begin : n4
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron4_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 5) begin : n5
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron5_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 6) begin : n6
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron6_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 7) begin : n7
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron7_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 8) begin : n8
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron8_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 9) begin : n9
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron9_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 10) begin : n10
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron10_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 11) begin : n11
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron11_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 12) begin : n12
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron12_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 13) begin : n13
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron13_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 14) begin : n14
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron14_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 15) begin : n15
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron15_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 16) begin : n16
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron16_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 17) begin : n17
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron17_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 18) begin : n18
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron18_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 19) begin : n19
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron19_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 20) begin : n20
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron20_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 21) begin : n21
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron21_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 22) begin : n22
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron22_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 23) begin : n23
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron23_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 24) begin : n24
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron24_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 25) begin : n25
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron25_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 26) begin : n26
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron26_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 27) begin : n27
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron27_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 28) begin : n28
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron28_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 29) begin : n29
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron29_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 30) begin : n30
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron30_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 31) begin : n31
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron31_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
            end
            else if (LAYER_ID == 1) begin : l1
                if (i == 0) begin : n0
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron0_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 1) begin : n1
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron1_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 2) begin : n2
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron2_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 3) begin : n3
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron3_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 4) begin : n4
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron4_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 5) begin : n5
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron5_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 6) begin : n6
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron6_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 7) begin : n7
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron7_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 8) begin : n8
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron8_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 9) begin : n9
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron9_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 10) begin : n10
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron10_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 11) begin : n11
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron11_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 12) begin : n12
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron12_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 13) begin : n13
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron13_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 14) begin : n14
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron14_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 15) begin : n15
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron15_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
            end
            else if (LAYER_ID == 2) begin : l2
                if (i == 0) begin : n0
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron0_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 1) begin : n1
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron1_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 2) begin : n2
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron2_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 3) begin : n3
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron3_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 4) begin : n4
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron4_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 5) begin : n5
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron5_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 6) begin : n6
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron6_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 7) begin : n7
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron7_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 8) begin : n8
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron8_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 9) begin : n9
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron9_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 10) begin : n10
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron10_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 11) begin : n11
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron11_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 12) begin : n12
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron12_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 13) begin : n13
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron13_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 14) begin : n14
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron14_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 15) begin : n15
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron15_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
            end
            else if (LAYER_ID == 3) begin : l3
                if (i == 0) begin : n0
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer3_neuron0_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 1) begin : n1
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer3_neuron1_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 2) begin : n2
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer3_neuron2_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 3) begin : n3
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer3_neuron3_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 4) begin : n4
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer3_neuron4_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 5) begin : n5
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer3_neuron5_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 6) begin : n6
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer3_neuron6_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 7) begin : n7
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer3_neuron7_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 8) begin : n8
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer3_neuron8_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 9) begin : n9
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer3_neuron9_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
            end
        end
    endgenerate

    // ---------------------------------------------------------
    // ReLU activation (combinational)
    // ---------------------------------------------------------
    assign valid_out = neuron_valid[0];

    always_comb begin
        for (int j = 0; j < NUM_NEURONS; j++)
            results[j] = (neuron_out[j] > 0) ? neuron_out[j] : '0;
    end

endmodule
