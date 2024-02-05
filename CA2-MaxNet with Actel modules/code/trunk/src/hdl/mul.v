// cell for array_mul
module mul_cell(
    input xi, yi, pi, ci,
    output xo, yo, po, co
);
    wire temp;
    And_2pins mul (.a(xi),.b(yi),.out(temp));

    Full_adder fa(.a(pi), .b(temp), .cin(ci), .s(po), .cout(co));
    assign xo = xi;
    assign yo = yi;

endmodule


// array_mul
module Mul #(parameter WIDTH = 5)(
    input [WIDTH-1:0] a, b,
    output [2*WIDTH-1:0] out
);

    wire [2*WIDTH - 1 : 0] z;
    wire[WIDTH-1:0] abs_x, abs_y;

    //get abs values
    twoscomp_converter #(WIDTH) conv1(.a(a), .sign(a[WIDTH-1]), .out(abs_x));
    twoscomp_converter #(WIDTH) conv2(.a(b), .sign(b[WIDTH-1]), .out(abs_y));

    wire xv [WIDTH : 0][WIDTH : 0];
    wire yv [WIDTH : 0][WIDTH : 0];
    wire cv [WIDTH : 0][WIDTH : 0];
    wire pv [WIDTH : 0][WIDTH : 0];

    // array_mul
    genvar i, j;
    generate
        for (i = 0; i < WIDTH; i = i + 1)
        begin: gen_rows
            for (j = 0; j < WIDTH; j = j + 1)
            begin: cols
                mul_cell bitMult_(
                    .xi(xv[i][j]), 
                    .yi(yv[i][j]),
                    .pi(pv[i][j + 1]),
                    .ci(cv[i][j]), 
                    .xo(xv[i][j + 1]),
                    .yo(yv[i + 1][j]),
                    .po(pv[i + 1][j]),
                    .co(cv[i][j + 1])
                );
            end
        end
    endgenerate

    generate
        for (i = 0; i < WIDTH; i = i + 1)
        begin: sides
            assign xv[i][0] = abs_x[i];
            assign cv[i][0] = 1'b0;
            assign pv[0][i + 1] = 1'b0;
            assign pv[i + 1][WIDTH] = cv[i][WIDTH];
            assign yv[0][i] = abs_y[i];
            assign z[i] = pv[i + 1][0];
            assign z[i + WIDTH] = pv[WIDTH][i + 1];
        end
    endgenerate

    wire both_neg;

    //gets the result sign
    Xor x(.a(a[WIDTH-1]), .b(b[WIDTH-1]), .out(both_neg));

    //convert the res to 2's comp
    twoscomp_converter #(2*WIDTH) conv3(.a(z), .sign(both_neg), .out(out));

endmodule
