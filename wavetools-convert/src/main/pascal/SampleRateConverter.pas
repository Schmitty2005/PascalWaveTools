unit SampleRateConverter;

{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}

interface

uses SysUtils {$IFDEF BLAISE}, ClassicPascalTypes{$ENDIF};

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
  var OutputData: TInt16Array; const InputRate, OutputRate: integer; const Channels: integer = 1);

implementation

function Frac(X: Float64): Float64;overload;
begin
  // NaN passes through
  if X <> X then
  begin
    Result := X;
    Exit;
  end;

  // At |X| >= 2^52 every Float64 is already an integer, and
  // Trunc would risk overflowing Int64 for huge or infinite values.
  if (X >= 4503599627370496.0) or (X <= -4503599627370496.0) then
  begin
    Result := 0.0;
    Exit;
  end;
  Result := X - Trunc(X)
end;


function Frac(X: Float32): Float32;overload;
begin
  // Float32 -> Float64 is exact, and so is the subtraction,
  // so the narrowing back is lossless.
  Result := Float32(Frac(Float64(X)));
end;


procedure ConvertSampleRate(const InputData: array of int16;
  var OutputData: TInt16Array; const InputRate, OutputRate: integer; const Channels: integer = 1);
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
    fraction := frac(SrcPos); //No Frac in Blaise

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
