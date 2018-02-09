unit SCFH8201;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SCCChildForm_Import, ExtCtrls, DRDialogs, DB, ADODB, DRStandard,
  StdCtrls, ComCtrls, Buttons, DRAdditional, DRSpecial, DRWin32, Grids,
  DRStringgrid, Mask, StrUtils, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdFTP, IdIntercept, IdLogBase, IdLogEvent,
  IdFTPCommon;

type
  TForm_SCFH8201 = class(TForm_SCF_Import)
    DRFramePanel1: TDRFramePanel;
    DRFramePanel2: TDRFramePanel;
    DRStrGrid_ImportInfo: TDRStringGrid;
    DRPanel4: TDRPanel;
    DRPanel2: TDRPanel;
    DRGroupBox1: TDRGroupBox;
    DRRadioButton_Acc_All: TDRRadioButton;
    DRRadioButton_Acc_CreDate: TDRRadioButton;
    DRRadioButton_Acc_ChgDate: TDRRadioButton;
    DRRadioButton_Acc_AccNo: TDRRadioButton;
    DRMaskEdit_Acc_CreDate: TDRMaskEdit;
    DRLabel2: TDRLabel;
    DRMaskEdit_Acc_ChgDate: TDRMaskEdit;
    DREdit_Acc_AccNo: TDREdit;
    DRButton_Acc_Import: TDRButton;
    DRGroupBox2: TDRGroupBox;
    DRRadioButton_Rpt_New: TDRRadioButton;
    DRRadioButton_Rpt_AccNo: TDRRadioButton;
    DREdit_Rpt_AccNo: TDREdit;
    DRButton_Rpt_Import: TDRButton;
    DRSpeedBtn_Unlock: TDRSpeedButton;
    DRButton2: TDRButton;
    DRFramePanel3: TDRFramePanel;
    DRPanel1: TDRPanel;
    DRLabel1: TDRLabel;
    DRMaskEdit_Test_Date: TDRMaskEdit;
    DRButton_Test_RptView: TDRButton;
    DRLabel3: TDRLabel;
    IdFTP1: TIdFTP;
    IdLogEvent1: TIdLogEvent;
    DRSpeedBtn_FileOpen: TDRSpeedButton;
    procedure DRButton_Acc_ImportClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DRButton2Click(Sender: TObject);
    procedure DRSpeedBtn_UnlockClick(Sender: TObject);
    procedure DRSpeedBtn_FileOpenClick(Sender: TObject);
    procedure DRButton_Rpt_ImportClick(Sender: TObject);
    procedure DRRadioButton_Acc_AllClick(Sender: TObject);
    procedure DRRadioButton_Acc_CreDateClick(Sender: TObject);
    procedure DRRadioButton_Acc_ChgDateClick(Sender: TObject);
    procedure DRRadioButton_Acc_AccNoClick(Sender: TObject);
    procedure DRRadioButton_Rpt_NewClick(Sender: TObject);
    procedure DRMaskEdit_Acc_CreDateChange(Sender: TObject);
    procedure DRMaskEdit_Acc_ChgDateChange(Sender: TObject);
    procedure DREdit_Acc_AccNoChange(Sender: TObject);
    procedure DREdit_Rpt_AccNoChange(Sender: TObject);
    procedure DRBitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function StartImportLock: Boolean;
    function EndImportLock: Boolean;
    procedure StrToMySamHead(s: string);

    function GetImportFileName: string; // Import ���ϸ� ����.

    // Import �Է»��� üũ
    function ImpAccInfoCheck(var sCreDate, sChgDate, sAccList: string): boolean;
    function ImpRptInfoCheck(var sAccList: string): boolean;

    // MCA TR ó��.
    procedure MCAImport(sGubn: string);
    function MCACallAcc(sImportFileName: string): boolean; // ����&����ó
    function MCACallRpt(sImportFileName: string): boolean; // ���� ����
    function MCACallAccNRpt(sImportFileName: string): boolean; // ����&����ó + ���� ����

    // Import ó��
    function MCAImportFileFTPGet(sImportFileName: string): boolean;
    function ImportFileOpen(bManual: boolean; sImportFileName: string): boolean;
    function ImportMain: boolean; // ** ������ǰ Import Main ó�� �Լ�() **
    function Import_AccInfo: boolean;  // ���� ���� ó�� SP ȣ��.
    function Import_AddrInfo: boolean; // ����ó ���� ó�� SP ȣ��.
    function Import_RptInfo(pFileName: string): boolean; // ���� ���� ó�� SP ȣ��.


  public
    { Public declarations }
  end;

var
  Form_SCFH8201: TForm_SCFH8201;

implementation

{$R *.dfm}

uses
  SCCLib, SCCGlobalType, SCCTFLib, SCCTFGlobalType, SCCCmuLib, SCCDataModule,
  CHILKATSSHLib_TLB;

const
  IMPDATA_CNT = 3; // Import ���� Data ���� ����
  IDX_ROW_ACC = 1; // �������� Index
  IDX_ROW_ADDR = 2; // ����ó Index
  IDX_ROW_RPT = 3; // �Ÿ� Index

  // �ڷᱸ��(����ID)
  IMP_RPT_CODE_ACC = '901'; // ���� ����
  IMP_RPT_CODE_ADDR = '902'; // ����ó ����
  IMP_RPT_CODE_RPT = '1'; // �Ϲ� ���� ���� ù��°�ڸ�
  IMP_RPT_CODE_TONG = '0'; // ��߱� ���� ���� ù��°�ڸ�

var
  DataList: TStringList;
  AccList: TStringList;
  ugb_RAID1: boolean;
  MySamHeadRec: TSamHeadRec_FI;

procedure TForm_SCFH8201.DRButton_Acc_ImportClick(Sender: TObject);
begin
  inherited;
  if gvHostCallUseYN <> 'Y' then
  begin
    //gf_ShowErrDlgMessage(Self.Tag,0,'����(CICS)�� ������ �� �����ϴ�. CICSUseYN = N, �����ͷε�� ���ǹٶ��ϴ�.',0);
    gf_ShowErrDlgMessage(Self.Tag, 0, '����(MCA)�� ������ �� �����ϴ�. �����ͷε�� ���ǹٶ��ϴ�.', 0);
    Exit;
  end;

  if not StartImportLock then Exit;

  MCAImport('A');

  EndImportLock;
end;

procedure TForm_SCFH8201.MCAImport(sGubn: string);
var
  sImportFileName, sMsg, sClientDir: string;
  ExtMsg: PChar;
begin
  try
    sClientDir := gf_ReadFormStrInfo(Self.Name, 'Default Dir', gvDirImport);

    // �������� ����Ʈ�Ҷ� ���� (����Ʈ������ settlenet\ImportData ������ ��ġ�� ftp ���� �뷮 0kb�� ����
    if (sClientDir = ExpandFileName(ExtractFilePath(Application.ExeName) + '..\..\ImportData')) then
    begin
      gf_ShowMessage(MessageBar, mtError, 0, 'Import ���� �ߺ� ����. (�����ͷε� ����)');
      Exit;
    end;

    DisableForm;
    sMsg := gwImportMsg + '(�ڷ� ����)'; // Import ���Դϴ�. ��� ��ٸ��ʽÿ�...
    ShowProcessPanel(sMsg, 0);


    gvMCAFtpFileList.Clear;

    // ���� ���ϸ� ����.
    sImportFileName := GetImportFileName;

    //1.MCA Call : ���忡�� Import File�� �����
    if sGubn = 'A' then //����&����ó
    begin
      sImportFileName := 'SZA' + sImportFileName;

      gf_Log('[' + IntToStr(Self.Tag) + '] MCACallAcc() Call.');
      if not MCACallAcc(sImportFileName) then
      begin
        HideProcessPanel;
        EnableForm;
        Exit;
      end;
    end
    else if sGubn = 'R' then // ���� ����
    begin
      sImportFileName := 'SZR' + sImportFileName;

      gf_Log('[' + IntToStr(Self.Tag) + '] MCACallRpt() Call.');
      if not MCACallRpt(sImportFileName) then
      begin
        HideProcessPanel;
        EnableForm;
        Exit;
      end;
    end
    else //����, �Ÿ� ��� ALL
    begin
      sImportFileName := 'SZT' + sImportFileName;

      gf_Log('[' + IntToStr(Self.Tag) + '] MCACallAccNRpt() Call.');
      if not MCACallAccNRpt(sImportFileName) then
      begin
        HideProcessPanel;
        EnableForm;
        Exit;
      end;
    end;

    sMsg := gwImportMsg + '(File Download)'; // Import ���Դϴ�. ��� ��ٸ��ʽÿ�...
    ShowProcessPanel(sMsg, 0);

    //2.FTP Download
    gf_log('[' + IntToStr(Self.Tag) + '] Bf ImportFileFTPGet');
    if not MCAImportFileFTPGet(sImportFileName) then
    begin
      HideProcessPanel;
      EnableForm;
      Exit;
    end;

    //3.File Open
    gf_log('[' + IntToStr(Self.Tag) + '] Bf ImportFileOpen');
    if not ImportFileOpen(False, sImportFileName) then
    begin
      HideProcessPanel;
      EnableForm;
      Exit;
    end;

    //4.Import
    gf_log('[' + IntToStr(Self.Tag) + '] Bf ImportMain');
    ImportMain;

  finally
    HideProcessPanel;
    EnableForm;
  end;
end;

//------------------------------------------------------------------------------
// Import �� ����.
//------------------------------------------------------------------------------

function TForm_SCFH8201.StartImportLock: Boolean;
  function myFormatCurDateTime: string;
  var s: string;
  begin
    s := gf_GetCurTime;
    Result := gf_GetCurDate + ' ' + LeftStr(s, 2) + ':' + Copy(s, 3, 2) + ':' + Copy(s, 5, 2);
  end;
