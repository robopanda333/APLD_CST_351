library verilog;
use verilog.vl_types.all;
entity Math is
    generic(
        Add             : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        Sub             : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        NotA            : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        NotB            : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        \And\           : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        \Or\            : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1);
        \Xor\           : vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi0);
        \Xnor\          : vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi1)
    );
    port(
        A               : in     vl_logic_vector(3 downto 0);
        B               : in     vl_logic_vector(3 downto 0);
        op              : in     vl_logic_vector(2 downto 0);
        result          : out    vl_logic_vector(3 downto 0);
        carry           : out    vl_logic;
        borrow          : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Add : constant is 1;
    attribute mti_svvh_generic_type of Sub : constant is 1;
    attribute mti_svvh_generic_type of NotA : constant is 1;
    attribute mti_svvh_generic_type of NotB : constant is 1;
    attribute mti_svvh_generic_type of \And\ : constant is 1;
    attribute mti_svvh_generic_type of \Or\ : constant is 1;
    attribute mti_svvh_generic_type of \Xor\ : constant is 1;
    attribute mti_svvh_generic_type of \Xnor\ : constant is 1;
end Math;
