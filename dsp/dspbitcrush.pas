{$mode delphi}

unit dspbitcrush;

interface

type

  PbitCrushParam = ^TbitCrushParam;

  TbitCrushParam = record
    sourceDepth: byte;
    crushDepth: byte;
  end;

procedure bitCrush(var aPcm: array of int16; const beginIndex, endIndex: uint64;
  const aDspData: Pointer);

implementation

uses dspTypes;

procedure bitCrush(var aPcm: array of int16; const beginIndex, endIndex: uint64;
  const aDspData: Pointer);
var
  p: PbitcrushParam absolute aDspData;
  x: uint64;
begin
  p^.CrushDepth := p^.sourceDepth - p^.CrushDepth;
  writeln(p^.CrushDepth);
  for x := beginIndex to endIndex do
  begin
    aPCM[x] := apcm[x] shr p^.CrushDepth;
    aPCM[x] := apcm[x] shl p^.CrushDepth;
    writeln(aPcm[x]);
  end;
end;

end.
