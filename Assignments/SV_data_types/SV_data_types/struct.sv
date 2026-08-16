struct — Grouped Signals (Datapath Cleanliness)

🔹 Definition

"struct groups multiple signals into one logical unit".

🔹 Where used most

==>Buses

==>Pipeline registers

==>Interface-style designs


✅ Synthesizable Example

//this module is about adder feeding register

module struct_example (
    input  logic clk,
    input  logic rst_n,
    input  logic valid_in,
    input  logic [7:0] data_in,
    output logic valid_out,
    output logic [7:0] data_out
);

    typedef struct packed {             //'typedef' is create a new data type and 'struct' is group related signals 
	                                    //'packed' treated as single register
        logic       valid;              //control bit
        logic [7:0] data;               //payload
    } packet_t;                         //user-defined type name

    packet_t pkt_reg;                   //reg for packets to store the values

    //Packet stored synchronously
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin            //active low
            pkt_reg.valid <= 1'b0;  // Struct fields accessed with . operator
            pkt_reg.data  <= 8'd0;
        end
        else begin
            pkt_reg.valid <= valid_in;        //Transfers input into packet
            pkt_reg.data  <= data_in + 8'd1; // add 1 arithmetic inside struct
        end
    end

    assign valid_out = pkt_reg.valid;        //Break struct back into signals
    assign data_out  = pkt_reg.data;         //Clean separation of datapath

endmodule



🧠 Logic Explanation

i)packed struct → synthesizable

ii)Treated as one register

iii)Clean pipeline modeling