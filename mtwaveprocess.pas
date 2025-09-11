unit MTWaveProcess;
{THIS UNIT IS a MESS and  will not be used in future}
{$mode Delphi}

interface

uses
  {$IFDEF LINUX}
  cthreads,
  {$ENDIF}
  Classes, SysUtils, wavegen;

type

  { TmtWaveProc }

  TmtWaveProc = class(TThread)
  private
    fStart: uint64;
    fEnd: uint64;
    fDSP: TwaveGenStyleExt;
    fSampleRate: integer;
    fHertz: double;
    fLengthMilliSec: uint64;
    fPCM: TwavePCM;
    fWaveSpecs: TWaveStyleSpecs;
    public
    procedure Execute; override;
    constructor Create(var aPCM: TwavePCM; const startPos, Endpos: uint64;
      dspFunction: TwaveGenStyleExt); overload;
    constructor Create(var aWaveStyleSpecs: TWaveStyleSpecs;
      dspFunction: TwaveGenStyleExt; const CPUCores: byte=3); overload;
  end;

procedure mtDspProcess(var aPCM: TwavePCM; dspFunction: TwaveGenStyleExt;
  var aWaveStyleSpec: TWaveStyleSpecs; const CPUCores: byte = 3);

implementation

procedure mtDspProcess(var aPCM: TwavePCM; dspFunction: TwaveGenStyleExt;
  var aWaveStyleSpec: TWaveStyleSpecs; const CPUCores: byte = 3);
var
  StartPos: array of uint64;
  lengthSegment: uint64;
  arPos: uint64;
  endPos: uint64;
  threadPool: array of TmtWaveProc;
begin
  SetLength(StartPos, CPUCores);
  //setup start and end positions for threads to use
  lengthSegment := High(aPCM) div CPUCores;
  StartPos[0] := Low(aPCM);
  arPos := 0;
  while arPos <= (CPUCores - 1) do
  begin
    StartPos[arPos] := arpos * lengthSegment;
    Inc(arPos);
  end;

  //setup threads using start and end positions;
  SetLength(threadPool, (CPUCores));

    arPos := 0; //reuse variable
  //sleep(200);  {Needed to prevent crash  ?   Why ? }
  while (arPos <= High(threadPool)) do
  begin
    if arPos >= High(StartPos) then endPos := High(aPCM)
    else
      endpos := StartPos[arPos + 1];
    threadpool[arPos] := TmtWaveProc.Create(aPCM, StartPos[arPos],
      endPos, dspFunction);
    Inc(arPos);
  end;

  //Wait for threads

  //be sure to Free Threads with autofree set
  {Use the TmtWaveProc class to process PCM data}
end;

{ TmtWaveProc }

procedure TmtWaveProc.Execute;
var
  pos: uint64;
begin
  pos := fStart;
  while pos <= fEnd do
  begin

  end;
  //fDSP(aPCM,
  { #todo -oB : Create Thread  }
end;

constructor TmtWaveProc.Create(var aPCM: TwavePCM; const startPos,
  Endpos: uint64; dspFunction: TwaveGenStyleExt);
begin
  {Setup thread auto free here}
  //FreeOnTerminate := True;//Temp Disable for debug!
  //fWaveSpecs := aWaveStyleSpec;
  fStart := startPos;
  fEnd := EndPos;
  fDSP := dspFunction;
  fPCM := aPCM;

  inherited Create(False);
end;

constructor TmtWaveProc.Create(var aWaveStyleSpecs: TWaveStyleSpecs;
  dspFunction: TwaveGenStyleExt; const CPUCores: byte = 3);
var
  StartPos: array of uint64;
  lengthSegment: uint64;
  arPos: uint64;
  endPos: uint64;
  threadPool: array of TmtWaveProc;
begin
  SetLength(StartPos, CPUCores);
  //setup start and end positions for threads to use
  lengthSegment := High(aWaveStyleSpecs.aPCM) div CPUCores;
  StartPos[0] := Low(aWaveStyleSpecs.aPCM);
  arPos := 0;
  while arPos <= (CPUCores - 1) do
  begin
    StartPos[arPos] := arpos * lengthSegment;
    Inc(arPos);
  end;

  //setup threads using start and end positions;
  SetLength(threadPool, (CPUCores));
  arPos := 0; //reuse variable
  while (arPos <= High(threadPool)) do
  begin
    if arPos >= High(StartPos) then endPos := High(aWaveStyleSpecs.aPCM)
    else
      endpos := StartPos[arPos + 1];
    threadpool[arPos] := TmtWaveProc.Create(aWaveStyleSpecs.aPCM,
      StartPos[arPos], endPos, dspFunction);
    Inc(arPos);
  end;

  //Wait for threads

  //be sure to Free Threads with autofree set
  {Use the TmtWaveProc class to process PCM data}
end;

end.
