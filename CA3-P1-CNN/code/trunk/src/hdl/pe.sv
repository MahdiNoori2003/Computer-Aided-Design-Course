module pe #(parameter NUMBER) ( input clk, rst, filter_wr_en, memory_wr_en, mac_en, mac_clr, shift_reg_en, finalize_shift_reg, done,
  input [1:0] write_filter_buff_ind,
  input [3:0] pixel_ind, 
  input [7:0] pixel,
  input [7:0] mem_data_out[0:3],
  input [($clog2(172)-1):0] wr_addr
);

  wire [7:0] filter_buff_out, mac_out;
  wire[7:0] mem_data_in[0:3];


  four_by_four_buffer FilterBuff(.data_in(mem_data_out), .wr_en(filter_wr_en),.clk(clk),.rst(rst), .rd_index(pixel_ind),
            .wr_index(({write_filter_buff_ind,2'b0})), .data_out(filter_buff_out));

  mac Mac(.clk(clk), .rst(rst), .reg_en(mac_en),.clr(mac_clr), .pixel(pixel), .weight(filter_buff_out), .result(mac_out));

  shift_register ShiftReg(.data_in(mac_out), .clk(clk), .sh_en(shift_reg_en),.final_en(finalize_shift_reg), .data_out(mem_data_in));

  write_memory #(172,NUMBER) OFM (.clk(clk), .write_en(memory_wr_en), .done(done), .addr(wr_addr), .inp(mem_data_in));

endmodule