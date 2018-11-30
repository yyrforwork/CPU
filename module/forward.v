`timescale 1ns / 1ps

`ifdef _FORWARD_
`else
`define _FORWARD_
`include "define.v"

module Forward(
        input      [`PC_BUS]          emo_PC_wb_data,
        input      [`PC_BUS]          mwo_PC_wb_data,
        input      [`DATA_BUS]        emo_IH_wb_data,
        input      [`DATA_BUS]        mwo_IH_wb_data,
        input      [`DATA_BUS]        emo_alu_answer,
        input      [`DATA_BUS]        mwo_alu_answer,
        input      [`DATA_BUS]        mwo_ram_read_answer,

        input      [`REG_ADDR_BUS]    reg1_addr,
        input      [`REG_ADDR_BUS]    reg2_addr,
        input      [`REG_ADDR_BUS]    emo_wb_addr,
        input      [`REG_ADDR_BUS]    mwo_wb_addr,

        input      [`ALU_OP1_MUX_BUS] op1_mux_op,
        input      [`ALU_OP2_MUX_BUS] op2_mux_op,
        input      [`REG_OP_BUS]      emo_reg_op,
        input      [`REG_OP_BUS]      mwo_reg_op,
        input      [`WB_DATA_OP_BUS]  emo_wb_data_op,
        input      [`WB_DATA_OP_BUS]  mwo_wb_dada_op,

        output reg [`DATA_BUS]        reg1_forward_data,
        output reg [`DATA_BUS]        reg2_forward_data,
            
        output reg                    reg1_forward_enable,
        output reg                    reg2_forward_enable,
    );

reg [`DATA_BUS] out1_data;
reg [`DATA_BUS] out2_data;

always @(*) begin
    case(emo_wb_data_op)
        `WB_DATA_OP_ALU : out1_data <= emo_alu_answer;
        `WB_DATA_OP_MEM : out1_data <= `DATA_ZERO;
        `WB_DATA_OP_IH  : out1_data <= emo_IH_wb_data;
        `WB_DATA_OP_PC  : out1_data <= emo_PC_wb_data;
        `WB_DATA_OP_NOP : out1_data <= `DATA_ZERO;
        default: out1data <= `DATA_ZERO;
    endcase

    case(mwo_wb_data_op)
        `WB_DATA_OP_ALU : out2_data <= mwo_alu_answer;
        `WB_DATA_OP_MEM : out2_data <= mwo_ram_read_answer;
        `WB_DATA_OP_IH  : out2_data <= mwo_IH_wb_data;
        `WB_DATA_OP_PC  : out2_data <= mwo_PC_wb_data;
        `WB_DATA_OP_NOP : out2_data <= `DATA_ZERO;
        default: out2_data <= `DATA_ZERO;
    endcase
end

always @(*) begin
    case(emo_reg_op)
        `REG_OP_REG:
            begin
                if (op1_mux_op == `ALU_A_OP_REGA)
                begin
                    if (reg1_addr == emo_wb_addr)
                    begin
                        reg1_forward_data   <= out1_data 
                        reg1_forward_enable <= `FORWARD_ENABLE;
                    end else begin
                        reg1_forward_data   <= `DATA_ZERO;
                        reg1_forward_enable <= `FORWARD_DISABLE;
                    end
                end else begin
                    reg1_forward_data   <= `DATA_ZERO;
                    reg1_forward_enable <= `FORWARD_DISABLE;
                end
                reg2_forward_data   <= `DATA_ZERO;
                reg2_forward_enable <= `FORWARD_DISABLE;
            end
        `REG_OP_IH:
            begin
                if (op1_mux_op == `ALU_A_OP_IH)
                begin
                    reg1_forward_data   <= out1_data; 
                    reg1_forward_enable <= `FORWARD_ENABLE;
                end else begin
                    reg1_forward_data   <= `DATA_ZERO;
                    reg1_forward_enable <= `FORWARD_DISABLE;
                end
                reg2_forward_data   <= `DATA_ZERO;
                reg2_forward_enable <= `FORWARD_DISABLE;
            end
        `REG_OP_SP:
            begin
                if (op1_mux_op == `ALU_A_OP_SP)
                begin
                    reg1_forward_data   <= out1_data;
                    reg1_forward_enable <= `FORWARD_ENABLE;
                end else begin
                    reg1_forward_data   <= `DATA_ZERO;
                    reg1_forward_enable <= `FORWARD_DISABLE;
                end
                reg2_forward_data   <= `DATA_ZERO;
                reg2_forward_enable <= `FORWARD_DISABLE;
            end
        `REG_OP_T:
            begin
                if (op1_mux_op == `ALU_A_OP_T)
                begin
                    reg1_forward_data   <= out1_data;
                    reg1_forward_enable <= `FORWARD_ENABLE;
                end else begin
                    reg1_forward_data   <= `DATA_ZERO;
                    reg1_forward_enable <= `FORWARD_DISABLE;
                end
                reg2_forward_data   <= `DATA_ZERO;
                reg2_forward_enable <= `FORWARD_DISABLE;
            end
        default: 
            begin
                reg1_forward_data   <= `DATA_ZERO;
                reg1_forward_enable <= `FORWARD_DISABLE;
                reg2_forward_data   <= `DATA_ZERO;
                reg2_forward_enable <= `FORWARD_DISABLE;
            end
    endcase

    case(mwo_reg_op)
        `REG_OP_REG:
            begin
                if (op2_mux_op == `ALU_A_OP_REGA)
                begin
                    if (reg1_addr == emo_wb_addr)
                    begin
                        reg1_forward_data   <= out1_data 
                        reg1_forward_enable <= `FORWARD_ENABLE;
                    end else begin
                        reg1_forward_data   <= `DATA_ZERO;
                        reg1_forward_enable <= `FORWARD_DISABLE;
                    end
                end else begin
                    reg1_forward_data   <= `DATA_ZERO;
                    reg1_forward_enable <= `FORWARD_DISABLE;
                end
                reg2_forward_data   <= `DATA_ZERO;
                reg2_forward_enable <= `FORWARD_DISABLE;
            end

        default: 
            begin
                reg1_forward_data   <= `DATA_ZERO;
                reg1_forward_enable <= `FORWARD_DISABLE;
                reg2_forward_data   <= `DATA_ZERO;
                reg2_forward_enable <= `FORWARD_DISABLE;
            end
    endcase
end

endmodule

`endif