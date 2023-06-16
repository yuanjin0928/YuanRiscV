`timescale 1ps/1ps
`default_nettype none

`include "riscv_defines.vh"

module imm_gen(
    input   wire    [31 : 0]    instruction,
    output  reg     [31 : 0]    imm
);

wire    [31 : 0]    op_code = instruction[6 : 0];
wire    [31 : 0]    imm_lui = instruction[31 : 20] << 12;
wire    [31 : 0]    imm_auipc = imm_lui;
wire    [31 : 0]    imm_jal = {{12{instruction[31]}}, instruction[31], instruction[19 : 12], instruction[20], instruction[30 : 21]};
wire    [31 : 0]    imm_jalr = {{20{instruction[31]}}, instruction[31 : 20]};
wire    [31 : 0]    imm_branch = {{20{instruction[31]}}, instruction[31], instruction[7], instruction[30 : 25], instruction[11 : 8]};  
wire    [31 : 0]    imm_load = {{20{instruction[31]}}, instruction[31 : 20]};
wire    [31 : 0]    imm_store = {{20{instruction[31]}}, instruction[31 : 25], instruction[11 : 7]};
wire    [31 : 0]    imm_alu_i = imm_load;

always @(*) begin
    imm = instruction;
    case (op_code)
        `OP_ALU_I:  imm = imm_alu_i;   
        `OP_BRANCH: imm = imm_branch;
        `OP_LOAD:   imm = imm_load;
        `OP_STORE:  imm = imm_store;
        `OP_LUI:    imm = imm_lui;
        `OP_AUIPC:  imm = imm_auipc;
        `OP_JAL:    imm = imm_jal;
        `OP_JALR:   imm = imm_jalr;
    endcase
end


endmodule