//==============================================================================
//   SettleNet Library (Only �ѱ�����)
//   [Y.K.J] 2011.08.08
//           �߰�: �ѱ��������� ������ �ý���(MCA)���� ���� �߰�
//==============================================================================

unit SCCTFLib;

interface

uses
   Windows, SysUtils, IniFiles, Forms, Dialogs, ADOdb, StrUtils, Classes,
   SCCTFGlobalType;

//------------------------------------------------------------------------------
//  MCA �ý��� Call
//------------------------------------------------------------------------------

// MCA ���� ���� ��û Call
function gf_tf_HostMCAConnect(FirstConnect: boolean; var sOut: string): boolean;

// MCA ���� ���� ���� Call
procedure gf_tf_HostMCADisConnect(var sOut: string);

// �ֽ�  //

//�ֽ� �����ڷ� ���� Call (������)
function gf_tf_HostMCAsngetACInfo(sDate,sAccList,sFileName:string;
                          var sOut:string) : boolean;

//�ֽ� �Ÿ��ڷ� ���� Call (������)
function gf_tf_HostMCAsngetTRInfo(sDate,sAccList,sFileName:string;
                          var sOut:string) : boolean;

//�ֽ� �������� ���� ó�� Call (������)
function gf_tf_HostMCAprocessStlClose(sDate, sWorkCode, sWorkAuthority:string;
                                        var sOut:string) : boolean;

//�ֽ� �������� Upload Call (������)
function gf_tf_HostMCAsnprocessUploadData(sDate, sFileName, sWorkCode:string;
                          var sOut:string) : boolean;

//�ֽ� ���� ���� Upload Call (������)
function gf_tf_HostMCAsnprocessUploadACData(sDate, sFileName, sWorkCode, sDelType:string;
                          var sOut:string) : boolean;

//���忡�� ��������(������)
function gf_tf_HostMCACalculate(
          sIssueCode, sTranCode, sTrdType, sAccNo, sStlDate:string;
          dAvrExecPrice, dTotExecQty, dTotExecAmt: double;
          var dComm, dTrdTax, dAgcTax, dCpgTax, dNetAmt, dHCommRate: double;
          var sOut : string) : boolean;

// ����  //

//���� �������� �ڷ� ���� MCA Call (������)
function gf_tf_HostMCAsngetFACInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;

//���� ���������� �ڷ� ���� MCA Call (������)
function gf_tf_HostMCAsngetFCmInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;

//���� ��Ź�ڷ� ���� MCA Call (������)
function gf_tf_HostMCAsngetFDPInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;

//���� �Ÿ��ڷ� ���� MCA Call (������)
function gf_tf_HostMCAsngetFTRInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;

//���� �̰����ڷ� ���� MCA Call (������)
function gf_tf_HostMCAsngetFOPInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;

//���� ����ڷ� ���� MCA Call (������)
function gf_tf_HostMCAsngetFLNInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;


// ������ǰ //

//������ǰ ����&����ó �ڷ� ���� Call (������)
function gf_tf_HostMCAsngetZACInfo(sDate, sChgDate, sAccList, sFileName:string;
                          var sOut:string) : boolean;

//������ǰ ���� ���� �ڷ� ���� Call (������)
function gf_tf_HostMCAsngetZRPTInfo(sDate, sAccList, sFileName:string;
                          var sOut:string) : boolean;


//-- ��Ÿ �Լ� ���� --

//  TR�� �������̽�ID ��������( T:�ŸŰ�(������:C), C: ������(������:JAVA) )
procedure gf_tf_GetIDFC_ID(pInterfaceID: string);

// MCA HeaderData ���ϱ�
procedure GetMCAHeaderData(MCA_TRName: string; var HeaderItem: TMCAHeader);

// Ÿ�μ� ���� ����Ʈ ����
procedure CreateAcEtcList;

// Ÿ�μ� ���� ���� üũ
function AcEtcYn(pAccNo: string): boolean;

//------------------------------------------------------------------------------
//  Log File ó��
//------------------------------------------------------------------------------
// MCA Log File ���(Thread Safe)
procedure gf_MCALog(S: String);
// MCA Log File Open
procedure gf_StartMCALog(pLogPath, pLogName: string);
// MCA Log File Close
procedure gf_EndMCALog;


implementation

uses
   SCCLib, SCCGlobalType, SCCDataModule;


//------------------------------------------------------------------------------
// Upload �� ������ ��������(SEUPLOAD2_TBL)
//------------------------------------------------------------------------------
function GetSEUPLOAD2_TBL(pADOQuery: TADOQuery; pFileName, pDate: string;
          var sOut:string): boolean;
