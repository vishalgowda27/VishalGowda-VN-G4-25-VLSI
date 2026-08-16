module extend_unit(
    input  [31:0] instr_in,
    output reg [31:0] imm_out
);

always @(*) begin

    case(instr_in[6:0])

        // I-Type (Load, ALU Immediate, JALR)
        7'b0000011,
        7'b0010011,
        7'b1100111:
            imm_out = {{20{instr_in[31]}}, instr_in[31:20]};

        // S-Type
        7'b0100011:
            imm_out = {{20{instr_in[31]}}, instr_in[31:25], instr_in[11:7]};

        // B-Type
        7'b1100011:
            imm_out = {{19{instr_in[31]}},
                        instr_in[31],
                        instr_in[7],
                        instr_in[30:25],
                        instr_in[11:8],
                        1'b0};

        // U-Type
        7'b0110111,
        7'b0010111:
            imm_out = {instr_in[31:12],12'b0};

        // J-Type
        7'b1101111:
            imm_out = {{11{instr_in[31]}},
                        instr_in[31],
                        instr_in[19:12],
                        instr_in[20],
                        instr_in[30:21],
                        1'b0};

        default:
            imm_out = 32'b0;

    endcase

end

endmodule