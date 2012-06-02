/******************************************************************************
Kehnin Dyer
Homework 3: Clock Divider
Date: 5/29/2012
******************************************************************************/

module ClkDiv
(
(* chip_pin = "J6" *)	input		clk_50mhz,
(* chip_pin = "M18" *)	output	reg	Scan_clk,	//  .002 %error
(* chip_pin = "K18" *)	output	reg	pwm_clk,	// 0     %error
(* chip_pin = "H18" *)	output	reg	Baud_clk	// 1.107 %error
);

reg	[14:0]	counter_scan;
parameter	scan_val	= 25000;
assign		scan_en		= (counter_scan >= scan_val);

reg	[22:0]	counter_pwm;
parameter	pwm_val		= 5000000;
assign		pwm_en		= (counter_pwm >= pwm_val);

reg	[8:0]	counter_baud;
parameter	baud_val	= 163;
assign		baud_en		= (counter_baud >= baud_val);


always@ (posedge clk_50mhz)
begin
	if(scan_en)
		counter_scan = 0;
	else
		counter_scan = counter_scan + 1;

	if(pwm_en)
		counter_pwm = 0;
	else
		counter_pwm = counter_pwm + 1;

	if(baud_en)
		counter_baud = 0;
	else
		counter_baud = counter_baud + 1;
end

always@ (posedge clk_50mhz)
begin
	if(scan_en)
		Scan_clk = ~Scan_clk;
	else
		Scan_clk = Scan_clk;

	if(pwm_en)
		pwm_clk = ~pwm_clk;
	else
		pwm_clk = pwm_clk;

	if(baud_en)
		Baud_clk = ~Baud_clk;
	else
		Baud_clk = Baud_clk;
end



initial
begin
Scan_clk = 0;
pwm_clk = 0;
Baud_clk = 0;	
end

endmodule
