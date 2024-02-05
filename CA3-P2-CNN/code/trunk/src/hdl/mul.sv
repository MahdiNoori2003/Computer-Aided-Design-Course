module mul(input [7:0] a,b,
    output [7:0] result
);

    reg [15:0] product;

    
    assign product = a * b;
    assign result = product[15:8];

endmodule