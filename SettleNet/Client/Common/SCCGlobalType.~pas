//==============================================================================
//   SettleNet Global Type
//   [LMS] 2001/08/14
//==============================================================================

unit SCCGlobalType;

interface

uses
  Windows, SysUtils, Messages, MSMQ_TLB, Printers, Graphics, Classes,
  Forms, DRToolEtc, ADODB;

const
  //----------------------------------------------------------------------------
  // Message
  //----------------------------------------------------------------------------
  WM_USER_REFRESH_CODELIST    = WM_USER + 101;  // CodeList 변경 요청 Message(Code Table 변경시)
  WM_USER_REFRESH_CODECONTROL = WM_USER + 102;  // Code Component Refresh 요청 Message
  WM_USER_CREATE_FORM         = WM_USER + 103;  // WParam을 TRCode로 간주하여 MenuClick과 동일 처리
  WM_USER_ENABLE_MENU         = WM_USER + 104;  // Main Frame의 Main Menu와 ToolBar Enable
  WM_USER_DISABLE_MENU        = WM_USER + 105;  // Main Frame의 Main Menu와 ToolBar Disable
  WM_USER_DISPLAY_TICKER      = WM_USER + 106;  // Ticker Message 처리
  WM_USER_RESET_TOOLBAR       = WM_USER + 107;  // 사용자정의 ToolBar 재구성
  WM_USER_REFRESH_GLOBVAR     = WM_USER + 108;  // Global var 갱신 요청 Message(Global 변수 관련 Table 변경시)
  WM_USER_REQUEST_DECISION    = WM_USER + 109;  // 결재 요청 처리
  WM_USER_ACCESS_CONTROL_CHEK = WM_USER + 110;  // ACCESS CONTROL 처리 
  WM_USER_REFRESH_GROUPLIST   = WM_USER + 111;  // GroupList 변경 요청 Message
  WM_USER_REFRESH_GROUPCONTROL= WM_USER + 112;  // Group Component Refresh 요청 Message

  WM_USER_CHANGE_JOBDATE      = WM_USER + 200;  // 송수신 Manager의 일자 변경 Message
  WM_USER_CHANGE_CURMEDIA     = WM_USER + 201;  // 송수신 Manager의 Media 변경 Message
  WM_USER_ENABLE_SRMGRFRAME   = WM_USER + 202;  // 송수신 Manager의 화면(수신확인, 자료전송, 송신확인)변경 가능 처리
  WM_USER_DISABLE_SRMGRFRAME  = WM_USER + 203;  // 송수신 Manager의 화면(수신확인, 자료전송, 송신확인)변경 불가능 처리
  WM_USER_CANCEL_FAX_SEND     = WM_USER + 204;  // 팩스 전송 중 취소
  WM_USER_MSMQ_RESULT         = WM_USER + 211;  // RealTime Message of MSMQ
  WM_USER_FAX_RESULT          = WM_USER + 212;  // RealTime Message of FAX, TLX
  WM_USER_EMAIL_RESULT        = WM_USER + 213;  // RealTime Message of EMAIL

  WM_USER_BF_FORM_CLOSE       = WM_USER + 220;  // Client Form 죽을때 나 죽어요 알림

  gcDISPLAY_TICKER_WPARAM_RECV      = 1;   // Ticker Display - 수신정보
  gcDISPLAY_TICKER_WPARAM_ITMSG     = 2;   // Ticker Display - IT Message
  gcDISPLAY_TICKER_LPARAM_BLINK_ON  = 1;   // Ticker Display - Blink On
  gcDISPLAY_TICKER_LPARAM_BLINK_Off = 2;   // Ticker Display - Blink Off

  //---------------------------
  // Code Table 정보
  //---------------------------
  gcCODE_TABLE_ALL      = 0;
  gcCODE_TABLE_SCROLE   = 1;
  gcCODE_TABLE_SCSECTP  = 2;
  gcCODE_TABLE_SCMKTTP  = 3;
  gcCODE_TABLE_SCTRMTD  = 4;
  gcCODE_TABLE_SCCOMTP  = 5;
  gcCODE_TABLE_SETEMCD  = 6;
  gcCODE_TABLE_SCFTYPE  = 7;
  gcCODE_TABLE_SCSNDMT  = 8;
  gcCODE_TABLE_SUCOMCD  = 9;
  gcCODE_TABLE_SCISSIF  = 10;
  gcCODE_TABLE_SCPARTY  = 11;
  gcCODE_TABLE_SUTRNCD  = 12;
  gcCODE_TABLE_SUDEPCD  = 13;
  gcCODE_TABLE_SCUREPID = 14;
  gcCODE_TABLE_SUMGRAC  = 15;

  //---------------------------
  // Global 변수 RealTime 수정
  //---------------------------
  gcGLOB_GCPREVIEW_PERCENT = 1;              // Preview Percent
  gcGLOB_GCUSE_DECLINE     = 2;              // 결재 라인 사용 여부
  gcGLOB_GMAIL_INFO        = 3;              // 메일전송자명, 리턴메일주소, 메일서명

  gcMainIniFileName    = 'SettleNet.Ini';    // SettleNet Environment Ini File Name
  gcFormIniFileName    = 'Scf.Ini';          // SettleNet Form Ini File Name
  gcCommonSection      = 'Common Info';      // SettleNet Form Ini File - 공통 Section
  gcPrinterSection     = 'Printer';          // SettleNet Form Ini File - Printer Section
  gcPrinterNameKey     = 'PrinterName';      // SettleNet Form Ini File - Printer Section PrinterName Key 
  gcOrientationKey     = 'Orientation';      // SettleNet Form Ini File - Printer Section Orientation Key
  gcMainFontName       = '굴림체';           // Main Used Font Name
  gcApplicationName    = 'SettleNet';        // Application Name
  gcNonePrinter        = -1;                 // 연결된 프린터 없음
  gcMsgLineInterval    = chr(13) + chr(13);  // Message Dialog에서의 line간격
  gcMaxMsmqDataSize    = 7000;               // MSMQ 전송을 위한 Packet의 Max Size

  gcGridBackColor      = clWhite;            // Grid Background Color(선택)
  gcGridSelectColor    = $00F4DDD2;          // Grid Select Color(선택) $00A6E0FF;
  gcSubGridSelectColor = $00FFF5F0;          // Grid Sub Select Color(선택) $00ECFFFF;
  gcGridTotSumColor    = $00F4F7FF;          // Grid 합계 관련 Color;
  gcGridEditableColor  = $00ECFFFF;          // Editing 가능한 Grid Cell Color $00DBFDEA;
  gcQueryEditColor     = $00FBEAE3;          // Query 가능 Edit Color(선택) $00ECFFFF;
  gcSelectItemColor    = $009A0742;          // 전송 선택 내역 Color
  gcTreeViewColor      = $00FFEEEE;          // TreeView Color $00ECFFFF;
  gcBlinkColor         = $00FFDFEE;          // Real Time Blink
  gcErrorColor         = clRed;              // Error Color
  gcManualColor        = clPurple;           // 수작업 표시 Color $00005EBB;
  gcReceivableColor    = clBlue;             // 미수 Color
  gcDomFaxColor        = clNavy;             // 국내팩스 (수신처관리)
  gcIntFaxColor        = $00FD5A02;          // 국제팩스 (수신처관리)
  gcTelexColot         = clPurple;           // 텔렉스 (수신처관리)
{
  gcGridBackColor      = clWhite;            // Grid Background Color(선택)
  gcGridSelectColor    = $00A6E0FF;
  gcSubGridSelectColor = $00ECFFFF;
  gcGridEditableColor  = $00DBFDEA;
  gcQueryEditColor     = $00ECFFFF;
  gcSelectItemColor    = $009A0742;          // 전송 선택 내역 Color
  gcTreeViewColor      = $00ECFFFF;
  gcBlinkColor         = $00FFDFEE;          // Real Time Blink
  gcErrorColor         = clRed;              // Error Color
  gcProcessColor       = clGreen;            // '진행중' 표시 Color
  gcManualColor        = $00005EBB;
  gcReceivableColor    = clBlue;             // 미수 Color
}
  // MSMQ, FAX Result Color
  gcRSPWaitColor   = clPurple;
  gcRSPSendColor   = $000080FF;
  gcRSPSentColor   = clGreen;
  gcRSPAckColor    = clGreen;
  gcRSPConfColor   = clNavy;
  gcRSPRecvColor   = $00DA6025;
  gcRSPBusyColor   = clGreen;
  gcRSPCancColor   = $00FD5A02;
  gcRSPFinColor    = clNavy;
  gcRSPErrColor    = clRed;
  gcRSPRejColor    = clRed;
  gcProcessColor   = clGreen;            // '진행중' 표시 Color

  gwTotal          = '전체';
  gwBuy            = '매수';
  gwSell           = '매도';
  gwBuyToOffset    = '환매';
  gwSellToOffset   = '전매';
  gwSettleExec     = '행사';
  gwSettleDistr    = '분배';
  gwFinalBuyToOffset  = '최종환매';
  gwFinalSellToOffset = '최종전매';
  gwNet            = 'Net';
  gwGross          = 'Gross';
  gwDomestic       = '내국인';
  gwForeign        = '외국인';
  gwQueryCnt       = '자료갯수:';
  gwSendStop       = '전송중지';
  gwNotAssigned    = '미등록';
  gwAssigned       = '등록';
  gwFreqNo         = '회차';
  gwDataCnt        = '건';
  gwKSDCust        = '고객';
  gwKSDProp        = '자기';
  gwKSDSettle      = '기관결제';
  gwKSE            = 'KSE';
  gwKOSDAQ         = 'KOSDAQ';
  gwOTC            = 'OTC';
  gwOprId          = '조작자';
  gwSubTotalSum    = '소계';
  gwTotalSum       = '합계';
  gwErrLineNo      = '오류라인# - ';
  gwDomFax         = '국내FAX';
  gwIntFax         = '국제FAX';
  gwTelex          = 'TELEX';
  gwProgram        = '프로그램';
  gwNonPgm         = '일반';
  gwAccnoCnt       = '계좌수: ';

  gwRSPOK          = 'OK';
  gwRSPError       = 'ERROR!';
  gwRSPSend        = 'SEND..';
  gwRSPSent        = 'SENT!!';
  gwRSPAck         = 'ACK.';
  gwRSPConfirm     = 'CONF.';
  gwRSPReceive     = 'RECV.';
  gwRSPBusy        = 'RETRY!';
  gwRSPFinish      = 'FINISH';
  gwRSPWaiting     = 'WAIT..';
  gwRSPReject      = 'REJECT';
  gwRSPCancel      = 'CANCEL';
  gwRSProcessing   = '진행중..';
  gwRSFinishAll    = '정상완료';
  gwRSNotFinishAll = '오류발생';

  // Message
