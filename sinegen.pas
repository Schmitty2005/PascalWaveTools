unit SineGen;

{$mode Delphi}

interface

uses Classes, {generics.collections, }SineGenInterfaces;

type

  { TsineGen }

  TsineGen<T> = class(TInterfacedObject, ICreateSineWave)
  private
    fArray: Tarray<T>;
    fSampleRate: uint16;
    fFrequency: uint16;
  public
    procedure SineGenerator(aSampleRate: uint16; aFrequency: uint16;
      aLength: uint64);
  end;


implementation

{ TsineGen }

procedure TsineGen<T>.SineGenerator(aSampleRate: uint16; aFrequency: uint16;
  aLength: uint64);
begin

end;

end.
