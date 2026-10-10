module fifo_assertion #(
    parameter ADDR_WIDTH = 3
)(
    input logic clk,
    input logic rst_n,
    input logic full,
    input logic empty,
    input logic w_en,
    input logic r_en,
    input logic [ADDR_WIDTH:0] wptr,
    input logic [ADDR_WIDTH:0] rptr
);

    property p_no_overflow;
        @(posedge clk) disable iff (!rst_n)
        (full && w_en) |=> $stable(wptr);
    endproperty

    assert_no_overflow: assert property (p_no_overflow)
        else $error("FIFO write pointer changed while full!");

    property p_no_underflow;
        @(posedge clk) disable iff (!rst_n)
        (empty && r_en) |=> $stable(rptr);
    endproperty

    assert_no_underflow: assert property (p_no_underflow)
        else $error("FIFO read pointer changed while empty!");

endmodule

// Bind checker to FIFO DUT
bind fifo fifo_assertion #(
    .ADDR_WIDTH($clog2(DEPTH))
) fifo_assertion_inst (
    .clk(clk),
    .rst_n(rst_n),
    .full(full),
    .empty(empty),
    .w_en(w_en),
    .r_en(r_en),
    .wptr(wptr),
    .rptr(rptr)
);