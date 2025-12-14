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

procedure setSampleRate(aSampleRate: uint64);
begin
  sr := aSampleRate;
end;


procedure adsrEnvelope(var aPCM: array of int16; aAdsrSettings: TadsrSettings);

  function MsToSec(var aMs: uint32): single; inline;
  begin
    Result := aMs / 1000;
  end;

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
