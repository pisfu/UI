program CueDOMView;

uses
  Forms,
  CueDOMView1 in 'CueDOMView1.pas' {frmXMLViewer};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'XML Viewer (CUESoft DOM)';
  Application.CreateForm(TfrmXMLViewer, frmXMLViewer);
  Application.Run;
end.
