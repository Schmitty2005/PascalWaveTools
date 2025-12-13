{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}
unit uadsrProcedures;

interface

uses uadsrTypes;
/// <summary>Modifies an existing PCM array of Int16 with an ADSR envelope.
/// <remarks>NOTE: DO NOT PASS WAVE HEADER!
/// </remarks>
/// <remarks>NOTE: Call setSampleRate(aSampleRate: uint64) procedure to set sample rate if sample rate is
///               other than 44100!
/// </remarks>
/// </summary>
procedure adsrEnvelope(var aPCM: array of int16; aAdsrSettings: TadsrSettings);

///<summary>setSampleRate must be called first!</summary> 
procedure setSampleRate(aSampleRate: uint64);

implementation

const
  cDefaultSampleRate = 44100;

var
  env: TadsrSettings;
  sr: uint64;
  sustainVolume: double;
  x, c: uint64;
  sustainSampleStart: uint64;
  sustainSampleEnd: uint64;

procedure fadeIn(var pcm: array of int16; lengthms: uint64;
  channels: uint8 = 1; sampleRate: uint32 = 48000);
var
  durationSamples: uint64;
  sampleNum: uint64;
  weight: double;
begin
  durationSamples := round(lengthMs / 1000 * samplerate) * Channels;
  sampleNum := 0;
  if durationSamples > high(pcm) then
    durationSamples := trunc(High(pcm));
  repeat
    weight := (0.5 * (1 - cos((Pi * sampleNum / (durationSamples - 1)))));
    pcm[sampleNum] := Trunc(pcm[sampleNum] * weight);
    Inc(sampleNum);
  until sampleNum > durationSamples;
end;

procedure fadeOut(var pcm: array of int16; lengthms: uint64;
  channels: uint8 = 1; sampleRate: uint32 = 48000);
var
  durationSamples: uint64;
  sampleNum: uint64;
  weight: double;
begin
  durationSamples := round(lengthMs / 1000 * samplerate) * Channels;
  sampleNum := 0;
  if durationSamples > high(pcm) then
    durationSamples := trunc(High(pcm));
  repeat
    weight := (0.5 * (1 - cos((Pi * sampleNum / (durationSamples - 1)))));
    pcm[high(pcm) - sampleNum] := Trunc(pcm[high(pcm) - sampleNum] * weight);
    Inc(sampleNum);
  until sampleNum > durationSamples;
  sustainVolume := weight;
end;


procedure setSampleRate(aSampleRate: uint64);
begin
  sr := aSampleRate;
end;

procedure attackEnvelope(var aPCM: array of int16; aAttack: uint64);
begin
  fadeIn(aPCM, aAttack, 1, sr);
end;

procedure decayEnvelope(var aPCM: array of int16; aDecay: uint64);
{ #todo -oB : Needs some thinking about how to accomplish this with decay and rate of decay! }
begin
  //Current values are temp for testing only!
  sustainVolume := 0.5;            //temp
  sustainSampleStart := 11025 * 2;// temp
end;

procedure sustainEnvelope(var aPCM: array of int16; aSustain: uint64);
{ #todo -oB : May not need aSustain ! }
begin
  //maintain sustain volume to end of array!
  for x := sustainSampleStart to High(aPCM) do
    aPCM[x] := trunc(aPCM[x] * sustainVolume);
end;

procedure releaseEnvelope(var aPCM: array of int16; aRelease: uint64);
begin
  fadeOut(aPCM, aRelease, 1, sr);
end;

procedure adsrEnvelope(var aPCM: array of int16; aAdsrSettings: TadsrSettings);
begin
  env := aAdsrsettings;
  attackEnvelope(aPCM, env.Attack);
  decayEnvelope(aPCM, env.Decay);
  sustainEnvelope(aPCM, env.Sustain);
  releaseEnvelope(aPCM, env.Release);
end;

begin
  sr := cDefaultSampleRate; //Set default sample rate.  Untested , but should work!
end.
