{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}
unit dspTypes;

interface

type

  PdspProcedure = ^TdspProcedure;

  TdspProcedure = procedure(var aPcm: array of int16;
    const beginIndex, endIndex: uint64; const aDspData: Pointer);

  TdspProcedureDM = procedure (const location: Pint16; const aLength: uint64;
  const aDspData: Pointer = nil);

  IdspProcess = interface
    ['{66EB5D6B-8528-43B2-8E3B-799C402703C3}']
    procedure process(var aPcm: array of int16; const aData: Pointer = nil);
  end;

  TdspBase = class abstract (TinterfacedObject, IdspProcess)
  protected
    fSampleRate: uint32;
    fData: Pointer;
  public
    constructor Create(aSampleRate: uint32; aData: pointer = nil); virtual;
    procedure process(var aPcm: array of int16; const aData: Pointer = nil);
      virtual; abstract;
  end;


implementation

constructor TdspBase.Create(aSampleRate: uint32; aData: pointer = nil);
begin
  fSampleRate := aSampleRate;
  fData := aData;
end;


end.
