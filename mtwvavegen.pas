unit mtwvavegen;
  {
  A second attempt at multithreading.  Most attempt recent as of 9-21-25

  }
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
  cthreads, Math, Classes, SysUtils;

type
  TpcmArray = array of int16;

  Tformula = function(aSample: int16; aParam: int32): int16; inline;

  TwaveThread = procedure(aPCM: TPCMarray; aForm: TFormaula;
    starPos: uint64; endPos: uint64; sampleRate: uint16);

function TubeSim(aSample: int16; aGain: int32): int16; inline;
function ReduceGain(aSample: int16; aReductionPrcnt): int16; inline;

implementation

function TubeSim(aSample: int16; aGain: int32): int16; inline;
begin
  Result := Tanh(aGain * aSample);
end;

function ReduceGain(aSample: int16; aReductionPrcnt): int16; inline;
begin
  Result := aSample * aReductionPrcnt;
end;

end.
