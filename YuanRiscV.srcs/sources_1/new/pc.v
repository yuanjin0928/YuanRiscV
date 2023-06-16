`timescale 1ps/1ps
`default_nettype none

`include "riscv_defines.vh"

module pc(
    input   wire                        clk,
    input   wire                        rst,
    input   wire   [`PC_WIDTH-1 : 0]    pc_next,
    output  reg    [`PC_WIDTH-1 : 0]    pc
);

always @(posedge clk) begin
    pc <= pc_next;

    if (rst)
        pc <= `PC_DEFAULT;
end

endmodule