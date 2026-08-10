// Driver - drives transaction onto the DUT (read)
class fifo_read_driver extends uvm_driver #(fifo_transaction);
    `uvm_component_utils(fifo_read_driver)

    virtual fifo_if  vif;
    fifo_transaction tr;
    uvm_analysis_port #(fifo_transaction) drv_ap;

    function new(string name = "fifo_read_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not found in read driver")
        drv_ap = new("drv_ap", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        vif.r_drv_cb.r_en <= 1'b0;

        wait(vif.rst_n);
        @(vif.r_drv_cb);

        forever begin
            seq_item_port.get_next_item(tr);

            drv_ap.write(tr);

            if(tr.op == READ_ONLY || tr.op == WRITE_READ) begin
                repeat(tr.delay) @(vif.r_drv_cb);
                
                vif.r_drv_cb.r_en   <= 1'b1;

                @(vif.r_drv_cb);
                vif.r_drv_cb.r_en   <= 1'b0;
            end
            seq_item_port.item_done();
        end
    endtask

endclass