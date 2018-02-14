unit SCFH8101;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SCCChildForm, DRDialogs, DB, ADODB, DRSpecial, StdCtrls,
  Buttons, DRAdditional, ExtCtrls, DRStandard, Grids, DRStringgrid,
  DrStringPrintU;

type
  TForm_SCFH8101 = class(TForm_SCF)
    DRPanel2: TDRPanel;
    DRLabel1: TDRLabel;
    DRLabel2: TDRLabel;
    DRLabel3: TDRLabel;
    DRLabel4: TDRLabel;
    DRFramePanel1: TDRFramePanel;
    DREdit_AccNo: TDREdit;
    DREdit_AccNameKor: TDREdit;
    DREdit_MgrOprTime: TDREdit;
    DREdit_MgrOprID: TDREdit;
    DREdit_ImportTime: TDREdit;
    DREdit_ImportID: TDREdit;
    DRStrGrid_Acc: TDRStringGrid;
    DrStringPrint1: TDrStringPrint;
    ADOQuery_Log: TADOQuery;
    procedure FormCreate(Sender: TObject); 
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);

    procedure DRStrGrid_AccSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure DRStrGrid_AccDblClick(Sender: TObject);
    procedure DREdit_AccNoKeyPress(Sender: TObject; var Key: Char);

    procedure DRBitBtn2Click(Sender: TObject);
    procedure DRBitBtn3Click(Sender: TObject);
    procedure DRBitBtn4Click(Sender: TObject);
    procedure DRBitBtn5Click(Sender: TObject);
    procedure DRBitBtn6Click(Sender: TObject);

    // 사용자 정의
    function QueryAllAcc: integer; // 계좌 쿼리 조회
    procedure ClearAccList;

    procedure ClearInputEdit(key : string = '');

    function DisplayGridAcc: Boolean;  // StrGrid에 계좌 DATA INPUT

    function AccCheckKeyEditEmpty: boolean;

    function DisplayToEdit_Acc(pAccNo: string): boolean;
    function SelectGridData_Acc(pAccNo: string): Integer;

    function DataInsert_Acc: boolean;
    function DataUpdate_Acc: boolean;
    function DataDelete_Acc: boolean;

    procedure MoveInsertData_Acc;
    procedure MoveUpdateData_Acc;

    function AccNoChk(pAccNo: string): boolean; // DB에 Insert시 테이블에 계좌 존재하는지 여부 체크
    function UpdateDel_AccNoChk(pAccNo: string): boolean; // DB에 Update / Delete시 테이블에 계좌 존재하는지 여부 체크

    function InsertLog(pTRGGB:string; pOriginAccNameKor:string = ''; pCurAccNameKor: string = ''): boolean;         // SZTRLOG_HIS에 INSERT하는 함수
    procedure MoveInsertData_Log(pTRGGB: string);                                                                   // 입력버튼 눌렸을 때 SZTRLOG_HIS에 넣는함수
    procedure MoveUpdateData_Log(pTRGGB, pOriginAccNameKor, pCurAccNameKor: string);                                // 수정버튼 눌렸을 때 SZTRLOG_HIS에 넣는함수
    procedure MoveDeleteData_Log(pTRGGB: string);                                                                   // 삭제버튼 눌렸을 때 SZTRLOG_HIS에 넣는함수
  private
    procedure DefClearStrGrid(pStrGrid: TDRStringGrid); // StrGrid Clear
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_SCFH8101: TForm_SCFH8101;

implementation

uses
  SCCLib, SCCGlobalType, SCCCmuLib;
{$R *.dfm}

type
  TAllAccItem = record           // 전체 계좌 List
    AccNo       : string;
    AccNameKor   : string;
  end;
  pTAllAccItem = ^TAllAccItem;

const
  IDX_ACC_NO     = 0;   // 계좌번호  Col Index
  IDX_ACC_NAME_KOR      = 1;   // 계좌명 Col Index

  LOG_JOB_GB        = 'A';     // 작업구분 '계좌정보'
  LOG_TRG_GB_ADD    = 'I';     // 입력시 SZTRLOG_HIS 테이블 TRG_GB
  LOG_TRG_GB_UPDATE = 'U';     // 수정시 SZTRLOG_HIS 테이블 TRG_GB
  LOG_TRG_GB_DELETE = 'D';     // 삭제시 SZTRLOG_HIS 테이블 TRG_GB
