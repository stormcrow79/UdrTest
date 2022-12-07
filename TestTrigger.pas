unit TestTrigger;

interface

uses
  Firebird;

type

  // structure for mapping messages for NEW. * and OLD. *
  // must match the set of fields in the test table
  TFieldsMessage = record
    Id: Integer;
    IdNull: WordBool;
    A: Integer;
    ANull: WordBool;
    B: Integer;
    BNull: WordBool;
    Name: record
      Length: Word;
      Value: array [0 .. 399] of AnsiChar;
    end;
    NameNull: WordBool;
  end;

  PFieldsMessage = ^TFieldsMessage;

  // Factory for creating an instance of the external trigger TMyTrigger
  TMyTriggerFactory = class(IUdrTriggerFactoryImpl)
    // Called when the factory is destroyed
    procedure dispose(); override;

    {Executed every time an external trigger is loaded into the metadata cache

      @param (AStatus Status vector)
      @param (AContext External trigger execution context)
      @param (AMetadata External trigger metadata)
      @param (AFieldsBuilder Build message for table fields)
    }
    procedure setup(AStatus: IStatus; AContext: IExternalContext;
      AMetadata: IRoutineMetadata; AFieldsBuilder: IMetadataBuilder); override;

    {Create a new instance of the external trigger TMyTrigger

      @param (AStatus Status vector)
      @param (AContext External trigger execution context)
      @param (AMetadata External trigger metadata)
      @returns (External Trigger Instance)
    }
    function newItem(AStatus: IStatus; AContext: IExternalContext;
      AMetadata: IRoutineMetadata): IExternalTrigger; override;
  end;

  TMyTrigger = class(IExternalTriggerImpl)
    // Called when the trigger is destroyed
    procedure dispose(); override;

    {This method is called immediately before execute and reports
      the kernel is our requested character set for exchanging data internally
      this method. During this call, the context uses the character set,
      obtained from ExternalEngine :: getCharSet.

      @param (AStatus Status vector)
      @param (AContext External trigger execution context)
      @param (AName Character set name)
      @param (AName Character set name length)
    }
    procedure getCharSet(AStatus: IStatus; AContext: IExternalContext;
      AName: PAnsiChar; ANameSize: Cardinal); override;

    {execution of trigger TMyTrigger

      @param (AStatus Status vector)
      @param (AContext External trigger execution context)
      @param (AAction Action (current event) trigger)
      @param (AOldMsg Message for old field values: OLD. *)
      @param (ANewMsg Message for new field values: NEW. *)
    }
    procedure execute(AStatus: IStatus; AContext: IExternalContext;
      AAction: Cardinal; AOldMsg: Pointer; ANewMsg: Pointer); override;
  end;

implementation

{ TMyTriggerFactory }

procedure TMyTriggerFactory.dispose;
begin
  Destroy;
end;

function TMyTriggerFactory.newItem(AStatus: IStatus; AContext: IExternalContext;
  AMetadata: IRoutineMetadata): IExternalTrigger;
begin
  Result := TMyTrigger.create;
end;

procedure TMyTriggerFactory.setup(AStatus: IStatus; AContext: IExternalContext;
  AMetadata: IRoutineMetadata; AFieldsBuilder: IMetadataBuilder);
begin

end;

{ TMyTrigger }

procedure TMyTrigger.dispose;
begin
  Destroy;
end;

procedure TMyTrigger.getCharSet(AStatus: IStatus; AContext: IExternalContext;
  AName: PAnsiChar; ANameSize: Cardinal);
begin
end;

procedure TMyTrigger.execute(AStatus: IStatus; AContext: IExternalContext;
  AAction: Cardinal; AOldMsg, ANewMsg: Pointer);
var
  xOld, xNew: PFieldsMessage;
begin  
  xNew := PFieldsMessage(ANewMsg);
  case AAction of
    IExternalTrigger.ACTION_INSERT:
      begin
        if xNew.BNull and not xNew.ANull then
        begin
          xNew.B := xNew.A + 1;
          xNew.BNull := False;
        end;
      end;

    IExternalTrigger.ACTION_UPDATE:
      begin
        if xNew.BNull and not xNew.ANull then
        begin
          xNew.B := xNew.A + 1;
          xNew.BNull := False;
        end;
      end;

    IExternalTrigger.ACTION_DELETE:
      begin

      end;
  end;
end;

end.
