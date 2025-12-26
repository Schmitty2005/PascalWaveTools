program dspDelphi;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils, System.Classes, dspTypes, dspbitcrush;

const
  cSr = 44100;

var
  ar: array of int16;
  x, s: integer;
  bc: TbitCrushParam;
  ms: TmemoryStream;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    bc.sourceDepth := 16;
    bc.crushDepth := 2;

    setlength(ar, cSr);

    for x := 0 to high(ar) do
      ar[x] := trunc(sin(x * 2 * PI * 800 / cSr) * 27000);

    s := high(ar) * sizeOf(int16);
    ms := TmemoryStream.create;
    ms.write(ar[0], s);
    ms.SaveToFile('bcinput.pcm');
    ms.Free;

    bitCrush(ar, low(ar), high(ar), @bc);

    ms := TmemoryStream.create;
    ms.write(ar[0], s);
    ms.SaveToFile('bcoutput.pcm');
    ms.Free;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  writeln('Press Enter..');
  readln;

end.
