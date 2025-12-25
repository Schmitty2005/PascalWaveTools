{$mode delphi}

unit dspBitCrush;

interface
(*
type
  {Move these to dspTypes.pas later}
  PdspProcesure = ^TdspProcedure;

  TdspProcedure = procedure(var aPcm: array of int16;
    beginIndex, endIndex: uInt64;
    aDspData: Pointer);
  {========================================================}
  PbitCrushTo = ^TbitCrushTo;
  TbitCrushTo = 2..14;

  PbitCrushParam = ^TbitCrushParam;

  TbitCrushParam = record
    sourceDepth: byte;
    crushDepth: byte;
  end;
*)
procedure bitCrush(var aPcm: array of int16;
  beginIndex, endIndex: uInt64;
  aDspData: Pointer);

procedure bitCrush2(var aPcm: array of int16;
 beginIndex, endIndex: uInt64;
  aDspData: Pointer);

implementation

uses dspTypes;

procedure bitCrush(var aPcm: array of int16;
  beginIndex, endIndex: uInt64;
  aDspData: Pointer);

var
  p: PbitcrushTo absolute aDspData;
  x: uInt64;
begin
  p^ := 16 - p^;
  for x := beginIndex to endIndex do
  begin
    aPCM[x] := apcm[x] shr p^;
    aPCM[x] := apcm[x] shl p^;
    writeln(aPcm[x]);
  end;
end;

procedure bitCrush2(var aPcm: array of int16;
 beginIndex, endIndex: uInt64;
  aDspData: Pointer);
var
  p: PbitcrushParam absolute aDspData;
  x: uInt64;
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




{
var
  ar : array of int16;  
  bc : TbitCrushTo;
begin
  setlength(ar, 5);
  ar := [32767, 16673, 8198, 4096, 2048, 1024];
 
  bc := 4;

  bitcrush(ar, 0, 5, @bc);
  }
end.
