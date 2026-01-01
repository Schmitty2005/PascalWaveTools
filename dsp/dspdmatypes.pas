unit dspDMATypes;

{$mode Delphi}

interface

type

  PdspProcedureDM = ^TdspProcedureDM;

  TdspProcedureDM = procedure(const location: Pint16; const aLength: uint64;
    const aDspData: Pointer = nil);

  IdspDMAProcess = interface
    ['{2B2DB825-7C0F-4ABA-9D4D-557915ACE857}']
    procedure process(const location: Pint16; const aLength: uint64;
      const aDspData: Pointer = nil);
  end;

  { TdspDMABase }

  TdspDMABase = class abstract (TinterfacedObject, IdspDMAProcess)
  protected
    fSampleRate: uint32;
    fData: Pointer;
  public
    constructor Create(aSampleRate: uint32; aData: pointer = nil); virtual;
    procedure process(const location: Pint16; const aLength: uint64;
      const aDspData: Pointer = nil); virtual; abstract;
  end;



implementation

{ TdspDMABase }

constructor TdspDMABase.Create(aSampleRate: uint32; aData: pointer);
begin
  fSampleRate := aSampleRate;
  fData := aData;
end;

end.
