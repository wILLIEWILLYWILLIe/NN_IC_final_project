
`ifndef MY_UVM_ENV_SV
`define MY_UVM_ENV_SV

class my_uvm_env extends uvm_env;
    `uvm_component_utils(my_uvm_env)

    my_uvm_agent      agent;
    my_uvm_scoreboard  scoreboard;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent      = my_uvm_agent::type_id::create("agent", this);
        scoreboard = my_uvm_scoreboard::type_id::create("scoreboard", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        agent.monitor.mon_ap.connect(scoreboard.sb_export);
    endfunction
endclass

`endif
