module phase_generator #(parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 8)(
	input [(DATA_WIDTH-1) : 0] tw_in,
	input phase_ena,
	input clk,
	input rst,
	
	output [(ADDR_WIDTH-1) : 0] read_addr
);

reg [(ADDR_WIDTH) : 0] aux_addr;

always@(negedge clk or negedge rst) begin
	if(!rst)
		aux_addr <= 0;
	else
		begin
			if(phase_ena)
				begin
					if(aux_addr>=(2**ADDR_WIDTH-1))
						aux_addr <= 0;
					else
						aux_addr <= aux_addr + tw_in;
				end
			else
				aux_addr <= aux_addr;
		end
end

assign read_addr = aux_addr[(ADDR_WIDTH-1):0];

endmodule
