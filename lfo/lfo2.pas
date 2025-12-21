{$mode delphi}

Unit lfo2;

Interface

Const 
  cDefSampRate = 44100;

Type 
  TlfoPCM = array Of int16;
  // move to wavetools types later ? 

  TlfoFloat = array Of single;
  //move to wavetools types later ? 

  TsampleRate = 1..192000;
  //move to types later

  TlfoRec = Record
    lfoPCM  : TlfoPCM;
    lfoFloat : TlfoFloat;
  End;



  TlfoProcedure = Procedure (Var aPCM : TlfoPCM; aFreq: double; aSampleRate : uint32 = cDefSampRate)
  ;

  TlfoProcedureRec = Procedure (Var aPCMRec : TlfoRec; aFreq: double; aSampleRate :uInt32= cDefSampRate);

  IgetLFOwave =  Interface
    Procedure lfoWave(aPCM : TlfoPCM ; aFreq : double);
  End;

TlfoBase = Class abstract(TinterfacedObject, IgetLfoWave)
  Private 
    fProc : TlfoProcedure;
    fFreq: double;
    fSampleRate : uint64;
    fpcm : TlfoPCM;
  Public 
    constructor create (aFreq: double; aSampleRate :uint64);
    virtual;
    abstract;
    Procedure lfoWave(aPCM : TlfoPCM ; aFreq : double);
    virtual;
    abstract;
    property freq : double read fFreq;
    property lfoPCM  : TlfoPCM read fpcm;
    property lfoProc : TlfoProcedure write fProc;
End;

Implementation

Procedure lfoSine(Var aPCM : TlfoPCM; aFreq: double; aSampleRate : uint32 = cDefSampRate);

Var 
  l, x: integer;
  w: double;
Begin
  l := round(aSampleRate / aFreq);
  w := 2 * Pi * aFreq / aSamplerate;
  setLength(aPCM, l);
  For x:= low(apcm) To l Do
    aPCM[x] := trunc( sin(x *w) * high(int16));

End;


Procedure lfoSineRec(Var aPCM : TlfoRec; aFreq: double; aSampleRate : uint32 = cDefSampRate);

Var 
  l, x: integer;
  w: double;
Begin
  l := round(aSampleRate / aFreq);
  w := 2 * Pi * aFreq / aSamplerate;
  setLength(aPCM.lfoPCM, l);
  setLength(aPCM.lfoFloat, l);
  For x:= low(apcm.lfoPcm) To l Do
    Begin
      aPCM.lfoPCM[x] := trunc( sin(x *w) * high(int16));
      aPCM.lfoFloat[x] := sin(x *w);
    End;
End;

{
var
  x:integer;
  a:TlfoPCM;
Begin
//lfoSine(a, 100);
    
//	for x:=low(a) to high(a) do
//	write(a[x],', ');
}
End.
