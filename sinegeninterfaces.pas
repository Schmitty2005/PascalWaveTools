unit SineGenInterfaces;
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils;

type

  ICreateSineWave = interface
    ['{8793964F-CB71-4C87-AA44-34B78AADFC21}']
    procedure SineGenerator(const aSampleRate: uint16; const aFrequency: uint16;
      const aMilliSecs: uint64;  aAmplitude: integer);
  end;

  ICreateSquareWave = interface
    ['{91C7A876-B01E-4B03-9619-10103D5FC8A3}']
    procedure SquareGenerator(aSampleRate: uint16; aFrequency: uint16;
      aMilliSecs: uint64; aAmplitude: integer);
  end;

implementation

end.
