`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.12.2025 12:31:22
// Design Name: 
// Module Name: gen_counter
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


module data_gen (
    input        i_clk,
    input        i_rst,
    input        i_tx_done,
    output reg [9:0] o_data
);
    always @(posedge i_clk) begin
        if (i_rst)
            o_data <= 10'd0;
        else if (i_tx_done)
            o_data <= o_data + 1'b1;
    end
endmodule
