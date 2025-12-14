program adsrTest;

uses
  Classes,
  uadsrTypes,
  uadsrProcedures;

const
  cSRandLength = 44100;
var

  es: TadsrSettings;
  ba: array of int16;
  x: uint64;
  ms: TMemoryStream;
begin
  setSampleRate(cSRandLength);
  SetLength(ba, cSRandLength);
  ms := TMemoryStream.Create;

  //fill array with line to view adsr envelope better
  for x := 0 to cSRandLength do
  begin
    ba[x] := trunc(32767 / 1.10);
  end;

  with es do
  begin
    attack := 250;
    decay := 75;
    sustainLevel := 0.50;
    Release := 250;
  end;
  adsrEnvelope(ba, es);
  //for x:=(11025 * 2)  to (11025 * 3) do  // only so much is held in CLI terminal buffer!
  {$IFDEF CONSOLE_OUT}
   for x:=0 to 44100 do
     write ('[',x,']', ' = ', ba[x], ', ');
  {$ENDIF}
  ms.writebuffer(ba[0], length(ba) * sizeOf(int16));
  ms.SaveToFile('arrayout.pcm'); //view in audacity !
  ms.Free;
end.
