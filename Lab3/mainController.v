

module mainController(
input				clk,
input				reset,
input		[3:0]	key,
input				key_ready,
input		[3:0]	CoinInputs, //nickel dime quarter
output			[5:0]	coinCount,
//output	reg		itemNumber
output [7:0] LED
);

wire creturn;
wire long_rdy;
//pulseExtend lr(clk, key_ready, long_rdy);
assign creturn = &key && key_ready;

parameter	s_Idle		= 5'h00, //inserting coins, wait for
			s_Dispence	= 5'h02, //turn on dispence state machine, either go to idle, or coin return
			s_Return	= 5'h04;  //return remaining coins
parameter	m_Idle = 3'h0,
				m_Dispence = 3'h2,
				m_R1 = 3'h3,
				m_Return = 3'h4;

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
reg leden;
LEDS leds(clk, dis_itemKey, leden, ret_down_5, ret_down_10, ret_down_25, LED);

reg		[2:0]	state;

always@ (negedge clk or posedge reset )
begin

	if(reset)
		state = m_Idle;
	else 
	case(state)		
	m_Idle:
	begin
		if(creturn)
			state = m_Return;
		else if(key_ready)
			state = m_Dispence;
		else
			state = state;
	end
	m_Dispence:
	begin
		if(dis_fail)
			state = m_Idle;
		else if (dis_done)
			state = m_R1;
		else
			state = state;
	end
	m_R1:
	begin
			if(ret_done)
			state = m_Idle;
		else
			state = state;
	end
	m_Return:
		if(ret_done)
			state = m_Idle;
		else
			state = state;
	default:
		state = m_Idle;
	endcase
end

always@ (*)
begin
	casex(state)
	m_Idle:
	begin
		leden = 0;
		dis_en = 0;
		ret_en = 0;
	end
	m_Dispence:
	begin
		leden = 1;
		dis_en = 1;
		ret_en = 0;
	end
	m_R1:
	begin
		leden = 1;
		dis_en = 0;
		ret_en = 1;
	end
	m_Return:
	begin
		leden = 0;
		dis_en = 0;
		ret_en = 1;
	end
	default:
	begin
		leden = 0;
		dis_en = 0;
		ret_en = 0;
	end
	endcase
end
endmodule

