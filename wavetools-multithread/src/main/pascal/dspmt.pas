unit dspmt;
{$IFDEF FPC}
{$mode ObjFPC}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, mtSetup, dspTypes;

type

  { TdspThread }

  TdspThread = class(TThread)
  private
    fDSPproc: TdspProcedureDM;
    fStartIndex: Pointer;
    fEndIndex: Pointer;
    fData: Pointer;
  protected
    procedure Execute; override;
  public
    constructor Create(aDSPProc: TdspProcedureDM; aStartPointer: Pointer;
      aEndPointer: Pointer; aData: Pointer = nil);
  end;

  { TdspRunner }

  TdspRunner = class(TThread)
  private
    fNumCores: byte;
    fThreadArr: array of TdspThread;
    fDspProcDM: TdspProcedureDM;
    fBlocks: TblocksP;
    fStartPointer: Pointer;
    fLengthArr: uint64;
    fData: Pointer;
  protected
    procedure Execute; override;
  public
    constructor Create(aStartPoint: Pointer; aTotalLength: uint64;
      aDSPProc: TdspProcedureDM; aNumCores: byte = 3; aData: Pointer = nil);
  end;

implementation

{ TdspThread }

procedure TdspThread.Execute;
begin
  // do dspProcDM call here
  fDSPproc(fStartIndex, fEndIndex - fStartIndex, fData);
end;

constructor TdspThread.Create(aDSPProc: TdspProcedureDM; aStartPointer: Pointer;
  aEndPointer: Pointer; aData: Pointer);
begin
   fDSPproc:= aDSPProc;
   fStartIndex:= aStartPointer;
   fEndIndex:= aEndPointer;
   fData := aData;
  inherited Create(False); //try this start on creation first! Suspend if issues!
end;

{ TdspRunner }

procedure TdspRunner.Execute;
var
  x: byte;
begin

  for x := 0 to fNumCores do
  begin
     fThreadArr[x]:=TdspThread.create(fDspProcDM, fBlocks[x].firstPointer,
     fBlocks[x].lastPointer,@fData);
     {  Check to make sure proper first and last pointers are correct and passed
        correctly!  }
    //set up threads to execute immedietly!
    //and wait for them to finish

  end;
end;

constructor TdspRunner.Create(aStartPoint: Pointer; aTotalLength: uint64;
  aDSPProc: TdspProcedureDM; aNumCores: byte; aData: Pointer);
begin
  inherited Create(True);
  fNumCores := aNumCores;
  fStartPointer := aStartPoint;
  fDspProcDM := aDSPProc;
  fData := aData;
  fLengthArr := aTotalLength;
  //fBlocks := calcBlockRangesP(fStartPointer, aTotalLength, aNumCores);
  setLength(fThreadArr, fNumCores);
end;

end.
