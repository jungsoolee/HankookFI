inherited Form_SCCFEAccMove: TForm_SCCFEAccMove
  Left = 327
  Top = 302
  Caption = 'Acc Number Move'
  ClientHeight = 185
  ClientWidth = 420
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited MessageBar: TDRMessageBar
    Top = 160
    Width = 420
  end
  inherited DRPanel_Btn: TDRPanel
    Width = 420
    inherited DRBitBtn1: TDRBitBtn
      Left = 353
    end
    inherited DRBitBtn2: TDRBitBtn
      Tag = 1
      Left = 288
      Caption = 'Copy'
      OnClick = DRBitBtn2Click
    end
    inherited DRBitBtn3: TDRBitBtn
      Left = 222
      Visible = False
    end
    inherited DRBitBtn4: TDRBitBtn
      Left = 157
      Visible = False
    end
  end
  object DRPanel1: TDRPanel [2]
    Left = 0
    Top = 27
    Width = 420
    Height = 133
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object DRLabel1: TDRLabel
      Left = 24
      Top = 54
      Width = 60
      Height = 12
      Caption = 'From AccNo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel2: TDRLabel
      Left = 24
      Top = 94
      Width = 48
      Height = 12
      Caption = 'To AccNo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel3: TDRLabel
      Left = 27
      Top = 24
      Width = 24
      Height = 12
      Caption = #51068#51088
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRUserDblCodeCombo_ToAccNo: TDRUserDblCodeCombo
      Left = 90
      Top = 50
      Width = 321
      Height = 20
      EditColor = 16312544
      EditWidth = 120
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
      OnEditKeyPress = DRUserDblCodeCombo_ToAccNoEditKeyPress
    end
    object DRUserDblCodeCombo_FromAccNo: TDRUserDblCodeCombo
      Left = 90
      Top = 90
      Width = 321
      Height = 20
      EditColor = 16312544
      EditWidth = 120
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeMode = imDontCare
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      InsertAllItem = False
      ReadOnly = False
      TabOrder = 1
      TabStop = True
    end
    object DRMaskEdit_TradeDate: TDRMaskEdit
      Left = 92
      Top = 20
      Width = 77
      Height = 20
      Color = 16312544
      EditMask = '9999-99-99;0; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
      MaxLength = 10
      ParentFont = False
      TabOrder = 2
      OnKeyPress = DRMaskEdit_TradeDateKeyPress
    end
    object DRCheckBox1: TDRCheckBox
      Left = 232
      Top = 22
      Width = 169
      Height = 17
      Caption = 'FromAccNo '#49325#51228#54980' '#48373#49324
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
  end
  inherited DRSaveDialog_GridExport: TDRSaveDialog
    Left = 24
    Top = 248
  end
  object ADOQuery_Temp: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 312
    Top = 411
  end
  object ADOQuery1: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 312
    Top = 411
  end
  object ADOQuery2: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 312
    Top = 411
  end
  object ADOQuery_Trade: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 120
    Top = 411
  end
end
