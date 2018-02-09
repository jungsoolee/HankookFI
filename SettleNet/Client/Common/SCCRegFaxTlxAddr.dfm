inherited DlgForm_RegFaxTlxAddr: TDlgForm_RegFaxTlxAddr
  Left = 2540
  Top = 143
  ActiveControl = DREdit_RcvCompKor
  Caption = ' FAX '#49688#49888#52376' '#46321#47197
  ClientHeight = 494
  ClientWidth = 421
  OldCreateOrder = True
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  inherited MessageBar: TDRMessageBar
    Top = 469
    Width = 421
  end
  inherited DRPanel_Btn: TDRPanel
    Width = 421
    inherited DRBitBtn1: TDRBitBtn
      Left = 354
      TabOrder = 5
    end
    inherited DRBitBtn2: TDRBitBtn
      Tag = 1
      Left = 289
      Caption = #51064#49604
      TabOrder = 4
      OnClick = DRBitBtn2Click
    end
    inherited DRBitBtn3: TDRBitBtn
      Tag = 2
      Left = 223
      Caption = #49325#51228
      TabOrder = 3
      OnClick = DRBitBtn3Click
    end
    inherited DRBitBtn4: TDRBitBtn
      Tag = 2
      Left = 158
      Caption = #49688#51221
      TabOrder = 2
      OnClick = DRBitBtn4Click
    end
    object DRBitBtn5: TDRBitBtn
      Tag = 2
      Left = 92
      Top = 1
      Width = 65
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #51077#47141
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = DRBitBtn5Click
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
    object DRBitBtn6: TDRBitBtn
      Tag = 1
      Left = 26
      Top = 1
      Width = 65
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #51312#54924
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = DRBitBtn6Click
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
  end
  object DRFramePanel_Top: TDRFramePanel [2]
    Left = 0
    Top = 27
    Width = 421
    Height = 134
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object DRLabel4: TDRLabel
      Left = 40
      Top = 74
      Width = 48
      Height = 12
      Caption = #47588#52404#48264#54840
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object DRLabel1: TDRLabel
      Left = 40
      Top = 15
      Width = 48
      Height = 12
      Caption = #49688#49888#52376#47749
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object DRLabel2: TDRLabel
      Left = 40
      Top = 45
      Width = 48
      Height = 12
      Caption = #51204#49569#44396#48516
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object DRLabel5: TDRLabel
      Left = 40
      Top = 103
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
    object DRLabel6: TDRLabel
      Left = 152
      Top = 44
      Width = 126
      Height = 12
      Caption = '(1.'#44397#45236'FAX 2.'#44397#51228'FAX)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DREdit_RcvCompKor: TDREdit
      Left = 123
      Top = 11
      Width = 250
      Height = 20
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = 'Microsoft IME 2003'
      MaxLength = 60
      ParentFont = False
      TabOrder = 0
      OnKeyPress = DREdit_RcvCompKorKeyPress
    end
    object DREdit_MediaNo: TDREdit
      Left = 123
      Top = 70
      Width = 160
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = 'Microsoft IME 2003'
      MaxLength = 64
      ParentFont = False
      TabOrder = 2
      OnKeyPress = DREdit_MediaNoKeyPress
    end
    object DREdit_OprId: TDREdit
      Left = 122
      Top = 100
      Width = 73
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
    object DREdit_OprTime: TDREdit
      Left = 197
      Top = 100
      Width = 177
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
    object DREdit_FaxGubun: TDREdit
      Left = 123
      Top = 41
      Width = 19
      Height = 20
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = 'Microsoft IME 2003'
      MaxLength = 1
      ParentFont = False
      TabOrder = 1
      OnChange = DREdit_FaxGubunChange
      OnKeyPress = DREdit_FaxGubunKeyPress
    end
  end
  object DRStrGrid_Main: TDRStringGrid [3]
    Left = 0
    Top = 161
    Width = 421
    Height = 308
    TabStop = False
    Align = alClient
    Color = clWhite
    ColCount = 4
    DefaultRowHeight = 17
    FixedCols = 0
    RowCount = 30
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnDblClick = DRStrGrid_MainDblClick
    OnSelectCell = DRStrGrid_MainSelectCell
    OnFiexedRowClick = DRStrGrid_MainFiexedRowClick
    AllowFixedRowClick = True
    TopRow = 1
    LeftCol = 0
    SelectedCellColor = 16047570
    SelectedFontColor = clBlack
    ColWidths = (
      164
      64
      48
      120)
    AlignCol = {000001010001020002030001}
    FixedAlignRow = {000002}
    Cells = (
      0
      0
      #49688#49888#52376
      0
      1
      '0'
      1
      0
      #51204#49569#44396#48516
      1
      1
      '1'
      2
      0
      #44397#44032
      2
      1
      '2'
      3
      0
      #47588#52404#48264#54840
      3
      1
      '3')
  end
  inherited DRSaveDialog_GridExport: TDRSaveDialog
    Left = 248
    Top = 368
  end
  object ADOQuery_SUPRTAD: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    SQL.Strings = (
      '')
    Left = 56
    Top = 243
  end
  object ADOQuery_Temp: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    SQL.Strings = (
      '')
    Left = 56
    Top = 307
  end
  object DrStringPrint1: TDrStringPrint
    EndLinePrint = True
    TitleGroup = False
    ColLine = False
    PrintAlignType = plAutoSize
    StringGrid = DRStrGrid_Main
    Orientation = poPortrait
    Left = 208
    Top = 232
  end
end
