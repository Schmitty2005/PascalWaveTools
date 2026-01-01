unit wavetoolsexp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, uadsrTypes,
  dspbitcrush, dspDMAFilter, dspDMAPhaseReverse, dspDMAsaturate, dspDMATypes,
  dspTypes, SampleRateConverter, samplerateclasses, lfoTypes, lfoSine, sinelfo,
  uWaveFader, waveGen;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
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
  tw.FreqHertz := 18000;
  tw.SampleRate := 44100;
  tw.LengthMilliSec := 1000;
  tw.WaveStyle := wsTri;
  sawWave(tw);

    fWave := tw.aPCM;

  ms := TMemoryStream.Create;
  ms.Write(fWave[0], length(fWave) * 2);
  ms.SaveToFile('UnFilteredSample.pcm');
  ms.Free;
  // Copy
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Close;
end;

end.
