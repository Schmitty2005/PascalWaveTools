unit SampleRateConverter;

{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}

interface

uses SysUtils;

type
  TInt16Array = array of Int16;

{ Converts PCM audio data from one sample rate to another using linear interpolation

Parameters:
InputData: Source PCM data as 16-bit signed integers
OutputData: Destination array (will be resized automatically)
InputRate: Source sample rate in Hz (e.g., 44100)
OutputRate: Target sample rate in Hz (e.g., 48000)
Channels: Number of audio channels (1=mono, 2=stereo, etc.)
}
//procedure ConvertSampleRate(const InputData: TInt16Array;
  //var OutputData: TInt16Array; InputRate, OutputRate: integer; Channels: integer = 1);
procedure ConvertSampleRate(const InputData: array of int16;
  var OutputData: TInt16Array; InputRate, OutputRate: integer; Channels: integer = 1);

implementation

procedure ConvertSampleRate(const InputData: array of int16;
  var OutputData: TInt16Array; InputRate, OutputRate: integer; Channels: integer = 1);
var
  i, ch: integer;
  InputFrames, OutputFrames: integer;
  Ratio: double;
  SrcPos: double;
  SrcIdx: integer;
  Fraction: double;
  Sample1, Sample2: Int16;
  InterpolatedValue: double;
  OutputIdx: integer;
begin
  // Validate input
  if Length(InputData) = 0 then
  begin
    SetLength(OutputData, 0);
    Exit;
  end;

  if (InputRate <= 0) or (OutputRate <= 0) or (Channels <= 0) then
    raise Exception.Create('Invalid parameters: rates and channels must be positive');

  if Length(InputData) mod Channels <> 0 then
    raise Exception.Create('Input data length must be divisible by number of channels');

  // Calculate frame counts (a frame = all channels for one time point)
  InputFrames := Length(InputData) div Channels;
  OutputFrames := Round(InputFrames * OutputRate / InputRate);

  // Resize output array
  SetLength(OutputData, OutputFrames * Channels);

  // Calculate ratio for resampling
  Ratio := InputRate / OutputRate;

  // Process each output frame
  for i := 0 to OutputFrames - 1 do
  begin
    // Calculate source position (in frames)
    SrcPos := i * Ratio;
    SrcIdx := Trunc(SrcPos);
    fraction := frac(SrcPos);

    // Process each channel
    for ch := 0 to Channels - 1 do
    begin
      OutputIdx := i * Channels + ch;

      // Get samples for interpolation
      if SrcIdx >= InputFrames - 1 then
      begin
        // At or beyond end of input - use last sample
        Sample1 := InputData[(InputFrames - 1) * Channels + ch];
        Sample2 := Sample1;
      end
      else
      begin
        Sample1 := InputData[SrcIdx * Channels + ch];
        Sample2 := InputData[(SrcIdx + 1) * Channels + ch];
      end;

      // Linear interpolation
      InterpolatedValue := Sample1 + (Sample2 - Sample1) * Fraction;

      // Clamp and store result
      if InterpolatedValue > 32767 then
        OutputData[OutputIdx] := 32767
      else if InterpolatedValue < -32768 then
        OutputData[OutputIdx] := -32768
      else
        OutputData[OutputIdx] := Round(InterpolatedValue);
    end;

  end;
end;

end.