var
  AllAccList     : TList;                       // Acc List
  SelColIdx : Integer;                          // StrGrid 선택된 Col Index
  SelRowIdx : Integer;                          // StrGrid 선택된 Row Index


procedure TForm_SCFH8101.DefClearStrGrid(pStrGrid: TDRStringGrid);
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
//  Clear AccList (계좌)
//==============================================================================
procedure TForm_SCFH8101.ClearAccList;
var
  I : Integer;
  AccItem : pTAllAccItem;
begin
  if not Assigned(AllAccList) then Exit;
  for I := 0 to AllAccList.Count -1 do
  begin
    AccItem := AllAccList.Items[I];
    Dispose(AccItem);
  end;
  AllAccList.Clear;
end;

//==============================================================================
//  Form Create
//==============================================================================
procedure TForm_SCFH8101.FormCreate(Sender: TObject);
begin
  inherited;
  ClearInputEdit;
  AllAccList := TList.Create;

  if (not Assigned(AllAccList)) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); // List 생성 오류
    Close;
    Exit;
  end;

  QueryAllAcc;

  DisplayGridAcc;

  // 필수입력 Edit
  DREdit_AccNo.Color          := gcQueryEditColor;
  DREdit_AccNameKor.Color     := gcQueryEditColor;
end;

//==============================================================================
//  Edit Clear
//==============================================================================
procedure TForm_SCFH8101.ClearInputEdit(key : string = '');
begin
  if key = '' then
  begin
    DREdit_AccNo.Clear;
    DREdit_AccNameKor.Clear;
  end;
  DREdit_ImportID.Clear;
  DREdit_ImportTime.Clear;
  DREdit_MgrOprID.Clear;
  DREdit_MgrOprTime.Clear;
end;

//==============================================================================
// 전체 계좌 Query
//==============================================================================
function TForm_SCFH8101.QueryAllAcc: integer;
var
  AccItem : pTAllAccItem;
