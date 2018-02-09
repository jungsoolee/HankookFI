//==============================================================================
//   [LMS] 2001/01/31
//==============================================================================
unit SCCLogin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DRStandard, DRAdditional, ExtCtrls, SCCCmuGlobal, IniFiles,
  ComCtrls, DRWin32, registry, Db, ADODB, Grids, DRStringgrid, Buttons,
  Menus;

type
  TForm_Login = class(TForm)
    DRPanel1: TDRPanel;
    DRColorBtn_Ok: TDRColorBtn;
    DRColorBtn_Cancel: TDRColorBtn;
    DRColorBtn_Setup: TDRColorBtn;
    DRLabel1: TDRLabel;
    DRLabel2: TDRLabel;
    DREdit_OprUsrNo: TDREdit;
    DREdit_Pswrd: TDREdit;
    DRPanel_msg: TDRPanel;
    DRPanel_Version: TDRPanel;
    DRProgressBar: TDRProgressBar;
    DRLabel3: TDRLabel;
    DRLabel_Percent: TDRLabel;
    DRPanel2: TDRPanel;
    DRImage1: TDRImage;
    DRLabel_Version: TDRLabel;
    ADOConnection_VersionSync: TADOConnection;
    ADOQuery_VersionSync: TADOQuery;
    DRPanel4: TDRPanel;
    DRPanel5: TDRPanel;
    DRBitBtn_DelHis: TDRBitBtn;
    DRStrGrid_His: TDRStringGrid;
    DRPanel3: TDRPanel;
    DRLabel4: TDRLabel;
    DRLabel5: TDRLabel;
    DRLabel6: TDRLabel;
    DRLabel7: TDRLabel;
    DREdit_DBServer: TDREdit;
    DREdit_DBName: TDREdit;
    DREdit_DBUserId: TDREdit;
    DREdit_DBPassword: TDREdit;
    DRCheckBox_Eye: TDRCheckBox;
    DRImage_CapsLock: TDRImage;
    PopupMenu1: TDRPopupMenu;
    ADOConnection_DeptInfo: TADOConnection;
    ADOQuery_DeptInfo: TADOQuery;
    procedure DREdit_OprUsrNoChange(Sender: TObject);
    procedure DREdit_OprUsrNoKeyPress(Sender: TObject; var Key: Char);
    procedure DREdit_PswrdKeyPress(Sender: TObject; var Key: Char);
    procedure DRColorBtn_OkClick(Sender: TObject);
    procedure DRColorBtn_CancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DRPanel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DRColorBtn_SetupClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DREdit_PswrdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DREdit_PswrdExit(Sender: TObject);
    procedure DREdit_PswrdEnter(Sender: TObject);
    procedure DRStrGrid_HisSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormShow(Sender: TObject);
    procedure DRStrGrid_HisFiexedRowClick(Sender: TObject; ACol: Integer);
    procedure DRBitBtn_DelHisClick(Sender: TObject);
    procedure DRCheckBox_EyeClick(Sender: TObject);
    procedure DRPanel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DRStrGrid_HisMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    function  DeptInfo(pSqlServer, pDbName : String)  : boolean;
    procedure PopupItemClick(pDeptCode : String);
    procedure PopupClick(Sender: TObject);
  private
    procedure OnLoginData(var Msg : TMessage); message WM_USER_TCPIP_CLIENT_LOGSND;
    procedure WMNCHitTest(var Msg : TWMNCHitTest); message WM_NCHITTEST;
    function NRWConnect(NRWName: string; Num: integer): boolean;
  public
    { Public declarations }
  end;

var
  Form_Login: TForm_Login;
implementation

{$R *.DFM}

uses
   SCCCmuLib, SCCGlobalType, SCCTcpIp, SCCEnvSetup, SCCLib;

const
   RtnSuccess  = 1;
   UsrIdError  = -1;
   PswrdError  = -2;
   WorkStError = -3;
   MsgColor    = $00E1FFFF;

var
   isCapsLock : Boolean;
   SortFlag0, SortFlag1 : Boolean;
   FormShowed : boolean;
   DeptInfoList : tStringlist;

procedure TForm_login.OnLoginData(var Msg : TMessage);
var
  sMsg : string;
  EnvSetupInfo : TIniFile;
  nLgGigan  : Integer;
  sLstLgDt, sCurDate, sCurTime, sSvrName  : String;
  sAuthor : String;
  i, iHisCount : integer;
  bExists : boolean;
  sShortPass, sFullPass : string;
  procedure History2TierWriteIni;
  var
    i : Integer;
  begin
    if (gv2TierLoginYN = 'Y') then
    begin
     EnvSetupInfo := TIniFile.Create(gvDirCfg + gcMainIniFileName);
     EnvSetupInfo.WriteString('History', 'LastIP', Trim(DREdit_DBServer.Text));
     EnvSetupInfo.WriteString('History', 'LastDB', Trim(DREdit_DBName.Text));
     iHisCount := DRStrGrid_His.RowCount -1;
     //Config add---------------------
     bExists := false;
     with DRStrGrid_His do
     begin

       if  (RowCount = 2)
       and (Cells[0,1] = '') then
         iHisCount := 0;

       for i := 1 to RowCount -1 do
       begin
         if  (Cells[0,i] = Trim(DREdit_DBServer.Text))
         and (Cells[1,i] = Trim(DREdit_DBName.Text)) then
         begin
           bExists := true;
           Break;
         end;
       end;

       if Not bExists then
       begin
         Cells[0,RowCount] := Trim(DREdit_DBServer.Text);
         Cells[1,RowCount] := Trim(DREdit_DBName.Text);
         RowCount := RowCount + 1;
         iHisCount := iHisCount + 1;
       end;
       EnvSetupInfo.WriteString('History', 'HisCount', IntToStr(iHisCount));

       if iHisCount > 0 then
       begin
         for i := 1 to iHisCount do
         begin
           EnvSetupInfo.WriteString('History', 'IP' + IntToStr(i), Cells[0,i]);
           EnvSetupInfo.WriteString('History', 'DB' + IntToStr(i), Cells[1,i]);
         end;
       end;
     end;
     EnvSetupInfo.Free;
    end;
  end;