var sSQL, sID: string;
  iTimeOut, iImportingSeconds, iMin, iSec: integer;
begin
  Result := False;

  //0.SCILOCK�� �ش� �μ� Record�� ������ �ϳ� ����.
  sSQL := ' select CNT=count(*) from SCILOCK_TBL '
    + ' where DEPT_CODE = ''' + gvDeptCode + ''' ';

  if gf_CountQuery(sSQL) <= 0 then
  begin
    sSQL := ' insert into SCILOCK_TBL ( DEPT_CODE, OPR_ID, S_DATE, S_TIME, E_DATE, E_TIME, LOCK_TIME) '
      + ' values ( ''' + gvDeptCode + ''','''','''','''','''','''','''') ';
    if not gf_ExecQuery(sSQL) then Exit;
  end;

  //1.Lock �ɱ�
  gf_BeginTransaction;

  sSQL := ' update SCILOCK_TBL '
    + ' set LOCK_TIME = ''' + gf_GetCurTime + ''' '
    + ' where DEPT_CODE = ''' + gvDeptCode + ''' ';

  if not gf_ExecQuery(sSQL) then
  begin
    gf_RollbackTransaction;
    Exit;
  end;

  //2.���� �������� Import ����
  sSQL := ' select STR = isnull(max(OPR_ID),'''') from SCILOCK_TBL '
    + ' where DEPT_CODE = ''' + gvDeptCode + ''' '
    + ' and   E_TIME = '''' '
    + ' and   OPR_ID > '''' ';

  sID := gf_ReturnStrQuery(sSQL);

  if sID > '' then //���� Import���� ����� �ִ�.
  begin
    sSQL := ' select CNT= datediff(second,convert(datetime,S_DATE + space(1) + substring(S_TIME,1,2) + '':''  + substring(S_TIME,3,2) + '':''  + substring(S_TIME,5,2),121),getdate()) '
      + ' from SCILOCK_TBL '
      + ' where DEPT_CODE = ''' + gvDeptCode + ''' ';

    iImportingSeconds := gf_CountQuery(sSQL);
    iTimeOut := StrToInt(gf_GetSystemOptionValue('HI6', '8')) * 60; //System Option : Timeout Minute��������. Default 8��

    iMin := Trunc(iImportingSeconds / 60);
    iSec := iImportingSeconds - (iMin * 60);

    if iTimeOut < iImportingSeconds then //�ٸ� ����ڰ� Import Timeout�� �ʰ��ߴ�. ��,������ Import�ѵ� �ð�(ex.8��)�� �ʰ��� ���
    begin
      //timeout�� �ʰ������� ����ɰ� Import�ҷ�?
      if gf_ShowDlgMessage(Self.Tag, mtError, 0,
        '���� ����� ' + sID + '�� Import���Դϴ�. ����ð�(' + IntToStr(iMin) + '��' + IntToStr(iSec) + '��).' + #13#10
        + '���ÿ� Import�� �ڷ� ������ �߻��� �� �ֽ��ϴ�. ' + #13#10 + #13#10
        + '�׷��� Import�Ͻðڽ��ϱ�?'
        , [mbYes, mbCancel], 0) = idCancel then
      begin
        gf_RollbackTransaction;
        Exit;
      end;
      //�׷��� Import�ϰڴٴ� ��...!
    end
    else //���� Import Timeout�� �ʰ����� �ʾҰ�, Import�������̶�� �Ǵ��ϰ� ���� Import��Ű�� �ʴ´�.
    begin
      gf_ShowErrDlgMessage(Self.Tag, 0,
        '���� ����� ' + sID + '�� Import���Դϴ�. ����ð�(' + IntToStr(iMin) + '��' + IntToStr(iSec) + '��).' + #13#10
        + '����� �ٽ� Import �õ��Ͻʽÿ�.'
        , 0);
      gf_RollbackTransaction;
      Exit;
    end;
  end;

  //3. Import Lock �ɱ�, ���� ������̴�.
  sSQL := ' update SCILOCK_TBL '
    + ' set    OPR_ID = ''' + gvOprUsrNo + ''' '
    + '       ,S_DATE = ''' + gf_GetCurDate + ''' '
    + '       ,S_TIME = ''' + gf_GetCurTime + ''' '
    + '       ,E_DATE = '''' '
    + '       ,E_TIME = '''' '
    + ' where DEPT_CODE = ''' + gvDeptCode + ''' ';

  if not gf_ExecQuery(sSQL) then
  begin
    gf_RollbackTransaction;
    Exit;
  end;

  gf_CommitTransaction;

  Result := True;
end;

//------------------------------------------------------------------------------
// Import �� ����.
//------------------------------------------------------------------------------

function TForm_SCFH8201.EndImportLock: Boolean;
var
  sSQL: string;
begin
  Result := False;

  sSQL := ' update SCILOCK_TBL '
    + ' set    OPR_ID = ''' + gvOprUsrNo + ''' '
    + '       ,E_DATE = ''' + gf_GetCurDate + ''' '
    + '       ,E_TIME = ''' + gf_GetCurTime + ''' '
    + ' where DEPT_CODE = ''' + gvDeptCode + ''' ';

  if not gf_ExecQuery(sSQL) then Exit;

  Result := True;
end;


function TForm_SCFH8201.GetImportFileName: string;
begin
  Result := gf_GetCurDate + LeftStr(gf_GetCurTime, 6) + '_' + gvDeptCode + '.txt';
end;

//------------------------------------------------------------------------------
//  MCA ���� ���� ����Ʈ
//------------------------------------------------------------------------------

function TForm_SCFH8201.MCACallAcc(sImportFileName: string): boolean;
var
  sCreDate, sChgDate, sAccList: string;
  sMsg: string;
begin
  Result := false;
  if not ImpAccInfoCheck(sCreDate, sChgDate, sAccList) then Exit;

  // ���� �������� ī��Ʈ
  gvMCAFileCnt := 0;

  //----------------------------------------------------------------------------
  // Connect MCA
  //----------------------------------------------------------------------------
  if not gf_tf_HostMCAConnect(False, sMsg) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 0, 'MCA ���� ����.'
      + #13#10 + #13#10 + sMsg, 0);
    Exit;
  end;

  gf_log('[' + IntToStr(Self.Tag) + '] Bf gf_tf_HostMCAsngetZACInfo[��������]');
  if not gf_tf_HostMCAsngetZACInfo(sCreDate, sChgDate, sAccList, sImportFileName, sMsg) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 0,
      '���忡�� ���� Import ���� ������ ����(MCA)'
      + #13#10 + #13#10 + sMsg, 0);
    Exit;
  end;

  Result := True;
end;

function TForm_SCFH8201.MCACallRpt(sImportFileName: string): boolean;
var
  sAccList: string;
  sMsg: string;
begin
  Result := false;
  if not ImpRptInfoCheck(sAccList) then Exit;

  // ���� �������� ī��Ʈ
  gvMCAFileCnt := 0;

  //----------------------------------------------------------------------------
  // Connect MCA
  //----------------------------------------------------------------------------
  if not gf_tf_HostMCAConnect(False, sMsg) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 0, 'MCA ���� ����.'
      + #13#10 + #13#10 + sMsg, 0);
    Exit;
  end;

  gf_log('[' + IntToStr(Self.Tag) + '] Bf gf_tf_HostMCAsngetZRPTInfo[���� ����]');
  // !! ���� ������ ���� ������ ó���Ѵ�.
  if not gf_tf_HostMCAsngetZRPTInfo(gvCurDate, sAccList, sImportFileName, sMsg) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 0,
      '���忡�� ���� ���� Import ���� ������ ����(MCA)'
      + #13#10 + #13#10 + sMsg, 0);
    Exit;
  end;

  Result := True;
end;

function TForm_SCFH8201.MCACallAccNRpt(sImportFileName: string): boolean;
var
  sCreDate, sChgDate, sAccList: string;
  sMsg: string;
begin
  Result := false;

  // ���� �������� ī��Ʈ
  gvMCAFileCnt := 0;

  //----------------------------------------------------------------------------
  // Connect MCA
  //----------------------------------------------------------------------------
  if not gf_tf_HostMCAConnect(False, sMsg) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 0, 'MCA ���� ����.'
      + #13#10 + #13#10 + sMsg, 0);
    Exit;
  end;

  //-- ����&����ó -------------------------------------------------------------
  if not ImpAccInfoCheck(sCreDate, sChgDate, sAccList) then Exit;

  gf_log('[' + IntToStr(Self.Tag) + '] Bf gf_tf_HostMCAsngetZACInfo[��������]');
  if not gf_tf_HostMCAsngetZACInfo(sCreDate, sChgDate, sAccList, sImportFileName, sMsg) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 0,
      '���忡�� ���� Import ���� ������ ����(MCA)'
      + #13#10 + #13#10 + sMsg, 0);
    Exit;
  end;

  //-- ���� ���� -------------------------------------------------------------
  if not ImpRptInfoCheck(sAccList) then Exit;

  gf_log('[' + IntToStr(Self.Tag) + '] Bf gf_tf_HostMCAsngetZRPTInfo[���� ����]');
  // !! ���� ������ ���� ������ ó���Ѵ�.
  if not gf_tf_HostMCAsngetZRPTInfo(gvCurDate, sAccList, sImportFileName, sMsg) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 0,
      '���忡�� ���� ���� Import ���� ������ ����(MCA)'
      + #13#10 + #13#10 + sMsg, 0);
    Exit;
  end;

  Result := True;
end;

function TForm_SCFH8201.ImpAccInfoCheck(var sCreDate, sChgDate, sAccList: string): boolean;
begin
  Result := false;

  sCreDate := '';
  sChgDate := '';
  sAccList := '';

  // ���� ���� Ȯ��
  if DRRadioButton_Acc_CreDate.Checked then
  begin
    sCreDate := Trim(DRMaskEdit_Acc_CreDate.Text);
    if (sCreDate = '') or
      (gf_CheckValidDate(sCreDate) = False) then
    begin
      gf_ShowMessage(MessageBar, mtError, 1040, ''); //���� �Է� ����
      DRMaskEdit_Acc_CreDate.SetFocus;
      sCreDate := '';
      Exit;
    end;
  end else
  // ���� ���� Ȯ��
    if DRRadioButton_Acc_ChgDate.Checked then
    begin
      sChgDate := Trim(DRMaskEdit_Acc_ChgDate.Text);
      if (sChgDate = '') or
        (gf_CheckValidDate(sChgDate) = False) then
      begin
        gf_ShowMessage(MessageBar, mtError, 1040, ''); //���� �Է� ����
        DRMaskEdit_Acc_ChgDate.SetFocus;
        sChgDate := '';
        Exit;
      end;
    end else
  // ���¹�ȣ Ȯ��
      if DRRadioButton_Acc_AccNo.Checked then
      begin
        if (Length(Trim(DREdit_Acc_AccNo.Text)) <> 8) then //DRLabel_AAccName.Caption = ''
        begin
          gf_ShowMessage(MessageBar, mtError, 0, '���¹�ȣ�� �߸��Ǿ����ϴ�.');
          DREdit_Acc_AccNo.SetFocus;
          Exit;
        end;
        sAccList := Trim(DREdit_Acc_AccNo.Text);
      end;

  Result := True;
end;


function TForm_SCFH8201.MCAImportFileFTPGet(
  sImportFileName: string): boolean;
var
  sFTPMode, sIP, sID, sPW,
    sFTPPath, sClientDir: string;
  iPort: Integer;
  i: integer;
  sGetFileName: string;

  slMergeFileList: TStringList;
  slPartFileList: TStringList;

  {sFTP}
  sFTP: TChilkatSFtp;
  FileList: IChilkatSFtpDir;
  FileObj: IChilkatSFtpFile;
  sPathHandle, sFileHandle: WideString;
begin
  try
    Result := false;

    slMergeFileList := TStringList.Create;
    slPartFileList := TStringList.Create;

    if gvMCAFtpFileList.Count <= 0 then Exit;

    // FTP ���� IP
    sFTPMode := gvMCAFileFtpMode;
    // FTP ���� IP
    sIP := gvMCAFileFtpIP;
    // FTP ���� Port
    iPort := gvMCAFileFtpPort;
    // FTP ���� ID
    sID := gvMCAFileFtpID;
    // FTP ���� PASSWD
    sPW := gvMCAFileFtpPW;
    // FTP ���� ���
    sFTPPath := gvMCAFileFtpPath;

    if (sIP = '') or (sID = '') or (sPW = '') then
    begin
      gf_ShowErrDlgMessage(Self.Tag, 0, 'FTP���������� �����ϴ�.', 0);
      gf_ShowMessage(MessageBar, mtError, 0, 'Import ����: FTP');
      Exit;
    end;

    sClientDir := gf_ReadFormStrInfo(Self.Name, 'Default Dir', gvDirImport);

    if not DirectoryExists(sClientDir) then
      sClientDir := gvDirImport;

    if sFTPMode <> 'SFTP' then
    begin
      // FTP Mode --------------------------------------------------------------
      with IdFTP1 do
      begin
        try
          gf_Log(Self.Name + '[FTP] ó�� ����. ');

          IdFtp1.Intercept := IdLogEvent1;

          if not IdFTP1.Connected then
          begin
            Username := sID;
            Password := sPW;
            Host := sIP;
            Connect;
          end;
          gf_Log(Self.Name + '[FTP] ���� ���� �Ϸ�. (' + sIP + ',' + IntToStr(iPort));

          TransferType := ftASCII;

          // FTP������ ������ ���� ��������
          for i := 0 to gvMCAFtpFileList.Count - 1 do
          begin
            sGetFileName := Trim(gvMCAFtpFileList.Strings[i]);

            try
              Get(sGetFileName, sClientDir + '\' + sGetFileName, true, false);
            except
              on E: Exception do
              begin
                Continue;
              end;
            end;
            gf_Log(Self.Name + '[FTP] ���� ��� ���� �ޱ� �Ϸ�. ' + sGetFileName);

            // ������ ���� ����Ʈ�� ����
            slPartFileList.LoadFromFile(sClientDir + '\' + sGetFileName);
            // ������ ����Ʈ�� ���� ����Ʈ�� ����
            slMergeFileList.AddStrings(slPartFileList);
            // ����Ʈ�� ����� ���� ����
            if FileExists(sClientDir + '\' + sGetFileName) then
            begin
              DeleteFile(sClientDir + '\' + sGetFileName);
            end;
          end; // for i:=0 to gvMCAFtpFileList.Count-1 do
          // FTP ���� ����
          Quit;
        except
          on E: Exception do
          begin
            gf_ShowErrDlgMessage(Self.Tag, 0, 'FTP Error: ' + E.Message, 0);
            Quit;
            Exit;
          end;
        end;
      end; //with
    end else
    begin
      // SFTP Mode -------------------------------------------------------------
      try
        gf_Log(Self.Name + ' [SFTP] ó�� ����.');

        // Component Initialize
        sFTP := TChilkatsFTP.Create(Self);
        if sFTP.UnlockComponent('DATAROSSH_NOCXOD3U7ExX') <> 1 then
        begin
          gf_Log(Self.Name + ' [SFTP] ���۳�Ʈ �ʱ�ȭ Err. ' + sFTP.LastErrorText);
          exit;
        end;
        //  Set some timeouts, in milliseconds:
        sFTP.ConnectTimeoutMs := 5000;
        sFTP.IdleTimeoutMs := 10000;
        sFTP.MaxPacketSize := 0;

        // FTP Connect
        if sFTP.Connect(sIP, iPort) <> 1 then
        begin
          gf_Log(Self.Name + ' [SFTP] ���� ���� Err. ' + sFTP.LastErrorText);
          exit;
        end;

        // FTP Login
        if sFTP.AuthenticatePw(sID, sPW) <> 1 then
        begin
          gf_Log(Self.Name + ' [SFTP] ���� �α��� Err. ' + sFTP.LastErrorText);
          exit;
        end;

        //  After authenticating, the SFTP subsystem must be initialized:
        if sFTP.InitializeSftp() <> 1 then
        begin
          gf_Log(Self.Name + ' [SFTP] ���� ����ȭ Err. ' + sFTP.LastErrorText);
          exit;
        end;

        // ��� ����
        if (Trim(sFTPPath) <> '') then
        begin
          sPathHandle := sFTP.OpenDir(sFTPPath);
          if (Length(sPathHandle) = 0) then
          begin
            gf_Log(Self.Name + ' [SFTP] ���� ��� ���� Err. ' + sFTP.LastErrorText);
            Exit;
          end;
        end;
        gf_Log(Self.Name + ' [SFTP] ���� ���� �Ϸ�. (' + sIP + ',' + IntToStr(iPort));

        // FTP������ ������ ���� ��������
        for i := 0 to gvMCAFtpFileList.Count - 1 do
        begin
          sGetFileName := Trim(gvMCAFtpFileList.Strings[i]);

          //  Open a file on the server:
          sFileHandle := sFTP.OpenFile(sGetFileName, 'readOnly', 'openExisting');
          if (Length(sFileHandle) = 0) then
          begin
            gf_Log(Self.Name + ' [SFTP] ���� ��� ���� ���� Err. ' + sftp.LastErrorText);
            Exit;
          end;

          //  Download the file:
          if (sftp.DownloadFile(sFileHandle, sClientDir + '\' + sGetFileName) <> 1) then
          begin
            gf_Log(Self.Name + ' [SFTP] ���� ��� ���� �ޱ� Err. ' + sftp.LastErrorText);
            Exit;
          end;

          //  Close the file.
          if (sftp.CloseHandle(sFileHandle) <> 1) then
          begin
            gf_Log(Self.Name + ' [SFTP] ���� ��� ���� ���� ���� Err. ' + sftp.LastErrorText);
            Exit;
          end;
          gf_Log(Self.Name + ' [SFTP] ���� ��� ���� �ޱ� �Ϸ�. ' + sGetFileName);

          // ������ ���� ����Ʈ�� ����
          slPartFileList.LoadFromFile(sClientDir + '\' + sGetFileName);
          // ������ ����Ʈ�� ���� ����Ʈ�� ����
          slMergeFileList.AddStrings(slPartFileList);
          // ����Ʈ�� ����� ���� ����
          if FileExists(sClientDir + '\' + sGetFileName) then
          begin
            DeleteFile(sClientDir + '\' + sGetFileName);
          end;
        end; // for i:=0 to gvMCAFtpFileList.Count-1 do
      finally
        if Assigned(sFTP) then
        begin
          if (Trim(sFTPPath) <> '') then
          begin
            if sftp.CloseHandle(sPathHandle) <> 1 then
            begin
              gf_Log(Self.Name + ' [SFTP] CloseHandle Err. ' + sftp.LastErrorText);
            end;
          end;

          sftp.Disconnect;
          gf_Log(Self.Name + ' [SFTP] ó�� ����.');
        end;
      end;
    end;

    // ���յ� ���� ����
    slMergeFileList.SaveToFile(sClientDir + '\' + sImportFileName);

    gf_Log(Self.Name + ' ���� ����: ' + sClientDir + '\' + sImportFileName);

    Result := True;
  finally
    FreeAndNil(slMergeFileList);
    FreeAndNil(slPartFileList);
  end;
end;

function TForm_SCFH8201.ImportFileOpen(bManual: boolean;
  sImportFileName: string): boolean;
var
  iIndex, iSamHdrSize, iHdrCnt, K: Integer;
  fTextFile: TextFile;
  sBaseDate, sFileName, sReadBuff, sTotHeader, sHeader: string;
  iDataCnt: array[0..IMPDATA_CNT - 1] of Integer;

  SearchRec: TSearchRec;
  sDirName: string;
begin

  Result := false;

  gf_ClearMessage(MessageBar);
  DRLabel_FileName.Caption := '';
  DRLabel_BaseDate.Caption := '';
   //DRLabel_DataCnt.Caption  := '';
  DRLabel_FileDate.Caption := '';
  DRLabel_FileSize.Caption := '';
  DRRichEdit_File.Lines.Clear;

   //--- ���� ���� (Ini���� Defualt Dir �о����, ���� �� ����)
  sDirName := gf_ReadFormStrInfo(Self.Name, 'Default Dir', gvDirImport);
  if DirectoryExists(sDirName) then
    DROpenDialog_Import.InitialDir := sDirName
  else
    DROpenDialog_Import.InitialDir := gvDirImport;


  if bManual then //����ڰ� ���� ���� ���ý� ���� Open â�� ���
  begin
    if not DROpenDialog_Import.Execute then
    begin
      DREdit_FileName.Text := '';
      Exit;
    end;

    Screen.Cursor := crHourGlass;
    sDirName := ExtractFileDir(DROpenDialog_Import.FileName);
    gf_WriteFormStrInfo(Self.Name, 'Default Dir', sDirName);

    DREdit_FileName.Text := DROpenDialog_Import.FileName;
  end else //���� ȣ�� ó���� �ڵ����� ������ ������.
  begin
    DREdit_FileName.Text := DROpenDialog_Import.InitialDir + '\' + sImportFileName; // ��μ���
  end;

  sFileName := Trim(DREdit_FileName.Text);

  if sFileName = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1034, ''); //������ �����Ͻʽÿ�.
    Exit;
  end;

  if FindFirst(sFileName, faAnyFile, SearchRec) <> 0 then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 1027, DREdit_FileName.Text, 0); //List ���� ����
    gf_ShowMessage(MessageBar, mtError, 1027, ''); // �ش� ������ �������� �ʽ��ϴ�.
    Screen.Cursor := crDefault;
    Exit;
  end;


   //--- Display to RichEdit
  DRRichEdit_File.Lines.LoadFromFile(sFileName);

   //--- Display File Info.
  DRLabel_FileName.Caption := ExtractFileName(sFileName);
   //DRLabel_DataCnt.Caption := IntToStr(DRRichEdit_File.Lines.Count);
  DRLabel_FileDate.Caption :=
    DateTimeToStr(FileDateToDateTime(FileAge(DREdit_FileName.Text)));
  DRLabel_FileSize.Caption := IntToStr(SearchRec.Size);

   //--- Clear
  for iIndex := 1 to DRStrGrid_ImportInfo.RowCount - 1 do
  begin
    DRStrGrid_ImportInfo.Cells[1, iIndex] := 'X'; // ���Կ��� clear
    DRStrGrid_ImportInfo.Cells[2, iIndex] := 'X'; // �ڷ᰹�� clear
  end; // end of for

  for iIndex := 0 to IMPDATA_CNT - 1 do iDataCnt[iIndex] := 0;

  if DRRichEdit_File.Lines.Count <= 0 then
  begin
    gf_ShowMessage(MessageBar, mtError, 0, '����ڷᰡ �������� �ʽ��ϴ�.'); // �ش� ������ �����ϴ�.
    Screen.Cursor := crDefault;
    Exit;
  end;

  AssignFile(fTextFile, sFileName);
{$I-}
  Reset(fTextFile);
{$I+}
  if IOResult <> 0 then
  begin
    gf_ShowMessage(MessageBar, mtError, 1027, ''); //�ش� ������ �������� �ʽ��ϴ�.
    CloseFile(fTextFile);
    Screen.Cursor := crDefault;
    Exit;
  end;

   //--- DataList ����
  DataList.Clear;
  while not Eof(fTextFile) do
  begin
    Readln(fTextFile, sReadBuff); // ���Ͽ��� �� �� �о�� sReadBuff �� ����.

    if Trim(sReadBuff) <> '' then
    begin
      iSamHdrSize := SizeOf(MySamHeadRec);
      StrToMySamHead(sReadBuff);
//        MoveDataChar(@MySamHeadRec, sReadBuff, iSamHdrSize);

        // ������ǰ �ڷ��� ��� ó��.
      if (MySamHeadRec.SecType = gcSEC_FINANCIALINS) then
      begin
          // ����� �������ڰ� ������ ��쿡 �����͸� �߶���µ� ���� �߻�
          // � ���ڸ� Space�� ��ġ��Ű�Ƿμ� Import ���� ����!
        DataList.Add(StringReplace(StringReplace(sReadBuff, '� ', '  ', [rfReplaceAll]), #159, ' ', [rfReplaceAll]));
      end;
    end;
  end; // end of while
  CloseFile(fTextFile);

   //--- Assign �ڷ�����
  for iIndex := 0 to DataList.Count - 1 do
  begin
    StrToMySamHead(Trim(DataList.Strings[iIndex]));
      //MoveDataChar(@MySamHeadRec, DataList.Strings[iIndex], SizeOf(MySamHeadRec));

    if (Copy(MySamHeadRec.Version, 1, 1) <> 'T') or (MySamHeadRec.SecType <> gcSEC_FINANCIALINS) then
    begin
      gf_ShowMessage(MessageBar, mtError, 9005,
        gwErrLineNo + IntToStr(iIndex + 1) + '(��������)'); // ������ ����
      Screen.Cursor := crDefault;
      Exit;
    end;

    if iIndex = 0 then // �ڷ� ���� ���� ó�� (SUIMLOG_TLB�� SEC_DATE_
    begin
      sBaseDate := Trim(MySamHeadRec.CreDate);
      DRLabel_BaseDate.Caption := gf_FormatDate(sBaseDate);
      sBaseDate := '$$'; //�Ÿ��ڷ��� �Ÿ����� MaskEdit_TradeDate �� �ֱ� ����. �ֳ�? ���۾����� ���Ͽ��� �Ͽ� Import�Ҷ� TradeDate�� �޶����� �� �ֱ� �����̴�.
    end;

    if (MySamHeadRec.ReportID = IMP_RPT_CODE_ACC) then
    begin
      Inc(iDataCnt[IDX_ROW_ACC - 1]); // ���� ����
    end else
    if (MySamHeadRec.ReportID = IMP_RPT_CODE_ADDR) then
    begin
      Inc(iDataCnt[IDX_ROW_ADDR - 1]); // ����ó ����
    end else
    if (Copy(MySamHeadRec.ReportID, 1, 1) = IMP_RPT_CODE_RPT) or
      (Copy(MySamHeadRec.ReportID, 1, 1) = IMP_RPT_CODE_TONG) then
    begin
      Inc(iDataCnt[IDX_ROW_RPT - 1]); // ���� ���� ����
    end else
    begin
      gf_ShowMessage(MessageBar, mtError, 9005,
        gwErrLineNo + IntToStr(iIndex + 1) + '(�ڷᱸ��)'); //������ ����
      Screen.Cursor := crDefault;
      Exit;
    end;
  end; // end For

   //--- Display �ڷ�����
  for iIndex := 1 to IMPDATA_CNT do
  begin
    if iDataCnt[iIndex - 1] > 0 then
    begin
      DRStrGrid_ImportInfo.Cells[1, iIndex] := 'O';
      DRStrGrid_ImportInfo.Cells[2, iIndex] := IntToStr(iDataCnt[iIndex - 1]);
    end else
    begin
      DRStrGrid_ImportInfo.Cells[1, iIndex] := 'X';
      DRStrGrid_ImportInfo.Cells[2, iIndex] := 'X';
    end;
  end; // end of for

  Screen.Cursor := crDefault;

  Result := True;
end;

procedure TForm_SCFH8201.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  if IdFTP1.Connected then
  begin
    IdFTP1.Quit;
  end;
end;

procedure TForm_SCFH8201.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if Assigned(DataList) then DataList.Free;
  if Assigned(AccList) then AccList.Free;
end;

// ������ǰ Import Main ó�� �Լ�()

function TForm_SCFH8201.ImportMain: boolean;
const
  // Data�� DataCount, DataSize
  // 7500 / DATA_SIZE = ? (8000�� SP���� �޾��ټ��ִ� MAX SIZE, 500�� Argument�� ����)

  MAX_DATA_CNT = 4;

  //���� =======================================================================
  DATA_CNT_ACC = 39;
  DATA_SIZE_ACC = 190;

  // ����ó ====================================================================
  DATA_CNT_ADDR = 13;
  DATA_SIZE_ADDR = 560;

  // ���� ���� ===============================================================
  DATA_SIZE_RPT   = 7500; // �ִ� ���̷� ���.
  DATA_DELIMITER  = '|'; // �ٹٲ� ������

var
  I, iIndex, iDataType, iStartSeqNo, iAccIndex, iSubAccIndex: Integer;
  iMaxDataCnt, iMaxDataSize, iDataCnt: Integer;
  sFirstBrnCode, sDeptCode, sRptID, sSecType, sCreDate, sMsg: string;
  sReadBuff, sSumBuff: string;
  sVersion, sDataGbn, sDlgMsg, sDate, sTime: string;
  sImpFileName: string;
begin
  Result := False;
  gf_ClearMessage(MessageBar);

  gf_log('[' + IntToStr(Self.Tag) + '] start importmain');
  if Trim(DREdit_FileName.Text) = '' then
  begin
    HideProcessPanel;
    EnableForm;
    gf_ShowMessage(MessageBar, mtError, 1034, ''); // ������ �����Ͻʽÿ�.
    Exit;
  end;

  if DataList.Count <= 0 then
  begin
    HideProcessPanel;
    EnableForm;
    gf_ShowMessage(MessageBar, mtError, 0, '��� �ڷᰡ �������� �ʽ��ϴ�.');
    Exit;
  end;

  sReadBuff := DataList.Strings[0];

//  if (Copy(sReadBuff, 6, 1) <> gcSEC_FINANCIALINS) then
//  begin
//    HideProcessPanel;
//    EnableForm;
//    gf_ShowMessage(MessageBar, mtError, 9005, '���������� �߸��Ǿ����ϴ�. (' + Copy(sReadBuff, 5, 1) + ')');
//    Exit;
//  end;

  if (Copy(sReadBuff, 1, 1) <> 'T') then
  begin
    HideProcessPanel;
    EnableForm;
    gf_ShowMessage(MessageBar, mtError, 9005, '�������� �ʴ� �����Դϴ�. (' + Copy(sReadBuff, 1, 1) + ') �����ͷε忡 �����Ͻʽÿ�.');
    Exit;
  end else
    if (Copy(sReadBuff, 1, 1) = 'T') then
    begin
      StrToMySamHead(sReadBuff);
  //MoveDataChar(@MySamHeadRec, sReadBuff, SizeOf(MySamHeadRec));
      sSecType := MySamHeadRec.SecType;
      sCreDate := Trim(MySamHeadRec.CreDate);
      sFirstBrnCode := Trim(MySamHeadRec.BrnCode);
    end else
    begin
      HideProcessPanel;
      EnableForm;
      gf_ShowMessage(MessageBar, mtError, 9005, '�� �� ���� �ڷ��Դϴ�. �ڷᱸ��(' + Copy(sReadBuff, 1, 1) + ')');
      Exit;
    end;

  // �μ��ڵ� Check
  if not gf_GetGlobalDeptCode(sFirstBrnCode, sDeptCode) then
  begin
    HideProcessPanel;
    EnableForm;
    gf_ShowErrDlgMessage(Self.Tag, gvErrorNo, gvExtMsg, 0); // Error Message
    gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg);
  end; // end of if

//  if sDeptCode <> gvDeptCode then
//  begin
//    HideProcessPanel;
//    EnableForm;
//    gf_ShowMessage(MessageBar, mtError, 2020,
//      'ImportFile�� �μ�(' + sDeptCode + ')�� ����� �μ�(' + gvDeptCode + ')�� �ٸ��ϴ�.');
//    Exit;
//  end;

  DisableForm;
  sMsg := gwImportMsg + '(Insert TempTable)'; // Import ���Դϴ�. ��� ��ٸ��ʽÿ�...
  ShowProcessPanel(sMsg, DataList.Count);

   //--------------------
  gf_Begintransaction;
   //--------------------

   //----------------------------------------------------------------------------
   // SamFile DB Write Stored Procedure Call
   //----------------------------------------------------------------------------

  iStartSeqNo := 1; // SCTEMP_TBL�� Package�� ���� ù��° SeqNo
  iDataCnt := 0; // SCTEMP_TBL�� Package�� ���� Data Count
  sSumBuff := '';

  //----------------------------------------
  // 2. ����&����ó ���� SCTEMP_TBL INSERT
  //----------------------------------------
  if (DRStrGrid_ImportInfo.Cells[1, IDX_ROW_ACC] <> 'X') or
    (DRStrGrid_ImportInfo.Cells[1, IDX_ROW_ADDR] <> 'X') then
  begin
    gf_log('[' + IntToStr(Self.Tag) + '] bf ����&����ó ���� SCTEMP_TBL INSERT');
    if (DRStrGrid_ImportInfo.Cells[1, IDX_ROW_ACC] <> 'X') then
    begin
      iMaxDataCnt := DATA_CNT_ACC;
      iMaxDataSize := DATA_SIZE_ACC;
    end
    else
      if (DRStrGrid_ImportInfo.Cells[1, IDX_ROW_ADDR] <> 'X') then
      begin
        iMaxDataCnt := DATA_CNT_ADDR;
        iMaxDataSize := DATA_SIZE_ADDR;
      end;

    for iIndex := 0 to DataList.Count - 1 do
    begin
      sReadBuff := DataList.Strings[iIndex];
      if Trim(sReadBuff) = '' then Continue;
      StrToMySamHead(sReadBuff);
//        MoveDataChar(@MySamHeadRec, sReadBuff, SizeOf(MySamHeadRec));

      // ���� ������ �Ѿ��.
      if (copy(sReadBuff, 8, 1) <> '9') then Continue;

      if (Copy(MySamHeadRec.Version, 1, 1) <> 'T') then // or (MySamHeadRec.SecType <> gcSEC_FINANCIALINS)
      begin
        gf_RollBackTransaction;
        sMsg := gwImportErrMsg + gwClickOKMsg + // Import �� ���� �߻�! Ȯ�� ��ư�� �����ֽʽÿ�.
          '(' + gwErrLineNo + IntToStr(iIndex + 1) + ')';
        ErrorProcessPanel(sMsg, True);
        gf_ShowMessage(MessageBar, mtError, 9005, gwErrLineNo + IntToStr(iIndex + 1)); // ������ ����
        Exit;
      end;

//      if Trim(MySamHeadRec.BrnCode) <> sFirstBrnCode then
//      begin
//        gf_RollBackTransaction;
//        sMsg := gwImportErrMsg + gwClickOKMsg + // Import �� ���� �߻�! Ȯ�� ��ư�� �����ֽʽÿ�.
//          '(' + gwErrLineNo + IntToStr(iIndex + 1) + ')';
//        ErrorProcessPanel(sMsg, True);
//        gf_ShowMessage(MessageBar, mtError, 2020, gwErrLineNo + IntToStr(iIndex + 1)); // �μ��ڵ� ����
//        Exit;
//      end;

      sReadBuff := MoveDataStr(sReadBuff, iMaxDataSize + 1); // 800 Byte�� ������ ����
      sSumBuff := sSumBuff + sReadBuff;
      inc(iDataCnt, 1);
      if iDataCnt = iMaxDataCnt then // Package�� ä����
      begin
        DataModule_SettleNet.ADOSP_SP0100_1.Parameters.ParamByName('@in_DeptUserID').Value := gvDeptCode + gvOprUsrNo;
        DataModule_SettleNet.ADOSP_SP0100_1.Parameters.ParamByName('@in_str_seq').Value := iStartSeqNo;
        DataModule_SettleNet.ADOSP_SP0100_1.Parameters.ParamByName('@in_cnt').Value := iDataCnt;
        DataModule_SettleNet.ADOSP_SP0100_1.Parameters.ParamByName('@in_size').Value := iMaxDataSize;
        DataModule_SettleNet.ADOSP_SP0100_1.Parameters.ParamByName('@in_data').Value := sSumBuff;
        sSumBuff := '';
        try
          Application.ProcessMessages;
          DataModule_SettleNet.ADOSP_SP0100_1.Execute;

          if Trim(DataModule_SettleNet.ADOSP_SP0100_1.Parameters.ParamByName('@out_rtc').Value) <> '' then
          begin
            gf_RollBackTransaction;
            gf_ShowErrDlgMessage(Self.Tag, 1031, //Database ����
              'ADOSP_SP0100_1: ' + Trim(DataModule_SettleNet.ADOSP_SP0100_1.Parameters.ParamByName('@out_kor_msg').Value), 0);
            sMsg := gwImportErrMsg + gwClickOKMsg; // Import �� ���� �߻�! Ȯ�� ��ư�� �����ֽʽÿ�.
            ErrorProcessPanel(sMsg, True);
            gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_SP0100_1'); //Import�� �����߻�
            Exit;
          end;

        except
          on E: Exception do
          begin
            gf_RollBackTransaction;
            gf_ShowErrDlgMessage(Self.Tag, 1031, 'ADOSP_SP0100_1: ' + E.Message, 0);
            sMsg := gwImportErrMsg + gwClickOKMsg; // Import �� ���� �߻�! Ȯ�� ��ư�� �����ֽʽÿ�.
            ErrorProcessPanel(sMsg, True);
            gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_SP0100_1'); //Import�� �����߻�
            Exit;
          end;
        end;

        iStartSeqNo := iStartSeqNo + iDataCnt;
        iDataCnt := 0; // Clear
        sSumBuff := '';
      end; //end if
    end; //end For

     //������ �ڷ� Call
    if iDataCnt > 0 then // ó�� Data ����
    begin
      DataModule_SettleNet.ADOSP_SP0100_1.Parameters.ParamByName('@in_DeptUserID').Value :=
        gvDeptCode + gvOprUsrNo;
      DataModule_SettleNet.ADOSP_SP0100_1.Parameters.ParamByName('@in_str_seq').Value := iStartSeqNo;
      DataModule_SettleNet.ADOSP_SP0100_1.Parameters.ParamByName('@in_cnt').Value := iDataCnt;
      DataModule_SettleNet.ADOSP_SP0100_1.Parameters.ParamByName('@in_size').Value := iMaxDataSize;
      DataModule_SettleNet.ADOSP_SP0100_1.Parameters.ParamByName('@in_data').Value := sSumBuff;
      try
        Application.ProcessMessages;
        DataModule_SettleNet.ADOSP_SP0100_1.Execute;

        if Trim(DataModule_SettleNet.ADOSP_SP0100_1.Parameters.ParamByName('@out_rtc').Value) <> '' then
        begin
          gf_RollBackTransaction;
          gf_ShowErrDlgMessage(Self.Tag, 1031, //Database ����
            'ADOSP_SP0100_1: ' + Trim(DataModule_SettleNet.ADOSP_SP0100_1.Parameters.ParamByName('@out_kor_msg').Value), 0);
          sMsg := gwImportErrMsg + gwClickOKMsg; // Import �� ���� �߻�! Ȯ�� ��ư�� �����ֽʽÿ�.
          ErrorProcessPanel(sMsg, True);
          gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_SP0100_1'); //Import�� �����߻�
          Exit;
        end;

      except
        on E: Exception do
        begin
          gf_RollBackTransaction;
          gf_ShowErrDlgMessage(Self.Tag, 1031, //Database ����
            'ADOSP_SP0100_1: ' + E.Message, 0);
          sMsg := gwImportErrMsg + gwClickOKMsg; // Import �� ���� �߻�! Ȯ�� ��ư�� �����ֽʽÿ�.
          ErrorProcessPanel(sMsg, True);
          gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_SP0100_1'); //Import�� �����߻�
          Exit;
        end;
      end;

      iStartSeqNo := iStartSeqNo + iDataCnt;
      iDataCnt := 0; // Clear
      sSumBuff := '';
    end; // end of for
  end; // 2. ����&����ó ���� SCTEMP_TBL INSERT

  //----------------------------------------
  // 3. �ֽĸŸų��� Temp�� �ִ´�
  //----------------------------------------
  if DRStrGrid_ImportInfo.Cells[1, IDX_ROW_RPT] <> 'X' then
  begin
    gf_log('[' + IntToStr(Self.Tag) + '] bf ���� ���� SCTEMP_TBL INSERT');

    //------------------------------------------------------------------------
    // ���� �ڷ� üũ. (���� ���� ���� �� ù��° �ٸ� üũ�Ѵ�.)
    //------------------------------------------------------------------------      
    for iIndex:=0 to DataList.Count-1 do
    begin
      sReadBuff := DataList.Strings[iIndex];

      if Trim(sReadBuff) = '' then Continue;

      StrToMySamHead(sReadBuff);
      sSecType := MySamHeadRec.SecType;
      sCreDate := Trim(MySamHeadRec.CreDate);
      sFirstBrnCode := Trim(MySamHeadRec.BrnCode);

      // ���� ������ �ƴϸ� �Ѿ��.
      if (copy(sReadBuff, 8, 1) <> '1') and
        (copy(sReadBuff, 8, 1) <> '0') then Continue;

      if (Copy(MySamHeadRec.Version, 1, 1) <> 'T') then // or (MySamHeadRec.SecType <> gcSEC_FINANCIALINS)
      begin
        gf_RollBackTransaction;
        sMsg := gwImportErrMsg + gwClickOKMsg + // Import �� ���� �߻�! Ȯ�� ��ư�� �����ֽʽÿ�.
          '(' + gwErrLineNo + IntToStr(iIndex + 1) + ')';
        ErrorProcessPanel(sMsg, True);
        gf_ShowMessage(MessageBar, mtError, 9005, gwErrLineNo + IntToStr(iIndex + 1)); // ������ ����
        Exit;
      end;

      // ���� ���� üũ
//      if not gf_CheckValidDate(sCreDate) then
//      begin
//        gf_RollBackTransaction;
//        sMsg := gwImportErrMsg + gwClickOKMsg + // Import �� ���� �߻�! Ȯ�� ��ư�� �����ֽʽÿ�.
//          '(' + gwErrLineNo + IntToStr(iIndex + 1) + ')' + ' ���ڿ���';
//        ErrorProcessPanel(sMsg, True);
//        gf_ShowMessage(MessageBar, mtError, 9005, gwErrLineNo + IntToStr(iIndex + 1) + ' ���ڿ���'); // ������ ����
//        Exit;
//      end;

      // �μ��ڵ� Check
      if not gf_GetGlobalDeptCode(sFirstBrnCode, sDeptCode) then
      begin
        gf_RollBackTransaction;
        sMsg := gwImportErrMsg + gwClickOKMsg + // Import �� ���� �߻�! Ȯ�� ��ư�� �����ֽʽÿ�.
          '(' + gwErrLineNo + IntToStr(iIndex + 1) + ')' + ' �μ�����.';
        ErrorProcessPanel(sMsg, True);
        gf_ShowMessage(MessageBar, mtError, 9005, gwErrLineNo + IntToStr(iIndex + 1) + ' �μ�����.'); // ������ ����
        Exit; Exit;
      end; // end of if

//      if sDeptCode <> gvDeptCode then
//      begin
//        gf_RollBackTransaction;
//        sMsg := gwImportErrMsg + gwClickOKMsg + // Import �� ���� �߻�! Ȯ�� ��ư�� �����ֽʽÿ�.
//          '(' + gwErrLineNo + IntToStr(iIndex + 1) + ')' + #13#10 + 'TextFile�μ��� ����ںμ��� Ʋ��.';
//        ErrorProcessPanel(sMsg, True);
//        gf_ShowMessage(MessageBar, mtError, 9005, gwErrLineNo + IntToStr(iIndex + 1) + ' TextFile�μ��� ����ںμ��� Ʋ��.'); // ������ ����
//        Exit;
//      end;
      sVersion := copy(sReadBuff, 1, 4);

      Break;
    end; // ���� �ڷ� üũ. (���� ���� ���� �� ù��° �ٸ� üũ�Ѵ�.)

    //------------------------------------------------------------------------
    // ���� ���� �ڷ� ����. (����&����ó ������ �и�.)
    //------------------------------------------------------------------------
    sSumBuff := '';
    iMaxDataSize := DATA_SIZE_RPT;
//    iMaxDataCnt := ;

    for iIndex := 0 to DataList.Count - 1 do
    begin
      sReadBuff := DataList.Strings[iIndex];
      if (RightStr(sReadBuff,1) <> #09) then sReadBuff := sReadBuff + #09;

      if Trim(sReadBuff) = '' then Continue;

      // ���� ������ �ƴϸ� �Ѿ��.
      if (copy(sReadBuff, 8, 1) <> '1') and
        (copy(sReadBuff, 8, 1) <> '0') then Continue;

      StrToMySamHead(sReadBuff);

//      if Trim(MySamHeadRec.BrnCode) <> sFirstBrnCode then
//      begin
//        gf_RollBackTransaction;
//        sMsg := gwImportErrMsg + gwClickOKMsg + // Import �� ���� �߻�! Ȯ�� ��ư�� �����ֽʽÿ�.
//          '(' + gwErrLineNo + IntToStr(iIndex + 1) + ')';
//        ErrorProcessPanel(sMsg, True);
//        gf_ShowMessage(MessageBar, mtError, 2020, gwErrLineNo + IntToStr(iIndex + 1)); // �μ��ڵ� ����
//        Exit;
//      end;

      if (Length(sSumBuff + sReadBuff + DATA_DELIMITER) >= iMaxDataSize) then
      begin
//ShowMessage('@in_DeptUserID - ' + gvDeptCode + gvOprUsrNo + #13#10
//	+'@in_str_seq - ' + IntToStr(iStartSeqNo) + #13#10
//	+'@in_cnt - ' + IntToStr(iDataCnt) + #13#10
//	+'@in_delimiter - ' + DATA_DELIMITER);
//ShowMessage('[' + sSumBuff +']');

        // ��Ŷ�� �� ���� SP ȣ�� ó��.
        DataModule_SettleNet.ADOSP_SP0100_2.Parameters.ParamByName('@in_DeptUserID').Value := gvDeptCode + gvOprUsrNo;
        DataModule_SettleNet.ADOSP_SP0100_2.Parameters.ParamByName('@in_str_seq').Value := iStartSeqNo;
        DataModule_SettleNet.ADOSP_SP0100_2.Parameters.ParamByName('@in_cnt').Value := iDataCnt;
        DataModule_SettleNet.ADOSP_SP0100_2.Parameters.ParamByName('@in_delimiter').Value := DATA_DELIMITER;
        DataModule_SettleNet.ADOSP_SP0100_2.Parameters.ParamByName('@in_data').Value := sSumBuff;
        sSumBuff := '';
        
        try
          Application.ProcessMessages;
          DataModule_SettleNet.ADOSP_SP0100_2.Execute;

          if Trim(DataModule_SettleNet.ADOSP_SP0100_2.Parameters.ParamByName('@out_rtc').Value) <> '' then
          begin
            gf_RollBackTransaction;
            gf_ShowErrDlgMessage(Self.Tag, 1031, //Database ����
              'ADOSP_SP0100_2: ' + Trim(DataModule_SettleNet.ADOSP_SP0100_2.Parameters.ParamByName('@out_kor_msg').Value), 0);
            sMsg := gwImportErrMsg + gwClickOKMsg; // Import �� ���� �߻�! Ȯ�� ��ư�� �����ֽʽÿ�.
            ErrorProcessPanel(sMsg, True);
            gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_SP0100_2'); //Import�� �����߻�
            Exit;
          end;

        except
          on E: Exception do
          begin
            gf_RollBackTransaction;
            gf_ShowErrDlgMessage(Self.Tag, 1031, 'ADOSP_SP0100_2: ' + E.Message, 0);
            sMsg := gwImportErrMsg + gwClickOKMsg; // Import �� ���� �߻�! Ȯ�� ��ư�� �����ֽʽÿ�.
            ErrorProcessPanel(sMsg, True);
            gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_SP0100_2'); //Import�� �����߻�
            Exit;
          end;
        end;
        
        iStartSeqNo := iStartSeqNo + iDataCnt;
        iDataCnt := 0;
        sSumBuff := '';
      end;
      
      // �ڷ� ����.
      sSumBuff := sSumBuff + sReadBuff + DATA_DELIMITER;
      inc(iDataCnt, 1);
    end; //end For

     //������ �ڷ� Call
    if iDataCnt > 0 then // ó�� Data ����
    begin

//ShowMessage('[L]@in_DeptUserID - ' + gvDeptCode + gvOprUsrNo + #13#10
//	+'@in_str_seq - ' + IntToStr(iStartSeqNo) + #13#10
//	+'@in_cnt - ' + IntToStr(iDataCnt) + #13#10
//	+'@in_delimiter - ' + DATA_DELIMITER);
//ShowMessage('[' + sSumBuff +']');

      DataModule_SettleNet.ADOSP_SP0100_2.Parameters.ParamByName('@in_DeptUserID').Value := gvDeptCode + gvOprUsrNo;
      DataModule_SettleNet.ADOSP_SP0100_2.Parameters.ParamByName('@in_str_seq').Value := iStartSeqNo;
      DataModule_SettleNet.ADOSP_SP0100_2.Parameters.ParamByName('@in_cnt').Value := iDataCnt;
      DataModule_SettleNet.ADOSP_SP0100_2.Parameters.ParamByName('@in_delimiter').Value := DATA_DELIMITER;
      DataModule_SettleNet.ADOSP_SP0100_2.Parameters.ParamByName('@in_data').Value := sSumBuff;
      sSumBuff := '';
      
      try
        Application.ProcessMessages;
        DataModule_SettleNet.ADOSP_SP0100_2.Execute;

        if Trim(DataModule_SettleNet.ADOSP_SP0100_2.Parameters.ParamByName('@out_rtc').Value) <> '' then
        begin
          gf_RollBackTransaction;
          gf_ShowErrDlgMessage(Self.Tag, 1031, //Database ����
            'ADOSP_SP0100_2: ' + Trim(DataModule_SettleNet.ADOSP_SP0100_2.Parameters.ParamByName('@out_kor_msg').Value), 0);
          sMsg := gwImportErrMsg + gwClickOKMsg; // Import �� ���� �߻�! Ȯ�� ��ư�� �����ֽʽÿ�.
          ErrorProcessPanel(sMsg, True);
          gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_SP0100_2'); //Import�� �����߻�
          Exit;
        end;

      except
        on E: Exception do
        begin
          gf_RollBackTransaction;
          gf_ShowErrDlgMessage(Self.Tag, 1031, 'ADOSP_SP0100_2: ' + E.Message, 0);
          sMsg := gwImportErrMsg + gwClickOKMsg; // Import �� ���� �߻�! Ȯ�� ��ư�� �����ֽʽÿ�.
          ErrorProcessPanel(sMsg, True);
          gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_SP0100_2'); //Import�� �����߻�
          Exit;
        end;
      end;
        
      iStartSeqNo := iStartSeqNo + iDataCnt;
      iDataCnt := 0;
      sSumBuff := '';
    end; //������ �ڷ� Call
  end; // if �׸��忡 �ŸŰ� �ִٸ� ...

  //--------------------
  gf_CommitTransaction;
  //--------------------

   //----------------------------------------------------------------------------
   // 4. ���� Import  SP CALL
   //----------------------------------------------------------------------------

   //----------------------------------------------------------------------------
   // 4.1 ���� ����  Import
   //----------------------------------------------------------------------------
  if DRStrGrid_ImportInfo.Cells[1, IDX_ROW_ACC] <> 'X' then
  begin
    gf_log('[' + IntToStr(Self.Tag) + '] bf Import_AccInfo');
    sMsg := '[���� ����] ' + gwImportMsg; // 'Import ���Դϴ�. ��� ��ٸ��ʽÿ�...'
    ShowProcessPanel(sMsg, DataList.Count);
    if not Import_AccInfo then
    begin
      //gf_RollbackTransaction;
      HideProcessPanel;
      EnableForm;
      Exit;
    end;
  end; // end of if

   //----------------------------------------------------------------------------
   // 4.2 ����ó Import
   //----------------------------------------------------------------------------
  if DRStrGrid_ImportInfo.Cells[1, IDX_ROW_ADDR] <> 'X' then
  begin
    gf_log('[' + IntToStr(Self.Tag) + '] bf Import_AddrInfo');
    sMsg := '[����ó ����] ' + gwImportMsg; // 'Import ���Դϴ�. ��� ��ٸ��ʽÿ�...'
    ShowProcessPanel(sMsg, DataList.Count);
    if not Import_AddrInfo then
    begin
         //gf_RollbackTransaction;
      HideProcessPanel;
      EnableForm;
      Exit;
    end;
  end; // end of if

   //----------------------------------------------------------------------------
   // 4.3 ���� ���� Import
   //----------------------------------------------------------------------------
   if DRStrGrid_ImportInfo.Cells[1, IDX_ROW_RPT] <> 'X' then
   begin
gf_log('['+ IntToStr(Self.Tag) +'] bf Import_RptInfo');
      sMsg := '[���� ����] ' + gwImportMsg; // 'Import ���Դϴ�. ��� ��ٸ��ʽÿ�...'
      ShowProcessPanel(sMsg, DataList.Count);

      sImpFileName := ExtractFileName(DREdit_FileName.Text);

      if not Import_RptInfo(sImpFileName) then
      begin
         //gf_RollbackTransaction;
         HideProcessPanel;
         EnableForm;
         Exit;
      end;
   end;  // end of if

  gf_log('[' + IntToStr(Self.Tag) + '] Done import process');

  HideProcessPanel;
  EnableForm;
  DREdit_FileName.Text := ''; // Clear File Name
  gf_ShowMessage(MessageBar, mtInformation, 1140, ''); // Import �Ϸ�

  Result := True;
end;

procedure TForm_SCFH8201.StrToMySamHead(s: string);
var sValue: string;
  i, iLastPos, iPos: integer;
begin
  i := 0;
  iLastPos := 0;
  iPos := PosEx(#09, s, iLastPos + 1);

  while iPos > 0 do
  begin
    inc(i);
    sValue := copy(s, iLastPos + 1, iPos - iLastPos - 1);

    case i of
      1 : MySamHeadRec.Version  := trim(sValue);
      2 : MySamHeadRec.SecType  := trim(sValue);
      3 : MySamHeadRec.ReportID := trim(sValue);
      4 : MySamHeadRec.CreDate  := trim(sValue);
      5 : MySamHeadRec.CreTime  := trim(sValue);
      6 : MySamHeadRec.SeqNo    := trim(sValue);
      7 : MySamHeadRec.EmpId    := trim(sValue);
      8 : MySamHeadRec.BrnCode  := trim(sValue);
      9 : MySamHeadRec.AccNo    := trim(sValue);
      10: MySamHeadRec.PrdNo    := trim(sValue);
      11: MySamHeadRec.BlcNo    := trim(sValue);
    end;

    iLastPos := iPos;
    iPos := PosEx(#9, s, iLastPos + 1);
  end;
end;


function TForm_SCFH8201.Import_AccInfo: boolean;
begin
  Result := False;

  with DataModule_SettleNet do
  begin
    //----------------------------------------------------------------------------
    // Real Import Stored Procedure Call
    //----------------------------------------------------------------------------
    ADOSP_SP8201_1.Parameters.ParamByName('@in_DeptUserID').Value := gvDeptCode + gvOprUsrNo;
    ADOSP_SP8201_1.Parameters.ParamByName('@in_DeptCode').Value := gvDeptCode;

    try
      Application.ProcessMessages;
      ADOSP_SP8201_1.Execute;

      if Trim(ADOSP_SP8201_1.Parameters.ParamByName('@out_rtc').Value) <> '' then
      begin
        gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_Import'); //Import�� �����߻�
        gf_ShowErrDlgMessage(Self.Tag, 1031, 'ADOSP_Import [���� ����]: ' +
          Trim(ADOSP_SP8201_1.Parameters.ParamByName('@out_kor_msg').Value), 0);
        Exit;
      end;

      if Trim(ADOSP_SP8201_1.Parameters.ParamByName('@RETURN_VALUE').Value) <> '1' then
      begin
        gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_Import'); //Import�� �����߻�
        gf_ShowErrDlgMessage(Self.Tag, 1031, 'ADOSP_Import[���� ����]: �˼����� ����', 0);
        Exit;
      end;

    except
      on E: Exception do
      begin
        gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_Import'); //Import�� �����߻�
        gf_ShowErrDlgMessage(Self.Tag, 1031, 'ADOSP_Import[���� ����]: ' + E.Message, 0);
        Exit;
      end;
    end;
  end; // with DataModule_SettleNet do

  Result := True;
end;


procedure TForm_SCFH8201.DRButton2Click(Sender: TObject);
begin
  inherited;
  gf_log('[' + IntToStr(Self.Tag) + '] ����ڰ� ���� ���� �����Ͽ� Import����');
  if not StartImportLock then
  begin
    HideProcessPanel;
    EnableForm;
    Exit;
  end;

  gf_log('[' + IntToStr(Self.Tag) + '] BF ImportMain');
  ImportMain;
  gf_log('[' + IntToStr(Self.Tag) + '] BF EndImportLock');
  EndImportLock;
end;

procedure TForm_SCFH8201.DRSpeedBtn_UnlockClick(Sender: TObject);
var
  iCNT: integer;
begin
  inherited;

  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    iCNT := StrToInt(gf_ReturnStrQuery('SELECT STR = COUNT(DEPT_CODE) FROM SCILOCK_TBL ' +
      'WHERE DEPT_CODE = ''' + gvDeptCode + ''' ' +
      '  and S_DATE <> '''' AND E_DATE = '''' '));
    if iCNT < 1 then
    begin
      gf_ShowMessage(MessageBar, mtError, 0, 'Lock ���� ����� �����ϴ�.'); // �ش� ������ �������� �ʽ��ϴ�.
      Exit;
    end;

  end;

  // Confirm - ����Ʈ ���� ����
  if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 0, '����Ʈ ���� �����Ͻðڽ��ϱ�?', mbOKCancel, 0) = idcancel then
  begin
    gf_ShowMessage(MessageBar, mtInformation, 1082, ''); // �۾��� ��ҵǾ����ϴ�.
    Exit;
  end;

  DisableForm;

  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('DELETE SCILOCK_TBL');
    SQL.Add('WHERE DEPT_CODE = ''' + gvDeptCode + ''' ');
  end;

  try
    gf_ADOExecSQL(ADOQuery_Temp);
  except
    on E: Exception do
    begin
      gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_TEMP[SCILOCK_TBL :INSERT]: ' + E.Message, 0);
      gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_TEMP[SCILOCK_TBL : INSERT]'); // Database ����
      EnableForm;
      Exit;
    end;
  end;
  EnableForm;
  gf_ShowMessage(MessageBar, mtInformation, 1016, ''); // ó�� �Ϸ�
end;

procedure TForm_SCFH8201.DRSpeedBtn_FileOpenClick(Sender: TObject);
begin
  inherited;
  ImportFileOpen(True, '');
end;

function TForm_SCFH8201.Import_AddrInfo: boolean;
begin
  Result := False;

  with DataModule_SettleNet do
  begin
    //----------------------------------------------------------------------------
    // Real Import Stored Procedure Call
    //----------------------------------------------------------------------------
    ADOSP_SP8201_2.Parameters.ParamByName('@in_DeptUserID').Value := gvDeptCode + gvOprUsrNo;
    ADOSP_SP8201_2.Parameters.ParamByName('@in_DeptCode').Value := gvDeptCode;

    try
      Application.ProcessMessages;
      ADOSP_SP8201_2.Execute;

      if Trim(ADOSP_SP8201_2.Parameters.ParamByName('@out_rtc').Value) <> '' then
      begin
        gf_ShowMessage(MessageBar, mtError, 1031, 'Import_AddrInfo'); //Import�� �����߻�
        gf_ShowErrDlgMessage(Self.Tag, 1031, 'Import_AddrInfo [����ó ����]: ' +
          Trim(ADOSP_SP8201_2.Parameters.ParamByName('@out_kor_msg').Value), 0);
        Exit;
      end;

      if Trim(ADOSP_SP8201_2.Parameters.ParamByName('@RETURN_VALUE').Value) <> '1' then
      begin
        gf_ShowMessage(MessageBar, mtError, 1031, 'Import_AddrInfo'); //Import�� �����߻�
        gf_ShowErrDlgMessage(Self.Tag, 1031, 'Import_AddrInfo[����ó ����]: �˼����� ����', 0);
        Exit;
      end;

    except
      on E: Exception do
      begin
        gf_ShowMessage(MessageBar, mtError, 1031, 'Import_AddrInfo'); //Import�� �����߻�
        gf_ShowErrDlgMessage(Self.Tag, 1031, 'Import_AddrInfo[����ó ����]: ' + E.Message, 0);
        Exit;
      end;
    end;
  end; // with DataModule_SettleNet do

  Result := True;
end;

procedure TForm_SCFH8201.DRButton_Rpt_ImportClick(Sender: TObject);
begin
  inherited;

  if gvHostCallUseYN <> 'Y' then
  begin
    //gf_ShowErrDlgMessage(Self.Tag,0,'����(CICS)�� ������ �� �����ϴ�. CICSUseYN = N, �����ͷε�� ���ǹٶ��ϴ�.',0);
    gf_ShowErrDlgMessage(Self.Tag, 0, '����(MCA)�� ������ �� �����ϴ�. �����ͷε�� ���ǹٶ��ϴ�.', 0);
    Exit;
  end;

  if not StartImportLock then Exit;

  MCAImport('R');

  EndImportLock;
end;

function TForm_SCFH8201.ImpRptInfoCheck(var sAccList: string): boolean;
begin
  Result := False;

  sAccList := '';

  // ���¹�ȣ Ȯ��
  if DRRadioButton_Rpt_AccNo.Checked then
  begin
    if (Length(Trim(DREdit_Rpt_AccNo.Text)) <> 8) then
    begin
      gf_ShowMessage(MessageBar, mtError, 0, '���¹�ȣ�� �߸��Ǿ����ϴ�.');
      DREdit_Rpt_AccNo.SetFocus;
      Exit;
    end;
    sAccList := Trim(DREdit_Rpt_AccNo.Text);
  end;

  Result := True;
end;

procedure TForm_SCFH8201.DRRadioButton_Acc_AllClick(Sender: TObject);
begin
  inherited;
  if DRRadioButton_Acc_All.Checked then
  begin
    DRMaskEdit_Acc_CreDate.Clear;
    DRMaskEdit_Acc_ChgDate.Clear;
    DREdit_Acc_AccNo.Clear;
  end;
end;

procedure TForm_SCFH8201.DRRadioButton_Acc_CreDateClick(Sender: TObject);
begin
  inherited;
  if DRRadioButton_Acc_CreDate.Checked then
  begin
    DRMaskEdit_Acc_ChgDate.Clear;
    DREdit_Acc_AccNo.Clear;
  end;
end;

procedure TForm_SCFH8201.DRRadioButton_Acc_ChgDateClick(Sender: TObject);
begin
  inherited;
  if DRRadioButton_Acc_ChgDate.Checked then
  begin
    DRMaskEdit_Acc_CreDate.Clear;
    DREdit_Acc_AccNo.Clear;
  end;
end;

procedure TForm_SCFH8201.DRRadioButton_Acc_AccNoClick(Sender: TObject);
begin
  inherited;
  if DRRadioButton_Acc_AccNo.Checked then
  begin
    DRMaskEdit_Acc_CreDate.Clear;
    DRMaskEdit_Acc_ChgDate.Clear;
  end;
end;

procedure TForm_SCFH8201.DRRadioButton_Rpt_NewClick(Sender: TObject);
begin
  inherited;
  if DRRadioButton_Rpt_New.Checked then
  begin
    DREdit_Rpt_AccNo.Clear;
  end;
end;

procedure TForm_SCFH8201.DRMaskEdit_Acc_CreDateChange(Sender: TObject);
begin
  inherited;
  DRRadioButton_Acc_CreDate.Checked;
end;

procedure TForm_SCFH8201.DRMaskEdit_Acc_ChgDateChange(Sender: TObject);
begin
  inherited;
  DRRadioButton_Acc_ChgDate.Checked;
end;

procedure TForm_SCFH8201.DREdit_Acc_AccNoChange(Sender: TObject);
begin
  inherited;
  DRRadioButton_Acc_AccNo.Checked;
end;

procedure TForm_SCFH8201.DREdit_Rpt_AccNoChange(Sender: TObject);
begin
  inherited;
  DRRadioButton_Rpt_AccNo.Checked;
end;

function TForm_SCFH8201.Import_RptInfo(pFileName: string): boolean;
begin
  Result := False;

  with DataModule_SettleNet do
  begin
    //----------------------------------------------------------------------------
    // Real Import Stored Procedure Call
    //----------------------------------------------------------------------------
    ADOSP_SP8201_3.Parameters.ParamByName('@in_DeptUserID').Value  := gvDeptCode + gvOprUsrNo;
    ADOSP_SP8201_3.Parameters.ParamByName('@in_DeptCode').Value    := gvDeptCode;
    ADOSP_SP8201_3.Parameters.ParamByName('@in_ImpFileName').Value := pFileName;

    try
      Application.ProcessMessages;
      ADOSP_SP8201_3.Execute;

      if Trim(ADOSP_SP8201_3.Parameters.ParamByName('@out_rtc').Value) <> '' then
      begin
        gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_Import'); //Import�� �����߻�
        gf_ShowErrDlgMessage(Self.Tag, 1031, 'ADOSP_Import [���� ����]: ' +
          Trim(ADOSP_SP8201_3.Parameters.ParamByName('@out_kor_msg').Value), 0);
        Exit;
      end;

      if Trim(ADOSP_SP8201_3.Parameters.ParamByName('@RETURN_VALUE').Value) <> '1' then
      begin
        gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_Import'); //Import�� �����߻�
        gf_ShowErrDlgMessage(Self.Tag, 1031, 'ADOSP_Import[���� ����]: �˼����� ����', 0);
        Exit;
      end;

    except
      on E: Exception do
      begin
        gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_Import'); //Import�� �����߻�
        gf_ShowErrDlgMessage(Self.Tag, 1031, 'ADOSP_Import[���� ����]: ' + E.Message, 0);
        Exit;
      end;
    end;
  end; // with DataModule_SettleNet do

  Result := True;
end;

procedure TForm_SCFH8201.DRBitBtn2Click(Sender: TObject);
begin
  inherited;
  if gvHostCallUseYN <> 'Y' then
  begin
    //gf_ShowErrDlgMessage(Self.Tag,0,'����(CICS)�� ������ �� �����ϴ�. CICSUseYN = N, �����ͷε�� ���ǹٶ��ϴ�.',0);
    gf_ShowErrDlgMessage(Self.Tag, 0, '����(MCA)�� ������ �� �����ϴ�. �����ͷε�� ���ǹٶ��ϴ�.', 0);
    Exit;
  end;

  if not StartImportLock then Exit;

  MCAImport('ALL');

  EndImportLock;
end;

procedure TForm_SCFH8201.FormShow(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  //-- ȭ�� �ʱ�ȭ -------------------------------------------------------------
  // ���� �� ����ó
  DRRadioButton_Acc_ChgDate.Checked := True;
  DRMaskEdit_Acc_ChgDate.Text := gf_GetCurDate;
  DRMaskEdit_Acc_ChgDate.SetFocus;

  // ����
  DRRadioButton_Rpt_New.Checked := True;

  // [TEST]
  DRMaskEdit_Test_Date.Text := gf_GetCurDate;

  // ���� ���� �׸���
  with DRStrGrid_ImportInfo do
  begin
    for i := 1 to RowCount - 1 do
    begin
      Cells[1, i] := 'X';
      Cells[2, i] := 'X';
    end; // for i:=1 to RowCount-1 do
  end; // with DRStringGrid_ImportInfo do
end;

procedure TForm_SCFH8201.FormCreate(Sender: TObject);
begin
  inherited;
  DataList := TStringList.Create;
  if not Assigned(DataList) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); //List ���� ����
    Close;
  end;

  AccList := TStringList.Create;
  if not Assigned(AccList) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); //List ���� ����
    Close;
  end;
end;

end.

