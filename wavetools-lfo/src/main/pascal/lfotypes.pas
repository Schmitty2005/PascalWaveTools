{$IFDEF FPC}
{$mode delphi}
{$ENDIF}
unit lfoTypes;

interface

const
  cDefSampRate = 44100;

type
  TlfoPCM = array of int16;

  TlfoFloat = array of single;



  TlfoRec = record
    lfoPCM: TlfoPCM;
    lfoFloat: TlfoFloat;
  end;

  TlfoProcedure = procedure(var aPCM: TlfoPCM; aFreq: double;
    aSampleRate: uint32 = cDefSampRate);

  TlfoProcedureRec = procedure(var aPCMRec: TlfoRec; aFreq: double;
    aSampleRate: uint32 = cDefSampRate);

  IgetLFOwave = interface
    procedure lfoWave(var aPCM: TlfoPCM; aFreq: double);
  end;

  { TlfoBase }

  TlfoBase = class abstract(TinterfacedObject, IgetLfoWave)
  protected
    fProc: TlfoProcedure;
    fFreq: double;
    fSampleRate: uint64;
    fpcm: TlfoPCM;
  public
    constructor Create(aFreq: double; aSampleRate: uint64); virtual;
    procedure lfoWave(var aPCM: TlfoPCM; aFreq: double); virtual; abstract;
    property freq: double read fFreq;
    property lfoPCM: TlfoPCM read fpcm;
    property lfoProc: TlfoProcedure write fProc;
  end;

implementation

{ TlfoBase }

constructor TlfoBase.Create(aFreq: double; aSampleRate: uint64);
begin
  fFreq := aFreq;
  fSampleRate := aSampleRate;
end;

end.