begin
   DREdit_OprUsrNo.Enabled := True;
   DREdit_Pswrd.Enabled := True;
   DRColorBtn_Ok.Enabled := True;
   DRColorBtn_Cancel.Enabled := True;
   DRColorBtn_Setup.Enabled := True;
   Screen.Cursor := crDefault;

   // LocalHost IP ��������
   gf_GetLocalIP(sSvrName, gvLocalIP);

   // Server Error
   if Msg.WParam = gcTCPIP_CLIENT_LOGSND_WPARAM_LOGIN_FAILD then
   begin
      DRPanel_msg.Color   := MsgColor;
      DRPanel_msg.caption := ' ' + gvDataBuff;
      DREdit_OprUsrNo.SelectAll;
      DREdit_OprUsrNo.SetFocus;
      Exit;
   end else
   if Msg.WParam =gcTCPIP_CLIENT_LOGSND_WPARAM_LOGIN_VERSIONUP then
   begin
     //gf_ShowErrDlgMessage(0, 0, 'Client Version Upgrade�� �Ϸ�Ǿ����ϴ�.'
     //           + gcMsgLineInterval + '������ �������� �õ��Ͻʽÿ�.',0);
     ModalResult := idAbort;
     Exit;
   end;

   with ADOConnection_VersionSync do
   begin
    if Connected then Connected := False;
    ConnectionString := 'Provider=SQLOLEDB.1;Persist Security Info=True;'
                      + 'User ID=' + gvDBUserID + ';'
                      + 'Password=' + gvDBPassWd + ';'
                      + 'Data Source=' + gvDBServerName + ';';
    DefaultDatabase := gvDefaultDB;
      Try
         Connected := True;
      Except on E: Exception do
         begin
            gf_ShowErrDlgMessage(0, 0, 'DB ���� ����. Version Sync. ' + gcMsgLineInterval + E.Message, 0);
            gf_Log('[E]DB Connection Error.Version Sync.' + E.Message);
            ModalResult := idAbort;
            Exit;
         end;
      End;
   end;

//==============================================================================
// Password ��ȣȭ Hash���
// CITI�� ���
//==============================================================================
  with ADOQuery_VersionSync do
  begin

     gvPassEnrpYN := 'N';

     Close;
     SQL.Clear;
     SQL.Add(' select Isnull(OPT_VALUE,''N'') as OPT_VALUE   '
           + ' from   SUSYOPT_TBL '
           + ' where  OPT_CODE  = ''T01'' ');


     gf_ADOQueryOpen(ADOQuery_VersionSync);

     if RecordCount > 0 then
     begin
         gvPassEnrpYN := Trim(FieldByName('OPT_VALUE').AsString);
     end;

     if (gvPassEnrpYN = 'Y') and (gvUserEnrpYN <> 'Y') then
     begin
        //write inifile
        EnvSetupInfo := TIniFile.Create(gvdirCfg + gcMainIniFileName);
        EnvSetupInfo.WriteString('User Information', 'Encryption', 'Y');
        EnvSetupInfo.free;

        gvUserEnrpYN := 'Y';
     end else
     if (gvPassEnrpYN <> 'Y') and (gvUserEnrpYN = 'Y') then
     begin
        //write inifile
        EnvSetupInfo := TIniFile.Create(gvdirCfg + gcMainIniFileName);
        EnvSetupInfo.WriteString('User Information', 'Encryption', 'N');
        EnvSetupInfo.free;
     end;

     gf_Log('After PassWord Encrption');

  end;

