/*************************
file name : pulse_gen.v

module name : pulse_gen

History : 04NOV2025
/*************************
/*
PARAMETER t_total   t_on
0           0 us 
1           1 us
2           2 us
3           3 us
4           4 us
5           5 us
6           6 us
7           7 us
8           8 us
9           9 us
10          10 us

11          11us          
12          12us
13          13us
14          14us
15          15us
*/
module pulse_gen
#(
parameter T_ON = 7,   //50%
parameter T_TOTAL = 7  //8us
) (
input i_clk,
input i_rst,
output o_pulse,
output o_invalid_inp

);

localparam ON_CNT = (T_ON+)/2;

//Declare the intermediate signals
reg [2:0] pulse_cntrl_cnt; 


//control logic : 3-bit counter
//that counts from 0 to 7 and
// it overflows.

/*
Look up table for pulse period = 8
parameter    t_on       count value at which we toggle
1            12.50%         1
3             25.00%        2
5             37.50%         3
7             50.00%         4
9             62.50%         5
11             75.00%         6
13             87.50%         7
15              100.00%       8
2n-1 are the odd 
(k+1)/2             

*/
always @ (posedge i_clk) begin
if(i_rst)begin end
pulse_cntrl_cnt <= 3'b0;
end
 else begin
 pulse_cntrl_cnt<=pulse_cntrl_cnt+1;
 // if(pulse_cntrl_cnt<ON_CNT) begin
 
 end
 end
 
 always @(*) begin
 //if(i_rst) begin
 //o_pulse = 1'b0;
 //end else begin
 if(pulse_cntrl_cnt<4) begin
 o_pulse = 1'b1;
 end
 else begin 
 o_pulse = 1'b0;
 
 end
 end
 endmodule