object Form1: TForm1
  Left = 0
  Top = 0
  Anchors = [akRight, akBottom]
  Caption = 'Form1'
  ClientHeight = 361
  ClientWidth = 684
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 10
    Width = 674
    Height = 45
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 5
    Margins.Bottom = 10
    Align = alTop
    BevelOuter = bvNone
    Color = clMoneyGreen
    Padding.Left = 3
    Padding.Right = 3
    Padding.Bottom = 20
    ParentBackground = False
    TabOrder = 0
    ExplicitTop = 20
    ExplicitWidth = 586
    object Edit1: TEdit
      AlignWithMargins = True
      Left = 6
      Top = 3
      Width = 579
      Height = 19
      Align = alClient
      TabOrder = 0
      Text = 'Edit1'
      ExplicitTop = 21
      ExplicitWidth = 25
      ExplicitHeight = 21
    end
    object Button3: TButton
      Left = 588
      Top = 0
      Width = 83
      Height = 25
      Align = alRight
      Caption = 'Button3'
      TabOrder = 1
      ExplicitLeft = 488
      ExplicitTop = 12
      ExplicitHeight = 39
    end
  end
  object Memo2: TMemo
    Left = 0
    Top = 65
    Width = 523
    Height = 205
    Align = alClient
    Constraints.MinHeight = 80
    Constraints.MinWidth = 50
    Lines.Strings = (
      'Memo2')
    TabOrder = 1
    ExplicitLeft = 74
    ExplicitTop = 135
    ExplicitWidth = 185
    ExplicitHeight = 89
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 280
    Width = 678
    Height = 78
    Margins.Top = 10
    Align = alBottom
    BevelOuter = bvNone
    Color = clSkyBlue
    ParentBackground = False
    TabOrder = 2
    ExplicitWidth = 590
    DesignSize = (
      678
      78)
    object Button1: TButton
      Left = 287
      Top = 18
      Width = 177
      Height = 44
      Anchors = [akRight, akBottom]
      Caption = 'Button1'
      TabOrder = 0
    end
    object Button2: TButton
      Left = 470
      Top = 18
      Width = 176
      Height = 44
      Anchors = [akRight, akBottom]
      Caption = 'Button2'
      TabOrder = 1
    end
  end
  object Panel3: TPanel
    AlignWithMargins = True
    Left = 528
    Top = 68
    Width = 153
    Height = 199
    Margins.Left = 5
    Align = alRight
    BevelOuter = bvNone
    Color = clSilver
    ParentBackground = False
    TabOrder = 3
    object Button4: TButton
      Left = 0
      Top = 0
      Width = 153
      Height = 33
      Align = alTop
      Caption = 'Button4'
      TabOrder = 0
      ExplicitWidth = 185
    end
  end
end
