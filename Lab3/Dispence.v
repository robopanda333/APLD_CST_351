
module Dispence(
input			clk,
input			reset,
input			enable,
input	[3:0]	key_code,
input			key_rdy,
input	[5:0]	coinVal,
input			kill,
output	reg[3:0]	itemCode,
output	reg		done,
output	reg		failed,
output	reg		dispencing,
output			down_5Out,
output			down_10Out,
output			down_25Out
);
reg down_5, down_10, down_25;
assign {down_5Out, down_10Out,down_25Out} = {down_5, down_10, down_25};
parameter	s_idle     = 0,
			s_1stKey   = 1,
			s_2ndKey   = 2,
			s_decode   = 3,
			s_charge   = 4,
			s_wait1sec = 5,
			s_done     = 6;
reg	[2:0]	state;
reg	[5:0]	costCounter;

parameter secondcount = 2000;
reg [10:0] secondtimer;

/*
reg	[5:0] itemCost [0:8];
//reg [3:0] itemIndex [0:255];
initial
begin
//	$readmemh("itemindex.rom", itemIndex);
	$readmemh("itemcost.rom", itemCost);
end
*/

	
always@(posedge clk or posedge reset)
begin
	if(reset)
	begin
		secondtimer = 0;
		state = s_idle;
		itemCode = 0;
	end
	else if(!enable)
	begin
		secondtimer = 0;
		state = s_idle;
		itemCode = (kill?0:itemCode);
	end
	else
	case(state)
	s_idle:
	begin
		
		secondtimer = 0;
		//costCounter = 0;
		if(enable)
		begin
			case(key_code)
			4'h1:itemCode = 1;
			4'h2:itemCode = 1;
			4'h3:itemCode = 2;
			4'h4:itemCode = 2;
			4'h5:itemCode = 3;
			4'h6:itemCode = 3;
			4'h7:itemCode = 4;
			4'h8:itemCode = 4;
			default:	itemCode = 0;
			endcase
			state = s_decode;
		end
		else
		begin
			state   = state;
			itemCode    = itemCode;
		end
	end
	s_decode:
	begin
		secondtimer = 0;
		state = s_charge;
		itemCode    = itemCode;
	end
	s_charge:
	begin
			itemCode    = itemCode;
		secondtimer = 0;
		if(costCounter > 0)
		begin
			state = state;
		end
		else
			state = s_wait1sec;
	end
	s_wait1sec:
	begin
			itemCode   = itemCode;
		if(secondtimer < secondcount)
		begin
			state = state;
			secondtimer = secondtimer + 10'b1;
		end
		else
		begin
			secondtimer = secondtimer;
			state = s_done;
		end
	end
	s_done:
	begin
			itemCode    = itemCode;
		state = state;
		secondtimer = 0;
	end
	default:
	begin
		itemCode    = 0;
		secondtimer = 0;
		state       = s_idle;
	end
	endcase
end

always@(*)
begin
case(state)
	s_idle:
	begin
		done        = 0;
		failed      = 0;
		dispencing  = 0;
		{down_5, down_10, down_25} = 0;
	end
	s_decode:
	begin
		done = 0;
		dispencing = 0;
		{down_5, down_10, down_25} = 0;
		case(key_code)
		4'h1:	failed = coinVal < 6'd15;
		4'h2:	failed = coinVal < 6'd15;
		4'h3:	failed = coinVal < 6'd13;
		4'h4:	failed = coinVal < 6'd13;
		4'h5:	failed = coinVal < 6'd17;
		4'h6:	failed = coinVal < 6'd17;
		4'h7:	failed = coinVal < 6'd10;
		4'h8:	failed = coinVal < 6'd10;
		default:failed = 1;
		endcase
	end
	s_charge:
	begin
		done        = 0;
		failed      = 0;
		dispencing  = 1;
		down_5  = costCounter >= 1;
		down_10 = costCounter >= 2;
		down_25 = costCounter >= 5;
	end
	s_wait1sec:
	begin
	{down_5, down_10, down_25} = 0;
		done       = 0;
		failed     = 0;
		dispencing = 1;
	end
	s_done:
	begin
	{down_5, down_10, down_25} = 0;
		done        = 1;
		failed      = 0;
		dispencing  = 1;
	end
	default:
	begin
		{down_5, down_10, down_25} = 0;
		done        = 0;
		failed      = 0;
		dispencing  = 0;
	end
endcase
end


always@(posedge clk)
begin
	case(state)
	s_decode:
		case(itemCode)
			4'h1:costCounter = 6'd15;
			4'h2:costCounter = 6'd13;
			4'h3:costCounter = 6'd17;
			4'h4:costCounter = 6'd10;
			default:costCounter = 0;
		endcase
	s_charge:
		casex({down_25, down_10, down_5})
			3'b1xx:  costCounter = costCounter - 6'h5;
			3'b01x:  costCounter = costCounter - 6'h2;
			3'b001:  costCounter = costCounter - 6'h1;
			default: costCounter = costCounter;
		endcase
	default:
	costCounter = costCounter;
	endcase

end



endmodule
