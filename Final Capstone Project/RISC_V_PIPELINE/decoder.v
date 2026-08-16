module Decoder(
    input  [6:0] opcode_in,
    input  [2:0] funct3_in,
    input  [6:0] funct7_in,

    output reg       Reg_WrEn_Out,
    output reg [2:0] Imm_Type_Out,
    output reg       ladder_Src_Out,
    output reg       ALU_Src_Out,
    output reg [3:0] ALU_Control_Out,
    output reg       DM_WrEn_Out,
    output reg [7:0] Branch_Cond_Out,
    output reg       Load_Unsigned_Out,
    output reg [1:0] Load_Size_Out,
    output reg [2:0] Result_Src_Out
);

always @(*) begin

    // Default Values
    Reg_WrEn_Out      = 1'b0;
    Imm_Type_Out      = 3'b000;
    ladder_Src_Out    = 1'b0;
    ALU_Src_Out       = 1'b0;
    ALU_Control_Out   = 4'b0000;
    DM_WrEn_Out       = 1'b0;
    Branch_Cond_Out   = 8'b00000000;
    Load_Unsigned_Out = 1'b0;
    Load_Size_Out     = 2'b00;
    Result_Src_Out    = 3'b000;

    case(opcode_in)

    // ==========================
    // R-TYPE
    // ==========================
    7'b0110011: begin

        Reg_WrEn_Out = 1'b1;

        case({funct7_in,funct3_in})

            10'b0000000_000: ALU_Control_Out = 4'b0000; // ADD
            10'b0100000_000: ALU_Control_Out = 4'b0001; // SUB
            10'b0000000_111: ALU_Control_Out = 4'b0010; // AND
            10'b0000000_110: ALU_Control_Out = 4'b0011; // OR
            10'b0000000_100: ALU_Control_Out = 4'b0100; // XOR
            10'b0000000_001: ALU_Control_Out = 4'b0101; // SLL
            10'b0000000_101: ALU_Control_Out = 4'b0110; // SRL
            10'b0100000_101: ALU_Control_Out = 4'b0111; // SRA
            10'b0000000_010: ALU_Control_Out = 4'b1000; // SLT
            10'b0000000_011: ALU_Control_Out = 4'b1001; // SLTU

            default: ALU_Control_Out = 4'b0000;

        endcase
    end

    // ==========================
    // I-TYPE ALU
    // ==========================
    7'b0010011: begin

        Reg_WrEn_Out = 1'b1;
        ALU_Src_Out  = 1'b1;
        Imm_Type_Out = 3'b000;

        case(funct3_in)

            3'b000: ALU_Control_Out = 4'b0000; // ADDI
            3'b111: ALU_Control_Out = 4'b0010; // ANDI
            3'b110: ALU_Control_Out = 4'b0011; // ORI
            3'b100: ALU_Control_Out = 4'b0100; // XORI
            3'b010: ALU_Control_Out = 4'b1000; // SLTI
            3'b011: ALU_Control_Out = 4'b1001; // SLTIU
            3'b001: ALU_Control_Out = 4'b0101; // SLLI

            3'b101: begin
                if(funct7_in == 7'b0000000)
                    ALU_Control_Out = 4'b0110; // SRLI
                else
                    ALU_Control_Out = 4'b0111; // SRAI
            end

            default: ALU_Control_Out = 4'b0000;

        endcase

    end

    // ==========================
    // LOAD
    // ==========================
    7'b0000011: begin

        Reg_WrEn_Out   = 1'b1;
        ALU_Src_Out    = 1'b1;
        Imm_Type_Out   = 3'b000;
        Result_Src_Out = 3'b001;

        case(funct3_in)

            3'b000: begin
                Load_Size_Out = 2'b00;
                Load_Unsigned_Out = 1'b0;
            end

            3'b001: begin
                Load_Size_Out = 2'b01;
                Load_Unsigned_Out = 1'b0;
            end

            3'b010: begin
                Load_Size_Out = 2'b10;
                Load_Unsigned_Out = 1'b0;
            end

            3'b100: begin
                Load_Size_Out = 2'b00;
                Load_Unsigned_Out = 1'b1;
            end

            3'b101: begin
                Load_Size_Out = 2'b01;
                Load_Unsigned_Out = 1'b1;
            end

            default: begin
                Load_Size_Out = 2'b00;
                Load_Unsigned_Out = 1'b0;
            end

        endcase

    end

    // ==========================
    // STORE
    // ==========================
    7'b0100011: begin

        DM_WrEn_Out  = 1'b1;
        ALU_Src_Out  = 1'b1;
        Imm_Type_Out = 3'b001;

    end

    // ==========================
    // BRANCH
    // ==========================
    7'b1100011: begin

        Imm_Type_Out = 3'b010;

        case(funct3_in)

            3'b000: Branch_Cond_Out = 8'b00000001; // BEQ
            3'b001: Branch_Cond_Out = 8'b00000010; // BNE
            3'b100: Branch_Cond_Out = 8'b00000100; // BLT
            3'b101: Branch_Cond_Out = 8'b00001000; // BGE
            3'b110: Branch_Cond_Out = 8'b00010000; // BLTU
            3'b111: Branch_Cond_Out = 8'b00100000; // BGEU

            default: Branch_Cond_Out = 8'b00000000;

        endcase

    end

    // ==========================
    // JAL
    // ==========================
    7'b1101111: begin

        Reg_WrEn_Out   = 1'b1;
        Imm_Type_Out   = 3'b100;
        Result_Src_Out = 3'b010;

    end

    // ==========================
    // JALR
    // ==========================
    7'b1100111: begin

        Reg_WrEn_Out   = 1'b1;
        Imm_Type_Out   = 3'b000;
        Result_Src_Out = 3'b010;

    end

    // ==========================
    // LUI
    // ==========================
    
    7'b0110111: begin
    Reg_WrEn_Out    = 1'b1;
    Imm_Type_Out    = 3'b011;
    ALU_Src_Out     = 1'b1;
    ALU_Control_Out = 4'b0000;
end

    // ==========================
    // AUIPC
    // ==========================
    7'b0010111: begin
    Reg_WrEn_Out    = 1'b1;
    Imm_Type_Out    = 3'b011;
    ladder_Src_Out  = 1'b1;
    ALU_Src_Out     = 1'b1;
    ALU_Control_Out = 4'b0000;
end

    default: begin
    end

    endcase

end

endmodule