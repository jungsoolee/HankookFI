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

    // 사용자 정의
    function QueryLog: integer; // SZTRLOG_HIS 쿼리 조회

    procedure ClearLogList;

    function DisplayGridLog: Boolean; // StrGrid에 Log DATA INPUT

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
    OprDateTime : string;     // 변경일시
    OprId       : string;     // 조작자
    AccNo       : string;     // 계좌번호
    JobGB       : string;     // 자료구분
    TrCode      : string;     // 화면
    TrgGB       : string;     // 구분
    Comment     : string;     // 변경내역
  end;
  pTLogItem = ^TLogItem;


const
  IDX_SEQUENCE         = 0;   // 시퀀스  Col Index
  IDX_OPR_DATE_TIME    = 1;   // 변경일시 Col Index
  IDX_OPR_ID           = 2;   // 조작자 Col Index
  IDX_ACC_NO           = 3;   // 계좌번호 Col Index
  IDX_JOB_GB           = 4;   // 자료구분 Col Index
  IDX_TR_CODE          = 5;   // 화면 Col Index
  IDX_TRG_GB           = 6;   // 구분 Col Index
  IDX_COMMENT          = 7;   // 변경내역 Col Index

  LOG_JOB_GB_ACC    = 'A';     // 작업구분 '계좌정보'
  LOG_JOB_GB_FAX    = 'F';     // 작업구분 'Fax'
  LOG_JOB_GB_EMAIL  = 'E';     // 작업구분 'Email'

  LOG_TRG_GB_ADD    = 'I';     // 처리구분 추가
  LOG_TRG_GB_UPDATE = 'U';     // 처리구분 수정
  LOG_TRG_GB_DELETE = 'D';     // 처리구분 삭제
  LOG_TRG_GB_IMPORT = 'N';     // 처리구분 Import
var
  LogList     : TList;                          // Log List
  SelColIdx : Integer;                          // StrGrid 선택된 Col Index
  SelRowIdx : Integer;                          // StrGrid 선택된 Row Index

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
// StrGrid에 Log DATA INPUT
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
      gf_ShowMessage(MessageBar, mtInformation, 1018, ''); //해당 내역이 없습니다.
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

      // 작업구분
      if sJobGB = LOG_JOB_GB_ACC then          // A
        sJobGB := '계좌정보'
      else if sJobGB = LOG_JOB_GB_FAX then     // F
        sJobGB := 'Fax'
      else if sJobGB = LOG_JOB_GB_EMAIL then   // E
        sJobGB := 'Email';

      // 처리구분
      if sTrgGB = LOG_TRG_GB_IMPORT then       // N
        sTrgGB := 'Import'
      else if sTrgGB = LOG_TRG_GB_ADD then     // I
        sTrgGB := '입력'
      else if sTrgGB = LOG_TRG_GB_UPDATE then  // U
        sTrgGB := '수정'
      else if sTrgGB = LOG_TRG_GB_DELETE then  // D
        sTrgGB := '삭제';

      // No
      Cells[IDX_SEQUENCE, iRow] := sSequence;
      // 변경일시
      Cells[IDX_OPR_DATE_TIME, iRow] := sOprDateTime;
      // 조작자
      Cells[IDX_OPR_ID, iRow] := sOprId;
      // 계좌번호
      Cells[IDX_ACC_NO, iRow] := sAccNo;
      // 자료구분
      Cells[IDX_JOB_GB, iRow] := sJobGB;
      // 화면
      Cells[IDX_TR_CODE, iRow] := sTrCode;
      // 구분
      Cells[IDX_TRG_GB, iRow] := sTrgGB;
      // 변경내역
      Cells[IDX_COMMENT, iRow] := sComment;
      HintCell[IDX_COMMENT, iRow] := sComment;
    end;
  end;

  Result := True;
end;

