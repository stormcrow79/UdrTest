unit UdrReplace;

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

  ReplaceFactory = class(IUdrFunctionFactoryImpl)
    procedure dispose(); override;

    procedure setup(status: iStatus; context: iExternalContext;
      metadata: iRoutineMetadata; inBuilder: iMetadataBuilder;
      outBuilder: iMetadataBuilder); override;

    function newItem(status: iStatus; context: iExternalContext;
      metadata: iRoutineMetadata): IExternalFunction; override;
  end;

implementation

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
  xInput: IncInMessagePtr;
  xOutput: IncOutMessagePtr;
begin
  xInput := IncInMessagePtr(inMsg);
  xOutput := IncOutMessagePtr(outMsg);

  xOutput^.resultNull := xInput^.valNull;
  xOutput^.Result := xInput^.val + 1;
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
