module hazard_unit(

    //-------------------------
    // Decode Stage
    //-------------------------
    input  [4:0] Src_Addr1_D_In,
    input  [4:0] Src_Addr2_D_In,

    //-------------------------
    // Execute Stage
    //-------------------------
    input  [4:0] Des_Addr_E_In,
    input        Reg_WrEn_E_In,
    input  [2:0] Result_Src_E_In,
    input  [4:0] Src_Addr1_E_In,
    input  [4:0] Src_Addr2_E_In,

    //-------------------------
    // Memory Stage
    //-------------------------
    input  [4:0] Des_Addr_M_In,
    input        Reg_WrEn_M_In,

    //-------------------------
    // Writeback Stage
    //-------------------------
    input  [4:0] Des_Addr_W_In,
    input        Reg_WrEn_W_In,

    //-------------------------
    // Branch
    //-------------------------
    input Branch_Taken_E_In,
    input MemRead_E,
    //-------------------------
    // Pipeline Control
    //-------------------------
    output reg Stall_F_Out,
    output reg Stall_D_Out,
    output reg Flush_D_Out,
    output reg Flush_E_Out,

    //-------------------------
    // Forwarding Control
    //-------------------------
    output reg [1:0] ForwardA_E_Out,
    output reg [1:0] ForwardB_E_Out,
    output reg PC_Write,
    output reg IF_ID_Write,
    output reg Control_Zero
);

always @(*) begin

    //-------------------------
    // Default outputs
    //-------------------------
    Stall_F_Out    = 1'b0;
    Stall_D_Out    = 1'b0;
    Flush_D_Out    = 1'b0;
    Flush_E_Out    = 1'b0;

    ForwardA_E_Out = 2'b00;
    ForwardB_E_Out = 2'b00;
    PC_Write     = 1'b1;
    IF_ID_Write  = 1'b1;
    Control_Zero = 1'b0;

    //--------------------------------------------------
    // Forward Operand A
    //--------------------------------------------------
    if (Reg_WrEn_M_In &&
        (Des_Addr_M_In != 5'd0) &&
        (Des_Addr_M_In == Src_Addr1_E_In))
    begin
        ForwardA_E_Out = 2'b10;
    end
    else if (Reg_WrEn_W_In &&
             (Des_Addr_W_In != 5'd0) &&
             (Des_Addr_W_In == Src_Addr1_E_In))
    begin
        ForwardA_E_Out = 2'b01;
    end

    //--------------------------------------------------
    // Forward Operand B
    //--------------------------------------------------
    if (Reg_WrEn_M_In &&
        (Des_Addr_M_In != 5'd0) &&
        (Des_Addr_M_In == Src_Addr2_E_In))
    begin
        ForwardB_E_Out = 2'b10;
    end
    else if (Reg_WrEn_W_In &&
             (Des_Addr_W_In != 5'd0) &&
             (Des_Addr_W_In == Src_Addr2_E_In))
    begin
        ForwardB_E_Out = 2'b01;
    end

   if ( MemRead_E &&
     (Des_Addr_E_In != 5'd0) &&
     (
        (Des_Addr_E_In == Src_Addr1_D_In) ||
        (Des_Addr_E_In == Src_Addr2_D_In)
     )
   )
begin
    PC_Write     = 1'b0;
    IF_ID_Write  = 1'b0;
    Control_Zero = 1'b1;
    
    Stall_F_Out = 1'b1;
    Stall_D_Out = 1'b1;
end

//--------------------------------------------------
// Branch Flush
//--------------------------------------------------
if (Branch_Taken_E_In)
begin
    Flush_D_Out = 1'b1;
    Flush_E_Out = 1'b1;
end
end

endmodule