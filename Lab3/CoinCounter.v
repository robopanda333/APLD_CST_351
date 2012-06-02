

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
input				down,
output reg [5:0]	coinCount
);

always@ (negedge clk or posedge reset)
begin
if(reset)
	coinCount = 0;
else
begin
	casex({down, dollar, quarter, dime, nickel})
	5'b1XXXX:coinCount = coinCount - 1;
	5'b01XXX:coinCount = coinCount + 20;
	5'b001XX:coinCount = coinCount + 5;
	5'b0001X:coinCount = coinCount + 2;
	5'b00001:coinCount = coinCount + 1;
	default:coinCount = coinCount;
	endcase
end
end
endmodule
