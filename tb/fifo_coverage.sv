// Coverage Check
class fifo_coverage extends uvm_subscriber #(fifo_transaction);
    `uvm_component_utils(fifo_coverage)

    fifo_transaction tr;

    covergroup fifo_cg;
        option.per_instance = 1;    // Show the coverage of each instance

        cp_op: coverpoint tr.op {
            bins write_op       = {WRITE_ONLY};
            bins read_op        = {READ_ONLY};
        }

        cp_delay: coverpoint tr.delay{
            bins zero_delay     = {0};
            bins short_delay    = {[1:2]};
            bins long_delay     = {[3:5]};
        }
        cross_op_delay: cross cp_op, cp_delay;
    endgroup

    function new(string name = "fifo_coverage", uvm_component parent = null);
        super.new(name, parent);
        fifo_cg = new();
    endfunction 

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    virtual function void write(fifo_transaction t);
        this.tr = t;
        fifo_cg.sample();
    endfunction

endclass