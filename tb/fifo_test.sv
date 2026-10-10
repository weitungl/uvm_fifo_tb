// Test
class fifo_base_test extends uvm_test;
    `uvm_component_utils(fifo_base_test)
    fifo_env env;

    virtual fifo_if vif;

    function new(string name = "fifo_base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = fifo_env::type_id::create("env", this);
        
        if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not found in test")
    endfunction
endclass

// Test1: rand test
class fifo_rand_test extends fifo_base_test;
    `uvm_component_utils(fifo_rand_test)

    function new(string name = "fifo_rand_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        fifo_write_sequence w_seq = fifo_write_sequence::type_id::create("w_seq");
        fifo_read_sequence  r_seq = fifo_read_sequence::type_id::create("r_seq");

        phase.raise_objection(this);
        wait(vif.rst_n == 1'b1);
        `uvm_info("TEST", "Running Test1: Random Sequence", UVM_LOW)

        w_seq.num_trans = 200;
        r_seq.num_trans = 200;

        fork
            w_seq.start(env.w_agent.sqr);
            r_seq.start(env.r_agent.sqr);
        join

        #100ns;
        phase.drop_objection(this);
    endtask
endclass

// Test2: full_empty test
class fifo_full_empty_test extends fifo_base_test;
    `uvm_component_utils(fifo_full_empty_test)

    function new(string name = "fifo_full_empty_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        fifo_full_write_seq w_full  = fifo_full_write_seq::type_id::create("w_full");
        fifo_empty_read_seq r_empty = fifo_empty_read_seq::type_id::create("r_empty");
        
        phase.raise_objection(this);
        wait(vif.rst_n == 1'b1);
        `uvm_info("TEST", "Running Test2: Full/Empty Boundary Sequence", UVM_LOW)

        w_full.start(env.w_agent.sqr);

        r_empty.start(env.r_agent.sqr);
        #100ns;
        phase.drop_objection(this);
    endtask
endclass


// Test 3: Try corrupt transaction
class fifo_override_test extends fifo_rand_test;
    `uvm_component_utils(fifo_override_test)

    function new(string name = "fifo_override_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        fifo_transaction::type_id::set_type_override(fifo_corrupt_transaction::get_type());
        super.build_phase(phase);
    endfunction

endclass

// Test 4: reset test
class fifo_reset_test extends fifo_base_test;
    `uvm_component_utils(fifo_reset_test)

    function new(string name = "fifo_reset_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        fifo_write_sequence w_seq = fifo_write_sequence::type_id::create("w_seq");
        fifo_read_sequence  r_seq = fifo_read_sequence::type_id::create("r_seq");

        phase.raise_objection(this);
        wait(vif.rst_n == 1'b1);
        `uvm_info("TEST", "Running Test4: Reset", UVM_LOW)

        w_seq.num_trans = 5;
        w_seq.start(env.w_agent.sqr);

        vif.trigger_reset(2);

        w_seq.num_trans = 100;
        r_seq.num_trans = 100;

        fork
            w_seq.start(env.w_agent.sqr);
            r_seq.start(env.r_agent.sqr);
        join

        #100ns;
        phase.drop_objection(this);
    endtask

endclass

// Test 5: check when the fifo is full and simultaneously write and read
class fifo_full_simultaneous_test extends fifo_base_test;
    `uvm_component_utils(fifo_full_simultaneous_test)

    function new(string name = "fifo_full_simultaneous_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        fifo_full_write_seq w_full;
        fifo_no_delay_write_seq w_seq;
        fifo_no_delay_read_seq r_seq;

        w_full = fifo_full_write_seq::type_id::create("w_full");
        w_seq  = fifo_no_delay_write_seq::type_id::create("w_seq");
        r_seq  = fifo_no_delay_read_seq::type_id::create("r_seq");

        phase.raise_objection(this);
        wait(vif.rst_n === 1'b1);

        // Step 1: Fill FIFO
        w_full.start(env.w_agent.sqr);

        // Step 2: Confirm FIFO is full
        wait(vif.full === 1'b1);

        // Step 3: Simultaneous Write / Read
        fork
            w_seq.start(env.w_agent.sqr);
            r_seq.start(env.r_agent.sqr);
        join

        #100ns;
        phase.drop_objection(this);
    endtask
endclass