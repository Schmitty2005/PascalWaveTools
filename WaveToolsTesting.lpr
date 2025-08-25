{$MODE DELPHI}
program WaveToolsTesting;

uses
  SineGenInterfaces, SineGen;

var
  wti: ICreateSineWave;
  wtx : ICreateSquareWave;
begin
  wti := TsineGen<int8>.Create;
  wti.SineGenerator(22050, 660, 1000, 90);

  wtx := TsineGen<int16>.create;
  wtx.SquareGenerator (22050, 660,1000,90);

end.
