(*
----------------------------------------------------------------------------

	PROGRAM NAME : DATAROAD Comunication Header정의
		       (SCCCmuGlobal.pas)
	PROGRAM TYPE : Header File
	최종  작성일 : 1998/8/29

 * LMS Add 2004.01.15 gcSVC_CTRL_TIMEOUT        
----------------------------------------------------------------------------
*)

unit SCCCmuGlobal;

interface
uses
  Windows, Messages,Classes,SysUtils,MSMQ_TLB,DRSHMDefine;

// 상수 선언
const
        //-------------------------------------------------------
        // Version 정보
        //-------------------------------------------------------
        gcUSERSVR_CLIENT_VERSION = ' 1.1';

        //-------------------------------------------------------
        // Message
        //-------------------------------------------------------
        WM_USER_TCPIP_CLIENT_LOGSND     = WM_USER + 1;
        WM_USER_TCPIP_USRSVR_LOGRCV     = WM_USER + 2;
        WM_USER_TCPIP_USRSVR_SVRLOG     = WM_USER + 3;
        WM_USER_MSMQT_USRSVR_SEND       = WM_USER + 4;
        WM_USER_MSMQT_USRSVR_RECV       = WM_USER + 5;
        WM_USER_TCPIP_DRSVR_LOGRCV      = WM_USER + 6;
        WM_USER_FAXST_USRSVR_SEND       = WM_USER + 7;

        // Client Main으로 Send하는 Message
        gcTCPIP_CLIENT_LOGSND_WPARAM_DISCONN         = 1;
        gcTCPIP_CLIENT_LOGSND_WPARAM_LOGIN_SUCCESS   = 2;
        gcTCPIP_CLIENT_LOGSND_WPARAM_LOGIN_FAILD     = 3;
        gcTCPIP_CLIENT_LOGSND_WPARAM_LOGIN_VERSIONUP = 4;        

        //-------------------------------------------------------
        // SERVER <-> CLIENT Send/Recv Define
        //-------------------------------------------------------
        gcMAX_COMM_BUFF_SIZE = 10000;  // Send/Recv Buffer Max Size
        gcCOMPRESS_GUBUN   = '1';      // Send/Recv Compress Gubun
        gcNOCOMPRESS_GUBUN = '0';
        gcTIMEOUT_SET     =  20;      // 20초
        gcSTX             = Char($02);
        gcETX             = Char($03);

        //통신전송 DATA TYPE
        gcSTYPE_LOGN = 'LOG';    // Login
        gcSTYPE_DATA = 'DAT';    // 자료전송
        gcSTYPE_CHEG = 'CHG';    // 체결전송
        gcSTYPE_POLL = 'POL';    // Polling Data
        gcSTYPE_ACK  = 'ACK';    // ACK data
        gcSTYPE_NAK  = 'NAK';    // NAK data
        gcSTYPE_CLO  = 'CLO';    // Close Data
        gcSTYPE_MON  = 'MON';    // Monitoring Data
        gcSTYPE_MSG  = 'MSG';    // Message Broadcast Data
        gcSTYPE_INT  = 'INT';    // 초기접속시의 자료
        gcSTYPE_MSQ  = 'MSQ';    // MSMQ자료 전송
        gcSTYPE_FAX  = 'FAX';    // FAX 자료 전송
        gcSTYPE_MEL  = 'MEL';    // EMail 자료 전송
        gcSTYPE_FXC  = 'FXC';    // FAX 전송 Cancel        
        gcSTYPE_TRN  = 'TRN';    // Client에서 TRANSACTION SEND
        gcSTYPE_EXE  = 'EXE';    // Client에서 Client Execute Module Send

        //TUXEDO 통신전송 DATA TYPE
        gcSTYPE_COM    = 'COM';   // 통신 Tr : 수수료계산
        gcSTYPE_UPLOAD = 'UPL';   // 통신 Tr : 마감업로드
        gcSTYPE_IMP_TR = 'IMT';   // 통신 Tr : 임포트파일 업로드 (주식매매자료)
        gcSTYPE_IMP_AC = 'IMA';   // 통신 Tr : 임포트파일 업로드 (계좌자료)
        gcSTYPE_IMP_FAC = 'IFA'; // 통신 Tr : 임포트파일 업로드 (선물계좌자료)
        gcSTYPE_IMP_FDP = 'IFD'; // 통신 Tr : 임포트파일 업로드 (선물예탁자료)
        gcSTYPE_IMP_FTR = 'IFT'; // 통신 Tr : 임포트파일 업로드 (선물매매)
        gcSTYPE_IMP_FOP = 'IFO'; // 통신 Tr : 임포트파일 업로드 (미결제)
        gcSTYPE_IMP_FCO = 'IFC'; // 통신 Tr : 임포트파일 업로드 (대용자료)


        //초기접속시 Sub Trx-Code
        gcDATA_DELIMITER     =  Char($04);  //Server자료의 Data Delimiter(EOT:^D)
        gcDATA_SUB_DELIMITER =  Char($05);  //Server자료의 Sub Data Delimiter(ENQ:^E)
        gcSINT_STA   = 'STA';
        gcSINT_VER   = 'VER';                

        //통신상 Error Define
        gcSYSTEM_ERROR       = -4000;
        gcABNORMAL_DATA      = -4030;
        gcCOMM_TERMINATE     = -4032;       // connect terminate
        gcERROR_TIME_OUT     = -4033;       // recv time out
        gcERROR_DATA_CONTEXT = -4034;       // data context error

        //-----------------------------------------------------------------
        // InterNal Queue Information
        //-----------------------------------------------------------------
        gcClientQueueSize  = 102400;

        // Send Method
        gcSND_MTD_DATA    = '1';
        gcSND_MTD_FAX     = '2';
        gcSND_MTD_TELEX   = '3';
        gcSND_MTD_EMAIL   = '4';
        gcSND_MTD_IMG_IDX = '5';
        gcSND_MTD_FAX_IDX = '6';

        //-----------------------------------------------------------------
        // Service Handleing Constants
        //-----------------------------------------------------------------
        gcSVC_CTRL_TIMEOUT = 300000;     // milliseconds -> 300seconds

