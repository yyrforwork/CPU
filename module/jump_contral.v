`ifdef _JUMP_CONTRAL_
`else
`define _JUMP_CONTRAL_
`include define.v

module JUMP_CONTRAL(
	input rst;
	input wire pc_jump_en;
	output reg clear;
	);

	always @(*) begin
		if (rst == `RST_ENABLE) begin
			clear <= `CLEAR_DISABLE;			
		end
		else if (pc_jump_en == `PC_JUMP) begin
			clear <= `CLEAR_ENABLE;
		end	else begin
			clear <= `CLEAR_DISABLE;
		end

	end

endmodule
`endif

`define CLEAR_ENABLE  1'b1;
`define CLEAR_DISABLE 1'b0;
