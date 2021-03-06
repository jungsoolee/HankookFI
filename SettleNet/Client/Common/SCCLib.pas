//==============================================================================
//   SettleNet Library
//   P.H.S 2006.08.08   gf_SplitTextFile(pFreqNo(회차) default='') 추가
//   P.H.S 2006.08.25   gf_PreviewText(pFreqNo(회차) default='') 추가
//==============================================================================
unit SCCLib;

interface
uses
  Windows, SysUtils, Graphics, ExtCtrls, DB, DBTables, Dialogs, Messages, forms,
  Grids, Controls, Classes, Stdctrls, Dbctrls, Printers, Quickrpt,
  DRStringGrid, DRStandard, DRAdditional, DRColorTab, DRSpecial, DRwin32, FileCtrl,
  SCCGlobalType, ADOdb, SCCPSInputBox, ShellAPI, SCCEditForm, IniFiles,
  SCCCmuLib, SCCIconDlg, SCCRegFaxTlxAddr, SCBERegGroup, SCBFRegGroup, SCCShowAttDlg, SCCViewMail,
  SCCRegEmailAddr, SCCSelectEmail, SCCEditAttFile, SCCAccNoSearch, SCCAutoSplitAcc,
  Registry, ActiveX, ComObj, Excel2000, math, SCCCmuGlobal, ThreadCL2Md, TlHelp32, WinSock, //2006.04.10 Delphi 7 version 추가 1
  DCPmd5, DCPrijndael, DCPsha256;

//------------------------------------------------------------------------------
//  Crystal 10 DLL Registry 등록하기 Function //2006.04.10 Delphi 7 version 추가 1
//------------------------------------------------------------------------------
//Crystal 10 Dll은 반드시 Registry에 등록해서 써야 한다.
//별도로 Settup 작업을 하면 되지만 두고두고 귀찮은 작업이다
//따라서 Registry를 건들 수 없는 외국계를 제외하고
//Application 초입에 자동으로 Crystal Dll을 설치한다.
//물론, 기 설치된 PC는 제외한다.
function gf_DllSetup: boolean;

//------------------------------------------------------------------------------
//  EMail File 생성 Main Function
//------------------------------------------------------------------------------
function gf_CreateEMailFile(pEMailFormId, pDirName, pDeptCode, pTradeDate: string;
  pGrpName: string; AccNoList: TStringList; var FileName: string; CreateFlag: boolean): boolean;

//------------------------------------------------------------------------------
// [한/영] Code <-> Code명 변환 함수
//------------------------------------------------------------------------------
// gvIssueList에서 해당 종목코드에 부합되는 Index 리턴
function gf_ReturnIssueCodeIdx(pIssueList: TList; pIssueCode: string): Integer;
// 종목코드의 관련 정보(TIssueType) 리턴
function gf_ReturnIssueInfo(pSecType, pIssueCode: string; var pIssueItem: pTIssueType): boolean;
// 종목코드를 종목표준코드로 변환
function gf_IssueCodeToFullCode(pSecType, pIssueCode: string): string;
// 종목코드를 종목명으로 변환
function gf_IssueCodeToFullName(pSecType, pIssueCode: string): string;
// 종목코드를 종목단축명으로 변환
function gf_IssueCodeToShortName(pSecType, pIssueCode: string): string;
// 종목명울 종목코드로 변환
function gf_IssueFullNameToCode(pSecType, pIssueName: string): string;
// 종목단축명을 종목코드로 변환
function gf_IssueShortNameToCode(pSecType, pIssueName: string): string;
// 종목리스트 정렬
procedure gf_SortIssueList(pIssueList: TList; pAscCodeFlag: boolean);
// CodeList를 참조하여 Code를 Name으로 변환하여 리턴(CompCode 제외)
function gf_CodeToName(pList: TList; pCode: string): string;
// CodeList를 참조하여 Name을 Code로 변환하여 리턴  (CompCode 제외)
function gf_NameToCode(pList: TList; pName: string): string;
// CompCode를 Name으로 변환하여 리턴
function gf_CompCodeToName(pCompCode: string): string;
// CompName을 Code로 변환하여 리턴
function gf_CompNameToCode(pCompName: string): string;
// RoleCode를 Name으로 변환하여 리턴
function gf_RoleCodeToName(pRoleCode: string): string;
// RoleName을 Code로 변환하여 리턴
function gf_RoleNameToCode(pRoleName: string): string;
// ReprotID를 Name으로 변환하여 리턴
function gf_ReportIDToName(pReportID: string): string;
// ReportName을 Report ID로 변환하여 리턴
function gf_ReportNameToID(pReportName: string): string;
// 해당 Report에 대한 Direction 리턴
function gf_GetReportDirection(pReportId: string): string;
// 해당 Report에 대한 ReportType 리턴
function gf_GetReportType(pReportId: string): string;
// DeptCode를 Name으로 변환하여 리천
function gf_DeptCodeToName(pDeptCode: string): string;
// DeptName을 Code로 변환하여 리턴
function gf_DeptNameToCode(pDeptName: string): string;
// FundType을 Name으로 변환하여 리턴
function gf_FundTypeToName(pFundType: string): string;
// Fundtype명을 FundType으로 변환하여 리턴
function gf_FundTypeNameToType(pFundTypeName: string): string;
// Sec Type을 Name으로 변환하여 리턴
function gf_SecTypeToName(pSecType: string): string;
// Sec Name을 Type으로 변환하여 리턴
function gf_SecNameToType(pSecName: string): string;
// Tran Mtd를 Name으로 변환하여 리턴
function gf_TranMtdToName(pTranMtd: string): string;
// Tran Mtd Name을 Tran Mtd 로 변환하여 리턴
function gf_TranNametoMtd(pTranName: string): string;
// Com Type을 Name으로 변환하여 리턴
function gf_ComTypeToName(pComType: string): string;
// Com Name을 Type으로 변환하여 리턴
function gf_ComNameToType(pComName: string): string;
// Mkt Type을 Name으로 변화하여 리턴
function gf_MktTypeToName(pMktType: string): string;
// Mkt Name을 Type으로 변환하여 리턴
function gf_MktNameToType(pMktName: string): string;
// Tran Code를 Name으로 변환하여 리턴
function gf_TranCodeToName(pTranCode: string): string;
// Tran Code Name을 Tran Code로 변환하여 리턴
function gf_TranNameToCode(pTranName: string): string;
// Party ID를 Name으로 변환하여 리턴
function gf_PartyIDToName(pPartyID: string): string;
// Party Name을 ID로 변환하여 리턴
function gf_PartyNameToID(pPartyName: string): string;
// SellBuyCode를 Name으로 변환하여 리턴
function gf_SellBuyCodeToName(pCode: string): string;
// SellBuyName을 Code로 변환하여 리턴
function gf_SellBuyNameToCode(pName: string): string;
// TeamCode를 Name으로 변환하여 리턴
function gf_TeamCodeToName(pTeamCode: string): string;
// TeamName을 Code로 변환하여 리턴
function gf_TeamNameToCode(pTeamName: string): string;
// FundType을 Name으로 변환하여 리턴
function gf_FundTypeCodeToName(pFundTypeCode: string): string;
// FundTypeName을 Type으로 변환하여 리턴
function gf_FundTypeNameToCode(pFundTypeName: string): string;
// SendMethod Code를 Name으로 변환하여 리턴
function gf_SendMtdCodeToName(pSendMtdCode: string): string;
// SendMethod Name을 SendMethod Code로 변환하여 리턴
function gf_SendMtdNameToCode(pSendMtdName: string): string;
// CustProp Code를 Name으로 변환하여 리턴
function gf_CustPropCodeToName(pCustPropCode: string): string;
// CustProp Name을 Code로 변환하여 리턴
function gf_CustPropNameToCode(pCustPropName: string): string;

//------------------------------------------------------------------------------
//  Log File 처리
//------------------------------------------------------------------------------
// Log File 기록(Thread Safe)
procedure gf_Log(S: string);
// Log File Open
procedure gf_StartLog(pLogPath, pLogName: string);
// Log File Close
procedure gf_EndLog;


//------------------------------------------------------------------------------
//  채번 함수
//------------------------------------------------------------------------------
//  Data 전송시 횟수 채번
function gf_GetDataSendFreqNo(pSecType: string): Integer;
//  Data 전송시 총송신 Seq. No 채번
function gf_GetDataSendSeqNo(pSecType: string): Integer;
//  Fax 전송시 횟수 채번
function gf_GetFaxSendFreqNo: Integer;
//  Fax 전송시 총수신 Seq. No 채번
function gf_GetFaxSendSeqNo: Integer;

//------------------------------------------------------------------------------
//  Format 함수
//------------------------------------------------------------------------------
// 모계좌번호, 부계좌번호 formatting 00000000000-0000
function gf_FormatAccNo(pAccNo, pSubAccNo: string): string;
// 계좌번호 unformatting : 00000000000-0000 -> 00000000000, 0000
procedure gf_UnformatAccNo(pFormatAccNo: string; var pAccNo, pSubAccNo: string);
// Date formatting : YYYYMMDD -> YYYY-MM-DD
function gf_FormatDate(pDate: string): string;
// Date unformatting : YYYY-MM-DD -> YYYYMMDD
function gf_UnformatDate(pDate: string): string;
// Report 에서의 Date formatting : YYYYMMDD -> YYYY/MM/DD(+++수정필요)
function gf_PrintFormatDate(pDate: string): string;
// Time formatting : HHMMSSMM -> HH:MM:SS.MM
function gf_FormatTime(pTime: string): string;
// Time unformatting : HH:MM:SS.MM -> HHMMSSMM
function gf_UnformatTime(pTime: string): string;
// DiffTime Formatting -> MM.SS
function gf_FormatDiffTime(pDiffTime: Integer): string;
// Edit File Name Formatting
function gf_FormatEditFileName(pJobDate, pReportId, pAccNo, pSubAccNo, pMediaNo: string): string;
// Copy String + Fill Space
function gf_MoveDataStr(Source: string; iSize: Integer): string;


//------------------------------------------------------------------------------
//  일자/시간 관련 함수
//----------------------------------------------------------------------------=
//  입력된 일자가 유효한 일자인지 확인
function gf_CheckValidDate(pDate: string): boolean;
//  오늘 일자 가져오기 함수(YYYYMMDD)
function gf_GetCurDate: string;
//  현재 시간 가져오기 함수(HHMMSSMM)
function gf_GetCurTime: string;
//  결제 일자 구하는 함수, 오류 발생시 해당 오류 Message 리턴
function gf_GetSettleDate(pApplyType, pStdDate: string; var pSettleDate: string): string;
//  입력된 일자의 차이를 구하는 함수
function gf_Getstgigan(sDate, tDate: string): integer;

//------------------------------------------------------------------------------
//  형변환 함수
//------------------------------------------------------------------------------
// Conversion Error 발생시 0이 Return되는 StrToFloat
function gf_StrToFloat(pStr: string): double;
// Conversion Error 발생시 0이 Return되는 StrToInt
function gf_StrToInt(pStr: string): integer;
// currency comma 처리하여 해당 값 return
function gf_CurrencyToFloat(pStr: string): double;
// currency comma String에서 currency comma 제거한 string return
function gf_CurrencyToStr(pStr: string): string;

// 날짜 형식 변환시 한글os 날짜 표기형식으로 수정하기 위한 StrToDate
function gf_StrToDate(pDate: string; pDateFormat: string = 'yyyy-mm-dd'; pDateSeparator: char = '-'): TDateTime;
// 날짜 형식 변환시 한글os 날짜 표기형식으로 수정하기 위한 StrToDateTime
function gf_StrToDateTime(pDate: string; pDateFormat: string = 'yyyy-mm-dd'; pDateSeparator: char = '-'): TDateTime;

//------------------------------------------------------------------------------
//  계좌 관련 함수
//------------------------------------------------------------------------------
// 계좌 존재 확인 후 계좌명 Return (한/영)
function gf_GetAccName(InAccNo: string; var OutAccName: string): boolean;

//------------------------------------------------------------------------------
//  Message 관련 함수
//------------------------------------------------------------------------------
// Dialog Message (한/영)
function gf_ShowDlgMessage(pTrCode: LongInt; pDlgType: TMsgDlgType; pMsgNo: LongInt; pExtMsg: string;
  pButtons: TMsgDlgButtons; pHelpCtx: LongInt): Integer;
// Error Dialog Message (한/영)
function gf_ShowErrDlgMessage(pTrCode: LongInt; pMsgNo: LongInt; pExtMsg: string; pHelpCtx: LongInt): Integer;
// [한영] MessageBar에 Message 출력
procedure gf_ShowMessage(pMsgBar: TDRMessageBar; pMsgType: TMsgDlgType; pMsgNo: LongInt; pExtMsg: string);
// MessageBar Clear
procedure gf_ClearMessage(pMsgBar: TDRMessageBar);
// Message 번호를 받아 해당 Message return (한/영)
function gf_ReturnMsg(pMsgNo: LongInt): string;

//------------------------------------------------------------------------------
//  DB 관련
//------------------------------------------------------------------------------
// 생성된 Shared Lock을 풀어주는 Query Open
procedure gf_QueryOpen(pQuery: TQuery);
// 생성된 Shared Lock을 풀어주는 Query Open
procedure gf_ADOQueryOpen(pQuery: TADOQuery);

// Update, Insert, Delete를 수행하는 SQL 수행
procedure gf_ExecSQL(pQuery: TQuery);
// Update, Insert, Delete를 수행하는 SQL 수행
procedure gf_ADOExecSQL(pQuery: TADOQuery);

// Parameter를 가져오는 Stored Proc 의 실행
procedure gf_ExecProc(pStoredProc: TStoredProc);
// Parameter를 가져오는 Stored Proc 의 실행
procedure gf_ADOExecProc(pStoredProc: TADOStoredProc);

// ResultSet을 가져오는 Stored Proc 의 실행
procedure gf_GetResultProc(pStoredProc: TStoredProc);
// ResultSet을 가져오는 Stored Proc 의 실행
procedure gf_ADOGetResultProc(pStoredProc: TADOStoredProc);

// Database Start Transaction
procedure gf_BeginTransaction;
// Database Commit
procedure gf_CommitTransaction;
// Database Rollback
procedure gf_RollbackTransaction;

//------------------------------------------------------------------------------
// Report 관련
//------------------------------------------------------------------------------
// Print Crystal Rpt Type Report ( By Kim Ji-Young)
function gf_PrintReport(ExpFileName: string): Boolean;
// Print Crystal Rpt Type Report ( By Kim Ji-Young)
function gf_PreviewReport(ExpFileName: string): Boolean;

//------------------------------------------------------------------------------
//  송수신 Manager 관련
//------------------------------------------------------------------------------
// 수신처 Component에서 수신처 정보를 Display 하기 위한 Format
function gf_FormatFaxTlxAddr(pAddrItem: pTFaxTlxAddr): string;
// FaxTlxAddrList Clear (SUPRTAD_TBL - Fax/Tlx) Item: TFaxTlxAddr
procedure gf_ClearFaxTlxAddrList(pList: TList);
// 해당 부서의 수신처 관리 화면 생성 (수신처 변경시 True Return)
function gf_ShowRegFaxTlxAddr(pSendMtd: string; pSendSeq: Integer): Integer;
// 해당 부서의 그룹 관리 화면 생성
function gf_ShowRegGroup(pSecType, pGrpName, pCallFlag, pAccNo, pSubAccNo: string): Integer;
// 이메일 첨부화일 생성
function gf_CreateMailFile(SndItem: pTFSndMail; CallFlag: boolean; JobDate: string): string;
// 이메일 첨부화일 보기
function gf_ViewMailFile(SndItem: pTFSndMail; JobDate: string): string;
// 수신처관리- 이메일 등록화면
function gf_ShowRegEmailAddr(pMailRcv, pMailAddr: string): integer;
// 이메일 수신처 등록 화면 생성
function gf_ShowSelectEmail(pMailAddrList, pCCMailAddrList, pCCBlindAddrList: TStringList;
  pRcvType, pTitle: string): Integer;
function gf_SendSeqToRcvName(pSendSeq: string): string;

// Show Att File
function gf_ShowAttDlg(pSndDate: string; FreqItem: pTFreqMail; pAttSeqNo: Integer): boolean;
// EMail Attaxh File 저장
function gf_SaveMailAttachToFile(pSendDate: string; pCurTotSeqNo,
  pAttSeqNo: Integer; pFileName: string): boolean;
// Fax 전송 내역 File 저장
function gf_SaveSentImageToFile(pSendDate: string; pCurTotSeqNo: Integer;
  pFileName: string): boolean;
// Free MediaNo List
procedure gf_FreeReportList(ReportList: TList);
// Telex의 국가코드 확인
function gf_CheckValidNatCode(pNatCode: string): boolean;
// Text File을 구분자별 Unit으로 Split시켜 저장
function gf_SplitTextFile(pSrcFileName, pDesFileName, pTxtUnitInfo: string; pFreqNo: string = ''): boolean;
// Text File을 Page 구분된 Text File로 변환
function gf_ConvertPageText(pSrcFileName, pDesFileName: string; pPSStrList: TStringList;
  var pTotPageCnt: Integer; var pLogoPageNo, pTxtUnitInfo: string): boolean;
// Preview Edit Text Type Report
function gf_PreviewEditor(pOpenFileName, pSaveFileName, pOrientation, pExpFileNameBody: string;
  var pPSStrList: TStringList): boolean;
// Preview Text Type Report
function gf_PreviewText(pOpenFileName, pOrientation, pTitle, pTabCaption, pExpFileNameBody: string; pFreqNo: string = ''): boolean;
// FAX PS Input Box Create & Return PS StringList
procedure gf_ShowPSInputBox(var PSDefaultList, PSLeftList, PSRightList: TStringList;
  pDeptCode, pTradeDate, pAccNm, pSubAccNo, pMediaNo, pRptId, pGrpType, pRptType, pDirection: string;
  pWkMode: string = 'I');
// Data RSPFlag Font Color Return
function gf_GetDataRSPFlagColor(pRSPFlagName: string): TColor;
// Fax/Tlx RSPFlag Font Color Return
function gf_GetFaxTlxRSPFlagColor(pRSPFlagName: string): TColor;
// WM_USER_MSMQ_RESULT WParam Message Return
function gf_GetMSMQResult(pRSPFlag: Integer): string;
// WM_USER_FAX_RESULT WParam Message Return
function gf_GetFaxTlxResult(pRSPFlag: Integer): string;
// WM_USER_MAIL_RESULT WParam Message Return
function gf_GetMailResult(pRSPFlag: Integer): string;
// Mail RSPFlag Font Color Return
function gf_GetMailRSPFlagColor(pRSPFlagName: string): TColor;
// SRMgrFrame Enable
procedure gf_EnableSRMgrFrame(pSRMgrFrame: TForm);
// SRMgrFrame Disable
procedure gf_DisableSRMgrFrame(pSRMgrFrame: TForm);
// Show Mail Snd
function gf_ShowMailSnd(pSndDate: string; SndItem: pTFSndMail): boolean;
// Show Mail Snt
function gf_ShowMailSnt(pSndDate: string; FreqItem: pTFreqMail): boolean;
// Edit Attatch File
function gf_EditAttFile(pFileName: string): boolean;



//------------------------------------------------------------------------------
// 결재 관련 처리 (사용자 Authority 처리 포함)
//------------------------------------------------------------------------------
// 결재 처리 관련 Report의 꼬리말 Return;
function gf_GetReportDecTail(pTrCode: Integer; pStlDate: string): string;
// 선행 TR의 결재 완료 확인 : 결재완료 -> True, 결재미완료 -> False
function gf_CheckPreTRProcess(pTrCode: Integer; pStlDate: string;
  var pMsg: string): boolean;
//후행 TR의 결재 진행 여부 확인 : 결재진행중 -> True, 결재미진행 -> False
function gf_CheckAfterTRProcess(pTrCode: Integer; pStlDate: string;
  var pMsg: string; iDecLevel: integer = 0): boolean;

//결재라인 취소 가능하냐?
function gf_CanCancelDecLine(pTrCode: Integer; pStlDate: string; pDecLevel: integer;
  var pMsg: string): boolean;
// 후행 TR의 결재 내역 Clear : Result -> 삭제 갯수
function gf_ClearAfterTRProcess(pTrCode: Integer; pStlDate: string): Integer;
// 화면권한여부 확인
function gf_CanUseTrCode(pTrCode: Integer): boolean;
// Enable Button
procedure gf_EnableBtn(pTrCode: Integer; pButton: TControl);


//------------------------------------------------------------------------------
// * 기타...
//------------------------------------------------------------------------------
//  전월 산출 pYearMonth : YYYYMM Return : YYYYMM
function gf_GetPreMonth(pYearMonth: string): string;
//  Numeric Data 여부 판단
function gf_IsNumeric(Value: string): boolean;
// 사용자 부서코드에 대응되는 SettleNet 부서코드 Return
function gf_GetGlobalDeptCode(pUserDeptCode: string;
  var pGlobalDeptCode: string): boolean;
// Show ICON Dialog (Result = 선택 Image Index)
function gf_ShowIconDlg(ScreenX, ScreenY, CurImageIdx: Integer): Integer;
// 사용자 정의 ToolBar 재구성
procedure gf_ResetUserToolBar;
// TrCode에 해당하는 메뉴이름 Return
function gf_TrCodeToMenuName(pTrCode: Integer; var pFullName,
  pShrtName: string): boolean;
// Execution Module의 Version을 리턴
function gf_ExeVersion(sExeFullPathFileName: string): string;
// 해당 일자의 선물정산이 되었는지 확인
function gf_FutDailySettled(pTradeDate: string): string;
// 두개의 StringList가 동일한지 판단
function gf_IsSameStringList(pStrList1, pStrList2: TStringList): boolean;
// 해당 SendMethod를 사용가능한지 판단
function gf_CanUseSendMtd(pSendMtdCode: string): boolean;
// NotePad 실행시키는 함수
procedure gf_ExecNotePad(pParentHandle: THandle; pFileName: string);
// Ini File에서 해당 Form의 정보를 읽어오는 함수(String Type)
function gf_ReadFormStrInfo(pFormName, pKeyName, pDefaultValue: string): string;
// Ini File에서 해당 Form의 정보를 읽어오는 함수(Integer Type)
function gf_ReadFormIntInfo(pFormName, pKeyName: string; pDefaultValue: Integer): Integer;
// Ini File에 해당 Form 정보 기록하는 함수(String Type)
procedure gf_WriteFormStrInfo(pFormName, pKeyName, pDefaultValue: string);
// Ini File에 해당 Form 정보 기록하는 함수(Integer Type)
procedure gf_WriteFormIntInfo(pFormName, pKeyName: string; pDefaultValue: Integer);
// 디렉토리간에 파일 복사
function gf_CopyFile(pSource, pDestn: string): boolean;
// 디렉토리 지우기 (Sub File 포함해서)
procedure gf_DelDirectory(DirectoryName: string);
// 디렉토리 관리(//COPY, DELETE, MOVE, RENAME)
function File_DirOperations_Datail(
  Action: string; //COPY, DELETE, MOVE, RENAME
  RenameOnCollision: Boolean; //Renames if directory exists
  NoConfirmation: Boolean; //Responds "Yes to All" to any dialogs
  Silent: Boolean; //No progress dialog is shown
  ShowProgress: Boolean; //displays progress dialog but no file names
  FromDir: string; //From directory
  ToDir: string //To directory
  ): Boolean;

// 컨트롤 정가운데로 정렬
procedure gf_ControlCenterAllign(pBackGroundControl, pFrontControl : TControl);

// Print Text File
function gf_PrintTextFile(pFileName, pOrientation: string; pMaxPageLineCnt: Integer): boolean;
// Print Memo
function gf_PrintMemo(pPrnMemo: TMemo; pOrientation: string;
  pMaxPageLineCnt: Integer): boolean;
// Main Frame의 Main Menu, ToolBar Enable
procedure gf_EnableMainMenu;
// Main Frame의 Main Menu, ToolBar Disable
procedure gf_DisableMainMenu;
// 수신처 등록 화면에서의 Send Method에 따른 Color Return
function gf_ReturnSendMtdColor(pSendMtd: string): TColor;
// Child Form 생성
procedure gf_CreateForm(pTrCode: Integer);
// Code Table 변경 후 호출 (MainFrame에 CodeList 갱신 message 전송)
procedure gf_RefreshCodeList(pCodeTableNo: Integer);
// Group Table 변경 후 호출 (MainFrame에 CodeList 갱신 message 전송)
procedure gf_RefreshGroupList;
// Global 변수 관련 데이터 변경 후 호출 (MainFrame에 Global var 갱신 message 전송)
procedure gf_RefreshGlobalVar(pGlobVarNo: Integer); overload;
procedure gf_RefreshGlobalVar(pGlobVarNo: Integer; pSetValue: Integer); overload;
// List Sort시 Item 크기 비교를 위한 함수(Floating)
function gf_ReturnFloatComp(pTemp1, pTemp2: double; pAscending: boolean): Integer;
// List Sort시 Item 크기 비교를 위한 함수(Sting)
function gf_ReturnStrComp(pTemp1, pTemp2: string; pAscending: boolean): Integer;
// 해당 화면에 대한 권한 여부 확인
function gf_CheckUsableMenu(pTrCode: Integer): boolean;
// 프린트 하기전 프린터 환경 설정
function gf_InitPrint(pPrnComponent: TObject): boolean;
// Application의 Root Path Return (SettleNet -> C:\Program Files\SettleNet\
function gf_GetAppRootPath: string;
// Row Selection의 위치를 SelRowIdx의 위치로 옮김
procedure gf_SelectStrGridRow(pStringGrid: TStringGrid; SelRowIdx: Integer);
// Cell Selection의 위치를 SelColIdx, SelRowIdx의위치로 옮김
procedure gf_SelectStrGridCell(pStringGrid: TStringGrid; SelColIdx, SelRowIdx: Integer);
// StringGrid의 Cell을 지워줌
procedure gf_ClearStrGrid(pStringGrid: TStringGrid; StartCol, StartRow, EndCol, EndRow: Integer);
// StringGrid의 FixedCell을 제외한 모든 Cell을 지워줌
procedure gf_ClearStrGridAll(pStringGrid: TStringGrid);
// StringGrid의 ColIdx, RowIdx에 해당하는 Cell Click
procedure gf_ClickStrGrid(pStringGrid: TStringGrid; ColIdx, RowIdx: Integer);
// 해당 Index를 StringGrid의 가장 상위 Row로 이동시킴
procedure gf_SetTopRow(pStringGrid: TStringGrid; CurIdx: Integer);
// 해당 Form 출력
//procedure gf_PrintForm(pPrintForm: TForm);

// 시스템옵션가져오기
function gf_GetSystemOptionValue(pOptCode, pDefaultValue: string): string;
function gf_GetSystemOptionInfo(pOptCode, pOptValue: string): string;


// 도스 환경변수 가져오기
function GetDosEnv(Value: string): string;

//기본Printer를 PDF Printer로
function gf_DefPrinter2PDFPrinter: boolean;

//PDF Printer에서 기본Printer로
function gf_PDFPrinter2DefPrinter: boolean;

//pwd 암호화
function gfEncryption(i_password, i_HashEncYN: string; var o_Shortpassword: string): string;
function gfDecryption(i_password, i_HashEncYN: string): string;

//계좌검색 창띄우기
function gf_ShowAccNoSearch(pSecType, pAccNo, pAccName: string): Integer;

function gf_CountQuery(pSQL: string): integer;
function gf_ReturnStrQuery(pSQL: string): string;
function IsCloseTradeDate(sTradeDate: string): boolean;

//그리드에서 해당 컬럼의 값 찾아 Row 리턴
function gf_FindRowInGrid(pStrGrid: TDRStringGrid; iCol: integer; sKey: string): integer;

function GetAveCharSize(Canvas: TCanvas): TPoint;

function InputQueryDRDateEdit(const ACaption, APrompt, APrompt2: string;
  var Value: string): Boolean;

//version dll, exe upgrade하기
function gf_VersionSync(pQuery: TADOQuery; pExtGB: string; pPanel: TDRPanel): string;

function gf_FormatTelNo(sTelNo: string): string;

//  OASYS Allocation 번호 채번 CON_SEQ_NO
function gf_GetOASYSSendSeqNo: Integer;

// 주식Off, 코스닥Off, 기타 수수료율 Get
//function gf_GetCommRateLst(pADOQuery : TADOQuery; pAccNo : String; var sEqtyOff, sKosqOff : String; var sAll : TList): Integer;
//function gf_GetCommRateStr(pADOQuery : TADOQuery; pAccNo : String; var sEqtyOff, sKosqOff, sAll : String): Integer;

function gf_GetHisTypeName(sHisType: string): string;

function gf_GetHisTypeShortName(sHisType: string): string;

function gf_GetHisDelTypeName(sHisType: string): string;

function gf_GetHisDelTypeShortName(sHisType: string): string;

function gf_UpdateManualChain(sTradeDate: string): boolean;

//소문자를 대문자로
function gf_ToUpper(var Key: char): char;

// round 함스들의 오류 따로 맹듬..
function gf_RoundTo(AValue: Double; ADigit: Double): Double;

// 올림 함수
Function gf_CeilingTo(AValue: Double; ADigit : Double) : Double;

//Host (HostGW or CICS) Interface ===============================================================
procedure myStr2Char(str: PChar; instr: string; len: longint);
function myChar2Str(str: PChar; len: longint): string;

//당일임시적용수수료율 원장 변경
function gf_HostCallsnchangeFee(sDate, sAccNo: string; dComRate: double; var sNotifyNeed: string; var sOut: string): boolean;
//당일임시적용수수료율 원장 변경(한투용)
function gf_HostCICSsnchangeFee(sDate, sAccNo: string; dComRate: double; var sNotifyNeed: string; var sOut: string): boolean;
//당일임시적용수수료율 원장 변경(HostGateWay용:하나대투) >>> 없음.

//원장에서 수수료계산
function gf_HostCallsncalculate(
  sTrdDate, sIssueCode, sTranCode, sTrdType,
  sAccNo, sStlDate: string; dAvrExecPrice, dTotExecQty, dTotExecAmt: double;
  var dComm: double; var dTrdTax: double; var dAgcTax: double;
  var dCpgTax: double; var dNetAmt: double; var dHCommRate: double;
  var sOut: string): boolean;

//원장에서 수수료계산(한투용)
function gf_HostCICSCalculate(
  sIssueCode, sTranCode, sTrdType,
  sAccNo, sStlDate: string; dAvrExecPrice, dTotExecQty, dTotExecAmt: double;
  var dComm: double; var dTrdTax: double; var dAgcTax: double;
  var dCpgTax: double; var dNetAmt: double; var dHCommRate: double;
  var sOut: string): boolean;

//원장에서 수수료계산(HostGateWay용:하나대투)
function gf_HostGateWayCalculate(
  pTrdDate, pIssueCode, pTranCode, pTrdType,
  pAccNo, pStlDate: string; dAvrExecPrice, dTotExecQty, dTotExecAmt: double;
  var dComm: double; var dTrdTax: double; var dAgcTax: double;
  var dCpgTax: double; var dNetAmt: double; var dHCommRate: double;
  var sOut: string): boolean;

//OMS 매매자료 생성 Call
function gf_HostCICSsngetOMSTRInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

//매매자료 생성 Call (한투용)
function gf_HostCICSsngetTRInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

//계좌자료 생성 Call (한투용)
function gf_HostCICSsngetACInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

//주식매매자료 생성 Call (하나대투용)
function gf_HostGateWaysngetTRInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

//선물매매자료 생성 Call (하나대투용)
function gf_HostGateWaysngetFTRInfo(sDate, sAccList, sFileName: string;
  var sOut: string;iTradeTypeIdx: integer): boolean;

//주식계좌자료 생성 Call (하나대투용)
function gf_HostGateWaysngetACInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

//선물계좌자료 생성 Call (하나대투용)
function gf_HostGateWaysngetFACInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

//Upload Call (한투용)
function gf_HostCICSsnprocessUploadData(sDate, sFileName, sWorkCode: string; var sOut: string): boolean;
function gf_HostCICSsnprocessUploadACData(sDate, sFileName, sWorkCode: string; var sOut: string): boolean;
//Upload Call (하나대투용)
function gf_HostGateWaysnprocessUploadData(sDate, sFileName: string; var sOut: string): boolean;

//고객파일 Upload Call
function gf_HostCICSsnprocessReqUploadData(sClient, sOrdd, sSettd, sWorkCode, sInputFile: string; var sOut: string): boolean;

function gf_AutoSplitAcc(AutoSplitList : TList) : boolean;


//Host (HostGW or CICS) Interface End ===========================================================

function gf_GetCommnTax(pADOQuery: TADOQuery; pTradeDate, pDeptCode, pAccNo, pHwAccNo,
  pIssueCode, pTranCode, pTradeType, pBrkShtNo, pStlDate: string; var sOutRtc: string): boolean;


function gf_GetCommnTax2(pMyTradeDate, pMyBrkShtNo,
  pMyIssueCode, pMyTranCode, pMyTradeType, pMyAccNo, pMyStlDate: string;
  pMyAvrExecPrice, pMyTotExecQty, pMyTotExecAmt: double;
  var pMyComm: double; var pMyTTax: double;
  var pMyATax: double; var pMyCTax: double;
  var pMyNetAmt: double; var pMyCommRate: double; var pMsg: string; pSettleNetCommCalcYN: string = 'N';
  pHwAccTaxUse: string = 'N'): boolean;

//수수료 보정위한 SP Call
function ExecuteCommBojung(
  in_user_id, in_dept_code, in_trade_date, in_acc_no,
  in_brk_sht_no, in_issue_code, in_tran_code, in_trade_type: string;
  in_my_amt, in_tot_amt, in_tot_comm, in_comm_rate: double;
  var out_comm: double; var out_netamt: double; var sMsg: string
  ): boolean;

//제세금 보정위한 SP Call
function ExecuteTaxBojung(
  in_user_id, in_dept_code, in_trade_date, in_acc_no,
  in_brk_sht_no, in_issue_code, in_tran_code, in_trade_type: string;
  in_my_amt, in_my_comm, in_tot_amt,
  in_tot_ttax, in_tot_atax, in_tot_ctax: double;
  var out_ttax: double; var out_atax: double;
  var out_ctax: double; var out_netamt: double; var sMsg: string
  ): boolean;


//------------------------------------------------------------------------------
// 단가별 주문번호에 복사 하는 녀석 // 나머지 녀석들은  = 0
//------------------------------------------------------------------------------
function gf_CopyTradeToOrdTd(ADOQuery_Trade, ADOQuery_Ordexe: TADOQuery;
  TradeDate, DeptCode, AccNo, SubAccNo, IssueCode, TranCode, TradeType, BrkShtNo: string): boolean;

//------------------------------------------------------------------------------
// 단가별 주문번호에 복사 하는 녀석 선물용 // 나머지 녀석들은  = 0
//------------------------------------------------------------------------------
function gf_CopyTradeToOrdTdF(ADOQuery_Trade, ADOQuery_Ordexe: TADOQuery;
  TradeDate, DeptCode, AccNo, SubAccNo, IssueCode, TranCode, TradeType: string): boolean;

//엑셀 OLE 가져오기, 없을 경우 실행시킴
function gf_GetExcelOleObject(bBackGround: boolean = False): Variant;

function GridColToXLCol(iCol: integer): string;

function gf_ExecQuery(pSQL: string): Boolean;

//백그라운드 엑셀띄울때 오류보고 안나오게하기
procedure gfSetDWNeverUpload;


//------------------------------------------------------------------------------
// 선물 Import 위한 CICS Call
//------------------------------------------------------------------------------
//계좌자료 생성 Call
function gf_HostCICSsngetFACInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

//매매자료 생성 Call
function gf_HostCICSsngetFTRInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

//예탁자료 생성 Call
function gf_HostCICSsngetFDPInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

//미결제자료 생성 Call
function gf_HostCICSsngetFOPInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

//대용자료 생성 Call
function gf_HostCICSsngetFLNInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;


//------------------------------------------------------------------------------

// Trunc 버그 함수로 만듬   String 변환 다시 Double 하면 문제가없음
function gf_Trunc(X: Double): Double;

//------------------------------------------------------------------------------


function gf_GetProcCnt(sProcName: string): Integer;

//---------------------------------------------------------------------------
// 화면사용및 로그인, 계정변경 로그기록 처리 함수.
//---------------------------------------------------------------------------
function gf_LogLstWrite(pADOQuery: TADOQuery; sDeptcd, sLogcd, sOprId, sOprDate, sStrTm, sEndTm,
  sOprIP, sEditUsr, sTrCd, sComment, sIUPos: string): Boolean;

function gf_GetLocalIP(Name: string; var IP: string): Boolean;

procedure gf_ExcelSaveAs(pXL: Variant; pFileName: string; pFileFormat: Integer = xlExcel9795);
function gf_GetXLOptionValue: string;


// [Y.S.M] 2011.2.1 ============================================================
// 처음값 마지막 값을 받아 그 사이에 있는 값을  Return한다
function Gf_InsideString(const S, FirstString, LastString: string): string; overload;

function Gf_InsideString(const S, FirstString: string): string; overload;

// 포지션 사이에 있는값을 Date 포맷으로 가져와서 해당 포지션 데이터를 치환 한다.
function Gf_FormatDateDollarDollar(const S: string; pDate: TDateTime): string;

//==============================================================================

//  [Y.S.M] 2011.09.02
// StringList는 #0(Null) ~ ' '(공백까지) Delimiter로 인식.. 함수로 변경함..
// 파라메터 StrictDelimiter:=True; 가 있지만 델파이 2007 이상 부터 생김..
procedure gf_DelimiterStringList(Delimiter: char; DelimitedText: string; var pStringList: TStringList);

// [Y.K.J] 2012.05.05 데이터 체크 (SP: SBP2801_TDC)
procedure gf_ExecSBP2801_TDC(iTrCode: integer; sDeptCode, sTradeDate: string);

function gf_GetCTMID(sTradeDate, sGB: string): string;


// [Y.S.M] 2012.08.08 //Computer 이름 가져오기
//function gf_GetComName: string;
// Computer IP 구해오기
function gf_GetComIP: String;
// Computer IP 를 구해와서 Hex로 변환
function gf_GetComIpToHex : string;

// 메일묶음처리 함수
function gf_ShowMergeMail(var GrpName, MailformId: string): Boolean;

//------------------------------------------------------------------------------
// PDF Engine 사용 시 인쇄 함수
//------------------------------------------------------------------------------
procedure gf_DirectPrintForPDF(pPDFFileName: string);

//------------------------------------------------------------------------------
// 파일 잠겨있는것 확인
//------------------------------------------------------------------------------
function gf_IsFileInUse(fName: string): boolean;


//------------------------------------------------------------------------------
// Fax ComPort Open/Close 오류 시 처리 메시지
//------------------------------------------------------------------------------
procedure gf_FaxErrMaxCntErrMsg(pADOQuery : TADOQuery; pLabel : TDRLabel);

//------------------------------------------------------------------------------
// EMail Connection/Login 오류 시 처리 메시지
//------------------------------------------------------------------------------
procedure gf_EmailErrMsg(pADOQuery : TADOQuery; pLabel : TDRLabel);


//------------------------------------------------------------------------------
// 종합계좌번호, 상품코드, 잔고번호 formatting 00000000-00-0000
//------------------------------------------------------------------------------
function gf_FormatAccNo_FI(pAccNo, pPrdNo, pBlcNo: string): string;

//------------------------------------------------------------------------------
// 금융상품 첨부파일명 변환
//------------------------------------------------------------------------------
function gf_ConvertText_FI(pOldText, pFileNameInfo, pAccNo, pPrdNo, pBlcNo,
  pCreDate: String): String;


implementation

uses
  SCCDataModule, SCCPreviewForm, UCrpe32, StrUtils, SCFH2106_MD, SCFH3106_MD, SCCMergeMail,
  SCCTFLib, SCCPreviewFormPDF;

//------------------------------------------------------------------------------
//  Crystal 10 DLL Registry 등록하기 Function //2006.04.10 Delphi 7 version 추가 1
//------------------------------------------------------------------------------
//Crystal 10 Dll은 반드시 Registry에 등록해서 써야 한다.
//별도로 Settup 작업을 하면 되지만 두고두고 귀찮은 작업이다
//따라서 Registry를 건들 수 없는 외국계를 제외하고
//Application 초입에 자동으로 Crystal Dll을 설치한다.
//물론, 기 설치된 PC는 제외한다.

function gf_DllSetup: boolean;

  function IsInstalledActiveX(ClassName: string): Boolean;
  var
    GUID: TGUID;
  begin
    Result := Succeeded(CLSIDFromProgID(PWideChar(WideString(ClassName)), GUID));
  end;

  function ComRegister(Filename: string): boolean;
  begin
    Result := false;
    if not FileExists(Filename) then Exit;
    try
      if FileExists(FileName) then
        RegisterComServer(FileName);
    except
      Exit;
    end;
    Result := true;
  end;

var Reg: TRegistry;
  s, sPath: string;
begin
  sPath := ExtractFilePath(Application.ExeName);
  try
    try
      //sFtp activex 설치
      if not IsInstalledActiveX('Chilkat.SFtpDir.1') then
      begin
//        if Not ComRegister('EChilkatSsh.dll') then Exit;
        ComRegister('EChilkatSsh.dll');
      end;

      //DynamicPDF Viewer 설치
      if not IsInstalledActiveX('Dynamic.DynamicViewerCtrl.2') then
      begin
        if  FileExists('DynamicPDFViewer.ocx') then
        begin
          ComRegister('DynamicPDFViewer.ocx');
        end;
      end;

      Reg := TRegistry.Create;
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if Reg.OpenKey('\SOFTWARE\Crystal Decisions\10.0\Crystal Reports', true) then
      begin
        //해당 PC에 이미 Crystal Report 10이 깔려있습니다
        if trim(Reg.ReadString('Version')) > '' then Exit;

        //이미 등록되어 있으면 설치 안함. 그게 맞든 안맞든.
        s := Trim(Reg.ReadString('CommonFiles'));
        if s = '' then Reg.WriteString('CommonFiles', sPath);
        if not IsInstalledActiveX('CrystalRuntime.Report.10') then
        begin
          if not ComRegister('craxdrt.dll') then Exit;
        end;
        if not IsInstalledActiveX('CrystalReports10.EmbeddableCrystalReportsDesignerCtrl.1') then
        begin
          if not ComRegister('crdesignerctrl.dll') then Exit;
        end;
        if not IsInstalledActiveX('QueryEngine.QESession.10.0') then
        begin
          if not ComRegister('crqe.dll') then Exit;
        end;
        if not IsInstalledActiveX('CrystalReports10.ExactModeller.1') then
        begin
          if not ComRegister('exportModeller.dll') then Exit;
        end;
        if not IsInstalledActiveX('CrystalReports10.Tslv.1') then
        begin
          if not ComRegister('crtslv.dll') then Exit;
        end;

        Reg.CloseKey;
      end;
      //else 오픈 못함, //Registry Read / Write 권한이 없을때 그냥 소리없이 사라지자. 외국계땜시.

      //Fax보고서 
			//Export시 미리보기와 틀려지는 문제 해결 레지스트
      Reg.RootKey:= HKEY_CURRENT_USER;
      if Reg.OpenKey('\SOFTWARE\Crystal Decisions\10.0\Crystal Reports\Export\PDF\', true) then
      begin
        Reg.WriteInteger('ForceLargerFonts',1);
        Reg.CloseKey;
      end;

    except //Registry Read / Write 권한이 없을때 그냥 소리없이 사라지자. 외국계땜시.
    end;
  finally
    Reg.Free;
  end;
end;

//------------------------------------------------------------------------------
//  EMail File 생성 Main Function
//------------------------------------------------------------------------------

function gf_CreateEMailFile(pEMailFormId, pDirName, pDeptCode, pTradeDate: string;
  pGrpName: string; AccNoList: TStringList; var FileName: string;
  CreateFlag: boolean): boolean;

type // EMailFile 생성 Function Type
  TCrePMailFunc = function(MainADOC: TADOConnection;
    EmailID, DirName, DeptCode, TradeDate, OprUsrNo: string; pGrpName: string;
    AccNoList: TStringList; CreateFlag, IsXlsFlag: boolean;
    FileName: PChar; var ErrorNo: Integer; ExtMsg: PChar): boolean; StdCall;

var
  CreEMailFunc: TCreEMailFunc;
  DllHandle: THandle;
  sDllName, sFuncName: string;
  iErrorNo: Integer;
  ExtMsgArr: array[0..1024] of Char;
  //FileNameArr: array[0..10000] of Char;
  FileNameArr: array of Char;

  ADOQuery_IsPDF, ADOQuery_SUGPMEL_TBL: TADOQuery;
  CrePMailFunc: TCrePMailFunc;
  IsPDF, IsPDFXls: Boolean;
  dt: DWORD;
  sSiteEmailDir: string;
  RealMailID: string;
  sXlsRPassWd, sXlsWPassWd: string; // 읽기, 쓰기 암호 변수
begin

  FileName := ''; // Clear
  Result := True;

  SetLength(FileNameArr, 100000);

//******P.H.S*******************************************************************
//******2006.04*****************************************************************
  try
    try
      ADOQuery_IsPDF := TADOQuery.Create(nil);
      IsPDF := False;
      IsPDFXls := False;
      with ADOQuery_IsPDF do begin
        Close;
        Connection := DataModule_SettleNet.ADOConnection_Main;
        SQL.Add('SELECT REPORT_ID, MAILFORM_NAME_KOR FROM SCMELID_TBL '
          + 'WHERE MAILFORM_ID = ''' + pEMailFormID + '''');
        Open;

        if (RecordCount > 0) and (Trim(FieldByName('REPORT_ID').AsString) <> '') then
        begin
          IsPDF := True;
          if Pos('엑셀', Trim(FieldByName('MAILFORM_NAME_KOR').AsString)) <> 0 then
            IsPDFXls := True;
        end;
      end;
    finally
      if Assigned(ADOQuery_IsPDF) then begin
        ADOQuery_IsPDF.Close;
        ADOQuery_IsPDF.Free;
      end;
    end;
  except
    on E: Exception do
    begin
      result := False;
    end;
  end;

   //============================================================================
   //  수신처에 등록된 읽기/쓰기 암호 가져오기 ([Y.K.J]2011.01.27)
   //============================================================================
  if CreateFlag then
  begin
    try
      try
        ADOQuery_SUGPMEL_TBL := TADOQuery.Create(nil);
        with ADOQuery_SUGPMEL_TBL do
        begin
          sXlsRPassWd := '';
          sXlsWPassWd := '';

          Close;
          Connection := DataModule_SettleNet.ADOConnection_Main;
          SQL.Add(' SELECT R_PASSWD, W_PASSWD                  '
            + ' FROM SUGPMEL_TBL                           '
            + ' WHERE DEPT_CODE = ''' + pDeptCode + '''      '
            + '   AND GRP_NAME = ''' + pGrpName + '''        '
            + '   AND MAILFORM_ID = ''' + pEMailFormId + ''' ');
          Open;

          if RecordCount > 0 then
          begin
            sXlsRPassWd := Trim(FieldByName('R_PASSWD').AsString);
            sXlsWPassWd := Trim(FieldByName('W_PASSWD').AsString);
          end;
          gf_WriteFormStrInfo('Excel Option', 'R_PASSWD', sXlsRPassWd);
          gf_WriteFormStrInfo('Excel Option', 'W_PASSWD', sXlsWPassWd);
          gf_WriteFormStrInfo('Excel Option', 'TRADE_DATE',pTradeDate);
        end;
      finally
        if Assigned(ADOQuery_SUGPMEL_TBL) then
        begin
          ADOQuery_SUGPMEL_TBL.Close;
          ADOQuery_SUGPMEL_TBL.Free;
        end;
      end;
    except
      on E: Exception do result := False;
    end;
  end; // if CreateFlag then

  FillChar(ExtMsgArr, SizeOf(ExtMsgArr), #0);

  if IsPDF then begin
    sDllName := 'EH_PDFDLL.DLL';
    sFuncName := 'gf_CreatePDFFile';

    dt := GetTickCount;
    DllHandle := LoadLibrary(pChar(sDllName));
    dt := GetTickCount - dt;
    gf_Log('PDF LoadLibrary : ' + pEMailFormID + ' (' + IntToStr(dt) + ')');

    if (DllHandle = HINSTANCE_ERROR) or (DllHandle = 0) then
    begin
      Result := False;
      gvErrorNo := 9108; // DLL Load 오류
      gvExtMsg := sDllName;
      Exit;
    end;

    try
      try

        dt := GetTickCount;

        @CrePMailFunc := GetProcAddress(DllHandle, pChar(sFuncName));
        if @CrePMailFunc <> nil then
        begin
          if not CrePMailFunc(DataModule_SettleNet.ADOConnection_Main,
            pEMailFormID, pDirName, pDeptCode, pTradeDate, gvOprUsrNo, pGrpName,
            AccNoList, CreateFlag, IsPDFXls,
            PChar(FileNameArr), iErrorNo, ExtMsgArr) then
          begin
            Result := False;
            gvErrorNo := iErrorNo;
            gvExtMsg := StrPas(ExtMsgArr);
          end
          else
            FileName := StrPas(PChar(FileNameArr));
        end;
        dt := GetTickCount - dt;
        gf_Log('PDF CrePMailFunc : ' + pEMailFormID + ' (' + IntToStr(dt) + ')');

      except
        on E: Exception do
        begin
          Result := False;
          gvErrorNo := 1134; // PDF 자료 생성 오류
          gvExtMsg := E.Message;
        end;
      end;
    finally
      FreeLibrary(DllHandle);
    end;

  end else
  begin
    //  메일 묶음 기능 추가
    //  묶음 메일일때는 묶음 메일에서 처리
    RealMailID := '';
    if Copy(pEMailFormId, 3, 1) = 'M' then
    begin
      RealMailID := pEMailFormId;
      pEMailFormId := 'MERGEMAIL';
      // YSM -> 메일묶음에 대한 서식 처리
      // ExtMsgArr 에러 처리 하는부분에 실제 아이디를 넘겨줌.
      StrPCopy(ExtMsgArr, RealMailID);
      // EG_PDFDLL을 타냐.. 아니면 E_PDFDLL이냐..
      // NM버전은  EN_PDFDLL = 2   Fix
      // TF버전은  EH_PDFDLL = 3   Fix
      // iErrorNo 이용해서 넘겨줌..
      {if gvSettleNetGlobalYN = 'Y' then
        iErrorNo := 1
      else
        iErrorNo := 0;}
       iErrorNo := 3;
    end;


    sDllName := pEMailFormId + '.DLL';
    sFuncName := 'gf_' + pEMailFormId;

      //20090819, DataRoad DB Only, 각Site별 SiteEmail Directory 이름, Default ''
    sSiteEmailDir := gf_GetSystemOptionValue('A02', '');
    if sSiteEmailDir > '' then
    begin
      sSiteEmailDir := 'c:\SettleNetTF\SiteEmail\' + sSiteEmailDir + '\Bin\';
      DllHandle := LoadLibrary(pChar(sSiteEmailDir + sDllName));
      if (DllHandle = HINSTANCE_ERROR) or (DllHandle = 0) then
      begin
        DllHandle := LoadLibrary(pChar(sDllName));
        if (DllHandle = HINSTANCE_ERROR) or (DllHandle = 0) then
        begin
          Result := False;
          gvErrorNo := 9108; // DLL Load 오류
          gvExtMsg := sDllName;
          Exit;
        end;
      end;
    end
    else //거래처 Real DB : Client Bin에서만 찾지...
    begin
      DllHandle := LoadLibrary(pChar(sDllName));
      if (DllHandle = HINSTANCE_ERROR) or (DllHandle = 0) then
      begin
        Result := False;
        gvErrorNo := 9108; // DLL Load 오류
        gvExtMsg := sDllName;
        Exit;
      end;
    end;
{
dt := GetTickCount;
      DllHandle := LoadLibrary(pChar(sDllName));
dt := GetTickCount - dt;
gf_Log('Email LoadLibrary : ' + pEMailFormID + ' (' + IntToStr(dt) + ')');
      if (DllHandle = HINSTANCE_ERROR) or (DllHandle = 0) then
      begin
         Result    := False;
         gvErrorNo := 9108;  // DLL Load 오류
         gvExtMsg  := sDllName;
         Exit;
      end;
}
    try
      try
        dt := GetTickCount;
        @CreEMailFunc := GetProcAddress(DllHandle, pChar(sFuncName));
        if @CreEMailFunc <> nil then
        begin

          if not CreEMailFunc(DataModule_SettleNet.ADOConnection_Main,
            pDirName, pDeptCode, pTradeDate, pGrpName,
            AccNoList, CreateFlag,
            PChar(FileNameArr), iErrorNo, ExtMsgArr) then
          begin

            Result := False;
            gvErrorNo := iErrorNo;
            gvExtMsg := StrPas(ExtMsgArr);
          end
          else
            FileName := StrPas(PChar(FileNameArr));
        end;
        dt := GetTickCount - dt;
        gf_Log('Email CrePMailFunc : ' + pEMailFormID + ' (' + IntToStr(dt) + ')');
      except
        on E: Exception do
        begin
          Result := False;
          gvErrorNo := 1134; // EMail 자료 생성 오류
          gvExtMsg := E.Message;
        end;
      end;
    finally
      FreeLibrary(DllHandle);
    end;

  end;
end;
//------------------------------------------------------------------------------
// gvIssueList에서 해당 종목코드에 부합되는 Index 리턴
//------------------------------------------------------------------------------

function gf_ReturnIssueCodeIdx(pIssueList: TList; pIssueCode: string): Integer;
var
  I: Integer;
  IssueItem: pTIssueType;
begin
  Result := -1;
  for I := 0 to pIssueList.Count - 1 do
  begin
    IssueItem := pIssueList.Items[I];
    if IssueItem.Code = pIssueCode then
    begin
      Result := I;
      break;
    end;
  end;
end;

//------------------------------------------------------------------------------
// 종목코드의 관련 정보(TIssueType) 리턴 (해당 종목 존재하지 않을 경우 False Return)
//------------------------------------------------------------------------------

function gf_ReturnIssueInfo(pSecType, pIssueCode: string; var pIssueItem: pTIssueType): boolean;
var
  Idx: Integer;
begin
  Result := False;
  pIssueItem := nil;
  if pSecType = gcSEC_EQUITY then // 주식
  begin
    Idx := gf_ReturnIssueCodeIdx(gvEIssueList, pIssueCode);
    if Idx >= 0 then // 해당 종목 존재시
    begin
      pIssueItem := gvEIssueList.Items[Idx];
      Result := True;
    end;
  end
  else if pSecType = gcSEC_FUTURES then // 선물
  begin
    Idx := gf_ReturnIssueCodeIdx(gvFIssueList, pIssueCode);
    if Idx >= 0 then // 해당 종목 존재시
    begin
      pIssueItem := gvFIssueList.Items[Idx];
      Result := True;
    end;
  end;
end;

//------------------------------------------------------------------------------
// 종목코드를 종목표준코드로 변환
//------------------------------------------------------------------------------

function gf_IssueCodeToFullCode(pSecType, pIssueCode: string): string;
var
  Idx: Integer;
  IssueItem: pTIssueType;
begin
  Result := '';
  if pSecType = gcSEC_EQUITY then //주식
  begin
    Idx := gf_ReturnIssueCodeIdx(gvEIssueList, pIssueCode);
    if Idx >= 0 then
    begin
      IssueItem := gvEIssueList.Items[Idx];
      Result := IssueItem.FullCode;
    end;
  end
  else if pSecType = gcSEC_FUTURES then // 선물
  begin
    Idx := gf_ReturnIssueCodeIdx(gvFIssueList, pIssueCode);
    if Idx >= 0 then
    begin
      IssueItem := gvFIssueList.Items[Idx];
      Result := IssueItem.FullCode;
    end;
  end;
end;

//------------------------------------------------------------------------------
// 종목코드를 종목명으로 변환
//------------------------------------------------------------------------------

function gf_IssueCodeToFullName(pSecType, pIssueCode: string): string;
var
  Idx: Integer;
  IssueItem: pTIssueType;
begin
  Result := '';
  if pSecType = gcSEC_EQUITY then //주식
  begin
    Idx := gf_ReturnIssueCodeIdx(gvEIssueList, pIssueCode);
    if Idx >= 0 then
    begin
      IssueItem := gvEIssueList.Items[Idx];
      Result := IssueItem.FullName;
    end;
  end
  else if pSecType = gcSEC_FUTURES then //선물
  begin
    Idx := gf_ReturnIssueCodeIdx(gvFIssueList, pIssueCode);
    if Idx >= 0 then
    begin
      IssueItem := gvFIssueList.Items[Idx];
      Result := IssueItem.FullName;
    end;
  end;
end;

//------------------------------------------------------------------------------
// 종목코드를 종목단축명으로 변환
//------------------------------------------------------------------------------

function gf_IssueCodeToShortName(pSecType, pIssueCode: string): string;
var
  Idx: Integer;
  IssueItem: pTIssueType;
begin
  Result := '';
  if pSecType = gcSEC_EQUITY then //주식
  begin
    Idx := gf_ReturnIssueCodeIdx(gvEIssueList, pIssueCode);
    if Idx >= 0 then
    begin
      IssueItem := gvEIssueList.Items[Idx];
      Result := IssueItem.ShrtName;
    end;
  end
  else if pSecType = gcSEC_FUTURES then
  begin
    Idx := gf_ReturnIssueCodeIdx(gvFIssueList, pIssueCode);
    if Idx >= 0 then
    begin
      IssueItem := gvFIssueList.Items[Idx];
      Result := IssueItem.ShrtName;
    end;
  end;
end;

//------------------------------------------------------------------------------
// 종목명울 종목코드로 변환
//------------------------------------------------------------------------------

function gf_IssueFullNameToCode(pSecType, pIssueName: string): string;
var
  I: Integer;
  IssueItem: pTIssueType;
begin
  Result := '';
  if pSecType = gcSEC_EQUITY then //주식
  begin
    for I := 0 to gvEIssueList.Count - 1 do
    begin
      IssueItem := gvEIssueList.Items[I];
      if pIssueName = IssueItem.FullName then
      begin
        Result := IssueItem.Code;
        break;
      end;
    end
  end
  else if pSecType = gcSEC_FUTURES then // 선물
  begin
    for I := 0 to gvFIssueList.Count - 1 do
    begin
      IssueItem := gvFIssueList.Items[I];
      if pIssueName = IssueItem.FullName then
      begin
        Result := IssueItem.Code;
        break;
      end;
    end
  end;
end;

//------------------------------------------------------------------------------
// 종목단축명을 종목코드로 변환
//------------------------------------------------------------------------------

function gf_IssueShortNameToCode(pSecType, pIssueName: string): string;
var
  I: Integer;
  IssueItem: pTIssueType;
begin
  Result := '';
  if pSecType = gcSEC_EQUITY then //주식
  begin
    for I := 0 to gvEIssueList.Count - 1 do
    begin
      IssueItem := gvEIssueList.Items[I];
      if pIssueName = IssueItem.ShrtName then
      begin
        Result := IssueItem.Code;
        break;
      end;
    end
  end
  else if pSecType = gcSEC_FUTURES then // 선물
  begin
    for I := 0 to gvFIssueList.Count - 1 do
    begin
      IssueItem := gvFIssueList.Items[I];
      if pIssueName = IssueItem.ShrtName then
      begin
        Result := IssueItem.Code;
        break;
      end;
    end
  end;
end;

//------------------------------------------------------------------------------
// 종목리스트 정렬
// 코드순 정렬: pAscCodeFlag = True, 코드명순 정렬: pAscCodeFlag = False
//------------------------------------------------------------------------------

function IssueListCompareCode(Item1, Item2: Pointer): Integer;
begin
  if pTIssueType(Item1).Code > pTIssueType(Item2).Code then
    Result := 1
  else if pTIssueType(Item1).Code = pTIssueType(Item2).Code then
    Result := 0
  else
    Result := -1;
end;

function IssueListCompareName(Item1, Item2: Pointer): Integer;
begin
  if pTIssueType(Item1).FullName > pTIssueType(Item2).FullName then
    Result := 1
  else if pTIssueType(Item1).FullName = pTIssueType(Item2).FullName then
    Result := 0
  else
    Result := -1;
end;

procedure gf_SortIssueList(pIssueList: TList; pAscCodeFlag: boolean);
begin
  if pAscCodeFlag then // 코드순으로 정렬
    pIssueList.Sort(IssueListCompareCode)
  else // 코드명순으로 정렬
    pIssueList.Sort(IssueListCompareName);
end;

//------------------------------------------------------------------------------
// CodeList를 참조하여 Code를 Name으로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_CodeToName(pList: TList; pCode: string): string;
var
  CodeItem: pTCodeType;
  I, Idx: Integer;
begin
  Result := '';
  Idx := -1;
  CodeItem := nil;
  for I := 0 to pList.Count - 1 do
  begin
    CodeItem := pList.Items[I];
    if CodeItem.Code = pCode then
    begin
      Idx := I;
      break;
    end;
  end;
  if Idx < 0 then Exit; // 해당 Party ID 존재하지 않음
  Result := CodeItem.Name;
end;

//------------------------------------------------------------------------------
// CodeList를 참조하여 Name을 Code로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_NameToCode(pList: TList; pName: string): string;
var
  CodeItem: pTCodeType;
  I, Idx: Integer;
begin
  Result := '';
  Idx := -1;
  CodeItem := nil;
  for I := 0 to pList.Count - 1 do
  begin
    CodeItem := pList.Items[I];
    if CodeItem.Name = pName then
    begin
      Idx := I;
      break;
    end;
  end;
  if Idx < 0 then Exit; //해당 Party Name이 존재하지 않음
  Result := CodeItem.Code;
end;

//------------------------------------------------------------------------------
// DeptCode를 Name으로 변환하여 리천
//------------------------------------------------------------------------------

function gf_DeptCodeToName(pDeptCode: string): string;
begin
  Result := gf_CodeToName(gvDeptCodeList, pDeptCode);
end;

//------------------------------------------------------------------------------
// DeptName을 Code로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_DeptNameToCode(pDeptName: string): string;
begin
  Result := gf_NameToCode(gvDeptCodeList, pDeptName);
end;

//------------------------------------------------------------------------------
// FundType을 Name으로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_FundTypeToName(pFundType: string): string;
begin
  Result := gf_CodeToName(gvFundTypeList, pFundType);
end;

//------------------------------------------------------------------------------
// Fundtype명을 FundType으로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_FundTypeNameToType(pFundTypeName: string): string;
begin
  Result := gf_NameToCode(gvFundTypeList, pFundTypeName);
end;

//------------------------------------------------------------------------------
// Sec Type을 Name으로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_SecTypeToName(pSecType: string): string;
begin
  Result := gf_CodeToName(gvSecTypeList, pSecType);
end;

//------------------------------------------------------------------------------
// Sec Name을 Type으로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_SecNameToType(pSecName: string): string;
begin
  Result := gf_NameToCode(gvSecTypeList, pSecName);
end;

//------------------------------------------------------------------------------
// Tran Mtd를 Name으로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_TranMtdToName(pTranMtd: string): string;
begin
  Result := gf_CodeToName(gvTranMtdList, pTranMtd);
end;

//------------------------------------------------------------------------------
// Tran Mtd Name을 Tran Mtd 로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_TranNametoMtd(pTranName: string): string;
begin
  Result := gf_NameToCode(gvTranMtdList, pTranName);
end;

//------------------------------------------------------------------------------
// Com Type을 Name으로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_ComTypeToName(pComType: string): string;
begin
  Result := gf_CodeToName(gvComTypeList, pComType);
end;

//------------------------------------------------------------------------------
// Com Name을 Type으로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_ComNameToType(pComName: string): string;
begin
  Result := gf_NameToCode(gvComTypeList, pComName);
end;

//------------------------------------------------------------------------------
// Mkt Type을 Name으로 변화하여 리턴
//------------------------------------------------------------------------------

function gf_MktTypeToName(pMktType: string): string;
begin
  Result := gf_CodeToName(gvMktTypeList, pMktType);
end;

//------------------------------------------------------------------------------
// Mkt Name을 Type으로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_MktNameToType(pMktName: string): string;
begin
  Result := gf_NameToCode(gvMktTypeList, pMktName);
end;

//------------------------------------------------------------------------------
// Tran Code를 Name으로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_TranCodeToName(pTranCode: string): string;
begin
  Result := gf_CodeToName(gvTranCodeList, pTranCode);
end;

//------------------------------------------------------------------------------
// Tran Code Name을 Tran Code로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_TranNameToCode(pTranName: string): string;
begin
  Result := gf_NameToCode(gvTranCodeList, pTranName);
end;

//------------------------------------------------------------------------------
// PartyID를 Name으로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_PartyIDToName(pPartyID: string): string;
begin
  Result := gf_CodeToName(gvPartyIDList, pPartyID);
end;

//------------------------------------------------------------------------------
// Party Name을 ID로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_PartyNameToID(pPartyName: string): string;
begin
  Result := gf_NameToCode(gvPartyIDList, pPartyName);
end;

//------------------------------------------------------------------------------
// TeamCode를 Name으로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_TeamCodeToName(pTeamCode: string): string;
begin
  Result := gf_CodeToName(gvTeamCodeList, pTeamCode);
end;
//------------------------------------------------------------------------------
// TeamName을 Code로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_TeamNameToCode(pTeamName: string): string;
begin
  Result := gf_NameToCode(gvTeamCodeList, pTeamName);
end;

//------------------------------------------------------------------------------
// RoleCode를 Name으로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_RoleCodeToName(pRoleCode: string): string;
begin
  Result := gf_CodeToName(gvRoleCodeList, pRoleCode);
end;

//------------------------------------------------------------------------------
// RoleName을 Code로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_RoleNameToCode(pRoleName: string): string;
begin
  Result := gf_NameToCode(gvRoleCodeList, pRoleName);
end;

//------------------------------------------------------------------------------
// ReprotID를 Name으로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_ReportIDToName(pReportID: string): string;
var
  RepItem: pTReportType;
  I: Integer;
begin
  Result := '';
  for I := 0 to gvReportIdList.Count - 1 do
  begin
    RepItem := gvReportIdList.Items[I];
    if RepItem.ReportId = pReportId then
    begin
      Result := RepItem.ReportName;
      Exit;
    end;
  end;
end;

//------------------------------------------------------------------------------
// ReportName을 Report ID로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_ReportNameToID(pReportName: string): string;
var
  RepItem: pTReportType;
  I: Integer;
begin
  Result := '';
  for I := 0 to gvReportIdList.Count - 1 do
  begin
    RepItem := gvReportIdList.Items[I];
    if RepItem.ReportName = pReportName then
    begin
      Result := RepItem.ReportId;
      Exit;
    end;
  end;
end;

//------------------------------------------------------------------------------
// CompCode를 Name으로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_CompCodeToName(pCompCode: string): string;
var
  CompItem: pTCompCodeType;
  I: Integer;
begin
  Result := '';
  for I := 0 to gvCompCodeList.Count - 1 do
  begin
    CompItem := gvCompCodeList.Items[I];
    if CompItem.Code = pCompCode then
    begin
      Result := CompItem.Name;
      Exit;
    end;
  end; // end of for
end;

//------------------------------------------------------------------------------
// CompName을 Code로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_CompNameToCode(pCompName: string): string;
var
  CompItem: pTCompCodeType;
  I: Integer;
begin
  Result := '';
  for I := 0 to gvCompCodeList.Count - 1 do
  begin
    CompItem := gvCompCodeList.Items[I];
    if CompItem.Name = pCompName then
    begin
      Result := CompItem.Code;
      Exit;
    end;
  end; // end of for
end;

//------------------------------------------------------------------------------
// 해당 Report에 대한 Direction 리턴
//------------------------------------------------------------------------------

function gf_GetReportDirection(pReportId: string): string;
var
  RepItem: pTReportType;
  I: Integer;
begin
  Result := gcLandscape; // Default
  for I := 0 to gvReportIdList.Count - 1 do
  begin
    RepItem := gvReportIdList.Items[I];
    if RepItem.ReportId = pReportId then
    begin
      Result := RepItem.Direction;
      Exit;
    end;
  end;
end;

//------------------------------------------------------------------------------
// 해당 Report에 대한 ReportType 리턴
//------------------------------------------------------------------------------

function gf_GetReportType(pReportId: string): string;
var
  RepItem: pTReportType;
  I: Integer;
begin
  Result := gcRTYPE_CRPT; // Default
  for I := 0 to gvReportIdList.Count - 1 do
  begin
    RepItem := gvReportIdList.Items[I];
    if RepItem.ReportId = pReportId then
    begin
      if RepItem.TextYn = 'Y' then
        Result := gcRTYPE_TEXT;
      Exit;
    end;
  end;
end;

//------------------------------------------------------------------------------
// FundType을 Name으로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_FundTypeCodeToName(pFundTypeCode: string): string;
begin
  Result := gf_CodeToName(gvFundTypeList, pFundTypeCode);
end;

//------------------------------------------------------------------------------
// FundTypeName을 Type으로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_FundTypeNameToCode(pFundTypeName: string): string;
begin
  Result := gf_NameToCode(gvFundTypeList, pFundTypeName);
end;

//------------------------------------------------------------------------------
// SellBuyCode를 Name으로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_SellBuyCodeToName(pCode: string): string;
begin
  Result := '';
  if pCode = gcTRADE_BUY then Result := gwBuy
  else if pCode = gcTRADE_SELL then Result := gwSell
  else if pCode = gcTRADE_BUY_OFF then Result := gwBuyToOffset
  else if pCode = gcTRADE_SELL_OFF then Result := gwSellToOffset
  else if pCode = gcTRADAE_EXEC then Result := gwSettleExec
  else if pCode = gcTRADE_DISTR then Result := gwSettleDistr
end;

//------------------------------------------------------------------------------
// SellBuyName을 Code로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_SellBuyNameToCode(pName: string): string;
begin
  Result := '';
  if pName = gwBuy then Result := gcTRADE_BUY
  else if pName = gwSell then Result := gcTRADE_SELL
  else if pName = gwBuyToOffset then Result := gcTRADE_BUY_OFF
  else if pName = gwSellToOffset then Result := gcTRADE_SELL_OFF
  else if pName = gwSettleExec then Result := gcTRADAE_EXEC
  else if pName = gwSettleDistr then Result := gcTRADE_DISTR
end;

//------------------------------------------------------------------------------
// SendMethod Code를 Name으로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_SendMtdCodeToName(pSendMtdCode: string): string;
begin
  Result := gf_CodeToName(gvSendMtdList, pSendMtdCode);
end;

//------------------------------------------------------------------------------
// Execution Module의 Version을 Return함(1.1.0.1)
//------------------------------------------------------------------------------

function gf_ExeVersion(sExeFullPathFileName: string): string;
{
var
  Bytes: UINT;
  Block: array[0..1023] of Byte;
  Translation: Pointer;
  FileVerInfo: PVSFixedFileInfo;
  FileVersion: array[0..63] of Char;
  Handle: DWord;
  s: string;
begin

//gf_Log('Get Version Start : ' + sExeFullPathFileName );
  if not FileExists(sExeFullPathFileName) then
  begin
    Result := '';
    Exit;
  end;
//gf_Log('Get File Check End ');

  try
    Bytes := GetFileVersionInfoSize(PChar(sExeFullPathFileName), Handle);
//gf_Log('Bytes End');

    if Bytes <> 0 then
    begin
      if GetFileVersionInfo(PChar(sExeFullPathFileName), Handle, Bytes, @Block) then
      begin
//gf_Log('GetFileVersionInfo End');
        if VerQueryValue(@Block, '\', Translation, Bytes) then
        begin
//gf_Log('VerQueryValue  End');
          FileVerInfo := PVSFixedFileInfo(Translation);
//gf_Log('PVSFixedFileInfo  End ' + FileVersion);
          StrFmt(FileVersion, '%x.%x.%x.%x',
            [HIWORD(FileVerInfo.dwFileVersionMS),
            LOWORD(FileVerInfo.dwFileVersionMS),
              HIWORD(FileVerInfo.dwFileVersionLS),
              LOWORD(FileVerInfo.dwFileVersionLS)]);
          Result := Trim(FileVersion);
          Exit;
        end;
      end;
    end;
  except
    on E: Exception do
    begin //Exception도 안걸리고 뒤짐.
      gf_Log('Get Version Except : ' + sExeFullPathFileName + ' ' + E.Message);
    end;
  end;

  Result := '';
}
var
  Size, Size2: DWord;
  Pt, Pt2: Pointer;
  SZfULLPATH: PChar;
begin

  Result := '';
  SZfULLPATH := pchar(sExeFullPathFileName);

  Size := GetFileVersionInfoSize(szFullPath, Size2);
  if Size > 0 then begin
    GetMem(Pt, Size);
    try
      GetFileVersionInfo(szFullPath, 0, Size, Pt);
      VerQueryValue(Pt, '\', Pt2, Size2);
      with TVSFixedFileInfo(Pt2^) do begin
        Result := Format('%x.%x.%x.%x', [HiWord(dwFileVersionMS),
          LoWord(dwFileVersionMS),
            HiWord(dwFileVersionLS),
            LoWord(dwFileVersionLS)]);
      end;
    finally
      FreeMem(Pt);
    end;
  end;
end;

//------------------------------------------------------------------------------
// 해당 일자의 선물 정산이 되었는지 확인
//------------------------------------------------------------------------------

function gf_FutDailySettled(pTradeDate: string): string;
begin
  Result := '';
  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' Select CLS_YN = ISNULL(max(CLS_YN), ''N'')   ' //첫번째 Row만 가져온다.
      + ' From   SFDEPGT_TBL     '
      + ' Where  DEPT_CODE  = ''' + gvDeptCode + ''' '
      + '   and  TRADE_DATE = ''' + pTradeDate + ''' '
      + '   and  MANUAL_YN  = ''N''                  ');
//              + ' GROUP BY DEPT_CODE, TRADE_DATE, CLS_YN    ');

    gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

    if RecordCount <= 0 then exit; // 데이타가 없을 경우
    Result := Trim(FieldByName('CLS_YN').asString);
  end;
end;

//------------------------------------------------------------------------------
// 두개의 StringList가 동일한지 판단
//------------------------------------------------------------------------------

function gf_IsSameStringList(pStrList1, pStrList2: TStringList): boolean;
var
  Str1, Str2: string;
  I: Integer;
begin
  Result := False;
  if pStrList1.Count <> pStrList2.Count then Exit; // StringList의 Strings갯수가 다름
  for I := 0 to pStrList1.Count - 1 do
  begin
    Str1 := pStrList1.Strings[I];
    Str2 := pStrList2.Strings[I];
    if Str1 <> Str2 then Exit;
  end; // end of for
  Result := True;
end;

//------------------------------------------------------------------------------
// 해당 SendMethod를 사용가능한지 판단
//------------------------------------------------------------------------------

function gf_CanUseSendMtd(pSendMtdCode: string): boolean;
var
  CodeItem: pTCodeType;
  I: Integer;
begin
  Result := False;
  for I := 0 to gvSendMtdList.Count - 1 do
  begin
    CodeItem := gvSendMtdList.Items[I];
    if CodeItem.Code = pSendMtdCode then
    begin
      Result := True;
      Break;
    end;
  end;
end;

//------------------------------------------------------------------------------
// SendMethod Name을 SendMethod Code로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_SendMtdNameToCode(pSendMtdName: string): string;
begin
  Result := gf_NameToCode(gvSendMtdList, pSendMtdName);
end;

//------------------------------------------------------------------------------
// CustProp Code를 Name으로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_CustPropCodeToName(pCustPropCode: string): string;
begin
  Result := '';
  if pCustPropCode = gcKSD_CUST then Result := gwKSDCust
  else if pCustPropCode = gcKSD_PROP then Result := gwKSDProp;
end;

//------------------------------------------------------------------------------
// CustProp Name을 Code로 변환하여 리턴
//------------------------------------------------------------------------------

function gf_CustPropNameToCode(pCustPropName: string): string;
begin
  Result := '';
  if pCustPropName = gwKSDCust then Result := gcKSD_CUST
  else if pCustPropName = gwKSDProp then Result := gcKSD_PROP;
end;

//------------------------------------------------------------------------------
//   Log File 기록(Thread Safe)
//------------------------------------------------------------------------------

procedure gf_Log(S: string);
var
  Hour, Min, Sec, MSec: Word;
begin
  if not gvLogFlag then Exit;

  if (Trim(gvLogPath) <> '') then // Log File Write
  begin
    DecodeTime(Now, Hour, Min, Sec, MSec);
    EnterCriticalSection(gvLogCriticalSection);
    WriteLn(gvLogFile, FormatFloat('00', Hour) + ':' + FormatFloat('00', Min)
      + ':' + FormatFloat('00', Sec) + ':' + FormatFloat('000', MSec) + ' ' + S);
    Flush(gvLogFile);
    LeaveCriticalSection(gvLogCriticalSection);
  end;
end;

//------------------------------------------------------------------------------
//   Log File Open
//------------------------------------------------------------------------------

procedure gf_StartLog(pLogPath, pLogName: string);
var
  FileName: string;
  Year, Month, Day: word;

  Hour, Min, Sec, MSec: Word;
begin
  if not gvLogFlag then Exit;
  if Trim(pLogPath) = '' then Exit;

  gvLogPath := pLogPath;
  if not DirectoryExists(gvLogPath) then
    if not CreateDir(gvLogpath) then
      raise Exception.Create('Cannot Create ' + gvLogPath);

  InitializeCriticalSection(gvLogCriticalSection);
  DecodeDate(Date, Year, Month, Day);

  DecodeTime(Now, Hour, Min, Sec, MSec);

//   FileName := pLogName + FormatFloat('0000', Year) + FormatFloat('00', Month) + FormatFloat('00', Day) + '.Txt';
  FileName := pLogName +
    FormatFloat('0000', Year) + FormatFloat('00', Month) + FormatFloat('00', Day) +
    FormatFloat('00', Hour) + FormatFloat('00', Min) + FormatFloat('00', Sec) +
    '.Txt';
  AssignFile(gvLogFile, gvLogPath + FileName);
  if FileExists(gvLogPath + FileName) then
    Append(gvLogFile)
  else
    Rewrite(gvLogFile);
end;

//------------------------------------------------------------------------------
//   Log File Close
//------------------------------------------------------------------------------

procedure gf_EndLog;
begin
  if not gvLogFlag then Exit;

  if (Trim(gvLogPath) <> '') then // Log File Write
  begin
    EnterCriticalSection(gvLogCriticalSection);
    WriteLn(gvLogFile, '');
    Flush(gvLogFile);
    LeaveCriticalSection(gvLogCriticalSection);
    CloseFile(gvLogFile);
    DeleteCriticalSection(gvLogCriticalSection);
  end;
end;

//------------------------------------------------------------------------------
//  Data 전송시 횟수 채번
//------------------------------------------------------------------------------

function gf_GetDataSendFreqNo(pSecType: string): Integer;
var
  RtnValue: string;
begin
  Result := -1;
  with DataModule_SettleNet.ADOSP_SP0103 do
  begin
    try
      Parameters.ParamByName('@in_date').Value := gvCurDate;
      Parameters.ParamByName('@in_dept_code').Value := gcDEPT_CODE_COMMON;
      Parameters.ParamByName('@in_sec_type').Value := pSecType;
      Parameters.ParamByName('@in_send_mtd').Value := gcSEND_DATA;
      Parameters.ParamByName('@in_biz_type').Value := '11'; //11: 회차
      Parameters.ParamByName('@in_get_flag').Value := '2';
      Execute;
    except
      on E: Exception do
      begin
        gvErrorNo := 9002; // StoredProcedure 실행 오류입니다.
        gvExtMsg := 'SP0103: ' + E.Message;
        Exit;
      end;
    end;
    RtnValue := Parameters.ParamByName('@out_rtc').Value;
    if (Trim(RtnValue) <> '') and (RtnValue <> '0000') then //오류 발생
    begin
      gvErrorNo := 9002; // StoredProcedure 실행 오류입니다.
      gvExtMsg := 'SP0103: ' + Parameters.ParamByName('@out_kor_msg').Value;
      Exit;
    end;
    Result := Parameters.ParamByName('@out_snd_no').Value;
  end;
end;

//------------------------------------------------------------------------------
//  Data 전송시 총송신 Seq. No 채번
//------------------------------------------------------------------------------

function gf_GetDataSendSeqNo(pSecType: string): Integer;
var
  RtnValue: string;
begin
  Result := -1;
  with DataModule_SettleNet.ADOSP_SP0103 do
  begin
    try
      Parameters.ParamByName('@in_date').Value := gvCurDate;
      Parameters.ParamByName('@in_dept_code').Value := gcDEPT_CODE_COMMON;
      Parameters.ParamByName('@in_sec_type').Value := pSecType;
      Parameters.ParamByName('@in_send_mtd').Value := gcSEND_DATA;
      Parameters.ParamByName('@in_biz_type').Value := '01'; //01: 총송신번호
      Parameters.ParamByName('@in_get_flag').Value := '2';
      Execute;
    except
      on E: Exception do
      begin
        gvErrorNo := 9002; // StoredProcedure 실행 오류입니다.
        gvExtMsg := 'SP0103: ' + E.Message;
        Exit;
      end;
    end;
    RtnValue := Parameters.ParamByName('@out_rtc').Value;
    if (Trim(RtnValue) <> '') and (RtnValue <> '0000') then //오류 발생
    begin
      gvErrorNo := 9002; // StoredProcedure 실행 오류입니다.
      gvExtMsg := 'SP0103: ' + Parameters.ParamByName('@out_kor_msg').Value;
      Exit;
    end;
    Result := Parameters.ParamByName('@out_snd_no').Value;
  end;
end;


//------------------------------------------------------------------------------
//  Fax 전송시 횟수 채번
//------------------------------------------------------------------------------

function gf_GetFaxSendFreqNo: Integer;
var
  RtnValue: string;
begin
  Result := -1;
  with DataModule_SettleNet.ADOSP_SP0103 do
  begin
    try
      Parameters.ParamByName('@in_date').Value := gvCurDate;
      Parameters.ParamByName('@in_dept_code').Value := gcDEPT_CODE_COMMON;
      Parameters.ParamByName('@in_sec_type').Value := gcSEC_COMMONFAX;
      Parameters.ParamByName('@in_send_mtd').Value := gcSEND_FAX;
      Parameters.ParamByName('@in_biz_type').Value := '11'; //11: 회차
      Parameters.ParamByName('@in_get_flag').Value := '2';
      Execute;
    except
      on E: Exception do
      begin // StoredProcedure 실행 오류입니다.
        gvErrorNo := 9002; // StoredProcedure 실행 오류입니다.
        gvExtMsg := 'SP0103: ' + E.Message;
        Exit;
      end;
    end;
    RtnValue := Parameters.ParamByName('@out_rtc').Value;
    if (Trim(RtnValue) <> '') and (RtnValue <> '0000') then //오류 발생
    begin
      gvErrorNo := 9002; // StoredProcedure 실행 오류입니다.
      gvExtMsg := 'SP0103: ' + Parameters.ParamByName('@out_kor_msg').Value;
      Exit;
    end;
    Result := Parameters.ParamByName('@out_snd_no').Value;
  end;
end;

//------------------------------------------------------------------------------
//  Fax 전송시 총수신 Seq. No 채번
//------------------------------------------------------------------------------

function gf_GetFaxSendSeqNo: Integer;
var
  RtnValue: string;
begin
  Result := -1;
  with DataModule_SettleNet.ADOSP_SP0103 do
  begin
    try
      Parameters.ParamByName('@in_date').Value := gvCurDate;
      Parameters.ParamByName('@in_dept_code').Value := gcDEPT_CODE_COMMON;
      Parameters.ParamByName('@in_sec_type').Value := gcSEC_COMMONFAX;
      Parameters.ParamByName('@in_send_mtd').Value := gcSEND_FAX;
      Parameters.ParamByName('@in_biz_type').Value := '01'; //01: 총송신번호
      Parameters.ParamByName('@in_get_flag').Value := '2';
      Execute;
    except
      on E: Exception do
      begin // StoredProcedure 실행 오류입니다.
        gvErrorNo := 9002; // StoredProcedure 실행 오류입니다.
        gvExtMsg := 'SP0103: ' + E.Message;
        Exit;
      end;
    end;
    RtnValue := Parameters.ParamByName('@out_rtc').Value;
    if (Trim(RtnValue) <> '') and (RtnValue <> '0000') then //오류 발생
    begin
      gvErrorNo := 9002; // StoredProcedure 실행 오류입니다.
      gvExtMsg := 'SP0103: ' + Parameters.ParamByName('@out_kor_msg').Value;
      Exit;
    end;
    Result := Parameters.ParamByName('@out_snd_no').Value;
  end;
end;

//------------------------------------------------------------------------------
//  계좌번호 Formatting : 00000000000,0000 -> 0000000000-0000
//------------------------------------------------------------------------------

function gf_FormatAccNo(pAccNo, pSubAccNo: string): string;
begin
  if Trim(pSubAccNo) = '' then
    Result := pAccNo
  else // SubAccNo 존재
    Result := pAccNo + '-' + pSubAccNo;
end;

//------------------------------------------------------------------------------
// 계좌번호 unformatting : 0000000000-0000 -> 00000000000, 0000
//------------------------------------------------------------------------------

procedure gf_UnformatAccNo(pFormatAccNo: string; var pAccNo, pSubAccNo: string);
var
  iPos: Integer;
begin
  iPos := Pos('-', pFormatAccNo);
  if iPos <= 0 then // SubAccNo가 존재하지 않음
  begin
    pAccNo := pFormatAccNo;
    pSubAccNo := '';
  end
  else // SubAccNo가 존재
  begin
    pAccNo := copy(pFormatAccNo, 1, iPos - 1);
    pSubAccNo := copy(pFormatAccNo, iPos + 1, Length(pFormatAccNo) - iPos);
  end;
end;

//------------------------------------------------------------------------------
// Date Formatting YYYYMMDD -> YYYY-MM-DD
//------------------------------------------------------------------------------

function gf_FormatDate(pDate: string): string;
begin
  Result := '';
  if Length(Trim(pDate)) = 8 then
    Result := copy(pDate, 1, 4) + '-' + copy(pDate, 5, 2) + '-' + copy(pDate, 7, 2);
end;

//------------------------------------------------------------------------------
// Date unformatting : YYYY-MM-DD -> YYYYMMDD
//------------------------------------------------------------------------------

function gf_UnformatDate(pDate: string): string;
begin
  Result := '';
  if Length(pDate) = 10 then
    Result := copy(pDate, 1, 4) + copy(pDate, 6, 2) + copy(pDate, 9, 2);
end;

//------------------------------------------------------------------------------
// Report에서의 Date Formatting : YYYYMMDD -> YYYY/MM/DD
//------------------------------------------------------------------------------

function gf_PrintFormatDate(pDate: string): string;
begin
  Result := '';
  if Length(pDate) = 8 then
    Result := copy(pDate, 1, 4) + '/' + copy(pDate, 5, 2) + '/' + copy(pDate, 7, 2);
end;

//------------------------------------------------------------------------------
// Time Formatting : HHMMSSMM - HH:MM:SS.MM
//------------------------------------------------------------------------------

function gf_FormatTime(pTime: string): string;
begin
  Result := '';
  if Length(Trim(pTime)) = 8 then
    Result := copy(pTime, 1, 2) + ':' + copy(pTime, 3, 2) + ':' + copy(pTime, 5, 2) + '.' + copy(pTime, 7, 2)
  else if Length(Trim(pTime)) = 6 then
    Result := copy(pTime, 1, 2) + ':' + copy(pTime, 3, 2) + ':' + copy(pTime, 5, 2)
end;

//------------------------------------------------------------------------------
// Time unformatting : HH:MM:SS.MM -> HHMMSSMM
//------------------------------------------------------------------------------

function gf_UnformatTime(pTime: string): string;
begin
  Result := '';
  if Length(pTime) = 11 then
    Result := copy(pTime, 1, 2) + copy(pTime, 4, 2) + copy(pTime, 7, 2) + copy(pTime, 10, 2)
  else if Length(pTime) = 8 then
    Result := copy(pTime, 1, 2) + copy(pTime, 4, 2) + copy(pTime, 7, 2);
end;

//------------------------------------------------------------------------------
// DiffTime Formating -> H시간 M분 S초
//------------------------------------------------------------------------------

function gf_FormatDiffTime(pDiffTime: Integer): string;
var
  Min, Sec: Integer;
begin
  Result := '';

  if pDiffTime = 0 then Exit;

  Min := pDiffTime div 60;
  Sec := pDiffTime mod 60;

  Result := FormatFloat('#0', Min) + '.';
  Result := Result + FormatFloat('00', Sec);
end;

//------------------------------------------------------------------------------
// Edit File Name Formatting
//------------------------------------------------------------------------------

function gf_FormatEditFileName(pJobDate, pReportId, pAccNo, pSubAccNo, pMediaNo: string): string;
begin
  Result := gvDirUserData +
    copy(pJobDate, 5, 4) + // 업무일자
    pReportId + // Report Id
//             copy(pReportId, 1, 2) + copy(pReportId, 6, 2) + // Report Id
  pAccNo; //계좌번호
  if Trim(pSubAccNo) <> '' then
    Result := Result + '-' + pSubAccNo; // 부계좌 존재시

  Result := Result + pMediaNo + '.tmp'; //@@
end;

//------------------------------------------------------------------------------
// Copy String + Fill Space
//------------------------------------------------------------------------------

function gf_MoveDataStr(Source: string; iSize: Integer): string;
var
  I: Integer;
begin
  Result := Source;
  for I := iSize - Length(Result) - 1 downto 1 do
    Result := Result + ' ';
end;

//------------------------------------------------------------------------------
//   일자 확인(YYYYMMDD 형태)
//------------------------------------------------------------------------------

function gf_CheckValidDate(pDate: string): boolean;
var
  Day, Month, Year: Word;
begin
  if Length(pDate) <> 8 then
  begin
    Result := False;
    Exit;
  end;
  if (Length(Trim(copy(pDate, 1, 4))) <> 4) or (Length(Trim(copy(pDate, 5, 2))) <> 2)
    or (Length(Trim(copy(pDate, 7, 2))) <> 2) then
  begin
    Result := False;
    Exit;
  end;
  Year := StrToInt(copy(pDate, 1, 4));
  Month := StrToInt(copy(pDate, 5, 2));
  Day := StrToInt(copy(pDate, 7, 2));
  if (Day < 1) or (Month < 1) or (Month > 12) or (Year < 1900) or (Year > 2078) then
    Result := False
  else
  begin
    case Month of
      1, 3, 5, 7, 8, 10, 12: Result := Day <= 31;
      4, 6, 9, 11: Result := Day <= 30;
      2: Result := Day <= 28 + Ord((Year mod 4) = 0) * Ord(Year <> 1900)
    else Result := False
    end; // end of case
  end;
end;

//------------------------------------------------------------------------------
//  오늘 일자 가져오기 함수(YYYYMMDD)
//------------------------------------------------------------------------------

function gf_GetCurDate: string;
begin
  try
    with DataModule_SettleNet.ADOSP_SP0001 do
    begin
      Execute;
      Result := Parameters.ParamByName('@out_pam').Value;
    end;
  except
    Result := '';
  end;
end;

//------------------------------------------------------------------------------
//  현재 시간 가져오기 함수(HHMMSSMM)
//------------------------------------------------------------------------------

function gf_GetCurTime: string;
begin
  try
    with DataModule_SettleNet.ADOSP_SP0002 do
    begin
      Execute;
      Result := Parameters.ParamByName('@out_pam').Value;
    end;
  except
    Result := '';
  end;
end;

//------------------------------------------------------------------------------
//  결제 일자 구하는 함수, 오류 발생시 해당 오류 Message 리턴
//  ApplyType => 00 : 보통, 일반
//               11 : 주식출납                 12 : 주식매매
//               21 : 채권출납                 22 : 채권매매
//               31 : KOSPI출납, 선물옵션출납  32 : KOSPI매매, 선물옵션매매
//               41 : KOFEX출납                42 : KOFEX매매
//------------------------------------------------------------------------------

function gf_GetSettleDate(pApplyType, pStdDate: string; var pSettleDate: string): string;
var
  RtnValue: string;
begin
  Result := '';
  pSettleDate := '';
  with DataModule_SettleNet.ADOSP_SP0019 do
  begin
    Parameters.ParamByName('@in_aply_type').Value := pApplyType;
    Parameters.ParamByName('@in_date').Value := pStdDate;
    try
      Execute;
    except
      on E: Exception do
      begin // StoredProcedure 실행 오류입니다.
        Result := '[9002]' + gf_ReturnMsg(9002) + 'SP0019: ' + E.Message;
        Exit;
      end;
    end;
    RtnValue := Parameters.ParamByName('@out_rtc').Value;
    if (Trim(RtnValue) <> '') and (RtnValue <> '0000') then //오류 발생
    begin
      Result := '[9002]' + gf_ReturnMsg(9002) + 'SP0019: ' // StoredProcedure 실행 오류입니다.
        + Parameters.ParamByName('@out_kor_msg').Value;
      Exit;
    end;
    pSettleDate := Parameters.ParamByName('@out_date').Value;
  end;
end;

//------------------------------------------------------------------------------
//  두일자의 차를 구하는 함수
//------------------------------------------------------------------------------

function gf_Getstgigan(sDate, tDate: string): integer;
var
  sDay, sMonth, sYear: Word;
  tDay, tMonth, tYear: Word;
  I, Day, temp, sJulday, tJulday: integer;
begin

  if Length(Trim(sDate)) <> 8 then sDate := '00000000';

  if Length(Trim(tDate)) <> 8 then sDate := '00000000';

  sYear := StrToInt(copy(sDate, 1, 4));
  sMonth := StrToInt(copy(sDate, 5, 2));
  sDay := StrToInt(copy(sDate, 7, 2));

  temp := 0;
  for I := 1 to sMonth - 1 do
  begin
    case I of
      1, 3, 5, 7, 8, 10, 12: Day := 31;
      4, 6, 9, 11: Day := 30;
      2: Day := 28 + Ord((sYear mod 4) = 0) * Ord(sYear <> 1900)
    else Day := 0
    end; // end of case
    temp := temp + Day;
  end;
  sJulday := (sYear * 365) + temp + sDay;

  tYear := StrToInt(copy(tDate, 1, 4));
  tMonth := StrToInt(copy(tDate, 5, 2));
  tDay := StrToInt(copy(tDate, 7, 2));

  temp := 0;
  for I := 1 to tMonth - 1 do
  begin
    case I of
      1, 3, 5, 7, 8, 10, 12: Day := 31;
      4, 6, 9, 11: Day := 30;
      2: Day := 28 + Ord((sYear mod 4) = 0) * Ord(sYear <> 1900)
    else Day := 0
    end; // end of case
    temp := temp + Day;
  end;

  tJulday := (tYear * 365) + temp + tDay;

  Result := tJulday - sJulday;

end;

//------------------------------------------------------------------------------
// Conversion Error 발생시 0이 Return되는 StrToFloat
//------------------------------------------------------------------------------

function gf_StrToFloat(pStr: string): double;
begin
  if Length(Trim(pStr)) = 0 then // Space 입력시
  begin
    Result := 0;
    Exit;
  end;
  try
    Result := StrToFloat(Trim(pStr));
  except
    Result := 0;
  end;
end;

//------------------------------------------------------------------------------
// Conversion Error 발생시 0이 Return되는 StrToInteger
//------------------------------------------------------------------------------

function gf_StrToInt(pStr: string): Integer;
begin
  if Length(Trim(pStr)) = 0 then // Space 입력시
    Result := 0
  else
    Result := StrToIntDef(Trim(pStr), 0)
end;

//------------------------------------------------------------------------------
//  Currency Comma를 없애고 해당 값을 return 하는 함수
//------------------------------------------------------------------------------

function gf_CurrencyToFloat(pStr: string): double;
var
  DestArray, SrcArray: array[0..255] of Char;
  iDest, iSrc: Integer;
  NumStr: string;
begin
  if length(pStr) > 256 then // 처리할 수 없는 숫자 string
  begin
    Result := -1;
    Exit;
  end;
  FillChar(SrcArray, Sizeof(SrcArray), ' ');
  FillChar(DestArray, Sizeof(DestArray), ' ');
  StrpCopy(SrcArray, pStr);
  iSrc := 0;
  iDest := 0;
  while SrcArray[iSrc] <> #0 do
  begin
    if SrcArray[iSrc] = ',' then
    begin
      Inc(iSrc);
      continue;
    end
    else
    begin
      DestArray[iDest] := SrcArray[iSrc];
      Inc(iSrc);
      Inc(iDest);
    end;
  end;
  DestArray[iDest] := #0;
  NumStr := StrPas(DestArray);
  if Length(Trim(NumStr)) = 0 then
    Result := 0
  else
    Result := StrToFloat(NumStr);
end;

//----------------------------------------------------------------------------=
//  [한영] 계좌 존재 확인 후 계좌명 Return
//  계좌존재시 True Return, 존재하지 않을 경우 False Return
//----------------------------------------------------------------------------=

function gf_GetAccName(InAccNo: string; var OutAccName: string): boolean;
begin
  OutAccName := '';
  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ACC_NAME_KOR ' +
      'FROM   SEACBIF_TBL ' +
      'WHERE  ACC_NO = :pAccNo');
    Parameters.ParamByName('pAccNo').Value := InAccNo;
    gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

    if RecordCount <> 1 then
    begin
      Result := False;
      Exit;
    end;
    OutAccName := FieldByName('ACC_NAME_KOR').asString;
    result := True;
  end;
end;

//------------------------------------------------------------------------------
//  Dialog Message 출력
//------------------------------------------------------------------------------

function gf_ShowDlgMessage(pTrCode: LongInt; pDlgType: TMsgDlgType; pMsgNo: LongInt; pExtMsg: string;
  pButtons: TMsgDlgButtons; pHelpCtx: LongInt): Integer;
var
  TmpMsg: string;
begin
  if pMsgNo <= 0 then // MsgNo <= 0 이면 Extended Msg만 사용하겠다는 의미
    TmpMsg := pExtMsg
  else
    TmpMsg := '[' + IntToStr(pMsgNo) + '] ' + gf_ReturnMsg(pMsgNo) + gcMsgLineInterval + pExtMsg;

  with CreateMessageDialog(TmpMsg, pDlgType, pButtons) do
  begin
    try
      Position := poscreenCenter; //poDesktopCenter; //
      FormStyle := fsStayOnTop;
         //!!! Font도 바꿀 수 있다
      HelpContext := pHelpCtx;
      if pTrCode = 0 then
        Caption := gcApplicationName
      else
        Caption := gcApplicationName + '[' + IntToStr(pTrCode) + ']';
//         SetForeGroundWindow(gvMainFrameHandle);
      Result := ShowModal;
    finally
      Free;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Error Dialog Message (한/영)
//------------------------------------------------------------------------------

function gf_ShowErrDlgMessage(pTrCode: LongInt; pMsgNo: LongInt; pExtMsg: string; pHelpCtx: LongInt): Integer;
var
  TmpMsg: string;
begin
  if pMsgNo <= 0 then // MsgNo <= 0 이면 Extended Msg만 사용하겠다는 의미
    TmpMsg := pExtMsg
  else
    TmpMsg := '[' + IntToStr(pMsgNo) + '] ' + gf_ReturnMsg
      (pMsgNo) + gcMsgLineInterval + pExtMsg;

  with CreateMessageDialog(TmpMsg, mtError, [mbOK]) do
  begin
    try
         //!!! Font도 바꿀 수 있다
      HelpContext := pHelpCtx;
      if pTrCode = 0 then
        Caption := gcApplicationName
      else
        Caption := gcApplicationName + '[' + IntToStr(pTrCode) + ']';
//         SetForeGroundWindow(gvMainFrameHandle); 이거 풀면 modal 위의 modal시 첫번째 모달이 숨어버림
      Result := ShowModal;
    finally
      Free;
    end;
  end;
end;

//------------------------------------------------------------------------------
// [한영] MessageBar에 Message 출력
//------------------------------------------------------------------------------

procedure gf_ShowMessage(pMsgBar: TDRMessageBar; pMsgType: TMsgDlgType; pMsgNo: LongInt; pExtMsg: string);
begin
  if pMsgNo <= 0 then // MsgNo <= 0 이면 Extended Msg만 사용하겠다는 의미
    pMsgBar.ShowMessage(pMsgType, pExtMsg)
  else
  begin
    if Trim(pExtMsg) = '' then
      pMsgBar.ShowMessage(pMsgType, '[' + IntToStr(pMsgNo) + ']' + gf_ReturnMsg(pMsgNo))
    else
      pMsgBar.ShowMessage(pMsgType, '[' + IntToStr(pMsgNo) + ']' + gf_ReturnMsg(pMsgNo) + ' - ' + pExtMsg);
  end
end;

//------------------------------------------------------------------------------
// MessageBar Clear
//------------------------------------------------------------------------------

procedure gf_ClearMessage(pMsgBar: TDRMessageBar);
begin
  pMsgBar.ClearMessage;
end;

//------------------------------------------------------------------------------
//  [한영] Message 번호를 받아 해당 Message return
//------------------------------------------------------------------------------

function gf_ReturnMsg(pMsgNo: LongInt): string; // Message 번호를 받아 해당 Message return
begin
  with DataModule_SettleNet.ADOQuery_Msg do
  begin
    try
      Close;
      Parameters.ParamByName('pMsgCode').Value := IntToStr(pMsgNo);
      gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Msg);
      if RecordCount > 0 then
        Result := FieldByName('MSG_NAME_KOR').asString
      else
        Result := '해당 Message 번호는 존재하지 않습니다.';
    except
      on E: Exception do
        Result := 'Message Error-' + E.Message;
    end;
  end;
end;

//------------------------------------------------------------------------------
// currency comma string에서 currency comma 제거한 string return
//------------------------------------------------------------------------------

function gf_CurrencyToStr(pStr: string): string;
var
  DestArray, SrcArray: array[0..255] of Char;
  iDest, iSrc: Integer;
  NumStr: string;
begin
  if length(pStr) > 256 then // 처리할 수 없는 숫자 string
  begin
    Result := '';
    Exit;
  end;
  FillChar(SrcArray, Sizeof(SrcArray), ' ');
  FillChar(DestArray, Sizeof(DestArray), ' ');
  StrpCopy(SrcArray, pStr);
  iSrc := 0;
  iDest := 0;
  while SrcArray[iSrc] <> #0 do
  begin
    if SrcArray[iSrc] = ',' then
    begin
      Inc(iSrc);
      continue;
    end
    else
    begin
      DestArray[iDest] := SrcArray[iSrc];
      Inc(iSrc);
      Inc(iDest);
    end;
  end;
  DestArray[iDest] := #0;
  NumStr := StrPas(DestArray);
  if NumStr = '' then NumStr := '0';
  Result := NumStr;
end;

//------------------------------------------------------------------------------
// Query Open시 생성된 Shared Lock을 풀어줌
//------------------------------------------------------------------------------

procedure gf_QueryOpen(pQuery: TQuery);
begin
  with pQuery do
  begin
    if not Prepared then Prepare;
    Open;
    DisableControls;
    FetchAll;
    First;
    EnableControls;
  end;
end;

//------------------------------------------------------------------------------
// Query Open시 생성된 Shared Lock을 풀어줌
//------------------------------------------------------------------------------

procedure gf_ADOQueryOpen(pQuery: TADOQuery);
begin
  with pQuery do
  begin
    if not Prepared then
      Prepared := True;
    Open;
    DisableControls;
    Last;
    First;
//      EnableControls;
  end;
end;

//------------------------------------------------------------------------------
// Update, Insert, Delete를 수행하는 SQL 수행
//------------------------------------------------------------------------------

procedure gf_ExecSQL(pQuery: TQuery);
begin
  with pQuery do
  begin
    if not Prepared then Prepare;
    ExecSQL;
  end;
end;

//------------------------------------------------------------------------------
// Update, Insert, Delete를 수행하는 SQL 수행
//------------------------------------------------------------------------------

procedure gf_ADOExecSQL(pQuery: TADOQuery);
begin
  with pQuery do
  begin
    if not Prepared then Prepared := True;
    ExecSQL;
  end;
end;

//------------------------------------------------------------------------------
// Parameter를 가져오는 Stored Proc 의 실행
//------------------------------------------------------------------------------

procedure gf_ExecProc(pStoredProc: TStoredProc);
begin
  with pStoredProc do
  begin
    if not Prepared then Prepared := True;
    ExecProc;
  end;
end;

//------------------------------------------------------------------------------
// Parameter를 가져오는 Stored Proc 의 실행
//------------------------------------------------------------------------------

procedure gf_ADOExecProc(pStoredProc: TADOStoredProc);
begin
  with pStoredProc do
  begin
    if not Prepared then Prepared := True;
    ExecProc;
  end;
end;

//------------------------------------------------------------------------------
//  ResultSet을 가져오는 Stored Proc 의 실행
//------------------------------------------------------------------------------

procedure gf_GetResultProc(pStoredProc: TStoredProc);
begin
  with pStoredProc do
  begin
    if not Prepared then Prepare;
    Active := True;
    DisableControls;
//      GetResults;  +++ Test 후 적용 생각
    FetchAll;
    First;
    EnableControls;
  end;
end;

//------------------------------------------------------------------------------
//  ResultSet을 가져오는 Stored Proc 의 실행
//------------------------------------------------------------------------------

procedure gf_ADOGetResultProc(pStoredProc: TADOStoredProc);
begin
  with pStoredProc do
  begin
    if not Prepared then Prepared := True;
    Active := True;
    DisableControls;
//      GetResults;  +++ Test 후 적용 생각
    Last;
    First;
    EnableControls;
  end;
end;

//------------------------------------------------------------------------------
//  Database Start Tramsaction
//------------------------------------------------------------------------------

procedure gf_BeginTransaction;
begin
  if not DataModule_SettleNet.ADOConnection_Main.InTransaction then
    DataModule_SettleNet.ADOConnection_Main.BeginTrans;
end;

//------------------------------------------------------------------------------
//  Database Commit
//------------------------------------------------------------------------------

procedure gf_CommitTransaction;
begin
  if DataModule_SettleNet.ADOConnection_Main.InTransaction then
    DataModule_SettleNet.ADOConnection_Main.CommitTrans;
end;

//------------------------------------------------------------------------------
//  Database RollBack
//------------------------------------------------------------------------------

procedure gf_RollbackTransaction;
begin
  if DataModule_SettleNet.ADOConnection_Main.InTransaction then
    DataModule_SettleNet.ADOConnection_Main.RollbackTrans;
end;

//----------------------------------------------------------------------------------=
//   List Sort시 Item 크기 비교를 위한 함수(Sting)
//----------------------------------------------------------------------------------=

function gf_ReturnStrComp(pTemp1, pTemp2: string; pAscending: boolean): Integer;
begin
  if pAscending then //오름차순에 의한 비교
  begin
    if pTemp1 > pTemp2 then
      Result := 1
    else if pTemp1 = pTemp2 then
      Result := 0
    else
      Result := -1;
  end
  else // 내림차순에 의한 비교
  begin
    if pTemp1 > pTemp2 then
      Result := -1
    else if pTemp1 = pTemp2 then
      Result := 0
    else
      Result := 1;
  end
end;

//------------------------------------------------------------------------------
// Print Text File
//------------------------------------------------------------------------------

function gf_PrintTextFile(pFileName, pOrientation: string; pMaxPageLineCnt: Integer): boolean;
var
  ReadFile: TextFile;
  ReadBuff: string;
  x, y: Integer;
  LineCnt, LineHeight: Integer;
  TopMargin, LeftMargin: Integer;
  I: Integer;
begin
  Result := False;

   // 출력할 파일 존재 여부 확인
  if not FileExists(pFileName) then
  begin
    gvErrorNo := 1027; // 해당 파일이 존재하지 않습니다.
    gvExtMsg := '';
    Exit;
  end;

   // Assign Read File
  AssignFile(ReadFile, pFileName);
{$I-}
  Reset(ReadFile);
{$I+}
  if IOResult <> 0 then
  begin
    gvErrorNo := 1027; // 해당 파일이 존재하지 않습니다.
    gvExtMsg := '';
    Exit;
  end;

  Screen.Cursor := crHourGlass;
  try
      // Set Margin
    TopMargin := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
    LeftMargin := GetDeviceCaps(Printer.Handle, LOGPIXELSX) * 3 div 4;

    Printer.Title := gcApplicationName;

      // Set Orientation
    if pOrientation = gcPortrait then
      Printer.Orientation := poPortrait
    else
      Printer.Orientation := poLandscape;
    gvPrinter.Orientation := Printer.Orientation;

    Printer.BeginDoc;
    Printer.Canvas.Font.PixelsPerInch :=
      GetDeviceCaps(Printer.Canvas.Handle, LOGPIXELSY);
      // Printer에서 지원되는 Font 중 Courier와 근사 Font Search
    for I := 0 to Printer.Fonts.Count - 1 do
    begin
      if Pos(gcTEXT_FONT_NAME, UpperCase(Printer.Fonts[I])) > 0 then
      begin
        Printer.Canvas.Font.Name := Printer.Fonts[I];
        break;
      end;
    end;
    Printer.Canvas.Font.Size := gcTEXT_FONT_SIZE;
    LineHeight := Printer.Canvas.TextHeight('Ay');

    LineCnt := 0;
    x := LeftMargin;
    y := TopMargin;
    while not Eof(ReadFile) do
    begin
      Inc(LineCnt);
      Readln(ReadFile, ReadBuff);
      Printer.Canvas.TextOut(x, y, ReadBuff);
      y := y + LineHeight;
      if (LineCnt >= pMaxPageLineCnt) and (not Eof(ReadFile)) then
      begin
        Printer.NewPage;
        LineCnt := 0;
        y := TopMargin;
      end;
    end; // end of while
    Printer.Canvas.TextOut(x, y, ''); //*** 마무리 생각 좀 해볼 것
    Printer.Canvas.TextOut(x, y + LineHeight, '>> End of Report');
  except
    on E: Exception do
    begin
      gvErrorNo := 1102; // 인쇄 중 오류 발생
      gvExtMsg := E.Message;
      CloseFile(ReadFile);
      Screen.Cursor := crDefault;
      Exit;
    end;
  end;
  Printer.EndDoc;
  CloseFile(ReadFile);
  Screen.Cursor := crDefault;
  Result := True;
end;

//------------------------------------------------------------------------------
// Print Memo
//------------------------------------------------------------------------------

function gf_PrintMemo(pPrnMemo: TMemo; pOrientation: string;
  pMaxPageLineCnt: Integer): boolean;
var
  x, y: Integer;
  LineCnt, LineHeight: Integer;
  TopMargin, LeftMargin: Integer;
  I: Integer;
begin
  Result := False;
  Screen.Cursor := crHourGlass;
  try
      // Set Margin
    TopMargin := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
    LeftMargin := GetDeviceCaps(Printer.Handle, LOGPIXELSX) * 3 div 4;

    Printer.Title := gcApplicationName;

      // Set Orientation
    if pOrientation = gcPortrait then
      Printer.Orientation := poPortrait
    else
      Printer.Orientation := poLandscape;
    gvPrinter.Orientation := Printer.Orientation;

    Printer.BeginDoc;

    Printer.Canvas.Font.PixelsPerInch :=
      GetDeviceCaps(Printer.Canvas.Handle, LOGPIXELSY);
      // Printer에서 지원되는 Font 중 Courier와 근사 Font Search
    for I := 0 to Printer.Fonts.Count - 1 do
    begin
      if Pos(gcTEXT_FONT_NAME, UpperCase(Printer.Fonts[I])) > 0 then
      begin
        Printer.Canvas.Font.Name := Printer.Fonts[I];
        break;
      end;
    end;
    Printer.Canvas.Font.Size := gcTEXT_FONT_SIZE;
    LineHeight := Printer.Canvas.TextHeight('Ay');

    LineCnt := 0;
    x := LeftMargin;
    y := TopMargin;
    for I := 0 to pPrnMemo.Lines.Count - 1 do
    begin
      Inc(LineCnt);
      Printer.Canvas.TextOut(x, y, pPrnMemo.Lines[I]);
      y := y + LineHeight;
      if (LineCnt >= pMaxPageLineCnt) and (I < pPrnMemo.Lines.Count - 1) then
      begin
        Printer.NewPage;
        LineCnt := 0;
        y := TopMargin;
      end;
    end; // end of while
    Printer.Canvas.TextOut(x, y, ''); //*** 마무리 생각 좀 해볼 것
    Printer.Canvas.TextOut(x, y + LineHeight, '>> End of Report');
  except
    on E: Exception do
    begin
      gvErrorNo := 1102; // 인쇄 중 오류 발생
      gvExtMsg := E.Message;
      Screen.Cursor := crDefault;
      Exit;
    end;
  end;
  Printer.EndDoc;
  Screen.Cursor := crDefault;
  Result := True;
end;

//------------------------------------------------------------------------------
// Main Frame의 Main Menu, ToolBar Enable
//------------------------------------------------------------------------------

procedure gf_EnableMainMenu;
begin
  SendMessage(gvMainFrameHandle, WM_USER_ENABLE_MENU, 0, 0);
end;

//------------------------------------------------------------------------------
// Main Frame의 Main Menu, ToolBar Disable
//------------------------------------------------------------------------------

procedure gf_DisableMainMenu;
begin
  SendMessage(gvMainFrameHandle, WM_USER_DISABLE_MENU, 0, 0);
end;

//------------------------------------------------------------------------------
// 수신처 등록 화면에서의 Send Method에 따른 Color Return
//------------------------------------------------------------------------------

function gf_ReturnSendMtdColor(pSendMtd: string): TColor;
begin
  if pSendMtd = gcSEND_DATA then
    Result := clNavy
  else if pSendMtd = gcSEND_FAX then
    Result := clGreen
  else
    Result := clBlack;
end;

//------------------------------------------------------------------------------
// Child Form 생성
//------------------------------------------------------------------------------

procedure gf_CreateForm(pTrCode: Integer);
begin
  if pTrCode > 0 then
    SendMessage(gvMainFrameHandle, WM_USER_CREATE_FORM, pTrCode, 0);
end;

//------------------------------------------------------------------------------
// Code Table 변경 후 호출 (MainFrame에 CodeList 갱신 message 전송)
//------------------------------------------------------------------------------

procedure gf_RefreshCodeList(pCodeTableNo: Integer);
begin
  SendMessage(gvMainFrameHandle, WM_USER_REFRESH_CODELIST, pCodeTableNo, 0);
end;

//------------------------------------------------------------------------------
// Group Table 변경 후 호출 (MainFrame에 Group List message 전송)
//------------------------------------------------------------------------------

procedure gf_RefreshGroupList;
begin
  SendMessage(gvMainFrameHandle, WM_USER_REFRESH_GROUPLIST, 0, 0);
end;

//------------------------------------------------------------------------------
// Global 변수 관련 데이터 변경 후 호출 (MainFrame에 Global var 갱신 message 전송)
//------------------------------------------------------------------------------

procedure gf_RefreshGlobalVar(pGlobVarNo: Integer);
begin
  SendMessage(gvMainFrameHandle, WM_USER_REFRESH_GLOBVAR, pGlobVarNo, 0);
end;

procedure gf_RefreshGlobalVar(pGlobVarNo: Integer; pSetValue: Integer);
begin
  SendMessage(gvMainFrameHandle, WM_USER_REFRESH_GLOBVAR, pGlobVarNo, pSetValue);
end;

//------------------------------------------------------------------------------
//   List Sort시 Item 크기 비교를 위한 함수(Double)
//------------------------------------------------------------------------------

function gf_ReturnFloatComp(pTemp1, pTemp2: double; pAscending: boolean): Integer;
begin
  if pAscending then //오름차순에 의한 비교
  begin
    if pTemp1 > pTemp2 then
      Result := 1
    else if pTemp1 = pTemp2 then
      Result := 0
    else
      Result := -1;
  end
  else // 내림차순에 의한 비교
  begin
    if pTemp1 > pTemp2 then
      Result := -1
    else if pTemp1 = pTemp2 then
      Result := 0
    else
      Result := 1;
  end
end;

//------------------------------------------------------------------------------
// 해당 화면에 대한 권한 여부 확인
//------------------------------------------------------------------------------

function gf_CheckUsableMenu(pTrCode: Integer): boolean;
begin
   //+++ 진행 중
  Result := True;
end;

//------------------------------------------------------------------------------
//   프린트 하기 전 프린터 환경 설정
//------------------------------------------------------------------------------

function gf_InitPrint(pPrnComponent: TObject): boolean;
begin
  if gvPrinter.PrinterIdx = gcNonePrinter then //Printer가 연결되지 않은 경우
  begin
    Result := False;
    Exit;
  end;

   // Printer가 연결된 경우
  Result := True;
  if pPrnComponent <> nil then
  begin
    if pPrnComponent.ClassName = 'TQuickRep' then // QuickReport인 경우
    begin
      with (pPrnComponent as TQuickRep) do
      begin
        PrinterSettings.Title := gcApplicationName;
        PrinterSettings.PrinterIndex := gvPrinter.PrinterIdx;
        PrinterSettings.Copies := gvPrinter.Copies;
      end;
    end
    else if pPrnComponent.ClassName = 'TQRCompositeReport' then
    begin
      with (pPrnComponent as TQRCompositeReport) do
      begin
        PrinterSettings.Title := gcApplicationName;
        PrinterSettings.PrinterIndex := gvPrinter.PrinterIdx;
        PrinterSettings.Copies := gvPrinter.Copies;
      end;
    end;
    Result := False;
  end
  else //일반적인 폼print
  begin
    Printer.Title := gcApplicationName;
    Printer.PrinterIndex := gvPrinter.PrinterIdx;
    Printer.Copies := gvPrinter.Copies;
    Printer.Orientation := gvPrinter.Orientation;
  end; // end of else
  gvPrinter.Copies := 1; //일단 한번 Print를 한다음에는 1로 초기화
end;

//------------------------------------------------------------------------------
//  Application의 Root Path Return (SettleNet -> C:\Program Files\SettleNet
//------------------------------------------------------------------------------

function gf_GetAppRootPath: string;
var
  ExecPath: string;
begin
  ExecPath := ExtractFilePath(Application.ExeName);
  Result := ExecPath + '..\' // Application이 RootDir/Bin 에서 실행된다는 전제 필요
end;

//------------------------------------------------------------------------------
//  Row Selection의 위치를 SelRowIdx의 위치로 옮김
//------------------------------------------------------------------------------

procedure gf_SelectStrGridRow(pStringGrid: TStringGrid; SelRowIdx: Integer);
var
  SelectRect: TRect;
begin
  if (SelRowIdx > pStringGrid.RowCount - 1) or (SelRowIdx < pStringGrid.FixedRows) then // StringGrid영역밖의 RowIndex인 경우
    Exit;
  pStringGrid.Row := SelRowIdx;
  SelectRect.Left := pStringGrid.FixedCols;
  SelectRect.Top := SelRowIdx;
  SelectRect.Right := pStringGrid.ColCount - 1;
  SelectRect.Bottom := SelRowIdx;
  pStringGrid.Selection := TGridRect(SelectRect);
  pStringGrid.Repaint;
end;

//------------------------------------------------------------------------------
//  Cell Selection의 위치를 SelColIdx, SelRowIdx의위치로 옮김
//------------------------------------------------------------------------------

procedure gf_SelectStrGridCell(pStringGrid: TStringGrid; SelColIdx, SelRowIdx: Integer);
begin
  with pStringGrid do
  begin
    if (SelColIdx > pStringGrid.ColCount - 1) or (SelColIdx < pStringGrid.FixedCols) then // StringGrid영역밖의 ColIndex인 경우
      Exit;
    if (SelRowIdx > pStringGrid.RowCount - 1) or (SelRowIdx < pStringGrid.FixedRows) then // StringGrid영역밖의 RowIndex인 경우
      Exit;

    Col := SelColIdx;
    Row := SelRowIdx;
  end;
end;

//------------------------------------------------------------------------------
//  StringGrid의 Cell을 지워주는 함수
//  StartCol, StartRow -> 지워줄 시작 column, 시작 row 지정
//  EndCol, EndRow -> 지워줄 마지막 column, 마지막 row지정
//------------------------------------------------------------------------------

procedure gf_ClearStrGrid(pStringGrid: TStringGrid; StartCol, StartRow, EndCol, EndRow: Integer);
var
  iCol, iRow: Integer;
begin
  for iCol := StartCol to EndCol do
    for iRow := StartRow to EndRow do
      pStringGrid.Cells[iCol, iRow] := '';
end;

//------------------------------------------------------------------------------
// StringGrid의 FixedCell을 제외한 모든 Cell을 지워줌
//------------------------------------------------------------------------------

procedure gf_ClearStrGridAll(pStringGrid: TStringGrid);
var
  iCol, iRow: Integer;
begin
  for iCol := pStringGrid.FixedCols to pStringGrid.ColCount - 1 do
    for iRow := pStringGrid.FixedRows to pStringGrid.RowCount - 1 do
      pStringGrid.Cells[iCol, iRow] := '';

end;

//------------------------------------------------------------------------------
// StringGrid의 ColIdx, RowIdx에 해당하는 Cell Click
//------------------------------------------------------------------------------

procedure gf_ClickStrGrid(pStringGrid: TStringGrid; ColIdx, RowIdx: Integer);
var
  XPos, YPos: Integer;
  R: TRect;
  Msg: TMessage;
begin
  if (ColIdx > pStringGrid.ColCount - 1) or (ColIdx < pStringGrid.FixedCols) then // StringGrid영역밖의 ColIndex인 경우
    Exit;
  if (RowIdx > pStringGrid.RowCount - 1) or (RowIdx < pStringGrid.FixedRows) then // StringGrid영역밖의 RowIndex인 경우
    Exit;

  R := pStringGrid.CellRect(ColIdx, RowIdx);
  XPos := R.Left + Trunc((R.Right - R.Left) / 2);
  YPos := R.Top + Trunc((R.Bottom - R.Top) / 2);
  Msg.LParamLo := XPos;
  Msg.LParamHi := YPos;
  pStringGrid.Perform(WM_LBUTTONDOWN, 0, Msg.LParam);
  pStringGrid.Perform(WM_LBUTTONUP, 0, Msg.LParam);
end;

//------------------------------------------------------------------------------
// 해당 Index를 StringGrid의 가장 상위 Row로 이동시킴
//------------------------------------------------------------------------------

procedure gf_SetTopRow(pStringGrid: TStringGrid; CurIdx: Integer);
begin
  if (CurIdx > pStringGrid.RowCount - 1) or (CurIdx < pStringGrid.FixedRows) then // StringGrid영역밖의 RowIndex인 경우
    Exit;

  if pStringGrid.RowCount - CurIdx < pStringGrid.VisibleRowCount then
    pStringGrid.TopRow := pStringGrid.RowCount - pStringGrid.VisibleRowCount
  else
    pStringGrid.TopRow := CurIdx;
end;

//------------------------------------------------------------------------------
// Print Crystal Rpt Type Report ( By Kim Ji-Young)
//------------------------------------------------------------------------------

function gf_PreviewReport(ExpFileName: string): Boolean;
begin
  Result := False;

  if not Assigned(gvMainFrame) then
  begin
    gvErrorNo := 9106; // system오류
    gvExtMsg := '';
    Exit;
  end;

  Screen.Cursor := crHourGlass;

  if gvPrinter.PrinterIdx = gcNonePrinter then
  begin
    gvErrorNo := 1111; // 현재 설정된 프린터가 없습니다.
    gvExtMsg := '';
    Screen.Cursor := crDefault;
    Exit;
  end;

  // 파일 형식에 따른 처리.
  if (gvFaxReportFileType <> gcFILE_TYPE_PDF) then
  begin
    // Crystal Report 처리.
    with Datamodule_Settlenet.Crpe1 do
    begin
      if not Assigned(RepForm_Preview) then
      begin
        Application.CreateForm(TRepForm_Preview, RepForm_Preview);
        RepForm_Preview.Parent := gvMainFrame;
      end;
      ReportName := ExpFileName;
      //[Y.S.M] 2013.07.02 Printer Clear 추가  파일저장 및 미리보기 시
      printer.Clear;
      Output := toWindow;
      WindowZoom.Magnification := gvPreviewPercent;
      RepForm_Preview.Show;

        //------------------------------------------------------------------------
        //원래는 Preveiw 화면에서 프린터에서 해야 하는데
        //거기에서는 껌버덕 거리는 화면 때문에 여기서 해준다.
        //------------------------------------------------------------------------
      try
        Printer.Retrieve;
        Printer.PreserveRptSettings := [prOrientation];
        Printer.Send;
      except
        on E: Exception do
        begin
          gvErrorNo := 8003; //Privew Execute 오류
          gvExtMsg := 'Printer.Sender 오류 ' + E.Message;
          Screen.Cursor := crDefault;
          RepForm_preview.Close;
          Exit;
        end;
      end; //try

      try
        Execute;
      except
        on E: Exception do
        begin
          gvErrorNo := 8003; //Privew Execute 오류
          gvExtMsg := E.Message;
          Screen.Cursor := crDefault;
          RepForm_preview.Close;
          Exit;
        end;
      end; // try
      RepForm_preView.Total.Caption := ' ' + inttostr(Pages.Count);
      RepForm_PreView.DREdit_CurPage.Text := '1';
    end; //with
  end else
  begin
    with RepForm_PreviewPDF.DynamicPDFViewer do
    begin
      if not Assigned(RepForm_PreviewPDF) then
      begin
        Application.CreateForm(TRepForm_PreviewPDF, RepForm_PreviewPDF);
        RepForm_PreviewPDF.Parent := gvMainFrame;
      end;
      RepForm_PreviewPDF.TmpPDFFileName := ExpFileName;
      RepForm_PreviewPDF.Show;
    end;
  end;

  Screen.Cursor := crDefault;
  Result := True;
end;

//------------------------------------------------------------------------------
// Print Crystal Rpt Type Report ( By Kim Ji-Young)
//------------------------------------------------------------------------------

function gf_PrintReport(ExpFileName: string): Boolean;
begin
  Result := False;
  Screen.Cursor := crHourGlass;

  // 파일 형식에 따른 처리.
  if (gvFaxReportFileType <> gcFILE_TYPE_PDF) then
  begin
    with Datamodule_Settlenet.crpe1 do
    begin
      ReportName := ExpFileName;

      if gvPrinter.PrinterIdx = gcNonePrinter then
      begin
        gvErrorNo := 1111; // 현재 설정된 프린터가 없습니다.
        gvExtMsg := '';
        Screen.Cursor := crDefault;
        CloseJob;
        Exit;
      end;

      try
        Printer.Retrieve;
        Printer.PreserveRptSettings := [prOrientation];
        Printer.Send;
      except
        on E: Exception do
        begin
          gvErrorNo := 8004; //Printer Execute 오류
          gvExtMsg := 'Printer.Sender 오류 ' + E.Message;
          Screen.Cursor := crDefault;
          CloseJob;
          Exit;
        end;
      end; //try

      ProgressDialog := False;
      //[Y.S.M] 2013.07.02 Printer Clear 추가 인쇄시
      Printer.Clear;
      if gvDefaultPrinterUseYN <> 'Y' then
      begin
        Printer.PreserveRptSettings := [prOrientation];
        Printers.Printer.PrinterIndex := Printers.Printer.Printers.IndexOf(gvPrinter.PrinterName);
        Printer.GetCurrent(False);
        Printer.Name := gvPrinter.PrinterName;
      end;
      Output := toPrinter;
      try
        Execute;
      except
        on E: Exception do
        begin
          gvErrorNo := 8004; //Printer Execute 오류
          gvExtMsg := E.Message;
          CloseJob;
          Screen.Cursor := crDefault;
          Exit;
        end;
      end; // try
      CloseJob;
    end;
  end else
  // PDF Engine 처리.
  begin
    // PDF 인쇄
    gf_DirectPrintForPDF(ExpFileName);
  end;

  Screen.Cursor := crDefault;
  Result := True;
end;

//------------------------------------------------------------------------------
// EMail Attaxh File 저장
//------------------------------------------------------------------------------

function gf_SaveMailAttachToFile(pSendDate: string; pCurTotSeqNo: integer;
  pAttSeqNo: Integer; pFileName: string): boolean;
begin

  Result := False;
  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' Select ATTACH_DATA '
      + ' From SCMELATT_TBL '
      + ' Where SND_DATE = ''' + pSendDate + ''' '
      + '   and CUR_TOT_SEQ_NO = ' + IntToStr(pCurTotSeqNo)
      + '   and ATT_SEQ_NO = ' + IntToStr(pAttSeqNo));
    try
      gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
    except
      on E: Exception do
      begin
        gf_ShowErrDlgMessage(0, 9001, E.Message, 0);
        gvErrorNo := 9001; // DataBase 오류입니다.
        gvExtMsg := E.Message;
        Exit;
      end;
    end;

    if RecordCount = 0 then
    begin
      gvErrorNo := 1068; // 해당 정보를 읽어올 수 없습니다.
      gvExtMsg := '';
      Exit;
    end;

      // Save Image File
    try
      DeleteFile(pFileName);
      TBlobField(FieldByName('ATTACH_DATA')).SaveToFile(pFileName);
    except
      on E: Exception do
      begin
        gvErrorNo := 9006; // 파일 생성 오류
        gvExtMsg := '';
        Exit;
      end;
    end;
    Result := True;
  end; // end of with
end;

//------------------------------------------------------------------------------
//  Fax/Tlx 전송 Image를  File로 저장
//------------------------------------------------------------------------------

function gf_SaveSentImageToFile(pSendDate: string;
  pCurTotSeqNo: Integer; pFileName: string): boolean;
begin
  Result := False;
  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' Select fi.MAIN_DATA, fi.DIRECTION, fi.FILE_TYPE '
      + ' From SCFAXSND_TBL fs, SCFAXIMG_TBL fi   '
      + ' Where fs.SND_DATE = ''' + pSendDate + ''' '
      + '   and fs.CUR_TOT_SEQ_NO = ' + IntToStr(pCurTotSeqNo)
      + '   and fs.SND_DATE   = fi.SND_DATE   '
      + '   and fs.TRADE_DATE = fi.TRADE_DATE '
      + '   and fs.DEPT_CODE  = fi.DEPT_CODE  '
      + '   and fs.IDX_SEQ_NO = fi.IDX_SEQ_NO '
      + '   and DATALENGTH(fi.MAIN_DATA) <> 0 '); // 한투에서 MAIN_DATA를 날려서 추가~~
    try
      gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
    except
      on E: Exception do
      begin
        gf_ShowErrDlgMessage(0, 9001, E.Message, 0);
        gvErrorNo := 9001; // DataBase 오류입니다.
        gvExtMsg := E.Message;
        Exit;
      end;
    end;

    if RecordCount = 0 then
    begin
      gvErrorNo := 1068; // 해당 정보를 읽어올 수 없습니다.
      gvExtMsg := '';
      Exit;
    end;

      // Save Image File
    try
      DeleteFile(pFileName);
      TBlobField(FieldByName('MAIN_DATA')).SaveToFile(pFileName);

      gvFaxReportDirection := Trim(FieldByName('DIRECTION').AsString);
      gvFaxReportFileType  := Trim(FieldByName('FILE_TYPE').AsString);      
    except
      on E: Exception do
      begin
        gvErrorNo := 9006; // 파일 생성 오류
        gvExtMsg := '';
        Exit;
      end;
    end;
    Result := True;
  end; // end of with
end;

//------------------------------------------------------------------------------
//  Free ReportList
//------------------------------------------------------------------------------

procedure gf_FreeReportList(ReportList: TList);
var
  I: Integer;
  ReportItem: pTReportList;
  ACTrade: pTBACTrade;
  GPTrade: pTBGPTrade;
  ACNormal: pTBACNormal;
  GPNormal: pTBGPNormal;
begin
  if not Assigned(ReportList) then Exit;
  for I := 0 to ReportList.Count - 1 do
  begin
    ReportItem := ReportList.Items[I];
    case ReportItem.iExtFlag of
      1: if Assigned(ReportItem.tExtInfo) then
          Dispose(pTBACTrade(ReportItem.tExtInfo));
      2: if Assigned(ReportItem.tExtInfo) then
          Dispose(pTBGPTrade(ReportItem.tExtInfo));
      3: if Assigned(ReportItem.tExtInfo) then
          Dispose(pTBACNormal(ReportItem.tExtInfo));
      4: if Assigned(ReportItem.tExtInfo) then
          Dispose(pTBGPNormal(ReportItem.tExtInfo));
    end;
    Dispose(ReportItem);
  end; // end of for
  ReportList.Free;
end;

//------------------------------------------------------------------------------
// Telex의 국가코드 확인
//------------------------------------------------------------------------------

function gf_CheckValidNatCode(pNatCode: string): boolean;
begin
  Result := False;
  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' Select NAT_CODE '
      + ' From SCNATCD_TBL '
      + ' Where NAT_CODE = ''' + pNatCode + ''' ');
    gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
    if RecordCount = 1 then Result := True;
  end;
end;

//------------------------------------------------------------------------------
// Text File을 구분자별 Unit으로 Split시켜 저장
// P.H.S 2006.08.08   파일명에 pFreqNo(회차) 추가
//------------------------------------------------------------------------------

function gf_SplitTextFile(pSrcFileName, pDesFileName, pTxtUnitInfo, pFreqNo: string): boolean;
var
  sReadBuff, sTmpStr: string;
  SplitPgNoList, DesFileList: TStringList;
  I, iNextPageNo, iNextLine, iReadCnt, iPageNo: Integer;
  SrcFile, DesFile: TextFile;
  DestFileName, DestFileDir: string;
begin
  Result := False;
  gvErrorNo := 1132; // Export 중 오류 발생
  gvExtMsg := '';

   // Assign Read File
  AssignFile(SrcFile, pSrcFileName);
{$I-}
  Reset(SrcFile);
{$I+}
  if IOResult <> 0 then
  begin
    gvErrorNo := 1027; // 해당 파일이 존재하지 않습니다.
    gvExtMsg := '';
    try
      CloseFile(SrcFile);
    except
      on EInOutError do
      begin
           // 이것이 없으면 I/O Error Exception후 뻗는 현상 발생
      end;
    end;
    Exit;
  end;

  if Trim(pTxtUnitInfo) = '' then
  begin
      // Assign Write File
    AssignFile(DesFile, pDesFileName + '.txt');
{$I-}
    Rewrite(DesFile);
{$I+}
    if IOResult <> 0 then
    begin
      gvErrorNo := 9006; // 파일 생성 오류
      gvExtMsg := '';
      try
        CloseFile(SrcFile);
        CloseFile(DesFile);
      except
        on EInOutError do //이미 Word등 프로그램으로 열린 경우 103 Error 발생
        begin
              // 이것이 없으면 I/O Error Exception후 뻗는 현상 발생
        end;
      end;
      Exit;
    end;
    while not Eof(SrcFile) do
    begin
      Readln(SrcFile, sReadBuff);
      Writeln(DesFile, sReadBuff);
    end; // end of while
    try
      CloseFile(SrcFile);
      CloseFile(DesFile);
    except
      on EInOutError do
      begin
           // 이것이 없으면 I/O Error Exception후 뻗는 현상 발생
      end;
    end;
    Result := True;
    Exit;
  end;

  DesFileList := TStringList.Create;
  SplitPgNoList := TStringList.Create;
  iReadCnt := 1;
  while True do
  begin
    sTmpStr := fnGetTokenStr(pTxtUnitInfo, gcSPLIT_CHAR, iReadCnt);
    if Trim(sTmpStr) = '' then break;

    if pFreqNo <> '' then
    begin
      DesFileList.Add(pDesFileName + '_' +
        fnGetTokenStr(sTmpStr, gcSUB_SPLIT_CHAR, 1) + '_' + pFreqNo + '.txt');
      SplitPgNoList.Add(fnGetTokenStr(sTmpStr, gcSUB_SPLIT_CHAR, 2));
    end
    else begin
      DesFileList.Add(pDesFileName + '_' +
        fnGetTokenStr(sTmpStr, gcSUB_SPLIT_CHAR, 1) + '.txt');
      SplitPgNoList.Add(fnGetTokenStr(sTmpStr, gcSUB_SPLIT_CHAR, 2));
    end;

    Inc(iReadCnt);
  end; // end of while

  iPageNo := 1;
  iNextLine := 1;
  for I := 0 to DesFileList.Count - 1 do
  begin
      // Assign Write File
    DestFileName := ExtractFileName(DesFileList.Strings[I]);
    DestFileDir := ExtractFileDir(DesFileList.Strings[I]);

      // 화일명에 특수문자 포함안됨.
    DestFileName := StringReplace(DestFileName, '/', ' ', [rfReplaceAll]);
    DestFileName := StringReplace(DestFileName, '\', ' ', [rfReplaceAll]);
    DestFileName := StringReplace(DestFileName, ':', ' ', [rfReplaceAll]);
    DestFileName := StringReplace(DestFileName, '*', ' ', [rfReplaceAll]);
    DestFileName := StringReplace(DestFileName, '?', ' ', [rfReplaceAll]);
    DestFileName := StringReplace(DestFileName, '"', ' ', [rfReplaceAll]);
    DestFileName := StringReplace(DestFileName, '<', ' ', [rfReplaceAll]);
    DestFileName := StringReplace(DestFileName, '>', ' ', [rfReplaceAll]);
    DestFileName := StringReplace(DestFileName, '|', ' ', [rfReplaceAll]);

    AssignFile(DesFile, DestFileDir + '/' + DestFileName); //DesFileList.Strings[I]);
{$I-}
    Rewrite(DesFile);
{$I+}
    if IOResult <> 0 then
    begin
      gvErrorNo := 9006; // 파일 생성 오류
      gvExtMsg := '';
      try
        CloseFile(SrcFile);
        CloseFile(DesFile);
      except
        on EInOutError do //이미 Word등 프로그램으로 열린 경우 103 Error 발생
        begin
              // 이것이 없으면 I/O Error Exception후 뻗는 현상 발생
        end;
      end;
      Exit;
    end;

    if I < DesFileList.Count - 1 then
      iNextPageNo := StrToInt(SplitPgNoList.Strings[I + 1])
    else
      iNextPageNo := 0;

    while not Eof(SrcFile) do
    begin
      Readln(SrcFile, sReadBuff);
      Writeln(DesFile, sReadBuff);
      Inc(iNextLine);
      if iNextLine = gcRTYPE_TEXT_MAX_LINE + 1 then
      begin
        Inc(iPageNo);
        iNextLine := 1;
        if iPageNo = iNextPageNo then
        begin
          CloseFile(DesFile);
          Break;
        end;
      end;
    end; // end of while
  end; // end of for

  if Assigned(DesFileList) then DesFileList.Free;
  if Assigned(SplitPgNoList) then SplitPgNoList.Free;
  try
    CloseFile(SrcFile);
    CloseFile(DesFile);
  except
    on EInOutError do
    begin
        // 이것이 없으면 I/O Error Exception후 뻗는 현상 발생
    end;
  end;
  Result := True;
end;

//------------------------------------------------------------------------------
// Text File을 Page 구분된 Text File로 변환
// 2006.08.31 P.H.S (#12) 제거
//------------------------------------------------------------------------------

function gf_ConvertPageText(pSrcFileName, pDesFileName: string; pPSStrList: TStringList;
  var pTotPageCnt: Integer; var pLogoPageNo, pTxtUnitInfo: string): boolean;
var
  sReadBuff: string;
  SrcFile, DesFile: TextFile;
  I, K, iLineCnt, iRtnCnt, iModCnt, iStrIdx: Integer;
  RptDataList: TStringList;
begin
  Result := False;
  gvErrorNo := 1128; // TEXT 파일 변환 중 오류 발생
  gvExtMsg := '';

  if not FileExists(pSrcFileName) then
  begin
    gvErrorNo := 1027; // 해당 파일이 존재하지 않습니다.
    gvExtMsg := '';
    Exit;
  end;

   // Assign Read File
  AssignFile(SrcFile, pSrcFileName);
{$I-}
  Reset(SrcFile);
{$I+}
  if IOResult <> 0 then
  begin
    gvErrorNo := 1027; // 해당 파일이 존재하지 않습니다.
    gvExtMsg := '';
    CloseFile(SrcFile);
    Exit;
  end;

   // Assign Write File
  AssignFile(DesFile, pDesFileName);
{$I-}
  Rewrite(DesFile);
{$I+}
  if IOResult <> 0 then
  begin
    gvErrorNo := 9006; // 파일 생성 오류
    gvExtMsg := '';
    CloseFile(SrcFile);
    CloseFile(DesFile);
    Exit;
  end;

  iStrIdx := -1;
  RptDataList := TStringList.Create;

   // PS 처리
  if pPSStrList.Count > 0 then
  begin
    for I := 0 to pPSStrList.Count - 1 do
    begin
      RptDataList.Add(pPSStrList.Strings[I]);
      Inc(iStrIdx);
    end; // end of for
    RptDataList.Add(gcSPLIT_CHAR + gcPS_MARK + gcSPLIT_CHAR + gcPS_MARK + gcSPLIT_CHAR); // PS 표시
    Inc(iStrIdx);
  end; // end of if

//if gvRealLogYN = 'Y' then gf_Log('전송SendFaxTlx gf_ConvertPageText 1 End');

   // 공백 Line 제거 후 RptDataList에 저장
  while not Eof(SrcFile) do
  begin
    Readln(SrcFile, sReadBuff);
    sReadBuff := StringReplace(sReadBuff, #12, '', [rfReplaceAll]);
    if copy(sReadBuff, 1, 1) <> gcSPLIT_CHAR then
    begin
      RptDataList.Add(sReadBuff);
      Inc(iStrIdx);
    end
    else //  이전에 공백 Line이 있는지 확인 후 제거
    begin
      while Trim(RptDataList.Strings[iStrIdx]) = '' do
      begin
        RptDataList.Delete(iStrIdx);
        dec(iStrIdx);
      end;
      RptDataList.Add(sReadBuff);
      Inc(iStrIdx);
    end;
  end; // end of while
  iStrIdx := RptDataList.Count - 1; // 마지막 Index
  while Trim(RptDataList.Strings[iStrIdx]) = '' do
  begin
    RptDataList.Delete(iStrIdx);
    dec(iStrIdx);
  end;

//if gvRealLogYN = 'Y' then gf_Log('전송SendFaxTlx gf_ConvertPageText 2 End');

  iLineCnt := 0; // Line수
  pTotPageCnt := 0; // Page수
  pLogoPageNo := ''; // Logo가 Print될 Page No
  pTxtUnitInfo := ''; // Text File 생성시 구분이 될 Page No
  for I := 0 to RptDataList.Count - 1 do
  begin
    sReadBuff := RptDataList.Strings[I];
    if copy(sReadBuff, 1, 1) <> gcSPLIT_CHAR then
    begin
      Writeln(DesFile, sReadBuff);
      Inc(iLineCnt);
    end
    else
    begin
      pLogoPageNo := pLogoPageNo + IntToStr(pTotPageCnt + 1) + gcSPLIT_CHAR;
      pTxtUnitInfo := pTxtUnitInfo
        + fnGetTokenStr(sReadBuff, gcSPLIT_CHAR, 2) + gcSUB_SPLIT_CHAR
        + IntToStr(pTotPageCnt + 1) + gcSUB_SPLIT_CHAR + gcSPLIT_CHAR;
      pTotPageCnt := pTotPageCnt + (iLineCnt div gcRTYPE_TEXT_MAX_LINE);
      iModCnt := iLineCnt mod gcRTYPE_TEXT_MAX_LINE;
      iRtnCnt := 0;
      if iModCnt > 0 then
      begin
        iRtnCnt := gcRTYPE_TEXT_MAX_LINE - iModCnt;
        Inc(pTotPageCnt);
      end;
      if iRtnCnt > 0 then
      begin
        for K := 1 to iRtnCnt do
          Writeln(DesFile, '');
      end;
      iLineCnt := 0;
    end; // end of else
  end; // end of for

//if gvRealLogYN = 'Y' then gf_Log('전송SendFaxTlx gf_ConvertPageText 3 End');

  CloseFile(SrcFile);
  CloseFile(DesFile);
  RptDataList.Free;

  gvErrorNo := 0;
  gvExtMsg := '';
  Result := True;
end;

//------------------------------------------------------------------------------
// Preview Edit Text Type Report
//------------------------------------------------------------------------------

function gf_PreviewEditor(pOpenFileName, pSaveFileName,
  pOrientation, pExpFileNameBody: string; var pPSStrList: TStringList): boolean;
begin
  Result := False;
  Application.CreateForm(TForm_Edit, Form_Edit);
  with Form_Edit do
  begin
    if not OpenEditFile(pOpenFileName, pSaveFileName,
      pOrientation, pExpFileNameBody, pPSStrList) then Exit; // Error
    ShowModal;
  end;
  Result := True;
end;

//------------------------------------------------------------------------------
// Preview Text Type Report
// [P.H.S 2005-08-25]
// PDF파일명 : ExportDir + YYYYMMDD_계좌번호(ID)_FaxNumber_서식명_회차
// pFreqNo Param 추가
//------------------------------------------------------------------------------

function gf_PreviewText(pOpenFileName, pOrientation, pTitle, pTabCaption, pExpFileNameBody: string; pFreqNo: string): boolean;
begin
  Result := False;
  Application.CreateForm(TForm_Edit, Form_Edit);
  with Form_Edit do
  begin
    if not OpenReadFile(pOpenFileName, pOrientation, pTitle, pTabCaption, pExpFileNameBody, pFreqNo) then Exit; // Error
    ShowModal;
  end;
  Result := True;
end;

//------------------------------------------------------------------------------
// FAX PS Input Box Create & Return PS StringList
//------------------------------------------------------------------------------

procedure gf_ShowPSInputBox(var PSDefaultList, PSLeftList, PSRightList: TStringList;
  pDeptCode, pTradeDate, pAccNm, pSubAccNo, pMediaNo, pRptId,
  pGrpType, pRptType, pDirection, pWkMode: string);
const
  CHAR_WIDTH = 6;
  MEMO_MARGIN = 10;

var
  I, RtnValue: Integer;
  PSExistFlag: boolean;
  iMaxColCnt, iMaxRowCnt: Integer;
begin
  try
    Application.CreateForm(TDlgForm_PSInputBox, DlgForm_PSInputBox);

      // Form Create 성공
    with DlgForm_PSInputBox do
    begin
         //-----------------------------------------------P.S 삭제
      if pWkMode = 'D' then
      begin
        TradeDate := pTradeDate;
        AccNm := pAccNm;
        SubAccNo := pSubAccNo;
        MediaNo := pMediaNo;
        ReportID := pRptId;
        Grptype := pGrpType;

        if not PSDataDelete then Exit;
      end else
         //-----------------------------------------------P.S 입력
      begin
            // MaxColCnt, MaxRowCnt Setting
        if pRptType = gcRTYPE_CRPT then
        begin
          iMaxColCnt := gcCRPTPS_MAX_COL_PORT; // Default 세로  65
          if pDirection = gcLandscape then // 가로 85
            iMaxColCnt := gcCRPTPS_MAX_COL_LAND;
          iMaxRowCnt := gcCRPTPS_MAX_ROW; // 10
          DRMemo_PS.ScrollBars := ssNone;
          DRMemo_PS.MaxLength := iMaxColCnt * iMaxRowCnt;

          TradeDate := pTradeDate;
          AccNm := pAccNm;
          SubAccNo := pSubAccNo;
          MediaNo := pMediaNo;
          ReportID := pRptId;
          Grptype := pGrpType;
        end
        else // if pRptType = gcRTYPE_TEXT then
        begin
          iMaxColCnt := gcRTYPE_TEXT_MAX_CHAR;
          iMaxRowCnt := gcRTYPE_TEXT_MAX_LINE;
          DRMemo_PS.ScrollBars := ssVertical;
          DRMemo_PS.MaxLength := 0; // 입력 제한 없음

          TradeDate := pTradeDate;
          AccNm := pAccNm;
          SubAccNo := pSubAccNo;
          MediaNo := pMediaNo;
          ReportID := pRptId;
          Grptype := pGrpType;
        end;
        MaxColCnt := iMaxColCnt;
        MaxRowCnt := iMaxRowCnt;

            // Form의 Width Setting
        ClientWidth := DRMemo_LineNo.Width +
          (MaxColCnt * CHAR_WIDTH) + MEMO_MARGIN;

            // 입력 문자 선택
        DRMemo_PS.ImeMode := imSHanguel; // Default => 한글
        if (pDeptCode = gcDEPT_CODE_INT) or // 국제부
          (pRptType = gcRTYPE_TEXT) then // Text 양식
          DRMemo_PS.ImeMode := imSAlpha; // Default => 영문

            // Memo에 해당 P.S 입력
        if not Assigned(PSDefaultList) then
          PSDefaultList := TStringList.Create;
        DRMemo_PS.Lines.Clear;
        for I := 0 to PSDefaultList.Count - 1 do
          DRMemo_PS.Lines.Add(PSDefaultList.Strings[I]);

            // Memo에 해당 Left P.S 입력
        if not Assigned(PSLeftList) then
          PSLeftList := TStringList.Create;
        DRMemo_LeftPS.Lines.Clear;
        for I := 0 to PSLeftList.Count - 1 do
          DRMemo_LeftPS.Lines.Add(PSLeftList.Strings[I]);

            // Memo에 해당 Right P.S 입력
        if not Assigned(PSRightList) then
          PSRightList := TStringList.Create;
        DRMemo_RightPS.Lines.Clear;
        for I := 0 to PSRightList.Count - 1 do
          DRMemo_RightPS.Lines.Add(PSRightList.Strings[I]);

        RtnValue := ShowModal;
        if RtnValue = idOK then // 확인 버튼 클릭한 경우에만 처리
        begin
          PSDefaultList.Clear;
          PSLeftList.Clear;
          PSRightList.Clear;

               // DefaultPS Data가 존재하는지 판단
          PSExistFlag := False;
          for I := 0 to DRMemo_PS.Lines.Count - 1 do
          begin
            if I > iMaxRowCnt - 1 then Break;
            if Trim(DRMemo_PS.Lines.Strings[I]) <> '' then
            begin
              PSExistFlag := True;
              Break;
            end;
          end; //end of for

          if PSExistFlag then // PS 존재
          begin
            for I := 0 to DRMemo_PS.Lines.Count - 1 do
            begin
              if I > iMaxRowCnt - 1 then Break;
              PSDefaultList.Add(Trim(DRMemo_PS.Lines.Strings[I]));
            end; // end of for
          end; // end of if

               // LeftPS Data가 존재하는지 판단
          PSExistFlag := False;
          for I := 0 to DRMemo_LeftPS.Lines.Count - 1 do
          begin
            if I > iMaxRowCnt - 1 then Break;
            if Trim(DRMemo_LeftPS.Lines.Strings[I]) <> '' then
            begin
              PSExistFlag := True;
              Break;
            end;
          end; //end of for

          if PSExistFlag then // PS 존재
          begin
            for I := 0 to DRMemo_LeftPS.Lines.Count - 1 do
            begin
              if I > iMaxRowCnt - 1 then Break;
              PSLeftList.Add(Trim(DRMemo_LeftPS.Lines.Strings[I]));
            end; // end of for
          end; // end of if

               // RightPS Data가 존재하는지 판단
          PSExistFlag := False;
          for I := 0 to DRMemo_RightPS.Lines.Count - 1 do
          begin
            if I > iMaxRowCnt - 1 then Break;
            if Trim(DRMemo_RightPS.Lines.Strings[I]) <> '' then
            begin
              PSExistFlag := True;
              Break;
            end;
          end; //end of for

          if PSExistFlag then // PS 존재
          begin
            for I := 0 to DRMemo_RightPS.Lines.Count - 1 do
            begin
              if I > iMaxRowCnt - 1 then Break;
              PSRightList.Add(Trim(DRMemo_RightPS.Lines.Strings[I]));
            end; // end of for
          end; // end of if
        end; // end of if Result = idOK
      end; // end of if WkMode
    end; // end of with
  finally
    DlgForm_PSInputBox.Free;
  end;
end;

//------------------------------------------------------------------------------
// Data RSPFlag Font Color Return
//------------------------------------------------------------------------------

function gf_GetDataRSPFlagColor(pRSPFlagName: string): TColor;
begin
  if pRSPFlagName = gwRSPWaiting then Result := gcRSPWaitColor
  else if pRSPFlagName = gwRSPSend then Result := gcRSPSendColor
  else if pRSPFlagName = gwRSPAck then Result := gcRSPAckColor
  else if pRSPFlagName = gwRSPConfirm then Result := gcRSPConfColor
  else if pRSPFlagName = gwRSPReject then Result := gcRSPRejColor
  else if pRSPFlagName = gwRSPReceive then Result := gcRSPRecvColor
  else Result := clBlack;
end;

//------------------------------------------------------------------------------
// Fax/Tlx RSPFlag Font Color Return
//------------------------------------------------------------------------------

function gf_GetFaxTlxRSPFlagColor(pRSPFlagName: string): TColor;
begin
  if pRSPFlagName = gwRSPWaiting then Result := gcRSPWaitColor
  else if pRSPFlagName = gwRSPSend then Result := gcRSPSendColor
  else if pRSPFlagName = gwRSPSent then Result := gcRSPSentColor
  else if pRSPFlagName = gwRSPBusy then Result := gcRSPBusyColor
  else if pRSPFlagName = gwRSPFinish then Result := gcRSPFinColor
  else if pRSPFlagName = gwRSPCancel then Result := gcRSPCancColor
  else if pRSPFlagName = gwRSPError then Result := gcErrorColor
  else Result := clBlack;
end;

//------------------------------------------------------------------------------
// WM_USER_MSMQ_RESULT WParam Message Return
//------------------------------------------------------------------------------

function gf_GetMSMQResult(pRSPFlag: Integer): string;
begin
  case pRSPFlag of
    gcMSMQ_RSPF_WAIT: Result := gwRSPWaiting;
    gcMSMQ_RSPF_SEND: Result := gwRSPSend;
    gcMSMQ_RSPF_ACK: Result := gwRSPAck;
    gcMSMQ_RSPF_CONF: Result := gwRSPConfirm;
    gcMSMQ_RSPF_RECV: Result := gwRSPReceive
  else
    Result := '';
  end;
end;

//------------------------------------------------------------------------------
// WM_USER_FAX_RESULT WParam Message Return
//------------------------------------------------------------------------------

function gf_GetFaxTlxResult(pRSPFlag: Integer): string;
begin
  case pRSPFlag of
    gcFAXTLX_RSPF_WAIT: Result := gwRSPWaiting;
    gcFAXTLX_RSPF_SEND: Result := gwRSPSend;
    gcFAXTLX_RSPF_BUSY: Result := gwRSPBusy;
    gcFAXTLX_RSPF_CANC: Result := gwRSPCancel;
    gcFAXTLX_RSPF_SENT: Result := gwRSPSent;
    gcFAXTLX_RSPF_FIN: Result := gwRSPFinish
  else
    Result := '';
  end;
end;

//------------------------------------------------------------------------------
// WM_USER_MAIL_RESULT WParam Message Return
//------------------------------------------------------------------------------

function gf_GetMailResult(pRSPFlag: Integer): string;
begin
  case pRSPFlag of
    gcEMAIL_RSPF_WAIT: Result := gwRSPWaiting;
    gcEMAIL_RSPF_SEND: Result := gwRSPSend;
    gcEMAIL_RSPF_CANC: Result := gwRSPCancel;
    gcEMAIL_RSPF_FIN: Result := gwRSPFinish
  else
    Result := '';
  end;
end;

//------------------------------------------------------------------------------
// Mail RSPFlag Font Color Return
//------------------------------------------------------------------------------

function gf_GetMailRSPFlagColor(pRSPFlagName: string): TColor;
begin
  if pRSPFlagName = gwRSPWaiting then Result := gcRSPWaitColor
  else if pRSPFlagName = gwRSPSend then Result := gcRSPSendColor
  else if pRSPFlagName = gwRSPFinish then Result := gcRSPFinColor
  else if pRSPFlagName = gwRSPCancel then Result := gcRSPCancColor
  else if pRSPFlagName = gwRSPError then Result := gcErrorColor
  else Result := clBlack;
end;

//------------------------------------------------------------------------------
// SRMgrFrame Enable
//------------------------------------------------------------------------------

procedure gf_EnableSRMgrFrame(pSRMgrFrame: TForm);
begin
  pSRMgrFrame.Perform(WM_USER_ENABLE_SRMGRFRAME, 0, 0);
end;

//------------------------------------------------------------------------------
// SRMgrFrame Disable
//------------------------------------------------------------------------------

procedure gf_DisableSRMgrFrame(pSRMgrFrame: TForm);
begin
  pSRMgrFrame.Perform(WM_USER_DISABLE_SRMGRFRAME, 0, 0);
end;
//------------------------------------------------------------------------------
// Show MailSnd
//------------------------------------------------------------------------------

function gf_ShowMailSnd(pSndDate: string; SndItem: pTFSndMail): boolean;
begin
  Result := False;
  Application.CreateForm(TDlgForm_ViewMail, DlgForm_ViewMail);
  with DlgForm_ViewMail do
  begin
    if not ShowMailSnd(pSndDate, SndItem) then Exit; // Error
    ShowModal;
  end;
  Result := True;
end;
//------------------------------------------------------------------------------
// Show MailSnt
//------------------------------------------------------------------------------

function gf_ShowMailSnt(pSndDate: string; FreqItem: pTFreqMail): boolean;
begin
  Result := False;
  Application.CreateForm(TDlgForm_ViewMail, DlgForm_ViewMail);
  with DlgForm_ViewMail do
  begin
    if not ShowMailSnt(pSndDate, FreqItem) then Exit; // Error
    ShowModal;
  end;
  Result := True;
end;
//------------------------------------------------------------------------------
// Edit Attatch File
//------------------------------------------------------------------------------

function gf_EditAttFile(pFileName: string): boolean;
begin
  Result := False;
  Application.CreateForm(TForm_EditAttFile, Form_EditAttFile);
  with Form_EditAttFile do
  begin
    LoadAttFile(pFileName);
    ShowModal;
  end;
  Result := True;
end;
//------------------------------------------------------------------------------
//  Print Form
//------------------------------------------------------------------------------
{
procedure gf_PrintForm(pPrintForm: TForm);
var
  FormImage : TImage;
begin
   with DataModule_SettleNet.DRMWPrintObject_Main do
   begin
      FormImage := Nil;
      if PrinterCanvas <> nil then Exit;
      Try
         Orientation := gvPrinter.Orientation;
         Title       := pPrintForm.Caption;
         Start;
         FormImage := TImage.Create(Nil);
         FormImage.Picture.Bitmap := pPrintForm.GetFormImage;
         case Orientation of
           // A4용지              가로:210 mm       세로:297 mm
           // 1 Cm -> 0.3937 In        8.2677 In        11.692 In
           // 1 In -> 25.4 mm   0.3 In ->   7.62 mm
           //                  10.5 In -> 266.7  mm
           //                     6 In -> 152.4  mm
           //                   7.8 In -> 198.12 mm
           //                   5.5 In -> 139.7  mm
           poLandscape : PrintGraphic(0.3,0.3,10.5,6,FormImage);
           else          PrintGraphic(0.3,0.3,7.8,5.5,FormImage);
         end;
         Quit;
      Except
         on E: Exception do
            gf_ShowErrDlgMessage(0, 0, E.Message, 0);
      end;
   end;
   FormImage.Destroy;
end;
}
//------------------------------------------------------------------------------
// NotePad 실행시키는 함수
//------------------------------------------------------------------------------

procedure gf_ExecNotePad(pParentHandle: THandle; pFileName: string);
begin
  ShellExecute(pParentHandle, 'open', 'notepad', pChar(pFileName), '', SW_SHOWNORMAL);
end;

//------------------------------------------------------------------------------
// Ini File에서 해당 Form의 정보를 읽어오는 함수
//------------------------------------------------------------------------------

function gf_ReadFormStrInfo(pFormName, pKeyName, pDefaultValue: string): string;
var
  FormInfo: TIniFile;
begin
  FormInfo := TIniFile.Create(gvDirCfg + gcFormIniFileName);
  Result := FormInfo.ReadString(pFormName, pKeyName, pDefaultValue);
  FormInfo.Free;
end;

//------------------------------------------------------------------------------
// Ini File에 해당 Form 정보 기록하는 함수
//------------------------------------------------------------------------------

procedure gf_WriteFormStrInfo(pFormName, pKeyName, pDefaultValue: string);
var
  FormInfo: TIniFile;
begin
  FormInfo := TIniFile.Create(gvDirCfg + gcFormIniFileName);
  FormInfo.WriteString(pFormName, pKeyName, pDefaultValue);
  FormInfo.Free;
end;

//------------------------------------------------------------------------------
// Ini File에서 해당 Form의 정보를 읽어오는 함수(Integer Type)
//------------------------------------------------------------------------------

function gf_ReadFormIntInfo(pFormName, pKeyName: string; pDefaultValue: Integer): Integer;
var
  FormInfo: TIniFile;
begin
  FormInfo := TIniFile.Create(gvDirCfg + gcFormIniFileName);
  Result := FormInfo.ReadInteger(pFormName, pKeyName, pDefaultValue);
  FormInfo.Free;
end;

//------------------------------------------------------------------------------
// Ini File에 해당 Form 정보 기록하는 함수(Integer Type)
//------------------------------------------------------------------------------

procedure gf_WriteFormIntInfo(pFormName, pKeyName: string; pDefaultValue: Integer);
var
  FormInfo: TIniFile;
begin
  FormInfo := TIniFile.Create(gvDirCfg + gcFormIniFileName);
  FormInfo.WriteInteger(pFormName, pKeyName, pDefaultValue);
  FormInfo.Free;
end;

//------------------------------------------------------------------------------
// Directory 간에 파일 복사
//------------------------------------------------------------------------------

function gf_CopyFile(pSource, pDestn: string): boolean;
var
  SHFileOpStruct: TSHFileOpStruct;
begin
  with SHFileOpStruct do
  begin
    Wnd := Screen.ActiveForm.Handle;
    wFunc := FO_COPY;
    pFrom := PChar(pSource + chr(0));
    pTo := PChar(pDestn);
    fFlags := FOF_FILESONLY or FOF_NOCONFIRMATION;
    hNameMappings := nil;
    lpszProgressTitle := nil;
  end;

  if SHFileOperation(SHFileOpStruct) = 0 then
    Result := True
  else
    Result := False;
{
   File_DirOperations_Datail(
     'COPY', //Action            : String;  //COPY, DELETE, MOVE, RENAME
     False,    //RenameOnCollision : Boolean; //Renames if directory exists
     True,     //NoConfirmation    : Boolean; //Responds "Yes to All" to any dialogs
     True,     //Silent            : Boolean; //No progress dialog is shown
     False,    //ShowProgress      : Boolean; //displays progress dialog but no file names
     pSource,  //FromDir : String;  //From directory
     pDestn    //ToDir   : String   //To directory
     );
}
end;

//------------------------------------------------------------------------------
// Directory Del
//------------------------------------------------------------------------------

procedure gf_DelDirectory(DirectoryName: string);
begin
  File_DirOperations_Datail(
    'DELETE', //Action            : String;  //COPY, DELETE, MOVE, RENAME
    False, //RenameOnCollision : Boolean; //Renames if directory exists
    True, //NoConfirmation    : Boolean; //Responds "Yes to All" to any dialogs
    True, //Silent            : Boolean; //No progress dialog is shown
    False, //ShowProgress      : Boolean; //displays progress dialog but no file names
    DirectoryName, //FromDir : String;  //From directory
    '' //ToDir   : String   //To directory
    );

end;


function File_DirOperations_Datail(
  Action: string; //COPY, DELETE, MOVE, RENAME
  RenameOnCollision: Boolean; //Renames if directory exists
  NoConfirmation: Boolean; //Responds "Yes to All" to any dialogs
  Silent: Boolean; //No progress dialog is shown
  ShowProgress: Boolean; //displays progress dialog but no file names
  FromDir: string; //From directory
  ToDir: string //To directory
  ): Boolean;
var
  SHFileOpStruct: TSHFileOpStruct;
  FromBuf, ToBuf: array[0..255] of Char;
begin
  try
  //   If Not DirectoryExists(FromDir) Then
  //   Begin
  //     Result := False;
  //     Exit;
  //   End;
    Fillchar(SHFileOpStruct, Sizeof(SHFileOpStruct), 0);
    FillChar(FromBuf, Sizeof(FromBuf), 0);
    FillChar(ToBuf, Sizeof(ToBuf), 0);
    StrPCopy(FromBuf, FromDir);
    StrPCopy(ToBuf, ToDir);
    with SHFileOpStruct do
    begin
      Wnd := 0;
      if UpperCase(Action) = 'COPY' then wFunc := FO_COPY;
      if UpperCase(Action) = 'DELETE' then wFunc := FO_DELETE;
      if UpperCase(Action) = 'MOVE' then wFunc := FO_MOVE;
      if UpperCase(Action) = 'RENAME' then wFunc := FO_RENAME;
      pFrom := @FromBuf;
      pTo := @ToBuf;
      fFlags := FOF_ALLOWUNDO;
      if RenameOnCollision then fFlags := fFlags or FOF_RENAMEONCOLLISION;
      if NoConfirmation then fFlags := fFlags or FOF_NOCONFIRMATION;
      if Silent then fFlags := fFlags or FOF_SILENT;
      if ShowProgress then fFlags := fFlags or FOF_SIMPLEPROGRESS;
    end;
    Result := (SHFileOperation(SHFileOpStruct) = 0);
  except
    Result := False;
  end;
end;




//------------------------------------------------------------------------------
// TrCode에 해당하는 사용자등록 Image Index Return
//------------------------------------------------------------------------------

function gf_TrCodeToImageIdx(pSecType: string; pTrCode: Integer): Integer;
var
  ToolItem: pTUserToolBar;
  BtnItem: pTBtnInfo;
  I, K: Integer;
begin
  Result := -1;
  for I := 0 to gvUsrToolBarList.Count - 1 do
  begin
    ToolItem := gvUsrToolBarList.Items[I];
    if ToolItem.SecType = pSecType then
    begin
      for K := 0 to ToolItem.BtnInfoList.Count - 1 do
      begin
        BtnItem := ToolItem.BtnInfoList.Items[K];
        if BtnItem.TrCode = pTrCode then
        begin
          Result := BtnItem.ImageIdx;
          Exit;
        end; // end of if
      end; // end of for K
    end; // end of if
  end; // end of for I
end;

//------------------------------------------------------------------------------
// TrCode에 해당하는 메뉴이름 Return
//------------------------------------------------------------------------------

function gf_TrCodeToMenuName(pTrCode: Integer; var pFullName,
  pShrtName: string): boolean;
var
  I: Integer;
  MenuItem: pTMenuInfo;
begin
  Result := False;
  pFullName := '';
  pShrtName := '';
  for I := 0 to gvMenuList.Count - 1 do
  begin
    MenuItem := gvMenuList.Items[I];
    if MenuItem.TrCode = IntToStr(pTrCode) then
    begin
      pFullName := MenuItem.MenuName;
      pShrtName := MenuItem.ShrtName;
    end;
  end;
end;

//------------------------------------------------------------------------------
//  사용자 정의 ToolBar 재구성
//------------------------------------------------------------------------------

procedure gf_ResetUserToolBar;
begin
  SendMessage(gvMainFrameHandle, WM_USER_RESET_TOOLBAR, 0, 0);
end;

//------------------------------------------------------------------------------
// Show ICON Dialog (Result = 선택 Image Index)
//------------------------------------------------------------------------------

function gf_ShowIconDlg(ScreenX, ScreenY, CurImageIdx: Integer): Integer;
var
  I: Integer;
begin
  try
    DlgForm_Icon := TDlgForm_Icon.Create(nil);
    with DlgForm_Icon do
    begin
      Top := ScreenY;
      Left := ScreenX;
      if (CurImageIdx >= 0) and (CurImageIdx <= MAX_ICON_CNT - 1) then
        (IconArr[CurImageIdx] as TDRSpeedButton).Down := True;

      ShowModal;

      Result := -1;
      for I := 0 to MAX_ICON_CNT - 1 do
      begin
        if Assigned(IconArr[I]) then
        begin
          if (IconArr[I] as TDRSpeedButton).Down then
          begin
            Result := I;
            break;
          end;
        end; // end of if Assigned
      end; // end of for
    end;
  finally
    DlgForm_Icon.Free;
  end;
end;

//------------------------------------------------------------------------------
// 사용자 부서코드에 대응되는 SettleNet 부서코드 Return
//------------------------------------------------------------------------------

function gf_GetGlobalDeptCode(pUserDeptCode: string;
  var pGlobalDeptCode: string): boolean;
begin
  Result := False;
  pGlobalDeptCode := '';
  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' SELECT DEPT_CODE FROM SUDEPCD_TBL ' +
      ' WHERE USER_DEPT_CODE = ''' + pUserDeptCode + '''');
    try
      gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
    except
      on E: Exception do
      begin
        gvErrorNo := 9001; // Database 오류
        gvExtMsg := E.Message;
        Exit;
      end;
    end;

    if RecordCount <> 1 then
    begin
      gvErrorNo := 2020; //부서코드 오류
      gvExtMsg := 'RecordCount <> 1';
      Exit;
    end;
    pGlobalDeptCode := Trim(FieldByName('DEPT_CODE').asstring);
    Result := True;
  end; // end of with
end;

//------------------------------------------------------------------------------
//  Numeric Data 여부 판단
//------------------------------------------------------------------------------

function gf_IsNumeric(Value: string): boolean;
var
  I: Integer;
begin
  Result := True;
  if Length(Value) = 0 then
  begin
    Result := False;
    Exit;
  end;
  for I := 1 to Length(Value) do
  begin
    if (Ord(Value[I]) < 48) or (Ord(Value[I]) > 57) then
    begin
      Result := False;
      Exit;
    end;
  end;
end;

//------------------------------------------------------------------------------
// 해당 부서의 수신처 관리 화면 생성
//------------------------------------------------------------------------------

function gf_ShowRegFaxTlxAddr(pSendMtd: string; pSendSeq: Integer): Integer;
begin
  Application.CreateForm(TDlgForm_RegFaxTlxAddr, DlgForm_RegFaxTlxAddr);

   // Set Default Data
  DlgForm_RegFaxTlxAddr.DefSendMtd := pSendMtd;
  DlgForm_RegFaxTlxAddr.DefSendSeq := pSendSeq;

  Result := DlgForm_RegFaxTlxAddr.ShowModal; // Assign Return Value
end;


//------------------------------------------------------------------------------
// 해당 부서의 그룹 관리 화면 생성
//------------------------------------------------------------------------------

function gf_ShowRegGroup(pSecType, pGrpName, pCallFlag, pAccNo, pSubAccNo: string): Integer;
begin
  if pSecType = gcSEC_EQUITY then
  begin
    Application.CreateForm(TDlgForm_ERegGroup, DlgForm_ERegGroup);
      // Set Default Data
    DlgForm_ERegGroup.DefGrpName := pGrpName;
    DlgForm_ERegGroup.DefCallFlag := pCallFlag;
    DlgForm_ERegGroup.DefAccNo := pAccNo;
    DlgForm_ERegGroup.DefSubAccNo := pSubAccNo;
    Result := DlgForm_ERegGroup.ShowModal; // Assign Return Value
  end else
  begin
    Application.CreateForm(TDlgForm_FRegGroup, DlgForm_FRegGroup);
      // Set Default Data
    DlgForm_FRegGroup.DefGrpName := pGrpName;
    DlgForm_FRegGroup.DefCallFlag := pCallFlag;
    DlgForm_FRegGroup.DefAccNo := pAccNo;
    DlgForm_FRegGroup.DefSubAccNo := pSubAccNo;
    Result := DlgForm_FRegGroup.ShowModal; // Assign Return Value
  end;
end;


//------------------------------------------------------------------------------
// 이메일 첨부화일 생성 (c:\SettleNet\Client\tmp\에 생성
//                            1.Query시 화일이름 가져오기  (CallFlag = False)
//                            2.Email Send시               (CallFlag = True)
//------------------------------------------------------------------------------

function gf_CreateMailFile(SndItem: pTFSndMail; CallFlag: boolean; JobDate: string): string;
var
  sPathName, sDirName, sFileName, sTmpStr: string;
  iCnt: integer;
  SR: TSearchRec;
  SearchRec: boolean;
  StartTime: Double;
begin

  StartTime := GetTickCount;
  gf_Log('송수신 갱신 - MAIL_ID : ' + SndItem.MailFormId
    + ' MailGroup : ' + SndITem.AccGrpName + ' Start');

  try
    sPathNAme := '';
    sFileName := '';
    sDirName := '';
    iCnt := 1;
    Result := '';
   // Tmp Dir 만들기
    if not DirectoryExists(gvDirTemp) then if not CreateDir(gvDirTemp) then Exit;
   // 사용자 디렉토리 생성
    if SndItem.AccGrpType = gcRGroup_GRP then
      sDirName := gvDirUserData + SndItem.AccGrpName + '\' // 사용자 디렉토리
    else
      sDirName := gvDirUserData + SndItem.AccList.Strings[0] + '\';

   // 파일 이름만 Return
    if gf_CreateEMailFile(SndItem.MailFormId, gvDirTemp, gvDeptCode, JobDate,
      SndITem.AccGrpName, SndITem.AccList, sFileName, False) then
    begin
      sPathName := sFileName //경로명 포함해서
    end else
    begin
      Result := '';
      Exit;
    end;

    SearchRec := false;
    while True do
    begin //UserData에 있는지 판단
      sFileName := ExtractFileName(fnGetTokenStr(sPathName, gcSPLIT_MAILADDR, iCnt));
      if Trim(sFileName) = '' then Break;
      if FindFirst(sDirName + sFileName, faAnyFile, SR) = 0 then
        repeat
          begin
            Result := Result + sDirName + SR.Name + gcSPLIT_MAILADDR;
            SndItem.EditFlag := True;
            SearchRec := true;
          end;
        until FindNext(SR) <> 0;
      Inc(iCnt);
    end; // end of While
    FindClose(SR);
    if IOResult <> 0 then // Error 발생
    begin
      Result := '';
      exit;
    end;
   //UserData에 없으면.
    if not SearchRec then
    begin
      if CallFlag then // Email Send시
      begin
         // MailFile 생성
        if gf_CreateEMailFile(SndItem.MailFormID, gvDirTemp, gvDeptCode, JobDate,
          SndITem.AccGrpName, SndItem.AccList, sFileName, True) then
        begin
          Result := sFileName
        end else
        begin
          Result := '';
          Exit;
        end;
      end else //Query시
        Result := sPathName;
    end; // end of else

  finally
    if (GetTickCount - StartTime) >= 3000 then // 3초 이상
    begin
      gf_Log('=============================== '
        + FloatToStr((GetTickCount - StartTime) * 0.001) + '초 ==');

    end;
    gf_Log('송수신 갱신 - MAIL_ID : ' + SndItem.MailFormId + ' MailGroup : ' + SndITem.AccGrpName + ' End');
  end;


end;

//------------------------------------------------------------------------------
// 파일보기 (UserData Dir 확인 후 없으면 UserData Dir에 생성)
//------------------------------------------------------------------------------

function gf_ViewMailFile(SndItem: pTFSndMail; JobDate: string): string;
var
  sPathName, sDirName, sFileName: string;
  FileItem: pTAttFile;
  i, iCnt: integer;
  SR: TSearchRec;
  SearchRec: boolean;
begin
  Result := '';
  sPathName := '';
  sFileName := '';
  sDirName := '';
  iCnt := 1;
   // 사용자 디렉토리
  if SndItem.AccGrpType = gcRGroup_GRP then
    sDirName := gvDirUserData + SndItem.AccGrpName + '\'
  else
    sDirName := gvDirUserData + SndItem.AccList.Strings[0] + '\';

  if not DirectoryExists(sDirName) then
    if not CreateDir(sDirName) then Exit;

  if SndITem.AttFileList <> nil then
  begin
    for i := 0 to SndItem.AttFileList.Count - 1 do
    begin
      FileItem := SndITem.AttFileList.Items[i];
      sPathName := sPathName + FileItem.FileName + gcSPLIT_MAILADDR;
    end;
  end;
   // User Data 에 있는지 확인
  SearchRec := false;
  while True do
  begin
    sFileName := ExtractFileName(fnGetTokenStr(sPathName, gcSPLIT_MAILADDR, iCnt));
    if Trim(sFileName) = '' then Break;
    if FindFirst(sDirName + sFileName, faAnyFile, SR) = 0 then
      repeat
        begin
          Result := Result + sDirName + SR.Name + gcSPLIT_MAILADDR;
          SndItem.EditFlag := True;
          SearchRec := true;
        end;
      until FindNext(SR) <> 0;
    Inc(iCnt);
  end; // end of While
  FindClose(SR);
  if IOResult <> 0 then // Error 발생
  begin
    Result := '';
    exit;
  end;


  if not SearchRec then
  begin // 없으면 생성
      // MailFile 생성  gvDirUserData\sDirName\FielName
    if gf_CreateEMailFile(SndItem.MailFormID, sDirName, gvDeptCode, JobDate,
      SndITem.AccGrpName, SndITem.AccList, sFileName, True) then
    begin
      Result := sFileName
    end else
    begin
      Result := '';
      Exit;
    end;
  end;
end;
//------------------------------------------------------------------------------
// 이메일 등록화면
//------------------------------------------------------------------------------

function gf_ShowRegEmailAddr(pMailRcv, pMailAddr: string): Integer;
begin
  Application.CreateForm(TDlgForm_RegEmailAddr, DlgForm_RegEmailAddr);

   // Set Default Data
  DlgForm_RegEmailAddr.PubMailRcv := pMailRcv;
  DlgForm_RegEmailAddr.PubMailAddr := pMailAddr;


  Result := DlgForm_RegEmailAddr.ShowModal; // Assign Return Value

end;
//------------------------------------------------------------------------------
// 이메일 수신처 등록 화면 생성
//------------------------------------------------------------------------------

function gf_ShowSelectEmail(pMailAddrList, pCCMailAddrList, pCCBlindAddrList: TStringList;
  pRcvType, pTitle: string): Integer;
begin
  Application.CreateForm(TDlgForm_SelectEmail, DlgForm_SelectEmail);
   // Set Default Data

  DlgForm_SelectEmail.DefMailAddrList := pMailAddrList;
  DlgForm_SelectEmail.DefCCMailAddrList := pCCMailAddrList;
  DlgForm_SelectEmail.DefCCBlindAddrList := pCCBlindAddrList;
  DlgForm_SelectEmail.DefRcvType := pRcvType;
  DlgForm_SelectEmail.DefTitle := pTitle;

  Result := DlgForm_SelectEmail.ShowModal; // Assign Return Value
end;

//------------------------------------------------------------------------------
// 각 SEndSEq의 수신처명을 가져온다
//------------------------------------------------------------------------------

function gf_SendSeqToRcvName(pSendSeq: string): string;
begin
  Result := '';
  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' SELECT RCV_COMP_KOR    '
      + ' FROM   SUMELAD_TBL     '
      + ' WHERE  DEPT_CODE = ''' + gvDeptCode + '''   '
      + '  AND   SEND_SEQ  = ''' + pSendSeq + '''');

    gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
    Result := Trim(FieldByName('RCV_COMP_KOR').asString);
  end;

end;


//------------------------------------------------------------------------------
// Show AttFileDlg
//------------------------------------------------------------------------------

function gf_ShowAttDlg(pSndDate: string; FreqItem: pTFreqMail; pAttSeqNo: Integer): boolean;
begin
  Result := False;
   // Create AttFileDlg
  Application.CreateForm(TForm_ShowAttDlg, Form_ShowAttDlg);
  with Form_ShowAttDlg do
  begin
    pbSndDate := pSndDate;
    pbAttSeqNo := pAttSeqNo;
    pFreqItem := FreqItem;
    ShowModal;
  end;
  Result := True;
end;
//------------------------------------------------------------------------------
// FaxTlxAddrList Clear (SUPRTAD_TBL - Fax/Tlx) Item: TFaxTlxAddr
//------------------------------------------------------------------------------

procedure gf_ClearFaxTlxAddrList(pList: TList);
var
  I: Integer;
  AddrItem: pTFaxTlxAddr;
begin
  if not Assigned(pList) then Exit;
  for I := 0 to pList.Count - 1 do
  begin
    AddrItem := pList.Items[I];
    Dispose(AddrItem);
  end; // end of for
  pList.Clear;
end;

//------------------------------------------------------------------------------
// 수신처 Component에서 수신처 정보를 Display 하기 위한 Format
//------------------------------------------------------------------------------

function gf_FormatFaxTlxAddr(pAddrItem: pTFaxTlxAddr): string;
var
  sSendMtdName: string;
begin
  Result := '';
  if Assigned(pAddrItem) then
  begin
    if pAddrItem.SendMtd = gcSEND_FAX then
    begin
      if pAddrItem.IntTelYn = 'N' then
        sSendMtdName := 'FAX'
      else
        sSendMtdName := gcINT_FAX_MARK + 'FAX'
    end
    else
      sSendMtdName := 'TLX';

    Result := pAddrItem.RcvCompKor + ' (' +
      sSendMtdName + '- ' +
      pAddrItem.NatCode + pAddrItem.MediaNo + ')';
  end;
end;

//------------------------------------------------------------------------------
//  전월 산출 pYearMonth : YYYYMM Return : YYYYMM
//------------------------------------------------------------------------------

function gf_GetPreMonth(pYearMonth: string): string;
var
  iYear, iMonth: Integer;
  sYear, sMonth: string;
begin
  Result := '';
  if Length(pYearMonth) <> 6 then Exit; // Error
  iYear := gf_StrToInt(copy(pYearMonth, 1, 4));
  iMonth := gf_StrToInt(copy(pYearMonth, 5, 2));

  iMonth := iMonth - 1;
  if iMonth = 0 then
  begin
    iMonth := 12;
    iYear := iYear - 1;
  end;
  sYear := FormatFloat('0000', iYear);
  sMonth := FormatFloat('00', iMonth);
  Result := sYear + sMonth;
end;

//------------------------------------------------------------------------------
// 화면권한여부 확인 True:권한있음 False:권한없음
//------------------------------------------------------------------------------

function gf_CanUseTrCode(pTrCode: Integer): boolean;
var
  iSearchIdx: Integer;
begin
  if gvUseTrCodeList.Count > 0 then // 사용자 권한 사용
  begin
    iSearchIdx := gvUseTrCodeList.IndexOf(IntToStr(pTrCode));

    Result := False; // 권한없음
    if iSearchIdx >= 0 then
      Result := True; // 권한있음
  end
  else // 사용자 권한 사용 안함
    Result := True; // 권한있음
end;

//------------------------------------------------------------------------------
// Enable Button
//------------------------------------------------------------------------------

procedure gf_EnableBtn(pTrCode: Integer; pButton: TControl);
var
  iAuthority: Integer;
begin
  iAuthority := gcAUTH_QUERY_ONLY; // 조회만 가능
  if gf_CanUseTrCode(pTrCode) then
    iAuthority := gcAUTH_ALL; // 모든권한

  pButton.Enabled := False;
  if pButton.Tag <= iAuthority then
    pButton.Enabled := True;
end;

//------------------------------------------------------------------------------
// 결재 처리 관련 Report의 꼬리말 Return;
//------------------------------------------------------------------------------

function gf_GetReportDecTail(pTrCode: Integer; pStlDate: string): string;
var
  sTailStr: string;
begin
  if not gvUseDecLine then // 결재라인 사용 안함
  begin
    Result := '';
    Exit;
  end;

  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' select t.DEC_LEVEL, l.DEC_NAME, '
      + '        OPR_ID = ISNull(a.OPR_ID, ''''), '
      + '        OPR_NAME = (select u.USER_NAME '
      + '                    from SUUSER_TBL u '
      + '                    where u.USER_ID = a.OPR_ID) '
      + ' from  SUTRDEC_TBL t, SUDAILD_TBL a, SUDECLN_TBL l '
      + ' where t.DEPT_CODE = ''' + gvDeptCode + ''' '
      + '     and t.TR_CODE = ''' + IntToStr(pTrCode) + ''' '
      + '     and t.DEPT_CODE *= a.DEPT_CODE '
      + '     and t.TR_CODE *= a.TR_CODE '
      + '     and t.DEC_LEVEL *= a.DEC_LEVEL '
      + '     and a.STL_DATE = ''' + pStlDate + ''' '
      + '     and l.DEPT_CODE = t.DEPT_CODE '
      + '     and l.DEC_LEVEL = t.DEC_LEVEL '
      + ' order by t.DEC_LEVEL');
    gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

    sTailStr := '';
    while not Eof do
    begin
      sTailStr := sTailStr + FieldByName('DEC_NAME').asString + ' : ' +
        FieldByName('OPR_NAME').asString + '     ';
      Next
    end; // end of while
  end; // end of with
  Result := sTailStr;
end;

//------------------------------------------------------------------------------
// 선행 TR의 결재 완료 확인 : 결재완료 -> True, 결재미완료 -> False
//------------------------------------------------------------------------------

function gf_CheckPreTRProcess(pTrCode: Integer; pStlDate: string;
  var pMsg: string): boolean;
var
  bConfirmed: boolean;
  sQueryStr: string;
begin
  pMsg := ''; // Clear;
  if not gvUseDecLine then // 결재라인 사용 안함
  begin
    Result := True;
    Exit;
  end;

  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
{$IFDEF SETTLENET_A} // 회계
    sQueryStr := ' select r.REF_TR_CODE,  m.MENU_NAME_KOR, '
      + '        t.DEC_LEVEL, l.DEC_NAME,  t.MAIN_OPR_ID, '
      + '        OPR_ID = ISNull(a.OPR_ID, '''') '
      + ' from SCREFTR_TBL r, SUTRDEC_TBL t,  SUDAILD_TBL a, '
      + '      SUDECLN_TBL l, SAMENU_TBL m '
      + ' where r.REF_TYPE = ''P'' '
      + '    and r.TR_CODE = ''' + IntToStr(pTrCode) + ''' '
      + '    and t.DEPT_CODE = ''' + gvDeptCode + ''' '
      + '    and t.TR_CODE = r.REF_TR_CODE '
      + '    and t.DEPT_CODE *= a.DEPT_CODE '
      + '    and t.TR_CODE *= a.TR_CODE '
      + '    and t.DEC_LEVEL *= a.DEC_LEVEL '
      + '    and a.STL_DATE = ''' + pStlDate + ''' '
      + '    and l.DEPT_CODE = t.DEPT_CODE '
      + '    and l.DEC_LEVEL = t.DEC_LEVEL '
      + '    and m.ROLE_CODE = ''' + gvRoleCode + ''' '
      + '    and m.SEC_CODE = ''' + gvCurSecType + ''' '
      + '    and m.TR_CODE = r.REF_TR_CODE '
      + '    and l.DEC_LEVEL < 8           ' //9.viewer라는 예외사항있음.
      + ' order by r.REF_TR_CODE, t.DEC_LEVEL ';
{$ELSE} // SettleNet
    sQueryStr := ' select r.REF_TR_CODE,  m.MENU_NAME_KOR, '
      + '        t.DEC_LEVEL, l.DEC_NAME,  t.MAIN_OPR_ID, '
      + '        OPR_ID = ISNull(a.OPR_ID, '''') '
      + ' from SCREFTR_TBL r, SUTRDEC_TBL t,  SUDAILD_TBL a, '
      + '      SUDECLN_TBL l, SUMENU_TBL m '
      + ' where r.REF_TYPE = ''P'' '
      + '    and r.TR_CODE = ''' + IntToStr(pTrCode) + ''' '
      + '    and t.DEPT_CODE = ''' + gvDeptCode + ''' '
      + '    and t.TR_CODE = r.REF_TR_CODE '
      + '    and t.DEPT_CODE *= a.DEPT_CODE '
      + '    and t.TR_CODE *= a.TR_CODE '
      + '    and t.DEC_LEVEL *= a.DEC_LEVEL '
      + '    and a.STL_DATE = ''' + pStlDate + ''' '
      + '    and l.DEPT_CODE = t.DEPT_CODE '
      + '    and l.DEC_LEVEL = t.DEC_LEVEL '
      + '    and m.ROLE_CODE = ''' + gvRoleCode + ''' '
      + '    and m.SEC_CODE = ''' + gvCurSecType + ''' '
      + '    and m.TR_CODE = r.REF_TR_CODE '
      + '    and l.DEC_LEVEL < 8           ' //9.viewer라는 예외사항있음.
      + ' order by r.REF_TR_CODE, t.DEC_LEVEL ';
{$ENDIF}
    SQL.Add(sQueryStr);
    gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

    bConfirmed := True;
    while not Eof do
    begin
      if Trim(FieldByName('OPR_ID').asString) = '' then // 미결재 내역 존재
      begin
        bConfirmed := False;
        pMsg := pMsg +
          '[' + Trim(FieldByName('REF_TR_CODE').asString) + '] ' +
          Trim(FieldByName('MENU_NAME_KOR').asString) + ': ' +
          Trim(FieldByName('DEC_NAME').asString) + Chr(13);
      end;
      Next;
    end; // end of while

    if not bConfirmed then // 미결재 내역 존재시
      pMsg := pMsg + Chr(13) +
        '선행 결재가 처리되지 않았으므로 해당 작업을 진행할 수 없습니다.';
    Result := bConfirmed;
  end; // end of with
end;

//------------------------------------------------------------------------------
//후행 TR의 결재 진행 여부 확인 : 결재진행중 -> True, 결재미진행 -> False
//------------------------------------------------------------------------------

function gf_CheckAfterTRProcess(pTrCode: Integer; pStlDate: string;
  var pMsg: string; iDecLevel: integer): boolean;
var
  sQueryStr: string;
begin
  pMsg := ''; // Clear;
  if not gvUseDecLine then // 결재라인 사용 안함
  begin
    Result := False;
    Exit;
  end;

  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
{$IFDEF SETTLENET_A} // 회계
    sQueryStr := ' select r.REF_TR_CODE,  m.MENU_NAME_KOR, '
      + '        t.DEC_LEVEL, l.DEC_NAME,  t.MAIN_OPR_ID, '
      + '        OPR_ID = ISNull(a.OPR_ID, '''') '
      + ' from SCREFTR_TBL r, SUTRDEC_TBL t,  SUDAILD_TBL a, '
      + '      SUDECLN_TBL l, SAMENU_TBL m '
      + ' where r.REF_TYPE = ''C'' '
      + '    and r.TR_CODE = ''' + IntToStr(pTrCode) + ''' '
      + '    and t.DEPT_CODE = ''' + gvDeptCode + ''' '
      + '    and t.TR_CODE = r.REF_TR_CODE '
      + '    and t.DEPT_CODE = a.DEPT_CODE '
      + '    and t.TR_CODE = a.TR_CODE '
      + '    and t.DEC_LEVEL = a.DEC_LEVEL '
      + '    and a.STL_DATE = ''' + pStlDate + ''' '
      + '    and l.DEPT_CODE = t.DEPT_CODE '
      + '    and l.DEC_LEVEL = t.DEC_LEVEL '
      + '    and m.ROLE_CODE = ''' + gvRoleCode + ''' '
      + '    and m.SEC_CODE = ''' + gvCurSecType + ''' '
      + '    and m.TR_CODE = r.REF_TR_CODE '
      + '    and l.DEC_LEVEL < 8           ' //9.viewer라는 예외사항있음.
      + ' order by r.REF_TR_CODE, t.DEC_LEVEL ';
{$ELSE} // SettleNet
    sQueryStr := ' select r.REF_TR_CODE,  m.MENU_NAME_KOR, '
      + '        t.DEC_LEVEL, l.DEC_NAME,  t.MAIN_OPR_ID, '
      + '        OPR_ID = ISNull(a.OPR_ID, '''') '
      + ' from SCREFTR_TBL r, SUTRDEC_TBL t,  SUDAILD_TBL a, '
      + '      SUDECLN_TBL l, SUMENU_TBL m '
      + ' where r.REF_TYPE = ''C'' '
      + '    and r.TR_CODE = ''' + IntToStr(pTrCode) + ''' '
      + '    and t.DEPT_CODE = ''' + gvDeptCode + ''' '
      + '    and t.TR_CODE = r.REF_TR_CODE '
      + '    and t.DEPT_CODE = a.DEPT_CODE '
      + '    and t.TR_CODE = a.TR_CODE '
      + '    and t.DEC_LEVEL = a.DEC_LEVEL '
      + '    and a.STL_DATE = ''' + pStlDate + ''' '
      + '    and l.DEPT_CODE = t.DEPT_CODE '
      + '    and l.DEC_LEVEL = t.DEC_LEVEL '
      + '    and m.ROLE_CODE = ''' + gvRoleCode + ''' '
      + '    and m.SEC_CODE = ''' + gvCurSecType + ''' '
      + '    and m.TR_CODE = r.REF_TR_CODE '
      + '    and l.DEC_LEVEL < 8           ' //9.viewer라는 예외사항있음.
      + ' order by r.REF_TR_CODE, t.DEC_LEVEL ';
{$ENDIF}
    SQL.Add(sQueryStr);
    gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

    if RecordCount = 0 then // 후행 TR의 처리된 결재 내역 없음
      Result := False
    else // 후행 TR의 처리된 결재 내역 있음
    begin
      Result := True;
      pMsg := '실행할 수 없습니다.' + Char(13) + Char(13);
      while not Eof do
      begin
        pMsg := pMsg +
          '[' + Trim(FieldByName('REF_TR_CODE').asString) + '] ' +
          Trim(FieldByName('MENU_NAME_KOR').asString) + ': ' +
          Trim(FieldByName('DEC_NAME').asString) + Chr(13);
        Next;
      end;
      pMsg := pMsg + Chr(13) +
                 //'처리된 결재 내역이 취소됩니다. 진행하시겠습니까? ';
      '위의 결재 사항을 취소하셔야 합니다.';
    end;
  end; // end of with
end;


//------------------------------------------------------------------------------
//결재라인 취소하냐?
//------------------------------------------------------------------------------

function gf_CanCancelDecLine(pTrCode: Integer; pStlDate: string; pDecLevel: integer;
  var pMsg: string): boolean;
var
  sQueryStr: string;
begin
  pMsg := ''; // Clear;
  if not gvUseDecLine then // 결재라인 사용 안함
  begin
    Result := False;
    Exit;
  end;

  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
{$IFDEF SETTLENET_A} // 회계
    sQueryStr := ' select r.REF_TR_CODE,  m.MENU_NAME_KOR, '
      + '        t.DEC_LEVEL, l.DEC_NAME,  t.MAIN_OPR_ID, '
      + '        OPR_ID = ISNull(a.OPR_ID, '''') '
      + ' from SCREFTR_TBL r, SUTRDEC_TBL t,  SUDAILD_TBL a, '
      + '      SUDECLN_TBL l, SAMENU_TBL m '
      + ' where r.REF_TYPE = ''C'' '
      + '    and r.TR_CODE = ''' + IntToStr(pTrCode) + ''' '
      + '    and t.DEPT_CODE = ''' + gvDeptCode + ''' '
      + '    and t.TR_CODE = r.REF_TR_CODE '
      + '    and t.DEPT_CODE = a.DEPT_CODE '
      + '    and t.TR_CODE = a.TR_CODE '
      + '    and t.DEC_LEVEL = a.DEC_LEVEL '
      + '    and a.STL_DATE = ''' + pStlDate + ''' '
      + '    and l.DEPT_CODE = t.DEPT_CODE '
      + '    and l.DEC_LEVEL = t.DEC_LEVEL '
      + '    and m.ROLE_CODE = ''' + gvRoleCode + ''' '
      + '    and m.SEC_CODE = ''' + gvCurSecType + ''' '
      + '    and m.TR_CODE = r.REF_TR_CODE '
      + '    and ( ((r.REF_TR_CODE = r.TR_CODE) and (a.DEC_LEVEL > ' + IntToStr(pDecLevel) + ')) '
      + '        or((r.REF_TR_CODE <> r.TR_CODE)) '
      + '        ) '
      + '    and l.DEC_LEVEL < 8           ' //9.viewer라는 예외사항있음.
      + ' order by r.REF_TR_CODE, t.DEC_LEVEL ';
{$ELSE} // SettleNet
    sQueryStr := ' select r.REF_TR_CODE,  m.MENU_NAME_KOR, '
      + '        t.DEC_LEVEL, l.DEC_NAME,  t.MAIN_OPR_ID, '
      + '        OPR_ID = ISNull(a.OPR_ID, '''') '
      + ' from SCREFTR_TBL r, SUTRDEC_TBL t,  SUDAILD_TBL a, '
      + '      SUDECLN_TBL l, SUMENU_TBL m '
      + ' where r.REF_TYPE = ''C'' '
      + '    and r.TR_CODE = ''' + IntToStr(pTrCode) + ''' '
      + '    and t.DEPT_CODE = ''' + gvDeptCode + ''' '
      + '    and t.TR_CODE = r.REF_TR_CODE '
      + '    and t.DEPT_CODE = a.DEPT_CODE '
      + '    and t.TR_CODE = a.TR_CODE '
      + '    and t.DEC_LEVEL = a.DEC_LEVEL '
      + '    and a.STL_DATE = ''' + pStlDate + ''' '
      + '    and l.DEPT_CODE = t.DEPT_CODE '
      + '    and l.DEC_LEVEL = t.DEC_LEVEL '
      + '    and m.ROLE_CODE = ''' + gvRoleCode + ''' '
      + '    and m.SEC_CODE = ''' + gvCurSecType + ''' '
      + '    and m.TR_CODE = r.REF_TR_CODE '
      + '    and ( ((r.REF_TR_CODE = r.TR_CODE) and (a.DEC_LEVEL > ' + IntToStr(pDecLevel) + ')) '
      + '        or((r.REF_TR_CODE <> r.TR_CODE)) '
      + '        ) '
      + '    and l.DEC_LEVEL < 8           ' //9.viewer라는 예외사항있음.
      + ' order by r.REF_TR_CODE, t.DEC_LEVEL ';
{$ENDIF}
    SQL.Add(sQueryStr);
    gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

    if RecordCount = 0 then // 후행 TR의 처리된 결재 내역 없음
      Result := False
    else // 후행 TR의 처리된 결재 내역 있음
    begin
      Result := True;
      pMsg := '취소할 수 없습니다.' + Char(13) + Char(13);
      while not Eof do
      begin
        pMsg := pMsg +
          '[' + Trim(FieldByName('REF_TR_CODE').asString) + '] ' +
          Trim(FieldByName('MENU_NAME_KOR').asString) + ': ' +
          Trim(FieldByName('DEC_NAME').asString) + Chr(13);
        Next;
      end;
      pMsg := pMsg + Chr(13) +
                 //'처리된 결재 내역이 취소됩니다. 진행하시겠습니까? ';
      '위의 결재 사항을 먼저 취소하셔야 합니다.';
    end;
  end; // end of with
end;

//------------------------------------------------------------------------------
// 후행 TR의 결재 내역 Clear : Clear 성공 -> True, Clear 실패 -> False
//------------------------------------------------------------------------------

function gf_ClearAfterTRProcess(pTrCode: Integer; pStlDate: string): Integer;
begin
  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' delete SUDAILD_TBL '
      + ' from  SCREFTR_TBL r '
      + ' where r.REF_TYPE = ''C'' '
      + '   and r.TR_CODE = ''' + IntToStr(pTrCode) + ''' '
      + '   and SUDAILD_TBL.DEPT_CODE = ''' + gvDeptCode + ''' '
      + '   and SUDAILD_TBL.STL_DATE = ''' + pStlDate + ''' '
      + '   and SUDAILD_TBL.TR_CODE = r.REF_TR_CODE   ');
    gf_ADOExecSQL(DataModule_SettleNet.ADOQuery_Main);
    Result := RowsAffected;
  end; // end of with
end;


//------------------------------------------------------------------------------
// SUSYOPT_TBL에서 시스템 옵션 읽어오기
//------------------------------------------------------------------------------

function gf_GetSystemOptionValue(pOptCode, pDefaultValue: string): string;
var
  sQueryStr: string;
begin

  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    sQueryStr := ' select OPT_VALUE '
      + ' from   SUSYOPT_TBL '
      + ' where  OPT_CODE = ''' + pOptCode + ''' ';
    SQL.Add(sQueryStr);
    gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

    if RecordCount = 0 then
      Result := pDefaultValue
    else
      Result := Trim(FieldByName('OPT_VALUE').asString);
  end; // end of with
end;

function gf_GetSystemOptionInfo(pOptCode, pOptValue: string): string;
var
  sQueryStr: string;
  TempString : string;
begin

  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    sQueryStr := ' select INFO '
      + ' from   SUSYOPT_TBL '
      + ' where  OPT_CODE = ''' + pOptCode + ''' '
      + ' and    OPT_VALUE = ''' + pOptValue + ''' '      ;
    SQL.Add(sQueryStr);
    gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

    if RecordCount = 0 then
    begin
      exit;
    end else
    begin
      TempString := Trim(FieldByName('INFO').asString);
      TempString := Trim(Copy(TempString, Pos(';', TempString) + 1, Length(TempString)));
      Result := TempString;
    end;
  end; // end of with
end;


//도스 환경변수 가져오기

function GetDosEnv(Value: string): string;
var
  P: PChar;
  S: string;
  E: string;
begin
  Result := '';
  P := GetEnvironmentStrings;
  while P[0] <> #0 do
  begin
    S := StrPas(P);
    E := S;
    S := Copy(UpperCase(S), 1, Length(Value) + 1);
    if S = UpperCase(Value + '=') then
      Result := Copy(E, Length(Value) + 2, Length(E));
    P := StrEnd(P) + 1;
  end;
end;

//기본Printer를 PDF Printer로
//기존 gvPrinter를 백업후 gvPriner에 PDF Printer로!

function gf_DefPrinter2PDFPrinter: boolean;
var i: integer;
begin
  Result := false;
  for i := 0 to Printer.Printers.Count - 1 do
  begin
    if pos(gcPDFPrinterName, UpperCase(Printer.Printers.Strings[i])) > 0 then
    begin
      gvOldPrinter.PrinterIdx := gvPrinter.PrinterIdx;
      gvOldPrinter.PrinterName := gvPrinter.PrinterName;
      gvOldPrinter.Copies := gvPrinter.Copies;
      gvOldPrinter.Orientation := gvPrinter.Orientation;
      Printer.PrinterIndex := i;
      gvPrinter.PrinterIdx := i;
      gvPrinter.PrinterName := Printer.Printers.Strings[i];
      gvPrinter.Copies := 1;
      gvPrinter.Orientation := poPortrait;
      Result := true;
      Exit;
    end;
  end;

  gf_ShowErrDlgMessage(0, 0, 'PDF Converter용 Printer가 설치되어 있지 않습니다.', 0);
end;

//PDF Printer에서 기본Printer로

function gf_PDFPrinter2DefPrinter: boolean;
begin
  Result := true;
  gvPrinter.PrinterIdx := gvOldPrinter.PrinterIdx;
  gvPrinter.PrinterName := gvOldPrinter.PrinterName;
  gvPrinter.Copies := gvOldPrinter.Copies;
  gvPrinter.Orientation := gvOldPrinter.Orientation;
  Printer.PrinterIndex := gvPrinter.PrinterIdx;
end;

//----------------------------------------------------------------------------
//  gfEncryption : 암호화
//----------------------------------------------------------------------------
//function gfEncryption(char* i_password, char* o_password): Integer;

function gfEncryption(i_password, i_HashEncYN: string; var o_Shortpassword: string): string;
const
  k: array[0..15] of Integer = (10, 2, 4, 11, 12, 3, 14, 13, 9, 1, 15, 6, 16, 7, 5, 8);
  PASSWD_SALT = '$eTT1eNeT'; // 암호화에 사용될 난수
var
  i, j: Integer;
  arandom: array[0..82] of Char;
  apswd: array[0..15] of Char;
  ahexa: array[0..15] of Char;
  apassword: array[0..30] of Char;

  Cipher: TDCP_rijndael;
  o_password: string;

  DCP_SHA256: TDCP_sha256;
  HashDigest: array of byte;
begin

  o_Shortpassword := '';

  if i_HashEncYN = 'Y' then
  begin

    try
      DCP_SHA256 := TDCP_sha256.Create(nil);
      DCP_SHA256.Init;
      DCP_SHA256.UpdateStr(i_password + PASSWD_SALT);

      SetLength(HashDigest, DCP_sha256.HashSize div 8);
      DCP_sha256.Final(HashDigest[0]);

      for i := 0 to Length(HashDigest) - 1 do
      begin
        o_Shortpassword := o_Shortpassword + IntToHex(HashDigest[i], 2);
      end;

      Result := o_Shortpassword;

    finally
      DCP_SHA256.Free;
    end;

    Exit;
  end else
  if i_HashEncYN = 'O' then
  begin

    Cipher := TDCP_rijndael.Create(nil);
    Cipher.InitStr(gcInEnKey, TDCP_md5);
    o_password := Cipher.EncryptString(i_password);

    for i := 1 to Length(o_password) do
    begin
      if (i mod 2) <> 0 then
        o_Shortpassword := o_Shortpassword + o_password[i];
    end;

    result := o_password;

    Cipher.Burn;
    Cipher.Free;

    Exit;
  end;

  FillChar(apassword, SizeOf(apassword), 0);
  FillChar(ahexa, SizeOf(ahexa), 0);
  FillChar(arandom, SizeOf(arandom), 0);

  StrPCopy(apassword, i_password);
  FillChar(apswd, SizeOf(apswd), 0);
  arandom := 'BDYFZGLC89HRTWwxyA5EIKMpqO6VNstuvzPnfeQ4bcJSUX0g12hij37adkolmr+[%,(-~!{)}]?.<@#^&*$';

  for i := 0 to StrLen(apassword) - 1 do
  begin
    for j := 0 to Length(arandom) - 1 do
    begin
      if (apassword[i] = arandom[j]) then
      begin
        if j + Ord(k[i]) > 82 then
          ahexa[i] := Char(j + Ord(k[i]) - 83)
        else
          ahexa[i] := Char(j + Ord(k[i]));

        //ahexa[i] := Char(j + Ord(k[i]));
        break;
      end;
    end;
  end;

  for i := 0 to StrLen(apassword) - 1 do
    apswd[i] := arandom[Ord(ahexa[i])];

  o_Shortpassword := StrPas(apswd);    
  Result := StrPas(apswd);
end;

//----------------------------------------------------------------------------
//  gfDecryption : 복호화
//----------------------------------------------------------------------------

function gfDecryption(i_password, i_HashEncYN: string): string;
const
  k: array[0..15] of Integer = (10, 2, 4, 11, 12, 3, 14, 13, 9, 1, 15, 6, 16, 7, 5, 8);
var
  i, j: Integer;
  arandom: array[0..83] of Char; //82
  apswd: array[0..15] of Char;
  ahexa: array[0..15] of Char;
  apassword: array[0..30] of Char;

  Cipher: TDCP_rijndael;
  o_password, strtmp: string;  
begin

  if i_HashEncYN = 'Y' then
  begin
    Cipher := TDCP_rijndael.Create(nil);
    Cipher.InitStr(gcInEnKey, TDCP_md5);
    o_password := Cipher.DecryptString(i_password);

    result := o_password;

    Cipher.Burn;
    Cipher.Free;
    Exit;
  end;

  FillChar(apassword, SizeOf(apassword), 0);
  FillChar(ahexa, SizeOf(ahexa), 0);
  FillChar(arandom, SizeOf(arandom), 0);

  StrPCopy(apassword, i_password);
  FillChar(apswd, SizeOf(apswd), 0);
  arandom := 'BDYFZGLC89HRTWwxyA5EIKMpqO6VNstuvzPnfeQ4bcJSUX0g12hij37adkolmr+[%,(-~!{)}]?.<@#^&*$';

  for i := 0 to StrLen(apassword) - 1 do //
  begin
    for j := 0 to StrLen(arandom) - 1 do //
    begin
      if (apassword[i] = arandom[j]) then
      begin
        if j - Ord(k[i]) < 0 then
          ahexa[i] := Char(j - Ord(k[i]) + 83)
        else
          ahexa[i] := Char(j - Ord(k[i]));
        //ahexa[i] := Char(j - Ord(k[i]));
        break;
      end;
    end
  end;

  for i := 0 to StrLen(apassword) - 1 do
    apswd[i] := arandom[Ord(ahexa[i])];

  Result := StrPas(apswd);
end;

//------------------------------------------------------------------------------
// 계좌 검색
//------------------------------------------------------------------------------

function gf_ShowAccNoSearch(pSecType, pAccNo, pAccName: string): Integer;
begin
  if pSecType = 'E' then
  begin
    Application.CreateForm(TForm_SCFH2106_MD, Form_SCFH2106_MD);

     // Set In Data
    Form_SCFH2106_MD.InSecType := pSecType;
    Form_SCFH2106_MD.InAccNo := pAccNo;
    Form_SCFH2106_MD.InAccName := pAccName;

    Result := Form_SCFH2106_MD.ShowModal; // Assign Return Value
  end
  else //F
  begin
    Application.CreateForm(TForm_SCFH3106_MD, Form_SCFH3106_MD);

     // Set In Data
    Form_SCFH3106_MD.InSecType := pSecType;
    Form_SCFH3106_MD.InAccNo := pAccNo;
    Form_SCFH3106_MD.InAccName := pAccName;

    Result := Form_SCFH3106_MD.ShowModal; // Assign Return Value
  end;

end;

function gf_CountQuery(pSQL: string): integer;
begin
  Result := 0;
  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    SQL.Add(pSQL);
    gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
    if RecordCount > 0 then
      Result := FieldByName('CNT').asInteger;
  end;
end;

function gf_ReturnStrQuery(pSQL: string): string;
begin
  Result := '';
  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    SQL.Add(pSQL);
    gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
    if RecordCount > 0 then
      Result := Trim(FieldByName('STR').AsString);
  end;
end;

function IsCloseTradeDate(sTradeDate: string): boolean;
begin
  Result := false;

  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;

    SQL.Add(' select            '
      + '   CLOSE_DATE = ISNULL(MAX(CLOSE_DATE),'''')   '
      + ' from  SUCLOSE_TBL      '
      + ' where CLOSE_DATE = ''' + sTradeDate + ''' ' //추후  > 추가할 것
      + ' and   DEPT_CODE  = ''' + gvDeptCode + ''' '
      + ' and   TRD_CLOSE_YN = ''Y'' '
      );

    try
      gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
    except
      on E: Exception do
      begin
        gf_ShowErrDlgMessage(0, 9001, 'ADOQuery_Main[Query]: ' + E.Message, 0); // Database 오류
//            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Main[Query]'); //Database 오류
        Exit;
      end;
    end;

    if RecordCount > 0 then
    begin
      First;
      if Trim(FieldByName('CLOSE_DATE').asString) > '' then
      begin
        Result := true;
        Exit;
      end;
    end;
    Close;
  end; //with
end;

function gf_FindRowInGrid(pStrGrid: TDRStringGrid; iCol: integer; sKey: string): integer;
var i: integer;
begin
  Result := -1;
  with pStrGrid do
  begin
    if RowCount <= 1 then Exit;
    for i := 1 to RowCount - 1 do
    begin
      if Cells[iCol, i] = sKey then
      begin
        Result := i;
        Exit;
      end;
    end;
  end;
end;

function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;

function InputQueryDRDateEdit(const ACaption, APrompt, APrompt2: string;
  var Value: string): Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Prompt2: TLabel;
  Edit: TDRMaskEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
begin
  Result := False;
  Form := TForm.Create(Application);
  with Form do
  try
    Canvas.Font := Font;
    DialogUnits := GetAveCharSize(Canvas);
    BorderStyle := bsDialog;
    Caption := ACaption;
    ClientWidth := MulDiv(180, DialogUnits.X, 4);
    ClientHeight := MulDiv(63, DialogUnits.Y, 8);
    Position := poScreenCenter;
    Prompt := TDRLabel.Create(Form);
    Prompt2 := TDRLabel.Create(Form);
    with Prompt do
    begin
      Parent := Form;
      AutoSize := True;
      Left := MulDiv(8, DialogUnits.X, 4);
      Top := MulDiv(8, DialogUnits.Y, 8);
      Caption := APrompt;
    end;
    with Prompt2 do
    begin
      Parent := Form;
      AutoSize := True;
      Left := Prompt.Left;
      Top := Prompt.Top + Prompt.Height + 10;
      Caption := APrompt2;
    end;
    Edit := TDRMaskEdit.Create(Form);
    with Edit do
    begin
      Parent := Form;
      Left := Prompt2.Left + Prompt2.Width + 10;
      Top := Prompt2.Top - 2; //MulDiv(19, DialogUnits.Y, 8);
//        Width := MulDiv(164, DialogUnits.X, 4);
      MaxLength := 10; //@@
      Text := Value;
      width := 73;
      EditMask := '9999-99-99;0; '; //@@
      SelectAll;
    end;
    ButtonTop := MulDiv(41, DialogUnits.Y, 8);
    ButtonWidth := MulDiv(50, DialogUnits.X, 4);
    ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
    with TDRButton.Create(Form) do
    begin
      Parent := Form;
      Caption := '확인';
      ModalResult := mrOk;
      Default := True;
      SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
        ButtonHeight);
    end;
    with TDRButton.Create(Form) do
    begin
      Parent := Form;
      Caption := '취소';
      ModalResult := mrCancel;
      Cancel := True;
      SetBounds(MulDiv(92, DialogUnits.X, 4), ButtonTop, ButtonWidth,
        ButtonHeight);
    end;
    if ShowModal = mrOk then
    begin
      Value := Edit.Text;
      Result := True;
    end;
  finally
    Form.Free;
  end;
end;

//version exe, dll upgrade하기
//Result > '' Pgm Restart 사유 else 계속 진행

function gf_VersionSync(pQuery: TADOQuery; pExtGB: string; pPanel: TDRPanel): string;
//-------------------------------------------------------------------------------------
// 버전관리 대폭 변경 FileAge 체크후 Age가 변한 파일만 버전체크 -버전체크가 느려서
// 예전버전도 Age체크 후 버전 체크 했었음 전버전은 INI로 체크함
// 이번버전은 DB 파일에서 직접 체크
// 파일생성날짜로 미리 체크를 하므로 속도 개선이 됨. 파일이 복사되더라도
// 파일생성날짜는 같은 파일이라면 무조건 같으므로 INI처리 필요없음
//-------------------------------------------------------------------------------------
type
  TFiles = record
    FileName: string;
    Version: string;
    Action: string;
    FileAge: integer;
    MailFormID: string;
    MailFormName: string;
    MailHelpText: string;
  end;
  pTFiles = ^TFiles;
var sVersion, sSyncVersion, sMsg: string;
  iSyncAge: Integer;
  StFiles: TList;
  sr: TSearchRec;
  sMailFormID, sDBFVersion, sDBFName, sSyncFileName, sFilePath: string;
  iDBFAge: Integer;

  FilesItem, tempFilesItem: pTFiles;
  I, J, iCur, iTot: integer;
  SMailForm, sOriMsg: string;
  FileVerIni: TIniFile;
  FileStringList: TStringList;
  MsgOpen: Boolean;
  sDllFormName : String;
  bAddDllForm : Boolean;
//Result = '' 성공, else ERROR
  function UploadToDB(sPath, sFileName, sMode, sVersion: string; iAge: integer): string;
  var
    SDate, STime: string;
    sTmpFileName: string;
  begin
    Result := '';
    SDate := FormatDateTime('YYYYMMDD', now);
    Stime := FormatDateTime('hhmm', now);
    sFileName := UpperCase(sFileName);
    with pQuery do
    begin
      Close;
      SQL.Clear;
      if sMode = 'I' then
      begin
        SQL.Add(' if exists ( select ''1'' from SCPRVER_TBL where F_NAME = ''' + sFileName + ''' ) '
          + ' begin ' + #13#10 + #13#10
          + '   DELETE FROM SCPRVER_TBL '
          + '   WHERE F_NAME = ''' + sFileName + ''' ' + #13#10 + #13#10
          + ' end ');
        SQL.Add(' INSERT INTO SCPRVER_TBL ( F_VERSION, F_AGE,  F_NAME, F_DATA, OPR_ID, OPR_DATE, OPR_TIME ) '
          + ' VALUES ( ''' + sVersion + ''', '
          + '         ' + inttostr(iAge) + ',    '
          + '          ''' + sFileName + ''', '
          + '          :pF_Data , '
          + '          ''' + gvOprUsrNo + ''', '
          + '          '''', '
          + '          '''') ');

      end
      else if sMode = 'U' then
      begin
        SQL.Add(' UPDATE SCPRVER_TBL '
          + ' SET    F_VERSION = ''' + sVersion + ''', '
          + '        F_AGE     = ' + inttostr(iAge) + '  , '
          + '        F_DATA    = :pF_Data, '
          + '       OPR_ID    = ''' + gvOprUsrNo + ''', '
          + '       OPR_DATE  = '''', '
          + '       OPR_TIME  = ''''  '
          + ' WHERE  F_NAME    = ''' + sFileName + ''' ');
      end
      else if sMode = 'A' then
      begin
        SQL.Add(' UPDATE SCPRVER_TBL '
          + ' SET    F_AGE     = ' + inttostr(iAge) + '  , '
          + '       OPR_ID    = ''' + gvOprUsrNo + ''', '
          + '       OPR_DATE  = '''', '
          + '       OPR_TIME  = ''''  '
          + ' WHERE  F_NAME    = ''' + sFileName + ''' ');
      end;

      try
        if sMode <> 'A' then
        begin
          // [Y.K.J] 2016.10.24
          // 간혹 해당 파일이 사용중이여서 엑세스 할수 없다는 에러가 발생한다.
          // 그럴 경우 해당 파일의 복사본을 만들어서 올리는 처리를 한다.
          if gf_IsFileInUse(sPath + sFileName) then
          begin
            gf_Log('[VersionSync] [Upload] Warning!! File Used. ('+ sFileName +')');

            gf_Log('[VersionSync] [Upload] Clone File Process Start.');
            sTmpFileName := ChangeFileExt(sFileName, '.tmp');
            if CopyFile(pchar(sPath + sFileName), pchar(sPath + sTmpFileName), false) then
            begin
              Parameters.ParamByName('pF_Data').LoadFromFile(sPath + sTmpFileName, ftBlob);

              if not DeleteFile(sPath + sTmpFileName) then
                gf_Log('[VersionSync] [Upload] Clone File Delete Failed. ('+ sTmpFileName +')');
              gf_Log('[VersionSync] [Upload] Clone File Process Success.');
            end else
            begin
              gf_Log('[VersionSync] [Upload] Clone File Process Fail.');
            end;
          end else
          begin
            Parameters.ParamByName('pF_Data').LoadFromFile(sPath + sFileName, ftBlob);
          end;
        end;
        gf_ADOExecSQL(pQuery);
      except
        on E: Exception do
        begin
          gf_Log('[VersionSync] [Upload] Error. ' + E.Message);
          Result := '[VersionSync] [Upload] Error. ' + E.Message;
        end;
      end;
    end;
  end;

//Result = '' 성공, else ERROR
  function DownloadFromDB(sPath, sFileName: string): string;
  var sOldVersionName: string;
    FileAttributes: Word;

  begin
    Result := '';
    with pQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add(' SELECT F_DATA FROM SCPRVER_TBL '
        + ' WHERE  F_NAME    = ''' + sFileName + ''' ');
      try
        gf_ADOQueryOpen(pQuery);
      except
        on E: Exception do
        begin
          gf_ShowErrDlgMessage(0, 9001,
            'Download :' + E.Message, 0); // Database 오류
          Result := 'DownLoad Error!';
          Exit;
        end;
      end;

      sOldVersionName := sFileName;
      sOldVersionName := ChangeFileExt(sPath + sFileName, '.old');
      if FileExists(sOldVersionName) then // LMS
      begin
        FileAttributes := FileGetAttr(sOldVersionName);
        if (FileAttributes and SysUtils.faReadOnly) = SysUtils.faReadOnly then
        begin
          FileAttributes := FileAttributes and not SysUtils.faReadOnly;
          FileSetAttr(sOldVersionName, FileAttributes);
        end;
        if not DeleteFile(sOldVersionName) then
        begin
          gf_ShowErrDlgMessage(0, 0, 'annot Delete Old File!:' + sOldVersionName, 0);
          Result := 'Cannot Delete Old File!';
          Exit;
        end;
      end;

      if FileExists(sPath + sFileName) then RenameFile(sPath + sFileName, sOldVersionName); //file이 없을 수도 있다.

      if RecordCount > 0 then
      begin
        try
          // 해당파일이 아무 내용이 없을경우 만들지 않음
          if Trim(FieldByName('F_DATA').AsString) <> '' then
            TBlobField(FieldByName('F_DATA')).SaveToFile(sPath + sFileName);
        except
          on E: Exception do
          begin
            RenameFile(sOldVersionName, sPath + sFileName); //원상복귀
            gf_ShowErrDlgMessage(0, 0, 'SaveToFile Error:' + E.Message, 0);
            Result := 'DownLoad Error!1';
            Exit;
          end;
        end;


      end
      else
      {begin //발생안함
        gf_ShowErrDlgMessage(0, 9001,
          'Download : 대상자료 없음', 0); // Database 오류
        Result := 'DownLoad Error!2'; //Database 오류
        Exit;
      end;}
    end;
    Result := '';
  end;

  function findDllFilesbyName(sFileName: string): integer;
  var i: integer;
    FilesItem: pTFiles;
  begin
    Result := -1;
    for i := 0 to StFiles.Count - 1 do
    begin
      FilesItem := StFiles.Items[i];
      if FilesItem.FileName = sFileName then
      begin
        Result := i;
        Exit;
      end;
    end;
  end;


begin
  Result := '';
  sMsg := '';
  sOriMsg := pPanel.Caption;
  try

    if pExtGB = 'EXE' then //1.EXE Download
    begin
      pPanel.Caption := sOriMsg + ' EXE';
      pPanel.Repaint;
      sFilePath := ExtractFilePath(Application.ExeName);
      sSyncFileName := uppercase(ExtractFileName(Application.ExeName));
      with pQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT F_AGE , F_VERSION    '
          + ' FROM SCPRVER_TBL WHERE upper(F_NAME) = ''' + sSyncFileName + ''' ');
        try
          gf_ADOQueryOpen(pQuery);
        except
          on E: Exception do
          begin
            gf_ShowErrDlgMessage(0, 0, 'Version Check:' + E.Message, 0);
            Result := 'Select SCPRVER Error!';
            Exit;
          end;
        end;

        if RecordCount <= 0 then //없음 관리 안함.. 끝
        begin
            // 버전 관리 하자
            // 자기자신도 없으면 업데이트 안함.
          Screen.Cursor := crDefault;
          Exit;
            { sMsg := UploadToDB(sFilePath, sSyncFileName, 'I', sVersion);

            if sMsg > '' then  //Upload 실패는 중요하지 않고 발생도 안할 거다. 계속 진행
            begin
            //      Screen.Cursor := crDefault;
            //      Exit;
            end;}
        end else
        begin
            //iDBFAge      := FieldByName('F_AGE').AsInteger;
          sDBFVersion := trim(FieldByName('F_VERSION').asSTring);
          gf_log('Age 체크 Start');
          iSyncAge := FileAge(sFilePath + sSyncFileName);
          gf_log('Age 체크 End');

          //if iDBFAge <> iSyncAge then  // Age 체크후 틀리면 버전 체크
          //begin
          sSyncVersion := gf_ExeVersion(Application.ExeName);
          if sSyncVersion < sDBFVersion then //download 해라
          begin
            sMsg := DownloadFromDB(sFilePath, sSyncFileName);
            if FileExists(sFilePath + sSyncFileName) then
              if FileSetDate(sFilePath + sSyncFileName, iDBFAge) <> 0 then
                gf_Log('Application FileAge Change Error : ' + sSyncFileName)
              else
                gf_Log('Application FileAge Change End');
            if sMsg = '' then //down load 성공
            begin
              // gf_ShowErrDlgMessage(0, 0, 'Client Version Upgrade가 완료되었습니다.'
              //  + gcMsgLineInterval + '종료후 재접속을 시도하십시오.', 0);
              Result := 'Program Upgraded! ';
              Exit;
            end;
          end
          else if sSyncVersion > sDBFVersion then //Upload 해라
          begin
            sMsg := UploadToDB(sFilePath, sSyncFileName, 'U', sSyncVersion, iSyncAge);
            if sMsg > '' then //Upload 실패는 중요하지 않고 발생도 안할 거다. 계속 진행
            begin
                  //        Screen.Cursor := crDefault;
                  //        Exit;

            end;
          end else if sSyncVersion = sDBFVersion then
          begin
                  {if iDBFAge < iSyncAge then
                  begin
                     sMsg := UploadToDB(sFilePath, sSyncFileName, 'U', sSyncVersion, iSyncAge);
                  end
                  else if iDBFAge > iSyncAge then
                  begin
                     sMsg := DownloadFromDB(sFilePath, sSyncFileName);
                     if FileExists(sFilePath + sSyncFileName) then
                        if FileSetDate(sFilePath + sSyncFileName, iDBFAge) <> 0 then
                           gf_Log('Application FileAge Change Error : ' + sSyncFileName)
                        else
                           gf_Log('Application FileAge Change End');
                     if sMsg = '' then //down load 성공
                     begin
                        gf_ShowErrDlgMessage(0, 0, 'Client Version Upgrade가 완료되었습니다.'
                             + gcMsgLineInterval + '종료후 재접속을 시도하십시오.',0);
                        Result:= 'Program Upgraded! ';
                        Exit;
                     end;
                  end; }
          end;
            //end;
        end; // if RecordCount <= 0 then
      end; //with
      pPanel.Caption := sOriMsg; //초기화
    end else //2. // IF NOT EXE  모든 업데이트 대상  Download 또는 Insert
    begin
      StFiles := TList.Create;
      if not Assigned(StFiles) then
      begin
        gf_ShowErrDlgMessage(0, 9004, '', 0); // List 생성 오류  List 생성오류는 중요하지 않다. exe 계속 달려.
        Exit; //List 생성오류는 중요하지 않다. exe 계속 달려.
      end;

      sSyncFileName := uppercase(ExtractFileName(Application.ExeName));
      sFilePath := ExtractFilePath(Application.ExeName);

      with pQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add(' SELECT ISNULL(F.F_NAME, ''NEW'')  F_NAME ,        '
          + ' ISNULL(F.F_AGE, 0) F_AGE ,                                  '
          + ' ISNULL(D.MAILFORM_ID + ''.DLL'', ''DOWN'' ) MAILFORM_ID,     '
          + ' ISNULL(F_VERSION,'''') F_VERSION                    '
          + ' FROM SCPRVER_TBL F FULL OUTER JOIN SCMELID_TBL D  '
          + ' ON upper(F.F_NAME) = upper(D.MAILFORM_ID) + ''.DLL''            '
                //  제외 자기자신 EXE는 따로! 관리
          + ' WHERE upper(isnull(F.F_NAME,'''')) <> ''' + sSyncFileName + '''           ');
        try
          gf_ADOQueryOpen(pQuery);
        except
          on E: Exception do
          begin
            gf_ShowErrDlgMessage(0, 0, 'Version Check List :' + E.Message, 0);
            Result := 'Select Version Check File Query Error!';
            Exit;
          end;
        end;

        while not Eof do
        begin
          sMailFormID := uppercase(Trim(FieldByName('MAILFORM_ID').AsString));
          sDBFName := uppercase(Trim(FieldByName('F_NAME').AsString));
          iDBFAge := FieldByName('F_AGE').AsInteger;
          sDBFVersion := Trim(FieldByName('F_VERSION').AsString);
          gf_Log('Update Start : ' + sDBFName + ', Mail ID : ' + sMailFormID);

            // NEW 신규 Upload 대상 해당 피시에 파일이 없을수 있음.
          if sDBFName = 'NEW' then
          begin
               //gf_Log('UPDATE 1');
               // 파일이 없을경우는 넘어감 다른곳에서 입력중이거나 업데이트 예정 파일
            if not FileExists(sFilePath + sMailFormID) then
            begin
              Next;
              Continue;
            end;
               // 있으면 업로드 DB
            New(FilesItem);
            StFiles.Add(FilesItem);
            FilesItem.FileName := sMailFormID;

               //gf_Log('UPDATE New ExeVersion Start');
            try
              FilesItem.Version := gf_ExeVersion(sFilePath + FilesItem.FileName);
            except
              on E: Exception do
              begin
                FilesItem.Version := '';
                gf_log('Version Chack Error : ' + FilesItem.FileName
                  + 'Message : ' + E.Message);
              end;
            end;
               //gf_Log('UPDATE New ExeVersion End ');
            FilesItem.Action := 'I'; // 추가 대상
            FilesItem.FileAge := FileAge(sFilePath + FilesItem.FileName);
               //gf_Log('UPDATE 1 END');
          end else
            // 이 외는 버전 체크 관리
          begin
            New(FilesItem);
            StFiles.Add(FilesItem);
               //gf_Log('UPDATE 2');
            FilesItem.FileName := sDBFName;
            FilesItem.Version := '';

               // 파일이 없을경우 다운 받아야됨
            if not FileExists(sFilePath + sDBFName) then
            begin
              FilesItem.FileAge := iDBFAge;
              FilesItem.Action := 'D'; // 다운 받는 대상
            end else
            begin // 파일이 있는경우 버전 체크
                  //gf_Log('UPDATE 2 - FileAge Chack');
              iSyncAge := FileAge(sFilePath + sDBFName);
                  //gf_Log('UPDATE 2 - FileAge Chack End');
                  // F_AGE에 값과 실제 파일의 AGE체크
                  //gf_Log('iDBFAge(' + inttostr(iDBFAge) +  ') <> iSyncAge(' + IntToStr(iSyncAge) +')' );
              if iDBFAge <> iSyncAge then // 같지 않을경우 버전 체크
              begin
                     //gf_Log('UPDATE 2 (iDBFAge <>  iSyncAge)- Version Chack');
                try
                  sSyncVersion := gf_ExeVersion(sFilePath + sDBFName); ; // Age가 있으므로 버전체크 안함 '' 공란
                except
                  on E: Exception do
                  begin
                    FilesItem.Version := '';
                    sSyncVersion := '';
                    gf_log('Version Chack Error : ' + sDBFName
                      + 'Message : ' + E.Message);
                  end;
                end;
                     //gf_Log('UPDATE 2 (iDBFAge <>  iSyncAge)- Version Chack End');
                     //gf_Log('File Version : ' + sSyncVersion);
                     //gf_Log('DB File Version : ' +  sDBFVersion );

                if (sDBFVersion = sSyncVersion) or
                  (sSyncVersion = '') then //같거나 버전이 없음 Age를 동기화
                begin
                  if iDBFAge < iSyncAge then
                  begin
                    FilesItem.Action := 'U';
                    FilesItem.Version := sSyncVersion; // 폴더 파일 버전
                    FilesItem.FileAge := iSyncAge; // 폴더 파일 Age
                  end
                  else if iDBFAge > iSyncAge then
                  begin
                    FilesItem.Action := 'D';
                    FilesItem.Version := sDBFVersion; // DB에 있는 버전
                    FilesItem.FileAge := iDBFAge; // DB 파일 Age
                  end;
                end else
                  if sDBFVersion >
                    sSyncVersion then //다운받아
                  begin
                    FilesItem.Action := 'D';
                    FilesItem.Version := sDBFVersion; // DB에 있는 버전
                    FilesItem.FileAge := iDBFAge; // DB 파일 Age
                  end
                  else if sDBFVersion < sSyncVersion then //올려 받아
                  begin
                    FilesItem.Action := 'U';
                    FilesItem.Version := sSyncVersion; // 폴더 파일 버전
                    FilesItem.FileAge := iSyncAge; // 폴더 파일 Age
                  end;

              end else // F_AGE 값이 같은경우 NO UPDATE
              begin
                FilesItem.Action := 'N';
              end;
                  //gf_Log('UPDATE 2 END');
            end;
          end;
          Next;
        end;

      end; // end with pQuery do

      // [L.J.S] 2016.10.25 DLL로 만든 화면 처음 사용시 SCPRVER_TBL 테이블에 등록
      // 등록 되어 있으면 신경 안 쓴다.
      // * SCMELID_TBL에 등록된 보고서에 할당된 dll 화면 있는지 확인
      sDllFormName := '';
      for i := 0 to StFiles.Count-1 do
      begin
        FilesItem := stFiles.Items[i];

        sMailFormID := FilesItem.FileName;

        bAddDllForm := False;

        // * DLL 화면 이름 형식 (MAILFORM_ID_FORM_.dll)
        sDllFormName := Copy(sMailFormID, 1, 7) + '_FORM.DLL';

        // * DLL 화면 파일이 PC에 존재 하면
        if FileExists(sFilePath + sDllFormName) then
        begin
          bAddDllForm := True;

          // * 파일 리스트에 해당 DLL 화면이 존재하는지 확인
          for j := 0 to StFiles.Count-1 do
          begin
            tempFilesItem := StFiles.Items[j];
            // * 존재하면 해당 MAILFORM_ID 작업은 끝낸다. : bAddDllForm := False;
            // * 존재하지 않으면 파일리스트 추가를 허용.  : bAddDllForm := True;
            if sDllFormName = tempFilesItem.FileName then
            begin
              bAddDllForm := False;
              break;
            end;
          end;

          // * Dll 화면 파일 리스트에 추가
          if bAddDllForm then begin
            New(FilesItem);
            StFiles.Add(FilesItem);
            FilesItem.FileName := sDllFormName;
            FilesItem.Version  := gf_ExeVersion(sFilePath + FilesItem.FileName);
            FilesItem.Action   := 'I';
            FilesItem.FileAge  := FileAge(sFilePath + FilesItem.FileName);
            FilesItem.MailFormID := '';
            FilesItem.MailFormName := '';
            FilesItem.MailHelpText := '';

            gf_Log('Add DLL Form : ' + sDllFormName);
          end;
        end;

        gf_Log('Searching DLL Form : ' + sMailFormID);
      end;

      gf_Log('SCPRVER Query END');
      iCur := 0;
      iTot := 0;
      for i := 0 to StFiles.Count - 1 do
      begin
        FilesItem := StFiles.Items[i];

        if FilesItem.Action = 'N' then Continue;

        inc(iTot);
      end;

      MsgOpen := False;
      for i := 0 to StFiles.Count - 1 do
      begin

        FilesItem := StFiles.Items[i];

        if FilesItem.Action = 'N' then Continue;

        if FilesItem.Action = 'D' then
        begin
          gf_Log('download start ' + FilesItem.FileName);
          inc(iCur);
          pPanel.Caption := sOriMsg + ' ' + IntToStr(iCur) + '/' + IntToStr(iTot);
          pPanel.Repaint;
          sMsg := DownloadFromDB(sFilePath, FilesItem.FileName);
         //FilesItem.FileAge := FileAge(sFilePath + FilesItem.FileName);

          gf_Log('download end ' + FilesItem.FileName);
          gf_Log('FileAge Change ' + FilesItem.FileName);
         // 파일을 다운받으면 Age가 변경된다  DB의 Age로 Age변경!!!
          if FileExists(sFilePath + FilesItem.FileName) then
            if FileSetDate(sFilePath + FilesItem.FileName, FilesItem.FileAge) <> 0 then
            begin
              if not MsgOpen then
              begin
                MsgOpen := True;
                gf_ShowErrDlgMessage(0, 0, 'FileUpdate 오류 - 파일 쓰기에 실패 했습니다. '
                  + #13#10 + #13#10 + 'Dataroad에 문의하세요.', 0);
              end;

              gf_Log('FileAge Change Error' + FilesItem.FileName)
            end
            else
              gf_Log('FileAge Change End Count ' + IntToStr(iCur));
        end
        else if FilesItem.Action = 'U' then
        begin
          gf_Log('Upload U start ' + FilesItem.FileName);
          inc(iCur);
          pPanel.Caption := sOriMsg + ' ' + IntToStr(iCur) + '/' + IntToStr(iTot);
          pPanel.Repaint;
          sMsg := UploadToDB(sFilePath, FilesItem.FileName, 'U', FilesItem.Version, FilesItem.FileAge);
          gf_Log('Upload U end ' + FilesItem.FileName);
        end
        else if FilesItem.Action = 'I' then
        begin
          gf_Log('Upload I start ' + FilesItem.FileName);
          inc(iCur);
          pPanel.Caption := sOriMsg + ' ' + IntToStr(iCur) + '/' + IntToStr(iTot);
          pPanel.Repaint;
          sMsg := UploadToDB(sFilePath, FilesItem.FileName, 'I', FilesItem.Version, FilesItem.FileAge);
          gf_Log('Upload I end ' + FilesItem.FileName);
        end
        else if FilesItem.Action = 'A' then
        begin
          gf_Log('Upload A start ' + FilesItem.FileName);
          inc(iCur);
          pPanel.Caption := sOriMsg + ' ' + IntToStr(iCur) + '/' + IntToStr(iTot);
          pPanel.Repaint;
          sMsg := UploadToDB(sFilePath, FilesItem.FileName, 'A', '', FilesItem.FileAge);
          gf_Log('Upload A end ' + FilesItem.FileName);
        end;

      end; // for

      pPanel.Caption := sOriMsg; //초기화

    end; //2.DLL Download END

  finally
    gf_Log('File Update LIST Free');

    if Assigned(StFiles) then
    begin
      FreeAndNil(StFiles);
    end;
  end;
end;

function gf_FormatTelNo(sTelNo: string): string;
begin
  sTelNo := Trim(sTelNo);
  sTelNo := StringReplace(sTelNo, '-', '', [rfReplaceAll]);

  if Length(sTelNo) <= 8 then //시내통화
  begin
    sTelNo := LeftStr(sTelNo, Length(sTelNo) - 4) + '-' + RightStr(sTelNo, 4);
  end
  else if (sTelNo[1] = '0') and (sTelNo[2] >= '2') then //02 이상 지역번호 쓴 경우
  begin
    if LeftStr(sTelNo, 2) = '02' then //02
      sTelNo := LeftStr(sTelNo, 2) + '-' + Copy(sTelNo, 3, Length(sTelNo) - 6) + '-' + RightStr(sTelNo, 4)
    else //기타 지역번호
      sTelNo := LeftStr(sTelNo, 3) + '-' + Copy(sTelNo, 4, Length(sTelNo) - 7) + '-' + RightStr(sTelNo, 4)
  end
  else //if (sTelNo[1] > '0') and (sTelNo[1] <= '9') then //국제번호
  begin
    //국제번호는 변수가 너무 많아 포맷안함. 국가번호가 한자리에서 3자리까지임.
  end;
  Result := sTelNo;
end;

//------------------------------------------------------------------------------
//  OASYS SOTRADE 번호 채번 SEND_SEQ_NO
//------------------------------------------------------------------------------

function gf_GetOASYSSendSeqNo: Integer;
var
  RtnValue: string;
begin
  Result := -1;
  with DataModule_SettleNet.ADOSP_SP0103 do
  begin
    try
      Parameters.ParamByName('@in_date').Value := gvCurDate;
      Parameters.ParamByName('@in_dept_code').Value := gcDEPT_CODE_COMMON;
      Parameters.ParamByName('@in_sec_type').Value := gcSEC_EQUITY;
      Parameters.ParamByName('@in_send_mtd').Value := '7';
      Parameters.ParamByName('@in_biz_type').Value := '01'; //01: 총송신번호인데 의미없음.
      Parameters.ParamByName('@in_get_flag').Value := '2'; //채번
      Execute;
    except
      on E: Exception do
      begin // StoredProcedure 실행 오류입니다.
        gvErrorNo := 9002; // StoredProcedure 실행 오류입니다.
        gvExtMsg := 'SP0103: ' + E.Message;
        Exit;
      end;
    end;
    RtnValue := Parameters.ParamByName('@out_rtc').Value;
    if (Trim(RtnValue) <> '') and (RtnValue <> '0000') then //오류 발생
    begin
      gvErrorNo := 9002; // StoredProcedure 실행 오류입니다.
      gvExtMsg := 'SP0103: ' + Parameters.ParamByName('@out_kor_msg').Value;
      Exit;
    end;
    Result := Parameters.ParamByName('@out_snd_no').Value;
  end;
end;

//------------------------------------------------------------------------------
//  수수료계산율 (주식Off, 코스닥Off, 기타all)
//------------------------------------------------------------------------------
{
function gf_GetCommRateLst(pADOQuery : TADOQuery; pAccNo : String; var sEqtyOff, sKosqOff : String; var sAll : TList): Integer;
var
   iRow : Integer;
   sEqtyCD, sKosqCD, sAllCD : String;
   pAll : PTCommRate;
begin
   Result := -1;

   sEqtyCD := '021';   //주식Offline
   sKosqCD := '200';   //코스닥Offline
   sAllCD  := '000';   //전체

   with pADOQuery do
   begin
      Try
         Close;
         SQL.Clear;
         SQL.Add('SELECT                                                    '+
                 '  EQUITY_COMM = (SELECT ROUND(ISNULL((COMM_RATE *100),0),3,1) FROM SEACOMR_TBL '+
                 '                  WHERE COMM_CODE = ''' + sEqtyCD + '''   '+
                 '                    AND ACC_NO    = M.ACC_NO              '+
                 '                    AND DEPT_CODE = M.DEPT_CODE           '+
                 '                    AND S_DATE   <= ''' + gvCurDate + ''' '+
                 '                    AND E_DATE   >= ''' + gvCurDate + ''')'+
                 ', KOSDAQ_COMM = (SELECT ROUND(ISNULL((COMM_RATE *100),0),3,1) FROM SEACOMR_TBL '+
                 '                  WHERE COMM_CODE = ''' + sKosqCD + '''   '+
                 '                    AND ACC_NO    = M.ACC_NO              '+
                 '                    AND DEPT_CODE = M.DEPT_CODE           '+
                 '                    AND S_DATE   <= ''' + gvCurDate + ''' '+
                 '                    AND E_DATE   >= ''' + gvCurDate + ''')'+
                 ', ALL_COMM =   (SELECT ROUND(ISNULL((COMM_RATE *100),0),3,1) FROM SEACOMR_TBL    '+
                 '               WHERE COMM_CODE =  ''' + sAllCD + '''      '+
                 '                 AND ACC_NO    = M.ACC_NO                 '+
                 '                    AND DEPT_CODE = M.DEPT_CODE           '+
                 '                    AND S_DATE   <= ''' + gvCurDate + ''' '+
                 '                    AND E_DATE   >= ''' + gvCurDate + ''')'+
                 ', COMM_CODE, COMM_RATE = ROUND(ISNULL((COMM_RATE *100),0),3,1)'+
                 ', CD, NM                                                  '+
                 '  FROM SEACOMR_TBL M, SUGRPCD_TBL G                       '+
                 '  WHERE DEPT_CODE = ''' + gvDeptCode + '''   '+
                 '   AND  ACC_NO    = ''' + pAccNo     + '''   '+
                 '   AND  M.S_DATE <= ''' + gvCurDate  + '''   '+
                 '   AND  M.E_DATE >= ''' + gvCurDate  + '''   '+
                 '   AND  M.COMM_CODE = G.CD                   '+
                 '   AND  G.GRP     = ''06''                   ');

         gf_ADOQueryOpen(pADOQuery);

      Except
      on E : Exception do
      begin
         gvErrorNo := 9001;
         gvExtMsg  := 'SEACOMR_TBL[Select]: ' + E.Message;
         Exit;
      end;
      End;

      if RecordCount <= 0 then
      begin
         Result := 0;
         Exit;
      end;

      First;

      sEqtyOff := FormatFloat('##0.000', FieldByName('EQUITY_COMM').AsFloat);
      sKosqOff := FormatFloat('##0.000', FieldByName('KOSDAQ_COMM').AsFloat);

      if sEqtyOff <= '0.000' then sEqtyOff := FormatFloat('##0.000', FieldByName('ALL_COMM').AsFloat);
      if sKosqOff <= '0.000' then sKosqOff := FormatFloat('##0.000', FieldByName('ALL_COMM').AsFloat);

      if not Assigned(sAll) then
      begin
         Exit;
      end;

      while NOT EOF do
      begin
         Inc(iRow);
         New(pAll);
         sAll.Add(pAll);
         pAll.Code    := Trim(FieldByName('COMM_CODE').AsString);
         pAll.ComRate := FormatFloat('##0.000', FieldByName('COMM_RATE').AsFloat);
         pAll.ComName := Trim(FieldByName('NM').AsString);

         Next;
      end;

   end;

   Result := iRow;
end;

//------------------------------------------------------------------------------
//  수수료계산율 (주식Off, 코스닥Off, 기타all)
//------------------------------------------------------------------------------
function gf_GetCommRateStr(pADOQuery : TADOQuery; pAccNo : String; var sEqtyOff, sKosqOff, sAll : String): Integer;
var
   iRow : Integer;
   sEqtyCD, sKosqCD, sAllCD, sTemp : String;
begin
   Result := -1;

   sEqtyOff := '0.000';
   sKosqOff := '0.000';
   sAll     := '0.000';

   sEqtyCD := '021';   //주식Offline
   sKosqCD := '200';   //코스닥Offline
   sAllCD  := '000';   //전체

   with pADOQuery do
   begin
      Try
         Close;
         SQL.Clear;
         SQL.Add('SELECT                                                    '+
                 '  EQUITY_COMM = (SELECT ROUND(ISNULL((COMM_RATE *100),0),3,1) FROM SEACOMR_TBL '+
                 '                  WHERE COMM_CODE = ''' + sEqtyCD + '''   '+
                 '                    AND ACC_NO    = A.ACC_NO              '+
                 '                    AND DEPT_CODE = A.DEPT_CODE           '+
                 '                    AND S_DATE   <= ''' + gvCurDate + ''' '+
                 '                    AND E_DATE   >= ''' + gvCurDate + ''')'+
                 ', KOSDAQ_COMM = (SELECT ROUND(ISNULL((COMM_RATE *100),0),3,1) FROM SEACOMR_TBL '+
                 '                  WHERE COMM_CODE = ''' + sKosqCD + '''   '+
                 '                    AND ACC_NO    = A.ACC_NO              '+
                 '                    AND DEPT_CODE = A.DEPT_CODE           '+
                 '                    AND S_DATE   <= ''' + gvCurDate + ''' '+
                 '                    AND E_DATE   >= ''' + gvCurDate + ''')'+
                 ', ALL_COMM = (SELECT ROUND(ISNULL((COMM_RATE *100),0),3,1) FROM SEACOMR_TBL    '+
                 '               WHERE COMM_CODE =  ''' + sAllCD + '''      '+
                 '                 AND ACC_NO    = A.ACC_NO                 '+
                 '                 AND DEPT_CODE = A.DEPT_CODE              '+
                 '                 AND S_DATE   <= ''' + gvCurDate + '''    '+
                 '                 AND E_DATE   >= ''' + gvCurDate + ''')   '+
                 ', COMM_RATE = ROUND(ISNULL((COMM_RATE * 100),0),3,1), COMM_CODE      '+
                 '  FROM SEACOMR_TBL A                                      '+
                 '  WHERE DEPT_CODE = ''' + gvDeptCode + '''   '+
                 '   AND  A.S_DATE <= ''' + gvCurDate  + '''   '+
                 '   AND  A.E_DATE >= ''' + gvCurDate  + '''   '+
                 '   AND  ACC_NO    = ''' + pAccNo     + '''   ');

         gf_ADOQueryOpen(pADOQuery);

      Except
      on E : Exception do
      begin
         gvErrorNo := 9001;
         gvExtMsg  := 'SEACOMR_TBL[Select]: ' + E.Message;
         Exit;
      end;
      End;

      if RecordCount <= 0 then
      begin
         Result := 0;
         Exit;
      end;

      First;


      sEqtyOff := FormatFloat('##0.000', FieldByName('EQUITY_COMM').AsFloat);
      sKosqOff := FormatFloat('##0.000', FieldByName('KOSDAQ_COMM').AsFloat);
      sTemp := FormatFloat('##0.000', FieldByName('ALL_COMM').AsFloat);

      if sEqtyOff <= '0.000' then sEqtyOff := sTemp;
      if sKosqOff <= '0.000' then sKosqOff := sTemp;

      while NOT EOF do
      begin
         Inc(iRow);

         sAll := sAll + '[' + Trim(FieldByName('COMM_CODE').AsString) + ':' +
                              FormatFloat('##0.000', FieldByName('COMM_RATE').AsFloat) + ']';
         Next;
      end;

   end;

   Result := iRow;
end;
}

function gf_GetHisTypeName(sHisType: string): string;
begin
  if sHisType = '1' then
    Result := '계좌정정'
  else
    if sHisType = '2' then
      Result := '단가별계좌정정'
    else
      if sHisType = '3' then
        Result := '대표계좌분할'
      else
        if sHisType = '4' then
          Result := '수수료정정'
        else
          if sHisType = '5' then
            Result := '매매정정'
          else
            if sHisType = '6' then
              Result := 'Import'
            else
              if sHisType = '7' then
                Result := '주문번호별매매정정'
              else
                if sHisType = '8' then
                  Result := '수수료보정'
                else
                  if sHisType = '9' then
                    Result := '세금보정'
                  else
                    Result := '';
end;

function gf_GetHisTypeShortName(sHisType: string): string;
begin
  if sHisType = '1' then
    Result := '계좌정정2'
  else
    if sHisType = '2' then
      Result := '계좌정정'
    else
      if sHisType = '3' then
        Result := '대표분할'
      else
        if sHisType = '4' then
          Result := '수수료정정'
        else
          if sHisType = '5' then
            Result := '매매정정'
          else
            if sHisType = '6' then
              Result := 'Import'
            else
              if sHisType = '7' then
                Result := '매매정정#'
              else
                if sHisType = '8' then
                  Result := '수수료보정'
                else
                  if sHisType = '9' then
                    Result := '세금보정'
                  else
                    Result := '';
end;

function gf_GetHisDelTypeName(sHisType: string): string;
begin
  if sHisType = '1' then
    Result := 'Import'
  else
    if sHisType = '2' then
      Result := '계좌정정취소'
    else
      if sHisType = '3' then
        Result := '대표계좌분할취소'
      else
        Result := '';
end;

function gf_GetHisDelTypeShortName(sHisType: string): string;
begin
  if sHisType = '1' then
    Result := 'Import'
  else
    if sHisType = '2' then
      Result := '정정취소'
    else
      if sHisType = '3' then
        Result := '분할취소'
      else
        Result := '';
end;

function gf_UpdateManualChain(sTradeDate: string): boolean;
var sDlgMsg: string;
begin
  Result := false;
  with DataModule_SettleNet.ADOSP_ManualChainUpdate do
  begin
    Parameters.ParamByName('@in_user_id').Value := gvOprUsrNo;
    Parameters.ParamByName('@in_dept_code').Value := gvDeptCode;
    Parameters.ParamByName('@in_trade_date').Value := sTradeDate;
    try
      Execute;
    except
      on E: Exception do
      begin
        gf_ShowErrDlgMessage(0, 0, //Database 오류
          '정정체인Update오류: ' + E.Message, 0);
        Exit;
      end;
    end;

    sDlgMsg := '';
    if Trim(Parameters.ParamByName('@out_rtc').Value) <> '' then
      sDlgMsg := '정정체인Update오류: ' +
        Trim(Parameters.ParamByName('@out_kor_msg').Value);

    if Parameters.ParamByName('@RETURN_VALUE').Value <> 1 then
      sDlgMsg := sDlgMsg + #13#10 + '정정체인 Return Value is not 1';

    if (Trim(Parameters.ParamByName('@out_rtc').Value) <> '') or
      (Parameters.ParamByName('@RETURN_VALUE').Value <> 1) then
    begin
      gf_ShowErrDlgMessage(0, 0, sDlgMsg, 0);
      Exit;
    end;
  end;
  Result := True;
end;

//소문자를 대문자로

function gf_ToUpper(var Key: char): char;
var
  i: integer;
begin
  i := integer(Key);
  if ((i >= 97) and (i <= 122)) then //소문자
  begin
    i := i - 32;
    Key := Char(i); //대문자
  end;

  Result := Key;
end;

//CICS Interface Start =========================================================

procedure myStr2Char(str: PChar; instr: string; len: longint);
var
  i: integer;
  StrTmp: array[0..8196] of char;
begin
  FillChar(str^, len, #0);

  strPLcopy(StrTmp, instr, len);
  for i := 0 to len - 1 do
    str[i] := StrTmp[i];
  str[len] := #0;
end;

function myChar2Str(str: PChar; len: longint): string;
var
  StrTmp: array[0..8196] of char;
begin
  strLcopy(StrTmp, Str, len);
  StrTmp[len + 1] := #0;
  Result := StrPas(StrTmp);
end;

// 한투 당일임시적용수수료율 정정 using CICS 1-1

function gf_HostCICSsnchangeFee(sDate, sAccNo: string; dComRate: double; var sNotifyNeed: string; var sOut: string): boolean;
type
  TsnchangeFee = function(psEmpId, psCustDept, psDate, psAccNo, psComRate, psNofifyNeed, pszOut: pchar): integer; cdecl;

var
  snchangeFee: TsnchangeFee;
  DllHandle: THandle;

  caEmpID: array[0..10] of char;
  caCustDept: array[0..3] of char;
  caDate: array[0..8] of char;
  caAccNo: array[0..20] of char;
  caComRate: array[0..9] of char;
  caNofifyNeed: array[0..1] of char;
  caOut: array[0..100] of char;

  sEmpID, sCustDept, sComRate: string;
begin
  Result := false;

  sEmpID := gvOprEmpID;
  sCustDept := '0' + gvDeptCode;

  DllHandle := LoadLibrary(pChar('ESNCICS.dll'));
  if (DllHandle = HINSTANCE_ERROR) or (DllHandle = 0) then
  begin
    ShowMessage('Dll Load 오류');
    Exit;
  end;

  FillChar(caEmpID, sizeOf(caEmpID), #0);
  FillChar(caCustDept, sizeOf(caCustDept), #0);
  FillChar(caDate, sizeOf(caDate), #0);
  FillChar(caAccNo, sizeOf(caAccNo), #0);
  FillChar(caComRate, sizeOf(caComRate), #0);
  FillChar(caNofifyNeed, sizeOf(caNofifyNeed), #0);
  FillChar(caOut, sizeOf(caOut), #0);

  myStr2Char(caEmpID, sEmpID, Length(sEmpID));
  myStr2Char(caCustDept, sCustDept, Length(sCustDept));
  myStr2Char(caDate, sDate, Length(sDate));
  myStr2Char(caAccNo, sAccNo, Length(sAccNo));

  sComRate := FormatFloat('0.00000000', dComRate);
  sComRate := StringReplace(sComRate, '.', '', [rfReplaceAll]);
  myStr2Char(caComRate, sComRate, Length(sComRate));

  try
    try
      @snchangeFee := GetProcAddress(DllHandle, pChar('snchangeFee'));
      if @snchangeFee <> nil then
      begin
        if snchangeFee(caEmpID, caCustDept, caDate, caAccNo, caComRate, caNofifyNeed, caOut) <> 0 then
        begin
              //ShowMessage('snchangeFee error:' + caOut);
          sOut := caOut;
          exit;
        end;
           //ShowMessage('snchangeFee OK :' + caOut);
      end;
    except
      on E: Exception do
      begin
           //ShowMessage('Except..' + E.Message);
        sOut := 'Except..' + E.Message;
        Exit;
      end;
    end;
  finally
    FreeLibrary(DllHandle);
  end;

  sNotifyNeed := caNofifyNeed;
//gf_log( '수수료율 정저우 노티파이 ' + sNotifyNeed);
  sOut := caOut;
  Result := true;
end;

//당일임시적용수수료율 정정 using CICS 1.

function gf_HostCallsnchangeFee(sDate, sAccNo: string; dComRate: double; var sNotifyNeed: string; var sOut: string): boolean;
begin
  result := False;

  if gvHostGWUseYN = 'N' then //한투
  begin
    if not gf_HostCICSsnchangeFee(sDate, sAccNo, dComRate, sNotifyNeed, sOut) then exit;
  end;

  result := True;
end;


//수수료 계산 Only Using CICS

function gf_HostCICSCalculate(
  sIssueCode, sTranCode, sTrdType,
  sAccNo, sStlDate: string; dAvrExecPrice, dTotExecQty, dTotExecAmt: double;
  var dComm: double; var dTrdTax: double; var dAgcTax: double;
  var dCpgTax: double; var dNetAmt: double; var dHCommRate: double;
  var sOut: string): boolean;
type
  Tsncalculate = function(
    psEmpId, psCustDept,
    psMrkKnd, psIssueCode, psSecType, psTrdType,
    psComType, psAccNo, psStlDate,
    psAvrExecPrice, psTotExecQty, psTotExecAmt,
    // 이하 Output
    psComm, psTrdTax, psAgcTax,
    psCpgTax, psNetAmt, psHCommRate,
    pszOut: pchar): integer; cdecl;

var
  sncalculate: Tsncalculate;
  DllHandle: THandle;

  caEmpId: array[0..10] of char;
  caCustDept: array[0..3] of char;
  caMrkKnd: array[0..1] of char;
  caIssueCode: array[0..12] of char;
  caSecType: array[0..1] of char;
  caTrdType: array[0..1] of char;
  caComType: array[0..1] of char;
  caAccNo: array[0..20] of char;
  caStlDate: array[0..8] of char;
  caAvrExecPrice: array[0..19] of char;
  caTotExecQty: array[0..13] of char;
  caTotExecAmt: array[0..15] of char;
  caComm: array[0..13] of char;
  caTrdTax: array[0..13] of char;
  caAgcTax: array[0..13] of char;
  caCpgTax: array[0..13] of char;
  caNetAmt: array[0..15] of char;
  caHCommRate: array[0..9] of char;
  caOut: array[0..100] of char;

  sEmpID, sCustDept, sSecType, sMrkKnd, sComType: string;
  sAvrExecPrice, sTotExecQty, sTotExecAmt: string;
  sComm, sTrdTax, sAgcTax, sCpgTax, sNetAmt, sHCommRate: string;
begin
  Result := false;

  sEmpID := gvOprEmpID;
  sCustDept := '0' + gvDeptCode;

  sSecType := Copy(sTranCode, 1, 1);
  sMrkKnd := Copy(sTranCode, 2, 1);
  sComType := Copy(sTranCode, 4, 1);

  DllHandle := LoadLibrary(pChar('ESNCICS.dll'));
  if (DllHandle = HINSTANCE_ERROR) or (DllHandle = 0) then
  begin
    ShowMessage('Dll Load 오류');
    Exit;
  end;

  FillChar(caEmpId, sizeOf(caEmpId), #0);
  FillChar(caCustDept, sizeOf(caCustDept), #0);
  FillChar(caMrkKnd, sizeOf(caMrkKnd), #0);
  FillChar(caIssueCode, sizeOf(caIssueCode), #0);
  FillChar(caSecType, sizeOf(caSecType), #0);
  FillChar(caTrdType, sizeOf(caTrdType), #0);
  FillChar(caComType, sizeOf(caComType), #0);
  FillChar(caAccNo, sizeOf(caAccNo), #0);
  FillChar(caStlDate, sizeOf(caStlDate), #0);
  FillChar(caAvrExecPrice, sizeOf(caAvrExecPrice), #0);
  FillChar(caTotExecQty, sizeOf(caTotExecQty), #0);
  FillChar(caTotExecAmt, sizeOf(caTotExecAmt), #0);
  FillChar(caComm, sizeOf(caComm), #0);
  FillChar(caTrdTax, sizeOf(caTrdTax), #0);
  FillChar(caAgcTax, sizeOf(caAgcTax), #0);
  FillChar(caCpgTax, sizeOf(caCpgTax), #0);
  FillChar(caNetAmt, sizeOf(caNetAmt), #0);
  FillChar(caHCommRate, sizeOf(caHCommRate), #0);
  FillChar(caOut, sizeOf(caOut), #0);

  sAvrExecPrice := FormatFloat('0000000000.000000000', dAvrExecPrice);
  sAvrExecPrice := StringReplace(sAvrExecPrice, '.', '', [rfReplaceAll]);
  sTotExecQty := FormatFloat('0000000000000', dTotExecQty);
  sTotExecAmt := FormatFloat('000000000000000', dTotExecAmt);

  myStr2Char(caEmpId, sEmpId, Length(sEmpId));
  myStr2Char(caCustDept, sCustDept, Length(sCustDept));
  myStr2Char(caMrkKnd, sMrkKnd, Length(sMrkKnd));
  myStr2Char(caIssueCode, sIssueCode, Length(sIssueCode));
  myStr2Char(caSecType, sSecType, Length(sSecType));
  myStr2Char(caTrdType, sTrdType, Length(sTrdType));
  myStr2Char(caComType, sComType, Length(sComType));
  myStr2Char(caAccNo, sAccNo, Length(sAccNo));
  myStr2Char(caStlDate, sStlDate, Length(sStlDate));
  myStr2Char(caAvrExecPrice, sAvrExecPrice, Length(sAvrExecPrice));
  myStr2Char(caTotExecQty, sTotExecQty, Length(sTotExecQty));
  myStr2Char(caTotExecAmt, sTotExecAmt, Length(sTotExecAmt));

  try
    try
      @sncalculate := GetProcAddress(DllHandle, pChar('sncalculate'));
      if @sncalculate <> nil then
      begin
        if sncalculate(
          caEmpId, caCustDept, caMrkKnd, caIssueCode, caSecType, caTrdType, caComType
          , caAccNo, caStlDate, caAvrExecPrice, caTotExecQty, caTotExecAmt
          , caComm, caTrdTax, caAgcTax, caCpgTax, caNetAmt, caHCommRate, caOut
          ) <> 0 then
        begin
              //ShowMessage('sncalculate error:' + caOut);
          sOut := caOut;
          exit;
        end;
{
           ShowMessage( 'sncalculate OK '
            + #13#10 + 'caComm     =' + '''' + caComm     + ''''
            + #13#10 + 'caTrdTax   =' + '''' + caTrdTax   + ''''
            + #13#10 + 'caAgcTax   =' + '''' + caAgcTax   + ''''
            + #13#10 + 'caCpgTax   =' + '''' + caCpgTax   + ''''
            + #13#10 + 'caNetAmt   =' + '''' + caNetAmt   + ''''
            + #13#10 + 'caHCommRate=' + '''' + caHCommRate+ ''''
            + #13#10 + 'caOut      =' + '''' + caOut      + '''');
}
        sComm := myChar2Str(caComm, Length(caComm));
        sTrdTax := myChar2Str(caTrdTax, Length(caTrdTax));
        sAgcTax := myChar2Str(caAgcTax, Length(caAgcTax));
        sCpgTax := myChar2Str(caCpgTax, Length(caCpgTax));
        sNetAmt := myChar2Str(caNetAmt, Length(caNetAmt));
        sHCommRate := myChar2Str(caHCommRate, Length(caHCommRate));

        gf_log('수수료확인:' + sComm);
        gf_log('수수료율확인:' + sHCommRate);

        dComm := StrToFloat(sComm);
        dTrdTax := StrToFloat(sTrdTax);
        dAgcTax := StrToFloat(sAgcTax);
        dCpgTax := StrToFloat(sCpgTax);
        dNetAmt := StrToFloat(sNetAmt);
        dHCommRate := StrToFloat(copy(sHCommRate, 1, 1) + '.' + copy(sHCommRate, 2, 8));

        gf_log('수수료확인2:' + ForMatFloat('#,##0', dComm));
        gf_log('수수료율확인2:' + ForMatFloat('#,##0.000000', dHCommRate));

{
           ShowMessage( 'sncalculate OK '
            + #13#10 + 'dComm     =' + '''' + FormatFloat('#,##0',dComm     )+ ''''
            + #13#10 + 'dTrdTax   =' + '''' + FormatFloat('#,##0',dTrdTax   )+ ''''
            + #13#10 + 'dAgcTax   =' + '''' + FormatFloat('#,##0',dAgcTax   )+ ''''
            + #13#10 + 'dCpgTax   =' + '''' + FormatFloat('#,##0',dCpgTax   )+ ''''
            + #13#10 + 'dNetAmt   =' + '''' + FormatFloat('#,##0',dNetAmt   )+ ''''
            + #13#10 + 'dHCommRate=' + '''' + FormatFloat('#,##0.00000000',dHCommRate)+ ''''
            + #13#10 + 'caOut      =' + '''' + caOut      + '''');
}
      end;
    except
      on E: Exception do
      begin
           //ShowMessage('Except..' + E.Message);
        sOut := 'Except..' + E.Message;
        Exit;
      end;
    end;
  finally
    FreeLibrary(DllHandle);
  end;

  sOut := caOut;
  Result := true;
end;

//OMS 매매 Import Using CICS

function gf_HostCICSsngetOMSTRInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;
type
  TsngetOMSTRInfo = function(
    psEmpId, psCustDept, psDate: pchar;
    ppsAccNo: ppchar; psFileName, pszOut: pchar
    ): integer; cdecl;

var
  i, j: integer;
  sngetOMSTRInfo: TsngetOMSTRInfo;
  DllHandle: THandle;

  caFileName: array[0..30] of char;
  caCustDept: array[0..3] of char;
  caDate: array[0..8] of char;
  pcaAccNo: array[0..1000] of PChar;
  caaAccNo: array[0..1000, 0..20] of char;
  caEmpId: array[0..10] of char;
  caOut: array[0..100] of char;

  sEmpID, sCustDept: string;
begin
  Result := false;

  sEmpID := gvOprEmpID;
  sCustDept := '0' + gvDeptCode;

  DllHandle := LoadLibrary(pChar('ESNCICS.dll'));
  if (DllHandle = HINSTANCE_ERROR) or (DllHandle = 0) then
  begin
    ShowMessage('Dll Load 오류');
    Exit;
  end;

  FillChar(caFileName, SizeOf(caFileName), #0);
  FillChar(caCustDept, SizeOf(caCustDept), #0);
  FillChar(caDate, SizeOf(caDate), #0);
  FillChar(caaAccNo, SizeOf(caaAccNo), #0);
  FillChar(caEmpId, SizeOf(caEmpId), #0);
  FillChar(caOut, SizeOf(caOut), #0);

  myStr2Char(caEmpId, sEmpId, Length(sEmpId));
  myStr2Char(caCustDept, sCustDept, Length(sCustDept));
  myStr2Char(caDate, sDate, Length(sDate));
  myStr2Char(caFileName, sFileName, Length(sFileName));

  if sAccList > '' then
  begin
    i := 0;
    while (sAccList > '') do
    begin
      j := Pos(',', sAccList);
      if j <= 0 then break;
      myStr2Char(caaAccNo[i], LeftStr(sAccList, j - 1), Length(LeftStr(sAccList, j - 1)));
      sAccList := Copy(sAccList, j + 1, Length(sAccList) - j);
      inc(i);
    end;

    for i := i to 4 do
    begin
      caaAccNo[i][0] := ' '; //없을때 5개까지 Space처리하기로 함.
    end;
  end
  else
  begin
//    ShowMessage('해당 그룹의 계좌가 존재하지 않습니다.');
//    Exit;
    caaAccNo[0][0] := ' '; //없을때 5개까지 Space처리하기로 함.
    caaAccNo[1][0] := ' ';
    caaAccNo[2][0] := ' ';
    caaAccNo[3][0] := ' ';
    caaAccNo[4][0] := ' ';
  end;

  for i := 0 to High(caaAccNo) do
  begin
    if caaAccNo[i][0] = #0 then
    begin
      pcaAccNo[i] := #0;
      break;
    end
    else
      pcaAccNo[i] := caaAccNo[i];
  end;

{
  pcaAccNo[0] := StrNew('1223311');
  pcaAccNo[1] := StrNew('1223312');
  pcaAccNo[2] := nil;
}
  try
    try
      @sngetOMSTRInfo := GetProcAddress(DllHandle, pChar('sngetOMSTRInfo'));
      if @sngetOMSTRInfo <> nil then
      begin
        if sngetOMSTRInfo(caEmpId, caCustDept, caDate, ppchar(@pcaAccNo), caFileName, caOut) <> 0 then
        begin
              //ShowMessage('sngetOMSTRInfo error:' + caOut);
          sOut := caOut;
          exit;
        end;
           //ShowMessage('sngetOMSTRInfo OK :' + caOut);
      end;
    except
      on E: Exception do
      begin
           //ShowMessage('Except..' + E.Message);
        sOut := 'Except..' + E.Message;
        Exit;
      end;
    end;
  finally
    FreeLibrary(DllHandle);
  end;

//  StrDispose(pcaAccNo[0]);
//  StrDispose(pcaAccNo[1]);

  sOut := caOut;
  Result := true;
end;

//매매 Import Using CICS

function gf_HostCICSsngetTRInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;
type
  TsngetTRInfo = function(
    psEmpId, psCustDept, psDate: pchar;
    ppsAccNo: ppchar; psFileName, pszOut: pchar
    ): integer; cdecl;

var
  i, j: integer;
  sngetTRInfo: TsngetTRInfo;
  DllHandle: THandle;

  caFileName: array[0..30] of char;
  caCustDept: array[0..3] of char;
  caDate: array[0..8] of char;
  pcaAccNo: array[0..1000] of PChar;
  caaAccNo: array[0..1000, 0..20] of char;
  caEmpId: array[0..10] of char;
  caOut: array[0..100] of char;

  sEmpID, sCustDept: string;
begin
  Result := false;

  sEmpID := gvOprEmpID;
  sCustDept := '0' + gvDeptCode;

  DllHandle := LoadLibrary(pChar('ESNCICS.dll'));
  if (DllHandle = HINSTANCE_ERROR) or (DllHandle = 0) then
  begin
    ShowMessage('Dll Load 오류');
    Exit;
  end;

  FillChar(caFileName, SizeOf(caFileName), #0);
  FillChar(caCustDept, SizeOf(caCustDept), #0);
  FillChar(caDate, SizeOf(caDate), #0);
  FillChar(caaAccNo, SizeOf(caaAccNo), #0);
  FillChar(caEmpId, SizeOf(caEmpId), #0);
  FillChar(caOut, SizeOf(caOut), #0);

  myStr2Char(caEmpId, sEmpId, Length(sEmpId));
  myStr2Char(caCustDept, sCustDept, Length(sCustDept));
  myStr2Char(caDate, sDate, Length(sDate));
  myStr2Char(caFileName, sFileName, Length(sFileName));

  if sAccList > '' then
  begin
    i := 0;
    while (sAccList > '') do
    begin
      j := Pos(',', sAccList);
      if j <= 0 then break;
      myStr2Char(caaAccNo[i], LeftStr(sAccList, j - 1), Length(LeftStr(sAccList, j - 1)));
      sAccList := Copy(sAccList, j + 1, Length(sAccList) - j);
      inc(i);
    end;

    for i := i to 4 do
    begin
      caaAccNo[i][0] := ' '; //없을때 5개까지 Space처리하기로 함.
    end;
  end
  else
  begin
//    ShowMessage('해당 그룹의 계좌가 존재하지 않습니다.');
//    Exit;
    caaAccNo[0][0] := ' '; //없을때 5개까지 Space처리하기로 함.
    caaAccNo[1][0] := ' ';
    caaAccNo[2][0] := ' ';
    caaAccNo[3][0] := ' ';
    caaAccNo[4][0] := ' ';
  end;

  for i := 0 to High(caaAccNo) do
  begin
    if caaAccNo[i][0] = #0 then
    begin
      pcaAccNo[i] := #0;
      break;
    end
    else
      pcaAccNo[i] := caaAccNo[i];
  end;

{
  pcaAccNo[0] := StrNew('1223311');
  pcaAccNo[1] := StrNew('1223312');
  pcaAccNo[2] := nil;
}
  try
    try
      @sngetTRInfo := GetProcAddress(DllHandle, pChar('sngetTRInfo'));
      if @sngetTRInfo <> nil then
      begin
        if sngetTRInfo(caEmpId, caCustDept, caDate, ppchar(@pcaAccNo), caFileName, caOut) <> 0 then
        begin
              //ShowMessage('sngetTRInfo error:' + caOut);
          sOut := caOut;
          exit;
        end;
           //ShowMessage('sngetTRInfo OK :' + caOut);
      end;
    except
      on E: Exception do
      begin
           //ShowMessage('Except..' + E.Message);
        sOut := 'Except..' + E.Message;
        Exit;
      end;
    end;
  finally
    FreeLibrary(DllHandle);
  end;

//  StrDispose(pcaAccNo[0]);
//  StrDispose(pcaAccNo[1]);

  sOut := caOut;
  Result := true;
end;

//계좌 Import Using CICS

function gf_HostCICSsngetACInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;
type
  TsngetACInfo = function(
    psEmpId, psCustDept, psDate: pchar;
    ppsAccNo: ppchar; psFileName, pszOut: pchar
    ): integer; cdecl;
var
  sngetACInfo: TsngetACInfo;
  DllHandle: THandle;

  caFileName: array[0..30] of char;
  caCustDept: array[0..3] of char;
  caDate: array[0..8] of char;
  caEmpId: array[0..10] of char;
  caOut: array[0..100] of char;
  pcaAccNo: array[0..1000] of PChar;
  caaAccNo: array[0..1000, 0..20] of char;

  i, j: integer;
  sEmpID, sCustDept: string;
begin
  Result := false;

  sEmpID := gvOprEmpID;
  sCustDept := '0' + gvDeptCode;

  DllHandle := LoadLibrary(pChar('ESNCICS.dll'));
  if (DllHandle = HINSTANCE_ERROR) or (DllHandle = 0) then
  begin
    ShowMessage('Dll Load 오류');
    Exit;
  end;

  FillChar(caFileName, SizeOf(caFileName), #0);
  FillChar(caCustDept, SizeOf(caCustDept), #0);
  FillChar(caDate, SizeOf(caDate), #0);
  FillChar(caEmpId, SizeOf(caEmpId), #0);
  FillChar(caOut, SizeOf(caOut), #0);
  FillChar(caaAccNo, SizeOf(caaAccNo), #0);

  myStr2Char(caEmpId, sEmpId, Length(sEmpId));
  myStr2Char(caCustDept, sCustDept, Length(sCustDept));
  myStr2Char(caDate, sDate, Length(sDate));
  myStr2Char(caFileName, sFileName, Length(sFileName));

  if caDate[0] = #0 then caDate[0] := ' ';

  if sAccList > '' then
  begin
    i := 0;
    while (sAccList > '') do
    begin
      j := Pos(',', sAccList);
      if j <= 0 then break;
      myStr2Char(caaAccNo[i], LeftStr(sAccList, j - 1), Length(LeftStr(sAccList, j - 1)));
      sAccList := Copy(sAccList, j + 1, Length(sAccList) - j);
      inc(i);
    end;

    for i := i to 4 do
    begin
      caaAccNo[i][0] := ' '; //없을때 5개까지 Space처리하기로 함.
    end;
  end
  else
  begin
//    ShowMessage('해당 그룹의 계좌가 존재하지 않습니다.');
//    Exit;
    caaAccNo[0][0] := ' '; //없을때 5개까지 Space처리하기로 함.
    caaAccNo[1][0] := ' ';
    caaAccNo[2][0] := ' ';
    caaAccNo[3][0] := ' ';
    caaAccNo[4][0] := ' ';
  end;

  for i := 0 to High(caaAccNo) do
  begin
    if caaAccNo[i][0] = #0 then
    begin
      pcaAccNo[i] := #0;
      break;
    end
    else
      pcaAccNo[i] := caaAccNo[i];
  end;

  try
    try
      @sngetACInfo := GetProcAddress(DllHandle, pChar('sngetACInfo'));
      if @sngetACInfo <> nil then
      begin
        if sngetACInfo(caEmpId, caCustDept, caDate, ppchar(@pcaAccNo), caFileName, caOut) <> 0 then
        begin
              //ShowMessage('sngetACInfo error:' + caOut);
          sOut := caOut;
          exit;
        end;
           //ShowMessage('sngetTRInfo OK :' + caOut);
      end;
    except
      on E: Exception do
      begin
           //ShowMessage('Except..' + E.Message);
        sOut := 'Except..' + E.Message;
        Exit;
      end;
    end;
  finally
    FreeLibrary(DllHandle);
  end;

  sOut := caOut;
  Result := true;
end;

//주식매매 Import Using HostGateWay (하나대투용)
function gf_HostGateWaysngetTRInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;
var
  ImpData: TCliSvrImpData;
  sAccNo, sImpType: string;
  iRc: Integer;
begin
  Result := false;

   // SocketThread 실행중인지 체크
  iRc := fnMdServerAlive;
  if iRc = -1 then
  begin
    sOut := 'gf_HostGateWaysngetFTRInfo >> not fnServerAlive 서버가 실행중인지 확인하시오.';
    Exit;
  end;

  sAccNo   := Copy(sAccList,1,8) + ' ' + Copy(sAccList,9,3);

  CharCharCpy(ImpData.csTradeDate, Pchar(sDate), Sizeof(ImpData.csTradeDate));
  CharCharCpy(ImpData.csAccNo, Pchar(sAccNo), Sizeof(ImpData.csAccNo));
  CharCharCpy(ImpData.csFileName, PChar(sFileName), Sizeof(ImpData.csFileName));
  CharCharCpy(ImpData.csDeptCode, PChar(gvDeptCode), Sizeof(ImpData.csDeptCode));

  sImpType := gcSTYPE_IMP_TR;

  iRc := fnImpDataSend(sImpType, ImpData);

  if iRc = -1 then
  begin
    result := False;
    if Length(ImpData.csErrmsg) > 0 then
      sOut := 'gf_HostGateWaysngetFTRInfo >> not fnImpDataSend [' + ImpData.csErrcode + ']' + ImpData.csErrmsg
    else
      sOut := 'gf_HostGateWaysngetFTRInfo >> not fnImpDataSend HostGW가 실행중인지 확인하십시오.';
    exit;
  end;

  DisplaynLog('Monitor : ' + ImpData.csErrcode);
  DisplaynLog('Monitor : ' + ImpData.csErrmsg);
  DisplaynLog('Monitor : ' + ImpData.csCreYN);
  sOut := '[' + ImpData.csErrcode + ']' + ImpData.csErrmsg;

  Result := true;

end;

//선물매매 Import Using HostGateWay (하나대투용)
function gf_HostGateWaysngetFTRInfo(sDate, sAccList, sFileName: string;
  var sOut: string; iTradeTypeIdx: integer): boolean;
var
  ImpData: TCliSvrImpData;
  sAccNo, sImpType, sAccFileName: string;
  iRc, iData : Integer;
begin
  Result := false;
  sAccFileName := '';
  gvMCIFtpFileList.Clear;

  // 파일 생성갯수 카운트
  gvMCIFileCnt := 0;

  DisplaynLog('gf_HostGateWaysngetFTRInfo start ');

   // SocketThread 실행중인지 체크
  iRc := fnMdServerAlive;
  if iRc = -1 then
  begin
    sOut := 'gf_HostGateWaysngetFTRInfo >> not fnServerAlive 서버가 실행중인지 확인하시오.';
    Exit;
  end;

  sAccNo   := Copy(sAccList,1,8) + ' ' + Copy(sAccList,9,3);
  iData := 0;


  CharCharCpy(ImpData.csTradeDate, Pchar(sDate), Sizeof(ImpData.csTradeDate));
  CharCharCpy(ImpData.csAccNo, Pchar(sAccNo), Sizeof(ImpData.csAccNo));
  //CharCharCpy(ImpData.csFileName, PChar(sFileName), Sizeof(ImpData.csFileName));
  CharCharCpy(ImpData.csDeptCode, PChar(gvDeptCode), Sizeof(ImpData.csDeptCode));



  if (iTradeTypeIdx <> 2) then
  begin
    // sImpType := gcSTYPE_IMP_FTR;    // 통신 Tr : 임포트파일 업로드 (선물예탁자료)

    // SFT2018011917285-
    sAccFileName := sFileName + '-' + '001' ; // 기존 파일명 + 순번


    gvMCIFtpFileList.Add(sAccFileName);
    Inc(gvMCIFileCnt);

    CharCharCpy(ImpData.csFileName, PChar(sAccFileName), Sizeof(ImpData.csFileName));

    DisplaynLog('gf_HostGateWaysngetFTRInfo >> gcSTYPE_IMP_FDP 예탁 ');
    DisplaynLog('gf_HostGateWaysngetFTRInfo >> sAccFileName : ' + sAccFileName);

    iRc := fnImpDataSend(gcSTYPE_IMP_FDP, ImpData); // 통신 Tr : 임포트파일 업로드 (선물예탁자료)

    if iRc = -1 then
    begin
      result := False;
      if Length(ImpData.csErrmsg) > 0 then
        sOut := 'gf_HostGateWaysngetFTRInfo >> not fnImpDataSend [' + ImpData.csErrcode + ']' + ImpData.csErrmsg
      else
        sOut := 'gf_HostGateWaysngetFTRInfo >> not fnImpDataSend HostGW가 실행중인지 확인하십시오.';
      exit;
    end;

    DisplaynLog('Monitor : ' + ImpData.csErrcode);
    DisplaynLog('Monitor : ' + ImpData.csErrmsg);
    DisplaynLog('Monitor : ' + ImpData.csCreYN);
    sOut := '[' + ImpData.csErrcode + ']' + ImpData.csErrmsg;

  end;

  if  (iTradeTypeIdx <> 1) then
  begin
    //sImpType := gcSTYPE_IMP_FDP;    // 통신 Tr : 임포트파일 업로드 (선물매매,미결제,대용자료)

    sAccFileName :=  sFileName + '-' + '002';   // 기존 파일명   순번

    gvMCIFtpFileList.Add(sAccFileName);
    Inc(gvMCIFileCnt);

    CharCharCpy(ImpData.csFileName, PChar(sAccFileName), Sizeof(ImpData.csFileName));

    DisplaynLog('gf_HostGateWaysngetFTRInfo >> gcSTYPE_IMP_FTR 선물매매 ');
    DisplaynLog('gf_HostGateWaysngetFTRInfo >> sAccFileName : ' + sAccFileName);

    iRc := fnImpDataSend(gcSTYPE_IMP_FTR, ImpData);  // 선물매매

    if iRc = -1 then
    begin
      result := False;
      if Length(ImpData.csErrmsg) > 0 then
        sOut := 'gf_HostGateWaysngetFTRInfo >> not fnImpDataSend [' + ImpData.csErrcode + ']' + ImpData.csErrmsg
      else
        sOut := 'gf_HostGateWaysngetFTRInfo >> not fnImpDataSend HostGW가 실행중인지 확인하십시오.';
      exit;
    end;

    DisplaynLog('Monitor : ' + ImpData.csErrcode);
    DisplaynLog('Monitor : ' + ImpData.csErrmsg);
    DisplaynLog('Monitor : ' + ImpData.csCreYN);
    sOut := '[' + ImpData.csErrcode + ']' + ImpData.csErrmsg;

    //------------------------------------------------------------------------------
    sAccFileName :=  sFileName + '-' + '003';   // 기존 파일명   순번

    gvMCIFtpFileList.Add(sAccFileName);
    Inc(gvMCIFileCnt);

    CharCharCpy(ImpData.csFileName, PChar(sAccFileName), Sizeof(ImpData.csFileName));

    DisplaynLog('gf_HostGateWaysngetFTRInfo >> gcSTYPE_IMP_FOP 미결제 ');
    DisplaynLog('gf_HostGateWaysngetFTRInfo >> sAccFileName : ' + sAccFileName);

    iRc := fnImpDataSend(gcSTYPE_IMP_FOP, ImpData);  // 미결ㅈㅔ

    if iRc = -1 then
    begin
      result := False;
      if Length(ImpData.csErrmsg) > 0 then
        sOut := 'gf_HostGateWaysngetFTRInfo >> not fnImpDataSend [' + ImpData.csErrcode + ']' + ImpData.csErrmsg
      else
        sOut := 'gf_HostGateWaysngetFTRInfo >> not fnImpDataSend HostGW가 실행중인지 확인하십시오.';
      exit;
    end;

    DisplaynLog('Monitor : ' + ImpData.csErrcode);
    DisplaynLog('Monitor : ' + ImpData.csErrmsg);
    DisplaynLog('Monitor : ' + ImpData.csCreYN);
    sOut := '[' + ImpData.csErrcode + ']' + ImpData.csErrmsg;

    //------------------------------------------------------------------------------
    sAccFileName :=  sFileName + '-' + '004';   // 기존 파일명   순번

    gvMCIFtpFileList.Add(sAccFileName);
    Inc(gvMCIFileCnt);

    CharCharCpy(ImpData.csFileName, PChar(sAccFileName), Sizeof(ImpData.csFileName));

    DisplaynLog('gf_HostGateWaysngetFTRInfo >> gcSTYPE_IMP_FCO 대용 ');
    DisplaynLog('gf_HostGateWaysngetFTRInfo >> sAccFileName : ' + sAccFileName);

    iRc := fnImpDataSend(gcSTYPE_IMP_FCO, ImpData);          // 대용

    if iRc = -1 then
    begin
      result := False;
      if Length(ImpData.csErrmsg) > 0 then
        sOut := 'gf_HostGateWaysngetFTRInfo >> not fnImpDataSend [' + ImpData.csErrcode + ']' + ImpData.csErrmsg
      else
        sOut := 'gf_HostGateWaysngetFTRInfo >> not fnImpDataSend HostGW가 실행중인지 확인하십시오.';
      exit;
    end;

    DisplaynLog('Monitor : ' + ImpData.csErrcode);
    DisplaynLog('Monitor : ' + ImpData.csErrmsg);
    DisplaynLog('Monitor : ' + ImpData.csCreYN);
    sOut := '[' + ImpData.csErrcode + ']' + ImpData.csErrmsg;         

  end;

  Result := true;

end;

//주식계좌 Import Using HostGateWay (하나대투용)
function gf_HostGateWaysngetACInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

var
  ImpData: TCliSvrImpData;
  sImpType: string;
  iRc: Integer;
begin
  Result := false;

   // SocketThread 실행중인지 체크
  iRc := fnMdServerAlive;
  if iRc = -1 then
  begin
    sOut := 'gf_HostGateWaysngetACInfo >> not fnServerAlive 서버가 실행중인지 확인하시오.';
    Exit;
  end;

  CharCharCpy(ImpData.csTradeDate, Pchar(sDate), Sizeof(ImpData.csTradeDate));
  CharCharCpy(ImpData.csAccNo, PChar(sAccList), Sizeof(ImpData.csAccNo));
  CharCharCpy(ImpData.csFileName, PChar(sFileName), Sizeof(ImpData.csFileName));
  CharCharCpy(ImpData.csDeptCode, PChar(gvDeptCode), Sizeof(ImpData.csDeptCode));

  sImpType := gcSTYPE_IMP_AC;

   //
  iRc := fnImpDataSend(sImpType, ImpData);

  DisplaynLog('Monitor : ' + ImpData.csErrcode);
  DisplaynLog('Monitor : ' + ImpData.csErrmsg);
  DisplaynLog('Monitor : ' + ImpData.csCreYN);
  sOut := '[' + ImpData.csErrcode + ']' + ImpData.csErrmsg;

  if iRc = -1 then
  begin
    result := False;
    if Length(ImpData.csErrmsg) > 0 then
      sOut := 'gf_HostGateWaysngetFACInfo >> not fnImpDataSend [' + ImpData.csErrcode + ']' + ImpData.csErrmsg
    else
      sOut := 'gf_HostGateWaysngetFACInfo >> not fnImpDataSend HostGW가 실행중인지 확인하십시오.';
    exit;
  end;

  Result := true;

end;

//선물계좌 Import Using HostGateWay (하나대투용)
function gf_HostGateWaysngetFACInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

var
  ImpData: TCliSvrImpData;
  sImpType: string;
  iRc: Integer;
begin
  Result := false;

  gf_log('SCCLib bf SocketThread 실행중인지 체크 ');

  gvMCIFtpFileList.Clear;
  
  // 파일 생성갯수 카운트
  gvMCIFileCnt := 0;


  gf_log('gvMCIFileCnt : ' + IntToStr(gvMCIFileCnt));

   // SocketThread 실행중인지 체크
  iRc := fnMdServerAlive;
  if iRc = -1 then
  begin
    sOut := 'gf_HostGateWaysngetACInfo >> not fnServerAlive 서버가 실행중인지 확인하시오.';
    Exit;
  end;

  gf_log('csTradeDate : ' + sDate);
  gf_log('csAccNo     : ' + sAccList);
  gf_log('csFileName  : ' + sFileName);
  gf_log('csDeptCode  : ' + gvDeptCode);


  CharCharCpy(ImpData.csTradeDate, Pchar(sDate), Sizeof(ImpData.csTradeDate));
  CharCharCpy(ImpData.csAccNo, PChar(sAccList), Sizeof(ImpData.csAccNo));
  CharCharCpy(ImpData.csFileName, PChar(sFileName), Sizeof(ImpData.csFileName));
  CharCharCpy(ImpData.csDeptCode, PChar(gvDeptCode), Sizeof(ImpData.csDeptCode));


  sImpType := gcSTYPE_IMP_FAC;     // 선물계좌자료

  gf_log('sImpType : ' + gcSTYPE_IMP_FAC);

  gvMCIFtpFileList.Add(sFileName);

  gf_log('gvMCIFtpFileList.Add ');

  Inc(gvMCIFileCnt);

  gf_log('gvMCIFtpFileList.Add ');
  
   //
  gf_log('SCCLib bf fnImpDataSend ');

  iRc := fnImpDataSend(sImpType, ImpData);     //

  DisplaynLog('Monitor : ' + ImpData.csErrcode);
  DisplaynLog('Monitor : ' + ImpData.csErrmsg);
  DisplaynLog('Monitor : ' + ImpData.csCreYN);
  sOut := '[' + ImpData.csErrcode + ']' + ImpData.csErrmsg;

  if iRc = -1 then
  begin
    result := False;
    if Length(ImpData.csErrmsg) > 0 then
      sOut := 'gf_HostGateWaysngetFACInfo >> not fnImpDataSend [' + ImpData.csErrcode + ']' + ImpData.csErrmsg
    else
      sOut := 'gf_HostGateWaysngetFACInfo >> not fnImpDataSend HostGW가 실행중인지 확인하십시오.';
    exit;
  end;


  Result := true;

end;


//Upload Call
//WorkCode : 마감해제 'D', 마감 'I', 몰라요 'R'

function gf_HostCICSsnprocessUploadData(sDate, sFileName, sWorkCode: string; var sOut: string): boolean;
type
  TsnprocessUploadData = function(
    psEmpId, psCustDept, psDate, psWorkCode, psInputFile, pszOut: pchar
    ): integer; cdecl;
var
  snprocessUploadData: TsnprocessUploadData;
  DllHandle: THandle;

  caFileName: array[0..100] of char;
  caCustDept: array[0..3] of char;
  caDate: array[0..8] of char;
  caEmpId: array[0..10] of char;
  caWorkCode: array[0..1] of char;
  caOut: array[0..100] of char;

  sEmpID, sCustDept: string;
begin
  Result := false;

  sEmpID := gvOprEmpID;
  sCustDept := '0' + gvDeptCode;

  DllHandle := LoadLibrary(pChar('ESNCICS.dll'));
  if (DllHandle = HINSTANCE_ERROR) or (DllHandle = 0) then
  begin
    ShowMessage('Dll Load 오류');
    Exit;
  end;

  FillChar(caFileName, SizeOf(caFileName), #0);
  FillChar(caCustDept, SizeOf(caCustDept), #0);
  FillChar(caDate, SizeOf(caDate), #0);
  FillChar(caEmpId, SizeOf(caEmpId), #0);
  FillChar(caWorkCode, SizeOf(caWorkCode), #0);
  FillChar(caOut, SizeOf(caOut), #0);

  myStr2Char(caEmpId, sEmpId, Length(sEmpId));
  myStr2Char(caCustDept, sCustDept, Length(sCustDept));
  myStr2Char(caDate, sDate, Length(sDate));
  myStr2Char(caWorkCode, sWorkCode, Length(sWorkCode));
  myStr2Char(caFileName, sFileName, Length(sFileName));

  if caFileName[0] = #0 then caFileName[0] := ' ';

  try
    try
      @snprocessUploadData := GetProcAddress(DllHandle, pChar('snprocessUploadData'));
      if @snprocessUploadData <> nil then
      begin
        if snprocessUploadData(caEmpId, caCustDept, caDate, caWorkCode, caFileName, caOut) <> 0 then
        begin
              //ShowMessage('snprocessUploadData error:' + caOut);
          sOut := caOut;
          exit;
        end;
           //ShowMessage('snprocessUploadData OK :' + caOut);
      end;
    except
      on E: Exception do
      begin
           //ShowMessage('Except..' + E.Message);
        sOut := 'Except..' + E.Message;
        Exit;
      end;
    end;
  finally
    FreeLibrary(DllHandle);
  end;

  sOut := caOut;
  Result := true;
end;

//Upload Call
//WorkCode : 마감해제 'D', 마감 'I'

function gf_HostCICSsnprocessUploadACData(sDate, sFileName, sWorkCode: string; var sOut: string): boolean;
type
  TsnprocessUploadACData = function(
    psEmpId, psCustDept, psDate, psWorkCode, psInputFile, pszOut: pchar
    ): integer; cdecl;
var
  snprocessUploadACData: TsnprocessUploadACData;
  DllHandle: THandle;

  caFileName: array[0..100] of char;
  caCustDept: array[0..3] of char;
  caDate: array[0..8] of char;
  caEmpId: array[0..10] of char;
  caWorkCode: array[0..1] of char;
  caOut: array[0..100] of char;

  sEmpID, sCustDept: string;
begin
  Result := false;

  sEmpID := gvOprEmpID;
  sCustDept := '0' + gvDeptCode;

  DllHandle := LoadLibrary(pChar('ESNCICS.dll'));
  if (DllHandle = HINSTANCE_ERROR) or (DllHandle = 0) then
  begin
    ShowMessage('Dll Load 오류');
    Exit;
  end;

  FillChar(caFileName, SizeOf(caFileName), #0);
  FillChar(caCustDept, SizeOf(caCustDept), #0);
  FillChar(caDate, SizeOf(caDate), #0);
  FillChar(caEmpId, SizeOf(caEmpId), #0);
  FillChar(caWorkCode, SizeOf(caWorkCode), #0);
  FillChar(caOut, SizeOf(caOut), #0);

  myStr2Char(caEmpId, sEmpId, Length(sEmpId));
  myStr2Char(caCustDept, sCustDept, Length(sCustDept));
  myStr2Char(caDate, sDate, Length(sDate));
  myStr2Char(caWorkCode, sWorkCode, Length(sWorkCode));
  myStr2Char(caFileName, sFileName, Length(sFileName));

  if caFileName[0] = #0 then caFileName[0] := ' ';

  try
    try
      @snprocessUploadACData := GetProcAddress(DllHandle, pChar('snprocessUploadACData'));
      if @snprocessUploadACData <> nil then
      begin
        if snprocessUploadACData(caEmpId, caCustDept, caDate, caWorkCode, caFileName, caOut) <> 0 then
        begin
              //ShowMessage('snprocessUploadData error:' + caOut);
          sOut := caOut;
          exit;
        end;
           //ShowMessage('snprocessUploadData OK :' + caOut);
      end;
    except
      on E: Exception do
      begin
           //ShowMessage('Except..' + E.Message);
        sOut := 'Except..' + E.Message;
        Exit;
      end;
    end;
  finally
    FreeLibrary(DllHandle);
  end;

  sOut := caOut;
  Result := true;
end;

//Upload Call  (하나대투용)
//WorkCode : 마감해제 'D', 마감 'I', 몰라요 'R'

function gf_HostGateWaysnprocessUploadData(sDate, sFileName: string; var sOut: string): boolean;
var
  UpData: TCliSvrUpData;
  sImpType: string;
  iRc: Integer;
  sCmtType, sMrktDeal, sCommOrd, sPgmCall, sTradeType: string;
begin
  Result := false;

   // SocketThread 실행중인지 체크
  iRc := fnMdServerAlive;
  if iRc = -1 then
  begin
    sOut := 'gf_HostGateWaysnprocessUploadData >> not fnServerAlive 서버가 실행중인지 확인하시오.';
    Exit;
  end;

  CharCharCpy(UpData.csDeptCode, PChar(gvDeptCode), sizeof(UpData.csDeptCode));
  CharCharCpy(UpData.csOprUser, PChar(gvOprUsrNo), sizeof(UpData.csOprUser));
  CharCharCpy(UpData.csTradeDate, Pchar(sDate), sizeof(UpData.csTradeDate));
  CharCharCpy(UpData.csFileName, PChar(sFileName), Sizeof(UpData.csFileName));

   //
  iRc := fnInfoUpDataSend(UpData);

  if iRc = -1 then
  begin
    result := False;
    if Length(UpData.csErrmsg) > 0 then
      sOut := 'gf_HostGateWayCalculate >> not fnInfoUpDataSend [' + UpData.csErrcode + ']' + UpData.csErrmsg
    else
      sOut := 'gf_HostGateWayCalculate >> not fnInfoUpDataSend HostGW가 실행중인지 확인하십시오.';
    exit;
  end;

  DisplaynLog('Monitor : ' + UpData.csErrcode);
  DisplaynLog('Monitor : ' + UpData.csErrmsg);
  DisplaynLog('Monitor : ' + UpData.csCreYN);
  sOut := '[' + UpData.csErrcode + ']' + UpData.csErrmsg;

  Result := true;
end;

//고객파일 Upload Call
//WorkCode : 원장데이터삭제 'D', 파일내용 원장입력 'I'

function gf_HostCICSsnprocessReqUploadData(sClient, sOrdd, sSettd, sWorkCode, sInputFile: string; var sOut: string): boolean;
type
  TsnprocessReqUploadData = function(
    psEmpId, psCustDept, psClient, psOrdd, psSettd, psWorkCode, psInputFile, pszOut: pchar
    ): integer; cdecl;
var
  snprocessReqUploadData: TsnprocessReqUploadData;
  DllHandle: THandle;

  caFileName: array[0..100] of char; //고객파일명
  caEmpId: array[0..10] of char; //
  caCustDept: array[0..3] of char; //부서코드
  caClient: array[0..60] of char; //client명
  caOrdd: array[0..8] of char; //매매일
  caSettd: array[0..8] of char; //결제일
  caWorkCode: array[0..1] of char; //workCode
  caOut: array[0..100] of char;

  sEmpID, sCustDept: string;
begin
  Result := false;

  sEmpID := gvOprEmpID;
  sCustDept := '0' + gvDeptCode;

  DllHandle := LoadLibrary(pChar('ESNCICS.dll'));
  if (DllHandle = HINSTANCE_ERROR) or (DllHandle = 0) then
  begin
    ShowMessage('Dll Load 오류');
    Exit;
  end;

  FillChar(caFileName, SizeOf(caFileName), #0);
  FillChar(caEmpId, SizeOf(caEmpId), #0);
  FillChar(caCustDept, SizeOf(caCustDept), #0);
  FillChar(caClient, Sizeof(caClient), #0);
  FillChar(caOrdd, SizeOf(caOrdd), #0);
  FillChar(caSettd, SizeOf(caSettd), #0);
  FillChar(caWorkCode, SizeOf(caWorkCode), #0);
  FillChar(caOut, SizeOf(caOut), #0);

  myStr2Char(caEmpId, sEmpId, Length(sEmpId));
  myStr2Char(caCustDept, sCustDept, Length(sCustDept));
  myStr2Char(caClient, sClient, Length(sClient));
  myStr2Char(caOrdd, sOrdd, Length(sOrdd));
  myStr2Char(caSettd, sSettd, Length(sSettd));
//  myStr2Char(caDate    ,sDate    ,Length(sDate    ));
  myStr2Char(caWorkCode, sWorkCode, Length(sWorkCode));
  myStr2Char(caFileName, sInputFile, Length(sInputFile));

  if caFileName[0] = #0 then caFileName[0] := ' ';

  try
    try
      @snprocessReqUploadData := GetProcAddress(DllHandle, pChar('snprocessReqUploadData'));
      if @snprocessReqUploadData <> nil then
      begin
        gf_Log('[gf_CICSsnprocessReqUploadData] WorkCode = ' + caWorkCode + ' , Client = ' + caClient);
        if snprocessReqUploadData(caEmpId, caCustDept, caClient, caOrdd, caSettd, caWorkCode, caFileName, caOut) <> 0 then
        begin
          gf_Log('[gf_CICSsnprocessReqUploadData] Fail WorkCode = ' + caWorkCode + ', sOut = ' + caOut);
              //ShowMessage('snprocessUploadData error:' + caOut);
          sOut := caOut;
          exit;
        end;
           //ShowMessage('snprocessUploadData OK :' + caOut);
      end else
      begin
        gf_Log('[gf_CICSsnprocessReqUploadData]ReqUpload not found function');
        sOut := 'ReqUpload not function ';
        Exit;
      end;
    except
      on E: Exception do
      begin
           //ShowMessage('Except..' + E.Message);
        sOut := 'ReqUpload Except..' + E.Message;
        Exit;
      end;
    end;
  finally
    FreeLibrary(DllHandle);
  end;

  sOut := caOut;
  Result := true;
end;

//CICS Interface End ===========================================================

function gf_GetCommnTax(pADOQuery: TADOQuery; pTradeDate, pDeptCode, pAccNo, pHwAccNo,
  pIssueCode, pTranCode, pTradeType, pBrkShtNo, pStlDate: string; var sOutRtc: string): boolean;
var
  dQty, dAmt, dSumQty, dSumAmt, dSumComm, dSumTTax, dSumATax, dSumCTax: Double;
  dTotQty, dTotAmt, dTotAvr: double;
  dGetComm, dGetTTax, dGetATax, dGetCTax, dGetNAmt, dGetCommRate: Double;
  sOut: string;
  sHwAccTaxUse: string; //하위계좌가 비과세인지 여부
begin
  result := False;

  sOutRtc := '';
  dQty := 0;
  dAmt := 0;
  dSumQty := 0;
  dSumAmt := 0;
  dSumComm := 0;
  dSumTTax := 0;
  dSumATax := 0;
  dSumCTax := 0;

  dGetComm := 0;
  dGetTTax := 0;
  dGetATax := 0;
  dGetCTax := 0;
  dGetNAmt := 0;
  dGetCommRate := 0;

  with pADOQuery do
  begin
      //=========================================================================
      // 하위계좌의 비과세여부를 알아온다.
      //=========================================================================
    Close;
    SQL.Clear;
    SQL.Add(' SELECT   isnull(TRADE_TAX_YN,''N'') as TRADE_TAX_YN  FROM SEACBIF_TBL ' +
      ' WHERE	DEPT_CODE	 = ''' + pDeptCode + ''' ' +
      '   AND   ACC_NO       = ''' + pHwAccNo + ''' ');

    try
      gf_ADOQueryOpen(pADOQuery);
    except
      on E: Exception do
      begin
         //gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SELECT SETSPTM_TBL]: ' + E.Message, 0); //Database 오류
         //gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SELECT SETSPTM_TBL]');  //Database 오류
         //gf_RollbackTransaction;
        sOutRtc := 'ADOQuery_Temp[SELECT SEACBIF_TBL]: ' + E.Message;
        Exit;
      end;
    end;

    if RecordCount <= 0 then
    begin
      sOutRtc := 'ADOQuery_Temp[SELECT SEACBIF_TBL]: RecordCount 0 ';
      Exit;
    end;

    if Trim(FieldByName('TRADE_TAX_YN').AsString) = 'N' then
      sHwAccTaxUse := 'Y'
    else
      sHwAccTaxUse := 'N';

      //=========================================================================
      //=========================================================================

    Close;
    SQL.Clear;
    SQL.Add(' SELECT   QTY, AMT  FROM SETSPTM_TBL ' +
      ' WHERE	TRADE_DATE	 = ''' + pTradeDate + ''' ' +
      '   AND   DEPT_CODE	 = ''' + pDeptCode + ''' ' +
      '   AND   ACC_NO       = ''' + pAccNo + ''' ' +
      '   AND   HW_ACC_NO	 = ''' + pHwAccNo + ''' ' +
      '   AND   ISSUE_CODE	 = ''' + pIssueCode + ''' ' +
      '   AND   TRAN_CODE	 = ''' + pTranCode + ''' ' +
      '   AND   TRADE_TYPE	 = ''' + pTradeType + ''' ' +
      '   AND   BRK_SHT_NO   = ''' + pBrkShtNo + ''' ');

    try
      gf_ADOQueryOpen(pADOQuery);
    except
      on E: Exception do
      begin
         //gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SELECT SETSPTM_TBL]: ' + E.Message, 0); //Database 오류
         //gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SELECT SETSPTM_TBL]');  //Database 오류
         //gf_RollbackTransaction;
        sOutRtc := 'ADOQuery_Temp[SELECT SETSPTM_TBL]: ' + E.Message;
        Exit;
      end;
    end;

    if RecordCount <= 0 then
    begin
      sOutRtc := 'ADOQuery_Temp[SELECT SETSPTM_TBL]: RecordCount 0 ';
      Exit;
    end;

    dQty := FieldByName('QTY').AsFloat;
    dAmt := FieldByName('AMT').AsFloat;

    if (dQty <= 0) or (dAmt <= 0) then
    begin
      result := True;
      Exit;
    end;

    Close;
    SQL.Clear;
    SQL.Add(' SELECT   SUM(TOT_EXEC_QTY) as TOT_EXEC_QTY    ' +
      '         ,SUM(TOT_EXEC_AMT) as TOT_EXEC_AMT    ' +
      '         ,SUM(COMM) as COMM                    ' +
      '         ,SUM(TRADE_TAX) as TRADE_TAX          ' +
      '         ,SUM(AGCT_TAX)  as AGCT_TAX           ' +
      '         ,SUM(CAP_GAIN_TAX) as CAP_GAIN_TAX    ' +
      '  FROM   SETRADE_TBL                           ' +
      ' WHERE	TRADE_DATE	 = ''' + pTradeDate + ''' ' +
      '   AND   DEPT_CODE	 = ''' + pDeptCode + ''' ' +
      '   AND   ACC_NO       = ''' + pHwAccNo + ''' ' +
      '   AND   SUB_ACC_NO   = ''''  ' +
      '   AND   ISSUE_CODE	 = ''' + pIssueCode + ''' ' +
      '   AND   TRAN_CODE	 = ''' + pTranCode + ''' ' +
      '   AND   TRADE_TYPE	 = ''' + pTradeType + ''' ' +
      '   AND   BRK_SHT_NO   = ''' + pBrkShtNo + ''' ' +
      '   AND   TOT_EXEC_QTY > 0 ');

    try
      gf_ADOQueryOpen(pADOQuery);
    except
      on E: Exception do
      begin
         //gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SELECT SETSPTM_TBL]: ' + E.Message, 0); //Database 오류
         //gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SELECT SETSPTM_TBL]');  //Database 오류
         //gf_RollbackTransaction;
        sOutRtc := 'ADOQuery_Temp[SELECT SETSPTM_TBL]: ' + E.Message;
        Exit;
      end;
    end;

    if RecordCount >= 1 then
    begin
      dSumQty := FieldByName('TOT_EXEC_QTY').AsFloat;
      dSumAmt := FieldByName('TOT_EXEC_AMT').AsFloat;
      dSumComm := FieldByName('COMM').AsFloat;
      dSumTTax := FieldByName('TRADE_TAX').AsFloat;
      dSumATax := FieldByName('AGCT_TAX').AsFloat;
      dSumCTax := FieldByName('CAP_GAIN_TAX').AsFloat;
    end;

    dTotQty := dQty + dSumQty;
    dTotAmt := dAmt + dSumAmt;
    dTotAvr := dTotAmt / dTotQty; //20070814 수정

//      showmessage(FloatToStr(dTotQty) + ' , ' + FloatToStr(dTotAmt) + ' , ' + FloatToStr(dTotAvr));
    gf_log('분할 ACC_NO : ' + pHwAccNo);
    gf_log('분할 dTotQty : ' + FormatFloat('#,##0', dTotQty));
    gf_log('분할 dTotAmt : ' + FormatFloat('#,##0', dTotAmt));
    gf_log('분할 dTotAvr : ' + FormatFloat('#,##0.000000000', dTotAvr));

//2010.09.29
//자기자신에게 몰빵한 경우, 즉,
//대표와 하위계좌가 동일하고( Z계좌와 Z제거계좌)
//수량이 동일한 경우
//수수료,제세금 계산을 하지 않는다.
//따라서 당근 보정도 없다.




    if not gf_GetCommnTax2(pTradeDate, pBrkShtNo, pIssueCode, pTranCode, pTradeType, pHwAccNo, pStlDate, dTotAvr, dTotQty, dTotAmt,
      dGetComm, dGetTTax, dGetATax, dGetCTax, dGetNAmt, dGetCommRate, sOut, 'N'
      , sHwAccTaxUse) then
    begin
      sOutRtc := 'gf_CICSsncalculate Error ' + sOut;
      Exit;
    end;

    gf_log('분할 dGetComm : ' + FormatFloat('#,##0', dGetComm));
    gf_log('분할 dGetTTax : ' + FormatFloat('#,##0', dGetTTax));
    gf_log('분할 dGetCTax : ' + FormatFloat('#,##0', dGetCTax));
    gf_log('분할 dGetNAmt : ' + FormatFloat('#,##0', dGetNAmt));

    {
      if (dGetComm < dSumComm) or
         (dGetTTax < dSumTTax) or
         (dGetATax < dSumATax) or
         (dGetCTax < dSumCTax) then
      begin
         sOutRtc := 'gf_CICSsncalculate Error : 기존수수료의 합보다 작은값을 Return Error';
         Exit;
      end;

//      showmessage('ccc');

      dGetComm := dGetComm - dSumComm;
      dGetTTax := dGetTTax - dSumTTax;
      dGetATax := dGetATax - dSumATax;
      dGetCTax := dGetCTax - dSumCTax;
     }
    Close;
    SQL.Clear;
    SQL.Add(' UPDATE  SETSPTM_TBL    ' +
      '    SET  H_COMM_RATE  = ' + FloatToStr(dGetCommRate) + ',' +
      '         COMM         = ' + FloatToStr(dGetComm) + ',' +
      '         TRADE_TAX    = ' + FloatToStr(dGetTTax) + ',' +
      '         AGCT_TAX     = ' + FloatToStr(dGetATax) + ',' +
      '         CAP_GAIN_TAX = ' + FloatToStr(dGetCTax) +
      ' WHERE	TRADE_DATE	 = ''' + pTradeDate + ''' ' +
      '   AND   DEPT_CODE	 = ''' + pDeptCode + ''' ' +
      '   AND   ACC_NO       = ''' + pAccNo + ''' ' +
      '   AND   HW_ACC_NO	 = ''' + pHwAccNo + ''' ' +
      '   AND   ISSUE_CODE	 = ''' + pIssueCode + ''' ' +
      '   AND   TRAN_CODE	 = ''' + pTranCode + ''' ' +
      '   AND   TRADE_TYPE	 = ''' + pTradeType + ''' ' +
      '   AND   BRK_SHT_NO   = ''' + pBrkShtNo + ''' ');

    try

      gf_ADOExecSQL(pADOQuery);

    except
      on E: Exception do
      begin
         //gf_ShowErrDlgMessage(Self.Tag, 9001,'ADOQuery_Temp[UPDATE SETSPTM_TBL]: ' + E.Message, 0); //Database 오류
         //gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[UPDATE SETSPTM_TBL]');  //Database 오류
         //gf_RollbackTransaction;
        sOutRtc := 'ADOQuery_Temp[UPDATE SETSPTM_TBL]: ' + E.Message;
        Exit;
      end;
    end;
  end;

  result := True;
end;

// TRADE-> ORDTD SPEXE -> ORDEX COPY...  자사주문# 0  주문지# 1

function gf_CopyTradeToOrdTd(ADOQuery_Trade, ADOQuery_Ordexe: TADOQuery;
  TradeDate, DeptCode, AccNo, SubAccNo, IssueCode, TranCode, TradeType, BrkShtNo: string): boolean;
begin

   // SEORDEX_TBL DELETE // 삭제후 처리 한다... QTY = 0
  with ADOQuery_Ordexe do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' UPDATE SEORDEX_TBL '
      + ' SET EXEC_QTY = 0                             '
      + ' WHERE DEPT_CODE  = ''' + DeptCode + '''      '
      + '   AND TRADE_DATE = ''' + TradeDate + '''     '
      + '   AND ACC_NO     = ''' + AccNo + '''         '
      + '   and BRK_SHT_NO = ''' + BrkShtNo + ''' '
      + '   AND SUB_ACC_NO = ''' + SubAccNo + '''      '
      + '   AND ISSUE_CODE = ''' + IssueCode + '''     '
      + '   AND TRAN_CODE  = ''' + TranCode + '''      '
      + '   AND TRADE_TYPE = ''' + TradeType + '''     ');

    try
      gf_ADOExecSQL(ADOQuery_Ordexe);
    except
      on E: Exception do
      begin
        Result := False;
        Exit;
      end;
    end;
  end;

   // SEORDTD_TBL DELETE
  with ADOQuery_Ordexe do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' UPDATE SEORDTD_TBL                                           '
      + ' SET TOT_EXEC_QTY = 0 '
      + ' WHERE DEPT_CODE  = ''' + DeptCode + '''      '
      + '   AND TRADE_DATE = ''' + TradeDate + '''     '
      + '   AND ACC_NO     = ''' + AccNo + '''         '
      + '   and BRK_SHT_NO = ''' + BrkShtNo + ''' '
      + '   AND SUB_ACC_NO = ''' + SubAccNo + '''      '
      + '   AND ISSUE_CODE = ''' + IssueCode + '''     '
      + '   AND TRAN_CODE  = ''' + TranCode + '''      '
      + '   AND TRADE_TYPE = ''' + TradeType + '''     ');

    try
      gf_ADOExecSQL(ADOQuery_Ordexe);
    except
      on E: Exception do
      begin
        Result := False;
        Exit;
      end;
    end;
  end;

  with ADOQuery_Trade do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' SELECT TOT_EXEC_QTY, TOT_EXEC_AMT, LAST_EXEC_TIME '
      + ' From SETRADE_TBL '
      + ' Where TRADE_DATE = ''' + TradeDate + ''''
      + '   and DEPT_CODE  = ''' + DeptCode + ''''
      + '   and ACC_NO     = ''' + AccNo + ''''
      + '   and SUB_ACC_NO = ''' + SubAccNo + ''''
      + '   and BRK_SHT_NO = ''' + BrkShtNo + ''''
      + '   and ISSUE_CODE = ''' + IssueCode + ''''
      + '   and TOT_EXEC_QTY > 0 ' //총수량 0이 아닌녀석 - 0인넘은 없는 삭제된놈임
      + '   and TRAN_CODE  = ''' + TranCode + ''''
      + '   and TRADE_TYPE = ''' + TradeType + '''');
    try
      gf_ADOQueryOpen(ADOQuery_Trade);
    except
      on E: Exception do
      begin
        Result := False;
        Exit;
      end;
    end;
  end; // END WITH

  with ADOQuery_Ordexe do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' if exists (SELECT 1 FROM SEORDTD_TBL                                 '
      + ' WHERE DEPT_CODE = ''' + DeptCode + '''                  '
      + '   AND TRADE_DATE = ''' + TradeDate + '''  '
      + '   AND ACC_NO = ''' + AccNo + '''                '
      + '   AND BRK_SHT_NO = ''' + BrkShtNo + '''            '
      + '   AND SUB_ACC_NO = ''' + SubAccNo + ''' '
      + '   AND ISSUE_CODE = ''' + IssueCode + '''        '
      + '   AND TRAN_CODE = ''' + TranCode + '''          '
      + '   AND ORD_NO    = ''' + '0' + '''          '
      + '   AND TRADE_TYPE = ''' + TradeType + ''' )          '

//           + '   AND TOT_EXEC_QTY = 0  )   '
      + '   BEGIN  ');
    SQL.Add('update SEORDTD_TBL                                                 '
      + ' SET                                                                 '
     // + ' ORD_NO = ''' + DREdit_OrdNo.Text + ''', '
      + ' TOT_EXEC_QTY = ' + FloatToStr(ADOQuery_Trade.FieldByName('TOT_EXEC_QTY').AsFloat) + ', '
      //+ ' TOT_EXEC_QTY = :pTotExecQty '
      + ' TOT_EXEC_AMT = ' + FloatToStr(ADOQuery_Trade.FieldByName('TOT_EXEC_AMT').AsFloat) + ', '
      + ' INV_SHT_NO = ''' + '' + ''', '
      + ' LAST_EXEC_TIME = ''' + ADOQuery_Trade.FieldByName('LAST_EXEC_TIME').AsString + '''  '
      //+ ' INV_ORD_NO = ' + '' + '  '  ;


      + ' WHERE DEPT_CODE = ''' + DeptCode + '''                  '
      + '   AND TRADE_DATE = ''' + TradeDate + '''  '
      + '   AND ACC_NO = ''' + AccNo + '''                '
      + '   AND BRK_SHT_NO = ''' + BrkShtNo + '''            '
      + '   AND SUB_ACC_NO = ''' + SubAccNo + ''' '
      + '   AND ISSUE_CODE = ''' + IssueCode + '''        '
      + '   AND TRAN_CODE = ''' + TranCode + '''          '
      + '   AND ORD_NO    = ''' + '0' + '''          '
      + '   AND TRADE_TYPE = ''' + TradeType + '''  END   '

      + ' ELSE BEGIN ');

    SQL.Add(' Insert SEORDTD_TBL                                                 '
      + ' (TRADE_DATE, DEPT_CODE, ACC_NO, SUB_ACC_NO, ISSUE_CODE, TRAN_CODE, '
      + ' TRADE_TYPE, ORD_NO, TOT_EXEC_QTY, TOT_EXEC_AMT, INV_SHT_NO,        '
      + ' BRK_SHT_NO, LAST_EXEC_TIME)                                                        '
      + ' Values                                                             '
      + ' (:pTradeDate, :pDeptCode, :pAccNo, :pSubAccNo, :pIssueCode,        '
      + '  :pTranCode,  :pTradeType, :pOrdNo, :pTotExecQty, :pTotExecAmt,    '
      + '  :pInvShtNo,  :pBrkShtNo, :pLastExecTime)  END                        ');

    Parameters.ParamByName('pTradeDate').Value := TradeDate;
    Parameters.ParamByName('pDeptCode').Value := DeptCode;
    Parameters.ParamByName('pAccNo').Value := AccNo;
    Parameters.ParamByName('pSubAccNo').Value := SubAccNo;
    Parameters.ParamByName('pBrkShtNo').Value := BrkShtNo;
    Parameters.ParamByName('pIssueCode').Value := IssueCode;
    Parameters.ParamByName('pTranCode').Value := TranCode;
    Parameters.ParamByName('pTradeType').Value := TradeType;
    Parameters.ParamByName('pOrdNo').Value := '0';
    Parameters.ParamByName('pTotExecQty').Value := (ADOQuery_Trade.FieldByName('TOT_EXEC_QTY').AsFloat);
    Parameters.ParamByName('pTotExecAmt').Value := (ADOQuery_Trade.FieldByName('TOT_EXEC_AMT').AsFloat);
    Parameters.ParamByName('pInvShtNo').Value := '';
     // Parameters.ParamByName('pInvOrdNo').Value     := DREdit_InvOrdNo.Text;
    Parameters.ParamByName('pLastExecTime').Value := ADOQuery_Trade.FieldByName('LAST_EXEC_TIME').AsString;
    try
      gf_ADOExecSQL(ADOQuery_Ordexe);
    except
      on E: Exception do
      begin
        Result := False;
        Exit;
      end;
    end;
  end;

  with ADOQuery_Trade do
  begin
    Close;
    SQL.Clear;
    SQL.Add('   SELECT EXEC_QTY, EXEC_PRICE, EXEC_AMT, LAST_EXEC_TIME    '
      + '  FROM SESPEXE_TBL '
      + ' WHERE DEPT_CODE = ''' + DeptCode + '''                  '
      + '   AND TRADE_DATE = ''' + TradeDate + '''  '
      + '   AND ACC_NO = ''' + AccNo + '''                '
      + '   AND BRK_SHT_NO = ''' + BrkShtNo + '''            '
      + '   AND SUB_ACC_NO = ''' + SubAccNo + ''' '
      + '   AND ISSUE_CODE = ''' + IssueCode + '''        '
      + '   AND TRAN_CODE = ''' + TranCode + '''          '
      + '   AND EXEC_QTY > 0 '
      + '   AND TRADE_TYPE = ''' + TradeType + '''');
    try
      gf_ADOQueryOpen(ADOQuery_Trade);
    except
      on E: Exception do
      begin
        Result := False;
        Exit;
      end;
    end;
  end; // END WITH

  ADOQuery_Trade.First;

  while not ADOQuery_Trade.Eof do
  begin
    with ADOQuery_Ordexe do
    begin
      Close;
      SQL.Clear;
      SQL.Add(' if exists (SELECT 1 FROM SEORDEX_TBL              '
        + ' WHERE DEPT_CODE = ''' + DeptCode + '''                  '
        + '   AND TRADE_DATE = ''' + TradeDate + '''  '
        + '   AND ACC_NO = ''' + AccNo + '''                '
        + '   AND BRK_SHT_NO = ''' + BrkShtNo + '''            '
        + '   AND SUB_ACC_NO = ''' + SubAccNo + ''' '
        + '   AND ISSUE_CODE = ''' + IssueCode + '''        '
        + '   AND TRAN_CODE = ''' + TranCode + '''          '
        + '   AND EXEC_PRICE = ' + FloatToStr(ADOQuery_Trade.FieldByName('EXEC_PRICE').AsFloat) + '            '
        + '   AND ORD_NO    = ''' + '0' + '''          '
        + '   AND TRADE_TYPE = ''' + TradeType + ''' )          '

   //           + '   AND TOT_EXEC_QTY = 0  )   '
        + '   BEGIN  ');
      SQL.Add('update SEORDEX_TBL                                                 '
        + ' SET                                                                 '
        // + ' ORD_NO = ''' + DREdit_OrdNo.Text + ''', '
        + ' EXEC_QTY = ' + FloatToStr(ADOQuery_Trade.FieldByName('EXEC_QTY').AsFloat) + ', '
         //+ ' TOT_EXEC_QTY = :pTotExecQty '
        + ' EXEC_AMT = ' + FloatToStr(ADOQuery_Trade.FieldByName('EXEC_AMT').AsFloat) + ', '
        + ' LAST_EXEC_TIME = ''' + ADOQuery_Trade.FieldByName('LAST_EXEC_TIME').AsString + '''  '
         //+ ' INV_ORD_NO = ' + '' + '  '  ;

        + ' WHERE DEPT_CODE = ''' + DeptCode + '''                  '
        + '   AND TRADE_DATE = ''' + TradeDate + '''  '
        + '   AND ACC_NO = ''' + AccNo + '''                '
        + '   AND BRK_SHT_NO = ''' + BrkShtNo + '''            '
        + '   AND SUB_ACC_NO = ''' + SubAccNo + ''' '
        + '   AND ISSUE_CODE = ''' + IssueCode + '''        '
        + '   AND TRAN_CODE = ''' + TranCode + '''          '
        + '   AND EXEC_PRICE = ' + FloatToStr(ADOQuery_Trade.FieldByName('EXEC_PRICE').AsFloat) + '            '
        + '   AND ORD_NO    = ''' + '0' + '''          '
        + '   AND TRADE_TYPE = ''' + TradeType + '''  END   '

        + ' ELSE BEGIN ');

      SQL.Add(' Insert SEORDEX_TBL                                                 '
        + ' (TRADE_DATE, DEPT_CODE, ACC_NO, SUB_ACC_NO, ISSUE_CODE, TRAN_CODE, '
        + ' TRADE_TYPE, ORD_NO, EXEC_QTY, EXEC_AMT, EXEC_PRICE,        '
        + ' BRK_SHT_NO, LAST_EXEC_TIME)                                                        '
        + ' Values                                                             '
        + ' (:pTradeDate, :pDeptCode, :pAccNo, :pSubAccNo, :pIssueCode,        '
        + '  :pTranCode,  :pTradeType, :pOrdNo, :pExecQty, :pExecAmt, :pExecPrice,    '
        + '  :pBrkShtNo, :pLastExecTime)  END                        ');

      Parameters.ParamByName('pTradeDate').Value := TradeDate;
      Parameters.ParamByName('pDeptCode').Value := DeptCode;
      Parameters.ParamByName('pAccNo').Value := AccNo;
      Parameters.ParamByName('pSubAccNo').Value := SubAccNo;
      Parameters.ParamByName('pBrkShtNo').Value := BrkShtNo;
      Parameters.ParamByName('pIssueCode').Value := IssueCode;
      Parameters.ParamByName('pTranCode').Value := TranCode;
      Parameters.ParamByName('pTradeType').Value := TradeType;
      Parameters.ParamByName('pOrdNo').Value := '0';
      Parameters.ParamByName('pExecQty').Value := (ADOQuery_Trade.FieldByName('EXEC_QTY').AsFloat);
      Parameters.ParamByName('pExecAmt').Value := (ADOQuery_Trade.FieldByName('EXEC_AMT').AsFloat);
      Parameters.ParamByName('pExecPrice').Value := (ADOQuery_Trade.FieldByName('EXEC_PRICE').AsFloat);
        // Parameters.ParamByName('pInvOrdNo').Value     := DREdit_InvOrdNo.Text;
      Parameters.ParamByName('pLastExecTime').Value := ADOQuery_Trade.FieldByName('LAST_EXEC_TIME').AsString;
      try
        gf_ADOExecSQL(ADOQuery_Ordexe);
      except
        on E: Exception do
        begin
          Result := False;
          Exit;
        end;
      end;
    end;
    ADOQuery_Trade.Next;
  end; //END WHILE

  Result := True;

end;

// 선물용 TRADE-> ORDTD SPEXE -> ORDEX COPY...  자사주문# 0  주문지# 1

function gf_CopyTradeToOrdTdF(ADOQuery_Trade, ADOQuery_Ordexe: TADOQuery;
  TradeDate, DeptCode, AccNo, SubAccNo, IssueCode, TranCode, TradeType: string): boolean;
begin

   // SFORDEX_TBL DELETE // 삭제후 처리 한다... QTY = 0
  with ADOQuery_Ordexe do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' UPDATE SFFORDEX_TBL '
      + ' SET EXEC_QTY = 0                             '
      + ' WHERE DEPT_CODE  = ''' + DeptCode + '''      '
      + '   AND TRADE_DATE = ''' + TradeDate + '''     '
      + '   AND ACC_NO     = ''' + AccNo + '''         '
//            + '   and BRK_SHT_NO = ''' + BrkShtNo + ''' '
      + '   AND SUB_ACC_NO = ''' + SubAccNo + '''      '
      + '   AND ISSUE_CODE = ''' + IssueCode + '''     '
      + '   AND TRAN_CODE  = ''' + TranCode + '''      '
      + '   AND TRADE_TYPE = ''' + TradeType + '''     ');

    try
      gf_ADOExecSQL(ADOQuery_Ordexe);
    except
      on E: Exception do
      begin
        Result := False;
        Exit;
      end;
    end;
  end;

   // SFORDTD_TBL DELETE
  with ADOQuery_Ordexe do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' UPDATE SFFORDTD_TBL                                           '
      + ' SET TOT_EXEC_QTY = 0 '
      + ' WHERE DEPT_CODE  = ''' + DeptCode + '''      '
      + '   AND TRADE_DATE = ''' + TradeDate + '''     '
      + '   AND ACC_NO     = ''' + AccNo + '''         '
//            + '   and BRK_SHT_NO = ''' + BrkShtNo + ''' '
      + '   AND SUB_ACC_NO = ''' + SubAccNo + '''      '
      + '   AND ISSUE_CODE = ''' + IssueCode + '''     '
      + '   AND TRAN_CODE  = ''' + TranCode + '''      '
      + '   AND TRADE_TYPE = ''' + TradeType + '''     ');

    try
      gf_ADOExecSQL(ADOQuery_Ordexe);
    except
      on E: Exception do
      begin
        Result := False;
        Exit;
      end;
    end;
  end;

  with ADOQuery_Trade do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' SELECT TOT_EXEC_QTY, TOT_EXEC_AMT, LAST_EXEC_TIME '
      + ' From SFTRADE_TBL '
      + ' Where TRADE_DATE = ''' + TradeDate + ''''
      + '   and DEPT_CODE  = ''' + DeptCode + ''''
      + '   and ACC_NO     = ''' + AccNo + ''''
      + '   and SUB_ACC_NO = ''' + SubAccNo + ''''
//            + '   and BRK_SHT_NO = ''' + BrkShtNo + ''''
      + '   and ISSUE_CODE = ''' + IssueCode + ''''
      + '   and TOT_EXEC_QTY > 0 ' //총수량 0이 아닌녀석 - 0인넘은 없는 삭제된놈임
      + '   and TRAN_CODE  = ''' + TranCode + ''''
      + '   and TRADE_TYPE = ''' + TradeType + '''');
    try
      gf_ADOQueryOpen(ADOQuery_Trade);
    except
      on E: Exception do
      begin
        Result := False;
        Exit;
      end;
    end;
  end; // END WITH

  with ADOQuery_Ordexe do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' if exists (SELECT 1 FROM SFFORDTD_TBL                                 '
      + ' WHERE DEPT_CODE = ''' + DeptCode + '''                  '
      + '   AND TRADE_DATE = ''' + TradeDate + '''  '
      + '   AND ACC_NO = ''' + AccNo + '''                '
//           + '   AND BRK_SHT_NO = ''' + BrkShtNo + '''            '
      + '   AND SUB_ACC_NO = ''' + SubAccNo + ''' '
      + '   AND ISSUE_CODE = ''' + IssueCode + '''        '
      + '   AND TRAN_CODE = ''' + TranCode + '''          '
      + '   AND ORD_NO    = ''' + '0' + '''          '
      + '   AND TRADE_TYPE = ''' + TradeType + ''' )          '

//           + '   AND TOT_EXEC_QTY = 0  )   '
      + '   BEGIN  ');
    SQL.Add('update SFFORDTD_TBL                                                 '
      + ' SET                                                                 '
     // + ' ORD_NO = ''' + DREdit_OrdNo.Text + ''', '
      + ' TOT_EXEC_QTY = ' + FloatToStr(ADOQuery_Trade.FieldByName('TOT_EXEC_QTY').AsFloat) + ', '
      //+ ' TOT_EXEC_QTY = :pTotExecQty '
      + ' TOT_EXEC_AMT = ' + FloatToStr(ADOQuery_Trade.FieldByName('TOT_EXEC_AMT').AsFloat) + ', '
      + ' INV_SHT_NO = ''' + '' + ''', '
      + ' LAST_EXEC_TIME = ''' + ADOQuery_Trade.FieldByName('LAST_EXEC_TIME').AsString + '''  '
      //+ ' INV_ORD_NO = ' + '' + '  '  ;


      + ' WHERE DEPT_CODE = ''' + DeptCode + '''                  '
      + '   AND TRADE_DATE = ''' + TradeDate + '''  '
      + '   AND ACC_NO = ''' + AccNo + '''                '
//           + '   AND BRK_SHT_NO = ''' + BrkShtNo + '''            '
      + '   AND SUB_ACC_NO = ''' + SubAccNo + ''' '
      + '   AND ISSUE_CODE = ''' + IssueCode + '''        '
      + '   AND TRAN_CODE = ''' + TranCode + '''          '
      + '   AND ORD_NO    = ''' + '0' + '''          '
      + '   AND TRADE_TYPE = ''' + TradeType + '''  END   '

      + ' ELSE BEGIN ');

    SQL.Add(' Insert SFFORDTD_TBL                                                 '
      + ' (TRADE_DATE, DEPT_CODE, ACC_NO, SUB_ACC_NO, ISSUE_CODE, TRAN_CODE, '
      + ' TRADE_TYPE, ORD_NO, TOT_EXEC_QTY, TOT_EXEC_AMT, INV_SHT_NO,        '
      + ' LAST_EXEC_TIME)                                                        '
      + ' Values                                                             '
      + ' (:pTradeDate, :pDeptCode, :pAccNo, :pSubAccNo, :pIssueCode,        '
      + '  :pTranCode,  :pTradeType, :pOrdNo, :pTotExecQty, :pTotExecAmt,    '
      + '  :pInvShtNo,  :pLastExecTime)  END                        ');

    Parameters.ParamByName('pTradeDate').Value := TradeDate;
    Parameters.ParamByName('pDeptCode').Value := DeptCode;
    Parameters.ParamByName('pAccNo').Value := AccNo;
    Parameters.ParamByName('pSubAccNo').Value := SubAccNo;
//      Parameters.ParamByName('pBrkShtNo').Value     := BrkShtNo;
    Parameters.ParamByName('pIssueCode').Value := IssueCode;
    Parameters.ParamByName('pTranCode').Value := TranCode;
    Parameters.ParamByName('pTradeType').Value := TradeType;
    Parameters.ParamByName('pOrdNo').Value := '0';
    Parameters.ParamByName('pTotExecQty').Value := (ADOQuery_Trade.FieldByName('TOT_EXEC_QTY').AsFloat);
    Parameters.ParamByName('pTotExecAmt').Value := (ADOQuery_Trade.FieldByName('TOT_EXEC_AMT').AsFloat);
    Parameters.ParamByName('pInvShtNo').Value := '';
     // Parameters.ParamByName('pInvOrdNo').Value     := DREdit_InvOrdNo.Text;
    Parameters.ParamByName('pLastExecTime').Value := ADOQuery_Trade.FieldByName('LAST_EXEC_TIME').AsString;
    try
      gf_ADOExecSQL(ADOQuery_Ordexe);
    except
      on E: Exception do
      begin
        Result := False;
        Exit;
      end;
    end;
  end;

  with ADOQuery_Trade do
  begin
    Close;
    SQL.Clear;
    SQL.Add('   SELECT EXEC_QTY, EXEC_PRICE, EXEC_AMT, EXEC_TIME    '
      + '  FROM SFSPEXE_TBL '
      + ' WHERE DEPT_CODE = ''' + DeptCode + '''                  '
      + '   AND TRADE_DATE = ''' + TradeDate + '''  '
      + '   AND ACC_NO = ''' + AccNo + '''                '
//           + '   AND BRK_SHT_NO = ''' + BrkShtNo + '''            '
      + '   AND SUB_ACC_NO = ''' + SubAccNo + ''' '
      + '   AND ISSUE_CODE = ''' + IssueCode + '''        '
      + '   AND TRAN_CODE = ''' + TranCode + '''          '
      + '   AND EXEC_QTY > 0 '
      + '   AND TRADE_TYPE = ''' + TradeType + '''');
    try
      gf_ADOQueryOpen(ADOQuery_Trade);
    except
      on E: Exception do
      begin
        Result := False;
        Exit;
      end;
    end;
  end; // END WITH

  ADOQuery_Trade.First;

  while not ADOQuery_Trade.Eof do
  begin
    with ADOQuery_Ordexe do
    begin
      Close;
      SQL.Clear;
      SQL.Add(' if exists (SELECT 1 FROM SFFORDEX_TBL              '
        + ' WHERE DEPT_CODE = ''' + DeptCode + '''                  '
        + '   AND TRADE_DATE = ''' + TradeDate + '''  '
        + '   AND ACC_NO = ''' + AccNo + '''                '
//              + '   AND BRK_SHT_NO = ''' + BrkShtNo + '''            '
        + '   AND SUB_ACC_NO = ''' + SubAccNo + ''' '
        + '   AND ISSUE_CODE = ''' + IssueCode + '''        '
        + '   AND TRAN_CODE = ''' + TranCode + '''          '
        + '   AND EXEC_PRICE = ' + FloatToStr(ADOQuery_Trade.FieldByName('EXEC_PRICE').AsFloat) + '            '
        + '   AND ORD_NO    = ''' + '0' + '''          '
        + '   AND TRADE_TYPE = ''' + TradeType + ''' )          '

   //           + '   AND TOT_EXEC_QTY = 0  )   '
        + '   BEGIN  ');
      SQL.Add('update SFFORDEX_TBL                                                 '
        + ' SET                                                                 '
        // + ' ORD_NO = ''' + DREdit_OrdNo.Text + ''', '
        + ' EXEC_QTY = ' + FloatToStr(ADOQuery_Trade.FieldByName('EXEC_QTY').AsFloat) + ', '
         //+ ' TOT_EXEC_QTY = :pTotExecQty '
        + ' EXEC_AMT = ' + FloatToStr(ADOQuery_Trade.FieldByName('EXEC_AMT').AsFloat) + ', '
        + ' EXEC_TIME = ''' + ADOQuery_Trade.FieldByName('EXEC_TIME').AsString + '''  '
         //+ ' INV_ORD_NO = ' + '' + '  '  ;

        + ' WHERE DEPT_CODE = ''' + DeptCode + '''                  '
        + '   AND TRADE_DATE = ''' + TradeDate + '''  '
        + '   AND ACC_NO = ''' + AccNo + '''                '
//              + '   AND BRK_SHT_NO = ''' + BrkShtNo + '''            '
        + '   AND SUB_ACC_NO = ''' + SubAccNo + ''' '
        + '   AND ISSUE_CODE = ''' + IssueCode + '''        '
        + '   AND TRAN_CODE = ''' + TranCode + '''          '
        + '   AND EXEC_PRICE = ' + FloatToStr(ADOQuery_Trade.FieldByName('EXEC_PRICE').AsFloat) + '            '
        + '   AND ORD_NO    = ''' + '0' + '''          '
        + '   AND TRADE_TYPE = ''' + TradeType + '''  END   '

        + ' ELSE BEGIN ');

      SQL.Add(' Insert SFFORDEX_TBL                                                 '
        + ' (TRADE_DATE, DEPT_CODE, ACC_NO, SUB_ACC_NO, ISSUE_CODE, TRAN_CODE, '
        + ' TRADE_TYPE, ORD_NO, EXEC_QTY, EXEC_AMT, EXEC_PRICE,        '
        + ' EXEC_TIME)                                                        '
        + ' Values                                                             '
        + ' (:pTradeDate, :pDeptCode, :pAccNo, :pSubAccNo, :pIssueCode,        '
        + '  :pTranCode,  :pTradeType, :pOrdNo, :pExecQty, :pExecAmt, :pExecPrice,    '
        + '  :pExecTime)  END                        ');

      Parameters.ParamByName('pTradeDate').Value := TradeDate;
      Parameters.ParamByName('pDeptCode').Value := DeptCode;
      Parameters.ParamByName('pAccNo').Value := AccNo;
      Parameters.ParamByName('pSubAccNo').Value := SubAccNo;
//         Parameters.ParamByName('pBrkShtNo').Value     := BrkShtNo;
      Parameters.ParamByName('pIssueCode').Value := IssueCode;
      Parameters.ParamByName('pTranCode').Value := TranCode;
      Parameters.ParamByName('pTradeType').Value := TradeType;
      Parameters.ParamByName('pOrdNo').Value := '0';
      Parameters.ParamByName('pExecQty').Value := (ADOQuery_Trade.FieldByName('EXEC_QTY').AsFloat);
      Parameters.ParamByName('pExecAmt').Value := (ADOQuery_Trade.FieldByName('EXEC_AMT').AsFloat);
      Parameters.ParamByName('pExecPrice').Value := (ADOQuery_Trade.FieldByName('EXEC_PRICE').AsFloat);
        // Parameters.ParamByName('pInvOrdNo').Value     := DREdit_InvOrdNo.Text;
      Parameters.ParamByName('pExecTime').Value := ADOQuery_Trade.FieldByName('EXEC_TIME').AsString;
      try
        gf_ADOExecSQL(ADOQuery_Ordexe);
      except
        on E: Exception do
        begin
          Result := False;
          Exit;
        end;
      end;
    end;
    ADOQuery_Trade.Next;
  end; //END WHILE

  Result := True;

end;

//엑셀 OLE 가져오기, 없을 경우 실행시킴

function gf_GetExcelOleObject(bBackGround: boolean = False): Variant;
var XL: Variant;
  Excel: _Application;
//Excel : TExcelApplication;
  lcid: integer;
begin
  Result := XL;
{
  try
    XL := CreateOleObject('excel.Application');
    lcid := LOCALE_USER_DEFAULT;
    XL.Visible:= True;
//    sleep (5000);
  except

  end;
}
  try
    XL := GetActiveOleObject('excel.Application');
  except
    if bBackGround then //Back Groud로 돌릴때
      XL := CreateOleObject('excel.Application')
    else
    begin
      lcid := LOCALE_USER_DEFAULT;
      Excel := CoExcelApplication.Create;
      Excel.Visible[lcid] := True;
      try
        XL := GetActiveOleObject('excel.Application');
      except
        //
      end;
    end;
  end;

{
  try
     XL := GetActiveOleObject('excel.Application');
  except
     if bBackGround then //Back Groud로 돌릴때
       XL := CreateOleObject('excel.Application')
     else
     begin
       lcid := LOCALE_USER_DEFAULT;
       Excel := CoExcelApplication.Create;
       Excel.Visible[lcid] := True;
       try
         XL := GetActiveOleObject('excel.Application');
       except
        //
       end;
     end;
  end;
}
  Result := XL;
end;

function gf_Trunc(X: Double): Double;
var
  S: string;
begin
  Result := 0;
  S := FloattoStr(X);
  Result := trunc(StrToFloat(S));
end;

//수수료, 제세금 보정 타입 (한국H, 하나대투 D), Defalut H
//한투는 보정하고
//대투는 아무것도 안하고.
//============================================================================
//  gf_GetSystemOptionValue('HXX','H') = 'D' then //하나대투 보정안함 =======
//======================================================================
// 수수료,제세금계산시 보정까지 고려하여 계산하기.
// "수수료,제세금 보정 거래그룹" 여부를 파악후
// 보정한다.
{
 *  * 수수료보정거래그룹 이란?
 *      정상-일반과세
 *      정상-일반비과세
 *      프로그램-일반과세
 *      프로그램-일반비과세
 *      BRK_SHT_NO가 여러개 는 수수료 보정을 해야 한다.
 *      의 거래가 동시 발생한 경우 수수료계산은 합산하여 계산되어야 한다.
 * ==> 같은 종목이라도 장이 다르거나 (OTC), 매체가 다른 경우 (HTS,인터넷,일반) 보정거래그룹이 아니다.
 *
 *  * 제세금보정거래그룹 이란?
 *      수수료보정거래그룹과 달리
 *      - 매체구분을 무시한다. 즉, 장구분만 한다.
 *      - 장내단주는 세율이 다르지 않다. 장외단주나 장외거래 모두 세율이 0.5%로 동일하므로 단주여부는 보정거래그룹 구분단위가 아니다.

==> 수수료 보정을 먼저하고, 제세금보정을 한다.
==> 수수료, 제세금 보정이 끝나면 호출한 놈(tran code + brk sht no)의 수수료,제세금,결제금액을 넘겨준다
}

function gf_GetCommnTax2(pMyTradeDate, pMyBrkShtNo,
  pMyIssueCode, pMyTranCode, pMyTradeType, pMyAccNo, pMyStlDate: string;
  pMyAvrExecPrice, pMyTotExecQty, pMyTotExecAmt: double;
  var pMyComm: double; var pMyTTax: double;
  var pMyATax: double; var pMyCTax: double;
  var pMyNetAmt: double; var pMyCommRate: double; var pMsg: string; pSettleNetCommCalcYN: string;
  pHwAccTaxUse: string): boolean;
var
  //자기자신 제외한 것
  dSumQtyComm, dSumAmtComm: Double;
  dSumQtyTax, dSumAmtTax: Double;

  //수수료보정시 총합계에 대한 수수료계산 cics output, Tax관련은 제세금 보정에 사용됨.
  dComm, dTTax, dATax, dCTax: Double;
  //CICS call 위한 가라(의미없는) 변수. 수수료보정시 세금변수, 세금보정시 수수료변수는 의미없기 때문이다. 잘생각해봐~~~
  dCommGara, dTTaxGara, dATaxGara, dCTaxGara, dNetAmtGara, dMyCommRateGara: Double;

  //총합계
  dAvrExecPriceComm, dTotExecQtyComm, dTotExecAmtComm: Double;
  dAvrExecPriceTax, dTotExecQtyTax, dTotExecAmtTax: Double;

begin
  Result := False;

  gf_log('gf_GetCommnTax2 Start ----------------------------------------------');
  gf_log('@@in ACC_NO:' + pMyAccNo);
  gf_log('@@in BRK_SHT_NO:' + pMyBrkShtNo);
  gf_log('@@in ISSUE_CODE:' + pMyIssueCode);
  gf_log('@@in TRADE_TYPE:' + pMyTradeType);
  gf_log('@@in TRAN_CODE:' + pMyTranCode);

  //0. Output 초기화
  if pSettleNetCommCalcYN <> 'Y' then pMyCommRate := 0; //수수료를 직접계산할때 pMycommRate의 값을 받아오므로 초기화하면 안되지.

  pMyComm := 0;
  pMyTTax := 0;
  pMyATax := 0;
  pMyCTax := 0;
  pMyNetAmt := 0;
  pMsg := '';

  dSumQtyComm := 0;
  dSumAmtComm := 0;
  dSumQtyTax := 0;
  dSumAmtTax := 0;

  dComm := 0;
  dTTax := 0;
  dATax := 0;
  dCTax := 0;

  dCommGara := 0;
  dTTaxGara := 0;
  dATaxGara := 0;
  dCTaxGara := 0;
  dNetAmtGara := 0;
  dMyCommRateGara := 0;

  //수수료, 제세금 보정 타입 (한국H, 하나대투 D), Defalut H
  //한투는 보정하고
  //대투는 아무것도 안하고.

  //============================================================================
  if gf_GetSystemOptionValue('HXX', 'H') = 'D' then //하나대투 보정안함 =======
  begin //======================================================================
    with DataModule_SettleNet.ADOQuery_Main do
    begin
      gf_log('CommTax2 DType 수수료, 제세금 계산 Start ----------------------------------------------');
      gf_log('CommTax2 pMyTotExecAmt:' + ForMatFloat('#,##0', pMyTotExecAmt));
      gf_log('CommTax2 pMyTotExecQty:' + ForMatFloat('#,##0', pMyTotExecQty));

      if pMyTotExecQty = 0 then
      begin
        gf_log('CommTax2 수량 0');
        Result := True;
      end // if pMyTotExecQty = 0 then
      else
      begin
        pMyAvrExecPrice := pMyTotExecAmt / pMyTotExecQty; //사용안함.
        //원장에서 수수료, 제세금 계산
        if not gf_HostCallsncalculate(
          pMyTradeDate, pMyIssueCode, pMyTranCode, pMyTradeType, pMyAccNo, pMyStlDate,
          pMyAvrExecPrice, pMyTotExecQty, pMyTotExecAmt,
          //output
          dCommGara, pMyTTax, pMyATax, pMyCTax, dNetAmtGara, dMyCommRateGara, //수수료율 가라~
          pMsg) then Exit;

        //수수료 SettleNet이 계산
        //원장에서 제세금 먼저 구한후
        //수수료, 결제금액을 우리가 나중에 계산
        if pSettleNetCommCalcYN = 'Y' then
        begin
          pMyComm := gf_Trunc(pMyTotExecAmt * pMyCommRate * 0.1) * 10;
          //pMyCommRate := pMyCommRate; 수수료율은 받은 그대로
        end
        else //원장에서 수수료, 제세금 계산하면 원장에서 준 수수료율로 치환
        begin
          pMyComm := dCommGara;
          pMyCommRate := dMyCommRateGara;
        end; // if pSettleNetCommCalcYN = 'Y' then

        if pMyTradeType = 'B' then //결제금액계산, 하나대투는 결제금액 안줌.
          pMyNetAmt := pMyTotExecAmt + pMyComm
        else
          pMyNetAmt := pMyTotExecAmt - pMyComm - pMyTTax - pMyATax - pMyCTax;

      end; // if pMyTotExecQty = 0 then

      gf_log('CommTax2 pMyComm:' + ForMatFloat('#,##0', pMyComm));
      gf_log('CommTax2 pMyTTax:' + ForMatFloat('#,##0', pMyTTax));
      gf_log('CommTax2 pMyATax:' + ForMatFloat('#,##0', pMyATax));
      gf_log('CommTax2 pMyCTax:' + ForMatFloat('#,##0', pMyCTax));
      gf_log('CommTax2 pMyCommRate:' + ForMatFloat('#,##0.0000', pMyCommRate));
      gf_log('CommTax2 pMyNetAmt:' + ForMatFloat('#,##0', pMyNetAmt));
      gf_log('CommTax2 DType 수수료, 제세금 계산 End ----------------------------------------------');

    end; //with DataModule_SettleNet.ADOQuery_Main do

  end // if gf_GetSystemOptionValue('HXX','H') = 'D' then
  //============================================================================
  else //한투 보정할때 =========================================================
  begin //======================================================================

    with DataModule_SettleNet.ADOQuery_Main do
    begin
      gf_log('수수료 보정 Start ----------------------------------------------');

      //1. 수수료 보정 대상 약정구하기 : 자기자신 제외
      Close;
      SQL.Clear;
      SQL.Add(' SELECT  SUM(TOT_EXEC_QTY) as TOT_EXEC_QTY    ' +
        '        ,SUM(TOT_EXEC_AMT) as TOT_EXEC_AMT    ' +
        '        ,CNT=count(*) ' +
        ' FROM   SETRADE_TBL                          ' +
        ' WHERE	 TRADE_DATE	 = ''' + pMyTradeDate + ''' ' +
        '   AND   DEPT_CODE	 = ''' + gvDeptCode + ''' ' +
        '   AND   ACC_NO      = ''' + pMyAccNo + ''' ' +
        '   AND   SUB_ACC_NO  = ''''  ' +
        '   AND   ISSUE_CODE	 = ''' + pMyIssueCode + ''' ' +
        '   AND   TRADE_TYPE	 = ''' + pMyTradeType + ''' ' +
              //장구분은 구별한다
        '   and   substring(TRAN_CODE,1,2) =  substring(''' + pMyTranCode + ''',1,2) ' +
              //일반,단주,프로그램여부는 무시하여 한그룹으로 한다.
              //과세/비과세구분은 무시하고 매체구분별로  한그룹으로 한다
        '    and     (case substring(TRAN_CODE,4,1)                                                   ' +
        '    when ''1'' then ''A'' when ''2'' then ''3'' when ''5'' then ''B'' when ''6'' then ''C''  ' +
        '    else substring(TRAN_CODE,4,1)                                                            ' +
        '    end)                                                                                     ' +
        ' = (case substring(''' + pMyTranCode + ''',4,1)                                                ' +
        '    when ''1'' then ''A'' when ''2'' then ''3'' when ''5'' then ''B'' when ''6'' then ''C''  ' +
        '    else substring(''' + pMyTranCode + ''',4,1)                                                ' +
        '    end)                                                                                     ' +
        '    AND   ((TRAN_CODE+BRK_SHT_NO) <> (''' + pMyTranCode + pMyBrkShtNo + ''')) ' + //자기자신 제외
        '    and     TOT_EXEC_QTY > 0 '
        );

      try
        gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
      except
        on E: Exception do
        begin
          pMsg := '수수료 보정 대상 약정구하기[SELECT 합산]: ' + E.Message;
          Exit;
        end;
      end;

      if RecordCount >= 1 then
      begin
        dSumQtyComm := FieldByName('TOT_EXEC_QTY').AsFloat;
        dSumAmtComm := FieldByName('TOT_EXEC_AMT').AsFloat;
        gf_log('@@수수료 보정 나 제외 CNT ' + ForMatFloat('#,##0', FieldByName('CNT').AsFloat));
        gf_log('@@수수료 보정 나 제외 sum dSumQtyComm' + ForMatFloat('#,##0', dSumQtyComm));
        gf_log('@@수수료 보정 나 제외 sum dSumAmtComm' + ForMatFloat('#,##0', dSumAmtComm));
      end
      else
      begin
        pMsg := '수수료 보정 대상 약정구하기 오류: RecordCount = 0';
        Exit;
      end; // if RecordCount >= 1 then

      dTotExecQtyComm := dSumQtyComm + pMyTotExecQty;
      dTotExecAmtComm := dSumAmtComm + pMyTotExecAmt;
      gf_log('@@수수료 보정 나 포함 sum dTotExecQtyComm' + ForMatFloat('#,##0', dTotExecQtyComm));
      gf_log('@@수수료 보정 나 포함 sum dTotExecAmtComm' + ForMatFloat('#,##0', dTotExecAmtComm));

      if dTotExecQtyComm = 0 then
      begin
        dAvrExecPriceComm := 0;
        dComm := 0;
        pMyCommRate := 0.0;
      end // if dTotExecQtyComm = 0 then
      else
      begin
        dAvrExecPriceComm := dTotExecAmtComm / dTotExecQtyComm;

        if pSettleNetCommCalcYN = 'Y' then
        begin //수수료 SettleNet이 계산
          dComm := gf_Trunc(dTotExecAmtComm * pMyCommRate * 0.1) * 10;
        end // if pSettleNetCommCalcYN = 'Y' then
        else
        begin //원장에서 수수료 계산
          // [Y.K.J] 2011.12.20 한투 원장 신 시스템으로 가면서 이부분은 안탐.

          //수수료보정위한 수수료계산 call ==========================================
          if not gf_HostCallsncalculate(
            pMyTradeDate, pMyIssueCode, pMyTranCode, pMyTradeType, pMyAccNo, pMyStlDate,
            dAvrExecPriceComm, dTotExecQtyComm, dTotExecAmtComm, //총합산 값을 보낸다
            //output
            dComm, dTTaxGara, dATaxGara, dCTaxGara, dNetAmtGara, pMyCommRate, //총합산 값을 받는다
            pMsg) then Exit;
        end; // if pSettleNetCommCalcYN = 'Y' then else

      end; // if dTotExecQtyComm = 0 then else

      gf_log('@@수수료보정 MCA 수수료 계산후 보정그룹수수료 dComm' + ForMatFloat('#,##0', dComm));
      gf_log('@@수수료보정 MCA 수수료 계산후 보정그룹수수료 pMyCommRate' + ForMatFloat('0.000000', pMyCommRate));
      //gf_log('@@수수료보정 CICS 수수료 계산후 보정그룹수수료 dComm' + ForMatFloat('#,##0',dComm));
      //gf_log('@@수수료보정 CICS 수수료 계산후 보정그룹수수료 pMyCommRate' + ForMatFloat('0.000000',pMyCommRate));

      //SP Call & Return
      if not ExecuteCommBojung(
        gvOprUsrNo, gvDeptCode, pMyTradeDate, pMyAccNo, pMyBrkShtNo, pMyIssueCode, pMyTranCode, pMyTradeType,
        pMyTotExecAmt, dTotExecAmtComm, dComm, pMyCommRate,
        //output
        pMyComm, pMyNetAmt, pMsg) then Exit;

      gf_log('@@수수료보정 자기자신 수수료 pMyComm' + ForMatFloat('#,##0', pMyComm));
      gf_log('@@수수료보정 pMyNetAmt' + ForMatFloat('#,##0', pMyNetAmt));

      gf_log('수수료 보정 End ----------------------------------------------');


      //-- 제세금 보정 ---------------------------------------------------------
      if (pMyTradeType = 'B') or //제세금보정대상 아님
        ((RightStr(pMyTranCode, 1) <> '1') and
        (RightStr(pMyTranCode, 1) <> '2') and
        (RightStr(pMyTranCode, 1) <> '5') and
        (RightStr(pMyTranCode, 1) <> '6'))
        then
      begin
        //매수이거나 비과세는 보정대상 아님.
      end // if (pMyTradeType = 'B') or ~
      else //제세금보정 대상 =======
      begin

        gf_log('제세금 보정 Start --------------------------------------------');

        Close;
        SQL.Clear;
        SQL.Add(' SELECT  SUM(TOT_EXEC_QTY) as TOT_EXEC_QTY    ' +
          '        ,SUM(TOT_EXEC_AMT) as TOT_EXEC_AMT    ' +
          '        ,CNT=count(*) ' +
          '  FROM   SETRADE_TBL                          ' +
          ' WHERE	 TRADE_DATE	 = ''' + pMyTradeDate + ''' ' +
          '   AND   DEPT_CODE	 = ''' + gvDeptCode + ''' ' +
          '   AND   ACC_NO      = ''' + pMyAccNo + ''' ' +
          '   AND   SUB_ACC_NO  = ''''  ' +
          '   AND   ISSUE_CODE	 = ''' + pMyIssueCode + ''' ' +
          '   AND   TRADE_TYPE	 = ''' + pMyTradeType + ''' ' +
                //장구분은 구별한다
          '   and   substring(TRAN_CODE,1,2) =  substring(''' + pMyTranCode + ''',1,2) ' +
                //일반,단주,프로그램여부는 무시하여 한그룹으로 한다.
                //매체구분을 무시하고 과세만 대상으로 한그룹으로 한다.
                //substring(TRAN_CODE,4,1)이 1,2,5,6인 과세만을 대상으로 함.
          '    and     substring(TRAN_CODE,4,1) in (''1'',''2'',''5'',''6'')   ' +
          '    and     substring(TRAN_CODE,4,1) in (''1'',''2'',''5'',''6'')   ' +
          '    AND   ((TRAN_CODE+BRK_SHT_NO) <> (''' + pMyTranCode + pMyBrkShtNo + ''')) ' + //자기자신 제외
          '    and     TOT_EXEC_QTY > 0 '
          );

        try
          gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
        except
          on E: Exception do
          begin
            pMsg := '제세금 보정 대상 약정구하기[SELECT 합산]: ' + E.Message;
            Exit;
          end;
        end;

        if RecordCount >= 1 then
        begin
          dSumQtyTax := FieldByName('TOT_EXEC_QTY').AsFloat;
          dSumAmtTax := FieldByName('TOT_EXEC_AMT').AsFloat;
          gf_log('@@제세금 보정 나 제외 CNT ' + ForMatFloat('#,##0', FieldByName('CNT').AsFloat));
          gf_log('@@제세금 보정 나 제외 sum dSumQtyTax' + ForMatFloat('#,##0', dSumQtyTax));
          gf_log('@@제세금 보정 나 제외 sum dSumAmtTax' + ForMatFloat('#,##0', dSumAmtTax));
        end // if RecordCount >= 1 then
        else
        begin
          pMsg := '제세금 보정 대상 약정구하기 오류: RecordCount = 0';
          Exit;
        end; // if RecordCount >= 1 then else

        dTotExecQtyTax := dSumQtyTax + pMyTotExecQty;
        dTotExecAmtTax := dSumAmtTax + pMyTotExecAmt;
        gf_log('@@제세금 보정 나 포함 sum dTotExecQtyTax' + ForMatFloat('#,##0', dTotExecQtyTax));
        gf_log('@@제세금 보정 나 포함 sum dTotExecAmtTax' + ForMatFloat('#,##0', dTotExecAmtTax));

        if dTotExecQtyTax = 0 then
        begin
          dAvrExecPriceTax := 0;
          dTTax := 0;
          dATax := 0;
          dCTax := 0;
        end // if dTotExecQtyTax = 0 then
        else
        begin
          dAvrExecPriceTax := dTotExecAmtTax / dTotExecQtyTax;

          //제세금보정위한 수수료계산 call ==========================================
          if not gf_HostCallsncalculate(
            pMyTradeDate, pMyIssueCode, pMyTranCode, pMyTradeType, pMyAccNo, pMyStlDate,
            dAvrExecPriceTax, dTotExecQtyTax, dTotExecAmtTax, //총합산 값을 보낸다
            //output
            dCommGara, dTTax, dATax, dCTax, dNetAmtGara, dMyCommRateGara, //총합산 값을 받는다
            pMsg) then Exit;

          //============================================================================================
          // 대표계좌분할일때만, 해준다.
          // 법인부는 계좌에따라서 같은 종목에 대해서 과세매매, 비과세매매가 자유자재로 발생할 수 있지만...
          // 국제부는 계좌에따라서 모든 종목에 대해서 과세, 비과세가 고정되어 있다. (계좌과세여부: TRADE_TAX_YN)
          //============================================================================================
          if pHwAccTaxUse = 'Y' then
          begin
            gf_log('@@대표계좌분할시만 해당@@ ');
            gf_log('@@비과세계좌로 세금 0으로 [dTTax, dATax, dCTax] = 0 ');
            dTTax := 0;
            dATax := 0;
            dCTax := 0;
          end; // if pHwAccTaxUse = 'Y' then
        end; // if dTotExecQtyTax = 0 then else

        gf_log('@@제세금보정 CICS 제세금 계산후 보정그룹거래세 dTTax' + ForMatFloat('#,##0', dTTax));
        gf_log('@@제세금보정 CICS 제세금 계산후 보정그룹농특세 dATax' + ForMatFloat('0.000000', dATax));
        gf_log('@@제세금보정 CICS 제세금 계산후 보정그룹양도세 dCTax' + ForMatFloat('0.000000', dCTax));

        //SP Call & Return
        if not ExecuteTaxBojung(
          gvOprUsrNo, gvDeptCode, pMyTradeDate, pMyAccNo, pMyBrkShtNo, pMyIssueCode, pMyTranCode, pMyTradeType,
          pMyTotExecAmt, pMyComm, dTotExecAmtTax, dTTax, dATax, dCTax,
          //output
          pMyTTax, pMyATax, pMyCTax, pMyNetAmt, pMsg) then Exit;

        gf_log('@@제세금보정 pMyTTax' + ForMatFloat('#,##0', pMyTTax));
        gf_log('@@제세금보정 pMyATax' + ForMatFloat('#,##0', pMyATax));
        gf_log('@@제세금보정 pMyCTax' + ForMatFloat('#,##0', pMyCTax));
        gf_log('@@제세금보정 pMyNetAmt' + ForMatFloat('#,##0', pMyNetAmt));

        gf_log('제세금 보정 End ----------------------------------------------');

      end; // if (pMyTradeType = 'B') or ~ else

    end; // with DataModule_SettleNet.ADOQuery_Main do

  end; //보정할시

  Result := True;

end;

function gf_HostCallsncalculate(
  sTrdDate, sIssueCode, sTranCode, sTrdType,
  sAccNo, sStlDate: string; dAvrExecPrice, dTotExecQty, dTotExecAmt: double;
  var dComm: double; var dTrdTax: double; var dAgcTax: double;
  var dCpgTax: double; var dNetAmt: double; var dHCommRate: double;
  var sOut: string): boolean;
begin

  result := False;
   // 하나대투
  if gvHostGWUseYN = 'Y' then
  begin
    if not gf_HostGateWayCalculate(sTrdDate, sIssueCode, sTranCode, sTrdType,
      sAccNo, sStlDate, dAvrExecPrice, dTotExecQty, dTotExecAmt,
      dComm, dTrdTax, dAgcTax,
      dCpgTax, dNetAmt, dHCommRate, sOut) then Exit;
  end else
   // 한국증권
  begin
      //----------------------------------------------------------------------------
      // Connect MCA
      //----------------------------------------------------------------------------
    if not gf_tf_HostMCAConnect(False, sOut) then
    begin
      gf_ShowErrDlgMessage(0, 0, 'MCA 접속 에러.'
        + #13#10 + #13#10 + sOut, 0);
      Exit;
    end;

    if not gf_tf_HostMCACalculate(sIssueCode, sTranCode, sTrdType,
      sAccNo, sStlDate, dAvrExecPrice, dTotExecQty, dTotExecAmt,
      dComm, dTrdTax, dAgcTax,
      dCpgTax, dNetAmt, dHCommRate, sOut) then Exit;
      {if not gf_HostCICSCalculate(sIssueCode,sTranCode,sTrdType,
                         sAccNo,sStlDate,dAvrExecPrice,dTotExecQty,dTotExecAmt,
                         dComm,dTrdTax,dAgcTax,
                         dCpgTax,dNetAmt,dHCommRate,sOut) then Exit;}
  end;

  result := True;

end;

function gf_HostGateWayCalculate(
  pTrdDate, pIssueCode, pTranCode, pTrdType,
  pAccNo, pStlDate: string; dAvrExecPrice, dTotExecQty, dTotExecAmt: double;
  var dComm: double; var dTrdTax: double; var dAgcTax: double;
  var dCpgTax: double; var dNetAmt: double; var dHCommRate: double;
  var sOut: string): boolean;

var
  CommData: TCliSvrComData;
  sCd: string;
  sCmtType, sMrktDeal, sCommOrd, sPgmCall, sTradeType: string;
  sAccNo: string;

  nErrcode: Integer;
  irc: Integer;

  //-- 하나대투 매체코드 가져오기 ----------------------------------------------
  function GetComCode(pComType: string): string;
  begin
    Result := '';

    with DataModule_SettleNet.ADOQuery_Main do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select ETC1 ');
      SQL.Add('from SUGRPCD_TBL ');
      SQL.Add('WHERE GRP = ''16'' ');
      SQL.Add('  AND CD = ''' + pComType + ''' ');

      gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

      Result := Trim(FieldByName('ETC1').asString);
    end; // end of with

  end; //-- 하나대투 매체코드 가져오기 -----------------------------------------

begin
  Result := false;
   // SocketThread 실행중인지 체크
  irc := fnMdServerAlive;
  if irc = -1 then
  begin
    sOut := 'gf_HostGateWayCalculate >> not fnServerAlive HostGW가 실행중인지 확인하십시오.';
    Exit;
  end;

  // 계좌번호 체계(11): 계좌번호(8) + 계좌상품코드(3)
  //계좌상품코드
  sCmtType := Copy(pAccNo,9,3);

  //시장거래구분
  sCd := Copy(pTranCode, 2, 1);
  if sCd = '1' then sMrktDeal := gcHanaMCI_Mrkt_KSP else
  if sCd = '2' then sMrktDeal := gcHanaMCI_Mrkt_KSD else
  if sCd = '3' then sMrktDeal := gcHanaMCI_Mrkt_FRE else
  if sCd = 'A' then sMrktDeal := gcHanaMCI_Mrkt_OTC else
                    sMrktDeal := gcHanaMCI_Mrkt_All;
  //통신매체구분
  sCd := Copy(pTranCode, 4, 1);
  sCommOrd := GetComCode(sCd);

  //프로그램호가구분 (프로그램구분 우선적으로)
  sCd := Copy(pTranCode, 3, 1);
  if sCd = '4' then sPgmCall := gcHanaMCI_Pgmc_Pgm else
                    sPgmCall := gcHanaMCI_Pgmc_Gen;

   //매매구분
  if pTrdType = gcTRADE_SELL then
    sTradeType := '1'
  else
    sTradeType := '2';

  CharCharCpy(CommData.csTradeDate,  Pchar(pTrdDate),   sizeof(CommData.csTradeDate));
  CharCharCpy(CommData.csAccNo,      PChar(pAccNo),     Sizeof(CommData.csAccNo));
  CharCharCpy(CommData.csCmtType,    PChar(sCmttype),   Sizeof(CommData.csCmtType));
  CharCharCpy(@CommData.csMrktDeal,  PChar(sMrktDeal),  Sizeof(CommData.csMrktDeal));
  CharCharCpy(CommData.csIssueCode,  PChar(pIssueCode), Sizeof(CommData.csIssueCode));
  CharCharCpy(@CommData.csTradeType, pchar(sTradeType), Sizeof(CommData.csTradeType));
  CharCharCpy(CommData.csCommOrd,    PChar(sCommOrd),   Sizeof(CommData.csCommOrd));
  CharCharCpy(CommData.csPgmCall,    PChar(sPgmCall),   Sizeof(CommData.csPgmCall));
  CharCharCpy(CommData.cnAmt,        PChar(FloatToStr(dTotExecAmt)), Sizeof(CommData.cnAmt));

  // 수수료내놔~~~!!
  irc := fnComDataSend(CommData);

  if irc = -1 then
  begin
    result := False;
    if Length(CommData.csErrmsg) > 0 then
      sOut := 'gf_HostGateWayCalculate >> not fnComDataSend [' + CommData.csErrcode + ']' + Trim(CommData.csErrmsg)
    else
      sOut := 'gf_HostGateWayCalculate >> not fnComDataSend HostGW가 실행중인지 확인하십시오.';
    exit;
  end;

  DisplaynLog('Monitor : ' + CommData.csErrcode);
  DisplaynLog('Monitor : ' + CommData.csErrmsg);
  DisplaynLog('Monitor : ' + CommData.cnComm);
  DisplaynLog('Monitor : ' + CommData.cnTTax);
  DisplaynLog('Monitor : ' + CommData.cnATax);
  DisplaynLog('Monitor : ' + CommData.cnCommRate);
  DisplaynLog('Monitor : ' + CommData.cnCommAdd);

  dComm := StrToFloat(CommData.cnComm);
  dTrdTax := StrToFloat(CommData.cnTTax);
  dAgcTax := StrToFloat(CommData.cnATax);
  dHCommRate := StrToFloat(CommData.cnCommRate);
  sOut := '[' + CommData.csErrcode + ']' + CommData.csErrmsg;

  Result := true;
end;


//수수료 보정위한 SP Call

function ExecuteCommBojung(
  in_user_id, in_dept_code, in_trade_date, in_acc_no,
  in_brk_sht_no, in_issue_code, in_tran_code, in_trade_type: string;
  in_my_amt, in_tot_amt, in_tot_comm, in_comm_rate: double;
  var out_comm: double; var out_netamt: double; var sMsg: string
  ): boolean;
begin
  Result := False;

  out_comm := 0;
  sMsg := '';

  with DataModule_SettleNet.ADOSP_CommBojung do
  begin
    Parameters.ParamByName('@in_user_id').Value := in_user_id;
    Parameters.ParamByName('@in_dept_code').Value := in_dept_code;
    Parameters.ParamByName('@in_trade_date').Value := in_trade_date;
    Parameters.ParamByName('@in_acc_no').Value := in_acc_no;
    Parameters.ParamByName('@in_brk_sht_no').Value := in_brk_sht_no;
    Parameters.ParamByName('@in_issue_code').Value := in_issue_code;
    Parameters.ParamByName('@in_tran_code').Value := in_tran_code;
    Parameters.ParamByName('@in_trade_type').Value := in_trade_type;
    Parameters.ParamByName('@in_my_amt').Value := in_my_amt;

    Parameters.ParamByName('@in_tot_amt').Value := in_tot_amt;
    Parameters.ParamByName('@in_tot_comm').Value := in_tot_comm;
    Parameters.ParamByName('@in_comm_rate').Value := in_comm_rate;

    try
      Execute;
    except
      on E: Exception do
      begin
        sMsg := 'SBPCommBojung: ' + E.Message; //gf_ShowErrDlgMessage(0, 0,'SBPCommTaxBojung: ' + E.Message,0);
        Exit;
      end;
    end;

    if Trim(Parameters.ParamByName('@out_rtc').Value) <> '' then
      sMsg := 'SBPCommBojung: ' +
        Trim(Parameters.ParamByName('@out_kor_msg').Value);

    if Parameters.ParamByName('@RETURN_VALUE').Value <> 1 then
      sMsg := sMsg + #13#10 + 'SBPCommBojung: 알수없는오류 Return Value <> 1';

    if (Trim(Parameters.ParamByName('@out_rtc').Value) <> '') or
      (Parameters.ParamByName('@RETURN_VALUE').Value <> 1) then
    begin
      Exit;
    end;

    out_comm := Parameters.ParamByName('@out_comm').Value;
    out_netamt := Parameters.ParamByName('@out_netamt').Value;

  end; //with
  Result := True;
end;

//제세금 보정위한 SP Call

function ExecuteTaxBojung(
  in_user_id, in_dept_code, in_trade_date, in_acc_no,
  in_brk_sht_no, in_issue_code, in_tran_code, in_trade_type: string;
  in_my_amt, in_my_comm, in_tot_amt,
  in_tot_ttax, in_tot_atax, in_tot_ctax: double;
  var out_ttax: double; var out_atax: double;
  var out_ctax: double; var out_netamt: double; var sMsg: string
  ): boolean;
begin
  Result := False;

  sMsg := '';

  with DataModule_SettleNet.ADOSP_TaxBojung do
  begin
    Parameters.ParamByName('@in_user_id').Value := in_user_id;
    Parameters.ParamByName('@in_dept_code').Value := in_dept_code;
    Parameters.ParamByName('@in_trade_date').Value := in_trade_date;
    Parameters.ParamByName('@in_acc_no').Value := in_acc_no;
    Parameters.ParamByName('@in_brk_sht_no').Value := in_brk_sht_no;
    Parameters.ParamByName('@in_issue_code').Value := in_issue_code;
    Parameters.ParamByName('@in_tran_code').Value := in_tran_code;
    Parameters.ParamByName('@in_trade_type').Value := in_trade_type;
    Parameters.ParamByName('@in_my_amt').Value := in_my_amt;
    Parameters.ParamByName('@in_my_comm').Value := in_my_comm;

    Parameters.ParamByName('@in_tot_amt').Value := in_tot_amt;
    Parameters.ParamByName('@in_tot_ttax').Value := in_tot_ttax;
    Parameters.ParamByName('@in_tot_atax').Value := in_tot_atax;
    Parameters.ParamByName('@in_tot_ctax').Value := in_tot_ctax;

    try
      Execute;
    except
      on E: Exception do
      begin
        sMsg := 'SBPTaxBojung: ' + E.Message; //gf_ShowErrDlgMessage(0, 0,'SBPCommTaxBojung: ' + E.Message,0);
        Exit;
      end;
    end;

    if Trim(Parameters.ParamByName('@out_rtc').Value) <> '' then
      sMsg := 'SBPTaxBojung: ' +
        Trim(Parameters.ParamByName('@out_kor_msg').Value);

    if Parameters.ParamByName('@RETURN_VALUE').Value <> 1 then
      sMsg := sMsg + #13#10 + 'SBPTaxBojung: 알수없는오류 Return Value <> 1';

    if (Trim(Parameters.ParamByName('@out_rtc').Value) <> '') or
      (Parameters.ParamByName('@RETURN_VALUE').Value <> 1) then
    begin
      Exit;
    end;

    out_ttax := Parameters.ParamByName('@out_ttax').Value;
    out_atax := Parameters.ParamByName('@out_atax').Value;
    out_ctax := Parameters.ParamByName('@out_ctax').Value;
    out_netamt := Parameters.ParamByName('@out_netamt').Value;
  end; //with
  Result := True;
end;

//그리드는 0부터시작
//엑셀은 A부터시작
//그리드가 26개를 초과시 AA, AB 로 나타남

function GridColToXLCol(iCol: integer): string;
var ii: integer;
  s: string;
begin
  if iCol <= 25 then
  begin
    Result := char(iCol + 65);
    Exit;
  end;

  if iCol > 25 then
  begin
    ii := trunc(iCol / 26);
    s := GridColToXLCol(ii - 1);
    Result := s + GridColToXLCol(iCol - (26 * ii));
  end;
end;

function gf_ExecQuery(pSQL: string): Boolean;
begin
  Result := False;
  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    SQL.Add(pSQL);
    try
      gf_ADOExecSQL(DataModule_SettleNet.ADOQuery_Main);
    except
      on E: Exception do
      begin
        raise Exception.Create('ADOQuery_Main:' + E.Message);
        Exit;
      end;
    end;
  end;
  Result := True;
end;

procedure gfSetDWNeverUpload;
//var Reg : TRegistry;
begin
{
  try
    try
      Reg := TRegistry.Create;
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey('\Software\Policies\Microsoft\Office\10\Common', true) then
      begin
        Reg.WriteInteger('DWNeverUpload', 1);

        Reg.CloseKey;
      end;
      if Reg.OpenKey('\Software\Policies\Microsoft\Office\11\Common', true) then
      begin
        Reg.WriteInteger('DWNeverUpload', 1);

        Reg.CloseKey;
      end;
      //else 오픈 못함, //Registry Read / Write 권한이 없을때 그냥 소리없이 사라지자. 외국계땜시.
    except //Registry Read / Write 권한이 없을때 그냥 소리없이 사라지자. 외국계땜시.
    end;
  finally
    Reg.Free;
  end;
}
//위 레지스트리처리가 안먹네...아래는 파일 삭제 방법. 덜 멋스럽다.
  gf_Log('before delete DW20.exe');
  try
    if FileExists('C:\Program Files\Common Files\Microsoft Shared\DW\DW20.EXE') then
    begin
      deletefile('C:\Program Files\Common Files\Microsoft Shared\DW\DW20.EXE');
    end;
  except
    on E: Exception do
    begin
      gf_log('Delete DW20.exe Except:' + E.Message);
    end;
  end;
  gf_Log('before delete DW20.exe');

end;

function gf_RoundTo(AValue: Double; ADigit: Double): Double;
var
  position: Double;

begin
  if AValue = 0 then
  begin
    Result := 0;
    Exit;
  end;
  ADigit := ADigit * -1;
  position := Power(10, ADigit);
  result := gf_Trunc(AValue * position + 0.5) / position;
end;

// 올림
Function gf_CeilingTo(AValue: Double; ADigit : Double) : Double;
var
   position : Double;
begin
   if AValue = 0 then
   begin
      Result := 0;
      Exit;
   end;
   ADigit := ADigit * -1;
   position := Power(10,ADigit);
   result := gf_Trunc(AValue * position + 0.9) / position;
end;
//선물 계좌 Import Using CICS

function gf_HostCICSsngetFACInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;
type
  TsngetFACInfo = function(
    psEmpId, psCustDept, psDate: pchar;
    ppsAccNo: ppchar; psFileName, pszOut: pchar
    ): integer; cdecl;
var
  sngetFACInfo: TsngetFACInfo;
  DllHandle: THandle;

  caFileName: array[0..30] of char;
  caCustDept: array[0..3] of char;
  caDate: array[0..8] of char;
  caEmpId: array[0..10] of char;
  caOut: array[0..100] of char;
  pcaAccNo: array[0..1000] of PChar;
  caaAccNo: array[0..1000, 0..20] of char;

  i, j: integer;
  sEmpID, sCustDept: string;
begin
  Result := false;

  sEmpID := gvOprEmpID;
  sCustDept := '0' + gvDeptCode;

  DllHandle := LoadLibrary(pChar('ESNCICS.dll'));
  if (DllHandle = HINSTANCE_ERROR) or (DllHandle = 0) then
  begin
    ShowMessage('Dll Load 오류');
    Exit;
  end;

  FillChar(caFileName, SizeOf(caFileName), #0);
  FillChar(caCustDept, SizeOf(caCustDept), #0);
  FillChar(caDate, SizeOf(caDate), #0);
  FillChar(caEmpId, SizeOf(caEmpId), #0);
  FillChar(caOut, SizeOf(caOut), #0);
  FillChar(caaAccNo, SizeOf(caaAccNo), #0);

  myStr2Char(caEmpId, sEmpId, Length(sEmpId));
  myStr2Char(caCustDept, sCustDept, Length(sCustDept));
  myStr2Char(caDate, sDate, Length(sDate));
  myStr2Char(caFileName, sFileName, Length(sFileName));

  if caDate[0] = #0 then caDate[0] := ' ';

  if sAccList > '' then
  begin
    i := 0;
    while (sAccList > '') do
    begin
      j := Pos(',', sAccList);
      if j <= 0 then break;
      myStr2Char(caaAccNo[i], LeftStr(sAccList, j - 1), Length(LeftStr(sAccList, j - 1)));
      sAccList := Copy(sAccList, j + 1, Length(sAccList) - j);
      inc(i);
    end;

    for i := i to 4 do
    begin
      caaAccNo[i][0] := ' '; //없을때 5개까지 Space처리하기로 함.
    end;
  end
  else
  begin
//    ShowMessage('해당 그룹의 계좌가 존재하지 않습니다.');
//    Exit;
    caaAccNo[0][0] := ' '; //없을때 5개까지 Space처리하기로 함.
    caaAccNo[1][0] := ' ';
    caaAccNo[2][0] := ' ';
    caaAccNo[3][0] := ' ';
    caaAccNo[4][0] := ' ';
  end;

  for i := 0 to High(caaAccNo) do
  begin
    if caaAccNo[i][0] = #0 then
    begin
      pcaAccNo[i] := #0;
      break;
    end
    else
      pcaAccNo[i] := caaAccNo[i];
  end;

  try
    try
      @sngetFACInfo := GetProcAddress(DllHandle, pChar('sngetFACInfo'));
      if @sngetFACInfo <> nil then
      begin
        if sngetFACInfo(caEmpId, caCustDept, caDate, ppchar(@pcaAccNo), caFileName, caOut) <> 0 then
        begin
              //ShowMessage('sngetFACInfo error:' + caOut);
          sOut := caOut;
          exit;
        end;
           //ShowMessage('sngetFACInfo OK :' + caOut);
      end;
    except
      on E: Exception do
      begin
           //ShowMessage('Except..' + E.Message);
        sOut := 'Except..' + E.Message;
        Exit;
      end;
    end;
  finally
    FreeLibrary(DllHandle);
  end;

  sOut := caOut;
  Result := true;
end;

//선물 매매 Import Using CICS

function gf_HostCICSsngetFTRInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;
type
  TsngetFTRInfo = function(
    psEmpId, psCustDept, psDate: pchar;
    ppsAccNo: ppchar; psFileName, pszOut: pchar
    ): integer; cdecl;

var
  i, j: integer;
  sngetFTRInfo: TsngetFTRInfo;
  DllHandle: THandle;

  caFileName: array[0..30] of char;
  caCustDept: array[0..3] of char;
  caDate: array[0..8] of char;
  pcaAccNo: array[0..1000] of PChar;
  caaAccNo: array[0..1000, 0..20] of char;
  caEmpId: array[0..10] of char;
  caOut: array[0..100] of char;

  sEmpID, sCustDept: string;
begin
  Result := false;

  sEmpID := gvOprEmpID;
  sCustDept := '0' + gvDeptCode;

  DllHandle := LoadLibrary(pChar('ESNCICS.dll'));
  if (DllHandle = HINSTANCE_ERROR) or (DllHandle = 0) then
  begin
    ShowMessage('Dll Load 오류');
    Exit;
  end;

  FillChar(caFileName, SizeOf(caFileName), #0);
  FillChar(caCustDept, SizeOf(caCustDept), #0);
  FillChar(caDate, SizeOf(caDate), #0);
  FillChar(caaAccNo, SizeOf(caaAccNo), #0);
  FillChar(caEmpId, SizeOf(caEmpId), #0);
  FillChar(caOut, SizeOf(caOut), #0);

  myStr2Char(caEmpId, sEmpId, Length(sEmpId));
  myStr2Char(caCustDept, sCustDept, Length(sCustDept));
  myStr2Char(caDate, sDate, Length(sDate));
  myStr2Char(caFileName, sFileName, Length(sFileName));

  if sAccList > '' then
  begin
    i := 0;
    while (sAccList > '') do
    begin
      j := Pos(',', sAccList);
      if j <= 0 then break;
      myStr2Char(caaAccNo[i], LeftStr(sAccList, j - 1), Length(LeftStr(sAccList, j - 1)));
      sAccList := Copy(sAccList, j + 1, Length(sAccList) - j);
      inc(i);
    end;

    for i := i to 4 do
    begin
      caaAccNo[i][0] := ' '; //없을때 5개까지 Space처리하기로 함.
    end;
  end
  else
  begin
//    ShowMessage('해당 그룹의 계좌가 존재하지 않습니다.');
//    Exit;
    caaAccNo[0][0] := ' '; //없을때 5개까지 Space처리하기로 함.
    caaAccNo[1][0] := ' ';
    caaAccNo[2][0] := ' ';
    caaAccNo[3][0] := ' ';
    caaAccNo[4][0] := ' ';
  end;

  for i := 0 to High(caaAccNo) do
  begin
    if caaAccNo[i][0] = #0 then
    begin
      pcaAccNo[i] := #0;
      break;
    end
    else
      pcaAccNo[i] := caaAccNo[i];
  end;

{
  pcaAccNo[0] := StrNew('1223311');
  pcaAccNo[1] := StrNew('1223312');
  pcaAccNo[2] := nil;
}
  try
    try
      @sngetFTRInfo := GetProcAddress(DllHandle, pChar('sngetFTRInfo'));
      if @sngetFTRInfo <> nil then
      begin
        if sngetFTRInfo(caEmpId, caCustDept, caDate, ppchar(@pcaAccNo), caFileName, caOut) <> 0 then
        begin
              //ShowMessage('sngetFTRInfo error:' + caOut);
          sOut := caOut;
          exit;
        end;
           //ShowMessage('sngetFTRInfo OK :' + caOut);
      end;
    except
      on E: Exception do
      begin
           //ShowMessage('Except..' + E.Message);
        sOut := 'Except..' + E.Message;
        Exit;
      end;
    end;
  finally
    FreeLibrary(DllHandle);
  end;

//  StrDispose(pcaAccNo[0]);
//  StrDispose(pcaAccNo[1]);

  sOut := caOut;
  Result := true;
end;

//예탁자료 생성 Call

function gf_HostCICSsngetFDPInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;
type
  TsngetFDPInfo = function(
    psEmpId, psCustDept, psDate: pchar;
    ppsAccNo: ppchar; psFileName, pszOut: pchar
    ): integer; cdecl;

var
  i, j: integer;
  sngetFDPInfo: TsngetFDPInfo;
  DllHandle: THandle;

  caFileName: array[0..30] of char;
  caCustDept: array[0..3] of char;
  caDate: array[0..8] of char;
  pcaAccNo: array[0..1000] of PChar;
  caaAccNo: array[0..1000, 0..20] of char;
  caEmpId: array[0..10] of char;
  caOut: array[0..100] of char;

  sEmpID, sCustDept: string;
begin
  Result := false;

  sEmpID := gvOprEmpID;
  sCustDept := '0' + gvDeptCode;

  DllHandle := LoadLibrary(pChar('ESNCICS.dll'));
  if (DllHandle = HINSTANCE_ERROR) or (DllHandle = 0) then
  begin
    ShowMessage('Dll Load 오류');
    Exit;
  end;

  FillChar(caFileName, SizeOf(caFileName), #0);
  FillChar(caCustDept, SizeOf(caCustDept), #0);
  FillChar(caDate, SizeOf(caDate), #0);
  FillChar(caaAccNo, SizeOf(caaAccNo), #0);
  FillChar(caEmpId, SizeOf(caEmpId), #0);
  FillChar(caOut, SizeOf(caOut), #0);

  myStr2Char(caEmpId, sEmpId, Length(sEmpId));
  myStr2Char(caCustDept, sCustDept, Length(sCustDept));
  myStr2Char(caDate, sDate, Length(sDate));
  myStr2Char(caFileName, sFileName, Length(sFileName));

  if sAccList > '' then
  begin
    i := 0;
    while (sAccList > '') do
    begin
      j := Pos(',', sAccList);
      if j <= 0 then break;
      myStr2Char(caaAccNo[i], LeftStr(sAccList, j - 1), Length(LeftStr(sAccList, j - 1)));
      sAccList := Copy(sAccList, j + 1, Length(sAccList) - j);
      inc(i);
    end;

    for i := i to 4 do
    begin
      caaAccNo[i][0] := ' '; //없을때 5개까지 Space처리하기로 함.
    end;
  end
  else
  begin
//    ShowMessage('해당 그룹의 계좌가 존재하지 않습니다.');
//    Exit;
    caaAccNo[0][0] := ' '; //없을때 5개까지 Space처리하기로 함.
    caaAccNo[1][0] := ' ';
    caaAccNo[2][0] := ' ';
    caaAccNo[3][0] := ' ';
    caaAccNo[4][0] := ' ';
  end;

  for i := 0 to High(caaAccNo) do
  begin
    if caaAccNo[i][0] = #0 then
    begin
      pcaAccNo[i] := #0;
      break;
    end
    else
      pcaAccNo[i] := caaAccNo[i];
  end;

{
  pcaAccNo[0] := StrNew('1223311');
  pcaAccNo[1] := StrNew('1223312');
  pcaAccNo[2] := nil;
}
  try
    try
      @sngetFDPInfo := GetProcAddress(DllHandle, pChar('sngetFDPInfo'));
      if @sngetFDPInfo <> nil then
      begin
        if sngetFDPInfo(caEmpId, caCustDept, caDate, ppchar(@pcaAccNo), caFileName, caOut) <> 0 then
        begin
              //ShowMessage('sngetFDPInfo error:' + caOut);
          sOut := caOut;
          exit;
        end;
           //ShowMessage('sngetFDPInfo OK :' + caOut);
      end;
    except
      on E: Exception do
      begin
           //ShowMessage('Except..' + E.Message);
        sOut := 'Except..' + E.Message;
        Exit;
      end;
    end;
  finally
    FreeLibrary(DllHandle);
  end;

//  StrDispose(pcaAccNo[0]);
//  StrDispose(pcaAccNo[1]);

  sOut := caOut;
  Result := true;
end;

//미결제자료 생성 Call

function gf_HostCICSsngetFOPInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;
type
  TsngetFOPInfo = function(
    psEmpId, psCustDept, psDate: pchar;
    ppsAccNo: ppchar; psFileName, pszOut: pchar
    ): integer; cdecl;

var
  i, j: integer;
  sngetFOPInfo: TsngetFOPInfo;
  DllHandle: THandle;

  caFileName: array[0..30] of char;
  caCustDept: array[0..3] of char;
  caDate: array[0..8] of char;
  pcaAccNo: array[0..1000] of PChar;
  caaAccNo: array[0..1000, 0..20] of char;
  caEmpId: array[0..10] of char;
  caOut: array[0..100] of char;

  sEmpID, sCustDept: string;
begin
  Result := false;

  sEmpID := gvOprEmpID;
  sCustDept := '0' + gvDeptCode;

  DllHandle := LoadLibrary(pChar('ESNCICS.dll'));
  if (DllHandle = HINSTANCE_ERROR) or (DllHandle = 0) then
  begin
    ShowMessage('Dll Load 오류');
    Exit;
  end;

  FillChar(caFileName, SizeOf(caFileName), #0);
  FillChar(caCustDept, SizeOf(caCustDept), #0);
  FillChar(caDate, SizeOf(caDate), #0);
  FillChar(caaAccNo, SizeOf(caaAccNo), #0);
  FillChar(caEmpId, SizeOf(caEmpId), #0);
  FillChar(caOut, SizeOf(caOut), #0);

  myStr2Char(caEmpId, sEmpId, Length(sEmpId));
  myStr2Char(caCustDept, sCustDept, Length(sCustDept));
  myStr2Char(caDate, sDate, Length(sDate));
  myStr2Char(caFileName, sFileName, Length(sFileName));

  if sAccList > '' then
  begin
    i := 0;
    while (sAccList > '') do
    begin
      j := Pos(',', sAccList);
      if j <= 0 then break;
      myStr2Char(caaAccNo[i], LeftStr(sAccList, j - 1), Length(LeftStr(sAccList, j - 1)));
      sAccList := Copy(sAccList, j + 1, Length(sAccList) - j);
      inc(i);
    end;

    for i := i to 4 do
    begin
      caaAccNo[i][0] := ' '; //없을때 5개까지 Space처리하기로 함.
    end;
  end
  else
  begin
//    ShowMessage('해당 그룹의 계좌가 존재하지 않습니다.');
//    Exit;
    caaAccNo[0][0] := ' '; //없을때 5개까지 Space처리하기로 함.
    caaAccNo[1][0] := ' ';
    caaAccNo[2][0] := ' ';
    caaAccNo[3][0] := ' ';
    caaAccNo[4][0] := ' ';
  end;

  for i := 0 to High(caaAccNo) do
  begin
    if caaAccNo[i][0] = #0 then
    begin
      pcaAccNo[i] := #0;
      break;
    end
    else
      pcaAccNo[i] := caaAccNo[i];
  end;

{
  pcaAccNo[0] := StrNew('1223311');
  pcaAccNo[1] := StrNew('1223312');
  pcaAccNo[2] := nil;
}
  try
    try
      @sngetFOPInfo := GetProcAddress(DllHandle, pChar('sngetFOPInfo'));
      if @sngetFOPInfo <> nil then
      begin
        if sngetFOPInfo(caEmpId, caCustDept, caDate, ppchar(@pcaAccNo), caFileName, caOut) <> 0 then
        begin
              //ShowMessage('sngetFOPInfo error:' + caOut);
          sOut := caOut;
          exit;
        end;
           //ShowMessage('sngetFOPInfo OK :' + caOut);
      end;
    except
      on E: Exception do
      begin
           //ShowMessage('Except..' + E.Message);
        sOut := 'Except..' + E.Message;
        Exit;
      end;
    end;
  finally
    FreeLibrary(DllHandle);
  end;

//  StrDispose(pcaAccNo[0]);
//  StrDispose(pcaAccNo[1]);

  sOut := caOut;
  Result := true;
end;

//대용잔고 생성 Call

function gf_HostCICSsngetFLNInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;
type
  TsngetFLNInfo = function(
    psEmpId, psCustDept, psDate: pchar;
    ppsAccNo: ppchar; psFileName, pszOut: pchar
    ): integer; cdecl;

var
  i, j: integer;
  sngetFLNInfo: TsngetFLNInfo;
  DllHandle: THandle;

  caFileName: array[0..30] of char;
  caCustDept: array[0..3] of char;
  caDate: array[0..8] of char;
  pcaAccNo: array[0..1000] of PChar;
  caaAccNo: array[0..1000, 0..20] of char;
  caEmpId: array[0..10] of char;
  caOut: array[0..100] of char;

  sEmpID, sCustDept: string;
begin
  Result := false;

  sEmpID := gvOprEmpID;
  sCustDept := '0' + gvDeptCode;

  DllHandle := LoadLibrary(pChar('ESNCICS.dll'));
  if (DllHandle = HINSTANCE_ERROR) or (DllHandle = 0) then
  begin
    ShowMessage('Dll Load 오류');
    Exit;
  end;

  FillChar(caFileName, SizeOf(caFileName), #0);
  FillChar(caCustDept, SizeOf(caCustDept), #0);
  FillChar(caDate, SizeOf(caDate), #0);
  FillChar(caaAccNo, SizeOf(caaAccNo), #0);
  FillChar(caEmpId, SizeOf(caEmpId), #0);
  FillChar(caOut, SizeOf(caOut), #0);

  myStr2Char(caEmpId, sEmpId, Length(sEmpId));
  myStr2Char(caCustDept, sCustDept, Length(sCustDept));
  myStr2Char(caDate, sDate, Length(sDate));
  myStr2Char(caFileName, sFileName, Length(sFileName));

  if sAccList > '' then
  begin
    i := 0;
    while (sAccList > '') do
    begin
      j := Pos(',', sAccList);
      if j <= 0 then break;
      myStr2Char(caaAccNo[i], LeftStr(sAccList, j - 1), Length(LeftStr(sAccList, j - 1)));
      sAccList := Copy(sAccList, j + 1, Length(sAccList) - j);
      inc(i);
    end;

    for i := i to 4 do
    begin
      caaAccNo[i][0] := ' '; //없을때 5개까지 Space처리하기로 함.
    end;
  end
  else
  begin
//    ShowMessage('해당 그룹의 계좌가 존재하지 않습니다.');
//    Exit;
    caaAccNo[0][0] := ' '; //없을때 5개까지 Space처리하기로 함.
    caaAccNo[1][0] := ' ';
    caaAccNo[2][0] := ' ';
    caaAccNo[3][0] := ' ';
    caaAccNo[4][0] := ' ';
  end;

  for i := 0 to High(caaAccNo) do
  begin
    if caaAccNo[i][0] = #0 then
    begin
      pcaAccNo[i] := #0;
      break;
    end
    else
      pcaAccNo[i] := caaAccNo[i];
  end;

{
  pcaAccNo[0] := StrNew('1223311');
  pcaAccNo[1] := StrNew('1223312');
  pcaAccNo[2] := nil;
}
  try
    try
      @sngetFLNInfo := GetProcAddress(DllHandle, pChar('sngetFLNInfo'));
      if @sngetFLNInfo <> nil then
      begin
        if sngetFLNInfo(caEmpId, caCustDept, caDate, ppchar(@pcaAccNo), caFileName, caOut) <> 0 then
        begin
              //ShowMessage('sngetFLNInfo error:' + caOut);
          sOut := caOut;
          exit;
        end;
           //ShowMessage('sngetFLNInfo OK :' + caOut);
      end;
    except
      on E: Exception do
      begin
           //ShowMessage('Except..' + E.Message);
        sOut := 'Except..' + E.Message;
        Exit;
      end;
    end;
  finally
    FreeLibrary(DllHandle);
  end;

//  StrDispose(pcaAccNo[0]);
//  StrDispose(pcaAccNo[1]);

  sOut := caOut;
  Result := true;
end;

//------------------------------------------------------------------------------
// 실행중인 프로세스 count 알아내기
//------------------------------------------------------------------------------

function gf_GetProcCnt(sProcName: string): Integer;
var Process32: TProcessEntry32;
  SHandle: THandle;
begin
  Result := 0;

  Process32.dwSize := SizeOf(TProcessEntry32);
  SHandle := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);

  if Process32First(SHandle, Process32) then
  begin
    while Process32Next(SHandle, Process32) do begin
      if UpperCase(Process32.szExeFile) = UpperCase(sProcName) then
      begin
        Inc(Result);
      end;
    end;
  end;
  CloseHandle(SHandle); // closes an open object handle

end;

//---------------------------------------------------------------------------
// 접속 및 화면 사용 내역을 기록
//---------------------------------------------------------------------------
function gf_LogLstWrite(pADOQuery: TADOQuery; sDeptcd, sLogcd, sOprId, sOprDate, sStrTm, sEndTm,
  sOprIP, sEditUsr, sTrCd, sComment, sIUPos: string): Boolean;
var
  sStrTime: string;
  sOptValue: string;
begin
  result := False;
  sStrTime := '';
  sOptValue := '';

  if pADOQuery = nil then
    pADOQuery := DataModule_SettleNet.ADOQuery_Main;

  with pADOQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT OPT_VALUE = ISNULL(OPT_VALUE,''N'') FROM SUSYOPT_TBL '
      + '  WHERE OPT_CODE = ''L02''');

    try
      pADOQuery.Open;
      if RecordCount > 0 then
        sOptValue := Trim(FieldByName('OPT_VALUE').AsString);

    except
      on E: Exception do
      begin
        gf_Log('gf_LogLstWrite >> SUSYOPT Select Error : ' + E.Message);
        Exit;
      end;
    end;

      //if sOptValue <> 'Y' then Exit;
  end;

  with pADOQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT STR_TIME = Max(STR_TIME) FROM SCLOGLST_TBL '
      + ' WHERE DEPT_CODE = ''' + sDeptcd + ''' '
      + '   AND LOG_CODE  = ''' + sLogcd + ''' '
      + '   AND OPR_ID    = ''' + sOprId + ''' '
      + '   AND OPR_DATE  = ''' + sOprDate + ''' '
      + '   AND TR_CODE   = ''' + sTrCd + ''' '
      + '   AND END_TIME  = ''''       ');

    try
      gf_ADOQueryOpen(pADOQuery);

      if RecordCount > 0 then sStrTime := Trim(FieldByName('STR_TIME').AsString);

    except
      on E: Exception do
      begin
        gf_Log('gf_LogLstWrite >> SCLOGLST Select Error : ' + E.Message);
        Exit;
      end;
    end;

    if sIUpos <> 'I' then
    begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE SCLOGLST_TBL '
        + '   SET END_TIME  = :pEndTime, '
        + '       COMMENT   = :pComment  '
        + ' WHERE DEPT_CODE = :pDeptCode '
        + '   and LOG_CODE  = :pLogCode  '
        + '   and OPR_ID    = :pOprId    '
        + '   and OPR_DATE  = :pOprDate  '
        + '   AND STR_TIME  = :pStrTime  '
        + '   and TR_CODE   = :pTrCode   ');

      Parameters.ParamByName('pEndTime').Value := sEndTm;
      Parameters.ParamByName('pComment').Value := sComment;
      Parameters.ParamByName('pDeptCode').Value := sDeptcd;
      Parameters.ParamByName('pLogCode').Value := sLogCd;
      Parameters.ParamByName('pOprId').Value := sOprId;
      Parameters.ParamByName('pOprDate').Value := sOprDate;
      Parameters.ParamByName('pStrTime').Value := sStrTime;
      Parameters.ParamByName('pTrCode').Value := sTrCd;

    end else
    begin
      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO SCLOGLST_TBL (DEPT_CODE, LOG_CODE, OPR_ID, OPR_DATE, STR_TIME, '
        + '                          END_TIME, OPR_IP, EDIT_USRID, TR_CODE, COMMENT)  '
        + ' VALUES '
        + '(:pDeptCode, :pLogCode, :pOprId, :pOprDate, :pStrTime, :pEndTime, :pOprIP, '
        + ' :pEditUsrId, :pTrCode, :pComment) ');

      Parameters.ParamByName('pDeptCode').Value := sDeptcd;
      Parameters.ParamByName('pLogCode').Value := sLogcd;
      Parameters.ParamByName('pOprId').Value := sOprId;
      Parameters.ParamByName('pOprDate').Value := sOprDate;
      Parameters.ParamByName('pStrTime').Value := sStrTm;
      Parameters.ParamByName('pEndTime').Value := sEndTm;
      Parameters.ParamByName('pOprIP').Value := sOprIp;
      Parameters.ParamByName('pEditUsrId').Value := sEditUsr;
      Parameters.ParamByName('pTrCode').Value := sTrCd;
      Parameters.ParamByName('pComment').Value := sComment;

    end;

    try
      gf_ADOExecSQL(pADOQuery);
    except
      on E: Exception do
      begin
        gf_Log('gf_LogLstWrite >> SCLOGLST Insert/Update Error : ' + E.Message);
        Exit;
      end;
    end;
  end;

  result := True;
end;

function gf_GetLocalIP(Name: string; var IP: string): Boolean;
var
  wsdata: TWSAData;
  hostName: array[0..255] of char;
  hostEnt: PHostEnt;
  addr: PChar;
begin
  result := False;

  WSAStartup($0101, wsdata);

  try
    gethostname(hostName, sizeof(hostName));
    StrPCopy(hostName, Name);
    hostEnt := GetHostByName(hostName);
    if Assigned(hostEnt) then
      if Assigned(hostEnt^.h_addr_list) then begin
        addr := hostEnt^.h_addr_list^;
        if Assigned(addr) then begin
          IP := Format('%d.%d.%d.%d', [byte(addr[0]), byte(addr[1]),
            byte(addr[2]), byte(addr[3])]);
        end;

      end else Exit;

  finally
    WSACleanup;
  end;

  result := True;
end;

//------------------------------------------------------------------------------
// [Y.K.J] 2007.12.13 오피스 2007 호환성 문제로 인한 함수 추가
//         (기본 확장자명: .xls -> .xlsx)
//         2008.09.11 수정: 엑셀 쓰기암호 사용 처리
//------------------------------------------------------------------------------

procedure gf_ExcelSaveAs(pXL: Variant; pFileName: string; pFileFormat: Integer = xlExcel9795);
var
  sWritePassWd: string;
begin
  // 엑셀암호 사용 여부 체크
  sWritePassWd := gf_GetXLOptionValue;
  // 저장
  if (pFileFormat = xlExcel9795) then
  begin
    if Double(pXL.Version) >= 12 then // 2007일경우
      pXL.ActiveWorkBook.SaveAS(pFileName, 56, WriteResPassword := sWritePassWd)
    else
      pXL.ActiveWorkBook.SaveAS(pFileName, xlExcel9795, WriteResPassword := sWritePassWd)
  end else
  begin
    pXL.ActiveWorkBook.SaveAS(pFileName, pFileFormat);
  end;
end;
// 엑셀 쓰기암호 사용 여부 체크

function gf_GetXLOptionValue: string;
var
  sCfgDir: string;
  XLInfo: TIniFile;
begin
  try
    Result := '';
    // 설정파일(Scf.Ini) 경로 설정
    //sCfgDir := Copy(pFileName,1,Pos('..',pFileName)-5)+'Cfg\';
    sCfgDir := Copy(ExtractFilePath(ParamStr(0)), 1, Pos('Bin\', ExtractFilePath(ParamStr(0))) - 1) + 'Cfg\';
    // 설정 파일 읽기
    XLInfo := TIniFile.Create(sCfgDir + 'Scf.Ini');
    // 암호 사용하면 암호값 저장
    if (XLInfo.ReadString('Excel Option', 'E07', 'N') = 'Y') then
      Result := XLInfo.ReadString('Excel Option', 'E08', '1234');
  finally
    XLInfo.Free;
  end;
end;

function Gf_InsideString(const S, FirstString, LastString: string): string;
var
  sTemp: string;
  iPos, iPos2: Integer;
begin
  Result := '';
  sTemp := S;
  iPos := pos(FirstString, sTemp);
  if iPos > 0 then
  begin
    sTemp := copy(sTemp, iPos + Length(FirstString),
      length(sTemp) - (iPos + Length(FirstString) - 1));
    iPos2 := pos(LastString, sTemp);
    if iPos2 > 0 then
    begin
      Result := copy(sTemp, 1, iPos2 - 1);
    end;
  end;
end;

function Gf_InsideString(const S, FirstString: string): string;
begin
  Result := Gf_InsideString(s, FirstString, FirstString);
end;

function Gf_FormatDateDollarDollar(const S: string; pDate: TDateTime): string;
var
  sTemp: string;
  sReplaceTemp: string;
const
  DATE_DELIMITER = '$$';
begin
  Result := S;
  sTemp := Gf_InsideString(S, DATE_DELIMITER);
  sReplaceTemp := FormatDateTime(sTemp, pDate);
  Result := StringReplace(S, DATE_DELIMITER + sTemp + DATE_DELIMITER, sReplaceTemp, [rfReplaceAll]);
end;

// [Y.K.J] 2012.05.05 데이터 체크 (SP: SBP2801_TDC)
// SETRADE_TBL 과 SESPEXE_TBL 간 수량을 비교한다.

procedure gf_ExecSBP2801_TDC(iTrCode: integer; sDeptCode, sTradeDate: string);
var
  sErrAccNoList: TStringList;
  sErrAccNoItem,
    sErrAccListSavePath,
    sErrAccListSaveFileName: string;
begin

  sErrAccListSavePath := gvLogPath;
  sErrAccListSaveFileName := sTradeDate + '_DiscordanceList' + '.txt';

  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    SQL.Add('exec SBP2801_TDC ''' + sDeptCode + ''', ''' + sTradeDate + '''');

    try
      gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
    except
      on E: Exception do
      begin
        gf_ShowErrDlgMessage(0, 9001,
          'ADOQuery_Main[exec SBP2801_TDC]: ' + E.Message, 0); //Database 오류
        Exit;
      end;
    end;

    if RecordCount > 0 then
    begin

      sErrAccNoList := TStringList.Create;

      sErrAccNoItem := '';

      sErrAccNoList.Add('****************************************');
      sErrAccNoList.Add(' [' + Copy(sTradeDate, 1, 4) + '-'
        + Copy(sTradeDate, 5, 2) + '-'
        + Copy(sTradeDate, 7, 2)
        + '] ' + '매매내역 불일치 계좌 목록');
      sErrAccNoList.Add('****************************************');

      First;
      while not Eof do
      begin
        // 리스트에 저장[계좌번호]
        sErrAccNoList.Add(gf_FormatAccNo(Trim(FieldByName('ACC_NO').AsString),
          Trim(FieldByName('SUB_ACC_NO').AsString)));
        Next;
      end;
      // 리스트내역 파일 저장
      sErrAccNoList.SaveToFile(sErrAccListSavePath + sErrAccListSaveFileName);

      // 에러메시지 출력
      gf_ShowErrDlgMessage(iTrCode, 0,
        '***********************************************' + Chr(10)
        + '  매매수량이 맞지 않는 데이터가 발견되었습니다.' + Chr(10)
        + '  매매 Import를 재실행하시기 바랍니다.         ' + Chr(10)
        + '  [확인]버튼을 누르면 목록 확인이 가능합니다.  ' + Chr(10)
        + '  (총 ' + IntToStr(RecordCount) + ' 건)          ' + Chr(10)
        + '***********************************************', 0);

      sErrAccNoList.Clear;
      sErrAccNoList.Free;

      // 불일치 목록 보기
      if ShellExecute(0, 'open', Pchar(sErrAccListSavePath + sErrAccListSaveFileName),
        nil, nil, SW_SHOW) = SE_ERR_NOASSOC then
      begin
        WinExec(PChar('notepad.exe ' + sErrAccListSavePath + sErrAccListSaveFileName), SW_SHOW);
        Exit;
      end;

    end;
  end; // with ADOQuery_temp do

end;

//------------------------------------------------------------------------------
// CTM 채번
// 사용법
// [sGB] M : MasterReferenceID  : M + YYMMDD + 99999 (ID)
//       C : ClientAllocationID : C + YYMMDD + 99999 (ID)
//------------------------------------------------------------------------------

function gf_GetCTMID(sTradeDate, sGB: string): string;
begin
  gf_BeginTransaction; //채번의 유일성 보장위해 반드시 락을 건다.
  Result := '';
  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    SQL.Add('exec SBPCTMID ''' + sTradeDate + ''',''' + sGB + ''' ');
    gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
    if RecordCount > 0 then
      Result := Trim(FieldByName('CTM_ID').AsString);
  end;
  gf_CommitTransaction; //락을 푼다.
end;


function gf_StrToDate(pDate: string; pDateFormat: string = 'yyyy-mm-dd'; pDateSeparator: char = '-'): TDateTime;
begin
  ShortDateFormat := pDateFormat;
  DateSeparator := pDateSeparator;
  Result := StrToDate(pDate);
end;

function gf_StrToDateTime(pDate: string; pDateFormat: string = 'yyyy-mm-dd'; pDateSeparator: char = '-'): TDateTime;
begin
  ShortDateFormat := pDateFormat;
  DateSeparator := pDateSeparator;
  Result := StrToDateTime(pDate);
end;

{Function Gf_GetComName : String;
var
  p: PHostEnt;
  wVersionRequested: WORD;
  s: array[0..128] of char;
  wsaData: TWSAData;
begin

  wVersionRequested := MAKEWORD(1, 1);

  WSAStartup(wVersionRequested, wsaData);

  GetHostName(@s, 128);

  p := GetHostByName(@s);

  Result := p.h_name;
end;}

// Computer IP 구해오기
function gf_GetComIP: String;
var
   p : PHostEnt;
   p2 : pansichar;
   s : array[0..128] of char;
   wVersionRequested : WORD;

   wsaData : TWSAData;
   IPadd : String;
   Sint : integer;
begin
   Sint := 0;
   {Start up WinSock}

   wVersionRequested := MAKEWORD(1, 1);
   WSAStartup(wVersionRequested, wsaData);

   {Get the computer name}
   GetHostName(@s, 128);

   p := GetHostByName(@s);

   {Get the IpAddress}
   p2 :=  iNet_ntoa(PInAddr(p^.h_addr^)^);

   Result := p2;
   {Shut down WinSock}

   WSACleanup;
end;

// Computer Ip 를 구해와서 Hex로 변환
function gf_GetComIpToHex : string;
var
   p : PHostEnt;
   p2 : pansichar;
   s  : array[0..128] of char;
   wVersionRequested : WORD;

   wsaData : TWSAData;
   IpaddToHex : string;
   IPadd : String;
   Sint : integer;
begin
   Sint := 0;
   {Start up WinSock}

   wVersionRequested := MAKEWORD(1, 1);
   WSAStartup(wVersionRequested, wsaData);

   {Get the computer name}
   GetHostName(@s, 128);

   p := GetHostByName(@s);

   {Get the IpAddress}
   p2 :=  iNet_ntoa(PInAddr(p^.h_addr^)^);

   IPadd := p2;

   while Pos('.', IPadd) > 0 do
   begin
     Sint := Pos('.', IPadd) + 1;
     IpaddToHex := IpaddToHex + IntToHex(StrToInt(Copy(IPadd,1,Sint-2)),1);
     IPadd := Copy(IPadd,Sint,Length(IPadd));
   end;
      IpaddToHex := IpaddToHex + IntToHex(StrToInt(Copy(IPadd,1,Sint-2)),1);

   {Shut down WinSock}
   WSACleanup;

   Result := IpaddToHex;
end;
function gf_ShowMergeMail(var GrpName, MailformId : string): Boolean;
begin
  Result := False;

  Application.CreateForm(TDlgForm_MergeMail, DlgForm_MergeMail);


  with DlgForm_MergeMail do
  begin
    //Visible := True;
    if not ShowMailMerge(GrpName, MailformId) then Exit; // Error
    ShowModal;
  end;
  GrpName := DlgForm_MergeMail.DRUserCodeCombo_MailGrp.CodeName;
  // 변경되야되는 ID

  if Copy(DlgForm_MergeMail.DRUserCodeCombo_MailForm.Code, 3, 1) = 'M' then
    MailformId := DlgForm_MergeMail.DRUserCodeCombo_MailForm.Code
  else
    MailformId := '';
  if not DlgForm_MergeMail.DRChkBox_InsertUpdate.Checked then
    MailformId := 'N';

  Result := True;
end;

procedure gf_ControlCenterAllign(pBackGroundControl, pFrontControl : TControl);
var
  iBHeight, iBWidth : integer;
  iFHeight, iFWidth : integer;
begin
	iBHeight := 0;
	iBWidth := 0;
	
	iFHeight := 0;
	iFWidth := 0;	

  iBHeight := pBackGroundControl.Height;
  iBWidth := pBackGroundControl.Width;

  iFHeight := pFrontControl.Height;
  iFWidth := pFrontControl.Width;

  if iBHeight <> 0 then
  begin
    iBHeight := iBHeight div 2;
  end;
  if iBWidth <> 0 then
  begin
    iBWidth := iBWidth div 2;
  end;

  if iFHeight <> 0 then
  begin
    iFHeight :=  iFHeight div 2;
  end;
  if iFWidth <> 0 then
  begin
    iFWidth := iFWidth div 2;
  end;

  pFrontControl.Top := (iBHeight - iFHeight);
  pFrontControl.Left := (iBWidth - iFWidth);

end;

//------------------------------------------------------------------------------
// PDF Engine 사용 시 인쇄 함수
//------------------------------------------------------------------------------
procedure gf_DirectPrintForPDF(pPDFFileName: string);
// DynamicPDFViewer.OpenFileForPrinter() 버그가 있다.
// : OpenFileForPrinter() 처리 후 해당 함수가 종료 될때까지
//   파일 핸들이 해지가 안된다. (DynamicPDFViewer.CloseFile; 안 먹힘.)
//   그래서 별도의 함수로 만듬. (인쇄 후 파일 삭제를 할 수 있게...)
begin
  if not Assigned(RepForm_PreviewPDF) then
  begin
    Application.CreateForm(TRepForm_PreviewPDF, RepForm_PreviewPDF);
    RepForm_PreviewPDF.Parent := gvMainFrame;
  end;

  // 미리보기 화면 안 열고 PDF 파일 바로 인쇄.
  with RepForm_PreviewPDF.DynamicPDFViewer.OpenFileForPrinter(pPDFFileName) do
  begin
    if gvDefaultPrinterUseYN <> 'Y' then
    begin
      printerName := gvPrinter.PrinterName;
    end;
    AutoRotate := True; // 페이지 방향 자동 설정.
    if gvFaxReportDirection = '2' then
      AutoCenter := True   // 가로방향
    else
      AutoCenter := False; // 세로방향
    Scaling := 0; // 0 : Fit to Paper
    PrintQuiet;
    RepForm_PreviewPDF.Close;
  end; // with SCCPreviewFormPDF.RepForm_PreviewPDF.DynamicPDFViewer do
end;

//------------------------------------------------------------------------------
// 파일 잠겨있는것 확인
//------------------------------------------------------------------------------

function gf_IsFileInUse(fName: string): boolean;
var
  HFileRes: HFILE;
begin
  result := false;

  if not FileExists(fName) then
    exit;

  HFileRes := CreateFile(pchar(fName), GENERIC_READ or GENERIC_WRITE,
    0, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

  result := (HFileRes = INVALID_HANDLE_VALUE);

  if not Result then
    CloseHandle(HFileRes);
end;


procedure gf_DelimiterStringList(Delimiter: char; DelimitedText: string; var pStringList: TStringList);
var
  i: Integer;
begin

  if not Assigned(pStringList) then exit;
  // delimiter 는 1자리만 지원
  if Length(Delimiter) > 1 then Exit;

  pStringList.Clear;
  pStringList.Delimiter := Delimiter;
  // #171 문자열로 ' '을 '¿' 대체 하여 변경한다
  DelimitedText := StringReplace(DelimitedText, ' ', '¿', [rfReplaceAll]);

  pStringList.DelimitedText := DelimitedText;

  // 변경후 다시 '¿' 값을 ' ' 값으로 돌린다
  for i := 0 to pStringList.Count - 1 do
  begin
    pStringList.Strings[i] := StringReplace(pStringList.Strings[i], '¿', ' ', [rfReplaceAll]);
  end;

end;

function gf_AutoSplitAcc(AutoSplitList : TList) : boolean;
var
  i : Integer;
begin
  Result := false;
  if not FormCreated then
  begin
    Application.CreateForm(TDlgForm_AutoSplitAcc, DlgForm_AutoSplitAcc);
    DlgForm_AutoSplitAcc.Show;
  end;
  Result := True;

end;


//------------------------------------------------------------------------------
// Fax ComPort Open/Close 오류 시 처리 메시지
//------------------------------------------------------------------------------
procedure gf_FaxErrMaxCntErrMsg(pADOQuery : TADOQuery; pLabel : TDRLabel);
var
  iFaxReSetCnt : Integer;
  iFaxModemCnt : Integer;
begin

  with pADOQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select OPT_VALUE  '
        + ' from   SUSYOPT_TBL '
        + ' where  OPT_CODE = ''F04''   ');
    Try
      Open;
      Last;
      First;
      except
      on E: Exception do
      begin
        gf_Log('gf_FaxErrMaxCntErrMsg Error!!!(F04) ' + E.Message);
        Exit;
      end;
    end;

    if RecordCount = 0 then
      iFaxReSetCnt := 5
    else
      iFaxReSetCnt := StrToIntDef(Trim(FieldByName('OPT_VALUE').asString), 5 );

    Close;
    SQL.Clear;
    SQL.Add('select COM_PORT, RESET_CNT  '
        + ' from   SCFAXERR_TBL ');
    Try
      Open;
      Last;
      First;
      except
      on E: Exception do
      begin
        gf_Log('gf_FaxErrMaxCntErrMsg Error!!!(SCFAXERR_TBL) ' + E.Message);
        Exit;
      end;
    end;
    iFaxModemCnt := RecordCount;

    Filtered := False;
    Filter := ' RESET_CNT >= ' +   IntToStr(iFaxReSetCnt);
    Filtered := True;

    pLabel.Caption := '';
    // iFaxReSetCnt = 팩스 오류로 재시작 최대 값(OPT = 'F04')
    // RecordCount   = 오류난 팩스 갯수
    // iFaxModemCnt  = 실제 Fax모뎀 포트 총갯수
    pLabel.Visible := False;
    if RecordCount > 0 then
    begin
      pLabel.Visible := True;
      pLabel.Caption := 'Fax모뎀 오류!!! 문의요망 [' +  IntToStr(RecordCount)
                                            + '/' +  IntToStr(iFaxReSetCnt) + ']';
    end;
    Filtered := False;

  end;
end;

//------------------------------------------------------------------------------
// EMail Connection/Login 오류 시 처리 메시지
//------------------------------------------------------------------------------
procedure gf_EmailErrMsg(pADOQuery : TADOQuery; pLabel : TDRLabel);
VAR
  sErrTypeName : String;
  sReTryName : String;

begin

  with pADOQuery do
  begin

    Close;
    SQL.Clear;
    SQL.Add(' select TOP 1 ERR_TIME, ERR_TYPE,     ');
    SQL.Add('    ERR_CNT = ( SELECT COUNT(*) FROM SCMELERR_TBL E2 WHERE E2.ERR_TYPE = E.ERR_TYPE )   ');
    SQL.Add('   from SCMELERR_TBL E  ORDER BY ERR_TIME DESC  ');
    Try
      Open;
      Last;
      First;
      except
      on E: Exception do
      begin
        gf_Log('gf_EmailErrMsg Error!!!(SCMELERR_TBL) ' + E.Message);
        Exit;
      end;
    end;
    pLabel.Caption := '';
    pLabel.Visible := False;
    if RecordCount > 0 then
    begin
      if Trim(FieldByName('ERR_TYPE').asString) = 'C' then
      begin
        sErrTypeName := '접속 실패... ';
        sReTryName :=  Trim(FieldByName('ERR_CNT').asString);

      end
      else if Trim(FieldByName('ERR_TYPE').asString) = 'L' then
      begin
        sErrTypeName := '로그인 실패... ';
        sReTryName :=  Trim(FieldByName('ERR_CNT').asString);
      end;
      pLabel.Caption := '[문의요망]메일 서버 ' +  sErrTypeName
                    + '재시도 중 (' +   sReTryName + ')';

      pLabel.Visible := True;

    end;

  end;
end;

//------------------------------------------------------------------------------
// 종합계좌번호, 상품코드, 잔고번호 formatting 00000000-00-0000
//------------------------------------------------------------------------------
function gf_FormatAccNo_FI(pAccNo, pPrdNo, pBlcNo: string): string;
begin
  Result := '';

  // 종합계좌 + 상품코드 + 잔고번호
  if (Trim(pAccNo) <> '') and (Trim(pPrdNo) <> '') and (Trim(pBlcNo) <> '') then
  begin
    Result := Trim(pAccNo) + '-' + Trim(pPrdNo) + '-' + Trim(pBlcNo);
  end else
  // 종합계좌 + 상품코드
  if (Trim(pAccNo) <> '') and (Trim(pPrdNo) <> '') then
  begin
    Result := Trim(pAccNo) + '-' + Trim(pPrdNo);
  end else
  // 종합계좌
  if (Trim(pAccNo) <> '') then
  begin
    Result := Trim(pAccNo);
  end;
end;

//------------------------------------------------------------------------------
// 금융상품 첨부파일명 변환
//------------------------------------------------------------------------------
function gf_ConvertText_FI(pOldText, pFileNameInfo, pAccNo, pPrdNo, pBlcNo,
  pCreDate: String): String;
const
  STR_FILENAME = '{출력화일명}';
  STR_ACC_NO   = '{계좌번호}';
  STR_CRE_DATE = '{생성일자}';
var
  sBuff: string;
begin
  Result := pOldText;

  if (pOldText = '') then Exit;

  sBuff := pOldText;

  // 출력화일명 변환
  sBuff := StringReplace(sBuff, STR_FILENAME, pFileNameInfo, [rfReplaceAll]);
  // 계좌번호 변환
  sBuff := StringReplace(sBuff, STR_FILENAME, gf_FormatAccNo_FI(pAccNo, pPrdNo, pBlcNo), [rfReplaceAll]);
  // 출력화일명 변환
  sBuff := StringReplace(sBuff, STR_FILENAME, pCreDate, [rfReplaceAll]);

  Result := sBuff;
end;

end.

