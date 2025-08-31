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

  TWaveStyleSpecs = record
    WaveStyle: TWaveStyle;
    aPCM: TwavePCM;
    FreqHertz: integer;
    Amplitude: int16;
    SampleRate: integer;
    LengthMilliSec: uint32;
    StartPhaseDeg: integer;
  end;

  TwaveGenStyle = function(aWaveSpec: TWaveStyleSpecs): uint32;

  TwaveGenStyleExt = function(var aPCM: TwavePCM; const aHertz: integer;
    const aAmp: int16; const aSampleRate: integer; const aMilliSecLength: uint32;
    const aStartPhaseAngle: integer): uint32;


function triangleWave(var aPCM: TwavePCM; const aHertz: integer;
  const aAmp: int16; const aSampleRate: integer; const aMilliSecLength: uint32;
  const aStartPhaseAngle: integer = 90): uint32; overload;

function triangleWave(aWaveSpec: TWaveStyleSpecs): uint32; overload;

function sawWave(var aPCM: TwavePCM; const aHertz: integer; const aAmp: int16;
  const aSampleRate: integer; const aMilliSecLength: uint32;
  const aStartPhaseAngle: integer = 90): uint32; overload;

function sawWave(aWaveSpec: TWaveStyleSpecs): uint32; overload;

implementation

{$IFDEF FPC}
uses Math;
{$ENDIF}

{$IFDEF DCC}
Uses system.Math;
{$ENDIF}
(*
  n = sample number
  p = period in samples
  n %p = triangle wave
*)


{ #todo -oB : Amplitude needs to change to 0 to 100 percent like other functions!  Currently uses Max of Int16 values.
 }

function triangleWave(var aPCM: TwavePCM; const aHertz: integer;
  const aAmp: int16; const aSampleRate: integer; const aMilliSecLength: uint32;
  const aStartPhaseAngle: integer = 90): uint32;
var
  phase, phaseStep, tau: double;
  numSamples: uint32;
  Count: uint32;
begin
  tau := 2 * PI;
  phase := DegToRad(aStartPhaseAngle);
  numSamples := trunc(aMilliSecLength / 1000 * aSampleRate);
  PhaseStep := 2 * PI * aHertz / aSampleRate;
  Count := 0;
  setLength(aPCM, numSamples);
  while Count < High(aPCM) do
  begin
    Phase := fmod(Phase, tau);
    if Phase < PI then
      aPCM[Count] := round(aAmp * (2 / PI * (Phase - PI / 2)))
    else
      aPCM[Count] := round(aAmp * (-2 / PI * (Phase - 3 * PI / 2)));
    Phase := Phase + PhaseStep;
    Inc(Count);
  end;
  Result := Count;
end;

function triangleWave(aWaveSpec: TWaveStyleSpecs): uint32;
begin
  Result := trianglewave(aWaveSpec.aPCM, aWaveSpec.FreqHertz,
    aWaveSpec.Amplitude, aWaveSpec.SampleRate, aWaveSpec.LengthMilliSec,
    aWaveSpec.StartPhaseDeg);
end;

function sawWave(var aPCM: TwavePCM; const aHertz: integer; const aAmp: int16;
  const aSampleRate: integer; const aMilliSecLength: uint32;
  const aStartPhaseAngle: integer): uint32;
begin
  { #todo -oB : Needs Completion! }
  result := 0;
end;

function sawWave(aWaveSpec: TWaveStyleSpecs): uint32;
begin
  Result := sawWave(aWaveSpec.aPCM, aWaveSpec.FreqHertz,
    aWaveSpec.Amplitude, aWaveSpec.SampleRate, aWaveSpec.LengthMilliSec,
    aWaveSpec.StartPhaseDeg);
end;

end.
