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


    // 사용자 정의
    function QueryFax(pAccNo : string): integer; // 계좌번호에 해당하는 Fax 쿼리 조회
    function QueryEmail(pAccNo : string): integer; // 계좌번호에 해당하는 Email 쿼리 조회

    procedure ClearFaxList;
    procedure ClearEmailList;

    procedure ClearInputEdit;

    function RefreshAccNoCombo: boolean;

    function DisplayGridFaxEmail: Boolean;  // StrGrid에 Fax, Email DATA INPUT

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
                       pOriginTelNo:string = ''; pCurTelNo: string = ''         ): boolean;                    // SZTRLOG_HIS에 INSERT하는 함수
    procedure MoveInsertData_Log(pTRGGB, pLOGGB: string);                                                              // 입력버튼 눌렸을 때 SZTRLOG_HIS에 넣는함수
    procedure MoveUpdateData_Log(pTRGGB, pLOGGB, pOriginRcvNameKor, pCurRcvNameKor, pOriginTelNo, pCurTelNo:string);   // 수정버튼 눌렸을 때 SZTRLOG_HIS에 넣는함수
    procedure MoveDeleteData_Log(pTRGGB, pLOGGB: string);                                                              // 삭제버튼 눌렸을 때 SZTRLOG_HIS에 넣는함수
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
    AccNo       : string;     // 계좌번호
    SendType    : string;     // 전송구분
    MediaNo     : string;     // 팩스번호
    RcvNameKor  : string;     // 담당자
    TelNo       : string;     // 전화번호
  end;
  pTFaxItem = ^TFaxItem;

  TEmailItem = record         // Email List
    AccNo       : string;     // 계좌번호
    SendType    : string;     // 전송구분
    MailAddr    : string;     // 메일주소
    RcvNameKor  : string;     // 담당자
    TelNo       : string;     // 전화번호
  end;
  pTEmailItem = ^TEmailItem;

const
  IDX_SEND_TYPE    = 0;   // 전송구분  Col Index
  IDX_FAX_EMAIL    = 1;   // Fax | Email Col Index
  IDX_RCV_NAME_KOR = 2;   // 담당자 Col Index
  IDX_TEL_NO       = 3;   // 전화번호 Col Index

  SEND_TYPE_FAX = 'Fax';       // Fax Col
  SEND_TYPE_EMAIL ='Email';    // Email Col

  RADIO_SEND_TYPE_FAX   = 0;  // Radio Index Fax
  RADIO_SEND_TYPE_EMAIL = 1;  // Radio Index Email

  LOG_JOB_GB_FAX    = 'F';     // 작업구분 'Fax'
  LOG_JOB_GB_EMAIL  = 'E';     // 작업구분 'Email'
  LOG_TRG_GB_ADD    = 'I';     // 입력시 SZTRLOG_HIS 테이블 TRG_GB
  LOG_TRG_GB_UPDATE = 'U';     // 수정시 SZTRLOG_HIS 테이블 TRG_GB
  LOG_TRG_GB_DELETE = 'D';     // 삭제시 SZTRLOG_HIS 테이블 TRG_GB
var
  FaxList     : TList;                          // Fax List
  EmailList   : TList;                        // Email List
  SelColIdx : Integer;                          // StrGrid 선택된 Col Index
  SelRowIdx : Integer;                          // StrGrid 선택된 Row Index


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
//  Clear EmailList (이메일)
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
//  Clear FaxList (팩스)
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

  // List생성
  FaxList      := TList.Create;
  EmailList    := TList.Create;

  if (not Assigned(FaxList)) or (not Assigned(EmailList)) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); // List 생성 오류
    Close;
    Exit;
  end;

  if not RefreshAccNoCombo then Exit;

  // 필수입력 Edit
  DRUserDblCodeCombo_AccNo.EditColor := gcQueryEditColor;
  DREdit_FaxEmail.Color              := gcQueryEditColor;

end;

//==============================================================================
// 계좌번호에 해당하는 Email Query
//==============================================================================
function TForm_SCFH8105.QueryEmail(pAccNo: string): integer;
var
  EmailItem : pTEmailItem;
begin
  Result := 0;

  ClearEmailList;

  with ADOQuery_DECLN do
  begin
    // 해당 계좌 전체 Email
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
      begin  // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZMELDE_INS]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZMELDE_INS]'); //Database 오류
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
// 계좌번호에 해당하는 Fax Query
//==============================================================================
function TForm_SCFH8105.QueryFax(pAccNo: string): integer;
var
  FaxItem : pTFaxItem;
begin
  Result := 0;

  ClearFaxList;

  with ADOQuery_DECLN do
  begin
    // 해당 계좌 전체 Fax
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
      begin  // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZFAXDE_INS]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZFAXDE_INS]'); //Database 오류
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
// 계좌콤보 Refresh
//==============================================================================
function TForm_SCFH8105.RefreshAccNoCombo: boolean;
begin
  Result := False;
  with ADOQuery_DECLN do
  begin
    // 계좌
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
      begin  // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZACBIF_INS]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZACBIF_INS]'); //Database 오류
        Exit;
      end;
    End;

    DRUserDblCodeCombo_AccNo.ClearItems;
