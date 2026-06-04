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
logic [31:0] pc_target;
logic [31:0] pc_plus_four;
wire pc_source;

assign pc_plus_four = pc + 4;

wire [31:0] mem_read;


always_comb begin : pcSelect
    case(pc_source)
        1'b1: pc_next = pc_target ;
        1'b0: pc_next = pc_plus_four;
    endcase
end

always @(posedge clk) begin
    if(rst_n == 0) begin
        pc <= 32'b0;
    end else begin
        pc <= pc_next;
    end
end

  logic [31:0] instruction;
    
    memory  #(
        .mem_init("./test_instructionmemory.hex")
            ) 
instruction_mem (
        .clk(clk),
        .address(pc),
        .write_data(32'b0),    // Instruction memory is read only
        .write_enable(1'b0),   // Always disabled
        .rst_n(1'b1),          // Reset disabled
        //the instruction
        .read_data(instruction)
    );
    
    // Instruction Decoding
    logic [6:0] op = instruction[6:0];
    logic [2:0] func3 = instruction[14:12];
    logic [6:0] func7 = instruction[31:25];

    logic       alu_zero;  // From ALU
    
    // Control Signals
    logic [3:0] alu_control;
    logic [2:0] imm_source;
    logic       mem_write;
    logic       reg_write;
    wire [1:0] second_add_source;
    
    // Control Unit Instantiation
    ControlUnit ControlUnit(
        //Inputs
        .opcode(op),
        .funct3(func3),
        .funct7(func7),       // Not used in basic implementation
        .zero_flag(alu_zero),
        
        //Outputs
        .alu_control(alu_control),
        .imm_source(imm_source),
        .mem_write(mem_write),
        .reg_write(reg_write),
        .pc_source(pc_source),
        .second_add_source(second_add_source)
        
        //Multiplexer
        .alu_source(alu_source),
        .write_back_source(write_back_source)

    );
    
    always_comb begin : second_add_select
        case(second_add_source) 
            2'b0: pc_target = pc + immediate ; 
            2'b1: pc_target = immediate; 
    endcase
    end 

logic [4:0] source_reg1;
assign source_reg1 = instruction[19:15];
logic [4:0] source_reg2;
assign source_reg2 = instruction[24:20];
logic [4:0] dest_reg;
assign dest_reg = instruction[11:7];
wire [31:0] read_reg1;
wire [31:0] read_reg2;
wire [1:0] write_back_source;
logic [31:0] write_back_data;


always_comb begin : memory_source_select
    case (write_back_source)
        2'b00: write_back_data = alu_result; 
        2'b01: write_back_data = mem_read;
        2'b10: write_back_data = pc_plus_four; 
        2'b11: write_back_data = pc_target; 
        default: write_back_data =32'b0;
    endcase
end


regfile regfile(
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
signExtension sign_extender(
    .source(raw_imm),
    .imm_source(imm_source),
    .extended_imm(immediate)
);





wire [31:0] alu_result;
logic [31:0] alu_src2;
always_comb begin : alu_source_select
    case (alu_source)
        1'b0: alu_src2 = read_reg2;
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



memory #(
.mem_init("./test_datamemory.hex")
)
data_memory (
    // Memory inputs
    .clk(clk),
    .address(alu_result), // the alu computes the new addr e.g. 0x4(r1) is the pointer r1 + 4
    .write_data(read_reg2), //data always taken from second register
    .write_enable(mem_write),
    .rst_n(1'b1), //reset is active low
    // Memory outputs
    .read_data(mem_read)
);
endmodule

