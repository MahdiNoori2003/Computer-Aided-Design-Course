module And_2pins(input a, b,
    output out
);

    Actel_C2 c2(.out(out),.D00(1'b0), .D01(1'b1), .D10(1'bz), .D11(1'bz), .A1(1'b0),.B1(1'b0),.A0(a),.B0(b) );

endmodule


module And_3pins (input a, b, c,
    output out
);
    Actel_C1 c1(.A0(1'b0), .A1(1'b0), .SA(1'b0), .B0(1'b0), .B1(c), .SB(b), .S0(a), .S1(1'b0), .F(out));

endmodule


module And_4pins (input a, b, c, d, 
    output out
);

    Actel_C2 c2 (.D00(1'b0), .D01(1'b0), .D10(1'b0), .D11(d), .A1(c), .B1(1'b0), .A0(a), .B0(b), .out(out));

endmodule