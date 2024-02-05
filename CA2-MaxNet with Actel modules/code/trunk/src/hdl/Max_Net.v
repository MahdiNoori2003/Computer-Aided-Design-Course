module MaxNet (
    input clk, rst, start,
    input [4:0] X1, X2, X3, X4,max,
    output done
);
    

    wire finish, load_reg, sel;

    datapath  datapath_instance(.clk(clk),.rst(rst),.ld_t(load_reg),.sel(sel),.max(max),.finish(finish),.X1(X1),.X2(X2),.X3(X3),.X4(X4));
    controller controller_instance (.finish(finish),.start(start),.clk(clk),.rst(rst),.load_reg(load_reg),.sel(sel),.done(done));

endmodule