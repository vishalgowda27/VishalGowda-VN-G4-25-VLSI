1)logic — Primary RTL Signal Type

🔹Definition

"logic is a 4-state variable data type (0,1,X,Z) used to model real hardware signals".

It replaces reg and can be used in combinational and sequential logic.

🔹Where used most

==>Flip-flops

==>Combinational logic

==>Datapath signals

==>Control signals



✅ Synthesizable Example (≈20 lines)

//This module about Adder + Subtractor + MUX + Register

module logic_example (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [3:0]  a,
    input  logic [3:0]  b,
    input  logic        sel,
    output logic [4:0]  y
);

    logic [4:0] sum;                   //internal combinational results and bit width is 5 to prevent overflow
    logic [4:0] diff;

    // Combinational logic and no memory/no latch
    always_comb begin   
        sum  = {1'b0, a} + {1'b0, b};   // concatenation + addition and Extends 'a' from 4 bits → 5 bits(sum/diff) to prevent overflow
        diff = {1'b0, a} - {1'b0, b};   //concatenation + substarction  and stored in diff
    end

    // Sequential logic which is declares flip-flop behavior(asynchronous ff)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)       //Active-low reset
            y <= 5'd0;
        else
            y <= (sel) ? sum : diff;    // mux logic and Ternary operator
			                            // if sel = 1, load = sum or
										// if sel = 0, load = diff 
    end
endmodule



🧠 Logic Explanation

i){1'b0, a} → concatenation to avoid overflow

ii)sum/diff → pure combinational datapath

iii)sel → 2:1 multiplexer

iv)always_ff → real flip-flop behavior.