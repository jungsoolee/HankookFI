//==========================================================================
//           Client TCP/IP Send/Recv Moudule                                |
//                                                                          |
//==========================================================================
unit ThreadCL2Md;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,DB,
  ScktComp,ExtCtrls, StdCtrls, Buttons,Winsock, ComObj,
  SCCCmuLib,SCCCmuGlobal,
  SCCGlobalType;

//--------------------------------------------------------------------------------------
// Dataroad Host GateWay 통신
//--------------------------------------------------------------------------------------
function  fnComTcpIpInit:Integer;
function  fnComThreadCreate(TSockID_Local : TSocket) :integer;
procedure fnComTcpIpClose;

//수수료계산관련
function  fnComDataSend(var pCommData : TCliSvrComData) : Integer;
//임포트파일생성관련
function  fnImpDataSend(sImpType:String; var pImpData : TCliSvrImpData) : Integer;
//마감정보업로드관련
function  fnInfoUpDataSend(var pUpData : TCliSvrUpData) : Integer;
//Client 정보관련
function fnComServerSendData(iSlen:integer; cpSbuff:PChar):Integer;
//Display Form
function fnSetfrmMain(frmMain : TForm; comDisply: TComponent) : integer;
//소켓생존여부
function fnMdServerAlive :Integer;

procedure DisplaynLog(msg : String);

type
//*=======================================================================*/
//*  자료전송,수신 Thread
//*=======================================================================*/
  TThreadCL2Md = class(TThread)
    FMySocket : TSocket;
    FTimeOut  : Integer;
    FException: Exception;

    FNormalCreFlag : Boolean;

    FlanRawBuff : Array[0..gcMAX_COMM_BUFF_SIZE] of char;

  private
    { Private declarations }
  protected
    procedure DoTerminate; override;
    procedure Execute; override;  // 메인 프로시저

    function  InitLogin : Integer;

    function  fnLoginSendData(TSockID_Local:TSocket):Integer;
    function  fnInitLoginRecv(TSockID_Local:TSocket):Integer;

    procedure OnRcvDataTrans(pRcvBuff : PChar);
  public

    frmMain : TForm;
    comDisply : TComponent;

    constructor Create(TSockID_Local : TSocket); // 클래스 생성처리및 속성처리
    destructor  destroy; override;
  end;
//*=======================================================================*/

implementation

uses
  SCCLib,SCCLogin,SCCDataModule, SCFH2356;

const
   NUL  = #0;  // NULL
   SPC  = #32; // SPACE
   TAB  = #09; // TAB

var
  // Thread Class
  TcpServicePort_CM  : TThreadCL2Md;
  ErrMessage         : String;

procedure DisplaynLog(msg : String);
begin
   if Assigned(TcpServicePort_CM) then
   if Assigned(TcpServicePort_CM.frmMain) then
   begin
      if Assigned(TcpServicePort_CM.comDisply) then
      if (TcpServicePort_CM.comDisply is TMemo) then
         TMemo(TcpServicePort_CM.comDisply).Lines.Add(msg);
   end;

   gf_Log(msg);
end;

//*=======================================================================*/
// TODO: TThreadCL2Md Execute 자료송수신Procedure
//*=======================================================================*/
procedure TThreadCL2Md.Execute;
var
    TSockID : TSocket;
    Tfd     : TFDSet;
    timeout : TTimeVal;
    iRc     : Integer;

    lanRawBuff,lanPbuff:array[0..10000] of char;
    iRawLen,iDecodeSize:LongInt;
    iComRc   : LongInt;
    //iSendErrno: LongInt;
begin

   //HostGW로 로그인
   if InitLogin < 0 then
   begin
      DisplaynLog('TThreadCL2Md [Execute]>> [ERROR] InitLogin Error!!! ');
      Exit;
   end;

   TSockID := FMySocket;

   //lanRawBuff := 'POL';
   //iRawLen := 3;

repeat

   try

      while (not(Terminated)) do
      begin

         // TTCP.terminate에서 terminated=TRUE로 만듬
         if terminated = TRUE then exit;

         DisplaynLog('TThreadCL2Md [Execute]>> while...');

         // Select readfds Status
         FD_ZERO(Tfd);
         FD_SET(TSockID,Tfd);

         // TimeOut 20초
         timeout.tv_sec  := FTimeOut;
         timeout.tv_usec := 1000;

         // SELECT
         iRc :=  Select(1,@Tfd,Nil,Nil,@timeout);

         // Select Error Check
         if iRc = 0 then // Time Out
         begin
            DisplaynLog('TThreadCL2Md [Execute]>> timeout...');

            iRawLen := 3;
            CharCharCpy(lanRawBuff,gcSTYPE_POLL,3);
            iComRc := fnTcpDataSend(TSockID,1,iRawLen,lanRawBuff);

            if iComRc = gcCOMM_TERMINATE then
            begin
               DisplaynLog('TThreadCL2Md [Execute] >> Polling Send Error : terminate...');
               exit;
            end;

            continue;
         end else
         if iRc < 0 then     // Other error
         begin
            DisplaynLog('TThreadCL2Md [Execute]>> terminate...');
            Exit;
         end;

         // Polling Data Send
         iRawLen := 3;
         CharCharCpy(lanRawBuff,gcSTYPE_POLL,3);
         DisplaynLog('TThreadCL2Md [Execute] >> Polling Send ');
         iComRc := fnTcpDataSend(TSockID,1,iRawLen,lanRawBuff);

         if iComRc = gcCOMM_TERMINATE then
         begin
            DisplaynLog('TThreadCL2Md [Execute]>> Polling Send Error : terminate...');
            exit;
         end;


