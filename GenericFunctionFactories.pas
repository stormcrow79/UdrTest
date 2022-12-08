unit GenericFunctionFactories;

interface

uses Firebird;

type
  GenericFunctionFactory = class(IUdrFunctionFactoryImpl)
  private
    FFunctionClass: TClass;
  public
    constructor create(functionClass: TClass);

    procedure dispose(); override;

    procedure setup(status: iStatus; context: iExternalContext;
      metadata: iRoutineMetadata; inBuilder: iMetadataBuilder;
      outBuilder: iMetadataBuilder); override;

    function newItem(status: iStatus; context: iExternalContext;
      metadata: iRoutineMetadata): IExternalFunction; override;
  end;

implementation

constructor GenericFunctionFactory.create(functionClass: TClass);
begin
  FFunctionClass := functionClass;
end;

procedure GenericFunctionFactory.dispose();
begin
  Destroy;
end;

procedure GenericFunctionFactory.setup(status: iStatus; context: iExternalContext;
  metadata: iRoutineMetadata; inBuilder: iMetadataBuilder; outBuilder: iMetadataBuilder);
begin
end;

function GenericFunctionFactory.newItem(status: iStatus; context: iExternalContext;
  metadata: iRoutineMetadata): IExternalFunction;
begin
  Result := FFunctionClass.Create as IExternalFunction;
end;


end.
