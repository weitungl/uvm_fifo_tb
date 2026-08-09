// Agent - unit for sequencer, read_driver, read_monitor
class fifo_read_agent extends uvm_agent;
    `uvm_component_utils(fifo_read_agent)

    fifo_sequencer      sqr;
    fifo_read_driver    drv;
    fifo_read_monitor   mon;

    function new(string name = "fifo_read_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        mon = fifo_read_monitor::type_id::create("mon", this);

        if(get_is_active() == UVM_ACTIVE) begin
            sqr = fifo_sequencer::type_id::create("sqr", this);
            drv = fifo_read_driver::type_id::create("drv", this);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if(get_is_active() == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        end
    endfunction

endclass
