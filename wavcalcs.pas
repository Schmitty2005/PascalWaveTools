{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

unit wavCalcs;


interface
{$IFDEF DCC}
uses system.math;
{$ENDIF}

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

begin

end.
