4)enum — Readable FSM State Encoding

🔹 Definition

"enum defines named constant values, making FSMs readable and safe".

🔹 Where used most

==>FSMs

==>Protocol controllers

==>Sequencers



✅ Synthesizable Example

// this module is about FSM

/*FSM has:
Asynchronous reset
Synchronous state transitions
*/

module enum_example (
    input  logic clk,
    input  logic rst_n,
    input  logic start,
    output logic done
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,             //Idle state , FSM doing nothing here and waiting for an event like it wait for start signal
        RUN   = 2'b01,             //RUN when start  1 (01)
        WAIT  = 2'b10,             //WAIT when start 2 (10)
        DONE  = 2'b11              //DONE when start 3 (11)
    } state_t;

    state_t state, next_state;

    // State register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;   // default enum reset
        else
            state <= next_state;
    end

    // Next-state logic
    always_comb begin
        next_state = state; // default assignment
        done = 1'b0;

        case (state)
            IDLE : if (start) next_state = RUN;
            RUN  : next_state = WAIT;
            WAIT : next_state = DONE;
            DONE : done = 1'b1;
        endcase
    end

endmodule



🧠 Logic Explanation

i)Named states → no magic numbers

ii)Default assignment prevents latches

iii)Clean FSM → industry standard

limitations: we can't use or repeate state value like its 5th state , we can't use it again as 5th state again to other state but we can use other values with next states