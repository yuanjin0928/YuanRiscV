`timescale  1ns/1ps
`default_nettype none

`include "riscv_defines.vh"

module  pc_next_gen(
    input   wire    [`PC_NEXT_SRC_SEL_WIDTH-1 : 0]  pc_next_src_sel,
    input   wire    [2 : 0]                         funct3,
    input   wire    [`PC_WIDTH-1 : 0]               pc_current,
    input   wire    [31 : 0]                        imm,
    input   wire    [31 : 0]                        rs1,    // defined for JALR
    input   wire                                    alu_equal, alu_unsigned_less, alu_signed_less,
    output  reg     [`PC_WIDTH-1 : 0]               pc_next   
);

wire    [`PC_WIDTH-1 : 0]    pc_next_inc = pc_current + 4;
wire    [`PC_WIDTH-1 : 0]    pc_next_branch = pc_current + imm << 1;
wire    [`PC_WIDTH-1 : 0]    pc_next_jal = pc_next_branch;
wire    [`PC_WIDTH-1 : 0]    pc_next_jalr = rs1 + imm;

always @(*) begin
    pc_next = pc_next_inc;
    case (pc_next_src_sel) 
        `PC_NEXT_SRC_INC: pc_next = pc_next_inc;
        `PC_NEXT_SRC_BRANCH: 
            case (funct3)
                `BRANCH_BEQ:
                    pc_next = alu_equal ? pc_next_branch : pc_next_inc;
                `BRANCH_BNE:
                    pc_next = !alu_equal ? pc_next_branch : pc_next_inc;
                `BRANCH_BLT:
                    pc_next = alu_signed_less ? pc_next_branch : pc_next_inc;
                `BRANCH_BGE:
                    pc_next = !alu_signed_less ? pc_next_branch : pc_next_inc;
                `BRANCH_BLTU:
                    pc_next = alu_unsigned_less ? pc_next_branch : pc_next_inc; 
                `BRANCH_BGEU:
                    pc_next = !alu_unsigned_less ? pc_next_branch : pc_next_inc;
            endcase
        `PC_NEXT_SRC_JAL:
            pc_next = pc_next_jal;
        `PC_NEXT_SRC_JALR:
            pc_next = pc_next_jalr;
    endcase
end

endmodule
