{$MODE DELPHI}
program samplerateconvert;

uses
  Classes,
  SampleRateConverter;

var
  ms: TMemoryStream;
  ar: array of int16;
  oa: array of int16;
begin
  ar:= nil;
  oa:= nil;
  ms := TMemoryStream.Create;
  ms.LoadFromFile('ks.pcm');

  setlength(ar, ms.Size);
  ms.ReadBuffer(ar[0], ms.Size );
  ms.Free;

  ConvertSampleRate(ar, oa, 44100, 8000, 1);

  ms := TMemoryStream.Create;
  ms.Write(oa[0], Length(oa) * 2);
  ms.SaveToFile('converted.pcm');
  ms.Free;
end.
