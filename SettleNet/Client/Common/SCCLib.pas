//==============================================================================
//   SettleNet Library
//   P.H.S 2006.08.08   gf_SplitTextFile(pFreqNo(ȸ��) default='') �߰�
//   P.H.S 2006.08.25   gf_PreviewText(pFreqNo(ȸ��) default='') �߰�
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
  Registry, ActiveX, ComObj, Excel2000, math, SCCCmuGlobal, ThreadCL2Md, TlHelp32, WinSock, //2006.04.10 Delphi 7 version �߰� 1
  DCPmd5, DCPrijndael, DCPsha256;

//------------------------------------------------------------------------------
//  Crystal 10 DLL Registry ����ϱ� Function //2006.04.10 Delphi 7 version �߰� 1
//------------------------------------------------------------------------------
//Crystal 10 Dll�� �ݵ�� Registry�� ����ؼ� ��� �Ѵ�.
//������ Settup �۾��� �ϸ� ������ �ΰ��ΰ� ������ �۾��̴�
//���� Registry�� �ǵ� �� ���� �ܱ��踦 �����ϰ�
//Application ���Կ� �ڵ����� Crystal Dll�� ��ġ�Ѵ�.
//����, �� ��ġ�� PC�� �����Ѵ�.
function gf_DllSetup: boolean;

//------------------------------------------------------------------------------
//  EMail File ���� Main Function
//------------------------------------------------------------------------------
function gf_CreateEMailFile(pEMailFormId, pDirName, pDeptCode, pTradeDate: string;
  pGrpName: string; AccNoList: TStringList; var FileName: string; CreateFlag: boolean): boolean;

//------------------------------------------------------------------------------
// [��/��] Code <-> Code�� ��ȯ �Լ�
//------------------------------------------------------------------------------
// gvIssueList���� �ش� �����ڵ忡 ���յǴ� Index ����
function gf_ReturnIssueCodeIdx(pIssueList: TList; pIssueCode: string): Integer;
// �����ڵ��� ���� ����(TIssueType) ����
function gf_ReturnIssueInfo(pSecType, pIssueCode: string; var pIssueItem: pTIssueType): boolean;
// �����ڵ带 ����ǥ���ڵ�� ��ȯ
function gf_IssueCodeToFullCode(pSecType, pIssueCode: string): string;
// �����ڵ带 ��������� ��ȯ
function gf_IssueCodeToFullName(pSecType, pIssueCode: string): string;
// �����ڵ带 ������������ ��ȯ
function gf_IssueCodeToShortName(pSecType, pIssueCode: string): string;
// ������� �����ڵ�� ��ȯ
function gf_IssueFullNameToCode(pSecType, pIssueName: string): string;
// ���������� �����ڵ�� ��ȯ
function gf_IssueShortNameToCode(pSecType, pIssueName: string): string;
// ���񸮽�Ʈ ����
procedure gf_SortIssueList(pIssueList: TList; pAscCodeFlag: boolean);
// CodeList�� �����Ͽ� Code�� Name���� ��ȯ�Ͽ� ����(CompCode ����)
function gf_CodeToName(pList: TList; pCode: string): string;
// CodeList�� �����Ͽ� Name�� Code�� ��ȯ�Ͽ� ����  (CompCode ����)
function gf_NameToCode(pList: TList; pName: string): string;
// CompCode�� Name���� ��ȯ�Ͽ� ����
function gf_CompCodeToName(pCompCode: string): string;
// CompName�� Code�� ��ȯ�Ͽ� ����
function gf_CompNameToCode(pCompName: string): string;
// RoleCode�� Name���� ��ȯ�Ͽ� ����
function gf_RoleCodeToName(pRoleCode: string): string;
// RoleName�� Code�� ��ȯ�Ͽ� ����
function gf_RoleNameToCode(pRoleName: string): string;
// ReprotID�� Name���� ��ȯ�Ͽ� ����
function gf_ReportIDToName(pReportID: string): string;
// ReportName�� Report ID�� ��ȯ�Ͽ� ����
function gf_ReportNameToID(pReportName: string): string;
// �ش� Report�� ���� Direction ����
function gf_GetReportDirection(pReportId: string): string;
// �ش� Report�� ���� ReportType ����
function gf_GetReportType(pReportId: string): string;
// DeptCode�� Name���� ��ȯ�Ͽ� ��õ
function gf_DeptCodeToName(pDeptCode: string): string;
// DeptName�� Code�� ��ȯ�Ͽ� ����
function gf_DeptNameToCode(pDeptName: string): string;
// FundType�� Name���� ��ȯ�Ͽ� ����
function gf_FundTypeToName(pFundType: string): string;
// Fundtype���� FundType���� ��ȯ�Ͽ� ����
function gf_FundTypeNameToType(pFundTypeName: string): string;
// Sec Type�� Name���� ��ȯ�Ͽ� ����
function gf_SecTypeToName(pSecType: string): string;
// Sec Name�� Type���� ��ȯ�Ͽ� ����
function gf_SecNameToType(pSecName: string): string;
// Tran Mtd�� Name���� ��ȯ�Ͽ� ����
function gf_TranMtdToName(pTranMtd: string): string;
// Tran Mtd Name�� Tran Mtd �� ��ȯ�Ͽ� ����
function gf_TranNametoMtd(pTranName: string): string;
// Com Type�� Name���� ��ȯ�Ͽ� ����
function gf_ComTypeToName(pComType: string): string;
// Com Name�� Type���� ��ȯ�Ͽ� ����
function gf_ComNameToType(pComName: string): string;
// Mkt Type�� Name���� ��ȭ�Ͽ� ����
function gf_MktTypeToName(pMktType: string): string;
// Mkt Name�� Type���� ��ȯ�Ͽ� ����
function gf_MktNameToType(pMktName: string): string;
// Tran Code�� Name���� ��ȯ�Ͽ� ����
function gf_TranCodeToName(pTranCode: string): string;
// Tran Code Name�� Tran Code�� ��ȯ�Ͽ� ����
function gf_TranNameToCode(pTranName: string): string;
// Party ID�� Name���� ��ȯ�Ͽ� ����
function gf_PartyIDToName(pPartyID: string): string;
// Party Name�� ID�� ��ȯ�Ͽ� ����
function gf_PartyNameToID(pPartyName: string): string;
// SellBuyCode�� Name���� ��ȯ�Ͽ� ����
function gf_SellBuyCodeToName(pCode: string): string;
// SellBuyName�� Code�� ��ȯ�Ͽ� ����
function gf_SellBuyNameToCode(pName: string): string;
// TeamCode�� Name���� ��ȯ�Ͽ� ����
function gf_TeamCodeToName(pTeamCode: string): string;
// TeamName�� Code�� ��ȯ�Ͽ� ����
function gf_TeamNameToCode(pTeamName: string): string;
// FundType�� Name���� ��ȯ�Ͽ� ����
function gf_FundTypeCodeToName(pFundTypeCode: string): string;
// FundTypeName�� Type���� ��ȯ�Ͽ� ����
function gf_FundTypeNameToCode(pFundTypeName: string): string;
// SendMethod Code�� Name���� ��ȯ�Ͽ� ����
function gf_SendMtdCodeToName(pSendMtdCode: string): string;
// SendMethod Name�� SendMethod Code�� ��ȯ�Ͽ� ����
function gf_SendMtdNameToCode(pSendMtdName: string): string;
// CustProp Code�� Name���� ��ȯ�Ͽ� ����
function gf_CustPropCodeToName(pCustPropCode: string): string;
// CustProp Name�� Code�� ��ȯ�Ͽ� ����
function gf_CustPropNameToCode(pCustPropName: string): string;

//------------------------------------------------------------------------------
//  Log File ó��
//------------------------------------------------------------------------------
// Log File ���(Thread Safe)
procedure gf_Log(S: string);
// Log File Open
procedure gf_StartLog(pLogPath, pLogName: string);
// Log File Close
procedure gf_EndLog;


//------------------------------------------------------------------------------
//  ä�� �Լ�
//------------------------------------------------------------------------------
//  Data ���۽� Ƚ�� ä��
function gf_GetDataSendFreqNo(pSecType: string): Integer;
//  Data ���۽� �Ѽ۽� Seq. No ä��
function gf_GetDataSendSeqNo(pSecType: string): Integer;
//  Fax ���۽� Ƚ�� ä��
function gf_GetFaxSendFreqNo: Integer;
//  Fax ���۽� �Ѽ��� Seq. No ä��
function gf_GetFaxSendSeqNo: Integer;

//------------------------------------------------------------------------------
//  Format �Լ�
//------------------------------------------------------------------------------
// ����¹�ȣ, �ΰ��¹�ȣ formatting 00000000000-0000
function gf_FormatAccNo(pAccNo, pSubAccNo: string): string;
// ���¹�ȣ unformatting : 00000000000-0000 -> 00000000000, 0000
procedure gf_UnformatAccNo(pFormatAccNo: string; var pAccNo, pSubAccNo: string);
// Date formatting : YYYYMMDD -> YYYY-MM-DD
function gf_FormatDate(pDate: string): string;
// Date unformatting : YYYY-MM-DD -> YYYYMMDD
function gf_UnformatDate(pDate: string): string;
// Report ������ Date formatting : YYYYMMDD -> YYYY/MM/DD(+++�����ʿ�)
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
//  ����/�ð� ���� �Լ�
//----------------------------------------------------------------------------=
//  �Էµ� ���ڰ� ��ȿ�� �������� Ȯ��
function gf_CheckValidDate(pDate: string): boolean;
//  ���� ���� �������� �Լ�(YYYYMMDD)
function gf_GetCurDate: string;
//  ���� �ð� �������� �Լ�(HHMMSSMM)
function gf_GetCurTime: string;
//  ���� ���� ���ϴ� �Լ�, ���� �߻��� �ش� ���� Message ����
function gf_GetSettleDate(pApplyType, pStdDate: string; var pSettleDate: string): string;
//  �Էµ� ������ ���̸� ���ϴ� �Լ�
function gf_Getstgigan(sDate, tDate: string): integer;

//------------------------------------------------------------------------------
//  ����ȯ �Լ�
//------------------------------------------------------------------------------
// Conversion Error �߻��� 0�� Return�Ǵ� StrToFloat
function gf_StrToFloat(pStr: string): double;
// Conversion Error �߻��� 0�� Return�Ǵ� StrToInt
function gf_StrToInt(pStr: string): integer;
// currency comma ó���Ͽ� �ش� �� return
function gf_CurrencyToFloat(pStr: string): double;
// currency comma String���� currency comma ������ string return
function gf_CurrencyToStr(pStr: string): string;

// ��¥ ���� ��ȯ�� �ѱ�os ��¥ ǥ���������� �����ϱ� ���� StrToDate
function gf_StrToDate(pDate: string; pDateFormat: string = 'yyyy-mm-dd'; pDateSeparator: char = '-'): TDateTime;
// ��¥ ���� ��ȯ�� �ѱ�os ��¥ ǥ���������� �����ϱ� ���� StrToDateTime
function gf_StrToDateTime(pDate: string; pDateFormat: string = 'yyyy-mm-dd'; pDateSeparator: char = '-'): TDateTime;

//------------------------------------------------------------------------------
//  ���� ���� �Լ�
//------------------------------------------------------------------------------
// ���� ���� Ȯ�� �� ���¸� Return (��/��)
function gf_GetAccName(InAccNo: string; var OutAccName: string): boolean;

//------------------------------------------------------------------------------
//  Message ���� �Լ�
//------------------------------------------------------------------------------
// Dialog Message (��/��)
function gf_ShowDlgMessage(pTrCode: LongInt; pDlgType: TMsgDlgType; pMsgNo: LongInt; pExtMsg: string;
  pButtons: TMsgDlgButtons; pHelpCtx: LongInt): Integer;
// Error Dialog Message (��/��)
function gf_ShowErrDlgMessage(pTrCode: LongInt; pMsgNo: LongInt; pExtMsg: string; pHelpCtx: LongInt): Integer;
// [�ѿ�] MessageBar�� Message ���
procedure gf_ShowMessage(pMsgBar: TDRMessageBar; pMsgType: TMsgDlgType; pMsgNo: LongInt; pExtMsg: string);
// MessageBar Clear
procedure gf_ClearMessage(pMsgBar: TDRMessageBar);
// Message ��ȣ�� �޾� �ش� Message return (��/��)
function gf_ReturnMsg(pMsgNo: LongInt): string;

//------------------------------------------------------------------------------
//  DB ����
//------------------------------------------------------------------------------
// ������ Shared Lock�� Ǯ���ִ� Query Open
procedure gf_QueryOpen(pQuery: TQuery);
// ������ Shared Lock�� Ǯ���ִ� Query Open
procedure gf_ADOQueryOpen(pQuery: TADOQuery);

// Update, Insert, Delete�� �����ϴ� SQL ����
procedure gf_ExecSQL(pQuery: TQuery);
// Update, Insert, Delete�� �����ϴ� SQL ����
procedure gf_ADOExecSQL(pQuery: TADOQuery);

// Parameter�� �������� Stored Proc �� ����
procedure gf_ExecProc(pStoredProc: TStoredProc);
// Parameter�� �������� Stored Proc �� ����
procedure gf_ADOExecProc(pStoredProc: TADOStoredProc);

// ResultSet�� �������� Stored Proc �� ����
procedure gf_GetResultProc(pStoredProc: TStoredProc);
// ResultSet�� �������� Stored Proc �� ����
procedure gf_ADOGetResultProc(pStoredProc: TADOStoredProc);

// Database Start Transaction
procedure gf_BeginTransaction;
// Database Commit
procedure gf_CommitTransaction;
// Database Rollback
procedure gf_RollbackTransaction;

//------------------------------------------------------------------------------
// Report ����
//------------------------------------------------------------------------------
// Print Crystal Rpt Type Report ( By Kim Ji-Young)
function gf_PrintReport(ExpFileName: string): Boolean;
// Print Crystal Rpt Type Report ( By Kim Ji-Young)
function gf_PreviewReport(ExpFileName: string): Boolean;

//------------------------------------------------------------------------------
//  �ۼ��� Manager ����
//------------------------------------------------------------------------------
// ����ó Component���� ����ó ������ Display �ϱ� ���� Format
function gf_FormatFaxTlxAddr(pAddrItem: pTFaxTlxAddr): string;
// FaxTlxAddrList Clear (SUPRTAD_TBL - Fax/Tlx) Item: TFaxTlxAddr
procedure gf_ClearFaxTlxAddrList(pList: TList);
// �ش� �μ��� ����ó ���� ȭ�� ���� (����ó ����� True Return)
function gf_ShowRegFaxTlxAddr(pSendMtd: string; pSendSeq: Integer): Integer;
// �ش� �μ��� �׷� ���� ȭ�� ����
function gf_ShowRegGroup(pSecType, pGrpName, pCallFlag, pAccNo, pSubAccNo: string): Integer;
// �̸��� ÷��ȭ�� ����
function gf_CreateMailFile(SndItem: pTFSndMail; CallFlag: boolean; JobDate: string): string;
// �̸��� ÷��ȭ�� ����
function gf_ViewMailFile(SndItem: pTFSndMail; JobDate: string): string;
// ����ó����- �̸��� ���ȭ��
function gf_ShowRegEmailAddr(pMailRcv, pMailAddr: string): integer;
// �̸��� ����ó ��� ȭ�� ����
function gf_ShowSelectEmail(pMailAddrList, pCCMailAddrList, pCCBlindAddrList: TStringList;
  pRcvType, pTitle: string): Integer;
function gf_SendSeqToRcvName(pSendSeq: string): string;

// Show Att File
function gf_ShowAttDlg(pSndDate: string; FreqItem: pTFreqMail; pAttSeqNo: Integer): boolean;
// EMail Attaxh File ����
function gf_SaveMailAttachToFile(pSendDate: string; pCurTotSeqNo,
  pAttSeqNo: Integer; pFileName: string): boolean;
// Fax ���� ���� File ����
function gf_SaveSentImageToFile(pSendDate: string; pCurTotSeqNo: Integer;
  pFileName: string): boolean;
// Free MediaNo List
procedure gf_FreeReportList(ReportList: TList);
// Telex�� �����ڵ� Ȯ��
function gf_CheckValidNatCode(pNatCode: string): boolean;
// Text File�� �����ں� Unit���� Split���� ����
function gf_SplitTextFile(pSrcFileName, pDesFileName, pTxtUnitInfo: string; pFreqNo: string = ''): boolean;
// Text File�� Page ���е� Text File�� ��ȯ
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
// ���� ���� ó�� (����� Authority ó�� ����)
//------------------------------------------------------------------------------
// ���� ó�� ���� Report�� ������ Return;
function gf_GetReportDecTail(pTrCode: Integer; pStlDate: string): string;
// ���� TR�� ���� �Ϸ� Ȯ�� : ����Ϸ� -> True, ����̿Ϸ� -> False
function gf_CheckPreTRProcess(pTrCode: Integer; pStlDate: string;
  var pMsg: string): boolean;
//���� TR�� ���� ���� ���� Ȯ�� : ���������� -> True, ��������� -> False
function gf_CheckAfterTRProcess(pTrCode: Integer; pStlDate: string;
  var pMsg: string; iDecLevel: integer = 0): boolean;

//������� ��� �����ϳ�?
function gf_CanCancelDecLine(pTrCode: Integer; pStlDate: string; pDecLevel: integer;
  var pMsg: string): boolean;
// ���� TR�� ���� ���� Clear : Result -> ���� ����
function gf_ClearAfterTRProcess(pTrCode: Integer; pStlDate: string): Integer;
// ȭ����ѿ��� Ȯ��
function gf_CanUseTrCode(pTrCode: Integer): boolean;
// Enable Button
procedure gf_EnableBtn(pTrCode: Integer; pButton: TControl);


//------------------------------------------------------------------------------
// * ��Ÿ...
//------------------------------------------------------------------------------
//  ���� ���� pYearMonth : YYYYMM Return : YYYYMM
function gf_GetPreMonth(pYearMonth: string): string;
//  Numeric Data ���� �Ǵ�
function gf_IsNumeric(Value: string): boolean;
// ����� �μ��ڵ忡 �����Ǵ� SettleNet �μ��ڵ� Return
function gf_GetGlobalDeptCode(pUserDeptCode: string;
  var pGlobalDeptCode: string): boolean;
// Show ICON Dialog (Result = ���� Image Index)
function gf_ShowIconDlg(ScreenX, ScreenY, CurImageIdx: Integer): Integer;
// ����� ���� ToolBar �籸��
procedure gf_ResetUserToolBar;
// TrCode�� �ش��ϴ� �޴��̸� Return
function gf_TrCodeToMenuName(pTrCode: Integer; var pFullName,
  pShrtName: string): boolean;
// Execution Module�� Version�� ����
function gf_ExeVersion(sExeFullPathFileName: string): string;
// �ش� ������ ���������� �Ǿ����� Ȯ��
function gf_FutDailySettled(pTradeDate: string): string;
// �ΰ��� StringList�� �������� �Ǵ�
function gf_IsSameStringList(pStrList1, pStrList2: TStringList): boolean;
// �ش� SendMethod�� ��밡������ �Ǵ�
function gf_CanUseSendMtd(pSendMtdCode: string): boolean;
// NotePad �����Ű�� �Լ�
procedure gf_ExecNotePad(pParentHandle: THandle; pFileName: string);
// Ini File���� �ش� Form�� ������ �о���� �Լ�(String Type)
function gf_ReadFormStrInfo(pFormName, pKeyName, pDefaultValue: string): string;
// Ini File���� �ش� Form�� ������ �о���� �Լ�(Integer Type)
function gf_ReadFormIntInfo(pFormName, pKeyName: string; pDefaultValue: Integer): Integer;
// Ini File�� �ش� Form ���� ����ϴ� �Լ�(String Type)
procedure gf_WriteFormStrInfo(pFormName, pKeyName, pDefaultValue: string);
// Ini File�� �ش� Form ���� ����ϴ� �Լ�(Integer Type)
procedure gf_WriteFormIntInfo(pFormName, pKeyName: string; pDefaultValue: Integer);
// ���丮���� ���� ����
function gf_CopyFile(pSource, pDestn: string): boolean;
// ���丮 ����� (Sub File �����ؼ�)
procedure gf_DelDirectory(DirectoryName: string);
// ���丮 ����(//COPY, DELETE, MOVE, RENAME)
function File_DirOperations_Datail(
  Action: string; //COPY, DELETE, MOVE, RENAME
  RenameOnCollision: Boolean; //Renames if directory exists
  NoConfirmation: Boolean; //Responds "Yes to All" to any dialogs
  Silent: Boolean; //No progress dialog is shown
  ShowProgress: Boolean; //displays progress dialog but no file names
  FromDir: string; //From directory
  ToDir: string //To directory
  ): Boolean;

