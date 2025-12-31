{$MODE DELPHI}
program samplerateconvert;

uses
  Classes,
  SampleRateConverter,
  samplerateclasses;

var
  ms: TMemoryStream;
  ar: array of int16;
  oa: array of int16;
  co: TInt16Array;
  ia: array of int16;

  rc: TsampleRateConverter;
  ic: IsampleRateConvert;
begin
  ar := nil;
  oa := nil;
  ms := TMemoryStream.Create;
  ms.LoadFromFile('ks.pcm');

  setlength(ar, ms.Size);
  ms.ReadBuffer(ar[0], ms.Size);
  ms.Free;

  ConvertSampleRate(ar, oa, 44100, 22050, 1);

  ms := TMemoryStream.Create;
  ms.Write(oa[0], Length(oa));
  ms.SaveToFile('converted22050.pcm');
  ms.Free;

  rc := TsampleRateConverter.Create(44100, 1, 8000);
  co := nil;
  rc.rateConvert(ar, co);
  rc.Free;

  ms := TMemoryStream.Create;
  ms.Write(co[0], Length(co));
  ms.SaveToFile('clout8000.pcm');
  ms.Free;

  ia := nil;
  ic := TsampleRateConverter.Create(44100, 1, 8000);
  ic.rateConvert(ar, ia);

  ms := TMemoryStream.Create;
  ms.Write(ia[0], Length(ia));
  ms.SaveToFile('ifout8000.pcm');
  ms.Free;

end.
