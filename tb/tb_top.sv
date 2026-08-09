// Testbench top
`include "uvm_macros.svh"
import uvm_pkg::*;

module tb_top;
    bit clk;
    bit rst_n;

    initial begin
        clk = 0;
        forever #5ns clk = ~clk;
    end

    initial begin
        rst_n = 0;
        #20ns;
        rst_n = 1;
    end

    fifo_if vif(
        .clk(clk),
        .rst_n(rst_n)
    );

    fifo #(
        .DATA_WIDTH(fifo_pkg::DATA_WIDTH),
        .DEPTH(fifo_pkg::FIFO_DEPTH)
    ) u_fifo(
        .clk(vif.clk),
        .rst_n(vif.rst_n),
        .w_en(vif.w_en),
        .wdata(vif.wdata),
        .full(vif.full),
        .r_en(vif.r_en),
        .rdata(vif.rdata),
        .empty(vif.empty)
    );

    initial begin
        uvm_config_db#(virtual fifo_if)::set(null, "*", "vif", vif);
        run_test();
    end

endmodule