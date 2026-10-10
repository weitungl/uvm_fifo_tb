// Coverage Check
class fifo_coverage extends uvm_subscriber #(fifo_transaction);
    `uvm_component_utils(fifo_coverage)

    fifo_transaction tr;

    virtual fifo_if vif;

    // Stimulus Coverage (from driver)
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

    covergroup fifo_behavior_cg;
        option.per_instance = 1;

        cp_status: coverpoint {vif.full, vif.empty} iff(vif.rst_n){
            bins empty = {2'b01};
            bins full = {2'b10};
            bins partial = {2'b00};
            
            illegal_bins invalid = {2'b11};
        }

        cp_operation: coverpoint {vif.w_en, vif.r_en} iff(vif.rst_n){
            bins idle = {2'b00};
            bins write = {2'b10};
            bins read = {2'b01};
            bins simultaneously = {2'b11};
        }
        cross_status_op: cross cp_status, cp_operation;
    endgroup

    function new(string name = "fifo_coverage", uvm_component parent = null);
        super.new(name, parent);
        fifo_cg = new();
        fifo_behavior_cg = new();
    endfunction 

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not found in coverage")
    endfunction

    virtual function void write(fifo_transaction t);
        this.tr = t;
        fifo_cg.sample();
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.clk);
            if(vif.rst_n)
                fifo_behavior_cg.sample();
        end
    endtask

endclass