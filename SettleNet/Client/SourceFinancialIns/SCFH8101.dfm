inherited Form_SCFH8101: TForm_SCFH8101
  Tag = 8101
  Left = 413
  Top = 495
  Width = 629
  Height = 466
  Caption = '[8101] '#44228#51340' '#44288#47532
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited DRPanel_Top: TDRPanel
    Width = 621
    inherited DRPanel_Title: TDRPanel
      Caption = #44228#51340' '#44288#47532
    end
    inherited DRBitBtn1: TDRBitBtn
      Left = 554
    end
    inherited DRBitBtn2: TDRBitBtn
      Left = 488
      Caption = #51064#49604
      OnClick = DRBitBtn2Click
    end
    inherited DRBitBtn3: TDRBitBtn
      Tag = 2
      Left = 422
      Caption = #49325#51228
      OnClick = DRBitBtn3Click
    end
    inherited DRBitBtn4: TDRBitBtn
      Tag = 2
      Left = 356
      Caption = #49688#51221
      OnClick = DRBitBtn4Click
    end
    inherited DRBitBtn5: TDRBitBtn
      Tag = 2
      Left = 290
      Caption = #51077#47141
      OnClick = DRBitBtn5Click
    end
    inherited DRBitBtn6: TDRBitBtn
      Left = 224
      Caption = #51312#54924
      OnClick = DRBitBtn6Click
    end
  end
  inherited MessageBar: TDRMessageBar
    Top = 410
    Width = 621
  end
  object DRPanel2: TDRPanel [4]
    Left = 0
    Top = 105
    Width = 621
    Height = 305
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    object DRStrGrid_Acc: TDRStringGrid
      Left = 1
      Top = 1
      Width = 619
      Height = 303
      Align = alClient
      Color = clWhite
      ColCount = 2
      DefaultRowHeight = 18
      FixedCols = 0
      RowCount = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
      ParentFont = False
      TabOrder = 0
      OnDblClick = DRStrGrid_AccDblClick
      OnSelectCell = DRStrGrid_AccSelectCell
      AllowFixedRowClick = False
      TopRow = 1
      LeftCol = 0
      SelectedCellColor = 16047570
      SelectedFontColor = clBlack
      ColWidths = (
        89
        509)
      AlignCol = {000002010001}
      FixedAlignCol = {000002010002}
      AlignRow = {000002}
      FixedAlignRow = {000002}
      Cells = (
        0
        0
        #44228#51340#48264#54840
        0
        1
        '123456789'
        1
        0
        #44228#51340#47749
        1
        1
        #45936#51060#53552#47196#46300'1234567890')
    end
  end
  object DRFramePanel1: TDRFramePanel [5]
    Left = 0
    Top = 27
    Width = 621
    Height = 78
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 5
    object DRLabel1: TDRLabel
      Left = 25
      Top = 20
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
      Left = 300
      Top = 45
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
    object DRLabel3: TDRLabel
      Left = 300
      Top = 20
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
    object DRLabel2: TDRLabel
      Left = 25
      Top = 45
      Width = 36
      Height = 12
      Caption = #44228#51340#47749
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DREdit_AccNo: TDREdit
      Left = 85
      Top = 16
      Width = 100
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
      MaxLength = 8
      ParentFont = False
      TabOrder = 0
      OnKeyPress = DREdit_AccNoKeyPress
    end
    object DREdit_AccNameKor: TDREdit
      Left = 85
      Top = 41
      Width = 179
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
      MaxLength = 100
      ParentFont = False
      TabOrder = 1
    end
    object DREdit_MgrOprTime: TDREdit
      Left = 431
      Top = 42
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
    object DREdit_MgrOprID: TDREdit
      Left = 375
      Top = 42
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
    object DREdit_ImportTime: TDREdit
      Left = 431
      Top = 16
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
      TabOrder = 3
    end
    object DREdit_ImportID: TDREdit
      Left = 375
      Top = 16
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
      TabOrder = 2
    end
  end
  inherited ADOQuery_DECLN: TADOQuery
    Left = 120
    Top = 237
  end
  inherited DRSaveDialog_GridExport: TDRSaveDialog
    Left = 120
    Top = 288
  end
  object DrStringPrint1: TDrStringPrint
    EndLinePrint = True
    TitleGroup = False
    ColLine = False
    PrintAlignType = plAutoSize
    StringGrid = DRStrGrid_Acc
    Orientation = poPortrait
    Left = 120
    Top = 345
  end
  object ADOQuery_Log: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 120
    Top = 181
  end
end
