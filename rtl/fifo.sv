// DUT
module fifo #(
    parameter DATA_WIDTH = 32,
    parameter DEPTH = 16
)(
    input  logic                    clk,
    input  logic                    rst_n,

    // Write
    input  logic                    w_en,
    input  logic [DATA_WIDTH-1:0]   wdata,
    output logic                    full,
    // Read
    input  logic                    r_en,
    output logic [DATA_WIDTH-1:0]   rdata,
    output logic                    empty
);

    localparam ADDR_WIDTH = $clog2(DEPTH);

    logic [DATA_WIDTH-1:0] mem [DEPTH];
    logic [ADDR_WIDTH:0] wptr;
    logic [ADDR_WIDTH:0] rptr;

    // Write pointer & write
    always_ff @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            wptr <= '0;
        end else if(w_en && !full) begin
            wptr <= wptr + 1'b1;
            mem[wptr[ADDR_WIDTH-1:0]]   <= wdata;
        end
    end

    // Read pointer
    always_ff @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            rptr <= '0;
        end else if(r_en && !empty) begin
            rptr <= rptr + 1'b1;
        end
    end

    // read out
    assign rdata = mem[rptr[ADDR_WIDTH-1:0]];

    assign full = (wptr[ADDR_WIDTH] != rptr[ADDR_WIDTH] &&          // MSB different, but the
                    wptr[ADDR_WIDTH-1:0] == rptr[ADDR_WIDTH-1:0]);  // rest are the same

    assign empty = (wptr == rptr);

endmodule