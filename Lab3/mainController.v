

module mainController(
input		clk,
input		reset,
input [3:0]	key,
input		key_ready,
input [5:0]	coinCount,

);

wire return;
assign return = (&key) && key_ready;
parameter	s_Idle		= 5'h00, //inserting coins, wait for
			s_Dispence	= 5'h02, //turn on dispence state machine, either go to idle, or coin return
			s_Return	= 5'h04;  //return remaining coins

wire	[]	dispence_itemKey;
wire		dispence_fail,
			dispence_succeed,
			dispence_enable;
Dispence ud(clk, reset, )


wire			n_syn,
				di_syn,
				q_syn,
				do_syn,
				down;

coinSync csync(clk, Nickel, Dime, Quarter, Dollar, n_syn, di_syn, q_syn, do_syn);
CoinCounter	ccnt(clk, RESET, n_syn, di_syn, q_syn, do_syn, down, coinCount);



reg		[2:0]	state;

always@ (posedge clk or posedge reset)
begin
	casex({reset, return, state})
	5'b1xxxx:
	5'b01xxx:
	s_Idle:
	s_Dispence:
	s_Return:
	endcase
end

always@ (*)
begin
	casex({reset, return, state})
	5'b1xxxx:
	begin
	end
	5'b01xxx:
	begin
	end
	s_Idle:
	begin
	end
	s_Dispence:
	begin
	end
	s_Return:
	begin
	end
	default:
	begin
	end
	endcase
end
endmodule