type
        //Client초기 접속시 UserSvr로 전송될 자료
        ptTLOGDATA = ^TLOGDATA;
        TLOGDATA = record
          cEngFlag : Char;
          csPassWd : Array [0..63] of char;
          csUsrSvrVersion: Array [0..4] of char;
          csClientExeName: Array [0..19] of Char;
          csClientVersion: Array [0..29] of char;
        end;
        {
        //수수료계산 원장 Call 필요시 HostGateWay로 전송및 수신자료
        ptTCALCOMDATA = ^TCALCOMDATA;
        TCALCOMDATA = record
          cEngFlag    : Char;
          csTradeDate : Array [0..7]  of char; // 매매일
          csStatus    : Array [0..9]  of char; // 상태
          csAccNo     : Array [0..9]  of char; // 계좌번호
          csTranType  : char;                  // 거래구분
          csStlDate   : Array [0..7]  of char; // 결재일
          csIssueCode : Array [0..19] of char; // 종목코드
          cnAmt       : Array [0..14] of char; // 약정금액
          cnComm      : Array [0..12] of char; // 수수료
          cnTTax      : Array [0..12] of char; // 거래세
          cnATax      : Array [0..12] of char; // 농특세
          cnGTax      : Array [0..12] of char; // 양도세
          cnCommRate  : Array [0..16] of char; // 수수료율
        end;
        }
//------------------------------------------------------------------------------
// TRANSACTION DEFINE START
//------------------------------------------------------------------------------
const
        gcTRAN_T10001 = 'T10001';  // Client User Update Transaction
type

        ptTRAN_T10001 = ^TTRAN_T10001;
        TTRAN_T10001   = record
          UserId     : Array [0..7] of char;
          UserName   : Array [0..59] of char;
          DeptCode   : Array [0..1] of char;
          OprMtd     : Char;   // 'I' : Insert, 'D' : Delete, 'U' : Update
        end;
//--------------------- TRANSACTION DEFINE END ---------------------------------

