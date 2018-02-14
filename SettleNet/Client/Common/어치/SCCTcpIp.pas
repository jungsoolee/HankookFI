//==========================================================================
//           Client TCP/IP Send/Recv Moudule                                |
//                                                                          |
//                              Designed  By Nam Seoung Woo                 |
//                                             2000.12.06                   |
//                                                                          |
//==========================================================================
// CITI_TEST : Citi증권 Test를 위해 Client의 POLL전송은 Commant 처리
unit SCCTcpIp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,DB,
  ScktComp,ExtCtrls, StdCtrls, Buttons,Winsock,SCCCmuLib,SCCCmuGlobal,
  DRSHMQueue,SCCGlobalType,ADODb, DRSpecial;

//--------------------------------------------------------------------------------------
// DataRoad Main Process
//--------------------------------------------------------------------------------------
function  fnServerSendData(iSlen:integer;cpSbuff:PChar):Integer;
function  fnMQDataSend(pSndFormat : pMSMQSendFormat; var iTotSeqNo : Integer) : Boolean;
function  fnFAXDataSend(pFaxSndFormat : pFAXTLXSendFormat;
                        tReportList  : TList; var StartTime : String) : Boolean;
function  fnFAXDataSend_TFFI(pFaxSndFormat : pFAXTLXSendFormat;
                        tReportList  : TList; var StartTime : String) : Boolean;
function  fnFAXDataReSend(iTotSeqNo : Integer) : Boolean; OverLoad;
function  fnFAXDataReSend(iTotSeqNo : Integer; sOprTime:String) : Boolean; OverLoad;
function  fnFAXDataCancel(iTotSeqNo , Tag : Integer; MessageBar: TDRMessageBar) : Boolean;
function  fnEMailDataSend(pEMailFormat : pEMailSendFormat;
                          tEMailAttList: TList; var StartTime : String) : Boolean;
function  fnEMailDataSend_TFFI(pEMailFormat : pTSndMailData;
                               tEMailAttList: TList; var StartTime : String) : Boolean;
function  fnEMailDataCancel(iTotSeqNo : Integer) : Boolean;


//초기접속시 사용자Login관련
function  fnTcpIpInit:Integer;
function  fnThreadCreate(TSockID_Local : TSocket) :integer;
procedure fnTcpIpClose;

type
//*=======================================================================*/
//*  자료전송,수신 Thread
//*=======================================================================*/
  TTcp_ServicePort = class(TThread)
    FMySocket : TSocket;
    FTimeOut  : Integer;
    FException: Exception;
    FClientQueue   : TDRSHMQueue;
    FNormalCreFlag : Boolean;
    FClientVersionUP : Boolean;
    FTotalRead,FTotalFileSize : Integer;
  private
    { Private declarations }
  protected
    procedure DoTerminate; override;
    procedure Execute; override;  // 메인 프로시저
    function  InitLogin : Integer;
    function  fnLoginSendData(TSockID_Local:TSocket):Integer;
    function  fnInitLoginRecv(TSockID_Local:TSocket):Integer;
    procedure ClientQueueInsert(RLen : Integer; Rbuff : PChar);
    function fnClientVersionUpGrade(TSockID_Local:TSocket;lanRawBuff : PChar) : Integer;
    procedure DisplayVersionUpgradeBar;
  public
    constructor Create(TSockID_Local : TSocket); // 클래스 생성처리및 속성처리
    destructor  destroy; override;
  end;
//*=======================================================================*/

implementation

uses
  SCCLib,SCCLogin,SCCDataModule;

var
  // Thread Class
  TcpServicePort    : TTcp_ServicePort;
  ErrMessage        : String;

//*=======================================================================*/
// Client Service Tcp 자료송수신Procedure
//*=======================================================================*/
procedure TTcp_ServicePort.Execute;
var
   TSockID : TSocket;
   Tfd     : TFDSet;
   timeout : TTimeVal;
   iRc     : Integer;
   lanRawBuff,lanPbuff:array[0..gcMAX_COMM_BUFF_SIZE] of char;
   iRawLen,iDecodeSize:LongInt;
   iComRc   : LongInt;
   iPacketNo: LongInt;
   faxResult : ptTFAXResult;
begin

  FClientVersionUp := False;
  if InitLogin < 0 then
  begin
    gf_Log('TCPIP_LOGSND>> InitLogin Error');
    Exit;
  end;

  if FClientVersionUP then
  begin
    gf_Log('TCPIP_LOGSND>> Client Version Upgrade and Then Exit');  
    Exit;
  end;  

  // InterNal Queue Create
  if not fnQueueOpen(FClientQueue,Trim(gvOprUsrNo)+'Client',gcClientQueueSize,True)then
  begin
    gf_Log('TCPIP_LOGSND>> Queue Create Error');
    Exit;
  end;

  TSockID := FMySocket;
repeat

try
  while True do
  begin
       // TTCP.terminate에서 terminated=TRUE로 만듬
       if terminated = TRUE then
       begin
         exit;
       end;

       // Select readfds Status
       FD_ZERO(Tfd);
       FD_SET(TSockID,Tfd);

       // TimeOut 20초
       timeout.tv_sec := FTimeOut;
       timeout.tv_usec := 0;

       // SELECT
       iRc :=  Select(1,@Tfd,Nil,Nil,@timeout);

       // Select Error Check
       if iRc = 0 then // Time Out
       begin
         // fnTcpDataSend에대한 Error는 위의 Select절에서 한다
         // Poll Data는 ACK를 기다리지 않느다.
(*---CITI_TEST------------------------------------------
         iRawLen := 3;
         CharCharCpy(lanRawBuff,gcSTYPE_POLL,3);
         fnTcpDataSend(TSockID,1,iRawLen,lanRawBuff);
------------------------------------------------------*)
         continue;
       end else
       if iRc < 0 then     // Other error
       begin
         case WSAGetLastError() of
              WSAEINTR,WSAEINPROGRESS : continue;
         else
              Exit;
         end;
       end;

       // 자료수신
       iComRc := fnTcpDataRecv(TSockID,lanRawBuff,iDecodeSize,iPacketNO);

       // 자료수신정상 Check
       case iComRc of
            gcCOMM_TERMINATE : // Connection Terminate => ReConnection
                  begin
                    exit;
                  end;
            gcERROR_TIME_OUT,
            gcERROR_DATA_CONTEXT :
                  begin
                       // Send Main Error(통신이상 해당작업결과요망)
                       continue;
                  end;
       end; // end case

       // 정상수신자료
       CharCharCpy(lanPbuff,lanRawBuff,iDecodeSize);
       lanPbuff[iDecodeSize] := #0;

       //------------------------
       // Type별 Check
       //------------------------
       if CharCharCmp(@lanPbuff[0],gcSTYPE_POLL,3) = 0 then
       begin
          //----------------------------------------------------------------
          // Poll Data는 ACK를 보내지 않는다.
          // iRawLen := 0;
          // fnTcpDataSend(flog,TSockID,STYPE_ACK,1,iRawLen,lanRawBuff);
          if gvRealLogYN = 'Y' then  // LMS Modify 20040202
            gf_Log('TRACE>> Rcv POLL');
          continue;
          //----------------------------------------------------------------
       end else
       if CharCharCmp(@lanPbuff[0],gcSTYPE_CLO,3) = 0 then
       begin
         Exit;
       end else
       if (CharCharCmp(@lanPbuff[0],gcSTYPE_MSQ,3) = 0) or
          (CharCharCmp(@lanPbuff[0],gcSTYPE_MSG,3) = 0) or
          (CharCharCmp(@lanPbuff[0],gcSTYPE_MEL,3) = 0) or                 
          (CharCharCmp(@lanPbuff[0],gcSTYPE_FAX,3) = 0) then
       begin
         ClientQueueInsert(iDecodeSize,lanPbuff);
{
         if gvRealLogYN = 'Y' then  // LMS Modify 20040113
         begin
           if  copy(lanPbuff, 1, 3) = gcSTYPE_FAX then
           begin
             faxResult := ptTFAXResult(lanPbuff + sizeof(SvrCliHead_R));
             gf_Log('TRACE>> EnQ DATA [' +
               Trim(faxResult^.sSeqNo) + '=' +
               gf_GetFaxTlxResult(gf_StrToInt(faxResult^.sRspCode)) + '=' +
               gf_FormatTime(faxResult^.sSendTime) + '=' +
               gf_FormatTime(faxResult^.sRecvTime) + '=' +
               faxResult^.sDiffTime + '=' +
               faxResult^.sCurrPage + '=' +
               faxResult^.sBusyCnt + '=' +
               Trim(faxResult^.sOprId) + '=' +
               Trim(faxResult^.sOprTime) + '=' +
               Trim(faxResult^.sErrCode) + '=' +
               Trim(faxResult^.sErrMsg) + '=' +
               Trim(faxResult^.sExtMsg) + ']'
             );
           end;
         end;
}         
         Continue;
       end else
       begin
         // Server Type Error
       end;
  end; (* end while *)

except
  begin
    gf_Log('TCPIP_LOGSND>> Exception Error : ' + FException.Message);
    Exit;
  end;
end; // except end

  // 외부에서 kill발생시
  if terminated = TRUE then break;

until false;

end;


//*=======================================================================*/
//* MSMQResult Send
//*=======================================================================*/
procedure TTcp_ServicePort.ClientQueueInsert(RLen : Integer; Rbuff: PChar);
begin
  if FClientQueue.EnQueue(RLen,Rbuff) = False then
  begin
    gf_Log('TCPIP_LOGSND>> ClientQueue EnQueue Error');
    Exit;
  end;
end;

//*=======================================================================*/
//* InitLogin
//*=======================================================================*/
function TTcp_ServicePort.InitLogin : Integer;
var
  iResult : Integer;
  MyMsg   : TMessage;
begin
  // Login Data Send
  iResult := fnLoginSendData(FMySocket);

  Result := iResult;
  
  if iResult < 0 then
  begin
    gf_Log('InitLogin>> after fnLoginSendData:'+ErrMessage);
    MyMsg.WParam := gcTCPIP_CLIENT_LOGSND_WPARAM_LOGIN_FAILD;
    gvDataBuff := ErrMessage;
    SendMessage(gvLoginFormHandle,WM_USER_TCPIP_CLIENT_LOGSND,MyMsg.WParam,MyMsg.LParam);
    Result := iResult;
    exit;
  end;

  if FClientVersionUP then
  begin
    MyMsg.WParam := gcTCPIP_CLIENT_LOGSND_WPARAM_LOGIN_VERSIONUP;
    SendMessage(gvLoginFormHandle,WM_USER_TCPIP_CLIENT_LOGSND,MyMsg.WParam,MyMsg.LParam);
    Exit;
  end;
    
  MyMsg.WParam := gcTCPIP_CLIENT_LOGSND_WPARAM_LOGIN_SUCCESS;
  SendMessage(gvLoginFormHandle,WM_USER_TCPIP_CLIENT_LOGSND,MyMsg.WParam,MyMsg.LParam);
end;

//*=======================================================================*/
// Client Login Data 전송 function
//*=======================================================================*/
function  TTcp_ServicePort.fnLoginSendData(TSockID_Local:TSocket):Integer;
var
   cpSbuff : array [0..gcMAX_COMM_BUFF_SIZE] of char;
   iSlen,iRc: Integer;
   CliSvrHead : CliSvrHead_R;
   tTempLogData : TLOGDATA;
   sCliVersion  : String;
begin
     fnCharSet(@clisvrhead,' ',sizeof(CliSvrHead_R));

     CharCharCpy(clisvrhead.TrCode,gcSTYPE_LOGN,3);
     fnCharSet(clisvrhead.TrCode,' ',sizeof(clisvrhead.TrCode));
     //초기 Login시 단말번호 없음
     fnCharSet(clisvrhead.TermNo,' ',sizeof(clisvrhead.TermNo));
     MoveDataChar(clisvrhead.LoginID,gvOprUsrNo,Length(gvOprUsrNo));
     fnCharSet(clisvrhead.WinHandle,' ',sizeof(clisvrhead.WinHandle));

     CharCharCpy(cpSbuff,@clisvrhead,sizeof(CliSvrHead_R));
     iSlen := sizeof(CliSvrHead_R);

     //----------------------------------------------------
     // DATA -> ENGFLG[1) + PASSWD[8] + VERSION[4]
     //----------------------------------------------------
{$IFDEF ENG_VER}
     tTempLogData.cEngFlag := 'E';
{$ELSE}
     tTempLogData.cEngFlag := 'K';
{$ENDIF}
     MoveDataChar(tTempLogData.csPassWd,gvOprPassWd,SizeOf(tTempLogData.csPassWd));
     CharCharCpy(tTempLogData.csUsrSvrVersion,gcUSERSVR_CLIENT_VERSION,Length(gcUSERSVR_CLIENT_VERSION));
     tTempLogData.csUsrSvrVersion[4] := #0;
     MoveDataChar(tTempLogData.csClientExeName,
                  ExtractFileName(Application.ExeName),SizeOf(tTempLogData.csClientExeName));
     sCliVersion := gf_ExeVersion(Application.ExeName);
     MoveDataChar(tTempLogData.csClientVersion,sCliVersion,SizeOf(tTempLogData.csClientVersion));
     CharCharCpy(@cpsBuff[iSlen],@tTempLogData,SizeOf(tTempLogData));
     Inc(iSlen,SizeOf(tTempLogData));
     cpSbuff[iSlen] := #0;

     //초기 Login Send
     iRc := fnTcpDataSend(TSockID_Local,1,iSlen,cpSbuff);
     if (iRc < 0) then
     begin
       ErrMessage := '[' + IntToStr(abs(iRc)) + '] ' + fnErrorMsg(abs(iRc));
       result := iRc;
       exit;
     end;
gf_Log('fnLoginSendData>> after fnTcpDataSend');
     //초기 Login승인 수신(사용자정보를 수신)
     iRc := fnInitLoginRecv(TSockID_Local);
     if iRc < 0 then
     begin
       result := iRc;
       exit;
     end;
gf_Log('fnLoginSendData>> after fnInitLoginRecv');
     result := 1;
end;

//*=======================================================================*/
// 초기 사용자정보수신
//*=======================================================================*/
function TTcp_ServicePort.fnInitLoginRecv(TSockID_Local:TSocket):Integer;
var
   cpSbuff : array [0..gcMAX_COMM_BUFF_SIZE] of char;
   iSlen,iRc: Integer;
   cpTemp : array [0..256] of char;
   iIndex : Integer;

   // P/C I/P Address관련
   addrlen : Integer;
   pcaddr  : PChar;
   my_addr : TSockAddrIn;

   lanRawBuff : array[0..gcMAX_COMM_BUFF_SIZE] of char;
   iDecodeSize:LongInt;
   iPacketNo  : LongInt;
   iDataIndex,iTokenLen : Integer;
