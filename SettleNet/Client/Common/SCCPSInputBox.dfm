inherited DlgForm_PSInputBox: TDlgForm_PSInputBox
  Left = 420
  Top = 255
  Caption = 'P.S '#51077#47141' '
  ClientHeight = 319
  ClientWidth = 506
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited MessageBar: TDRMessageBar
    Top = 294
    Width = 506
  end
  inherited DRPanel_Btn: TDRPanel
    Width = 506
    DesignSize = (
      506
      27)
    inherited DRBitBtn1: TDRBitBtn
      Left = 2
      Visible = False
    end
    inherited DRBitBtn2: TDRBitBtn
      Left = 439
      Caption = #45803#44592'(F7)'
      ModalResult = 2
      OnClick = DRBitBtn2Click
    end
    inherited DRBitBtn3: TDRBitBtn
      Left = 373
      Caption = #49325#51228
      OnClick = DRBitBtn3Click
    end
    inherited DRBitBtn4: TDRBitBtn
      Left = 307
      Caption = #51200#51109'(F5)'
      OnClick = DRBitBtn4Click
    end
  end
  object DRPanel_Top: TDRPanel [2]
    Left = 0
    Top = 27
    Width = 506
    Height = 129
    Align = alTop
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object DRMemo_LineNo: TDRMemo
      Left = 0
      Top = 0
      Width = 12
      Height = 129
      Align = alLeft
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      Lines.Strings = (
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7'
        '8'
        '9'
        '0')
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      OnKeyDown = DRMemo_LineNoKeyDown
    end
    object DRMemo_PS: TDRMemo
      Left = 12
      Top = 0
      Width = 494
      Height = 129
      Align = alClient
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeMode = imSAlpha
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
      ParentFont = False
      TabOrder = 1
      OnKeyDown = DRMemo_PSKeyDown
      OnKeyPress = DRMemo_PSKeyPress
    end
  end
  object DRPanel_Left: TDRPanel [3]
    Left = 0
    Top = 178
    Width = 506
    Height = 47
    Align = alTop
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object DRMemo1: TDRMemo
      Left = 0
      Top = 0
      Width = 12
      Height = 47
      Align = alLeft
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      Lines.Strings = (
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7'
        '8'
        '9'
        '0')
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      OnKeyDown = DRMemo_LineNoKeyDown
    end
    object DRMemo_LeftPS: TDRMemo
      Tag = 1
      Left = 12
      Top = 0
      Width = 494
      Height = 47
      Align = alClient
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeMode = imSAlpha
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
      ParentFont = False
      TabOrder = 1
      OnKeyDown = DRMemo_PSKeyDown
      OnKeyPress = DRMemo_PSKeyPress
    end
  end
  object DRPanel_Right: TDRPanel [4]
    Left = 0
    Top = 247
    Width = 506
    Height = 47
    Align = alClient
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    object DRMemo3: TDRMemo
      Left = 0
      Top = 0
      Width = 12
      Height = 47
      Align = alLeft
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      Lines.Strings = (
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7'
        '8'
        '9'
        '0')
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      OnKeyDown = DRMemo_LineNoKeyDown
    end
    object DRMemo_RightPS: TDRMemo
      Tag = 2
      Left = 12
      Top = 0
      Width = 494
      Height = 47
      Align = alClient
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeMode = imSAlpha
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
      ParentFont = False
      TabOrder = 1
      OnKeyDown = DRMemo_PSKeyDown
      OnKeyPress = DRMemo_PSKeyPress
    end
  end
  object DRPanel1: TDRPanel [5]
    Left = 0
    Top = 156
    Width = 506
    Height = 22
    Align = alTop
    BevelInner = bvLowered
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -15
    Font.Name = #44404#47548#52404
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    object DRLabel1: TDRLabel
      Left = 2
      Top = 6
      Width = 48
      Height = 12
      Caption = #50812#51901' P.S'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
  end
  object DRPanel2: TDRPanel [6]
    Left = 0
    Top = 225
    Width = 506
    Height = 22
    Align = alTop
    BevelInner = bvLowered
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -15
    Font.Name = #44404#47548#52404
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    object DRLabel4: TDRLabel
      Left = 2
      Top = 5
      Width = 60
      Height = 12
      Caption = #50724#47480#51901' P.S'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
  end
  object ADOQuery_InputPS: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 224
    Top = 83
  end
end
