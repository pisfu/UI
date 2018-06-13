unit pjct;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
TTest = class
Data: array [0..10] of Char;
    Caption: string;
    Description: string;
    procedure ShowCaption;
    procedure ShowDescription;
    procedure ShowData;
end;

  TForm1 = class(TForm)
procedure FormCreate(Sender: TObject);
private
    FT: TTest;
procedure InitData(Value: PChar);
end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{ TTest }

procedure TTest.ShowCaption;
begin
ShowMessage(Caption);
end;

procedure TTest.ShowData;
begin
ShowMessage(PChar(@Data[0]));
end;

procedure TTest.ShowDescription;
begin
ShowMessage(Description);
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
FT :=TTest.Create;
try
  FT.Caption := 'Test caption';
  FT.Description := 'Test Description';
  InitData(@FT.Data[0]);
  FT.ShowCaption;
  FT.ShowDescription;
  FT.ShowData;
finally
  FT.Free;
end;
end;

procedure TForm1.InitData(Value: PChar);
const
ValueData = 'Test data value';
var
  I: Integer;
begin
for I := 1 to Length(ValueData) do
begin
    Value^ := ValueData[I];
Inc(Value);
end;
end;

end.
