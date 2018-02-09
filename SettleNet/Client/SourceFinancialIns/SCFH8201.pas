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

    function GetImportFileName: string; // Import 파일명 설정.

    // Import 입력사항 체크
    function ImpAccInfoCheck(var sCreDate, sChgDate, sAccList: string): boolean;
    function ImpRptInfoCheck(var sAccList: string): boolean;

    // MCA TR 처리.
    procedure MCAImport(sGubn: string);
    function MCACallAcc(sImportFileName: string): boolean; // 계좌&수신처
    function MCACallRpt(sImportFileName: string): boolean; // 보고서 전문
    function MCACallAccNRpt(sImportFileName: string): boolean; // 계좌&수신처 + 보고서 전문

    // Import 처리
    function MCAImportFileFTPGet(sImportFileName: string): boolean;
    function ImportFileOpen(bManual: boolean; sImportFileName: string): boolean;
    function ImportMain: boolean; // ** 금융상품 Import Main 처리 함수() **
    function Import_AccInfo: boolean;  // 계좌 정보 처리 SP 호출.
    function Import_AddrInfo: boolean; // 수신처 정보 처리 SP 호출.
    function Import_RptInfo(pFileName: string): boolean; // 보고서 전문 처리 SP 호출.


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
  IMPDATA_CNT = 3; // Import 가능 Data 종류 갯수
  IDX_ROW_ACC = 1; // 계좌정보 Index
  IDX_ROW_ADDR = 2; // 수신처 Index
  IDX_ROW_RPT = 3; // 매매 Index

  // 자료구분(보고서ID)
  IMP_RPT_CODE_ACC = '901'; // 계좌 정보
  IMP_RPT_CODE_ADDR = '902'; // 수신처 정보
  IMP_RPT_CODE_RPT = '1'; // 일반 보고서 전문 첫번째자리
  IMP_RPT_CODE_TONG = '0'; // 통발기 보고서 전문 첫번째자리

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
    //gf_ShowErrDlgMessage(Self.Tag,0,'원장(CICS)과 연결할 수 없습니다. CICSUseYN = N, 데이터로드로 문의바랍니다.',0);
    gf_ShowErrDlgMessage(Self.Tag, 0, '원장(MCA)과 연결할 수 없습니다. 데이터로드로 문의바랍니다.', 0);
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

    // 서버에서 임포트할때 주의 (임포트폴더가 settlenet\ImportData 폴더랑 겹치면 ftp 파일 용량 0kb됨 주의
    if (sClientDir = ExpandFileName(ExtractFilePath(Application.ExeName) + '..\..\ImportData')) then
    begin
      gf_ShowMessage(MessageBar, mtError, 0, 'Import 폴더 중복 오류. (데이터로드 문의)');
      Exit;
    end;

    DisableForm;
    sMsg := gwImportMsg + '(자료 생성)'; // Import 중입니다. 잠시 기다리십시요...
    ShowProcessPanel(sMsg, 0);


    gvMCAFtpFileList.Clear;

    // 공통 파일명 생성.
    sImportFileName := GetImportFileName;

    //1.MCA Call : 원장에서 Import File을 만든다
    if sGubn = 'A' then //계좌&수신처
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
    else if sGubn = 'R' then // 보고서 전문
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
    else //계좌, 매매 모두 ALL
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

    sMsg := gwImportMsg + '(File Download)'; // Import 중입니다. 잠시 기다리십시요...
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
// Import 락 설정.
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

  //0.SCILOCK에 해당 부서 Record가 없으면 하나 만듬.
  sSQL := ' select CNT=count(*) from SCILOCK_TBL '
    + ' where DEPT_CODE = ''' + gvDeptCode + ''' ';

  if gf_CountQuery(sSQL) <= 0 then
  begin
    sSQL := ' insert into SCILOCK_TBL ( DEPT_CODE, OPR_ID, S_DATE, S_TIME, E_DATE, E_TIME, LOCK_TIME) '
      + ' values ( ''' + gvDeptCode + ''','''','''','''','''','''','''') ';
    if not gf_ExecQuery(sSQL) then Exit;
  end;

  //1.Lock 걸기
  gf_BeginTransaction;

  sSQL := ' update SCILOCK_TBL '
    + ' set LOCK_TIME = ''' + gf_GetCurTime + ''' '
    + ' where DEPT_CODE = ''' + gvDeptCode + ''' ';

  if not gf_ExecQuery(sSQL) then
  begin
    gf_RollbackTransaction;
    Exit;
  end;

  //2.현재 진행중인 Import 정보
  sSQL := ' select STR = isnull(max(OPR_ID),'''') from SCILOCK_TBL '
    + ' where DEPT_CODE = ''' + gvDeptCode + ''' '
    + ' and   E_TIME = '''' '
    + ' and   OPR_ID > '''' ';

  sID := gf_ReturnStrQuery(sSQL);

  if sID > '' then //현재 Import중인 사람이 있다.
  begin
    sSQL := ' select CNT= datediff(second,convert(datetime,S_DATE + space(1) + substring(S_TIME,1,2) + '':''  + substring(S_TIME,3,2) + '':''  + substring(S_TIME,5,2),121),getdate()) '
      + ' from SCILOCK_TBL '
      + ' where DEPT_CODE = ''' + gvDeptCode + ''' ';

    iImportingSeconds := gf_CountQuery(sSQL);
    iTimeOut := StrToInt(gf_GetSystemOptionValue('HI6', '8')) * 60; //System Option : Timeout Minute가져오기. Default 8분

    iMin := Trunc(iImportingSeconds / 60);
    iSec := iImportingSeconds - (iMin * 60);

    if iTimeOut < iImportingSeconds then //다른 사용자가 Import Timeout을 초과했다. 즉,정해진 Import한도 시간(ex.8분)을 초과한 경우
    begin
      //timeout을 초과했으니 목숨걸고 Import할래?
      if gf_ShowDlgMessage(Self.Tag, mtError, 0,
        '현재 사용자 ' + sID + '가 Import중입니다. 경과시간(' + IntToStr(iMin) + '분' + IntToStr(iSec) + '초).' + #13#10
        + '동시에 Import시 자료 오류가 발생할 수 있습니다. ' + #13#10 + #13#10
        + '그래도 Import하시겠습니까?'
        , [mbYes, mbCancel], 0) = idCancel then
      begin
        gf_RollbackTransaction;
        Exit;
      end;
      //그래도 Import하겠다는 뜻...!
    end
    else //아직 Import Timeout을 초과하지 않았고, Import진행중이라고 판단하고 절대 Import시키지 않는다.
    begin
      gf_ShowErrDlgMessage(Self.Tag, 0,
        '현재 사용자 ' + sID + '가 Import중입니다. 경과시간(' + IntToStr(iMin) + '분' + IntToStr(iSec) + '초).' + #13#10
        + '잠시후 다시 Import 시도하십시오.'
        , 0);
      gf_RollbackTransaction;
      Exit;
    end;
  end;

  //3. Import Lock 걸기, 내가 사용중이당.
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
// Import 락 해제.
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
//  MCA 원장 계좌 임포트
//------------------------------------------------------------------------------

function TForm_SCFH8201.MCACallAcc(sImportFileName: string): boolean;
var
  sCreDate, sChgDate, sAccList: string;
  sMsg: string;
begin
  Result := false;
  if not ImpAccInfoCheck(sCreDate, sChgDate, sAccList) then Exit;

  // 파일 생성갯수 카운트
  gvMCAFileCnt := 0;

  //----------------------------------------------------------------------------
  // Connect MCA
  //----------------------------------------------------------------------------
  if not gf_tf_HostMCAConnect(False, sMsg) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 0, 'MCA 접속 에러.'
      + #13#10 + #13#10 + sMsg, 0);
    Exit;
  end;

  gf_log('[' + IntToStr(Self.Tag) + '] Bf gf_tf_HostMCAsngetZACInfo[계좌정보]');
  if not gf_tf_HostMCAsngetZACInfo(sCreDate, sChgDate, sAccList, sImportFileName, sMsg) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 0,
      '원장에서 계좌 Import 파일 생성중 오류(MCA)'
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

  // 파일 생성갯수 카운트
  gvMCAFileCnt := 0;

  //----------------------------------------------------------------------------
  // Connect MCA
  //----------------------------------------------------------------------------
  if not gf_tf_HostMCAConnect(False, sMsg) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 0, 'MCA 접속 에러.'
      + #13#10 + #13#10 + sMsg, 0);
    Exit;
  end;

  gf_log('[' + IntToStr(Self.Tag) + '] Bf gf_tf_HostMCAsngetZRPTInfo[보고서 전문]');
  // !! 보고서 전문은 당일 내역만 처리한다.
  if not gf_tf_HostMCAsngetZRPTInfo(gvCurDate, sAccList, sImportFileName, sMsg) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 0,
      '원장에서 보고서 전문 Import 파일 생성중 오류(MCA)'
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

  // 파일 생성갯수 카운트
  gvMCAFileCnt := 0;

  //----------------------------------------------------------------------------
  // Connect MCA
  //----------------------------------------------------------------------------
  if not gf_tf_HostMCAConnect(False, sMsg) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 0, 'MCA 접속 에러.'
      + #13#10 + #13#10 + sMsg, 0);
    Exit;
  end;

  //-- 계좌&수신처 -------------------------------------------------------------
  if not ImpAccInfoCheck(sCreDate, sChgDate, sAccList) then Exit;

  gf_log('[' + IntToStr(Self.Tag) + '] Bf gf_tf_HostMCAsngetZACInfo[계좌정보]');
  if not gf_tf_HostMCAsngetZACInfo(sCreDate, sChgDate, sAccList, sImportFileName, sMsg) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 0,
      '원장에서 계좌 Import 파일 생성중 오류(MCA)'
      + #13#10 + #13#10 + sMsg, 0);
    Exit;
  end;

  //-- 보고서 전문 -------------------------------------------------------------
  if not ImpRptInfoCheck(sAccList) then Exit;

  gf_log('[' + IntToStr(Self.Tag) + '] Bf gf_tf_HostMCAsngetZRPTInfo[보고서 전문]');
  // !! 보고서 전문은 당일 내역만 처리한다.
  if not gf_tf_HostMCAsngetZRPTInfo(gvCurDate, sAccList, sImportFileName, sMsg) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 0,
      '원장에서 보고서 전문 Import 파일 생성중 오류(MCA)'
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

  // 개설 일자 확인
  if DRRadioButton_Acc_CreDate.Checked then
  begin
    sCreDate := Trim(DRMaskEdit_Acc_CreDate.Text);
    if (sCreDate = '') or
      (gf_CheckValidDate(sCreDate) = False) then
    begin
      gf_ShowMessage(MessageBar, mtError, 1040, ''); //일자 입력 오류
      DRMaskEdit_Acc_CreDate.SetFocus;
      sCreDate := '';
      Exit;
    end;
  end else
  // 변경 일자 확인
    if DRRadioButton_Acc_ChgDate.Checked then
    begin
      sChgDate := Trim(DRMaskEdit_Acc_ChgDate.Text);
      if (sChgDate = '') or
        (gf_CheckValidDate(sChgDate) = False) then
      begin
        gf_ShowMessage(MessageBar, mtError, 1040, ''); //일자 입력 오류
        DRMaskEdit_Acc_ChgDate.SetFocus;
        sChgDate := '';
        Exit;
      end;
    end else
  // 계좌번호 확인
      if DRRadioButton_Acc_AccNo.Checked then
      begin
        if (Length(Trim(DREdit_Acc_AccNo.Text)) <> 8) then //DRLabel_AAccName.Caption = ''
        begin
          gf_ShowMessage(MessageBar, mtError, 0, '계좌번호가 잘못되었습니다.');
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

    // FTP 접속 IP
    sFTPMode := gvMCAFileFtpMode;
    // FTP 접속 IP
    sIP := gvMCAFileFtpIP;
    // FTP 접속 Port
    iPort := gvMCAFileFtpPort;
    // FTP 접속 ID
    sID := gvMCAFileFtpID;
    // FTP 접속 PASSWD
    sPW := gvMCAFileFtpPW;
    // FTP 접속 경로
    sFTPPath := gvMCAFileFtpPath;

    if (sIP = '') or (sID = '') or (sPW = '') then
    begin
      gf_ShowErrDlgMessage(Self.Tag, 0, 'FTP설정정보가 없습니다.', 0);
      gf_ShowMessage(MessageBar, mtError, 0, 'Import 오류: FTP');
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
          gf_Log(Self.Name + '[FTP] 처리 시작. ');

          IdFtp1.Intercept := IdLogEvent1;

          if not IdFTP1.Connected then
          begin
            Username := sID;
            Password := sPW;
            Host := sIP;
            Connect;
          end;
          gf_Log(Self.Name + '[FTP] 서버 접속 완료. (' + sIP + ',' + IntToStr(iPort));

          TransferType := ftASCII;

          // FTP서버에 생성된 파일 가져오기
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
            gf_Log(Self.Name + '[FTP] 서버 대상 파일 받기 완료. ' + sGetFileName);

            // 각각의 파일 리스트에 저장
            slPartFileList.LoadFromFile(sClientDir + '\' + sGetFileName);
            // 각각의 리스트를 통합 리스트에 저장
            slMergeFileList.AddStrings(slPartFileList);
            // 리스트에 저장된 파일 삭제
            if FileExists(sClientDir + '\' + sGetFileName) then
            begin
              DeleteFile(sClientDir + '\' + sGetFileName);
            end;
          end; // for i:=0 to gvMCAFtpFileList.Count-1 do
          // FTP 접속 종료
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
        gf_Log(Self.Name + ' [SFTP] 처리 시작.');

        // Component Initialize
        sFTP := TChilkatsFTP.Create(Self);
        if sFTP.UnlockComponent('DATAROSSH_NOCXOD3U7ExX') <> 1 then
        begin
          gf_Log(Self.Name + ' [SFTP] 컴퍼넌트 초기화 Err. ' + sFTP.LastErrorText);
          exit;
        end;
        //  Set some timeouts, in milliseconds:
        sFTP.ConnectTimeoutMs := 5000;
        sFTP.IdleTimeoutMs := 10000;
        sFTP.MaxPacketSize := 0;

        // FTP Connect
        if sFTP.Connect(sIP, iPort) <> 1 then
        begin
          gf_Log(Self.Name + ' [SFTP] 서버 연결 Err. ' + sFTP.LastErrorText);
          exit;
        end;

        // FTP Login
        if sFTP.AuthenticatePw(sID, sPW) <> 1 then
        begin
          gf_Log(Self.Name + ' [SFTP] 서버 로그인 Err. ' + sFTP.LastErrorText);
          exit;
        end;

        //  After authenticating, the SFTP subsystem must be initialized:
        if sFTP.InitializeSftp() <> 1 then
        begin
          gf_Log(Self.Name + ' [SFTP] 서버 안정화 Err. ' + sFTP.LastErrorText);
          exit;
        end;

        // 경로 설정
        if (Trim(sFTPPath) <> '') then
        begin
          sPathHandle := sFTP.OpenDir(sFTPPath);
          if (Length(sPathHandle) = 0) then
          begin
            gf_Log(Self.Name + ' [SFTP] 서버 경로 설정 Err. ' + sFTP.LastErrorText);
            Exit;
          end;
        end;
        gf_Log(Self.Name + ' [SFTP] 서버 접속 완료. (' + sIP + ',' + IntToStr(iPort));

        // FTP서버에 생성된 파일 가져오기
        for i := 0 to gvMCAFtpFileList.Count - 1 do
        begin
          sGetFileName := Trim(gvMCAFtpFileList.Strings[i]);

          //  Open a file on the server:
          sFileHandle := sFTP.OpenFile(sGetFileName, 'readOnly', 'openExisting');
          if (Length(sFileHandle) = 0) then
          begin
            gf_Log(Self.Name + ' [SFTP] 서버 대상 파일 연결 Err. ' + sftp.LastErrorText);
            Exit;
          end;

          //  Download the file:
          if (sftp.DownloadFile(sFileHandle, sClientDir + '\' + sGetFileName) <> 1) then
          begin
            gf_Log(Self.Name + ' [SFTP] 서버 대상 파일 받기 Err. ' + sftp.LastErrorText);
            Exit;
          end;

          //  Close the file.
          if (sftp.CloseHandle(sFileHandle) <> 1) then
          begin
            gf_Log(Self.Name + ' [SFTP] 서버 대상 파일 연결 해제 Err. ' + sftp.LastErrorText);
            Exit;
          end;
          gf_Log(Self.Name + ' [SFTP] 서버 대상 파일 받기 완료. ' + sGetFileName);

          // 각각의 파일 리스트에 저장
          slPartFileList.LoadFromFile(sClientDir + '\' + sGetFileName);
          // 각각의 리스트를 통합 리스트에 저장
          slMergeFileList.AddStrings(slPartFileList);
          // 리스트에 저장된 파일 삭제
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
          gf_Log(Self.Name + ' [SFTP] 처리 종료.');
        end;
      end;
    end;

    // 통합된 파일 저장
    slMergeFileList.SaveToFile(sClientDir + '\' + sImportFileName);

    gf_Log(Self.Name + ' 통합 파일: ' + sClientDir + '\' + sImportFileName);

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

   //--- 파일 선택 (Ini에서 Defualt Dir 읽어오기, 선택 후 저장)
  sDirName := gf_ReadFormStrInfo(Self.Name, 'Default Dir', gvDirImport);
  if DirectoryExists(sDirName) then
    DROpenDialog_Import.InitialDir := sDirName
  else
    DROpenDialog_Import.InitialDir := gvDirImport;


  if bManual then //사용자가 직접 파일 선택시 파일 Open 창을 띄움
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
  end else //원장 호출 처리시 자동으로 파일을 선택함.
  begin
    DREdit_FileName.Text := DROpenDialog_Import.InitialDir + '\' + sImportFileName; // 경로수정
  end;

  sFileName := Trim(DREdit_FileName.Text);

  if sFileName = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1034, ''); //파일을 선택하십시요.
    Exit;
  end;

  if FindFirst(sFileName, faAnyFile, SearchRec) <> 0 then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 1027, DREdit_FileName.Text, 0); //List 생성 오류
    gf_ShowMessage(MessageBar, mtError, 1027, ''); // 해당 파일이 존재하지 않습니다.
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
    DRStrGrid_ImportInfo.Cells[1, iIndex] := 'X'; // 포함여부 clear
    DRStrGrid_ImportInfo.Cells[2, iIndex] := 'X'; // 자료갯수 clear
  end; // end of for

  for iIndex := 0 to IMPDATA_CNT - 1 do iDataCnt[iIndex] := 0;

  if DRRichEdit_File.Lines.Count <= 0 then
  begin
    gf_ShowMessage(MessageBar, mtError, 0, '대상자료가 존재하지 않습니다.'); // 해당 내역이 없습니다.
    Screen.Cursor := crDefault;
    Exit;
  end;

  AssignFile(fTextFile, sFileName);
{$I-}
  Reset(fTextFile);
{$I+}
  if IOResult <> 0 then
  begin
    gf_ShowMessage(MessageBar, mtError, 1027, ''); //해당 파일이 존재하지 않습니다.
    CloseFile(fTextFile);
    Screen.Cursor := crDefault;
    Exit;
  end;

   //--- DataList 생성
  DataList.Clear;
  while not Eof(fTextFile) do
  begin
    Readln(fTextFile, sReadBuff); // 파일에서 한 줄 읽어와 sReadBuff 에 저장.

    if Trim(sReadBuff) <> '' then
    begin
      iSamHdrSize := SizeOf(MySamHeadRec);
      StrToMySamHead(sReadBuff);
//        MoveDataChar(@MySamHeadRec, sReadBuff, iSamHdrSize);

        // 금융상품 자료일 경우 처리.
      if (MySamHeadRec.SecType = gcSEC_FINANCIALINS) then
      begin
          // 종목명에 깨진문자가 들어오는 경우에 데이터를 잘라오는데 문제 발생
          // � 문자를 Space로 대치시키므로서 Import 오류 방지!
        DataList.Add(StringReplace(StringReplace(sReadBuff, '� ', '  ', [rfReplaceAll]), #159, ' ', [rfReplaceAll]));
      end;
    end;
  end; // end of while
  CloseFile(fTextFile);

   //--- Assign 자료정보
  for iIndex := 0 to DataList.Count - 1 do
  begin
    StrToMySamHead(Trim(DataList.Strings[iIndex]));
      //MoveDataChar(@MySamHeadRec, DataList.Strings[iIndex], SizeOf(MySamHeadRec));

    if (Copy(MySamHeadRec.Version, 1, 1) <> 'T') or (MySamHeadRec.SecType <> gcSEC_FINANCIALINS) then
    begin
      gf_ShowMessage(MessageBar, mtError, 9005,
        gwErrLineNo + IntToStr(iIndex + 1) + '(업무구분)'); // 데이터 오류
      Screen.Cursor := crDefault;
      Exit;
    end;

    if iIndex = 0 then // 자료 생성 일자 처리 (SUIMLOG_TLB의 SEC_DATE_
    begin
      sBaseDate := Trim(MySamHeadRec.CreDate);
      DRLabel_BaseDate.Caption := gf_FormatDate(sBaseDate);
      sBaseDate := '$$'; //매매자료의 매매일을 MaskEdit_TradeDate 에 넣기 위함. 왜냐? 수작업으로 파일오픈 하여 Import할때 TradeDate와 달라질수 도 있기 때문이다.
    end;

    if (MySamHeadRec.ReportID = IMP_RPT_CODE_ACC) then
    begin
      Inc(iDataCnt[IDX_ROW_ACC - 1]); // 계좌 정보
    end else
    if (MySamHeadRec.ReportID = IMP_RPT_CODE_ADDR) then
    begin
      Inc(iDataCnt[IDX_ROW_ADDR - 1]); // 수신처 정보
    end else
    if (Copy(MySamHeadRec.ReportID, 1, 1) = IMP_RPT_CODE_RPT) or
      (Copy(MySamHeadRec.ReportID, 1, 1) = IMP_RPT_CODE_TONG) then
    begin
      Inc(iDataCnt[IDX_ROW_RPT - 1]); // 보고서 전문 정보
    end else
    begin
      gf_ShowMessage(MessageBar, mtError, 9005,
        gwErrLineNo + IntToStr(iIndex + 1) + '(자료구분)'); //데이터 오류
      Screen.Cursor := crDefault;
      Exit;
    end;
  end; // end For

   //--- Display 자료정보
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

// 금융상품 Import Main 처리 함수()

function TForm_SCFH8201.ImportMain: boolean;
const
  // Data별 DataCount, DataSize
  // 7500 / DATA_SIZE = ? (8000은 SP에서 받아줄수있는 MAX SIZE, 500은 Argument를 위해)

  MAX_DATA_CNT = 4;

  //계좌 =======================================================================
  DATA_CNT_ACC = 39;
  DATA_SIZE_ACC = 190;

  // 수신처 ====================================================================
  DATA_CNT_ADDR = 13;
  DATA_SIZE_ADDR = 560;

  // 보고서 전문 ===============================================================
  DATA_SIZE_RPT   = 7500; // 최대 길이로 담기.
  DATA_DELIMITER  = '|'; // 줄바꿈 구분자

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
    gf_ShowMessage(MessageBar, mtError, 1034, ''); // 파일을 선택하십시요.
    Exit;
  end;

  if DataList.Count <= 0 then
  begin
    HideProcessPanel;
    EnableForm;
    gf_ShowMessage(MessageBar, mtError, 0, '대상 자료가 존재하지 않습니다.');
    Exit;
  end;

  sReadBuff := DataList.Strings[0];

//  if (Copy(sReadBuff, 6, 1) <> gcSEC_FINANCIALINS) then
//  begin
//    HideProcessPanel;
//    EnableForm;
//    gf_ShowMessage(MessageBar, mtError, 9005, '업무구분이 잘못되었습니다. (' + Copy(sReadBuff, 5, 1) + ')');
//    Exit;
//  end;

  if (Copy(sReadBuff, 1, 1) <> 'T') then
  begin
    HideProcessPanel;
    EnableForm;
    gf_ShowMessage(MessageBar, mtError, 9005, '지원되지 않는 버전입니다. (' + Copy(sReadBuff, 1, 1) + ') 데이터로드에 문의하십시오.');
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
      gf_ShowMessage(MessageBar, mtError, 9005, '알 수 없는 자료입니다. 자료구분(' + Copy(sReadBuff, 1, 1) + ')');
      Exit;
    end;

  // 부서코드 Check
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
//      'ImportFile의 부서(' + sDeptCode + ')와 사용자 부서(' + gvDeptCode + ')가 다릅니다.');
//    Exit;
//  end;

  DisableForm;
  sMsg := gwImportMsg + '(Insert TempTable)'; // Import 중입니다. 잠시 기다리십시요...
  ShowProcessPanel(sMsg, DataList.Count);

   //--------------------
  gf_Begintransaction;
   //--------------------

   //----------------------------------------------------------------------------
   // SamFile DB Write Stored Procedure Call
   //----------------------------------------------------------------------------

  iStartSeqNo := 1; // SCTEMP_TBL에 Package로 들어가는 첫번째 SeqNo
  iDataCnt := 0; // SCTEMP_TBL에 Package로 들어가는 Data Count
  sSumBuff := '';

  //----------------------------------------
  // 2. 계좌&수신처 정보 SCTEMP_TBL INSERT
  //----------------------------------------
  if (DRStrGrid_ImportInfo.Cells[1, IDX_ROW_ACC] <> 'X') or
    (DRStrGrid_ImportInfo.Cells[1, IDX_ROW_ADDR] <> 'X') then
  begin
    gf_log('[' + IntToStr(Self.Tag) + '] bf 계좌&수신처 정보 SCTEMP_TBL INSERT');
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

      // 보고서 전문은 넘어가기.
      if (copy(sReadBuff, 8, 1) <> '9') then Continue;

      if (Copy(MySamHeadRec.Version, 1, 1) <> 'T') then // or (MySamHeadRec.SecType <> gcSEC_FINANCIALINS)
      begin
        gf_RollBackTransaction;
        sMsg := gwImportErrMsg + gwClickOKMsg + // Import 중 오류 발생! 확인 버튼을 눌러주십시요.
          '(' + gwErrLineNo + IntToStr(iIndex + 1) + ')';
        ErrorProcessPanel(sMsg, True);
        gf_ShowMessage(MessageBar, mtError, 9005, gwErrLineNo + IntToStr(iIndex + 1)); // 데이터 오류
        Exit;
      end;

//      if Trim(MySamHeadRec.BrnCode) <> sFirstBrnCode then
//      begin
//        gf_RollBackTransaction;
//        sMsg := gwImportErrMsg + gwClickOKMsg + // Import 중 오류 발생! 확인 버튼을 눌러주십시요.
//          '(' + gwErrLineNo + IntToStr(iIndex + 1) + ')';
//        ErrorProcessPanel(sMsg, True);
//        gf_ShowMessage(MessageBar, mtError, 2020, gwErrLineNo + IntToStr(iIndex + 1)); // 부서코드 오류
//        Exit;
//      end;

      sReadBuff := MoveDataStr(sReadBuff, iMaxDataSize + 1); // 800 Byte로 보내기 위해
      sSumBuff := sSumBuff + sReadBuff;
      inc(iDataCnt, 1);
      if iDataCnt = iMaxDataCnt then // Package이 채워짐
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
            gf_ShowErrDlgMessage(Self.Tag, 1031, //Database 오류
              'ADOSP_SP0100_1: ' + Trim(DataModule_SettleNet.ADOSP_SP0100_1.Parameters.ParamByName('@out_kor_msg').Value), 0);
            sMsg := gwImportErrMsg + gwClickOKMsg; // Import 중 오류 발생! 확인 버튼을 눌러주십시요.
            ErrorProcessPanel(sMsg, True);
            gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_SP0100_1'); //Import중 오류발생
            Exit;
          end;

        except
          on E: Exception do
          begin
            gf_RollBackTransaction;
            gf_ShowErrDlgMessage(Self.Tag, 1031, 'ADOSP_SP0100_1: ' + E.Message, 0);
            sMsg := gwImportErrMsg + gwClickOKMsg; // Import 중 오류 발생! 확인 버튼을 눌러주십시요.
            ErrorProcessPanel(sMsg, True);
            gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_SP0100_1'); //Import중 오류발생
            Exit;
          end;
        end;

        iStartSeqNo := iStartSeqNo + iDataCnt;
        iDataCnt := 0; // Clear
        sSumBuff := '';
      end; //end if
    end; //end For

     //마지막 자료 Call
    if iDataCnt > 0 then // 처리 Data 있음
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
          gf_ShowErrDlgMessage(Self.Tag, 1031, //Database 오류
            'ADOSP_SP0100_1: ' + Trim(DataModule_SettleNet.ADOSP_SP0100_1.Parameters.ParamByName('@out_kor_msg').Value), 0);
          sMsg := gwImportErrMsg + gwClickOKMsg; // Import 중 오류 발생! 확인 버튼을 눌러주십시요.
          ErrorProcessPanel(sMsg, True);
          gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_SP0100_1'); //Import중 오류발생
          Exit;
        end;

      except
        on E: Exception do
        begin
          gf_RollBackTransaction;
          gf_ShowErrDlgMessage(Self.Tag, 1031, //Database 오류
            'ADOSP_SP0100_1: ' + E.Message, 0);
          sMsg := gwImportErrMsg + gwClickOKMsg; // Import 중 오류 발생! 확인 버튼을 눌러주십시요.
          ErrorProcessPanel(sMsg, True);
          gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_SP0100_1'); //Import중 오류발생
          Exit;
        end;
      end;

      iStartSeqNo := iStartSeqNo + iDataCnt;
      iDataCnt := 0; // Clear
      sSumBuff := '';
    end; // end of for
  end; // 2. 계좌&수신처 정보 SCTEMP_TBL INSERT

  //----------------------------------------
  // 3. 주식매매내역 Temp에 넣는다
  //----------------------------------------
  if DRStrGrid_ImportInfo.Cells[1, IDX_ROW_RPT] <> 'X' then
  begin
    gf_log('[' + IntToStr(Self.Tag) + '] bf 보고서 전문 SCTEMP_TBL INSERT');

    //------------------------------------------------------------------------
    // 기초 자료 체크. (보고서 전문 내역 중 첫번째 줄만 체크한다.)
    //------------------------------------------------------------------------      
    for iIndex:=0 to DataList.Count-1 do
    begin
      sReadBuff := DataList.Strings[iIndex];

      if Trim(sReadBuff) = '' then Continue;

      StrToMySamHead(sReadBuff);
      sSecType := MySamHeadRec.SecType;
      sCreDate := Trim(MySamHeadRec.CreDate);
      sFirstBrnCode := Trim(MySamHeadRec.BrnCode);

      // 보고서 전문이 아니면 넘어가기.
      if (copy(sReadBuff, 8, 1) <> '1') and
        (copy(sReadBuff, 8, 1) <> '0') then Continue;

      if (Copy(MySamHeadRec.Version, 1, 1) <> 'T') then // or (MySamHeadRec.SecType <> gcSEC_FINANCIALINS)
      begin
        gf_RollBackTransaction;
        sMsg := gwImportErrMsg + gwClickOKMsg + // Import 중 오류 발생! 확인 버튼을 눌러주십시요.
          '(' + gwErrLineNo + IntToStr(iIndex + 1) + ')';
        ErrorProcessPanel(sMsg, True);
        gf_ShowMessage(MessageBar, mtError, 9005, gwErrLineNo + IntToStr(iIndex + 1)); // 데이터 오류
        Exit;
      end;

      // 일자 오류 체크
//      if not gf_CheckValidDate(sCreDate) then
//      begin
//        gf_RollBackTransaction;
//        sMsg := gwImportErrMsg + gwClickOKMsg + // Import 중 오류 발생! 확인 버튼을 눌러주십시요.
//          '(' + gwErrLineNo + IntToStr(iIndex + 1) + ')' + ' 일자오류';
//        ErrorProcessPanel(sMsg, True);
//        gf_ShowMessage(MessageBar, mtError, 9005, gwErrLineNo + IntToStr(iIndex + 1) + ' 일자오류'); // 데이터 오류
//        Exit;
//      end;

      // 부서코드 Check
      if not gf_GetGlobalDeptCode(sFirstBrnCode, sDeptCode) then
      begin
        gf_RollBackTransaction;
        sMsg := gwImportErrMsg + gwClickOKMsg + // Import 중 오류 발생! 확인 버튼을 눌러주십시요.
          '(' + gwErrLineNo + IntToStr(iIndex + 1) + ')' + ' 부서오류.';
        ErrorProcessPanel(sMsg, True);
        gf_ShowMessage(MessageBar, mtError, 9005, gwErrLineNo + IntToStr(iIndex + 1) + ' 부서오류.'); // 데이터 오류
        Exit; Exit;
      end; // end of if

//      if sDeptCode <> gvDeptCode then
//      begin
//        gf_RollBackTransaction;
//        sMsg := gwImportErrMsg + gwClickOKMsg + // Import 중 오류 발생! 확인 버튼을 눌러주십시요.
//          '(' + gwErrLineNo + IntToStr(iIndex + 1) + ')' + #13#10 + 'TextFile부서와 사용자부서가 틀림.';
//        ErrorProcessPanel(sMsg, True);
//        gf_ShowMessage(MessageBar, mtError, 9005, gwErrLineNo + IntToStr(iIndex + 1) + ' TextFile부서와 사용자부서가 틀림.'); // 데이터 오류
//        Exit;
//      end;
      sVersion := copy(sReadBuff, 1, 4);

      Break;
    end; // 기초 자료 체크. (보고서 전문 내역 중 첫번째 줄만 체크한다.)

    //------------------------------------------------------------------------
    // 보고서 전문 자료 생성. (계좌&수신처 정보와 분리.)
    //------------------------------------------------------------------------
    sSumBuff := '';
    iMaxDataSize := DATA_SIZE_RPT;
//    iMaxDataCnt := ;

    for iIndex := 0 to DataList.Count - 1 do
    begin
      sReadBuff := DataList.Strings[iIndex];
      if (RightStr(sReadBuff,1) <> #09) then sReadBuff := sReadBuff + #09;

      if Trim(sReadBuff) = '' then Continue;

      // 보고서 전문이 아니면 넘어가기.
      if (copy(sReadBuff, 8, 1) <> '1') and
        (copy(sReadBuff, 8, 1) <> '0') then Continue;

      StrToMySamHead(sReadBuff);

//      if Trim(MySamHeadRec.BrnCode) <> sFirstBrnCode then
//      begin
//        gf_RollBackTransaction;
//        sMsg := gwImportErrMsg + gwClickOKMsg + // Import 중 오류 발생! 확인 버튼을 눌러주십시요.
//          '(' + gwErrLineNo + IntToStr(iIndex + 1) + ')';
//        ErrorProcessPanel(sMsg, True);
//        gf_ShowMessage(MessageBar, mtError, 2020, gwErrLineNo + IntToStr(iIndex + 1)); // 부서코드 오류
//        Exit;
//      end;

      if (Length(sSumBuff + sReadBuff + DATA_DELIMITER) >= iMaxDataSize) then
      begin
//ShowMessage('@in_DeptUserID - ' + gvDeptCode + gvOprUsrNo + #13#10
//	+'@in_str_seq - ' + IntToStr(iStartSeqNo) + #13#10
//	+'@in_cnt - ' + IntToStr(iDataCnt) + #13#10
//	+'@in_delimiter - ' + DATA_DELIMITER);
//ShowMessage('[' + sSumBuff +']');

        // 패킷이 다 차면 SP 호출 처리.
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
            gf_ShowErrDlgMessage(Self.Tag, 1031, //Database 오류
              'ADOSP_SP0100_2: ' + Trim(DataModule_SettleNet.ADOSP_SP0100_2.Parameters.ParamByName('@out_kor_msg').Value), 0);
            sMsg := gwImportErrMsg + gwClickOKMsg; // Import 중 오류 발생! 확인 버튼을 눌러주십시요.
            ErrorProcessPanel(sMsg, True);
            gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_SP0100_2'); //Import중 오류발생
            Exit;
          end;

        except
          on E: Exception do
          begin
            gf_RollBackTransaction;
            gf_ShowErrDlgMessage(Self.Tag, 1031, 'ADOSP_SP0100_2: ' + E.Message, 0);
            sMsg := gwImportErrMsg + gwClickOKMsg; // Import 중 오류 발생! 확인 버튼을 눌러주십시요.
            ErrorProcessPanel(sMsg, True);
            gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_SP0100_2'); //Import중 오류발생
            Exit;
          end;
        end;
        
        iStartSeqNo := iStartSeqNo + iDataCnt;
        iDataCnt := 0;
        sSumBuff := '';
      end;
      
      // 자료 누적.
      sSumBuff := sSumBuff + sReadBuff + DATA_DELIMITER;
      inc(iDataCnt, 1);
    end; //end For

     //마지막 자료 Call
    if iDataCnt > 0 then // 처리 Data 있음
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
          gf_ShowErrDlgMessage(Self.Tag, 1031, //Database 오류
            'ADOSP_SP0100_2: ' + Trim(DataModule_SettleNet.ADOSP_SP0100_2.Parameters.ParamByName('@out_kor_msg').Value), 0);
          sMsg := gwImportErrMsg + gwClickOKMsg; // Import 중 오류 발생! 확인 버튼을 눌러주십시요.
          ErrorProcessPanel(sMsg, True);
          gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_SP0100_2'); //Import중 오류발생
          Exit;
        end;

      except
        on E: Exception do
        begin
          gf_RollBackTransaction;
          gf_ShowErrDlgMessage(Self.Tag, 1031, 'ADOSP_SP0100_2: ' + E.Message, 0);
          sMsg := gwImportErrMsg + gwClickOKMsg; // Import 중 오류 발생! 확인 버튼을 눌러주십시요.
          ErrorProcessPanel(sMsg, True);
          gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_SP0100_2'); //Import중 오류발생
          Exit;
        end;
      end;
        
      iStartSeqNo := iStartSeqNo + iDataCnt;
      iDataCnt := 0;
      sSumBuff := '';
    end; //마지막 자료 Call
  end; // if 그리드에 매매가 있다면 ...

  //--------------------
  gf_CommitTransaction;
  //--------------------

   //----------------------------------------------------------------------------
   // 4. 실제 Import  SP CALL
   //----------------------------------------------------------------------------

   //----------------------------------------------------------------------------
   // 4.1 계좌 정보  Import
   //----------------------------------------------------------------------------
  if DRStrGrid_ImportInfo.Cells[1, IDX_ROW_ACC] <> 'X' then
  begin
    gf_log('[' + IntToStr(Self.Tag) + '] bf Import_AccInfo');
    sMsg := '[계좌 정보] ' + gwImportMsg; // 'Import 중입니다. 잠시 기다리십시요...'
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
   // 4.2 수신처 Import
   //----------------------------------------------------------------------------
  if DRStrGrid_ImportInfo.Cells[1, IDX_ROW_ADDR] <> 'X' then
  begin
    gf_log('[' + IntToStr(Self.Tag) + '] bf Import_AddrInfo');
    sMsg := '[수신처 정보] ' + gwImportMsg; // 'Import 중입니다. 잠시 기다리십시요...'
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
   // 4.3 보고서 전문 Import
   //----------------------------------------------------------------------------
   if DRStrGrid_ImportInfo.Cells[1, IDX_ROW_RPT] <> 'X' then
   begin
gf_log('['+ IntToStr(Self.Tag) +'] bf Import_RptInfo');
      sMsg := '[보고서 전문] ' + gwImportMsg; // 'Import 중입니다. 잠시 기다리십시요...'
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
  gf_ShowMessage(MessageBar, mtInformation, 1140, ''); // Import 완료

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
        gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_Import'); //Import중 오류발생
        gf_ShowErrDlgMessage(Self.Tag, 1031, 'ADOSP_Import [계좌 정보]: ' +
          Trim(ADOSP_SP8201_1.Parameters.ParamByName('@out_kor_msg').Value), 0);
        Exit;
      end;

      if Trim(ADOSP_SP8201_1.Parameters.ParamByName('@RETURN_VALUE').Value) <> '1' then
      begin
        gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_Import'); //Import중 오류발생
        gf_ShowErrDlgMessage(Self.Tag, 1031, 'ADOSP_Import[계좌 정보]: 알수없는 오류', 0);
        Exit;
      end;

    except
      on E: Exception do
      begin
        gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_Import'); //Import중 오류발생
        gf_ShowErrDlgMessage(Self.Tag, 1031, 'ADOSP_Import[계좌 정보]: ' + E.Message, 0);
        Exit;
      end;
    end;
  end; // with DataModule_SettleNet do

  Result := True;
end;


procedure TForm_SCFH8201.DRButton2Click(Sender: TObject);
begin
  inherited;
  gf_log('[' + IntToStr(Self.Tag) + '] 사용자가 직접 파일 오픈하여 Import시작');
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
      gf_ShowMessage(MessageBar, mtError, 0, 'Lock 해제 대상이 없습니다.'); // 해당 파일이 존재하지 않습니다.
      Exit;
    end;

  end;

  // Confirm - 임포트 락을 해제
  if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 0, '임포트 락을 해제하시겠습니까?', mbOKCancel, 0) = idcancel then
  begin
    gf_ShowMessage(MessageBar, mtInformation, 1082, ''); // 작업이 취소되었습니다.
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
      gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_TEMP[SCILOCK_TBL : INSERT]'); // Database 오류
      EnableForm;
      Exit;
    end;
  end;
  EnableForm;
  gf_ShowMessage(MessageBar, mtInformation, 1016, ''); // 처리 완료
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
        gf_ShowMessage(MessageBar, mtError, 1031, 'Import_AddrInfo'); //Import중 오류발생
        gf_ShowErrDlgMessage(Self.Tag, 1031, 'Import_AddrInfo [수신처 정보]: ' +
          Trim(ADOSP_SP8201_2.Parameters.ParamByName('@out_kor_msg').Value), 0);
        Exit;
      end;

      if Trim(ADOSP_SP8201_2.Parameters.ParamByName('@RETURN_VALUE').Value) <> '1' then
      begin
        gf_ShowMessage(MessageBar, mtError, 1031, 'Import_AddrInfo'); //Import중 오류발생
        gf_ShowErrDlgMessage(Self.Tag, 1031, 'Import_AddrInfo[수신처 정보]: 알수없는 오류', 0);
        Exit;
      end;

    except
      on E: Exception do
      begin
        gf_ShowMessage(MessageBar, mtError, 1031, 'Import_AddrInfo'); //Import중 오류발생
        gf_ShowErrDlgMessage(Self.Tag, 1031, 'Import_AddrInfo[수신처 정보]: ' + E.Message, 0);
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
    //gf_ShowErrDlgMessage(Self.Tag,0,'원장(CICS)과 연결할 수 없습니다. CICSUseYN = N, 데이터로드로 문의바랍니다.',0);
    gf_ShowErrDlgMessage(Self.Tag, 0, '원장(MCA)과 연결할 수 없습니다. 데이터로드로 문의바랍니다.', 0);
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

  // 계좌번호 확인
  if DRRadioButton_Rpt_AccNo.Checked then
  begin
    if (Length(Trim(DREdit_Rpt_AccNo.Text)) <> 8) then
    begin
      gf_ShowMessage(MessageBar, mtError, 0, '계좌번호가 잘못되었습니다.');
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
        gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_Import'); //Import중 오류발생
        gf_ShowErrDlgMessage(Self.Tag, 1031, 'ADOSP_Import [계좌 정보]: ' +
          Trim(ADOSP_SP8201_3.Parameters.ParamByName('@out_kor_msg').Value), 0);
        Exit;
      end;

      if Trim(ADOSP_SP8201_3.Parameters.ParamByName('@RETURN_VALUE').Value) <> '1' then
      begin
        gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_Import'); //Import중 오류발생
        gf_ShowErrDlgMessage(Self.Tag, 1031, 'ADOSP_Import[계좌 정보]: 알수없는 오류', 0);
        Exit;
      end;

    except
      on E: Exception do
      begin
        gf_ShowMessage(MessageBar, mtError, 1031, 'ADOSP_Import'); //Import중 오류발생
        gf_ShowErrDlgMessage(Self.Tag, 1031, 'ADOSP_Import[계좌 정보]: ' + E.Message, 0);
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
    //gf_ShowErrDlgMessage(Self.Tag,0,'원장(CICS)과 연결할 수 없습니다. CICSUseYN = N, 데이터로드로 문의바랍니다.',0);
    gf_ShowErrDlgMessage(Self.Tag, 0, '원장(MCA)과 연결할 수 없습니다. 데이터로드로 문의바랍니다.', 0);
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
  //-- 화면 초기화 -------------------------------------------------------------
  // 계좌 및 수신처
  DRRadioButton_Acc_ChgDate.Checked := True;
  DRMaskEdit_Acc_ChgDate.Text := gf_GetCurDate;
  DRMaskEdit_Acc_ChgDate.SetFocus;

  // 보고서
  DRRadioButton_Rpt_New.Checked := True;

  // [TEST]
  DRMaskEdit_Test_Date.Text := gf_GetCurDate;

  // 파일 정보 그리드
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
    gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); //List 생성 오류
    Close;
  end;

  AccList := TStringList.Create;
  if not Assigned(AccList) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); //List 생성 오류
    Close;
  end;
end;

end.

