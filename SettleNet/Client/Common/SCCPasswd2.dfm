object Form_Passwd2: TForm_Passwd2
  Left = 1943
  Top = 385
  Width = 307
  Height = 363
  Caption = #48708#48128#48264#54840' '#48320#44221
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DRPanel_Top: TDRPanel
    Left = 0
    Top = 0
    Width = 299
    Height = 27
    Align = alTop
    BevelInner = bvLowered
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    DesignSize = (
      299
      27)
    object DRBitBtn1: TDRBitBtn
      Left = 232
      Top = 1
      Width = 65
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #51333#47308
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = DRBitBtn1Click
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
    object DRBitBtn2: TDRBitBtn
      Left = 166
      Top = 1
      Width = 65
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #49688#51221
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = DRBitBtn2Click
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
  end
  object DRPanel1: TDRPanel
    Left = 0
    Top = 27
    Width = 299
    Height = 72
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object DRLabel1: TDRLabel
      Left = 23
      Top = 17
      Width = 54
      Height = 12
      Caption = #49324#50857#51088' ID'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel3: TDRLabel
      Left = 23
      Top = 44
      Width = 48
      Height = 12
      Caption = #48708#48128#48264#54840
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DREdit_UserID: TDREdit
      Left = 119
      Top = 13
      Width = 154
      Height = 20
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = 'Microsoft IME 2010'
      MaxLength = 8
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      Text = 'DREdit_UserID'
    end
    object DREdit_NewPasswd: TDREdit
      Left = 119
      Top = 40
      Width = 154
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = 'Microsoft IME 2010'
      MaxLength = 15
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 1
      Text = 'DREdit1'
      OnKeyPress = DREdit_NewPasswdKeyPress
    end
  end
  object MessageBar: TDRMessageBar
    Left = 0
    Top = 311
    Width = 299
    Height = 25
    Align = alBottom
  end
  object DRStringGrid1: TDRStringGrid
    Left = 0
    Top = 99
    Width = 299
    Height = 212
    Align = alClient
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
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect, goThumbTracking]
    ParentFont = False
    TabOrder = 1
    OnDblClick = DRStringGrid1DblClick
    OnSelectCell = DRStringGrid1SelectCell
    AllowFixedRowClick = False
    TopRow = 1
    LeftCol = 0
    SelectedCellColor = 16047570
    SelectedFontColor = clBlack
    ColWidths = (
      64
      64
      148)
    AlignCol = {020002}
    FixedAlignCol = {000002010002020002}
    Cells = (
      0
      0
      #49324#50857#51088' ID'
      0
      1
      'abcdefgh'
      0
      3
      '0'
      1
      0
      #49324#50857#51088#47749
      1
      1
      #50976#44305#51652
      1
      3
      '1'
      2
      0
      #48708#48128#48264#54840' '#48320#44221#51068#49884
      2
      1
      '2099-99-99 99:99:99.99'
      2
      3
      '2')
  end
  object ADOQuery_Main: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 40
    Top = 304
  end
end
