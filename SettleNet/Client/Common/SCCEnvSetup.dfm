object Form_EnvSetup: TForm_EnvSetup
  Left = 462
  Top = 134
  ActiveControl = DREdit_PrimarySvr
  BorderStyle = bsDialog
  Caption = #54872#44221' '#49444#51221
  ClientHeight = 353
  ClientWidth = 333
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    00000000000000000000000000000008FFF00000000000000000000000000088
    7777000000000000000000000000008800770F00000000000000000000000880
    88F70FFF0000000000000000000008808880FFFFF00000000000000000000888
    000FFF8FFFF0000000000000000007888800F8088FFF00000000000000000078
    888800F0088F8800000000000000000077700FFFF00888880000000000000000
    000FFFFFFFF088800000000000000000000000FFF8880008BBBBBB8800000000
    000000000800BBBBBBBBBBBBB80000000000000000BBBBBBBBBBBBBBBBB00000
    00000000BBBBBBBBB0000BBBBBB00000000000BB87000000000BB0BBBB800000
    000000008B8BBBBBBBBBB00BB80000000000BBBBBBBBBBBBBBBBBBB000000000
    00BBBBBB0000000000BBB0BB0F000000BBBBB0008888888870BB0B0B0FF0000B
    BBB00888BBBBBBB070BB0BB00FF0000BB0088BBBBBBBBBB070BB0B700000000B
    088BBBBBBBBBBB070BB0BB00000000008BBBBBBBBBBBBB070BB0BB0000000000
    0BBBBBBBBBBBB070BB0BB7000000000008BBBBBBBBBBB070BB0BB00000000000
    008BBBBBBBBB070BB0BB0000000000000000BBBBBBB070BB0BB0000000000000
    0000088888070BB0B0000000000000000000000000BBBB000000000000000000
    00000000BBBB000000000000000000000000000000000000000000000000E07F
    FFFFC01FFFFF8007FFFF8003FFFF0000FFFF00007FFF00001FFF000007FF8000
    03FFC0000007F0000001FC000000FFC00000FFE00000FFC00000FF800000FE00
    0001F8000000F0000000E0000000C0000000C0000009C000000FC000000FF000
    001FF000003FF800007FFC0000FFFF0001FFFF8007FFFFC03FFFFFF0FFFF}
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object DRPanel_Bottom: TDRPanel
    Left = 0
    Top = 330
    Width = 333
    Height = 23
    Align = alBottom
    Alignment = taLeftJustify
    BevelOuter = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object DRPanel_Msg: TDRPanel
      Left = 4
      Top = 3
      Width = 324
      Height = 16
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Color = 14811135
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Visible = False
    end
  end
  object DRPanel1: TDRPanel
    Left = 0
    Top = 302
    Width = 333
    Height = 28
    Align = alBottom
    BevelOuter = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    DesignSize = (
      333
      28)
    object DRBitBtn_Cancel: TDRBitBtn
      Left = 266
      Top = 1
      Width = 65
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #52712#49548
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ModalResult = 2
      ParentFont = False
      TabOrder = 1
      OnClick = DRBitBtn_CancelClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333333333000033338833333333333333333F333333333333
        0000333911833333983333333388F333333F3333000033391118333911833333
        38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
        911118111118333338F3338F833338F3000033333911111111833333338F3338
        3333F8330000333333911111183333333338F333333F83330000333333311111
        8333333333338F3333383333000033333339111183333333333338F333833333
        00003333339111118333333333333833338F3333000033333911181118333333
        33338333338F333300003333911183911183333333383338F338F33300003333
        9118333911183333338F33838F338F33000033333913333391113333338FF833
        38F338F300003333333333333919333333388333338FFF830000333333333333
        3333333333333333333888330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
    object DRBitBtn_Ok: TDRBitBtn
      Left = 200
      Top = 1
      Width = 65
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #54869#51064
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548#52404
      Font.Style = []
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
      OnClick = DRBitBtn_OkClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
      BorderWidth = 3
      BorderColor = 10790052
      MouseOverColor = clNavy
    end
  end
  object DRPageControl_EnvSetup: TDRPageControl
    Left = 0
    Top = 0
    Width = 333
    Height = 302
    ActivePage = DRTabSheet_Server
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
    TabOrder = 2
    OnChange = DRPageControl_EnvSetupChange
    object DRTabSheet_Server: TDRTabSheet
      Caption = 'Server'#49444#51221
      GripAlign = gaLeft
      ImageIndex = -1
      StaticPageIndex = -1
      TabVisible = True
      OnEnter = DRTabSheet_ServerEnter
      object DRLabel1: TDRLabel
        Left = 26
        Top = 72
        Width = 84
        Height = 12
        Caption = 'Primary Server'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRLabel2: TDRLabel
        Left = 25
        Top = 104
        Width = 78
        Height = 12
        Caption = 'Backup Server'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRLabel3: TDRLabel
        Left = 25
        Top = 136
        Width = 66
        Height = 12
        Caption = #51217#49549' Server'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRLabel4: TDRLabel
        Left = 25
        Top = 168
        Width = 24
        Height = 12
        Caption = 'Port'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRLabel5: TDRLabel
        Left = 25
        Top = 200
        Width = 48
        Height = 12
        Caption = 'Time Out'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
      end
      object DRImage1: TDRImage
        Left = 44
        Top = 18
        Width = 35
        Height = 33
        Picture.Data = {
          055449636F6E0000010001002020100000000000E80200001600000028000000
          2000000040000000010004000000000080020000000000000000000000000000
          0000000000000000000080000080000000808000800000008000800080800000
          80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
          FFFFFF00000000000000000000000000000000000008FFF00000000000000000
          0000000000887777000000000000000000000000008800770F00000000000000
          00000000088088F70FFF0000000000000000000008808880FFFFF00000000000
          000000000888000FFF8FFFF0000000000000000007888800F8088FFF00000000
          000000000078888800F0088F8800000000000000000077700FFFF00888880000
          000000000000000FFFFFFFF088800000000000000000000000FFF8880008BBBB
          BB8800000000000000000800BBBBBBBBBBBBB80000000000000000BBBBBBBBBB
          BBBBBBB0000000000000BBBBBBBBB0000BBBBBB00000000000BB87000000000B
          B0BBBB800000000000008B8BBBBBBBBBB00BB80000000000BBBBBBBBBBBBBBBB
          BBB00000000000BBBBBB0000000000BBB0BB0F000000BBBBB0008888888870BB
          0B0B0FF0000BBBB00888BBBBBBB070BB0BB00FF0000BB0088BBBBBBBBBB070BB
          0B700000000B088BBBBBBBBBBB070BB0BB00000000008BBBBBBBBBBBBB070BB0
          BB00000000000BBBBBBBBBBBB070BB0BB7000000000008BBBBBBBBBBB070BB0B
          B00000000000008BBBBBBBBB070BB0BB0000000000000000BBBBBBB070BB0BB0
          0000000000000000088888070BB0B0000000000000000000000000BBBB000000
          00000000000000000000BBBB0000000000000000000000000000000000000000
          00000000E07FFFFFC01FFFFF8007FFFF8003FFFF0000FFFF00007FFF00001FFF
          000007FF800003FFC0000007F0000001FC000000FFC00000FFE00000FFC00000
          FF800000FE000001F8000000F0000000E0000000C0000000C0000009C000000F
          C000000FF000001FF000003FF800007FFC0000FFFF0001FFFF8007FFFFC03FFF
          FFF0FFFF}
      end
      object DREdit_PrimarySvr: TDREdit
        Left = 131
        Top = 67
        Width = 156
        Height = 20
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
        ParentFont = False
        TabOrder = 0
        Text = '100.100.100.5'
      end
      object DREdit_BackupSvr: TDREdit
        Left = 131
        Top = 99
        Width = 156
        Height = 20
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
        ParentFont = False
        TabOrder = 1
      end
      object DREdit_Port: TDREdit
        Left = 131
        Top = 163
        Width = 156
        Height = 20
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
        ParentFont = False
        TabOrder = 3
        Text = '3001'
      end
      object DREdit_TimeOut: TDREdit
        Left = 131
        Top = 196
        Width = 156
        Height = 20
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
        ParentFont = False
        TabOrder = 4
        Text = '60'
      end
      object DRRadioGroup_CurSvr: TDRRadioGroup
        Left = 131
        Top = 122
        Width = 158
        Height = 30
        Columns = 2
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ItemIndex = 0
        Items.Strings = (
          'Primary'
          'Backup')
        ParentFont = False
        TabOrder = 2
      end
    end
    object DRTabSheet_EnvSetup: TDRTabSheet
      Caption = #54872#44221#49444#51221
      GripAlign = gaLeft
      ImageIndex = -1
      StaticPageIndex = -1
      TabVisible = True
      OnEnter = DRTabSheet_EnvSetupEnter
      object DRGroupBox1: TDRGroupBox
        Left = 11
        Top = 16
        Width = 300
        Height = 92
        Caption = #49324#50857#51088#51221#48372
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = #44404#47548#52404
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object DRLabel6: TDRLabel
          Left = 23
          Top = 29
          Width = 48
          Height = 12
          Caption = #49324#50857#51088'ID'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentFont = False
        end
        object DRLabel7: TDRLabel
          Left = 23
          Top = 57
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
        object DREdit_OprUsrNo: TDREdit
          Left = 87
          Top = 25
          Width = 79
          Height = 20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ImeMode = imSAlpha
          ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
          MaxLength = 8
          ParentFont = False
          TabOrder = 0
        end
        object DREdit_Pswrd: TDREdit
          Left = 87
          Top = 53
          Width = 79
          Height = 20
          Color = clBtnFace
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ImeName = #54620#44397#50612'('#54620#44544') (MS-IME95)'
          MaxLength = 8
          ParentFont = False
          PasswordChar = '*'
          TabOrder = 1
        end
        object DRCheckBox_SavePswrd: TDRCheckBox
          Left = 189
          Top = 57
          Width = 97
          Height = 17
          Caption = #48708#48128#48264#54840#51200#51109
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
      end
    end
  end
end