//*************************
{
       // 자료수신
       iComRc := fnTcpDataRecv(TSockID,lanRawBuff,iDecodeSize,iPacketNO);
       // 자료수신정상 Check
       case iComRc of
            gcCOMM_TERMINATE : // Connection Terminate => ReConnection
                  begin
                    DisplaynLog('terminate');
                    exit;
                  end;
            gcERROR_TIME_OUT,
            gcERROR_DATA_CONTEXT :
                  begin
                       // Send Main Error(통신이상 해당작업결과요망)
                      DisplaynLog('timeout');
                      continue;
                  end;
       end; // end case
}
//***************************

         Sleep(1000);
  end; (* end while *)

except
   begin
      DisplaynLog('TThreadCL2Md [Execute]>> [ERROR] : ' + FException.Message);
      Exit;
   end;
end; // except end

   // 외부에서 kill발생시
   if terminated = TRUE then break;

until false;

end;


//*=======================================================================*/
//* InitLogin
//*=======================================================================*/
function TThreadCL2Md.InitLogin : Integer;
var
   iResult : Integer;
begin
   // Login Data Send
   iResult := fnLoginSendData(FMySocket);

   Result := iResult;

   if iResult < 0 then
   begin
      gf_Log('InitLogin>> after fnLoginSendData:'+ErrMessage);
      DisplaynLog('InitLogin>> after fnLoginSendData:'+ErrMessage);
      Result := iResult;
      exit;
   end;

end;

//*=======================================================================*/
// Client Login Data 전송 function
//*=======================================================================*/
function  TThreadCL2Md.fnLoginSendData(TSockID_Local:TSocket):Integer;
var
    cpSbuff : array [0..gcMAX_COMM_BUFF_SIZE] of char;
    iSlen,iRc: Integer;
    CliSvrHead : CliSvrHead_R;
    tTempLogData : TLOGDATA;
    sCliVersion  : String;
begin
    result := -1;

    fnCharSet(@clisvrhead,' ',sizeof(CliSvrHead_R));

    CharCharCpy(clisvrhead.TrGbn,gcSTYPE_LOGN,3);
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
    {
    gf_Log('fnLoginSendData>> after fnTcpDataSend');
    //초기 Login승인 수신(사용자정보를 수신)
    iRc := fnInitLoginRecv(TSockID_Local);
    if iRc < 0 then
    begin
    result := iRc;
    exit;
    end;
    gf_Log('fnLoginSendData>> after fnInitLoginRecv');
    }
    result := 1;
end;

//*=======================================================================*/
// 초기 사용자정보수신
//*=======================================================================*/
function TThreadCL2Md.fnInitLoginRecv(TSockID_Local:TSocket):Integer;
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
     {
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
     }
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


procedure TThreadCL2Md.OnRcvDataTrans(pRcvBuff : PChar);
var
//   iSendLen : LongInt;
//   pRcvBuff : array [0..gcMAX_COMM_BUFF_SIZE] of char;

   ptTmpComData   : ptTCliSvrComData;
   pCliSvrHead    : ptCliSvrHead_R;

   sUserID  : String;
   sTradeDate, sAccNo, sCmtType, sMrktDeal, sIssueCode, sTradeType, sCommOrd, sPgmCall, sAmt : String;

   o_cmsn_rt, o_cmsn_add  : double;
   o_cmsn, o_deal_tax, o_vill_tax : double;

