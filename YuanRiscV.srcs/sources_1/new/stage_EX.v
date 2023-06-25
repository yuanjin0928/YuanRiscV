`timescale 1ns / 1ps
`default_nettype none

`include "riscv_defines.vh"


module stage_EX(
    input   wire                                    clk,

    input   wire                                    pipe_prev_reg_reg_write,
    input   wire    [4 : 0]                         pipe_prev_reg_reg_write_port_addr,
    output  reg                                     pipe_reg_reg_write,
    output  reg     [4 : 0]                         pipe_reg_reg_write_port_addr,

    input   wire                                    pipe_prev_reg_mem_write,
    output  reg                                     pipe_reg_mem_write,
    output  reg     [31 : 0]                        pipe_reg_mem_write_data,

    input   wire                                    pipe_prev_reg_reg_data_from_mem,
    output  reg                                     pipe_reg_reg_data_from_mem,

    input   wire    [`ALU_OP_WIDTH-1 : 0]           pipe_prev_reg_alu_op, 
    input   wire    [2 : 0]                         pipe_prev_reg_funct3,
    input   wire                                    pipe_prev_reg_funct7_30,  // SUB and SRA  
    input   wire                                    pipe_prev_reg_funct7_25,  // RV32M extension 

    input   wire    [`PC_NEXT_SRC_SEL_WIDTH-1 : 0]  pipe_prev_reg_pc_next_src_sel,
    input   wire    [`PC_WIDTH-1 : 0]               pipe_prev_reg_pc,
    input   wire    [31 : 0]                        pipe_prev_reg_imm,
    input   wire    [31 : 0]                        pipe_prev_reg_reg_read_data1, 
    output  reg                                     pipe_reg_jump,
    output  reg     [`PC_WIDTH-1 : 0]               pipe_reg_pc_jump,

    input   wire    [`ALUT_SRC2_WIDTH-1 : 0]        pipe_prev_reg_alu_src2_sel,   

    input   wire    [31 : 0]                        pipe_prev_reg_reg_read_data2,
    output  reg     [31 : 0]                        pipe_reg_ex_result,

    input   wire    [`REG_DATA_SRC_SEL_WIDTH-1 : 0] pipe_prev_reg_reg_data_src_sel
);

always @(posedge clk) begin
    pipe_reg_reg_write <= pipe_prev_reg_reg_write;
    pipe_reg_reg_write_port_addr <= pipe_prev_reg_reg_write_port_addr;

    pipe_reg_reg_data_from_mem <= pipe_prev_reg_reg_data_from_mem;
    pipe_reg_mem_write <= pipe_prev_reg_mem_write;
end

wire    [`ALU_OP_WIDTH-1 : 0]   alu_ctrl;

alu_control alu_control_unit(
    .alu_op(pipe_prev_reg_alu_op), 
    .funct3(pipe_prev_reg_funct3),
    .funct7_30(pipe_prev_reg_funct7_30),  // SUB and SRA  
    .funct7_25(pipe_prev_reg_funct7_25),  // RV32M extension 
    .alu_ctrl(alu_ctrl)
);

wire    alu_equal, alu_unsigned_less, alu_signed_less;
wire    jump;
wire    [`PC_WIDTH-1 : 0]   pc_next;

mpc_next_gen pc_next_gen_unit(
    .pc_next_src_sel(pipe_prev_reg_pc_next_src_sel),
    .funct3(pipe_prev_reg_funct3),
    .pc_current(pipe_prev_reg_pc),
    .imm(pipe_prev_reg_imm),
    .rs1(pipe_prev_reg_reg_read_data1),    // defined for JALR
    .alu_equal(alu_equal), 
    .alu_unsigned_less(alu_unsigned_less), 
    .alu_signed_less(alu_signed_less),
    .jump(jump),
    .pc_next(pc_next)   
);

always @(posedge clk) begin
    pipe_reg_jump <= jump;
    pipe_reg_pc_jump <= pc_next;
end

wire    [31 : 0]    alu_src_2 = (pipe_prev_reg_alu_src2_sel == `ALU_SRC2_REG) ? pipe_prev_reg_reg_read_data2 : pipe_prev_reg_imm;
wire    [31 : 0]    alu_result;

alu alu_unit(
    .alu_src_1(pipe_prev_reg_reg_read_data1), 
    .alu_src_2(alu_src_2),
    .alu_ctrl(alu_ctrl),
    .alu_result(alu_result),
    .alu_signed_less(alu_signed_less),
    .alu_unsigned_less(alu_unsigned_less),
    .alu_equal(alu_equal)
);

wire    [31 : 0]    ex_result;
wire    [31 : 0]    csr;
reg_data_src_gen reg_data_src_gen_unit(
    .reg_data_src_sel(pipe_prev_reg_reg_data_src_sel),
    .imm(pipe_prev_reg_imm),
    .pc_current(pipe_prev_reg_pc),
    .csr(csr),
    .alu_result(alu_result),
    .reg_data(ex_result)
);

always @(posedge clk) begin
    pipe_reg_ex_result <= ex_result; 
end

always @(posedge clk) begin
    pipe_reg_mem_write_data <= pipe_prev_reg_reg_read_data2;
end

endmodule
