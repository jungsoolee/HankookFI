{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R+,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R+,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R+,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
//==============================================================================
//   [LMS] 2001/06/02
//     UPDATE : [JYKIM] 2001/12/27
//==============================================================================
//!!! EMail 선택시 책임자, 계좌종류 선택되지 않도록 처리
//!!! AUTHORITY 관련 처리 - !!!AAA(gf_EnableBtn)
//!!! MODIFY
// [jykim] 일단 보류사항
//        ㉠ 그룹일 경우 text는 없는 걸로 간주한다.
//           :구현시 레포트 Lib.pas 도 추가해야 한다.
// FThreadHoldFlag 중요.
//        onrcv.. 를 Realtime Q를 사용하지 않고 별도 thread가 2tier 쿼리함.
//        그전에도 Thread-safe처리 않됨. 전송,갱신시만 락을 걸어줌.
//        나머지 모든 event에 락을 걸수 없지 않는가.... 지켜보자.

//==============================================================================
// [P.H.S] 2006.08.17
// PDF Export 추가 (Rpt & TXT)
// fax 대상 PDF파일명 : gvDirExport + 거래일(YYYYMMDD)_계좌번호(ID) or 그룹명_FaxNumber_서식명
// fax 전송 PDF파일명 : gvDirExport + 전송일(YYYYMMDD)_계좌번호(ID) or 그룹명_FaxNumber_서식명
//==============================================================================

//==============================================================================
// [P.H.S] 2006.11.22
// 국내쿼리 국제쿼리로 통합
//==============================================================================

unit SCFH8801_SND;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  SCCSRMgrForm_SND, Buttons, DRAdditional, StdCtrls, DRStandard, Grids,
  DRStringgrid, ExtCtrls, DRColorTab, ComCtrls, DRWin32, DRSpecial, Menus,
  Db, ADODB, SCCCmuGlobal, SCCGlobalType, FileCtrl, ShellAPI, OleServer,
  DRDialogs, Forms, DRCodeControl, TlHelp32, UCrpe32, Mask, DrStringPrintU, IniFiles;

type
  //=== Fax/Tlx 전송 위한 PS데이터
  TPSStrList = record
    PSStringList  : TStringList;
    L_PSStringList: TStringList;
    R_PSStringList: TStringList;
  end;

  //=== Attach File Info
  TFIAttFile = record
     FileName    : string;
     AttSeqNo    : Integer;
  end;
  pTFIAttFile = ^TFIAttFile;

  // [L.J.S] - 전송대상 구조체(FAX, E-mail, 미등록)
  TSnd = record
    SendType       : string;      // 전송구분 - FAX: F, E-mail: E, 미등록: N
    JobSeq         : double;     // 보고서 Job Sequence
    JobDate        : string;      // 보고서 생성 일
    EmpNo          : string;      // 사번
    EmpName        : string;      // 사명
    JobTime        : string;      // 생성시간
    FullAccNo      : string;      // 계좌번호 - 상품코드 - 잔고번호
    AccNo          : string;      // 계좌번호
    PrdNo          : string;      // 상품코드
    BlcNo          : string;      // 잔고번호
    AccName        : string;      // 계좌명
    MediaName      : string;      // 수신처 명
    MediaNo        : string;      // 수신처 번호
    MailName       : TStringList; // Mail 수신처 명
    MailAddr       : TStringList; // Mail 주소
    FullMailName   : string;      // 이어 붙인 Mail 수신처 명
    FullMailAddr   : string;      // 이어 붙인 Mail 주소
    ReportCode     : string;      // 전문 ID (3자리)
    ReportID       : string;      // SettleNet 보고서 관리 ID (7자리)
    ReportName     : string;      // 보고서 명
    PSStringList   : TStringList; // 추신 추가시 해당 내역 저장
    PSStringAll    : boolean;     // PS 전체입력
    AttFileList    : TList;       // Attach File List
    SubjectData    : string;      // Mail 제목
    MailBodyData   : string;      // Mail 본문
    ReportIdx      : Integer;     // 전송될 동일 레포트 Idx
    RIdxSeqNo      : Integer;     // 전송된 동일 레포트 Idx
    StartTime      : string;      // 전송 시작 시간
    EndTime        : string;      // 전송 완료 시간
    SendDate       : string;      // 최종 전송 일자
    ExceptFlag     : boolean;     // 전송 제외 여부
    SendFlag       : boolean;     // 전송 여부
    CancFlag       : boolean;     // 전송 후 취소 여부
    ExportFlag     : boolean;     // EXPORT 여부
    CurTotSeqNo    : Integer;     // CurTotSeqNo
    ErrMsg         : string;      // Error Message
    Selected       : boolean;     // 전송 선택 여부
    GridRowIdx     : Integer;     // Display되는 Grid의 Row Index
  end;
  pTSnd = ^TSnd;

  // [L.J.S] - 당일송신확인 구조체(FAX, E-mail)
  TSnt = record
    SendType         : string;        // FAX or E-mail                           
    JobSeq           : Integer;       // 보고서 시퀀스                           
    EmpNo            : string;        // 사번                                    
    EmpName          : string;        // 사명                                    
    FullAccNo        : string;        // 계좌번호 - 상품코드 - 잔고번호          
    AccNo            : string;        // 계좌번호                                
    PrdNo            : string;        // 삼품코드                                
    BlcNo            : string;        // 잔고번호                                
    AccName          : string;        // 계좌명                                  
    MediaName        : string;        // 수신처 명                               
    MediaNo          : string;        // 수신처 번호                             
    MailName         : TStringList;   // Mail 수신처 명                          
    MailAddr         : TStringList;   // Mail 주소                               
    FullMailName     : string;        // 이어 붙인 Mail 수신처 명                
    FullMailAddr     : string;        // 이어 붙인 Mail 주소                     
    ReportCode       : string;        // 보고서 전문 ID(3자리)                   
    ReportID         : string;        // SettleNet 보고서 관리 ID(7자리)         
    ReportName       : string;        // 보고서 명                               
    AttFileList      : TList;         // Attach File List                        
    SubjectData      : string;        // Mail 제목                               
    MailBodyData     : string;        // Mail 본문                               
    StartTime        : string;        // 전송 시작 시간                          
    EndTime          : string;        // 전송 완료 시간                          
    SendDate         : string;        // 최종 전송 일자                          
    Direction        : string;        // 보고서 방향(가로, 세로)                 
    DiffTime         : Integer;       // EndTime - StartTime                     
    TotalPageCnt     : Integer;       // 전체 페이지                             
    SendPageCnt      : Integer;       // 전송중인 페이지                         
    BusyResndCnt     : Integer;       // 재전송 회수                             
    RSPFlag          : Integer;       // 전송 상태                               
    ExportFlag       : boolean;       // EXPORT여부                              
    CurTotSeqNo      : Integer;       // CurTotSeqNo                             
    Selected         : boolean;       // 선택 여부                               
    GridRowIdx       : Integer;       // Display되는 Grid의 Row Index            
    ErrCode          : string;        // 에러 코드                               
    ErrMsg           : string;        // 에러 메시지                             
    ExtMsg           : string;        // 이메일 보고서 만들 때 넘기는 메시지 변수
    OprID            : string;        // 조작자 정보                             
    OprTime          : string;        // 조작 시간                               
  end;
  pTSnt = ^TSnt;

  //=== Fax/Tlx 전송 위한 데이터
  TESndFaxTlx = record
    AccGrpType   : string;       // 그룹별/계좌별 구분
    AccNo        : string;       // 계좌번호
    SubAccNo     : string;       // 부계좌번호
    ClientGrpName: string;       // Client 그룹일때, 그룹명
    InsertAmd    : Boolean;      // AMENDED 추가여부
    IssueExcept  : Boolean;      // 종목편집 여부
    AccName      : string;       // 계좌명
    ClientMgrName: string;       // 기관별 담당자           -법인에서만씀
    ClientTelNo  : string;       // 기관별 담당자 전화번호  -법인에서만씀
    ClientFaxNo  : string;       // 기관별 담당자 팩스번호  -법인에서만씀
    AccNoList    : TStringList;  // 계좌 List
    AccId        : string;       // 계좌 Identification
    SendMtd      : string;       // Fax/Tlx
    RcvCompKor   : string;       // 수신처
    NatCode      : string;       // 국가코드
    MediaNo      : string;       // 번호
    IntTelYn     : string;       // 국제/국내 여부
    ReportID     : string;       // Report Id
    ReportName   : string;       // Report명
    BuyExecAmt   : double;       // 매수약정대금
    SellExecAmt  : double;       // 매도약정대금
    BuyComm      : double;       // 매수수수료
    SellComm     : double;       // 매도수수료
    TotTax       : double;       // 제세금
    NetAmt       : double;       // 결제금액
    MgrName      : string;       // 관리자명
    PgmAcYN      : string;       // 프로그램매매 계좌 여부
    AccAttr      : string;       // 계좌 속성
    //PSStringList : TStringList;  // 추신 추가시 해당 내역 저장
    PSList       : TPSStrList;
    SendSeq      : Integer;      // 수신처Sequ
    EditFileName : string;       // Edit된 File Name
    StartTime    : string;       // 최초전송 시작시간
    SendFlag     : boolean;      // 전송 여부
    CancFlag     : boolean;      // 전송 후 취소 여부
    DpSplit      : string;       // 미분할 대표계좌 여부
    CurTotSeqNo  : Integer;      // CurTotSeqNo
    ErrMsg       : string;       // Error Message
    Selected     : boolean;      // 전송 선택 여부
    GridRowIdx   : Integer;      // Display되는 Grid의 Row Index
    ReportIdx    : Integer;      // 전송될 동일 레포트 Idx                       
    RIdxSeqNo    : Integer;      // 전송된 동일 레포트 Idx
    FundCode     : string ;      //@@ 펀드
    FundName     : string ;      //@@ 펀드명
    SettleMemo   : String;       // 결제메모
    SubDeptName : string;
  end;
  pTESndFaxTlx = ^TESndFaxTlx;

  //=== Fax/Tlx 전송 확인 데이터
  TESntFaxTlx = record
    AccGrpType   : string;       // 그룹별/계좌별 구분
    AccNo        : string;       // 계좌번호
    SubAccNo     : string;       // 부계좌번호
    ClientGrpName: string;       // Client 그룹일때, 그룹명
    AccName      : string;       // 계좌명
    AccId        : string;       // 계좌 Identification
    FaxTlxGbn    : string;       // Fax/Tlx 구분
    RcvCompKor   : string;       // 수신처
    NatCode      : string;       // 국가코드
    MediaNo      : string;       // 번호
    MgrName      : string;       // 관리자명
    PgmAcYN      : string;       // 프로그램매매 계좌 여부
    AccAttr      : string;       // 계좌 속성
    FundCode     : string ;      //@@ 펀드
    FundName     : string ;      //@@ 펀드명
    DisplayAll   : boolean;      // 전회차 내역 보여줄지 여부
    SubDeptName  : string;
    FreqList     : TList;        // 회차별 List
  end;
  pTESntFaxTlx = ^TESntFaxTlx;

  //=== Fax/Tlx 전송 확인 회차 정보
  TEFreqFaxTlx = record
    FreqNo       : Integer;      // 회차
    CurTotSeqNo  : Integer;      // CurTotSeqNo
    ReportType   : string;       // Report Type
    Direction    : string;       // Direction
    TxtUnitInfo  : string;       // Text File 구분 정보
    SendTime     : string;       // 전송시작시간
    SentTime     : string;       // 전송완료시간
    DiffTime     : Integer;      // 전송시간
    TotalPageCnt : Integer;      // 전체Page Count
    SendPageCnt  : Integer;      // 전송중 Page Count
    BusyResndCnt : Integer;      // 재전송 Count
    RSPFlag      : Integer;      // 전송 상태
    ErrCode      : string;       // Error Code
    ErrMsg       : string;       // Error Message
    ExtMsg       : string;       // Extended Message
    OprId        : string;       // 조작자
    OprTime      : string;       // 조작자
    LastFlag     : boolean;      // 마지막 회차 여부
    Selected     : boolean;      // 선택 여부
    GridRowIdx   : Integer;      // Display되는 Grid의 Row Index
  end;
  pTEFreqFaxTlx = ^TEFreqFaxTlx;

  TForm_SCFH8801_SND = class(TForm_SCF_SND)
    ADOQuery_Snd: TADOQuery;
    DRPopupMenu_SndFax: TDRPopupMenu;
    PopupSndFax1: TMenuItem;
    PopupSndFax2: TMenuItem;
    N1: TMenuItem;
    PopupSndFax3: TMenuItem;
    PopupSndFax4: TMenuItem;
    PopupSndFaxTlx33: TMenuItem;
    N4: TMenuItem;
    PopupSndFax7: TMenuItem;
    PopupSndFax8: TMenuItem;
    N2: TMenuItem;
    PopupSndFax10: TMenuItem;
    ADOQuery_Snt: TADOQuery;
    DRPopupMenu_SntFax: TDRPopupMenu;
    PopupSntFaxTlx1: TMenuItem;
    PopupSntFaxTlx2: TMenuItem;
    PopupSntFaxTlx5: TMenuItem;
    MenuItem2: TMenuItem;
    PopupSntFaxTlx4: TMenuItem;
    ADOQuery_temp: TADOQuery;
    DRPopupMenu_SntMail: TDRPopupMenu;
    PopupSntMail1: TMenuItem;
    PopupSntMail2: TMenuItem;
    PopupSntMail3: TMenuItem;
    ADODataSet_Snt: TADODataSet;
    DRSpeedBtn_SntFaxTlxRefresh: TDRSpeedButton;
    DRSpeedBtn_SndFaxTlxRefresh: TDRSpeedButton;
    DRSpeedBtn_SntMailRefresh: TDRSpeedButton;
    DRSpeedBtn_SndMailRefresh: TDRSpeedButton;
    PopupSndFax9: TMenuItem;
    DRSpeedBtn_SndFaxTlxExport: TDRSpeedButton;
    DRSpeedBtn_SndFaxTlxPDFExport: TDRSpeedButton;
    DRSpeedBtn_SntFaxTlxPDFExport: TDRSpeedButton;
    DRSpeedBtn_SndMailPDFExport: TDRSpeedButton;
    DRSpeedBtn_SntMailPDFExport: TDRSpeedButton;
    DRButton_DRLast: TDRButton;
    PopupSndFax5: TMenuItem;
    DRBitBtn5: TDRBitBtn;
    DrStringPrint1: TDrStringPrint;
    PopupSndFax6: TMenuItem;
    DRSpeedButton_SndFax: TDRSpeedButton;
    DRSpeedButton_SntFax: TDRSpeedButton;
    DRSpeedButton_SndMail: TDRSpeedButton;
    DRSpeedButton_SntMail: TDRSpeedButton;
    DRButton_DRNext: TDRButton;
    DRButton_DRPrior: TDRButton;
    DRPopupMenu_SndMail: TDRPopupMenu;
    PopupSndMail1: TMenuItem;
    PopupSndMail2: TMenuItem;
    N5: TMenuItem;
    PopupSndMail11: TMenuItem;
    PopupSndMail12: TMenuItem;
    MenuItem1: TMenuItem;
    PopupSndMail3: TMenuItem;
    PopupSndMail4: TMenuItem;
    MenuItem5: TMenuItem;
    DRLabel5: TDRLabel;
    DRMaskEdit_Date1: TDRMaskEdit;
    DRPanel6: TDRPanel;
    DRPanel_TotPanel: TDRPanel;
    DRPanel8: TDRPanel;
    DRSplitter_Tot: TDRSplitter;
    DRPanel_Snt: TDRPanel;
    DRStrGrid_Snt: TDRStringGrid;
    DRPanel_Snd: TDRPanel;
    DRImage1: TDRImage;
    DRImage2: TDRImage;
    DRPanel_SndTitle: TDRPanel;
    DRLabel_Snd: TDRLabel;
    DRSpeedButton_SndExport: TDRSpeedButton;
    DRSpeedButton_SndRefresh: TDRSpeedButton;
    DRSpeedButton_SndPrint: TDRSpeedButton;
    DRRadioButton_SndType_ALL: TDRRadioButton;
    DRRadioButton_SndType_FAX: TDRRadioButton;
    DRRadioButton_SndType_Email: TDRRadioButton;
    DRCheckBox_NotSnd: TDRCheckBox;
    DRRadioButton_SndType_None: TDRRadioButton;
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
    DRStrGrid_Snd: TDRStringGrid;
    DRUserDblCodeCombo_Acc: TDRUserDblCodeCombo;
    DRLabel3: TDRLabel;
    DRUserDblCodeCombo_Emp: TDRUserDblCodeCombo;
    DRLabel6: TDRLabel;
    DRMaskEdit_Time: TDRMaskEdit;
    DRLabel7: TDRLabel;
    DRLabel4: TDRLabel;
    DRBitBtn_Dest: TDRBitBtn;
    DRBitBtn_ImportRpt: TDRBitBtn;
    DRBitBtn_ImportALL: TDRBitBtn;
    PopupSndMail5: TMenuItem;
    PopupSndMail6: TMenuItem;
    N3: TMenuItem;
    PopupSndMail7: TMenuItem;
    PopupSndMail8: TMenuItem;
    PopupSndMail9: TMenuItem;
    N8: TMenuItem;
    PopupSndMail10: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    DRPanel_SntTitle: TDRPanel;
    DRLabel_Snt: TDRLabel;
    DRSpeedButton_Refresh: TDRSpeedButton;
    DRSpeedButton_Print: TDRSpeedButton;
    DRSpeedButton_SntExport: TDRSpeedButton;
    DRPanel11: TDRPanel;
    DRRadioButton_Prc_Sending: TDRRadioButton;
    DRRadioButton_Prc_Error: TDRRadioButton;
    DRRadioButton_Prc_ALL: TDRRadioButton;
    DRRadioButton_SntType_FAX: TDRRadioButton;
    DRRadioButton_SntType_Email: TDRRadioButton;
    DRRadioButton_SntType_ALL: TDRRadioButton;
    DRComboBox_SndColOrder: TDRComboBox;
    DRLabel1: TDRLabel;
    procedure ClearScreen;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DRBitBtn4Click(Sender: TObject);
    procedure DRBitBtn3Click(Sender: TObject);
    procedure DRBitBtn2Click(Sender: TObject);
    procedure ProcPanel_BitBtn_ConfirmClick(Sender: TObject);

    // [L.J.S] 한투 금상 함수 정의
    procedure DefSetSndStrGrid;
    procedure DefSetSntStrGrid;

    procedure ClearSndList;
    procedure ClearSnTList;

    function fn_MakeEmpCombo: Boolean;
    function fn_MakeAccCombo: Boolean;
    function fn_MakeColOrdCombo: Boolean;

    function fn_QueryToSndList: Boolean;
    function fn_QueryToSntList: Boolean;

    procedure DisplaySndList(DefSelectFlag: boolean);
    procedure DisplaySndItem(pSndItem: pTSnd);
    procedure DisplaySntList(DefSelectFlag: boolean);
    procedure DisplaySntItem(pSntItem: pTSnt);
    procedure ChangeViewType(pViewType: Integer; pTotPanel, pSndPanel, pSntPanel: TPanel;
                                 pSplitter: TSplitter);

    function fn_CreateMailFile(SndItem: pTSnd; CallFlag: boolean; JobDate: string): string;
    function fn_CreateEMailFile(pEMailFormId, pDirName, pDeptCode, pTradeDate: string;
                                  pGrpName: string; var FileName: string; CreateFlag: boolean): boolean;

    function fn_GetSndListIdx(pGridRowIdx: Integer): Integer;
    procedure SetColOpt;



    //=== Send Fax/Tlx
    procedure SetDefaultPSStringList(SrcItem: pTESndFaxTlx);
    procedure AddSntFaxTlxList(SndItem: pTESndFaxTlx; pTotPageCnt: Integer; pTxtUnitInfo: string);
    procedure SetSntFaxTlxListCanc(pCurTotSeqNo: Integer);
    function  SendFaxTlx(SndItemIdxList: TStringList): boolean;
    function  GetSndFaxTlxListIdx(pGridRowIdx: Integer): Integer;
    procedure SameAccCopyEditData(SrcItem: pTESndFaxTlx);

    //=== Sent Fax/Tlx
    function  RetrySendFaxTlx(SntItem: pTESntFaxTlx; FreqItem: pTEFreqFaxTlx): boolean;
    function  GetSntFaxTlxListIdx(pGridRowIdx: Integer; var pSntIdx, pFreqIdx: Integer): boolean;
    procedure ClearSntFaxList;
    procedure DisplayFreqFaxTlxItem(SntItem: pTESntFaxTlx; FreqItem: pTEFreqFaxTlx);
    procedure DisplaySntFaxTlxList(DefSelectFlag: boolean);

    //=== Send EMail
    function  SendEMail(SndItemIdxList: TStringList): boolean;
    function  GetSndMailListIdx(pGridRowIdx: Integer): Integer;
    procedure AddSntMailList(SndItem: pTFSndMail);
    procedure PopupSndMailClick(Sender: TObject);
    procedure PopupSndMailSubClick(Sender: TObject);

    //== Sent EMail
    function  QueryToSntMailList : boolean;
    procedure ClearSntMailList;
    procedure DisplaySntMailList;
    procedure DisplayFreqMailItem(SntItem: pTSntMail; FreqItem: pTFreqMail);
    function  BuildMailStrList(SndItem: TStringList):string;
    function  GetSntMailListIdx(pGridRowIdx: Integer; var pSntIdx, pFreqIdx: Integer): boolean;
    procedure PopupSntMailClick(Sender: TObject);
    procedure PopupSntMailSubClick(Sender: TObject);

    procedure DRStrGrid_SndFaxTlxDblClick(Sender: TObject);
    procedure DRStrGrid_SndFaxTlxFiexedRowClick(Sender: TObject; ACol: Integer);
    procedure DRStrGrid_SndFaxTlxMouseUp(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DRStrGrid_SntFaxTlxFiexedRowClick(Sender: TObject;ACol: Integer);
    procedure DRStrGrid_SntFaxTlxMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DRRadioBtn_SntFaxTlxClick(Sender: TObject);
    procedure DRSpeedBtn_SndFaxTlxPrintClick(Sender: TObject);
    procedure DRSpeedBtn_FaxTlxResendClick(Sender: TObject);
    procedure DRSpeedBtn_SntFaxTlxPrintClick(Sender: TObject);
    procedure DRSpeedBtn_FaxTlxExportClick(Sender: TObject);
    procedure PopupSndFaxTlxClick(Sender: TObject);
    procedure PopupSntFaxTlxClick(Sender: TObject);
    procedure DRCheckBox_FaxTlxTotFreqClick(Sender: TObject);
    procedure DRStrGrid_SntFaxTlxDblClick(Sender: TObject);
    procedure DRCheckBox_ViewClick(Sender: TObject);
    procedure DRSpeedBtn_SndMailDirClick(Sender: TObject);
    procedure DRStrGrid_SndMailFiexedRowClick(Sender: TObject; ACol: Integer);
    procedure DRStrGrid_SndMailMouseUp(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DRSpeedBtn_SndFaxTlxSelectClick(Sender: TObject);
    procedure DRSpeedBtn_SntFaxTlxSelectClick(Sender: TObject);
    procedure DRStrGrid_SntMailFiexedRowClick(Sender: TObject;ACol: Integer);
    procedure DRStrGrid_SntMailMouseUp(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    procedure DRStrGrid_SntMailDblClick(Sender: TObject);
    procedure DRSpeedBtn_ExportClick(Sender: TObject);
    procedure DRSpeedBtn_SndFaxTlxRefreshClick(Sender: TObject);
    procedure RefreshListNGrid(pRefreshSnd, pRefreshSnt: boolean);
    procedure DRSpeedBtn_SntFaxTlxRefreshClick(Sender: TObject);
    procedure DRSpeedBtn_SndFaxTlxExportClick(Sender: TObject);
    procedure OnRcvFaxTlxResult(var msg: TMessage); message WM_USER_FAX_RESULT;
    procedure OnRcvMailResult(var msg: TMessage); message WM_USER_EMAIL_RESULT;
    procedure MgrOrFundFiltering();
    procedure FreeLoadXXX;
    procedure DRSpeedBtn_SndFaxTlxPDFExportClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DRButton_DRLastClick(Sender: TObject);
    procedure DRCheckBox_ClientNMClick(Sender: TObject);
    procedure DRMaskEdit_Date1KeyPress(Sender: TObject; var Key: Char);
    procedure DRMaskEdit_Date1Change(Sender: TObject);
    procedure DRBitBtn5Click(Sender: TObject);
    procedure DRSpeedButton_GridPrintClick(Sender: TObject);
    procedure DRButton_DRPriorClick(Sender: TObject);
    procedure DRButton_DRNextClick(Sender: TObject);
    procedure DRPanel_SndTitleDblClick(Sender: TObject);
    procedure DRPanel_SntTitleDblClick(Sender: TObject);
    procedure DRComboBox_SndColOrderChange(Sender: TObject);

  private
    procedure OnRcvChangeJobDate(var msg: TMessage); message WM_USER_CHANGE_JOBDATE;
    procedure DataExistDateJump(sSeparation: String);
    function  EmailManyFileCheck(pSndItemIdxList: TStringList): boolean; // 이메일 보고서 전송 전 파일 갯수 체크.

  public
    procedure SelectSendMtd(pSendMtd: string);
    procedure SetIssueExceptStat;

//    procedure RefreshForm; override;  // Filtering 조건 초기화 함수 CTRL + F5로 작동
  end;

//=======================================================================*/
//  Realtime 대체 Thread
//=======================================================================*/
  T2TRealThread = class(TThread)
    FTimeOut  : Integer;
    FException: Exception;
  private
    { Private declarations }
  protected
//    procedure DoTerminate; override;
    procedure Execute; override;
  public
    procedure RealPushGajjaTot;
    procedure RealPushGajjaFax;
    procedure RealPushGajjaEmail;
    constructor Create;
    destructor  destroy; override;
  end;
//*=======================================================================*/

var
  Form_SCFH8801_SND: TForm_SCFH8801_SND;
  EnvSetupInfo: TIniFile;

implementation

{$R *.DFM}

uses
   SCCLib, SCCCmuLib, SCCTcpIp, SCBEReportLib, SCCEditForm, SCCBSRType,
   SCCDataModule, SCCSRMgrForm, SCFH2304, DateUtils;

const
   NL = #13#10;

   SELECT_IDX    = 0;           // DRStrGrid_의 Select Column Index

   // [L.J.S]
   WORD_NONE = '미등록';
   
   SND_COL_COUNT = 12;
   SNT_COL_COUNT = 13;

   SND_NO1_IDX  = 1;    // 컬럼 순서가 달라질 수 있는 필드들 (사번, 생성시간, 계좌번호, 계좌명(계좌번호 COL_IDX + 1)
   SND_NO2_IDX  = 2;    // 컬럼 순서가 달라질 수 있는 필드들 (사번, 생성시간, 계좌번호, 계좌명(계좌번호 COL_IDX + 1)
   SND_NO3_IDX  = 3;    // 컬럼 순서가 달라질 수 있는 필드들 (사번, 생성시간, 계좌번호, 계좌명(계좌번호 COL_IDX + 1)
   SND_NO4_IDX  = 4;    // 컬럼 순서가 달라질 수 있는 필드들 (사번, 생성시간, 계좌번호, 계좌명(계좌번호 COL_IDX + 1)
   SND_TYPE_IDX      = 5;    // DRStrGrid_Snd 전송구분 Col Index
   SND_DEST_NAME_IDX = 6;    // DRStrGrid_Snd 수신처명 Col Index
   SND_DEST_IDX      = 7;    // DRStrGrid_Snd 수신처 Col Index
   SND_RPT_IDX       = 8;    // DRStrGrid_Snd 보고서 서식 Col Index
   SND_REQ_TIME_IDX  = 9;    // DRStrGrid_Snd 전송 요청 시간 Col Index
   SND_FIN_TIME_IDX  = 10;   // DRStrGrid_Snd 전송 완료 시간 Col Index
   SND_EXP_IDX       = 11;   // DRStrGrid_Snd 전송제외 Col Index

   SNT_EMP_IDX       = 1;    // DRStrGrid_Snt 사번 Col Index
   SNT_ACC_NO_IDX    = 2;    // DRStrGrid_Snt 계좌번호 Col Index
   SNT_ACC_NAME_IDX  = 3;    // DRStrGrid_Snt 계좌명 Col Index
   SNT_TYPE_IDX      = 4;    // DRStrGrid_Snt 전송구분 Col Index
   SNT_DEST_NAME_IDX = 5;    // DRStrGrid_Snt 수신처명 Col Index
   SNT_DEST_IDX      = 6;    // DRStrGrid_Snt 수신처 Col Index
   SNT_RPT_IDX       = 7;    // DRStrGrid_Snt 보고서 서식 Col Index
   SNT_REQ_TIME_IDX  = 8;    // DRStrGrid_Snt 전송 시작 시간 Col Index
   SNT_FIN_TIME_IDX  = 9;    // DRStrGrid_Snt 전송 완료 시간 Col Index
   SNT_RESEND_IDX    = 10;   // DRStrGrid_Snt 재전송 Col Index
   SNT_PRC_IDX       = 11;   // DRStrGrid_Snt Process Col Index
   SNT_PAGE_IDX      = 12;   // DRStrGrid_Snt Page Col Index

   SND_TYPE_FAX      = 'FAX';  // 전송대상 전송 구분 - FAX
   SND_TYPE_MAIL     = 'E-mail';  // 전송대상 전송 구분 - E-mail
   SND_TYPE_NONE     = 'NONE';  // 전송대상 전송 구분 - 미등록



   SND_FAXTLX_ACCNO_IDX  = 1;   // DRStrGrid_SndFaxTlx의 계좌번호 Column Index
   SND_FAXTLX_RCVCMP_IDX = 3;   // DRStrGrid_SndFaxTlx의 수신처 Column Index
   SND_FAXTLX_SNDCNF_IDX = 6;   // DRStrGrid_SndFaxTlx의 서버전송확인 Column Index

   SNT_FAXTLX_ACCNO_IDX   = 1;  // DRStrGrid_SntFaxTlx의 계좌번호 Column Index
   SNT_FAXTLX_FREQNO_IDX  = 5;  // DRStrGrid_SntFaxTlx의 회차 Column Index
   SNT_FAXTLX_SNTTIME_IDX = 6;  // DRStrGrid_SntFaxTlx의 전송시간 Column Index
   SNT_FAXTLX_RSPF_IDX    = 10; // DRStrGrid_SntFaxTlx의 Porcess Column Index

   SND_MAIL_ACCGRP_IDX    = 1;  // DRStrGrid_SndEMail의 그룹, 계좌명
   SND_MAIL_RCVCMP_IDX    = 2;  // DRStrGrid_SndMail의 수신처 Column Index
   SND_MAIL_MAILID_IDX    = 4;  // DRStrGrid_SndMail의 메일서식 Column Index
   SND_MAIL_SNDCNF_IDX    = 5;  // DRStrGrid_SndMail의 서버전송 Column Index

   SNT_MAIL_ACCGRP_IDX    = 1;  // DRStrGrid_SntEMail의 그룹, 계좌명
   SNT_MAIL_RCVCMP_IDX    = 3;  // DRStrGrid_SntdMail의 수신처 Column Index
   SNT_MAIL_SNDCNF_IDX    = 5;  // DRStrGrid_SntMail의  서버전송 Column Index
   SNT_MAIL_RSPF_IDX      = 7; // DRStrGrid_SntFaxTlx의 Porcess Column Inde

   // Mail Send 관련
   MAIL_RCV_TYPE     = 0;//'R';
   CCMAIL_RCV_TYPE   = 1;//'C';
   CCBLIND_RCV_TYPE  = 2;//'B';

   MsgInterLine      = ' ' + chr(13) + ' ';

var
  // [L.J.S]
  SndList, SntList: TList; // 전송대상, 당일송신확인 리스트

  bNotSend: Boolean;                    // 전송대상 - 미전송 내역 체크 여부
  bSndSelected, bSntSelected: Boolean;  // 전송대상, 당일송신확인 - 전체 선택 여부

  iSndSortIdx, iSntSortIdx: Integer;         // 전송대상, 당일송신확인 - Sort할 컬럼 인덱스
  arrSndSortFlag: Array [0..12] of Boolean;  // 전송대상 - Sort할 전체 컬럼 배열
  arrSntSortFlag: Array [0..13] of Boolean;  // 당일송신확인 - Sort할 전체 컬럼 배열

  iSndColIdx, iSndRowIdx: Integer;  // 전송대상 - 그리드 Col, Row 인덱스
  iSntColIdx, iSntRowIdx: Integer;  // 당일송신확인 - 그리드 Col, Row 인덱스

  bSndOnlyViewFlag: boolean; // View Type
  bSntOnlyViewFlag: boolean; // View Type

  iSndColOpt : Integer; // 전송대상 - 컬럼 순서 옵션
                        // 1. 사번 / 생성시간 / 계좌번호
                        // 2. 계좌번호 / 생성시간
                        // 3. 생성시간 / 계좌번호
  iSndEmpIdx, iSndJobTimeIdx, iSndAccNoIdx, iSndAccNameIdx : Integer; // 전송대상 - 컬럼 순서가 달라질 수 있는 3가지 컬럼 인덱스




   SndFaxTlxList, SntFaxTlxList : TList;             // Fax/Tlx 전송, 송신확인 List
   SndFaxTlxColIdx, SndFaxTlxRowIdx : Integer;       // DRGrid_SndFaxTlx의 Select된 Col Index, Row Index
   SntFaxTlxColIdx, SntFaxTlxRowIdx : Integer;       // DRGrid_SntFaxTlx의 Select된 Col Index, Row Index
   SndFaxTlxSelected, SntFaxTlxSelected : boolean;   // Fax/Tlx 전체 선택 여부
   SndFaxTlxSortIdx, SntFaxTlxSortIdx : Integer;     // SndFaxTlxList, SndFaxTlxList Sort Index
   SndFaxTlxSortFlag : Array [0..11] of boolean;      // Column별 Sort Status
   SntFaxTlxSortFlag : Array [0..11] of boolean;     // Column별 Sort Status
   FaxTlxTotFreqChecked: string;                     // 진행내역 조회후 전회차보기 체크박스 원상복구시 사용


   //Email
   SndMailList, SntMailList : TList;                 // EMail 전송,전송내역 List
   SndMailSelected, SntMailSelected : boolean;       // Mail 전체선택 여부
   SndMailColIdx, SndMailRowIdx : Integer;           // DRGrid_SndMail의 Selecte된 Col Index, Row Index
   SntMailColIdx, SntMailRowIdx : Integer;           // DRGrid_SntMail의 Selecte된 Col Index, Row Index
   SndMailSortIdx, SntMailSortIdx : Integer;         // SndMailList, SndMailList Sort Index
   SndMailSortFlag : Array [0..6] of boolean;        // Column별 Sort Status
   SntMailSortFlag : Array [0..7] of boolean;       // Column별 Sort Status

   RealThread : T2TRealThread;
   tMyFAXResult : TFAXResult;
   tMyEmailResult : TEMailResult;
   sFaxResultRcvLastTime : string;
   sEmailResultRcvLastTime : string;
   iRealThreadSleepSeconds : integer;
   FThreadHoldFlag : boolean;  ////@@@@@@@@ VERY IMPORTANT @@@@@@@@ VERY VERY
   sRealThreadUseYN : string;
   sGridSelectAllYN : string;
      
//------------------------------------------------------------------------------
//  T2TRealThread Thread
//------------------------------------------------------------------------------
constructor T2TRealThread.Create;
begin
  inherited Create(True); // thread생성되자 마자 실행안됨
end;

destructor T2TRealThread.Destroy;
begin
   inherited Destroy;
   RealThread := nil;
end;

//Fax Real Push
procedure T2TRealThread.RealPushGajjaTot;
var tmsg : TMessage;
    sTmpTime : string;
begin
   with DataModule_SettleNet.ADOQuery_THread do
   begin
      Close;
      SQL.Clear;

      SQL.Add(' SELECT CUR_DATE = A.SND_DATE,   ' +
              '        DEPT_CODE = A.DEPT_CODE, ' +
              '        SEQ_NO = A.CUR_TOT_SEQ_NO, ' +
              '        SEC_CODE = B.SEC_TYPE, ' +
              '        MEDIA_NO = A.MEDIA_NO,  ' +
              '        RSP_CODE = A.RSP_FLAG,  ' +
              '        BUSY_CNT = A.BUSY_RESND_CNT, ' +
              '        CURR_PAGE = A.SEND_PAGE, ' +
              '        ERR_CODE = A.ERR_CODE, ' +
              '        EXT_MSG = A.EXT_MSG, ' +
              '        SEND_TIME = A.SEND_TIME, ' +
              '        RECV_TIME = A.SENT_TIME, ' +
              '        DIFF_TIME = A.DIFF_TIME, ' +
              '        REPORT_ID = B.REPORT_ID, ' +
              '        OPR_ID =  A.OPR_ID,      ' +
              '        OPR_TIME = A.OPR_TIME    ' +
              ' FROM SCFAXSND_TBL A, SCFAXIMG_TBL B ' +
              ' WITH (NOLOCK)                         ' +
              ' WHERE A.SND_DATE      =  ''' + gvCurDate + ''' '  +
              ' AND   A.DEPT_CODE     =  ''' + gvDeptCode + ''' ' +
              ' AND   A.OPR_TIME      >= ''' + sFaxResultRcvLastTime + ''' ' +
              ' AND   A.SND_DATE   = B.SND_DATE            ' +
              ' AND   A.DEPT_CODE  = B.DEPT_CODE           ' +
               { TODO : REPORT_ID로 제외}
           //
              ' AND SubString(B.REPORT_ID,2,1) <> ''3''     ' +

              ' AND   A.IDX_SEQ_NO = B.IDX_SEQ_NO          ' +
              ' ORDER BY A.OPR_TIME                        '
              );
      try
//         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_THread);
         DataModule_SettleNet.ADOQuery_THread.Open;
         DataModule_SettleNet.ADOQuery_THread.Last;
         DataModule_SettleNet.ADOQuery_THread.First;
      except
         on E : Exception do
         begin
           gf_Log('RealPushGajjTot gf_ADOQueryOpen Error!!! ' + E.Message);
           Exit;
         end;
      end;

      if FThreadHoldFlag then
      begin
         Close;
         Exit;
      end;

      // 자료가 없으면
      if RecordCount <= 0 then
      begin
         Close;
         Exit;
      end;

      try
         while not Eof do
         begin

            if FThreadHoldFlag then
            begin
               Close;
               Exit;
            end;

            sTmpTime := Trim(FieldByName('OPR_TIME').asString);

            fnCharSet(@tMyFAXResult,' ',SizeOf(tMyFAXResult));
            MoveDataChar(tMyFAXResult.sCurDate,  Trim(FieldByName('CUR_DATE').asString), SizeOf(tMyFAXResult.sCurDate));
            MoveDataChar(tMyFAXResult.sDeptCode, Trim(FieldByName('DEPT_CODE').asString), SizeOf(tMyFAXResult.sDeptCode));
            MoveDataChar(tMyFAXResult.sSeqNo   , Trim(FieldByName('SEQ_NO').asString), SizeOf(tMyFAXResult.sSeqNo   ));
            tMyFAXResult.sSecCode := Trim(FieldByName('SEC_CODE').asString)[1];
            MoveDataChar(tMyFAXResult.sMediaNo , Trim(FieldByName('MEDIA_NO').asString), SizeOf(tMyFAXResult.sMediaNo ));
            tMyFAXResult.sRspCode := Trim(FieldByName('RSP_CODE').asString)[1];
            MoveDataChar(tMyFAXResult.sBusyCnt , Trim(FieldByName('BUSY_CNT').asString), SizeOf(tMyFAXResult.sBusyCnt ));
            MoveDataChar(tMyFAXResult.sCurrPage, Trim(FieldByName('CURR_PAGE').asString), SizeOf(tMyFAXResult.sCurrPage));
            MoveDataChar(tMyFAXResult.sErrCode , Trim(FieldByName('ERR_CODE').asString), SizeOf(tMyFAXResult.sErrCode ));

            if Trim(FieldByName('ERR_CODE').asString) = '9103' then //잠시후 재전송합니다...
               MoveDataChar(tMyFAXResult.sErrMsg  , '잠시후 재전송합니다...', SizeOf(tMyFAXResult.sErrMsg  ))
            else if Trim(FieldByName('ERR_CODE').asString) = '9102' then //자료 전송중 오류 발생
               MoveDataChar(tMyFAXResult.sErrMsg  , '자료 전송중 오류 발생', SizeOf(tMyFAXResult.sErrMsg  ))
            else
               MoveDataChar(tMyFAXResult.sErrMsg  , Trim(FieldByName('ERR_CODE').asString), SizeOf(tMyFAXResult.sErrMsg  )); //@@

            MoveDataChar(tMyFAXResult.sExtMsg  , Trim(FieldByName('EXT_MSG').asString), SizeOf(tMyFAXResult.sExtMsg  ));
            MoveDataChar(tMyFAXResult.sSendTime, Trim(FieldByName('SEND_TIME').asString), SizeOf(tMyFAXResult.sSendTime));
            MoveDataChar(tMyFAXResult.sRecvTime, Trim(FieldByName('RECV_TIME').asString), SizeOf(tMyFAXResult.sRecvTime));
            MoveDataChar(tMyFAXResult.sDiffTime, Trim(FieldByName('DIFF_TIME').asString), SizeOf(tMyFAXResult.sDiffTime));
            MoveDataChar(tMyFAXResult.sReportID, Trim(FieldByName('REPORT_ID').asString), SizeOf(tMyFAXResult.sReportID));
            MoveDataChar(tMyFAXResult.sOprID   , Trim(FieldByName('OPR_ID').asString), SizeOf(tMyFAXResult.sOprID   ));
            MoveDataChar(tMyFAXResult.sOprTime , Trim(FieldByName('OPR_TIME').asString), SizeOf(tMyFAXResult.sOprTime ));

            gvptFaxResult := @tMyFAXResult;
            Form_SCFH8801_SND.OnRcvFaxTlxResult( tmsg );

            if FThreadHoldFlag then
            begin
               Close;
               Exit;
            end;

            if sTmpTime > sFaxResultRcvLastTime then
            begin
               sFaxResultRcvLastTime := sTmpTime; //마지막시간 보유하기
            end;

            if Terminated then
            begin
               Close;
               Exit;
            end;

            Next;
         end;  // end of while
      except
         on E:Exception do
         begin
            gf_Log('realpushgajja fax exception..' + E.Message);
         end;
      end;
      close;
   end;  // end of with

end;

procedure T2TRealThread.RealPushGajjaFax;
var tmsg : TMessage;
    sTmpTime : string;
begin
   with DataModule_SettleNet.ADOQuery_THread do
   begin
      Close;
      SQL.Clear;

      SQL.Add(' SELECT CUR_DATE = A.SND_DATE,   ' +
              '        DEPT_CODE = A.DEPT_CODE, ' +
              '        SEQ_NO = A.CUR_TOT_SEQ_NO, ' +
              '        SEC_CODE = B.SEC_TYPE, ' +
              '        MEDIA_NO = A.MEDIA_NO,  ' +
              '        RSP_CODE = A.RSP_FLAG,  ' +
              '        BUSY_CNT = A.BUSY_RESND_CNT, ' +
              '        CURR_PAGE = A.SEND_PAGE, ' +
              '        ERR_CODE = A.ERR_CODE, ' +
              '        EXT_MSG = A.EXT_MSG, ' +
              '        SEND_TIME = A.SEND_TIME, ' +
              '        RECV_TIME = A.SENT_TIME, ' +
              '        DIFF_TIME = A.DIFF_TIME, ' +
              '        REPORT_ID = B.REPORT_ID, ' +
              '        OPR_ID =  A.OPR_ID,      ' +
              '        OPR_TIME = A.OPR_TIME    ' +
              ' FROM SCFAXSND_TBL A, SCFAXIMG_TBL B ' +
              ' WITH (NOLOCK)                         ' +
              ' WHERE A.SND_DATE      =  ''' + gvCurDate + ''' '  +
              ' AND   A.DEPT_CODE     =  ''' + gvDeptCode + ''' ' +
              ' AND   A.OPR_TIME      >= ''' + sFaxResultRcvLastTime + ''' ' +
              ' AND   A.SND_DATE   = B.SND_DATE            ' +
              ' AND   A.DEPT_CODE  = B.DEPT_CODE           ' +
               { TODO : REPORT_ID로 제외}
           //
              ' AND SubString(B.REPORT_ID,2,1) <> ''3''     ' +

              ' AND   A.IDX_SEQ_NO = B.IDX_SEQ_NO          ' +
              ' ORDER BY A.OPR_TIME                        '
              );
      try
//         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_THread);
         DataModule_SettleNet.ADOQuery_THread.Open;
         DataModule_SettleNet.ADOQuery_THread.Last;
         DataModule_SettleNet.ADOQuery_THread.First;
      except
         on E : Exception do
         begin
           gf_Log('RealPushGajjaFax gf_ADOQueryOpen Error!!! ' + E.Message);
           Exit;
         end;
      end;

      if FThreadHoldFlag then
      begin
         Close;
         Exit;
      end;

      // 자료가 없으면
      if RecordCount <= 0 then
      begin
         Close;
         Exit;
      end;

      try
         while not Eof do
         begin

            if FThreadHoldFlag then
            begin
               Close;
               Exit;
            end;

            sTmpTime := Trim(FieldByName('OPR_TIME').asString);

            fnCharSet(@tMyFAXResult,' ',SizeOf(tMyFAXResult));
            MoveDataChar(tMyFAXResult.sCurDate,  Trim(FieldByName('CUR_DATE').asString), SizeOf(tMyFAXResult.sCurDate));
            MoveDataChar(tMyFAXResult.sDeptCode, Trim(FieldByName('DEPT_CODE').asString), SizeOf(tMyFAXResult.sDeptCode));
            MoveDataChar(tMyFAXResult.sSeqNo   , Trim(FieldByName('SEQ_NO').asString), SizeOf(tMyFAXResult.sSeqNo   ));
            tMyFAXResult.sSecCode := Trim(FieldByName('SEC_CODE').asString)[1];
            MoveDataChar(tMyFAXResult.sMediaNo , Trim(FieldByName('MEDIA_NO').asString), SizeOf(tMyFAXResult.sMediaNo ));
            tMyFAXResult.sRspCode := Trim(FieldByName('RSP_CODE').asString)[1];
            MoveDataChar(tMyFAXResult.sBusyCnt , Trim(FieldByName('BUSY_CNT').asString), SizeOf(tMyFAXResult.sBusyCnt ));
            MoveDataChar(tMyFAXResult.sCurrPage, Trim(FieldByName('CURR_PAGE').asString), SizeOf(tMyFAXResult.sCurrPage));
            MoveDataChar(tMyFAXResult.sErrCode , Trim(FieldByName('ERR_CODE').asString), SizeOf(tMyFAXResult.sErrCode ));

            if Trim(FieldByName('ERR_CODE').asString) = '9103' then //잠시후 재전송합니다...
               MoveDataChar(tMyFAXResult.sErrMsg  , '잠시후 재전송합니다...', SizeOf(tMyFAXResult.sErrMsg  ))
            else if Trim(FieldByName('ERR_CODE').asString) = '9102' then //자료 전송중 오류 발생
               MoveDataChar(tMyFAXResult.sErrMsg  , '자료 전송중 오류 발생', SizeOf(tMyFAXResult.sErrMsg  ))
            else
               MoveDataChar(tMyFAXResult.sErrMsg  , Trim(FieldByName('ERR_CODE').asString), SizeOf(tMyFAXResult.sErrMsg  )); //@@

            MoveDataChar(tMyFAXResult.sExtMsg  , Trim(FieldByName('EXT_MSG').asString), SizeOf(tMyFAXResult.sExtMsg  ));
            MoveDataChar(tMyFAXResult.sSendTime, Trim(FieldByName('SEND_TIME').asString), SizeOf(tMyFAXResult.sSendTime));
            MoveDataChar(tMyFAXResult.sRecvTime, Trim(FieldByName('RECV_TIME').asString), SizeOf(tMyFAXResult.sRecvTime));
            MoveDataChar(tMyFAXResult.sDiffTime, Trim(FieldByName('DIFF_TIME').asString), SizeOf(tMyFAXResult.sDiffTime));
            MoveDataChar(tMyFAXResult.sReportID, Trim(FieldByName('REPORT_ID').asString), SizeOf(tMyFAXResult.sReportID));
            MoveDataChar(tMyFAXResult.sOprID   , Trim(FieldByName('OPR_ID').asString), SizeOf(tMyFAXResult.sOprID   ));
            MoveDataChar(tMyFAXResult.sOprTime , Trim(FieldByName('OPR_TIME').asString), SizeOf(tMyFAXResult.sOprTime ));

            gvptFaxResult := @tMyFAXResult;
            Form_SCFH8801_SND.OnRcvFaxTlxResult( tmsg );

            if FThreadHoldFlag then
            begin
               Close;
               Exit;
            end;

            if sTmpTime > sFaxResultRcvLastTime then
            begin
               sFaxResultRcvLastTime := sTmpTime; //마지막시간 보유하기
            end;

            if Terminated then
            begin
               Close;
               Exit;
            end;

            Next;
         end;  // end of while
      except
         on E:Exception do
         begin
            gf_Log('realpushgajja fax exception..' + E.Message);
         end;
      end;
      close;
   end;  // end of with

end;

// string  비교 길이 맞춤
procedure ComporeStrLenSame(var Str1, Str2: string);
var
  iLenStr1, iLenStr2: Integer;
begin
  iLenStr1 := Length(Str1);
  iLenStr2 := Length(Str2);
  if iLenStr1 > iLenStr2 then // 길이의 차이를 재서
    Str2 := MoveDataStr(Str2, iLenStr1 + 1) // str2 의 길이가 짧으면 str2의 길이를 str1하고 맞춤
  else if iLenStr1 < iLenStr2 then
    Str1 := MoveDataStr(Str1, iLenStr2 + 1) // str1 의 길이가 짧으면 str1의 길이를 str2하고 맞춤
  // 길이가 같으면 그냥 나감
end;

//Email Real Push
procedure T2TRealThread.RealPushGajjaEMail;
var tmsg : TMessage;
    sTmpTime : string;
begin
   with DataModule_SettleNet.ADOQuery_THread do
   begin
      Close;
      SQL.Clear;

      SQL.Add(' SELECT CUR_DATE = A.SND_DATE,   ' +
              '        DEPT_CODE = A.DEPT_CODE, ' +
              '        SEQ_NO = A.CUR_TOT_SEQ_NO, ' +
              '        RSP_CODE = A.RSP_FLAG,  ' +
              '        ERR_CODE = A.ERR_CODE, ' +
              '        EXT_MSG = A.EXT_MSG, ' +
              '        SEND_TIME = A.SEND_TIME, ' +
              '        SENT_TIME = A.SENT_TIME, ' +
              '        DIFF_TIME = A.DIFF_TIME, ' +
              '        MAIL_FORM_GRP = B.MAILFORM_GRP, ' +
              '        OPR_ID =  A.OPR_ID,      ' +
              '        OPR_TIME = A.OPR_TIME    ' +
              ' FROM SCMELSND_TBL  A, SCMELINF_TBL B ' +
              ' WITH (NOLOCK)                         ' +
              ' WHERE A.SND_DATE      =  ''' + gvCurDate + ''' '  +
              ' AND   A.DEPT_CODE     =  ''' + gvDeptCode + ''' ' +
              ' AND   A.OPR_TIME      >= ''' + sEmailResultRcvLastTime + ''' ' +
              ' AND   A.SND_DATE      = B.SND_DATE      ' +
              ' AND   A.CUR_TOT_SEQ_NO= B.CUR_TOT_SEQ_NO ' +
              ' ORDER BY A.OPR_TIME                        '
              );
      try
//         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_THread);
         DataModule_SettleNet.ADOQuery_THread.Open;
         DataModule_SettleNet.ADOQuery_THread.Last;
         DataModule_SettleNet.ADOQuery_THread.First;
      except
         on E : Exception do
         begin
           gf_Log('RealPushGajjaEmail gf_ADOQueryOpen Error!!! ' + E.Message);
           Exit;
         end;
      end;

      if FThreadHoldFlag then
      begin
         Close;
         Exit;
      end;

      // 자료가 없으면
      if RecordCount <= 0 then
      begin
         Close;
         Exit;
      end;

      try
         while not Eof do
         begin

            if FThreadHoldFlag then
            begin
               Close;
               Exit;
            end;
            sTmpTime := Trim(FieldByName('OPR_TIME').asString);

            fnCharSet(@tMyEmailResult,' ',SizeOf(tMyEmailResult));
            MoveDataChar(tMyEmailResult.sCurDate,  Trim(FieldByName('CUR_DATE').asString), SizeOf(tMyEmailResult.sCurDate));
            MoveDataChar(tMyEmailResult.sDeptCode, Trim(FieldByName('DEPT_CODE').asString), SizeOf(tMyEmailResult.sDeptCode));
            MoveDataChar(tMyEmailResult.sSeqNo   , Trim(FieldByName('SEQ_NO').asString), SizeOf(tMyEmailResult.sSeqNo   ));
            MoveDataChar(tMyEmailResult.sMailFormGrp, Trim(FieldByName('MAIL_FORM_GRP').asString), SizeOf(tMyEmailResult.sMailFormGrp   ));
            tMyEmailResult.sRspCode := Trim(FieldByName('RSP_CODE').asString)[1];
            MoveDataChar(tMyEmailResult.sErrCode , Trim(FieldByName('ERR_CODE').asString), SizeOf(tMyEmailResult.sErrCode ));

            if Trim(FieldByName('ERR_CODE').asString) = '9103' then //잠시후 재전송합니다...
               MoveDataChar(tMyEmailResult.sErrMsg  , '잠시후 재전송합니다...', SizeOf(tMyEmailResult.sErrMsg  ))
            else if Trim(FieldByName('ERR_CODE').asString) = '9102' then //자료 전송중 오류 발생
               MoveDataChar(tMyEmailResult.sErrMsg  , '자료 전송중 오류 발생', SizeOf(tMyEmailResult.sErrMsg  ))
            else
               MoveDataChar(tMyEmailResult.sErrMsg  , Trim(FieldByName('ERR_CODE').asString), SizeOf(tMyEmailResult.sErrMsg  )); //@@

            MoveDataChar(tMyEmailResult.sExtMsg  , Trim(FieldByName('EXT_MSG').asString), SizeOf(tMyEmailResult.sExtMsg  ));
            MoveDataChar(tMyEmailResult.sSendTime, Trim(FieldByName('SEND_TIME').asString), SizeOf(tMyEmailResult.sSendTime));
            MoveDataChar(tMyEmailResult.sSentTime, Trim(FieldByName('SENT_TIME').asString), SizeOf(tMyEmailResult.sSentTime));
            MoveDataChar(tMyEmailResult.sDiffTime, Trim(FieldByName('DIFF_TIME').asString), SizeOf(tMyEmailResult.sDiffTime));
            MoveDataChar(tMyEmailResult.sOprID   , Trim(FieldByName('OPR_ID').asString), SizeOf(tMyEmailResult.sOprID   ));
            MoveDataChar(tMyEmailResult.sOprTime , Trim(FieldByName('OPR_TIME').asString), SizeOf(tMyEmailResult.sOprTime ));

            gvptEMailResult := @tMyEmailResult;
            Form_SCFH8801_SND.OnRcvMailResult( tmsg );

            if FThreadHoldFlag then
            begin
               Close;
               Exit;
            end;
            
            if sTmpTime > sEmailResultRcvLastTime then
            begin
               sEmailResultRcvLastTime := sTmpTime; //마지막시간 보유하기
            end;

            if Terminated then
            begin
               Close;
               Exit;
            end;

            Next;
         end;  // end of while
      except
         on E:Exception do
         begin
           gf_Log('realpushgajja mail... exception' + E.Message);
         end;
      end;
      Close;
   end;  // end of with
end;

//=======================================================================
// TcpMonitor Port Execute
//=======================================================================
procedure T2TRealThread.Execute;
begin

//   sleep(5000);//
   while True do
   begin
      if Terminated then break;   // Thread 종료
      if FThreadHoldFlag then
      begin
         sleep(1000);
         Continue;
      end;
      try
         if Form_SCFH8801_SND.DRPageControl_Main.ActivePage.PageIndex = gcPAGE_IDX_FAXTLX then
         begin
            if not Assigned(SntFaxTlxList) then continue;
            RealPushGajjaFax;
         end
         else if Form_SCFH8801_SND.DRPageControl_Main.ActivePage.PageIndex = gcPAGE_IDX_EMAIL then
         begin
            if not Assigned(SntMailList) then continue;
            RealPushGajjaEmail;
         end
         else continue;

      except
         on E:Exception do
         begin

         end;
      end;

      if terminated = TRUE then break;

      Sleep(iRealThreadSleepSeconds * 1000);

   end;

end;

//------------------------------------------------------------------------------
//  SndFaxTlxList Sorting
//------------------------------------------------------------------------------
function SndFaxTlxListCompare(Item1, Item2: Pointer): Integer;
var
   TmpStr1, TmpStr2: string;
   StdStr1, StdStr2: string;
   sCompareStr1, sCompareStr2: string;
begin
   if not Form_SCFH8801_SND.DRCheckBox_View.Checked then  // AccNo Only
   begin
      StdStr1 := pTESndFaxTlx(Item1).AccGrpType +
                 MoveDataStr(pTESndFaxTlx(Item1).AccNo, 21) +
                 MoveDataStr(pTESndFaxTlx(Item1).SubAccNo, 5) +
                 UpperCase(MoveDataStr(pTESndFaxTlx(Item1).AccName, 61)) +
                 UpperCase(MoveDataStr(pTESndFaxTlx(Item1).RcvCompKor, 61)) +
                 pTESndFaxTlx(Item1).NatCode + pTESndFaxTlx(Item1).MediaNo;

      StdStr2 := pTESndFaxTlx(Item2).AccGrpType +
                 MoveDataStr(pTESndFaxTlx(Item2).AccNo, 21) +
                 MoveDataStr(pTESndFaxTlx(Item2).SubAccNo, 5) +
                 UpperCase(MoveDataStr(pTESndFaxTlx(Item2).AccName, 61)) +
                 UpperCase(MoveDataStr(pTESndFaxTlx(Item2).RcvCompKor, 61)) +
                 pTESndFaxTlx(Item2).NatCode + pTESndFaxTlx(Item2).MediaNo;
   end  else  // Acc Identification + AccNo
   begin
      StdStr1 := pTESndFaxTlx(Item1).AccGrpType +
                 MoveDataStr(pTESndFaxTlx(Item1).AccId, 6) +
                 MoveDataStr(pTESndFaxTlx(Item1).AccNo, 21) +
                 MoveDataStr(pTESndFaxTlx(Item1).SubAccNo, 5) +
                 UpperCase(MoveDataStr(pTESndFaxTlx(Item1).AccName, 61)) +
                 UpperCase(MoveDataStr(pTESndFaxTlx(Item1).RcvCompKor, 61)) +
                 pTESndFaxTlx(Item1).NatCode + pTESndFaxTlx(Item1).MediaNo;

      StdStr2 := pTESndFaxTlx(Item2).AccGrpType +
                 MoveDataStr(pTESndFaxTlx(Item2).AccId, 6) +
                 MoveDataStr(pTESndFaxTlx(Item2).AccNo, 21) +
                 MoveDataStr(pTESndFaxTlx(Item2).SubAccNo, 5) +
                 UpperCase(MoveDataStr(pTESndFaxTlx(Item2).AccName, 61)) +
                 UpperCase(MoveDataStr(pTESndFaxTlx(Item2).RcvCompKor, 61)) +
                 pTESndFaxTlx(Item2).NatCode + pTESndFaxTlx(Item2).MediaNo;
   end;


   case SndFaxTlxSortIdx of
      // 계좌번호
      1:
      begin
        sCompareStr1 := '';
        sCompareStr2 := '';
      end;

      // 계좌명
      2:
      begin
        sCompareStr1 := UpperCase(pTESndFaxTlx(Item1).AccName);
        sCompareStr2 := UpperCase(pTESndFaxTlx(Item2).AccName);
      end;
      // 수신처
      3:
      begin
        sCompareStr1 := UpperCase(pTESndFaxTlx(Item1).RcvCompKor);
        sCompareStr2 := UpperCase(pTESndFaxTlx(Item2).RcvCompKor);
      end;
      // 번호
      4:
      begin
        sCompareStr1 := MoveDataStr(pTESndFaxTlx(Item1).NatCode, 3)
                      + MoveDataStr(pTESndFaxTlx(Item1).MediaNo, 65);
        sCompareStr2 := MoveDataStr(pTESndFaxTlx(Item2).NatCode, 3)
                      + MoveDataStr(pTESndFaxTlx(Item2).MediaNo, 65);
      end;
      // Report 서식
      5:
      begin
        sCompareStr1 := pTESndFaxTlx(Item1).ReportName;
        sCompareStr2 := pTESndFaxTlx(Item1).ReportName;
      end;
      6: // 서버전송확인
      begin
         TmpStr1 := '';
         if pTESndFaxTlx(Item1).SendFlag then
         begin
            if pTESndFaxTlx(Item1).CancFlag then TmpStr1 := gwRSPCancel
            else if Trim(pTESndFaxTlx(Item1).ErrMsg) <> '' then TmpStr1 := gwRSPError
            else TmpStr1 := gwRSPOK;
         end;
         TmpStr2 := '';
         if pTESndFaxTlx(Item2).SendFlag then
         begin
            if pTESndFaxTlx(Item2).CancFlag then TmpStr2 := gwRSPCancel
            else if Trim(pTESndFaxTlx(Item2).ErrMsg) <> '' then TmpStr2 := gwRSPError
            else TmpStr2 := gwRSPOK;
         end;

         sCompareStr1 := TmpStr1;
         sCompareStr2 := TmpStr2;
      end;
      7: // P.S
      begin
         TmpStr1 := '';
         if pTESndFaxTlx(Item1).PSList.PSStringList.Count > 0 then TmpStr1:= gcUSER_DEF_MARK;
         TmpStr2 := '';
         if pTESndFaxTlx(Item2).PSList.PSStringList.Count > 0 then TmpStr2:= gcUSER_DEF_MARK;

         sCompareStr1 := TmpStr1;
         sCompareStr2 := TmpStr2;
      end;
      8: // Edit
      begin
         TmpStr1 := '';
         if Trim(pTESndFaxTlx(Item1).EditFileName) <> '' then TmpStr1 := gcUSER_DEF_MARK;
         TmpStr2 := '';
         if Trim(pTESndFaxTlx(Item2).EditFileName) <> '' then TmpStr2 := gcUSER_DEF_MARK;

         sCompareStr1 := TmpStr1;
         sCompareStr2 := TmpStr2;
      end;
      9: // Amend
      begin
         TmpStr1 := '';
         if pTESndFaxTlx(Item1).InsertAmd then TmpStr1 := gcUSER_DEF_MARK;
         TmpStr2 := '';
         if pTESndFaxTlx(Item2).InsertAmd then TmpStr2 := gcUSER_DEF_MARK;

         sCompareStr1 := TmpStr1;
         sCompareStr2 := TmpStr2;
      end
      else
      begin
         Result := 0;
         Exit;
      end;
   end;  // end of case

   ComporeStrLenSame(sCompareStr1, sCompareStr2);

   Result := gf_ReturnStrComp(sCompareStr1 + StdStr1, sCompareStr2 + StdStr2,
                              SndFaxTlxSortFlag[SndFaxTlxSortIdx]);

end;

//------------------------------------------------------------------------------
//  SntFaxTlxList Sorting
//------------------------------------------------------------------------------
function SntFaxTlxListCompare(Item1, Item2: Pointer): Integer;
var
   StdStr1, StdStr2: string;
   sCompareStr1, sCompareStr2: string;
begin
   if not Form_SCFH8801_SND.DRCheckBox_View.Checked then  // AccNo Only
   begin
      StdStr1 := pTESntFaxTlx(Item1).AccGrpType +
                 MoveDataStr(pTESntFaxTlx(Item1).AccNo, 21) +
                 MoveDataStr(pTESntFaxTlx(Item1).SubAccNo, 5) +
                 UpperCase(MoveDataStr(pTESntFaxTlx(Item1).AccName,  61)) +
                 UpperCase(MoveDataStr(pTESntFaxTlx(Item1).RcvCompKor, 61)) +
                 pTESntFaxTlx(Item1).NatCode + pTESntFaxTlx(Item1).MediaNo;

      StdStr2 := pTESntFaxTlx(Item2).AccGrpType +
                 MoveDataStr(pTESntFaxTlx(Item2).AccNo, 21) +
                 MoveDataStr(pTESntFaxTlx(Item2).SubAccNo,5) +
                 UpperCase(MoveDataStr(pTESntFaxTlx(Item2).AccName,  61)) +
                 UpperCase(MoveDataStr(pTESntFaxTlx(Item2).RcvCompKor, 61)) +
                 pTESntFaxTlx(Item2).NatCode + pTESntFaxTlx(Item2).MediaNo;
   end  else  // Acc Identification + AccNo
   begin
      StdStr1 := pTESntFaxTlx(Item1).AccGrpType +
                 MoveDataStr(pTESntFaxTlx(Item1).AccId, 6) +
                 MoveDataStr(pTESntFaxTlx(Item1).AccNo, 21) +
                 MoveDataStr(pTESntFaxTlx(Item1).SubAccNo,5) +
                 UpperCase(MoveDataStr(pTESntFaxTlx(Item1).AccName,  61)) +
                 UpperCase(MoveDataStr(pTESntFaxTlx(Item1).RcvCompKor, 61)) +
                 pTESntFaxTlx(Item1).NatCode + pTESntFaxTlx(Item1).MediaNo;

      StdStr2 := pTESntFaxTlx(Item2).AccGrpType +
                 MoveDataStr(pTESntFaxTlx(Item2).AccId, 6) +
                 MoveDataStr(pTESntFaxTlx(Item2).AccNo, 21) +
                 MoveDataStr(pTESntFaxTlx(Item2).SubAccNo, 5) +
                 UpperCase(MoveDataStr(pTESntFaxTlx(Item2).AccName,  61)) +
                 UpperCase(MoveDataStr(pTESntFaxTlx(Item2).RcvCompKor, 61)) +
                 pTESntFaxTlx(Item2).NatCode + pTESntFaxTlx(Item2).MediaNo;
   end;

   case SntFaxTlxSortIdx of
      // 계좌번호
      1:
      begin
         sCompareStr1 := '';
         sCompareStr2 := '';
      end;
      // 계좌명
      2:
      begin
         sCompareStr1 := UpperCase(pTESntFaxTlx(Item1).AccName);
         sCompareStr2 := UpperCase(pTESntFaxTlx(Item2).AccName);
      end;
      // 수신처
      3:
      begin
         sCompareStr1 := UpperCase(pTESntFaxTlx(Item1).RcvCompKor);
         sCompareStr2 := UpperCase(pTESntFaxTlx(Item2).RcvCompKor);
      end;
      // 번호
      4:
      begin
        sCompareStr1 := MoveDataStr(pTESntFaxTlx(Item1).NatCode, 3)
                      + MoveDataStr(pTESntFaxTlx(Item1).MediaNo, 65);
        sCompareStr2 := MoveDataStr(pTESntFaxTlx(Item2).NatCode, 3)
                      + MoveDataStr(pTESntFaxTlx(Item2).MediaNo, 65);

      end
      else
      begin
         Result := 0;
         Exit;
      end;
   end;  // end of case

   ComporeStrLenSame(sCompareStr1, sCompareStr2);

   Result := gf_ReturnStrComp(sCompareStr1 + StdStr1, sCompareStr2 + StdStr2,
                              SntFaxTlxSortFlag[SntFaxTlxSortIdx]);

end;

//------------------------------------------------------------------------------
//  SntFaxTlxList의 FreqList Sorting
//------------------------------------------------------------------------------
function FreqFaxTlxListCompare(Item1, Item2: Pointer): Integer;
begin
   Result := gf_ReturnFloatComp(pTEFreqFaxTlx(Item1).FreqNo,
                                pTEFreqFaxTlx(Item2).FreqNo, False);
end;


//------------------------------------------------------------------------------
//  SndMailList Sorting
//------------------------------------------------------------------------------
function SndMailListCompare(Item1, Item2: Pointer): Integer;
var
   TmpStr1, TmpStr2: string;
   StdStr1, StdStr2: string;
   sCompareStr1, sCompareStr2: string;
   i : integer;
begin
   StdStr1 := pTFSndMail(Item1).AccGrpType
            + UpperCase(MoveDataStr(pTFSndMail(Item1).AccGrpName, 61))
            + UpperCase(MoveDataStr(pTFSndMail(Item1).MailFormName, 61));

   StdStr2 := pTFSndMail(Item2).AccGrpType
            + UpperCase(MoveDataStr(pTFSndMail(Item2).AccGrpName, 61))
            + UpperCase(MoveDataStr(pTFSndMail(Item2).MailFormName, 61));

   case SndMailSortIdx of
      // 그룹명/계좌명
      1: begin
           sCompareStr1 := '';
           sCompareStr2 := '';
         end;
      // 수신처
      2: begin
            TmpStr1 := '';
            for i := 0 to pTFSndMail(Item1).MailRcv.Count -1 do
            begin
               TmpStr1 := TmpStr1 + pTFSndMail(Item1).MailRcv.Strings[i];
            end;
            TmpStr2 := '';
            for i := 0 to pTFSndMail(Item2).MailRcv.Count -1 do
            begin
               TmpStr2 := TmpStr2 + pTFSndMail(Item2).MailRcv.Strings[i];
            end;

            sCompareStr1 := TmpStr1;
            sCompareStr2 := TmpStr2;
         end;
      // 제목
      3: begin
            sCompareStr1 := UpperCase(pTFSndMail(Item1).SubjectData);
            sCompareStr2 := UpperCase(pTFSndMail(Item2).SubjectData);
         end;
      // 메일서식
      4: begin
            sCompareStr1 := UpperCase(pTFSndMail(Item1).MailFormName);
            sCompareStr2 := UpperCase(pTFSndMail(Item2).MailFormName);
         end;
       // 서버전송확인
      5: begin
            TmpStr1 := '';
            if pTFSndMail(Item1).SendFlag then
            begin
               if pTFSndMail(Item1).CancFlag then TmpStr1 := gwRSPCancel
               else if Trim(pTFSndMail(Item1).ErrMsg) <> '' then TmpStr1 := gwRSPError
               else TmpStr1 := gwRSPOK;
            end;
            TmpStr2 := '';
            if pTFSndMail(Item2).SendFlag then
            begin
               if pTFSndMail(Item2).CancFlag then TmpStr2 := gwRSPCancel
               else if Trim(pTFSndMail(Item2).ErrMsg) <> '' then TmpStr2 := gwRSPError
               else TmpStr2 := gwRSPOK;
            end;

            sCompareStr1 := TmpStr1;
            sCompareStr2 := TmpStr2;
         end;

      6:  // Edit
      begin
         TmpStr1 := '';
         if pTFSndMail(Item1).EditFlag then TmpStr1 := gcUSER_DEF_MARK;
         TmpStr2 := '';
         if pTFSndMail(Item2).EditFlag then TmpStr2 := gcUSER_DEF_MARK;

         sCompareStr1 := TmpStr1;
         sCompareStr2 := TmpStr2;
      end
      else
      begin
         Result := 0;
         Exit;
      end;
   end;  // end of case

   ComporeStrLenSame(sCompareStr1, sCompareStr2);

   Result := gf_ReturnStrComp(sCompareStr1 + StdStr1, sCompareStr2 + StdStr2,
                              SndMailSortFlag[SndMailSortIdx]);

end;

//------------------------------------------------------------------------------
//  SntMailLists Sorting
//------------------------------------------------------------------------------
function SntMailListCompare(Item1, Item2: Pointer): Integer;
var
   StdStr1, StdStr2: string;
begin
   StdStr1 := pTSntMail(Item1).AccGrpType + MoveDataStr(pTSntMail(Item1).AccGrpName, 61);
   StdStr2 := pTSntMail(Item2).AccGrpType + MoveDataStr(pTSntMail(Item2).AccGrpName, 61);

   case SntMailSortIdx of
      // 그룹명/계좌명
      1: Result := gf_ReturnStrComp(StdStr1, StdStr2,
                                    SntMailSortFlag[SntMailSortIdx]);
      // 수신처
{
      3: begin
            TmpStr1 := '';
            for i := 0 to pTSntMail(item1).FreqList.Count -1 do
            begin
               TmpStr1  := TmpStr1 + pTFreqMail(item1).RcvMailName;
            end;
            TmpStr2 := '';
            for i := 0 to pTSntMail(item2).FreqList.Count -1 do
            begin
               TmpStr2  := TmpStr2 + pTFreqMail(item2).RcvMailName;
            end;
            gf_ReturnStrComp(TmpStr1 + StdStr1,
                             TmpStr2 + StdStr2,
                             SndMailSortFlag[SndMailSortIdx]);
         end;

      // 제목
      4: begin
            TmpStr1 := '';
            for j := 0 to pTSntMail(Item1).FreqList.Count -1 do
            begin
               TmpStr1 := TmpStr1 + pTSntMail(Item1).
            end;
            TmpStr2 := '';
            for i := 0 to pTFSndMail(Item2).MailRcv.Count -1 do
            begin
               TmpStr2 := TmpStr2 + pTFSndMail(Item2).MailRcv.Strings[i];
            end;
            gf_ReturnStrComp(TmpStr1 + StdStr1,
                             TmpStr2 + StdStr2,
                             SndMailSortFlag[SndMailSortIdx]);
         end;
}        else
         Result := 0;
   end;  // end of case
end;

//------------------------------------------------------------------------------
//  SntMailList의 FreqList Sorting
//------------------------------------------------------------------------------
function FreqMailListCompare(Item1, Item2: Pointer): Integer;
begin
   Result := gf_ReturnFloatComp(pTFreqMail(Item1).FreqNo,
                                pTFreqMail(Item2).FreqNo, False);
end;

//------------------------------------------------------------------------------
//  일자 변경 데이터 갱신
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.OnRcvChangeJobDate(var msg: TMessage);
begin
   DRBitBtn4Click(DRBitBtn4);  // 갱신 버튼 클릭
end;

//------------------------------------------------------------------------------
//  On Receive MailResult
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.OnRcvMailResult(var msg: TMessage);
//--- FreqItem에 MailResult Copy
procedure UpdateFreqItem(FreqItem: pTFreqMail; EMailResult: ptTEMailResult);
begin
   FreqItem.RSPFlag      := gf_StrToInt(gvptEMailResult.sRspCode);
   FreqItem.SendTime     := gvptEMailResult.sSendTime;
   FreqItem.SentTime     := gvptEMailResult.sSentTime;
   FreqItem.ErrCode      := Trim(gvptEMailResult.sErrCode);
   FreqItem.ErrMsg       := Trim(gvptEMailResult.sErrMsg);
   FreqItem.ExtMsg       := Trim(gvptEMailResult.sExtMsg);
   FreqItem.OprId        := Trim(gvptEMailResult.sOprId);
   FreqItem.OprTime      := Trim(gvptEMailResult.sOprTime);  //2004.03.03
end;

var
   SntItem  : pTSntMail;
   FreqItem : pTFreqMail;
   I, K, iCurTotSeqNo: Integer;
   sSecType : string;
begin
   if gvptEMailResult.sCurDate <> gvCurDate then Exit;
   sSecType := copy(gvptEMailResult.sMailFormGrp, 1, 1); //반드시 첫번째꺼만 써야해.. 두번째자리는 _만 넣었어. real gajja push가!!
   if sSecType <> gcSEC_EQUITY then Exit; // 주식업무 아닌 경우
   if FThreadHoldFlag then Exit;

   iCurTotSeqNo := gf_StrToInt(Trim(gvptEMailResult.sSeqNo));

   try
      for I := 0 to SntMailList.Count -1 do
      begin
         SntItem := SntMailList.Items[I];
         for K := 0 to SntItem.FreqList.Count -1 do
         begin
            FreqItem := SntItem.FreqList.Items[K];
            if FreqItem.CurTotSeqNo = iCurTotSeqNo then   // List Update
            begin
               //2004.03.03 start =================================================
               //기존 List보다 늦게 도착한 것은 Skip
               if FreqItem.OprTime > String(gvptEMailResult.sOprTime) then Exit;
               //2004.03.03 end ===================================================

               UpdateFreqItem(FreqItem, gvptEMailResult);   // Update FreqItem

               // Display SntFaxTlxList Item
               if (DRPageControl_Main.ActivePage.PageIndex = gcPAGE_IDX_EMAIL)  then //Email 조회 중
                   DisplayFreqMailItem(SntItem, FreqItem);

               Exit;
            end;  // end of if
         end;  // end of for K
      end;  // end of for I
   except
      on E:Exception do
      begin
         gf_Log('on rcv mail exception..' + E.Message);
      end;
   end;
end;

//------------------------------------------------------------------------------
//  On Receive FaxTlxResult
//  도치시 팝업띄우는 것 일단 막음 : 2004.03.03
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.OnRcvFaxTlxResult(var msg: TMessage);
var
   SntItem  : pTESntFaxTlx;
   FreqItem : pTEFreqFaxTlx;
   iRspFlag, iCurTotSeqNo: Integer;
   I, K, iPopFlag : Integer; //2004.01.15 추가
begin
   if not Assigned(SntFaxTlxList) then Exit;
   if gvpTFAXResult.sCurDate <> gvCurDate then Exit;
   if gvpTFAXResult.sSecCode <> gcSEC_EQUITY then Exit; // 주식업무 아닌 경우
   if FThreadHoldFlag then Exit;

   iRspFlag     := gf_StrToInt(gvpTFAXResult.sRspCode);
   iCurTotSeqNo := gf_StrToInt(Trim(gvpTFAXResult.sSeqNo));

   try
      for I := 0 to SntFaxTlxList.Count -1 do
      begin
         SntItem := SntFaxTlxList.Items[I];
         for K := 0 to SntItem.FreqList.Count -1 do
         begin
            FreqItem := SntItem.FreqList.Items[K];
            if FreqItem.CurTotSeqNo = iCurTotSeqNo then   // List Update
            begin
               //2004.03.03 start =================================================
               //기존 List보다 늦게 도착한 것은 Skip
               if FreqItem.OprTime > String(gvpTFAXResult.sOprTime) then Exit;

               FreqItem.RSPFlag      := iRspFlag;
               FreqItem.SendTime     := gvpTFAXResult.sSendTime;
               FreqItem.SentTime     := gvpTFAXResult.sRecvTime;
               FreqItem.DiffTime     := gf_StrToInt(gvpTFAXResult.sDiffTime);
               FreqItem.SendPageCnt  := gf_StrToInt(gvpTFAXResult.sCurrPage);
               FreqItem.BusyResndCnt := gf_StrToInt(gvpTFAXResult.sBusyCnt);
               FreqItem.ErrCode := gvpTFAXResult.sErrCode;
               FreqItem.ErrMsg  := Trim(gvpTFAXResult.sErrMsg);
               FreqItem.ExtMsg  := Trim(gvpTFAXResult.sExtMsg);
               FreqItem.OprId   := Trim(gvpTFAXResult.sOprId);
               FreqItem.OprTime := gvpTFAXResult.sOprTime; //2004.03.03

               // Display SntFaxTlxList Item
               if DRPageControl_Main.ActivePage.PageIndex = gcPAGE_IDX_FAXTLX then // Fax/Tlx 조회 중
                  DisplayFreqFaxTlxItem(SntItem, FreqItem);

               Exit;
            end;  // end of if
         end;  // end of for K
      end;  // end of for I
   except
      on E:Exception do
      begin
         gf_Log('onrcv fax Exception..' + E.Message); //안죽어.
      end;
   end; //try
end;

//------------------------------------------------------------------------------
//  매체 변경
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.SelectSendMtd(pSendMtd: string);
begin
   if (pSendMtd = gcSEND_FAX) or (pSendMtd = gcSEND_TLX) then
      DRPageControl_Main.ActivePage := DRPageControl_Main.Pages[gcPAGE_IDX_FAXTLX]
   else if pSendMtd = gcSEND_EMAIL then
      DRPageControl_Main.ActivePage := DRPageControl_Main.Pages[gcPAGE_IDX_EMAIL];
end;

procedure TForm_SCFH8801_SND.FormCreate(Sender: TObject);
  //--- Clear & Default Setting StrGrid
  procedure DefClearStrGrid(pStrGrid: TDRStringGrid);
  begin
     with pStrGrid do
     begin
        Color             := gcGridBackColor;
        SelectedCellColor := gcGridSelectColor;
        RowCount := 2;
        Rows[1].Clear;
     end;  // end of with
  end;
var
   I, iActPageIdx : Integer;
   iAccTypeIdx, iChkStat : Integer;
begin
  inherited;

  FreeLoadXXX;

  FThreadHoldFlag := false;

  sFaxResultRcvLastTime := ''; //@@
  sEmailResultRcvLastTime := '';

  bSndOnlyViewFlag := False; // 전체 보기
  bSntOnlyViewFlag := False; // 전체 보기

  // 사번 ComboBox 셋팅
  fn_MakeEmpCombo;

  // 생성 시간
  DRMaskEdit_Time.Text := '00:00';

  // 게좌번호 ComboBox 셋팅
  fn_MakeAccCombo;

  // 전송대상 - 미전송 내역만(초기 - Check)
  bNotSend := True;
  DRCheckBox_NotSnd.Checked := bNotSend;

  // 전송대상 - 전송구분
  DRRadioButton_SndType_ALL.Checked;

  // 전송대상 - 컬럼 정렬 옵션 ComboBox 셋팅
  fn_MakeColOrdCombo;

  // 당일송신확인 - 전송구분
  DRRadioButton_SntType_ALL.Checked;

  // 당일송신확인 - Process
  DRRadioButton_Prc_ALL.Checked;

  // 전송대상 컬럼 순서 셋팅
  SetColOpt;

  // [L.J.S]
  DefSetSndStrGrid;
  DefSetSntStrGrid;

  DefClearStrGrid(DRStrGrid_Snd);
  DefClearStrGrid(DRStrGrid_Snt);

  //=== List 생성
  SndList := TList.Create;
  SntList := TList.Create;

  if (not Assigned(SndList)) or (not Assigned(SntList)) then
  begin
     gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); //List 생성 오류
     Close;
     Exit;
  end;
  
//   Fax
//  SndFaxTlxSortIdx := SND_FAXTLX_ACCNO_IDX;     // 계좌번호순 Sorting
//  SndFaxTlxSortFlag[SndFaxTlxSortIdx] := true;  // Ascending
//  SntFaxTlxSortIdx := SNT_FAXTLX_ACCNO_IDX;     // 계좌번호순 Sorting
//  SntFaxTlxSortFlag[SntFaxTlxSortIdx] := true;  // Ascending
//  SndFaxTlxSelected := True;
//  DRStrGrid_SndFaxTlx.Cells[SELECT_IDX, 0] := gcSEND_MARK;
//  SntFaxTlxSelected := True;
//  DRStrGrid_SntFaxTlx.Cells[SELECT_IDX, 0] := gcSEND_MARK;
//  FaxTlxTotFreqChecked := '';
//
//  --- EMail
//  SndMailSortIdx := SND_MAIL_ACCGRP_IDX;     // 그룹명순 Sorting
//  SndMailSortFlag[SndMailSortIdx] := true;   // Desc : 그룹이 먼저 나와야 함
//  SntMailSortIdx := SNT_MAIL_ACCGRP_IDX;     // 계좌명순 Sorting
//  SntMailSortFlag[SntMailSortIdx] := true;   // Desc : 그룹이 먼저 나와야 함
//  SndMailSelected := True;
//  DRStrGrid_SndMail.Cells[SELECT_IDX, 0] := gcSEND_MARK;
//  SntMailSelected := True;
//  DRStrGrid_SntMail.Cells[SELECT_IDX, 0] := gcSEND_MARK;

  //RealThread Sleep 초... Defalut 5초
  iRealThreadSleepSeconds := StrToInt( gf_GetSystemOptionValue('S03','5') );

  sGridSelectAllYN := 'Y';

  //Real Thread 사용여부
  sRealThreadUseYN := gf_GetSystemOptionValue('S05','Y');

  {if sRealThreadUseYN = 'Y' then
  begin
     RealThread := nil;
     RealThread := T2TRealThread.Create;
     if RealThread <> nil then
     begin
       RealThread.priority:=tpNormal;
       RealThread.FreeOnTerminate := True;
       RealThread.Resume;   // RealThread.Execute 실행
     end
     else
     begin
        ShowMessage('RealThread not Create');
        Exit;
     end;
  end;     }

  //Report Query Stored Procedure 사용 여부 Defalut N
  gvRptQueryUseSPYN := gf_GetSystemOptionValue('S18','N');
  EnvSetupInfo := TIniFile.Create(gvDirCfg + gcMainIniFileName);
end;

procedure TForm_SCFH8801_SND.FormClose(Sender: TObject; var Action: TCloseAction);
var
   iAccTypeIdx, iChkStat : Integer;
begin
  inherited;

   if sRealThreadUseYN = 'Y' then fnThreadKilled(RealThread,True); //@@

   //=== Clear List
   ClearSntFaxList;
   ClearSntMailList;

//   ClearSndNoneList;
   ClearSndList;
   ClearSnTList;

   //=== Free List
   if Assigned(SndFaxTlxList) then SndFaxTlxList.Free;
   if Assigned(SntFaxTlxList) then SntFaxTlxList.Free;
   if Assigned(SndMailList)   then SndMailList.Free;
   if Assigned(SntMailList)   then SntMailList.Free;
//   if Assigned(SndNoneList)   then SndNoneList.Free;

   if Assigned(SndList)   then SndList.Free;
   if Assigned(SntList)   then SntList.Free;

   FreeAndNil(EnvSetupInfo);

   Form_SCFH8801_SND := nil;

end;

//------------------------------------------------------------------------------
//  화면 Clear
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.ClearScreen;
begin
   // Clear Fax/Tlx관련 List
   ClearSndList;
   ClearSnTList;

   case DRPageControl_Main.ActivePage.PageIndex of
      gcPAGE_IDX_FAXTLX:  // Fax/Tlx
      begin
         if gvDeptCode <> gcDEPT_CODE_CORP then
            DRStrGrid_SndFaxTlx.ColWidths[9] := -1;

         DRStrGrid_SndFaxTlx.RowCount := 2;
         DRStrGrid_SndFaxTlx.Rows[1].Clear;
         DRStrGrid_SntFaxTlx.RowCount := 2;
         DRStrGrid_SntFaxTlx.Rows[1].Clear;
      end;
      gcPAGE_IDX_EMAIL: // EMail
      begin
      end;
   end; // end of case
end;

//------------------------------------------------------------------------------
//  선택 내역 전송
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRBitBtn3Click(Sender: TObject);
var
   I, K : Integer;
   iTotCnt, iProcessCnt, iErrorCnt : Integer;
   SndItem : pTESndFaxTlx;
   MailItem   : pTFSndMail;
   sCurAccNo, sCurSubAccNo, sCurReportId : string;
   sCurNatCode, sCurMediaNo : string;
   CurAmendYN : Boolean;
   CurPSStringList, CurLPSStringList, CurRPSStringList, SndItemIdxList : TStringList;
   iReportIdx : integer;
   sSendDlgMsg: string;
   bTradeTodayCheck : Boolean;
begin
   inherited;

   FreeLoadXXX ;

   bTradeTodayCheck := False;

   //=== 총전송건수 계산
   iTotCnt := 0;
   case DRPageControl_Main.ActivePage.PageIndex of
      gcPAGE_IDX_FAXTLX:  // Fax/Tlx
      begin
         for I := 0 to SndFaxTlxList.Count -1 do
         begin
            SndItem := SndFaxTlxList.Items[I];
            if SndItem.Selected then Inc(iTotCnt);
         end;
      end;

      gcPAGE_IDX_EMAIL: // EMail
      begin
         //초반부터 아예 막는다.
         if not gvSendMailFlag then
         begin
            gf_ShowDlgMessage(Self.Tag, mtWarning, 1149,'', [mbOK], 0);                 //서버의 메일 설정 정보가 없습니다.
            exit;
         end;

         for I := 0 to SndMailList.Count -1 do
         begin
            MailItem := SndMailList.Items[I];
            if MailItem.Selected then Inc(iTotCnt);
         end;
      end;
   end; // end of case

   if iTotCnt <= 0 then
   begin
      gf_ShowMessage(MessageBar, mtInformation, 1009, '');  // 선택 항목이 없습니다.
      Exit;
   end;

   // Confirm - 정말 전송하시겠습니까?
   if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 1143, '', [mbYes, mbNo], 0) <> IDYES then
   begin
      gf_ShowMessage(MessageBar, mtInformation, 1082, '');  // 작업이 취소되었습니다.
      Exit;
   end;

   if EnvSetupInfo.ReadString(IntToStr(Self.Tag), 'TradeTodayCheck', 'N') = 'Y' then
   begin
     if gvCurDate <> ParentForm.JobDate then
       bTradeTodayCheck := True;
   end;

   ///////////////////////////////////////////////////////////////////////
   //  2014.11.04  psh 전송전 계좌 체크 해서 메시지 띄우기
   ///////////////////////////////////////////////////////////////////////

   //=== 매체별 전송
   case DRPageControl_Main.ActivePage.PageIndex of
      gcPAGE_IDX_FAXTLX:  // Fax/Tlx
      begin
         if gvRealLogYN = 'Y' then gf_Log('전송FAXALL>> Start');
         gf_ShowMessage(MessageBar, mtInformation, 1072, ''); // 전송 중입니다.
         SndItemIdxList   := TStringList.Create;   // 동일 계좌별 처리 리스트
         CurPSStringList  := TStringList.Create;   // PSStringList를 비교하기 위한 변수
         CurLPSStringList := TStringList.Create;   // Left PSStringList를 비교하기 위한 변수
         CurRPSStringList := TStringList.Create;   // Right PSStringList를 비교하기 위한 변수
         if (not Assigned(SndItemIdxList)) or (not Assigned(CurPSStringList)) then
         begin
            gf_ShowMessage(MessageBar, mtError, 9004, '');  // List 생성 오류
            Exit;
         end;

         DisableForm;
         gf_DisableSRMgrFrame(ParentForm);
         //Report Index Clear  ☆★중요
         for I := 0 to SndFaxTlxList.Count -1 do
         begin
            SndItem := SndFaxTlxList.Items[I];
            SndItem.ReportIdx := -1;    //전송될 동일 레포트
            SndItem.RIdxSeqNo := -1;    //전송된 동일 레포트
         end;

         // 전송 확인 메세지 출력.
         sSendDlgMsg := '';
         if bTradeTodayCheck then
         begin
           sSendDlgMsg := sSendDlgMsg + '당일 매매내역이 아닙니다.' + #13#10;

           if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 0,
                sSendDlgMsg + #13#10 + '전송하시겠습니까?', mbOKCancel, 0) = idCancel then
           begin
             EnableForm;
             gf_EnableSRMgrFrame(ParentForm);
             gf_ShowMessage(MessageBar, mtInformation, 1082, ''); // 작업이 취소되었습니다.
             Exit;
           end;
         end;

         // 동일레포트 Idx 생성 (같은 List 이중  Loop)
         iReportIdx := 0;
         for I := 0 to SndFaxTlxList.Count -1 do
         begin
            SndItem := SndFaxTlxList.Items[I];
            if not SndItem.Selected then Continue;
            // 그룹인경우 동일레포트 처리 안함..
            if SndItem.AccGrpType = gcRGroup_GRP then Continue;

            if SndItem.ReportIdx <= 0 then   //이전에 나랑 똑같은 보고서가 없었다.
            begin
               Inc(iReportIdx, 1);  //1부터 시작
               SndItem.ReportIdx := iReportIdx;
               sCurAccNo    := SndItem.AccNo;
               sCurSubAccNo := SndItem.SubAccNo;
               sCurReportId := SndItem.ReportId;
               CurPSStringList.Assign(SndItem.PSList.PSStringList);
               CurLPSStringList.Assign(SndItem.PSList.L_PSStringList);
               CurRPSStringList.Assign(SndItem.PSList.R_PSStringList);
               CurAmendYN := SndItem.InsertAmd;

               for K := I + 1  to SndFaxTlxList.Count - 1 do
               begin
                  SndItem      := SndFaxTlxList.Items[K];
                  if not SndItem.Selected then Continue;
                  if SndItem.AccGrpType = gcRGroup_GRP then Continue;

                  // 동일 계좌 동일 레포트 동일 PS 그룹 처리
                  if (SndItem.AccNo     = sCurAccNo)    and
                     (SndItem.SubAccNo  = sCurSubAccNo) and
                     (SndItem.ReportId  = sCurReportId) and
                     (SndItem.InsertAmd = CurAmendYN)   and
                     (gf_IsSameStringList(SndItem.PSList.PSStringList,   CurPSStringList)) and
                     (gf_IsSameStringList(SndItem.PSList.L_PSStringList, CurLPSStringList)) and
                     (gf_IsSameStringList(SndItem.PSList.R_PSStringList, CurRPSStringList)) then
                  begin
                     SndItem.ReportIdx := iReportIdx;
                  end;
               end; // end of for K
            end;
         end; // end of for I

         // 수신처별 전송
         ShowProcessPanel(gwSendMsg, iTotCnt, False, True);
         iProcessCnt := 0;
         iErrorCnt   := 0;
         FThreadHoldFlag := true;
         for I := 0 to SndFaxTlxList.Count -1 do
         begin
            SndItem := SndFaxTlxList.Items[I];
            if not SndItem.Selected then Continue;

            SndItemIdxList.Clear;
            SndItem.Selected := False;
            SndItemIdxList.Add(IntToStr(I));
            sCurNatCode := SndItem.NatCode;
            sCurMediaNo := SndItem.MediaNo;

            for K := I + 1 to SndFaxTlxList.Count -1 do
            begin
               SndItem := SndFaxTlxList.Items[K];
               if not SndItem.Selected then Continue;

               // 동일 수신처 처리
               if (SndItem.NatCode = sCurNatCode) and
                  (SndItem.MediaNo = sCurMediaNo) then
               begin
                  SndItem.Selected := False;
                  SndItemIdxList.Add(IntToStr(K));
               end;
            end;  // end of for K

            Inc(iProcessCnt, SndItemIdxList.Count);
            IncProcessPanel(iProcessCnt, SndItemIdxList.Count);
//            if gvRealLogYN = 'Y' then gf_Log('전송FAXALL>> ' + IntToStr(I) + '/' + IntToStr(iProcessCnt) + '전송전');
            if not SendFaxTlx(SndItemIdxList) then
            begin
//               if gvRealLogYN = 'Y' then gf_Log('전송FAXALL>> 전송오류 ErrorProcessPanel전' + gf_ReturnMsg(gvErrorNo));
               ErrorProcessPanel(gf_ReturnMsg(gvErrorNo) , False);
               Inc(iErrorCnt, SndItemIdxList.Count);
//               if gvRealLogYN = 'Y' then gf_Log('전송FAXALL>> 전송오류' + IntToStr(iErrorCnt) + gf_ReturnMsg(gvErrorNo));
            end;

            sleep(1000); //@@
         end; // end of for I

         SndFaxTlxSelected := False;  // All Not Selected
         DRStrGrid_SndFaxTlx.Cells[SELECT_IDX, 0] := '';
         if Assigned(SndItemIdxList)   then SndItemIdxList.Free;
         if Assigned(CurPSStringList)  then CurPSStringList.Free;
         if Assigned(CurLPSStringList) then CurLPSStringList.Free;
         if Assigned(CurRPSStringList) then CurRPSStringList.Free;

         if iErrorCnt > 0 then // 오류 발생
         begin
            ErrorProcessPanel(gwSendErrMsg +  '(총' + IntToStr(iErrorCnt) + '건), '
                + gwClickOKMsg , True);
            gf_ShowMessage(MessageBar, mtError, 1073, '');    // 전송 중 오류 발생
         end else
         begin
            HideProcessPanel;
            EnableForm;
            gf_EnableSRMgrFrame(ParentForm);
            gf_ShowMessage(MessageBar, mtInformation, 1013, ''); // 전송 완료
         end;
         FThreadHoldFlag := false;
//         if gvRealLogYN = 'Y' then gf_Log('전송FAXALL>> END');
      end;

      gcPAGE_IDX_EMAIL: // EMail
      begin
         gf_ShowMessage(MessageBar, mtInformation, 1072, '');  //전송  중입니다.
         SndItemIdxList  := TStringList.Create;                // 동일 파일별 처리 리스트
         if (not Assigned(SndItemIdxList))  then
         begin
            gf_ShowMessage(MessageBar, mtError, 9004, '');     // List 생성 오류
            Exit;
         end;

         DisableForm;
         gf_DisableSRMgrFrame(ParentForm);

         // 전송 확인 메세지 출력.
         sSendDlgMsg := '';
         if bTradeTodayCheck then
         begin
           sSendDlgMsg := sSendDlgMsg + '당일 매매내역이 아닙니다.' + #13#10;

           if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 0,
                sSendDlgMsg + #13#10 + '전송하시겠습니까?', mbOKCancel, 0) = idCancel then
           begin
             EnableForm;
             gf_EnableSRMgrFrame(ParentForm);
             gf_ShowMessage(MessageBar, mtInformation, 1082, ''); // 작업이 취소되었습니다.
             Exit;
           end;
         end;

         // 전송 대상 목록 생성 후 파일 갯수 체크.
         SndItemIdxList.Clear;
         for I := 0 to SndMailList.Count - 1 do
         begin
           MailItem := SndMailList.Items[I];
           if not MailItem.Selected then Continue;

           SndItemIdxList.Add(IntToStr(I));
         end;

         if not EmailManyFileCheck(SndItemIdxList) then
         begin
           EnableForm;
           gf_EnableSRMgrFrame(ParentForm);
           gf_ShowMessage(MessageBar, mtInformation, 1082, ''); // 작업이 취소되었습니다.
           Exit;
         end;
         
//         ShowProcessPanel(gwSendMsg, iTotCnt, False, True);
         iProcessCnt := 0;
         iErrorCnt   := 0;
         FThreadHoldFlag := true;
         for I := 0 to SndMailList.Count -1 do
         begin
            MailItem := SndMailList.Items[I];
            if not MailItem.Selected then Continue;

            SndItemIdxList.Clear;
            MailItem.Selected := False;
            SndItemIdxList.Add(IntToStr(I));

            ShowProcessPanel(gwCreFileMsg, iTotCnt, False, True);
            Inc(iProcessCnt);
            IncProcessPanel(iProcessCnt, SndItemIdxList.Count);

            if not SendEMail(SndItemIdxList) then
            begin
//               ErrorProcessPanel(gf_ReturnMsg(gvErrorNo) , False);
               Inc(iErrorCnt, SndItemIdxList.Count);
            end else
            begin
               ShowProcessPanel(gwSendMsg, iTotCnt, False, True);
               IncProcessPanel(iProcessCnt, SndItemIdxList.Count);
            end;
         end; // end of for I

         SndMailSelected := False;  // All Not Selected
         DRStrGrid_SndMail.Cells[SELECT_IDX, 0] := '';
         if Assigned(SndItemIdxList) then SndItemIdxList.Free;

         if iErrorCnt > 0 then // 오류 발생
         begin
            ErrorProcessPanel(gwCreFileErrMsg +  '(총' + IntToStr(iErrorCnt) + '건), '
                + gwClickOKMsg , True);
            gf_ShowMessage(MessageBar, mtError, 1073, '');   // 전송 중 오류 발생
         end  else
         begin
            HideProcessPanel;
            EnableForm;
            gf_EnableSRMgrFrame(ParentForm);
            gf_ShowMessage(MessageBar, mtInformation, 1013, ''); // 전송 완료
         end;
         FThreadHoldFlag := false;
      end;
   end; // end of case
end;

//------------------------------------------------------------------------------
//  전송 제외 내역
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRBitBtn2Click(Sender: TObject);
begin
  inherited;
   gvB2802Data.iQueryIdx  := 3;  // 전송 제외 내역 조회
   gf_CreateForm(2802); // 주식 매매 체결 조회 화면 Create
end;

//------------------------------------------------------------------------------
//  Process Panel의 확인 버튼 클릭
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.ProcPanel_BitBtn_ConfirmClick(Sender: TObject);
begin
  inherited;
end;

//------------------------------------------------------------------------------
//  Clear SndEMailList
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.ClearSntMailList;
var
   I, K, L : Integer;
   SntItem  : pTSntMail;
   FreqItem : pTFreqMail;
   FileItem : pTAttFile;
begin
   if not Assigned(SntMailList) then Exit;
   for I := 0 to SntMailList.Count -1 do
   begin
      SntItem := SntMailList.Items[I];
      if Assigned(SntItem.FreqList) then
      begin
         for K := 0 to SntItem.FreqList.Count -1 do
         begin
            FreqItem := SntItem.FreqList.Items[K];
            if Assigned(FreqItem.AccList)     then FreqItem.AccList.Free;
            if Assigned(FreqItem.AttFileList) then
            begin
               for L := 0 to FreqItem.AttFileList.Count -1 do
               begin
                  FileItem := FreqItem.AttFileList.Items[L];
                  Dispose(FileItem);
               end;
               FreqItem.AttFileList.Free;
            end;
            Dispose(FreqItem);
         end;  // end of for
         SntItem.FreqList.Free;
      end; // end of if
      Dispose(SntItem);
   end; // end of for K
   SntMailList.Clear;
end;


//------------------------------------------------------------------------------
//  조건에 맞는 Default PSStringList Setting
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.SetDefaultPSStringList(SrcItem: pTESndFaxTlx);
var
   I : Integer;
   DesItem  : pTESndFaxTlx;
begin
   for I := 0 to SndFaxTlxList.Count -1 do
   begin
      DesItem := SndFaxTlxList.Items[I];
      if (DesItem.AccNo = SrcItem.AccNo) and
         (DesItem.SubAccNo = SrcItem.SubAccNo) and
         (DesItem.GridRowIdx <> SrcItem.GridRowIdx) then  // 원본 데이터 제외한 계좌 Searching
      begin
         if (DesItem.PSList.PSStringList.Count > 0 ) then  // P.S입력이 있는 경우
         begin
            SrcItem.PSList.PSStringList.Assign(DesItem.PSList.PSStringList);
            Exit;
         end else
         if (DesItem.PSList.L_PSStringList.Count > 0 ) then  // Left P.S입력이 있는 경우
         begin
            SrcItem.PSList.L_PSStringList.Assign(DesItem.PSList.L_PSStringList);
            Exit;
         end; // end of if
         if (DesItem.PSList.R_PSStringList.Count > 0 ) then  // Right P.S입력이 있는 경우
         begin
            SrcItem.PSList.R_PSStringList.Assign(DesItem.PSList.R_PSStringList);
            Exit;
         end; // end of if
      end;  // end of if
   end;  // end of for
end;

//------------------------------------------------------------------------------
//  Fax/Tlx Send 후 SntFaxTlxList에 New Item 추가 및 Display
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.AddSntFaxTlxList(SndItem: pTESndFaxTlx;
                                    pTotPageCnt: Integer; pTxtUnitInfo: string);
var
   I, iLastFreqNo : Integer;
   SntItem : pTESntFaxTlx;
   FreqItem : pTEFreqFaxTlx;
   ExistFlag : boolean;
begin
   SntItem := nil;
   iLastFreqNo := 0;
   ExistFlag := False;
   // 기존에 존재하는지 확인
   //그룹별
   if SndItem.AccGrpType = gcRGROUP_GRP then
   begin
      for I := 0 to SntFaxTlxList.Count -1 do
      begin
         SntItem := SntFaxTlxList.Items[I];

         if (SndITem.AccGrpType = SntITem.AccGrpType) and
            (SndItem.AccName    = SntItem.AccName) and
            (SndItem.SendMtd = SntItem.FaxTlxGbn) and
            (SndItem.NatCode = SntItem.NatCode) and
            (SndItem.MediaNo = SntItem.MediaNo) then
         begin
            ExistFlag := True;
            FreqItem := SntItem.FreqList.Items[0];  // 마지막 회차 정보
            iLastFreqNo := FreqItem.FreqNo;
            break;
         end;  // end of if
      end;
   end else  //계좌별
   begin
      for I := 0 to SntFaxTlxList.Count -1 do
      begin
         SntItem := SntFaxTlxList.Items[I];

         if (SndItem.AccGrpType = SntItem.AccGrpType) and
            (SndItem.AccNo = SntItem.AccNo) and
            (SndItem.SubAccNo = SntItem.SubAccNo) and
            (SndItem.SendMtd = SntItem.FaxTlxGbn) and
            (SndItem.NatCode = SntItem.NatCode) and
            (SndItem.MediaNo = SntItem.MediaNo) then
          begin
               ExistFlag := True;
               FreqItem := SntItem.FreqList.Items[0];  // 마지막 회차 정보
               iLastFreqNo := FreqItem.FreqNo;
               break;
          end;  // end of if
      end;
   end;

   if not ExistFlag then  // 존재하지 않을 경우
   begin
      New(SntItem);
      SntFaxTlxList.Add(SntItem);
      SntItem.AccGrpType   := SndItem.AccGrpType;
      SntItem.AccNo        := '';
      SntItem.SubAccNo     := '';
      if SndItem.AccGrpType = gcRGROUP_ACC then
      begin
         SntItem.AccNo        := SndItem.AccNo;
         SntItem.SubAccNo     := SndItem.SubAccNo;
      end;
      SntItem.AccName      := SndItem.AccName;
      SntItem.AccId        := SndItem.AccId;
      SntItem.FaxTlxGbn    := SndItem.SendMtd;
      SntItem.RcvCompKor   := SndItem.RcvCompKor;
      SntItem.NatCode      := SndItem.NatCode;
      SntItem.MediaNo      := SndItem.MediaNo;
      SntItem.MgrName      := SndItem.MgrName;
      SntItem.SubDeptName  := SndItem.SubDeptName;
      SntItem.PgmAcYN      := SndItem.PgmAcYN;
      SntItem.AccAttr      := SndItem.AccAttr;
      SntItem.DisplayAll   := DRCheckBox_FaxTlxTotFreq.Checked;
      SntItem.FreqList     := TList.Create;
   end;

   New(FreqItem);
   SntItem.FreqList.Add(FreqItem);
   Inc(iLastFreqNo);
   FreqItem.FreqNo       := iLastFreqNo;
   FreqItem.CurTotSeqNo  := SndItem.CurTotSeqNo;
   FreqItem.ReportType   := gf_GetReportType(SndItem.ReportID);
   FreqItem.Direction    := gf_GetReportDirection(SndItem.ReportID);
   FreqItem.TxtUnitInfo  := pTxtUnitInfo;
   FreqItem.SendTime     := '';
   FreqItem.SentTime     := '';
   FreqItem.DiffTime     := 0;
   FreqItem.TotalPageCnt := pTotPageCnt;
   FreqItem.SendPageCnt  := 0;
   FreqItem.BusyResndCnt := 0;
   FreqItem.RSPFlag      := gcFAXTLX_RSPF_WAIT;
   FreqItem.ErrCode      := '';
   FreqItem.ErrMsg       := '';
   FreqItem.ExtMsg       := '';
   FreqItem.OprId        := gvOprUsrNo;

   SntItem.FreqList.Sort(FreqFaxTlxListCompare);  // 회차 역순으로 보여주기 위해 Sorting
   for I := 0 to SntItem.FreqList.Count -1 do     // Clear LastFlag
   begin
      FreqItem := SntItem.FreqList.Items[I];
      FreqItem.LastFlag := False;
   end;  // end of for
   FreqItem := SntItem.FreqList.Items[0];  // Last Flag Setting
   FreqItem.LastFlag := True;
   SntFaxTlxList.Sort(SntFaxTlxListCompare);  // SbtFaxTlxList Sorting
   DisplaySntFaxTlxList(True);
end;

//------------------------------------------------------------------------------
//  SntFaxTlxList의 RSPFlag Update (현재는 전송 취소 후 Update 용도로 사용
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.SetSntFaxTlxListCanc(pCurTotSeqNo: Integer);
var
   I, K  : Integer;
   SntItem  : pTESntFaxTlx;
   FreqItem : pTEFreqFaxTlx;
begin
   for I := 0 to SntFaxTlxList.Count -1 do
   begin
      SntItem := SntFaxTlxList.Items[I];
      for K := 0 to SntItem.FreqList.Count -1 do
      begin
         FreqItem := SntItem.FreqList.Items[K];
         if FreqItem.CurTotSeqNo = pCurTotSeqNo then
         begin
            FreqItem.RSPFlag := gcFAXTLX_RSPF_CANC;  // Cancel Setting
            FreqItem.ErrCode := '';
            FreqItem.ErrMsg  := '';
            FreqItem.OprId   := gvOprUsrNo;

            // Display SntFaxTlxList Item
            DisplayFreqFaxTlxItem(SntItem, FreqItem);
            Exit;
         end;  // end of if
      end;  // end of for K
   end;  // end of for I
end;

//------------------------------------------------------------------------------
//  Send Fax or Tlx (계좌에 대한 수신처 그룹으로 처리)
//------------------------------------------------------------------------------
function TForm_SCFH8801_SND.SendFaxTlx(SndItemIdxList: TStringList): boolean;
var
   SndItem : pTESndFaxTlx;
   SndFmtItem  : TFAXTLXSendFormat;
   ReportItem  : pTReportList;
   AccExtInfo  : pTBACTrade;
   GrpExtInfo  : pTBGPTrade;
   ReportList  : TList;
   I, J, K, iSndIdx, iTotPageCnt : Integer;
   ErrFlag : boolean;
   sRptType, sSndFileName, sTmpFileName, sErrMsg : string;
   sLogoPageNo, sTxtUnitInfo : string;
   iReportIdx, iIdxSeqNo : Integer;
   Starttime : string;
begin
   Result  := False;
   ErrFlag := False;
   //동일 수신처에 여러 레포트가 딸려온다.
   if SndItemIdxList.Count <= 0 then Exit;

   // 전송 데이터 Clear
   for I := 0 to SndItemIdxList.Count -1 do
   begin
      iSndIdx := StrToInt(SndItemIdxList.Strings[I]);
      SndItem := SndFaxTlxList.Items[iSndIdx];
      SndItem.SendFlag     := True;
      SndItem.CancFlag     := False;
      SndItem.CurTotSeqNo  := -1;
      SndItem.ErrMsg       := '';
   end; // end of for

   iSndIdx := StrToInt(SndItemIdxList.Strings[0]); // 첫번째 Item (Because 수신처가 같기 때문)
   SndItem := SndFaxTlxList.Items[iSndIdx];

   SndFmtItem.sCurDate      := gvCurDate;
   SndFmtItem.sFromPartyId  := gvMyPartyID;
   SndFmtItem.sFaxTlxGbn    := SndItem.SendMtd;
   SndFmtItem.sRcvCompKor   := SndITem.RcvCompKor;
   SndFmtItem.sMediaNo      := SndITem.MediaNo;
   SndFmtItem.sIntTelYn     := SndITem.IntTelYn;
   SndFmtItem.sNatCode      := SndITem.NatCode;

   // Report List 생성
   ReportList := TList.Create;
   if not Assigned(ReportList) then
   begin
      ErrFlag := True;
      sErrMsg := gf_ReturnMsg(9004); // List 생성 오루
      exit;
   end;

   //수신처에 하나에 대한 여러 보고서 List 생성
   for I := 0 to SndItemIdxList.Count -1 do
   begin

//if gvRealLogYN = 'Y' then gf_Log('전송SendFaxTlx start ' + IntToStr(I+1) + '/' + IntToStr(SndItemIdxList.Count));

      iSndIdx := StrToInt(SndItemIdxList.Strings[I]);
      SndItem := SndFaxTlxList.Items[iSndIdx];

      // Report 파일 생성(이전에 동일한 레포트가 없었을 경우)
      sTmpFileName := '';
      sSndFileName := '';
      sLogoPageNo  := '';
      sTxtUnitInfo := '';
      iTotPageCnt  := 0;
      if SndItem.RIdxSeqNo <= 0 then //  동일 Img Idx가 없었을 경우
      begin
         // Report 생성 : sSndFileName 유일성 강조(계좌번호+부계좌번호)★☆
         sSndFileName := gvDirTemp + 'FT' + gf_GetCurTime + SndITem.AccNo + SndItem.SubAccNo + IntToStr(I) + '.tmp'; //@@
         sRptType     := gf_GetReportType(SndItem.ReportId);
         if sRptType = gcRTYPE_CRPT then
         begin
            // Report Export   계좌별 & 그룹별
            if not gf_Export_CRB_EI1_1(SndItem.ReportID, SndItem.RcvCompKor, SndItem.MediaNo, sSndFileName, ParentForm.JobDate,
                   SndItem.AccName, SndItem.AccGrpType, SndItem.ClientMgrName, SndItem.ClientTelNo, SndItem.ClientFaxNo,
                   SndItem.AccNoList, SndItem.PSList.PSStringList, SndItem.PSList.L_PSStringList, SndItem.PSList.R_PSStringList,
                   SndItem.InsertAmd, gvStampSignFlag, iTotPageCnt) then
            begin
               ErrFlag := True;
               sErrMsg := gf_ReturnMsg(gvErrorNo) + ' (' + gvExtMsg + ')';
            end;
         end
         else // if SRptType = gcRTYPE_TEXT then
         begin
            if Trim(SndItem.EditFileName) = '' then  // Edit된 File 존재하지 않을 경우
            begin
               //sTmpFileName := 생성시간 + 계좌번호+부계좌번호(유일성강조)
               sTmpFileName := gvDirTemp + 'TP' + gf_GetCurTime + SndITem.AccNo + SndItem.SubAccNo + '.tmp'; //@@

               // Report Export   계좌별 & 그룹별
               if not gf_Export_CRB_EI1_1(SndItem.ReportID, SndItem.RcvCompKor, SndItem.MediaNo, sTmpFileName, ParentForm.JobDate,
                      SndItem.AccName, SndItem.AccGrpType, SndItem.ClientMgrName, SndItem.ClientTelNo, SndItem.ClientFaxNo,
                      SndItem.AccNoList, SndItem.PSList.PSStringList,SndItem.PSList.L_PSStringList, SndItem.PSList.R_PSStringList,
                      SndItem.InsertAmd, gvStampSignFlag, iTotPageCnt) then
               begin
                  ErrFlag := True;
                  sErrMsg := gf_ReturnMsg(gvErrorNo) + ' (' + gvExtMsg + ')';
               end  else  // Export Error
               begin
                  // Text File Conversion
                  if not gf_ConvertPageText( sTmpFileName, sSndFileName,
                     SndItem.PSList.PSStringList, iTotPageCnt, sLogoPageNo, sTxtUnitInfo) then
                  begin
                     ErrFlag := True;
                     sErrMsg := gf_ReturnMsg(1128); // TEXT 파일 변환 중 오류 발생
                  end;

                  if not DeleteFile(sTmpFileName) then  //temp\지우기
                  begin
                     gf_log('can not delete tmp file=' + sTmpFileName);
                  end;
               end;
            end
            else // Edit된 File 존재시
            begin
               // Text File Conversion
//if gvRealLogYN = 'Y' then gf_Log('전송SendFaxTlx before gf_ConvertPageText Edit된 File 존재시');
               if not gf_ConvertPageText(SndItem.EditFileName, sSndFileName,
                  SndItem.PSList.PSStringList, iTotPageCnt, sLogoPageNo, sTxtUnitInfo) then
               begin
                  ErrFlag := True;
                  sErrMsg := gf_ReturnMsg(1128); // TEXT 파일 변환 중 오류 발생
               end;
            end;
         end;  // end of else

         if ErrFlag then // Error 발생
         begin
//if gvRealLogYN = 'Y' then gf_Log('전송SendFaxTlx before Error 발생');
            for J := 0 to SndItemIdxList.Count -1 do
            begin
               iSndIdx := StrToInt(SndItemIdxList.Strings[J]);
               SndITem := SndFaxTlxList.Items[iSndIdx];
               SndITem.ErrMsg := sErrMsg;
               //DisplaySndFaxTlxItem(SndItem);
            end; // end of for

            if Assigned(ReportList) then gf_FreeReportList(ReportList);
            DeleteFile(sSndFileName);
            if Trim(sTmpFileName) <> '' then DeleteFile(sTmpFileName);
            Exit;
         end;
      end;

      New(ReportItem);
      ReportList.Add(ReportItem);

      // ReportList 정보
      ReportItem.sSecCode      := gcSEC_EQUITY;
      ReportItem.sTradeDate    := ParentForm.JobDate;
      ReportItem.sReportId     := SndITem.ReportId;
      ReportItem.sDirection    := gf_GetReportDirection(SndITem.ReportId);
      ReportItem.iTotalPageCnt := iTotPageCnt;
      ReportItem.sReportType   := gf_GetReportType(SndItem.ReportID);
      ReportItem.sLogoPageNo   := sLogoPageNo;
      ReportItem.sTxtUnitInfo  := sTxtUnitInfo;
      ReportItem.sFileName     := sSndFileName;
      ReportItem.iCurTotSeqNo  := -1;                 // 초기화
      ReportItem.iIdxSeqNo     := SndITem.RIdxSeqNo;  // 레포트이미지 Index
      If SndItem.AccGrpType = gcRGroup_ACC then
      begin
         ReportItem.iExtFlag      := 1;            // 계좌별
         New(AccExtInfo);
         ReportItem.tExtInfo      := AccExtInfo;

         // 추가정보(계좌별)
         AccExtInfo.sAccNo           := SndItem.AccNo;
         AccExtInfo.sSubAccNo        := SndItem.SubAccNo;
         AccExtInfo.dBuyExecAmt      := SndItem.BuyExecAmt;
         AccExtInfo.dSellExecAmt     := SndItem.SellExecAmt;
         AccExtInfo.dBuyComm         := SndItem.BuyComm;
         AccExtInfo.dSellComm        := SndItem.SellComm;
         AccExtInfo.dTotTax          := SndItem.TotTax;
         AccExtInfo.dNetAmt          := SndItem.NetAmt;
      end
      else
      begin
         ReportItem.iExtFlag         := 2;         // 그룹별
         New(GrpExtInfo);
         ReportItem.tExtInfo         := GrpExtInfo;
         // 추가정보(그룹별)
         GrpExtInfo.sSecCode         := gcSEC_EQUITY;
         GrpExtInfo.sGrpName         := SndItem.AccName;
         GrpExtInfo.dBuyExecAmt      := SndItem.BuyExecAmt;
         GrpExtInfo.dSellExecAmt     := SndItem.SellExecAmt;
         GrpExtInfo.dBuyComm         := SndItem.BuyComm;
         GrpExtInfo.dSellComm        := SndItem.SellComm;
         GrpExtInfo.dTotTax          := SndItem.TotTax;
         GrpExtInfo.dNetAmt          := SndItem.NetAmt;
         GrpExtInfo.sPgmAccYn        := SndItem.PgmAcYN;
         GrpExtInfo.sAccAttr         := SndItem.AccAttr;
      end;

//if gvRealLogYN = 'Y' then gf_Log('전송SendFaxTlx end ' + IntToStr(I+1) + '/' + IntToStr(SndItemIdxList.Count));

   end; //end of for
   // End of ReportList 생성 ---------------------------------------------------

//if gvRealLogYN = 'Y' then gf_Log('전송SendFaxTlx before fnFaxDataSend');

   // FaxTlx 내역 전송
   Starttime := ''; // 전송시작시간을 받아옴.
   Result := fnFaxDataSend(@SndFmtItem, ReportList, Starttime);

//if gvRealLogYN = 'Y' then gf_Log('전송SendFaxTlx after fnFaxDataSend');

   sErrMsg := '';
   if Result = False then
      sErrMsg := gf_ReturnMsg(gvErrorNo) + ' (' + gvExtMsg + ')';


   // SndFaxTlxList Update & 화면 Display & 송신 확인 내역 추가
   for I := 0 to SndItemIdxList.Count -1 do
   begin
      iSndIdx := StrToInt(SndItemIdxList.Strings[I]);
      SndItem := SndFaxTlxList.Items[iSndIdx];

      ReportItem := ReportList.Items[I];
      SndItem.CurTotSeqNo  := ReportItem.iCurTotSeqNo;
      SndItem.ErrMsg       := sErrMsg;
      SndItem.StartTime    := Starttime;
      SndItem.RIdxSeqNo    := ReportItem.iIdxSeqNo;
      //DisplaySndFaxTlxItem(SndItem);  // 화면 Display

      // 송신 확인 내역 추가
      if Result = True then
         AddSntFaxTlxList(SndItem, ReportItem.iTotalPageCnt, ReportItem.sTxtUnitInfo);

      // 동일레포트 Index 처리
      if SndItem.ReportIdx > 0 then
      begin
         iReportIdx  := SndItem.ReportIdx;
         iIdxSeqNo   := SndItem.RIdxSeqNo;
         for K := 0 to SndFaxTlxList.Count - 1 do
         begin
            SndItem := SndFaxTlxList.Items[K];
            if not SndItem.Selected then Continue;

            if iReportIdx = SndItem.ReportIdx then
                SndItem.RIdxSeqNo := iIdxSeqNo;
         end;
      end; // end of if

      if Trim(ReportITem.sFileName) <> '' then
      begin
         if not DeleteFile(ReportITem.sFileName) then  //temp\지우기
         begin
            gf_log('can not delete file=' + ReportITem.sFileName);
         end;
      end;
   end;
   gf_FreeReportList(ReportList);
   Result := True;

//if gvRealLogYN = 'Y' then gf_Log('전송SendFaxTlx End');

end;

//------------------------------------------------------------------------------
// 해당 Row 데이타
//------------------------------------------------------------------------------
function TForm_SCFH8801_SND.GetSndFaxTlxListIdx(pGridRowIdx: Integer): Integer;
var
   I : Integer;
   SndItem : pTESndFaxTlx;
begin
   Result := -1;
   if pGridRowIdx <= 0 then Exit;

   for I := 0 to SndFaxTlxList.Count -1 do
   begin
      SndItem := SndFaxTlxList.Items[I];
      if SndItem.GridRowIdx = pGridRowIdx then
      begin
         Result := I;
         Break;
      end;
   end;  // end of for
end;

//------------------------------------------------------------------------------
//  동일 계좌 P.S, Edit File 동일값 Setting
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.SameAccCopyEditData(SrcItem: pTESndFaxTlx);
var
   I : Integer;
   DesItem  : pTESndFaxTlx;
begin
   for I := 0 to SndFaxTlxList.Count -1 do
   begin
      if SrcItem.AccGrpType = gcRGroup_ACC then
      begin
         DesItem := SndFaxTlxList.Items[I];
         if (DesItem.AccNo    = SrcItem.AccNo) and
            (DesItem.SubAccNo = SrcItem.SubAccNo) and
            (DesItem.GridRowIdx <> SrcItem.GridRowIdx) then  // 원본 데이터 제외한 동일계좌 Item
         begin
            // Edit File
            if (gf_GetReportType(DesItem.ReportID) = gcRTYPE_TEXT) and
               (DesItem.ReportID = SrcItem.ReportID) then
                  DesItem.EditFileName := SrcItem.EditFileName;

            // Display
//            DisplaySndFaxTlxItem(DesItem);
         end;  // end of if

      end else
      begin
         DesItem := SndFaxTlxList.Items[I];
         if (DesItem.AccName = SrcItem.AccName) and
            (DesItem.GridRowIdx <> SrcItem.GridRowIdx) then  // 원본 데이터 제외한 동일계좌 Item
         begin
            // Edit File
            if (gf_GetReportType(DesItem.ReportID) = gcRTYPE_TEXT) and
               (DesItem.ReportID = SrcItem.ReportID) then
                  DesItem.EditFileName := SrcItem.EditFileName;

            // Display
//            DisplaySndFaxTlxItem(DesItem);
         end;  // end of if

      end;

   end;  // end of for
end;

//------------------------------------------------------------------------------
//  Fax/Tlx 재전송
//------------------------------------------------------------------------------
function TForm_SCFH8801_SND.RetrySendFaxTlx(SntItem: pTESntFaxTlx;
                                              FreqItem: pTEFreqFaxTlx): boolean;
begin
   // Clear
   FreqItem.SendTime     := '';
   FreqItem.SentTime     := '';
   FreqItem.DiffTime     := 0;
   FreqItem.SendPageCnt  := 0;
   FreqItem.BusyResndCnt := 0;
   FreqItem.RSPFlag      := gcFAXTLX_RSPF_WAIT;
   FreqItem.ErrCode      := '';
   FreqItem.ErrMsg       := '';
   FreqItem.OprId        := gvOprUsrNo;

   // Display SntFaxTlxList Item
   DisplayFreqFaxTlxItem(SntItem, FreqItem);

   // 재전송
   Result := fnFAXDataReSend(FreqItem.CurTotSeqNo);

   if not Result then  // Error 일 경우 처리
   begin
      FreqItem.RSPFlag      := gcFAXTLX_RSPF_FIN;
      FreqItem.ErrCode      := IntToStr(gvErrorNo);
      FreqItem.ErrMsg       := gvExtMsg;

      // Display SntFaxTlxList Item
      DisplayFreqFaxTlxItem(SntItem, FreqItem);
   end;
end;

//------------------------------------------------------------------------------
//  Return SntFaxTlxList Index
//------------------------------------------------------------------------------
function TForm_SCFH8801_SND.GetSntFaxTlxListIdx(pGridRowIdx: Integer;
                                       var pSntIdx, pFreqIdx: Integer): boolean;
var
   I, K : Integer;
   SntItem  : pTESntFaxTlx;
   FreqItem : pTEFreqFaxTlx;
begin
   Result := False;
   pSntIdx  := -1;
   pFreqIdx := -1;
   if pGridRowIdx <= 0 then Exit;

   for I := 0 to SntFaxTlxList.Count -1 do
   begin
      SntItem := SntFaxTlxList.Items[I];
      if not Assigned(SntItem.FreqList) then Exit;

      for K := 0 to SntItem.FreqList.Count -1 do
      begin
         FreqItem := SntItem.FreqList.Items[K];
         if FreqItem.GridRowIdx = pGridRowIdx then
         begin
            Result := True;
            PSntIdx  := I;
            pFreqIdx := K;
            Break;
         end;  // end of if
      end;  // end of for K
   end;  // end of for I
end;

//------------------------------------------------------------------------------
//  Clear SntFaxTlxList
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.ClearSntFaxList;
var
   I, K : Integer;
   SntItem  : pTESntFaxTlx;
   FreqItem : pTEFreqFaxTlx;
begin
   if not Assigned(SntFaxTlxList) then Exit;
   for I := 0 to SntFaxTlxList.Count -1 do
   begin
      SntItem := SntFaxTlxList.Items[I];
      if Assigned(SntItem.FreqList) then
      begin
         for K := 0 to SntItem.FreqList.Count -1 do
         begin
            FreqItem := SntItem.FreqList.Items[K];
            Dispose(FreqItem);
         end;  // end of for
         SntItem.FreqList.Free;
      end; // end of if
      Dispose(SntItem);
   end; // end of for K
   SntFaxTlxList.Clear;
end;

//------------------------------------------------------------------------------
//  Display SntFaxTlxList FreqItem
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DisplayFreqFaxTlxItem(SntItem: pTESntFaxTlx;
                                                       FreqItem: pTEFreqFaxTlx);
var
   iRow : Integer;
   sFmtAccNo, sAccName : string;
begin
   with DRStrGrid_SntFaxTlx do
   begin
      iRow := FreqItem.GridRowIdx;
      if iRow <= 0 then Exit;   // List의 해당 Item은 Update되었으나 Display되지 않는 경우

      if (not SntItem.DisplayAll) and   // 마지막 회차보기 @@@@@@@@@
         (not FreqItem.LastFlag) then Exit;

      sFmtAccNo := Cells[SNT_FAXTLX_ACCNO_IDX, iRow];     // 계좌번호
      sAccName  := Cells[SNT_FAXTLX_ACCNO_IDX + 1, iRow]; // 계좌명 & 그룹명
      Rows[iRow].Clear;
      HintCell[SNT_FAXTLX_FREQNO_IDX, iRow]  := '';
      HintCell[SNT_FAXTLX_SNTTIME_IDX, iRow] := '';
      HintCell[SNT_FAXTLX_RSPF_IDX, iRow]    := '';

      if FreqItem.Selected then
         RowFont[iRow].Color := gcSelectItemColor
      else
         RowFont[iRow].Color := clBlack;
      SelectedFontColorRow[iRow] := RowFont[iRow].Color;

      // 계좌번호
      Cells[1, iRow] := sFmtAccNo;
      // 계좌명
      Cells[2, iRow] := sAccName;
      if FreqItem.LastFlag then  // 마지막 회차만 출력
      begin
         // 수신처
         Cells[3, iRow] := SntItem.RcvCompKor;

         // 번호
         if SntItem.FaxTlxGbn = gcSEND_FAX then  // Fax
            Cells[4, iRow] := SntItem.MediaNo
         else  // Telex
            Cells[4, iRow] := SntItem.NatCode + SntItem.MediaNo;
      end;

      if FreqItem.Selected then   // 선택 여부
         Cells[0, iRow] := gcSEND_MARK;

      // 회차
      Cells[5, iRow] := IntToStr(FreqItem.FreqNo);

      // Tlx 번호 Hint 처리
      if SntItem.FaxTlxGbn = gcSEND_TLX then
         HintCell[5, iRow] := 'TLX ' + IntToStr(FreqItem.CurTotSeqNo);

      // 전송시작시간
      Cells[6, iRow] := gf_FormatTime(copy(FreqItem.SendTime, 1, 6));

      // 조작자 정보
      HintCell[6, iRow] := gwOprId + ':' + FreqItem.OprId;

      // 전송완료시간
      Cells[7, iRow] := gf_FormatTime(copy(FreqItem.SentTime, 1, 6));

      // 전송시간
      Cells[8, iRow] := gf_FormatDiffTime(FreqItem.DiffTime);

      // Fax 재전송 횟수
//      if SntItem.FaxTlxGbn = gcSEND_FAX then 20041217 telex도 재전송함.
         Cells[9, iRow] := FormatFloat('##', FreqItem.BusyResndCnt);

      // Process
      Cells[10, iRow] := gf_GetFaxTlxResult(FreqItem.RSPFlag);

      if SntItem.FaxTlxGbn = gcSEND_TLX then  // Tlx의 경우 Extension Message Display
         HintCell[10, iRow] := FreqItem.ExtMsg;

      // Error 확인 후 Error Message 출력
      if Trim(FreqItem.ErrCode) <> '' then
      begin
         if FreqItem.RSPFlag = gcFAXTLX_RSPF_FIN then
            Cells[10, iRow] := gwRSPError;

         if (FreqItem.RSPFlag = gcFAXTLX_RSPF_FIN) or
            (FreqItem.RSPFlag = gcFAXTLX_RSPF_BUSY) then
            HintCell[10, iRow] := FreqItem.ErrMsg + Chr(13) + '(' + FreqItem.ExtMsg + ')';
      end;
      CellFont[10, iRow].Color := gf_GetFaxTlxRSPFlagColor(Cells[10, iRow]);
      SelectedFontColorCell[10, iRow] := CellFont[10, iRow].Color;

      // Fax 진행 Page
      if SntItem.FaxTlxGbn = gcSEND_FAX then
         Cells[11, iRow] := IntToStr(FreqItem.SendPageCnt) + '/' + IntToStr(FreqItem.TotalPageCnt);
   end;  // end of with
end;

//------------------------------------------------------------------------------
//  Display SntFaxTlxList
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DisplaySntFaxTlxList(DefSelectFlag: boolean);
var
   SntItem  : pTESntFaxTlx;
   FreqItem : pTEFreqFaxTlx;
   I, K, iRowCnt, iRow : Integer;
   sAccNo, sSubAccNo, sGrpName : string;
begin
   DRLabel_SntFaxTlx.Caption := '>> 당일송신확인';
   with DRStrGrid_SntFaxTlx do
   begin
      iRow := 0;
      sAccNo    := '';
      sSubAccNo := '';
      sGrpName  := '';
      for I := 0 to SntFaxTlxList.Count -1 do
      begin
         SntItem := SntFaxTlxList.Items[I];
         for K := 0 to SntItem.FreqList.Count -1 do  // 초기화
         begin
            FreqItem := SntItem.FreqList.Items[K];
            FreqItem.GridRowIdx := -1;
            if DefSelectFlag then
               FreqItem.Selected   := False;
         end;
         
         // 진행중, 오류내역, 조회회차
         for K := 0 to SntItem.FreqList.Count -1 do
         begin
            FreqItem := SntItem.FreqList.Items[K];

            if (not SntItem.DisplayAll) and   // 마지막 회차보기
               (not FreqItem.LastFlag) then Continue;

            if (DRRadioBtn_FaxTlxSend.Checked) and      // 진행중
               ((FreqItem.RSPFlag = gcFAXTLX_RSPF_FIN) or
               (FreqItem.RSPFlag = gcFAXTLX_RSPF_CANC)) then Continue;

            if (DRRadioBtn_FaxTlxError.Checked) and     // 오류내역
               ((FreqItem.RSPFlag <> gcFAXTLX_RSPF_FIN) or
               (Trim(FreqItem.ErrCode) = '')) then Continue;

            Inc(iRow);

            FreqItem.GridRowIdx := iRow;
            if DefSelectFlag then
               FreqItem.Selected   := SntFaxTlxSelected;

            // 계좌번호, 계좌명 출력
            Cells[SNT_FAXTLX_ACCNO_IDX, iRow]     := '';  // 계좌번호
            Cells[SNT_FAXTLX_ACCNO_IDX + 1, iRow] := '';  // 계좌명

            // 계좌정보 출력 여부 결정하기 위한 처리
            //그룹별
            if SntItem.AccGrpType = gcRGROUP_GRP then
            begin
               if sGrpName <> SntItem.AccName  then
               begin
                  sGrpName := SntItem.AccName;
                  Cells[SNT_FAXTLX_ACCNO_IDX, iRow] := gcSIGMA + SntItem.AccName;
                  // 그룹명
                  Cells[2, iRow] := SntItem.AccName;
               end;
            end else
            //계좌별
            begin
               if (sAccNo <> SntItem.AccNo) or (sSubAccNo <> SntItem.SubAccNo) then
               begin
                  sAccNo    := SntItem.AccNo;
                  sSubAccNo := SntItem.SubAccNo;

                  if not DRCheckBox_View.Checked then // 계좌번호
                     Cells[SND_FAXTLX_ACCNO_IDX, iRow] := gf_FormatAccNo(SntItem.AccNo, SntItem.SubAccNo)
                  else // Identification + 계좌번호
                  begin
                     if SntItem.AccId <> '' then
                        Cells[SND_FAXTLX_ACCNO_IDX, iRow] := SntItem.AccId + gcACCID_DIV_CHAR +
                                          gf_FormatAccNo(SntItem.AccNo, SntItem.SubAccNo)
                     else
                        Cells[SND_FAXTLX_ACCNO_IDX, iRow] :=
                                          gf_FormatAccNo(SntItem.AccNo, SntItem.SubAccNo);
                  end;
                  // 계좌명
                  if not DRCheckBox_ClientNM.Checked then
                     Cells[2, iRow] := SntItem.AccName
                  else // (Client명 + 계좌명)
                  begin
                     if SntItem.ClientGrpName <> '' then
                        Cells[2, iRow] := SntItem.ClientGrpName + gcACCID_DIV_CHAR + SntItem.AccName
                     else
                        Cells[2, iRow] := SntItem.AccName;
                  end;
               end;
            end;
            DisplayFreqFaxTlxItem(SntItem, FreqItem); // 회차 정보 Display
         end;  // end of for K
      end;  // end of for I
      if iRow <= 0 then
      begin
         RowCount := 2;
         Rows[1].Clear;
         HintCell[SNT_FAXTLX_FREQNO_IDX, 1]  := '';
         HintCell[SNT_FAXTLX_SNTTIME_IDX, 1] := '';
         HintCell[SNT_FAXTLX_RSPF_IDX, 1]    := '';
         Exit;
      end else
      begin
         iRowCnt  := iRow;
         RowCount := iRowCnt+1;
      end;
   end;  // end of with
   DRLabel_SntFaxTlx.Caption := DRLabel_SntFaxTlx.Caption + ' (' //+ gwQueryCnt
                                + IntToStr(iRowCnt) + ')';
end;

//------------------------------------------------------------------------------
//  송신 확인 내역 중 해당 계좌 내역 Select
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRStrGrid_SndFaxTlxDblClick(Sender: TObject);
var
   I, iSndIdx : Integer;
   SndItem  : pTESndFaxTlx;
   SntItem  : pTESntFaxTlx;
   FreqItem : pTEFreqFaxTlx;
begin
  inherited;
   //수신처가 없을 순 없다
   if Trim(DRStrGrid_SndFaxTlx.Cells[SND_FAXTLX_RCVCMP_IDX, SndFaxTlxRowIdx]) = '' then
                             Exit;  // Data 없는 경우
   iSndIdx := GetSndFaxTlxListIdx(SndFaxTlxRowIdx);
   if iSndIdx < 0 then
   begin
      gf_ShowMessage(MessageBar, mtError, 1068, ''); //해당 정보를 읽어올 수 없습니다.
      Exit;
   end;
   SndItem := SndFaxTlxList.Items[iSndIdx];

   SntFaxTlxSortIdx := SNT_FAXTLX_ACCNO_IDX;
   SntFaxTlxSortFlag[SNT_FAXTLX_ACCNO_IDX] := True;
   SntFaxTlxList.Sort(SntFaxTlxListCompare);
   DisplaySntFaxTlxList(True);

   for I := 0 to SntFaxTlxList.Count -1 do
   begin
      SntItem := SntFaxTlxList.Items[I];
      if SndITem.AccGrpType =  gcRGROUP_GRP then
      begin
         if (SntItem.AccName  = SndItem.AccName) and
            (SntItem.RcvCompKor = SndItem.RcvCompKor)  then
         begin
            FreqItem := SntItem.FreqList.Items[0]; // 마지막 회차
            gf_SetTopRow(DRStrGrid_SntFaxTlx, FreqItem.GridRowIdx);
            gf_SelectStrGridRow(DRStrGrid_SntFaxTlx, FreqItem.GridRowIdx);
            Break;
         end;  // end of if
      end else
      begin
         if (SntItem.AccNo = SndItem.AccNo) and (SntItem.SubAccNo = SndItem.SubAccNo) then
         begin
            FreqItem := SntItem.FreqList.Items[0]; // 마지막 회차
            gf_SetTopRow(DRStrGrid_SntFaxTlx, FreqItem.GridRowIdx);
            gf_SelectStrGridRow(DRStrGrid_SntFaxTlx, FreqItem.GridRowIdx);
            Break;
         end;  // end of if
      end;
   end;  // end of for

end;

//------------------------------------------------------------------------------
//  Fixed Row Click - 전체 선택 여부, Sorting
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRStrGrid_SndFaxTlxFiexedRowClick(
  Sender: TObject; ACol: Integer);
var //@@
   i,iSndIdx : integer;
   SelectedRect: TGridRect;
   SndItem : pTESndFaxTlx;
begin
  inherited;
   if ACol = SELECT_IDX then
   begin
      SndFaxTlxSelected := not (SndFaxTlxSelected);  // toggle
      if SndFaxTlxSelected then
         DRStrGrid_SndFaxTlx.Cells[SELECT_IDX, 0] := gcSEND_MARK
      else
         DRStrGrid_SndFaxTlx.Cells[SELECT_IDX, 0] := '';

//@@ start
      SelectedRect := DRStrGrid_SndFaxTlx.Selection; //@@
      if SelectedRect.Bottom - SelectedRect.Top + 1 > 1 then //1개이상 multi 선택시
      begin
         for i := SelectedRect.Top to SelectedRect.Bottom do
         begin
            iSndIdx := GetSndFaxTlxListIdx(i);
            if iSndIdx < 0 then continue;
            SndItem := SndFaxTlxList.Items[iSndIdx];
            SndItem.Selected := SndFaxTlxSelected;
//            DisplaySndFaxTlxItem(SndItem);
         end;
      end
      else //1개만 선택시
//         DisplaySndFaxTlxList(True); //@@ end

   end
   else  // Sorting
   begin
      Screen.Cursor := crHourGlass;
      SndFaxTlxSortIdx := ACol;
      SndFaxTlxSortFlag[ACol] := not SndFaxTlxSortFlag[ACol];
      SndFaxTlxList.Sort(SndFaxTlxListCompare);
//      DisplaySndFaxTlxList(False);
      Screen.Cursor := crDefault;
   end;
end;

procedure TForm_SCFH8801_SND.DRStrGrid_SndFaxTlxMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   ACol, ARow : Integer;
   ScreenP : TPoint;
   iSndIdx : Integer;
   SndItem : pTESndFaxTlx;
begin
   inherited;
   DRStrGrid_SndFaxTlx.MouseToCell(X, Y, ACol, ARow);
   if (ARow <= 0) or (ACol < 0) then Exit;

   SndFaxTlxColIdx := ACol;
   SndFaxTlxRowIdx := ARow;

   if Trim(DRStrGrid_SndFaxTlx.Cells[SND_FAXTLX_RCVCMP_IDX, ARow]) = '' then
      Exit;  // Data 없는 경우

   if ((Button = mbLeft) and (ssCtrl in Shift))
      or ((Button = mbLeft) and (ACol = SELECT_IDX)) then  // 전송 선택 클릭
   begin
      iSndIdx := GetSndFaxTlxListIdx(ARow);
      if iSndIdx < 0 then
      begin
         gf_ShowMessage(MessageBar, mtError, 1068, ''); //해당 정보를 읽어올 수 없습니다.
         Exit;
      end;
      SndItem := SndFaxTlxList.Items[iSndIdx];
      SndItem.Selected := not SndItem.Selected;

      // Display SndFaxTlxItem
//      DisplaySndFaxTlxItem(SndItem);
   end
   else if Button = mbRight then
   begin
      gf_SelectStrGridRow(DRStrGrid_SndFaxTlx, SndFaxTlxRowIdx);

      // Popup Menu 처리
      iSndIdx := GetSndFaxTlxListIdx(ARow);
      if iSndIdx < 0 then
      begin
         gf_ShowMessage(MessageBar, mtError, 1068, ''); //해당 정보를 읽어올 수 없습니다.
         Exit;
      end;
      SndItem := SndFaxTlxList.Items[iSndIdx];

      GetCursorPos(ScreenP);
      DRPopupMenu_SndFax.Popup(ScreenP.X, ScreenP.Y);
   end;
end;

//------------------------------------------------------------------------------
//  Fixed Row Click - 전체 선택 여부, Sorting
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRStrGrid_SntFaxTlxFiexedRowClick(
                                                Sender: TObject; ACol: Integer);
var
   iRptTypeIdx, i,iSntIdx,iFreqIdx  : integer;
   SntItem  : pTESntFaxTlx;
   FreqItem : pTEFreqFaxTlx;
   SelectedRect: TGridRect;
begin
   inherited;
   if ACol = SELECT_IDX then
   begin
      SntFaxTlxSelected := not (SntFaxTlxSelected);  // toggle
      if SntFaxTlxSelected then
         DRStrGrid_SntFaxTlx.Cells[SELECT_IDX, 0] := gcSEND_MARK
      else
         DRStrGrid_SntFaxTlx.Cells[SELECT_IDX, 0] := '';

      SelectedRect := DRStrGrid_SntFaxTlx.Selection; //@@
      if SelectedRect.Bottom - SelectedRect.Top + 1 > 1 then //1개이상 multi 선택시
      begin
         for i := SelectedRect.Top to SelectedRect.Bottom do
         begin
            if not GetSntFaxTlxListIdx(i, iSntIdx, iFreqIdx) then continue;
            SntItem  := SntFaxTlxList.Items[iSntIdx];
            FreqItem := SntItem.FreqList.Items[iFreqIdx];
            FreqItem.Selected   := SntFaxTlxSelected;
         end; //for

         DisplaySntFaxTlxList(false);
      end
      else   //1개 선택시
         DisplaySntFaxTlxList(True);
   end else  // Sorting
   begin
      Screen.Cursor := crHourGlass;
      SntFaxTlxSortIdx := ACol;
      SntFaxTlxSortFlag[ACol] := not SntFaxTlxSortFlag[ACol];
      SntFaxTlxList.Sort(SntFaxTlxListCompare);
      DisplaySntFaxTlxList(False);
      Screen.Cursor := crDefault;
   end;
end;

procedure TForm_SCFH8801_SND.DRStrGrid_SntFaxTlxMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   ACol, ARow : Integer;
   ScreenP : TPoint;
   iSntIdx, iFreqIdx : Integer;
   SntItem  : pTESntFaxTlx;
   FreqItem : pTEFreqFaxTlx;
begin
  inherited;
   DRStrGrid_SntFaxTlx.MouseToCell(X, Y, ACol, ARow);
   if (ARow <= 0) or (ACol < 0) then Exit;

   SntFaxTlxColIdx := ACol;
   SntFaxTlxRowIdx := ARow;

   if Trim(DRStrGrid_SntFaxTlx.Cells[SNT_FAXTLX_FREQNO_IDX, ARow]) = '' then
      Exit;  // Data 없는 경우

   if ((Button = mbLeft) and (ssCtrl in Shift))
      or ((Button = mbLeft) and (ACol = SELECT_IDX)) then  // 선택 클릭
   begin
      if not GetSntFaxTlxListIdx(ARow, iSntIdx, iFreqIdx) then
      begin
         gf_ShowMessage(MessageBar, mtError, 1068, ''); //해당 정보를 읽어올 수 없습니다.
         Exit;
      end;
      SntItem  := SntFaxTlxList.Items[iSntIdx];
      FreqItem := SntItem.FreqList.Items[iFreqIdx];
      FreqItem.Selected := not FreqItem.Selected;
      DisplayFreqFaxTlxItem(SntItem, FreqItem);
   end
   else if Button = mbRight then
   begin
      gf_SelectStrGridRow(DRStrGrid_SntFaxTlx, SntFaxTlxRowIdx);

      // Popup Menu 처리
      if not GetSntFaxTlxListIdx(ARow, iSntIdx, iFreqIdx) then
      begin
         gf_ShowMessage(MessageBar, mtError, 1068, ''); //해당 정보를 읽어올 수 없습니다.
         Exit;
      end;
      SntItem := SntFaxTlxList.Items[iSntIdx];
      FreqItem := SntItem.FreqList.Items[iFreqIdx];

      GetCursorPos(ScreenP);
      DRPopupMenu_SntFax.Popup(ScreenP.X, ScreenP.Y);
   end;
end;

//------------------------------------------------------------------------------
//  Fax/Tlx 송신 확인 조회 조건
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRRadioBtn_SntFaxTlxClick(Sender: TObject);
var
   PreState : boolean;
begin
  inherited;
   FThreadHoldFlag := true;
   // 전체 or 오류 발생
   if (DRRadioBtn_FaxTlxAll.Checked) or (DRRadioBtn_FaxTlxError.Checked) then
   begin
      DRCheckBox_FaxTlxTotFreq.Enabled := True;
      if Trim(FaxTlxTotFreqChecked) <> '' then
         DRCheckBox_FaxTlxTotFreqClick(DRCheckBox_FaxTlxTotFreq);  //원상복귀
   end
   // 진행중 내역 (DRRadioBtn_FaxTlxSend.Checked)
   else
   begin
      PreState := DRCheckBox_FaxTlxTotFreq.Checked;
      DRCheckBox_FaxTlxTotFreq.Enabled := False;
      DRCheckBox_FaxTlxTotFreq.Checked := True;
      if PreState then
         FaxTlxTotFreqChecked := 'T'
      else
         FaxTlxTotFreqChecked := 'F';
   end;
   FThreadHoldFlag := false;
   FThreadHoldFlag := true; //전체보기시 되돌리므로

   if sGridSelectAllYN = 'Y' then
   begin
      DRStrGrid_SntFaxTlx.Cells[SELECT_IDX, 0] := gcSEND_MARK;
      SntFaxTlxSelected := true; //@@
   end
   else
   begin
      DRStrGrid_SntFaxTlx.Cells[SELECT_IDX, 0] := '';
      SntFaxTlxSelected := false; //@@
   end;
   DisplaySntFaxTlxList(True);

   // 재전송 버튼 처리 - !!!AAA
   DRSpeedBtn_FaxTlxResend.Enabled := False;
   if (DRRadioBtn_FaxTlxError.Checked)
      and (Trim(DRStrGrid_SntFaxTlx.Cells[SNT_FAXTLX_FREQNO_IDX, 1]) <> '') then  // Data 있는 경우
      gf_EnableBtn(Self.Tag, DRSpeedBtn_FaxTlxResend);  // 재전송버튼 Eanble

   FThreadHoldFlag := false;

end;

//------------------------------------------------------------------------------
// Fax 자료 전송 - 선택 내역 인쇄
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRSpeedBtn_SndFaxTlxPrintClick(Sender: TObject);
var
   iTotCnt, I, iTotPageCnt : Integer;
   iProcessCnt, iErrorCnt : Integer;
   SndItem : pTESndFaxTlx;
   sPrnFileName, sTmpFileName : string;
   sLogoPageNo, sTxtUnitInfo  : string;
begin
  inherited;

   FreeLoadXXX ;

   // 선택 항목 갯수 계산
   iTotCnt := 0;
   for I := 0 to SndFaxTlxList.Count -1 do
   begin
      SndItem := SndFaxTlxList.Items[I];
      if SndItem.Selected then Inc(iTotCnt);
   end;

   if iTotCnt <= 0 then    // 선택 항목 없는 경우
   begin
      gf_ShowMessage(MessageBar, mtInformation, 1009, '');  // 선택 항목이 없습니다.
      Exit;
   end;

//   if gvRealLogYN = 'Y' then gf_Log('Print FAXALL>> Start');
   gf_ShowMessage(MessageBar, mtInformation, 1100, ''); // 인쇄 중입니다.
   DisableForm;
   ShowProcessPanel(gwPrintingMsg, iTotCnt, False, True);
   iProcessCnt := 0;
   iErrorCnt   := 0;

if gvRealLogYN = 'Y' then gf_Log('Print ALL>>');

   for I := 0 to SndFaxTlxList.Count -1 do
   begin
      SndItem := SndFaxTlxList.Items[I];
      if not SndItem.Selected then Continue;

      Inc(iProcessCnt, 1);
      IncProcessPanel(iProcessCnt, 1);
      if gf_GetReportType(SndItem.ReportID) = gcRTYPE_CRPT then
      begin
//            if gvRealLogYN = 'Y' then gf_Log('Print FAXALL>> 그룹별 CryRpt start'+ IntToStr(i) + '/' + inttostr(SndFaxTlxList.Count));

            if not gf_Print_CRB_EI1_1(SndItem.ReportID, SndItem.RcvCompKor, SndItem.MediaNo, gcPTYPE_PRINT, ParentForm.JobDate,
            SndItem.AccName, SndItem.AccGrpType, SndItem.ClientMgrName, SndItem.ClientTelNo, SndItem.ClientFaxNo,
            SndItem.AccNoList, SndItem.PSList.PSStringList, SndItem.PSList.L_PSStringList, SndItem.PSList.R_PSStringList,
            SndItem.InsertAmd, gvStampSignFlag) then
            begin
//               if gvRealLogYN = 'Y' then gf_Log('Print FAXALL>> 그룹별 CryRpt Error proc'+ IntToStr(i) + '/' + inttostr(SndFaxTlxList.Count));
               ErrorProcessPanel(gwPrintErrMsg, False);
               Inc(iErrorCnt, 1);
               Continue;
            end;

//         end;
      end  else // if SRptType = gcRTYPE_TEXT then
      begin
         if Trim(SndItem.EditFileName) = '' then // Edit File이 존재하지 않는 경우
         begin
//            if gvRealLogYN = 'Y' then gf_Log('Print FAXALL>> not Edited Text Rpt start'+ IntToStr(i) + '/' + inttostr(SndFaxTlxList.Count));
            sTmpFileName := gvDirTemp + Self.Name + '.tmp'; //@@
            // Report Export
            if not gf_Print_CRB_EI1_1(SndItem.ReportID, SndItem.RcvCompKor, SndItem.MediaNo, gcPTYPE_PRINT, ParentForm.JobDate,
            SndItem.AccName, SndItem.AccGrpType, SndItem.ClientMgrName, SndItem.ClientTelNo, SndItem.ClientFaxNo,
            SndItem.AccNoList, SndItem.PSList.PSStringList, SndItem.PSList.L_PSStringList, SndItem.PSList.R_PSStringList,
            SndItem.InsertAmd, gvStampSignFlag) then
{
            if not gf_Export_CRB_EI1(SndItem.ReportID, SndItem.RcvCompKor, SndItem.MediaNo, sTmpFileName, ParentForm.JobDate,
                   SndItem.AccNoList, SndItem.PSStringList, gvStampSignFlag, iTotPageCnt) then
}
            begin
//               if gvRealLogYN = 'Y' then gf_Log('Print FAXALL>> not Edited Text Rpt Error Proc'+ IntToStr(i) + '/' + inttostr(SndFaxTlxList.Count));
               ErrorProcessPanel(gwPrintErrMsg, False);
               Inc(iErrorCnt, 1);
               Continue;
            end;
         end
         else
         begin
//            if gvRealLogYN = 'Y' then gf_Log('Print FAXALL>> Edited Text Rpt start'+ IntToStr(i) + '/' + inttostr(SndFaxTlxList.Count));
            sTmpFileName := SndItem.EditFileName;
         end;

         sPrnFileName := gvDirTemp + 'PRN' + gf_GetCurTime + '.tmp' ; //tmp

//         if gvRealLogYN = 'Y' then gf_Log('Print FAXALL>> Before ConverPagetext'+ IntToStr(i) + '/' + inttostr(SndFaxTlxList.Count));
         if not gf_ConvertPageText(sTmpFileName, sPrnFileName,
            SndItem.PSList.PSStringList, iTotPageCnt, sLogoPageNo, sTxtUnitInfo) then
         begin
//            if gvRealLogYN = 'Y' then gf_Log('Print FAXALL>> Before ConverPagetext Error Proc'+ IntToStr(i) + '/' + inttostr(SndFaxTlxList.Count));
            ErrorProcessPanel(gwPrintErrMsg, False);
            Inc(iErrorCnt, 1);
            Continue;
         end;

//         if gvRealLogYN = 'Y' then gf_Log('Print FAXALL>> Before PrintTextFile'+ IntToStr(i) + sPrnFileName);
         if not gf_PrintTextFile(sPrnFileName,
                                 gf_GetReportDirection(SndItem.ReportID),
                                 gcRTYPE_TEXT_MAX_LINE) then
         begin
//            if gvRealLogYN = 'Y' then gf_Log('Print FAXALL>> Before PrintTextFile Error Proc'+ IntToStr(i) + sPrnFileName);
            ErrorProcessPanel(gwPrintErrMsg, False);
            Inc(iErrorCnt, 1);
            Continue;
         end;
         if sTmpFileName <> SndItem.EditFileName then
         begin
//            if gvRealLogYN = 'Y' then gf_Log('Print FAXALL>> Before DeleteFile'+ IntToStr(i) + sTmpFileName);
            DeleteFile(sTmpFileName);
         end;

//         if gvRealLogYN = 'Y' then gf_Log('Print FAXALL>> Before DeleteFile'+ IntToStr(i) + sPrnFileName);
         DeleteFile(sPrnFileName);
      end;  // end of else TEXT Type Report
      sleep(1000); //@@
   end;  // end of for

   if iErrorCnt > 0 then // 오류 발생
   begin
//      if gvRealLogYN = 'Y' then gf_Log('Print FAXALL>> before ErrorProcessPanel');
      ErrorProcessPanel(gwPrintErrMsg +  '(총' + IntToStr(iErrorCnt) + '건), '
                        + gwClickOKMsg , True);
      gf_ShowMessage(MessageBar, mtError, 1102, '') // 인쇄 중 오류 발생
   end else
   begin
      HideProcessPanel;
      EnableForm;
      gf_ShowMessage(MessageBar, mtInformation, 1101, ''); // 인쇄 완료
   end;

//   if gvRealLogYN = 'Y' then gf_Log('Print FAXALL>> END');
end;

//------------------------------------------------------------------------------
//  선택 내역 재전송
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRSpeedBtn_FaxTlxResendClick(Sender: TObject);
var
   iTotCnt, I, K : Integer;
   iProcessCnt, iErrorCnt : Integer;
   SntItem  : pTESntFaxTlx;
   FreqItem : pTEFreqFaxTlx;
begin
  inherited;
   // 선택 항목 갯수 계산
   iTotCnt := 0;
   for I := 0 to SntFaxTlxList.Count -1 do
   begin
      SntItem := SntFaxTlxList.Items[I];
      for K := 0 to SntItem.FreqList.Count -1 do
      begin
         FreqItem := SntItem.FreqList.Items[K];
         if FreqItem.Selected then Inc(iTotCnt);
      end;  // end of for K
   end;  // end of for I

   if iTotCnt <= 0 then
   begin
      gf_ShowMessage(MessageBar, mtInformation, 1009, '');  // 선택 항목이 없습니다.
      Exit;
   end;

   FThreadHoldFlag := true;
   gf_ShowMessage(MessageBar, mtInformation, 1015, ''); // 처리 중입니다.
   DisableForm;
   gf_DisableSRMgrFrame(ParentForm);
   ShowProcessPanel(gwResendMsg, iTotCnt, False, True);
   iProcessCnt := 0;
   iErrorCnt   := 0;

   for I := 0 to SntFaxTlxList.Count -1 do
   begin
      SntItem := SntFaxTlxList.Items[I];
      if SntItem.FaxTlxGbn = gcSEND_TLX then continue; //20041217 add telex는 재전송 없음.
      for K := 0 to SntItem.FreqList.Count -1 do
      begin
         FreqItem := SntItem.FreqList.Items[K];

         if not FreqItem.Selected then Continue;

         Inc(iProcessCnt, 1);
         IncProcessPanel(iProcessCnt, 1);

         if not RetrySendFaxTlx(SntItem, FreqItem) then
         begin
            ErrorProcessPanel(gf_ReturnMsg(gvErrorNo) + ' (' + gvExtMsg+ ')' , False);
            Inc(iErrorCnt, 1);
         end;
      end;  // end of for K
   end;  // end of for I

   SntFaxTlxSelected := False;  // All Not Selected
   DRStrGrid_SntFaxTlx.Cells[SELECT_IDX, 0] := '';
   DisplaySntFaxTlxList(True); // 전체 내역 다시 Display

   if iErrorCnt > 0 then // 오류 발생
   begin
      ErrorProcessPanel(gwResendErrMsg +  '(총' + IntToStr(iErrorCnt) + '건), '
                        + gwClickOKMsg , True);
      gf_ShowMessage(MessageBar, mtError, 1070, ''); //재전송 중 오류 발생
   end
   else  // 정상 완료
   begin
      HideProcessPanel;
      gf_EnableSRMgrFrame(ParentForm);
      EnableForm;
      gf_ShowMessage(MessageBar, mtInformation, 1016, ''); // 처리 완료
   end;
   FThreadHoldFlag := false;
end;

//------------------------------------------------------------------------------
// Fax 송신 확인 - 선택 내역 인쇄
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRSpeedBtn_SntFaxTlxPrintClick(Sender: TObject);
var
   iTotCnt, I, K : Integer;
   iProcessCnt, iErrorCnt : Integer;
   SntItem  : pTESntFaxTlx;
   FreqItem : pTEFreqFaxTlx;
   sFileName, sRptType : string;
   sQury, ReportName : String;
begin
  inherited;
   // 선택 항목 갯수 계산
   iTotCnt := 0;
   for I := 0 to SntFaxTlxList.Count -1 do
   begin

      SntItem := SntFaxTlxList.Items[I];
      for K := 0 to SntItem.FreqList.Count -1 do
      begin
         FreqItem := SntItem.FreqList.Items[K];
         if FreqItem.Selected then Inc(iTotCnt);
      end;  // end of for K
   end;  // end of for I

   if iTotCnt <= 0 then    // 선택 항목 없는 경우
   begin
      gf_ShowMessage(MessageBar, mtInformation, 1009, '');  // 선택 항목이 없습니다.
      Exit;
   end;

   gf_ShowMessage(MessageBar, mtInformation, 1100, ''); // 인쇄 중입니다.
   DisableForm;
   ShowProcessPanel(gwPrintingMsg, iTotCnt, False, True);
   iProcessCnt := 0;
   iErrorCnt   := 0;

   FThreadHoldFlag := true;
   for I := 0 to SntFaxTlxList.Count -1 do
   begin
      SntItem := SntFaxTlxList.Items[I];
      for K := 0 to SntItem.FreqList.Count -1 do
      begin
         FreqItem := SntItem.FreqList.Items[K];

         if not FreqItem.Selected then Continue;

         Inc(iProcessCnt, 1);
         IncProcessPanel(iProcessCnt, 1);

//*******************P.H.S 2006.08.08*********************************************************************//
// PDF파일명 : ExportDir + YYYYMMDD_계좌번호(ID)_FaxNumber_서식명
//*******************************************************************************************************//
         sQury := '';
         ReportName := '';

         sFileName := gvDirTemp + gvCurDate + '_';

         if SntItem.AccGrpType = gcRGROUP_ACC then
            sFileName := sFileName + SntItem.AccNo
         else
            sFileName := sFileName + SntItem.AccName;

         if Trim(SntItem.AccId) <> '' then
            sFileName := sFileName + '(' + SntItem.AccId + ')';

         sQury := 'Select STR = fr.REPORT_NAME_KOR       '
                + ' From SCFAXSND_TBL fs, SCFAXIMG_TBL fi, SUREPID_TBL fr '
                + ' Where fs.SND_DATE = ''' + gvCurDate + ''' '
                + '   and fs.CUR_TOT_SEQ_NO = ' + IntToStr(FreqItem.CurTotSeqNo)
                + '   and fs.SND_DATE   = fi.SND_DATE    '
                + '   and fs.DEPT_CODE  = fi.DEPT_CODE   '
                + '   and fs.IDX_SEQ_NO = fi.IDX_SEQ_NO  '
                + '   and fi.REPORT_ID  = fr.REPORT_ID   ';

         ReportName := gf_ReturnStrQuery(sQury);

         sFileName := sFileName + '_' + SntItem.MediaNo
                                + '_' + ReportName + '_' + IntToStr(FreqItem.FreqNo) + '.tmp';

//         sFileName := gvDirTemp + Self.Name + '.tmp'; //@@

         if not gf_SaveSentImageToFile(gvCurDate, FreqItem.CurTotSeqNo, sFileName) then
         begin
            ErrorProcessPanel(gwPrintErrMsg, False);
            Inc(iErrorCnt, 1);
            Continue;
         end;

         sRptType := FreqItem.ReportType;
         if sRptType = gcRTYPE_CRPT then
         begin
            if not gf_PrintReport(sFileName) then
            begin
               ErrorProcessPanel(gwPrintErrMsg, False);
               Inc(iErrorCnt, 1);
               Continue;
            end;
         end
         else // if sRptType = gcRTYPE_TEXT then
         begin
            if not gf_PrintTextFile(sFileName, FreqItem.Direction, gcRTYPE_TEXT_MAX_LINE) then
            begin
               ErrorProcessPanel(gwPrintErrMsg, False);
               Inc(iErrorCnt, 1);
               Continue;
            end;
         end;
         DeleteFile(sFileName);
      end;  // end of for K
   end;  // end of for I

   if iErrorCnt > 0 then // 오류 발생
   begin
      ErrorProcessPanel(gwPrintErrMsg +  '(총' + IntToStr(iErrorCnt) + '건), '
                        + gwClickOKMsg , True);
      gf_ShowMessage(MessageBar, mtError, 1102, '') // 인쇄 중 오류 발생
   end else
   begin
      HideProcessPanel;
      EnableForm;
      gf_ShowMessage(MessageBar, mtInformation, 1101, ''); // 인쇄 완료
   end;
   FThreadHoldFlag := false;
end;

//------------------------------------------------------------------------------
//  Sent 선택 내역 Export
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRSpeedBtn_FaxTlxExportClick(Sender: TObject);
var
   iTotCnt, I, K : Integer;
   iProcessCnt, iErrorCnt : Integer;
   SntItem  : pTESntFaxTlx;
   FreqItem : pTEFreqFaxTlx;
   sReadFileName, sSaveFileName : string;
   sQury, ReportName : string;
begin
  inherited;
   // 선택 항목 갯수 계산
   iTotCnt := 0;
   for I := 0 to SntFaxTlxList.Count -1 do
   begin
      SntItem := SntFaxTlxList.Items[I];
      for K := 0 to SntItem.FreqList.Count -1 do
      begin
         FreqItem := SntItem.FreqList.Items[K];
         if FreqItem.Selected then Inc(iTotCnt);
      end;  // end of for K
   end;  // end of for I

   if iTotCnt <= 0 then    // 선택 항목 없는 경우
   begin
      gf_ShowMessage(MessageBar, mtInformation, 1009, '');  // 선택 항목이 없습니다.
      Exit;
   end;

   gf_ShowMessage(MessageBar, mtInformation, 1131, ''); // Export 중입니다.
   DisableForm;
   ShowProcessPanel(gwExportMsg, iTotCnt, False, True);
   iProcessCnt := 0;
   iErrorCnt   := 0;

   FThreadHoldFlag := true;
   for I := 0 to SntFaxTlxList.Count -1 do
   begin
      SntItem := SntFaxTlxList.Items[I];

      for K := 0 to SntItem.FreqList.Count -1 do
      begin
         FreqItem := SntItem.FreqList.Items[K];

         if not FreqItem.Selected then Continue;

         Inc(iProcessCnt, 1);
         IncProcessPanel(iProcessCnt, 1);

//*******************P.H.S 2006.08.08*********************************************************************//
// PDF파일명 : ExportDir + YYYYMMDD_계좌번호(ID)_FaxNumber_서식명
//*******************************************************************************************************//

         sSaveFileName := DREdit_SndMailDir.Text//gvDirExport
                        + gvCurDate + '_';

         if SntItem.AccGrpType = gcRGROUP_ACC then
            sSaveFileName := sSaveFileName + SntItem.AccNo
         else
            sSaveFileName := sSaveFileName + SntItem.AccName;

         if Trim(SntItem.AccId) <> '' then
            sSaveFileName := sSaveFileName + '(' + SntItem.AccId + ')';

         sQury := 'Select STR = fr.REPORT_NAME_KOR       '
                + ' From SCFAXSND_TBL fs, SCFAXIMG_TBL fi, SUREPID_TBL fr '
                + ' Where fs.SND_DATE = ''' + gvCurDate + ''' '
                + '   and fs.CUR_TOT_SEQ_NO = ' + IntToStr(FreqItem.CurTotSeqNo)
                + '   and fs.SND_DATE   = fi.SND_DATE    '
                + '   and fs.DEPT_CODE  = fi.DEPT_CODE   '
                + '   and fs.IDX_SEQ_NO = fi.IDX_SEQ_NO  '
                + '   and fi.REPORT_ID  = fr.REPORT_ID   ';

         ReportName := gf_ReturnStrQuery(sQury);

         sSaveFileName := sSaveFileName + '_' + SntItem.MediaNo
                                        + '_' + ReportName;

         sReadFileName := sSaveFileName + '_' + InttoStr(FreqItem.FreqNo) + '.tmp'; //gvDirTemp + Self.Name + '.tmp'; //@@

         if not gf_SaveSentImageToFile(gvCurDate, FreqItem.CurTotSeqNo, sReadFileName) then
         begin
            ErrorProcessPanel(gwExportErrMsg, False);
            Inc(iErrorCnt, 1);
            Continue;
         end;

         if FreqItem.ReportType = gcRTYPE_CRPT then //*** 일단!
         begin
            if FileExists(sReadFileName) then begin
              // 파일 형식에 따른 처리.
              if (gvFaxReportFileType <> gcFILE_TYPE_PDF) then
              // Rpt 처리.
              begin
                 with Datamodule_Settlenet.crpe1 do
                 begin
                    ReportName  := sReadFileName;
                    ExportOptions.FileName := sSaveFileName + '_' + IntToStr(FreqItem.FreqNo) + '.pdf';
                    ExportOptions.FileType := AdobeAcrobatPDF;
                    ProgressDialog := False;
                    //[Y.S.M] 2013.07.02 Printer Clear 추가  파일저장 및 미리보기 시
                    Printer.Clear;
                    Output := toExport;
                    try
                       Execute;
                    except
                       begin
                          gf_ShowMessage(MessageBar, mtInformation, 1132, ''); // Export중 오류
                          EnableForm;
                          CloseJob;
                          Exit;
                       end;
                    end;
                    CloseJob;
                 end;
              end else
              // PDF 처리.
              begin
                // 같은 파일명의 파일이 존재하면 삭제.
                if FileExists(sSaveFileName + '_' + IntToStr(FreqItem.FreqNo) + '.pdf') then
                begin
                  if not DeleteFile(sSaveFileName + '_' + IntToStr(FreqItem.FreqNo) + '.pdf') then
                  begin
                    gf_ShowMessage(MessageBar, mtInformation, 1132, ''); // Export중 오류
                    EnableForm;
                    Exit;
                  end;
                end;

                // 파일명 변경. (저장)
                if not RenameFile(sReadFileName, sSaveFileName + '_' + IntToStr(FreqItem.FreqNo) + '.pdf') then
                begin
                  gf_ShowMessage(MessageBar, mtInformation, 1132, ''); // Export중 오류
                  EnableForm;
                  Exit;
                end;
              end;
            end;
         {
            ErrorProcessPanel(gwExportErrMsg + '- 비텍스트 양식 레포트 Export 제외', False);
            Inc(iErrorCnt, 1);
            Continue;
          }
         end
         else // if sRptType = gcRTYPE_TEXT then
         begin
            if not gf_SplitTextFile(sReadFileName, sSaveFileName, FreqItem.TxtUnitInfo, IntToStr(FreqItem.FreqNo)) then
            begin
               ErrorProcessPanel(gwExportErrMsg, False);
               Inc(iErrorCnt, 1);
               Continue;
            end;
         end;
//*******************************************************************************************************//
//*******************************************************************************************************//
         DeleteFile(sReadFileName);
      end;  // end of for K
   end;  // end of for I

   if iErrorCnt > 0 then // 오류 발생
   begin
      ErrorProcessPanel(gwExportErrMsg +  '(총' + IntToStr(iErrorCnt) + '건), '
                        + gwClickOKMsg , True);
      gf_ShowMessage(MessageBar, mtError, 1132,
                     IntToStr(iErrorCnt) + '건의 비텍스트 양식 레포트는 Export 제외되었습니다.') // Export 중 오류 발생

   end else
   begin
      HideProcessPanel;
      EnableForm;
      gf_ShowMessage(MessageBar, mtInformation, 1133, ''); // Export 완료
   end;
   FThreadHoldFlag := false;

end;

//------------------------------------------------------------------------------
//  Fax/Tlx 자료전송 팝업 메뉴 처리
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.PopupSndFaxTlxClick(Sender: TObject);
var
   iSndIdx, i : Integer;
   SndItem : pTESndFaxTlx;
   SndItemIdxList : TStringList;
   iPrnType, iTotPageCnt : Integer;
   sRptType, sPrnFileName, sTmpFileName, sSaveFileName, sExpFileName, sExpFileNameBody, sFileName : string;
   sLogoPageNo, sTxtUnitInfo : string;
begin
  inherited;
   gf_ClearMessage(MessageBar);
   // 동일 레포트 Index Clear
   for I := 0 to SndFaxTlxList.Count -1 do
   begin
      SndItem := SndFaxTlxList.Items[I];
      SndItem.ReportIdx := -1;
      SndItem.RIdxSeqNo := -1;
   end;

   iSndIdx := GetSndFaxTlxListIdx(SndFaxTlxRowIdx);
   if iSndIdx < 0 then
   begin
      gf_ShowMessage(MessageBar, mtError, 1068, ''); //해당 정보를 읽어올 수 없습니다.
      Exit;
   end;
   SndItem  := SndFaxTlxList.Items[iSndIdx];

   case (Sender as TMenuItem).Tag of
      1: // 전송
      begin

         if EnvSetupInfo.ReadString(IntToStr(Self.Tag), 'TradeTodayCheck', 'N') = 'Y' then
         begin
           if gvCurDate <> ParentForm.JobDate then //
             if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 0, '당일 매매내역이 아닙니다. 전송하시겠습니까?', mbOKCancel, 0) = idCancel then
             begin
               gf_ShowMessage(MessageBar, mtInformation, 1082, ''); // 작업이 취소되었습니다.
               Exit;
             end;
         end;

         gf_ShowMessage(MessageBar, mtInformation, 1072, ''); // 전송 중입니다.

         SndItemIdxList := TStringList.Create;
         if not Assigned(SndItemIdxList) then
         begin
            gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); //List 생성 오류
            Exit;
         end;

         DisableForm;
         gf_DisableSRMgrFrame(ParentForm);
         ShowProcessPanel(gwSendMsg, 1, False, True);
         IncProcessPanel(1, 1);

         ///////////////////////////////////////////////////////////////////////
         //  2014.11.04  psh 전송전 계좌 체크 해서 메시지 띄우기
         ///////////////////////////////////////////////////////////////////////

         SndItemIdxList.Add(IntToStr(iSndIdx));  // 전송 처리될 Index
         FThreadHoldFlag := true;
         if SendFaxTlx(SndItemIdxList) then
         begin
            gf_ShowMessage(MessageBar, mtInformation, 1013, ''); //전송 완료
            HideProcessPanel;
            gf_EnableSRMgrFrame(ParentForm);
            EnableForm;
         end  else
         begin
            gf_ShowMessage(MessageBar, mtError, 1073, '');    // 전송 중 오류 발생
            ErrorProcessPanel(gwSendErrMsg + ' ' + gwClickOkMsg, True);
         end;
         FThreadHoldFlag := false;
         if Assigned(SndItemIdxList) then SndItemIdxList.Free;
      end;

      2:  // 전송 취소
      begin
         gf_ShowMessage(MessageBar, mtInformation, 1096, ''); //전송 취소 중입니다.

         if not fnFAXDataCancel(SndItem.CurTotSeqNo, self.Tag, MessageBar) then
         begin
            gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg); // 오류 발생
            Exit;
         end;

         // 전송 취소 완료
         //SndItem.CancFlag := True;
         //SndItem.ErrMsg   := '';

         // Display SndFaxTlxItem
         //DisplaySndFaxTlxItem(SndItem);

         // SntFaxTlxList Update & 송신 확인 Display
         SetSntFaxTlxListCanc(SndItem.CurTotSeqNo);

         gf_ShowMessage(MessageBar, mtInformation, 1016, ''); //처리 완료
      end;

      31:  // P.S 입력
      begin
      {
         if (SndItem.PSList.PSStringList.Count   = 0) and   // 입력된 PS가 없는 경우
            (SndItem.PSList.L_PSStringList.Count = 0) and
            (SndItem.PSList.R_PSStringList.Count = 0) then
             SetDefaultPSStringList(SndItem);               // 동일계좌의 PSList Setting
       }
         if SndItem.AccGrpType = gcRGROUP_ACC then // 계좌별
         begin
            gf_ShowPSInputBox(SndItem.PSList.PSStringList, SndItem.PSList.L_PSStringList,
                              SndItem.PSList.R_PSStringList, gvDeptCode, ParentForm.JobDate,
                              SndItem.AccNo, SndItem.SubAccNo, SndItem.MediaNo,
                              SndItem.ReportID, 'A',
                              gf_GetReportType(SndItem.ReportID),
                              gf_GetReportDirection(SndItem.ReportID));
         end else                                 // 그룹별
         begin
            gf_ShowPSInputBox(SndItem.PSList.PSStringList, SndItem.PSList.L_PSStringList,
                              SndItem.PSList.R_PSStringList, gvDeptCode, ParentForm.JobDate,
                              SndItem.AccName, '', SndItem.MediaNo,
                              SndItem.ReportID, 'G',
                              gf_GetReportType(SndItem.ReportID),
                              gf_GetReportDirection(SndItem.ReportID));
         end;
         // Display SndFaxTlxItem
//         DisplaySndFaxTlxItem(SndItem);
      end;

      32:  // P.S 취소
      begin
         if SndItem.AccGrpType = gcRGROUP_ACC then // 계좌별
         begin
            gf_ShowPSInputBox(SndItem.PSList.PSStringList, SndItem.PSList.L_PSStringList,
                              SndItem.PSList.R_PSStringList, gvDeptCode, ParentForm.JobDate,
                              SndItem.AccNo, SndItem.SubAccNo, SndItem.MediaNo,
                              SndItem.ReportID, 'A',
                              gf_GetReportType(SndItem.ReportID),
                              gf_GetReportDirection(SndItem.ReportID),'D');
         end else                                 // 그룹별
         begin
            gf_ShowPSInputBox(SndItem.PSList.PSStringList, SndItem.PSList.L_PSStringList,
                              SndItem.PSList.R_PSStringList, gvDeptCode, ParentForm.JobDate,
                              SndItem.AccName, '', SndItem.MediaNo,
                              SndItem.ReportID, 'G',
                              gf_GetReportType(SndItem.ReportID),
                              gf_GetReportDirection(SndItem.ReportID),'D');
         end;

         SndItem.PSList.PSStringList.Clear;
         SndItem.PSList.L_PSStringList.Clear;
         SndItem.PSList.R_PSStringList.Clear;

         // Displau SndFaxTlxItem
//         DisplaySndFaxTlxItem(SndItem);
      end;

      33: // Edit 취소
      begin
         if (gf_GetReportType(SndItem.ReportID) = gcRTYPE_TEXT) and
            (Trim(SndItem.EditFileName) <> '') then
         begin
            DeleteFile(SndItem.EditFileName);  // Delete Edit File
            SndItem.EditFileName := '';

            // Displau SndFaxTlxItem
//            DisplaySndFaxTlxItem(SndItem);

            // 동일 계좌 Setting
            SameAccCopyEditData(SndItem);
         end;
      end;

      34: //AMEND 추가 or 취소
      begin
         SndItem.InsertAmd := not SndItem.InsertAmd;

//         DisplaySndFaxTlxItem(SndItem);
      end;

      35: //종목제외 입력
      begin
         if SndItem.AccGrpType = gcRGROUP_GRP then  //그룹별
         begin
            gvB2301Data.sTradeDate := ParentForm.JobDate;
            gvB2301Data.sAccNo     := '';
            gvB2301Data.sGrpName   := SndItem.AccName;

            Application.CreateForm(TForm_SCFH2304, Form_SCFH2304);
            Form_SCFH2304.ShowModal;
         end else
         begin
            gvB2301Data.sTradeDate := ParentForm.JobDate;
            gvB2301Data.sAccNo     := gf_FormatAccNo(SndItem.AccNo, SndItem.SubAccNo);
            gvB2301Data.sGrpName   := SndItem.AccName;

            Application.CreateForm(TForm_SCFH2304, Form_SCFH2304);
            Form_SCFH2304.ShowModal;
         end;

         SetIssueExceptStat;
//         DisplaySndFaxTlxList(True);
      end;

      4, 5, 8: // 미리보기, 인쇄, Export
      begin
         if (Sender as TMenuItem).Tag = 5 then
            gf_ShowMessage(MessageBar, mtInformation, 1100, ''); // 인쇄 중입니다.
         if (Sender as TMenuItem).Tag = 8 then
            gf_ShowMessage(MessageBar, mtInformation, 1131, ''); // Export 중입니다.

         sRptType := gf_GetReportType(SndItem.ReportID);
         if sRptType = gcRTYPE_CRPT then  // Rpt Type Report의 경우
         begin
            if (Sender as TMenuItem).Tag = 4 then  //미리보기
               iPrnType := gcPTYPE_PREVIEW
            else if (Sender as TMenuItem).Tag = 5 then  // 인쇄
               iPrnType := gcPTYPE_PRINT
            else // Export
            begin

               //*******************P.H.S 2006.08.08*********************************************************************//
               // PDF파일명 : ExportDir + YYYYMMDD_계좌번호(ID)_FaxNumber_서식명
               //*******************************************************************************************************//

               sFileName := DREdit_SndMailDir.Text//gvDirExport
                            + ParentForm.JobDate + '_';

               if SndItem.AccGrpType = gcRGROUP_ACC then
                  sFileName := sFileName + SndItem.AccNo
               else
                  sFileName := sFileName + SndItem.AccName;

               if Trim(SndItem.AccId) <> '' then
                  sFileName := sFileName + '(' + SndItem.AccId + ')';

               sFileName := sFileName + '_' + SndItem.MediaNo
                                      + '_' + SndItem.ReportName;

               if sRptType = gcRTYPE_CRPT then//Rpt File
               begin
                  gvExportPDF  := 'Y';

                  sFileName := sFileName + '.pdf';
                  // Report Export  계좌별& 그룹별
                  if not gf_Export_CRB_EI1_1(SndItem.ReportID, SndItem.RcvCompKor, SndItem.MediaNo, sFileName, ParentForm.JobDate,
                     SndItem.AccName, SndItem.AccGrpType, SndItem.ClientMgrName, SndItem.ClientTelNo, SndItem.ClientFaxNo,
                     SndItem.AccNoList, SndItem.PSList.PSStringList, SndItem.PSList.L_PSStringList, SndItem.PSList.R_PSStringList,
                     SndItem.InsertAmd, gvStampSignFlag, iTotPageCnt) then
                  begin
                     gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg);
                     gvExportPDF := 'N';
                     Exit;
                  end;
               end;

               gf_ShowMessage(MessageBar, mtInformation, 1133, ''); // Export 완료
               gvExportPDF  := 'N';
               Exit;
            end;

            //ReportLib Call 계좌별& 그룹별
            if not gf_Print_CRB_EI1_1(SndItem.ReportID, SndItem.RcvCompKor, SndItem.MediaNo, iPrnType, ParentForm.JobDate,
                  SndItem.AccName, SndItem.AccGrpType, SndItem.ClientMgrName, SndItem.ClientTelNo, SndItem.ClientFaxNo,
                  SndItem.AccNoList, SndItem.PSList.PSStringList, SndItem.PSList.L_PSStringList, SndItem.PSList.R_PSStringList,
                  SndItem.InsertAmd, gvStampSignFlag) then
            begin
               gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg);  // Error 발생
               Exit;
            end;
            
            if (Sender as TMenuItem).Tag = 5 then
              gf_ShowMessage(MessageBar, mtInformation, 1101, ''); // 인쇄완료.
         end
         else // if SRptType = gcRTYPE_TEXT then
         begin
            if Trim(SndItem.EditFileName) = '' then // Edit File이 존재하지 않는 경우
            begin
               sTmpFileName := gvDirTemp + Self.Name + '.tmp'; //@@

               // Report Export  계좌별 & 그룹별
               if not gf_Export_CRB_EI1_1(SndItem.ReportID, SndItem.RcvCompKor, SndItem.MediaNo, sTmpFileName, ParentForm.JobDate,
                  SndItem.AccName, SndItem.AccGrpType, SndItem.ClientMgrName, SndItem.ClientTelNo, SndItem.ClientFaxNo,
                  SndItem.AccNoList, SndItem.PSList.PSStringList, SndItem.PSList.L_PSStringList, SndItem.PSList.R_PSStringList,
                  SndItem.InsertAmd, gvStampSignFlag, iTotPageCnt) then
               begin
                   gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg);  // Error 발생
                   Exit;
               end;

            end
            else  // Edit File이 존재하는 경우
               sTmpFileName := SndItem.EditFileName;

            if (Sender as TMenuItem).Tag = 4 then  // 미리보기
            begin
               //*******************P.H.S 2006.08.25*********************************************************************//
               // PDF파일명 : ExportDir + YYYYMMDD_계좌번호(ID)_FaxNumber_서식명
               //*******************************************************************************************************//

               sExpFileNameBody := DREdit_SndMailDir.Text//gvDirExport
                            + gvCurDate + '_';

               if SndItem.AccGrpType = gcRGROUP_ACC then
                  sExpFileNameBody := sExpFileNameBody + SndItem.AccNo
               else
                  sExpFileNameBody := sExpFileNameBody + SndItem.AccName;

               if Trim(SndItem.AccId) <> '' then
                  sExpFileNameBody := sExpFileNameBody + '(' + SndItem.AccId + ')';

               sExpFileNameBody := sExpFileNameBody + '_' + SndItem.MediaNo
                                  + '_' + SndItem.ReportName;

                //*******************************************************************************************************//
               //*******************************************************************************************************//

               if SndItem.AccGrpType = gcRGROUP_ACC then // 계좌별
               begin
                  sSaveFileName := gf_FormatEditFileName(ParentForm.JobDate, SndItem.ReportID,
                                   SndItem.AccNo, SndItem.SubAccNo, SndItem.MediaNo );
               end else                                 // 그룹별
               begin
                  sSaveFileName := gf_FormatEditFileName(ParentForm.JobDate, SndItem.ReportID,
                                   SndItem.AccName, SndItem.SubAccNo, SndItem.MediaNo);
               end;


               gvSRMgrEdited := False;

               if not gf_PreviewEditor(sTmpFileName, sSaveFileName,
                      gf_GetReportDirection(SndItem.ReportID), sExpFileNameBody, SndItem.PSList.PSStringList) then
               begin
                  gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg);  // Error 발생
                  Exit;
               end;
               if gvSRMgrEdited then  // Save Edit 내용
               begin
                  SndItem.EditFileName := sSaveFileName;
                  // Displau Snd FaxTlxItem
//                  DisplaySndFaxTlxItem(SndItem);
                  // 동일 계좌 Setting
                  SameAccCopyEditData(SndItem);
               end;
            end
            else if (Sender as TMenuItem).Tag = 5 then  // 인쇄
            begin
               sPrnFileName := gvDirTemp + 'PRN' + gf_GetCurTime + '.tmp';//@@
               if not gf_ConvertPageText(sTmpFileName, sPrnFileName,   // Conversion to Page Text
                  SndItem.PSList.PSStringList,iTotPageCnt, sLogoPageNo, sTxtUnitInfo) then
               begin
                  gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg);
                  Exit;
               end;
               if not gf_PrintTextFile(sPrnFileName,
                                       gf_GetReportDirection(SndItem.ReportID),
                                       gcRTYPE_TEXT_MAX_LINE) then
               begin
                  gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg);
                  Exit;
               end;

               gf_ShowMessage(MessageBar, mtInformation, 1101, ''); // 인쇄 완료
               DeleteFile(sPrnFileName);
            end
            else //Export
            begin
               //*******************P.H.S 2006.08.08*********************************************************************//
               // PDF파일명 : ExportDir + YYYYMMDD_계좌번호(ID)_FaxNumber_서식명
               //*******************************************************************************************************//

               sFileName := DREdit_SndMailDir.Text//gvDirExport
                            + ParentForm.JobDate + '_';

               if SndItem.AccGrpType = gcRGROUP_ACC then
                  sFileName := sFileName + SndItem.AccNo
               else
                  sFileName := sFileName + SndItem.AccName;

               if Trim(SndItem.AccId) <> '' then
                  sFileName := sFileName + '(' + SndItem.AccId + ')';

               sFileName := sFileName + '_' + SndItem.MediaNo
                                      + '_' + SndItem.ReportName;

               //*******************************************************************************************************//
               //*******************************************************************************************************//

               sExpFileName := gvDirTemp + 'EXP' + gf_GetCurTime + '.tmp'; //@@
               if not gf_ConvertPageText(sTmpFileName, sExpFileName,   // Conversion to Page Text
                  SndItem.PSList.PSStringList,iTotPageCnt, sLogoPageNo, sTxtUnitInfo) then
               begin
                  gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg);
                  Exit;
               end;

               if not gf_SplitTextFile(sExpFileName, sFileName, sTxtUnitInfo) then
               begin
                  gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg); // Error 발생
                  Exit;
               end;

               gf_ShowMessage(MessageBar, mtInformation, 1133, ''); // Export 완료
               DeleteFile(sExpFileName);

            end;  // end of else

            if sTmpFileName <> SndItem.EditFileName then
               DeleteFile(sTmpFileName);
         end;

      end;

      6: // 수신처 정보 조회
      begin
         gvB2102Data.sGrpName := SndITem.AccName;
         gvB2102Data.sSecType  := gcSEC_EQUITY;
         if SndItem.AccGrpType = gcRGROUP_ACC then
         begin
            gvB2102Data.sGrpName := '';
            gvB2102Data.sAccNo := SndItem.AccNo;
            gvB2102Data.sSubAccNo := SndItem.SubAccNo;
         end;
         gvB2102Data.sSendMtd  := SndItem.SendMtd;
         gvB2102Data.sNatCode  := SndItem.NatCode;
         gvB2102Data.sMediaNo  := SndItem.MediaNo;
         gvB2102Data.sIntTelYn := SndItem.IntTelYn;
         gf_CreateForm(2102);
      end;

      9: // 계좌 정보 조회
      begin
         gvB2101Data.sAccGrp := SndITem.AccName;
         if SndItem.AccGrpType = gcRGROUP_ACC then
         begin
            gvB2101Data.sAccGrp := '';
            gvB2101Data.sAccNo  := SndItem.AccNo;
            gvB2101Data.sUserSubAccNo := '';//필요없음
            if SndItem.AccAttr = 'A' then
               gvB2101Data.sAccAttrType := '2'  //외국인
            else if SndItem.SubAccNo > '' then
               gvB2101Data.sAccAttrType := '3'  //부계좌
            else
               gvB2101Data.sAccAttrType := '1' ;//국내
            gf_CreateForm(2101);
         end
         else
         begin
            gvB2106Data.sClientNM := SndItem.AccName;
            gf_CreateForm(2106);
         end;
      end;

      7: // 상세 내역 조회 (매매 or 부계좌 or 잔고조회)
      begin
        if copy(SndItem.ReportID,1,2) = 'E2' then //잔고보고서
        begin
          if SndItem.AccGrpType = gcRGROUP_GRP then  //그룹별
          begin
            gvB2303Data.sTradeDate := ParentForm.JobDate;
            gvB2303Data.sGrpName   := SndITem.AccName; //그룹명
            gf_CreateForm(2303);
          end
          else
          begin
            gvB2303Data.sTradeDate := ParentForm.JobDate;
            gvB2303Data.sAccNo     := SndItem.AccNo;
            gf_CreateForm(2303);
          end;
        end
        else //매매보고서
        begin
          if SndItem.AccGrpType = gcRGROUP_GRP then  //그룹별
          begin
            gvB2301Data.sTradeDate := ParentForm.JobDate;
            gvB2301Data.sGrpName   := SndITem.AccName; //그룹명
            gf_CreateForm(2301);
          end
          else
          begin

          end;
        end; //if 매매보고서 or 잔고보고서
      end;
   end; // end of case
end;

//------------------------------------------------------------------------------
//  Fax/Tlx 송신확인 팝업 메뉴 처리
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.PopupSntFaxTlxClick(Sender: TObject);
var
   SntItem  : pTESntFaxTlx;
   FreqItem : pTEFreqFaxTlx;
   iSntIdx, iFreqIdx : Integer;
   sFileName, sTmpFileName, sExpFileNameBody : string;
   sQury, ReportName : String;
   dt : double;
begin
  inherited;
   gf_ClearMessage(MessageBar);
   if not GetSntFaxTlxListIdx(SntFaxTlxRowIdx, iSntIdx, iFreqIdx) then
   begin
      gf_ShowMessage(MessageBar, mtError, 1068, ''); //해당 정보를 읽어올 수 없습니다.
      Exit;
   end;
   SntItem  := SntFaxTlxList.Items[iSntIdx];
   FreqItem := SntItem.FreqList.Items[iFreqIdx];

//******************************************************************************//
// 파일명 : YYYYMMDD_계좌번호(ID)_FaxNumber_서식명_회차
//******************************************************************************//
   sFileName := gvCurDate + '_';

   if SntItem.AccGrpType = gcRGROUP_ACC then
      sFileName := sfileName + SntItem.AccNo
   else
      sFileName := sfileName + SntItem.AccName;

   if Trim(SntItem.AccId) <> '' then
      sFileName := sFileName + '(' + SntItem.AccId + ')';

   sQury := 'Select STR = fr.REPORT_NAME_KOR       '
          + ' From SCFAXSND_TBL fs, SCFAXIMG_TBL fi, SUREPID_TBL fr '
          + ' Where fs.SND_DATE = ''' + gvCurDate + ''' '
          + '   and fs.CUR_TOT_SEQ_NO = ' + IntToStr(FreqItem.CurTotSeqNo)
          + '   and fs.SND_DATE   = fi.SND_DATE    '
          + '   and fs.TRADE_DATE = fi.TRADE_DATE  '
          + '   and fs.DEPT_CODE  = fi.DEPT_CODE   '
          + '   and fs.IDX_SEQ_NO = fi.IDX_SEQ_NO  '
          + '   and fi.REPORT_ID  = fr.REPORT_ID   ';

   ReportName := gf_ReturnStrQuery(sQury);


   sFileName := sFileName + '_' + SntItem.MediaNo + '_' + ReportName + '_' + InttoStr(FreqItem.FreqNo);
//******************************************************************************//


   case (Sender as TMenuItem).Tag of
      1: // 내역 보기
      begin
         dt := GetTickCount;

         DisableForm;
         //sFileName := gvDirTemp + Self.Name + '.tmp'; //@@
         sFileName := gvDirTemp + sFileName + '.tmp';
         // Save Image File
         if not gf_SaveSentImageToFile(gvCurDate, FreqItem.CurTotSeqNo, sFileName) then
         begin
            gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg); // Error 발생
            EnableForm;
            Exit;
         end;
         EnableForm;
         if FreqItem.ReportType = gcRTYPE_CRPT then  // Rpt Type Report의 경우
         begin
            if not gf_PreviewReport(sFileName) then
            begin
               gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg);  // Export시 Error 발생
               Exit;
            end;
         end  else  // if FreqItem.ReportType = gcRTYPE_TEXT then
         begin

         sExpFileNameBody     := DREdit_SndMailDir.Text + sFileName;
            if not gf_PreviewText(sFileName,
                   FreqItem.Direction,
                   gf_FormatAccNo(SntItem.AccNo, SntItem.SubAccNo) + ' ' + SntItem.AccName,
                   FreqItem.TxtUnitInfo,
                   sExpFileNameBody, IntToStr(FreqItem.FreqNo)) then
            begin
               gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg);  // Export시 Error 발생
               Exit;
            end;

//*******************************************************************************************************//
//*******************************************************************************************************//
         end;
         DeleteFile(sFileName);

         dt := GetTickCount -dt;
         gf_Log(FloatToStr(dt));
      end;

      2: // 인쇄
      begin
         gf_ShowMessage(MessageBar, mtInformation, 1100, ''); // 인쇄 중입니다.
         DisableForm;

         //sFileName := gvDirTemp + Self.Name + '.tmp'; //@@
         sFileName := gvDirTemp + sFileName + '.tmp';

         // Save Image File
         if not gf_SaveSentImageToFile(gvCurDate, FreqItem.CurTotSeqNo, sFileName) then
         begin
            gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg); // Error 발생
            EnableForm;
            Exit;
         end;
         if FreqItem.ReportType = gcRTYPE_CRPT then  // Rpt Type Report의 경우
         begin
            if not gf_PrintReport(sFileName) then
            begin
               gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg);  // Export시 Error 발생
               EnableForm;
               Exit;
            end;
         end   else  // if SntItem.ReportType = gcRTYPE_TEXT then
         begin
            if not gf_PrintTextFile(sFileName, FreqItem.Direction, gcRTYPE_TEXT_MAX_LINE) then
            begin
               gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg);
               EnableForm;
               Exit;
            end;
         end;
         DeleteFile(sFileName);
         EnableForm;
         gf_ShowMessage(MessageBar, mtInformation, 1101, ''); // 인쇄 완료
      end;

      3:  // 재전송
      begin
         FThreadHoldFlag := true;
         DisableForm;
         gf_ShowMessage(MessageBar, mtInformation, 1091, ''); // 재전송 중입니다.

         if not RetrySendFaxTlx(SntItem, FreqItem) then
         begin
            gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg); // 오류 발생
            EnableForm;
            FThreadHoldFlag := false;
            Exit;
         end;

         gf_ShowMessage(MessageBar, mtInformation, 1013, ''); //전송 완료
         EnableForm;
         FThreadHoldFlag := false;
      end;

      4:  // 전송 취소
      begin
         gf_ShowMessage(MessageBar, mtInformation, 1096, ''); //전송 취소 중입니다.

         FThreadHoldFlag := true;
         // 전송 취소
         FreqItem.RSPFlag := gcFAXTLX_RSPF_CANC;  // Cancel Setting
         FreqItem.ErrCode := '';
         FreqItem.ErrMsg  := '';
         FreqItem.OprId   := gvOprUsrNo;

         // Display SntFaxTlxItem
         //DisplayFreqFaxTlxItem(SntItem, FreqItem);

         if not fnFAXDataCancel(FreqItem.CurTotSeqNo, self.Tag, MessageBar) then
         begin
            gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg); // 오류 발생
            FreqItem.RSPFlag := gcFAXTLX_RSPF_FIN;  // Error Setting
            FreqItem.ErrCode := IntToStr(gvErrorNo);
            FreqItem.ErrMsg  := gvExtMsg;

            // Display SntFaxTlxItem
            DisplayFreqFaxTlxItem(SntItem, FreqItem);
            FThreadHoldFlag := false;
            Exit;
         end;

         // Display SntFaxTlxItem
         DisplayFreqFaxTlxItem(SntItem, FreqItem);

         gf_ShowMessage(MessageBar, mtInformation, 1016, ''); //처리 완료
         FThreadHoldFlag := false;

      end;

      5: // Export
      begin
         gf_ShowMessage(MessageBar, mtInformation, 1131, ''); // Export 중입니다.
         DisableForm;

         //sTmpFileName := gvDirTemp + Self.Name + '.tmp'; //@@
         sTmpFileName := gvDirTemp + sFileName + '.tmp'; //@@

         // Save Image File
         if not gf_SaveSentImageToFile(gvCurDate, FreqItem.CurTotSeqNo, sTmpFileName) then
         begin
            gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg); // Error 발생
            EnableForm;
            Exit;
         end;
         if FreqItem.ReportType = gcRTYPE_CRPT then  //*** 일단
         begin
            if FileExists(sTmpFileName) then begin
              // 파일 형식에 따른 처리.
              if (gvFaxReportFileType <> gcFILE_TYPE_PDF) then
              // Rpt 처리.
              begin
                 with Datamodule_Settlenet.crpe1 do
                 begin
                    ReportName  := sTmpFileName;
                    ExportOptions.FileName := DREdit_SndMailDir.Text + sFileName + '.pdf';
                    ExportOptions.FileType := AdobeAcrobatPDF;
                    ProgressDialog := False;
                    //[Y.S.M] 2013.07.02 Printer Clear 추가  파일저장 및 미리보기 시
                    Printer.Clear;
                    Output := toExport;
                    try
                       Execute;
                    except
                       begin
                          gf_ShowMessage(MessageBar, mtInformation, 1132, ''); // Export중 오류
                          EnableForm;
                          CloseJob;
                          Exit;
                       end;
                    end;
                    CloseJob;
                 end;
              end else
              // PDF 처리.
              begin
                // 같은 파일명의 파일이 존재하면 삭제.
                if FileExists(DREdit_SndMailDir.Text + sFileName + '.pdf') then
                begin
                  if not DeleteFile(DREdit_SndMailDir.Text + sFileName + '.pdf') then
                  begin
                    gf_ShowMessage(MessageBar, mtInformation, 1132, ''); // Export중 오류
                    EnableForm;
                    Exit;
                  end;
                end;

                // 파일명 변경. (저장)
                if not RenameFile(sTmpFileName, DREdit_SndMailDir.Text + sFileName + '.pdf') then
                begin
                  gf_ShowMessage(MessageBar, mtInformation, 1132, ''); // Export중 오류
                  EnableForm;
                  Exit;
                end;
              end;
            end;
//            gf_ShowDlgMessage(Self.Tag, mtWarning, 0, '텍스트 양식 레포트만 지원됩니다.', [mbOK], 0);
            gf_ShowMessage(MessageBar, mtInformation, 1133, ''); // Export 완료
         end
         else // if FreqItem.ReportType = gcRTYPE_TEXT then
         begin
            if not gf_SplitTextFile(sTmpFileName, sFileName, FreqItem.TxtUnitInfo,  IntToStr(FreqItem.FreqNo) ) then
            begin
               gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg); // Error 발생
               EnableForm;
               Exit;
            end;
            gf_ShowMessage(MessageBar, mtInformation, 1133, ''); // Export 완료
         end;
//*******************************************************************************************************//
//*******************************************************************************************************//
         DeleteFile(sFileName);
         DeleteFile(sTmpFileName);
         EnableForm;
      end;
   end; // end of case
end;

//------------------------------------------------------------------------------
// 송신확인에서 전회차 보기
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRCheckBox_FaxTlxTotFreqClick(Sender: TObject);
var
   I : Integer;
   SntItem : pTESntFaxTlx;
   MyOrgChecked : boolean;
begin
  inherited;
   if Trim(FaxTlxTotFreqChecked) <> '' then
   begin
      if FaxTlxTotFreqChecked = 'T' then
         MyOrgChecked := True
      else
         MyOrgChecked := False;
      FaxTlxTotFreqChecked := '';

      if MyOrgChecked <> DRCheckBox_FaxTlxTotFreq.Checked then
      begin
         DRCheckBox_FaxTlxTotFreq.Checked := MyOrgChecked;
         Exit;
      end;
   end;

   for I := 0 to SntFaxTlxList.Count -1 do
   begin
      SntItem := SntFaxTlxList.Items[I];
      SntItem.DisplayAll := DRCheckBox_FaxTlxTotFreq.Checked;
   end;

   if sGridSelectAllYN = 'Y' then
   begin
      DRStrGrid_SntFaxTlx.Cells[SELECT_IDX, 0] := gcSEND_MARK;
      SntFaxTlxSelected := true; //@@
   end
   else
   begin
      DRStrGrid_SntFaxTlx.Cells[SELECT_IDX, 0] := '';
      SntFaxTlxSelected := false; //@@
   end;
   DisplaySntFaxTlxList(True);

   // 재전송 버튼 처리 - !!!AAA
   DRSpeedBtn_FaxTlxResend.Enabled := False;
   if (DRRadioBtn_FaxTlxError.Checked)
      and (Trim(DRStrGrid_SntFaxTlx.Cells[SNT_FAXTLX_FREQNO_IDX, 1]) <> '') then  // Data 있는 경우
      gf_EnableBtn(Self.Tag, DRSpeedBtn_FaxTlxResend)  // 재전송버튼 Eanble
end;

//------------------------------------------------------------------------------
// 송신 확인에서 DblClick
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRStrGrid_SntFaxTlxDblClick(Sender: TObject);
var
   SntItem  : pTESntFaxTlx;
   iSntIdx, iFreqIdx : Integer;
begin
  inherited;
   // 회차가 없을 순 없다.
   if Trim(DRStrGrid_SntFaxTlx.Cells[SNT_FAXTLX_FREQNO_IDX, SntFaxTlxRowIdx]) = '' then
                             Exit;  // Data 없는 경우
   if not GetSntFaxTlxListIdx(SntFaxTlxRowIdx, iSntIdx, iFreqIdx) then
   begin
      gf_ShowMessage(MessageBar, mtError, 1068, ''); //해당 정보를 읽어올 수 없습니다.
      Exit;
   end;
   if iFreqIdx > 0 then Exit;  // 마지막 회차가 아닌 경우

   SntItem  := SntFaxTlxList.Items[iSntIdx];
   SntItem.DisplayAll := not SntItem.DisplayAll;
   DisplaySntFaxTlxList(True);
end;

//------------------------------------------------------------------------------
//  계좌 Identification 조회 여부
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRCheckBox_ViewClick(Sender: TObject);
begin
  inherited;
   SndFaxTlxSortIdx := SND_FAXTLX_ACCNO_IDX;
   SndFaxTlxSortFlag[SND_FAXTLX_ACCNO_IDX] := True;  // Accending
   SndFaxTlxList.Sort(SndFaxTlxListCompare);
//   DisplaySndFaxTlxList(True);

   SntFaxTlxSortIdx := SNT_FAXTLX_ACCNO_IDX;
   SntFaxTlxSortFlag[SNT_FAXTLX_ACCNO_IDX] := True;  // Accending
   SntFaxTlxList.Sort(SntFaxTlxListCompare);
   DisplaySntFaxTlxList(True);
end;

//------------------------------------------------------------------------------
//  EMail File 생성 Dir 지정
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRSpeedBtn_SndMailDirClick(Sender: TObject);
var
   sDirName  : string;
begin
  inherited;
   sDirName := DREdit_SndMailDir.Text;

   if SelectDirectory('', '', sDirName) then
   begin
      DREdit_SndMailDir.Text := sDirName + '\';
      gf_WriteFormStrInfo(Self.Name, 'EMailFile Dir', DREdit_SndMailDir.Text);
   end;
end;

//------------------------------------------------------------------------------
//  SndMailList의 Item Index Return
//------------------------------------------------------------------------------
function TForm_SCFH8801_SND.GetSndMailListIdx(pGridRowIdx: Integer): Integer;
var
   I : Integer;
   SndItem : pTFSndMail;
begin
   Result := -1;
   for I := 0 to SndMailList.Count -1 do
   begin
      SndItem := SndMailList.Items[I];
      if (SndItem.GridRowIdx = pGridRowIdx) then
      begin
         Result := I;
         Exit;
      end;
   end;  // end of for
end;

procedure TForm_SCFH8801_SND.DRStrGrid_SndMailFiexedRowClick(
  Sender: TObject; ACol: Integer);
var //@@
   iRptTypeIdx, i,iSndIdx : integer;
   SelectedRect: TGridRect;
   SndItem : pTFSndMail;
begin
  inherited;
   if ACol = SELECT_IDX then
   begin
      SndMailSelected := not (SndMailSelected);  // toggle
      if SndMailSelected then
         DRStrGrid_SndMail.Cells[SELECT_IDX, 0] := gcSEND_MARK
      else
         DRStrGrid_SndMail.Cells[SELECT_IDX, 0] := '';

      //@@ start
      SelectedRect := DRStrGrid_SndMail.Selection; //@@
      if SelectedRect.Bottom - SelectedRect.Top + 1 > 1 then //1개이상 multi 선택시
      begin
         for i := SelectedRect.Top to SelectedRect.Bottom do
         begin
            iSndIdx := GetSndMailListIdx(i);
            if iSndIdx < 0 then continue;
            SndItem := SndMailList.Items[iSndIdx];
            SndItem.Selected := SndMailSelected;
//            DisplaySndMailItem(SndItem);
         end;
      end
      else //1개만 선택시
//         DisplaySndMailList(true);
   end else  // Sorting
   begin
      Screen.Cursor := crHourGlass;
      SndMailSortIdx := ACol;
      SndMailSortFlag[ACol] := not SndMailSortFlag[ACol];
      SndMailList.Sort(SndMailListCompare);
//      DisplaySndMailList(false);
      Screen.Cursor := crDefault;
   end;
end;

procedure TForm_SCFH8801_SND.DRStrGrid_SndMailMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   ScreenP : TPoint;
   SndItem : pTFSndMail;
   FileItem : pTAttFile;
   ACol, ARow : Integer;
   iSndIdx, i : Integer;
   MenuItem : TMenuItem;   
begin
   DRStrGrid_SndMail.MouseToCell(X, Y, ACol, ARow);
   if (ARow <= 0) or (ACol < 0) then Exit;

   SndMailColIdx := ACol;
   SndMailRowIdx := ARow;

   // Data 없는 경우(메일 서식이 없는경우는 없다라고 간주)
   if Trim(DRStrGrid_SndMail.Cells[SND_MAIL_MAILID_IDX, ARow]) = '' then Exit;
   iSndIdx := GetSndMailListIdx(ARow);
   if iSndIdx < 0 then
   begin
      gf_ShowMessage(MessageBar, mtError, 1068, ''); //해당 정보를 읽어올 수 없습니다.
      Exit;
   end;
   SndItem := SndMailList.Items[iSndIdx];

   if ((Button = mbLeft) and (ssCtrl in Shift))
      or ((Button = mbLeft) and (ACol = SELECT_IDX)) then  // 전송 선택 클릭
   begin
      SndItem.Selected := not SndItem.Selected;
//      DisplaySndMailItem(SndItem);
   end
   else if Button = mbRight then  // PopupMenu 처리
   begin
      gf_SelectStrGridRow(DRStrGrid_SndMail, SndMailRowIdx);
      // 파일보기 SubMenu
      if SndITem.AttFileList <> nil then
      begin
         PopupSndMail2.Clear;
         for I := 0 to SndItem.AttFileList.Count -1 do
         begin
            FileItem := SndItem.AttFileList.Items[I] ;
            MenuItem := TMenuItem.Create(nil);
            MenuItem.Name    := 'PopupSndMail2_Sub' + IntToStr(I);
            MenuItem.Caption := ExtractFileName(FileItem.FileName);
            MenuItem.Tag     := I ;
            MenuItem.OnClick := PopupSndMailSubClick;
            PopupSndMail2.Add(MenuItem);
         end;
      end;
      // 파일 에러 시
      if SndItem.ErrMsg <> '' then
      begin
//         PopupSndMail0.Enabled := False; //E-mail 전송
         PopupSndMail1.Enabled := False; //파일보기
         PopupSndMail2.Enabled := False; //내역보기
      end else
      begin
//         PopupSndMail0.Enabled := true; //E-mail 전송
         PopupSndMail1.Enabled := true; //파일보기
         PopupSndMail2.Enabled := true; //내역보기
      end;
      // 편집여부
      if not SndItem.EditFlag then
         PopupSndMail3.Enabled := False
      else
         PopupSndMail3.Enabled := True;

      GetCursorPos(ScreenP);
      DRPopupMenu_SndMail.Popup(ScreenP.X, ScreenP.Y);
   end; // end of else
end;

//------------------------------------------------------------------------------
//  EMail 자료전송 팝업 메뉴 처리
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.PopupSndMailClick(Sender: TObject);
var
   iSndIdx, I : Integer;
   SndItem : pTFSndMail;
   FileItem : pTAttFile;
   SndItemIdxList : TStringList;
   sFilePath, sFileName, sFileDir : string;
   SR        : TSearchRec;
begin
  inherited;
   gf_ClearMessage(MessageBar);
   iSndIdx := GetSndMailListIdx(SndMailRowIdx);
   sFileName := '';
   sFilePath := '';
   sFileDir  := '';
   if iSndIdx < 0 then
   begin
      gf_ShowMessage(MessageBar, mtError, 1068, ''); //해당 정보를 읽어올 수 없습니다.
      Exit;
   end;
   SndItem := SndMailList.Items[iSndIdx];

   case (Sender as TMenuItem).Tag of
      0: // E-mail 전송
      begin
         if EnvSetupInfo.ReadString(IntToStr(Self.Tag), 'TradeTodayCheck', 'N') = 'Y' then
         begin
           if gvCurDate <> ParentForm.JobDate then //
             if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 0, '당일 매매내역이 아닙니다. 전송하시겠습니까?', mbOKCancel, 0) = idCancel then
             begin
               gf_ShowMessage(MessageBar, mtInformation, 1082, ''); // 작업이 취소되었습니다.
               Exit;
             end;
         end;
         
         gf_ShowMessage(MessageBar, mtInformation, 1072, ''); // 전송 중입니다.
         SndItemIdxList := TStringList.Create;
         if not Assigned(SndItemIdxList) then
         begin
            gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); //List 생성 오류
            Exit;
         end;

         SndItemIdxList.Add(IntToStr(iSndIdx));  // 전송 처리될 Index

         // 전송 대상 목록 생성 후 파일 갯수 체크.
         if not EmailManyFileCheck(SndItemIdxList) then
         begin
           gf_ShowMessage(MessageBar, mtInformation, 1082, ''); // 작업이 취소되었습니다.
           Exit;
         end;

         DisableForm;
         gf_DisableSRMgrFrame(ParentForm);
         ShowProcessPanel(gwSendMsg, 1, False, True);
         IncProcessPanel(1, 1);

         ///////////////////////////////////////////////////////////////////////
         //  2014.11.04  psh 전송전 계좌 체크 해서 메시지 띄우기
         ///////////////////////////////////////////////////////////////////////

         FThreadHoldFlag := true;
         if SendEMail(SndItemIdxList) then
         begin
            gf_ShowMessage(MessageBar, mtInformation, 1013, ''); //전송 완료
            HideProcessPanel;
            gf_EnableSRMgrFrame(ParentForm);
            EnableForm;
         end  else
         begin
            gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg);    // 전송 중 오류 발생
            ErrorProcessPanel(gwSendErrMsg + ' ' + gwClickOkMsg, True);
            EnableForm;
         end;
         FThreadHoldFlag := false;
         if Assigned(SndItemIdxList) then SndItemIdxList.Free;
      end;

      1: // 내역보기
      begin
         if not gf_ShowMailSnd(ParentForm.JobDate, SndItem) then
         begin
            gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg);  // Export시 Error 발생
            Enableform;
            Exit;
         end;
//         DisplaySndMailList(false);
      end;

      2: // 파일보기 (=미리보기) => PopupSndMailSubClick
      begin
      end;

      3: // 편집취소
      begin
         if Assigned(SndItem.AttFileList) then
         begin
            for I := 0 to SndItem.AttFileList.Count - 1 do
            begin
              FileItem := SndItem.AttFileList.Items[I];
              sFilePath := FileItem.FileName;

              if FindFirst(sFilePath, faAnyFile, SR) = 0 then
                 Repeat
                 begin
                    if not DeleteFile(sFilePath) then
                    begin
                       gf_ShowErrDlgMessage(Self.Tag, 9007,
                                            '[Delete File Error]: 원본파일이 사용중입니다.' , 0);
                       gf_ShowMessage(MessageBar, mtError, 9007, '');    // 파일 삭제 오류;
                       FindClose(SR);
                       Enableform;
                       exit;
                    end; // end of if
                 end;
                 Until FindNext(SR) <> 0;
            end;
            FindClose(SR);
            if IOResult <> 0 then  // Error 발생
            begin
               gf_ShowMessage(MessageBar, mtError, 1017, ' IOResult Error');    // 처리 중 오류 발생
               Enableform;
               exit;
            end;
            SndItem.EditFlag := False;
//            DisplaySndMailItem(SndItem);
         end; // end of if
      end;

      4: // 수신처 정보 조회
      begin
         gvB2103Data.sGrpName    := SndItem.AccGrpName;
         gvB2103Data.MailFormId  := SndItem.MailFormId;
         gf_CreateForm(2103);
      end;
      9: // 계좌 정보 조회
      begin
         gvB2106Data.sClientNM := SndITem.AccGrpName;
         gf_CreateForm(2106);
      end;
      5: // 상세내역조회
      begin
        if copy(SndItem.MailFormId,1,2) = 'E2' then //잔고조회
        begin
          gvB2303Data.sTradeDate := ParentForm.JobDate;
          gvB2303Data.sGrpName   := SndITem.AccGrpName; //그룹명
          gf_CreateForm(2303);
        end
        else   //매매조회 
        begin
          gvB2301Data.sTradeDate := ParentForm.JobDate;
          gvB2301Data.sGrpName   := SndITem.AccGrpName; //그룹명
          gf_CreateForm(2301);
        end;
      end;
   end; // end of case
end;

//------------------------------------------------------------------------------
//  Create EMail File
//------------------------------------------------------------------------------
function TForm_SCFH8801_SND.SendEMail(SndItemIdxList: TStringList): boolean;
var
  SndItem      : pTFSndMail;
  FileItem     : pTAttFile;
  SndMailData  : TEMailSendFormat;
  MailAttList  : TList;
  MailAttItem  : pEMailSendAttach;
  sFileName, sErrMsg, sTokenFileName: string;
  ErrFlag      : boolean;
  I, J, iSndIdx, iCnt  : Integer;
  StartTime : string;

  iRetrySnd: integer;
begin
   Result  := False;
   ErrFlag := False;

   if SndItemIdxList.Count <= 0 then Exit;

   // 전송 데이터 Clear
   for I := 0 to SndItemIdxList.Count -1 do
   begin
      iSndIdx := StrToInt(SndItemIdxList.Strings[I]);
      SndItem := SndMailList.Items[iSndIdx];
      SndItem.SendFlag     := True;
      SndItem.ErrMsg       := '';
   end; // end of for

   // 수신처 정보
   for I := 0 to SndItemIdxList.Count -1 do
   begin
      iSndIdx := StrToInt(SndItemIdxList.Strings[I]);
      SndItem := SndMailList.Items[iSndIdx];

      SndMailData.sCurDate        := gf_GetCurDate;
      SndMailData.sTradeDate      := ParentForm.JobDate;
      SndMailData.sDeptCode       := gvDeptCode;
      SndMailData.sSndUserName    := gvMailOprName;
      SndMailData.sReturnMailAddr := gvRtnMailAddr;
      SndMailData.sSubjectData    := SndItem.SubjectData;
      SndMailData.sMailBodyData   := SndItem.MailBodyData;
      SndMailData.sAccGrpType     := SndItem.AccGrpType;
      SndMailData.sSecType        := gcSEC_EQUITY;
      SndMailData.sGrpName        := SndItem.AccGrpName;
      SndMailData.sFmtAccNoList   := SndItem.AccList;
      SndMailData.sOprID          := gvOprUsrNo;
      SndMailData.sOprTime        := gf_GetCurTime;

      SndMailData.sRcvMailAddr    := BuildMailStrList(SndItem.MailAddr);
      SndMailData.sCCMailAddr     := BuildMailStrList(SndItem.CCMailAddr);
      SndMailData.sCCBlindAddr    := BuildMailStrList(SndItem.CCBlindAddr);
      SndMailData.sRcvMailName    := BuildMailStrList(SndItem.MailRcv);
      SndMailData.sCCMailName     := BuildMailStrList(SndItem.CCMailRcv);
      SndMailData.sCCBlindName    := BuildMailStrList(SndItem.CCBlindRcv);
      SndMailData.sMailFormGrp    := copy(SndItem.MailFormId, 1, 2);
      SndMailData.sMailFormID     := SndItem.MailFormId; //@@ 2004.11.01

      SndMailData.iCurTotSeqNo := -1;  // 초기화

      // Email 파일생성(이미 error 난것도 포함해서 진행한다)
      sFileName := gf_CreateMailFile(SndItem, True, ParentForm.JobDate);
      if Trim(sFileName) = '' then                 // 파일생성 Error
      begin
         ErrFlag  := True; // Error 발생
         sErrMsg := gf_ReturnMsg(gvErrorNo) + ' (' + gvExtMsg + ')';
         for J := 0 to SndItemIdxList.Count -1 do
         begin
            iSndIdx := StrToInt(SndItemIdxList.Strings[J]);
            SndItem := SndMailList.Items[iSndIdx];
            SndItem.ErrMsg := sErrMsg;
//            DisplaySndMailItem(SndItem);
         end; // end of for
         Exit;
      end;

      // File Attach
      MailAttList := TList.Create;
      if not Assigned(MailAttList) then
      begin
         gvErrorNo := 9004;
         gvExtMsg  := 'MailAttList - List Create Error';
         exit;
      end;

      iCnt := 1;
      sTokenFileName := '';
      while True do
      begin
         sTokenFileName := fnGetTokenStr(sFileName, gcSPLIT_MAILADDR, iCnt);
         if sTokenFileName = '' then break;
         New(MailAttItem);
         MailAttList.Add(MailAttItem);
         MailAttItem.sAttachFilePath := ExtractFilePath(sTokenFileName);   //FileName에 모든 경로가 있다.
         MailAttItem.sAttachFileName := ExtractFileName(sTokenFileName);
         Inc(iCnt);
      end;
      // 메일서버로 전송!!
      Starttime := '';
      Result := fnEMailDataSend(@SndMailData, MailAttList, Starttime);
      // 전송중 오류
      if not Result then
      begin
         for iRetrySnd:=1 to 5 do
         begin
           gf_Log('[E-mail] Retry Send. (' + IntToStr(iRetrySnd) + ')'
                + ' [GRP]' + SndItem.AccGrpName
                + ' [MailFormID]' + SndItem.MailFormId );
           Sleep(2000); // 잠시 쉬었다가 처리.
           Result := fnEMailDataSend(@SndMailData, MailAttList, Starttime); // 다시 한 번 시도.
           if Result then
           begin
             gf_Log('[E-mail] Retry Send Success. (' + IntToStr(iRetrySnd) + ')'
                  + ' [GRP]' + SndItem.AccGrpName
                  + ' [MailFormID]' + SndItem.MailFormId );
             Break;
           end;
         end;
         // 최종 전송 오류 처리.
         if (iRetrySnd = 5) and (Result = False) then
         begin
           SndITem.ErrMsg     := gf_ReturnMsg(gvErrorNo) + ' (' + gvExtMsg + ')';
           SndItem.StartTime  := gf_GetCurTime;
//           DisplaySndMailItem(SndItem);
           Exit;
         end;
      end;
   end;  // end of for

   // Clear MailList
   for I := 0 to MailAttList.Count - 1 do
   begin
      MailAttItem := MailAttList.Items[I];
      Dispose(MailAttItem);
   end;
   MailAttList.Clear;

   // SndMailList Update & 화면 Display & 송신 확인 내역 추가
   sTokenFileName := '';
   for I := 0 to SndItemIdxList.Count -1 do
   begin
      iSndIdx := StrToInt(SndItemIdxList.Strings[I]);
      SndItem := SndMailList.Items[iSndIdx];
      SndItem.StartTime := Starttime;
      for J := 0 to SndItem.AttFileList.Count - 1 do
      begin
        FileItem := SndItem.AttFileList.Items[J];
        sTokenFileName := fnGetTokenStr(sFileName, gcSPLIT_MAILADDR, J+1);
        FileItem.FileName := sTokenFileName;
        // File Directory가 temp이면 지워라.......
        if ExtractFilePath(FileItem.FileName) = gvDirTemp then
           DeleteFile(FileItem.fileName);
      end;
      SndItem.iCurTotSeqNo  := SndMailData.iCurTotSeqNo;  //총 전송 횟수
//      DisplaySndMailItem(SndItem);  // 화면 Display
      // 송신 확인 내역 추가
      if Result = True then  AddSntMailList(SndItem);
   end;  // end of for
   Result := True;
end;


//------------------------------------------------------------------------------
// 계좌별 선택 - 전송 내역
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRSpeedBtn_SndFaxTlxSelectClick(Sender: TObject);
var
   I, iIdx : Integer;
   SndItem : pTESndFaxTlx;
   sAccNo, sSubAccNo : string;
   sGrpName : string;
begin
  inherited;
   //!!! MODIFY -----------------------------------
   // 계좌 Sorting
   SndFaxTlxSortIdx := SND_FAXTLX_ACCNO_IDX;
   SndFaxTlxSortFlag[SndFaxTlxSortIdx] := True;  // Ascending
   SndFaxTlxList.Sort(SndFaxTlxListCompare);

   // 전체 선택 삭제
   SndFaxTlxSelected := True;
   DRStrGrid_SndFaxTlxFiexedRowClick(DRStrGrid_SndFaxTlx, SELECT_IDX);

   sAccNo    := '';
   sSubAccNo := '';
   sGrpName  := '';
   for I := 1 to DRStrGrid_SndFaxTlx.RowCount -1 do
   begin
      iIdx := GetSndFaxTlxListIdx(I);
      if iIdx >= 0 then
      begin
         SndItem := SndFaxTlxList.Items[iIdx];
         if SndItem.AccGrpType = gcRGROUP_GRP then
         begin
            if (sGrpName <> SndItem.AccName) then
            begin
               sGrpName := SndItem.AccName;
               SndItem.Selected := True;
            end;
         end else
         begin
            if (sAccNo <> SndItem.AccNo) or
               (sSubAccNo <> SndItem.SubAccNo) then
            begin
               sAccNo    := SndItem.AccNo;
               sSubAccNo := SndItem.SubAccNo;
               SndItem.Selected := True;
            end;
         end;
      end;
//      DisplaySndFaxTlxItem(SndItem);
   end;  // end of for
end;

//------------------------------------------------------------------------------
// 계좌별 선택 - 송신 확인
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRSpeedBtn_SntFaxTlxSelectClick(Sender: TObject);
var
   I, iSntIdx, iFreqIdx  : Integer;
   sAccNo, sSubAccNo, sGrpName : string;
   SntItem  : pTESntFaxTlx;
   FreqItem : pTEFreqFaxTlx;
begin
  inherited;
   //!!! MODIFY -----------------------------------
   // 선택 항목 갯수 계산
   if SntFaxTlxList.Count <= 0 then exit;

   FThreadHoldFlag := true;
   // 계좌 Sorting
   SntFaxTlxSortIdx := SNT_FAXTLX_ACCNO_IDX;
   SntFaxTlxSortFlag[SntFaxTlxSortIdx] := True;  // Ascending
   SntFaxTlxList.Sort(SntFaxTlxListCompare);

   // 전체 선택 삭제
   SntFaxTlxSelected := True;
   DRStrGrid_SntFaxTlxFiexedRowClick(DRStrGrid_SntFaxTlx, SELECT_IDX);

   sAccNo    := '';
   sSubAccNo := '';
   sGrpName  := '';
   for I := 1 to DRStrGrid_SntFaxTlx.RowCount -1 do
   begin
      GetSntFaxTlxListIdx(I, iSntIdx, iFreqIdx);
      if iSntIdx >= 0 then
      begin
         SntItem := SntFaxTlxList.Items[iSntIdx];
         if SntItem.AccGrpType = gcRGROUP_GRP then
         begin
            if (sGrpName <> SntItem.AccName) then
            begin
               FreqItem := SntItem.FreqList.Items[iFreqIdx];
               if FreqItem.LastFlag then
               begin
                  sGrpName := SntItem.AccName;
                  FreqItem.Selected := True;
               end;
            end;
         end else
         begin
            if (sAccNo <> SntItem.AccNo) or
               (sSubAccNo <> SntItem.SubAccNo) then
            begin
               FreqItem := SntItem.FreqList.Items[iFreqIdx];
               if FreqItem.LastFlag then
               begin
                  sAccNo    := SntItem.AccNo;
                  sSubAccNo := SntItem.SubAccNo;
                  FreqItem.Selected := True;
               end;
            end;
         end;
      end;
      DisplayFreqFaxTlxItem(SntItem, FreqItem);
   end;  // end of for
   FThreadHoldFlag := false;

end;


//------------------------------------------------------------------------------
// 전송후 내역List
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DisplaySntMailList;
var
   SntItem  : pTSntMail;
   FreqItem : pTFreqMail;
   I, K, J, iRowCnt, iRow : Integer;
   GrpName, sHintStr : string;
   AccGrpType, FmtAccNo: string;
begin
   DRLabel_SntMail.Caption := '>> 당일송신확인';
   with DRStrGrid_SntMail do
   begin
      // Display될 StrGrid의 RowCount 계산
      iRowCnt := 0;
      for I := 0 to SntMailList.Count -1 do
      begin
         SntItem := SntMailList.Items[I];

         for K := 0 to SntItem.FreqList.Count -1 do
         begin
            FreqItem := SntItem.FreqList.Items[K];

            if (not SntItem.DisplayAll) and   // 마지막 회차보기
               (not FreqItem.LastFlag) then Continue;

            if (DRRadioBtn_EmailSend.Checked) and      // 진행중
               ((FreqItem.RSPFlag = gcEMAIL_RSPF_FIN) or
                (FreqItem.RSPFlag = gcEMAIL_RSPF_CANC)) then Continue

            else if (DRRadioBtn_EmailError.Checked) and       // 오류내역
                ((FreqItem.RSPFlag <> gcEMAIL_RSPF_FIN) or
                 (Trim(FreqItem.ErrCode) = '')) then Continue;

            Inc(iRowCnt);
         end;  // end of for K

      end;  // end of for I

      if iRowCnt <= 0 then   // Data 없는 경우
      begin
         RowCount := 2;
         Rows[1].Clear;
         HintCell[SNT_MAIL_ACCGRP_IDX, 1]   := '';
         HintCell[SNT_MAIL_RCVCMP_IDX, 1]   := '';
         HintCell[SNT_MAIL_SNDCNF_IDX, 1]   := '';
         HintCell[SNT_MAIL_RSPF_IDX, 1]      := '';
         Exit;
      end;

      RowCount := iRowCnt + 1;
      iRow := 0;
      GrpName := '';
      FmtAccNo := '';
      for I := 0 to SntMailList.Count -1 do
      begin
         SntItem := SntMailList.Items[I];
         for K := 0 to SntItem.FreqList.Count -1 do  // 초기화
         begin
            FreqItem := SntItem.FreqList.Items[K];
            FreqItem.GridRowIdx := -1;
         end;

         AccGrpType := SntITem.AccGrpType;

         for K := 0 to SntItem.FreqList.Count -1 do
         begin
            FreqItem := SntItem.FreqList.Items[K];

            if (not SntItem.DisplayAll) and   // 마지막 회차보기
               (not FreqItem.LastFlag) then Continue;

            if (DRRadioBtn_EmailSend.Checked) and      // 진행중
               ((FreqItem.RSPFlag = gcEMAIL_RSPF_FIN) or
                (FreqItem.RSPFlag = gcEMAIL_RSPF_CANC)) then Continue

            else if (DRRadioBtn_EmailError.Checked) and       // 오류내역
                ((FreqItem.RSPFlag <> gcEMAIL_RSPF_FIN) or
                 (Trim(FreqItem.ErrCode) = '')) then Continue;

            Inc(iRow);
//            Rows[iRow].Clear;
            Cells[SNT_MAIL_ACCGRP_IDX, iRow] := '';
            HintCell[SNT_MAIL_ACCGRP_IDX, iRow]   := '';
            FreqItem.GridRowIdx := iRow;
            // 그룹명 / 계좌명
            sHintStr   := ' ' + MsgInterLine;
            if AccGrpType = gcRGROUP_GRP then
            begin
               if (GrpName <> FreqItem.AccGrpName) then
               begin
                  GrpName := FreqItem.AccGrpName;
                  Cells[SNT_MAIL_ACCGRP_IDX, iRow] := gcSIGMA + FreqItem.AccGrpName;
                  if Assigned(FreqItem.AccList) then
                  begin
                    for j := 0 to FreqItem.AccList.Count -1 do
                       sHintStr := sHintStr + FreqItem.AccList.Strings[j] + MsgInterLine;
                  end;
                  HintCell[SNT_MAIL_ACCGRP_IDX, iRow] := sHintStr;
               end;
            end else
            begin
               if (FmtAccNo <> FreqItem.AccList.Strings[0]) then
               begin
                  FmtAccNo := FreqItem.AccList.Strings[0];
                  Cells[SNT_MAIL_ACCGRP_IDX, iRow] := FreqItem.AccGrpName;
                  sHintStr :=  sHintStr + FreqItem.AccList.Strings[0] + MsgInterLine;
                  HintCell[SNT_MAIL_ACCGRP_IDX, iRow] := sHintStr;
               end;
            end;

            DisplayFreqMailItem(SntItem, FreqItem);
         end;  // end of for K
      end;  // end of for I
   end;  // end of with
   DRLabel_SntMail.Caption :=  DRLabel_SntMail.Caption + ' (' //+ gwQueryCnt
                                + IntToStr(iRowCnt) + ')';

//   gf_ShowMessage(MessageBar, mtInformation, 1021, gwQueryCnt + IntToStr(iRowCnt)); //조회 완료

end;

//------------------------------------------------------------------------------
//  전송 후 Mail info
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DisplayFreqMailItem(SntItem: pTSntMail; FreqItem: pTFreqMail);
var
   iRow, iReadCnt : Integer;
   sAccGrpName,sHintStr, sTmpStr : string;
begin
   with DRStrGrid_SntMail do
   begin
      iRow := FreqItem.GridRowIdx;
      if iRow <= 0 then Exit;   // List의 해당 Item은 Update되었으나 Display되지 않는 경우

      if (not SntItem.DisplayAll) and   // 마지막 회차보기 @@@@@@@@@
         (not FreqItem.LastFlag) then Exit;

      sAccGrpName := Trim(Cells[SNT_MAIL_ACCGRP_IDX, iRow]);  // 수신처
      Rows[iRow].Clear;

      HintCell[SNT_MAIL_RCVCMP_IDX, iRow]   := '';
      HintCell[SNT_MAIL_SNDCNF_IDX, iRow]   := '';
      HintCell[SNT_MAIL_RSPF_IDX, iRow]      := '';
      // 그룹명
      Cells[SNT_MAIL_ACCGRP_IDX, iRow] := sAccGrpName;

      // 회차
      Cells[2, iRow] := IntToStr(FreqItem.FreqNo);
      // 수신처
      Cells[SNT_MAIL_RCVCMP_IDX, iRow]    := Copy(FreqItem.RcvMailName, 1, Length(FreqItem.RcvMailName)-1);
      sHintStr  := ' ' + MsgInterLine;
      iReadCnt := 1;
      while True do
      begin
         sTmpStr := fnGetTokenStr(FreqItem.RcvMailAddr, gcSPLIT_MAILADDR, iReadCnt);
         if Trim(sTmpStr) = '' then break;
         sHintStr  := sHintStr + sTmpStr + MsgInterLine;
         Inc(iReadCnt);
      end;  // end of while
      HintCell[SNT_MAIL_RCVCMP_IDX, iRow] := sHintStr;
      // 제목
      Cells[4, iRow] := FreqItem.SubjectData;

      // 요청시간
      Cells[5, iRow] := gf_FormatTime(copy(FreqItem.SendTime, 1, 6));
      // 조작자정보
//      HintCell[SNT_MAIL_SNDCNF_IDX, iRow] := gwOprId + ':' + FreqItem.OprId;
      // 완료시간
      Cells[6, iRow] := gf_FormatTime(copy(FreqItem.SentTime, 1, 6));

      // Process
      Cells[SNT_MAIL_RSPF_IDX, iRow] := gf_GetMailResult(FreqItem.RSPFlag);

      // Error 확인 후 Error Message 출력
      if Trim(FreqItem.ErrCode) <> '' then
      begin
         if FreqItem.RSPFlag = gcEMAIL_RSPF_FIN then
            Cells[SNT_MAIL_RSPF_IDX, iRow] := gwRSPError;
            HintCell[SNT_MAIL_RSPF_IDX, iRow] := FreqItem.ErrMsg + Chr(13) + '(' + FreqItem.ExtMsg + ')';
      end;
      CellFont[SNT_MAIL_RSPF_IDX, iRow].Color := gf_GetMailRSPFlagColor(Cells[SNT_MAIL_RSPF_IDX, iRow]);
      SelectedFontColorCell[SNT_MAIL_RSPF_IDX, iRow] := CellFont[SNT_MAIL_RSPF_IDX, iRow].Color;

   end;  // end of with
end;


//------------------------------------------------------------------------------
//  전송 후 SntList에다가 추가시킨다
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.AddSntMailList(SndItem: pTFSndMail);
var
   I, iLastFreqNo : Integer;
   SntItem  : pTSntMail;
   FreqItem : pTFreqMail;
   AttItem  : pTAttFile;   
   FileItem : pTAttFile;
   ExistFlag : boolean;
   sAccNo    : string;
begin
   iLastFreqNo := 0;
   ExistFlag := False;
   // 기존에 존재하는지 확인
   for I := 0 to SntMailList.Count -1 do
   begin
      SntItem := SntMailList.Items[I];
      if (SntItem.AccGrpName = SndItem.AccGrpName) and
         (SntItem.AccGrpType = SndItem.AccGrpType) then
      begin
         ExistFlag := True;
         FreqItem := SntItem.FreqList.Items[0];  // 마지막 회차 정보
         iLastFreqNo := FreqItem.FreqNo;
         break;
      end;  // end of if
   end; // end of for

   if not ExistFlag then  // 존재하지 않을 경우
   begin
      New(SntItem);
      SntMailList.Add(SntItem);
      SntItem.AccGrpType   := SndItem.AccGrpType;
      SntItem.AccGrpName   := SndItem.AccGrpName;
      SntItem.DisplayAll   := DRCheckBox_EMailTotFreq.Checked;
      SntItem.FreqList     := TList.Create;
   end;

   New(FreqItem);
   SntItem.FreqList.Add(FreqItem);
   Inc(iLastFreqNo);
   FreqItem.FreqNo       := iLastFreqNo;
   FreqItem.CurTotSeqNo  := SndItem.iCurTotSeqNo;
   FreqItem.AccGrpName   := SndITem.AccGrpName;
   FreqItem.AccList      := TStringList.Create;
   for I := 0 to SndItem.AccList.Count -1 do
   begin
      sAccNo := SndItem.AccList.Strings[I];
      FreqItem.AccList.Add(sAccNo);
   end;
   FreqItem.RcvMailAddr  := BuildMailStrList(SndItem.MailAddr);
   FreqItem.CCMailAddr   := BuildMailStrList(SndItem.CCMailAddr);
   FreqItem.CCBlindAddr  := BuildMailStrList(SndItem.CCBlindAddr);
   FreqItem.RcvMailName  := BuildMailStrList(SndItem.MailRcv);
   FreqItem.CCMailName   := BuildMailStrList(SndItem.CCMailRcv);
   FreqItem.CCBlindName  := BuildMailStrList(SndItem.CCBlindRcv);
   FreqItem.SubjectData  := SndItem.SubjectData;
   FreqItem.MailBodyData := SndItem.MailBodyData;
   FreqItem.AttFileList  := TList.Create;
   FreqItem.SendTime     := '';
   FreqItem.SentTime     := '';
   FreqItem.RSPFlag      := gcEMAIL_RSPF_WAIT;
   FreqItem.ErrCode      := '';
   FreqItem.ExtMsg       := '';
   FreqItem.OprId        := gvOprUsrNo;

   // 화일 생성
   if not Assigned(SndItem.AttFileList) then Exit;
   for I := 0 to SndItem.AttFileList.Count -1 do
   begin
      FileItem := SndItem.AttFileList.Items[I];
      New(AttItem);
      FreqItem.AttFileList.Add(AttItem);
      AttItem.FileName := ExtractFileName(FileItem.FileName);
      AttItem.AttSeqNo := FileItem.AttSeqNo;
   end;

   SntItem.FreqList.Sort(FreqMailListCompare);  // 회차 역순으로 보여주기 위해 Sorting
   for I := 0 to SntItem.FreqList.Count -1 do     // Clear LastFlag
   begin
      FreqItem := SntItem.FreqList.Items[I];
      FreqItem.LastFlag := False;
   end;  // end of for
   FreqItem := SntItem.FreqList.Items[0];  // Last Flag Setting
   FreqItem.LastFlag := True;
   SntMailList.Sort(SntMailListCompare);  // SbtMailList Sorting
   DisplaySntMailList;

end;

//------------------------------------------------------------------------------
//  Mail 전송 확인 내역 Query 후 List 생성
//------------------------------------------------------------------------------
function TForm_SCFH8801_SND.QueryToSntMailList: boolean;

//-------------------
// 그룹별 계좌중에 ACC_ATTR 및 PGMAC_YN 수정
//-------------------
procedure UpdateSntMailList;
var
   SntItem  : pTSntMail;
   i : integer;
   TmpGrpname, TmpAccNo, TmpSubAccNo, SubDeptName : string;
begin
    TmpGrpName := '';

    for i := 0 to  SntMailList.Count -1 do
    begin
       SntItem := SntMailList.Items[i];
       if SntItem.AccGrpType <>  gcRGROUP_GRP then Continue;

       if TmpGrpName <> SntItem.AccGrpName then
       begin
          TmpGrpName := SntItem.AccGrpName;

          with ADOQuery_temp do
          begin
             Close;
             SQL.Clear;

             SQL.Add( 'SELECT SUB_DEPT_NAME = isnull(A.SUB_DEPT_NAME,'''')   '
                    + 'FROM   SUAGPAC_TBL G, SEACBIF_TBL A    '
                    + 'WHERE  G.DEPT_CODE = ''' + gvDeptCode + ''' '
                    + '  AND  G.GRP_NAME = ''' + TmpGrpName + ''' '
                    + '  AND  G.DEPT_CODE = A.DEPT_CODE '
                    + '  AND  G.ACC_NO = A.ACC_NO '
                    + '  AND  G.SEC_TYPE = ''' + gcSEC_EQUITY + ''' '
                    + ' ORDER BY A.SUB_DEPT_NAME DESC, A.ACC_NO ');

             Try
                gf_ADOQueryOpen(ADOQuery_temp);
             Except
                on E : Exception do
                begin    // Database 오류
                   gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_temp[SEACBIF_TBL]: ' + E.Message, 0);
                   gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_temp[SEACBIF_TBL]'); //Database 오류
                   Exit;
                end;
             End;
             SubDeptName := Trim(FieldByname('SUB_DEPT_NAME').asString);
          end;
       end;
       SntItem.SubDeptName := SubDeptName;
    end;
end;

var
   SntItem  : pTSntMail;
   FreqItem : pTFreqMail;
   FileItem : pTAttFile;
   iCurTotSeqNo, iFreqNo, I,iAttSeqNo  : Integer;
   GrpName, FmtAccNo, AccNo, SubAccNO : string;
begin
   Result := False;
   ClearSntMailList;

   with ADOQuery_Snt do
   begin
      //그룹별
      Close;
      SQL.Clear;
      SQL.Add(' SELECT MG.CUR_TOT_SEQ_NO, MG.GRP_NAME, MG.ACC_NO, MG.SUB_ACC_NO,  '
            + '        MS.RCV_MAIL_ADDR , MS.CC_MAIL_ADDR, MS.CC_BLIND_ADDR, '
            + '        MS.RCV_MAIL_NAME , MS.CC_MAIL_NAME, MS.CC_BLIND_NAME, '
            + '        MS.SUBJECT_DATA,   MS.MAIL_BODY_DATA, MS.ERR_CODE, MS.EXT_MSG,    '
            + '        MS.SEND_TIME,  MS.SENT_TIME, MS.OPR_TIME, MS.RSP_FLAG,'
            + '        MT.ATT_SEQ_NO, MT.ATTACH_FILENAME, MI.MAILFORM_GRP '
            + '   FROM SCMELGP_TBL MG, SCMELSND_TBL MS, SCMELATT_TBL MT, SCMELINF_TBL MI   '
            + '  WHERE MG.SND_DATE = ''' + gvCurDate + ''' '
            + '  AND   MG.DEPT_CODE = ''' + gvDeptCode + ''' '
            + '  AND   MG.SND_DATE = MS.SND_DATE             '
            + '  AND   MG.DEPT_CODE = MS.DEPT_CODE           '
            + '  AND   MG.CUR_TOT_SEQ_NO = MS.CUR_TOT_SEQ_NO '
            + '  AND   MS.SND_DATE = MT.SND_DATE             '
            + '  AND   MS.CUR_TOT_SEQ_NO = MT.CUR_TOT_SEQ_NO '
            + '  AND   MS.SND_DATE = MI.SND_DATE             '
            + '  AND   MS.CUR_TOT_SEQ_NO = MI.CUR_TOT_SEQ_NO '
//            + '  AND   MI.MAILFORM_GRP = ''E1'' '
            + '  AND   MI.MAILFORM_GRP in (''E1'', ''E2'') ' //잔고포함. 20060428
            + ' ORDER BY MG.GRP_NAME, MG.CUR_TOT_SEQ_NO,      '
            + '          MG.ACC_NO, MG.SUB_ACC_NO, MT.ATT_SEQ_NO ');

      Try
         gf_ADOQueryOpen(ADOQuery_Snt);
      Except
         on E : Exception do
         begin    // Database 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Snt[MAIL]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Snt[MAIL]'); //Database 오류
            Exit;
         end;
      End;

      GrpName   := '';
      FmtAccNo  := '';
      iCurTotSeqNo := -1;
      iFreqNo   := 0;
      while not Eof do
      begin
         if (Trim(FieldByName('GRP_NAME').asString) <> GrpName) then
         begin
            GrpName  := Trim(FieldByName('GRP_NAME').asString);
            iCurTotSeqNo := -1;
            iFreqNo      := 0;  // FreqNo Clear
            FmtAccNo := '';

            New(SntItem);
            SntMailList.Add(SntItem);

            SntItem.AccGrpName  := Trim(FieldByName('GRP_NAME').asString);
            SntItem.AccGrpType  := gcRGROUP_GRP;
            SntItem.DisplayAll  := DRCheckBox_EmailTotFreq.Checked;
            SntItem.FreqList    := TList.Create;
         end;

         if FieldByName('CUR_TOT_SEQ_NO').asInteger <> iCurTotSeqNo then
         begin
            iCurTotSeqNo := FieldByName('CUR_TOT_SEQ_NO').asInteger;

            Inc(iFreqNo);
            New(FreqItem);
            SntItem.FreqList.Add(FreqItem);
            FreqItem.FreqNo       := iFreqNo;
            FreqItem.AccGrpName   := Trim(FieldByName('GRP_NAME').asString);
            FreqItem.CurTotSeqNo  := FieldByName('CUR_TOT_SEQ_NO').asInteger;
            FreqItem.SubjectData  := Trim(FieldByName('SUBJECT_DATA').asString);
            FreqItem.MailBodyData := Trim(FieldByName('MAIL_BODY_DATA').asString);
            FreqItem.SendTime     := Trim(FieldByName('SEND_TIME').asString);
            FreqItem.SentTime     := Trim(FieldByName('SENT_TIME').asString);
            FreqItem.RSPFlag      := FieldByName('RSP_FLAG').asInteger;
            FreqItem.ErrCode      := Trim(FieldByName('ERR_CODE').asString);
            FreqItem.ErrMsg       := '';
            if Trim(FreqItem.ErrCode) <> '' then
               FreqItem.ErrMsg       := gf_ReturnMsg(gf_StrToInt(FreqItem.ErrCode));
            FreqItem.ExtMsg       := Trim(FieldByName('EXT_MSG').asString);
            FreqItem.OprTime      := Trim(FieldByName('OPR_TIME').asString);
            FreqItem.LastFlag     := False;
            FreqItem.GridRowIdx   := -1;

            FreqItem.RcvMailAddr  := Trim(FieldByName('RCV_MAIL_ADDR').asString);
            FreqItem.CCMailAddr   := Trim(FieldByName('CC_MAIL_ADDR').asString);
            FreqItem.CCBlindAddr  := Trim(FieldByName('CC_BLIND_ADDR').asString);
            FreqItem.RcvMailName  := Trim(FieldByName('RCV_MAIL_NAME').asString);
            FreqItem.CCMailName   := Trim(FieldByName('CC_MAIL_NAME').asString);
            FreqItem.CCBlindName  := Trim(FieldByName('CC_BLIND_NAME').asString);

            FreqItem.MailFormGrp  := Trim(FieldbyName('MAILFORM_GRP').asString);
            FreqItem.AccList      := TStringList.Create;
            FreqItem.AttFileList  := TList.Create;
            if (not Assigned(FreqItem.AccList)) or (not Assigned(FreqItem.AttFileList)) then
            begin
               gf_ShowErrDlgMessage(Self.Tag, 9004, '[QueryToSntMailList]', 0); // List 생성 오류
               gf_ShowMessage(MessageBar, mtError, 9004, '[QueryToSntMailList]'); //Database 오류
               Exit;
            end;
            // 계좌번호 생성
            FmtAccNo := gf_FormatAccNo(Trim(FieldByName('ACC_NO').asString),
                                       Trim(FieldByName('SUB_ACC_NO').asString));
            FreqItem.AccList.Add(FmtAccNo);

            // 첨부파일 생성
            New(FileItem);
            FreqItem.AttFileList.Add(FileItem);
            FileItem.FileName := Trim(FieldByName('ATTACH_FILENAME').asString);
            FileItem.AttSeqNo := FieldByName('ATT_SEQ_NO').asInteger;
            iAttSeqNo := FileItem.AttSeqNo;
        end; // end of if

        // 추가 계좌번호 생성
        if FmtAccNo <> gf_FormatAccNo(Trim(FieldByName('ACC_NO').asString),
                                     Trim(FieldByName('SUB_ACC_NO').asString)) then
        begin
           FmtAccNo := gf_FormatAccNo(Trim(FieldByName('ACC_NO').asString),
                                     Trim(FieldByName('SUB_ACC_NO').asString));
           FreqItem.AccList.Add(FmtAccNo);
        end;

        // 추가 AttachFile 생성
        if (FreqItem.AccList.Count = 1) and  //계좌번호 하나에 두개의 화일만 추가된다 
           (iAttSeqNo <> FieldByName('ATT_SEQ_NO').asInteger) then
        begin
           New(FileItem);
           FreqItem.AttFileList.Add(FileItem);
           FileItem.FileName := Trim(FieldByName('ATTACH_FILENAME').asString);
           FileItem.AttSeqNo := FieldByName('ATT_SEQ_NO').asInteger;
           iAttSeqNo := FileItem.AttSeqNo;
        end;

        Next;
      end;  // end of while

      //UpdateSntMailList;

      // 전체 Sorting
      SntMailList.Sort(SntMailListCompare);
      // 회차 역순으로 보여주기 위해 Sorting
      for I := 0 to SntMailList.Count -1 do
      begin
         SntItem := SntMailList.Items[I];
         SntItem.FreqList.Sort(FreqMailListCompare);
         FreqItem := SntItem.FreqList.Items[0]; //sorting 했으므로 맨마지막이 첫번째다.
         FreqItem.LastFlag := True;
      end;
   end; // end of with
   Result := True;
end;



//------------------------------------------------------------------------------
// 수신/참조/숨은참조 List 만들기
//------------------------------------------------------------------------------
function TForm_SCFH8801_SND.BuildMailStrList(SndItem: TStringList): string;
var
  I : integer;
  Len : integer;
  sTmpStr : string;
  sSplt : string;
begin
  sTmpSTr := '';
  if not Assigned(SndItem) then Exit;
  for I := 0 to SndItem.Count -1 do
  begin
    sTmpStr  := sTmpStr  + SndItem.Strings[I] + gcSPLIT_MAILADDR;
  end; // end of for
  Result := sTmpStr;
end;


//------------------------------------------------------------------------------
// Sorting;
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRStrGrid_SntMailFiexedRowClick(
  Sender: TObject; ACol: Integer);
begin
  inherited;
   if ACol = SELECT_IDX then
   begin
      SntMailSelected := not (SntMailSelected);  // toggle
      if SntMailSelected then
         DRStrGrid_SntMail.Cells[SELECT_IDX, 0] := gcSEND_MARK
      else
         DRStrGrid_SntMail.Cells[SELECT_IDX, 0] := '';
      DisplaySntMailList;
   end else  // Sorting
   begin
      Screen.Cursor := crHourGlass;
      SntMailSortIdx := ACol;
      SntMailSortFlag[ACol] := not SntMailSortFlag[ACol];
      SntMailList.Sort(SntMailListCompare);
      DisplaySntMailList;
      Screen.Cursor := crDefault;
   end;
end;

//------------------------------------------------------------------------------
//  PopUp Menu Show
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRStrGrid_SntMailMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   ScreenP : TPoint;
   SntItem : pTSntMail;
   FreqItem : pTFreqMail;
   FileItem  : pTAttFile;   
   iSntIdx, iFreqIdx : Integer;
   ACol, ARow,i : Integer;
   MenuItem : TMenuItem;   
begin
   DRStrGrid_SntMail.MouseToCell(X, Y, ACol, ARow);
   if (ARow <= 0) or (ACol < 0) then Exit;

   SntMailColIdx := ACol;
   SntMailRowIdx := ARow;

   if Trim(DRStrGrid_SntMail.Cells[SNT_MAIL_RCVCMP_IDX, ARow]) = '' then
      Exit;  // Data 없는 경우

   if ((Button = mbLeft) and (ssCtrl in Shift))
      or ((Button = mbLeft) and (ACol = SELECT_IDX)) then  // 전송 선택 클릭
   begin
      DisplaySntMailList;
   end
   else if Button = mbRight then  // PopupMenu 처리
   begin
      gf_SelectStrGridRow(DRStrGrid_SntMail, SntMailRowIdx);

      GetSntMailListIdx(SntMailRowIdx, iSntIdx, iFreqIdx) ;
      if iSntIdx <= -1 then
      begin
         gf_ShowMessage(MessageBar, mtError, 1068, ''); //해당 정보를 읽어올 수 없습니다.
         Exit;
      end;
      SntItem := SntMailList.Items[iSntIdx];
      FreqItem := SntITem.FreqList.Items[iFreqIdx];

      GetCursorPos(ScreenP);
      DRPopupMenu_SntMail.Popup(ScreenP.X, ScreenP.Y);
   end; // end of else
end;

//------------------------------------------------------------------------------
// Snt PopUp Menu  Execute
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.PopupSntMailClick(Sender: TObject);
var
   SntItem   : pTSntMail;
   FreqItem  : pTFreqMail;
   fileItem  : pTAttFile;
   iSntIdx, iFreqIdx, iCurTotSeqNo : Integer;
   sFileName, sDirName : string;
   i : integer;
begin
   gf_ClearMessage(MessageBar);

   if not GetSntMailListIdx(SntMailRowIdx, iSntIdx, iFreqIdx) then
   begin
      gf_ShowMessage(MessageBar, mtError, 1068, ''); //해당 정보를 읽어올 수 없습니다.
      Exit;
   end;
   SntItem  := SntMailList.Items[iSntIdx];
   FreqItem := SntItem.FreqList.Items[iFreqIdx];
   fileItem  := FreqItem.AttFileList.Items[0];

   case (Sender as TMenuItem).Tag of
      1: // 내역 보기
      begin
         iCurTotSeqNo := FreqItem.CurTotSeqNo;
         if not gf_ShowMailSnt(gvCurDate, FreqItem) then
         begin
            gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg);  // Export시 Error 발생
            Exit;
         end;
      end;

      3: //파일보기(=전송된 데이타) => PopupSntMailSubClick
      begin
      end;
//      4: // 인쇄 없앰
      5:  // 전송 취소
      begin
         gf_ShowMessage(MessageBar, mtInformation, 1096, ''); //전송 취소 중입니다.

         // 전송 취소
         FreqItem.RSPFlag := gcEMAIL_RSPF_CANC;  // Cancel Setting
         FreqItem.ErrCode := '';
         FreqItem.ExtMsg  := '';
         FreqItem.OprId   := gvOprUsrNo;

         // Display SntFaxTlxItem
         DisplayFreqMailItem(SntItem, FreqItem);

         if not fnEMailDataCancel(FreqItem.CurTotSeqNo) then
         begin
            gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg); // 오류 발생
            FreqItem.RSPFlag := gcEMAIL_RSPF_FIN;  // Error Setting
            FreqItem.ErrCode := IntToStr(gvErrorNo);
            FreqItem.ErrMsg  := gf_ReturnMsg(gvErrorNo);
            FreqItem.ExtMsg  := gvExtMsg;

            // Display SntFaxTlxItem
            DisplayFreqMailItem(SntItem, FreqItem);
            Exit;
         end;
         gf_ShowMessage(MessageBar, mtInformation, 1016, ''); //처리 완료
      end;
   end; // end of case
end;


//------------------------------------------------------------------------------
// SntList에서 SntIdx와 FreqIdx  가져오기
//------------------------------------------------------------------------------
function TForm_SCFH8801_SND.GetSntMailListIdx(pGridRowIdx: Integer;
  var pSntIdx, pFreqIdx: Integer): boolean;
var
   I, K : Integer;
   SntItem  : pTSntMail;
   FreqItem : pTFreqMail;
begin
   Result := False;
   pSntIdx  := -1;
   pFreqIdx := -1;

   for I := 0 to SntMailList.Count -1 do
   begin
      SntItem := SntMailList.Items[I];
      if not Assigned(SntItem.FreqList) then Exit;
      for K := 0 to SntItem.FreqList.Count -1 do
      begin
         FreqItem := SntItem.FreqList.Items[K];
         if FreqItem.GridRowIdx = pGridRowIdx then
         begin
            Result := True;
            PSntIdx  := I;
            pFreqIdx := K;
            Exit;
         end;  // end of if
      end;  // end of for K
   end;  // end of for I

end;

//------------------------------------------------------------------------------
// SntMail DlbClick
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRStrGrid_SntMailDblClick(Sender: TObject);
var
   SntItem  : pTSntMail;
   iSntIdx, iFreqIdx : Integer;
begin
  inherited;
   if Trim(DRStrGrid_SntMail.Cells[SNT_MAIL_RCVCMP_IDX, SntMailRowIdx]) = '' then
                             Exit;  // Data 없는 경우
   if not GetSntMailListIdx(SntMailRowIdx, iSntIdx, iFreqIdx) then
   begin
      gf_ShowMessage(MessageBar, mtError, 1068, ''); //해당 정보를 읽어올 수 없습니다.
      Exit;
   end;
   if iFreqIdx > 0 then Exit;  // 마지막 회차가 아닌 경우

   SntItem  := SntMailList.Items[iSntIdx];
   SntItem.DisplayAll := not SntItem.DisplayAll;
   DisplaySntMailList;
end;

//------------------------------------------------------------------------------
// EMail Export
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRSpeedBtn_ExportClick(Sender: TObject);
var
   SndITem : pTFSndMail;
   FileItem  : pTAttFile;
   sDefineDir : string;
   sDirName, sFileName : string;
   sSourceDir, sDestinDir : string;
   I, J, iProcessCnt, iTotalCnt,iErrorCnt : integer;
begin
  inherited;
gf_Log('EXPORT: START!!');
   sDefineDir := DREdit_SndMailDir.Text;   // 사용자가 지정한 디렉토리
   iProcessCnt := 0;
   iTotalCnt   := 0;
   iErrorCnt   := 0;
   //선택 데이터 갯수
   DisableForm;
   for I := 0 to SndMailList.Count -1 do
   begin
      SndITem := SndMailList.Items[I];
      if (SndITem.Selected) then  Inc(iTotalCnt);
   end;
   if iTotalCnt <= 0 then
   begin
      gf_ShowMessage(MessageBar, mtInformation, 1009, '');  // 선택 항목이 없습니다.
      Enableform;
      Exit;
   end;

   gf_DisableSRMgrFrame(ParentForm);
   ShowProcessPanel(gwCreFileMsg, iTotalCnt, False, True);
   for I := 0 to SndMailList.Count -1 do
   begin
      SndITem := SndMailList.Items[I];
      //선택된 것만
      if (not SndITem.Selected)  then Continue;

      Inc(iProcessCnt, 1);
      IncProcessPanel(iProcessCnt, 1);
      SndITem.Selected := false;
      SndItem.SendFlag := True;

      if SndITem.AttFileList = nil then
      begin
//         DisplaySndMailItem(SndItem);  // 화면 Display
         Inc(iErrorCnt);
         Continue;
      end;

      sDirName := sDefineDir + SndITem.AccGrpName + '\';
      if not DirectoryExists(sDirName) then
         if not CreateDir(sDirName) then Exit;

      if SndITem.EditFlag then          // UserData Directory에 있는 화일 카피
      begin
         for j := 0 to SndItem.AttFileList.Count -1 do
         begin
           FileItem  := SndItem.AttFileList.Items[J];

           sSourceDir := FileItem.FileName;
           sDestinDir := sDirName + ExtractFileName(FileItem.FileName);
           if FileExists(sSourceDir) then
           begin
              if Not gf_CopyFile(sSourceDir, sDestinDir) then
              begin
                  HideProcessPanel;
                  EnableForm;
                  gf_EnableSRMgrFrame(ParentForm);
                  gf_ShowMessage(MessageBar, mtError, 9006,
                                 '- FileCopy 오류');  // 파일 생성 오류
                  Exit;
              end; // if Not gf_CopyFile(sSourceDir, sDestinDir) then
           end; // if FileExists(sSourceDir) then
         end; // for j := 0 to SndItem.AttFileList.Count -1 do
      end  else
      begin
         // MailFile 생성
         sFileName := '';
         gf_CreateEMailFile(SndITem.MailFormID, sDirName, gvDeptCode, ParentForm.JobDate,
                            SndITem.AccGrpName, SndITem.AccList, sFileName, True);
         if sFileName = '' then
         begin
            SndITem.ErrMsg := gvExtMsg;
            Inc(iErrorCnt,1);
         end;

         //FileItem.FileName := fnGetTokenStr(sFileName, gcSPLIT_MAILADDR, J+1);
      end; // end of if SndITem.EditFlag
   end;
//   DisplaySndMailItem(SndItem);  // 화면 Display

   if iErrorCnt > 0 then // 오류 발생
   begin
      ErrorProcessPanel(gwCreFileErrMsg +  '(총' + IntToStr(iErrorCnt) + '건), '
                        + gwClickOKMsg , True);
      gf_ShowMessage(MessageBar, mtError, 9006, '');   // 파일 생성 오류
   end  else
   begin
      HideProcessPanel;
      EnableForm;
      gf_EnableSRMgrFrame(ParentForm);
      gf_ShowMessage(MessageBar, mtInformation, 1136, ''); // 파일 생성 완료
   end;
end;


//------------------------------------------------------------------------------
// Snd 파일보기 에서 SubMenu에 있는 해당 화일 보기
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.PopupSndMailSubClick(Sender: TObject);
var
   sFileName, sFilePath, sFileDir : string;
   iCnt, iSndIdx, I : integer;
   SndItem : pTFSndMail;
   FileItem : pTAttFile;
begin
   sFileName := '';
   sFilePath := '';
   sFileDir  := '';
   iSndIdx := GetSndMailListIdx(SndMailRowIdx);
   if iSndIdx < 0 then
   begin
      gf_ShowMessage(MessageBar, mtError, 1068, ''); //해당 정보를 읽어올 수 없습니다.
      Exit;
   end;
   SndItem := SndMailList.Items[iSndIdx];

   if SndItem.AccGrpType = gcRGroup_GRP then
      sFileDir := gvDirUserData + SndItem.AccGrpName + '\' // 사용자 디렉토리
   else
      sFileDir := gvDirUserData + SndItem.AccList.Strings[0] + '\';

   // 파일 생성
   Disableform;
   sFilePath := gf_ViewMailFile(SndItem, ParentForm.JobDate);
   if sFilePath = '' then
   begin
      SndItem.SendFlag := true;
      SndItem.ErrMsg   := gf_ReturnMsg(gvErrorNo) + ' (' + gvExtMsg + ')';
//      DisplaySndMailItem(SndItem);
      gf_ShowMessage(MessageBar, mtError, 9006, '');    // 파일 생성 오류;
      Enableform;
      exit;
   end;
   sFileName := fnGetTokenStr(sFilePath, gcSPLIT_MAILADDR, (Sender as TMenuItem).Tag+1);
   
   if ShellExecute(Handle, 'open', Pchar(sFileName), nil, nil, SW_SHOW) = SE_ERR_NOASSOC then
   begin
      WinExec(PChar('rundll32.exe shell32.dll,OpenAs_RunDLL ' +  sFileName), SW_SHOW);
      enableform;
      Exit;
   end;
   SndItem.EditFlag := True;

   //UserDataDirectory
   for I := 0 to SndItem.AttFileList.Count - 1  do
   begin
     FileItem := SndItem.AttFileList.Items[I];
     FileItem.FileName := fnGetTokenStr(sFilePath, gcSPLIT_MAILADDR, I+1);
   end;
//   DisplaySndMailItem(SndItem);
   Enableform;

end;



//------------------------------------------------------------------------------
// Snt 파일보기 에서 SubMenu에 있는 해당 화일 보기
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.PopupSntMailSubClick(Sender: TObject);
var
   SntItem  : pTSntMail;
   FreqItem : pTFreqMail;
   iSntIdx, iFreqIdx, iCurTotSeqNo : Integer;
   sFileName, sDirName : string;
begin
   Disableform;

   if not GetSntMailListIdx(SntMailRowIdx, iSntIdx, iFreqIdx) then
   begin
      gf_ShowMessage(MessageBar, mtError, 1068, ''); //해당 정보를 읽어올 수 없습니다.
      Enableform;
      Exit;
   end;
   SntItem  := SntMailList.Items[iSntIdx];
   FreqItem := SntItem.FreqList.Items[iFreqIdx];

   sFileName := gvDirTemp + (Sender as TMenuItem).Caption;
   if FileExists(sFileName) then DeleteFile(sFileName);
   if not gf_SaveMailAttachToFile(gvCurDate, FreqItem.CurTotSeqNo,
                                  (Sender as TMenuItem).Tag+1, sFileName) then
   begin
      gf_ShowErrDlgMessage(0, gvErrorNo, gvExtMsg, 0);  // Error 발생
      Enableform;
      Exit;
   end;
   if ShellExecute(Handle, 'open', Pchar(sFileName), nil, nil, SW_SHOW) = SE_ERR_NOASSOC then
   begin
      WinExec(PChar('rundll32.exe shell32.dll,OpenAs_RunDLL ' +  sFileName), SW_SHOW);
      enableform;
      exit;
   end;
   Enableform;
end;

//@@
procedure TForm_SCFH8801_SND.MgrOrFundFiltering();
begin
   gf_ClearMessage(MessageBar);
   case DRPageControl_Main.ActivePage.PageIndex of
      gcPAGE_IDX_FAXTLX:  // Fax/Tlx
      begin

         if sGridSelectAllYN = 'Y' then
         begin
            DRStrGrid_SndFaxTlx.Cells[SELECT_IDX, 0] := gcSEND_MARK;
            DRStrGrid_SntFaxTlx.Cells[SELECT_IDX, 0] := gcSEND_MARK;
            SndFaxTlxSelected := true; //@@
            SntFaxTlxSelected := true; //@@
         end
         else
         begin
            DRStrGrid_SndFaxTlx.Cells[SELECT_IDX, 0] := '';
            DRStrGrid_SntFaxTlx.Cells[SELECT_IDX, 0] := '';
            SndFaxTlxSelected := false; //@@
            SntFaxTlxSelected := false; //@@
         end;

//         DisplaySndFaxTlxList(True);
         DisplaySntFaxTlxList(True);
      end;

      gcPAGE_IDX_EMAIL: // EMail
      begin

         if sGridSelectAllYN = 'Y' then
         begin
            DRStrGrid_SndMail.Cells[SELECT_IDX, 0] := gcSEND_MARK;
            DRStrGrid_SntMail.Cells[SELECT_IDX, 0] := gcSEND_MARK;
            SndMailSelected := true; //@@
            SntMailSelected := true; //@@
         end
         else
         begin
            DRStrGrid_SndMail.Cells[SELECT_IDX, 0] := '';
            DRStrGrid_SntMail.Cells[SELECT_IDX, 0] := '';
            SndMailSelected := false; //@@
            SntMailSelected := false; //@@
         end;

//         DisplaySndMailList(True);
         DisplaySntMailList;
      end;
   end; // end of case
end;

//------------------------------------------------------------------------------
//  갱신 (SND만)
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRSpeedBtn_SndFaxTlxRefreshClick(
  Sender: TObject);
begin
   inherited;
   RefreshListNGrid( true, false ) ;
end;

//------------------------------------------------------------------------------
//  갱신 (SNT만)
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRSpeedBtn_SntFaxTlxRefreshClick(
  Sender: TObject);
begin
   inherited;
   FThreadHoldFlag := true;
   RefreshListNGrid( false, true ) ;
   FThreadHoldFlag := false;
end;

//------------------------------------------------------------------------------
//  갱신 (전체)
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRBitBtn4Click(Sender: TObject);
begin
   inherited;
   FThreadHoldFlag := true;
   RefreshListNGrid( true, true ) ;
   FThreadHoldFlag := false;
end;

//------------------------------------------------------------------------------
//  갱신
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.RefreshListNGrid(pRefreshSnd, pRefreshSnt : boolean);
var
  I : Integer;
  SndRtnValue, SntRtnValue: boolean;
begin
  if not gf_CheckValidDate(ParentForm.JobDate) then
  begin
    gf_ShowMessage(MessageBar, mtError, 1040, ''); // 일자 입력 오류
    ParentForm.DRMaskEdit_Date.SetFocus;
    Exit;
  end;

  gf_ShowMessage(MessageBar, mtInformation, 1020, ''); // 조회 중입니다.
  DisableForm;
  gf_DisableSRMgrFrame(ParentForm);

  SndRtnValue := false; // 전송대상 리스트 생성 이상 유무
  SntRtnValue := false; // 당일송싱확인 리스트 생성 이상 유무

  // 전송대사 리스트 확인
  if pRefreshSnd then
  begin
    SndRtnValue := fn_QueryToSndList;
  end;
  // 당일송신확인 리스트 확인
  if pRefreshSnt then
  begin
    SntRtnValue := fn_QueryToSntList;
  end;

  if pRefreshSnd then
  begin
    if SndRtnValue then
    begin
      if sGridSelectAllYN = 'Y' then
      begin
         DRStrGrid_Snd.Cells[SELECT_IDX, 0] := gcSEND_MARK;
         bSndSelected := true; //@@
      end
      else
      begin
         DRStrGrid_Snd.Cells[SELECT_IDX, 0] := '';
         bSndSelected := false; //@@
      end;
      DisplaySndList(True);
    end
    else // Error
    begin
      DRStrGrid_Snd.RowCount := 2;
      DRStrGrid_Snd.Rows[1].Clear;
    end;
  end;

  if pRefreshSnt then
  begin
    if SntRtnValue then
    begin
      if sGridSelectAllYN = 'Y' then
      begin
         DRStrGrid_Snt.Cells[SELECT_IDX, 0] := gcSEND_MARK;
         bSntSelected := true; //@@
      end
      else
      begin
         DRStrGrid_Snt.Cells[SELECT_IDX, 0] := '';
         bSntSelected := false; //@@
      end;
      DisplaySntList(True);
    end
    else  // Error
    begin
      DRStrGrid_Snt.RowCount := 2;
      DRStrGrid_Snt.Rows[1].Clear;
    end;
  end;

  gf_EnableSRMgrFrame(ParentForm);
  EnableForm;
  gf_ShowMessage(MessageBar, mtInformation, 1021, '');   // 조회 완료
end;

//------------------------------------------------------------------------------
//  Send 선택 내역 Export
//------------------------------------------------------------------------------
procedure TForm_SCFH8801_SND.DRSpeedBtn_SndFaxTlxExportClick(Sender: TObject);
var
   iTotCnt, I, iTotPageCnt : Integer;
   iProcessCnt, iErrorCnt : Integer;
   SndItem : pTESndFaxTlx;
   sPrnFileName, sTmpFileName, sExpFileName, sFileName : string;
   sLogoPageNo, sTxtUnitInfo  : string;
begin
   inherited;

   FreeLoadXXX ;

   // 선택 항목 갯수 계산
   iTotCnt := 0;
   for I := 0 to SndFaxTlxList.Count -1 do
   begin
      SndItem := SndFaxTlxList.Items[I];
      if SndItem.Selected then Inc(iTotCnt);
   end;

   if iTotCnt <= 0 then    // 선택 항목 없는 경우
   begin
      gf_ShowMessage(MessageBar, mtInformation, 1009, '');  // 선택 항목이 없습니다.
      Exit;
   end;

//   if gvRealLogYN = 'Y' then gf_Log('Export FAXALL>> start');
   gf_ShowMessage(MessageBar, mtInformation, 1131, ''); // Export 중입니다.
   DisableForm;
   ShowProcessPanel(gwExportMsg, iTotCnt, False, True);
   iProcessCnt := 0;
   iErrorCnt   := 0;

if gvRealLogYN = 'Y' then gf_Log('Export ALL>>');   
   for I := 0 to SndFaxTlxList.Count -1 do
   begin
      SndItem := SndFaxTlxList.Items[I];
      if not SndItem.Selected then Continue;

      Inc(iProcessCnt, 1);
      IncProcessPanel(iProcessCnt, 1);

//*******************P.H.S 2006.08.08*********************************************************************//
// PDF파일명 : ExportDir + YYYYMMDD_계좌번호(ID)_FaxNumber_서식명
//*******************************************************************************************************//
      sFileName := '';
      sFileName := DREdit_SndMailDir.Text//gvDirExport
                   + ParentForm.JobDate + '_';

      if SndItem.AccGrpType = gcRGROUP_ACC then
         sFileName := sFileName + SndItem.AccNo
      else
         sFileName := sFileName + SndItem.AccName;
         
      if Trim(SndItem.AccId) <> '' then
         sFileName := sFileName + '(' + SndItem.AccId + ')';

      sFileName := sFileName + '_' + SndItem.MediaNo
                             + '_' + SndItem.ReportName;

      if gf_GetReportType(SndItem.ReportID) = gcRTYPE_CRPT then //*** 일단!
      begin

         if Trim(SndItem.EditFileName) = '' then // Edit File이 존재하지 않는 경우
         begin
            gvExportPDF  := 'Y';

            sFileName := sFileName + '.pdf';
            // Report Export  계좌별& 그룹별
            if not gf_Export_CRB_EI1_1(SndItem.ReportID, SndItem.RcvCompKor, SndItem.MediaNo, sFileName, ParentForm.JobDate,
               SndItem.AccName, SndItem.AccGrpType, SndItem.ClientMgrName, SndItem.ClientTelNo, SndItem.ClientFaxNo,
               SndItem.AccNoList, SndItem.PSList.PSStringList, SndItem.PSList.L_PSStringList, SndItem.PSList.R_PSStringList,
               SndItem.InsertAmd, gvStampSignFlag, iTotPageCnt)  then
            begin
               ErrorProcessPanel(gwExportErrMsg+'-'+IntToStr(gvErrorNo)+'-'+gvExtMsg, False);
               Inc(iErrorCnt, 1);
               gvExportPDF := 'N';
               Continue;
            end;

            gvExportPDF := 'N';
         end
         else  // Edit File이 존재하는 경우
         begin
//          if gvRealLogYN = 'Y' then gf_Log('Export FAXALL>> edited start' + IntToStr(i) );
            sTmpFileName := SndItem.EditFileName;
         end;
      end
      else // gcRTYPE_TEXT
      begin

         if Trim(SndItem.EditFileName) = '' then // Edit File이 존재하지 않는 경우
         begin
//            if gvRealLogYN = 'Y' then gf_Log('Export FAXALL>> not edited start' + IntToStr(i) );

            sTmpFileName := gvDirTemp + Self.Name + '.tmp'; //@@
            // Report Export 계좌별& 그룹별
            if not gf_Export_CRB_EI1_1(SndItem.ReportID, SndItem.RcvCompKor, SndItem.MediaNo, sTmpFileName, ParentForm.JobDate,
               SndItem.AccName, SndItem.AccGrpType, SndItem.ClientMgrName, SndItem.ClientTelNo, SndItem.ClientFaxNo,
               SndItem.AccNoList, SndItem.PSList.PSStringList,SndItem.PSList.L_PSStringList, SndItem.PSList.R_PSStringList,
               SndItem.InsertAmd, gvStampSignFlag, iTotPageCnt)  then
            begin
               ErrorProcessPanel(gwExportErrMsg+'-'+IntToStr(gvErrorNo)+'-'+gvExtMsg, False);
               Inc(iErrorCnt, 1);
               Continue;
            end;
         end
         else  // Edit File이 존재하는 경우
         begin
//          if gvRealLogYN = 'Y' then gf_Log('Export FAXALL>> edited start' + IntToStr(i) );
            sTmpFileName := SndItem.EditFileName;
         end;

         sExpFileName := gvDirTemp + 'EXP' + gf_GetCurTime + '.tmp'; //@@
//         if gvRealLogYN = 'Y' then gf_Log('Export FAXALL>> before convertpage text' + IntToStr(i) );
         if not gf_ConvertPageText(sTmpFileName, sExpFileName,   // Conversion to Page Text
            SndItem.PSList.PSStringList,iTotPageCnt, sLogoPageNo, sTxtUnitInfo) then
         begin
//            if gvRealLogYN = 'Y' then gf_Log('Export FAXALL>> convertpage error proc ' + IntToStr(i) );
            ErrorProcessPanel(gwExportErrMsg+'-'+IntToStr(gvErrorNo)+'-'+gvExtMsg, False);
            Inc(iErrorCnt, 1);
            Continue;
         end;
//         if gvRealLogYN = 'Y' then gf_Log('Export FAXALL>> before Split text file' + IntToStr(i) );
         if not gf_SplitTextFile(sExpFileName, sFileName, sTxtUnitInfo) then
         begin
//            if gvRealLogYN = 'Y' then gf_Log('Export FAXALL>> Split text file error proc ' + IntToStr(i) );
            ErrorProcessPanel(gwExportErrMsg+'-'+IntToStr(gvErrorNo)+'-'+gvExtMsg, False);
            Inc(iErrorCnt, 1);
            Continue;
         end;

//         if gvRealLogYN = 'Y' then gf_Log('Export FAXALL>> before delete file ' + IntToStr(i) + sExpFileName);
         DeleteFile(sExpFileName);

         if sTmpFileName <> SndItem.EditFileName then
         begin
            DeleteFile(sTmpFileName);
//            if gvRealLogYN = 'Y' then gf_Log('Export FAXALL>> convertpage error proc ' + IntToStr(i) + sTmpFileName);
         end;
         sleep(1000); //@@
      end; //if

      gvExportPDF  := 'N';

   end; //for

   if iErrorCnt > 0 then // 오류 발생
   begin
//      if gvRealLogYN = 'Y' then gf_Log('Export FAXALL>> before error proc panel');
      ErrorProcessPanel(gwExportErrMsg +  '(총' + IntToStr(iErrorCnt) + '건), '
                        + gwClickOKMsg , True);
      gf_ShowMessage(MessageBar, mtError, 1132,
                     IntToStr(iErrorCnt) + '건의 레포트가 Export 제외되었습니다.');// Export 중 오류 발생
   end
   else
   begin
      HideProcessPanel;
      EnableForm;
      gf_ShowMessage(MessageBar, mtInformation, 1133, ''); // Export 완료
   end;
//   if gvRealLogYN = 'Y' then gf_Log('Export FAXALL>> END');
end;

procedure TForm_SCFH8801_SND.FreeLoadXXX;
var
  Snapshot: THandle;
  ModuleEntry: TModuleEntry32;
  NextModule: BOOL;
begin
   Snapshot := CreateToolhelp32Snapshot( TH32CS_SNAPALL, GetCurrentProcessID );
   NextModule := Module32First( Snapshot, ModuleEntry );
   while NextModule do
   begin
     if ( UpperCase (ModuleEntry.szModule) = 'WBHOOK32.DLL' )
     or ( UpperCase (ModuleEntry.szModule) = 'WBHKRES.DLL' ) then //
     begin
        gf_Log(ModuleEntry.szModule + ' found. free start');
        try
           FreeLibrary(ModuleEntry.hModule);
        except
           on E:Exception do
           begin
              gf_Log(ModuleEntry.szModule + ' found. free error' + E.Message);
           end;
        end;
        gf_Log(ModuleEntry.szModule + ' found. free end');
     end;

     NextModule := Module32Next( Snapshot, ModuleEntry );
   end;

   CloseHandle( Snapshot );
end;

//FAX Send용 PDF Export
procedure TForm_SCFH8801_SND.DRSpeedBtn_SndFaxTlxPDFExportClick(
  Sender: TObject);
begin
  inherited;
  //PDF Printer로 Printer전환
  if gf_DefPrinter2PDFPrinter() = false then Exit;

end;

procedure TForm_SCFH8801_SND.FormShow(Sender: TObject);
begin
  inherited;

    // 일자
  DRMaskEdit_Date1.Text := ParentForm.JobDate;
  
  // 갱신 해야됨
end;

procedure TForm_SCFH8801_SND.DRButton_DRLastClick(Sender: TObject);
begin
  inherited;
  DataExistDateJump(Trim(DRButton_DRLast.Caption));
end;

procedure TForm_SCFH8801_SND.DRCheckBox_ClientNMClick(Sender: TObject);
begin
  inherited;
//   DisplaySndFaxTlxList(True);

   DisplaySntFaxTlxList(True);

end;

procedure TForm_SCFH8801_SND.DRMaskEdit_Date1KeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
   if Key = #13 then
   begin
      if not gf_CheckValidDate(DRMaskEdit_Date1.Text) then
         gf_ShowErrDlgMessage(Self.Tag, 1040, '', 0); // 일자 입력 오류
      //if not Assigned(ActiveChildForm) then Exit;
      SendMessage(Self.Handle, WM_USER_CHANGE_JOBDATE, 0, 0);
      DRMaskEdit_Date1.SetFocus;
      DRMaskEdit_Date1.SelectAll;
   end;

end;

procedure TForm_SCFH8801_SND.DRMaskEdit_Date1Change(Sender: TObject);
begin
  inherited;
   ParentForm.JobDate := DRMaskEdit_Date1.Text;
end;

procedure TForm_SCFH8801_SND.DRBitBtn5Click(Sender: TObject);
begin
  inherited;


   gf_ShowMessage(MessageBar, mtInformation, 1100, ''); // 인쇄 중입니다.
   DisableForm;
   ShowProcessMsgBar;

   case DRPageControl_Main.ActivePage.PageIndex of

      gcPAGE_IDX_FAXTLX:  // Fax/Tlx
      begin

         try

            with DrStringPrint1 do
            begin
               Title := '매매 내역 전송 대상' ;
               UserText1 := '';
               UserText1 := '매매일자' + ':' + DRMaskEdit_Date1.EditText;

               // 기타 조회사항 (선택시만 Display)
               UserText2 := '[FAX/TELEX]';

               StringGrid := DRStrGrid_SndFaxTlx;
               Print;

               Title := '매매 내역 송신 확인' ;
               UserText1 := '';
               UserText1 := '매매일자' + ':' + DRMaskEdit_Date1.EditText;

               // 기타 조회사항 (선택시만 Display)
               UserText2 := '[FAX/TELEX]';

               StringGrid := DRStrGrid_SntFaxTlx;
               Print;
            end;

         except
         begin
            HideProcessMsgBar;
            EnableForm;
            Exit;
         end;
         end;

      end;

      gcPAGE_IDX_EMAIL: // EMail
      begin

         try

            with DrStringPrint1 do
            begin
               Title := '매매 내역 전송 대상' ;
               UserText1 := '';
               UserText1 := '매매일자' + ':' + DRMaskEdit_Date1.EditText;

               // 기타 조회사항 (선택시만 Display)
               UserText2 := '[E-MAIL]';

               StringGrid := DRStrGrid_SndMail;
               Print;

               Title := '매매 내역 송신 확인' ;
               UserText1 := '';
               UserText1 := '매매일자' + ':' + DRMaskEdit_Date1.EditText;

               // 기타 조회사항 (선택시만 Display)
               UserText2 := '[E-MAIL]';

               StringGrid := DRStrGrid_SntMail;
               Print;
            end;

         except
         begin
            HideProcessMsgBar;
            EnableForm;
            Exit;
         end;
         end;

      end;
   end; // end of case


   HideProcessMsgBar;
   EnableForm;
   gf_ShowMessage(MessageBar, mtInformation, 1101, ''); // 인쇄 완료

end;

//-------------------
// 그룹별 & 계좌별 Issue Except 정보
//-------------------
procedure TForm_SCFH8801_SND.SetIssueExceptStat;
var
   SndItem: pTESndFaxTlx;
   i, j: integer;
   TmpAccNo, TmpSubAccNo : string;
   dt : DWORD;
begin
   dt := GetTickCount;
   //국제부는 사용안함
   if (gvDeptCode = gcDEPT_CODE_INT) or (gvDeptCode = '06') then Exit;

   with ADOQuery_temp do
   begin

      Close;
      SQL.Clear;
      SQL.Add( ' SELECT E.ACC_NO  '
        + ' FROM   SCISSEX_TBL E   '
        + ' WHERE  E.DEPT_CODE = ''' + gvDeptCode   + ''' '
        + '  AND   E.SEC_TYPE  = ''' + gcSEC_EQUITY + ''' '
        + '  AND   E.TRADE_DATE= ''' + ParentForm.JobDate + ''' ');

       Try
          gf_ADOQueryOpen(ADOQuery_temp);
       Except
          on E : Exception do
          begin    // Database 오류
             gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_temp[SCISSEX_TBL]: ' + E.Message, 0);
             gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_temp[SCISSEX_TBL]'); //Database 오류
             Exit;
          end;
       End;

       for i := 0 to  SndFaxTlxList.Count -1 do
       begin
          SndItem := SndFaxTlxList.Items[i];
          SndItem.IssueExcept := False;

          First;
          while not EOF do
          begin
            for j:=0 to SndItem.AccNoList.Count -1 do
            begin
               if SndItem.IssueExcept then
               begin
                  Next;
                  continue;
               end;
               if Trim(FieldByName('ACC_NO').AsString) <> SndItem.AccNoList[j] then continue;
               SndItem.IssueExcept := True;
            end;

            Next;
          end;
       end;

   end;
   dt := GetTickCount-dt;
   gf_log('IssueExcept Create ===== ' + IntToStr(dt));

end;


procedure TForm_SCFH8801_SND.DRSpeedButton_GridPrintClick(Sender: TObject);
begin
  inherited;

   gf_ShowMessage(MessageBar, mtInformation, 1100, ''); // 인쇄 중입니다.
   DisableForm;
   ShowProcessMsgBar;

   case DRPageControl_Main.ActivePage.PageIndex of

      gcPAGE_IDX_FAXTLX:  // Fax/Tlx
      begin

         try

            with DrStringPrint1 do
            begin

               if TDRSpeedButton(Sender).Name = 'DRSpeedButton_SndFax' then
               begin
                  Title := '매매 내역 전송 대상' ;
                  UserText1 := '';
                  UserText1 := '매매일자' + ':' + DRMaskEdit_Date1.EditText;

                  // 기타 조회사항 (선택시만 Display)
                  UserText2 := '[FAX/TELEX]';

                  StringGrid := DRStrGrid_SndFaxTlx;
                  Print;
               end else
               begin
                  Title := '매매 내역 당일 송신 확인' ;
                  UserText1 := '';
                  UserText1 := '전송일자' + ':' + Copy(gvCurDate,1,4) + '-' +
                                                  Copy(gvCurDate,5,2) + '-' +
                                                  Copy(gvCurDate,7,2);

                  UserText2 := '[FAX/TELEX]';

                  StringGrid := DRStrGrid_SntFaxTlx;
                  Print;
               end;

            end;

         except
         begin
            HideProcessMsgBar;
            EnableForm;
            Exit;
         end;
         end;

      end;

      gcPAGE_IDX_EMAIL: // EMail
      begin

         try

            with DrStringPrint1 do
            begin

               if TDRSpeedButton(Sender).Name = 'DRSpeedButton_SndMail' then
               begin
                  Title := '매매 내역 전송 대상' ;
                  UserText1 := '';
                  UserText1 := '매매일자' + ':' + DRMaskEdit_Date1.EditText;

                  // 기타 조회사항 (선택시만 Display)
                  UserText2 := '[E-MAIL]';

                  StringGrid := DRStrGrid_SndMail;
                  Print;
               end else
               begin
                  Title := '매매 내역 당일 송신 확인' ;
                  UserText1 := '';
                  UserText1 := '전송일자' + ':' + Copy(gvCurDate,1,4) + '-' +
                                                  Copy(gvCurDate,5,2) + '-' +
                                                  Copy(gvCurDate,7,2);


                  UserText2 := '[E-MAIL]';

                  StringGrid := DRStrGrid_SntMail;
                  Print;
               end;
            end;

         except
         begin
            HideProcessMsgBar;
            EnableForm;
            Exit;
         end;
         end;

      end;
   end; // end of case


   HideProcessMsgBar;
   EnableForm;
   gf_ShowMessage(MessageBar, mtInformation, 1101, ''); // 인쇄 완료

end;

procedure TForm_SCFH8801_SND.DRButton_DRPriorClick(Sender: TObject);
begin
  inherited;
   DataExistDateJump(Trim(DRButton_DRPrior.Caption));
end;

procedure TForm_SCFH8801_SND.DRButton_DRNextClick(Sender: TObject);
begin
  inherited;
  DataExistDateJump(Trim(DRButton_DRNext.Caption));
end;

procedure TForm_SCFH8801_SND.DataExistDateJump(sSeparation: String);
var
   sDate, sSQL, sCurDate: string;
begin
   sSQL := '';
   sCurDate := Trim(DRMaskEdit_Date1.Text);
//ShowMessage(sSeparation);
   if (sSeparation = '<') or (sSeparation = '>|') then
      sSQL := sSQL + ' select MAX(TRADE_DATE) as STR         '
   else
   if sSeparation = '>' then
      sSQL := sSQL +' select MIN(TRADE_DATE) as STR         ';

   sSQL := sSQL + ' from SETRADE_TBL                       '
                + ' WHERE DEPT_CODE = '''+ gvDeptCode +''' ';
   if sSeparation <> '>|' then
      sSQL := sSQL + '   AND TRADE_DATE '+ sSeparation +' '''+ sCurDate +'''  ';
   sSQL := sSQL + ' order by 1 desc                        ';
//ShowMessage(sSQL);
   sDate := gf_ReturnStrQuery(sSQL);
   if sDate = '' then
   begin
      gf_ShowMessage(MessageBar, mtError, 0, '끝!!');
      Exit;
   end;
   DRMaskEdit_Date1.Text := sDate;
  DRBitBtn4Click(Nil);
end;

// 이메일 보고서 전송 전 파일 갯수 체크
function TForm_SCFH8801_SND.EmailManyFileCheck(
  pSndItemIdxList: TStringList): boolean;
var
  SndItem: pTFSndMail;
  i, iSndIdx, iCnt, iFileCnt, iItemCnt: integer;
  sManyFileStr,
  sFileName, sTotFileName: string;
begin
  Result := False;

  sManyFileStr := '';
  iItemCnt := 0;

  for i:=0 to pSndItemIdxList.Count-1 do
  begin
    iSndIdx := StrToInt(pSndItemIdxList.Strings[i]);
    SndItem := SndMailList.Items[iSndIdx];

    // 파일명 가져오기
    sTotFileName := gf_CreateMailFile(SndItem, False, ParentForm.JobDate);

    iCnt := 1;
    // 파일명 갯수 체크
    while True do
    begin
      sFileName := (fnGetTokenStr(sTotFileName, gcSPLIT_MAILADDR, iCnt));
      if (sFileName) = '' then Break;
      Inc(iCnt);
    end; // end of While

    // 파일명 체크 대상 생성. (기준: 30건)
    if ((iCnt-1) > 30) then
    begin
      // 많은 파일명을 가진 수신처 갯수가 5개 넘어가면 처리 그만. 
      if (iItemCnt >= 5) then
      begin
        sManyFileStr := sManyFileStr + '...' +  #13#10;
        Break;
      end;

      if sManyFileStr = '' then
        sManyFileStr := '[' + SndItem.AccGrpName + '] ' +
            SndItem.MailFormName + ' (' + IntToStr(iCnt-1) + '건)' + #13#10
      else
        sManyFileStr := sManyFileStr + '[' + SndItem.AccGrpName + '] ' +
            SndItem.MailFormName + ' (' + IntToStr(iCnt-1) + '건)' + #13#10;

      Inc(iItemCnt);
    end; // if ((iCnt-1) > 30) and ~
  end; // for i:=0 to SndMailList.Count-1 do

  if (sManyFileStr <> '') then
  begin
    // 팝업!!
    if gf_ShowDlgMessage(0, mtWarning, 0,
          '대량의 파일이 첨부된 수신처가 존재합니다.' + #13#10 +
          '전송 시 많은 시간이 소요됩니다.' + #13#10 +
          '그래도 전송하시겠습니까?' + #13#10 + #13#10 +
          sManyFileStr,
          mbOKCancel, 0) = idCancel then
    begin
      Exit;
    end; // if gf_ShowDlgMessage(0, mtWarning, 0, ~
  end; // if (sManyFileStr <> '') then

  Result := True;
end;

procedure TForm_SCFH8801_SND.DefSetSndStrGrid;
var
  i: integer;
begin
  with DRStrGrid_Snd do
  begin
    ColCount := SND_COL_COUNT;
    RowCount := 2;
    Rows[1].Clear;

    // Col 제목
    begin
      Cells[SELECT_IDX,        0] := '';
      Cells[iSndEmpIdx,        0] := '사번';
      Cells[iSndJobTimeIdx,    0] := '생성시간';
      Cells[iSndAccNoIdx,      0] := '계좌번호';
      Cells[iSndAccNameIdx,    0] := '계좌명';
      Cells[SND_TYPE_IDX,      0] := '전송구분';
      Cells[SND_DEST_NAME_IDX, 0] := '수신처명';
      Cells[SND_DEST_IDX,      0] := '수신처';
      Cells[SND_RPT_IDX,       0] := '보고서서식';
      Cells[SND_REQ_TIME_IDX,  0] := '요청시간';
      Cells[SND_FIN_TIME_IDX,  0] := '완료시간';
      Cells[SND_EXP_IDX,       0] := '전송제외';
    end;

    // Fixed Col Align
    begin
      AlignRow[0] := alCenter;
    end;

    // Not Fixed Col Align
    begin
      AlignCol[SELECT_IDX]        := alCenter;
      AlignCol[iSndEmpIdx]        := alCenter;
      AlignCol[iSndJobTimeIdx]    := alCenter;
      AlignCol[iSndAccNoIdx]      := alLeft;
      AlignCol[iSndAccNameIdx]    := alLeft;
      AlignCol[SND_TYPE_IDX]      := alCenter;
      AlignCol[SND_DEST_NAME_IDX] := alLeft;
      AlignCol[SND_DEST_IDX]      := alLeft;
      AlignCol[SND_RPT_IDX]       := alLeft;
      AlignCol[SND_REQ_TIME_IDX]  := alCenter;
      AlignCol[SND_FIN_TIME_IDX]  := alCenter;
      AlignCol[SND_EXP_IDX]       := alCenter;
    end;

    // ColWIdth
    begin
      if iSndColOpt > 0 then ColWidths[iSndEmpIdx] := -1
      else ColWidths[iSndEmpIdx] := 50;

      ColWidths[SELECT_IDX]        := 10;
      ColWidths[iSndEmpIdx]        := 50;
      ColWidths[iSndJobTimeIdx]    := 60;
      ColWidths[iSndAccNoIdx]      := 110;
      ColWidths[iSndAccNameIdx]    := 160;
      ColWidths[SND_TYPE_IDX]      := 55;
      ColWidths[SND_DEST_NAME_IDX] := 105;
      ColWidths[SND_DEST_IDX]      := 250;
      ColWidths[SND_RPT_IDX]       := 260;
      ColWidths[SND_REQ_TIME_IDX]  := 66;
      ColWidths[SND_FIN_TIME_IDX]  := 60;
      ColWidths[SND_EXP_IDX]       := 60;
    end;
  end;
end;

procedure TForm_SCFH8801_SND.DefSetSntStrGrid;
var
  i: integer;
begin
  with DRStrGrid_Snt do
  begin
    ColCount := SNT_COL_COUNT;
    RowCount := 2;
    Rows[1].Clear;

    // Col 제목
    begin
      Cells[SELECT_IDX,        0] := '';
      Cells[SNT_EMP_IDX,       0] := '사번';
      Cells[SNT_ACC_NO_IDX,    0] := '계좌번호';
      Cells[SNT_ACC_NAME_IDX,  0] := '계좌명';
      Cells[SNT_TYPE_IDX,      0] := '전송구분';
      Cells[SNT_DEST_NAME_IDX, 0] := '수신처명';
      Cells[SNT_DEST_IDX,      0] := '수신처';
      Cells[SNT_RPT_IDX,       0] := '보고서서식';
      Cells[SNT_REQ_TIME_IDX,  0] := '시작시간';
      Cells[SNT_FIN_TIME_IDX,  0] := '완료시간';
      Cells[SNT_RESEND_IDX,    0] := '재전송';
      Cells[SNT_PRC_IDX,       0] := 'Process';
      Cells[SNT_PAGE_IDX,      0] := 'Page';
    end;

    // Fixed Col Align
    begin
      AlignRow[0] := alCenter;
    end;

    // Not Fixed Col Align
    begin
      AlignCol[SELECT_IDX]        := alCenter;
      AlignCol[SNT_EMP_IDX]       := alCenter;
      AlignCol[SNT_ACC_NO_IDX]    := alCenter;
      AlignCol[SNT_ACC_NAME_IDX]  := alLeft;
      AlignCol[SNT_TYPE_IDX]      := alCenter;
      AlignCol[SNT_DEST_NAME_IDX] := alLeft;
      AlignCol[SNT_DEST_IDX]      := alLeft;
      AlignCol[SNT_RPT_IDX]       := alLeft;
      AlignCol[SNT_REQ_TIME_IDX]  := alCenter;
      AlignCol[SNT_FIN_TIME_IDX]  := alCenter;
      AlignCol[SNT_RESEND_IDX]    := alCenter;
      AlignCol[SNT_PRC_IDX]       := alCenter;
      AlignCol[SNT_PAGE_IDX]      := alCenter;
    end;

    // ColWIdth
    begin
      ColWidths[SELECT_IDX]        := 10;
      ColWidths[SNT_EMP_IDX]       := 50;
      ColWidths[SNT_ACC_NO_IDX]    := 110;
      ColWidths[SNT_ACC_NAME_IDX]  := 160;
      ColWidths[SNT_TYPE_IDX]      := 55;
      ColWidths[SNT_DEST_NAME_IDX] := 105;
      ColWidths[SNT_DEST_IDX]      := 250;
      ColWidths[SNT_RPT_IDX]       := 260;
      ColWidths[SNT_REQ_TIME_IDX]  := 66;
      ColWidths[SNT_FIN_TIME_IDX]  := 66;
      ColWidths[SNT_RESEND_IDX]    := 50;
      ColWidths[SNT_PRC_IDX]       := 70;
      ColWidths[SNT_PAGE_IDX]      := 45;
    end;
  end;
end;

function TForm_SCFH8801_SND.fn_MakeEmpCombo: Boolean;
begin
  Result := False;
  DRUserDblCodeCombo_Emp.ClearItems;
  DRUserDblCodeCombo_Emp.AddItem(gwTotal, gwTotal);

  with ADOQuery_temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' SELECT USER_ID, USER_NAME '
          + ' FROM SUUSER_TBL           '
          + ' WHERE DEPT_CODE = ''' + gvDeptCode + ''' ');

    try
      gf_ADOQueryOpen(ADOQuery_temp);
    except
      On E:Exception do
      begin
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_temp[SUUSER_TBL]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_temp[SUUSER_TBL]'); //Database 오류
        Exit;
      end;
    end;

    First;
    while not Eof do
    begin
      DRUserDblCodeCombo_Emp.AddItem(Trim(FieldByName('USER_ID').AsString),
                                     Trim(FieldByName('USER_NAME').AsString));

      Next;
    end;
  end;

  DRUserDblCodeCombo_Emp.AssignCode(gwTotal);
  Result := True;
end;

function TForm_SCFH8801_SND.fn_MakeAccCombo: Boolean;
begin
  Result := False;
  DRUserDblCodeCombo_Acc.ClearItems;
  DRUserDblCodeCombo_Acc.AddItem(gwTotal, gwTotal);

  with ADOQuery_temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' SELECT ACC_NO, ACC_NAME_KOR '
          + ' FROM SZACBIF_INS          '
          + ' WHERE DEPT_CODE = ''' + gvDeptCode + ''' ');

    try
      gf_ADOQueryOpen(ADOQuery_temp);
    except
      On E:Exception do
      begin
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_temp[SZACBIF_INS]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_temp[SZACBIF_INS]'); //Database 오류
        Exit;
      end;
    end;

    First;
    while not Eof do
    begin
      DRUserDblCodeCombo_Acc.AddItem(Trim(FieldByName('ACC_NO').AsString),
                                     Trim(FieldByName('ACC_NAME_KOR').AsString));

      Next;
    end;
  end;

  DRUserDblCodeCombo_Acc.AssignCode(gwTotal);
  Result := True;
end;

function TForm_SCFH8801_SND.fn_QueryToSndList: Boolean;
  procedure  BuildAttFileList(pFileInfo : string; pSndITem : pTSnd; pFileITem :pTFIAttFile);
  var
    sFileName : string;
    iCnt : integer;
  begin
    if Trim(pFileInfo) = '' then
    begin
      pSndITem.AttFileList := nil;
      pSndITem.SendFlag := true;
      pSndITem.ErrMsg  := gf_ReturnMsg(gvErrorNo) + ' (' + gvExtMsg + ')';
      exit;
    end;

    iCnt := 1;
    While True do
    begin
      sFileName := fnGetTokenStr(pFileInfo, gcSPLIT_MAILADDR, iCnt);  //Directory 포함해서
      if Trim(sFileName) = '' then Break;
      New(pFileITem);
      pSndITem.AttFileList.Add(pFileITem);

      pFileITem.FileName := sFileName;
      pFileITem.AttSeqNo := iCnt;

      Inc(iCnt);
    end; // end of While
  end;

  procedure BuildSndFaxItem(pADOQuery:TADOQuery; pSndItem: pTSnd);
  begin
    with pADOQuery do
    begin
      pSndItem.SendType       := Trim(FieldByName('SEND_TYPE').AsString);
      pSndItem.JobSeq         := FieldByName('JOB_SEQ').AsFloat;
      pSndItem.JobDate        := Trim(FieldByName('JOB_DATE').AsString);
      pSndItem.EmpNo          := Trim(FieldByName('EMP_NO').AsString);
      pSndItem.EmpName        := Trim(FieldByName('USER_NAME').AsString);
      pSndItem.JobTime        := Trim(FieldByName('JOB_TIME').AsString);
      pSndItem.AccNo          := Trim(FieldByName('ACC_NO').AsString);
      pSndItem.PrdNo          := Trim(FieldByName('PRD_NO').AsString);
      pSndItem.BlcNo          := Trim(FieldByName('BLC_NO').AsString);
      pSndItem.AccName        := Trim(FieldByName('ACC_NAME_KOR').AsString);
      pSndItem.MediaName      := Trim(FieldByName('F_RCV_NAME_KOR').AsString);
      pSndItem.MediaNo        := Trim(FieldByName('MEDIA_NO').AsString);
      pSndItem.ReportCode     := Trim(FieldByName('REPORT_CODE').AsString);
      pSndItem.ReportID       := Trim(FieldByName('REPORT_ID').AsString);
      pSndItem.ReportName     := Trim(FieldByName('VIEW_FILENAME').AsString);

      if Trim(pSndItem.ReportName) = '' then
        pSndItem.ReportName := Trim(FieldByName('REPORT_CODE').asString);

      pSndItem.PSStringList   := TStringList.Create;
      pSndItem.PSStringAll    := False;
      pSndItem.ExceptFlag     := False;
      pSndItem.SendFlag       := False;
      pSndItem.CancFlag       := False;
      pSndItem.ExportFlag     := False;
      pSndItem.CurTotSeqNo    := -1;
      pSndItem.ErrMsg         := '';
      pSndItem.Selected       := False;
      pSndItem.GridRowIdx     := -1;
      pSndItem.ReportIdx      := -1;
      pSndItem.RIdxSeqNo      := -1;
    end;
  end;

  procedure BuildSndMailItem(pADOQuery:TADOQuery; pSndItem: pTSnd);
  var
    sFileInfo: String;
    FileITem: pTFIAttFile;
    TDateTemp : TDateTime;
  begin
    with pADOQuery do
    begin
      sFileInfo := fn_CreateMailFile(pSndItem, False, ParentForm.JobDate);

      //Attch File Insert
      BuildAttFileList(sFileInfo, pSndITem, FileITem);
      
      pSndItem.SendType       := Trim(FieldByName('SEND_TYPE').AsString);
      pSndItem.JobSeq         := FieldByName('JOB_SEQ').AsFloat;
      pSndItem.JobDate        := Trim(FieldByName('JOB_DATE').AsString);
      pSndItem.EmpNo          := Trim(FieldByName('EMP_NO').AsString);
      pSndItem.EmpName        := Trim(FieldByName('USER_NAME').AsString);
      pSndItem.JobTime        := Trim(FieldByName('JOB_TIME').AsString);
      pSndItem.AccNo          := Trim(FieldByName('ACC_NO').AsString);
      pSndItem.PrdNo          := Trim(FieldByName('PRD_NO').AsString);
      pSndItem.BlcNo          := Trim(FieldByName('BLC_NO').AsString);
      pSndItem.AccName        := Trim(FieldByName('ACC_NAME_KOR').AsString);

      pSndItem.MailName       := TStringList.Create;
      gf_DelimiterStringList(',', Trim(FieldByName('E_RCV_NAME_KOR').AsString), pSndItem.MailName);
      pSndItem.FullMailName   := Trim(FieldByName('E_RCV_NAME_KOR').AsString);

      pSndItem.MailAddr       := TStringList.Create;
      gf_DelimiterStringList(',', Trim(FieldByName('MAIL_ADDR').AsString), pSndItem.MailName);
      pSndItem.FullMailAddr   := Trim(FieldByName('MAIL_ADDR').AsString);

      pSndItem.ReportCode     := Trim(FieldByName('REPORT_CODE').AsString);
      pSndItem.ReportID       := Trim(FieldByName('REPORT_ID').AsString);
      pSndItem.ReportName     := Trim(FieldByName('VIEW_FILENAME').AsString);

      if Trim(pSndItem.ReportName) = '' then
        pSndItem.ReportName := Trim(FieldByName('REPORT_CODE').asString);

      pSndItem.PSStringList   := TStringList.Create;
      pSndItem.PSStringAll    := False;
      pSndItem.AttFileList    := TList.Create;
      pSndItem.ExceptFlag     := False;
      pSndItem.SendFlag       := False;
//      pSndItem.CancFlag       := False;
      pSndItem.ExportFlag     := False;
//      pSndItem.CurTotSeqNo    := -1;
      pSndItem.ErrMsg         := '';
      pSndItem.Selected       := False;
      pSndItem.GridRowIdx     := -1;
//      pSndItem.ReportIdx      := -1;
//      pSndItem.RIdxSeqNo      := -1;

      pSndItem.SubjectData    := Trim(FieldByName('SUBJECT_DATA').asString);
      pSndItem.MailBodyData   := Trim(FieldByName('MAIL_BODY_DATA').asString);


      TDateTemp :=  gf_StrToDate(gf_formatdate(ParentForm.JobDate));
      pSndItem.SubjectData  := Gf_FormatDateDollarDollar(pSndItem.SubjectData , TDateTemp);
      pSndItem.MailBodyData := Gf_FormatDateDollarDollar(pSndItem.MailBodyData, TDateTemp);
    end;
  end;

  procedure BuildSndNoneItem(pADOQuery:TADOQuery; pSndItem: pTSnd);
  begin
    with pADOQuery do
    begin
      pSndItem.SendType       := Trim(FieldByName('SEND_TYPE').AsString);
      pSndItem.JobSeq         := FieldByName('JOB_SEQ').AsFloat;
      pSndItem.JobDate        := Trim(FieldByName('JOB_DATE').AsString);
      pSndItem.EmpNo          := Trim(FieldByName('EMP_NO').AsString);
      pSndItem.EmpName        := Trim(FieldByName('USER_NAME').AsString);
      pSndItem.JobTime        := Trim(FieldByName('JOB_TIME').AsString);
      pSndItem.AccNo          := Trim(FieldByName('ACC_NO').AsString);
      pSndItem.PrdNo          := Trim(FieldByName('PRD_NO').AsString);
      pSndItem.BlcNo          := Trim(FieldByName('BLC_NO').AsString);
      pSndItem.AccName        := Trim(FieldByName('ACC_NAME_KOR').AsString);
      pSndItem.MediaName      := WORD_NONE; // '미등록'
      pSndItem.MediaNo        := WORD_NONE; // '미등록'
      pSndItem.ReportCode     := Trim(FieldByName('REPORT_CODE').AsString);
      pSndItem.ReportID       := Trim(FieldByName('REPORT_ID').AsString);
      pSndItem.ReportName     := Trim(FieldByName('VIEW_FILENAME').AsString);

      if Trim(pSndItem.ReportName) = '' then
        pSndItem.ReportName := Trim(FieldByName('REPORT_CODE').asString);

//      pSndItem.PSStringList   := TStringList.Create;
      pSndItem.PSStringAll    := False;
      pSndItem.ExceptFlag     := False;
      pSndItem.SendFlag       := False;
      pSndItem.CancFlag       := False;
      pSndItem.ExportFlag     := False;
      pSndItem.CurTotSeqNo    := -1;
      pSndItem.ErrMsg         := WORD_NONE; // '미등록'
      pSndItem.Selected       := False;
      pSndItem.GridRowIdx     := -1;
      pSndItem.ReportIdx      := -1;
      pSndItem.RIdxSeqNo      := -1;

      // 미등록 대상이라 전송일자, 전송시간, 완료시간 없음 
      pSndItem.SendDate       := WORD_NONE; // '미등록'
      pSndItem.StartTime      := WORD_NONE; // '미등록'
      pSndItem.EndTime        := WORD_NONE; // '미등록'
    end;
  end;

  //-------------------
  // 갱신시 서버전송 OK 여부 찍기 - FAX
  //-------------------
  procedure UpdateSndFaxList_OK(pSndQuery: TADOQuery);
  var
     SndItem : pTSnd;
     dJobSeq: Double;
     i,iCurTotSeqNo : integer;
     sJobDate, sStartTime, sEndTime, sMediaNo: string;
  begin

    if SndList.Count <= 0 then Exit;

    with pSndQuery do
    begin
      while not Eof do
      begin

        dJobSeq      := FieldByName('JOB_SEQ').AsFloat;
        sJobDate     := Trim(FieldByName('JOB_DATE').AsString);
        sStartTime   := Trim(FieldByName('STRT_TIME').AsString);
        sEndTime     := Trim(FieldByName('SENT_TIME').AsString);
        sMediaNo     := Trim(FieldByName('MEDIA_NO').AsString);
        iCurTotSeqNo := FieldByName('CUR_TOT_SEQ_NO').asInteger;

        for i := 0 to  SndList.Count -1 do
        begin
          SndItem := SndList.Items[i];
          if SndItem.SendType = SND_TYPE_FAX then
          begin
            if ((SndITem.JobDate = sJobDate ) and
                (SndITem.JobSeq  = dJobSeq  ) and
                (SndItem.MediaNo = sMediaNo )) then
            begin
              SndItem.SendFlag    := true;
              SndItem.CurTotSeqNo := iCurTotSeqNo;
              SndItem.StartTime   := sStartTime;
              SndItem.EndTime     := sEndTime;
              break;
            end;
          end;
        end; //for

        Next;
      end;  // end of while
    end; //with
  end;

  //-------------------
  // 갱신시 MAIL 서버전송 OK 여부 찍기 - E-mail
  //-------------------
  procedure UpdateSndMailList_OK(pSndQuery: TADOQuery);
  var
    SndItem : pTSnd;
    i, iCurTotSeqNo : integer;
    dJobSeq: Double;
    sJobDate, sStartTime, sEndTime, sRcvMailAddr: String;
  begin
    dJobSeq      := -1;
    sJobDate     := '';
    sStartTime   := '';
    sEndTime     := '';
    sRcvMailAddr := '';
    iCurTotSeqNo := -1;

    if SndList.Count <= 0 then Exit;

    with pSndQuery do
    begin
      while not Eof do
      begin
        dJobSeq      := FieldByName('JOB_SEQ').AsFloat;
        sJobDate     := Trim(FieldByName('JOB_DATE').AsString);
        sStartTime   := Trim(FieldByName('STRT_TIME').AsString);
        sEndTime     := Trim(FieldByName('SENT_TIME').AsString);
        sRcvMailAddr := Trim(FieldByName('RCV_MAIL_ADDR').AsString);

        for i := 0 to  SndList.Count -1 do
        begin
          SndItem := SndList.Items[i];
          if SndItem.SendType = SND_TYPE_MAIL then
          begin
            if not Assigned(SndItem.MailAddr) then Continue; //절대로 없다

            if (SndItem.JobDate = sJobDate  ) and
               (SndItem.JobSeq  = dJobSeq ) then
            begin
              if BuildMailStrList(SndItem.MailAddr) <> sRcvMailAddr then continue;

              SndItem.SendFlag    := true;
              SndItem.CurTotSeqNo := iCurTotSeqNo;
              SndItem.StartTime   := sStartTime;
              SndItem.EndTime     := sEndTime;
              break;
            end;
          end;
        end; //for

        Next;
      end;  // end of while
    end; //with
  end;

var
  SndItem: pTSnd;

begin
  Result := False;
  ClearSndList;  // List Clear

  with ADOQuery_Snd do
  begin
    Close;
    SQL.Clear;

    if DRRadioButton_SndType_ALL.Checked then
    begin
      // FAX
      SQL.Add(' SELECT SEND_TYPE = ''' + SND_TYPE_FAX + ''', M.JOB_SEQ, M.EMP_NO, U.USER_NAME, M.JOB_TIME,  ');
      SQL.Add('        FULL_ACC_NO = (CASE WHEN M.PRD_NO = '''' THEN M.ACC_NO                               ');
      SQL.Add('                            ELSE (CASE WHEN M.BLC_NO = '''' THEN M.ACC_NO + ''-'' + M.PRD_NO ');
      SQL.Add('                                       ELSE M.ACC_NO + ''-'' + M.PRD_NO + ''-'' + M.BLC_NO   ');
      SQL.Add('                                  END)                                                       ');
      SQL.Add('                       END),                                                                 ');
      SQL.Add('        M.JOB_DATE,                                                                          ');
      SQL.Add(' 		   M.ACC_NO, M.PRD_NO, M.BLC_NO, A.ACC_NAME_KOR,                                        ');
      SQL.Add(' 	     F_RCV_NAME_KOR = F.RCV_NAME_KOR, F.MEDIA_NO,                                         ');
      SQL.Add(' 	     E_RCV_NAME_KOR = '''', MAIL_ADDR = '''',                                             ');
      SQL.Add(' 	     R.REPORT_CODE, D.REPORT_ID, R.VIEW_FILENAME,                                         ');
      SQL.Add(' 	     SUBJECT_DATA = '''', MAIL_BODY_DATA = ''''                                           ');
      SQL.Add(' FROM SZMAIN_INS M JOIN SZACBIF_INS A                                                        ');
      SQL.Add('   ON M.DEPT_CODE = A.DEPT_CODE                                                              ');
      SQL.Add('   AND M.ACC_NO   = A.ACC_NO                                                                 ');
      SQL.Add(' JOIN SZFAXDE_INS F                                                                          ');
      SQL.Add('   ON M.DEPT_CODE = F.DEPT_CODE                                                              ');
      SQL.Add('   AND M.ACC_NO   = F.ACC_NO                                                                 ');
      SQL.Add(' JOIN SZREPIF_INS R                                                                          ');
      SQL.Add('   ON M.REPORT_CODE = R.REPORT_CODE                                                          ');
      SQL.Add(' JOIN SZREPID_INS D                                                                          ');
      SQL.Add('   ON M.REPORT_CODE = D.REPORT_CODE                                                          ');
      SQL.Add(' LEFT OUTER JOIN SUUSER_TBL U                                                                ');
      SQL.Add('   ON M.DEPT_CODE = U.DEPT_CODE                                                              ');
      SQL.Add('   AND M.EMP_NO   = U.USER_ID                                                                ');
      SQL.Add(' WHERE M.DEPT_CODE = ''' + gvDeptCode + '''                                                  ');
      SQL.Add('    AND M.JOB_DATE  = ''' + ParentForm.JobDate + '''                                         ');
      SQL.Add('   AND SUBSTRING(M.JOB_TIME, 1, 4) >= ''' + Trim(DRMaskEdit_Time.Text) + '''                 ');

      if DRUserDblCodeCombo_Emp.Code <> '전체' then
      begin
        SQL.ADd(' AND M.EMP_NO = ''' + DRUserDblCodeCombo_Emp.Code + ''' ');
      end;

      if DRUserDblCodeCombo_Acc.Code <> '전체' then
      begin
        SQL.ADd(' AND M.ACC_NO = ''' + DRUserDblCodeCombo_Acc.Code + ''' ');
      end;

      SQL.Add('  UNION                                                                                      ');

      // E-mail
      SQL.Add(' SELECT SEND_TYPE = ''' + SND_TYPE_MAIL + ''', M.JOB_SEQ, M.EMP_NO, U.USER_NAME, M.JOB_TIME, ');
      SQL.Add('        FULL_ACC_NO = (CASE WHEN M.PRD_NO = '''' THEN M.ACC_NO                               ');
      SQL.Add('                            ELSE (CASE WHEN M.BLC_NO = '''' THEN M.ACC_NO + ''-'' + M.PRD_NO ');
      SQL.Add('                                       ELSE M.ACC_NO + ''-'' + M.PRD_NO + ''-'' + M.BLC_NO   ');
      SQL.Add('                                  END)                                                       ');
      SQL.Add('                       END),                                                                 ');
      SQL.Add('        M.JOB_DATE,                                                                          ');
      SQL.Add(' 		   M.ACC_NO, M.PRD_NO, M.BLC_NO, A.ACC_NAME_KOR,                                        ');
      SQL.Add(' 		   F_RCV_NAME_KOR = '''', MEDIA_NO = '''',		                                          ');
      SQL.Add(' 	     E_RCV_NAME_KOR = E.RCV_NAME_KOR, E.MAIL_ADDR,                                        ');
      SQL.Add(' 	     R.REPORT_CODE, D.REPORT_ID, R.VIEW_FILENAME,                                         ');
      SQL.Add(' 	     R.SUBJECT_DATA, MAIL_BODY_DATA = CONVERT(VARCHAR(8000), R.MAIL_BODY_DATA)            ');
      SQL.Add(' FROM SZMAIN_INS M JOIN SZACBIF_INS A                                                        ');
      SQL.Add('   ON M.DEPT_CODE = A.DEPT_CODE                                                              ');
      SQL.Add('   AND M.ACC_NO   = A.ACC_NO                                                                 ');
      SQL.Add(' JOIN SZMELDE_INS E                                                                          ');
      SQL.Add('   ON M.DEPT_CODE = E.DEPT_CODE                                                              ');
      SQL.Add('   AND M.ACC_NO   = E.ACC_NO                                                                 ');
      SQL.Add(' JOIN SZREPIF_INS R                                                                          ');
      SQL.Add('   ON M.REPORT_CODE = R.REPORT_CODE                                                          ');
      SQL.Add(' JOIN SZREPID_INS D                                                                          ');
      SQL.Add('   ON M.REPORT_CODE = D.REPORT_CODE                                                          ');
      SQL.Add(' LEFT OUTER JOIN SUUSER_TBL U                                                                ');
      SQL.Add('   ON M.DEPT_CODE = U.DEPT_CODE                                                              ');
      SQL.Add('   AND M.EMP_NO   = U.USER_ID                                                                ');
      SQL.Add(' WHERE M.DEPT_CODE = ''' + gvDeptCode + '''                                                  ');
      SQL.Add('    AND M.JOB_DATE  = ''' + ParentForm.JobDate + '''                                         ');
      SQL.Add('   AND SUBSTRING(M.JOB_TIME, 1, 4) >= ''' + Trim(DRMaskEdit_Time.Text) + '''                 ');

      if DRUserDblCodeCombo_Emp.Code <> '전체' then
      begin
        SQL.ADd(' AND M.EMP_NO = ''' + DRUserDblCodeCombo_Emp.Code + ''' ');
      end;

      if DRUserDblCodeCombo_Acc.Code <> '전체' then
      begin
        SQL.ADd(' AND M.ACC_NO = ''' + DRUserDblCodeCombo_Acc.Code + ''' ');
      end;

      SQL.Add('  UNION                                                                                      ');

      // NONE
      SQL.Add(' SELECT SEND_TYPE = ''' + SND_TYPE_NONE + ''', M.EMP_NO, M.JOB_SEQ, U.USER_NAME, M.JOB_TIME, ');
      SQL.Add('        FULL_ACC_NO = (CASE WHEN M.PRD_NO = '''' THEN M.ACC_NO                               ');
      SQL.Add('                            ELSE (CASE WHEN M.BLC_NO = '''' THEN M.ACC_NO + ''-'' + M.PRD_NO ');
      SQL.Add('                                       ELSE M.ACC_NO + ''-'' + M.PRD_NO + ''-'' + M.BLC_NO   ');
      SQL.Add('                                  END)                                                       ');
      SQL.Add('                       END),                                                                 ');
      SQL.Add('        M.JOB_DATE,                                                                          ');
      SQL.Add(' 		   M.ACC_NO, M.PRD_NO, M.BLC_NO, A.ACC_NAME_KOR,                                        ');
      SQL.Add(' 	     F_RCV_NAME_KOR = '''', MEDIA_NO = '''',		                                          ');
      SQL.Add(' 	     E_RCV_NAME_KOR = '''', MAIL_ADDR = '''',                                             ');
      SQL.Add(' 	     R.REPORT_CODE, D.REPORT_ID, R.VIEW_FILENAME,                                         ');
      SQL.Add(' 	     SUBJECT_DATA = '''', MAIL_BODY_DATA = ''''                                           ');
      SQL.Add(' FROM SZMAIN_INS M JOIN SZACBIF_INS A                                                        ');
      SQL.Add('   ON M.DEPT_CODE = A.DEPT_CODE                                                              ');
      SQL.Add('   AND M.ACC_NO   = A.ACC_NO                                                                 ');
      SQL.Add(' JOIN SZREPIF_INS R                                                                          ');
      SQL.Add('   ON M.REPORT_CODE = R.REPORT_CODE                                                          ');
      SQL.Add(' JOIN SZREPID_INS D                                                                          ');
      SQL.Add('   ON M.REPORT_CODE = D.REPORT_CODE                                                          ');
      SQL.Add(' LEFT OUTER JOIN SUUSER_TBL U                                                                ');
      SQL.Add('   ON M.DEPT_CODE = U.DEPT_CODE                                                              ');
      SQL.Add('   AND M.EMP_NO   = U.USER_ID                                                                ');
      SQL.Add(' WHERE M.DEPT_CODE = ''' + gvDeptCode + '''                                                  ');
      SQL.Add('   AND M.JOB_DATE  = ''' + ParentForm.JobDate + '''                                          ');
      SQL.Add('   AND (NOT EXISTS (SELECT 1                                                                 ');
      SQL.Add('                    FROM SZFAXDE_INS F                                                       ');
      SQL.Add('                    WHERE M.DEPT_CODE = F.DEPT_CODE                                          ');
      SQL.Add('                      AND M.ACC_NO = F.ACC_NO)                                               ');
      SQL.Add('   AND NOT EXISTS (SELECT 1                                                                  ');
      SQL.Add('                   FROM SZMELDE_INS E                                                        ');
      SQL.Add('                   WHERE M.DEPT_CODE = E.DEPT_CODE                                           ');
      SQL.Add('                     AND M.ACC_NO = E.ACC_NO))                                               ');
      SQL.Add(' AND SUBSTRING(M.JOB_TIME, 1, 4) >= ''' + Trim(DRMaskEdit_Time.Text) + '''                   ');

      if DRUserDblCodeCombo_Emp.Code <> '전체' then
      begin
        SQL.ADd(' AND M.EMP_NO = ''' + DRUserDblCodeCombo_Emp.Code + ''' ');
      end;

      if DRUserDblCodeCombo_Acc.Code <> '전체' then
      begin
        SQL.ADd(' AND M.ACC_NO = ''' + DRUserDblCodeCombo_Acc.Code + ''' ');
      end;
    end else if DRRadioButton_SndType_FAX.Checked then
    begin
      // FAX
      SQL.Add(' SELECT SEND_TYPE = ''' + SND_TYPE_FAX + ''', M.EMP_NO, M.JOB_SEQ, U.USER_NAME, M.JOB_TIME,  ');
      SQL.Add('        FULL_ACC_NO = (CASE WHEN M.PRD_NO = '''' THEN M.ACC_NO                               ');
      SQL.Add('                            ELSE (CASE WHEN M.BLC_NO = '''' THEN M.ACC_NO + ''-'' + M.PRD_NO ');
      SQL.Add('                                       ELSE M.ACC_NO + ''-'' + M.PRD_NO + ''-'' + M.BLC_NO   ');
      SQL.Add('                                  END)                                                       ');
      SQL.Add('                       END),                                                                 ');
      SQL.Add('        M.JOB_DATE,                                                                          ');
      SQL.Add(' 		   M.ACC_NO, M.PRD_NO, M.BLC_NO, A.ACC_NAME_KOR,                                        ');
      SQL.Add(' 	     F_RCV_NAME_KOR = F.RCV_NAME_KOR, F.MEDIA_NO,                                         ');
      SQL.Add(' 	     E_RCV_NAME_KOR = '''', MAIL_ADDR = '''',                                             ');
      SQL.Add(' 	     R.REPORT_CODE, D.REPORT_ID, R.VIEW_FILENAME,                                         ');
      SQL.Add(' 	     SUBJECT_DATA = '''', MAIL_BODY_DATA = ''''                                           ');
      SQL.Add(' FROM SZMAIN_INS M JOIN SZACBIF_INS A                                                        ');
      SQL.Add('   ON M.DEPT_CODE = A.DEPT_CODE                                                              ');
      SQL.Add('   AND M.ACC_NO   = A.ACC_NO                                                                 ');
      SQL.Add(' JOIN SZFAXDE_INS F                                                                          ');
      SQL.Add('   ON M.DEPT_CODE = F.DEPT_CODE                                                              ');
      SQL.Add('   AND M.ACC_NO   = F.ACC_NO                                                                 ');
      SQL.Add(' JOIN SZREPIF_INS R                                                                          ');
      SQL.Add('   ON M.REPORT_CODE = R.REPORT_CODE                                                          ');
      SQL.Add(' JOIN SZREPID_INS D                                                                          ');
      SQL.Add('   ON M.REPORT_CODE = D.REPORT_CODE                                                          ');
      SQL.Add(' LEFT OUTER JOIN SUUSER_TBL U                                                                ');
      SQL.Add('   ON M.DEPT_CODE = U.DEPT_CODE                                                              ');
      SQL.Add('   AND M.EMP_NO   = U.USER_ID                                                                ');
      SQL.Add(' WHERE M.DEPT_CODE = ''' + gvDeptCode + '''                                                  ');
      SQL.Add('    AND M.JOB_DATE  = ''' + ParentForm.JobDate + '''                                         ');
      SQL.Add('   AND SUBSTRING(M.JOB_TIME, 1, 4) >= ''' + Trim(DRMaskEdit_Time.Text) + '''                 ');

      if DRUserDblCodeCombo_Emp.Code <> '전체' then
      begin
        SQL.ADd(' AND M.EMP_NO = ''' + DRUserDblCodeCombo_Emp.Code + ''' ');
      end;

      if DRUserDblCodeCombo_Acc.Code <> '전체' then
      begin
        SQL.ADd(' AND M.ACC_NO = ''' + DRUserDblCodeCombo_Acc.Code + ''' ');
      end;
    end else if DRRadioButton_SndType_Email.Checked then
    begin
      // E-mail
      SQL.Add(' SELECT SEND_TYPE = ''' + SND_TYPE_MAIL + ''', M.EMP_NO, M.JOB_SEQ, U.USER_NAME, M.JOB_TIME, ');
      SQL.Add('        FULL_ACC_NO = (CASE WHEN M.PRD_NO = '''' THEN M.ACC_NO                               ');
      SQL.Add('                            ELSE (CASE WHEN M.BLC_NO = '''' THEN M.ACC_NO + ''-'' + M.PRD_NO ');
      SQL.Add('                                       ELSE M.ACC_NO + ''-'' + M.PRD_NO + ''-'' + M.BLC_NO   ');
      SQL.Add('                                  END)                                                       ');
      SQL.Add('                       END),                                                                 ');
      SQL.Add('        M.JOB_DATE,                                                                          ');
      SQL.Add(' 		   M.ACC_NO, M.PRD_NO, M.BLC_NO, A.ACC_NAME_KOR,                                        ');
      SQL.Add(' 		   F_RCV_NAME_KOR = '''', MEDIA_NO = '''',		                                          ');
      SQL.Add(' 	     E_RCV_NAME_KOR = E.RCV_NAME_KOR, E.MAIL_ADDR,                                        ');
      SQL.Add(' 	     R.REPORT_CODE, D.REPORT_ID, R.VIEW_FILENAME,                                         ');
      SQL.Add(' 	     R.SUBJECT_DATA, MAIL_BODY_DATA = CONVERT(VARCHAR(8000), R.MAIL_BODY_DATA)            ');
      SQL.Add(' FROM SZMAIN_INS M JOIN SZACBIF_INS A                                                        ');
      SQL.Add('   ON M.DEPT_CODE = A.DEPT_CODE                                                              ');
      SQL.Add('   AND M.ACC_NO   = A.ACC_NO                                                                 ');
      SQL.Add(' JOIN SZMELDE_INS E                                                                          ');
      SQL.Add('   ON M.DEPT_CODE = E.DEPT_CODE                                                              ');
      SQL.Add('   AND M.ACC_NO   = E.ACC_NO                                                                 ');
      SQL.Add(' JOIN SZREPIF_INS R                                                                          ');
      SQL.Add('   ON M.REPORT_CODE = R.REPORT_CODE                                                          ');
      SQL.Add(' JOIN SZREPID_INS D                                                                          ');
      SQL.Add('   ON M.REPORT_CODE = D.REPORT_CODE                                                          ');
      SQL.Add(' LEFT OUTER JOIN SUUSER_TBL U                                                                ');
      SQL.Add('   ON M.DEPT_CODE = U.DEPT_CODE                                                              ');
      SQL.Add('   AND M.EMP_NO   = U.USER_ID                                                                ');
      SQL.Add(' WHERE M.DEPT_CODE = ''' + gvDeptCode + '''                                                  ');
      SQL.Add('    AND M.JOB_DATE  = ''' + ParentForm.JobDate + '''                                         ');
      SQL.Add('   AND SUBSTRING(M.JOB_TIME, 1, 4) >= ''' + Trim(DRMaskEdit_Time.Text) + '''                 ');

      if DRUserDblCodeCombo_Emp.Code <> '전체' then
      begin
        SQL.ADd(' AND M.EMP_NO = ''' + DRUserDblCodeCombo_Emp.Code + ''' ');
      end;

      if DRUserDblCodeCombo_Acc.Code <> '전체' then
      begin
        SQL.ADd(' AND M.ACC_NO = ''' + DRUserDblCodeCombo_Acc.Code + ''' ');
      end;
    end else if DRRadioButton_SndType_None.Checked then
    begin
      // NONE
      SQL.Add(' SELECT SEND_TYPE = ''' + SND_TYPE_NONE + ''', M.EMP_NO, M.JOB_SEQ, U.USER_NAME, M.JOB_TIME, ');
      SQL.Add('        FULL_ACC_NO = (CASE WHEN M.PRD_NO = '''' THEN M.ACC_NO                               ');
      SQL.Add('                            ELSE (CASE WHEN M.BLC_NO = '''' THEN M.ACC_NO + ''-'' + M.PRD_NO ');
      SQL.Add('                                       ELSE M.ACC_NO + ''-'' + M.PRD_NO + ''-'' + M.BLC_NO   ');
      SQL.Add('                                  END)                                                       ');
      SQL.Add('                       END),                                                                 ');
      SQL.Add('        M.JOB_DATE,                                                                          ');
      SQL.Add(' 		   M.ACC_NO, M.PRD_NO, M.BLC_NO, A.ACC_NAME_KOR,                                        ');
      SQL.Add(' 	     F_RCV_NAME_KOR = '''', MEDIA_NO = '''',		                                          ');
      SQL.Add(' 	     E_RCV_NAME_KOR = '''', MAIL_ADDR = '''',                                             ');
      SQL.Add(' 	     R.REPORT_CODE, D.REPORT_ID, R.VIEW_FILENAME,                                         ');
      SQL.Add(' 	     SUBJECT_DATA = '''', MAIL_BODY_DATA = ''''                                           ');
      SQL.Add(' FROM SZMAIN_INS M JOIN SZACBIF_INS A                                                        ');
      SQL.Add('   ON M.DEPT_CODE = A.DEPT_CODE                                                              ');
      SQL.Add('   AND M.ACC_NO   = A.ACC_NO                                                                 ');
      SQL.Add(' JOIN SZREPIF_INS R                                                                          ');
      SQL.Add('   ON M.REPORT_CODE = R.REPORT_CODE                                                          ');
      SQL.Add(' JOIN SZREPID_INS D                                                                          ');
      SQL.Add('   ON M.REPORT_CODE = D.REPORT_CODE                                                          ');
      SQL.Add(' LEFT OUTER JOIN SUUSER_TBL U                                                                ');
      SQL.Add('   ON M.DEPT_CODE = U.DEPT_CODE                                                              ');
      SQL.Add('   AND M.EMP_NO   = U.USER_ID                                                                ');
      SQL.Add(' WHERE M.DEPT_CODE = ''' + gvDeptCode + '''                                                  ');
      SQL.Add('   AND M.JOB_DATE  = ''' + ParentForm.JobDate + '''                                          ');
      SQL.Add('   AND (NOT EXISTS (SELECT 1                                                                 ');
      SQL.Add('                    FROM SZFAXDE_INS F                                                       ');
      SQL.Add('                    WHERE M.DEPT_CODE = F.DEPT_CODE                                          ');
      SQL.Add('                      AND M.ACC_NO = F.ACC_NO)                                               ');
      SQL.Add('   AND NOT EXISTS (SELECT 1                                                                  ');
      SQL.Add('                   FROM SZMELDE_INS E                                                        ');
      SQL.Add('                   WHERE M.DEPT_CODE = E.DEPT_CODE                                           ');
      SQL.Add('                     AND M.ACC_NO = E.ACC_NO))                                               ');
      SQL.Add(' AND SUBSTRING(M.JOB_TIME, 1, 4) >= ''' + Trim(DRMaskEdit_Time.Text) + '''                   ');

      if DRUserDblCodeCombo_Emp.Code <> '전체' then
      begin
        SQL.ADd(' AND M.EMP_NO = ''' + DRUserDblCodeCombo_Emp.Code + ''' ');
      end;

      if DRUserDblCodeCombo_Acc.Code <> '전체' then
      begin
        SQL.ADd(' AND M.ACC_NO = ''' + DRUserDblCodeCombo_Acc.Code + ''' ');
      end;
    end;

    SQL.Add(' ORDER BY SEND_TYPE, M.ACC_NO, M.PRD_NO, M.BLC_NO, R.REPORT_CODE  ');

    try
//SQL.SaveToFile('C:\전송대상.SQL');
      gf_ADOQueryOPen(ADOQuery_Snd);
    except
      On E: Exception do // Database 오류
      begin
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Snd[전송대상]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Snd[전송대상]'); //Database 오류
        Exit;
      end;
    end;

    while not Eof do
    begin
      New(SndItem);

      if Trim(FieldByName('SEND_TYPE').AsString) = SND_TYPE_FAX then
        BuildSndFaxItem(ADOQuery_Snd, SndItem)
      else if Trim(FieldByName('SEND_TYPE').AsString) = SND_TYPE_MAIL then
        BuildSndMailItem(ADOQuery_Snd, SndItem)
      else if Trim(FieldByName('SEND_TYPE').AsString) = SND_TYPE_NONE then
        BuildSndNoneItem(ADOQuery_Snd, SndItem)
      else
        Continue;

      SndList.Add(SndItem);

      Next;
    end;

    //@@ ==> 20041029 서버전송 Cell에 OK 여부 찍기
    if gvSendOKCheckYN = 'Y' then
    begin
      Close;
      SQL.Clear;
      SQL.Add(' SELECT SNT.JOB_DATE, SNT.JOB_SEQ, SND.STRT_TIME,       ');
      SQL.Add('        SND.SENT_TIME, SND.MEDIA_NO, SND.CUR_TOT_SEQ_NO ');
      SQL.Add(' FROM SCFAXSND_TBL SND JOIN SZFAXSNT_INS SNT            ');
      SQL.Add(' ON SND.SND_DATE = SNT.SND_DATE                         ');
      SQL.Add(' AND SND.CUR_TOT_SEQ_NO = SNT.CUR_TOT_SEQ_NO            '); 
      SQL.Add(' WHERE SND.SND_DATE   = ''' + gvCurDate + '''           ');
      SQL.Add(' AND   SND.TRADE_DATE = ''' + ParentForm.JobDate + '''  ');
      SQL.Add(' AND   SND.DEPT_CODE  = ''' + gvDeptCode + '''          ');
      
      Try
//SQL.SaveToFile('C:\FAX서버전송시간.SQL');
         gf_ADOQueryOpen(ADOQuery_Snd);
      Except
         on E : Exception do
         begin    // Database 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Snd[Fax/Tlx 서버전송결과]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Snd[Fax/Tlx 서버전송결과]'); //Database 오류
            Exit;
         end;
      End;
      
      UpdateSndFaxList_OK(ADOQuery_Snd); // FAX - 서버 전송 시간

      Close;
      SQL.Clear;
      SQL.Add(' SELECT SND.SND_DATE, SND.STRT_TIME, SND.SENT_TIME,     ');
      SQL.Add('        SNT.JOB_SEQ, SND.RCV_MAIL_ADDR                  ');
      SQL.Add(' FROM SCMELSND_TBL SND JOIN SZMELSNT_INS SNT            ');
      SQL.Add(' ON SND.SND_DATE = SNT.SND_DATE                         ');
      SQL.Add(' AND SND.CUR_TOT_SEQ_NO = SNT.CUR_TOT_SEQ_NO            ');
      SQL.Add(' WHERE SND.SND_DATE   = ''' + gvCurDate + '''           ');
      SQL.Add(' AND   SND.TRADE_DATE = ''' + ParentForm.JobDate + '''  ');
      SQL.Add(' AND   SND.DEPT_CODE  = ''' + gvDeptCode + '''          ');
      
      Try
//SQL.SaveToFile('C:\E-MAIL서버전송시간.SQL');      
         gf_ADOQueryOpen(ADOQuery_Snd);
      Except
         on E : Exception do
         begin    // Database 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Snd[Mail 서버전송결과]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Snd[Mail 서버전송결과]'); //Database 오류
            Exit;
         end;
      End;

      UpdateSndMailList_OK(ADOQuery_Snd); // E-mail - 서버 전송 시간
    end;//gvSendOKCheckYN
  end;

  // Sorting 들어가야 됨
  Result := True;
end;

function TForm_SCFH8801_SND.fn_QueryToSntList: Boolean;
//var
//  SntItem: pTSnt;
begin
  Result := False;
  ClearSnTList;

  { with ADODataSet_Snt do
  begin
    Close;
   CommandText :=
            '(Select fa.ACC_NO, fa.SUB_ACC_NO, ACC_NAME = ac.ACC_NAME_KOR, '
          + '    ac.CLIENT, '
          + '    fs.FAX_TLX_GBN, fs.RCV_COMP_KOR, fs.NAT_CODE, fs.MEDIA_NO, '
          + '    fi.REPORT_TYPE, fi.DIRECTION, fi.TXT_UNIT_INFO, fs.CUR_TOT_SEQ_NO, fs.SEND_TIME, '
          + '    fs.SENT_TIME, fs.DIFF_TIME, fi.TOTAL_PAGES, fs.SEND_PAGE, fs.BUSY_RESND_CNT, '
          + '    fs.RSP_FLAG, fs.ERR_CODE, fs.EXT_MSG, ac.MGR_NAME, ac.SUB_DEPT_NAME, ac.PGMAC_YN, ac.ACC_ATTR, '
          + '    ac.FUND_CODE, ac.FUND_NAME_KOR, ' //@@
          + '    ac.IDENTIFICATION, fs.OPR_ID, fs.OPR_TIME '
          + ' From SCFAXSND_TBL fs, SCFAXIMG_TBL fi, SCFAXACT_TBL fa, '
          + '      SEACBIF_TBL ac '
          + ' Where fs.SND_DATE      = ''' + gvCurDate    + ''' '   // 당일자 전송
          + '   and fs.FROM_PARTY_ID = ''' + gvMyPartyID  + ''' '
          + '   and fs.DEPT_CODE = ''' + gvDeptCode  + ''' '
          + '   and fi.SEC_TYPE      = ''' + gcSEC_EQUITY + ''' '
          + '   and fs.SND_DATE   = fi.SND_DATE    '
          + '   and fs.TRADE_DATE = fi.TRADE_DATE  '
          + '   and fs.DEPT_CODE  = fi.DEPT_CODE   '
          + '   and fs.IDX_SEQ_NO = fi.IDX_SEQ_NO  '
          + '   and fs.SND_DATE   = fa.SND_DATE    '
          + '   and fs.DEPT_CODE  = fa.DEPT_CODE   '
          + '   and fs.IDX_SEQ_NO = fa.IDX_SEQ_NO  '
          + '   and fs.DEPT_CODE  = ac.DEPT_CODE   '
          + '   and fa.ACC_NO     = ac.ACC_NO      '
          + '   and fa.SUB_ACC_NO = ''''           '
          + ' Order By fa.ACC_NO, fa.SUB_ACC_NO, fs.RCV_COMP_KOR, fs.FAX_TLX_GBN, '
          + '          fs.NAT_CODE, fs.MEDIA_NO, fs.CUR_TOT_SEQ_NO ';
    Try
      open;
    Except
      on E : Exception do
      begin    // Database 오류
         gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADODataSet_Snt[AFax/Tlx]: ' + E.Message, 0);
         gf_ShowMessage(MessageBar, mtError, 9001, 'ADODataSet_Snt[AFax/Tlx]'); //Database 오류
         Exit;
      end;
    End;


  end;  }
end;

procedure TForm_SCFH8801_SND.DisplaySndList(DefSelectFlag: boolean);
var
  i: Integer;
  iRowCnt, iRow: Integer;
  SndItem: pTSnd;
begin
  DRLabel_Snd.Caption := '>> 전송대상';
  with DRStrGrid_Snd do
  begin
    iRow := 0;

    for i:= 0 to SndList.Count - 1 do
    begin
      SndItem := SndList.Items[i];
      SndItem.GridRowIdx := -1; // 초기화

      if DefSelectFlag then
        SndItem.Selected := False;

      Inc(iRow);

      SndItem.GridRowIdx := iRow;
      if DefSelectFlag then
        SndItem.Selected := bSndSelected;

      // 미전송 대상만 그리드에 보이게
      if (bNotSend) and (SndItem.SendFlag) then Continue;

      DisplaySndItem(SndItem);
    end;

    if iRow <= 0 then
    begin
      RowCount := 2;
      Rows[1].Clear;
      
      HintCell[iSndEmpIdx, 1]        := '';
      HintCell[iSndAccNoIdx, 1]      := '';
      HintCell[SND_RPT_IDX, 1]       := '';
      HintCell[SND_REQ_TIME_IDX, 1]  := '';
      HintCell[SND_FIN_TIME_IDX, 1]  := '';

      Exit;
    end else
    begin
      iRowCnt  := iRow;
      RowCount := iRowCnt + 1;
    end;
  end;

  DRLabel_Snd.Caption := DRLabel_Snd.Caption + ' (' + IntToStr(iRowCnt) + ')';
end;

procedure TForm_SCFH8801_SND.DisplaySntList(DefSelectFlag: boolean);
begin
  with DRStrGrid_Snt do
  begin

  end;
end;

procedure TForm_SCFH8801_SND.DRPanel_SndTitleDblClick(Sender: TObject);
begin
  inherited;
  bSndOnlyViewFlag := not bSndOnlyViewFlag;
  bSntOnlyViewFlag := False;

  if bSndOnlyViewFlag then // 전송대상 그리드만 보기
    ChangeViewType(gcVIEW_SEND, DRPanel_TotPanel, DRPanel_Snd, DRPanel_Snt, DRSplitter_Tot)
  else // 전체 보기
    ChangeViewType(gcVIEW_ALL, DRPanel_TotPanel, DRPanel_Snd, DRPanel_Snt, DRSplitter_Tot)
end;

procedure TForm_SCFH8801_SND.ChangeViewType(pViewType: Integer;
  pTotPanel, pSndPanel, pSntPanel: TPanel;
  pSplitter: TSplitter);
begin
  pSplitter.Align := alNone;
  pSplitter.Visible := False;
  pSndPanel.Align := alNone;
  pSntPanel.Align := alNone;

  if pViewType = gcVIEW_ALL then // 전체 보기
  begin
    pSndPanel.Height := pTotPanel.Height div 2;
    pSndPanel.Align := alTop;
    pSplitter.Align := alTop;
    pSplitter.Visible := True;
    pSntPanel.Align := alClient;
  end
  else if pViewType = gcVIEW_SEND then // 자료 전송
  begin
    pSndPanel.Align := alClient;
    pSplitter.Align := alTop;
    pSndPanel.BringToFront;
  end
  else if pViewType = gcVIEW_SENT then // 송신 확인
  begin
    pSplitter.Align := alTop;
    pSntPanel.Align := alClient;
    pSntPanel.BringToFront;
  end;
end;

procedure TForm_SCFH8801_SND.DRPanel_SntTitleDblClick(Sender: TObject);
begin
  inherited;
  bSntOnlyViewFlag := not bSntOnlyViewFlag;
  bSndOnlyViewFlag := False;
  
  if bSndOnlyViewFlag then // 전송대상 그리드만 보기
    ChangeViewType(gcVIEW_SEND, DRPanel_TotPanel, DRPanel_Snd, DRPanel_Snt, DRSplitter_Tot)
  else // 전체 보기
    ChangeViewType(gcVIEW_ALL, DRPanel_TotPanel, DRPanel_Snd, DRPanel_Snt, DRSplitter_Tot)
end;

procedure TForm_SCFH8801_SND.ClearSndList;
var
   i, k : Integer;
   SndItem : pTSnd;
   FileItem: pTAttFile;
begin
   if not Assigned(SndList) then Exit;
   for I := 0 to SndList.Count -1 do
   begin
      SndItem := SndList.Items[I];
      if Assigned(SndItem.MailName) then SndItem.MailName.Free;
      if Assigned(SndItem.MailAddr) then SndItem.MailAddr.Free;
      if Assigned(SndItem.PSStringList) then SndItem.PSStringList.Free;

      if Assigned(SndItem.AttFileList) then
      begin
        for K := 0 to  SndItem.AttFileList.Count -1 do
        begin
          FileItem := SndItem.AttFileList.Items[K];
          Dispose(FileItem);
        end;
        SndItem.AttFileList.Free;
      end;
      Dispose(SndItem);
   end;
   SndList.Clear;
end;

procedure TForm_SCFH8801_SND.ClearSnTList;
var
  i: Integer;
begin

end;

function TForm_SCFH8801_SND.fn_MakeColOrdCombo: Boolean;
begin
  Result := False;

  DRComboBox_SndColOrder.Items.Clear;

  DRComboBox_SndColOrder.Items.Add('사번 / 생성시간 / 계좌번호');
  DRComboBox_SndColOrder.Items.Add('생성시간 / 계좌번호');
  DRComboBox_SndColOrder.Items.Add('계좌번호 / 생성시간');

  DRComboBox_SndColOrder.ItemIndex := 0;
  iSndColOpt := DRComboBox_SndColOrder.ItemIndex;
  Result := True;
end;

function TForm_SCFH8801_SND.fn_CreateMailFile(SndItem: pTSnd; CallFlag: boolean; JobDate: string): string;
var
  sPathName, sDirName, sFileName, sTmpStr: string;
  iCnt: integer;
  SR: TSearchRec;
  SearchRec: boolean;
  StartTime: Double;
begin

  StartTime := GetTickCount;
  gf_Log('송수신 갱신 - MAIL_ID : ' + SndItem.ReportID + ' MailGroup : ' + SndITem.FullAccNo + ' Start');

  try
    sPathNAme := '';
    sFileName := '';
    sDirName := '';
    iCnt := 1;
    Result := '';


    // Tmp Dir 만들기
    if not DirectoryExists(gvDirTemp) then if not CreateDir(gvDirTemp) then Exit;

    // 사용자 디렉토리 생성
    sDirName := gvDirUserData + SndItem.FullAccNo + '\'; // 사용자 디렉토리


    // 파일 이름만 Return
    if fn_CreateEMailFile(SndItem.ReportID, gvDirTemp, gvDeptCode, JobDate,
      SndITem.FullAccNo, sFileName, False) then
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
//            SndItem.EditFlag := True;
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
        if fn_CreateEMailFile(SndItem.ReportID, gvDirTemp, gvDeptCode, JobDate,
          SndITem.FullAccNo, sFileName, True) then
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

    gf_Log('송수신 갱신 - MAIL_ID : ' + SndItem.ReportID + ' MailGroup : ' + SndITem.FullAccNo + ' End');
  end;


end;

//------------------------------------------------------------------------------
//  [L.J.S] 2018.02.05 손봐야 되는 함수임
//  EMail File 생성 Main Function
//------------------------------------------------------------------------------
function TForm_SCFH8801_SND.fn_CreateEMailFile(pEMailFormId, pDirName, pDeptCode, pTradeDate: string;
  pGrpName: string; var FileName: string; CreateFlag: boolean): boolean;

type
  // [L.J.S] 2018.02.05 수정해야됨 !!!! EMailFile 생성 Function Type - PDF:  
  TCrePMailFunc = function(MainADOC: TADOConnection;
    EmailID, DirName, DeptCode, TradeDate, OprUsrNo: string; pGrpName: string;
    CreateFlag: boolean; FileName: PChar;
    var ErrorNo: Integer; ExtMsg: PChar): boolean; StdCall;
var
  DllHandle: THandle;
  sDllName, sFuncName: string;
  iErrorNo: Integer;
  ExtMsgArr: array[0..1024] of Char;
  FileNameArr: array of Char;
  CrePMailFunc: TCrePMailFunc;
  dt: DWORD;
begin
  FileName := ''; // Clear
  Result := True;

  SetLength(FileNameArr, 100000);

  FillChar(ExtMsgArr, SizeOf(ExtMsgArr), #0);

  // !!!!!!!!!! 수정해야 됨 !!!!!!!!!!!
  sDllName := '크리스탈레포트 만드는 dll 파일명';
  sFuncName := '안에 호출할 함수명';

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
          CreateFlag, PChar(FileNameArr), iErrorNo, ExtMsgArr) then
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
end;

//------------------------------------------------------------------------------
// 해당 Row 데이타
//------------------------------------------------------------------------------
function TForm_SCFH8801_SND.fn_GetSndListIdx(pGridRowIdx: Integer): Integer;
var
   I : Integer;
   SndItem : pTSnd;
begin
   Result := -1;
   if pGridRowIdx <= 0 then Exit;

   for I := 0 to SndList.Count -1 do
   begin
      SndItem := SndList.Items[I];
      if SndItem.GridRowIdx = pGridRowIdx then
      begin
         Result := I;
         Break;
      end;
   end;  // end of for
end;

procedure TForm_SCFH8801_SND.DisplaySndItem(pSndItem: pTSnd);
var
  iRow, iPreIdx, i: Integer;
  PreItem: pTSnd;
  sPreEmpNo, sPreJobTime, sPreFullAccNo, sPreAccNo, sPreSndType, sPreDest: String;
  sDest, sDestName: String;
begin
  with DRStrGrid_Snd do
  begin
    iRow := pSndItem.GridRowIdx;
    if iRow <= 0 then Exit; // List의 해당 Item은 Update되었으나 Display는 되지 않는 경우

    Rows[iRow].Clear;
    HintCell[iSndEmpIdx, iRow]        := '';
    HintCell[iSndAccNoIdx, iRow]      := '';
    HintCell[SND_RPT_IDX, iRow]       := '';
    HintCell[SND_REQ_TIME_IDX, iRow]  := '';
    HintCell[SND_FIN_TIME_IDX, iRow]  := '';

    if pSndItem.Selected then
      RowFont[iRow].Color := gcSelectItemColor
    else
      RowFont[iRow].Color := clBlack;

    SelectedFontColorRow[iRow] := RowFont[iRow].Color;

    if pSndItem.SendType = SND_TYPE_FAX then
    begin
      sDest := pSndItem.MediaNo;
      sDestname := pSndItem.MediaName;
    end else if pSndItem.SendType = SND_TYPE_MAIL then
    begin
      sDest := pSndItem.FullMailAddr;
      sDestName := pSndItem.FullMailName;
    end else if pSndItem.SendType = SND_TYPE_NONE then
    begin
      sDest := pSndItem.MediaNo;
      sDestname := pSndItem.MediaName;
    end;

    sPreEmpNo      := '';
    sPreJobTime    := '';
    sPreFullAccNo  := '';
    sPreAccNo      := '';
    sPreSndType    := '';
    sPreDest       := '';

    iPreIdx := fn_GetSndListIdx(iRow-1);

    if iPreIdx > -1 then
    begin
      PreItem            := SndList.Items[iPreIdx];
      sPreEmpNo          := PreItem.EmpNo;
      sPreJobTime        := PreItem.JobTime;
      sPreFullAccNo      := PreItem.FullAccNo;
      sPreACcNo          := PreItem.AccNo;
      sPreSndType        := PreItem.SendType;

      if sPresndType = SND_TYPE_FAX then sPreDest := PreItem.MediaNo
      else if sPresndType = SND_TYPE_FAX then sPreDest := PreItem.FullMailAddr
      else if sPresndType = SND_TYPE_NONE then sPreDest := PreItem.MediaNo;
    end;

    case iSndColOpt of
      // 사번 - 생성시간 - 계좌번호 - 계좌명
      0 : begin
        if (sPreEmpNo <> pSndItem.EmpNo) then
        begin
          Cells[iSndEmpIdx, iRow]        := pSndItem.EmpNo;
          Cells[iSndJobTimeIdx, iRow]    := pSndItem.JobTime;
          Cells[iSndAccNoIdx, iRow]      := pSndItem.FullAccNo;
          Cells[iSndAccNameIdx, iRow]    := pSndItem.AccName;
          Cells[SND_TYPE_IDX, iRow]      := pSndItem.SendType;
          Cells[SND_DEST_NAME_IDX, iRow] := sDestName;
          Cells[SND_DEST_IDX, iRow]      := sDest;
        end else
        begin
          if (sPreJobTime <> pSndItem.JobTime) then
          begin
            Cells[iSndJobTimeIdx, iRow]    := pSndItem.JobTime;
            Cells[iSndAccNoIdx, iRow]      := pSndItem.FullAccNo;
            Cells[iSndAccNameIdx, iRow]    := pSndItem.AccName;
            Cells[SND_TYPE_IDX, iRow]      := pSndItem.SendType;
            Cells[SND_DEST_NAME_IDX, iRow] := sDestName;
            Cells[SND_DEST_IDX, iRow]      := sDest;
          end else begin
            if (sPreFullAccNo <> pSndItem.FullAccNo) then
            begin
              Cells[iSndAccNoIdx, iRow]      := pSndItem.FullAccNo;
              Cells[iSndAccNameIdx, iRow]    := pSndItem.AccName;
              Cells[SND_TYPE_IDX, iRow]      := pSndItem.SendType;
              Cells[SND_DEST_NAME_IDX, iRow] := sDestName;
              Cells[SND_DEST_IDX, iRow]      := sDest;
            end else
            begin
              if (sPreDest <> sDest) then
              begin
                Cells[SND_TYPE_IDX, iRow]      := pSndItem.SendType;
                Cells[SND_DEST_NAME_IDX, iRow] := sDestName;
                Cells[SND_DEST_IDX, iRow]      := sDest;
              end;
            end;
          end;
        end;
      end;

      // 생성시간 - 계좌번호 - 계좌명
      1 : begin

      end;

      // 계좌번호 - 계좌명 - 생성시간
      2 : begin

      end;
    end;

    HintCell[iSndEmpIdx, iRow]        := pSndItem.EmpNo + ' ' + pSndItem.EmpName;
    HintCell[SND_DEST_NAME_IDX, iRow] := sDestname;
    HintCell[SND_DEST_IDX, iRow]      := sDest;
    HintCell[SND_RPT_IDX, iRow]       := pSndItem.ReportCode + ' ' + pSndItem.ReportName;

    // 전송 선택 여부
    if pSndItem.Selected then
      Cells[SELECT_IDX, iRow] := gcSEND_MARK;

    // 보고서 서식
    Cells[SND_RPT_IDX, iRow] := pSndItem.ReportName;


    // 요청시간, 완료시간
    if pSndItem.SendFlag then
    begin
      if pSndItem.CancFlag then   // 전송 후 취소
      begin
        Cells[SND_REQ_TIME_IDX, iRow] := gwRSPCancel;
        CellFont[SND_REQ_TIME_IDX, iRow].Color := gcRSPCancColor;

        Cells[SND_FIN_TIME_IDX, iRow] := gwRSPCancel;
        CellFont[SND_FIN_TIME_IDX, iRow].Color := gcRSPCancColor;
      end
      else if pSndItem.CurTotSeqNo > 0 then   // 정상 전송
      begin
        Cells[SND_REQ_TIME_IDX, iRow] := gf_FormatTime(pSndItem.StartTime);
        CellFont[SND_REQ_TIME_IDX, iRow].Color := RowFont[iRow].Color;

        Cells[SND_FIN_TIME_IDX, iRow] := gf_FormatTime(pSndItem.EndTime);
        CellFont[SND_FIN_TIME_IDX, iRow].Color := RowFont[iRow].Color;
      end
      else   // Error
      begin
        Cells[SND_REQ_TIME_IDX, iRow] := gwRSPError;
        HintCell[SND_REQ_TIME_IDX, iRow]       := pSndItem.ErrMsg;
        CellFont[SND_REQ_TIME_IDX, iRow].Color := gcErrorColor;;

        Cells[SND_FIN_TIME_IDX, iRow] := gwRSPError;
        HintCell[SND_FIN_TIME_IDX, iRow]       := pSndItem.ErrMsg;
        CellFont[SND_FIN_TIME_IDX, iRow].Color := gcErrorColor;;
      end;
      SelectedFontColorCell[SND_REQ_TIME_IDX, iRow] := CellFont[SND_REQ_TIME_IDX, iRow].Color;
      SelectedFontColorCell[SND_FIN_TIME_IDX, iRow] := CellFont[SND_FIN_TIME_IDX, iRow].Color;
    end;

    // 전송제외
    if pSndItem.ExceptFlag then
      Cells[SND_EXP_IDX, iRow] := 'Y';
  end;
end;



procedure TForm_SCFH8801_SND.DisplaySntItem(pSntItem: pTSnt);
begin
  with DRStrGrid_Snt do
  begin

  end;
end;

procedure TForm_SCFH8801_SND.SetColOpt;
begin
  iSndColOpt := DRComboBox_SndColOrder.ItemIndex;

  case iSndColOpt of
    // 사번 - 생성시간 - 계좌번호 - 계좌명
    0: begin
      iSndEmpIdx     := SND_NO1_IDX;
      iSndJobTimeIdx := SND_NO2_IDX;
      iSndAccNoIdx   := SND_NO3_IDX;
      iSndAccNameIdx := SND_NO4_IDX;
    end;

    // 생성시간 - 계좌번호 - 계좌명
    1: begin
      iSndEmpIdx     := SND_NO1_IDX;
      iSndJobTimeIdx := SND_NO2_IDX;
      iSndAccNoIdx   := SND_NO3_IDX;
      iSndAccNameIdx := SND_NO4_IDX;

    end;

    // 계좌번호 - 계좌명 - 생성시간
    2: begin
      iSndEmpIdx     := SND_NO1_IDX;
      iSndAccNoIdx   := SND_NO2_IDX;
      iSndAccNameIdx := SND_NO3_IDX;
      iSndJobTimeIdx := SND_NO4_IDX;
    end;
  end;
end;

procedure TForm_SCFH8801_SND.DRComboBox_SndColOrderChange(Sender: TObject);
begin
  inherited;
  SetColOpt;
  DefSetSndStrGrid;
end;
end.

