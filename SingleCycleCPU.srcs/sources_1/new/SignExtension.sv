`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 04:17:50 PM
// Design Name: 
// Module Name: SignExtension
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


module SignExtension(

input logic [2:0] imm_source,
input logic  [24:0] source,
output logic [31:0] extended_imm
    );
logic [11:0] gathered_imm;
always_comb begin
    case(imm_source)
        // For I-Types
        3'b000 : extended_imm = {{20{source[24]}}, source[24:13]};
        // For S-types
        3'b001 : extended_imm = {{20{source[24]}},source[24:18],source[4:0]};
        // For B-types
        3'b010 : extended_imm = {{20{source[24]}},source[0],source[23:18],source[4:1],1'b0};
        // For J-types
        3'b011 : extended_imm = {{12{source[24]}},source[12:5], source[13], source[23:14], 1'b0};
        3'b100: extended_imm = {source[24:5],12'b000000000000};
        default: extended_imm  = 12'b0;
    endcase
end


    
endmodule
