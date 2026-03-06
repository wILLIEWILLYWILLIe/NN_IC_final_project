
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

    // Pass internal layer outputs to interface for coverage
    always_comb begin
        for (int i = 0; i < 128; i++) vif.l0_relu[i] = dut.l0_relu[i];
        for (int i = 0; i < 64; i++)  vif.l1_relu[i] = dut.l1_relu[i];
        for (int i = 0; i < 32; i++)  vif.l2_relu[i] = dut.l2_relu[i];
        for (int i = 0; i < 10; i++)  vif.l3_relu[i] = dut.l3_relu[i];
    end

    initial begin
        uvm_config_db#(virtual nn_if)::set(uvm_root::get(), "*", "vif", vif);
        run_test("my_uvm_test");
    end

endmodule
