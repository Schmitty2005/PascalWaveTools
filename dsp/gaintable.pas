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
    procedure setValue(i: integer; AValue: int16);
  public
    property Value[i: integer]: int16 read getValue write setValue; default;
    constructor Create(aPosSat: TsatFunc; aNegSat: TsatFunc;
      aSettings: TasymSettimgs);
  end;


implementation

{ TgainTable }

function TgainTable.getValue(i: integer): int16;
begin
  Result := fGainTable[i];
end;

procedure TgainTable.setValue(i: integer; AValue: int16);
begin
  fGainTable[i] := Avalue;
end;

constructor TgainTable.Create(aPosSat: TsatFunc; aNegSat: TsatFunc;
  aSettings: TasymSettimgs);
var
  i: int16;
  u: uint16 absolute i;
begin
  setLength(fGainTable, high(uint16));
  fPOSsat:=aPosSat;
  fNegSat:=aNegSat;
  fsatSettings := aSettings;
  //pass fGainTable to dspSat to fill table with values

end;

end.
