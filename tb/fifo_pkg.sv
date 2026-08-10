package fifo_pkg;

    `include "uvm_macros.svh"
    import uvm_pkg::*;

    parameter int DATA_WIDTH = 32;
    parameter int FIFO_DEPTH = 16;

    typedef enum logic [1:0] {
        WRITE_ONLY,
        READ_ONLY,
        WRITE_READ
    } fifo_op_e;

    `include "fifo_transaction.sv"
    `include "fifo_corrupt_transaction.sv"
    `include "fifo_sequencer.sv"
    `include "fifo_write_driver.sv"
    `include "fifo_write_monitor.sv"
    `include "fifo_read_driver.sv"
    `include "fifo_read_monitor.sv"
    `include "fifo_write_agent.sv"
    `include "fifo_read_agent.sv"
    `include "fifo_scoreboard.sv"
    `include "fifo_coverage.sv"
    `include "fifo_env.sv"
    `include "fifo_sequence.sv"
    `include "fifo_test.sv"

endpackage