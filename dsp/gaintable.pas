unit gaintable;
{$IFDEF FPC}
{$mode ObjFPC}{$H+}
{$ENDIF}

interface

uses
  Classes, Math, dspProcs;

type

  { TgainTable }

  TgainTable = class
  private
    fGainTable: array of int16;
    fPOSsat: TsatFunc;
    fNegSat: TsatFunc;
    fsatSettings: TasymSettimgs;
    function getValue(i: integer): int16;
    //procedure setValue(i: integer; AValue: int16);
  public
    property Value[i: integer]: int16 read getValue; default;
    constructor Create(const aSettings: TasymSettimgs);
  end;


implementation

{ TgainTable }

function TgainTable.getValue(i: integer): int16;
begin
  Result := fGainTable[i];
end;

//procedure TgainTable.setValue(i: integer; AValue: int16);
//begin
//  fGainTable[i] := Avalue;
//end;

constructor TgainTable.Create(const aSettings: TasymSettimgs);
{ #todo -oB : No Need to have PosSat and NegSat functions,
              as they are included in TasymSettings }
var
  i: int16;
  u: uint16 absolute i;
begin
  { #todo -oB : Check if this create function is working properly }
  setLength(fGainTable, high(uint16));
  for i := low(int16) to high(int16) do
    fGainTable[u] := i;

  fsatSettings := aSettings;
  fPOSsat := fsatSettings.posSatFunction;
  fNegSat := fsatSettings.negSatFunction;

  //pass fGainTable to dspSat to fill table with values
  dspAsymSat(@fGainTable[0], @fGainTable[high(fGainTable)], @fsatSettings);
end;

end.
