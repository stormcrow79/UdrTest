library UdrTest;

uses
  Firebird in 'Firebird.pas',
  UdrInit in 'UdrInit.pas',
  UdrGenRows in 'UdrGenRows.pas',
  UdrInc in 'UdrInc.pas',
  TestTrigger in 'TestTrigger.pas',
  MessageBuilder in 'MessageBuilder.pas';

exports firebird_udr_plugin;

begin
  IsMultiThread := true;
end.