//    DRUserDblCodeCombo_AccNo.InsertAllItem := false;  // 전체 항목 추가
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
// 조회버튼 Click
//==============================================================================
procedure TForm_SCFH8105.DRBitBtn6Click(Sender: TObject);
var
  AccNo : String;
  RowCount : Integer;
begin
  inherited;
  gf_ShowMessage(MessageBar, mtInformation, 1020, ''); //조회 중입니다.
  DisableForm;

  ClearInputEdit;

  AccNo := Trim(DRUserDblCodeCombo_AccNo.Code);
  if AccNo = '' then   // 계좌번호
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, '계좌번호'); //입력 오류
    DRUserDblCodeCombo_AccNo.SetFocus;
    EnableForm;
    Exit;
  end;

  RowCount := QueryFax(AccNo) + QueryEmail(AccNo);
  DisplayGridFaxEmail;

   if RowCount <= 0 then
       gf_ShowMessage(MessageBar, mtInformation, 1018, '') //해당 내역이 없습니다.
   else
       gf_ShowMessage(MessageBar, mtInformation, 1021,
               gwQueryCnt + IntToStr(RowCount)); // 조회 완료

   DRStrGrid_FaxEmail.SetFocus;
   EnableForm;
end;

//==============================================================================
// DRStrGrid_FaxEmail EmailList, FaxList  생성
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
      gf_ShowMessage(MessageBar, mtInformation, 1018, ''); //해당 내역이 없습니다.
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

      // 전송구분
      Cells[IDX_SEND_TYPE, iRow] := sSendType;
      // Fax | Email
      Cells[IDX_FAX_EMAIL, iRow] := sFaxEmail;
      // 담당자
      Cells[IDX_RCV_NAME_KOR, iRow] := sRcvNameKor;
      // 전화번호
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

      // 전송구분
      Cells[IDX_SEND_TYPE, iRow] := sSendType;
      // Fax | Email
      Cells[IDX_FAX_EMAIL, iRow] := sFaxEmail;
      // 담당자
      Cells[IDX_RCV_NAME_KOR, iRow] := sRcvNameKor;
      // 전화번호
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
// 필수입력 항목 누락 확인
//==============================================================================
function TForm_SCFH8105.CheckKeyEditEmpty: boolean;
begin
   Result := true;

   // 계좌번호
   if Trim(DRUserDblCodeCombo_AccNo.Code) = '' then   // 계좌번호
   begin
      gf_ShowMessage(MessageBar, mtError, 1012, '계좌번호'); //입력 오류
      DRUserDblCodeCombo_AccNo.SetFocus;
      Exit;
   end;

  // Fax | Email
  if Trim(DREdit_FaxEmail.Text) = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, 'Fax | Email'); //입력 오류
    DREdit_FaxEmail.SetFocus;
    Exit;
  end;
   Result := false;
end;

//==============================================================================
// FaxEmail 그리드 더블클릭
//==============================================================================
procedure TForm_SCFH8105.DRStrGrid_FaxEmailSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  SelRowIdx := ARow;
end;

//==============================================================================
// FaxEmail 그리드 더블클릭
//==============================================================================
procedure TForm_SCFH8105.DRStrGrid_FaxEmailDblClick(Sender: TObject);
var
  sSendType, sAccNo, sFaxEmail : string;
  FaxItem : pTFaxItem;
  EmailItem : pTEmailItem;
begin
  inherited;
  gf_ClearMessage(MessageBar);

  sSendType := Trim(DRStrGrid_FaxEmail.Cells[IDX_SEND_TYPE, SelRowIdx]);  // 선택된 전송구분

  if SelRowIdx <= 0 then Exit;
  if sSendType = '' then exit;

  sAccNo := Trim(DRUserDblCodeCombo_AccNo.Code);
  sFaxEmail := Trim(DRStrGrid_FaxEmail.Cells[IDX_FAX_EMAIL, SelRowIdx]);
  // 라디오버튼 항목 체크
  if sSendType = SEND_TYPE_FAX then        // Fax
    DisplayToEdit_Fax(sAccNo, sFaxEmail)     // 더블클릭한 Fax 정보 가져오기
  else if sSendType = SEND_TYPE_EMAIL then // Email
    DisplayToEdit_Email(sAccNo, sFaxEmail);   // 더블클릭한 Email 정보 가져오기


  DREdit_FaxEmail.SetFocus;
end;

//==============================================================================
// StrGrid에서 해당 데이터에 해당되는 RowIndex 찾아 Select
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
  if SearchIdx > -1 then  //해당 데이터 존재시
     gf_SelectStrGridRow(DRStrGrid_FaxEmail, SearchIdx)
  else  //해당 데이터 존재하지 않을 경우 첫Row Select
     gf_SelectStrGridRow(DRStrGrid_FaxEmail, 1);
  Result := SearchIdx;
