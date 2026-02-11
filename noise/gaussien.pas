
{******************************************************************************
 * MIT License
 *
 * Copyright (c) 2026
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 ******************************************************************************}


 { #todo -oB : UNTESTED!
 }
unit gaussien;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  // Parameter type for Gaussian noise generation
  TGaussianNoiseParams = record
    Mean: double;        // Mean value of the Gaussian distribution
    StdDev: double;      // Standard deviation
    Amplitude: double;   // Amplitude multiplier (default 1.0)
  end;
  PGaussianNoiseParams = ^TGaussianNoiseParams;

procedure GenerateGaussianNoise(aStartPoint: PInt16; aEndPoint: PInt16;
  aData: Pointer = nil);


implementation

// Generates Gaussian noise using Box-Muller transform
procedure GenerateGaussianNoise(aStartPoint: PInt16; aEndPoint: PInt16;
  aData: Pointer = nil);
var
  Current: PInt16;
  Params: PGaussianNoiseParams;
  Mean, StdDev, Amplitude: double;
  U1, U2, Z0, Z1: double;
  Value: double;
  UseSecond: boolean;
  SavedZ: double;
begin
  randomize;
  if aStartPoint = nil then Exit;
  if aEndPoint = nil then Exit;
  if PtrUInt(aEndPoint) < PtrUInt(aStartPoint) then Exit;

  // Get parameters or use defaults
  if aData <> nil then
  begin
    Params := PGaussianNoiseParams(aData);
    Mean := Params^.Mean;
    StdDev := Params^.StdDev;
    Amplitude := Params^.Amplitude;
  end
  else
  begin
    Mean := 0.0;
    StdDev := 1000.0;  // Default std dev for int16 range
    Amplitude := 1.0;
  end;

  Current := aStartPoint;
  UseSecond := False;
  SavedZ := 0.0;

  while PtrUInt(Current) <= PtrUInt(aEndPoint) do
  begin
    // Box-Muller transform generates two independent Gaussian samples
    if UseSecond then
    begin
      Z0 := SavedZ;
      UseSecond := False;
    end
    else
    begin
      // Generate two uniform random numbers in (0, 1]
      repeat
        U1 := Random;
      until U1 > 0.0;

      repeat
        U2 := Random;
      until U2 > 0.0;

      // Box-Muller transform
      Z0 := Sqrt(-2.0 * Ln(U1)) * Cos(2.0 * Pi * U2);
      Z1 := Sqrt(-2.0 * Ln(U1)) * Sin(2.0 * Pi * U2);

      SavedZ := Z1;
      UseSecond := True;
    end;

    // Scale and shift to desired mean and standard deviation
    Value := Mean + (Z0 * StdDev * Amplitude);

    // Clamp to int16 range [-32768, 32767]
    if Value > 32767.0 then
      Current^ := 32767
    else if Value < -32768.0 then
      Current^ := -32768
    else
      Current^ := Round(Value);

    Inc(Current);
  end;
end;


end.
(*





// Example usage:
procedure TestGaussianNoise;
var
  Buffer: array[0..999] of Int16;
  Params: TGaussianNoiseParams;
begin
  Randomize; // Initialize random number generator

  // Set parameters
  Params.Mean := 0.0;
  Params.StdDev := 5000.0;
  Params.Amplitude := 1.0;

  // Generate noise
  GenerateGaussianNoise(@Buffer[0], @Buffer[High(Buffer)], @Params);

  // Or use default parameters (nil)
  // GenerateGaussianNoise(@Buffer[0], @Buffer[High(Buffer)], nil);
end;

*)
