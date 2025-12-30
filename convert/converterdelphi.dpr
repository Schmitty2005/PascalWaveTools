program converterdelphi;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, SampleRateConverter, samplerateclasses;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
