`ifdef _ID_EXE_REG_
`else
`define _ID_EXE_REG_
`include define.v

module ID_EXE_REG(
	input wire clk,
	input wire rst,
	input wire ID_EXE_PAUSE,

	//**************input*************
	input wire[`INSTRUCTION_BUS] inst,
	
	//wb op
	input wire[`WB_DATA_OP_BUS] NEW_ID_EXE_DATA_OP,
	input wire[`REG_OP_BUS]     NEW_ID_EXE_REG_OP,
	
	//mem op
	input wire[`RAM_EN_OP_BUS]  NEW_ID_EXE_RAM_EN_OP,
	input wire[`RAM_OP_BUS]     NEW_ID_EXE_RAM_OP,

	//exe op
	input wire[`ALU_OP_BUS] 		NEW_ID_EXE_ALU_OP,
	input wire[`JUMP_DATA_BUS] 		NEW_ID_EXE_JUMP_DATA_OP,
	input wire[`JUMP_EN_OP_BUS] 	NEW_ID_EXE_JUMP_EN_OP,
	input wire[`ALU_A_OP_BUS] 		NEW_ID_EXE_ALU_A_OP,
	input wire[`ALU_B_OP_BUS] 		NEW_ID_EXE_ALU_B_OP,
	input wire[`IM_OP_BUS] 			NEW_ID_EXE_IM_OP,
	input wire[`WB_ADDR_OP_BUS] 	NEW_ID_EXE_WB_ADDR_OP,
	input wire[`RAM_W_DATA_OP_BUS] 	NEW_ID_EXE_RAM_W_DATA_OP;

	//regs
	input wire[`DATA_BUS] NEW_ID_EXE_REGA,
	input wire[`DATA_BUS] NEW_ID_EXE_REGB,
	input wire[`DATA_BUS] NEW_ID_EXE_IH,
	input wire[`DATA_BUS] NEW_ID_EXE_SP,
	input wire[`DATA_BUS] NEW_ID_EXE_RA,
	input wire[`DATA_BUS] NEW_ID_EXE_T,

	//im
	input wire[`PC_BUS]   NEW_ID_EXE_PC,
	input wire[`DATA_BUS] NEW_ID_EXE_S_E_10_0;
	input wire[`DATA_BUS] NEW_ID_EXE_S_E_7_0;
	input wire[`DATA_BUS] NEW_ID_EXE_S_E_4_0;
	input wire[`DATA_BUS] NEW_ID_EXE_S_E_3_0;
	input wire[`DATA_BUS] NEW_ID_EXE_z_E_7_0;

	//******************output*************

		//wb op
	output reg[`WB_DATA_OP_BUS] ID_EXE_DATA_OP,
	output reg[`REG_OP_BUS]     ID_EXE_REG_OP,
	
	//mem op
	output reg[`RAM_EN_OP_BUS]  ID_EXE_RAM_EN_OP,
	output reg[`RAM_OP_BUS]     ID_EXE_RAM_OP,

	//exe op
	output reg[`ALU_OP_BUS] 		ID_EXE_ALU_OP,
	output reg[`JUMP_DATA_BUS] 		ID_EXE_JUMP_DATA_OP,
	output reg[`JUMP_EN_OP_BUS] 	ID_EXE_JUMP_EN_OP,
	output reg[`ALU_A_OP_BUS] 		ID_EXE_ALU_A_OP,
	output reg[`ALU_B_OP_BUS] 		ID_EXE_ALU_B_OP,
	output reg[`IM_OP_BUS] 			ID_EXE_IM_OP,
	output reg[`WB_ADDR_OP_BUS]    	ID_EXE_WB_ADDR_OP,
	output reg[`RAM_W_DATA_OP_BUS] 	ID_EXE_RAM_W_DATA_OP;g

	//regs
	output reg[`DATA_BUS] ID_EXE_REGA,
	output reg[`DATA_BUS] ID_EXE_REGB,
	output reg[`DATA_BUS] ID_EXE_IH,
	output reg[`DATA_BUS] ID_EXE_SP,
	output reg[`DATA_BUS] ID_EXE_RA,
	output reg[`DATA_BUS] ID_EXE_T,

	//im
	output reg[`PC_BUS]   ID_EXE_PC,
	output reg[`DATA_BUS] ID_EXE_S_E_10_0,
	output reg[`DATA_BUS] ID_EXE_S_E_7_0,
	output reg[`DATA_BUS] ID_EXE_S_E_4_0,
	output reg[`DATA_BUS] ID_EXE_S_E_3_0,
	output reg[`DATA_BUS] ID_EXE_z_E_7_0,

	//wb addr
	output reg[`REG_ADDR_BUS] ID_EXE_REG_ADDR_RX,
	output reg[`REG_ADDR_BUS] ID_EXE_REG_ADDR_RY,
	output reg[`REG_ADDR_BUS] ID_EXE_REG_ADDR_RZ,
	);

	always @(posedge clk , posedge rst) begin
		if (rst) begin
			// reset
			
		end
		else
		if (ID_EXE_PAUSE != `PAUSE_ENABLE) begin
			//wb op
			ID_EXE_DATA_OP   <= NEW_ID_EXE_DATA_OP;
			ID_EXE_REG_OP    <= NEW_EXE_REG_OP;
			
			//mem op
			ID_EXE_RAM_EN_OP <= NEW_ID_EXE_RAM_EN_OP;
			ID_EXE_RAM_OP    <= NEW_ID_EXE_RAM_OP;

			//exe op
			ID_EXE_ALU_OP    	<=NEW_ID_EXE_ALU_OP;   
			ID_EXE_JUMP_DATA_OP <=NEW_ID_EXE_JUMP_DATA_OP;
			ID_EXE_JUMP_EN_OP   <=NEW_ID_EXE_RAM_EN_OP;
			ID_EXE_ALU_A_OP 	<=NEW_ID_EXE_ALU_A_OP;
			ID_EXE_ALU_B_OP 	<=NEW_ID_EXE_ALU_B_OP;
			ID_EXE_IM_OP 		<=NEW_ID_EXE_IM_OP;
			ID_EXE_WB_ADDR_OP 	<=NEW_ID_EXE_WB_ADDR_OP;
			ID_EXE_RAM_W_DATA_OP<=NEW_ID_EXE_RAM_W_DATA_OP;

			//regs
			ID_EXE_REGA <=NEW_ID_EXE_REGA;
			ID_EXE_REGB <=NEW_ID_EXE_REGB;
			ID_EXE_IH   <=NEW_ID_EXE_IH;
			ID_EXE_SP   <=NEW_ID_EXE_SP;
			ID_EXE_RA   <=NEW_ID_EXE_RA;
			ID_EXE_T    <=NEW_ID_EXE_T;

			//im
			ID_EXE_PC,
			ID_EXE_S_E_10_0<= NEW_ID_EXE_S_E_10_0;
			ID_EXE_S_E_7_0 <= NEW_ID_EXE_S_E_7_0;
			ID_EXE_S_E_4_0 <= NEW_ID_EXE_S_E_4_0;
			ID_EXE_S_E_3_0 <= NEW_ID_EXE_S_E_3_0;
			ID_EXE_z_E_7_0 <= NEW_ID_EXE_z_E_7_0;

			//wb addr
			ID_EXE_REG_ADDR_RX <=inst[`INST_RX_ADDR];
			ID_EXE_REG_ADDR_RY <=inst[`INST_RY_ADDR];
			ID_EXE_REG_ADDR_RZ <=inst[`INST_RZ_ADDR];	
		end
	end

endmodule
`endif