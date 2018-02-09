object Form_About: TForm_About
  Left = 2908
  Top = 451
  BorderStyle = bsDialog
  Caption = 'About SettleNet'
  ClientHeight = 319
  ClientWidth = 328
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DRPanel1: TDRPanel
    Left = 0
    Top = 0
    Width = 328
    Height = 418
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object DRLabel1: TDRLabel
      Left = 56
      Top = 46
      Width = 133
      Height = 43
      Caption = 'SettleNet'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -35
      Font.Name = 'Impact'
      Font.Style = []
      ParentFont = False
    end
    object DRLabel_Version: TDRLabel
      Left = 60
      Top = 91
      Width = 75
      Height = 16
      Caption = 'Ver. 2.0.4.15'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DRLabel3: TDRLabel
      Left = 56
      Top = 25
      Width = 77
      Height = 23
      Caption = 'DataRoad'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Impact'
      Font.Style = []
      ParentFont = False
    end
    object DRLabel_DataRoadUrl: TDRLabel
      Left = 43
      Top = 167
      Width = 136
      Height = 15
      Cursor = crHandPoint
      Caption = 'http://www.dataroad.co.kr'
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsUnderline]
      ParentFont = False
      OnClick = DRLabel_DataRoadUrlClick
    end
    object DRLabel2: TDRLabel
      Left = 42
      Top = 141
      Width = 162
      Height = 15
      Caption = 'Copyright(C) 2000 DataRoad '
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object DRLabel_ServerInfo: TDRLabel
      Left = 42
      Top = 229
      Width = 45
      Height = 15
      Caption = '> Server'
      Font.Charset = ANSI_CHARSET
      Font.Color = 4194432
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object DRLabel_DBInfo: TDRLabel
      Left = 42
      Top = 245
      Width = 68
      Height = 15
      Caption = '> DataBase '
      Font.Charset = ANSI_CHARSET
      Font.Color = 4194432
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object DRLabel_Used: TDRLabel
      Left = 42
      Top = 261
      Width = 40
      Height = 15
      Caption = '> Used'
      Font.Charset = ANSI_CHARSET
      Font.Color = 4194432
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object DRLabel_CPU: TDRLabel
      Left = 42
      Top = 198
      Width = 36
      Height = 15
      Caption = '> CPU'
      Font.Charset = ANSI_CHARSET
      Font.Color = 4194432
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object DRLabel_memory: TDRLabel
      Left = 42
      Top = 213
      Width = 53
      Height = 15
      Caption = '> Memory'
      Font.Charset = ANSI_CHARSET
      Font.Color = 4194432
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object DRLabel_VerSync: TDRLabel
      Left = 61
      Top = 115
      Width = 6
      Height = 12
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRPanel_VerSync: TDRPanel
      Left = 32
      Top = 114
      Width = 265
      Height = 17
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object DRBitBtn1: TDRBitBtn
      Left = 207
      Top = 89
      Width = 65
      Height = 25
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = DRBitBtn1Click
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
    object DRPanel3: TDRPanel
      Left = 32
      Top = 131
      Width = 265
      Height = 3
      BevelOuter = bvLowered
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 300
    Width = 328
    Height = 19
    Panels = <>
  end
  object ADOQuery_VersionSync: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 251
    Top = 16
  end
end