//  gwSendData        = 'DATA 전송 중입니다. 잠시 기다리십시오...';
  gwSendData        = 'DATA 전송';
  gwSendFax         = 'FAX 전송';
  gwSendTlx         = 'TLX 전송';
  gwSendMsg         = '전송 중입니다. 잠시 기다리십시오...';
  gwCreFileMsg      = '파일 생성 중입니다. 잠시 기다리십시오...';
  gwResendMsg       = '재전송 중입니다. 잠시 기다리십시오...';
  gwPrintingMsg     = '인쇄 중입니다. 잠시 기다리십시오...';
  gwExportMsg       = 'Export 중입니다. 잠시 기다리십시오...';
  gwImportMsg       = 'Import 중입니다. 잠시 기다리십시오...';
  gwManualWarning   = '기존 수작업 자료가 있습니다. 갯수 : ';
  gwAfterDelImport  = '기존 수작업자료를 삭제후 Import 하시겠습니까? ';

  gwCreFileErrMsg   = '파일 생성 중 오류 발생! ';
  gwSendErrMsg      = '전송 중 오류 발생! ';
  gwResendErrMsg    = '재전송 중 오류 발생! ';
  gwPrintErrMsg     = '인쇄 중 오류 발생! ';
  gwExportErrMsg    = 'Export 중 오류 발생! ';
  gwImportErrMsg    = 'Import 중 오류 발생! ';
  gwClickOKMsg      = '확인 버튼을 눌러주십시오.';

  gwAccNoDelMsg     = '부계좌가 등록되어 있습니다. 삭제하시겠습니까? ';

  // 매매구분
  gcTRADE_SELL      = 'S';  // 매도
  gcTRADE_BUY       = 'B';  // 매수
  gcTRADE_SELL_OFF  = 'T';  // 전매도
  gcTRADE_BUY_OFF   = 'H';  // 환매수
  gcTRADAE_EXEC     = 'E';  // 행사
  gcTRADE_DISTR     = 'D';  // 분배

  // ROLE CODE
  gcROLE_INVESTOR   = 'I';  // Investor
  gcROLE_BROKER     = 'B';  // Broker
  gcROLE_CUSTODY    = 'C';  // Custody
  gcROLE_TRUST      = 'T';  // 사무수탁사

  // SEC TYPE
  gcSEC_EQUITY      = 'E';
  gcSEC_BOND        = 'B';
  gcSEC_FUTURES     = 'F';
  gcSEC_KOFEX       = 'K';
  gcSEC_OPTION      = 'O';
  gcSEC_INDEX       = 'I';
  gcSEC_TESTMSG     = '?';
  gcSEC_COMMONFAX   = 'C';
  gcSEC_FINANCIALINS= 'Z';

  gcKOSPI200        = 'KKKKKKKKKKKKKKKKKKKK';   //KOSPI200 Char(20)종목코드

  // FUND TYPE
  gcFTYPE_MUTUAL    = '5';     // 뮤추얼펀드

  // BNK COMP CODE
  gcBNK_KSD_SETTLE  = '0000';  // 기관결제
  gcBNK_NON_MEMBER  = '0001';  // 비회원
  gcBNK_HOUSE       = '0002';  // 상품
  gcBNK_DVP         = '0003';  // DVP
  gcBNK_DANGSA      = '0004';  // 당사

  // 송수신 DEPT_CODE (SP0103 호출시 사용)
  gcDEPT_CODE_COMMON = '??';

  // 툭정부서
  gcDEPT_COMMON      = '00';  // 특정부서 관련 없이 공통 부서(보고서 때문에 추가)
  gcDEPT_CODE_CORP   = '01';  // 법인부
  gcDEPT_CODE_INT    = '02';  // 국제부

  // 내외국인 구분
  gcDOMESTIC        = 'D';
  gcFOREIGN         = 'F';

  // Round Chopping Type
  gcROUND           = 'R';
  gcCHOPPING        = 'C';

  // 결제 방법
  gcSTL_NET         = 'N';
  gcSTL_GROSS       = 'G';

  // KSD 계좌 계정
  gcKSD_PROP        = '1';   // 자기
  gcKSD_CUST        = '2';   // 고객

  // Send Method
  gcSEND_DATA       = '1';
  gcSEND_FAX        = '2';
  gcSEND_TLX        = '3';
  gcSEND_EMAIL      = '4';

  // 인쇄 방향
  gcPortrait        = '1';    // 세로
  gcLandscape       = '2';    // 가로

  // 인쇄 타입
  gcPTYPE_PREVIEW   = 1;      // 미리보기
  gcPTYPE_PRINT     = 2;      // 인쇄
  gcPTYPE_EXPORT    = 3;

  // Report Type
  gcRTYPE_CRPT      = '1';    // Crystal Report Type
  gcRTYPE_TEXT      = '2';    // Text Type

  // Report Group
  gcRGROUP_GRP      = '1G';    // Display 순서 + 그룹
  gcRGROUP_ACC      = '2A';    // Display 순서 + 계좌단위
