{$mode objfpc}
//Program dspTwo;
unit dspProcs;

interface

uses Classes, SysUtils, Math;

type
  TdspProc = procedure(aStartPoint: Pint16; aEndPoint: Pint16; aData: Pointer = nil);

procedure dspSaturate(aStartPoint: Pint16; aEndPoint: Pint16; aData: Pointer = nil);

procedure dspBitCrush(aStartPoint: Pint16; aEndPoint: Pint16; aData: Pointer = nil);



implementation

procedure dspSaturate(aStartPoint: Pint16; aEndPoint: Pint16; aData: Pointer = nil);
var
  gain: Psingle absolute aData;
  sample: Pint16;
  Count: uint64;
  max: uint64;
  calc: single;
begin
  {$pointermath on}
  max := aEndPoint - aStartPoint;
  sample := aStartPoint;
  ;
  for Count := 0 to max do
  begin
    //writeln (format ('%P', [sample]));
    calc := sample^ / High(int16);
    calc := tanh(calc * gain^);
    sample^ := trunc(calc * high(int16));
    Inc(sample);
  end;
  {$pointermath off}
end;

procedure dspBitCrush(aStartPoint: Pint16; aEndPoint: Pint16; aData: Pointer = nil);
var
  bcdepth: pbyte absolute aData;
  crush: byte;
  sample: Pint16;
  max: uint64;
  Count: uint64;
begin
  {$pointermath on}
  crush := 16 - bcDepth^;
  sample := aStartPoint;
  max := aEndPoint - aStartPoint;
  for Count := 0 to max do
  begin
    sample^ := sample^ shr crush;
    sample^ := sample^ shl crush;
    Inc(sample);
  end;
  {$pointermath off}
end;


{
var
  satGain : single;
  arr : array of int16;
  bitCrush : byte;

Begin
  setLength(arr,44100);
  fillWord(arr[0], 44099, 16278);
  writeln(arr[0]);
  
  satGain := 6.25;
    
  dspSaturate (@arr[0], @arr[44099], @satGain);

  writeln(arr[0]);

  bitcrush :=8;

  dspBitCrush (@arr[0], @arr[44099], @bitcrush);

  writeln(arr[0]);
}
end.
