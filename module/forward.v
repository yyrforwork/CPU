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

        input      [`ALU_A_OP_BUS]    op1_mux_op,
        input      [`ALU_B_OP_BUS]    op2_mux_op,
        input      [`REG_OP_BUS]      emo_reg_op,
        input      [`REG_OP_BUS]      mwo_reg_op,
        input      [`WB_DATA_OP_BUS]  emo_wb_data_op,
        input      [`WB_DATA_OP_BUS]  mwo_wb_data_op,

        input      [`RAM_DATA_OP_BUS] ram_data_op,

        output reg [`DATA_BUS]        reg1_forward_data,
        output reg [`DATA_BUS]        reg2_forward_data,
        output reg [`DATA_BUS]        mux_forward_data,

        output reg                    reg1_forward_enable,
        output reg                    reg2_forward_enable,
        output reg                    mux_forward_enable,

        //IH part
        input      [`DATA_BUS]        ieo_ih,
        output reg [`DATA_BUS]        emi_ih
    );

reg [`DATA_BUS] emo_data;
reg [`DATA_BUS] mwo_data;

always @(*) begin
    case(emo_wb_data_op)
        `WB_DATA_OP_ALU : emo_data = emo_alu_answer;
        `WB_DATA_OP_MEM : emo_data = `DATA_ZERO;
        `WB_DATA_OP_IH  : emo_data = emo_IH_wb_data;
        `WB_DATA_OP_PC  : emo_data = emo_PC_wb_data;
        `WB_DATA_OP_NOP : emo_data = `DATA_ZERO;
        default: emo_data = `DATA_ZERO;
    endcase

    case(mwo_wb_data_op)
        `WB_DATA_OP_ALU : mwo_data = mwo_alu_answer;
        `WB_DATA_OP_MEM : mwo_data = mwo_ram_read_answer;
        `WB_DATA_OP_IH  : mwo_data = mwo_IH_wb_data;
        `WB_DATA_OP_PC  : mwo_data = mwo_PC_wb_data;
        `WB_DATA_OP_NOP : mwo_data = `DATA_ZERO;
        default: mwo_data = `DATA_ZERO;
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
                        reg1_forward_data   = emo_data;
                        reg1_forward_enable = `FORWARD_ENABLE;
                    end else begin
                        reg1_forward_data   = `DATA_ZERO;
                        reg1_forward_enable = `FORWARD_DISABLE;
                    end
                end else begin
                    reg1_forward_data   = `DATA_ZERO;
                    reg1_forward_enable = `FORWARD_DISABLE;
                end
            end
        `REG_OP_SP:
            begin
                if (op1_mux_op == `ALU_A_OP_SP)
                begin
                    reg1_forward_data   = emo_data;
                    reg1_forward_enable = `FORWARD_ENABLE;
                end else begin
                    reg1_forward_data   = `DATA_ZERO;
                    reg1_forward_enable = `FORWARD_DISABLE;
                end
            end
        `REG_OP_T:
            begin
                if (op1_mux_op == `ALU_A_OP_T)
                begin
                    reg1_forward_data   = emo_data;
                    reg1_forward_enable = `FORWARD_ENABLE;
                end else begin
                    reg1_forward_data   = `DATA_ZERO;
                    reg1_forward_enable = `FORWARD_DISABLE;
                end
            end
        default:
            begin
                reg1_forward_data   = `DATA_ZERO;
                reg1_forward_enable = `FORWARD_DISABLE;
            end
    endcase

    if(~reg1_forward_enable) begin
        case(mwo_reg_op)
            `REG_OP_REG:
                begin
                    if (op1_mux_op == `ALU_A_OP_REGA)
                    begin
                        if (reg1_addr == mwo_wb_addr)
                        begin
                            reg1_forward_data   = mwo_data;
                            reg1_forward_enable = `FORWARD_ENABLE;
                        end else begin
                            reg1_forward_data   = `DATA_ZERO;
                            reg1_forward_enable = `FORWARD_DISABLE;
                        end
                    end else begin
                        reg1_forward_data   = `DATA_ZERO;
                        reg1_forward_enable = `FORWARD_DISABLE;
                    end
                end
            `REG_OP_SP:
                begin
                    if (op1_mux_op == `ALU_A_OP_SP)
                    begin
                        reg1_forward_data   = mwo_data;
                        reg1_forward_enable = `FORWARD_ENABLE;
                    end else begin
                        reg1_forward_data   = `DATA_ZERO;
                        reg1_forward_enable = `FORWARD_DISABLE;
                    end
                end
            `REG_OP_T:
                begin
                    if (op1_mux_op == `ALU_A_OP_T)
                    begin
                        reg1_forward_data   = mwo_data;
                        reg1_forward_enable = `FORWARD_ENABLE;
                    end else begin
                        reg1_forward_data   = `DATA_ZERO;
                        reg1_forward_enable = `FORWARD_DISABLE;
                    end
                end
            default: 
                begin
                    reg1_forward_data   = `DATA_ZERO;
                    reg1_forward_enable = `FORWARD_DISABLE;
                end
        endcase
    end

    case(emo_reg_op)
        `REG_OP_REG:
            begin
                if (op2_mux_op == `ALU_B_OP_REGB)
                begin
                    if (reg2_addr == emo_wb_addr)
                    begin
                        reg2_forward_data   = emo_data;
                        reg2_forward_enable = `FORWARD_ENABLE;
                    end else begin
                        reg2_forward_data   = `DATA_ZERO;
                        reg2_forward_enable = `FORWARD_DISABLE;
                    end
                end else begin
                    reg2_forward_data   = `DATA_ZERO;
                    reg2_forward_enable = `FORWARD_DISABLE;
                end
            end
        default:
            begin
                reg2_forward_data   = `DATA_ZERO;
                reg2_forward_enable = `FORWARD_DISABLE;
            end
    endcase

    if(~reg2_forward_enable) begin
        case(mwo_reg_op)
            `REG_OP_REG:
                begin
                    if (op2_mux_op == `ALU_B_OP_REGB)
                    begin
                        if (reg2_addr == mwo_wb_addr)
                        begin
                            reg2_forward_data   = mwo_data;
                            reg2_forward_enable = `FORWARD_ENABLE;
                        end else begin
                            reg2_forward_data   = `DATA_ZERO;
                            reg2_forward_enable = `FORWARD_DISABLE;
                        end
                    end else begin
                        reg2_forward_data   = `DATA_ZERO;
                        reg2_forward_enable = `FORWARD_DISABLE;
                    end
                end

            default: 
                begin
                    reg2_forward_data   = `DATA_ZERO;
                    reg2_forward_enable = `FORWARD_DISABLE;
                end
        endcase
    end

    case(emo_reg_op)
    `REG_OP_REG:
        begin
            if ((ram_data_op == `RAM_DATA_OP_REGA && reg1_addr == emo_wb_addr)
            || (ram_data_op == `RAM_DATA_OP_REGB && reg2_addr == emo_wb_addr))
            begin
                mux_forward_data   = emo_data;
                mux_forward_enable = `FORWARD_ENABLE;
            end else 
            begin
                mux_forward_data   = `DATA_ZERO;
                mux_forward_enable = `FORWARD_DISABLE;
            end
        end
    default:
        begin
            mux_forward_data   = `DATA_ZERO;
            mux_forward_enable = `FORWARD_DISABLE;
        end
    endcase

    if (~mux_forward_enable) begin
        case(mwo_reg_op)
        `REG_OP_REG:
            begin
                if ((ram_data_op == `RAM_DATA_OP_REGA && reg1_addr == mwo_wb_addr)
                || (ram_data_op == `RAM_DATA_OP_REGB && reg2_addr == mwo_wb_addr))
                begin
                    mux_forward_data   = mwo_data;
                    mux_forward_enable = `FORWARD_ENABLE;
                end else 
                begin
                    mux_forward_data   = `DATA_ZERO;
                    mux_forward_enable = `FORWARD_DISABLE;
                end
            end
        default:
            begin
                mux_forward_data   = `DATA_ZERO;
                mux_forward_enable = `FORWARD_DISABLE;
            end
        endcase
    end
    
    if (emo_reg_op == `REG_OP_IH) 
        emi_ih = emo_data;
    else begin
        if (mwo_reg_op == `REG_OP_IH)
            emi_ih = mwo_data;
        else begin
            emi_ih = ieo_ih;
        end
    end
end

endmodule

`endif