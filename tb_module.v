`timescale 1ns/1ns
module tb_module #(parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 8, parameter TUNING = 1)();

reg clk_tb;
reg reset_tb;
reg [1:0] instruct_tb;
reg [(DATA_WIDTH-1) : 0] data_tb;
reg [(ADDR_WIDTH-1) : 0] write_addr_tb;
	
wire [(DATA_WIDTH-1) : 0] tw_out_tb;
wire [(ADDR_WIDTH-1) : 0] read_addr_tb;
wire [(DATA_WIDTH-1):0] q_tb;
wire ram_full_tb;
wire write_ena_tb;
wire phase_ena_tb;
wire tuning_ena_tb;

integer i = 0;
integer fileinCoeffs,statusI = 0;

reg [(ADDR_WIDTH-1) : 0] tuning_value = TUNING; 

top_module #( .DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) dut(
	//in
	.clk_top			(clk_tb),
	.reset_top		(reset_tb),
	.instruct_top	(instruct_tb),
	.data_top		(data_tb),
	.write_addr_top(write_addr_tb),
	//out
	.tw_out_top		(tw_out_tb),
	.read_addr_top	(read_addr_tb),
	.q_top			(q_tb),
	.ram_full_top	(ram_full_tb),
	.write_ena_top	(write_ena_tb),
	.phase_ena_top	(phase_ena_tb),
	.tuning_ena_top(tuning_ena_tb)
);

initial begin
	fileinCoeffs = $fopen("Sine_hexv.txt","r");
	clk_tb = 1'b0;
	reset_tb = 1'b1;
	#1 reset_tb = 1'b0;
	#1 reset_tb = 1'b1;
	
	instruct_tb = 2'b01;
	#2 instruct_tb = 2'b00;
	
	#2500;
	$stop;
end


initial begin
	@(instruct_tb == 2'b01)
	@(negedge clk_tb)
	while(!$feof(fileinCoeffs)) begin
		@(posedge clk_tb)
		statusI = $fscanf(fileinCoeffs,"%h \n",data_tb);
		write_addr_tb = i;
		i = i + 1;
		
		if(i==tuning_value+1)
			begin
				instruct_tb = 2'b10;
				#3 instruct_tb = 2'b00;
			end
	end
	$fclose(fileinCoeffs);
	instruct_tb = 2'b11;
	#8 instruct_tb = 2'b00;
end


always #1 clk_tb = ~clk_tb;

endmodule
