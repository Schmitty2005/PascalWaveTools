program waveinfo;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils, wavetools;

var
  wh: TWaveHeader;
  fn: String;

procedure waveHeaderText(aWaveHeader: TWaveHeader);

begin
  writeln('Filename : ', fn);
  writeln(' Size : ', aWaveHeader.FileSize);
  writeln('Sample Rate : ', aWaveHeader.SampleRate);
  writeln(' Number of Channels : ', aWaveHeader.NumChannles);
  writeln('Size of data : ', aWaveHeader.sizeOfData);
end;

begin
  fn := ParamStr(1);
  if fn = '' then
  begin
    writeln('No filename given on command line! ');
    writeln('    Usage : waveinfo <filename>');
    exit;
  end;

  try

    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;

end.
