module cnn #(parameter KERNEL_COUNT)(input clk, rst, start, 
  input [($clog2(16*KERNEL_COUNT+256)-1):0] xInp, yInp, 
  input [($clog2(172)-1):0] zInp, 
  output done
);

  wire temp_done, wr_ofm_en, en_pc_filter,addr_gen_line_counter_en, addr_gen_window_pos_counter_en;
  wire cout_addr_generator,window_ld_done;
  wire [7:0] pes_out [0:KERNEL_COUNT-1][0:3];
  wire [7:0] ofms_out [0:KERNEL_COUNT-1][0:3];
  wire [7:0] filter_mems_out [0:KERNEL_COUNT-1][0:3];
  
  wire [($clog2(172)-1):0] wr_ofm_addr, rd_ofm_addr, ofm_addr;
  wire ofm_addr_sel_layer1,ofm_addr_sel_layer2;

  cnn_layer1  #(KERNEL_COUNT) Layer1 (.clk(clk), .rst(rst), .start(start), .xInp(xInp) , .yInp(yInp), 
  .zInp(zInp), .done(temp_done) , .ofm_wr_en(wr_ofm_en), .pes_out(pes_out), .wr_ofm_addr(wr_ofm_addr),.sel_wr_mem_layer1(ofm_addr_sel_layer1));

  wire [$clog2(16*KERNEL_COUNT)-1:0] pc_filter_out;

  pc #($clog2(16*KERNEL_COUNT)) PCFilter (.clk(clk),.rst(rst),.sel(1'b0),.en(en_pc_filter), .init_pc({($clog2(16*KERNEL_COUNT)){1'b0}}), .pc_out(pc_filter_out));

  address_generator AddressGen(.clk(clk), .rst(rst), .en_window_start_pos_counter(addr_gen_window_pos_counter_en), .en_line_counter(addr_gen_line_counter_en),
  .address(rd_ofm_addr), .cout_addr_generator(cout_addr_generator), .window_ld_done(window_ld_done));

  two_to_one_mux_with_two_bit_sel #($clog2(172)) Mux_OFM_Addr (.sel({ofm_addr_sel_layer1,ofm_addr_sel_layer2}),
    .data_0(rd_ofm_addr), .data_1(wr_ofm_addr), .data_out(ofm_addr));

  genvar i;
  generate
  for(i = 0; i < KERNEL_COUNT; i+=1)
    read_memory #(16*KERNEL_COUNT, $sformatf("filter%0d_L2.txt", i+1)) FilterMem (.clk(clk), .addr(pc_filter_out), .data_out(filter_mems_out[i]));
  endgenerate
  generate
  for(i = 0; i < KERNEL_COUNT; i+=1)
    ofm_memory #(172,i+1) OFM (.clk(clk), .write_en(wr_ofm_en), .done(temp_done), .addr(ofm_addr), .inp(pes_out[i]),.data_out(ofms_out[i]));
  endgenerate

  cnn_layer2 #(KERNEL_COUNT) Layer2 (.clk(clk), .rst(rst), .start(temp_done), .cout_addr_generator(cout_addr_generator), .window_ld_done(window_ld_done),
    .filter_buff_inp(filter_mems_out), .window_inp(ofms_out), .en_pc_filter(en_pc_filter), .addr_gen_line_counter_en(addr_gen_line_counter_en), 
    .sel_mem_layer2(ofm_addr_sel_layer2), .addr_gen_window_pos_counter_en(addr_gen_window_pos_counter_en), .done(done));

endmodule