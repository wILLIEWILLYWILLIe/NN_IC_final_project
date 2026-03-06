
`ifndef MY_UVM_PKG_SV
`define MY_UVM_PKG_SV

`timescale 1ns/10ps

package my_uvm_pkg;
    import uvm_pkg::*;
    import nn_pkg::*;
    `include "uvm_macros.svh"

    `include "my_uvm_globals.sv"
    `include "my_uvm_transaction.sv"
    `include "my_uvm_sequence.sv"
    `include "my_uvm_driver.sv"
    `include "my_uvm_monitor.sv"
    `include "my_uvm_scoreboard.sv"
    `include "my_uvm_agent.sv"
    `include "my_uvm_env.sv"
    `include "my_uvm_test.sv"

endpackage

`endif
