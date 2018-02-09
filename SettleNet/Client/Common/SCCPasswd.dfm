object Form_Passwd: TForm_Passwd
  Left = 2114
  Top = 479
  Width = 263
  Height = 155
  Caption = #44288#47532#51088' '#48708#48128#48264#54840' '#51077#47141
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DRLabel1: TDRLabel
    Left = 33
    Top = 44
    Width = 60
    Height = 13
    Caption = #48708#48128#48264#54840
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = #44404#47548#52404
    Font.Style = [fsBold]
    ParentFont = False
  end
  object DRLabel2: TDRLabel
    Left = 33
    Top = 16
    Width = 45
    Height = 13
    Caption = #44288#47532#51088
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = #44404#47548#52404
    Font.Style = [fsBold]
    ParentFont = False
  end
  object DRButton1: TDRButton
    Left = 94
    Top = 87
    Width = 65
    Height = 25
    Caption = #54869#51064
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = DRButton1Click
  end
  object DRButton2: TDRButton
    Left = 160
    Top = 87
    Width = 65
    Height = 25
    Caption = #52712#49548
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = DRButton2Click
  end
  object DREdit1: TDREdit
    Left = 118
    Top = 40
    Width = 107
    Height = 20
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    MaxLength = 15
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 1
    OnKeyPress = DREdit1KeyPress
  end
  object DRUserDblCodeCombo_Admin: TDRUserDblCodeCombo
    Left = 118
    Top = 12
    Width = 108
    Height = 20
    EditWidth = 89
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ImeMode = imDontCare
    ImeName = 'Microsoft IME 2003'
    InsertAllItem = False
    ReadOnly = False
    TabOrder = 0
    TabStop = True
    OnCodeChange = DRUserDblCodeCombo_AdminCodeChange
    OnEditKeyPress = DRUserDblCodeCombo_AdminEditKeyPress
  end
  object drpnl_msg: TDRPanel
    Left = 2
    Top = 66
    Width = 248
    Height = 17
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object ADOQuery_Temp: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 64
    Top = 315
  end
  object ADOQuery1: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 64
    Top = 315
  end
  object ADOQuery2: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 64
    Top = 315
  end
end