//  gcRGROUP_INS      = 'I';    // 기관단위
  gcRGROUP_COM      = 'C';    // 공통

  // Authority
  gcAUTH_QUERY_ONLY = 1;      // 조회만 가능
  gcAUTH_ALL        = 2;      // 모든권한

  gcCRPTPS_MAX_COL_PORT = 65;   // PS Input Memo Col (Crystal Report Portrait(세로) Type)
  gcCRPTPS_MAX_COL_LAND = 85;   // PS Input Memo Col (Crystal Report Landscape(가로) Type)
  gcCRPTPS_MAX_ROW      = 10;   // PS Input Memo Row (Crystal Report Type)

  gcRTYPE_TEXT_MAX_LINE = 55;    // TEXT Type Report의 최대 길이
  gcRTYPE_TEXT_MAX_CHAR = 85;    // TEXT Type Report에 한줄에 들어갈 수 있는 최대 문자수

  gcTEXT_FONT_NAME  = 'COURIER'; // Text Print시 Font Name
  gcTEXT_FONT_SIZE  = 11;        // Text Print시 Font Size

  gcUSER_DEF_MARK   = '*';       // 사용자 정의 표시
  gcCOM_RPT_MARK    = '*';       // 기관단위  Report 표시 
  gcSEND_MARK       = '>';       // 전송 선택 표시
  gcINT_FAX_MARK    = '#';       // 국제 FAX 표시
  gcSPLIT_MAILADDR  = ';';       // Mail Address의 구분자
  gcINVALID_DATA    = '-';       // 모호성 데이터
  gcSPLIT_CHAR      = '^';       // 구분자
  gcSUB_SPLIT_CHAR  = '`';       // gcSPLIT_CHAR로 구분된 문장안의 구분자
  gcACCID_DIV_CHAR  = '.';       // Identification과 계좌번호의 구분자
  gcPS_MARK         = 'P.S';     // P.S 구분자 (Text Report에서 사용)
  gcSIGMA           = '∑';      // Sigma
  gcLogFileHdr      = 'SNLog';   // LogFileName의 Header
  ExceptMark        = '×';

  gcVIEW_RECV       = 1;      // 수신자료
  gcVIEW_SEND       = 2;      // 자료전송
  gcVIEW_SENT       = 3;      // 송신확인
  gcVIEW_ALL        = 4;

  gcRSP_RESULT_NONE = -1;     // 아무 상태 아님

  gcFST_PRIORITY    = 1;      // 가장 상위 순위
  gcLAST_PRIORITY   = 10;     // 가장 하위 순위
  gcDEF_PRIORITY    = 1;      // Default 순위

  // SCCRegFaxTlxAddr의 ModalResult
  gcMR_NONE           = 1;    // 조작하지 않음
  gcMR_INSERTED       = 2;    // 추가됨(Insert)
  gcMR_MODIFIED       = 3;    // 수정됨(Update,Delete)
  //조작 유형
  gcOP_INSERTED       = 'I';   //입력
  gcOP_UPDATED        = 'U';   //수정
  gcOP_DELETED        = 'D';   //삭제

  // E-mail 수신Type
  gcMAIL_RCV_TYPE     = 'R'; //수신처
  gcCCMAIL_RCV_TYPE   = 'C'; //참조
  gcCCBLIND_RCV_TYPE  = 'B'; //숨은참조

  // E-mail 서명
  gcMAIL_TAIL_CRLF    = Chr(13) + Chr(10) + Chr(13) + Chr(10) + Chr(13) + Chr(10);

  // MSMQ Result
  gcMSMQ_RSPF_WAIT    = 0;  // Waiting
  gcMSMQ_RSPF_SEND    = 1;  // Send
  gcMSMQ_RSPF_ACK     = 2;  // Ack
  gcMSMQ_RSPF_CONF    = 3;  // Confirm
  gcMSMQ_RSPF_RECV    = 4;  // Receive

  // FaxTlx Result
  gcFAXTLX_RSPF_WAIT  = 0;   // Waiting
  gcFAXTLX_RSPF_SEND  = 1;   // Sending
  gcFAXTLX_RSPF_BUSY  = 2;   // Busy
  gcFAXTLX_RSPF_CANC  = 3;   // Cancel
  gcFAXTLX_RSPF_SENT  = 8;   // 한국통신까지 Send된 상태
  gcFAXTLX_RSPF_FIN   = 9;   // Finish

  // EMail Result
  gcEMAIL_RSPF_WAIT   = 0;   // Waiting
  gcEMAIL_RSPF_SEND   = 1;   // Sending                 
  gcEMAIL_RSPF_CANC   = 3;   // Cancel
  gcEMAIL_RSPF_FIN    = 9;   // Finish

  //--- Page Sheet Index (송수신Mgr)
  gcPAGE_IDX_DATA     = 0;   // Data Page Tab Index
  gcPAGE_IDX_FAXTLX   = 1;   // Fax/Tlx Page Tab Index
  gcPAGE_IDX_EMAIL    = 2;   // EMail Page Tab Index

  gcMAX_USER_TOOLBTN  = 20;  // 사용자정의 ToolButton의 최대 갯수

  // TRX Code: 업무구분 + RoleCode + 업무Seq + Table작업(I:Insert) + Seq
  gcTRX_CODE_TRADE    = 'EI0I0';  // Broker: 매매내역
  gcTRX_CODE_PROXY    = 'EI1I0';  // Broker: Proxy 업무
  gcTRX_CODE_SETTLE   = 'EB0I0';  // Investor: 운용지시

  // INV BIZ_CODE
  gcBIZ_CODE_SETTLE   = '1'    ; // 윤용지시

  gcPDFPrinterName    = 'PDFFACTORY'; //PDF Printer 이름 pdfFactory @@20041104
  gcInEnKey           = 'dataroad,.';
  gcAMENDMENT_HEADER  = '%%AMENDMENT%%';

  // LOG 기록정보 코드
  gcLogINF       = '1000';  // 로그인정보
  gcLogINF_inout = '10001';
  gcLogINF_fail  = '10002';
  gcUsrINF       = '2000'; // 계정정보
  gcUsrINF_cre   = '20001';
  gcUsrINF_del   = '20002';
  gcUsrINF_Edi   = '20003';
  gcUsrINF_EdiPw = '20004';
  gcDisINF       = '3000'; // 화면사용정보
  gcDisINF_tr    = '30001';

  //-- 하나금융투자 MCI 코드
  // 계좌상품코드
  gcHanaMCI_Cmt_Type = '110'; //위탁
  // 시장소속구분코드
  gcHanaMCI_Mrkt_All = 'Z';  //기타
  gcHanaMCI_Mrkt_KSP = '1';  //거래소
  gcHanaMCI_Mrkt_KSD = '0';  //코스닥
  gcHanaMCI_Mrkt_FRE = 'E';  //프리보드(제3시장)
  gcHanaMCI_Mrkt_OTC = '2';  //장외단주
  // 통신매체구분
  gcHanaMCI_Comm_All = '99'; //전체
  gcHanaMCI_Comm_Gen = '00'; //일반   (일반+ARS+기타)
  gcHanaMCI_Comm_Hts = '10'; //HTS    (인터넷)
  gcHanaMCI_Comm_Pgm = '50'; //프로그램매매  (프로그램)
  // 프로그램호가구분
  gcHanaMCI_Pgmc_Gen = '00'; //일반
  gcHanaMCI_Pgmc_Pgm = '01'; //프로그램매매

  gcFILE_TYPE_RPT = 'RPT';
  gcFILE_TYPE_PDF = 'PDF';

