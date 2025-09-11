unit mtWaveGen;

{$mode Delphi}

interface

uses
  {$IFDEF LINUX}
  cthreads,
  {$ENDIF}  Classes, SysUtils, mtInterfaces, wavegen;

type

  { TblockProc }

  TblockProc = class(TInterfacedObject, IwaveGenInterface, IWaveBlock)
    function getFreqHz: double;
    procedure setFreqHz(aFreq: double);

    function getSampleRate: integer;
    procedure setSampleRate(aSampleRate: integer);

    function getLengthMilliSec: integer;
    procedure setLengthMillSec(aLengthMilliSec: integer);

    function getWaveStyle: TWaveStyle;
    procedure setWaveStyle(aWaveStyle: TWaveStyle);

    procedure GenWaveArray(aPCM: TwavePCM; aFreqHz: double;
      aLengthMilliSec: integer; aWaveStyle: TWaveStyle = wsSine;
      aSampleRate: integer = 44100);
    procedure GenWaveStyleSpecs(aWaveStyleSpec: TWaveStyleSpecs);


    procedure setStartPos(aStartBlock: uint64);
    function getStartPos: uint64;

    procedure setEndPos(aStartBlock: uint64);
    function getEndPos: uint64;

    property StartPos: uint64 read getStartPos write setStartPos;
    property EndPos: uint64 read getEndPos write setEndPos;
    property FreqHz: double read getFreqHz write setFreqHz;
    property SampleRate: integer read getSampleRate write setSampleRate;
    property LengthMilliSecs: integer read GetLengthMilliSec write setLengthMillSec;
    property WaveStyle: TWaveStyle read getWaveStyle write setWaveStyle;


  end;

implementation

{ TblockProc }

function TblockProc.getFreqHz: double;
begin

end;

procedure TblockProc.setFreqHz(aFreq: double);
begin

end;

function TblockProc.getSampleRate: integer;
begin

end;

procedure TblockProc.setSampleRate(aSampleRate: integer);
begin

end;

function TblockProc.getLengthMilliSec: integer;
begin

end;

procedure TblockProc.setLengthMillSec(aLengthMilliSec: integer);
begin

end;

function TblockProc.getWaveStyle: TWaveStyle;
begin

end;

procedure TblockProc.setWaveStyle(aWaveStyle: TWaveStyle);
begin

end;

procedure TblockProc.GenWaveArray(aPCM: TwavePCM; aFreqHz: double;
  aLengthMilliSec: integer; aWaveStyle: TWaveStyle; aSampleRate: integer);
begin

end;

procedure TblockProc.GenWaveStyleSpecs(aWaveStyleSpec: TWaveStyleSpecs);
begin

end;

procedure TblockProc.setStartPos(aStartBlock: uint64);
begin

end;

function TblockProc.getStartPos: uint64;
begin

end;

procedure TblockProc.setEndPos(aStartBlock: uint64);
begin

end;

function TblockProc.getEndPos: uint64;
begin

end;

end.
