`ifdef _PC_
`else
`define _PC
`include define.v

module PC(
	input rst;
	input clk;
	input wire PC_pause;
	input wire[`PC_BUS] PC_in;
	output reg[`pc_BUS] PC_out;
	)

	always @(posedge clk, negedge rst) begin
		if(rst == `RST_ENABLE)begin
			PC_out == `FIRST_ADDR;
		end else begin
			if (PC_pause != `PAUSE_ENABLE) begin
				PC_out <= PC_in;
			end
		end

	end

endmodule
`endif