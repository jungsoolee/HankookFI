inherited Form_Dlg_STLDate: TForm_Dlg_STLDate
  Left = 414
  Top = 279
  BorderIcons = [biSystemMenu, biMinimize, biHelp]
  Caption = #44208#51228#51068' '#51221#48372' '#44288#47532
  ClientHeight = 215
  ClientWidth = 464
  PixelsPerInch = 96
  TextHeight = 13
  inherited MessageBar: TDRMessageBar
    Top = 190
    Width = 464
  end
  inherited DRPanel_Btn: TDRPanel
    Width = 464
    inherited DRBitBtn1: TDRBitBtn
      Left = 397
      Cancel = True
      Font.Color = clBlack
    end
    inherited DRBitBtn2: TDRBitBtn
      Left = 332
      Caption = #51201#50857
      Font.Color = clBlack
      OnClick = DRBitBtn2Click
    end
    inherited DRBitBtn3: TDRBitBtn
      Left = 266
      Caption = #51312#54924
      Font.Color = clBlack
      OnClick = DRBitBtn3Click
    end
    inherited DRBitBtn4: TDRBitBtn
      Left = 201
      Font.Color = clNavy
    end
    object DRPanel_Title: TDRPanel
      Left = 1
      Top = 1
      Width = 190
      Height = 25
      Align = alLeft
      BevelInner = bvRaised
      BevelOuter = bvNone
      BevelWidth = 2
      Caption = #44208#51228#51068' '#51221#48372' '#44288#47532
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 11141120
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
    end
  end
  object DRPanel1: TDRPanel [2]
    Left = 0
    Top = 27
    Width = 464
    Height = 163
    Align = alClient
    BevelInner = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object DRGroupBox_mandaRtoRry: TDRGroupBox
      Left = 8
      Top = 8
      Width = 449
      Height = 145
      Caption = #47588#47588#44208#51228#51068' '#51221#48372
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object DRLabel1: TDRLabel
        Left = 21
        Top = 23
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
      object DRLabel2: TDRLabel
        Left = 21
        Top = 46
        Width = 48
        Height = 12
        Caption = #44208#51228#51068#51088
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRLabel10: TDRLabel
        Left = 206
        Top = 71
        Width = 84
        Height = 12
        Caption = #47588#46020#51088#44552#44208#51228#51068
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRLabel65: TDRLabel
        Left = 21
        Top = 70
        Width = 84
        Height = 12
        Caption = #47588#49688#51088#44552#44208#51228#51068
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRLabel4: TDRLabel
        Left = 21
        Top = 99
        Width = 36
        Height = 12
        Caption = #51312#51089#51088
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRLabel5: TDRLabel
        Left = 206
        Top = 98
        Width = 48
        Height = 12
        Caption = #51312#51089#49884#44036
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRMaskEdit_TRADEDate: TDRMaskEdit
        Tag = 4
        Left = 116
        Top = 19
        Width = 79
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
        Text = '20060203'
        OnKeyPress = DRMaskEdit_TRADEDateKeyPress
      end
      object DRMaskEdit_STLDate: TDRMaskEdit
        Tag = 1
        Left = 116
        Top = 43
        Width = 80
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
        TabOrder = 1
        OnKeyPress = DRMaskEdit_DateKeyPress
      end
      object DRMaskEdit_BUYDate: TDRMaskEdit
        Tag = 2
        Left = 116
        Top = 67
        Width = 80
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
        TabOrder = 2
        OnKeyPress = DRMaskEdit_DateKeyPress
      end
      object DRMaskEdit_SELDate: TDRMaskEdit
        Tag = 3
        Left = 296
        Top = 67
        Width = 80
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
        TabOrder = 3
        OnKeyPress = DRMaskEdit_DateKeyPress
      end
      object DREdit_OprID: TDREdit
        Left = 116
        Top = 94
        Width = 80
        Height = 20
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeMode = imSAlpha
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
        ParentFont = False
        ReadOnly = True
        TabOrder = 4
      end
      object DREdit_OprTime: TDREdit
        Left = 296
        Top = 94
        Width = 141
        Height = 20
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeMode = imSAlpha
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
        ParentFont = False
        ReadOnly = True
        TabOrder = 5
      end
    end
  end
  inherited DRSaveDialog_GridExport: TDRSaveDialog
    Left = 584
    Top = 360
  end
  object ADOQuery_SUSTLDT: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 232
    Top = 35
  end
  object ADOQuery_SUSTLDT_Insert: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 376
    Top = 35
  end
  object ADOQuery_SETRADE_Update: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 288
    Top = 35
  end
end
