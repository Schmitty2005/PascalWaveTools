unit dspDMAFilter;

{$mode Delphi}

interface
 { #todo -oB : incomplete.  TFilterFactor is not used. }
type
  TfilterFactor = byte;

procedure dspDMAFilter(const location: Pint16; const aLength: uint64;
  const aDspData: Pointer = nil);

implementation

procedure dspDMAFilter(const location: Pint16; const aLength: uint64;
  const aDspData: Pointer = nil);
var
  x: uint64;
  s, ns: single;
  f: ^TfilterFactor absolute aDspData;
begin
  for x := 0 to aLength do
  begin
    s := (location + x)^ / 32767;
    ns := (location + x - 1)^ / 32767;
    s := (s + ns);// / 2;
    (location +x)^ := trunc(s * 32767);
  end;
end;

end.
