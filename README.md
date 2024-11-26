### A working Interpreter (with tracer) in eight functions/procedures!  ###

1 procedure Error(const Msg: string);   
2 procedure SetLabelAddr(const Name: string; Addr: Byte);   
3 function  GetLabelAddr(const Name: string): Byte;   
4 function  GetVal(const Index: Byte): Integer;   
5 procedure Let(n: byte);   
6 procedure ExecuteMe;   
7 procedure LoadProgram;   
8 procedure PrintState;   
    
Keywords: if, jmp, prn, ret, + TRC (means TRACE)  
Math  Operators: + (add) ! (neg)  
Logic Operators: < (less) = (equ) 

Bitsy uses Built-in Variables.   
The Var IDs: B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q, R, S,T,U,V,W,X,Y,Z  
B..Q - 32 bit signed integers.    
R    - RANDOM number gererator (r/w)        
S..Z - 8 bit ASCII codes.    
    
compile it with freepascal: 
### fpc atto.pas ###   
  
type: 
### Bitsy.exe < FIBO > FIBO.OUT ###    
  
analise the content of FIBO.OUT 

The sample files:  

FIBO  
FACT 
ASCII  
MULT  
MATH  
RAND  
LOOP  

-------------------------------------------
![](bitsy_Logo_d.png)
