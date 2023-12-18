module datapath(input clk, rst, load_x, sel_x, load_y, sel_y, load_z, sel_z, mem_write_en, 
    write_buff_counter_en, read_buff_counter_en, shift_buff, write_buff_en,
    write_filter_buff_counter_en, read_filter_buff_counter_en, write_filter_buff_en,
    partial_res_en,shift_reg_en,clear_mac,finalize_shift_reg,done, write_window_buff_en,
    input[1:0] mem_addr_sel,
    input[8:0] x_inp, y_inp, z_inp,
    output cout_filter_write_index, cout_mac_index, cout_buff_write_index, cout_buff_read_index
  );

  wire[8:0] x_out, y_out, z_out, x_mux_out, y_mux_out, z_mux_out, x_new, y_new, z_new, mem_addr;

  
  pc x_pc(.clk(clk), .rst(rst), .sel(sel_x), .en(load_x), .init_pc(x_inp), .pc_out(x_out));
  pc y_pc(.clk(clk), .rst(rst), .sel(sel_y), .en(load_y), .init_pc(y_inp), .pc_out(y_out));
  pc z_pc(.clk(clk), .rst(rst), .sel(sel_z), .en(load_z), .init_pc(z_inp), .pc_out(z_out));

  wire[7:0] filter_buff_out, window_buff_out, mac_out;
  wire[3:0] read_buff_ind, read_four_to_four_buff_ind;
  wire[1:0] write_buff_ind, write_filter_buff_ind;
  wire write_buff_counter_cout, read_buff_counter_cout, write_filter_buff_counter_cout,
            read_filter_buff_counter_cout;

  two_bit_counter BuffWrCount(.clk(clk), .rst(rst), .en(write_buff_counter_en),
            .cout(write_buff_counter_cout), .count(write_buff_ind));
  
  counter_up_to_12 BuffRdCount(.clk(clk), .rst(rst), .en(read_buff_counter_en),
            .cout(read_buff_counter_cout), .count(read_buff_ind));

  two_bit_counter FilterBuffWrCount(.clk(clk), .rst(rst), .en(write_filter_buff_counter_en),
            .cout(write_filter_buff_counter_cout), .count(write_filter_buff_ind));

  four_bit_counter FilterBuffRdCount(.clk(clk), .rst(rst), .en(read_filter_buff_counter_en),
            .cout(read_filter_buff_counter_cout), .count(read_four_to_four_buff_ind));

              
  
  wire[7:0] mem_data_in[0:3];
  wire[7:0] mem_data_out[0:3];
  wire[7:0] buff_out[0:3][0:3];

  three_to_one_mux MemoryAddressMux(.sel(mem_addr_sel), .data_0(x_out), .data_1(y_out), .data_2(z_out), .data_out(mem_addr));

  memory Memoty(.clk(clk), .wr_en(mem_write_en), .done(done), .addr(mem_addr), .initial_wr_addr(z_inp), .data_in(mem_data_in), .data_out(mem_data_out));

  four_by_sixteen_buffer Buff(.clk(clk), .rst(rst), .sh_en(shift_buff), .wr_en(write_buff_en), .data_in(mem_data_out),
            .rd_index(read_buff_ind), .wr_index(({write_buff_ind,2'b0})), .data_out(buff_out));

  four_by_four_buffer FilterBuff(.data_in(mem_data_out), .wr_en(write_filter_buff_en),.clk(clk),.rst(rst), .rd_index(read_four_to_four_buff_ind),
            .wr_index(({write_filter_buff_ind,2'b0})), .data_out(filter_buff_out));

  four_by_four_window Window(.data_in(buff_out), .wr_en(write_window_buff_en),.clk(clk),.rst(rst), .rd_index(read_four_to_four_buff_ind),
             .data_out(window_buff_out));
            
  mac Mac(.clk(clk), .rst(rst), .reg_en(partial_res_en),.clr(clear_mac), .pixel(window_buff_out), .weight(filter_buff_out), .result(mac_out));

  shift_register ShiftReg(.data_in(mac_out), .clk(clk), .sh_en(shift_reg_en),.final_en(finalize_shift_reg), .data_out(mem_data_in));

  assign cout_filter_write_index = write_filter_buff_counter_cout;
  assign cout_mac_index = read_filter_buff_counter_cout;
  assign cout_buff_write_index = write_buff_counter_cout;
  assign cout_buff_read_index = read_buff_counter_cout;
  
endmodule
