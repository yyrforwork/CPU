`ifdef _JUMP_EN_MUX_
`else
`define _JUMP_EN_MUX_
`include define.v

module JUMP_EN_MUX(
	input wire[`JUMP_EN_MUX_OP_BUS] jump_en_mux_op;
	input wire zero;//等于0时值为1
	output reg jump_en;
	)

	always @(*) begin
		case(jump_en_mux_op)
			`JUMP_EN_OP_EN:		jump_en <= `PC_JUMP_ENABLE;
			`JUMP_EN_OP_ZEROJ:	jump_en <= zero;
			`JUMP_EN_OP_NZEROJ:	jump_en <= ~zero;
			default:;
		endcase
	end

endmodule
`endif

`define PC_JUMP_ENABLE 1'b1
`define PC_JUMP_DISABLE 1'b0