begin
  Result := 0;

  ClearAccList;

  with ADOQuery_DECLN do
  begin
    // 전체 계좌
    Close;
    SQL.Clear;
    SQL.Add(' SELECT A.ACC_NO, A.ACC_NAME_KOR                     '
          + ' FROM SZACBIF_INS A                                   '
          + ' WHERE A.DEPT_CODE = ''' + gvDeptCode + '''             '
          + ' ORDER BY A.ACC_NO                                    ');

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


    while not Eof do
    begin
      New(AccItem);
      AllAccList.Add(AccItem);
      AccItem.AccNo := Trim(FieldByName('ACC_NO').AsString);
      AccItem.AccNameKor := Trim(FieldByName('ACC_NAME_KOR').AsString);

      Next;
    end;  // end while

  end;

  Result := AllAccList.Count;
end;

//==============================================================================
// Form Close
//==============================================================================
procedure TForm_SCFH8101.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
   if Assigned(AllAccList) then
   begin
     ClearAccList;
     AllAccList.Free;
   end;
end;

//==============================================================================
// Form Show
//==============================================================================
procedure TForm_SCFH8101.FormShow(Sender: TObject);
begin
  inherited;
  DREdit_AccNo.SetFocus;
end;

//==============================================================================
// DRStrGrid_Acc 계좌List 생성
//==============================================================================
function TForm_SCFH8101.DisplayGridAcc: Boolean;
var
  I, K, iRow : Integer;
  AccItem : pTAllAccItem;
  sAccNo, sAccNameKor : string;
begin
  Result := false;

  with DRStrGrid_Acc do
  begin
    if AllAccList.Count <= 0 then
    begin
      RowCount := 2;
      Rows[1].Clear;
      gf_ShowMessage(MessageBar, mtInformation, 1018, ''); //해당 내역이 없습니다.
      Exit;
    end;
    DefClearStrGrid(DRStrGrid_Acc);

    RowCount := AllAccList.Count + 1;

    iRow := 0;
    sAccNo := '';
    sAccNameKor := '';

    // StrGrid Input
    for i := 0 to AllAccList.Count - 1 do
    begin
      AccItem := AllAccList.Items[i];

      Inc(iRow);
      Rows[iRow].Clear;

      sAccNo := AccItem.AccNo;
      sAccNameKor := AccItem.AccNameKor;

      // 계좌번호
      Cells[IDX_ACC_NO, iRow] := sAccNo;
      // 계좌명
      Cells[IDX_ACC_NAME_KOR, iRow] := sAccNameKor;
    end;
  end;

  Result := True;
end;

//==============================================================================
// 필수입력 항목 누락 확인
//==============================================================================
function TForm_SCFH8101.AccCheckKeyEditEmpty: boolean;
var
  I : Integer;
  Checked : boolean;
begin
  Result := True;

  // 계좌번호
  if Trim(DREdit_AccNo.Text) = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, '계좌번호'); //입력 오류
    DREdit_AccNo.SetFocus;
    Exit;
  end;

  // 계좌명
  if Trim(DREdit_AccNameKor.Text) = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, '계좌명'); //입력 오류
    DREdit_AccNameKor.SetFocus;
    Exit;
  end;

  Result := false;
end;

//==============================================================================
// 계좌 그리드 더블클릭
//==============================================================================
procedure TForm_SCFH8101.DRStrGrid_AccSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  SelRowIdx := ARow;
end;

//==============================================================================
// 계좌 그리드 더블클릭
//==============================================================================
procedure TForm_SCFH8101.DRStrGrid_AccDblClick(Sender: TObject);
var
  AccItem : pTAllAccItem;
begin
  inherited;
  gf_ClearMessage(MessageBar);

  if SelRowIdx <= 0 then Exit;
  if AllAccList.Count <= 0 then Exit;

  // 더블클릭한 계좌 정보 가져오기
  AccItem := AllAccList.Items[SelRowIdx -1];

  DisplayToEdit_Acc(AccItem.AccNo);
  DREdit_AccNameKor.SetFocus;
end;

//==============================================================================
// 계좌번호 Enter 시
//==============================================================================
procedure TForm_SCFH8101.DREdit_AccNoKeyPress(Sender: TObject;
  var Key: Char);
var
 TmpAccNo  : string;
begin
  inherited;

  TmpAccNo := '';

  if Key = #13 then
  begin
     gf_ClearMessage(MessageBar);
     if Trim(DREdit_AccNo.Text) <> '' then
     begin
        TmpAccNo := Trim(DREdit_AccNo.Text);
        ClearInputEdit;
        DREdit_AccNo.Text := TmpAccNo;
        if not DisplayToEdit_Acc(TmpAccNo) then exit;
        SelectGridData_Acc(TmpAccNO);
     end;
     DREdit_AccNameKor.SetFocus;
  end
  else if (key in ['0'..'9']) then
  begin
     TmpAccNo := TmpAccNo + Key;

     ClearInputEdit(Key);
  end
  else if (not (Key in ['0'..'9'])) and (Key <> #8) then
  begin
    key := #0;
    gf_ShowMessage(MessageBar, mtError, 1045,''); // 숫자를 입력하십시요.
  end;
end;

//==============================================================================
// 해당 계좌 데이터
//==============================================================================
function TForm_SCFH8101.DisplayToEdit_Acc(pAccNo: string): boolean;
begin

   Result := false;
   with  ADOQuery_DECLN do
   begin
      EnableBCD := False;
      Close;
      SQL.Clear;
      SQL.Add(' SELECT ACC_NO, ACC_NAME_KOR,                              '
            + ' OPR_ID, OPR_DATE, OPR_TIME,                               '
            + ' IMPORT_ID, IMPORT_DATE, IMPORT_TIME                       '
            + ' FROM SZACBIF_INS                                         '
            + ' WHERE DEPT_CODE = ''' + gvDeptCode + '''                  '
            + ' AND   ACC_NO  = ''' + pAccNo + '''                  ');

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

      if RecordCount <= 0 then
      begin
         Result := true;
         Exit;
      end;
      // 각 Edit Input
      DREdit_AccNo.Text := Trim(FieldByName('ACC_NO').asString);
      DREdit_AccNameKor.Text := Trim(FieldByName('ACC_NAME_KOR').asString);
      DREdit_MgrOprId.Text := Trim(FieldByName('OPR_ID').asString);
      DREdit_MgrOprTime.Text := gf_FormatDate(Trim(FieldByName('OPR_DATE').asString))
                            + ' ' + gf_FormatTime(Trim(FieldByName('OPR_TIME').asString));
      DREdit_ImportID.Text := Trim(FieldByName('IMPORT_ID').asString);
      DREdit_ImportTime.Text := gf_FormatDate(Trim(FieldByName('IMPORT_DATE').asString))
                            + ' ' + gf_FormatTime(Trim(FieldByName('IMPORT_TIME').asString));



   end;

   Result := true;
end;

//==============================================================================
// StrGrid에서 해당 데이터에 해당되는 RowIndex 찾아 Select
//==============================================================================
function TForm_SCFH8101.SelectGridData_Acc(pAccNo: string): Integer;
var
   I, SearchIdx : Integer;
begin
   SearchIdx := -1;
   for I := 1 to DRStrGrid_Acc.RowCount -1 do
   begin
      if (DRStrGrid_Acc.Cells[IDX_ACC_NO, I] = pAccNo) then
      begin
          SearchIdx := I;
          break;
      end;
   end;
   if SearchIdx > -1 then  //해당 데이터 존재시
      gf_SelectStrGridRow(DRStrGrid_Acc, SearchIdx)
   else  //해당 데이터 존재하지 않을 경우 첫Row Select
      gf_SelectStrGridRow(DRStrGrid_Acc, 1);
   Result := SearchIdx;
end;

//==============================================================================
// 조회 버튼 Click
//==============================================================================
procedure TForm_SCFH8101.DRBitBtn6Click(Sender: TObject);
var
  AccRowCount : Integer;
begin
  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1020, ''); //조회 중입니다.
   DisableForm;

   ClearInputEdit;
   AccRowCount := QueryAllAcc;  // 계좌 쿼리 결과 행 수
   DisplayGridAcc;  // 스트링그리드에 데이터 Input

   if AccRowCount <= 0 then
       gf_ShowMessage(MessageBar, mtInformation, 1018, '') //해당 내역이 없습니다.
   else
       gf_ShowMessage(MessageBar, mtInformation, 1021,
               gwQueryCnt + IntToStr(AccRowCount)); // 조회 완료
   DREdit_AccNo.SetFocus;

   EnableForm;
end;

//==============================================================================
// 입력 버튼 Click
//==============================================================================
procedure TForm_SCFH8101.DRBitBtn5Click(Sender: TObject);
begin
  inherited;
  if not DataInsert_Acc then Exit;
end;

//==============================================================================
// DB Insert
//==============================================================================
function TForm_SCFH8101.DataInsert_Acc: boolean;
var
   CurAccNo : string;
begin
  inherited;
  Result := false;

  gf_ShowMessage(MessageBar, mtInformation, 1010, ''); //입력 중입니다.

  if AccCheckKeyEditEmpty then Exit;   //입력 누락 항목 확인

  CurAccNo := Trim(DREdit_AccNo.Text);

  DisableForm;
  // 계좌로 기존 등록 Check
  if not AccNoChk(CurAccNo) then
  begin
     EnableForm;
     SelectGridData_Acc(CurAccNo);
     DREdit_AccNo.SetFocus;
     Exit;
  end;

  with ADOQuery_DECLN do
  begin
     Close;
     sql.clear;
     sql.add(   // 계좌 테이블 입력
              ' INSERT SZACBIF_INS                                                '
            + '  (DEPT_CODE,    ACC_NO,         ACC_NAME_KOR,                     '
            + '   MANUAL_YN,                                                      '
            + '   OPR_ID,       OPR_DATE,       OPR_TIME                    )     '
//            + '   IMPORT_ID,    IMPORT_DATE,    IMPORT_TIME     )                 '
            + ' VALUES                                                            '
            + '  (:pDEPT_CODE,   :pACC_NO,       :pACC_NAME_KOR,                  '
            + '   :pMANUAL_YN,                                                    '
            + '   :pOPR_ID,      :pOPR_DATE,     :pOPR_TIME                  )  '
//            + '   :pIMPORT_ID,   :pIMPORT_DATE,  :pIMPORT_TIME                )  '
            );

     MoveInsertData_Acc;

     Try
        gf_ADOExecSQL(ADOQuery_DECLN);
     Except
        on E : Exception do
        begin
           gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZACBIF_INS :INSERT]: ' + E.Message, 0);
           gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZACBIF_INS : INSERT]'); // Database 오류
           EnableForm;
           Exit;
        end;
     end;
  end;

  InsertLog(LOG_TRG_GB_ADD);  // SZTRLOG_HIS Insert

  QueryAllAcc;   // 전체계좌 조회쿼리
  DisplayGridAcc; // 그리드에 데이터 INPUT

  SelectGridData_Acc(CurAccNo);
  ClearInputEdit;

  EnableForm;
  DREdit_AccNo.SetFocus;
  gf_ShowMessage(MessageBar, mtInformation, 1011, ''); // 입력 완료
  Result := true;
end;

//==============================================================================
// 계좌번호 존재하는지 Check
//==============================================================================
function TForm_SCFH8101.AccNoChk(pAccNo: string): boolean;
begin
   Result := false;
   with  ADOQuery_DECLN do
   begin
      Close;
      SQL.Clear;
      SQL.Add(' SELECT ACC_NO                             '
            + ' FROM SZACBIF_INS                          '
            + ' WHERE DEPT_CODE = ''' + gvDeptcode  + ''' '
            + '   and ACC_NO    = ''' + pAccNO + '''      ');
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

      if RecordCount >= 1  then
      begin
         gf_ShowMessage(MessageBar, mtError, 1003, ''); // 해당 계좌가 존재합니다.
         exit;
      end;
   end;
   Result := true;
end;

//==============================================================================
// 계좌 정보 Insert
//==============================================================================
procedure TForm_SCFH8101.MoveInsertData_Acc;
begin
  with ADOQuery_DECLN do
  begin
    // 담당부서
    Parameters.ParamByName('pDEPT_CODE').Value := gvDeptCode;
    // 계좌번호
    Parameters.ParamByName('pACC_NO').Value := Trim(DREdit_AccNo.Text);
    // 계좌명
    Parameters.ParamByName('pACC_NAME_KOR').Value := Trim(DREdit_AccNameKor.Text);
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
// 수정 버튼 Click
//==============================================================================
procedure TForm_SCFH8101.DRBitBtn4Click(Sender: TObject);
begin
  inherited;
  if not DataUpdate_Acc then Exit;
end;

//==============================================================================
// 계좌 수정
//==============================================================================
function TForm_SCFH8101.DataUpdate_Acc: boolean;
var
   OriginAccNameKor : string;
   CurAccNameKor : string;
   CurAccNo: string;
begin
   Result := false;
   gf_ShowMessage(MessageBar, mtInformation, 1007, ''); //수정 중입니다.

   if AccCheckKeyEditEmpty then Exit;   // Key Field Edit에 누락 항목

   CurAccNo := Trim(DREdit_AccNo.Text);

   DisableForm;

   // 계좌로 기존 등록 Check
   if not UpdateDel_AccNoChk(CurAccNo) then
   begin
      EnableForm;
      DREdit_AccNo.SetFocus;
      Exit;
   end;

   // 기존 계좌명
   OriginAccNameKor := Trim(ADOQuery_DECLN.FieldByName('ACC_NAME_KOR').AsString);
   // 변경 계좌명
   CurAccNameKor    := Trim(DREdit_AccNameKor.Text);

   // 변경내역 없으면
   if OriginAccNameKor = CurAccNameKor then
   begin
     SelectGridData_Acc(CurAccNo);
     EnableForm;
     DREdit_AccNo.SetFocus;
     gf_ShowMessage(MessageBar, mtInformation, 0, '변경사항이 없습니다.'); // 수정 X
     Exit;
   end;

   with ADOQuery_DECLN do
   begin
      Close;
      sql.clear;
      sql.add(   // 계좌 테이블 수정
             ' UPDATE SZACBIF_INS                       '
           + ' SET                                      '
           + ' DEPT_CODE        =  :pDEPT_CODE,       '
//           + ' ACC_NO           =  :pACC_NO,          '
           + ' ACC_NAME_KOR     =  :pACC_NAME_KOR,    '
           + ' OPR_ID           =  :pOPR_ID,          '
           + ' OPR_DATE         =  :pOPR_DATE,        '
           + ' OPR_TIME         =  :pOPR_TIME         '
//           + ' IMPORT_ID        =  :pIMPORT_ID,       '
//           + ' IMPORT_DATE      =  :pIMPORT_DATE,     '
//           + ' IMPORT_TIME      =  :pIMPORT_TIME      '
           + ' WHERE DEPT_CODE  = ''' + gvDeptCode + ''' '
           + ' AND   ACC_NO     = ''' + CurAccNo   + ''' ');
      MoveUpdateData_Acc;

      Try
         gf_ADOExecSQL(ADOQuery_DECLN);
      Except
         on E : Exception do
         begin
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZACBIF_INS :UPDATE]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZACBIF_INS : UPDATE]'); // Database 오류
            EnableForm;
            Exit;
         end;
      end;//try
   end; //with

   InsertLog(LOG_TRG_GB_UPDATE, OriginAccNameKor, CurAccNameKor);  // SZTRLOG_HIS Insert

   QueryAllAcc;   // 전체계좌 조회쿼리
   DisplayGridAcc; // 그리드에 데이터 INPUT

   SelectGridData_Acc(CurAccNo);
   ClearInputEdit;

   EnableForm;
   DREdit_AccNo.SetFocus;
   gf_ShowMessage(MessageBar, mtInformation, 1008, ''); // 수정 완료
   Result := true;
end;

//==============================================================================
// 계좌등록 check -update/delete시 check
//==============================================================================
function TForm_SCFH8101.UpdateDel_AccNoChk(pAccNo: string): boolean;
begin
   Result := false;
   with  ADOQuery_DECLN do
   begin
      Close;
      SQL.Clear;
      SQL.Add(
             ' SELECT ACC_NO, ACC_NAME_KOR                       '+
             ' FROM SZACBIF_INS                          '+
             ' WHERE DEPT_CODE = ''' + gvDeptcode  + ''' '+
             ' AND   ACC_NO    = ''' + pAccNO + ''' ');
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

      if RecordCount <= 0  then
      begin
         gf_ShowMessage(MessageBar, mtError, 1004, ''); //해당 계좌는 존재하지 않습니다.
         exit;
      end;
   end;
   Result := true;
end;

//==============================================================================
// 계좌 정보 Update
//==============================================================================
procedure TForm_SCFH8101.MoveUpdateData_Acc;
begin
  with ADOQuery_DECLN do
  begin
    // 담당부서
    Parameters.ParamByName('pDEPT_CODE').Value := gvDeptCode;
    // 계좌명
    Parameters.ParamByName('pACC_NAME_KOR').Value := Trim(DREdit_AccNameKor.Text);
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
// 삭제버튼 Click
//==============================================================================
procedure TForm_SCFH8101.DRBitBtn3Click(Sender: TObject);
begin
  inherited;
  if not DataDelete_Acc then exit;
end;

//==============================================================================
// 계좌 삭제
//==============================================================================
function TForm_SCFH8101.DataDelete_Acc: boolean;
var
   CurAccNo : string;
   DeleteStr : string;
begin
   inherited;
   Result := false;
   if Trim(DREdit_AccNo.Text) = '' then  // 삭제 대상 없음
   begin
      gf_ShowMessage(MessageBar, mtError, 1012, '계좌번호'); //입력 오류
      DREdit_AccNo.SetFocus;
      Exit;
   end;

   CurAccNo := Trim(DREdit_AccNo.Text);
   DeleteStr := '(' + CurAccNo + ': ' + DREdit_AccNameKor.Text + ')';


   try

      // 계좌로 기존 등록 Check
      if not UpdateDel_AccNoChk(CurAccNo) then
      begin
//         EnableForm;
         DREdit_AccNo.SetFocus;
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
        sql.add(   // 계좌 테이블 삭제
            '  DELETE FROM  SZACBIF_INS   '+
            '  WHERE  DEPT_CODE = ''' + gvDeptCode + ''' '+
            '     AND ACC_NO    = ''' + CurAccNo + ''' ');
        Try
           gf_ADOExecSQL(ADOQuery_DECLN);
        Except
           on E : Exception do
           begin
              gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZACBIF_INS : DELETE]: ' + E.Message, 0);
              gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZACBIF_INS : DELETE]'); // Database 오류
 //                  EnableForm;
              Exit;
           end;
        end;  //try
      end; //  with

      InsertLog(LOG_TRG_GB_DELETE);  // SZTRLOG_HIS Insert

      QueryAllAcc;   // 전체계좌 조회쿼리
      DisplayGridAcc; // 그리드에 데이터 INPUT

      ClearInputEdit;
//      EnableForm;
      DREdit_AccNo.SetFocus;
      gf_ShowMessage(MessageBar, mtInformation, 1006, DeleteStr ); // 삭제 완료
      Result := true;
   finally
      EnableForm;
   end;
end;

//==============================================================================
// 인쇄 버튼 Click
//==============================================================================
procedure TForm_SCFH8101.DRBitBtn2Click(Sender: TObject);
begin
  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1100, ''); // 인쇄 중입니다.

   with DrStringPrint1 do
   begin
      Title  := DRPanel_Title.Caption;
      UserText1  := '';
      UserText2  := '';

      StringGrid := DRStrGrid_Acc;
//      Orientation  := poPortrait;   //poLandscape;

      Print;
   end;

   gf_ShowMessage(MessageBar, mtInformation, 1101, ''); // 인쇄 완료
end;

//==============================================================================
// SZTRLOG_HIS Insert
//==============================================================================
function TForm_SCFH8101.InsertLog(pTRGGB: string; pOriginAccNameKor: string = ''; pCurAccNameKor: string = ''): boolean;
begin
   Result := false;
   with  ADOQuery_Log do
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

      if pTRGGB = LOG_TRG_GB_ADD then  // 입력일 때
      begin
        MoveInsertData_Log(pTRGGB);
      end
      else if pTRGGB = LOG_TRG_GB_UPDATE then// 수정일 때
      begin
        if pOriginAccNameKor = pCurAccNameKor then
          Exit;
        MoveUpdateData_Log(pTRGGB, pOriginAccNameKor, pCurAccNameKor);
      end
      else                                // 삭제일 때
      begin
        MoveDeleteData_Log(pTRGGB);
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
procedure TForm_SCFH8101.MoveInsertData_Log(pTRGGB: string);
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
    Parameters.ParamByName('pACC_NO').Value := Trim(DREdit_AccNo.Text);
    // 작업구분
    Parameters.ParamByName('pJOB_GB').Value := LOG_JOB_GB;
    // 처리구분
    Parameters.ParamByName('pTRG_GB').Value := pTRGGB;
    // 화면TR
    Parameters.ParamByName('pTR_CODE').Value := Trim(IntToStr(Self.Tag));
    // 작업자
    Parameters.ParamByName('pOPR_ID').Value := gvOprUsrNo;
    // 작업내용
    Parameters.ParamByName('pCOMMENT').Value := '[' + Trim(DREdit_AccNo.Text) + '] ' + '입력';
  end;
end;

//==============================================================================
// 수정버튼 눌렸을 때 SZTRLOG_HIS에 넣기
//==============================================================================
procedure TForm_SCFH8101.MoveUpdateData_Log(pTRGGB, pOriginAccNameKor, pCurAccNameKor: string);
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
    Parameters.ParamByName('pACC_NO').Value := Trim(DREdit_AccNo.Text);
    // 작업구분
    Parameters.ParamByName('pJOB_GB').Value := LOG_JOB_GB;
    // 처리구분
    Parameters.ParamByName('pTRG_GB').Value := pTRGGB;
    // 화면TR
    Parameters.ParamByName('pTR_CODE').Value := Trim(IntToStr(Self.Tag));
    // 작업자
    Parameters.ParamByName('pOPR_ID').Value := gvOprUsrNo;
    // 작업내용
    Parameters.ParamByName('pCOMMENT').Value := '[' + Trim(DREdit_AccNo.Text) + '] '
                                              + '계좌명: ' + pOriginAccNameKor + ' -> ' +  pCurAccNameKor;
  end;
end;

//==============================================================================
// 삭제버튼 눌렸을 때 SZTRLOG_HIS에 넣기
//==============================================================================
procedure TForm_SCFH8101.MoveDeleteData_Log(pTRGGB: string);
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
    Parameters.ParamByName('pACC_NO').Value := Trim(DREdit_AccNo.Text);
    // 작업구분
    Parameters.ParamByName('pJOB_GB').Value := LOG_JOB_GB;
    // 처리구분
    Parameters.ParamByName('pTRG_GB').Value := pTRGGB;
    // 화면TR
    Parameters.ParamByName('pTR_CODE').Value := Trim(IntToStr(Self.Tag));
    // 작업자
    Parameters.ParamByName('pOPR_ID').Value := gvOprUsrNo;
    // 작업내용
    Parameters.ParamByName('pCOMMENT').Value := '[' + Trim(DREdit_AccNo.Text) + '] ' + '삭제';
  end;
end;

end.
