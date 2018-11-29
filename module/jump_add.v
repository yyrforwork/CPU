`ifdef _JUMP_ADD_
`else
`define _JUMP_ADD_
`include define.v

module JUMP_ADD(
	input wire[`PC_BUS] old_pc;
	input wire[`PC_BUS] im;
	output reg[`PC_BUS] new_pc;
	)

	always @(*) begin
		new_pc <= old_pc + im;
	end

endmodule
`endif