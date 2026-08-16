module string_find_char;
    string in_str    = "system verilog";
    string sub       = "verilog";
    int idx;

    initial begin
        idx = in_str.find(sub);
        $display("Index = %0d", idx);
    end
endmodule
