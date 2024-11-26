### A working Interpreter (with tracer) in eight functions/procedures and the main!  ###

1 procedure Error(const Msg: string);   
2 procedure SetLabelAddr(const Name: string; Addr: Byte);   
3 function  GetLabelAddr(const Name: string): Byte;   
4 function  GetVal(const Index: Byte): Integer;   
5 procedure Let(n: byte);   
6 procedure ExecuteMe;   
7 procedure LoadProgram;   
8 procedure PrintState;   
9 main   
    
Keywords: if, jmp, prn, ret, + TRC (means TRACE)  
Math  Operators: + (add) ! (neg)  
Logic Operators: < (less) = (equ) 

Bitsy uses Built-in Variables.  
  
  
compile it with freepascal: 
### fpc atto.pas ###   
  
type: 
### Bitsy.exe < FIBO > FIBO.OUT ###    
  
analise the content of FIBO.OUT 

The sample files:

FACT
ASCII
MULT
MATH
RAND
LOOP

 

-------------------------------------------
![](bitsy_Logo_d.png)
