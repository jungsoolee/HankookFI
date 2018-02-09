inherited Form_SCF_RCV: TForm_SCF_RCV
  Left = 106
  Top = 182
  Caption = 'Form_SCF_RCV'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited DRPanel_Top: TDRPanel
    inherited DRBitBtn2: TDRBitBtn
      Tag = 1
      Caption = #44081#49888
      OnClick = DRBitBtn2Click
    end
  end
  object DRFramePanel_Query: TDRFramePanel
    Left = 0
    Top = 27
    Width = 822
    Height = 41
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 3
    object DRLabel_Party: TDRLabel
      Left = 30
      Top = 15
      Width = 36
      Height = 12
      Caption = #49569#49888#52376
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRUserCodeCombo_Party: TDRUserCodeCombo
      Left = 82
      Top = 11
      Width = 150
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeMode = imSHanguel
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      InsertAllItem = False
      ReadOnly = False
      TabOrder = 0
      TabStop = True
      OnCodeChange = DRUserCodeCombo_PartyCodeChange
    end
  end
  object DRPanel_DataTitle: TDRPanel
    Left = 0
    Top = 68
    Width = 822
    Height = 23
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    object DRLabel_Data: TDRLabel
      Left = 15
      Top = 6
      Width = 42
      Height = 12
      Caption = '* DATA'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DRPanel_FaxRadioBtnGroup: TDRPanel
      Left = 518
      Top = 5
      Width = 179
      Height = 14
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object DRLabel_B1: TDRLabel
        Left = 6
        Top = 1
        Width = 7
        Height = 12
        Caption = '['
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = [fsBold]
        ParentFont = False
      end
      object DRLabel_B2: TDRLabel
        Left = 169
        Top = 1
        Width = 7
        Height = 12
        Caption = ']'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = [fsBold]
        ParentFont = False
      end
      object DRRadioBtn_DataProcess: TDRRadioButton
        Left = 13
        Top = 1
        Width = 59
        Height = 12
        Caption = #51652#54665#51473
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = DRRadioBtn_DataProcessClick
      end
      object DRRadioBtn_DataError: TDRRadioButton
        Left = 74
        Top = 1
        Width = 43
        Height = 12
        Caption = #50724#47448
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = DRRadioBtn_DataProcessClick
      end
      object DRRadioBtn_DataTotal: TDRRadioButton
        Left = 124
        Top = 1
        Width = 45
        Height = 12
        Caption = #51204#52404
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        TabStop = True
        OnClick = DRRadioBtn_DataProcessClick
      end
    end
    object DRCheckBox_DataTotFreq: TDRCheckBox
      Left = 721
      Top = 5
      Width = 80
      Height = 15
      Caption = #51204#54924#52264#48372#44592
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = DRCheckBox_DataTotFreqClick
    end
  end
  object DRStrGrid_RcvData: TDRStringGrid
    Left = 0
    Top = 91
    Width = 822
    Height = 479
    Align = alClient
    Color = clWhite
    ColCount = 8
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
    TabOrder = 5
    OnDblClick = DRStrGrid_RcvDataDblClick
    OnMouseUp = DRStrGrid_RcvDataMouseUp
    AllowFixedRowClick = False
    TopRow = 1
    LeftCol = 0
    SelectedCellColor = 16047570
    SelectedFontColor = clBlack
    ColWidths = (
      165
      54
      103
      96
      91
      96
      97
      92)
    AlignCol = {000001010002020000030000040000050002060002070002}
    FixedAlignRow = {000002}
    Cells = (
      0
      0
      #49569#49888#52376
      0
      1
      '0'
      1
      0
      #54924#52264
      1
      1
      '1'
      2
      0
      #52509#51204#49569#44148#49688
      2
      1
      '2'
      3
      0
      #52509#49688#49888#44148#49688
      3
      1
      '3'
      4
      0
      'Error'#49688
      4
      1
      '4'
      5
      0
      #49688#49888#49884#44036
      5
      1
      '5'
      6
      0
      #51204#49569#49884#44036
      6
      1
      '6'
      7
      0
      #49345#53468
      7
      1
      '7')
  end
  object ADOQuery_Temp: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    SQL.Strings = (
      
        'Select P.PARTY_NAME_KOR, T3.FREQ_NO, A.ACC_NAME_KOR, Q1.*  From ' +
        'SEQUESND_TBL Q1, SEACBIF_TBL A, SCPARTY_TBL P,'
      '    (Select TO_PARTY_ID, MAX_SENT_CNT =  Max(SENT_CNT)'
      '     From SEQUESND_TBL'
      '     Where SND_DATE = '#39'20000415'#39
      '       and TRAN_CODE = '#39'EI0I0'#39
      '       and FROM_PARTY_ID = '#39'KRB00101'#39
      '     Group By TO_PARTY_ID) as T1,'
      ''
      '    (Select TO_PARTY_ID, FREQ_NO = Count(SENT_CNT)'
      '     From'
      '        (Select TO_PARTY_ID, SENT_CNT'
      '         From SEQUESND_TBL'
      '         Where SND_DATE = '#39'20000415'#39
      '             and  TRAN_CODE = '#39'EI0I0'#39
      '             and FROM_PARTY_ID = '#39'KRB00101'#39
      '         Group By TO_PARTY_ID, SENT_CNT ) as T2'
      '     Group By TO_PARTY_ID) as T3'
      ''
      'Where  Q1.TO_PARTY_ID = T1.TO_PARTY_ID'
      '   and Q1.SENT_CNT = T1.MAX_SENT_CNT'
      '   and Q1.TO_PARTY_ID = T3.TO_PARTY_ID'
      '   and Substring(Q1.TO_PARTY_ID, 1, 2) = p.NAT'
      '   and Substring(Q1.TO_PARTY_ID, 3, 6) = P.PARTY_ID'
      '   and Substring(Q1.COMMON_DATA, 9, 20) = A.ACC_NO'
      '   and Q1.SND_DATE = '#39'20000415'#39
      '   and Q1.TRAN_CODE = '#39'EI0I0'#39
      '   and Q1.FROM_PARTY_ID = '#39'KRB00101'#39
      'Order By  P.PARTY_NAME_KOR')
    Left = 88
    Top = 155
  end
  object ADOQuery_Rcv: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <>
    SQL.Strings = (
      
        'Select P.PARTY_NAME_KOR, T3.FREQ_NO, A.ACC_NAME_KOR, Q1.*  From ' +
        'SEQUESND_TBL Q1, SEACBIF_TBL A, SCPARTY_TBL P,'
      '    (Select TO_PARTY_ID, MAX_SENT_CNT =  Max(SENT_CNT)'
      '     From SEQUESND_TBL'
      '     Where SND_DATE = '#39'20000415'#39
      '       and TRAN_CODE = '#39'EI0I0'#39
      '       and FROM_PARTY_ID = '#39'KRB00101'#39
      '     Group By TO_PARTY_ID) as T1,'
      ''
      '    (Select TO_PARTY_ID, FREQ_NO = Count(SENT_CNT)'
      '     From'
      '        (Select TO_PARTY_ID, SENT_CNT'
      '         From SEQUESND_TBL'
      '         Where SND_DATE = '#39'20000415'#39
      '             and  TRAN_CODE = '#39'EI0I0'#39
      '             and FROM_PARTY_ID = '#39'KRB00101'#39
      '         Group By TO_PARTY_ID, SENT_CNT ) as T2'
      '     Group By TO_PARTY_ID) as T3'
      ''
      'Where  Q1.TO_PARTY_ID = T1.TO_PARTY_ID'
      '   and Q1.SENT_CNT = T1.MAX_SENT_CNT'
      '   and Q1.TO_PARTY_ID = T3.TO_PARTY_ID'
      '   and Substring(Q1.TO_PARTY_ID, 1, 2) = p.NAT'
      '   and Substring(Q1.TO_PARTY_ID, 3, 6) = P.PARTY_ID'
      '   and Substring(Q1.COMMON_DATA, 9, 20) = A.ACC_NO'
      '   and Q1.SND_DATE = '#39'20000415'#39
      '   and Q1.TRAN_CODE = '#39'EI0I0'#39
      '   and Q1.FROM_PARTY_ID = '#39'KRB00101'#39
      'Order By  P.PARTY_NAME_KOR')
    Left = 88
    Top = 227
  end
  object DRPopupMenu_Data: TDRPopupMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    AutoPopup = False
    Left = 88
    Top = 304
    object Popup_Detail: TMenuItem
      Caption = #49345#49464' '#45236#50669' '#48372#44592
    end
  end
end
