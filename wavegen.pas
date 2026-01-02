unit waveGen;
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

{ #todo -oB : Use DEFINES to possibly set sample rate and amplitude defaults
 }
interface



uses
  SysUtils, {Math,} waveCalcs;

const
  DEFAULTSAMPERATE = 44100;

type
  EWaveGenError = class(Exception);

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

  TwaveGenStyleExt = function(var aPCM: TwavePCM; const aHertz: double;
    const aMilliSecLength: uint32; const aAmp: int16;
    const aSampleRate: integer = DEFAULTSAMPERATE;
    const aStartPhaseAngle: integer = 90): uint32;

function WaveGen(aWaveStyleSpec: TWaveStyleSpecs): integer;

function triangleWave(var aPCM: TwavePCM; const aHertz: double;
  const aMilliSecLength: uint32; const aAmp: int16;
  const aSampleRate: integer = DEFAULTSAMPERATE;
  const aStartPhaseAngle: integer = 90): uint32; overload;

function triangleWave(var aWaveSpec: TWaveStyleSpecs): uint32; overload;

function sawWave(var aPCM: TwavePCM; const aHertz: double;
  const aMilliSecLength: uint32; const aAmp: int16;
  const aSampleRate: integer = DEFAULTSAMPERATE;
  const aStartPhaseAngle: integer = 90): uint32; overload;

function sawWave(var aWaveSpec: TWaveStyleSpecs): uint32; overload;

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

function checkWaveStyleSpec(aWaveSpec: TWaveStyleSpecs): boolean;
begin
  Result := False;
  if (aWaveSpec.FreqHertz = 0) then
  begin
    raise EWaveGenError.Create('Sample Rate cannot be zero!');
    Result := True;
  end;
  if (aWaveSpec.LengthMilliSec = 0) then
  begin
    raise EWaveGenError.Create('Length of Wave  cannot be zero!');
    Result := True;
  end;
  if (aWaveSpec.Amplitude = 0) then
  begin
    raise EWaveGenError.Create('Amplitude cannot be zero!');
    Result := True;
  end;
end;

{ #todo -oB : Amplitude needs to change to 0 to 100 percent like other functions!  Currently uses Max of Int16 values.
 }

function WaveGen(aWaveStyleSpec: TWaveStyleSpecs): integer;
begin
  { #todo -oB -cFeature : Use a case statement to select proper TWaveGenFunction and generate based on TWaveStyleSpecs.WaveType
 }
  Result := 0;
end;

function triangleWave(var aPCM: TwavePCM; const aHertz: double;
  const aMilliSecLength: uint32; const aAmp: int16;
  const aSampleRate: integer = DEFAULTSAMPERATE;
  const aStartPhaseAngle: integer = 90): uint32;
var
  phase, phaseStep, tau: double;
  numSamples: uint32;
  Count: uint32;
begin
  tau := 2 * PI;
  phase := DegToRad(aStartPhaseAngle);
  numSamples := trunc(aMilliSecLength / 1000 * aSampleRate);
  PhaseStep := 2 * PI * (aHertz * 10) / aSampleRate;
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

function triangleWave(var aWaveSpec: TWaveStyleSpecs): uint32;
begin
  checkWaveStyleSpec(aWaveSpec);
  Result := trianglewave(aWaveSpec.aPCM, aWaveSpec.FreqHertz,
    aWaveSpec.LengthMilliSec, aWaveSpec.Amplitude, aWaveSpec.SampleRate,
    aWaveSpec.StartPhaseDeg);
end;

{NEW SawWave Function written by Claude AI}
function sawWave(var aPCM: TwavePCM; const aHertz: double;
  const aMilliSecLength: uint32; const aAmp: int16;
  const aSampleRate: integer = DEFAULTSAMPERATE;
  const aStartPhaseAngle: integer = 90): uint32;
var
  totalSamples: uint32;
  i: uint32;
  t: double;
  phase: double;
  sampleValue: double;
  phaseOffset: double;
begin
  // Calculate total number of samples needed
  totalSamples := (aMilliSecLength * aSampleRate) div 1000;

  // Set the length of the PCM array
  SetLength(aPCM, totalSamples);

  // Convert start phase angle from degrees to radians
  phaseOffset := (aStartPhaseAngle * Pi) / 180.0;

  // Generate sawtooth wave samples
  for i := 0 to totalSamples - 1 do
  begin
    // Calculate time in seconds
    t := i / aSampleRate;

    // Calculate phase (0 to 2*Pi range per cycle)
    phase := (2.0 * Pi * aHertz * t) + phaseOffset;

    // Normalize phase to 0..2*Pi range
    phase := fmod(phase, 2.0 * Pi);
    if phase < 0 then
      phase := phase + 2.0 * Pi;

    // Generate sawtooth: linear ramp from -1 to +1
    // Sawtooth formula: 2 * (phase / (2*Pi)) - 1
    sampleValue := 2.0 * (phase / (2.0 * Pi)) - 1.0;

    // Scale by amplitude and store
    aPCM[i] := Round(sampleValue * aAmp);
  end;

  Result := totalSamples;
end;

(*
//OLD SawWave function
function sawWave(var aPCM: TwavePCM; const aHertz: double;
  const aMilliSecLength: uint32; const aAmp: int16;
  const aSampleRate: integer = DEFAULTSAMPERATE;
  const aStartPhaseAngle: integer = 90): uint32;
var
  phase, tau, precalc: double;
  numSamples: uint32;
  Count: uint32;
begin

  tau := 2 * PI;
  precalc := aHertz * tau / aSampleRate;
  phase := DegToRad(aStartPhaseAngle);
  numSamples := trunc(aMilliSecLength / 1000 * aSampleRate);
  //PhaseStep := 2 * PI * aHertz / aSampleRate;
  Count := 0;
  setLength(aPCM, numSamples);
  while Count < High(aPCM) do
  begin
    Phase := Phase + precalc;
    if Phase >= 2 * pi then
      Phase := Phase - (2 * pi);
    aPCM[Count] := Trunc((Phase / (2 * pi) * 2 - 1) * aAmp);
    Inc(Count);
  end;
  Result := Count;
end;
*)


function sawWave(var aWaveSpec: TWaveStyleSpecs): uint32;
var
  Count: uint32;
begin
  checkWaveStyleSpec(aWaveSpec);
  Count := sawWave(aWaveSpec.aPCM, aWaveSpec.FreqHertz, aWaveSpec.LengthMilliSec,
    aWaveSpec.Amplitude, aWaveSpec.SampleRate, aWaveSpec.StartPhaseDeg);
  if Count = 0 then raise EWaveGenError.Create('Saw Wave Creation Failed! Zero Length!');
  Result := Count;
end;

end.
