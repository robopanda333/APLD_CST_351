library verilog;
use verilog.vl_types.all;
entity ClkDiv is
    generic(
        scan_val        : integer := 25000;
        pwm_val         : integer := 5000000;
        baud_val        : integer := 163
    );
    port(
        clk_50mhz       : in     vl_logic;
        Scan_clk        : out    vl_logic;
        pwm_clk         : out    vl_logic;
        Baud_clk        : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of scan_val : constant is 1;
    attribute mti_svvh_generic_type of pwm_val : constant is 1;
    attribute mti_svvh_generic_type of baud_val : constant is 1;
end ClkDiv;
