`ifdef _EXE_MEM_REG_
`else
`define _EXE_MEM_REG_
`include define.v

module EXE_MEM_REG(
	input wire clk,
	input wire rst,

	input wire[`RAM_EN_OP_BUS] NEW_EXE_MEM_RAM_EN,
	input wire[`RAM_OP_BUS] NEW_EXE_MEM_RAM_OP,
	input wire[`WB_DATA_OP_BUS] NEW_EXE_MEM_DATA_OP,
	input wire[`REG_OP_BUS] NEW_EXE_MEM_REG_OP,

	output reg[`RAM_EN_OP_BUS] EXE_MEM_RAM_EN,
	output reg[`RAM_OP_BUS] EXE_MEM_RAM_OP,
	output reg[`WB_DATA_OP_BUS] EXE_MEM_DATA_OP,
	output reg[`REG_OP_BUS] EXE_MEM_REG_OP,

	input wire[`DATA_BUS] NEW_EXE_MEM_IH,
	input wire[`DATA_BUS] NEW_EXE_MEM_PC,
	input wire[`DATA_BUS] NEW_EXE_MEM_ALU_ANSWER,
	input wire[`DATA_BUS] NEW_EXE_MEM_RAM_WB_DATA,
	input wire[`REG_ADDR_BUS] NEW_EXE_MEM_WB_ADDR,

	output reg[`DATA_BUS] EXE_MEM_IH,
	output reg[`DATA_BUS] EXE_MEM_PC,
	output reg[`DATA_BUS] EXE_MEM_ALU_ANSWER,
	output reg[`DATA_BUS] EXE_MEM_RAM_WB_DATA,
	output reg[`REG_ADDR_BUS] EXE_MEM_WB_ADDR,

	);

	always @(posedge clk , posedge rst) begin
		if (rst) begin
			// reset
		end
		else begin
			EXE_MEM_RAM_EN				<= NEW_EXE_MEM_RAM_EN;
			EXE_MEM_RAM_OP 				<= NEW_EXE_MEM_RAM_OP;
			EXE_MEM_DATA_OP 			<= NEW_EXE_MEM_DATA_OP;
			EXE_MEM_REG_OP  			<= NEW_EXE_MEM_REG_OP;

			EXE_MEM_IH 					<= NEW_EXE_MEM_IH;
			EXE_MEM_PC 					<= NEW_EXE_MEM_PC;
			EXE_MEM_ALU_ANSWER 			<= NEW_EXE_MEM_ALU_ANSWER;
			EXE_MEM_RAM_WB_DATA 		<= NEW_EXE_MEM_RAM_WB_DATA;
			EXE_MEM_WB_ADDR 			<= NEW_EXE_MEM_WB_ADDR;
		end
	end
endmodule
`endif