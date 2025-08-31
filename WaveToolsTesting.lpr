{$MODE DELPHI}
program WaveToolsTesting;

uses
  Classes,
  SysUtils,
  SineGenInterfaces,
  SineGen,
  wavCalcs,
  waveGen;

var
  wti: ICreateSineWave<Int16>;
  wtx: ICreateSquareWave;
  sPCM, sawPCM: TwavePCM;
  ms: TBytesStream;
  ft : TwaveGenStyleExt;
  lt : TwaveGenStyle;
  wsp  : TWaveStyleSpecs;
begin
  ft := @triangleWave;
  lt := @triangleWave;

  wsp.WaveStyle:=wsSine;
  wsp.FreqHertz:=800;
  wsp.LengthMilliSec:= 500;
  writeln(lt(wsp));
  wti := TsineGen<int16>.Create;
  wti.SineGenerator(22050, 660, 1000, 90);

  wtx := TsineGen<int16>.Create;
  wtx.SquareGenerator(22050, 662, 1000, 90);

  {Test Triangle / Sawtooth WaveGen function}
  writeln(triangleWave(sPCM, 804, 1000, 27000, 44100, 90));
  writeln('Saw Wave Length : ', sawWave(sawPCM, 440, 500, 27000));
  ms := TBytesStream.Create(Tbytes(sPCM));
  ms.SaveToFile('triangle.pcm');
  //Create a test saw wave
  ms := TBytesStream.Create(Tbytes(sawPCM));
  ms.SaveToFile('SawWave.pcm');
  ms.Free;
end.
