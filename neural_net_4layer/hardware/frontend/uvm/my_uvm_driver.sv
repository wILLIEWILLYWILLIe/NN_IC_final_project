
`ifndef MY_UVM_DRIVER_SV
`define MY_UVM_DRIVER_SV

class my_uvm_driver extends uvm_driver#(my_uvm_transaction);
    `uvm_component_utils(my_uvm_driver)

    virtual nn_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual nn_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", $sformatf("virtual interface must be set for: %s.vif", get_full_name()))
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        vif.wr_en <= 0;
        vif.din   <= 0;

        `uvm_info("DRV", "Waiting for reset deassertion", UVM_LOW)
        wait(vif.reset === 1);
        @(posedge vif.clock);
        wait(vif.reset === 0);
        `uvm_info("DRV", "Reset deasserted, starting drive loop", UVM_LOW)
        repeat(5) @(posedge vif.clock);

        forever begin
            seq_item_port.get_next_item(req);
            drive_pixels(req);
            seq_item_port.item_done();
        end
    endtask

    task drive_pixels(my_uvm_transaction tr);
        int len = tr.pixel_data.size();
        `uvm_info("DRV", $sformatf("Driving %0d pixels into FIFO", len), UVM_LOW)
        for (int i = 0; i < len; i++) begin
            while (vif.in_full) @(posedge vif.clock);
            @(negedge vif.clock);
            vif.wr_en <= 1;
            vif.din   <= tr.pixel_data[i][NN_DATA_WIDTH-1:0];
            @(posedge vif.clock);
            #1;
            vif.wr_en <= 0;
        end
        `uvm_info("DRV", "All pixels driven", UVM_LOW)
    endtask

endclass

`endif
