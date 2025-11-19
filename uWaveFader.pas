{$IFDEF FPC}
{$mode delphi}
{$ENDIF}
program uWaveFade;
  {Interface}

  {$IFDEF FPC}
uses classes, Math;
  {$ENDIF}
  {$IFDEF DCC}
Uses System.Classes, System.Math;
  {$ENDIF}

type
  IWaveFader = interface
    ['{F7FF823F-AC70-4E5F-B14D-29537B80DF23}']
    procedure FadeWave(pcm: array of int16; const millisecDur: uint64);
  end;

  TWaveFader = class(TinterfacedObject, IWaveFader)
  public
  type
    Tchannels = (cMono, cStereo);
    TFadeType = (ftIn, ftOut, ftBoth);
  private
    fSampleRate: uint32;
    fmsDuration: uint64;
    fFadeType: TfadeType;
    fChannels: Tchannels;
  public
    constructor Create(const SampleRate: uint32; const FadeType: TfadeType;
      const NumChannels: Tchannels);

    procedure FadeWave(pcm: array of int16; const millisecDur: uint64);
  end;

  {Implementation}

{ #todo -oB -cTesting : Procedure needs testing! }
{ #todo 1 -oB -cfeature : Break out into FadeIn FadeOut procedures as well as
        interface procedures for uInt16 and uInt8 types}
  procedure fadeInOut<T>(var pcm: array of T; lengthms: uint64;
    channels: uint8 = 1; sampleRate: uint32 = 48000);
  var
    durationSamples: uint64;
    sampleNum: uint64;
    weight: double;
  begin
    { #todo -oB : Add check to ensure fade samples do not exceed pcm samples !
 }
    durationSamples := round(lengthMs / 1000 * samplerate) * Channels;
    sampleNum := 0;
    repeat
      //  float weight = 0.5 * (1 - cos(M_PI * s / (numFadeSamples - 1)));
      weight := (0.5 * (1 - cos((Pi * sampleNum / (durationSamples - 1)))));
      pcm[sampleNum] := pcm[sampleNum] * weight;                          //fade in
      pcm[high(pcm) - sampleNum] := pcm[high(pcm) - sampleNum] * weight;  //fade out
      Inc(sampleNum);
    until sampleNum > durationSamples;
  end;


  constructor TWaveFader.Create(const SampleRate: uint32;
  const FadeType: TfadeType; const NumChannels: Tchannels);
  begin
    fSampleRate := SampleRate;
    fFadeType := FadeType;
    fChannels := NumChannels;
  end;

  procedure TWaveFader.FadeWave(pcm: array of int16; const millisecDur: uint64);
  var
    mul: uint64;
    Count: uint64;
    max: uint64;
    ramp: single;
  begin
    case fChannels of
      cMono:
        mul := 1;
      cStereo:
        mul := 2;
    end;
    fmsDuration := millisecDur;
    max := Trunc(((fmsDuration / 1000) * fSampleRate) * mul);
    Count := 0;
    ramp := 0;
    case fFadeType of
      ftIn:
      begin
        repeat
          ramp := Count / max;
          pcm[Count] := trunc(pcm[Count] * ramp);
          Inc(Count);
        until Count > max;
      end;
      ftOut:
      begin
      end;
      ftBoth:
      begin
      end;
    end;

  end;

var
  d: TwaveFader;
  pcm: array [0..44100] of int16;
  x: integer;
begin
  x := 0;
  while x <= high(pcm) do
  begin
    pcm[x] := 27000;
    Inc(x);
  end;

end.