type
  // EMailFile 생성 Function Type
  TCreEMailFunc = function (MainADOC: TADOConnection;
                     DirName, DeptCode, TradeDate : string; pGrpName : string;
                     AccNoList: TStringList; CreateFlag: boolean;
                     FileName: PChar; var ErrorNo: Integer; ExtMsg: PChar):boolean; StdCall;

  //=== Menu 정보
  TMenuInfo = record
     SecCode  : string;      // 업무 Code
     MenuId   : string;      // Menu Id
     MenuType : string;      // Menu Type
     MenuName : string;      // Menu Caption
     ShrtName : string;      // Menu 단축명
     ParentId : string;      // 상위 Menu Id
     TrCode   : string;      // TrCode
  end;
  pTMenuInfo = ^TMenuInfo;

  //=== 사용자 ToolBar
  TUserToolBar = record
     SecType    : string;    // 업무 Code
     BtnInfoList: TList;     // ToolButton 정보 List
  end;
  pTUserToolBar = ^TUserToolBar;

  // ToolButton 정보
  TBtnInfo = record
     TrCode   : Integer;     // TrCode
     ImageIdx : Integer;     // Image Index
  end;
  pTBtnInfo = ^TBtnInfo;

  //=== Print
  TSNPrinter = record
     PrinterIdx  : Integer;  // Printer Index
     PrinterName : string;   // Printer Name
     Copies      : Integer;  // 매수
     Orientation : TPrinterOrientation;   //방향설정
  end;

  //=== 일반 Code Type
  TCodeType = record
     Code : string;      // Code
     Name : string;      // Code명
  end;
  pTCodeType = ^TCodeType;

  //=== Comp Code Type
  TCompCodeType = record
     Code    : string;
     Name    : string;
     MemYN   : string;
  end;
  pTCompCodeType = ^TCompCodeType;

  //=== Issue Type
  TIssueType = record
     Code     : string;
     FullCode : string;
     FullName : string;
     ShrtName : string;
  end;
  pTIssueType = ^TIssueType;

  //=== Manager
  TManagerType = record
     SecType : string;
     MgrName : string;
  end;
  pTManagerType = ^TManagerType;

  //=== Report
  TReportType = record
     ReportId   : string;
     ReportName : string;
     Direction  : string;
     TextYn     : string;
     ReportUnit : string;
  end;
  pTReportType = ^TReportType;

  //=== SUPRTAD_TBL (Fax/Tlx)
  TFaxTlxAddr = record
     SendMtd    : string;  // Fax/Tlx
     SendSeq    : Integer;
     RcvCompKor : string;
     NatCode    : string;
     MediaNo    : string;
     IntTelYn   : string;
  end;
  pTFaxTlxAddr = ^TFaxTlxAddr;

  //=== Send MSMQ Format
  TMSMQDataFormat = record
    sTableName : string[10];
    cDelIns    : Char;
    iStartPos  : Integer;
    iDataSize  : Integer;
    iRepetCnt  : Integer;
  end;
  pMSMQDataFormat = ^TMSMQDataFormat;

  TMSMQSendFormat = record
    sCurDate     : string[8];    // 당일자
    sFromPartyID : string[6];
    sToPartyID   : string[6];
    sSecDate     : string[8];    // 업무일자
    iSendCnt     : Integer;      // 회차
    iSendTotSeq  : Integer;      // 해당회차의 총전송건수
    iSendCurSeq  : Integer;      // 해당회차 자료의 전송번호
    sTRXCode     : string[5];
    sCommonFld   : string[100];  // COMMON FIELD -> NO USE
    iInfoDataCnt : Integer;      // MSMQ Info Tabel의 갯수
    tMSMQData    : Array [0..9] of TMSMQDataFormat;
    sMainDATA    : string;
  end;
  pMSMQSendFormat = ^TMSMQSendFormat;

 //=== Send Fax/Telex Format (수신처 정보)
  TFAXTLXSendFormat = record
    sCurDate      : string[8];
    sFromPartyId  : string[6];
    sFaxTlxGbn    : string[1];
    sRcvCompKor   : string[60];
    sMediaNo      : string[64];
    sIntTelYn     : string[1];
    sNatCode      : string[2];
  end;
  pFAXTLXSendFormat = ^TFAXTLXSendFormat;

  //=== Report 정보 List
  TReportList = record
    sSecCode      : string[1];
    sTradeDate    : string[8];
    sReportType   : string[1];
    sReportId     : string[7];
    sDirection    : string[1];
    sLogoPageNo   : string;
    sTxtUnitInfo  : string;
    iTotalPageCnt : Integer;
    sFileName     : string;
    iCurTotSeqNo  : Integer;
    iIdxSeqNo     : Integer;
    tExtInfo      : Pointer;
    iExtFlag      : Integer;  // 0: NoUse    1: TBACTrade    2: TBGPTrade
                              // 3: TBACNormal   4: TBGPNormal
  end;
  pTReportList = ^TReportList;

  // [L.J.S] - 한투 금상 FAX Report 포멧 구조체 
  TFaxReportList_TFFI = record
    sSecCode      : string[1];
    sTradeDate    : string[8];
    sReportType   : string[1];
    sReportId     : string[7];
    sDirection    : string[1];
    sJobDate      : string[8];
    iJobSeq       : Integer;
    iTotalPageCnt : Integer;
    sFileName     : string;
    iCurTotSeqNo  : Integer;
    iIdxSeqNo     : Integer;
  end;
  pTFaxReportList_TFFI = ^TFaxReportList_TFFI;

  //=== Fax/Telex 전송 관련 Data
  TBACTrade = record              // Broker - A/C Trade Data
    sAccNo        : string[20];
    sSubAccNo     : string[4];
    dBuyExecAmt   : double;
    dSellExecAmt  : double;
    dBuyComm      : double;
    dSellComm     : double;
    dTotTax       : double;
    dNetAmt       : double;
  end;
  pTBACTrade = ^TBACTrade;

  TBGPTrade = record              // Broker - Group Trade Data
    sSecCode      : string[1];
    sGrpName      : string[60];
    dBuyExecAmt   : double;
    dSellExecAmt  : double;
    dBuyComm      : double;
    dSellComm     : double;
    dTotTax       : double;
    dNetAmt       : double;
    sPgmAccYn     : string[1];
    sAccAttr      : string[1];
  end;
  pTBGPTrade = ^TBGPTrade;
                                  // Broker - A/C Normal Data
  TBACNormal = record
    sAccNo     : string[20];
    sSubAccNo  : string[4];
    dAmt1      : double;          // 예탁현금, 입금총액, 예탁금이용료
    dAmt2      : double;          // 예탁총액, 출금총액, 세금합계
  end;
  pTBACNormal = ^TBACNormal;

  TBGPNormal = record             // Broker - Group Normal Data
    sSecCode   : string[1];
    sGrpName   : string[60];
    dAmt1      : double;          // 예탁현금, 입금총액, 예탁금이용료
    dAmt2      : double;          // 예탁총액, 출금총액, 세금합계
  end;
  pTBGPNormal = ^TBGPNormal;

  //=== EMail File 전송 위한 데이터
  TFSndMail = record
    AccGrpType   : string;        // 그룹 : 'G' , 계좌 : 'A'
    AccGrpName   : string;        // 그룹이름 Or 계좌이름
    MailFormId   : string;        // EMail Form Id
    MailFormName : string;        // EMail Form Name
    MailFormType : string;        // EMail Form Type
    PdfFileYN    : string;
    MailRcv      : TStringList;   // 수신처
    MailAddr     : TStringList;   // Mail Address
    CCMailRcv    : TStringList;   // 참조
    CCMailAddr   : TStringList;   // Mail Address
    CCBlindRcv   : TStringList;   // 숨은참조
    CCBlindAddr  : TStringList;   // Mail Address
    AccList      : TStringList;   // 계좌LIST
    AttFileList  : TList;         // Attach File List
    SubjectData  : string;        // Mail 제목
    MailBodyData : string;        // Mail 본문    A
    SendFlag     : boolean;       // 전송여부(생성여부)
    CancFlag     : boolean;       // 전송취소여부
    EditFlag     : boolean;       // 파일편집여부
    DpSplit      : string;       // 미분할 대표계좌 여부
    ErrMsg       : string;        // Error Message
    Selected     : boolean;       // 전송 선택 여부
    GridRowIdx   : Integer;       // Display되는 Grid의 Row Index
    iCurTotSeqNo : Integer;       // CurTotSeqNo
