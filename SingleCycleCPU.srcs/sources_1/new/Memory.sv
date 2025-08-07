`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2025 12:21:30 PM
// Design Name: 
// Module Name: Memory
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


module Memory (

input logic clk,
input logic [31:0] address,
input logic [31:0] write_data,
input logic write_enable,
input logic rst_n,
output logic [31:0] read_data


);


logic [31:0] mem [0:63]; 





always @(posedge clk) begin
// reset logic
if (rst_n == 1'b0) begin
for (int i = 0; i < 64; i++) begin
    mem[i] <= 32'b0;
    end
end
else if (write_enable) begin
    if (address[1:0] == 2'b00) begin
        mem[address[31:2]] <= write_data;
        end
    end
end
always_comb begin
    read_data = mem[address[31:2]];
end
endmodule