unit dspthreads;
{$IFDEF FPC}
{$mode ObjFPC}{$H+}
{$ENDIF}
{
Newest and up to date version of multi thread classes for dsp
}
interface

uses
  Classes, SysUtils, mtSetup;

type
  TdspProc = procedure(aStartPoint: Pint16; aEndPoint: Pint16; aData: Pointer = nil);

  { TdspThread }

  TdspThread = class(TThread)
  private
    fDSPProc: TdspProc;
    fStartPoint: PInt16;
    fEndPoint: PInt16;
    fData: Pointer;
  protected
    procedure execute; override;
  public
    constructor Create(aStartPoint: Pint16; aEndPoint: Pint16;
      aDSPProc: TdspProc; aData: Pointer = nil);
  end;

  { TdspRunner }

  TdspRunner = class(TThread)
  private
    fDSPProc: TdspProc;
    fStartPoint: PInt16;
    fEndPoint: PInt16;
    fData: Pointer;
    fCPUCores: byte;
    fDSPThreads: array of TdspThread;
    fPointerBlocks: TblocksP;
  protected
    procedure Execute; override;
  public
    constructor Create(aFirstPointer: Pint16; aLastPointer: Pint16;
      aDSPProc: TdspProc; aCpuCores: byte = 3; aData: Pointer = nil);
  end;

implementation

{ TdspThread }

procedure TdspThread.execute;
begin
  fDSPProc(fStartPoint, fEndPoint, fData);
end;

constructor TdspThread.Create(aStartPoint: Pint16; aEndPoint: Pint16;
  aDSPProc: TdspProc; aData: Pointer);
begin
  inherited Create(True);
  fStartPoint := aStartPoint;
  fEndPoint := aEndPoint;
  fDSPProc := aDSPProc;
  fData := aData;
  //FreeOnTerminate:= True;
end;

{ TdspRunner }

procedure TdspRunner.Execute;
var
  Count: byte;
begin
  //run all of the threads and waitFor;
  for Count := 0 to fCPUCores - 1 do
    fDSPThreads[Count].Start;

  for Count := 0 to fCPUCores - 1 do
    fDSPThreads[Count].WaitFor;

  //Maybe use free on terminate property for TdspThread class instead ?
  for Count := 0 to fCPUCores - 1 do
    fDSPThreads[Count].Free;
end;

constructor TdspRunner.Create(aFirstPointer: Pint16; aLastPointer: Pint16;
  aDSPProc: TdspProc; aCpuCores: byte; aData: Pointer);
var
  Count: byte;
begin
  inherited Create(True);
  fStartPoint := aFirstPointer;
  fEndPoint := aLastPointer;
  fDSPProc := aDSPProc;
  fData := aData;
  fCPUCores := aCpuCores;
  fPointerBlocks := calcBlockRangesP(fStartPoint, (fEndPoint - fStartPoint), fCPUCores);
  SetLength(fDSPThreads, fCPUCores);
  //setup threads
  for Count := 0 to fCPUCores - 1 do
    fDSPThreads[Count] := TdspThread.Create(fPointerBlocks[Count].firstPointer,
      fPointerBlocks[Count].lastPointer, fDSPProc, fData);
end;

end.
