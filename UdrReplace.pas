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

  ReplaceFactory = class(IUdrFunctionFactoryImpl)
    procedure dispose(); override;

    procedure setup(status: iStatus; context: iExternalContext;
      metadata: iRoutineMetadata; inBuilder: iMetadataBuilder;
      outBuilder: iMetadataBuilder); override;

    function newItem(status: iStatus; context: iExternalContext;
      metadata: iRoutineMetadata): IExternalFunction; override;
  end;

implementation

uses SysUtils, MessageBuilder;

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
  input: TMessageBuilder;
  value, find, replace: TVarCharField;
  xOutput: ReplaceOutMessagePtr;
  tmp: string;
begin
  input := TMessageBuilder.Create(inMsg);
  try
    value := input.AddVarChar(400);
    find := input.AddVarChar(400);
    replace := input.AddVarChar(400);
    xOutput := ReplaceOutMessagePtr(outMsg);

    xOutput^.ResultNull := value.Null;
    if not xOutput^.ResultNull then
    begin
      tmp := StringReplace(value.Value, find.Value, replace.Value, [rfReplaceAll]); 
      
      xOutput^.Result.Length := Length(tmp);
      Move(tmp[1], xOutput^.Result.Value[0], Length(tmp));
    end;
  finally
    input.Free;
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
