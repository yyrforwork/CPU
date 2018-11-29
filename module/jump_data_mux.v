`ifdef _JUMP_DATA_MUX_
`else
`define _JUNP_DATA_MUX_
`include define.v

module JUMP_DATA_MUX(
	input wire jump_data_op;
	input wire[`PC_BUS] jump_answer;
	input wire[`PC_BUS] alu_answer;
	output reg[`PC_BUS] jump_addr;
	)

	always @(*) begin
		if(jump_data_op == `JUMP_DATA_OP_ALU)
			jump_addr = alu_answer;
		else begin
			jump_addr = jump_answer;
		end
	end

endmodule
`endif