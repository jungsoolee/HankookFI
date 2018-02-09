inherited DlgForm_MergeMail: TDlgForm_MergeMail
  Left = 429
  Top = 230
  Caption = #47700#51068' '#47926#51020
  ClientHeight = 526
  ClientWidth = 405
  PixelsPerInch = 96
  TextHeight = 13
  inherited MessageBar: TDRMessageBar
    Top = 501
    Width = 405
  end
  inherited DRPanel_Btn: TDRPanel
    Width = 405
    inherited DRBitBtn1: TDRBitBtn
      Left = 338
    end
    inherited DRBitBtn2: TDRBitBtn
      Left = 273
      Caption = #49325#51228
      OnClick = DRBitBtn2Click
    end
    inherited DRBitBtn3: TDRBitBtn
      Left = 207
      Caption = #49688#51221
      OnClick = DRBitBtn3Click
    end
    inherited DRBitBtn4: TDRBitBtn
      Left = 142
      Caption = #51077#47141
      OnClick = DRBitBtn4Click
    end
  end
  object DRPanel1: TDRPanel [2]
    Left = 0
    Top = 57
    Width = 405
    Height = 270
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object DRSpeedButton_MailRcv: TDRSpeedButton
      Tag = 2
      Left = 7
      Top = 58
      Width = 76
      Height = 20
      Caption = #49688#49888#52376'  '
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
      OnClick = DRSpeedButton_MailRcvClick
    end
    object DRSpeedButton_CCMailRcv: TDRSpeedButton
      Tag = 2
      Left = 7
      Top = 83
      Width = 76
      Height = 20
      BiDiMode = bdLeftToRight
      Caption = #52280#51312'    '
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
      ParentBiDiMode = False
      OnClick = DRSpeedButton_MailRcvClick
    end
    object DRSpeedButton_CCBlindMailRcv: TDRSpeedButton
      Tag = 2
      Left = 7
      Top = 108
      Width = 76
      Height = 20
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
      OnClick = DRSpeedButton_MailRcvClick
    end
    object DRLabel15: TDRLabel
      Left = 8
      Top = 138
      Width = 24
      Height = 12
      Caption = #51228#47785
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object DRLabel27: TDRLabel
      Left = 8
      Top = 161
      Width = 24
      Height = 12
      Caption = #48376#47928
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object DRLabel13: TDRLabel
      Left = 9
      Top = 37
      Width = 72
      Height = 12
      Caption = #47700#51068#47926#51020#49436#49885
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel4: TDRLabel
      Left = 9
      Top = 14
      Width = 36
      Height = 12
      Caption = #44536#47353#47749
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DREdit_MailAddr: TDREdit
      Left = 87
      Top = 58
      Width = 313
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      MaxLength = 64
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      OnKeyPress = DRUserCodeCombo_MailGrpEditKeyPress
    end
    object DREdit_CCMailAddr: TDREdit
      Left = 87
      Top = 83
      Width = 313
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      MaxLength = 64
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
      OnKeyPress = DRUserCodeCombo_MailGrpEditKeyPress
    end
    object DREdit_CCBlindMailAddr: TDREdit
      Left = 87
      Top = 108
      Width = 313
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      MaxLength = 64
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
      OnKeyPress = DRUserCodeCombo_MailGrpEditKeyPress
    end
    object DREdit_Title: TDREdit
      Left = 87
      Top = 133
      Width = 312
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      MaxLength = 255
      ParentFont = False
      TabOrder = 5
      OnKeyPress = DRUserCodeCombo_MailGrpEditKeyPress
    end
    object DRMemo_Body: TDRMemo
      Left = 87
      Top = 159
      Width = 314
      Height = 97
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 6
    end
    object DRUserCodeCombo_MailForm: TDRUserCodeCombo
      Left = 88
      Top = 33
      Width = 252
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
      TabOrder = 1
      TabStop = True
      OnCodeChange = DRUserCodeCombo_MailFormCodeChange
      OnEditKeyPress = DRUserCodeCombo_MailGrpEditKeyPress
    end
    object DRUserCodeCombo_MailGrp: TDRUserCodeCombo
      Left = 88
      Top = 8
      Width = 186
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
      OnCodeChange = DRUserCodeCombo_MailGrpCodeChange
      OnEditKeyPress = DRUserCodeCombo_MailGrpEditKeyPress
    end
    object DRChkBox_InsertUpdate: TDRCheckBox
      Left = 96
      Top = 176
      Width = 257
      Height = 17
      Caption = #51077#47141#49688#51221#49324#54637#52404#53356
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      Visible = False
    end
  end
  object DRPanel2: TDRPanel [3]
    Left = 0
    Top = 27
    Width = 405
    Height = 30
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object DRRadioGrp_RptType: TDRRadioGroup
      Left = 3
      Top = -3
      Width = 400
      Height = 32
      Columns = 4
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        #49440#47932#47588#47588
        #50696#53441#54788#54889
        #51077#52636#44552#53685#51648
        #51452#49885#47588#47588)
      ParentFont = False
      TabOrder = 0
      OnClick = DRRadioGrp_RptTypeClick
    end
  end
  object DRPanel5: TDRPanel [4]
    Left = 0
    Top = 347
    Width = 405
    Height = 154
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    DesignSize = (
      405
      154)
    object DRSpeedBtn_MailRcv: TDRSpeedButton
      Left = 180
      Top = 34
      Width = 45
      Height = 90
      Anchors = [akTop]
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
    object DRListView_MailList: TDRListView
      Left = 1
      Top = 1
      Width = 180
      Height = 152
      Align = alLeft
      BiDiMode = bdLeftToRight
      Color = clWhite
      Columns = <
        item
          Caption = #47700#51068#49436#49885
          Width = 176
        end>
      DragCursor = crMultiDrag
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      FullDrag = True
      IconOptions.Arrangement = iaLeft
      Items.Data = {
        300000000100000000000000FFFFFFFFFFFFFFFF01000000000000000AB8DEC0
        CFBCADBDC4B8ED06453130303031FFFF}
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      ParentBiDiMode = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      ViewStyle = vsReport
      OnDblClick = DRListView_MailListDblClick
      OnDragDrop = DRListView_MailListDragDrop
      OnDragOver = DRListView_MailListDragOver
      OnKeyPress = DRListView_MailListKeyPress
      OnMouseDown = DRListView_MailListMouseDown
    end
    object DRListView_MailMergeList: TDRListView
      Left = 224
      Top = 1
      Width = 180
      Height = 152
      Align = alRight
      BiDiMode = bdLeftToRight
      Columns = <
        item
          AutoSize = True
          Caption = #47700#51068#49436#49885
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
      TabOrder = 1
      ViewStyle = vsReport
      OnDblClick = DRListView_MailMergeListDblClick
      OnDragDrop = DRListView_MailMergeListDragDrop
      OnDragOver = DRListView_MailMergeListDragOver
      OnKeyDown = DRListView_MailMergeListKeyDown
      OnKeyPress = DRListView_MailListKeyPress
      OnMouseDown = DRListView_MailMergeListMouseDown
    end
  end
  object DRPanel6: TDRPanel [5]
    Left = 0
    Top = 327
    Width = 405
    Height = 20
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    object DRPanel7: TDRPanel
      Left = 1
      Top = 1
      Width = 179
      Height = 18
      Align = alLeft
      Caption = #47700#51068#49436#49885' '#47785#47197
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object DRPanel8: TDRPanel
      Left = 225
      Top = 1
      Width = 179
      Height = 18
      Align = alRight
      Caption = #47926#51012' '#47700#51068#49436#49885' '#47785#47197
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  inherited DRSaveDialog_GridExport: TDRSaveDialog
    Left = 728
    Top = 448
  end
  object ADOQuery_Temp: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 304
    Top = 504
  end
end
