/****************************************
	SURE ProEd Integrated VLSI Internship
	Batch name : G4
	
	File Name  :  FA.v
	
	Module Name:  FA
	
	Description: 1-bit full adder
	
	Engineer   : Dev Chadha
	
	History    : 24NOV2025 (created)
	
****************************************/
	
module FA
	(
		input  i_a,
		input  i_b,
		input  i_cin,
		output o_sum,
		output o_cout
	);
	
	// assign o_sum  = i_a ^ i_b ^ i_cin;
       //  o_sum_nor (cin, i_a, i_b, o_sum);
       // assign o_cout = (i_a & i_b) | (i_b & i_cin) | (i_a & i_cin);
       // o_cout_nand (i_a, i_b, i_cin, o_cout);
	
wire sum0;
wire carry;
wire carry1;

//module instantiation by order
HA ha0(i_a, sum0, i_b, carry0);

//module instantiation by name
HA ha1()
endmodule



/********
file name : 4-bit FA 
History   : 25NOV2025
*******/

module full_adder
#(
parameter N = 8 // you can use it for other bits
)(
input [N-1:0] i_a,
input [N-1:0] i_b,
input       i_cin,
output[N-1:0] o_sum,
output      o_carry
);

//wire c1,c2,c3;

// we should use loops for many instantiation
wire [N-1:0]carry;
assign carry[0] = i_cin;
assign o_cout = carry[N-1];

genvar i;
generate
for (i=0; i<N+1; i+1) begin  // i=0,1,2,3 
//for generalising we just chnage the Bus like how many bits(8,16..) and 
// for(i=0; i<N+1; i=i+1)
FA
fa_inst(
.i_a (i_a[i]),
.i_b  (i_b[i]),
.i_cin (carry[i]),
.o_sum (o_sum[i]),
.c_cout(carry[i+1])
);
end
endgenerate
endmodule


//instead of using number of instantiation we can use loops as likein the above one

FA
fa_inst0(
.i_a (i_a[0]),
.i_b  (i_b[0]),
.i_cin (i_cin),
.o_sum (o_sum[0]),
.c_cout(c1)
);
end

FA
fa_inst1(
.i_a (i_a[1]),
.i_b  (i_b[1]),
.i_cin (c1),
.o_sum (o_sum[1]),
.c_cout(c2)
);

FA
fa_inst2(
.i_a (i_a[2]),
.i_b  (i_b[2]),
.i_cin (c2),
.o_sum (o_sum[2]),
.c_cout(c3)
);

FA
fa_inst3(
.i_a (i_a[3]),
.i_b  (i_b[3]),
.i_cin (c3),
.o_sum (o_sum[3]),
.c_cout(cout)
);

endmodule


 