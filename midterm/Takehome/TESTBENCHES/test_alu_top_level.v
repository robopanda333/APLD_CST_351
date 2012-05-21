

`timescale 10ns / 100ps

module test_alu_top_level;

reg     [2:0]   opcode;
reg     [3:0]   data;
reg             go;
reg             clk;
reg             rst;
wire    [3:0]   result;
wire            cout;
wire            borrow;
wire            led_idle;
wire            led_wait;
wire            led_rdy;
wire            led_done;

integer i;
integer j;
reg [3:0] A;
reg [3:0] B;

Alu dut(opcode, data, go, clk, rst, result, cout, borrow, led_idle, led_wait, led_rdy, led_done);
    always #10 clk = ~clk;

    always@ (posedge led_rdy)
        $display("opcode:%o \nA:%h B:%h result:%h", opcode, A, B, result);

    initial
    begin
    A = 0;
    B = 0;
    i = 0;
    j = 0;
    clk = 0;
    opcode = 0;
    data = 0;
    go = 0;
    rst = 0;
    #10;
    rst = 1;
    wait(led_idle == 1);
    rst = 0;

    //test Add
    opcode = 0;
    for(i = 0; i < 15; i = i + 1)
    begin
    for(j = 0; j < 15; j = j + 1)
    begin
        #20;
        A = i;
        data = i;
        #20;
        go = 1;
        #10 wait(led_wait);
        #10;
        B = j;
        data = j;
        go = 0;
        #10 wait(led_rdy);
    end
    end
    //test Sub
    opcode = 1;
    for(i = 0; i < 15; i = i + 1)
    begin
    for(j = 0; j < 15; j = j + 1)
    begin
        #10;
        data = i;
        #10;
        go = 1;
        wait(led_wait);
        data = j;
        go = 0;
        wait(~led_wait);
        wait(led_done);
        wait(led_rdy);
    end
    end
    //test the rest of the opcodes
    opcode = 1;
    for(opcode = 1; opcode > 0; opcode = opcode + 1)
    begin
    #10;
    $display("opcode",opcode);
    for(i = 0; i < 15; i = i + 1)
    begin
    for(j = 0; j < 15; j = j + 1)
    begin
        #10;
        data = i;
        #10;
        go = 1;
        wait(led_wait);
        data = j;
        go = 0;
        wait(~led_wait);
        wait(led_done);
        wait(led_rdy);
    end
    end
    end

    $stop;
    end
endmodule
            
    
    
    
