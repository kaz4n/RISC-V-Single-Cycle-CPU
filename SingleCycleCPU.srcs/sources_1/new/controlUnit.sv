`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 04:21:16 PM
// Design Name: 
// Module Name: controlUnit
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


module ControlUnit(
input logic [6:0]opcode,
input logic [2:0] funct3,
input logic [6:0] funct7,
input logic zero_flag,


output logic [2:0] alu_control,
output logic [1:0] imm_source,
output logic mem_write,
output logic reg_write
    );

logic [1:0] alu_op;

always_comb begin
case(opcode)

// load instruction
    7'b0000011: begin
        reg_write = 1'b1;
        imm_source = 2'b00;
        mem_write = 1'b0;
        alu_op = 2'b00;
    end
    
    default: begin 
        reg_write = 1'b0;
        imm_source = 2'b00;
        mem_write = 1'b0;
        alu_op = 2'b00;
    end



endcase
end

endmodule
