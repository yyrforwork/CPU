`timescale 1ns / 1ps

`ifdef _CPU_
`else
`define _CPU_
`include "define.v"

`include "ALU_A_Mux.v"
`include "ALU_B_Mux.v"
`include "ALU.v"
`include "Control.v"
`include "EXE_MEM.v"
`include "Extender.v"
`include "Forward.v"
`include "ID_EXE.v"
`include "IF_ID.v"
`include "Im_Mux.v"
`include "Jump_Add.v"
`include "Jump_Control.v"
`include "Jump_Data_Mux.v"
`include "Jump_En_Mux.v"
`include "MEM_WB.v"
`include "Pause_Control.v"
`include "PC_Adder.v"
`include "PC_Jump_Mux.v"
`include "PC.v"
`include "RAM_Data_Mux.v"
`include "REG_File.v"
`include "ram.v"
`include "WB_Addr_Mux.v"
`include "WB_Data_Mux.v"
`include "RAM_SIM1.v"
`include "RAM_SIM2.v"
`include "vga.v"

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
    output [8:0] vga_rgb,
    output       vga_row_ctrl,
    output       vga_col_ctrl
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

wire p_c_out_pc_pause;
wire p_c_out_ii_pause;
wire p_c_out_ie_pause;
wire[`PC_BUS] pc_new;

//############# IF ####################
//PC module
wire pc_pause;
wire[`PC_BUS] pc_in_pc;
wire[`PC_BUS] pc_out_pc;

assign pc_pause = p_c_out_pc_pause;
assign pc_in_pc = pc_new;
PC pc(
    .rst(rst),
    .clk_50Mhz(clk_50MHz),
    .PC_pause(pc_pause),
    .PC_in(pc_in_pc),
    .PC_out(pc_out_pc)
    );

//PC_Adder
wire[`PC_BUS] pc_a_in_pc;
wire[`PC_BUS] pc_a_out_pc;

assign pc_a_in_pc = pc_out_pc ;
PC_Adder pc_a(
    .old_PC(pc_a_in_pc),
    .new_PC(pc_a_out_pc)
    ); 

//jump control
wire jump_en;
wire jump_control_ie_pause;
Jump_Control jump_ctl(
    .pc_jump_en(jump_en),
    .clear(ii_clear),
    .pause(jump_control_ie_pause)
    );

//pc jump mux
wire[`PC_BUS] jump_addr;
PC_Jump_Mux pc_jump_mux(
    .PC_jump_op(jump_en),
    .PC_jump(jump_addr),
    .PC_add(pc_a_out_pc),
    .PC_new(pc_new)
    );

wire[`INST_BUS] ram1_out_inst;
//############# IF end

//############# IF/ID #################

wire iii_pause;
wire iii_clear;
wire[`INST_BUS] iii_inst;
wire[`INST_BUS] iio_inst;
wire[`PC_BUS] iii_pca;
wire[`PC_BUS] iio_pca;

assign iii_pause = p_c_out_ii_pause;
assign iii_clear = ii_clear;
assign iii_inst = ram1_out_inst;
assign iii_pca = pc_a_out_pc;

IF_ID if_id(
    .rst(rst),
    .clk_50MHz(clk_50MHz),
    .ii_PC_pause(iii_pause),
    .ii_PC_clear(iii_clear),
    .ram_out_inst(iii_inst),
    .pc_add_value(iii_pca),
    .ii_inst(iio_inst),
    .ii_PC(iio_pca)
    );
//############# IF_ID_end

//############# ID ####################

//main_control
wire[`INST_BUS] mci_inst;
wire[`ALU_OP_BUS] mco_alu_op;
wire[`ALU_A_OP_BUS] mco_alu_A_op;
wire[`ALU_B_OP_BUS] mco_alu_B_op;
wire[`REG_OP_BUS] mco_reg_op;
wire[`WB_DATA_OP_BUS] mco_wb_data_op;
wire[`WB_ADDR_OP_BUS] mco_wb_addr_op;
wire mco_ram_en;
wire mco_ram_op;
wire[`JUMP_EN_OP_BUS] mco_jump_en_op;
wire[`JUMP_DATA_BUS] mco_jump_data_op;
wire[`IM_OP_BUS] mco_im_op;
wire[`RAM_DATA_OP_BUS] mco_ram_data_op;

assign mci_inst = iio_inst;

Control main_control(
    .rst(rst),
    .clk_50MHz(clk_50MHz),
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
    .ram_data_op(mco_ram_data_op)
    );

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

