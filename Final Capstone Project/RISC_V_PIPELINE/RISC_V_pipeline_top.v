module RISCV_PIPELINE_TOP(
    input clk,
    input rst,


    // Instruction from Instruction Memory
    // input  [31:0] instr_in,


    // Data Memory Interface
    output [31:0] DM_Addr_Out,
    output [31:0] DM_WrData_Out,
    output [3:0]  DM_WrMask_Out,
    output        DM_WrEn_Out,

    // Debug
    output [31:0] PC_Out
);


// PC UNIT


wire Branch_Taken;
wire [31:0] Branch_Target;

wire [31:0] PC_F;
wire [31:0] PC_plus4_F;

wire PC_Write;
wire IF_ID_Write;
wire Control_Zero;

//===========================
// Forwarding Unit Signals
//===========================

wire [1:0] ForwardA;
wire [1:0] ForwardB;

wire [31:0] ForwardA_Data;
wire [31:0] ForwardB_Data;
wire [31:0] Store_Data_E;
PC_Unit PC_INST(
    .clk(clk),
    .rst(rst),
    .PC_Write(PC_Write),          // ADD THIS
    .Branch_Taken(Branch_Taken),
    .Target_Address(Branch_Target),
    .PC_out(PC_F),
    .PC_plus4_out(PC_plus4_F)
);

assign PC_Out = PC_F;

wire [31:0] instruction_F;
instruction_memory IMEM_INST(

    .PC_In(PC_F),

    .Instruction_Out(instruction_F)

);
// INSTRUCTION FIELDS


wire [6:0] opcode;
wire [4:0] rd;
wire [2:0] funct3;
wire [4:0] rs1;
wire [4:0] rs2;
wire [6:0] funct7;

assign opcode = Instruction_D[6:0];
assign rd     = Instruction_D[11:7];
assign funct3 = Instruction_D[14:12];
assign rs1    = Instruction_D[19:15];
assign rs2    = Instruction_D[24:20];
assign funct7 = Instruction_D[31:25];

// DECODER


wire Reg_WrEn;
wire [2:0] Imm_Type;
wire ladder_Src;
wire ALU_Src;
wire [3:0] ALU_Control;
wire DM_WrEn;
wire [7:0] Branch_Cond;
wire Load_Unsigned;
wire [1:0] Load_Size;
wire [2:0] Result_Src;

Decoder DECODER_INST(
    .opcode_in(opcode),
    .funct3_in(funct3),
    .funct7_in(funct7),

    .Reg_WrEn_Out(Reg_WrEn),
    .Imm_Type_Out(Imm_Type),
    .ladder_Src_Out(ladder_Src),
    .ALU_Src_Out(ALU_Src),
    .ALU_Control_Out(ALU_Control),
    .DM_WrEn_Out(DM_WrEn),
    .Branch_Cond_Out(Branch_Cond),
    .Load_Unsigned_Out(Load_Unsigned),
    .Load_Size_Out(Load_Size),
    .Result_Src_Out(Result_Src)
);

//-----------------------------
// Control signals after hazard control
//-----------------------------
wire        Reg_WrEn_Final;
wire [2:0]  Result_Src_Final;
wire [3:0]  ALU_Control_Final;
wire        ALU_Src_Final;
wire        DM_WrEn_Final;
wire [1:0]  Load_Size_Final;
wire        Load_Unsigned_Final;
wire [7:0]  Branch_Cond_Final;
wire        ladder_Src_Final;

assign Reg_WrEn_Final      = Control_Zero ? 1'b0   : Reg_WrEn;
assign Result_Src_Final    = Control_Zero ? 'b0    : Result_Src;
assign ALU_Control_Final   = Control_Zero ? 4'b0000: ALU_Control;
assign ALU_Src_Final       = Control_Zero ? 1'b0   : ALU_Src;
assign DM_WrEn_Final       = Control_Zero ? 1'b0   : DM_WrEn;
assign Load_Size_Final     = Control_Zero ? 2'b00  : Load_Size;
assign Load_Unsigned_Final = Control_Zero ? 1'b0   : Load_Unsigned;
assign Branch_Cond_Final = Control_Zero ? 8'b00000000 : Branch_Cond;
assign ladder_Src_Final    = Control_Zero ? 1'b0   : ladder_Src;