begin
    // Client Data
    //CharCharCpy(pRcvBuff, FlanRawBuff, Sizeof(FlanRawBuff));
    pCliSvrHead := @pRcvBuff[0];

    // User ID
    sUserID := Trim(Char2Str(pCliSvrHead.LoginID,8));
    if sUserID <> Trim(gvOprUsrNo) then
    begin
        DisplaynLog('OnRcvDataTrans : sUserID : ' + sUserID + '<> ' + 'gvOprUsrNo : ' + gvOprUsrNo);
        Exit;
    end;

    DisplaynLog(IntToStr(FMySocket) + '***************************************************  Starting...');

    // 수수료계산 대상정보
    ptTmpComData := @pRcvBuff[sizeof(CliSvrHead_R)];

    sTradeDate := Trim(Char2Str(ptTmpComData.csTradeDate ,SizeOf(ptTmpComData.csTradeDate)));
    sAccNo     := Trim(Char2Str(ptTmpComData.csAccNo ,SizeOf(ptTmpComData.csAccNo)));
    sCmtType   := Trim(Char2Str(ptTmpComData.csCmtType ,SizeOf(ptTmpComData.csCmtType)));
    sMrktDeal  := Trim(Char2Str(@ptTmpComData.csMrktDeal ,SizeOf(ptTmpComData.csMrktDeal)));
    sIssueCode := Trim(Char2Str(ptTmpComData.csIssueCode ,SizeOf(ptTmpComData.csIssueCode)));
    sTradeType := Trim(Char2Str(@ptTmpComData.csTradeType, Sizeof(ptTmpComData.csTradeType)));
    sCommOrd   := Trim(Char2Str(ptTmpComData.csCommOrd, Sizeof(ptTmpComData.csCommOrd)));
    sPgmCall   := Trim(Char2Str(ptTmpComData.csPgmCall, Sizeof(ptTmpComData.csPgmCall)));
    sAmt       := Trim(Char2Str(ptTmpComData.cnAmt ,SizeOf(ptTmpComData.cnAmt)));

    o_cmsn     :=  StrToFloat(Trim(Char2Str(ptTmpComData.cnComm ,SizeOf(ptTmpComData.cnComm))));
    o_deal_tax :=  StrToFloat(Trim(Char2Str(ptTmpComData.cnTTax ,SizeOf(ptTmpComData.cnComm))));
    o_vill_tax :=  StrToFloat(Trim(Char2Str(ptTmpComData.cnATax ,SizeOf(ptTmpComData.cnATax))));
    o_cmsn_rt  :=  StrToFloat(Trim(Char2Str(ptTmpComData.cnCommRate ,SizeOf(ptTmpComData.cnCommRate))));
    o_cmsn_add :=  StrToFloat(Trim(Char2Str(ptTmpComData.cnCommAdd ,SizeOf(ptTmpComData.cnCommAdd))));


    DisplaynLog(IntToStr(FMySocket) + '  RCVCOM[ TRADE_DATE = ' + sTradeDate + ']');  
    DisplaynLog(IntToStr(FMySocket) + '  RCVCOM[ ACC_NO     = ' + sAccNo + ']');
    DisplaynLog(IntToStr(FMySocket) + '  RCVCOM[ CMT_TYPE   = ' + sCmtType + ']');
    DisplaynLog(IntToStr(FMySocket) + '  RCVCOM[ MRK_DEAL_TP= ' + sMrktDeal + ']');
    DisplaynLog(IntToStr(FMySocket) + '  RCVCOM[ ISSUE_CODE = ' + sIssueCode + ']');
    DisplaynLog(IntToStr(FMySocket) + '  RCVCOM[ TRADE_TYPE = ' + sTradeType + ']');
    DisplaynLog(IntToStr(FMySocket) + '  RCVCOM[ COMM_ORD   = ' + sCommOrd + ']');
    DisplaynLog(IntToStr(FMySocket) + '  RCVCOM[ PGM_CALL   = ' + sPgmCall + ']');
    DisplaynLog(IntToStr(FMySocket) + '  RCVCOM[ sAmt       = ' + sAmt + ']');
                                                              
    DisplaynLog(IntToStr(FMySocket) + '  RCVCOM[ COMM     = ' + FloatToStr(o_cmsn) + ']');
    DisplaynLog(IntToStr(FMySocket) + '  RCVCOM[ T_TAX    = ' + FloatToStr(o_deal_tax) + ']');
    DisplaynLog(IntToStr(FMySocket) + '  RCVCOM[ A_TAX    = ' + FloatToStr(o_vill_tax) + ']');
    DisplaynLog(IntToStr(FMySocket) + '  RCVCOM[ COM_RATE = ' + FormatFloat('#0.0###########', o_cmsn_rt) + ']');
    DisplaynLog(IntToStr(FMySocket) + '  RCVCOM[ COM_ADD  = ' + FloatToStr(o_cmsn_add) + ']');

    DisplaynLog(IntToStr(FMySocket) + '***************************************************  Ending...');

end;

//*=======================================================================*/
//* TODO: TThreadCL2Md Create
//*=======================================================================*/
constructor TThreadCL2Md.Create(TSockID_Local : TSocket);
begin
  inherited Create(True); // thread생성되자 마자 실행안됨

   FMySocket := TSockID_Local;
   if gvUserSvrTimeOut <= 0 then
      FTimeOut := 10
   else
      FTimeOut := gvUserSvrTimeOut;

   FNormalCreFlag := True;
end;

//*=======================================================================*/
//* TODO: TThreadCL2Md Destroy
//*=======================================================================*/
destructor TThreadCL2Md.Destroy;
var
   Msg : TMessage;
begin
  inherited destroy;
   DisplaynLog('destroy >> TcpServicePort_CM := nil ');

   TcpServicePort_CM := Nil;

   // Send Main Error(통신주절)
   //Msg.WParam := gcTCPIP_CLIENT_LOGSND_WPARAM_DISCONN;
   //PostMessage(gvMainFrameHandle,WM_USER_TCPIP_CLIENT_LOGSND, Msg.WParam,Msg.LParam);
end;

//*=======================================================================*/
//* TODO: TThreadCL2Md Terminate
//*=======================================================================*/
procedure TThreadCL2Md.DoTerminate;
begin
   DisplaynLog('doterminate >> sock close ');

   TcpClose(FMySocket);
   FMySocket := 0;
   inherited DoTerminate;
end;

