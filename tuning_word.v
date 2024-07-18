module tuning_word #(parameter ADDR_WIDTH = 8)(
	
	input clk,
	input [(ADDR_WIDTH-1) : 0] tw_in,
	input ena_tw,
	
	output reg [(ADDR_WIDTH-1) : 0] tw_out
);

always@(posedge clk) begin
	if(ena_tw)
		begin
			tw_out <= tw_in;
		end
	else
		tw_out <= tw_out;
end

endmodule
