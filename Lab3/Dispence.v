

module Dispence(
input			clk,
input			reset,
input			enable,
input	[3:0]	key_code,
input			key_rdy,
input	[5:0]	coinVal,
output	[3:0]	itemCode,
output			code_valid,
output			Failed,
output			down
);

parameter	s_idle = 0,
			s_1stKey = 1,
			s_2ndKey = 2,
			s_decode = 3,
			s_charge = 4;
reg	[2:0]	state;
reg	[3:0]	key1,
			key2;

always@(negedge clk or posedge reset)
begin
	if(reset|~enable)
		state = s_idle;
end
endmodule