begin
     ErrMessage := '';
     
     // 결과를 기다린다.
     iRc := fnTcpDataRecv(TSockID_Local,lanRawBuff,iDecodeSize,iPacketNO);
     if (iRc < 0) then
     begin
       ErrMessage := ErrMessage + fnErrorMsg(abs(iRc));
       result := iRc;
       exit;
     end;

     //--------------------------------------------------------------
     // Packet -> DATA구분(3) + MSGNO(4) + TRX-CODE(3) + SeqNo(4) +
     //             (INT)                   (STA/VER)
     //           DRUSERID(n) + 0x04 + COMPANYNAME(n) + 0x04 + OPRNAME(n) + 0x04 +
     //
     //           RoleCode(1) + 0x04 + DBCOMPUTERNAME (n) + DBNAME(n) + 0x04 +
     //
     //           DB USERID(n) + 0x04 + DB PASSWD(n) + 0x04 + SPLIT_MTD(1) + 0x04
     //
     //           MY PARTY ID(n) + 0x04 + 당일자(n) + 0x04 + DR 접속여부 + 0x04
     //
     //           STAMP Sign여부 + 0x04 + Default DataBaseName + 0x04
     //
     //           MailSendFlag  + 0x04
     //
     //--------------------------------------------------------------


     // Msg가 '0000'이아니면 Server에서 온 Message를 출력후 exit
     if CharCharCmp(@lanRawBuff[3],'0000',4) <> 0 then
     begin
       ErrMessage := ErrMessage + StrPas(@lanRawBuff[7]);
       result := -fnAtoI(@lanRawBuff[3],4);
       exit;
     end;

     // Client Version Check
     if CharCharCmp(@lanRawBuff[7],gcSINT_VER,3) = 0 then
     begin
       Result := fnClientVersionUpGrade(TSockID_Local,lanRawBuff);
       if Result < 0 then
       begin
         Result := -1;
         ErrMessage := 'Client Version Upgrade Error!';
         Exit;
       end;
       Exit;
     end;

     iDataIndex := 14;

     // DataRoad UserID
     iTokenLen := fnGetTokenNull(@lanRawBuff[iDataIndex],iDecodeSize-iDataIndex,gcDATA_DELIMITER,1,cpTemp);
     if iTokenLen < 0 then
     begin
        // Server자료 이상
        Result := -4030; //Abnormal server data.
        ErrMessage := ErrMessage + fnErrorMsg(abs(Result));
        Exit;
     end;
     gvPartyUserID := Trim(Char2Str(cpTemp,strlen(cpTemp)));
     Inc(iDataIndex,iTokenLen+1);

     // 회사이름
     iTokenLen := fnGetTokenNull(@lanRawBuff[iDataIndex],iDecodeSize-iDataIndex,gcDATA_DELIMITER,1,cpTemp);
     if iTokenLen < 0 then
     begin
        // Server자료 이상
        Result := -4030; //Abnormal server data.
        ErrMessage := ErrMessage + fnErrorMsg(abs(Result));
        Exit;
     end;
     gvCompName := Trim(Char2Str(cpTemp,strlen(cpTemp)));
     Inc(iDataIndex,iTokenLen+1);

     // 조작자이름
     iTokenLen := fnGetTokenNull(@lanRawBuff[iDataIndex],iDecodeSize-iDataIndex,gcDATA_DELIMITER,1,cpTemp);
     if iTokenLen < 0 then
     begin
        // Server자료 이상
        Result := -4030; //Abnormal server data.
        ErrMessage := ErrMessage + fnErrorMsg(abs(Result));
        Exit;
     end;
     gvOprUsrName := Trim(Char2Str(cpTemp,strlen(cpTemp)));
     Inc(iDataIndex,iTokenLen+1);
     
     // RoleCode
     iTokenLen := fnGetTokenNull(@lanRawBuff[iDataIndex],iDecodeSize-iDataIndex,gcDATA_DELIMITER,1,cpTemp);
     if iTokenLen < 0 then
     begin
        // Server자료 이상
        Result := -4030; //Abnormal server data.
        ErrMessage := ErrMessage + fnErrorMsg(abs(Result));
        Exit;
     end;
     gvRoleCode := Trim(Char2Str(cpTemp,strlen(cpTemp)));
     Inc(iDataIndex,iTokenLen+1);

     // DataBase Computer Name
     iTokenLen := fnGetTokenNull(@lanRawBuff[iDataIndex],iDecodeSize-iDataIndex,gcDATA_DELIMITER,1,cpTemp);
     if iTokenLen < 0 then
     begin
        // Server자료 이상
        Result := -4030; //Abnormal server data.
        ErrMessage := ErrMessage + fnErrorMsg(abs(Result));
        Exit;
     end;
     gvDBServerName := Trim(Char2Str(cpTemp,strlen(cpTemp)));
     Inc(iDataIndex,iTokenLen+1);

     // DataBase Name
     iTokenLen := fnGetTokenNull(@lanRawBuff[iDataIndex],iDecodeSize-iDataIndex,gcDATA_DELIMITER,1,cpTemp);
     if iTokenLen < 0 then
     begin
        // Server자료 이상
        Result := -4030; //Abnormal server data.
        ErrMessage := ErrMessage + fnErrorMsg(abs(Result));
        Exit;
     end;
     gvDBName := Trim(Char2Str(cpTemp,strlen(cpTemp)));
     Inc(iDataIndex,iTokenLen+1);     

     // DataBase User ID
     iTokenLen := fnGetTokenNull(@lanRawBuff[iDataIndex],iDecodeSize-iDataIndex,gcDATA_DELIMITER,1,cpTemp);
     if iTokenLen < 0 then
     begin
        // Server자료 이상
        Result := -4030; //Abnormal server data.
        ErrMessage := ErrMessage + fnErrorMsg(abs(Result));
        Exit;
     end;
     gvDBUserID := Trim(Char2Str(cpTemp,strlen(cpTemp)));
     Inc(iDataIndex,iTokenLen+1);     

     // DataBase PassWd
     iTokenLen := fnGetTokenNull(@lanRawBuff[iDataIndex],iDecodeSize-iDataIndex,gcDATA_DELIMITER,1,cpTemp);
     if iTokenLen < 0 then
     begin
        // Server자료 이상
        Result := -4030; //Abnormal server data.
        ErrMessage := ErrMessage + fnErrorMsg(abs(Result));
        Exit;
     end;
     gvDBPassWd := Trim(Char2Str(cpTemp,strlen(cpTemp)));
     Inc(iDataIndex,iTokenLen+1);

     // Split Method
     iTokenLen := fnGetTokenNull(@lanRawBuff[iDataIndex],iDecodeSize-iDataIndex,gcDATA_DELIMITER,1,cpTemp);
     if iTokenLen < 0 then
     begin
        // Server자료 이상
        Result := -4030; //Abnormal server data.
        ErrMessage := ErrMessage + fnErrorMsg(abs(Result));
        Exit;
     end;
     gvSplitMtd := Trim(Char2Str(cpTemp,strlen(cpTemp)));
     Inc(iDataIndex,iTokenLen+1);

     // PARTY ID
     iTokenLen := fnGetTokenNull(@lanRawBuff[iDataIndex],iDecodeSize-iDataIndex,gcDATA_DELIMITER,1,cpTemp);
     if iTokenLen < 0 then
     begin
        // Server자료 이상
        Result := -4030; //Abnormal server data.
        ErrMessage := ErrMessage + fnErrorMsg(abs(Result));
        Exit;
     end;
     gvMyPartyID := Trim(Char2Str(cpTemp,strlen(cpTemp)));
     gvCompCode  := Copy(gvMyPartyID,1,4);
     gvDeptCode  := Copy(gvMyPartyID,5,2);
     Inc(iDataIndex,iTokenLen+1);

     // 당일자
     iTokenLen := fnGetTokenNull(@lanRawBuff[iDataIndex],iDecodeSize-iDataIndex,gcDATA_DELIMITER,1,cpTemp);
     if iTokenLen < 0 then
     begin
        // Server자료 이상
        Result := -4030; //Abnormal server data.
        ErrMessage := ErrMessage + fnErrorMsg(abs(Result));
        Exit;
     end;
     gvCurDate := Trim(Char2Str(cpTemp,strlen(cpTemp)));
     Inc(iDataIndex,iTokenLen+1);

     // DR Svr접속 여부
     iTokenLen := fnGetTokenNull(@lanRawBuff[iDataIndex],iDecodeSize-iDataIndex,gcDATA_DELIMITER,1,cpTemp);
     if iTokenLen < 0 then
     begin
        // Server자료 이상
        Result := -4030; //Abnormal server data.
        ErrMessage := ErrMessage + fnErrorMsg(abs(Result));
        Exit;
     end;
     if cpTemp[0] = '1' then
       gvDRSvrConnFlag := True
     else
       gvDRSvrConnFlag := False;
     Inc(iDataIndex,iTokenLen+1);

     // Stamp Sign 여부
     iTokenLen := fnGetTokenNull(@lanRawBuff[iDataIndex],iDecodeSize-iDataIndex,gcDATA_DELIMITER,1,cpTemp);
     if iTokenLen < 0 then
     begin
        // Server자료 이상
        Result := -4030; //Abnormal server data.
        ErrMessage := ErrMessage + fnErrorMsg(abs(Result));
        Exit;
     end;
     if cpTemp[0] = 'Y' then
       gvStampSignFlag := True
     else
       gvStampSignFlag := False;
     Inc(iDataIndex,iTokenLen+1);

     // User Dept Name
     iTokenLen := fnGetTokenNull(@lanRawBuff[iDataIndex],iDecodeSize-iDataIndex,gcDATA_DELIMITER,1,cpTemp);
     if iTokenLen < 0 then
     begin
        // Server자료 이상
        Result := -4030; //Abnormal server data.
        ErrMessage := ErrMessage + fnErrorMsg(abs(Result));
        Exit;
     end;
     gvDeptName := Trim(Char2Str(cpTemp,strlen(cpTemp)));
     Inc(iDataIndex,iTokenLen+1);

     // Default DataBaseName
     iTokenLen := fnGetTokenNull(@lanRawBuff[iDataIndex],iDecodeSize-iDataIndex,gcDATA_DELIMITER,1,cpTemp);
     if iTokenLen < 0 then
     begin
        // Server자료 이상
        Result := -4030; //Abnormal server data.
        ErrMessage := ErrMessage + fnErrorMsg(abs(Result));
        Exit;
     end;
     gvDefaultDB := Trim(Char2Str(cpTemp,strlen(cpTemp)));
     Inc(iDataIndex,iTokenLen+1);

     // MailSendFlag Setting
     iTokenLen := fnGetTokenNull(@lanRawBuff[iDataIndex],iDecodeSize-iDataIndex,gcDATA_DELIMITER,1,cpTemp);
     if iTokenLen < 0 then
     begin
        // Server자료 이상
        Result := -4030; //Abnormal server data.
        ErrMessage := ErrMessage + fnErrorMsg(abs(Result));
        Exit;
     end;
     gvSendMailFlag := False;
     if Trim(Char2Str(cpTemp,strlen(cpTemp))) = '1' then
        gvSendMailFlag := True;  // Server Mail Send 가능 여부

     //------------------------------------------------
     // Client단말번호
     // TSockID_Local은 반드시 connect후 사용돼야함
     //------------------------------------------------
     addrlen := sizeof(my_addr);
     if getsockname(TsockID_Local,my_addr,addrlen) <> 0 then
     begin
       result := -4008; //System error.
       ErrMessage := ErrMessage + 'GetSockName Error';
       exit;
     end;
     pcaddr := inet_ntoa(my_addr.sin_addr);
     gvTermNo := pcaddr;
     for iIndex := 1 to 15 - Length(gvTermNo) do
       gvTermNo := gvTermNo + ' ';

     //ACK자료 전송
     iSlen := 0;
     CharCharCpy(@cpSbuff[iSlen],lanRawBuff,14);
     Inc(iSlen,14);
     CharCharCpy(@cpSbuff[iSlen],'ACK',3);
     Inc(iSlen,3);

     iRc := fnTcpDataSend(TSockID_Local,1,iSlen,cpSbuff);
     if (iRc < 0) then
     begin
          ErrMessage := ErrMessage + fnErrorMsg(abs(iRc));
          result := iRc;
          exit;
     end;

     result := 1;
end;

//*=======================================================================*/
// Client Version Upgrade
//*=======================================================================*/
function TTcp_ServicePort.fnClientVersionUpgrade(TSockID_Local:TSocket;lanRawBuff : PChar) : Integer;
var
  iDataRead : Integer;
  iSeqNo         : Integer;
  BytesWritten   : Integer;
  iDecodeSize:LongInt;
  iPacketNo  : LongInt;
  cpSbuff    : array [0..gcMAX_COMM_BUFF_SIZE] of char;
  iSlen,iRc  : Integer;
  DestFile   : File;
  sOldFileName,sUpgradeFileName : String;
  FileAttributes : Word;
begin
  sUpgradeFileName := ExtractFilePath(Application.ExeName) +'\'+
                      ChangeFileExt(ExtractFileName(Application.ExeName),'.$$$');

  AssignFile(DestFile,sUpgradeFileName);
  {$I-}
  ReWrite(DestFile,1);
  {$I+}
  if IOResult <> 0 then
  begin
    ErrMessage := 'DestFile Create Error!';
    result := -1;
    Exit;
  End;

  FTotalFileSize := fnAtoI(@lanRawBuff[14],8);
  FTotalRead := 0;

  While True do
  begin
    Try
      Synchronize(DisplayVersionUpgradeBar);

      //ACK자료 전송
      iSlen := 0;
      CharCharCpy(@cpSbuff[iSlen],lanRawBuff,14);
      Inc(iSlen,14);
      CharCharCpy(@cpSbuff[iSlen],'ACK',3);
      Inc(iSlen,3);

      iRc := fnTcpDataSend(TSockID_Local,1,iSlen,cpSbuff);
      if (iRc < 0) then
      begin
        ErrMessage := ErrMessage + fnErrorMsg(abs(iRc));
        result := iRc;
        CloseFile(DestFile);
        exit;
      end;

      // 결과를 기다린다.
      iRc := fnTcpDataRecv(TSockID_Local,lanRawBuff,iDecodeSize,iPacketNO);
      if (iRc < 0) then
      begin
        ErrMessage := 'Socket Read Error : ' + fnErrorMsg(abs(iRc));
        result := iRc;
        CloseFile(DestFile);
        Exit;
      end;

      //--------------------------------------------------------------
      // Packet -> DATA구분(3) + MSGNO(4) + TRX-CODE(3) + SeqNo(4) +
      //             (INT)                   (VER)
      //           FileSize(8) + DATA(n)
      //--------------------------------------------------------------
      iSeqNo    := fnAtoI(@lanRawBuff[10],4);
      if iSeqNo = 9999 then Break;

      iDataRead := fnAtoI(@lanRawBuff[14],8);
      Inc(FTotalRead,iDataRead);
      BlockWrite(DestFile,lanRawBuff[22],iDataRead,BytesWritten);
      if iDataRead <> BytesWritten then
      begin
        ErrMessage := 'BlockWrite Error';
        result := -1;
        CloseFile(DestFile);
        Exit;
      end;
    Except
      Erase(DestFile);
      Raise;
      ErrMessage := 'Client Version Upgrade Error!';
      result := -1;
      CloseFile(DestFile);
      Exit;
    End;
  end; //end While

  Try
    CloseFile(DestFile);

    AssignFile(DestFile,Application.ExeName);
    sOldFileName := ExtractFilePath(Application.ExeName)+ '\' +
             ChangeFileExt(ExtractFileName(Application.ExeName),'.Old');

    if FileExists(sOldFileName) then   // LMS
    begin
       FileAttributes := FileGetAttr(sOldFileName);
       if (FileAttributes and SysUtils.faReadOnly) = SysUtils.faReadOnly then
       begin
         FileAttributes := FileAttributes and not SysUtils.faReadOnly;
         FileSetAttr(sOldFileName, FileAttributes);
       end;
       FileAttributes := FileGetAttr(Application.ExeName);
       if (FileAttributes and SysUtils.faReadOnly) = SysUtils.faReadOnly then
       begin
         FileAttributes := FileAttributes and not SysUtils.faReadOnly;
         FileSetAttr(Application.ExeName, FileAttributes);
       end;
       DeleteFile(sOldFileName);
    end;
    Rename(DestFile,sOldFileName);
    AssignFile(DestFile,sUpgradeFileName);
    Rename(DestFile,Application.ExeName);
  Except
    DeleteFile(sOldFileName);
    DeleteFile(sUpgradeFileName);
    Raise;
    ErrMessage := 'Client Version Upgrade Error!';
    result := -1;
    Exit;
  End;

  with Form_Login do
  begin
    DRPanel_Version.Visible := False;
  end;

  FClientVersionUp := True;
  Result := 1;
end;

//*=======================================================================*/
// Version Upgrade Process Bar
//*=======================================================================*/
procedure TTcp_ServicePort.DisplayVersionUpgradeBar;
begin
  with Form_Login do
  begin
    if not DRPanel_Version.Visible then
    begin
      DRPanel_Version.Visible := True;
      DRPanel_Version.Repaint;
    end;

    DRProgressBar.Position := Trunc((FTotalRead / FTotalFileSize) * 100);
    DRLabel_Percent.Caption := IntToStr(DRProgressBar.Position) + ' %';
    DRLabel_Percent.Update;
    DRProgressBar.Update
  end;
end;

//*=======================================================================*/
//* TTcp_ServicePort Thread Create
//*=======================================================================*/
constructor TTcp_ServicePort.Create(TSockID_Local : TSocket);
begin
  inherited Create(True); // thread생성되자 마자 실행안됨

  FMySocket := TSockID_Local;
  if gvUserSvrTimeOut <= 0 then
    FTimeOut := 10
  else
    FTimeOut  := gvUserSvrTimeOut;

  FNormalCreFlag := True;  
