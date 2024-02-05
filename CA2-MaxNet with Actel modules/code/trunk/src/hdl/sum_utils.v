module Full_adder(
    input a, b, cin, 
    output s, cout
);
    wire temp1,temp2,temp3;
    
    // sum
    Xor x1(.a(a), .b(b), .out(temp1));
    Xor x2(.a(temp1), .b(cin), .out(s));

    // c
    And_2pins a1(.a(temp1), .b(cin), .out(temp2));
    And_2pins a2(.a(a), .b(b), .out(temp3));
    Or_2pins or1(.a(temp3), .b(temp2), .out(cout));

endmodule


module Adder #(parameter WIDTH) (
    input [WIDTH - 1: 0] a, b, 
    input cin, 
    output [WIDTH - 1 :0] out
);
    wire [WIDTH : 0] c;
    assign c[0] = cin;

    genvar i;
    generate
        for (i = 0; i < WIDTH ; i = i + 1) begin: full_adders
            Full_adder fa(a[i], b[i], c[i], out[i], c[i+1]);
        end
    endgenerate

endmodule