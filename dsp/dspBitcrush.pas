{$mode delphi}

Unit dspBitCrush;

Interface

Type 
{Move these to dspTypes.pas later}
  PdspProcesure = ^TdspProcedure;

  TdspProcedure = Procedure (
                             Var aPcm : Array Of int16;
                             beginIndex,
                             endIndex : uInt64;
                             aDspData: Pointer);

  PbitCrushTo = ^TbitCrushTo;
  TbitCrushTo = 2..14;

  PbitCrushParam = ^TbitCrushParam;

  TbitCrushParam = Record
    sourceDepth : byte;
    desiredDepth : byte;
  End;

Procedure bitCrush(
                   Var aPcm : Array Of int16;
                   beginIndex,
                   endIndex : uInt64;
                   aDspData: Pointer);

Implementation

Procedure bitCrush(
                   Var aPcm : Array Of int16;
                   beginIndex,
                   endIndex : uInt64;
                   aDspData: Pointer);

Var 
  p : PbitcrushTo absolute aDspData;
  x : uInt64;
Begin
  p^ := 16 - p^;
  For x:= beginIndex To endIndex Do
    Begin
      aPCM[x] := apcm[x] shr p^;
      aPCM[x] := apcm[x] shl p^;
      writeln(aPcm[x]);
    End;
End;


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
End.
