inherited Form_SCFH8104: TForm_SCFH8104
  Tag = 8104
  Left = 238
  Top = 483
  Width = 979
  Height = 523
  Caption = '[8104] '#48372#44256#49436' '#44288#47532
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited DRPanel_Top: TDRPanel
    Width = 971
    inherited DRPanel_Title: TDRPanel
      Caption = #48372#44256#49436' '#44288#47532
    end
    inherited DRBitBtn1: TDRBitBtn
      Left = 904
    end
    inherited DRBitBtn2: TDRBitBtn
      Left = 838
      Caption = #51064#49604
      OnClick = DRBitBtn2Click
    end
    inherited DRBitBtn3: TDRBitBtn
      Tag = 2
      Left = 772
      Caption = #51200#51109'(F5)'
      OnClick = DRBitBtn3Click
    end
    inherited DRBitBtn4: TDRBitBtn
      Left = 706
      Caption = #51312#54924
      TabStop = False
      OnClick = DRBitBtn4Click
    end
    inherited DRBitBtn5: TDRBitBtn
      Left = 640
      Visible = False
    end
    inherited DRBitBtn6: TDRBitBtn
      Left = 574
      Visible = False
    end
  end
  inherited MessageBar: TDRMessageBar
    Top = 467
    Width = 971
  end
  object DRPanel1: TDRPanel [4]
    Left = 0
    Top = 27
    Width = 971
    Height = 440
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    object DRPanel2: TDRPanel
      Left = 1
      Top = 1
      Width = 464
      Height = 438
      Align = alLeft
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object DRStrGrid_Report: TDRStringGrid
        Left = 1
        Top = 1
        Width = 462
        Height = 436
        Align = alClient
        Color = clWhite
        ColCount = 2
        DefaultRowHeight = 18
        FixedCols = 0
        RowCount = 30
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
        ParentFont = False
        TabOrder = 0
        OnDblClick = DRStrGrid_ReportDblClick
        OnSelectCell = DRStrGrid_ReportSelectCell
        AllowFixedRowClick = False
        TopRow = 1
        LeftCol = 0
        Editable = False
        SelectedCellColor = 16047570
        SelectedFontColor = clBlack
        ColWidths = (
          56
          384)
        AlignCol = {000002}
        FixedAlignRow = {000002}
        Cells = (
          0
          0
          #48372#44256#49436'ID'
          0
          1
          '001'
          1
          0
          #48372#44256#49436#47749
          1
          1
          #48372#44256#49436#47749'1234567890')
      end
    end
    object DRPanel3: TDRPanel
      Left = 465
      Top = 1
      Width = 505
      Height = 438
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      DesignSize = (
        505
        438)
      object DRLabel1: TDRLabel
        Left = 16
        Top = 20
        Width = 48
        Height = 12
        Caption = #48372#44256#49436'ID'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRLabel2: TDRLabel
        Left = 16
        Top = 50
        Width = 48
        Height = 12
        Caption = #48372#44256#49436#47749
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRLabel3: TDRLabel
        Left = 16
        Top = 80
        Width = 60
        Height = 12
        Caption = #54868#47732#52636#47141#47749
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRLabel4: TDRLabel
        Left = 16
        Top = 110
        Width = 60
        Height = 12
        Caption = #52636#47141#54028#51068#47749
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRLabel5: TDRLabel
        Left = 16
        Top = 140
        Width = 60
        Height = 12
        Caption = #52392#48512#54028#51068#47749
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRLabel6: TDRLabel
        Left = 16
        Top = 170
        Width = 48
        Height = 12
        Caption = #47700#51068#51228#47785
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRLabel7: TDRLabel
        Left = 205
        Top = 20
        Width = 60
        Height = 12
        Caption = #51312#51089#51088#51221#48372
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRLabel8: TDRLabel
        Left = 16
        Top = 200
        Width = 48
        Height = 12
        Caption = #47700#51068#48376#47928
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DREdit_MgrOprTime: TDREdit
        Left = 331
        Top = 17
        Width = 142
        Height = 20
        TabStop = False
        Anchors = [akLeft, akTop, akRight]
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
        TabOrder = 0
      end
      object DREdit_MgrOprId: TDREdit
        Left = 269
        Top = 17
        Width = 59
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
        TabOrder = 1
      end
      object DREdit_ReportID: TDREdit
        Left = 104
        Top = 16
        Width = 65
        Height = 20
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
        TabOrder = 2
        OnKeyPress = DREdit_KeyPress
      end
      object DREdit_ReportName: TDREdit
        Left = 104
        Top = 46
        Width = 369
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
        OnKeyPress = DREdit_KeyPress
      end
      object DREdit_ViewFileName: TDREdit
        Left = 104
        Top = 77
        Width = 369
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        MaxLength = 200
        ParentFont = False
        TabOrder = 4
        OnKeyPress = DREdit_KeyPress
      end
      object DREdit_AddFileName: TDREdit
        Left = 104
        Top = 137
        Width = 369
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        MaxLength = 200
        ParentFont = False
        TabOrder = 6
        OnKeyPress = DREdit_KeyPress
      end
      object DREdit_SubjectData: TDREdit
        Left = 104
        Top = 167
        Width = 369
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        MaxLength = 200
        ParentFont = False
        TabOrder = 7
        OnKeyPress = DREdit_KeyPress
      end
      object DREdit_FileNameInfo: TDREdit
        Left = 104
        Top = 107
        Width = 369
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        MaxLength = 200
        ParentFont = False
        TabOrder = 5
        OnKeyPress = DREdit_KeyPress
      end
      object DRMemo_MailBodyData: TDRMemo
        Left = 104
        Top = 197
        Width = 369
        Height = 226
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        Lines.Strings = (
          'DRMemo_MailBodyData')
        ParentFont = False
        TabOrder = 8
      end
    end
  end
  inherited ADOQuery_DECLN: TADOQuery
    Left = 72
    Top = 213
  end
  inherited DRSaveDialog_GridExport: TDRSaveDialog
    Left = 192
    Top = 216
  end
  object DrStringPrint1: TDrStringPrint
    EndLinePrint = True
    TitleGroup = False
    ColLine = False
    PrintAlignType = plAutoSize
    Orientation = poLandscape
    Left = 72
    Top = 312
  end
end
