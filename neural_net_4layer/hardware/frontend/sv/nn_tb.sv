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
    // Cycle counter — counts every clk while DUT FSM is active
    // (i.e., from FIFO_PREFETCH to DONE, not IDLE)
    // ---------------------------------------------------------
    integer cycle_cnt;
    logic   dut_active;

    assign dut_active = (u_dut.state != u_dut.S_IDLE);

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            cycle_cnt <= 0;
        else if (dut_active)
            cycle_cnt <= cycle_cnt + 1;
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
        repeat (10) @(posedge clk);
        reset = 1'b0;
        repeat (5) @(posedge clk);

        $display("============================================");
        $display("Neural Network Testbench");
        $display("============================================");
        $display("Loading %0d inputs from %s", NUM_INPUTS, INPUT_FILE);

        // Write all input data into FIFO
        for (int i = 0; i < NUM_INPUTS; i++) begin
            @(posedge clk);
            while (in_full) @(posedge clk);
            wr_en <= 1'b1;
            din   <= $signed(input_data[i]);
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
        $display("DEBUG Layer 0 out: [%0d, %0d, %0d...]", u_dut.l0_result[0], u_dut.l0_result[1], u_dut.l0_result[2]);
        $display("DEBUG Layer 1 out: [%0d, %0d, %0d...]", u_dut.l1_result[0], u_dut.l1_result[1], u_dut.l1_result[2]);
        $display("DEBUG Layer 2 out: [%0d, %0d, %0d...]", u_dut.l2_result[0], u_dut.l2_result[1], u_dut.l2_result[2]);
        $display("DEBUG Layer 3 out: [%0d, %0d, %0d...]", u_dut.l3_result[0], u_dut.l3_result[1], u_dut.l3_result[2]);
        $display("Output Probabilities Output (Layer 3):");
        for (int i=0; i<10; i++)
             $display("  Class %0d: %0d", i, u_dut.l3_result[i]);
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
