`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2023 06:09:56 PM
// Design Name: 
// Module Name: alu_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "riscv_defines.vh"

module alu_control(
    input   wire    [`ALU_OP_WIDTH-1 : 0]   alu_op, 
    input   wire    [2 : 0]                 funct3,
    input   wire                            funct7_30,  // SUB and SRA  
    input   wire                            funct7_25,  // RV32M extension 
    output  reg     [`ALU_OP_WIDTH-1 : 0]   alu_ctrl
);
always @(*) begin
    alu_ctrl = 0;
    case (alu_op)
        `ALU_OP_BRANCH: alu_ctrl = `ALU_SUB;
        `ALU_OP_MEM:    alu_ctrl = `ALU_ADD;
        `ALU_OP_REG: 
            case ({funct7_30, funct7_25})
                2'b00:
                    case (funct3)
                        3'b000: alu_ctrl = `ALU_ADD;
                        3'b001: alu_ctrl = `ALU_SLL;
                        3'b010: alu_ctrl = `ALU_SLT;
                        3'b011: alu_ctrl = `ALU_SLTU;
                        3'b100: alu_ctrl = `ALU_XOR;
                        3'b101: alu_ctrl = `ALU_SRL;
                        3'b110: alu_ctrl = `ALU_OR;
                        3'b111: alu_ctrl = `ALU_AND;    
                    endcase
                2'b01:
                    case (funct3)
                        3'b000: alu_ctrl = `ALU_MUL;
                        3'b001: alu_ctrl = `ALU_MULH;
                        3'b010: alu_ctrl = `ALU_MULHSU;
                        3'b011: alu_ctrl = `ALU_MULHU;
                        3'b100: alu_ctrl = `ALU_DIV;
                        3'b101: alu_ctrl = `ALU_DIVU;
                        3'b110: alu_ctrl = `ALU_REM;
                        3'b111: alu_ctrl = `ALU_REMU;
                    endcase
                2'b10: alu_ctrl = (funct3 == 3'b000) ? `ALU_SUB : `ALU_SRA;
            endcase
    endcase
end

endmodule