type
        //통신 Header
        ptNetHead_R = ^NetHead_R;
        NetHead_R = record
                    stx : char;
                    SendLength : array [0..3] of char;
                    PacketNo   : array [0..1] of char;
                    CompGbn    : char;
                    UnCompLength:array [0..3] of char;
        end;

        ptCliSvrHead_R = ^CliSvrHead_R;
        CliSvrHead_R = record
                    TrGbn      : array [0..2]  of char;  // DATA구분                */
                    TrCode     : array [0..5]  of char;  // TRX CODE                */
                    TermNo     : array [0..14] of char; // 단말번호(IP-ADDR)        */
                    LoginID    : array [0..7]  of char;  // 사용자번호              */
                    WinHandle  : array [0..11] of char;  // Window Handle           */
                    Fil        : array [0..6]  of char;  // filler                  */
        end;

        ptSvrCliHead_R = ^SvrCliHead_R;
        SvrCliHead_R = record
                    CliHead    : CliSvrHead_R;
                    MsgNo      : array [0..3] of char;  // Message Number           */
                    UsrMsgGbn  : char;                  // User Message여부         */
                                                        // 0 : 없음   1 : 있음      */
                    UsrMsg     : array [0..59] of char; // User Message           */
                    ConGbn     : char;                  // 연속자료 여부            */
                                                        // 0 : 없음   1 : 있음      */
        end;

        ptTMSMQResult = ^TMSMQResult;
        TMSMQResult = record
          sCurDate   : Array [0..7] of Char;
          sDeptCode  : Array [0..1] of Char;
          sSecCode   : Char;
          sPartyID   : Array [0..5] of Char;
          sCurTotSeqNo: Array [0..6] of Char; // 당일의 총
          sSentCnt   : Array [0..6] of Char;  // 회차
          sSendTotSeq: Array [0..6] of Char;  // 회차의 총 전송 건수
          sSeqNo     : Array [0..6] of Char;  // 회차의 해당 번호
          sTranCode  : Array [0..4] of Char;  // TranCode
          sRspCode   : Char;                  // '1' : Sent    '2' : ACK
                                              // '3' : CONFIRM '4' : Receive
          sRecvTime  : Array [0..7] of Char;  // 확인 시간
          sSendTime  : Array [0..7] of Char;  // 전송 시간
          sTotCnfCnt : Array [0..6] of Char;  // 해당 회차의 총 확인 건수
          sTotAckCnt : Array [0..6] of Char;  // 해당 회차의 총 Ack  건수
          sTotErrCnt : Array [0..6] of Char;  // 해당 회차의 총 Err  건수
          sErrCode   : Array [0..3] of Char;
          sErrMsg    : Array [0..127] of Char;
          sExtMsg    : Array [0..127] of Char;
          sOprID     : Array [0..7] of Char;
        end;

        ptTFAXResult = ^TFAXResult;
        TFAXResult = record
          sCurDate   : Array [0..7] of Char;
          sDeptCode  : Array [0..1] of Char;
          sSeqNo     : Array [0..6] of Char;
          sSecCode   : Char;
          sMediaNo   : Array [0..64] of Char;
          sRspCode   : Char; // '1' : Sending '2' : Busy  '9' : End
          sBusyCnt   : Array [0..3] of Char;
          sCurrPage  : Array [0..3] of Char;
          sErrCode   : Array [0..3] of Char;
          sErrMsg    : Array [0..127] of Char;
          sExtMsg    : Array [0..127] of Char;
          sSendTime  : Array [0..7] of Char;
          sRecvTime  : Array [0..7] of Char;
          sDiffTime  : Array [0..3] of Char;
          sReportID  : Array [0..6] of Char;
          sOprID     : Array [0..7] of Char;
          sOprTime   : Array [0..7] of Char;
        end;

        ptTEMailResult = ^TEMailResult;
        TEMailResult = record
          sCurDate     : Array [0..7] of Char;
          sDeptCode    : Array [0..1] of Char;
          sSeqNo       : Array [0..6] of Char;
          sRspCode     : Char; // '1' : Sending '2' : Busy  '9' : End
          sErrCode     : Array [0..3] of Char;
          sErrMsg      : Array [0..127] of Char;
          sExtMsg      : Array [0..127] of Char;
          sSendTime    : Array [0..7] of Char;
          sSentTime    : Array [0..7] of Char;
          sDiffTime    : Array [0..3] of Char;
          sMailFormGrp : Array [0..1] of Char;
          sOprID       : Array [0..7] of Char;
          sOprTime     : Array [0..7] of Char;
        end;

//--------------------------------------------------------
// Send / Receive관련
//--------------------------------------------------------
type
   // Message Queue의 Header(_Label)
   pTQueueHeaderInfo = ^TQueueHeaderInfo;
   TQueueHeaderInfo = record
     SendDate    : Array [0..7] of Char;  //전송한일자
     FromPartyID : Array [0..5] of Char;
     TotSeqNo    : Array [0..6] of Char;  // 송신 Count번호 -> 당일의 총송신건수
     ToPartyID   : Array [0..5] of Char;
     TrxCode     : Array [0..4] of char;
     MQVersion   : Array [0..3] of char;
     SentCount   : Array [0..4] of char;  // 전송 횟수
     SendSeqNo   : Array [0..6] of char;  // 해당 Packet의 Count
     SendTotSeqNo: Array [0..6] of char;  // 전송할 총 Packet
     SecDate     : Array [0..7] of char;  // 상품일자
     SentTime    : Array [0..7] of char;  // 전송 시간
     InfoHeadCnt : Array [0..1] of char;
     Filler      : Array [0..22]of char;
   end;

   pTQueueBodyInfo = ^TQueueBodyInfo;
   TQueueBodyInfo = record
     sCommonData  : Array [0..99]   of char;
     sInfoData    : Array [0..239]  of char;
     sMainData    : Array [0..6999] of char;
   end;

   pTQueueRspBodyInfo = ^TQueueRspBodyInfo;
   TQueueRspBodyInfo = record
     sConfTime    : Array [0..7]   of char;
     sErrCode     : Array [0..3]   of char;
     sExtMsg      : Array [0..127] of char;
   end;

   //--------------------------------------------------------
   // Monitoring Memory관련
   //--------------------------------------------------------
   TRcvSndInfo = record
     MtdCode    : string;
     iTreeIndex : Integer;
     MtdName    : string;
     RcvSndCnt  : Integer; // Recv -> 수신된총Count
                           // Send -> 보내야될 총자료
     SentCnt    : Integer; // Send -> 보낸자료 Count
     RcvTotCnt  : Integer; // 수신돼야할 총 Count : Recv에서만 사용
     RcvCurCnt  : Integer; // 수신된 Count
   end;
   pTRcvSndInfo = ^TRcvSndInfo;

   TPartyInfo = record
     PartyID  : string;
     iTreeIndex : Integer;
     DeptName   : string;
     RcvSndList : TList;   // TRcvSndInfo List
     RcvSndCnt  : Integer;
     SentCnt    : Integer; // SendInfo에서 보낸자료 Count
   end;
   pTPartyInfo = ^TPartyInfo;

   TMonitorInfo = record
     RoleCode   : String;
     iTreeIndex : Integer;
     RoleName  : String;
     PartyInfo : TList;    // TPartyInfo List
     RcvSndCnt : Integer;
     SentCnt   : Integer; // SendInfo에서 보낸자료 Count
   end;
   pTMonitorInfo = ^TMonitorInfo;
