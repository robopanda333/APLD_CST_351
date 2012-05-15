
module SPI(
input			clk,
output	reg		s_clk,
output	reg		ss,
output			MOSI,
input			Data_rdy,
input	[7:0]	d,
output	reg		int
);

reg	[3:0]	count;
reg			load;
reg			ena;

shift U1(
		.d(d),
		.so(MOSI),
		.load(load),
		.clk(clk)
);
parameter	s_idle		= 0,
			s_ss_to_on	= 1,
			s_shifting	= 2,
			s_ss_to_off	= 3;

reg	[1:0]	state;
always@ (posedge clk)
begin
	case(state)
		s_idle:
			begin
				count	= 4'h0;
				if(Data_rdy)
					state = s_ss_to_on;
				else
					state = state;
			end
		s_ss_to_on:
			begin
				count	= 4'h0;
				state = s_shifting;
			end
		s_shifting:
			begin
				if(count[3])
					state = s_ss_to_off;
				else
					state = state;
				count	= count + 1;
			end
		s_ss_to_off:
			begin
				state = s_idle;
				count	= 4'h0;
			end
		default:
			begin
				state = s_idle;
				count	= 4'h0;
			end
	endcase
end

always@ (*)
begin
	case(state)
		s_idle:
			begin
				s_clk	= 1;
				ss		= 1;
				int		= 1;
				load	= 0;
			end
		s_ss_to_on:
			begin
				ss		= 0;
				s_clk	= 1;
				int		= 0;
				load	= 1;
			end
		s_shifting:
			begin
				ss		= 0;
				s_clk	= clk;
				int		= 0;
				load	= 0;
			end
		s_ss_to_off:
			begin
				ss		= 0;
				s_clk	= 1;
				int		= 0;
				load	= 0;
			end
		default:
			begin
				ss		= 1;
				s_clk	= 1;
				int		= 0;
				load	= 0;
			end
	endcase
end
endmodule


module shift(
input		[7:0]	d,
output	reg			so,
input				load,
input				clk
);
reg [7:0]tmp;

always@ (negedge clk)
begin
	so = tmp[7];
	if(load)
		tmp = d;
	else
		tmp = {tmp[6:0], 1'b0};
end
endmodule

