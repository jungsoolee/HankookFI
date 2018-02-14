unit SCFH8111;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SCCChildForm, DRDialogs, DB, ADODB, DRSpecial, StdCtrls,
  Buttons, DRAdditional, ExtCtrls, DRStandard, Grids, DRStringgrid, Mask,
  DRCodeControl;

type
  TForm_SCFH8111 = class(TForm_SCF)
    DRFramePanel1: TDRFramePanel;
    DRPanel1: TDRPanel;
    DRStrGrid_Log: TDRStringGrid;
    DRLabel1: TDRLabel;
    DRLabel2: TDRLabel;
    DRLabel3: TDRLabel;
    DRLabel4: TDRLabel;
    DRMaskEdit_OprSDate: TDRMaskEdit;
    DRMaskEdit_OprEDate: TDRMaskEdit;
    DRLabel5: TDRLabel;
    DRUserDblCodeCombo_Acc: TDRUserDblCodeCombo;
    DRUserCodeCombo_JobGB: TDRUserCodeCombo;
    DRUserCodeCombo_User: TDRUserCodeCombo;
                                     
    procedure DRBitBtn3Click(Sender: TObject);

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DREdit_KeyPress(Sender: TObject; var Key: Char);
    procedure DRUserCodeCombo_JobGBEditKeyPress(Sender: TObject;
      var Key: Char);

    // ����� ����
    function QueryLog: integer; // SZTRLOG_HIS ���� ��ȸ

    procedure ClearLogList;

    function DisplayGridLog: Boolean; // StrGrid�� Log DATA INPUT

    function RefreshAccNoCombo: boolean;
    function RefreshUserCombo: boolean;
    function RefreshJobGBCombo: boolean;

    function CheckKeyEditEmpty: boolean;

    function ThreeMonthOverCheck(pCheckDate: string): boolean;
  private
    procedure DefClearStrGrid(pStrGrid: TDRStringGrid);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_SCFH8111: TForm_SCFH8111;

implementation

uses
  SCCLib, SCCGlobalType, SCCCmuLib;
{$R *.dfm}

type
  TLogItem = record           // Log List
    Sequence    : integer;
    OprDateTime : string;     // �����Ͻ�
    OprId       : string;     // ������
    AccNo       : string;     // ���¹�ȣ
    JobGB       : string;     // �ڷᱸ��
    TrCode      : string;     // ȭ��
    TrgGB       : string;     // ����
    Comment     : string;     // ���泻��
  end;
  pTLogItem = ^TLogItem;


const
  IDX_SEQUENCE         = 0;   // ������  Col Index
  IDX_OPR_DATE_TIME    = 1;   // �����Ͻ� Col Index
  IDX_OPR_ID           = 2;   // ������ Col Index
  IDX_ACC_NO           = 3;   // ���¹�ȣ Col Index
  IDX_JOB_GB           = 4;   // �ڷᱸ�� Col Index
  IDX_TR_CODE          = 5;   // ȭ�� Col Index
  IDX_TRG_GB           = 6;   // ���� Col Index
  IDX_COMMENT          = 7;   // ���泻�� Col Index

  LOG_JOB_GB_ACC    = 'A';     // �۾����� '��������'
  LOG_JOB_GB_FAX    = 'F';     // �۾����� 'Fax'
  LOG_JOB_GB_EMAIL  = 'E';     // �۾����� 'Email'

  LOG_TRG_GB_ADD    = 'I';     // ó������ �߰�
  LOG_TRG_GB_UPDATE = 'U';     // ó������ ����
  LOG_TRG_GB_DELETE = 'D';     // ó������ ����
  LOG_TRG_GB_IMPORT = 'N';     // ó������ Import
var
  LogList     : TList;                          // Log List
  SelColIdx : Integer;                          // StrGrid ���õ� Col Index
  SelRowIdx : Integer;                          // StrGrid ���õ� Row Index

procedure TForm_SCFH8111.DefClearStrGrid(pStrGrid: TDRStringGrid);
begin
  with pStrGrid do
  begin
    Color             := gcGridBackColor;
    SelectedCellColor := gcGridSelectColor;
    RowCount := 2;
    Rows[1].Clear;
  end;  // end of with
