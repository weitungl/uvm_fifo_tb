`include "uvm_macros.svh"
// Interface
import fifo_pkg::*;
import uvm_pkg::*;

interface fifo_if (
    input logic clk
);
    // Reset
    logic rst_n = 1'b0;

    task automatic trigger_reset(int unsigned num_cycles = 2);
        @(negedge clk);
        rst_n = 1'b0;
        repeat(num_cycles) @(negedge clk);
        rst_n = 1'b1;
    endtask
    
    // Write
    logic                       w_en;
    logic [DATA_WIDTH-1:0]      wdata;
    logic                       full;

    // Read
    logic                       r_en;
    logic [DATA_WIDTH-1:0]      rdata;
    logic                       empty;

    // Write Clocking Blocks
    clocking w_drv_cb @(posedge clk);
        default input #1step output #1ns;
        output  w_en, wdata;
        input   full;
    endclocking

    clocking w_mon_cb @(posedge clk);
        default input #1step output #1ns;
        input   w_en, wdata, full;
    endclocking

    // Read Clocking Blocks
    clocking r_drv_cb @(posedge clk);
        default input #1step output #1ns;
        output  r_en;
        input   rdata, empty;
    endclocking

    clocking r_mon_cb @(posedge clk);
        default input #1step output #1ns;
        input   r_en, rdata, empty;
    endclocking


    // Assertions
    // Full, empty exclusion
    property p_full_empty;
        @(posedge clk) disable iff (!rst_n)
        !(full && empty);
    endproperty

    assert_full_empty: assert property (p_full_empty)
        else `uvm_error("SVA", "FIFO cannot be full and empty simultaneously!")

    // Reset check
    property p_reset;
        @(posedge clk)
        !rst_n |-> (empty && !full);
    endproperty

    assert_reset: assert property (p_reset)
        else `uvm_error("SVA", "FIFO reset state incorrect!")

    // Overflow Protection
    property p_no_overflow;
        @(posedge clk) disable iff (!rst_n)
        (full && w_en && !r_en) |=> full;
    endproperty

    assert_no_overflow: assert property (p_no_overflow)
        else `uvm_error("SVA", "FIFO overflow protection failed!")

    // Underflow Protection
    property p_no_underflow;
        @(posedge clk) disable iff (!rst_n)
        (empty && r_en && !w_en) |=> empty;
    endproperty

    assert_no_underflow: assert property (p_no_underflow)
        else `uvm_error("SVA", "FIFO underflow protection failed!")

endinterface