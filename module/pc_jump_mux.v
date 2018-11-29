`ifdef _PC_JUMP_MUX_
`else
`define _PC_JUMP_MUX_
`include define.v

module PC_JUMP_MUX(
	input wire pc_jump_op;
	input wire[`PC_BUS] PC_plus;
	input wire[`PC_BUS] PC_jump;
	output reg[`PC_BUS] PC_new;
	)

	always @(*) begin
		if (pc_jump_op == `PC_JUMP) begin
			PC_new <= PC_jump;
		end else begin
			PC_new <= PC_plus;
		end
	end

endmodule
`endif

`define PC_JUMP_ENABLE  1'b1;
`define PC_JUMP_DIAABLE 1'b0;