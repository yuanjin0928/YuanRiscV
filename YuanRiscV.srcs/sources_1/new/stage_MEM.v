`timescale 1ps/1ps
`default_nettype none

module stage_MEM (
    input   wire    clk,

    input   wire    [4 : 0]     pipe_prev_reg_reg_write_port_addr,
    input   wire    [31 : 0]    pipe_prev_reg_mem_write_data,
    input   wire    [31 : 0]    pipe_prev_reg_ex_result,
    input   wire                pipe_prev_reg_mem_write,
    input   wire                pipe_prev_reg_reg_data_from_mem,
    input   wire                pipe_prev_reg_reg_write,

    output  reg                 pipe_reg_reg_write,
    output  reg                 pipe_reg_reg_data_from_mem,
    output  reg     [31 : 0]    pipe_reg_mem_read_data,
    output  reg     [31 : 0]    pipe_reg_ex_result
);

always @(posedge clk) begin
    pipe_reg_reg_write <= pipe_prev_reg_reg_write;
    pipe_reg_reg_data_from_mem <= pipe_prev_reg_reg_data_from_mem;
    pipe_reg_ex_result <= pipe_prev_reg_ex_result;
end

endmodule