
{$IFDEF MSWINDOWS}

{$ENDIF}
{$IFDEF UNIX}

{$ENDIF}program adsrenvelope;
  {$mode delphi}

  {$TYPEDADDRESS ON}

type

  TadsrSettings = record
    attack: uint32;
    decay: uint32;
    sustain: uint32;
    Release: uint32;
  end;

  IdspProcedure = interface
    ['{B6AF58DA-7FB7-4481-9B39-38867717DC14}']
    procedure dsp(pcm: array of int16; const Data: pointer);
  end;

  TdspBase = class abstract (TinterfacedObject, IdspProcedure)
  private
    fSampleRate: uint64;
  public
    procedure dsp(pcm: array of int16; const Data: pointer); virtual; abstract;
    constructor Create(aSampleRate: uint64); virtual; abstract;
  end;

  { TadsrEnvelope }

  TadsrEnvelope = class(TdspBase)
    procedure dsp(pcm: array of int16; const Data: pointer); override;
    constructor Create(aSampleRate: uint64); override;
  end;

  procedure TadsrEnvelope.dsp(pcm: array of int16; const Data: pointer);
  var
    envSettings: TadsrSettings;
    pcmLength, counter : Uint64;
  begin
    pcmLength := Length(pcm);
    envSettings := (TadsrSettings(Data^));
    writeln(envSettings.decay);
  end;

  constructor TadsrEnvelope.Create(aSampleRate: uint64);
  begin
    inherited;
    fSampleRate := aSampleRate;
  end;

var
  adsr: Tadsrsettings;
  ac: TadsrEnvelope;
  ar: array of int16;
begin
  with adsr do
  begin
    attack := 2;
    decay := 4;
    sustain := 8;
    Release := 16;
  end;

  setLength(ar, 20);

  ac := TadsrEnvelope.Create(44100);

  ac.dsp(ar, @adsr);
  ac.Free;
end.
