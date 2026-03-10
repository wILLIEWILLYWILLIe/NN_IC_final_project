// =============================================================
// Neural Network Batch Testbench — All 10 MNIST Classes
// =============================================================
// Runs ALL 10 digit classes (0-9) in ONE continuous simulation.
// The waveform shows all 10 inferences back-to-back.
// =============================================================
`timescale 1ns/1ps

module nn_tb_all;
    import nn_pkg::*;

    localparam int NUM_CLASSES = 10;

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
    // Marker signal for waveform: current class being tested
    // ---------------------------------------------------------
    integer current_class;

    // ---------------------------------------------------------
    // Results tracking
    // ---------------------------------------------------------
    integer pass_count = 0;
    integer fail_count = 0;

    // ---------------------------------------------------------
    // Task: Run one inference for a given class
    // ---------------------------------------------------------
    task automatic run_one_class(
        input int class_id
    );
        string x_file, y_file;
        integer fd_x, fd_y;
        integer val, status;
        integer true_label;

        // Build file paths
        $sformat(x_file, "../../../source/test_samples/x_test_class%0d.txt", class_id);
        $sformat(y_file, "../../../source/test_samples/y_test_class%0d.txt", class_id);

        current_class = class_id;

        $display("");
        $display("=============================================");
        $display("  Testing Class %0d", class_id);
        $display("=============================================");

        // --- Read true label ---
        fd_y = $fopen(y_file, "r");
        if (fd_y == 0) begin
            $display("ERROR: Could not open %s", y_file);
            return;
        end
        void'($fscanf(fd_y, "%d", true_label));
        $fclose(fd_y);

        // --- Assert Reset ---
        reset = 1'b1;
        wr_en = 1'b0;
        din   = '0;
        repeat (20) @(posedge clk);
        #2;
        reset = 1'b0;
        repeat (5) @(posedge clk);

        // Force FIFO clocks (synthesis disconnects wr_clk)
        force u_dut.u_input_fifo.wr_clk = clk;
        force u_dut.u_input_fifo.rd_clk = clk;

        // --- Read and write input data from file ---
        fd_x = $fopen(x_file, "r");
        if (fd_x == 0) begin
            $display("ERROR: Could not open %s", x_file);
            return;
        end

        for (int i = 0; i < NUM_INPUTS; i++) begin
            status = $fscanf(fd_x, "%h", val);
            if (status != 1) begin
                $display("ERROR: Failed to read pixel %0d from %s", i, x_file);
                $fclose(fd_x);
                return;
            end
            while (in_full) @(posedge clk);
            wr_en <= 1'b1;
            din   <= $signed(val[DATA_WIDTH-1:0]);
            @(posedge clk);
        end
        wr_en <= 1'b0;
        din   <= '0;
        $fclose(fd_x);

        $display("[%0t] All %0d inputs written for class %0d. Waiting for inference...",
                 $time, NUM_INPUTS, class_id);

        // --- Wait for inference ---
        wait (inference_done === 1'b1);
        @(posedge clk);

        // --- Report result ---
        $display("  Predicted Class : %0d", predicted_class);
        $display("  True Label      : %0d", true_label);
        $display("  Max Score       : %0d (0x%08h)", max_score, max_score);

        if (predicted_class == true_label[3:0]) begin
            $display("  >>> PASSED <<<");
            pass_count = pass_count + 1;
        end else begin
            $display("  >>> FAILED <<< (Expected %0d, Got %0d)", true_label, predicted_class);
            fail_count = fail_count + 1;
        end

        // Small gap between tests for waveform readability
        repeat (10) @(posedge clk);

    endtask

    // ---------------------------------------------------------
    // Main test procedure
    // ---------------------------------------------------------
    initial begin
        reset = 1'b1;
        wr_en = 1'b0;
        din   = '0;
        current_class = -1;

        $display("==============================================");
        $display("  Neural Network Batch Testbench");
        $display("  Testing ALL %0d MNIST Classes", NUM_CLASSES);
        $display("==============================================");

        // Run all 10 classes sequentially
        for (int c = 0; c < NUM_CLASSES; c++) begin
            run_one_class(c);
        end

        // Final summary
        $display("");
        $display("==============================================");
        $display("  BATCH SIMULATION COMPLETE");
        $display("==============================================");
        $display("  Total : %0d", NUM_CLASSES);
        $display("  Passed: %0d", pass_count);
        $display("  Failed: %0d", fail_count);
        if (fail_count == 0)
            $display("  *** ALL TESTS PASSED ***");
        else
            $display("  *** SOME TESTS FAILED ***");
        $display("==============================================");

        #100;
        $finish;
    end

    // Timeout watchdog (generous for 10 inferences)
    initial begin
        #100_000_000;  // 100 ms
        $display("ERROR: Simulation timeout!");
        $finish;
    end

endmodule
