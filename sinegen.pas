unit SineGen;

{$mode Delphi}

interface

uses Classes, generics.collections;

type

  { TsineGen }

  TsineGen<T> = class
  private
    fArray: Tarray<T>;
    fSampleRate: uint16;
    fFrequency: uint16;
  public
    class procedure SineGenerator(aSampleRate: uint16; aFrequency: uint16;
      aLength: uint64);
  end;


implementation

{ TsineGen }

class procedure TsineGen<T>.SineGenerator(aSampleRate: uint16;
  aFrequency: uint16; aLength: uint64);
begin

end;

end.
