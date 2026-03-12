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

    `ifdef POST_ROUTE
    initial begin
        $sdf_annotate("../../backend/innovus/nn_top_final.sdf", u_dut);
        $display("SDF Annotation Applied (Post-Route)");
    end
    `endif

    `ifdef POST_ROUTE
    initial begin
        $display("======= GLS DEBUG TRACKING =======");
        $monitor("Time=%0t RN=%b CK=%b Q=%b NOTIFIER=%b \nstate=%b%b%b%b mac_valid_out0=%b", 
            $time, 
            u_dut.\gen_mac_lanes[0].u_lane_u_mac .FE_OFN124_FE_DBTN52_reset,
            u_dut.\gen_mac_lanes[0].u_lane_u_mac .clk_clone17,
            u_dut.\gen_mac_lanes[0].u_lane_u_mac .valid_out_reg.Q,
            u_dut.\gen_mac_lanes[0].u_lane_u_mac .valid_out_reg.NOTIFIER,
            u_dut.state[3], u_dut.state[2], u_dut.state[1], u_dut.state[0],
            u_dut.FE_OFN1166_mac_valid_out_0
            );
    end
    `endif

    // Dump waveforms
    // initial begin
    //     $shm_open("waves.shm");
    //     $shm_probe("AC");
    // end

    // GLS Debug: trace key signals to find x-propagation source
    `ifndef POST_ROUTE
    initial begin
        $timeformat(-9, 0, "ns", 10);
        $monitor("T=%0t rst=%b wr_en=%b fifo_empty=%b in_full=%b inf_done=%b state=%b",
            $time, reset, wr_en, u_dut.fifo_empty, in_full, inference_done,
            u_dut.state);
    end
    `endif

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
        #2; // Deassert reset slightly after the clock edge to avoid Recovery/Removal violations
        reset = 1'b0;
        repeat (10) @(posedge clk);

        $display("============================================");
        $display("Neural Network Testbench");
        $display("============================================");
        $display("Loading %0d inputs from %s", NUM_INPUTS, INPUT_FILE);

        // FIFO clock forcing removed — FIFO now uses single clk port
        // (no separate wr_clk/rd_clk needed)

        // Monitor inputs/outputs
        fork
            // Periodic progress monitor (every 100us / 10000 cycles)
            forever begin
                #100_000; // 100us
                $display("[%0t] PROGRESS: wr_en=%b, in_full=%b, inference_done=%b",
                         $time, wr_en, in_full, inference_done);
                $display("[%0t] PROGRESS: u_dut.fifo_empty=%b", $time, u_dut.fifo_empty);
            end
        join_none

        fork
            forever @(posedge clk) begin
                if (inference_done) $display("[%0t] DEBUG: inference_done asserted!", $time);
            end
        join_none

        // Write all input data into FIFO
        begin
            integer full_stall_cnt;
            full_stall_cnt = 0;
            for (int i = 0; i < NUM_INPUTS; i++) begin
                while (in_full) begin
                    full_stall_cnt++;
                    @(posedge clk);
                end
                wr_en <= 1'b1;
                din   <= $signed(input_data[i]);
                @(posedge clk);
                if (i % 100 == 0)
                    $display("[%0t] WRITE: item %0d/%0d, full_stalls=%0d, fifo_empty=%b",
                             $time, i, NUM_INPUTS, full_stall_cnt, u_dut.fifo_empty);
            end
            @(posedge clk);
            wr_en <= 1'b0;
            din   <= '0;
            $display("[%0t] All inputs written to FIFO. Total full_stalls=%0d", $time, full_stall_cnt);
        end

        // Wait for inference to complete
        $display("[%0t] Waiting for inference... fifo_empty=%b", $time, u_dut.fifo_empty);
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
        #50_000_000;  // 50 ms = 5M cycles (extended for GLS)
        $display("ERROR: Simulation timeout!");
        $finish;
    end

endmodule
