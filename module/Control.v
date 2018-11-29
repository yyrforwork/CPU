`timescale 1ns / 1ps

`ifdef _CONTROL_
`else
`define _CONTROL_
`include "define.v"

module Control(
        input                       rst,
        input                       clk_50MHz,
        input     [`INST_BUS]       inst,

        output reg[`ALU_OP_BUS]     ALU_op,
        output reg[`ALU_A_OP_BUS]   ALU_A_op,
        output reg[`ALU_B_OP_BUS]   ALU_B_op,
        
        output reg[`REG_OP_BUS]     REG_op,
        output reg[`WB_DATA_OP_BUS] wb_data_op,
        output reg[`WB_ADDR_OP_BUS] wb_addr_op,
        
        output reg jump_op,
        output reg ram_op,
        
    );

always @ (*) begin
    if (~rst) begin
        ALU_op <= `ALU_OP_NOP;
        
    end else begin
    case(inst[`INST_OP])
        `INST_ADDIU: begin
            ALU_op <= `ALU_OP_ADD;
            ALU_A_op <= `ALU_A_OP_REGA;
            ALU_B_op <= `ALU_B_OP_IM;
            REG_op <= `REG_OP_REG;
            wb_data_op <= `WB_DATA_OP_ALU;
            wb_addr_op <= `WB_ADDR_OP_RX;

        end

        `INST_ADDIU3: begin
            ALU_op <= `ALU_OP_ADD;
            ALU_A_op <= `ALU_A_OP_REGA;
            ALU_B_op <= `ALU_B_OP_IM;
            REG_op <= `REG_OP_REG;
            wb_data_op <= `WB_DATA_OP_ALU;
            wb_addr_op <= `WB_ADDR_OP_RY;

        end

        `INST_ADDSP: begin
            ALU_op <= `ALU_OP_ADD;
            ALU_A_op <= `ALU_A_OP_SP;
            ALU_B_op <= `ALU_B_OP_IM;
            REG_op <= `REG_OP_SP;
            wb_data_op <= `WB_DATA_OP_ALU;
            wb_addr_op <= `WB_ADDR_OP_NOP;

        end

        `INST_ADDSP3: begin
            ALU_op <= `ALU_OP_ADD;
            ALU_A_op <= `ALU_A_OP_SP;
            ALU_B_op <= `ALU_B_OP_IM;
            REG_op <= `REG_OP_REG;
            wb_data_op <= `WB_DATA_OP_ALU;
            wb_addr_op <= `WB_ADDR_OP_RX;

        end

        `INST_ADDU: begin
            ALU_op <= `ALU_OP_ADD;
            ALU_A_op <= `ALU_A_OP_REGA;
            ALU_B_op <= `ALU_B_OP_REGB;
            REG_op <= `REG_OP_REG;
            wb_data_op <= `WB_DATA_OP_ALU;
            wb_addr_op <= `WB_ADDR_OP_RZ;

        end

        `INST_AND: begin
            ALU_op <= `ALU_OP_AND;
            ALU_A_op <= `ALU_A_OP_REGA;
            ALU_B_op <= `ALU_B_OP_REGB;
            REG_op <= `REG_OP_REG;
            wb_data_op <= `WB_DATA_OP_ALU;
            wb_addr_op <= `WB_ADDR_OP_RX;

        end

        `INST_B: begin
            ALU_op <= `ALU_OP_NOP;
            ALU_A_op <= `ALU_A_OP_NOP;
            ALU_B_op <= `ALU_B_OP_NOP;
            REG_op <= `REG_OP_NOP;
            wb_data_op <= `WB_DATA_OP_NOP;
            wb_addr_op <= `WB_ADDR_OP_NOP;

        end

        `INST_BEQZ: begin
            ALU_op <= `ALU_OP_NOP;
            ALU_A_op <= `ALU_A_OP_REGA;
            ALU_B_op <= `ALU_B_OP_NOP;
            REG_op <= `REG_OP_NOP;
            wb_data_op <= `WB_DATA_OP_NOP;
            wb_addr_op <= `WB_ADDR_OP_NOP;

        end

        `INST_BNEZ: begin
            ALU_op <= `ALU_OP_NOP;
            ALU_A_op <= `ALU_A_OP_REGA;
            ALU_B_op <= `ALU_B_OP_NOP;
            REG_op <= `REG_OP_NOP;
            wb_data_op <= `WB_DATA_OP_NOP;
            wb_addr_op <= `WB_ADDR_OP_NOP;

        end

        `INST_BTEQZ: begin
            ALU_op <= `ALU_OP_NOP;
            ALU_A_op <= `ALU_A_OP_T;
            ALU_B_op <= `ALU_B_OP_NOP;
            REG_op <= `REG_OP_NOP;
            wb_data_op <= `WB_DATA_OP_NOP;
            wb_addr_op <= `WB_ADDR_OP_NOP;

        end

        `INST_CMP: begin
            ALU_op <= `ALU_OP_EQU;
            ALU_A_op <= `ALU_A_OP_REGA;
            ALU_B_op <= `ALU_B_OP_REGB;
            REG_op <= `REG_OP_T;
            wb_data_op <= `WB_DATA_OP_ALU;
            wb_addr_op <= `WB_ADDR_OP_NOP;

        end

        `INST_CMPI: begin
            ALU_op <= `ALU_OP_EQU;
            ALU_A_op <= `ALU_A_OP_REGA;
            ALU_B_op <= `ALU_B_OP_IM;
            REG_op <= `REG_OP_T;
            wb_data_op <= `WB_DATA_OP_ALU;
            wb_addr_op <= `WB_ADDR_OP_NOP;

        end

        `INST_JR: begin
            ALU_op <= `ALU_OP_RETA;
            ALU_A_op <= `ALU_A_OP_REGA;
            ALU_B_op <= `ALU_B_OP_NOP;
            REG_op <= `REG_OP_NOP;
            wb_data_op <= `WB_DATA_OP_NOP;
            wb_addr_op <= `WB_ADDR_OP_NOP;

        end

        `INST_LI: begin
            ALU_op <= `ALU_OP_RETB;
            ALU_A_op <= `ALU_A_OP_NOP;
            ALU_B_op <= `ALU_B_OP_IM;
            REG_op <= `REG_OP_REG;
            wb_data_op <= `WB_DATA_OP_ALU;
            wb_addr_op <= `WB_ADDR_OP_RX;

        end

        `INST_LW: begin
            ALU_op <= `ALU_OP_ADD;
            ALU_A_op <= `ALU_A_OP_REGA;
            ALU_B_op <= `ALU_B_OP_IM;
            REG_op <= `REG_OP_REG;
            wb_data_op <= `WB_DATA_OP_MEM;
            wb_addr_op <= `WB_ADDR_OP_RY;

        end

        `INST_LW_SP: begin
            ALU_op <= `ALU_OP_ADD;
            ALU_A_op <= `ALU_A_OP_SP;
            ALU_B_op <= `ALU_B_OP_IM;
            REG_op <= `REG_OP_REG;
            wb_data_op <= `WB_DATA_OP_MEM;
            wb_addr_op <= `WB_ADDR_OP_RX;

        end

        `INST_MFIH: begin
            ALU_op <= `ALU_OP_NOP;
            ALU_A_op <= `ALU_A_OP_NOP;
            ALU_B_op <= `ALU_B_OP_NOP;
            REG_op <= `REG_OP_REG;
            wb_data_op <= `WB_DATA_OP_IH;
            wb_addr_op <= `WB_ADDR_OP_RX;

        end

        `INST_MFPC: begin
            ALU_op <= `ALU_OP_NOP;
            ALU_A_op <= `ALU_A_OP_NOP;
            ALU_B_op <= `ALU_B_OP_NOP;
            REG_op <= `REG_OP_REG;
            wb_data_op <= `WB_DATA_OP_PC;
            wb_addr_op <= `WB_ADDR_OP_RX;

        end

        `INST_MTIH: begin
            ALU_op <= `ALU_OP_RETA;
            ALU_A_op <= `ALU_A_OP_REGA;
            REG_op <= `REG_OP_IH;
            wb_data_op <= `WB_DATA_OP_ALU;
            wb_addr_op <= `WB_ADDR_OP_NOP;

        end

        `INST_MTSP: begin
            ALU_op <= `ALU_OP_RETA;
            ALU_A_op <= `ALU_A_OP_REGA;
            ALU_B_op <= `ALU_B_OP_NOP;
            REG_op <= `REG_OP_SP;
            wb_data_op <= `WB_DATA_OP_ALU;
            wb_addr_op <= `WB_ADDR_OP_NOP;
            
        end

        `INST_NOP: begin
            ALU_op <= `ALU_OP_NOP;
            ALU_A_op <= `ALU_A_OP_NOP;
            ALU_B_op <= `ALU_B_OP_NOP;
            REG_op <= `REG_OP_NOP;
            wb_data_op <= `WB_DATA_OP_NOP;
            wb_addr_op <= `WB_ADDR_OP_NOP;
            
        end

        `INST_OR: begin
            ALU_op <= `ALU_OP_OR;
            ALU_A_op <= `ALU_A_OP_REGA;
            ALU_B_op <= `ALU_B_OP_REGB;
            REG_op <= `REG_OP_REG;
            wb_data_op <= `WB_DATA_OP_ALU;
            wb_addr_op <= `WB_ADDR_OP_RX;
            
        end

        `INST_SLL: begin
            ALU_op <= `ALU_OP_SLL;
            ALU_A_op <= `ALU_A_OP_RZ;
            ALU_B_op <= `ALU_B_OP_REGB;
            REG_op <= `REG_OP_REG;
            wb_data_op <= `WB_DATA_OP_ALU;
            wb_addr_op <= `WB_ADDR_OP_RX;

        end

        `INST_SLLV: begin
            ALU_op <= `ALU_OP_SLLV;
            ALU_A_op <= `ALU_A_OP_REGA;
            ALU_B_op <= `ALU_B_OP_REGB;
            REG_op <= `REG_OP_REG;
            wb_data_op <= `WB_DATA_OP_ALU;
            wb_addr_op <= `WB_ADDR_OP_RY;

        end

        `INST_SRA: begin
            ALU_op <= `ALU_OP_SRA;
            ALU_A_op <= `ALU_A_OP_RZ;
            ALU_B_op <= `ALU_B_OP_REGB;
            REG_op <= `REG_OP_REG;
            wb_data_op <= `WB_DATA_OP_ALU;
            wb_addr_op <= `WB_ADDR_OP_RX;

        end

        `INST_SRL: begin
            ALU_op <= `ALU_OP_SRL;
            ALU_A_op <= `ALU_A_OP_RZ;
            ALU_B_op <= `ALU_B_OP_REGB;
            REG_op <= `REG_OP_REG;
            wb_data_op <= `WB_DATA_OP_ALU;
            wb_addr_op <= `WB_ADDR_OP_RX;

        end

        `INST_SUBU: begin
            ALU_op <= `ALU_OP_SUB;
            ALU_A_op <= `ALU_A_OP_REGA;
            ALU_B_op <= `ALU_B_OP_REGB;
            REG_op <= `REG_OP_REG;
            wb_data_op <= `WB_DATA_OP_ALU;
            wb_addr_op <= `WB_ADDR_OP_RZ;

        end

        `INST_SW: begin
            ALU_op <= `ALU_OP_ADD;
            ALU_A_op <= `ALU_A_OP_REGA;
            ALU_B_op <= `ALU_B_OP_IM;
            REG_op <= `REG_OP_NOP;
            wb_data_op <= `WB_DATA_OP_NOP;
            wb_addr_op <= `WB_ADDR_OP_NOP;

        end

        `INST_SW_RS: begin
            ALU_op <= `ALU_OP_ADD;
            ALU_A_op <= `ALU_A_OP_SP;
            ALU_B_op <= `ALU_B_OP_IM;
            REG_op <= `REG_OP_NOP;
            wb_data_op <= `WB_DATA_OP_NOP;
            wb_addr_op <= `WB_ADDR_OP_NOP;

        end

        `INST_SW_SP: begin
            ALU_op <= `ALU_OP_ADD;
            ALU_A_op <= `ALU_A_OP_SP;
            ALU_B_op <= `ALU_B_OP_IM;
            REG_op <= `REG_OP_NOP;
            wb_data_op <= `WB_DATA_OP_NOP;
            wb_addr_op <= `WB_ADDR_OP_NOP;

        end
    endcase
    end
end

endmodule
`endif
