inherited DlgForm_RegGroup: TDlgForm_RegGroup
  Left = 355
  Top = 207
  Caption = 'Group '#46321#47197
  ClientHeight = 504
  ClientWidth = 734
  OldCreateOrder = True
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  inherited MessageBar: TDRMessageBar
    Top = 479
    Width = 734
  end
  inherited DRPanel_Btn: TDRPanel
    Width = 734
    inherited DRBitBtn1: TDRBitBtn
      Tag = 1
      Left = 667
      TabOrder = 4
    end
    inherited DRBitBtn2: TDRBitBtn
      Tag = 1
      Left = 602
      Caption = #49325#51228
      OnClick = DRBitBtn2Click
    end
    inherited DRBitBtn3: TDRBitBtn
      Tag = 2
      Left = 536
      Caption = #49688#51221
      TabOrder = 3
      OnClick = DRBitBtn3Click
    end
    inherited DRBitBtn4: TDRBitBtn
      Tag = 2
      Left = 471
      Caption = #51077#47141
      TabOrder = 1
      OnClick = DRBitBtn4Click
    end
    object DRBitBtn6: TDRBitBtn
      Tag = 1
      Left = 406
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
      TabOrder = 0
      OnClick = DRBitBtn6Click
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
  end
  object DRPanel1: TDRPanel [2]
    Left = 0
    Top = 27
    Width = 734
    Height = 452
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object DRPanel3: TDRPanel
      Left = 170
      Top = 73
      Width = 564
      Height = 376
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      DesignSize = (
        564
        376)
      object DRSpeedBtn_Insert: TDRSpeedButton
        Left = 265
        Top = 116
        Width = 35
        Height = 69
        Anchors = [akTop]
        Caption = #52628#44032
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
        Layout = blGlyphBottom
        NumGlyphs = 2
        ParentFont = False
        OnClick = DRSpeedBtn_InsertClick
      end
      object DRSpeedBtn_Delete: TDRSpeedButton
        Left = 265
        Top = 200
        Width = 35
        Height = 69
        Anchors = [akTop]
        Caption = #49325#51228
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
          3333333333333FF3333333333333003333333333333F77F33333333333009033
          333333333F7737F333333333009990333333333F773337FFFFFF330099999000
          00003F773333377777770099999999999990773FF33333FFFFF7330099999000
          000033773FF33777777733330099903333333333773FF7F33333333333009033
          33333333337737F3333333333333003333333333333377333333333333333333
          3333333333333333333333333333333333333333333333333333333333333333
          3333333333333333333333333333333333333333333333333333}
        Layout = blGlyphBottom
        NumGlyphs = 2
        ParentFont = False
        OnClick = DRSpeedBtn_DeleteClick
      end
      object DRPanel5: TDRPanel
        Left = 307
        Top = 4
        Width = 253
        Height = 369
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object DRLabel2: TDRLabel
          Left = 10
          Top = 8
          Width = 72
          Height = 12
          Caption = #46321#47197#44228#51340'LIST'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentFont = False
        end
        object DRLabel20: TDRLabel
          Left = 29
          Top = 33
          Width = 84
          Height = 12
          Caption = #51228#50808#44228#51340'('#51204#52404')'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNone
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object DRCheckBox_ExcepAll: TDRCheckBox
          Left = 10
          Top = 30
          Width = 15
          Height = 17
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = DRCheckBox_ExcepAllClick
        end
        object DRListView_SelectAcc: TDRListView
          Left = 2
          Top = 53
          Width = 248
          Height = 310
          Checkboxes = True
          Columns = <
            item
              AutoSize = True
              Caption = #44228#51340#48264#54840
            end
            item
              Caption = #44228#51340#47749
              Width = 150
            end>
          DragCursor = crMultiDrag
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          HideSelection = False
          MultiSelect = True
          RowSelect = True
          ParentFont = False
          TabOrder = 1
          ViewStyle = vsReport
          OnColumnClick = DRListView_SelectAccColumnClick
          OnDblClick = DRListView_SelectAccDblClick
          OnEndDrag = DRListView_SelectAccEndDrag
          OnDragDrop = DRListView_SelectAccDragDrop
          OnDragOver = DRListView_SelectAccDragOver
          OnKeyDown = DRListView_SelectAccKeyDown
          OnKeyPress = DRListView_SelectAccKeyPress
          OnMouseDown = DRListView_SelectAccMouseDown
        end
      end
      object DRPanel4: TDRPanel
        Left = 2
        Top = 4
        Width = 257
        Height = 369
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object DRLabel1: TDRLabel
          Left = 7
          Top = 8
          Width = 72
          Height = 12
          Caption = #51204#52404#44228#51340'LIST'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentFont = False
        end
        object DRLabel6: TDRLabel
          Left = 7
          Top = 33
          Width = 48
          Height = 12
          Caption = #44228#51340#48264#54840
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentFont = False
        end
        object DRListView_AllAcc: TDRListView
          Left = 3
          Top = 53
          Width = 251
          Height = 310
          Color = clInactiveBorder
          Columns = <
            item
              Caption = #44228#51340#48264#54840
              Width = 90
            end
            item
              Caption = #44228#51340#47749
              Width = 120
            end
            item
              Alignment = taCenter
              Caption = #53804#51088#51088
              Width = 60
            end>
          DragCursor = crMultiDrag
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          HideSelection = False
          MultiSelect = True
          OwnerData = True
          RowSelect = True
          ParentFont = False
          TabOrder = 0
          ViewStyle = vsReport
          OnColumnClick = DRListView_AllAccColumnClick
          OnData = DRListView_AllAccData
          OnDblClick = DRListView_AllAccDblClick
          OnEndDrag = DRListView_AllAccEndDrag
          OnDragDrop = DRListView_AllAccDragDrop
          OnDragOver = DRListView_AllAccDragOver
          OnKeyPress = DRListView_AllAccKeyPress
          OnMouseDown = DRListView_AllAccMouseDown
        end
        object DRUserDblCodeCombo_GrpAcc: TDRUserDblCodeCombo
          Left = 70
          Top = 28
          Width = 150
          Height = 20
          EditWidth = 130
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ImeMode = imSHanguel
          ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
          InsertAllItem = False
          NameVisible = False
          ReadOnly = False
          TabOrder = 1
          TabStop = True
          OnEditKeyPress = DRUserDblCodeCombo_GrpAccEditKeyPress
        end
      end
    end
    object DRPanel7: TDRPanel
      Left = 168
      Top = -7
      Width = 566
      Height = 80
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object DRLabel4: TDRLabel
        Left = 27
        Top = 26
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
      object DRLabel8: TDRLabel
        Left = 26
        Top = 51
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
      object DREdit_GrpName: TDREdit
        Left = 116
        Top = 20
        Width = 147
        Height = 20
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        ParentFont = False
        TabOrder = 0
        OnKeyPress = DREdit_GrpNameKeyPress
      end
      object DREdit_MgrOprId: TDREdit
        Left = 117
        Top = 46
        Width = 59
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
        TabOrder = 1
      end
      object DREdit_MgrOprTime: TDREdit
        Left = 177
        Top = 46
        Width = 147
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
        TabOrder = 2
      end
    end
    object DRPanel2: TDRPanel
      Left = 1
      Top = 1
      Width = 169
      Height = 450
      Align = alLeft
      Caption = 'DRPanel2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object DRPanel6: TDRPanel
        Left = 1
        Top = 1
        Width = 167
        Height = 27
        Align = alTop
        Alignment = taLeftJustify
        Caption = '  >> '#44536#47353' '#47785#47197
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object DRSpeedButton_FindAcc: TDRSpeedButton
          Left = 142
          Top = 4
          Width = 19
          Height = 19
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333303333
            333333333337FF3333333333330003333333333333777F333333333333080333
            3333333F33777FF33F3333B33B000B33B3333373F777773F7333333BBB0B0BBB
            33333337737F7F77F333333BBB0F0BBB33333337337373F73F3333BBB0F7F0BB
            B333337F3737F73F7F3333BB0FB7BF0BB3333F737F37F37F73FFBBBB0BF7FB0B
            BBB3773F7F37337F377333BB0FBFBF0BB333337F73F333737F3333BBB0FBF0BB
            B3333373F73FF7337333333BBB000BBB33333337FF777337F333333BBBBBBBBB
            3333333773FF3F773F3333B33BBBBB33B33333733773773373333333333B3333
            333333333337F33333333333333B333333333333333733333333}
          NumGlyphs = 2
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = DRSpeedButton_FindAccClick
        end
        object DRUserDblCodeCombo_GrpFAcc: TDRUserDblCodeCombo
          Left = 5
          Top = 3
          Width = 136
          Height = 20
          EditWidth = 115
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ImeMode = imSHanguel
          ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
          InsertAllItem = False
          NameVisible = False
          ReadOnly = False
          TabOrder = 0
          TabStop = True
          OnCodeChange = DRUserDblCodeCombo_GrpFAccCodeChange
          OnEditKeyPress = DRUserDblCodeCombo_GrpFAccEditKeyPress
        end
      end
      object DRTreeView_MgrAcc: TDRTreeView
        Left = 166
        Top = 28
        Width = 165
        Height = 421
        Align = alLeft
        Color = 16380658
        HideSelection = False
        Indent = 19
        ReadOnly = True
        TabOrder = 1
        OnChange = DRTreeView_MgrAccChange
      end
      object DRTreeView_MgrGrp: TDRTreeView
        Left = 1
        Top = 28
        Width = 165
        Height = 421
        Align = alLeft
        Color = 16380658
        HideSelection = False
        Indent = 19
        ReadOnly = True
        TabOrder = 2
        OnChange = DRTreeView_MgrGrpChange
      end
    end
  end
  object ADOQuery_Temp: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    Left = 112
    Top = 403
  end
  object ADOQuery_SUAGPAC: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    SQL.Strings = (
      '')
    Left = 112
    Top = 307
  end
end
