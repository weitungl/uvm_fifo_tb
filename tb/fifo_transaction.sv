// Transaction
class fifo_transaction extends uvm_sequence_item;
    rand logic [DATA_WIDTH-1:0]     data;
    rand fifo_op_e                  op;
    rand int                        delay;

    logic                           full;
    logic                           empty;

    `uvm_object_utils(fifo_transaction)

    constraint c_delay {
        delay inside {[0:5]};
    }
    
    function new(string name = "fifo_transaction");
        super.new(name);
    endfunction
endclass