// IMMEDIATE GENERATOR

wire [31:0] Imm_Data;

extend_unit EXT_INST(
    .instr_in(Instruction_D),
    .imm_out(Imm_Data)
);


// IF / ID PIPELINE REGISTER

wire [31:0] PC_D;
wire [31:0] PC_plus4_D;
wire [31:0] Instruction_D;

IF_ID IF_ID_INST(

    .clk(clk),
    .rst(rst),
    .IF_ID_Write(IF_ID_Write),   

    .PC_F(PC_F),
    .PC_Plus4_F(PC_plus4_F),
    .Instruction_F(instruction_F),

    .PC_D(PC_D),
    .PC_Plus4_D(PC_plus4_D),
    .Instruction_D(Instruction_D),

    .Flush_D(Flush_D)
);

// ID / EX PIPELINE REGISTER

wire [31:0] PC_E;
wire [31:0] PC_plus4_E;
wire [31:0] Src_Data1_E;
wire [31:0] Src_Data2_E;
wire [31:0] Imm_Data_E;

wire [4:0] rs1_E;
wire [4:0] rs2_E;
wire [4:0] rd_E;

wire Reg_WrEn_E;
wire [2:0] Result_Src_E;
wire [3:0] ALU_Control_E;
wire ALU_Src_E;
wire DM_WrEn_E;
wire [1:0] Load_Size_E;
wire Load_Unsigned_E;
wire [7:0] Branch_Cond_E;
wire ladder_Src_E;
wire [2:0] funct3_E;

ID_EX ID_EX_INST(
    .clk(clk),
    .rst(rst),
    .Flush_E(Flush_E),

    // Data
    .PC_D(PC_D),
    .PC_plus4_D(PC_plus4_D),
    .Src_Data1_D(Src_Data1),
    .Src_Data2_D(Src_Data2),
    .Imm_Data_D(Imm_Data),
    .rs1_D(rs1),
    .rs2_D(rs2),
    .rd_D(rd),
    .funct3_D(funct3),

    // Control
    .Reg_WrEn_D(Reg_WrEn_Final),
    .Result_Src_D(Result_Src_Final),
    .ALU_Control_D(ALU_Control_Final),
    .ALU_Src_D(ALU_Src_Final),
    .DM_WrEn_D(DM_WrEn_Final),
    .Load_Size_D(Load_Size_Final),
    .Load_Unsigned_D(Load_Unsigned_Final),
    .Branch_Cond_D(Branch_Cond_Final),
    .ladder_Src_D(ladder_Src_Final),

    // Outputs
    .PC_E(PC_E),
    .PC_plus4_E(PC_plus4_E),
    .Src_Data1_E(Src_Data1_E),
    .Src_Data2_E(Src_Data2_E),
    .Imm_Data_E(Imm_Data_E),
    .rs1_E(rs1_E),
    .rs2_E(rs2_E),
    .rd_E(rd_E),
    .funct3_E(funct3_E),

    .Reg_WrEn_E(Reg_WrEn_E),
    .Result_Src_E(Result_Src_E),
    .ALU_Control_E(ALU_Control_E),
    .ALU_Src_E(ALU_Src_E),
    .DM_WrEn_E(DM_WrEn_E),
    .Load_Size_E(Load_Size_E),
    .Load_Unsigned_E(Load_Unsigned_E),
    .Branch_Cond_E(Branch_Cond_E),
    .ladder_Src_E(ladder_Src_E)
);

//===========================
// EX / MEM PIPELINE SIGNALS
//===========================

wire [31:0] ALU_Result_M;
wire [31:0] Src_Data2_M;
wire [31:0] PC_plus4_M;
wire [4:0]  rd_M;

wire        Reg_WrEn_M;
wire [2:0]  Result_Src_M;
wire        DM_WrEn_M;
wire [1:0]  Load_Size_M;
wire        Load_Unsigned_M;
wire [2:0] funct3_M;