//*=======================================================================*/
//* TODO: fnComThreadCreate
//*=======================================================================*/
function fnComThreadCreate(TSockID_Local : TSocket) :integer;
begin
   TcpServicePort_CM := Nil;

   // SEND PORT Thread Create
   TcpServicePort_CM := TThreadCL2Md.Create(TSockID_Local);
   if (TcpServicePort_CM = Nil) or (Not TcpServicePort_CM.FNormalCreFlag) then
   begin
      Result := 1;
      Exit;
   end;

   TcpServicePort_CM.priority:=tpNormal;
   TcpServicePort_CM.FreeOnTerminate := True;
   TcpServicePort_CM.Resume;   // TTcp_ComServicePort.Execute 실행
   Result := 1;
end;

//*=======================================================================*/
// TODO: fnComTcpIpInit
//*=======================================================================*/
function fnComTcpIpInit : Integer;
var
   TsockID_Local : TSocket;
   sMsg : array [0..50] of char;
   Msg : TMessage;
   SERVER_IPADDR : array [0..15] of char;
   SERVER_PORT   : integer;

begin
   Str2Char(SERVER_IPADDR,gvUserSvrIP,Length(gvUserSvrIP));
   SERVER_PORT := gvUserSvrPort + 2;  //3003

   // SOCKET 초기화 ( Memory Grid error발생시 bind error생성 가능함
   if (WinsockInit < 0) then
   begin
      ErrMessage := '>> Winsock Init error <<';
      DisplaynLog(ErrMessage);
      result := -1;
      Exit;
   end;

   // Tcp open
   TSockID_Local := TcpOpen(SERVER_IPADDR,SERVER_PORT);
   if TsockID_Local < 0 then
   begin
      strfmt(sMsg,'>> TCP [%s] port [%d]Failed <<',[SERVER_IPADDR,SERVER_PORT]);
      DisplaynLog(StrPas(sMsg));
      result := -1;
      exit;
   end;

   fnComThreadCreate(TSockID_Local);
   Result := 1;
end;

//*=======================================================================*/
// TODO: fnComTcpIpClose
//*=======================================================================*/
procedure fnComTcpIpClose;
var
   iRc : Integer;
begin
   // Thread Kill
   TcpClose(TcpServicePort_CM.FMySocket);
   iRc := fnThreadKilled(TcpServicePort_CM,TRUE);

   if iRc > -1 then
   begin
      TcpServicePort_CM := nil;
   end;

end;

//*=======================================================================*/
// TODO: fnComDataSend
//*=======================================================================*/
function fnComDataSend(var pCommData : TCliSvrComData) : Integer;
var
   cpSbuff : array [0..gcMAX_COMM_BUFF_SIZE] of char;
   iSlen, iRc: Integer;
   CliSvrHead : CliSvrHead_R;

   lanRawBuff,lanPbuff:array[0..gcMAX_COMM_BUFF_SIZE] of char;
   iDecodeSize:LongInt;
   iComRc   : LongInt;
   iPacketNo: LongInt;

   SndComData : TCliSvrComData;
   ptRcvComData : ptTCliSvrComData;
begin

    DisplaynLog('TThreadCL2Md [fnComDataSend]>> SndFunction Starting!!~~~~~~~~ ');

    result := -1;
    
    SndComData := pCommData;

    fnCharSet(@CliSvrHead,' ',sizeof(CliSvrHead_R));

    CharCharCpy(CliSvrHead.TrGbn,gcSTYPE_COM,3);
    fnCharSet(CliSvrHead.TrCode,' ',sizeof(CliSvrHead.TrCode));
    //초기 Login시 단말번호 없음
    fnCharSet(CliSvrHead.TermNo,' ',sizeof(CliSvrHead.TermNo));
    MoveDataChar(CliSvrHead.LoginID,gvOprUsrNo,Length(gvOprUsrNo));
    fnCharSet(CliSvrHead.WinHandle,' ',sizeof(CliSvrHead.WinHandle));

    CharCharCpy(cpSbuff,@CliSvrHead,sizeof(CliSvrHead_R));
    iSlen := sizeof(CliSvrHead_R);

    //----------------------------------------------------
    // DATA -> ENGFLG[1) + PASSWD[8] + VERSION[4]
    //----------------------------------------------------
    {
    MoveDataChar(SndComData.csTradeDate, pTradeDate, Sizeof(SndComData.csTradeDate));
    MoveDataChar(SndComData.csAccNo, pAccNo, Sizeof(SndComData.csAccNo));
    MoveDataChar(SndComData.cnAmt, FloatToStr(pAmt), Sizeof(SndComData.cnAmt));
    MoveDataChar(SndComData.csStatus, 'READY', Sizeof(SndComData.csStatus));
    MoveDataChar(@SndComData.csTranType, pTranType, Sizeof(SndComData.csTranType));
    MoveDataChar(@SndComData.csStlDate, pStlDate, Sizeof(SndComData.csStlDate));
    MoveDataChar(@SndComData.csIssueCode, pIssueCode, Sizeof(SndComData.csIssueCode));
    }

