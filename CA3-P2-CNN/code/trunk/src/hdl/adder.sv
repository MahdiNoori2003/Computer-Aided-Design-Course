module adder #(parameter WIDTH = 8)(input [WIDTH-1:0] a,b,
    output [WIDTH-1:0] sum
);
    wire carry;
    assign {carry,sum} = a+b;
    
endmodule

module adder_parametrized #(parameter N) (input [11:0] mac_outs [0:N-1],
    output [7:0] add_out
);
    reg [13:0] sum;
    always @(*) begin
        sum = 0;
        for(integer i=0; i<N; i=i+1) begin
            sum = sum + mac_outs[i];
        end

    end

    assign add_out = sum[11:4];
endmodule
