`timescale 1ps/1ps
`default_nettype none

module state_WB(
    input   wire                pipe_prev_reg_reg_data_from_mem,
    input   wire                pipe_prev_reg_reg_write,
    input   wire    [31 : 0]    pipe_prev_reg_mem_read_data,
    input   wire    [31 : 0]    pipe_prev_reg_ex_result,  
    input   wire    [4 : 0]     pipe_prev_reg_reg_write_port_addr,

    output  wire    [31 : 0]    reg_write_data,
    output  wire                reg_write,
    output  wire    [4 : 0]     reg_write_port_addr  
);

assign reg_write_data = pipe_prev_reg_reg_data_from_mem ? pipe_prev_reg_mem_read_data : pipe_prev_reg_ex_result;
assign reg_write = pipe_prev_reg_reg_write;
assign reg_write_port_addr = pipe_prev_reg_reg_write_port_addr;

endmodule