//    DisplaynLog('TThreadCL2Md [fnComDataSend]>> SND [TRADE_DATE] ' + SndComData.csTradeDate);
//    DisplaynLog('TThreadCL2Md [fnComDataSend]>> SND [AMT       ] ' + SndComData.cnAmt);

    CharCharCpy(@cpsBuff[iSlen], @SndComData, Sizeof(SndComData));
    Inc(iSlen, Sizeof(SndComData));
    cpSbuff[iSlen] := #0;

    Displaynlog('TThreadCL2Md [fnComDataSend]>> SND FullBuff : ' + cpSbuff);

    // 수수료계산될 계좌정보 전송
    iRc := fnTcpDataSend(TcpServicePort_CM.FMySocket,1,iSlen,cpSbuff);
    if (iRc < 0) then
    begin
        ErrMessage := '[' + IntToStr(abs(iRc)) + '] ' + fnErrorMsg(abs(iRc));
        DisplaynLog('TThreadCL2Md [fnComDataSend]>> ' + ErrMessage);
        result := -1;
        exit;
    end;

    DisplaynLog('TThreadCL2Md [fnComDataSend]>> before fnTcpDataRecv ');

    iComRc := fnTcpDataRecv(TcpServicePort_CM.FMySocket,lanRawBuff,iDecodeSize,iPacketNO);
    case iComRc of
      gcCOMM_TERMINATE : // Connection Terminate => ReConnection
            begin
                DisplaynLog('TThreadCL2Md [fnComDataSend]>> fnTcpDataRecv terminate');
                result := -1;
                exit;
            end;
      gcERROR_TIME_OUT,
      gcERROR_DATA_CONTEXT :
            begin
                // Send Main Error(통신이상 해당작업결과요망)
                DisplaynLog('TThreadCL2Md [fnComDataSend]>> fnTcpDataRecv timeout');
                result := -1;
                exit;
            end;
    end; // end case

    // 정상수신자료
    CharCharCpy(lanPbuff,lanRawBuff,iDecodeSize);
    lanPbuff[iDecodeSize] := #0;

    //------------------------
    // Type Check
    //------------------------
    try
    if CharCharCmp(@lanPbuff[0],gcSTYPE_COM,3) = 0 then
    begin
        //----------------------------------------------------------------
        // 수수료계산 다했단다.
        ptRcvComData := @lanPbuff[Sizeof(CliSvrHead_R)];
        CharCharCpy(pCommData.csErrcode, ptRcvComData.csErrcode, Sizeof(pCommData.csErrcode));
        CharCharCpy(pCommData.csErrmsg, ptRcvComData.csErrmsg, Sizeof(pCommData.csErrmsg));
        CharCharCpy(pCommData.cnComm, ptRcvComData.cnComm, Sizeof(pCommData.cnComm));
        CharCharCpy(pCommData.cnTTax, ptRcvComData.cnTTax, Sizeof(pCommData.cnTTax));
        CharCharCpy(pCommData.cnATax, ptRcvComData.cnATax, Sizeof(pCommData.cnATax));
        CharCharCpy(pCommData.cnCommRate, ptRcvComData.cnCommRate, Sizeof(pCommData.cnCommRate));
        CharCharCpy(pCommData.cnCommAdd, ptRcvComData.cnCommAdd, Sizeof(pCommData.cnCommAdd));

        if (pCommData.csErrcode <> '000000') then
        begin
          DisplaynLog('TThreadCL2Md [fnComDataSend]>> [ERROR] csErrmsg : ' + pCommData.csErrmsg);
          exit;
        end;

        //TcpServicePort_CM.OnRcvDataTrans(lanPbuff);
        //----------------------------------------------------------------
    end else
    begin
        DisplaynLog('TThreadCL2Md [fnComDataSend]>> [ERROR] fnTcpDataRecv TypeCheck Error !!!! ');
        Exit;
    end;
    except
    on E : Exception do
    begin
      DisplaynLog('~~~~~~~~~~~~~~~~~~~~~~~~여기다!!!');
      DisplaynLog(lanPbuff);
      DisplaynLog('~~~~~~~~~~~~~~~~~~~~~~~~~');
      Exit;
    end;
    end;

    DisplaynLog('TThreadCL2Md [fnComDataSend]>> after fnTcpDataRecv');

    result := 1;
    DisplaynLog('TThreadCL2Md [fnComDataSend]>> SndFunction Ending!!~~~~~~~~ ');

end;

//*=======================================================================*/
// TODO: fnImpDataSend
//*=======================================================================*/
function fnImpDataSend(sImpType:String; var pImpData : TCliSvrImpData) : Integer;
var
   cpSbuff : array [0..gcMAX_COMM_BUFF_SIZE] of char;
   iSlen, iRc: Integer;
   CliSvrHead : CliSvrHead_R;

   lanRawBuff,lanPbuff:array[0..gcMAX_COMM_BUFF_SIZE] of char;
   iDecodeSize:LongInt;
   iComRc   : LongInt;
   iPacketNo: LongInt;

   SndImpData : TCliSvrImpData;
   ptRcvImpData : ptTCliSvrImpData;
