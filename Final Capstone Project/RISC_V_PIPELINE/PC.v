module PC_Unit (
    input clk,
    input rst,
    input Branch_Taken,
    input PC_Write,
    input [31:0] Target_Address,

    output reg [31:0] PC_out,
    output [31:0] PC_plus4_out
);

always @(posedge clk or posedge rst) begin

  if (rst) begin
    PC_out <= 32'b0;
end

else if (!PC_Write) begin
    PC_out <= PC_out;
end

else if (Branch_Taken) begin
    PC_out <= Target_Address;
end

else begin
    PC_out <= PC_out + 4;
end

end


assign PC_plus4_out = PC_out + 4;

endmodule