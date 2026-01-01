{$IFDEF FPC}
{$MODE delphi}
{$ENDIF}
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
    procedure process(var aPcm: array of int16;
      const aData: pointer = nil); override;
  end;

procedure bitCrush(var aPcm: array of int16; const beginIndex, endIndex: uint64;
  const aDspData: pointer);

implementation

procedure bitCrush(var aPcm: array of int16; const beginIndex, endIndex: uint64;
  const aDspData: pointer);
var
  p: PbitCrushParam absolute aDspData;
  z: uint64;
  crush : byte;
begin
  crush := p^.sourceDepth - p^.crushDepth;
{$R-}
  for z := beginIndex to endIndex do
  begin
    aPcm[z] := aPcm[z] shr crush;
    aPcm[z] := aPcm[z] shl crush;
  end;
{$R+}
end;

{ Tbitcrusher }

constructor Tbitcrusher.Create(aSampleRate: uint32; aData: pointer);
begin
  inherited Create(aSampleRate, aData);
  fpp := aData;
  fbp := fpp^;
end;

procedure Tbitcrusher.process(var aPcm: array of int16; const aData: pointer);
var
  pbp: PbitCrushParam absolute aData;
begin
  bitCrush(aPcm, low(aPcm), high(aPcm), fpp);
end;

end.
