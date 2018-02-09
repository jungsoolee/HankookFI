inherited DlgForm_AccNoSearch: TDlgForm_AccNoSearch
  Left = 443
  Top = 203
  Caption = #44228#51340' '#44160#49353
  ClientHeight = 388
  ClientWidth = 393
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited MessageBar: TDRMessageBar
    Top = 363
    Width = 393
  end
  inherited DRPanel_Btn: TDRPanel
    Width = 393
    inherited DRBitBtn1: TDRBitBtn
      Tag = 1
      Left = 326
      Cancel = True
      Caption = #45803#44592
      TabOrder = 4
    end
    inherited DRBitBtn2: TDRBitBtn
      Tag = 1
      Left = 261
      Caption = #54869#51064
      TabOrder = 3
      OnClick = DRBitBtn2Click
    end
    inherited DRBitBtn3: TDRBitBtn
      Tag = 1
      Left = 196
      TabOrder = 2
      Visible = False
    end
    inherited DRBitBtn4: TDRBitBtn
      Tag = 2
      Left = 131
      TabOrder = 1
      Visible = False
    end
    object DRBitBtn6: TDRBitBtn
      Tag = 1
      Left = 66
      Top = 1
      Width = 65
      Height = 25
      Anchors = [akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Visible = False
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
  end
  object DRPanel1: TDRPanel [2]
    Left = 0
    Top = 27
    Width = 393
    Height = 336
    Align = alClient
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object DRPanel7: TDRPanel
      Left = 0
      Top = 0
      Width = 393
      Height = 63
      Align = alTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object DRLabel4: TDRLabel
        Left = 27
        Top = 36
        Width = 36
        Height = 12
        Caption = #44160#49353#50612
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRLabel1: TDRLabel
        Left = 27
        Top = 11
        Width = 174
        Height = 12
        Caption = #44228#51340#44160#49353' ('#44228#51340#48264#54840' or '#44228#51340#47749')'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DREdit_Data: TDREdit
        Left = 72
        Top = 32
        Width = 169
        Height = 20
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = 'Microsoft IME 2003'
        ParentFont = False
        TabOrder = 0
        OnKeyDown = DREdit_DataKeyDown
      end
      object DRButton1: TDRButton
        Left = 243
        Top = 30
        Width = 65
        Height = 25
        Caption = #51312#54924
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = DRButton1Click
      end
    end
    object DRStrGrid_Acc: TDRStringGrid
      Left = 0
      Top = 63
      Width = 393
      Height = 273
      Align = alClient
      Color = clWhite
      ColCount = 3
      DefaultRowHeight = 18
      FixedCols = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
      ParentFont = False
      TabOrder = 1
      OnDblClick = DRStrGrid_AccDblClick
      OnSelectCell = DRStrGrid_AccSelectCell
      OnFiexedRowClick = DRStrGrid_AccFiexedRowClick
      AllowFixedRowClick = True
      TopRow = 1
      LeftCol = 0
      SelectedCellColor = 16047570
      SelectedFontColor = clBlack
      ColWidths = (
        88
        140
        142)
      AlignCell = {000000000201000000020200000002}
      AlignCol = {000001010001020001}
      Cells = (
        0
        0
        #44228#51340#48264#54840
        0
        1
        '123456789012'
        1
        0
        #44228#51340#47749
        2
        0
        #48512#44592#47749
        2
        1
        '1')
    end
  end
  inherited DRSaveDialog_GridExport: TDRSaveDialog
    Left = 64
    Top = 192
  end
  object ADOQuery_Temp: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 48
    Top = 267
  end
end
