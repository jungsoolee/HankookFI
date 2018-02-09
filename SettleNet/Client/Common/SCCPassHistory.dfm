object frmPWHistory: TfrmPWHistory
  Left = 488
  Top = 373
  ActiveControl = DRBtnOK
  BorderStyle = bsDialog
  Caption = #54056#49828#50892#46300' '#55176#49828#53664#47532
  ClientHeight = 148
  ClientWidth = 242
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object DRStringGrid1: TDRStringGrid
    Left = 0
    Top = 0
    Width = 241
    Height = 121
    Color = clWhite
    ColCount = 2
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect, goThumbTracking]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
    OnKeyDown = DRStringGrid1KeyDown
    AllowFixedRowClick = False
    TopRow = 1
    LeftCol = 0
    SelectedCellColor = 16047570
    SelectedFontColor = clBlack
    ColWidths = (
      122
      112)
    AlignCell = {00000000020100000002}
    AlignCol = {000002010002}
    Cells = (
      0
      0
      #54056#49828#50892#46300' '#48320#44221#51068
      1
      0
      #54056#49828#50892#46300)
  end
  object DRBtnOK: TDRBitBtn
    Left = 159
    Top = 123
    Width = 82
    Height = 25
    Caption = #54869#51064
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = DRBtnOKClick
    BorderWidth = 3
    BorderColor = 10790052
    MouseOverColor = clNavy
  end
  object ADOQuery_History: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 160
    Top = 56
  end
end
