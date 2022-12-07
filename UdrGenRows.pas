unit UdrGenRows;

interface

uses Firebird;

type
  GenRowsInMessage = record
    start: integer;
    startNull: wordbool;
    end_: integer;
    endNull: wordbool;
  end;

  GenRowsInMessagePtr = ^GenRowsInMessage;

  GenRowsOutMessage = record
    Result: integer;
    resultNull: wordbool;
  end;

  GenRowsOutMessagePtr = ^GenRowsOutMessage;

  GenRowsResultSet = class(iExternalResultSetImpl)
    procedure dispose(); override;
    function fetch(status: iStatus): boolean; override;


  public
    inMessage: GenRowsInMessagePtr;
    outMessage: GenRowsOutMessagePtr;
  end;

  GenRowsProcedure = class(iExternalProcedureImpl)
    procedure dispose(); override;

    procedure getCharSet(status: iStatus; context: iExternalContext;
      Name: pansichar; nameSize: cardinal); override;

    function Open(status: iStatus; context: iExternalContext; inMsg: Pointer;
      outMsg: Pointer): iExternalResultSet; override;
  end;

  GenRowsFactory = class(iUdrProcedureFactoryImpl)
    procedure dispose(); override;

    procedure setup(status: iStatus; context: iExternalContext;
      metadata: iRoutineMetadata; inBuilder: iMetadataBuilder;
      outBuilder: iMetadataBuilder); override;

    function newItem(status: iStatus; context: iExternalContext;
      metadata: iRoutineMetadata): iExternalProcedure; override;
  end;

implementation

procedure GenRowsResultSet.dispose();
begin
  Destroy;
end;

function GenRowsResultSet.fetch(status: iStatus): boolean;
begin
  if (outMessage.Result >= inMessage.end_) then
    Result := False
  else
  begin
    outMessage.Result := outMessage.Result + 1;
    Result := True;
  end;
end;


procedure GenRowsProcedure.dispose();
begin
  Destroy;
end;

procedure GenRowsProcedure.getCharSet(status: iStatus; context: iExternalContext;
  Name: pansichar; nameSize: cardinal);
begin
end;

function GenRowsProcedure.Open(status: iStatus; context: iExternalContext;
  inMsg: Pointer; outMsg: Pointer): iExternalResultSet;
var
  Ret: GenRowsResultSet;
begin
  Ret := GenRowsResultSet.Create();
  Ret.inMessage := inMsg;
  Ret.outMessage := outMsg;

  Ret.outMessage.resultNull := False;
  Ret.outMessage.Result := Ret.inMessage.start - 1;

  Result := Ret;
end;


procedure GenRowsFactory.dispose();
begin
  Destroy;
end;

procedure GenRowsFactory.setup(status: iStatus; context: iExternalContext;
  metadata: iRoutineMetadata; inBuilder: iMetadataBuilder; outBuilder: iMetadataBuilder);
begin
end;

function GenRowsFactory.newItem(status: iStatus; context: iExternalContext;
  metadata: iRoutineMetadata): iExternalProcedure;
begin
  Result := GenRowsProcedure.Create;
end;
end.
