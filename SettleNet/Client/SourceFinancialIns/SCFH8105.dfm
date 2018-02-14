inherited Form_SCFH8105: TForm_SCFH8105
  Tag = 8105
  Left = 337
  Top = 449
  Width = 708
  Height = 550
  Caption = '[8105] '#49688#49888#52376' '#44288#47532
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited DRPanel_Top: TDRPanel
    Width = 700
    inherited DRPanel_Title: TDRPanel
      Caption = #49688#49888#52376' '#44288#47532
    end
    inherited DRBitBtn1: TDRBitBtn
      Left = 633
    end
    inherited DRBitBtn2: TDRBitBtn
      Left = 567
      Caption = #51064#49604
      OnClick = DRBitBtn2Click
    end
    inherited DRBitBtn3: TDRBitBtn
      Tag = 2
      Left = 501
      Caption = #49325#51228
      OnClick = DRBitBtn3Click
    end
    inherited DRBitBtn4: TDRBitBtn
      Tag = 2
      Left = 435
      Caption = #49688#51221
      OnClick = DRBitBtn4Click
    end
    inherited DRBitBtn5: TDRBitBtn
      Tag = 2
      Left = 369
      Caption = #51077#47141
      OnClick = DRBitBtn5Click
    end
    inherited DRBitBtn6: TDRBitBtn
      Left = 303
      Caption = #51312#54924
      OnClick = DRBitBtn6Click
    end
  end
  inherited MessageBar: TDRMessageBar
    Top = 494
    Width = 700
  end
  object DRPanel1: TDRPanel [4]
    Left = 0
    Top = 27
    Width = 700
    Height = 40
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    object DRLabel1: TDRLabel
      Left = 20
      Top = 14
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
    object DRUserDblCodeCombo_AccNo: TDRUserDblCodeCombo
      Left = 100
      Top = 10
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
      InsertAllItem = False
      ReadOnly = False
      TabOrder = 0
      TabStop = True
      OnCodeChange = DRUserDblCodeCombo_AccNoCodeChange
      OnEditKeyPress = DRUserDblCodeCombo_AccNoEditKeyPress
    end
  end
  object DRPanel2: TDRPanel [5]
    Left = 0
    Top = 67
    Width = 700
    Height = 120
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    object DRLabel2: TDRLabel
      Left = 20
      Top = 15
      Width = 48
      Height = 12
      Caption = #51204#49569#44396#48516
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel3: TDRLabel
      Left = 20
      Top = 40
      Width = 66
      Height = 12
      Caption = 'Fax | Email'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel4: TDRLabel
      Left = 20
      Top = 65
      Width = 48
      Height = 12
      Caption = #45812#45817#51088#47749
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel5: TDRLabel
      Left = 20
      Top = 90
      Width = 48
      Height = 12
      Caption = #51204#54868#48264#54840
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel6: TDRLabel
      Left = 372
      Top = 65
      Width = 60
      Height = 12
      Caption = 'Import'#51221#48372
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel7: TDRLabel
      Left = 372
      Top = 90
      Width = 60
      Height = 12
      Caption = #51312#51089#51088#51221#48372
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRRadioGroup_SndType: TDRRadioGroup
      Left = 100
      Top = 1
      Width = 130
      Height = 30
      Columns = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'Fax'
        'Email')
      ParentFont = False
      TabOrder = 0
      OnClick = DRRadioGroup_SndTypeClick
    end
    object DREdit_FaxEmail: TDREdit
      Left = 100
      Top = 36
      Width = 555
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      MaxLength = 64
      ParentFont = False
      TabOrder = 1
      OnKeyPress = DREdit_FaxEmailKeyPress
    end
    object DREdit_Name: TDREdit
      Left = 100
      Top = 61
      Width = 239
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      MaxLength = 80
      ParentFont = False
      TabOrder = 2
      OnKeyPress = DREdit_KeyPress
    end
    object DREdit_Phone: TDREdit
      Left = 100
      Top = 86
      Width = 239
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      MaxLength = 20
      ParentFont = False
      TabOrder = 3
      OnKeyPress = DREdit_PhoneKeyPress
    end
    object DREdit_ImportTime: TDREdit
      Left = 495
      Top = 61
      Width = 160
      Height = 20
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
      ParentFont = False
      ReadOnly = True
      TabOrder = 5
    end
    object DREdit_ImportID: TDREdit
      Left = 440
      Top = 61
      Width = 56
      Height = 20
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
    end
    object DREdit_MgrOprTime: TDREdit
      Left = 495
      Top = 86
      Width = 160
      Height = 20
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
      ParentFont = False
      ReadOnly = True
      TabOrder = 7
    end
    object DREdit_MgrOprID: TDREdit
      Left = 440
      Top = 86
      Width = 56
      Height = 20
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
      ParentFont = False
      ReadOnly = True
      TabOrder = 6
    end
  end
  object DRPanel3: TDRPanel [6]
    Left = 0
    Top = 187
    Width = 700
    Height = 307
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    object DRStrGrid_FaxEmail: TDRStringGrid
      Left = 2
      Top = 2
      Width = 696
      Height = 303
      Align = alClient
      Color = clWhite
      ColCount = 4
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
      TabOrder = 0
      OnDblClick = DRStrGrid_FaxEmailDblClick
      OnSelectCell = DRStrGrid_FaxEmailSelectCell
      AllowFixedRowClick = False
      TopRow = 1
      LeftCol = 0
      SelectedCellColor = 16047570
      SelectedFontColor = clBlack
      ColWidths = (
        63
        397
        95
        118)
      AlignCol = {000002}
      FixedAlignRow = {000002}
      Cells = (
        0
        0
        #51204#49569#44396#48516
        0
        1
        'Fax'
        0
        2
        'Email'
        1
        0
        'Fax | Email'
        1
        1
        '02-333-3333'
        1
        2
        'dataroad@dataroad.co.kr;aaa1234@naver.com;'
        2
        0
        #45812#45817#51088
        2
        1
        #45812#45817#51088'123456'
        2
        2
        #45812#45817#51088'23456'
        3
        0
        #51204#54868#48264#54840
        3
        1
        '02-3333-3333'
        3
        2
        '02-4444-4444')
    end
  end
  inherited ADOQuery_DECLN: TADOQuery
    Left = 232
    Top = 261
  end
  inherited DRSaveDialog_GridExport: TDRSaveDialog
    Left = 232
    Top = 408
  end
  object DrStringPrint1: TDrStringPrint
    EndLinePrint = True
    TitleGroup = False
    ColLine = False
    PrintAlignType = plAutoSize
    Orientation = poPortrait
    Left = 232
    Top = 360
  end
  object ADOQuery_Log: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 232
    Top = 309
  end
end
