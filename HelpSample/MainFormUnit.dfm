object Form1: TForm1
  Left = 0
  Top = 0
  ClientHeight = 338
  ClientWidth = 992
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 528
    Top = 9
    Width = 130
    Height = 25
    Action = ActionFrom2to3
  end
  object SpeedButton2: TSpeedButton
    Left = 335
    Top = 9
    Width = 130
    Height = 25
    HelpType = htKeyword
    Action = ActionFrom2to1
  end
  object SpeedButton3: TSpeedButton
    Left = 199
    Top = 9
    Width = 130
    Height = 25
    HelpType = htKeyword
    Action = ActionFrom1to2
  end
  object SpeedButton4: TSpeedButton
    Left = 664
    Top = 8
    Width = 130
    Height = 25
    Action = ActionFrom3to2
  end
  object SpeedButton5: TSpeedButton
    Left = 32
    Top = 8
    Width = 23
    Height = 22
    OnClick = SpeedButton5Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 39
    Width = 320
    Height = 291
    DragMode = dmAutomatic
    ReadOnly = True
    TabOrder = 0
    OnDragDrop = MemoDragDrop
    OnDragOver = Memo1DragOver
  end
  object Memo2: TMemo
    Left = 336
    Top = 40
    Width = 320
    Height = 291
    DragMode = dmAutomatic
    ReadOnly = True
    TabOrder = 1
    OnDragDrop = MemoDragDrop
    OnDragOver = Memo2DragOver
  end
  object Memo3: TMemo
    Left = 664
    Top = 40
    Width = 320
    Height = 291
    DragMode = dmAutomatic
    ReadOnly = True
    TabOrder = 2
    OnDragDrop = MemoDragDrop
    OnDragOver = Memo3DragOver
  end
  object ActionManager1: TActionManager
    Images = ImageList1
    Left = 904
    Top = 8
    StyleName = 'Platform Default'
    object ActionFrom1to2: TAction
      Category = 'Jump'
      Caption = #1055#1088#1099#1075#1085#1091#1090#1100' '#1090#1091#1076#1072
      ImageIndex = 1
      OnExecute = ActionFrom1to2Execute
    end
    object ActionFrom2to1: TAction
      Category = 'Jump'
      Caption = #1055#1088#1099#1075#1085#1091#1090#1100' '#1089#1102#1076#1072
      ImageIndex = 0
      OnExecute = ActionFrom2to1Execute
    end
    object ActionFrom2to3: TAction
      Category = 'Jump'
      Caption = #1055#1088#1099#1075#1085#1091#1090#1100' '#1090#1091#1076#1072
      ImageIndex = 1
      OnExecute = ActionFrom2to3Execute
    end
    object ActionFrom3to2: TAction
      Category = 'Jump'
      Caption = #1055#1088#1099#1075#1085#1091#1090#1100' '#1089#1102#1076#1072
      ImageIndex = 0
      OnExecute = ActionFrom3to2Execute
    end
  end
  object ImageList1: TImageList
    Left = 944
    Top = 8
    Bitmap = {
      494C010102000800180010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      000000000000000000000000000000000000000000000000000000000000E7E7
      E700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E7E7E7000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DEDEDE00B5B5B5005A5A
      5A00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005A5A5A00B5B5B500DEDEDE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D6D6D600313131003131
      3100848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      84003131310031313100D6D6D600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484006B6B
      6B00292929004242420000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000424242002929
      29006B6B6B008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DEDEDE0000000000CECECE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CECECE0000000000DEDE
      DE00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008C8C8C004242420084848400DEDEDE0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000DEDEDE0084848400424242008C8C8C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E7E7E70010101000C6C6C600737373009C9C9C00C6C6C600E7E7E7000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E7E7E700C6C6C6009C9C9C0073737300C6C6C60010101000E7E7
      E700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000084848400B5B5B500D6D6D600CECECE00F7F7F700B5B5B500ADAD
      AD00E7E7E700000000000000000000000000000000000000000000000000E7E7
      E700ADADAD00B5B5B500F7F7F700CECECE00D6D6D600B5B5B500848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008C8C8C00BDBDBD00EFEFEF00C6C6C600CECECE0000000000F7F7
      F700ADADAD00D6D6D60000000000000000000000000000000000D6D6D600ADAD
      AD00F7F7F70000000000CECECE00C6C6C600EFEFEF00BDBDBD008C8C8C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D6D6D600E7E7E700C6C6C60000000000ADADAD00DEDEDE000000
      0000949494004242420000000000000000000000000000000000424242009494
      940000000000DEDEDE00ADADAD0000000000C6C6C600E7E7E700D6D6D6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F7F7F700B5B5B50000000000ADADAD0000000000000000006B6B6B003939
      3900000000001010100000000000000000000000000000000000101010000000
      0000393939006B6B6B000000000000000000ADADAD0000000000B5B5B500F7F7
      F700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000EFEFEF00C6C6C60000000000BDBDBD00DEDEDE00D6D6D600080808000000
      0000000000000808080000000000000000000000000000000000080808000000
      00000000000008080800D6D6D600DEDEDE00BDBDBD0000000000C6C6C600EFEF
      EF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DEDEDE00CECECE0000000000848484000000000000000000000000000000
      0000000000002929290000000000000000000000000000000000292929000000
      0000000000000000000000000000000000008484840000000000CECECE00DEDE
      DE00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006363630029292900000000000000000000000000000000000000
      0000000000009C9C9C00000000000000000000000000000000009C9C9C000000
      0000000000000000000000000000000000000000000029292900636363000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D6D6D60000000000000000000000000000000000000000000000
      00005A5A5A000000000000000000000000000000000000000000000000005A5A
      5A00000000000000000000000000000000000000000000000000D6D6D6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000EFEFEF00636363001818180008080800292929009C9C
      9C00000000000000000000000000000000000000000000000000000000000000
      00009C9C9C0029292900080808001818180063636300EFEFEF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00EFFFFFF7000000008FFFFFF100000000
      87FFFFE100000000C3FFFFC300000000F1FFFF8F00000000F87FFE1F00000000
      F01FF80F00000000F807E01F00000000F823C41F00000000F893C91F00000000
      F2C3C34F00000000F203C04F00000000F203C04F00000000F803C01F00000000
      F807E01F00000000FC0FF03F0000000000000000000000000000000000000000
      000000000000}
  end
end