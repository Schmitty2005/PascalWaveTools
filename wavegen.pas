unit waveGen;
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
  {Math,} wavCalcs;

type
  TwavePCM = array of int16;

  TWaveStyle = (wsSine, wsTri, wsSqr, wsSaw);

  TwaveGenStyle = function(var aPCM: TwavePCM; const aHertz: integer;
    const aAmp: int16; const aSampleRate: integer; const aMilliSecLength: uint32;
    const aStartPhaseAngle: integer): uint32;

function triangleWave(var aPCM: TwavePCM; const aHertz: integer;
  const aAmp: int16; const aSampleRate: integer; const aMilliSecLength: uint32;
  const aStartPhaseAngle: integer): uint32;


implementation

{$IFDEF FPC}
uses Math;
{$ENDIF}

(*
n = sample number
p = period in samples
n %p = triangle wave
*)


function triangleWave(var aPCM: TWavePCM; const aHertz: integer;
  const aAmp: int16; const aSampleRate: integer; const aMilliSecLength: uint32;
  const aStartPhaseAngle: integer): uint32;
var
  startRad: extended;
  numSamples: uint32;
  Count: uint32;
  sample: int16;
begin
  startRad := DegToRad(aStartPhaseAngle);
  numSamples := trunc(aMilliSecLength / 1000 * aSampleRate);
  Count := 0;
  setLength(aPcm, numSamples);
  while Count < High(aPCM) do
  begin
    sample := Count mod aHertz;
    sample := trunc(abs(sample) - aHertz / 2);
    aPCM[Count] := 4 * aAmp * sample - aAmp;
    Inc(Count);
  end;
end;

end.
