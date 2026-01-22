program DelphiDSP;

uses
  Vcl.Forms,
  dsptest in 'dsptest.pas' {Form15};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm15, Form15);
  Application.Run;
end.
