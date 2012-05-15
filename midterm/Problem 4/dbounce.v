

module dbounce(
input wire clk,
input wire rst,
input wire	sw_in,
output wire sw_out
);

reg [5:0] shift;

assign sw_out = &{shift[4:0]};
always@ (posedge clk)
begin
	shift = {shift[4:0],sw_in};
end

endmodule