begin
  Result := True;
  with pADOQuery do
  begin
    EnableBCD := False;
    Close;
    SQL.Clear;
    SQL.Add('SELECT                                                             ');
    SQL.Add('  SEQ =                                                            ');
    SQL.Add('    CASE WHEN GUBUN = ''2'' THEN ''1''                             ');
    SQL.Add('         WHEN GUBUN = ''3'' THEN ''2''                             ');
    SQL.Add('         WHEN GUBUN = ''R'' THEN ''3''                             ');
    SQL.Add('         WHEN GUBUN = ''L'' THEN ''4''                             ');
    SQL.Add('    END,                                                           ');
    SQL.Add('  USER_ID,     FILE_NAME,     OPR_DATE,      OPR_TIME,    DEPT_CODE, ');
    SQL.Add('  TRADE_DATE,  F_ACC_NO,      F_BRK_SHT_NO,  T_ACC_NO,    T_BRK_SHT_NO, ');
    SQL.Add('  ACC_ATTR = (SELECT ACC_ATTR FROM SEACBIF_TBL b                   ');
    SQL.Add('              WHERE b.DEPT_CODE = a.DEPT_CODE                      ');
    SQL.Add('                AND b.ACC_NO= a.F_ACC_NO),                         ');
    SQL.Add('  ISSUE_CODE,  F_TAXGBJJ_YN,  T_TAXGBJJ_YN,  TRAN_CODE,   TRADE_TYPE, ');
    SQL.Add('  GUBUN,       DATA_GB,       COMM_RATE,     EXEC_PRICE,  EXEC_QTY, ');
    SQL.Add('  EXEC_AMT,    COMM,          TAX                                  ');
    SQL.Add('FROM SEUPLOAD2_TBL a                                               ');

    SQL.Add('WHERE USER_ID = '''+ gvOprUsrNo +'''                               ');
    SQL.Add('  AND FILE_NAME = '''+ pFileName +'''                              ');
    SQL.Add('  AND DEPT_CODE = '''+ gvDeptCode +'''                             ');
    SQL.Add('  AND TRADE_DATE = '''+ pDate +'''                                 ');
    SQL.Add('ORDER BY SEQ, DATA_GB                                              ');

    Try
      gf_ADOQueryOpen(pADOQuery);
    Except
      on E: Exception do
      begin
          sOut := 'ADOQuery Error[SEUPLOAD2_TBL]. :' + E.Message;
          Result := False;
          exit;
      end;
    End;
  end;
end;

//------------------------------------------------------------------------------
// ���º� Upload - ������ ���� ����Ʈ ��������(SEUPLOAD2_TBL)
//------------------------------------------------------------------------------
function GetAccUploadDelList(pADOQuery: TADOQuery; pFileName, pDate, pDelType: string;
          var sOut:string): boolean;
begin
  Result := True;
  with pADOQuery do
  begin
    EnableBCD := False;
    Close;
    SQL.Clear;
    // ���������� ���� ó��.
    if (pDelType = gwTotal) then
    // ��ü ����.
    begin
      SQL.Add('SELECT DISTINCT                                                    ');
      SQL.Add('  SEQ = '''',                                                      ');
      SQL.Add('  USER_ID = '''', FILE_NAME = '''',                                ');
      SQL.Add('  OPR_DATE = '''', OPR_TIME = '''',                                ');
      SQL.Add('  DEPT_CODE, TRADE_DATE,                                           ');
      SQL.Add('  F_ACC_NO = REPLACE(ACC_NO,''Z'',''''), F_BRK_SHT_NO = '''',      ');
      SQL.Add('  T_ACC_NO = REPLACE(ACC_NO,''Z'',''''), T_BRK_SHT_NO = '''', ACC_ATTR = '''', ');
      SQL.Add('  ISSUE_CODE = '''',  F_TAXGBJJ_YN = '''',  T_TAXGBJJ_YN = '''',   ');
      SQL.Add('  TRAN_CODE = '''', TRADE_TYPE = '''',                             ');
      SQL.Add('  GUBUN = '''', DATA_GB = '''', COMM_RATE = ''0'',                 ');
      SQL.Add('  EXEC_PRICE = ''0'', EXEC_QTY = ''0'',                            ');
      SQL.Add('  EXEC_AMT = ''0'', COMM = ''0'', TAX = ''0''                      ');
      SQL.Add('FROM SETRADE_TBL                                                   ');
      SQL.Add('WHERE DEPT_CODE = '''+ gvDeptCode +'''                             ');
      SQL.Add('  AND TRADE_DATE = '''+ pDate +'''                                 ');
      SQL.Add('ORDER BY F_ACC_NO, T_ACC_NO                                        ');
    end else
    // ó����� ���¸� ����.
    begin
      SQL.Add('SELECT DISTINCT                                                    ');
      SQL.Add('  SEQ = '''',                                                      ');
      SQL.Add('  USER_ID, FILE_NAME,                                              ');
      SQL.Add('  OPR_DATE, OPR_TIME,                                              ');
      SQL.Add('  DEPT_CODE, TRADE_DATE,                                           ');
      SQL.Add('  F_ACC_NO, F_BRK_SHT_NO, T_ACC_NO, T_BRK_SHT_NO, ACC_ATTR = '''', ');
      SQL.Add('  ISSUE_CODE = '''',  F_TAXGBJJ_YN = '''',  T_TAXGBJJ_YN = '''',   ');
      SQL.Add('  TRAN_CODE = '''', TRADE_TYPE = '''',                             ');
      SQL.Add('  GUBUN = '''', DATA_GB = '''', COMM_RATE = ''0'',                 ');
      SQL.Add('  EXEC_PRICE = ''0'', EXEC_QTY = ''0'',                            ');
      SQL.Add('  EXEC_AMT = ''0'', COMM = ''0'', TAX = ''0''                      ');
      SQL.Add('FROM SEUPLOAD2_TBL a                                               ');
      SQL.Add('WHERE DEPT_CODE = '''+ gvDeptCode +'''                             ');
      SQL.Add('  AND TRADE_DATE = '''+ pDate +'''                                 ');
      SQL.Add('  AND USER_ID = '''+ gvOprUsrNo +'''                               ');
      SQL.Add('  AND FILE_NAME = '''+ pFileName +'''                              ');
      SQL.Add('ORDER BY SEQ, DATA_GB                                              ');
    end;

    Try
      gf_ADOQueryOpen(pADOQuery);
    Except
      on E: Exception do
      begin
          sOut := 'ADOQuery Error[GetAccUploadDelList()]. :' + E.Message;
          Result := False;
          exit;
      end;
    End;
  end;
end;

//------------------------------------------------------------------------------
// MCA Interface ���ں�ȯ(���ڳ� Nil ���ֱ�)
//------------------------------------------------------------------------------
procedure myStr2NotNilChar(str : PChar; instr : string; len : longint);
var
    i : integer;
    StrTmp : array[0..8196] of char;
begin
    FillChar(str^, len, #32);

    strPLcopy(StrTmp, instr, len);
    for i := 0 to len - 1 do
        str[i] := StrTmp[i];
    str[len] := #32;
end;

//------------------------------------------------------------------------------
// MCA HeaderData ���ϱ�
//------------------------------------------------------------------------------
procedure GetMCAHeaderData(MCA_TRName: string; var HeaderItem: TMCAHeader);
var
  // ��� ����
  sTR_Type          : string;
  sInterface_id     : string;
  sEncrypt_flag     : string;
  sTr_name          : string;
  sScr_no           : string;
  sLang_id          : string;
  sMode_flag        : string;
  sTr_cont          : string;
  sCo_cd            : string;
  sMedia_cd1        : string;
  sMedia_cd2        : string;
  sOrg_cd           : string;
  sSeq_no           : string;
  sDept_cd          : string;
  sEmp_id           : string;
  sEmp_seq          : string;
  sUser_id          : string;
  sBr_open_cd       : string;
  sAcct_no          : string;
  sMediaFlag        : string;
  sMediaFlag_Detail : string;
  sRt_cd            : string;
begin

  sTR_Type          := '';          // �ŷ�����
  sEncrypt_flag     := '';          // ��ȣ/����/��������/IP4, IP6 ���� �÷���
  sTr_name          := MCA_TRName;  // TR(Service) Name
  sScr_no           := '00000';     // ȭ�� ��ȣ
  sLang_id          := 'K';         // ��� ����(K: �ѱ���, E: ����)
  sMode_flag        := '1';         // ����/� �÷���(1: ����, 2: �)
  sTr_cont          := '';          // ���� �ŷ� ����
  sCo_cd            := 'A';         // ȸ�� �ڵ�
  sMedia_cd1        := '01';        // ��ü ����(01: �ѱ��ܸ�)
  sMedia_cd2        := '00000';     // �Է¸�ü�󼼱���([�Ϲ�����]00000: TO_BE�����ڵ�)
  sOrg_cd           := '01710';     // �����ڵ�
  sSeq_no           := '301';       // �Ϸù�ȣ
  sDept_cd          := '01710';     // ������ �μ��ڵ�
  sEmp_id           := gvOprEmpID;  // ������ ���
  sEmp_seq          := '';          // ������ ����
  sUser_id          := '';          // HTS ID(������ : Space, ���� : HTS ID)
  sBr_open_cd       := '';          // ���� ������
  sAcct_no          := '';          // ���¹�ȣ
  sMediaFlag        := '';          // �Է¸�ü����
  sMediaFlag_Detail := '';          // �ŷ��Է¸�ü�󼼱���
  sRt_cd            := '';          // ���� ���� ����
                                        // 0: ����ó��
                                        // 1: �ý��ۿ���
                                        // 2:
                                        // 3: Dummy Return
                                        // 4: ROLLBACK_NORMAL_RETURN
                                        // 5: COMMIT_BLANK_RETURN
                                        // 6: SKIP_AND_GO
                                        // 7: ���� ����

  // Interface ID ���ϱ�(T:�ŸŰ�, C:������)
  if (MCA_TRName = gcMCA_TR_E_ACC       ) or   // �ֽ� �������� Import
     (MCA_TRName = gcMCA_TR_E_TRADE     ) or   // �ֽ� �Ÿų��� Import
     (MCA_TRName = gcMCA_TR_E_UPLOAD    ) or   // �ֽ� �������� Upload
     (MCA_TRName = gcMCA_TR_F_TRADE     ) then // ���� �Ÿų��� Import
  begin
    sInterface_id := 'T';
  end else
  if (MCA_TRName = gcMCA_TR_E_CLOSE     ) or   // �ֽ� �������� ���� üũ
     (MCA_TRName = gcMCA_TR_E_CALC_COMM ) or   // �ֽ� ��������
     (MCA_TRName = gcMCA_TR_E_UPLOAD_ACC) or   // �ֽ� ������������ Upload
     (MCA_TRName = gcMCA_TR_F_ACC       ) or   // ���� �������� Import
     (MCA_TRName = gcMCA_TR_F_DEPOSIT   ) or   // ���� ��Ź���� Import
     (MCA_TRName = gcMCA_TR_F_OPEN      ) or   // ���� �̰������� Import
     (MCA_TRName = gcMCA_TR_F_COLT      ) or   // ���� ��볻�� Import
     (MCA_TRName = gcMCA_TR_F_COMM_INFO ) or   // ���� ���� ���������� Import
     (MCA_TRName = gcMCA_TR_Z_ACC       ) or   // ������ǰ ���� Import
     (MCA_TRName = gcMCA_TR_Z_RPT       ) then // ������ǰ ���� ���� Import
  begin
    sInterface_id := 'C';
  end;

  // INPUT.ITFC_ID ���� (gvMCAInterfaceID)
  gf_tf_GetIDFC_ID(sInterface_id);

  // ��� �ʱ�ȭ
  FillChar(HeaderItem,SizeOf(HeaderItem),#32);

  myStr2NotNilChar(HeaderItem.TR_TYPE          , sTR_Type          , Length(sTR_Type         ) );
  myStr2NotNilChar(HeaderItem.INTERFACE_ID     , sInterface_id     , Length(sInterface_id    ) );
  myStr2NotNilChar(HeaderItem.ENCRYPT_FLAG     , sEncrypt_flag     , Length(sEncrypt_flag    ) );
  myStr2NotNilChar(HeaderItem.TR_NAME          , sTr_name          , Length(sTr_name         ) );
  myStr2NotNilChar(HeaderItem.SCR_NO           , sScr_no           , Length(sScr_no          ) );
  myStr2NotNilChar(HeaderItem.LANG_ID          , sLang_id          , Length(sLang_id         ) );
  myStr2NotNilChar(HeaderItem.MODE_FLAG        , sMode_flag        , Length(sMode_flag       ) );
  myStr2NotNilChar(HeaderItem.TR_CONT          , sTr_cont          , Length(sTr_cont         ) );
  myStr2NotNilChar(HeaderItem.CO_CD            , sCo_cd            , Length(sCo_cd           ) );
  myStr2NotNilChar(HeaderItem.MEDIA_CD1        , sMedia_cd1        , Length(sMedia_cd1       ) );
  myStr2NotNilChar(HeaderItem.MEDIA_CD2        , sMedia_cd2        , Length(sMedia_cd2       ) );
  myStr2NotNilChar(HeaderItem.ORG_CD           , sOrg_cd           , Length(sOrg_cd          ) );
  myStr2NotNilChar(HeaderItem.SEQ_NO           , sSeq_no           , Length(sSeq_no          ) );
  myStr2NotNilChar(HeaderItem.DEPT_CD          , sDept_cd          , Length(sDept_cd         ) );
  myStr2NotNilChar(HeaderItem.EMP_ID           , sEmp_id           , Length(sEmp_id          ) );
  myStr2NotNilChar(HeaderItem.EMP_SEQ          , sEmp_seq          , Length(sEmp_seq         ) );
  myStr2NotNilChar(HeaderItem.USER_ID          , sUser_id          , Length(sUser_id         ) );
  myStr2NotNilChar(HeaderItem.BR_OPEN_CD       , sBr_open_cd       , Length(sBr_open_cd      ) );
  myStr2NotNilChar(HeaderItem.ACCT_NO          , sAcct_no          , Length(sAcct_no         ) );
  myStr2NotNilChar(HeaderItem.MEDIAFLAG        , sMediaFlag        , Length(sMediaFlag       ) );
  myStr2NotNilChar(HeaderItem.MEDIAFLAG_DETAIL , sMediaFlag_Detail , Length(sMediaFlag_Detail) );
  myStr2NotNilChar(HeaderItem.RT_CD            , sRt_cd            , Length(sRt_cd           ) );

end;

//------------------------------------------------------------------------------
// MCA ���� ���� ��û Call
//------------------------------------------------------------------------------
function gf_tf_HostMCAConnect(FirstConnect: boolean; var sOut: string): boolean;
var
  iResult: integer;
begin
  //gf_MCALog('MCA: Connect() Start. ');
  Result:= False;

  iResult := 0;
  Try
    if (m_hHKCommDLL <> 0) then
    begin
      if (Not gvMCAConnectYn) then
      begin

        iResult := m_pConnectMCAServer(pAnsiChar(gvMCAConnectIP),
                      gvMCAConnectPort,'',gvMainFrameHandle);

        if iResult <> 0 then
        begin
          // ó�� ����(��Ʋ�� �����Ͽ�����)�Ͽ����� ���� üũ.
          if FirstConnect then
          begin
            gvMCAConnectYn := False;
            sOut := 'MCA Connect Error. :' + IntToStr(iResult);
            exit;
          end;
        end;
        gf_MCALog('MCA: Connect() Ok. ');
        gvMCAConnectYn := True;
      end;
    end else
    begin
      sOut := 'MCA Connect(): DLL Load Error. (HKServerCommDLL.dll)';
      Exit;
    end;
  Except
    On E: Exception do
    begin
      sOut := 'MCA Connect() Except: ' + E.Message + ': ' + IntToStr(iResult);
      Exit;
    end;
  End;

  Result:= True;
  //gf_MCALog('MCA: Connect() Finish.');
end;

//------------------------------------------------------------------------------
// MCA ���� ���� ���� Call
//------------------------------------------------------------------------------
procedure gf_tf_HostMCADisConnect(var sOut: string);
begin

  if (m_hHKCommDLL <> 0) then
  begin
    m_pDisConnectMCAServer();
    gf_MCALog('MCA: DisConnect() Ok.');
    gvMCAConnectYn := False;
  end else
  begin
    sOut := 'MCA DisConnect(): DLL Load Error. (HKServerCommDLL.dll)';
    Exit;
  end;

end;

//------------------------------------------------------------------------------
//�ֽ� ���� Import Using MCA
// todo: �ֽ� ���� Import - gf_HostMCAsngetACInfo()
//------------------------------------------------------------------------------
function gf_tf_HostMCAsngetACInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;
var
  sCustDept : string;

  iResult, i, iComPos: integer;

  sAccNo,
  sAccFileName: string;

  headerInfo : TMCAHeader; // ��� ����
  InputData : TTTC3808UI1; // Input

  // Input ����
  sCANO           : string;
  sACNT_PRDT_CD   : string;
  sORGNO          : string;
  sWORK_DT        : string;
  sITFC_ID        : string;
  sPOUT_FILE_NAME : string;

begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TTC3808U] �ֽ� ���� ���� ���� ����.');

  Result := false;

  sCustDept := '0' + gvDeptCode;

  //----------------------------------------------------------------------------
  // RequestData
  //---------------------------------------------------------------------------
  gvMCAReceive := False;
  iResult := 0;

  // ��� ����
  GetMCAHeaderData(gcMCA_TR_E_ACC, headerInfo);

  gf_MCALog('headerInfo.TR_Type          : ' + headerInfo.TR_Type          );
  gf_MCALog('headerInfo.Interface_id     : ' + headerInfo.Interface_id     );
  gf_MCALog('headerInfo.Encrypt_flag     : ' + headerInfo.Encrypt_flag     );
  gf_MCALog('headerInfo.Tr_name          : ' + headerInfo.Tr_name          );
  gf_MCALog('headerInfo.Scr_no           : ' + headerInfo.Scr_no           );
  gf_MCALog('headerInfo.Lang_id          : ' + headerInfo.Lang_id          );
  gf_MCALog('headerInfo.Mode_flag        : ' + headerInfo.Mode_flag        );
  gf_MCALog('headerInfo.Tr_cont          : ' + headerInfo.Tr_cont          );
  gf_MCALog('headerInfo.Co_cd            : ' + headerInfo.Co_cd            );
  gf_MCALog('headerInfo.Media_cd1        : ' + headerInfo.Media_cd1        );
  gf_MCALog('headerInfo.Media_cd2        : ' + headerInfo.Media_cd2        );
  gf_MCALog('headerInfo.Org_cd           : ' + headerInfo.Org_cd           );
  gf_MCALog('headerInfo.Seq_no           : ' + headerInfo.Seq_no           );
  gf_MCALog('headerInfo.Dept_cd          : ' + headerInfo.Dept_cd          );
  gf_MCALog('headerInfo.Emp_id           : ' + headerInfo.Emp_id           );
  gf_MCALog('headerInfo.Emp_seq          : ' + headerInfo.Emp_seq          );
  gf_MCALog('headerInfo.User_id          : ' + headerInfo.User_id          );
  gf_MCALog('headerInfo.Br_open_cd       : ' + headerInfo.Br_open_cd       );
  gf_MCALog('headerInfo.Acct_no          : ' + headerInfo.Acct_no          );
  gf_MCALog('headerInfo.MediaFlag        : ' + headerInfo.MediaFlag        );
  gf_MCALog('headerInfo.MediaFlag_Detail : ' + headerInfo.MediaFlag_Detail );
  gf_MCALog('headerInfo.Rt_cd            : ' + headerInfo.Rt_cd            );

  // ��� ���¼� ��ŭ ����
  if (sAccList > '') then
  begin
    while (sAccList > '') do
    begin
      gf_MCALog('���º� ���� �ڷ� ����.');
      Inc(gvMCAFileCnt);

          if Pos(',', sAccList) > 0 then
          begin
            // ó�� ��� ���� ã��.
            iComPos := Pos(',', sAccList);
            sAccNo := LeftStr(sAccList,iComPos-1);
            sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);
          end else
          begin
            sAccNo := '';
          end;

          //
      sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '_' // ���� ���ϸ�
                    + FormatFloat('000', gvMCAFileCnt)                   // ����
                    + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // Ȯ����
      gvMCAFtpFileList.Add(sAccFileName);

          gf_MCALog('sAccNo: ' + sAccNo);
          gf_MCALog('sAccList: ' + sAccList);

      // Input ����
      FillChar(InputData,SizeOf(InputData),#32);

          sCANO           := LeftStr(sAccNo,8);
          sACNT_PRDT_CD   := Copy(sAccNo,9,2);
      sORGNO          := sCustDept;
      sITFC_ID        := gvMCAInterfaceID;
      sPOUT_FILE_NAME := sAccFileName;

      myStr2NotNilChar(InputData.CANO           , sCANO           , Length(sCANO          ) );
      myStr2NotNilChar(InputData.ACNT_PRDT_CD   , sACNT_PRDT_CD   , Length(sACNT_PRDT_CD  ) );
      myStr2NotNilChar(InputData.SETN_BRNO      , sORGNO          , Length(sORGNO         ) );
      myStr2NotNilChar(InputData.WORK_DT        , sDate           , Length(sDate          ) );
      myStr2NotNilChar(InputData.ITFC_ID        , sITFC_ID        , Length(sITFC_ID       ) );
      myStr2NotNilChar(InputData.POUT_FILE_NAME , sPOUT_FILE_NAME , Length(sPOUT_FILE_NAME) );

      InputData._CANO           := #16;
      InputData._ACNT_PRDT_CD   := #16;
      InputData._SETN_BRNO      := #16;
      InputData._WORK_DT        := #16;
      InputData._ITFC_ID        := #16;
      InputData._POUT_FILE_NAME := #16;
        
      gf_MCALog(IntToStr(gvMCAFileCnt) + ' : ' + sAccFileName);
      gf_MCALog('Input.CANO                   : ' + InputData.CANO             );
      gf_MCALog('Input.ACNT_PRDT_CD           : ' + InputData.ACNT_PRDT_CD     );
      gf_MCALog('Input.SETN_BRNO              : ' + InputData.SETN_BRNO        );
      gf_MCALog('Input.sWORK_DT               : ' + InputData.WORK_DT          );
      gf_MCALog('Input.sITFC_ID               : ' + InputData.ITFC_ID          );
      gf_MCALog('Input.POUT_FILE_NAME         : ' + InputData.POUT_FILE_NAME   );

      Try
        if (m_hHKCommDLL <> 0) then
        begin
          Sleep(1000);
          //
          iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                      sizeof(TMCAHeader), sizeof(TTTC3808UI1));

          if iResult = 0 then
          begin
             sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
             exit;
          end;
        end else
        begin
          sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
          Exit;
        end;

        while True do
        begin
          EnterCriticalSection(gvMCACriticalSection);
          if gvMCAReceive then
          begin
            gvMCAReceive := False;
            gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
            LeaveCriticalSection(gvMCACriticalSection);

            if gvMCAResult <> 'Y' then
            begin
              sOut := '���� ó�� ����.';
              gf_MCALog('���� ó�� ����.');
              //Exit;
            end;
            Break;
          end;
          LeaveCriticalSection(gvMCACriticalSection);
          Application.ProcessMessages;
          Sleep(100);
        end; // while

        Result := true;

      Except
         On E: Exception do
         begin
            sOut := '���� ȣ��() ����: ' + E.Message + ': ' + IntToStr(iResult);
            Exit;
         end;
      End;
    end;

  end else
  begin
    // ��ü �Ÿ� ����Ʈ
    gf_MCALog('��ü ���� �ڷ� ����.');
    Inc(gvMCAFileCnt);
    sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '_' // ���� ���ϸ�
                  + FormatFloat('000', gvMCAFileCnt) + 'T'        // ����
                  + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // Ȯ����
    gvMCAFtpFileList.Add(sAccFileName);

    // Input ����
    FillChar(InputData,SizeOf(InputData),#32);

    sCANO           := '';
    sACNT_PRDT_CD   := '';
    sORGNO          := sCustDept;
    sITFC_ID        := gvMCAInterfaceID;
    sPOUT_FILE_NAME := sAccFileName;

    myStr2NotNilChar(InputData.CANO           , sCANO           , Length(sCANO          ) );
    myStr2NotNilChar(InputData.ACNT_PRDT_CD   , sACNT_PRDT_CD   , Length(sACNT_PRDT_CD  ) );
    myStr2NotNilChar(InputData.SETN_BRNO      , sORGNO          , Length(sORGNO         ) );
    myStr2NotNilChar(InputData.WORK_DT        , sDate           , Length(sDate          ) );
    myStr2NotNilChar(InputData.ITFC_ID        , sITFC_ID        , Length(sITFC_ID       ) );
    myStr2NotNilChar(InputData.POUT_FILE_NAME , sPOUT_FILE_NAME , Length(sPOUT_FILE_NAME) );

    InputData._CANO           := #16;
    InputData._ACNT_PRDT_CD   := #16;
    InputData._SETN_BRNO      := #16;
    InputData._WORK_DT        := #16;
    InputData._ITFC_ID        := #16;
    InputData._POUT_FILE_NAME := #16;

    gf_MCALog(IntToStr(gvMCAFileCnt) + ' : ' + sAccFileName);
    gf_MCALog('Input.CANO                   : ' + InputData.CANO             );
    gf_MCALog('Input.ACNT_PRDT_CD           : ' + InputData.ACNT_PRDT_CD     );
    gf_MCALog('Input.SETN_BRNO              : ' + InputData.SETN_BRNO        );
    gf_MCALog('Input.sWORK_DT               : ' + InputData.WORK_DT          );
    gf_MCALog('Input.sITFC_ID               : ' + InputData.ITFC_ID          );
    gf_MCALog('Input.POUT_FILE_NAME         : ' + InputData.POUT_FILE_NAME   );

    Try
      if (m_hHKCommDLL <> 0) then
      begin
        Sleep(1000);
        //
        iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                    sizeof(TMCAHeader), sizeof(TTTC3808UI1));

        if iResult = 0 then
        begin
           sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
           exit;
        end;
      end else
      begin
        sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
        Exit;
      end;

      while True do
      begin
        EnterCriticalSection(gvMCACriticalSection);
        if gvMCAReceive then
        begin
          gvMCAReceive := False;
          gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
          LeaveCriticalSection(gvMCACriticalSection);

          if gvMCAResult <> 'Y' then
          begin
            sOut := '���� ó�� ����.';
            gf_MCALog('���� ó�� ����.');
            //Exit;
          end;
          Break;
        end;
        LeaveCriticalSection(gvMCACriticalSection);
        Application.ProcessMessages;
        Sleep(100);
      end; // while

      Result := true;

    Except
       On E: Exception do
       begin
          sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
          Exit;
       end;
    End;
  end; // if (sAccList > '') then

  gf_MCALog('MCA: [TTC3808U] �ֽ� ���� ���� ���� ����.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
//�Ÿ� Import Using MCA
// TODO: �ֽ� �Ÿ� Import - gf_HostMCAsngetTRInfo()
//------------------------------------------------------------------------------
function gf_tf_HostMCAsngetTRInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;
var
  sCustDept : string;

  iResult, i, iComPos: integer;

  sAccNo,
  sAccFileName: string;

  headerInfo : TMCAHeader; // ���� ������ DLL ��� ����

  InputData : TTTC3809UI; // �ֽ� �Ÿ� Input

  // Input ����
  sCANO           : string;
  sACNT_PRDT_CD   : string;

  sSize           : string;
  sORGNO          : string;
  sWORK_DT        : string;
  sITFC_ID        : string;
  sPOUT_FILE_NAME : string;
  sDATA_CNT       : string;

begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TTC3809U] �ֽ� �Ÿ� ���� ���� ����.');

  Result := false;

  sCustDept := '0' + gvDeptCode;

  gvMCAReceive := False;
  iResult := 0;

  // ��� �ʱ�ȭ
  GetMCAHeaderData(gcMCA_TR_E_TRADE, headerInfo);

  gf_MCALog('headerInfo.TR_Type          : ' + headerInfo.TR_Type          );
  gf_MCALog('headerInfo.Interface_id     : ' + headerInfo.Interface_id     );
  gf_MCALog('headerInfo.Encrypt_flag     : ' + headerInfo.Encrypt_flag     );
  gf_MCALog('headerInfo.Tr_name          : ' + headerInfo.Tr_name          );
  gf_MCALog('headerInfo.Scr_no           : ' + headerInfo.Scr_no           );
  gf_MCALog('headerInfo.Lang_id          : ' + headerInfo.Lang_id          );
  gf_MCALog('headerInfo.Mode_flag        : ' + headerInfo.Mode_flag        );
  gf_MCALog('headerInfo.Tr_cont          : ' + headerInfo.Tr_cont          );
  gf_MCALog('headerInfo.Co_cd            : ' + headerInfo.Co_cd            );
  gf_MCALog('headerInfo.Media_cd1        : ' + headerInfo.Media_cd1        );
  gf_MCALog('headerInfo.Media_cd2        : ' + headerInfo.Media_cd2        );
  gf_MCALog('headerInfo.Org_cd           : ' + headerInfo.Org_cd           );
  gf_MCALog('headerInfo.Seq_no           : ' + headerInfo.Seq_no           );
  gf_MCALog('headerInfo.Dept_cd          : ' + headerInfo.Dept_cd          );
  gf_MCALog('headerInfo.Emp_id           : ' + headerInfo.Emp_id           );
  gf_MCALog('headerInfo.Emp_seq          : ' + headerInfo.Emp_seq          );
  gf_MCALog('headerInfo.User_id          : ' + headerInfo.User_id          );
  gf_MCALog('headerInfo.Br_open_cd       : ' + headerInfo.Br_open_cd       );
  gf_MCALog('headerInfo.Acct_no          : ' + headerInfo.Acct_no          );
  gf_MCALog('headerInfo.MediaFlag        : ' + headerInfo.MediaFlag        );
  gf_MCALog('headerInfo.MediaFlag_Detail : ' + headerInfo.MediaFlag_Detail );
  gf_MCALog('headerInfo.Rt_cd            : ' + headerInfo.Rt_cd            );

  if (sAccList > '') then
  begin

    gf_MCALog('���º� �Ÿ� �ڷ� ����.');

    // Input ����
    FillChar(InputData,SizeOf(InputData),#32);

    // TTC3809U1
    //sSize := FormatFloat('0000', gcMCA_IN_ARRAY_SIZE_TRADE);
    //myStr2NotNilChar(InputData.SIZE, sSize, Length(sSize) );

    //gf_MCALog('InputData.SIZE              : ' + InputData.SIZE  );

    i:= 0;

    // ��� ���¼� ��ŭ ����
    while (sAccList > '') do
    begin

      // �ִ� ���� ��ŭ ����: ������ �ø��� �ʱ�ȭ
      if (i >= gcMCA_IN_STRING_SIZE_TRADE) then
      begin
        // ���ϸ� ���� ����
        Inc(gvMCAFileCnt);
        sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '_' // ���� ���ϸ�
                      + FormatFloat('000', gvMCAFileCnt)                   // ����
                      + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // Ȯ����
        gvMCAFtpFileList.Add(sAccFileName);

        // ���� ����Ʈ ���� �� ������ ���
        InputData._ACC_NO := #16;

        // TTC3809U
        sORGNO          := sCustDept;
        sITFC_ID        := gvMCAInterfaceID;
        sPOUT_FILE_NAME := sAccFileName;
        sDATA_CNT := FormatFloat('000', i);

        myStr2NotNilChar(InputData.SETN_BRNO      , sORGNO          , Length(sORGNO         ) );
        myStr2NotNilChar(InputData.WORK_DT        , sDate           , Length(sDate          ) );
        myStr2NotNilChar(InputData.ITFC_ID        , sITFC_ID        , Length(sITFC_ID       ) );
        myStr2NotNilChar(InputData.POUT_FILE_NAME , sPOUT_FILE_NAME , Length(sPOUT_FILE_NAME) );
        myStr2NotNilChar(InputData.DATA_CNT       , sDATA_CNT       , Length(sDATA_CNT      ) );

        InputData._SETN_BRNO      := #16;
        InputData._WORK_DT        := #16;
        InputData._ITFC_ID        := #16;
        InputData._POUT_FILE_NAME := #16;
        InputData._DATA_CNT       := #16;

        gf_MCALog('Input.SETN_BRNO             : ' + InputData.SETN_BRNO      );
        gf_MCALog('Input.sWORK_DT              : ' + InputData.WORK_DT        );
        gf_MCALog('Input.sITFC_ID              : ' + InputData.ITFC_ID        );
        gf_MCALog('Input.POUT_FILE_NAME        : ' + InputData.POUT_FILE_NAME );
        gf_MCALog('Input.DATA_CNT              : ' + InputData.DATA_CNT       );
        gf_MCALog(IntToStr(gvMCAFileCnt) + ' ��° ���� ���� : ' + sAccFileName);

        // �� �� ������ ��������
        Try
          if (m_hHKCommDLL <> 0) then
          begin
            Sleep(1000);
            //
            iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                        sizeof(TMCAHeader), sizeof(TTTC3809UI));

            if iResult = 0 then
            begin
              sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
              exit;
            end;

          end else
          begin
            sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
            Exit;
          end;

          while True do
          begin
            EnterCriticalSection(gvMCACriticalSection);
            if gvMCAReceive then
            begin
              gvMCAReceive := False;
              gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
              LeaveCriticalSection(gvMCACriticalSection);

              if gvMCAResult <> 'Y' then
              begin
                gf_MCALog('���� ó�� ����.');
                sOut := '���� ó�� ����.';
                gf_MCALog(sOut);
                //Exit;
              end;
              Break;
            end;
            LeaveCriticalSection(gvMCACriticalSection);
            Application.ProcessMessages;
            Sleep(100);
          end; // while

        Except
          On E: Exception do
          begin
            sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
            Exit;
          end;
        End;

        // �ʱ�ȭ
        FillChar(InputData,SizeOf(InputData),#32);

        i:= 0;
        //sSize := FormatFloat('0000', gcMCA_IN_ARRAY_SIZE_TRADE);
        //myStr2NotNilChar(InputData.SIZE, sSize, Length(sSize) );

        //gf_MCALog('InputData.SIZE              : ' + InputData.SIZE  );
      end; // if (i >= gcMCA_IN_ARRAY_SIZE_UPLOAD_ACC) then

      if Pos(',', sAccList) > 0 then
      begin
        // ó�� ��� ���� ã��.
        iComPos := Pos(',', sAccList);
        sAccNo := LeftStr(sAccList,iComPos-1);
        sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);
        //gf_MCALog('ó�� ��� ���¹�ȣ: ' + sAccNo);
        //gf_MCALog('ó���� ���� ���: ' + sAccList);
      end else
      begin
        sAccNo := '';
      end;

      sCANO           := LeftStr(sAccNo,8);
      sACNT_PRDT_CD   := Copy(sAccNo,9,2);

      myStr2NotNilChar(InputData.ACC_NO[i].CANO           , sCANO           , Length(sCANO          ) );
      myStr2NotNilChar(InputData.ACC_NO[i].ACNT_PRDT_CD   , sACNT_PRDT_CD   , Length(sACNT_PRDT_CD  ) );

      //InputData.OCCURS_IN1[i]._CANO           := #16;
      //InputData.OCCURS_IN1[i]._ACNT_PRDT_CD   := #16;

      gf_MCALog('Input[' + IntToStr(i) + '].CANO               : ' + InputData.ACC_NO[i].CANO             );
      gf_MCALog('Input[' + IntToStr(i) + '].ACNT_PRDT_CD       : ' + InputData.ACC_NO[i].ACNT_PRDT_CD     );

      Inc(i);
      
    end; // while (sAccList > '') do


    // ���ϸ� ���� ����
    Inc(gvMCAFileCnt);
    sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '_' // ���� ���ϸ�
                  + FormatFloat('000', gvMCAFileCnt)                   // ����
                  + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // Ȯ����
    gvMCAFtpFileList.Add(sAccFileName);

    // ���� ����Ʈ ���� �� ������ ���
    InputData._ACC_NO := #16;

    // TTC3809U
    sORGNO          := sCustDept;
    sITFC_ID        := gvMCAInterfaceID;
    sPOUT_FILE_NAME := sAccFileName;
    sDATA_CNT := FormatFloat('000', i);

    myStr2NotNilChar(InputData.SETN_BRNO      , sORGNO          , Length(sORGNO         ) );
    myStr2NotNilChar(InputData.WORK_DT        , sDate           , Length(sDate          ) );
    myStr2NotNilChar(InputData.ITFC_ID        , sITFC_ID        , Length(sITFC_ID       ) );
    myStr2NotNilChar(InputData.POUT_FILE_NAME , sPOUT_FILE_NAME , Length(sPOUT_FILE_NAME) );
    myStr2NotNilChar(InputData.DATA_CNT       , sDATA_CNT       , Length(sDATA_CNT      ) );

    InputData._SETN_BRNO      := #16;
    InputData._WORK_DT        := #16;
    InputData._ITFC_ID        := #16;
    InputData._POUT_FILE_NAME := #16;
    InputData._DATA_CNT     := #16;

    gf_MCALog('Input.SETN_BRNO             : ' + InputData.SETN_BRNO      );
    gf_MCALog('Input.sWORK_DT              : ' + InputData.WORK_DT        );
    gf_MCALog('Input.sITFC_ID              : ' + InputData.ITFC_ID        );
    gf_MCALog('Input.POUT_FILE_NAME        : ' + InputData.POUT_FILE_NAME );
    gf_MCALog('InputData.DATA_CNT          : ' + InputData.DATA_CNT       );
    gf_MCALog(IntToStr(gvMCAFileCnt) + ' ��° ���� ���� : ' + sAccFileName);

    Try
       if (m_hHKCommDLL <> 0) then
      begin
        Sleep(1000);
        // �Ÿ�
        iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                    sizeof(TMCAHeader), sizeof(TTTC3809UI));

        if iResult = 0 then
        begin
           sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
           exit;
        end;
      end else
      begin
        sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
        Exit;
      end;

      while True do
      begin
        EnterCriticalSection(gvMCACriticalSection);
        if gvMCAReceive then
        begin
          gvMCAReceive := False;
          gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
          LeaveCriticalSection(gvMCACriticalSection);

          if gvMCAResult <> 'Y' then
          begin
            sOut := '���� ó�� ����.';
            gf_MCALog('���� ó�� ����.');
            //Exit;
          end;
          Break;
        end;
        LeaveCriticalSection(gvMCACriticalSection);
        Application.ProcessMessages;
        Sleep(100);
      end; // while

      Result := True;

    Except
       On E: Exception do
       begin
          sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
          Exit;
       end;
    End;

  end else
  begin
    gf_MCALog('��ü �Ÿ� �ڷ� ����.');

    // TTC3809UI
    //sSize := FormatFloat('0000', gcMCA_IN_ARRAY_SIZE_TRADE);
    //myStr2NotNilChar(InputData.SIZE, sSize, Length(sSize) );

    //gf_MCALog('InputData.SIZE              : ' + InputData.SIZE  );

    // ��ü �Ÿ� ����Ʈ
    Inc(gvMCAFileCnt);
    sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '_' // ���� ���ϸ�
                  + FormatFloat('000', gvMCAFileCnt) + 'T'        // ����
                  + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // Ȯ����
    gvMCAFtpFileList.Add(sAccFileName);

    // Input ����
    FillChar(InputData,SizeOf(InputData),#32);

    sCANO           := '';
    sACNT_PRDT_CD   := '';
    sORGNO          := sCustDept;
    sITFC_ID        := gvMCAInterfaceID;
    sPOUT_FILE_NAME := sAccFileName;
    sDATA_CNT := '000';

    myStr2NotNilChar(InputData.ACC_NO[0].CANO           , sCANO           , Length(sCANO          ) );
    myStr2NotNilChar(InputData.ACC_NO[0].ACNT_PRDT_CD   , sACNT_PRDT_CD   , Length(sACNT_PRDT_CD  ) );
    myStr2NotNilChar(InputData.SETN_BRNO                    , sORGNO          , Length(sORGNO         ) );
    myStr2NotNilChar(InputData.WORK_DT                      , sDate           , Length(sDate          ) );
    myStr2NotNilChar(InputData.ITFC_ID                      , sITFC_ID        , Length(sITFC_ID       ) );
    myStr2NotNilChar(InputData.POUT_FILE_NAME               , sPOUT_FILE_NAME , Length(sPOUT_FILE_NAME) );
    myStr2NotNilChar(InputData.DATA_CNT                     , sDATA_CNT       , Length(sDATA_CNT      ) );

    //InputData.OCCURS_IN1[0]._CANO           := #16;
    //InputData.OCCURS_IN1[0]._ACNT_PRDT_CD   := #16;
    InputData._ACC_NO                       := #16;
    InputData._SETN_BRNO                    := #16;
    InputData._WORK_DT                      := #16;
    InputData._ITFC_ID                      := #16;
    InputData._POUT_FILE_NAME               := #16;
    InputData._DATA_CNT                     := #16;

    gf_MCALog('Input[0].CANO               : ' + InputData.ACC_NO[0].CANO             );
    gf_MCALog('Input[0].ACNT_PRDT_CD       : ' + InputData.ACC_NO[0].ACNT_PRDT_CD     );
    gf_MCALog('Input.SETN_BRNO             : ' + InputData.SETN_BRNO                      );
    gf_MCALog('Input.sWORK_DT              : ' + InputData.WORK_DT                        );
    gf_MCALog('Input.sITFC_ID              : ' + InputData.ITFC_ID                        );
    gf_MCALog('Input.POUT_FILE_NAME        : ' + InputData.POUT_FILE_NAME                 );
    gf_MCALog('Input.DATA_CNT              : ' + InputData.DATA_CNT                       );
    gf_MCALog(IntToStr(gvMCAFileCnt) + ' ��° ���� ���� : ' + sAccFileName);

    Try
       if (m_hHKCommDLL <> 0) then
      begin
        Sleep(1000);
        // �Ÿ�
        iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                    sizeof(TMCAHeader), sizeof(TTTC3809UI));

        if iResult = 0 then
        begin
           sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
           exit;
        end;
      end else
      begin
        sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
        Exit;
      end;

      while True do
      begin
        EnterCriticalSection(gvMCACriticalSection);
        if gvMCAReceive then
        begin
          gvMCAReceive := False;
          gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
          LeaveCriticalSection(gvMCACriticalSection);

          if gvMCAResult <> 'Y' then
          begin
            sOut := '���� ó�� ����.';
            gf_MCALog('���� ó�� ����.');
            //Exit;
          end;
          Break;
        end;
        LeaveCriticalSection(gvMCACriticalSection);
        Application.ProcessMessages;
        Sleep(100);
      end; // while

      Result := true;

    Except
       On E: Exception do
       begin
          sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
          Exit;
       end;
    End;

  end; // if (sAccList > '') then

  Result := True;

  gf_MCALog('MCA: [TTC3809U] �ֽ� �Ÿ� ���� ���� ����.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
//�ֽ� �������� ���� üũ Call (������)
// TODO: �ֽ� �������� ���� üũ - gf_tf_HostMCAprocessStlClose()
//>>>> �Ķ���� �� ���� <<<<
// 1. sWorkCode (�۾�����)
//      - 01: ��ȸ, 02: ���
// 2. sWorkAuthority (�۾�����)
//     - SN: ��Ʋ��(����ڱ���;�⺻��)
//     - 01: WINK
//     - SM: ��Ʋ��(�����ڱ���;���������� ���)
//------------------------------------------------------------------------------
function gf_tf_HostMCAprocessStlClose(sDate, sWorkCode, sWorkAuthority:string;
                                        var sOut:string) : boolean;
var
  sCustDept : string;

  iResult, i, iDataSeq: integer;

  headerInfo : TMCAHeader; // ��� ����

  InputData : TTSC6315UI; // Input

  // Input
  sSize              : string;

  // InputData�� �������� �÷��� ���� ��.
  sORGNO             : string;
  sCLSG_YN           : string;
  sPRCS_DVSN_CD      : string;
  sTRAD_DT           : string;
  sTRAD_STTL_PRCS_AFRS_DVSN_CD : string;
begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TSC6315U] �ֽ� ������������ ����.');
  gf_MCALog('�۾�����: ' + sWorkCode + ', ����: ' + sWorkAuthority);

  Result := false;

  iDataSeq := 0;

  sCustDept := '0' + gvDeptCode;

  gvMCAReceive := False;
  iResult := 0;

  // ��� �ʱ�ȭ
  GetMCAHeaderData(gcMCA_TR_E_CLOSE, headerInfo);

  gf_MCALog('headerInfo.TR_Type          [' + headerInfo.TR_Type          + ']');
  gf_MCALog('headerInfo.Interface_id     [' + headerInfo.Interface_id     + ']');
  gf_MCALog('headerInfo.Encrypt_flag     [' + headerInfo.Encrypt_flag     + ']');
  gf_MCALog('headerInfo.Tr_name          [' + headerInfo.Tr_name          + ']');
  gf_MCALog('headerInfo.Scr_no           [' + headerInfo.Scr_no           + ']');
  gf_MCALog('headerInfo.Lang_id          [' + headerInfo.Lang_id          + ']');
  gf_MCALog('headerInfo.Mode_flag        [' + headerInfo.Mode_flag        + ']');
  gf_MCALog('headerInfo.Tr_cont          [' + headerInfo.Tr_cont          + ']');
  gf_MCALog('headerInfo.Co_cd            [' + headerInfo.Co_cd            + ']');
  gf_MCALog('headerInfo.Media_cd1        [' + headerInfo.Media_cd1        + ']');
  gf_MCALog('headerInfo.Media_cd2        [' + headerInfo.Media_cd2        + ']');
  gf_MCALog('headerInfo.Org_cd           [' + headerInfo.Org_cd           + ']');
  gf_MCALog('headerInfo.Seq_no           [' + headerInfo.Seq_no           + ']');
  gf_MCALog('headerInfo.Dept_cd          [' + headerInfo.Dept_cd          + ']');
  gf_MCALog('headerInfo.Emp_id           [' + headerInfo.Emp_id           + ']');
  gf_MCALog('headerInfo.Emp_seq          [' + headerInfo.Emp_seq          + ']');
  gf_MCALog('headerInfo.User_id          [' + headerInfo.User_id          + ']');
  gf_MCALog('headerInfo.Br_open_cd       [' + headerInfo.Br_open_cd       + ']');
  gf_MCALog('headerInfo.Acct_no          [' + headerInfo.Acct_no          + ']');
  gf_MCALog('headerInfo.MediaFlag        [' + headerInfo.MediaFlag        + ']');
  gf_MCALog('headerInfo.MediaFlag_Detail [' + headerInfo.MediaFlag_Detail + ']');
  gf_MCALog('headerInfo.Rt_cd            [' + headerInfo.Rt_cd            + ']');

  // Input �ʱ�ȭ
  FillChar(InputData,SizeOf(InputData),#32);

  sPRCS_DVSN_CD     := sWorkCode; // 01: ��ȸ, 02: ���
  sTRAD_DT          := sDate;
  sTRAD_STTL_PRCS_AFRS_DVSN_CD := sWorkAuthority; // SN: ��Ʋ��, 01: WINK, SM : ��Ʋ�ݰ�����
  sORGNO            := sCustDept;
  // ���� ���(02) ��û�̸� ���� üũ
  if sWorkCode = '02' then
  begin
    if sWorkAuthority = 'SN' then
      sCLSG_YN := 'Y'
    else
    if sWorkAuthority = 'SM' then
      sCLSG_YN := 'N';
  end;

  // TSC6315UI
  myStr2NotNilChar(InputData.PRCS_DVSN_CD, sPRCS_DVSN_CD, Length(sPRCS_DVSN_CD) );
  myStr2NotNilChar(InputData.TRAD_DT,      sTRAD_DT,      Length(sTRAD_DT) );
  myStr2NotNilChar(InputData.TRAD_STTL_PRCS_AFRS_DVSN_CD,
                                           sTRAD_STTL_PRCS_AFRS_DVSN_CD,
                                                          Length(sTRAD_STTL_PRCS_AFRS_DVSN_CD) );
  myStr2NotNilChar(InputData.ORGNO,        sORGNO, Length(sORGNO) );
  // ���� ��û ó��
  if sWorkCode = '02' then
    myStr2NotNilChar(InputData.CLSG_YN , sCLSG_YN, Length(sCLSG_YN) );

  InputData._PRCS_DVSN_CD  := #16;
  InputData._TRAD_DT       := #16;
  InputData._TRAD_STTL_PRCS_AFRS_DVSN_CD := #16;
  InputData._ORGNO         := #16;
  InputData._CLSG_YN       := #16;
  
  gf_MCALog('- InputDta ----------------------------------------------------------');
  gf_MCALog('InputData.PRCS_DVSN_CD                [' + InputData.PRCS_DVSN_CD  + ']');
  gf_MCALog('InputData._PRCS_DVSN_CD               [' + InputData._PRCS_DVSN_CD + ']');
  gf_MCALog('InputData.TRAD_DT                     [' + InputData.TRAD_DT       + ']');
  gf_MCALog('InputData._TRAD_DT                    [' + InputData._TRAD_DT      + ']');
  gf_MCALog('InputData.TRAD_STTL_PRCS_AFRS_DVSN_CD [' + InputData.TRAD_STTL_PRCS_AFRS_DVSN_CD + ']');
  gf_MCALog('InputData._TRAD_STTL_PRCS_AFRS_DVSN_CD[' + InputData._TRAD_STTL_PRCS_AFRS_DVSN_CD +']');
  gf_MCALog('InputData.ORGNO                       [' + InputData.ORGNO         + ']');
  gf_MCALog('InputData._ORGNO                      [' + InputData._ORGNO        + ']');
  gf_MCALog('InputData.CLSG_YN                     [' + InputData.CLSG_YN       + ']');
  gf_MCALog('InputData._CLSG_YN                    [' + InputData._CLSG_YN      + ']');
  gf_MCALog('---------------------------------------------------------------------');

  Try
    if (m_hHKCommDLL <> 0) then
    begin
      Sleep(1000);
      //
      iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                   sizeof(TMCAHeader), sizeof(TTSC6315UI));

      if iResult = 0 then
      begin
        sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
        exit;
      end;

    end else
    begin
      sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
      Exit;
    end;

    while True do
    begin
      EnterCriticalSection(gvMCACriticalSection);
      if gvMCAReceive then
      begin
        gvMCAReceive := False;
        //gf_MCALog('CopyData OK. (gvMCAReceive = True) [Result:' + gvMCAResult + ']');
        LeaveCriticalSection(gvMCACriticalSection);

        if gvMCAResult <> 'Y' then
        begin
          sOut := '���� ó�� ����.';
          gf_MCALog('���� ó�� ����.');
          Exit;
        end;

        if (gvMCACloseResult <> 'Y') and
           (gvMCACloseResult <> 'N') then
        begin
          sOut := '�������� ���� ó�� ����. ';
          gf_MCALog('�������� ���� ó�� ����. ');
          Exit;
        end;
        Break;
      end; // if gvMCAReceive then
      LeaveCriticalSection(gvMCACriticalSection);
      Application.ProcessMessages;
      Sleep(100);
    end; // while

    Result := True;

  Except
    On E: Exception do
    begin
      sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
      Exit;
    end;
  End;

  gf_MCALog('MCA: [TSC6315U] �ֽ� ������������ ����.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
//MCA Upload Call
//WorkCode : �Է� '01', ���� '02', ���¹ݿ� '03'
// todo: �ֽ� �������� ���ε� - gf_HostMCAsnprocessUploadData()
//------------------------------------------------------------------------------
function gf_tf_HostMCAsnprocessUploadData(sDate, sFileName, sWorkCode:string;
          var sOut:string) : boolean;
var
  sCustDept, sZeroSpace : string;

  iResult, i, iDataSeq, iStrCnt: integer;

  headerInfo : TMCAHeader; // ��� ����

  InputData : TTTC6317UI; // Input

  // Input [Array]
  sSize                 : string;
  sCHNG_BF_CANO         : string; // FROM���հ��¹�ȣ
  sCHNG_BF_ACNT_PRDT_CD : string; // FROM���»�ǰ�ڵ�
  sORGT_ODNO            : string; // From�ֹ�����ȣ
  sCHNG_AF_CANO         : string; // TO���հ��¹�ȣ
  sCHNG_AF_ACNT_PRDT_CD : string; // TO���»�ǰ�ڵ�
  sOPNT_ODNO1           : string; // To�ֹ�����ȣ
  sPDNO                 : string; // ��ǰ�ڵ�
  sF_TRTX_TXTN_YN       : string; // From��������
  sT_TRTX_TXTN_YN       : string; // To��������
  sEXCG_DVSN_CD         : string; // �屸��
  sTRAN_MTD             : string; // �ŸŹ��
  sCOM_TYPE             : string; // ��ü����
  sSLL_BUY_DVSN_CD      : string; // �Ÿű���
  sGUBUN                : string; // �۾�����
  sMTRL_DVSN_CD         : string; // �ڷᱸ��

  dTRAD_FEE_RT          : double; // ��������
  dAVG_UNPR             : double; // ��մܰ�
  dSTTL_QTY             : double; // ����
  dAGRM_AMT             : double; // �����ݾ�
  dFEE                  : double; // ������
  dTAXA                 : double; // ������

  sTRAD_FEE_RT          : string; // ��������
  sAVG_UNPR             : string; // ��մܰ�
  sSTTL_QTY             : string; // ����
  sAGRM_AMT             : string; // �����ݾ�
  sFEE                  : string; // ������
  sTAXA                 : string; // ������

  // Input [Single]
  sWORK_DVSN_CD         : string;
  sADMN_ORGNO           : string;
  sTRAD_DT              : string;
  sDATA_CNT             : string;

  iLoofCnt: Integer;
begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TTC6317U] �ֽ� �Ÿ� ����/���� ���� ���ε� ����.');

  Result := false;

  iDataSeq := 0;

  sCustDept := '0' + gvDeptCode;

  gvMCAReceive := False;
  iResult := 0;

  // ��� ����
  GetMCAHeaderData(gcMCA_TR_E_UPLOAD, headerInfo);

  gf_MCALog('headerInfo.TR_Type          : ' + headerInfo.TR_Type          );
  gf_MCALog('headerInfo.Interface_id     : ' + headerInfo.Interface_id     );
  gf_MCALog('headerInfo.Encrypt_flag     : ' + headerInfo.Encrypt_flag     );
  gf_MCALog('headerInfo.Tr_name          : ' + headerInfo.Tr_name          );
  gf_MCALog('headerInfo.Scr_no           : ' + headerInfo.Scr_no           );
  gf_MCALog('headerInfo.Lang_id          : ' + headerInfo.Lang_id          );
  gf_MCALog('headerInfo.Mode_flag        : ' + headerInfo.Mode_flag        );
  gf_MCALog('headerInfo.Tr_cont          : ' + headerInfo.Tr_cont          );
  gf_MCALog('headerInfo.Co_cd            : ' + headerInfo.Co_cd            );
  gf_MCALog('headerInfo.Media_cd1        : ' + headerInfo.Media_cd1        );
  gf_MCALog('headerInfo.Media_cd2        : ' + headerInfo.Media_cd2        );
  gf_MCALog('headerInfo.Org_cd           : ' + headerInfo.Org_cd           );
  gf_MCALog('headerInfo.Seq_no           : ' + headerInfo.Seq_no           );
  gf_MCALog('headerInfo.Dept_cd          : ' + headerInfo.Dept_cd          );
  gf_MCALog('headerInfo.Emp_id           : ' + headerInfo.Emp_id           );
  gf_MCALog('headerInfo.Emp_seq          : ' + headerInfo.Emp_seq          );
  gf_MCALog('headerInfo.User_id          : ' + headerInfo.User_id          );
  gf_MCALog('headerInfo.Br_open_cd       : ' + headerInfo.Br_open_cd       );
  gf_MCALog('headerInfo.Acct_no          : ' + headerInfo.Acct_no          );
  gf_MCALog('headerInfo.MediaFlag        : ' + headerInfo.MediaFlag        );
  gf_MCALog('headerInfo.MediaFlag_Detail : ' + headerInfo.MediaFlag_Detail );
  gf_MCALog('headerInfo.Rt_cd            : ' + headerInfo.Rt_cd            );


  // Input ����
  with DataModule_SettleNet.ADOQuery_Main do
  begin

    // !!01:�Է� �ܿ��� ������ �ʿ����.
    if sWorkCode = '01' then
    begin
      // ���ε� ������ ��������(SEUPLOAD2_TBL)
      if Not GetSEUPLOAD2_TBL(DataModule_SettleNet.ADOQuery_Main,
              sFileName, sDate, sOut) then
      begin
        sOut := 'gf_tf_HostMCAsnprocessUploadData: ' + sOut;
        Exit;
      end;
      gf_MCALog('Upload Data GET. (SEUPLOAD2_TBL)');

    end; // if sWorkCode = '01' then

    // Input Structure �����̽� �ʱ�ȭ
    FillChar(InputData,SizeOf(InputData),#32);

    //
    sSize := FormatFloat('0000', gcMCA_IN_ARRAY_SIZE_UPLOAD);
    myStr2NotNilChar(InputData.SIZE, sSize, Length(sSize) );

    if (sWorkCode = '01') then
      gf_MCALog('InputData.SIZE            : ' + InputData.SIZE  );

    i:= 0;
    iLoofCnt := 0;
    if sWorkCode = '01' then
    begin
      First;

      while Not Eof do
      begin
        // ArraySize��ŭ ����: ������ �ø��� �ʱ�ȭ
        if (i >= gcMCA_IN_ARRAY_SIZE_UPLOAD) then
        begin
          // TTC6317UI2
          sWORK_DVSN_CD := sWorkCode;
          sADMN_ORGNO   := sCustDept;
          sTRAD_DT      := sDate;
          sDATA_CNT     := FormatFloat('000', i);

          myStr2NotNilChar(InputData.WORK_DVSN_CD, sWORK_DVSN_CD, Length(sWORK_DVSN_CD) );
          myStr2NotNilChar(InputData.ADMN_ORGNO  , sADMN_ORGNO  , Length(sADMN_ORGNO  ) );
          myStr2NotNilChar(InputData.TRAD_DT     , sTRAD_DT     , Length(sTRAD_DT     ) );
          myStr2NotNilChar(InputData.DATA_CNT    , sDATA_CNT    , Length(sDATA_CNT    ) );

          InputData._WORK_DVSN_CD := #16;
          InputData._ADMN_ORGNO   := #16;
          InputData._TRAD_DT      := #16;
          InputData._DATA_CNT     := #16;

          gf_MCALog('InputData.WORK_DVSN_CD   : ' + InputData.WORK_DVSN_CD  );
          gf_MCALog('InputData._WORK_DVSN_CD  : ' + InputData._WORK_DVSN_CD );
          gf_MCALog('InputData.ADMN_ORGNO     : ' + InputData.ADMN_ORGNO    );
          gf_MCALog('InputData._ADMN_ORGNO    : ' + InputData._ADMN_ORGNO   );
          gf_MCALog('InputData.TRAD_DT        : ' + InputData.TRAD_DT       );
          gf_MCALog('InputData._TRAD_DT       : ' + InputData._TRAD_DT      );
          gf_MCALog('InputData.DATA_CNT       : ' + InputData.DATA_CNT      );
          gf_MCALog('InputData._DATA_CNT      : ' + InputData._DATA_CNT     );

          // �� �� ������ ��������
          Try
            if (m_hHKCommDLL <> 0) then
            begin
              Sleep(1000);
              //
              iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                          sizeof(TMCAHeader), sizeof(TTTC6317UI));

              Inc(iLoofCnt);
              gf_MCALog('Packet : ' + IntToStr(iLoofCnt));

              if iResult = 0 then
              begin
                sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
                exit;
              end;

            end else
            begin
              sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
              Exit;
            end;

            while True do
            begin
              EnterCriticalSection(gvMCACriticalSection);
              if gvMCAReceive then
              begin
                gvMCAReceive := False;

                gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
                LeaveCriticalSection(gvMCACriticalSection);

                if gvMCAResult <> 'Y' then
                begin
                  gf_MCALog('���� ó�� ����.');
                  sOut := '���� ó�� ����.';
                  Exit;
                end;
                Break;
              end;
              LeaveCriticalSection(gvMCACriticalSection);
              Application.ProcessMessages;
              Sleep(100);
            end; // while

          Except
            On E: Exception do
            begin
              sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
              Exit;
            end;
          End;

          // �ʱ�ȭ
          FillChar(InputData,SizeOf(InputData),#32);

          i:= 0;
          sSize := FormatFloat('0000', gcMCA_IN_ARRAY_SIZE_UPLOAD);
          myStr2NotNilChar(InputData.SIZE, sSize, Length(sSize) );

          gf_MCALog('InputData.SIZE            : ' + InputData.SIZE  );
        end; // if (i >= gcMCA_IN_ARRAY_SIZE_UPLOAD) then

        sCHNG_BF_CANO        := LeftStr(Trim(FieldByName('F_ACC_NO').AsString),8);
        sCHNG_BF_ACNT_PRDT_CD:= Copy(Trim(FieldByName('F_ACC_NO').AsString),9,2);
        //sORGT_ODNO           := Trim(FieldByName('F_BRK_SHT_NO').AsString);
        sORGT_ODNO           := Copy(Trim(FieldByName('TRAN_CODE').AsString),3,1);
        sCHNG_AF_CANO        :=  LeftStr(Trim(FieldByName('T_ACC_NO').AsString),8);
        sCHNG_AF_ACNT_PRDT_CD:= Copy(Trim(FieldByName('T_ACC_NO').AsString),9,2);
        sOPNT_ODNO1          := Trim(FieldByName('T_BRK_SHT_NO').AsString);

        // ��ǰ��ȣ(�����ڵ�)
        sZeroSpace := '';
        for iStrCnt:=1 to SizeOf(InputData.OCCURS_IN1[i].PDNO)-
                          Length(Trim(FieldByName('ISSUE_CODE').AsString)) do
        begin
          sZeroSpace := sZeroSpace + '0';
        end;
        sPDNO := sZeroSpace + Trim(FieldByName('ISSUE_CODE').AsString);

        // From��������
        sF_TRTX_TXTN_YN      := Trim(FieldByName('F_TAXGBJJ_YN').AsString);
        // To��������
        sT_TRTX_TXTN_YN      := Trim(FieldByName('T_TAXGBJJ_YN').AsString);

        // �屸��
        sEXCG_DVSN_CD        := Copy(Trim(FieldByName('TRAN_CODE').AsString),2,1);
        // �ŸŹ��
        sTRAN_MTD            := Copy(Trim(FieldByName('TRAN_CODE').AsString),3,1);
        // ��ü����
        sCOM_TYPE            := Copy(Trim(FieldByName('TRAN_CODE').AsString),4,1);

        // �Ÿű���
        sSLL_BUY_DVSN_CD     := Trim(FieldByName('TRADE_TYPE').AsString);

        // �۾�����
        sGUBUN               := Trim(FieldByName('GUBUN').AsString);
        // �ڷᱸ��
        if Trim(FieldByName('DATA_GB').AsString) = 'T' then
          sMTRL_DVSN_CD      := '1'
        else
          sMTRL_DVSN_CD      := '2';

        // ��������
        dTRAD_FEE_RT         := (FieldByName('COMM_RATE').AsFloat);
        // ��մܰ�
        dAVG_UNPR            := (FieldByName('EXEC_PRICE').AsFloat);
        // ����
        dSTTL_QTY            := (FieldByName('EXEC_QTY').AsFloat);
        // �����ݾ�
        dAGRM_AMT            := (FieldByName('EXEC_AMT').AsFloat);
        // ������
        dFEE                 := (FieldByName('COMM').AsFloat);
        // ����
        dTAXA                := (FieldByName('TAX').AsFloat);

        sTRAD_FEE_RT  := FormatFloat('00000000000000.00000000', dTRAD_FEE_RT);
        sAVG_UNPR     := FormatFloat('000000000.00000000'     , dAVG_UNPR);
        sSTTL_QTY     := FormatFloat('0000000000'             , dSTTL_QTY);
        sAGRM_AMT     := FormatFloat('000000000000000000'     , dAGRM_AMT);
        sFEE          := FormatFloat('000000000000000000'     , dFEE);
        sTAXA         := FormatFloat('000000000000000000'     , dTAXA);

        myStr2NotNilChar(InputData.OCCURS_IN1[i].CHNG_BF_CANO         , sCHNG_BF_CANO         , Length(sCHNG_BF_CANO         ) );
        myStr2NotNilChar(InputData.OCCURS_IN1[i].CHNG_BF_ACNT_PRDT_CD , sCHNG_BF_ACNT_PRDT_CD , Length(sCHNG_BF_ACNT_PRDT_CD ) );
        myStr2NotNilChar(InputData.OCCURS_IN1[i].ORGT_ODNO            , sORGT_ODNO            , Length(sORGT_ODNO            ) );
        myStr2NotNilChar(InputData.OCCURS_IN1[i].CHNG_AF_CANO         , sCHNG_AF_CANO         , Length(sCHNG_AF_CANO         ) );
        myStr2NotNilChar(InputData.OCCURS_IN1[i].CHNG_AF_ACNT_PRDT_CD , sCHNG_AF_ACNT_PRDT_CD , Length(sCHNG_AF_ACNT_PRDT_CD ) );
        myStr2NotNilChar(InputData.OCCURS_IN1[i].OPNT_ODNO1           , sOPNT_ODNO1           , Length(sOPNT_ODNO1           ) );
        myStr2NotNilChar(InputData.OCCURS_IN1[i].PDNO                 , sPDNO                 , Length(sPDNO                 ) );
        myStr2NotNilChar(InputData.OCCURS_IN1[i].F_TRTX_TXTN_YN       , sF_TRTX_TXTN_YN       , Length(sF_TRTX_TXTN_YN       ) );
        myStr2NotNilChar(InputData.OCCURS_IN1[i].T_TRTX_TXTN_YN       , sT_TRTX_TXTN_YN       , Length(sT_TRTX_TXTN_YN       ) );
        myStr2NotNilChar(InputData.OCCURS_IN1[i].EXCG_DVSN_CD         , sEXCG_DVSN_CD         , Length(sEXCG_DVSN_CD         ) );
        myStr2NotNilChar(InputData.OCCURS_IN1[i].TRAN_MTD             , sTRAN_MTD             , Length(sTRAN_MTD             ) );
        myStr2NotNilChar(InputData.OCCURS_IN1[i].COM_TYPE             , sCOM_TYPE             , Length(sCOM_TYPE             ) );
        myStr2NotNilChar(InputData.OCCURS_IN1[i].SLL_BUY_DVSN_CD      , sSLL_BUY_DVSN_CD      , Length(sSLL_BUY_DVSN_CD      ) );
        myStr2NotNilChar(InputData.OCCURS_IN1[i].GUBUN                , sGUBUN                , Length(sGUBUN                ) );
        myStr2NotNilChar(InputData.OCCURS_IN1[i].MTRL_DVSN_CD         , sMTRL_DVSN_CD         , Length(sMTRL_DVSN_CD         ) );
        myStr2NotNilChar(InputData.OCCURS_IN1[i].TRAD_FEE_RT          , sTRAD_FEE_RT          , Length(sTRAD_FEE_RT          ) );
        myStr2NotNilChar(InputData.OCCURS_IN1[i].AVG_UNPR             , sAVG_UNPR             , Length(sAVG_UNPR             ) );
        myStr2NotNilChar(InputData.OCCURS_IN1[i].STTL_QTY             , sSTTL_QTY             , Length(sSTTL_QTY             ) );
        myStr2NotNilChar(InputData.OCCURS_IN1[i].AGRM_AMT             , sAGRM_AMT             , Length(sAGRM_AMT             ) );
        myStr2NotNilChar(InputData.OCCURS_IN1[i].FEE                  , sFEE                  , Length(sFEE                  ) );
        myStr2NotNilChar(InputData.OCCURS_IN1[i].TAXA                 , sTAXA                 , Length(sTAXA                 ) );

        InputData.OCCURS_IN1[i]._CHNG_BF_CANO         := #16;
        InputData.OCCURS_IN1[i]._CHNG_BF_ACNT_PRDT_CD := #16;
        InputData.OCCURS_IN1[i]._ORGT_ODNO            := #16;
        InputData.OCCURS_IN1[i]._CHNG_AF_CANO         := #16;
        InputData.OCCURS_IN1[i]._CHNG_AF_ACNT_PRDT_CD := #16;
        InputData.OCCURS_IN1[i]._OPNT_ODNO1           := #16;
        InputData.OCCURS_IN1[i]._PDNO                 := #16;
        InputData.OCCURS_IN1[i]._F_TRTX_TXTN_YN       := #16;
        InputData.OCCURS_IN1[i]._T_TRTX_TXTN_YN       := #16;
        InputData.OCCURS_IN1[i]._EXCG_DVSN_CD         := #16;
        InputData.OCCURS_IN1[i]._TRAN_MTD             := #16;
        InputData.OCCURS_IN1[i]._COM_TYPE             := #16;
        InputData.OCCURS_IN1[i]._SLL_BUY_DVSN_CD      := #16;
        InputData.OCCURS_IN1[i]._GUBUN                := #16;
        InputData.OCCURS_IN1[i]._MTRL_DVSN_CD         := #16;
        InputData.OCCURS_IN1[i]._TRAD_FEE_RT          := #16;
        InputData.OCCURS_IN1[i]._AVG_UNPR             := #16;
        InputData.OCCURS_IN1[i]._STTL_QTY             := #16;
        InputData.OCCURS_IN1[i]._AGRM_AMT             := #16;
        InputData.OCCURS_IN1[i]._FEE                  := #16;
        InputData.OCCURS_IN1[i]._TAXA                 := #16;
//{--
        gf_MCALog('');
        gf_MCALog('InputData[' + IntToStr(i) + '].CHNG_BF_CANO         : ' + InputData.OCCURS_IN1[i].CHNG_BF_CANO         );
        gf_MCALog('InputData[' + IntToStr(i) + '].CHNG_BF_ACNT_PRDT_CD : ' + InputData.OCCURS_IN1[i].CHNG_BF_ACNT_PRDT_CD );
        gf_MCALog('InputData[' + IntToStr(i) + '].ORGT_ODNO            : ' + InputData.OCCURS_IN1[i].ORGT_ODNO            );
        gf_MCALog('InputData[' + IntToStr(i) + '].CHNG_AF_CANO         : ' + InputData.OCCURS_IN1[i].CHNG_AF_CANO         );
        gf_MCALog('InputData[' + IntToStr(i) + '].CHNG_AF_ACNT_PRDT_CD : ' + InputData.OCCURS_IN1[i].CHNG_AF_ACNT_PRDT_CD );
        gf_MCALog('InputData[' + IntToStr(i) + '].OPNT_ODNO1           : ' + InputData.OCCURS_IN1[i].OPNT_ODNO1           );
        gf_MCALog('InputData[' + IntToStr(i) + '].PDNO                 : ' + InputData.OCCURS_IN1[i].PDNO                 );
        gf_MCALog('InputData[' + IntToStr(i) + '].F_TRTX_TXTN_YN       : ' + InputData.OCCURS_IN1[i].F_TRTX_TXTN_YN       );
        gf_MCALog('InputData[' + IntToStr(i) + '].T_TRTX_TXTN_YN       : ' + InputData.OCCURS_IN1[i].T_TRTX_TXTN_YN       );
        gf_MCALog('InputData[' + IntToStr(i) + '].EXCG_DVSN_CD         : ' + InputData.OCCURS_IN1[i].EXCG_DVSN_CD         );
        gf_MCALog('InputData[' + IntToStr(i) + '].TRAN_MTD             : ' + InputData.OCCURS_IN1[i].TRAN_MTD             );
        gf_MCALog('InputData[' + IntToStr(i) + '].COM_TYPE             : ' + InputData.OCCURS_IN1[i].COM_TYPE             );
        gf_MCALog('InputData[' + IntToStr(i) + '].SLL_BUY_DVSN_CD      : ' + InputData.OCCURS_IN1[i].SLL_BUY_DVSN_CD      );
        gf_MCALog('InputData[' + IntToStr(i) + '].GUBUN                : ' + InputData.OCCURS_IN1[i].GUBUN                );
        gf_MCALog('InputData[' + IntToStr(i) + '].MTRL_DVSN_CD         : ' + InputData.OCCURS_IN1[i].MTRL_DVSN_CD         );
        gf_MCALog('InputData[' + IntToStr(i) + '].TRAD_FEE_RT          : ' + InputData.OCCURS_IN1[i].TRAD_FEE_RT          );
        gf_MCALog('InputData[' + IntToStr(i) + '].AVG_UNPR             : ' + InputData.OCCURS_IN1[i].AVG_UNPR             );
        gf_MCALog('InputData[' + IntToStr(i) + '].STTL_QTY             : ' + InputData.OCCURS_IN1[i].STTL_QTY             );
        gf_MCALog('InputData[' + IntToStr(i) + '].AGRM_AMT             : ' + InputData.OCCURS_IN1[i].AGRM_AMT             );
        gf_MCALog('InputData[' + IntToStr(i) + '].FEE                  : ' + InputData.OCCURS_IN1[i].FEE                  );
        gf_MCALog('InputData[' + IntToStr(i) + '].TAXA                 : ' + InputData.OCCURS_IN1[i].TAXA                 );
//--}
        // ���� �ʱ�ȭ
        Inc(i);
          
        Next;
      end; // while Not Eof do

    end; // if sWorkCode = '01' then

    // TTC6317UI2
    sWORK_DVSN_CD := sWorkCode;
    sADMN_ORGNO   := sCustDept;
    sTRAD_DT      := sDate;

    if sWorkCode = '01' then
      sDATA_CNT   := FormatFloat('000', i)
    else
      sDATA_CNT   := '001';

    myStr2NotNilChar(InputData.WORK_DVSN_CD, sWORK_DVSN_CD, Length(sWORK_DVSN_CD) );
    myStr2NotNilChar(InputData.ADMN_ORGNO  , sADMN_ORGNO  , Length(sADMN_ORGNO  ) );
    myStr2NotNilChar(InputData.TRAD_DT     , sTRAD_DT     , Length(sTRAD_DT     ) );
    myStr2NotNilChar(InputData.DATA_CNT    , sDATA_CNT    , Length(sDATA_CNT    ) );

    InputData._WORK_DVSN_CD := #16;
    InputData._ADMN_ORGNO   := #16;
    InputData._TRAD_DT      := #16;
    InputData._DATA_CNT     := #16;
    
    gf_MCALog('InputData.WORK_DVSN_CD                       : ' + InputData.WORK_DVSN_CD  );
    gf_MCALog('InputData._WORK_DVSN_CD                      : ' + InputData._WORK_DVSN_CD );
    gf_MCALog('InputData.ADMN_ORGNO                         : ' + InputData.ADMN_ORGNO    );
    gf_MCALog('InputData._ADMN_ORGNO                        : ' + InputData._ADMN_ORGNO   );
    gf_MCALog('InputData.TRAD_DT                            : ' + InputData.TRAD_DT       );
    gf_MCALog('InputData._TRAD_DT                           : ' + InputData._TRAD_DT      );
    gf_MCALog('InputData.DATA_CNT                           : ' + InputData.DATA_CNT      );
    gf_MCALog('InputData._DATA_CNT                          : ' + InputData._DATA_CNT     );

  end; // with DataModule_SettleNet.ADOQuery_Main do

  Try
    if (m_hHKCommDLL <> 0) then
    begin
      Sleep(1000);
      //
      iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                  sizeof(TMCAHeader), sizeof(TTTC6317UI));

      Inc(iLoofCnt);
      gf_MCALog('Packet(Last) : ' + IntToStr(iLoofCnt));
                      
      if iResult = 0 then
      begin
        sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
        exit;
      end;

    end else
    begin
      sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
      Exit;
    end;

    while True do
    begin
      EnterCriticalSection(gvMCACriticalSection);
      if gvMCAReceive then
      begin
        gvMCAReceive := False;
        gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
        LeaveCriticalSection(gvMCACriticalSection);

        if gvMCAResult <> 'Y' then
        begin
          gf_MCALog('���� ó�� ����.');
          sOut := '���� ó�� ����.';
          Exit;
        end;
        Break;
      end; // if gvMCAReceive then
      LeaveCriticalSection(gvMCACriticalSection);
      Application.ProcessMessages;
      Sleep(100);
    end; // while

  Except
    On E: Exception do
    begin
      sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
      Exit;
    end;
  End;

  Result := true;

  gf_MCALog('MCA: [TTC6317U] �ֽ� �Ÿ� ����/���� ���� ���ε� ����.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
//MCA ���º� Upload Call
//WorkCode : �Է� '01', ���� '02'
// todo: �ֽ� ���º� ���ε� - gf_HostMCAsnprocessUploadACData
//------------------------------------------------------------------------------
function gf_tf_HostMCAsnprocessUploadACData(sDate, sFileName, sWorkCode, sDelType:string;
          var sOut:string) : boolean;
var
  sCustDept, sZeroSpace : string;

  iResult, i, iDataSeq, iStrCnt: integer;

  headerInfo : TMCAHeader; // ��� ����
  InputData : TTSC6307UI; // Input

  // Input
  sSize                 : string;
  sCHNG_BF_CANO         : string; // ���������հ��¹�ȣ
  sCHNG_BF_ACNT_PRDT_CD : string; // ���������»�ǰ�ڵ�
  sCHNG_AF_CANO         : string; // ���������հ��¹�ȣ
  sCHNG_AF_ACNT_PRDT_CD : string; // �����İ��»�ǰ�ڵ�
  sPDNO                 : string; // ��ǰ��ȣ          
  sEXCG_DVSN_CD         : string; // �ŷ��ұ����ڵ�    
  sTRTX_TXTN_YN         : string; // �ŷ�����������    
  sSTTL_ORD_DVSN_CD     : string; // �����ֹ������ڵ�  
  sORD_MDIA_DVSN_CD     : string; // �ֹ���ü�����ڵ�
  sSLL_BUY_DVSN_CD      : string; // �ŵ��ż������ڵ�
  sMTRL_DVSN_CD         : string; // �ڷᱸ���ڵ�      
  
  dSTTL_QTY             : double; // ��������
  dSTTL_PRIC            : double; // ��������
  dAVG_UNPR             : double; // ��մܰ�
  dSTTL_AMT             : double; // �����ݾ�
  dFEE                  : double; // ������
  dTAX_SMTL_AMT         : double; // �����հ�ݾ�

  sSTTL_QTY             : string; // ��������    
  sSTTL_PRIC            : string; // ��������    
  sAVG_UNPR             : string; // ��մܰ�    
  sSTTL_AMT             : string; // �����ݾ�    
  sFEE                  : string; // ������      
  sTAX_SMTL_AMT         : string; // �����հ�ݾ�

  sWORK_DVSN_CD         : string;
  sORGNO                : string;
  sTRAD_DT              : string;
  sDATA_CNT             : string;
begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TSC6307U] �ֽ� �Ÿ� ���� ���� ���ε� ����.');

  Result := false;

  iDataSeq := 0;

  sCustDept := '0' + gvDeptCode;

  gvMCAReceive := False;
  iResult := 0;

  // ��� ����
  GetMCAHeaderData(gcMCA_TR_E_UPLOAD_ACC, headerInfo);

  gf_MCALog('headerInfo.TR_Type          : ' + headerInfo.TR_Type          );
  gf_MCALog('headerInfo.Interface_id     : ' + headerInfo.Interface_id     );
  gf_MCALog('headerInfo.Encrypt_flag     : ' + headerInfo.Encrypt_flag     );
  gf_MCALog('headerInfo.Tr_name          : ' + headerInfo.Tr_name          );
  gf_MCALog('headerInfo.Scr_no           : ' + headerInfo.Scr_no           );
  gf_MCALog('headerInfo.Lang_id          : ' + headerInfo.Lang_id          );
  gf_MCALog('headerInfo.Mode_flag        : ' + headerInfo.Mode_flag        );
  gf_MCALog('headerInfo.Tr_cont          : ' + headerInfo.Tr_cont          );
  gf_MCALog('headerInfo.Co_cd            : ' + headerInfo.Co_cd            );
  gf_MCALog('headerInfo.Media_cd1        : ' + headerInfo.Media_cd1        );
  gf_MCALog('headerInfo.Media_cd2        : ' + headerInfo.Media_cd2        );
  gf_MCALog('headerInfo.Org_cd           : ' + headerInfo.Org_cd           );
  gf_MCALog('headerInfo.Seq_no           : ' + headerInfo.Seq_no           );
  gf_MCALog('headerInfo.Dept_cd          : ' + headerInfo.Dept_cd          );
  gf_MCALog('headerInfo.Emp_id           : ' + headerInfo.Emp_id           );
  gf_MCALog('headerInfo.Emp_seq          : ' + headerInfo.Emp_seq          );
  gf_MCALog('headerInfo.User_id          : ' + headerInfo.User_id          );
  gf_MCALog('headerInfo.Br_open_cd       : ' + headerInfo.Br_open_cd       );
  gf_MCALog('headerInfo.Acct_no          : ' + headerInfo.Acct_no          );
  gf_MCALog('headerInfo.MediaFlag        : ' + headerInfo.MediaFlag        );
  gf_MCALog('headerInfo.MediaFlag_Detail : ' + headerInfo.MediaFlag_Detail );
  gf_MCALog('headerInfo.Rt_cd            : ' + headerInfo.Rt_cd            );
                           
  // Input ����
  with DataModule_SettleNet.ADOQuery_Main do
  begin
    // DATA QUERY
    if sWorkCode = '01' then
    begin
      if Not GetSEUPLOAD2_TBL(DataModule_SettleNet.ADOQuery_Main,
              sFileName, sDate, sOut) then
      begin
        sOut := 'gf_tf_HostMCAsnprocessUploadData: ' + sOut;
        Exit;
      end;
      gf_MCALog('Upload Data GET. (Ins)');
    end else
    begin
      if Not GetAccUploadDelList(DataModule_SettleNet.ADOQuery_Main,
              sFileName, sDate, sDelType, sOut) then
      begin
        sOut := 'gf_tf_HostMCAsnprocessUploadData: ' + sOut;
        Exit;
      end;
      gf_MCALog('Upload Data GET. (Del: '+ sDelType +')');
    end;

    // Input Structure �����̽� �ʱ�ȭ
    FillChar(InputData,SizeOf(InputData),#32);

    // TSC6307UI2
    sSize := FormatFloat('0000', gcMCA_IN_ARRAY_SIZE_UPLOAD_ACC);
    myStr2NotNilChar(InputData.SIZE, sSize, Length(sSize) );

    gf_MCALog('InputData.SIZE              : ' + InputData.SIZE  );

    i:= 0;

    First;
    while Not Eof do
    begin

      // ArraySize��ŭ ����: ������ �ø��� �ʱ�ȭ
      if (i >= gcMCA_IN_ARRAY_SIZE_UPLOAD_ACC) then
      begin
        // TSC6307UI2
        sWORK_DVSN_CD := sWorkCode;
        sORGNO        := sCustDept;
        sTRAD_DT      := sDate;
        sDATA_CNT := FormatFloat('00000000', i);

        myStr2NotNilChar(InputData.WORK_DVSN_CD, sWORK_DVSN_CD, Length(sWORK_DVSN_CD) );
        myStr2NotNilChar(InputData.ORGNO       , sORGNO       , Length(sORGNO       ) );
        myStr2NotNilChar(InputData.TRAD_DT     , sTRAD_DT     , Length(sTRAD_DT     ) );
        myStr2NotNilChar(InputData.DATA_CNT    , sDATA_CNT    , Length(sDATA_CNT    ) );

        InputData._WORK_DVSN_CD := #16;
        InputData._ORGNO        := #16;
        InputData._TRAD_DT      := #16;
        InputData._DATA_CNT     := #16;

        gf_MCALog('');
        gf_MCALog('InputData.WORK_DVSN_CD  : ' + InputData.WORK_DVSN_CD  );
        gf_MCALog('InputData._WORK_DVSN_CD : ' + InputData._WORK_DVSN_CD );
        gf_MCALog('InputData.ORGNO         : ' + InputData.ORGNO         );
        gf_MCALog('InputData._ORGNO        : ' + InputData._ORGNO        );
        gf_MCALog('InputData.TRAD_DT       : ' + InputData.TRAD_DT       );
        gf_MCALog('InputData._TRAD_DT      : ' + InputData._TRAD_DT      );
        gf_MCALog('InputData.DATA_CNT      : ' + InputData.DATA_CNT      );
        gf_MCALog('InputData._DATA_CNT     : ' + InputData._DATA_CNT     );

        // �� �� ������ ��������
        Try
          if (m_hHKCommDLL <> 0) then
          begin
            Sleep(1000);
            //
            iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                        sizeof(TMCAHeader), sizeof(TTSC6307UI));

            if iResult = 0 then
            begin
              sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
              exit;
            end;

          end else
          begin
            sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
            Exit;
          end;

          while True do
          begin
            EnterCriticalSection(gvMCACriticalSection);
            if gvMCAReceive then
            begin
              gvMCAReceive := False;
              gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
              LeaveCriticalSection(gvMCACriticalSection);

              if gvMCAResult <> 'Y' then
              begin
                gf_MCALog('���� ó�� ����.');
                sOut := '���� ó�� ����.';
                gf_MCALog(sOut);
                Exit;
              end;
              Break;
            end;
            LeaveCriticalSection(gvMCACriticalSection);
            Application.ProcessMessages;
            Sleep(100);
          end; // while

        Except
          On E: Exception do
          begin
            sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
            Exit;
          end;
        End;

        // �ʱ�ȭ
        FillChar(InputData,SizeOf(InputData),#32);

        i:= 0;
        sSize := FormatFloat('0000', gcMCA_IN_ARRAY_SIZE_UPLOAD_ACC);
        myStr2NotNilChar(InputData.SIZE, sSize, Length(sSize) );

        gf_MCALog('InputData.SIZE              : ' + InputData.SIZE  );
      end; // if (i >= gcMCA_IN_ARRAY_SIZE_UPLOAD_ACC) then


      sCHNG_BF_CANO        := LeftStr(Trim(FieldByName('F_ACC_NO').AsString),8);
      sCHNG_BF_ACNT_PRDT_CD:= Copy(Trim(FieldByName('F_ACC_NO').AsString),9,2);
      sCHNG_AF_CANO        := LeftStr(Trim(FieldByName('T_ACC_NO').AsString),8);
      sCHNG_AF_ACNT_PRDT_CD:= Copy(Trim(FieldByName('T_ACC_NO').AsString),9,2);

      // ��ǰ��ȣ(�����ڵ�)
      sZeroSpace := '';
      for iStrCnt:=1 to SizeOf(InputData.OCCURS_IN1[i].PDNO)-
                        Length(Trim(FieldByName('ISSUE_CODE').AsString)) do
      begin
        sZeroSpace := sZeroSpace + '0';
      end;
      sPDNO := sZeroSpace + Trim(FieldByName('ISSUE_CODE').AsString);

      // �ŷ��ұ����ڵ�(01:���, 02:�ŷ���, 03:�ڽ���, 04:��������)
      if (Copy(Trim(FieldByName('TRAN_CODE').AsString),3,1) = '2') then
        sEXCG_DVSN_CD        := '01'  // ���(����)
      else
      if (Copy(Trim(FieldByName('TRAN_CODE').AsString),2,1) = '1') then
        sEXCG_DVSN_CD        := '02'  // �ŷ���
      else
      if (Copy(Trim(FieldByName('TRAN_CODE').AsString),2,1) = '2') then
        sEXCG_DVSN_CD        := '03'  // �ڽ���
      else
        sEXCG_DVSN_CD        := '01'; // �� ��(���)

      // �ŷ�����������(����f/t�� ��������)(Y:����, N:�����)
      sTRTX_TXTN_YN        := Trim(FieldByName('T_TAXGBJJ_YN').AsString);

      // �����ֹ������ڵ�(01:�Ϲ�, 02:����(or���α׷�), 11:��ȸ����Ź, 12:��ȸ����ǰ)
      if (Copy(Trim(FieldByName('TRAN_CODE').AsString),3,1) = '4') then
        sSTTL_ORD_DVSN_CD    := '02'
      else
        sSTTL_ORD_DVSN_CD    := '01';


      // �ֹ���ü�����ڵ�(01:OFFLINE, 02: ONLINE, 03:ARS, 04: �� ��)
      if (Copy(Trim(FieldByName('TRAN_CODE').AsString),4,1) = '1') or
         (Copy(Trim(FieldByName('TRAN_CODE').AsString),4,1) = 'A') then
        sORD_MDIA_DVSN_CD := '01'
      else
      if (Copy(Trim(FieldByName('TRAN_CODE').AsString),4,1) = '2') or
         (Copy(Trim(FieldByName('TRAN_CODE').AsString),4,1) = '3') then
        sORD_MDIA_DVSN_CD := '02'
      else
      if (Copy(Trim(FieldByName('TRAN_CODE').AsString),4,1) = '5') or
         (Copy(Trim(FieldByName('TRAN_CODE').AsString),4,1) = 'B') then
        sORD_MDIA_DVSN_CD := '03'
      else
        sORD_MDIA_DVSN_CD := '04';

      if (Trim(FieldByName('TRADE_TYPE').AsString) = 'S') then
        sSLL_BUY_DVSN_CD     := '01'
      else
      if (Trim(FieldByName('TRADE_TYPE').AsString) = 'B') then
        sSLL_BUY_DVSN_CD     := '02';

      // �ڷᱸ���ڵ�  
      sMTRL_DVSN_CD        := Trim(FieldByName('DATA_GB').AsString);
      dSTTL_QTY            :=     (FieldByName('EXEC_QTY').AsFloat);
      dSTTL_PRIC           :=     (FieldByName('EXEC_PRICE').AsFloat);
      dAVG_UNPR            := 0; //  ��մܰ�(0���� ä���)
      dSTTL_AMT            :=     (FieldByName('EXEC_AMT').AsFloat);
      dFEE                 :=     (FieldByName('COMM').AsFloat);
      dTAX_SMTL_AMT        :=     (FieldByName('TAX').AsFloat);

      sSTTL_QTY     := FormatFloat('0000000000'          , dSTTL_QTY);
      sSTTL_PRIC    := FormatFloat('0000000000'          , dSTTL_PRIC);
      sAVG_UNPR     := FormatFloat('00000000000000000000', dAVG_UNPR);
      sSTTL_AMT     := FormatFloat('000000000000000000'  , dSTTL_AMT);
      sFEE          := FormatFloat('000000000000000000'  , dFEE);
      sTAX_SMTL_AMT := FormatFloat('000000000000000000'  , dTAX_SMTL_AMT);

      myStr2NotNilChar(InputData.OCCURS_IN1[i].CHNG_BF_CANO         , sCHNG_BF_CANO        , Length(sCHNG_BF_CANO        ) );
      myStr2NotNilChar(InputData.OCCURS_IN1[i].CHNG_BF_ACNT_PRDT_CD , sCHNG_BF_ACNT_PRDT_CD, Length(sCHNG_BF_ACNT_PRDT_CD) );
      myStr2NotNilChar(InputData.OCCURS_IN1[i].CHNG_AF_CANO         , sCHNG_AF_CANO        , Length(sCHNG_AF_CANO        ) );
      myStr2NotNilChar(InputData.OCCURS_IN1[i].CHNG_AF_ACNT_PRDT_CD , sCHNG_AF_ACNT_PRDT_CD, Length(sCHNG_AF_ACNT_PRDT_CD) );
      myStr2NotNilChar(InputData.OCCURS_IN1[i].PDNO                 , sPDNO                , Length(sPDNO                ) );
      myStr2NotNilChar(InputData.OCCURS_IN1[i].EXCG_DVSN_CD         , sEXCG_DVSN_CD        , Length(sEXCG_DVSN_CD        ) );
      myStr2NotNilChar(InputData.OCCURS_IN1[i].TRTX_TXTN_YN         , sTRTX_TXTN_YN        , Length(sTRTX_TXTN_YN        ) );
      myStr2NotNilChar(InputData.OCCURS_IN1[i].STTL_ORD_DVSN_CD     , sSTTL_ORD_DVSN_CD    , Length(sSTTL_ORD_DVSN_CD    ) );
      myStr2NotNilChar(InputData.OCCURS_IN1[i].ORD_MDIA_DVSN_CD     , sORD_MDIA_DVSN_CD    , Length(sORD_MDIA_DVSN_CD    ) );
      myStr2NotNilChar(InputData.OCCURS_IN1[i].SLL_BUY_DVSN_CD      , sSLL_BUY_DVSN_CD     , Length(sSLL_BUY_DVSN_CD     ) );
      myStr2NotNilChar(InputData.OCCURS_IN1[i].MTRL_DVSN_CD         , sMTRL_DVSN_CD        , Length(sMTRL_DVSN_CD        ) );

      myStr2NotNilChar(InputData.OCCURS_IN1[i].STTL_QTY             , sSTTL_QTY            , Length(sSTTL_QTY            ) );
      myStr2NotNilChar(InputData.OCCURS_IN1[i].STTL_PRIC            , sSTTL_PRIC           , Length(sSTTL_PRIC           ) );
      myStr2NotNilChar(InputData.OCCURS_IN1[i].AVG_UNPR             , sAVG_UNPR            , Length(sAVG_UNPR            ) );
      myStr2NotNilChar(InputData.OCCURS_IN1[i].STTL_AMT             , sSTTL_AMT            , Length(sSTTL_AMT            ) );
      myStr2NotNilChar(InputData.OCCURS_IN1[i].FEE                  , sFEE                 , Length(sFEE                 ) );
      myStr2NotNilChar(InputData.OCCURS_IN1[i].TAX_SMTL_AMT         , sTAX_SMTL_AMT        , Length(sTAX_SMTL_AMT        ) );

      InputData.OCCURS_IN1[i]._CHNG_BF_CANO         := #16;
      InputData.OCCURS_IN1[i]._CHNG_BF_ACNT_PRDT_CD := #16;
      InputData.OCCURS_IN1[i]._CHNG_AF_CANO         := #16;
      InputData.OCCURS_IN1[i]._CHNG_AF_ACNT_PRDT_CD := #16;
      InputData.OCCURS_IN1[i]._PDNO                 := #16;
      InputData.OCCURS_IN1[i]._EXCG_DVSN_CD         := #16;
      InputData.OCCURS_IN1[i]._TRTX_TXTN_YN         := #16;
      InputData.OCCURS_IN1[i]._STTL_ORD_DVSN_CD     := #16;
      InputData.OCCURS_IN1[i]._ORD_MDIA_DVSN_CD     := #16;
      InputData.OCCURS_IN1[i]._SLL_BUY_DVSN_CD      := #16;
      InputData.OCCURS_IN1[i]._MTRL_DVSN_CD         := #16;
      InputData.OCCURS_IN1[i]._STTL_QTY             := #16;
      InputData.OCCURS_IN1[i]._STTL_PRIC            := #16;
      InputData.OCCURS_IN1[i]._AVG_UNPR             := #16;
      InputData.OCCURS_IN1[i]._STTL_AMT             := #16;
      InputData.OCCURS_IN1[i]._FEE                  := #16;
      InputData.OCCURS_IN1[i]._TAX_SMTL_AMT         := #16;

      if (sWorkCode = '01') then
      begin
        gf_MCALog('');
        gf_MCALog('InputData[' + IntToStr(i) + '].CHNG_BF_CANO         : ' + InputData.OCCURS_IN1[i].CHNG_BF_CANO         );
        gf_MCALog('InputData[' + IntToStr(i) + '].CHNG_BF_ACNT_PRDT_CD : ' + InputData.OCCURS_IN1[i].CHNG_BF_ACNT_PRDT_CD );
        gf_MCALog('InputData[' + IntToStr(i) + '].CHNG_AF_CANO         : ' + InputData.OCCURS_IN1[i].CHNG_AF_CANO         );
        gf_MCALog('InputData[' + IntToStr(i) + '].CHNG_AF_ACNT_PRDT_CD : ' + InputData.OCCURS_IN1[i].CHNG_AF_ACNT_PRDT_CD );
        gf_MCALog('InputData[' + IntToStr(i) + '].PDNO                 : ' + InputData.OCCURS_IN1[i].PDNO                 );
        gf_MCALog('InputData[' + IntToStr(i) + '].EXCG_DVSN_CD         : ' + InputData.OCCURS_IN1[i].EXCG_DVSN_CD         );
        gf_MCALog('InputData[' + IntToStr(i) + '].TRTX_TXTN_YN         : ' + InputData.OCCURS_IN1[i].TRTX_TXTN_YN         );
        gf_MCALog('InputData[' + IntToStr(i) + '].STTL_ORD_DVSN_CD     : ' + InputData.OCCURS_IN1[i].STTL_ORD_DVSN_CD     );
        gf_MCALog('InputData[' + IntToStr(i) + '].ORD_MDIA_DVSN_CD     : ' + InputData.OCCURS_IN1[i].ORD_MDIA_DVSN_CD     );
        gf_MCALog('InputData[' + IntToStr(i) + '].SLL_BUY_DVSN_CD      : ' + InputData.OCCURS_IN1[i].SLL_BUY_DVSN_CD      );
        gf_MCALog('InputData[' + IntToStr(i) + '].MTRL_DVSN_CD         : ' + InputData.OCCURS_IN1[i].MTRL_DVSN_CD         );
        gf_MCALog('InputData[' + IntToStr(i) + '].STTL_QTY             : ' + InputData.OCCURS_IN1[i].STTL_QTY             );
        gf_MCALog('InputData[' + IntToStr(i) + '].STTL_PRIC            : ' + InputData.OCCURS_IN1[i].STTL_PRIC            );
        gf_MCALog('InputData[' + IntToStr(i) + '].AVG_UNPR             : ' + InputData.OCCURS_IN1[i].AVG_UNPR             );
        gf_MCALog('InputData[' + IntToStr(i) + '].STTL_AMT             : ' + InputData.OCCURS_IN1[i].STTL_AMT             );
        gf_MCALog('InputData[' + IntToStr(i) + '].FEE                  : ' + InputData.OCCURS_IN1[i].FEE                  );
        gf_MCALog('InputData[' + IntToStr(i) + '].TAX_SMTL_AMT         : ' + InputData.OCCURS_IN1[i].TAX_SMTL_AMT         );
      end; // if (sWorkCode = '01') then

      // ���� �ʱ�ȭ
      Inc(i);
        
      Next;
    end; // while Not Eof do
    // TSC6307UI2
    sWORK_DVSN_CD := sWorkCode;
    sORGNO        := sCustDept;
    sTRAD_DT      := sDate;
    sDATA_CNT := FormatFloat('00000000', i);

    myStr2NotNilChar(InputData.WORK_DVSN_CD, sWORK_DVSN_CD, Length(sWORK_DVSN_CD) );
    myStr2NotNilChar(InputData.ORGNO       , sORGNO       , Length(sORGNO       ) );
    myStr2NotNilChar(InputData.TRAD_DT     , sTRAD_DT     , Length(sTRAD_DT     ) );
    myStr2NotNilChar(InputData.DATA_CNT    , sDATA_CNT    , Length(sDATA_CNT    ) );

    InputData._WORK_DVSN_CD := #16;
    InputData._ORGNO        := #16;
    InputData._TRAD_DT      := #16;
    InputData._DATA_CNT     := #16;

    gf_MCALog('');
    gf_MCALog('InputData.WORK_DVSN_CD  : ' + InputData.WORK_DVSN_CD  );
    gf_MCALog('InputData._WORK_DVSN_CD : ' + InputData._WORK_DVSN_CD );
    gf_MCALog('InputData.ORGNO         : ' + InputData.ORGNO         );
    gf_MCALog('InputData._ORGNO        : ' + InputData._ORGNO        );
    gf_MCALog('InputData.TRAD_DT       : ' + InputData.TRAD_DT       );
    gf_MCALog('InputData._TRAD_DT      : ' + InputData._TRAD_DT      );
    gf_MCALog('InputData.DATA_CNT      : ' + InputData.DATA_CNT      );
    gf_MCALog('InputData._DATA_CNT     : ' + InputData._DATA_CNT     );

  end; // with DataModule_SettleNet.ADOQuery_Main do

  Try
    if (m_hHKCommDLL <> 0) then
    begin
      Sleep(1000);
      //
      gf_MCALog('m_pRequestData() - Last: ' + IntToStr(i));
      iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                  sizeof(TMCAHeader), sizeof(TTSC6307UI));

      if iResult = 0 then
      begin
        sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
        exit;
      end;

    end else
    begin
      sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
      Exit;
    end;

    while True do
    begin
      EnterCriticalSection(gvMCACriticalSection);
      if gvMCAReceive then
      begin
        gvMCAReceive := False;
          
        gf_MCALog('CopyData OK. (gvMCAReceive = True) [Result:' + gvMCAResult + ']');
        LeaveCriticalSection(gvMCACriticalSection);

        if gvMCAResult <> 'Y' then
        begin
          gf_MCALog('���� ó�� ����.');
          sOut := '���� ó�� ����.';
          Exit;
        end;
        Break;
      end; // if gvMCAReceive then
      LeaveCriticalSection(gvMCACriticalSection);
      Application.ProcessMessages;
      Sleep(100);
    end; // while

  Except
    On E: Exception do
    begin
      sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
      Exit;
    end;
  End;

  Result := true;

  gf_MCALog('MCA: [TSC6307U] �ֽ� �Ÿ� ���� ���� ���ε� ����.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
//�ֽ� ������ ��� ó�� Call (������)
// TODO: �ֽ� �������� ó�� - gf_HostMCACalculate()
//------------------------------------------------------------------------------
function gf_tf_HostMCACalculate(
          sIssueCode, sTranCode, sTrdType, sAccNo, sStlDate: string;
          dAvrExecPrice, dTotExecQty, dTotExecAmt: double;
          var dComm, dTrdTax, dAgcTax, dCpgTax, dNetAmt, dHCommRate: double;
          var sOut : string) : boolean;
var
  sCustDept, sZeroSpace: string;

  iResult, i, iDataSeq, iStrCnt: integer;

  headerInfo : TMCAHeader; // ��� ����
  InputData  : TTSC3220RI1; // Input

  // Input
  sEXCG_DVSN_CD     : string; // �ŷ��ұ����ڵ�
  sPDNO             : string; // ��ǰ��ȣ
  sPRDT_TYPE_CD     : string; // ��ǰ�����ڵ�
  sSLL_BUY_DVSN_CD  : string; // �ŵ��ż������ڵ�
  sTRTX_TXTN_YN     : string; // �ŷ�����������
  sORD_MDIA_DVSN_CD : string; // �ֹ���ü�����ڵ�
  sCANO             : string; // ���հ��¹�ȣ
  sACNT_PRDT_CD     : string; // ���»�ǰ�ڵ�
  sSTTL_DT          : string; // ��������

  sAVG_UNPR         : string; // ��մܰ�
  sTOT_CCLD_QTY     : string; // ��ü�����
  sTOT_CCLD_AMT     : string; // ��ü��ݾ�

  sComm,   sTrdTax, sAgcTax,
  sCpgTax, sNetAmt, sHCommRate : string;
begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TSC3220R] �ֽ� ������ ��� ����.');
  
  Result := false;

  iDataSeq := 0;

  sCustDept := '0' + gvDeptCode;

  gvMCAReceive := False;
  iResult := 0;

  // ��� ����
  GetMCAHeaderData(gcMCA_TR_E_CALC_COMM, headerInfo);
    
  gf_MCALog('headerInfo.cTR_Type          : ' + headerInfo.TR_Type          );
  gf_MCALog('headerInfo.cInterface_id     : ' + headerInfo.Interface_id     );
  gf_MCALog('headerInfo.cEncrypt_flag     : ' + headerInfo.Encrypt_flag     );
  gf_MCALog('headerInfo.cTr_name          : ' + headerInfo.Tr_name          );
  gf_MCALog('headerInfo.cScr_no           : ' + headerInfo.Scr_no           );
  gf_MCALog('headerInfo.cLang_id          : ' + headerInfo.Lang_id          );
  gf_MCALog('headerInfo.cMode_flag        : ' + headerInfo.Mode_flag        );
  gf_MCALog('headerInfo.cTr_cont          : ' + headerInfo.Tr_cont          );
  gf_MCALog('headerInfo.cCo_cd            : ' + headerInfo.Co_cd            );
  gf_MCALog('headerInfo.cMedia_cd1        : ' + headerInfo.Media_cd1        );
  gf_MCALog('headerInfo.cMedia_cd2        : ' + headerInfo.Media_cd2        );
  gf_MCALog('headerInfo.cOrg_cd           : ' + headerInfo.Org_cd           );
  gf_MCALog('headerInfo.cSeq_no           : ' + headerInfo.Seq_no           );
  gf_MCALog('headerInfo.cDept_cd          : ' + headerInfo.Dept_cd          );
  gf_MCALog('headerInfo.cEmp_id           : ' + headerInfo.Emp_id           );
  gf_MCALog('headerInfo.cEmp_seq          : ' + headerInfo.Emp_seq          );
  gf_MCALog('headerInfo.cUser_id          : ' + headerInfo.User_id          );
  gf_MCALog('headerInfo.cBr_open_cd       : ' + headerInfo.Br_open_cd       );
  gf_MCALog('headerInfo.cAcct_no          : ' + headerInfo.Acct_no          );
  gf_MCALog('headerInfo.cMediaFlag        : ' + headerInfo.MediaFlag        );
  gf_MCALog('headerInfo.cMediaFlag_Detail : ' + headerInfo.MediaFlag_Detail );
  gf_MCALog('headerInfo.cRt_cd            : ' + headerInfo.Rt_cd            );

  // Input Structure �����̽� �ʱ�ȭ
  FillChar(InputData,SizeOf(InputData),#32);

  // �ŷ��ұ����ڵ�
  if (Copy(sTranCode,2,1) = '1') then sEXCG_DVSN_CD := '02'
  else
  if (Copy(sTranCode,2,1) = '2') then sEXCG_DVSN_CD := '03'
  else
    sEXCG_DVSN_CD := '01';

  // ��ǰ��ȣ(�����ڵ�)
  sZeroSpace := '';
  for iStrCnt:=1 to SizeOf(InputData.PDNO)-
                    Length(sIssueCode) do
  begin
    sZeroSpace := sZeroSpace + '0';
  end;
  sPDNO := sZeroSpace + sIssueCode;

  // ��ǰ�����ڵ�
  sPRDT_TYPE_CD := '300';

  // �ŵ��ż������ڵ�
  if (sTrdType = 'S') then sSLL_BUY_DVSN_CD     := '01'
  else
  if (sTrdType = 'B') then sSLL_BUY_DVSN_CD     := '02';

  // �ŷ�����������
  if (Copy(sTranCode,4,1) = '1') or
     (Copy(sTranCode,4,1) = '2') or
     (Copy(sTranCode,4,1) = '5') or
     (Copy(sTranCode,4,1) = '6') then sTRTX_TXTN_YN := 'Y'
  else
  if (Copy(sTranCode,4,1) = '3') or
     (Copy(sTranCode,4,1) = 'A') or
     (Copy(sTranCode,4,1) = 'B') or
     (Copy(sTranCode,4,1) = 'C') then sTRTX_TXTN_YN := 'N'
  else
    sTRTX_TXTN_YN := 'N';

  // �ֹ���ü�����ڵ�
  if (Copy(sTranCode,4,1) = '1') or
     (Copy(sTranCode,4,1) = 'A') then sORD_MDIA_DVSN_CD := '01'
  else
  if (Copy(sTranCode,4,1) = '2') or
     (Copy(sTranCode,4,1) = '3') then sORD_MDIA_DVSN_CD := '02'
  else
  if (Copy(sTranCode,4,1) = '5') or
     (Copy(sTranCode,4,1) = 'B') then sORD_MDIA_DVSN_CD := '03'
  else
    sORD_MDIA_DVSN_CD := '04';

  // ���հ��¹�ȣ
  sCANO := LeftStr(sAccNo,8);

  // ���»�ǰ�ڵ�
  sACNT_PRDT_CD := Copy(sAccNo,9,2);

  // ��������
  sSTTL_DT := sStlDate;

  // ��մܰ�
  sAVG_UNPR     := FormatFloat('0000000000.0000000000',dAvrExecPrice);
  sAVG_UNPR     := StringReplace(sAVG_UNPR,'.','',[rfReplaceAll]);

  // ��ü�����
  sTOT_CCLD_QTY := FormatFloat('0000000000', dTotExecQty);

  // ��ü��ݾ�
  sTOT_CCLD_AMT := FormatFloat('000000000000000000', dTotExecAmt);

  myStr2NotNilChar(InputData.EXCG_DVSN_CD    , sEXCG_DVSN_CD    , Length(sEXCG_DVSN_CD    ) );
  myStr2NotNilChar(InputData.PDNO            , sPDNO            , Length(sPDNO            ) );
  myStr2NotNilChar(InputData.PRDT_TYPE_CD    , sPRDT_TYPE_CD    , Length(sPRDT_TYPE_CD    ) );
  myStr2NotNilChar(InputData.SLL_BUY_DVSN_CD , sSLL_BUY_DVSN_CD , Length(sSLL_BUY_DVSN_CD ) );
  myStr2NotNilChar(InputData.TRTX_TXTN_YN    , sTRTX_TXTN_YN    , Length(sTRTX_TXTN_YN    ) );
  myStr2NotNilChar(InputData.ORD_MDIA_DVSN_CD, sORD_MDIA_DVSN_CD, Length(sORD_MDIA_DVSN_CD) );
  myStr2NotNilChar(InputData.CANO            , sCANO            , Length(sCANO            ) );
  myStr2NotNilChar(InputData.ACNT_PRDT_CD    , sACNT_PRDT_CD    , Length(sACNT_PRDT_CD    ) );
  myStr2NotNilChar(InputData.STTL_DT         , sSTTL_DT         , Length(sSTTL_DT         ) );
    
  myStr2NotNilChar(InputData.AVG_UNPR        , sAVG_UNPR         , Length(sAVG_UNPR       ) );
  myStr2NotNilChar(InputData.TOT_CCLD_QTY    , sTOT_CCLD_QTY     , Length(sTOT_CCLD_QTY   ) );
  myStr2NotNilChar(InputData.TOT_CCLD_AMT    , sTOT_CCLD_AMT     , Length(sTOT_CCLD_AMT   ) );

  InputData._EXCG_DVSN_CD     := #16;
  InputData._PDNO             := #16;
  InputData._PRDT_TYPE_CD     := #16;
  InputData._SLL_BUY_DVSN_CD  := #16;
  InputData._TRTX_TXTN_YN     := #16;
  InputData._ORD_MDIA_DVSN_CD := #16;
  InputData._CANO             := #16;
  InputData._ACNT_PRDT_CD     := #16;
  InputData._STTL_DT          := #16;

  InputData._AVG_UNPR         := #16;
  InputData._TOT_CCLD_QTY     := #16;
  InputData._TOT_CCLD_AMT     := #16;

  gf_MCALog('InputData. EXCG_DVSN_CD     : ' + InputData.EXCG_DVSN_CD      );
  gf_MCALog('InputData._EXCG_DVSN_CD     : ' + InputData._EXCG_DVSN_CD     );
  gf_MCALog('InputData. PDNO             : ' + InputData.PDNO              );
  gf_MCALog('InputData._PDNO             : ' + InputData._PDNO             );
  gf_MCALog('InputData. PRDT_TYPE_CD     : ' + InputData.PRDT_TYPE_CD      );
  gf_MCALog('InputData._PRDT_TYPE_CD     : ' + InputData._PRDT_TYPE_CD     );
  gf_MCALog('InputData. SLL_BUY_DVSN_CD  : ' + InputData.SLL_BUY_DVSN_CD   );
  gf_MCALog('InputData._SLL_BUY_DVSN_CD  : ' + InputData._SLL_BUY_DVSN_CD  );
  gf_MCALog('InputData. TRTX_TXTN_YN     : ' + InputData.TRTX_TXTN_YN      );
  gf_MCALog('InputData._TRTX_TXTN_YN     : ' + InputData._TRTX_TXTN_YN     );
  gf_MCALog('InputData. ORD_MDIA_DVSN_CD : ' + InputData.ORD_MDIA_DVSN_CD  );
  gf_MCALog('InputData._ORD_MDIA_DVSN_CD : ' + InputData._ORD_MDIA_DVSN_CD );
  gf_MCALog('InputData. CANO             : ' + InputData.CANO              );
  gf_MCALog('InputData._CANO             : ' + InputData._CANO             );
  gf_MCALog('InputData. ACNT_PRDT_CD     : ' + InputData.ACNT_PRDT_CD      );
  gf_MCALog('InputData._ACNT_PRDT_CD     : ' + InputData._ACNT_PRDT_CD     );
  gf_MCALog('InputData. STTL_DT          : ' + InputData.STTL_DT           );
  gf_MCALog('InputData._STTL_DT          : ' + InputData._STTL_DT          );
  gf_MCALog('InputData. AVG_UNPR         : ' + InputData.AVG_UNPR          );
  gf_MCALog('InputData._AVG_UNPR         : ' + InputData._AVG_UNPR         );
  gf_MCALog('InputData. TOT_CCLD_QTY     : ' + InputData.TOT_CCLD_QTY      );
  gf_MCALog('InputData._TOT_CCLD_QTY     : ' + InputData._TOT_CCLD_QTY     );
  gf_MCALog('InputData. TOT_CCLD_AMT     : ' + InputData.TOT_CCLD_AMT      );
  gf_MCALog('InputData._TOT_CCLD_AMT     : ' + InputData._TOT_CCLD_AMT     );

  Try
    if (m_hHKCommDLL <> 0) then
    begin
      Sleep(1000);
      //
      iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                  sizeof(TMCAHeader), sizeof(TTSC3220RI1));

      if iResult = 0 then
      begin
        sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
        exit;
      end;

    end else
    begin
      sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
      Exit;
    end;

    while True do
    begin
      EnterCriticalSection(gvMCACriticalSection);
      if gvMCAReceive then
      begin
        gvMCAReceive := False;
        gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
        LeaveCriticalSection(gvMCACriticalSection);

        if gvMCAResult <> 'Y' then
        begin
          gf_MCALog('���� ó�� ����.');
          sOut := '���� ó�� ����.';
          Exit;
        end else
        // ����ó�� ������ �������� �� �ֱ�
        begin
          gf_MCALog('InputData.EXCG_DVSN_CD     : [Sent]' + gf_MoveDataStr(Trim(InputData.EXCG_DVSN_CD    ),21) + ' [Receive]' + gf_MoveDataStr(Trim(gvMCAInputData_CalcComm.EXCG_DVSN_CD    ),21) );
          gf_MCALog('InputData.PDNO             : [Sent]' + gf_MoveDataStr(Trim(InputData.PDNO            ),21) + ' [Receive]' + gf_MoveDataStr(Trim(gvMCAInputData_CalcComm.PDNO            ),21) );
          gf_MCALog('InputData.PRDT_TYPE_CD     : [Sent]' + gf_MoveDataStr(Trim(InputData.PRDT_TYPE_CD    ),21) + ' [Receive]' + gf_MoveDataStr(Trim(gvMCAInputData_CalcComm.PRDT_TYPE_CD    ),21) );
          gf_MCALog('InputData.SLL_BUY_DVSN_CD  : [Sent]' + gf_MoveDataStr(Trim(InputData.SLL_BUY_DVSN_CD ),21) + ' [Receive]' + gf_MoveDataStr(Trim(gvMCAInputData_CalcComm.SLL_BUY_DVSN_CD ),21) );
          gf_MCALog('InputData.TRTX_TXTN_YN     : [Sent]' + gf_MoveDataStr(Trim(InputData.TRTX_TXTN_YN    ),21) + ' [Receive]' + gf_MoveDataStr(Trim(gvMCAInputData_CalcComm.TRTX_TXTN_YN    ),21) );
          gf_MCALog('InputData.ORD_MDIA_DVSN_CD : [Sent]' + gf_MoveDataStr(Trim(InputData.ORD_MDIA_DVSN_CD),21) + ' [Receive]' + gf_MoveDataStr(Trim(gvMCAInputData_CalcComm.ORD_MDIA_DVSN_CD),21) );
          gf_MCALog('InputData.CANO             : [Sent]' + gf_MoveDataStr(Trim(InputData.CANO            ),21) + ' [Receive]' + gf_MoveDataStr(Trim(gvMCAInputData_CalcComm.CANO            ),21) );
          gf_MCALog('InputData.ACNT_PRDT_CD     : [Sent]' + gf_MoveDataStr(Trim(InputData.ACNT_PRDT_CD    ),21) + ' [Receive]' + gf_MoveDataStr(Trim(gvMCAInputData_CalcComm.ACNT_PRDT_CD    ),21) );
          gf_MCALog('InputData.STTL_DT          : [Sent]' + gf_MoveDataStr(Trim(InputData.STTL_DT         ),21) + ' [Receive]' + gf_MoveDataStr(Trim(gvMCAInputData_CalcComm.STTL_DT         ),21) );
          gf_MCALog('InputData.AVG_UNPR         : [Sent]' + gf_MoveDataStr(Trim(InputData.AVG_UNPR        ),21) + ' [Receive]' + gf_MoveDataStr(Trim(gvMCAInputData_CalcComm.AVG_UNPR        ),21) );
          gf_MCALog('InputData.TOT_CCLD_QTY     : [Sent]' + gf_MoveDataStr(Trim(InputData.TOT_CCLD_QTY    ),21) + ' [Receive]' + gf_MoveDataStr(Trim(gvMCAInputData_CalcComm.TOT_CCLD_QTY    ),21) );
          gf_MCALog('InputData.TOT_CCLD_AMT     : [Sent]' + gf_MoveDataStr(Trim(InputData.TOT_CCLD_AMT    ),21) + ' [Receive]' + gf_MoveDataStr(Trim(gvMCAInputData_CalcComm.TOT_CCLD_AMT    ),21) );

          // ���� ó�� ������� �ڷ����� Ȯ��.
          if (Trim(InputData.EXCG_DVSN_CD    ) <> Trim(gvMCAInputData_CalcComm.EXCG_DVSN_CD    )) or
             (Trim(InputData.PDNO            ) <> Trim(gvMCAInputData_CalcComm.PDNO            )) or
             (Trim(InputData.SLL_BUY_DVSN_CD ) <> Trim(gvMCAInputData_CalcComm.SLL_BUY_DVSN_CD )) or
             (Trim(InputData.TRTX_TXTN_YN    ) <> Trim(gvMCAInputData_CalcComm.TRTX_TXTN_YN    )) or
             (Trim(InputData.ORD_MDIA_DVSN_CD) <> Trim(gvMCAInputData_CalcComm.ORD_MDIA_DVSN_CD)) or
             (Trim(InputData.CANO            ) <> Trim(gvMCAInputData_CalcComm.CANO            )) or
             (Trim(InputData.ACNT_PRDT_CD    ) <> Trim(gvMCAInputData_CalcComm.ACNT_PRDT_CD    )) then
          begin
            gf_MCALog('��û�ڷ� Input �� ����ġ.');
            sOut := '��û�ڷ� Input �� ����ġ.';
            Exit;
          end;

          gf_MCALog('���� ������ : '   + gvMCAOutputData_CalcComm.FEE     );
          gf_MCALog('���� �ŷ��� : '   + gvMCAOutputData_CalcComm.TRTX    );
          gf_MCALog('���� ��Ư�� : '   + gvMCAOutputData_CalcComm.FSTX    );
          gf_MCALog('���� �絵�� : '   + gvMCAOutputData_CalcComm.TRFX    );
          gf_MCALog('���� �����ݾ� : ' + gvMCAOutputData_CalcComm.EXCC_AMT);
          gf_MCALog('����� �������� : ' + gvMCAOutputData_CalcComm.FEE_RT  );
          Try
            StrToFloat(gvMCAOutputData_CalcComm.FEE_RT);
          Except
            gf_MCALog('�������� �� ����.');
          End;
          gf_MCALog('���� �������� : ' + FloatToStr(StrToFloat(gvMCAOutputData_CalcComm.FEE_RT) / 100000000) );

          sComm      := StrPas(gvMCAOutputData_CalcComm.FEE);
          sTrdTax    := StrPas(gvMCAOutputData_CalcComm.TRTX);
          sAgcTax    := StrPas(gvMCAOutputData_CalcComm.FSTX);
          sCpgTax    := StrPas(gvMCAOutputData_CalcComm.TRFX);
          sNetAmt    := StrPas(gvMCAOutputData_CalcComm.EXCC_AMT);
          sHCommRate := StrPas(gvMCAOutputData_CalcComm.FEE_RT);

          Try
            dComm      := StrToFloat(sComm     );
            dTrdTax    := StrToFloat(sTrdTax   );
            dAgcTax    := StrToFloat(sAgcTax   );
            dCpgTax    := StrToFloat(sCpgTax   );
            dNetAmt    := StrToFloat(sNetAmt   );
            dHCommRate := StrToFloat(sHCommRate) / 100000000;
          Except
            on E: Exception do
            begin
              sOut := '�������� �� ��ȯ ����. ' + E.Message;
              Exit;
            end;
          End;
        end;
        Break;
      end; // if gvMCAReceive then
      LeaveCriticalSection(gvMCACriticalSection);
      Application.ProcessMessages;
      Sleep(100);
    end; // while

  Except
    On E: Exception do
    begin
      sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
      Exit;
    end;
  End;

  Result := true;

  gf_MCALog('MCA: [TSC3220R] �ֽ� ������ ��� ����.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;


//------------------------------------------------------------------------------
//���� ���� Import Using MCA
// todo: ���� ���� Import - gf_HostMCAsngetFACInfo()
//------------------------------------------------------------------------------
function gf_tf_HostMCAsngetFAcInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;
var
  sCustDept : string;

  iResult, i, iComPos: integer;

  sAccNo,
  sAccFileName: string;

  headerInfo : TMCAHeader; // ���� ������ DLL ��� ����

  InputData : TTFO6137RI1; // ���� �������� Input

  // Input ����
  sACNT_ADMN_ORGNO : string;
  sINQR_DT         : string;
  sCANO            : string;
  sACNT_PRDT_CD    : string;
  sPOUT_FILE_NAME  : string;
  sITFC_ID         : string;

begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TFO6137R] ���� ���� ���� ���� ����.');

  Result := false;

  sCustDept := '0' + gvDeptCode;

  gvMCAReceive := False;
  iResult := 0;

  //-- ��� �ʱ�ȭ -----------------------------------------------------------
  GetMCAHeaderData(gcMCA_TR_F_ACC, headerInfo);

  gf_MCALog('headerInfo.cTR_Type          : ' + headerInfo.TR_Type          );
  gf_MCALog('headerInfo.cInterface_id     : ' + headerInfo.Interface_id     );
  gf_MCALog('headerInfo.cEncrypt_flag     : ' + headerInfo.Encrypt_flag     );
  gf_MCALog('headerInfo.cTr_name          : ' + headerInfo.Tr_name          );
  gf_MCALog('headerInfo.cScr_no           : ' + headerInfo.Scr_no           );
  gf_MCALog('headerInfo.cLang_id          : ' + headerInfo.Lang_id          );
  gf_MCALog('headerInfo.cMode_flag        : ' + headerInfo.Mode_flag        );
  gf_MCALog('headerInfo.cTr_cont          : ' + headerInfo.Tr_cont          );
  gf_MCALog('headerInfo.cCo_cd            : ' + headerInfo.Co_cd            );
  gf_MCALog('headerInfo.cMedia_cd1        : ' + headerInfo.Media_cd1        );
  gf_MCALog('headerInfo.cMedia_cd2        : ' + headerInfo.Media_cd2        );
  gf_MCALog('headerInfo.cOrg_cd           : ' + headerInfo.Org_cd           );
  gf_MCALog('headerInfo.cSeq_no           : ' + headerInfo.Seq_no           );
  gf_MCALog('headerInfo.cDept_cd          : ' + headerInfo.Dept_cd          );
  gf_MCALog('headerInfo.cEmp_id           : ' + headerInfo.Emp_id           );
  gf_MCALog('headerInfo.cEmp_seq          : ' + headerInfo.Emp_seq          );
  gf_MCALog('headerInfo.cUser_id          : ' + headerInfo.User_id          );
  gf_MCALog('headerInfo.cBr_open_cd       : ' + headerInfo.Br_open_cd       );
  gf_MCALog('headerInfo.cAcct_no          : ' + headerInfo.Acct_no          );
  gf_MCALog('headerInfo.cMediaFlag        : ' + headerInfo.MediaFlag        );
  gf_MCALog('headerInfo.cMediaFlag_Detail : ' + headerInfo.MediaFlag_Detail );
  gf_MCALog('headerInfo.cRt_cd            : ' + headerInfo.Rt_cd            );

  // ��� ���¼� ��ŭ ����
  if (sAccList > '') then
  begin
    while (sAccList > '') do
    begin
      gf_MCALog('���º� �������� �ڷ� ����.');
      Inc(gvMCAFileCnt);

      if Pos(',', sAccList) > 0 then
      begin
        // ó�� ��� ���� ã��.
        iComPos := Pos(',', sAccList);
        sAccNo := LeftStr(sAccList,iComPos-1);
        sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);

        // Ÿ�μ� ���� üũ(Ÿ�μ� �����̸� �μ��ڵ� ����)
        if AcEtcYn(sAccNo) then sCustDept := '';
      end else
      begin
        sAccNo := '';
      end;

      //
      sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // ���� ���ϸ�
                    + FormatFloat('000', gvMCAFileCnt)                   // ����
                    + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // Ȯ����
      gvMCAFtpFileList.Add(sAccFileName);

      gf_MCALog('sAccNo: ' + sAccNo);
      gf_MCALog('sAccList: ' + sAccList);

      //-- Input ���� ------------------------------------------------------------
      FillChar(InputData,SizeOf(InputData),#32);

      sACNT_ADMN_ORGNO := sCustDept;
      sINQR_DT         := sDate;
      sCANO            := LeftStr(sAccNo,8);
      sACNT_PRDT_CD    := Copy(sAccNo,9,2);
      sPOUT_FILE_NAME  := sAccFileName;
      sITFC_ID         := gvMCAInterfaceID;

      myStr2NotNilChar(InputData.ACNT_ADMN_ORGNO  , sACNT_ADMN_ORGNO, Length(sACNT_ADMN_ORGNO) );
      myStr2NotNilChar(InputData.INQR_DT          , sINQR_DT        , Length(sINQR_DT        ) );
      myStr2NotNilChar(InputData.CANO             , sCANO           , Length(sCANO           ) );
      myStr2NotNilChar(InputData.ACNT_PRDT_CD     , sACNT_PRDT_CD   , Length(sACNT_PRDT_CD   ) );
      myStr2NotNilChar(InputData.POUT_FILE_NAME   , sPOUT_FILE_NAME , Length(sPOUT_FILE_NAME ) );
      myStr2NotNilChar(InputData.ITFC_ID          , sITFC_ID        , Length(sITFC_ID        ) );

      InputData._ACNT_ADMN_ORGNO := #16;
      InputData._INQR_DT := #16;
      InputData._CANO := #16;
      InputData._ACNT_PRDT_CD := #16;
      InputData._POUT_FILE_NAME := #16;
      InputData._ITFC_ID := #16;

      gf_MCALog(IntToStr(gvMCAFileCnt) + ' : ' + sAccFileName);
      gf_MCALog('Input.ACNT_ADMN_ORGNO        : ' + InputData.ACNT_ADMN_ORGNO  );
      gf_MCALog('Input.INQR_DT                : ' + InputData.INQR_DT          );
      gf_MCALog('Input.CANO                   : ' + InputData.CANO             );
      gf_MCALog('Input.ACNT_PRDT_CD           : ' + InputData.ACNT_PRDT_CD     );
      gf_MCALog('Input.POUT_FILE_NAME         : ' + InputData.POUT_FILE_NAME   );
      gf_MCALog('Input.ITFC_ID                : ' + InputData.ITFC_ID          );

      // Input ����
      Try
         if (m_hHKCommDLL <> 0) then
        begin
          Sleep(1000);
          //
          iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                      sizeof(TMCAHeader), sizeof(TTFO6137RI1));

          if iResult = 0 then
          begin
            sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
            exit;
          end;
        end else
        begin
          sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
          Exit;
        end;

        while True do
        begin
          EnterCriticalSection(gvMCACriticalSection);
          if gvMCAReceive then
          begin
            gvMCAReceive := False;
            gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
            LeaveCriticalSection(gvMCACriticalSection);

            if gvMCAResult <> 'Y' then
            begin
              gf_MCALog('���� ó�� ����.');
              sOut := '���� ó�� ����.';
              //Exit;
            end;
            Break;
          end;
          LeaveCriticalSection(gvMCACriticalSection);
          Application.ProcessMessages;
          Sleep(100);
        end; // while

        Result := True;

      Except
         On E: Exception do
         begin
            sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
            Exit;
         end;
      End;
    end; // while (sAccList > '') do

  end else
  begin
    gf_MCALog('��ü �������� �ڷ� ����.');
    Inc(gvMCAFileCnt);

    if Pos(',', sAccList) > 0 then
    begin
      // ó�� ��� ���� ã��.
      iComPos := Pos(',', sAccList);
      sAccNo := LeftStr(sAccList,iComPos-1);
      sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);
    end else
    begin
      sAccNo := '';
    end;

    //
    sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // ���� ���ϸ�
                  + FormatFloat('000', gvMCAFileCnt) + 'T'        // ����
                  + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // Ȯ����
    gvMCAFtpFileList.Add(sAccFileName);

    //-- Input ���� ------------------------------------------------------------
    FillChar(InputData,SizeOf(InputData),#32);

    sACNT_ADMN_ORGNO := sCustDept;
    sINQR_DT         := sDate;
    sCANO            := LeftStr(sAccNo,8);
    sACNT_PRDT_CD    := Copy(sAccNo,9,2);
    sPOUT_FILE_NAME  := sAccFileName;
    sITFC_ID         := gvMCAInterfaceID;

    myStr2NotNilChar(InputData.ACNT_ADMN_ORGNO  , sACNT_ADMN_ORGNO, Length(sACNT_ADMN_ORGNO) );
    myStr2NotNilChar(InputData.INQR_DT          , sINQR_DT        , Length(sINQR_DT        ) );
    myStr2NotNilChar(InputData.CANO             , sCANO           , Length(sCANO           ) );
    myStr2NotNilChar(InputData.ACNT_PRDT_CD     , sACNT_PRDT_CD   , Length(sACNT_PRDT_CD   ) );
    myStr2NotNilChar(InputData.POUT_FILE_NAME   , sPOUT_FILE_NAME , Length(sPOUT_FILE_NAME ) );
    myStr2NotNilChar(InputData.ITFC_ID          , sITFC_ID        , Length(sITFC_ID        ) );

    InputData._ACNT_ADMN_ORGNO := #16;
    InputData._INQR_DT := #16;
    InputData._CANO := #16;
    InputData._ACNT_PRDT_CD := #16;
    InputData._POUT_FILE_NAME := #16;
    InputData._ITFC_ID := #16;

    gf_MCALog(IntToStr(gvMCAFileCnt) + ' : ' + sAccFileName);
    gf_MCALog('Input.ACNT_ADMN_ORGNO        : ' + InputData.ACNT_ADMN_ORGNO  );
    gf_MCALog('Input.INQR_DT                : ' + InputData.INQR_DT          );
    gf_MCALog('Input.CANO                   : ' + InputData.CANO             );
    gf_MCALog('Input.ACNT_PRDT_CD           : ' + InputData.ACNT_PRDT_CD     );
    gf_MCALog('Input.POUT_FILE_NAME         : ' + InputData.POUT_FILE_NAME   );
    gf_MCALog('Input.ITFC_ID                : ' + InputData.ITFC_ID          );

    // Input ����
    Try
       if (m_hHKCommDLL <> 0) then
      begin
        Sleep(1000);
        //
        iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                    sizeof(TMCAHeader), sizeof(TTFO6137RI1));

        if iResult = 0 then
        begin
           sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
           exit;
        end;
      end else
      begin
        sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
        Exit;
      end;

      while True do
      begin
        EnterCriticalSection(gvMCACriticalSection);
        if gvMCAReceive then
        begin
          gvMCAReceive := False;
          gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
          LeaveCriticalSection(gvMCACriticalSection);

          if gvMCAResult <> 'Y' then
          begin
            gf_MCALog('���� ó�� ����.');
            sOut := '���� ó�� ����.';
            //Exit;
          end;
          Break;
        end;
        LeaveCriticalSection(gvMCACriticalSection);
        Application.ProcessMessages;
        Sleep(100);
      end; // while

      Result := True;

    Except
       On E: Exception do
       begin
          sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
          Exit;
       end;
    End;
  end; // if (sAccList > '') then

  gf_MCALog('MCA: [TFO6137R] ���� ���� ���� ���� ����.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
//���� ���������� Import Using MCA
// todo: ���� �������ڵ� Import - gf_tf_HostMCAsngetFCmInfo()
//------------------------------------------------------------------------------
function gf_tf_HostMCAsngetFCmInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;
var
  sCustDept : string;

  iResult, i, iComPos: integer;

  sAccNo,
  sAccFileName: string;

  headerInfo : TMCAHeader; // ��� ����
  InputData : TTFO6142RI1; // Input

  // Input ����
  sACNT_ADMN_ORGNO : string;
  sINQR_DT         : string;
  sCANO            : string;
  sACNT_PRDT_CD    : string;
  sPOUT_FILE_NAME  : string;
  sITFC_ID         : string;

begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TFO6142R] ���� ���������� ���� ���� ����.');

  Result := false;

  sCustDept := '0' + gvDeptCode;

  gvMCAReceive := False;
  iResult := 0;

  // ��� ����
  GetMCAHeaderData(gcMCA_TR_F_COMM_INFO, headerInfo);
  
  gf_MCALog('headerInfo.TR_Type          : ' + headerInfo.TR_Type          );
  gf_MCALog('headerInfo.Interface_id     : ' + headerInfo.Interface_id     );
  gf_MCALog('headerInfo.Encrypt_flag     : ' + headerInfo.Encrypt_flag     );
  gf_MCALog('headerInfo.Tr_name          : ' + headerInfo.Tr_name          );
  gf_MCALog('headerInfo.Scr_no           : ' + headerInfo.Scr_no           );
  gf_MCALog('headerInfo.Lang_id          : ' + headerInfo.Lang_id          );
  gf_MCALog('headerInfo.Mode_flag        : ' + headerInfo.Mode_flag        );
  gf_MCALog('headerInfo.Tr_cont          : ' + headerInfo.Tr_cont          );
  gf_MCALog('headerInfo.Co_cd            : ' + headerInfo.Co_cd            );
  gf_MCALog('headerInfo.Media_cd1        : ' + headerInfo.Media_cd1        );
  gf_MCALog('headerInfo.Media_cd2        : ' + headerInfo.Media_cd2        );
  gf_MCALog('headerInfo.Org_cd           : ' + headerInfo.Org_cd           );
  gf_MCALog('headerInfo.Seq_no           : ' + headerInfo.Seq_no           );
  gf_MCALog('headerInfo.Dept_cd          : ' + headerInfo.Dept_cd          );
  gf_MCALog('headerInfo.Emp_id           : ' + headerInfo.Emp_id           );
  gf_MCALog('headerInfo.Emp_seq          : ' + headerInfo.Emp_seq          );
  gf_MCALog('headerInfo.User_id          : ' + headerInfo.User_id          );
  gf_MCALog('headerInfo.Br_open_cd       : ' + headerInfo.Br_open_cd       );
  gf_MCALog('headerInfo.Acct_no          : ' + headerInfo.Acct_no          );
  gf_MCALog('headerInfo.MediaFlag        : ' + headerInfo.MediaFlag        );
  gf_MCALog('headerInfo.MediaFlag_Detail : ' + headerInfo.MediaFlag_Detail );
  gf_MCALog('headerInfo.Rt_cd            : ' + headerInfo.Rt_cd            );

  // ��� ���¼� ��ŭ ����
  if (sAccList > '') then
  begin
    while (sAccList > '') do
    begin
      gf_MCALog('���º� ���������� �ڷ� ����.');
      Inc(gvMCAFileCnt);

      if Pos(',', sAccList) > 0 then
      begin
        // ó�� ��� ���� ã��.
        iComPos := Pos(',', sAccList);
        sAccNo := LeftStr(sAccList,iComPos-1);
        sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);

        // Ÿ�μ� ���� üũ(Ÿ�μ� �����̸� �μ��ڵ� ����)
        if AcEtcYn(sAccNo) then sCustDept := '';
      end else
      begin
        sAccNo := '';
      end;

      //
      sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // ���� ���ϸ�
                    + FormatFloat('000', gvMCAFileCnt)                  // ����
                    + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // Ȯ����
      gvMCAFtpFileList.Add(sAccFileName);

      gf_MCALog('sAccNo: ' + sAccNo);
      gf_MCALog('sAccList: ' + sAccList);

      // Input ����
      FillChar(InputData,SizeOf(InputData),#32);

      sACNT_ADMN_ORGNO := sCustDept;
      sINQR_DT         := sDate;
      sCANO            := LeftStr(sAccNo,8);
      sACNT_PRDT_CD    := Copy(sAccNo,9,2);
      sPOUT_FILE_NAME  := sAccFileName;
      sITFC_ID         := gvMCAInterfaceID;

      myStr2NotNilChar(InputData.ACNT_ADMN_ORGNO  , sACNT_ADMN_ORGNO, Length(sACNT_ADMN_ORGNO) );
      myStr2NotNilChar(InputData.INQR_DT          , sINQR_DT        , Length(sINQR_DT        ) );
      myStr2NotNilChar(InputData.CANO             , sCANO           , Length(sCANO           ) );
      myStr2NotNilChar(InputData.ACNT_PRDT_CD     , sACNT_PRDT_CD   , Length(sACNT_PRDT_CD   ) );
      myStr2NotNilChar(InputData.POUT_FILE_NAME   , sPOUT_FILE_NAME , Length(sPOUT_FILE_NAME ) );
      myStr2NotNilChar(InputData.ITFC_ID          , sITFC_ID        , Length(sITFC_ID        ) );

      InputData._ACNT_ADMN_ORGNO := #16;
      InputData._INQR_DT := #16;
      InputData._CANO := #16;
      InputData._ACNT_PRDT_CD := #16;
      InputData._POUT_FILE_NAME := #16;
      InputData._ITFC_ID := #16;

      gf_MCALog(IntToStr(gvMCAFileCnt) + ' : ' + sAccFileName);
      gf_MCALog('Input.ACNT_ADMN_ORGNO        : ' + InputData.ACNT_ADMN_ORGNO  );
      gf_MCALog('Input.INQR_DT                : ' + InputData.INQR_DT          );
      gf_MCALog('Input.CANO                   : ' + InputData.CANO             );
      gf_MCALog('Input.ACNT_PRDT_CD           : ' + InputData.ACNT_PRDT_CD     );
      gf_MCALog('Input.POUT_FILE_NAME         : ' + InputData.POUT_FILE_NAME   );
      gf_MCALog('Input.ITFC_ID                : ' + InputData.ITFC_ID          );

      // Input ����
      Try
         if (m_hHKCommDLL <> 0) then
        begin
          Sleep(1000);
          // 
          iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                      sizeof(TMCAHeader), sizeof(TTFO6142RI1));

          if iResult = 0 then
          begin
             sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
             exit;
          end;
        end else
        begin
          sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
          Exit;
        end;

        while True do
        begin
          EnterCriticalSection(gvMCACriticalSection);
          if gvMCAReceive then
          begin
            gvMCAReceive := False;
            gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
            LeaveCriticalSection(gvMCACriticalSection);

            if gvMCAResult <> 'Y' then
            begin
              gf_MCALog('���� ó�� ����.');
              sOut := '���� ó�� ����.';
              //Exit;
            end;
            Break;
          end;
          LeaveCriticalSection(gvMCACriticalSection);
          Application.ProcessMessages;
          Sleep(100);
        end; // while

        Result := True;

      Except
         On E: Exception do
         begin
            sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
            Exit;
         end;
      End;
    end; // while (sAccList > '') do
  end else
  begin
    gf_MCALog('��ü ���������� �ڷ� ����.');
    Inc(gvMCAFileCnt);

    if Pos(',', sAccList) > 0 then
    begin
      // ó�� ��� ���� ã��.
      iComPos := Pos(',', sAccList);
      sAccNo := LeftStr(sAccList,iComPos-1);
      sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);
    end else
    begin
      sAccNo := '';
    end;

    //
    sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // ���� ���ϸ�
                  + FormatFloat('000', gvMCAFileCnt) + 'T'                  // ����
                  + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // Ȯ����
    gvMCAFtpFileList.Add(sAccFileName);

    // Input ����
    FillChar(InputData,SizeOf(InputData),#32);

    sACNT_ADMN_ORGNO := sCustDept;
    sINQR_DT         := sDate;
    sCANO            := LeftStr(sAccNo,8);
    sACNT_PRDT_CD    := Copy(sAccNo,9,2);
    sPOUT_FILE_NAME  := sAccFileName;
    sITFC_ID         := gvMCAInterfaceID;

    myStr2NotNilChar(InputData.ACNT_ADMN_ORGNO  , sACNT_ADMN_ORGNO, Length(sACNT_ADMN_ORGNO) );
    myStr2NotNilChar(InputData.INQR_DT          , sINQR_DT        , Length(sINQR_DT        ) );
    myStr2NotNilChar(InputData.CANO             , sCANO           , Length(sCANO           ) );
    myStr2NotNilChar(InputData.ACNT_PRDT_CD     , sACNT_PRDT_CD   , Length(sACNT_PRDT_CD   ) );
    myStr2NotNilChar(InputData.POUT_FILE_NAME   , sPOUT_FILE_NAME , Length(sPOUT_FILE_NAME ) );
    myStr2NotNilChar(InputData.ITFC_ID          , sITFC_ID        , Length(sITFC_ID        ) );

    InputData._ACNT_ADMN_ORGNO := #16;
    InputData._INQR_DT := #16;
    InputData._CANO := #16;
    InputData._ACNT_PRDT_CD := #16;
    InputData._POUT_FILE_NAME := #16;
    InputData._ITFC_ID := #16;

    gf_MCALog(IntToStr(gvMCAFileCnt) + ' : ' + sAccFileName);
    gf_MCALog('Input.ACNT_ADMN_ORGNO        : ' + InputData.ACNT_ADMN_ORGNO  );
    gf_MCALog('Input.INQR_DT                : ' + InputData.INQR_DT          );
    gf_MCALog('Input.CANO                   : ' + InputData.CANO             );
    gf_MCALog('Input.ACNT_PRDT_CD           : ' + InputData.ACNT_PRDT_CD     );
    gf_MCALog('Input.POUT_FILE_NAME         : ' + InputData.POUT_FILE_NAME   );
    gf_MCALog('Input.ITFC_ID                : ' + InputData.ITFC_ID          );

    // Input ����
    Try
       if (m_hHKCommDLL <> 0) then
      begin
        Sleep(1000);
        // 
        iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                    sizeof(TMCAHeader), sizeof(TTFO6142RI1));

        if iResult = 0 then
        begin
           sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
           exit;
        end;
      end else
      begin
        sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
        Exit;
      end;

      while True do
      begin
        EnterCriticalSection(gvMCACriticalSection);
        if gvMCAReceive then
        begin
          gvMCAReceive := False;
          gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
          LeaveCriticalSection(gvMCACriticalSection);

          if gvMCAResult <> 'Y' then
          begin
            gf_MCALog('���� ó�� ����.');
            sOut := '���� ó�� ����.';
            //Exit;
          end;
          Break;
        end;
        LeaveCriticalSection(gvMCACriticalSection);
        Application.ProcessMessages;
        Sleep(100);
      end; // while

      Result := True;

    Except
       On E: Exception do
       begin
          sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
          Exit;
       end;
    End;
  end; // if (sAccList > '') then

  gf_MCALog('MCA: [TFO6142R] ���� ���������� ���� ���� ����.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
//���� ��Ź Import Using MCA
// todo: ���� ��Ź Import - gf_HostMCAsngetFDPInfo()
//------------------------------------------------------------------------------
function gf_tf_HostMCAsngetFDPInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;
var
  sCustDept : string;
  
  iResult, i, iComPos: integer;

  sAccNo,
  sAccFileName: string;

  headerInfo : TMCAHeader; // ��� ����

  InputData : TTFO6138RI1; // Input

  // Input ����
  sACNT_ADMN_ORGNO : string;
  sINQR_DT         : string;
  sCANO            : string;
  sACNT_PRDT_CD    : string;
  sPOUT_FILE_NAME  : string;
  sITFC_ID         : string;

begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TFO6138R] ���� ��Ź ���� ���� ����.');

  Result := false;

  // Ÿ�μ� ���´� �μ��ڵ�(���°���������ȣ) ��������
  sCustDept := '0' + gvDeptCode;

  gvMCAReceive := False;
  iResult := 0;

  // ��� �ʱ�ȭ
  GetMCAHeaderData(gcMCA_TR_F_DEPOSIT, headerInfo);

  gf_MCALog('headerInfo.TR_Type          : ' + headerInfo.TR_Type          );
  gf_MCALog('headerInfo.Interface_id     : ' + headerInfo.Interface_id     );
  gf_MCALog('headerInfo.Encrypt_flag     : ' + headerInfo.Encrypt_flag     );
  gf_MCALog('headerInfo.Tr_name          : ' + headerInfo.Tr_name          );
  gf_MCALog('headerInfo.Scr_no           : ' + headerInfo.Scr_no           );
  gf_MCALog('headerInfo.Lang_id          : ' + headerInfo.Lang_id          );
  gf_MCALog('headerInfo.Mode_flag        : ' + headerInfo.Mode_flag        );
  gf_MCALog('headerInfo.Tr_cont          : ' + headerInfo.Tr_cont          );
  gf_MCALog('headerInfo.Co_cd            : ' + headerInfo.Co_cd            );
  gf_MCALog('headerInfo.Media_cd1        : ' + headerInfo.Media_cd1        );
  gf_MCALog('headerInfo.Media_cd2        : ' + headerInfo.Media_cd2        );
  gf_MCALog('headerInfo.Org_cd           : ' + headerInfo.Org_cd           );
  gf_MCALog('headerInfo.Seq_no           : ' + headerInfo.Seq_no           );
  gf_MCALog('headerInfo.Dept_cd          : ' + headerInfo.Dept_cd          );
  gf_MCALog('headerInfo.Emp_id           : ' + headerInfo.Emp_id           );
  gf_MCALog('headerInfo.Emp_seq          : ' + headerInfo.Emp_seq          );
  gf_MCALog('headerInfo.User_id          : ' + headerInfo.User_id          );
  gf_MCALog('headerInfo.Br_open_cd       : ' + headerInfo.Br_open_cd       );
  gf_MCALog('headerInfo.Acct_no          : ' + headerInfo.Acct_no          );
  gf_MCALog('headerInfo.MediaFlag        : ' + headerInfo.MediaFlag        );
  gf_MCALog('headerInfo.MediaFlag_Detail : ' + headerInfo.MediaFlag_Detail );
  gf_MCALog('headerInfo.Rt_cd            : ' + headerInfo.Rt_cd            );

  if (sAccList > '') then
  begin
    // ��� ���¼� ��ŭ ����
    while (sAccList > '') do
    begin
      gf_MCALog('���º� ��Ź �ڷ� ����.');
      Inc(gvMCAFileCnt);

      if Pos(',', sAccList) > 0 then
      begin
        // ó�� ��� ���� ã��.
        iComPos := Pos(',', sAccList);
        sAccNo := LeftStr(sAccList,iComPos-1);
        sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);

        // Ÿ�μ� ���� üũ(Ÿ�μ� �����̸� �μ��ڵ� ����)
        if AcEtcYn(sAccNo) then sCustDept := '';
      end else
      begin
        sAccNo := '';
      end;

      //
      sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // ���� ���ϸ�
                    + FormatFloat('000', gvMCAFileCnt)              // ����
                    + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // Ȯ����
      gvMCAFtpFileList.Add(sAccFileName);

      gf_MCALog('sAccNo: ' + sAccNo);
      gf_MCALog('sAccList: ' + sAccList);

      // Input ����
      FillChar(InputData,SizeOf(InputData),#32);

      sACNT_ADMN_ORGNO := sCustDept;
      sINQR_DT         := sDate;
      sCANO            := LeftStr(sAccNo,8);
      sACNT_PRDT_CD    := Copy(sAccNo,9,2);
      sPOUT_FILE_NAME  := sAccFileName;
      sITFC_ID         := gvMCAInterfaceID;

      myStr2NotNilChar(InputData.ACNT_ADMN_ORGNO  , sACNT_ADMN_ORGNO, Length(sACNT_ADMN_ORGNO) );
      myStr2NotNilChar(InputData.INQR_DT          , sINQR_DT        , Length(sINQR_DT        ) );
      myStr2NotNilChar(InputData.CANO             , sCANO           , Length(sCANO           ) );
      myStr2NotNilChar(InputData.ACNT_PRDT_CD     , sACNT_PRDT_CD   , Length(sACNT_PRDT_CD   ) );
      myStr2NotNilChar(InputData.POUT_FILE_NAME   , sPOUT_FILE_NAME , Length(sPOUT_FILE_NAME ) );
      myStr2NotNilChar(InputData.ITFC_ID          , sITFC_ID        , Length(sITFC_ID        ) );

      InputData._ACNT_ADMN_ORGNO := #16;
      InputData._INQR_DT := #16;
      InputData._CANO := #16;
      InputData._ACNT_PRDT_CD := #16;
      InputData._POUT_FILE_NAME := #16;
      InputData._ITFC_ID := #16;

      gf_MCALog(IntToStr(gvMCAFileCnt) + ' : ' + sAccFileName);
      gf_MCALog('Input.ACNT_ADMN_ORGNO        : ' + InputData.ACNT_ADMN_ORGNO  );
      gf_MCALog('Input.INQR_DT                : ' + InputData.INQR_DT          );
      gf_MCALog('Input.CANO                   : ' + InputData.CANO             );
      gf_MCALog('Input.ACNT_PRDT_CD           : ' + InputData.ACNT_PRDT_CD     );
      gf_MCALog('Input.POUT_FILE_NAME         : ' + InputData.POUT_FILE_NAME   );
      gf_MCALog('Input.ITFC_ID                : ' + InputData.ITFC_ID          );

      // Input ����
      Try
         if (m_hHKCommDLL <> 0) then
        begin
          Sleep(1000);
          //
          iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                      sizeof(TMCAHeader), sizeof(TTFO6138RI1));

          if iResult = 0 then
          begin
             sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
             exit;
          end;
        end else
        begin
          sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
          Exit;
        end;

        while True do
        begin
          EnterCriticalSection(gvMCACriticalSection);
          if gvMCAReceive then
          begin
            gvMCAReceive := False;
            gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
            LeaveCriticalSection(gvMCACriticalSection);
          
            if gvMCAResult <> 'Y' then
            begin
              gf_MCALog('���� ó�� ����.');
              sOut := '���� ó�� ����.';
              //Exit;
            end;
            Break;
          end;
          LeaveCriticalSection(gvMCACriticalSection);
          Application.ProcessMessages;
          Sleep(100);
        end; // while

        Result := true;

      Except
         On E: Exception do
         begin
            sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
            Exit;
         end;
      End;
    end; // while
  end else
  begin
    gf_MCALog('��ü ��Ź �ڷ� ����.');
    Inc(gvMCAFileCnt);

    if Pos(',', sAccList) > 0 then
    begin
      // ó�� ��� ���� ã��.
      iComPos := Pos(',', sAccList);
      sAccNo := LeftStr(sAccList,iComPos-1);
      sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);
    end else
    begin
      sAccNo := '';
    end;

    //
    sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // ���� ���ϸ�
                  + FormatFloat('000', gvMCAFileCnt) + 'T'              // ����
                  + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // Ȯ����
    gvMCAFtpFileList.Add(sAccFileName);

    // Input ����
    FillChar(InputData,SizeOf(InputData),#32);

    sACNT_ADMN_ORGNO := sCustDept;
    sINQR_DT         := sDate;
    sCANO            := LeftStr(sAccNo,8);
    sACNT_PRDT_CD    := Copy(sAccNo,9,2);
    sPOUT_FILE_NAME  := sAccFileName;
    sITFC_ID         := gvMCAInterfaceID;

    myStr2NotNilChar(InputData.ACNT_ADMN_ORGNO  , sACNT_ADMN_ORGNO, Length(sACNT_ADMN_ORGNO) );
    myStr2NotNilChar(InputData.INQR_DT          , sINQR_DT        , Length(sINQR_DT        ) );
    myStr2NotNilChar(InputData.CANO             , sCANO           , Length(sCANO           ) );
    myStr2NotNilChar(InputData.ACNT_PRDT_CD     , sACNT_PRDT_CD   , Length(sACNT_PRDT_CD   ) );
    myStr2NotNilChar(InputData.POUT_FILE_NAME   , sPOUT_FILE_NAME , Length(sPOUT_FILE_NAME ) );
    myStr2NotNilChar(InputData.ITFC_ID          , sITFC_ID        , Length(sITFC_ID        ) );

    InputData._ACNT_ADMN_ORGNO := #16;
    InputData._INQR_DT := #16;
    InputData._CANO := #16;
    InputData._ACNT_PRDT_CD := #16;
    InputData._POUT_FILE_NAME := #16;
    InputData._ITFC_ID := #16;

    gf_MCALog(IntToStr(gvMCAFileCnt) + ' : ' + sAccFileName);
    gf_MCALog('Input.ACNT_ADMN_ORGNO        : ' + InputData.ACNT_ADMN_ORGNO  );
    gf_MCALog('Input.INQR_DT                : ' + InputData.INQR_DT          );
    gf_MCALog('Input.CANO                   : ' + InputData.CANO             );
    gf_MCALog('Input.ACNT_PRDT_CD           : ' + InputData.ACNT_PRDT_CD     );
    gf_MCALog('Input.POUT_FILE_NAME         : ' + InputData.POUT_FILE_NAME   );
    gf_MCALog('Input.ITFC_ID                : ' + InputData.ITFC_ID          );

    // Input ����
    Try
       if (m_hHKCommDLL <> 0) then
      begin
        Sleep(1000);
        // �Ÿ�
        iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                    sizeof(TMCAHeader), sizeof(TTFO6138RI1));

        if iResult = 0 then
        begin
           sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
           exit;
        end;
      end else
      begin
        sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
        Exit;
      end;

      while True do
      begin
        EnterCriticalSection(gvMCACriticalSection);
        if gvMCAReceive then
        begin
          gvMCAReceive := False;
          gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
          LeaveCriticalSection(gvMCACriticalSection);
          
          if gvMCAResult <> 'Y' then
          begin
            gf_MCALog('���� ó�� ����.');
            sOut := '���� ó�� ����.';
            //Exit;
          end;
          Break;
        end;
        LeaveCriticalSection(gvMCACriticalSection);
        Application.ProcessMessages;
        Sleep(100);
      end; // while

      Result := true;

    Except
       On E: Exception do
       begin
          sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
          Exit;
       end;
    End;
  end; // if (sAccList > '') then

  gf_MCALog('MCA: [TFO6138R] ���� ��Ź ���� ���� ����.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
//���� �Ÿ� Import Using MCA
// todo: ���� �Ÿ� Import - gf_HostMCAsngetFTRInfo()
//------------------------------------------------------------------------------
function gf_tf_HostMCAsngetFTRInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;
var
  sCustDept : string;
  
  iResult, i, iComPos: integer;

  sAccNo,
  sAccFileName: string;

  headerInfo : TMCAHeader; // ��� ����

  InputData : TTTO9008RI1; // Input

  // Input ����
  sACNT_ADMN_ORGNO : string;
  sINQR_DT         : string;
  sCANO            : string;
  sACNT_PRDT_CD    : string;
  sPOUT_FILE_NAME  : string;
  sITFC_ID         : string;

begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TFO6139R] ���� �Ÿ� ���� ���� ����.');

  Result := false;

  sCustDept := '0' + gvDeptCode;

  gvMCAReceive := False;
  iResult := 0;

  // ��� �ʱ�ȭ
  GetMCAHeaderData(gcMCA_TR_F_TRADE, headerInfo);

  gf_MCALog('headerInfo.TR_Type          : ' + headerInfo.TR_Type          );
  gf_MCALog('headerInfo.Interface_id     : ' + headerInfo.Interface_id     );
  gf_MCALog('headerInfo.Encrypt_flag     : ' + headerInfo.Encrypt_flag     );
  gf_MCALog('headerInfo.Tr_name          : ' + headerInfo.Tr_name          );
  gf_MCALog('headerInfo.Scr_no           : ' + headerInfo.Scr_no           );
  gf_MCALog('headerInfo.Lang_id          : ' + headerInfo.Lang_id          );
  gf_MCALog('headerInfo.Mode_flag        : ' + headerInfo.Mode_flag        );
  gf_MCALog('headerInfo.Tr_cont          : ' + headerInfo.Tr_cont          );
  gf_MCALog('headerInfo.Co_cd            : ' + headerInfo.Co_cd            );
  gf_MCALog('headerInfo.Media_cd1        : ' + headerInfo.Media_cd1        );
  gf_MCALog('headerInfo.Media_cd2        : ' + headerInfo.Media_cd2        );
  gf_MCALog('headerInfo.Org_cd           : ' + headerInfo.Org_cd           );
  gf_MCALog('headerInfo.Seq_no           : ' + headerInfo.Seq_no           );
  gf_MCALog('headerInfo.Dept_cd          : ' + headerInfo.Dept_cd          );
  gf_MCALog('headerInfo.Emp_id           : ' + headerInfo.Emp_id           );
  gf_MCALog('headerInfo.Emp_seq          : ' + headerInfo.Emp_seq          );
  gf_MCALog('headerInfo.User_id          : ' + headerInfo.User_id          );
  gf_MCALog('headerInfo.Br_open_cd       : ' + headerInfo.Br_open_cd       );
  gf_MCALog('headerInfo.Acct_no          : ' + headerInfo.Acct_no          );
  gf_MCALog('headerInfo.MediaFlag        : ' + headerInfo.MediaFlag        );
  gf_MCALog('headerInfo.MediaFlag_Detail : ' + headerInfo.MediaFlag_Detail );
  gf_MCALog('headerInfo.Rt_cd            : ' + headerInfo.Rt_cd            );

  if (sAccList > '') then
  begin
    // ��� ���¼� ��ŭ ����
    while (sAccList > '') do
    begin
      gf_MCALog('���º� �Ÿ� �ڷ� ����.');
      Inc(gvMCAFileCnt);


      if Pos(',', sAccList) > 0 then
      begin
        // ó�� ��� ���� ã��.
        iComPos := Pos(',', sAccList);
        sAccNo := LeftStr(sAccList,iComPos-1);
        sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);

        // Ÿ�μ� ���� üũ(Ÿ�μ� �����̸� �μ��ڵ� ����)
        if AcEtcYn(sAccNo) then sCustDept := '';
      end else
      begin
        sAccNo := '';
      end;

      //
      sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // ���� ���ϸ�
                    + FormatFloat('000', gvMCAFileCnt)                   // ����
                    + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // Ȯ����
      gvMCAFtpFileList.Add(sAccFileName);

      gf_MCALog('sAccNo: ' + sAccNo);
      gf_MCALog('sAccList: ' + sAccList);

      // Input ����
      FillChar(InputData,SizeOf(InputData),#32);

      sACNT_ADMN_ORGNO := sCustDept;
      sINQR_DT         := sDate;
      sCANO            := LeftStr(sAccNo,8);
      sACNT_PRDT_CD    := Copy(sAccNo,9,2);
      sPOUT_FILE_NAME  := sAccFileName;
      sITFC_ID         := gvMCAInterfaceID;

      myStr2NotNilChar(InputData.ACNT_ADMN_ORGNO  , sACNT_ADMN_ORGNO, Length(sACNT_ADMN_ORGNO) );
      myStr2NotNilChar(InputData.INQR_DT          , sINQR_DT        , Length(sINQR_DT        ) );
      myStr2NotNilChar(InputData.CANO             , sCANO           , Length(sCANO           ) );
      myStr2NotNilChar(InputData.ACNT_PRDT_CD     , sACNT_PRDT_CD   , Length(sACNT_PRDT_CD   ) );
      myStr2NotNilChar(InputData.POUT_FILE_NAME   , sPOUT_FILE_NAME , Length(sPOUT_FILE_NAME ) );
      myStr2NotNilChar(InputData.ITFC_ID          , sITFC_ID        , Length(sITFC_ID        ) );

      InputData._ACNT_ADMN_ORGNO := #16;
      InputData._INQR_DT := #16;
      InputData._CANO := #16;
      InputData._ACNT_PRDT_CD := #16;
      InputData._POUT_FILE_NAME := #16;
      InputData._ITFC_ID := #16;

      gf_MCALog(IntToStr(gvMCAFileCnt) + ' : ' + sAccFileName);
      gf_MCALog('Input.ACNT_ADMN_ORGNO        : ' + InputData.ACNT_ADMN_ORGNO  );
      gf_MCALog('Input.INQR_DT                : ' + InputData.INQR_DT          );
      gf_MCALog('Input.CANO                   : ' + InputData.CANO             );
      gf_MCALog('Input.ACNT_PRDT_CD           : ' + InputData.ACNT_PRDT_CD     );
      gf_MCALog('Input.POUT_FILE_NAME         : ' + InputData.POUT_FILE_NAME   );
      gf_MCALog('Input.ITFC_ID                : ' + InputData.ITFC_ID          );

      // Input ����
      Try
         if (m_hHKCommDLL <> 0) then
        begin
          Sleep(1000);
          // �Ÿ�
          iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                      sizeof(TMCAHeader), sizeof(TTFO6138RI1));

          if iResult = 0 then
          begin
             sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
             exit;
          end;
        end else
        begin
          sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
          Exit;
        end;

        while True do
        begin
          EnterCriticalSection(gvMCACriticalSection);
          if gvMCAReceive then
          begin
            gvMCAReceive := False;
            gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
            LeaveCriticalSection(gvMCACriticalSection);
          
            if gvMCAResult <> 'Y' then
            begin
              gf_MCALog('���� ó�� ����.');
              sOut := '���� ó�� ����.';
              //Exit;
            end;
            Break;
          end;
          LeaveCriticalSection(gvMCACriticalSection);
          Application.ProcessMessages;
          Sleep(100);
        end; // while

        Result := True;

      Except
         On E: Exception do
         begin
            sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
            Exit;
         end;
      End;
    end; // while (sAccList > '') do
  end else
  begin
    gf_MCALog('��ü �Ÿ� �ڷ� ����.');
    Inc(gvMCAFileCnt);


    if Pos(',', sAccList) > 0 then
    begin
      // ó�� ��� ���� ã��.
      iComPos := Pos(',', sAccList);
      sAccNo := LeftStr(sAccList,iComPos-1);
      sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);
    end else
    begin
      sAccNo := '';
    end;

    //
    sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // ���� ���ϸ�
                  + FormatFloat('000', gvMCAFileCnt) + 'T'                   // ����
                  + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // Ȯ����
    gvMCAFtpFileList.Add(sAccFileName);

    gf_MCALog('sAccNo: ' + sAccNo);
    gf_MCALog('sAccList: ' + sAccList);

    // Input ����
    FillChar(InputData,SizeOf(InputData),#32);

    sACNT_ADMN_ORGNO := sCustDept;
    sINQR_DT         := sDate;
    sCANO            := LeftStr(sAccNo,8);
    sACNT_PRDT_CD    := Copy(sAccNo,9,2);
    sPOUT_FILE_NAME  := sAccFileName;
    sITFC_ID         := gvMCAInterfaceID;

    myStr2NotNilChar(InputData.ACNT_ADMN_ORGNO  , sACNT_ADMN_ORGNO, Length(sACNT_ADMN_ORGNO) );
    myStr2NotNilChar(InputData.INQR_DT          , sINQR_DT        , Length(sINQR_DT        ) );
    myStr2NotNilChar(InputData.CANO             , sCANO           , Length(sCANO           ) );
    myStr2NotNilChar(InputData.ACNT_PRDT_CD     , sACNT_PRDT_CD   , Length(sACNT_PRDT_CD   ) );
    myStr2NotNilChar(InputData.POUT_FILE_NAME   , sPOUT_FILE_NAME , Length(sPOUT_FILE_NAME ) );
    myStr2NotNilChar(InputData.ITFC_ID          , sITFC_ID        , Length(sITFC_ID        ) );

    InputData._ACNT_ADMN_ORGNO := #16;
    InputData._INQR_DT := #16;
    InputData._CANO := #16;
    InputData._ACNT_PRDT_CD := #16;
    InputData._POUT_FILE_NAME := #16;
    InputData._ITFC_ID := #16;

    gf_MCALog(IntToStr(gvMCAFileCnt) + ' : ' + sAccFileName);
    gf_MCALog('Input.ACNT_ADMN_ORGNO        : ' + InputData.ACNT_ADMN_ORGNO  );
    gf_MCALog('Input.INQR_DT                : ' + InputData.INQR_DT          );
    gf_MCALog('Input.CANO                   : ' + InputData.CANO             );
    gf_MCALog('Input.ACNT_PRDT_CD           : ' + InputData.ACNT_PRDT_CD     );
    gf_MCALog('Input.POUT_FILE_NAME         : ' + InputData.POUT_FILE_NAME   );
    gf_MCALog('Input.ITFC_ID                : ' + InputData.ITFC_ID          );

    // Input ����
    Try
       if (m_hHKCommDLL <> 0) then
      begin
        Sleep(1000);
        //
        iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                    sizeof(TMCAHeader), sizeof(TTFO6138RI1));

        if iResult = 0 then
        begin
           sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
           exit;
        end;
      end else
      begin
        sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
        Exit;
      end;

      while True do
      begin
        EnterCriticalSection(gvMCACriticalSection);
        if gvMCAReceive then
        begin
          gvMCAReceive := False;
          gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
          LeaveCriticalSection(gvMCACriticalSection);
          
          if gvMCAResult <> 'Y' then
          begin
            gf_MCALog('���� ó�� ����.');
            sOut := '���� ó�� ����.';
            //Exit;
          end;
          Break;
        end;
        LeaveCriticalSection(gvMCACriticalSection);
        Application.ProcessMessages;
        Sleep(100);
      end; // while

      Result := True;

    Except
       On E: Exception do
       begin
          sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
          Exit;
       end;
    End;
  end; // if (sAccList > '') then

  gf_MCALog('MCA: [TFO6139R] ���� �Ÿ� ���� ���� ����.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
//���� �̰��� Import Using MCA
// todo: ���� �̰��� Import - gf_HostMCAsngetFOPInfo()
//------------------------------------------------------------------------------
function gf_tf_HostMCAsngetFOPInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;
var
  sCustDept : string;

  iResult, i, iComPos: integer;

  sAccNo,
  sAccFileName: string;

  headerInfo : TMCAHeader; // ���� ������ DLL ��� ����

  InputData : TTFO6140RI1; // ���� �Ÿ� Input

  // Input ����
  sACNT_ADMN_ORGNO : string;
  sINQR_DT         : string;
  sCANO            : string;
  sACNT_PRDT_CD    : string;
  sPOUT_FILE_NAME  : string;
  sITFC_ID         : string;

begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TFO6140R] ���� �̰��� ���� ���� ����.');

  Result := false;

  sCustDept := '0' + gvDeptCode;

  gvMCAReceive := False;
  iResult := 0;

  // ��� �ʱ�ȭ
  GetMCAHeaderData(gcMCA_TR_F_OPEN, headerInfo);

  gf_MCALog('headerInfo.TR_Type          : ' + headerInfo.TR_Type          );
  gf_MCALog('headerInfo.Interface_id     : ' + headerInfo.Interface_id     );
  gf_MCALog('headerInfo.Encrypt_flag     : ' + headerInfo.Encrypt_flag     );
  gf_MCALog('headerInfo.Tr_name          : ' + headerInfo.Tr_name          );
  gf_MCALog('headerInfo.Scr_no           : ' + headerInfo.Scr_no           );
  gf_MCALog('headerInfo.Lang_id          : ' + headerInfo.Lang_id          );
  gf_MCALog('headerInfo.Mode_flag        : ' + headerInfo.Mode_flag        );
  gf_MCALog('headerInfo.Tr_cont          : ' + headerInfo.Tr_cont          );
  gf_MCALog('headerInfo.Co_cd            : ' + headerInfo.Co_cd            );
  gf_MCALog('headerInfo.Media_cd1        : ' + headerInfo.Media_cd1        );
  gf_MCALog('headerInfo.Media_cd2        : ' + headerInfo.Media_cd2        );
  gf_MCALog('headerInfo.Org_cd           : ' + headerInfo.Org_cd           );
  gf_MCALog('headerInfo.Seq_no           : ' + headerInfo.Seq_no           );
  gf_MCALog('headerInfo.Dept_cd          : ' + headerInfo.Dept_cd          );
  gf_MCALog('headerInfo.Emp_id           : ' + headerInfo.Emp_id           );
  gf_MCALog('headerInfo.Emp_seq          : ' + headerInfo.Emp_seq          );
  gf_MCALog('headerInfo.User_id          : ' + headerInfo.User_id          );
  gf_MCALog('headerInfo.Br_open_cd       : ' + headerInfo.Br_open_cd       );
  gf_MCALog('headerInfo.Acct_no          : ' + headerInfo.Acct_no          );
  gf_MCALog('headerInfo.MediaFlag        : ' + headerInfo.MediaFlag        );
  gf_MCALog('headerInfo.MediaFlag_Detail : ' + headerInfo.MediaFlag_Detail );
  gf_MCALog('headerInfo.Rt_cd            : ' + headerInfo.Rt_cd            );

  if (sAccList > '') then
  begin
    // ��� ���¼� ��ŭ ����
    while (sAccList > '') do
    begin
      gf_MCALog('���º� �̰��� �ڷ� ����.');
      Inc(gvMCAFileCnt);

      if Pos(',', sAccList) > 0 then
      begin
        // ó�� ��� ���� ã��.
        iComPos := Pos(',', sAccList);
        sAccNo := LeftStr(sAccList,iComPos-1);
        sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);

        // Ÿ�μ� ���� üũ(Ÿ�μ� �����̸� �μ��ڵ� ����)
        if AcEtcYn(sAccNo) then sCustDept := '';
      end else
      begin
        sAccNo := '';
      end;

      //
      sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // ���� ���ϸ�
                    + FormatFloat('000', gvMCAFileCnt)                   // ����
                    + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // Ȯ����
      gvMCAFtpFileList.Add(sAccFileName);

      gf_MCALog('sAccNo: ' + sAccNo);
      gf_MCALog('sAccList: ' + sAccList);

      // Input ����
      FillChar(InputData,SizeOf(InputData),#32);

      sACNT_ADMN_ORGNO := sCustDept;
      sINQR_DT         := sDate;
      sCANO            := LeftStr(sAccNo,8);
      sACNT_PRDT_CD    := Copy(sAccNo,9,2);
      sPOUT_FILE_NAME  := sAccFileName;
      sITFC_ID         := gvMCAInterfaceID;

      myStr2NotNilChar(InputData.ACNT_ADMN_ORGNO  , sACNT_ADMN_ORGNO, Length(sACNT_ADMN_ORGNO) );
      myStr2NotNilChar(InputData.INQR_DT          , sINQR_DT        , Length(sINQR_DT        ) );
      myStr2NotNilChar(InputData.CANO             , sCANO           , Length(sCANO           ) );
      myStr2NotNilChar(InputData.ACNT_PRDT_CD     , sACNT_PRDT_CD   , Length(sACNT_PRDT_CD   ) );
      myStr2NotNilChar(InputData.POUT_FILE_NAME   , sPOUT_FILE_NAME , Length(sPOUT_FILE_NAME ) );
      myStr2NotNilChar(InputData.ITFC_ID          , sITFC_ID        , Length(sITFC_ID        ) );

      InputData._ACNT_ADMN_ORGNO := #16;
      InputData._INQR_DT := #16;
      InputData._CANO := #16;
      InputData._ACNT_PRDT_CD := #16;
      InputData._POUT_FILE_NAME := #16;
      InputData._ITFC_ID := #16;

      gf_MCALog(IntToStr(gvMCAFileCnt) + ' : ' + sAccFileName);
      gf_MCALog('Input.ACNT_ADMN_ORGNO        : ' + InputData.ACNT_ADMN_ORGNO  );
      gf_MCALog('Input.INQR_DT                : ' + InputData.INQR_DT          );
      gf_MCALog('Input.CANO                   : ' + InputData.CANO             );
      gf_MCALog('Input.ACNT_PRDT_CD           : ' + InputData.ACNT_PRDT_CD     );
      gf_MCALog('Input.POUT_FILE_NAME         : ' + InputData.POUT_FILE_NAME   );
      gf_MCALog('Input.ITFC_ID                : ' + InputData.ITFC_ID          );

      // Input ����
      Try
         if (m_hHKCommDLL <> 0) then
        begin
          Sleep(1000);
          //
          iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                      sizeof(TMCAHeader), sizeof(TTFO6140RI1));

          if iResult = 0 then
          begin
             sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
             exit;
          end;
        end else
        begin
          sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
          Exit;
        end;

        while True do
        begin
          EnterCriticalSection(gvMCACriticalSection);
          if gvMCAReceive then
          begin
            gvMCAReceive := False;
            gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
            LeaveCriticalSection(gvMCACriticalSection);
          
            if gvMCAResult <> 'Y' then
            begin
              gf_MCALog('���� ó�� ����.');
              sOut := '���� ó�� ����.';
              //Exit;
            end;
            Break;
          end;
          LeaveCriticalSection(gvMCACriticalSection);
          Application.ProcessMessages;
          Sleep(100);
        end; // while

        Result := True;

      Except
         On E: Exception do
         begin
            sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
            Exit;
         end;
      End;
    end;
  end else
  begin
    gf_MCALog('��ü �̰��� �ڷ� ����.');
    Inc(gvMCAFileCnt);

    if Pos(',', sAccList) > 0 then
    begin
      // ó�� ��� ���� ã��.
      iComPos := Pos(',', sAccList);
      sAccNo := LeftStr(sAccList,iComPos-1);
      sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);
    end else
    begin
      sAccNo := '';
    end;

    //
    sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // ���� ���ϸ�
                  + FormatFloat('000', gvMCAFileCnt) + 'T'                   // ����
                  + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // Ȯ����
    gvMCAFtpFileList.Add(sAccFileName);

    // Input ����
    FillChar(InputData,SizeOf(InputData),#32);

    sACNT_ADMN_ORGNO := sCustDept;
    sINQR_DT         := sDate;
    sCANO            := LeftStr(sAccNo,8);
    sACNT_PRDT_CD    := Copy(sAccNo,9,2);
    sPOUT_FILE_NAME  := sAccFileName;
    sITFC_ID         := gvMCAInterfaceID;

    myStr2NotNilChar(InputData.ACNT_ADMN_ORGNO  , sACNT_ADMN_ORGNO, Length(sACNT_ADMN_ORGNO) );
    myStr2NotNilChar(InputData.INQR_DT          , sINQR_DT        , Length(sINQR_DT        ) );
    myStr2NotNilChar(InputData.CANO             , sCANO           , Length(sCANO           ) );
    myStr2NotNilChar(InputData.ACNT_PRDT_CD     , sACNT_PRDT_CD   , Length(sACNT_PRDT_CD   ) );
    myStr2NotNilChar(InputData.POUT_FILE_NAME   , sPOUT_FILE_NAME , Length(sPOUT_FILE_NAME ) );
    myStr2NotNilChar(InputData.ITFC_ID          , sITFC_ID        , Length(sITFC_ID        ) );

    InputData._ACNT_ADMN_ORGNO := #16;
    InputData._INQR_DT := #16;
    InputData._CANO := #16;
    InputData._ACNT_PRDT_CD := #16;
    InputData._POUT_FILE_NAME := #16;
    InputData._ITFC_ID := #16;

    gf_MCALog(IntToStr(gvMCAFileCnt) + ' : ' + sAccFileName);
    gf_MCALog('Input.ACNT_ADMN_ORGNO        : ' + InputData.ACNT_ADMN_ORGNO  );
    gf_MCALog('Input.INQR_DT                : ' + InputData.INQR_DT          );
    gf_MCALog('Input.CANO                   : ' + InputData.CANO             );
    gf_MCALog('Input.ACNT_PRDT_CD           : ' + InputData.ACNT_PRDT_CD     );
    gf_MCALog('Input.POUT_FILE_NAME         : ' + InputData.POUT_FILE_NAME   );
    gf_MCALog('Input.ITFC_ID                : ' + InputData.ITFC_ID          );

    // Input ����
    Try
       if (m_hHKCommDLL <> 0) then
      begin
        Sleep(1000);
        //
        iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                    sizeof(TMCAHeader), sizeof(TTFO6140RI1));

        if iResult = 0 then
        begin
           sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
           exit;
        end;
      end else
      begin
        sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
        Exit;
      end;

      while True do
      begin
        EnterCriticalSection(gvMCACriticalSection);
        if gvMCAReceive then
        begin
          gvMCAReceive := False;
          gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
          LeaveCriticalSection(gvMCACriticalSection);
          
          if gvMCAResult <> 'Y' then
          begin
            gf_MCALog('���� ó�� ����.');
            sOut := '���� ó�� ����.';
            //Exit;
          end;
          Break;
        end;
        LeaveCriticalSection(gvMCACriticalSection);
        Application.ProcessMessages;
        Sleep(100);
      end; // while

      Result := True;

    Except
       On E: Exception do
       begin
          sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
          Exit;
       end;
    End;
  end;
  
  gf_MCALog('MCA: [TFO6140R] ���� �̰��� ���� ���� ����.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
//���� ��� Import Using MCA
// todo: ���� ��� Import - gf_HostMCAsngetFLNInfo()
//------------------------------------------------------------------------------
function gf_tf_HostMCAsngetFLNInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;
var
  sCustDept : string;

  iResult, i, iComPos, iFileSeq: integer;

  sAccNo,
  sAccFileName: string;

  headerInfo : TMCAHeader; // ��� ����

  InputData : TTFO6141RI1; // Input

  // Input ����
  sACNT_ADMN_ORGNO : string;
  sINQR_DT         : string;
  sCANO            : string;
  sACNT_PRDT_CD    : string;
  sPOUT_FILE_NAME  : string;
  sITFC_ID         : string;

begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TFO6141R] ���� ��� ���� ���� ����.');
  
  Result := false;

  sCustDept := '0' + gvDeptCode;

  gvMCAReceive := False;
  iResult := 0;

  // ��� �ʱ�ȭ
  GetMCAHeaderData(gcMCA_TR_F_COLT, headerInfo);

  gf_MCALog('headerInfo.TR_Type          : ' + headerInfo.TR_Type          );
  gf_MCALog('headerInfo.Interface_id     : ' + headerInfo.Interface_id     );
  gf_MCALog('headerInfo.Encrypt_flag     : ' + headerInfo.Encrypt_flag     );
  gf_MCALog('headerInfo.Tr_name          : ' + headerInfo.Tr_name          );
  gf_MCALog('headerInfo.Scr_no           : ' + headerInfo.Scr_no           );
  gf_MCALog('headerInfo.Lang_id          : ' + headerInfo.Lang_id          );
  gf_MCALog('headerInfo.Mode_flag        : ' + headerInfo.Mode_flag        );
  gf_MCALog('headerInfo.Tr_cont          : ' + headerInfo.Tr_cont          );
  gf_MCALog('headerInfo.Co_cd            : ' + headerInfo.Co_cd            );
  gf_MCALog('headerInfo.Media_cd1        : ' + headerInfo.Media_cd1        );
  gf_MCALog('headerInfo.Media_cd2        : ' + headerInfo.Media_cd2        );
  gf_MCALog('headerInfo.Org_cd           : ' + headerInfo.Org_cd           );
  gf_MCALog('headerInfo.Seq_no           : ' + headerInfo.Seq_no           );
  gf_MCALog('headerInfo.Dept_cd          : ' + headerInfo.Dept_cd          );
  gf_MCALog('headerInfo.Emp_id           : ' + headerInfo.Emp_id           );
  gf_MCALog('headerInfo.Emp_seq          : ' + headerInfo.Emp_seq          );
  gf_MCALog('headerInfo.User_id          : ' + headerInfo.User_id          );
  gf_MCALog('headerInfo.Br_open_cd       : ' + headerInfo.Br_open_cd       );
  gf_MCALog('headerInfo.Acct_no          : ' + headerInfo.Acct_no          );
  gf_MCALog('headerInfo.MediaFlag        : ' + headerInfo.MediaFlag        );
  gf_MCALog('headerInfo.MediaFlag_Detail : ' + headerInfo.MediaFlag_Detail );
  gf_MCALog('headerInfo.Rt_cd            : ' + headerInfo.Rt_cd            );

  if (sAccList > '') then
  begin
    // ��� ���¼� ��ŭ ����
    while (sAccList > '') do
    begin
      gf_MCALog('���º� ��� �ڷ� ����.');
      Inc(gvMCAFileCnt);

      if Pos(',', sAccList) > 0 then
      begin
        // ó�� ��� ���� ã��.
        iComPos := Pos(',', sAccList);
        sAccNo := LeftStr(sAccList,iComPos-1);
        sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);

        // Ÿ�μ� ���� üũ(Ÿ�μ� �����̸� �μ��ڵ� ����)
        if AcEtcYn(sAccNo) then sCustDept := '';
      end else
      begin
        sAccNo := '';
      end;

      //
      sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // ���� ���ϸ�
                    + FormatFloat('000', gvMCAFileCnt)                   // ����
                    + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // Ȯ����
      gvMCAFtpFileList.Add(sAccFileName);

      gf_MCALog('sAccNo: ' + sAccNo);
      gf_MCALog('sAccList: ' + sAccList);

      // Input ����
      FillChar(InputData,SizeOf(InputData),#32);

      sACNT_ADMN_ORGNO := sCustDept;
      sINQR_DT         := sDate;
      sCANO            := LeftStr(sAccNo,8);
      sACNT_PRDT_CD    := Copy(sAccNo,9,2);
      sPOUT_FILE_NAME  := sAccFileName;
      sITFC_ID         := gvMCAInterfaceID;

      myStr2NotNilChar(InputData.ACNT_ADMN_ORGNO  , sACNT_ADMN_ORGNO, Length(sACNT_ADMN_ORGNO) );
      myStr2NotNilChar(InputData.INQR_DT          , sINQR_DT        , Length(sINQR_DT        ) );
      myStr2NotNilChar(InputData.CANO             , sCANO           , Length(sCANO           ) );
      myStr2NotNilChar(InputData.ACNT_PRDT_CD     , sACNT_PRDT_CD   , Length(sACNT_PRDT_CD   ) );
      myStr2NotNilChar(InputData.POUT_FILE_NAME   , sPOUT_FILE_NAME , Length(sPOUT_FILE_NAME ) );
      myStr2NotNilChar(InputData.ITFC_ID          , sITFC_ID        , Length(sITFC_ID        ) );

      InputData._ACNT_ADMN_ORGNO := #16;
      InputData._INQR_DT := #16;
      InputData._CANO := #16;
      InputData._ACNT_PRDT_CD := #16;
      InputData._POUT_FILE_NAME := #16;
      InputData._ITFC_ID := #16;

      gf_MCALog(IntToStr(gvMCAFileCnt) + ' : ' + sAccFileName);
      gf_MCALog('Input.ACNT_ADMN_ORGNO        : ' + InputData.ACNT_ADMN_ORGNO  );
      gf_MCALog('Input.INQR_DT                : ' + InputData.INQR_DT          );
      gf_MCALog('Input.CANO                   : ' + InputData.CANO             );
      gf_MCALog('Input.ACNT_PRDT_CD           : ' + InputData.ACNT_PRDT_CD     );
      gf_MCALog('Input.POUT_FILE_NAME         : ' + InputData.POUT_FILE_NAME   );
      gf_MCALog('Input.ITFC_ID                : ' + InputData.ITFC_ID          );

      // Input ����
      Try
         if (m_hHKCommDLL <> 0) then
        begin
          Sleep(1000);
          //
          iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                      sizeof(TMCAHeader), sizeof(TTFO6141RI1));

          if iResult = 0 then
          begin
             sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
             exit;
          end;
        end else
        begin
          sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
          Exit;
        end;

        while True do
        begin
          EnterCriticalSection(gvMCACriticalSection);
          if gvMCAReceive then
          begin
            gvMCAReceive := False;
            gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
            LeaveCriticalSection(gvMCACriticalSection);

            if gvMCAResult <> 'Y' then
            begin
              gf_MCALog('���� ó�� ����.');
              sOut := '���� ó�� ����.';
              //Exit;
            end;
            Break;
          end;
          LeaveCriticalSection(gvMCACriticalSection);
          Application.ProcessMessages;
          Sleep(100);
        end; // while

        Result := True;

      Except
         On E: Exception do
         begin
            sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
            Exit;
         end;
      End;
    end; // while (sAccList > '') do
  end else
  begin
    gf_MCALog('��ü ��� �ڷ� ����.');
    Inc(gvMCAFileCnt);

    if Pos(',', sAccList) > 0 then
    begin
      // ó�� ��� ���� ã��.
      iComPos := Pos(',', sAccList);
      sAccNo := LeftStr(sAccList,iComPos-1);
      sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);
    end else
    begin
      sAccNo := '';
    end;

    //
    sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // ���� ���ϸ�
                  + FormatFloat('000', gvMCAFileCnt) + 'T'                   // ����
                  + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // Ȯ����
    gvMCAFtpFileList.Add(sAccFileName);

    // Input ����
    FillChar(InputData,SizeOf(InputData),#32);

    sACNT_ADMN_ORGNO := sCustDept;
    sINQR_DT         := sDate;
    sCANO            := LeftStr(sAccNo,8);
    sACNT_PRDT_CD    := Copy(sAccNo,9,2);
    sPOUT_FILE_NAME  := sAccFileName;
    sITFC_ID         := gvMCAInterfaceID;

    myStr2NotNilChar(InputData.ACNT_ADMN_ORGNO  , sACNT_ADMN_ORGNO, Length(sACNT_ADMN_ORGNO) );
    myStr2NotNilChar(InputData.INQR_DT          , sINQR_DT        , Length(sINQR_DT        ) );
    myStr2NotNilChar(InputData.CANO             , sCANO           , Length(sCANO           ) );
    myStr2NotNilChar(InputData.ACNT_PRDT_CD     , sACNT_PRDT_CD   , Length(sACNT_PRDT_CD   ) );
    myStr2NotNilChar(InputData.POUT_FILE_NAME   , sPOUT_FILE_NAME , Length(sPOUT_FILE_NAME ) );
    myStr2NotNilChar(InputData.ITFC_ID          , sITFC_ID        , Length(sITFC_ID        ) );

    InputData._ACNT_ADMN_ORGNO := #16;
    InputData._INQR_DT := #16;
    InputData._CANO := #16;
    InputData._ACNT_PRDT_CD := #16;
    InputData._POUT_FILE_NAME := #16;
    InputData._ITFC_ID := #16;

    gf_MCALog(IntToStr(gvMCAFileCnt) + ' : ' + sAccFileName);
    gf_MCALog('Input.ACNT_ADMN_ORGNO        : ' + InputData.ACNT_ADMN_ORGNO  );
    gf_MCALog('Input.INQR_DT                : ' + InputData.INQR_DT          );
    gf_MCALog('Input.CANO                   : ' + InputData.CANO             );
    gf_MCALog('Input.ACNT_PRDT_CD           : ' + InputData.ACNT_PRDT_CD     );
    gf_MCALog('Input.POUT_FILE_NAME         : ' + InputData.POUT_FILE_NAME   );
    gf_MCALog('Input.ITFC_ID                : ' + InputData.ITFC_ID          );

    // Input ����
    Try
       if (m_hHKCommDLL <> 0) then
      begin
        Sleep(1000);
        // �Ÿ�
        iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                    sizeof(TMCAHeader), sizeof(TTFO6141RI1));

        if iResult = 0 then
        begin
           sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
           exit;
        end;
      end else
      begin
        sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
        Exit;
      end;

      while True do
      begin
        EnterCriticalSection(gvMCACriticalSection);
        if gvMCAReceive then
        begin
          gvMCAReceive := False;
          gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
          LeaveCriticalSection(gvMCACriticalSection);

          if gvMCAResult <> 'Y' then
          begin
            gf_MCALog('���� ó�� ����.');
            sOut := '���� ó�� ����.';
            //Exit;
          end;
          Break;
        end;
        LeaveCriticalSection(gvMCACriticalSection);
        Application.ProcessMessages;
        Sleep(100);
      end; // while

      Result := True;

    Except
       On E: Exception do
       begin
          sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
          Exit;
       end;
    End;
  end; // if (sAccList > '') then

  gf_MCALog('MCA: [TFO6141R] ���� ��� ���� ���� ����.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
//   Log File ���(Thread Safe)
//------------------------------------------------------------------------------
procedure gf_MCALog(S: String);
var
   Hour, Min, Sec, MSec: Word;
begin
   if not gvMCALogFlag then Exit;

   if (Trim(gvMCALogPath) <> '') then   // Log File Write
   begin
      DecodeTime(Now, Hour, Min, Sec, MSec);
      EnterCriticalSection(gvMCALogCriticalSection);
      WriteLn(gvMCALogFile, FormatFloat('00',Hour) + ':' +  FormatFloat('00',Min)
          + ':' +  FormatFloat('00', Sec) + ':' +  FormatFloat('000', MSec) + ' ' + S);
      Flush(gvMCALogFile);
      LeaveCriticalSection(gvMCALogCriticalSection);
   end;
end;

//------------------------------------------------------------------------------
//   Log File Open
//------------------------------------------------------------------------------
procedure gf_StartMCALog(pLogPath, pLogName: string);
var
   FileName: String;
   Year, Month, Day : word;

   Hour, Min, Sec, MSec: Word;
begin
   if not gvMCALogFlag then Exit;
   if Trim(pLogPath) = '' then Exit;

   gvMCALogPath := pLogPath;
   if not DirectoryExists(gvMCALogPath) then
      if not CreateDir(gvMCALogpath) then
         raise Exception.Create('Cannot Create ' + gvMCALogPath);

   InitializeCriticalSection(gvMCALogCriticalSection);
   DecodeDate(Date, Year, Month, Day);

   DecodeTime(Now,  Hour, Min, Sec, MSec);

   FileName := pLogName +
     FormatFloat('0000', Year) + FormatFloat('00', Month) + FormatFloat('00', Day) +
     FormatFloat('00', Hour) + FormatFloat('00', Min) + FormatFloat('00', Sec) +
     '.Txt';
   AssignFile(gvMCALogFile, gvMCALogPath + FileName);
   if FileExists(gvMCALogPath + FileName) then
      Append(gvMCALogFile)
   else
      Rewrite(gvMCALogFile);
end;

//------------------------------------------------------------------------------
//   Log File Close
//------------------------------------------------------------------------------
procedure gf_EndMCALog;
begin
   if not gvMCALogFlag then Exit;

   if (Trim(gvMCALogPath) <> '')  then   // Log File Write
   begin
      EnterCriticalSection(gvMCALogCriticalSection);
      WriteLn(gvMCALogFile, '');
      Flush(gvMCALogFile);
      LeaveCriticalSection(gvMCALogCriticalSection);
      CloseFile(gvMCALogFile);
      DeleteCriticalSection(gvMCALogCriticalSection);
   end;
end;

//------------------------------------------------------------------------------
//  TR�� �������̽�ID ��������( T:�ŸŰ�(������:C), C: ������(������:JAVA) )
//------------------------------------------------------------------------------
procedure gf_tf_GetIDFC_ID(pInterfaceID: string);
begin

  with DataModule_SettleNet.ADOQuery_Main do
  begin
    //-- MCA Interface ID ���� CALL. -----------------------------------------
    gf_Log('MCA Interface ID ���� CALL.');
    Close;
    SQL.Clear;
    SQL.Add('SELECT ETC2                                  ');
    SQL.Add('FROM SUGRPCD_TBL                             ');
    SQL.Add('WHERE GRP = ''11''                           ');
    SQL.Add('  AND NM = (SELECT FTP_ADDR FROM SUFTPIF_TBL ');
    SQL.Add('            WHERE DEPT_CODE = ''00''         ');
    SQL.Add('              AND FTP_NAME = ''FTP SERVER'') ');
    SQL.Add('  AND ETC1 = '''+ pInterfaceID +'''          ');

    Try
      gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
    Except
      on E: Exception do
      begin
        // Database ����
        gf_Log('FTP INFO QUERY [SUGRPCD_TBL(11)]');
        gf_ShowDlgMessage(0, mtError, 9001, 'FTP INFO QUERY [SUGRPCD_TBL(11)]' + E.Message, [mbOK], 0); // Database ����
        Exit;
      end;
    End;

    if (RecordCount = 1) then
    begin
      // ���� ���� ��ġ ������
      gvMCAInterfaceID := Trim(FieldByName('ETC2').AsString);
      gf_MCALog('gvMCAInterfaceID: ' + gvMCAInterfaceID);
    end else
    begin
      gf_Log('MCA �������̽�ID ������ ������ �� �����ϴ�. [SUGRPCD_TBL(11)]');
      gf_ShowDlgMessage(0, mtError, 0, 'MCA �������̽�ID ������ ������ �� �����ϴ�. [SUGRPCD_TBL(11)]', [mbOK], 0); // Database ����
      Exit;
    end;
  end; // with DataModule_SettleNet.ADOQuery_Main do

end;

// Ÿ�μ� ���� ����Ʈ ����
procedure CreateAcEtcList;
begin

  with DataModule_SettleNet.ADOQuery_Main do
  begin
    //-- MCA Interface ID ���� CALL. -----------------------------------------
    gf_Log('MCA Interface ID ���� CALL.');
    Close;
    SQL.Clear;
    SQL.Add('SELECT ACC_NO                          ');
    SQL.Add('FROM SFACETC_TBL                       ');
    SQL.Add('WHERE DEPT_CODE = '''+ gvDeptCode +''' ');

    Try
      gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
    Except
      on E: Exception do
      begin
        // Database ����
        gf_Log('Ÿ�μ� ���� ���� ����. [SFACETC_TBL]');
        gf_ShowDlgMessage(0, mtError, 9001, 'Ÿ�μ� ���� ���� ����.  [SFACETC_TBL]' + E.Message, [mbOK], 0); // Database ����
        Exit;
      end;
    End;

    gvAcEtcList.Clear;

    while not Eof do
    begin
      gvAcEtcList.Add(Trim(FieldByName('ACC_NO').AsString));
      Next;
    end;


  end; // with DataModule_SettleNet.ADOQuery_Main do

end;

// Ÿ�μ� ���� ���� üũ
function AcEtcYn(pAccNo: string): boolean;
var
  i: integer;
begin
  Result := False;
  for i:=0 to gvAcEtcList.Count-1 do
  begin
    if (pAccNo = Trim(gvAcEtcList.Strings[i])) then
    begin
      Result := True;
      Break;
    end;
  end;
end;

//------------------------------------------------------------------------------
// ������ǰ ����&����ó Import Using MCA
//------------------------------------------------------------------------------
function gf_tf_HostMCAsngetZACInfo(sDate, sChgDate, sAccList, sFileName:string;
                           var sOut:string) : boolean;
var
//  sCustDept : string;

  iResult, i, iComPos: integer;

  sAccFileName: string;

  headerInfo : TMCAHeader; // ��� ����
  InputData : TT_FI_ACCI1; // Input

  // Input ����
  sCANO           : string;
  sACNT_PRDT_CD   : string;
  sITFC_ID        : string;
  sPOUT_FILE_NAME : string;

begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TTC3808U] ������ǰ ����&����ó ���� ���� ����.');

  Result := false;

//  sCustDept := '0' + gvDeptCode;

  //----------------------------------------------------------------------------
  // RequestData
  //---------------------------------------------------------------------------
  gvMCAReceive := False;
  iResult := 0;

  // ��� ����
  GetMCAHeaderData(gcMCA_TR_Z_ACC, headerInfo);

  gf_MCALog('headerInfo.TR_Type          : ' + headerInfo.TR_Type          );
  gf_MCALog('headerInfo.Interface_id     : ' + headerInfo.Interface_id     );
  gf_MCALog('headerInfo.Encrypt_flag     : ' + headerInfo.Encrypt_flag     );
  gf_MCALog('headerInfo.Tr_name          : ' + headerInfo.Tr_name          );
  gf_MCALog('headerInfo.Scr_no           : ' + headerInfo.Scr_no           );
  gf_MCALog('headerInfo.Lang_id          : ' + headerInfo.Lang_id          );
  gf_MCALog('headerInfo.Mode_flag        : ' + headerInfo.Mode_flag        );
  gf_MCALog('headerInfo.Tr_cont          : ' + headerInfo.Tr_cont          );
  gf_MCALog('headerInfo.Co_cd            : ' + headerInfo.Co_cd            );
  gf_MCALog('headerInfo.Media_cd1        : ' + headerInfo.Media_cd1        );
  gf_MCALog('headerInfo.Media_cd2        : ' + headerInfo.Media_cd2        );
  gf_MCALog('headerInfo.Org_cd           : ' + headerInfo.Org_cd           );
  gf_MCALog('headerInfo.Seq_no           : ' + headerInfo.Seq_no           );
  gf_MCALog('headerInfo.Dept_cd          : ' + headerInfo.Dept_cd          );
  gf_MCALog('headerInfo.Emp_id           : ' + headerInfo.Emp_id           );
  gf_MCALog('headerInfo.Emp_seq          : ' + headerInfo.Emp_seq          );
  gf_MCALog('headerInfo.User_id          : ' + headerInfo.User_id          );
  gf_MCALog('headerInfo.Br_open_cd       : ' + headerInfo.Br_open_cd       );
  gf_MCALog('headerInfo.Acct_no          : ' + headerInfo.Acct_no          );
  gf_MCALog('headerInfo.MediaFlag        : ' + headerInfo.MediaFlag        );
  gf_MCALog('headerInfo.MediaFlag_Detail : ' + headerInfo.MediaFlag_Detail );
  gf_MCALog('headerInfo.Rt_cd            : ' + headerInfo.Rt_cd            );

  // ���� ����Ʈ
  Inc(gvMCAFileCnt);
  sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '_' // ���� ���ϸ�
                + FormatFloat('000', gvMCAFileCnt)        // ����
                + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // Ȯ����
  gvMCAFtpFileList.Add(sAccFileName);

  // Input ����
  FillChar(InputData,SizeOf(InputData),#32);

  sCANO           := sAccList;
  sACNT_PRDT_CD   := '';
  sITFC_ID        := gvMCAInterfaceID;
  sPOUT_FILE_NAME := sAccFileName;

  myStr2NotNilChar(InputData.CANO           , sCANO           , Length(sCANO          ) );
  myStr2NotNilChar(InputData.ACNT_PRDT_CD   , sACNT_PRDT_CD   , Length(sACNT_PRDT_CD  ) );
  myStr2NotNilChar(InputData.CRE_DT         , sDate           , Length(sDate          ) );
  myStr2NotNilChar(InputData.CHG_DT         , sChgDate        , Length(sChgDate       ) );
  myStr2NotNilChar(InputData.ITFC_ID        , sITFC_ID        , Length(sITFC_ID       ) );
  myStr2NotNilChar(InputData.POUT_FILE_NAME , sPOUT_FILE_NAME , Length(sPOUT_FILE_NAME) );

  InputData._CANO           := #16;
  InputData._ACNT_PRDT_CD   := #16;
  InputData._CRE_DT         := #16;
  InputData._CHG_DT         := #16;
  InputData._ITFC_ID        := #16;
  InputData._POUT_FILE_NAME := #16;

  gf_MCALog(IntToStr(gvMCAFileCnt) + ' : ' + sAccFileName);
  gf_MCALog('Input.CANO            : ' + InputData.CANO             );
  gf_MCALog('Input.ACNT_PRDT_CD    : ' + InputData.ACNT_PRDT_CD     );
  gf_MCALog('Input.CRE_DT          : ' + InputData.CRE_DT           );
  gf_MCALog('Input.CHG_DT          : ' + InputData.CHG_DT           );
  gf_MCALog('Input.sITFC_ID        : ' + InputData.ITFC_ID          );
  gf_MCALog('Input.POUT_FILE_NAME  : ' + InputData.POUT_FILE_NAME   );

  Try
    if (m_hHKCommDLL <> 0) then
    begin
      Sleep(1000);
      //
      iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                  sizeof(TMCAHeader), sizeof(TT_FI_ACCI1));

      if iResult = 0 then
      begin
         sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
         exit;
      end;
    end else
    begin
      sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
      Exit;
    end;

    while True do
    begin
      EnterCriticalSection(gvMCACriticalSection);
      if gvMCAReceive then
      begin
        gvMCAReceive := False;
        gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
        LeaveCriticalSection(gvMCACriticalSection);

        if gvMCAResult <> 'Y' then
        begin
          sOut := '���� ó�� ����.';
          gf_MCALog('���� ó�� ����.');
          //Exit;
        end;
        Break;
      end;
      LeaveCriticalSection(gvMCACriticalSection);
      Application.ProcessMessages;
      Sleep(100);
    end; // while

    Result := true;

  Except
     On E: Exception do
     begin
        sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
        Exit;
     end;
  End;

  gf_MCALog('MCA: [T_FI_ACC] ������ǰ ���� ���� ���� ����.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
// ������ǰ ���� ���� Import Using MCA
//------------------------------------------------------------------------------
function gf_tf_HostMCAsngetZRPTInfo(sDate, sAccList, sFileName:string;
                           var sOut:string) : boolean;
var
//  sCustDept : string;

  iResult, i, iComPos: integer;

  sAccFileName: string;

  headerInfo : TMCAHeader; // ��� ����
  InputData : TT_FI_RPTI1; // Input

  // Input ����
  sCANO           : string;
  sITFC_ID        : string;
  sPOUT_FILE_NAME : string;

begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TTC3808U] ������ǰ ���� ���� ���� ���� ����.');

  Result := false;

//  sCustDept := '0' + gvDeptCode;

  //----------------------------------------------------------------------------
  // RequestData
  //---------------------------------------------------------------------------
  gvMCAReceive := False;
  iResult := 0;

  // ��� ����
  GetMCAHeaderData(gcMCA_TR_Z_RPT, headerInfo);

  gf_MCALog('headerInfo.TR_Type          : ' + headerInfo.TR_Type          );
  gf_MCALog('headerInfo.Interface_id     : ' + headerInfo.Interface_id     );
  gf_MCALog('headerInfo.Encrypt_flag     : ' + headerInfo.Encrypt_flag     );
  gf_MCALog('headerInfo.Tr_name          : ' + headerInfo.Tr_name          );
  gf_MCALog('headerInfo.Scr_no           : ' + headerInfo.Scr_no           );
  gf_MCALog('headerInfo.Lang_id          : ' + headerInfo.Lang_id          );
  gf_MCALog('headerInfo.Mode_flag        : ' + headerInfo.Mode_flag        );
  gf_MCALog('headerInfo.Tr_cont          : ' + headerInfo.Tr_cont          );
  gf_MCALog('headerInfo.Co_cd            : ' + headerInfo.Co_cd            );
  gf_MCALog('headerInfo.Media_cd1        : ' + headerInfo.Media_cd1        );
  gf_MCALog('headerInfo.Media_cd2        : ' + headerInfo.Media_cd2        );
  gf_MCALog('headerInfo.Org_cd           : ' + headerInfo.Org_cd           );
  gf_MCALog('headerInfo.Seq_no           : ' + headerInfo.Seq_no           );
  gf_MCALog('headerInfo.Dept_cd          : ' + headerInfo.Dept_cd          );
  gf_MCALog('headerInfo.Emp_id           : ' + headerInfo.Emp_id           );
  gf_MCALog('headerInfo.Emp_seq          : ' + headerInfo.Emp_seq          );
  gf_MCALog('headerInfo.User_id          : ' + headerInfo.User_id          );
  gf_MCALog('headerInfo.Br_open_cd       : ' + headerInfo.Br_open_cd       );
  gf_MCALog('headerInfo.Acct_no          : ' + headerInfo.Acct_no          );
  gf_MCALog('headerInfo.MediaFlag        : ' + headerInfo.MediaFlag        );
  gf_MCALog('headerInfo.MediaFlag_Detail : ' + headerInfo.MediaFlag_Detail );
  gf_MCALog('headerInfo.Rt_cd            : ' + headerInfo.Rt_cd            );

  // ���� ���� ����Ʈ
  Inc(gvMCAFileCnt);
  sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '_' // ���� ���ϸ�
                + FormatFloat('000', gvMCAFileCnt)        // ����
                + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // Ȯ����
  gvMCAFtpFileList.Add(sAccFileName);

  // Input ����
  FillChar(InputData,SizeOf(InputData),#32);

  sCANO           := sAccList;
  sITFC_ID        := gvMCAInterfaceID;
  sPOUT_FILE_NAME := sAccFileName;

  myStr2NotNilChar(InputData.CANO           , sCANO           , Length(sCANO          ) );
  myStr2NotNilChar(InputData.ITFC_ID        , sITFC_ID        , Length(sITFC_ID       ) );
  myStr2NotNilChar(InputData.POUT_FILE_NAME , sPOUT_FILE_NAME , Length(sPOUT_FILE_NAME) );

  InputData._CANO           := #16;
  InputData._ITFC_ID        := #16;
  InputData._POUT_FILE_NAME := #16;

  gf_MCALog(IntToStr(gvMCAFileCnt) + ' : ' + sAccFileName);
  gf_MCALog('Input.CANO            : ' + InputData.CANO             );
  gf_MCALog('Input.sITFC_ID        : ' + InputData.ITFC_ID          );
  gf_MCALog('Input.POUT_FILE_NAME  : ' + InputData.POUT_FILE_NAME   );

  Try
    if (m_hHKCommDLL <> 0) then
    begin
      Sleep(1000);
      //
      iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                  sizeof(TMCAHeader), sizeof(TT_FI_RPTI1));

      if iResult = 0 then
      begin
         sOut := '���� ȣ�� ����: ' + IntToStr(iResult);
         exit;
      end;
    end else
    begin
      sOut := '���� ȣ�� ����: DLL Load Error. (HKServerCommDLL.dll)';
      Exit;
    end;

    while True do
    begin
      EnterCriticalSection(gvMCACriticalSection);
      if gvMCAReceive then
      begin
        gvMCAReceive := False;
        gf_MCALog('CopyData OK. [Result:' + gvMCAResult + ']');
        LeaveCriticalSection(gvMCACriticalSection);

        if gvMCAResult <> 'Y' then
        begin
          sOut := '���� ó�� ����.';
          gf_MCALog('���� ó�� ����.');
          //Exit;
        end;
        Break;
      end;
      LeaveCriticalSection(gvMCACriticalSection);
      Application.ProcessMessages;
      Sleep(100);
    end; // while

    Result := true;

  Except
     On E: Exception do
     begin
        sOut := '���� ó�� ����(): ' + E.Message + ': ' + IntToStr(iResult);
        Exit;
     end;
  End;

  gf_MCALog('MCA: [T_FI_ACC] ������ǰ ���� ���� ���� ���� ����.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;


end.
