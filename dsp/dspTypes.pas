{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}
unit dspTypes;

interface

type

  PdspProcedure = ^TdspProcedure;

  TdspProcedure = procedure(
    var aPcm: array of int16;
    const beginIndex, endIndex: uint64;
    const aDspData: Pointer);

  IdspProcess = interface
    procedure process(aPcm: array of int16; const aData: Pointer = nil);
  end;

  TdspBase = class abstract (TinterfacedObject, IdspProcess)
  private
    fSampleRate: uint32;
    fData: Pointer;
  public
    constructor Create(aSampleRate: uint32; aData: pointer = nil); virtual;
    procedure process(aPcm: array of int16; const aData: Pointer = nil);
      virtual; abstract;
  end;


implementation

constructor TdspBase.Create(aSampleRate: uint32; aData: pointer = nil);
begin
  fSampleRate := aSampleRate;
  fData := aData;
end;


end.