wire[`REG_ADDR_BUS] mwo_wb_addr;
wire[`DATA_BUS] wb_data;
wire[`REG_OP_BUS] mwo_reg_op;

assign reg_files_in_a_addr = iio_inst[`INST_RX_ADDR];
assign reg_files_in_b_addr = iio_inst[`INST_RY_ADDR];
assign reg_files_in_wb_addr = mwo_wb_addr;
assign reg_files_in_wb_data = wb_data;
assign reg_files_in_reg_op = mwo_reg_op;

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
    .RA_data(reg_files_out_ra_data)
    );

//entender
wire[`INST_BUS] ex_in_inst;

wire[`DATA_BUS] ex_out_z_e_7_0;
wire[`DATA_BUS] ex_out_s_e_10_0;
wire[`DATA_BUS] ex_out_s_e_7_0;
wire[`DATA_BUS] ex_out_s_e_4_0;
wire[`DATA_BUS] ex_out_s_e_3_0;

assign ex_in_inst = iio_inst;
Extender ex(
    .inst(ex_in_inst),
    .z_e_7_0(ex_out_z_e_7_0),
    .s_e_10_0(ex_out_s_e_10_0),
    .s_e_7_0(ex_out_s_e_7_0),
    .s_e_4_0(ex_out_s_e_4_0),
    .s_e_3_0(ex_out_s_e_3_0)
    );

//pause control
wire[`REG_OP_BUS] p_c_in_reg_op;
wire[`REG_ADDR_BUS] p_c_in_wb_addr;
wire[`WB_DATA_OP_BUS] p_c_in_wb_data_op;
wire[`REG_ADDR_BUS] p_c_in_reg1_addr;
wire[`REG_ADDR_BUS] p_c_in_reg2_addr;
wire[`ALU_A_OP_BUS] p_c_in_alu_a_op;
wire[`ALU_B_OP_BUS] p_c_in_alu_b_op;
wire[`REG_ADDR_BUS] wb_addr;
wire[`REG_OP_BUS] ieo_reg_op;
wire[`WB_DATA_OP_BUS] ieo_wb_data_op;
wire[`RAM_DATA_OP_BUS] ieo_ram_data_op;
wire ram_pause;

assign p_c_in_reg_op = ieo_reg_op;
assign p_c_in_wb_addr = wb_addr;
assign p_c_in_wb_data_op = ieo_wb_data_op;
assign p_c_in_reg1_addr = iio_inst[`INST_RX_ADDR];
assign p_c_in_reg2_addr = iio_inst[`INST_RY_ADDR];
assign p_c_in_alu_a_op = mco_alu_A_op;
assign p_c_in_alu_b_op = mco_alu_B_op;

Pause_Control p_c(
    .reg_op(p_c_in_reg_op),
    .wb_addr(p_c_in_wb_addr),
    .wb_data_op(p_c_in_wb_data_op),
    .REGA_addr(p_c_in_reg1_addr),
    .REGB_addr(p_c_in_reg2_addr),
    .ALU_A_op(p_c_in_alu_a_op),
    .ALU_B_op(p_c_in_alu_b_op),
    .ram_data_op(mco_ram_data_op),

    .ram_pause(ram_pause),
    .PC_pause(p_c_out_pc_pause),
    .ii_pause(p_c_out_ii_pause),
    .ie_pause(p_c_out_ie_pause)
    );
//############# ID end

//############# ID/EXE ################
wire iei_pause;
wire[`INST_BUS] iei_inst;
wire[`WB_DATA_OP_BUS] iei_wb_data_op;
wire[`REG_OP_BUS] iei_reg_op;
wire iei_ram_en;
wire iei_ram_op;

wire[`ALU_OP_BUS] iei_alu_op;
wire[`JUMP_DATA_BUS] iei_jump_data_op;
wire[`JUMP_EN_OP_BUS] iei_jump_en_op;
wire[`ALU_A_OP_BUS] iei_alu_a_op;
wire[`ALU_B_OP_BUS] iei_alu_b_op;
wire[`IM_OP_BUS] iei_im_op;
wire[`WB_ADDR_OP_BUS] iei_wb_addr_op;
wire[`RAM_DATA_OP_BUS] iei_ram_data_op;

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
wire ieo_ram_en;
wire ieo_ram_op;

wire[`ALU_OP_BUS] ieo_alu_op;
wire[`JUMP_DATA_BUS] ieo_jump_data_op;
wire[`JUMP_EN_OP_BUS] ieo_jump_en_op;
wire[`ALU_A_OP_BUS] ieo_alu_a_op;
wire[`ALU_B_OP_BUS] ieo_alu_b_op;
wire[`IM_OP_BUS] ieo_im_op;
wire[`WB_ADDR_OP_BUS] ieo_wb_addr_op;

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

