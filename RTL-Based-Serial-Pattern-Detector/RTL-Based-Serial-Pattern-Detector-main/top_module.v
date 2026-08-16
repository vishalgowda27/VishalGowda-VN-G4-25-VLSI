`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.12.2025 12:32:49
// Design Name: 
// Module Name: top_module
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

module top_module (
    input        i_clk,        
    input        i_rst,        
    input        i_en,         
    output       o_serial_out, 
    output       o_hit,

    // 7-segment outputs
    output wire [6:0] seg_h,   // hundreds
    output wire [6:0] seg_t,   // tens
    output wire [6:0] seg_o,    // ones
    output wire [9:0] o_hit_count, //
    output wire o_hit_count_valid //
);

    // --------------------------------
    // Internal wires
    // --------------------------------
    wire [9:0] gen_data;
    wire       tx_done;
    wire       hit_fast;

    wire [3:0] hundreds;
    wire [3:0] tens;
    wire [3:0] ones;
    reg one_sec_pulse;

    // --------------------------------
    // Generator
    // --------------------------------
    data_gen u_data_gen (
        .i_clk     (i_clk),
        .i_rst     (i_rst),
        .i_tx_done (tx_done),
        .o_data    (gen_data)
    );

    // --------------------------------
    // PISO Transmitter
    // --------------------------------
    serial_transmitter u_serial_transmitter (
        .i_clk      (i_clk),
        .i_rst      (i_rst),
        .i_en_n     (i_en),
        .p_data     (gen_data),
        .s_data     (o_serial_out),
        .o_ready    (tx_done)
    );

    // --------------------------------
    // Serial Detector
    // --------------------------------
    serial_detector u_serial_detector (
        .i_clk   (i_clk),
        .i_rst   (i_rst),
        .s_data  (o_serial_out),
        .o_hit   (hit_fast)
    );

    // --------------------------------
    // BONUS: 1-Second Display Logic
    // --------------------------------
    reg [13:0] sec_count;
    reg        hit_1s;

    always @(posedge i_clk) begin
        if (i_rst) begin
            sec_count <= 14'd0;
            hit_1s    <= 1'b0;
        end
        else if (sec_count == 14'd9999) begin
            sec_count <= 14'd0;
            hit_1s    <= 1'b1;
        end
        else begin
            sec_count <= sec_count + 1'b1;
            hit_1s    <= 1'b0;
        end
    end

    assign o_hit = hit_fast;

// ---------------- HIT COUNTER ----------------
    reg [9:0] hit_count;
    reg [9:0] hit_count_latched;

    always @(posedge i_clk) begin
    if (i_rst) begin
        hit_count <= 10'd0;
        hit_count_latched <= 10'd0;
    end
    else if (one_sec_pulse) begin
        // 1-second boundary
        hit_count_latched <= hit_count;
        hit_count <= 10'd0;
    end
    else if (o_hit) begin
        // count hits within the second
        hit_count <= hit_count + 1'b1;
    end
end

    // --------------------------------
    // Binary to BCD Conversion
    // --------------------------------
    bcd u_bcd (
        .bin      (gen_data),
        .hundreds (hundreds),
        .tens     (tens),
        .ones     (ones)
    );

    // --------------------------------
    // 7-Segment Decoders
    // --------------------------------
    seg7 u_seg_h (
        .bcd (hundreds),
        .seg (seg_h)
    );

    seg7 u_seg_t (
        .bcd (tens),
        .seg (seg_t)
    );

    seg7 u_seg_o (
        .bcd (ones),
        .seg (seg_o)
    );

endmodule

