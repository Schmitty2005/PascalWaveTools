unit dspDMATypes;

{$mode Delphi}

interface

type

  PdspProcedureDM = ^TdspProcedureDM;

  TdspProcedureDM = procedure(const location: Pint16; const aLength: uint64;
    const aDspData: Pointer = nil);

  IdspDMAProcess = interface
    ['{2B2DB825-7C0F-4ABA-9D4D-557915ACE857}']
    procedure process(const location: Pint16; const aLength: uint64;
      const aDspData: Pointer = nil);
  end;

  TdspDMABase = class abstract (TinterfacedObject, IdspDMAProcess)
  protected
    fSampleRate: uint32;
    fData: Pointer;
  public
    constructor Create(aSampleRate: uint32; aData: pointer = nil); virtual;
    procedure process(const location: Pint16; const aLength: uint64;
      const aDspData: Pointer = nil); virtual; abstract;
  end;



implementation

end.
(*
//
{$mode delphi}
Program dspProcedures;

uses math;

type

  TsaturateGain = single;

  TfilterFactor = byte;




procedure dspFilter ( const location : Pint16;
    const aLength: uint64;
    const aDspData: Pointer=nil);
var
  x: uInt64;
  s, ns: single;
  f: ^TfilterFactor absolute aDspData;
begin
  for x:= 0 to aLength do
    begin
     s:= (location+x)^/ 32767;
     ns:= (location+x+1)^/32767;
     s:= (s+ns)/2;
     (location+x)^:=trunc(s*32767);
   end;
end;




const
  cSr = 44100;
  cLen = 44100*60*5;
  cFreq = 18000;

var
  ar : array of int16;
  c : integer;
  g : TsaturateGain;
  w : single;

begin
  c:=0;
  g:=1.2;
  w:= 2* pi * cFreq *cSr;
  setlength(ar,cLen);

  for c:=0 to cLen do
    ar[c]:= trunc(sin(w*c)*27000);
  writeln('====sine====');

  for c:= 0 to 255 do
    write(ar[c],', ');

  dspsaturate(@ar[0], cLen, @g);

  writeln;
  writeln('====saturated====');

  for c:= 0 to 255 do
    write(ar[c],', ');

  dspFilter(@ar[0],cLen,nil);
writeln;
writeln;

writeln('====Filter====');
    for c:= 0 to 255 do
    write(ar[c],', ');

dspPhaseReverse(@ar[0], clen);

writeln;
writeln;

writeln('====Phase====');
    for c:= 0 to 255 do
    write(ar[c],', ');


writeln(#13#9, low(int16));

end.




*)
