module seq_detector(
 input  i_clk,
 input  i_rst,
 input  i_bit_stream,
 output o_seq_detected
);
 //more technique: S0,S1,S2,S3
 parameterp [1:0] S0 = 2'b00;
 parameterp [1:0] S1 = 2'b01;
 parameterp [1:0] S2 = 2'b10;
 parameterp [1:0] S3 = 2'b11;
 
 //declare state and next_state vriables
 reg [1:0] state;
 reg [1:0] next_state;
 
 //next state decision block
 always @(*) begin
 case (state)
 
 S0: next_state = (in) ? S1 : S0;
 S1: next_state = (in) ? S1 : S2;
 S2: next_state = (in) ? S3 : S0;
 S3: next_state = (in) ? S1 : S2;
 defalut: next_state = 0;
 
 endcase
 end
 
 //state tansition block
 always @ (posedge i_clk) begin
 if(i_rst)
  state <= S0;
  end else begin
  state <= next_state;
  end
  
  endmodule
 