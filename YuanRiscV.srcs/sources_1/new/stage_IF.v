`timescale 1ps/1ps
`default_nettype none

`include "riscv_defines.vh"

module stage_IF(
    input   wire                        clk,
    input   wire                        rst,
    input   wire    [`PC_WIDTH-1 : 0]   pipe_prev_reg_pc_jump,
    input   wire                        pipe_prev_reg_jump,
    output  reg     [31 : 0]            pipe_reg_instruction,
    output  reg     [`PC_WIDTH-1 : 0]   pipe_reg_pc
);  

wire    [`PC_WIDTH-1 : 0]   pc;
wire    pc_next = pipe_prev_reg_jump ? pipe_prev_reg_pc_jump : pc + 4;


pc  pc_unit (
    .clk(clk),
    .rst(rst),
    .pc_next(pc_next),
    .pc(pc)
);

always @(posedge clk) begin
    pipe_reg_pc <= pc;
end

endmodule