3)int — Signed Arithmetic Register
🔹 Definition

"int is a 32-bit signed 2-state variable".

🔹 Where used most

==>Address counters

==>Loop indexes (synth tools optimize)

==>Arithmetic-heavy blocks



✅ Synthesizable Example

/*
this module about 

acc → 32-bit register

operand → constant

Arithmetic → ALU logic
*/

module int_example (
    input  logic clk,
    input  logic rst_n,
    input  logic add_en,      // adder enable
    output int   acc         //Accumulator which is Stores running result of arithmetic
);

    int operand;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc     <= 0;     //set to zero
            operand <= 10;    //operand is constant increment value
        end
        else if (add_en) begin
            acc <= acc + operand;     // signed addition like Adds operand to current acc
        end
        else begin
            acc <= acc - 1;           // decrement
        end
    end

endmodule


🧠 Logic Explanation

i)Signed arithmetic supported

ii)Synthesizer maps to 32-bit adder/subtractor

iii)Efficient for control-heavy logic