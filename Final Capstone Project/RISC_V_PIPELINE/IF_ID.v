module IF_ID(

    input clk,
    input rst,
    input IF_ID_Write,
    input Flush_D,
    // Inputs from IF Stage
    input  [31:0] PC_F,
    input  [31:0] PC_Plus4_F,
    input  [31:0] Instruction_F,

    // Outputs to ID Stage
    output reg [31:0] PC_D,
    output reg [31:0] PC_Plus4_D,
    output reg [31:0] Instruction_D

);

always @(posedge clk or posedge rst)
begin

    if(rst)
begin
    PC_D <= 32'b0;
    PC_Plus4_D <= 32'b0;
    Instruction_D <= 32'h00000013;
end
else if(Flush_D)
begin
    PC_D <= 32'b0;
    PC_Plus4_D <= 32'b0;
    Instruction_D <= 32'h00000013;   // NOP
end
else if(IF_ID_Write)
begin
    PC_D <= PC_F;
    PC_Plus4_D <= PC_Plus4_F;
    Instruction_D <= Instruction_F;
end

end

endmodule