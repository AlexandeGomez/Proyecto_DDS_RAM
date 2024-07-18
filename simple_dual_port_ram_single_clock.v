module simple_dual_port_ram_single_clock #(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=8)
(
	input [(DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] read_addr, write_addr,
	input we, clk,
	output reg [(DATA_WIDTH-1):0] q
);

	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

	always @ (posedge clk)
	begin

		if (we)
			ram[write_addr] <= data;

		q <= ram[read_addr];
	end

endmodule
