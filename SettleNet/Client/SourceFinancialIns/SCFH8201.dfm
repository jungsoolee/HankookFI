inherited Form_SCFH8201: TForm_SCFH8201
  Tag = 8201
  Left = 308
  Top = 323
  VertScrollBar.Range = 0
  BorderStyle = bsSingle
  Caption = '[8201] '#44552#50997#49345#54408' Import'
  ClientHeight = 512
  ClientWidth = 639
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  inherited DRPanel_Additional: TDRPanel [0]
    TabOrder = 9
  end
  inherited ProcessPanel: TDRPanel [1]
    TabOrder = 8
  end
  inherited DRPanel_Decision: TDRPanel [2]
    TabOrder = 10
  end
  inherited ProcessMsgBar: TDRPanel [3]
    TabOrder = 5
  end
  inherited DRRichEdit_File: TDRRichEdit [4]
    Top = 421
    Width = 505
    Height = 183
    Align = alNone
    TabOrder = 7
    Visible = False
  end
  inherited DRPanel_Top: TDRPanel [5]
    Width = 639
    inherited DRBitBtn1: TDRBitBtn
      Left = 572
    end
    inherited DRBitBtn2: TDRBitBtn
      Left = 496
      Width = 75
      Caption = 'IMPORT ALL'
      OnClick = DRBitBtn2Click
    end
    inherited DRBitBtn3: TDRBitBtn
      Left = 400
    end
    inherited DRBitBtn4: TDRBitBtn
      Left = 334
    end
    inherited DRBitBtn5: TDRBitBtn
      Left = 268
    end
    inherited DRBitBtn6: TDRBitBtn
      Left = 202
    end
  end
  inherited MessageBar: TDRMessageBar [6]
    Top = 487
    Width = 639
  end
  inherited DRFramePanel_T: TDRFramePanel [7]
    Top = 331
    Width = 639
    inherited DRLabel_FileCap: TDRLabel
      Left = 32
    end
    inherited DRSpeedBtn_FileName: TDRSpeedButton
      Left = 4
      Visible = False
    end
    object DRSpeedBtn_Unlock: TDRSpeedButton [2]
      Left = 500
      Top = 12
      Width = 24
      Height = 22
      Hint = #51076#54252#53944' lock '#54644#51228
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        18000000000000060000120B0000120B00000000000000000000008080008080
        0080800080800080800080800080800080800080800080800080800080800080
        80008080008080008080008080008080008080008080008080008080008080FF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF008080008080008080008080008080
        008080008080008080008080003F7C003F7C003F7C003F7C003F7C003F7C0080
        800080800080800080800080800080800080800080800080800080807F7F7F7F
        7F7F7F7F7F7F7F7F7F7F7F7F7F7F008080FFFFFF008080008080008080008080
        008080008080008080003F7C0086D10088D10073C40065BA006EC30056B2003F
        7C0080800080800080800080800080800080800080800080807F7F7FFFFFFF00
        80800080800080800080800080807F7F7FFFFFFF008080008080008080008080
        008080008080008080003F7C4BDEFF2EDBFF1E9EE626B8F304ADFF037CD9003F
        7C0080800080800080800080800080800080800080800080807F7F7F008080FF
        FFFF0080800080800080800080807F7F7F008080008080008080008080008080
        008080008080008080008080003F7C0DB3EE0973B90BA1ED008DE9003F7C0080
        800080800080800080800080800080800080800080800080800080807F7F7FFF
        FFFF008080FFFFFFFFFFFF7F7F7FFFFFFF008080008080008080008080008080
        008080008080008080008080003F7C2CABC1003070003F7C00B5F8003F7C0080
        800080800080800080800080800080800080800080800080800080807F7F7FFF
        FFFF7F7F7F7F7F7F0080807F7F7FFFFFFF008080008080008080008080008080
        008080008080008080008080003F7C30CAF330A7D62BB0DF00A7F6003F7C0080
        800080800080800080800080800080800080800080800080800080807F7F7F00
        80800080800080800080807F7F7F008080FFFFFF008080008080008080008080
        008080008080008080003F7C30C9FF22CBFF0BACFE0A99F1039BF60374D3003F
        7C0080800080800080800080800080800080800080800080807F7F7FFFFFFF00
        80800080800080800080800080807F7F7FFFFFFF008080008080008080008080
        008080008080008080003F7C70B8D454B1D6008AD2007CCB0085CB0051A9003F
        7C008080008080008080008080008080008080008080FFFFFF7F7F7F008080FF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F008080008080008080008080008080
        008080493652008080008080003F7C003F7C003F7C003F7C003F7C003F7C0080
        800080800080800080800080800080800080807F7F7F008080FFFFFF7F7F7F7F
        7F7F7F7F7F7F7F7F7F7F7F7F7F7F008080008080008080008080008080008080
        4936528C859249365200808049365281747A4936520080800080800080800080
        800080800080800080800080800080807F7F7FFFFFFF7F7F7FFFFFFF7F7F7FFF
        FFFF7F7F7FFFFFFF008080008080008080008080008080008080008080008080
        493652A49FA8493652008080493652827C854936520080800080800080800080
        800080800080800080800080800080807F7F7FFFFFFF7F7F7F0080807F7F7F00
        80807F7F7FFFFFFF008080008080008080008080008080008080008080008080
        493652D1CED3ABA5AF493652B1B2B18176874936520080800080800080800080
        800080800080800080800080800080807F7F7F008080FFFFFF7F7F7F00808000
        80807F7F7F008080008080008080008080008080008080008080008080008080
        0080804936529A919F8E85937C70824936520080800080800080800080800080
        800080800080800080800080800080800080807F7F7F008080FFFFFFFFFFFF7F
        7F7F008080008080008080008080008080008080008080008080008080008080
        0080800080804936524936524936520080800080800080800080800080800080
        800080800080800080800080800080800080800080807F7F7F7F7F7F7F7F7F00
        8080008080008080008080008080008080008080008080008080008080008080
        0080800080800080800080800080800080800080800080800080800080800080
        8000808000808000808000808000808000808000808000808000808000808000
        8080008080008080008080008080008080008080008080008080}
      NumGlyphs = 2
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = DRSpeedBtn_UnlockClick
    end
    object DRSpeedBtn_FileOpen: TDRSpeedButton [3]
      Left = 476
      Top = 12
      Width = 24
      Height = 22
      Hint = #51076#54252#53944' lock '#54644#51228
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
      ParentShowHint = False
      ShowHint = True
      OnClick = DRSpeedBtn_FileOpenClick
    end
    inherited DREdit_FileName: TDREdit
      Left = 80
      Width = 395
      Color = clWhite
    end
    object DRButton2: TDRButton
      Tag = 2
      Left = 534
      Top = 10
      Width = 67
      Height = 25
      Caption = 'IMPORT'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      TabStop = False
      OnClick = DRButton2Click
    end
  end
  inherited DRFramePanel_M: TDRFramePanel [8]
    Top = 377
    Width = 639
    Height = 110
    Align = alClient
    inherited DRLabel_FileSizeCap: TDRLabel
      Left = 288
      Caption = #54028#51068#53356#44592' :'
    end
    inherited DRLabel_FileDateCap: TDRLabel
      Left = 288
    end
    inherited DRLabel_FileDate: TDRLabel
      Left = 361
    end
    inherited DRLabel_FileSize: TDRLabel
      Left = 361
    end
    inherited DRLabel_BaseDateCap: TDRLabel
      Left = 8
      Top = 7
      Visible = False
    end
    inherited DRLabel_FileNameCap: TDRLabel
      Left = 288
      Caption = #54028' '#51068' '#47749' :'
    end
    inherited DRLabel_FileName: TDRLabel
      Left = 361
    end
    inherited DRLabel_TodayImpCap: TDRLabel
      Left = 120
      Top = 7
      Visible = False
    end
    inherited DRLabel_TodayImp: TDRLabel
      Left = 218
      Top = 7
      Visible = False
    end
    inherited DRLabel_BaseDate: TDRLabel
      Left = 84
      Top = 7
      Visible = False
    end
    object DRStrGrid_ImportInfo: TDRStringGrid
      Left = 32
      Top = 16
      Width = 216
      Height = 80
      Color = clWhite
      ColCount = 3
      DefaultRowHeight = 18
      RowCount = 4
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect, goThumbTracking]
      ParentFont = False
      TabOrder = 0
      AllowFixedRowClick = False
      TopRow = 1
      LeftCol = 1
      SelectedCellColor = 16047570
      SelectedFontColor = clBlack
      ColWidths = (
        82
        64
        64)
      AlignCol = {000002010002020002}
      FixedAlignCol = {000002010002020002}
      Cells = (
        0
        0
        #51088#47308' '#44396#48516
        0
        1
        #44228#51340' '#51221#48372
        0
        2
        #49688#49888#52376' '#51221#48372
        0
        3
        #48372#44256#49436' '#51088#47308
        1
        0
        #54252#54632#50668#48512
        1
        1
        'X'
        1
        2
        'X'
        1
        3
        'X'
        2
        0
        #51088#47308#44079#49688
        2
        1
        '0'
        2
        2
        '0'
        2
        3
        '0')
    end
  end
  object DRFramePanel1: TDRFramePanel [9]
    Left = 0
    Top = 27
    Width = 639
    Height = 137
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object DRPanel4: TDRPanel
      Left = 32
      Top = 12
      Width = 130
      Height = 33
      Caption = #44228#51340' '#48143' '#49688#49888#52376
      Color = clHighlight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -16
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object DRGroupBox1: TDRGroupBox
      Left = 216
      Top = 8
      Width = 409
      Height = 116
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object DRLabel2: TDRLabel
        Left = 171
        Top = 41
        Width = 24
        Height = 12
        Caption = #51060#54980
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRRadioButton_Acc_All: TDRRadioButton
        Left = 16
        Top = 16
        Width = 73
        Height = 17
        Caption = #51204#52404#44228#51340
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = DRRadioButton_Acc_AllClick
      end
      object DRRadioButton_Acc_CreDate: TDRRadioButton
        Left = 16
        Top = 38
        Width = 57
        Height = 17
        Caption = #44060#49444#51068
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = DRRadioButton_Acc_CreDateClick
      end
      object DRRadioButton_Acc_ChgDate: TDRRadioButton
        Left = 16
        Top = 62
        Width = 57
        Height = 17
        Caption = #48320#44221#51068
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = DRRadioButton_Acc_ChgDateClick
      end
      object DRRadioButton_Acc_AccNo: TDRRadioButton
        Left = 16
        Top = 86
        Width = 46
        Height = 17
        Caption = #44228#51340
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnClick = DRRadioButton_Acc_AccNoClick
      end
      object DRMaskEdit_Acc_CreDate: TDRMaskEdit
        Left = 94
        Top = 37
        Width = 73
        Height = 20
        EditMask = '9999-99-99;0; '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = 'Microsoft IME 2003'
        MaxLength = 10
        ParentFont = False
        TabOrder = 2
        OnChange = DRMaskEdit_Acc_CreDateChange
      end
      object DRMaskEdit_Acc_ChgDate: TDRMaskEdit
        Left = 94
        Top = 61
        Width = 73
        Height = 20
        EditMask = '9999-99-99;0; '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = 'Microsoft IME 2003'
        MaxLength = 10
        ParentFont = False
        TabOrder = 4
        OnChange = DRMaskEdit_Acc_ChgDateChange
      end
      object DREdit_Acc_AccNo: TDREdit
        Left = 94
        Top = 84
        Width = 111
        Height = 20
        TabStop = False
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = 'Microsoft IME 2003'
        MaxLength = 20
        ParentFont = False
        TabOrder = 6
        OnChange = DREdit_Acc_AccNoChange
      end
      object DRButton_Acc_Import: TDRButton
        Tag = 2
        Left = 318
        Top = 80
        Width = 67
        Height = 25
        Caption = 'IMPORT'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        TabStop = False
        OnClick = DRButton_Acc_ImportClick
      end
    end
  end
  object DRFramePanel2: TDRFramePanel [10]
    Left = 0
    Top = 164
    Width = 639
    Height = 86
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object DRPanel2: TDRPanel
      Left = 32
      Top = 14
      Width = 130
      Height = 33
      Caption = #48372' '#44256' '#49436
      Color = clHighlight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -16
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object DRGroupBox2: TDRGroupBox
      Left = 216
      Top = 8
      Width = 409
      Height = 64
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object DRRadioButton_Rpt_New: TDRRadioButton
        Left = 16
        Top = 16
        Width = 73
        Height = 17
        Caption = #49888#44508#44148#47564
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = DRRadioButton_Rpt_NewClick
      end
      object DRRadioButton_Rpt_AccNo: TDRRadioButton
        Left = 16
        Top = 38
        Width = 46
        Height = 17
        Caption = #44228#51340
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object DREdit_Rpt_AccNo: TDREdit
        Left = 94
        Top = 36
        Width = 111
        Height = 20
        TabStop = False
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = 'Microsoft IME 2003'
        MaxLength = 20
        ParentFont = False
        TabOrder = 2
        OnChange = DREdit_Rpt_AccNoChange
      end
      object DRButton_Rpt_Import: TDRButton
        Tag = 2
        Left = 318
        Top = 35
        Width = 67
        Height = 25
        Caption = 'IMPORT'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        TabStop = False
        OnClick = DRButton_Rpt_ImportClick
      end
    end
  end
  object DRFramePanel3: TDRFramePanel [11]
    Left = 0
    Top = 250
    Width = 639
    Height = 81
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 11
    object DRLabel1: TDRLabel
      Left = 216
      Top = 32
      Width = 48
      Height = 12
      Caption = #51312#54924#51068#51088
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel3: TDRLabel
      Left = 32
      Top = 56
      Width = 138
      Height = 12
      Caption = '** '#52572#51333' '#48152#50689' '#51204' '#49325#51228' **'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRPanel1: TDRPanel
      Left = 32
      Top = 14
      Width = 130
      Height = 33
      Caption = #53580' '#49828' '#53944
      Color = clHighlight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -16
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object DRMaskEdit_Test_Date: TDRMaskEdit
      Left = 278
      Top = 28
      Width = 73
      Height = 20
      EditMask = '9999-99-99;0; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = 'Microsoft IME 2003'
      MaxLength = 10
      ParentFont = False
      TabOrder = 1
    end
    object DRButton_Test_RptView: TDRButton
      Left = 368
      Top = 26
      Width = 73
      Height = 25
      Caption = #48372#44256#49436#49373#49457
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
  inherited ADOQuery_DECLN: TADOQuery
    Left = 480
    Top = 101
  end
  inherited DRSaveDialog_GridExport: TDRSaveDialog
    Left = 128
    Top = 128
  end
  inherited DROpenDialog_Import: TDROpenDialog
    Left = 480
    Top = 51
  end
  inherited ADOQuery_Temp: TADOQuery
    Left = 32
    Top = 78
  end
  inherited ADOQuery_Main: TADOQuery
    Left = 32
    Top = 134
  end
  inherited Timer1: TTimer
    Left = 128
    Top = 81
  end
  object IdFTP1: TIdFTP
    MaxLineAction = maException
    ReadTimeout = 0
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 472
    Top = 188
  end
  object IdLogEvent1: TIdLogEvent
    Left = 472
    Top = 252
  end
end
