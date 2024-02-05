module datapath #(parameter KERNEL_COUNT)(input clk, rst, load_x, sel_x, load_y, sel_y, load_z, sel_z, mem_write_en, 
  write_buff_counter_en, read_buff_counter_en, shift_buff, write_buff_en,
  write_filter_buff_counter_en, read_filter_buff_counter_en, 
  input [0:KERNEL_COUNT-1] write_filter_buff_en,
  input partial_res_en,shift_reg_en,clear_mac,finalize_shift_reg,done, write_window_buff_en, mem_addr_sel,
  input [($clog2(16*KERNEL_COUNT+256)-1):0] x_inp, y_inp, 
  input [($clog2(172)-1):0] z_inp,
  output cout_filter_write_index, cout_mac_index, cout_buff_write_index, cout_buff_read_index
);

  wire[($clog2(16*KERNEL_COUNT+256)-1):0] x_out, y_out, x_mux_out, y_mux_out, mem_addr;
  wire [($clog2(172)-1):0] z_out ,z_mux_out,z_new;

  pc #(($clog2(16*KERNEL_COUNT+256))) x_pc (.clk(clk), .rst(rst), .sel(sel_x), .en(load_x), .init_pc(x_inp), .pc_out(x_out));
  pc #(($clog2(16*KERNEL_COUNT+256))) y_pc (.clk(clk), .rst(rst), .sel(sel_y), .en(load_y), .init_pc(y_inp), .pc_out(y_out));
  pc #(($clog2(172))) z_pc(.clk(clk), .rst(rst), .sel(sel_z), .en(load_z), .init_pc(z_inp), .pc_out(z_out));

  wire[7:0] window_buff_out;
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

              
  
  wire[7:0] mem_data_out[0:3];
  wire[7:0] buff_out[0:3][0:3];

  two_to_one_mux #($clog2(16*KERNEL_COUNT+256)) MemoryAddressMux(.sel(mem_addr_sel), .data_0(x_out), .data_1(y_out), .data_out(mem_addr));

  read_memory #(16*KERNEL_COUNT+256) RD_Memory(.clk(clk), .addr(mem_addr), .data_out(mem_data_out));

  four_by_sixteen_buffer Buff(.clk(clk), .rst(rst), .sh_en(shift_buff), .wr_en(write_buff_en), .data_in(mem_data_out),
            .rd_index(read_buff_ind), .wr_index(({write_buff_ind,2'b0})), .data_out(buff_out));

  four_by_four_window Window(.data_in(buff_out), .wr_en(write_window_buff_en),.clk(clk),.rst(rst), .rd_index(read_four_to_four_buff_ind),
             .data_out(window_buff_out));

  genvar i;
  generate
    for(i = 0; i < KERNEL_COUNT; i+=1)
      pe #(i+1) PE(.clk(clk), .rst(rst), .filter_wr_en(write_filter_buff_en[i]), .memory_wr_en(mem_write_en),
      .mac_en(partial_res_en), .mac_clr(clear_mac), .shift_reg_en(shift_reg_en), .finalize_shift_reg(finalize_shift_reg),.done(done),
      .write_filter_buff_ind(write_filter_buff_ind),.pixel_ind(read_four_to_four_buff_ind),.pixel(window_buff_out),
      .mem_data_out(mem_data_out),.wr_addr(z_out));
  endgenerate

  assign cout_filter_write_index = write_filter_buff_counter_cout;
  assign cout_mac_index = read_filter_buff_counter_cout;
  assign cout_buff_write_index = write_buff_counter_cout;
  assign cout_buff_read_index = read_buff_counter_cout;
  
endmodule
