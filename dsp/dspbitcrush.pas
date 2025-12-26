{$mode delphi}

unit dspbitcrush;

interface

uses dspTypes;

type

  PbitCrushParam = ^TbitCrushParam;

  TbitCrushParam = record
    sourceDepth: byte;
    crushDepth: byte;
  end;

  { Tbitcrusher }

  Tbitcrusher = class(TdspBase)
  private
    fpp: PbitCrushParam;
    fbp: TbitCrushParam;
  public
    constructor Create(aSampleRate: uint32; aData: pointer = nil); override;
    procedure process(aPcm: array of int16; const aData: Pointer = nil); override;
  end;

procedure bitCrush(var aPcm: array of int16; const beginIndex, endIndex: uint64;
  const aDspData: Pointer);

implementation


procedure bitCrush(var aPcm: array of int16; const beginIndex, endIndex: uint64;
  const aDspData: Pointer);
var
  p: PbitcrushParam absolute aDspData;
  x: uint64;
begin
  p^.CrushDepth := p^.sourceDepth - p^.CrushDepth;
  for x := beginIndex to endIndex do
  begin
    aPCM[x] := apcm[x] shr p^.CrushDepth;
    aPCM[x] := apcm[x] shl p^.CrushDepth;
  end;
end;

{ Tbitcrusher }

constructor Tbitcrusher.Create(aSampleRate: uint32; aData: Pointer);
begin
  inherited Create(aSampleRate, aData);
  fpp := aData;
  fbp := fpp^;
end;

procedure Tbitcrusher.process(aPcm: array of int16; const aData: Pointer);
var
  pbp: PbitCrushParam absolute aData;
begin
  bitCrush(aPCM, low(aPCM), high(aPCM), fpp);
end;

end.
