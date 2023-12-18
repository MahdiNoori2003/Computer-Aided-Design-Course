module convolution(input clk, rst, start, 
    input[8:0] xInp, yInp, zInp, 
    output done
);
    wire en_x, en_y, en_z, en_buff, en_buff_read_index, en_filter, en_filter_write_index, en_window, en_mac_index, en_mac, en_shift_register, en_buff_write_index,mem_write_en;

    wire c1, c2, c3, c4, clr_mac , finalize_shift_reg;

    wire sh_en_register;

    wire temp_done;

    assign done = temp_done;

    wire sel_x, sel_y, sel_z;
    wire [1:0] sel_address_memory;
    controller Controller(.clk(clk), .start(start), .cout_filter_write_index(c3), .cout_mac_index(c4), .cout_buff_write_index(c2), .cout_buff_read_index(c1),.rst(rst), 
    .en_x(en_x), .en_y(en_y), .en_z(en_z), .en_buff(en_buff), .en_buff_read_index(en_buff_read_index), .en_filter(en_filter), .en_filter_write_index(en_filter_write_index), .en_window(en_window), .en_mac_index(en_mac_index), .en_mac(en_mac), .en_buff_write_index(en_buff_write_index), .sh_en_buff(sh_en_register), .sh_en_reg(en_shift_register),
    .sel_x(sel_x), .sel_y(sel_y), .sel_z(sel_z), .wr_en_memory(mem_write_en), .done(temp_done),.clr_mac(clr_mac),.finalize_shift_reg(finalize_shift_reg), .sel_address_memory(sel_address_memory)
    );


    datapath Datapath(.clk(clk), .rst(rst), .load_x(en_x), .sel_x(sel_x), .load_y(en_y), .sel_y(sel_y), .load_z(en_z), .sel_z(sel_z), .mem_write_en(mem_write_en), 
        .write_buff_counter_en(en_buff_write_index), .read_buff_counter_en(en_buff_read_index), .shift_buff(sh_en_register), .write_buff_en(en_buff),
        .write_filter_buff_counter_en(en_filter_write_index), .read_filter_buff_counter_en(en_mac_index), .write_filter_buff_en(en_filter),.partial_res_en(en_mac),
        .shift_reg_en(en_shift_register),.clear_mac(clr_mac),
        .finalize_shift_reg(finalize_shift_reg),
        .done(temp_done),.mem_addr_sel(sel_address_memory), .x_inp(xInp), .y_inp(yInp), .z_inp(zInp), .cout_filter_write_index(c3), .cout_mac_index(c4), .cout_buff_write_index(c2), .cout_buff_read_index(c1),
        .write_window_buff_en(en_window)
    );
endmodule