begin
    gf_Log('TThreadCL2Md [fnImpDataSend]>> SndFunction Starting!!~~~~~~~~ ');
    DisplaynLog('TThreadCL2Md [fnImpDataSend]>> SndFunction Starting!!~~~~~~~~ ');

    result := -1;

    SndImpData := pImpData;

    fnCharSet(@CliSvrHead,' ',sizeof(CliSvrHead_R));

    CharCharCpy(CliSvrHead.TrGbn,Pchar(sImpType),3);
    fnCharSet(CliSvrHead.TrCode,' ',sizeof(CliSvrHead.TrCode));
    //초기 Login시 단말번호 없음
    fnCharSet(CliSvrHead.TermNo,' ',sizeof(CliSvrHead.TermNo));
    MoveDataChar(CliSvrHead.LoginID,gvOprUsrNo,Length(gvOprUsrNo));
    fnCharSet(CliSvrHead.WinHandle,' ',sizeof(CliSvrHead.WinHandle));

    CharCharCpy(cpSbuff,@CliSvrHead,sizeof(CliSvrHead_R));
    iSlen := sizeof(CliSvrHead_R);


    gf_Log('TThreadCL2Md [fnImpDataSend]>> SND [IMP_TYPE  ] ' + sImpType);
    gf_Log('TThreadCL2Md [fnImpDataSend]>> SND [TRADE_DATE] ' + SndImpData.csTradeDate);
    gf_Log('TThreadCL2Md [fnImpDataSend]>> SND [ACC_NO]     ' + SndImpData.csAccNo);
    gf_Log('TThreadCL2Md [fnImpDataSend]>> SND [FILE_NAME ] ' + SndImpData.csFileName);
    gf_Log('TThreadCL2Md [fnImpDataSend]>> SND [DEPT_CODE ] ' + SndImpData.csDeptCode);

    //----------------------------------------------------
    // DATA -> ENGFLG[1) + PASSWD[8] + VERSION[4]
    //----------------------------------------------------

    DisplaynLog('TThreadCL2Md [fnImpDataSend]>> SND [IMP_TYPE  ] ' + sImpType);
    DisplaynLog('TThreadCL2Md [fnImpDataSend]>> SND [TRADE_DATE] ' + SndImpData.csTradeDate);
    DisplaynLog('TThreadCL2Md [fnImpDataSend]>> SND [ACC_NO]     ' + SndImpData.csAccNo);
    DisplaynLog('TThreadCL2Md [fnImpDataSend]>> SND [FILE_NAME ] ' + SndImpData.csFileName);
    DisplaynLog('TThreadCL2Md [fnImpDataSend]>> SND [DEPT_CODE ] ' + SndImpData.csDeptCode);

    CharCharCpy(@cpsBuff[iSlen], @SndImpData, Sizeof(SndImpData));
    Inc(iSlen, Sizeof(SndImpData));
    cpSbuff[iSlen] := #0;

    // 임포트될 계좌정보 전송
    iRc := fnTcpDataSend(TcpServicePort_CM.FMySocket,1,iSlen,cpSbuff);
    if (iRc < 0) then
    begin
        ErrMessage := '[' + IntToStr(abs(iRc)) + '] ' + fnErrorMsg(abs(iRc));
        DisplaynLog('TThreadCL2Md [fnImpDataSend]>> ' + ErrMessage);
        gf_Log('TThreadCL2Md [fnImpDataSend]>> ' + ErrMessage);
        result := -1;
        exit;
    end;

    DisplaynLog('TThreadCL2Md [fnImpDataSend]>> before fnTcpDataRecv ');

    iComRc := fnTcpDataRecv(TcpServicePort_CM.FMySocket,lanRawBuff,iDecodeSize,iPacketNO);
    case iComRc of
      gcCOMM_TERMINATE : // Connection Terminate => ReConnection
            begin
                DisplaynLog('TThreadCL2Md [fnImpDataSend]>> fnTcpDataRecv terminate');
                gf_Log('TThreadCL2Md [fnImpDataSend]>> fnTcpDataRecv terminate');
                result := -1;
                exit;
            end;
      gcERROR_TIME_OUT,
      gcERROR_DATA_CONTEXT :
            begin
                // Send Main Error(통신이상 해당작업결과요망)
                DisplaynLog('TThreadCL2Md [fnImpDataSend]>> fnTcpDataRecv timeout');
                gf_Log('TThreadCL2Md [fnImpDataSend]>> fnTcpDataRecv timeout');
                result := -1;
                exit;
            end;
    end; // end case

    // 정상수신자료
    CharCharCpy(lanPbuff,lanRawBuff,iDecodeSize);
    lanPbuff[iDecodeSize] := #0;

    gf_Log('정상수신자료');
    //------------------------
    // Type Check
    //------------------------
    if CharCharCmp(@lanPbuff[0],PChar(sImpType),3) = 0 then
    begin
        //----------------------------------------------------------------
        // 임포트파일 만들었단다.
        ptRcvImpData := @lanPbuff[Sizeof(CliSvrHead_R)];
        CharCharCpy(pImpData.csErrcode, ptRcvImpData.csErrcode, Sizeof(pImpData.csErrcode));
        CharCharCpy(pImpData.csErrmsg, ptRcvImpData.csErrmsg, Sizeof(pImpData.csErrmsg));
        CharCharCpy(@pImpData.csCreYN, @ptRcvImpData.csCreYN, Sizeof(pImpData.csCreYN));

        if (pImpData.csErrcode <> '000000') then
        begin
          DisplaynLog('TThreadCL2Md [fnImpDataSend]>> [ERROR] csErrmsg : ' + pImpData.csErrmsg);
          exit;
        end;

        //TcpServicePort_CM.OnRcvDataTrans(lanPbuff);
        //----------------------------------------------------------------
    end else
    begin
        DisplaynLog('TThreadCL2Md [fnImpDataSend]>> [ERROR] fnTcpDataRecv TypeCheck Error !!!! ');
    end;

    DisplaynLog('TThreadCL2Md [fnImpDataSend]>> after fnTcpDataRecv');
    gf_Log('TThreadCL2Md [fnImpDataSend]>> after fnTcpDataRecv');

    result := 1;
    DisplaynLog('TThreadCL2Md [fnImpDataSend]>> SndFunction Ending!!~~~~~~~~ ');
    gf_Log('TThreadCL2Md [fnImpDataSend]>> SndFunction Ending!!~~~~~~~~ ');
