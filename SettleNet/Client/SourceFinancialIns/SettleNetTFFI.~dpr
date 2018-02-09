//==============================================================================
//   [LMS] 2000/05/24
//==============================================================================
program SettleNetTFFI;

uses
  Forms,
  Windows,
  DB,
  SysUtils,
  Dialogs,
  ShellAPI,
  Messages,
  TlHelp32,
  Graphics,
  SCCChildForm in '..\Common\SCCChildForm.pas' {Form_SCF},
  SCFHFIMain in 'SCFHFIMain.pas' {Form_MainFrameFI},
  SCCDataModule in '..\Common\SCCDataModule.pas' {DataModule_SettleNet: TDataModule},
  SCCLogin in '..\Common\SCCLogin.pas' {form_login},
  SCCGlobalType in '..\Common\SCCGlobalType.pas',
  SCCLoading in '..\Common\SCCLoading.pas' {Form_Loading},
  SCCLib in '..\Common\SCCLib.pas',
  SCCDlgForm in '..\Common\SCCDlgForm.pas' {Form_Dlg},
  SCCSRMgrFrame in '..\Common\SCCSRMgrFrame.pas' {Form_SRMgrFrame},
  SCCSRMgrForm in '..\Common\SCCSRMgrForm.pas' {Form_SRMgrForm},
  SCCSRMgrForm_RCV in '..\Common\SCCSRMgrForm_RCV.pas' {Form_SCF_RCV},
  SCCSRMgrForm_SND in '..\Common\SCCSRMgrForm_SND.pas' {Form_SCF_SND},
  SCCChildForm_Import in '..\Common\SCCChildForm_Import.pas' {Form_SCF_Import},
  SCFH2101_DAETOO in 'SCFH2101_DAETOO.pas',
  SCFH2101_HANTOO in 'SCFH2101_HANTOO.pas',
  SCCSRMgrForm_AC in '..\Common\SCCSRMgrForm_AC.pas' {Form_SCF_AC},
  SCCUpdate in '..\Common\SCCUpdate.pas' {Form_Update},
  ThreadCL2Md in '..\Common\ThreadCL2Md.pas';

{$R *.RES}
var
  RetValue: Integer;
  MyRoleCode: string;
  HWnd: THandle;
  icon: TIcon;
  sMsg, sId, sPw, sUserSvrChk: string;
  i : Integer;
begin

  //날짜 형식 관련 전역변수 세팅
  //OS 설정에 따라 오류 발생 방지 2011.06.10
  ShortDateFormat := 'yyyy-mm-dd';
  DateSeparator := '-';

//Crystal 10 Dll은 반드시 Registry에 등록해서 써야 한다.
//별도로 Settup 작업을 하면 되지만 두고두고 귀찮은 작업이다
//따라서 Registry를 건들 수 없는 외국계를 제외하고
//Application 초입에 자동으로 Crystal Dll을 설치한다.
//물론, 기 설치된 PC는 제외한다.
  gf_DllSetup; //2006.04.10 Delphi 7 version 추가 1

  HWnd := FindWindow('TForm_MainFrameFI', nil);
//==========================================
  HWnd := 0; //debugging 시에 필요함
