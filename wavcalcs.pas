{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

unit wavCalcs;
{$IFDEF DCC}
uses system.math;
{$ENDIF}

interface

///<summary>  A quick inline function to calculate the number of samples that
///would create one cycle at a specifice frequency in hertz;
///</summary>
///<param name="Hertz">The item to remove
///</param>
///<param name = "SampleRate"> The sample rate of the PCM / Wave data
///</param>
function calOneCycle(const Hertz: integer; const SampleRate: integer): integer; inline;

implementation

{$IFDEF FPC}
uses Math;
{$ENDIF}

function calOneCycle(const hertz: integer; const sampleRate: integer): integer; inline;
begin
  Result := trunc(sampleRate / hertz);
end;

begin

end.
