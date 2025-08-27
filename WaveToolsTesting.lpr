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
  wti: ICreateSineWave;
  wtx: ICreateSquareWave;
  sPCM: TwavePCM;
  ms: TBytesStream;
begin
  {HeapTrace is showing something is not getting free'd in interface!}
  wti := TsineGen<int8>.Create;
  wti.SineGenerator(22050, 660, 1000, 90);
  {Also check for HeapTrace issues}
  wtx := TsineGen<int16>.Create;
  wtx.SquareGenerator(22050, 660, 1000, 90);

  {Test Triangle / Sawtooth WaveGen function}
  writeln(triangleWave(sPCM, 800, 10, 44100, 1000, 0));
  ms := TBytesStream.Create(Tbytes(sPCM));
  ms.SaveToFile('triangle.pcm');
  ms.Free;
end.
