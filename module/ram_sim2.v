`timescale 1ns / 1ps

`ifdef _RAM_SIM2_
`else
`define __RAM_SIM2_
`include "define.v"

module RAM_SIM2(
        input rst,
        input clk_50MHz,

        input ram_en,
        input ram_op,
        input [`DATA_BUS] addr,
        input [`DATA_BUS] w_data,
        output [`DATA_BUS] r_data
    );

reg [`DATA_BUS] data[0:15] ;

assign r_data = data[addr[3:0]];
always @(*)
begin
	if(ram_en == `RAM_ENABLE)
		if(ram_op == `RAM_OP_WR)
		begin
			data[addr[3:0]] <= w_data;
		end
end

endmodule

`endif