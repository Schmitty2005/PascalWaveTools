unit mtInterfaces;

{$mode Delphi}

interface

uses
  Classes, SysUtils, waveGen;

type

  IwaveSettings = interface
    function getFreqHz: double;
    procedure setFreqHz(aFreq: double);

    function getSampleRate: integer;
    procedure setSampleRate(aSampleRate: integer);

    function getLengthMilliSec : Integer;
    procedure setLengthMillSec (aLengthMilliSec : Integer);

    function getWaveStyle : TWaveStyle;
    procedure setWaveStyle (aWaveStyle:  TWaveStyle);

    property FreqHz: double read getFreqHz write setFreqHz;
    property SampleRate : Integer read getSampleRate write setSampleRate;
    property LengthMilliSecs : Integer read GetLengthMilliSec write setLengthMillSec;
    property WaveStyle : TWaveStyle read getWaveStyle write setWaveStyle;

  end;

implementation

end.
