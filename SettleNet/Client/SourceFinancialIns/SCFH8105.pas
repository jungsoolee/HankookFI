unit SCFH8105;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SCCChildForm, DRDialogs, DB, ADODB, DRSpecial, StdCtrls,
  Buttons, DRAdditional, ExtCtrls, DRStandard, DRCodeControl, Grids,
  DRStringgrid, DrStringPrintU, StrUtils;

type
  TForm_SCFH8105 = class(TForm_SCF)
    DRPanel1: TDRPanel;
    DRPanel2: TDRPanel;
    DRPanel3: TDRPanel;
    DRLabel1: TDRLabel;
    DRUserDblCodeCombo_AccNo: TDRUserDblCodeCombo;
    DRLabel2: TDRLabel;
    DRLabel3: TDRLabel;
    DRLabel4: TDRLabel;
    DRLabel5: TDRLabel;
    DRLabel6: TDRLabel;
    DRLabel7: TDRLabel;
    DRRadioGroup_SndType: TDRRadioGroup;
    DREdit_FaxEmail: TDREdit;
    DREdit_Name: TDREdit;
    DREdit_Phone: TDREdit;
    DREdit_ImportTime: TDREdit;
    DREdit_ImportID: TDREdit;
    DREdit_MgrOprTime: TDREdit;
    DREdit_MgrOprID: TDREdit;
    DRStrGrid_FaxEmail: TDRStringGrid;
    DrStringPrint1: TDrStringPrint;
    ADOQuery_Log: TADOQuery;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
                                                                  
    procedure DRBitBtn2Click(Sender: TObject);
    procedure DRBitBtn3Click(Sender: TObject);
    procedure DRBitBtn4Click(Sender: TObject);
    procedure DRBitBtn5Click(Sender: TObject);
    procedure DRBitBtn6Click(Sender: TObject);

    procedure DRStrGrid_FaxEmailSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure DRStrGrid_FaxEmailDblClick(Sender: TObject);
    procedure DRRadioGroup_SndTypeClick(Sender: TObject);

    procedure DREdit_PhoneKeyPress(Sender: TObject; var Key: Char);
    procedure DREdit_KeyPress(Sender: TObject; var Key: Char);


    // ����� ����
    function QueryFax(pAccNo : string): integer; // ���¹�ȣ�� �ش��ϴ� Fax ���� ��ȸ
    function QueryEmail(pAccNo : string): integer; // ���¹�ȣ�� �ش��ϴ� Email ���� ��ȸ

    procedure ClearFaxList;
    procedure ClearEmailList;

    procedure ClearInputEdit;

    function RefreshAccNoCombo: boolean;

    function DisplayGridFaxEmail: Boolean;  // StrGrid�� Fax, Email DATA INPUT

    function DisplayToEdit_Fax(pAccNo, pMediaNo: string): boolean;
    function DisplayToEdit_Email(pAccNo, pMailAddr: string): boolean;

    function DataInsert_Fax: boolean;
    function DataUpdate_Fax: boolean;
    function DataDelete_Fax: boolean;
                                       
    function DataInsert_Email: boolean;
    function DataUpdate_Email: boolean;
    function DataDelete_Email: boolean;

    procedure MoveInsertData_Fax;
    procedure MoveInsertData_Email;

    procedure MoveUpdateData;

    function FaxNoChk(pAccNo, pMediaNo: string): boolean;
    function EmailNoChk(pAccNo, pMailAddr: string): boolean;

    function UpdateDel_FaxNoChk(pAccNo, pMediaNo: string): boolean;
    function UpdateDel_EmailNoChk(pAccNo, pMailAddr: string): boolean;


    procedure DRUserDblCodeCombo_AccNoCodeChange(Sender: TObject);

    function CheckKeyEditEmpty: boolean;

    function SelectGridData_FaxEmail(pFaxEmail: string): Integer;
    procedure DREdit_FaxEmailKeyPress(Sender: TObject; var Key: Char);
    procedure DRUserDblCodeCombo_AccNoEditKeyPress(Sender: TObject;
      var Key: Char);

    function InsertLog(pTRGGB:string; pLOGGB: string; pOriginRcvNameKor:string = ''; pCurRcvNameKor: string = '';
                       pOriginTelNo:string = ''; pCurTelNo: string = ''         ): boolean;                    // SZTRLOG_HIS�� INSERT�ϴ� �Լ�
    procedure MoveInsertData_Log(pTRGGB, pLOGGB: string);                                                              // �Է¹�ư ������ �� SZTRLOG_HIS�� �ִ��Լ�
    procedure MoveUpdateData_Log(pTRGGB, pLOGGB, pOriginRcvNameKor, pCurRcvNameKor, pOriginTelNo, pCurTelNo:string);   // ������ư ������ �� SZTRLOG_HIS�� �ִ��Լ�
    procedure MoveDeleteData_Log(pTRGGB, pLOGGB: string);                                                              // ������ư ������ �� SZTRLOG_HIS�� �ִ��Լ�
  private
    procedure DefClearStrGrid(pStrGrid: TDRStringGrid);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_SCFH8105: TForm_SCFH8105;

implementation

uses
  SCCLib, SCCGlobalType, SCCCmuLib;
{$R *.dfm}

type
  TFaxItem = record           // Fax List
    AccNo       : string;     // ���¹�ȣ
    SendType    : string;     // ���۱���
    MediaNo     : string;     // �ѽ���ȣ
    RcvNameKor  : string;     // �����
    TelNo       : string;     // ��ȭ��ȣ
  end;
  pTFaxItem = ^TFaxItem;

  TEmailItem = record         // Email List
    AccNo       : string;     // ���¹�ȣ
    SendType    : string;     // ���۱���
    MailAddr    : string;     // �����ּ�
    RcvNameKor  : string;     // �����
    TelNo       : string;     // ��ȭ��ȣ
  end;
  pTEmailItem = ^TEmailItem;

const
  IDX_SEND_TYPE    = 0;   // ���۱���  Col Index
  IDX_FAX_EMAIL    = 1;   // Fax | Email Col Index
  IDX_RCV_NAME_KOR = 2;   // ����� Col Index
  IDX_TEL_NO       = 3;   // ��ȭ��ȣ Col Index

  SEND_TYPE_FAX = 'Fax';       // Fax Col
  SEND_TYPE_EMAIL ='Email';    // Email Col

  RADIO_SEND_TYPE_FAX   = 0;  // Radio Index Fax
  RADIO_SEND_TYPE_EMAIL = 1;  // Radio Index Email

  LOG_JOB_GB_FAX    = 'F';     // �۾����� 'Fax'
  LOG_JOB_GB_EMAIL  = 'E';     // �۾����� 'Email'
  LOG_TRG_GB_ADD    = 'I';     // �Է½� SZTRLOG_HIS ���̺� TRG_GB
  LOG_TRG_GB_UPDATE = 'U';     // ������ SZTRLOG_HIS ���̺� TRG_GB
  LOG_TRG_GB_DELETE = 'D';     // ������ SZTRLOG_HIS ���̺� TRG_GB
var
  FaxList     : TList;                          // Fax List
  EmailList   : TList;                        // Email List
  SelColIdx : Integer;                          // StrGrid ���õ� Col Index
  SelRowIdx : Integer;                          // StrGrid ���õ� Row Index


procedure TForm_SCFH8105.DefClearStrGrid(pStrGrid: TDRStringGrid);
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
//  Clear EmailList (�̸���)
//==============================================================================
procedure TForm_SCFH8105.ClearEmailList;
var
  I : Integer;
  EmailItem : pTEmailItem;
begin
  if not Assigned(EmailList) then Exit;
  for I := 0 to EmailList.Count -1 do
  begin
    EmailItem := EmailList.Items[I];
    Dispose(EmailItem);
  end;
  EmailList.Clear;
end;

//==============================================================================
//  Clear FaxList (�ѽ�)
//==============================================================================
procedure TForm_SCFH8105.ClearFaxList;
var
  I : Integer;
  FaxItem : pTFaxItem;
begin
  if not Assigned(FaxList) then Exit;
  for I := 0 to FaxList.Count -1 do
  begin
    FaxItem := FaxList.Items[I];
    Dispose(FaxItem);
  end;
  FaxList.Clear;
end;

//==============================================================================
//  Edit Clear
//==============================================================================
procedure TForm_SCFH8105.ClearInputEdit;
begin
  DREdit_FaxEmail.Clear;
  DREdit_Name.Clear;
  DREdit_Phone.Clear;
  DREdit_ImportID.Clear;
  DREdit_ImportTime.Clear;
  DREdit_MgrOprID.Clear;
  DREdit_MgrOprTime.Clear;
