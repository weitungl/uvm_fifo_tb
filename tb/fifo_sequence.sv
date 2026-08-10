// Sequence 

//  Base Sequence
class fifo_base_sequence extends uvm_sequence #(fifo_transaction);
    `uvm_object_utils(fifo_base_sequence)

    function new(string name = "fifo_base_sequence");
        super.new(name);
    endfunction

    task write_data(input bit[DATA_WIDTH-1:0] data);
        req = fifo_transaction::type_id::create("req");
        start_item(req);
        if(!req.randomize() with {op == WRITE_ONLY; this.data == data;})
            `uvm_fatal("SEQ", "Randomization failed")
        finish_item(req);
    endtask

    task read_data();
        req = fifo_transaction::type_id::create("req");
        start_item(req);
        if(!req.randomize() with {op == READ_ONLY;})
            `uvm_fatal("SEQ", "Randomization failed")
        finish_item(req);
    endtask
endclass

// Sequence 1
class fifo_write_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_write_sequence)
    int num_trans = 50;

    function new(string name = "fifo_write_sequence");
        super.new(name);
    endfunction

    virtual task body();
        repeat(num_trans) begin
            write_data($urandom());
        end
    endtask
endclass

class fifo_read_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_read_sequence)
    int num_trans = 50;

    function new(string name = "fifo_read_sequence");
        super.new(name);
    endfunction

    virtual task body();
        repeat(num_trans) begin
            read_data();
        end
    endtask
endclass

// Sequence 2
class fifo_full_write_seq extends fifo_base_sequence;
    `uvm_object_utils(fifo_full_write_seq)
    int fifo_depth = 16;

    function new(string name = "fifo_full_write_seq");
        super.new(name);
    endfunction

    virtual task body();
        repeat(fifo_depth + 2) write_data($urandom());
    endtask
endclass

class fifo_empty_read_seq extends fifo_base_sequence;
    `uvm_object_utils(fifo_empty_read_seq)
    int fifo_depth = 16;

    function new(string name = "fifo_empty_read_seq");
        super.new(name);
    endfunction

    virtual task body();
        repeat(fifo_depth + 2) read_data();
    endtask
endclass

