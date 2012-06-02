//-----------------------------------------------------------------------------
//University: OIT - CSET
//Class: CST 231
//Lab:Lab 1
//Project: Multiplexed Display
//
//Author: Kehnin Dyer
//Date: 2012 02 02
//Dependancies: BCD_7SEG.v, MUX4_1x4.v DATA_LATCH.v PRIORITY_N_COUNTER.v
//-----------------------------------------------------------------------------
//DISCRIPTION: Top level of Lab 1. Connects the counter with priority
//encoder to a 4-1 by 4 mux which gets it's input from a latch that latches
//during one count of the 4. the data from the mux is then sent to the bcd to
//seven seg encoder which then gets output to the pins. the common is controlled
//by the inverted priority encoder.
//-----------------------------------------------------------------------------
module MultiplexedDisplay
(
	input			CLK,
	input	[3:0]	A,
	input	[3:0]	B,
	input	[3:0]	C,
	output	[6:0]	SEG, //[a:g]
	output	[2:0]	COM
);
//define pins

//define internal signals
	wire [1:0] Count;
	wire LatchControl;
	wire [2:0] com_n;
	wire [3:0] L_A, L_B, L_C, Muxd, test;
	
//body
assign COM = ~com_n;
//assign test = Muxd;
	PRIORITY_N_COUNTER pc(CLK, Count, {LatchControl, com_n});
	MUX4_1x4 m(Count, 4'h0, A, B, C, Muxd);
	BCD_7SEG b(Muxd, SEG);
endmodule
