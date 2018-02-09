inherited Form_SCF_ExRate: TForm_SCF_ExRate
  Left = 458
  Top = 141
  VertScrollBar.Range = 0
  BorderIcons = [biSystemMenu, biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = #44228#51340#48324' '#54872#50984' '#46321#47197
  ClientHeight = 568
  ClientWidth = 534
  FormStyle = fsNormal
  Position = poScreenCenter
  Visible = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited DRPanel_Top: TDRPanel
    Width = 534
    inherited DRBitBtn1: TDRBitBtn [0]
      Left = 467
      Font.Color = clBlack
    end
    inherited DRBitBtn2: TDRBitBtn [1]
      Left = 401
      Caption = #51201#50857
      Font.Color = clBlack
      OnClick = DRBitBtn2Click
    end
    inherited DRBitBtn3: TDRBitBtn [2]
      Left = 335
      Caption = #51312#54924
      Font.Color = clBlack
      OnClick = DRBitBtn3Click
    end
    inherited DRBitBtn4: TDRBitBtn [3]
      Left = 269
      Font.Color = clNavy
      Visible = False
    end
    inherited DRBitBtn5: TDRBitBtn [4]
      Left = 203
      Font.Color = clNavy
      Visible = False
    end
    inherited DRBitBtn6: TDRBitBtn [5]
      Left = 137
      Font.Color = clNavy
      Visible = False
    end
    inherited DRPanel_Title: TDRPanel [6]
      Width = 144
      Caption = #44228#51340#48324' '#54872#50984' '#46321#47197
    end
  end
  inherited MessageBar: TDRMessageBar
    Top = 543
    Width = 534
  end
  object DRFramePanel2: TDRFramePanel [4]
    Left = 0
    Top = 27
    Width = 534
    Height = 78
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    object DRLabel_TradeDate: TDRLabel
      Left = 20
      Top = 21
      Width = 48
      Height = 12
      Caption = #47588#47588#51068#51088
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel_AccNo: TDRLabel
      Left = 20
      Top = 48
      Width = 24
      Height = 12
      Caption = #53685#54868
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRMaskEdit_TradeDate: TDRMaskEdit
      Left = 72
      Top = 17
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
      OnKeyPress = DRMaskEdit_KeyPress
    end
    object DRCheckBox_ApplyALL: TDRCheckBox
      Left = 215
      Top = 50
      Width = 78
      Height = 13
      Caption = #8595#51068#44292#51077#47141
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 2
    end
    object DRUserCodeCombo_Currency: TDRUserCodeCombo
      Left = 72
      Top = 43
      Width = 130
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeMode = imSHanguel
      ImeName = 'Microsoft IME 2003'
      InsertAllItem = False
      ReadOnly = False
      TabOrder = 1
      TabStop = True
      OnCodeChange = DRUserCodeCombo_CurrencyCodeChange
      OnEditKeyPress = DRUserCodeCombo_CurrencyEditKeyPress
    end
  end
  object DRStrGrid_Main: TDRStringGrid [5]
    Left = 0
    Top = 105
    Width = 534
    Height = 438
    Align = alClient
    Color = clWhite
    ColCount = 6
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 30
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goEditing, goThumbTracking]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnSelectCell = DRStrGrid_MainSelectCell
    AllowFixedRowClick = False
    TopRow = 1
    LeftCol = 0
    OnAfterEdit = DRStrGrid_MainAfterEdit
    SelectedCellColor = 16047570
    SelectedFontColor = clBlack
    AutoEditNextCell = True
    NextCellEdit = nc_downright
    NextCellTab = nc_downright
    AfterLastCellEdit = lc_stop
    ColWidths = (
      90
      149
      64
      65
      64
      64)
    AlignCol = {000001010001020000030000040000050000}
    FixedAlignRow = {000002}
    EditCol = {000000010000}
    Cells = (
      0
      0
      #44228#51340#48264#54840
      0
      1
      '123456789012345'
      0
      2
      '0'
      1
      0
      #44228#51340#47749
      1
      2
      '1'
      2
      0
      #51201#50857#47588#49688
      2
      1
      'X'
      2
      2
      '2'
      3
      0
      #51201#50857#47588#46020
      3
      1
      'A00000'
      3
      2
      '3'
      4
      0
      #49884#51109#47588#49688
      4
      1
      #51068#51060#49340#49324#50724#47449#52832
      4
      2
      '4'
      5
      0
      #49884#51109#47588#46020
      5
      1
      #51068#51060#49340#49324#50724#50977
      5
      2
      '5')
  end
  inherited ADOQuery_DECLN: TADOQuery
    Left = 0
    Top = 229
  end
  inherited DRSaveDialog_GridExport: TDRSaveDialog
    Left = 65528
    Top = 192
  end
  object ADOQuery_TEMP: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 104
    Top = 232
  end
  object ADOQuery_Exchange: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 104
    Top = 296
  end
  object ADOQuery_Update: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 104
    Top = 360
  end
  object ADOQuery_Insert: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 112
    Top = 424
  end
end
