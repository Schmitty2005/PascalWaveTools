{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

unit wavCalcs;



interface
{$IFDEF DCC}
uses system.math, system.sysutils;
{$ENDIF}

{$IFDEF FPC}
uses sysutils;
{$ENDIF}

type
  EwavCalcError = class(Exception);

  Tpan = record
    left : double;
    right : double;
  end;

///<summary>  A quick inline function to calculate the number of samples that
///would create one cycle at a specifice frequency in hertz;
///</summary>
///<param name="Hertz">The item to remove
///</param>
///<param name = "SampleRate"> The sample rate of the PCM / Wave data
///</param>
function calOneCycle(const Hertz: integer; const SampleRate: integer): integer; inline;

///<summary>  Convert a desired dB value to a decimal factor.  Example : +3dB =~ 1.41
///</summary>
///<param name="dB">Standard dB level (ex. 1.5 for 1.5dB)
///</param>
function dBtoDec (dB : double): double ; inline;

{======Pan Laws=====}
{ConstPowPan and sqrLaw pan provide same results.  Testing needed to find out
  which method is quicker to calculate}
function linearPan (pan : double) : Tpan;

function constPowPan ( pan : double ) : Tpan;

function sqrLawPan  ( pan : double) : Tpan;


implementation

{$IFDEF FPC}
uses Math;
{$ENDIF}

function calOneCycle(const hertz: integer; const sampleRate: integer): integer; inline;
begin
  Result := trunc(sampleRate / hertz);
end;

function dBtoDec (dB : double): double ; inline;
begin
  Result := Power(10, (db/20));
end;

function linearPan (pan : double) : Tpan;
begin
  if (pan > 1.0) or (pan < -1.0 ) then 
    raise EwavCalcError.Create('Pan value must be between 1.0 and -1.0');
  result.left := 1-pan;
  result.right := pan;
end;

function constPowPan ( pan : double ) : Tpan;
const
  precalc = (pi / 2);
begin
  if (pan > 1.0) or (pan < -1.0 ) then 
    raise EwavCalcError.Create('Pan value must be between 1.0 and -1.0');
  result.left := cos(pan * precalc);
  result.right := sin(pan * precalc); 
end;

function sqrLawPan  ( pan : double) : Tpan;
begin
  if (pan > 1.0) or (pan < -1.0 ) then 
    raise EwavCalcError.Create('Pan value must be between 1.0 and -1.0');
  result.Left := Sqrt(1-pan);
  result.Right := Sqrt(pan);
end;

begin

end.
