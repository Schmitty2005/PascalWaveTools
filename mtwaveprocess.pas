unit MTWaveProcess;

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
    procedure Execute; override;
    constructor Create(aPCM: TwavePCM; const startPos, Endpos: uint64;
      dspFunction: TwaveGenStyleExt); overload;
  end;

procedure mtDspProcess(aPCM: TwavePCM; dspFunction: TwaveGenStyleExt;
  const CPUCores: byte = 3);

implementation

procedure mtDspProcess(aPCM: TwavePCM; dspFunction: TwaveGenStyleExt;
  const CPUCores: byte = 3);
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
begin
  { #todo -oB : Create Thread  }
  sleep(10);
end;

constructor TmtWaveProc.Create(aPCM: TwavePCM; const startPos, Endpos: uint64;
  dspFunction: TwaveGenStyleExt);
begin
  {Setup thread auto free here}
  inherited Create(False);
end;

end.