//--------------------------------------------------------

//=============================================================================
//  Tuxedo 관련 송수신패킷  (하나대투사용)
//=============================================================================

type
    //수수료계산 원장 Call 필요시 전송될 자료 [Client <-> HostGw]
    ptTCliSvrComData = ^TCliSvrComData;
    TCliSvrComData = record
      csTradeDate : Array [0..7]  of char; // 매매일
      csAccNo     : Array [0..8]  of char; // 계좌번호
      csCmtType   : Array [0..2]  of char; // 계좌상품구분       110:위탁
      csMrktDeal  : char; // 시장거래구분       STKDR:거래소, KSQDR: 코스닥, K-OTC:프리보드(제3시장), XXXXX:기타
      csIssueCode : Array [0..31] of char; // 종목코드           A+단축번호(6자리)
      csTradeType : char;                  // 매도수구분         1:매도 2:매수
      csCommOrd   : Array [0..1]  of char; // 통신매체구분
      csPgmCall   : Array [0..1]  of char; // 프로그램호가구분   00:일반 01:프로그램매매
      cnAmt       : Array [0..12] of char; // 약정금액
      //OutData
      csErrcode   : Array [0..5]  of char; // Tuxedo ErrCode
      csErrmsg    : Array [0..129]of char; // Tuxedo Errmessage
      cnComm      : Array [0..18] of char; // 수수료
      cnTTax      : Array [0..18] of char; // 거래세
      cnATax      : Array [0..18] of char; // 농특세
      cnCommRate  : Array [0..16] of char; // 수수료율           ex)1.0049813230
      cnCommAdd   : Array [0..18] of char; // 수수료가산금액
    end;

    //업로드파일 생성요청시 전송될 자료 [Client <-> HostGw]
    ptTCliSvrUpData = ^TCliSvrUpData;
    TCliSvrUpData = record
      csDeptCode  : Array [0..1]  of char; // 부서코드
      csOprUser   : Array [0..7]  of char; // 사용자아이디
      csTradeDate : Array [0..7]  of char; // 매매일
      csFileName  : Array [0..50] of char; // 파일명
      //OutData
      csErrcode   : Array [0..5]  of char; // Tuxedo ErrCode
      csErrmsg    : Array [0..129]of char; // Tuxedo Errmessage
      csCreYN     : char;                  // 파일생성여부
    end;

    //임포트파일 생성요청시 전송될 자료 [Client <-> HostGw]
    ptTCliSvrImpData = ^TCliSvrImpData;
    TCliSvrImpData = record
      csTradeDate : Array [0..7]  of char; // 매매일
      csAccNo     : Array [0..11]  of char; // 계좌번호
      csFileName  : Array [0..199] of char; // 파일명
      csDeptCode  : Array [0..1]  of char; // 부서코드
      //OutData
      csErrcode   : Array [0..5]  of char; // Tuxedo ErrCode
      csErrmsg    : Array [0..129]of char; // Tuxedo Errmessage
      csCreYN     : char;                  // 파일생성여부
    end;

var
  gvptMSMQResult : ptTMSMQResult;
  gvptFAXResult  : ptTFAXResult;
  gvptEMailResult: ptTEMailResult;
  
  gvSvrErrorNo   : Integer;        // Error No
  gvSvrExtMsg    : string;         // Extended Message

  gvMCIFtpFileList: TStringList; // 생성 파일 리스트
  gvMCIFileCnt: Integer; // 임포트 파일 생성 갯수 체크

implementation

end.
