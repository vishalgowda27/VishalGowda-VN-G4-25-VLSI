`timescale 1ns / 1ps

module tb_PIPELINE;

reg clk;
reg rst;

wire [31:0] DM_Addr_Out;
wire [31:0] DM_WrData_Out;
wire [3:0]  DM_WrMask_Out;
wire        DM_WrEn_Out;
wire [31:0] PC_Out;
integer cycle = 0;
RISCV_PIPELINE_TOP dut(

    .clk(clk),
    .rst(rst),

    .DM_Addr_Out(DM_Addr_Out),
    .DM_WrData_Out(DM_WrData_Out),
    .DM_WrMask_Out(DM_WrMask_Out),
    .DM_WrEn_Out(DM_WrEn_Out),

    .PC_Out(PC_Out)

);

// Clock Generation
always #5 clk = ~clk;

// Reset
initial begin

    clk = 0;
    rst = 1;

    $dumpfile("pipeline.vcd");
    $dumpvars(0, tb_PIPELINE);

    #30;
    rst = 0;

    #300;

    $finish;

end
always @(posedge clk) begin
    #1;

    if (!rst) begin
        cycle = cycle + 1;

        $display("\n============================================================");
        $display("Cycle : %0d", cycle);
        $display("PC    : %h", dut.PC_F);
        $display("Instr : %h", dut.Instruction_D);

        // Register File
        $display("\nRegister File");
        $display("-------------");
        $display("x1=%h  x2=%h  x3=%h  x4=%h",
                 dut.RF_INST.my_regs[1],
                 dut.RF_INST.my_regs[2],
                 dut.RF_INST.my_regs[3],
                 dut.RF_INST.my_regs[4]);

        // Decode
        $display("\nDecode Stage");
        $display("------------");
        $display("rs1=%0d (%h)   rs2=%0d (%h)",
                 dut.rs1, dut.Src_Data1,
                 dut.rs2, dut.Src_Data2);

        // Execute
        $display("\nExecute Stage");
        $display("-------------");
        $display("ForwardA=%b  ForwardB=%b",
                 dut.ForwardA,
                 dut.ForwardB);

        $display("ALU Result = %h",
                 dut.ALU_Result);

        // Memory
        if (dut.DM_WrEn_M)
        begin
            $display("\nMemory Stage");
            $display("------------");
            $display("STORE Addr=%h Data=%h",
                     dut.DM_Addr_Out,
                     dut.DM_WrData_Out);
        end

        // Writeback
        if (dut.Reg_WrEn_W)
        begin
            $display("\nWriteback");
            $display("---------");
            $display("x%0d <= %h",
                     dut.rd_W,
                     dut.Writeback_Data);
        end

        $display("============================================================");

        $display("x1 = %h", dut.RF_INST.my_regs[1]);
        $display("x2 = %h", dut.RF_INST.my_regs[2]);
        $display("x3 = %h", dut.RF_INST.my_regs[3]);
        $display("x4 = %h", dut.RF_INST.my_regs[4]);
    end
end


endmodule