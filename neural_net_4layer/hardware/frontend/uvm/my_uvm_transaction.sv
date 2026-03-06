
`ifndef MY_UVM_TRANSACTION_SV
`define MY_UVM_TRANSACTION_SV

class my_uvm_transaction extends uvm_sequence_item;

    rand int pixel_data[];      // 784 input pixel values

    `uvm_object_utils_begin(my_uvm_transaction)
        `uvm_field_array_int(pixel_data, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "my_uvm_transaction");
        super.new(name);
    endfunction

endclass

`endif
