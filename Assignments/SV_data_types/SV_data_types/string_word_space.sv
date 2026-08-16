module string_word_space;
    string in_str = "S U R E P r o E d";
    string out    = " ";
    int i;

  initial begin
    for(i = 0; i < in_str.len(); i++)
        if(in_str[i] != " ")
           out = {out, in_str[i]};
      

    $display ("No space : %s", out);
  end
endmodule
