object EditMail_Form: TEditMail_Form
  Left = 327
  Top = 211
  BorderStyle = bsDialog
  Caption = 'E-mail'
  ClientHeight = 521
  ClientWidth = 700
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MessageBar: TDRMessageBar
    Left = 0
    Top = 496
    Width = 700
    Height = 25
    Align = alBottom
  end
  object DRPanel_Btn: TDRPanel
    Left = 0
    Top = 0
    Width = 700
    Height = 27
    Align = alTop
    BevelInner = bvLowered
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -15
    Font.Name = #44404#47548#52404
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    DesignSize = (
      700
      27)
    object DRBitBtn1: TDRBitBtn
      Left = 634
      Top = 1
      Width = 65
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #51333#47308'(F9)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
    object DRBitBtn2: TDRBitBtn
      Tag = 2
      Left = 569
      Top = 1
      Width = 65
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #51204#49569'(F4)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
  end
  object DRPanel1: TDRPanel
    Left = 0
    Top = 27
    Width = 700
    Height = 182
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object DRLabel1: TDRLabel
      Left = 20
      Top = 15
      Width = 54
      Height = 12
      Caption = #48156' '#49888' '#51064':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel2: TDRLabel
      Left = 20
      Top = 62
      Width = 54
      Height = 12
      Caption = #49688' '#49888' '#52376':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel5: TDRLabel
      Left = 20
      Top = 86
      Width = 54
      Height = 12
      Caption = #51228'    '#47785':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel6: TDRLabel
      Left = 19
      Top = 108
      Width = 60
      Height = 12
      Caption = #52392#48512' '#54028#51068':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel3: TDRLabel
      Left = 20
      Top = 39
      Width = 54
      Height = 12
      Caption = #49688#49888#52376#47749':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRListView_SndAttFile: TDRListView
      Tag = 1
      Left = 87
      Top = 108
      Width = 602
      Height = 58
      BevelInner = bvNone
      BevelOuter = bvNone
      Columns = <>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      IconOptions.AutoArrange = True
      ParentFont = False
      SmallImages = DRImg_Popup
      TabOrder = 0
      ViewStyle = vsSmallIcon
    end
    object DREdit1: TDREdit
      Left = 87
      Top = 11
      Width = 330
      Height = 20
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      MaxLength = 255
      ParentFont = False
      TabOrder = 1
    end
    object DREdit2: TDREdit
      Left = 87
      Top = 83
      Width = 330
      Height = 20
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      MaxLength = 255
      ParentFont = False
      TabOrder = 2
    end
    object DREdit3: TDREdit
      Left = 87
      Top = 59
      Width = 602
      Height = 20
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      MaxLength = 255
      ParentFont = False
      TabOrder = 3
    end
    object DREdit4: TDREdit
      Left = 87
      Top = 35
      Width = 330
      Height = 20
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      MaxLength = 255
      ParentFont = False
      TabOrder = 4
    end
  end
  object DRPanel2: TDRPanel
    Left = 0
    Top = 209
    Width = 700
    Height = 287
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object DRMemo_MailBody: TDRMemo
      Left = 1
      Top = 1
      Width = 698
      Height = 285
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
  end
  object DRImg_Popup: TImageList
    ShareImages = True
    Left = 456
    Top = 320
  end
end
