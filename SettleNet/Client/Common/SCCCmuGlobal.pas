(*
----------------------------------------------------------------------------

	PROGRAM NAME : DATAROAD Comunication Header����
		       (SCCCmuGlobal.pas)
	PROGRAM TYPE : Header File
	����  �ۼ��� : 1998/8/29

 * LMS Add 2004.01.15 gcSVC_CTRL_TIMEOUT        
----------------------------------------------------------------------------
*)

unit SCCCmuGlobal;

interface
uses
  Windows, Messages,Classes,SysUtils,MSMQ_TLB,DRSHMDefine;

// ��� ����
const
        //-------------------------------------------------------
        // Version ����
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

        // Client Main���� Send�ϴ� Message
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
        gcTIMEOUT_SET     =  20;      // 20��
        gcSTX             = Char($02);
        gcETX             = Char($03);

        //������� DATA TYPE
        gcSTYPE_LOGN = 'LOG';    // Login
        gcSTYPE_DATA = 'DAT';    // �ڷ�����
        gcSTYPE_CHEG = 'CHG';    // ü������
        gcSTYPE_POLL = 'POL';    // Polling Data
        gcSTYPE_ACK  = 'ACK';    // ACK data
        gcSTYPE_NAK  = 'NAK';    // NAK data
        gcSTYPE_CLO  = 'CLO';    // Close Data
        gcSTYPE_MON  = 'MON';    // Monitoring Data
        gcSTYPE_MSG  = 'MSG';    // Message Broadcast Data
        gcSTYPE_INT  = 'INT';    // �ʱ����ӽ��� �ڷ�
        gcSTYPE_MSQ  = 'MSQ';    // MSMQ�ڷ� ����
        gcSTYPE_FAX  = 'FAX';    // FAX �ڷ� ����
        gcSTYPE_MEL  = 'MEL';    // EMail �ڷ� ����
        gcSTYPE_FXC  = 'FXC';    // FAX ���� Cancel        
        gcSTYPE_TRN  = 'TRN';    // Client���� TRANSACTION SEND
        gcSTYPE_EXE  = 'EXE';    // Client���� Client Execute Module Send

        //TUXEDO ������� DATA TYPE
        gcSTYPE_COM    = 'COM';   // ��� Tr : ��������
        gcSTYPE_UPLOAD = 'UPL';   // ��� Tr : �������ε�
        gcSTYPE_IMP_TR = 'IMT';   // ��� Tr : ����Ʈ���� ���ε� (�ֽĸŸ��ڷ�)
        gcSTYPE_IMP_AC = 'IMA';   // ��� Tr : ����Ʈ���� ���ε� (�����ڷ�)
        gcSTYPE_IMP_FAC = 'IFA'; // ��� Tr : ����Ʈ���� ���ε� (���������ڷ�)
        gcSTYPE_IMP_FDP = 'IFD'; // ��� Tr : ����Ʈ���� ���ε� (������Ź�ڷ�)
        gcSTYPE_IMP_FTR = 'IFT'; // ��� Tr : ����Ʈ���� ���ε� (�����Ÿ�)
        gcSTYPE_IMP_FOP = 'IFO'; // ��� Tr : ����Ʈ���� ���ε� (�̰���)
        gcSTYPE_IMP_FCO = 'IFC'; // ��� Tr : ����Ʈ���� ���ε� (����ڷ�)


        //�ʱ����ӽ� Sub Trx-Code
        gcDATA_DELIMITER     =  Char($04);  //Server�ڷ��� Data Delimiter(EOT:^D)
        gcDATA_SUB_DELIMITER =  Char($05);  //Server�ڷ��� Sub Data Delimiter(ENQ:^E)
        gcSINT_STA   = 'STA';
        gcSINT_VER   = 'VER';                

        //��Ż� Error Define
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
        //Client�ʱ� ���ӽ� UserSvr�� ���۵� �ڷ�
        ptTLOGDATA = ^TLOGDATA;
        TLOGDATA = record
          cEngFlag : Char;
          csPassWd : Array [0..63] of char;
          csUsrSvrVersion: Array [0..4] of char;
          csClientExeName: Array [0..19] of Char;
          csClientVersion: Array [0..29] of char;
        end;
        {
        //�������� ���� Call �ʿ�� HostGateWay�� ���۹� �����ڷ�
        ptTCALCOMDATA = ^TCALCOMDATA;
        TCALCOMDATA = record
          cEngFlag    : Char;
          csTradeDate : Array [0..7]  of char; // �Ÿ���
          csStatus    : Array [0..9]  of char; // ����
          csAccNo     : Array [0..9]  of char; // ���¹�ȣ
          csTranType  : char;                  // �ŷ�����
          csStlDate   : Array [0..7]  of char; // ������
          csIssueCode : Array [0..19] of char; // �����ڵ�
          cnAmt       : Array [0..14] of char; // �����ݾ�
          cnComm      : Array [0..12] of char; // ������
          cnTTax      : Array [0..12] of char; // �ŷ���
          cnATax      : Array [0..12] of char; // ��Ư��
          cnGTax      : Array [0..12] of char; // �絵��
          cnCommRate  : Array [0..16] of char; // ��������
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
        //��� Header
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
                    TrGbn      : array [0..2]  of char;  // DATA����                */
                    TrCode     : array [0..5]  of char;  // TRX CODE                */
                    TermNo     : array [0..14] of char; // �ܸ���ȣ(IP-ADDR)        */
                    LoginID    : array [0..7]  of char;  // ����ڹ�ȣ              */
                    WinHandle  : array [0..11] of char;  // Window Handle           */
                    Fil        : array [0..6]  of char;  // filler                  */
        end;

        ptSvrCliHead_R = ^SvrCliHead_R;
        SvrCliHead_R = record
                    CliHead    : CliSvrHead_R;
                    MsgNo      : array [0..3] of char;  // Message Number           */
                    UsrMsgGbn  : char;                  // User Message����         */
                                                        // 0 : ����   1 : ����      */
                    UsrMsg     : array [0..59] of char; // User Message           */
                    ConGbn     : char;                  // �����ڷ� ����            */
                                                        // 0 : ����   1 : ����      */
        end;

        ptTMSMQResult = ^TMSMQResult;
        TMSMQResult = record
          sCurDate   : Array [0..7] of Char;
          sDeptCode  : Array [0..1] of Char;
          sSecCode   : Char;
          sPartyID   : Array [0..5] of Char;
          sCurTotSeqNo: Array [0..6] of Char; // ������ ��
          sSentCnt   : Array [0..6] of Char;  // ȸ��
          sSendTotSeq: Array [0..6] of Char;  // ȸ���� �� ���� �Ǽ�
          sSeqNo     : Array [0..6] of Char;  // ȸ���� �ش� ��ȣ
          sTranCode  : Array [0..4] of Char;  // TranCode
          sRspCode   : Char;                  // '1' : Sent    '2' : ACK
                                              // '3' : CONFIRM '4' : Receive
          sRecvTime  : Array [0..7] of Char;  // Ȯ�� �ð�
          sSendTime  : Array [0..7] of Char;  // ���� �ð�
          sTotCnfCnt : Array [0..6] of Char;  // �ش� ȸ���� �� Ȯ�� �Ǽ�
          sTotAckCnt : Array [0..6] of Char;  // �ش� ȸ���� �� Ack  �Ǽ�
          sTotErrCnt : Array [0..6] of Char;  // �ش� ȸ���� �� Err  �Ǽ�
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
// Send / Receive����
//--------------------------------------------------------
type
   // Message Queue�� Header(_Label)
   pTQueueHeaderInfo = ^TQueueHeaderInfo;
   TQueueHeaderInfo = record
     SendDate    : Array [0..7] of Char;  //����������
     FromPartyID : Array [0..5] of Char;
     TotSeqNo    : Array [0..6] of Char;  // �۽� Count��ȣ -> ������ �Ѽ۽ŰǼ�
     ToPartyID   : Array [0..5] of Char;
     TrxCode     : Array [0..4] of char;
     MQVersion   : Array [0..3] of char;
     SentCount   : Array [0..4] of char;  // ���� Ƚ��
     SendSeqNo   : Array [0..6] of char;  // �ش� Packet�� Count
     SendTotSeqNo: Array [0..6] of char;  // ������ �� Packet
     SecDate     : Array [0..7] of char;  // ��ǰ����
     SentTime    : Array [0..7] of char;  // ���� �ð�
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
   // Monitoring Memory����
   //--------------------------------------------------------
   TRcvSndInfo = record
     MtdCode    : string;
     iTreeIndex : Integer;
     MtdName    : string;
     RcvSndCnt  : Integer; // Recv -> ���ŵ���Count
                           // Send -> �����ߵ� ���ڷ�
     SentCnt    : Integer; // Send -> �����ڷ� Count
     RcvTotCnt  : Integer; // ���ŵž��� �� Count : Recv������ ���
     RcvCurCnt  : Integer; // ���ŵ� Count
   end;
   pTRcvSndInfo = ^TRcvSndInfo;

   TPartyInfo = record
     PartyID  : string;
     iTreeIndex : Integer;
     DeptName   : string;
     RcvSndList : TList;   // TRcvSndInfo List
     RcvSndCnt  : Integer;
     SentCnt    : Integer; // SendInfo���� �����ڷ� Count
   end;
   pTPartyInfo = ^TPartyInfo;

   TMonitorInfo = record
     RoleCode   : String;
     iTreeIndex : Integer;
     RoleName  : String;
     PartyInfo : TList;    // TPartyInfo List
     RcvSndCnt : Integer;
     SentCnt   : Integer; // SendInfo���� �����ڷ� Count
   end;
   pTMonitorInfo = ^TMonitorInfo;
//--------------------------------------------------------

//=============================================================================
//  Tuxedo ���� �ۼ�����Ŷ  (�ϳ��������)
//=============================================================================

type
    //�������� ���� Call �ʿ�� ���۵� �ڷ� [Client <-> HostGw]
    ptTCliSvrComData = ^TCliSvrComData;
    TCliSvrComData = record
      csTradeDate : Array [0..7]  of char; // �Ÿ���
      csAccNo     : Array [0..8]  of char; // ���¹�ȣ
      csCmtType   : Array [0..2]  of char; // ���»�ǰ����       110:��Ź
      csMrktDeal  : char; // ����ŷ�����       STKDR:�ŷ���, KSQDR: �ڽ���, K-OTC:��������(��3����), XXXXX:��Ÿ
      csIssueCode : Array [0..31] of char; // �����ڵ�           A+�����ȣ(6�ڸ�)
      csTradeType : char;                  // �ŵ�������         1:�ŵ� 2:�ż�
      csCommOrd   : Array [0..1]  of char; // ��Ÿ�ü����
      csPgmCall   : Array [0..1]  of char; // ���α׷�ȣ������   00:�Ϲ� 01:���α׷��Ÿ�
      cnAmt       : Array [0..12] of char; // �����ݾ�
      //OutData
      csErrcode   : Array [0..5]  of char; // Tuxedo ErrCode
      csErrmsg    : Array [0..129]of char; // Tuxedo Errmessage
      cnComm      : Array [0..18] of char; // ������
      cnTTax      : Array [0..18] of char; // �ŷ���
      cnATax      : Array [0..18] of char; // ��Ư��
      cnCommRate  : Array [0..16] of char; // ��������           ex)1.0049813230
      cnCommAdd   : Array [0..18] of char; // �����ᰡ��ݾ�
    end;

    //���ε����� ������û�� ���۵� �ڷ� [Client <-> HostGw]
    ptTCliSvrUpData = ^TCliSvrUpData;
    TCliSvrUpData = record
      csDeptCode  : Array [0..1]  of char; // �μ��ڵ�
      csOprUser   : Array [0..7]  of char; // ����ھ��̵�
      csTradeDate : Array [0..7]  of char; // �Ÿ���
      csFileName  : Array [0..50] of char; // ���ϸ�
      //OutData
      csErrcode   : Array [0..5]  of char; // Tuxedo ErrCode
      csErrmsg    : Array [0..129]of char; // Tuxedo Errmessage
      csCreYN     : char;                  // ���ϻ�������
    end;

    //����Ʈ���� ������û�� ���۵� �ڷ� [Client <-> HostGw]
    ptTCliSvrImpData = ^TCliSvrImpData;
    TCliSvrImpData = record
      csTradeDate : Array [0..7]  of char; // �Ÿ���
      csAccNo     : Array [0..11]  of char; // ���¹�ȣ
      csFileName  : Array [0..199] of char; // ���ϸ�
      csDeptCode  : Array [0..1]  of char; // �μ��ڵ�
      //OutData
      csErrcode   : Array [0..5]  of char; // Tuxedo ErrCode
      csErrmsg    : Array [0..129]of char; // Tuxedo Errmessage
      csCreYN     : char;                  // ���ϻ�������
    end;

var
  gvptMSMQResult : ptTMSMQResult;
  gvptFAXResult  : ptTFAXResult;
  gvptEMailResult: ptTEMailResult;
  
  gvSvrErrorNo   : Integer;        // Error No
  gvSvrExtMsg    : string;         // Extended Message

  gvMCIFtpFileList: TStringList; // ���� ���� ����Ʈ
  gvMCIFileCnt: Integer; // ����Ʈ ���� ���� ���� üũ

implementation

end.