end;

//==============================================================================
// 해당 Email 데이터
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
         begin  // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZMELDE_INS]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZMELDE_INS]'); //Database 오류
            Exit;
         end;
      End;

      if RecordCount <= 0 then
      begin
         Result := true;
         Exit;
      end;
      // 각 Edit Input
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
// 해당 FAX 데이터
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
         begin  // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZFAXDE_INS]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZFAXDE_INS]'); //Database 오류
            Exit;
         end;
      End;

      if RecordCount <= 0 then
      begin
         Result := true;
         Exit;
      end;
      // 각 Edit Input

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

  // 라디오버튼 항목 체크
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
// 전화번호 Edit KeyPress
//==============================================================================
procedure TForm_SCFH8105.DREdit_PhoneKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if (not (Key in ['0'..'9'])) and (Key <> #13) and (Key <> #8) and (Key <> #45) then
  begin
    key := #0 ;
    gf_ShowMessage(MessageBar, mtError, 1045,''); // 숫자를 입력하십시요.
  end;
end;

//==============================================================================
// 입력버튼 Click
//==============================================================================
procedure TForm_SCFH8105.DRBitBtn5Click(Sender: TObject);
begin
  inherited;
  // 라디오버튼 항목 체크
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

  gf_ShowMessage(MessageBar, mtInformation, 1010, ''); //입력 중입니다.

  if CheckKeyEditEmpty then Exit;   //입력 누락 항목 확인

  // 끝에 세미콜론 넣기
  if RightStr(Trim(DREdit_FaxEmail.Text),1) <> ';' then
    DREdit_FaxEmail.Text := Trim(DREdit_FaxEmail.Text) + ';';

  CurAccNo    := Trim(DRUserDblCodeCombo_AccNo.Code);
  CurMailAddr := Trim(DREdit_FaxEmail.Text);


  DisableForm;
  // 계좌번호, MailAddr로 기존 등록 Check
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
     sql.add(   // Email 테이블 입력
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
           gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZMELDE_INS : INSERT]'); // Database 오류
           EnableForm;
           Exit;
        end;
     end;
  end;

  InsertLog(LOG_TRG_GB_ADD, LOG_JOB_GB_EMAIL);

  QueryEmail(CurAccNo);   // Email 조회쿼리
  DisplayGridFaxEmail; // 그리드에 데이터 INPUT

  SelectGridData_FaxEmail(CurMailAddr);
  ClearInputEdit;

  EnableForm;
  DREdit_FaxEmail.SetFocus;
  gf_ShowMessage(MessageBar, mtInformation, 1011, ''); // 입력 완료
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

  gf_ShowMessage(MessageBar, mtInformation, 1010, ''); //입력 중입니다.

  if CheckKeyEditEmpty then Exit;   //입력 누락 항목 확인

  CurAccNo    := Trim(DRUserDblCodeCombo_AccNo.Code);
  CurMediaNo := Trim(DREdit_FaxEmail.Text);

  DisableForm;
  // 계좌번호, 팩스번호로 기존 등록 Check
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
     sql.add(   // Fax 테이블 입력
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
           gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZFAXDE_INS : INSERT]'); // Database 오류
           EnableForm;
           Exit;
        end;
     end;
  end;

  InsertLog(LOG_TRG_GB_ADD, LOG_JOB_GB_FAX);

  QueryFax(CurAccNo);   // Fax 조회쿼리
  DisplayGridFaxEmail; // 그리드에 데이터 INPUT

  SelectGridData_FaxEmail(CurMediaNo);
  ClearInputEdit;

  EnableForm;
  DREdit_FaxEmail.SetFocus;
  gf_ShowMessage(MessageBar, mtInformation, 1011, ''); // 입력 완료
  Result := true;
end;

//==============================================================================
// Email 존재하는지 Check
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
         begin  // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZMELDE_INS]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZMELDE_INS]'); //Database 오류
            Exit;
         end;
      End;

      if RecordCount >= 1  then
      begin
        gf_ShowMessage(MessageBar, mtError, 1024, 'Email'); // 해당 자료가 이미 존재합니다.
        exit;
      end;
   end;
   Result := true;
end;

//==============================================================================
// Fax 존재하는지 Check
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
         begin  // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZFAXDE_INS]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZFAXDE_INS]'); //Database 오류
            Exit;
         end;
      End;

      if RecordCount >= 1  then
      begin
        gf_ShowMessage(MessageBar, mtError, 1024, 'Fax'); // 해당 자료가 이미 존재합니다.
        exit;
      end;
   end;
   Result := true;
end;

//==============================================================================
// Email 정보 Insert
//==============================================================================
procedure TForm_SCFH8105.MoveInsertData_Email;
begin
  with ADOQuery_DECLN do
  begin
    // 담당부서
    Parameters.ParamByName('pDEPT_CODE').Value := gvDeptCode;
    // 계좌번호
    Parameters.ParamByName('pACC_NO').Value := Trim(DRUserDblCodeCombo_AccNo.Code);
    // 수신처 구분
    Parameters.ParamByName('pSEND_MTD').Value := 'R';
    // 메일주소
    Parameters.ParamByName('pMAIL_ADDR').Value := Trim(DREdit_FaxEmail.Text);
    // 담당자
    Parameters.ParamByName('pRCV_NAME_KOR').Value := Trim(DREdit_Name.Text);
    // 전화번호
    Parameters.ParamByName('pTEL_NO').Value := Trim(DREdit_Phone.Text);
    // 전송중지
    Parameters.ParamByName('pSEND_STOP').Value := 'N';
    // 수작업여부
    Parameters.ParamByName('pMANUAL_YN').Value := 'N';
    // 조작자 ID
    Parameters.ParamByName('pOPR_ID').Value := gvOprUsrNo;
    // 조작일자
    Parameters.ParamByName('pOPR_DATE').Value := gvCurDate;
    // 조작시간
    Parameters.ParamByName('pOPR_TIME').Value := gf_GetCurTime;
{
    // Import ID
    Parameters.ParamByName('pIMPORT_ID').Value := Trim(DREdit_ImportID);
    // Import일자
    Parameters.ParamByName('pIMPORT_DATE').Value := '';
    // Import시간
    Parameters.ParamByName('pIMPORT_TIME').Value := '';
}
  end;
end;

//==============================================================================
// Fax 정보 Insert
//==============================================================================
procedure TForm_SCFH8105.MoveInsertData_Fax;
begin
  with ADOQuery_DECLN do
  begin
    // 담당부서
    Parameters.ParamByName('pDEPT_CODE').Value := gvDeptCode;
    // 계좌번호
    Parameters.ParamByName('pACC_NO').Value := Trim(DRUserDblCodeCombo_AccNo.Code);
    // 팩스번호
    Parameters.ParamByName('pMEDIA_NO').Value := Trim(DREdit_FaxEmail.Text);
    // 담당자
    Parameters.ParamByName('pRCV_NAME_KOR').Value := Trim(DREdit_Name.Text);
    // 전화번호
    Parameters.ParamByName('pTEL_NO').Value := Trim(DREdit_Phone.Text);
    // 전송중지
    Parameters.ParamByName('pSEND_STOP').Value := 'N';
    // 수작업여부
    Parameters.ParamByName('pMANUAL_YN').Value := 'N';
    // 조작자 ID
    Parameters.ParamByName('pOPR_ID').Value := gvOprUsrNo;
    // 조작일자
    Parameters.ParamByName('pOPR_DATE').Value := gvCurDate;
    // 조작시간
    Parameters.ParamByName('pOPR_TIME').Value := gf_GetCurTime;
{
    // Import ID
    Parameters.ParamByName('pIMPORT_ID').Value := Trim(DREdit_ImportID);
    // Import일자
    Parameters.ParamByName('pIMPORT_DATE').Value := '';
    // Import시간
    Parameters.ParamByName('pIMPORT_TIME').Value := '';
}
  end;
end;


//==============================================================================
// 수정버튼 Click
//==============================================================================
procedure TForm_SCFH8105.DRBitBtn4Click(Sender: TObject);
begin
  inherited;
  // 라디오버튼 항목 체크
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
// Email 수정
//==============================================================================
function TForm_SCFH8105.DataUpdate_Email: boolean;
var
   OriginRcvNameKor, CurRcvNameKor: string;
   OriginTelNo, CurTelNo: string;
   CurAccNo: string;
   CurMailAddr : string;
begin
   Result := false;
   gf_ShowMessage(MessageBar, mtInformation, 1007, ''); //수정 중입니다.

   if CheckKeyEditEmpty then Exit;   // Key Field Edit에 누락 항목

   CurAccNo := Trim(DRUserDblCodeCombo_AccNo.Code);
   CurMailAddr := Trim(DREdit_FaxEmail.Text);
   DisableForm;

   // 계좌번호, 메일주소로 기존 등록 Check
   if not UpdateDel_EmailNoChk(CurAccNo, CurMailAddr) then
   begin
      EnableForm;
      DREdit_FaxEmail.SetFocus;
      Exit;
   end;

   // 기존 담당자
   OriginRcvNameKor := Trim(ADOQuery_DECLN.FieldByName('RCV_NAME_KOR').AsString);
   // 변경 담당자
   CurRcvNameKor    := Trim(DREdit_Name.Text);
   // 기존 전화번호
   OriginTelNo := Trim(ADOQuery_DECLN.FieldByName('TEL_NO').AsString);
   // 변경 전화번호
   CurTelNo    := Trim(DREdit_Phone.Text);

   // 변경내역 없으면
   if ((OriginRcvNameKor = CurRcvNameKor) and (OriginTelNo = CurTelNo))  then
   begin
     SelectGridData_FaxEmail(CurMailAddr);

     EnableForm;
     DREdit_FaxEmail.SetFocus;
     gf_ShowMessage(MessageBar, mtInformation, 0, '변경사항이 없습니다.'); // 수정 X
     Exit;
   end;
   with ADOQuery_DECLN do
   begin
      Close;
      sql.clear;
      sql.add(   // Email 테이블 수정
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
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZMELDE_INS : UPDATE]'); // Database 오류
            EnableForm;
            Exit;
         end;
      end;//try
   end; //with

   InsertLog(LOG_TRG_GB_UPDATE, LOG_JOB_GB_EMAIL, OriginRcvNameKor, CurRcvNameKor, OriginTelNo, CurTelNo);

   QueryEmail(CurAccNo);   // Email 조회쿼리
   DisplayGridFaxEmail; // 그리드에 데이터 INPUT

   SelectGridData_FaxEmail(CurMailAddr);
   ClearInputEdit;

   EnableForm;
   DREdit_FaxEmail.SetFocus;
   gf_ShowMessage(MessageBar, mtInformation, 1008, ''); // 수정 완료
   Result := true;

end;

//==============================================================================
// Fax 수정
//==============================================================================
function TForm_SCFH8105.DataUpdate_Fax: boolean;
var
   OriginRcvNameKor, CurRcvNameKor: string;
   OriginTelNo, CurTelNo: string;
   CurAccNo: string;
   CurMediaNo : string;
begin
   Result := false;
   gf_ShowMessage(MessageBar, mtInformation, 1007, ''); //수정 중입니다.

   if CheckKeyEditEmpty then Exit;   // Key Field Edit에 누락 항목

   CurAccNo := Trim(DRUserDblCodeCombo_AccNo.Code);
   CurMediaNo := Trim(DREdit_FaxEmail.Text);
   DisableForm;

   // 계좌번호, 팩스번호로 기존 등록 Check
   if not UpdateDel_FaxNoChk(CurAccNo, CurMediaNo) then
   begin
      EnableForm;
      DREdit_FaxEmail.SetFocus;
      Exit;
   end;

   // 기존 담당자
   OriginRcvNameKor := Trim(ADOQuery_DECLN.FieldByName('RCV_NAME_KOR').AsString);
   // 변경 담당자
   CurRcvNameKor    := Trim(DREdit_Name.Text);
   // 기존 전화번호
   OriginTelNo := Trim(ADOQuery_DECLN.FieldByName('TEL_NO').AsString);
   // 변경 전화번호
   CurTelNo    := Trim(DREdit_Phone.Text);

   // 변경내역 없으면
   if ((OriginRcvNameKor = CurRcvNameKor) and (OriginTelNo = CurTelNo))  then
   begin
     SelectGridData_FaxEmail(CurMediaNo);

     EnableForm;
     DREdit_FaxEmail.SetFocus;
     gf_ShowMessage(MessageBar, mtInformation, 0, '변경사항이 없습니다.'); // 수정 X
     Exit;
   end;
   with ADOQuery_DECLN do
   begin
      Close;
      sql.clear;
      sql.add(   // Fax 테이블 수정
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
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZFAXDE_INS : UPDATE]'); // Database 오류
            EnableForm;
            Exit;
         end;
      end;//try
   end; //with

   InsertLog(LOG_TRG_GB_UPDATE, LOG_JOB_GB_FAX, OriginRcvNameKor, CurRcvNameKor, OriginTelNo, CurTelNo);

   QueryFax(CurAccNo);   // Fax 조회쿼리
   DisplayGridFaxEmail; // 그리드에 데이터 INPUT

   SelectGridData_FaxEmail(CurMediaNo);
   ClearInputEdit;

   EnableForm;
   DREdit_FaxEmail.SetFocus;
   gf_ShowMessage(MessageBar, mtInformation, 1008, ''); // 수정 완료
   Result := true;
end;

//==============================================================================
// Fax | Email 정보 Update
//==============================================================================
procedure TForm_SCFH8105.MoveUpdateData;
begin
  with ADOQuery_DECLN do
  begin
    // 담당부서
    Parameters.ParamByName('pDEPT_CODE').Value := gvDeptCode;
    // 담당자
    Parameters.ParamByName('pRCV_NAME_KOR').Value := Trim(DREdit_Name.Text);
    // 전화번호
    Parameters.ParamByName('pTEL_NO').Value := Trim(DREdit_Phone.Text);
    // 조작자 ID
    Parameters.ParamByName('pOPR_ID').Value := gvOprUsrNo;
    // 조작일자
    Parameters.ParamByName('pOPR_DATE').Value := gvCurDate;
    // 조작시간
    Parameters.ParamByName('pOPR_TIME').Value := gf_GetCurTime;
{
    // Import ID
    Parameters.ParamByName('pIMPORT_ID').Value := Trim(DREdit_ImportID);
    // Import일자
    Parameters.ParamByName('pIMPORT_DATE').Value := '';
    // Import시간
    Parameters.ParamByName('pIMPORT_TIME').Value := '';
}
  end;
end;


//==============================================================================
// Fax 등록 check -update/delete시 check
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
         begin  // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZFAXDE_INS]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZFAXDE_INS]'); //Database 오류
            Exit;
         end;
      End;

      if RecordCount <= 0  then
      begin
         gf_ShowMessage(MessageBar, mtError, 1025, 'Fax'); //해당 자료가 존재하지 않습니다.
         exit;
      end;
   end;
   Result := true;
end;

//==============================================================================
// Email 등록 check -update/delete시 check
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
         begin  // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZMELDE_INS]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZMELDE_INS]'); //Database 오류
            Exit;
         end;
      End;

      if RecordCount <= 0  then
      begin
         gf_ShowMessage(MessageBar, mtError, 1025, 'Email'); //해당 자료가 존재하지 않습니다.
         exit;
      end;
   end;
   Result := true;
end;

//==============================================================================
// 삭제버튼 Click
//==============================================================================
procedure TForm_SCFH8105.DRBitBtn3Click(Sender: TObject);
begin
  inherited;
  // 라디오버튼 항목 체크
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
// Fax 삭제
//==============================================================================
function TForm_SCFH8105.DataDelete_Fax: boolean;
var
   CurAccNo : string;
   CurMediaNo : string;
   DeleteStr : string;
begin
   inherited;
   Result := false;

   if CheckKeyEditEmpty then Exit;   // Key Field Edit에 누락 항목

   CurAccNo := Trim(DRUserDblCodeCombo_AccNo.Code);
   CurMediaNo := Trim(DREdit_FaxEmail.Text);
   DeleteStr := '(' + CurAccNo + ': ' + CurMediaNo + ')';


   try

      // 계좌, 팩스번호로 기존 등록 Check
      if not UpdateDel_FaxNoChk(CurAccNo, CurMediaNo) then
      begin
//         EnableForm;
         DREdit_FaxEmail.SetFocus;
         Exit;
      end;

      // Confirm - 정말 삭제하시겠습니까?
      if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 0, '정말 삭제하시겠습니까?', mbOKCancel, 0) = idcancel then
      begin
        gf_ShowMessage(MessageBar, mtInformation, 1082, '');  // 작업이 취소되었습니다.
        Exit;
      end;

      DisableForm;
      gf_ShowMessage(MessageBar, mtInformation, 1005, ''); //삭제 중입니다.

      with ADOQuery_DECLN do
      begin
        Close;
        sql.clear;
        sql.add(   // Fax 테이블 삭제
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
              gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZFAXDE_INS : DELETE]'); // Database 오류
 //                  EnableForm;
              Exit;
           end;
        end;  //try
      end; //  with

      InsertLog(LOG_TRG_GB_DELETE, LOG_JOB_GB_FAX);

      QueryFax(CurAccNo);   // Fax 조회쿼리
      DisplayGridFaxEmail; // 그리드에 데이터 INPUT

      SelectGridData_FaxEmail(CurMediaNo);
      ClearInputEdit;

      DREdit_FaxEmail.SetFocus;
      gf_ShowMessage(MessageBar, mtInformation, 1006, DeleteStr ); // 삭제 완료
      Result := true;
   finally
      EnableForm;
   end;
