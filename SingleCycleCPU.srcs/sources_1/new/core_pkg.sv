`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2025 10:40:15 AM
// Design Name: 
// Module Name: core_pkg
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



    
package core__pkg;
// INSTRUCTION OP CODES
    typedef enum logic [6:0] {
        OPCODE_R_TYPE = 7'b0110011,
        OPCODE_I_TYPE_ALU = 7'b0010011,
        OPCODE_I_TYPE_LOAD = 7'b0000011,
        OPCODE_S_TYPE = 7'b0100011,
        OPCODE_B_TYPE = 7'b1100011,
        OPCODE_U_TYPE_LUI = 7'b0110111,
        OPCODE_U_TYPE_AUIPC = 7'b0010111,
        OPCODE_J_TYPE = 7'b1101111,
        OPCODE_J_TYPE_JALR = 7'b1100111
    } opcode_t;
    // ALU OPs for ALU DECODERx 
    typedef enum logic [1:0] {
        ALU_OP_LOAD_STORE = 2'b00,
        ALU_OP_BRANCHES = 2'b01,
        ALU_OP_MATH = 2'b10
    } alu_op_t ;
    

endpackage
