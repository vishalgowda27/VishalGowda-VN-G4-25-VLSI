module string_palindrome;

    string in_str = "radar";
    bit is_palindrome = 1;
    int i;

    initial begin
        for (i = 0; i < in_str.len()/2; i++) begin
            if (s[i] != in_str[in_str.len()-1-i]) begin
                is_palindrome = 0;
                break;
            end
        end

        if (is_palindrome)
            $display("'%s' is a palindrome", in_str);
        else
            $display("'%s' is NOT a palindrome", in_str);
    end
endmodule



/*
What is a palindrome?

A string that reads the same forward and backward. or 

“Palindrome checking compares mirror characters from both ends until the center of the string.”

ex: "madam" ✅

    "level" ✅

    "radar" ✅
    
    "vlsi" ❌
	
Compare:

1st character ↔ last character

2nd character ↔ second last and continue untill middle
*/