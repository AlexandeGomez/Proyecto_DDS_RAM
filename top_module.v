module top_module #(parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 8)(

	input clk_top,
	input reset_top,
	input [1:0] instruct_top,
	input [(DATA_WIDTH-1) : 0] data_top,
	input [(ADDR_WIDTH-1) : 0] write_addr_top,
	
	output [(DATA_WIDTH-1) : 0] tw_out_top,
	output [(ADDR_WIDTH-1) : 0] read_addr_top,
	output [(DATA_WIDTH-1):0] q_top,
	output ram_full_top,
	output write_ena_top,
	output phase_ena_top,
	output tuning_ena_top
);


//		TUNING WORD
tuning_word #( .ADDR_WIDTH(ADDR_WIDTH)) tw_dut(
	//in
	.clk		(clk_top),
	.tw_in	(write_addr_top),
	.ena_tw	(tuning_ena_top),
	//out
	.tw_out	(tw_out_top)
);

// 	PHASE GENERATOR
phase_generator #( .DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) phgen_dut(
	//in
	.tw_in		(tw_out_top),
	.phase_ena	(phase_ena_top),
	.clk			(clk_top),
	.rst			(reset_top),
	//out
	.read_addr	(read_addr_top)
);

//		RAM
simple_dual_port_ram_single_clock #( .DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) ram_dut(
	//in
	.data			(data_top),
	.read_addr	(read_addr_top),
	.write_addr	(write_addr_top),
	.we			(write_ena_top),
	.clk			(clk_top),
	//out
	.q				(q_top)
);

// 	FLAG FULL RAM
flag_ram_full #( .ADDR_WIDTH(ADDR_WIDTH)) flag_ram_dut(
	//in
	.clk			(clk_top),
	.addr			(write_addr_top),
	//out
	.ram_full	(ram_full_top)
);

//		MAQUINA DE ESTADOS
mealy_sm fsm_dut(
	//	in
	.clk			(clk_top),
	.reset		(reset_top),
	.ram_full	(ram_full_top),
	.instruct	(instruct_top),
	//out
	.write_ena	(write_ena_top),
	.phase_ena	(phase_ena_top),
	.tuning_ena	(tuning_ena_top)
);

endmodule
