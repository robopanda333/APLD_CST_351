//-----------------------------------------------------------------------------
//University: OIT - CSET
//Class: CST 231
//Lab:Lab 1
//Project: Multiplexed Display
//
//Author: Kehnin Dyer
//Date: 2012 02 01
//Dependancies:
//-----------------------------------------------------------------------------
//DISCRIPTION:it counts. it encodes. what more do you want?
//-----------------------------------------------------------------------------

module PRIORITY_N_COUNTER
(
	input				CLK,
	output	reg	[1:0]	COUNT,
	output	reg	[3:0]	OUTPUT
);
always@(posedge CLK)
	COUNT = (COUNT + 1'b1);

always@(COUNT)
	case(COUNT)
		2'b00: OUTPUT = 4'b1000;
		2'b01: OUTPUT = 4'b0100;
		2'b10: OUTPUT = 4'b0010;
		2'b11: OUTPUT = 4'b0001;
	endcase

endmodule 
