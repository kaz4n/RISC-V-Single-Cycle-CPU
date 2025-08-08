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
import core__pkg::*;



module ControlUnit(
input logic [6:0]opcode,
input logic [2:0] funct3,
input logic [6:0] funct7,
input logic zero_flag,


output logic [2:0] alu_control,
output logic [2:0] imm_source,
output logic mem_write,
output logic reg_write,
output logic alu_source,
output logic [1:0] write_back_source,
output logic pc_source,
output logic second_add_source

    );

logic [1:0] alu_op;
logic branch;
logic jump;

always_comb begin
    case(opcode)

        // load instruction I-Type
        7'b0000011: begin
            reg_write = 1'b1;
            imm_source = 3'b000;
            mem_write = 1'b0;
            alu_op = 2'b00; 
            alu_source = 1'b1; // from immediate sign extender
            write_back_source = 2'b01; //from memory
            branch = 1'b0;
            jump = 1'b0;
            end
        // I-type ALU
        7'b0010011: begin
            reg_write = 1'b1;
            imm_source = 3'b000;
            mem_write = 1'b0;
            alu_op = 2'b10; 
            alu_source = 1'b1; //from sign extender 
            write_back_source = 2'b00; 
            branch = 1'b0;
            jump = 1'b0;
        end
        // Store Instruction S-Type
        7'b0100011: begin
            reg_write = 1'b0;
            imm_source = 3'b001;
            mem_write = 1'b1;
            alu_op = 2'b00;  
            alu_source = 1'b1; // from immediate sign extender
            write_back_source = 2'bxx; //from ALU result 
            branch = 1'b0;
            jump = 1'b0;
    
            end
            7'b0010111 : begin
            reg_write = 1'b1;
            imm_source= 3'bxxx;
            mem_write = 1'b0;
            alu_op = 2'b10;
            alu_source = 1'b0; 
            write_back_source = 2'b00; 
            branch = 1'b0;
            jump = 1'b0;
            end
         // R-Type
         7'b0110011 : begin
            reg_write = 1'b1;
            imm_source= 3'bxxx;
            mem_write = 1'b0;
            alu_op = 2'b10;
            alu_source = 1'b0; 
            write_back_source = 2'b00; 
            branch = 1'b0;
            jump = 1'b0;
            end
         //auipc
         7'b0110111, 7'bb0010111 : begin
            reg_write = 1'b1;
            imm_source= 3'b100;
            mem_write = 1'b0;
            write_back_source = 2'b11; 
            branch = 1'b0;
            jump = 1'b0;
            case(opcode[5])
                1'b0: second_add_source = 1'b0;
                1'b1: second_add_source = 1'b1;
            endcase
            end
            
         //for Branch if equal
         7'b1100011: begin
            reg_write = 1'b0;
            imm_source = 3'b010;
            mem_write = 1'b0;
            alu_op = 2'b01;
            alu_source = 1'b0; 
            write_back_source = 2'bxx;
            branch = 1'b1;
            jump = 1'b0;

         end
         
         //for J-type branch uncondtionally
         7'b1101111: begin
            reg_write = 1'b1;
            imm_source = 3'b011;
            mem_write = 1'b0;
            alu_op = 2'bxx;
            alu_source = 1'bx; 
            write_back_source = 2'b10;
            branch = 1'b1;
            jump = 1'b1;

         end 
        default: begin 
            reg_write = 1'b0;
            imm_source = 3'b000;
            mem_write = 1'b0;
            alu_op = 2'b00;
            alu_source = 1'b0; 
            write_back_source = 2'b0; 
            branch = 1'b0;  
            jump = 1'b1;

        end

    endcase
end


always_comb begin

    case(alu_op)
        // store or load instruction
        2'b00: alu_control = 3'b000;
        // branch if equal instruction 
        2'b01: alu_control = 3'b001;
        //all other instructions 
        2'b10: begin 
            case(funct3) 
                // ADD 
                3'b000:
                    case({opcode[5],funct7[5]})
                        //for subtraction
                        2'b11: alu_control = 3'b001;
                        //for addition
                        default: alu_control = 3'b000;
                    endcase
                    
                    
                //for Set Less Than
                3'b010: alu_control = 3'b101;
                //for Or
                3'b110: alu_control = 3'b011;
                //for And
                3'b111: alu_control = 3'b010; 
                
                default: alu_control = 3'b111;
            endcase
        end
        default: alu_control = 3'b111;
    endcase
end

assign pc_source = (zero_flag & branch)|jump; 

endmodule
