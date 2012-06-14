module LEDS(
input clk,
input [3:0]item,
input dispencing,
input down_5,
input down_10,
input down_25,
output [7:0] leds
);
assign leds[0] = !(item==4'h1 && dispencing);
assign leds[1] = !(item==4'h2 && dispencing);
assign leds[2] = !(item==4'h3 && dispencing);
assign leds[3] = !(item==4'h4 && dispencing);
assign leds[4] = 1;

Blink five(clk, down_5 && ~down_10 && ~down_25, leds[5]);
Blink ten(clk, down_5 && down_10 && ~down_25, leds[6]);
Blink twentyfive(clk, down_5 && down_10 && down_25, leds[7]);

endmodule



module Blink(
input clk,
input en,
output reg LED
);
parameter 	count = 1,
				idle  = 0;
reg  state;
parameter secondcount = 1000;
parameter halftime = 500;
reg [10:0] counter;

always@ (posedge clk)
begin
	if(en)
	begin
		counter = 0;
		state = count;
	end
	else
	case(state)
	count:
		if (counter < secondcount)
		begin
			counter = counter + 1;
			state = count;
		end
		else
		begin
			state = idle;
			counter = 2001;
		end
	idle:
	begin
		state = idle;
		counter = 2001;
	end
	endcase
end
always@ (*)
begin
	if(state == count)
		LED = !(counter < halftime);
	else
		LED = 1;
end

endmodule