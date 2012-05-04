
module Controller(
input				clk,
output	reg	[7:0]	Data,
output	reg			Data_rdy,
input				transEna,
input			[7:0]	Ascii,
input				Ascii_Rdy
);

////////////////////////////////////////////////////////////////////////////
//rom
////////////////////////////////////////////////////////////////////////////
reg [7:0] mem [0:31];
initial
begin
	$readmemh("ROM.txt", mem);
end

parameter	s_idle		= 0,
			s_sendData	= 1,
			s_waitInt	= 2,
			s_Keypad_idle		= 3,
			s_Keypad_send		= 4,
			s_Keypad_wait		= 5;
reg	[3:0]	state;
reg	[4:0]	address;

always@ (negedge clk)
begin
	case(state)
	s_idle:
		begin
			state = s_sendData;
			address = 0;
		end
	s_sendData:
		begin
			state = s_waitInt;
			address = address;
		end
	s_waitInt:
		begin
			if(transEna)
			begin
				if(address == 5'd23)
				begin
					state = s_Keypad;
					address = address;
				end
				else
				begin
					state = s_sendData;
					address = address + 1;
				end
			end
			else
			begin
				state = state;
				address = address;
			end
		end
	s_Keypad_idle:
		begin
			address = address;
			
			case({Ascii_Rdy, transEna})
			2'b11:
				state = s_Keypad_send;
			default:
				state = state;
			endcase
		end
	s_Keypad_send:
		begin
			address = address;
			state = s_Keypad_wait;
		end
	s_Keypad_wait:
		begin
			address = address;
			if(transEna)
				if(!|Ascii)
					state = s_idle;
				else
					state = s_Keypad_idle;
			else
				state = state;
		end
	default:
		begin
			state = s_idle;
			address = 0;
		end
	endcase
end


always@ (*)
begin
	case(state)
	s_idle:
		begin
			Data		= mem[address];
			Data_rdy	= 0;
		end
	s_sendData:
		begin
			Data		= mem[address];
			Data_rdy	= 1;
		end
	s_waitInt:
		begin
			Data		= mem[address];
			Data_rdy	= 0;
		end
	s_Keypad_idle:
		begin
			Data		= Ascii;
			Data_rdy	= 0;
		end
	s_Keypad_send:
		begin
			Data		= Ascii;
			Data_rdy	= 1;
		end
	s_Keypad_wait:
		begin
			Data		= Ascii;
			Data_rdy	= 0;
		end
	default:
		begin
			Data		= mem[address];
			Data_rdy	= 0;
		end
	endcase
end
endmodule

