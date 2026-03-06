
`ifndef MY_UVM_SCOREBOARD_SV
`define MY_UVM_SCOREBOARD_SV

class my_uvm_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(my_uvm_scoreboard)

    uvm_analysis_imp #(my_uvm_transaction, my_uvm_scoreboard) sb_export;

    int expected_label;
    int error_count = 0;
    int test_count  = 0;

    // ---- Functional Coverage ----
    int cov_predicted;
    int cov_expected;
    logic cov_correct;

    // Predicted class coverage
    covergroup cg_prediction;
        option.per_instance = 1;

        predicted_class: coverpoint cov_predicted {
            bins digit[] = {[0:9]};
        }
        expected_class: coverpoint cov_expected {
            bins digit[] = {[0:9]};
        }
        correctness: coverpoint cov_correct {
            bins pass = {1};
            bins fail = {0};
        }
        pred_x_exp: cross predicted_class, expected_class;
    endgroup

    // Per-layer functional coverage (L0 to L3 output activations)
    logic signed [DATA_WIDTH-1:0] cov_l0_out;
    logic signed [DATA_WIDTH-1:0] cov_l1_out;
    logic signed [DATA_WIDTH-1:0] cov_l2_out;
    logic signed [DATA_WIDTH-1:0] cov_l3_out;
    virtual nn_if vif;

    covergroup cg_layer_activations;
        option.per_instance = 1;

        l0_activation: coverpoint cov_l0_out {
            bins zero     = {0};
            bins positive = {[1:$]};
        }
        l1_activation: coverpoint cov_l1_out {
            bins zero     = {0};
            bins positive = {[1:$]};
        }
        l2_activation: coverpoint cov_l2_out {
            bins zero     = {0};
            bins positive = {[1:$]};
        }
        l3_activation: coverpoint cov_l3_out {
            bins zero     = {0};
            bins positive = {[1:$]};
        }
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg_prediction = new();
        cg_layer_activations = new();
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export", this);
        if(!uvm_config_db#(virtual nn_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", $sformatf("virtual interface must be set for: %s.vif", get_full_name()))
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        int fd, status;
        super.connect_phase(phase);

        // Read expected label
        fd = $fopen(REF_LABEL_FILE, "r");
        if (fd == 0) begin
            `uvm_fatal("SCB", $sformatf("Could not open label file: %s", REF_LABEL_FILE))
        end
        status = $fscanf(fd, "%d", expected_label);
        if (status != 1) begin
            `uvm_fatal("SCB", "Failed to read expected label")
        end
        $fclose(fd);
        `uvm_info("SCB", $sformatf("Expected label (ground truth): %0d", expected_label), UVM_LOW)
    endfunction

    virtual function void write(my_uvm_transaction tr);
        int predicted = tr.pixel_data[0];
        int score     = tr.pixel_data[1];

        test_count++;

        // Prediction Coverage sampling
        cov_predicted = predicted;
        cov_expected  = expected_label;
        // Prediction Coverage sampling
        cov_predicted = predicted;
        cov_expected  = expected_label;
        cov_correct   = (predicted == expected_label);
        cg_prediction.sample();

        if (predicted == expected_label) begin
            `uvm_info("SCB", $sformatf("TEST PASSED! Predicted: %0d, Expected: %0d, Score: %0d",
                      predicted, expected_label, score), UVM_LOW)
        end else begin
            `uvm_error("SCB", $sformatf("TEST FAILED! Predicted: %0d, Expected: %0d, Score: %0d",
                       predicted, expected_label, score))
            error_count++;
        end
    endfunction

    virtual function void report_phase(uvm_phase phase);
        if (error_count == 0 && test_count > 0) begin
            `uvm_info("SCB", $sformatf("ALL %0d TESTS PASSED!", test_count), UVM_LOW)
        end else begin
            `uvm_error("SCB", $sformatf("%0d FAILURES out of %0d tests", error_count, test_count))
        end

        // Coverage report
        `uvm_info("SCB", $sformatf("Prediction Coverage: %.1f%%", cg_prediction.get_coverage()), UVM_LOW)
        `uvm_info("SCB", $sformatf("Layer Activations Coverage: %.1f%%", cg_layer_activations.get_coverage()), UVM_LOW)
    endfunction

endclass

`endif
