//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2023 10:10:20 PM
// Design Name: 
// Module Name: alu
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
`timescale 1ns / 1ps
`default_nettype none 
`include "riscv_defines.vh"

module alu(
    input   wire    [31 : 0]    alu_src_1, alu_src_2,
    input   wire    [`ALU_CTRL_WIDTH-1 : 0]  alu_ctrl,
    output  reg     [31 : 0]    alu_result,
    output  wire                alu_signed_less,
    output  wire                alu_unsigned_less,
    output  wire                alu_equal
);

wire    is_sub = alu_ctrl == `ALU_SUB;
wire    [31:0]  cond_inv_b = is_sub ? ~alu_src_2 : alu_src_2;
wire    [32:0]  sum = {1'b1, cond_inv_b} + {1'b0, alu_src_1} + {32'b0, is_sub};

assign alu_equal = sum[31:0] == 0;
assign alu_signed_less = (alu_src_1 ^ alu_src_2) ? alu_src_1[31] : sum[32];
assign alu_unsigned_less = sum[32];


wire    [63:0]  result_sra = {{32{alu_src_1[31]}}, alu_src_1} >> alu_src_2;  

always @(*) begin
    case (alu_ctrl)
        `ALU_ADD:   alu_result = sum[31:0]; 
        `ALU_SUB:   alu_result = sum[31:0];
        `ALU_AND:   alu_result = alu_src_1 & alu_src_2;
        `ALU_OR:    alu_result = alu_src_1 | alu_src_2;
        `ALU_XOR:   alu_result = alu_src_1 ^ alu_src_2;
        `ALU_SLL:   alu_result = alu_src_1 << alu_src_2;
        `ALU_SRL:   alu_result = alu_src_1 >> alu_src_2;
        `ALU_SRA:   alu_result = result_sra[31:0];
        `ALU_SLT:   alu_result = alu_signed_less;
        `ALU_SLTU:  alu_result = alu_unsigned_less;
        default:    alu_result = 0;
    endcase
end

endmodule

