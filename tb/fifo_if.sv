// Interface
import fifo_pkg::*;

interface fifo_if (
    input logic clk,
    input logic rst_n
);
    // Interface Signals
    
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


endinterface