//    MgrName      : string;       // 관리자명 이하 20060512 추가 필터링 위함
//    PgmAcYN      : string;       // 프로그램매매 계좌 여부
//    AccAttr      : string;       // 계좌 속성
//    FundCode     : string ;      //@@ 펀드
//    FundName     : string ;      //@@ 펀드명
    SubDeptName : string;
    StartTime   : string;          //전송 시간
  end;
  pTFSndMail = ^TFSndMail;

// EMail Send Format
  TEMailSendFormat = record
    sCurDate        : string[8];
    sTradeDate      : string[8];
    sDeptCode       : string[2];
    sRcvMailAddr    : string;        // Send EMail Address List
    sCCMailAddr     : string;        // CC EMail Address List
    sCCBlindAddr    : string;        // Blind CC EMail Address List
    sRcvMailName    : string;        // Send EMail Address Name List
    sCCMailName     : string;        // CC EMail Address Name List
    sCCBlindName    : string;        // Blind CC EMail Address Name List
    sSndUserName    : string[60];    // 상대방 EMail수신신 보낸사람표시 이름
    sReturnMailAddr : string[64];    // Return Mail을 수신할 Email Address
    sSubjectData    : string[128];   // EMail 제목
    sMailBodyData   : string;        // EMail 내용(Body)
    sAccGrpType     : string;        // 그룹 : 'G' , 계좌 : 'A'
    sSecType        : string;        // 업무그룹
    sGrpName        : string;        // Group Name (Group 전송 아닐경우 '' 처리)
    sFmtAccNoList   : TStringList;   // Format AccNo(AccNo-SubAccNo) List
    sMailFormGrp    : string[2];     // MailFormID의 처음 2Char
    sOprID          : string[8];     // 조작자
    sOprTime        : string[8];     // 조작시간
    sMailFormID     : string[7];     // @@ MAIN FORM ID //@@ 2004.11.01
    iCurTotSeqNo    : Integer;       // Return변수
  end;
  pEMailSendFormat = ^TEMailSendFormat;

  // [L.J.S] - 한투 금상 E-mail 전송 포멧 구조체 
  TSndMailData_TFFI = record
    CurDate        : string[8];     // 전송일
    JobDate        : string[8];     // 작업일
    JobSeq         : Integer;       // 작업 Sequence
    DeptCode       : string[2];     // 부서코드
    RcvMailAddr    : string;        // Send EMail Address List
    RcvMailName    : string;        // Send EMail Address Name List
    SndUserName    : string[60];    // 상대방 EMail수신신 보낸사람표시 이름
    ReturnMailAddr : string[64];    // Return Mail을 수신할 Email Address
    SubjectData    : string[128];   // EMail 제목
    MailBodyData   : string;        // EMail 내용(Body)
    SecType        : string;        // 업무그룹
    OprID          : string[8];     // 조작자
    OprTime        : string[8];     // 조작시간
    ReportID       : string[7];     // MAIN FORM ID
    CurTotSeqNo    : Integer;       // Return변수
  end;
  pTSndMailData_TFFI = ^TSndMailData_TFFI;

  // EMail Send Attach File Format
  TEMailSendAttach = record
    sAttachFilePath : string;
    sAttachFileName : string;
  end;
  pEMailSendAttach = ^TEMailSendAttach;

    //=== Mail 전송 확인 데이터
  TSntMail = record
     AccGrpName  : string;       // 계좌명, 그룹명
     AccGrpType  : string;       // 그룹 : 'G' , 계좌 : 'A'
     DisplayAll  : boolean;      // 전회차 내역 보여줄지 여부
     SubDeptName : string;
     FreqList    : TList;        // 회차별 List
  end;
  pTSntMail = ^TSntMail;

  //=== Mail 전송 확인 회차 정보
  TFreqMail = record
    FreqNo       : Integer;      // 회차
    CurTotSeqNo  : Integer;      // CurTotSeqNo
    AccGrpName   : string;       // 계좌명, 그룹명
    AccList      : TStringList;  // 계좌번호 List
    RcvMailAddr  : string;       // 수신처 List
    CCMailAddr   : string;       // 참조 List
    CCBlindAddr  : string;       // 숨은 참조 List
    RcvMailName  : string;       // 수신처명
    CCMailName   : string;       // 참조명
    CCBlindName  : string;       // 숨은참조명
    SubjectData  : string;       // 제목
    MailBodyData : string;       // 내용
    AttFileList  : TList;        // Attach File List
    MailFormGrp  : string[2];    // MailFormID의 처음 2Char
    SendTime     : string;       // 전송시작시간
    SentTime     : string;       // 전송완료시간
    RSPFlag      : Integer;      // 전송 상태
    ErrCode      : string;       // Error Code
    ErrMsg       : string;       // Error Msg
    ExtMsg       : string;       // Extended Message
    OprId        : string;       // 조작자
    OprTime      : string;       // 조작시간
    LastFlag     : boolean;      // 마지막 회차 여부
    GridRowIdx   : Integer;      // Display되는 Grid의 Row Index
  end;
  pTFreqMail = ^TFreqMail;

  //=== Attach File Info
  TAttFile = record
     FileName    : string;
     AttSeqNo    : Integer;
  end;
  pTAttFile = ^TAttFile;


  //=== Broker Form Interface Data Type
  TB2101Data = Record       // [2101]계좌등록
     sAccNo        : string;
     sAccAttrType  : string; // 내국인: 1 , 외국인: 2, 부계좌: 3
     sUserSubAccNo : string;
     sAccGrp       : string;
  end;

  TB2102Data = Record      // [2101]계좌별 수신처 관리
     sGrpName  : string;   // Comp별 수신처
     sSecType  : string;   // Comp별 수신처
     sAccNo    : string;
     sSubAccNo : string;
     sSendMtd  : string;
     sNatCode  : string;
     sMediaNo  : string;
     sIntTelYn : string;
  end;

  TB2103Data = Record      // [2103] EMail 수신처 관리
     sGrpName  : string;   // 그룹별 수신처
     sAccNo    : string;   // Acc별 수신처
     sSubAccNo : string;   // Acc별 수신처
     MailFormId : string;  // 메일 서식
  end;

  TB2112Data = Record      // [2112] 하위계좌등록
     sAccNo    : string;   // Acc별 수신처
  end;

  TB2152Data = Record      // [2152] 예탁원 계좌 및 결제 은행 관리
     sTabIndex : Integer;  // Tab Index: 1: 결제 은행 관리 2: 예탁원 계좌 관리
     sKSDAccNo : string;
  end;

  TB2301Data = Record      // [2301]일자별 주식 매매 내역 조회
     sTradeDate : string;
     sPartyComp : string;
     sOffice    : string;
     sGrpName   : string;
     sAccNo     : string;
     sIssueCode : string;
     sTradeType : string;
  end;




  TB2303Data = Record      // [2303]일자별 잔고 내역 조회
     sTradeDate : string;
     sGrpName   : string;
     sAccNo     : string;
  end;

  TB2401Data = Record      // [2401]결제 자료 일괄 생성
     sStlDate   : string;
     sAccNo     : string;
     sIssueCode : string;
     sTradeType : string;
  end;

  TB2402Data = Record      // [2402] 결제자료 입력
     sSettleData  : string;
     sBnkCompCode : string;
     sInvCompCode : string;
     sFundType    : string;
     sTradeType   : string;
     sIssueCode   : string;
  end;

  TB2403Data = Record      // [2403] 미수내역관리
     sStlDate   : string;
     sAccNo     : string;
     sTradeType : string;
     sCstdBank  : string;
     sFxBank    : string;
     sIssueCode : string;
  end;

  TB2601Data = Record      // [2601] 예탁금 이용료 조회
     sBaseDate  : string;
     sAccNo     : string;
  end;

  TB2602Data = Record       // [2602]무상증자내역조회
     sBaseDate      : string;
     sAccNo         : string;
     sIssueCode     : string;
  end;

  TB2603Data = Record       // [2603]유상증자내역조회
     sBaseDate      : string;
     sAccNo         : string;
     sIssueCode     : string;
  end;

  TB2604Data = Record      // [2604] 배당 내역 조회
     sBaseDate  : string;
     sAccNo     : string;
     sIssueCode : string;
  end;
  
  TB2701Data = Record      // [2701] 부계좌 거래분할
     sTradeDate : string;
     sAccNo     : string;
     sIssueCode : string;
     sTranCode  : string;
     sTradeType : string;
  end;

  TB2702Data = Record      // [2702] 부계좌 거래분할 조회
     sTradeDate : string;
     sAccNo     : string;
     sSubAccNo  : string;
     sIssueCode : string;
     sTranCode  : string;
     sTradeType : string;
     sGubun     : string;  // D : 대사 else 조회
  end;

  TB2802Data = Record      // [2802]당일 송신 제외 관리
     iQueryIdx : Integer;  // 전체: 1,  전송: 2,  전송제외: 3,  미지정: 4,
  end;                     // 전송중단: 5 (Clear: 0)

  TB2811Data = Record      // [2811] 회차별 데이터 전송 내역 조회
     sSndDate : string;
     sPartyId : string;
     iFreqNo  : Integer;   // Party별 Seq 회차
     iSentCnt : Integer;   // Party별 실제 회차
     sAccNo   : string;
  end;

  TB2821Data = Record      // [2821] 회차별 데이터 수신 내역 조회
     sRcvDate : string;
     sPartyId : string;
     iFreqNo  : Integer;   // Party별 Seq 회차
     iSentCnt : Integer;   // Party별 실제 회차
  end;



  TB2911Data = Record      // [2911]계좌별 수신처 관리
     sGrpName  : string;   // Comp별 수신처
     sSecType  : string;   // Comp별 수신처
     sAccNo    : string;
     sSubAccNo : string;
     sSendMtd  : string;
     sNatCode  : string;
     sMediaNo  : string;
     sIntTelYn : string;
  end;

  TB2912Data = Record      // [2912] EMail 수신처 관리
     sGrpName  : string;   // 그룹별 수신처
     sAccNo    : string;   // Acc별 수신처
     sSubAccNo : string;   // Acc별 수신처
     MailFormId : string;  // 메일 서식
  end;

  TB2913Data = Record      // [2913]청약 내역 조회
     sTradeDate : string;
     sGrpName   : string;
     sAccNo     : string;
     sIssueCode : string;
  end;

  TB2108Data = Record     // [2108] Client 그룹관리 내역
     sTradeDate : string; // 매매일
     sClientNM  : string; // 그룹명
  end;

  TB2356Data = Record     // [2108] Client 그룹관리 내역
     sTradeDate : string; // 매매일
     sClientNM  : string; // 그룹명
     sAccNo     : string; // 계좌번호,,, 대표분할화면으로 점프용
     sIssueCode : string;
     sTradeType : string;
     sTranCode  : string;
     sBrkShtNo  : string;
  end;

  TB3101Data = Record       // [3101] 계좌등록
     sAccNo    : string;
     sAccGrp   : string;
  end;

  TB3102Data = Record      // [3102] 선물 수신처별/계좌별 수신처 관리
     sGrpName  : string;   // Comp별 수신처
     sSecType  : string;   // Comp별 수신처
     sAccNo    : string;   // Acc별 수신처
     sSubAccNo : string;   // Acc별 수신처
     sSendMtd  : string;
     sNatCode  : string;
     sMediaNo  : string;
     sIntTelYn : string;
  end;

  TB3103Data = Record      // [3103] EMail 수신처 관리
     sGrpName  : string;   // 그룹별 수신처
     sAccNo    : string;   // Acc별 수신처
     sSubAccNo : string;   // Acc별 수신처
     MailFormId : string;  // 메일 서식  
  end;
  

  TB3105Data = Record      // [3105] 선물 수신처별/계좌별 수신처 관리
     sGrpName  : string;   // 그룹별 수신처
     sSecType  : string;   // 그룹별 수신처
     sAccNo    : string;   // Acc별 수신처
     sSubAccNo : string;   // Acc별 수신처
     sSendMtd  : string;
     sNatCode  : string;
     sMediaNo  : string;
     sIntTelYn : string;
  end;


  TB3301Data = Record       // [3301] 예탁현황
     sTradeDate   : string;
     sGrpName    : string;
  end;

  TB3302Data = Record       // [3302] 위탁자잔고 내역
     sTradeDate   : string;
     sAccNo    : string;
  end;

  TB3303Data = Record       // [3303]매매내역 및 예탁현황
     sTradedate    : string;
     sAccNo        : string;
