unit whiteNoise;

{$mode ObjFPC}{$H+}

interface


uses
  Classes, SysUtils {$IFDEF BLAISE}, Legacey.random{$ENDIF};

type
  TNoise = array of int16;

procedure whiteNoise(var aPCM: TNoise; aLengthms: int64 {uint64};
  aAmplitude: uint16 = 27000; aSampleRate: uint32 = 44100);

implementation

procedure whiteNoise(var aPCM: TNoise; aLengthms: int64 {uint64};
  aAmplitude: uint16 = 27000; aSampleRate: uint32 = 44100);
var
  x, l:int64; // uint64;
begin
  l := ((aSampleRate * aLengthms) div 1000);
  setLength(aPCM, l);
  for x := low(aPCM) to high(Apcm) do
    aPCM[x] := trunc((random() - 0.5) * aAmplitude * 2);
end;



end.
