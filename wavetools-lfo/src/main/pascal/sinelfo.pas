unit sinelfo;

{$mode ObjFPC}{$H+}

interface

uses lfoTypes;

procedure sineWaveLFO(var aPcm: TlfoPCM; aFreq: double; aSampleRate: uint64 = 44100);

implementation

procedure sineWaveLFO(var aPcm: TlfoPCM; aFreq: double; aSampleRate: uint64 = 44100);
var
  x: integer;
  calc: double;
begin
  setLength(apcm, trunc(aSampleRate / afreq));
  calc := 2 * PI * aFreq;
  for x := 0 to Trunc(aSampleRate / afreq) do
    apcm[x] := trunc(cos(x * calc) * 27000);
end;

end.
