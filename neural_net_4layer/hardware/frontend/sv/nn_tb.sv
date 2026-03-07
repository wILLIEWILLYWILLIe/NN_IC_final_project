// =============================================================
// Neural Network Direct Testbench
// =============================================================
// 1. Reads 784 hex inputs from x_test.txt
// 2. Writes them into the DUT input FIFO
// 3. Waits for inference_done
// 4. Compares predicted_class with y_test.txt
// 5. Reports DUT cycle count (FSM active cycles)
// =============================================================
`timescale 1ns/1ps

module nn_tb;
    import nn_pkg::*;

    // ---------------------------------------------------------
    // File paths (relative to sim working directory)
    // ---------------------------------------------------------
    localparam string INPUT_FILE = "../../../source/x_test.txt";
    localparam string LABEL_FILE = "../../../source/y_test.txt";

    // ---------------------------------------------------------
    // Clock & Reset
    // ---------------------------------------------------------
    logic clk = 0;
    always #5 clk = ~clk;  // 100 MHz (10 ns period)

    logic reset;

    // ---------------------------------------------------------
    // DUT signals
    // ---------------------------------------------------------
    logic                          wr_en;
    logic signed [DATA_WIDTH-1:0]  din;
    logic                          in_full;
    logic                          inference_done;
    logic [3:0]                    predicted_class;
    logic signed [DATA_WIDTH-1:0]  max_score;

    // ---------------------------------------------------------
    // DUT
    // ---------------------------------------------------------
    nn_top u_dut (
        .clk             (clk),
        .reset           (reset),
        .wr_en           (wr_en),
        .din             (din),
        .in_full         (in_full),
        .inference_done  (inference_done),
        .predicted_class (predicted_class),
        .max_score       (max_score)
    );

    // ---------------------------------------------------------
    // Input Data
    // ---------------------------------------------------------
    logic [DATA_WIDTH-1:0] input_data [0:NUM_INPUTS-1];
    initial $readmemh(INPUT_FILE, input_data);

    // True label
    integer true_label;
    integer f_label;
    initial begin
        f_label = $fopen(LABEL_FILE, "r");
        if (f_label) begin
            void'($fscanf(f_label, "%d", true_label));
            $fclose(f_label);
        end else begin
            $display("WARNING: Could not open %s, defaulting to -1", LABEL_FILE);
            true_label = -1;
        end
    end

    // ---------------------------------------------------------
    // Cycle counter — Simplified for GLS (no hierarchical refs)
    // ---------------------------------------------------------
    integer cycle_cnt;
    logic   counting;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            cycle_cnt <= 0;
            counting <= 0;
        end else begin
            if (wr_en) counting <= 1;
            if (inference_done) counting <= 0;
            
            if (counting && !inference_done)
                cycle_cnt <= cycle_cnt + 1;
        end
    end

    // Total sim cycle counter (from reset release)
    integer total_cycles;
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            total_cycles <= 0;
        else
            total_cycles <= total_cycles + 1;
    end

    // ---------------------------------------------------------
    // Test procedure
    // ---------------------------------------------------------
    initial begin
        // Reset
        reset = 1'b1;
        wr_en = 1'b0;
        din   = '0;
        repeat (50) @(posedge clk); // Extended reset for GLS
        reset = 1'b0;
        repeat (10) @(posedge clk);

        $display("============================================");
        $display("Neural Network Testbench");
        $display("============================================");
        $display("Loading %0d inputs from %s", NUM_INPUTS, INPUT_FILE);

        // Force wr_clk if it was optimized away/unconnected in netlist
        force u_dut.u_input_fifo.wr_clk = clk;
        force u_dut.u_input_fifo.rd_clk = clk;

        // Monitor inputs/outputs
        fork
            forever @(posedge clk) begin
                if (wr_en) $display("[%0t] DEBUG: wr_en=1, din=%0h, in_full=%b", $time, din, in_full);
                if (u_dut.fifo_empty === 1'b0) $display("[%0t] DEBUG: FIFO NOT EMPTY", $time);
                if (u_dut.n_471219) $display("[%0t] DEBUG: FIFO rd_en=1, dout=%0h", $time, u_dut.fifo_dout);
                if (inference_done) $display("[%0t] DEBUG: inference_done asserted!", $time);
            end
        join_none

        // Write all input data into FIFO
        for (int i = 0; i < NUM_INPUTS; i++) begin
            while (in_full) @(posedge clk);
            wr_en <= 1'b1;
            din   <= $signed(input_data[i]);
            @(posedge clk);
        end
        @(posedge clk);
        wr_en <= 1'b0;
        din   <= '0;

        $display("All inputs written to FIFO.");

        // Wait for inference to complete
        $display("Waiting for inference...");
        wait (inference_done === 1'b1);
        @(posedge clk);

        $display("");
        $display("============================================");
        $display("RESULTS");
        $display("============================================");
        $display("Predicted Class  : %0d", predicted_class);
        $display("True Label       : %0d", true_label);
        $display("Max Score        : %0d (0x%08h)", max_score, max_score);
        $display("--------------------------------------------");
        // Internal layer signals removed for NPU architecture
        $display("DUT FSM Cycles   : %0d", cycle_cnt);
        $display("  Layer 0 (MAC)  : ~%0d cycles (784 MACs + overhead)", LAYER0_IN);
        $display("  Layer 1 (MAC)  : ~%0d cycles (128 MACs + overhead)", LAYER1_IN);
        $display("  Layer 2 (MAC)  : ~%0d cycles (64 MACs + overhead)", LAYER2_IN);
        $display("  Layer 3 (MAC)  : ~%0d cycles (32 MACs + overhead)", LAYER3_IN);
        $display("Total Sim Cycles : %0d (from reset release)", total_cycles);
        $display("Sim Time         : %0t", $time);
        $display("");

        if (predicted_class == true_label[3:0]) begin
            $display("*** TEST PASSED ***");
        end else begin
            $display("*** TEST FAILED ***");
            $display("Expected: %0d, Got: %0d", true_label, predicted_class);
        end
        $display("============================================");

        #100;
        $finish;
    end

    // Timeout watchdog
    initial begin
        #10_000_000;  // 10 ms = 1M cycles
        $display("ERROR: Simulation timeout!");
        $finish;
    end

endmodule
