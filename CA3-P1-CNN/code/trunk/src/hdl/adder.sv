module adder #(parameter WIDTH = 8)(input [WIDTH-1:0] a,b,
    output [WIDTH-1:0] sum
);
    wire carry;
    assign {carry,sum} = a+b;
    
endmodule
