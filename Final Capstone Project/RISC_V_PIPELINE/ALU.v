module ALU(
    input  [31:0] A_in,
    input  [31:0] B_in,
    input  [3:0]  ALU_Control_in,
    output [31:0] ALU_Result_out
);

reg [31:0] ALU_Result;

always @(*) begin

    // Default value
    ALU_Result = 32'b0;

    case(ALU_Control_in)

        4'b0000: ALU_Result = A_in + B_in;                       // ADD / ADDI

        4'b0001: ALU_Result = A_in - B_in;                       // SUB

        4'b0010: ALU_Result = A_in & B_in;                       // AND / ANDI
        4'b0011: ALU_Result = A_in | B_in;                       // OR / ORI
        4'b0100: ALU_Result = A_in ^ B_in;                       // XOR / XORI
        4'b0101: ALU_Result = A_in << B_in[4:0];                 // SLL / SLLI
        4'b0110: ALU_Result = A_in >> B_in[4:0];                 // SRL / SRLI
        4'b0111: ALU_Result = $signed(A_in) >>> B_in[4:0];       // SRA / SRAI
        4'b1000: ALU_Result = ($signed(A_in) < $signed(B_in)) ?
                              32'd1 : 32'd0;                     // SLT / SLTI
        4'b1001: ALU_Result = (A_in < B_in) ?
                              32'd1 : 32'd0;                     // SLTU / SLTIU

        default: ALU_Result = 32'b0;

    endcase

end

assign ALU_Result_out = ALU_Result;

endmodule