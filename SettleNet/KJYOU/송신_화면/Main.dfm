object Form1: TForm1
  Left = 0
  Top = 41
  Width = 1024
  Height = 643
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
    Width = 1016
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
      1016
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
      Left = 950
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
      Left = 883
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
      Left = 816
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
      Left = 749
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
      Left = 669
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
    Top = 591
    Width = 1016
    Height = 25
    Align = alBottom
  end
  object DRFramePanel_Query: TDRFramePanel
    Left = 0
    Top = 27
    Width = 1016
    Height = 40
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object DRLabel3: TDRLabel
      Left = 179
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
      Left = 565
      Top = 14
      Width = 102
      Height = 12
      Caption = #44228#51340#48264#54840'/'#44592#44288#53076#46300
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
    end
    object DRLabel6: TDRLabel
      Left = 394
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
      Left = 498
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
      Width = 74
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
      Text = '20180101'
    end
    object DRMaskEdit1: TDRMaskEdit
      Left = 447
      Top = 11
      Width = 47
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
      Text = '09:00'
      OnKeyPress = DRMaskEdit1KeyPress
    end
    object DRUserDblCodeCombo1: TDRUserDblCodeCombo
      Left = 211
      Top = 10
      Width = 140
      Height = 20
      EditWidth = 120
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
      OnCodeChange = DRUserDblCodeCombo1CodeChange
    end
    object DRUserDblCodeCombo2: TDRUserDblCodeCombo
      Left = 671
      Top = 10
      Width = 200
      Height = 20
      EditWidth = 180
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
      OnCodeChange = DRUserDblCodeCombo2CodeChange
    end
  end
  object DRPanel6: TDRPanel
    Left = 0
    Top = 67
    Width = 1016
    Height = 524
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
      Width = 1016
      Height = 524
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
        Top = 377
        Width = 1016
        Height = 147
        Align = alClient
        BevelOuter = bvNone
        Caption = 'DRPanel7'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object DRPanel4: TDRPanel
          Left = 0
          Top = 0
          Width = 1016
          Height = 24
          Align = alTop
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentFont = False
          TabOrder = 0
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
          object DRSpeedBtn_SntMailPDFExport: TDRSpeedButton
            Tag = 1
            Left = 902
            Top = 2
            Width = 23
            Height = 20
            Hint = 'PDF Export'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            Glyph.Data = {
              66060000424D6606000000000000360000002800000017000000160000000100
              18000000000030060000C40E0000C40E00000000000000000000C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400
              0000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
              D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D45A5A5A31313131313131313129292931313129292929292910101010
              1010101010101010101010C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D47B737BFFFFFFFFFFFFEFEFEFEFEFEFEFEFEFEFEF
              EFDED6DEDED6DEDED6DECEC6C6DED6DE101010C8D0D4C8D0D4C8D0D4C8D0D400
              0000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D47B737B6363FF7373FFFFFFFF
              EFEFEFEFEFEFDED6DEDED6DEDED6DEDED6DECEC6C6DED6DE101010C8D0D4C8D0
              D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D47B737BEF
              EFEF5A5ACE8C8CE7FFFFFFEFEFEFEFEFEFEFEFEFEFEFEFDED6DECEC6C6DED6DE
              101010C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D47B737BFFFFFFFFFFFF5A5ACEB5B5EFDEDEEFFFF7EFFFFFFFF7EFEFB5
              B5D66363FFEFEFEF101010C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D47B737BEFEFEFEFEFEFDEDEEF4A4AF7ADADFFADAD
              FF4A4AF74A4AF75A5ACE8C8CE7FFFFFF101010C8D0D4C8D0D4C8D0D4C8D0D400
              0000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D47B737BEFEFEFEFEFEFFFFFFF
              7373FFF7EFEF8C8CE7ADADFFFFFFFFEFEFEFDED6DEEFEFEF101010C8D0D4C8D0
              D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D47B737BEF
              EFEFDED6DEEFEFEFDEDEEF3931FF9C9CEFFFFFFFEFEFEFEFEFEFDED6DEEFEFEF
              101010C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D47B737BEFEFEFDED6DEDED6DEFFFFFF4A4AF7EFEFEFEFEFEFEFEFEFDE
              D6DECEC6C6EFEFEF101010C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D47B737BDED6DECEC6C6DED6DEDED6DE5A5ACEDED6
              DEEFEFEFDED6DEDED6DECEC6C6DED6DE101010C8D0D4C8D0D4C8D0D4C8D0D400
              0000C8D0D4C8D0D4C8D0D40000D608088C08088C08088C08088C08088C08088C
              08088C08088C08088CEFEFEFCEC6C6CEC6C6BDB5BDCEC6C6101010C8D0D4C8D0
              D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D46363FF2921FF1010FF1010FF00
              00F70000F70000F70000D60000D608088C8C8C8C7B737B7B737B7B737B8C8C8C
              313131C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D47373FF3931
              FF2921FF1010FF0000F70000F70000F70000F70000D608088C7B737BFFFFFFFF
              FFFFFFFFFF313131C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4
              C8D0D47373FF6363FF4A4AF74A4AF74A4AF73931FF3931FF3931FF2921FF0000
              D68C8C8CFFFFFFFFFFFF313131C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400
              0000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D47B737BCEC6C6C6BDBDC6BDBD
              C6BDBDBDB5BDA5A5A58C8C8CDED6DE313131C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D47B737B7B
              737B7B737B7B737B7B737B7B737B7B737B7B737B7B737BC8D0D4C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
              D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400
              0000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D4C8D0D4000000}
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
        object DRStrGrid_SntFaxTlx: TDRStringGrid
          Left = 0
          Top = 24
          Width = 1016
          Height = 123
          Align = alClient
          Color = clWhite
          ColCount = 13
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 3
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
            61
            63
            42
            76
            46)
          AlignCol = {
            0000020100020200010300010400020500010600010700020800020900020A00
            020B00020C0002}
          FixedAlignRow = {000002}
          Cells = (
            1
            0
            #49324#48264
            1
            1
            '975001'
            2
            0
            #44228#51340#48264#54840
            2
            1
            '99999999-98'
            3
            0
            #44228#51340#47749
            3
            1
            #45936#51060#53552#47196#46300'_'#44228#51340'_1'
            4
            0
            #51204#49569#44396#48516
            4
            1
            'FAX'
            4
            2
            'E-mail'
            5
            0
            #49688#49888#52376#47749
            5
            1
            #51064#44592#54596
            5
            2
            #51064#44592#54596';'#50976#44305#51652';'
            6
            0
            #49688#49888#52376
            6
            1
            '0000-0000'
            6
            2
            'in@dr.com;yk@dr.com;'
            7
            0
            #54924#52264
            7
            1
            '1'#13#10
            7
            2
            '2'
            8
            0
            #49884#51089#49884#51089
            8
            1
            '11:32:11'#13#10
            8
            2
            '11:34:27'
            9
            0
            #50756#47308#49884#44036
            9
            1
            '11:33:02'
            9
            2
            '11:34:27'
            10
            0
            #51116#51204#49569
            11
            0
            'Process'
            11
            1
            'Sending..'
            11
            2
            'FINISH'
            12
            0
            'Page'
            12
            1
            '1/2'#13#10)
          FontCell = (
            0
            0
            -2147483640
            -12
            #44404#47548#52404
            0
            418022401)
        end
      end
      object DRPanel8: TDRPanel
        Left = 0
        Top = 0
        Width = 1016
        Height = 377
        Align = alTop
        BevelOuter = bvNone
        Caption = 'DRPanel8'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object DRStrGrid_SndMail_Total: TDRStringGrid
          Tag = 99
          Left = 0
          Top = 24
          Width = 570
          Height = 113
          Align = alCustom
          Color = clWhite
          ColCount = 10
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 11
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
            51
            59
            129
            131
            54
            104
            175
            160
            72)
          AlignCol = {000002010002020002030001040001050002060001070001080001090002}
          AlignRow = {000002}
          FixedAlignRow = {000002}
          Cells = (
            0
            5
            '>'
            1
            0
            #49324#48264
            1
            1
            '975001'
            1
            5
            '975001'
            1
            6
            '975001'
            1
            7
            '975001'
            1
            8
            '975023'
            1
            9
            '975023'
            1
            10
            '975023'
            2
            0
            #49373#49457#49884#44036
            2
            1
            '11:24:00'
            2
            5
            '11:24:02'
            2
            6
            '11:24:11'
            2
            7
            '11:24:25'
            2
            8
            '11:35:57'
            2
            9
            '12:00:00'
            2
            10
            '12:01:00'
            3
            0
            #44228#51340#48264#54840'/'#44592#44288#53076#46300
            3
            1
            '99999999-98'
            3
            8
            '99999999-99'
            3
            9
            '123-45-67890'
            3
            10
            '000-00-0000'
            4
            0
            #44228#51340#47749'/'#44592#44288#47749
            4
            1
            #53580#49828#53944#44228#51340'1'
            4
            8
            #53580#49828#53944#44228#51340'2'
            4
            9
            #44144#47000#44592#44288'1'
            4
            10
            #44144#47000#44592#44288'2'
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
            8
            'E-mail'#13#10
            5
            9
            'E-mail'
            5
            10
            'Fax'
            6
            0
            #49688#49888#52376#47749
            6
            1
            #45936#51060#53552#47196#46300
            6
            3
            #44592#44288'7'
            6
            5
            #44592#44288'1'
            6
            8
            #44592#44288'3'
            6
            9
            #44592#44288'1'
            6
            10
            #44592#44288'2'
            7
            0
            #49688#49888#52376
            7
            1
            '1234-5678'
            7
            3
            '2222-3333'
            7
            5
            'abc@abc.com;123@abc.com'
            7
            6
            #13#10
            7
            8
            #48372#44256#49436' '#48372#45253#45768#45796'.'
            7
            9
            'abc@abc.com;123@abc.com'
            7
            10
            '2020-2020'
            8
            0
            #48372#44256#49436#49436#49885
            8
            1
            '['#51077#44552'] MMW'#49888#44508'-'#54869#51064#49436
            8
            2
            '['#52636#44552'] RP-'#49688#51061#44552#44228#49328#49436
            8
            3
            '['#51077#44552'] MMW'#49888#44508'-'#54869#51064#49436
            8
            4
            '['#52636#44552'] RP-'#49688#51061#44552#44228#49328#49436
            8
            5
            '['#52636#44552'] RP-'#50896#52380#51669#49688#50689#49688#51613
            8
            6
            '['#52636#44552'] '#51092#44256#51613#47749#49436
            8
            7
            '['#51092#44256'] '#51092#44256#51613#47749#49436
            8
            8
            '['#44592#53440'] '#51333#54633#44228#51340#51088#49328#54788#54889
            8
            9
            '['#51092#44256'] '#51092#44256#51613#47749#49436
            8
            10
            '['#51092#44256'] '#51092#44256#51613#47749#49436
            9
            0
            #49436#48260#51204#49569
            9
            5
            '11:34:27'
            9
            6
            '11:34:27'
            9
            7
            '11:34:27'
            9
            8
            '11:36:41')
          FontCell = (
            0
            0
            -2147483640
            -12
            #44404#47548#52404
            0
            418022401)
        end
        object DRPanel_SndMailTitle: TDRPanel
          Left = 0
          Top = 0
          Width = 1016
          Height = 24
          Align = alTop
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentFont = False
          TabOrder = 1
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
          object DRSpeedBtn_SndMailPDFExport: TDRSpeedButton
            Tag = 1
            Left = 902
            Top = 2
            Width = 23
            Height = 20
            Hint = 'PDF Export'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            Glyph.Data = {
              66060000424D6606000000000000360000002800000017000000160000000100
              18000000000030060000C40E0000C40E00000000000000000000C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400
              0000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
              D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D45A5A5A31313131313131313129292931313129292929292910101010
              1010101010101010101010C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D47B737BFFFFFFFFFFFFEFEFEFEFEFEFEFEFEFEFEF
              EFDED6DEDED6DEDED6DECEC6C6DED6DE101010C8D0D4C8D0D4C8D0D4C8D0D400
              0000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D47B737B6363FF7373FFFFFFFF
              EFEFEFEFEFEFDED6DEDED6DEDED6DEDED6DECEC6C6DED6DE101010C8D0D4C8D0
              D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D47B737BEF
              EFEF5A5ACE8C8CE7FFFFFFEFEFEFEFEFEFEFEFEFEFEFEFDED6DECEC6C6DED6DE
              101010C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D47B737BFFFFFFFFFFFF5A5ACEB5B5EFDEDEEFFFF7EFFFFFFFF7EFEFB5
              B5D66363FFEFEFEF101010C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D47B737BEFEFEFEFEFEFDEDEEF4A4AF7ADADFFADAD
              FF4A4AF74A4AF75A5ACE8C8CE7FFFFFF101010C8D0D4C8D0D4C8D0D4C8D0D400
              0000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D47B737BEFEFEFEFEFEFFFFFFF
              7373FFF7EFEF8C8CE7ADADFFFFFFFFEFEFEFDED6DEEFEFEF101010C8D0D4C8D0
              D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D47B737BEF
              EFEFDED6DEEFEFEFDEDEEF3931FF9C9CEFFFFFFFEFEFEFEFEFEFDED6DEEFEFEF
              101010C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D47B737BEFEFEFDED6DEDED6DEFFFFFF4A4AF7EFEFEFEFEFEFEFEFEFDE
              D6DECEC6C6EFEFEF101010C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D47B737BDED6DECEC6C6DED6DEDED6DE5A5ACEDED6
              DEEFEFEFDED6DEDED6DECEC6C6DED6DE101010C8D0D4C8D0D4C8D0D4C8D0D400
              0000C8D0D4C8D0D4C8D0D40000D608088C08088C08088C08088C08088C08088C
              08088C08088C08088CEFEFEFCEC6C6CEC6C6BDB5BDCEC6C6101010C8D0D4C8D0
              D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D46363FF2921FF1010FF1010FF00
              00F70000F70000F70000D60000D608088C8C8C8C7B737B7B737B7B737B8C8C8C
              313131C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D47373FF3931
              FF2921FF1010FF0000F70000F70000F70000F70000D608088C7B737BFFFFFFFF
              FFFFFFFFFF313131C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4
              C8D0D47373FF6363FF4A4AF74A4AF74A4AF73931FF3931FF3931FF2921FF0000
              D68C8C8CFFFFFFFFFFFF313131C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400
              0000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D47B737BCEC6C6C6BDBDC6BDBD
              C6BDBDBDB5BDA5A5A58C8C8CDED6DE313131C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D47B737B7B
              737B7B737B7B737B7B737B7B737B7B737B7B737B7B737BC8D0D4C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
              D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400
              0000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D4C8D0D4000000}
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
            OnClick = DRRadioButton4Click
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
            OnClick = DRRadioButton4Click
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
            OnClick = DRRadioButton4Click
          end
          object DRCheckBox1: TDRCheckBox
            Left = 104
            Top = 5
            Width = 97
            Height = 17
            Caption = #48120#51204#49569
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #44404#47548#52404
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            OnClick = DRCheckBox1Click
          end
        end
        object DRStrGrid_SndMail_NotSend: TDRStringGrid
          Tag = 1
          Left = 32
          Top = 40
          Width = 570
          Height = 113
          Align = alCustom
          Color = clWhite
          ColCount = 10
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 11
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect, goThumbTracking]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          AllowFixedRowClick = True
          TopRow = 1
          LeftCol = 0
          SelectedCellColor = 16047570
          SelectedFontColor = clBlack
          ColWidths = (
            14
            51
            59
            129
            131
            54
            104
            175
            160
            72)
          AlignCol = {000002010002020002030001040001050002060001070001080001090002}
          AlignRow = {000002}
          FixedAlignRow = {000002}
          Cells = (
            0
            5
            '>'
            1
            0
            #49324#48264
            1
            1
            '975001'
            1
            5
            '975001'
            1
            6
            '975001'
            1
            7
            '975001'
            1
            8
            '975023'
            1
            9
            '975023'
            1
            10
            '975023'
            2
            0
            #49373#49457#49884#44036
            2
            1
            '11:24:00'
            2
            5
            '11:24:02'
            2
            6
            '11:24:11'
            2
            7
            '11:24:25'
            2
            8
            '11:35:57'
            2
            9
            '12:00:00'
            2
            10
            '12:01:00'
            3
            0
            #44228#51340#48264#54840'/'#44592#44288#53076#46300
            3
            1
            '99999999-98'
            3
            8
            '99999999-99'
            3
            9
            '123-45-67890'
            3
            10
            '000-00-0000'
            4
            0
            #44228#51340#47749'/'#44592#44288#47749
            4
            1
            #53580#49828#53944#44228#51340'1'
            4
            8
            #53580#49828#53944#44228#51340'2'
            4
            9
            #44144#47000#44592#44288'1'
            4
            10
            #44144#47000#44592#44288'2'
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
            8
            'E-mail'#13#10
            5
            9
            'E-mail'
            5
            10
            'Fax'
            6
            0
            #49688#49888#52376
            6
            1
            #45936#51060#53552#47196#46300
            6
            3
            #44592#44288'7'
            6
            5
            #44592#44288'1'
            6
            8
            #44592#44288'3'
            6
            9
            #44592#44288'1'
            6
            10
            #44592#44288'2'
            7
            0
            #54057#49828#48264#54840'/'#47700#51068#51228#47785
            7
            1
            '1234-5678'
            7
            3
            '2222-3333'
            7
            5
            #50504#45397#54616#49464#50836'.'
            7
            6
            #13#10
            7
            8
            #48372#44256#49436' '#48372#45253#45768#45796'.'
            7
            9
            #48372#44256#49436' '#48372#45253#45768#45796'.'
            7
            10
            '2020-2020'
            8
            0
            #48372#44256#49436#49436#49885
            8
            1
            '['#51077#44552'] MMW'#49888#44508'-'#54869#51064#49436
            8
            2
            '['#52636#44552'] RP-'#49688#51061#44552#44228#49328#49436
            8
            3
            '['#51077#44552'] MMW'#49888#44508'-'#54869#51064#49436
            8
            4
            '['#52636#44552'] RP-'#49688#51061#44552#44228#49328#49436
            8
            5
            '['#52636#44552'] RP-'#50896#52380#51669#49688#50689#49688#51613
            8
            6
            '['#52636#44552'] '#51092#44256#51613#47749#49436
            8
            7
            '['#51092#44256'] '#51092#44256#51613#47749#49436
            8
            8
            '['#44592#53440'] '#51333#54633#44228#51340#51088#49328#54788#54889
            8
            9
            '['#51092#44256'] '#51092#44256#51613#47749#49436
            8
            10
            '['#51092#44256'] '#51092#44256#51613#47749#49436
            9
            0
            #49436#48260#51204#49569
            9
            5
            #13#10
            9
            6
            '11:34:27'
            9
            7
            '11:34:27'
            9
            8
            '11:36:41')
          FontCell = (
            0
            0
            -2147483640
            -12
            #44404#47548#52404
            0
            418022401)
        end
        object DRStrGrid_SndMail_OnlyFax: TDRStringGrid
          Tag = 2
          Left = 64
          Top = 64
          Width = 570
          Height = 113
          Align = alCustom
          Color = clWhite
          ColCount = 10
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 11
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect, goThumbTracking]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          AllowFixedRowClick = True
          TopRow = 1
          LeftCol = 0
          SelectedCellColor = 16047570
          SelectedFontColor = clBlack
          ColWidths = (
            14
            51
            59
            129
            131
            54
            104
            175
            160
            72)
          AlignCol = {000002010002020002030001040001050002060001070001080001090002}
          AlignRow = {000002}
          FixedAlignRow = {000002}
          Cells = (
            0
            5
            '>'
            1
            0
            #49324#48264
            1
            1
            '975001'
            1
            5
            '975001'
            1
            6
            '975001'
            1
            7
            '975001'
            1
            8
            '975023'
            1
            9
            '975023'
            1
            10
            '975023'
            2
            0
            #49373#49457#49884#44036
            2
            1
            '11:24:00'
            2
            5
            '11:24:02'
            2
            6
            '11:24:11'
            2
            7
            '11:24:25'
            2
            8
            '11:35:57'
            2
            9
            '12:00:00'
            2
            10
            '12:01:00'
            3
            0
            #44228#51340#48264#54840'/'#44592#44288#53076#46300
            3
            1
            '99999999-98'
            3
            8
            '99999999-99'
            3
            9
            '123-45-67890'
            3
            10
            '000-00-0000'
            4
            0
            #44228#51340#47749'/'#44592#44288#47749
            4
            1
            #53580#49828#53944#44228#51340'1'
            4
            8
            #53580#49828#53944#44228#51340'2'
            4
            9
            #44144#47000#44592#44288'1'
            4
            10
            #44144#47000#44592#44288'2'
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
            8
            'E-mail'#13#10
            5
            9
            'E-mail'
            5
            10
            'Fax'
            6
            0
            #49688#49888#52376
            6
            1
            #45936#51060#53552#47196#46300
            6
            3
            #44592#44288'7'
            6
            5
            #44592#44288'1'
            6
            8
            #44592#44288'3'
            6
            9
            #44592#44288'1'
            6
            10
            #44592#44288'2'
            7
            0
            #54057#49828#48264#54840'/'#47700#51068#51228#47785
            7
            1
            '1234-5678'
            7
            3
            '2222-3333'
            7
            5
            #50504#45397#54616#49464#50836'.'
            7
            6
            #13#10
            7
            8
            #48372#44256#49436' '#48372#45253#45768#45796'.'
            7
            9
            #48372#44256#49436' '#48372#45253#45768#45796'.'
            7
            10
            '2020-2020'
            8
            0
            #48372#44256#49436#49436#49885
            8
            1
            '['#51077#44552'] MMW'#49888#44508'-'#54869#51064#49436
            8
            2
            '['#52636#44552'] RP-'#49688#51061#44552#44228#49328#49436
            8
            3
            '['#51077#44552'] MMW'#49888#44508'-'#54869#51064#49436
            8
            4
            '['#52636#44552'] RP-'#49688#51061#44552#44228#49328#49436
            8
            5
            '['#52636#44552'] RP-'#50896#52380#51669#49688#50689#49688#51613
            8
            6
            '['#52636#44552'] '#51092#44256#51613#47749#49436
            8
            7
            '['#51092#44256'] '#51092#44256#51613#47749#49436
            8
            8
            '['#44592#53440'] '#51333#54633#44228#51340#51088#49328#54788#54889
            8
            9
            '['#51092#44256'] '#51092#44256#51613#47749#49436
            8
            10
            '['#51092#44256'] '#51092#44256#51613#47749#49436
            9
            0
            #49436#48260#51204#49569
            9
            5
            #13#10
            9
            6
            '11:34:27'
            9
            7
            '11:34:27'
            9
            8
            '11:36:41')
          FontCell = (
            0
            0
            -2147483640
            -12
            #44404#47548#52404
            0
            418022401)
        end
        object DRStrGrid_SndMail_OnlyEmail: TDRStringGrid
          Tag = 3
          Left = 104
          Top = 96
          Width = 570
          Height = 113
          Align = alCustom
          Color = clWhite
          ColCount = 10
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 11
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect, goThumbTracking]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          AllowFixedRowClick = True
          TopRow = 1
          LeftCol = 0
          SelectedCellColor = 16047570
          SelectedFontColor = clBlack
          ColWidths = (
            14
            51
            59
            129
            131
            54
            104
            175
            160
            72)
          AlignCol = {000002010002020002030001040001050002060001070001080001090002}
          AlignRow = {000002}
          FixedAlignRow = {000002}
          Cells = (
            0
            5
            '>'
            1
            0
            #49324#48264
            1
            1
            '975001'
            1
            5
            '975001'
            1
            6
            '975001'
            1
            7
            '975001'
            1
            8
            '975023'
            1
            9
            '975023'
            1
            10
            '975023'
            2
            0
            #49373#49457#49884#44036
            2
            1
            '11:24:00'
            2
            5
            '11:24:02'
            2
            6
            '11:24:11'
            2
            7
            '11:24:25'
            2
            8
            '11:35:57'
            2
            9
            '12:00:00'
            2
            10
            '12:01:00'
            3
            0
            #44228#51340#48264#54840'/'#44592#44288#53076#46300
            3
            1
            '99999999-98'
            3
            5
            '99999999-98'
            3
            8
            '99999999-99'
            3
            9
            '123-45-67890'
            3
            10
            '000-00-0000'
            4
            0
            #44228#51340#47749'/'#44592#44288#47749
            4
            1
            #53580#49828#53944#44228#51340'1'
            4
            8
            #53580#49828#53944#44228#51340'2'
            4
            9
            #44144#47000#44592#44288'1'
            4
            10
            #44144#47000#44592#44288'2'
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
            8
            'E-mail'#13#10
            5
            9
            'E-mail'
            5
            10
            'Fax'
            6
            0
            #49688#49888#52376
            6
            1
            #45936#51060#53552#47196#46300
            6
            3
            #44592#44288'7'
            6
            5
            #44592#44288'1'
            6
            8
            #44592#44288'3'
            6
            9
            #44592#44288'1'
            6
            10
            #44592#44288'2'
            7
            0
            #54057#49828#48264#54840'/'#47700#51068#51228#47785
            7
            1
            '1234-5678'
            7
            3
            '2222-3333'
            7
            5
            #50504#45397#54616#49464#50836'.'
            7
            6
            #13#10
            7
            8
            #48372#44256#49436' '#48372#45253#45768#45796'.'
            7
            9
            #48372#44256#49436' '#48372#45253#45768#45796'.'
            7
            10
            '2020-2020'
            8
            0
            #48372#44256#49436#49436#49885
            8
            1
            '['#51077#44552'] MMW'#49888#44508'-'#54869#51064#49436
            8
            2
            '['#52636#44552'] RP-'#49688#51061#44552#44228#49328#49436
            8
            3
            '['#51077#44552'] MMW'#49888#44508'-'#54869#51064#49436
            8
            4
            '['#52636#44552'] RP-'#49688#51061#44552#44228#49328#49436
            8
            5
            '['#52636#44552'] RP-'#50896#52380#51669#49688#50689#49688#51613
            8
            6
            '['#52636#44552'] '#51092#44256#51613#47749#49436
            8
            7
            '['#51092#44256'] '#51092#44256#51613#47749#49436
            8
            8
            '['#44592#53440'] '#51333#54633#44228#51340#51088#49328#54788#54889
            8
            9
            '['#51092#44256'] '#51092#44256#51613#47749#49436
            8
            10
            '['#51092#44256'] '#51092#44256#51613#47749#49436
            9
            0
            #49436#48260#51204#49569
            9
            5
            #13#10
            9
            6
            '11:34:27'
            9
            7
            '11:34:27'
            9
            8
            '11:36:41')
          FontCell = (
            0
            0
            -2147483640
            -12
            #44404#47548#52404
            0
            418022401)
        end
        object DRStrGrid_SndMail_WorkNo: TDRStringGrid
          Tag = 4
          Left = 144
          Top = 120
          Width = 570
          Height = 113
          Align = alCustom
          Color = clWhite
          ColCount = 10
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 11
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect, goThumbTracking]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          AllowFixedRowClick = True
          TopRow = 1
          LeftCol = 0
          SelectedCellColor = 16047570
          SelectedFontColor = clBlack
          ColWidths = (
            14
            51
            59
            129
            131
            54
            104
            175
            160
            72)
          AlignCol = {000002010002020002030001040001050002060001070001080001090002}
          AlignRow = {000002}
          FixedAlignRow = {000002}
          Cells = (
            0
            5
            '>'
            1
            0
            #49324#48264
            1
            1
            '975001'
            1
            5
            '975001'
            1
            6
            '975001'
            1
            7
            '975001'
            1
            8
            '975023'
            1
            9
            '975023'
            1
            10
            '975023'
            2
            0
            #49373#49457#49884#44036
            2
            1
            '11:24:00'
            2
            5
            '11:24:02'
            2
            6
            '11:24:11'
            2
            7
            '11:24:25'
            2
            8
            '11:35:57'
            2
            9
            '12:00:00'
            2
            10
            '12:01:00'
            3
            0
            #44228#51340#48264#54840'/'#44592#44288#53076#46300
            3
            1
            '99999999-98'
            3
            8
            '99999999-99'
            3
            9
            '123-45-67890'
            3
            10
            '000-00-0000'
            4
            0
            #44228#51340#47749'/'#44592#44288#47749
            4
            1
            #53580#49828#53944#44228#51340'1'
            4
            8
            #53580#49828#53944#44228#51340'2'
            4
            9
            #44144#47000#44592#44288'1'
            4
            10
            #44144#47000#44592#44288'2'
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
            8
            'E-mail'#13#10
            5
            9
            'E-mail'
            5
            10
            'Fax'
            6
            0
            #49688#49888#52376
            6
            1
            #45936#51060#53552#47196#46300
            6
            3
            #44592#44288'7'
            6
            5
            #44592#44288'1'
            6
            8
            #44592#44288'3'
            6
            9
            #44592#44288'1'
            6
            10
            #44592#44288'2'
            7
            0
            #54057#49828#48264#54840'/'#47700#51068#51228#47785
            7
            1
            '1234-5678'
            7
            3
            '2222-3333'
            7
            5
            #50504#45397#54616#49464#50836'.'
            7
            6
            #13#10
            7
            8
            #48372#44256#49436' '#48372#45253#45768#45796'.'
            7
            9
            #48372#44256#49436' '#48372#45253#45768#45796'.'
            7
            10
            '2020-2020'
            8
            0
            #48372#44256#49436#49436#49885
            8
            1
            '['#51077#44552'] MMW'#49888#44508'-'#54869#51064#49436
            8
            2
            '['#52636#44552'] RP-'#49688#51061#44552#44228#49328#49436
            8
            3
            '['#51077#44552'] MMW'#49888#44508'-'#54869#51064#49436
            8
            4
            '['#52636#44552'] RP-'#49688#51061#44552#44228#49328#49436
            8
            5
            '['#52636#44552'] RP-'#50896#52380#51669#49688#50689#49688#51613
            8
            6
            '['#52636#44552'] '#51092#44256#51613#47749#49436
            8
            7
            '['#51092#44256'] '#51092#44256#51613#47749#49436
            8
            8
            '['#44592#53440'] '#51333#54633#44228#51340#51088#49328#54788#54889
            8
            9
            '['#51092#44256'] '#51092#44256#51613#47749#49436
            8
            10
            '['#51092#44256'] '#51092#44256#51613#47749#49436
            9
            0
            #49436#48260#51204#49569
            9
            5
            #13#10
            9
            6
            '11:34:27'
            9
            7
            '11:34:27'
            9
            8
            '11:36:41')
          FontCell = (
            0
            0
            -2147483640
            -12
            #44404#47548#52404
            0
            418022401)
        end
        object DRStrGrid_SndMail_CreateTime: TDRStringGrid
          Tag = 5
          Left = 360
          Top = 32
          Width = 570
          Height = 113
          Align = alCustom
          Color = clWhite
          ColCount = 10
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 11
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect, goThumbTracking]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          AllowFixedRowClick = True
          TopRow = 1
          LeftCol = 0
          SelectedCellColor = 16047570
          SelectedFontColor = clBlack
          ColWidths = (
            14
            51
            59
            129
            131
            54
            104
            175
            160
            72)
          AlignCol = {000002010002020002030001040001050002060001070001080001090002}
          AlignRow = {000002}
          FixedAlignRow = {000002}
          Cells = (
            0
            5
            '>'
            1
            0
            #49324#48264
            1
            1
            '975001'
            1
            5
            '975001'
            1
            6
            '975001'
            1
            7
            '975001'
            1
            8
            '975023'
            1
            9
            '975023'
            1
            10
            '975023'
            2
            0
            #49373#49457#49884#44036
            2
            1
            '11:24:00'
            2
            5
            '11:24:02'
            2
            6
            '11:24:11'
            2
            7
            '11:24:25'
            2
            8
            '11:35:57'
            2
            9
            '12:00:00'
            2
            10
            '12:01:00'
            3
            0
            #44228#51340#48264#54840'/'#44592#44288#53076#46300
            3
            1
            '99999999-98'
            3
            8
            '99999999-99'
            3
            9
            '123-45-67890'
            3
            10
            '000-00-0000'
            4
            0
            #44228#51340#47749'/'#44592#44288#47749
            4
            1
            #53580#49828#53944#44228#51340'1'
            4
            8
            #53580#49828#53944#44228#51340'2'
            4
            9
            #44144#47000#44592#44288'1'
            4
            10
            #44144#47000#44592#44288'2'
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
            8
            'E-mail'#13#10
            5
            9
            'E-mail'
            5
            10
            'Fax'
            6
            0
            #49688#49888#52376
            6
            1
            #45936#51060#53552#47196#46300
            6
            3
            #44592#44288'7'
            6
            5
            #44592#44288'1'
            6
            8
            #44592#44288'3'
            6
            9
            #44592#44288'1'
            6
            10
            #44592#44288'2'
            7
            0
            #54057#49828#48264#54840'/'#47700#51068#51228#47785
            7
            1
            '1234-5678'
            7
            3
            '2222-3333'
            7
            5
            #50504#45397#54616#49464#50836'.'
            7
            6
            #13#10
            7
            8
            #48372#44256#49436' '#48372#45253#45768#45796'.'
            7
            9
            #48372#44256#49436' '#48372#45253#45768#45796'.'
            7
            10
            '2020-2020'
            8
            0
            #48372#44256#49436#49436#49885
            8
            1
            '['#51077#44552'] MMW'#49888#44508'-'#54869#51064#49436
            8
            2
            '['#52636#44552'] RP-'#49688#51061#44552#44228#49328#49436
            8
            3
            '['#51077#44552'] MMW'#49888#44508'-'#54869#51064#49436
            8
            4
            '['#52636#44552'] RP-'#49688#51061#44552#44228#49328#49436
            8
            5
            '['#52636#44552'] RP-'#50896#52380#51669#49688#50689#49688#51613
            8
            6
            '['#52636#44552'] '#51092#44256#51613#47749#49436
            8
            7
            '['#51092#44256'] '#51092#44256#51613#47749#49436
            8
            8
            '['#44592#53440'] '#51333#54633#44228#51340#51088#49328#54788#54889
            8
            9
            '['#51092#44256'] '#51092#44256#51613#47749#49436
            8
            10
            '['#51092#44256'] '#51092#44256#51613#47749#49436
            9
            0
            #49436#48260#51204#49569
            9
            5
            #13#10
            9
            6
            '11:34:27'
            9
            7
            '11:34:27'
            9
            8
            '11:36:41')
          FontCell = (
            0
            0
            -2147483640
            -12
            #44404#47548#52404
            0
            418022401)
        end
        object DRStrGrid_SndMail_AccNo: TDRStringGrid
          Tag = 6
          Left = 416
          Top = 56
          Width = 570
          Height = 113
          Align = alCustom
          Color = clWhite
          ColCount = 10
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 11
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect, goThumbTracking]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
          AllowFixedRowClick = True
          TopRow = 1
          LeftCol = 0
          SelectedCellColor = 16047570
          SelectedFontColor = clBlack
          ColWidths = (
            14
            51
            59
            129
            131
            54
            104
            175
            160
            72)
          AlignCol = {000002010002020002030001040001050002060001070001080001090002}
          AlignRow = {000002}
          FixedAlignRow = {000002}
          Cells = (
            0
            5
            '>'
            1
            0
            #49324#48264
            1
            1
            '975001'
            1
            5
            '975001'
            1
            6
            '975001'
            1
            7
            '975001'
            1
            8
            '975023'
            1
            9
            '975023'
            1
            10
            '975023'
            2
            0
            #49373#49457#49884#44036
            2
            1
            '11:24:00'
            2
            5
            '11:24:02'
            2
            6
            '11:24:11'
            2
            7
            '11:24:25'
            2
            8
            '11:35:57'
            2
            9
            '12:00:00'
            2
            10
            '12:01:00'
            3
            0
            #44228#51340#48264#54840'/'#44592#44288#53076#46300
            3
            1
            '99999999-98'
            3
            8
            '99999999-99'
            3
            9
            '123-45-67890'
            3
            10
            '000-00-0000'
            4
            0
            #44228#51340#47749'/'#44592#44288#47749
            4
            1
            #53580#49828#53944#44228#51340'1'
            4
            8
            #53580#49828#53944#44228#51340'2'
            4
            9
            #44144#47000#44592#44288'1'
            4
            10
            #44144#47000#44592#44288'2'
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
            8
            'E-mail'#13#10
            5
            9
            'E-mail'
            5
            10
            'Fax'
            6
            0
            #49688#49888#52376
            6
            1
            #45936#51060#53552#47196#46300
            6
            3
            #44592#44288'7'
            6
            5
            #44592#44288'1'
            6
            8
            #44592#44288'3'
            6
            9
            #44592#44288'1'
            6
            10
            #44592#44288'2'
            7
            0
            #54057#49828#48264#54840'/'#47700#51068#51228#47785
            7
            1
            '1234-5678'
            7
            3
            '2222-3333'
            7
            5
            #50504#45397#54616#49464#50836'.'
            7
            6
            #13#10
            7
            8
            #48372#44256#49436' '#48372#45253#45768#45796'.'
            7
            9
            #48372#44256#49436' '#48372#45253#45768#45796'.'
            7
            10
            '2020-2020'
            8
            0
            #48372#44256#49436#49436#49885
            8
            1
            '['#51077#44552'] MMW'#49888#44508'-'#54869#51064#49436
            8
            2
            '['#52636#44552'] RP-'#49688#51061#44552#44228#49328#49436
            8
            3
            '['#51077#44552'] MMW'#49888#44508'-'#54869#51064#49436
            8
            4
            '['#52636#44552'] RP-'#49688#51061#44552#44228#49328#49436
            8
            5
            '['#52636#44552'] RP-'#50896#52380#51669#49688#50689#49688#51613
            8
            6
            '['#52636#44552'] '#51092#44256#51613#47749#49436
            8
            7
            '['#51092#44256'] '#51092#44256#51613#47749#49436
            8
            8
            '['#44592#53440'] '#51333#54633#44228#51340#51088#49328#54788#54889
            8
            9
            '['#51092#44256'] '#51092#44256#51613#47749#49436
            8
            10
            '['#51092#44256'] '#51092#44256#51613#47749#49436
            9
            0
            #49436#48260#51204#49569
            9
            5
            #13#10
            9
            6
            '11:34:27'
            9
            7
            '11:34:27'
            9
            8
            '11:36:41')
          FontCell = (
            0
            0
            -2147483640
            -12
            #44404#47548#52404
            0
            418022401)
        end
        object DRStringGrid1: TDRStringGrid
          Left = 0
          Top = 24
          Width = 1016
          Height = 353
          Align = alClient
          Color = clWhite
          ColCount = 10
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 17
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect, goThumbTracking]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 8
          AllowFixedRowClick = True
          TopRow = 1
          LeftCol = 0
          SelectedCellColor = 16047570
          SelectedFontColor = clBlack
          ColWidths = (
            14
            51
            59
            129
            131
            54
            115
            175
            252
            72)
          AlignCol = {000002010002020002030001040001050002060001070001080001090002}
          AlignRow = {000002}
          FixedAlignRow = {000002}
          Cells = (
            0
            1
            '>'
            0
            5
            '>'
            0
            6
            '>'
            0
            7
            '>'
            1
            0
            #49324#48264
            1
            1
            '975001'
            1
            8
            '975023'
            1
            9
            '975023'
            1
            12
            '123456'
            2
            0
            #49373#49457#49884#44036
            2
            1
            '11:24:00'
            2
            8
            '11:27:31'
            2
            9
            '11:30:24'
            2
            12
            '12:03:33'
            3
            0
            #44228#51340#48264#54840'/'#44592#44288#53076#46300
            3
            1
            '99999999-98'
            3
            8
            '00000000-00'
            3
            9
            '00000000-00'
            3
            12
            'AA001'
            4
            0
            #44228#51340#47749'/'#44592#44288#47749
            4
            1
            #45936#51060#53552#47196#46300'_'#44228#51340'_1'
            4
            8
            #44221#45224#51008#54665'_'#44228#51340'_1'
            4
            9
            #44221#45224#51008#54665'_'#44228#51340'_1'
            4
            12
            #45936#51060#53552#47196#46300
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
            8
            'E-mail'#13#10
            5
            9
            'FAX'
            5
            12
            'FAX'
            5
            13
            'FAX'
            5
            14
            'E-mail'
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
            8
            #51060#51221#49688';'
            6
            9
            #51060#51221#49688
            6
            12
            #51064#44592#54596
            6
            13
            #50976#44305#51652
            6
            14
            #51064#44592#54596';'#50976#44305#51652';'
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
            8
            'js@naver.com;'
            7
            9
            '9999-9999'
            7
            12
            '0000-0000'
            7
            13
            '1234-5678'
            7
            14
            'in@dr.com;yk@dr.com;'
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
            'RP'#49688#51061#44552#44228#49328#49436' RP'
            8
            6
            #51092#44256#54869#51064#49436
            8
            7
            #50896#52380#51669#49688#50689#49688#51613
            8
            8
            #51092#44256#51613#47749#49436
            8
            9
            'RP'#49688#51061#44552#44228#49328#49436' RP'
            8
            10
            #51092#44256#54869#51064#49436
            8
            11
            #50896#52380#51669#49688#50689#49688#51613
            8
            12
            #50896#52380#51669#49688#50689#49688#51613
            8
            13
            #50896#52380#51669#49688#50689#49688#51613
            8
            14
            #44552#50997#49345#54408' '#54788#44552#47588#49688' '#54869#51064#49436' '#50808#54868'RP '#49888#44508#47588#49688
            8
            15
            #44552#50997#49345#54408' '#54788#44552#47588#49688' '#54869#51064#49436' '#50808#54868'RP '#47588#46020#49888#52397
            8
            16
            #50896#52380#51669#49688#50689#49688#51613
            9
            0
            #49436#48260#51204#49569
            9
            1
            '11:33:02'
            9
            5
            '11:34:27'
            9
            6
            '11:34:27'
            9
            7
            '11:34:27')
          FontCell = (
            0
            0
            -2147483640
            -12
            #44404#47548#52404
            0
            418022401)
        end
      end
    end
  end
end
