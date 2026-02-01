unit wavetoolsexp;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF LINUX} cthreads, {$ENDIF}
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, {uadsrTypes,}
  {dspbitcrush, dspDMAFilter, dspDMAPhaseReverse,}{dspDMAsaturate, dspDMATypes,}
  {dspTypes,} SampleRateConverter, samplerateclasses, lfoTypes, lfoSine, sinelfo,
  uWaveFader, waveGen, whiteNoise, PinkNoiseGen, {dspMt} dspProcs, dspThreads, mtSetup;
  // dspDMAsaturate;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button10: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    procedure Button10Click(Sender: TObject);
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
  //dspDMAFilter.dspDMAFilter(@fWave[0], Length(fwave));
  //ms := TMemoryStream.Create;
  //ms.Write(fWave[0], length(fWave) * 2);
  //ms.SaveToFile('FilteredSample.pcm');
  //ms.Free;
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

procedure TForm1.Button10Click(Sender: TObject);
var
  ar: array of int16;
  ms: TMemoryStream;
  st: TasymSettimgs;
  x: uint64;
  sm: int16;
begin
  setLength(ar, 44100);
  //set up saturation
  st.negGain := 1;
  st.posGain := 1.2;
  st.negSatFunction := @Sat1;
  st.posSatFunction := @Sat2;
  st.negLimit := -27000;
  st.posLimit := 12000;

  //create sine wave array
  for x := 0 to 44099 do
  begin
    ar[x] := trunc(sin(2 * PI * 800 / 44100 * x) * 27000);
    //ar[x] := trunc(sat2((ar[x]/High(int16)), 1.7) * high(int16));
  end;

  ms := TMemoryStream.Create;
  ms.Write(ar[0], length(ar) * 2);
  ms.SaveToFile('asyPRESat.pcm');
  ms.Free;

  //run process
  dspAsymSat(@ar[0], @ar[44099], @st);

  //setup mem stream;
  ms := TMemoryStream.Create;
  ms.Write(ar[0], length(ar) * 2);
  ms.SaveToFile('asySat.pcm');
  ms.Free;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  //dspDMAPhaseReverse.dspDMAPhaseReverse(@fWave[0], length(fWave));

  //ms := TMemoryStream.Create;
  //ms.Write(fWave[0], length(fWave) * 2);
  //ms.SaveToFile('PhaseReversedSample.pcm');
  //ms.Free;

end;

procedure TForm1.Button5Click(Sender: TObject);
//var
//bc: TbitCrushParam;
begin
  //bc.crushDepth := 4;
  //bc.sourceDepth := 16;
  //dspbitcrush.bitCrush(fWave, 0, length(fWave), @bc);

  //ms := TMemoryStream.Create;
  //ms.Write(fWave[0], length(fWave) * 2);
  //ms.SaveToFile('BitCrushedSample.pcm');
  //ms.Free;

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
  arr, tba: array of int16;
  ts: TdspRunner;
  sm: int16;
  x: uint64;
  //bc: TbitCrushParam;

  ms: TmemoryStream;

  pb, pe, ps: Pointer;
  ps2: uint64;
  dsp: TdspThread;
  sg: single;
  br: TblocksP;
  bc: byte;
begin

  SetLength(arr, 4410000);


  // create sine wave for testing!
  for x := 0 to high(arr) do
  begin
    arr[x] := trunc(sin(2 * PI * 800 / 44100 * x) * 27000);
  end;


  sg := 1.125;

  bc := 3;

  ts := TdspRunner.Create(@arr[0], @arr[High(arr)], @dspSaturate, 3, @sg);
  {$POINTERMATH ON}
  pb := @arr[0];
  pe := @arr[100];
  ps2 := pe - pb;
  //test of pointer math....can be removed later
  {$POINTERMATH OFF}

  ts.Start;

  ts.WaitFor;



  ts.Free;
  ts := TdspRunner.Create(@arr[0], @arr[high(arr)], @dspBitCrush, 3, @bc);
  ts.Start;
  ts.WaitFor;

  ms := TMemoryStream.Create;


  //test to see why bitcrush may not be working!
  dsp := TdspThread.Create(@arr[0], @arr[high(arr)], @dspBitCrush, @bc);
  dsp.Start;
  dsp.WaitFor;

  // dspBitCrush(@arr[0], @arr[high(arr)], @bc);


  ms.Write(arr[0], Length(arr) * 2);
  ms.SaveToFile('MTtest.pcm');

  ms.Free;

end;

procedure TForm1.Button9Click(Sender: TObject);
var
  pb: TblocksP;
  ar: array of int16;
begin
  setLength(ar, 44100);
  pb := calcBlockRangesP2(@ar, @ar[high(ar)], 3);
end;

end.
