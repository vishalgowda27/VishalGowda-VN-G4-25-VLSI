module reg_file(
    input clk,
    input rst,
    input WrEn_in,
    input [4:0] des_addr_in,
    input [31:0] des_data_in,
    input [4:0] src_addr1_in,
    input [4:0] src_addr2_in,

    output [31:0] src_data1_out,
    output [31:0] src_data2_out
);

reg [31:0] my_regs[0:31];

integer i;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        for(i = 0; i < 32; i = i + 1)
            my_regs[i] <= 32'b0;
    end
    else if (WrEn_in) begin
        if (des_addr_in != 5'b00000)
            my_regs[des_addr_in] <= des_data_in;
    end
end
always @(posedge clk) begin
    if (WrEn_in)
begin
    $display("RF WRITE @ %0t : rd=%0d data=%h",
             $time,
             des_addr_in,
             des_data_in);

    my_regs[des_addr_in] <= des_data_in;
end
    
end
assign src_data1_out = my_regs[src_addr1_in];
assign src_data2_out = my_regs[src_addr2_in];

endmodule