`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 03:26:07 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
input logic [31:0]source1,
input logic [31:0]source2,

input logic [2:0] alucontrol ,


output logic [31:0] result,
output logic zero
 );
 
 
 
always_comb begin
case (alucontrol)
    3'b000 : result = source1 + source2;
    3'b001 : result = source1 - (~source2 + 1'b1); 
    3'b010 : result = source1&source2;
    3'b011 : result = source1|source2; 
    
    default: result = 32'b0;
    endcase
end


assign zero = result == 32'b0;

 
endmodule
