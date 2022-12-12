unit MessageBuilder;

interface

uses SysUtils, Classes, Firebird;

type
  TVarCharField = class
  private
    FLength: ^Word;
    FData: PChar;
    FNull: PWordBool;

    function GetValue: string;
    function GetNull: boolean;
  public
    property Value: string read GetValue;
    property Null: boolean read GetNull;
  end;

  TMessageBuilder = class
  private
    FMessage: Pointer;
    FIndex: integer;
    FFields: TList;
  public
    constructor Create(Message: Pointer);
    destructor Destroy; override;

    function AddVarChar(Length: integer): TVarCharField;
  end;

implementation

procedure log(const message: string);
var f: text;
begin
  AssignFile(f, 'c:\ccare\udr.log');
  Append(f);
  Writeln(f, message);
  Close(f);
end;

constructor TMessageBuilder.Create(Message: Pointer);
begin
  FMessage := Message;
  FFields := TList.Create;
end;

destructor TMessageBuilder.Destroy;
begin
  FFields.Free;
  inherited;
end;

function TMessageBuilder.AddVarchar(Length: integer) : TVarCharField;
begin
log('AddVarChar ' + IntToStr(Length));
  Result := TVarCharField.Create;
  Result.FLength := FMessage + FIndex;
  Inc(FIndex, 8);
log('  length ' + IntToStr(Result.FLength^));
  Result.FData := FMessage + FIndex;
  Inc(FIndex, Length + (Length mod 8));
log('  data ' + string(Result.FData));
  Result.FNull := FMessage + FIndex;
  Inc(FIndex, 8);
end;


function TVarCharField.GetValue: string;
begin
  Result := '';
  if Null or (FLength^ = 0) then
    exit;

  SetLength(Result, FLength^);
  Move(FData^, Result[1], FLength^);
end;

function TVarCharField.GetNull: boolean;
begin
  Result := FNull^;
end;

end.