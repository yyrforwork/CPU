`ifdef _MEM_WB_REG_
`else
`define _MEM_WB_REG_
`include define.v

module MEM_WB_REG(
	input wire clk,
	input wire rst,

	input wire [`WB_DATA_OP_BUS] NEW_MEM_WB_DATA_OP,
	input wire [`REG_OP_BUS] NEW_MEM_WB_REG_OP,

	output reg[`WB_DATA_OP_BUS] MEM_WB_DATA_OP,
	output reg[`REG_OP_BUS] MEM_WB_REG_OP,

	input wire [`DATA_BUS] NEW_MEM_WB_IH,
	input wire [`DATA_BUS] NEW_MEM_WB_PC,
	input wire [`DATA_BUS] NEW_MEM_WB_ALU_ANSWER,
	input wire [`DATA_BUS] NEW_MEM_WB_RAM_READ_ANSWER,
	input wire [`REG_ADDR_BUS] NEW_MEM_WB_WB_ADDR,

	output reg[`DATA_BUS] MEM_WB_IH,
	output reg[`DATA_BUS] MEM_WB_PC,
	output reg[`DATA_BUS] MEM_WB_ALU_ANSWER,
	output reg[`DATA_BUS] MEM_WB_RAM_READ_ANSWER,
	output reg[`REG_ADDR_BUS] MEM_WB_WB_ADDR,

	);

	always @(posedge clk , posedge rst) begin
		if (rst) begin
			// reset
		end
		else begin
			MEM_WB_DATA_OP 			<= NEW_MEM_WB_DATA_OP;
			MEM_WB_REG_OP  			<= NEW_MEM_WB_REG_OP;

			MEM_WB_IH 				<= NEW_MEM_WB_IH;
			MEM_WB_PC 				<= NEW_MEM_WB_PC;
			MEM_WB_ALU_ANSWER 		<= NEW_MEM_WB_ALU_ANSWER;
			MEM_WB_RAM_READ_ANSWER 	<= NEW_MEM_WB_RAM_READ_ANSWER;
			MEM_WB_WB_ADDR 			<= NEW_MEM_WB_WB_ADDR;
		end
	end
endmodule
`endif