end;

//*=======================================================================*/
// TODO: fnInfoUpDataSend
//*=======================================================================*/
function fnInfoUpDataSend(var pUpData : TCliSvrUpData) : Integer;
var
   cpSbuff : array [0..gcMAX_COMM_BUFF_SIZE] of char;
   iSlen, iRc: Integer;
   CliSvrHead : CliSvrHead_R;

   lanRawBuff,lanPbuff:array[0..gcMAX_COMM_BUFF_SIZE] of char;
   iDecodeSize:LongInt;
   iComRc   : LongInt;
   iPacketNo: LongInt;

   SndUpData : TCliSvrUpData;
   ptRcvUpData : ptTCliSvrUpData;
begin

    DisplaynLog('TThreadCL2Md [fnInfoUpDataSend]>> SndFunction Starting!!~~~~~~~~ ');

    result := -1;

    SndUpData := pUpData;

    fnCharSet(@CliSvrHead,' ',sizeof(CliSvrHead_R));

    CharCharCpy(CliSvrHead.TrGbn,gcSTYPE_UPLOAD,3);
    fnCharSet(CliSvrHead.TrCode,' ',sizeof(CliSvrHead.TrCode));
    //초기 Login시 단말번호 없음
    fnCharSet(CliSvrHead.TermNo,' ',sizeof(CliSvrHead.TermNo));
    MoveDataChar(CliSvrHead.LoginID,gvOprUsrNo,Length(gvOprUsrNo));
    fnCharSet(CliSvrHead.WinHandle,' ',sizeof(CliSvrHead.WinHandle));

    CharCharCpy(cpSbuff,@CliSvrHead,sizeof(CliSvrHead_R));
    iSlen := sizeof(CliSvrHead_R);

    //----------------------------------------------------
    // DATA -> ENGFLG[1) + PASSWD[8] + VERSION[4]
    //----------------------------------------------------

    DisplaynLog('TThreadCL2Md [fnInfoUpDataSend]>> SND [TRADE_DATE] ' + SndUpData.csTradeDate);
    DisplaynLog('TThreadCL2Md [fnInfoUpDataSend]>> SND [FILE_NAME ] ' + SndUpData.csFileName);

    CharCharCpy(@cpsBuff[iSlen], @SndUpData, Sizeof(SndUpData));
    Inc(iSlen, Sizeof(SndUpData));
    cpSbuff[iSlen] := #0;

    // 업로드될 파일생성정보 전송
    iRc := fnTcpDataSend(TcpServicePort_CM.FMySocket,1,iSlen,cpSbuff);
    if (iRc < 0) then
    begin
        ErrMessage := '[' + IntToStr(abs(iRc)) + '] ' + fnErrorMsg(abs(iRc));
        DisplaynLog('TThreadCL2Md [fnInfoUpDataSend]>> ' + ErrMessage);
        result := -1;
        exit;
    end;

    DisplaynLog('TThreadCL2Md [fnInfoUpDataSend]>> before fnTcpDataRecv ');

    iComRc := fnTcpDataRecv(TcpServicePort_CM.FMySocket,lanRawBuff,iDecodeSize,iPacketNO);
    case iComRc of
      gcCOMM_TERMINATE : // Connection Terminate => ReConnection
            begin
                DisplaynLog('TThreadCL2Md [fnInfoUpDataSend]>> fnTcpDataRecv terminate');
                result := -1;
                exit;
            end;
      gcERROR_TIME_OUT,
      gcERROR_DATA_CONTEXT :
            begin
                // Send Main Error(통신이상 해당작업결과요망)
                DisplaynLog('TThreadCL2Md [fnInfoUpDataSend]>> fnTcpDataRecv timeout');
                result := -1;
                exit;
            end;
    end; // end case

    // 정상수신자료
    CharCharCpy(lanPbuff,lanRawBuff,iDecodeSize);
    lanPbuff[iDecodeSize] := #0;

    //------------------------
    // Type Check
    //------------------------
    try
    if CharCharCmp(@lanPbuff[0],gcSTYPE_UPLOAD,3) = 0 then
    begin
        //----------------------------------------------------------------
        // 업로드파일 다 만들었단다.
        ptRcvUpData := @lanPbuff[Sizeof(CliSvrHead_R)];
        CharCharCpy(pUpData.csErrcode, ptRcvUpData.csErrcode, Sizeof(pUpData.csErrcode));
        CharCharCpy(pUpData.csErrmsg, ptRcvUpData.csErrmsg, Sizeof(pUpData.csErrmsg));
        CharCharCpy(@pUpData.csCreYN, @ptRcvUpData.csCreYN, Sizeof(pUpData.csCreYN));

        if (pUpData.csErrcode <> '000000') then
        begin
          DisplaynLog('TThreadCL2Md [fnInfoUpDataSend]>> [ERROR] csErrmsg : ' + pUpData.csErrmsg);
          exit;
        end;
        if (pUpData.csCreYN <> 'Y') then
        begin
          DisplaynLog('TThreadCL2Md [fnInfoUpDataSend]>> [ERROR] not CreateFile : ' + pUpData.csCreYN);
          exit;
        end;
        //----------------------------------------------------------------
    end else
    begin
        DisplaynLog('TThreadCL2Md [fnInfoUpDataSend]>> [ERROR] fnTcpDataRecv TypeCheck Error !!!! ');
        Exit;
    end;
    except
    on E : Exception do
    begin
      DisplaynLog('TThreadCL2Md [fnInfoUpDataSend]>> ~~~~~~~~~~~~~~~~~~~~~~~~여기다!!!');
      DisplaynLog(lanPbuff);
      DisplaynLog('TThreadCL2Md [fnInfoUpDataSend]>> ~~~~~~~~~~~~~~~~~~~~~~~~~');
      Exit;
    end;
    end;
    DisplaynLog('TThreadCL2Md [fnInfoUpDataSend]>> after fnTcpDataRecv');

    result := 1;
    DisplaynLog('TThreadCL2Md [fnInfoUpDataSend]>> SndFunction Ending!!~~~~~~~~ ');

