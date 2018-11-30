`timescale 1ns / 1ps

`ifdef _CPU_
`else
`define _CPU_
`include "define.v"
`include "sram.v"

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
// CPU
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

module CPU(
    input rst,
    input clk,
    input clk_50MHz,
    input clk_11MHz,

    // RAM1
    inout  [`DATA_BUS] ram1_data,
    output [`ADDR_BUS] ram1_addr,
    output ram1_en,
    output ram1_oe,
    output ram1_we,

    // RAM2
    inout  [`DATA_BUS] ram2_data,
    output [`ADDR_BUS] ram2_addr,
    output ram2_en,
    output ram2_oe,
    output ram2_we,

    // UART
    input  tsre,
    input  tbre,
    input  data_ready,
    output rdn,
    output wrn,

    // Other
   );

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
// clk_25MHz
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

reg clk_25MHz;
always @ (posedge clk_50MHz, negedge rst)
begin
  if (!rst)
    clk_25MHz = 0;
  else
    clk_25MHz = ~ clk_25MHz;
end

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
// RAM1
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

// ram1 declaration
wire[`DATA_BUS] ram1_ctl_data_o;
reg [`DATA_BUS] ram1_ctl_data_i;
reg [`ADDR_BUS] ram1_ctl_addr;
reg ram1_ctl_op;
reg ram1_ctl_en;

// ram1 combination
sram ram1(
        .rst(rst),
        .clk_50MHz(clk_50MHz),

        .sram_data(ram1_data),
        .sram_addr(ram1_addr),
        .sram_en(ram1_en),
        .sram_oe(ram1_oe),
        .sram_we(ram1_we),

        .data_o(ram1_ctl_data_o),
        .data_i(ram1_ctl_data_i),
        .addr(ram1_ctl_addr),
        .op(ram1_ctl_op),
        .en(ram1_ctl_en)
    );

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
// RAM2
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

// ram2 declaration
wire[`DATA_BUS] ram2_ctl_data_o;
reg [`DATA_BUS] ram2_ctl_data_i;
reg [`ADDR_BUS] ram2_ctl_addr;
reg ram2_ctl_op;
reg ram2_ctl_en;

// ram2 combination
sram ram2(
        .rst(rst),
        .clk_50MHz(clk_50MHz),

        .sram_data(ram2_data),
        .sram_addr(ram2_addr),
        .sram_en(ram2_en),
        .sram_oe(ram2_oe),
        .sram_we(ram2_we),

        .data_o(ram2_ctl_data_o),
        .data_i(ram2_ctl_data_i),
        .addr(ram2_ctl_addr),
        .op(ram2_ctl_op),
        .en(ram2_ctl_en)
    );


//############# WIRE OUT OF PIPE ######
/*wire[`PC_BUS] jump_MUX_pc_out;   
wire pc_pause;
wire */
//############# IF ####################

//PC module
wire pc_pause;
wire[`PC_BUS] pc_in_pc;
wire[`PC_BUS] pc_out_pc;

assign pc_pause = ;
assign pc_in_pc = ;
PC pc(
    .rst(rst),
    .clk_50Mhz(clk_50MHz),
    .PC_pause(pc_pause),
    .PC_in(pc_in_pc),
    .PC_out(pc_out_pc)
    )

//PC_Adder
wire[`PC_BUS] pc_a_in_pc;
wire[`PC_BUS] pc_a_out_pc;

assign pc_a_in_pc = pc_out_pc ;
PC_Adder pc_a(
    .old_PC(pc_a_in_pc),
    .new_PC(pc_a_out_pc)
    ) 

//instuction ram
wire[`PC_BUS] inst_ram_in_addr;
wire[`INSTUCTION_BUS] inst_ram_out_inst;

SRAM2 inst_ram(
    .addr(inst_ram_in_addr),
    .ins(inst_ram_out_inst)
    )

//############# IF end

//############# IF/ID #################

wire iii_pause;
wire iii_clear;
wire[`INSTUCTION_BUS] iii_inst;
wire[`INSTUCTION_BUS] iio_inst;
wire[`PC_BUS] iii_pca;
wire[`PC_BUS] iio_pca;

assign iii_pause = ;
assign iii_clear = ;
assign iii_inst = inst_ram_out_inst;
assign iii_pca = pc_a_out_pc;

IF_ID_REG if_id_reg(
    .rst(rst),
    .clk(clk),
    .if_id_pause(iii_pause),
    .if_id_clear(iii_clear),
    .ram_out_ins(iii_inst),
    .pc_add_value(iii_pca),
    .IF_ID_ins(iio_inst)
    .IF_ID_PC(iio_pca),
    );
