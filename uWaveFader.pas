{$IFDEF FPC}
{$mode delphi}
{$ENDIF}
program uWaveFade;
  {Implementation}

  {$IFDEF FPC}
uses classes;
  {$ENDIF}
  {$IFDEF DCC}
Uses System.Classes;
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

  {Interface}
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
