module four_by_four_buffer(input  clk, rst, wr_en,
  input [3:0] rd_index, wr_index,
  input [7:0] data_in[0:3],
  output [7:0] data_out
);

  reg [7:0] memory [0:15];

  always @(posedge clk,posedge rst) begin
    if (rst) begin
      integer k;
      for (k = 0; k < 16; k = k + 1) begin
          memory[k] = 8'd0;
      end
    end
    if (wr_en)
      begin
      memory[wr_index] <= data_in[0];
      memory[wr_index+4'd1] <= data_in[1];
      memory[wr_index+4'd2] <= data_in[2];
      memory[wr_index+4'd3] <= data_in[3];
    end
  end

  assign data_out = memory[rd_index];

endmodule


module four_by_four_window(input clk,rst, wr_en,
  input [3:0] rd_index,
  input [7:0] data_in[0:3][0:3],
  output [7:0] data_out
);

  reg [7:0] memory [0:15];

  always @(posedge clk,posedge rst) begin
    if (rst) begin
      integer k;
      for (k = 0; k < 16; k = k + 1) begin
          memory[k]=8'd0;
      end
    end
    if (wr_en) begin
      integer i;
      integer j;
      for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
          memory[4*i+j] = data_in[i][j]; 
        end
      end
    end
  end

  assign data_out = memory[rd_index];

endmodule


module four_by_sixteen_buffer (input clk, rst, sh_en, wr_en,
  input [3:0] rd_index,wr_index,
  input [7:0] data_in [0:3],
  output reg [7:0] data_out [0:3][0:3]
);
  
  reg [7:0] memory [0:3][0:15];

  always @(posedge clk , posedge rst) begin
    if (rst) begin
      integer i;
      integer j;
      for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
          memory[i][j] <= 8'b0;
        end
      end
    end 
    else begin
      if (wr_en == 1'b1) begin
        memory[3][wr_index] <= data_in[0] ;
        memory[3][wr_index + 1] <= data_in[1] ;
        memory[3][wr_index + 2] <= data_in[2] ;
        memory[3][wr_index + 3] <= data_in[3] ;
      end
      
      if(sh_en)begin
        integer i;
        integer j;
			  for (i = 0; i < 3; i = i + 1) begin
          	for (j = 0; j < 16; j = j + 1)begin
            				memory[i][j] <= memory[i+1][j];
          			end
        		end
		  end
      
    end
  end
  always @(*) begin
    integer i;
      integer j;
      for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
          data_out[j][i]= memory[j][rd_index+i]; 
        end
      end
  end
endmodule