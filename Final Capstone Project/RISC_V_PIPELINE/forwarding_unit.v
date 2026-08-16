module forwarding_unit(

    // Source registers of instruction in Execute stage
    input [4:0] rs1_E,
    input [4:0] rs2_E,

    // Destination register of instruction in Memory stage
    input [4:0] rd_M,
    input       Reg_WrEn_M,

    // Destination register of instruction in Writeback stage
    input [4:0] rd_W,
    input       Reg_WrEn_W,

    // Forwarding control outputs
    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB

);

always @(*) begin

    // Default:
    // 00 -> No forwarding
    ForwardA = 2'b00;
    ForwardB = 2'b00;

    //--------------------------------------------------
    // Forward Operand A
    //--------------------------------------------------

    // EX Hazard
    if (Reg_WrEn_M &&
        (rd_M != 5'b00000) &&
        (rd_M == rs1_E))
    begin
        ForwardA = 2'b10;
    end

    // MEM Hazard
    else if (Reg_WrEn_W &&
             (rd_W != 5'b00000) &&
             (rd_W == rs1_E))
    begin
        ForwardA = 2'b01;
    end

    //--------------------------------------------------
    // Forward Operand B
    //--------------------------------------------------

    // EX Hazard
    if (Reg_WrEn_M &&
        (rd_M != 5'b00000) &&
        (rd_M == rs2_E))
    begin
        ForwardB = 2'b10;
    end

    // MEM Hazard
    else if (Reg_WrEn_W &&
             (rd_W != 5'b00000) &&
             (rd_W == rs2_E))
    begin
        ForwardB = 2'b01;
    end

end

endmodule