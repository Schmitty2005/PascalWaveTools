unit SineGen;

{$mode Delphi}
{$DEFINE DEBUG}

interface

uses SysUtils, Classes, SineGenInterfaces;

type

  ESineGenException = class(Exception);

  { TsineGen }
  TsineGen<T> = class(TInterfacedObject, ICreateSineWave)
  private
    fArray: Tarray<T>;
  public
    procedure SineGenerator(aSampleRate: uint16; aFrequency: uint16;
      aMilliSecs: uint64; aAmplitude: integer);
  end;


implementation

{ TsineGen }

procedure TsineGen<T>.SineGenerator(aSampleRate: uint16; aFrequency: uint16;
  aMilliSecs: uint64; aAmplitude: integer);
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
    angle := sin(preCalc * Count);// sin(aFrequency * Pi * 2 * Count / aSampleRate);
    fArray[Count] := trunc(angle * aAmplitude);
    Inc(Count);
  end;
  {$IFDEF DEBUG}
  memStream := TMemoryStream.Create;
  memStream.Write(fArray[0], length(fArray) * sizeOf(T));
  memStream.SaveToFile('sinegentest8bit.pcm');
  {$ENDIF}
  //sample := angle * amp * high<T>;

end;

end.
