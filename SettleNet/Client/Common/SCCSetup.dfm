inherited Form_Setup: TForm_Setup
  Left = 1599
  Top = 438
  Caption = #54872#44221#49444#51221
  PixelsPerInch = 96
  TextHeight = 13
  inherited DRPanel_Btn: TDRPanel
    inherited DRBitBtn2: TDRBitBtn
      Caption = #51201#50857
      OnClick = DRBitBtn2Click
    end
    inherited DRBitBtn3: TDRBitBtn
      Visible = False
    end
    inherited DRBitBtn4: TDRBitBtn
      Visible = False
    end
  end
  object DRPageControl_SystemSetup: TDRPageControl [2]
    Left = 0
    Top = 27
    Width = 402
    Height = 301
    ActivePage = DRTabSheet_User
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
    object DRTabSheet_User: TDRTabSheet
      Caption = #49324#50857#51088
      GripAlign = gaLeft
      ImageIndex = -1
      StaticPageIndex = -1
      TabVisible = True
      object DRLabel1: TDRLabel
        Left = 8
        Top = 8
        Width = 150
        Height = 12
        Caption = '[2801]'#47588#47588' '#49569#49688#49888' Manager'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRLabel2: TDRLabel
        Left = 8
        Top = 80
        Width = 138
        Height = 12
        Caption = #50868#50689#52404#51228' > '#44397#44032' '#48143' '#50616#50612
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRLabel_UserLocale: TDRLabel
        Left = 10
        Top = 102
        Width = 227
        Height = 15
        Caption = #54805#49885' : Korean              '#49884#49828#53596' '#47196#52888' : Korean'
        Font.Charset = ANSI_CHARSET
        Font.Color = 4194432
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object DRPanel1: TDRPanel
        Left = 167
        Top = 13
        Width = 223
        Height = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object DRCheckBox_Today: TDRCheckBox
        Left = 9
        Top = 30
        Width = 208
        Height = 19
        Hint = #47588#47588' '#51204#49569#49884' '#45216#51676#47484' '#54869#51064#54616#50668' '#50724#45720#51060' '#50500#45776#44221#50864' '#54869#51064' '#47700#49884#51648#47484' '#48372#50668#51469#45768#45796'.'
        Caption = #47588#47588' '#51204#49569#49884' '#50724#45720#45216#51676' '#54869#51064' '#50668#48512
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object DRPanel2: TDRPanel
        Left = 167
        Top = 85
        Width = 223
        Height = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object DRBitBtn_ConfirmLocale: TDRBitBtn
        Left = 325
        Top = 99
        Width = 65
        Height = 20
        Caption = #54869#51064
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = DRBitBtn_ConfirmLocaleClick
        BorderWidth = 3
        BorderColor = 10790052
        MouseOverColor = clNavy
      end
    end
    object DRTabSheetSystem: TDRTabSheet
      Caption = #49884#49828#53596
      GripAlign = gaLeft
      ImageIndex = -1
      StaticPageIndex = -1
      TabVisible = True
      object DRStringGrid_System: TDRStringGrid
        Left = 0
        Top = 24
        Width = 394
        Height = 250
        Align = alBottom
        Color = clWhite
        ColCount = 3
        DefaultRowHeight = 18
        FixedCols = 0
        RowCount = 30
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goThumbTracking]
        ParentFont = False
        TabOrder = 0
        AllowFixedRowClick = False
        TopRow = 1
        LeftCol = 0
        SelectedCellColor = 16047570
        SelectedFontColor = clBlack
        ColWidths = (
          52
          105
          364)
        AlignCol = {000002010001020001}
        FixedAlignCol = {000002010002020002}
        Cells = (
          0
          0
          'OPT_CODE'
          0
          1
          'E03'
          1
          0
          'OPT_VALUE'
          1
          1
          'Y                                                 '
          2
          0
          'INFO'
          2
          1
          #50641#49472' '#48177#44536#46972#50868#46300' '#49892#54665#49884' '#50724#47448#47700#49884#51648' '#46916#50864#45716' DW20.exe '#49325#51228#54616#44592' Default N')
      end
    end
  end
  inherited DRSaveDialog_GridExport: TDRSaveDialog
    Left = 336
  end
  object ADOQuery_temp: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 264
    Top = 43
  end
end