end;

//==============================================================================
// Email 삭제
//==============================================================================
function TForm_SCFH8105.DataDelete_Email: boolean;
var
   CurAccNo : string;
   CurMailAddr : string;
   DeleteStr : string;
begin
   inherited;
   Result := false;

   if CheckKeyEditEmpty then Exit;   // Key Field Edit에 누락 항목

   CurAccNo := Trim(DRUserDblCodeCombo_AccNo.Code);
   CurMailAddr := Trim(DREdit_FaxEmail.Text);
   DeleteStr := '(' + CurAccNo + ': ' + CurMailAddr + ')';


   try

      // 계좌, 메일주소로 기존 등록 Check
      if not UpdateDel_EmailNoChk(CurAccNo, CurMailAddr) then
      begin
//         EnableForm;
         DREdit_FaxEmail.SetFocus;
         Exit;
      end;

      // Confirm - 정말 삭제하시겠습니까?
      if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 0, '정말 삭제하시겠습니까?', mbOKCancel, 0) = idcancel then
      begin
        gf_ShowMessage(MessageBar, mtInformation, 1082, '');  // 작업이 취소되었습니다.
        Exit;
      end;

      DisableForm;
      gf_ShowMessage(MessageBar, mtInformation, 1005, ''); //삭제 중입니다.

      with ADOQuery_DECLN do
      begin
        Close;
        sql.clear;
        sql.add(   // Email 테이블 삭제
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
              gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZMELDE_INS : DELETE]'); // Database 오류
 //                  EnableForm;
              Exit;
           end;
        end;  //try
      end; //  with

      InsertLog(LOG_TRG_GB_DELETE, LOG_JOB_GB_EMAIL);

      QueryEmail(CurAccNo);   // Email 조회쿼리
      DisplayGridFaxEmail; // 그리드에 데이터 INPUT

      SelectGridData_FaxEmail(CurMailAddr);
      ClearInputEdit;

      DREdit_FaxEmail.SetFocus;
      gf_ShowMessage(MessageBar, mtInformation, 1006, DeleteStr ); // 삭제 완료
      Result := true;
   finally
      EnableForm;
   end;
