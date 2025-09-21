program waveinfo;

{$APPTYPE CONSOLE}
{$R *.res}
{$IFDEF DCC}
uses
  System.SysUtils, wavetools;
  {$ENDIF}
  {$IFDEF FPC}
  {$MODE DELPHI}
uses
   classes, Sysutils, wavetools;
  {$ENDIF}
var
  wh: TWaveHeader;
  fn: String;

procedure waveHeaderText(aWaveHeader: TWaveHeader);

var
  whr: IReadWaveHeader;

begin
  whr := TWaveHeaderReader.Create;
  whr.ReadWaveHeader(fn, aWaveHeader);
  writeln;
  writeln('====Wave Header Info ====');
  writeln;
  writeln('Filename : ', fn);
  writeln('Size : ', aWaveHeader.FileSize);
  writeln('Sample Rate : ', aWaveHeader.SampleRate);
  writeln('Number of Channels : ', aWaveHeader.NumChannles);
  writeln('Size of data : ', aWaveHeader.sizeOfData);
  writeln('Block Size : ', aWaveHeader.BlockSize);
  writeln('Bytes Per Sec : ', aWaveHeader.bytesPerSec);
  writeln('Bytes Per Block ', aWaveHeader.bytesPerBlock);
  writeln ('Type Format (1=PCM)  : ', aWaveHeader.TypeFormat);
  writeln('Bits Per Sample : ', aWaveHeader.BitsPerSample);

  writeln;
end;

begin
  fn := ParamStr(1);
  if fn = '' then
  begin
    writeln('====Wave Header Info ====');
    writeln('No filename given on command line! ');
    writeln('    Usage : waveinfo <filename>');
    exit;
  end;
  writeln('====Wave Header Info ====');
  writeln('Wave Header info for file : ', fn);
  try
    waveHeaderText(wh);
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;

end.
