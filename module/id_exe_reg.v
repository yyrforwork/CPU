`ifdef _ie_
`else
`define _ie_
`include "define.v"

module ie(
    input                        clk,
    input                        rst,
    input wire ie_PAUSE,

    //**************input*************
    input wire[`INSTRUCTION_BUS] inst,
    
    //wb op
    input wire[`WB_DATA_OP_BUS] n_ie_DATA_op,
    input wire[`REG_OP_BUS]     n_ie_REG_op,
    
    //mem op
    input wire                  n_ie_RAM_en,
    input wire                  n_ie_RAM_op,

    //exe op
    input wire[`ALU_OP_BUS]         n_ie_ALU_op,
    input wire[`JUMP_DATA_BUS]      n_ie_JUMP_DATA_op,
    input wire[`JUMP_EN_OP_BUS]     n_ie_JUMP_EN_op,
    input wire[`ALU_A_OP_BUS]       n_ie_ALU_A_op,
    input wire[`ALU_B_OP_BUS]       n_ie_ALU_B_op,
    input wire[`IM_OP_BUS]          n_ie_IM_op,
    input wire[`WB_ADDR_OP_BUS]     n_ie_WB_ADDR_op,
    input wire[`RAM_W_DATA_OP_BUS]  n_ie_RAM_W_DATA_op,

    //regs
    input wire[`DATA_BUS] n_ie_REGA,
    input wire[`DATA_BUS] n_ie_REGB,
    input wire[`DATA_BUS] n_ie_IH,
    input wire[`DATA_BUS] n_ie_SP,
    input wire[`DATA_BUS] n_ie_RA,
    input wire[`DATA_BUS] n_ie_T,

    //im
    input wire[`PC_BUS]   n_ie_PC,
    input wire[`DATA_BUS] n_ie_s_e_10_0,
    input wire[`DATA_BUS] n_ie_s_e_7_0,
    input wire[`DATA_BUS] n_ie_s_e_4_0,
    input wire[`DATA_BUS] n_ie_s_e_3_0,
    input wire[`DATA_BUS] n_ie_z_e_7_0,

    //******************output*************

        //wb op
    output reg[`WB_DATA_OP_BUS] ie_DATA_op,
    output reg[`REG_OP_BUS]     ie_REG_op,
    
    //mem op
    output reg[`RAM_EN_OP_BUS]  ie_RAM_EN_op,
    output reg[`RAM_OP_BUS]     ie_RAM_op,

    //exe op
    output reg[`ALU_OP_BUS]         ie_ALU_op,
    output reg[`JUMP_DATA_BUS]      ie_JUMP_DATA_op,
    output reg[`JUMP_EN_OP_BUS]     ie_JUMP_EN_op,
    output reg[`ALU_A_OP_BUS]       ie_ALU_A_op,
    output reg[`ALU_B_OP_BUS]       ie_ALU_B_op,
    output reg[`IM_OP_BUS]          ie_IM_op,
    output reg[`WB_ADDR_OP_BUS]     ie_WB_ADDR_op,
    output reg[`RAM_W_DATA_OP_BUS]  ie_RAM_W_DATA_op,

    //regs
    output reg[`DATA_BUS] ie_REGA,
    output reg[`DATA_BUS] ie_REGB,
    output reg[`DATA_BUS] ie_IH,
    output reg[`DATA_BUS] ie_SP,
    output reg[`DATA_BUS] ie_RA,
    output reg[`DATA_BUS] ie_T,

    //im
    output reg[`PC_BUS]   ie_PC,
    output reg[`DATA_BUS] ie_s_e_10_0,
    output reg[`DATA_BUS] ie_s_e_7_0,
    output reg[`DATA_BUS] ie_s_e_4_0,
    output reg[`DATA_BUS] ie_s_e_3_0,
    output reg[`DATA_BUS] ie_z_e_7_0,

    //wb addr
    output reg[`REG_ADDR_BUS] ie_REG_ADDR_RX,
    output reg[`REG_ADDR_BUS] ie_REG_ADDR_RY,
    output reg[`REG_ADDR_BUS] ie_REG_ADDR_RZ,
    );

    always @(posedge clk , posedge rst) begin
        if (rst) begin
            // reset
            
        end
        else
        if (ie_PAUSE != `PAUSE_ENABLE) begin
            //wb op
            ie_DATA_OP   <= n_ie_DATA_OP;
            ie_REG_OP    <= n_ie_REG_OP;
            
            //mem op
            ie_RAM_EN_OP <= n_ie_RAM_EN_OP;
            ie_RAM_OP    <= n_ie_RAM_OP;

            //exe op
            ie_ALU_OP       <=n_ie_ALU_OP;   
            ie_JUMP_DATA_OP <=n_ie_JUMP_DATA_OP;
            ie_JUMP_EN_OP   <=n_ie_RAM_EN_OP;
            ie_ALU_A_OP     <=n_ie_ALU_A_OP;
            ie_ALU_B_OP     <=n_ie_ALU_B_OP;
            ie_IM_OP        <=n_ie_IM_OP;
            ie_WB_ADDR_OP   <=n_ie_WB_ADDR_OP;
            ie_RAM_W_DATA_OP<=n_ie_RAM_W_DATA_OP;

            //regs
            ie_REGA <=n_ie_REGA;
            ie_REGB <=n_ie_REGB;
            ie_IH   <=n_ie_IH;
            ie_SP   <=n_ie_SP;
            ie_RA   <=n_ie_RA;
            ie_T    <=n_ie_T;

            //im
            ie_PC      <= n_ie_PC;
            ie_s_e_10_0<= n_ie_s_e_10_0;
            ie_s_e_7_0 <= n_ie_s_e_7_0;
            ie_s_e_4_0 <= n_ie_s_e_4_0;
            ie_s_e_3_0 <= n_ie_s_e_3_0;
            ie_z_e_7_0 <= n_ie_z_e_7_0;

            //wb addr
            ie_REG_ADDR_RX <=inst[`INST_RX_ADDR];
            ie_REG_ADDR_RY <=inst[`INST_RY_ADDR];
            ie_REG_ADDR_RZ <=inst[`INST_RZ_ADDR];   
        end
    end

endmodule
`endif