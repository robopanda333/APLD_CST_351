//-----------------------------------------------------------------------------
//University: OIT - CSET
//Class: CST 231
//Lab:Lab 1
//Project: Multiplexed Display
//
//Author: Kehnin Dyer
//Date: 2012 01 28
//Dependancies:
//-----------------------------------------------------------------------------
//DISCRIPTION:A latch for the 12 bits of data that matter
//-----------------------------------------------------------------------------
module DATA_LATCH
(
	input					CLK,
	input					ENA_N,
	input			[11:0]	INPUT,
	output reg		[11:0]	OUTPUT
);

always@(posedge CLK)
	if(~ENA_N)
		OUTPUT = INPUT;
	else
		OUTPUT = OUTPUT;
endmodule
