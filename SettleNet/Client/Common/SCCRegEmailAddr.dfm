inherited DlgForm_RegEmailAddr: TDlgForm_RegEmailAddr
  Left = 2995
  Top = 378
  ActiveControl = DREdit_MailRcv
  Caption = #49688#49888#52376' Email '#46321#47197
  ClientHeight = 592
  ClientWidth = 422
  OldCreateOrder = True
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  inherited MessageBar: TDRMessageBar
    Top = 567
    Width = 422
  end
  inherited DRPanel_Btn: TDRPanel
    Width = 422
    inherited DRBitBtn1: TDRBitBtn
      Tag = 2
      Left = 355
    end
    inherited DRBitBtn2: TDRBitBtn
      Tag = 1
      Left = 290
      Caption = #51064#49604
      OnClick = DRBitBtn2Click
    end
    inherited DRBitBtn3: TDRBitBtn
      Tag = 2
      Left = 225
      Caption = #49325#51228
      OnClick = DRBitBtn3Click
    end
    inherited DRBitBtn4: TDRBitBtn
      Tag = 1
      Left = 160
      Caption = #49688#51221
      OnClick = DRBitBtn4Click
    end
    object DRBitBtn5: TDRBitBtn
      Tag = 1
      Left = 95
      Top = 1
      Width = 65
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #51077#47141
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = DRBitBtn5Click
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
    object DRBitBtn6: TDRBitBtn
      Tag = 1
      Left = 30
      Top = 1
      Width = 65
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #51312#54924
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = DRBitBtn6Click
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
  end
  object DRPanel: TDRPanel [2]
    Left = 0
    Top = 27
    Width = 422
    Height = 540
    Align = alClient
    BevelOuter = bvLowered
    Caption = 'DRPanel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object DRPanel1: TDRPanel
      Left = 1
      Top = 194
      Width = 420
      Height = 345
      Align = alClient
      BevelOuter = bvNone
      Caption = 'DRPanel1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object DRStrGrid_MailAddrInsert: TDRStringGrid
        Left = 0
        Top = 0
        Width = 420
        Height = 345
        TabStop = False
        Align = alClient
        Color = clWhite
        ColCount = 2
        DefaultRowHeight = 18
        FixedCols = 0
        RowCount = 33
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnDblClick = DRStrGrid_MailAddrInsertDblClick
        OnMouseMove = DRStrGrid_MailAddrInsertMouseMove
        OnFiexedRowClick = DRStrGrid_MailAddrInsertFiexedRowClick
        AllowFixedRowClick = True
        TopRow = 1
        LeftCol = 0
        SelectedCellColor = 16047570
        SelectedFontColor = clBlack
        ColWidths = (
          140
          258)
        AlignCol = {000001010001}
        FixedAlignRow = {000002}
        Cells = (
          0
          0
          #49688#49888#52376
          0
          1
          #44608#51648#50689
          0
          2
          '0'
          1
          0
          #51060#47700#51068#51452#49548
          1
          1
          'jykim@dataroad.co.kr'
          1
          2
          '1')
      end
    end
    object DRPanel_Edit: TDRPanel
      Left = 1
      Top = 1
      Width = 420
      Height = 193
      Align = alTop
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object DRLabel1: TDRLabel
        Left = 15
        Top = 15
        Width = 48
        Height = 12
        Caption = #49688#49888#52376#47749
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRLabel2: TDRLabel
        Left = 15
        Top = 43
        Width = 60
        Height = 12
        Caption = #51060#47700#51068#51452#49548
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRLabel25: TDRLabel
        Left = 15
        Top = 169
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
      object DREdit_OprID: TDREdit
        Left = 87
        Top = 163
        Width = 61
        Height = 20
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
        ParentFont = False
        ReadOnly = True
        TabOrder = 6
      end
      object DREdit_OprTime: TDREdit
        Left = 147
        Top = 163
        Width = 232
        Height = 20
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
        ParentFont = False
        ReadOnly = True
        TabOrder = 7
      end
      object DREdit_MailRcv: TDREdit
        Left = 87
        Top = 11
        Width = 291
        Height = 20
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        MaxLength = 60
        ParentFont = False
        TabOrder = 0
        OnKeyPress = DREdit_MailRcvKeyPress
      end
      object DREdit_SendSeq: TDREdit
        Left = 380
        Top = 5
        Width = 34
        Height = 20
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
        ParentFont = False
        ReadOnly = True
        TabOrder = 8
        Visible = False
      end
      object DREdit_Addr1: TDREdit
        Left = 87
        Top = 39
        Width = 291
        Height = 20
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = 'Microsoft IME 2003'
        MaxLength = 200
        ParentFont = False
        TabOrder = 1
        OnKeyPress = DREdit_Addr1KeyPress
      end
      object DREdit_Addr2: TDREdit
        Left = 87
        Top = 63
        Width = 291
        Height = 20
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = 'Microsoft IME 2003'
        MaxLength = 200
        ParentFont = False
        TabOrder = 2
        OnKeyPress = DREdit_Addr1KeyPress
      end
      object DREdit_Addr3: TDREdit
        Left = 87
        Top = 87
        Width = 291
        Height = 20
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = 'Microsoft IME 2003'
        MaxLength = 200
        ParentFont = False
        TabOrder = 3
        OnKeyPress = DREdit_Addr1KeyPress
      end
      object DREdit_Addr4: TDREdit
        Left = 87
        Top = 111
        Width = 291
        Height = 20
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = 'Microsoft IME 2003'
        MaxLength = 200
        ParentFont = False
        TabOrder = 4
        OnKeyPress = DREdit_Addr1KeyPress
      end
      object DREdit_Addr5: TDREdit
        Left = 87
        Top = 135
        Width = 291
        Height = 20
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = 'Microsoft IME 2003'
        MaxLength = 200
        ParentFont = False
        TabOrder = 5
        OnKeyPress = DREdit_Addr5KeyPress
      end
    end
  end
  inherited DRSaveDialog_GridExport: TDRSaveDialog
    Left = 288
    Top = 344
  end
  object ADOQuery_SUMELAD: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    SQL.Strings = (
      '')
    Left = 64
    Top = 323
  end
  object DrStringPrint1: TDrStringPrint
    EndLinePrint = True
    TitleGroup = False
    ColLine = False
    PrintAlignType = plAutoSize
    Orientation = poPortrait
    Left = 153
    Top = 325
  end
end
