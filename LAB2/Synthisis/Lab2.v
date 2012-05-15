

//defines for wishbone SPI module
module Lab2(
(* chip_pin = "J6" *)								input			CLK,
(* chip_pin = "B13, B14, B15, B18" *)				input	[3:0]	K_I,//8,7,6,5
(* chip_pin = "B12, B11, A10, B9" *)				inout	[3:0]	K_O,//4,3,2,1
(* chip_pin = "U13, V13, U12, V12" *)				output	[3:0]	LED_RIGHT,
(* chip_pin = "U4,V4,U5,V5" *)						output	[3:0]	LED_LEFT,
(* chip_pin = "C9, C10, D10, C11, D11, C12, D12" *)	output	[6:0]	SEG,
(* chip_pin = "H3, F3, C3" *)			 			output	[2:0]	COM,
(* chip_pin = "C4" *)								output			DP,
(* chip_pin = "B3" *)								output			COM4,
/////////////////////////////////////////////////////////////////spi
(* chip_pin = "B16" *)								output			sClk,
(* chip_pin = "D14" *)								output			sOut,
(* chip_pin = "C15" *)								input			sIn,
(* chip_pin = "C14" *)								output			sSS
);

wire clk_1KHz;

wire	[7:0]	cnt_d,
				Ascii;
wire	[3:0]	K_O_tmp;
wire			cnt_ena,
				cnt_d_rdy,
				Ascii_rdy;

CLKDIV cckdv(CLK, clk_1KHz);

KP_top kp(
				.CLK(clk_1KHz),
				.K_I(K_I),
				.K_O(K_O_tmp),
				.Ascii(Ascii),
				.d_rdy(Ascii_rdy)
);
tristate ts(K_O_tmp,K_O);

Controller cnt(
					.clk(clk_1KHz),
					.Data(cnt_d),
					.Data_rdy(cnt_d_rdy),
					.transEna(cnt_ena),
					.Ascii(Ascii),
					.Ascii_Rdy(Ascii_rdy)
);

SPI spi(
		.clk(clk_1KHz),
		.s_clk(sClk),
		.ss(sSS),
		.MOSI(sOut),
		.Data_rdy(cnt_d_rdy),
		.d(cnt_d),
		.int(cnt_ena)
);

assign {LED_LEFT, LED_RIGHT} = ~{K_I,K_O_tmp};

endmodule



module tristate(
input [3:0] in,
inout [3:0] out
);
	assign out[0] = in[0]?1'bZ:1'b0;
	assign out[1] = in[1]?1'bZ:1'b0;
	assign out[2] = in[2]?1'bZ:1'b0;
	assign out[3] = in[3]?1'bZ:1'b0;
endmodule


