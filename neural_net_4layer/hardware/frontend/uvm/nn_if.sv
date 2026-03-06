
`ifndef NN_IF_SV
`define NN_IF_SV

interface nn_if(input logic clock, input logic reset);
    import nn_pkg::*;

    // Input FIFO write interface
    logic                          wr_en;
    logic signed [DATA_WIDTH-1:0]  din;
    logic                          in_full;

    // Output interface
    logic                          inference_done;
    logic [3:0]                    predicted_class;
    logic signed [DATA_WIDTH-1:0]  max_score;

    // Internal layer outputs for functional coverage
    logic signed [DATA_WIDTH-1:0]  l0_relu [128];
    logic signed [DATA_WIDTH-1:0]  l1_relu [64];
    logic signed [DATA_WIDTH-1:0]  l2_relu [32];
    logic signed [DATA_WIDTH-1:0]  l3_relu [10];

    modport driver (
        input  clock, reset,
        output wr_en, din,
        input  in_full
    );

    modport monitor (
        input  clock, reset,
        input  wr_en, din, in_full,
        input  inference_done, predicted_class, max_score
    );

endinterface

`endif
