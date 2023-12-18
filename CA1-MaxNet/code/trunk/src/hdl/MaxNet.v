module MaxNet(input clk,rst,start,
            output done,
            output [31:0] max_num);
            
    wire ld_reg,ld_memory,sel,finish;

    //wiring controller and datapath
    Controller controller(finish, start, clk, rst, ld_memory, ld_reg, sel,done);
    Datapath datapath(clk,rst,sel,ld_memory,ld_reg,finish,max_num);
endmodule