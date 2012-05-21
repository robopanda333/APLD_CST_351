library verilog;
use verilog.vl_types.all;
entity Alu is
    port(
        Opcode          : in     vl_logic_vector(2 downto 0);
        Data            : in     vl_logic_vector(3 downto 0);
        GO              : in     vl_logic;
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        Result          : out    vl_logic_vector(3 downto 0);
        cout            : out    vl_logic;
        borrow          : out    vl_logic;
        led_idle        : out    vl_logic;
        led_wait        : out    vl_logic;
        led_rdy         : out    vl_logic;
        led_done        : out    vl_logic
    );
end Alu;
