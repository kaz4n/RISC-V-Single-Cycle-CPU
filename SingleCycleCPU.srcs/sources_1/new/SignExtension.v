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

input logic [1:0] imm_source,
input logic  [24:0] source,
output logic [31:0] extended_imm
    );
logic [11:0] gathered_imm;
always_comb begin
    case(imm_source)
    2'b00: gathered_imm = source[24:13];
    default: gathered_imm = 12'b0;
    endcase
end

assign extended_imm = {{20{gathered_imm[11]}}, gathered_imm};

    
endmodule
