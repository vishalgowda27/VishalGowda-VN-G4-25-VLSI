module store_unit(
    input DM_WrEn_In,
    input [2:0] Func3_In,
    input [31:0] Added_Data_In,
    input [31:0] Src_Data2_In,

    output reg [31:0] DM_Addr_Out,
    output reg [31:0] DM_WrData_Out,
    output reg [3:0] DM_WrMask_Out,
    output reg DM_WrEn_Out
);

always @(*) begin

    DM_Addr_Out   = Added_Data_In;
    DM_WrData_Out = Src_Data2_In;
    DM_WrEn_Out   = DM_WrEn_In;

    case(Func3_In)

        3'b000: DM_WrMask_Out = 4'b0001; // SB

        3'b001: DM_WrMask_Out = 4'b0011; // SH

        3'b010: DM_WrMask_Out = 4'b1111; // SW

        default: DM_WrMask_Out = 4'b0000;

    endcase

end

endmodule