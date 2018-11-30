`timescale 1ns / 1ps

`ifdef _CONTROL_
`else
`define _CONTROL_
`include "define.v"

module Control(
        input                        rst,
        input                        clk_50MHz,
        input     [`INST_BUS]        inst,

        output reg[`ALU_OP_BUS]      ALU_op,
        output reg[`ALU_A_OP_BUS]    ALU_A_op,
        output reg[`ALU_B_OP_BUS]    ALU_B_op,
        
        output reg[`REG_OP_BUS]      REG_op,
        output reg[`WB_DATA_OP_BUS]  wb_data_op,
        output reg[`WB_ADDR_OP_BUS]  wb_addr_op,

        output reg                   RAM_en,
        output reg                   RAM_op,
        output reg[`JUMP_EN_OP_BUS]  jump_en_op,
        output reg[`JUMP_DATA_BUS]   jump_data_op,
        output reg[`IM_OP_BUS]       im_op,
        output reg[`RAM_DATA_OP_BUS] ram_data_op
    );

reg[`INST_CTL_OP] inst_ctl_op;

always @(*) begin
    // load control op
    case(inst[`INST_OP])
        `INST_ADDIU:  inst_ctl_op <= `INST_CTL_ADDIU;
        `INST_ADDIU3: inst_ctl_op <= `INST_CTL_ADDIU3;
        `INST_ADDSP3: inst_ctl_op <= `INST_CTL_ADDSP3;
        `INST_GROUP1:
            begin case(inst[10:8])
                3'b011: inst_ctl_op <= `INST_CTL_ADDSP;
                3'b000: inst_ctl_op <= `INST_CTL_BTEQZ;
                3'b100: inst_ctl_op <= `INST_CTL_MTSP;
                3'b010: inst_ctl_op <= `INST_CTL_SW_RS;
            endcase end
        `INST_GROUP2:inst_ctl_op <= INST_CTL_ADDU;
            // begin case(inst[1:0])
            //     2'b01: inst_ctl_op <= INST_CTL_ADDU;
            //     2'b11: inst_ctl_op <= INST_CTL_SUBU;
            // endcase end
        // `INST_GROUP3:
        //     begin case(inst[4:0])
        //         5'b01100: inst_ctl_op <= INST_CTL_AND;
        //         5'b01010: inst_ctl_op <= INST_CTL_CMP;
        //         5'b00000: 
        //             begin case(inst[7:5])
        //                 3'b000: inst_ctl_op <= INST_CTL_JR;
        //                 3'b010: inst_ctl_op <= INST_CTL_MFPC;
        //             endcase end
        //         5'b01101: inst_ctl_op <= INST_CTL_OR;
        //         5'b00100: inst_ctl_op <= INST_CTL_SLLV;
        //     endcase end
        `INST_B:      inst_ctl_op <= `INST_CTL_ADDIU;
        `INST_BEQZ:   inst_ctl_op <= `INST_CTL_BEQZ;
        `INST_BNEZ:   inst_ctl_op <= `INST_CTL_BNEZ;
        `INST_CMPI:   inst_ctl_op <= `INST_CTL_CMPI;
        `INST_LI:     inst_ctl_op <= `INST_CTL_LI;
        `INST_LW:     inst_ctl_op <= `INST_CTL_LW;
        `INST_LW_SP:  inst_ctl_op <= `INST_CTL_LW_SP;
        `INST_GROUP4:
            begin case(inst[0])
                1'b0: inst_ctl_op <= `INST_CTL_MFIH;
                1'b1: inst_ctl_op <= `INST_CTL_MTIH;
            endcase end
        `INST_NOP:     inst_ctl_op <= `INST_CTL_NOP;
        `INST_GROUP5:
            begin case(inst[1:0])
                2'b00: inst_ctl_op <= `INST_CTL_SLL;
                2'b11: inst_ctl_op <= `INST_CTL_SRA;
                2'b10: inst_ctl_op <= `INST_CTL_SRL;
            endcase end
        `INST_SW:     inst_ctl_op <= `INST_CTL_SW;
        `INST_SW_SP:  inst_ctl_op <= `INST_CTL_SW_SP;
    endcase

    // // arrange every operation signal
    // case(inst_ctl_op)
    //     `INST_CTL_ADDIU: begin
    //         ALU_op <= `ALU_OP_ADD;
    //         ALU_A_op <= `ALU_A_OP_REGA;
    //         ALU_B_op <= `ALU_B_OP_IM;
    //         REG_op <= `REG_OP_REG;
    //         wb_data_op <= `WB_DATA_OP_ALU;
    //         wb_addr_op <= `WB_ADDR_OP_RX;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_S_E_7_0;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_ADDIU3: begin
    //         ALU_op <= `ALU_OP_ADD;
    //         ALU_A_op <= `ALU_A_OP_REGA;
    //         ALU_B_op <= `ALU_B_OP_IM;
    //         REG_op <= `REG_OP_REG;
    //         wb_data_op <= `WB_DATA_OP_ALU;
    //         wb_addr_op <= `WB_ADDR_OP_RY;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_S_E_3_0;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_ADDSP: begin
    //         ALU_op <= `ALU_OP_ADD;
    //         ALU_A_op <= `ALU_A_OP_SP;
    //         ALU_B_op <= `ALU_B_OP_IM;
    //         REG_op <= `REG_OP_SP;
    //         wb_data_op <= `WB_DATA_OP_ALU;
    //         wb_addr_op <= `WB_ADDR_OP_NOP;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_S_E_7_0;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_ADDSP3: begin
    //         ALU_op <= `ALU_OP_ADD;
    //         ALU_A_op <= `ALU_A_OP_SP;
    //         ALU_B_op <= `ALU_B_OP_IM;
    //         REG_op <= `REG_OP_REG;
    //         wb_data_op <= `WB_DATA_OP_ALU;
    //         wb_addr_op <= `WB_ADDR_OP_RX;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_S_E_7_0;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_ADDU: begin
    //         ALU_op <= `ALU_OP_ADD;
    //         ALU_A_op <= `ALU_A_OP_REGA;
    //         ALU_B_op <= `ALU_B_OP_REGB;
    //         REG_op <= `REG_OP_REG;
    //         wb_data_op <= `WB_DATA_OP_ALU;
    //         wb_addr_op <= `WB_ADDR_OP_RZ;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_NOP;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_AND: begin
    //         ALU_op <= `ALU_OP_AND;
    //         ALU_A_op <= `ALU_A_OP_REGA;
    //         ALU_B_op <= `ALU_B_OP_REGB;
    //         REG_op <= `REG_OP_REG;
    //         wb_data_op <= `WB_DATA_OP_ALU;
    //         wb_addr_op <= `WB_ADDR_OP_RX;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_NOP;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_B: begin
    //         ALU_op <= `ALU_OP_NOP;
    //         ALU_A_op <= `ALU_A_OP_NOP;
    //         ALU_B_op <= `ALU_B_OP_NOP;
    //         REG_op <= `REG_OP_NOP;
    //         wb_data_op <= `WB_DATA_OP_NOP;
    //         wb_addr_op <= `WB_ADDR_OP_NOP;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_EN;
    //         jump_data_op <= `JUMP_DATA_ALU;
    //         im_op <= `IM_OP_S_E_10_0;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_BEQZ: begin
    //         ALU_op <= `ALU_OP_NOP;
    //         ALU_A_op <= `ALU_A_OP_REGA;
    //         ALU_B_op <= `ALU_B_OP_NOP;
    //         REG_op <= `REG_OP_NOP;
    //         wb_data_op <= `WB_DATA_OP_NOP;
    //         wb_addr_op <= `WB_ADDR_OP_NOP;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_ZEROJ;
    //         jump_data_op <= `JUMP_DATA_ALU;
    //         im_op <= `IM_OP_NOP;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_BNEZ: begin
    //         ALU_op <= `ALU_OP_NOP;
    //         ALU_A_op <= `ALU_A_OP_REGA;
    //         ALU_B_op <= `ALU_B_OP_NOP;
    //         REG_op <= `REG_OP_NOP;
    //         wb_data_op <= `WB_DATA_OP_NOP;
    //         wb_addr_op <= `WB_ADDR_OP_NOP;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_NZEROJ;
    //         jump_data_op <= `JUMP_DATA_ALU;
    //         im_op <= `IM_OP_NOP;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_BTEQZ: begin
    //         ALU_op <= `ALU_OP_NOP;
    //         ALU_A_op <= `ALU_A_OP_T;
    //         ALU_B_op <= `ALU_B_OP_NOP;
    //         REG_op <= `REG_OP_NOP;
    //         wb_data_op <= `WB_DATA_OP_NOP;
    //         wb_addr_op <= `WB_ADDR_OP_NOP;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_ZEROJ;
    //         jump_data_op <= `JUMP_DATA_ALU;
    //         im_op <= `IM_OP_NOP;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_CMP: begin
    //         ALU_op <= `ALU_OP_EQU;
    //         ALU_A_op <= `ALU_A_OP_REGA;
    //         ALU_B_op <= `ALU_B_OP_REGB;
    //         REG_op <= `REG_OP_T;
    //         wb_data_op <= `WB_DATA_OP_ALU;
    //         wb_addr_op <= `WB_ADDR_OP_NOP;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_NOP;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_CMPI: begin
    //         ALU_op <= `ALU_OP_EQU;
    //         ALU_A_op <= `ALU_A_OP_REGA;
    //         ALU_B_op <= `ALU_B_OP_IM;
    //         REG_op <= `REG_OP_T;
    //         wb_data_op <= `WB_DATA_OP_ALU;
    //         wb_addr_op <= `WB_ADDR_OP_NOP;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_S_E_7_0;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_JR: begin
    //         ALU_op <= `ALU_OP_RETA;
    //         ALU_A_op <= `ALU_A_OP_REGA;
    //         ALU_B_op <= `ALU_B_OP_NOP;
    //         REG_op <= `REG_OP_NOP;
    //         wb_data_op <= `WB_DATA_OP_NOP;
    //         wb_addr_op <= `WB_ADDR_OP_NOP;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_EN;
    //         jump_data_op <= `JUMP_DATA_ALU;
    //         im_op <= `IM_OP_NOP;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_LI: begin
    //         ALU_op <= `ALU_OP_RETB;
    //         ALU_A_op <= `ALU_A_OP_NOP;
    //         ALU_B_op <= `ALU_B_OP_IM;
    //         REG_op <= `REG_OP_REG;
    //         wb_data_op <= `WB_DATA_OP_ALU;
    //         wb_addr_op <= `WB_ADDR_OP_RX;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_Z_E_7_0;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_LW: begin
    //         ALU_op <= `ALU_OP_ADD;
    //         ALU_A_op <= `ALU_A_OP_REGA;
    //         ALU_B_op <= `ALU_B_OP_IM;
    //         REG_op <= `REG_OP_REG;
    //         wb_data_op <= `WB_DATA_OP_MEM;
    //         wb_addr_op <= `WB_ADDR_OP_RY;
    //         RAM_en <= `RAM_ENABLE;
    //         RAM_op <= `RAM_OP_RD;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_S_E_4_0;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_LW_SP: begin
    //         ALU_op <= `ALU_OP_ADD;
    //         ALU_A_op <= `ALU_A_OP_SP;
    //         ALU_B_op <= `ALU_B_OP_IM;
    //         REG_op <= `REG_OP_REG;
    //         wb_data_op <= `WB_DATA_OP_MEM;
    //         wb_addr_op <= `WB_ADDR_OP_RX;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_S_E_7_0;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_MFIH: begin
    //         ALU_op <= `ALU_OP_NOP;
    //         ALU_A_op <= `ALU_A_OP_NOP;
    //         ALU_B_op <= `ALU_B_OP_NOP;
    //         REG_op <= `REG_OP_REG;
    //         wb_data_op <= `WB_DATA_OP_IH;
    //         wb_addr_op <= `WB_ADDR_OP_RX;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_NOP;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_MFPC: begin
    //         ALU_op <= `ALU_OP_NOP;
    //         ALU_A_op <= `ALU_A_OP_NOP;
    //         ALU_B_op <= `ALU_B_OP_NOP;
    //         REG_op <= `REG_OP_REG;
    //         wb_data_op <= `WB_DATA_OP_PC;
    //         wb_addr_op <= `WB_ADDR_OP_RX;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_NOP;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_MTIH: begin
    //         ALU_op <= `ALU_OP_RETA;
    //         ALU_A_op <= `ALU_A_OP_REGA;
    //         REG_op <= `REG_OP_IH;
    //         wb_data_op <= `WB_DATA_OP_ALU;
    //         wb_addr_op <= `WB_ADDR_OP_NOP;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_NOP;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_MTSP: begin
    //         ALU_op <= `ALU_OP_RETA;
    //         ALU_A_op <= `ALU_A_OP_REGA;
    //         ALU_B_op <= `ALU_B_OP_NOP;
    //         REG_op <= `REG_OP_SP;
    //         wb_data_op <= `WB_DATA_OP_ALU;
    //         wb_addr_op <= `WB_ADDR_OP_NOP;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_NOP;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_NOP: begin
    //         ALU_op <= `ALU_OP_NOP;
    //         ALU_A_op <= `ALU_A_OP_NOP;
    //         ALU_B_op <= `ALU_B_OP_NOP;
    //         REG_op <= `REG_OP_NOP;
    //         wb_data_op <= `WB_DATA_OP_NOP;
    //         wb_addr_op <= `WB_ADDR_OP_NOP;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_NOP;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_OR: begin
    //         ALU_op <= `ALU_OP_OR;
    //         ALU_A_op <= `ALU_A_OP_REGA;
    //         ALU_B_op <= `ALU_B_OP_REGB;
    //         REG_op <= `REG_OP_REG;
    //         wb_data_op <= `WB_DATA_OP_ALU;
    //         wb_addr_op <= `WB_ADDR_OP_RX;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_NOP;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_SLL: begin
    //         ALU_op <= `ALU_OP_SLL;
    //         ALU_A_op <= `ALU_A_OP_RZ;
    //         ALU_B_op <= `ALU_B_OP_REGB;
    //         REG_op <= `REG_OP_REG;
    //         wb_data_op <= `WB_DATA_OP_ALU;
    //         wb_addr_op <= `WB_ADDR_OP_RX;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_NOP;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_SLLV: begin
    //         ALU_op <= `ALU_OP_SLLV;
    //         ALU_A_op <= `ALU_A_OP_REGA;
    //         ALU_B_op <= `ALU_B_OP_REGB;
    //         REG_op <= `REG_OP_REG;
    //         wb_data_op <= `WB_DATA_OP_ALU;
    //         wb_addr_op <= `WB_ADDR_OP_RY;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_NOP;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_SRA: begin
    //         ALU_op <= `ALU_OP_SRA;
    //         ALU_A_op <= `ALU_A_OP_RZ;
    //         ALU_B_op <= `ALU_B_OP_REGB;
    //         REG_op <= `REG_OP_REG;
    //         wb_data_op <= `WB_DATA_OP_ALU;
    //         wb_addr_op <= `WB_ADDR_OP_RX;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_NOP;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_SRL: begin
    //         ALU_op <= `ALU_OP_SRL;
    //         ALU_A_op <= `ALU_A_OP_RZ;
    //         ALU_B_op <= `ALU_B_OP_REGB;
    //         REG_op <= `REG_OP_REG;
    //         wb_data_op <= `WB_DATA_OP_ALU;
    //         wb_addr_op <= `WB_ADDR_OP_RX;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_NOP;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_SUBU: begin
    //         ALU_op <= `ALU_OP_SUB;
    //         ALU_A_op <= `ALU_A_OP_REGA;
    //         ALU_B_op <= `ALU_B_OP_REGB;
    //         REG_op <= `REG_OP_REG;
    //         wb_data_op <= `WB_DATA_OP_ALU;
    //         wb_addr_op <= `WB_ADDR_OP_RZ;
    //         RAM_en <= `RAM_DISABLE;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_NOP;
    //         ram_data_op <= RAM_DATA_OP_NOP;
    //     end

    //     `INST_CTL_SW: begin
    //         ALU_op <= `ALU_OP_ADD;
    //         ALU_A_op <= `ALU_A_OP_REGA;
    //         ALU_B_op <= `ALU_B_OP_IM;
    //         REG_op <= `REG_OP_NOP;
    //         wb_data_op <= `WB_DATA_OP_NOP;
    //         wb_addr_op <= `WB_ADDR_OP_NOP;
    //         RAM_en <= `RAM_ENABLE;
    //         RAM_op <= `RAM_OP_WR;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_S_E_4_0;
    //         ram_data_op <= RAM_DATA_OP_REGB;
    //     end

    //     `INST_CTL_SW_RS: begin
    //         ALU_op <= `ALU_OP_ADD;
    //         ALU_A_op <= `ALU_A_OP_SP;
    //         ALU_B_op <= `ALU_B_OP_IM;
    //         REG_op <= `REG_OP_NOP;
    //         wb_data_op <= `WB_DATA_OP_NOP;
    //         wb_addr_op <= `WB_ADDR_OP_NOP;
    //         RAM_en <= `RAM_ENABLE;
    //         RAM_op <= `RAM_OP_WR;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_S_E_7_0;
    //         ram_data_op <= RAM_DATA_OP_RA;
    //     end

    //     `INST_CTL_SW_SP: begin
    //         ALU_op <= `ALU_OP_ADD;
    //         ALU_A_op <= `ALU_A_OP_SP;
    //         ALU_B_op <= `ALU_B_OP_IM;
    //         REG_op <= `REG_OP_NOP;
    //         wb_data_op <= `WB_DATA_OP_NOP;
    //         wb_addr_op <= `WB_ADDR_OP_NOP;
    //         RAM_en <= `RAM_ENABLE;
    //         RAM_op <= `RAM_OP_WR;
    //         jump_en_op <= `JUMP_EN_OP_NOP;
    //         jump_data_op <= `JUMP_DATA_NOP;
    //         im_op <= `IM_OP_S_E_7_0;
    //         ram_data_op <= RAM_DATA_OP_REGA;
    //     end
    // endcase
end

endmodule

`endif
