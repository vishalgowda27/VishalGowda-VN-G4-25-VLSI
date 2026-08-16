module string_word_reverse;
     string in_str = "I want to bacome a Physical Design Engineer";
     string word   = " " ;
     string out    = " " ;
     int i;

  initial begin
    for(i=0; i<=in_str.len(); i++) begin
        if (i == in_str.len() || in_str[i] == " ") begin
          out = (out=="")?  word: {word, " ", out};
          word = " " ;
       end
       else
           word = {word, in_str[i]};
     end

    $display("output : %s", out);

   end
endmodule