//############# IF_ID_end

//############# ID ####################

//main_control
wire[`INSTUCTION_BUS] mci_inst;
wire[`ALU_OP_BUS] mco_alu_op;
wire[`ALU_A_OP_BUS] mco_alu_A_op;
wire[`ALU_B_OP_BUS] mco_alu_B_op;
wire[`REG_OP_BUS] mco_reg_op;
wire[`WB_DATA_OP_BUS] mco_wb_data_op;
wire[`WB_ADDR_OP_BUS] mco_wb_addr_op;
wire mco_ram_en;
wire mco_ram_op;
wire[`JUMP_EN_OP_BUS] mco_jump_en_op;
wire[`JUMP_DATA_OP_BUS] mco_jump_data_op;
wire[`IM_OP_BUS] mco_im_op;
wire[`RAM_DATA_OP_BUS] mco_ram_data_op;

assign mci_inst = iio_inst;

Control main_control(
    .rst(rst),
    .clk_50Mhz(clk),
    .inst(mci_inst),

    .ALU_op(mco_alu_op),
    .ALU_A_op(mco_alu_A_op),
    .ALU_B_op(mco_alu_B_op),
    
    .REG_op(mco_reg_op),
    .wb_data_op(mco_wb_data_op),
    .wb_addr_op(mco_wb_addr_op),
    
    .RAM_en(mco_ram_en),
    .RAM_op(mco_ram_op),
    .jump_en_op(mco_jump_en_op),
    .jump_data_op(mco_jump_data_op),
    .im_op(mco_im_op),
    .ram_data_op(mco_ram_data_op),
    )

//reg_files
wire[`REG_ADDR_BUS] reg_files_in_a_addr;
wire[`REG_ADDR_BUS] reg_files_in_b_addr;
wire[`REG_ADDR_BUS] reg_files_in_wb_addr;
wire[`DATA_BUS] reg_files_in_wb_data;
wire[`REG_OP_BUS] reg_files_in_reg_op;

wire[`DATA_BUS] reg_files_out_a_data;
wire[`DATA_BUS] reg_files_out_b_data;
wire[`DATA_BUS] reg_files_out_t_data;
wire[`DATA_BUS] reg_files_out_sp_data;
wire[`DATA_BUS] reg_files_out_ih_data;
wire[`DATA_BUS] reg_files_out_ra_data;

assign reg_files_in_a_addr = iio_inst[`INST_RX_ADDR];
assign reg_files_in_b_addr = iio_inst[`INST_RY_ADDR];
assign reg_files_in_wb_addr = ;
assign reg_files_in_wb_data = ;
assign reg_files_in_reg_op = ;

REG_File regs(
    .rst(rst),
    .clk_50MHz(clk_50MHz),
    .A_addr(reg_files_in_a_addr),
    .B_addr(reg_files_in_b_addr),
    .wb_addr(reg_files_in_wb_addr),
    .wb_data(reg_files_in_wb_data),
    .reg_op(reg_files_in_reg_op),
    .A_data(reg_files_out_a_data),
    .B_data(reg_files_out_b_data),
    .T_data(reg_files_out_t_data),
    .SP_data(reg_files_out_sp_data),
    .IH_data(reg_files_out_ih_data),
    .RA_data(reg_files_out_ra_data),
    )

//entender
wire[`INSTUCTION_BUS] ex_in_inst;

wire[`DATA_BUS] ex_out_z_e_7_0;
wire[`DATA_BUS] ex_out_s_e_10_0;
wire[`DATA_BUS] ex_out_s_e_7_0;
wire[`DATA_BUS] ex_out_s_e_4_0;
wire[`DATA_BUS] ex_out_s_e_3_0;

assign ex_in_inst = iio_inst;
Extender ex(
    .inst(ex_in_inst),
    .z_e_7_0(ex_out_z_e_7_0)
    .s_e_10_0(ex_out_s_e_10_0),
    .s_e_7_0(ex_out_s_e_7_0),
    .s_e_4_0(ex_out_s_e_4_0),
    .s_e_3_0(ex_out_s_e_3_0)
    )

//pause control
wire[`REG_OP_BUS] p_c_in_reg_op;
wire[`REG_ADDR_BUS] p_c_in_wb_addr;
wire[`REG_ADDR_BUS] p_c_in_reg1_addr;
wire[`REG_ADDR_BUS] p_c_in_reg2_addr;
wire[`ALU_A_OP_BUS] p_c_in_alu_a_op;
wire[`ALU_B_OP_BUS] p_c_in_alu_b_op;

