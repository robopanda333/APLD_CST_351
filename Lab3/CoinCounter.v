

//all inputs to this are sync'd save reset only.
//runs on neg edge
module CoinCounter
(
input				clk,
input				reset,
input				nickel,
input				dime,
input				quarter,
input				dollar,
input				down_5,
input				down_10,
input				down_25,
output reg [5:0]	coinCount
);

always@ (negedge clk or posedge reset)
begin
if(reset)
	coinCount = 6'h0;
else
begin
	casex({down_25, down_10, down_5, dollar, quarter, dime, nickel})
	7'b1XXXXXX:coinCount = coinCount - 6'h5;
	7'b01XXXXX:coinCount = coinCount - 6'h2;
	7'b001XXXX:coinCount = coinCount - 6'h1;
	7'b0001XXX:coinCount = coinCount + 6'd20;
	7'b00001XX:coinCount = coinCount + 6'h5;
	7'b000001X:coinCount = coinCount + 6'h2;
	7'b0000001:coinCount = coinCount + 6'h1;
	default:coinCount = coinCount;
	endcase
end
end
endmodule
