{$MODE DELPHI}
unit dspTypes;

interface

type

  PbitCrushTo = ^TbitCrushTo;
  TbitCrushTo = 2..14;

  PdspProcedure = ^TdspProcedure;

  TdspProcedure = procedure(var aPcm: array of int16;
    beginIndex, endIndex: uInt64;
    aDspData: Pointer);

  IdspProcess = interface
    procedure process(aPcm: array of int16; aData: Pointer = nil);
  end;

  TdspBase = class abstract (TinterfacedObject, IdspProcess)
  private
    fSampleRate: uInt32;
    fData: Pointer;
  public
    constructor Create(aSampleRate: uint32; aData: pointer = nil); virtual;
    procedure process(aPcm: array of int16; aData: Pointer = nil); virtual; abstract;
  end;

  PbitCrushParam = ^TbitCrushParam;

  TbitCrushParam = record
    sourceDepth: byte;
    crushDepth: byte;
  end;

implementation

constructor TdspBase.Create(aSampleRate: uint32; aData: pointer = nil);
begin
  fSampleRate := aSampleRate;
  fData := aData;
end;


end.