end;

//*=======================================================================*/
//* TCP Terminate
//*=======================================================================*/
procedure TTcp_ServicePort.DoTerminate;
begin
  TcpClose(FMySocket);
  FMySocket := 0;
  if FClientQueue <> Nil then fnQueueClose(FClientQueue);  
  inherited DoTerminate;
end;

//*=======================================================================*/
//* TCP Destroy
//*=======================================================================*/
destructor TTcp_ServicePort.destroy;
var
  Msg : TMessage;
begin
  inherited destroy;
  TcpServicePort := Nil;

  // Send Main Error(통신주절)
  Msg.WParam := gcTCPIP_CLIENT_LOGSND_WPARAM_DISCONN;
  PostMessage(gvMainFrameHandle,WM_USER_TCPIP_CLIENT_LOGSND, Msg.WParam,Msg.LParam);
end;

//*=======================================================================*/
//* Thread Create
//*=======================================================================*/
function fnThreadCreate(TSockID_Local : TSocket) :integer;
begin
  TcpServicePort := Nil;

  // SEND PORT Thread Create
  TcpServicePort:= TTcp_ServicePort.Create(TSockID_Local);
  if (TcpServicePort = Nil) or (Not TcpServicePort.FNormalCreFlag) then
  begin
    Result := 1;
    Exit;
  end;
  
  TcpServicePort.priority:=tpNormal;
  TcpServicePort.FreeOnTerminate := True;
  TcpServicePort.Resume;   // TTcp_ServicePort.Execute 실행
  Result := 1;
end;

//*=======================================================================*/
// TcpIpInit
//*=======================================================================*/
function fnTcpIpInit : Integer;
var
  TsockID_Local : TSocket;
  sMsg : array [0..50] of char;
  Msg : TMessage;
  SERVER_IPADDR : array [0..15] of char;
  SERVER_PORT   : integer;
begin
  Str2Char(SERVER_IPADDR,gvUserSvrIP,Length(gvUserSvrIP));
  SERVER_PORT := gvUserSvrPort;

  // SOCKET 초기화 ( Memory Grid error발생시 bind error생성 가능함
  if (WinsockInit < 0) then
  begin
    ErrMessage := '>> Winsock Init error <<';
    gvDataBuff := ErrMessage;
    Msg.WParam := gcTCPIP_CLIENT_LOGSND_WPARAM_LOGIN_FAILD;
    SendMessage(gvLoginFormHandle,WM_USER_TCPIP_CLIENT_LOGSND,Msg.WParam,Msg.LParam);
    result := -1;
    Exit;
  end;

  // Tcp open
  TSockID_Local := TcpOpen(SERVER_IPADDR,SERVER_PORT);
  if TsockID_Local < 0 then
  begin
    strfmt(sMsg,'>> TCP [%s] port [%d]Failed <<',[SERVER_IPADDR,SERVER_PORT]);
    gvDataBuff := StrPas(sMsg);
    Msg.WParam := gcTCPIP_CLIENT_LOGSND_WPARAM_LOGIN_FAILD;
    SendMessage(gvLoginFormHandle,WM_USER_TCPIP_CLIENT_LOGSND,Msg.WParam,Msg.LParam);
    result := -1;
    exit;
  end;

  fnThreadCreate(TSockID_Local);
  Result := 1;
end;

//*=======================================================================*/
// TcpIpClose
//*=======================================================================*/
procedure fnTcpIpClose;
begin
  // Thread Kill
  fnThreadKilled(TcpServicePort,TRUE);
end;
//*=======================================================================*/

//*=======================================================================*/
// Client Data 전송 function
//*=======================================================================*/
function fnServerSendData(iSlen:integer; cpSbuff:PChar):Integer;
var
   lpExitCode : DWord;
begin
  Result := -1;
  if Assigned(TcpServicePort) then
  begin
       if GetExitCodeThread(TcpServicePort.Handle,lpExitCode) then
       begin
           if lpExitCode = STILL_ACTIVE then
           begin
                result := fnTcpDataSend(TcpServicePort.FMySocket,1,iSlen,cpSbuff);
           end;
       end;
  end;
end;

//=======================================================================
// Message Queue Data Send Function
//=======================================================================
function fnMQDataSend(pSndFormat : pMSMQSendFormat; var iTotSeqNo : Integer) : Boolean;
var
  sTemp : String;
  sSecCode : String;
  iIndex : Integer;

  cpSbuff : array [0..gcMAX_COMM_BUFF_SIZE] of char;
  iSlen   : Integer;
  CliSvrHead : CliSvrHead_R;
begin
  sSecCode := Copy(pSndFormat.sTRXCode,1,1);

  with DataModule_SettleNet do
  begin
    //채번
    with ADOSP_SP0103 do
    begin
      try
        Parameters.ParamByName('@in_date').Value := gvCurDate;
        Parameters.ParamByName('@in_dept_code').Value := gcDEPT_CODE_COMMON;
        Parameters.ParamByName('@in_sec_type').Value := sSecCode;
        Parameters.ParamByName('@in_send_mtd').Value := gcSND_MTD_DATA;
        Parameters.ParamByName('@in_biz_type').Value := '01';
        Parameters.ParamByName('@in_get_flag').Value := '2';
        Execute;
      except
        on E : Exception do
        begin
          gvErrorNo := 9002; // Stored Procedure 실행 오류
          gvExtMsg := E.Message;
          Result := False;
          Exit;
        end;
      end;

      sTemp := Parameters.ParamByName('@out_rtc').Value;
      if sTemp <> '0000' then
      begin
        gvErrorNo := 9002; // Stored Procedure 실행 오류
        gvExtMsg := Trim(Parameters.ParamByName('@out_kor_msg').Value);
        Result := False;
        Exit;
      end;
      iTotSeqNo := Parameters.ParamByName('@out_snd_no').Value;
    end;

    with ADOCommand_Main do
    begin
      CommandText :=
              'INSERT SEQUESND_TBL                     ' +
              '   (SND_DATE,                           ' +
              '    SEND_TOT_SEQ,           SEC_DATE,   ' +
              '    FROM_PARTY_ID,          TO_PARTY_ID,' +
              '    SENT_CNT,                           ' +
              '    SEQ_NO,                 TRAN_CODE,  ' +
              '    CUR_TOT_SEQ_NO,         COMMON_DATA,' +
              '    INFO_DATA_CNT,          INFO_DATA,  ' +
              '    MAIN_DATA,              OPR_ID     )' +
              'VALUES                                  ' +
              '   (:pSndDate,                          ' +
              '    :pSendTotSeq,           :pSecDate,  ' +
              '    :pFromPartyID,          :pToPartyID,' +
              '    :pSendCnt,                          ' +
              '    :pSeqNo,                :pTranCode, ' +
              '    :pCurTotSeqNo,          :pCommonData,'+
              '    :pInfoDataCnt,          :pInfoData, ' +
              '    :pMainData,             :pOprID    )';
      try
        Parameters.ParamByName('pSndDate').Value     := pSndFormat.sCurDate;
        Parameters.ParamByName('pSendTotSeq').Value  := pSndFormat.iSendTotSeq;
        Parameters.ParamByName('pSecDate').Value     := pSndFormat.sSecDate;
        Parameters.ParamByName('pFromPartyID').Value := pSndFormat.sFromPartyID;
        Parameters.ParamByName('pToPartyID').Value   := pSndFormat.sTOPartyID;
        Parameters.ParamByName('pSendCnt').Value     := pSndFormat.iSendCnt;
        Parameters.ParamByName('pSeqNo').Value       := pSndFormat.iSendCurSeq;
        Parameters.ParamByName('pTranCode').Value := pSndFormat.sTRXCode;
        Parameters.ParamByName('pCurTotSeqNo').Value := iTotSeqNo;
        Parameters.ParamByName('pCommonData').Value := pSndFormat.sCommonFld;
        Parameters.ParamByName('pInfoDataCnt').Value := pSndFormat.iInfoDataCnt;

        //정보부
        sTemp := '';
        for iIndex := 0 to pSndFormat.iInfoDataCnt - 1 do
        begin
          pSndFormat.tMSMQData[iIndex].sTableName :=
            MoveDataStr(pSndFormat.tMSMQData[iIndex].sTableName,
                     SizeOf(pSndFormat.tMSMQData[iIndex].sTableName));

          sTemp := sTemp +
                   pSndFormat.tMSMQData[iIndex].sTableName +
                   pSndFormat.tMSMQData[iIndex].cDelIns    +
                   FormatFloat('00000',pSndFormat.tMSMQData[iIndex].iStartPos)+
                   FormatFloat('00000',pSndFormat.tMSMQData[iIndex].iDataSize) +
                   FormatFloat('000',  pSndFormat.tMSMQData[iIndex].iRepetCnt);
        end;
        Parameters.ParamByName('pInfoData').Value := sTemp;

        Parameters.ParamByName('pMainData').Value := pSndFormat.sMainDATA;

        Parameters.ParamByName('pOprID').Value := gvOprUsrNo;

        Execute;
      except
        on E : Exception do
        begin
          gvErrorNo := 9001; // DB오류
          gvExtMsg := E.Message;
          Result := False;
          Exit;
        end;
      end; // end Except
    end; //end ADOQuery_Main
  end; //end with DataModule_SettleNet

  //----------------------------------------------------------------------------
  // MSMQ SEND Request Send
  //----------------------------------------------------------------------------
  fnCharSet(@clisvrhead,' ',sizeof(CliSvrHead_R));
  MoveDataChar(clisvrhead.TrGbn,gcSTYPE_MSQ,SizeOf(clisvrhead.TrGbn));
  MoveDataChar(clisvrhead.TrCode,'',SizeOf(clisvrhead.TrCode));
  MoveDataChar(clisvrhead.TermNo,gvTermNo,sizeof(clisvrhead.TermNo));
  MoveDataChar(clisvrhead.LoginID,gvOprUsrNo,Sizeof(clisvrhead.LoginID));
  MoveDataChar(clisvrhead.WinHandle,'',sizeof(clisvrhead.WinHandle));

  CharCharCpy(cpSbuff,@clisvrhead,sizeof(CliSvrHead_R));
  iSlen := sizeof(CliSvrHead_R);

  // MSMQ자료 전송 Request Send
  if fnServerSendData(iSlen,cpSbuff) < 0 then
  begin
{
   Result := False;
   Exit;
}
  end;

  Result := True;
end;

//=======================================================================
// Fax Data Send Function : LMS Modify
//=======================================================================
function fnFAXDataSend(pFaxSndFormat : pFAXTLXSendFormat;
                       tReportList : TList; var StartTime : String) : Boolean;
var
  cpSbuff : array [0..gcMAX_COMM_BUFF_SIZE] of char;
  iSlen   : Integer;
  CliSvrHead : CliSvrHead_R;
  sTemp    : String;
  iIndex   : Integer;
  iSndTotSeqNo, iCurTotSeqNo, iIdxSeqNo : Integer;
  pReportInfo    : pTReportList;
  pTmpTBACTrade  : pTBACTrade;
  pTmpTBGPTrade  : pTBGPTrade;
  pTmpTBACNormal : pTBACNormal;
  pTmpTBGPNormal : pTBGPNormal;
