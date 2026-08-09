// Monitor - observes DUT outputs and sends to scoreboard (read)
class fifo_read_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_read_monitor)

    virtual fifo_if vif;
    uvm_analysis_port #(fifo_transaction) analysis_port;

    function new(string name = "fifo_read_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not found in read monitor")
        analysis_port = new("analysis_port", this);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        fifo_transaction tr;

        wait(vif.rst_n);
        @(vif.r_mon_cb);

        forever begin
            @(vif.r_mon_cb);

            if(vif.r_mon_cb.r_en && !vif.r_mon_cb.empty) begin
                tr = fifo_transaction::type_id::create("tr");
                tr.op   = READ_ONLY;
                tr.data = vif.r_mon_cb.rdata;

                analysis_port.write(tr); 
            end
        end
    endtask


endclass