wire p_c_out_pc_pause;
wire p_c_out_ii_pause;
wire p_c_out_ie_pause;

assign p_c_in_reg_op = ;
assign p_c_in_wb_addr = ;
assign p_c_in_reg1_addr = iio_inst[`INST_RX_ADDR];
assign p_c_in_reg2_addr = iio_inst[`INST_RY_ADDR];
assign p_c_in_alu_a_op = mco_alu_A_op;
assign p_c_in_alu_b_op = mco_alu_B_op;

Pause_Control p_c(
    .reg_op(p_c_in_reg_op),
    .wb_addr(p_c_in_wb_addr),
    .reg1_addr(p_c_in_reg1_addr),
    .reg2_addr(p_c_in_reg2_addr),
    .alu_a_op(p_c_in_alu_a_op),
    .alu_b_op(p_c_in_alu_b_op),

    .PC_pause(p_c_out_pc_pause,
    .ii_pasu3(p_c_out_ii_pause),
    .ie_pause(p_c_out_ie_pause)
    )
//############# ID end

//############# ID/EXE ################
wire iei_pause;
wire[`INSTUCTION_BUS] iei_inst;
wire[`WB_DATA_OP_BUS] iei_data_op;
wire[`REG_OP_BUS] iei_reg_op;
wire iei_ram_en;
wire iei_ram_op;

wire[`ALU_OP_BUS] iei_alu_op;
wire[`JUMP_DATA_OP_BUS] iei_jump_data_op;
wire[`JUMP_EN_OP_BUS] iei_jump_en_op;
wire[`ALU_A_OP_BUS] iei_alu_a_op;
wire[`ALU_B_OP_BUS] iei_alu_b_op;
wire[`IM_OP_BUS] iei_im_op;
wire[`WB_ADDR_OP_BUS] iei_wb_addr_op;
wire[`RAM_DATA_op_BUS] iei_ram_data_op;

wire[`DATA_BUS] iei_rega;
wire[`DATA_BUS] iei_regb;
wire[`DATA_BUS] iei_ih;
wire[`DATA_BUS] iei_sp;
wire[`DATA_BUS] iei_ra;
wire[`DATA_BUS] iei_t;

wire[`PC_BUS] iei_pc;
wire[`DATA_BUS] iei_s_e_10_0;
wire[`DATA_BUS] iei_s_e_7_0;
wire[`DATA_BUS] iei_s_e_4_0;
wire[`DATA_BUS] iei_s_e_3_0;
wire[`DATA_BUS] iei_z_e_7_0;

//******************************************
wire[`WB_DATA_OP_BUS] ieo_data_op;
wire[`REG_OP_BUS] ieo_reg_op;
wire ieo_ram_en;
wire ieo_ram_op;

wire[`ALU_OP_BUS] ieo_alu_op;
wire[`JUMP_DATA_OP_BUS] ieo_jump_data_op;
wire[`JUMP_EN_OP_BUS] ieo_jump_en_op;
wire[`ALU_A_OP_BUS] ieo_alu_a_op;
wire[`ALU_B_OP_BUS] ieo_alu_b_op;
wire[`IM_OP_BUS] ieo_im_op;
wire[`WB_ADDR_OP_BUS] ieo_wb_addr_op;
wire[`RAM_DATA_op_BUS] ieo_ram_data_op;

wire[`DATA_BUS] ieo_rega;
wire[`DATA_BUS] ieo_regb;
wire[`DATA_BUS] ieo_ih;
wire[`DATA_BUS] ieo_sp;
wire[`DATA_BUS] ieo_ra;
wire[`DATA_BUS] ieo_t;

wire[`PC_BUS] ieo_pc;
wire[`DATA_BUS] ieo_s_e_10_0;
wire[`DATA_BUS] ieo_s_e_7_0;
wire[`DATA_BUS] ieo_s_e_4_0;
wire[`DATA_BUS] ieo_s_e_3_0;
wire[`DATA_BUS] ieo_z_e_7_0;

wire[`REG_ADDR_BUS] ieo_reg_addr_rx;
wire[`REG_ADDR_BUS] ieo_reg_addr_ry;
wire[`REG_ADDR_BUS] ieo_reg_addr_rz;

//*************************************

assign  = ;

ID_EXE ie(
    .rst(rst),
    .clk_50MHz(clk_50MHz),
    .ie_PAUSE(iei_pause),

    .inst(iei_inst),
    
    .n_ie_DATA_op(iei_data_op),
    .n_ie_REG_op(iei_reg_op),

    .n_ie_RAM_en(iei_ram_en),
    .n_ie_RAM_op(iei_ram_op),

    .n_ie_ALU_op(iei_alu_op),
    .n_ie_JUMP_DATA_op(iei_jump_data_op),
    .n_ie_JUMP_EN_OP(iei_jump_en_op),
    .n_ie_ALU_A_op(iei_alu_a_op),
    .n_ie_ALU_B_op(iei_alu_b_op),
    .n_ie_IM_op(iei_im_op),
    .n_ie_WB_ADDR_op(iei_wb_addr_op),
    .n_ie_RAM_DATA_op(iei_ram_data_op),

    .n_ie_REGA(iei_rega),
    .n_ie_REGB(iei_regb),
    .n_ie_IH(iei_ih),
    .n_ie_SP(iei_sp),
    .n_ie_RA(iei_ra),
    .n_ie_T(iei_t),

    .n_ie_PC(iei_pc),
    .n_ie_s_e_10_0(iei_s_e_10_0),
    .n_ie_s_e_7_0(iei_s_e_7_0),
    .n_ie_s_e_4_0(iei_s_e_4_0),
    .n_ie_s_e_3_0(iei_s_e_3_0),
    .n_ie_z_e_7_0(iei_z_e_7_0),
//*****************************
    .ie_DATA_op(ieo_data_op),
    .ie_REG_op(ieo_reg_op),

    .ie_RAM_en(ieo_ram_en),
    .ie_RAM_op(ieo_ram_op),

    .ie_ALU_op(ieo_alu_op),
    .ie_JUMP_DATA_op(ieo_jump_data_op),
    .ie_JUMP_EN_OP(ieo_jump_en_op),
    .ie_ALU_A_op(ieo_alu_a_op),
    .ie_ALU_B_op(ieo_alu_b_op),
    .ie_IM_op(ieo_im_op),
    .ie_WB_ADDR_op(ieo_wb_addr_op),
    .ie_RAM_DATA_op(ieo_ram_data_op),

    .ie_REGA(ieo_rega),
    .ie_REGB(ieo_regb),
    .ie_IH(ieo_ih),
    .ie_SP(ieo_sp),
    .ie_RA(ieo_ra),
    .ie_T(ieo_t),

    .ie_PC(ieo_pc),
    .ie_s_e_10_0(ieo_s_e_10_0),
    .ie_s_e_7_0(ieo_s_e_7_0),
    .ie_s_e_4_0(ieo_s_e_4_0),
    .ie_s_e_3_0(ieo_s_e_3_0),
    .ie_z_e_7_0(ieo_z_e_7_0),

    .ie_REG_ADDR_RX(ieo_reg_addr_rx),
    .ie_REG_ADDR_RY(ieo_reg_addr_ry),
    .ie_REG_ADDR_RZ(ieo_reg_addr_rz)

    )

//############# EXE ###################

//forward

//opA mux
wire[`DATA_BUS] alu_a;
ALU_A_Mux alu_a_mux(
    .data_T(ieo_t),
    .data_SP(ieo_sp),
    .data_RZ(ieo_reg_addr_rz),
    .data_REGA(ieo_rega),
    .data_FOWD(),
    .ALU_A_FOWD_en(),
    .ALU_A_op(ieo_alu_a_op),
    .ALU_A_data(alu_a)
    )

//opB mux
wire[`DATA_BUS] alu_b;
ALU_B_Mux alu_b_mux(
    .data_IM(im_out),
    .data_REGB(ieo_regb),
    .data_FOWD(),
    .ALU_B_FOWD_en(),
    .ALU_B_op(ieo_alu_b_op),
    .ALU_B_data(alu_b)
    )

//im mux
wire[`DATA_BUS] im_out;
Im_Mux im_mux(
    .im_s_e3_0(ieo_s_e_3_0),
    .im_s_e4_0(ieo_s_e_4_0),
    .im_s_e7_0(ieo_s_e_7_0),
    .im_s_e10_0(ieo_s_e_10_0),
    .im_z_e7_0(ieo_z_e_7_0),
    .im_op(ieo_im_op),
    .im_out(im_out)
    )

//wb_addr mux
wire[`REG_ADDR_BUS] wb_addr;
WB_Addr_Mux wb_addr_Mux(
    .wb_addr_op(ieo_wb_addr_op),
    .rx_addr(ieo_reg_addr_rx),
    .ry_addr(ieo_reg_addr_ry),
    .rz_addr(ieo_reg_addr_rz),
    .wb_addr(wb_Addr)
    )

//alu
//############# EXE/MEM ###############
//############# MEM ###################
//############# MEM/WB ################
//############# WB ####################



endmodule

`endif