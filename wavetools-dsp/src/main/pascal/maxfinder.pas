unit maxfinder;
{$IFDEF FPC}
{$mode ObjFPC}{$H+}
{$ENDIF}

interface

uses Classes, mtSetup;

const
  cMaxThreads = 255;

type

  Tgain = object
  private
    fInt: int16;
    fFlt: single;
    procedure setInt(const aValue: int16);
    procedure setFlt(const aValue: single);
  public
    property Vol16: int16 read fInt write setInt;
    property VolFlt: single read fFlt write setFlt;
  end;

  maxPool = array [1..cMaxThreads] of int16;

  TmaxFinder = class(Tthread)
  private
    fThreadNum: uint16;
    fMaxValue: int16;
    fPoutMax: Pint16;
    fStart, fEnd: Pint16;
  protected
    procedure Execute; override;
  public
    property threadNum: uint16 read fThreadNum write fThreadNum;
    property FoundMaxValue: int16 read fMaxValue;
    procedure Create(aStart: Pint16; aEnd: Pint16; out aFoundMax: int16);
  end;

  { TfindMaxRunner }

  TfindMaxRunner = class(Tthread)
  private
    fNumCores: byte;
    fThreads: array of TmaxFinder;
    fMaxArr: TblocksP;
  protected
    procedure Execute; override;
  public
    constructor Create(aStartPoint: Pint16; aEndPoint: Pint16; aCPUCores: byte);
  end;

implementation

{ Tgain }
procedure Tgain.setInt(const aValue: int16);
begin
  fInt := aValue;
  fFlt := abs(aValue) / high(int16);
end;

procedure Tgain.setFlt(const aValue: single);
begin
  fFlt := abs(aValue);
  fInt := trunc(fFlt * high(int16));
end;

{ TmaxFinder }

procedure TmaxFinder.Execute;
var
  MaxValue: int16;
  memPos: Pint16;
  Count, postn: uint64;
begin
  Count := fEnd - fStart;
  memPos := fStart;
  MaxValue := 0;
  for Postn := 0 to Count do
  begin
    if (memPos + Postn)^ > MaxValue then
      MaxValue := (memPos + Postn)^;
  end;
  fPoutMax^ := MaxValue;
  fMaxValue := MaxValue;
end;

procedure TmaxFinder.Create(aStart: Pint16; aEnd: Pint16; out aFoundMax: int16);
begin
  fPoutMax := @aFoundMax;
  fStart := aStart;
  fEnd := aEnd;
  inherited Create(True);
end;

{ TfindMaxRunner }

procedure TfindMaxRunner.Execute;
begin
  {Create threads based off of Tblocks start and end points}
end;

constructor TfindMaxRunner.Create(aStartPoint: Pint16; aEndPoint: Pint16;
  aCPUCores: byte);
begin
  inherited Create(True);
  fNumCores := aCPUCores;
  fMaxArr := calcBlockRangesP2(aStartPoint, aEndPoint, fNumCores);
end;


end.
