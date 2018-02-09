inherited Form_SCF_Import: TForm_SCF_Import
  Left = 892
  Top = 272
  Width = 789
  ActiveControl = DREdit_FileName
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object DRRichEdit_File: TDRRichEdit [1]
    Left = 0
    Top = 181
    Width = 781
    Height = 315
    Align = alClient
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
    Lines.Strings = (
      '')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 5
    WordWrap = False
  end
  inherited DRPanel_Top: TDRPanel [2]
    Width = 781
    DesignSize = (
      781
      27)
    inherited DRPanel_Title: TDRPanel
      Caption = 'IMPORT'
    end
    inherited DRBitBtn1: TDRBitBtn
      Left = 714
    end
    inherited DRBitBtn2: TDRBitBtn
      Tag = 2
      Left = 648
      Caption = 'IMPORT'
    end
    inherited DRBitBtn3: TDRBitBtn
      Left = 582
      Visible = False
    end
    inherited DRBitBtn4: TDRBitBtn
      Left = 516
      Visible = False
    end
    inherited DRBitBtn5: TDRBitBtn
      Left = 450
      Visible = False
    end
    inherited DRBitBtn6: TDRBitBtn
      Left = 384
      Visible = False
    end
  end
  inherited MessageBar: TDRMessageBar [3]
    Width = 781
  end
  inherited DRPanel_Decision: TDRPanel [4]
    TabOrder = 8
  end
  object DRFramePanel_T: TDRFramePanel [5]
    Left = 0
    Top = 27
    Width = 781
    Height = 46
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 3
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
      Left = 515
      Top = 12
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
      Left = 104
      Top = 13
      Width = 410
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
  end
  object DRFramePanel_M: TDRFramePanel [6]
    Left = 0
    Top = 73
    Width = 781
    Height = 108
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    object DRLabel_FileSizeCap: TDRLabel
      Left = 328
      Top = 50
      Width = 60
      Height = 12
      Caption = #54868#51068#53356#44592' :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel_FileDateCap: TDRLabel
      Left = 40
      Top = 76
      Width = 60
      Height = 12
      Caption = #49373#49457#51068#51088' :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel_FileDate: TDRLabel
      Left = 113
      Top = 76
      Width = 18
      Height = 12
      Caption = 'XXX'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel_FileSize: TDRLabel
      Left = 404
      Top = 50
      Width = 18
      Height = 12
      Caption = 'XXX'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel_BaseDateCap: TDRLabel
      Left = 328
      Top = 23
      Width = 60
      Height = 12
      Caption = #44592#51456#51068#51088' :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel_FileNameCap: TDRLabel
      Left = 40
      Top = 23
      Width = 60
      Height = 12
      Caption = #54868#51068#47749'   :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel_FileName: TDRLabel
      Left = 113
      Top = 23
      Width = 18
      Height = 12
      Caption = 'XXX'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel_TodayImpCap: TDRLabel
      Left = 328
      Top = 76
      Width = 90
      Height = 12
      Caption = #45817#51068' Import >> '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel_TodayImp: TDRLabel
      Left = 426
      Top = 76
      Width = 18
      Height = 12
      Caption = 'XXX'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel_BaseDate: TDRLabel
      Left = 404
      Top = 23
      Width = 24
      Height = 12
      Caption = 'XXXX'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
  end
  object ProcessPanel: TDRPanel [7]
    Left = 116
    Top = 255
    Width = 489
    Height = 169
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    Visible = False
    object ProcPanel_Label_Msg: TDRLabel
      Left = 49
      Top = 25
      Width = 400
      Height = 12
      Caption = 'Import '#51473' '#50724#47448' '#48156#49373'! '#54869#51064' '#48260#53948#51012' '#45580#47084#51452#49901#49884#50836'.('#50724#47448#46972#51064'# -1)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ProcPanel_Label_TotalCnt: TDRLabel
      Left = 58
      Top = 130
      Width = 66
      Height = 12
      Caption = 'Total Count'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object ProcPanel_BitBtn_Confirm: TDRBitBtn
      Left = 356
      Top = 122
      Width = 65
      Height = 25
      Caption = #54869#51064
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = ProcPanel_BitBtn_ConfirmClick
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
    object ProcPanel_Animate: TAnimate
      Left = 82
      Top = 53
      Width = 272
      Height = 60
      CommonAVI = aviCopyFiles
      StopFrame = 31
      Visible = False
    end
  end
  object DRPanel_Additional: TDRPanel [8]
    Left = 283
    Top = 226
    Width = 264
    Height = 217
    BevelInner = bvLowered
    BevelWidth = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    Visible = False
    object DRLabel_AddTitle: TDRLabel
      Left = 35
      Top = 18
      Width = 96
      Height = 12
      Caption = #48120#46321#47197' '#44228#51340' LIST'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel_AddMsg: TDRLabel
      Left = 71
      Top = 190
      Width = 114
      Height = 12
      Caption = #48120#46321#47197#46108' '#44228#51340#51077#45768#45796
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object DRLabel_AddMsgCap: TDRLabel
      Left = 19
      Top = 190
      Width = 48
      Height = 12
      Caption = 'Message:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRListBox_AddList: TDRListBox
      Left = 17
      Top = 35
      Width = 146
      Height = 146
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
      ItemHeight = 12
      ParentFont = False
      TabOrder = 0
    end
    object DRButton_AddConf: TDRButton
      Left = 177
      Top = 35
      Width = 67
      Height = 25
      Caption = #54869#51064
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = DRButton_AddConfClick
    end
    object DRButton_AddRegs: TDRButton
      Left = 177
      Top = 69
      Width = 67
      Height = 25
      Caption = #44228#51340#46321#47197
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
  object DROpenDialog_Import: TDROpenDialog
    Filter = 'Text File(*.txt),Data File(*.dat)|*.txt;*.dat|All Files(*.*)|*.*'
    Left = 608
    Top = 35
  end
  object ADOQuery_Temp: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 632
    Top = 230
  end
  object ADOQuery_Main: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 632
    Top = 294
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = Timer1Timer
    Left = 568
    Top = 97
  end
end
