module Max_NetTB;

    reg [4:0] X1, X2, X3, X4;
    reg clk, rst, start;
    wire done;

    wire [4:0] out;

    MaxNet UUT (.X1(X1),.X2(X2),.X3(X3),.X4(X4),.clk(clk),.rst(rst),.start(start),.max(out),.done(done));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        X1 = 5'b01000;
        X2 = 5'b00110;
        X3 = 5'b00100;
        X4 = 5'b00010;
        #15 rst = 0;
        
        start = 1'b1;
        #15 start = 1'b0;


        wait(done == 1'b1)
        #20 $stop;
    end
endmodule
