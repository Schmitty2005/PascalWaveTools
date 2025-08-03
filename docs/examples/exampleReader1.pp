
Program readerTest;

Uses wavetools;

Var 
  rh : IReadWaveHeader;
  wh : TWaveHeader;
  f : String;
Begin
  f := 'wavefile.wav';
  rh := TwaveHeaderReader;
  rh.ReadWaveHeader(filename, wh);
  //The wh record now contains all the info from the file wave header
End;
