module imm_adder(
    input Iadder_src_In,
    input [31:0] PC_In,
    input [31:0] Src_Data1_In,
    input [31:0] Imm_Data_In,

    output reg [31:0] Added_Data_Out
);

always @(*) begin

    if(Iadder_src_In)
        Added_Data_Out = Src_Data1_In + Imm_Data_In;
    else
        Added_Data_Out = PC_In + Imm_Data_In;

end

endmodule