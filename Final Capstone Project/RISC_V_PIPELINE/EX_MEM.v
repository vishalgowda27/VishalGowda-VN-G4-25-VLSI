module EX_MEM(
    input clk,
    input rst,

    //==========================
    // Data Signals from Execute
    //==========================
    input  [31:0] ALU_Result_E,
    input  [31:0] Src_Data2_E,
    input  [31:0] PC_plus4_E,
    input  [4:0]  rd_E,
    input  [2:0] funct3_E,

    //==========================
    // Control Signals
    //==========================
    input         Reg_WrEn_E,
    input  [2:0]  Result_Src_E,
    input         DM_WrEn_E,
    input  [1:0]  Load_Size_E,
    input         Load_Unsigned_E,

    //==========================
    // Data Outputs to Memory
    //==========================
    output reg [31:0] ALU_Result_M,
    output reg [31:0] Src_Data2_M,
    output reg [31:0] PC_plus4_M,
    output reg [4:0]  rd_M,
    output reg [2:0] funct3_M,

    //==========================
    // Control Outputs
    //==========================
    output reg        Reg_WrEn_M,
    output reg [2:0]  Result_Src_M,
    output reg        DM_WrEn_M,
    output reg [1:0]  Load_Size_M,
    output reg        Load_Unsigned_M
);

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        ALU_Result_M     <= 32'b0;
        Src_Data2_M      <= 32'b0;
        PC_plus4_M       <= 32'b0;
        rd_M             <= 5'b0;

        Reg_WrEn_M       <= 1'b0;
        Result_Src_M     <= 3'b000;
        DM_WrEn_M        <= 1'b0;
        Load_Size_M      <= 2'b00;
        Load_Unsigned_M  <= 1'b0;
        funct3_M         <= 3'b000;
    end
    else
    begin
        ALU_Result_M     <= ALU_Result_E;
        Src_Data2_M      <= Src_Data2_E;
        PC_plus4_M       <= PC_plus4_E;
        rd_M             <= rd_E;

        Reg_WrEn_M       <= Reg_WrEn_E;
        Result_Src_M     <= Result_Src_E;
        DM_WrEn_M        <= DM_WrEn_E;
        Load_Size_M      <= Load_Size_E;
        Load_Unsigned_M  <= Load_Unsigned_E;
        funct3_M         <= funct3_E;
    end
end

endmodule