assign iei_pause = p_c_out_ie_pause;
assign iei_inst = iio_inst;
assign iei_wb_data_op = mco_wb_data_op;
assign iei_reg_op = mco_reg_op;
assign iei_ram_en = mco_ram_en;
assign iei_ram_op = mco_ram_op;

assign iei_alu_op = mco_alu_op;
assign iei_jump_data_op = mco_jump_data_op;
assign iei_jump_en_op = mco_jump_en_op;
assign iei_alu_a_op = mco_alu_A_op;
assign iei_alu_b_op = mco_alu_B_op;
assign iei_im_op = mco_im_op;
assign iei_wb_addr_op = mco_wb_addr_op;
assign iei_ram_data_op = mco_ram_data_op;

assign iei_rega = reg_files_out_a_data;
assign iei_regb = reg_files_out_b_data;
assign iei_ih = reg_files_out_ih_data;
assign iei_sp = reg_files_out_sp_data;
assign iei_ra = reg_files_out_ra_data;
assign iei_t = reg_files_out_t_data;

assign iei_pc = iio_pca;
assign iei_s_e_10_0 = ex_out_s_e_10_0;
assign iei_s_e_7_0 = ex_out_s_e_7_0;
assign iei_s_e_4_0 = ex_out_s_e_4_0;
assign iei_s_e_3_0 = ex_out_s_e_3_0;
assign iei_z_e_7_0 = ex_out_z_e_7_0;
ID_EXE ie(
    .rst(rst),
    .clk_50MHz(clk_50MHz),
    .ie_PAUSE(iei_pause),
    .jump_control_ie_PAUSE(jump_control_ie_pause),

    .inst(iei_inst),
    
    .n_ie_WB_DATA_op(iei_wb_data_op),
    .n_ie_REG_op(iei_reg_op),

    .n_ie_RAM_en(iei_ram_en),
    .n_ie_RAM_op(iei_ram_op),

    .n_ie_ALU_op(iei_alu_op),
    .n_ie_JUMP_DATA_op(iei_jump_data_op),
    .n_ie_JUMP_EN_op(iei_jump_en_op),
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
    .ie_WB_DATA_op(ieo_wb_data_op),
    .ie_REG_op(ieo_reg_op),

    .ie_RAM_en(ieo_ram_en),
    .ie_RAM_op(ieo_ram_op),

    .ie_ALU_op(ieo_alu_op),
    .ie_JUMP_DATA_op(ieo_jump_data_op),
    .ie_JUMP_EN_op(ieo_jump_en_op),
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

    );

//############# EXE ###################

//forward
wire[`DATA_BUS] reg1_forward_data;
wire[`DATA_BUS] reg2_forward_data;
wire reg1_forward_enable;
wire reg2_forward_enable;

wire[`WB_DATA_OP_BUS] emo_wb_data_op;
wire[`REG_OP_BUS] emo_reg_op;
wire[`DATA_BUS] emo_ih;
wire[`DATA_BUS] emo_pc;
wire[`DATA_BUS] emo_alu_data;
wire[`DATA_BUS] emo_ram_wb_data;
wire[`REG_ADDR_BUS] emo_wb_addr;

wire[`WB_DATA_OP_BUS] mwo_wb_data_op;
wire[`DATA_BUS] mwo_ih;
wire[`DATA_BUS] mwo_pc;
wire[`DATA_BUS] mwo_alu_data;
wire[`DATA_BUS] mwo_ram_data;
wire[`DATA_BUS] forward_out_ih;
wire[`DATA_BUS] mux_forward_data;
wire mux_forward_enable;

Forward forward_ctrl(
    .emo_PC_wb_data(emo_pc),
    .mwo_PC_wb_data(mwo_pc),
    .emo_IH_wb_data(emo_ih),
    .mwo_IH_wb_data(mwo_ih),
    .emo_alu_answer(emo_alu_data),
    .mwo_alu_answer(mwo_alu_data),
    .mwo_ram_read_answer(mwo_ram_data),

    .reg1_addr(ieo_reg_addr_rx),
    .reg2_addr(ieo_reg_addr_ry),
    .emo_wb_addr(emo_wb_addr),
    .mwo_wb_addr(mwo_wb_addr),

    .op1_mux_op(ieo_alu_a_op),
    .op2_mux_op(ieo_alu_b_op),
    .emo_reg_op(emo_reg_op),
    .mwo_reg_op(mwo_reg_op),
    .emo_wb_data_op(emo_wb_data_op),
    .mwo_wb_data_op(mwo_wb_data_op),
    
    .ram_data_op(ieo_ram_data_op),

    .reg1_forward_data(reg1_forward_data),
    .reg2_forward_data(reg2_forward_data),
    .mux_forward_data(mux_forward_data),

    .reg1_forward_enable(reg1_forward_enable),
    .reg2_forward_enable(reg2_forward_enable),
    .mux_forward_enable(mux_forward_enable),

    .ieo_ih(ieo_ih),
    .emi_ih(forward_out_ih)
    );

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
    );

