`timescale 1ps/1ps
`default_nettype none

`include "riscv_defines.vh"

module reg_data_src_gen(
    input   wire    [`REG_DATA_SRC_SEL_WIDTH-1  :0] reg_data_src_sel,
    input   wire    [31 : 0]                        imm,
    input   wire    [`PC_WIDTH-1 : 0]               pc_current,
    input   wire    [31 : 0]                        csr,
    input   wire    [31 : 0]                        alu_result,
    input   wire    [31 : 0]                        mem_load,
    output  reg     [31 : 0]                        reg_data
);

wire    [31 : 0]    reg_data_lui = imm;
wire    [31 : 0]    reg_data_auipc = pc_current + (imm << 1);
wire    [31 : 0]    reg_data_jal_jalr = pc_current + 4;

always @(*) begin
    reg_data = 0;
    case (reg_data_src_sel) 
        `REG_DATA_SRC_ALU:      reg_data = alu_result;
        `REG_DATA_SRC_LOAD:     reg_data = mem_load;
        `REG_DATA_SRC_LUI:      reg_data = reg_data_lui;
        `REG_DATA_SRC_AUIPC:    reg_data = reg_data_auipc;
        `REG_DATA_SRC_JAL_JALR: reg_data = reg_data_jal_jalr;
        `REG_DATA_SRC_CSR:      reg_data = csr;
    endcase
end

endmodule