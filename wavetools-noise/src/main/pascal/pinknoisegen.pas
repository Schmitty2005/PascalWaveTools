unit PinkNoiseGen;

{
  MIT License

  Copyright (c) 2026

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
}

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

type
  TNoise = array of SmallInt;

{ Generates pink noise (1/f noise) with specified parameters
  @param aPCM - Output array that will contain the generated samples
  @param aLengthms - Duration of the noise in milliseconds
  @param aAmplitude - Peak amplitude (default: 27000, max safe: 32767)
  @param aSampleRate - Sample rate in Hz (default: 44100)
}
procedure PinkNoise(var aPCM: TNoise; aLengthms: UInt64;
  aAmplitude: UInt16 = 27000; aSampleRate: UInt32 = 44100);

implementation

{uses
  Math;}

type
  TPinkNoiseGenerator = record
    b0, b1, b2, b3, b4, b5, b6: Double;
  end;

function GeneratePinkSample(var gen: TPinkNoiseGenerator): Double;
var
  white: Double;
begin
  // Generate white noise in range [-1, 1]
  white := (Random * 2.0) - 1.0;

  // Paul Kellet's refined pink noise algorithm
  gen.b0 := 0.99886 * gen.b0 + white * 0.0555179;
  gen.b1 := 0.99332 * gen.b1 + white * 0.0750759;
  gen.b2 := 0.96900 * gen.b2 + white * 0.1538520;
  gen.b3 := 0.86650 * gen.b3 + white * 0.3104856;
  gen.b4 := 0.55000 * gen.b4 + white * 0.5329522;
  gen.b5 := -0.7616 * gen.b5 - white * 0.0168980;

  Result := gen.b0 + gen.b1 + gen.b2 + gen.b3 + gen.b4 + gen.b5 + gen.b6 + white * 0.5362;
  Result := Result * 0.11; // Scale to approximately [-1, 1]

  gen.b6 := white * 0.115926;
end;

procedure PinkNoise(var aPCM: TNoise; aLengthms: UInt64;
  aAmplitude: UInt16 = 27000; aSampleRate: UInt32 = 44100);
var
  numSamples: UInt64;
  i: UInt64;
  gen: TPinkNoiseGenerator;
  sample: Double;
  intSample: Integer;
begin
  // Calculate number of samples needed
  numSamples := (aLengthms * aSampleRate) div 1000;

  // Allocate the array
  SetLength(aPCM, numSamples);

  // Initialize the pink noise generator
  gen.b0 := 0;
  gen.b1 := 0;
  gen.b2 := 0;
  gen.b3 := 0;
  gen.b4 := 0;
  gen.b5 := 0;
  gen.b6 := 0;

  // Initialize random seed
  Randomize;

  // Generate pink noise samples
  for i := 0 to numSamples - 1 do
  begin
    sample := GeneratePinkSample(gen);

    // Scale to amplitude and convert to integer
    intSample := Round(sample * aAmplitude);

    // Clamp to valid SmallInt range
    if intSample > 32767 then
      intSample := 32767
    else if intSample < -32768 then
      intSample := -32768;

    aPCM[i] := SmallInt(intSample);
  end;
end;

end.

