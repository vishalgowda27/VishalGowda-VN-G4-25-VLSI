module string_cnt_char;
string in_str = "IntegratedVLSI";
int    count  = 0;
int i;

initial begin
for(i = 0; in_str[i] != ""; i++)
count++;

$display("Lenght : %0d", count);

end
endmodule