{$MODE DELPHI}
program WaveToolsTesting;

uses cthreads,  {Needs to be first in uses!}
  Classes,
  SysUtils,
  SineGenInterfaces,
  SineGen,
  wavCalcs,
  waveGen, MTWaveProcess;

var
  wti: ICreateSineWave<int16>;
  wtx: ICreateSquareWave;
  sPCM, sawPCM: TwavePCM;
  ms: TBytesStream;
  ft: TwaveGenStyleExt;
  lt: TwaveGenStyle;
  wsp: TWaveStyleSpecs;
begin
  ft := @triangleWave;
  lt := @triangleWave;

  wsp.WaveStyle := wsSine;
  wsp.FreqHertz := 803;
  wsp.LengthMilliSec := 500;
  wsp.Amplitude := 27000;
  writeln(lt(wsp));
  //wti := TsineGen<int16>.Create;
  //wti.SineGenerator(22050, 660, 1000, 90);

  wtx := TsineGen<int16>.Create;
  wtx.SquareGenerator(22050, 662, 1000, 90);

  wsp.aPCM := sawPCM;
  wsp.SampleRate := 44100;
  wsp.StartPhaseDeg := 0;

  {Test Triangle / Sawtooth WaveGen function}
  writeln(triangleWave(sPCM, 804, 1000, 27000, 44100, 90));
  writeln('Saw Wave Length : ', sawWave(sawPCM, 800, 500, 27000));
  ms := TBytesStream.Create(Tbytes(sPCM));
  ms.SaveToFile('triangle.pcm');
  //Create a test saw wave
  ms := TBytesStream.Create(Tbytes(sawPCM));
  ms.SaveToFile('SawWave.pcm');

  sawWave(wsp);
  ms := TBytesStream.Create(Tbytes(wsp.aPCM));
  ms.SaveToFile('SawWave803.pcm');

  ms.Free;

  mtDspProcess(wsp.aPCM, ft, wsp);
end.
