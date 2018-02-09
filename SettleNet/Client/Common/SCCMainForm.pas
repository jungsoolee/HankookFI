//==============================================================================
//   SettleNet MainFrame
//==============================================================================
// System TrCode: 현재 9900번대 사용, 0000번대 사용할지 여부 생각
// PopupMenu가 MDI Child Form에서도 생성되는 문제 해결할 것

unit SCCMainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, DRWin32, ExtCtrls, DRAdditional, DRStandard, DRDock, DRToolbar,
  Menus, DRToolEtc, StdCtrls, Mask, Printers, ImgList, DRSHMQueue,
  SCCGlobalType, SCCTFGlobalType, SCCCmuGlobal, DRDialogs, DRCodeControl,
  FileCtrl, IniFiles, Buttons, ShellApi, ZipMstr19, CHILKATMAILLib2_TLB,
  OleCtrls, SHDocVw, Comobj;

type
  TTickerType = (ttRcvData);
  //---------------------------
  // SettleNet Hint
  //---------------------------
  TSCCHint = class(THintWindow)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
  end;

  //---------------------------
  //  Queue Read Thread
  //---------------------------
  TQueueReadThread = class(TThread)
  private
    FClientQueue : TDRSHMQueue;
    FNorMalFlag  : Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create;  
    destructor Destroy; override;
  end;

  //---------------------------
  // SettleNet MainFrame
  //---------------------------
  TMainFrame = class(TForm)
    DRDock_Main: TDRDock;
    DRStatusBar_Main: TDRStatusBar;
    DRMainMenu_Main: TDRMainMenu;
    DRToolbar_Sys: TDRToolbar;
    DRPanel_TreeView: TDRPanel;
    DRTreeView_SendRcv: TDRTreeView;
    DRPopupMenu_ShowForm: TDRPopupMenu;
    DRImage_BGLogo: TDRImage;
    DRPanel3: TDRPanel;
    DRLabel4: TDRLabel;
    DRLabel_TreeErrCnt: TDRLabel;
    DRToolbarBtn_Close: TDRToolbarBtn;
    DRToolbarBtn_PrintScreen: TDRToolbarBtn;
    DRToolbarBtn_UserToolBar: TDRToolbarBtn;
    DRPanel_MSQ: TDRPanel;
    DRImage_CompLogo: TDRImage;
    DRToolbar_SecType: TDRToolbar;
    DRPanel_SecType: TDRPanel;
    DRLabel1: TDRLabel;
    DRUserCodeCombo_SecType: TDRUserCodeCombo;
    DRToolbar_User: TDRToolbar;
    DRPrinterSetupDlg_Main: TDRPrinterSetupDialog;
    DRToolbarBtn_PrinterSetup: TDRToolbarBtn;
    DRImageList_Sys: TDRImageList;
    DRToolbarBtn_Decision: TDRToolbarBtn;
    Timer1: TTimer;
    DRToolbar_TR: TDRToolbar;
    DRPanel1: TDRPanel;
    DREdit_tr: TDREdit;
    Zip: TZipMaster19;
    procedure ClearToolBarList(pToolBarList: TList);
    procedure SetDefBtnInfoList(pRoleCode, pSecType: string; pBtnInfoList: TList);
    function  CreateMenu: boolean;
    procedure CreateCodeList;
    procedure BuildCodeList(pCodeTableNo: Integer);
    procedure FreeCodeList;
    procedure DisplayTicker(pTickerType: TTickerType; pMsg: string);
    procedure InitChildForm(pForm: TForm; pTrCode: Integer);
    procedure RunTran(pTrCode: Integer); virtual; abstract;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure PmnuClick(Sender: TObject);
    procedure MenuClick(Sender: TObject);
    procedure DRPopupMenu_ShowFormPopup(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DRStatusBar_MainDrawPanel(StatusBar: TDRStatusBar;
      Panel: TDRStatusPanel; const Rect: TRect);
    procedure DRUserCodeCombo_SecTypeCodeChange(Sender: TObject);
    procedure DRToolbarBtn_DecisionClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure DREdit_trEnter(Sender: TObject);
    procedure DREdit_trChange(Sender: TObject);
    procedure DREdit_trMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FClientInstance: TFarProc;
    FPrevClientProc: TFarProc;
    procedure ClientWndProc(var Message: TMessage);
    procedure OnRcvServerData(var msg: TMessage);        message WM_USER_TCPIP_CLIENT_LOGSND;
    procedure OnRcvRefreshCodeList(var msg: TMessage);   message WM_USER_REFRESH_CODELIST;
    procedure OnRcvRefreshGrpList(var msg: TMessage);    message WM_USER_REFRESH_GROUPLIST;
    procedure OnRcvMsmqResult(var msg: TMessage);        message WM_USER_MSMQ_RESULT;
    procedure OnRcvFaxResult(var msg: TMessage);         message WM_USER_FAX_RESULT;
    procedure OnRcvEMailResult(var msg: TMessage);       message WM_USER_EMAIL_RESULT;
    procedure OnRcvCreateForm(var msg: TMessage);        message WM_USER_CREATE_FORM;
    procedure OnRcvDisplayTicker(var msg: TMessage);     message WM_USER_DISPLAY_TICKER;
    procedure OnRcvEnableMenu(var msg: TMessage);        message WM_USER_ENABLE_MENU;
    procedure OnRcvDisableMenu(var msg: TMessage);       message WM_USER_DISABLE_MENU;
    procedure OnRcvResetToolBar(var msg: TMessage);      message WM_USER_RESET_TOOLBAR;
    procedure OnRcvRefreshGlobVar(var msg: TMessage);    message WM_USER_REFRESH_GLOBVAR;
    procedure OnRcvAccessControl(var msg: TMessage);     message WM_USER_ACCESS_CONTROL_CHEK;
    procedure OnRcvBFFormClose(var msg: TMessage);       message WM_USER_BF_FORM_CLOSE;

    Procedure WMCopyData(var Message:TMessage); message WM_COPYDATA;

    function InitHKCommDLL: boolean;

    function Runzip(sTarget: string): Boolean;
    procedure ZipStatus(Sender: TObject; details: TZMProgressDetails);
    function LogSendMail(pSender: string): boolean;
    function UserTrCheck : boolean;
    { Private declarations }
  public
    procedure PrintSettupShow;
    procedure AttachToWindowsMenu(iTrCode: integer);
    { Public declarations }
  end;

var
  SCCHint  : TSCCHint;                  // 사용자 정의 Hint
//  QueueReadThread : TQueueReadThread;   // Queue 읽어 처리하는 Thread
  MainFrame: TMainFrame;
  sExecPath: string;
  bZipBatchRun: Boolean;
  sZipFilePathName: string;
  OleWeb : oleVariant;

procedure HintSetUp(AOwner:TComponent);

implementation

{$R *.DFM}

uses
   SCCLib, SCCTFLib, SCCTcpIp, SCCDataModule, SCCCmuLib, SCCChildForm,
   SCCSRMgrFrame, SCBERegGroup,
   SCCAbout,          // About Form
   SCCUserToolBar,    // 사용자정의 ToolBar
   SCCUserInfo, UCrpe32, ADODB,       // 사용자 정보
   SCCSetup, DB; // 환경설정

const
   MAX_FORM_CNT = 10;     // 사용가능 MDI Child Form 갯수

var
   TickerMsg : String;  // Ticker Message
   bNormalClose : boolean;

//==============================================================================
//   Hint
//==============================================================================
procedure HintSetUp(AOwner:TComponent);
begin
   HintWindowClass := TSCCHint;
   HintWindowClass.Create(AOwner);
//   SCCHint := HintWindowClass.Create(AOwner);
end;

constructor TSCCHint.Create(AOwner:TComponent);
begin
   inherited Create(AOwner);
   ControlStyle := ControlStyle-[csOpaque];
   with Canvas do
   begin
      Font.Name := gcMainFontName;
      Font.Size := 9;
   end;
   Application.HintHidePause := 60000; // 60초
   Application.HintPause := 300;       // 0.3초
end;

destructor TSCCHint.Destroy;
begin
   inherited Destroy;
end;

//==============================================================================
//  Queue Read Thread
//==============================================================================
constructor TQueueReadThread.Create;
begin
  inherited Create(True); // thread생성되자 마자 실행안됨

  if not fnQueueOpen(FClientQueue,Trim(gvOprUsrNo)+'Client',gcClientQueueSize,False)then
  begin
    FNorMalFlag := False;
    Exit;
  end;
  FNormalFlag := True;
end;

destructor TQueueReadThread.Destroy;
begin
   inherited Destroy;
   if FClientQueue <> nil then fnQueueClose(FClientQueue);
//   QueueReadThread := nil;
end;

procedure TQueueReadThread.Execute;
var
   QLen : Integer;
   pSvrCli : ptSvrCliHead_R;
   faxResult : ptTFAXResult;
begin
   while True do
   begin
      if Terminated then Exit;   // Thread 종료

      Qlen := FClientQueue.DeQueue;  // Queue Read
      if (QLen <= 0) then        // 처리할 데이터 없는 경우
      begin
         Sleep(10);
         continue;
      end;
      pSvrCli := @FClientQueue.DQdata;
      if Trim(pSvrCli.CliHead.TrGbn) = gcSTYPE_MSQ then
      begin
        gvpTMSMQResult := @FClientQueue.DQdata[SizeOf(SvrCliHead_R)];
        SendMessage(gvMainFrameHandle, WM_USER_MSMQ_RESULT, 0, 0);

        //*** 수신 내역만 Ticker 처리
        if gf_StrToInt(Trim(gvpTMSMQResult.sRspCode)) = gcMSMQ_RSPF_RECV then
        begin
           TickerMsg := '[' + gf_SecTypeToName(gvpTMSMQResult.sSecCode) + ']'
                + ' ' + gf_PartyIdToName(gvpTMSMQResult.sPartyID)
                + ' ' + Trim(gvpTMSMQResult.sSeqNo)
                + '/' + Trim(gvpTMSMQResult.sSendTotSeq);
           SendMessage(gvMainFrameHandle, WM_USER_DISPLAY_TICKER,
               gcDISPLAY_TICKER_WPARAM_RECV, gcDISPLAY_TICKER_LPARAM_BLINK_ON);
           if Terminated then  Exit;  // Thread 종료
           sleep(50); //*** 자연스러운 방법을 생각해 보자
           SendMessage(gvMainFrameHandle, WM_USER_DISPLAY_TICKER,
               gcDISPLAY_TICKER_WPARAM_RECV, gcDISPLAY_TICKER_LPARAM_BLINK_OFF);
        end;
      end
      else if Trim(pSvrCli.CliHead.TrGbn) = gcSTYPE_MSG then
      begin
        TickerMsg := Char2Str(@FClientQueue.DQdata[Length(gcSTYPE_MSG)],
                             Qlen-Length(gcSTYPE_MSG));
        SendMessage(gvMainFrameHandle, WM_USER_DISPLAY_TICKER,
            gcDISPLAY_TICKER_WPARAM_ITMSG, gcDISPLAY_TICKER_LPARAM_BLINK_ON);
        if Terminated then  Exit;  // Thread 종료
        sleep(50);
        SendMessage(gvMainFrameHandle, WM_USER_DISPLAY_TICKER,
            gcDISPLAY_TICKER_WPARAM_ITMSG, gcDISPLAY_TICKER_LPARAM_BLINK_OFF);
      end
      else if Trim(pSvrCli.CliHead.TrGbn) = gcSTYPE_FAX then
      begin
        gvpTFAXResult := @FClientQueue.DQdata[SizeOf(SvrCliHead_R)];
        SendMessage(gvMainFrameHandle, WM_USER_FAX_RESULT, 0, 0);
{
        if gvRealLogYN = 'Y' then
        begin
           if  copy(FClientQueue.DQdata, 1, 3) = gcSTYPE_FAX then
           begin
             faxResult := ptTFAXResult(FClientQueue.DQdata + sizeof(SvrCliHead_R));
             gf_Log('TRACE>> SEND DATA [' +
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
      end
      else if Trim(pSvrCli.CliHead.TrGbn) = gcSTYPE_MEL then
      begin
        gvptEMailResult := @FClientQueue.DQdata[SizeOf(SvrCliHead_R)];
        SendMessage(gvMainFrameHandle, WM_USER_EMAIL_RESULT, 0, 0);
      end
   end;
end;

//------------------------------------------------------------------------------
//   DateRoad Logo Display
//------------------------------------------------------------------------------
procedure TMainFrame.ClientWndProc(var Message: TMessage);
//var
//   MyDc : hDC;
//   BGLeft, BGTop : Integer;
begin
{
   with Message do
   begin
      case Msg of
         WM_ERASEBKGND :
         begin
            CallWindowProc(FPrevClientProc, Clienthandle, Msg, Wparam, LParam);
            if DRPanel_TreeView.Visible then
               BGLeft := (ClientRect.Right - ClientRect.Left - DRPanel_TreeView.Width - DRImage_BGLogo.Picture.Width) div 2 + ClientRect.Left
            else
               BGLeft := (ClientRect.Right - ClientRect.Left - DRImage_BGLogo.Picture.Width) div 2 + ClientRect.Left;
            BGTop := (ClientRect.Bottom - ClientRect.Top - DRImage_BGLogo.Picture.Height - DRDock_Main.Height) div 2
                     + ClientRect.Top -20;
            MyDc:= TWMEraseBKGnd(Message).DC;
            //BitBlt(MyDC, ClientRect.Left, ClientRect.Top, ClientRect.Right, ClientRect.Bottom, DRImage_BGLogo.Picture.Bitmap.Canvas.Handle, 0, 0, NOTSRCERASE);
            BitBlt(MyDC, BGLeft, BGTop, DRImage_BGLogo.Picture.Width, DRImage_BGLogo.Picture.Height, DRImage_BGLogo.Picture.Bitmap.Canvas.Handle, 0, 0, SRCCOPY);
            Result := 1;
         end
         else
            Result := CallWindowProc(FPrevClientProc, Clienthandle, Msg, Wparam, LParam);
      end;  // end of case
   end;
}
end;

//------------------------------------------------------------------------------
//  Server에서 Message 수신
//------------------------------------------------------------------------------
procedure TMainFrame.OnRcvServerData(var Msg: TMessage);
begin
   case Msg.WParam of
      gcTCPIP_CLIENT_LOGSND_WPARAM_DISCONN :    // 접속 끊긴 상태
      begin
         if gf_ShowDlgMessage(0, mtConfirmation, 0, '서버와의 TCP접속이 끊어졌으므로 현재 프로그램은 종료됩니다.' ,
            [mbOK], 0) = idOK then
         begin
            //Application.Terminate;
            bNormalClose := false;
            close;
            Exit;
         end;
      end; // end of case
   end; // end of case
end;

//------------------------------------------------------------------------------
//  Refresh CodeList
//------------------------------------------------------------------------------
procedure TMainFrame.OnRcvRefreshCodeList(var Msg: TMessage);
var
   I : Integer;
begin
   // Refresh CodeList
   BuildCodeList(Msg.WParam);
   // BroadCasting
   for I := 0 to MDIChildCount -1 do
      PostMessage(MDIChildren[I].Handle, WM_USER_REFRESH_CODECONTROL, Msg.WParam, 0);
end;

//------------------------------------------------------------------------------
//  Refresh GroupList
//------------------------------------------------------------------------------
procedure TMainFrame.OnRcvRefreshGrpList(var msg: TMessage);
var
   I : Integer;
begin
   // BroadCasting
   for I := 0 to MDIChildCount -1 do
      PostMessage(MDIChildren[I].Handle, WM_USER_REFRESH_GROUPCONTROL, Msg.WParam, 0);
end;

//------------------------------------------------------------------------------
//  Receive WM_USER_MSMQ_RESULT
//------------------------------------------------------------------------------
procedure TMainFrame.OnRcvMsmqResult(var msg: TMessage);
var
   I : Integer;
begin
   // gcMSMQ_RESULT_RECV
   //**** 종목 갱신
   for I := 0 to MDIChildCount -1 do
       SendMessage(MDIChildren[I].Handle, WM_USER_MSMQ_RESULT, Msg.WParam, Msg.LParam);
end;

//------------------------------------------------------------------------------
//  Receive WM_USER_FAX_RESULT
//------------------------------------------------------------------------------
procedure TMainFrame.OnRcvFaxResult(var msg: TMessage);
var
   I : Integer;
begin
   for I := 0 to MDIChildCount -1 do
       SendMessage(MDIChildren[I].Handle, WM_USER_FAX_RESULT, Msg.WParam, Msg.LParam);
end;

//------------------------------------------------------------------------------
//  Receive WM_USER_EMAIL_RESULT
//------------------------------------------------------------------------------
procedure TMainFrame.OnRcvEMailResult(var msg: TMessage);
var
   I : Integer;
begin
   for I := 0 to MDIChildCount -1 do
       SendMessage(MDIChildren[I].Handle, WM_USER_EMAIL_RESULT, Msg.WParam, Msg.LParam);
end;

//------------------------------------------------------------------------------
// Receive WM_USER_CREATE_FORM
//------------------------------------------------------------------------------
procedure TMainFrame.OnRcvCreateForm(var msg: TMessage);
var
   TmpMenuItem: TComponent;
begin
   if msg.WParam > 0 then
   begin
      Try
         TmpMenuItem := TComponent.Create(nil);
         TmpMenuItem.Tag := msg.WParam;
         MenuClick(TmpMenuItem);
      Finally
         if Assigned(TmpMenuItem) then TmpMenuItem.Free;
      End;
   end;  // end of if   
end;

//------------------------------------------------------------------------------
// Receive WM_USER_ENABLE_MENU
//------------------------------------------------------------------------------
procedure TMainFrame.OnRcvEnableMenu(var msg: TMessage);
var
   I : Integer;
   TmpMenuItem : TMenuItem;
begin
   TmpMenuItem := nil;
   for I := 0 to DRMainMenu_Main.Items.Count -1 do
   begin
      TmpMenuItem := DrMainMenu_Main.Items[I];
      if Assigned(TmpMenuItem) then
         TmpMenuItem.Enabled := True;
   end;
   DRDock_Main.Enabled := True;
end;

//------------------------------------------------------------------------------
// Receive WM_USER_DISABLE_MENU
//------------------------------------------------------------------------------
procedure TMainFrame.OnRcvDisableMenu(var msg: TMessage);
var
   I : Integer;
   TmpMenuItem : TMenuItem;
begin
   TmpMenuItem := nil;
   for I := 0 to DRMainMenu_Main.Items.Count -1 do
   begin
      TmpMenuItem := DrMainMenu_Main.Items[I];
      if Assigned(TmpMenuItem) then
         TmpMenuItem.Enabled := False;
   end;
   DRDock_Main.Enabled := False;
end;

//------------------------------------------------------------------------------
// Receive WM_USER_DISPLAY_TICKER
//------------------------------------------------------------------------------
procedure TMainFrame.OnRcvDisplayTicker(var msg: TMessage);
var
   FontColor, BGColor : TColor;
begin
   if msg.LParam = gcDISPLAY_TICKER_LPARAM_BLINK_ON then
   begin
      case msg.WParam of
         gcDISPLAY_TICKER_WPARAM_RECV  :  // 수신자료
         begin
            FontColor := clNavy;
            BGColor   := $00FFE8DD;
         end;
         gcDISPLAY_TICKER_WPARAM_ITMSG :  // IT Message
         begin
            FontColor := clPurple;
            BGColor   := $00EFCFEA;
         end;
      end;  // end of case
      DRStatusBar_Main.Panels[1].Color := BGColor;
      DRStatusBar_Main.Panels[1].Font.Color := FontColor;
      DRStatusBar_Main.Panels[1].Text := ' ' + TickerMsg;
      DRStatusBar_Main.Repaint;
   end
   else  // Blink Off
   begin
      case msg.WParam of
         gcDISPLAY_TICKER_WPARAM_RECV  :  // 수신자료
         begin
            FontColor := clBlack;
            BGColor   := clSilver;
         end;
         gcDISPLAY_TICKER_WPARAM_ITMSG :  // IT Message
         begin
            FontColor := clPurple;
            BGColor   := clWhite;
         end;
      end;  // end of case
      DRStatusBar_Main.Panels[1].Color := BGColor;
      DRStatusBar_Main.Panels[1].Font.Color := FontColor;
      DRStatusBar_Main.Repaint;
   end;
end;

//------------------------------------------------------------------------------
// 결재버튼 클릭
//------------------------------------------------------------------------------
procedure TMainFrame.DRToolbarBtn_DecisionClick(Sender: TObject);
begin
   if Assigned(ActiveMDIChild) then
      SendMessage(ActiveMDIChild.Handle, WM_USER_REQUEST_DECISION, 0, 0);
end;

//------------------------------------------------------------------------------
//  Form Create
//------------------------------------------------------------------------------
procedure TMainFrame.FormCreate(Sender: TObject);
var
   I, iTextSaveDays : Integer;
   TmpPopupMenu : TMenuItem;
   sRoleName, sDefSecType, sUserGrpCode, sGetSecType : string;
   SR       : TSearchRec;
   Year, Month, Day : word;
   StdLogFile, sUDMDate, sAccessIp : string;
   CodeItem : pTCodeType;
   SecItem  : pTCodeItem;
   MenuItem : pTMenuInfo;
   InfoFile : TIniFile;
   ToolItem : pTUserToolBar;
   BtnItem  : pTBtnInfo;
   ScfSetupInfo : TIniFile;
   sMsg: string;
begin

gf_log('MainFrame: create start');
   bNormalClose := true;
   sAccessIp := '';

   Try
      Top    := 10;
      Left   := 10;
      Height := 785;
      Width  := 1015; //1180;//
      gvMainFrameHandle := Handle;
//  BackGround Image 출력시 사용 ***
{
      FClientInstance := MakeObjectInstance(ClientWndProc);
      FPrevClientProc := Pointer(GetWindowLong(Clienthandle, GWL_WNDPROC));
      SetWindowLong(ClientHandle, GWL_WNDPROC, LongInt(FClientInstance));
}


//데이터로드 or UAT환경에서 2tier 접속 Start ==============================================
   if gv2TierLoginYN = 'Y' then
   begin
     gvRoleCode := 'B';// RoleCode
     gvSplitMtd := ''; // Split Method
     gvDRSvrConnFlag := False;// DR Svr접속 여부
     gvTermNo := gvLocalIP;// Client단말번호
     gvSendMailFlag := True;  // MailSendFlag Setting

     //Party User ID
     gvPartyUserID := gf_ReturnStrQuery('select STR=isnull(max(DR_USER_ID),''dr1'') from SUDEFLT_TBL ');
     // 회사이름
     gvCompName  := gf_ReturnStrQuery('select STR=isnull(max(USER_NAME),''XX'') from SUDEFLT_TBL ');

     // 조작자이름
     gvOprUsrName := gf_ReturnStrQuery('select STR=isnull(max(USER_NAME),''XX'') from SUUSER_TBL where USER_ID = ''' + gvOprUsrNo +''' ');
{
     if gvOprUsrName = 'XX' then
     begin
       gf_ShowErrDlgMessage(0,0,
                   gvOprUsrNo + ' 사용자가 등록되어 있지 않음.  ' + #13#10 + #13#10 +
                   '사용자 등록 먼저하고 사용할 것.'+ #13#10 + #13#10 +
                   '확인사항 : SCDEPCD_TBL, SUDEPCD_TBL, SCPARTY_TBL, SUUSER_TBL'
                   ,0);
     end;
}
     //부서코드
     gvDeptCode   := gf_ReturnStrQuery('select STR=isnull(max(DEPT_CODE),''XX'') from SUUSER_TBL where USER_ID = ''' + gvOprUsrNo +''' ');

     // PARTY ID
     gvMyPartyID := gf_ReturnStrQuery('select STR=isnull(max(PARTY_ID),''XX'') from SCPARTY_TBL where USER_ID = '''+gvPartyUserID+'''');
     gvCompCode  := copy(gvMyPartyID,1,4);

     // 당일자
     gvCurDate := gf_ReturnStrQuery('select STR=rtrim(replace( convert(char(10),getdate(),121) ,''-'',''''))');

     // Stamp Sign 여부
     if 'Y' = gf_ReturnStrQuery('select STR=isnull(max(STAMP_YN),''Y'') from SUDEPCD_TBL where DEPT_CODE = '''+gvDeptCode+'''') then
       gvStampSignFlag := True
     else
       gvStampSignFlag := False;//True;
     // User Dept Name
     gvDeptName := gf_ReturnStrQuery('select STR=isnull(max(USER_DEPT_NAME_KOR),''XX'') from SUDEPCD_TBL where DEPT_CODE = '''+gvDeptCode+'''');

   end;//
//데이터로드 or UAT환경에서 2tier 접속 End   ==============================================

      //--- Variable
      gvMainFrame       := Self;
      gvDirDefault      := gf_GetAppRootPath;                // Default Directory
      gvDirTemp         := gf_GetAppRootPath + 'Temp\';      // Temp Directory
      gvDirRpt          := gf_GetAppRootPath + 'Rpt\';      // Rpt Directory
      gvDirResource     := gf_GetAppRootPath + 'Resource\';  // Resource Directory
      gvDirUserData     := gf_GetAppRootPath + 'UserData\';  // User Data Directory
      gvDirImport       := gf_GetAppRootPath + 'Import\';     // Import Directory
      gvDirExport       := gf_GetAppRootPath + 'Export\';     // Export Directory

      //--- Check Default Directory Exist
      gf_Log('Before Check Default Directory Exist');
      if not DirectoryExists(gvDirTemp) then
         if not CreateDir(gvDirTemp) then
         begin
            gf_Log('[E]Cannot Create ' + gvDirTemp);
            raise Exception.Create('Cannot Create ' + gvDirTemp);
         end;

      if not DirectoryExists(gvDirRpt) then
         if not CreateDir(gvDirRpt) then
         begin
            gf_Log('[E]Cannot Create ' + gvDirRpt);
            raise Exception.Create('Cannot Create ' + gvDirRpt);
         end;

      if not DirectoryExists(gvDirUserData) then
         if not CreateDir(gvDirUserData) then
         begin
            gf_Log('[E]Cannot Create ' + gvDirUserData);
            raise Exception.Create('Cannot Create ' + gvDirUserData);
         end;

      if not DirectoryExists(gvDirImport) then
         if not CreateDir(gvDirImport) then
         begin
            gf_Log('[E]Cannot Create ' + gvDirImport);
            raise Exception.Create('Cannot Create ' + gvDirImport);
         end;

      if not DirectoryExists(gvDirExport) then
         if not CreateDir(gvDirExport) then
         begin
            gf_Log('[E]Cannot Create ' + gvDirExport);
            raise Exception.Create('Cannot Create ' + gvDirExport);
         end;
      gf_Log('After Check Default Directory Exist');


//      gvOASYSXXX := gf_GetSystemOptionValue('XXX','N'); //2012-05-19 오아시스 사용여부 

      //--- User Data Directory File 삭제
      gf_Log('Before delete UserDataFiles');
      Try
         InfoFile := TIniFile.Create(gvDirUserData + 'UDMINF');
         sUDMDate := InfoFile.ReadString('INFO', 'DATE', '00000000');
         if sUDMDate <> gvCurDate then  // Directory 및 File 삭제
         begin
            {$I-}  // IO Error Checking Off
            if FindFirst(gvDirUserData + '*.*', faAnyFile, SR) = 0 then
               Repeat
                  if (SR.Name <> 'UDMINF') and  // Date File
                     (LowerCase(ExtractFileExt(SR.Name)) <> '.tmp') and    // .tmp (Text edit 보고서)
                     (SR.Name <> '.') and       // Root Dir
                     (SR.Name <> '..') then     // 상위 Dir
                    gf_DelDirectory(gvDirUserData + SR.Name);
               Until FindNext(SR) <> 0;
            FindClose(SR);
            {$I+}  // IO Error Checking On
            if IOResult <> 0 then  // Error 발생
               gf_Log('[E]Error in delete UserDataFiles');

            //Text Report 저장한 것 삭제하기(이미지 저장일수 만큼만 보관)
            {$I-}  // IO Error Checking Off

            iTextSaveDays := StrToInt(gf_GetSystemOptionValue('D01','1'));//fax image 보관일수
            if FindFirst(gvDirUserData + '*.tmp', faAnyFile, SR) = 0 then //.tmp는 .txt보고서 임시수정(edit)파일이다.
               Repeat
                 if (FileDateToDateTime(FileAge(gvDirUserData + SR.Name)) + iTextSaveDays)
                    < gf_StrToDateTime(gf_FormatDate(gvCurDate)) then
                 DeleteFile(gvDirUserData + SR.Name);
               Until FindNext(SR) <> 0;
            FindClose(SR);
            {$I+}  // IO Error Checking On
            if IOResult <> 0 then  // Error 발생
               gf_Log('[E]Error in delete UserDataFiles (Text Report)');
            InfoFile.WriteString('INFO', 'DATE', gvCurDate);

            //Upload 파일 삭제하기 : 7일 보관
            if gf_GetSystemOptionValue('I09','N') = 'N' then //dataroad 버튼 사용여부, 즉 한국증권에서만.
            begin
              {$I-}  // IO Error Checking Off
              if FindFirst(gvDirUserData + 'UP*.txt', faAnyFile, SR) = 0 then
                 Repeat
                   if (FileDateToDateTime(FileAge(gvDirUserData + SR.Name)) + 7)
                      < gf_StrToDateTime(gf_FormatDate(gvCurDate)) then
                   DeleteFile(gvDirUserData + SR.Name);
                 Until FindNext(SR) <> 0;
              FindClose(SR);
              {$I+}  // IO Error Checking On
              if IOResult <> 0 then  // Error 발생
                 gf_Log('[E]Error in delete Upload Files'); //결제정정 Upload파일삭제

              {$I-}  // IO Error Checking Off
              if FindFirst(gvDirUserData + 'RB*.txt', faAnyFile, SR) = 0 then
                 Repeat
                   if (FileDateToDateTime(FileAge(gvDirUserData + SR.Name)) + 7)
                      < gf_StrToDateTime(gf_FormatDate(gvCurDate)) then
                   DeleteFile(gvDirUserData + SR.Name);
                 Until FindNext(SR) <> 0;
              FindClose(SR);
              {$I+}  // IO Error Checking On
              if IOResult <> 0 then  // Error 발생
                 gf_Log('[E]Error in delete RB Upload Files'); //실적(Result of Business)Upload파일삭제

            end;
gf_log('MainFrame: bf Import file delete');
            //Import File 삭제하기 (7일만 보관)
            if gf_GetSystemOptionValue('I09','N') = 'N' then //dataroad 버튼 사용여부, 즉 한국증권에서만.
            begin
              {$I-}  // IO Error Checking Off
              if FindFirst(gvDirImport + '*.txt', faAnyFile, SR) = 0 then
                 Repeat
                   if (FileDateToDateTime(FileAge(gvDirImport + SR.Name)) + 7)
                      < gf_StrToDateTime(gf_FormatDate(gvCurDate)) then
                   DeleteFile(gvDirImport + SR.Name);
                 Until FindNext(SR) <> 0;
              FindClose(SR);
              {$I+}  // IO Error Checking On
              if IOResult <> 0 then  // Error 발생
                 gf_Log('[E]Error in delete ImportFiles ');
            end;
gf_log('MainFrame: bf dllin delete');
            //dllin 삭제하기 (7일만 보관)
            if gf_GetSystemOptionValue('I09','N') = 'N' then //dataroad 버튼 사용여부, 즉 한국증권에서만.
            begin
              {$I-}  // IO Error Checking Off
              if FindFirst(gvDirDefault + 'Bin\dllin*.txt', faAnyFile, SR) = 0 then
                 Repeat
                   if (FileDateToDateTime(FileAge(gvDirDefault + 'Bin\' + SR.Name)) + 7)
                      < gf_StrToDateTime(gf_FormatDate(gvCurDate)) then
                   DeleteFile(gvDirDefault + 'Bin\' + SR.Name);
                 Until FindNext(SR) <> 0;
              FindClose(SR);
              {$I+}  // IO Error Checking On
              if IOResult <> 0 then  // Error 발생
                 gf_Log('[E]Error in delete dllin Files ');
            end;

         end;
      Finally
         InfoFile.Free;
      End;
      gf_Log('After delete UserDataFiles');

      //--- Temp Direcory File 삭제
      gf_Log('Before delete TempFiles');
      {$I-}  // IO Error Checking Off
      if FindFirst(gvDirTemp + '*.*' , faAnyFile, SR) = 0 then
         Repeat
            DeleteFile(gvDirTemp + SR.Name);
         Until FindNext(SR) <> 0;
      FindClose(SR);
      {$I+}  // IO Error Checking On
      if IOResult <> 0 then  // Error 발생
         gf_Log('[E]Error in delete TempFiles');
      gf_Log('After delete TempFiles');

      //--- 30일이전의 Log File 삭제 20040820 in
      if gvLogFlag then  // Log File 생성시에만 적용
      begin
         gf_Log('Before delete LogFiles');
         DecodeDate(Date-30, Year, Month, Day);
         StdLogFile := 'SN' + gvRoleCode + 'Log' + FormatFloat('0000', Year) + FormatFloat('00', Month) + FormatFloat('00', Day) + '.Txt';
         {$I-}  // IO Error Checking Off
         if FindFirst(gvLogPath +  'SN' + gvRoleCode + 'Log' + '*.Txt', faAnyFile, SR) = 0 then
            Repeat
               if (SR.Name < StdLogFile + '.Txt' ) then
                  DeleteFile(gvLogPath + SR.Name);
            Until FindNext(SR) <> 0 ;
         FindClose(SR);
         {$I+}  // IO Error Checking On
         if IOResult <> 0 then  // Error 발생
            gf_Log('[E]Error in delete Logfiles');
         gf_Log('After delete LogFiles');
      end;

      //--- Hint 속성 변경
      HintSetUp(self);
      gf_Log('Setup Hint');
{   @@ Q no use .......... in 20040831
      //--- Crate Thread
      gf_Log('Before Create QueueReadThread');
      QueueReadThread := TQueueReadThread.Create;
      if QueueReadThread <> nil then
      begin
         if not QueueReadThread.FNorMalFlag then
         begin
           gf_Log('<E>Error in open QueueReadThread.');
           gf_Log('Application.Terminate.');

           bNormalClose := false;
           close;
           //Application.Terminate;
           Exit;
         end;
         QueueReadThread.FreeOnTerminate := False;
         QueueReadThread.Resume;
      end else
      begin
         gf_Log('<E>Error in creation QueueReadThread.');
         gf_Log('Application.Terminate.');
         bNormalClose := false;
         close;
//         Application.Terminate;
         Exit;
      end;
      gf_Log('After Create QueueReadThread');
}

      //add 20060419
      if (gvCompCode = 'B065')
      and (gvDeptCode = '01') then //이트레이드 일본주식
      begin
        gvETradeJapanYN := 'Y';
      end;

      gv02DeptDomYN := gf_GetSystemOptionValue('E03','N'); //02부서를 국제부대신 법인확장으로 사용여부

      //--- Create Code List
      gf_Log('Before create CodeList');
      CreateCodeList;
      gf_Log('After create CodeList');

      //--- 사용 업무  *** 차후 수정 생각
      DRUserCodeCombo_SecType.ClearItems;
      for I := 0 to gvSecTypeList.Count -1 do
      begin
         CodeItem := gvSecTypeList.Items[I];
         DRUserCodeCombo_SecType.AddItem(CodeItem.Code, CodeItem.Name);
      end;
      // Default 업무
      sDefSecType := gf_ReadFormStrInfo(gvRoleCode + gcCommonSection, 'SecType', '');
      if not DRUserCodeCombo_SecType.AssignCode(sDefSecType) then // Error
      begin
         if DRUserCodeCombo_SecType.CodeList.Count > 0 then
         begin
            SecItem := DRUserCodeCombo_SecType.CodeList.Items[0];  // Default - 첫번째
            DRUserCodeCombo_SecType.AssignCode(SecItem.Code);
         end
         else
         begin
            Raise Exception.Create('Default Securities Setting Error');
            Exit;
         end;
      end;  // end of if
      gvCurSecType := DRUserCodeCombo_SecType.Code;

      //--- Create MenuList;
      gvMenuList := TList.Create;
      if not Assigned(gvMenuList) then
      begin
         Raise Exception.Create('MenuList Create Error');
         Exit;
      end;

      //@@
      gvDirRptUseYN := gf_GetSystemOptionValue('S08','N') ;//Rpt사용시 Client PC에 저장된 Rpt 사용여부 Default N

      //ADMIN 사용자 여부
      //TF01,02.. User 나 Data01,02 User 만 "마감해제"같은 메뉴를  볼수 있게 하기 위해
      if (uppercase(copy(gvOprUsrNo,1,2)) = 'IT')
      or (uppercase(copy(gvOprUsrNo,1,2)) = 'TF')
      or (uppercase(copy(gvOprUsrNo,1,4)) = 'DATA') then
        gvTFAdminYN := 'Y'
      else
        gvTFAdminYN := 'N';

gf_log('MainFrame: bf menu query');
      with DataModule_SettleNet.ADOQuery_Main do
      begin
         Close;
         SQL.Clear;
         SQL.Add(' Select * From SUMENU_TBL ');
//         if gvETradeJapanYN = 'Y' then
//           SQL.Add(' where SEC_DETAIL_CODE = ''J'' ');
         //한국증권 추가 20061019 부서별 메뉴 제외
//         SQL.Add(' where isnull(EXCEPT_DEPT_CODE,'''') <> ''' + gvDeptCode + ''' ');
         SQL.Add(' where charindex( ''' + gvDeptCode + ''', isnull(EXCEPT_DEPT_CODE,'''')) = 0 ');

         SQL.Add(' Order By MENU_ID ');
         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

         while not Eof do
         begin
            if  (Trim(FieldByName('ADMIN_ONLY').asString) = 'Y')
            and (gvTFAdminYN <> 'Y' ) then
            begin
              Next;
              Continue;
            end;

            New(MenuItem);
            gvMenuList.Add(MenuItem);
            MenuItem.SecCode  := Trim(FieldByName('SEC_CODE').asString);
            MenuItem.MenuId   := Trim(FieldByName('MENU_ID').asString);
            MenuItem.MenuType := Trim(FieldByName('MENU_TYPE').asString);
            MenuItem.MenuName := Trim(FieldByName('MENU_NAME_KOR').asString);
            MenuItem.ShrtName := Trim(FieldByName('MENU_SHRT_KOR').asString);
            MenuItem.ParentId := Trim(FieldByName('PARENT_ID').asString);
            MenuItem.TrCode   := Trim(FieldByName('TR_CODE').asString);
            Next;
         end;  // end of while
      end;  // end of with
gf_log('MainFrame: af menu query');
      //--- Create Menu
      if not CreateMenu then
      begin
         Raise Exception.Create('Main Menu Create Error');
         Exit;
      end;

      //--- Create PopupMenu
      gf_Log('Before create Popup Menu');
      for I := 1 to MAX_FORM_CNT do
      begin
         TmpPopupMenu := TMenuItem.Create(Self);
         with TmpPopupMenu do
         begin
            Caption := '';
            Visible := False;
            Name := 'pmnu' + IntToStr(I);
            OnClick := PmnuClick;
            DRPopupMenu_ShowForm.Items.Add(TmpPopupMenu);
         end;
      end;
      gf_Log('After create Popup Menu');

      //--- Create ToolBar Button
      for I := 0 to gcMAX_USER_TOOLBTN -1 do
      begin
         gvUserToolBtn[I] := TDRToolbarBtn.Create(Self);
         gvUserToolBtn[I].Parent := DRToolbar_User;
         gvUserToolBtn[I].Height := 40;
         gvUserToolBtn[I].Width  := 63;
         gvUserToolBtn[I].Layout := blGlyphTop;
         gvUserToolBtn[I].Name   := 'DRToolbarBtn_User'+ IntToStr(I);
      end;

      //--- Create UserToolBarList
      gvUsrToolBarList := TList.Create;
      if not Assigned(gvUsrToolBarList) then
      begin
         Raise Exception.Create('UserToolBarList Create Error');
         Exit;
      end;

      with DataModule_SettleNet.ADOQuery_RepMain do
      begin
         Close;
         SQL.Clear;
         SQL.Add(' Select * From SUUSRTB_TBL '
               + ' Where USER_ID = ''' + gvOprUsrNo + ''' '
               + ' Order By SEC_TYPE, SEQ_NO ');
         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_RepMain);

         for I := 0 to gvSecTypeList.Count -1 do
         begin
            CodeItem  := gvSecTypeList.Items[I];
            New(ToolItem);
            gvUsrToolBarList.Add(ToolItem);
            ToolItem.SecType := CodeItem.Code;
            ToolItem.BtnInfoList := TList.Create;
            if not Assigned(ToolItem.BtnInfoList) then
            begin
               Raise Exception.Create('BtnInfoList Create Error');
               Exit;
            end;

            //--- Filtering
            Filtered := False;
            Filter   := 'SEC_TYPE = ''' + CodeItem.Code + ''' ';
            Filtered := True;

            if RecordCount > 0 then   // 사용자정의 ToolBar Data가 존재
            begin
               while not Eof do
               begin
                  New(BtnItem);
                  ToolItem.BtnInfoList.Add(BtnItem);
                  BtnItem.TrCode   := FieldByName('TR_CODE').asInteger;
                  BtnItem.ImageIdx := FieldByName('IMAGE_IDX').asInteger;
                  Next;
               end;  // end of while
            end
            else  // SettleNet Default ToolBar로 처리
               SetDefBtnInfoList(gvRoleCode, ToolItem.SecType, ToolItem.BtnInfoList);
         end;  // end of for I
          //--- Filter Clear
         Filtered := False;
         Filter   := '';
      end;  // end of with
gf_log('MainFrame: af USRTB');
      //--- 사용자 Authority
      gvUseTrCodeList := TStringList.Create;
      with DataModule_SettleNet.ADOQuery_Main do
      begin
         Close;
         SQL.Clear;
         SQL.Add(' Select USER_GRP_CODE '
               + ' From SUUSER_TBL '
               + ' Where USER_ID  = ''' + gvOprUsrNo + ''' ');
         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

         sUserGrpCode := Trim(FieldByName('USER_GRP_CODE').asString);
         if Trim(sUserGrpCode) <> '' then // 사용자 그룹 있음
         begin
            Close;   // 사용가능 화면 리스트 생성
            SQL.Clear;
            SQL.Add(' Select t.TR_CODE '
                  + ' From SUUGPTR_TBL t '
                  + ' Where t.DEPT_CODE = ''' + gvDeptCode + ''' '
                  + '   and t.USER_GRP_CODE = ''' + sUserGrpCode+ ''' ');
            gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

            while not Eof do
            begin
               gvUseTrCodeList.Add(Trim(FieldByName('TR_CODE').asString));
               Next;
            end;  // end of while
         end;  // end of if
      end;  // end of with
 gf_log('MainFrame: af UGPTR ');
      gf_ResetUserToolBar;       // 사용자정의 ToolBar 생성

      //--- 결재라인 사용여부 확인
      gf_RefreshGlobalVar(gcGLOB_GCUSE_DECLINE);

      //--- 메일관련 정보 Setting
      gf_RefreshGlobalVar(gcGLOB_GMAIL_INFO);
 gf_log('MainFrame: bf Printer set');
      try
        //--- Set Printer Info
        with gvPrinter do    // Printer Setup Variable
        begin
          //SettleNet 만의 Printer사용시
           if  (gvDefaultPrinterUseYN <> 'Y') //2007.05.23
           and (gf_ReadFormStrInfo(gcPrinterSection,gcPrinterNameKey,'') > '') then //등록한게 있다
           begin
              PrinterName := gf_ReadFormStrInfo(gcPrinterSection,gcPrinterNameKey,'');
              PrinterIdx := Printer.Printers.IndexOf(PrinterName);

              if PrinterIdx = gcNonePrinter then //기존 것을 못찾았다. 기본 프린터로 한다.
              begin
                PrinterIdx := Printer.PrinterIndex;
                PrinterName := Printer.Printers[Printer.PrinterIndex];
                if Printers.Printer.Orientation = poPortrait then
                begin
                  Orientation := poPortrait;
                  gf_WriteFormStrInfo(gcPrinterSection,gcOrientationKey,'P');
                end
                else
                begin
                  Orientation := poLandscape;
                  gf_WriteFormStrInfo(gcPrinterSection,gcOrientationKey,'L');
                end;
                Copies     := 1;
                gf_WriteFormStrInfo(gcPrinterSection,gcPrinterNameKey,PrinterName);
              end
              else //기존 등록한 것 찾았다
              begin
                Printers.Printer.PrinterIndex := PrinterIdx;
                if gf_ReadFormStrInfo(gcPrinterSection,gcOrientationKey,'P') = 'P' then
                begin
                  Orientation := poPortrait;
                  Printers.Printer.Orientation := poPortrait;
                end
                else
                begin
                  Orientation := poLandscape;
                  Printers.Printer.Orientation := poLandscape;
                end;
                Copies     := 1;
              end;

           end
           else //등록한게 없다
           begin
             if Printers.Printer.Printers.Count = 0 then  // 사용가능 Printer없음
             begin
                PrinterIdx  := gcNonePrinter;
                PrinterName := '';
                Orientation := poPortrait;
                Copies     := 1;
             end
             else  //사용가능 Printer있음. Default Printer사용.
             begin
                PrinterIdx := Printer.PrinterIndex;
                PrinterName := Printer.Printers[Printer.PrinterIndex];
                if Printers.Printer.Orientation = poPortrait then
                begin
                  Orientation := poPortrait;
                  gf_WriteFormStrInfo(gcPrinterSection,gcOrientationKey,'P');
                end
                else
                begin
                  Orientation := poLandscape;
                  gf_WriteFormStrInfo(gcPrinterSection,gcOrientationKey,'L');
                end;
                Copies     := 1;
                gf_WriteFormStrInfo(gcPrinterSection,gcPrinterNameKey,PrinterName);
             end;
           end;

  {
           if Printer.Printers.Count = 0 then  // 사용가능 Printer없음
           begin
              PrinterIdx  := gcNonePrinter;
              PrinterName := '';
           end
           else  //사용가능 Printer있음
           begin
              PrinterIdx := Printer.PrinterIndex;
              PrinterName := Printer.Printers[PrinterIdx];
           end;
           Copies     := 1;
           Orientation := poPortrait;
  }         
        end;
     Except on E: Exception do
        begin
           gf_WriteFormStrInfo(gcPrinterSection,gcPrinterNameKey,'');
           gf_ShowErrDlgMessage(0, 0, 'SettleNet에 설정된 Printer에 문제가 있습니다. ' + Chr(13)
                            + '해당 PC에 설치된 프린터를 확인하신후  SettleNet을 재시작기 바랍니다.' + chr(13)
                            + E.Message , 0);
           Halt;
        end;
     End;
gf_log('MainFrame: af Priter set');
      //--- Read Preview Percent
      gvPreviewPercent := gf_ReadFormIntInfo(gvRoleCode + gcCommonSection, 'Preview Percent', 100);
//      gvPreviewPercent := 100;

      sRoleName := gf_RoleCodeToName(gvRoleCode);

      Caption := 'SETTLE NET-' + sRoleName +
                 ' [' + gvCompName + ' ' + gvDeptName + ' ' + gvOprUsrName;

      if Trim(sUserGrpCode) <> '' then
         Caption := Caption + ' - ' + sUserGrpCode;
      Caption := Caption + ']';

      //2Tier 표시
      if gv2TierLoginYN = 'Y' then
        Caption := '[2T] ' + Caption + ' ' + gvDefaultDB;

      //폴더및 파일이름에 UAT일경우 UAT표시
      if Pos('UAT',UpperCase(Application.ExeName)) > 0 then
        Caption := '[UAT] ' + Caption;

      Application.Title := Caption;

   Except on E: Exception do
      begin
         gf_ShowErrDlgMessage(0, 0, 'MainFrame 생성 중 오류가 발생하여 프로그램을 종료합니다.' + Chr(13)
                          + E.Message , 0);
         Halt;
      end;
   End;

gf_log('MainFrame: bf etc db set1');
   //add 20050601
   gvDRUserID := gf_ReturnStrQuery('select STR = DR_USER_ID from SUDEFLT_TBL');
gf_log('MainFrame: bf etc db set2');

   //add 20050627
   if gf_GetSystemOptionValue('E01','N') = 'Y' then
   begin

     // [Y.K.J] 2012.01.06 부서별 주식/선물 구분 처리 방법 변경
     sGetSecType := gf_ReturnStrQuery(' SELECT STR = SEC_TYPE FROM SUDEPCD_TBL '
                                     +' WHERE DEPT_CODE = '''+ gvDeptCode +''' ');
     if (sGetSecType <> '') then
     begin
       DRUserCodeCombo_SecType.AssignCode(sGetSecType);
       DRUserCodeCombo_SecTypeCodeChange(nil);
     end;

     {if (gvDeptCode = '01') or (gvDeptCode = '02') or (gvDeptCode = '05') or (gvDeptCode = '06') then
     begin
       if DRUserCodeCombo_SecType.Code <> 'E' then
       begin
         DRUserCodeCombo_SecType.AssignCode ('E');
         DRUserCodeCombo_SecTypeCodeChange(nil);
       end
     end
     else
     if (gvDeptCode = '03') or (gvDeptCode = '04') then
     begin
       if DRUserCodeCombo_SecType.Code <> 'F' then
       begin
         DRUserCodeCombo_SecType.AssignCode ('F');
         DRUserCodeCombo_SecTypeCodeChange(nil);
       end
     end;}
   end;
gf_log('MainFrame: bf etc db set3');

  gvHostCallUseYN := gf_GetSystemOptionValue('HI5','N');//HostCall 연동 여부, dataroad N, 한국증권 Y, 하나대투 Y
//  gvHostGWUseYN   := gf_GetSystemOptionValue('HE5','N');//HostGW 사용 여부, Default N, 한국증권 N, 하나대투 Y
  if gf_GetSystemOptionValue('HXX','H') = 'D' then
    gvHostGWUseYN   := 'Y' //HostGW 사용 여부, Default N, 한국증권 N, 하나대투 Y
  else
    gvHostGWUseYN   := 'N';

    // 하나 증권 이면서 관리자 아이디 일때.. 허용된 IP에서만 접속 가능하게.. 데이터로드 test 환경 빼고
     if (gvHostGWUseYN = 'Y') and (Copy(gvLocalIP,1,11) <> '100.100.100') then
     begin
       // 관리자인지 체크
       if UserTrCheck then
       begin
         sAccessIp := gf_ReturnStrQuery('SELECT STR = NM FROM SUGRPCD_TBL WHERE GRP = ''18'' AND NM = ''' + gvLocalIP + ''' ');

         if (sAccessIp = '') then
         begin
            if gf_ShowDlgMessage(0, mtConfirmation, 0, '허용된 ip에서 접속하지 않았으므로 현재 프로그램은 종료됩니다.' ,
            [mbOK], 0) = idOK then
           begin
              Application.Terminate;
           end;
         end;
       end;
     end;


gf_log('MainFrame: bf etc db set4');

  gvOprEmpID := gf_ReturnStrQuery(' select STR=rtrim(EMP_ID) from SUUSER_TBL'
                                + ' where USER_ID = ''' + gvOprUsrNo + ''' ');

gf_log('MainFrame: bf etc db set5');

  if gf_GetSystemOptionValue('E05','N') = 'Y' then
  begin
    gfSetDWNeverUpload;
{ //아래는 파일 삭제 방법. 덜 멋스럽다.
    gf_Log('before delete DW20.exe');
    try
      if FileExists('C:\Program Files\Common Files\Microsoft Shared\DW\DW20.EXE') then
      begin
        deletefile('C:\Program Files\Common Files\Microsoft Shared\DW\DW20.EXE');
      end;
    except
      on E : Exception do
      begin
        gf_log('Delete DW20.exe Except:' + E.Message);
      end;
    end;
    gf_Log('before delete DW20.exe');
}
  end;

//------------------------------------------------------------------------------
// JP
// 엑셀파일 패스워드 사용여부
//------------------------------------------------------------------------------
  if gf_GetSystemOptionValue('E07','N') = 'Y' then
  begin
   ScfSetupInfo := TIniFile.Create(gvDirCfg + gcFormIniFileName);
   ScfSetupInfo.WriteString('Excel Option', 'E07', 'Y');
   ScfSetupInfo.WriteString('Excel Option', 'E08', gf_GetSystemOptionValue('E08','1234'));
   ScfSetupInfo.Free;
  end else
  begin
   ScfSetupInfo := TIniFile.Create(gvDirCfg + gcFormIniFileName);
   ScfSetupInfo.WriteString('Excel Option', 'E07', 'N');
   ScfSetupInfo.Free;
  end;

//------------------------------------------------------------------------------
//  한국증권 원장 시스템 연동 처리
//------------------------------------------------------------------------------
  if (gvHostGWUseYN = 'N') and     // 한국증권이면...
     (gvHostCallUseYN <> 'N') then // 데이터로드가 아니면...
  begin

    //----------------------------------
    gvMCALogFlag := True; // Log File 생성
    //----------------------------------
    gvRoleCode := 'B';
    gf_StartMCALog(gf_GetAppRootPath + 'Log/', 'MCALog');  // MCA Log File 초기화
    //gf_StartMCALog(gf_GetAppRootPath + 'Log/', 'SN' + gvRoleCode + 'MCALog');  // MCA Log File 초기화

    //--- 30일이전의 MCA Log File 삭제
    if gvMCALogFlag then  // Log File 생성시에만 적용
    begin
      gf_Log('Before delete MCALogFiles');
      DecodeDate(Date-30, Year, Month, Day);
      StdLogFile := 'MCALog'
                  + FormatFloat('0000', Year)
                  + FormatFloat('00'  , Month)
                  + FormatFloat('00'  , Day) + '.Txt';
      {$I-}  // IO Error Checking Off
      if FindFirst(gvLogPath +  'MCALog' + '*.Txt', faAnyFile, SR) = 0 then
        Repeat
          if (SR.Name < StdLogFile + '.Txt' ) then
            DeleteFile(gvLogPath + SR.Name);
        Until FindNext(SR) <> 0 ;
      FindClose(SR);
      {$I+}  // IO Error Checking On
      if IOResult <> 0 then  // Error 발생
        gf_Log('[E]Error in delete MCALogfiles');
      gf_Log('After delete MCALogFiles');
    end;

    //-- MCA DLL LOAD ----------------------------------------------------------
    if Not InitHKCommDLL then
    begin
      gf_Log('HK MCA DLL LOAD Failed.');
      Halt;
    end;
    gf_Log('HK MCA DLL LOAD OK. ' + IntToStr(m_hHKCommDLL));

    gf_Log('Before Connect DataBase[MCA DLL Load After]');
    //------------------------------------------------------------------------
    // !!!! HK MCA DLL을 로드하면 ADO 접속이 끊기는 현상 발생.
    //      그래서 다시 접속을 해준다.
    // [ADO] DATABASE 접속
    //------------------------------------------------------------------------
    with DataModule_SettleNet.ADOConnection_Main do
    begin
      if Connected then
        Connected := False;
      Connected := True;
    end;
    gf_Log('After Connect DataBase[MCA DLL Load After]');

    with DataModule_SettleNet.ADOQuery_Main do
    begin
      //-- MCA 접속 서버 정보 CALL. --------------------------------------------
      gf_Log('MCA 접속 서버 정보 CALL.');
      Close;
      SQL.Clear;
      SQL.Add('SELECT FTP_ADDR, PORT_NO, TR_CODE ');
      SQL.Add('FROM SUFTPIF_TBL ');
      SQL.Add('WHERE DEPT_CODE = ''00'' ');
      SQL.Add('  AND FTP_NAME = ''MCA SERVER'' ');
//      SQL.Add('  AND TR_CODE = '''+ IntToStr(Self.Tag) +''' ');

      Try
        gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
      Except
        on E: Exception do
        begin
          // Database 오류
          gf_Log('MCA INFO QUERY [SUFTPIF_TBL]');
          gf_ShowDlgMessage(0, mtError, 9001, 'MCA INFO QUERY [SUFTPIF_TBL]' + E.Message, [mbOK], 0); // Database 오류
          Halt;
        end;
      End;

      if RecordCount = 1 then
      begin
        // MCA 접속 IP
        gvMCAConnectIP   := Trim(FieldByName('FTP_ADDR').AsString);
        // MCA 접속 PORT
        gvMCAConnectPort :=     (FieldByName('PORT_NO').AsInteger);
      end else
      begin
        gf_Log('MCA 접속 정보를 가져올 수 없습니다. [SUFTPIF_TBL]');
        gf_ShowDlgMessage(0, mtError, 0, 'MCA 접속 정보를 가져올 수 없습니다. [SUFTPIF_TBL]', [mbOK], 0); // Database 오류
        Halt;
      end;

      //-- FTP 접속 서버 정보 CALL. --------------------------------------------
      gf_Log('FTP 접속 서버 정보 CALL.');
      Close;
      SQL.Clear;
      SQL.Add('SELECT FTP_ADDR, FTP_ID, FTP_PASSWD, FTP_PATH, PORT_NO, FTP_MODE ');
      SQL.Add('FROM SUFTPIF_TBL                    ');
      SQL.Add('WHERE DEPT_CODE = ''00''            ');
      SQL.Add('  AND FTP_NAME = ''FTP SERVER''     ');

      Try
        gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
      Except
        on E: Exception do
        begin
          gf_Log('FTP INFO QUERY [SUFTPIF_TBL]');
          gf_ShowDlgMessage(0, mtError, 9001, 'FTP INFO QUERY [SUFTPIF_TBL]' + E.Message, [mbOK], 0); // Database 오류
          Halt;
        end;
      End;

      if RecordCount = 1 then
      begin
        // FTP 접속 IP
        gvMCAFileFtpIP := Trim(FieldByName('FTP_ADDR').AsString);
        // FTP 접속 ID
        gvMCAFileFtpID := Trim(FieldByName('FTP_ID').AsString);
        // FTP 접속 PASSWD
        gvMCAFileFtpPW := Trim(FieldByName('FTP_PASSWD').AsString);
        // FTP 접속 경로
        gvMCAFileFtpPath := Trim(FieldByName('FTP_PATH').AsString);
        // FTP 접속 Port
        gvMCAFileFtpPort := FieldByName('PORT_NO').AsInteger;
        // FTP 접속 모드
        gvMCAFileFtpMode := Trim(FieldByName('FTP_MODE').AsString);
      end else
      begin
        gf_Log('FTP 접속 정보를 가져올 수 없습니다. [SUFTPIF_TBL]');
        gf_ShowDlgMessage(0, mtError, 0, 'FTP 접속 정보를 가져올 수 없습니다. [SUFTPIF_TBL]', [mbOK], 0); // Database 오류
        Halt;
      end;

    end; // with DataModule_SettleNet.ADOQuery_Main do

    gvMCAConnectYn := False; // MCA 서버 접속 유무

    gvMCAFtpFileList := TStringList.Create; // MCA 파일 생성 목록 저장

    //----------------------------------------------------------------------------
    // Connect MCA
    //----------------------------------------------------------------------------
    if Not gf_tf_HostMCAConnect(True, sMsg) then
    begin
      gf_ShowErrDlgMessage(Self.Tag,0, 'MCA 접속 에러.'
      + #13#10 + #13#10 + sMsg,0);
      //Exit;
      Halt;
    end;

    InitializeCriticalSection(gvMCACriticalSection);

  end; // if (gvHostGWUseYN = 'N') and (gvHostCallUseYN <> 'N') then

  gvMCIFtpFileList := TStringList.Create; // MCI 파일 생성 목록 저장 (하나)

  // PDF Engine 사용여부
  gvPDFEngineUseYn := gf_GetSystemOptionValue('F03','N');

  // Fax Report 파일 형식 (RPT, PDF)
  if (gvPDFEngineUseYn = 'Y') then
    gvFaxReportFileType := gcFILE_TYPE_PDF
  else
    gvFaxReportFileType := gcFILE_TYPE_RPT;

  // DR담당자 정보 가져오기
  gvDrMgrName := gf_ReturnStrQuery('select STR=isnull(max(DR.DR_MGR_NAME),'''')     '
                                 + 'from SUDEPCD_TBL DC, SUDRMGR_TBL DR          '
                                 + 'where DC.DEPT_CODE = ''' + gvDeptCode + '''  '
                                 + 'and   DC.DR_MGR_NAME = DR.DR_MGR_NAME ');
  gvDrPosition := gf_ReturnStrQuery('select STR=isnull(max(DR.DR_POSITION),'''')     '
                                 + 'from SUDEPCD_TBL DC, SUDRMGR_TBL DR          '
                                 + 'where DC.DEPT_CODE = ''' + gvDeptCode + '''  '
                                 + 'and   DC.DR_MGR_NAME = DR.DR_MGR_NAME ');
  gvDrMailAddr := gf_ReturnStrQuery('select STR=isnull(max(DR.DR_MAIL_ADDR),'''')     '
                                 + 'from SUDEPCD_TBL DC, SUDRMGR_TBL DR          '
                                 + 'where DC.DEPT_CODE = ''' + gvDeptCode + '''  '
                                 + 'and   DC.DR_MGR_NAME = DR.DR_MGR_NAME ');
  gvDrPhone := gf_ReturnStrQuery('select STR=isnull(max(DR.DR_PHONE),'''')     '
                                 + 'from SUDEPCD_TBL DC, SUDRMGR_TBL DR          '
                                 + 'where DC.DEPT_CODE = ''' + gvDeptCode + '''  '
                                 + 'and   DC.DR_MGR_NAME = DR.DR_MGR_NAME ');
  gvDrCellPhone := gf_ReturnStrQuery('select STR=isnull(max(DR.DR_CELL_PHONE),'''')     '
                                 + 'from SUDEPCD_TBL DC, SUDRMGR_TBL DR          '
                                 + 'where DC.DEPT_CODE = ''' + gvDeptCode + '''  '
                                 + 'and   DC.DR_MGR_NAME = DR.DR_MGR_NAME ');

  gvDRHP_URL := gf_GetSystemOptionInfo('E24', 'Y');
  gvDRHP_ID := gf_GetSystemOptionValue('E37','');
  gvDRHP_PW :=  gf_GetSystemOptionValue('E38','');

  //------------------------------------------------------------------------
  //파생일때, 아이콘 변경
  //------------------------------------------------------------------------
  if (gvCurSecType = gcSEC_FUTURES) then
  begin
    icon := TIcon.Create;
    DataModule_SettleNet.DRImageList_AppIcon.GetIcon(0, icon);
    Application.Icon := icon;
  end;

end;

//------------------------------------------------------------------------------
//   Form Close
//------------------------------------------------------------------------------
procedure TMainFrame.FormClose(Sender: TObject;  var Action: TCloseAction);
var
   I : Integer;
   MenuItem : pTMenuInfo;
   sMsg: string;
   sCurDate, sCurTime: string;
begin

   if bNormalClose then
   begin
      if gf_ShowDlgMessage(0, mtConfirmation, 0, '종료하시겠습니까?', [mbYes, mbNo], 0) = idYes then
         Action := caFree
      else
      begin
         Action := caNone;
         Exit;
      end;
   end;

   gf_Log('Start MainFrame Close');

   // SEC_TYPE 저장
   gf_WriteFormStrInfo(gvRoleCode + gcCommonSection, 'SecType', DRUserCodeCombo_SecType.Code);

   // Close All MDI Children Form
   gf_Log('Before Close MDIChildren');
   for I := 0 to MDIChildCount-1 do
      MDIChildren[I].Close;
   gf_Log('After Close MDIChildren');

   { @@ no use Q........... in 20040831
   // Kill QueueReadThread
   gf_Log('Before Kill QueueReadThread');
   fnThreadKilled(QueueReadThread, True);
   gf_Log('After Kill QueueReadThread');
   }
   // Close Tcp/Ip
   gf_Log('Before fnTcpIpClose');
   fnTcpIpClose;
   gf_Log('After fnTcpIpClose');

   // Free gvMenuList
   gf_Log('Before Free MenuList');
   if Assigned(gvMenuList) then
   begin
      for I := 0 to gvMenuList.Count -1 do
      begin
         MenuItem := gvMenuList.Items[I];
         Dispose(MenuItem);
      end;  // end of for
      gvMenuList.Free;
   end;  // end of if
   gf_Log('After Free MenuList');

   // Free gvUsrToolBarList
   gf_Log('Before Free UserToolBarList');
   if Assigned(gvUsrToolBarList) then
   begin
      ClearToolBarList(gvUsrToolBarList);
      gvUsrToolBarList.Free;
   end;
   gf_Log('After Free UserToolBarList');

   // Free gvUseTrCodeList
   if Assigned(gvUseTrCodeList) then
      gvUseTrCodeList.Free;
      
   // Free All CodeList
   gf_Log('Before Free CodeList');
   FreeCodeList;
   gf_Log('After Free CodeList');

//------------------------------------------------------------------------------
//  한국증권 원장 시스템 연동 DLL Free
//------------------------------------------------------------------------------
   if (gvHostGWUseYN = 'N') and      // 한국증권이면...
      (gvHostCallUseYN <> 'N')  then // 데이터로드가 아니면...
   begin
     //----------------------------------------------------------------------------
     // DisConnect MCA
     //----------------------------------------------------------------------------
     gf_tf_HostMCADisConnect(sMsg);

     // MCA DLL 해제
     m_pConnectMCAServer := nil;
     m_pRequestData := nil;
     m_pDisConnectMCAServer := nil;
     FreeLibrary(m_hHKCommDLL);
     gf_MCALog('MainFrame: HK MCA DLL Free.');

     gvMCAFtpFileList.Free; // FTP 대상 파일 목록 리스트 해제

     DeleteCriticalSection(gvMCACriticalSection);

     gf_EndMCALog;
   end;

   gvMCIFtpFileList.Free; // FTP 대상 파일 목록 리스트 해제

//==============================================================================
// 로그인기록 gcLogINF_inout
//==============================================================================
  sCurTime := gf_GetCurTime;
  sCurDate := gf_GetCurDate;
  gf_LogLstWrite(nil, gvDeptCode, gcLogINF_inout, gvOprUsrNo,
    sCurDate, '', sCurTime, gvLocalIP, '', '', 'LogIn/LogOut', 'U');

   gf_Log('Close MainFrame');
   gf_EndLog;
end;

//------------------------------------------------------------------------------
//  Create Main Menu
//------------------------------------------------------------------------------
function TMainFrame.CreateMenu: boolean;
var
   I : Integer;
   MenuInfo : pTMenuInfo;
   MenuItem, SubItem : TMenuItem;
   ParentItem : TComponent;
begin
   Result := False;

   DRMainMenu_Main.Items.Clear;  // Clear Main Menu

   for I := 0 to gvMenuList.Count -1 do
   begin
      MenuInfo := gvMenuList.Items[I];

      if (MenuInfo.SecCode <> 'C') and  // 공통메뉴/선택업무 아닌 경우
         (MenuInfo.SecCode <> gvCurSecType) then Continue;

      MenuItem := TMenuItem.Create(Self);
      MenuItem.Name := 'M' + MenuInfo.MenuId;

      if MenuInfo.MenuType = 'T' then  // Top Menu인 경우
      begin
          MenuItem.Caption := MenuInfo.MenuName;
          DRMainMenu_Main.Items.Add(MenuItem);
      end
      else  // Sub Menu인 경우
      begin
         // Set Caption
         if (MenuInfo.MenuType = 'M') or (MenuInfo.MenuType = 'S') then  // Medium Menu, System Menu
            MenuItem.Caption := MenuInfo.MenuName
         else if MenuInfo.MenuType = 'B' then  // Biz Menu
            MenuItem.Caption := '[' + MenuInfo.TrCode + '] ' + MenuInfo.MenuName
         else if MenuInfo.MenuType = 'L' then
            MenuItem.Caption := '-'
         else  // Error
            MenuItem.Caption := '';

         // Link OnClick Event
         if (MenuInfo.MenuType = 'S') or (MenuInfo.MenuType = 'B') then  // System Menu, Biz Menu
         begin
            MenuItem.Tag     := StrToIntDef(MenuInfo.TrCode, 0);
            MenuItem.OnClick := MenuClick;
         end;

         ParentItem := FindComponent('M' +  MenuInfo.ParentId + '00');
         if not Assigned(ParentItem) then Exit;  // Error
        (ParentItem as TMenuItem).Add(MenuItem);
      end;  // end of else
   end;  // end of for
   Result := True;
end;

//------------------------------------------------------------------------------
//   생성된 MDI Child 선택
//------------------------------------------------------------------------------
procedure TMainFrame.PmnuClick(Sender: TObject);
var
   I : Integer;
begin
   for I := 0 to MDIChildCount-1 do
   begin
      if MDIChildren[I].Caption = TMenuItem(Sender).Caption then
      begin
         if MDIChildren[I].WindowState <> wsNormal then
            MDIChildren[I].WindowState := wsNormal
         else
         begin
            ShowWindow(MDIChildren[I].Handle, SW_RESTORE);
            MDIChildren[I].BringToFront;
         end;
         Break;
      end;
   end;
end;

//------------------------------------------------------------------------------
//  Popup MDI Child List 생성
//------------------------------------------------------------------------------
procedure TMainFrame.DRPopupMenu_ShowFormPopup(Sender: TObject);
var
   I : Integer;
   TmpPopUpMenu : TComponent;
begin
   for I := 1 to MAX_FORM_CNT do
   begin
      TmpPopUpMenu := FindComponent('pmnu' + IntToStr(I));
      if TMenuItem(TmpPopUpMenu) <> Nil then
      begin
         with TMenuItem(TmpPopUpMenu) do
         begin
            Caption := '';
            Visible := False;
            Tag     := 0;
         end;
      end;
   end;

   for I := 1 To MDIChildCount do
   begin
       TmpPopUpMenu := FindComponent('pmnu' + IntToStr(I));
       if TMenuItem(TmpPopUpMenu) <> Nil then
       begin
          with TMenuItem(TmpPopUpMenu) do
          begin
             Caption := MDIChildren[I-1].Caption;
             Visible := True;
             Tag     := StrToInt(copy(MDIChildren[I-1].Caption, 2, 4));
          end;  // end of with
       end; // end of if
   end; // end of for
end;



//------------------------------------------------------------------------------
//  Menu Click
//------------------------------------------------------------------------------
procedure TMainFrame.MenuClick(Sender: TObject);
var
   I : Integer;
   TrCode : Integer;
   OldDefaultPrinter : string;
begin
   TrCode := (Sender as TComponent).Tag;
   if TrCode = 0 then Exit;  // 처리 사항 없는 경우

   if TrCode < 9900 Then     // 일반 업무 화면인 경우
   begin
      if gf_CheckUsableMenu(TrCode) = False then
      begin
         gf_ShowErrDlgMessage(0, 0, '해당 화면에 대한 권한이 없습니다.', 0);
         Exit;
      end;

      for I := 0 to MDIChildCount-1 do  // 하나의 화면만 실행
      begin
         if MDIChildren[I] <> nil then
         begin
            if MDIChildren[I].Tag = TrCode then
            begin
               if MDIChildren[I].WindowState <> wsNormal then
               begin
                  MDIChildren[I].WindowState := wsNormal;
                  if (MDIChildren[I].Active) and (Assigned(MDIChildren[I].OnActivate)) then
                     MDIChildren[I].OnActivate(MDIChildren[I]);
               end
               else
               begin
                  ShowWindow(MDIChildren[I].Handle, SW_RESTORE);
                  MDIChildren[I].BringToFront;
                  if (MDIChildren[I].Active) and (Assigned(MDIChildren[I].OnActivate)) then
                     MDIChildren[I].OnActivate(MDIChildren[I]);
               end;
               Exit;
            end;
         end;
      end;

      if MDIChildCount > (MAX_FORM_CNT -1) then
      begin
         gf_ShowErrDlgMessage(0, 0, '동시에 사용할 수 있는 화면의 최대 갯수(' + IntToStr(MAX_FORM_CNT)
                            + ')를 초과하였습니다.', 0);
         Exit;
      end;
      Screen.Cursor := crHourGlass;
      RunTran(TrCode);  // 업무 화면 실행
      Screen.Cursor := crDefault;
   end

   else  // 일반업무화면 외 다른처리를 하는 Submenu
   begin
      case TrCode of
         9901: begin   // 사용자 정보 관리
                  Application.CreateForm(TForm_UserInfo, Form_UserInfo);
                  Form_UserInfo.ShowModal;
               end;
         9902: begin  // Printer Setup
                  if gvDefaultPrinterUseYN = 'Y' then  //2007.05.23
                  begin
                    gf_ShowErrDlgMessage(0,0,
                    '해당 PC는 윈도우즈 기본 프린터만을 사용하도록 설정되어 있습니다.'
                    + #13#10 + #13#10 + '데이터로드에 문의하시기 바랍니다.',0);
                    Exit;
                  end;

                  if gvPrinter.PrinterName > '' then
                  begin
                    Printers.Printer.PrinterIndex := Printers.Printer.Printers.IndexOf(gvPrinter.PrinterName);
                    Printers.Printer.Orientation := gvPrinter.Orientation;
                  end;

                  if DRPrinterSetupDlg_Main.Execute then
                  begin
                     // Printer Setup Variable
                     if Printer.Printers.Count = 0 then  // 사용가능 Printer없음
                     begin
                        gvPrinter.PrinterIdx  := gcNonePrinter;
                        gvPrinter.PrinterName := '';
                        gvPrinter.Copies      := 1;
                        gvPrinter.Orientation := poPortrait;
                     end
                     else  //사용가능 Printer있음
                     begin
                        gvPrinter.PrinterIdx  := Printer.PrinterIndex;
                        gvPrinter.PrinterName := Printer.Printers[gvPrinter.PrinterIdx];
                        gvPrinter.Copies      := Printer.Copies;
                        gvPrinter.Orientation := Printer.Orientation;
                     end;

                    gf_WriteFormStrInfo(gcPrinterSection,gcPrinterNameKey,gvPrinter.PrinterName);
                    if Printer.Orientation = poPortrait then
                      gf_WriteFormStrInfo(gcPrinterSection,gcOrientationKey,'P')
                    else
                      gf_WriteFormStrInfo(gcPrinterSection,gcOrientationKey,'L');
                    end;  // end of if

               end;
         9903: //화면인쇄
               begin

                  if gvPrinter.PrinterName > '' then
                  begin
                    Printers.Printer.PrinterIndex := Printers.Printer.Printers.IndexOf(gvPrinter.PrinterName);
                    Printers.Printer.Orientation := gvPrinter.Orientation;
                  end;

                  if MDIChildCount > 0 then
                  begin
                     if gvPrinter.PrinterIdx = gcNonePrinter then //Printer가 연결되지 않은 경우
                     begin
                        gf_ShowErrDlgMessage(0, 0, '설정된 프린터가 없습니다.', 0);
                        Exit;
                     end;
                     Screen.Cursor := crHourGlass;

                     ActiveMDIChild.PrintScale := poPrintToFit;
                     ActiveMDIChild.Print ;
                     
                     Screen.Cursor := crDefault;
                  end
                  else
                     gf_ShowDlgMessage(0, mtInformation, 0, '출력할 화면이 없습니다.', [mbOk], 0);
{
                  if MDIChildCount > 0 then
                  begin
                     if gvPrinter.PrinterIdx = gcNonePrinter then //Printer가 연결되지 않은 경우
                     begin
                        gf_ShowErrDlgMessage(0, 0, '설정된 프린터가 없습니다.', 0);
                        Exit;
                     end;
                     Screen.Cursor := crHourGlass;
                     gf_PrintForm(ActiveMDIChild);
                     Screen.Cursor := crDefault;
                  end
                  else
                     gf_ShowDlgMessage(0, mtInformation, 0, '출력할 화면이 없습니다.', [mbOk], 0);
}
               end;
         9904: Close;  // 종료
         9905: begin   // 사용자 ToolBar
                  Application.CreateForm(TDlgForm_UserToolBar, DlgForm_UserToolBar);
                  DlgForm_UserToolBar.ShowModal;
               end;

         9906: begin // 환경설정
                  Application.CreateForm(TForm_Setup, Form_Setup);
                  Form_Setup.ShowModal;
               end;

         9911: begin
                  Cascade; //계단식 배열
                  for I := 0 to MDIChildCount-1 do
                  begin
                     if (MDIChildren[I] is TForm_SCF) then
                     begin
                        MDIChildren[I].Height := (MDIChildren[I] as TForm_SCF).DefFormHeight;
                        MDIChildren[I].Width := (MDIChildren[I] as TForm_SCF).DefFormWidth;
                     end
                     else if (MDIChildren[I] is TForm_SRMgrFrame) then
                     begin
                        MDIChildren[I].Height := (MDIChildren[I] as TForm_SRMgrFrame).DefFormHeight;
                        MDIChildren[I].Width := (MDIChildren[I] as TForm_SRMgrFrame).DefFormWidth;
                     end;
                  end;
               end;
         9912: Tile;  //바둑판식 배열
         9913: begin  //모든화면 닫기
                  for I := 0 to MDIChildCount-1 do
                      MDIChildren[I].Close;
               end;
         9921: begin  //About(Version Info)
                  Application.CreateForm(TForm_About, Form_About);
                  Form_About.ShowModal;
               end;
      9922: begin //원격지원
          if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 0, '원격지원 프로그램을 실행하시겠습니까?', mbOKCancel, 0) = idok then
          begin
            if FileExists(sExecPath + 'SupportMe.exe') then
            begin
              ShellExecute(0, nil, pChar(sExecPath + 'SupportMe.exe'), nil, '', sw_ShowNormal);
            end else
            begin
              ShowMessage('원격지원 프로그램이 존재하지 않습니다.');
            end;
          end;
        end;
      9923: begin // 클라이언트 로그 전송
          if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 0, 'Client로그를 데이터로드에 전송하시겠습니까?', mbOKCancel, 0) = idok then
          begin
            if not RunZip('C') then
            begin
              ShowMessage('Client 로그 압축파일 생성 실패');
              Exit;
            end;
            if not LogSendMail('C') then ShowMessage('Client 로그 전송실패') else ShowMessage('Client 로그 전송완료');
          end;
        end;
      9924: begin // 서버 로그 전송
          if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 0, 'Server로그를 데이터로드에 전송하시겠습니까?', mbOKCancel, 0) = idok then
          begin
            if not LogSendMail('S') then ShowMessage('Server 로그 전송실패') else ShowMessage('Server 로그 전송완료');
          end;
        end;
      9925: begin //자료실
          if gf_GetSystemOptionValue('E24', 'Y') = 'Y' then
          begin
            try
            OleWeb := CreateOleObject('InternetExplorer.Application');
            OleWeb.Visible := True;
            OleWeb.Navigate(gvDRHP_URL);
            while OleWeb.Busy or OleWeb.readystate <>  READYSTATE_COMPLETE do Sleep(100);
            OleWeb.Document.all.userid.Value := gvDRHP_ID;
            OleWeb.Document.all.passwd.Value := gvDRHP_PW;
            OleWeb.document.all.mail_login_form.submit;
            SetForegroundWindow(OleWeb.HWND);
            except
              ShowMessage('ID : ' + gvDRHP_ID + Chr(13) + 'PW : ' + gvDRHP_PW);
              Exit;
            end;
          end;
        end;
               {
         12345: begin
                 if not Assigned(DlgForm_ERegGroup) then
                 begin
                     Application.CreateForm(TDlgForm_ERegGroup, DlgForm_ERegGroup);
                 end;
                 DlgForm_ERegGroup.Show;
                end;
                }               
      end;  //end of Case
   end;
end;

procedure TMainFrame.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;

//------------------------------------------------------------------------------
//  Child Form Initialize
//------------------------------------------------------------------------------
procedure TMainFrame.InitChildForm(pForm: TForm; pTrCode: Integer);
var
   I : Integer;
   iWidth, iHeight: integer;
   BtnCnt, WidthDiff, WidthToCWidth : Integer;
   HeightDiff: Integer;
   MenuInfo : pTMenuInfo;
   sFormTitle : string;
begin
   // Set Form  Title
   sFormTitle   := '';

   WidthDiff:= 0;
   WidthToCWidth:= 0;
   BtnCnt:= 0;
   HeightDiff:= 0;
   for I := 0 to gvMenuList.Count -1 do
   begin
      MenuInfo := gvMenuList.Items[I];
      if MenuInfo.TrCode = IntToStr(pTrCode) then
      begin
         sFormTitle := MenuInfo.MenuName;
         break;
      end; // end of if
   end;  // end of for

   if (pForm is TForm_SCF) then  // 일반 Client Form
   begin
      (pForm as TForm_SCF).DefFormHeight := pForm.Height;
      (pForm as TForm_SCF).DefFormWidth  := pForm.Width;
//-----------------------------------------------------------------------------
     // [L.J.S] 테마 변경에 따른 Form 넓이 변화
     WidthDiff:= (pForm as TForm_SCF).ClientWidth;
     WidthToCWidth:=(pForm as TForm_SCF).Width - (pForm as TForm_SCF).ClientWidth;
     HeightDiff:= (pForm as TForm_SCF).ClientHeight;

     iWidth:= ((pForm as TForm_SCF).Width - WidthDiff);
     Inc(iWidth, -7);
     (pForm as TForm_SCF).ClientWidth:= (pForm as TForm_SCF).ClientWidth + iWidth;

     iHeight:= ((pForm as TForm_SCF).Height - HeightDiff);
     Inc(iHeight, -26);
     (pForm as TForm_SCF).ClientHeight:= (pForm as TForm_SCF).ClientHeight + iHeight;


     BtnCnt:= WidthToCWidth - 8;
     // [L.J.S] 상단 패널 버튼 정렬
     with (pForm as TForm_SCF).DRPanel_Top do begin
       for i:= 0 to (pForm as TForm_SCF).DRPanel_Top.ControlCount-1 do
       begin
         if (Controls[i] is TDRBitBtn) then
         begin
             TDRBitBtn(Controls[i]).Left:= TDRBitBtn(Controls[i]).Left - BtnCnt;
         end;
       end;
     end;
//------------------------------------------------------------------------------
      (pForm as TForm_SCF).Caption := '[' + IntToStr(pTrCode) + '] ' + sFormTitle;
      (pForm as TForm_SCF).DRPanel_Title.Caption := sFormTitle;
   end
   else if (pForm is TForm_SRMgrFrame) then
   begin
      (pForm as TForm_SRMgrFrame).DefFormHeight := pForm.Height;
      (pForm as TForm_SRMgrFrame).DefFormWidth  := pForm.Width;
      (pForm as TForm_SRMgrFrame).Caption := '[' + IntToStr(pTrCode) + '] ' + sFormTitle;
   end;
   pForm.Tag := pTrCode;
end;

//------------------------------------------------------------------------------
//  Display Ticker
//------------------------------------------------------------------------------
procedure TMainFrame.DisplayTicker(pTickerType: TTickerType; pMsg: string);
begin
   DRStatusBar_Main.Panels[1].Text := ' ' + pMsg;
   if pTickerType = ttRcvData then
   begin
      DRStatusBar_Main.Panels.Items[1].Font.Color := clNavy;
      DRStatusBar_Main.Panels.Items[1].Blink :=  True;
      DRStatusBar_Main.Panels.Items[1].BlinkCnt := 5;
   end;
end;

//------------------------------------------------------------------------------
//  Create Code List
//------------------------------------------------------------------------------
procedure TMainFrame.CreateCodeList;
begin
   gvRoleCodeList := TList.Create;
   gvSecTypeList  := TList.Create;
   gvMktTypeList  := TList.Create;
   gvTranMtdList  := TList.Create;
   gvComTypeList  := TList.Create;
   gvPartyIDList  := TList.Create;
   gvFundTypeList := TList.Create;
   gvSendMtdList  := TList.Create;
   gvTranCodeList := TList.Create;
   gvDeptCodeList := TList.Create;
   gvReportIDList := TList.Create;
   gvCompCodeList := TList.Create;

   gvEIssueList   := TList.Create;
   gvFIssueList   := TList.Create;

   if (not Assigned(gvRoleCodeList)) or (not Assigned(gvSecTypeList))  or
      (not Assigned(gvMktTypeList))  or (not Assigned(gvTranMtdList))  or
      (not Assigned(gvComTypeList))  or (not Assigned(gvPartyIDList))  or
      (not Assigned(gvFundTypeList)) or (not Assigned(gvSendMtdList))  or
      (not Assigned(gvTranCodeList)) or (not Assigned(gvDeptCodeList)) or
      (not Assigned(gvReportIDList)) or (not Assigned(gvEIssueList))   or
      (not Assigned(gvFIssueList)) then
   begin
      Raise Exception.Create('CodeList Create Error');
      Exit;
   end;

   // Add Data
   BuildCodeList(gcCODE_TABLE_ALL);
   // ^^ CodeList Clear는 하셨나요? (FormClose())
end;

//------------------------------------------------------------------------------
//  Build Code List
//------------------------------------------------------------------------------
procedure TMainFrame.BuildCodeList(pCodeTableNo: Integer);
procedure ClearNormalCodeList(pList: TList);
var
   I : Integer;
   CodeItem : pTCodeType;
begin
   for I := 0 to pList.Count -1 do
   begin
      CodeItem := pList.Items[I];
      Dispose(CodeItem);
   end;
   pList.Clear;
end;
var
   CodeItem   : pTCodeType;
   IssueItem  : pTIssueType;
   MgrItem    : pTManagerType;
   CompItem   : pTCompCodeType;
   ReportItem : pTReportType;
   I : Integer;
begin
   with DataModule_SettleNet.ADOQuery_Main do
   begin
      //=== ROLE_CODE (Component 없음)
      if (pCodeTableNo = gcCODE_TABLE_ALL) or  (pCodeTableNo = gcCODE_TABLE_SCROLE) then
      begin
         Close;
         SQL.Clear;
         SQL.Add('SELECT ROLE_CODE, ROLE_NAME_KOR FROM SCROLE_TBL');
         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
         ClearNormalCodeList(gvRoleCodeList);
         if RecordCount > 0 then
         begin
            while not EOF do
            begin
               New(CodeItem);
               CodeItem.Code := Trim(FieldByName('ROLE_CODE').asString);
               CodeItem.Name := Trim(FieldByName('ROLE_NAME_KOR').asString);
               gvRoleCodeList.Add(CodeItem);
               Next;
            end;
         end;
      end;

      //=== SEC_TYPE (Component 없음)
      if (pCodeTableNo = gcCODE_TABLE_ALL) or (pCodeTableNo = gcCODE_TABLE_SCSECTP) then
      begin
         Close;
         SQL.Clear;
         SQL.Add('SELECT SEC_TYPE, SEC_NAME_KOR FROM SCSECTP_TBL ');
         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
         ClearNormalCodeList(gvSecTypeList);
         if RecordCount > 0 then
         begin
            while not EOF do
            begin
               New(CodeItem);
               CodeItem.Code := Trim(FieldByName('SEC_TYPE').asString);
               CodeItem.Name := Trim(FieldByName('SEC_NAME_KOR').asString);
               gvSecTypeList.Add(CodeItem);
               Next;
            end;
         end;
      end;

      //=== MKT_TYPE (Component 없음)
      if (pCodeTableNo = gcCODE_TABLE_ALL) or (pCodeTableNo =gcCODE_TABLE_SCMKTTP) then
      begin
         Close;
         SQL.Clear;
         SQL.Add('SELECT MKT_TYPE, MKT_NAME_KOR FROM SCMKTTP_TBL ');
         SQL.Add('order by 2 ');
         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
         ClearNormalCodeList(gvMktTypeList);
         if RecordCount > 0 then
         begin
            while not EOF do
            begin
               New(CodeItem);
               CodeItem.Code := Trim(FieldByName('MKT_TYPE').asString);
               CodeItem.Name := Trim(FieldByName('MKT_NAME_KOR').asString);
               gvMktTypeList.Add(CodeItem);
               Next;
            end;
         end;
      end;

      //=== TRAN_MTD (Component 없음)
      if (pCodeTableNo = gcCODE_TABLE_ALL) or (pCodeTableNo = gcCODE_TABLE_SCTRMTD) then
      begin
         Close;
         SQL.Clear;
         SQL.Add('SELECT TRAN_MTD, TRAN_NAME_KOR FROM SCTRMTD_TBL ');
         SQL.Add('order by 2 ');
         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
         ClearNormalCodeList(gvTranMtdList);
         if RecordCount > 0 then
         begin
            while not EOF do
            begin
               New(CodeItem);
               CodeItem.Code := Trim(FieldByName('TRAN_MTD').asString);
               CodeItem.Name := Trim(FieldByName('TRAN_NAME_KOR').asString);
               gvTranMtdList.Add(CodeItem);
               Next;
            end;
         end;
      end;

      //=== COM_TYPE (Component 없음)
      if (pCodeTableNo = gcCODE_TABLE_ALL) or (pCodeTableNo = gcCODE_TABLE_SCCOMTP) then
      begin
         Close;
         SQL.Clear;
         SQL.Add('SELECT COM_TYPE, COM_NAME_KOR FROM SCCOMTP_TBL ');
         SQL.Add('order by 2 ');
         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
         ClearNormalCodeList(gvComTypeList);
         if RecordCount > 0 then
         begin
            while not EOF do
            begin
               New(CodeItem);
               CodeItem.Code := Trim(FieldByName('COM_TYPE').asString);
               CodeItem.Name := Trim(FieldByName('COM_NAME_KOR').asString);
               gvComTypeList.Add(CodeItem);
               Next;
            end;
         end;
      end;

      //=== Team_Code
      if (pCodeTableNo = gcCODE_TABLE_ALL) or (pCodeTableNo = gcCODE_TABLE_SETEMCD) then
      begin
         if gvRoleCode = gcROLE_INVESTOR then  // Investor인 경우
         begin
            Close;
            SQL.Clear;
            SQL.Add(' SELECT TEAM_CODE, TEAM_NAME_KOR FROM SETEMCD_TBL ');
            gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
            ClearNormalCodeList(gvTeamCodeList);
            if RecordCount > 0 then
            begin
               while not EOF do
               begin
                  New(CodeItem);
                  CodeItem.Code := Trim(FieldByName('TEAM_CODE').asString);
                  CodeItem.Name := Trim(FieldByName('TEAM_NAME_KOR').asString);
                  gvTeamCodeList.Add(CodeItem);
                  Next;
               end;
            end;
         end;
      end;

      //=== Fund_Type
      if (pCodeTableNo = gcCODE_TABLE_ALL) or (pCodeTableNo = gcCODE_TABLE_SCFTYPE) then
      begin
         Close;
         SQL.Clear;
         SQL.Add(' SELECT FUND_TYPE, FUND_NAME_KOR FROM SCFTYPE_TBL  ');
         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
         ClearNormalCodeList(gvFundTypeList);
         if RecordCount > 0 then
         begin
            while not EOF do
            begin
               New(CodeItem);
               CodeItem.Code    := Trim(FieldByName('FUND_TYPE').asString);
               CodeItem.Name    := Trim(FieldByName('FUND_NAME_KOR').asString);
               gvFundTypeList.Add(CodeItem);
               Next;
            end;
         end;
      end;

      //=== Send_Mtd
      if (pCodeTableNo = gcCODE_TABLE_ALL) or (pCodeTableNo = gcCODE_TABLE_SCSNDMT) then
      begin
         Close;
         SQL.Clear;
         SQL.Add(' SELECT SEND_MTD, MTD_NAME_KOR FROM SCSNDMT_TBL  ');
         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
         ClearNormalCodeList(gvSendMtdList);
         if RecordCount > 0 then
         begin
            while not EOF do
            begin
               New(CodeItem);
               CodeItem.Code    := Trim(FieldByName('SEND_MTD').asString);
               CodeItem.Name    := Trim(FieldByName('MTD_NAME_KOR').asString);
               gvSendMtdList.Add(CodeItem);
               Next;
            end;
         end;
      end;

      //=== Tran_Code
      if (pCodeTableNo = gcCODE_TABLE_ALL) or (pCodeTableNo = gcCODE_TABLE_SUTRNCD) then
      begin
         Close;
         SQL.Clear;
         SQL.Add(' SELECT TRAN_CODE, TRAN_NAME_KOR FROM SUTRNCD_TBL  ');
         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
         ClearNormalCodeList(gvTranCodeList);
         if RecordCount > 0 then
         begin
            while not EOF do
            begin
               New(CodeItem);
               CodeItem.Code := Trim(FieldByName('TRAN_CODE').asString);
               CodeItem.Name := Trim(FieldByName('TRAN_NAME_KOR').asString);
               gvTranCodeList.Add(CodeItem);
               Next;
            end;
         end;
      end;

      //=== Report_ID
      if (pCodeTableNo = gcCODE_TABLE_ALL) or (pCodeTableNo = gcCODE_TABLE_SCUREPID) then
      begin
         Close;
         SQL.Clear;
         SQL.Add(' Select REPORT_ID, REPORT_NAME_KOR, DIRECTION, '
               + '        TEXT_YN, REPORT_UNIT '
               + ' From   SUREPID_TBL          '
               + ' Where  DEPT_CODE = '''+ gvDeptCode +''' or  '
               + '        DEPT_CODE = '''+ gcDEPT_COMMON +''' ');   //공통으로 사용하는 보고서
         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

         for I := 0 to gvReportIDList.Count -1 do
         begin
            ReportItem := gvReportIDList.Items[I];
            Dispose(ReportItem);
         end;
         gvReportIDList.Clear;

         if RecordCount > 0 then
         begin
            while not EOF do
            begin
               New(ReportItem);
               ReportItem.ReportId   := Trim(FieldByName('REPORT_ID').asString);
               ReportItem.ReportName := Trim(FieldByName('REPORT_NAME_KOR').asString);
               ReportItem.Direction  := Trim(FieldByName('DIRECTION').asString);
               ReportItem.TextYn     := Trim(FieldByName('TEXT_YN').asString);
               ReportItem.ReportUnit := Trim(FieldByName('REPORT_UNIT').asString);
               gvReportIDList.Add(ReportItem);
               Next;
            end;
         end;
      end;

      //=== Dept_Code (* 주의사항 : SCPARTY_TBL 바뀔 경우에도 갱신됨)
      if (pCodeTableNo = gcCODE_TABLE_ALL) or (pCodeTableNo = gcCODE_TABLE_SCPARTY)
          or (pCodeTableNo = gcCODE_TABLE_SUDEPCD) then
      begin
         Close;
         SQL.Clear;
         SQL.Add(' SELECT s.DEPT_CODE, u.USER_DEPT_NAME_KOR '
            + ' FROM SCDEPCD_TBL s, SUDEPCD_TBL u, SCPARTY_TBL p '
            + ' WHERE SUBSTRING(p.PARTY_ID, 1, 4) = ''' + gvCompCode + ''''
            + '   AND SUBSTRING(p.PARTY_ID, 5, 2) = s.DEPT_CODE '
            + '   AND s.DEPT_CODE *= u.DEPT_CODE '
            + ' ORDER BY u.USER_DEPT_NAME_KOR ');
         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
         ClearNormalCodeList(gvDeptCodeList);
         if RecordCount > 0 then
         begin
            while not EOF do
            begin
               New(CodeItem);
               CodeItem.Code := Trim(FieldByName('DEPT_CODE').asString);
               CodeItem.Name := Trim(FieldByName('USER_DEPT_NAME_KOR').asString);
               gvDeptCodeList.Add(CodeItem);
               Next;
            end;
         end;
      end;

      //=== ISSUE_CODE
      if (pCodeTableNo = gcCODE_TABLE_ALL) or (pCodeTableNo = gcCODE_TABLE_SCISSIF) then
      begin
         Close;
         SQL.Clear;

         SQL.Add(' SELECT ISSUE_CODE, ISSUE_FULL_CODE, SEC_TYPE, '
               + '        ISSUE_NAME_KOR, ISSUE_FULL_KOR '
               + ' FROM SCISSIF_TBL with (NOLOCK)'
               + ' where not (SEC_TYPE in (''F'',''O'') and EXPIRE_DATE < ''' + copy(gf_GetCurDate,1,6) + ''') ' //만기지난 것 제외
               );
         SQL.Add(' ORDER BY ISSUE_CODE ');

         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

         //--- 주식 종목 코드
         Filtered := False;
         Filter   := 'SEC_TYPE = ''' + gcSEC_EQUITY + ''' ';
         Filtered := True;

         for I := 0 to gvEIssueList.Count -1 do
         begin
            IssueItem := gvEIssueList.Items[I];
            Dispose(IssueItem);
         end;
         gvEIssueList.Clear;

         if RecordCount > 0 then
         begin
            while not EOF do
            begin
               New(IssueItem);
               IssueItem.Code := Trim(FieldByName('ISSUE_CODE').asString);
               IssueItem.FullCode := Trim(FieldByName('ISSUE_FULL_CODE').asString);
               IssueItem.FullName := Trim(FieldByName('ISSUE_FULL_KOR').asString);
               IssueItem.ShrtName := Trim(FieldByName('ISSUE_NAME_KOR').asString);
               gvEIssueList.Add(IssueItem);
               Next;
            end;
         end;

         //--- 선물 종목 코드
         Filtered := False;
         Filter   := 'SEC_TYPE = ''' + gcSEC_FUTURES +
                     ''' or SEC_TYPE = ''' + gcSEC_OPTION + ''' ';  
         Filtered := True;

         for I := 0 to gvFIssueList.Count -1 do
         begin
            IssueItem := gvFIssueList.Items[I];
            Dispose(IssueItem);
         end;
         gvFIssueList.Clear;

         if RecordCount > 0 then
         begin
            while not EOF do
            begin
               New(IssueItem);
               IssueItem.Code := Trim(FieldByName('ISSUE_CODE').asString);
               IssueItem.FullCode := Trim(FieldByName('ISSUE_FULL_CODE').asString);
               IssueItem.FullName := Trim(FieldByName('ISSUE_FULL_KOR').asString);
               IssueItem.ShrtName := Trim(FieldByName('ISSUE_NAME_KOR').asString);
               gvFIssueList.Add(IssueItem);
               Next;
            end;
         end;

         //--- Filter Clear
         Filtered := False;
         Filter   := '';
      end;

      //=== PARTY_ID
      if (pCodeTableNo = gcCODE_TABLE_ALL) or (pCodeTableNo = gcCODE_TABLE_SCPARTY) then
      begin
         Close;
         SQL.Clear;
         SQL.Add(' SELECT PARTY_ID, PARTY_NAME_KOR '
               + ' FROM SCPARTY_TBL  '
               + ' ORDER BY PARTY_NAME_KOR ' );
         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

         // Clear CodeList
         for I := 0 to gvPartyIDList.Count -1 do
         begin
            CodeItem := gvPartyIDList.Items[I];
            Dispose(CodeItem);
         end;
         gvPartyIDList.Clear;

         if RecordCount > 0 then
         begin
            while not EOF do
            begin
               New(CodeItem);
               CodeItem.Code := Trim(FieldByName('PARTY_ID').asString);
               CodeItem.Name := Trim(FieldByName('PARTY_NAME_KOR').asString);
               gvPartyIDList.Add(CodeItem);
               Next;
            end;
         end;
      end;

      if (pCodeTableNo = gcCODE_TABLE_ALL) or  (pCodeTableNo = gcCODE_TABLE_SUCOMCD) then
      begin
         Close;
         SQL.Clear;
         SQL.Add(' Select sc.COMP_CODE, sc.COMP_NAME_KOR, sc.MEM_YN '
               + ' From SCCOMCD_TBL sc, SUCOMCD_TBL uc '
               + ' Where sc.COMP_CODE = uc.COMP_CODE '
               + '   and uc.DEPT_CODE = ''' + gvDeptCode + ''' '
               + ' Order By sc.COMP_NAME_KOR ');
         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

         // Clear CompCodeList
         for I := 0 to gvCompCodeList.Count -1 do
         begin
            CompItem := gvCompCodeList.Items[I];
            Dispose(CompItem);
         end;  // end of for
         gvCompCodeList.Clear;

         if RecordCount > 0 then
         begin
            while not EOF do
            begin
               New(CompItem);
               CompItem.Code    := Trim(FieldByName('COMP_CODE').asString);
               CompItem.Name    := Trim(FieldByName('COMP_NAME_KOR').asString);
               CompItem.MemYN   := Trim(FieldByName('MEM_YN').asString);
               gvCompCodeList.Add(CompItem);
               Next;
            end;
         end;  // end of if
      end;  // end of if (pCodeTableNo = gcCODE_TABLE_SUCOMCD)
   end; // end of with
end;

//------------------------------------------------------------------------------
//   Free Code List
//------------------------------------------------------------------------------
procedure TMainFrame.FreeCodeList;
procedure FreeNormalCodeList(pList: TList);
var
   I : Integer;
   CodeItem : pTCodeType;
begin
   for I := 0 to pList.Count -1 do
   begin
      CodeItem := pList.Items[I];
      Dispose(CodeItem);
   end;
   pList.Free;
end;
var
   I : Integer;
   MgrItem   : pTManagerType;
   IssueItem : pTIssueType;
   CompItem  : pTCompCodeType;
begin
   //=== 공통
   if Assigned(gvRoleCodeList) then FreeNormalCodeList(gvRoleCodeList);
   if Assigned(gvSecTypeList)  then FreeNormalCodeList(gvSecTypeList);
   if Assigned(gvMktTypeList)  then FreeNormalCodeList(gvMktTypeList);
   if Assigned(gvTranMtdList)  then FreeNormalCodeList(gvTranMtdList);
   if Assigned(gvComTypeList)  then FreeNormalCodeList(gvComTypeList);
   if Assigned(gvSendMtdList)  then FreeNormalCodeList(gvSendMtdList);
   if Assigned(gvFundTypeList) then FreeNormalCodeList(gvFundTypeList);
   if Assigned(gvTranCodeList) then FreeNormalCodeList(gvTranCodeList);
   if Assigned(gvDeptCodeList) then FreeNormalCodeList(gvDeptCodeList);
   if Assigned(gvReportIDList) then FreeNormalCodeList(gvReportIDList);
   if Assigned(gvPartyIDList)  then FreeNormalCodeList(gvPartyIDList);

   //=== Investor
   if Assigned(gvTeamCodeList) then FreeNormalCodeList(gvTeamCodeList);

   //=== 공통

   if Assigned(gvEIssueList) then
   begin
      for I := 0 to gvEIssueList.Count -1 do
      begin
         IssueItem := gvEIssueList.Items[I];
         Dispose(IssueItem);
      end;
      gvEIssueList.Free;
   end;

   if Assigned(gvFIssueList) then
   begin
      for I := 0 to gvFIssueList.Count -1 do
      begin
         IssueItem := gvFIssueList.Items[I];
         Dispose(IssueItem);
      end;
      gvFIssueList.Free;
   end;

   if Assigned(gvCompCodeList) then
   begin
      for I := 0 to gvCompCodeList.Count -1 do
      begin
         CompItem := gvCompCodeList.Items[I];
         Dispose(CompItem);
      end;
      gvCompCodeList.Free;
   end;
end;

//------------------------------------------------------------------------------
//  StatusBar Display
//------------------------------------------------------------------------------
procedure TMainFrame.DRStatusBar_MainDrawPanel(StatusBar: TDRStatusBar;
  Panel: TDRStatusPanel; const Rect: TRect);
var
   SRect, DRect : TRect;
begin
 {  if Panel.Index = 2 then  // Display DataRoad Logo
   begin
      with StatusBar.Canvas do
      begin
         SRect := Classes.Rect(0, 0, DRImage_CompLogo.Picture.Bitmap.Width,
                                        DRImage_CompLogo.Picture.Bitmap.Height);
         DRect.Left := Rect.Left + 1;
         DRect.Top  := Rect.Top + (Rect.Bottom - Rect.Top - DRImage_CompLogo.Picture.Bitmap.Height) div 2;
         DRect.Right := DRect.Left + SRect.Right + 1;
         DRect.Bottom := DRect.Top + SRect.Bottom;
         BrushCopy(DRect, DRImage_CompLogo.Picture.Bitmap, SRect, clBackground);
      end;
   end;  }
end;

procedure TMainFrame.DRUserCodeCombo_SecTypeCodeChange(Sender: TObject);
var
   I : Integer;
begin
   gvCurSecType := DRUserCodeCombo_SecType.Code;

   // 기존의 화면 Close
   for I := 0 to MDIChildCount-1 do
      MDIChildren[I].Close;

   CreateMenu;  // Menu 재구성

   gf_ResetUserToolBar;  // ToolBar 재구성
end;

//------------------------------------------------------------------------------
//  ToolBar 재구성
//------------------------------------------------------------------------------
procedure TMainFrame.OnRcvResetToolBar(var msg: TMessage);
var
   I, K : Integer;
   ToolItem : pTUserToolBar;
   BtnItem  : pTBtnInfo;
   sFullName, sShrtName : string;
begin
   // Clear ToolBar Button
   for I := 0 to gcMAX_USER_TOOLBTN -1 do
   begin
      gvUserToolBtn[I].Caption    := '';
      gvUserToolBtn[I].Hint       := '';
      gvUserToolBtn[I].ShowHint   := False;
      gvUserToolBtn[I].Tag        := 0;
      gvUserToolBtn[I].ImageIndex := -1;
      gvUserToolBtn[I].Visible    := False;
   end;

   //--- 사용자정의 ToolBar
   for I := 0 to gvUsrToolBarList.Count -1 do
   begin
      ToolItem := gvUsrToolBarList.Items[I];
      if ToolItem.SecType = gvCurSecType then
      begin
         for K := 0 to ToolItem.BtnInfoList.Count -1 do
         begin
            BtnItem := ToolItem.BtnInfoList.Items[K];
            gf_TrCodeToMenuName(BtnItem.TrCode, sFullName, sShrtName);
            gvUserToolBtn[K].Caption    := sShrtName;
            gvUserToolBtn[K].Hint       := sFullName;
            gvUserToolBtn[K].ShowHint   := True;
            gvUserToolBtn[K].Tag        := BtnItem.TrCode;
            gvUserToolBtn[K].Images     := DataModule_SettleNet.DRImageList_User;
            gvUserToolBtn[K].ImageIndex := BtnItem.ImageIdx;
            gvUserToolBtn[K].OnClick    := MenuClick;
            gvUserToolBtn[K].Visible    := True;
         end;  // end of for K
      end;  // end of if
   end; // end of for I
   DRToolbar_User.Visible :=  gvUserToolBtn[0].Visible;
end;

//------------------------------------------------------------------------------
//  Global 변수 관련 Table 수정시 변수 갱신
//------------------------------------------------------------------------------
procedure TMainFrame.OnRcvRefreshGlobVar(var msg: TMessage);
begin
   case msg.WParam of
      gcGLOB_GCPREVIEW_PERCENT :  // Report Preview Percent
      begin
         gvPreviewPercent := msg.LParam
      end;

      gcGLOB_GCUSE_DECLINE :      // 결재 라인 사용 여부
      begin
         with DataModule_SettleNet.ADOQuery_Main do
         begin
            Close;
            SQL.Clear;
            SQL.Add(' Select DEC_LEVEL '
                  + ' From SUDECLN_TBL '
                  + ' Where DEPT_CODE = ''' + gvDeptCode + ''' ');
            gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

            if RecordCount > 0 then   // 결재라인 사용
            begin
               gvUseDecLine := True;
               DRToolbarBtn_Decision.Enabled := True;
            end
            else
            begin
               gvUseDecLine := False;
               DRToolbarBtn_Decision.Enabled := False;
               //이하 20061010추가
               DRToolbarBtn_Decision.Visible := False;
               DRToolbar_User.DockPos := DRToolbar_User.Left - DRToolbarBtn_Decision.Width;
               DRToolbar_User.Left := DRToolbar_User.Left - DRToolbarBtn_Decision.Width;
            end;
         end;  // end of with
      end;

      gcGLOB_GMAIL_INFO :         // 메일전송자명, 리턴메일주소
      begin
         with DataModule_SettleNet.ADOQuery_Main do
         begin
            Close;
            SQL.Clear;
            SQL.Add(' select MAIL_USER_NAME, MAIL_ADDR, MAIL_TAIL '
                  + ' from SUMYINF_TBL '
                  + ' where USER_ID = ''' + gvOprUsrNo + ''' ');
            gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

            gvMailOprName  := gvOprUsrName;
            gvRtnMailAddr  := '';
            gvMailTail     := '';
            if RecordCount > 0 then   // 등록정보 존재
            begin
               if Trim(FieldByName('MAIL_USER_NAME').asString) <> '' then
                  gvMailOprName := Trim(FieldByName('MAIL_USER_NAME').asString);
               gvRtnMailAddr  := Trim(FieldByName('MAIL_ADDR').asString);
               gvMailTail     := Trim(FieldByName('MAIL_TAIL').asString);
            end  // end of if
         end;  // end of with
      end;
   end;  // end of case
end;


//------------------------------------------------------------------------------
//  Access Control 관련 처리
//------------------------------------------------------------------------------
procedure TMainFrame.OnRcvAccessControl(var msg: TMessage);
var
   J, K, L : Integer;
   accessYN, sDate, tDate : string;
begin
// access control 관련 처리
   with DataModule_SettleNet.ADOQuery_Main do
   begin
      Close;
      SQL.Clear;
      SQL.Add(' SELECT ISNULL(ACONT_YN, ''N'') AS ACONT_YN, '
            + '   ISNULL(PWCHGE_GIGAN,0) AS PWCHGE_GIGAN '
            + '   FROM SUACCCON_TBL ');
      gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);

      accessYN := Trim(FieldByName('ACONT_YN').asString);
      K := FieldByName('PWCHGE_GIGAN').asInteger;

      if accessYN = 'Y' then // access control 사용
      begin
          Close;
          SQL.Clear;
          SQL.Add(' SELECT ISNULL(PWCHGE_DATE,''00000000'') AS PWCHGE_DATE, '
                + '        ISNULL(FIRST_FLAG, ''N'') AS FIRST_FLAG          '
                + '   FROM SUUSER_TBL                                       '
                + '  WHERE USER_ID = ''' + gvOprUsrNo + ''' ');
          gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
          sDate := FieldByName('PWCHGE_DATE').asString;
          tDate := gf_GetCurDate;
          J := gf_Getstgigan(sDate, tDate);
          if J >= K Then
          begin
            if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 1152, '', [mbYes, mbNo], 0) = idYes then
            begin
              Application.CreateForm(TForm_UserInfo, Form_UserInfo);
              Form_UserInfo.ShowModal;
            end;
          end
          else if Trim(FieldByName('FIRST_FLAG').asString) = 'Y' then
          begin
            if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 1153, '', [mbYes, mbNo], 0) = idYes then
            begin
              Application.CreateForm(TForm_UserInfo, Form_UserInfo);
              Form_UserInfo.ShowModal;
            end;
          end;
      end;  // end of if
   end;  // end of with
end;

//------------------------------------------------------------------------------
//  Clear ToolBarList
//------------------------------------------------------------------------------
procedure TMainFrame.ClearToolBarList(pToolBarList: TList);
var
   I, K : Integer;
   ToolItem : pTUserToolBar;
   BtnItem  : pTBtnInfo;
begin
   if Assigned(pToolBarList) then
   begin
      for I := 0 to pToolBarList.Count -1 do
      begin
         ToolItem := pToolBarList.Items[I];
         if Assigned(ToolItem.BtnInfoList) then
         begin
            for K := 0 to ToolItem.BtnInfoList.Count -1 do
            begin
               BtnItem := ToolItem.BtnInfoList.Items[K];
               Dispose(BtnItem);
            end;  // end of for K
            ToolItem.BtnInfoList.Free;
         end;  // end of if
         Dispose(ToolItem);
      end;  // end of for
      pToolBarList.Clear;
   end;  // end of if
end;

//------------------------------------------------------------------------------
//  해당 업무의 Default ToolBar BtnInfoList 생성
//------------------------------------------------------------------------------
procedure TMainFrame.SetDefBtnInfoList(pRoleCode, pSecType: string;
                                                           pBtnInfoList: TList);
type
  TDefArr = Array [0..9] of Integer;
Const
   //--- Broker ------------------------------------------------
   // Broker 주식 국제
   BEDefTrCodeArr   : TDefArr = (2801, 2106, 2101, 2102, 2103, 2201, 2301, 2806, 2813, 2392);
   BEDefImageIdxArr : TDefArr = (1,    8,    12,  3,    4,    5,    6,    7, 59, 11);

   // Broker 주식 법인
   BEDefTrCodeArr01   : TDefArr = (2801, 2106, 2101, 2102, 2103, 2201, 2301, 2806, 2311, 2392);
   BEDefImageIdxArr01 : TDefArr = (1,    8,    12,  3,    4,    5,    6,    7, 97, 11);

   // Broker 선물
   BFDefTrCodeArr   : TDefArr = (3801, 3101, 3102, 3103, 3201, 3303, 3351, 0, 0, 0);
   BFDefImageIdxArr : TDefArr = (1,    2,    3,    4,    5,    6,    7, 8, 9, 10);

   // Broker 주식 국제 (HostGW 사용하는 곳, Import TR을 바꾼다. OASYS도 빼자. 대표계좌등록을 넣자.
   BEDefTrCodeArrDT   : TDefArr = (2801, 2106, 2101, 2112, 2102, 2103, 2231, 2301, 2806, 2392);
   BEDefImageIdxArrDT : TDefArr = (1,    8,    12,     32,    3,    4,    5,    6,    7, 11);

var
   BtnItem  : pTBtnInfo;
   I : Integer;
   DefTrCodeArr, DefImageIdxArr : TDefArr;
begin
   if pRoleCode = gcROLE_BROKER then
   begin
      if pSecType = gcSEC_EQUITY then
      begin
         if (gvDeptCode = '01') or (gvDeptCode = '05') or
            (gvDeptCode = '07') or (gvDeptCode = '08') then
         begin
           DefTrCodeArr   := BEDefTrCodeArr01;
           DefImageIdxArr := BEDefImageIdxArr01;
         end
         else //02, 06
         begin

           if gf_GetSystemOptionValue('HXX','H') = 'D' then // 하나대투 Import TR 바뀜, OASYS대신 대표계좌등록으로 교체
           begin
             DefTrCodeArr   := BEDefTrCodeArrDT;
             DefImageIdxArr := BEDefImageIdxArrDT;
           end
           else
           begin
             DefTrCodeArr   := BEDefTrCodeArr;
             DefImageIdxArr := BEDefImageIdxArr;
           end;
         end;
      end
      else if pSecType = gcSEC_FUTURES then //03, 04
      begin
         DefTrCodeArr   := BFDefTrCodeArr;
         DefImageIdxArr := BFDefImageIdxArr;
      end
      else
         Exit;  // 처리하지 않음
   end
   else
      Exit;  // 처리하지 않음

   for I := Low(DefTrCodeArr) to High(DefTrCodeArr) do
   begin
      if DefTrCodeArr[I] = 0 then Continue;
      New(BtnItem);
      pBtnInfoList.Add(BtnItem);
      BtnItem.TrCode   := DefTrCodeArr[I];
      BtnItem.ImageIdx := DefImageIdxArr[I];
   end;  // end of for K
end;



procedure TMainFrame.FormShow(Sender: TObject);
var pagesperMB : integer;
    dbfilesize, used: double;
    dbfilename : string;
begin
   if DRToolbar_Tr.Visible then DREdit_tr.SetFocus;
   if AnsiStrLComp( pchar(gvOprUsrNo), 'data', 4) = 0 then Exit;
{
   with DataModule_SettleNet.ADOQuery_Main do
   begin
      // pagesperMB 가져오기
      Close;
      sql.clear;
      sql.add(  ' select   1048576 / low as pagesperMB ' +
                ' from     master.dbo.spt_values       ' +
                ' where    number = 1                  ' +
                ' and      type = ''E''                ' );
      Try
         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
      Except
         on E : Exception do Exit;
      end;

      if RecordCount <= 0 then Exit;

      pagesperMB := FieldByName('pagesperMB').AsInteger;
      if pagesperMB = 0 then Exit;

      // dbfilesize,  dbfilename 가져오기
      Close;
      sql.clear;
      sql.add(  ' select   sum(convert(dec(15,2),size)) / ' +
                intToStr(pagesperMB) + ' as dbfilesize,   ' +
                '          min(name) as dbfilename        ' +
                ' from     dbo.sysfiles                   ' +
                ' where    (status & 64 = 0)              ' );
      Try
         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
      Except
         on E : Exception do Exit;
      end;

      if RecordCount <= 0 then Exit;

      dbfilesize := FieldByName('dbfilesize').AsFloat;
      dbfilename := Trim(FieldByName('dbfilename').AsString);

      // used 가져오기
      Close;
      sql.clear;
      sql.add(  ' select   sum(convert(dec(15,2),reserved)) / ' +
                intToStr(pagesperMB) + ' as used              ' +
                ' from     sysindexes                         ' +
                ' where     indid in (0,1,255)               ' );
      Try
         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
      Except
         on E : Exception do Exit;
      end;

      if RecordCount <= 0 then Exit;

      used := FieldByName('used').AsFloat;

      if ( used / dbfilesize > 0.7 ) then
      begin

         Application.MessageBox(
             pChar('다음 사항을 데이타로드(702-0300)로 문의하세요.' + #13#10 + #13#10 +
             'SettleNet Database 사용 상태입니다.' + #13#10 + #13#10 +
             'Size(MB)  : ' + floatToStr(dbfilesize) + #13#10 +
             'Used(MB)  : ' + floatToStr(used)  + #13#10 + #13#10 +
             'Database 정리 작업이 필요한 상태입니다.'),
             '알림',
             MB_OK);

      end;//

   end;  // end of with
}   
//   gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SEACBIF[Query]: ' + E.Message, 0);// Database 오류
//   gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SEACBIF[Query]'); // Database 오류
    if DRToolbar_Tr.Visible then DREdit_tr.SetFocus;
end;

procedure TMainFrame.PrintSettupShow ;
begin
 timer1.Enabled := true;
 if DRPrinterSetupDlg_Main.Execute then
  begin
     // Printer Setup Variable
     if Printer.Printers.Count = 0 then  // 사용가능 Printer없음
     begin
        gvPrinter.PrinterIdx  := gcNonePrinter;
        gvPrinter.PrinterName := '';
        gvPrinter.Copies      := 1;
        gvPrinter.Orientation := poPortrait;
     end
     else  //사용가능 Printer있음
     begin
        gvPrinter.PrinterIdx  := Printer.PrinterIndex;
        gvPrinter.PrinterName := Printer.Printers[gvPrinter.PrinterIdx];
        gvPrinter.Copies      := Printer.Copies;
        gvPrinter.Orientation := Printer.Orientation;
     end;

    gf_WriteFormStrInfo(gcPrinterSection,gcPrinterNameKey,gvPrinter.PrinterName);
    if Printer.Orientation = poPortrait then
      gf_WriteFormStrInfo(gcPrinterSection,gcOrientationKey,'P')
    else
      gf_WriteFormStrInfo(gcPrinterSection,gcOrientationKey,'L');
  end;

end;

//Printer Settup 창을 찾아 자동으로 확인버튼을 누르게 함.
procedure TMainFrame.Timer1Timer(Sender: TObject);
var  hWnd1 : THandle;
begin
  hWnd1 := FindWindow('#32770',nil) ;
  if hWnd1 > 0 then
  begin
    Keybd_Event(VK_RETURN, 0, 0, 0);
    Keybd_Event(VK_RETURN, 0, KEYEVENTF_KEYUP, 0);
  end;
  timer1.Enabled := false;
end;


procedure TMainFrame.AttachToWindowsMenu(iTrCode: integer);
var
   I : Integer;
   MenuInfo : pTMenuInfo;
   MenuItem : TMenuItem;
   ParentItem, CheckItem : TComponent;
   sTrCode : string;
begin
   sTrCode := IntToStr(iTrCode);
   for I := 0 to gvMenuList.Count -1 do
   begin
      MenuInfo := gvMenuList.Items[I];

      if (MenuInfo.TrCode <> sTrCode) then Continue;

      CheckItem := nil;
      CheckItem := FindComponent('M' + MenuInfo.MenuId + 'MRU'); //기존에 MRU를 만들었으면 됐당
      if Assigned(CheckItem) then Exit;

      CheckItem := nil;
      CheckItem := FindComponent('MYYYYMRU'); //-
      if Not Assigned(CheckItem) then // - 가 없네. 만들어야징
      begin
        MenuItem := TMenuItem.Create(Self);
        MenuItem.Name := 'MYYYYMRU';  //Most Recently Used
        MenuItem.Caption := '-';

        ParentItem := FindComponent('MY000'); //Windows Menu
        if not Assigned(ParentItem) then Exit;  // Error
        (ParentItem as TMenuItem).Add(MenuItem);
      end;

      MenuItem := TMenuItem.Create(Self);
      MenuItem.Name := 'M' + MenuInfo.MenuId + 'MRU';  //Most Recently Used

      MenuItem.Caption := '[' + MenuInfo.TrCode + '] ' + MenuInfo.MenuName;

      MenuItem.Tag     := StrToIntDef(MenuInfo.TrCode, 0);
      MenuItem.OnClick := MenuClick;

      ParentItem := nil;
      ParentItem := FindComponent('MY000'); //Windows Menu
      if not Assigned(ParentItem) then Exit;  // Error
      (ParentItem as TMenuItem).Add(MenuItem);

      Exit;//찾았으니 볼 일 끝
   end;  // end of for
end;

procedure TMainFrame.OnRcvBFFormClose(var msg: TMessage); //(iTrCode: integer);
var
   I, J : Integer;
   MenuInfo : pTMenuInfo;
   MenuItem : TMenuItem;
   ParentItem, CheckItem : TComponent;
   sTrCode : string;
begin
   sTrCode := IntToStr(msg.WParam);
   for I := 0 to gvMenuList.Count -1 do
   begin
      MenuInfo := gvMenuList.Items[I];

      if (MenuInfo.TrCode <> sTrCode) then Continue;

      CheckItem := nil;
      CheckItem := FindComponent('M' + MenuInfo.MenuId + 'MRU');
      if Not Assigned(CheckItem) then Exit;  //기존에 MRU를 안만들었으면 됐당

      ParentItem := nil;
      ParentItem := FindComponent('MY000'); //Windows Menu
      if not Assigned(ParentItem) then Exit;  // Error
      (ParentItem as TMenuItem).Remove(CheckItem as TMenuItem);
      (CheckItem as TMenuItem).Destroy;

 {     이하 필요없음. -는 알아서 안보인다
      //나머지 MRU가 있는지 확인
      for j := 0 to (ParentItem as TMenuItem).Count -1 do
      begin
        MenuItem := (ParentItem as TMenuItem).Items[j];
        if pos('MRU',MenuItem.Name) > 0 then exit;
      end;

      //MRU가 하나도 없다. 그러면 - 도 지운다.
      CheckItem := nil;
      CheckItem := FindComponent('MYYYYMRU'); //-
      if Not Assigned(CheckItem) then Exit;

      (ParentItem as TMenuItem).Remove(CheckItem as TMenuItem);
 }
      exit; //볼 일 끝

   end;  // end of for
end;

procedure TMainFrame.DREdit_trEnter(Sender: TObject);
begin
//  DREdit_tr.SelectAll;
end;

procedure TMainFrame.DREdit_trMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  DREdit_tr.Clear;//SelectAll;
end;

procedure TMainFrame.DREdit_trChange(Sender: TObject);
var i : integer;
    sTr : string;
begin
  sTr := trim(DREdit_tr.Text);
  i := length(sTr);
  if i = 4 then
  begin
    if ((gvCurSecType = 'E') and ( copy(sTr,1,1) = '3'))
    or ((gvCurSecType = 'F') and ( copy(sTr,1,1) = '2')) then
    begin
      gf_ShowErrDlgMessage(0,0,'해당 화면은 존재하지 않습니다',0);
      if DRToolbar_Tr.Visible then DREdit_tr.SetFocus;
      if DRToolbar_Tr.Visible then DREdit_tr.SelectAll;
      Exit;
    end;

    if gf_IsNumeric(sTr) then
    begin
      DREdit_tr.Tag := StrToInt(sTr);
      MenuClick(DREdit_tr);
//    RunTran(StrToInt(sTr));
    end;
  end;

end;



function TMainFrame.InitHKCommDLL: boolean;
const
  HK_DLL_NAME_1 = 'HKServerCommDLL.dll';
  HK_DLL_NAME_2 = 'XS_Client.dll';
  //HK_DLL_NAME_3 = 'mfc100d.dll';
  //HK_DLL_NAME_4 = 'msvcr100d.dll';
begin
  Result := False;

  if (Not FileExists(HK_DLL_NAME_1)) then
  begin
    gf_ShowErrDlgMessage(0, 0, HK_DLL_NAME_1 + ' Load Failed!!', 0);
    Exit;
  end;

  if (Not FileExists(HK_DLL_NAME_2)) then
  begin
    gf_ShowErrDlgMessage(0, 0, HK_DLL_NAME_2 + ' Load Failed!!', 0);
    Exit;
  end;

  {if (Not FileExists(HK_DLL_NAME_3)) then
  begin
    gf_ShowErrDlgMessage(0, 0, HK_DLL_NAME_3 + ' Load Failed!!', 0);
    Exit;
  end;

  if (Not FileExists(HK_DLL_NAME_4)) then
  begin
    gf_ShowErrDlgMessage(0, 0, HK_DLL_NAME_4 + ' Load Failed!!', 0);
    Exit;
  end;}

  Try
    m_hHKCommDLL := LoadLibrary('HKServerCommDLL.dll');

    if (@m_hHKCommDLL <> nil) and
       (m_hHKCommDLL <> 0) then
    begin
      m_pConnectMCAServer    := CONNECTMCASERVER(GetProcAddress(m_hHKCommDLL,pChar('ConnectMCAServer')));
      m_pRequestData         := REQUESTDATA(GetProcAddress(m_hHKCommDLL,pChar('RequestData')));
      m_pDisConnectMCAServer := DISCONNECTMCASERVER(GetProcAddress(m_hHKCommDLL,pChar('DisConnectMCAServer')));
    end	else
    begin
      gf_ShowErrDlgMessage(0, 0, 'HKServerCommDLL Load Failed!!', 0);
      Exit;
    end;
  Except
    on E: Exception do
    begin
      gf_ShowErrDlgMessage(0, 0, 'MCA DLL Load Failed!! ' + E.Message, 0);
      Exit;
    end;
  End;

  Result := True;
end;

//------------------------------------------------------------------------------
//  WM_COPYDATA
//------------------------------------------------------------------------------
procedure TMainFrame.WMCopyData(var Message: TMessage);
Var
  Data :^COPYDATASTRUCT;

  // 헤더
  HeaderInfo : pMCAHeader;

  // 주식 계좌
  eAccInputItem  : pTTC3808UI1;
  eAccOutputItem : pTTC3808UO2;

  // 주식 매매
  etradeInputItem  : pTTC3809UI;
  eTradeOutputItem : pTTC3809UO2;

  // 주식 계좌 내역 업로드
  eUpLoadAccInputItem  : pTSC6307UI;
  eUpLoadAccOutputItem : pTSC6307UO3;

  // 주식 정정 내역 업로드
  eUpLoadInputItem  : pTTC6317UI;
  eUpLoadOutputItem : pTTC6317UO3;

  // 주식 결제업무 마감
  eCloseInputItem  : pTSC6315UI;
  eCloseOutputItem : pTSC6315UO;

  // 주식 수수료계산
  eCalcCommInputItem  : pTSC3220RI1;
  eCalcCommOutputItem : pTSC3220RO2;

  // 선물 계좌정보
  fAccInputItem  : pTFO6137RI1;
  fAccOutputItem : pTFO6137RO2;

  // 선물 수수료정보
  fAccCommInputItem  : pTFO6142RI1;
  fAccCommOutputItem : pTFO6142RO2;

  // 선물 예탁
  fDepoInputItem  : pTFO6138RI1;
  fDepoOutputItem : pTFO6138RO2;

  // 선물 매매
  fTradeInputItem  : pTTO9008RI1;
  fTradeOutputItem : pTTO9008RO2;

  // 선물 미결제
  fOpenInputItem  : pTFO6140RI1;
  fOpenOutputItem : pTFO6140RO2;

  // 선물 대용
  fColtInputItem  : pTFO6141RI1;
  fColtOutputItem : pTFO6141RO2;

  sdwData: string;
  scbData: string;
  slpData: string;

  clpData: Array[0..8000] of char;

  i, iEnd: integer;
Begin

  EnterCriticalSection(gvMCACriticalSection);

  gvMCAResult := '';

  gf_MCALog('Get CopyData[MainForm].');
  Try
    Data:= Ptr(Message.lParam);
{
    sdwData := IntToStr(Data.dwData);
    scbData := IntToStr(Data.cbData);
    slpData := StrPas(pchar(Data.lpData));

    FillChar(clpData, SizeOf(clpData), #32);
    Try
      CopyMemory(@clpData , Data.lpData, Sizeof(TMCAHeader)
                                       + Sizeof(TTTC3809UI)
                                       + Sizeof(TTTC3809UO2));
    Except
      on E: Exception do
      begin
        gf_MCALog('Err-CopyMemory(): ' + E.Message);
        Exit;
      end;
    End;

    for i:=0 to SizeOf(clpData)-1 do
    begin
      if clpData[i] = #0 then clpData[i] := #36;
    end;

    gf_MCALog('sdwData: [' + sdwData + ']');
    gf_MCALog('scbData: [' + scbData + ']');
    gf_MCALog('clpData: [' + clpData + ']');
    gf_MCALog('slpData[TotalArea] : [' + slpData + ']');

    gf_MCALog('slpData[InputArea] : [' + pChar(pTTC3809UI(lparam(Data.lpData) + SizeOf(TMCAHeader))) + ']');
    gf_MCALog('slpData[OutputArea]: [' + pchar(pTTC3809UO2(lparam(Data.lpData) + sizeof(TMCAHeader) + sizeof(pTTC3809UI))) + ']');
}
    CASE Data.dwData of
      gcMCA_SOCKET_DATA:
      begin
        // 헤더 영역
        HeaderInfo := Data^.lpData;

        if (HeaderInfo <> nil) then
        begin

          //-- [TTC3808U] 주식 계좌 --------------------------------------------
          if (Trim(HeaderInfo.TR_NAME) = gcMCA_TR_E_ACC) then
          begin
            // 리턴된 Input Data값
            eAccInputItem := pTTC3808UI1(lparam(Data.lpData) + SizeOf(TMCAHeader));

            // 리턴된 Output Data값
            eAccOutputItem := pTTC3808UO2(lparam(Data.lpData) + sizeof(TMCAHeader) + sizeof(TTTC3808UI1));


            {if (eAccOutputItem <> nil) and
               (Trim(pChar(eAccOutputItem)) <> '') then
            begin
              sMCASuccess := eAccOutputItem.NRML_PRCS_YN;
            end;}

            gvMCAResult := Trim(eAccOutputItem.NRML_PRCS_YN);
          end // if (Trim(HeaderInfo.Tr_name) = gctfMCA_TR_E_ACC) then
          else

          //-- [TTC3809U] 주식 매매 --------------------------------------------
          if (Trim(HeaderInfo.TR_NAME) = gcMCA_TR_E_TRADE) then
          begin
            // 리턴된 Input Data값
            eTradeInputItem := pTTC3809UI(lparam(Data.lpData) + SizeOf(TMCAHeader));

            // 리턴된 Output Data값
            eTradeOutputItem := pTTC3809UO2(lparam(Data.lpData) + sizeof(TMCAHeader) + sizeof(TTTC3809UI));

            gvMCAResult := Trim(eTradeOutputItem.NRML_PRCS_YN);
          end // if (Trim(HeaderInfo.Tr_name) = gctfMCA_TR_E_TRADE) then
          else

          //-- [TSC6315U] 주식 결제업무마감 체크 -------------------------------
          if (Trim(HeaderInfo.TR_NAME) = gcMCA_TR_E_CLOSE) then
          begin
            gvMCACloseResult := '';
            // 리턴된 Input Data값
            eCloseInputItem := pTSC6315UI(lparam(Data.lpData) + SizeOf(TMCAHeader));

            // 리턴된 Output Data값
            eCloseOutputItem := pTSC6315UO(lparam(Data.lpData) + sizeof(TMCAHeader) + sizeof(TTSC6315UI));
            
            Try
              StrToInt(eCloseOutputItem.SIZE);

              // MCA부서목록 갯수 만큼 루프
              for i:=0 to StrToInt(eCloseOutputItem.SIZE)-1 do
              begin
                // 세틀넷 부서코드와 매칭된 MCA 부서코드의 결제업무마감 유무 체크
                if gvDeptCode = Copy(Trim(eCloseOutputItem.OCCURS_OUT1[i].ORGNO),2,2) then
                begin
                  gvMCACloseResult := Trim(eCloseOutputItem.OCCURS_OUT1[i].CLSG_YN);
                  gf_MCALog('DeptCode: '+gvDeptCode+', R: '+gvMCACloseResult);
                end;
              end;
                  
            Except
              gf_MCALog(Trim(HeaderInfo.TR_NAME) + ': 결제업무마감처리Tr 사이즈 오류.');
            End;

            gvMCAResult := Trim(eCloseOutputItem.NRML_PRCS_YN);
          end // if (Trim(HeaderInfo.Tr_name) = gctfMCA_TR_E_TRADE) then
          else

          //-- [TSC6307U] 주식 계좌내역 업로드 ---------------------------------
          if (Trim(HeaderInfo.TR_NAME) = gcMCA_TR_E_UPLOAD_ACC) then
          begin
            // 리턴된 Input Data값
            eUpLoadAccInputItem := pTSC6307UI(lparam(Data.lpData) + SizeOf(TMCAHeader));

            // 리턴된 Output Data값
            eUpLoadAccOutputItem := pTSC6307UO3(lparam(Data.lpData) + sizeof(TMCAHeader) + SizeOf(TTSC6307UI));

            //gvMCAResult := Trim(eUpLoadAccOutputItem.NRML_PRCS_YN);
            if Trim(HeaderInfo.RT_CD) = '0' then
              gvMCAResult := 'Y'
            else
              gvMCAResult := 'N';
          end // if (Trim(HeaderInfo.TR_NAME) = gcMCA_TR_E_UPLOAD_ACC) then
          else

          //-- [TSC6317U] 주식 분할/정정내역 업로드 ----------------------------
          if (Trim(HeaderInfo.TR_NAME) = gcMCA_TR_E_UPLOAD) then
          begin
            // 리턴된 Input Data값
            eUpLoadInputItem := pTTC6317UI(lparam(Data.lpData) + SizeOf(TMCAHeader));

            // 리턴된 Output Data값
            eUpLoadOutputItem := pTTC6317UO3(lparam(Data.lpData) + sizeof(TMCAHeader) + SizeOf(TTTC6317UI));

            //gvMCAResult := Trim(eUpLoadAccOutputItem.NRML_PRCS_YN);
            if Trim(HeaderInfo.RT_CD) = '0' then
              gvMCAResult := 'Y'
            else
              gvMCAResult := 'N';
          end // if (Trim(HeaderInfo.TR_NAME) = gcMCA_TR_E_UPLOAD_ACC) then
          else

          //-- [TSC3220R] 주식 수수료계산 --------------------------------------
          if (Trim(HeaderInfo.TR_NAME) = gcMCA_TR_E_CALC_COMM) then
          begin
            // 리턴된 Input Data값
            eCalcCommInputItem := pTSC3220RI1(lparam(Data.lpData) + SizeOf(TMCAHeader));

            gvMCAInputData_CalcComm.EXCG_DVSN_CD     := eCalcCommInputItem.EXCG_DVSN_CD;
            gvMCAInputData_CalcComm.PDNO             := eCalcCommInputItem.PDNO;
            gvMCAInputData_CalcComm.PRDT_TYPE_CD     := eCalcCommInputItem.PRDT_TYPE_CD;
            gvMCAInputData_CalcComm.SLL_BUY_DVSN_CD  := eCalcCommInputItem.SLL_BUY_DVSN_CD;
            gvMCAInputData_CalcComm.TRTX_TXTN_YN     := eCalcCommInputItem.TRTX_TXTN_YN;
            gvMCAInputData_CalcComm.ORD_MDIA_DVSN_CD := eCalcCommInputItem.ORD_MDIA_DVSN_CD;
            gvMCAInputData_CalcComm.CANO             := eCalcCommInputItem.CANO;
            gvMCAInputData_CalcComm.ACNT_PRDT_CD     := eCalcCommInputItem.ACNT_PRDT_CD;
            gvMCAInputData_CalcComm.STTL_DT          := eCalcCommInputItem.STTL_DT;
            gvMCAInputData_CalcComm.AVG_UNPR         := eCalcCommInputItem.AVG_UNPR;
            gvMCAInputData_CalcComm.TOT_CCLD_QTY     := eCalcCommInputItem.TOT_CCLD_QTY;
            gvMCAInputData_CalcComm.TOT_CCLD_AMT     := eCalcCommInputItem.TOT_CCLD_AMT;

            // 리턴된 Output Data값
            eCalcCommOutputItem := pTSC3220RO2(lparam(Data.lpData) + sizeof(TMCAHeader) + SizeOf(TTSC3220RI1));

            // 리턴된 Output Data값 넘기기
            gvMCAOutputData_CalcComm.FEE      := eCalcCommOutputItem.FEE;
            gvMCAOutputData_CalcComm.TRTX     := eCalcCommOutputItem.TRTX;
            gvMCAOutputData_CalcComm.FSTX     := eCalcCommOutputItem.FSTX;
            gvMCAOutputData_CalcComm.TRFX     := eCalcCommOutputItem.TRFX;
            gvMCAOutputData_CalcComm.EXCC_AMT := eCalcCommOutputItem.EXCC_AMT;
            gvMCAOutputData_CalcComm.FEE_RT   := eCalcCommOutputItem.FEE_RT;

            // 리턴용
            //FillChar(gvMCAOutputData_CalcComm, SizeOf(gvMCAOutputData_CalcComm), #32);
            //gvMCAOutputData_CalcComm := eCalcCommOutputItem;


            //gvMCAResult := Trim(eUpLoadAccOutputItem.NRML_PRCS_YN);
            if Trim(HeaderInfo.RT_CD) = '0' then
              gvMCAResult := 'Y'
            else
              gvMCAResult := 'N';
          end // if (Trim(HeaderInfo.TR_NAME) = gcMCA_TR_E_CALC_COMM) then
          else

          //-- [TFO6137R] 선물 계좌 --------------------------------------------
          if (Trim(HeaderInfo.Tr_name) = gcMCA_TR_F_ACC) then
          begin
            // 리턴된 Input Data값
            fAccInputItem := pTFO6137RI1(lparam(Data.lpData) + SizeOf(TMCAHeader));

            // 리턴된 Output Data값
            fAccOutputItem := pTFO6137RO2(lparam(Data.lpData) + sizeof(TMCAHeader) + sizeof(TTFO6137RI1));

            //gvMCAResult := Trim(fAccOutputItem.NRML_PRCS_YN);
            if Trim(HeaderInfo.RT_CD) = '0' then
              gvMCAResult := 'Y'
            else
              gvMCAResult := 'N';
          end // if (Trim(HeaderInfo.Tr_name) = gcMCA_TR_F_ACC) then
          else

          //-- [TFO6142R] 선물 수수료코드 --------------------------------------
          if (Trim(HeaderInfo.Tr_name) = gcMCA_TR_F_COMM_INFO) then
          begin
            // 리턴된 Input Data값
            fAccCommInputItem := pTFO6142RI1(lparam(Data.lpData) + SizeOf(TMCAHeader));

            // 리턴된 Output Data값
            fAccCommOutputItem := pTFO6142RO2(lparam(Data.lpData) + sizeof(TMCAHeader) + sizeof(TTFO6142RI1));

            //gvMCAResult := Trim(fAccCommOutputItem.NRML_PRCS_YN);
            if Trim(HeaderInfo.RT_CD) = '0' then
              gvMCAResult := 'Y'
            else
              gvMCAResult := 'N';
          end // if (Trim(HeaderInfo.Tr_name) = gcMCA_TR_F_COMM_INFO) then
          else

          //-- [TFO6138R] 선물 예탁 --------------------------------------------
          if (Trim(HeaderInfo.Tr_name) = gcMCA_TR_F_DEPOSIT) then
          begin
            // 리턴된 Input Data값
            fDepoInputItem := pTFO6138RI1(lparam(Data.lpData) + SizeOf(TMCAHeader));

            // 리턴된 Output Data값
            fDepoOutputItem := pTFO6138RO2(lparam(Data.lpData) + sizeof(TMCAHeader) + sizeof(TTFO6138RI1));

            //gvMCAResult := Trim(fDepoOutputItem.NRML_PRCS_YN);
            if Trim(HeaderInfo.RT_CD) = '0' then
              gvMCAResult := 'Y'
            else
              gvMCAResult := 'N';
          end // if (Trim(HeaderInfo.Tr_name) = gcMCA_TR_F_DEPOSIT) then
          else

          //-- [TTO9008R] 선물 매매 --------------------------------------------
          if (Trim(HeaderInfo.Tr_name) = gcMCA_TR_F_TRADE) then
          begin
            // 리턴된 Input Data값
            fTradeInputItem := pTTO9008RI1(lparam(Data.lpData) + SizeOf(TMCAHeader));

            // 리턴된 Output Data값
            fTradeOutputItem := pTTO9008RO2(lparam(Data.lpData) + sizeof(TMCAHeader) + sizeof(TTTO9008RI1));

            //gvMCAResult := Trim(fTradeOutputItem.NRML_PRCS_YN);
            if Trim(HeaderInfo.RT_CD) = '0' then
              gvMCAResult := 'Y'
            else
              gvMCAResult := 'N';            
          end // if (Trim(HeaderInfo.Tr_name) = gcMCA_TR_F_TRADE) then
          else

          //-- [TFO6140R] 선물 미결제 ------------------------------------------
          if (Trim(HeaderInfo.Tr_name) = gcMCA_TR_F_OPEN) then
          begin
            // 리턴된 Input Data값
            fOpenInputItem := pTFO6140RI1(lparam(Data.lpData) + SizeOf(TMCAHeader));

            // 리턴된 Output Data값
            fOpenOutputItem := pTFO6140RO2(lparam(Data.lpData) + sizeof(TMCAHeader) + sizeof(TTFO6140RI1));

            //gvMCAResult := Trim(fOpenOutputItem.NRML_PRCS_YN);
            if Trim(HeaderInfo.RT_CD) = '0' then
              gvMCAResult := 'Y'
            else
              gvMCAResult := 'N';
          end // if (Trim(HeaderInfo.Tr_name) = gcMCA_TR_F_OPEN) then
          else

          //-- [TFO6141R] 선물 대용 --------------------------------------------
          if (Trim(HeaderInfo.Tr_name) = gcMCA_TR_F_COLT) then
          begin
            // 리턴된 Input Data값
            fColtInputItem := pTFO6141RI1(lparam(Data.lpData) + SizeOf(TMCAHeader));

            // 리턴된 Output Data값
            fColtOutputItem := pTFO6141RO2(lparam(Data.lpData) + sizeof(TMCAHeader) + sizeof(TTFO6141RI1));

            //gvMCAResult := Trim(fColtOutputItem.NRML_PRCS_YN);
            if Trim(HeaderInfo.RT_CD) = '0' then
              gvMCAResult := 'Y'
            else
              gvMCAResult := 'N';
          end; // if (Trim(HeaderInfo.Tr_name) = gcMCA_TR_F_COLT) then


          //--------------------------------------------------------------------
          //  [Output Data Log]
          //--------------------------------------------------------------------
          if (Trim(HeaderInfo.TR_NAME) <> gcMCA_TR_E_CLOSE) then
          begin
            gf_MCALog('- OutputData --------------------------------------------------------');
            gf_MCALog('headerInfo.TR_Type          : ' + HeaderInfo.TR_Type          );
            gf_MCALog('headerInfo.Interface_id     : ' + HeaderInfo.Interface_id     );
            gf_MCALog('headerInfo.Encrypt_flag     : ' + HeaderInfo.Encrypt_flag     );
            gf_MCALog('headerInfo.Tr_name          : ' + HeaderInfo.Tr_name          );
            gf_MCALog('headerInfo.Scr_no           : ' + HeaderInfo.Scr_no           );
            gf_MCALog('headerInfo.Lang_id          : ' + HeaderInfo.Lang_id          );
            gf_MCALog('headerInfo.Mode_flag        : ' + HeaderInfo.Mode_flag        );
            gf_MCALog('headerInfo.Tr_cont          : ' + HeaderInfo.Tr_cont          );
            gf_MCALog('headerInfo.Co_cd            : ' + HeaderInfo.Co_cd            );
            gf_MCALog('headerInfo.Media_cd1        : ' + HeaderInfo.Media_cd1        );
            gf_MCALog('headerInfo.Media_cd2        : ' + HeaderInfo.Media_cd2        );
            gf_MCALog('headerInfo.Org_cd           : ' + HeaderInfo.Org_cd           );
            gf_MCALog('headerInfo.Seq_no           : ' + HeaderInfo.Seq_no           );
            gf_MCALog('headerInfo.Dept_cd          : ' + HeaderInfo.Dept_cd          );
            gf_MCALog('headerInfo.Emp_id           : ' + HeaderInfo.Emp_id           );
            gf_MCALog('headerInfo.Emp_seq          : ' + HeaderInfo.Emp_seq          );
            gf_MCALog('headerInfo.User_id          : ' + HeaderInfo.User_id          );
            gf_MCALog('headerInfo.Br_open_cd       : ' + HeaderInfo.Br_open_cd       );
            gf_MCALog('headerInfo.Acct_no          : ' + HeaderInfo.Acct_no          );
            gf_MCALog('headerInfo.MediaFlag        : ' + HeaderInfo.MediaFlag        );
            gf_MCALog('headerInfo.MediaFlag_Detail : ' + HeaderInfo.MediaFlag_Detail );
            gf_MCALog('headerInfo.Rt_cd            : ' + HeaderInfo.Rt_cd            );
          end;

          //-- [Log] 주식 계좌 Import ------------------------------------------
          if (Trim(HeaderInfo.TR_NAME) = gcMCA_TR_E_ACC) then
          begin
            gf_MCALog('Input.CANO                   : ' + eAccInputItem.CANO);
            gf_MCALog('Input.ACNT_PRDT_CD           : ' + eAccInputItem.ACNT_PRDT_CD);
            gf_MCALog('Input.SETN_BRNO              : ' + eAccInputItem.SETN_BRNO);
            gf_MCALog('Input.sWORK_DT               : ' + eAccInputItem.WORK_DT);
            gf_MCALog('Input.sITFC_ID               : ' + eAccInputItem.ITFC_ID);
            gf_MCALog('Input.POUT_FILE_NAME         : ' + eAccInputItem.POUT_FILE_NAME);

            gf_MCALog('Output.NRML_PRCS_YN          : ' + eAccOutputItem.NRML_PRCS_YN);
            gf_MCALog('Output.PRCS_MSG              : ' + eAccOutputItem.PRCS_MSG);
            gf_MCALog('---------------------------------------------------------------------');
          end else
          //-- [Log] 주식 매매 Import ------------------------------------------
          if (Trim(HeaderInfo.TR_NAME) = gcMCA_TR_E_TRADE) then
          begin

            //gf_MCALog('Input.SIZE                                 : ' + eTradeInputItem.SIZE          );

            Try
              iEnd := StrToInt(eTradeInputItem.DATA_CNT);
              for i:=0 to iEnd -1 do
              begin
                gf_MCALog('Input['+ IntToStr(i) +'].CANO          : ' + eTradeInputItem.ACC_NO[i].CANO          );
                gf_MCALog('Input['+ IntToStr(i) +'].ACNT_PRDT_CD  : ' + eTradeInputItem.ACC_NO[i].ACNT_PRDT_CD  );
              end;
            Except
              gf_MCALog('TradeInputItem.DATA_CNT 숫자변환 오류.');
            End;

            gf_MCALog('Input.SETN_BRNO         : ' + eTradeInputItem.SETN_BRNO);
            gf_MCALog('Input.sWORK_DT          : ' + eTradeInputItem.WORK_DT);
            gf_MCALog('Input.sITFC_ID          : ' + eTradeInputItem.ITFC_ID);
            gf_MCALog('Input.POUT_FILE_NAME    : ' + eTradeInputItem.POUT_FILE_NAME);

            gf_MCALog('Output.NRML_PRCS_YN     : ' + eTradeOutputItem.NRML_PRCS_YN);
            gf_MCALog('Output.PRCS_MSG         : ' + eTradeOutputItem.PRCS_MSG);
            gf_MCALog('---------------------------------------------------------------------');
          end else

          //-- [Log] 주식 결제업무 마감 유무 체크 ------------------------------
          if (Trim(HeaderInfo.TR_NAME) = gcMCA_TR_E_CLOSE) then
          begin
            gf_MCALog('Input.PRCS_DVSN_CD   : ' + eCloseInputItem.PRCS_DVSN_CD                );
            gf_MCALog('Input.TRAD_DT        : ' + eCloseInputItem.TRAD_DT                     );
            gf_MCALog('Input.TRAD_STTL_PRC~ : ' + eCloseInputItem.TRAD_STTL_PRCS_AFRS_DVSN_CD );
            gf_MCALog('Input.ORGNO          : ' + eCloseInputItem.ORGNO         );
            gf_MCALog('Input.CLSG_YN        : ' + eCloseInputItem.CLSG_YN       );

            gf_MCALog('Output.SIZE          : ' + eCloseOutputItem.SIZE                      );

            Try
              iEnd := StrToInt(eCloseOutputItem.SIZE);
              for i:=0 to iEnd -1 do
              begin
                gf_MCALog('Output['+ IntToStr(i) +'].ORGNO      : ' + eCloseOutputItem.OCCURS_OUT1[i].ORGNO      );
                gf_MCALog('Output['+ IntToStr(i) +'].ORG_NAME   : ' + eCloseOutputItem.OCCURS_OUT1[i].ORG_NAME   );
                gf_MCALog('Output['+ IntToStr(i) +'].CLSG_YN    : ' + eCloseOutputItem.OCCURS_OUT1[i].CLSG_YN    );
                gf_MCALog('Output['+ IntToStr(i) +'].CLSG_TMD   : ' + eCloseOutputItem.OCCURS_OUT1[i].CLSG_TMD   );
                gf_MCALog('Output['+ IntToStr(i) +'].OPTR_NAME  : ' + eCloseOutputItem.OCCURS_OUT1[i].OPTR_NAME  );
              end;
            Except
              gf_MCALog('eCloseOutputItem.SIZE 숫자변환 오류.');
            End;

            gf_MCALog('Output.NRML_PRCS_YN  : ' + eCloseOutputItem.NRML_PRCS_YN  );
          //gf_MCALog('Output._NRML_PRCS_YN   : ' + eCloseOutputItem._NRML_PRCS_YN );
            gf_MCALog('---------------------------------------------------------------------');
          end else

          //-- [Log] 주식 계좌최종내역 업로드 ----------------------------------
          if (Trim(HeaderInfo.TR_NAME) = gcMCA_TR_E_UPLOAD_ACC) then
          begin
            // 작업구분코드가 입력(01) 이면 출력
            if (Trim(eUpLoadAccInputItem.WORK_DVSN_CD) = '01') then
            begin
              gf_MCALog('Input.SIZE                                 : ' + eUpLoadAccInputItem.SIZE          );

              Try
                iEnd := StrToInt(eUpLoadAccInputItem.DATA_CNT);
                for i:=0 to iEnd -1 do
                begin
                  gf_MCALog('');
                  gf_MCALog('Input['+ IntToStr(i) +'].CHNG_BF_CANO          : ' + eUpLoadAccInputItem.OCCURS_IN1[i].CHNG_BF_CANO          );
                  gf_MCALog('Input['+ IntToStr(i) +'].CHNG_BF_ACNT_PRDT_CD  : ' + eUpLoadAccInputItem.OCCURS_IN1[i].CHNG_BF_ACNT_PRDT_CD  );
                  gf_MCALog('Input['+ IntToStr(i) +'].CHNG_AF_CANO          : ' + eUpLoadAccInputItem.OCCURS_IN1[i].CHNG_AF_CANO          );
                  gf_MCALog('Input['+ IntToStr(i) +'].CHNG_AF_ACNT_PRDT_CD  : ' + eUpLoadAccInputItem.OCCURS_IN1[i].CHNG_AF_ACNT_PRDT_CD  );
                  gf_MCALog('Input['+ IntToStr(i) +'].PDNO                  : ' + eUpLoadAccInputItem.OCCURS_IN1[i].PDNO                  );
                  gf_MCALog('Input['+ IntToStr(i) +'].EXCG_DVSN_CD          : ' + eUpLoadAccInputItem.OCCURS_IN1[i].EXCG_DVSN_CD          );
                  gf_MCALog('Input['+ IntToStr(i) +'].TRTX_TXTN_YN          : ' + eUpLoadAccInputItem.OCCURS_IN1[i].TRTX_TXTN_YN          );
                  gf_MCALog('Input['+ IntToStr(i) +'].STTL_ORD_DVSN_CD      : ' + eUpLoadAccInputItem.OCCURS_IN1[i].STTL_ORD_DVSN_CD      );
                  gf_MCALog('Input['+ IntToStr(i) +'].ORD_MDIA_DVSN_CD      : ' + eUpLoadAccInputItem.OCCURS_IN1[i].ORD_MDIA_DVSN_CD      );
                  gf_MCALog('Input['+ IntToStr(i) +'].SLL_BUY_DVSN_CD       : ' + eUpLoadAccInputItem.OCCURS_IN1[i].SLL_BUY_DVSN_CD       );
                  gf_MCALog('Input['+ IntToStr(i) +'].MTRL_DVSN_CD          : ' + eUpLoadAccInputItem.OCCURS_IN1[i].MTRL_DVSN_CD          );
                  gf_MCALog('Input['+ IntToStr(i) +'].STTL_QTY              : ' + eUpLoadAccInputItem.OCCURS_IN1[i].STTL_QTY              );
                  gf_MCALog('Input['+ IntToStr(i) +'].STTL_PRIC             : ' + eUpLoadAccInputItem.OCCURS_IN1[i].STTL_PRIC             );
                  gf_MCALog('Input['+ IntToStr(i) +'].AVG_UNPR              : ' + eUpLoadAccInputItem.OCCURS_IN1[i].AVG_UNPR              );
                  gf_MCALog('Input['+ IntToStr(i) +'].STTL_AMT              : ' + eUpLoadAccInputItem.OCCURS_IN1[i].STTL_AMT              );
                  gf_MCALog('Input['+ IntToStr(i) +'].FEE                   : ' + eUpLoadAccInputItem.OCCURS_IN1[i].FEE                   );
                  gf_MCALog('Input['+ IntToStr(i) +'].TAX_SMTL_AMT          : ' + eUpLoadAccInputItem.OCCURS_IN1[i].TAX_SMTL_AMT          );
                end;
              Except
                gf_MCALog('UpLoadInputItem.DATA_CNT 숫자변환 오류.');
              End;
            end; // if (Trim(eUpLoadAccInputItem.WORK_DVSN_CD) = '01') then

            gf_MCALog('Input.WORK_DVSN_CD           : ' + eUpLoadAccInputItem.WORK_DVSN_CD  );
            gf_MCALog('Input.ORGNO                  : ' + eUpLoadAccInputItem.ORGNO         );
            gf_MCALog('Input.TRAD_DT                : ' + eUpLoadAccInputItem.TRAD_DT       );
            gf_MCALog('Input.DATA_CNT               : ' + eUpLoadAccInputItem.DATA_CNT      );

            gf_MCALog('Output.NRML_PRCS_YN          : ' + eUpLoadAccOutputItem.NRML_PRCS_YN );
            gf_MCALog('---------------------------------------------------------------------');
          end else
          //-- [Log] 주식 분할/정정 내역 업로드 --------------------------------
          if (Trim(HeaderInfo.TR_NAME) = gcMCA_TR_E_UPLOAD) then
          begin
            // 작업구분코드가 입력(01) 이면 출력
            if (Trim(eUpLoadInputItem.WORK_DVSN_CD) = '01') then
            begin
              gf_MCALog('Input.SIZE                                 : ' + eUpLoadInputItem.SIZE          );

              Try
                iEnd := StrToInt(eUpLoadInputItem.DATA_CNT);
                for i:=0 to iEnd -1 do
                begin
                  gf_MCALog('');
                  gf_MCALog('Input['+ IntToStr(i) +'].CHNG_BF_CANO          : ' + eUpLoadInputItem.OCCURS_IN1[i].CHNG_BF_CANO          );
                  gf_MCALog('Input['+ IntToStr(i) +'].CHNG_BF_ACNT_PRDT_CD  : ' + eUpLoadInputItem.OCCURS_IN1[i].CHNG_BF_ACNT_PRDT_CD  );
                  gf_MCALog('Input['+ IntToStr(i) +'].ORGT_ODNO             : ' + eUpLoadInputItem.OCCURS_IN1[i].ORGT_ODNO             );
                  gf_MCALog('Input['+ IntToStr(i) +'].CHNG_AF_CANO          : ' + eUpLoadInputItem.OCCURS_IN1[i].CHNG_AF_CANO          );
                  gf_MCALog('Input['+ IntToStr(i) +'].CHNG_AF_ACNT_PRDT_CD  : ' + eUpLoadInputItem.OCCURS_IN1[i].CHNG_AF_ACNT_PRDT_CD  );
                  gf_MCALog('Input['+ IntToStr(i) +'].OPNT_ODNO1            : ' + eUpLoadInputItem.OCCURS_IN1[i].OPNT_ODNO1            );
                  gf_MCALog('Input['+ IntToStr(i) +'].PDNO                  : ' + eUpLoadInputItem.OCCURS_IN1[i].PDNO                  );
                  gf_MCALog('Input['+ IntToStr(i) +'].F_TRTX_TXTN_YN        : ' + eUpLoadInputItem.OCCURS_IN1[i].F_TRTX_TXTN_YN        );
                  gf_MCALog('Input['+ IntToStr(i) +'].T_TRTX_TXTN_YN        : ' + eUpLoadInputItem.OCCURS_IN1[i].T_TRTX_TXTN_YN        );
                  gf_MCALog('Input['+ IntToStr(i) +'].EXCG_DVSN_CD          : ' + eUpLoadInputItem.OCCURS_IN1[i].EXCG_DVSN_CD          );
                  gf_MCALog('Input['+ IntToStr(i) +'].TRAN_MTD              : ' + eUpLoadInputItem.OCCURS_IN1[i].TRAN_MTD              );
                  gf_MCALog('Input['+ IntToStr(i) +'].COM_TYPE              : ' + eUpLoadInputItem.OCCURS_IN1[i].COM_TYPE              );
                  gf_MCALog('Input['+ IntToStr(i) +'].SLL_BUY_DVSN_CD       : ' + eUpLoadInputItem.OCCURS_IN1[i].SLL_BUY_DVSN_CD       );
                  gf_MCALog('Input['+ IntToStr(i) +'].GUBUN                 : ' + eUpLoadInputItem.OCCURS_IN1[i].GUBUN                 );
                  gf_MCALog('Input['+ IntToStr(i) +'].MTRL_DVSN_CD          : ' + eUpLoadInputItem.OCCURS_IN1[i].MTRL_DVSN_CD          );
                  gf_MCALog('Input['+ IntToStr(i) +'].TRAD_FEE_RT           : ' + eUpLoadInputItem.OCCURS_IN1[i].TRAD_FEE_RT           );
                  gf_MCALog('Input['+ IntToStr(i) +'].AVG_UNPR              : ' + eUpLoadInputItem.OCCURS_IN1[i].AVG_UNPR              );
                  gf_MCALog('Input['+ IntToStr(i) +'].STTL_QTY              : ' + eUpLoadInputItem.OCCURS_IN1[i].STTL_QTY              );
                  gf_MCALog('Input['+ IntToStr(i) +'].AGRM_AMT              : ' + eUpLoadInputItem.OCCURS_IN1[i].AGRM_AMT              );
                  gf_MCALog('Input['+ IntToStr(i) +'].FEE                   : ' + eUpLoadInputItem.OCCURS_IN1[i].FEE                   );
                  gf_MCALog('Input['+ IntToStr(i) +'].TAXA                  : ' + eUpLoadInputItem.OCCURS_IN1[i].TAXA                  );
                end;
              Except
                gf_MCALog('UpLoadInputItem.DATA_CNT 숫자변환 오류.');
              End;
            end; // if (Trim(eUpLoadInputItem.WORK_DVSN_CD) = '01') then

            gf_MCALog('Input.WORK_DVSN_CD           : ' + eUpLoadInputItem.WORK_DVSN_CD  );
            gf_MCALog('Input.ADMN_ORGNO             : ' + eUpLoadInputItem.ADMN_ORGNO    );
            gf_MCALog('Input.TRAD_DT                : ' + eUpLoadInputItem.TRAD_DT       );
            gf_MCALog('Input.DATA_CNT               : ' + eUpLoadInputItem.DATA_CNT      );

            gf_MCALog('Output.NRML_PRCS_YN          : ' + eUpLoadOutputItem.NRML_PRCS_YN );
            gf_MCALog('---------------------------------------------------------------------');
          end else
          //-- [Log] 주식 수수료 계산 ------------------------------------------
          if (Trim(HeaderInfo.TR_NAME) = gcMCA_TR_E_CALC_COMM) then
          begin
            gf_MCALog('InputData.EXCG_DVSN_CD       : ' + eCalcCommInputItem.EXCG_DVSN_CD      );
            gf_MCALog('InputData.PDNO               : ' + eCalcCommInputItem.PDNO              );
            gf_MCALog('InputData.PRDT_TYPE_CD       : ' + eCalcCommInputItem.PRDT_TYPE_CD      );
            gf_MCALog('InputData.SLL_BUY_DVSN_CD    : ' + eCalcCommInputItem.SLL_BUY_DVSN_CD   );
            gf_MCALog('InputData.TRTX_TXTN_YN       : ' + eCalcCommInputItem.TRTX_TXTN_YN      );
            gf_MCALog('InputData.ORD_MDIA_DVSN_CD   : ' + eCalcCommInputItem.ORD_MDIA_DVSN_CD  );
            gf_MCALog('InputData.CANO               : ' + eCalcCommInputItem.CANO              );
            gf_MCALog('InputData.ACNT_PRDT_CD       : ' + eCalcCommInputItem.ACNT_PRDT_CD      );
            gf_MCALog('InputData.STTL_DT            : ' + eCalcCommInputItem.STTL_DT           );
            gf_MCALog('InputData.AVG_UNPR           : ' + eCalcCommInputItem.AVG_UNPR      );
            gf_MCALog('InputData.TOT_CCLD_QTY       : ' + eCalcCommInputItem.TOT_CCLD_QTY  );
            gf_MCALog('InputData.TOT_CCLD_AMT       : ' + eCalcCommInputItem.TOT_CCLD_AMT  );

            gf_MCALog('OutputData.FEE       : ' + eCalcCommOutputItem.FEE       );
            gf_MCALog('OutputData.TRTX      : ' + eCalcCommOutputItem.TRTX      );
            gf_MCALog('OutputData.FSTX      : ' + eCalcCommOutputItem.FSTX      );
            gf_MCALog('OutputData.TRFX      : ' + eCalcCommOutputItem.TRFX      );
            gf_MCALog('OutputData.EXCC_AMT  : ' + eCalcCommOutputItem.EXCC_AMT  );
            gf_MCALog('OutputData.FEE_RT    : ' + eCalcCommOutputItem.FEE_RT    );
            gf_MCALog('OutputData.FEE_RT(C) : ' + FormatFloat('#,##0.000000',
              StrToFloat(eCalcCommOutputItem.FEE_RT) / 1000000));
            gf_MCALog('---------------------------------------------------------------------');
          {end else
          //-- [Log] 선물 계좌 -------------------------------------------------
          if (Trim(HeaderInfo.Tr_name) = gcMCA_TR_F_ACC) then
          begin
            gf_MCALog('Input.ACNT_ADMN_ORGNO        : ' + fAccInputItem.ACNT_ADMN_ORGNO);
            gf_MCALog('Input._ACNT_ADMN_ORGNO       : ' + fAccInputItem._ACNT_ADMN_ORGNO);
            gf_MCALog('Input.INQR_DT                : ' + fAccInputItem.INQR_DT);
            gf_MCALog('Input._INQR_DT               : ' + fAccInputItem._INQR_DT);
            gf_MCALog('Input.CANO                   : ' + fAccInputItem.CANO);
            gf_MCALog('Input._CANO                  : ' + fAccInputItem._CANO);
            gf_MCALog('Input.ACNT_PRDT_CD           : ' + fAccInputItem.ACNT_PRDT_CD);
            gf_MCALog('Input._ACNT_PRDT_CD          : ' + fAccInputItem._ACNT_PRDT_CD);
            gf_MCALog('Input.POUT_FILE_NAME         : ' + fAccInputItem.POUT_FILE_NAME);
            gf_MCALog('Input._POUT_FILE_NAME        : ' + fAccInputItem._POUT_FILE_NAME);
            gf_MCALog('Input.ITFC_ID                : ' + fAccInputItem.ITFC_ID);
            gf_MCALog('Input._ITFC_ID               : ' + fAccInputItem._ITFC_ID);

            gf_MCALog('Output.NRML_PRCS_YN          : ' + fAccOutputItem.NRML_PRCS_YN);
            gf_MCALog('Output._NRML_PRCS_YN         : ' + fAccOutputItem._NRML_PRCS_YN);
          end else
          //-- [Log] 선물 수수료정보 -------------------------------------------
          if (Trim(HeaderInfo.Tr_name) = gcMCA_TR_F_COMM_INFO) then
          begin
            gf_MCALog('Input.ACNT_ADMN_ORGNO        : ' + fAccCommInputItem.ACNT_ADMN_ORGNO);
            gf_MCALog('Input._ACNT_ADMN_ORGNO       : ' + fAccCommInputItem._ACNT_ADMN_ORGNO);
            gf_MCALog('Input.INQR_DT                : ' + fAccCommInputItem.INQR_DT);
            gf_MCALog('Input._INQR_DT               : ' + fAccCommInputItem._INQR_DT);
            gf_MCALog('Input.CANO                   : ' + fAccCommInputItem.CANO);
            gf_MCALog('Input._CANO                  : ' + fAccCommInputItem._CANO);
            gf_MCALog('Input.ACNT_PRDT_CD           : ' + fAccCommInputItem.ACNT_PRDT_CD);
            gf_MCALog('Input._ACNT_PRDT_CD          : ' + fAccCommInputItem._ACNT_PRDT_CD);
            gf_MCALog('Input.POUT_FILE_NAME         : ' + fAccCommInputItem.POUT_FILE_NAME);
            gf_MCALog('Input._POUT_FILE_NAME        : ' + fAccCommInputItem._POUT_FILE_NAME);
            gf_MCALog('Input.ITFC_ID                : ' + fAccCommInputItem.ITFC_ID);
            gf_MCALog('Input._ITFC_ID               : ' + fAccCommInputItem._ITFC_ID);

            gf_MCALog('Output.NRML_PRCS_YN          : ' + fAccCommOutputItem.NRML_PRCS_YN);
            gf_MCALog('Output._NRML_PRCS_YN         : ' + fAccCommOutputItem._NRML_PRCS_YN);
          end else
          //-- [Log] 선물 예탁 -------------------------------------------------
          if (Trim(HeaderInfo.Tr_name) = gcMCA_TR_F_DEPOSIT) then
          begin
            gf_MCALog('Input.ACNT_ADMN_ORGNO        : ' + fDepoInputItem.ACNT_ADMN_ORGNO);
            gf_MCALog('Input._ACNT_ADMN_ORGNO       : ' + fDepoInputItem._ACNT_ADMN_ORGNO);
            gf_MCALog('Input.INQR_DT                : ' + fDepoInputItem.INQR_DT);
            gf_MCALog('Input._INQR_DT               : ' + fDepoInputItem._INQR_DT);
            gf_MCALog('Input.CANO                   : ' + fDepoInputItem.CANO);
            gf_MCALog('Input._CANO                  : ' + fDepoInputItem._CANO);
            gf_MCALog('Input.ACNT_PRDT_CD           : ' + fDepoInputItem.ACNT_PRDT_CD);
            gf_MCALog('Input._ACNT_PRDT_CD          : ' + fDepoInputItem._ACNT_PRDT_CD);
            gf_MCALog('Input.POUT_FILE_NAME         : ' + fDepoInputItem.POUT_FILE_NAME);
            gf_MCALog('Input._POUT_FILE_NAME        : ' + fDepoInputItem._POUT_FILE_NAME);
            gf_MCALog('Input.ITFC_ID                : ' + fDepoInputItem.ITFC_ID);
            gf_MCALog('Input._ITFC_ID               : ' + fDepoInputItem._ITFC_ID);

            gf_MCALog('Output.NRML_PRCS_YN          : ' + fDepoOutputItem.NRML_PRCS_YN);
            gf_MCALog('Output._NRML_PRCS_YN         : ' + fDepoOutputItem._NRML_PRCS_YN);
          end else
          //-- [Log] 선물 매매 -------------------------------------------------
          if (Trim(HeaderInfo.Tr_name) = gcMCA_TR_F_TRADE) then
          begin
            gf_MCALog('Input.ACNT_ADMN_ORGNO        : ' + fTradeInputItem.ACNT_ADMN_ORGNO);
          //gf_MCALog('Input._ACNT_ADMN_ORGNO       : ' + fTradeInputItem._ACNT_ADMN_ORGNO);
            gf_MCALog('Input.INQR_DT                : ' + fTradeInputItem.INQR_DT);
          //gf_MCALog('Input._INQR_DT               : ' + fTradeInputItem._INQR_DT);
            gf_MCALog('Input.CANO                   : ' + fTradeInputItem.CANO);
          //gf_MCALog('Input._CANO                  : ' + fTradeInputItem._CANO);
            gf_MCALog('Input.ACNT_PRDT_CD           : ' + fTradeInputItem.ACNT_PRDT_CD);
          //gf_MCALog('Input._ACNT_PRDT_CD          : ' + fTradeInputItem._ACNT_PRDT_CD);
            gf_MCALog('Input.POUT_FILE_NAME         : ' + fTradeInputItem.POUT_FILE_NAME);
          //gf_MCALog('Input._POUT_FILE_NAME        : ' + fTradeInputItem._POUT_FILE_NAME);
            gf_MCALog('Input.ITFC_ID                : ' + fTradeInputItem.ITFC_ID);
          //gf_MCALog('Input._ITFC_ID               : ' + fTradeInputItem._ITFC_ID);

            gf_MCALog('Output.NRML_PRCS_YN          : ' + fTradeOutputItem.NRML_PRCS_YN);
          //gf_MCALog('Output._NRML_PRCS_YN         : ' + fTradeOutputItem._NRML_PRCS_YN);
          end else
          //-- [Log] 선물 미결제 -----------------------------------------------
          if (Trim(HeaderInfo.Tr_name) = gcMCA_TR_F_OPEN) then
          begin
            gf_MCALog('Input.ACNT_ADMN_ORGNO        : ' + fOpenInputItem.ACNT_ADMN_ORGNO);
            gf_MCALog('Input._ACNT_ADMN_ORGNO       : ' + fOpenInputItem._ACNT_ADMN_ORGNO);
            gf_MCALog('Input.INQR_DT                : ' + fOpenInputItem.INQR_DT);
            gf_MCALog('Input._INQR_DT               : ' + fOpenInputItem._INQR_DT);
            gf_MCALog('Input.CANO                   : ' + fOpenInputItem.CANO);
            gf_MCALog('Input._CANO                  : ' + fOpenInputItem._CANO);
            gf_MCALog('Input.ACNT_PRDT_CD           : ' + fOpenInputItem.ACNT_PRDT_CD);
            gf_MCALog('Input._ACNT_PRDT_CD          : ' + fOpenInputItem._ACNT_PRDT_CD);
            gf_MCALog('Input.POUT_FILE_NAME         : ' + fOpenInputItem.POUT_FILE_NAME);
            gf_MCALog('Input._POUT_FILE_NAME        : ' + fOpenInputItem._POUT_FILE_NAME);
            gf_MCALog('Input.ITFC_ID                : ' + fOpenInputItem.ITFC_ID);
            gf_MCALog('Input._ITFC_ID               : ' + fOpenInputItem._ITFC_ID);

            gf_MCALog('Output.NRML_PRCS_YN          : ' + fOpenOutputItem.NRML_PRCS_YN);
            gf_MCALog('Output._NRML_PRCS_YN         : ' + fOpenOutputItem._NRML_PRCS_YN);
          end else
          //-- [Log] 선물 대용 -------------------------------------------------
          if (Trim(HeaderInfo.Tr_name) = gcMCA_TR_F_COLT) then
          begin
            gf_MCALog('Input.ACNT_ADMN_ORGNO        : ' + fColtInputItem.ACNT_ADMN_ORGNO);
            gf_MCALog('Input._ACNT_ADMN_ORGNO       : ' + fColtInputItem._ACNT_ADMN_ORGNO);
            gf_MCALog('Input.INQR_DT                : ' + fColtInputItem.INQR_DT);
            gf_MCALog('Input._INQR_DT               : ' + fColtInputItem._INQR_DT);
            gf_MCALog('Input.CANO                   : ' + fColtInputItem.CANO);
            gf_MCALog('Input._CANO                  : ' + fColtInputItem._CANO);
            gf_MCALog('Input.ACNT_PRDT_CD           : ' + fColtInputItem.ACNT_PRDT_CD);
            gf_MCALog('Input._ACNT_PRDT_CD          : ' + fColtInputItem._ACNT_PRDT_CD);
            gf_MCALog('Input.POUT_FILE_NAME         : ' + fColtInputItem.POUT_FILE_NAME);
            gf_MCALog('Input._POUT_FILE_NAME        : ' + fColtInputItem._POUT_FILE_NAME);
            gf_MCALog('Input.ITFC_ID                : ' + fColtInputItem.ITFC_ID);
            gf_MCALog('Input._ITFC_ID               : ' + fColtInputItem._ITFC_ID);

            gf_MCALog('Output.NRML_PRCS_YN          : ' + fColtOutputItem.NRML_PRCS_YN);
            gf_MCALog('Output._NRML_PRCS_YN         : ' + fColtOutputItem._NRML_PRCS_YN);}
          end;
          //--------------------------------------------------------------------
          //  [Output Data Log]
          //--------------------------------------------------------------------
                    
        end;
      end; // Case - gcMCA_SOCKET_DATA:

      gcMCA_SOCKET_CLOSE:
      begin

      end;
    END; // Case - gcMCA_SOCKET_CLOSE:

  Except
  End;
  // CopyData Ok.
  gvMCAReceive := True;

  LeaveCriticalSection(gvMCACriticalSection);
end;

function TMainFrame.LogSendMail(pSender: string): boolean;
var
  SndItem: pTFSndMail;
  SndMailData: TEMailSendFormat;
  ComSetupInfo: TIniFile;
  email: CHILKATMAILLib2_TLB.IChilkatEmail2;
  ChilkatMailMan21: TChilkatMailMan2;
  sSubjectStr: string;
  sAttachFile: string;
  iCnt, i: integer;
  MailAttList: TList;
  MailAttItem: pEMailSendAttach;
  sFileName, sErrMsg, sTokenFileName, Starttime: string;
  SR: TsearchRec;
begin
  try
    // 제목           // 증권사 + 부서 + 제목
    sSubjectStr := '';
    sSubjectStr := '[' + gvCompName + ' ' + gvDeptName + '] ';
    if pSender = 'S' then
    begin
      sSubjectStr := sSubjectStr + Trim('서버 로그 전송');
      sZipFilePathName := sExecPath + '..\..\Server\Log\ServerLog.ZIP';
    end else
    begin
      sSubjectStr := sSubjectStr + Trim('클라이언트 로그 전송');
    end;



    SndMailData.sSubjectData := sSubjectStr;

    SndMailData.sCurDate := gf_GetCurDate;
    //SndMailData.sTradeDate := ParentForm.JobDate;
    SndMailData.sDeptCode := gvDeptCode;
    SndMailData.sSecType := gcSEC_EQUITY;
    SndMailData.sOprID := gvOprUsrNo;
    SndMailData.sOprTime := gf_GetCurTime;

    SndMailData.sRcvMailAddr := 'settlenet@settlenet.co.kr;';


    SndMailData.iCurTotSeqNo := -1; // 초기화

    sFileName := sZipFilePathName + ';';

    // File Attach
    MailAttList := TList.Create;
    if not Assigned(MailAttList) then
    begin
      gvErrorNo := 9004;
      gvExtMsg := 'MailAttList - List Create Error';
      exit;
    end;

    iCnt := 1;
    sTokenFileName := '';
    while True do
    begin
      // ???????????????????????????????????????
      // 야매코딩...
      sTokenFileName := fnGetTokenStr(sFileName, gcSPLIT_MAILADDR, iCnt);
      if sTokenFileName = '' then break;
      New(MailAttItem);
      MailAttList.Add(MailAttItem);
      MailAttItem.sAttachFilePath := ExtractFilePath(sTokenFileName); //FileName에 모든 경로가 있다.
      MailAttItem.sAttachFileName := ExtractFileName(sTokenFileName);
      Inc(iCnt);
    end;

    // 메일서버로 전송!!
    Starttime := '';
    Result := fnEMailDataSend(@SndMailData, MailAttList, Starttime);
    // 전송중 오류
    if not Result then
    begin
      ShowMessage(gf_ReturnMsg(gvErrorNo) + ' (' + gvExtMsg + ')');
      //SndITem.ErrMsg := gf_ReturnMsg(gvErrorNo) + ' (' + gvExtMsg + ')';
      //SndItem.StartTime := gf_GetCurTime;

      //DisplaySndMailItem(SndItem);
      Exit;
    end;

    // Clear MailList
    for I := 0 to MailAttList.Count - 1 do
    begin
      MailAttItem := MailAttList.Items[I];
      Dispose(MailAttItem);
    end;
    MailAttList.Clear;
    {
    // Temp 디렉토리 삭제 Send시 만들어짐
    if FindFirst(gvDirTemp + '\*.*', faDirectory, SR) = 0 then
      repeat
        begin
          if (Sr.Name <> '.') and (Sr.Name <> '..') then
          begin
            if DirectoryExists(gvDirTemp + SR.Name) then
              ExRemoveDir(gvDirTemp + SR.Name);
          end;
        end;
      until FindNext(SR) <> 0;
      }
  finally
    if sErrMsg <> '' then
      ShowMessage('[Log Send] Error ' + sErrMsg);

  end;



  {
  ComSetupInfo := TIniFile.Create(sExecPath + '..\..\Server\Cfg\UserServer.INI');

  success := ChilkatMailMan21.UnlockComponent('DATAROMAILQ_Z00x2Xqm3H9l');
  if (success <> 1) then
  begin
    ShowMessage('Component unlock failed');
    Exit;
  end;

  gvIniPasswordEncryption := ComSetupInfo.ReadBool('Client Setup','IniPasswordEncryption',False);


  //Create a new email object
  // 새로운 이멜 만들기
  email := ChilkatMailMan21.NewEmail();
  email.charset := Trim(ComSetupInfo.ReadString('Client Setup','EMAIL_CHARSET',''));  // 받던가~~ 고정하던가~~ 화면 만들거냐 ㅠ_ㅠ

  // 케릭터셋 지정
  Email.PreferredCharset := ComSetUpInfo.ReadString('Client Setup', 'EMAIL_CTENCODING', '');


  email.Subject := sSubjectStr;

  // 내용
  //email.Body := Trim(e_body.Text);

  // 보내는 사람 이름
  email.fromName := '데이터로드';

  //보내는 사람 주소
  email.FromAddress := 'settlenet@settlenet.co.kr';

  // 중요 메일 처리 수작업 밖에 없음 1이 중요
  email.AddHeaderField('X-Priority', '1');

  // 싱글멜
  email.AddTo(Trim(edt_ToAddr.text), Trim(edt_ToAddr.text));

  sAttachFile := sZipFilePathName;

  email.AddFileAttachment2(sAttachFile,''); // ?????????????????

  // 포트 설정
  ChilkatMailMan21.SmtpPort := StrToInt(ComSetUpInfo.ReadString('Client Setup', 'EMAIL_SEND_SVRPORT', ''));   // 서버정보에 ini 가져 와야 할듯????????????????? ㅠㅠ

  //  Set the SMTP server.
  ChilkatMailMan21.SmtpHost := Trim(ComSetupInfo.ReadString('Client Setup', 'EMAIL_SEND_SMTP', ''));

  // 인증방식   Set the SMTP login/password
  ChilkatMailMan21.SmtpAuthMethod := Trim(ComSetupInfo.ReadString('Client Setup','EMAIL_AUTH_TYPE', ''));
  ChilkatMailMan21.SmtpUsername := Trim(ComSetupInfo.ReadString('Client Setup','EMAIL_SEND_USERID', ''));

  // 암호화/복호화에 따른 암호 가져오기
  if gvIniPasswordEncryption then
  begin
    ChilkatMailMan21.SmtpPassword := gfPasswordDecryption(ComSetUpInfo.ReadString('Client Setup', 'EMAIL_SEND_PASSWD', ''));
  end else
  begin
    ChilkatMailMan21.SmtpPassword := ComSetUpInfo.ReadString('Client Setup', 'EMAIL_SEND_PASSWD', '');
  end;

  try
    // 멜 보내기
    ok := ChilkatMailMan21.SendEmail(email as CHILKATMAILLib2_TLB.IChilkatEmail2);
    // 에러 체크
    if (ok <> 1) then
    begin
      showmessage('SEND-ERROR' + ChilkatMailMan21.LastErrorText);
      //Memo_Error.Lines.Add(ChilkatMailMan21.LastErrorText);
      //gf_ShowMessage(MessageBar, mtError, 0, 'SEND-ERROR');
      exit;
    end;

    if UpperCase(ParamStr(1)) <> '-A' then ShowMessage('전송완료!');
    //MessageBar.ShowMessage(mtInformation, '전송완료');

  finally
    // Pop3 열러 있으면 접속 해지
    //if c_pop3.Checked then
    //  ChilkatMailMan21.Pop3EndSession();

    ok := ChilkatMailMan21.CloseSmtpConnection();
    if (ok <> 1) then
    begin
      ShowMessage('Connection to SMTP server not closed cleanly.');
      //Memo_Error.Lines.Add(ChilkatMailMan21.LastErrorText);
      //gf_ShowMessage(MessageBar, mtError, 0, 'Connection to SMTP server not closed cleanly.');
    end;
  end;
  }


end;

// 압축실행

function TMainFrame.Runzip(sTarget: string): Boolean;
var
  sDirLog, sZipFilePath: string;
  sFileName: string;
  FileAttrs: Integer;
  FileCnt: integer;
  sr: TSearchRec;
  sPw: string;
  tmp: string;
begin
  try
    // 위치확인.. 서버 / 클라이언트
    {
    if sTarget  = 'S' then sDirLog := '..\..\Server\Log\'
    else if sTarget  = 'C' then sDirLog := '..\Log\'
    else Exit;
    }

    if sTarget = 'C' then sDirLog := '..\Log\'
    else Exit;

    Result := False;

    tmp := sExecPath + 'DelZip190.dll';
    if not FileExists(tmp) then
    begin
      ShowMessage('' + sExecPath + 'DelZip190.dll 파일이 존재하지 않습니다.');
      exit;
    end;

    // 압축 비밀번호 설정 ㅡ ㅅ ㅡ
    {
    if gf_GetSystemOptionValue('E34', '') <> '' then
    begin
      sPw := gfEncryption(Trim(gf_GetSystemOptionValue('E34', ''), 'O', Temp));
    end;
    }

    // 압축 dll 처리
    Zip.DLL_Load := False;
//    Zip.DLLDirectory := sExecPath + '..\..\Server\Bin\DelZip190.dll';  //   C:\SettleNet\Server\Bin
    Zip.DLLDirectory := sExecPath + 'DelZip190.dll'; //   C:\SettleNet\Server\Bin
    Zip.DLL_Load := True;

    // ShowMessage(Zip.DLLDirectory);

    //-- 압축 대상 파일 처리(~\Temp\ 폴더내의 모든 파일) -------------------------
    FileAttrs := faAnyFile; // 파일 속성 (모든 파일)

    Zip.FSpecArgs.Clear;

    if FindFirst(sExecPath + sDirLog + '*.*', FileAttrs, sr) = 0 then
    begin
      repeat
        if not ((sr.Name = '.') or (sr.Name = '..')) then
        begin
          Inc(FileCnt);
          Zip.FSpecArgs.Add(sExecPath + sDirLog + sr.Name);
        end;
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;

    // 압축 파일명
    sZipFilePath := sExecPath + sDirLog;
    // 파일명 포맷 변환
      //if sTarget  = 'S' then sFileName := 'ServerLog.ZIP' else sFileName := 'ClientLog.ZIP';
    sFileName := 'ClientLog.ZIP';

    sZipFilePathName := sZipFilePath + sFileName;

    Zip.Password := 'dataroad,.';
    Zip.AddOptions := [AddEncrypt];

      // ShowMessage(sZipFilePathName);

    Zip.ZipFileName := sZipFilePathName;
    Zip.OnProgress := ZipStatus;

    bZipBatchRun := True;
    Zip.Add; // 압축
      // 기다리기
    while bZipBatchRun do Sleep(1000);

    Result := True;
  finally
    // if Assigned(Icon) then Icon.Free;
    Zip.DLL_Load := false;
  end;

end;

procedure TMainFrame.ZipStatus(Sender: TObject;
  details: TZMProgressDetails);
begin
  case details.Order of
    EndOfBatch: bZipBatchRun := False;
  end;
end;



function TMainFrame.UserTrCheck : boolean;
begin
  Result := false;
  with DataModule_SettleNet.ADOQuery_Main do
  begin
     Close;
     SQL.Clear;
     SQL.Add(' SELECT * FROM SUUSER_TBL U ');
     sql.Add(' WHERE  USER_ID = ''' + gvOprUsrNo + ''' ');
     sql.Add('   and USER_GRP_CODE IN (SELECT USER_GRP_CODE FROM SUUGPTR_TBL  WHERE TR_CODE = ''9104'' AND U.DEPT_CODE = SUUGPTR_TBL.DEPT_CODE) ');
     SQL.Add('     AND DEPT_CODE = ''' + gvDeptCode +''' ');


    Try
       gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
    Except  // DataBase 오류입니다.
       On E: Exception do
       begin
          Exit;
       end;
    End;

    if recordcount > 0 then     Result := True;

  end; // with ADOQuery_Main do
end;

end.



