inherited DlgForm_OASndType: TDlgForm_OASndType
  Left = 604
  Top = 427
  Caption = 'OASYS '#51088#46041#54868#49444#51221
  ClientHeight = 117
  ClientWidth = 261
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited MessageBar: TDRMessageBar
    Top = 92
    Width = 261
  end
  inherited DRPanel_Btn: TDRPanel
    Width = 261
    TabOrder = 2
    inherited DRBitBtn1: TDRBitBtn
      Left = 194
      Caption = #45803#44592'(F7)'
      TabOrder = 1
    end
    inherited DRBitBtn2: TDRBitBtn
      Left = 129
      Caption = #51200#51109'(F5)'
      TabOrder = 0
      OnClick = DRBitBtn2Click
    end
    inherited DRBitBtn3: TDRBitBtn
      Left = 63
      TabOrder = 3
      Visible = False
    end
    inherited DRBitBtn4: TDRBitBtn
      Left = -2
      TabOrder = 2
      Visible = False
    end
  end
  object DRPanel1: TDRPanel [2]
    Left = 0
    Top = 27
    Width = 261
    Height = 65
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object DRGroupBox1: TDRGroupBox
      Left = 14
      Top = 3
      Width = 233
      Height = 54
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object DRRadioButton_AutoOK: TDRRadioButton
        Left = 20
        Top = 13
        Width = 193
        Height = 17
        Caption = 'OASYS ccm '#51088#46041#51204#49569' '#49444#51221
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object DRRadioButton_AutoNO: TDRRadioButton
        Left = 20
        Top = 33
        Width = 193
        Height = 17
        Caption = 'OASYS ccm '#51088#46041#51204#49569' '#54644#51228
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
    end
  end
  inherited DRSaveDialog_GridExport: TDRSaveDialog
    Left = 32
    Top = 0
  end
  object ADOQuery_Tmp: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 216
    Top = 35
  end
end
