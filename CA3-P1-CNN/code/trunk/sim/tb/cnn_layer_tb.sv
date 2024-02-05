module cnn_layer_tb();
    parameter KERNEL_COUNT = 4;
    reg clk=1'b0;
    reg rst,start;  
    reg [$clog2(KERNEL_COUNT*16+256)-1:0] x;
    reg [$clog2(KERNEL_COUNT*16+256)-1:0] y;
    reg [7:0] z;
    wire done;
    cnn_layer #(KERNEL_COUNT) UUT(clk,rst,start,x,y,z,done);

    always begin
        #2 clk = ~clk;
    end

    initial begin
        #1 rst = 1;
        #4 rst = 0;
        x = {{$clog2(KERNEL_COUNT *16 + 256 - 7){1'b0}}, 7'b1000000};
        y = {$clog2(KERNEL_COUNT * 16 + 256){1'b0}};
        z = 8'd0;
        start = 1;
        #4 start = 0;
        wait(done == 1'b1)
        #20 $stop;
    end
endmodule
