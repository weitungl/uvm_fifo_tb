// Driver - drives transaction onto the DUT (write)
class fifo_write_driver extends uvm_driver #(fifo_transaction);
    `uvm_component_utils(fifo_write_driver)

    virtual fifo_if vif;
    fifo_transaction tr;

    function new(string name = "fifo_write_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not found in write driver")
    endfunction

    virtual task run_phase(uvm_phase phase);
        vif.w_drv_cb.w_en <= 1'b0;
        vif.w_drv_cb.wdata <= '0;
        wait(vif.rst_n == 1'b1);
        @(vif.w_drv_cb);

        forever begin
            seq_item_port.get_next_item(tr);

            if(tr.op == WRITE_ONLY || tr.op == WRITE_READ) begin
                repeat (tr.delay) @(vif.w_drv_cb);

                vif.w_drv_cb.w_en       <= 1'b1;
                vif.w_drv_cb.wdata      <= tr.data;

                @(vif.w_drv_cb);
                vif.w_drv_cb.w_en       <= 1'b0;
            end
            seq_item_port.item_done();
        end
    endtask

endclass