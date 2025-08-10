{$MODE DELPHI}
program WaveToolsTesting;
uses  wavetools, SineGenInterfaces, SineGen;// something needs to be done about two units being called


var
  wti :ICreateSineWave;//ICreateSineWave(8000, 800, 1000, 80);
begin
   wti := TsineGen<Int16>.Create;
   wti.SineGenerator(8000,800, 1000, 50);
end.

