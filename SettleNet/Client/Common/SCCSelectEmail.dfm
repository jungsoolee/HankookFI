inherited DlgForm_SelectEmail: TDlgForm_SelectEmail
  Left = 192
  Top = 293
  Caption = 'Email '#51452#49548#49440#53469
  ClientHeight = 473
  ClientWidth = 692
  OldCreateOrder = True
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  inherited MessageBar: TDRMessageBar
    Top = 448
    Width = 692
  end
  inherited DRPanel_Btn: TDRPanel
    Width = 692
    object DRLabel_Title: TDRLabel [0]
      Left = 16
      Top = 8
      Width = 324
      Height = 12
      Caption = #44536#47353#47749' : ????    '#47700#51068#49436#49885' : ????                      '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    inherited DRBitBtn1: TDRBitBtn
      Tag = 2
      Left = 625
    end
    inherited DRBitBtn2: TDRBitBtn
      Tag = 1
      Left = 560
      Caption = #51201#50857'(F4)'
      OnClick = DRBitBtn2Click
    end
    inherited DRBitBtn3: TDRBitBtn
      Tag = 2
      Left = 494
      Caption = #51312#54924
      OnClick = DRBitBtn3Click
    end
    inherited DRBitBtn4: TDRBitBtn
      Tag = 1
      Left = 429
      Top = 27
      Visible = False
    end
  end
  object TDRPanel [2]
    Left = 0
    Top = 27
    Width = 692
    Height = 421
    Align = alClient
    BevelOuter = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    DesignSize = (
      692
      421)
    object DRSpeedBtn_MailRcv: TDRSpeedButton
      Left = 359
      Top = 29
      Width = 84
      Height = 30
      Anchors = [akTop]
      Caption = #48155#45716#49324#46988
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333FF3333333333333003333
        3333333333773FF3333333333309003333333333337F773FF333333333099900
        33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
        99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
        33333333337F3F77333333333309003333333333337F77333333333333003333
        3333333333773333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      Layout = blGlyphRight
      NumGlyphs = 2
      ParentFont = False
      OnClick = DRSpeedBtn_MailRcvClick
    end
    object DRSpeedBtn_CCMailRcv: TDRSpeedButton
      Left = 359
      Top = 209
      Width = 84
      Height = 30
      Anchors = [akTop]
      Caption = #52280#51312'   '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333FF3333333333333003333
        3333333333773FF3333333333309003333333333337F773FF333333333099900
        33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
        99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
        33333333337F3F77333333333309003333333333337F77333333333333003333
        3333333333773333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      Layout = blGlyphRight
      NumGlyphs = 2
      ParentFont = False
      OnClick = DRSpeedBtn_CCMailRcvClick
    end
    object DRSpeedBtn_CCBlindMailRcv: TDRSpeedButton
      Left = 359
      Top = 321
      Width = 84
      Height = 30
      Anchors = [akTop]
      Caption = #49704#51008#52280#51312
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333FF3333333333333003333
        3333333333773FF3333333333309003333333333337F773FF333333333099900
        33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
        99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
        33333333337F3F77333333333309003333333333337F77333333333333003333
        3333333333773333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      Layout = blGlyphRight
      NumGlyphs = 2
      ParentFont = False
      OnClick = DRSpeedBtn_CCBlindMailRcvClick
    end
    object DRGroupBox1: TDRGroupBox
      Left = 3
      Top = 2
      Width = 347
      Height = 415
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object DRSpeedButton_RegEmailAddr: TDRSpeedButton
        Left = 201
        Top = 384
        Width = 140
        Height = 25
        Caption = #49688#49888#52376' '#46321#47197#51221#48372
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          33333333333333333333333333C3333333333333337F3333333333333C0C3333
          333333333777F33333333333C0F0C3333333333377377F333333333C0FFF0C33
          3333333777F377F3333333CCC0FFF0C333333373377F377F33333CCCCC0FFF0C
          333337333377F377F3334CCCCCC0FFF0C3337F3333377F377F33C4CCCCCC0FFF
          0C3377F333F377F377F33C4CC0CCC0FFF0C3377F3733F77F377333C4CCC0CC0F
          0C333377F337F3777733333C4C00CCC0333333377F773337F3333333C4CCCCCC
          3333333377F333F7333333333C4CCCC333333333377F37733333333333C4C333
          3333333333777333333333333333333333333333333333333333}
        NumGlyphs = 2
        ParentFont = False
        OnClick = DRSpeedButton_RegEmailAddrClick
      end
      object DRListView_MailList: TDRListView
        Left = 3
        Top = 7
        Width = 341
        Height = 373
        BiDiMode = bdLeftToRight
        Color = clWhite
        Columns = <
          item
            Caption = #49688#49888#52376#47749
            Width = 150
          end
          item
            AutoSize = True
            Caption = #51060#47700#51068#51452#49548
          end>
        DragCursor = crMultiDrag
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        FullDrag = True
        IconOptions.Arrangement = iaLeft
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        ParentBiDiMode = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = DRListView_MailListColumnClick
        OnDblClick = DRListView_MailListDblClick
        OnDragDrop = DRListView_MailListDragDrop
        OnDragOver = DRListView_MailListDragOver
        OnMouseDown = DRListView_MailListMouseDown
      end
    end
    object DRListView_CCBlindMailRcv: TDRListView
      Left = 449
      Top = 303
      Width = 236
      Height = 105
      Columns = <
        item
          AutoSize = True
          Caption = #49688#49888#52376#47749
        end>
      DragCursor = crMultiDrag
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      FullDrag = True
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      ParentFont = False
      TabOrder = 1
      ViewStyle = vsReport
      OnDragDrop = DRListView_CCBlindMailRcvDragDrop
      OnDragOver = DRListView_MailRcvDragOver
      OnKeyDown = DRListView_CCBlindMailRcvKeyDown
      OnKeyPress = DRListView_CCBlindMailRcvKeyPress
      OnMouseDown = DRListView_CCBlindMailRcvMouseDown
    end
    object DRListView_CCMailRcv: TDRListView
      Left = 449
      Top = 189
      Width = 236
      Height = 106
      Columns = <
        item
          AutoSize = True
          Caption = #49688#49888#52376#47749
        end>
      DragCursor = crMultiDrag
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      FullDrag = True
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      ParentFont = False
      TabOrder = 2
      ViewStyle = vsReport
      OnDragDrop = DRListView_CCMailRcvDragDrop
      OnDragOver = DRListView_MailRcvDragOver
      OnKeyDown = DRListView_CCMailRcvKeyDown
      OnKeyPress = DRListView_CCMailRcvKeyPress
      OnMouseDown = DRListView_CCMailRcvMouseDown
    end
    object DRListView_MailRcv: TDRListView
      Left = 449
      Top = 11
      Width = 236
      Height = 172
      BiDiMode = bdLeftToRight
      Columns = <
        item
          AutoSize = True
          Caption = #49688#49888#52376#47749
        end>
      DragCursor = crMultiDrag
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      FullDrag = True
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      ParentBiDiMode = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 3
      ViewStyle = vsReport
      OnDragDrop = DRListView_MailRcvDragDrop
      OnDragOver = DRListView_MailRcvDragOver
      OnKeyDown = DRListView_MailRcvKeyDown
      OnKeyPress = DRListView_MailRcvKeyPress
      OnMouseDown = DRListView_MailRcvMouseDown
    end
  end
  object ADOQuery_MailList: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 40
    Top = 75
  end
  object PopupMenuMailRcv: TDRPopupMenu
    AutoHotkeys = maManual
    Left = 555
    Top = 89
    object MenuItem_DelJobMail: TMenuItem
      Caption = #49325#51228
      OnClick = MenuItem_DelJobMailClick
    end
  end
  object PopupMenuCCMailRcv: TDRPopupMenu
    AutoHotkeys = maManual
    Left = 539
    Top = 241
    object MenuItem_DelJobCC: TMenuItem
      Caption = #49325#51228
      OnClick = MenuItem_DelJobCCClick
    end
  end
  object PopupMenuCCBlindRcv: TDRPopupMenu
    AutoHotkeys = maManual
    Left = 539
    Top = 361
    object MenuItem_DelJobBlind: TMenuItem
      Caption = #49325#51228
      OnClick = MenuItem_DelJobBlindClick
    end
  end
  object PopupMenuAllMailList: TDRPopupMenu
    AutoHotkeys = maManual
    Left = 187
    Top = 81
    object MenuItem1: TMenuItem
      Caption = #48155#45716#49324#46988' ->'
      OnClick = DRSpeedBtn_MailRcvClick
    end
    object N1: TMenuItem
      Caption = #52280#51312'       ->'
      OnClick = DRSpeedBtn_CCMailRcvClick
    end
    object N2: TMenuItem
      Caption = #49704#51008#52280#51312' ->'
      OnClick = DRSpeedBtn_CCBlindMailRcvClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Caption = #49688#49888#52376' '#46321#47197#51221#48372
      OnClick = DRSpeedButton_RegEmailAddrClick
    end
  end
end
