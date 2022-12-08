unit UdrInit;

interface

uses Firebird;

function firebird_udr_plugin(status: iStatus; theirUnloadFlagLocal: BooleanPtr; udrPlugin: iUdrPlugin): BooleanPtr; cdecl;

implementation

uses GenericFunctionFactories, UdrGenRows, UdrInc, TestTrigger, UdrReplace;

var
	myUnloadFlag   : Boolean;
	theirUnloadFlag: BooleanPtr;

function firebird_udr_plugin(status: iStatus; theirUnloadFlagLocal: BooleanPtr; udrPlugin: iUdrPlugin): BooleanPtr; cdecl;
begin
	udrPlugin.registerProcedure(status, 'gen_rows', GenRowsFactory.create());
  udrPlugin.registerFunction(status, 'pas_inc', GenericFunctionFactory.create(IncFunction));
  udrPlugin.registerFunction(status, 'replace', GenericFunctionFactory.create(ReplaceFunction));
  udrPlugin.registerTrigger(status, 'test_trigger', TMyTriggerFactory.Create());
	theirUnloadFlag := theirUnloadFlagLocal;
	Result := @myUnloadFlag;
end;

initialization
	myUnloadFlag := false;
finalization
	if ((theirUnloadFlag <> nil) and not myUnloadFlag) then
		theirUnloadFlag^ := true;
end.
