unit UdrInc;

interface

uses Firebird;

type
  IncInMessage = record
    val: integer;
    valNull: wordbool;
  end;

  IncInMessagePtr = ^IncInMessage;

  IncOutMessage = record
    Result: integer;
    resultNull: wordbool;
  end;

  IncOutMessagePtr = ^IncOutMessage;

  IncFunction = class(IExternalFunctionImpl)
    procedure dispose(); override;

    procedure getCharSet(status: iStatus; context: iExternalContext;
      Name: pansichar; nameSize: cardinal); override;

    procedure Execute(status: iStatus; context: iExternalContext;
      inMsg: Pointer; outMsg: Pointer); override;
  end;

  IncFactory = class(IUdrFunctionFactoryImpl)
    procedure dispose(); override;

    procedure setup(status: iStatus; context: iExternalContext;
      metadata: iRoutineMetadata; inBuilder: iMetadataBuilder;
      outBuilder: iMetadataBuilder); override;

    function newItem(status: iStatus; context: iExternalContext;
      metadata: iRoutineMetadata): IExternalFunction; override;
  end;

implementation

procedure IncFunction.dispose();
begin
  Destroy;
end;

procedure IncFunction.getCharSet(status: iStatus; context: iExternalContext;
  Name: pansichar; nameSize: cardinal);
begin
end;

procedure IncFunction.Execute(status: iStatus; context: iExternalContext;
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


procedure IncFactory.dispose();
begin
  Destroy;
end;

procedure IncFactory.setup(status: iStatus; context: iExternalContext;
  metadata: iRoutineMetadata; inBuilder: iMetadataBuilder; outBuilder: iMetadataBuilder);
begin
end;

function IncFactory.newItem(status: iStatus; context: iExternalContext;
  metadata: iRoutineMetadata): IExternalFunction;
begin
  Result := IncFunction.Create;
end;

end.
