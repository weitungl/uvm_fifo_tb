// Agent - unit for sequencer, write_driver, write_monitor
class fifo_write_agent extends uvm_agent;
    `uvm_component_utils(fifo_write_agent)

    fifo_sequencer          sqr;
    fifo_write_driver       drv;
    fifo_write_monitor      mon;

    function new(string name = "fifo_write_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon = fifo_write_monitor::type_id::create("mon", this);

        if(get_is_active() == UVM_ACTIVE) begin
            drv = fifo_write_driver::type_id::create("drv", this);
            sqr = fifo_sequencer::type_id::create("sqr", this);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if(get_is_active() == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        end
    endfunction

endclass