//==============================================================================
// ���ӱ��� üũ
//==============================================================================
   with ADOQuery_VersionSync do
   begin

      //2-Tier ����  �α�ID, �н����� üũ Start -------------------------------
      if gv2TierLoginYN = 'Y' then
      begin
        Close;
        SQL.Clear;
        SQL.Add(' select PASSWD  '
              + ' from   SUUSER_TBL '
              + ' WHERE USER_ID = '''+ DREdit_OprUsrNo.Text + ''' ');

        gf_ADOQueryOpen(ADOQuery_VersionSync);

        if RecordCount = 0 then
        begin
          DRPanel_msg.Color   := MsgColor;
          DRPanel_msg.caption := ' User ID Not Found!';
          DREdit_OprUsrNo.SelectAll;
          DREdit_OprUsrNo.SetFocus;
          Exit;
        end
        else
        //--------------------------------------------------------------------------
        // [Y.K.J] ��ȣȭ(SHA256) ��� ���濡 ���� ó�� ���� �߰�.
        //--------------------------------------------------------------------------
        // ��ȣȭ Hash ��� ���� & ����� ��ȣ ���� üũ
        if (gvPassEnrpYN = 'Y') and (Length(Trim(gvOprPassWd)) < 64) then
        // ��ȣȭ �� ��ȣ ó��
        begin
          // �Ϲ� ��ȣȭ �� SHA256 Hash �� ����.
          sFullPass := gfEncryption(gfDecryption(Trim(gvOprPassWd), 'N'), 'Y', sShortPass);

          // ��ȯ�� Hash ���� ������ ���� ��
          if Trim(sFullPass) <> Trim(FieldByName('PASSWD').asString) then
          begin
            // ���� ��ȣȭ ���('MD5')���� üũ
            sShortPass := gfDecryption(Trim(FieldByName('NEW_PASSWD').asString), 'Y');
            gfEncryption(sShortPass, 'O', sFullPass);

            if Trim(gvOprPassWd) <> Trim(sFullPass) then
            begin
              DRPanel_msg.Color   := MsgColor;
              DRPanel_msg.caption := ' Password ����!';
              DREdit_Pswrd.SelectAll;
              DREdit_Pswrd.SetFocus;
              Exit;
            end;

          end;
        end else
        // �Ϲ� ��ȣ �� ó��
        begin
          if Trim(gvOprPassWd) <> Trim(FieldByName('PASSWD').AsString) then
          begin
            DRPanel_msg.Color   := MsgColor;
            DRPanel_msg.caption := ' Password ����!';
            DREdit_Pswrd.SelectAll;
            DREdit_Pswrd.SetFocus;
            Exit;
          end;
        end;
      end;
      //2-Tier ����  �α�ID, �н����� üũ End   -------------------------------

      Close;
      SQL.Clear;
      SQL.Add(' select LASTLOG_DATE  = ISNULL(LASTLOG_DATE,''''),  '
            + '        LASTLOG_GIGAN = ISNULL((SELECT CASE WHEN (ACONT_YN = ''Y'') THEN LASTLOG_GIGAN ELSE 0 END FROM SUACCCON_TBL),0), '
            + '        AUTHORITY, DEPT_CODE  '
            + ' from   SUUSER_TBL '
            + ' WHERE USER_ID = '''+DREdit_OprUsrNo.Text+''' ');

      gf_ADOQueryOpen(ADOQuery_VersionSync);

      if RecordCount > 0 then
      begin
         //���� �α�� �������� �����ִ� ������ �����ϳ�, ���⼭ ���Ѵ�. �ֳ�? 2-Tier�� ���޾Ƽ�
         gvDeptCode := Trim(FieldByName('DEPT_CODE').AsString);
         
         nLgGigan := FieldByName('LASTLOG_GIGAN').AsInteger;
         sLstLgDt := Trim(FieldByName('LASTLOG_DATE').AsString);
         sAuthor  := Trim(FieldByName('AUTHORITY').AsString);
         sCurDate := FormatDateTime('YYYYMMDD', now);

         if (nLgGigan > 0) and (sLstLgDt <> '') then
         begin
            if gf_Getstgigan(sLstLgDt, sCurDate) >= nLgGigan then
            begin
               DRPanel_msg.Color   := MsgColor;
               DRPanel_msg.caption := ' ' + '�����Ⱓ ���������ʾ� ������ ������ ������Դϴ�.';
               DREdit_OprUsrNo.SelectAll;
               DREdit_OprUsrNo.SetFocus;
               gf_ShowErrDlgMessage(0, 0, '�����Ⱓ ���������ʾ� ������ ������ ������Դϴ�.'
                         + gcMsgLineInterval + '������ �ٸ� ����ڷ� �������Ͻʽÿ�.',0);
               ModalResult := idAbort;

               //==============================================================================
               // �α��ν��� gcLogINF_fail
               //==============================================================================
               sCurTime := FormatDateTime('hhmmssmm', now);
               gf_LogLstWrite(ADOQuery_VersionSync, gvDeptCode, gcLogINF_fail, DREdit_OprUsrNo.Text,
                                sCurDate, sCurTime, sCurTime, '', '', '', 'Login Fail :' + DRPanel_msg.Caption, 'I');

               Exit;
            end;
         end;

         if sAuthor = 'N' then
         begin
            DRPanel_msg.Color   := MsgColor;
            DRPanel_msg.caption := ' ' + '������ ������ ������Դϴ�.';
            DREdit_OprUsrNo.SelectAll;
            DREdit_OprUsrNo.SetFocus;
            gf_ShowErrDlgMessage(0, 0, '������ ������ ������Դϴ�.'
                      + gcMsgLineInterval + '������ �ٸ� ����ڷ� �������Ͻʽÿ�.',0);
            ModalResult := idAbort;

            //==============================================================================
            // �α��ν��� gcLogINF_fail
            //==============================================================================
            sCurTime := FormatDateTime('hhmmssmm', now);
            gf_LogLstWrite(ADOQuery_VersionSync, gvDeptCode, gcLogINF_fail, DREdit_OprUsrNo.Text,
                             sCurDate, sCurTime, sCurTime, '', '', '', 'Login Fail :' + DRPanel_msg.Caption, 'I');

            Exit;
         end;
      end;

   end;
//==============================================================================


   if gvVersionUpgrade then
   begin

  // Version Check Start ======================================================
     DRPanel_msg.Caption := ' Program Version Synchronizing...';
     DRPanel_msg.Refresh;

     with ADOConnection_VersionSync do
     begin
       if Connected then Connected := False;
       ConnectionString := 'Provider=SQLOLEDB.1;Persist Security Info=True;'
                         + 'User ID=' + gvDBUserID + ';'
                         + 'Password=' + gvDBPassWd + ';'
                         + 'Data Source=' + gvDBServerName + ';';
       DefaultDatabase := gvDefaultDB;
       Try
          Connected := True;
       Except on E: Exception do
          begin
             gf_ShowErrDlgMessage(0, 0, 'DB ���� ����. Version Sync. ' + gcMsgLineInterval + E.Message, 0);
             gf_Log('[E]DB Connection Error.Version Sync.' + E.Message);
             ModalResult := idAbort;
             Exit;
          end;
       End;
     end;

     try
       sMsg := gf_VersionSync(ADOQuery_VersionSync, 'EXE', DRPanel_Msg) ;
     Except
         on E : Exception do
         begin
           gf_Log('gf_VersionSync EXE Except : ' + E.MEssage); //��������.
         end;
     End;

     if sMsg > '' then
     begin
       DRPanel_msg.Caption := sMsg;
       ModalResult := idAbort; //���� Ȥ�� �������� exe Upgrade. Restart
       //[Y.S.M] 2013.07.23
       // Dataroad or UATȯ�濡�� 2tier ���� History ��� =============================
       if sMsg =  'Program Upgraded! ' then
         History2TierWriteIni;

       //==============================================================================
       // �α��ν��� gcLogINF_fail
       //==============================================================================
       sCurTime := FormatDateTime('hhmmssmm', now);
       gf_LogLstWrite(ADOQuery_VersionSync, gvDeptCode, gcLogINF_fail, DREdit_OprUsrNo.Text,
                        sCurDate, sCurTime, sCurTime, gvLocalIP, '', '', 'Login Fail :' + DRPanel_msg.Caption, 'I');
       Exit;
     end;

     with ADOQuery_VersionSync do
     begin
       Close;
       SQL.Clear;
       SQL.Add(' select OPT_VALUE '
             + ' from   SUSYOPT_TBL '
             + ' where  OPT_CODE = ''E02'' ');
       gf_ADOQueryOpen(ADOQuery_VersionSync);

       if RecordCount > 0 then
         sMsg := Trim(FieldByName('OPT_VALUE').asString)
       else
         sMsg := 'N'; //default N
     end;

     if sMsg = 'Y' then
     begin
       sMsg := '';
       try
        sMsg := gf_VersionSync(ADOQuery_VersionSync, 'DLL', DRPanel_Msg) ;
       Except
           on E : Exception do
           begin
             gf_Log('gf_VersionSync DLL Except : ' + E.MEssage); //��������.
           end;
       End;

//       if sMsg > '' then
//       begin
//         DRPanel_msg.Caption := sMsg;
//         ModalResult := idAbort; //���� Ȥ�� �������� exe Upgrade. Restart
//         Exit;
//       end;
     end;
     gf_Log('After Version Synchronizing');

   // Version Check End  ======================================================
  end;

//==============================================================================
// �������α��� ��¥ ������Ʈ
//==============================================================================
  with ADOQuery_VersionSync do
  begin
     Close;
     SQL.Clear;
     SQL.Add('UPDATE SUUSER_TBL SET LASTLOG_DATE = ''' + sCurDate + ''' '
           + '  WHERE USER_ID = ''' + Trim(DREdit_OprUsrNo.Text) + ''' ');

     try
        gf_ADOExecSQL(ADOQuery_VersionSync);
     except
     on E : Exception do
     begin
        gf_Log('SUUSER_TBL LASTLOG_DATE update Except : ' + E.MEssage);
     end;
     end;
  end;

  // Dataroad or UATȯ�濡�� 2tier ���� History ��� ============================================
  History2TierWriteIni;

//==============================================================================
// �α��α�� gcLogINF_inout
//==============================================================================
  sCurTime := FormatDateTime('hhmmssmm', now);
  gf_LogLstWrite(ADOQuery_VersionSync, gvDeptCode, gcLogINF_inout, DREdit_OprUsrNo.Text,
                 sCurDate, sCurTime, '', gvLocalIP, '', '', 'LogIn', 'I');

  ADOConnection_VersionSync.Connected := false;

  // �ڵ� ������ ó�� ���� 
  bRestartWait := False;

  ModalResult := idOK;
end;

procedure TForm_Login.DREdit_OprUsrNoChange(Sender: TObject);
begin
//***   if Length(DREdit_OprUsrNo.Text) = DREdit_OprUsrNo.MaxLength then
//***      DREdit_Pswrd.SetFocus;
end;

procedure TForm_Login.DREdit_OprUsrNoKeyPress(Sender: TObject;
  var Key: Char);
begin
   if Key = #13 then
   begin
      DREdit_Pswrd.SetFocus;
      Key := #0;
   end;
end;

procedure TForm_Login.DREdit_PswrdKeyPress(Sender: TObject; var Key: Char);
var i : integer;
begin
   if Key = #13 then
   begin
     DRColorBtn_OkClick(nil);
     Key := #0;
   end
   else
   begin
     i := integer(Key);
     
     if  (i < 33) or (i > 126) then
     begin
       if i <> 8 then Key := #0; //backspace oK
     end;

    { if  (i < 48) //����, ������ ����.
     or ((i > 57) and (i <65))
     or ((i > 90) and (i <97))
     or  (i > 122) then
     begin
       if i <> 8 then Key := #0; //backspace oK
     end; }
   end;
end;

procedure TForm_Login.DRColorBtn_OkClick(Sender: TObject);
var
   iLen, I, iPos : Integer;
   EnvSetupInfo : TIniFile;
   CurServer : string;
   Reg: TRegistry;
   OprShotPass : string;
   MyMsg   : TMessage;
begin

   if Trim(DREdit_OprUsrNo.Text) = '' then
   begin
     DREdit_OprUsrNo.SetFocus;
     exit;
   end;

   if Trim(DREdit_Pswrd.Text) = '' then
   begin
     DREdit_Pswrd.SetFocus;
     exit;
   end;

   Screen.Cursor := crHourGlass;
   DREdit_OprUsrNo.Enabled := False;
   DREdit_Pswrd.Enabled := False;
   DRColorBtn_Ok.Enabled := False;
   DRColorBtn_Cancel.Enabled := False;
   DRColorBtn_Setup.Enabled := False;

   DRPanel_msg.Color   := MsgColor;
   DRPanel_msg.Caption := ' ���� ���Դϴ�. ��ø� ��ٷ� �ֽʽÿ�...';

   //=== ������� �о����
   EnvSetupInfo := TIniFile.Create(gvDirCfg + gcMainIniFileName);

   CurServer := EnvSetupInfo.ReadString('Communication Setup', 'CurrentServer', 'Primary');

   if EnvSetupInfo.ReadString('Communication Setup', 'VersionUpgrade', 'Y') = 'N' then
     gvVersionUpgrade := false
   else
     gvVersionUpgrade := true;

  if (UpperCase(ExtractFileName( Application.ExeName)) = 'SETTLENETTF_TEST.EXE')
  or (UpperCase(ExtractFileName( Application.ExeName)) = 'SETTLENETTF-TEST.EXE') then
  begin //�׽�Ʈ ȯ��
     gvVersionUpgrade := false;
  end;

{
   gvUATSvrYN := 'N';
   if UpperCase(Application.Title) = UpperCase('SettleNetB-UAT') then //@#@
   begin
      gvUserSvrIP := EnvSetupInfo.ReadString('Communication Setup', 'UATServer', '');
      gvUATSvrYN := 'Y';
   end
   else
}
   if CurServer = 'Primary' then
      gvUserSvrIP := EnvSetupInfo.ReadString('Communication Setup', 'PrimaryServer', '')
   else
      gvUserSvrIP   := EnvSetupInfo.ReadString('Communication Setup', 'BackupServer', '');
   gvUserSvrPort    := EnvSetupInfo.ReadInteger('Communication Setup', 'Port', 0);
   gvUserSvrTimeOut := EnvSetupInfo.ReadInteger('Communication Setup', 'TimeOut', 20);

   //=== Real Monotioring Logging ���� 2004.01.15 �߰�
   // Real Data Monitoring�� Log��� ��뿩��
   gvRealLogYN := EnvSetupInfo.ReadString('User Information', 'RealLogYN', 'N');
   // Real Data Monitoring PopUp ���� �����������. PopUp�� �����ѹ��� ���� ����.
   gvRealLogPopupStopYN := 'N';

   //Net Resource info (Client INI�� Setting)
   //Guest������ Open���� ���� Site�� Network Drive��Ҵ� ���� ���ӵ�.
   //MDAC 2.6�̻��� ������.
   gvNRW := EnvSetupInfo.ReadString('Communication Setup', 'NRW', '');
   gvNRWID := EnvSetupInfo.ReadString('Communication Setup', 'NRWID', '');
   gvNRWPW := EnvSetupInfo.ReadString('Communication Setup', 'NRWPW', '');

   //Crystal Report���� OS�� Default Printer�� ����� �� ���� 2007.05.23
   //Crystal 10 Component Bug ����. Default Printer ���� ���������� ���� �־
   //�����Ͱ� Fine Printer�� Ư���� ���� ���� �̸�����/�μ�� ���η� ��Ÿ���� ���� �ذ�����.
   gvDefaultPrinterUseYN := EnvSetupInfo.ReadString('Communication Setup', 'DefaultPrinterUseYN', 'N');

   if gvNRW > '' then
   begin
     for i := 1 to 17 do
     begin
       if NRWConnect(gvNRW,i) then
       begin
          Break;
       end;
     end; //for ..i
     if gvNetworkDrive > '' then
     begin
       Sleep(1000);
       WNetCancelConnection2(PChar(gvNetworkDrive), CONNECT_UPDATE_PROFILE, true);
     end
     else
     begin
       gf_ShowErrDlgMessage(0, 0, 'ShareSettleNet ���� ���� - Network Drive�� ���� �� �����ϴ�. '
           + #13#10+ #13#10+'������ �ȵ� ��� Dataroad�� �����ϼ���.', 0);
     end;
   end;

//   EnvSetupInfo.Free;

   if (Trim(CurServer) = '') or (gvUserSvrPort = 0) then
   begin
      DRPanel_msg.Caption := ' ���� ���� - ȯ�� ���������� Ȯ���� �ֽʽÿ�';
      gf_ShowErrDlgMessage(0, 0, '���� ���� - ȯ�� ���������� Ȯ���� �ֽʽÿ�', 0);
      Screen.Cursor := crDefault;
      DREdit_OprUsrNo.Enabled   := True;
      DREdit_Pswrd.Enabled      := True;
      DRColorBtn_Ok.Enabled     := True;
      DRColorBtn_Cancel.Enabled := True;
      DRColorBtn_Setup.Enabled  := True;
      DRColorBtn_SetupClick(DRColorBtn_Setup);
      Exit;
   end;


   //=== ����� ���� ä��
   gvOprUsrNo := DREdit_OprUsrNo.Text;
   iLen := Length(gvOprUsrNo);
   for I:=1 to 8-iLen do
      gvOprUsrNo := gvOprUsrNo + ' ';

   // �������� Password Hash Cipher ��뿩��
   gvUserEnrpYN := EnvSetupInfo.ReadString('User Information', 'Encryption', 'N');

   EnvSetupInfo.Free;

   gfEncryption(DREdit_Pswrd.Text, gvUserEnrpYN, OprShotPass);
   gvOprPassWd := OprShotPass;
   iLen := Length(gvOprPassWd);
   for I:=1 to 8-iLen do
      gvOprPassWd := gvOprPasswd + ' ';

// ���� ȯ�溯�� ��������
  gvUserProfile := GetDosEnv('USERPROFILE');
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Environment', True)
    then gvCurrentUserTempDir := Reg.ReadString('TMP');
    iPos := pos ('%USERPROFILE%', gvCurrentUserTempDir);
    if iPos > 0 then
    begin
      gvCurrentUserTempDir := copy(gvCurrentUserTempDir, length('%USERPROFILE%') +1, length(gvCurrentUserTempDir) - iPos);
      gvCurrentUserTempDir := gvUserProfile + gvCurrentUserTempDir ;
    end;
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
  if gvRealLogYN = 'Y' then gf_Log(gvCurrentUserTempDir);

  if gv2TierLoginYN <> 'Y' then
    fnTcpIpInit
  else
  begin //�����ͷε�ȯ�濡�� User Server (����)�� �����ϰ� 2-tier�� �ٴ� ���
    // DataBase Computer Name
    gvDBServerName := Trim(DREdit_DBServer.Text);
    // DataBase Name
    gvDBName := Trim(DREdit_DBName.Text);
    // DataBase User ID
    gvDBUserID := Trim(DREdit_DBUserId.Text);
    // DataBase PassWd
    gvDBPassWd := Trim(DREdit_DBPassword.Text);
    // Default DataBaseName
    gvDefaultDB := Trim(DREdit_DBName.Text);

    MyMsg.WParam := gcTCPIP_CLIENT_LOGSND_WPARAM_LOGIN_SUCCESS;
    SendMessage(gvLoginFormHandle,WM_USER_TCPIP_CLIENT_LOGSND,MyMsg.WParam,MyMsg.LParam);
  end;
end;

procedure TForm_Login.DRColorBtn_CancelClick(Sender: TObject);
begin
   ModalResult := IdAbort;
end;

procedure TForm_Login.FormCreate(Sender: TObject);
function ExeVersion(sExeFullPathFileName: string): string;
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
        Result := Format('%d.%d.%d.%d', [HiWord(dwFileVersionMS),
          LoWord(dwFileVersionMS),
            HiWord(dwFileVersionLS),
            LoWord(dwFileVersionLS)]);
      end;
    finally
      FreeMem(Pt);
    end;
  end;
end;
function GetProgramColor(sDB : string) : TColor;
begin
   if Copy(sDB,1,2) = 'S5' then
     Result := 16751515
   else if Copy(sDB,1,2) = 'S7' then
     Result := 11757311
   else if Copy(sDB,1,2) = 'TF' then
     Result := 11596692
   else if Copy(sDB,1,2) = 'NM' then
     Result := 8240895
   else
     Result := clgray;//16751515;
end;
var
   EnvSetupInfo : TIniFile;
   sOprUserNo, sSvrName : string;

   i,j, iHisCount, iPos : integer;
   sList : TStringList;
   CurColor : TColor;
begin
   gvLoginFormHandle := 0;
   // Version ���� Display
   DRLabel_Version.Caption    := 'Ver. ' +
                                 ExeVersion(Application.ExeName);
   //=== Ini File���� ����� ���� �о����
   gvDirCfg     := gf_GetAppRootPath + 'Cfg\';       // Cfg Directory
   EnvSetupInfo := TIniFile.Create(gvDirCfg + gcMainIniFileName);
   sOprUserNo := EnvSetupInfo.ReadString('User Information', 'UserID', '');
   if Trim(sOprUserNo) <> '' then
      DREdit_OprUsrNo.Text := sOprUserNo;


   //DataRoad or UATȯ�濡�� 2-Tier �α� ȯ�� ����� Start ==================================
   FormShowed := false;
   SortFlag0 := True;
   SortFlag1 := True;

   // LocalHost IP ��������
   gf_GetLocalIP(sSvrName, gvLocalIP);

   if Copy(gvLocalIP,1,11) = '100.100.100' then
   begin
     gv2TierLoginYN := 'Y';
     DRCheckBox_Eye.Visible := True; //���� ���ӿ��δ� �����ͷε常 ������~~
     DREdit_Pswrd.Text := '123456';
   end
   else
   begin
     //�����̸��� UAT�ϰ�� 2tier����, ����! �������� UAT�� UAT ������ ����������.
     if Pos('UAT',UpperCase(ExtractFileName(Application.ExeName))) > 0 then
       gv2TierLoginYN := 'Y'
     else
       gv2TierLoginYN := 'N';
     DRCheckBox_Eye.Visible := False;
   end;

   if gv2TierLoginYN = 'Y' then
   begin
     BorderStyle := bsSingle;

     DREdit_DBServer.Text := EnvSetupInfo.ReadString('History', 'LastIP', '100.100.100.22');
     DREdit_DBName.Text := EnvSetupInfo.ReadString('History', 'LastDB', 'S7_STLNET_BRK');
     DREdit_DBUserId.Text := 'settlenet';
     DREdit_DBPassword.Text := 'settlenet,.';

     sList := TStringList.Create;

     iHisCount := EnvSetupInfo.ReadInteger('History', 'HisCount', 0);

     DRStrGrid_His.RowCount := 2;
     DRStrGrid_His.Rows[1].Clear;

     if iHisCount > 0 then
     begin
       for i := 1 to iHisCount do
       begin
         sList.Add ( Trim(EnvSetupInfo.ReadString('History', 'IP' + IntToStr(i), ''))
                    + '$$'
                    + Trim(EnvSetupInfo.ReadString('History', 'DB' + IntToStr(i), '')));
       end;

       sList.Sort;
       j := 0;
       for i := 0 to iHisCount -1 do
       begin
         iPos := Pos('$$',sList.Strings[i]);
         if iPos > 1 then
           inc(j)
         else
           continue;
         DRStrGrid_His.Cells[0, j] := copy(sList.Strings[i],1,iPos-1);
         DRStrGrid_His.Cells[1, j] := Copy(sList.Strings[i],iPos+2,20); //20 is ����

         CurColor := GetProgramColor(DRStrGrid_His.Cells[1, j]);
         DRStrGrid_His.ColorRow[j] := CurColor;
         DRStrGrid_His.SelectedColorRow[j] := CurColor;
         DRStrGrid_His.SelectedFontColorRow[j] := clWhite;//gcGridSelectColor;

       end;

       DRStrGrid_His.RowCount := j + 1; //iHisCount + 1;

     end;

     sList.Free;

     for j := 1 to  DRStrGrid_His.RowCount - 1 do
     begin
       if  (DREdit_DBServer.Text = DRStrGrid_His.Cells[0, j])
       and (DREdit_DBName.Text = DRStrGrid_His.Cells[1, j]) then
       begin
         gf_SelectStrGridRow(DRStrGrid_His,j);
         Break;
       end;
     end;

   end
   else
   begin
     BorderStyle := bsNone;
     Width := DRPanel1.Width + 0;
     Height := DRPanel1.Height + 0;
   end;
   //DataRoad or UATȯ�濡�� 2-Tier �α� ȯ�� ����� End   ==================================

   EnvSetupInfo.Free;
end;

procedure TForm_Login.WMNCHitTest(var Msg: TWMNCHitTest);
begin
   Color := random(999);
   if Bool(GetAsyncKeyState(VK_LBUTTON)) then
      Msg.Result := HTCAPTION
   else
      Msg.Result := HTCLIENT;
end;

procedure TForm_Login.DRPanel1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
   Msg : TMessage;
   SP, CP : TPoint;
begin
   CP.x := X;
   Cp.y := Y;
   SP := ClientToScreen(CP);
   Msg.LParamLo := SP.X;
   Msg.LParamHi := SP.Y;
   SendMessage(Self.Handle, WM_NCHITTEST, Msg.WParam, Msg.LParam);
end;

procedure TForm_Login.DRColorBtn_SetupClick(Sender: TObject);
begin
   Application.CreateForm(TForm_EnvSetup, Form_EnvSetup);
   Form_EnvSetup.ShowModal;
   DREdit_OprUsrNo.SetFocus;
end;

procedure TForm_Login.FormActivate(Sender: TObject);
begin
   Try
      if gvLoginFormHandle = 0 then
         gvLoginFormHandle := Handle;
   Except
      On E: Exception do
      begin
         ShowMessage('<Sorry> ' + E.Message);
         ModalResult := idAbort;
         Exit;
      end;
   End;
end;


procedure TForm_Login.DREdit_PswrdKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (Copy(DREdit_OprUsrNo.Text,1,4) = 'data')
   and (DREdit_Pswrd.Text = '.')
   and (Key in [VK_RETURN] )
   then
   begin
      DREdit_Pswrd.Text := '123456';
      DRColorBtn_OkClick(DRColorBtn_Ok);
   end;
end;

function TForm_Login.NRWConnect(NRWName:string;Num:integer) : boolean;
var
  NRW: TNetResource;
begin
  Result := false;
  gvNetworkDrive := '';
  with NRW do
  begin
    dwType := RESOURCETYPE_ANY;
    Case Num of
      1 : lpLocalName := 'H:';
      2 : lpLocalName := 'I:';
      3 : lpLocalName := 'J:';
      4 : lpLocalName := 'K:';
      5 : lpLocalName := 'L:';
      6 : lpLocalName := 'M:';
      7 : lpLocalName := 'N:';
      8 : lpLocalName := 'O:';
      9 : lpLocalName := 'P:';
      10 : lpLocalName := 'Q:';
      11 : lpLocalName := 'R:';
      12 : lpLocalName := 'S:';
      13 : lpLocalName := 'T:';
      14 : lpLocalName := 'U:';
      15 : lpLocalName := 'V:';
      16 : lpLocalName := 'W:';
      17 : lpLocalName := 'Y:';
    end;

    gvNetworkDrive := lpLocalName;
    lpRemoteName := PChar(NRWName);

    lpProvider := '';
  end;

//  if WNetAddConnection2(NRW,'dataroad,.','Administrator',CONNECT_UPDATE_PROFILE) = NO_ERROR then
  if WNetAddConnection2(NRW, pChar(gvNRWPW), pChar(gvNRWID), CONNECT_UPDATE_PROFILE) = NO_ERROR then
    Result := true
  else
  begin
    gvNetworkDrive := '';
    Result := false;
  end;
end;

procedure TForm_Login.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) then
  begin
    if Key = VK_F1 then
    begin
      if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
        DREdit_OprUsrNo.Text := 'data1'
      else
        DREdit_OprUsrNo.Text := 'data01';
      DREdit_Pswrd.Text := '123456';
      DRColorBtn_OkClick(nil);
    end
    else if Key = VK_F2 then
    begin
      if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
        DREdit_OprUsrNo.Text := 'data2'
      else
        DREdit_OprUsrNo.Text := 'data02';
      DREdit_Pswrd.Text := '123456';
      DRColorBtn_OkClick(nil);
    end
    else if Key = VK_F3 then
    begin
      if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
        DREdit_OprUsrNo.Text := 'data3'
      else
        DREdit_OprUsrNo.Text := 'data03';
      DREdit_Pswrd.Text := '123456';
      DRColorBtn_OkClick(nil);
    end
    else if Key = VK_F4 then
    begin
      if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
        DREdit_OprUsrNo.Text := 'data4'
      else
        DREdit_OprUsrNo.Text := 'data04';
      DREdit_Pswrd.Text := '123456';
      DRColorBtn_OkClick(nil);
    end
    else if Key = VK_F5 then
    begin
      if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
        DREdit_OprUsrNo.Text := 'data5'
      else
        DREdit_OprUsrNo.Text := 'data05';
      DREdit_Pswrd.Text := '123456';
      DRColorBtn_OkClick(nil);
    end
    else if Key = VK_F6 then
    begin
      if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
        DREdit_OprUsrNo.Text := 'data6'
      else
        DREdit_OprUsrNo.Text := 'data06';
      DREdit_Pswrd.Text := '123456';
      DRColorBtn_OkClick(nil);
    end
    else if Key = VK_F7 then
    begin
      if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
        DREdit_OprUsrNo.Text := 'data7'
      else
        DREdit_OprUsrNo.Text := 'data07';
      DREdit_Pswrd.Text := '123456';
      DRColorBtn_OkClick(nil);
    end
    else if Key = VK_F8 then
    begin
      if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
        DREdit_OprUsrNo.Text := 'data8'
      else
        DREdit_OprUsrNo.Text := 'data08';
      DREdit_Pswrd.Text := '123456';
      DRColorBtn_OkClick(nil);
    end
    else if Key = VK_F9 then
    begin
      if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
        DREdit_OprUsrNo.Text := 'data9'
      else
        DREdit_OprUsrNo.Text := 'data09';
      DREdit_Pswrd.Text := '123456';
      DRColorBtn_OkClick(nil);
    end
    else if Key = VK_F10 then
    begin
      if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
        DREdit_OprUsrNo.Text := 'data010'
      else
        DREdit_OprUsrNo.Text := 'data10';
      DREdit_Pswrd.Text := '123456';
      DRColorBtn_OkClick(nil);
    end
    else if Key = VK_F11 then
    begin
      if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
        DREdit_OprUsrNo.Text := 'data011'
      else
        DREdit_OprUsrNo.Text := 'data11';
      DREdit_Pswrd.Text := '123456';
      DRColorBtn_OkClick(nil);
    end
    else if Key = VK_F12 then
    begin
      if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
        DREdit_OprUsrNo.Text := 'data012'
      else
        DREdit_OprUsrNo.Text := 'data12';
      DREdit_Pswrd.Text := '123456';
      DRColorBtn_OkClick(nil);
    end;
  end;
end;


procedure TForm_Login.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
   iCapsLock : Integer;
begin

  iCapsLock  := GetKeyState(VK_CAPITAL);
  isCapsLock := Boolean(iCapsLock);

  if Assigned(ActiveControl) then
  begin
     if Trim((ActiveControl).Name) = 'DREdit_Pswrd' then
     begin
      DRImage_CapsLock.BringToFront;
      DRImage_CapsLock.Visible := isCapsLock;
      DRPanel_msg.Visible      := not isCapsLock;
     end else
     begin
      DRImage_CapsLock.Visible := False;
      DRPanel_msg.Visible      := True;
     end;
  end;
end;


procedure TForm_Login.DREdit_PswrdExit(Sender: TObject);
begin
   DRImage_CapsLock.Visible := False;
   DRPanel_msg.Visible      := True;
end;

procedure TForm_Login.DREdit_PswrdEnter(Sender: TObject);
begin
   DRImage_CapsLock.BringToFront;
   DRImage_CapsLock.Visible := isCapsLock;
   DRPanel_msg.Visible      := not isCapsLock;
end;

procedure TForm_Login.DRStrGrid_HisSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if Not FormShowed then
  begin
    CanSelect := false;
    Exit;
  end;

  if ARow <= 0 then Exit;
  with DRStrGrid_His do
  begin
    if Cells[ACol,ARow] = '' then Exit;
    DREdit_DBServer.Text := Cells[0,ARow];
    DREdit_DBName.Text := Cells[1,ARow];
  end;
end;

procedure TForm_Login.FormShow(Sender: TObject);
begin
  FormShowed := True;
  if DREdit_OprUsrNo.Text > '' then
    ActiveControl := DREdit_Pswrd
  else
    ActiveControl := DREdit_OprUsrNo;

end;

procedure TForm_Login.DRStrGrid_HisFiexedRowClick(Sender: TObject;
  ACol: Integer);
begin
  if ACol = 0 then
  begin
    SortFlag0 := Not SortFlag0;
    DRStrGrid_His.SortColumn(0,1,1,SortFlag0);
  end
  else
  begin
    SortFlag1 := Not SortFlag1;
    DRStrGrid_His.SortColumn(1,0,0,SortFlag1);
  end;
end;

procedure TForm_Login.DRBitBtn_DelHisClick(Sender: TObject);
var  EnvSetupInfo : TIniFile;
     i, iHisCount : integer;
begin
  DRStrGrid_His.RemoveRow(DRStrGrid_His.Row);
  if DRStrGrid_His.RowCount = 1 then
  begin
    DRStrGrid_His.RowCount := 2;
    DRStrGrid_His.FixedRows := 1;
  end;

  EnvSetupInfo := TIniFile.Create(gvDirCfg + gcMainIniFileName);

  iHisCount := DRStrGrid_His.RowCount -1;

  //Config ����---------------------
  with DRStrGrid_His do
  begin

    if  (RowCount = 2)
    and (Cells[0,1] = '') then
      iHisCount := 0;

    EnvSetupInfo.WriteString('History', 'HisCount', IntToStr(iHisCount));

    if iHisCount > 0 then
    begin
      for i := 1 to iHisCount do
      begin
        EnvSetupInfo.WriteString('History', 'IP' + IntToStr(i), Cells[0,i]);
        EnvSetupInfo.WriteString('History', 'DB' + IntToStr(i), Cells[1,i]);
      end;
    end;
    EnvSetupInfo.Free;
  end;

end;

procedure TForm_Login.DRCheckBox_EyeClick(Sender: TObject);
begin
  if DRCheckBox_Eye.Checked then
    gv2TierLoginYN := 'N'
  else
    gv2TierLoginYN := 'Y';
end;

//DataRoad���� R��ư , L��ư���� User �ٲٱ�
procedure TForm_Login.DRPanel1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  s : string;
  i : integer;
begin
  if Copy(gvLocalIP,1,11) <> '100.100.100' then Exit;

  s := copy(DREdit_OprUsrNo.Text,1,5);
  if uppercase(s) <> 'DATA0' then Exit;

  i := StrToInt(copy(DREdit_OprUsrNo.Text,6,1));

  if Button = mbRight then
  begin
    if i < 9 then i := i + 1;
  end
  else
  if Button = mbLeft then
  begin
    if i > 1 then i := i - 1;
  end;

  DREdit_OprUsrNo.Text := s + IntToStr(i);
end;

procedure TForm_Login.DRStrGrid_HisMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   ScreenP : TPoint;
   ACol, ARow : Integer;
   SqlServer, DbName : String;
   SelColIdx, SelRowIdx, I : Integer;

   MenuItem : TMenuItem;

begin
  inherited;
   SqlServer := '';
   DbName := '';

   DRStrGrid_His.MouseToCell(X, Y, ACol, ARow);

   SelColIdx := ACol;
   SelRowIdx := ARow;

   if Button = mbRight then // ���콺 ������ Ŭ�� �ϸ�
   begin
      gf_SelectStrGridRow((Sender as TDRStringGrid), ARow);
      GetCursorPos(ScreenP);

      if ARow <= 0 then Exit;

      with DRStrGrid_His do
      begin
        if Cells[ACol,ARow] = '' then Exit;

        SqlServer :=  Cells[0,ARow]; // SQL Server
        DbName := Cells[1,ARow]; // Database Name

        DeptInfo(SqlServer,DbName);

        PopupMenu1.Items.Clear;

        if DeptInfoList.Count <> 0 then
        begin
           for I := 0 to DeptInfoList.Count -1 do
           begin
              MenuItem := TMenuItem.Create(nil);
              MenuItem.Name    := 'popupitem' + IntToStr(I);
              MenuItem.Caption := DeptInfoList.Strings[I];
              MenuItem.OnClick := PopupClick;
              PopupMenu1.Items.Insert(I,MenuItem);
           end;
           PopupMenu1.Popup(ScreenP.X, ScreenP.Y); // �˾� �޴� ���
        end;
      end; // with DRStrGrid_His do
   end; // if Button = mbRight then
end;

// PopupItem�� �μ� ���� ǥ��
function TForm_Login.DeptInfo(pSqlServer, pDbName : string): boolean;
var
   i :Integer;
begin
   Result := False;

   DeptInfoList := TStringList.Create;

   with ADOConnection_DeptInfo do
   begin
    if Connected then Connected := False;
    ConnectionString := 'Provider=SQLOLEDB.1;Persist Security Info=True;'
                      + 'User ID=' + Trim(DREdit_DBUserId.Text) + ';' // SQL �α��� ID
                      + 'Password=' + Trim(DREdit_DBPassword.Text) + ';' // SQL �α��� �н�����
                      + 'Data Source=' + pSqlServer + ';'; // IP

    DefaultDatabase := gvDefaultDB;
      Try
         Connected := True;
      Except on E: Exception do
         begin
            gf_ShowErrDlgMessage(0, 0, 'DB ���� ����. Version Sync. ' + gcMsgLineInterval + E.Message, 0);
            gf_Log('[E]DB Connection Error.Version Sync.' + E.Message);
            ModalResult := idAbort;
            Exit;
         end;
      End;

      with ADOQuery_DeptInfo do
      begin
         Close;
         sql.clear;
         sql.add(
                  ' SELECT DEPT_CODE, USER_DEPT_NAME_KOR  '+
                  ' FROM   ' + pDbName + ' .. SUDEPCD_TBL '+
                  ' ORDER BY DEPT_CODE                     ');

         Try
            gf_ADOQueryOpen(ADOQuery_DeptInfo);
         Except
            on E : Exception do
            begin
               Exit;
            end;
         end;

         if RecordCount = 0 then
            Exit;

         First;
         while not EOF do
         begin
            DeptInfoList.Add(Trim(FieldByName('DEPT_CODE').asString) + ' '
                              + Trim(FieldByName('USER_DEPT_NAME_KOR').asString));

            Next;
         end; // while not EOF do
      end; // with ADOQuery_DeptInfo do
   end; // with ADOConnection_DeptInfo do

   Result := true;
end;

procedure TForm_Login.PopupClick(Sender: TObject);
var
   DeptCode : string;
begin
   DeptCode := Copy(TMenuItem(Sender).Caption,1,2);

   PopupItemClick(DeptCode);
end;

// PopupItem Ŭ���� ����
procedure TForm_Login.PopupItemClick(pDeptCode : String);
begin
   DRCheckBox_Eye.Checked := false;

   if pDeptCode = '01' then
   begin
     if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
       DREdit_OprUsrNo.Text := 'data1'
     else
       DREdit_OprUsrNo.Text := 'data01';
     DREdit_Pswrd.Text := '123456';
     DRColorBtn_OkClick(nil);
   end
   else if pDeptCode = '02' then
   begin
     if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
       DREdit_OprUsrNo.Text := 'data2'
     else
       DREdit_OprUsrNo.Text := 'data02';
     DREdit_Pswrd.Text := '123456';
     DRColorBtn_OkClick(nil);
   end
   else if pDeptCode = '03' then
   begin
     if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
       DREdit_OprUsrNo.Text := 'data3'
     else
       DREdit_OprUsrNo.Text := 'data03';
     DREdit_Pswrd.Text := '123456';
     DRColorBtn_OkClick(nil);
   end
   else if pDeptCode = '04' then
   begin
     if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
       DREdit_OprUsrNo.Text := 'data4'
     else
       DREdit_OprUsrNo.Text := 'data04';
     DREdit_Pswrd.Text := '123456';
     DRColorBtn_OkClick(nil);
   end
   else if pDeptCode = '05' then
   begin
     if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
       DREdit_OprUsrNo.Text := 'data5'
     else
       DREdit_OprUsrNo.Text := 'data05';
     DREdit_Pswrd.Text := '123456';
     DRColorBtn_OkClick(nil);
   end
   else if pDeptCode = '06' then
   begin
     if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
       DREdit_OprUsrNo.Text := 'data6'
     else
       DREdit_OprUsrNo.Text := 'data06';
     DREdit_Pswrd.Text := '123456';
     DRColorBtn_OkClick(nil);
   end
   else if pDeptCode = '07' then
   begin
     if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
       DREdit_OprUsrNo.Text := 'data7'
     else
       DREdit_OprUsrNo.Text := 'data07';
     DREdit_Pswrd.Text := '123456';
     DRColorBtn_OkClick(nil);
   end
   else if pDeptCode = '08' then
   begin
     if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
       DREdit_OprUsrNo.Text := 'data8'
     else
       DREdit_OprUsrNo.Text := 'data08';
     DREdit_Pswrd.Text := '123456';
     DRColorBtn_OkClick(nil);
   end
   else if pDeptCode = '09' then
   begin
     if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
       DREdit_OprUsrNo.Text := 'data9'
     else
       DREdit_OprUsrNo.Text := 'data09';
     DREdit_Pswrd.Text := '123456';
     DRColorBtn_OkClick(nil);
   end
   else if pDeptCode = '10' then
   begin
     if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
       DREdit_OprUsrNo.Text := 'data010'
     else
       DREdit_OprUsrNo.Text := 'data10';
     DREdit_Pswrd.Text := '123456';
     DRColorBtn_OkClick(nil);
   end
   else if pDeptCode = '11' then
   begin
     if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
       DREdit_OprUsrNo.Text := 'data011'
     else
       DREdit_OprUsrNo.Text := 'data11';
     DREdit_Pswrd.Text := '123456';
     DRColorBtn_OkClick(nil);
   end
   else if pDeptCode = '12' then
   begin
     if uppercase(Trim(DRPanel_msg.Caption)) = 'ALREADY LOGIN' then
       DREdit_OprUsrNo.Text := 'data012'
     else
       DREdit_OprUsrNo.Text := 'data12';
     DREdit_Pswrd.Text := '123456';
     DRColorBtn_OkClick(nil);
   end;
end;

end.