//     sApplyType    : Integer; // 1: 정산마감전, 2: 정산마감후, 3: 정산반영후
  end;

  TB3304Data = Record      // [3308] 일자별 선물/옵션매매 내역 조회
     sTradeDate   : string;
     sInvCompCode : string;
     sGrpName     : string;
     sAccNo       : string;
     sIssueCode   : string;
     sTradeType   : string;
  end;

  TB3306Data = Record       // [3306] 예탁금이용료
     sBaseDate    : string;
     sGrpName : string;
  end;

  TB3307Data = Record       // [3307] 월말 잔고 현황 조회
     sBaseDate    : string;
     sAccNo       : string;
  end;

  TB3308Data = Record       // [3308] 옵션구간이론가 조회
     sTradeDate    : string;
     sIssueType    : string;
     sDepositType  : string;
     sInvType      : string;
  end;

  TB3309Data = Record       // [3309] 입출금 통지서
     sTradeDate   : string;
     sGrpName : string;
  end;

  TB3401Data = Record      // [3401] 일자별 프로그램매매 내역 조회
     sTradeDate   : string;
     sInvCompCode : string;
     sGrpName     : string;
     sAccNo       : string;
     sIssueCode   : string;
     sTradeType   : string;
  end;

  TB3802Data = Record      // [3802]당일 송신 제외 관리
     iQueryIdx : Integer;  // 전체: 1,  등록: 2,  미등록: 3
     iPageIdx  : Integer;  // 0 : 매매내역    1 : 대용잔고      2 : 예탁현황
                           // 3 : 입출금통지  4 : 예탁금이용료  5 : 프로그램매매
                           // 6 : 월말잔고
  end;
  
  TB9202Data = Record      // [9202] 자사 은행 코드 등록
     sBankName : string;
  end;

  //=== Investor Form Interface Data Type
  TI2101Data = Record      // [2101]계좌등록 및 관리
     sCompCode : string;
     sAccNo    : string;
  end;

  TI2102Data = Record      // [2102]계좌별 수신처 관리
     sCompCode : string;
     sSendMtd  : string;
     sMediaNo  : string;
  end;

  TI2103Data = Record
     sFundCode : string;
  end;

  TI2401Data = Record       // [2401] 운용 지시 내역 조회
     sStlDate  : string;
     sCompCode : string;
     sFundCode : string;
  end;

  TI2701Data = Record
     sTradeDate : string;   // [2701] 주식 배정 입력
     sBrkCode   : string;
     sIssueCode : string;
     sTranCode  : string;
     sTradeType : string;
     sFundType  : string;
     sTeamCode  : string;
     sTrdTotQty : string;
     sSplit     : Integer;
  end;

  TI2802Data = Record      // [2802] 당일 전송 제외 관리
     iQueryIdx : Integer;  // 전체: 1,  전송: 2,  전송제외: 3,  미지정: 4,
  end;                     // 당일제외: 5,  전송중단: 6 (Clear: 0)

  TI2811Data = Record      // [2811] 회차별 데이터 전송 내역 조회
     sSndDate : string;
     sPartyId : string;
     iFreqNo  : Integer;   // Party별 Seq 회차
     iSentCnt : Integer;   // Party별 실제 회차
     sAccNo   : string;
  end;

  TI2821Data = Record      // [2821] 회차별 데이터 수신 내역 조회
     sRcvDate : string;
     sPartyId : string;
     iFreqNo  : Integer;   // Party별 Seq 회차
     iSentCnt : Integer;   // Party별 실제 회차
  end;

  TI9101Data = Record      // [9101] 사용자 등록
     sDeptCode : string;
     sUserID   : string;
  end;

  TI9202Data = Record      // [9202] 자사 은행 코드 등록
     sBankName : string;
  end;

  //=== 수수료율 정보
  TCommRate = record
     Code  : string;      // 수수료 Code
     ComRate   : String;  // 수수료율
     ComName   : string;  // 코드설명
  end;
  pTCommRate = ^TCommRate;

