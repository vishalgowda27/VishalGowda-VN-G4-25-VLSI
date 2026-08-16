union — Multiple Views of Same Hardware

🔹 Definition

"union allows different interpretations of the same bits".

🔹 Where used most

==>Register maps

==>Byte/word access

==>Protocol headers



✅ Synthesizable Example


module union_example (              
    input  logic clk,
    input  logic rst_n,
    input  logic load,
    output logic [31:0] word_out
);

    typedef union packed {
    logic [31:0] word;              // full 32-bit view
    logic [1:0][15:0] half;         // two 16-bit halves = 32 bits
} data_u;


    data_u reg_u;                   //hardware register and One physical register

    //synchronous
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)                  //active low
            reg_u.word <= 32'd0;    //Clear entire register
        else if (load)
            reg_u.half <= 16'h00FF;   // Writes only lower 16 bits/lower half write
    end

    assign word_out = reg_u.word;     //Read full register

endmodule


🧠 Logic Explanation

i)Same storage, different access width

ii)Synth maps to single register

iii)Common in register files