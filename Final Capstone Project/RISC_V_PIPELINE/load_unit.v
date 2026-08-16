module load_unit(
    input [31:0] Read_Data_In,
    input [1:0] Load_Size_In,
    input Load_Unsigned_In,

    output reg [31:0] Loaded_Data_Out
);

always @(*) begin

    case(Load_Size_In)

        // BYTE
        2'b00:
        begin
            if(Load_Unsigned_In)
                Loaded_Data_Out = {24'b0, Read_Data_In[7:0]};
            else
                Loaded_Data_Out = {{24{Read_Data_In[7]}}, Read_Data_In[7:0]};
        end

        // HALFWORD
        2'b01:
        begin
            if(Load_Unsigned_In)
                Loaded_Data_Out = {16'b0, Read_Data_In[15:0]};
            else
                Loaded_Data_Out = {{16{Read_Data_In[15]}}, Read_Data_In[15:0]};
        end

        // WORD
        2'b10:
            Loaded_Data_Out = Read_Data_In;

        default:
            Loaded_Data_Out = 32'b0;

    endcase

end

endmodule