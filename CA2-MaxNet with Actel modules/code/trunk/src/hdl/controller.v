module controller(input clk, start, rst, finish, output load_reg, sel, done);

wire [2:0] ps_out,ns_out,ns_in,ps_out_bar;

Register #(3) ps (.data_in(ns_out) , .clk(clk) , .rst(rst) , .en(1'b1) , .out(ps_out));
Register #(3) ns (.data_in(ns_in) , .clk(clk) , .rst(rst) , .en(1'b1) , .out(ns_out));

Not n1(.a(ps_out[0]),.out(ps_out_bar[0]));
Not n2(.a(ps_out[1]),.out(ps_out_bar[1]));
Not n3(.a(ps_out[2]),.out(ps_out_bar[2]));

And_3pins done_gen (.a(ps_out_bar[0]),.b(ps_out_bar[1]),.c(ps_out_bar[2]),.out(done));

wire ld_helper_out,sel_temp;
assign sel = sel_temp;
And_3pins ld_helper (.a(ps_out_bar[2]),.b(ps_out[1]),.c(ps_out_bar[0]), .out(ld_helper_out));
And_3pins sel_gen (.a(ps_out[2]),.b(ps_out_bar[1]),.c(ps_out[0]), .out(sel_temp));
Or_2pins ld_gen (.a(ld_helper_out),.b(sel_temp),.out(load_reg));

wire temp1,temp2,temp3,temp4,temp5,temp6,temp7;
wire finish_bar,start_bar;
Not n4(.a(finish),.out(finish_bar));
Not n5(.a(start),.out(start_bar));

And_2pins and1(.a(ps_out[1]), .b(ps_out_bar[0]), .out(temp1));
And_2pins and2(.a(ps_out[1]), .b(ps_out[0]), .out(temp2));
And_2pins and3(.a(finish_bar), .b(ps_out[2]), .out(temp3));
And_2pins and4(.a(ps_out[2]), .b(ps_out[0]), .out(temp4));

And_3pins and5(.a(start),.b(ps_out_bar[2]),.c(ps_out_bar[1]),.out(temp5));
And_3pins and6(.a(start_bar),.b(ps_out_bar[1]),.c(ps_out[0]),.out(temp6));
And_3pins and7(.a(finish_bar),.b(ps_out[2]),.c(ps_out_bar[0]),.out(temp7));

Or_4pins or1(.a(temp1),.b(temp3),.c(temp4),.d(temp5),.out(ns_in[0]));
Or_3pins or2(.a(temp1),.b(temp4),.c(temp6),.out(ns_in[1]));
Or_2pins or3(.a(temp2),.b(temp7),.out(ns_in[2]));

endmodule