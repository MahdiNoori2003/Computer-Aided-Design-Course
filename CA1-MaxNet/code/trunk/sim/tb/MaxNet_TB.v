module MaxNet_TB;
  reg clk;
  reg rst;
  reg start;

  wire [31:0] max_num;
  wire done;

  MaxNet UUT( clk,rst,start,done, max_num);

  always begin
    #2 clk = ~clk;
  end

  initial begin
    clk = 0;
    rst = 1;
    start = 0;

    #5 rst = 0; start = 1;

    #8 start = 0;
    wait(done == 1'b1)
    #2 $stop;
  end

endmodule