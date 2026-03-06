// =============================================================
// Neural Network Parameter Package (4-Layer)
// =============================================================
package nn_pkg;

    // --- Quantization ---
    parameter BITS       = 12;
    parameter QUANT_VAL  = (1 << BITS);

    // --- Data Width ---
    parameter DATA_WIDTH = 16;

    // --- Network Topology ---
    parameter NUM_LAYERS   = 4;
    parameter NUM_INPUTS   = 784;
    parameter NUM_OUTPUTS  = 10;

    // Layer sizes
    parameter LAYER0_IN  = 784;
    parameter LAYER0_OUT = 32;
    parameter LAYER1_IN  = 32;
    parameter LAYER1_OUT = 16;
    parameter LAYER2_IN  = 16;
    parameter LAYER2_OUT = 16;
    parameter LAYER3_IN  = 16;
    parameter LAYER3_OUT = 10;

    // --- FIFO ---
    parameter FIFO_DEPTH = 16;
    parameter DEBUG = 1;

    // --- Dequantize function with Saturation ---
    function automatic signed [DATA_WIDTH-1:0] dequantize;
        input signed [63:0] acc;
        logic signed [63:0] shifted;
        begin
            shifted = acc >>> BITS;
            if (shifted > 32767)       dequantize = 32767;
            else if (shifted < -32768) dequantize = -32768;
            else                       dequantize = shifted[DATA_WIDTH-1:0];
        end
    endfunction

endpackage
