inherited Form_SCFH8111: TForm_SCFH8111
  Tag = 8111
  Left = 267
  Top = 427
  Width = 954
  Height = 550
  Caption = '[8111] '#48320#44221' '#45236#50669' '#51312#54924
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited DRPanel_Top: TDRPanel
    Width = 946
    inherited DRPanel_Title: TDRPanel
      Caption = #48320#44221' '#45236#50669' '#51312#54924
    end
    inherited DRBitBtn1: TDRBitBtn
      Left = 879
    end
    inherited DRBitBtn2: TDRBitBtn
      Left = 813
      Caption = #51064#49604
    end
    inherited DRBitBtn3: TDRBitBtn
      Left = 747
      Caption = #51312#54924
      OnClick = DRBitBtn3Click
    end
    inherited DRBitBtn4: TDRBitBtn
      Left = 681
      Visible = False
    end
    inherited DRBitBtn5: TDRBitBtn
      Left = 615
      Visible = False
    end
    inherited DRBitBtn6: TDRBitBtn
      Left = 549
      Visible = False
    end
  end
  inherited MessageBar: TDRMessageBar
    Top = 494
    Width = 946
  end
  object DRFramePanel1: TDRFramePanel [4]
    Left = 0
    Top = 27
    Width = 946
    Height = 86
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    object DRLabel1: TDRLabel
      Left = 20
      Top = 25
      Width = 48
      Height = 12
      Caption = #51312#51089#51068#51088
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel2: TDRLabel
      Left = 20
      Top = 50
      Width = 36
      Height = 12
      Caption = #51312#51089#51088
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel3: TDRLabel
      Left = 370
      Top = 25
      Width = 48
      Height = 12
      Caption = #44228#51340#48264#54840
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel4: TDRLabel
      Left = 370
      Top = 50
      Width = 48
      Height = 12
      Caption = #51088#47308#44396#48516
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel5: TDRLabel
      Left = 183
      Top = 25
      Width = 6
      Height = 12
      Caption = '~'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRMaskEdit_OprSDate: TDRMaskEdit
      Left = 100
      Top = 21
      Width = 73
      Height = 20
      EditMask = '9999-99-99;0; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
      MaxLength = 10
      ParentFont = False
      TabOrder = 0
      OnKeyPress = DREdit_KeyPress
    end
    object DRMaskEdit_OprEDate: TDRMaskEdit
      Left = 200
      Top = 21
      Width = 73
      Height = 20
      EditMask = '9999-99-99;0; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
      MaxLength = 10
      ParentFont = False
      TabOrder = 1
      OnKeyPress = DREdit_KeyPress
    end
    object DRUserDblCodeCombo_Acc: TDRUserDblCodeCombo
      Left = 435
      Top = 21
      Width = 210
      Height = 20
      EditWidth = 100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeMode = imDontCare
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      InsertAllItem = True
      ReadOnly = False
      TabOrder = 3
      TabStop = True
      OnEditKeyPress = DREdit_KeyPress
    end
    object DRUserCodeCombo_JobGB: TDRUserCodeCombo
      Left = 435
      Top = 46
      Width = 119
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeMode = imSHanguel
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
      InsertAllItem = True
      ReadOnly = False
      TabOrder = 4
      TabStop = True
      OnEditKeyPress = DRUserCodeCombo_JobGBEditKeyPress
    end
    object DRUserCodeCombo_User: TDRUserCodeCombo
      Left = 100
      Top = 46
      Width = 100
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeMode = imSHanguel
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
      InsertAllItem = True
      ReadOnly = False
      TabOrder = 2
      TabStop = True
      OnEditKeyPress = DREdit_KeyPress
    end
  end
  object DRPanel1: TDRPanel [5]
    Left = 0
    Top = 113
    Width = 946
    Height = 381
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    object DRStrGrid_Log: TDRStringGrid
      Left = 1
      Top = 1
      Width = 944
      Height = 379
      Align = alClient
      Color = clWhite
      ColCount = 8
      DefaultRowHeight = 18
      FixedCols = 0
      RowCount = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      AllowFixedRowClick = False
      TopRow = 1
      LeftCol = 0
      SelectedCellColor = 16047570
      SelectedFontColor = clBlack
      ColWidths = (
        35
        147
        93
        65
        63
        67
        54
        393)
      AlignCol = {000002010002020002040002060002}
      FixedAlignRow = {000002}
      Cells = (
        0
        0
        'No'
        0
        1
        '10000'
        1
        0
        #48320#44221#51068#49884
        1
        1
        '2018.02.12 13:58:00.00'
        2
        0
        #51312#51089#51088
        2
        1
        'abcdefghijklmn'
        3
        0
        #44228#51340#48264#54840
        3
        1
        '12345678'
        4
        0
        #51088#47308#44396#48516
        4
        1
        'Import'
        4
        2
        #44228#51340#51221#48372
        4
        3
        'Fax'
        4
        4
        'Email'
        5
        0
        #54868#47732
        5
        1
        #44228#51340#44288#47532
        5
        2
        'Import'
        5
        3
        #49688#49888#52376#44288#47532
        6
        0
        #44396#48516
        6
        1
        'Import'
        6
        2
        #51077#47141
        6
        3
        #49688#51221
        6
        4
        #49325#51228
        7
        0
        #48320#44221#45236#50669
        7
        1
        #48320#44221#45236#50669'123456789')
    end
  end
  inherited ADOQuery_DECLN: TADOQuery
    Left = 136
    Top = 309
  end
  inherited DRSaveDialog_GridExport: TDRSaveDialog
    Left = 136
    Top = 353
  end
end