end;

//==============================================================================
//  Clear LogList (SZTRLOG_HIS)
//==============================================================================
procedure TForm_SCFH8111.ClearLogList;
var
  I : Integer;
  LogItem : pTLogItem;
begin
  if not Assigned(LogList) then Exit;
  for I := 0 to LogList.Count -1 do
  begin
    LogItem := LogList.Items[I];
    Dispose(LogItem);
  end;
  LogList.Clear;
end;

//==============================================================================
// StrGrid�� Log DATA INPUT
//==============================================================================
function TForm_SCFH8111.DisplayGridLog: Boolean;
var
  I, K, iRow : Integer;
  LogItem : pTLogItem;
  sSequence, sOprDateTime, sOprId, sAccNo, sJobGB, sTrCode, sTrgGB, sComment : string;
begin
  Result := false;

  with DRStrGrid_Log do
  begin
    if LogList.Count <= 0 then
    begin
      RowCount := 2;
      Rows[1].Clear;
      gf_ShowMessage(MessageBar, mtInformation, 1018, ''); //�ش� ������ �����ϴ�.
      Exit;
    end;
    DefClearStrGrid(DRStrGrid_Log);

    RowCount := LogList.Count + 1;

    iRow := 0;
    sSequence    := '';
    sOprDateTime := '';
    sOprId       := '';
    sAccNo       := '';
    sJobGB       := '';
    sTrCode      := '';
    sTrgGB       := '';
    sComment     := '';


    // StrGrid Input
    for i := 0 to LogList.Count - 1 do
    begin
      LogItem := LogList.Items[i];

      Inc(iRow);
      Rows[iRow].Clear;

      sSequence    := IntToStr(LogItem.Sequence);
      sOprDateTime := LogItem.OprDateTime;
      sOprId       := LogItem.OprId;
      sAccNo       := LogItem.AccNo;
      sJobGB       := LogItem.JobGB;
      sTrCode      := LogItem.TrCode;
      sTrgGB       := LogItem.TrgGB;
      sComment     := LogItem.Comment;

      // �۾�����
      if sJobGB = LOG_JOB_GB_ACC then          // A
        sJobGB := '��������'
      else if sJobGB = LOG_JOB_GB_FAX then     // F
        sJobGB := 'Fax'
      else if sJobGB = LOG_JOB_GB_EMAIL then   // E
        sJobGB := 'Email';

      // ó������
      if sTrgGB = LOG_TRG_GB_IMPORT then       // N
        sTrgGB := 'Import'
      else if sTrgGB = LOG_TRG_GB_ADD then     // I
        sTrgGB := '�Է�'
      else if sTrgGB = LOG_TRG_GB_UPDATE then  // U
        sTrgGB := '����'
      else if sTrgGB = LOG_TRG_GB_DELETE then  // D
        sTrgGB := '����';

      // No
      Cells[IDX_SEQUENCE, iRow] := sSequence;
      // �����Ͻ�
      Cells[IDX_OPR_DATE_TIME, iRow] := sOprDateTime;
      // ������
      Cells[IDX_OPR_ID, iRow] := sOprId;
      // ���¹�ȣ
      Cells[IDX_ACC_NO, iRow] := sAccNo;
      // �ڷᱸ��
      Cells[IDX_JOB_GB, iRow] := sJobGB;
      // ȭ��
      Cells[IDX_TR_CODE, iRow] := sTrCode;
      // ����
      Cells[IDX_TRG_GB, iRow] := sTrgGB;
      // ���泻��
      Cells[IDX_COMMENT, iRow] := sComment;
      HintCell[IDX_COMMENT, iRow] := sComment;
    end;
  end;

  Result := True;
end;

//==============================================================================
// SZTRLOG_HIS ���� ��ȸ
//==============================================================================
function TForm_SCFH8111.QueryLog: integer;
var
  iSequence : integer;
  LogItem : pTLogItem;
