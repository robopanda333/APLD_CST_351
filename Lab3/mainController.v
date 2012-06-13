

module mainController(
input				clk,
input				reset,
input		[3:0]	key,
input				key_ready,
input		[3:0]	CoinInputs, //nickel dime quarter
output			[5:0]	coinCount,
output	reg		itemNumber
);

wire creturn;
assign creturn = (!key) && key_ready;
parameter	s_Idle		= 5'h00, //inserting coins, wait for
			s_Dispence	= 5'h02, //turn on dispence state machine, either go to idle, or coin return
			s_Return	= 5'h04;  //return remaining coins

wire	[3:0]	dis_itemKey;
wire			dis_fail,
				dis_done,
				dis_led;
reg				dis_en;
wire			dis_down_5, dis_down_10, dis_down_25;


Dispence ud(clk, reset, dis_en, key, key_ready, coinCount, dis_itemKey, dis_done, dis_fail, dis_led,
			dis_down_5, dis_down_10, dis_down_25);

wire			n_syn,
				di_syn,
				q_syn,
				do_syn;
wire		down_5, down_10, down_25;
assign down_5  = dis_down_5  | ret_down_5 ;
assign down_10 = dis_down_10 | ret_down_10;
assign down_25 = dis_down_25 | ret_down_25;
coinSync csync(clk, CoinInputs[3], CoinInputs[2], CoinInputs[1], CoinInputs[0], n_syn, di_syn, q_syn, do_syn);
CoinCounter	ccnt(clk, reset, n_syn, di_syn, q_syn, do_syn, down_5, down_10, down_25, coinCount);

reg		ret_en;
wire	ret_done;
wire	ret_down_5, ret_down_10, ret_down_25;
c_return ret(clk, coinCount, ret_en, ret_done, ret_down_5, ret_down_10, ret_down_25);


reg		[2:0]	state;

always@ (posedge clk or posedge reset)
begin
	casex({reset, creturn, state})
	5'b1xxxx:
		state = s_Idle;
	5'b01xxx:
		state = s_Return;
	s_Idle:
		if(key_ready)
			state = s_Dispence;
		else
			state = state;
	s_Dispence:
		case({dis_fail, dis_done})
		2'b1x:  state = s_Idle;
		2'b01:  state = s_Return;
		default:state = state;
		endcase
	s_Return:
		if(ret_done)
			state = s_Idle;
		else
			state = state;
	endcase
end

always@ (*)
begin
	casex({reset, creturn, state})
	5'b1xxxx:
	begin
		dis_en = 0;
		ret_en = 0;
	end
	5'b01xxx:
	begin
		dis_en = 0;
		ret_en = 0;
	end
	s_Idle:
	begin
		dis_en = 0;
		ret_en = 0;
	end
	s_Dispence:
	begin
		dis_en = 1;
		ret_en = 0;
	end
	s_Return:
	begin
		dis_en = 0;
		ret_en = 1;
	end
	default:
	begin
		dis_en = 0;
		ret_en = 0;
	end
	endcase
end
endmodule

