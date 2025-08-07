`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2025 12:19:50 PM
// Design Name: 
// Module Name: SingleCycleCPU
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


module SingleCycleCPU( 
input logic clk,
input logic rst_n
);
reg [31:0] pc;
logic [31:0] pc_next;
wire [31:0] mem_read;


always_comb begin : pcSelect
    pc_next = pc + 4;
end
always @(posedge clk) begin
    if(rst_n == 0) begin
        pc <= 32'b0;
    end else begin
        pc <= pc_next;
    end
end

  logic [31:0] instruction;
    
    Memory  #(
    ) instruction_mem (
        .clk(clk),
        .address(pc),
        .write_data(32'b0),    // Instruction memory is read-only
        .write_enable(1'b0),   // Always disabled
        .rst_n(1'b1),          // Reset disabled
        .read_data(instruction)
    );
    
    // Instruction Decoding
    logic [6:0] op = instruction[6:0];
    logic [2:0] func3 = instruction[14:12];
    logic       alu_zero;  // From ALU
    
    // Control Signals
    logic [2:0] alu_control;
    logic [1:0] imm_source;
    logic       mem_write;
    logic       reg_write;
    
    // Control Unit Instantiation
    ControlUnit ControlUnit(
        //Inputs
        .opcode(op),
        .funct3(func3),
        .funct7(7'b0),       // Not used in basic implementation
        .zero_flag(alu_zero),
        
        //Outputs
        .alu_control(alu_control),
        .imm_source(imm_source),
        .mem_write(mem_write),
        .reg_write(reg_write),
        
        //Multiplexer
        .alu_source(alu_source),
        .write_back_source(write_back_source)

    );
    
    
logic [4:0] source_reg1;
assign source_reg1 = instruction[19:15];
logic [4:0] source_reg2;
assign source_reg2 = instruction[24:20];
logic [4:0] dest_reg;
assign dest_reg = instruction[11:7];
wire [31:0] read_reg1;
wire [31:0] read_reg2;

logic [31:0] write_back_data;

logic [31:0] write_back_data;

always_comb begin : memory_source_select
    case (write_back_source)
        1'b1: write_back_data = alu_result;
        default: write_back_data = mem_read;
    endcase
end


Registers regfile(
    // basic signals
    .clk(clk),
    .rst_n(rst_n),
    // Read In
    .address1(source_reg1),
    .address2(source_reg2),
    // Read out
    .read_data1(read_reg1),
    .read_data2(read_reg2),
    // Write In
    .write_enable(reg_write),
    .write_data(write_back_data),
    .address3(dest_reg)
);


logic [24:0] raw_imm;
assign raw_imm = instruction[31:7];
wire [31:0] immediate;
SignExtension sign_extender(
    .source(raw_imm),
    .imm_source(imm_source),
    .extended_imm(immediate)
);





wire [31:0] alu_result;
logic [31:0] alu_src2;
always_comb begin : alu_source_select
    case (alu_source)
        1'b1: alu_src2 = immediate;
        default: alu_src2 = read_reg2;
    endcase
end

ALU alu_inst(
    .alucontrol(alu_control),
    .source1(read_reg1),
    .source2(alu_src2),
    .result(alu_result),
    .zero(alu_zero)
);



Memory #(
) data_memory (
    // Memory inputs
    .clk(clk),
    .address(alu_result),
    .write_data(read_reg2),
    .write_enable(mem_write),
    .rst_n(1'b1),
    // Memory outputs
    .read_data(mem_read)
);
endmodule