//==========================================
  if HWnd = 0 then // SettleNet이 실행중이 아닐때
  begin
    Application.Initialize;

      //Broker Program
    MyRoleCode := gcROLE_BROKER;

      //----------------------------------
    gvLogFlag := TRUE; // Log File 생성
      //----------------------------------
    gvRoleCode := 'B';
    gf_StartLog(gf_GetAppRootPath + 'Log/', 'SN' + gvRoleCode + 'Log'); // Log File 초기화
    gf_Log('============================================================================');
    gf_Log('Before Login');
      //----------------------------------------------------------------------------
      // Login 처리
      //----------------------------------------------------------------------------
    try
      if Trim(ParamStr(3)) = '' then
      begin
        Form_Login := TForm_Login.Create(Application);
        // 일반 실행
        RetValue := Form_Login.ShowModal;
        sId := Form_Login.DREdit_OprUsrNo.Text;
        sPw := Form_Login.DREdit_Pswrd.Text;
        sUserSvrChk := 'True';
        if gv2TierLoginYN = 'Y' then
          sUserSvrChk := 'False';
      end else
      // 파라미터값이 넘어오면 프로그램 재시작으로 간주
      begin
        //[Y.S.M] 2013.07.23
        {gf_log('Client Version Upgrade->'  +
               ' Paramstr [1]' + Trim(ParamStr(1))
                       + '[2]' + Trim(ParamStr(2))
                       + '[3]' + Trim(ParamStr(3))
                       + '[END]' ); }
        gf_log('Client Version Upgraded');
        Form_Update := TForm_Update.Create(Application);
        Form_Update.Show;
        for i := 5 downto 1 do
        begin
          Form_Update.DRLabel_Time.Caption := inttostr(i) + '초 후';
          Form_Update.Refresh;
          Sleep(1000);
        end;
        Form_Update.Close;
        Form_Update.Free;
        // 3Tier 처리 시 쓰레드 함수처리가 되기전
        // Form_Login폼 Free가 먼저되서 처리 못함 방지 변수
        bReStartWait := True;
        
        Form_Login := TForm_Login.Create(Application);
        //id
        Form_Login.DREdit_OprUsrNo.Text := Trim(ParamStr(1));
        //pw
        Form_Login.DREdit_Pswrd.Text := Trim(ParamStr(2));
        //UserSvr
        if (Trim(ParamStr(3)) = 'False') then
          Form_Login.DRCheckBox_Eye.Checked := False
        else
          Form_Login.DRCheckBox_Eye.Checked := True;
        Form_Login.FormActivate(Form_Login);
        Form_Login.DRColorBtn_OkClick(Form_Login.DRColorBtn_Ok);
        RetValue := IDOK;
        // 3Tier 처리 시 쓰레드 함수처리가 되기전
        // Form_Login폼 Free가 먼저되서 처리 못함 방지
        while bRestartWait do
        begin
          Application.ProcessMessages;
          Sleep(10);
        end;
      end;
      sMsg := Form_Login.DRPanel_msg.Caption;
      Form_login.Free;
    except
      gf_ShowErrDlgMessage(0, 0, '로그온 중 오류가 발생하였습니다.'
        + gcMsgLineInterval + '재접속을 시도하십시오.', 0);
      Form_login.Free;
      Application.Terminate;
      Exit;
    end;

    if RetValue <> idOK then
    begin
      Application.Terminate;
      //[Y.S.M] 2013.07.23
      //Program Upgraded 상태면 재시작
      if sMsg = 'Program Upgraded! ' then
      begin
        // App 재시작
        ShellExecute(0, nil,  pchar(ExtractFileName(ParamStr(0))) ,
        pchar(sId +
          ' ' + sPw +
          ' ' + sUserSvrChk),  pchar(ExtractFilePath(ParamStr(0))), SW_SHOWDEFAULT);
      end;


      Exit;
    end;

    if MyRoleCode <> gvRoleCode then
    begin
      gf_ShowErrDlgMessage(0, 0, '이 프로그램은 BROKER용 입니다.'
        + gcMsgLineInterval + 'DATAROAD에 문의 바랍니다.', 0);
      Application.Terminate;
      Exit;
    end;

      //----------------------------------------------------------------------------
      // Loading Form Create
      //----------------------------------------------------------------------------
    Form_Loading := TForm_Loading.Create(Application);
    Form_Loading.Show;
    Form_Loading.Update;


    gf_Log('============================================================================');
    gf_Log(' SETTLENET BROKER START');
    gf_Log(' [' + gvOprUsrNo + '] ' + gvCompName);
    gf_Log('============================================================================');

      //----------------------------------------------------------------------------
      // DataBase Create
      //----------------------------------------------------------------------------
    gf_Log('Before Create DataModule_SettleNet');
  try
    Application.CreateForm(TDataModule_SettleNet, DataModule_SettleNet);
  except on E: Exception do
      begin
        gf_ShowErrDlgMessage(0, 0, 'DB 접속 오류입니다.' + gcMsgLineInterval + E.Message, 0);
        gf_Log('[E]DB Connection Error' + E.Message);
        Form_Loading.Free;
        Application.Terminate;
        Exit;
      end;
    end;
    gf_Log('After Create DataModule_SettleNet');

    gf_Log('Before Connect DataBase');
      //------------------------------------------------------------------------
      // [ADO] DATABASE 사용위해
      //------------------------------------------------------------------------
    with DataModule_SettleNet.ADOConnection_Main do
    begin
      if Connected then Connected := False;
      ConnectionString := 'Provider=SQLOLEDB.1;Persist Security Info=True;'
        + 'User ID=' + gvDBUserID + ';'
        + 'Password=' + gvDBPassWd + ';'
        + 'Data Source=' + gvDBServerName + ';';
      DefaultDatabase := gvDefaultDB;
      try
        Connected := True;
      except on E: Exception do
        begin
          gf_ShowErrDlgMessage(0, 0, 'DB 접속 오류입니다.' + gcMsgLineInterval + E.Message, 0);
          gf_Log('[E]DB Connection Error' + E.Message);
          Form_Loading.Free;
          gf_Log('Application Terminate');
          Application.Terminate;
          Exit;
        end;
      end;
    end;
    gf_Log('After Connect DataBase');

      //------------------------------------------------------------------------
      // [ADO] Thread가 DATABASE 사용위해
      //------------------------------------------------------------------------
    with DataModule_SettleNet.ADOConnection_Thread do
    begin
      if Connected then Connected := False;
      ConnectionString := 'Provider=SQLOLEDB.1;Persist Security Info=True;'
        + 'User ID=' + gvDBUserID + ';'
        + 'Password=' + gvDBPassWd + ';'
        + 'Data Source=' + gvDBServerName + ';';
      DefaultDatabase := gvDefaultDB;
      try
        Connected := True;
      except on E: Exception do
        begin
          gf_ShowErrDlgMessage(0, 0, 'Thread DB 접속 오류입니다.' + gcMsgLineInterval + E.Message, 0);
          gf_Log('[E]Thread DB Connection Error' + E.Message);
          Form_Loading.Free;
          gf_Log('Application Terminate');
          Application.Terminate;
          Exit;
        end;
      end;
    end;

    gf_Log('After Thread Connect DataBase');

    gf_Log('Before Create Form_MainFrameFI');
    Application.CreateForm(TForm_MainFrameFI, Form_MainFrameFI);
    gf_Log('After Create Form_MainFrameFI');

    Form_MainFrameFI.Show;

    // [하나대투] TCP/IP 초기화.
    if (gvHostGWUseYN = 'Y') and
       (gv2TierLoginYN <> 'Y') then
    begin
      gf_Log('Before Connect HostGW Socket');

      if fnComTcpIpInit = -1 then
      begin
        gf_Log('TcpOpen Fail!!!');
      end;

      gf_Log('After Connect HostGW Socket');
    end;

      //----------------------------------------------------------------------------
      //Loading Form Destroy
      //----------------------------------------------------------------------------
    Form_Loading.Free;

      // Access Control 처리
    SendMessage(gvMainFrameHandle, WM_USER_ACCESS_CONTROL_CHEK, 0, 0);

      //사용자가 설정한 SettleNet 프린터가
      //app loading시 제대로 다시 설정이 안되는 경우가 있다. (JP 김지영PC)
      //Printer.PrinterIndex := ... : 이게 assign은 되나 제대로 안먹힘.
      //이때 Printer Settup창을 띄운후 확인을 누르면 먹히더라. 그래서 꽁수.
    if gf_ReadFormStrInfo('Printer', 'SettupBeforeRun', 'N') = 'Y' then
    begin
      Form_MainFrameFI.PrintSettupShow;
    end;

    Application.Run;

  end
  else // 이미 실행되어 있는 경우
  begin
    ShowWindow(HWnd, SW_RESTORE);
    SetForeGroundWindow(Hwnd);
    Application.Terminate;
  end;
end.

