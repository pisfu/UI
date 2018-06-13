unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Button3: TButton;
    Panel1: TPanel;
    Memo2: TMemo;
    Panel2: TPanel;
    Panel3: TPanel;
    Button4: TButton;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormShow(Sender: TObject);
begin
  Panel1.Color:=clBtnFace;
  Panel2.Color:=clBtnFace;
  Panel3.Color:=clBtnFace;
end;

end.
