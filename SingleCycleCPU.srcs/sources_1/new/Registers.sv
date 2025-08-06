`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 03:02:18 PM
// Design Name: 
// Module Name: Registers
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


module Registers(

input logic clk,
input logic rst_n,

input logic [4:0] address1,
input logic [4:0] address2,
output logic [31:0] read_data1,
output logic [31:0] read_data2,

input logic [4:0] address3,
input logic [31:0] write_data,
input logic write_enable);


reg [31:0] registers [0:31];


always @(posedge clk) begin
if(rst_n == 1'b0) begin
    for(int i = 0; i<32; i++) begin
        registers[i] <= 32'b0;
    end
end
// Write, except on 0, reserved for a zero constant according to RISC-V specs
else if(write_enable == 1'b1 && address3 != 0) begin
    registers[address3] <= write_data;
    end
end
// Read logic, async
always_comb begin : readLogic
    read_data1 = registers[address1];
    read_data2 = registers[address2];
end



endmodule
