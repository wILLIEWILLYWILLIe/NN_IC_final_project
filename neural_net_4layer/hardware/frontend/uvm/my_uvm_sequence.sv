
`ifndef MY_UVM_SEQUENCE_SV
`define MY_UVM_SEQUENCE_SV

class my_uvm_sequence extends uvm_sequence#(my_uvm_transaction);
    `uvm_object_utils(my_uvm_sequence)

    function new(string name = "my_uvm_sequence");
        super.new(name);
    endfunction

    virtual task body();
        int fd;
        int val, status;

        req = my_uvm_transaction::type_id::create("req");

        fd = $fopen(REF_INPUT_FILE, "r");
        if (fd == 0) begin
            `uvm_fatal("SEQ", $sformatf("Could not open input file: %s", REF_INPUT_FILE))
        end

        `uvm_info("SEQ", $sformatf("Reading %0d input pixels from %s", NN_NUM_INPUTS, REF_INPUT_FILE), UVM_LOW)

        start_item(req);
        req.pixel_data = new[NN_NUM_INPUTS];

        for (int i = 0; i < NN_NUM_INPUTS; i++) begin
            status = $fscanf(fd, "%h\n", val);
            if (status != 1) begin
                `uvm_fatal("SEQ", $sformatf("Failed to read input pixel %0d", i))
            end
            req.pixel_data[i] = val;
        end
        finish_item(req);

        $fclose(fd);
        `uvm_info("SEQ", "Sequence complete", UVM_LOW)
    endtask

endclass

`endif
