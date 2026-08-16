module string_comaparison;

string a = "SVUVM";
string b = "svuvm";

initial begin
    if (a == b)
        $display("Same");
    else
        $display("Different");

    if (a.tolower() == b)
        $display("Same ignoring case");
end
endmodule