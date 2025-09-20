program wavetoolsdelphi;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  wavcalcs in 'wavcalcs.pas',
  wavegen in 'wavegen.pas',
  wavetools in 'wavetools.pas';

// ,
  // wavetools in 'wavetools.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
