inherited DlgForm_AutoSplitAcc: TDlgForm_AutoSplitAcc
  Left = 778
  Top = 391
  Caption = #51204#52404' '#48516#54624
  ClientHeight = 398
  ClientWidth = 590
  PixelsPerInch = 96
  TextHeight = 13
  inherited MessageBar: TDRMessageBar
    Top = 373
    Width = 590
  end
  inherited DRPanel_Btn: TDRPanel
    Width = 590
    inherited DRBitBtn1: TDRBitBtn
      Left = 523
    end
    inherited DRBitBtn2: TDRBitBtn
      Left = 457
      Caption = #51068#44292#48516#54624
      OnClick = DRBitBtn2Click
    end
    inherited DRBitBtn3: TDRBitBtn
      Left = 392
      Visible = False
    end
    inherited DRBitBtn4: TDRBitBtn
      Left = 327
      Visible = False
    end
  end
  object DRPanel1: TDRPanel [2]
    Left = 0
    Top = 27
    Width = 319
    Height = 346
    Align = alLeft
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object DRUserDblCodeCombo_HwAcc: TDRUserDblCodeCombo
      Left = 143
      Top = 488
      Width = 123
      Height = 20
      DefaultView = dvNameFirst
      EditWidth = 105
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
      Visible = False
      OnCodeChange = DRUserDblCodeCombo_HwAccCodeChange
      OnEditKeyPress = DRUserDblCodeCombo_HwAccEditKeyPress
    end
    object DRStringGrid_Main: TDRStringGrid
      Left = 1
      Top = 1
      Width = 317
      Height = 344
      Align = alClient
      Color = clWhite
      ColCount = 4
      DefaultRowHeight = 18
      FixedCols = 0
      RowCount = 10
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
      ParentFont = False
      TabOrder = 1
      OnClick = DRStringGrid_MainClick
      OnDrawCell = DRStringGrid_MainDrawCell
      OnSelectCell = DRStringGrid_MainSelectCell
      AllowFixedRowClick = False
      TopRow = 1
      LeftCol = 0
      Editable = False
      SelectedCellColor = 16047570
      SelectedFontColor = clBlack
      ColWidths = (
        60
        79
        58
        94)
      AlignCol = {000002010002020002030002}
      FixedAlignCol = {000002010002}
      FixedAlignRow = {000002}
      Cells = (
        0
        0
        #45824#54364' ID'
        0
        1
        '0'
        1
        0
        #45824#54364#44228#51340
        1
        1
        '1'
        2
        0
        #54616#50948' ID'
        2
        1
        '2'
        3
        0
        #54616#50948#44228#51340
        3
        1
        '3')
    end
  end
  object pnl1: TPanel [3]
    Left = 319
    Top = 27
    Width = 271
    Height = 346
    Align = alClient
    Caption = 'pnl1'
    TabOrder = 3
    object DRStringGrid_HwAcc: TDRStringGrid
      Left = 1
      Top = 1
      Width = 269
      Height = 344
      Align = alClient
      Color = clWhite
      ColCount = 3
      DefaultRowHeight = 18
      FixedCols = 0
      RowCount = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
      ParentFont = False
      TabOrder = 0
      OnDblClick = DRStringGrid_HwAccDblClick
      OnDrawCell = DRStringGrid_MainDrawCell
      OnSelectCell = DRStringGrid_HwAccSelectCell
      AllowFixedRowClick = False
      TopRow = 1
      LeftCol = 0
      Editable = False
      SelectedCellColor = 16047570
      SelectedFontColor = clBlack
      ColWidths = (
        67
        101
        77)
      AlignCol = {000002010002020002}
      FixedAlignCol = {000002010002}
      FixedAlignRow = {000002}
      Cells = (
        0
        0
        #54616#50948' ID'
        0
        1
        '0'
        1
        0
        #54616#50948#44228#51340
        1
        1
        '1'
        2
        0
        #49688#49688#47308#50984
        2
        1
        '2')
    end
  end
  inherited DRSaveDialog_GridExport: TDRSaveDialog
    Left = 168
    Top = 264
  end
  object ADOQuery_Main: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    CursorType = ctStatic
    Parameters = <>
    Left = 173
    Top = 93
  end
  object ADOQuery_Temp: TADOQuery
    Connection = DataModule_SettleNet.ADOConnection_Main
    EnableBCD = False
    Parameters = <>
    Left = 37
    Top = 119
  end
  object ADOSP_SBP2701_AO_Bef: TADOCommand
    CommandText = 'SBP2701_AO_Bef;1'
    CommandType = cmdStoredProc
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@in_trade_date'
        Attributes = [paNullable]
        DataType = ftString
        Size = 8
        Value = Null
      end
      item
        Name = '@in_dept_code'
        Attributes = [paNullable]
        DataType = ftString
        Size = 2
        Value = Null
      end
      item
        Name = '@in_acc_no'
        Attributes = [paNullable]
        DataType = ftString
        Size = 20
        Value = Null
      end
      item
        Name = '@in_brk_sht_no'
        Attributes = [paNullable]
        DataType = ftString
        Size = 3
        Value = Null
      end
      item
        Name = '@in_issue_code'
        Attributes = [paNullable]
        DataType = ftString
        Size = -1
        Value = Null
      end
      item
        Name = '@in_tran_code'
        Attributes = [paNullable]
        DataType = ftString
        Size = 12
        Value = Null
      end
      item
        Name = '@in_trade_type'
        Attributes = [paNullable]
        DataType = ftString
        Size = 4
        Value = Null
      end
      item
        Name = '@out_rtc'
        Attributes = [paNullable]
        DataType = ftString
        Direction = pdInputOutput
        Size = 4
        Value = Null
      end
      item
        Name = '@out_kor_msg'
        Attributes = [paNullable]
        DataType = ftString
        Direction = pdInputOutput
        Size = 128
        Value = Null
      end
      item
        Name = '@out_eng_msg'
        Attributes = [paNullable]
        DataType = ftString
        Direction = pdInputOutput
        Size = 128
        Value = Null
      end>
    Left = 169
    Top = 174
  end
  object ADOSP_SBPTax_SettleSplit: TADOCommand
    CommandText = 'SBPTax_SettleSplit;1'
    CommandType = cmdStoredProc
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@in_trade_date'
        Attributes = [paNullable]
        DataType = ftString
        Size = 8
        Value = Null
      end
      item
        Name = '@in_dept_code'
        Attributes = [paNullable]
        DataType = ftString
        Size = 2
        Value = Null
      end
      item
        Name = '@in_acc_no'
        Attributes = [paNullable]
        DataType = ftString
        Size = 20
        Value = Null
      end
      item
        Name = '@in_brk_sht_no'
        Attributes = [paNullable]
        DataType = ftString
        Size = 3
        Value = Null
      end
      item
        Name = '@in_issue_code'
        Attributes = [paNullable]
        DataType = ftString
        Size = 12
        Value = Null
      end
      item
        Name = '@in_tran_code'
        Attributes = [paNullable]
        DataType = ftString
        Size = 4
        Value = Null
      end
      item
        Name = '@in_trade_type'
        Attributes = [paNullable]
        DataType = ftString
        Size = 1
        Value = Null
      end
      item
        Name = '@out_rtc'
        Attributes = [paNullable]
        DataType = ftString
        Direction = pdInputOutput
        Size = 4
        Value = Null
      end
      item
        Name = '@out_kor_msg'
        Attributes = [paNullable]
        DataType = ftString
        Direction = pdInputOutput
        Size = 128
        Value = Null
      end
      item
        Name = '@out_eng_msg'
        Attributes = [paNullable]
        DataType = ftString
        Direction = pdInputOutput
        Size = 128
        Value = Null
      end>
    Left = 278
    Top = 176
  end
  object ADOSP_SBP2701_AO: TADOCommand
    CommandText = 'SBP2701_AO;1'
    CommandType = cmdStoredProc
    Connection = DataModule_SettleNet.ADOConnection_Main
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@in_trade_date'
        Attributes = [paNullable]
        DataType = ftString
        Size = 8
        Value = Null
      end
      item
        Name = '@in_dept_code'
        Attributes = [paNullable]
        DataType = ftString
        Size = 2
        Value = Null
      end
      item
        Name = '@in_acc_no'
        Attributes = [paNullable]
        DataType = ftString
        Size = 20
        Value = Null
      end
      item
        Name = '@in_brk_sht_no'
        Attributes = [paNullable]
        DataType = ftString
        Size = 3
        Value = Null
      end
      item
        Name = '@in_issue_code'
        Attributes = [paNullable]
        DataType = ftString
        Size = 12
        Value = Null
      end
      item
        Name = '@in_tran_code'
        Attributes = [paNullable]
        DataType = ftString
        Size = 4
        Value = Null
      end
      item
        Name = '@in_trade_type'
        Attributes = [paNullable]
        DataType = ftString
        Size = 1
        Value = Null
      end
      item
        Name = '@in_dpsplit_mtd'
        Attributes = [paNullable]
        DataType = ftString
        Size = 1
        Value = Null
      end
      item
        Name = '@in_split_type'
        Attributes = [paNullable]
        DataType = ftString
        Size = 1
        Value = Null
      end
      item
        Name = '@in_opr_id'
        Attributes = [paNullable]
        DataType = ftString
        Direction = pdInputOutput
        Size = 20
        Value = Null
      end
      item
        Name = '@in_imp_cnt'
        Attributes = [paNullable]
        DataType = ftString
        Direction = pdInputOutput
        Size = 10
        Value = Null
      end
      item
        Name = '@out_rtc'
        Attributes = [paNullable]
        DataType = ftString
        Direction = pdInputOutput
        Size = 4
        Value = Null
      end
      item
        Name = '@out_kor_msg'
        Attributes = [paNullable]
        DataType = ftString
        Direction = pdInputOutput
        Size = 128
        Value = Null
      end
      item
        Name = '@out_eng_msg'
        Attributes = [paNullable]
        DataType = ftString
        Direction = pdInputOutput
        Size = 128
        Value = Null
      end>
    Left = 40
    Top = 178
  end
end
