module MEM_WB(
    input clk,
    input rst,

    //==========================
    // Data Signals from Memory
    //==========================
    input  [31:0] Loaded_Data_M,
    input  [31:0] ALU_Result_M,
    input  [31:0] PC_plus4_M,
    input  [4:0]  rd_M,

    //==========================
    // Control Signals
    //==========================
    input         Reg_WrEn_M,
    input  [2:0]  Result_Src_M,

    //==========================
    // Data Outputs to Writeback
    //==========================
    output reg [31:0] Loaded_Data_W,
    output reg [31:0] ALU_Result_W,
    output reg [31:0] PC_plus4_W,
    output reg [4:0]  rd_W,

    //==========================
    // Control Outputs
    //==========================
    output reg        Reg_WrEn_W,
    output reg [2:0]  Result_Src_W
);

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        Loaded_Data_W <= 32'b0;
        ALU_Result_W  <= 32'b0;
        PC_plus4_W    <= 32'b0;
        rd_W          <= 5'b0;

        Reg_WrEn_W    <= 1'b0;
        Result_Src_W  <= 3'b000;
    end
    else
    begin
        Loaded_Data_W <= Loaded_Data_M;
        ALU_Result_W  <= ALU_Result_M;
        PC_plus4_W    <= PC_plus4_M;
        rd_W          <= rd_M;

        Reg_WrEn_W    <= Reg_WrEn_M;
        Result_Src_W  <= Result_Src_M;
    end

    $display("MEM_WB @ %0t : rd=%0d RegWr=%b ResultSrc=%b ALU=%h Load=%h",
         $time,
         rd_W,
         Reg_WrEn_W,
         Result_Src_W,
         ALU_Result_W,
         Loaded_Data_W);
end

endmodule