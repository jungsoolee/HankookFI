inherited DlgForm_XLInput: TDlgForm_XLInput
  Left = 951
  Top = 119
  Width = 754
  Height = 604
  BorderStyle = bsSizeable
  Caption = #52397#50557' '#45236#50669' '#54028#51068' '#51077#47141
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited MessageBar: TDRMessageBar
    Top = 552
    Width = 746
  end
  inherited DRPanel_Btn: TDRPanel
    Width = 746
    inherited DRBitBtn1: TDRBitBtn
      Left = 679
    end
    inherited DRBitBtn2: TDRBitBtn
      Left = 614
      Visible = False
    end
    inherited DRBitBtn3: TDRBitBtn
      Left = 548
      Visible = False
    end
    inherited DRBitBtn4: TDRBitBtn
      Left = 483
      Visible = False
    end
    object DRPanel_Title: TDRPanel
      Left = 1
      Top = 1
      Width = 190
      Height = 25
      Align = alLeft
      BevelInner = bvRaised
      BevelOuter = bvNone
      BevelWidth = 2
      Caption = #52397#50557' '#45236#50669' '#54028#51068' '#51077#47141
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 11141120
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
    end
  end
  object DRFramePanel_T: TDRFramePanel [2]
    Left = 0
    Top = 27
    Width = 746
    Height = 46
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object DRLabel_FileCap: TDRLabel
      Left = 40
      Top = 18
      Width = 36
      Height = 12
      Caption = #54868#51068#47749
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRSpeedBtn_FileName: TDRSpeedButton
      Left = 583
      Top = 13
      Width = 24
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        55555555FFFFFFFFFF55555000000000055555577777777775F55500B8B8B8B8
        B05555775F555555575F550F0B8B8B8B8B05557F75F555555575550BF0B8B8B8
        B8B0557F575FFFFFFFF7550FBF0000000000557F557777777777500BFBFBFBFB
        0555577F555555557F550B0FBFBFBFBF05557F7F555555FF75550F0BFBFBF000
        55557F75F555577755550BF0BFBF0B0555557F575FFF757F55550FB700007F05
        55557F557777557F55550BFBFBFBFB0555557F555555557F55550FBFBFBFBF05
        55557FFFFFFFFF7555550000000000555555777777777755555550FBFB055555
        5555575FFF755555555557000075555555555577775555555555}
      NumGlyphs = 2
      ParentFont = False
      OnClick = DRSpeedBtn_FileNameClick
    end
    object DREdit_FileName: TDREdit
      Left = 78
      Top = 14
      Width = 505
      Height = 20
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
    object DRButton_Import: TDRButton
      Tag = 2
      Left = 617
      Top = 12
      Width = 67
      Height = 25
      Caption = #51077#47141
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = DRButton_ImportClick
    end
  end
  object DRStringGrid_InputInfo: TDRStringGrid [3]
    Left = 0
    Top = 73
    Width = 746
    Height = 479
    Align = alClient
    Color = clWhite
    ColCount = 8
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 30
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect, goThumbTracking]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    AllowFixedRowClick = False
    TopRow = 1
    LeftCol = 0
    Editable = False
    SelectedCellColor = 16047570
    SelectedFontColor = clBlack
    ColWidths = (
      88
      107
      120
      105
      92
      98
      68
      39)
    AlignCell = {0000000002010000000202000100000300010000}
    AlignCol = {000002010002020000030000040000050000060002070002}
    FixedAlignCol = {000002010002020002030002040002}
    FixedAlignRow = {000002020002}
    Cells = (
      0
      0
      #51333#47785#53076#46300
      0
      1
      'A0000000'
      1
      0
      #44228#51340#48264#54840
      1
      1
      '0000000000'
      2
      0
      #49688#47049
      2
      1
      '999,999,999'
      3
      0
      #49688#49688#47308
      3
      1
      '999,999,999'
      4
      0
      #49688#49688#47308#50984
      4
      1
      '0.00000 %'
      5
      0
      #44552#50529
      5
      1
      '999,999,999'
      6
      0
      #52397#50557#51068
      6
      1
      '2015-07-07'
      7
      0
      #49345#53468
      7
      1
      'O'
      7
      2
      'X'
      7
      3
      #51473#48373)
    FontCol = (
      7
      -16777208
      -12
      #44404#47548#52404
      0
      418278401)
  end
  inherited DRSaveDialog_GridExport: TDRSaveDialog
    Left = 16
    Top = 472
  end
  object DROpenDialog_Input: TDROpenDialog
    Left = 120
    Top = 464
  end
  object ADOQuery_ICodeCheck: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    EnableBCD = False
    Parameters = <>
    SQL.Strings = (
      '')
    Left = 200
    Top = 459
  end
  object ADOQuery_ANoCheck: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    EnableBCD = False
    Parameters = <>
    SQL.Strings = (
      '')
    Left = 264
    Top = 459
  end
  object ADOQuery_Main: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    EnableBCD = False
    Parameters = <>
    SQL.Strings = (
      '')
    Left = 360
    Top = 459
  end
  object ADOQuery_Temp: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    EnableBCD = False
    Parameters = <>
    SQL.Strings = (
      '')
    Left = 232
    Top = 419
  end
end
