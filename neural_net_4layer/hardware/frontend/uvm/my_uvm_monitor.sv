
`ifndef MY_UVM_MONITOR_SV
`define MY_UVM_MONITOR_SV

class my_uvm_monitor extends uvm_monitor;
    `uvm_component_utils(my_uvm_monitor)

    virtual nn_if vif;
    uvm_analysis_port#(my_uvm_transaction) mon_ap;

    // Performance measurement
    int first_wr_cycle  = -1;
    int done_cycle      = -1;
    int cycle_count     = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual nn_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", $sformatf("virtual interface must be set for: %s.vif", get_full_name()))
        end
        mon_ap = new("mon_ap", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        my_uvm_transaction tr;

        // Track clock cycles
        fork
            forever begin
                @(posedge vif.clock);
                if (!vif.reset) cycle_count++;
                // Detect first write
                if (vif.wr_en && !vif.in_full && first_wr_cycle == -1)
                    first_wr_cycle = cycle_count;
            end
        join_none

        // Wait for inference_done
        forever begin
            @(posedge vif.clock);
            #1;
            if (vif.inference_done) begin
                done_cycle = cycle_count;
                tr = my_uvm_transaction::type_id::create("tr");
                tr.pixel_data = new[2];
                // Pack result into transaction: [0]=predicted_class, [1]=max_score
                tr.pixel_data[0] = vif.predicted_class;
                tr.pixel_data[1] = vif.max_score;

                `uvm_info("MON", $sformatf("Inference done! Predicted class: %0d, Max score: %0d",
                          vif.predicted_class, vif.max_score), UVM_LOW)
                mon_ap.write(tr);
            end
        end
    endtask

    virtual function void report_phase(uvm_phase phase);
        int latency;
        if (first_wr_cycle >= 0 && done_cycle >= 0) begin
            latency = done_cycle - first_wr_cycle;
            `uvm_info("MON", "--- PERFORMANCE SUMMARY ---", UVM_LOW)
            `uvm_info("MON", $sformatf("First Write Cycle:    %0d", first_wr_cycle), UVM_LOW)
            `uvm_info("MON", $sformatf("Inference Done Cycle: %0d", done_cycle), UVM_LOW)
            `uvm_info("MON", $sformatf("Total Latency:        %0d cycles", latency), UVM_LOW)
            `uvm_info("MON", $sformatf("@100MHz Inference:    %.2f us", real'(latency) * 0.01), UVM_LOW)
            `uvm_info("MON", "---------------------------", UVM_LOW)
        end
    endfunction

endclass

`endif
