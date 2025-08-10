unit SineGenInterfaces;

{$mode Delphi}

interface

uses
  Classes, SysUtils;

type

  ICreateSineWave = interface
    ['{8793964F-CB71-4C87-AA44-34B78AADFC21}']
    procedure SineGenerator(aSampleRate: uint16; aFrequency: uint16;
      aMilliSecs: uint64; aAmplitude: integer);
  end;

implementation

end.
