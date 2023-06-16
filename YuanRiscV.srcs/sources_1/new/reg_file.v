`timescale 1ns / 1ps
`default_nettype none


module reg_file(
    input   wire                clk,
    input   wire                we,
    input   wire    [4 : 0]     read_port1_addr,
    input   wire    [4 : 0]     read_port2_addr,
    input   wire    [4 : 0]     write_port_addr,
    input   wire    [31 : 0]    reg_write_data,
    output  wire    [31 : 0]    reg_read_data1,
    output  wire    [31 : 0]    reg_read_data2 
);

(*ram_style = "distributed"*) reg [31 : 0] reg_ram [31 : 0];

assign reg_read_data1 = reg_ram[read_port1_addr];
assign reg_read_data2 = reg_ram[read_port2_addr];

always @(posedge clk) begin
    if (we && write_port_addr != 0)
        reg_ram[write_port_addr] <= reg_write_data;
end

endmodule
