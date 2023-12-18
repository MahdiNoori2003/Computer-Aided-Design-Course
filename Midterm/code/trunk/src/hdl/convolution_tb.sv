module convolution_tb();

    reg clk=1'b0;
    reg rst,start;  
    reg [8:0] x;
    reg [8:0] y;
    reg [8:0] z;
    wire done;
    convolution UUT(clk,rst,start,x,y,z,done);

    always begin
        #2 clk = ~clk;
    end

    initial begin
        #1 rst = 1;
        #4 rst = 0;
        x = 9'd10;
        y = 9'd286;
        z = 9'd302;
        start = 1;
        #4 start = 0;
        wait(done == 1'b1)
        #20 $stop;
    end
endmodule
