unit samplerateclasses;

{$mode Delphi}

interface

  { #todo -oB : Change Tint16Array to global wavetools type later
 }
uses
  Classes, SysUtils, SampleRateConverter;

type
  TpcmArray = array of int16;

  IsampleRateConvert = interface
    ['{851284F9-BCBA-4ED8-A480-1FC44CF68A4A}']
    procedure rateConvert(const aInputPCM: array of int16; var aOutputPCM: TInt16Array);
  end;

  { TsampleRateConverter }

  TsampleRateConverter = class(TInterfacedObject, IsampleRateConvert)
  private
    finputSr: uint32;
    fOutputSr: uint32;
    fChannels: byte;
  public
    constructor Create(const aInputSampleRate: uint32; const aInputChannels: byte;
      const aOutputSampleRate: uint32);
    procedure rateConvert(const aInputPCM: array of int16; var aOutputPCM: TInt16Array);
  end;



implementation

{ TsampleRateConverter }

constructor TsampleRateConverter.Create(const aInputSampleRate: uint32;
  const aInputChannels: byte; const aOutputSampleRate: uint32);
begin
  finputSr := aInputSampleRate;
  fChannels := aInputChannels;
  fOutputSr := aOutputSampleRate;
end;

procedure TsampleRateConverter.rateConvert(const aInputPCM: array of int16;
  var aOutputPCM: Tint16Array);
begin
  ConvertSampleRate(aInputPCM, aOutputPCM, finputSr, fOutputSr, fChannels);
end;

end.
