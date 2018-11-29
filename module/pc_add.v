`ifdef _PC_ADD_
`else
`define _PC_ADD_
`include define.v

module PC_ADD(
	input wire[`PC_BUS] old_pc;
	input wire[`PC_BUS] im;
	output reg[`PC_BUS] new_pc;
	)

	always @(*) begin
		new_pc <= old_pc + im;
	end

endmodule
`endif