//-----------------------------------------------------------------------------
//University: OIT - CSET
//Class: CST 231
//Lab:Lab 5
//Project: keypad controller
//
//Author: Kehnin Dyer
//Date: 2012 03 15
//Dependancies: none
//-----------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------

module KP_sMachine(
	input		clk,
	input		en,
	output	reg	load,
	output 	reg	latch
);
parameter	s_SCAN = 0,
			s_PRESSED = 1,
			s_RELEASED = 2,
			s_DEBOUNCE = 3;


reg	[1:0] count;
reg	[1:0] state;

always@ (posedge clk)
begin
	case(state)
		s_SCAN:
		begin
			count = 0;
			if(en)
				state = s_SCAN;
			else
				state = s_PRESSED;
		end
		s_DEBOUNCE:
		begin
			if (count == 3)
			begin
				count = 0;
				state = s_PRESSED;
			end
			else
			begin
				count = count + 2'b1;
				state = state;
			end
		end			
		s_PRESSED:
		begin
			count = 0;
			if(!en)
				state = s_PRESSED;
			else
				state = s_RELEASED;
		end
		s_RELEASED:
		begin
			count = 0;
			state = s_SCAN;
		end
		default:
		begin
			count = 0;
			state = s_SCAN;
		end
	endcase
	latch = (state == s_PRESSED);
	load = (state == s_RELEASED);
end
endmodule

