{$MODE DELPHI}
program WaveToolsTesting;

uses
  SineGenInterfaces, SineGen;

var
  wti: ICreateSineWave;
begin
  wti := TsineGen<int8>.Create;
  wti.SineGenerator(22050, 660, 1000, 90);
end.
