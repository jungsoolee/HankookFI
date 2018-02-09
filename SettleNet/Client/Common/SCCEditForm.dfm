object Form_Edit: TForm_Edit
  Left = 329
  Top = 169
  Width = 995
  Height = 648
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Preview Editor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = DRMainMenu_EditForm
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DRPanel_Btn: TDRPanel
    Left = 0
    Top = 0
    Width = 987
    Height = 28
    Align = alTop
    BevelOuter = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object DRLabel_Title: TDRLabel
      Left = 18
      Top = 9
      Width = 7
      Height = 12
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DRBitBtn_Close: TDRBitBtn
      Left = 915
      Top = 2
      Width = 70
      Height = 25
      Caption = #51333#47308
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = DRBitBtn_CloseClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033BBBBBBBBBB
        BB33337777777777777F33BB00BBBBBBBB33337F77333333F37F33BB0BBBBBB0
        BB33337F73F33337FF7F33BBB0BBBB000B33337F37FF3377737F33BBB00BB00B
        BB33337F377F3773337F33BBBB0B00BBBB33337F337F7733337F33BBBB000BBB
        BB33337F33777F33337F33EEEE000EEEEE33337F3F777FFF337F33EE0E80000E
        EE33337F73F77773337F33EEE0800EEEEE33337F37377F33337F33EEEE000EEE
        EE33337F33777F33337F33EEEEE00EEEEE33337F33377FF3337F33EEEEEE00EE
        EE33337F333377F3337F33EEEEEE00EEEE33337F33337733337F33EEEEEEEEEE
        EE33337FFFFFFFFFFF7F33EEEEEEEEEEEE333377777777777773}
      NumGlyphs = 2
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
    object DRBitBtn_Print: TDRBitBtn
      Tag = 1
      Left = 706
      Top = 2
      Width = 70
      Height = 25
      Caption = #51064#49604
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = DRBitBtn_PrintClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555000000
        000055555F77777777775555000FFFFFFFF0555F777F5FFFF55755000F0F0000
        FFF05F777F7F77775557000F0F0FFFFFFFF0777F7F7F5FFFFFF70F0F0F0F0000
        00F07F7F7F7F777777570F0F0F0FFFFFFFF07F7F7F7F5FFFFFF70F0F0F0F0000
        00F07F7F7F7F777777570F0F0F0FFFFFFFF07F7F7F7F5FFF55570F0F0F0F000F
        FFF07F7F7F7F77755FF70F0F0F0FFFFF00007F7F7F7F5FF577770F0F0F0F00FF
        0F057F7F7F7F77557F750F0F0F0FFFFF00557F7F7F7FFFFF77550F0F0F000000
        05557F7F7F77777775550F0F0000000555557F7F7777777555550F0000000555
        55557F7777777555555500000005555555557777777555555555}
      NumGlyphs = 2
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
    object DRBitBtn_Save: TDRBitBtn
      Tag = 2
      Left = 636
      Top = 2
      Width = 70
      Height = 25
      Caption = #51200#51109
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = DRBitBtn_SaveClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333FFFFFFFFFFFFF33000077777770033377777777777773F000007888888
        00037F3337F3FF37F37F00000780088800037F3337F77F37F37F000007800888
        00037F3337F77FF7F37F00000788888800037F3337777777337F000000000000
        00037F3FFFFFFFFFFF7F00000000000000037F77777777777F7F000FFFFFFFFF
        00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
        00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
        00037F7F333333337F7F000FFFFFFFFF07037F7F33333333777F000FFFFFFFFF
        0003737FFFFFFFFF7F7330099999999900333777777777777733}
      NumGlyphs = 2
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
    object DRBitBtn_Printer: TDRBitBtn
      Left = 845
      Top = 2
      Width = 70
      Height = 25
      Caption = #54532#47536#53552
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = DRBitBtn_PrinterClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
        00033FFFFFFFFFFFFFFF0888888888888880777777777777777F088888888888
        8880777777777777777F0000000000000000FFFFFFFFFFFFFFFF0F8F8F8F8F8F
        8F80777777777777777F08F8F8F8F8F8F9F0777777777777777F0F8F8F8F8F8F
        8F807777777777777F7F0000000000000000777777777777777F3330FFFFFFFF
        03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
        03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
        33333337F3FF7F3733333330F08F0F0333333337F7737F7333333330FFFF0033
        33333337FFFF7733333333300000033333333337777773333333}
      NumGlyphs = 2
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
    object DRBitBtn_Export: TDRBitBtn
      Tag = 1
      Left = 776
      Top = 2
      Width = 70
      Height = 25
      Caption = 'Export'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = DRBitBtn_ExportClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333303
        333333333333337FF3333333333333903333333333333377FF33333333333399
        03333FFFFFFFFF777FF3000000999999903377777777777777FF0FFFF0999999
        99037F3337777777777F0FFFF099999999907F3FF777777777770F00F0999999
        99037F773777777777730FFFF099999990337F3FF777777777330F00FFFFF099
        03337F773333377773330FFFFFFFF09033337F3FF3FFF77733330F00F0000003
        33337F773777777333330FFFF0FF033333337F3FF7F3733333330F08F0F03333
        33337F7737F7333333330FFFF003333333337FFFF77333333333000000333333
        3333777777333333333333333333333333333333333333333333}
      NumGlyphs = 2
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
  end
  object MessageBar: TDRMessageBar
    Left = 0
    Top = 577
    Width = 987
    Height = 25
    Align = alBottom
  end
  object DRPageControl_Main: TDRPageControl
    Left = 0
    Top = 28
    Width = 987
    Height = 549
    Align = alClient
    FlatSeperators = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    HotTrack = False
    TabActiveColor = clWhite
    TabInactiveColor = clBtnFace
    TabInactiveFont.Charset = DEFAULT_CHARSET
    TabInactiveFont.Color = clBlack
    TabInactiveFont.Height = -12
    TabInactiveFont.Name = #44404#47548#52404
    TabInactiveFont.Style = []
    ParentFont = False
    PopupMenu = DRPopupMenu_EditForm
    TabOrder = 2
    OnMouseDown = DRPageControl_MainMouseDown
    OnMouseUp = DRPageControl_MainMouseUp
  end
  object DRMainMenu_EditForm: TDRMainMenu
    AutoHotkeys = maManual
    Left = 88
    Top = 56
    object N1: TMenuItem
      Caption = #54868#51068
      object Menu_Save: TMenuItem
        Caption = #51200#51109
        OnClick = Menu_SaveClick
      end
      object Menu_Print: TMenuItem
        Caption = #51064#49604
        OnClick = Menu_PrintClick
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object Menu_Close: TMenuItem
        Caption = #51333#47308
        OnClick = Menu_CloseClick
      end
    end
    object N6: TMenuItem
      Caption = #54200#51665
      object Menu_Undo: TMenuItem
        Caption = 'Undo'
        ShortCut = 16474
        OnClick = Menu_UndoClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Menu_Copy: TMenuItem
        Caption = #48373#49324
        ShortCut = 16451
        OnClick = Menu_CopyClick
      end
      object Menu_Cut: TMenuItem
        Caption = #51096#46972#45236#44592
        ShortCut = 16472
        OnClick = Menu_CutClick
      end
      object Menu_Paste: TMenuItem
        Caption = #48537#51060#44592
        ShortCut = 16470
        OnClick = Menu_PasteClick
      end
    end
  end
  object DRPopupMenu_EditForm: TDRPopupMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    AutoPopup = False
    OnPopup = DRPopupMenu_EditFormPopup
    Left = 88
    Top = 120
    object Popup_DeleteTab: TMenuItem
      Caption = #49325#51228
      OnClick = Popup_DeleteTabClick
    end
  end
  object DRPrinterSetupDlg_Main: TDRPrinterSetupDialog
    Left = 89
    Top = 176
  end
end
