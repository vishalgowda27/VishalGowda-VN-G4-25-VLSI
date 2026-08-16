`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.12.2025 12:31:49
// Design Name: 
// Module Name: PISO
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


module serial_transmitter (
    input        i_clk,
    input        i_rst,
    input        i_en_n,
    input  [9:0] p_data,
    output reg   s_data,
    output reg   o_ready
);

    reg [9:0] shift_reg;
    reg [3:0] bit_count;

    always @(posedge i_clk) begin
        if (i_rst) begin
            shift_reg   <= 10'd0;
            bit_count   <= 4'd0;
            s_data      <= 1'b0;
            o_ready     <= 1'b0;
        end
        else if (i_en_n) begin

            if (bit_count == 4'd0)
                shift_reg <= p_data;
            else
                shift_reg <= shift_reg >> 1;

            s_data   <= shift_reg[0];
            o_ready  <= 1'b0;

            if (bit_count == 4'd9) begin
                bit_count <= 4'd0;
                o_ready     <= 1'b1;   
            end
            else
                bit_count <= bit_count + 1'b1;
        end
        else begin
            o_ready <= 1'b0;
        end
    end

endmodule
