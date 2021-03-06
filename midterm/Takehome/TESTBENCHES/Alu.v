

/*
opcodes
0 : Add
1 : Subtract
2 : Invert A
3 : Invert B
4 : A & B
5 : A | B
6 : A ^ B
7 : ~(A ^ B)
*/



module Alu(
input   [2:0]   Opcode,
input   [3:0]   Data,
input           GO,
input           clk,
input           reset,
output  [3:0]   Result,
output          cout,
output          borrow,
output          led_idle,
output          led_wait,
output          led_rdy,
output          led_done
);
wire    [3:0]   A,
                B;
wire    [2:0]   op;
wire            enA,
                enB,
                enOp;

datalatch       Alatch(clk, reset, enA,  Data, A);
datalatch       Blatch(clk, reset, enB,  Data, B);
datalatch       opCode(clk, reset, enOp, Opcode, op);
Math        math(A, B, op, Result, cout, borrow);
Controller  cnt(clk, reset, GO, enA, enB, enOp, led_idle, led_wait, led_rdy, led_done);
endmodule



module Math(
input       [3:0]   A,
input       [3:0]   B,
input       [2:0]   op,
output  reg [3:0]   result,
output  reg         carry,
output  reg         borrow
);
parameter   Add     = 3'h0,
            Sub     = 3'h1,
            NotA    = 3'h2,
            NotB    = 3'h3,
            And     = 3'h4,
            Or      = 3'h5,
            Xor     = 3'h6,
            Xnor    = 3'h7;
always@ (*)
begin
    case(op)
    Add:
    begin
        {carry, result} = A + B;
        borrow = 0;
    end
    Sub:
    begin
        {borrow, result} = A - B;
        carry = 0;
    end
    NotA:
    begin
        result = ~A;
        {carry, borrow} = 0;
    end
    NotB:
    begin
        result = ~B;
        {carry, borrow} = 0;
    end
    And:
    begin
        result = A & B;
        {carry, borrow} = 0;
    end
    Or:
    begin
        result = A | B;
        {carry, borrow} = 0;
    end
    Xor:
    begin
        result = A ^ B;
        {carry, borrow} = 0;
    end
    Xnor:
    begin
        result = ~ A ^ B;
        {carry, borrow} = 0;
    end
    endcase
end
endmodule




module Controller(
input       clk,
input       rst,
input       go,
output  reg enA,
output  reg enB,
output  reg enOp,
output  reg led_idle,
output  reg led_wait,
output  reg led_rdy,
output  reg led_done
);
parameter   s_Reset     = 3'h0,
            s_Ready     = 3'h1,
            s_LatchA    = 3'h2,
            s_LatchB    = 3'h3,
            s_Work      = 3'h4,
            s_Done      = 3'h5;
parameter   o_Reset     = 7'b0001000,//{enA,enB,enOp,led_idle,led_wait,led_rdy,led_done}
            o_Ready     = 7'b0000010,
            o_LatchA    = 7'b1000100,
            o_LatchB    = 7'b0110000,
            o_Work      = 7'b0000000,
            o_Done      = 7'b0000001;
reg [2:0]   state;
always@ (posedge clk or posedge rst)
begin
    if(rst)
        state = s_Reset;
    else
    case(state)
    s_Reset:
        state = s_Ready;
    s_Ready:
        if(go)
            state = s_LatchA;
        else
            state = state;
    s_LatchA:
        if(go)
            state = state;
        else
            state = s_LatchB;
    s_LatchB:
        state = s_Work;
    s_Work:
        state = s_Done;
    s_Done:
        state = s_Ready;
    default:
        state = s_Reset;
    endcase
end
always@ (*)
    case(state)
    s_Reset: {enA,enB,enOp,led_idle,led_wait,led_rdy,led_done} = o_Reset;
    s_Ready: {enA,enB,enOp,led_idle,led_wait,led_rdy,led_done} = o_Ready;
    s_LatchA:{enA,enB,enOp,led_idle,led_wait,led_rdy,led_done} = o_LatchA;
    s_LatchB:{enA,enB,enOp,led_idle,led_wait,led_rdy,led_done} = o_LatchB;
    s_Work:  {enA,enB,enOp,led_idle,led_wait,led_rdy,led_done} = o_Work;
    s_Done:  {enA,enB,enOp,led_idle,led_wait,led_rdy,led_done} = o_Done;
    default: {enA,enB,enOp,led_idle,led_wait,led_rdy,led_done} = o_Reset;
    endcase
endmodule


module datalatch(
input               clk,
input               rst,
input               en,
input       [3:0]   d,
output  reg [3:0]   q
);
always@(posedge ~clk or posedge rst)
begin
    if(rst)
        q = 0;
    else
        if(en)
            q = d;
        else
            q = q;
end
endmodule