//==============================================================================
// SZTRLOG_HIS 쿼리 조회
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
    // 전체 Log
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
    // 일자조회
    SQL.Add('  AND L.OPR_DATE >= '''+ Trim(DRMaskEdit_OprSDate.Text) +''' '
           +'  AND L.OPR_DATE <= '''+ Trim(DRMaskEdit_OprEDate.Text) +''' ');
    // 계좌
    if Trim(DRUserDblCodeCombo_Acc.Code) <> '전체' then
      SQL.Add('  AND L.ACC_NO = ''' + Trim(DRUserDblCodeCombo_Acc.Code) + ''' ');
    // 조작자
    if Trim(DRUserCodeCombo_User.Code) <> '전체' then
      SQL.Add('  AND L.OPR_ID = ''' + Trim(DRUserCodeCombo_User.Code) + ''' ');
    // 자료
    if Trim(DRUserCodeCombo_JobGB.Code) <> '전체' then
    begin
      SQL.Add('  AND L.JOB_GB = ''' + Trim(DRUserCodeCombo_JobGB.Code) + ''' ');
    end;

    SQL.Add(' ORDER BY L.OPR_DATE, L.OPR_TIME, L.JOB_GB                                  ');

    Try
      gf_ADOQueryOpen(ADOQuery_DECLN);
    Except
      on E : Exception do
      begin  // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZTRLOG_HIS]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZTRLOG_HIS]'); //Database 오류
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

  // List생성
  LogList := TList.Create;

  if not Assigned(LogList) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); // List 생성 오류
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
// 조회버튼 Click
//==============================================================================
procedure TForm_SCFH8111.DRBitBtn3Click(Sender: TObject);
var
  RowCount : Integer;
begin
  inherited;
  gf_ShowMessage(MessageBar, mtInformation, 1020, ''); //조회 중입니다.

  if CheckKeyEditEmpty then Exit;

  DisableForm;

  RowCount := QueryLog;
  DisplayGridLog;

  if RowCount <= 0 then
     gf_ShowMessage(MessageBar, mtInformation, 1018, '') //해당 내역이 없습니다.
  else
     gf_ShowMessage(MessageBar, mtInformation, 1021,
             gwQueryCnt + IntToStr(RowCount)); // 조회 완료

   DRStrGrid_Log.SetFocus;
   EnableForm;
end;

//==============================================================================
// 계좌콤보 Refresh
//==============================================================================
function TForm_SCFH8111.RefreshAccNoCombo: boolean;
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

    DRUserDblCodeCombo_Acc.ClearItems;
//    DRUserDblCodeCombo_Acc.InsertAllItem := false;  // 전체 항목 X
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
// 자료콤보 Refresh
//==============================================================================
function TForm_SCFH8111.RefreshJobGBCombo: boolean;
begin
  Result := False;

  DRUserCodeCombo_JobGB.ClearItems;
//  DRUserCodeCombo_JobGB.InsertAllItem := false;  // 전체 항목 X

  DRUserCodeCombo_JobGB.AddItem(LOG_JOB_GB_ACC, '계좌정보');
  DRUserCodeCombo_JobGB.AddItem(LOG_JOB_GB_FAX, 'Fax');
  DRUserCodeCombo_JobGB.AddItem(LOG_JOB_GB_EMAIL, 'Email');
  Result := True;
end;

//==============================================================================
// 조작자콤보 Refresh
//==============================================================================
function TForm_SCFH8111.RefreshUserCombo: boolean;
begin
  Result := False;
  with ADOQuery_DECLN do
  begin
    // 조작자
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
      begin  // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SUUSER_TBL]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SUUSER_TBL]'); //Database 오류
        Exit;
      end;
    End;

    DRUserCodeCombo_User.ClearItems;
//    DRUserCodeCombo_User.InsertAllItem := false;  // 전체 항목 X

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

  DRUserDblCodeCombo_Acc.AssignCode('전체');
  DRUserCodeCombo_User.AssignCode('전체');
  DRUserCodeCombo_JobGB.AssignCode('전체');

  DRMaskEdit_OprSDate.SetFocus;
end;

//==============================================================================
// 필수입력 항목 누락 확인
//==============================================================================
function TForm_SCFH8111.CheckKeyEditEmpty: boolean;
begin
   Result := true;

   // 조작시작일 체크(입력값오류)
   if Trim(DRMaskEdit_OprSDate.Text) <> '' then
   begin
      if gf_CheckValidDate(DRMaskEdit_OprSDate.Text) = False then
      begin
         gf_ShowMessage(MessageBar, mtError, 1040, '(조작일)'); //일자 입력 오류
         DRMaskEdit_OprSDate.SetFocus;
         Exit;
      end;
   end;
   // 조작종료일 체크(입력값오류)
   if Trim(DRMaskEdit_OprEDate.Text) <> '' then
   begin
      if gf_CheckValidDate(DRMaskEdit_OprEDate.Text) = False then
      begin
         gf_ShowMessage(MessageBar, mtError, 1040, '(조작일)'); //일자 입력 오류
         DRMaskEdit_OprEDate.SetFocus;
         Exit;
      end;
   end;

   if (Trim(DRMaskEdit_OprSDate.Text) > Trim(DRMaskEdit_OprEDate.Text)) then
   begin
     gf_ShowMessage(MessageBar, mtError, 1040, '시작일자가 종료일자보다 작아야 합니다.'); //일자 입력 오류
     DRMaskEdit_OprEDate.SetFocus;
     DRMaskEdit_OprEDate.SelectAll;
     Exit;
   end;

   if not ThreeMonthOverCheck(Trim(DRMaskEdit_OprEDate.EditText)) then
   begin
     gf_ShowMessage(MessageBar, mtError, 1040, '최대 3개월까지 조회 가능합니다.'); //일자 입력 오류
     DRMaskEdit_OprEDate.SetFocus;
     DRMaskEdit_OprEDate.SelectAll;
     Exit;
   end;

   // 계좌번호
   if Trim(DRUserDblCodeCombo_Acc.Code) = '' then   // 계좌
   begin
      gf_ShowMessage(MessageBar, mtError, 1012, '계좌'); //입력 오류
      DRUserDblCodeCombo_Acc.SetFocus;
      Exit;
   end;

  // 조작자
  if Trim(DRUserCodeCombo_User.Code) = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, '조작자'); //입력 오류
    DRUserCodeCombo_User.SetFocus;
    Exit;
  end;
  // 자료
  if Trim(DRUserCodeCombo_JobGB.Code) = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, '자료'); //입력 오류
    DRUserCodeCombo_JobGB.SetFocus;
    Exit;
  end;
   Result := false;
end;

//==============================================================================
// 조작일자기간조회 Maximum 3개월
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
// Edit Enter 입력 시
//==============================================================================
procedure TForm_SCFH8111.DREdit_KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
   if (Key = #13) and (ActiveControl is TWinControl) then   // 다음 Control로 이동
   begin
      gf_ClearMessage(MessageBar);
      SelectNext(ActiveControl as TWinControl, True, True);
   end;
end;

//==============================================================================
// 자료 Combo Enter 입력 시
//==============================================================================
procedure TForm_SCFH8111.DRUserCodeCombo_JobGBEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
   if (Key = #13) and (ActiveControl is TWinControl) then  
   begin
      DRBitBtn3Click(Sender);   // 조회
   end;
end;

end.
