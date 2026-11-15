unit lfoSine;
{$IFDEF FPC}
{$mode ObjFPC}{$H+}
{$ENDIF}
{ #todo -oB : Implement TlfoRec procedure in another class for making float lfo and pcm lfo at same time. }
interface

uses
  lfoTypes;

type

  { TlfoSin }

  TlfoSin = class(TlfoBase)
  public
    constructor Create(aFreq: double; aSampleRate: uint64); override;
    procedure lfoWave(var aPCM: TlfoPCM; aFreq: double); override;
  end;

implementation

procedure lfoSineRec(var aPCM: TlfoRec; aFreq: double;
  aSampleRate: uint32 = cDefSampRate);
var
  l, x: integer;
  w: double;
begin
  l := round(aSampleRate / aFreq);
  w := 2 * Pi * aFreq / aSamplerate;
  setLength(aPCM.lfoPCM, l);
  setLength(aPCM.lfoFloat, l);
  for x := low(apcm.lfoPcm) to l do
  begin
    aPCM.lfoPCM[x] := trunc(sin(x * w) * high(int16));
    aPCM.lfoFloat[x] := sin(x * w);
  end;
end;

procedure lfoSine(var aPCM: TlfoPCM; aFreq: double; aSampleRate: uint32 = cDefSampRate);
var
  l, x: integer;
  w: double;
begin
  l := round(aSampleRate / aFreq);
  w := 2 * Pi * aFreq / aSamplerate;
  setLength(aPCM, l);
  for x := low(apcm) to l do
    aPCM[x] := trunc(sin(x * w) * high(int16));
end;

{ TlfoSin }

constructor TlfoSin.Create(aFreq: double; aSampleRate: uint64);
begin
  inherited Create(aFreq, aSampleRate);
  fProc := @lfoSine;
end;

procedure TlfoSin.lfoWave(var aPCM: TlfoPCM; aFreq: double);
begin
  fProc(aPCM, aFreq, fSampleRate);
end;



end.
