

module Dispence(
input			clk,
input			reset,
input			enable,
input	[3:0]	key_code,
input			key_rdy,
input	[5:0]	coinVal,
output	[3:0]	itemCode,
output			done,
output			Failed,
output			down_5,
output			down_10,
output			down_25
);

parameter	s_idle     = 0,
			s_1stKey   = 1,
			s_2ndKey   = 2,
			s_decode   = 3,
			s_charge   = 4,
			s_wait1sec = 5,
			s_done     = 6;


module Dispence(
input			clk,
input			reset,
input			enable,
input	[3:0]	key_code,
input			key_rdy,
input	[5:0]	coinVal,
output	[3:0]	itemCode,
output			done,
output			Failed,
output			down_5,
output			down_10,
output			down_25
);

parameter	s_idle     = 0,
			s_1stKey   = 1,
			s_2ndKey   = 2,
			s_decode   = 3,
			s_charge   = 4,
			s_wait1sec = 5;
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
	if(reset|~enable)
		state = s_idle;
	case(state)
	s_idle:
	begin
		itemCode    = itemIndex[{key1, key2}];
		costCounter = itemCost[itemIndex[{key1, key2}]];
		done        = 0;
		failed      = 0;
		key1        = 0;
		key2        = 0;
		secondtimer = 0;
		if(enable)
			state   = s_1stKey;
		else
			state   = state;
	end
	s_1stKey:
	begin
		itemCode    = itemIndex[{key1, key2}];
		costCounter = itemCost[itemIndex[{key1, key2}]];
		done        = 0;
		key2        = 0;
		secondtimer = 0;
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
		costCounter = itemCost[itemIndex[{key1, key2}]];
		done        = 0;
		failed      = 0;
		key1        = key1;
		secondtimer = 0;
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
		costCounter =    itemCost[itemIndex[{key1, key2}]];
		done        = 0;
		failed      = !((itemCost[itemIndex[{key1, key2}]] <= coinVal)&&itemIndex[{key1, key2}]);
		key1        = key1;
		key2        = key2;
		secondtimer = 0;
		state       = s_charge;
	end
	s_charge:
	begin
		if(costCounter > 0)
		begin
			down_5  = costCounter >= 1;
			down_10 = costCounter >= 2;
			down_25 = costCounter >= 5;
			state = s_wait1sec;
		end
		else
			state = s_idle;
		end
	end
	s_wait1sec:
	begin
	end
	s_done:
	begin
		
	end
	default:
		begin
			
		end
	endcase
end

endmodule

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
	if(reset|~enable)
		state = s_idle;
	case(state)
	s_idle:
		begin
			itemCode    = itemIndex[{key1, key2}];
			costCounter = itemCost[itemIndex[{key1, key2}]];
			done        = 0;
			failed      = 0;
			key1        = 0;
			key2        = 0;
			secondtimer = 0;
			if(enable)
				state   = s_1stKey;
			else
				state   = state;
		end
	s_1stKey:
		begin
			itemCode    = itemIndex[{key1, key2}];
			costCounter = itemCost[itemIndex[{key1, key2}]];
			done        = 0;
			key2        = 0;
			secondtimer = 0;
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
			costCounter = itemCost[itemIndex[{key1, key2}]];
			done        = 0;
			failed      = 0;
			key1        = key1;
			secondtimer = 0;
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
			costCounter =    itemCost[itemIndex[{key1, key2}]];
			done        = 0;
			failed      = !((itemCost[itemIndex[{key1, key2}]] <= coinVal)&&itemIndex[{key1, key2}]);
			key1        = key1;
			key2        = key2;
			secondtimer = 0;
			state       = s_charge;
		end
	s_charge:
		begin
			if(costCounter > 0)
			begin
				down_5  = costCounter >= 1;
				down_10 = costCounter >= 2;
				down_25 = costCounter >= 5;
				state = s_wait1sec;
			end
			else
				state = s_idle;
			end
		end
	s_wait1sec:
	default:
		begin
			
		end
	endcase
end

endmodule

