`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.12.2025 12:32:18
// Design Name: 
// Module Name: Serial_detector
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module serial_detector (
    input        i_clk,
    input        i_rst,        
    input        s_data,      
    output reg   o_hit         
);

     reg [8:0] shift_reg;
    parameter PATTERN = 9'b101000111;

    always @(posedge i_clk) begin
        if (i_rst) begin
            shift_reg <= 9'd0;
            o_hit       <= 1'b0;
        end else begin 
            shift_reg   <= {s_data, shift_reg[8:1]};
            o_hit       <= (shift_reg == PATTERN);
    end
end
endmodule

