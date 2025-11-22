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
    Tchannels = (cMono = 1, cStereo);
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

  procedure fadeIn<T>(var pcm: array of T; lengthms: uint64; channels: uint8 = 1;
    sampleRate: uint32 = 48000);
  var
    durationSamples: uint64;
    sampleNum: uint64;
    weight: double;
  begin
    durationSamples := round(lengthMs / 1000 * samplerate) * Channels;
    sampleNum := 0;
    //if durationSamples > high(pcm) then durationSamples:= trunc(High(pcm)/2);//In AND Out fade
    if durationSamples > high(pcm) then
      durationSamples := trunc(High(pcm));//In OR Out fade
    repeat
      //  float weight = 0.5 * (1 - cos(M_PI * s / (numFadeSamples - 1)));
      weight := (0.5 * (1 - cos((Pi * sampleNum / (durationSamples - 1)))));
      pcm[sampleNum] := Trunc(pcm[sampleNum] * weight);
      //fade in
      //pcm[high(pcm) - sampleNum] := Trunc(pcm[high(pcm) - sampleNum] * weight)   ;  //fade out
      Inc(sampleNum);
    until sampleNum > durationSamples;
  end;


  procedure fadeOut<T>(var pcm: array of T; lengthms: uint64;
    channels: uint8 = 1; sampleRate: uint32 = 48000);
  var
    durationSamples: uint64;
    sampleNum: uint64;
    weight: double;
  begin
    durationSamples := round(lengthMs / 1000 * samplerate) * Channels;
    sampleNum := 0;
    //if durationSamples > high(pcm) then durationSamples:= trunc(High(pcm)/2);//In AND Out fade
    if durationSamples > high(pcm) then
      durationSamples := trunc(High(pcm));//In OR Out fade
    repeat
      //  float weight = 0.5 * (1 - cos(M_PI * s / (numFadeSamples - 1)));
      weight := (0.5 * (1 - cos((Pi * sampleNum / (durationSamples - 1)))));
      //pcm[sampleNum] := Trunc(pcm[sampleNum] * weight);                          //fade in
      pcm[high(pcm) - sampleNum] := Trunc(pcm[high(pcm) - sampleNum] * weight);
      //fade out
      Inc(sampleNum);
    until sampleNum > durationSamples;
  end;

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
    durationSamples := round(lengthMs / 1000 * samplerate) * Channels;
    sampleNum := 0;
    if durationSamples > high(pcm) then
      durationSamples := trunc(High(pcm) / 2);//In AND Out fade
    //if durationSamples > high(pcm) then durationSamples:= trunc(High(pcm));//In OR Out fade
    repeat
      //  float weight = 0.5 * (1 - cos(M_PI * s / (numFadeSamples - 1)));
      weight := (0.5 * (1 - cos((Pi * sampleNum / (durationSamples - 1)))));
      pcm[sampleNum] := Trunc(pcm[sampleNum] * weight);
      //fade in
      pcm[high(pcm) - sampleNum] := Trunc(pcm[high(pcm) - sampleNum] * weight);
      //fade out
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
        fadeIn<Int16>(pcm, max, Ord(fChannels), fSampleRate);
      ftOut:
        fadeOut<Int16>(pcm, max, Ord(fChannels), fSampleRate);
      ftBoth:
        fadeInOut<Int16>(pcm, max, Ord(fChannels), fSampleRate);
    end;

  end;

var
  d: TwaveFader;
  pcm: array [0..44100] of uint16;
  x: integer;
begin
  x := 0;
  while x <= high(pcm) do
  begin
    pcm[x] := 27000;
    Inc(x);
  end;

  fadeInOut<uInt16>(pcm, 10, 1);

end.
