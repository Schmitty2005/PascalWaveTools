{$IFDEF FPC}
{$mode delphi}
{$ENDIF}
program uWaveFader;

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

(*
Generic functions / procedures are not allowed in global functions when using the Delphi Compiler. 
They are allowed in FPC ! :)
*)
{$IFDEF FPC}
  {$INCLUDE fadeprocs.inc}
{$ENDIF}


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
  {$IFDEF DCC}
  (*  Delphi cannot have global functions / procedures with generics ...so they will go here... WTF...*)
  {$INCLUDE fadeprocs.inc}
  {$ENDIF}
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
