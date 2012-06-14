

module c_return(
input			clk,
input	[5:0]	coinCount,
input			en,
output	reg		done,
output	reg		down_5,
output	reg		down_10,
output	reg		down_25
);

parameter	s_idle = 0,
			s_ret  = 1,
			s_wait = 2,
			s_done = 3;
reg [1:0] state;

parameter waitVal = 2000;
reg [10:0] waitCount;


always@ (negedge clk)
begin
	if(!en)
		state = s_idle;
	else
	begin
		case(state)
		s_idle:
			state = s_ret;
		s_ret:
			if(coinCount > 0)
				state = s_wait;
			else
				state = s_done;
		s_wait:
			if(waitCount < waitVal)
				state = state;
			else
				state = s_ret;
		s_done:
			state = state;
		endcase
	end
end

always@ (posedge clk)
begin
	case(state)
	s_idle:
	begin
		waitCount = 0;
		{down_5, down_10, down_25} = 0;
		done = 0;
	end
	s_ret:
	begin
		waitCount = 0;
		down_5  = coinCount >= 1;
		down_10 = coinCount >= 2;
		down_25 = coinCount >= 5;
		done = 0;
	end
	s_wait:
	begin
		waitCount = waitCount + 11'h1;
		{down_5, down_10, down_25} = 3'h0;
		done = 0;
	end
	s_done:
	begin
		waitCount = 0;
		{down_5, down_10, down_25} = 0;
		done = 1;
	end
	endcase
end
endmodule
