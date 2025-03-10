module mealy_sm
(
	input	clk,
	input reset,
	input ram_full,
	input [1:0] instruct,
	
	output reg write_ena,
	output reg phase_ena,
	output reg tuning_ena
);

	// Declare state register
	reg		[1:0]state;

	// Declare states
	parameter IDLE = 0, RAM_INIT = 1, TUNING_INIT = 2, DDS_RUNNING = 3;

	// Determine the next state synchronously, based on the
	// current state and the input
	always @ (posedge clk or negedge reset) begin
		if (!reset)
			state <= IDLE;
		else
			case (state)
				IDLE:
					if (instruct==2'b01)
						state <= RAM_INIT;
					else if(instruct==2'b11)
						state <= DDS_RUNNING;
					else
						state <= IDLE;
				RAM_INIT:
					if (ram_full)
						state <= IDLE;
					else if (instruct==2'b10)
						state <= TUNING_INIT;
					else 
						state <= RAM_INIT;
				TUNING_INIT:
					begin
						state <= RAM_INIT;
					end
				DDS_RUNNING:
					if (!ram_full)
						state <= IDLE;
					else
						state <= DDS_RUNNING;
			endcase
	end

	// Determine the output based only on the current state
	// and the input (do not wait for a clock edge).
	always @ (state or ram_full)
	begin
			case (state)
				IDLE:
					begin
						write_ena <= 1'b0;
						phase_ena <= 1'b0;
						tuning_ena <= 1'b0;
					end
				RAM_INIT:
					if(!ram_full)
						begin
							write_ena <= 1'b1;
							phase_ena <= 1'b0;
							tuning_ena <= 1'b0;
						end
					else
						begin
							write_ena <= 1'b0;
							phase_ena <= 1'b0;
							tuning_ena <= 1'b0;
						end
				TUNING_INIT:
					begin
						write_ena <= 1'b1;
						phase_ena <= 1'b0;
						tuning_ena <= 1'b1;
					end
				DDS_RUNNING:
					if (!ram_full)
						begin
							write_ena <= 1'b0;
							phase_ena <= 1'b0;
							tuning_ena <= 1'b0;
						end
					else
						begin
							write_ena <= 1'b0;
							phase_ena <= 1'b1;
							tuning_ena <= 1'b0;
						end
			endcase
	end

endmodule
