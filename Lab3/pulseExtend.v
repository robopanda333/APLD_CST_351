
module pulseExtend(
input clk,
input in,
output out
);
reg [2:0] temp;

always@(posedge clk)
begin
	if (in)
	temp = {3{in}};
	else
	temp = {temp[1:0], in};
end
assign out = temp[2];
endmodule