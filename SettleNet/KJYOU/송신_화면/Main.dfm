object Form1: TForm1
  Left = 381
  Top = 15
  Width = 1160
  Height = 997
  Caption = '[9999] '#44552#50997#49345#54408' '#49569#49888' Manager'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DRPanel1: TDRPanel
    Left = 0
    Top = 0
    Width = 1152
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
    TabOrder = 0
    DesignSize = (
      1152
      27)
    object DRPanel3: TDRPanel
      Left = 1
      Top = 1
      Width = 176
      Height = 25
      Align = alLeft
      BevelInner = bvRaised
      BevelOuter = bvNone
      BevelWidth = 2
      Caption = #44552#50997#49345#54408' '#49569#49888' Manager'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 11141120
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object DRBitBtn1: TDRBitBtn
      Left = 1086
      Top = 1
      Width = 65
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #51333#47308'(F9)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
    object DRBitBtn2: TDRBitBtn
      Tag = 2
      Left = 1019
      Top = 1
      Width = 67
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #51064#49604'(F7)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
    object DRBitBtn3: TDRBitBtn
      Tag = 2
      Left = 952
      Top = 1
      Width = 67
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #51204#49569'(F4)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
    object DRBitBtn4: TDRBitBtn
      Tag = 2
      Left = 885
      Top = 1
      Width = 67
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #44081#49888'(F3)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
    object DRBitBtn5: TDRBitBtn
      Tag = 2
      Left = 805
      Top = 1
      Width = 80
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Import(F2)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
  end
  object MessageBar: TDRMessageBar
    Left = 0
    Top = 941
    Width = 1152
    Height = 25
    Align = alBottom
  end
  object DRFramePanel_Query: TDRFramePanel
    Left = 0
    Top = 27
    Width = 1152
    Height = 40
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object DRLabel3: TDRLabel
      Left = 177
      Top = 14
      Width = 24
      Height = 12
      Caption = #49324#48264
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel5: TDRLabel
      Left = 31
      Top = 14
      Width = 24
      Height = 12
      Caption = #51068#51088
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel1: TDRLabel
      Left = 569
      Top = 14
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
    object DRLabel6: TDRLabel
      Left = 400
      Top = 14
      Width = 48
      Height = 12
      Caption = #49373#49457#49884#44036
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel7: TDRLabel
      Left = 504
      Top = 14
      Width = 24
      Height = 12
      Caption = #51060#54980
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRMaskEdit_Date1: TDRMaskEdit
      Left = 61
      Top = 10
      Width = 75
      Height = 20
      EditMask = '9999-99-99;0; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
      MaxLength = 10
      ParentFont = False
      TabOrder = 0
    end
    object DRMaskEdit1: TDRMaskEdit
      Left = 453
      Top = 11
      Width = 48
      Height = 20
      EditMask = '!90:00;1;_'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
      MaxLength = 5
      ParentFont = False
      TabOrder = 1
      Text = '  :  '
    end
    object DRUserDblCodeCombo1: TDRUserDblCodeCombo
      Left = 209
      Top = 9
      Width = 150
      Height = 20
      EditWidth = 130
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeMode = imDontCare
      ImeName = 'Microsoft IME 2003'
      InsertAllItem = False
      ReadOnly = False
      TabOrder = 2
      TabStop = True
    end
    object DRUserDblCodeCombo2: TDRUserDblCodeCombo
      Left = 623
      Top = 9
      Width = 150
      Height = 20
      EditWidth = 130
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ImeMode = imDontCare
      ImeName = 'Microsoft IME 2003'
      InsertAllItem = False
      ReadOnly = False
      TabOrder = 3
      TabStop = True
    end
  end
  object DRPanel6: TDRPanel
    Left = 0
    Top = 67
    Width = 1152
    Height = 874
    Align = alClient
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object DRPanel2: TDRPanel
      Left = 0
      Top = 0
      Width = 1152
      Height = 874
      Align = alClient
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object DRPanel7: TDRPanel
        Left = 0
        Top = 737
        Width = 1152
        Height = 137
        Align = alClient
        Caption = 'DRPanel7'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object DRStrGrid_SntFaxTlx: TDRStringGrid
          Left = 1
          Top = 25
          Width = 1150
          Height = 111
          Align = alClient
          Color = clWhite
          ColCount = 14
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 15
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect, goThumbTracking]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          AllowFixedRowClick = True
          TopRow = 1
          LeftCol = 0
          SelectedCellColor = 16047570
          SelectedFontColor = clBlack
          ColWidths = (
            14
            50
            76
            138
            56
            103
            178
            32
            145
            63
            61
            76
            69
            49)
          AlignCol = {
            0000020100020200010300010400020500010600010700020800020900020A00
            020B00020C00020D0002}
          FixedAlignRow = {000002}
          Cells = (
            1
            0
            #49324#48264
            1
            1
            '975001'
            1
            2
            '975001'
            1
            3
            '975023'
            2
            0
            #44228#51340#48264#54840
            2
            1
            '99999999-98'
            2
            3
            '99999999-99'
            3
            0
            #44228#51340#47749
            3
            1
            #53580#49828#53944#44228#51340'1'
            3
            3
            #53580#49828#53944#44228#51340'2'
            4
            0
            #51204#49569#44396#48516
            4
            1
            'FAX'
            4
            2
            'E-mail'
            4
            3
            'E-mail'
            5
            0
            #49688#49888#52376
            5
            1
            #45936#51060#53552#47196#46300
            5
            2
            #44592#44288'1'
            5
            3
            #44592#44288'3'
            6
            0
            #54057#49828#48264#54840'/'#47700#51068#51228#47785
            6
            1
            '1234-5678'
            6
            2
            #50504#45397#54616#49464#50836'.'
            6
            3
            #48372#44256#49436' '#48372#45253#45768#45796'.'
            7
            0
            #54924#52264
            7
            1
            '1'#13#10
            7
            2
            '2'
            7
            3
            '1'
            8
            0
            #48372#44256#49436#49436#49885
            9
            0
            #49884#51089#49884#51089
            9
            1
            '11:32:11'#13#10
            9
            2
            '11:34:27'
            9
            3
            '11:36:41'
            10
            0
            #50756#47308#49884#44036
            10
            1
            '11:33:02'
            10
            2
            '11:34:27'
            10
            3
            '11:36:41'
            11
            0
            #51116#51204#49569
            12
            0
            'Process'
            12
            1
            'Sending..'
            12
            2
            'FINISH'
            12
            3
            'FINISH'#13#10
            13
            0
            'Page'
            13
            1
            '1/2')
          FontCell = (
            0
            0
            -2147483640
            -12
            #44404#47548#52404
            0
            434373633)
        end
        object DRPanel4: TDRPanel
          Left = 1
          Top = 1
          Width = 1150
          Height = 24
          Align = alTop
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object DRLabel_SntMail: TDRLabel
            Left = 15
            Top = 7
            Width = 99
            Height = 12
            Caption = '>> '#45817#51068#49569#49888#54869#51064
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clPurple
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = [fsBold]
            ParentFont = False
          end
          object DRSpeedBtn_SntEmailPrint: TDRSpeedButton
            Tag = 1
            Left = 533
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
            Visible = False
          end
          object DRSpeedBtn_EmailResend: TDRSpeedButton
            Tag = 2
            Left = 509
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
            Visible = False
          end
          object DRSpeedBtn_EmailExport: TDRSpeedButton
            Tag = 1
            Left = 557
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
            Visible = False
          end
          object DRSpeedBtn_SntEmailSelect: TDRSpeedButton
            Tag = 1
            Left = 485
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
          object DRSpeedBtn_SntMailRefresh: TDRSpeedButton
            Tag = 1
            Left = 855
            Top = 2
            Width = 23
            Height = 20
            Hint = #44081#49888
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            Glyph.Data = {
              46040000424D4604000000000000360000002800000011000000140000000100
              18000000000010040000C40E0000C40E00000000000000000000C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D4C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D400C8D0D4C8D0D4040404040404040404040404040404040404040404040404
              040404040404040404040404040404C8D0D4C8D0D400C8D0D4C8D0D4868686CC
              CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
              040404C8D0D4C8D0D400C8D0D4C8D0D4868686FFFFFFFFFFFF99FFFFFFFFFF99
              FFFF00993399FFFFFFFFFF99FFFFFFFFFFCCCCCC040404C8D0D4C8D0D400C8D0
              D4C8D0D4868686FFFFFF99FFFFFFFFFF99FFFF009933009933FFFFFF99FFFFFF
              FFFF99FFFFCCCCCC040404C8D0D4C8D0D400C8D0D4C8D0D4868686FFFFFFFFFF
              FF99FFFF00993300993300993300993300993399FFFFFFFFFFCCCCCC040404C8
              D0D4C8D0D400C8D0D4C8D0D4868686FFFFFF99FFFFFFFFFF99FFFF0099330099
              33FFFFFF66990066660099FFFFCCCCCC040404C8D0D4C8D0D400C8D0D4C8D0D4
              868686FFFFFFFFFFFF99FFFFFFFFFF99FFFF00993399FFFFFFFFFF666600FFFF
              FFCCCCCC040404C8D0D4C8D0D400C8D0D4C8D0D4868686FFFFFF99FFFF666600
              99FFFFFFFFFF99FFFFFFFFFF99FFFF66660099FFFFCCCCCC040404C8D0D4C8D0
              D400C8D0D4C8D0D4868686FFFFFFFFFFFF666600FFFFFF99FFFF00993399FFFF
              FFFFFF99FFFFFFFFFFCCCCCC040404C8D0D4C8D0D400C8D0D4C8D0D4868686FF
              FFFF99FFFF666600669900FFFFFF00993300993399FFFFFFFFFF99FFFFCCCCCC
              040404C8D0D4C8D0D400C8D0D4C8D0D4868686FFFFFFFFFFFF99FFFF00993300
              993300993300993300993399FFFFFFFFFFCCCCCC040404C8D0D4C8D0D400C8D0
              D4C8D0D4868686FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00993300993399FFFFFF
              FFFFCCCCCCCCCCCC040404C8D0D4C8D0D400C8D0D4C8D0D4868686FFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFF00993399FFFFFFFFFF040404040404040404040404C8
              D0D4C8D0D400C8D0D4C8D0D4868686FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF99FF
              FFFFFFFF99FFFF868686FFFFFF040404C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4
              868686FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8686860404
              04C8D0D4C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4868686868686868686868686
              868686868686868686868686868686868686C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D400C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D4C8
              D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D400}
            Layout = blGlyphBottom
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
          end
          object DRSpeedButton_SntMail: TDRSpeedButton
            Tag = 1
            Left = 878
            Top = 2
            Width = 23
            Height = 20
            Hint = 'Grid'#51064#49604
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            Glyph.Data = {
              36060000424D3606000000000000360000002800000020000000100000000100
              18000000000000060000120B0000120B00000000000000000000008080000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000000000008080008080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000004AB00
              04AB0004AB0004AB0004AB0004AB0004AB0004AB0004AB0004AB0004AB0004AB
              0004AB0004AB000000007F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFF00000004AB00
              04AB0004AB0004AB0004AB0004AB0004AB0004AB0004AB0004AB0004AB0004AB
              0004AB0004AB000000007F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFF000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFF
              A0DB9FFFFFFFA0DB9FFFFFFFA0DB9FFFFFFFA0DB9FFFFFFFA0DB9FFFFFFFA0DB
              9FFFFFFFA0DB9F0000007F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFF000000A0DB9F
              FFFFFFA0DB9FFFFFFFA0DB9FFFFFFFA0DB9FFFFFFFA0DB9FFFFFFFA0DB9FFFFF
              FFFD4D25FFFFFF0000007F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFF000000FFFFFF
              A0DB9FFFFFFFA0DB9FFFFFFFA0DB9FFFFFFFA0DB9FFFFFFFA0DB9FFFFFFFA0DB
              9FFFFFFFA0DB9F0000007F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFF7F7F7FFFFFFF000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              000000000000000000007F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFF008080008080
              008080000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
              000080800080800080800080800080800080807F7F7FFFFFFF008080FFFFFFFF
              FFFFFFFFFFFFFFFF008080FFFFFF7F7F7FFFFFFF008080008080008080008080
              008080000000FFFFFF000000000000000000000000FFFFFF000000FFFFFF0000
              000080800080800080800080800080800080807F7F7FFFFFFF7F7F7F7F7F7F7F
              7F7F7F7F7F0080807F7F7F0080807F7F7FFFFFFF008080008080008080008080
              008080000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
              000080800080800080800080800080800080807F7F7FFFFFFF008080FFFFFFFF
              FFFF008080FFFFFFFFFFFFFFFFFF7F7F7FFFFFFF008080008080008080008080
              008080000000FFFFFF000000000000FFFFFF0000000000000000000000000000
              000080800080800080800080800080800080807F7F7FFFFFFF7F7F7F7F7F7F00
              80807F7F7F7F7F7F7F7F7F7F7F7F7F7F7F008080008080008080008080008080
              008080000000FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF0000000080
              800080800080800080800080800080800080807F7F7FFFFFFF008080FFFFFFFF
              FFFF7F7F7FFFFFFF0080807F7F7F008080008080008080008080008080008080
              008080000000FFFFFF000000A0DB9FFFFFFF000000FFFFFF0000000080800080
              800080800080800080800080800080800080807F7F7FFFFFFF7F7F7F7F7F7F00
              80807F7F7FFFFFFF7F7F7F008080008080008080008080008080008080008080
              008080000000FFFFFFFFFFFFFFFFFFFFFFFF0000000000000080800080800080
              800080800080800080800080800080800080807F7F7FFFFFFFFFFFFFFFFFFFFF
              FFFF7F7F7F7F7F7F008080008080008080008080008080008080008080008080
              0080800000000000000000000000000000000000000080800080800080800080
              800080800080800080800080800080800080807F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F008080008080008080008080008080008080008080}
            NumGlyphs = 2
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
          end
          object DRPanel5: TDRPanel
            Left = 597
            Top = 7
            Width = 170
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
              Left = 5
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
              Left = 68
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
            Left = 772
            Top = 7
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
          object DRRadioButton1: TDRRadioButton
            Left = 364
            Top = 5
            Width = 41
            Height = 17
            Caption = 'FAX'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            ParentFont = False
            TabOrder = 2
          end
          object DRRadioButton2: TDRRadioButton
            Left = 416
            Top = 5
            Width = 57
            Height = 17
            Caption = 'E-mail'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            ParentFont = False
            TabOrder = 3
          end
          object DRRadioButton3: TDRRadioButton
            Left = 309
            Top = 5
            Width = 41
            Height = 17
            Caption = #51204#52404
            Checked = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            ParentFont = False
            TabOrder = 4
            TabStop = True
          end
        end
      end
      object DRPanel8: TDRPanel
        Left = 0
        Top = 0
        Width = 1152
        Height = 737
        Align = alTop
        Caption = 'DRPanel8'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object DRPanel_SndMailTitle: TDRPanel
          Left = 1
          Top = 1
          Width = 1150
          Height = 24
          Align = alTop
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object DRLabel_SndMail: TDRLabel
            Left = 15
            Top = 7
            Width = 73
            Height = 12
            Caption = '>> '#51204#49569#45824#49345
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clPurple
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = [fsBold]
            ParentFont = False
          end
          object DRSpeedBtn_SndMailDir: TDRSpeedButton
            Tag = 1
            Left = 808
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
          object DRSpeedBtn_Export: TDRSpeedButton
            Tag = 1
            Left = 831
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
          object DRSpeedBtn_SndMailRefresh: TDRSpeedButton
            Tag = 1
            Left = 854
            Top = 2
            Width = 23
            Height = 20
            Hint = #44081#49888
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            Glyph.Data = {
              46040000424D4604000000000000360000002800000011000000140000000100
              18000000000010040000C40E0000C40E00000000000000000000C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D4C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D400C8D0D4C8D0D4040404040404040404040404040404040404040404040404
              040404040404040404040404040404C8D0D4C8D0D400C8D0D4C8D0D4868686CC
              CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
              040404C8D0D4C8D0D400C8D0D4C8D0D4868686FFFFFFFFFFFF99FFFFFFFFFF99
              FFFF00993399FFFFFFFFFF99FFFFFFFFFFCCCCCC040404C8D0D4C8D0D400C8D0
              D4C8D0D4868686FFFFFF99FFFFFFFFFF99FFFF009933009933FFFFFF99FFFFFF
              FFFF99FFFFCCCCCC040404C8D0D4C8D0D400C8D0D4C8D0D4868686FFFFFFFFFF
              FF99FFFF00993300993300993300993300993399FFFFFFFFFFCCCCCC040404C8
              D0D4C8D0D400C8D0D4C8D0D4868686FFFFFF99FFFFFFFFFF99FFFF0099330099
              33FFFFFF66990066660099FFFFCCCCCC040404C8D0D4C8D0D400C8D0D4C8D0D4
              868686FFFFFFFFFFFF99FFFFFFFFFF99FFFF00993399FFFFFFFFFF666600FFFF
              FFCCCCCC040404C8D0D4C8D0D400C8D0D4C8D0D4868686FFFFFF99FFFF666600
              99FFFFFFFFFF99FFFFFFFFFF99FFFF66660099FFFFCCCCCC040404C8D0D4C8D0
              D400C8D0D4C8D0D4868686FFFFFFFFFFFF666600FFFFFF99FFFF00993399FFFF
              FFFFFF99FFFFFFFFFFCCCCCC040404C8D0D4C8D0D400C8D0D4C8D0D4868686FF
              FFFF99FFFF666600669900FFFFFF00993300993399FFFFFFFFFF99FFFFCCCCCC
              040404C8D0D4C8D0D400C8D0D4C8D0D4868686FFFFFFFFFFFF99FFFF00993300
              993300993300993300993399FFFFFFFFFFCCCCCC040404C8D0D4C8D0D400C8D0
              D4C8D0D4868686FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00993300993399FFFFFF
              FFFFCCCCCCCCCCCC040404C8D0D4C8D0D400C8D0D4C8D0D4868686FFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFF00993399FFFFFFFFFF040404040404040404040404C8
              D0D4C8D0D400C8D0D4C8D0D4868686FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF99FF
              FFFFFFFF99FFFF868686FFFFFF040404C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4
              868686FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8686860404
              04C8D0D4C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4868686868686868686868686
              868686868686868686868686868686868686C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D400C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D4C8
              D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D400}
            Layout = blGlyphBottom
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
          end
          object DRSpeedButton_SndMail: TDRSpeedButton
            Tag = 1
            Left = 877
            Top = 2
            Width = 23
            Height = 20
            Hint = 'Grid'#51064#49604
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            Glyph.Data = {
              36060000424D3606000000000000360000002800000020000000100000000100
              18000000000000060000120B0000120B00000000000000000000008080000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000000000008080008080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000004AB00
              04AB0004AB0004AB0004AB0004AB0004AB0004AB0004AB0004AB0004AB0004AB
              0004AB0004AB000000007F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFF00000004AB00
              04AB0004AB0004AB0004AB0004AB0004AB0004AB0004AB0004AB0004AB0004AB
              0004AB0004AB000000007F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFF000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFF
              A0DB9FFFFFFFA0DB9FFFFFFFA0DB9FFFFFFFA0DB9FFFFFFFA0DB9FFFFFFFA0DB
              9FFFFFFFA0DB9F0000007F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFF000000A0DB9F
              FFFFFFA0DB9FFFFFFFA0DB9FFFFFFFA0DB9FFFFFFFA0DB9FFFFFFFA0DB9FFFFF
              FFFD4D25FFFFFF0000007F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFF000000FFFFFF
              A0DB9FFFFFFFA0DB9FFFFFFFA0DB9FFFFFFFA0DB9FFFFFFFA0DB9FFFFFFFA0DB
              9FFFFFFFA0DB9F0000007F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFF7F7F7FFFFFFF000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              000000000000000000007F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFF008080008080
              008080000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
              000080800080800080800080800080800080807F7F7FFFFFFF008080FFFFFFFF
              FFFFFFFFFFFFFFFF008080FFFFFF7F7F7FFFFFFF008080008080008080008080
              008080000000FFFFFF000000000000000000000000FFFFFF000000FFFFFF0000
              000080800080800080800080800080800080807F7F7FFFFFFF7F7F7F7F7F7F7F
              7F7F7F7F7F0080807F7F7F0080807F7F7FFFFFFF008080008080008080008080
              008080000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
              000080800080800080800080800080800080807F7F7FFFFFFF008080FFFFFFFF
              FFFF008080FFFFFFFFFFFFFFFFFF7F7F7FFFFFFF008080008080008080008080
              008080000000FFFFFF000000000000FFFFFF0000000000000000000000000000
              000080800080800080800080800080800080807F7F7FFFFFFF7F7F7F7F7F7F00
              80807F7F7F7F7F7F7F7F7F7F7F7F7F7F7F008080008080008080008080008080
              008080000000FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF0000000080
              800080800080800080800080800080800080807F7F7FFFFFFF008080FFFFFFFF
              FFFF7F7F7FFFFFFF0080807F7F7F008080008080008080008080008080008080
              008080000000FFFFFF000000A0DB9FFFFFFF000000FFFFFF0000000080800080
              800080800080800080800080800080800080807F7F7FFFFFFF7F7F7F7F7F7F00
              80807F7F7FFFFFFF7F7F7F008080008080008080008080008080008080008080
              008080000000FFFFFFFFFFFFFFFFFFFFFFFF0000000000000080800080800080
              800080800080800080800080800080800080807F7F7FFFFFFFFFFFFFFFFFFFFF
              FFFF7F7F7F7F7F7F008080008080008080008080008080008080008080008080
              0080800000000000000000000000000000000000000080800080800080800080
              800080800080800080800080800080800080807F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F008080008080008080008080008080008080008080}
            NumGlyphs = 2
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
          end
          object DRRadioButton4: TDRRadioButton
            Left = 309
            Top = 5
            Width = 41
            Height = 17
            Caption = #51204#52404
            Checked = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            TabStop = True
          end
          object DRRadioButton5: TDRRadioButton
            Left = 364
            Top = 5
            Width = 41
            Height = 17
            Caption = 'FAX'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
          object DRRadioButton6: TDRRadioButton
            Left = 416
            Top = 5
            Width = 57
            Height = 17
            Caption = 'E-mail'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            ParentFont = False
            TabOrder = 2
          end
          object DRCheckBox1: TDRCheckBox
            Left = 104
            Top = 5
            Width = 97
            Height = 17
            Caption = #48120#51204#49569' '#45236#50669#47564
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            ParentFont = False
            TabOrder = 3
          end
          object DRRadioButton7: TDRRadioButton
            Left = 480
            Top = 5
            Width = 57
            Height = 17
            Caption = #48120#46321#47197
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            ParentFont = False
            TabOrder = 4
          end
        end
        object DRStringGrid_Tot_Send: TDRStringGrid
          Left = 8
          Top = 33
          Width = 265
          Height = 88
          Align = alCustom
          Color = clWhite
          ColCount = 10
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 37
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect, goThumbTracking]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnDrawCell = DRStringGrid_Tot_SendDrawCell
          AllowFixedRowClick = True
          TopRow = 1
          LeftCol = 0
          SelectedCellColor = 16047570
          SelectedFontColor = clBlack
          ColWidths = (
            14
            51
            59
            109
            157
            54
            104
            175
            288
            72)
          AlignCol = {000002010002020002030001040001050002060001070001080001090002}
          AlignRow = {000002}
          FixedAlignRow = {000002}
          Cells = (
            1
            0
            #49324#48264
            1
            1
            '975001'
            1
            13
            '975023'
            1
            17
            '123456'
            1
            29
            '123456'
            2
            0
            #49373#49457#49884#44036
            2
            1
            '11:24:00'
            2
            13
            '11:30:24'
            2
            17
            '12:00:03'
            2
            29
            '13:10:48'
            3
            0
            #44228#51340#48264#54840
            3
            1
            '12345678'
            3
            7
            '12345678-12'
            3
            13
            '00000000-00'
            3
            17
            '99999999-99-9999'
            3
            29
            '88888888'
            4
            0
            #44228#51340#47749
            4
            1
            #45936#51060#53552#47196#46300'_'#44228#51340'_1'
            4
            7
            #45936#51060#53552#47196#46300'_'#44228#51340'_1_12'
            4
            13
            #44221#45224#51008#54665'_'#44228#51340'_1'
            4
            17
            #45936#51060#53552#47196#46300'_'#44592#44288'_9'
            4
            29
            #49888#54620#51008#54665'_'#44228#51340
            5
            0
            #51204#49569#44396#48516
            5
            1
            'FAX'
            5
            3
            'FAX'
            5
            5
            'E-mail'
            5
            7
            'FAX'
            5
            9
            'FAX'
            5
            12
            'FAX'
            5
            13
            'E-mail'
            5
            15
            'FAX'
            5
            17
            'E-mail'
            5
            20
            'Fax'
            5
            23
            'Fax'
            5
            26
            'Fax'
            5
            29
            #48120#46321#47197
            6
            0
            #49688#49888#52376#47749
            6
            1
            #51064#44592#54596
            6
            3
            #50976#44305#51652
            6
            5
            #51064#44592#54596';'#50976#44305#51652';'
            6
            7
            #51064#44592#54596
            6
            9
            #50976#44305#51652
            6
            12
            #51060#51221#49688
            6
            13
            #51060#51221#49688';'
            6
            15
            #51060#51221#49688
            6
            17
            #51064#44592#54596';'#50976#44305#51652';'#51060#51221#49688
            6
            20
            #51064#44592#54596
            6
            23
            #50976#44305#51652
            6
            26
            #51060#51221#49688
            6
            29
            #48120#46321#47197
            7
            0
            #49688#49888#52376
            7
            1
            '0000-0000'
            7
            3
            '1234-5678'
            7
            5
            'in@dr.com;yk@dr.com;'
            7
            6
            #13#10
            7
            7
            '0000-0000'
            7
            9
            '1234-5678'
            7
            12
            '9999-9999'
            7
            13
            'js@naver.com'
            7
            15
            '9999-9999'
            7
            17
            'in@dr.com;yk@dr.com;js@naver.com;'
            7
            20
            '0000-0000'
            7
            23
            '1234-5678'
            7
            26
            '9999-9999'
            7
            29
            #48120#46321#47197
            8
            0
            #48372#44256#49436#49436#49885
            8
            1
            #44552#50997#49345#54408' '#54788#44552#47588#49688' '#54869#51064#49436' '#50808#54868'RP '#49888#44508#47588#49688
            8
            2
            #44552#50997#49345#54408' '#54788#44552#47588#49688' '#54869#51064#49436' '#50808#54868'RP '#47588#46020#49888#52397
            8
            3
            #44552#50997#49345#54408' '#54788#44552#47588#49688' '#54869#51064#49436' '#50808#54868'RP '#49888#44508#47588#49688
            8
            4
            #44552#50997#49345#54408' '#54788#44552#47588#49688' '#54869#51064#49436' '#50808#54868'RP '#47588#46020#49888#52397
            8
            5
            #44552#50997#49345#54408' '#54788#44552#47588#49688' '#54869#51064#49436' '#50808#54868'RP '#49888#44508#47588#49688
            8
            6
            #44552#50997#49345#54408' '#54788#44552#47588#49688' '#54869#51064#49436' '#50808#54868'RP '#47588#46020#49888#52397
            8
            7
            #44552#50997#49345#54408' '#54788#44552#47588#49688' '#54869#51064#49436' '#50808#54868'RP '#49888#44508#47588#49688
            8
            8
            #44552#50997#49345#54408' '#54788#44552#47588#49688' '#54869#51064#49436' '#50808#54868'RP '#47588#46020#49888#52397
            8
            9
            #44552#50997#49345#54408' '#54788#44552#47588#49688' '#54869#51064#49436' '#50808#54868'RP '#49888#44508#47588#49688
            8
            10
            #44552#50997#49345#54408' '#54788#44552#47588#49688' '#54869#51064#49436' '#50808#54868'RP '#47588#46020#49888#52397
            8
            12
            #51092#44256#51613#47749#49436
            8
            13
            'RP'#49688#51061#44552#44228#49328#49436' RP'
            8
            14
            #50896#52380#51669#49688#50689#49688#51613
            8
            15
            'RP'#49688#51061#44552#44228#49328#49436' RP'
            8
            16
            #50896#52380#51669#49688#50689#49688#51613
            8
            17
            #44552#50997#49345#54408' '#54788#44552#47588#49688' '#54869#51064#49436' '#50808#54868'RP '#49888#44508#47588#49688
            8
            18
            'RP'#49688#51061#44552#44228#49328#49436' RP'
            8
            19
            #50896#52380#51669#49688#50689#49688#51613
            8
            20
            #44552#50997#49345#54408' '#54788#44552#47588#49688' '#54869#51064#49436' '#50808#54868'RP '#49888#44508#47588#49688
            8
            21
            'RP'#49688#51061#44552#44228#49328#49436' RP'
            8
            22
            #50896#52380#51669#49688#50689#49688#51613
            8
            23
            #44552#50997#49345#54408' '#54788#44552#47588#49688' '#54869#51064#49436' '#50808#54868'RP '#49888#44508#47588#49688
            8
            24
            'RP'#49688#51061#44552#44228#49328#49436' RP'
            8
            25
            #50896#52380#51669#49688#50689#49688#51613
            8
            26
            #44552#50997#49345#54408' '#54788#44552#47588#49688' '#54869#51064#49436' '#50808#54868'RP '#49888#44508#47588#49688
            8
            27
            'RP'#49688#51061#44552#44228#49328#49436' RP'
            8
            28
            #50896#52380#51669#49688#50689#49688#51613
            8
            29
            #51092#44256#51613#47749#49436
            8
            30
            #50896#52380#51669#49688#50689#49688#51613
            9
            0
            #49436#48260#51204#49569
            9
            5
            #13#10)
          FontCell = (
            0
            0
            -2147483640
            -12
            #44404#47548#52404
            0
            434373633
            5
            29
            255
            -12
            #44404#47548#52404
            0
            434373632
            6
            29
            255
            -12
            #44404#47548#52404
            0
            434373632
            7
            29
            255
            -12
            #44404#47548#52404
            0
            434373632)
        end
      end
    end
  end
end
