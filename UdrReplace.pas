unit UdrReplace;

(*
-- TEST SQL  --

create function replace(
  input varchar(400),
  find varchar(400),
  replace varchar(400)
) returns varchar(400)
external name 'udrtest!replace'
engine udr;

select replace('12345', '3', 'ccc') from rdb$database rd;
=> 12ccc45
*)

interface

uses Firebird;

type
  ReplaceInMessage = record
    Input: record
      Length: Word;
      Value: array [0 .. 399] of AnsiChar;
    end;
    InputNull: WordBool;
    Find: record
      Length: Word;
      Value: array [0 .. 399] of AnsiChar;
    end;
    FindNull: WordBool;
    Replace: record
      Length: Word;
      Value: array [0 .. 399] of AnsiChar;
    end;
    ReplaceNull: WordBool;
  end;

  ReplaceInMessagePtr = ^ReplaceInMessage;

  ReplaceOutMessage = record
    Result: record
      Length: Word;
      Value: array [0 .. 399] of AnsiChar;
    end;
    ResultNull: WordBool;
  end;

  ReplaceOutMessagePtr = ^ReplaceOutMessage;

  ReplaceFunction = class(IExternalFunctionImpl)
    procedure dispose(); override;

    procedure getCharSet(status: iStatus; context: iExternalContext;
      Name: pansichar; nameSize: cardinal); override;

    procedure Execute(status: iStatus; context: iExternalContext;
      inMsg: Pointer; outMsg: Pointer); override;
  end;

implementation

uses SysUtils;

procedure ReplaceFunction.dispose();
begin
  Destroy;
end;

procedure ReplaceFunction.getCharSet(status: iStatus; context: iExternalContext;
  Name: pansichar; nameSize: cardinal);
begin
end;

procedure ReplaceFunction.Execute(status: iStatus; context: iExternalContext;
  inMsg: Pointer; outMsg: Pointer);
var
  xInput: ReplaceInMessagePtr;
  xOutput: ReplaceOutMessagePtr;
  value: string;
begin
  xInput := ReplaceInMessagePtr(inMsg);
  xOutput := ReplaceOutMessagePtr(outMsg);

  xOutput^.ResultNull := xInput^.InputNull;
  if not xOutput^.ResultNull then
  begin
    value := StringReplace(xInput^.Input.Value, xInput^.Find.Value, xInput^.Replace.Value, [rfReplaceAll]);
    xOutput^.Result.Length := Length(value);
    Move(value[1], xOutput^.Result.Value[0], Length(value));
  end;
end;

end.
