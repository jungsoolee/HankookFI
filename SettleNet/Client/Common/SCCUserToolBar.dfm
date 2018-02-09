inherited DlgForm_UserToolBar: TDlgForm_UserToolBar
  Left = 327
  Top = 259
  ActiveControl = DRSecTypeCombo1
  Caption = #49324#50857#51088' ToolBar '#44288#47532
  ClientWidth = 530
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited MessageBar: TDRMessageBar
    Width = 530
  end
  inherited DRPanel_Btn: TDRPanel
    Width = 530
    inherited DRBitBtn1: TDRBitBtn
      Left = 463
    end
    inherited DRBitBtn2: TDRBitBtn
      Left = 398
      Caption = #52712#49548'(F8)'
      OnClick = DRBitBtn2Click
    end
    inherited DRBitBtn3: TDRBitBtn
      Left = 332
      Caption = #51201#50857'(F5)'
      OnClick = DRBitBtn3Click
    end
    inherited DRBitBtn4: TDRBitBtn
      Left = 267
      Visible = False
    end
  end
  object DRFramePanel1: TDRFramePanel [2]
    Left = 0
    Top = 27
    Width = 530
    Height = 35
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object DRLabel1: TDRLabel
      Left = 32
      Top = 13
      Width = 24
      Height = 12
      Caption = #50629#47924
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRSecTypeCombo1: TDRSecTypeCombo
      Left = 70
      Top = 8
      Width = 140
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeMode = imSHanguel
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      InsertAllItem = False
      ReadOnly = True
      TabOrder = 0
      TabStop = True
      OnCodeChange = DRSecTypeCombo1CodeChange
    end
  end
  object DRFramePanel2: TDRFramePanel [3]
    Left = 0
    Top = 62
    Width = 530
    Height = 266
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 3
    object DRLabel2: TDRLabel
      Left = 20
      Top = 18
      Width = 72
      Height = 12
      Caption = '> '#47700#45684#47532#49828#53944
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel3: TDRLabel
      Left = 277
      Top = 18
      Width = 108
      Height = 12
      Caption = '> '#49324#50857#51088#51221#51032' '#47700#45684' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRStrGrid_UserMenu: TDRStringGrid
      Left = 273
      Top = 38
      Width = 240
      Height = 212
      TabStop = False
      Color = clWhite
      ColCount = 1
      DefaultRowHeight = 15
      DragCursor = crHandPoint
      FixedCols = 0
      RowCount = 30
      FixedRows = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      Options = [goColSizing, goRowSelect, goThumbTracking]
      ParentFont = False
      ParentShowHint = False
      ScrollBars = ssVertical
      ShowHint = True
      TabOrder = 0
      OnDragDrop = DRStrGrid_UserMenuDragDrop
      OnDragOver = DRStrGrid_UserMenuDragOver
      OnDrawCell = DRStrGrid_UserMenuDrawCell
      OnMouseDown = DRStrGrid_MenuMouseDown
      OnSelectCell = DRStrGrid_UserMenuSelectCell
      AllowFixedRowClick = False
      TopRow = 0
      LeftCol = 0
      SelectedCellColor = 16047570
      SelectedFontColor = clBlack
      ColWidths = (
        236)
      AlignCol = {000001}
      FixedAlignRow = {000002}
      Cells = (
        0
        0
        #49324#50857#51088#51221#51032' '#47700#45684)
    end
    object DRStrGrid_AllMenu: TDRStringGrid
      Left = 18
      Top = 38
      Width = 240
      Height = 212
      TabStop = False
      Color = clBtnFace
      ColCount = 1
      DefaultRowHeight = 15
      DragCursor = crHandPoint
      FixedCols = 0
      RowCount = 30
      FixedRows = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      Options = [goColSizing, goRowSelect, goThumbTracking]
      ParentFont = False
      ParentShowHint = False
      ScrollBars = ssVertical
      ShowHint = True
      TabOrder = 1
      OnDragDrop = DRStrGrid_AllMenuDragDrop
      OnDragOver = DRStrGrid_AllMenuDragOver
      OnMouseDown = DRStrGrid_MenuMouseDown
      OnSelectCell = DRStrGrid_AllMenuSelectCell
      AllowFixedRowClick = False
      TopRow = 0
      LeftCol = 0
      SelectedCellColor = 16047570
      SelectedFontColor = clBlack
      ColWidths = (
        219)
      AlignCol = {000001}
      FixedAlignRow = {000002}
      Cells = (
        0
        0
        #49324#50857#51088#51221#51032' '#47700#45684)
    end
  end
  object DRPopupMenu_Property: TDRPopupMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    AutoPopup = False
    Left = 408
    Top = 150
    object MenuItem_Property: TMenuItem
      Caption = #50500#51060#53080#48320#44221
      OnClick = MenuItem_PropertyClick
    end
  end
  object ADOQuery_Main: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 408
    Top = 216
  end
end
