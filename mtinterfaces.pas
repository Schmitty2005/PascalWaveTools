unit mtInterfaces;

{$mode Delphi}

interface

uses
  Classes, SysUtils, waveGen;

type

  IwaveSettings = interface
    ['{9D97030E-DCB9-43A3-A46B-1A38C8B6D1F6}']
    function getFreqHz: double;
    procedure setFreqHz(aFreq: double);

    function getSampleRate: integer;
    procedure setSampleRate(aSampleRate: integer);

    function getLengthMilliSec: integer;
    procedure setLengthMillSec(aLengthMilliSec: integer);

    function getWaveStyle: TWaveStyle;
    procedure setWaveStyle(aWaveStyle: TWaveStyle);

    property FreqHz: double read getFreqHz write setFreqHz;
    property SampleRate: integer read getSampleRate write setSampleRate;
    property LengthMilliSecs: integer read GetLengthMilliSec write setLengthMillSec;
    property WaveStyle: TWaveStyle read getWaveStyle write setWaveStyle;

  end;

  IwaveGenInterface = interface(IwaveSettings)
    ['{C6BB4119-B6C6-476A-9ED6-3BAE7FAD8F84}']
    procedure GenWaveArray(aPCM: TwavePCM; aFreqHz: double;
      aLengthMilliSec: integer; aWaveStyle: TWaveStyle = wsSine;
      aSampleRate: integer = 44100);
    procedure GenWaveStyleSpecs(aWaveStyleSpec: TWaveStyleSpecs);
  end;

  IWaveBlock = interface
    ['{F5C78B5E-FDF7-4771-8DAA-855764A4EC2F}']
    procedure setStartPos(aStartBlock: uint64);
    function getStartPos: uint64;

    procedure setEndPos(aStartBlock: uint64);
    function getEndPos: uint64;

    property StartPos: uint64 read getStartPos write setStartPos;
    property EndPos: uint64 read getEndPos write setEndPos;
  end;


implementation

end.