//opA mux
wire[`DATA_BUS] alu_a;
ALU_A_Mux alu_a_mux(
    .data_T(ieo_t),
    .data_SP(ieo_sp),
    .data_RZ(ieo_reg_addr_rz),
    .data_REGA(ieo_rega),
    .data_FOWD(reg1_forward_data),
    .ALU_A_FOWD_en(reg1_forward_enable),
    .ALU_A_op(ieo_alu_a_op),
    .ALU_A_data(alu_a)
    );

//opB mux
wire[`DATA_BUS] alu_b;
ALU_B_Mux alu_b_mux(
    .data_IM(im_out),
    .data_REGB(ieo_regb),
    .data_FOWD(reg2_forward_data),
    .ALU_B_FOWD_en(reg2_forward_enable),
    .ALU_B_op(ieo_alu_b_op),
    .ALU_B_data(alu_b)
    );


//wb_addr mux
WB_Addr_Mux wb_addr_Mux(
    .wb_addr_op(ieo_wb_addr_op),
    .rx_addr(ieo_reg_addr_rx),
    .ry_addr(ieo_reg_addr_ry),
    .rz_addr(ieo_reg_addr_rz),
    .wb_addr(wb_addr)
    );

//alu
wire zero;
wire[`DATA_BUS] alu_answer;
ALU alu(
    .a(alu_a),
    .b(alu_b),
    .op(ieo_alu_op),
    .y(alu_answer),
    .zero(zero)
    );

//jump add
wire[`DATA_BUS] jump_add_pc;
Jump_Add jump_add(
    .old_pc(ieo_pc),
    .im(im_out),
    .new_pc(jump_add_pc)
    );

//jump data mux
Jump_Data_Mux jump_data_mux(
    .jump_answer(jump_add_pc),
    .alu_answer(alu_answer),
    .jump_data_op(ieo_jump_data_op),
    .jump_addr(jump_addr)
    );

//jump en mux
Jump_En_Mux jump_en_mux(
    .zero(zero),
    .jump_en_op(ieo_jump_en_op),
    .jump_en(jump_en)
    );

//ram data mux 

wire[`DATA_BUS] ram_data;
RAM_Data_Mux ram_data_mux(
    .data_REGA(ieo_rega),
    .data_REGB(ieo_regb),
    .data_RA(ieo_ra),
    .data_FOWD(mux_forward_data),

    .RAM_data_op(ieo_ram_data_op),
    .forward_enable(mux_forward_enable),
    .RAM_data(ram_data)
    );
//############# EXE end

//############# EXE/MEM ###############

wire emi_ram_en;
wire emi_ram_op;
wire[`WB_DATA_OP_BUS] emi_wb_data_op;
wire[`REG_OP_BUS] emi_reg_op;
wire[`DATA_BUS] emi_ih;
wire[`DATA_BUS] emi_pc;
wire[`DATA_BUS] emi_alu_data;
wire[`DATA_BUS] emi_ram_wb_data;
wire[`REG_ADDR_BUS] emi_wb_addr;

wire emo_ram_en;
wire emo_ram_op;

assign emi_ram_en = ieo_ram_en;
assign emi_ram_op = ieo_ram_op;
assign emi_wb_data_op = ieo_wb_data_op;
assign emi_reg_op = ieo_reg_op;
assign emi_ih = forward_out_ih;
assign emi_pc = ieo_pc;
assign emi_alu_data = alu_answer;
assign emi_ram_wb_data = ram_data;
assign emi_wb_addr = wb_addr;

EXE_MEM em(
    .rst(rst),
    .clk_50MHz(clk_50MHz),
    .n_em_RAM_en(emi_ram_en),
    .n_em_RAM_op(emi_ram_op),
    .n_em_WB_DATA_op(emi_wb_data_op),
    .n_em_REG_op(emi_reg_op),
    .n_em_IH(emi_ih),
    .n_em_PC(emi_pc),
    .n_em_ALU_data(emi_alu_data),
    .n_em_RAM_WB_data(emi_ram_wb_data),
    .n_em_WB_addr(emi_wb_addr),

    .em_RAM_en(emo_ram_en),
    .em_RAM_op(emo_ram_op),
    .em_WB_DATA_op(emo_wb_data_op),
    .em_REG_op(emo_reg_op),
    .em_IH(emo_ih),
    .em_PC(emo_pc),
    .em_ALU_data(emo_alu_data),
    .em_RAM_WB_data(emo_ram_wb_data),
    .em_WB_addr(emo_wb_addr)
    );
