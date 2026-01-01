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

function triangleWave(aWaveSpec: TWaveStyleSpecs): uint32; overload;

function sawWave(var aPCM: TwavePCM; const aHertz: double;
  const aMilliSecLength: uint32; const aAmp: int16;
  const aSampleRate: integer = DEFAULTSAMPERATE;
  const aStartPhaseAngle: integer = 90): uint32; overload;

function sawWave(var aWaveSpec: TWaveStyleSpecs): uInt32; overload;

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
  checkWaveStyleSpec(aWaveSpec);
  Result := trianglewave(aWaveSpec.aPCM, aWaveSpec.FreqHertz,
    aWaveSpec.Amplitude, aWaveSpec.SampleRate, aWaveSpec.LengthMilliSec,
    aWaveSpec.StartPhaseDeg);
end;

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

function sawWave(var aWaveSpec: TWaveStyleSpecs): uInt32;
var
  Count: uint32;
begin
  checkWaveStyleSpec(aWaveSpec);
  Count := sawWave(aWaveSpec.aPCM, aWaveSpec.FreqHertz, aWaveSpec.LengthMilliSec,
    aWaveSpec.Amplitude, aWaveSpec.SampleRate, aWaveSpec.StartPhaseDeg);
  if Count = 0 then raise EWaveGenError.create('Saw Wave Creation Failed! Zero Length!');
  Result := Count;
end;

end.