end;

//==============================================================================
// 인쇄버튼 Click
//==============================================================================
procedure TForm_SCFH8105.DRBitBtn2Click(Sender: TObject);
begin
  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1100, ''); // 인쇄 중입니다.

   with DrStringPrint1 do
   begin
      Title  := DRPanel_Title.Caption;
      UserText1  := '';
      UserText2  := '';

      StringGrid := DRStrGrid_FaxEmail;
//      Orientation  := poPortrait;   //poLandscape;

      Print;
   end;

   gf_ShowMessage(MessageBar, mtInformation, 1101, ''); // 인쇄 완료
end;

procedure TForm_SCFH8105.FormShow(Sender: TObject);
begin
  inherited;
  DRUserDblCodeCombo_AccNo.SetFocus;
end;

procedure TForm_SCFH8105.DREdit_KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
   if (Key = #13) and (ActiveControl is TWinControl) then   // 다음 Control로 이동
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

   if (Key = #13) and (ActiveControl is TWinControl) then   // 다음 Control로 이동
   begin
      gf_ClearMessage(MessageBar);
      SelectNext(ActiveControl as TWinControl, True, True);
      Exit;
   end;

  // 라디오버튼 항목 체크
  if DRRadioGroup_SndType.ItemIndex = RADIO_SEND_TYPE_FAX then  // Fax
  begin
    if (not (Key in ['0'..'9'])) and (Key <> #8) and (Key <> #45) then
    begin
      key := #0;
      gf_ShowMessage(MessageBar, mtError, 1045,''); // 숫자를 입력하십시요.
    end;
  end;

end;

//==============================================================================
// 계좌번호 KeyPress
//==============================================================================
procedure TForm_SCFH8105.DRUserDblCodeCombo_AccNoEditKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;

   if (Key = #13) and (ActiveControl is TWinControl) then   // 다음 Control로 이동
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
     sql.add(   // LOG 테이블 입력
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
          LOG_TRG_GB_ADD   : MoveInsertData_Log(pTRGGB);                                    // 입력버튼
          LOG_TRG_GB_UPDATE:
          begin
            if pOriginAccNameKor = pCurAccNameKor then Exit;
            MoveUpdateData_Log(pTRGGB, pOriginAccNameKor, pCurAccNameKor); // 수정버튼
          end;
          LOG_TRG_GB_DELETE: MoveDeleteData_Log(pTRGGB);                                    // 삭제버튼
       end;
}

      if pTRGGB = LOG_TRG_GB_ADD then         // 입력일 때
      begin
        MoveInsertData_Log(pTRGGB, pLOGGB);
      end
      else if pTRGGB = LOG_TRG_GB_UPDATE then // 수정일 때
      begin
        if ((pOriginRcvNameKor = pCurRcvNameKor) and (pOriginTelNo = pCurTelNo))  then        // 담당자, 전화번호 전부 변경 X
          Exit
        else if ((pOriginRcvNameKor = pCurRcvNameKor) and (pOriginTelNo <> pCurTelNo)) then   // 담당자 변경 X
          MoveUpdateData_Log(pTRGGB, pLOGGB, '', '', pOriginTelNo, pCurTelNo)
        else if ((pOriginRcvNameKor <> pCurRcvNameKor) and (pOriginTelNo = pCurTelNo)) then   // 전화번호 변경 X
          MoveUpdateData_Log(pTRGGB, pLOGGB, pOriginRcvNameKor, pCurRcvNameKor, '', '')
        else                                                                                  // 담당자, 전화번호 전부 변경 O
          MoveUpdateData_Log(pTRGGB, pLOGGB, pOriginRcvNameKor, pCurRcvNameKor, pOriginTelNo, pCurTelNo);
      end
      else                                    // 삭제일 때
      begin
        MoveDeleteData_Log(pTRGGB, pLOGGB);
      end;

      Try
        gf_ADOExecSQL(ADOQuery_Log);
      Except
         on E : Exception do
         begin  // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Log[SZTRLOG_HIS]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Log[SZTRLOG_HIS]'); //Database 오류
            Exit;
         end;
      End;

   end;
   Result := true;
end;

//==============================================================================
// 입력버튼 눌렸을 때 SZTRLOG_HIS에 넣기
//==============================================================================
procedure TForm_SCFH8105.MoveInsertData_Log(pTRGGB, pLOGGB: string);
begin
  with ADOQuery_Log do
  begin
    // 담당부서
    Parameters.ParamByName('pDEPT_CODE').Value := gvDeptCode;
    // 조작일자
    Parameters.ParamByName('pOPR_DATE').Value := gvCurDate;
    // 조작시간
    Parameters.ParamByName('pOPR_TIME').Value := gf_GetCurTime;
    // 계좌번호
    Parameters.ParamByName('pACC_NO').Value := Trim(DRUserDblCodeCombo_AccNo.Code);
    // 작업구분
    Parameters.ParamByName('pJOB_GB').Value := pLOGGB;
    // 처리구분
    Parameters.ParamByName('pTRG_GB').Value := pTRGGB;
    // 화면TR
    Parameters.ParamByName('pTR_CODE').Value := Trim(IntToStr(Self.Tag));
    // 작업자
    Parameters.ParamByName('pOPR_ID').Value := gvOprUsrNo;
    // 작업내용
    Parameters.ParamByName('pCOMMENT').Value := '[' + Trim(DRUserDblCodeCombo_AccNo.Code) + '] '
                                              + '[' + Trim(DREdit_FaxEmail.Text)          + '] '
                                              + '입력';
  end;
end;

//==============================================================================
// 수정버튼 눌렸을 때 SZTRLOG_HIS에 넣기
//==============================================================================
procedure TForm_SCFH8105.MoveUpdateData_Log(pTRGGB, pLOGGB, pOriginRcvNameKor,
  pCurRcvNameKor, pOriginTelNo, pCurTelNo: string);
var
  UpdateCommentStr: string;
begin
  with ADOQuery_Log do
  begin
    // 담당부서
    Parameters.ParamByName('pDEPT_CODE').Value := gvDeptCode;
    // 조작일자
    Parameters.ParamByName('pOPR_DATE').Value := gvCurDate;
    // 조작시간
    Parameters.ParamByName('pOPR_TIME').Value := gf_GetCurTime;
    // 계좌번호
    Parameters.ParamByName('pACC_NO').Value := Trim(DRUserDblCodeCombo_AccNo.Code);
    // 작업구분
    Parameters.ParamByName('pJOB_GB').Value := pLOGGB;
    // 처리구분
    Parameters.ParamByName('pTRG_GB').Value := pTRGGB;
    // 화면TR
    Parameters.ParamByName('pTR_CODE').Value := Trim(IntToStr(Self.Tag));
    // 작업자
    Parameters.ParamByName('pOPR_ID').Value := gvOprUsrNo;
    UpdateCommentStr := '[' + Trim(DRUserDblCodeCombo_AccNo.Code) + '] '
                      + '[' + Trim(DREdit_FaxEmail.Text)          + '] ';

    if not ((pOriginRcvNameKor = '') and (pCurRcvNameKor = '')) then  // 담당자 변경 O
      UpdateCommentStr := UpdateCommentStr + '담당자: '   + pOriginRcvNameKor + ' -> ' +  pCurRcvNameKor + ',';
    if not ((pOriginTelNo = '') and (pCurTelNo = '')) then            // 전화번호 변경 O
      UpdateCommentStr := UpdateCommentStr + '전화번호: ' + pOriginTelNo      + ' -> ' +  pCurTelNo;

    // 끝에 , 가 있으면 전화번호는 변경이 되지 않은 경우
    if RightStr(Trim(UpdateCommentStr),1) = ',' then
      UpdateCommentStr := Copy(UpdateCommentStr, 1, Length(UpdateCommentStr)-1);

    // 작업내용
    Parameters.ParamByName('pCOMMENT').Value := UpdateCommentStr;
  end;
end;

//==============================================================================
// 삭제버튼 눌렸을 때 SZTRLOG_HIS에 넣기
//==============================================================================
procedure TForm_SCFH8105.MoveDeleteData_Log(pTRGGB, pLOGGB: string);
begin
  with ADOQuery_Log do
  begin
    // 담당부서
    Parameters.ParamByName('pDEPT_CODE').Value := gvDeptCode;
    // 조작일자
    Parameters.ParamByName('pOPR_DATE').Value := gvCurDate;
    // 조작시간
    Parameters.ParamByName('pOPR_TIME').Value := gf_GetCurTime;
    // 계좌번호
    Parameters.ParamByName('pACC_NO').Value := Trim(DRUserDblCodeCombo_AccNo.Code);
    // 작업구분
    Parameters.ParamByName('pJOB_GB').Value := pLOGGB;
    // 처리구분
    Parameters.ParamByName('pTRG_GB').Value := pTRGGB;
    // 화면TR
    Parameters.ParamByName('pTR_CODE').Value := Trim(IntToStr(Self.Tag));
    // 작업자
    Parameters.ParamByName('pOPR_ID').Value := gvOprUsrNo;
    // 작업내용
    Parameters.ParamByName('pCOMMENT').Value := '[' + Trim(DRUserDblCodeCombo_AccNo.Code) + '] '
                                              + '[' + Trim(DREdit_FaxEmail.Text)          + '] '
                                              + '삭제';
  end;
end;

end.
