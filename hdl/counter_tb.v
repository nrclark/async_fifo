module counter_tb;
    reg i_clk;
    reg i_rst;
    reg i_enable;
    wire [`DATA_WIDTH-1:0] o_data_out;

    initial
    begin
        $from_myhdl(i_clk, i_rst, i_enable);
        $to_myhdl(o_data_out);
    end

    sync_counter #(
        .DATA_WIDTH(`DATA_WIDTH)
    ) myFIFO (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_enable(i_enable),
        .o_data_out(o_data_out)
    );
   
endmodule
