{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}
unit uadsrProcedures;

interface

uses uadsrTypes;
/// <summary>Modifies an existing PCM array of Int16 with an ADSR envelope.
/// <remarks>NOTE: DO NOT PASS WAVE HEADER!
/// </remarks>
/// <remarks>NOTE: Call <code>setSampleRate(aSampleRate: uint64)</code> procedure to set sample rate if sample rate is
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
  // sustainVolume: double;
  // x, c: uint64;
  //sustainSampleStart: uint64;
  //sustainSampleEnd: uint64;


  {==============================================================================}

procedure ApplyADSR(var Buffer: array of int16; SampleRate: integer;
  AttackTime, DecayTime, SustainLevel, ReleaseTime: single);
var
  i: integer;
  Env: single;
  AttackSamples, DecaySamples, ReleaseSamples: integer;
  SustainSamples: integer;
  TotalSamples: integer;
begin
  TotalSamples := Length(Buffer);

  AttackSamples := Round(AttackTime * SampleRate);
  DecaySamples := Round(DecayTime * SampleRate);
  ReleaseSamples := Round(ReleaseTime * SampleRate);

  SustainSamples := TotalSamples - (AttackSamples + DecaySamples + ReleaseSamples);

  if SustainSamples < 0 then
    SustainSamples := 0;

  for i := 0 to TotalSamples - 1 do
  begin
    if i < AttackSamples then
    begin
      // Attack: 0 -> 1
      Env := i / AttackSamples;
    end
    else if i < AttackSamples + DecaySamples then
    begin
      // Decay: 1 -> SustainLevel
      Env := 1.0 - (1.0 - SustainLevel) * ((i - AttackSamples) / DecaySamples);
    end
    else if i < AttackSamples + DecaySamples + SustainSamples then
    begin
      // Sustain
      Env := SustainLevel;
    end
    else
    begin
      // Release: SustainLevel -> 0
      Env := SustainLevel * (1.0 -
        ((i - (AttackSamples + DecaySamples + SustainSamples)) / ReleaseSamples));
    end;

    // Clamp (safety)
    if Env < 0 then Env := 0;
    if Env > 1 then Env := 1;

    // Apply envelope
    Buffer[i] := Round(Buffer[i] * Env);
  end;
end;

{==============================================================================}



(*
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
  //sustainVolume := weight;
end;

procedure decayFade(var pcm: array of int16; lengthms: uint64;
  channels: uint8 = 1; sampleRate: uint32 = 48000);
var
  durationSamples: uint64;
  sampleNum: uint64;
  weight: double;
  endDecay: uint64;
begin
  durationSamples := round(lengthMs / 1000 * samplerate) * Channels;
  sampleNum := 0;//trunc(env.attack / 1000 * sr) + 1;
  endDecay := trunc((env.Attack + env.decay) / 1000 * sr);
  if durationSamples > high(pcm) then
    durationSamples := trunc(High(pcm));
  repeat
    { #todo -oB : high(pcm) needs to be replaced with proper end of fade! }
    weight := (0.5 * (1 - cos((Pi * sampleNum / (durationSamples - 1)))));
    pcm[endDecay - sampleNum] := Trunc(pcm[endDecay - sampleNum] * weight);
    Inc(sampleNum);
  until weight <= sustainVolume;
  sustainVolume := weight;
end;
*)

procedure setSampleRate(aSampleRate: uint64);
begin
  sr := aSampleRate;
end;
(*
procedure attackEnvelope(var aPCM: array of int16; aAttack: uint64);
begin
  fadeIn(aPCM, aAttack, 1, sr);
end;

procedure decayEnvelope(var aPCM: array of int16; aDecayLength: uint64;
  aSustainLevel: double);
{ #todo -oB : Needs some thinking about how to accomplish this with decay and rate of decay! }
var
  decayWeight: double;
  Count, currentSample: uint64;
begin
  Count := 0;
  currentSample := trunc((env.attack + 1) / 1000 * sr);
  sustainVolume := aSustainLevel;
  decayweight := 1;
  while decayWeight > sustainVolume do
  begin
    decayweight := decayWeight - (Count * (1 / decayWeight));
    aPCM[currentSample + Count] := trunc(aPCM[CurrentSample + Count] * decayWeight);
    Inc(Count);
  end;
  // decayFade(aPCM, env.decay, 1, sr); //decayFade is a failed attempt!
  //decayEnvelope(aPCM, sustainVolume);
  //Current values are temp for testing only!
  // sustainVolume := 0.5;            //temp
  //sustainSampleStart := 11025 * 2;// temp
  sustainSampleStart := trunc(((env.attack + env.decay) / 1000) * sr) + 1;
end;

procedure sustainEnvelope(var aPCM: array of int16);// aSustain: uint64);
{ #todo -oB : May not need aSustain ! }
{var
  susSampleStart: uint64;}
begin

  //maintain sustain volume to end of array!
  for x := sustainSampleStart to High(aPCM) do
    aPCM[x] := trunc(aPCM[x] * sustainVolume);
end;

procedure releaseEnvelope(var aPCM: array of int16; aRelease: uint64);
begin
  fadeOut(aPCM, aRelease, 1, sr);
end;
*)

procedure adsrEnvelope(var aPCM: array of int16; aAdsrSettings: TadsrSettings);

  function MsToSec(var aMs: uint32): single; inline; //overload;
  begin
    Result := aMs / 1000;
  end;
  {
   function MsToSec(var aMs: double): double;inline; overload;
  begin
    result := aMs / 1000;
  end;
   }
var
  at, dc, st, rl: double;
begin
  env := aAdsrsettings;

  at := MsToSec((aAdsrSettings.attack));
  dc := MsToSec(aAdsrSettings.decay);
  st := aAdsrSettings.sustainLevel;
  rl := MsToSec(aAdsrSettings.Release);

  ApplyADSR(aPCM, sr, at, dc, st, rl);

end;

begin
  sr := cDefaultSampleRate; //Set default sample rate.  Untested , but should work!
end.
