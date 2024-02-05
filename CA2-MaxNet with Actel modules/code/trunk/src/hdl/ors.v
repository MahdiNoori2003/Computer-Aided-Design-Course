module Or_2pins(input a, b, 
    output out
);

    Actel_C2 c2(.out(out),.D00(1'b0),.D01(1'bz), .D10(1'b1), .D11(1'bz), .A1(a),.B1(b), .A0(1'b0),.B0(1'b0));
endmodule

module Or_3pins (
    input a, b, c,
    output out
);

    Actel_C1 c1(.A0(a), .A1(1'b1), .SA(b), .B0(1'b1), .B1(1'b1), .SB(1'b1), .S0(c), .S1(1'b0), .F(out));
endmodule


module Or_4pins (
    input a, b, c, d,
    output out
);

    Actel_C1 c1(.A0(a), .A1(1'b1), .SA(b), .B0(1'b1), .B1(1'b1), .SB(1'b1), .S0(c), .S1(d), .F(out));
endmodule


module Or_bitwise #(parameter WIDTH = 5) (input [WIDTH-1:0] a, output out);
    wire [WIDTH-1:0] res;
    assign res[0] = a[0];
    genvar i;
    generate
        for (i = 1; i < WIDTH; i = i + 1) begin : or_stage
            Or_2pins or2(
                .a(res[i-1]),
                .b(a[i]),
                .out(res[i])
            );
        end
    endgenerate
    assign out = res[WIDTH-1];
endmodule
