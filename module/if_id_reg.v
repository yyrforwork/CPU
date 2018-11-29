`ifdef _IF_ID_REG_
`else
`define _IF_ID_REG_
`include define.v

module IF_ID_REG(
	input wire rst,
	input wire clk,
	
	input wire [] pc_pause,
	input wire [] pc_clear,
	
	input wire [`ISNTRUCION_BUS] ram_out_ins,
	input wire [`PC_DATA] pc_add_value,
	
	output reg [`PC_DATA] IF_ID_PC,
	output reg [`ISNTRUCION_BUS] IF_ID_ins,
	);

	always @(posedge clk , posedge rst) begin
		if (rst) begin
			// reset
			IF_ID_ins <= `EMPTY_INS;
		end
		else if (pc_pause == `PAUSE_DISABLE) begin
			if (pc_clear == `CLEAR_ENABLE)
			begin
				IF_ID_ins <=`EMPTY_INS;
			end else begin
				IF_ID_ins <=ram_out_ins;
				IF_ID_PC  <=pc_add_value;
			end
		end
	end
	
endmodule
`endif