module string_concatenation;
string a = "VLSI";
string b = "Design";
string c;

initial begin
    c = {a, " ", b};
    $display("%s", c);
end
endmodule