unit uadsrClasses;
{$IFDEF FPC}
{$mode DELPHI}
{$ENDIF}

interface

uses
  uadsrTypes;

type

  IadsrApply = interface
    ['{5BB951D2-D1D6-4C4D-B22C-67DE989495D9}']
    procedure applyADSR(var aPCM: array of int16);
  end;

  { TadsrEnvelope }

  TadsrEnvelope = class(TinterfacedObject, IadsrApply)
  private
    fadsrSettings: TadsrSettings;
    fSampleRate: uint32;
  public
    constructor Create(aAdsrSettings: TadsrSettings; aSampleRate: uint32 = 44100);
    procedure applyADSR(var aPCM: array of int16);
  end;

implementation

uses uadsrProcedures;

  { TadsrEnvelope }

constructor TadsrEnvelope.Create(aAdsrSettings: TadsrSettings; aSampleRate: uint32);
begin
  fadsrSettings := aAdsrSettings;
  fSampleRate := aSampleRate;
end;

procedure TadsrEnvelope.applyADSR(var aPCM: array of int16);
begin
  setSampleRate(fSampleRate);
  adsrEnvelope(aPCM, fadsrSettings);
end;

end.
