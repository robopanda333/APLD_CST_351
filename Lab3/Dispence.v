
module Dispence(
input			clk,
input			reset,
input			enable,
input	[3:0]	key_code,
input			key_rdy,
input	[5:0]	coinVal,
output	reg[3:0]	itemCode,
output	reg		done,
output	reg		failed,
output	reg		dispencing,
output	reg		down_5,
output	reg		down_10,
output	reg		down_25
);

parameter	s_idle     = 0,
			s_1stKey   = 1,
			s_2ndKey   = 2,
			s_decode   = 3,
			s_charge   = 4,
			s_wait1sec = 5,
			s_done     = 6;
reg	[2:0]	state;
reg	[5:0]	costCounter;
reg	[3:0]	key1,
			key2;

parameter secondcount = 999;
reg [9:0] secondtimer;

reg	[5:0] itemCost [0:8];
initial
	$readmemh("itemcost.rom", itemCost);

reg [3:0] itemIndex [0:255];//we can support every item!
initial
	$readmemh("itemindex.rom", itemIndex);

always@(negedge clk or posedge reset)
begin
	if(reset)
		state = s_idle;
	else if(!enable)
		state = s_idle;
	else
	case(state)
	s_idle:
	begin
		itemCode    = itemIndex[{key1, key2}];
		done        = 0;
		failed      = 0;
		key1        = 0;
		key2        = 0;
		secondtimer = 0;
		dispencing  = 0;
		if(enable)
			state   = s_1stKey;
		else
			state   = state;
	end
	s_1stKey:
	begin
		itemCode    = itemIndex[{key1, key2}];
		done        = 0;
		key2        = 0;
		secondtimer = 0;
		dispencing  = 0;
		if(key_rdy)
		begin
			state   = s_2ndKey;
			key1    = key_code;
		end
		else
		begin
			state   = state;
			key1    = key1;
		end
	end
	s_2ndKey:
	begin
		itemCode    = itemIndex[{key1, key2}];
		done        = 0;
		failed      = 0;
		key1        = key1;
		secondtimer = 0;
		dispencing  = 0;
		if(key_rdy)
		begin
			state   = s_2ndKey;
			key2    = key_code;
		end
		else
		begin
			state   = state;
			key2    = key2;
		end
	end
	s_decode:
	begin//store these values for the last time!
		itemCode    =    itemIndex[{key1, key2}];
		done        = 0;
		failed      = !((itemCost[itemIndex[{key1, key2}]] <= coinVal)&&itemIndex[{key1, key2}]);
		//if failed goes high the upper level state machine will set enable low killing this machine imediatlly.
		key1        = key1;
		key2        = key2;
		secondtimer = 0;
		dispencing  = 0;
		state       = s_charge;
	end
	s_charge:
	begin
		itemCode    = itemCode;
		done        = 0;
		failed      = 0;
		key1        = key1;
		key2        = key2;
		secondtimer = 0;
		dispencing  = 1;
		if(costCounter > 0)
		begin
			down_5  = costCounter >= 1;
			down_10 = costCounter >= 2;
			down_25 = costCounter >= 5;
			state = s_wait1sec;
		end
		else
			state = s_done;
	end
	s_wait1sec:
	begin
		itemCode   = itemCode;
		done       = 0;
		failed     = 0;
		key1       = key1;
		key2       = key2;
		dispencing = 1;
		if(secondtimer < secondcount)
		begin
			state = state;
			secondtimer = secondtimer+1;
		end
		else
		begin
			state = s_charge;
		end
	end
	s_done:
	begin
		itemCode    = itemCode;
		done        = 1;
		failed      = 0;
		key1        = key1;
		key2        = key2;
		secondtimer = 0;
		dispencing  = 1;
		state = state;
	end
	default:
		begin
			itemCode    = 0;
			done        = 0;
			failed      = 0;
			key1        = 0;
			key2        = 0;
			secondtimer = 0;
			dispencing  = 0;
			state       = s_idle;
		end
	endcase
end




always@(posedge clk)
begin
	case(state)
	s_decode:
		costCounter = itemCost[itemIndex[{key1, key2}]];
	s_charge:
		casex({down_25, down_10, down_5})
			3'b1xx:  costCounter = costCounter - 5;
			3'b01x:  costCounter = costCounter - 2;
			3'b001:  costCounter = costCounter - 1;
			default: costCounter = costCounter;
		endcase
	default:
	costCounter = costCounter;
	endcase

end



endmodule
