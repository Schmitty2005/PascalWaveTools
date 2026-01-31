{$IFDEF FPC}
{$mode objfpc}
{$ENDIF}
//Program dspTwo;
unit dspProcs;

interface

uses Classes, SysUtils, Math;

type
  {$IFDEF DCC}
 Pint16 = ^Int16;
  {$ENDIF}
  TdspProc = procedure(aStartPoint: Pint16; aEndPoint: Pint16; aData: Pointer = nil);

  PlimitThreshSet = ^TlimitThreshSet;

  TlimitThreshSet = record
    Threshold: int16;
    Gain: single;
  end;

  TsatFunc = function(aSample: single; aGain: single): single;

  TasymSettimgs = record
    posSatFunction: TsatFunc;
    negSatFunction: TsatFunc;
    posLimit: int16;
    negLimit: int16;
    posGain: single;
    negGain: single;
  end;


procedure dspSaturate(aStartPoint: Pint16; aEndPoint: Pint16; aData: Pointer = nil);

procedure dspBitCrush(aStartPoint: Pint16; aEndPoint: Pint16; aData: Pointer = nil);

procedure dspLimitThresh(aStartPoint: Pint16; aEndPoint: Pint16; aData: Pointer = nil);
{ #todo -oB : Test procedure dspLimitThresh

 }

procedure dspSaturate2(aStartPoint: Pint16; aEndPoint: Pint16; aData: Pointer = nil);


//Simple saturation functions for asymetrical distortion dsp
function noSat(aSample: single; aGain: single): single;

function Sat1(aSample: single; aGain: single): single;

function Sat2(aSample: single; aGain: single): single;

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
  crushed: int16;
  max: uint64;
  Count: uint64;
begin
  {$pointermath on}
  crush := 16 - bcDepth^;
  sample := aStartPoint;
  max := aEndPoint - aStartPoint;
  for Count := 0 to max do
    {$R-}
  begin
    crushed := sample^;
    {shl and shr dont seem to set bits to 0 when used with dereferenced pointers?}
    crushed := crushed shr crush;
    crushed := crushed shl crush;
    sample^ := crushed;
    Inc(sample);
  end;
  {$R+}
  {$pointermath off}
end;

procedure dspLimitThresh(aStartPoint: Pint16; aEndPoint: Pint16; aData: Pointer = nil);
var
  pset: PlimitThreshSet absolute aData;
  position: uint64;
  max: uint64;
  flt: single;
begin
  max := aEndPoint - aStartPoint;
  for position := 0 to max do
  begin
    if abs((aStartPoint + position)^) > pset^.threshold then
    begin
      flt := (tanh((aStartPoint + position)^ / high(int16) * pset^.gain));
      (aStartPoint + position)^ := trunc(flt * high(int16));
    end;
  end;
end;

procedure dspSaturate2(aStartPoint: Pint16; aEndPoint: Pint16; aData: Pointer = nil);
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
    calc := sample^ / High(int16);
    //calc := tanh(calc * gain^);
    gain^ := gain^ / 5;
    calc := sample^ / (gain^ + abs(sample^));
    //Gain should likely be between 0.1 and 10 to function properly
    sample^ := trunc(calc * high(int16));
    Inc(sample);
  end;
  {$pointermath off}
end;

function noSat(aSample: single; aGain: single): single;
begin
  Result := aSample;
end;

function Sat1(aSample: single; aGain: single): single;
begin
  Result := tanh(aSample * aGain);
end;

function Sat2(aSample: single; aGain: single): single;
begin
  Result := aSample / ((aGain / 5) + abs(aSample));
end;

procedure dspAsymSat(aStartPoint: Pint16; aEndPoint: Pint16; aData: Pointer = nil);
{ #todo -oB : Verify this dsp function works!
  //check for posSat and negSat being nil and simple pass sample instead
}
type
  PasymSet = ^TasymSettimgs;
var
  pset: PasymSet absolute aData;
  sample: Pint16;
  Count: uint64;
  max: uint64;
  posDSP: TsatFunc;
  negDSP: TsatFunc;
begin
  max := aEndPoint - aStartPoint;
  sample := aStartPoint;

  posDSP := pset^.posSatFunction;
  negDSP := pset^.negSatFunction;

  for Count := 0 to max do
  begin
    case sign((sample + Count)^) of
      1:
      begin
        if (sample + Count)^ > pset^.posLimit then;
        (sample + Count)^ := trunc(
          (posDSP((sample + Count)^, pset^.posGain) * high(int16)));
      end;

      -1:
      begin
        if (sample + Count)^ > pset^.negLimit then;
        (sample + Count)^ := trunc(negDSP((sample + Count)^, pset^.negGain) *
          (abs(low(int16))));
      end;

      //0: {Dont do anything to zero! }exit;

    end;
  end;
  {$pointermath off}

end;


end.