//############# end

//############# MEM ###################
wire[`DATA_BUS] ram_out_data;
wire[`ADDR_BUS] ram_in_addr;
assign ram_in_addr = {2'b00, emo_alu_data};

wire[`VGA_ROW_BUS] vga_row;
wire[`VGA_COL_BUS] vga_col;
wire[`VGA_DATA_BUS] vga_data;

ram RAM(
    .rst(rst),
    .clk_50MHz(clk_50MHz),
    .clk_25MHz(clk_25MHz),

    .sram1_data(ram1_data),
    .sram1_addr(ram1_addr),
    .sram1_en(ram1_en),
    .sram1_oe(ram1_oe),
    .sram1_we(ram1_we),

    .sram2_data(ram2_data),
    .sram2_addr(ram2_addr),
    .sram2_en(ram2_en),
    .sram2_oe(ram2_oe),
    .sram2_we(ram2_we),
    
    .data_o(ram_out_data),
    .data_i(emo_ram_wb_data),
    .addr(ram_in_addr),
    .op(emo_ram_op),
    .en(emo_ram_en),
    .pc(pc_out_pc),
    .inst(ram1_out_inst),
    
    .tsre(tsre),
    .tbre(tbre),
    .data_ready(data_ready),

    .vga_col(vga_col),
    .vga_row(vga_row),
    .vga_data(vga_data),

    .wrn(wrn),
    .rdn(rdn),
    .ram_pause(ram_pause)
    );

vga VGA(
    .rst(rst),
    .clk_25MHz(clk_25MHz),
    .vga_row(vga_row),
    .vga_col(vga_col),
    .vga_data(vga_data),

    .vga_rgb(vga_rgb),
    .vga_row_ctrl(vga_row_ctrl),
    .vga_col_ctrl(vga_col_ctrl)
    );


//############# MEM/WB ################
wire[`WB_DATA_OP_BUS] mwi_wb_data_op;
wire[`REG_OP_BUS] mwi_reg_op;
wire[`DATA_BUS] mwi_ih;
wire[`DATA_BUS] mwi_pc;
wire[`DATA_BUS] mwi_alu_data;
wire[`DATA_BUS] mwi_ram_data;
wire[`REG_ADDR_BUS] mwi_wb_addr;

assign mwi_wb_data_op = emo_wb_data_op;
assign mwi_reg_op = emo_reg_op;
assign mwi_ih = emo_ih;
assign mwi_pc = emo_pc;
assign mwi_alu_data = emo_alu_data;
assign mwi_ram_data = ram_out_data;
assign mwi_wb_addr = emo_wb_addr;

MEM_WB mwm_wb(
    .rst(rst),
    .clk_50MHz(clk_25MHz),
    
    .n_mw_WB_data_op(mwi_wb_data_op),
    .n_mw_REG_op(mwi_reg_op),

    .n_mw_IH(mwi_ih),
    .n_mw_PC(mwi_pc),
    .n_mw_ALU_data(mwi_alu_data),
    .n_mw_RAM_data(mwi_ram_data),
    .n_mw_WB_addr(mwi_wb_addr),

    .mw_WB_data_op(mwo_wb_data_op),
    .mw_REG_op(mwo_reg_op),

    .mw_IH(mwo_ih),
    .mw_PC(mwo_pc),
    .mw_ALU_data(mwo_alu_data),
    .mw_RAM_data(mwo_ram_data),
    .mw_WB_addr(mwo_wb_addr)
   );
//############# end
//############# WB ####################

//wb data mux
WB_Data_Mux wb_data_mux(
    .alu_data(mwo_alu_data),
    .mem_data(mwo_ram_data),
    .wb_PC(mwo_pc),
    .wb_IH(mwo_ih),
    .wb_data_op(mwo_wb_data_op),
    .wb_data(wb_data)
    );

initial begin
    // $monitor("%dns c=%x,r=%x, i=%x, pc=%x, watch=%x %x %x %x",
    //     $stime, clk_50MHz, rst, ram1_out_inst, pc_out_pc
    //                     , ieo_pc
    //                     , wb_addr
    //                     , wb_data
    //                     , mwo_reg_op
    //     );
end

endmodule

`endif