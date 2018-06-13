unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Menus, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    StatusBar1: TStatusBar;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Button1: TButton;
    Button2: TButton;
    BalloonHint1: TBalloonHint;
    ImageList1: TImageList;
    Button3: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button4: TButton;
    ButtonedEdit1: TButtonedEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ButtonedEdit2: TButtonedEdit;
    ButtonedEdit3: TButtonedEdit;
    PopupMenu2: TPopupMenu;
    procedure Button4Click(Sender: TObject);
    procedure ButtonedEdit1RightButtonClick(Sender: TObject);
    procedure ButtonedEdit2RightButtonClick(Sender: TObject);
    procedure ButtonedEdit2LeftButtonClick(Sender: TObject);
    procedure ButtonedEdit3Exit(Sender: TObject);
  private
    procedure RestoreText(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button4Click(Sender: TObject);
begin
  Edit1.Alignment := TAlignment((Ord(Edit1.Alignment) + 1)mod(Ord(High(TAlignment)) + 1));
end;

procedure TForm1.ButtonedEdit1RightButtonClick(Sender: TObject);
begin
  ButtonedEdit1.Undo;
end;

procedure TForm1.ButtonedEdit2LeftButtonClick(Sender: TObject);
begin
  ButtonedEdit2.PasteFromClipboard;
end;

procedure TForm1.ButtonedEdit2RightButtonClick(Sender: TObject);
begin
  ButtonedEdit2.Clear;
end;

procedure TForm1.ButtonedEdit3Exit(Sender: TObject);
begin
  if (ButtonedEdit3.Text <> '') and
    (PopupMenu2.Items.Find(ButtonedEdit3.Text) = nil) then
  begin
    PopupMenu2.Items.Add(NewItem(ButtonedEdit3.Text,0,False,True,RestoreText,0,''));
  end;
end;

procedure TForm1.RestoreText(Sender: TObject);
begin
  ButtonedEdit3.Text := StripHotkey((Sender as TMenuItem).Caption);
end;

end.
