
`timescale 1ns/10ps

`include "uvm_macros.svh"
import uvm_pkg::*;
import my_uvm_pkg::*;

module my_uvm_tb;

    logic clock;
    logic reset;

    initial begin
        clock = 0;
        forever #5 clock = ~clock;  // 100 MHz
    end

    // Active-high reset: assert then deassert
    initial begin
        reset = 1;   // Assert reset
        #100;
        reset = 0;   // Deassert reset
    end

    // Interface
    nn_if vif(clock, reset);

    // DUT
    nn_top dut (
        .clk             (vif.clock),
        .reset           (vif.reset),

        .wr_en           (vif.wr_en),
        .din             (vif.din),
        .in_full         (vif.in_full),

        .inference_done  (vif.inference_done),
        .predicted_class (vif.predicted_class),
        .max_score       (vif.max_score)
    );

    // Removed parallel layer outputs (lX_relu) to interface - no longer exist in TDM architecture

    initial begin
        uvm_config_db#(virtual nn_if)::set(uvm_root::get(), "*", "vif", vif);
        run_test("my_uvm_test");
    end

endmodule
