unit dsptest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, dspProcs, dspThreads;

type
  TForm15 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form15: TForm15;

implementation

{$R *.dfm}

procedure TForm15.Button1Click(Sender: TObject);
var
  ms: TMemoryStream;
  dsp: TdspRunner;
  ar: array of int16;
  x: uint32;
  s: int16;
  bc: byte;
begin
  // make simple sine wave
  setLength(ar, 44100);
  for x := 0 to 44099 do
    ar[x] := round(sin(2 * PI * 800 * x / 44100) * 27000);

  bc := 3;
  dsp := TdspRunner.Create(@ar[0], @ar[44099], @dspBitcrush, 3, @bc);

  dsp.Start;
  dsp.WaitFor;

  ms := TMemoryStream.Create;
  ms.Write(ar[0], high(ar));
  ms.SaveToFile('test.pcm');

end;

procedure TForm15.Button2Click(Sender: TObject);
begin
  close;
end;

end.
