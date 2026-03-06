// =============================================================
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
