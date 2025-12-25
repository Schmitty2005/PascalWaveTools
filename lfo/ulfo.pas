{$mode delphi}

unit ulfo;

interface

type
  {
  TlfoWaveTypes = (lfoSine, lfoTriangle, lfoSquare, lfoSaw);
  //likely will not be used. Use interfaces instead
  }
  TlfoWave = array of int16;

  TlfoProcedure = procedure(var aPcm: TlfoWave; aFreq: double;
    aSampleRate: uInt64 = 44100);
  
  TlfoSettings = record
    FreqHz: double;
    Amplitude: Uint32;
  end;

  //TlfoWave = array of int16;
  
  IlfoOutput = interface
    function lfoWave(aFreqHz: double): TlfoWave;
  end;

  TlfoBase = class abstract (TinterfacedObject, IlfoOutput)
  type
    TlfoPCM = array of int16;
  protected
    fSampleRate: uint64;
    fPCM: TlfoPCM;
    fFrequency: double;
    procedure setFreq(aFreq: double);
  public
    constructor Create(aSampleRate: uInt64);// virtual;//abstract;
    function lfoWave(aFreqHz: double): TlfoPCM;virtual;abstract;
    property Freq: double read fFrequency;// write fFrequency;
    property lfoPCM: TlfoPCM read fPCM;
  end;

  { TlfoWaveProcGen }

  TlfoWaveProcGen = class(TlfoBase)
  private
    fLfoProc: TlfoProcedure;
  public
    constructor Create(aFreq : double; aSampleRate: uInt64; aLfoWaveProc: TlfoProcedure);
    function lfoWave(aFreqHz: double): TlfoPCM;override;
  end;

implementation

constructor TlfoBase.Create(aSampleRate: uInt64);
begin
  fSampleRate := aSampleRate;
end;

procedure TlfoBase.setFreq(aFreq: double);
begin
  fFrequency := aFreq;
  { 
  run inherited in child class
  Generate LFO wave here.
  it should be a length of one wave cycle. 
  assign 16-bit mono pcm to fPCM.
  }
end;

constructor TlfoWaveProcGen.Create(aFreq: Double; aSampleRate: uInt64; aLfoWaveProc: TlfoProcedure);
begin
  fLfoProc := aLfoWaveProc;
  fSampleRate:= aSampleRate;
  fFrequency := aFreq;
end;

function TlfoWaveProcGen.lfoWave(aFreqHz: double): TlfoPCM;
begin
   fLfoProc(fPCM, fFrequency, fSampleRate);
end;


/////////////////////////////////////////////////////////////////////////////
//////////////////probably don't need ////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
{
TlfoWaveGen = class abstract 
(TinterfacedObject)
type 
   Tpcm = array of int16;
   TsampleRate = 1..192000;
private 
  fLfoWave : array of int16;
  fHertz : double;
  procedure generate(aHz:double); virtual; abstract;
  
public 
  constructor create(aSampleRate: TsampleRate; aFreq : double); virtual;abstract;
  function lfoWave (aFreqHz: double):TlfoWave;virtual;abstract;
  property FreqHz :double read fHertz write fHertz;
  property pcm : Tpcm read fLfoWave;
end;
}


{Ttest=class(TlfoWaveGen)
end;}
{
  constructor TlfowaveGen.create(aSampleRate: TsampleRate; aFreq : double);
  begin
  end;
}


{
procedure TlfoWaveGen.generate(aHz:double);
begin
  fHertz := aHz;
  //call generation procedure
end;
}

begin
end.
