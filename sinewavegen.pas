{$IFDEF FPC }
{$MODE delphi}
{$ENDIF}
unit sinewavegen;

(*
  Example Usage :

  var
  ba: TpcmArray;
  bs : TBytesStream;
  begin
  try
  singen(ba, 44100, 800, 1000, 100);
  bs := TBytesStream.Create(Tbytes(ba));
  bs.SaveToFile('test44100pcm.pcm');
  { TODO -oUser -cConsole Main : Insert code here }
  except
  on E: Exception do
  Writeln(E.ClassName, ': ', E.Message);
  end;

*)
interface

uses sysutils;

type

  TpcmArray = array of Int16;

procedure singen(out aPcm: TpcmArray; const sampleRate: Integer;
  const FreqHz: Integer; const msLength: Integer; const Ampli: Integer);

implementation

/// <summary>
/// A simple routine to create a sine wave PCM
/// </summary>
procedure singen(out aPcm: TpcmArray; const sampleRate: Integer;
  const FreqHz: Integer; const msLength: Integer; const Ampli: Integer);
const
  tau = 2 * PI;
var
  cnt, numSamples: Uint32;
  sample, precalc, ampCalc: double;
  pint: ^Int16;
Begin
  numSamples := trunc(msLength / 1000 * sampleRate);
  setLength(aPcm, numSamples);
  cnt := 0;
  pint := addr(aPcm[0]);
  precalc := tau * FreqHz / sampleRate;
  ampCalc := ((Ampli / 100) * High(Int16));
{$POINTERMATH ON}
  while cnt <= numSamples do
  begin
    pint[cnt] := trunc(cos(precalc * cnt) * ampCalc);
    inc(cnt);
  end;
{$POINTERMATH OFF}
End;

end.


