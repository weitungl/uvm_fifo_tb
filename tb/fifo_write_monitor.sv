// Monitor - observes DUT outputs and sends to scoreboard (write)
class fifo_write_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_write_monitor)

    virtual fifo_if vif;
    uvm_analysis_port #(fifo_transaction) analysis_port;

    function new(string name = "fifo_write_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not found in write monitor")
        analysis_port = new("analysis_port", this);
    endfunction

    virtual task run_phase(uvm_phase phase);    
        fifo_transaction tr;
        
        wait(vif.rst_n);
        @(vif.w_mon_cb);

        forever begin
            @(vif.w_mon_cb);

            if(vif.w_mon_cb.w_en && !vif.w_mon_cb.full) begin
                tr = fifo_transaction::type_id::create("tr");
                tr.op = WRITE_ONLY;
                tr.data = vif.w_mon_cb.wdata;

                analysis_port.write(tr);
            end 
        end
    endtask

endclass