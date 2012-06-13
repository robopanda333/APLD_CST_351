
module Lab1(
(* chip_pin = "J6" *)								input			CLK,
//(* chip_pin = "L17"   *)								input			hw_RESET,
(* chip_pin = "B13, B14, B15, B18" *)				input	[3:0]	K_I,//8,7,6,5
(* chip_pin = "B12, B11, A10, B9" *)				inout	[3:0]	K_O,//4,3,2,1
(* chip_pin = "U15" *)								input			Nickel,
(* chip_pin = "V15" *)								input			Dime,
(* chip_pin = "U14" *)								input			Quarter,
(* chip_pin = "V14" *)								input			Dollar,

(* chip_pin = "U13, V13, U12, V12" *)				output	[3:0]	LED_RIGHT,
(* chip_pin = "U4,V4,U5,V5" *)						output	[3:0]	LED_LEFT,
(* chip_pin = "C9, C10, D10, C11, D11, C12, D12" *)	output	[6:0]	SEG,
(* chip_pin = "H3, F3, C3" *)			 			output	[2:0]	COM,
(* chip_pin = "C4" *)								output			DP,
(* chip_pin = "B3" *)								output			COM4
);

wire hw_RESET = 0;
wire				key_ready,
				CLK_1k,
				RESET;
reg				rst;
wire	[3:0]	Key,
				A, B, C,
				K_O_tmp;
wire	[5:0]	coinCount;

CLKDIV divider(CLK,CLK_1k);
poweronreset r(CLK, hw_RESET, RESET);



KP_top kp(CLK_1k, K_I, K_O_tmp, {second, key}, key_ready);
tristate ts(K_O_tmp,K_O);

mainController mC(CLK_1k, RESET, key, key_ready, {Nickel, Dime, Quarter, Dollar}, coinCount, itemNumber);//, display_price, display_item);

coin_BCD c_bcd(coinCount, C, B, A);
MultiplexedDisplay lb(CLK_1k, A, B, C, SEG, COM);

 //make these static
assign DP = 0;
assign COM4 = 1;
endmodule




//just to get this stuff out of the top level
module tristate(
input [3:0] in,
inout [3:0] out
);
	assign out[0] = in[0]?1'bZ:1'b0;
	assign out[1] = in[1]?1'bZ:1'b0;
	assign out[2] = in[2]?1'bZ:1'b0;
	assign out[3] = in[3]?1'bZ:1'b0;
endmodule



//i am  adding this because my counter was starting at some non-zero value
//and it really shouldn't start with money inserted.
module poweronreset(
input clk,
input hw_reset,
output t_reset
);

reg sw_reset;
reg done;
reg [15:0] sw_reset_counter;
//simple power on reset
assign t_reset = sw_reset|hw_reset;
always@(posedge clk)
begin
if(done)
	begin
		sw_reset_counter = 0;
		sw_reset = 0;
	end
else
	if(sw_reset_counter <= 16'hAF2A) //some arbitrary non 0 number, it is very not likely to start at this value.
	begin
		sw_reset_counter = 0;
		done = 1;
		sw_reset = 1;
	end
	else
	begin
		sw_reset_counter = sw_reset_counter + 1;
		done = 0;
		sw_reset = 0;
	end
end
endmodule
