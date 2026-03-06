
`ifndef MY_UVM_GLOBALS_SV
`define MY_UVM_GLOBALS_SV

parameter string REF_INPUT_FILE  = "../../../source/x_test.txt";
parameter string REF_LABEL_FILE  = "../../../source/y_test.txt";

parameter int NN_NUM_INPUTS  = nn_pkg::NUM_INPUTS;     // 784
parameter int NN_NUM_OUTPUTS = nn_pkg::NUM_OUTPUTS;     // 10
parameter int NN_DATA_WIDTH  = nn_pkg::DATA_WIDTH;      // 32

`endif