var

  gvExportPDF      : string;         // 송/수신화면 Export

  gvMainFrame      : TForm;          // 해당 PGM 의 MainFrame
  gvDRSvrConnFlag  : boolean;        // DR Server와의 접속 상태를 나타내는 Flag
  gvErrorNo        : Integer;        // Error No
  gvExtMsg         : string;         // Extended Message
  gvPrinter        : TSNPrinter;     // 인쇄를 위한 환경 설정
  gvOldPrinter     : TSNPrinter;     // PDF 생성시 기존 SettleNet Default Printer를 백업해놈 @@20041103
  gvStampSignFlag  : boolean;        // Trade 서명을 할지 여부
  gvDirDefault     : string;         // ex) C:\SettleNet\Client\
  gvDirCfg         : string;         // ex) C:\SettleNet\Client\Cfg\
  gvDirTemp        : string;         // ex) C:\SettleNet\Client\Temp\
  gvDirResource    : string;         // ex) C:\SettleNet\Client\Resource\
  gvDirImport      : string;         // ex) c:\SettleNet\Client\Import\ (사용자정의)
  gvDirExport      : string;         // ex) c:\SettleNet\Client\Export\ (사용자정의)
  gvDirRpt         : string;         // ex) c:\SettleNet\Client\Rpt\
  gvDirUserData    : string;         // ex) c:\SettleNet\Client\UserData\
  gvDirKsdAcc      : string;         // 예탁원 자료 생성을 위한 Directory
  gvDBServerName   : string;
  gvDBUserID       : string;
  gvDBPassWd       : string;
  gvDBName         : string;
  gvDefaultDB      : string;
  gvSplitMtd       : string;
  gvPartyUserID    : string;
  gvMyPartyID      : string;
  gvCurSecType     : string;         // 현재 사용중 업무
  gvMenuList       : TList;          // 동적 Menu 생성을 위한 정보 List
  gvUseTrCodeList  : TStringList;    // 사용가능 TrCodeList
  gvUsrToolBarList : TList;          // 사용자 ToolBar 생성을 위한 정보 List
  gvUserToolBtn    : Array [0..gcMAX_USER_TOOLBTN -1] of TDRToolbarBtn;
  gvUseDecLine     : boolean;
  gvDirRptUseYN    : string;         // Client PC의 Rpt file 사용여부
                                     // N이면 서버에서 내려받아 Rpt사용

