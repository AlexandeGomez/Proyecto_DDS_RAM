module flag_ram_full #(parameter ADDR_WIDTH = 8)(
	
	input clk,
	input [(ADDR_WIDTH-1) : 0] addr,
	
	output reg ram_full
);

always @(posedge clk) begin
	if(addr==(2**ADDR_WIDTH)-1)
		ram_full <= 1'b1;
	else
		ram_full <= 1'b0;
end

endmodule
