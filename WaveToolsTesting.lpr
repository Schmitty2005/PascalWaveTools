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
  sPCM: TwavePCM;
  ms: TBytesStream;
begin

  wti := TsineGen<int16>.Create;
  wti.SineGenerator(22050, 660, 1000, 90);

  wtx := TsineGen<int16>.Create;
  wtx.SquareGenerator(22050, 660, 1000, 90);

  {Test Triangle / Sawtooth WaveGen function}
  writeln(triangleWave(sPCM, 800, 10, 44100, 1000, 0));
  ms := TBytesStream.Create(Tbytes(sPCM));
  ms.SaveToFile('triangle.pcm');
  ms.Free;
end.
