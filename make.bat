c:\fpc\3.2.2\bin\i386-win32\ppcrossx64.exe ^
  -MDelphi -TWin64 -Px86_64 -Cirot -O3 -vew ^
  -FEbin -FUobj ^
  UdrTest.dpr

copy .\bin\UdrTest.dll C:\Firebird\plugins\udr\