begin
  Result := False;

  if tReportList.Count <= 0 then
  begin
    gvErrorNo := 9005; // 데이터 오류
    gvExtMsg := 'Report 정보 없음';
    Exit;
  end;

  with DataModule_SettleNet do
  begin
    //--------------------
    gf_BeginTransaction;
    //--------------------

    //--- 채번 (SND_SEQ_NO: 동시 전송 Group 처리)
    with ADOSP_SP0103 do
    begin
      try
        Parameters.ParamByName('@in_date').Value := gvCurDate;
        Parameters.ParamByName('@in_dept_code').Value := gcDEPT_CODE_COMMON;
        Parameters.ParamByName('@in_sec_type').Value  := gcSEC_COMMONFAX;
        Parameters.ParamByName('@in_send_mtd').Value  := gcSND_MTD_FAX_IDX;
        Parameters.ParamByName('@in_biz_type').Value  := '01';
        Parameters.ParamByName('@in_get_flag').Value  := '2';
        Execute;
      except
        on E : Exception do
        begin
          gf_RollbackTransaction;
          gvErrorNo := 9002; // Stored Procedure 실행 오류
          gvExtMsg := E.Message;
          Exit;
        end;
      end;

      sTemp := Parameters.ParamByName('@out_rtc').Value;
      if sTemp <> '0000' then
      begin
        gf_RollbackTransaction;
        gvErrorNo := 9002; // Stored Procedure 실행 오류
        gvExtMsg := Trim(Parameters.ParamByName('@out_kor_msg').Value);
        Exit;
      end;
      iSndTotSeqNo := Parameters.ParamByName('@out_snd_no').Value;
    end;  // end of with

    for iIndex := 0 to tReportList.Count -1 do
    begin
      pReportInfo := tReportList.Items[iIndex];

      if pReportInfo.iIdxSeqNo > 0 then  // 이전에 저장된 Image
      begin
        iIdxSeqNo := pReportInfo.iIdxSeqNo;

        // 해당 Image Index에 대한 Report 관련 정보를 다시 넘겨줌 (송수신 Mgr에서 편하게 처리하기 위해)
        with ADOQuery_Main do
        begin
          Close;
          SQL.Clear;
          SQL.Add(' Select SEC_TYPE, TRADE_DATE, REPORT_TYPE,   ' +
                  '        REPORT_ID, DIRECTION, LOGO_PAGE_NO,  ' +
                  '        TXT_UNIT_INFO, TOTAL_PAGES           ' +
                  ' From SCFAXIMG_TBL                           ' +
                  ' Where SND_DATE = ''' + pFaxSndFormat.sCurDate + ''' ' +
                  ' and TRADE_DATE = ''' + pReportInfo.sTradeDate + ''' ' +
                  ' and IDX_SEQ_NO = '   + IntToStr(iIdxSeqNo) );

          Try
            gf_ADOQueryOpen(ADOQuery_Main);
          Except
            on E : Exception do
            begin
              gf_RollbackTransaction;
              gvErrorNo := 9001; // DB오류
              gvExtMsg := E.Message;
              Exit;
            end;
          End;
          pReportInfo.sSecCode      := Trim(FieldByName('SEC_TYPE').asString);
          pReportInfo.sTradeDate    := Trim(FieldByName('TRADE_DATE').AsString);
          pReportInfo.sReportType   := Trim(FieldByName('REPORT_TYPE').asString);
          pReportInfo.sReportId     := Trim(FieldByName('REPORT_ID').asString);
          pReportInfo.sDirection    := Trim(FieldByName('DIRECTION').asString);
          pReportInfo.sLogoPageNo   := Trim(FieldByName('LOGO_PAGE_NO').asString);
          pReportInfo.sTxtUnitInfo  := Trim(FieldByName('TXT_UNIT_INFO').asString);
          pReportInfo.iTotalPageCnt := FieldByName('TOTAL_PAGES').asInteger;
        end;  // end of if
      end
      else  // 신규 Image 저장
      begin
        if not FileExists(pReportInfo.sFileName) then
        begin
          gf_RollbackTransaction;
          gvErrorNo := 1027; // 해당 파일이 존재하지 않습니다.
          gvExtMsg := '';
          Exit;
        end;

        //--- 채번 (IDX_SEQ_NO - SCFAXIMG_TBL에서 사용할 자료)
        with ADOSP_SP0103 do
        begin
          try
            Parameters.ParamByName('@in_date').Value := gvCurDate;
            Parameters.ParamByName('@in_dept_code').Value := gcDEPT_CODE_COMMON;
            Parameters.ParamByName('@in_sec_type').Value  := gcSEC_COMMONFAX;
            Parameters.ParamByName('@in_send_mtd').Value  := gcSND_MTD_IMG_IDX;
            Parameters.ParamByName('@in_biz_type').Value  := '01';
            Parameters.ParamByName('@in_get_flag').Value  := '2';
            Execute;
          except
            on E : Exception do
            begin
              gf_RollbackTransaction;
              gvErrorNo := 9002; // Stored Procedure 실행 오류
              gvExtMsg := E.Message;
              Exit;
            end;
          end;

          sTemp := Parameters.ParamByName('@out_rtc').Value;
          if sTemp <> '0000' then
          begin
            gf_RollbackTransaction;
            gvErrorNo := 9002; // Stored Procedure 실행 오류
            gvExtMsg := Trim(Parameters.ParamByName('@out_kor_msg').Value);
            Exit;
          end;
          iIdxSeqNo := Parameters.ParamByName('@out_snd_no').Value;
        end;  // end of with

        //------------------------------------------------------------------------
        // INSERT TABLE: SCFAXIMG_TBL & EXTERNAL INFORMATION TABLE
        //------------------------------------------------------------------------
        with ADOCommand_Main do
        begin
           CommandType := cmdText;

           //--- SCFAXIMG_TBL INSERT
           CommandText :=
                  'INSERT SCFAXIMG_TBL                           ' +
                  '(SND_DATE,     DEPT_CODE,      IDX_SEQ_NO,    ' +
                  ' SEC_TYPE,     REPORT_TYPE,    REPORT_ID,     ' +
                  ' DIRECTION,    LOGO_PAGE_NO,   TXT_UNIT_INFO, ' +
                  ' TOTAL_PAGES,  MAIN_DATA,      TRADE_DATE,    ' +
                  ' FILE_TYPE) ' +
                  'VALUES                                        ' +
                  '(:pSndDate,     :pDeptCode,    :pIdxSeqNo,    ' +
                  ' :pSecType,     :pReportType,  :pReportID,    ' +
                  ' :pDirection,   :pLogoPageNo,  :pTxtUnitInfo, ' +
                  ' :pTotalPages,  :pMainData,    :pTradeDate,   ' +
                  ' :pFileType)  ';
           Try
             Parameters.ParamByName('pSndDate').Value     := pFaxSndFormat.sCurDate;
             Parameters.ParamByName('pDeptCode').Value    := gvDeptCode;
             Parameters.ParamByName('pIdxSeqNo').Value    := iIdxSeqNo;
             Parameters.ParamByName('pSecType').Value     := pReportInfo.sSecCode;
             Parameters.ParamByName('pReportType').Value  := pReportInfo.sReportType;
             Parameters.ParamByName('pReportID').Value    := pReportInfo.sReportId;
             Parameters.ParamByName('pDirection').Value   := pReportInfo.sDirection;
             Parameters.ParamByName('pLogoPageNo').Value  := pReportInfo.sLogoPageNo;
             Parameters.ParamByName('pTxtUnitInfo').Value := pReportInfo.sTxtUnitInfo;
             Parameters.ParamByName('pTotalPages').Value  := pReportInfo.iTotalPageCnt;
             Parameters.ParamByName('pMainData').LoadFromFile(pReportInfo.sFileName,ftBlob);
             Parameters.ParamByName('pTradeDate').Value   := pReportInfo.sTradeDate;
             if (gvPDFEngineUseYn <> 'Y') then
               Parameters.ParamByName('pFileType').Value := gcFILE_TYPE_RPT
             else
               Parameters.ParamByName('pFileType').Value := gcFILE_TYPE_PDF;
             Execute;
           Except
             on E : Exception do
             begin
               gf_RollbackTransaction;
               gvErrorNo := 9001; // DB오류
               gvExtMsg := E.Message;
               Exit;
             end;
           End;

           //--- EXTERNAL INFORMATION: SCFAXACT_TBL INSERT
           if pReportInfo.iExtFlag = 1 then
           begin
             pTmpTBACTrade := pTBACTrade(pReportInfo.tExtInfo);

             CommandText :=
                     'INSERT SCFAXACT_TBL                              ' +
                     '  (SND_DATE,      DEPT_CODE,   IDX_SEQ_NO,       ' +
                     '   ACC_NO,        SUB_ACC_NO,  BUY_EXEC_AMT,     ' +
                     '   SELL_EXEC_AMT, BUY_COMM,    SELL_COMM,        ' +
                     '   TOT_TAX,       NET_AMT)                       ' +
                     'VALUES                                           ' +
                     '  (:pSndDate,     :pDeptCode,  :pIdxSeqNo,       ' +
                     '   :pAccNo,       :pSubAccNo,  :pBuyExecAmt,     ' +
                     '   :pSellExecAmt, :pBuyComm,   :pSellComm,       ' +
                     '   :pTotTax,      :pNetAmt)                      ';
             Parameters.ParamByName('pSndDate').Value     := Trim(pFaxSndFormat.sCurDate);
             Parameters.ParamByName('pDeptCode').Value    := gvDeptCode;
             Parameters.ParamByName('pIdxSeqNo').Value    := iIdxSeqNo;
             Parameters.ParamByName('pAccNo').Value       := Trim(pTmpTBACTrade.sAccNo);
             Parameters.ParamByName('pSubAccNo').Value    := Trim(pTmpTBACTrade.sSubAccNo);
             Parameters.ParamByName('pBuyExecAmt').Value  := pTmpTBACTrade.dBuyExecAmt;
             Parameters.ParamByName('pSellExecAmt').Value := pTmpTBACTrade.dSellExecAmt;
             Parameters.ParamByName('pBuyComm').Value     := pTmpTBACTrade.dBuyComm;
             Parameters.ParamByName('pSellComm').Value    := pTmpTBACTrade.dSellComm;
             Parameters.ParamByName('pTotTax').Value      := pTmpTBACTrade.dTotTax;
             Parameters.ParamByName('pNetAmt').Value      := pTmpTBACTrade.dNetAmt;
             Try
               Execute;
             Except
               on E : Exception do
               begin
                 gf_RollbackTransaction;
                 gvErrorNo := 9001; // DB오류
                 gvExtMsg := E.Message;
                 Exit;
               end;
             End; // end Except
           end

           //--- EXTERNAL INFORMATION: SCFAXGPT_TBL INSERT
           else if pReportInfo.iExtFlag = 2 then
           begin
             pTmpTBGPTrade := pTBGPTrade(pReportInfo.tExtInfo);
             CommandText :=
                     'INSERT SCFAXGPT_TBL                              ' +
                     '  (SND_DATE,      DEPT_CODE,   IDX_SEQ_NO,       ' +
                     '   SEC_TYPE,      GRP_NAME,    BUY_EXEC_AMT,     ' +
                     '   SELL_EXEC_AMT, BUY_COMM,    SELL_COMM,        ' +
                     '   TOT_TAX,       NET_AMT,     PGMAC_YN,         ' +
                     '   ACC_ATTR)                                     ' +
                     'VALUES                                           ' +
                     '  (:pSndDate,     :pDeptCode,  :pIdxSeqNo,       ' +
                     '   :pSecType,     :pGrpName,   :pBuyExecAmt,     ' +
                     '   :pSellExecAmt, :pBuyComm,   :pSellComm,       ' +
                     '   :pTotTax,      :pNetAmt,    :pPgmAcYn,        ' +
                     '   :pAccAttr)                                    ';
             Parameters.ParamByName('pSndDate').Value     := Trim(pFaxSndFormat.sCurDate);
             Parameters.ParamByName('pDeptCode').Value    := gvDeptCode;
             Parameters.ParamByName('pIdxSeqNo').Value    := iIdxSeqNo;
             Parameters.ParamByName('pSecType').Value     := Trim(pTmpTBGPTrade.sSecCode);
             Parameters.ParamByName('pGrpName').Value     := Trim(pTmpTBGPTrade.sGrpName);
             Parameters.ParamByName('pBuyExecAmt').Value  := pTmpTBGPTrade.dBuyExecAmt;
             Parameters.ParamByName('pSellExecAmt').Value := pTmpTBGPTrade.dSellExecAmt;
             Parameters.ParamByName('pBuyComm').Value     := pTmpTBGPTrade.dBuyComm;
             Parameters.ParamByName('pSellComm').Value    := pTmpTBGPTrade.dSellComm;
             Parameters.ParamByName('pTotTax').Value      := pTmpTBGPTrade.dTotTax;
             Parameters.ParamByName('pNetAmt').Value      := pTmpTBGPTrade.dNetAmt;
             Parameters.ParamByName('pPgmAcYn').Value     := pTmpTBGPTrade.sPgmAccYn;
             Parameters.ParamByName('pAccAttr').Value     := pTmpTBGPTrade.sAccAttr;
             Try
               Execute;
             Except
               on E : Exception do
               begin
                 gf_RollbackTransaction;
                 gvErrorNo := 9001; // DB오류
                 gvExtMsg := E.Message;
                 Exit;
               end;
             End; // end Except
           end

           //--- EXTERNAL INFORMATION: SCFAXACN_TBL INSERT
           else if pReportInfo.iExtFlag = 3 then
           begin
             pTmpTBACNormal := pTBACNormal(pReportInfo.tExtInfo);

             CommandText :=
                  'INSERT SCFAXACN_TBL                                 ' +
                  '  (SND_DATE,   DEPT_CODE,    IDX_SEQ_NO,            ' +
                  '   ACC_NO,     SUB_ACC_NO,   AMT1,          AMT2)   ' +
                  'VALUES                                              ' +
                  '  (:pSndDate,  :pDeptCode,   :pIdxSeqNo,            ' +
                  '   :pAccNo,    :pSubAccNo,   :pAmt1,        :pAmt2) ';
             Parameters.ParamByName('pSndDate').Value     := Trim(pFaxSndFormat.sCurDate);
             Parameters.ParamByName('pDeptCode').Value    := gvDeptCode;
             Parameters.ParamByName('pIdxSeqNo').Value    := iIdxSeqNo;
             Parameters.ParamByName('pAccNo').Value       := Trim(pTmpTBACNormal.sAccNo);
             Parameters.ParamByName('pSubAccNo').Value    := Trim(pTmpTBACNormal.sSubAccNo);
             Parameters.ParamByName('pAmt1').Value        := pTmpTBACNormal.dAmt1;
             Parameters.ParamByName('pAmt2').Value        := pTmpTBACNormal.dAmt2;
             Try
               Execute;
             Except
               on E : Exception do
               begin
                 gf_RollbackTransaction;
                 gvErrorNo := 9001; // DB오류
                 gvExtMsg := E.Message;
                 Exit;
               end;
             End; // end Except
           end

           //--- EXTERNAL INFORMATION: SCFAXGPN_TBL INSERT
           else if pReportInfo.iExtFlag = 4 then
           begin
             pTmpTBGPNormal := pTBGPNormal(pReportInfo.tExtInfo);
             CommandText :=
                  'INSERT SCFAXGPN_TBL                                 ' +
                  '  (SND_DATE,   DEPT_CODE,    IDX_SEQ_NO,            ' +
                  '   SEC_TYPE,   GRP_NAME,     AMT1,          AMT2)   ' +
                  'VALUES                                              ' +
                  '  (:pSndDate,  :pDeptCode,   :pIdxSeqNo,            ' +
                  '   :pSecType,  :pGrpName,    :pAmt1,        :pAmt2) ';
             Parameters.ParamByName('pSndDate').Value     := Trim(pFaxSndFormat.sCurDate);
             Parameters.ParamByName('pDeptCode').Value    := gvDeptCode;
             Parameters.ParamByName('pIdxSeqNo').Value    := iIdxSeqNo;
             Parameters.ParamByName('pSecType').Value     := Trim(pTmpTBGPNormal.sSecCode);
             Parameters.ParamByName('pGrpName').Value     := Trim(pTmpTBGPNormal.sGrpName);
             Parameters.ParamByName('pAmt1').Value        := pTmpTBGPNormal.dAmt1;
             Parameters.ParamByName('pAmt2').Value        := pTmpTBGPNormal.dAmt2;
             Try
               Execute;
             Except
               on E : Exception do
               begin
                 gf_RollbackTransaction;
                 gvErrorNo := 9001; // DB오류
                 gvExtMsg := E.Message;
                 Exit;
               end;
             End; // end Except
           end;
        end; // end of with
      end;  // end of else

      //--- 채번 (CUR_TOT_SEQ_NO : SCFAXSND_TBL에서 사용할 자료)
      with ADOSP_SP0103 do
      begin
        Try
          Parameters.ParamByName('@in_date').Value := gvCurDate;
          Parameters.ParamByName('@in_dept_code').Value := gcDEPT_CODE_COMMON;
          Parameters.ParamByName('@in_sec_type').Value := gcSEC_COMMONFAX;
          Parameters.ParamByName('@in_send_mtd').Value := gcSND_MTD_FAX;
          Parameters.ParamByName('@in_biz_type').Value := '01';
          Parameters.ParamByName('@in_get_flag').Value := '2';
          Execute;
        Except
          on E : Exception do
          begin
            gf_RollbackTransaction;
            gvErrorNo := 9002; // Stored Procedure 실행 오류
            gvExtMsg := E.Message;
            Exit;
          end;
        end;

        sTemp := Parameters.ParamByName('@out_rtc').Value;
        if sTemp <> '0000' then
        begin
          gf_RollbackTransaction;
          gvErrorNo := 9002; // Stored Procedure 실행 오류
          gvExtMsg := Trim(Parameters.ParamByName('@out_kor_msg').Value);
          Exit;
        end;
        iCurTotSeqNo := Parameters.ParamByName('@out_snd_no').Value;
      end;  // end of with

      with ADOCommand_Main do
      begin
        CommandType := cmdText;

        StartTime := gf_GetCurTime;

        //--- SCFAXSND_TBL INSERT
        CommandText :=
                'INSERT SCFAXSND_TBL                            ' +
                '( SND_DATE,       DEPT_CODE,  CUR_TOT_SEQ_NO,  ' +
                '  SND_TOT_SEQ_NO, IDX_SEQ_NO, STRT_TIME,       ' +
                '  FROM_PARTY_ID,  MEDIA_NO,   INTTEL_YN,       ' +
                '  FAX_TLX_GBN,    NAT_CODE,   RCV_COMP_KOR,    ' +
                '  SEND_PAGE,      RSP_FLAG,   SEND_TIME,       ' +
                '  SENT_TIME,      DIFF_TIME,  BUSY_RESND_CNT,  ' +
                '  RESND_CNT,      ERR_CODE,   EXT_MSG,         ' +
                '  OPR_ID,         OPR_TIME,   TRADE_DATE)      ' +
                'VALUES                                         ' +
                '( :pSndDate,      :pDeptCode, :pCurTotSeqNo,   ' +
                '  :pSndTotSeqNo,  :pIdxSeqNo, :pStrpTime,      ' +
                '  :pFromPartyId,  :pMediaNo,  :pIntTelYn,      ' +
                '  :pFaxTlxGbn,    :pNatCode,  :pRcvCompKor,    ' +
                '  :pSendPage,     :pRspFlag,  :pSendTime,      ' +
                '  :pSentTime,     :pDiffTime, :pBusyResndCnt,  ' +
                '  :pResndCnt,     :pErrCode,  :pExtMsg,        ' +
                '  :pOprId,        :pOprTime,  :pTradeDate )    ';
        Parameters.ParamByName('pSndDate').Value     := Trim(pFaxSndFormat.sCurDate);
        Parameters.ParamByName('pDeptCode').Value    := gvDeptCode;
        Parameters.ParamByName('pCurTotSeqNo').Value := iCurTotSeqNo;
        Parameters.ParamByName('pSndTotSeqNo').Value := iSndTotSeqNo;
        Parameters.ParamByName('pIdxSeqNo').Value    := iIdxSeqNo;
        Parameters.ParamByName('pStrpTime').Value    := StartTime;
        Parameters.ParamByName('pFromPartyId').Value := pFaxSndFormat.sFromPartyID;
        Parameters.ParamByName('pMediaNo').Value     := Trim(pFaxSndFormat.sMediaNo);
        Parameters.ParamByName('pIntTelYn').Value    := Trim(pFaxSndFormat.sIntTelYn);
        Parameters.ParamByName('pFaxTlxGbn').Value   := Trim(pFaxSndFormat.sFaxTlxGbn);
        Parameters.ParamByName('pNatCode').Value     := Trim(pFaxSndFormat.sNatCode);
        Parameters.ParamByName('pRcvCompKor').Value  := Trim(pFaxSndFormat.sRcvCompKor);
        Parameters.ParamByName('pSendPage').Value    := 0;
        Parameters.ParamByName('pRspFlag').Value     := gcFAXTLX_RSPF_WAIT;
        Parameters.ParamByName('pSendTime').Value    := '';
        Parameters.ParamByName('pSentTime').Value    := '';
        Parameters.ParamByName('pDiffTime').Value    := 0;
        Parameters.ParamByName('pBusyResndCnt').Value:= 0;
        Parameters.ParamByName('pResndCnt').Value    := 0;
        Parameters.ParamByName('pErrCode').Value     := '';
        Parameters.ParamByName('pExtMsg').Value      := '';
        Parameters.ParamByName('pOprId').Value       := gvOprUsrNo;
        Parameters.ParamByName('pTradeDate').Value   := pReportInfo.sTradeDate;
        Try
          Parameters.ParamByName('pOprTime').Value   := gf_GetCurTime;
          Execute;
        Except
          on E : Exception do
          begin
            gf_RollbackTransaction;
            gvErrorNo := 9001; // DB오류
            gvExtMsg := E.Message;
            Exit;
          end;
        end; // end Except
      end; //end ADOQuery_Main

      //--- Return 변수
      pReportInfo.iCurTotSeqNo := iCurTotSeqNo;
      pReportInfo.iIdxSeqNo    := iIdxSeqNo;
    end;  // end of for

    //--------------------
    gf_CommitTransaction;
    //--------------------
  end;  // end of with

  //----------------------------------------------------------------------------
  // FAX SEND Request Send
  //----------------------------------------------------------------------------
  fnCharSet(@clisvrhead, ' ', sizeof(CliSvrHead_R));
  MoveDataChar(clisvrhead.TrGbn, gcSTYPE_FAX, SizeOf(clisvrhead.TrGbn));
  MoveDataChar(clisvrhead.TrCode, '', SizeOf(clisvrhead.TrCode));
  MoveDataChar(clisvrhead.TermNo, gvTermNo, sizeof(clisvrhead.TermNo));
  MoveDataChar(clisvrhead.LoginID, gvOprUsrNo, Sizeof(clisvrhead.LoginID));
  MoveDataChar(clisvrhead.WinHandle,'',sizeof(clisvrhead.WinHandle));

  CharCharCpy(cpSbuff,@clisvrhead,sizeof(CliSvrHead_R));
  iSlen := sizeof(CliSvrHead_R);

  // FAX자료 전송 Request Send
  if fnServerSendData(iSlen, cpSbuff) < 0 then
  begin
{
   gf_Log('Fax전송 Error -> fnServerSendData');
   Result := False;
   Exit;
}
  end;

  Result := True;
end;

//=======================================================================
// 한투 금상 FAX Data Send Function : L.J.S
//=======================================================================
function fnFAXDataSend_TFFI(pFaxSndFormat : pFAXTLXSendFormat;
                       tReportList : TList; var StartTime : String) : Boolean;
var
  cpSbuff : array [0..gcMAX_COMM_BUFF_SIZE] of char;
  iSlen   : Integer;
  CliSvrHead : CliSvrHead_R;
  sTemp    : String;
  iIndex   : Integer;
  iSndTotSeqNo, iCurTotSeqNo, iIdxSeqNo : Integer;
  pReportInfo    : pTReportList;
  pTmpTBACTrade  : pTBACTrade;
  pTmpTBGPTrade  : pTBGPTrade;
  pTmpTBACNormal : pTBACNormal;
  pTmpTBGPNormal : pTBGPNormal;
begin
  Result := False;

  if tReportList.Count <= 0 then
  begin
    gvErrorNo := 9005; // 데이터 오류
    gvExtMsg := 'Report 정보 없음';
    Exit;
  end;

  with DataModule_SettleNet do
  begin
    //--------------------
    gf_BeginTransaction;
    //--------------------

    //--- 채번 (SND_SEQ_NO: 동시 전송 Group 처리)
    with ADOSP_SP0103 do
    begin
      try
        Parameters.ParamByName('@in_date').Value := gvCurDate;
        Parameters.ParamByName('@in_dept_code').Value := gcDEPT_CODE_COMMON;
        Parameters.ParamByName('@in_sec_type').Value  := gcSEC_COMMONFAX;
        Parameters.ParamByName('@in_send_mtd').Value  := gcSND_MTD_FAX_IDX;
        Parameters.ParamByName('@in_biz_type').Value  := '01';
        Parameters.ParamByName('@in_get_flag').Value  := '2';
        Execute;
      except
        on E : Exception do
        begin
          gf_RollbackTransaction;
          gvErrorNo := 9002; // Stored Procedure 실행 오류
          gvExtMsg := E.Message;
          Exit;
        end;
      end;

      sTemp := Parameters.ParamByName('@out_rtc').Value;
      if sTemp <> '0000' then
      begin
        gf_RollbackTransaction;
        gvErrorNo := 9002; // Stored Procedure 실행 오류
        gvExtMsg := Trim(Parameters.ParamByName('@out_kor_msg').Value);
        Exit;
      end;
      iSndTotSeqNo := Parameters.ParamByName('@out_snd_no').Value;
    end;  // end of with

    for iIndex := 0 to tReportList.Count -1 do
    begin
      pReportInfo := tReportList.Items[iIndex];

      if pReportInfo.iIdxSeqNo > 0 then  // 이전에 저장된 Image
      begin
        iIdxSeqNo := pReportInfo.iIdxSeqNo;

        // 해당 Image Index에 대한 Report 관련 정보를 다시 넘겨줌 (송수신 Mgr에서 편하게 처리하기 위해)
        with ADOQuery_Main do
        begin
          Close;
          SQL.Clear;
          SQL.Add(' Select SEC_TYPE, TRADE_DATE, REPORT_TYPE,   ' +
                  '        REPORT_ID, DIRECTION, LOGO_PAGE_NO,  ' +
                  '        TXT_UNIT_INFO, TOTAL_PAGES           ' +
                  ' From SCFAXIMG_TBL                           ' +
                  ' Where SND_DATE = ''' + pFaxSndFormat.sCurDate + ''' ' +
                  ' and TRADE_DATE = ''' + pReportInfo.sTradeDate + ''' ' +
                  ' and IDX_SEQ_NO = '   + IntToStr(iIdxSeqNo) );

          Try
            gf_ADOQueryOpen(ADOQuery_Main);
          Except
            on E : Exception do
            begin
              gf_RollbackTransaction;
              gvErrorNo := 9001; // DB오류
              gvExtMsg := E.Message;
              Exit;
            end;
          End;
          pReportInfo.sSecCode      := Trim(FieldByName('SEC_TYPE').asString);
          pReportInfo.sTradeDate    := Trim(FieldByName('TRADE_DATE').AsString);
          pReportInfo.sReportType   := Trim(FieldByName('REPORT_TYPE').asString);
          pReportInfo.sReportId     := Trim(FieldByName('REPORT_ID').asString);
          pReportInfo.sDirection    := Trim(FieldByName('DIRECTION').asString);
          pReportInfo.sLogoPageNo   := Trim(FieldByName('LOGO_PAGE_NO').asString);
          pReportInfo.sTxtUnitInfo  := Trim(FieldByName('TXT_UNIT_INFO').asString);
          pReportInfo.iTotalPageCnt := FieldByName('TOTAL_PAGES').asInteger;
        end;  // end of if
      end
      else  // 신규 Image 저장
      begin
        if not FileExists(pReportInfo.sFileName) then
        begin
          gf_RollbackTransaction;
          gvErrorNo := 1027; // 해당 파일이 존재하지 않습니다.
          gvExtMsg := '';
          Exit;
        end;

        //--- 채번 (IDX_SEQ_NO - SCFAXIMG_TBL에서 사용할 자료)
        with ADOSP_SP0103 do
        begin
          try
            Parameters.ParamByName('@in_date').Value := gvCurDate;
            Parameters.ParamByName('@in_dept_code').Value := gcDEPT_CODE_COMMON;
            Parameters.ParamByName('@in_sec_type').Value  := gcSEC_COMMONFAX;
            Parameters.ParamByName('@in_send_mtd').Value  := gcSND_MTD_IMG_IDX;
            Parameters.ParamByName('@in_biz_type').Value  := '01';
            Parameters.ParamByName('@in_get_flag').Value  := '2';
            Execute;
          except
            on E : Exception do
            begin
              gf_RollbackTransaction;
              gvErrorNo := 9002; // Stored Procedure 실행 오류
              gvExtMsg := E.Message;
              Exit;
            end;
          end;

          sTemp := Parameters.ParamByName('@out_rtc').Value;
          if sTemp <> '0000' then
          begin
            gf_RollbackTransaction;
            gvErrorNo := 9002; // Stored Procedure 실행 오류
            gvExtMsg := Trim(Parameters.ParamByName('@out_kor_msg').Value);
            Exit;
          end;
          iIdxSeqNo := Parameters.ParamByName('@out_snd_no').Value;
        end;  // end of with

        //------------------------------------------------------------------------
        // INSERT TABLE: SCFAXIMG_TBL & EXTERNAL INFORMATION TABLE
        //------------------------------------------------------------------------
        with ADOCommand_Main do
        begin
          CommandType := cmdText;

          //--- SCFAXIMG_TBL INSERT
          CommandText :=
                 'INSERT SCFAXIMG_TBL                           ' +
                 '(SND_DATE,     DEPT_CODE,      IDX_SEQ_NO,    ' +
                 ' SEC_TYPE,     REPORT_TYPE,    REPORT_ID,     ' +
                 ' DIRECTION,    LOGO_PAGE_NO,   TXT_UNIT_INFO, ' +
                 ' TOTAL_PAGES,  MAIN_DATA,      TRADE_DATE,    ' +
                 ' FILE_TYPE) ' +
                 'VALUES                                        ' +
                 '(:pSndDate,     :pDeptCode,    :pIdxSeqNo,    ' +
                 ' :pSecType,     :pReportType,  :pReportID,    ' +
                 ' :pDirection,   :pLogoPageNo,  :pTxtUnitInfo, ' +
                 ' :pTotalPages,  :pMainData,    :pTradeDate,   ' +
                 ' :pFileType)  ';
          Try
            Parameters.ParamByName('pSndDate').Value     := pFaxSndFormat.sCurDate;
            Parameters.ParamByName('pDeptCode').Value    := gvDeptCode;
            Parameters.ParamByName('pIdxSeqNo').Value    := iIdxSeqNo;
            Parameters.ParamByName('pSecType').Value     := pReportInfo.sSecCode;
            Parameters.ParamByName('pReportType').Value  := pReportInfo.sReportType;
            Parameters.ParamByName('pReportID').Value    := pReportInfo.sReportId;
            Parameters.ParamByName('pDirection').Value   := pReportInfo.sDirection;
            Parameters.ParamByName('pLogoPageNo').Value  := pReportInfo.sLogoPageNo;
            Parameters.ParamByName('pTxtUnitInfo').Value := pReportInfo.sTxtUnitInfo;
            Parameters.ParamByName('pTotalPages').Value  := pReportInfo.iTotalPageCnt;
            Parameters.ParamByName('pMainData').LoadFromFile(pReportInfo.sFileName,ftBlob);
            Parameters.ParamByName('pTradeDate').Value   := pReportInfo.sTradeDate;
            if (gvPDFEngineUseYn <> 'Y') then
              Parameters.ParamByName('pFileType').Value := gcFILE_TYPE_RPT
            else
              Parameters.ParamByName('pFileType').Value := gcFILE_TYPE_PDF;
            Execute;
          Except
            on E : Exception do
            begin
              gf_RollbackTransaction;
              gvErrorNo := 9001; // DB오류
              gvExtMsg := E.Message;
              Exit;
            end;
          End;
        end; // end of with
      end;  // end of else

      //--- 채번 (CUR_TOT_SEQ_NO : SCFAXSND_TBL에서 사용할 자료)
      with ADOSP_SP0103 do
      begin
        Try
          Parameters.ParamByName('@in_date').Value := gvCurDate;
          Parameters.ParamByName('@in_dept_code').Value := gcDEPT_CODE_COMMON;
          Parameters.ParamByName('@in_sec_type').Value := gcSEC_COMMONFAX;
          Parameters.ParamByName('@in_send_mtd').Value := gcSND_MTD_FAX;
          Parameters.ParamByName('@in_biz_type').Value := '01';
          Parameters.ParamByName('@in_get_flag').Value := '2';
          Execute;
        Except
          on E : Exception do
          begin
            gf_RollbackTransaction;
            gvErrorNo := 9002; // Stored Procedure 실행 오류
            gvExtMsg := E.Message;
            Exit;
          end;
        end;

        sTemp := Parameters.ParamByName('@out_rtc').Value;
        if sTemp <> '0000' then
        begin
          gf_RollbackTransaction;
          gvErrorNo := 9002; // Stored Procedure 실행 오류
          gvExtMsg := Trim(Parameters.ParamByName('@out_kor_msg').Value);
          Exit;
        end;
        iCurTotSeqNo := Parameters.ParamByName('@out_snd_no').Value;
      end;  // end of with

      with ADOCommand_Main do
      begin
        CommandType := cmdText;

        StartTime := gf_GetCurTime;

        //--- SCFAXSND_TBL INSERT
        CommandText :=
                'INSERT SCFAXSND_TBL                            ' +
                '( SND_DATE,       DEPT_CODE,  CUR_TOT_SEQ_NO,  ' +
                '  SND_TOT_SEQ_NO, IDX_SEQ_NO, STRT_TIME,       ' +
                '  FROM_PARTY_ID,  MEDIA_NO,   INTTEL_YN,       ' +
                '  FAX_TLX_GBN,    NAT_CODE,   RCV_COMP_KOR,    ' +
                '  SEND_PAGE,      RSP_FLAG,   SEND_TIME,       ' +
                '  SENT_TIME,      DIFF_TIME,  BUSY_RESND_CNT,  ' +
                '  RESND_CNT,      ERR_CODE,   EXT_MSG,         ' +
                '  OPR_ID,         OPR_TIME,   TRADE_DATE)      ' +
                'VALUES                                         ' +
                '( :pSndDate,      :pDeptCode, :pCurTotSeqNo,   ' +
                '  :pSndTotSeqNo,  :pIdxSeqNo, :pStrpTime,      ' +
                '  :pFromPartyId,  :pMediaNo,  :pIntTelYn,      ' +
                '  :pFaxTlxGbn,    :pNatCode,  :pRcvCompKor,    ' +
                '  :pSendPage,     :pRspFlag,  :pSendTime,      ' +
                '  :pSentTime,     :pDiffTime, :pBusyResndCnt,  ' +
                '  :pResndCnt,     :pErrCode,  :pExtMsg,        ' +
                '  :pOprId,        :pOprTime,  :pTradeDate )    ';
        Parameters.ParamByName('pSndDate').Value     := Trim(pFaxSndFormat.sCurDate);
        Parameters.ParamByName('pDeptCode').Value    := gvDeptCode;
        Parameters.ParamByName('pCurTotSeqNo').Value := iCurTotSeqNo;
        Parameters.ParamByName('pSndTotSeqNo').Value := iSndTotSeqNo;
        Parameters.ParamByName('pIdxSeqNo').Value    := iIdxSeqNo;
        Parameters.ParamByName('pStrpTime').Value    := StartTime;
        Parameters.ParamByName('pFromPartyId').Value := pFaxSndFormat.sFromPartyID;
        Parameters.ParamByName('pMediaNo').Value     := Trim(pFaxSndFormat.sMediaNo);
        Parameters.ParamByName('pIntTelYn').Value    := Trim(pFaxSndFormat.sIntTelYn);
        Parameters.ParamByName('pFaxTlxGbn').Value   := Trim(pFaxSndFormat.sFaxTlxGbn);
        Parameters.ParamByName('pNatCode').Value     := Trim(pFaxSndFormat.sNatCode);
        Parameters.ParamByName('pRcvCompKor').Value  := Trim(pFaxSndFormat.sRcvCompKor);
        Parameters.ParamByName('pSendPage').Value    := 0;
        Parameters.ParamByName('pRspFlag').Value     := gcFAXTLX_RSPF_WAIT;
        Parameters.ParamByName('pSendTime').Value    := '';
        Parameters.ParamByName('pSentTime').Value    := '';
        Parameters.ParamByName('pDiffTime').Value    := 0;
        Parameters.ParamByName('pBusyResndCnt').Value:= 0;
        Parameters.ParamByName('pResndCnt').Value    := 0;
        Parameters.ParamByName('pErrCode').Value     := '';
        Parameters.ParamByName('pExtMsg').Value      := '';
        Parameters.ParamByName('pOprId').Value       := gvOprUsrNo;
        Parameters.ParamByName('pTradeDate').Value   := pReportInfo.sTradeDate;
        Try
          Parameters.ParamByName('pOprTime').Value   := gf_GetCurTime;
          Execute;
        Except
          on E : Exception do
          begin
            gf_RollbackTransaction;
            gvErrorNo := 9001; // DB오류
            gvExtMsg := E.Message;
            Exit;
          end;
        end; // end Except
      end; //end ADOQuery_Main

      //--- Return 변수
      pReportInfo.iCurTotSeqNo := iCurTotSeqNo;
      pReportInfo.iIdxSeqNo    := iIdxSeqNo;
    end;  // end of for

    //--------------------
    gf_CommitTransaction;
    //--------------------
  end;  // end of with

  //----------------------------------------------------------------------------
  // FAX SEND Request Send
  //----------------------------------------------------------------------------
  fnCharSet(@clisvrhead, ' ', sizeof(CliSvrHead_R));
  MoveDataChar(clisvrhead.TrGbn, gcSTYPE_FAX, SizeOf(clisvrhead.TrGbn));
  MoveDataChar(clisvrhead.TrCode, '', SizeOf(clisvrhead.TrCode));
  MoveDataChar(clisvrhead.TermNo, gvTermNo, sizeof(clisvrhead.TermNo));
  MoveDataChar(clisvrhead.LoginID, gvOprUsrNo, Sizeof(clisvrhead.LoginID));
  MoveDataChar(clisvrhead.WinHandle,'',sizeof(clisvrhead.WinHandle));

  CharCharCpy(cpSbuff,@clisvrhead,sizeof(CliSvrHead_R));
  iSlen := sizeof(CliSvrHead_R);

  // FAX자료 전송 Request Send
  if fnServerSendData(iSlen, cpSbuff) < 0 then
  begin
{
   gf_Log('Fax전송 Error -> fnServerSendData');
   Result := False;
   Exit;
}
  end;

  Result := True;
end;

//=======================================================================
// Fax Data ReSend Function
//=======================================================================
function fnFAXDataReSend(iTotSeqNo : Integer) : Boolean;
var
  iResndCnt : Integer;
  sTime : String;
begin
  with DataModule_SettleNet do
  begin
    with ADOQuery_Main do
    begin
      //------------------------------------------------------------------------
      // Conversion Data 오류 Check
      //------------------------------------------------------------------------
      Close;
      SQL.Clear;
      SQL.Add('SELECT B.ERR_CODE,     B.EXT_MSG,      ' +
              '       B.RSP_FLAG,     A.RESND_CNT     ' +
              'FROM SCFAXSND_TBL A, SCFAXAPF_TBL B    ' +
              'WHERE A.SND_DATE = :pSndDate           ' +
              '  AND A.CUR_TOT_SEQ_NO = :pCurTotSeqNo ' +
              '  AND B.SND_DATE = A.SND_DATE          ' +
              '  AND B.IDX_SEQ_NO = A.IDX_SEQ_NO      ');
      try
        Parameters.ParamByName('pSndDate').Value     := gvCurDate;
        Parameters.ParamByName('pCurTotSeqNo').Value := iTotSeqNo;
        gf_ADOQueryOpen(ADOQuery_Main);
      except
        on E : Exception do
        begin
          gvErrorNo := 9001; // DB오류
          gvExtMsg := E.Message;
          Result := False;
          Exit;
        end;
      end; // end Except

      if RecordCount <> 1 then
      begin
        gvErrorNo  := 1025; //해당자료 없음
        gvExtMsg := '';
        Result := False;
        Exit;
      end;

      if (FieldByName('RSP_FLAG').asInteger <> gcFAXTLX_RSPF_FIN) or
         (Trim(FieldByName('ERR_CODE').asString) <> '') then
      begin
        gvErrorNo:= 9005; //데이터 오류
        gvExtMsg := '재전송불가 : ' + Trim(FieldByName('EXT_MSG').asString);
        Result := False;
        Exit;
      end;
      iResndCnt := FieldByName('RESND_CNT').asInteger;
    end; //end ADOQuery_Main
    //------------------------------------------------------------------------

    with ADOCommand_Main do
    begin
      sTime := gf_GetCurTime;
      CommandText :=
        ' UPDATE SCFAXSND_TBL                  ' +
        ' SET RSP_FLAG = :pRspFlag,            ' +
        '     SEND_PAGE = :pSendPage,          ' +
        '     SEND_TIME = :pSendTime,          ' +
        '     DIFF_TIME = :pDiffTime,          ' +
        '     BUSY_RESND_CNT = :pBusyResndCnt, ' +
        '     RESND_CNT = :pResndCnt,          ' +
        '     ERR_CODE = :pErrCode,            ' +
        '     EXT_MSG  = :pExtMsg,             ' +
        '     OPR_ID = :pOprId,                ' +
        '     OPR_TIME = ''' + sTime +     ''' ' +
        ' WHERE SND_DATE = :pSndDate           ' +
        '   AND CUR_TOT_SEQ_NO = :pCurTotSeqNo ';
      try
        Parameters.ParamByName('pRspFlag').Value      := gcFAXTLX_RSPF_WAIT;
        Parameters.ParamByName('pSendPage').Value     := 0;
        Parameters.ParamByName('pSendTime').Value     := '';
        Parameters.ParamByName('pDiffTime').Value     := 0;
        Parameters.ParamByName('pBusyResndCnt').Value := 0;
        Parameters.ParamByName('pResndCnt').Value     := iResndCnt + 1;
        Parameters.ParamByName('pErrCode').Value      := '';
        Parameters.ParamByName('pExtMsg').Value       := '';
        Parameters.ParamByName('pOprId').Value        := gvOprUsrNo;
        Parameters.ParamByName('pSndDate').Value      := gvCurDate;
        Parameters.ParamByName('pCurTotSeqNo').Value  := iTotSeqNo;
        Execute;
      except
        on E : Exception do
        begin
          gvErrorNo := 9001; // DB오류
          gvExtMsg := E.Message;
          Result := False;
          Exit;
        end;
      end; // end Except
    end; // end of ADOCommand_Main
  end; //end with DataModule_SettleNet
  Result := True;
end;

//=======================================================================
// Fax Data ReSend Function
//=======================================================================
function fnFAXDataReSend(iTotSeqNo : Integer; sOprTime : String) : Boolean;
var
  iResndCnt : Integer;
begin
  with DataModule_SettleNet do
  begin
    with ADOQuery_Main do
    begin
      //------------------------------------------------------------------------
      // Conversion Data 오류 Check
      //------------------------------------------------------------------------
      Close;
      SQL.Clear;
      SQL.Add('SELECT B.ERR_CODE,     B.EXT_MSG,      ' +
              '       B.RSP_FLAG,     A.RESND_CNT     ' +
              'FROM SCFAXSND_TBL A, SCFAXAPF_TBL B    ' +
              'WHERE A.SND_DATE = :pSndDate           ' +
              '  AND A.CUR_TOT_SEQ_NO = :pCurTotSeqNo ' +
              '  AND B.SND_DATE = A.SND_DATE          ' +
              '  AND B.IDX_SEQ_NO = A.IDX_SEQ_NO      ');
      try
        Parameters.ParamByName('pSndDate').Value     := gvCurDate;
        Parameters.ParamByName('pCurTotSeqNo').Value := iTotSeqNo;
        gf_ADOQueryOpen(ADOQuery_Main);
      except
        on E : Exception do
        begin
          gvErrorNo := 9001; // DB오류
          gvExtMsg := E.Message;
          Result := False;
          Exit;
        end;
      end; // end Except

      if RecordCount <> 1 then
      begin
        gvErrorNo  := 1025; //해당자료 없음
        gvExtMsg := '';
        Result := False;
        Exit;
      end;

      if (FieldByName('RSP_FLAG').asInteger <> gcFAXTLX_RSPF_FIN) or
         (Trim(FieldByName('ERR_CODE').asString) <> '') then
      begin
        gvErrorNo:= 9005; //데이터 오류
        gvExtMsg := '재전송불가 : ' + Trim(FieldByName('EXT_MSG').asString);
        Result := False;
        Exit;
      end;
      iResndCnt := FieldByName('RESND_CNT').asInteger;
    end;  // end of with ADOQuery_Main
    //------------------------------------------------------------------------

    with ADOCommand_Main do
    begin
      CommandText :=
        ' UPDATE SCFAXSND_TBL                  ' +
        ' SET RSP_FLAG = :pRspFlag,            ' +
        '     SEND_PAGE = :pSendPage,          ' +
        '     SEND_TIME = :pSendTime,          ' +
        '     DIFF_TIME = :pDiffTime,          ' +
        '     BUSY_RESND_CNT = :pBusyResndCnt, ' +
        '     RESND_CNT = :pResndCnt,          ' +
        '     ERR_CODE = :pErrCode,            ' +
        '     EXT_MSG  = :pExtMsg,             ' +
        '     OPR_ID = :pOprId,                ' +
        '     OPR_TIME = :pOprTime             ' +
        ' WHERE SND_DATE = :pSndDate           ' +
        '   AND CUR_TOT_SEQ_NO = :pCurTotSeqNo ';
      try
        Parameters.ParamByName('pRspFlag').Value      := gcFAXTLX_RSPF_WAIT;
        Parameters.ParamByName('pSendPage').Value     := 0;
        Parameters.ParamByName('pSendTime').Value     := '';
        Parameters.ParamByName('pDiffTime').Value     := 0;
        Parameters.ParamByName('pBusyResndCnt').Value := 0;
        Parameters.ParamByName('pResndCnt').Value     := iResndCnt + 1;
        Parameters.ParamByName('pErrCode').Value      := '';
        Parameters.ParamByName('pExtMsg').Value       := '';
        Parameters.ParamByName('pOprId').Value        := gvOprUsrNo;
        Parameters.ParamByName('pOprTime').Value      := sOprTime;
        Parameters.ParamByName('pSndDate').Value      := gvCurDate;
        Parameters.ParamByName('pCurTotSeqNo').Value  := iTotSeqNo;
        Execute;
      except
        on E : Exception do
        begin
          gvErrorNo := 9001; // DB오류
          gvExtMsg := E.Message;
          Result := False;
          Exit;
        end;
      end; // end Except
    end; // end of ADOCommand_Main
  end; //end with DataModule_SettleNet

  Result := True;
end;

//=======================================================================
// Fax Data Cancel Function : LMS Modify
//=======================================================================
function fnFAXDataCancel(iTotSeqNo , Tag : Integer; MessageBar: TDRMessageBar) : Boolean;
var
  cpSbuff : array [0..gcMAX_COMM_BUFF_SIZE] of char;
  iSlen, iSndTotSeqNo, iRSPFlag : Integer;
  CliSvrHead : CliSvrHead_R;
  sTime : String;
begin
  with DataModule_SettleNet do
  begin
    with ADOQuery_Main do
    begin
      // Fax 같은번호 묶음 처리된것 Cancel시 모두 Cancel
      Close;
      SQL.Clear;
      SQL.Add('SELECT COUNT(SND_TOT_SEQ_NO) AS SND_COUNT , MAX(SND_TOT_SEQ_NO) AS SND_TOT_SEQ_NO');
      SQL.Add(' ,MIN(RSP_FLAG) as RSP_FLAG                          ,  MAX(MEDIA_NO) AS MEDIA_NO');
      SQL.Add('FROM SCFAXSND_TBL                                                                 ');
      SQL.Add('WHERE SND_DATE = '''  + gvCurDate  + '''                                          ');
      SQL.Add('AND SND_TOT_SEQ_NO = (                                                            ');
      SQL.Add('    select SND_TOT_SEQ_NO                                                         ');
      SQL.Add('      From SCFAXSND_TBL                                                           ');
      SQL.Add('     WHERE SND_DATE = '''  + gvCurDate  + '''                                     ');
      SQL.Add('       AND CUR_TOT_SEQ_NO = ''' + inttostr(iTotSeqNo) + ''')                      ');
      try
        gf_ADOQueryOpen(ADOQuery_Main);
      except
        on E: Exception do
        begin
          gvErrorNo := 9001; // DB오류
          gvExtMsg := E.Message;
          Result := False;
          Exit;
        end;
      end; // end Except


      // 2개 이상일땐 같은번호 같이 전송함.. 모두 취소
      if FieldByName('SND_COUNT').asInteger > 1 then
      begin

        //  같이 전송 처리 된 팩스의 Min(Flag)값이 Cancel Flag 같거나 크면 취소 불가 상태임
        //  gcFAXTLX_RSPF_SENT <-- // 한국통신까지 Send된 상태는 Flag가 8이지만
        //  위의 쿼리처리가 어렵고 전송완료로 판단 제외시킴.
        //  결론 - 한국통신까지 Send 상태인경우에는 취소 불가로 분류함
        if FieldByName('RSP_FLAG').asInteger >=  gcFAXTLX_RSPF_CANC then
        begin
          gvErrorNo := 1094; //취소가능상태아님
          gvExtMsg := '';
          Result := False;
          Exit;
        end;


        if gf_ShowDlgMessage(Tag, mtConfirmation, 0,
              '같은 팩스번호로 함께 전송중인 보고서가 있습니다.' + #13
            + '함께 전송중인 보고서는 모두 전송취소 됩니다.' + #13
            + '전송취소 하시겠습니까?'
          , mbOKCancel, 0) = idcancel then
        begin
          //gf_ShowMessage(MessageBar, mtInformation, 1082, '');  // 작업이 취소되었습니다.
          gvErrorNo := 1082; // 작업이 취소되었습니다.
          gvExtMsg := '';
          Result := False;
          Exit;
        end;

         with ADOCommand_Main do
         begin
           sTime := gf_GetCurTime;
          CommandText :=
            'UPDATE SCFAXSND_TBL                  ' +
            ' SET RSP_FLAG = :pRspFlag,           ' +
            '     OPR_ID   = :pOprId,             ' +
            '     OPR_TIME = ''' + sTime + '''    ' +
            'WHERE SND_DATE = :pSndDate           ' +
            '  AND SND_TOT_SEQ_NO = :pCurSndSeqNo ' +
            // 이미 전송된 보고서는 제외
            '  AND RSP_FLAG <> '  + inttostr(gcFAXTLX_RSPF_FIN);
          try
            Parameters.ParamByName('pSndDate').Value := gvCurDate;
            Parameters.ParamByName('pCurSndSeqNo').Value
                := ADOQuery_Main.FieldByName('SND_TOT_SEQ_NO').asInteger;

            Parameters.ParamByName('pRspFlag').Value := gcFAXTLX_RSPF_CANC;
            Parameters.ParamByName('pOprId').Value := gvOprUsrNo;
            Execute;
          except
            on E: Exception do
            begin
              gvErrorNo := 9001; // DB오류
              gvExtMsg := E.Message;
              Result := False;
              Exit;
            end;
          end; // end Except
        end;
        Result := True;
        Exit;
      end;

      Close;
      SQL.Clear;
      SQL.Add('SELECT SND_DATE,       DEPT_CODE,    ' +
              '       CUR_TOT_SEQ_NO, RSP_FLAG,     ' +
              '       FAX_TLX_GBN,    OPR_ID,       ' +
              '       SND_TOT_SEQ_NO                ' +
              'FROM SCFAXSND_TBL                    ' +
              'WHERE SND_DATE = :pSndDate           ' +
              '  AND CUR_TOT_SEQ_NO = :pCurTotSeqNo ');
      try
        Parameters.ParamByName('pSndDate').Value     := gvCurDate;
        Parameters.ParamByName('pCurTotSeqNo').Value := iTotSeqNo;
        gf_ADOQueryOpen(ADOQuery_Main);
      except
        on E : Exception do
        begin
          gvErrorNo := 9001; // DB오류
          gvExtMsg := E.Message;
          Result := False;
          Exit;
        end;
      end; // end Except

      if RecordCount <> 1 then
      begin
        gvErrorNo  := 1025; //해당자료 없음
        gvExtMsg := '';
        Result := False;
        Exit;
      end;

      if (FieldByName('RSP_FLAG').asInteger   = gcFAXTLX_RSPF_FIN) or
         (Trim(FieldByName('FAX_TLX_GBN').asString) = gcSEND_TLX) then
      begin
        gvErrorNo := 1094; //취소가능상태아님
        gvExtMsg := '';
        Result := False;
        Exit;
      end;

      iSndTotSeqNo := FieldByName('SND_TOT_SEQ_NO').asInteger;
      iRSPFlag     := FieldByName('RSP_FLAG').asInteger;
    end; //end ADOQuery_Main

    with ADOCommand_Main do
    begin
      //--- Sending중 Cancel
      {if iRSPFlag = gcFAXTLX_RSPF_SEND then
      begin
        sTime := gf_GetCurTime ;
        CommandText :=
                'UPDATE SCFAXSND_TBL                  ' +
                ' SET OPR_ID   = :pOprId,             ' +
                '     OPR_TIME = ''' + sTime + '''    ' +
                'WHERE SND_DATE = :pSndDate           ' +
                '  AND CUR_TOT_SEQ_NO = :pCurTotSeqNo ';
        try
          Parameters.ParamByName('pSndDate').Value     := gvCurDate;
          Parameters.ParamByName('pCurTotSeqNo').Value := iTotSeqNo;
          Parameters.ParamByName('pOprId').Value       := gvOprUsrNo;
          Execute;
        except
          // 업무와 상관없으므로 Pass
        end; // end Except
      end  // end of if

      //--- Wait Cancel
      else
      begin}
        sTime := gf_GetCurTime ;
        CommandText :=
                'UPDATE SCFAXSND_TBL                  ' +
                ' SET RSP_FLAG = :pRspFlag,           ' +
                '     OPR_ID   = :pOprId,             ' +
                '     OPR_TIME = ''' + sTime + '''    ' +
                'WHERE SND_DATE = :pSndDate           ' +
                '  AND CUR_TOT_SEQ_NO = :pCurTotSeqNo ';
        try
          Parameters.ParamByName('pSndDate').Value     := gvCurDate;
          Parameters.ParamByName('pCurTotSeqNo').Value := iTotSeqNo;
          Parameters.ParamByName('pRspFlag').Value     := gcFAXTLX_RSPF_CANC;
          Parameters.ParamByName('pOprId').Value       := gvOprUsrNo;
          Execute;
        except
          on E : Exception do
          begin
            gvErrorNo := 9001; // DB오류
            gvExtMsg := E.Message;
            Result := False;
            Exit;
          end;
        end; // end Except
      //end;
    end; // end With ADOCommand_Main

    //----------------------------------------------------------------------------
    // FAX Cancel Request Send
    //----------------------------------------------------------------------------
    {fnCharSet(@clisvrhead,' ',sizeof(CliSvrHead_R));
    MoveDataChar(clisvrhead.TrGbn,gcSTYPE_FXC,SizeOf(clisvrhead.TrGbn));
    MoveDataChar(clisvrhead.TrCode,'',SizeOf(clisvrhead.TrCode));
    MoveDataChar(clisvrhead.TermNo,gvTermNo,sizeof(clisvrhead.TermNo));
    MoveDataChar(clisvrhead.LoginID,gvOprUsrNo,Sizeof(clisvrhead.LoginID));
    MoveDataChar(clisvrhead.WinHandle,'',sizeof(clisvrhead.WinHandle));

    CharCharCpy(cpSbuff,@clisvrhead,sizeof(CliSvrHead_R));
    iSlen := sizeof(CliSvrHead_R);
    MoveDataChar(@cpSbuff[iSlen],IntToStr(iTotSeqNo),8);
    Inc(iSlen,8);
    MoveDataChar(@cpSbuff[iSlen],IntToStr(iSndTotSeqNo),8);
    Inc(iSlen,8);

    // FAX자료 전송 Request Send
    if fnServerSendData(iSlen,cpSbuff) < 0 then
    begin
      gvErrorNo := 9106; // SYSTEM 오류
      gvExtMsg := 'SYSTEM 오류(fnServerSendData)';
      Result := False;
      Exit;
    end;  }
    
    Result := True;
  end; //end with DataModule_SettleNet
end;

//=======================================================================
// EMail Data Send Function : LMS Modify
//=======================================================================
function fnEMailDataSend(pEMailFormat : pEMailSendFormat;
                         tEMailAttList: TList; var StartTime : String) : Boolean;
var
  cpSbuff : array [0..gcMAX_COMM_BUFF_SIZE] of char;
  iSlen   : Integer;
  CliSvrHead : CliSvrHead_R;
  sAttathPathFileName : String;
  sTemp    : String;
  iIndex   : Integer;
  pEMailAtt: pEMailSendAttach;
  iTotSeqNo: Integer;
  sAccNo, sSubAccNo : string;
begin
  gvErrorNo := 0;
  gvExtMsg  := '';

  if pEMailFormat.sRcvMailAddr[Length(pEMailFormat.sRcvMailAddr)] <> ';' then
  begin
    gvErrorNo := 9106; // SYSTEM 오류
    gvExtMsg := 'EMail(sRcvMailAddr) Address Format Error!!!';
    Result := False;
    Exit;
  end;

  if Length(Trim(pEMailFormat.sCCMailAddr)) > 0 then
  begin
    if pEMailFormat.sCCMailAddr[Length(pEMailFormat.sCCMailAddr)] <> ';' then
    begin
      gvErrorNo := 9106; // SYSTEM 오류
      gvExtMsg := 'EMail(sCCMailAddr) Address Format Error!!!';
      Result := False;
      Exit;
    end;
  end;

  if Length(Trim(pEMailFormat.sCCBlindAddr)) > 0 then
  begin
    if pEMailFormat.sCCBlindAddr[Length(pEMailFormat.sCCBlindAddr)] <> ';' then
    begin
      gvErrorNo := 9106; // SYSTEM 오류
      gvExtMsg := 'EMail(sCCBlindMailAddr) Address Format Error!!!';
      Result := False;
      Exit;
    end;
  end;

  gf_BeginTransaction;

  with DataModule_Settlenet do
  begin
    //채번(IDX_SEQ_NO - SCMELSND_TBL사용할자료)
    with ADOSP_SP0103 do
    begin
      try
        Parameters.ParamByName('@in_date').Value      := pEMailFormat.sCurDate;
        Parameters.ParamByName('@in_dept_code').Value := gcDEPT_CODE_COMMON;
        Parameters.ParamByName('@in_sec_type').Value  := gcSEC_COMMONFAX;
        Parameters.ParamByName('@in_send_mtd').Value  := gcSND_MTD_EMAIL;
        Parameters.ParamByName('@in_biz_type').Value  := '01';// 01 : 총송신번호
                                                              // 11 : 회차
                                                              // 21 : 송신한 번호
        Parameters.ParamByName('@in_get_flag').Value  := '2'; // '1' : Data Get
                                                              // '2' : 채번
                                                              // '9' : Write(@out_snd_no)
        Execute;
      except
        on E : Exception do
        begin
          gf_RollbackTransaction;
          gvErrorNo := 9002; // Stored Procedure 실행 오류
          gvExtMsg := E.Message;
          Result := False;
          Exit;
        end;
      end;

      sTemp := Parameters.ParamByName('@out_rtc').Value;
      if sTemp <> '0000' then
      begin
        gf_RollbackTransaction;
        gvErrorNo := 9002; // Stored Procedure 실행 오류
        gvExtMsg := Trim(Parameters.ParamByName('@out_kor_msg').Value);
        Result := False;
        Exit;
      end;
      iTotSeqNo := Parameters.ParamByName('@out_snd_no').Value;
    end;

    with ADOCommand_Main do
    begin
      StartTime := gf_GetCurTime;
      //----------------------------------------------------------------------
      // SCMELSND_TBL INSERT
      //----------------------------------------------------------------------
      CommandText :=
              'INSERT SCMELSND_TBL                                 ' +
              '(SND_DATE,        CUR_TOT_SEQ_NO,   DEPT_CODE,      ' +
              ' TRADE_DATE,      STRT_TIME,                        ' +
              ' RCV_MAIL_ADDR,   CC_MAIL_ADDR,     CC_BLIND_ADDR,  ' +
              ' RCV_MAIL_NAME,   CC_MAIL_NAME,     CC_BLIND_NAME,  ' +
              ' SND_USER_NAME,   RETURN_MAIL_ADDR, SUBJECT_DATA,   ' +
              ' MAIL_BODY_DATA,  RSP_FLAG,         SEND_TIME,      ' +
              ' SENT_TIME,       DIFF_TIME,        ERR_CODE,       ' +
              ' EXT_MSG,         OPR_ID,           OPR_TIME )      ' +
              'VALUES                                              ' +
              '(:pSndDate,       :pCurTotSeqNo,    :pDeptCode,     ' +
              ' :pTradeDate,     :pStrtTime,                       ' +
              ' :pRcvMailAddr,   :pCCMailAddr,     :pCCBlindAddr,  ' +
              ' :pRcvMailName,   :pCCMailName,     :pCCBlindName,  ' +
              ' :pSndUserName,   :pReturnMailAddr, :pSubjectData,  ' +
              ' :pMailBodyData,  :pRspFlag,        :pSendTime,     ' +
              ' :pSentTime,      :pDiffTime,       :pErrCode,      ' +
              ' :pExtMsg,        :pOprID,          :pOprTime )     ' ;
      try
        Parameters.ParamByName('pSndDate').Value        := pEMailFormat.sCurDate;
        Parameters.ParamByName('pCurTotSeqNo').Value    := iTotSeqNo;
        Parameters.ParamByName('pDeptCode').Value       := pEMailFormat.sDeptCode;
        Parameters.ParamByName('pTradeDate').Value      := pEMailFormat.sTradeDate;
        Parameters.ParamByName('pStrtTime').Value       := StartTime;
        Parameters.ParamByName('pRcvMailAddr').Value    := pEMailFormat.sRcvMailAddr;
        Parameters.ParamByName('pCCMailAddr').Value     := pEMailFormat.sCCMailAddr;
        Parameters.ParamByName('pCCBlindAddr').Value    := pEMailFormat.sCCBlindAddr;
        Parameters.ParamByName('pRcvMailName').Value    := pEMailFormat.sRcvMailName;
        Parameters.ParamByName('pCCMailName').Value     := pEMailFormat.sCCMailName;
        Parameters.ParamByName('pCCBlindName').Value    := pEMailFormat.sCCBlindName;
        Parameters.ParamByName('pSndUserName').Value    := pEMailFormat.sSndUserName;
        Parameters.ParamByName('pReturnMailAddr').Value := pEMailFormat.sReturnMailAddr;
        Parameters.ParamByName('pSubjectData').Value    := pEMailFormat.sSubjectData;
        Parameters.ParamByName('pMailBodyData').Value   := pEMailFormat.sMailBodyData;
        Parameters.ParamByName('pRspFlag').Value        := gcFAXTLX_RSPF_WAIT;
        Parameters.ParamByName('pSendTime').Value       := '';
        Parameters.ParamByName('pSentTime').Value       := '';
        Parameters.ParamByName('pDiffTime').Value       := 0;
        Parameters.ParamByName('pErrCode').Value        := '';
        Parameters.ParamByName('pExtMsg').Value         := '';
        Parameters.ParamByName('pOprID').Value          := pEMailFormat.sOprID;
        Parameters.ParamByName('pOprTime').Value        := pEMailFormat.sOprTime;
        Execute;
      except
        on E : Exception do
        begin
          gf_RollbackTransaction;
          gvErrorNo := 9001; // DB오류
          gvExtMsg := E.Message;
          Result := False;
          Exit;
        end;
      end; // end Except

      //----------------------------------------------------------------------
      // SCMELINF_TBL INSERT
      //----------------------------------------------------------------------
      CommandText :=
              'INSERT SCMELINF_TBL                                 ' +
              '(SND_DATE,        CUR_TOT_SEQ_NO,   MAILFORM_GRP, MAILFORM_ID)   ' +
              'VALUES                                              ' +
              '(:pSndDate,       :pCurTotSeqNo,    :pMailFormGrp, :pMailFormID)  '; //@@ 2004.11.01
      try
        Parameters.ParamByName('pSndDate').Value      := pEMailFormat.sCurDate;
        Parameters.ParamByName('pCurTotSeqNo').Value  := iTotSeqNo;
        Parameters.ParamByName('pMailFormGrp').Value  := pEMailFormat.sMailFormGrp;
        Parameters.ParamByName('pMailFormID').Value  := pEMailFormat.sMailFormID; //@@ 2004.11.01
        Execute;
      except
        on E : Exception do
        begin
          gf_RollbackTransaction;
          gvErrorNo := 9001; // DB오류
          gvExtMsg := E.Message;
          Result := False;
          Exit;
        end;
      end; // end Except
      
      //----------------------------------------------------------------------
      // SCMELATT_TBL INSERT
      //----------------------------------------------------------------------
      if (tEMailAttList <> Nil) and (tEMailAttList.Count >= 1) then
      begin
        for iIndex := 0 to tEMailAttList.Count - 1 do
        begin
          pEMailAtt := tEMailAttList[iIndex];

          sAttathPathFileName := pEMailAtt.sAttachFilePath + pEMailAtt.sAttachFileName;
          if not FileExists(sAttathPathFileName) then
          begin
            gf_RollbackTransaction;
            gvErrorNo := 1027; // 해당 파일이 존재하지 않습니다.
            gvExtMsg := 'Attach File Not Found : ' + sAttathPathFileName;
            Result := False;
            Exit;
          end;

          CommandText :=
                  'INSERT SCMELATT_TBL                               ' +
                  '(SND_DATE,        CUR_TOT_SEQ_NO,   ATT_SEQ_NO,   ' +
                  ' ATTACH_FILENAME, ATTACH_DATA)                    ' +
                  'VALUES                                            ' +
                  '(:pSndDate,       :pCurTotSeqNo,    :pAttSeqNo,   ' +
                  ' :pAttachFileName,:pAttachData)                   ';
          try
            Parameters.ParamByName('pSndDate').Value        := pEMailFormat.sCurDate;
            Parameters.ParamByName('pCurTotSeqNo').Value    := iTotSeqNo;
            Parameters.ParamByName('pAttSeqNo').Value       := iIndex+1;
            Parameters.ParamByName('pAttachFileName').Value := pEMailAtt.sAttachFileName;
            Parameters.ParamByName('pAttachData').LoadFromFile(sAttathPathFileName,ftBlob);
            Execute;
          except
            on E : Exception do
            begin
              gf_RollbackTransaction;
              gvErrorNo := 9001; // DB오류
              gvExtMsg := E.Message;
              Result := False;
              Exit;
            end;
          end; // end Except
        end; // end for
      end; // if tEMailAttList.Count >= 1

      //----------------------------------------------------------------------
      // SCMELAC_TBL Insert
      //----------------------------------------------------------------------
      if pEMailFormat.sAccGrpType = gcRGROUP_ACC then  //계좌단위
      begin
         for iIndex := 0 to pEMailFormat.sFmtAccNoList.Count -1 do
         begin
            gf_UnformatAccNo(pEMailFormat.sFmtAccNoList.Strings[iIndex],
                             sAccNo, sSubAccNo);
            CommandText :=
                    'INSERT SCMELAC_TBL                               ' +
                    '(SND_DATE,        CUR_TOT_SEQ_NO,    DEPT_CODE,  ' +
                    ' ACC_NO,          SUB_ACC_NO)                    ' +
                    'VALUES                                           ' +
                    '(:pSndDate,       :pCurTotSeqNo,     :DeptCode,  ' +
                    ' :pAccNo,         :pSubAccNo)                    ' ;
            try
              Parameters.ParamByName('pSndDate').Value      := pEMailFormat.sCurDate;
              Parameters.ParamByName('pCurTotSeqNo').Value  := iTotSeqNo;
              Parameters.ParamByName('DeptCode').Value      := pEMailFormat.sDeptCode;
              Parameters.ParamByName('pAccNo').Value        := sAccNo;
              Parameters.ParamByName('pSubAccNo').Value     := sSubAccNo;

              Execute;
            except
              on E : Exception do
              begin
                gf_RollbackTransaction;
                gvErrorNo := 9001; // DB오류
                gvExtMsg := E.Message;
                Result := False;
                Exit;
              end;
            end; // end Except
         end;  // end of for
      end;  // end of if

      //----------------------------------------------------------------------
      // SCMELGP_TBL Insert
      //----------------------------------------------------------------------
      if pEMailFormat.sAccGrpType = gcRGROUP_GRP then  // Group단위
      begin
         for iIndex := 0 to pEMailFormat.sFmtAccNoList.Count -1 do
         begin
            gf_UnformatAccNo(pEMailFormat.sFmtAccNoList.Strings[iIndex],
                             sAccNo, sSubAccNo);
            CommandText :=
                    'INSERT SCMELGP_TBL                               ' +
                    '(SND_DATE,        CUR_TOT_SEQ_NO,    DEPT_CODE,  ' +
                    ' SEC_TYPE,        GRP_NAME,                      ' +
                    ' ACC_NO,          SUB_ACC_NO)                    ' +
                    'VALUES                                           ' +
                    '(:pSndDate,       :pCurTotSeqNo,     :DeptCode,  ' +
                    ' :pSecType,       :pGrpName,                     ' +
                    ' :pAccNo,         :pSubAccNo)                    ' ;
            try
              Parameters.ParamByName('pSndDate').Value      := pEMailFormat.sCurDate;
              Parameters.ParamByName('pCurTotSeqNo').Value  := iTotSeqNo;
              Parameters.ParamByName('DeptCode').Value      := pEMailFormat.sDeptCode;
              Parameters.ParamByName('pSecType').Value      := pEMailFormat.sSecType;
              Parameters.ParamByName('pGrpName').Value      := pEMailFormat.sGrpName;
              Parameters.ParamByName('pAccNo').Value        := sAccNo;
              Parameters.ParamByName('pSubAccNo').Value     := sSubAccNo;

              Execute;
            except
              on E : Exception do
              begin
                gf_RollbackTransaction;
                gvErrorNo := 9001; // DB오류
                gvExtMsg := E.Message;
                Result := False;
                Exit;
              end;
            end; // end Except
         end;  // end of for
      end;  // end of if
    end; //end ADOCommand_Main
    //----------------------------------------------------------------------
  end; //end with DataModule_EFS
  gf_CommitTransaction;

  // Return 변수
  pEMailFormat.iCurTotSeqNo := iTotSeqNo;

  //----------------------------------------------------------------------------
  // EMAIL SEND Request Send
  //----------------------------------------------------------------------------
  fnCharSet(@clisvrhead,' ',sizeof(CliSvrHead_R));
  MoveDataChar(clisvrhead.TrGbn,gcSTYPE_MEL,SizeOf(clisvrhead.TrGbn));
  MoveDataChar(clisvrhead.TrCode,'',SizeOf(clisvrhead.TrCode));
  MoveDataChar(clisvrhead.TermNo,gvTermNo,sizeof(clisvrhead.TermNo));
  MoveDataChar(clisvrhead.LoginID,gvOprUsrNo,Sizeof(clisvrhead.LoginID));
  MoveDataChar(clisvrhead.WinHandle,'',sizeof(clisvrhead.WinHandle));

  CharCharCpy(cpSbuff,@clisvrhead,sizeof(CliSvrHead_R));
  iSlen := sizeof(CliSvrHead_R);

  // EMAIL자료 전송 Request Send
  if fnServerSendData(iSlen,cpSbuff) < 0 then
  begin
{
   gf_Log('Fax전송 Error -> fnServerSendData');
   Result := False;
   Exit;
}
  end;

  Result := True;
end;

//=======================================================================
// 한투 금상 EMail Data Send Function : L.J.S
//=======================================================================
function fnEMailDataSend_TFFI(pEMailFormat : pTSndMailData;
                              tEMailAttList: TList; var StartTime : String) : Boolean;
var
  cpSbuff : array [0..gcMAX_COMM_BUFF_SIZE] of char;
  iSlen   : Integer;
  CliSvrHead : CliSvrHead_R;
  sAttathPathFileName : String;
  sTemp    : String;
  iIndex   : Integer;
  pEMailAtt: pEMailSendAttach;
  iTotSeqNo: Integer;
  sAccNo, sSubAccNo : string;
begin
  gvErrorNo := 0;
  gvExtMsg  := '';

  if pEMailFormat.RcvMailAddr[Length(pEMailFormat.RcvMailAddr)] <> ';' then
  begin
    gvErrorNo := 9106; // SYSTEM 오류
    gvExtMsg := 'EMail(sRcvMailAddr) Address Format Error!!!';
    Result := False;
    Exit;
  end;

  gf_BeginTransaction;

  with DataModule_Settlenet do
  begin
    //채번(IDX_SEQ_NO - SCMELSND_TBL사용할자료)
    with ADOSP_SP0103 do
    begin
      try
        Parameters.ParamByName('@in_date').Value      := pEMailFormat.CurDate;
        Parameters.ParamByName('@in_dept_code').Value := gcDEPT_CODE_COMMON;
        Parameters.ParamByName('@in_sec_type').Value  := gcSEC_COMMONFAX;
        Parameters.ParamByName('@in_send_mtd').Value  := gcSND_MTD_EMAIL;
        Parameters.ParamByName('@in_biz_type').Value  := '01';// 01 : 총송신번호
                                                              // 11 : 회차
                                                              // 21 : 송신한 번호
        Parameters.ParamByName('@in_get_flag').Value  := '2'; // '1' : Data Get
                                                              // '2' : 채번
                                                              // '9' : Write(@out_snd_no)
        Execute;
      except
        on E : Exception do
        begin
          gf_RollbackTransaction;
          gvErrorNo := 9002; // Stored Procedure 실행 오류
          gvExtMsg := E.Message;
          Result := False;
          Exit;
        end;
      end;

      sTemp := Parameters.ParamByName('@out_rtc').Value;
      if sTemp <> '0000' then
      begin
        gf_RollbackTransaction;
        gvErrorNo := 9002; // Stored Procedure 실행 오류
        gvExtMsg := Trim(Parameters.ParamByName('@out_kor_msg').Value);
        Result := False;
        Exit;
      end;
      iTotSeqNo := Parameters.ParamByName('@out_snd_no').Value;
    end;

    with ADOCommand_Main do
    begin
      StartTime := gf_GetCurTime;
      //----------------------------------------------------------------------
      // SCMELSND_TBL INSERT
      //----------------------------------------------------------------------
      CommandText :=
              'INSERT SCMELSND_TBL                                 ' +
              '(SND_DATE,        CUR_TOT_SEQ_NO,   DEPT_CODE,      ' +
              ' TRADE_DATE,      STRT_TIME,                        ' +
              ' RCV_MAIL_ADDR,   CC_MAIL_ADDR,     CC_BLIND_ADDR,  ' +
              ' RCV_MAIL_NAME,   CC_MAIL_NAME,     CC_BLIND_NAME,  ' +
              ' SND_USER_NAME,   RETURN_MAIL_ADDR, SUBJECT_DATA,   ' +
              ' MAIL_BODY_DATA,  RSP_FLAG,         SEND_TIME,      ' +
              ' SENT_TIME,       DIFF_TIME,        ERR_CODE,       ' +
              ' EXT_MSG,         OPR_ID,           OPR_TIME )      ' +
              'VALUES                                              ' +
              '(:pSndDate,       :pCurTotSeqNo,    :pDeptCode,     ' +
              ' :pTradeDate,     :pStrtTime,                       ' +
              ' :pRcvMailAddr,   :pCCMailAddr,     :pCCBlindAddr,  ' +
              ' :pRcvMailName,   :pCCMailName,     :pCCBlindName,  ' +
              ' :pSndUserName,   :pReturnMailAddr, :pSubjectData,  ' +
              ' :pMailBodyData,  :pRspFlag,        :pSendTime,     ' +
              ' :pSentTime,      :pDiffTime,       :pErrCode,      ' +
              ' :pExtMsg,        :pOprID,          :pOprTime )     ' ;
      try
        Parameters.ParamByName('pSndDate').Value        := pEMailFormat.CurDate;
        Parameters.ParamByName('pCurTotSeqNo').Value    := iTotSeqNo;
        Parameters.ParamByName('pDeptCode').Value       := pEMailFormat.DeptCode;
        Parameters.ParamByName('pTradeDate').Value      := pEMailFormat.JobDate;
        Parameters.ParamByName('pStrtTime').Value       := StartTime;
        Parameters.ParamByName('pRcvMailAddr').Value    := pEMailFormat.RcvMailAddr;
        Parameters.ParamByName('pRcvMailName').Value    := pEMailFormat.RcvMailName;
        Parameters.ParamByName('pCCMailName').Value     := '';
        Parameters.ParamByName('pCCBlindName').Value    := '';
        Parameters.ParamByName('pSndUserName').Value    := pEMailFormat.SndUserName;
        Parameters.ParamByName('pReturnMailAddr').Value := pEMailFormat.ReturnMailAddr;
        Parameters.ParamByName('pSubjectData').Value    := pEMailFormat.SubjectData;
        Parameters.ParamByName('pMailBodyData').Value   := pEMailFormat.MailBodyData;
        Parameters.ParamByName('pRspFlag').Value        := gcFAXTLX_RSPF_WAIT;
        Parameters.ParamByName('pSendTime').Value       := '';
        Parameters.ParamByName('pSentTime').Value       := '';
        Parameters.ParamByName('pDiffTime').Value       := 0;
        Parameters.ParamByName('pErrCode').Value        := '';
        Parameters.ParamByName('pExtMsg').Value         := '';
        Parameters.ParamByName('pOprID').Value          := pEMailFormat.OprID;
        Parameters.ParamByName('pOprTime').Value        := pEMailFormat.OprTime;
        Execute;
      except
        on E : Exception do
        begin
          gf_RollbackTransaction;
          gvErrorNo := 9001; // DB오류
          gvExtMsg := E.Message;
          Result := False;
          Exit;
        end;
      end; // end Except

      //----------------------------------------------------------------------
      // SZMELSNT_INS INSERT - [L.J.S] 한투 금상 테이블
      //----------------------------------------------------------------------
      CommandText :=
              'INSERT SZMELSNT_INS                                        '+
              '(DEPT_CODE,  JOB_DATE, JOB_SEQ, SND_DATE,  CUR_TOT_SEQ_NO) '+
              'VALUES                                                     '+
              '(:pDeptCode, pJobDate, pJobSeq, pSendDate, pCurTotSeqNo)   ';
              
      try
        Parameters.ParamByName('pDeptCode').Value      := gvDeptCode;
        Parameters.ParamByName('pJobDate').Value       := pEmailFormat.JobDate;
        Parameters.ParamByName('pJobSeq').Value        := pEmailFormat.JobSeq;
        Parameters.ParamByName('pSendDate').Value      := pEMailFormat.CurDate;
        Parameters.ParamByName('pCurTotSeqNo').Value   := iTotSeqNo;

        Execute;
      except
        on E : Exception do
        begin
          gf_RollbackTransaction;
          gvErrorNo := 9001; // DB오류
          gvExtMsg := E.Message;
          Result := False;
          Exit;
        end;
      end; // end Except
      
      //----------------------------------------------------------------------
      // SCMELATT_TBL INSERT
      //----------------------------------------------------------------------
      if (tEMailAttList <> Nil) and (tEMailAttList.Count >= 1) then
      begin
        for iIndex := 0 to tEMailAttList.Count - 1 do
        begin
          pEMailAtt := tEMailAttList[iIndex];

          sAttathPathFileName := pEMailAtt.sAttachFilePath + pEMailAtt.sAttachFileName;
          if not FileExists(sAttathPathFileName) then
          begin
            gf_RollbackTransaction;
            gvErrorNo := 1027; // 해당 파일이 존재하지 않습니다.
            gvExtMsg := 'Attach File Not Found : ' + sAttathPathFileName;
            Result := False;
            Exit;
          end;

          CommandText :=
                  'INSERT SCMELATT_TBL                               ' +
                  '(SND_DATE,        CUR_TOT_SEQ_NO,   ATT_SEQ_NO,   ' +
                  ' ATTACH_FILENAME, ATTACH_DATA)                    ' +
                  'VALUES                                            ' +
                  '(:pSndDate,       :pCurTotSeqNo,    :pAttSeqNo,   ' +
                  ' :pAttachFileName,:pAttachData)                   ';
          try
            Parameters.ParamByName('pSndDate').Value        := pEMailFormat.CurDate;
            Parameters.ParamByName('pCurTotSeqNo').Value    := iTotSeqNo;
            Parameters.ParamByName('pAttSeqNo').Value       := iIndex+1;
            Parameters.ParamByName('pAttachFileName').Value := pEMailAtt.sAttachFileName;
            Parameters.ParamByName('pAttachData').LoadFromFile(sAttathPathFileName,ftBlob);
            Execute;
          except
            on E : Exception do
            begin
              gf_RollbackTransaction;
              gvErrorNo := 9001; // DB오류
              gvExtMsg := E.Message;
              Result := False;
              Exit;
            end;
          end; // end Except
        end; // end for
      end; // if tEMailAttList.Count >= 1
    end; //end ADOCommand_Main
    //----------------------------------------------------------------------
  end; //end with DataModule_EFS
  gf_CommitTransaction;

  // Return 변수
  pEMailFormat.CurTotSeqNo := iTotSeqNo;

  //----------------------------------------------------------------------------
  // EMAIL SEND Request Send
  //----------------------------------------------------------------------------
  fnCharSet(@clisvrhead,' ',sizeof(CliSvrHead_R));
  MoveDataChar(clisvrhead.TrGbn,     gcSTYPE_MEL, SizeOf(clisvrhead.TrGbn));
  MoveDataChar(clisvrhead.TrCode,    '',          SizeOf(clisvrhead.TrCode));
  MoveDataChar(clisvrhead.TermNo,    gvTermNo,    sizeof(clisvrhead.TermNo));
  MoveDataChar(clisvrhead.LoginID,   gvOprUsrNo,  Sizeof(clisvrhead.LoginID));
  MoveDataChar(clisvrhead.WinHandle, '',          sizeof(clisvrhead.WinHandle));

  CharCharCpy(cpSbuff, @clisvrhead, sizeof(CliSvrHead_R));
  iSlen := sizeof(CliSvrHead_R);

  // EMAIL자료 전송 Request Send
  if fnServerSendData(iSlen, cpSbuff) < 0 then
  begin
    gf_Log('E-mail 전송 Error -> fnServerSendData');
    Result := False;
    Exit;
  end;
  
  Result := True;
end;

//=======================================================================
// EMail Data Cancel Function
//=======================================================================
function fnEMailDataCancel(iTotSeqNo : Integer) : Boolean;
var sTime : string;
begin
  with DataModule_Settlenet do
  begin
    with ADOQuery_Main do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT SND_DATE,     CUR_TOT_SEQ_NO, ' +
              '       RSP_FLAG                      ' +
              'FROM SCMELSND_TBL                    ' +
              'WHERE SND_DATE       = :pSndDate     ' +
              '  AND CUR_TOT_SEQ_NO = :pCurTotSeqNo ');
      try
        Parameters.ParamByName('pSndDate').Value     := gvCurDate;
        Parameters.ParamByName('pCurTotSeqNo').Value := iTotSeqNo;
        gf_ADOQueryOpen(ADOQuery_Main);
      except
        on E : Exception do
        begin
          gvErrorNo := 9001; // DB오류
          gvExtMsg := E.Message;
          Result := False;
          Exit;
        end;
      end; // end Except

      if RecordCount <> 1 then
      begin
        gvErrorNo  := 1025; //해당자료 없음
        gvExtMsg := '해당자료없음['+IntToStr(iTotSeqNo)+']';
        Result := False;
        Exit;
      end;

      // Wait상태만 최소가능함
      if (FieldByName('RSP_FLAG').asInteger <> gcFAXTLX_RSPF_WAIT) then
      begin
        gvErrorNo := 1094; //취소가능상태아님
        gvExtMsg := '취소 가능 상태 아님';
        Result := False;
        Exit;
      end;
    end; //end ADOQuery_Main

    with ADOCommand_Main do
    begin
      sTime := gf_GetCurTime;
      CommandText :=
              'UPDATE SCMELSND_TBL                  ' +
              ' SET RSP_FLAG = :pRspFlag,           ' +
              '     OPR_ID   = :pOprId,             ' +
              '     OPR_TIME = ''' + sTime +    ''' ' +
              'WHERE SND_DATE = :pSndDate           ' +
              '  AND CUR_TOT_SEQ_NO = :pCurTotSeqNo ';
      try
        Parameters.ParamByName('pSndDate').Value     := gvCurDate;
        Parameters.ParamByName('pCurTotSeqNo').Value := iTotSeqNo;
        Parameters.ParamByName('pRspFlag').Value     := gcFAXTLX_RSPF_CANC;
        Parameters.ParamByName('pOprId').Value       := gvOprUsrNo;
        Execute;
      except
        on E : Exception do
        begin
          gvErrorNo := 9001; // DB오류
          gvExtMsg := E.Message;
          Result := False;
          Exit;
        end;
      end; // end Except
    end; //end ADOCommand_Main
  end; //end with DataModule_EFS

  Result := True;
end;

end.
