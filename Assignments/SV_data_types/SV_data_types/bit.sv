2)bit — 2-State Hardware Control

🔹 Definition

"bit is a 2-state data type (0,1)".

Used when X/Z is not required and deterministic hardware is preferred.

🔹 Where used most

==>Counters

==>Enable flags

==>Clock-gating logic

==>Simple FSM controls



✅ Synthesizable Example

//this module is about D input = NOT(Q) i.e, D=~Q

module bit_example (
    input  logic clk,
    input  logic rst_n,
    input  bit   en,
    output bit   toggle
);

    bit state;             // bit has state and that state had 0/1(only)

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state  <= 1'b0;
            toggle <= 1'b0;
        end
        else if (en) begin
            state  <= ~state;           // bitwise NOT for toggling   
			                            //If state = 0 → becomes 1
										//If state = 1 → becomes 0
            toggle <= state ^ toggle;   // XOR operation
        end
    end

endmodule



🧠 Logic Explanation

i)~state → toggling

ii)^ → XOR (used in parity & toggles)

iii)No X-propagation → fast & deterministic