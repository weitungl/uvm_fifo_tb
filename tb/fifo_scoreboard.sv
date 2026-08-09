// Scoreboard - checks DUT correctness
class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)

    uvm_analysis_export #(fifo_transaction) write_export;
    uvm_analysis_export #(fifo_transaction) read_export;

    uvm_tlm_analysis_fifo #(fifo_transaction) write_fifo;
    uvm_tlm_analysis_fifo #(fifo_transaction) read_fifo;

    fifo_transaction ref_queue[$];

    int pass_count = 0;
    int fail_count = 0;

    function new(string name = "fifo_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    // build
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        write_export    = new("write_export", this);
        read_export     = new("read_export", this);
        write_fifo      = new("write_fifo", this);
        read_fifo       = new("read_fifo", this);
    endfunction
    // connect
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        write_export.connect(write_fifo.analysis_export);
        read_export.connect(read_fifo.analysis_export);
    endfunction

    virtual task run_phase(uvm_phase phase);
        fork 
            process_write();
            process_read();
        join
    endtask

    virtual task process_write();
        fifo_transaction w_tr;
        forever begin
            write_fifo.get(w_tr);
            ref_queue.push_back(w_tr);
            `uvm_info("SCB_WRITE", $sformatf("Push Data: 0x%0h | Current Queue Depth: %0d", 
                                              w_tr.data, ref_queue.size()), UVM_HIGH)
        end
    endtask

    virtual task process_read();
        fifo_transaction r_tr;
        fifo_transaction exp_tr;

        forever begin
            read_fifo.get(r_tr);

            if(ref_queue.size() == 0) begin
                `uvm_error("SCB_UNDERFLOW", "READ transaction detected, but Reference Queue is Empty")
                fail_count ++;
            end else begin
                exp_tr = ref_queue.pop_front();

                if(exp_tr.data == r_tr.data) begin
                    pass_count ++;
                    `uvm_info("SCB_MATCH", $sformatf("Data Match! Exp: 0x%0h, Act: 0x%0h", 
                                              exp_tr.data, r_tr.data), UVM_LOW)
                end else begin
                    fail_count ++;
                    `uvm_error("SCB_MISMATCH", $sformatf("Data Mismatch! Exp: 0x%0h, Act: 0x%0h", 
                                              exp_tr.data, r_tr.data))
                end
            end
        end
    endtask

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SCB_SUMMARY", "----------------------------------------", UVM_NONE)
        `uvm_info("SCB_SUMMARY", $sformatf("  TOTAL MATCHES   : %0d", pass_count), UVM_NONE)
        `uvm_info("SCB_SUMMARY", $sformatf("  TOTAL MISMATCHES: %0d", fail_count), UVM_NONE)
        `uvm_info("SCB_SUMMARY", $sformatf("  REMAINING QUEUE : %0d", ref_queue.size()), UVM_NONE)
        `uvm_info("SCB_SUMMARY", "----------------------------------------", UVM_NONE)

        if (fail_count == 0) begin
            `uvm_info("SCB_RESULT", ">>> TEST PASSED <<<", UVM_NONE)
        end else begin
            `uvm_error("SCB_RESULT", ">>> TEST FAILED WITH MISMATCHES! <<<")
        end
    endfunction
endclass