// ��Ʈ�� ������� ����
procedure gf_ControlCenterAllign(pBackGroundControl, pFrontControl : TControl);

// Print Text File
function gf_PrintTextFile(pFileName, pOrientation: string; pMaxPageLineCnt: Integer): boolean;
// Print Memo
function gf_PrintMemo(pPrnMemo: TMemo; pOrientation: string;
  pMaxPageLineCnt: Integer): boolean;
// Main Frame�� Main Menu, ToolBar Enable
procedure gf_EnableMainMenu;
// Main Frame�� Main Menu, ToolBar Disable
procedure gf_DisableMainMenu;
// ����ó ��� ȭ�鿡���� Send Method�� ���� Color Return
function gf_ReturnSendMtdColor(pSendMtd: string): TColor;
// Child Form ����
procedure gf_CreateForm(pTrCode: Integer);
// Code Table ���� �� ȣ�� (MainFrame�� CodeList ���� message ����)
procedure gf_RefreshCodeList(pCodeTableNo: Integer);
// Group Table ���� �� ȣ�� (MainFrame�� CodeList ���� message ����)
procedure gf_RefreshGroupList;
// Global ���� ���� ������ ���� �� ȣ�� (MainFrame�� Global var ���� message ����)
procedure gf_RefreshGlobalVar(pGlobVarNo: Integer); overload;
procedure gf_RefreshGlobalVar(pGlobVarNo: Integer; pSetValue: Integer); overload;
// List Sort�� Item ũ�� �񱳸� ���� �Լ�(Floating)
function gf_ReturnFloatComp(pTemp1, pTemp2: double; pAscending: boolean): Integer;
// List Sort�� Item ũ�� �񱳸� ���� �Լ�(Sting)
function gf_ReturnStrComp(pTemp1, pTemp2: string; pAscending: boolean): Integer;
// �ش� ȭ�鿡 ���� ���� ���� Ȯ��
function gf_CheckUsableMenu(pTrCode: Integer): boolean;
// ����Ʈ �ϱ��� ������ ȯ�� ����
function gf_InitPrint(pPrnComponent: TObject): boolean;
// Application�� Root Path Return (SettleNet -> C:\Program Files\SettleNet\
function gf_GetAppRootPath: string;
// Row Selection�� ��ġ�� SelRowIdx�� ��ġ�� �ű�
procedure gf_SelectStrGridRow(pStringGrid: TStringGrid; SelRowIdx: Integer);
// Cell Selection�� ��ġ�� SelColIdx, SelRowIdx����ġ�� �ű�
procedure gf_SelectStrGridCell(pStringGrid: TStringGrid; SelColIdx, SelRowIdx: Integer);
// StringGrid�� Cell�� ������
procedure gf_ClearStrGrid(pStringGrid: TStringGrid; StartCol, StartRow, EndCol, EndRow: Integer);
// StringGrid�� FixedCell�� ������ ��� Cell�� ������
procedure gf_ClearStrGridAll(pStringGrid: TStringGrid);
// StringGrid�� ColIdx, RowIdx�� �ش��ϴ� Cell Click
procedure gf_ClickStrGrid(pStringGrid: TStringGrid; ColIdx, RowIdx: Integer);
// �ش� Index�� StringGrid�� ���� ���� Row�� �̵���Ŵ
procedure gf_SetTopRow(pStringGrid: TStringGrid; CurIdx: Integer);
// �ش� Form ���
//procedure gf_PrintForm(pPrintForm: TForm);

// �ý��ۿɼǰ�������
function gf_GetSystemOptionValue(pOptCode, pDefaultValue: string): string;
function gf_GetSystemOptionInfo(pOptCode, pOptValue: string): string;


// ���� ȯ�溯�� ��������
function GetDosEnv(Value: string): string;

//�⺻Printer�� PDF Printer��
function gf_DefPrinter2PDFPrinter: boolean;

//PDF Printer���� �⺻Printer��
function gf_PDFPrinter2DefPrinter: boolean;

//pwd ��ȣȭ
function gfEncryption(i_password, i_HashEncYN: string; var o_Shortpassword: string): string;
function gfDecryption(i_password, i_HashEncYN: string): string;

//���°˻� â����
function gf_ShowAccNoSearch(pSecType, pAccNo, pAccName: string): Integer;

function gf_CountQuery(pSQL: string): integer;
function gf_ReturnStrQuery(pSQL: string): string;
function IsCloseTradeDate(sTradeDate: string): boolean;

//�׸��忡�� �ش� �÷��� �� ã�� Row ����
function gf_FindRowInGrid(pStrGrid: TDRStringGrid; iCol: integer; sKey: string): integer;

function GetAveCharSize(Canvas: TCanvas): TPoint;

function InputQueryDRDateEdit(const ACaption, APrompt, APrompt2: string;
  var Value: string): Boolean;

//version dll, exe upgrade�ϱ�
function gf_VersionSync(pQuery: TADOQuery; pExtGB: string; pPanel: TDRPanel): string;

function gf_FormatTelNo(sTelNo: string): string;

//  OASYS Allocation ��ȣ ä�� CON_SEQ_NO
function gf_GetOASYSSendSeqNo: Integer;

// �ֽ�Off, �ڽ���Off, ��Ÿ �������� Get
//function gf_GetCommRateLst(pADOQuery : TADOQuery; pAccNo : String; var sEqtyOff, sKosqOff : String; var sAll : TList): Integer;
//function gf_GetCommRateStr(pADOQuery : TADOQuery; pAccNo : String; var sEqtyOff, sKosqOff, sAll : String): Integer;

function gf_GetHisTypeName(sHisType: string): string;

function gf_GetHisTypeShortName(sHisType: string): string;

function gf_GetHisDelTypeName(sHisType: string): string;

function gf_GetHisDelTypeShortName(sHisType: string): string;

function gf_UpdateManualChain(sTradeDate: string): boolean;

//�ҹ��ڸ� �빮�ڷ�
function gf_ToUpper(var Key: char): char;

// round �Խ����� ���� ���� �͵�..
function gf_RoundTo(AValue: Double; ADigit: Double): Double;

// �ø� �Լ�
Function gf_CeilingTo(AValue: Double; ADigit : Double) : Double;

//Host (HostGW or CICS) Interface ===============================================================
procedure myStr2Char(str: PChar; instr: string; len: longint);
function myChar2Str(str: PChar; len: longint): string;

//�����ӽ������������ ���� ����
function gf_HostCallsnchangeFee(sDate, sAccNo: string; dComRate: double; var sNotifyNeed: string; var sOut: string): boolean;
//�����ӽ������������ ���� ����(������)
function gf_HostCICSsnchangeFee(sDate, sAccNo: string; dComRate: double; var sNotifyNeed: string; var sOut: string): boolean;
//�����ӽ������������ ���� ����(HostGateWay��:�ϳ�����) >>> ����.

//���忡�� ��������
function gf_HostCallsncalculate(
  sTrdDate, sIssueCode, sTranCode, sTrdType,
  sAccNo, sStlDate: string; dAvrExecPrice, dTotExecQty, dTotExecAmt: double;
  var dComm: double; var dTrdTax: double; var dAgcTax: double;
  var dCpgTax: double; var dNetAmt: double; var dHCommRate: double;
  var sOut: string): boolean;

//���忡�� ��������(������)
function gf_HostCICSCalculate(
  sIssueCode, sTranCode, sTrdType,
  sAccNo, sStlDate: string; dAvrExecPrice, dTotExecQty, dTotExecAmt: double;
  var dComm: double; var dTrdTax: double; var dAgcTax: double;
  var dCpgTax: double; var dNetAmt: double; var dHCommRate: double;
  var sOut: string): boolean;

//���忡�� ��������(HostGateWay��:�ϳ�����)
function gf_HostGateWayCalculate(
  pTrdDate, pIssueCode, pTranCode, pTrdType,
  pAccNo, pStlDate: string; dAvrExecPrice, dTotExecQty, dTotExecAmt: double;
  var dComm: double; var dTrdTax: double; var dAgcTax: double;
  var dCpgTax: double; var dNetAmt: double; var dHCommRate: double;
  var sOut: string): boolean;

//OMS �Ÿ��ڷ� ���� Call
function gf_HostCICSsngetOMSTRInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

//�Ÿ��ڷ� ���� Call (������)
function gf_HostCICSsngetTRInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

//�����ڷ� ���� Call (������)
function gf_HostCICSsngetACInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

//�ֽĸŸ��ڷ� ���� Call (�ϳ�������)
function gf_HostGateWaysngetTRInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

//�����Ÿ��ڷ� ���� Call (�ϳ�������)
function gf_HostGateWaysngetFTRInfo(sDate, sAccList, sFileName: string;
  var sOut: string;iTradeTypeIdx: integer): boolean;

//�ֽİ����ڷ� ���� Call (�ϳ�������)
function gf_HostGateWaysngetACInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

//���������ڷ� ���� Call (�ϳ�������)
function gf_HostGateWaysngetFACInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

//Upload Call (������)
function gf_HostCICSsnprocessUploadData(sDate, sFileName, sWorkCode: string; var sOut: string): boolean;
function gf_HostCICSsnprocessUploadACData(sDate, sFileName, sWorkCode: string; var sOut: string): boolean;
//Upload Call (�ϳ�������)
function gf_HostGateWaysnprocessUploadData(sDate, sFileName: string; var sOut: string): boolean;

//�������� Upload Call
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

//������ �������� SP Call
function ExecuteCommBojung(
  in_user_id, in_dept_code, in_trade_date, in_acc_no,
  in_brk_sht_no, in_issue_code, in_tran_code, in_trade_type: string;
  in_my_amt, in_tot_amt, in_tot_comm, in_comm_rate: double;
  var out_comm: double; var out_netamt: double; var sMsg: string
  ): boolean;

//������ �������� SP Call
function ExecuteTaxBojung(
  in_user_id, in_dept_code, in_trade_date, in_acc_no,
  in_brk_sht_no, in_issue_code, in_tran_code, in_trade_type: string;
  in_my_amt, in_my_comm, in_tot_amt,
  in_tot_ttax, in_tot_atax, in_tot_ctax: double;
  var out_ttax: double; var out_atax: double;
  var out_ctax: double; var out_netamt: double; var sMsg: string
  ): boolean;


//------------------------------------------------------------------------------
// �ܰ��� �ֹ���ȣ�� ���� �ϴ� �༮ // ������ �༮����  = 0
//------------------------------------------------------------------------------
function gf_CopyTradeToOrdTd(ADOQuery_Trade, ADOQuery_Ordexe: TADOQuery;
  TradeDate, DeptCode, AccNo, SubAccNo, IssueCode, TranCode, TradeType, BrkShtNo: string): boolean;

//------------------------------------------------------------------------------
// �ܰ��� �ֹ���ȣ�� ���� �ϴ� �༮ ������ // ������ �༮����  = 0
//------------------------------------------------------------------------------
function gf_CopyTradeToOrdTdF(ADOQuery_Trade, ADOQuery_Ordexe: TADOQuery;
  TradeDate, DeptCode, AccNo, SubAccNo, IssueCode, TranCode, TradeType: string): boolean;

//���� OLE ��������, ���� ��� �����Ŵ
function gf_GetExcelOleObject(bBackGround: boolean = False): Variant;

function GridColToXLCol(iCol: integer): string;

function gf_ExecQuery(pSQL: string): Boolean;

//��׶��� ������ﶧ �������� �ȳ������ϱ�
procedure gfSetDWNeverUpload;


//------------------------------------------------------------------------------
// ���� Import ���� CICS Call
//------------------------------------------------------------------------------
//�����ڷ� ���� Call
function gf_HostCICSsngetFACInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

//�Ÿ��ڷ� ���� Call
function gf_HostCICSsngetFTRInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

//��Ź�ڷ� ���� Call
function gf_HostCICSsngetFDPInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

//�̰����ڷ� ���� Call
function gf_HostCICSsngetFOPInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

//����ڷ� ���� Call
function gf_HostCICSsngetFLNInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;


//------------------------------------------------------------------------------

// Trunc ���� �Լ��� ����   String ��ȯ �ٽ� Double �ϸ� ����������
function gf_Trunc(X: Double): Double;

//------------------------------------------------------------------------------


function gf_GetProcCnt(sProcName: string): Integer;

//---------------------------------------------------------------------------
// ȭ����� �α���, �������� �αױ�� ó�� �Լ�.
//---------------------------------------------------------------------------
function gf_LogLstWrite(pADOQuery: TADOQuery; sDeptcd, sLogcd, sOprId, sOprDate, sStrTm, sEndTm,
  sOprIP, sEditUsr, sTrCd, sComment, sIUPos: string): Boolean;

function gf_GetLocalIP(Name: string; var IP: string): Boolean;

procedure gf_ExcelSaveAs(pXL: Variant; pFileName: string; pFileFormat: Integer = xlExcel9795);
function gf_GetXLOptionValue: string;


// [Y.S.M] 2011.2.1 ============================================================
// ó���� ������ ���� �޾� �� ���̿� �ִ� ����  Return�Ѵ�
function Gf_InsideString(const S, FirstString, LastString: string): string; overload;

function Gf_InsideString(const S, FirstString: string): string; overload;

// ������ ���̿� �ִ°��� Date �������� �����ͼ� �ش� ������ �����͸� ġȯ �Ѵ�.
function Gf_FormatDateDollarDollar(const S: string; pDate: TDateTime): string;

//==============================================================================

//  [Y.S.M] 2011.09.02
// StringList�� #0(Null) ~ ' '(�������) Delimiter�� �ν�.. �Լ��� ������..
// �Ķ���� StrictDelimiter:=True; �� ������ ������ 2007 �̻� ���� ����..
procedure gf_DelimiterStringList(Delimiter: char; DelimitedText: string; var pStringList: TStringList);

// [Y.K.J] 2012.05.05 ������ üũ (SP: SBP2801_TDC)
procedure gf_ExecSBP2801_TDC(iTrCode: integer; sDeptCode, sTradeDate: string);

function gf_GetCTMID(sTradeDate, sGB: string): string;


// [Y.S.M] 2012.08.08 //Computer �̸� ��������
//function gf_GetComName: string;
// Computer IP ���ؿ���
function gf_GetComIP: String;
// Computer IP �� ���ؿͼ� Hex�� ��ȯ
function gf_GetComIpToHex : string;

// ���Ϲ���ó�� �Լ�
function gf_ShowMergeMail(var GrpName, MailformId: string): Boolean;

//------------------------------------------------------------------------------
// PDF Engine ��� �� �μ� �Լ�
//------------------------------------------------------------------------------
procedure gf_DirectPrintForPDF(pPDFFileName: string);

//------------------------------------------------------------------------------
// ���� ����ִ°� Ȯ��
//------------------------------------------------------------------------------
function gf_IsFileInUse(fName: string): boolean;

implementation

uses
  SCCDataModule, SCCPreviewForm, UCrpe32, StrUtils, SCFH2106_MD, SCFH3106_MD, SCCMergeMail,
  SCCTFLib, SCCPreviewFormPDF;

//------------------------------------------------------------------------------
//  Crystal 10 DLL Registry ����ϱ� Function //2006.04.10 Delphi 7 version �߰� 1
//------------------------------------------------------------------------------
//Crystal 10 Dll�� �ݵ�� Registry�� ����ؼ� ��� �Ѵ�.
//������ Settup �۾��� �ϸ� ������ �ΰ��ΰ� ������ �۾��̴�
//���� Registry�� �ǵ� �� ���� �ܱ��踦 �����ϰ�
//Application ���Կ� �ڵ����� Crystal Dll�� ��ġ�Ѵ�.
//����, �� ��ġ�� PC�� �����Ѵ�.

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
      //sFtp activex ��ġ
      if not IsInstalledActiveX('Chilkat.SFtpDir.1') then
      begin
