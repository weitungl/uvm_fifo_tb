// Bad Transaction
class fifo_corrupt_transaction extends fifo_transaction;
    `uvm_object_utils(fifo_corrupt_transaction)

    constraint c_corrupt_data {
        data == 32'hDEAD_BEEF;
    }

    constraint c_max_delay {
        delay == 5;
    }

    function new(string name = "fifo_corrupt_transaction");
        super.new(name);
    endfunction

endclass