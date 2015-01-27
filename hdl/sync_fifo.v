//-----------------------------------------------------
// Design Name : syn_fifo
// File Name   : syn_fifo.v
// Function    : Synchronous (single clock) FIFO
//-----------------------------------------------------

`default_nettype none
module sync_fifo #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16
)(
    input wire i_clk,
    input wire i_rst,
    input wire i_rd_en,
    input wire i_wr_en,
    input wire [DATA_WIDTH-1:0] i_data_in,
    output wire o_full,
    output wire o_empty,
    output reg [DATA_WIDTH-1:0] o_data_out = 0
);

    parameter ADDR_WIDTH = $clog2(FIFO_DEPTH);
    
   //-----------Internal variables-------------------

    reg [ADDR_WIDTH-1:0] wr_pointer = 0;
    reg [ADDR_WIDTH-1:0] rd_pointer = 0;
    reg [ADDR_WIDTH:0] status_cnt = 0;
    reg [DATA_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

   //-----------Variable assignments---------------

    assign o_full = (status_cnt == (FIFO_DEPTH-1));
    assign o_empty = (status_cnt == 0);

   //-----------Code Start---------------------------

    always @ (posedge i_clk or posedge i_rst)
    begin: WRITE_POINTER
        if (i_rst)
            wr_pointer <= 0;
        else if (i_wr_en)
            wr_pointer <= wr_pointer + 1;
    end

    always @ (posedge i_clk or posedge i_rst)
    begin: READ_POINTER
        if (i_rst)
            rd_pointer <= 0;
        else if (i_rd_en)
            rd_pointer <= rd_pointer + 1;
    end

    always @ (posedge i_clk or posedge i_rst)
    begin: STATUS_COUNTER
        if (i_rst)
            status_cnt <= 0;

        else if (i_rd_en && (!i_wr_en) && (status_cnt != 0))
            status_cnt <= status_cnt - 1;

        else if (i_wr_en && (!i_rd_en) && (status_cnt != FIFO_DEPTH))
            status_cnt <= status_cnt + 1;
    end

    always @ (posedge i_clk)
    begin: RAM
        if (i_wr_en)
            mem[wr_pointer] <= i_data_in;

        if (i_rd_en)
            o_data_out <= mem[rd_pointer];
    end

endmodule
`default_nettype wire
/*---------- Testbench ----------------
    
    sync_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) myFIFO (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_rd_en(i_rd_en),
        .i_wr_en(i_wr_en),
        .i_data_in(i_data_in),
        .o_full(o_full),
        .o_empty(o_empty),
        .o_data_out(o_data_out)
    );

-------------------------------------*/