end;

//==============================================================================
// Form Create
//==============================================================================
procedure TForm_SCFH8105.FormCreate(Sender: TObject);
begin
  inherited;

  DefClearStrGrid(DRStrGrid_FaxEmail);

  // List����
  FaxList      := TList.Create;
  EmailList    := TList.Create;

  if (not Assigned(FaxList)) or (not Assigned(EmailList)) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); // List ���� ����
    Close;
    Exit;
  end;

  if not RefreshAccNoCombo then Exit;

  // �ʼ��Է� Edit
  DRUserDblCodeCombo_AccNo.EditColor := gcQueryEditColor;
  DREdit_FaxEmail.Color              := gcQueryEditColor;

end;

//==============================================================================
// ���¹�ȣ�� �ش��ϴ� Email Query
//==============================================================================
function TForm_SCFH8105.QueryEmail(pAccNo: string): integer;
var
  EmailItem : pTEmailItem;
begin
  Result := 0;

  ClearEmailList;

  with ADOQuery_DECLN do
  begin
    // �ش� ���� ��ü Email
    Close;
    SQL.Clear;
    SQL.Add(' SELECT ACC_NO, MAIL_ADDR, RCV_NAME_KOR, TEL_NO         '
          + ' FROM SZMELDE_INS                                       '
          + ' WHERE DEPT_CODE = ''' + gvDeptCode + '''             '
          + ' AND   ACC_NO      = ''' + pAccNo + '''             '
          + ' ORDER BY RCV_NAME_KOR                                    ');

    Try
      gf_ADOQueryOpen(ADOQuery_DECLN);
    Except
      on E : Exception do
      begin  // DataBase ����
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZMELDE_INS]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZMELDE_INS]'); //Database ����
        Exit;
      end;
    End;


    while not Eof do
    begin
      New(EmailItem);
      EmailList.Add(EmailItem);
      EmailItem.AccNo := Trim(FieldByName('ACC_NO').AsString);
      EmailItem.SendType := 'Email';
      EmailItem.MailAddr := Trim(FieldByName('MAIL_ADDR').AsString);
      EmailItem.RcvNameKor := Trim(FieldByName('RCV_NAME_KOR').AsString);
      EmailItem.TelNo := Trim(FieldByName('TEL_NO').AsString);

      Next;
    end;  // end while

  end;

  Result := EmailList.Count;
end;

//==============================================================================
// ���¹�ȣ�� �ش��ϴ� Fax Query
//==============================================================================
function TForm_SCFH8105.QueryFax(pAccNo: string): integer;
var
  FaxItem : pTFaxItem;
begin
  Result := 0;

  ClearFaxList;

  with ADOQuery_DECLN do
  begin
    // �ش� ���� ��ü Fax
    Close;
    SQL.Clear;
    SQL.Add(' SELECT ACC_NO, MEDIA_NO, RCV_NAME_KOR, TEL_NO         '
          + ' FROM SZFAXDE_INS                                       '
          + ' WHERE DEPT_CODE = ''' + gvDeptCode + '''             '
          + ' AND   ACC_NO      = ''' + pAccNo + '''             '
          + ' ORDER BY RCV_NAME_KOR                                    ');

    Try
      gf_ADOQueryOpen(ADOQuery_DECLN);
    Except
      on E : Exception do
      begin  // DataBase ����
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZFAXDE_INS]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZFAXDE_INS]'); //Database ����
        Exit;
      end;
    End;


    while not Eof do
    begin
      New(FaxItem);
      FaxList.Add(FaxItem);
      FaxItem.AccNo := Trim(FieldByName('ACC_NO').AsString);
      FaxItem.SendType := 'Fax';
      FaxItem.MediaNo := Trim(FieldByName('MEDIA_NO').AsString);
      FaxItem.RcvNameKor := Trim(FieldByName('RCV_NAME_KOR').AsString);
      FaxItem.TelNo := Trim(FieldByName('TEL_NO').AsString);

      Next;
    end;  // end while

  end;

  Result := FaxList.Count;
end;

//==============================================================================
// �����޺� Refresh
//==============================================================================
function TForm_SCFH8105.RefreshAccNoCombo: boolean;
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

    DRUserDblCodeCombo_AccNo.ClearItems;
//    DRUserDblCodeCombo_AccNo.InsertAllItem := false;  // ��ü �׸� �߰�
    while not EOF do
    begin
      DRUserDblCodeCombo_AccNo.AddItem(Trim(FieldByName('ACC_NO').asString),
                                 Trim(FieldByName('ACC_NAME_KOR').asString));
      Next;
    end;
  end; // end of with
  Result := True;
end;

//==============================================================================
// Form Close
//==============================================================================
procedure TForm_SCFH8105.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if Assigned(FaxList) then  // FaxList Free
  begin
     ClearFaxList;
     FaxList.Free;
  end;
  if Assigned(EmailList) then  // EmailList Free
  begin
     ClearEmailList;
     EmailList.Free;
  end;
end;

//==============================================================================
// ��ȸ��ư Click
//==============================================================================
procedure TForm_SCFH8105.DRBitBtn6Click(Sender: TObject);
var
  AccNo : String;
  RowCount : Integer;
begin
  inherited;
  gf_ShowMessage(MessageBar, mtInformation, 1020, ''); //��ȸ ���Դϴ�.
  DisableForm;

  ClearInputEdit;

  AccNo := Trim(DRUserDblCodeCombo_AccNo.Code);
  if AccNo = '' then   // ���¹�ȣ
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, '���¹�ȣ'); //�Է� ����
    DRUserDblCodeCombo_AccNo.SetFocus;
    EnableForm;
    Exit;
  end;

  RowCount := QueryFax(AccNo) + QueryEmail(AccNo);
  DisplayGridFaxEmail;

   if RowCount <= 0 then
       gf_ShowMessage(MessageBar, mtInformation, 1018, '') //�ش� ������ �����ϴ�.
   else
       gf_ShowMessage(MessageBar, mtInformation, 1021,
               gwQueryCnt + IntToStr(RowCount)); // ��ȸ �Ϸ�

   DRStrGrid_FaxEmail.SetFocus;
   EnableForm;
end;

//==============================================================================
// DRStrGrid_FaxEmail EmailList, FaxList  ����
//==============================================================================
function TForm_SCFH8105.DisplayGridFaxEmail: Boolean;
var
  I, K, iRow : Integer;
  FaxItem : pTFaxItem;
  EmailItem : pTEmailItem;
  sSendType, sFaxEmail, sRcvNameKor, sTelNo : string;
begin
  Result := false;

  with DRStrGrid_FaxEmail do
  begin
    if (FaxList.Count <= 0) and (EmailList.Count <= 0) then
    begin
      RowCount := 2;
      Rows[1].Clear;
      gf_ShowMessage(MessageBar, mtInformation, 1018, ''); //�ش� ������ �����ϴ�.
      Exit;
    end;
    DefClearStrGrid(DRStrGrid_FaxEmail);

    RowCount := FaxList.Count + EmailList.Count + 1;

    iRow := 0;
    sSendType := '';
    sFaxEmail := '';
    sRcvNameKor := '';
    sTelNo      := '';
    // StrGrid Input
    for i := 0 to FaxList.Count - 1 do
    begin
      FaxItem := FaxList.Items[i];

      Inc(iRow);
      Rows[iRow].Clear;

      sSendType   := FaxItem.SendType;
      sFaxEmail    := FaxItem.MediaNo;
      sRcvNameKor := FaxItem.RcvNameKor;
      sTelNo      := FaxItem.TelNo;

      // ���۱���
      Cells[IDX_SEND_TYPE, iRow] := sSendType;
      // Fax | Email
      Cells[IDX_FAX_EMAIL, iRow] := sFaxEmail;
      // �����
      Cells[IDX_RCV_NAME_KOR, iRow] := sRcvNameKor;
      // ��ȭ��ȣ
      Cells[IDX_TEL_NO, iRow] := sTelNo;
    end;

    // StrGrid Input
    for i := 0 to EmailList.Count - 1 do
    begin
      EmailItem := EmailList.Items[i];
      Inc(iRow);
      
      sSendType   := EmailItem.SendType;
      sFaxEmail    := EmailItem.MailAddr;
      sRcvNameKor := EmailItem.RcvNameKor;
      sTelNo      := EmailItem.TelNo;

      // ���۱���
      Cells[IDX_SEND_TYPE, iRow] := sSendType;
      // Fax | Email
      Cells[IDX_FAX_EMAIL, iRow] := sFaxEmail;
      // �����
      Cells[IDX_RCV_NAME_KOR, iRow] := sRcvNameKor;
      // ��ȭ��ȣ
      Cells[IDX_TEL_NO, iRow] := sTelNo;
    end;
  end;

  Result := True;
end;

procedure TForm_SCFH8105.DRUserDblCodeCombo_AccNoCodeChange(
  Sender: TObject);
begin
  inherited;
  gf_ClearMessage(MessageBar);

  ClearInputEdit;
  DefClearStrGrid(DRStrGrid_FaxEmail);
end;

//==============================================================================
// �ʼ��Է� �׸� ���� Ȯ��
//==============================================================================
function TForm_SCFH8105.CheckKeyEditEmpty: boolean;
begin
   Result := true;

   // ���¹�ȣ
   if Trim(DRUserDblCodeCombo_AccNo.Code) = '' then   // ���¹�ȣ
   begin
      gf_ShowMessage(MessageBar, mtError, 1012, '���¹�ȣ'); //�Է� ����
      DRUserDblCodeCombo_AccNo.SetFocus;
      Exit;
   end;

  // Fax | Email
  if Trim(DREdit_FaxEmail.Text) = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, 'Fax | Email'); //�Է� ����
    DREdit_FaxEmail.SetFocus;
    Exit;
  end;
   Result := false;
end;

//==============================================================================
// FaxEmail �׸��� ����Ŭ��
//==============================================================================
procedure TForm_SCFH8105.DRStrGrid_FaxEmailSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  SelRowIdx := ARow;
end;

//==============================================================================
// FaxEmail �׸��� ����Ŭ��
//==============================================================================
procedure TForm_SCFH8105.DRStrGrid_FaxEmailDblClick(Sender: TObject);
var
  sSendType, sAccNo, sFaxEmail : string;
  FaxItem : pTFaxItem;
  EmailItem : pTEmailItem;
begin
  inherited;
  gf_ClearMessage(MessageBar);

  sSendType := Trim(DRStrGrid_FaxEmail.Cells[IDX_SEND_TYPE, SelRowIdx]);  // ���õ� ���۱���

  if SelRowIdx <= 0 then Exit;
  if sSendType = '' then exit;

  sAccNo := Trim(DRUserDblCodeCombo_AccNo.Code);
  sFaxEmail := Trim(DRStrGrid_FaxEmail.Cells[IDX_FAX_EMAIL, SelRowIdx]);
  // ������ư �׸� üũ
  if sSendType = SEND_TYPE_FAX then        // Fax
    DisplayToEdit_Fax(sAccNo, sFaxEmail)     // ����Ŭ���� Fax ���� ��������
  else if sSendType = SEND_TYPE_EMAIL then // Email
    DisplayToEdit_Email(sAccNo, sFaxEmail);   // ����Ŭ���� Email ���� ��������


  DREdit_FaxEmail.SetFocus;
end;

//==============================================================================
// StrGrid���� �ش� �����Ϳ� �ش�Ǵ� RowIndex ã�� Select
//==============================================================================
function TForm_SCFH8105.SelectGridData_FaxEmail(
  pFaxEmail: string): Integer;
var
  I, SearchIdx : Integer;
begin
  SearchIdx := -1;
  for I := 1 to DRStrGrid_FaxEmail.RowCount -1 do
  begin
     if (DRStrGrid_FaxEmail.Cells[IDX_FAX_EMAIL, I] = pFaxEmail) then
     begin
         SearchIdx := I;
         break;
     end;
  end;
  if SearchIdx > -1 then  //�ش� ������ �����
     gf_SelectStrGridRow(DRStrGrid_FaxEmail, SearchIdx)
  else  //�ش� ������ �������� ���� ��� ùRow Select
     gf_SelectStrGridRow(DRStrGrid_FaxEmail, 1);
  Result := SearchIdx;
end;

//==============================================================================
// �ش� Email ������
//==============================================================================
function TForm_SCFH8105.DisplayToEdit_Email(pAccNo, pMailAddr: string): boolean;
begin

   Result := false;
   with  ADOQuery_DECLN do
   begin
      EnableBCD := False;
      Close;
      SQL.Clear;
      SQL.Add(' SELECT ACC_NO, MAIL_ADDR,                                 '
            + ' RCV_NAME_KOR, TEL_NO,                                     '
            + ' OPR_ID, OPR_DATE, OPR_TIME,                               '
            + ' IMPORT_ID, IMPORT_DATE, IMPORT_TIME                       '
            + ' FROM SZMELDE_INS                                          '
            + ' WHERE DEPT_CODE = ''' + gvDeptCode + '''                  '
            + ' AND   ACC_NO  = ''' + pAccNo + '''                        '
            + ' AND   MAIL_ADDR  = ''' + pMailAddr + '''                  ');

      Try
         gf_ADOQueryOpen(ADOQuery_DECLN);
      Except
         on E : Exception do
         begin  // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZMELDE_INS]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZMELDE_INS]'); //Database ����
            Exit;
         end;
      End;

      if RecordCount <= 0 then
      begin
         Result := true;
         Exit;
      end;
      // �� Edit Input
      DRRadioGroup_SndType.ItemIndex := 1; // Email
      DREdit_FaxEmail.Text   := Trim(FieldByName('MAIL_ADDR').asString);
      DREdit_Name.Text       := Trim(FieldByName('RCV_NAME_KOR').asString);
      DREdit_Phone.Text      :=  Trim(FieldByName('TEL_NO').asString);
      DREdit_MgrOprId.Text   := Trim(FieldByName('OPR_ID').asString);
      DREdit_MgrOprTime.Text := gf_FormatDate(Trim(FieldByName('OPR_DATE').asString))
                               + ' ' + gf_FormatTime(Trim(FieldByName('OPR_TIME').asString));
      DREdit_ImportID.Text   := Trim(FieldByName('IMPORT_ID').asString);
      DREdit_ImportTime.Text := gf_FormatDate(Trim(FieldByName('IMPORT_DATE').asString))
                               + ' ' + gf_FormatTime(Trim(FieldByName('IMPORT_TIME').asString));

   end;

   Result := true;
end;

//==============================================================================
// �ش� FAX ������
//==============================================================================
function TForm_SCFH8105.DisplayToEdit_Fax(pAccNo, pMediaNo: string): boolean;
begin

   Result := false;
   with  ADOQuery_DECLN do
   begin
      EnableBCD := False;
      Close;
      SQL.Clear;
      SQL.Add(' SELECT ACC_NO, MEDIA_NO,                                  '
            + ' RCV_NAME_KOR, TEL_NO,                                     '
            + ' OPR_ID, OPR_DATE, OPR_TIME,                               '
            + ' IMPORT_ID, IMPORT_DATE, IMPORT_TIME                       '
            + ' FROM SZFAXDE_INS                                          '
            + ' WHERE DEPT_CODE = ''' + gvDeptCode + '''                  '
            + ' AND   ACC_NO  = ''' + pAccNo + '''                        '
            + ' AND   MEDIA_NO  = ''' + pMediaNo + '''                  ');

      Try
         gf_ADOQueryOpen(ADOQuery_DECLN);
      Except
         on E : Exception do
         begin  // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZFAXDE_INS]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZFAXDE_INS]'); //Database ����
            Exit;
         end;
      End;

      if RecordCount <= 0 then
      begin
         Result := true;
         Exit;
      end;
      // �� Edit Input

      DRRadioGroup_SndType.ItemIndex := 0; // Fax
      DREdit_FaxEmail.Text   := Trim(FieldByName('MEDIA_NO').asString);
      DREdit_Name.Text       := Trim(FieldByName('RCV_NAME_KOR').asString);
      DREdit_Phone.Text      :=  Trim(FieldByName('TEL_NO').asString);
      DREdit_MgrOprId.Text   := Trim(FieldByName('OPR_ID').asString);
      DREdit_MgrOprTime.Text := gf_FormatDate(Trim(FieldByName('OPR_DATE').asString))
                               + ' ' + gf_FormatTime(Trim(FieldByName('OPR_TIME').asString));
      DREdit_ImportID.Text   := Trim(FieldByName('IMPORT_ID').asString);
      DREdit_ImportTime.Text := gf_FormatDate(Trim(FieldByName('IMPORT_DATE').asString))
                               + ' ' + gf_FormatTime(Trim(FieldByName('IMPORT_TIME').asString));

   end;

   Result := true;
end;

//==============================================================================
// RadioButton Click (Fax | Email)
//==============================================================================
procedure TForm_SCFH8105.DRRadioGroup_SndTypeClick(Sender: TObject);
begin
  inherited;
  gf_ClearMessage(MessageBar);
  
//  ClearInputEdit;
//  DefClearStrGrid(DRStrGrid_FaxEmail);

  // ������ư �׸� üũ
  if DRRadioGroup_SndType.ItemIndex = RADIO_SEND_TYPE_FAX then  // Fax
  begin
     DREdit_FaxEmail.MaxLength := 64;
  end
  else if DRRadioGroup_SndType.ItemIndex = RADIO_SEND_TYPE_EMAIL then // Email
  begin
     DREdit_FaxEmail.MaxLength := 400;
  end;
end;

//==============================================================================
// ��ȭ��ȣ Edit KeyPress
//==============================================================================
procedure TForm_SCFH8105.DREdit_PhoneKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if (not (Key in ['0'..'9'])) and (Key <> #13) and (Key <> #8) and (Key <> #45) then
  begin
    key := #0 ;
    gf_ShowMessage(MessageBar, mtError, 1045,''); // ���ڸ� �Է��Ͻʽÿ�.
  end;
end;

//==============================================================================
// �Է¹�ư Click
//==============================================================================
procedure TForm_SCFH8105.DRBitBtn5Click(Sender: TObject);
begin
  inherited;
  // ������ư �׸� üũ
  if DRRadioGroup_SndType.ItemIndex = RADIO_SEND_TYPE_FAX then  // Fax
  begin
    if not DataInsert_Fax then Exit;
  end
  else if DRRadioGroup_SndType.ItemIndex = RADIO_SEND_TYPE_EMAIL then // Email
  begin
    if not DataInsert_Email then Exit;
  end;
end;

//==============================================================================
// DB Insert (Email)
//==============================================================================
function TForm_SCFH8105.DataInsert_Email: boolean;
var
  CurAccNo : string;
  CurMailAddr : string;
begin
  inherited;
  Result := false;

  gf_ShowMessage(MessageBar, mtInformation, 1010, ''); //�Է� ���Դϴ�.

  if CheckKeyEditEmpty then Exit;   //�Է� ���� �׸� Ȯ��

  // ���� �����ݷ� �ֱ�
  if RightStr(Trim(DREdit_FaxEmail.Text),1) <> ';' then
    DREdit_FaxEmail.Text := Trim(DREdit_FaxEmail.Text) + ';';

  CurAccNo    := Trim(DRUserDblCodeCombo_AccNo.Code);
  CurMailAddr := Trim(DREdit_FaxEmail.Text);


  DisableForm;
  // ���¹�ȣ, MailAddr�� ���� ��� Check
  if not EmailNoChk(CurAccNo, CurMailAddr) then
  begin
     EnableForm;
     SelectGridData_FaxEmail(CurMailAddr);
     DREdit_FaxEmail.SetFocus;
     Exit;
  end;

  with ADOQuery_DECLN do
  begin
     Close;
     sql.clear;
     sql.add(   // Email ���̺� �Է�
              ' INSERT SZMELDE_INS                                          '
            + '  (DEPT_CODE,       ACC_NO,          SEND_MTD,                '
            + '   MAIL_ADDR,       RCV_NAME_KOR,    TEL_NO,                 '
            + '   SEND_STOP,       MANUAL_YN,                               '
            + '   OPR_ID,          OPR_DATE,        OPR_TIME               ) '
//            + '   IMPORT_ID,    IMPORT_DATE,    IMPORT_TIME     )                 '
            + ' VALUES                                                      '
            + '  (:pDEPT_CODE,     :pACC_NO,         :pSEND_MTD,            '
            + '   :pMAIL_ADDR,     :pRCV_NAME_KOR,   :pTEL_NO,              '
            + '   :pSEND_STOP,     :pMANUAL_YN,                             '
            + '   :pOPR_ID,        :pOPR_DATE,       :pOPR_TIME               ) '
//            + '   :pIMPORT_ID,   :pIMPORT_DATE,  :pIMPORT_TIME                )  '
            );

     MoveInsertData_Email;

     Try
        gf_ADOExecSQL(ADOQuery_DECLN);
     Except
        on E : Exception do
        begin
           gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZMELDE_INS :INSERT]: ' + E.Message, 0);
           gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZMELDE_INS : INSERT]'); // Database ����
           EnableForm;
           Exit;
        end;
     end;
  end;

  InsertLog(LOG_TRG_GB_ADD, LOG_JOB_GB_EMAIL);

  QueryEmail(CurAccNo);   // Email ��ȸ����
  DisplayGridFaxEmail; // �׸��忡 ������ INPUT

  SelectGridData_FaxEmail(CurMailAddr);
  ClearInputEdit;

  EnableForm;
  DREdit_FaxEmail.SetFocus;
  gf_ShowMessage(MessageBar, mtInformation, 1011, ''); // �Է� �Ϸ�
  Result := true;
end;

//==============================================================================
// DB Insert (Fax)
//==============================================================================
function TForm_SCFH8105.DataInsert_Fax: boolean;
var
  CurAccNo : string;
  CurMediaNo : string;
begin
  inherited;
  Result := false;

  gf_ShowMessage(MessageBar, mtInformation, 1010, ''); //�Է� ���Դϴ�.

  if CheckKeyEditEmpty then Exit;   //�Է� ���� �׸� Ȯ��

  CurAccNo    := Trim(DRUserDblCodeCombo_AccNo.Code);
  CurMediaNo := Trim(DREdit_FaxEmail.Text);

  DisableForm;
  // ���¹�ȣ, �ѽ���ȣ�� ���� ��� Check
  if not FaxNoChk(CurAccNo, CurMediaNo) then
  begin
     EnableForm;            
     SelectGridData_FaxEmail(CurMediaNo);
     DREdit_FaxEmail.SetFocus;
     Exit;
  end;

  with ADOQuery_DECLN do
  begin
     Close;
     sql.clear;
     sql.add(   // Fax ���̺� �Է�
              ' INSERT SZFAXDE_INS                                          '
            + '  (DEPT_CODE,       ACC_NO,          MEDIA_NO,                '
            + '   RCV_NAME_KOR,    TEL_NO,                                   '
            + '   SEND_STOP,       MANUAL_YN,                               '
            + '   OPR_ID,          OPR_DATE,        OPR_TIME               ) '
//            + '   IMPORT_ID,    IMPORT_DATE,    IMPORT_TIME     )                 '
            + ' VALUES                                                      '
            + '  (:pDEPT_CODE,     :pACC_NO,         :pMEDIA_NO,            '
            + '   :pRCV_NAME_KOR,  :pTEL_NO,                                '
            + '   :pSEND_STOP,     :pMANUAL_YN,                             '
            + '   :pOPR_ID,        :pOPR_DATE,       :pOPR_TIME               ) '
//            + '   :pIMPORT_ID,   :pIMPORT_DATE,  :pIMPORT_TIME                )  '
            );

     MoveInsertData_Fax;

     Try
        gf_ADOExecSQL(ADOQuery_DECLN);
     Except
        on E : Exception do
        begin
           gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZFAXDE_INS :INSERT]: ' + E.Message, 0);
           gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZFAXDE_INS : INSERT]'); // Database ����
           EnableForm;
           Exit;
        end;
     end;
  end;

  InsertLog(LOG_TRG_GB_ADD, LOG_JOB_GB_FAX);

  QueryFax(CurAccNo);   // Fax ��ȸ����
  DisplayGridFaxEmail; // �׸��忡 ������ INPUT

  SelectGridData_FaxEmail(CurMediaNo);
  ClearInputEdit;

  EnableForm;
  DREdit_FaxEmail.SetFocus;
  gf_ShowMessage(MessageBar, mtInformation, 1011, ''); // �Է� �Ϸ�
  Result := true;
end;

//==============================================================================
// Email �����ϴ��� Check
//==============================================================================
function TForm_SCFH8105.EmailNoChk(pAccNo, pMailAddr: string): boolean;
begin
   Result := false;
   with  ADOQuery_DECLN do
   begin
      Close;
      SQL.Clear;
      SQL.Add(' SELECT MAIL_ADDR                               '
            + ' FROM SZMELDE_INS                               '
            + ' WHERE DEPT_CODE = ''' + gvDeptcode  + '''      '
            + ' AND   ACC_NO    = ''' + pAccNO      + '''      '
            + ' AND   MAIL_ADDR = ''' + pMailAddr   + '''      ');
      Try
         gf_ADOQueryOpen(ADOQuery_DECLN);
      Except
         on E : Exception do
         begin  // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZMELDE_INS]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZMELDE_INS]'); //Database ����
            Exit;
         end;
      End;

      if RecordCount >= 1  then
      begin
        gf_ShowMessage(MessageBar, mtError, 1024, 'Email'); // �ش� �ڷᰡ �̹� �����մϴ�.
        exit;
      end;
   end;
   Result := true;
end;

//==============================================================================
// Fax �����ϴ��� Check
//==============================================================================
function TForm_SCFH8105.FaxNoChk(pAccNo, pMediaNo: string): boolean;
begin
   Result := false;
   with  ADOQuery_DECLN do
   begin
      Close;
      SQL.Clear;
      SQL.Add(' SELECT MEDIA_NO                               '
            + ' FROM SZFAXDE_INS                               '
            + ' WHERE DEPT_CODE = ''' + gvDeptcode  + '''      '
            + ' AND   ACC_NO    = ''' + pAccNO      + '''      '
            + ' AND   MEDIA_NO  = ''' + pMediaNo   + '''      ');
      Try
         gf_ADOQueryOpen(ADOQuery_DECLN);
      Except
         on E : Exception do
         begin  // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZFAXDE_INS]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZFAXDE_INS]'); //Database ����
            Exit;
         end;
      End;

      if RecordCount >= 1  then
      begin
        gf_ShowMessage(MessageBar, mtError, 1024, 'Fax'); // �ش� �ڷᰡ �̹� �����մϴ�.
        exit;
      end;
   end;
   Result := true;
end;

//==============================================================================
// Email ���� Insert
//==============================================================================
procedure TForm_SCFH8105.MoveInsertData_Email;
begin
  with ADOQuery_DECLN do
  begin
    // ���μ�
    Parameters.ParamByName('pDEPT_CODE').Value := gvDeptCode;
    // ���¹�ȣ
    Parameters.ParamByName('pACC_NO').Value := Trim(DRUserDblCodeCombo_AccNo.Code);
    // ����ó ����
    Parameters.ParamByName('pSEND_MTD').Value := 'R';
    // �����ּ�
    Parameters.ParamByName('pMAIL_ADDR').Value := Trim(DREdit_FaxEmail.Text);
    // �����
    Parameters.ParamByName('pRCV_NAME_KOR').Value := Trim(DREdit_Name.Text);
    // ��ȭ��ȣ
    Parameters.ParamByName('pTEL_NO').Value := Trim(DREdit_Phone.Text);
    // ��������
    Parameters.ParamByName('pSEND_STOP').Value := 'N';
    // ���۾�����
    Parameters.ParamByName('pMANUAL_YN').Value := 'N';
    // ������ ID
    Parameters.ParamByName('pOPR_ID').Value := gvOprUsrNo;
    // ��������
    Parameters.ParamByName('pOPR_DATE').Value := gvCurDate;
    // ���۽ð�
    Parameters.ParamByName('pOPR_TIME').Value := gf_GetCurTime;
{
    // Import ID
    Parameters.ParamByName('pIMPORT_ID').Value := Trim(DREdit_ImportID);
    // Import����
    Parameters.ParamByName('pIMPORT_DATE').Value := '';
    // Import�ð�
    Parameters.ParamByName('pIMPORT_TIME').Value := '';
}
  end;
end;

//==============================================================================
// Fax ���� Insert
//==============================================================================
procedure TForm_SCFH8105.MoveInsertData_Fax;
begin
  with ADOQuery_DECLN do
  begin
    // ���μ�
    Parameters.ParamByName('pDEPT_CODE').Value := gvDeptCode;
    // ���¹�ȣ
    Parameters.ParamByName('pACC_NO').Value := Trim(DRUserDblCodeCombo_AccNo.Code);
    // �ѽ���ȣ
    Parameters.ParamByName('pMEDIA_NO').Value := Trim(DREdit_FaxEmail.Text);
    // �����
    Parameters.ParamByName('pRCV_NAME_KOR').Value := Trim(DREdit_Name.Text);
    // ��ȭ��ȣ
    Parameters.ParamByName('pTEL_NO').Value := Trim(DREdit_Phone.Text);
    // ��������
    Parameters.ParamByName('pSEND_STOP').Value := 'N';
    // ���۾�����
    Parameters.ParamByName('pMANUAL_YN').Value := 'N';
    // ������ ID
    Parameters.ParamByName('pOPR_ID').Value := gvOprUsrNo;
    // ��������
    Parameters.ParamByName('pOPR_DATE').Value := gvCurDate;
    // ���۽ð�
    Parameters.ParamByName('pOPR_TIME').Value := gf_GetCurTime;
{
    // Import ID
    Parameters.ParamByName('pIMPORT_ID').Value := Trim(DREdit_ImportID);
    // Import����
    Parameters.ParamByName('pIMPORT_DATE').Value := '';
    // Import�ð�
    Parameters.ParamByName('pIMPORT_TIME').Value := '';
}
  end;
end;


//==============================================================================
// ������ư Click
//==============================================================================
procedure TForm_SCFH8105.DRBitBtn4Click(Sender: TObject);
begin
  inherited;
  // ������ư �׸� üũ
  if DRRadioGroup_SndType.ItemIndex = RADIO_SEND_TYPE_FAX then  // Fax
  begin
    if not DataUpdate_Fax then Exit;
  end
  else if DRRadioGroup_SndType.ItemIndex = RADIO_SEND_TYPE_EMAIL then // Email
  begin
    if not DataUpdate_Email then Exit;
  end;
end;

//==============================================================================
// Email ����
//==============================================================================
function TForm_SCFH8105.DataUpdate_Email: boolean;
var
   OriginRcvNameKor, CurRcvNameKor: string;
   OriginTelNo, CurTelNo: string;
   CurAccNo: string;
   CurMailAddr : string;
begin
   Result := false;
   gf_ShowMessage(MessageBar, mtInformation, 1007, ''); //���� ���Դϴ�.

   if CheckKeyEditEmpty then Exit;   // Key Field Edit�� ���� �׸�

   CurAccNo := Trim(DRUserDblCodeCombo_AccNo.Code);
   CurMailAddr := Trim(DREdit_FaxEmail.Text);
   DisableForm;

   // ���¹�ȣ, �����ּҷ� ���� ��� Check
   if not UpdateDel_EmailNoChk(CurAccNo, CurMailAddr) then
   begin
      EnableForm;
      DREdit_FaxEmail.SetFocus;
      Exit;
   end;

   // ���� �����
   OriginRcvNameKor := Trim(ADOQuery_DECLN.FieldByName('RCV_NAME_KOR').AsString);
   // ���� �����
   CurRcvNameKor    := Trim(DREdit_Name.Text);
   // ���� ��ȭ��ȣ
   OriginTelNo := Trim(ADOQuery_DECLN.FieldByName('TEL_NO').AsString);
   // ���� ��ȭ��ȣ
   CurTelNo    := Trim(DREdit_Phone.Text);

   // ���泻�� ������
   if ((OriginRcvNameKor = CurRcvNameKor) and (OriginTelNo = CurTelNo))  then
   begin
     SelectGridData_FaxEmail(CurMailAddr);

     EnableForm;
     DREdit_FaxEmail.SetFocus;
     gf_ShowMessage(MessageBar, mtInformation, 0, '��������� �����ϴ�.'); // ���� X
     Exit;
   end;
   with ADOQuery_DECLN do
   begin
      Close;
      sql.clear;
      sql.add(   // Email ���̺� ����
             ' UPDATE SZMELDE_INS                       '
           + ' SET                                      '
           + ' DEPT_CODE        =  :pDEPT_CODE,         '
           + ' RCV_NAME_KOR     =  :pRCV_NAME_KOR,       '
           + ' TEL_NO           =  :pTEL_NO,       '
           + ' OPR_ID           =  :pOPR_ID,          '
           + ' OPR_DATE         =  :pOPR_DATE,        '
           + ' OPR_TIME         =  :pOPR_TIME         '
//           + ' IMPORT_ID        =  :pIMPORT_ID,       '
//           + ' IMPORT_DATE      =  :pIMPORT_DATE,     '
//           + ' IMPORT_TIME      =  :pIMPORT_TIME      '
           + ' WHERE DEPT_CODE  = ''' + gvDeptCode + ''' '
           + ' AND   ACC_NO     = ''' + CurAccNo   + ''' '
           + ' AND   MAIL_ADDR  = ''' + CurMailAddr + ''' '
           );

       MoveUpdateData;

      Try
         gf_ADOExecSQL(ADOQuery_DECLN);
      Except
         on E : Exception do
         begin
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZMELDE_INS :UPDATE]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZMELDE_INS : UPDATE]'); // Database ����
            EnableForm;
            Exit;
         end;
      end;//try
   end; //with

   InsertLog(LOG_TRG_GB_UPDATE, LOG_JOB_GB_EMAIL, OriginRcvNameKor, CurRcvNameKor, OriginTelNo, CurTelNo);

   QueryEmail(CurAccNo);   // Email ��ȸ����
   DisplayGridFaxEmail; // �׸��忡 ������ INPUT

   SelectGridData_FaxEmail(CurMailAddr);
   ClearInputEdit;

   EnableForm;
   DREdit_FaxEmail.SetFocus;
   gf_ShowMessage(MessageBar, mtInformation, 1008, ''); // ���� �Ϸ�
   Result := true;

end;

//==============================================================================
// Fax ����
//==============================================================================
function TForm_SCFH8105.DataUpdate_Fax: boolean;
var
   OriginRcvNameKor, CurRcvNameKor: string;
   OriginTelNo, CurTelNo: string;
   CurAccNo: string;
   CurMediaNo : string;
begin
   Result := false;
   gf_ShowMessage(MessageBar, mtInformation, 1007, ''); //���� ���Դϴ�.

   if CheckKeyEditEmpty then Exit;   // Key Field Edit�� ���� �׸�

   CurAccNo := Trim(DRUserDblCodeCombo_AccNo.Code);
   CurMediaNo := Trim(DREdit_FaxEmail.Text);
   DisableForm;

   // ���¹�ȣ, �ѽ���ȣ�� ���� ��� Check
   if not UpdateDel_FaxNoChk(CurAccNo, CurMediaNo) then
   begin
      EnableForm;
      DREdit_FaxEmail.SetFocus;
      Exit;
   end;

   // ���� �����
   OriginRcvNameKor := Trim(ADOQuery_DECLN.FieldByName('RCV_NAME_KOR').AsString);
   // ���� �����
   CurRcvNameKor    := Trim(DREdit_Name.Text);
   // ���� ��ȭ��ȣ
   OriginTelNo := Trim(ADOQuery_DECLN.FieldByName('TEL_NO').AsString);
   // ���� ��ȭ��ȣ
   CurTelNo    := Trim(DREdit_Phone.Text);

   // ���泻�� ������
   if ((OriginRcvNameKor = CurRcvNameKor) and (OriginTelNo = CurTelNo))  then
   begin
     SelectGridData_FaxEmail(CurMediaNo);

     EnableForm;
     DREdit_FaxEmail.SetFocus;
     gf_ShowMessage(MessageBar, mtInformation, 0, '��������� �����ϴ�.'); // ���� X
     Exit;
   end;
   with ADOQuery_DECLN do
   begin
      Close;
      sql.clear;
      sql.add(   // Fax ���̺� ����
             ' UPDATE SZFAXDE_INS                       '
           + ' SET                                      '
           + ' DEPT_CODE        =  :pDEPT_CODE,         '
           + ' RCV_NAME_KOR     =  :pRCV_NAME_KOR,       '
           + ' TEL_NO           =  :pTEL_NO,       '
           + ' OPR_ID           =  :pOPR_ID,          '
           + ' OPR_DATE         =  :pOPR_DATE,        '
           + ' OPR_TIME         =  :pOPR_TIME         '
//           + ' IMPORT_ID        =  :pIMPORT_ID,       '
//           + ' IMPORT_DATE      =  :pIMPORT_DATE,     '
//           + ' IMPORT_TIME      =  :pIMPORT_TIME      '
           + ' WHERE DEPT_CODE  = ''' + gvDeptCode + ''' '
           + ' AND   ACC_NO     = ''' + CurAccNo   + ''' '
           + ' AND   MEDIA_NO  = ''' + CurMediaNo + ''' '
           );

       MoveUpdateData;

      Try
         gf_ADOExecSQL(ADOQuery_DECLN);
      Except
         on E : Exception do
         begin
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZFAXDE_INS :UPDATE]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZFAXDE_INS : UPDATE]'); // Database ����
            EnableForm;
            Exit;
         end;
      end;//try
   end; //with

   InsertLog(LOG_TRG_GB_UPDATE, LOG_JOB_GB_FAX, OriginRcvNameKor, CurRcvNameKor, OriginTelNo, CurTelNo);

   QueryFax(CurAccNo);   // Fax ��ȸ����
   DisplayGridFaxEmail; // �׸��忡 ������ INPUT

   SelectGridData_FaxEmail(CurMediaNo);
   ClearInputEdit;

   EnableForm;
   DREdit_FaxEmail.SetFocus;
   gf_ShowMessage(MessageBar, mtInformation, 1008, ''); // ���� �Ϸ�
   Result := true;
end;

//==============================================================================
// Fax | Email ���� Update
//==============================================================================
procedure TForm_SCFH8105.MoveUpdateData;
begin
  with ADOQuery_DECLN do
  begin
    // ���μ�
    Parameters.ParamByName('pDEPT_CODE').Value := gvDeptCode;
    // �����
    Parameters.ParamByName('pRCV_NAME_KOR').Value := Trim(DREdit_Name.Text);
    // ��ȭ��ȣ
    Parameters.ParamByName('pTEL_NO').Value := Trim(DREdit_Phone.Text);
    // ������ ID
    Parameters.ParamByName('pOPR_ID').Value := gvOprUsrNo;
    // ��������
    Parameters.ParamByName('pOPR_DATE').Value := gvCurDate;
    // ���۽ð�
    Parameters.ParamByName('pOPR_TIME').Value := gf_GetCurTime;
{
    // Import ID
    Parameters.ParamByName('pIMPORT_ID').Value := Trim(DREdit_ImportID);
    // Import����
    Parameters.ParamByName('pIMPORT_DATE').Value := '';
    // Import�ð�
    Parameters.ParamByName('pIMPORT_TIME').Value := '';
}
  end;
end;


//==============================================================================
// Fax ��� check -update/delete�� check
//==============================================================================
function TForm_SCFH8105.UpdateDel_FaxNoChk(pAccNo,
  pMediaNo: string): boolean;
begin
   Result := false;
   with  ADOQuery_DECLN do
   begin
      Close;
      SQL.Clear;
      SQL.Add(
              ' SELECT MEDIA_NO, RCV_NAME_KOR, TEL_NO     '
            + ' FROM SZFAXDE_INS                          '
            + ' WHERE DEPT_CODE   = ''' + gvDeptcode  + ''' '
            + ' AND   ACC_NO      = ''' + pAccNO      + ''' '
            + ' AND   MEDIA_NO    = ''' + pMediaNo    + ''' ' );
      Try
         gf_ADOQueryOpen(ADOQuery_DECLN);
      Except
         on E : Exception do
         begin  // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZFAXDE_INS]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZFAXDE_INS]'); //Database ����
            Exit;
         end;
      End;

      if RecordCount <= 0  then
      begin
         gf_ShowMessage(MessageBar, mtError, 1025, 'Fax'); //�ش� �ڷᰡ �������� �ʽ��ϴ�.
         exit;
      end;
   end;
   Result := true;
end;

//==============================================================================
// Email ��� check -update/delete�� check
//==============================================================================
function TForm_SCFH8105.UpdateDel_EmailNoChk(pAccNo,
  pMailAddr: string): boolean;
begin
   Result := false;
   with  ADOQuery_DECLN do
   begin
      Close;
      SQL.Clear;
      SQL.Add(
              ' SELECT MAIL_ADDR, RCV_NAME_KOR, TEL_NO    '
            + ' FROM SZMELDE_INS                          '
            + ' WHERE DEPT_CODE   = ''' + gvDeptcode  + ''' '
            + ' AND   ACC_NO      = ''' + pAccNO      + ''' '
            + ' AND   MAIL_ADDR   = ''' + pMailAddr   + ''' ' );
      Try
         gf_ADOQueryOpen(ADOQuery_DECLN);
      Except
         on E : Exception do
         begin  // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZMELDE_INS]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZMELDE_INS]'); //Database ����
            Exit;
         end;
      End;

      if RecordCount <= 0  then
      begin
         gf_ShowMessage(MessageBar, mtError, 1025, 'Email'); //�ش� �ڷᰡ �������� �ʽ��ϴ�.
         exit;
      end;
   end;
   Result := true;
end;

//==============================================================================
// ������ư Click
//==============================================================================
procedure TForm_SCFH8105.DRBitBtn3Click(Sender: TObject);
begin
  inherited;
  // ������ư �׸� üũ
  if DRRadioGroup_SndType.ItemIndex = RADIO_SEND_TYPE_FAX then  // Fax
  begin
    if not DataDelete_Fax then Exit;
  end
  else if DRRadioGroup_SndType.ItemIndex = RADIO_SEND_TYPE_EMAIL then // Email
  begin
    if not DataDelete_Email then Exit;
  end;
end;

//==============================================================================
// Fax ����
//==============================================================================
function TForm_SCFH8105.DataDelete_Fax: boolean;
var
   CurAccNo : string;
   CurMediaNo : string;
   DeleteStr : string;
begin
   inherited;
   Result := false;

   if CheckKeyEditEmpty then Exit;   // Key Field Edit�� ���� �׸�

   CurAccNo := Trim(DRUserDblCodeCombo_AccNo.Code);
   CurMediaNo := Trim(DREdit_FaxEmail.Text);
   DeleteStr := '(' + CurAccNo + ': ' + CurMediaNo + ')';


   try

      // ����, �ѽ���ȣ�� ���� ��� Check
      if not UpdateDel_FaxNoChk(CurAccNo, CurMediaNo) then
      begin
//         EnableForm;
         DREdit_FaxEmail.SetFocus;
         Exit;
      end;

      // Confirm - ���� �����Ͻðڽ��ϱ�?
      if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 0, '���� �����Ͻðڽ��ϱ�?', mbOKCancel, 0) = idcancel then
      begin
        gf_ShowMessage(MessageBar, mtInformation, 1082, '');  // �۾��� ��ҵǾ����ϴ�.
        Exit;
      end;

      DisableForm;
      gf_ShowMessage(MessageBar, mtInformation, 1005, ''); //���� ���Դϴ�.

      with ADOQuery_DECLN do
      begin
        Close;
        sql.clear;
        sql.add(   // Fax ���̺� ����
            '  DELETE FROM  SZFAXDE_INS   '
          + '  WHERE  DEPT_CODE  = ''' + gvDeptCode + ''' '
          + '  AND    ACC_NO     = ''' + CurAccNo + ''' '
          + '  AND    MEDIA_NO   = ''' + CurMediaNo + ''' '
            );
        Try
           gf_ADOExecSQL(ADOQuery_DECLN);
        Except
           on E : Exception do
           begin
              gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZFAXDE_INS : DELETE]: ' + E.Message, 0);
              gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZFAXDE_INS : DELETE]'); // Database ����
 //                  EnableForm;
              Exit;
           end;
        end;  //try
      end; //  with

      InsertLog(LOG_TRG_GB_DELETE, LOG_JOB_GB_FAX);

      QueryFax(CurAccNo);   // Fax ��ȸ����
      DisplayGridFaxEmail; // �׸��忡 ������ INPUT

      SelectGridData_FaxEmail(CurMediaNo);
      ClearInputEdit;

      DREdit_FaxEmail.SetFocus;
      gf_ShowMessage(MessageBar, mtInformation, 1006, DeleteStr ); // ���� �Ϸ�
      Result := true;
   finally
      EnableForm;
   end;
end;

//==============================================================================
// Email ����
//==============================================================================
function TForm_SCFH8105.DataDelete_Email: boolean;
var
   CurAccNo : string;
   CurMailAddr : string;
   DeleteStr : string;
begin
   inherited;
   Result := false;

   if CheckKeyEditEmpty then Exit;   // Key Field Edit�� ���� �׸�

   CurAccNo := Trim(DRUserDblCodeCombo_AccNo.Code);
   CurMailAddr := Trim(DREdit_FaxEmail.Text);
   DeleteStr := '(' + CurAccNo + ': ' + CurMailAddr + ')';


   try

      // ����, �����ּҷ� ���� ��� Check
      if not UpdateDel_EmailNoChk(CurAccNo, CurMailAddr) then
      begin
//         EnableForm;
         DREdit_FaxEmail.SetFocus;
         Exit;
      end;

      // Confirm - ���� �����Ͻðڽ��ϱ�?
      if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 0, '���� �����Ͻðڽ��ϱ�?', mbOKCancel, 0) = idcancel then
      begin
        gf_ShowMessage(MessageBar, mtInformation, 1082, '');  // �۾��� ��ҵǾ����ϴ�.
        Exit;
      end;

      DisableForm;
      gf_ShowMessage(MessageBar, mtInformation, 1005, ''); //���� ���Դϴ�.

      with ADOQuery_DECLN do
      begin
        Close;
        sql.clear;
        sql.add(   // Email ���̺� ����
            '  DELETE FROM  SZMELDE_INS   '
          + '  WHERE  DEPT_CODE   = ''' + gvDeptCode + ''' '
          + '  AND    ACC_NO      = ''' + CurAccNo + ''' '
          + '  AND    MAIL_ADDR   = ''' + CurMailAddr + ''' '
            );
        Try
           gf_ADOExecSQL(ADOQuery_DECLN);
        Except
           on E : Exception do
           begin
              gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZMELDE_INS : DELETE]: ' + E.Message, 0);
              gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZMELDE_INS : DELETE]'); // Database ����
 //                  EnableForm;
              Exit;
           end;
        end;  //try
      end; //  with

      InsertLog(LOG_TRG_GB_DELETE, LOG_JOB_GB_EMAIL);

      QueryEmail(CurAccNo);   // Email ��ȸ����
      DisplayGridFaxEmail; // �׸��忡 ������ INPUT

      SelectGridData_FaxEmail(CurMailAddr);
      ClearInputEdit;

      DREdit_FaxEmail.SetFocus;
      gf_ShowMessage(MessageBar, mtInformation, 1006, DeleteStr ); // ���� �Ϸ�
      Result := true;
   finally
      EnableForm;
   end;
end;

//==============================================================================
// �μ��ư Click
//==============================================================================
procedure TForm_SCFH8105.DRBitBtn2Click(Sender: TObject);
begin
  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1100, ''); // �μ� ���Դϴ�.

   with DrStringPrint1 do
   begin
      Title  := DRPanel_Title.Caption;
      UserText1  := '';
      UserText2  := '';

      StringGrid := DRStrGrid_FaxEmail;
//      Orientation  := poPortrait;   //poLandscape;

      Print;
   end;

   gf_ShowMessage(MessageBar, mtInformation, 1101, ''); // �μ� �Ϸ�
end;

procedure TForm_SCFH8105.FormShow(Sender: TObject);
begin
  inherited;
  DRUserDblCodeCombo_AccNo.SetFocus;
end;

procedure TForm_SCFH8105.DREdit_KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
   if (Key = #13) and (ActiveControl is TWinControl) then   // ���� Control�� �̵�
   begin
      gf_ClearMessage(MessageBar);
      SelectNext(ActiveControl as TWinControl, True, True);
   end;
end;

//==============================================================================
// Fax | Email Edit KeyPress
//==============================================================================
procedure TForm_SCFH8105.DREdit_FaxEmailKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;

   if (Key = #13) and (ActiveControl is TWinControl) then   // ���� Control�� �̵�
   begin
      gf_ClearMessage(MessageBar);
      SelectNext(ActiveControl as TWinControl, True, True);
      Exit;
   end;

  // ������ư �׸� üũ
  if DRRadioGroup_SndType.ItemIndex = RADIO_SEND_TYPE_FAX then  // Fax
  begin
    if (not (Key in ['0'..'9'])) and (Key <> #8) and (Key <> #45) then
    begin
      key := #0;
      gf_ShowMessage(MessageBar, mtError, 1045,''); // ���ڸ� �Է��Ͻʽÿ�.
    end;
  end;

end;

//==============================================================================
// ���¹�ȣ KeyPress
//==============================================================================
procedure TForm_SCFH8105.DRUserDblCodeCombo_AccNoEditKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;

   if (Key = #13) and (ActiveControl is TWinControl) then   // ���� Control�� �̵�
   begin
      DREdit_FaxEmail.SetFocus;
   end;
end;

//==============================================================================
// SZTRLOG_HIS Insert
//==============================================================================
function TForm_SCFH8105.InsertLog(pTRGGB:string; pLOGGB: string; pOriginRcvNameKor:string = ''; pCurRcvNameKor: string = '';
  pOriginTelNo:string = ''; pCurTelNo: string = ''): boolean;
begin
   Result := false;
   with ADOQuery_Log do
   begin
     Close;
     sql.clear;
     sql.add(   // LOG ���̺� �Է�
              ' INSERT SZTRLOG_HIS                                                '
            + '  (DEPT_CODE,    OPR_DATE,         OPR_TIME,                     '
            + '   ACC_NO,                                                      '
            + '   JOB_GB,       TRG_GB,           TR_CODE,                        '
            + '   OPR_ID,       COMMENT                                   )     '
            + ' VALUES                                                            '
            + '  (:pDEPT_CODE,   :pOPR_DATE,       :pOPR_TIME,                  '
            + '   :pACC_NO,                                                      '
            + '   :pJOB_GB,      :pTRG_GB,         :pTR_CODE,                        '
            + '   :pOPR_ID,      :pCOMMENT                                )  '
            );
{
       case pTRGGB[1] of
          LOG_TRG_GB_ADD   : MoveInsertData_Log(pTRGGB);                                    // �Է¹�ư
          LOG_TRG_GB_UPDATE:
          begin
            if pOriginAccNameKor = pCurAccNameKor then Exit;
            MoveUpdateData_Log(pTRGGB, pOriginAccNameKor, pCurAccNameKor); // ������ư
          end;
          LOG_TRG_GB_DELETE: MoveDeleteData_Log(pTRGGB);                                    // ������ư
       end;
}

      if pTRGGB = LOG_TRG_GB_ADD then         // �Է��� ��
      begin
        MoveInsertData_Log(pTRGGB, pLOGGB);
      end
      else if pTRGGB = LOG_TRG_GB_UPDATE then // ������ ��
      begin
        if ((pOriginRcvNameKor = pCurRcvNameKor) and (pOriginTelNo = pCurTelNo))  then        // �����, ��ȭ��ȣ ���� ���� X
          Exit
        else if ((pOriginRcvNameKor = pCurRcvNameKor) and (pOriginTelNo <> pCurTelNo)) then   // ����� ���� X
          MoveUpdateData_Log(pTRGGB, pLOGGB, '', '', pOriginTelNo, pCurTelNo)
        else if ((pOriginRcvNameKor <> pCurRcvNameKor) and (pOriginTelNo = pCurTelNo)) then   // ��ȭ��ȣ ���� X
          MoveUpdateData_Log(pTRGGB, pLOGGB, pOriginRcvNameKor, pCurRcvNameKor, '', '')
        else                                                                                  // �����, ��ȭ��ȣ ���� ���� O
          MoveUpdateData_Log(pTRGGB, pLOGGB, pOriginRcvNameKor, pCurRcvNameKor, pOriginTelNo, pCurTelNo);
      end
      else                                    // ������ ��
      begin
        MoveDeleteData_Log(pTRGGB, pLOGGB);
      end;

      Try
        gf_ADOExecSQL(ADOQuery_Log);
      Except
         on E : Exception do
         begin  // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Log[SZTRLOG_HIS]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Log[SZTRLOG_HIS]'); //Database ����
            Exit;
         end;
      End;

   end;
   Result := true;
end;

//==============================================================================
// �Է¹�ư ������ �� SZTRLOG_HIS�� �ֱ�
//==============================================================================
procedure TForm_SCFH8105.MoveInsertData_Log(pTRGGB, pLOGGB: string);
begin
  with ADOQuery_Log do
  begin
    // ���μ�
    Parameters.ParamByName('pDEPT_CODE').Value := gvDeptCode;
    // ��������
    Parameters.ParamByName('pOPR_DATE').Value := gvCurDate;
    // ���۽ð�
    Parameters.ParamByName('pOPR_TIME').Value := gf_GetCurTime;
    // ���¹�ȣ
    Parameters.ParamByName('pACC_NO').Value := Trim(DRUserDblCodeCombo_AccNo.Code);
    // �۾�����
    Parameters.ParamByName('pJOB_GB').Value := pLOGGB;
    // ó������
    Parameters.ParamByName('pTRG_GB').Value := pTRGGB;
    // ȭ��TR
    Parameters.ParamByName('pTR_CODE').Value := Trim(IntToStr(Self.Tag));
    // �۾���
    Parameters.ParamByName('pOPR_ID').Value := gvOprUsrNo;
    // �۾�����
    Parameters.ParamByName('pCOMMENT').Value := '[' + Trim(DRUserDblCodeCombo_AccNo.Code) + '] '
                                              + '[' + Trim(DREdit_FaxEmail.Text)          + '] '
                                              + '�Է�';
  end;
end;

//==============================================================================
// ������ư ������ �� SZTRLOG_HIS�� �ֱ�
//==============================================================================
procedure TForm_SCFH8105.MoveUpdateData_Log(pTRGGB, pLOGGB, pOriginRcvNameKor,
  pCurRcvNameKor, pOriginTelNo, pCurTelNo: string);
var
  UpdateCommentStr: string;
begin
  with ADOQuery_Log do
  begin
    // ���μ�
    Parameters.ParamByName('pDEPT_CODE').Value := gvDeptCode;
    // ��������
    Parameters.ParamByName('pOPR_DATE').Value := gvCurDate;
    // ���۽ð�
    Parameters.ParamByName('pOPR_TIME').Value := gf_GetCurTime;
    // ���¹�ȣ
    Parameters.ParamByName('pACC_NO').Value := Trim(DRUserDblCodeCombo_AccNo.Code);
    // �۾�����
    Parameters.ParamByName('pJOB_GB').Value := pLOGGB;
    // ó������
    Parameters.ParamByName('pTRG_GB').Value := pTRGGB;
    // ȭ��TR
    Parameters.ParamByName('pTR_CODE').Value := Trim(IntToStr(Self.Tag));
    // �۾���
    Parameters.ParamByName('pOPR_ID').Value := gvOprUsrNo;
    UpdateCommentStr := '[' + Trim(DRUserDblCodeCombo_AccNo.Code) + '] '
                      + '[' + Trim(DREdit_FaxEmail.Text)          + '] ';

    if not ((pOriginRcvNameKor = '') and (pCurRcvNameKor = '')) then  // ����� ���� O
      UpdateCommentStr := UpdateCommentStr + '�����: '   + pOriginRcvNameKor + ' -> ' +  pCurRcvNameKor + ',';
    if not ((pOriginTelNo = '') and (pCurTelNo = '')) then            // ��ȭ��ȣ ���� O
      UpdateCommentStr := UpdateCommentStr + '��ȭ��ȣ: ' + pOriginTelNo      + ' -> ' +  pCurTelNo;

    // ���� , �� ������ ��ȭ��ȣ�� ������ ���� ���� ���
    if RightStr(Trim(UpdateCommentStr),1) = ',' then
      UpdateCommentStr := Copy(UpdateCommentStr, 1, Length(UpdateCommentStr)-1);

    // �۾�����
    Parameters.ParamByName('pCOMMENT').Value := UpdateCommentStr;
  end;
end;

//==============================================================================
// ������ư ������ �� SZTRLOG_HIS�� �ֱ�
//==============================================================================
procedure TForm_SCFH8105.MoveDeleteData_Log(pTRGGB, pLOGGB: string);
begin
  with ADOQuery_Log do
  begin
    // ���μ�
    Parameters.ParamByName('pDEPT_CODE').Value := gvDeptCode;
    // ��������
    Parameters.ParamByName('pOPR_DATE').Value := gvCurDate;
    // ���۽ð�
    Parameters.ParamByName('pOPR_TIME').Value := gf_GetCurTime;
    // ���¹�ȣ
    Parameters.ParamByName('pACC_NO').Value := Trim(DRUserDblCodeCombo_AccNo.Code);
    // �۾�����
    Parameters.ParamByName('pJOB_GB').Value := pLOGGB;
    // ó������
    Parameters.ParamByName('pTRG_GB').Value := pTRGGB;
    // ȭ��TR
    Parameters.ParamByName('pTR_CODE').Value := Trim(IntToStr(Self.Tag));
    // �۾���
    Parameters.ParamByName('pOPR_ID').Value := gvOprUsrNo;
    // �۾�����
    Parameters.ParamByName('pCOMMENT').Value := '[' + Trim(DRUserDblCodeCombo_AccNo.Code) + '] '
                                              + '[' + Trim(DREdit_FaxEmail.Text)          + '] '
                                              + '����';
  end;
end;

end.
