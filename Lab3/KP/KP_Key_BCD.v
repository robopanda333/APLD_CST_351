//-----------------------------------------------------------------------------
//University: OIT - CSET
//Class: CST 231
//Lab:Lab 5
//Project: keypad controller
//
//Author: Kehnin Dyer
//Date: 2012 05 03
//Dependancies: none
//-----------------------------------------------------------------------------
//DISCRIPTION:
//
//-----------------------------------------------------------------------------


module KP_Key_BCD(
input				clk,
input				valid,
input		[3:0]	d,
output	reg	[5:0]	Ascii,
output	reg			Ascii_valid
);

parameter	s_first = 0,
			s_second = 1,
			s_back = 2;

reg	[1:0]	state;
always@ (negedge clk)
begin
	case(state)
	s_first:
		begin
			if(d == 4'h7 && valid)
				state = s_second;
			else
				state = state;
		end //got to second if key = 7, and valid
	s_second:
		begin
		case({(d == 4'h7),valid})
		2'b11:
			state = state;
		2'b01:
			state = s_back;
		default:
			state = state;
		endcase
		end
	s_back:
		begin
		case({(d == 4'h7),valid})
		2'b11:
			state = s_second;
		2'b01:
			state = s_first;
		default:
			state = state;
		endcase
		end
	default:
		begin
			state = s_first;
		end
	endcase
end

always@ (posedge clk)
begin
	case(state)
	s_first:
		case(d)
			0:{Ascii_valid,Ascii} = {valid,5'h0f}; // clear
			1:{Ascii_valid,Ascii} = {valid,5'h00}; // J - 0
			4:{Ascii_valid,Ascii} = {valid,5'h07}; // G - 7
			5:{Ascii_valid,Ascii} = {valid,5'h08}; // H - 8
			6:{Ascii_valid,Ascii} = {valid,5'h09}; // I - 9
			8:{Ascii_valid,Ascii} = {valid,5'h04}; // D - 4
			9:{Ascii_valid,Ascii} = {valid,5'h05}; // E - 5
			10:{Ascii_valid,Ascii} = {valid,5'h06};// F - 6
			12:{Ascii_valid,Ascii} = {valid,5'h01};// A - 1
			13:{Ascii_valid,Ascii} = {valid,5'h02};// B - 2
			14:{Ascii_valid,Ascii} = {valid,5'h03};// C - 3
			default:{Ascii_valid,Ascii} = {6'h000};
		endcase
	default:
		case(d)
			0:{Ascii_valid,Ascii} = {valid,5'h1f}; // clear
			1:{Ascii_valid,Ascii} = {valid,5'h10}; // J - 0
			4:{Ascii_valid,Ascii} = {valid,5'h17}; // G - 7
			5:{Ascii_valid,Ascii} = {valid,5'h18}; // H - 8
			6:{Ascii_valid,Ascii} = {valid,5'h19}; // I - 9
			8:{Ascii_valid,Ascii} = {valid,5'h14}; // D - 4
			9:{Ascii_valid,Ascii} = {valid,5'h15}; // E - 5
			10:{Ascii_valid,Ascii} = {valid,5'h16};// F - 6
			12:{Ascii_valid,Ascii} = {valid,5'h11};// A - 1
			13:{Ascii_valid,Ascii} = {valid,5'h12};// B - 2
			14:{Ascii_valid,Ascii} = {valid,5'h13};// C - 3
			default:{Ascii_valid,Ascii} = {6'h000};
		endcase
	endcase
end

endmodule

