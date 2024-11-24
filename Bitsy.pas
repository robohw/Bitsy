program bitsy; // 2024.11.24

uses SysUtils, StrUtils; 
type
  TLabel = record
    Name: string;
    Addr: Byte;
  end;

var
  Code    : array of string;
  Tokens  : TStringArray;
  Labels  : array of TLabel;
  Vars    : array['B'..'Z'] of LongInt;
  LineNum : byte = 0;
  Stack   : byte = 0;                  // PSEUDO stack for RET-urn
  Trace   : Boolean = False;
  i       : integer;
  
procedure PrintState;
begin
  Writeln;
  Writeln('----------- Code:');
  for i := 1 to High(Code) do Writeln(i, '  ', Code[i]);
  Writeln;
  Writeln('----------- Variables (B..R, S..Z):');
  for i := 1 to 25 do Writeln(Chr(i + 65), ' ', Vars[Chr(i + 65)]);
end;
  
procedure Error(const Msg: string);
begin
  Writeln('ERROR: ', Msg);
  Writeln(code[lineNum-1]);
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
  for i := 0 to High(Labels) do if Labels[i].Name = Name then Exit(Labels[i].Addr);
end;

function GetVal(const Index: Byte): Integer;
begin
  case Tokens[Index][1] of
    'B'..'Q': GetVal := Vars[Tokens[Index][1]];
    'R': GetVal := Random(Vars['R']+1);
    'S'..'Z': Getval := Byte(Vars[Tokens[Index][1]]);
  else
    GetVal := StrToInt(Tokens[Index]);
  end;
end;

procedure Let(n: byte);
begin
  if not (Tokens[n][1] in ['B'..'Z']) then Error('invalid var ID: '+Tokens[n])
  else  
  case Length(Tokens)-1 of
    2, 6: Vars[Tokens[n][1]] := GetVal(Length(Tokens)-1);
    4, 8:begin
          case Tokens[Length(Tokens) - 2][1] of
            '+': Vars[Tokens[n][1]]:= GetVal(Length(Tokens)-3) + GetVal(Length(Tokens)-1);   
            '-': Vars[Tokens[n][1]]:= GetVal(Length(Tokens)-3) - GetVal(Length(Tokens)-1);
            '*': Vars[Tokens[n][1]]:= GetVal(Length(Tokens)-3) * GetVal(Length(Tokens)-1);
            '/': Vars[Tokens[n][1]]:= GetVal(Length(Tokens)-3) DIV GetVal(Length(Tokens)-1);
            '%': Vars[Tokens[n][1]]:= GetVal(Length(Tokens)-3) MOD GetVal(Length(Tokens)-1);
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
    Tokens:= SplitString(Code[LineNum],' ');    
    Inc(LineNum);  
    if Tokens[0][1]='.' then continue;
    case Tokens[0] of  
      'IF': begin
             if (Tokens[2][1] = '<') and (GetVal(1) < GetVal(3)) or
                (Tokens[2][1] = '=') and (GetVal(1) = GetVal(3)) then
                case Tokens[4] of
                 'JMP': begin Stack := linenum; LineNum := GetLabelAddr(Tokens[5]); end;
                 'PRN': if (Tokens[5][1]in ['B'..'R']) then Write(Vars[Tokens[5][1]]) else
                          Write(Chr(Vars[Tokens[5][1]]));
                else Let(4);
                end; // case
             end;
      'JMP': begin Stack := linenum; LineNum := GetLabelAddr(Tokens[1]); end;
      'RET': if (Stack <> 0) then LineNum:= Stack else Error('No way to RETURN');              
      'PRN': if (Tokens[1][1]in ['B'..'R']) then Write(Vars[Tokens[1][1]]) else
               Write(Chr(Vars[Tokens[1][1]]));
    else Let(0);
    end; // case
  end; // while
end;

procedure LoadProgram;
var
  Line: string;
begin
  Randomize;
  Vars['R'] := 99;  Vars['S'] := 32;  Vars['T'] := 10;
  SetLength(Code,0);   
  SetLength(Labels,0);

  while not Eof(Input) do
  begin
    ReadLn(Line);
    Line := UpCase(Trim(Copy(Line, 1, Pos(';', Line + ';') - 1))); // Remove comments    
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
