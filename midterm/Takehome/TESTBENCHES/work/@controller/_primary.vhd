library verilog;
use verilog.vl_types.all;
entity Controller is
    generic(
        s_Reset         : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        s_Ready         : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        s_LatchA        : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        s_LatchB        : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        s_Work          : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        s_Done          : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1);
        o_Reset         : vl_logic_vector(0 to 6) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0);
        o_Ready         : vl_logic_vector(0 to 6) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0);
        o_LatchA        : vl_logic_vector(0 to 6) := (Hi1, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0);
        o_LatchB        : vl_logic_vector(0 to 6) := (Hi0, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0);
        o_Work          : vl_logic_vector(0 to 6) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        o_Done          : vl_logic_vector(0 to 6) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1)
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        go              : in     vl_logic;
        enA             : out    vl_logic;
        enB             : out    vl_logic;
        enOp            : out    vl_logic;
        led_idle        : out    vl_logic;
        led_wait        : out    vl_logic;
        led_rdy         : out    vl_logic;
        led_done        : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of s_Reset : constant is 1;
    attribute mti_svvh_generic_type of s_Ready : constant is 1;
    attribute mti_svvh_generic_type of s_LatchA : constant is 1;
    attribute mti_svvh_generic_type of s_LatchB : constant is 1;
    attribute mti_svvh_generic_type of s_Work : constant is 1;
    attribute mti_svvh_generic_type of s_Done : constant is 1;
    attribute mti_svvh_generic_type of o_Reset : constant is 1;
    attribute mti_svvh_generic_type of o_Ready : constant is 1;
    attribute mti_svvh_generic_type of o_LatchA : constant is 1;
    attribute mti_svvh_generic_type of o_LatchB : constant is 1;
    attribute mti_svvh_generic_type of o_Work : constant is 1;
    attribute mti_svvh_generic_type of o_Done : constant is 1;
end Controller;
