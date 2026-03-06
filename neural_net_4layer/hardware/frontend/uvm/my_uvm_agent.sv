
`ifndef MY_UVM_AGENT_SV
`define MY_UVM_AGENT_SV

class my_uvm_agent extends uvm_agent;
    `uvm_component_utils(my_uvm_agent)

    uvm_sequencer#(my_uvm_transaction) sequencer;
    my_uvm_driver    driver;
    my_uvm_monitor   monitor;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = uvm_sequencer#(my_uvm_transaction)::type_id::create("sequencer", this);
        driver    = my_uvm_driver::type_id::create("driver", this);
        monitor   = my_uvm_monitor::type_id::create("monitor", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass

`endif
