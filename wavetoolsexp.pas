unit wavetoolsexp;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF LINUX} cthreads, {$ENDIF}
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, uadsrTypes,
  dspbitcrush, dspDMAFilter, dspDMAPhaseReverse, dspDMAsaturate, dspDMATypes,
  dspTypes, SampleRateConverter, samplerateclasses, lfoTypes, lfoSine, sinelfo,
  uWaveFader, waveGen, whiteNoise, PinkNoiseGen, dspMt, mtSetup;// dspDMAsaturate;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    fWave: TpcmArray;
  public


  end;

var
  Form1: TForm1;
  ms: TMemoryStream;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button2Click(Sender: TObject);
begin
  dspDMAFilter.dspDMAFilter(@fWave[0], Length(fwave));
  ms := TMemoryStream.Create;
  ms.Write(fWave[0], length(fWave) * 2);
  ms.SaveToFile('FilteredSample.pcm');
  ms.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  tw: TWaveStyleSpecs;
begin
  tw.Amplitude := 27000;
  tw.aPCM := fWave;
  tw.FreqHertz := 8000;
  tw.SampleRate := 44100;
  tw.LengthMilliSec := 1000;
  tw.WaveStyle := wsTri;
  //sawWave(tw);
  //triangleWave(tw);
  triangleWave(fWave, 1800, 1000, 27000, 441000);

  //fWave := tw.aPCM;

  ms := TMemoryStream.Create;
  ms.Write(fWave[0], length(fWave) * 2);
  ms.SaveToFile('GeneratedSample.pcm');
  ms.Free;
  // Copy
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  dspDMAPhaseReverse.dspDMAPhaseReverse(@fWave[0], length(fWave));

  ms := TMemoryStream.Create;
  ms.Write(fWave[0], length(fWave) * 2);
  ms.SaveToFile('PhaseReversedSample.pcm');
  ms.Free;

end;

procedure TForm1.Button5Click(Sender: TObject);
var
  bc: TbitCrushParam;
begin
  bc.crushDepth := 4;
  bc.sourceDepth := 16;
  dspbitcrush.bitCrush(fWave, 0, length(fWave), @bc);

  ms := TMemoryStream.Create;
  ms.Write(fWave[0], length(fWave) * 2);
  ms.SaveToFile('BitCrushedSample.pcm');
  ms.Free;

end;

procedure TForm1.Button6Click(Sender: TObject);
var
  pn: Tnoise;//array of double;
  ms: TMemoryStream;
begin
  //GeneratePinkNoise(44100, 1000, pn);
  PinkNoiseGen.PinkNoise(pn, 1000 * 60 * 5);
  ms := TMemoryStream.Create;
  ms.Write(pn[0], length(pn) * 2);// is a double 2 or 4 bytes  ?
  ms.SaveToFile('PinkNoise.pcm');//this will be a float 32 format maybe ?
  ms.Free;
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  wn: TNoise;
begin
  whiteNoise.whiteNoise(wn, 1000);
  fWave := wn;

  ms := TMemoryStream.Create;
  ms.Write(wn[0], length(wn) * 2);// is a double 2 or 4 bytes  ?
  ms.SaveToFile('WhiteNoise.pcm');//this will be a float 32 format maybe ?
  ms.Free;

end;

procedure TForm1.Button8Click(Sender: TObject);
var
  arr : array of int16;
  ts : TdspRunner;
  sm : int16;
  x : uInt64;
  bc : TbitCrushParam;

  ms : TmemoryStream;
begin

  SetLength(arr, 44100000);

  // create sine wave for testing!
  for x := 0 to high(arr) do
  begin
    arr[x] := trunc(sin (2 * PI * 800 / 44100 * x) * 27000);
  end;

  bc.crushDepth:=4; bc.sourceDepth:=16;

 // ts := TdspRunner.Create(@dspDMSaturate, arr, 3, @bc);  //old dspMutlliThreadUnit

 ts := TdspRunner.Create(@arr[0], Length(arr), @dspDMSaturate, 3, @bc) ;
  ts.Start;
  {
  if not ts.CheckTerminated then
   sleep(10); //thread was created from extern error ?  WTF ?
   }
   //ts.;

  ms:= TMemoryStream.create;

  ms.Write(arr[0], Length(arr) * 2 ) ;
  ms.SaveToFile('MTtest.pcm');

  ms.free;

end;

procedure TForm1.Button9Click(Sender: TObject);
var
  pb : TblocksP;
  ar : array of Int16;

begin
  setLength(ar, 44100);
  pb := calcBlockRangesP(@ar, length(ar), 3);
end;

end.