begin
  Result := 0;
  iSequence := 0;

  ClearLogList;

  with ADOQuery_DECLN do
  begin
    // ��ü Log
    Close;
    SQL.Clear;
    SQL.Add(' SELECT L.OPR_DATE, L.OPR_TIME,                             '
          + ' L.ACC_NO, L.JOB_GB, L.TRG_GB, L.TR_CODE, L.OPR_ID, L.COMMENT,       '
          + ' TR_NAME = (SELECT DISTINCT MENU_SHRT_KOR                        '
          + '             FROM SUMENU_INS M                                   '
          + '             WHERE L.TR_CODE  = M.TR_CODE                         '
          + '             AND   M.SEC_CODE =  ''Z''       )                    '
          + ' FROM SZTRLOG_HIS L                                      '
          + ' WHERE L.DEPT_CODE = ''' + gvDeptCode + '''             '   );
    // ������ȸ
    SQL.Add('  AND L.OPR_DATE >= '''+ Trim(DRMaskEdit_OprSDate.Text) +''' '
           +'  AND L.OPR_DATE <= '''+ Trim(DRMaskEdit_OprEDate.Text) +''' ');
    // ����
    if Trim(DRUserDblCodeCombo_Acc.Code) <> '��ü' then
      SQL.Add('  AND L.ACC_NO = ''' + Trim(DRUserDblCodeCombo_Acc.Code) + ''' ');
    // ������
    if Trim(DRUserCodeCombo_User.Code) <> '��ü' then
      SQL.Add('  AND L.OPR_ID = ''' + Trim(DRUserCodeCombo_User.Code) + ''' ');
    // �ڷ�
    if Trim(DRUserCodeCombo_JobGB.Code) <> '��ü' then
    begin
      SQL.Add('  AND L.JOB_GB = ''' + Trim(DRUserCodeCombo_JobGB.Code) + ''' ');
    end;

    SQL.Add(' ORDER BY L.OPR_DATE, L.OPR_TIME, L.JOB_GB                                  ');

    Try
      gf_ADOQueryOpen(ADOQuery_DECLN);
    Except
      on E : Exception do
      begin  // DataBase ����
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZTRLOG_HIS]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZTRLOG_HIS]'); //Database ����
        Exit;
      end;
    End;


    while not Eof do
    begin
      Inc(iSequence);
      New(LogItem);
      LogList.Add(LogItem);
      LogItem.Sequence := iSequence;
      LogItem.OprDateTime := gf_FormatDate(Trim(FieldByName('OPR_DATE').asString))
                               + ' ' + gf_FormatTime(Trim(FieldByName('OPR_TIME').asString));
      LogItem.OprId := Trim(FieldByName('OPR_ID').AsString);
      LogItem.AccNo := Trim(FieldByName('ACC_NO').AsString);
      LogItem.JobGB := Trim(FieldByName('JOB_GB').AsString);
      LogItem.TrCode := Trim(FieldByName('TR_NAME').AsString);
      LogItem.TrgGB:= Trim(FieldByName('TRG_GB').AsString);
      LogItem.Comment := Trim(FieldByName('COMMENT').AsString);

      Next;
    end;  // end while

  end;

  Result := LogList.Count;
end;

//==============================================================================
// Form Create
//==============================================================================
procedure TForm_SCFH8111.FormCreate(Sender: TObject);
begin
  inherited;

  DefClearStrGrid(DRStrGrid_Log);

  // List����
  LogList := TList.Create;

  if not Assigned(LogList) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); // List ���� ����
    Close;
    Exit;
  end;

  if not RefreshAccNoCombo then exit;
  if not RefreshUserCombo then exit;
  if not RefreshJobGBCombo then exit;
end;

//==============================================================================
// Form Close
//==============================================================================
procedure TForm_SCFH8111.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if Assigned(LogList) then  // LogList Free
  begin
     ClearLogList;
     LogList.Free;
  end;
end;

//==============================================================================
// ��ȸ��ư Click
//==============================================================================
procedure TForm_SCFH8111.DRBitBtn3Click(Sender: TObject);
var
  RowCount : Integer;
begin
  inherited;
  gf_ShowMessage(MessageBar, mtInformation, 1020, ''); //��ȸ ���Դϴ�.

  if CheckKeyEditEmpty then Exit;

  DisableForm;

  RowCount := QueryLog;
  DisplayGridLog;

  if RowCount <= 0 then
     gf_ShowMessage(MessageBar, mtInformation, 1018, '') //�ش� ������ �����ϴ�.
  else
     gf_ShowMessage(MessageBar, mtInformation, 1021,
             gwQueryCnt + IntToStr(RowCount)); // ��ȸ �Ϸ�

   DRStrGrid_Log.SetFocus;
   EnableForm;
end;

//==============================================================================
// �����޺� Refresh
//==============================================================================
function TForm_SCFH8111.RefreshAccNoCombo: boolean;
begin
  Result := False;
  with ADOQuery_DECLN do
  begin
    // ����
    Close;
    SQL.Clear;
    SQL.Add(' SELECT ACC_NO, ACC_NAME_KOR                              '
          + ' FROM SZACBIF_INS                                         '
          + ' WHERE DEPT_CODE = ''' + gvDeptCode + '''                  '
          + ' ORDER BY ACC_NO                                           ');
    Try
      gf_ADOQueryOpen(ADOQuery_DECLN);
    Except
      on E : Exception do
      begin  // DataBase ����
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZACBIF_INS]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZACBIF_INS]'); //Database ����
        Exit;
      end;
    End;

    DRUserDblCodeCombo_Acc.ClearItems;
//    DRUserDblCodeCombo_Acc.InsertAllItem := false;  // ��ü �׸� X
    while not EOF do
    begin
      DRUserDblCodeCombo_Acc.AddItem(Trim(FieldByName('ACC_NO').asString),
                                 Trim(FieldByName('ACC_NAME_KOR').asString));
      Next;
    end;
  end; // end of with
  Result := True;
end;

//==============================================================================
// �ڷ��޺� Refresh
//==============================================================================
function TForm_SCFH8111.RefreshJobGBCombo: boolean;
begin
  Result := False;

  DRUserCodeCombo_JobGB.ClearItems;
//  DRUserCodeCombo_JobGB.InsertAllItem := false;  // ��ü �׸� X

  DRUserCodeCombo_JobGB.AddItem(LOG_JOB_GB_ACC, '��������');
  DRUserCodeCombo_JobGB.AddItem(LOG_JOB_GB_FAX, 'Fax');
  DRUserCodeCombo_JobGB.AddItem(LOG_JOB_GB_EMAIL, 'Email');
  Result := True;
end;

//==============================================================================
// �������޺� Refresh
//==============================================================================
function TForm_SCFH8111.RefreshUserCombo: boolean;
begin
  Result := False;
  with ADOQuery_DECLN do
  begin
    // ������
    Close;
    SQL.Clear;
    SQL.Add(' SELECT USER_ID                                              '
          + ' FROM SUUSER_TBL                                             '
          + ' WHERE DEPT_CODE = ''' + gvDeptCode + '''                  '
          + ' ORDER BY USER_ID                                           ');
    Try
      gf_ADOQueryOpen(ADOQuery_DECLN);
    Except
      on E : Exception do
      begin  // DataBase ����
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SUUSER_TBL]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SUUSER_TBL]'); //Database ����
        Exit;
      end;
    End;

    DRUserCodeCombo_User.ClearItems;
//    DRUserCodeCombo_User.InsertAllItem := false;  // ��ü �׸� X

    while not EOF do
    begin
      DRUserCodeCombo_User.AddItem(Trim(FieldByName('USER_ID').asString), Trim(FieldByName('USER_ID').asString));
      Next;
    end;
  end; // end of with
  Result := True;
end;

//==============================================================================
// Form Show
//==============================================================================
procedure TForm_SCFH8111.FormShow(Sender: TObject);
begin
  inherited;
  DRMaskEdit_OprSDate.Text := gf_GetCurDate;
  DRMaskEdit_OprEDate.Text := gf_GetCurDate;

  DRUserDblCodeCombo_Acc.AssignCode('��ü');
  DRUserCodeCombo_User.AssignCode('��ü');
  DRUserCodeCombo_JobGB.AssignCode('��ü');

  DRMaskEdit_OprSDate.SetFocus;
end;

//==============================================================================
// �ʼ��Է� �׸� ���� Ȯ��
//==============================================================================
function TForm_SCFH8111.CheckKeyEditEmpty: boolean;
begin
   Result := true;

   // ���۽����� üũ(�Է°�����)
   if Trim(DRMaskEdit_OprSDate.Text) <> '' then
   begin
      if gf_CheckValidDate(DRMaskEdit_OprSDate.Text) = False then
      begin
         gf_ShowMessage(MessageBar, mtError, 1040, '(������)'); //���� �Է� ����
         DRMaskEdit_OprSDate.SetFocus;
         Exit;
      end;
   end;
   // ���������� üũ(�Է°�����)
   if Trim(DRMaskEdit_OprEDate.Text) <> '' then
   begin
      if gf_CheckValidDate(DRMaskEdit_OprEDate.Text) = False then
      begin
         gf_ShowMessage(MessageBar, mtError, 1040, '(������)'); //���� �Է� ����
         DRMaskEdit_OprEDate.SetFocus;
         Exit;
      end;
   end;

   if (Trim(DRMaskEdit_OprSDate.Text) > Trim(DRMaskEdit_OprEDate.Text)) then
   begin
     gf_ShowMessage(MessageBar, mtError, 1040, '�������ڰ� �������ں��� �۾ƾ� �մϴ�.'); //���� �Է� ����
     DRMaskEdit_OprEDate.SetFocus;
     DRMaskEdit_OprEDate.SelectAll;
     Exit;
   end;

   if not ThreeMonthOverCheck(Trim(DRMaskEdit_OprEDate.EditText)) then
   begin
     gf_ShowMessage(MessageBar, mtError, 1040, '�ִ� 3�������� ��ȸ �����մϴ�.'); //���� �Է� ����
     DRMaskEdit_OprEDate.SetFocus;
     DRMaskEdit_OprEDate.SelectAll;
     Exit;
   end;

   // ���¹�ȣ
   if Trim(DRUserDblCodeCombo_Acc.Code) = '' then   // ����
   begin
      gf_ShowMessage(MessageBar, mtError, 1012, '����'); //�Է� ����
      DRUserDblCodeCombo_Acc.SetFocus;
      Exit;
   end;

  // ������
  if Trim(DRUserCodeCombo_User.Code) = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, '������'); //�Է� ����
    DRUserCodeCombo_User.SetFocus;
    Exit;
  end;
  // �ڷ�
  if Trim(DRUserCodeCombo_JobGB.Code) = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, '�ڷ�'); //�Է� ����
    DRUserCodeCombo_JobGB.SetFocus;
    Exit;
  end;
   Result := false;
end;

//==============================================================================
// �������ڱⰣ��ȸ Maximum 3����
//==============================================================================
function TForm_SCFH8111.ThreeMonthOverCheck(pCheckDate: string): boolean;
var
  sStartDate: string;
begin
  Result := True;
  sStartDate := gf_ReturnStrQuery('DECLARE @DateNow DATETIME         '
                                 +'SET @DateNow='''+ pCheckDate +''' '
                                 +'SELECT DATEADD(Month, -3, @DateNow)+1 AS STR');
  sStartDate := Copy(sStartDate,1,4)
              + Copy(sStartDate,6,2)
              + Copy(sStartDate,9,2);

  if Trim(DRMaskEdit_OprSDate.Text) < sStartDate then
  begin
    Result := False;
  end;
end;

//==============================================================================
// Edit Enter �Է� ��
//==============================================================================
procedure TForm_SCFH8111.DREdit_KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
   if (Key = #13) and (ActiveControl is TWinControl) then   // ���� Control�� �̵�
   begin
      gf_ClearMessage(MessageBar);
      SelectNext(ActiveControl as TWinControl, True, True);
   end;
end;

//==============================================================================
// �ڷ� Combo Enter �Է� ��
//==============================================================================
procedure TForm_SCFH8111.DRUserCodeCombo_JobGBEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
   if (Key = #13) and (ActiveControl is TWinControl) then  
   begin
      DRBitBtn3Click(Sender);   // ��ȸ
   end;
end;

end.
