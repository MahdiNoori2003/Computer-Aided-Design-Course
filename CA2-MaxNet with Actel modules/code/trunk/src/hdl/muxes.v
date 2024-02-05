module two_to_one_mux (
    input a, b, sel, 
    output out
);

    Actel_C2 c2(.out(out),.D00(a),.D01(b), .D10(1'bz),.D11(1'bz), .A1(1'b0), .B1(1'b0), .A0(sel), .B0(1'b1));
endmodule


module two_to_one_mux_parametrized #(parameter WIDTH) (
    input [WIDTH-1:0] a,b,
    input sel,
    output [WIDTH-1:0] out
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin: mux_loop
            two_to_one_mux m (.a(a[i]), .b(b[i]), .sel(sel), .out(out[i]));
        end
    endgenerate

endmodule


module four_to_one_mux (
    input a, b, c, d, 
    input [1:0] sel, 
    output out
);

    Actel_C2 c2(.out(out),.D00(a),.D01(b), .D10(c),.D11(d), .A1(sel[1]), .B1(1'b0), .A0(sel[0]), .B0(1'b1));
endmodule


module four_to_one_mux_parametrized #(parameter WIDTH = 5) (
    input [WIDTH-1:0] a, b, c, d,
    input [1:0] sel,
    output [WIDTH-1:0] out
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin: mux_loop
            four_to_one_mux m (.a(a[i]), .b(b[i]), .c(c[i]), .d(d[i]), .sel(sel), .out(out[i]));
        end
    endgenerate
endmodule



