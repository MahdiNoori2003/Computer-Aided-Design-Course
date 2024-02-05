module Xor(
    input a, b, 
    output out
);

    four_to_one_mux decider(.a(1'b0), .b(1'b1), .c(1'b1), .d(1'b0), .sel({a, b}), .out(out));
endmodule


module Not (
    input a,
    output out
);

    Actel_C1 c1(.A0(1'b1), .A1(1'b1), .SA(1'b1), .B0(1'b0), .B1(1'b0), .SB(1'b0), .S0(a), .S1(1'b0), .F(out));

endmodule

module twoscomp_converter #(parameter WIDTH = 10)(
    input [WIDTH-1:0] a,
    input sign,
    output [WIDTH-1:0] out
);

    wire [WIDTH-1:0] temp;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : xor_loop
            Xor x(.a(a[i]), .b(sign), .out(temp[i]));
        end
    endgenerate

    Adder #(WIDTH) adder(.a(temp), .b({{(WIDTH-1){1'b0}}, sign }), .cin(1'b0), .out(out));

endmodule


// checks the end of the program 
module Done_checker(
    input z1, z2, z3, z4,
    output finish
);

    wire z1_bar, z2_bar, z3_bar, z4_bar;
    wire w1, w2, w3, w4, w5;
    wire[4:0] temp;

    Not n1(z1, z1_bar);
    Not n2(z2, z2_bar);
    Not n3(z3, z3_bar);
    Not n4(z4, z4_bar);

    And_4pins a1(z1, z2_bar, z3_bar, z4_bar, temp[0]);
    And_4pins a2(z1_bar, z2, z3_bar, z4_bar, temp[1]);  
    And_4pins a3(z1_bar, z2_bar, z3, z4_bar, temp[2]);    
    And_4pins a4(z1_bar, z2_bar, z3_bar, z4, temp[3]);
    And_4pins a5(z1_bar, z2_bar, z3_bar, z4_bar, temp[4]);

    Or_bitwise or1 (temp, finish);

endmodule


//finds the index of the max number
module Encoder(
    input z1, z2, z3, z4, 
    output [1:0] out
);
    Or_2pins or1(.a(z2), .b(z4), .out(out[0]));
    Or_2pins or2(.a(z3), .b(z4), .out(out[1]));
endmodule
