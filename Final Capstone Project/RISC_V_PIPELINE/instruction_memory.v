module instruction_memory(

    input  [31:0] PC_In,
    output [31:0] Instruction_Out

);

    // 256 x 32-bit Instruction Memory
    reg [31:0] instruction_mem [0:255];

    integer i;

    initial begin

    // Initialize all instructions to NOP
    for(i = 0; i < 256; i = i + 1)
        instruction_mem[i] = 32'h00000013;
//==================================================
// RV32I Verification Program - Stage 1
//==================================================


instruction_mem[0]  = 32'h123450B7;   // lui   x1,0x12345
// 1
instruction_mem[1]  = 32'h00000117;   // auipc x2,0
// 2
instruction_mem[2]  = 32'h00A00193;   // addi  x3,x0,10
// 3
instruction_mem[3]  = 32'h0081F213;   // andi  x4,x3,8
// 4
instruction_mem[4]  = 32'h00326293;   // ori   x5,x4,3
// 5
instruction_mem[5]  = 32'h00F2C313;   // xori  x6,x5,15
// 6
instruction_mem[6]  = 32'h00231393;   // slli  x7,x6,2
// 7
instruction_mem[7]  = 32'h0013D413;   // srli  x8,x7,1
// 8
instruction_mem[8]  = 32'h4013D493;   // srai  x9,x7,1
// 9
instruction_mem[9]  = 32'h0141A513;   // slti  x10,x3,20
// 10
instruction_mem[10] = 32'h0051B593;   // sltiu x11,x3,5
//11
instruction_mem[11] = 32'h00418633;   // add  x12, x3, x4
//12
instruction_mem[12] = 32'h404186B3;   // sub  x13, x3, x4
//13
instruction_mem[13] = 32'h0051F733;   // and  x14, x3, x5
//14
instruction_mem[14] = 32'h006267B3;   // or   x15, x4, x6
//15
instruction_mem[15] = 32'h0062C833;   // xor  x16, x5, x6
//16
instruction_mem[16] = 32'h002318B3;   // sll  x17, x6, x2
//17
instruction_mem[17] = 32'h0023D933;   // srl  x18, x7, x2
//18
instruction_mem[18] = 32'h4023D9B3;   // sra  x19, x7, x2
//19
instruction_mem[19] = 32'h00322A33;   // slt  x20, x4, x3
//20
instruction_mem[20] = 32'h0041BAB3;   // sltu x21, x3, x4
//21
instruction_mem[21] = 32'h00000093;   // addi x1,x0,0
//22
instruction_mem[22] = 32'h0000A103;   // lw   x2,0(x1)
//23
instruction_mem[23] = 32'h00510193;   // addi x3,x2,5
//24
instruction_mem[24] = 32'h00000013;   // nop
//25
instruction_mem[25] = 32'h00000013;   // nop
//26

instruction_mem[0] = 32'h02A00093;   // addi x1,x0,42
instruction_mem[1] = 32'h00000013;   // nop
instruction_mem[2] = 32'h00000013;   // nop
instruction_mem[4] = 32'h00102023;   // sw x1,0(x0)
instruction_mem[5] = 32'h00002103;   // lw x2,0(x0)
end
    // Instruction Fetch
    assign Instruction_Out = instruction_mem[PC_In[9:2]];

endmodule