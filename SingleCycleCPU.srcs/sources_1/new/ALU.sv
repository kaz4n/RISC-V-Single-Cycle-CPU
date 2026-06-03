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

input logic [3:0] alucontrol ,


output logic [31:0] result,
output logic zero
 );
 
 logic [4:0] shamt;
 assign shamt = source2[4:0];
always_comb begin
case (alucontrol)
    4'b0000 : result = source1 + source2;
    4'b0001 : result = source1 + (~source2 + 1'b1); 
    4'b0010 : result = source1&source2; //and
    4'b0011 : result = source1|source2;  //or
    4'b1000 : result = source1^source2; //xor
    //set less than, by default the numbers are unsigned therefore any negative number 
    //will be considered as a very large number, hence we use $signed() 
    4'b0101: result = {31'b0, $signed(source1) < $signed(source2)};
    //for the stliu, unsigned version 
    4'b0111 : result = {31'b0, source1 < source2 };
    4'b0100: source1 <<source2; //SLLI
    4'b0110: source1 >> shamt; //SRLI
    4'b1001: source1 >>>  shamt; //SRAI
    default: result = 32'b0;
    endcase
end


assign zero = result == 32'b0;

 
endmodule
