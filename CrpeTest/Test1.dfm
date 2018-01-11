object Form1: TForm1
  Left = 1756
  Top = 218
  Width = 671
  Height = 710
  Caption = 'CrpeTest'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 663
    Height = 121
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 12
      Top = 8
      Width = 226
      Height = 16
      Caption = '< Crystal Reports Test Program>'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object GroupBox1: TGroupBox
      Left = 6
      Top = 28
      Width = 649
      Height = 85
      TabOrder = 0
      DesignSize = (
        649
        85)
      object Button4: TButton
        Left = 540
        Top = 14
        Width = 101
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Create Columns'
        TabOrder = 0
        OnClick = Button4Click
      end
      object Edit1: TEdit
        Left = 411
        Top = 17
        Width = 121
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 1
        Text = 'Edit1'
      end
      object Button3: TButton
        Left = 8
        Top = 16
        Width = 105
        Height = 25
        Caption = 'DB Conn'
        TabOrder = 2
        OnClick = Button3Click
      end
      object Button2: TButton
        Left = 120
        Top = 16
        Width = 89
        Height = 25
        Caption = 'Get Data'
        TabOrder = 3
        OnClick = Button2Click
      end
      object Button1: TButton
        Left = 120
        Top = 48
        Width = 89
        Height = 25
        Caption = 'Create Report'
        TabOrder = 4
        OnClick = Button1Click
      end
      object Button_CreateRecSet: TButton
        Left = 8
        Top = 48
        Width = 105
        Height = 25
        Caption = 'Create Record Set'
        TabOrder = 5
        OnClick = Button_CreateRecSetClick
      end
      object Button5: TButton
        Left = 232
        Top = 16
        Width = 75
        Height = 25
        Caption = 'GetDLL'
        Enabled = False
        TabOrder = 6
        OnClick = Button5Click
      end
      object Edit2: TEdit
        Left = 411
        Top = 49
        Width = 121
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 7
        Text = 'Edit1'
        Visible = False
      end
      object Button6: TButton
        Left = 540
        Top = 47
        Width = 101
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Create DataCount'
        TabOrder = 8
        Visible = False
        OnClick = Button6Click
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 121
    Width = 663
    Height = 138
    Align = alTop
    TabOrder = 1
    object InputMemo: TMemo
      Left = 1
      Top = 1
      Width = 661
      Height = 136
      Align = alClient
      Lines.Strings = (
        'WorkMemo')
      ReadOnly = True
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 259
    Width = 663
    Height = 424
    Align = alClient
    TabOrder = 2
    object OutputMemo: TMemo
      Left = 1
      Top = 1
      Width = 661
      Height = 422
      Align = alClient
      Lines.Strings = (
        'WorkMemo')
      ReadOnly = True
      TabOrder = 0
    end
  end
  object ADOConnection_TFJS: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=settlenet,.;Persist Security Info=T' +
      'rue;User ID=settlenet;Initial Catalog=TF_HANKOOK_FI;Data Source=' +
      '100.100.100.160'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 272
    Top = 371
  end
  object ADOQuery_GetData: TADOQuery
    Parameters = <>
    Left = 312
    Top = 371
  end
end
