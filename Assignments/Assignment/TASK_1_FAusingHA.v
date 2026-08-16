/*
file name : FAusingHA

module name : FAusingHA

History : 24NOV2025

*/

//Half adder
module HA (
    input i_a,
    input i_b,
    output o_sum,
    output o_carry
)

assign o_sum = i_a ^ i_b;
assign o_carry = i_a & i_b;

endmodule


//full adder 
module full_adder (
    input  i_a,
    input  i_b,
    input  cin,
    output o_sum,
    output o_cout
);

    wire s1, c1, c2;

    // First half adder
    half_adder HA1 (
        .a(a),
        .b(b),
        .sum(s1),
        .carry(c1)
    );

    // Second half adder
    half_adder HA2 (
        .a(s1),
        .b(cin),
        .sum(sum),
        .carry(c2)
    );

    // Final carry
    assign cout = c1 | c2;

endmodule