//===========================
// MEM / WB PIPELINE SIGNALS
//===========================

wire [31:0] Loaded_Data_W;
wire [31:0] ALU_Result_W;
wire [31:0] PC_plus4_W;
wire [4:0]  rd_W;

wire        Reg_WrEn_W;
wire [2:0]  Result_Src_W;

// REGISTER FILE


wire [31:0] Src_Data1;
wire [31:0] Src_Data2;

wire [31:0] Writeback_Data;

reg_file RF_INST(
    .clk(clk),
    .rst(rst),
    .WrEn_in(Reg_WrEn_W),
    .des_addr_in(rd_W),
    .des_data_in(Writeback_Data),
    .src_addr1_in(rs1),
    .src_addr2_in(rs2),
    .src_data1_out(Src_Data1),
    .src_data2_out(Src_Data2)
);

// ALU OPERAND MUX

wire [31:0] ALU_B;

assign ALU_B =
        (ALU_Src_E) ? Imm_Data_E :
                      ForwardB_Data;

// ALU
assign ForwardA_Data =
    (ForwardA == 2'b00) ? Src_Data1_E :
    (ForwardA == 2'b10) ? ALU_Result_M :
    (ForwardA == 2'b01) ? Writeback_Data :
                          Src_Data1_E;

                          assign ForwardB_Data =
    (ForwardB == 2'b00) ? Src_Data2_E :
    (ForwardB == 2'b10) ? ALU_Result_M :
    (ForwardB == 2'b01) ? Writeback_Data :
                          Src_Data2_E;

assign Store_Data_E = ForwardB_Data;
wire [31:0] ALU_Result;

wire Branch_Taken_E;

wire Equal;
wire Less;
wire LessU;

assign Equal = (ForwardA_Data == ALU_B);
assign Less  = ($signed(ForwardA_Data) < $signed(ALU_B));
assign LessU = (ForwardA_Data < ALU_B);
assign Branch_Taken_E =
       (Branch_Cond_E == 8'b00000001) ?  Equal :
       (Branch_Cond_E == 8'b00000010) ? !Equal :
       (Branch_Cond_E == 8'b00000100) ?  Less :
       (Branch_Cond_E == 8'b00001000) ? !Less :
       (Branch_Cond_E == 8'b00010000) ?  LessU :
       (Branch_Cond_E == 8'b00100000) ? !LessU :
                                         1'b0;  

    wire [31:0] ALU_A;

assign ALU_A = (ladder_Src_E) ? PC_E : ForwardA_Data;

ALU ALU_INST(
    .A_in(ALU_A),
    .B_in(ALU_B),
    .ALU_Control_in(ALU_Control_E),
    .ALU_Result_out(ALU_Result)
);


// BRANCH TARGET ADDER


imm_adder ADDER_INST(
    .Iadder_src_In(ladder_Src_E),
    .PC_In(PC_E),
    .Src_Data1_In(Src_Data1_E),
    .Imm_Data_In(Imm_Data_E),
    .Added_Data_Out(Branch_Target)
);

//===========================
// EX / MEM PIPELINE REGISTER
//===========================

EX_MEM EX_MEM_INST(
    .clk(clk),
    .rst(rst),

    // Data Inputs from Execute Stage
    .ALU_Result_E(ALU_Result),
    .Src_Data2_E(Store_Data_E),
    .PC_plus4_E(PC_plus4_E),
    .rd_E(rd_E),
    .funct3_E(funct3_E),
    .funct3_M(funct3_M),

    // Control Inputs from Execute Stage
    .Reg_WrEn_E(Reg_WrEn_E),
    .Result_Src_E(Result_Src_E),
    .DM_WrEn_E(DM_WrEn_E),
    .Load_Size_E(Load_Size_E),
    .Load_Unsigned_E(Load_Unsigned_E),

    // Data Outputs to Memory Stage
    .ALU_Result_M(ALU_Result_M),
    .Src_Data2_M(Src_Data2_M),
    .PC_plus4_M(PC_plus4_M),
    .rd_M(rd_M),

    // Control Outputs to Memory Stage
    .Reg_WrEn_M(Reg_WrEn_M),
    .Result_Src_M(Result_Src_M),
    .DM_WrEn_M(DM_WrEn_M),
    .Load_Size_M(Load_Size_M),
    .Load_Unsigned_M(Load_Unsigned_M)
    
);

// STORE UNIT


store_unit STORE_INST(
    .DM_WrEn_In(DM_WrEn_M),
    .Func3_In(funct3_M),
    .Added_Data_In(ALU_Result_M),
    .Src_Data2_In(Src_Data2_M),

    .DM_Addr_Out(DM_Addr_Out),
    .DM_WrData_Out(DM_WrData_Out),
    .DM_WrMask_Out(DM_WrMask_Out),
    .DM_WrEn_Out(DM_WrEn_Out)
);

wire [31:0] DM_ReadData;
data_memory DMEM_INST(
    .clk(clk),
    .WrEn(DM_WrEn_Out),
    .WrMask(DM_WrMask_Out),
    .Address(DM_Addr_Out),
    .Write_Data(DM_WrData_Out),
    .Read_Data(DM_ReadData)

);
// LOAD UNIT


wire [31:0] Loaded_Data;

load_unit LOAD_INST(
    .Read_Data_In(DM_ReadData),
    .Load_Size_In(Load_Size_M),
    .Load_Unsigned_In(Load_Unsigned_M),
    .Loaded_Data_Out(Loaded_Data)
);
//===========================
// MEM / WB PIPELINE REGISTER
//===========================

MEM_WB MEM_WB_INST(
    .clk(clk),
    .rst(rst),

    // Memory Stage Inputs
    .Loaded_Data_M(Loaded_Data),
    .ALU_Result_M(ALU_Result_M),
    .PC_plus4_M(PC_plus4_M),
    .rd_M(rd_M),

    .Reg_WrEn_M(Reg_WrEn_M),
    .Result_Src_M(Result_Src_M),

    // Writeback Stage Outputs
    .Loaded_Data_W(Loaded_Data_W),
    .ALU_Result_W(ALU_Result_W),
    .PC_plus4_W(PC_plus4_W),
    .rd_W(rd_W),

    .Reg_WrEn_W(Reg_WrEn_W),
    .Result_Src_W(Result_Src_W)
);

hazard_unit HAZARD_UNIT_INST(

    // Decode Stage
    .Src_Addr1_D_In(rs1),
    .Src_Addr2_D_In(rs2),

    .PC_Write(PC_Write),
    .IF_ID_Write(IF_ID_Write),
    .Control_Zero(Control_Zero),
    // Execute Stage
    .Des_Addr_E_In(rd_E),
    .Reg_WrEn_E_In(Reg_WrEn_E),
    .Result_Src_E_In(Result_Src_E),
    .MemRead_E(Result_Src_E == 3'b001),
    .Src_Addr1_E_In(rs1_E),
    .Src_Addr2_E_In(rs2_E),

    // Memory Stage
    .Des_Addr_M_In(rd_M),
    .Reg_WrEn_M_In(Reg_WrEn_M),

    // Writeback Stage
    .Des_Addr_W_In(rd_W),
    .Reg_WrEn_W_In(Reg_WrEn_W),

    // Branch
    .Branch_Taken_E_In(Branch_Taken_E),   

    // Pipeline Control
    .Stall_F_Out(),
    .Stall_D_Out(),
    .Flush_D_Out(Flush_D),
    .Flush_E_Out(Flush_E),

    // Forwarding Control
    .ForwardA_E_Out(ForwardA),
    .ForwardB_E_Out(ForwardB)
);
// WRITEBACK MUX

assign Writeback_Data =
       (Result_Src_W == 3'b001) ? Loaded_Data_W :
       (Result_Src_W == 3'b010) ? PC_plus4_W :
                                  ALU_Result_W;


// TEMPORARY BRANCH LOGIC

assign Branch_Taken = Branch_Taken_E;
endmodule