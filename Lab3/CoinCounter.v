

//all inputs to this are sync'd save reset only.
//runs on neg edge
module CoinCounter
(
input				clk,
input				reset,
input				nickel,
input				dime,
input				quarter,
input				down,
output reg [5:0]	coinCount
);

always@ (negedge clk or posedge reset)
begin
if(reset)
	coinCount = 0;
else
begin
	
end
end
endmodule
