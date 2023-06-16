`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2023 09:04:04 PM
// Design Name: 
// Module Name: control
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

module control(
    input   wire    [6:0]                           op_code,
    output  reg     [`PC_NEXT_SRC_SEL_WIDTH-1 : 0]  pc_next_src_sel,
    output  reg     [`BRANCH_SEL_WIDTH-1 : 0]       branch_sel,
    output  reg     [`REG_DATA_SRC_SEL_WIDTH-1 : 0] reg_data_src_sel,
    output  reg     [`ALUT_SRC2_WIDTH-1 : 0]        alu_src2_sel,
    output  reg     [`ALU_OP_WIDTH-1 : 0]           alu_op,
    output  reg                                     reg_write,
    output  reg                                     mem_write
);

always @(*) begin
    pc_next_src_sel = 0;
    reg_data_src_sel = 0;
    alu_src2_sel = 0;
    alu_op = 0;
    reg_write = 0;
    mem_write = 0;
    case (op_code)
        `OP_LUI: begin 
            reg_write = 1'b1;   
            reg_data_src_sel = `REG_DATA_SRC_LUI;
        end     
        `OP_AUIPC: begin
            reg_write = 1'b1;   
            reg_data_src_sel = `REG_DATA_SRC_AUIPC;
        end      
        `OP_JAL: begin
            reg_write = 1'b1;
            reg_data_src_sel = `REG_DATA_SRC_AUIPC;
            pc_next_src_sel = `PC_NEXT_SRC_JAL;
        end     
        `OP_BRANCH: begin
            pc_next_src_sel = `PC_NEXT_SRC_BRANCH;
            alu_src2_sel = `ALU_SRC2_REG;
        end  
        `OP_LOAD: begin
            reg_write = 1'b1;
            alu_src2_sel = `ALU_SRC2_IMM;
        end    
        `OP_STORE: begin
            mem_write = 1'b1;
            alu_src2_sel = `ALU_SRC2_IMM; 
        end   
        `OP_ALU_I: begin
            reg_write = 1'b1;
            alu_src2_sel = `ALU_SRC2_IMM;
        end   
        `OP_ALU_R: begin
            reg_write = 1'b1;
            alu_src2_sel = `ALU_SRC2_REG;
        end   
        `OP_CSR: begin
            reg_data_src_sel = `REG_DATA_SRC_CSR;
        end     
    endcase
end

endmodule
