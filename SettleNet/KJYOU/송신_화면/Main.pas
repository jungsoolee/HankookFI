unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, DRWin32, Grids, DRStringgrid, DRStandard, StdCtrls,
  Mask, DRAdditional, Buttons, DRSpecial, ExtCtrls, DRColorTab,
  DRCodeControl, Math, SCCDllLib;

type
  TForm1 = class(TForm)
    DRPanel1: TDRPanel;
    DRPanel3: TDRPanel;
    DRBitBtn1: TDRBitBtn;
    DRBitBtn2: TDRBitBtn;
    MessageBar: TDRMessageBar;
    DRBitBtn3: TDRBitBtn;
    DRBitBtn4: TDRBitBtn;
    DRFramePanel_Query: TDRFramePanel;
    DRLabel3: TDRLabel;
    DRLabel5: TDRLabel;
    DRMaskEdit_Date1: TDRMaskEdit;
    DRLabel1: TDRLabel;
    DRPanel6: TDRPanel;
    DRPanel2: TDRPanel;
    DRBitBtn5: TDRBitBtn;
    DRLabel6: TDRLabel;
    DRMaskEdit1: TDRMaskEdit;
    DRLabel7: TDRLabel;
    DRUserDblCodeCombo1: TDRUserDblCodeCombo;
    DRPanel7: TDRPanel;
    DRStringGrid_Tot_Sent: TDRStringGrid;
    DRPanel4: TDRPanel;
    DRLabel_SntMail: TDRLabel;
    DRSpeedBtn_SntMailRefresh: TDRSpeedButton;
    DRSpeedButton_SntMail: TDRSpeedButton;
    DRPanel5: TDRPanel;
    DRRadioBtn_EmailSend: TDRRadioButton;
    DRRadioBtn_EmailError: TDRRadioButton;
    DRRadioBtn_EmailAll: TDRRadioButton;
    DRRadioButton1: TDRRadioButton;
    DRRadioButton2: TDRRadioButton;
    DRRadioButton3: TDRRadioButton;
    DRUserDblCodeCombo2: TDRUserDblCodeCombo;
    DRPanel8: TDRPanel;
    DRPanel_SndMailTitle: TDRPanel;
    DRLabel_SndMail: TDRLabel;
    DRSpeedBtn_SndMailDir: TDRSpeedButton;
    DRSpeedBtn_Export: TDRSpeedButton;
    DRSpeedBtn_SndMailRefresh: TDRSpeedButton;
    DRSpeedButton_SndMail: TDRSpeedButton;
    DRRadioButton4: TDRRadioButton;
    DRRadioButton5: TDRRadioButton;
    DRRadioButton6: TDRRadioButton;
    DRCheckBox1: TDRCheckBox;
    DRRadioButton7: TDRRadioButton;
    DRStringGrid_Tot_Send: TDRStringGrid;
    DRStringGrid1: TDRStringGrid;
    DRStringGrid2: TDRStringGrid;
    DRStringGrid3: TDRStringGrid;
    DRStringGrid4: TDRStringGrid;
    DRStringGrid5: TDRStringGrid;
    DRStringGrid6: TDRStringGrid;
    DRStringGrid7: TDRStringGrid;
    DRStringGrid8: TDRStringGrid;
    DRStringGrid9: TDRStringGrid;
    DRStringGrid11: TDRStringGrid;
    DRSplitter1: TDRSplitter;
    DRBitBtn6: TDRBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure DRStringGrid_Tot_SendDrawCell(Sender: TObject; ACol,
      ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure DRStringGrid_Tot_SentDrawCell(Sender: TObject; ACol,
      ARow: Integer; Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
    procedure InitSendStrGrid(pDRStrGrid: TDRStringGrid);
    procedure InitSentStrGrid(pDRStrGrid: TDRStringGrid);
    procedure SetStrGrid(pDRStrGrid: TDRStringGrid; pTag: Integer);
  public
    { Public declarations }
  end;

  TMyGrid = class(TDRStringGrid)
  public
    procedure DeleteRow(i: Integer); overload;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  // ���
  begin
    DRUserDblCodeCombo1.AddItem('��ü', '��ü');
    DRUserDblCodeCombo1.AddItem('975001', '���缺');
    DRUserDblCodeCombo1.AddItem('975023', 'ȯ����');
    DRUserDblCodeCombo1.AddItem('000000', '�̼���');
    DRUserDblCodeCombo1.AddItem('123456', '������');

    DRUserDblCodeCombo1.AssignCode('��ü');
  end;

  //���¹�ȣ
  begin
    DRUserDblCodeCombo2.AddItem('��ü', '��ü');
    DRUserDblCodeCombo2.AddItem('12345678', '�����ͷε�_����_1');
    DRUserDblCodeCombo2.AddItem('00000000', '�泲����_����');
    DRUserDblCodeCombo2.AddItem('99999999', '�����ͷε�_���');
    DRUserDblCodeCombo2.AddItem('88888888', '��������_����');

    DRUserDblCodeCombo2.AssignCode('��ü');
  end;

  // ����
  DRMaskEdit_Date1.EditText:= FormatDateTime('YYYY-MM-DD', Now());

  // �����ð�
  DRMaskEdit1.EditText := '00:00';


  // ��ü StringGrid�� ����
  // ���۴��
  begin
    for i:= 0 to DRPanel8.ControlCount-1 do
    begin
      if DRPanel8.Controls[i] is TDRStringGrid then
      begin
        InitSendStrGrid(TDRStringGrid(DRPanel8.Controls[i]));
        SetStrGrid(TDRStringGrid(DRPanel8.Controls[i]), TDRStringGrid(DRPanel8.Controls[i]).Tag);
        TDRStringGrid(DRPanel8.Controls[i]).Align := alClient;
        TDRStringGrid(DRPanel8.Controls[i]).Visible := True;
        if TDRStringGrid(DRPanel8.Controls[i]).Tag <> 0 then
          TDRStringGrid(DRPanel8.Controls[i]).Visible := False
          ;
      end;
    end;
  end;

  // ��ü StringGrid�� ����
  // ���� �۽� Ȯ��
  begin
    for i:= 0 to DRPanel7.ControlCount-1 do
    begin
      if DRPanel7.Controls[i] is TDRStringGrid then
      begin
        InitSentStrGrid(TDRStringGrid(DRPanel7.Controls[i]));
        TDRStringGrid(DRPanel7.Controls[i]).Align := alClient;
        TDRStringGrid(DRPanel7.Controls[i]).Visible := True;
        if TDRStringGrid(DRPanel7.Controls[i]).Tag <> 0 then
          TDRStringGrid(DRPanel7.Controls[i]).Visible := False;
      end;
    end;
  end;

end;

procedure TForm1.InitSendStrGrid(pDRStrGrid: TDRStringGrid);
var
  i: integer;
begin
  with pDRStrGrid do
  begin
    for i:= 1 to 36 do
    begin
      Rows[i].Clear;
    end;

    Cells[1, 1]  := '975001';
    Cells[1, 16] := '975023';
    Cells[1, 18] := '975023';
    Cells[1, 22] := '123456';
    Cells[1, 35] := '123456';

    Cells[2, 1]  := '11:24:00';
    Cells[2, 16] := '11:27:31';
    Cells[2, 18] := '11:30:24';
    Cells[2, 22] := '12:00:03';
    Cells[2, 35] := '13:13:13';

    Cells[3, 1]   := '12345678';
    Cells[3, 7]   := '12345678-12';
    Cells[3, 13]  := '12345678-12-1234';
    Cells[3, 16]  := '00000000-00';
    Cells[3, 18]  := '00000000-00';
    Cells[3, 22]  := '99999999-99-9999';
    Cells[3, 34]  := '77777777';
    Cells[3, 35]  := '88888888';

    Cells[4, 1]   := '�����ͷε�_����_1';
    Cells[4, 7]   := '�����ͷε�_����_12';
    Cells[4, 13]  := '�����ͷε�_����_1234';
    Cells[4, 16]  := '�泲����_����_1';
    Cells[4, 18]  := '�泲����_����_1';
    Cells[4, 22]  := '�����ͷε�_���_9999';
    Cells[4, 34]  := '��������_����';
    Cells[4, 35]  := '��������_����';

    Cells[5, 1]   := 'FAX';
    Cells[5, 3]   := 'FAX';
    Cells[5, 5]   := 'E-mail';
    Cells[5, 7]   := 'FAX';
    Cells[5, 9]   := 'FAX';
    Cells[5, 11]  := 'E-mail';
    Cells[5, 13]  := 'FAX';
    Cells[5, 14]  := 'FAX';
    Cells[5, 15]  := 'E-mail';
    Cells[5, 16]  := 'FAX';
    Cells[5, 17]  := 'E-mail';
    Cells[5, 18]  := 'FAX';
    Cells[5, 20]  := 'E-mail';
    Cells[5, 22]  := 'FAX';
    Cells[5, 31]  := 'E-mail';
    Cells[5, 34]  := 'E-mail';
    Cells[5, 35]  := '�̵��';

    Cells[6, 1]   := '�α���';
    Cells[6, 3]   := '������';
    Cells[6, 5]   := '�α���;������;';
    Cells[6, 7]   := '�α���';
    Cells[6, 9]   := '������';
    Cells[6, 11]  := '�α���;������;';
    Cells[6, 13]  := '�α���';
    Cells[6, 14]  := '������';
    Cells[6, 15]  := '�α���;������;';
    Cells[6, 16]  := '������';
    Cells[6, 17]  := '������;';
    Cells[6, 18]  := '������';
    Cells[6, 20]  := '������;';
    Cells[6, 22]  := '�α���';
    Cells[6, 25]  := '������';
    Cells[6, 28]  := '������';
    Cells[6, 31]  := '�α���;������;������;';
    Cells[6, 34]  := 'ȫ�浿;';


    Cells[6, 35]  := '�̵��';

    Cells[7, 1]   := '0000-0000';
    Cells[7, 3]   := '1234-5678';
    Cells[7, 5]   := 'in@dr.com;yk@dr.com;';
    Cells[7, 7]   := '0000-0000';
    Cells[7, 9]   := '1234-5678';
    Cells[7, 11]  := 'in@dr.com;yk@dr.com;';
    Cells[7, 13]  := '0000-0000';
    Cells[7, 14]  := '1234-5678';
    Cells[7, 15]  := 'in@dr.com;yk@dr.com;';
    Cells[7, 16]  := '9999-9999';
    Cells[7, 17]  := 'js@naver.com;';
    Cells[7, 18]  := '9999-9999';
    Cells[7, 20]  := 'js@naver.com;';
    Cells[7, 22]  := '0000-0000';
    Cells[7, 25]  := '1234-5678';
    Cells[7, 28]  := '9999-9999';
    Cells[7, 31]  := 'in@dr.com;yk@dr.com;@js@naver.com;';
    Cells[7, 34]  := 'gd@god.com;';
    Cells[7, 35]  := '�̵��';

    Cells[8, 1]   := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �űԸż�';
    Cells[8, 2]   := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �ŵ���û';
    Cells[8, 3]   := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �űԸż�';
    Cells[8, 4]   := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �ŵ���û';
    Cells[8, 5]   := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �űԸż�';
    Cells[8, 6]   := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �ŵ���û';
    Cells[8, 7]   := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �ŵ���û';
    Cells[8, 8]   := '��õ¡��������';
    Cells[8, 9]   := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �ŵ���û';
    Cells[8, 10]  := '��õ¡��������';
    Cells[8, 11]  := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �ŵ���û';
    Cells[8, 12]  := '��õ¡��������';
    Cells[8, 13]  := '�ܰ�����';
    Cells[8, 14]  := '�ܰ�����';
    Cells[8, 15]  := '�ܰ�����';
    Cells[8, 16]  := '�ܰ�����';
    Cells[8, 17]  := '�ܰ�����';
    Cells[8, 18]  := 'RP���ͱݰ�꼭 RP';
    Cells[8, 19]  := '��õ¡��������';
    Cells[8, 20]  := 'RP���ͱݰ�꼭 RP';
    Cells[8, 21]  := '��õ¡��������';
    Cells[8, 22]  := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �ŵ���û';
    Cells[8, 23]  := 'RP���ͱݰ�꼭 RP';
    Cells[8, 24]  := '��õ¡��������';
    Cells[8, 25]  := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �ŵ���û';
    Cells[8, 26]  := 'RP���ͱݰ�꼭 RP';
    Cells[8, 27]  := '��õ¡��������';
    Cells[8, 28]  := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �ŵ���û';
    Cells[8, 29]  := 'RP���ͱݰ�꼭 RP';
    Cells[8, 30]  := '��õ¡��������';
    Cells[8, 31]  := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �ŵ���û';
    Cells[8, 32]  := 'RP���ͱݰ�꼭 RP';
    Cells[8, 33]  := '��õ¡��������';
    Cells[8, 34]  := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �űԸż�';
    Cells[8, 35]  := '�ܰ�����';
    Cells[8, 36]  := '��õ¡��������';

    Cells[9, 1]   := '11:25:12';
    Cells[9, 2]   := '11:25:12';
    Cells[9, 3]   := '11:25:12';
    Cells[9, 4]   := '11:25:12';
    Cells[9, 5]   := '11:25:12';
    Cells[9, 6]   := '11:25:12';
    Cells[9, 7]   := '11:25:12';
    Cells[9, 8]   := '11:25:12';
    Cells[9, 9]   := '11:25:12';
    Cells[9, 10]  := '11:25:12';
    Cells[9, 11]  := '11:25:12';
    Cells[9, 12]  := '11:25:12';
    Cells[9, 13]  := '11:25:12';
    Cells[9, 14]  := '11:25:12';
    Cells[9, 15]  := '11:25:12';
    Cells[9, 16]  := '11:28:44';
    Cells[9, 17]  := '11:28:44';
    Cells[9, 20]  := '11:28:44';
  end;
end;

procedure TForm1.SetStrGrid(pDRStrGrid: TDRStringGrid; pTag: Integer);
var
  i: Integer;
begin

  case pTag of
    // ���
    1: begin
      for i:= 1 to 21 do
      begin
        TMyGrid(pDRStrGrid).DeleteRow(16);
      end;
    end;

    // �����ð�
    2: begin
      for i:= 1 to 21 do
      begin
        TMyGrid(pDRStrGrid).DeleteRow(1);
      end;
    end;

    // ���¹�ȣ
    3: begin
      for i:= 1 to 21 do
      begin
        TMyGrid(pDRStrGrid).DeleteRow(16);
      end;
    end;

    // ���� ���͸� - 1
    4: begin
      for i:= 1 to 17 do
      begin
        TMyGrid(pDRStrGrid).DeleteRow(1);
      end;

      for i:= 1 to 15 do
      begin
        TMyGrid(pDRStrGrid).DeleteRow(5);
      end;
    end;

    // ������ ������ - StringGrid ���� �������Ϻ��� �ؾ� ��
    5: begin
//      for i:= 1 to 17 do
//      begin
//        TMyGrid(pDRStrGrid).DeleteRow(1);
//      end;
    end;

    // �ѽ� ���͸� - StringGrid ���� �������Ϻ��� �ؾ� ��
    6: begin
//      for i:= 1 to 21 do
//      begin
//        TMyGrid(pDRStrGrid).DeleteRow(16);
//      end;
    end;

    // �̸��� ���͸� - StringGrid ���� �������Ϻ��� �ؾ� ��
    7: begin
//      for i:= 1 to 17 do
//      begin
//        TMyGrid(pDRStrGrid).DeleteRow(1);
//      end;
    end;

    // �̵�� ���͸�
    8: begin
      for i:= 1 to 34 do
      begin
        TMyGrid(pDRStrGrid).DeleteRow(1);
      end;
    end;

    // ���� ���͸� - 1
    9: begin
      for i:= 1 to 17 do
      begin
        TMyGrid(pDRStrGrid).DeleteRow(1);
      end;

      for i:= 1 to 15 do
      begin
        TMyGrid(pDRStrGrid).DeleteRow(5);
      end;

      for i:= 1 to 2 do
      begin
        TMyGrid(pDRStrGrid).DeleteRow(1);
      end;
    end;
  end;
end;

{ TMyGrid }

procedure TMyGrid.DeleteRow(i: Integer);
begin
  inherited DeleteRow(i);
end;

procedure TForm1.DRStringGrid_Tot_SendDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if (ACol = 5) or (ACol = 6) or (ACol = 7) then
  begin
    if ARow = 35 then
    begin
      TDRStringGrid(Sender).Canvas.Font.Color := clRed;
      TDRStringGrid(Sender).Canvas.FillRect(Rect);
      TDRStringGrid(Sender).Canvas.TextOut(Rect.Left+1, Rect.Top+2, TDRStringGrid(Sender).Cells[ACol, ARow]);
    end;
  end;
end;

procedure TForm1.InitSentStrGrid(pDRStrGrid: TDRStringGrid);
var
  i: integer;
begin
  with pDRStrGrid do
  begin
    for i:= 1 to 19 do
    begin
      Rows[i].Clear;
    end;

    Cells[1,  1] := '975001';
    Cells[1, 16] := '975023';

    Cells[2,  1] := '12345678';
    Cells[2,  7] := '12345678-12';
    Cells[2, 13] := '12345678-12-1234';
    Cells[2, 16] := '00000000-00';

    Cells[3,  1] := '�����ͷε�_����_1';
    Cells[3,  7] := '�����ͷε�_����_12';
    Cells[3, 13] := '�����ͷε�_����_1234';
    Cells[3, 16] := '�泲����_����_1';

    Cells[4,  1] := 'FAX';
    Cells[4,  3] := 'FAX';
    Cells[4,  5] := 'E-mail';
    Cells[4,  7] := 'FAX';
    Cells[4,  9] := 'FAX';
    Cells[4, 11] := 'E-mail';
    Cells[4, 13] := 'FAX';
    Cells[4, 14] := 'FAX';
    Cells[4, 15] := 'E-mail';
    Cells[4, 16] := 'FAX';
    Cells[4, 17] := 'E-mail';

    Cells[5,  1] := '�α���';
    Cells[5,  3] := '������';
    Cells[5,  5] := '�α���;������;';
    Cells[5,  7] := '�α���';
    Cells[5,  9] := '������';
    Cells[5, 11] := '�α���;������;';
    Cells[5, 13] := '�α���';
    Cells[5, 14] := '������';
    Cells[5, 15] := '�α���;������;';
    Cells[5, 16] := '������';
    Cells[5, 17] := '������';

    Cells[6,  1] := '0000-0000';
    Cells[6,  3] := '1234-5678';
    Cells[6,  5] := 'in@dr.com;yk@dr.com;';
    Cells[6,  7] := '0000-0000';
    Cells[6,  9] := '1234-5678';
    Cells[6, 11] := 'in@dr.com;yk@dr.com;';
    Cells[6, 13] := '0000-0000';
    Cells[6, 14] := '1234-5678';
    Cells[6, 15] := 'in@dr.com;yk@dr.com;';
    Cells[6, 16] := '9999-9999';
    Cells[6, 17] := 'js@naver.com;';

    Cells[7,  1] := '1';
    Cells[7,  2] := '2';
    Cells[7,  3] := '1';
    Cells[7,  4] := '2';
    Cells[7,  5] := '1';
    Cells[7,  6] := '2';
    Cells[7,  7] := '1';
    Cells[7,  8] := '2';
    Cells[7,  9] := '1';
    Cells[7, 10] := '2';
    Cells[7, 11] := '1';
    Cells[7, 12] := '2';
    Cells[7, 13] := '1';
    Cells[7, 14] := '1';
    Cells[7, 15] := '1';
    Cells[7, 16] := '1';
    Cells[7, 17] := '1';
    Cells[7, 18] := '2';

    Cells[8,  1] := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �űԸż�';
    Cells[8,  2] := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �ŵ���û';
    Cells[8,  3] := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �űԸż�';
    Cells[8,  4] := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �ŵ���û';
    Cells[8,  5] := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �űԸż�';
    Cells[8,  6] := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �ŵ���û';
    Cells[8,  7] := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �ŵ���û';
    Cells[8,  8] := '��õ¡��������';
    Cells[8,  9] := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �ŵ���û';
    Cells[8, 10] := '��õ¡��������';
    Cells[8, 11] := '������ǰ ���ݸż� Ȯ�μ� ��ȭRP �ŵ���û';
    Cells[8, 12] := '��õ¡��������';
    Cells[8, 13] := '�ܰ�����';
    Cells[8, 14] := '�ܰ�����';
    Cells[8, 15] := '�ܰ�����';
    Cells[8, 16] := '�ܰ�����';
    Cells[8, 17] := '�ܰ�����';
    Cells[8, 18] := 'RP���ͱݰ�꼭 RP';

    Cells[9,  1] := '11:25:12';
    Cells[9,  2] := '11:25:12';
    Cells[9,  3] := '11:25:12';
    Cells[9,  4] := '11:25:12';
    Cells[9,  5] := '11:25:12';
    Cells[9,  6] := '11:25:12';
    Cells[9,  7] := '11:25:12';
    Cells[9,  8] := '11:25:12';
    Cells[9,  9] := '11:25:12';
    Cells[9, 10] := '11:25:12';
    Cells[9, 11] := '11:25:12';
    Cells[9, 12] := '11:25:12';
    Cells[9, 13] := '11:25:12';
    Cells[9, 14] := '11:25:12';
    Cells[9, 15] := '11:25:12';
    Cells[9, 16] := '11:28:44';
    Cells[9, 17] := '11:28:44';
    Cells[9, 18] := '11:28:44';

    Cells[10,  1] := '11:26:01';
    Cells[10,  2] := '12:01:23';
    Cells[10,  3] := '11:25:40';
    Cells[10,  5] := '11:25:12';
    Cells[10,  6] := '11:25:12';
    Cells[10, 11] := '11:25:12';
    Cells[10, 12] := '11:25:12';
    Cells[10, 14] := '11:26:01';
    Cells[10, 15] := '11:25:12';
    Cells[10, 17] := '11:28:44';
    Cells[10, 18] := '11:28:44';

    Cells[11,  2] := '50';
    Cells[11, 13] := '100';

    Cells[12,  1] := 'FINISH';
    Cells[12,  2] := 'FINISH';
    Cells[12,  3] := 'FINISH';
    Cells[12,  4] := 'Sending..';
    Cells[12,  5] := 'FINISH';
    Cells[12,  6] := 'FINISH';
    Cells[12,  7] := 'Sending..';
    Cells[12,  8] := 'Wating..';
    Cells[12,  9] := 'Sending..';
    Cells[12, 10] := 'Sending..';
    Cells[12, 11] := 'FINISH';
    Cells[12, 12] := 'FINISH';
    Cells[12, 13] := 'ERROR';
    Cells[12, 14] := 'FINISH';
    Cells[12, 15] := 'FINISH';
    Cells[12, 16] := 'Sending..';
    Cells[12, 17] := 'FINISH';
    Cells[12, 18] := 'FINISH';

    Cells[13,  1] := '1/1';
    Cells[13,  2] := '2/2';
    Cells[13,  3] := '1/1';
    Cells[13,  4] := '1/2';
    Cells[13,  5] := '-';
    Cells[13,  6] := '-';
    Cells[13,  7] := '2/3';
    Cells[13,  9] := '1/4';
    Cells[13, 10] := '1/2';
    Cells[13, 11] := '-';
    Cells[13, 12] := '-';
    Cells[13, 13] := '-';
    Cells[13, 14] := '1/1';
    Cells[13, 15] := '-';
    Cells[13, 16] := '1/3';
    Cells[13, 17] := '-';
    Cells[13, 18] := '-';

    ColWidths[7] := -1;
  end;
end;

procedure TForm1.DRStringGrid_Tot_SentDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  iTemp: Integer;
begin
  if (ACol = 12) then
  begin
    if (ARow <> 0) then
    begin
      if Pos('F', Trim(TDRStringGrid(Sender).Cells[Acol, ARow])) > 0 then
      begin
        iTemp  := (Sender as TDRStringGrid).Canvas.TextWidth(Trim(TDRStringGrid(Sender).Cells[Acol, ARow]));
        TDRStringGrid(Sender).Canvas.Font.Color := clBlue;
        TDRStringGrid(Sender).Canvas.FillRect(Rect);
        TDRStringGrid(Sender).Canvas.TextOut(Rect.Left + Round(iTemp/2), Rect.Top+2, TDRStringGrid(Sender).Cells[ACol, ARow]);
      end else if Pos('S', Trim(TDRStringGrid(Sender).Cells[Acol, ARow])) > 0 then
      begin
        iTemp  := (Sender as TDRStringGrid).Canvas.TextWidth(Trim(TDRStringGrid(Sender).Cells[Acol, ARow]));
        TDRStringGrid(Sender).Canvas.Font.Color := $3399FF;
        TDRStringGrid(Sender).Canvas.FillRect(Rect);
        TDRStringGrid(Sender).Canvas.TextOut(Rect.Left + Round(iTemp/5), Rect.Top+2, TDRStringGrid(Sender).Cells[ACol, ARow]);
      end else if Pos('W', Trim(TDRStringGrid(Sender).Cells[Acol, ARow])) > 0 then
      begin
        iTemp  := (Sender as TDRStringGrid).Canvas.TextWidth(Trim(TDRStringGrid(Sender).Cells[Acol, ARow]));
        TDRStringGrid(Sender).Canvas.Font.Color := $669900;
        TDRStringGrid(Sender).Canvas.FillRect(Rect);
        TDRStringGrid(Sender).Canvas.TextOut(Rect.Left + Round(iTemp/4), Rect.Top+2, TDRStringGrid(Sender).Cells[ACol, ARow]);
      end else if Pos('E', Trim(TDRStringGrid(Sender).Cells[Acol, ARow])) > 0 then
      begin
        iTemp  := (Sender as TDRStringGrid).Canvas.TextWidth(Trim(TDRStringGrid(Sender).Cells[Acol, ARow]));
        TDRStringGrid(Sender).Canvas.Font.Color := clRed;
        TDRStringGrid(Sender).Canvas.FillRect(Rect);
        TDRStringGrid(Sender).Canvas.TextOut(Rect.Left + Round(iTemp/1.5), Rect.Top+2, TDRStringGrid(Sender).Cells[ACol, ARow]);
      end;
    end;
  end;
end;

end.
