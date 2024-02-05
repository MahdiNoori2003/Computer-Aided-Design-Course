module read_memory #(parameter WIDTH, string FILENAME) (input clk, 
    input[$clog2(WIDTH)-1:0] addr, 
    output [7:0] data_out [0:3]
);

    reg [31:0] data_mem [0:WIDTH - 1];
    initial 
    begin
        $readmemh ($sformatf("./file/%s", FILENAME), data_mem);
    end

    assign data_out[3] = data_mem [(addr >> 2)][7:0];
    assign data_out[2] = data_mem [(addr >> 2)][15:8];
    assign data_out[1] = data_mem [(addr >> 2)][23:16];
    assign data_out[0] = data_mem [(addr >> 2)][31:24];

endmodule


module write_memory #(parameter WIDTH,NUMBER) (input clk, write_en, done, 
    input[$clog2(WIDTH)-1:0] addr,
    input[7:0] inp [0:3]
);

    reg [31:0] data_mem [0:WIDTH - 1];
    
    always @(posedge clk) 
        begin
            if (write_en)
                data_mem[(addr >> 2)] <= {inp[0],inp[1],inp[2],inp[3]};
        end

    reg [63:0] hex_char;

    always @(done) begin
        if (done)begin
            integer i;
            integer file;
		    file = $fopen($sformatf("./outputs/output%0d_L2.txt", NUMBER), "w");

   	 	    for (i = 0; i < 25; i = i + 1) begin
      	    		$sformat(hex_char, "%h", data_mem[i]); 
      	    		$fwrite(file, "%s\n", hex_char);
    	    	end

    	    	$fclose(file); 
  	    end
    end

endmodule

module ofm_memory #(parameter WIDTH,NUMBER) (input clk, write_en, done, 
    input[$clog2(WIDTH)-1:0] addr,
    input[7:0] inp [0:3],
    output reg[7:0] data_out [0:3]
);

    reg [7:0] data_mem [0:WIDTH - 1];
    
    always @(posedge clk) 
        begin
            if (write_en) begin
                data_mem[(addr)] <= inp[0];
                data_mem[(addr) +1] <= inp[1];
                data_mem[(addr) +2] <= inp[2];
                data_mem[(addr) +3] <= inp[3];
            end
        end

    assign data_out[3] = data_mem [(addr + 3)];
    assign data_out[2] = data_mem [(addr + 2)];
    assign data_out[1] = data_mem [(addr + 1)];
    assign data_out[0] = data_mem [(addr)];


    reg [63:0] hex_char;

    always @(done) begin
        if (done)begin
            integer i;
            integer file;
		    file = $fopen($sformatf("./outputs/output%0d_L1.txt", NUMBER), "w");

   	 	    for (i = 0; i < 43; i = i + 1) begin
      	    		$sformat(hex_char, "%h", {data_mem[(4*i)],data_mem[(4*i)+1],data_mem[(4*i)+2],data_mem[(4*i)+3]}); 
      	    		$fwrite(file, "%s\n", hex_char);
    	    	end

    	    	$fclose(file); 
  	    end
    end

endmodule