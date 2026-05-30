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

// we can write to a register whilst getting data from 2 of them at the same time

module regfile(
//clock and reset pin 
input logic clk,
input logic rst_n,

//reading stuff
input logic [4:0] address1, //reg read 1 
input logic [4:0] address2, //reg read 2
output logic [31:0] read_data1,
output logic [31:0] read_data2,

//writing stuff
input logic [4:0] address3, //where to write to 
input logic [31:0] write_data, 
input logic write_enable); 


//we have an array of registers, 
//each register is 32 bit and there is 32 regsiters in total 
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
// asynchronously read from the regfile as reading and writing use different addr buses 
always_comb begin : readLogic
    read_data1 = registers[address1];
    read_data2 = registers[address2];
end



endmodule
