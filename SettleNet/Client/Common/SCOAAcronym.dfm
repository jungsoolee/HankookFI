inherited DlgForm_OAAcronym: TDlgForm_OAAcronym
  Left = 467
  Top = 362
  Caption = 'OASYS ACRONYM '#51077#47141
  ClientHeight = 241
  ClientWidth = 252
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited MessageBar: TDRMessageBar
    Top = 216
    Width = 252
  end
  inherited DRPanel_Btn: TDRPanel
    Width = 252
    TabOrder = 2
    inherited DRBitBtn1: TDRBitBtn
      Left = 185
      Caption = #45803#44592'(F7)'
      TabOrder = 2
    end
    inherited DRBitBtn2: TDRBitBtn
      Left = 120
      Caption = #49325#51228
      TabOrder = 1
      OnClick = DRBitBtn2Click
    end
    inherited DRBitBtn3: TDRBitBtn
      Left = 54
      Caption = #51077#47141
      TabOrder = 0
      OnClick = DRBitBtn3Click
    end
    inherited DRBitBtn4: TDRBitBtn
      Left = -11
      TabOrder = 3
      Visible = False
    end
  end
  object DRPanel1: TDRPanel [2]
    Left = 0
    Top = 27
    Width = 252
    Height = 189
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object DRPanel2: TDRPanel
      Left = 1
      Top = 67
      Width = 250
      Height = 121
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object DRStrGrid_AcronymLst: TDRStringGrid
        Left = 1
        Top = 1
        Width = 248
        Height = 119
        TabStop = False
        Align = alClient
        Color = clWhite
        ColCount = 2
        DefaultColWidth = 75
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
        OnDblClick = DRStrGrid_AcronymLstDblClick
        OnSelectCell = DRStrGrid_AcronymLstSelectCell
        AllowFixedRowClick = False
        TopRow = 1
        LeftCol = 0
        SelectedCellColor = 16047570
        SelectedFontColor = clBlack
        NextCellEdit = nc_downright
        NextCellTab = nc_downright
        AfterLastCellEdit = lc_stop
        ColWidths = (
          124
          102)
        AlignCol = {000001010002}
        FixedAlignCol = {000002}
        FixedAlignRow = {000002}
        Cells = (
          0
          0
          #44536#47353#47749
          0
          1
          'Client1'
          0
          2
          'Client2'
          1
          0
          'Acronym'
          1
          1
          'CLIENT'
          1
          2
          'OFFICE')
      end
    end
    object DRPanel3: TDRPanel
      Left = 1
      Top = 1
      Width = 250
      Height = 66
      Align = alTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object DRLabel1: TDRLabel
        Left = 10
        Top = 41
        Width = 78
        Height = 12
        Caption = 'Alert Acronym'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRLabel_Group: TDRLabel
        Left = 52
        Top = 14
        Width = 36
        Height = 12
        Caption = 'Client'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRUserCodeCombo_Group: TDRUserCodeCombo
        Left = 96
        Top = 10
        Width = 140
        Height = 20
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeMode = imDontCare
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        InsertAllItem = False
        ReadOnly = False
        TabOrder = 0
        TabStop = True
        OnCodeChange = DRUserCodeCombo_GroupCodeChange
        OnEditKeyPress = DRUserCodeCombo_GroupEditKeyPress
      end
      object DREdit_Acronym: TDREdit
        Left = 96
        Top = 35
        Width = 137
        Height = 20
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = 'Microsoft IME 2003'
        ParentFont = False
        TabOrder = 1
        OnKeyPress = DREdit_AcronymKeyPress
      end
    end
  end
  inherited DRSaveDialog_GridExport: TDRSaveDialog
    Left = 80
    Top = 144
  end
  object ADOQuery_Tmp: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 160
    Top = 155
  end
end
