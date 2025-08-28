unit SineGen;
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}
{$DEFINE DEBUG}

interface

uses SysUtils, Classes, SineGenInterfaces;

type

  ESineGenException = class(Exception);

  { TsineGen }
  TsineGen<T> = class(TInterfacedObject, ICreateSineWave<T>, ICreateSquareWave)
  private
    fArray: Tarray<T>;
  public
    procedure SineGenerator(const aSampleRate: uint16; const aFrequency: uint16;
      const aMilliSecs:  uint64;  aAmplitude: T);
    procedure SquareGenerator(aSampleRate: uint16; aFrequency: uint16;
      aMilliSecs: uint64; aAmplitude: Integer);
  end;

implementation

uses Math;
{ TsineGen }

procedure TsineGen<T>.SineGenerator(const aSampleRate: uint16; const aFrequency: uint16;
 const aMilliSecs: uint64;  aAmplitude: T);
var
  memStream: TmemoryStream;
  angle, preCalc, numSamples: double;
  Count: uint32; // maybe a Uint64 later ?
begin
  { #todo -oB : Needs type checking with Exception.  Only works with signed types for now. }
  Count := 0;
  aAmplitude := Trunc(aAmplitude * High(T) / 100.0);
  numSamples := (aSampleRate * aMilliSecs / 1000);
  preCalc := (aFrequency * PI * 2 / aSampleRate);
  setLength(fArray, Trunc(numSamples));
  while Count < numSamples do
  begin
    angle := sin(preCalc * Count);
    // sin(aFrequency * Pi * 2 * Count / aSampleRate);
    fArray[Count] := Trunc(angle * aAmplitude);
    Inc(Count);
  end;
{$IFDEF DEBUG}
  memStream := TmemoryStream.Create;
  memStream.Write(fArray[0], length(fArray) * sizeOf(T));
  memStream.SaveToFile('sinegentest8bit.pcm');
  memStream.free;
{$ENDIF}
end;

procedure TsineGen<T>.SquareGenerator(aSampleRate: uint16; aFrequency: uint16;
  aMilliSecs: uint64; aAmplitude: Integer);
var
  memStream: TmemoryStream;
  angle, preCalc, numSamples: double;
  Count: uint32; // maybe a Uint64 later ?
begin
  { #todo -oB : Needs type checking with Exception.  Only works with signed types for now. }
  Count := 0;
  aAmplitude := Trunc(aAmplitude * High(T) / 100);
  numSamples := (aSampleRate * aMilliSecs / 1000);
  preCalc := (aFrequency * PI * 2 / aSampleRate);
  setLength(fArray, Trunc(numSamples));
  while Count < numSamples do
  begin
    angle := sign(sin(preCalc * Count));
    // sin(aFrequency * Pi * 2 * Count / aSampleRate);
    fArray[Count] := Trunc(angle * aAmplitude);
    Inc(Count);
  end;
{$IFDEF DEBUG}
  memStream := TmemoryStream.Create;
  memStream.Write(fArray[0], length(fArray) * sizeOf(T));
  memStream.SaveToFile('squaregentest8bit.pcm');
  memStream.free;
{$ENDIF}
end;

end.
