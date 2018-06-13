unit MainFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, System.ImageList, Vcl.ImgList;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    ActionManager1: TActionManager;
    ActionFrom1to2: TAction;
    ActionFrom2to1: TAction;
    ActionFrom2to3: TAction;
    ActionFrom3to2: TAction;
    ImageList1: TImageList;
    SpeedButton5: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure ActionFrom1to2Execute(Sender: TObject);
    procedure ActionFrom2to1Execute(Sender: TObject);
    procedure ActionFrom2to3Execute(Sender: TObject);
    procedure ActionFrom3to2Execute(Sender: TObject);
    procedure Memo3DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean);
    procedure Memo2DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean);
    procedure Memo1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean);
    procedure MemoDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure SpeedButton5Click(Sender: TObject);
  private
    procedure ChangeButtonsStates;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

resourcestring
  StrMainFormCaption = 'Пример использования файла справки в приложении';
  StrStartPositionError = 'Не выбрано место изначальной посадки парашютиста';
  StrParashutist = 'Парашютист';

{$R *.dfm}

procedure TForm1.ActionFrom1to2Execute(Sender: TObject);
begin
  Memo1.Clear;
  Memo2.Text := StrParashutist;
  Memo3.Clear;
  ChangeButtonsStates;
end;

procedure TForm1.ActionFrom2to1Execute(Sender: TObject);
begin
  Memo1.Text := StrParashutist;
  Memo2.Clear;
  Memo3.Clear;
  ChangeButtonsStates;
end;

procedure TForm1.ActionFrom2to3Execute(Sender: TObject);
begin
  Memo1.Clear;
  Memo2.Clear;
  Memo3.Text := StrParashutist;
  ChangeButtonsStates;
end;

procedure TForm1.ActionFrom3to2Execute(Sender: TObject);
begin
  Memo1.Clear;
  Memo2.Text := StrParashutist;
  Memo3.Clear;
  ChangeButtonsStates;
end;

procedure TForm1.ChangeButtonsStates;
begin
  ActionFrom1to2.Enabled := Memo1.Text <> '';
  ActionFrom2to1.Enabled := Memo2.Text <> '';
  ActionFrom2to3.Enabled := Memo2.Text <> '';
  ActionFrom3to2.Enabled := Memo3.Text <> '';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption := StrMainFormCaption;

  Randomize;

  case random(3) + 1 of
    1:
      Memo1.Text := StrParashutist;
    2:
      Memo2.Text := StrParashutist;
    3:
      Memo3.Text := StrParashutist;
  else
    Raise Exception.Create(StrStartPositionError);
  end;

  ChangeButtonsStates;
end;

procedure TForm1.MemoDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  TMemo(Sender).Text := StrParashutist;
  TMemo(Source).Clear;
  ChangeButtonsStates;
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_INDEX, 0);
end;

procedure TForm1.Memo1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
begin
  Accept := (TMemo(Source) = Memo2) and (TMemo(Source).Text <> '');
end;

procedure TForm1.Memo2DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
begin
  Accept := ((TMemo(Source) = Memo1) or (TMemo(Source) = Memo3)) and (TMemo(Source).Text <> '');
end;

procedure TForm1.Memo3DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
begin
  Accept := (TMemo(Source) = Memo2) and (TMemo(Source).Text <> '');
end;

end.