end;

//*=======================================================================*/
// TODO: 사용자정보 Client Data 전송 function
//*=======================================================================*/
function fnComServerSendData(iSlen:integer; cpSbuff:PChar):Integer;
var
   iRc : Integer;
begin
   result := -1;

   // SocketThread 실행중인지 체크
   iRc := fnMdServerAlive;
   if iRc = -1 then
   begin
      DisplaynLog('gf_HostGateWaysngetACInfo >> not fnServerAlive 서버가 실행중인지 확인하시오.');
      Exit;
   end;

   result := fnTcpDataSend(TcpServicePort_CM.FMySocket,1,iSlen,cpSbuff);

end;

//*=======================================================================*/
// TODO: SocketThread 생존여부
//*=======================================================================*/
function fnMdServerAlive :Integer;
var
   lpExitCode : DWord;
   irc : Integer;
begin
   Result := -1;

   if Assigned(TcpServicePort_CM) then
   begin
      if GetExitCodeThread(TcpServicePort_CM.Handle,lpExitCode) then
      begin
         if lpExitCode = STILL_ACTIVE then
         begin
            result := 1;
         end;
      end;
   end else
   begin
      DisplaynLog('TThreadCL2Md [fnServerAlive] : not fnMdServerAlive!!! ReConnect Starting...');

      irc := fnComTcpIpInit;
      result := irc;

      if irc = -1 then
      begin
         DisplaynLog('TThreadCL2Md [fnServerAlive] : [ERROR] fnComTcpIpInit Fail!! ');
         Exit;
      end;

   end;

end;

function  fnSetfrmMain(frmMain : TForm; comDisply: TComponent) : integer;
begin
   result := -1;

   if Assigned(frmMain) then
   TcpServicePort_CM.frmMain   := frmMain;
   if Assigned(comDisply) then
   TcpServicePort_CM.comDisply := comDisply;
   result := 1;
end;

end.




var
    TSockID : TSocket;
    Tfd     : TFDSet;
    timeout : TTimeVal;
    iRc     : Integer;
    lanRawBuff,lanPbuff:array[0..10000] of char;
    iRawLen,iDecodeSize:LongInt;
    iComRc   : LongInt;
    iPacketNo: LongInt;

       // 자료수신
               {
       iComRc := fnTcpDataRecv(TSockID,lanRawBuff,iDecodeSize,iPacketNO);
       // 자료수신정상 Check
       case iComRc of
            gcCOMM_TERMINATE : // Connection Terminate => ReConnection
                  begin
                    DisplaynLog('terminate');
                    exit;
                  end;
            gcERROR_TIME_OUT,
            gcERROR_DATA_CONTEXT :
                  begin
                       // Send Main Error(통신이상 해당작업결과요망)
                      DisplaynLog('timeout');
                      continue;
                  end;
       end; // end case

       // 정상수신자료
       CharCharCpy(lanPbuff,lanRawBuff,iDecodeSize);
       lanPbuff[iDecodeSize] := #0;

DisplaynLog(Trim(lanPbuff));

       //------------------------
       // Type별 Check
       //------------------------
      if CharCharCmp(@lanPbuff[0],gcSTYPE_COM,3) = 0 then
      begin
         //----------------------------------------------------------------
         // 수수료계산 다했단다.
         CharCharCpy(FlanRawBuff, lanRawBuff, iDecodeSize);
         FlanRawBuff[iDecodeSize] := #0;

         Synchronize(OnRcvDataTrans);
         continue;
         //----------------------------------------------------------------
      end else
      if CharCharCmp(@lanPbuff[0],gcSTYPE_LOGN,3) = 0 then
      begin
         //----------------------------------------------------------------
         // 소켓 login접속 Ack
         CharCharCpy(FlanRawBuff, lanRawBuff, iDecodeSize);
         FlanRawBuff[iDecodeSize] := #0;

         //OnRcvDataLogin;
         continue;
         //----------------------------------------------------------------
      end else
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
      end;
               }
