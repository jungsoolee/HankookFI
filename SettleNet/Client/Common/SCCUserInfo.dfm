inherited Form_UserInfo: TForm_UserInfo
  Left = 1605
  Top = 430
  ActiveControl = DREdit_CurPswrd
  Caption = #49324#50857#51088' '#51221#48372' '#44288#47532
  ClientHeight = 473
  ClientWidth = 480
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited MessageBar: TDRMessageBar
    Top = 448
    Width = 480
  end
  inherited DRPanel_Btn: TDRPanel
    Width = 480
    inherited DRBitBtn1: TDRBitBtn
      Left = 413
    end
    inherited DRBitBtn2: TDRBitBtn
      Tag = 1
      Left = 283
      Caption = #52488#44592#54868
      OnClick = DRBitBtn2Click
    end
    inherited DRBitBtn3: TDRBitBtn
      Tag = 2
      Left = 348
      Caption = #54869#51064
      OnClick = DRBitBtn3Click
    end
    inherited DRBitBtn4: TDRBitBtn
      Left = 218
      Visible = False
    end
  end
  object DRPageControl_UserInfo: TDRPageControl [2]
    Left = 0
    Top = 27
    Width = 480
    Height = 421
    ActivePage = DRTabSheet_SecretNum
    Align = alClient
    FlatSeperators = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    HotTrack = False
    TabActiveColor = clWhite
    TabInactiveColor = clBtnFace
    TabInactiveFont.Charset = DEFAULT_CHARSET
    TabInactiveFont.Color = clBlack
    TabInactiveFont.Height = -12
    TabInactiveFont.Name = #44404#47548#52404
    TabInactiveFont.Style = []
    ParentFont = False
    TabOrder = 2
    OnChange = DRPageControl_UserInfoChange
    object DRTabSheet_SecretNum: TDRTabSheet
      Caption = #48708#48128#48264#54840
      GripAlign = gaLeft
      ImageIndex = -1
      StaticPageIndex = -1
      TabVisible = True
      object DRPanel1: TDRPanel
        Left = 0
        Top = 0
        Width = 472
        Height = 233
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
        object DRLabel4: TDRLabel
          Left = 106
          Top = 45
          Width = 48
          Height = 12
          Caption = #49324#50857#51088'ID'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentFont = False
        end
        object DRLabel5: TDRLabel
          Left = 106
          Top = 89
          Width = 72
          Height = 12
          Caption = #44592#51316#48708#48128#48264#54840
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentFont = False
        end
        object DRLabel6: TDRLabel
          Left = 106
          Top = 132
          Width = 72
          Height = 12
          Caption = #49888#44508#48708#48128#48264#54840
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentFont = False
        end
        object DRLabel7: TDRLabel
          Left = 106
          Top = 176
          Width = 72
          Height = 12
          Caption = #48708#48128#48264#54840#54869#51064
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentFont = False
        end
        object DREdit_UserID: TDREdit
          Left = 208
          Top = 39
          Width = 121
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
          MaxLength = 8
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
        end
        object DREdit_CurPswrd: TDREdit
          Left = 208
          Top = 83
          Width = 121
          Height = 20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ImeMode = imSAlpha
          ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
          MaxLength = 15
          ParentFont = False
          PasswordChar = '*'
          TabOrder = 1
          OnKeyPress = DREdit_CurPswrdKeyPress
        end
        object DREdit_NewPswrd: TDREdit
          Left = 208
          Top = 126
          Width = 121
          Height = 20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ImeMode = imSAlpha
          ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
          MaxLength = 15
          ParentFont = False
          PasswordChar = '*'
          TabOrder = 2
          OnKeyPress = DREdit_NewPswrdKeyPress
        end
        object DREdit_ConfirmPswrd: TDREdit
          Left = 208
          Top = 170
          Width = 121
          Height = 20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ImeMode = imSAlpha
          ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
          MaxLength = 15
          ParentFont = False
          PasswordChar = '*'
          TabOrder = 3
          OnKeyPress = DREdit_ConfirmPswrdKeyPress
        end
      end
    end
    object DRTabSheet_Mail: TDRTabSheet
      Caption = #47700#51068
      GripAlign = gaLeft
      ImageIndex = -1
      StaticPageIndex = -1
      TabVisible = True
      object DRLabel1: TDRLabel
        Left = 40
        Top = 32
        Width = 48
        Height = 12
        Caption = #49324#50857#51088#47749
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRLabel2: TDRLabel
        Left = 40
        Top = 66
        Width = 48
        Height = 12
        Caption = #47700#51068#51452#49548
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRBevel1: TDRBevel
        Left = 42
        Top = 101
        Width = 400
        Height = 2
      end
      object DRLabel3: TDRLabel
        Left = 40
        Top = 122
        Width = 360
        Height = 12
        Caption = #49436#47749'   ('#48372#45236#45716' '#47700#49464#51648#50640' '#51088#46041#51004#47196' '#49436#47749#51012' '#49341#51077#54624' '#49688' '#51080#49845#45768#45796'.)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DREdit_UserName: TDREdit
        Left = 110
        Top = 28
        Width = 177
        Height = 20
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeMode = imSAlpha
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        ParentFont = False
        TabOrder = 0
        OnKeyPress = DREdit_UserNameKeyPress
      end
      object DREdit_MailAdd: TDREdit
        Left = 110
        Top = 62
        Width = 329
        Height = 20
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeMode = imSAlpha
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        ParentFont = False
        TabOrder = 1
        OnKeyPress = DREdit_MailAddKeyPress
      end
      object DRMemo_Sign: TDRMemo
        Left = 40
        Top = 147
        Width = 401
        Height = 215
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 2
      end
    end
  end
  object ADOQuery_Main: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 76
    Top = 330
  end
  object ADOQuery_Temp: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 172
    Top = 330
  end
  object ADOQuery_TempA: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 276
    Top = 314
  end
end
