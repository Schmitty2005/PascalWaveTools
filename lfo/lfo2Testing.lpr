program lfo2Testing;

uses
  Classes,
  lfoTypes,
  lfoSine;

var
  ms: TMemoryStream;
  ar: array of int16;
  //pcm: TlfoPCM;
  //ls: TlfoRec;
  lfos: TlfoSin;
begin
  ms := TMemoryStream.Create;

  ar:= nil;
  lfos := TlfoSin.Create(5, 44100);
  lfos.lfoWave(ar, 5);
  lfos.Free;

  ms.write(ar[0], (high(ar) * SizeOf(int16)));
  ms.SaveToFile('lfoOutput_5Hz.pcm');
  ms.Free;

end.
