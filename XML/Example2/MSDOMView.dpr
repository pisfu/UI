program MSDOMView;

uses
  Forms,
  MSDOMView1 in 'MSDOMView1.pas' {frmXMLViewer};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'XML Viewer (MS DOM)';
  Application.CreateForm(TfrmXMLViewer, frmXMLViewer);
  Application.Run;
end.
