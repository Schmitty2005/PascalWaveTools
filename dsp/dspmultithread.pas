unit dspMultiThread;

{$mode ObjFPC}{$H+}

interface

{Needs cthreads in main unit}
uses
  Classes, SysUtils, dspTypes, mtSetup;

type
  InoiseGen = interface
    ['{B8579A4B-5A89-4C35-84F9-95FD490C3EC9}']
    procedure noiseArray(var apcm: array of int16; aLengthms: uint64);
    procedure noiseDMA(aMemLoc: Pointer; aLengthms: uint64);
  end;

  { TdspThread }

  TdspThread = class(Tthread)
  protected
    fPproc: PdspProcedure;
    fTproc: TdspProcedure;
    fPData: pointer;
    fBeginIndex: uint64;
    fEndIndex: uint64;
    fPCMarray: array of int16;//probably remove later
    fPintArray: ^int16;
    fArrLength: uint64;
    procedure Execute; override;
    //procedure noiseArray(var apcm: array of int16; aLengthms: uint64);
    //procedure noiseDMA(aMemLoc: Pointer; aLengthms: uint64);
  public
    constructor Create(var apcm: array of int16; dspProc: TdspProcedure;
      beginIndex: uint64; endIndex: uint64; aData: pointer = nil);
  end;



  { TdspRunner }

  TdspRunner = class(TThread)
  private
    procedure calcBlocks;
  protected
    fArrPointer: Pint16;
    fArrLength: uint64;
    fdspData: Pointer;
    fdspProc: TdspProcedure;
    fNumCores: byte;
    //fThreadArr: array of TdspThread;
    fRange: Trange;
    fBlocks: Tblocks;
    fArrInt16: array of int16;
    procedure Execute; override;
  public
    //constructor Create(aNumCores: byte = 3);
    constructor Create(const aDSPProc: TdspProcedure; var aPCM: array of int16;
      const aNumCores: byte = 3; const aData: Pointer = nil);

  end;




implementation

{ TdspThread }

procedure TdspThread.Execute;
begin
  fTproc(fPCMArray, fBeginIndex, fEndIndex, fPdata);
end;


constructor TdspThread.Create(var apcm: array of int16; dspProc: TdspProcedure;
  beginIndex: uint64; endIndex: uint64; aData: pointer);
begin
  fPintArray := @apcm[0];
  fArrLength := High(apcm);
  fTproc := dspProc;
  fBeginIndex := beginIndex;
  fEndIndex := endIndex;
  fPData := aData;
end;

{ TdspRunner }

procedure TdspRunner.calcBlocks;
begin
  fBlocks := calcBlockRanges(length(fArrInt16), fNumCores); //change to length field later

end;

procedure TdspRunner.Execute;
begin
  //for each Trange in Tblock do create a new dsp thread

end;


{
constructor TdspRunner.Create(aNumCores: byte);
begin

  fNumCores := aNumCores;
  //setLength(fThreadArr, fNumCores);

end;
 }
constructor TdspRunner.Create(const aDSPProc: TdspProcedure;
  var aPCM: array of int16; const aNumCores: byte; const aData: Pointer);
begin
  fdspProc := aDSPProc;
  fArrPointer := @aPCM[0];
  fArrLength := Length(aPCM);
  fNumCores := aNumCores;
  fdspData := aData;
end;

end.
(*

Program noise;
{$mode delphi}

uses cmem, cthreads, classes;

type

PdspProcedure = ^TdspProcedure;

  TdspProcedure = procedure(var aPcm: array of int16;
    const beginIndex, endIndex: uint64; const aDspData: Pointer);








  TnoiseBase = class abstract (TinterfacedObject, InoiseGen)
  protected
     fLengthMs: uint64;
   fSampleRate : uInt32;
  public
  procedure noiseArray(var apcm: array of int16; aLengthms : uint64);virtual ; abstract;
  procedure noiseDMA (aMemLoc : Pointer; aLengthms : uint64); virtual; abstract;
//  constructor create(aSampleRate:uInt32);virtual ; abstract;
   //needs create wth sample rate

  end;


  TpinkNoiseGen =class(TnoiseBase)
  end;


TwhiteNoiseGen =class(TnoiseBase)
  end;


constructor TdspThread.create(var apcm: array of int16; dspProc: TdspProcedure; beginIndex:uint64; endIndex: uInt64 ;aData: pointer = nil);
begin
  //set up field variables
end;


  procedure TdspThread.execute;
  begin
  //code to execute dsp!
  end;

  var

  pn: TpinkNoiseGen;
  wn :TwhiteNoiseGen;

Begin


End.



*)
