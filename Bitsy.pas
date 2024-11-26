program bitsy; //  Usage: bitsy.exe < script.in > script.out

                         {KeyWords: IF, JMP, RET, PRN.  Built-in Vars: 'B'..'Z' }
uses SysUtils, StrUtils; 
type
  TLabel = record
    Name: string;
    Addr: Byte;
  end;

var
  Code    : array of string;
  Tok     : TStringArray;               // Tokens buffer 
  Labels  : array of TLabel;
  Vars    : array['B'..'Z'] of LongInt; // built-in Vars. Without "A" for compatibility, 
  LineNum : Byte = 0;                   // "A" is reserved for ARRAY
  Stack   : Byte = 0;                   // PSEUDO stack for RET-urn
  Trace   : Boolean = False;
  i       : Integer;
  Counter : LongInt = 0; 
  
procedure PrintState;
begin
  Writeln(Chr(10), '----------- (',counter,' lines done) Code:');
  for i := 1 to High(Code) do Writeln(i, '  ', Code[i]);
  Writeln(Chr(10), '----------- Variables (B..R, S..Z):');
  for i := 1 to 25 do Writeln(Chr(i + 65), ' ', Vars[Chr(i + 65)]);
end;
  
procedure Error(const Msg: string);
begin
  Writeln('ERROR: ', Msg, Chr(10), code[lineNum-1]);
  if Trace then PrintState;
  Halt;
end;

procedure SetLabelAddr(const Name: string; Addr: Byte);
begin
  for i := 0 to High(Labels) do
    if Labels[i].Name = Name then Error('Label ' + Name + ' already exists.');
  SetLength(Labels, Length(Labels) + 1);
  Labels[High(Labels)].Name := Name;
  Labels[High(Labels)].Addr := Addr;
end;

function GetLabelAddr(const Name: string): Byte;
begin
  GetLabelAddr := 0;
  for i:= 0 to High(Labels) do if Labels[i].Name= Name then Exit(Labels[i].Addr);
  Error('Label "'+Name+'" missing');
end;

function GetVal(const Index: Byte): LongInt;
begin
  case Tok[Index][1] of
    'B'..'Q': GetVal := Vars[Tok[Index][1]];
    'R'     : GetVal := Random(Vars['R']+1);
    'S'..'Z': Getval := Byte(Vars[Tok[Index][1]]);
  else
    GetVal := StrToInt(Tok[Index]);
  end;
end;

procedure Let(n: byte);
begin
  if not (Tok[n][1] in ['B'..'Z']) then Error('invalid var ID: '+Tok[n]);
  if Tok[n+1][1] = '!' then Vars[Tok[n][1]]:= not Vars[Tok[n][1]] // One's complement
  else  
  case Length(Tok)-1 of
    2, 6: Vars[Tok[n][1]]:= GetVal(Length(Tok)-1);
    4, 8:begin
          case Tok[Length(Tok)-2][1] of
            '+': Vars[Tok[n][1]]:= GetVal(Length(Tok)-3) + GetVal(Length(Tok)-1);   
//          '-': Vars[Tok[n][1]]:= GetVal(Length(Tok)-3) - GetVal(Length(Tok)-1);
// .. You can expand if You want
          end;
         end;
  else Error('in expression');
  end;
end;

procedure ExecuteMe;
begin
  LineNum:= 1;      
  while LineNum < length(Code) do
  begin
    Tok:= SplitString(Code[LineNum],' ');    
    Inc(LineNum);  
    if Tok[0][1]='.' then continue;
    case Tok[0] of  
      'IF': begin
             if (Tok[2][1] = '<') and (GetVal(1) < GetVal(3)) or
                (Tok[2][1] = '=') and (GetVal(1) = GetVal(3)) then
                case Tok[4] of
                 'JMP': begin Stack:= linenum;  LineNum:= GetLabelAddr(Tok[5]); end;
                 'PRN': if (Tok[5][1]in ['B'..'R']) then Write(Vars[Tok[5][1]]) else
                          Write(Chr(Vars[Tok[5][1]]));
                else Let(4);
                end; // case
             end;
      'JMP': begin Stack:= linenum;  LineNum:= GetLabelAddr(Tok[1]); end;
      'RET': if (Stack <> 0) then LineNum:= Stack else Error('No way to RETURN');              
      'PRN': if (Tok[1][1]in ['B'..'R']) then Write(Vars[Tok[1][1]]) else
               Write(Chr(Vars[Tok[1][1]]));
    else Let(0);
    end; // case
    if (counter < 999999) then inc(counter) else Error ('infinit loop?'); 
  end; // while
end;

procedure LoadProgram;
var
  Line: string;
begin
  Randomize;
  Vars['R'] := 99; {RND}  Vars['S'] := 32; {space}  Vars['T'] := 10; {NewLine PreSET}
  SetLength(Code,0);   
  SetLength(Labels,0);

  while not Eof(Input) do
  begin
    ReadLn(Line);
    Line := UpCase(Trim(Copy(Line, 1, Pos(';', Line+';')-1))); // Remove comments    
    if (line = '') then continue;  
    if (line = 'TRC') then trace := true
    else
    begin
      if (Line[1] = '.') then SetLabelAddr(Line, LineNum+1); 
      Inc(LineNum);
      SetLength(Code, LineNum+1);
      Code[LineNum] := Line;
    end;
  end;
end;

begin
  LoadProgram;
  ExecuteMe;
  if Trace then PrintState;
end.
