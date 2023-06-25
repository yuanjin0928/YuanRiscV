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
    output  reg                                     jump,
    output  reg     [`PC_WIDTH-1 : 0]               pc_next   
);

wire    [`PC_WIDTH-1 : 0]    pc_next_branch = pc_current + imm << 1;
wire    [`PC_WIDTH-1 : 0]    pc_next_jal = pc_next_branch;
wire    [`PC_WIDTH-1 : 0]    pc_next_jalr = rs1 + imm;

always @(*) begin
    jump = 1'b0;
    pc_next = pc_current;
    case (pc_next_src_sel) 
        `PC_NEXT_SRC_INC: begin 
            jump = 1'b0;
            pc_next = pc_current;
        end
        `PC_NEXT_SRC_BRANCH: 
            case (funct3)
                `BRANCH_BEQ: begin
                    jump = alu_equal;
                    pc_next = pc_next_branch;
                end
                `BRANCH_BNE: begin
                    jump = !alu_equal;
                    pc_next = pc_next_branch;
                end
                `BRANCH_BLT: begin
                    jump = alu_signed_less;
                    pc_next = pc_next_branch;
                end
                `BRANCH_BGE: begin
                    jump = !alu_signed_less; 
                    pc_next = pc_next_branch;
                end
                `BRANCH_BLTU: begin
                    jump = alu_unsigned_less;
                    pc_next = pc_next_branch; 
                end
                `BRANCH_BGEU: begin
                    jump = !alu_unsigned_less;
                    pc_next = pc_next_branch;
                end
            endcase
        `PC_NEXT_SRC_JAL: begin
            jump = 1'b1;
            pc_next = pc_next_jal;
        end
        `PC_NEXT_SRC_JALR: begin
            jump = 1'b1;
            pc_next = pc_next_jalr;
        end
    endcase
end

endmodule
