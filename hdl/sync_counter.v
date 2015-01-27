//-----------------------------------------------------
// Design Name : sync_counter
// File Name   : sync_counter.v
// Function    : Synchronous Counter
//-----------------------------------------------------

`default_nettype none
module sync_counter #(
    parameter DATA_WIDTH = 8
)(
    input wire i_clk,
    input wire i_rst,
    input wire i_enable,
    output reg [DATA_WIDTH-1:0] o_data_out = 0
);
    
   //-----------Code Start---------------------------

    always @ (posedge i_clk)
   	begin: INCREMENT
   		if(i_rst)
   			o_data_out <= 0;
		else if (i_enable)
			o_data_out <= o_data_out + 1;
    end

endmodule
`default_nettype wire
/*---------- Testbench ----------------
    
    sync_counter #(
        .DATA_WIDTH(DATA_WIDTH)
    ) myCOUNTER (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_enable(i_enable),
        .o_data_out(o_data_out)
    );

-------------------------------------*/
