module cnn_layer1 #(parameter KERNEL_COUNT)(input clk, rst, start, 
    input [($clog2(16*KERNEL_COUNT+256)-1):0] xInp, yInp, 
    input [($clog2(172)-1):0] zInp, 
    output done,ofm_wr_en,
    output reg [7:0] pes_out [0:KERNEL_COUNT-1][0:3], 
    output [($clog2(172)-1):0] wr_ofm_addr,
    output sel_wr_mem_layer1
);
    wire en_x, en_y, en_z, en_buff, en_buff_read_index, en_filter_write_index, en_window, en_mac_index, en_mac, en_shift_register, en_buff_write_index,mem_write_en;
    wire[0:KERNEL_COUNT-1] en_filter;
    wire c1, c2, c3, c4, clr_mac , finalize_shift_reg;

    wire sh_en_register;

    wire temp_done;

    assign done = temp_done;

    wire sel_x, sel_y, sel_z, sel_address_memory;
    controller_cnn_layer1 #(KERNEL_COUNT) Controller(.clk(clk), .start(start), .cout_filter_write_index(c3), .cout_mac_index(c4), .cout_buff_write_index(c2), .cout_buff_read_index(c1),.rst(rst), 
    .en_x(en_x), .en_y(en_y), .en_z(en_z), .en_buff(en_buff), .en_buff_read_index(en_buff_read_index), .en_filter(en_filter), .en_filter_write_index(en_filter_write_index), .en_window(en_window), .en_mac_index(en_mac_index), .en_mac(en_mac), .en_buff_write_index(en_buff_write_index), .sh_en_buff(sh_en_register), .sh_en_reg(en_shift_register),
    .sel_x(sel_x), .sel_y(sel_y), .sel_z(sel_z), .wr_en_memory(ofm_wr_en), .done(temp_done),.clr_mac(clr_mac),.finalize_shift_reg(finalize_shift_reg), .sel_address_memory(sel_address_memory),.sel_address_wr_layer1(sel_wr_mem_layer1)
    );


    datapath_cnn_layer1 #(KERNEL_COUNT) Datapath(.clk(clk), .rst(rst), .load_x(en_x), .sel_x(sel_x), .load_y(en_y), .sel_y(sel_y), .load_z(en_z), .sel_z(sel_z),  
        .write_buff_counter_en(en_buff_write_index), .read_buff_counter_en(en_buff_read_index), .shift_buff(sh_en_register), .write_buff_en(en_buff),
        .write_filter_buff_counter_en(en_filter_write_index), .read_filter_buff_counter_en(en_mac_index), .write_filter_buff_en(en_filter),.partial_res_en(en_mac),
        .shift_reg_en(en_shift_register),.clear_mac(clr_mac),
        .finalize_shift_reg(finalize_shift_reg),.mem_addr_sel(sel_address_memory), .x_inp(xInp), .y_inp(yInp), .z_inp(zInp), .cout_filter_write_index(c3), .cout_mac_index(c4), .cout_buff_write_index(c2), .cout_buff_read_index(c1),
        .pes_out(pes_out) , .wr_ofm_addr(wr_ofm_addr),
        .write_window_buff_en(en_window)
    );
endmodule



module cnn_layer2 #(parameter KERNEL_COUNT)(input clk, rst, start, cout_addr_generator, window_ld_done,
    input [7:0] filter_buff_inp [0:KERNEL_COUNT-1][0:3],
    input [7:0] window_inp [0:KERNEL_COUNT-1][0:3],
    output en_pc_filter,addr_gen_line_counter_en, sel_mem_layer2,addr_gen_window_pos_counter_en, done
);

    wire cout_mac_index, cout_window_write_index, cout_filter_write_index;
    wire [0:KERNEL_COUNT-1] en_filter;

    wire write_filter_buff_counter_en,window_wr_en,read_filter_buff_counter_en,en_mac,sh_en_reg,clr_mac;
    wire temp_done, mem_wr_en, load_w;

    controller_cnn_layer2 #(KERNEL_COUNT) Controller (.clk(clk), .rst(rst), .start(start), .cout_filter_write_index(cout_filter_write_index),
    .cout_addr_generator(cout_addr_generator), .cout_mac_index(cout_mac_index), .window_ld_done(window_ld_done),
    .en_filter(en_filter),.en_pc_filter(en_pc_filter), .write_filter_buff_counter_en(write_filter_buff_counter_en), .window_wr_en(window_wr_en), 
    .addr_gen_line_counter_en(addr_gen_line_counter_en), .sel_mem(sel_mem_layer2), .en_mac_index(read_filter_buff_counter_en), .en_mac(en_mac), 
    .sh_en_reg(sh_en_reg), .addr_gen_window_pos_counter_en(addr_gen_window_pos_counter_en), 
    .clr_mac(clr_mac),.done(temp_done), .mem_wr_en(mem_wr_en), .load_w(load_w));

    assign done = temp_done;


    datapath_cnn_layer2 #(KERNEL_COUNT) Datapath (.clk(clk), .rst(rst), .load_w(load_w), .write_filter_buff_counter_en(write_filter_buff_counter_en),
    .write_window_counter_en(addr_gen_line_counter_en), .read_filter_buff_counter_en(read_filter_buff_counter_en),
    .window_wr_en(window_wr_en), .mac_en(en_mac), .mac_clr(clr_mac), .shift_reg_en(sh_en_reg), .mem_wr_en(mem_wr_en), .done(temp_done),
    .filter_buff_inp(filter_buff_inp),.window_inp(window_inp),
    .filter_wr_en(en_filter),.cout_mac_index(cout_mac_index), .cout_window_write_index(cout_window_write_index), 
    .cout_filter_write_index(cout_filter_write_index));

endmodule

