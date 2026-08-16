module data_memory(

    input clk,
    input WrEn,
    input [3:0] WrMask,
    input [31:0] Address,
    input [31:0] Write_Data,
    output [31:0] Read_Data

);

    // 256 x 32-bit Data Memory
    reg [31:0] data_mem [0:255];

    integer i;

    // Initialize memory to zero
    initial begin
        for(i = 0; i < 256; i = i + 1)
            data_mem[i] = 32'b0;
            
            // Test data for lw instruction
    data_mem[0] = 32'h00000000;
    end

    // Write Operation
    always @(posedge clk) begin

        if(WrEn) begin

            // For now, ignore WrMask
            data_mem[Address[9:2]] <= Write_Data;

        end

    end

    // Read Operation
    assign Read_Data = data_mem[Address[9:2]];

endmodule