//  gvUATSvrYN       : string;         //UAT Server에 접속했는지 Production인지 여부
  gvUserSvrIP      : string;
  gvUserSvrPort    : Integer;
  gvUserSvrTimeOut : Integer;

  gvPassEnrpYN  : string;
  gvUserEnrpYN  : string;           // Password암호화 Hash 알고리즘사용

  gvOprUsrNo    : string;           // 사용자 ID
  gvOprPassWd   : string;           // 사용자 Password
  gvOprUsrName  : string;           // 사용자명
  gvMailOprName : string;           // Mail 전송자명
  gvRtnMailAddr : string;           // Return Main Address (사용자 MailAddress)
  gvMailTail    : string;           // Mail 꼬리말 (서명)

  gvCurDate     : string;            // Server의 일자
  gvTermNo      : string;
  gvRoleCode    : string;            // 소속 RoleCode
  gvCompCode    : string;            // 소속 회사코드
  gvCompName    : string;            // 소속 회사명
  gvDeptCode    : string;            // 소속 부서코드
  gvDeptName    : string;            // 소속 부서명

  gvSRMgrEdited : boolean;           // 송수신 Manager에서의 Editting 여부
  gvSendMailFlag : boolean;          // 해당증권사가 멜 전송 가능한지 여부

  gvMainFrameHandle : Cardinal;
  gvLoginFormHandle : Cardinal;
  gvDataBuff        : string;
  gvPreviewPercent  : Integer;                 // Report Preview 시 배율

  gvLogFile : TextFile;                        // Log File
  gvLogFlag : boolean;
  gvLogPath : string;                          // Log File Directory
  gvLogCriticalSection: TRtlCriticalSection;   // Log File을 위한 CriticalSection

  gvRealLogYN : string;         // Real Data Monitoring시 Log기록 사용여부
  gvRealLogPopupStopYN : string;     // Real Data Monitoring PopUp 정지 여부.

  gvImportingFileName : string; //FTP창에서 DownLoad한 것을 Import창으로 Setting.
  //=== Form Interface Variable
  // Broker - 주식
  gvB2101Data    : TB2101Data;     // 2201, 2401 -> 2101 Call
  gvB2102Data    : TB2102Data;     // 2101, 2801, 2802 -> 2102 Call 위한 계좌번호
  gvB2103Data    : TB2103Data;     // 2801_SND -> 2103 Call 위한 Data
  gvB2112Data    : TB2112Data;

  gvB2152Data    : TB2152Data;     // 2453 -> 2152 Call 위한 Data
  gvB2301Data    : TB2301Data;     // 2801_SEND, 2802 -> 2301 Call 위한 Data
  gvB2303Data    : TB2303Data;     // 2801_SEND -> 2303 Call 위한 Data
  gvB2401Data    : TB2401Data;     // 2453 -> 2401 Call 위한 Data
  gvB2402Data    : TB2402Data;     // 2453 -> 2402 Call 위한 Data
  gvB2403Data    : TB2403Data;     // 2453 -> 2403 Call 위한 Data
  gvB2601Data    : TB2601Data;     // 2831 -> 2601 Call 위한 Data
  gvB2602Data    : TB2602Data;     // 2831 -> 2602 Call 위한 Data
  gvB2603Data    : TB2603Data;     // 2831 -> 2603 Call 위한 Data
  gvB2604Data    : TB2604Data;     // 2831 -> 2604 Call 위한 Data
  gvB2701Data    : TB2701Data;     // 2702 -> 2701 Call 위한 Data
  gvB2702Data    : TB2702Data;     // 2703 -> 2702 Call 위한 Data
  gvB2802Data    : TB2802Data;     // 2801 -> 2802 Call 위한 Data
  gvB2811Data    : TB2811Data;     // 2802 -> 2811 Call 위한 Data
  gvB2812Date    : string;         // 2801 -> 2812 Call 위한 일자
  gvB2821Data    : TB2821Data;     // 2801 -> 2821 Call 위한 Data

  gvB2911Data    : TB2911Data;     //2916_SND -> 2911 Call 위한 Data
  gvB2912Data    : TB2912Data;     //2916_SND -> 2911 Call 위한 Data
  gvB2913Data    : TB2913Data;     // 2916_SND -> 2913 Call 위한 Data


  // Broker - 선물
  gvB3101Data    : TB3101Data;     // 3201, 3401 -> 3101 Call
  gvB3102Data    : TB3102Data;     // 3801_SND -> 3102 Call 위한 Data
  gvB3103Data    : TB3103Data;     // 3801_SND -> 3103 Call 위한 Data
  gvB3105Data    : TB3105Data;     // 3801_SND -> 3105 Call 위한 Data
  gvB3301Data    : TB3301Data;     // 3801_SND -> 3301 Call 위한 Data
  gvB3302Data    : TB3302Data;     // 3801_SND -> 3302 Call 위한 Data
  gvB3303Data    : TB3303Data;     // 3801_SND -> 3303 Call 위한 Data
  gvB3304Data    : TB3304Data;     // 3801_SND -> 3308 Call 위한 Data

  gvB3306Data    : TB3306Data;     // 3801_SND -> 3306 Call 위한 Data
  gvB3307Data    : TB3307Data;     // 3801_SND -> 3307 Call 위한 Data
  gvB3308Data    : TB3308Data;     // 3801_SND -> 3308 Call 위한 Data
  gvB3309Data    : TB3309Data;     // 3801_SND -> 3309 Call 위한 Data
  gvB3401Data    : TB3401Data;     // 3801_SND -> 3401 Call 위한 Data
  gvB3802Data    : TB3802Data;     // 3801 -> 3802 Call 위한 Data
  gvB9101Data    : TI9101Data;     //9101_SND -> SCCPasswd2 Call 위한 Data
  gvB9202Data    : TB9202Data;     // 2401 -> 9202 Call 위한 Data
  
  // Investor
  gvI2101Data     : TI2101Data;    //
  gvI2102Data     : TI2102Data;    // 2801 -> 2102 Call 위한 계좌번호
  gvI2103data     : TI2103Data;    // 2211 -> 2103 Call 위한 FundCode
  gvI2401Data     : TI2401Data;    // 2801 -> 2401 Call 위한 Data
  gvI2501Date     : string;        // 2102 -> 2103 Call 위한 일자
  gvI2701Data     : TI2701Data;    // ?
  gvI2802Data     : TI2802Data;    // 2801 -> 2802 Call 위한 Data
  gvI2811Data     : TI2811Data;    // 2802 -> 2811 Call 위한 Data
  gvI2821Data     : TI2821Data;    // 2801 -> 2821 Call 위한 Data
  gvI9202Data     : TI9202Data;

  //----------------------------------------------------------------------------
  // Code 관련 List
  //----------------------------------------------------------------------------
  //=== 공통
  gvRoleCodeList : TList;     // Role 코드
  gvSecTypeList  : TList;     // 유가증권종류(주식, 채권, 선물..)
  gvMktTypeList  : TList;     // 장구분(장내, 장외..)
  gvTranMtdList  : TList;     // 매매방법(정상, 단주, 시간외, 프로그램매매, 자전..)
  gvComTypeList  : TList;     // 매체구분(유선, Internet, HTS, ARS..)

  gvPartyIDList  : TList;     // Party ID
  gvSendMtdList  : TList;     // 전송방법(Data, Fax, E-Mail, Telex..)
  gvFundTypeList : TList;     // 펀드종류
  gvTranCodeList : TList;     // Tran 코드
  gvDeptCodeList : TList;     // 부서코드
  gvReportIDList : TList;     // Report ID
  gvCompCodeList : TList;     // 자사회사코드

  //=== Investor
  gvTeamCodeList : TList;     // 팀코드

  //----------------------------------------------------------------------------
  // 종목 관련 List
  //----------------------------------------------------------------------------
  gvEIssueList   : TList;     // 주식종목코드
  gvFIssueList   : TList;     // 선물종목코드

  gvUserProfile : string;
  gvCurrentUserTempDir : string;

  gvSendUseYN : string; //전송사용여부

  //AccNoSearch화면에서 검색결과
  gvSearchOutAccNo    : string; //unformatted
  gvSearchOutSubAccNo : string; //unformatted
  gvSearchOutAccName  : string;

  //송수신 전송대상 갱신시 OK찍기여부
  gvSendOKCheckYN : string;

  //Net Resource info (Client INI에 Setting)
  //Guest계정이 Open되지 않은 Site에 Network Drive잡았다 떼면 접속됨.
  //MDAC 2.6이상은 사용안함.
  gvNRW : string;
  gvNRWID : string;
  gvNRWPW : string;
  gvNetworkDrive : string;

  //SUDEFLT_TBL에 등록된 DR_USER_ID, 회사구분에 사용된다.
  gvDRUserID : string;

  //Rpt Query를 Stored Procedure로 사용할 지 여부
  //서버 성능이 나쁜 곳은 SP로 하지 말 것 (삼성같은 곳)
  //씨티같이 서버는 좋은데 기타 여건상 Query가 늦은 곳에서 사용
  gvRptQueryUseSPYN : string ;

  //SCPRVER_TBL을 사용하여 Version Upgrade를 할지 말지 여부
  //exe 및 dll 자동 Upload & Download
  gvVersionUpgrade : boolean;

  //Etrade 일본주식 여부
  gvETradeJapanYN : string;

  //02 국제부를 법인부 확장으로 사용여부
  gv02DeptDomYN : string;

  gvB2107Data    : TB2101Data;     //
  gvB2106Data    : TB2108Data;     // 2108 -> 2106 Call 위한 Data
  gvB2109Data    : TB2108Data;     // 2108, 2102, 2103 -> 2109 Call 위한 Data
  gvB2359Data    : TB2108Data;     // 2360 -> 2359 Call 위한 Data

  gvB2356Data    : TB2356Data;     // 2108, CTM -> 2356 Call 위한 Data

  //HostCall 사용여부, Default Y, 한국증권(CICS) N, 하나대투(HostGW) Y
  gvHostCallUseYN : string;
  
  //HostGateWay 사용여부 Default N, 한국증권 N, 하나대투 Y
  gvHostGWUseYN   : string;

  gvOprEmpID : string; //사번

  //ADMIN 사용자 여부
  //TF01,02.. User 나 Data01,02 User 만 "마감해제"같은 메뉴를  볼수 있게 하기 위해
  gvTFAdminYN : string;

  //OASYS Delivery Name .. 아마 Alert 사용시에 쓰이는 듯
  //한국증권은 DONGKOR이고 TestBed는 아직 모름
  gvOASYSDeliveryName : string;

  //데이터로드 or UAT환경에서 눈깔접속아닌 2-Tier 접속 여부
  gv2TierLoginYN : string;

  gvLocalIP : string;

  //Crystal Report에서 OS의 Default Printer만 사용할 지 여부 2007.05.23
  //Crystal 10 Component Bug 때문. Default Printer 사용시 괜찮아지는 곳이 있어서
  //프린터가 Fine Printer등 특이한 놈이 가로 미리보기/인쇄시 세로로 나타나는 문제 해결위함.
  gvDefaultPrinterUseYN : string;

//  gvOASYSXXX : string;// OASYS 사용이면 Y

  // PDF Engine 사용여부
  gvPDFEngineUseYn : string;

  // Fax Report 파일 형식 (RPT, PDF)
  gvFaxReportFileType : string;

  // Fax Report 페이지방향 (1: 세로, 2: 가로)
  gvFaxReportDirection : string;

  // Auto Login 대기
  bReStartWait : Boolean;

  // 부서별 담당자 정보
  gvDrMgrName : string;
  gvDrPosition : string;
  gvDrMailAddr : string;
  gvDrPhone : string;
  gvDrCellPhone : string;

  // 부서별 데이터로드 홈페이지 정보
  gvDRHP_URL : String;
  gvDRHP_ID : String;
  gvDRHP_PW : String;

implementation

end.
