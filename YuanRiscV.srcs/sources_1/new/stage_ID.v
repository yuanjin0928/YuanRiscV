`timescale 1ps/1ps
`default_nettype none

`include "riscv_defines.vh"

module stage_ID (
    input   wire                                        clk,
    
    input   wire    [31 : 0]                            pipe_prev_reg_instruction,
    input   wire    [`PC_WIDTH-1 : 0]                   pipe_prev_reg_pc,
    input   wire                                        pipe_prev_reg_reg_write,
    input   wire    [4 : 0]                             pipe_prev_reg_reg_write_port_addr,
    input   wire    [31 : 0]                            pipe_prev_reg_reg_write_data,

    output  reg     [`PC_WIDTH-1 : 0]                   pipe_reg_pc,
    output  reg     [`PC_NEXT_SRC_SEL_WIDTH-1 : 0]      pipe_reg_pc_next_src_sel,
    output  reg     [`REG_DATA_SRC_SEL_WIDTH-1 : 0]     pipe_reg_reg_data_src_sel,
    output  reg     [`ALUT_SRC2_WIDTH-1 : 0]            pipe_reg_alu_src2_sel,
    output  reg     [`ALU_OP_WIDTH-1 : 0]               pipe_reg_alu_op,
    output  reg     [31 : 0]                            pipe_reg_reg_write_port_addr,
    output  reg                                         pipe_reg_reg_write,
    output  reg                                         pipe_reg_reg_data_from_mem,
    output  reg                                         pipe_reg_mem_write,

    output  reg     [31 : 0]                            pipe_reg_reg_read_data1,
    output  reg     [31 : 0]                            pipe_reg_reg_data_data2,

    output  reg     [31 : 0]                            pipe_reg_imm,

    output  reg     [2 : 0]                             pipe_reg_funct3,
    output  reg                                         pipe_reg_funct7_30,  // SUB and SRA  
    output  reg                                         pipe_reg_funct7_25   // RV32M extension 
);

wire    [6 : 0]                             op_code = pipe_prev_reg_instruction[6 : 0];
wire    [`PC_NEXT_SRC_SEL_WIDTH-1 : 0]      pc_next_src_sel;
wire    [`REG_DATA_SRC_SEL_WIDTH-1 : 0]     reg_data_src_sel;
wire    [`ALUT_SRC2_WIDTH-1 : 0]            alu_src2_sel;
wire    [`ALU_OP_WIDTH-1 : 0]               alu_op;
wire                                        reg_write;
wire                                        reg_data_from_mem;
wire                                        mem_write;

control control_unit(
    .op_code(op_code),
    .pc_next_src_sel(pc_next_src_sel),
    .reg_data_src_sel(reg_data_src_sel),
    .alu_src2_sel(alu_src2_sel),
    .alu_op(alu_op),
    .reg_write(reg_write),
    .reg_data_from_mem(reg_data_from_mem),
    .mem_write(mem_write)
);

always @(posedge clk) begin
    pipe_reg_pc                 <=      pipe_prev_reg_pc;
    pipe_reg_pc_next_src_sel    <=      pc_next_src_sel;
    pipe_reg_reg_data_src_sel   <=      reg_data_src_sel;
    pipe_reg_alu_src2_sel       <=      alu_src2_sel;
    pipe_reg_alu_op             <=      alu_op;
    pipe_reg_reg_write          <=      reg_write;
    pipe_reg_reg_data_from_mem  <=      reg_data_from_mem;
    pipe_reg_mem_write          <=      mem_write;
end

wire    [4 : 0]     read_port1_addr = pipe_prev_reg_instruction[19 : 15];
wire    [4 : 0]     read_port2_addr = pipe_prev_reg_instruction[24 : 20];
wire    [4 : 0]     write_port_addr = pipe_prev_reg_instruction[11 : 7];
wire    [31 : 0]    reg_read_data1;
wire    [31 : 0]    reg_read_data2;

reg_file reg_file_unit(
    .clk(clk),
    .we(pipe_prev_reg_reg_write),
    .read_port1_addr(read_port1_addr),
    .read_port2_addr(read_port2_addr),
    .write_port_addr(pipe_prev_reg_reg_write_port_addr),
    .reg_write_data(pipe_prev_reg_reg_write_data),
    .reg_read_data1(reg_read_data1),
    .reg_read_data2(reg_read_data2) 
);

always @(posedge clk) begin
    pipe_reg_reg_read_data1 <= reg_read_data1;
    pipe_reg_reg_data_data2 <= reg_read_data2;
    pipe_reg_reg_write_port_addr <= write_port_addr;
end

wire    [31 : 0]    imm;

imm_gen imm_gen_unit(
    .instruction(pipe_prev_reg_instruction),
    .imm(imm)
);

always @(posedge clk) begin
    pipe_reg_imm <= imm;
    pipe_reg_funct3 <= pipe_prev_reg_instruction[14 : 12];
    pipe_reg_funct7_25 <= pipe_prev_reg_instruction[25];
    pipe_reg_funct7_30 <= pipe_prev_reg_instruction[30];
    
end

endmodule