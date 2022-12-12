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
  TVarChar400 = record
    Length: Word;
    Value: array [0 .. 399] of AnsiChar;
    Null: WordBool;
  end;
  ReplaceInMessage = record
    Value: TVarChar400;
    Find: TVarChar400;
    Replace: TVarChar400;
  end;
  ReplaceInMessagePtr = ^ReplaceInMessage;

  ReplaceOutMessage = record
    Result: TVarChar400;
  end;
  ReplaceOutMessagePtr = ^ReplaceOutMessage;

  ReplaceFunction = class(IExternalFunctionImpl)
    procedure dispose(); override;

    procedure getCharSet(status: iStatus; context: iExternalContext;
      Name: pansichar; nameSize: cardinal); override;

    procedure Execute(status: iStatus; context: iExternalContext;
      inMsg: Pointer; outMsg: Pointer); override;
  end;

  ReplaceFactory = class(IUdrFunctionFactoryImpl)
    procedure dispose(); override;

    procedure setup(status: iStatus; context: iExternalContext;
      metadata: iRoutineMetadata; inBuilder: iMetadataBuilder;
      outBuilder: iMetadataBuilder); override;

    function newItem(status: iStatus; context: iExternalContext;
      metadata: iRoutineMetadata): IExternalFunction; override;
  end;

implementation

uses SysUtils;

procedure log(const message: string);
var f: text;
begin
  AssignFile(f, 'c:\ccare\udr.log');
  Append(f);
  Writeln(f, message);
  Close(f);
end;

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

  xOutput^.Result.Null := xInput^.Value.Null;
  if not xOutput^.Result.Null then
  begin
    value := StringReplace(xInput^.Value.Value, xInput^.Find.Value, xInput^.Replace.Value, [rfReplaceAll]);
    xOutput^.Result.Length := Length(value);
    Move(value[1], xOutput^.Result.Value[0], Length(value));
  end;
end;


procedure ReplaceFactory.dispose();
begin
  Destroy;
end;

procedure ReplaceFactory.setup(status: iStatus; context: iExternalContext;
  metadata: iRoutineMetadata; inBuilder: iMetadataBuilder; outBuilder: iMetadataBuilder);
begin
end;

function ReplaceFactory.newItem(status: iStatus; context: iExternalContext;
  metadata: iRoutineMetadata): IExternalFunction;
begin
  Result := ReplaceFunction.Create;
end;

end.
