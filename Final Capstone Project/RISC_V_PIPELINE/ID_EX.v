module ID_EX(
    input clk,
    input rst,
    input Flush_E,

    //==========================
    // Data Signals from Decode
    //==========================
    input  [31:0] PC_D,
    input  [31:0] PC_plus4_D,
    input  [31:0] Src_Data1_D,
    input  [31:0] Src_Data2_D,
    input  [31:0] Imm_Data_D,

    input  [4:0]  rs1_D,
    input  [4:0]  rs2_D,
    input  [4:0]  rd_D,
    input  [2:0] funct3_D,

    //==========================
    // Control Signals
    //==========================
    input         Reg_WrEn_D,
    input  [2:0]  Result_Src_D,
    input  [3:0]  ALU_Control_D,
    input         ALU_Src_D,
    input         DM_WrEn_D,
    input  [1:0]  Load_Size_D,
    input         Load_Unsigned_D,
    input  [7:0]  Branch_Cond_D,
    input         ladder_Src_D,

    //==========================
    // Data Outputs to Execute
    //==========================
    output reg [31:0] PC_E,
    output reg [31:0] PC_plus4_E,
    output reg [31:0] Src_Data1_E,
    output reg [31:0] Src_Data2_E,
    output reg [31:0] Imm_Data_E,

    output reg [4:0] rs1_E,
    output reg [4:0] rs2_E,
    output reg [4:0] rd_E,
    output reg [2:0] funct3_E,

    //==========================
    // Control Outputs
    //==========================
    output reg        Reg_WrEn_E,
    output reg [2:0]  Result_Src_E,
    output reg [3:0]  ALU_Control_E,
    output reg        ALU_Src_E,
    output reg        DM_WrEn_E,
    output reg [1:0]  Load_Size_E,
    output reg        Load_Unsigned_E,
    output reg [7:0]  Branch_Cond_E,
    output reg        ladder_Src_E
);

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        // Data Signals
        PC_E              <= 32'b0;
        PC_plus4_E        <= 32'b0;
        Src_Data1_E       <= 32'b0;
        Src_Data2_E       <= 32'b0;
        Imm_Data_E        <= 32'b0;

        rs1_E             <= 5'b0;
        rs2_E             <= 5'b0;
        rd_E              <= 5'b0;
        funct3_E          <= 3'b000;

        // Control Signals
        Reg_WrEn_E        <= 1'b0;
        Result_Src_E      <= 3'b000;
        ALU_Control_E     <= 4'b0000;
        ALU_Src_E         <= 1'b0;
        DM_WrEn_E         <= 1'b0;
        Load_Size_E       <= 2'b00;
        Load_Unsigned_E   <= 1'b0;
        Branch_Cond_E     <= 8'b00000000;
        ladder_Src_E      <= 1'b0;
    end
    else if (Flush_E)
    begin
        // Data Signals
        PC_E              <= 32'b0;
        PC_plus4_E        <= 32'b0;
        Src_Data1_E       <= 32'b0;
        Src_Data2_E       <= 32'b0;
        Imm_Data_E        <= 32'b0;

        rs1_E             <= 5'b0;
        rs2_E             <= 5'b0;
        rd_E              <= 5'b0;
        funct3_E          <= 3'b000;

        // Control Signals
        Reg_WrEn_E        <= 1'b0;
        Result_Src_E      <= 3'b000;
        ALU_Control_E     <= 4'b0000;
        ALU_Src_E         <= 1'b0;
        DM_WrEn_E         <= 1'b0;
        Load_Size_E       <= 2'b00;
        Load_Unsigned_E   <= 1'b0;
        Branch_Cond_E     <= 8'b00000000;
        ladder_Src_E      <= 1'b0;
    end
    else
    begin
        // Data Signals
        PC_E              <= PC_D;
        PC_plus4_E        <= PC_plus4_D;
        Src_Data1_E       <= Src_Data1_D;
        Src_Data2_E       <= Src_Data2_D;
        Imm_Data_E        <= Imm_Data_D;

        rs1_E             <= rs1_D;
        rs2_E             <= rs2_D;
        rd_E              <= rd_D;
        funct3_E          <= funct3_D;
        // Control Signals
        Reg_WrEn_E        <= Reg_WrEn_D;
        Result_Src_E      <= Result_Src_D;
        ALU_Control_E     <= ALU_Control_D;
        ALU_Src_E         <= ALU_Src_D;
        DM_WrEn_E         <= DM_WrEn_D;
        Load_Size_E       <= Load_Size_D;
        Load_Unsigned_E   <= Load_Unsigned_D;
        Branch_Cond_E     <= Branch_Cond_D;
        ladder_Src_E      <= ladder_Src_D;
    end
end

endmodule