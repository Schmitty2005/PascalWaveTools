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

  procedure mtDspProcess ( aPCM: TwavePCM; const CPUCores : Byte = 3);

implementation

procedure mtDspProcess(aPCM: TwavePCM; const CPUCores: Byte);
begin
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

  inherited Create(True);
end;

end.