//        if Not ComRegister('EChilkatSsh.dll') then Exit;
        ComRegister('EChilkatSsh.dll');
      end;

      //DynamicPDF Viewer ��ġ
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
        //�ش� PC�� �̹� Crystal Report 10�� ����ֽ��ϴ�
        if trim(Reg.ReadString('Version')) > '' then Exit;

        //�̹� ��ϵǾ� ������ ��ġ ����. �װ� �µ� �ȸµ�.
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
      //else ���� ����, //Registry Read / Write ������ ������ �׳� �Ҹ����� �������. �ܱ��趫��.

      //Fax������ 
			//Export�� �̸������ Ʋ������ ���� �ذ� ������Ʈ
      Reg.RootKey:= HKEY_CURRENT_USER;
      if Reg.OpenKey('\SOFTWARE\Crystal Decisions\10.0\Crystal Reports\Export\PDF\', true) then
      begin
        Reg.WriteInteger('ForceLargerFonts',1);
        Reg.CloseKey;
      end;

    except //Registry Read / Write ������ ������ �׳� �Ҹ����� �������. �ܱ��趫��.
    end;
  finally
    Reg.Free;
  end;
end;

//------------------------------------------------------------------------------
//  EMail File ���� Main Function
//------------------------------------------------------------------------------

function gf_CreateEMailFile(pEMailFormId, pDirName, pDeptCode, pTradeDate: string;
  pGrpName: string; AccNoList: TStringList; var FileName: string;
  CreateFlag: boolean): boolean;

type // EMailFile ���� Function Type
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
  sXlsRPassWd, sXlsWPassWd: string; // �б�, ���� ��ȣ ����
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
          if Pos('����', Trim(FieldByName('MAILFORM_NAME_KOR').AsString)) <> 0 then
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
   //  ����ó�� ��ϵ� �б�/���� ��ȣ �������� ([Y.K.J]2011.01.27)
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
      gvErrorNo := 9108; // DLL Load ����
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
          gvErrorNo := 1134; // PDF �ڷ� ���� ����
          gvExtMsg := E.Message;
        end;
      end;
    finally
      FreeLibrary(DllHandle);
    end;

  end else
  begin
    //  ���� ���� ��� �߰�
    //  ���� �����϶��� ���� ���Ͽ��� ó��
    RealMailID := '';
    if Copy(pEMailFormId, 3, 1) = 'M' then
    begin
      RealMailID := pEMailFormId;
      pEMailFormId := 'MERGEMAIL';
      // YSM -> ���Ϲ����� ���� ���� ó��
      // ExtMsgArr ���� ó�� �ϴºκп� ���� ���̵� �Ѱ���.
      StrPCopy(ExtMsgArr, RealMailID);
      // EG_PDFDLL�� Ÿ��.. �ƴϸ� E_PDFDLL�̳�..
      // NM������  EN_PDFDLL = 2   Fix
      // TF������  EH_PDFDLL = 3   Fix
      // iErrorNo �̿��ؼ� �Ѱ���..
      {if gvSettleNetGlobalYN = 'Y' then
        iErrorNo := 1
      else
        iErrorNo := 0;}
       iErrorNo := 3;
    end;


    sDllName := pEMailFormId + '.DLL';
    sFuncName := 'gf_' + pEMailFormId;

      //20090819, DataRoad DB Only, ��Site�� SiteEmail Directory �̸�, Default ''
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
          gvErrorNo := 9108; // DLL Load ����
          gvExtMsg := sDllName;
          Exit;
        end;
      end;
    end
    else //�ŷ�ó Real DB : Client Bin������ ã��...
    begin
      DllHandle := LoadLibrary(pChar(sDllName));
      if (DllHandle = HINSTANCE_ERROR) or (DllHandle = 0) then
      begin
        Result := False;
        gvErrorNo := 9108; // DLL Load ����
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
         gvErrorNo := 9108;  // DLL Load ����
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
          gvErrorNo := 1134; // EMail �ڷ� ���� ����
          gvExtMsg := E.Message;
        end;
      end;
    finally
      FreeLibrary(DllHandle);
    end;

  end;
end;
//------------------------------------------------------------------------------
// gvIssueList���� �ش� �����ڵ忡 ���յǴ� Index ����
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
// �����ڵ��� ���� ����(TIssueType) ���� (�ش� ���� �������� ���� ��� False Return)
//------------------------------------------------------------------------------

function gf_ReturnIssueInfo(pSecType, pIssueCode: string; var pIssueItem: pTIssueType): boolean;
var
  Idx: Integer;
begin
  Result := False;
  pIssueItem := nil;
  if pSecType = gcSEC_EQUITY then // �ֽ�
  begin
    Idx := gf_ReturnIssueCodeIdx(gvEIssueList, pIssueCode);
    if Idx >= 0 then // �ش� ���� �����
    begin
      pIssueItem := gvEIssueList.Items[Idx];
      Result := True;
    end;
  end
  else if pSecType = gcSEC_FUTURES then // ����
  begin
    Idx := gf_ReturnIssueCodeIdx(gvFIssueList, pIssueCode);
    if Idx >= 0 then // �ش� ���� �����
    begin
      pIssueItem := gvFIssueList.Items[Idx];
      Result := True;
    end;
  end;
end;

//------------------------------------------------------------------------------
// �����ڵ带 ����ǥ���ڵ�� ��ȯ
//------------------------------------------------------------------------------

function gf_IssueCodeToFullCode(pSecType, pIssueCode: string): string;
var
  Idx: Integer;
  IssueItem: pTIssueType;
begin
  Result := '';
  if pSecType = gcSEC_EQUITY then //�ֽ�
  begin
    Idx := gf_ReturnIssueCodeIdx(gvEIssueList, pIssueCode);
    if Idx >= 0 then
    begin
      IssueItem := gvEIssueList.Items[Idx];
      Result := IssueItem.FullCode;
    end;
  end
  else if pSecType = gcSEC_FUTURES then // ����
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
// �����ڵ带 ��������� ��ȯ
//------------------------------------------------------------------------------

function gf_IssueCodeToFullName(pSecType, pIssueCode: string): string;
var
  Idx: Integer;
  IssueItem: pTIssueType;
begin
  Result := '';
  if pSecType = gcSEC_EQUITY then //�ֽ�
  begin
    Idx := gf_ReturnIssueCodeIdx(gvEIssueList, pIssueCode);
    if Idx >= 0 then
    begin
      IssueItem := gvEIssueList.Items[Idx];
      Result := IssueItem.FullName;
    end;
  end
  else if pSecType = gcSEC_FUTURES then //����
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
// �����ڵ带 ������������ ��ȯ
//------------------------------------------------------------------------------

function gf_IssueCodeToShortName(pSecType, pIssueCode: string): string;
var
  Idx: Integer;
  IssueItem: pTIssueType;
begin
  Result := '';
  if pSecType = gcSEC_EQUITY then //�ֽ�
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
// ������� �����ڵ�� ��ȯ
//------------------------------------------------------------------------------

function gf_IssueFullNameToCode(pSecType, pIssueName: string): string;
var
  I: Integer;
  IssueItem: pTIssueType;
begin
  Result := '';
  if pSecType = gcSEC_EQUITY then //�ֽ�
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
  else if pSecType = gcSEC_FUTURES then // ����
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
// ���������� �����ڵ�� ��ȯ
//------------------------------------------------------------------------------

function gf_IssueShortNameToCode(pSecType, pIssueName: string): string;
var
  I: Integer;
  IssueItem: pTIssueType;
begin
  Result := '';
  if pSecType = gcSEC_EQUITY then //�ֽ�
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
  else if pSecType = gcSEC_FUTURES then // ����
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
// ���񸮽�Ʈ ����
// �ڵ�� ����: pAscCodeFlag = True, �ڵ���� ����: pAscCodeFlag = False
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
  if pAscCodeFlag then // �ڵ������ ����
    pIssueList.Sort(IssueListCompareCode)
  else // �ڵ�������� ����
    pIssueList.Sort(IssueListCompareName);
end;

//------------------------------------------------------------------------------
// CodeList�� �����Ͽ� Code�� Name���� ��ȯ�Ͽ� ����
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
  if Idx < 0 then Exit; // �ش� Party ID �������� ����
  Result := CodeItem.Name;
end;

//------------------------------------------------------------------------------
// CodeList�� �����Ͽ� Name�� Code�� ��ȯ�Ͽ� ����
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
  if Idx < 0 then Exit; //�ش� Party Name�� �������� ����
  Result := CodeItem.Code;
end;

//------------------------------------------------------------------------------
// DeptCode�� Name���� ��ȯ�Ͽ� ��õ
//------------------------------------------------------------------------------

function gf_DeptCodeToName(pDeptCode: string): string;
begin
  Result := gf_CodeToName(gvDeptCodeList, pDeptCode);
end;

//------------------------------------------------------------------------------
// DeptName�� Code�� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_DeptNameToCode(pDeptName: string): string;
begin
  Result := gf_NameToCode(gvDeptCodeList, pDeptName);
end;

//------------------------------------------------------------------------------
// FundType�� Name���� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_FundTypeToName(pFundType: string): string;
begin
  Result := gf_CodeToName(gvFundTypeList, pFundType);
end;

//------------------------------------------------------------------------------
// Fundtype���� FundType���� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_FundTypeNameToType(pFundTypeName: string): string;
begin
  Result := gf_NameToCode(gvFundTypeList, pFundTypeName);
end;

//------------------------------------------------------------------------------
// Sec Type�� Name���� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_SecTypeToName(pSecType: string): string;
begin
  Result := gf_CodeToName(gvSecTypeList, pSecType);
end;

//------------------------------------------------------------------------------
// Sec Name�� Type���� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_SecNameToType(pSecName: string): string;
begin
  Result := gf_NameToCode(gvSecTypeList, pSecName);
end;

//------------------------------------------------------------------------------
// Tran Mtd�� Name���� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_TranMtdToName(pTranMtd: string): string;
begin
  Result := gf_CodeToName(gvTranMtdList, pTranMtd);
end;

//------------------------------------------------------------------------------
// Tran Mtd Name�� Tran Mtd �� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_TranNametoMtd(pTranName: string): string;
begin
  Result := gf_NameToCode(gvTranMtdList, pTranName);
end;

//------------------------------------------------------------------------------
// Com Type�� Name���� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_ComTypeToName(pComType: string): string;
begin
  Result := gf_CodeToName(gvComTypeList, pComType);
end;

//------------------------------------------------------------------------------
// Com Name�� Type���� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_ComNameToType(pComName: string): string;
begin
  Result := gf_NameToCode(gvComTypeList, pComName);
end;

//------------------------------------------------------------------------------
// Mkt Type�� Name���� ��ȭ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_MktTypeToName(pMktType: string): string;
begin
  Result := gf_CodeToName(gvMktTypeList, pMktType);
end;

//------------------------------------------------------------------------------
// Mkt Name�� Type���� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_MktNameToType(pMktName: string): string;
begin
  Result := gf_NameToCode(gvMktTypeList, pMktName);
end;

//------------------------------------------------------------------------------
// Tran Code�� Name���� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_TranCodeToName(pTranCode: string): string;
begin
  Result := gf_CodeToName(gvTranCodeList, pTranCode);
end;

//------------------------------------------------------------------------------
// Tran Code Name�� Tran Code�� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_TranNameToCode(pTranName: string): string;
begin
  Result := gf_NameToCode(gvTranCodeList, pTranName);
end;

//------------------------------------------------------------------------------
// PartyID�� Name���� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_PartyIDToName(pPartyID: string): string;
begin
  Result := gf_CodeToName(gvPartyIDList, pPartyID);
end;

//------------------------------------------------------------------------------
// Party Name�� ID�� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_PartyNameToID(pPartyName: string): string;
begin
  Result := gf_NameToCode(gvPartyIDList, pPartyName);
end;

//------------------------------------------------------------------------------
// TeamCode�� Name���� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_TeamCodeToName(pTeamCode: string): string;
begin
  Result := gf_CodeToName(gvTeamCodeList, pTeamCode);
end;
//------------------------------------------------------------------------------
// TeamName�� Code�� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_TeamNameToCode(pTeamName: string): string;
begin
  Result := gf_NameToCode(gvTeamCodeList, pTeamName);
end;

//------------------------------------------------------------------------------
// RoleCode�� Name���� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_RoleCodeToName(pRoleCode: string): string;
begin
  Result := gf_CodeToName(gvRoleCodeList, pRoleCode);
end;

//------------------------------------------------------------------------------
// RoleName�� Code�� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_RoleNameToCode(pRoleName: string): string;
begin
  Result := gf_NameToCode(gvRoleCodeList, pRoleName);
end;

//------------------------------------------------------------------------------
// ReprotID�� Name���� ��ȯ�Ͽ� ����
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
// ReportName�� Report ID�� ��ȯ�Ͽ� ����
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
// CompCode�� Name���� ��ȯ�Ͽ� ����
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
// CompName�� Code�� ��ȯ�Ͽ� ����
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
// �ش� Report�� ���� Direction ����
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
// �ش� Report�� ���� ReportType ����
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
// FundType�� Name���� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_FundTypeCodeToName(pFundTypeCode: string): string;
begin
  Result := gf_CodeToName(gvFundTypeList, pFundTypeCode);
end;

//------------------------------------------------------------------------------
// FundTypeName�� Type���� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_FundTypeNameToCode(pFundTypeName: string): string;
begin
  Result := gf_NameToCode(gvFundTypeList, pFundTypeName);
end;

//------------------------------------------------------------------------------
// SellBuyCode�� Name���� ��ȯ�Ͽ� ����
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
// SellBuyName�� Code�� ��ȯ�Ͽ� ����
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
// SendMethod Code�� Name���� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_SendMtdCodeToName(pSendMtdCode: string): string;
begin
  Result := gf_CodeToName(gvSendMtdList, pSendMtdCode);
end;

//------------------------------------------------------------------------------
// Execution Module�� Version�� Return��(1.1.0.1)
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
    begin //Exception�� �Ȱɸ��� ����.
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
// �ش� ������ ���� ������ �Ǿ����� Ȯ��
//------------------------------------------------------------------------------

function gf_FutDailySettled(pTradeDate: string): string;
begin
  Result := '';
  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' Select CLS_YN = ISNULL(max(CLS_YN), ''N'')   ' //ù��° Row�� �����´�.
      + ' From   SFDEPGT_TBL     '
      + ' Where  DEPT_CODE  = ''' + gvDeptCode + ''' '
      + '   and  TRADE_DATE = ''' + pTradeDate + ''' '
      + '   and  MANUAL_YN  = ''N''                  ');
//              + ' GROUP BY DEPT_CODE, TRADE_DATE, CLS_YN    ');

    gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

    if RecordCount <= 0 then exit; // ����Ÿ�� ���� ���
    Result := Trim(FieldByName('CLS_YN').asString);
  end;
end;

//------------------------------------------------------------------------------
// �ΰ��� StringList�� �������� �Ǵ�
//------------------------------------------------------------------------------

function gf_IsSameStringList(pStrList1, pStrList2: TStringList): boolean;
var
  Str1, Str2: string;
  I: Integer;
begin
  Result := False;
  if pStrList1.Count <> pStrList2.Count then Exit; // StringList�� Strings������ �ٸ�
  for I := 0 to pStrList1.Count - 1 do
  begin
    Str1 := pStrList1.Strings[I];
    Str2 := pStrList2.Strings[I];
    if Str1 <> Str2 then Exit;
  end; // end of for
  Result := True;
end;

//------------------------------------------------------------------------------
// �ش� SendMethod�� ��밡������ �Ǵ�
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
// SendMethod Name�� SendMethod Code�� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_SendMtdNameToCode(pSendMtdName: string): string;
begin
  Result := gf_NameToCode(gvSendMtdList, pSendMtdName);
end;

//------------------------------------------------------------------------------
// CustProp Code�� Name���� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_CustPropCodeToName(pCustPropCode: string): string;
begin
  Result := '';
  if pCustPropCode = gcKSD_CUST then Result := gwKSDCust
  else if pCustPropCode = gcKSD_PROP then Result := gwKSDProp;
end;

//------------------------------------------------------------------------------
// CustProp Name�� Code�� ��ȯ�Ͽ� ����
//------------------------------------------------------------------------------

function gf_CustPropNameToCode(pCustPropName: string): string;
begin
  Result := '';
  if pCustPropName = gwKSDCust then Result := gcKSD_CUST
  else if pCustPropName = gwKSDProp then Result := gcKSD_PROP;
end;

//------------------------------------------------------------------------------
//   Log File ���(Thread Safe)
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
//  Data ���۽� Ƚ�� ä��
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
      Parameters.ParamByName('@in_biz_type').Value := '11'; //11: ȸ��
      Parameters.ParamByName('@in_get_flag').Value := '2';
      Execute;
    except
      on E: Exception do
      begin
        gvErrorNo := 9002; // StoredProcedure ���� �����Դϴ�.
        gvExtMsg := 'SP0103: ' + E.Message;
        Exit;
      end;
    end;
    RtnValue := Parameters.ParamByName('@out_rtc').Value;
    if (Trim(RtnValue) <> '') and (RtnValue <> '0000') then //���� �߻�
    begin
      gvErrorNo := 9002; // StoredProcedure ���� �����Դϴ�.
      gvExtMsg := 'SP0103: ' + Parameters.ParamByName('@out_kor_msg').Value;
      Exit;
    end;
    Result := Parameters.ParamByName('@out_snd_no').Value;
  end;
end;

//------------------------------------------------------------------------------
//  Data ���۽� �Ѽ۽� Seq. No ä��
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
      Parameters.ParamByName('@in_biz_type').Value := '01'; //01: �Ѽ۽Ź�ȣ
      Parameters.ParamByName('@in_get_flag').Value := '2';
      Execute;
    except
      on E: Exception do
      begin
        gvErrorNo := 9002; // StoredProcedure ���� �����Դϴ�.
        gvExtMsg := 'SP0103: ' + E.Message;
        Exit;
      end;
    end;
    RtnValue := Parameters.ParamByName('@out_rtc').Value;
    if (Trim(RtnValue) <> '') and (RtnValue <> '0000') then //���� �߻�
    begin
      gvErrorNo := 9002; // StoredProcedure ���� �����Դϴ�.
      gvExtMsg := 'SP0103: ' + Parameters.ParamByName('@out_kor_msg').Value;
      Exit;
    end;
    Result := Parameters.ParamByName('@out_snd_no').Value;
  end;
end;


//------------------------------------------------------------------------------
//  Fax ���۽� Ƚ�� ä��
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
      Parameters.ParamByName('@in_biz_type').Value := '11'; //11: ȸ��
      Parameters.ParamByName('@in_get_flag').Value := '2';
      Execute;
    except
      on E: Exception do
      begin // StoredProcedure ���� �����Դϴ�.
        gvErrorNo := 9002; // StoredProcedure ���� �����Դϴ�.
        gvExtMsg := 'SP0103: ' + E.Message;
        Exit;
      end;
    end;
    RtnValue := Parameters.ParamByName('@out_rtc').Value;
    if (Trim(RtnValue) <> '') and (RtnValue <> '0000') then //���� �߻�
    begin
      gvErrorNo := 9002; // StoredProcedure ���� �����Դϴ�.
      gvExtMsg := 'SP0103: ' + Parameters.ParamByName('@out_kor_msg').Value;
      Exit;
    end;
    Result := Parameters.ParamByName('@out_snd_no').Value;
  end;
end;

//------------------------------------------------------------------------------
//  Fax ���۽� �Ѽ��� Seq. No ä��
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
      Parameters.ParamByName('@in_biz_type').Value := '01'; //01: �Ѽ۽Ź�ȣ
      Parameters.ParamByName('@in_get_flag').Value := '2';
      Execute;
    except
      on E: Exception do
      begin // StoredProcedure ���� �����Դϴ�.
        gvErrorNo := 9002; // StoredProcedure ���� �����Դϴ�.
        gvExtMsg := 'SP0103: ' + E.Message;
        Exit;
      end;
    end;
    RtnValue := Parameters.ParamByName('@out_rtc').Value;
    if (Trim(RtnValue) <> '') and (RtnValue <> '0000') then //���� �߻�
    begin
      gvErrorNo := 9002; // StoredProcedure ���� �����Դϴ�.
      gvExtMsg := 'SP0103: ' + Parameters.ParamByName('@out_kor_msg').Value;
      Exit;
    end;
    Result := Parameters.ParamByName('@out_snd_no').Value;
  end;
end;

//------------------------------------------------------------------------------
//  ���¹�ȣ Formatting : 00000000000,0000 -> 0000000000-0000
//------------------------------------------------------------------------------

function gf_FormatAccNo(pAccNo, pSubAccNo: string): string;
begin
  if Trim(pSubAccNo) = '' then
    Result := pAccNo
  else // SubAccNo ����
    Result := pAccNo + '-' + pSubAccNo;
end;

//------------------------------------------------------------------------------
// ���¹�ȣ unformatting : 0000000000-0000 -> 00000000000, 0000
//------------------------------------------------------------------------------

procedure gf_UnformatAccNo(pFormatAccNo: string; var pAccNo, pSubAccNo: string);
var
  iPos: Integer;
begin
  iPos := Pos('-', pFormatAccNo);
  if iPos <= 0 then // SubAccNo�� �������� ����
  begin
    pAccNo := pFormatAccNo;
    pSubAccNo := '';
  end
  else // SubAccNo�� ����
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
// Report������ Date Formatting : YYYYMMDD -> YYYY/MM/DD
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
// DiffTime Formating -> H�ð� M�� S��
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
    copy(pJobDate, 5, 4) + // ��������
    pReportId + // Report Id
//             copy(pReportId, 1, 2) + copy(pReportId, 6, 2) + // Report Id
  pAccNo; //���¹�ȣ
  if Trim(pSubAccNo) <> '' then
    Result := Result + '-' + pSubAccNo; // �ΰ��� �����

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
//   ���� Ȯ��(YYYYMMDD ����)
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
//  ���� ���� �������� �Լ�(YYYYMMDD)
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
//  ���� �ð� �������� �Լ�(HHMMSSMM)
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
//  ���� ���� ���ϴ� �Լ�, ���� �߻��� �ش� ���� Message ����
//  ApplyType => 00 : ����, �Ϲ�
//               11 : �ֽ��ⳳ                 12 : �ֽĸŸ�
//               21 : ä���ⳳ                 22 : ä�ǸŸ�
//               31 : KOSPI�ⳳ, �����ɼ��ⳳ  32 : KOSPI�Ÿ�, �����ɼǸŸ�
//               41 : KOFEX�ⳳ                42 : KOFEX�Ÿ�
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
      begin // StoredProcedure ���� �����Դϴ�.
        Result := '[9002]' + gf_ReturnMsg(9002) + 'SP0019: ' + E.Message;
        Exit;
      end;
    end;
    RtnValue := Parameters.ParamByName('@out_rtc').Value;
    if (Trim(RtnValue) <> '') and (RtnValue <> '0000') then //���� �߻�
    begin
      Result := '[9002]' + gf_ReturnMsg(9002) + 'SP0019: ' // StoredProcedure ���� �����Դϴ�.
        + Parameters.ParamByName('@out_kor_msg').Value;
      Exit;
    end;
    pSettleDate := Parameters.ParamByName('@out_date').Value;
  end;
end;

//------------------------------------------------------------------------------
//  �������� ���� ���ϴ� �Լ�
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
// Conversion Error �߻��� 0�� Return�Ǵ� StrToFloat
//------------------------------------------------------------------------------

function gf_StrToFloat(pStr: string): double;
begin
  if Length(Trim(pStr)) = 0 then // Space �Է½�
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
// Conversion Error �߻��� 0�� Return�Ǵ� StrToInteger
//------------------------------------------------------------------------------

function gf_StrToInt(pStr: string): Integer;
begin
  if Length(Trim(pStr)) = 0 then // Space �Է½�
    Result := 0
  else
    Result := StrToIntDef(Trim(pStr), 0)
end;

//------------------------------------------------------------------------------
//  Currency Comma�� ���ְ� �ش� ���� return �ϴ� �Լ�
//------------------------------------------------------------------------------

function gf_CurrencyToFloat(pStr: string): double;
var
  DestArray, SrcArray: array[0..255] of Char;
  iDest, iSrc: Integer;
  NumStr: string;
begin
  if length(pStr) > 256 then // ó���� �� ���� ���� string
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
//  [�ѿ�] ���� ���� Ȯ�� �� ���¸� Return
//  ��������� True Return, �������� ���� ��� False Return
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
//  Dialog Message ���
//------------------------------------------------------------------------------

function gf_ShowDlgMessage(pTrCode: LongInt; pDlgType: TMsgDlgType; pMsgNo: LongInt; pExtMsg: string;
  pButtons: TMsgDlgButtons; pHelpCtx: LongInt): Integer;
var
  TmpMsg: string;
begin
  if pMsgNo <= 0 then // MsgNo <= 0 �̸� Extended Msg�� ����ϰڴٴ� �ǹ�
    TmpMsg := pExtMsg
  else
    TmpMsg := '[' + IntToStr(pMsgNo) + '] ' + gf_ReturnMsg(pMsgNo) + gcMsgLineInterval + pExtMsg;

  with CreateMessageDialog(TmpMsg, pDlgType, pButtons) do
  begin
    try
      Position := poscreenCenter; //poDesktopCenter; //
      FormStyle := fsStayOnTop;
         //!!! Font�� �ٲ� �� �ִ�
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
// Error Dialog Message (��/��)
//------------------------------------------------------------------------------

function gf_ShowErrDlgMessage(pTrCode: LongInt; pMsgNo: LongInt; pExtMsg: string; pHelpCtx: LongInt): Integer;
var
  TmpMsg: string;
begin
  if pMsgNo <= 0 then // MsgNo <= 0 �̸� Extended Msg�� ����ϰڴٴ� �ǹ�
    TmpMsg := pExtMsg
  else
    TmpMsg := '[' + IntToStr(pMsgNo) + '] ' + gf_ReturnMsg
      (pMsgNo) + gcMsgLineInterval + pExtMsg;

  with CreateMessageDialog(TmpMsg, mtError, [mbOK]) do
  begin
    try
         //!!! Font�� �ٲ� �� �ִ�
      HelpContext := pHelpCtx;
      if pTrCode = 0 then
        Caption := gcApplicationName
      else
        Caption := gcApplicationName + '[' + IntToStr(pTrCode) + ']';
//         SetForeGroundWindow(gvMainFrameHandle); �̰� Ǯ�� modal ���� modal�� ù��° ����� �������
      Result := ShowModal;
    finally
      Free;
    end;
  end;
end;

//------------------------------------------------------------------------------
// [�ѿ�] MessageBar�� Message ���
//------------------------------------------------------------------------------

procedure gf_ShowMessage(pMsgBar: TDRMessageBar; pMsgType: TMsgDlgType; pMsgNo: LongInt; pExtMsg: string);
begin
  if pMsgNo <= 0 then // MsgNo <= 0 �̸� Extended Msg�� ����ϰڴٴ� �ǹ�
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
//  [�ѿ�] Message ��ȣ�� �޾� �ش� Message return
//------------------------------------------------------------------------------

function gf_ReturnMsg(pMsgNo: LongInt): string; // Message ��ȣ�� �޾� �ش� Message return
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
        Result := '�ش� Message ��ȣ�� �������� �ʽ��ϴ�.';
    except
      on E: Exception do
        Result := 'Message Error-' + E.Message;
    end;
  end;
end;

//------------------------------------------------------------------------------
// currency comma string���� currency comma ������ string return
//------------------------------------------------------------------------------

function gf_CurrencyToStr(pStr: string): string;
var
  DestArray, SrcArray: array[0..255] of Char;
  iDest, iSrc: Integer;
  NumStr: string;
begin
  if length(pStr) > 256 then // ó���� �� ���� ���� string
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
// Query Open�� ������ Shared Lock�� Ǯ����
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
// Query Open�� ������ Shared Lock�� Ǯ����
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
// Update, Insert, Delete�� �����ϴ� SQL ����
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
// Update, Insert, Delete�� �����ϴ� SQL ����
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
// Parameter�� �������� Stored Proc �� ����
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
// Parameter�� �������� Stored Proc �� ����
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
//  ResultSet�� �������� Stored Proc �� ����
//------------------------------------------------------------------------------

procedure gf_GetResultProc(pStoredProc: TStoredProc);
begin
  with pStoredProc do
  begin
    if not Prepared then Prepare;
    Active := True;
    DisableControls;
//      GetResults;  +++ Test �� ���� ����
    FetchAll;
    First;
    EnableControls;
  end;
end;

//------------------------------------------------------------------------------
//  ResultSet�� �������� Stored Proc �� ����
//------------------------------------------------------------------------------

procedure gf_ADOGetResultProc(pStoredProc: TADOStoredProc);
begin
  with pStoredProc do
  begin
    if not Prepared then Prepared := True;
    Active := True;
    DisableControls;
//      GetResults;  +++ Test �� ���� ����
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
//   List Sort�� Item ũ�� �񱳸� ���� �Լ�(Sting)
//----------------------------------------------------------------------------------=

function gf_ReturnStrComp(pTemp1, pTemp2: string; pAscending: boolean): Integer;
begin
  if pAscending then //���������� ���� ��
  begin
    if pTemp1 > pTemp2 then
      Result := 1
    else if pTemp1 = pTemp2 then
      Result := 0
    else
      Result := -1;
  end
  else // ���������� ���� ��
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

   // ����� ���� ���� ���� Ȯ��
  if not FileExists(pFileName) then
  begin
    gvErrorNo := 1027; // �ش� ������ �������� �ʽ��ϴ�.
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
    gvErrorNo := 1027; // �ش� ������ �������� �ʽ��ϴ�.
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
      // Printer���� �����Ǵ� Font �� Courier�� �ٻ� Font Search
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
    Printer.Canvas.TextOut(x, y, ''); //*** ������ ���� �� �غ� ��
    Printer.Canvas.TextOut(x, y + LineHeight, '>> End of Report');
  except
    on E: Exception do
    begin
      gvErrorNo := 1102; // �μ� �� ���� �߻�
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
      // Printer���� �����Ǵ� Font �� Courier�� �ٻ� Font Search
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
    Printer.Canvas.TextOut(x, y, ''); //*** ������ ���� �� �غ� ��
    Printer.Canvas.TextOut(x, y + LineHeight, '>> End of Report');
  except
    on E: Exception do
    begin
      gvErrorNo := 1102; // �μ� �� ���� �߻�
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
// Main Frame�� Main Menu, ToolBar Enable
//------------------------------------------------------------------------------

procedure gf_EnableMainMenu;
begin
  SendMessage(gvMainFrameHandle, WM_USER_ENABLE_MENU, 0, 0);
end;

//------------------------------------------------------------------------------
// Main Frame�� Main Menu, ToolBar Disable
//------------------------------------------------------------------------------

procedure gf_DisableMainMenu;
begin
  SendMessage(gvMainFrameHandle, WM_USER_DISABLE_MENU, 0, 0);
end;

//------------------------------------------------------------------------------
// ����ó ��� ȭ�鿡���� Send Method�� ���� Color Return
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
// Child Form ����
//------------------------------------------------------------------------------

procedure gf_CreateForm(pTrCode: Integer);
begin
  if pTrCode > 0 then
    SendMessage(gvMainFrameHandle, WM_USER_CREATE_FORM, pTrCode, 0);
end;

//------------------------------------------------------------------------------
// Code Table ���� �� ȣ�� (MainFrame�� CodeList ���� message ����)
//------------------------------------------------------------------------------

procedure gf_RefreshCodeList(pCodeTableNo: Integer);
begin
  SendMessage(gvMainFrameHandle, WM_USER_REFRESH_CODELIST, pCodeTableNo, 0);
end;

//------------------------------------------------------------------------------
// Group Table ���� �� ȣ�� (MainFrame�� Group List message ����)
//------------------------------------------------------------------------------

procedure gf_RefreshGroupList;
begin
  SendMessage(gvMainFrameHandle, WM_USER_REFRESH_GROUPLIST, 0, 0);
end;

//------------------------------------------------------------------------------
// Global ���� ���� ������ ���� �� ȣ�� (MainFrame�� Global var ���� message ����)
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
//   List Sort�� Item ũ�� �񱳸� ���� �Լ�(Double)
//------------------------------------------------------------------------------

function gf_ReturnFloatComp(pTemp1, pTemp2: double; pAscending: boolean): Integer;
begin
  if pAscending then //���������� ���� ��
  begin
    if pTemp1 > pTemp2 then
      Result := 1
    else if pTemp1 = pTemp2 then
      Result := 0
    else
      Result := -1;
  end
  else // ���������� ���� ��
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
// �ش� ȭ�鿡 ���� ���� ���� Ȯ��
//------------------------------------------------------------------------------

function gf_CheckUsableMenu(pTrCode: Integer): boolean;
begin
   //+++ ���� ��
  Result := True;
end;

//------------------------------------------------------------------------------
//   ����Ʈ �ϱ� �� ������ ȯ�� ����
//------------------------------------------------------------------------------

function gf_InitPrint(pPrnComponent: TObject): boolean;
begin
  if gvPrinter.PrinterIdx = gcNonePrinter then //Printer�� ������� ���� ���
  begin
    Result := False;
    Exit;
  end;

   // Printer�� ����� ���
  Result := True;
  if pPrnComponent <> nil then
  begin
    if pPrnComponent.ClassName = 'TQuickRep' then // QuickReport�� ���
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
  else //�Ϲ����� ��print
  begin
    Printer.Title := gcApplicationName;
    Printer.PrinterIndex := gvPrinter.PrinterIdx;
    Printer.Copies := gvPrinter.Copies;
    Printer.Orientation := gvPrinter.Orientation;
  end; // end of else
  gvPrinter.Copies := 1; //�ϴ� �ѹ� Print�� �Ѵ������� 1�� �ʱ�ȭ
end;

//------------------------------------------------------------------------------
//  Application�� Root Path Return (SettleNet -> C:\Program Files\SettleNet
//------------------------------------------------------------------------------

function gf_GetAppRootPath: string;
var
  ExecPath: string;
begin
  ExecPath := ExtractFilePath(Application.ExeName);
  Result := ExecPath + '..\' // Application�� RootDir/Bin ���� ����ȴٴ� ���� �ʿ�
end;

//------------------------------------------------------------------------------
//  Row Selection�� ��ġ�� SelRowIdx�� ��ġ�� �ű�
//------------------------------------------------------------------------------

procedure gf_SelectStrGridRow(pStringGrid: TStringGrid; SelRowIdx: Integer);
var
  SelectRect: TRect;
begin
  if (SelRowIdx > pStringGrid.RowCount - 1) or (SelRowIdx < pStringGrid.FixedRows) then // StringGrid�������� RowIndex�� ���
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
//  Cell Selection�� ��ġ�� SelColIdx, SelRowIdx����ġ�� �ű�
//------------------------------------------------------------------------------

procedure gf_SelectStrGridCell(pStringGrid: TStringGrid; SelColIdx, SelRowIdx: Integer);
begin
  with pStringGrid do
  begin
    if (SelColIdx > pStringGrid.ColCount - 1) or (SelColIdx < pStringGrid.FixedCols) then // StringGrid�������� ColIndex�� ���
      Exit;
    if (SelRowIdx > pStringGrid.RowCount - 1) or (SelRowIdx < pStringGrid.FixedRows) then // StringGrid�������� RowIndex�� ���
      Exit;

    Col := SelColIdx;
    Row := SelRowIdx;
  end;
end;

//------------------------------------------------------------------------------
//  StringGrid�� Cell�� �����ִ� �Լ�
//  StartCol, StartRow -> ������ ���� column, ���� row ����
//  EndCol, EndRow -> ������ ������ column, ������ row����
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
// StringGrid�� FixedCell�� ������ ��� Cell�� ������
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
// StringGrid�� ColIdx, RowIdx�� �ش��ϴ� Cell Click
//------------------------------------------------------------------------------

procedure gf_ClickStrGrid(pStringGrid: TStringGrid; ColIdx, RowIdx: Integer);
var
  XPos, YPos: Integer;
  R: TRect;
  Msg: TMessage;
begin
  if (ColIdx > pStringGrid.ColCount - 1) or (ColIdx < pStringGrid.FixedCols) then // StringGrid�������� ColIndex�� ���
    Exit;
  if (RowIdx > pStringGrid.RowCount - 1) or (RowIdx < pStringGrid.FixedRows) then // StringGrid�������� RowIndex�� ���
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
// �ش� Index�� StringGrid�� ���� ���� Row�� �̵���Ŵ
//------------------------------------------------------------------------------

procedure gf_SetTopRow(pStringGrid: TStringGrid; CurIdx: Integer);
begin
  if (CurIdx > pStringGrid.RowCount - 1) or (CurIdx < pStringGrid.FixedRows) then // StringGrid�������� RowIndex�� ���
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
    gvErrorNo := 9106; // system����
    gvExtMsg := '';
    Exit;
  end;

  Screen.Cursor := crHourGlass;

  if gvPrinter.PrinterIdx = gcNonePrinter then
  begin
    gvErrorNo := 1111; // ���� ������ �����Ͱ� �����ϴ�.
    gvExtMsg := '';
    Screen.Cursor := crDefault;
    Exit;
  end;

  // ���� ���Ŀ� ���� ó��.
  if (gvFaxReportFileType <> gcFILE_TYPE_PDF) then
  begin
    // Crystal Report ó��.
    with Datamodule_Settlenet.Crpe1 do
    begin
      if not Assigned(RepForm_Preview) then
      begin
        Application.CreateForm(TRepForm_Preview, RepForm_Preview);
        RepForm_Preview.Parent := gvMainFrame;
      end;
      ReportName := ExpFileName;
      //[Y.S.M] 2013.07.02 Printer Clear �߰�  �������� �� �̸����� ��
      printer.Clear;
      Output := toWindow;
      WindowZoom.Magnification := gvPreviewPercent;
      RepForm_Preview.Show;

        //------------------------------------------------------------------------
        //������ Preveiw ȭ�鿡�� �����Ϳ��� �ؾ� �ϴµ�
        //�ű⿡���� ������ �Ÿ��� ȭ�� ������ ���⼭ ���ش�.
        //------------------------------------------------------------------------
      try
        Printer.Retrieve;
        Printer.PreserveRptSettings := [prOrientation];
        Printer.Send;
      except
        on E: Exception do
        begin
          gvErrorNo := 8003; //Privew Execute ����
          gvExtMsg := 'Printer.Sender ���� ' + E.Message;
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
          gvErrorNo := 8003; //Privew Execute ����
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

  // ���� ���Ŀ� ���� ó��.
  if (gvFaxReportFileType <> gcFILE_TYPE_PDF) then
  begin
    with Datamodule_Settlenet.crpe1 do
    begin
      ReportName := ExpFileName;

      if gvPrinter.PrinterIdx = gcNonePrinter then
      begin
        gvErrorNo := 1111; // ���� ������ �����Ͱ� �����ϴ�.
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
          gvErrorNo := 8004; //Printer Execute ����
          gvExtMsg := 'Printer.Sender ���� ' + E.Message;
          Screen.Cursor := crDefault;
          CloseJob;
          Exit;
        end;
      end; //try

      ProgressDialog := False;
      //[Y.S.M] 2013.07.02 Printer Clear �߰� �μ��
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
          gvErrorNo := 8004; //Printer Execute ����
          gvExtMsg := E.Message;
          CloseJob;
          Screen.Cursor := crDefault;
          Exit;
        end;
      end; // try
      CloseJob;
    end;
  end else
  // PDF Engine ó��.
  begin
    // PDF �μ�
    gf_DirectPrintForPDF(ExpFileName);
  end;

  Screen.Cursor := crDefault;
  Result := True;
end;

//------------------------------------------------------------------------------
// EMail Attaxh File ����
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
        gvErrorNo := 9001; // DataBase �����Դϴ�.
        gvExtMsg := E.Message;
        Exit;
      end;
    end;

    if RecordCount = 0 then
    begin
      gvErrorNo := 1068; // �ش� ������ �о�� �� �����ϴ�.
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
        gvErrorNo := 9006; // ���� ���� ����
        gvExtMsg := '';
        Exit;
      end;
    end;
    Result := True;
  end; // end of with
end;

//------------------------------------------------------------------------------
//  Fax/Tlx ���� Image��  File�� ����
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
      + '   and DATALENGTH(fi.MAIN_DATA) <> 0 '); // �������� MAIN_DATA�� ������ �߰�~~
    try
      gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
    except
      on E: Exception do
      begin
        gf_ShowErrDlgMessage(0, 9001, E.Message, 0);
        gvErrorNo := 9001; // DataBase �����Դϴ�.
        gvExtMsg := E.Message;
        Exit;
      end;
    end;

    if RecordCount = 0 then
    begin
      gvErrorNo := 1068; // �ش� ������ �о�� �� �����ϴ�.
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
        gvErrorNo := 9006; // ���� ���� ����
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
// Telex�� �����ڵ� Ȯ��
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
// Text File�� �����ں� Unit���� Split���� ����
// P.H.S 2006.08.08   ���ϸ��� pFreqNo(ȸ��) �߰�
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
  gvErrorNo := 1132; // Export �� ���� �߻�
  gvExtMsg := '';

   // Assign Read File
  AssignFile(SrcFile, pSrcFileName);
{$I-}
  Reset(SrcFile);
{$I+}
  if IOResult <> 0 then
  begin
    gvErrorNo := 1027; // �ش� ������ �������� �ʽ��ϴ�.
    gvExtMsg := '';
    try
      CloseFile(SrcFile);
    except
      on EInOutError do
      begin
           // �̰��� ������ I/O Error Exception�� ���� ���� �߻�
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
      gvErrorNo := 9006; // ���� ���� ����
      gvExtMsg := '';
      try
        CloseFile(SrcFile);
        CloseFile(DesFile);
      except
        on EInOutError do //�̹� Word�� ���α׷����� ���� ��� 103 Error �߻�
        begin
              // �̰��� ������ I/O Error Exception�� ���� ���� �߻�
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
           // �̰��� ������ I/O Error Exception�� ���� ���� �߻�
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

      // ȭ�ϸ��� Ư������ ���Ծȵ�.
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
      gvErrorNo := 9006; // ���� ���� ����
      gvExtMsg := '';
      try
        CloseFile(SrcFile);
        CloseFile(DesFile);
      except
        on EInOutError do //�̹� Word�� ���α׷����� ���� ��� 103 Error �߻�
        begin
              // �̰��� ������ I/O Error Exception�� ���� ���� �߻�
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
        // �̰��� ������ I/O Error Exception�� ���� ���� �߻�
    end;
  end;
  Result := True;
end;

//------------------------------------------------------------------------------
// Text File�� Page ���е� Text File�� ��ȯ
// 2006.08.31 P.H.S (#12) ����
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
  gvErrorNo := 1128; // TEXT ���� ��ȯ �� ���� �߻�
  gvExtMsg := '';

  if not FileExists(pSrcFileName) then
  begin
    gvErrorNo := 1027; // �ش� ������ �������� �ʽ��ϴ�.
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
    gvErrorNo := 1027; // �ش� ������ �������� �ʽ��ϴ�.
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
    gvErrorNo := 9006; // ���� ���� ����
    gvExtMsg := '';
    CloseFile(SrcFile);
    CloseFile(DesFile);
    Exit;
  end;

  iStrIdx := -1;
  RptDataList := TStringList.Create;

   // PS ó��
  if pPSStrList.Count > 0 then
  begin
    for I := 0 to pPSStrList.Count - 1 do
    begin
      RptDataList.Add(pPSStrList.Strings[I]);
      Inc(iStrIdx);
    end; // end of for
    RptDataList.Add(gcSPLIT_CHAR + gcPS_MARK + gcSPLIT_CHAR + gcPS_MARK + gcSPLIT_CHAR); // PS ǥ��
    Inc(iStrIdx);
  end; // end of if

//if gvRealLogYN = 'Y' then gf_Log('����SendFaxTlx gf_ConvertPageText 1 End');

   // ���� Line ���� �� RptDataList�� ����
  while not Eof(SrcFile) do
  begin
    Readln(SrcFile, sReadBuff);
    sReadBuff := StringReplace(sReadBuff, #12, '', [rfReplaceAll]);
    if copy(sReadBuff, 1, 1) <> gcSPLIT_CHAR then
    begin
      RptDataList.Add(sReadBuff);
      Inc(iStrIdx);
    end
    else //  ������ ���� Line�� �ִ��� Ȯ�� �� ����
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
  iStrIdx := RptDataList.Count - 1; // ������ Index
  while Trim(RptDataList.Strings[iStrIdx]) = '' do
  begin
    RptDataList.Delete(iStrIdx);
    dec(iStrIdx);
  end;

//if gvRealLogYN = 'Y' then gf_Log('����SendFaxTlx gf_ConvertPageText 2 End');

  iLineCnt := 0; // Line��
  pTotPageCnt := 0; // Page��
  pLogoPageNo := ''; // Logo�� Print�� Page No
  pTxtUnitInfo := ''; // Text File ������ ������ �� Page No
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

//if gvRealLogYN = 'Y' then gf_Log('����SendFaxTlx gf_ConvertPageText 3 End');

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
// PDF���ϸ� : ExportDir + YYYYMMDD_���¹�ȣ(ID)_FaxNumber_���ĸ�_ȸ��
// pFreqNo Param �߰�
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

      // Form Create ����
    with DlgForm_PSInputBox do
    begin
         //-----------------------------------------------P.S ����
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
         //-----------------------------------------------P.S �Է�
      begin
            // MaxColCnt, MaxRowCnt Setting
        if pRptType = gcRTYPE_CRPT then
        begin
          iMaxColCnt := gcCRPTPS_MAX_COL_PORT; // Default ����  65
          if pDirection = gcLandscape then // ���� 85
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
          DRMemo_PS.MaxLength := 0; // �Է� ���� ����

          TradeDate := pTradeDate;
          AccNm := pAccNm;
          SubAccNo := pSubAccNo;
          MediaNo := pMediaNo;
          ReportID := pRptId;
          Grptype := pGrpType;
        end;
        MaxColCnt := iMaxColCnt;
        MaxRowCnt := iMaxRowCnt;

            // Form�� Width Setting
        ClientWidth := DRMemo_LineNo.Width +
          (MaxColCnt * CHAR_WIDTH) + MEMO_MARGIN;

            // �Է� ���� ����
        DRMemo_PS.ImeMode := imSHanguel; // Default => �ѱ�
        if (pDeptCode = gcDEPT_CODE_INT) or // ������
          (pRptType = gcRTYPE_TEXT) then // Text ���
          DRMemo_PS.ImeMode := imSAlpha; // Default => ����

            // Memo�� �ش� P.S �Է�
        if not Assigned(PSDefaultList) then
          PSDefaultList := TStringList.Create;
        DRMemo_PS.Lines.Clear;
        for I := 0 to PSDefaultList.Count - 1 do
          DRMemo_PS.Lines.Add(PSDefaultList.Strings[I]);

            // Memo�� �ش� Left P.S �Է�
        if not Assigned(PSLeftList) then
          PSLeftList := TStringList.Create;
        DRMemo_LeftPS.Lines.Clear;
        for I := 0 to PSLeftList.Count - 1 do
          DRMemo_LeftPS.Lines.Add(PSLeftList.Strings[I]);

            // Memo�� �ش� Right P.S �Է�
        if not Assigned(PSRightList) then
          PSRightList := TStringList.Create;
        DRMemo_RightPS.Lines.Clear;
        for I := 0 to PSRightList.Count - 1 do
          DRMemo_RightPS.Lines.Add(PSRightList.Strings[I]);

        RtnValue := ShowModal;
        if RtnValue = idOK then // Ȯ�� ��ư Ŭ���� ��쿡�� ó��
        begin
          PSDefaultList.Clear;
          PSLeftList.Clear;
          PSRightList.Clear;

               // DefaultPS Data�� �����ϴ��� �Ǵ�
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

          if PSExistFlag then // PS ����
          begin
            for I := 0 to DRMemo_PS.Lines.Count - 1 do
            begin
              if I > iMaxRowCnt - 1 then Break;
              PSDefaultList.Add(Trim(DRMemo_PS.Lines.Strings[I]));
            end; // end of for
          end; // end of if

               // LeftPS Data�� �����ϴ��� �Ǵ�
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

          if PSExistFlag then // PS ����
          begin
            for I := 0 to DRMemo_LeftPS.Lines.Count - 1 do
            begin
              if I > iMaxRowCnt - 1 then Break;
              PSLeftList.Add(Trim(DRMemo_LeftPS.Lines.Strings[I]));
            end; // end of for
          end; // end of if

               // RightPS Data�� �����ϴ��� �Ǵ�
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

          if PSExistFlag then // PS ����
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
           // A4����              ����:210 mm       ����:297 mm
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
// NotePad �����Ű�� �Լ�
//------------------------------------------------------------------------------

procedure gf_ExecNotePad(pParentHandle: THandle; pFileName: string);
begin
  ShellExecute(pParentHandle, 'open', 'notepad', pChar(pFileName), '', SW_SHOWNORMAL);
end;

//------------------------------------------------------------------------------
// Ini File���� �ش� Form�� ������ �о���� �Լ�
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
// Ini File�� �ش� Form ���� ����ϴ� �Լ�
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
// Ini File���� �ش� Form�� ������ �о���� �Լ�(Integer Type)
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
// Ini File�� �ش� Form ���� ����ϴ� �Լ�(Integer Type)
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
// Directory ���� ���� ����
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
// TrCode�� �ش��ϴ� ����ڵ�� Image Index Return
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
// TrCode�� �ش��ϴ� �޴��̸� Return
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
//  ����� ���� ToolBar �籸��
//------------------------------------------------------------------------------

procedure gf_ResetUserToolBar;
begin
  SendMessage(gvMainFrameHandle, WM_USER_RESET_TOOLBAR, 0, 0);
end;

//------------------------------------------------------------------------------
// Show ICON Dialog (Result = ���� Image Index)
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
// ����� �μ��ڵ忡 �����Ǵ� SettleNet �μ��ڵ� Return
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
        gvErrorNo := 9001; // Database ����
        gvExtMsg := E.Message;
        Exit;
      end;
    end;

    if RecordCount <> 1 then
    begin
      gvErrorNo := 2020; //�μ��ڵ� ����
      gvExtMsg := 'RecordCount <> 1';
      Exit;
    end;
    pGlobalDeptCode := Trim(FieldByName('DEPT_CODE').asstring);
    Result := True;
  end; // end of with
end;

//------------------------------------------------------------------------------
//  Numeric Data ���� �Ǵ�
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
// �ش� �μ��� ����ó ���� ȭ�� ����
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
// �ش� �μ��� �׷� ���� ȭ�� ����
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
// �̸��� ÷��ȭ�� ���� (c:\SettleNet\Client\tmp\�� ����
//                            1.Query�� ȭ���̸� ��������  (CallFlag = False)
//                            2.Email Send��               (CallFlag = True)
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
  gf_Log('�ۼ��� ���� - MAIL_ID : ' + SndItem.MailFormId
    + ' MailGroup : ' + SndITem.AccGrpName + ' Start');

  try
    sPathNAme := '';
    sFileName := '';
    sDirName := '';
    iCnt := 1;
    Result := '';
   // Tmp Dir �����
    if not DirectoryExists(gvDirTemp) then if not CreateDir(gvDirTemp) then Exit;
   // ����� ���丮 ����
    if SndItem.AccGrpType = gcRGroup_GRP then
      sDirName := gvDirUserData + SndItem.AccGrpName + '\' // ����� ���丮
    else
      sDirName := gvDirUserData + SndItem.AccList.Strings[0] + '\';

   // ���� �̸��� Return
    if gf_CreateEMailFile(SndItem.MailFormId, gvDirTemp, gvDeptCode, JobDate,
      SndITem.AccGrpName, SndITem.AccList, sFileName, False) then
    begin
      sPathName := sFileName //��θ� �����ؼ�
    end else
    begin
      Result := '';
      Exit;
    end;

    SearchRec := false;
    while True do
    begin //UserData�� �ִ��� �Ǵ�
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
    if IOResult <> 0 then // Error �߻�
    begin
      Result := '';
      exit;
    end;
   //UserData�� ������.
    if not SearchRec then
    begin
      if CallFlag then // Email Send��
      begin
         // MailFile ����
        if gf_CreateEMailFile(SndItem.MailFormID, gvDirTemp, gvDeptCode, JobDate,
          SndITem.AccGrpName, SndItem.AccList, sFileName, True) then
        begin
          Result := sFileName
        end else
        begin
          Result := '';
          Exit;
        end;
      end else //Query��
        Result := sPathName;
    end; // end of else

  finally
    if (GetTickCount - StartTime) >= 3000 then // 3�� �̻�
    begin
      gf_Log('=============================== '
        + FloatToStr((GetTickCount - StartTime) * 0.001) + '�� ==');

    end;
    gf_Log('�ۼ��� ���� - MAIL_ID : ' + SndItem.MailFormId + ' MailGroup : ' + SndITem.AccGrpName + ' End');
  end;


end;

//------------------------------------------------------------------------------
// ���Ϻ��� (UserData Dir Ȯ�� �� ������ UserData Dir�� ����)
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
   // ����� ���丮
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
   // User Data �� �ִ��� Ȯ��
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
  if IOResult <> 0 then // Error �߻�
  begin
    Result := '';
    exit;
  end;


  if not SearchRec then
  begin // ������ ����
      // MailFile ����  gvDirUserData\sDirName\FielName
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
// �̸��� ���ȭ��
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
// �̸��� ����ó ��� ȭ�� ����
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
// �� SEndSEq�� ����ó���� �����´�
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
// ����ó Component���� ����ó ������ Display �ϱ� ���� Format
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
//  ���� ���� pYearMonth : YYYYMM Return : YYYYMM
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
// ȭ����ѿ��� Ȯ�� True:�������� False:���Ѿ���
//------------------------------------------------------------------------------

function gf_CanUseTrCode(pTrCode: Integer): boolean;
var
  iSearchIdx: Integer;
begin
  if gvUseTrCodeList.Count > 0 then // ����� ���� ���
  begin
    iSearchIdx := gvUseTrCodeList.IndexOf(IntToStr(pTrCode));

    Result := False; // ���Ѿ���
    if iSearchIdx >= 0 then
      Result := True; // ��������
  end
  else // ����� ���� ��� ����
    Result := True; // ��������
end;

//------------------------------------------------------------------------------
// Enable Button
//------------------------------------------------------------------------------

procedure gf_EnableBtn(pTrCode: Integer; pButton: TControl);
var
  iAuthority: Integer;
begin
  iAuthority := gcAUTH_QUERY_ONLY; // ��ȸ�� ����
  if gf_CanUseTrCode(pTrCode) then
    iAuthority := gcAUTH_ALL; // ������

  pButton.Enabled := False;
  if pButton.Tag <= iAuthority then
    pButton.Enabled := True;
end;

//------------------------------------------------------------------------------
// ���� ó�� ���� Report�� ������ Return;
//------------------------------------------------------------------------------

function gf_GetReportDecTail(pTrCode: Integer; pStlDate: string): string;
var
  sTailStr: string;
begin
  if not gvUseDecLine then // ������� ��� ����
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
// ���� TR�� ���� �Ϸ� Ȯ�� : ����Ϸ� -> True, ����̿Ϸ� -> False
//------------------------------------------------------------------------------

function gf_CheckPreTRProcess(pTrCode: Integer; pStlDate: string;
  var pMsg: string): boolean;
var
  bConfirmed: boolean;
  sQueryStr: string;
begin
  pMsg := ''; // Clear;
  if not gvUseDecLine then // ������� ��� ����
  begin
    Result := True;
    Exit;
  end;

  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
{$IFDEF SETTLENET_A} // ȸ��
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
      + '    and l.DEC_LEVEL < 8           ' //9.viewer��� ���ܻ�������.
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
      + '    and l.DEC_LEVEL < 8           ' //9.viewer��� ���ܻ�������.
      + ' order by r.REF_TR_CODE, t.DEC_LEVEL ';
{$ENDIF}
    SQL.Add(sQueryStr);
    gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

    bConfirmed := True;
    while not Eof do
    begin
      if Trim(FieldByName('OPR_ID').asString) = '' then // �̰��� ���� ����
      begin
        bConfirmed := False;
        pMsg := pMsg +
          '[' + Trim(FieldByName('REF_TR_CODE').asString) + '] ' +
          Trim(FieldByName('MENU_NAME_KOR').asString) + ': ' +
          Trim(FieldByName('DEC_NAME').asString) + Chr(13);
      end;
      Next;
    end; // end of while

    if not bConfirmed then // �̰��� ���� �����
      pMsg := pMsg + Chr(13) +
        '���� ���簡 ó������ �ʾ����Ƿ� �ش� �۾��� ������ �� �����ϴ�.';
    Result := bConfirmed;
  end; // end of with
end;

//------------------------------------------------------------------------------
//���� TR�� ���� ���� ���� Ȯ�� : ���������� -> True, ��������� -> False
//------------------------------------------------------------------------------

function gf_CheckAfterTRProcess(pTrCode: Integer; pStlDate: string;
  var pMsg: string; iDecLevel: integer): boolean;
var
  sQueryStr: string;
begin
  pMsg := ''; // Clear;
  if not gvUseDecLine then // ������� ��� ����
  begin
    Result := False;
    Exit;
  end;

  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
{$IFDEF SETTLENET_A} // ȸ��
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
      + '    and l.DEC_LEVEL < 8           ' //9.viewer��� ���ܻ�������.
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
      + '    and l.DEC_LEVEL < 8           ' //9.viewer��� ���ܻ�������.
      + ' order by r.REF_TR_CODE, t.DEC_LEVEL ';
{$ENDIF}
    SQL.Add(sQueryStr);
    gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

    if RecordCount = 0 then // ���� TR�� ó���� ���� ���� ����
      Result := False
    else // ���� TR�� ó���� ���� ���� ����
    begin
      Result := True;
      pMsg := '������ �� �����ϴ�.' + Char(13) + Char(13);
      while not Eof do
      begin
        pMsg := pMsg +
          '[' + Trim(FieldByName('REF_TR_CODE').asString) + '] ' +
          Trim(FieldByName('MENU_NAME_KOR').asString) + ': ' +
          Trim(FieldByName('DEC_NAME').asString) + Chr(13);
        Next;
      end;
      pMsg := pMsg + Chr(13) +
                 //'ó���� ���� ������ ��ҵ˴ϴ�. �����Ͻðڽ��ϱ�? ';
      '���� ���� ������ ����ϼž� �մϴ�.';
    end;
  end; // end of with
end;


//------------------------------------------------------------------------------
//������� ����ϳ�?
//------------------------------------------------------------------------------

function gf_CanCancelDecLine(pTrCode: Integer; pStlDate: string; pDecLevel: integer;
  var pMsg: string): boolean;
var
  sQueryStr: string;
begin
  pMsg := ''; // Clear;
  if not gvUseDecLine then // ������� ��� ����
  begin
    Result := False;
    Exit;
  end;

  with DataModule_SettleNet.ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
{$IFDEF SETTLENET_A} // ȸ��
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
      + '    and l.DEC_LEVEL < 8           ' //9.viewer��� ���ܻ�������.
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
      + '    and l.DEC_LEVEL < 8           ' //9.viewer��� ���ܻ�������.
      + ' order by r.REF_TR_CODE, t.DEC_LEVEL ';
{$ENDIF}
    SQL.Add(sQueryStr);
    gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

    if RecordCount = 0 then // ���� TR�� ó���� ���� ���� ����
      Result := False
    else // ���� TR�� ó���� ���� ���� ����
    begin
      Result := True;
      pMsg := '����� �� �����ϴ�.' + Char(13) + Char(13);
      while not Eof do
      begin
        pMsg := pMsg +
          '[' + Trim(FieldByName('REF_TR_CODE').asString) + '] ' +
          Trim(FieldByName('MENU_NAME_KOR').asString) + ': ' +
          Trim(FieldByName('DEC_NAME').asString) + Chr(13);
        Next;
      end;
      pMsg := pMsg + Chr(13) +
                 //'ó���� ���� ������ ��ҵ˴ϴ�. �����Ͻðڽ��ϱ�? ';
      '���� ���� ������ ���� ����ϼž� �մϴ�.';
    end;
  end; // end of with
end;

//------------------------------------------------------------------------------
// ���� TR�� ���� ���� Clear : Clear ���� -> True, Clear ���� -> False
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
// SUSYOPT_TBL���� �ý��� �ɼ� �о����
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


//���� ȯ�溯�� ��������

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

//�⺻Printer�� PDF Printer��
//���� gvPrinter�� ����� gvPriner�� PDF Printer��!

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

  gf_ShowErrDlgMessage(0, 0, 'PDF Converter�� Printer�� ��ġ�Ǿ� ���� �ʽ��ϴ�.', 0);
end;

//PDF Printer���� �⺻Printer��

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
//  gfEncryption : ��ȣȭ
//----------------------------------------------------------------------------
//function gfEncryption(char* i_password, char* o_password): Integer;

function gfEncryption(i_password, i_HashEncYN: string; var o_Shortpassword: string): string;
const
  k: array[0..15] of Integer = (10, 2, 4, 11, 12, 3, 14, 13, 9, 1, 15, 6, 16, 7, 5, 8);
  PASSWD_SALT = '$eTT1eNeT'; // ��ȣȭ�� ���� ����
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
//  gfDecryption : ��ȣȭ
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
// ���� �˻�
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
      + ' where CLOSE_DATE = ''' + sTradeDate + ''' ' //����  > �߰��� ��
      + ' and   DEPT_CODE  = ''' + gvDeptCode + ''' '
      + ' and   TRD_CLOSE_YN = ''Y'' '
      );

    try
      gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
    except
      on E: Exception do
      begin
        gf_ShowErrDlgMessage(0, 9001, 'ADOQuery_Main[Query]: ' + E.Message, 0); // Database ����
//            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Main[Query]'); //Database ����
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
      Caption := 'Ȯ��';
      ModalResult := mrOk;
      Default := True;
      SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
        ButtonHeight);
    end;
    with TDRButton.Create(Form) do
    begin
      Parent := Form;
      Caption := '���';
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

//version exe, dll upgrade�ϱ�
//Result > '' Pgm Restart ���� else ��� ����

function gf_VersionSync(pQuery: TADOQuery; pExtGB: string; pPanel: TDRPanel): string;
//-------------------------------------------------------------------------------------
// �������� ���� ���� FileAge üũ�� Age�� ���� ���ϸ� ����üũ -����üũ�� ������
// ���������� Ageüũ �� ���� üũ �߾��� �������� INI�� üũ��
// �̹������� DB ���Ͽ��� ���� üũ
// ���ϻ�����¥�� �̸� üũ�� �ϹǷ� �ӵ� ������ ��. ������ ����Ǵ���
// ���ϻ�����¥�� ���� �����̶�� ������ �����Ƿ� INIó�� �ʿ����
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
//Result = '' ����, else ERROR
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
          // ��Ȥ �ش� ������ ������̿��� ������ �Ҽ� ���ٴ� ������ �߻��Ѵ�.
          // �׷� ��� �ش� ������ ���纻�� ���� �ø��� ó���� �Ѵ�.
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

//Result = '' ����, else ERROR
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
            'Download :' + E.Message, 0); // Database ����
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

      if FileExists(sPath + sFileName) then RenameFile(sPath + sFileName, sOldVersionName); //file�� ���� ���� �ִ�.

      if RecordCount > 0 then
      begin
        try
          // �ش������� �ƹ� ������ ������� ������ ����
          if Trim(FieldByName('F_DATA').AsString) <> '' then
            TBlobField(FieldByName('F_DATA')).SaveToFile(sPath + sFileName);
        except
          on E: Exception do
          begin
            RenameFile(sOldVersionName, sPath + sFileName); //���󺹱�
            gf_ShowErrDlgMessage(0, 0, 'SaveToFile Error:' + E.Message, 0);
            Result := 'DownLoad Error!1';
            Exit;
          end;
        end;


      end
      else
      {begin //�߻�����
        gf_ShowErrDlgMessage(0, 9001,
          'Download : ����ڷ� ����', 0); // Database ����
        Result := 'DownLoad Error!2'; //Database ����
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

        if RecordCount <= 0 then //���� ���� ����.. ��
        begin
            // ���� ���� ����
            // �ڱ��ڽŵ� ������ ������Ʈ ����.
          Screen.Cursor := crDefault;
          Exit;
            { sMsg := UploadToDB(sFilePath, sSyncFileName, 'I', sVersion);

            if sMsg > '' then  //Upload ���д� �߿����� �ʰ� �߻��� ���� �Ŵ�. ��� ����
            begin
            //      Screen.Cursor := crDefault;
            //      Exit;
            end;}
        end else
        begin
            //iDBFAge      := FieldByName('F_AGE').AsInteger;
          sDBFVersion := trim(FieldByName('F_VERSION').asSTring);
          gf_log('Age üũ Start');
          iSyncAge := FileAge(sFilePath + sSyncFileName);
          gf_log('Age üũ End');

          //if iDBFAge <> iSyncAge then  // Age üũ�� Ʋ���� ���� üũ
          //begin
          sSyncVersion := gf_ExeVersion(Application.ExeName);
          if sSyncVersion < sDBFVersion then //download �ض�
          begin
            sMsg := DownloadFromDB(sFilePath, sSyncFileName);
            if FileExists(sFilePath + sSyncFileName) then
              if FileSetDate(sFilePath + sSyncFileName, iDBFAge) <> 0 then
                gf_Log('Application FileAge Change Error : ' + sSyncFileName)
              else
                gf_Log('Application FileAge Change End');
            if sMsg = '' then //down load ����
            begin
              // gf_ShowErrDlgMessage(0, 0, 'Client Version Upgrade�� �Ϸ�Ǿ����ϴ�.'
              //  + gcMsgLineInterval + '������ �������� �õ��Ͻʽÿ�.', 0);
              Result := 'Program Upgraded! ';
              Exit;
            end;
          end
          else if sSyncVersion > sDBFVersion then //Upload �ض�
          begin
            sMsg := UploadToDB(sFilePath, sSyncFileName, 'U', sSyncVersion, iSyncAge);
            if sMsg > '' then //Upload ���д� �߿����� �ʰ� �߻��� ���� �Ŵ�. ��� ����
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
                     if sMsg = '' then //down load ����
                     begin
                        gf_ShowErrDlgMessage(0, 0, 'Client Version Upgrade�� �Ϸ�Ǿ����ϴ�.'
                             + gcMsgLineInterval + '������ �������� �õ��Ͻʽÿ�.',0);
                        Result:= 'Program Upgraded! ';
                        Exit;
                     end;
                  end; }
          end;
            //end;
        end; // if RecordCount <= 0 then
      end; //with
      pPanel.Caption := sOriMsg; //�ʱ�ȭ
    end else //2. // IF NOT EXE  ��� ������Ʈ ���  Download �Ǵ� Insert
    begin
      StFiles := TList.Create;
      if not Assigned(StFiles) then
      begin
        gf_ShowErrDlgMessage(0, 9004, '', 0); // List ���� ����  List ���������� �߿����� �ʴ�. exe ��� �޷�.
        Exit; //List ���������� �߿����� �ʴ�. exe ��� �޷�.
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
                //  ���� �ڱ��ڽ� EXE�� ����! ����
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

            // NEW �ű� Upload ��� �ش� �ǽÿ� ������ ������ ����.
          if sDBFName = 'NEW' then
          begin
               //gf_Log('UPDATE 1');
               // ������ �������� �Ѿ �ٸ������� �Է����̰ų� ������Ʈ ���� ����
            if not FileExists(sFilePath + sMailFormID) then
            begin
              Next;
              Continue;
            end;
               // ������ ���ε� DB
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
            FilesItem.Action := 'I'; // �߰� ���
            FilesItem.FileAge := FileAge(sFilePath + FilesItem.FileName);
               //gf_Log('UPDATE 1 END');
          end else
            // �� �ܴ� ���� üũ ����
          begin
            New(FilesItem);
            StFiles.Add(FilesItem);
               //gf_Log('UPDATE 2');
            FilesItem.FileName := sDBFName;
            FilesItem.Version := '';

               // ������ ������� �ٿ� �޾ƾߵ�
            if not FileExists(sFilePath + sDBFName) then
            begin
              FilesItem.FileAge := iDBFAge;
              FilesItem.Action := 'D'; // �ٿ� �޴� ���
            end else
            begin // ������ �ִ°�� ���� üũ
                  //gf_Log('UPDATE 2 - FileAge Chack');
              iSyncAge := FileAge(sFilePath + sDBFName);
                  //gf_Log('UPDATE 2 - FileAge Chack End');
                  // F_AGE�� ���� ���� ������ AGEüũ
                  //gf_Log('iDBFAge(' + inttostr(iDBFAge) +  ') <> iSyncAge(' + IntToStr(iSyncAge) +')' );
              if iDBFAge <> iSyncAge then // ���� ������� ���� üũ
              begin
                     //gf_Log('UPDATE 2 (iDBFAge <>  iSyncAge)- Version Chack');
                try
                  sSyncVersion := gf_ExeVersion(sFilePath + sDBFName); ; // Age�� �����Ƿ� ����üũ ���� '' ����
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
                  (sSyncVersion = '') then //���ų� ������ ���� Age�� ����ȭ
                begin
                  if iDBFAge < iSyncAge then
                  begin
                    FilesItem.Action := 'U';
                    FilesItem.Version := sSyncVersion; // ���� ���� ����
                    FilesItem.FileAge := iSyncAge; // ���� ���� Age
                  end
                  else if iDBFAge > iSyncAge then
                  begin
                    FilesItem.Action := 'D';
                    FilesItem.Version := sDBFVersion; // DB�� �ִ� ����
                    FilesItem.FileAge := iDBFAge; // DB ���� Age
                  end;
                end else
                  if sDBFVersion >
                    sSyncVersion then //�ٿ�޾�
                  begin
                    FilesItem.Action := 'D';
                    FilesItem.Version := sDBFVersion; // DB�� �ִ� ����
                    FilesItem.FileAge := iDBFAge; // DB ���� Age
                  end
                  else if sDBFVersion < sSyncVersion then //�÷� �޾�
                  begin
                    FilesItem.Action := 'U';
                    FilesItem.Version := sSyncVersion; // ���� ���� ����
                    FilesItem.FileAge := iSyncAge; // ���� ���� Age
                  end;

              end else // F_AGE ���� ������� NO UPDATE
              begin
                FilesItem.Action := 'N';
              end;
                  //gf_Log('UPDATE 2 END');
            end;
          end;
          Next;
        end;

      end; // end with pQuery do

      // [L.J.S] 2016.10.25 DLL�� ���� ȭ�� ó�� ���� SCPRVER_TBL ���̺��� ���
      // ��� �Ǿ� ������ �Ű� �� ����.
      // * SCMELID_TBL�� ��ϵ� �������� �Ҵ�� dll ȭ�� �ִ��� Ȯ��
      sDllFormName := '';
      for i := 0 to StFiles.Count-1 do
      begin
        FilesItem := stFiles.Items[i];

        sMailFormID := FilesItem.FileName;

        bAddDllForm := False;

        // * DLL ȭ�� �̸� ���� (MAILFORM_ID_FORM_.dll)
        sDllFormName := Copy(sMailFormID, 1, 7) + '_FORM.DLL';

        // * DLL ȭ�� ������ PC�� ���� �ϸ�
        if FileExists(sFilePath + sDllFormName) then
        begin
          bAddDllForm := True;

          // * ���� ����Ʈ�� �ش� DLL ȭ���� �����ϴ��� Ȯ��
          for j := 0 to StFiles.Count-1 do
          begin
            tempFilesItem := StFiles.Items[j];
            // * �����ϸ� �ش� MAILFORM_ID �۾��� ������. : bAddDllForm := False;
            // * �������� ������ ���ϸ���Ʈ �߰��� ���.  : bAddDllForm := True;
            if sDllFormName = tempFilesItem.FileName then
            begin
              bAddDllForm := False;
              break;
            end;
          end;

          // * Dll ȭ�� ���� ����Ʈ�� �߰�
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
         // ������ �ٿ������ Age�� ����ȴ�  DB�� Age�� Age����!!!
          if FileExists(sFilePath + FilesItem.FileName) then
            if FileSetDate(sFilePath + FilesItem.FileName, FilesItem.FileAge) <> 0 then
            begin
              if not MsgOpen then
              begin
                MsgOpen := True;
                gf_ShowErrDlgMessage(0, 0, 'FileUpdate ���� - ���� ���⿡ ���� �߽��ϴ�. '
                  + #13#10 + #13#10 + 'Dataroad�� �����ϼ���.', 0);
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

      pPanel.Caption := sOriMsg; //�ʱ�ȭ

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

  if Length(sTelNo) <= 8 then //�ó���ȭ
  begin
    sTelNo := LeftStr(sTelNo, Length(sTelNo) - 4) + '-' + RightStr(sTelNo, 4);
  end
  else if (sTelNo[1] = '0') and (sTelNo[2] >= '2') then //02 �̻� ������ȣ �� ���
  begin
    if LeftStr(sTelNo, 2) = '02' then //02
      sTelNo := LeftStr(sTelNo, 2) + '-' + Copy(sTelNo, 3, Length(sTelNo) - 6) + '-' + RightStr(sTelNo, 4)
    else //��Ÿ ������ȣ
      sTelNo := LeftStr(sTelNo, 3) + '-' + Copy(sTelNo, 4, Length(sTelNo) - 7) + '-' + RightStr(sTelNo, 4)
  end
  else //if (sTelNo[1] > '0') and (sTelNo[1] <= '9') then //������ȣ
  begin
    //������ȣ�� ������ �ʹ� ���� ���˾���. ������ȣ�� ���ڸ����� 3�ڸ�������.
  end;
  Result := sTelNo;
end;

//------------------------------------------------------------------------------
//  OASYS SOTRADE ��ȣ ä�� SEND_SEQ_NO
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
      Parameters.ParamByName('@in_biz_type').Value := '01'; //01: �Ѽ۽Ź�ȣ�ε� �ǹ̾���.
      Parameters.ParamByName('@in_get_flag').Value := '2'; //ä��
      Execute;
    except
      on E: Exception do
      begin // StoredProcedure ���� �����Դϴ�.
        gvErrorNo := 9002; // StoredProcedure ���� �����Դϴ�.
        gvExtMsg := 'SP0103: ' + E.Message;
        Exit;
      end;
    end;
    RtnValue := Parameters.ParamByName('@out_rtc').Value;
    if (Trim(RtnValue) <> '') and (RtnValue <> '0000') then //���� �߻�
    begin
      gvErrorNo := 9002; // StoredProcedure ���� �����Դϴ�.
      gvExtMsg := 'SP0103: ' + Parameters.ParamByName('@out_kor_msg').Value;
      Exit;
    end;
    Result := Parameters.ParamByName('@out_snd_no').Value;
  end;
end;

//------------------------------------------------------------------------------
//  ���������� (�ֽ�Off, �ڽ���Off, ��Ÿall)
//------------------------------------------------------------------------------
{
function gf_GetCommRateLst(pADOQuery : TADOQuery; pAccNo : String; var sEqtyOff, sKosqOff : String; var sAll : TList): Integer;
var
   iRow : Integer;
   sEqtyCD, sKosqCD, sAllCD : String;
   pAll : PTCommRate;
begin
   Result := -1;

   sEqtyCD := '021';   //�ֽ�Offline
   sKosqCD := '200';   //�ڽ���Offline
   sAllCD  := '000';   //��ü

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
//  ���������� (�ֽ�Off, �ڽ���Off, ��Ÿall)
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

   sEqtyCD := '021';   //�ֽ�Offline
   sKosqCD := '200';   //�ڽ���Offline
   sAllCD  := '000';   //��ü

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
    Result := '��������'
  else
    if sHisType = '2' then
      Result := '�ܰ�����������'
    else
      if sHisType = '3' then
        Result := '��ǥ���º���'
      else
        if sHisType = '4' then
          Result := '����������'
        else
          if sHisType = '5' then
            Result := '�Ÿ�����'
          else
            if sHisType = '6' then
              Result := 'Import'
            else
              if sHisType = '7' then
                Result := '�ֹ���ȣ���Ÿ�����'
              else
                if sHisType = '8' then
                  Result := '�����Ẹ��'
                else
                  if sHisType = '9' then
                    Result := '���ݺ���'
                  else
                    Result := '';
end;

function gf_GetHisTypeShortName(sHisType: string): string;
begin
  if sHisType = '1' then
    Result := '��������2'
  else
    if sHisType = '2' then
      Result := '��������'
    else
      if sHisType = '3' then
        Result := '��ǥ����'
      else
        if sHisType = '4' then
          Result := '����������'
        else
          if sHisType = '5' then
            Result := '�Ÿ�����'
          else
            if sHisType = '6' then
              Result := 'Import'
            else
              if sHisType = '7' then
                Result := '�Ÿ�����#'
              else
                if sHisType = '8' then
                  Result := '�����Ẹ��'
                else
                  if sHisType = '9' then
                    Result := '���ݺ���'
                  else
                    Result := '';
end;

function gf_GetHisDelTypeName(sHisType: string): string;
begin
  if sHisType = '1' then
    Result := 'Import'
  else
    if sHisType = '2' then
      Result := '�����������'
    else
      if sHisType = '3' then
        Result := '��ǥ���º������'
      else
        Result := '';
end;

function gf_GetHisDelTypeShortName(sHisType: string): string;
begin
  if sHisType = '1' then
    Result := 'Import'
  else
    if sHisType = '2' then
      Result := '�������'
    else
      if sHisType = '3' then
        Result := '�������'
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
        gf_ShowErrDlgMessage(0, 0, //Database ����
          '����ü��Update����: ' + E.Message, 0);
        Exit;
      end;
    end;

    sDlgMsg := '';
    if Trim(Parameters.ParamByName('@out_rtc').Value) <> '' then
      sDlgMsg := '����ü��Update����: ' +
        Trim(Parameters.ParamByName('@out_kor_msg').Value);

    if Parameters.ParamByName('@RETURN_VALUE').Value <> 1 then
      sDlgMsg := sDlgMsg + #13#10 + '����ü�� Return Value is not 1';

    if (Trim(Parameters.ParamByName('@out_rtc').Value) <> '') or
      (Parameters.ParamByName('@RETURN_VALUE').Value <> 1) then
    begin
      gf_ShowErrDlgMessage(0, 0, sDlgMsg, 0);
      Exit;
    end;
  end;
  Result := True;
end;

//�ҹ��ڸ� �빮�ڷ�

function gf_ToUpper(var Key: char): char;
var
  i: integer;
begin
  i := integer(Key);
  if ((i >= 97) and (i <= 122)) then //�ҹ���
  begin
    i := i - 32;
    Key := Char(i); //�빮��
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

// ���� �����ӽ������������ ���� using CICS 1-1

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
    ShowMessage('Dll Load ����');
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
//gf_log( '�������� ������ ��Ƽ���� ' + sNotifyNeed);
  sOut := caOut;
  Result := true;
end;

//�����ӽ������������ ���� using CICS 1.

function gf_HostCallsnchangeFee(sDate, sAccNo: string; dComRate: double; var sNotifyNeed: string; var sOut: string): boolean;
begin
  result := False;

  if gvHostGWUseYN = 'N' then //����
  begin
    if not gf_HostCICSsnchangeFee(sDate, sAccNo, dComRate, sNotifyNeed, sOut) then exit;
  end;

  result := True;
end;


//������ ��� Only Using CICS

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
    // ���� Output
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
    ShowMessage('Dll Load ����');
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

        gf_log('������Ȯ��:' + sComm);
        gf_log('��������Ȯ��:' + sHCommRate);

        dComm := StrToFloat(sComm);
        dTrdTax := StrToFloat(sTrdTax);
        dAgcTax := StrToFloat(sAgcTax);
        dCpgTax := StrToFloat(sCpgTax);
        dNetAmt := StrToFloat(sNetAmt);
        dHCommRate := StrToFloat(copy(sHCommRate, 1, 1) + '.' + copy(sHCommRate, 2, 8));

        gf_log('������Ȯ��2:' + ForMatFloat('#,##0', dComm));
        gf_log('��������Ȯ��2:' + ForMatFloat('#,##0.000000', dHCommRate));

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

//OMS �Ÿ� Import Using CICS

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
    ShowMessage('Dll Load ����');
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
      caaAccNo[i][0] := ' '; //������ 5������ Spaceó���ϱ�� ��.
    end;
  end
  else
  begin
//    ShowMessage('�ش� �׷��� ���°� �������� �ʽ��ϴ�.');
//    Exit;
    caaAccNo[0][0] := ' '; //������ 5������ Spaceó���ϱ�� ��.
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

//�Ÿ� Import Using CICS

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
    ShowMessage('Dll Load ����');
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
      caaAccNo[i][0] := ' '; //������ 5������ Spaceó���ϱ�� ��.
    end;
  end
  else
  begin
//    ShowMessage('�ش� �׷��� ���°� �������� �ʽ��ϴ�.');
//    Exit;
    caaAccNo[0][0] := ' '; //������ 5������ Spaceó���ϱ�� ��.
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

//���� Import Using CICS

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
    ShowMessage('Dll Load ����');
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
      caaAccNo[i][0] := ' '; //������ 5������ Spaceó���ϱ�� ��.
    end;
  end
  else
  begin
//    ShowMessage('�ش� �׷��� ���°� �������� �ʽ��ϴ�.');
//    Exit;
    caaAccNo[0][0] := ' '; //������ 5������ Spaceó���ϱ�� ��.
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

//�ֽĸŸ� Import Using HostGateWay (�ϳ�������)
function gf_HostGateWaysngetTRInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;
var
  ImpData: TCliSvrImpData;
  sAccNo, sImpType: string;
  iRc: Integer;
begin
  Result := false;

   // SocketThread ���������� üũ
  iRc := fnMdServerAlive;
  if iRc = -1 then
  begin
    sOut := 'gf_HostGateWaysngetFTRInfo >> not fnServerAlive ������ ���������� Ȯ���Ͻÿ�.';
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
      sOut := 'gf_HostGateWaysngetFTRInfo >> not fnImpDataSend HostGW�� ���������� Ȯ���Ͻʽÿ�.';
    exit;
  end;

  DisplaynLog('Monitor : ' + ImpData.csErrcode);
  DisplaynLog('Monitor : ' + ImpData.csErrmsg);
  DisplaynLog('Monitor : ' + ImpData.csCreYN);
  sOut := '[' + ImpData.csErrcode + ']' + ImpData.csErrmsg;

  Result := true;

end;

//�����Ÿ� Import Using HostGateWay (�ϳ�������)
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

  // ���� �������� ī��Ʈ
  gvMCIFileCnt := 0;

  DisplaynLog('gf_HostGateWaysngetFTRInfo start ');

   // SocketThread ���������� üũ
  iRc := fnMdServerAlive;
  if iRc = -1 then
  begin
    sOut := 'gf_HostGateWaysngetFTRInfo >> not fnServerAlive ������ ���������� Ȯ���Ͻÿ�.';
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
    // sImpType := gcSTYPE_IMP_FTR;    // ��� Tr : ����Ʈ���� ���ε� (������Ź�ڷ�)

    // SFT2018011917285-
    sAccFileName := sFileName + '-' + '001' ; // ���� ���ϸ� + ����


    gvMCIFtpFileList.Add(sAccFileName);
    Inc(gvMCIFileCnt);

    CharCharCpy(ImpData.csFileName, PChar(sAccFileName), Sizeof(ImpData.csFileName));

    DisplaynLog('gf_HostGateWaysngetFTRInfo >> gcSTYPE_IMP_FDP ��Ź ');
    DisplaynLog('gf_HostGateWaysngetFTRInfo >> sAccFileName : ' + sAccFileName);

    iRc := fnImpDataSend(gcSTYPE_IMP_FDP, ImpData); // ��� Tr : ����Ʈ���� ���ε� (������Ź�ڷ�)

    if iRc = -1 then
    begin
      result := False;
      if Length(ImpData.csErrmsg) > 0 then
        sOut := 'gf_HostGateWaysngetFTRInfo >> not fnImpDataSend [' + ImpData.csErrcode + ']' + ImpData.csErrmsg
      else
        sOut := 'gf_HostGateWaysngetFTRInfo >> not fnImpDataSend HostGW�� ���������� Ȯ���Ͻʽÿ�.';
      exit;
    end;

    DisplaynLog('Monitor : ' + ImpData.csErrcode);
    DisplaynLog('Monitor : ' + ImpData.csErrmsg);
    DisplaynLog('Monitor : ' + ImpData.csCreYN);
    sOut := '[' + ImpData.csErrcode + ']' + ImpData.csErrmsg;

  end;

  if  (iTradeTypeIdx <> 1) then
  begin
    //sImpType := gcSTYPE_IMP_FDP;    // ��� Tr : ����Ʈ���� ���ε� (�����Ÿ�,�̰���,����ڷ�)

    sAccFileName :=  sFileName + '-' + '002';   // ���� ���ϸ�   ����

    gvMCIFtpFileList.Add(sAccFileName);
    Inc(gvMCIFileCnt);

    CharCharCpy(ImpData.csFileName, PChar(sAccFileName), Sizeof(ImpData.csFileName));

    DisplaynLog('gf_HostGateWaysngetFTRInfo >> gcSTYPE_IMP_FTR �����Ÿ� ');
    DisplaynLog('gf_HostGateWaysngetFTRInfo >> sAccFileName : ' + sAccFileName);

    iRc := fnImpDataSend(gcSTYPE_IMP_FTR, ImpData);  // �����Ÿ�

    if iRc = -1 then
    begin
      result := False;
      if Length(ImpData.csErrmsg) > 0 then
        sOut := 'gf_HostGateWaysngetFTRInfo >> not fnImpDataSend [' + ImpData.csErrcode + ']' + ImpData.csErrmsg
      else
        sOut := 'gf_HostGateWaysngetFTRInfo >> not fnImpDataSend HostGW�� ���������� Ȯ���Ͻʽÿ�.';
      exit;
    end;

    DisplaynLog('Monitor : ' + ImpData.csErrcode);
    DisplaynLog('Monitor : ' + ImpData.csErrmsg);
    DisplaynLog('Monitor : ' + ImpData.csCreYN);
    sOut := '[' + ImpData.csErrcode + ']' + ImpData.csErrmsg;

    //------------------------------------------------------------------------------
    sAccFileName :=  sFileName + '-' + '003';   // ���� ���ϸ�   ����

    gvMCIFtpFileList.Add(sAccFileName);
    Inc(gvMCIFileCnt);

    CharCharCpy(ImpData.csFileName, PChar(sAccFileName), Sizeof(ImpData.csFileName));

    DisplaynLog('gf_HostGateWaysngetFTRInfo >> gcSTYPE_IMP_FOP �̰��� ');
    DisplaynLog('gf_HostGateWaysngetFTRInfo >> sAccFileName : ' + sAccFileName);

    iRc := fnImpDataSend(gcSTYPE_IMP_FOP, ImpData);  // �̰ᤸ��

    if iRc = -1 then
    begin
      result := False;
      if Length(ImpData.csErrmsg) > 0 then
        sOut := 'gf_HostGateWaysngetFTRInfo >> not fnImpDataSend [' + ImpData.csErrcode + ']' + ImpData.csErrmsg
      else
        sOut := 'gf_HostGateWaysngetFTRInfo >> not fnImpDataSend HostGW�� ���������� Ȯ���Ͻʽÿ�.';
      exit;
    end;

    DisplaynLog('Monitor : ' + ImpData.csErrcode);
    DisplaynLog('Monitor : ' + ImpData.csErrmsg);
    DisplaynLog('Monitor : ' + ImpData.csCreYN);
    sOut := '[' + ImpData.csErrcode + ']' + ImpData.csErrmsg;

    //------------------------------------------------------------------------------
    sAccFileName :=  sFileName + '-' + '004';   // ���� ���ϸ�   ����

    gvMCIFtpFileList.Add(sAccFileName);
    Inc(gvMCIFileCnt);

    CharCharCpy(ImpData.csFileName, PChar(sAccFileName), Sizeof(ImpData.csFileName));

    DisplaynLog('gf_HostGateWaysngetFTRInfo >> gcSTYPE_IMP_FCO ��� ');
    DisplaynLog('gf_HostGateWaysngetFTRInfo >> sAccFileName : ' + sAccFileName);

    iRc := fnImpDataSend(gcSTYPE_IMP_FCO, ImpData);          // ���

    if iRc = -1 then
    begin
      result := False;
      if Length(ImpData.csErrmsg) > 0 then
        sOut := 'gf_HostGateWaysngetFTRInfo >> not fnImpDataSend [' + ImpData.csErrcode + ']' + ImpData.csErrmsg
      else
        sOut := 'gf_HostGateWaysngetFTRInfo >> not fnImpDataSend HostGW�� ���������� Ȯ���Ͻʽÿ�.';
      exit;
    end;

    DisplaynLog('Monitor : ' + ImpData.csErrcode);
    DisplaynLog('Monitor : ' + ImpData.csErrmsg);
    DisplaynLog('Monitor : ' + ImpData.csCreYN);
    sOut := '[' + ImpData.csErrcode + ']' + ImpData.csErrmsg;         

  end;

  Result := true;

end;

//�ֽİ��� Import Using HostGateWay (�ϳ�������)
function gf_HostGateWaysngetACInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

var
  ImpData: TCliSvrImpData;
  sImpType: string;
  iRc: Integer;
begin
  Result := false;

   // SocketThread ���������� üũ
  iRc := fnMdServerAlive;
  if iRc = -1 then
  begin
    sOut := 'gf_HostGateWaysngetACInfo >> not fnServerAlive ������ ���������� Ȯ���Ͻÿ�.';
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
      sOut := 'gf_HostGateWaysngetFACInfo >> not fnImpDataSend HostGW�� ���������� Ȯ���Ͻʽÿ�.';
    exit;
  end;

  Result := true;

end;

//�������� Import Using HostGateWay (�ϳ�������)
function gf_HostGateWaysngetFACInfo(sDate, sAccList, sFileName: string;
  var sOut: string): boolean;

var
  ImpData: TCliSvrImpData;
  sImpType: string;
  iRc: Integer;
begin
  Result := false;

  gf_log('SCCLib bf SocketThread ���������� üũ ');

  gvMCIFtpFileList.Clear;
  
  // ���� �������� ī��Ʈ
  gvMCIFileCnt := 0;


  gf_log('gvMCIFileCnt : ' + IntToStr(gvMCIFileCnt));

   // SocketThread ���������� üũ
  iRc := fnMdServerAlive;
  if iRc = -1 then
  begin
    sOut := 'gf_HostGateWaysngetACInfo >> not fnServerAlive ������ ���������� Ȯ���Ͻÿ�.';
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


  sImpType := gcSTYPE_IMP_FAC;     // ���������ڷ�

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
      sOut := 'gf_HostGateWaysngetFACInfo >> not fnImpDataSend HostGW�� ���������� Ȯ���Ͻʽÿ�.';
    exit;
  end;


  Result := true;

end;


//Upload Call
//WorkCode : �������� 'D', ���� 'I', ����� 'R'

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
    ShowMessage('Dll Load ����');
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
//WorkCode : �������� 'D', ���� 'I'

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
    ShowMessage('Dll Load ����');
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

//Upload Call  (�ϳ�������)
//WorkCode : �������� 'D', ���� 'I', ����� 'R'

function gf_HostGateWaysnprocessUploadData(sDate, sFileName: string; var sOut: string): boolean;
var
  UpData: TCliSvrUpData;
  sImpType: string;
  iRc: Integer;
  sCmtType, sMrktDeal, sCommOrd, sPgmCall, sTradeType: string;
begin
  Result := false;

   // SocketThread ���������� üũ
  iRc := fnMdServerAlive;
  if iRc = -1 then
  begin
    sOut := 'gf_HostGateWaysnprocessUploadData >> not fnServerAlive ������ ���������� Ȯ���Ͻÿ�.';
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
      sOut := 'gf_HostGateWayCalculate >> not fnInfoUpDataSend HostGW�� ���������� Ȯ���Ͻʽÿ�.';
    exit;
  end;

  DisplaynLog('Monitor : ' + UpData.csErrcode);
  DisplaynLog('Monitor : ' + UpData.csErrmsg);
  DisplaynLog('Monitor : ' + UpData.csCreYN);
  sOut := '[' + UpData.csErrcode + ']' + UpData.csErrmsg;

  Result := true;
end;

//�������� Upload Call
//WorkCode : ���嵥���ͻ��� 'D', ���ϳ��� �����Է� 'I'

function gf_HostCICSsnprocessReqUploadData(sClient, sOrdd, sSettd, sWorkCode, sInputFile: string; var sOut: string): boolean;
type
  TsnprocessReqUploadData = function(
    psEmpId, psCustDept, psClient, psOrdd, psSettd, psWorkCode, psInputFile, pszOut: pchar
    ): integer; cdecl;
var
  snprocessReqUploadData: TsnprocessReqUploadData;
  DllHandle: THandle;

  caFileName: array[0..100] of char; //�������ϸ�
  caEmpId: array[0..10] of char; //
  caCustDept: array[0..3] of char; //�μ��ڵ�
  caClient: array[0..60] of char; //client��
  caOrdd: array[0..8] of char; //�Ÿ���
  caSettd: array[0..8] of char; //������
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
    ShowMessage('Dll Load ����');
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
  sHwAccTaxUse: string; //�������°� ��������� ����
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
      // ���������� ��������θ� �˾ƿ´�.
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
         //gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SELECT SETSPTM_TBL]: ' + E.Message, 0); //Database ����
         //gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SELECT SETSPTM_TBL]');  //Database ����
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
         //gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SELECT SETSPTM_TBL]: ' + E.Message, 0); //Database ����
         //gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SELECT SETSPTM_TBL]');  //Database ����
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
         //gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SELECT SETSPTM_TBL]: ' + E.Message, 0); //Database ����
         //gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SELECT SETSPTM_TBL]');  //Database ����
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
    dTotAvr := dTotAmt / dTotQty; //20070814 ����

//      showmessage(FloatToStr(dTotQty) + ' , ' + FloatToStr(dTotAmt) + ' , ' + FloatToStr(dTotAvr));
    gf_log('���� ACC_NO : ' + pHwAccNo);
    gf_log('���� dTotQty : ' + FormatFloat('#,##0', dTotQty));
    gf_log('���� dTotAmt : ' + FormatFloat('#,##0', dTotAmt));
    gf_log('���� dTotAvr : ' + FormatFloat('#,##0.000000000', dTotAvr));

//2010.09.29
//�ڱ��ڽſ��� ������ ���, ��,
//��ǥ�� �������°� �����ϰ�( Z���¿� Z���Ű���)
//������ ������ ���
//������,������ ����� ���� �ʴ´�.
//���� ��� ������ ����.




    if not gf_GetCommnTax2(pTradeDate, pBrkShtNo, pIssueCode, pTranCode, pTradeType, pHwAccNo, pStlDate, dTotAvr, dTotQty, dTotAmt,
      dGetComm, dGetTTax, dGetATax, dGetCTax, dGetNAmt, dGetCommRate, sOut, 'N'
      , sHwAccTaxUse) then
    begin
      sOutRtc := 'gf_CICSsncalculate Error ' + sOut;
      Exit;
    end;

    gf_log('���� dGetComm : ' + FormatFloat('#,##0', dGetComm));
    gf_log('���� dGetTTax : ' + FormatFloat('#,##0', dGetTTax));
    gf_log('���� dGetCTax : ' + FormatFloat('#,##0', dGetCTax));
    gf_log('���� dGetNAmt : ' + FormatFloat('#,##0', dGetNAmt));

    {
      if (dGetComm < dSumComm) or
         (dGetTTax < dSumTTax) or
         (dGetATax < dSumATax) or
         (dGetCTax < dSumCTax) then
      begin
         sOutRtc := 'gf_CICSsncalculate Error : ������������ �պ��� �������� Return Error';
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
         //gf_ShowErrDlgMessage(Self.Tag, 9001,'ADOQuery_Temp[UPDATE SETSPTM_TBL]: ' + E.Message, 0); //Database ����
         //gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[UPDATE SETSPTM_TBL]');  //Database ����
         //gf_RollbackTransaction;
        sOutRtc := 'ADOQuery_Temp[UPDATE SETSPTM_TBL]: ' + E.Message;
        Exit;
      end;
    end;
  end;

  result := True;
end;

// TRADE-> ORDTD SPEXE -> ORDEX COPY...  �ڻ��ֹ�# 0  �ֹ���# 1

function gf_CopyTradeToOrdTd(ADOQuery_Trade, ADOQuery_Ordexe: TADOQuery;
  TradeDate, DeptCode, AccNo, SubAccNo, IssueCode, TranCode, TradeType, BrkShtNo: string): boolean;
begin

   // SEORDEX_TBL DELETE // ������ ó�� �Ѵ�... QTY = 0
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
      + '   and TOT_EXEC_QTY > 0 ' //�Ѽ��� 0�� �ƴѳ༮ - 0�γ��� ���� �����ȳ���
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

// ������ TRADE-> ORDTD SPEXE -> ORDEX COPY...  �ڻ��ֹ�# 0  �ֹ���# 1

function gf_CopyTradeToOrdTdF(ADOQuery_Trade, ADOQuery_Ordexe: TADOQuery;
  TradeDate, DeptCode, AccNo, SubAccNo, IssueCode, TranCode, TradeType: string): boolean;
begin

   // SFORDEX_TBL DELETE // ������ ó�� �Ѵ�... QTY = 0
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
      + '   and TOT_EXEC_QTY > 0 ' //�Ѽ��� 0�� �ƴѳ༮ - 0�γ��� ���� �����ȳ���
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

//���� OLE ��������, ���� ��� �����Ŵ

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
    if bBackGround then //Back Groud�� ������
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
     if bBackGround then //Back Groud�� ������
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

//������, ������ ���� Ÿ�� (�ѱ�H, �ϳ����� D), Defalut H
//������ �����ϰ�
//������ �ƹ��͵� ���ϰ�.
//============================================================================
//  gf_GetSystemOptionValue('HXX','H') = 'D' then //�ϳ����� �������� =======
//======================================================================
// ������,�����ݰ��� �������� �����Ͽ� ����ϱ�.
// "������,������ ���� �ŷ��׷�" ���θ� �ľ���
// �����Ѵ�.
{
 *  * �����Ẹ���ŷ��׷� �̶�?
 *      ����-�Ϲݰ���
 *      ����-�Ϲݺ����
 *      ���α׷�-�Ϲݰ���
 *      ���α׷�-�Ϲݺ����
 *      BRK_SHT_NO�� ������ �� ������ ������ �ؾ� �Ѵ�.
 *      �� �ŷ��� ���� �߻��� ��� ���������� �ջ��Ͽ� ���Ǿ�� �Ѵ�.
 * ==> ���� �����̶� ���� �ٸ��ų� (OTC), ��ü�� �ٸ� ��� (HTS,���ͳ�,�Ϲ�) �����ŷ��׷��� �ƴϴ�.
 *
 *  * �����ݺ����ŷ��׷� �̶�?
 *      �����Ẹ���ŷ��׷�� �޸�
 *      - ��ü������ �����Ѵ�. ��, �屸�и� �Ѵ�.
 *      - �峻���ִ� ������ �ٸ��� �ʴ�. ��ܴ��ֳ� ��ܰŷ� ��� ������ 0.5%�� �����ϹǷ� ���ֿ��δ� �����ŷ��׷� ���д����� �ƴϴ�.

==> ������ ������ �����ϰ�, �����ݺ����� �Ѵ�.
==> ������, ������ ������ ������ ȣ���� ��(tran code + brk sht no)�� ������,������,�����ݾ��� �Ѱ��ش�
}

function gf_GetCommnTax2(pMyTradeDate, pMyBrkShtNo,
  pMyIssueCode, pMyTranCode, pMyTradeType, pMyAccNo, pMyStlDate: string;
  pMyAvrExecPrice, pMyTotExecQty, pMyTotExecAmt: double;
  var pMyComm: double; var pMyTTax: double;
  var pMyATax: double; var pMyCTax: double;
  var pMyNetAmt: double; var pMyCommRate: double; var pMsg: string; pSettleNetCommCalcYN: string;
  pHwAccTaxUse: string): boolean;
var
  //�ڱ��ڽ� ������ ��
  dSumQtyComm, dSumAmtComm: Double;
  dSumQtyTax, dSumAmtTax: Double;

  //�����Ẹ���� ���հ迡 ���� �������� cics output, Tax������ ������ ������ ����.
  dComm, dTTax, dATax, dCTax: Double;
  //CICS call ���� ����(�ǹ̾���) ����. �����Ẹ���� ���ݺ���, ���ݺ����� �����ắ���� �ǹ̾��� �����̴�. �߻����غ�~~~
  dCommGara, dTTaxGara, dATaxGara, dCTaxGara, dNetAmtGara, dMyCommRateGara: Double;

  //���հ�
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

  //0. Output �ʱ�ȭ
  if pSettleNetCommCalcYN <> 'Y' then pMyCommRate := 0; //�����Ḧ ��������Ҷ� pMycommRate�� ���� �޾ƿ��Ƿ� �ʱ�ȭ�ϸ� �ȵ���.

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

  //������, ������ ���� Ÿ�� (�ѱ�H, �ϳ����� D), Defalut H
  //������ �����ϰ�
  //������ �ƹ��͵� ���ϰ�.

  //============================================================================
  if gf_GetSystemOptionValue('HXX', 'H') = 'D' then //�ϳ����� �������� =======
  begin //======================================================================
    with DataModule_SettleNet.ADOQuery_Main do
    begin
      gf_log('CommTax2 DType ������, ������ ��� Start ----------------------------------------------');
      gf_log('CommTax2 pMyTotExecAmt:' + ForMatFloat('#,##0', pMyTotExecAmt));
      gf_log('CommTax2 pMyTotExecQty:' + ForMatFloat('#,##0', pMyTotExecQty));

      if pMyTotExecQty = 0 then
      begin
        gf_log('CommTax2 ���� 0');
        Result := True;
      end // if pMyTotExecQty = 0 then
      else
      begin
        pMyAvrExecPrice := pMyTotExecAmt / pMyTotExecQty; //������.
        //���忡�� ������, ������ ���
        if not gf_HostCallsncalculate(
          pMyTradeDate, pMyIssueCode, pMyTranCode, pMyTradeType, pMyAccNo, pMyStlDate,
          pMyAvrExecPrice, pMyTotExecQty, pMyTotExecAmt,
          //output
          dCommGara, pMyTTax, pMyATax, pMyCTax, dNetAmtGara, dMyCommRateGara, //�������� ����~
          pMsg) then Exit;

        //������ SettleNet�� ���
        //���忡�� ������ ���� ������
        //������, �����ݾ��� �츮�� ���߿� ���
        if pSettleNetCommCalcYN = 'Y' then
        begin
          pMyComm := gf_Trunc(pMyTotExecAmt * pMyCommRate * 0.1) * 10;
          //pMyCommRate := pMyCommRate; ���������� ���� �״��
        end
        else //���忡�� ������, ������ ����ϸ� ���忡�� �� ���������� ġȯ
        begin
          pMyComm := dCommGara;
          pMyCommRate := dMyCommRateGara;
        end; // if pSettleNetCommCalcYN = 'Y' then

        if pMyTradeType = 'B' then //�����ݾװ��, �ϳ������� �����ݾ� ����.
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
      gf_log('CommTax2 DType ������, ������ ��� End ----------------------------------------------');

    end; //with DataModule_SettleNet.ADOQuery_Main do

  end // if gf_GetSystemOptionValue('HXX','H') = 'D' then
  //============================================================================
  else //���� �����Ҷ� =========================================================
  begin //======================================================================

    with DataModule_SettleNet.ADOQuery_Main do
    begin
      gf_log('������ ���� Start ----------------------------------------------');

      //1. ������ ���� ��� �������ϱ� : �ڱ��ڽ� ����
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
              //�屸���� �����Ѵ�
        '   and   substring(TRAN_CODE,1,2) =  substring(''' + pMyTranCode + ''',1,2) ' +
              //�Ϲ�,����,���α׷����δ� �����Ͽ� �ѱ׷����� �Ѵ�.
              //����/����������� �����ϰ� ��ü���к���  �ѱ׷����� �Ѵ�
        '    and     (case substring(TRAN_CODE,4,1)                                                   ' +
        '    when ''1'' then ''A'' when ''2'' then ''3'' when ''5'' then ''B'' when ''6'' then ''C''  ' +
        '    else substring(TRAN_CODE,4,1)                                                            ' +
        '    end)                                                                                     ' +
        ' = (case substring(''' + pMyTranCode + ''',4,1)                                                ' +
        '    when ''1'' then ''A'' when ''2'' then ''3'' when ''5'' then ''B'' when ''6'' then ''C''  ' +
        '    else substring(''' + pMyTranCode + ''',4,1)                                                ' +
        '    end)                                                                                     ' +
        '    AND   ((TRAN_CODE+BRK_SHT_NO) <> (''' + pMyTranCode + pMyBrkShtNo + ''')) ' + //�ڱ��ڽ� ����
        '    and     TOT_EXEC_QTY > 0 '
        );

      try
        gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
      except
        on E: Exception do
        begin
          pMsg := '������ ���� ��� �������ϱ�[SELECT �ջ�]: ' + E.Message;
          Exit;
        end;
      end;

      if RecordCount >= 1 then
      begin
        dSumQtyComm := FieldByName('TOT_EXEC_QTY').AsFloat;
        dSumAmtComm := FieldByName('TOT_EXEC_AMT').AsFloat;
        gf_log('@@������ ���� �� ���� CNT ' + ForMatFloat('#,##0', FieldByName('CNT').AsFloat));
        gf_log('@@������ ���� �� ���� sum dSumQtyComm' + ForMatFloat('#,##0', dSumQtyComm));
        gf_log('@@������ ���� �� ���� sum dSumAmtComm' + ForMatFloat('#,##0', dSumAmtComm));
      end
      else
      begin
        pMsg := '������ ���� ��� �������ϱ� ����: RecordCount = 0';
        Exit;
      end; // if RecordCount >= 1 then

      dTotExecQtyComm := dSumQtyComm + pMyTotExecQty;
      dTotExecAmtComm := dSumAmtComm + pMyTotExecAmt;
      gf_log('@@������ ���� �� ���� sum dTotExecQtyComm' + ForMatFloat('#,##0', dTotExecQtyComm));
      gf_log('@@������ ���� �� ���� sum dTotExecAmtComm' + ForMatFloat('#,##0', dTotExecAmtComm));

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
        begin //������ SettleNet�� ���
          dComm := gf_Trunc(dTotExecAmtComm * pMyCommRate * 0.1) * 10;
        end // if pSettleNetCommCalcYN = 'Y' then
        else
        begin //���忡�� ������ ���
          // [Y.K.J] 2011.12.20 ���� ���� �� �ý������� ���鼭 �̺κ��� ��Ž.

          //�����Ẹ������ �������� call ==========================================
          if not gf_HostCallsncalculate(
            pMyTradeDate, pMyIssueCode, pMyTranCode, pMyTradeType, pMyAccNo, pMyStlDate,
            dAvrExecPriceComm, dTotExecQtyComm, dTotExecAmtComm, //���ջ� ���� ������
            //output
            dComm, dTTaxGara, dATaxGara, dCTaxGara, dNetAmtGara, pMyCommRate, //���ջ� ���� �޴´�
            pMsg) then Exit;
        end; // if pSettleNetCommCalcYN = 'Y' then else

      end; // if dTotExecQtyComm = 0 then else

      gf_log('@@�����Ẹ�� MCA ������ ����� �����׷������ dComm' + ForMatFloat('#,##0', dComm));
      gf_log('@@�����Ẹ�� MCA ������ ����� �����׷������ pMyCommRate' + ForMatFloat('0.000000', pMyCommRate));
      //gf_log('@@�����Ẹ�� CICS ������ ����� �����׷������ dComm' + ForMatFloat('#,##0',dComm));
      //gf_log('@@�����Ẹ�� CICS ������ ����� �����׷������ pMyCommRate' + ForMatFloat('0.000000',pMyCommRate));

      //SP Call & Return
      if not ExecuteCommBojung(
        gvOprUsrNo, gvDeptCode, pMyTradeDate, pMyAccNo, pMyBrkShtNo, pMyIssueCode, pMyTranCode, pMyTradeType,
        pMyTotExecAmt, dTotExecAmtComm, dComm, pMyCommRate,
        //output
        pMyComm, pMyNetAmt, pMsg) then Exit;

      gf_log('@@�����Ẹ�� �ڱ��ڽ� ������ pMyComm' + ForMatFloat('#,##0', pMyComm));
      gf_log('@@�����Ẹ�� pMyNetAmt' + ForMatFloat('#,##0', pMyNetAmt));

      gf_log('������ ���� End ----------------------------------------------');


      //-- ������ ���� ---------------------------------------------------------
      if (pMyTradeType = 'B') or //�����ݺ������ �ƴ�
        ((RightStr(pMyTranCode, 1) <> '1') and
        (RightStr(pMyTranCode, 1) <> '2') and
        (RightStr(pMyTranCode, 1) <> '5') and
        (RightStr(pMyTranCode, 1) <> '6'))
        then
      begin
        //�ż��̰ų� ������� ������� �ƴ�.
      end // if (pMyTradeType = 'B') or ~
      else //�����ݺ��� ��� =======
      begin

        gf_log('������ ���� Start --------------------------------------------');

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
                //�屸���� �����Ѵ�
          '   and   substring(TRAN_CODE,1,2) =  substring(''' + pMyTranCode + ''',1,2) ' +
                //�Ϲ�,����,���α׷����δ� �����Ͽ� �ѱ׷����� �Ѵ�.
                //��ü������ �����ϰ� ������ ������� �ѱ׷����� �Ѵ�.
                //substring(TRAN_CODE,4,1)�� 1,2,5,6�� �������� ������� ��.
          '    and     substring(TRAN_CODE,4,1) in (''1'',''2'',''5'',''6'')   ' +
          '    and     substring(TRAN_CODE,4,1) in (''1'',''2'',''5'',''6'')   ' +
          '    AND   ((TRAN_CODE+BRK_SHT_NO) <> (''' + pMyTranCode + pMyBrkShtNo + ''')) ' + //�ڱ��ڽ� ����
          '    and     TOT_EXEC_QTY > 0 '
          );

        try
          gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
        except
          on E: Exception do
          begin
            pMsg := '������ ���� ��� �������ϱ�[SELECT �ջ�]: ' + E.Message;
            Exit;
          end;
        end;

        if RecordCount >= 1 then
        begin
          dSumQtyTax := FieldByName('TOT_EXEC_QTY').AsFloat;
          dSumAmtTax := FieldByName('TOT_EXEC_AMT').AsFloat;
          gf_log('@@������ ���� �� ���� CNT ' + ForMatFloat('#,##0', FieldByName('CNT').AsFloat));
          gf_log('@@������ ���� �� ���� sum dSumQtyTax' + ForMatFloat('#,##0', dSumQtyTax));
          gf_log('@@������ ���� �� ���� sum dSumAmtTax' + ForMatFloat('#,##0', dSumAmtTax));
        end // if RecordCount >= 1 then
        else
        begin
          pMsg := '������ ���� ��� �������ϱ� ����: RecordCount = 0';
          Exit;
        end; // if RecordCount >= 1 then else

        dTotExecQtyTax := dSumQtyTax + pMyTotExecQty;
        dTotExecAmtTax := dSumAmtTax + pMyTotExecAmt;
        gf_log('@@������ ���� �� ���� sum dTotExecQtyTax' + ForMatFloat('#,##0', dTotExecQtyTax));
        gf_log('@@������ ���� �� ���� sum dTotExecAmtTax' + ForMatFloat('#,##0', dTotExecAmtTax));

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

          //�����ݺ������� �������� call ==========================================
          if not gf_HostCallsncalculate(
            pMyTradeDate, pMyIssueCode, pMyTranCode, pMyTradeType, pMyAccNo, pMyStlDate,
            dAvrExecPriceTax, dTotExecQtyTax, dTotExecAmtTax, //���ջ� ���� ������
            //output
            dCommGara, dTTax, dATax, dCTax, dNetAmtGara, dMyCommRateGara, //���ջ� ���� �޴´�
            pMsg) then Exit;

          //============================================================================================
          // ��ǥ���º����϶���, ���ش�.
          // ���κδ� ���¿����� ���� ���� ���ؼ� �����Ÿ�, ������ŸŰ� ��������� �߻��� �� ������...
          // �����δ� ���¿����� ��� ���� ���ؼ� ����, ������� �����Ǿ� �ִ�. (���°�������: TRADE_TAX_YN)
          //============================================================================================
          if pHwAccTaxUse = 'Y' then
          begin
            gf_log('@@��ǥ���º��ҽø� �ش�@@ ');
            gf_log('@@��������·� ���� 0���� [dTTax, dATax, dCTax] = 0 ');
            dTTax := 0;
            dATax := 0;
            dCTax := 0;
          end; // if pHwAccTaxUse = 'Y' then
        end; // if dTotExecQtyTax = 0 then else

        gf_log('@@�����ݺ��� CICS ������ ����� �����׷�ŷ��� dTTax' + ForMatFloat('#,##0', dTTax));
        gf_log('@@�����ݺ��� CICS ������ ����� �����׷��Ư�� dATax' + ForMatFloat('0.000000', dATax));
        gf_log('@@�����ݺ��� CICS ������ ����� �����׷�絵�� dCTax' + ForMatFloat('0.000000', dCTax));

        //SP Call & Return
        if not ExecuteTaxBojung(
          gvOprUsrNo, gvDeptCode, pMyTradeDate, pMyAccNo, pMyBrkShtNo, pMyIssueCode, pMyTranCode, pMyTradeType,
          pMyTotExecAmt, pMyComm, dTotExecAmtTax, dTTax, dATax, dCTax,
          //output
          pMyTTax, pMyATax, pMyCTax, pMyNetAmt, pMsg) then Exit;

        gf_log('@@�����ݺ��� pMyTTax' + ForMatFloat('#,##0', pMyTTax));
        gf_log('@@�����ݺ��� pMyATax' + ForMatFloat('#,##0', pMyATax));
        gf_log('@@�����ݺ��� pMyCTax' + ForMatFloat('#,##0', pMyCTax));
        gf_log('@@�����ݺ��� pMyNetAmt' + ForMatFloat('#,##0', pMyNetAmt));

        gf_log('������ ���� End ----------------------------------------------');

      end; // if (pMyTradeType = 'B') or ~ else

    end; // with DataModule_SettleNet.ADOQuery_Main do

  end; //�����ҽ�

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
   // �ϳ�����
  if gvHostGWUseYN = 'Y' then
  begin
    if not gf_HostGateWayCalculate(sTrdDate, sIssueCode, sTranCode, sTrdType,
      sAccNo, sStlDate, dAvrExecPrice, dTotExecQty, dTotExecAmt,
      dComm, dTrdTax, dAgcTax,
      dCpgTax, dNetAmt, dHCommRate, sOut) then Exit;
  end else
   // �ѱ�����
  begin
      //----------------------------------------------------------------------------
      // Connect MCA
      //----------------------------------------------------------------------------
    if not gf_tf_HostMCAConnect(False, sOut) then
    begin
      gf_ShowErrDlgMessage(0, 0, 'MCA ���� ����.'
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

  //-- �ϳ����� ��ü�ڵ� �������� ----------------------------------------------
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

  end; //-- �ϳ����� ��ü�ڵ� �������� -----------------------------------------

begin
  Result := false;
   // SocketThread ���������� üũ
  irc := fnMdServerAlive;
  if irc = -1 then
  begin
    sOut := 'gf_HostGateWayCalculate >> not fnServerAlive HostGW�� ���������� Ȯ���Ͻʽÿ�.';
    Exit;
  end;

  // ���¹�ȣ ü��(11): ���¹�ȣ(8) + ���»�ǰ�ڵ�(3)
  //���»�ǰ�ڵ�
  sCmtType := Copy(pAccNo,9,3);

  //����ŷ�����
  sCd := Copy(pTranCode, 2, 1);
  if sCd = '1' then sMrktDeal := gcHanaMCI_Mrkt_KSP else
  if sCd = '2' then sMrktDeal := gcHanaMCI_Mrkt_KSD else
  if sCd = '3' then sMrktDeal := gcHanaMCI_Mrkt_FRE else
  if sCd = 'A' then sMrktDeal := gcHanaMCI_Mrkt_OTC else
                    sMrktDeal := gcHanaMCI_Mrkt_All;
  //��Ÿ�ü����
  sCd := Copy(pTranCode, 4, 1);
  sCommOrd := GetComCode(sCd);

  //���α׷�ȣ������ (���α׷����� �켱������)
  sCd := Copy(pTranCode, 3, 1);
  if sCd = '4' then sPgmCall := gcHanaMCI_Pgmc_Pgm else
                    sPgmCall := gcHanaMCI_Pgmc_Gen;

   //�Ÿű���
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

  // �����᳻��~~~!!
  irc := fnComDataSend(CommData);

  if irc = -1 then
  begin
    result := False;
    if Length(CommData.csErrmsg) > 0 then
      sOut := 'gf_HostGateWayCalculate >> not fnComDataSend [' + CommData.csErrcode + ']' + Trim(CommData.csErrmsg)
    else
      sOut := 'gf_HostGateWayCalculate >> not fnComDataSend HostGW�� ���������� Ȯ���Ͻʽÿ�.';
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


//������ �������� SP Call

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
      sMsg := sMsg + #13#10 + 'SBPCommBojung: �˼����¿��� Return Value <> 1';

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

//������ �������� SP Call

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
      sMsg := sMsg + #13#10 + 'SBPTaxBojung: �˼����¿��� Return Value <> 1';

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

//�׸���� 0���ͽ���
//������ A���ͽ���
//�׸��尡 26���� �ʰ��� AA, AB �� ��Ÿ��

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
      //else ���� ����, //Registry Read / Write ������ ������ �׳� �Ҹ����� �������. �ܱ��趫��.
    except //Registry Read / Write ������ ������ �׳� �Ҹ����� �������. �ܱ��趫��.
    end;
  finally
    Reg.Free;
  end;
}
//�� ������Ʈ��ó���� �ȸԳ�...�Ʒ��� ���� ���� ���. �� �ڽ�����.
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

// �ø�
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
//���� ���� Import Using CICS

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
    ShowMessage('Dll Load ����');
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
      caaAccNo[i][0] := ' '; //������ 5������ Spaceó���ϱ�� ��.
    end;
  end
  else
  begin
//    ShowMessage('�ش� �׷��� ���°� �������� �ʽ��ϴ�.');
//    Exit;
    caaAccNo[0][0] := ' '; //������ 5������ Spaceó���ϱ�� ��.
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

//���� �Ÿ� Import Using CICS

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
    ShowMessage('Dll Load ����');
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
      caaAccNo[i][0] := ' '; //������ 5������ Spaceó���ϱ�� ��.
    end;
  end
  else
  begin
//    ShowMessage('�ش� �׷��� ���°� �������� �ʽ��ϴ�.');
//    Exit;
    caaAccNo[0][0] := ' '; //������ 5������ Spaceó���ϱ�� ��.
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

//��Ź�ڷ� ���� Call

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
    ShowMessage('Dll Load ����');
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
      caaAccNo[i][0] := ' '; //������ 5������ Spaceó���ϱ�� ��.
    end;
  end
  else
  begin
//    ShowMessage('�ش� �׷��� ���°� �������� �ʽ��ϴ�.');
//    Exit;
    caaAccNo[0][0] := ' '; //������ 5������ Spaceó���ϱ�� ��.
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

//�̰����ڷ� ���� Call

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
    ShowMessage('Dll Load ����');
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
      caaAccNo[i][0] := ' '; //������ 5������ Spaceó���ϱ�� ��.
    end;
  end
  else
  begin
//    ShowMessage('�ش� �׷��� ���°� �������� �ʽ��ϴ�.');
//    Exit;
    caaAccNo[0][0] := ' '; //������ 5������ Spaceó���ϱ�� ��.
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

//����ܰ� ���� Call

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
    ShowMessage('Dll Load ����');
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
      caaAccNo[i][0] := ' '; //������ 5������ Spaceó���ϱ�� ��.
    end;
  end
  else
  begin
//    ShowMessage('�ش� �׷��� ���°� �������� �ʽ��ϴ�.');
//    Exit;
    caaAccNo[0][0] := ' '; //������ 5������ Spaceó���ϱ�� ��.
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
// �������� ���μ��� count �˾Ƴ���
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
// ���� �� ȭ�� ��� ������ ���
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
// [Y.K.J] 2007.12.13 ���ǽ� 2007 ȣȯ�� ������ ���� �Լ� �߰�
//         (�⺻ Ȯ���ڸ�: .xls -> .xlsx)
//         2008.09.11 ����: ���� �����ȣ ��� ó��
//------------------------------------------------------------------------------

procedure gf_ExcelSaveAs(pXL: Variant; pFileName: string; pFileFormat: Integer = xlExcel9795);
var
  sWritePassWd: string;
begin
  // ������ȣ ��� ���� üũ
  sWritePassWd := gf_GetXLOptionValue;
  // ����
  if (pFileFormat = xlExcel9795) then
  begin
    if Double(pXL.Version) >= 12 then // 2007�ϰ��
      pXL.ActiveWorkBook.SaveAS(pFileName, 56, WriteResPassword := sWritePassWd)
    else
      pXL.ActiveWorkBook.SaveAS(pFileName, xlExcel9795, WriteResPassword := sWritePassWd)
  end else
  begin
    pXL.ActiveWorkBook.SaveAS(pFileName, pFileFormat);
  end;
end;
// ���� �����ȣ ��� ���� üũ

function gf_GetXLOptionValue: string;
var
  sCfgDir: string;
  XLInfo: TIniFile;
begin
  try
    Result := '';
    // ��������(Scf.Ini) ��� ����
    //sCfgDir := Copy(pFileName,1,Pos('..',pFileName)-5)+'Cfg\';
    sCfgDir := Copy(ExtractFilePath(ParamStr(0)), 1, Pos('Bin\', ExtractFilePath(ParamStr(0))) - 1) + 'Cfg\';
    // ���� ���� �б�
    XLInfo := TIniFile.Create(sCfgDir + 'Scf.Ini');
    // ��ȣ ����ϸ� ��ȣ�� ����
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

// [Y.K.J] 2012.05.05 ������ üũ (SP: SBP2801_TDC)
// SETRADE_TBL �� SESPEXE_TBL �� ������ ���Ѵ�.

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
          'ADOQuery_Main[exec SBP2801_TDC]: ' + E.Message, 0); //Database ����
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
        + '] ' + '�Ÿų��� ����ġ ���� ���');
      sErrAccNoList.Add('****************************************');

      First;
      while not Eof do
      begin
        // ����Ʈ�� ����[���¹�ȣ]
        sErrAccNoList.Add(gf_FormatAccNo(Trim(FieldByName('ACC_NO').AsString),
          Trim(FieldByName('SUB_ACC_NO').AsString)));
        Next;
      end;
      // ����Ʈ���� ���� ����
      sErrAccNoList.SaveToFile(sErrAccListSavePath + sErrAccListSaveFileName);

      // �����޽��� ���
      gf_ShowErrDlgMessage(iTrCode, 0,
        '***********************************************' + Chr(10)
        + '  �Ÿż����� ���� �ʴ� �����Ͱ� �߰ߵǾ����ϴ�.' + Chr(10)
        + '  �Ÿ� Import�� ������Ͻñ� �ٶ��ϴ�.         ' + Chr(10)
        + '  [Ȯ��]��ư�� ������ ��� Ȯ���� �����մϴ�.  ' + Chr(10)
        + '  (�� ' + IntToStr(RecordCount) + ' ��)          ' + Chr(10)
        + '***********************************************', 0);

      sErrAccNoList.Clear;
      sErrAccNoList.Free;

      // ����ġ ��� ����
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
// CTM ä��
// ����
// [sGB] M : MasterReferenceID  : M + YYMMDD + 99999 (ID)
//       C : ClientAllocationID : C + YYMMDD + 99999 (ID)
//------------------------------------------------------------------------------

function gf_GetCTMID(sTradeDate, sGB: string): string;
begin
  gf_BeginTransaction; //ä���� ���ϼ� �������� �ݵ�� ���� �Ǵ�.
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
  gf_CommitTransaction; //���� Ǭ��.
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

// Computer IP ���ؿ���
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

// Computer Ip �� ���ؿͼ� Hex�� ��ȯ
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
  // ����ǾߵǴ� ID

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
// PDF Engine ��� �� �μ� �Լ�
//------------------------------------------------------------------------------
procedure gf_DirectPrintForPDF(pPDFFileName: string);
// DynamicPDFViewer.OpenFileForPrinter() ���װ� �ִ�.
// : OpenFileForPrinter() ó�� �� �ش� �Լ��� ���� �ɶ�����
//   ���� �ڵ��� ������ �ȵȴ�. (DynamicPDFViewer.CloseFile; �� ����.)
//   �׷��� ������ �Լ��� ����. (�μ� �� ���� ������ �� �� �ְ�...)
begin
  if not Assigned(RepForm_PreviewPDF) then
  begin
    Application.CreateForm(TRepForm_PreviewPDF, RepForm_PreviewPDF);
    RepForm_PreviewPDF.Parent := gvMainFrame;
  end;

  // �̸����� ȭ�� �� ���� PDF ���� �ٷ� �μ�.
  with RepForm_PreviewPDF.DynamicPDFViewer.OpenFileForPrinter(pPDFFileName) do
  begin
    if gvDefaultPrinterUseYN <> 'Y' then
    begin
      printerName := gvPrinter.PrinterName;
    end;
    AutoRotate := True; // ������ ���� �ڵ� ����.
    if gvFaxReportDirection = '2' then
      AutoCenter := True   // ���ι���
    else
      AutoCenter := False; // ���ι���
    Scaling := 0; // 0 : Fit to Paper
    PrintQuiet;
    RepForm_PreviewPDF.Close;
  end; // with SCCPreviewFormPDF.RepForm_PreviewPDF.DynamicPDFViewer do
end;

//------------------------------------------------------------------------------
// ���� ����ִ°� Ȯ��
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
  // delimiter �� 1�ڸ��� ����
  if Length(Delimiter) > 1 then Exit;

  pStringList.Clear;
  pStringList.Delimiter := Delimiter;
  // #171 ���ڿ��� ' '�� '��' ��ü �Ͽ� �����Ѵ�
  DelimitedText := StringReplace(DelimitedText, ' ', '��', [rfReplaceAll]);

  pStringList.DelimitedText := DelimitedText;

  // ������ �ٽ� '��' ���� ' ' ������ ������
  for i := 0 to pStringList.Count - 1 do
  begin
    pStringList.Strings[i] := StringReplace(pStringList.Strings[i], '��', ' ', [rfReplaceAll]);
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

end.
