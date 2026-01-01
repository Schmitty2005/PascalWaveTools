unit dspDMAPhaseReverse;

{$mode Delphi}

interface

procedure dspDMAPhaseReverse(const location: Pint16; const aLength: uint64;
  const aDspData: Pointer = nil);

implementation

procedure dspDMAPhaseReverse(const location: Pint16; const aLength: uint64;
  const aDspData: Pointer = nil);
var
  x: uint64;
  s: single;
begin
  for x := 0 to aLength do
  begin
    s := (location + x)^ / 32767;
    (location +x)^ := trunc(s * -32767);
  end;
end;

end.
