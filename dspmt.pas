unit dspmt;
{$IFDEF FPC}
{$mode ObjFPC}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, mtSetup, dspTypes;

type
  TdspThread = class(TThread)

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
    fData : Pointer;
  protected
    procedure Execute;override;
  public
    constructor Create(aStartPoint: Pointer; aTotalLength: uint64;
      aDSPProc: TdspProcedureDM; aNumCores: byte = 3; aData: Pointer = nil);
  end;

implementation

{ TdspRunner }

procedure TdspRunner.Execute;
var
  x: byte;
begin

  for x := 0 to fNumCores do
  begin
    //
    //set up threads to execute immedietly!
    //and wait for them to finish
    //
  end;
end;

constructor TdspRunner.Create(aStartPoint: Pointer; aTotalLength: uint64;
  aDSPProc: TdspProcedureDM; aNumCores: byte; aData: Pointer);
begin
  inherited create(true);
  fNumCores := aNumCores;
  fStartPointer:= aStartPoint;
  fDspProcDM:= aDSPProc;
  fData := aData;
  fLengthArr := aTotalLength;
  fBlocks := calcBlockRangesP(fStartPointer, aTotalLength, aNumCores);
  setLength (fThreadArr, fNumCores);
end;

end.
