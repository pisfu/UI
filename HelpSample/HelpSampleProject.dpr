program HelpSampleProject;

uses
  Vcl.Forms, System.SysUtils,
  MainFormUnit in 'MainFormUnit.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.HelpFile := ExtractFilePath(Application.ExeName) + 'Parashute Help.chm';
  Application.CreateForm(TForm1, Form1);
  Application.Run;

end.
