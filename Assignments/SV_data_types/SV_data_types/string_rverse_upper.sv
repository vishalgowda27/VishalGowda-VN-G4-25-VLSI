module string_reverse_upper;

    string input_str;
    string reversed_str;
    string final_str;

    int i;

    initial begin
        // Input sentence
        input_str = "Byanajjara Ganesha";

        // Initialize reversed string as empty
        reversed_str = "";

        // -----------------------------
        // Reverse the string
        // -----------------------------
        for (i = input_str.len()-1; i >= 0; i--) begin     //len() says number of characters
            reversed_str = {reversed_str, input_str[i]};
        end

        // -----------------------------
        // Convert to upper case
        // -----------------------------
        final_str = reversed_str.toupper();               //toupper() converts ASCII a–z → A–Z
	  //final_str = reversed_str.tolower();               //tolower() converts ASCII A–Z --> a-b
   

        // Display results
        $display("Original String : %s", input_str);
        $display("Reversed String : %s", reversed_str);
        $display("Final Output    : %s", final_str);
    end

endmodule
