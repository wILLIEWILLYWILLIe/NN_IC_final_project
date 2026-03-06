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
                else if (i == 32) begin : n32
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron32_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 33) begin : n33
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron33_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 34) begin : n34
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron34_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 35) begin : n35
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron35_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 36) begin : n36
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron36_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 37) begin : n37
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron37_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 38) begin : n38
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron38_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 39) begin : n39
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron39_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 40) begin : n40
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron40_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 41) begin : n41
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron41_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 42) begin : n42
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron42_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 43) begin : n43
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron43_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 44) begin : n44
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron44_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 45) begin : n45
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron45_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 46) begin : n46
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron46_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 47) begin : n47
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron47_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 48) begin : n48
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron48_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 49) begin : n49
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron49_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 50) begin : n50
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron50_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 51) begin : n51
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron51_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 52) begin : n52
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron52_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 53) begin : n53
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron53_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 54) begin : n54
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron54_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 55) begin : n55
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron55_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 56) begin : n56
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron56_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 57) begin : n57
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron57_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 58) begin : n58
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron58_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 59) begin : n59
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron59_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 60) begin : n60
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron60_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 61) begin : n61
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron61_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 62) begin : n62
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron62_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 63) begin : n63
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron63_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 64) begin : n64
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron64_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 65) begin : n65
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron65_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 66) begin : n66
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron66_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 67) begin : n67
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron67_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 68) begin : n68
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron68_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 69) begin : n69
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron69_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 70) begin : n70
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron70_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 71) begin : n71
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron71_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 72) begin : n72
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron72_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 73) begin : n73
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron73_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 74) begin : n74
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron74_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 75) begin : n75
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron75_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 76) begin : n76
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron76_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 77) begin : n77
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron77_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 78) begin : n78
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron78_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 79) begin : n79
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron79_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 80) begin : n80
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron80_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 81) begin : n81
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron81_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 82) begin : n82
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron82_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 83) begin : n83
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron83_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 84) begin : n84
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron84_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 85) begin : n85
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron85_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 86) begin : n86
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron86_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 87) begin : n87
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron87_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 88) begin : n88
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron88_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 89) begin : n89
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron89_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 90) begin : n90
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron90_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 91) begin : n91
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron91_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 92) begin : n92
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron92_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 93) begin : n93
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron93_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 94) begin : n94
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron94_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 95) begin : n95
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron95_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 96) begin : n96
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron96_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 97) begin : n97
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron97_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 98) begin : n98
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron98_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 99) begin : n99
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron99_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 100) begin : n100
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron100_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 101) begin : n101
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron101_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 102) begin : n102
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron102_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 103) begin : n103
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron103_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 104) begin : n104
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron104_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 105) begin : n105
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron105_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 106) begin : n106
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron106_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 107) begin : n107
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron107_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 108) begin : n108
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron108_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 109) begin : n109
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron109_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 110) begin : n110
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron110_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 111) begin : n111
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron111_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 112) begin : n112
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron112_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 113) begin : n113
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron113_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 114) begin : n114
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron114_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 115) begin : n115
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron115_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 116) begin : n116
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron116_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 117) begin : n117
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron117_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 118) begin : n118
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron118_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 119) begin : n119
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron119_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 120) begin : n120
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron120_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 121) begin : n121
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron121_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 122) begin : n122
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron122_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 123) begin : n123
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron123_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 124) begin : n124
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron124_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 125) begin : n125
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron125_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 126) begin : n126
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron126_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 127) begin : n127
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer0_neuron127_weights.txt")) u_n(
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
                else if (i == 16) begin : n16
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron16_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 17) begin : n17
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron17_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 18) begin : n18
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron18_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 19) begin : n19
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron19_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 20) begin : n20
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron20_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 21) begin : n21
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron21_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 22) begin : n22
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron22_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 23) begin : n23
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron23_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 24) begin : n24
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron24_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 25) begin : n25
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron25_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 26) begin : n26
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron26_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 27) begin : n27
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron27_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 28) begin : n28
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron28_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 29) begin : n29
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron29_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 30) begin : n30
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron30_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 31) begin : n31
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron31_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 32) begin : n32
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron32_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 33) begin : n33
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron33_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 34) begin : n34
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron34_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 35) begin : n35
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron35_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 36) begin : n36
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron36_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 37) begin : n37
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron37_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 38) begin : n38
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron38_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 39) begin : n39
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron39_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 40) begin : n40
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron40_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 41) begin : n41
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron41_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 42) begin : n42
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron42_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 43) begin : n43
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron43_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 44) begin : n44
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron44_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 45) begin : n45
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron45_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 46) begin : n46
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron46_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 47) begin : n47
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron47_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 48) begin : n48
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron48_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 49) begin : n49
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron49_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 50) begin : n50
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron50_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 51) begin : n51
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron51_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 52) begin : n52
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron52_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 53) begin : n53
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron53_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 54) begin : n54
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron54_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 55) begin : n55
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron55_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 56) begin : n56
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron56_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 57) begin : n57
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron57_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 58) begin : n58
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron58_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 59) begin : n59
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron59_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 60) begin : n60
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron60_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 61) begin : n61
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron61_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 62) begin : n62
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron62_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 63) begin : n63
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer1_neuron63_weights.txt")) u_n(
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
                else if (i == 16) begin : n16
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron16_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 17) begin : n17
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron17_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 18) begin : n18
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron18_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 19) begin : n19
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron19_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 20) begin : n20
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron20_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 21) begin : n21
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron21_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 22) begin : n22
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron22_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 23) begin : n23
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron23_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 24) begin : n24
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron24_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 25) begin : n25
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron25_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 26) begin : n26
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron26_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 27) begin : n27
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron27_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 28) begin : n28
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron28_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 29) begin : n29
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron29_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 30) begin : n30
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron30_weights.txt")) u_n(
                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));
                end
                else if (i == 31) begin : n31
                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/weights_and_biases/layer2_neuron31_weights.txt")) u_n(
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
