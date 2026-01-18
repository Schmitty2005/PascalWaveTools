unit dspDMAsaturate;

{$mode Delphi}

interface

uses dspDMATypes;

type
  TsaturateGain = single;

procedure dspDMSaturate(const location: Pint16; const aLength: uint64;
  const aDspData: Pointer = nil);
{ #todo -oB : add procedure that also accepts var array and uses dm
procedure dspSaturate(var aPCM: array of int16; const aLength: uint64;
  const aDspData: Pointer = nil);


}
implementation

uses Math;

procedure dspDMSaturate(const location: Pint16; const aLength: uint64;
  const aDspData: Pointer = nil);
var
  x: uint64;
  s: single;
  gp: ^TsaturateGain absolute aDspData;
begin
  for x := 0 to aLength do
  begin
    //Log the value of 'X' here for debug
    s := (location + x)^ / 32767;
    (location +x)^ := trunc(tanh(s * gp^) * 32767);
  end;
end;

end.
