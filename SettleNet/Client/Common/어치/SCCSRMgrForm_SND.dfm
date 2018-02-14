inherited Form_SCF_SND: TForm_SCF_SND
  Left = 307
  Top = 221
  Caption = 'Form_SCF_SND'
  ClientWidth = 829
  KeyPreview = True
  OldCreateOrder = True
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object DRPageControl_Main: TDRPageControl [0]
    Tag = 1
    Left = 0
    Top = 99
    Width = 829
    Height = 469
    ActivePage = DRTabSheet_FaxTlx
    Align = alClient
    FlatSeperators = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    HotTrack = False
    TabActiveColor = clWhite
    TabInactiveColor = clBtnFace
    TabInactiveFont.Charset = DEFAULT_CHARSET
    TabInactiveFont.Color = clBlack
    TabInactiveFont.Height = -12
    TabInactiveFont.Name = #44404#47548#52404
    TabInactiveFont.Style = []
    ParentFont = False
    TabOrder = 5
    OnChange = DRPageControl_MainChange
    object DRTabSheet_Data: TDRTabSheet
      Tag = 1
      Caption = 'DATA'
      GripAlign = gaLeft
      ImageIndex = -1
      StaticPageIndex = -1
      TabVisible = True
      object DRSplitter_Data: TDRSplitter
        Left = 0
        Top = 236
        Width = 821
        Height = 3
        Cursor = crVSplit
        Align = alTop
      end
      object DRPanel_SndData: TDRPanel
        Left = 0
        Top = 0
        Width = 821
        Height = 236
        Align = alTop
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object DRPanel_SndDataTitle: TDRPanel
          Left = 0
          Top = 0
          Width = 821
          Height = 24
          Align = alTop
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnDblClick = DRPanel_SndDataTitleDblClick
          object DRLabel_SndData: TDRLabel
            Left = 15
            Top = 7
            Width = 115
            Height = 12
            Caption = '>> DATA '#51088#47308' '#51204#49569
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clPurple
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = [fsBold]
            ParentFont = False
            OnClick = DRPanel_SndDataTitleDblClick
          end
        end
        object DRStrGrid_SndData: TDRStringGrid
          Left = 0
          Top = 24
          Width = 821
          Height = 212
          Align = alClient
          Color = clWhite
          ColCount = 10
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 15
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          AllowFixedRowClick = True
          TopRow = 1
          LeftCol = 0
          SelectedCellColor = 16047570
          SelectedFontColor = clBlack
          ColWidths = (
            13
            112
            123
            92
            70
            93
            69
            69
            93
            50)
          AlignCol = {000002010001020001030000040000050000060000070000080000090002}
          FixedAlignRow = {000002}
          Cells = (
            0
            0
            '>'
            0
            2
            '0'
            1
            0
            #49688#49888#52376
            1
            1
            #51068#51060#49340#49324#50724#50977#52832#54036#44396
            1
            2
            '1'
            2
            0
            #44228#51340#47749
            2
            1
            #51068#51060#49340#49324#50724#50977#52832#54036#44396#49901
            2
            2
            '2'
            3
            0
            #47588#49688#50557#51221#44552#50529
            3
            1
            'XXX,XXX,XXX,XXX'
            3
            2
            '3'
            4
            0
            #47588#49688#49688#49688#47308
            4
            1
            'XXX,XXX,XXX,XXX'
            4
            2
            '4'
            5
            0
            #47588#46020#50557#51221#44552#50529
            5
            1
            'XXX,XXX,XXX,XXX'
            5
            2
            '5'
            6
            0
            #47588#46020#49688#49688#47308
            6
            1
            'XXX,XXX,XXX,XXX'
            6
            2
            '6'
            7
            0
            #51228#49464#44552
            7
            1
            'XXX,XXX,XXX,XXX'
            7
            2
            '7'
            8
            0
            #44208#51228#44552#50529
            8
            1
            'XXX,XXX,XXX,XXX'
            8
            2
            '8'
            9
            0
            #49436#48260#51204#49569
            9
            2
            '9')
        end
      end
      object DRPanel_SntData: TDRPanel
        Left = 0
        Top = 239
        Width = 821
        Height = 203
        Align = alClient
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object DRPanel_SntDataTitle: TDRPanel
          Left = 0
          Top = 0
          Width = 814
          Height = 24
          Align = alTop
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnDblClick = DRPanel_SntDataTitleDblClick
          object DRLabel_SntData: TDRLabel
            Left = 15
            Top = 7
            Width = 115
            Height = 12
            Caption = '>> DATA '#49569#49888' '#54869#51064
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clPurple
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = [fsBold]
            ParentFont = False
            OnClick = DRPanel_SntDataTitleDblClick
          end
          object DRPanel_SntDataSelect: TDRPanel
            Left = 527
            Top = 6
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
            object DRRadioBtn_DataSend: TDRRadioButton
              Left = 6
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
            end
            object DRRadioBtn_DataError: TDRRadioButton
              Left = 67
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
            end
            object DRRadioBtn_DataAll: TDRRadioButton
              Left = 117
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
            end
          end
          object DRCheckBox_DataTotFreq: TDRCheckBox
            Left = 717
            Top = 6
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
          end
        end
        object DRStrGrid_SntData: TDRStringGrid
          Left = 0
          Top = 24
          Width = 814
          Height = 213
          Align = alClient
          Color = clWhite
          ColCount = 9
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
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          AllowFixedRowClick = False
          TopRow = 1
          LeftCol = 0
          SelectedCellColor = 16047570
          SelectedFontColor = clBlack
          ColWidths = (
            132
            56
            87
            88
            89
            85
            82
            89
            76)
          AlignCol = {000001010002020000030000040000050000060002070002080002}
          FixedAlignRow = {000002}
          Cells = (
            0
            0
            #49688#49888#52376
            0
            2
            '0'
            1
            0
            #54924#52264
            1
            2
            '1'
            2
            0
            #52509#51204#49569#44148#49688
            2
            1
            'XXXXX'
            2
            2
            '2'
            3
            0
            #54869#51064#44148#49688
            3
            1
            'XXXXX'
            3
            2
            '3'
            4
            0
            'ACK'#44148#49688
            4
            1
            'XXXXX'
            4
            2
            '4'
            5
            0
            'Error'#44148#49688
            5
            1
            'XXXXX'
            5
            2
            '5'
            6
            0
            #49884#51089#49884#44036
            6
            1
            'XX:XX:XX'
            6
            2
            '6'
            7
            0
            #50756#47308#49884#44036
            7
            1
            'XX:XX:XX'
            7
            2
            '7'
            8
            0
            'Process'
            8
            2
            '8')
        end
      end
    end
    object DRTabSheet_FaxTlx: TDRTabSheet
      Tag = 2
      Caption = 'FAX/TELEX'
      GripAlign = gaLeft
      ImageIndex = -1
      StaticPageIndex = -1
      TabVisible = True
      object DRSplitter_FaxTlx: TDRSplitter
        Left = 0
        Top = 236
        Width = 821
        Height = 3
        Cursor = crVSplit
        Align = alTop
        Beveled = True
      end
      object DRPanel_SndFaxTlx: TDRPanel
        Left = 0
        Top = 0
        Width = 821
        Height = 236
        Align = alTop
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object DRStrGrid_SndFaxTlx: TDRStringGrid
          Left = 0
          Top = 24
          Width = 821
          Height = 212
          Align = alClient
          Color = clWhite
          ColCount = 9
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          AllowFixedRowClick = True
          TopRow = 1
          LeftCol = 0
          SelectedCellColor = 16047570
          SelectedFontColor = clBlack
          ColWidths = (
            14
            127
            163
            135
            94
            135
            57
            28
            31)
          AlignCol = {000002010001020001030001040001050001060002070002080002}
          FixedAlignRow = {000002}
          Cells = (
            0
            0
            '>'
            0
            2
            '0'
            1
            0
            #44228#51340#48264#54840
            1
            1
            '123456789012345-0000'
            1
            2
            '1'
            2
            0
            #44228#51340#47749
            2
            1
            #51068#51060#49340#49324#50724#50977#52832#54036#44396#49901#51068#51060#49340#49324#50724
            2
            2
            '2'
            3
            0
            #49688#49888#52376
            3
            1
            #51068#51060#49340#49324#50724#50977#52832#54036#44396#49901#51068#51060#49340#49324#50724
            3
            2
            '3'
            4
            0
            #48264#54840
            4
            1
            '123456789012345'
            4
            2
            '4'
            5
            0
            'Report'#49436#49885
            5
            1
            #51068#48152#50577#49885'('#51333#47785#47749#49692')'
            5
            2
            '5'
            6
            0
            #49436#48260#51204#49569
            6
            2
            '6'
            7
            0
            'P.S'
            7
            2
            '7'
            8
            0
            'Edit'
            8
            2
            '8')
          FontCell = (
            0
            0
            -2147483640
            -12
            #44404#47548#52404
            0
            417522689)
        end
        object DRPanel_SndFaxTlxTitle: TDRPanel
          Left = 0
          Top = 0
          Width = 821
          Height = 24
          Align = alTop
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnDblClick = DRPanel_SndFaxTlxTitleDblClick
          object DRLabel_SndFaxTlx: TDRLabel
            Left = 15
            Top = 7
            Width = 136
            Height = 12
            Caption = '>> FAX/TLX '#51088#47308' '#51204#49569
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clPurple
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = [fsBold]
            ParentFont = False
            OnClick = DRPanel_SndFaxTlxTitleDblClick
          end
          object DRSpeedBtn_SndFaxTlxPrint: TDRSpeedButton
            Tag = 1
            Left = 771
            Top = 3
            Width = 23
            Height = 20
            Hint = #51064#49604
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              04000000000000010000130B0000130B00001000000000000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
              00033FFFFFFFFFFFFFFF0888888888888880777777777777777F088888888888
              8880777777777777777F0000000000000000FFFFFFFFFFFFFFFF0F8F8F8F8F8F
              8F80777777777777777F08F8F8F8F8F8F9F0777777777777777F0F8F8F8F8F8F
              8F807777777777777F7F0000000000000000777777777777777F3330FFFFFFFF
              03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
              03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
              33333337F3FF7F3733333330F08F0F0333333337F7737F7333333330FFFF0033
              33333337FFFF7733333333300000033333333337777773333333}
            NumGlyphs = 2
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
          end
          object DRSpeedBtn_SndFaxTlxSelect: TDRSpeedButton
            Tag = 1
            Left = 747
            Top = 3
            Width = 23
            Height = 20
            Hint = #44228#51340#48324' '#49440#53469
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              04000000000000010000120B0000120B00001000000000000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
              555555555555555555555555555555555555555555FF55555555555559055555
              55555555577FF5555555555599905555555555557777F5555555555599905555
              555555557777FF5555555559999905555555555777777F555555559999990555
              5555557777777FF5555557990599905555555777757777F55555790555599055
              55557775555777FF5555555555599905555555555557777F5555555555559905
              555555555555777FF5555555555559905555555555555777FF55555555555579
              05555555555555777FF5555555555557905555555555555777FF555555555555
              5990555555555555577755555555555555555555555555555555}
            NumGlyphs = 2
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            Visible = False
          end
        end
      end
      object DRPanel_SntFaxTlx: TDRPanel
        Left = 0
        Top = 239
        Width = 821
        Height = 203
        Align = alClient
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object DRPanel_SntFaxTlxTitle: TDRPanel
          Left = 0
          Top = 0
          Width = 821
          Height = 24
          Align = alTop
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnDblClick = DRPanel_SntFaxTlxTitleDblClick
          object DRLabel_SntFaxTlx: TDRLabel
            Left = 15
            Top = 7
            Width = 136
            Height = 12
            Caption = '>> FAX/TLX '#49569#49888' '#54869#51064
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clPurple
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = [fsBold]
            ParentFont = False
            OnClick = DRPanel_SntFaxTlxTitleDblClick
          end
          object DRSpeedBtn_SntFaxTlxPrint: TDRSpeedButton
            Tag = 1
            Left = 749
            Top = 3
            Width = 23
            Height = 20
            Hint = #51064#49604
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              04000000000000010000130B0000130B00001000000000000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
              00033FFFFFFFFFFFFFFF0888888888888880777777777777777F088888888888
              8880777777777777777F0000000000000000FFFFFFFFFFFFFFFF0F8F8F8F8F8F
              8F80777777777777777F08F8F8F8F8F8F9F0777777777777777F0F8F8F8F8F8F
              8F807777777777777F7F0000000000000000777777777777777F3330FFFFFFFF
              03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
              03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
              33333337F3FF7F3733333330F08F0F0333333337F7737F7333333330FFFF0033
              33333337FFFF7733333333300000033333333337777773333333}
            NumGlyphs = 2
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
          end
          object DRSpeedBtn_FaxTlxResend: TDRSpeedButton
            Tag = 2
            Left = 725
            Top = 3
            Width = 23
            Height = 20
            Hint = #51116#51204#49569
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              04000000000000010000130B0000130B00001000000000000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
              3333333333FFFFF3333333333999993333333333F77777FFF333333999999999
              3333333777333777FF33339993707399933333773337F3777FF3399933000339
              9933377333777F3377F3399333707333993337733337333337FF993333333333
              399377F33333F333377F993333303333399377F33337FF333373993333707333
              333377F333777F333333993333101333333377F333777F3FFFFF993333000399
              999377FF33777F77777F3993330003399993373FF3777F37777F399933000333
              99933773FF777F3F777F339993707399999333773F373F77777F333999999999
              3393333777333777337333333999993333333333377777333333}
            NumGlyphs = 2
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
          end
          object DRSpeedBtn_FaxTlxExport: TDRSpeedButton
            Tag = 1
            Left = 773
            Top = 3
            Width = 23
            Height = 20
            Hint = 'Export'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              04000000000000010000130B0000130B00001000000000000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333303
              333333333333337FF3333333333333903333333333333377FF33333333333399
              03333FFFFFFFFF777FF3000000999999903377777777777777FF0FFFF0999999
              99037F3337777777777F0FFFF099999999907F3FF777777777770F00F0999999
              99037F773777777777730FFFF099999990337F3FF777777777330F00FFFFF099
              03337F773333377773330FFFFFFFF09033337F3FF3FFF77733330F00F0000003
              33337F773777777333330FFFF0FF033333337F3FF7F3733333330F08F0F03333
              33337F7737F7333333330FFFF003333333337FFFF77333333333000000333333
              3333777777333333333333333333333333333333333333333333}
            NumGlyphs = 2
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
          end
          object DRSpeedBtn_SntFaxTlxSelect: TDRSpeedButton
            Tag = 1
            Left = 701
            Top = 3
            Width = 23
            Height = 20
            Hint = #44228#51340#48324' '#49440#53469
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              04000000000000010000120B0000120B00001000000000000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
              555555555555555555555555555555555555555555FF55555555555559055555
              55555555577FF5555555555599905555555555557777F5555555555599905555
              555555557777FF5555555559999905555555555777777F555555559999990555
              5555557777777FF5555557990599905555555777757777F55555790555599055
              55557775555777FF5555555555599905555555555557777F5555555555559905
              555555555555777FF5555555555559905555555555555777FF55555555555579
              05555555555555777FF5555555555557905555555555555777FF555555555555
              5990555555555555577755555555555555555555555555555555}
            NumGlyphs = 2
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            Visible = False
          end
          object DRPanel_SntFaxTlxSelect: TDRPanel
            Left = 429
            Top = 6
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
            object DRRadioBtn_FaxTlxSend: TDRRadioButton
              Left = 8
              Top = 1
              Width = 59
              Height = 12
              Caption = #51652#54665#51473
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = #44404#47548#52404
              Font.Style = []
              ParentFont = False
              TabOrder = 0
            end
            object DRRadioBtn_FaxTlxError: TDRRadioButton
              Left = 69
              Top = 1
              Width = 43
              Height = 12
              Caption = #50724#47448
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = #44404#47548#52404
              Font.Style = []
              ParentFont = False
              TabOrder = 1
            end
            object DRRadioBtn_FaxTlxAll: TDRRadioButton
              Left = 119
              Top = 1
              Width = 45
              Height = 12
              Caption = #51204#52404
              Checked = True
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = #44404#47548#52404
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              TabStop = True
            end
          end
          object DRCheckBox_FaxTlxTotFreq: TDRCheckBox
            Left = 613
            Top = 6
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
          end
        end
        object DRStrGrid_SntFaxTlx: TDRStringGrid
          Left = 0
          Top = 24
          Width = 821
          Height = 179
          Align = alClient
          Color = clWhite
          ColCount = 12
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 15
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          AllowFixedRowClick = True
          TopRow = 1
          LeftCol = 0
          SelectedCellColor = 16047570
          SelectedFontColor = clBlack
          ColWidths = (
            13
            124
            109
            107
            92
            32
            56
            57
            56
            48
            54
            33)
          AlignCol = {
            0000020100010200010300010400010500020600020700020800000900020A00
            020B0002}
          FixedAlignRow = {000002}
          Cells = (
            0
            0
            '>'
            0
            2
            '0'
            1
            0
            #44228#51340#48264#54840
            1
            2
            '1'
            2
            0
            #44228#51340#47749
            2
            1
            #51068#51060#49340#49324#50724#50977#52832#54036#44396#49901#51068#51060
            2
            2
            '2'
            3
            0
            #49688#49888#52376
            3
            1
            #51068#51060#49340#49324#50724#50977#52832#54036#44396#49901#51068#51060
            3
            2
            '3'
            4
            0
            #48264#54840
            4
            1
            '123456789012345'
            4
            2
            '4'
            5
            0
            #54924#52264
            5
            2
            '5'
            6
            0
            #49884#51089#49884#44036
            6
            1
            'XX:XX:XX'
            6
            2
            '6'
            7
            0
            #50756#47308#49884#44036
            7
            1
            'XX:XX:XX'
            7
            2
            '7'
            8
            0
            #51204#49569#49884#44036
            8
            1
            'XX.XX'
            8
            2
            '8'
            9
            0
            #51116#51204#49569'#'
            9
            2
            '9'
            10
            0
            'Process'
            10
            1
            'FINISH'
            10
            2
            '10'
            11
            0
            'Page'
            11
            1
            '1/4'
            11
            2
            '11')
          FontCell = (
            0
            0
            -2147483640
            -12
            #44404#47548#52404
            0
            417522689)
        end
      end
    end
    object DRTabSheet_EMail: TDRTabSheet
      Tag = 4
      Caption = 'E-MAIL'
      GripAlign = gaLeft
      ImageIndex = -1
      StaticPageIndex = -1
      TabVisible = True
      object DRPanel_SndMail: TDRPanel
        Left = 0
        Top = 0
        Width = 821
        Height = 442
        Align = alClient
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object DRSplitter_EMail: TDRSplitter
          Left = 0
          Top = 236
          Width = 821
          Height = 3
          Cursor = crVSplit
          Align = alTop
          Beveled = True
        end
        object DRPanel_SndEmail: TDRPanel
          Left = 0
          Top = 0
          Width = 821
          Height = 236
          Align = alTop
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object DRPanel_SndMailTitle: TDRPanel
            Left = 0
            Top = 0
            Width = 821
            Height = 24
            Align = alTop
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnDblClick = DRLabel_SndMailClick
            object DRLabel_SndMail: TDRLabel
              Left = 15
              Top = 7
              Width = 129
              Height = 12
              Caption = '>> E-MAIL '#51088#47308' '#51204#49569
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clPurple
              Font.Height = -12
              Font.Name = #44404#47548#52404
              Font.Style = [fsBold]
              ParentFont = False
              OnClick = DRLabel_SndMailClick
            end
            object DRSpeedBtn_SndMailDir: TDRSpeedButton
              Tag = 1
              Left = 745
              Top = 2
              Width = 23
              Height = 20
              Hint = 'Directory '#49440#53469
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = #44404#47548#52404
              Font.Style = []
              Glyph.Data = {
                76010000424D7601000000000000760000002800000020000000100000000100
                04000000000000010000120B0000120B00001000000000000000000000000000
                800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
                5555555555555555555555555555555555555555555555555555555555555555
                555555555555555555555555555555555555555FFFFFFFFFF555550000000000
                55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
                B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
                000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
                555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
                55555575FFF75555555555700007555555555557777555555555555555555555
                5555555555555555555555555555555555555555555555555555}
              NumGlyphs = 2
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
            end
            object DRLabel_SndMailDir: TDRLabel
              Left = 467
              Top = 6
              Width = 48
              Height = 12
              Caption = #49373#49457'Dir.'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = #44404#47548#52404
              Font.Style = []
              ParentFont = False
            end
            object DRSpeedBtn_Export: TDRSpeedButton
              Tag = 1
              Left = 769
              Top = 2
              Width = 23
              Height = 20
              Hint = 'Export'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = #44404#47548#52404
              Font.Style = []
              Glyph.Data = {
                76010000424D7601000000000000760000002800000020000000100000000100
                04000000000000010000130B0000130B00001000000000000000000000000000
                800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333303
                333333333333337FF3333333333333903333333333333377FF33333333333399
                03333FFFFFFFFF777FF3000000999999903377777777777777FF0FFFF0999999
                99037F3337777777777F0FFFF099999999907F3FF777777777770F00F0999999
                99037F773777777777730FFFF099999990337F3FF777777777330F00FFFFF099
                03337F773333377773330FFFFFFFF09033337F3FF3FFF77733330F00F0000003
                33337F773777777333330FFFF0FF033333337F3FF7F3733333330F08F0F03333
                33337F7737F7333333330FFFF003333333337FFFF77333333333000000333333
                3333777777333333333333333333333333333333333333333333}
              NumGlyphs = 2
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
            end
            object DREdit_SndMailDir: TDREdit
              Left = 517
              Top = 2
              Width = 227
              Height = 20
              Color = clBtnFace
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = #44404#47548#52404
              Font.Style = []
              ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
              ParentFont = False
              ReadOnly = True
              TabOrder = 0
            end
          end
          object DRStrGrid_SndMail: TDRStringGrid
            Left = 0
            Top = 24
            Width = 821
            Height = 212
            Align = alClient
            Color = clWhite
            ColCount = 7
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
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            AllowFixedRowClick = True
            TopRow = 1
            LeftCol = 0
            SelectedCellColor = 16047570
            SelectedFontColor = clBlack
            ColWidths = (
              14
              147
              155
              238
              110
              73
              48)
            AlignCol = {000002010001020001030001040001050002}
            FixedAlignRow = {000002}
            Cells = (
              0
              0
              '>'
              0
              2
              '0'
              1
              0
              #44536#47353#47749
              1
              1
              #51068#51060#49340#49324#50724#50977#52832#54036#44396#49901#51068#51060#49340#49324#50724
              1
              2
              '1'
              2
              0
              #49688#49888#52376
              2
              1
              #45824#54620#53804#49888
              2
              2
              '2'
              3
              0
              #51228#47785
              3
              1
              #45824#54620#53804#49888
              3
              2
              '3'
              4
              0
              #47700#51068#49436#49885
              4
              1
              #45824#54620#53804#49888
              4
              2
              '4'
              5
              0
              #49436#48260#51204#49569
              5
              1
              #45824#54620#53804#49888
              5
              2
              '5'
              6
              0
              'Edit')
            FontCell = (
              0
              0
              -2147483640
              -12
              #44404#47548#52404
              0
              417408001)
          end
        end
        object DRPanel_SntEmail: TDRPanel
          Left = 0
          Top = 239
          Width = 821
          Height = 203
          Align = alClient
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object DRPanel1: TDRPanel
            Left = 0
            Top = 0
            Width = 821
            Height = 27
            Align = alTop
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnDblClick = DRLabel_SntMailClick
            object DRLabel_SntMail: TDRLabel
              Left = 23
              Top = 7
              Width = 129
              Height = 12
              Caption = '>> E-MAIL '#49569#49888' '#54869#51064
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clPurple
              Font.Height = -12
              Font.Name = #44404#47548#52404
              Font.Style = [fsBold]
              ParentFont = False
              OnClick = DRLabel_SntMailClick
            end
            object DRSpeedBtn_SntEmailPrint: TDRSpeedButton
              Tag = 1
              Left = 749
              Top = 3
              Width = 23
              Height = 20
              Hint = #51064#49604
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = #44404#47548#52404
              Font.Style = []
              Glyph.Data = {
                76010000424D7601000000000000760000002800000020000000100000000100
                04000000000000010000130B0000130B00001000000000000000000000000000
                800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
                00033FFFFFFFFFFFFFFF0888888888888880777777777777777F088888888888
                8880777777777777777F0000000000000000FFFFFFFFFFFFFFFF0F8F8F8F8F8F
                8F80777777777777777F08F8F8F8F8F8F9F0777777777777777F0F8F8F8F8F8F
                8F807777777777777F7F0000000000000000777777777777777F3330FFFFFFFF
                03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
                03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
                33333337F3FF7F3733333330F08F0F0333333337F7737F7333333330FFFF0033
                33333337FFFF7733333333300000033333333337777773333333}
              NumGlyphs = 2
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
            end
            object DRSpeedBtn_EmailResend: TDRSpeedButton
              Tag = 2
              Left = 725
              Top = 3
              Width = 23
              Height = 20
              Hint = #51116#51204#49569
              Enabled = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = #44404#47548#52404
              Font.Style = []
              Glyph.Data = {
                76010000424D7601000000000000760000002800000020000000100000000100
                04000000000000010000130B0000130B00001000000000000000000000000000
                800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                3333333333FFFFF3333333333999993333333333F77777FFF333333999999999
                3333333777333777FF33339993707399933333773337F3777FF3399933000339
                9933377333777F3377F3399333707333993337733337333337FF993333333333
                399377F33333F333377F993333303333399377F33337FF333373993333707333
                333377F333777F333333993333101333333377F333777F3FFFFF993333000399
                999377FF33777F77777F3993330003399993373FF3777F37777F399933000333
                99933773FF777F3F777F339993707399999333773F373F77777F333999999999
                3393333777333777337333333999993333333333377777333333}
              NumGlyphs = 2
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
            end
            object DRSpeedBtn_EmailExport: TDRSpeedButton
              Tag = 1
              Left = 773
              Top = 3
              Width = 23
              Height = 20
              Hint = 'Export'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = #44404#47548#52404
              Font.Style = []
              Glyph.Data = {
                76010000424D7601000000000000760000002800000020000000100000000100
                04000000000000010000130B0000130B00001000000000000000000000000000
                800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333303
                333333333333337FF3333333333333903333333333333377FF33333333333399
                03333FFFFFFFFF777FF3000000999999903377777777777777FF0FFFF0999999
                99037F3337777777777F0FFFF099999999907F3FF777777777770F00F0999999
                99037F773777777777730FFFF099999990337F3FF777777777330F00FFFFF099
                03337F773333377773330FFFFFFFF09033337F3FF3FFF77733330F00F0000003
                33337F773777777333330FFFF0FF033333337F3FF7F3733333330F08F0F03333
                33337F7737F7333333330FFFF003333333337FFFF77333333333000000333333
                3333777777333333333333333333333333333333333333333333}
              NumGlyphs = 2
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
            end
            object DRSpeedBtn_SntEmailSelect: TDRSpeedButton
              Tag = 1
              Left = 701
              Top = 3
              Width = 23
              Height = 20
              Hint = #44228#51340#48324' '#49440#53469
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = #44404#47548#52404
              Font.Style = []
              Glyph.Data = {
                76010000424D7601000000000000760000002800000020000000100000000100
                04000000000000010000120B0000120B00001000000000000000000000000000
                800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
                555555555555555555555555555555555555555555FF55555555555559055555
                55555555577FF5555555555599905555555555557777F5555555555599905555
                555555557777FF5555555559999905555555555777777F555555559999990555
                5555557777777FF5555557990599905555555777757777F55555790555599055
                55557775555777FF5555555555599905555555555557777F5555555555559905
                555555555555777FF5555555555559905555555555555777FF55555555555579
                05555555555555777FF5555555555557905555555555555777FF555555555555
                5990555555555555577755555555555555555555555555555555}
              NumGlyphs = 2
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Visible = False
            end
            object DRPanel4: TDRPanel
              Left = 429
              Top = 6
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
              object DRRadioBtn_EmailSend: TDRRadioButton
                Left = 8
                Top = 1
                Width = 59
                Height = 12
                Caption = #51652#54665#51473
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -12
                Font.Name = #44404#47548#52404
                Font.Style = []
                ParentFont = False
                TabOrder = 0
              end
              object DRRadioBtn_EmailError: TDRRadioButton
                Left = 69
                Top = 1
                Width = 43
                Height = 12
                Caption = #50724#47448
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -12
                Font.Name = #44404#47548#52404
                Font.Style = []
                ParentFont = False
                TabOrder = 1
              end
              object DRRadioBtn_EmailAll: TDRRadioButton
                Left = 119
                Top = 1
                Width = 45
                Height = 12
                Caption = #51204#52404
                Checked = True
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -12
                Font.Name = #44404#47548#52404
                Font.Style = []
                ParentFont = False
                TabOrder = 2
                TabStop = True
              end
            end
            object DRCheckBox_EmailTotFreq: TDRCheckBox
              Left = 613
              Top = 6
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
            end
          end
          object DRStrGrid_SntMail: TDRStringGrid
            Left = 0
            Top = 27
            Width = 821
            Height = 176
            Align = alClient
            Color = clWhite
            ColCount = 8
            DefaultRowHeight = 18
            FixedCols = 0
            RowCount = 15
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            AllowFixedRowClick = True
            TopRow = 1
            LeftCol = 0
            SelectedCellColor = 16047570
            SelectedFontColor = clBlack
            ColWidths = (
              13
              150
              36
              157
              191
              81
              76
              79)
            AlignCol = {000002010001020001030001040001050002060002070002}
            FixedAlignRow = {000002}
            Cells = (
              0
              0
              '>'
              0
              2
              '0'
              1
              0
              #44536#47353#47749
              1
              2
              '1'
              2
              0
              #54924#52264
              2
              2
              '2'
              3
              0
              #49688#49888#52376
              3
              2
              '3'
              4
              0
              #51228#47785
              4
              2
              '4'
              5
              0
              #50836#52397#49884#44036
              5
              1
              'XX:XX:XX'
              5
              2
              '5'
              6
              0
              #50756#47308#49884#44036
              6
              1
              'XX:XX:XX'
              6
              2
              '6'
              7
              0
              'Process'
              7
              2
              '7')
            FontCell = (
              0
              0
              -2147483640
              -12
              #44404#47548#52404
              0
              417408001)
          end
        end
      end
    end
  end
  object ProcessPanel: TDRPanel [1]
    Left = 168
    Top = 250
    Width = 464
    Height = 131
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    Visible = False
    object ProcPanel_Label_Msg: TDRLabel
      Left = 28
      Top = 28
      Width = 105
      Height = 12
      Caption = 'Process Message'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ProcPanel_Label_TotalCnt: TDRLabel
      Left = 28
      Top = 81
      Width = 6
      Height = 12
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object ProcPanel_Label_ProcCnt: TDRLabel
      Left = 28
      Top = 101
      Width = 6
      Height = 12
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object ProcPanel_Animate: TDRAnimate
      Left = 190
      Top = 69
      Width = 272
      Height = 60
      CommonAVI = aviCopyFiles
      StopFrame = 31
      Visible = False
    end
    object ProcPanel_ProgressBar: TDRProgressBar
      Left = 28
      Top = 54
      Width = 411
      Height = 17
      TabOrder = 0
    end
    object ProcPanel_BitBtn_Confirm: TDRBitBtn
      Left = 410
      Top = 6
      Width = 50
      Height = 25
      Caption = #54869#51064
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = ProcPanel_BitBtn_ConfirmClick
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
  end
  inherited DRPanel_Top: TDRPanel
    Width = 829
    DesignSize = (
      829
      27)
    inherited DRPanel_Title: TDRPanel
      Caption = #51088#47308' '#51204#49569' && '#49569#49888' '#54869#51064
    end
    inherited DRBitBtn1: TDRBitBtn
      Left = 762
      Caption = #51333#47308'(F9)'
    end
    inherited DRBitBtn2: TDRBitBtn
      Tag = 1
      Left = 424
      Caption = #51204#49569#51228#50808
      Visible = False
    end
    inherited DRBitBtn3: TDRBitBtn
      Tag = 1
      Left = 630
      Caption = #44081#49888'(F3)'
      Visible = True
    end
    inherited DRBitBtn4: TDRBitBtn
      Tag = 2
      Left = 696
      Caption = #51204#49569'(F4)'
      Visible = True
    end
  end
  inherited MessageBar: TDRMessageBar
    Width = 829
  end
  object DRFramePanel_Query: TDRFramePanel
    Left = 0
    Top = 27
    Width = 829
    Height = 40
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 3
  end
  object DRPanel3: TDRPanel
    Left = 0
    Top = 67
    Width = 829
    Height = 32
    Align = alTop
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    object DRPanel2: TDRPanel
      Left = 644
      Top = 0
      Width = 185
      Height = 32
      Align = alRight
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object DRCheckBox_ClientNM: TDRCheckBox
        Left = 73
        Top = 1
        Width = 112
        Height = 15
        Caption = 'CLIENT'#47749' '#48372#44592
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object DRCheckBox_View: TDRCheckBox
        Left = 73
        Top = 14
        Width = 112
        Height = 17
        Caption = #44228#51340'ID '#48372#44592
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
    end
    object DRPanel5: TDRPanel
      Left = 0
      Top = 0
      Width = 473
      Height = 32
      Align = alLeft
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object DRSaveDialog_GridExport: TDRSaveDialog
    DefaultExt = '*.xls'
    Filter = 'MS EXCEL(*.xls)|*.xls'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Grid Export'
    Left = 288
  end
end
