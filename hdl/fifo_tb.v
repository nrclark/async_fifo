module fifo_tb;
    reg i_clk;
    reg i_rst;
    reg i_rd_en;
    reg i_wr_en;
    reg [`DATA_WIDTH-1:0] i_data_in;
    
    wire o_full;
    wire o_empty;
    wire [`DATA_WIDTH-1:0] o_data_out;

    initial
    begin
        $from_myhdl(i_clk, i_rst, i_rd_en, i_wr_en, i_data_in);
        $to_myhdl(o_full, o_empty, o_data_out);
    end

    sync_fifo #(
        .DATA_WIDTH(`DATA_WIDTH),
        .FIFO_DEPTH(`FIFO_DEPTH)
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
   
endmodule
