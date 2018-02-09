//==============================================================================
//   SettleNet Library (Only 한국증권)
//   [Y.K.J] 2011.08.08
//           추가: 한국투자증권 차세대 시스템(MCA)으로 인한 추가
//==============================================================================

unit SCCTFLib;

interface

uses
   Windows, SysUtils, IniFiles, Forms, Dialogs, ADOdb, StrUtils, Classes,
   SCCTFGlobalType;

//------------------------------------------------------------------------------
//  MCA 시스템 Call
//------------------------------------------------------------------------------

// MCA 서버 접속 요청 Call
function gf_tf_HostMCAConnect(FirstConnect: boolean; var sOut: string): boolean;

// MCA 서버 접속 해제 Call
procedure gf_tf_HostMCADisConnect(var sOut: string);

// 주식  //

//주식 계좌자료 생성 Call (한투용)
function gf_tf_HostMCAsngetACInfo(sDate,sAccList,sFileName:string;
                          var sOut:string) : boolean;

//주식 매매자료 생성 Call (한투용)
function gf_tf_HostMCAsngetTRInfo(sDate,sAccList,sFileName:string;
                          var sOut:string) : boolean;

//주식 결제업무 마감 처리 Call (한투용)
function gf_tf_HostMCAprocessStlClose(sDate, sWorkCode, sWorkAuthority:string;
                                        var sOut:string) : boolean;

//주식 정정내역 Upload Call (한투용)
function gf_tf_HostMCAsnprocessUploadData(sDate, sFileName, sWorkCode:string;
                          var sOut:string) : boolean;

//주식 계좌 내역 Upload Call (한투용)
function gf_tf_HostMCAsnprocessUploadACData(sDate, sFileName, sWorkCode, sDelType:string;
                          var sOut:string) : boolean;

//원장에서 수수료계산(한투용)
function gf_tf_HostMCACalculate(
          sIssueCode, sTranCode, sTrdType, sAccNo, sStlDate:string;
          dAvrExecPrice, dTotExecQty, dTotExecAmt: double;
          var dComm, dTrdTax, dAgcTax, dCpgTax, dNetAmt, dHCommRate: double;
          var sOut : string) : boolean;

// 선물  //

//선물 계좌정보 자료 생성 MCA Call (한투용)
function gf_tf_HostMCAsngetFACInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;

//선물 수수료정보 자료 생성 MCA Call (한투용)
function gf_tf_HostMCAsngetFCmInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;

//선물 예탁자료 생성 MCA Call (한투용)
function gf_tf_HostMCAsngetFDPInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;

//선물 매매자료 생성 MCA Call (한투용)
function gf_tf_HostMCAsngetFTRInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;

//선물 미결제자료 생성 MCA Call (한투용)
function gf_tf_HostMCAsngetFOPInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;

//선물 대용자료 생성 MCA Call (한투용)
function gf_tf_HostMCAsngetFLNInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;


// 금융상품 //

//금융상품 계좌&수신처 자료 생성 Call (한투용)
function gf_tf_HostMCAsngetZACInfo(sDate, sChgDate, sAccList, sFileName:string;
                          var sOut:string) : boolean;

//금융상품 보고서 전문 자료 생성 Call (한투용)
function gf_tf_HostMCAsngetZRPTInfo(sDate, sAccList, sFileName:string;
                          var sOut:string) : boolean;


//-- 기타 함수 모음 --

//  TR별 인터페이스ID 가져오기( T:매매계(개발툴:C), C: 계정계(개발툴:JAVA) )
procedure gf_tf_GetIDFC_ID(pInterfaceID: string);

// MCA HeaderData 구하기
procedure GetMCAHeaderData(MCA_TRName: string; var HeaderItem: TMCAHeader);

// 타부서 계좌 리스트 생성
procedure CreateAcEtcList;

// 타부서 계좌 여부 체크
function AcEtcYn(pAccNo: string): boolean;

//------------------------------------------------------------------------------
//  Log File 처리
//------------------------------------------------------------------------------
// MCA Log File 기록(Thread Safe)
procedure gf_MCALog(S: String);
// MCA Log File Open
procedure gf_StartMCALog(pLogPath, pLogName: string);
// MCA Log File Close
procedure gf_EndMCALog;


implementation

uses
   SCCLib, SCCGlobalType, SCCDataModule;


//------------------------------------------------------------------------------
// Upload 시 데이터 가져오기(SEUPLOAD2_TBL)
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
// 계좌별 Upload - 삭제시 계좌 리스트 가져오기(SEUPLOAD2_TBL)
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
    // 삭제유형에 따른 처리.
    if (pDelType = gwTotal) then
    // 전체 삭제.
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
    // 처리대상 계좌만 삭제.
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
// MCA Interface 문자변환(문자끝 Nil 없애기)
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
// MCA HeaderData 구하기
//------------------------------------------------------------------------------
procedure GetMCAHeaderData(MCA_TRName: string; var HeaderItem: TMCAHeader);
var
  // 헤더 정보
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

  sTR_Type          := '';          // 거래유형
  sEncrypt_flag     := '';          // 암호/압축/공인인증/IP4, IP6 구분 플래그
  sTr_name          := MCA_TRName;  // TR(Service) Name
  sScr_no           := '00000';     // 화면 번호
  sLang_id          := 'K';         // 언어 종류(K: 한국어, E: 영어)
  sMode_flag        := '1';         // 개발/운영 플래그(1: 개발, 2: 운영)
  sTr_cont          := '';          // 연속 거래 여부
  sCo_cd            := 'A';         // 회사 코드
  sMedia_cd1        := '01';        // 매체 구분(01: 한국단말)
  sMedia_cd2        := '00000';     // 입력매체상세구분([일반지점]00000: TO_BE지점코드)
  sOrg_cd           := '01710';     // 조직코드
  sSeq_no           := '301';       // 일련번호
  sDept_cd          := '01710';     // 조작자 부서코드
  sEmp_id           := gvOprEmpID;  // 조작자 사번
  sEmp_seq          := '';          // 조작자 연번
  sUser_id          := '';          // HTS ID(직원용 : Space, 고객용 : HTS ID)
  sBr_open_cd       := '';          // 계좌 개설점
  sAcct_no          := '';          // 계좌번호
  sMediaFlag        := '';          // 입력매체구분
  sMediaFlag_Detail := '';          // 거래입력매체상세구분
  sRt_cd            := '';          // 성공 실패 여부
                                        // 0: 정상처리
                                        // 1: 시스템오류
                                        // 2:
                                        // 3: Dummy Return
                                        // 4: ROLLBACK_NORMAL_RETURN
                                        // 5: COMMIT_BLANK_RETURN
                                        // 6: SKIP_AND_GO
                                        // 7: 응용 오류

  // Interface ID 구하기(T:매매계, C:계정계)
  if (MCA_TRName = gcMCA_TR_E_ACC       ) or   // 주식 계좌정보 Import
     (MCA_TRName = gcMCA_TR_E_TRADE     ) or   // 주식 매매내역 Import
     (MCA_TRName = gcMCA_TR_E_UPLOAD    ) or   // 주식 정정내역 Upload
     (MCA_TRName = gcMCA_TR_F_TRADE     ) then // 선물 매매내역 Import
  begin
    sInterface_id := 'T';
  end else
  if (MCA_TRName = gcMCA_TR_E_CLOSE     ) or   // 주식 결제업무 마감 체크
     (MCA_TRName = gcMCA_TR_E_CALC_COMM ) or   // 주식 수수료계산
     (MCA_TRName = gcMCA_TR_E_UPLOAD_ACC) or   // 주식 계좌최종내역 Upload
     (MCA_TRName = gcMCA_TR_F_ACC       ) or   // 선물 계좌정보 Import
     (MCA_TRName = gcMCA_TR_F_DEPOSIT   ) or   // 선물 예탁내역 Import
     (MCA_TRName = gcMCA_TR_F_OPEN      ) or   // 선물 미결제내역 Import
     (MCA_TRName = gcMCA_TR_F_COLT      ) or   // 선물 대용내역 Import
     (MCA_TRName = gcMCA_TR_F_COMM_INFO ) or   // 선물 계좌 수수료정보 Import
     (MCA_TRName = gcMCA_TR_Z_ACC       ) or   // 금융상품 계좌 Import
     (MCA_TRName = gcMCA_TR_Z_RPT       ) then // 금융상품 보고서 전문 Import
  begin
    sInterface_id := 'C';
  end;

  // INPUT.ITFC_ID 설정 (gvMCAInterfaceID)
  gf_tf_GetIDFC_ID(sInterface_id);

  // 헤더 초기화
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
// MCA 서버 접속 요청 Call
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
          // 처음 접속(세틀넷 실행하였을때)하였을때 에러 체크.
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
// MCA 서버 접속 해제 Call
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
//주식 계좌 Import Using MCA
// todo: 주식 계좌 Import - gf_HostMCAsngetACInfo()
//------------------------------------------------------------------------------
function gf_tf_HostMCAsngetACInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;
var
  sCustDept : string;

  iResult, i, iComPos: integer;

  sAccNo,
  sAccFileName: string;

  headerInfo : TMCAHeader; // 헤더 정보
  InputData : TTTC3808UI1; // Input

  // Input 정보
  sCANO           : string;
  sACNT_PRDT_CD   : string;
  sORGNO          : string;
  sWORK_DT        : string;
  sITFC_ID        : string;
  sPOUT_FILE_NAME : string;

begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TTC3808U] 주식 계좌 파일 생성 시작.');

  Result := false;

  sCustDept := '0' + gvDeptCode;

  //----------------------------------------------------------------------------
  // RequestData
  //---------------------------------------------------------------------------
  gvMCAReceive := False;
  iResult := 0;

  // 헤더 정보
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

  // 대상 계좌수 만큼 루프
  if (sAccList > '') then
  begin
    while (sAccList > '') do
    begin
      gf_MCALog('계좌별 계좌 자료 생성.');
      Inc(gvMCAFileCnt);

          if Pos(',', sAccList) > 0 then
          begin
            // 처리 대상 계좌 찾기.
            iComPos := Pos(',', sAccList);
            sAccNo := LeftStr(sAccList,iComPos-1);
            sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);
          end else
          begin
            sAccNo := '';
          end;

          //
      sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '_' // 기존 파일명
                    + FormatFloat('000', gvMCAFileCnt)                   // 순번
                    + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // 확장자
      gvMCAFtpFileList.Add(sAccFileName);

          gf_MCALog('sAccNo: ' + sAccNo);
          gf_MCALog('sAccList: ' + sAccList);

      // Input 정보
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
             sOut := '원장 호출 오류: ' + IntToStr(iResult);
             exit;
          end;
        end else
        begin
          sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
              sOut := '원장 처리 오류.';
              gf_MCALog('원장 처리 오류.');
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
            sOut := '원장 호출() 오류: ' + E.Message + ': ' + IntToStr(iResult);
            Exit;
         end;
      End;
    end;

  end else
  begin
    // 전체 매매 임포트
    gf_MCALog('전체 계좌 자료 생성.');
    Inc(gvMCAFileCnt);
    sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '_' // 기존 파일명
                  + FormatFloat('000', gvMCAFileCnt) + 'T'        // 순번
                  + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // 확장자
    gvMCAFtpFileList.Add(sAccFileName);

    // Input 정보
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
           sOut := '원장 호출 오류: ' + IntToStr(iResult);
           exit;
        end;
      end else
      begin
        sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
            sOut := '원장 처리 오류.';
            gf_MCALog('원장 처리 오류.');
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
          sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
          Exit;
       end;
    End;
  end; // if (sAccList > '') then

  gf_MCALog('MCA: [TTC3808U] 주식 계좌 파일 생성 종료.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
//매매 Import Using MCA
// TODO: 주식 매매 Import - gf_HostMCAsngetTRInfo()
//------------------------------------------------------------------------------
function gf_tf_HostMCAsngetTRInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;
var
  sCustDept : string;

  iResult, i, iComPos: integer;

  sAccNo,
  sAccFileName: string;

  headerInfo : TMCAHeader; // 한투 차세대 DLL 헤더 정보

  InputData : TTTC3809UI; // 주식 매매 Input

  // Input 정보
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
  gf_MCALog('MCA: [TTC3809U] 주식 매매 파일 생성 시작.');

  Result := false;

  sCustDept := '0' + gvDeptCode;

  gvMCAReceive := False;
  iResult := 0;

  // 헤더 초기화
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

    gf_MCALog('계좌별 매매 자료 생성.');

    // Input 정보
    FillChar(InputData,SizeOf(InputData),#32);

    // TTC3809U1
    //sSize := FormatFloat('0000', gcMCA_IN_ARRAY_SIZE_TRADE);
    //myStr2NotNilChar(InputData.SIZE, sSize, Length(sSize) );

    //gf_MCALog('InputData.SIZE              : ' + InputData.SIZE  );

    i:= 0;

    // 대상 계좌수 만큼 루프
    while (sAccList > '') do
    begin

      // 최대 갯수 만큼 루프: 데이터 올리고 초기화
      if (i >= gcMCA_IN_STRING_SIZE_TRADE) then
      begin
        // 파일명 생성 구문
        Inc(gvMCAFileCnt);
        sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '_' // 기존 파일명
                      + FormatFloat('000', gvMCAFileCnt)                   // 순번
                      + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // 확장자
        gvMCAFtpFileList.Add(sAccFileName);

        // 계좌 리스트 생성 후 구분자 찍기
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
        gf_MCALog(IntToStr(gvMCAFileCnt) + ' 번째 파일 생성 : ' + sAccFileName);

        // 꽉 찬 데이터 내보내기
        Try
          if (m_hHKCommDLL <> 0) then
          begin
            Sleep(1000);
            //
            iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                        sizeof(TMCAHeader), sizeof(TTTC3809UI));

            if iResult = 0 then
            begin
              sOut := '원장 호출 오류: ' + IntToStr(iResult);
              exit;
            end;

          end else
          begin
            sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
                gf_MCALog('원장 처리 오류.');
                sOut := '원장 처리 오류.';
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
            sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
            Exit;
          end;
        End;

        // 초기화
        FillChar(InputData,SizeOf(InputData),#32);

        i:= 0;
        //sSize := FormatFloat('0000', gcMCA_IN_ARRAY_SIZE_TRADE);
        //myStr2NotNilChar(InputData.SIZE, sSize, Length(sSize) );

        //gf_MCALog('InputData.SIZE              : ' + InputData.SIZE  );
      end; // if (i >= gcMCA_IN_ARRAY_SIZE_UPLOAD_ACC) then

      if Pos(',', sAccList) > 0 then
      begin
        // 처리 대상 계좌 찾기.
        iComPos := Pos(',', sAccList);
        sAccNo := LeftStr(sAccList,iComPos-1);
        sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);
        //gf_MCALog('처리 대상 계좌번호: ' + sAccNo);
        //gf_MCALog('처리할 계좌 목록: ' + sAccList);
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


    // 파일명 생성 구문
    Inc(gvMCAFileCnt);
    sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '_' // 기존 파일명
                  + FormatFloat('000', gvMCAFileCnt)                   // 순번
                  + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // 확장자
    gvMCAFtpFileList.Add(sAccFileName);

    // 계좌 리스트 생성 후 구분자 찍기
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
    gf_MCALog(IntToStr(gvMCAFileCnt) + ' 번째 파일 생성 : ' + sAccFileName);

    Try
       if (m_hHKCommDLL <> 0) then
      begin
        Sleep(1000);
        // 매매
        iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                    sizeof(TMCAHeader), sizeof(TTTC3809UI));

        if iResult = 0 then
        begin
           sOut := '원장 호출 오류: ' + IntToStr(iResult);
           exit;
        end;
      end else
      begin
        sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
            sOut := '원장 처리 오류.';
            gf_MCALog('원장 처리 오류.');
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
          sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
          Exit;
       end;
    End;

  end else
  begin
    gf_MCALog('전체 매매 자료 생성.');

    // TTC3809UI
    //sSize := FormatFloat('0000', gcMCA_IN_ARRAY_SIZE_TRADE);
    //myStr2NotNilChar(InputData.SIZE, sSize, Length(sSize) );

    //gf_MCALog('InputData.SIZE              : ' + InputData.SIZE  );

    // 전체 매매 임포트
    Inc(gvMCAFileCnt);
    sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '_' // 기존 파일명
                  + FormatFloat('000', gvMCAFileCnt) + 'T'        // 순번
                  + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // 확장자
    gvMCAFtpFileList.Add(sAccFileName);

    // Input 정보
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
    gf_MCALog(IntToStr(gvMCAFileCnt) + ' 번째 파일 생성 : ' + sAccFileName);

    Try
       if (m_hHKCommDLL <> 0) then
      begin
        Sleep(1000);
        // 매매
        iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                    sizeof(TMCAHeader), sizeof(TTTC3809UI));

        if iResult = 0 then
        begin
           sOut := '원장 호출 오류: ' + IntToStr(iResult);
           exit;
        end;
      end else
      begin
        sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
            sOut := '원장 처리 오류.';
            gf_MCALog('원장 처리 오류.');
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
          sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
          Exit;
       end;
    End;

  end; // if (sAccList > '') then

  Result := True;

  gf_MCALog('MCA: [TTC3809U] 주식 매매 파일 생성 종료.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
//주식 결제업무 마감 체크 Call (한투용)
// TODO: 주식 결제업무 마감 체크 - gf_tf_HostMCAprocessStlClose()
//>>>> 파라미터 값 설명 <<<<
// 1. sWorkCode (작업구분)
//      - 01: 조회, 02: 등록
// 2. sWorkAuthority (작업권한)
//     - SN: 세틀넷(사용자권한;기본값)
//     - 01: WINK
//     - SM: 세틀넷(관리자권한;마감해지시 사용)
//------------------------------------------------------------------------------
function gf_tf_HostMCAprocessStlClose(sDate, sWorkCode, sWorkAuthority:string;
                                        var sOut:string) : boolean;
var
  sCustDept : string;

  iResult, i, iDataSeq: integer;

  headerInfo : TMCAHeader; // 헤더 정보

  InputData : TTSC6315UI; // Input

  // Input
  sSize              : string;

  // InputData는 공란으로 올려도 무방 함.
  sORGNO             : string;
  sCLSG_YN           : string;
  sPRCS_DVSN_CD      : string;
  sTRAD_DT           : string;
  sTRAD_STTL_PRCS_AFRS_DVSN_CD : string;
begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TSC6315U] 주식 결제업무마감 시작.');
  gf_MCALog('작업구분: ' + sWorkCode + ', 권한: ' + sWorkAuthority);

  Result := false;

  iDataSeq := 0;

  sCustDept := '0' + gvDeptCode;

  gvMCAReceive := False;
  iResult := 0;

  // 헤더 초기화
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

  // Input 초기화
  FillChar(InputData,SizeOf(InputData),#32);

  sPRCS_DVSN_CD     := sWorkCode; // 01: 조회, 02: 등록
  sTRAD_DT          := sDate;
  sTRAD_STTL_PRCS_AFRS_DVSN_CD := sWorkAuthority; // SN: 세틀넷, 01: WINK, SM : 세틀넷관리자
  sORGNO            := sCustDept;
  // 마감 등록(02) 요청이면 마감 체크
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
  // 마감 요청 처리
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
        sOut := '원장 호출 오류: ' + IntToStr(iResult);
        exit;
      end;

    end else
    begin
      sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
          sOut := '원장 처리 오류.';
          gf_MCALog('원장 처리 오류.');
          Exit;
        end;

        if (gvMCACloseResult <> 'Y') and
           (gvMCACloseResult <> 'N') then
        begin
          sOut := '결제업무 마감 처리 오류. ';
          gf_MCALog('결제업무 마감 처리 오류. ');
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
      sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
      Exit;
    end;
  End;

  gf_MCALog('MCA: [TSC6315U] 주식 결제업무마감 종료.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
//MCA Upload Call
//WorkCode : 입력 '01', 삭제 '02', 계좌반영 '03'
// todo: 주식 정정내역 업로드 - gf_HostMCAsnprocessUploadData()
//------------------------------------------------------------------------------
function gf_tf_HostMCAsnprocessUploadData(sDate, sFileName, sWorkCode:string;
          var sOut:string) : boolean;
var
  sCustDept, sZeroSpace : string;

  iResult, i, iDataSeq, iStrCnt: integer;

  headerInfo : TMCAHeader; // 헤더 정보

  InputData : TTTC6317UI; // Input

  // Input [Array]
  sSize                 : string;
  sCHNG_BF_CANO         : string; // FROM종합계좌번호
  sCHNG_BF_ACNT_PRDT_CD : string; // FROM계좌상품코드
  sORGT_ODNO            : string; // From주문지번호
  sCHNG_AF_CANO         : string; // TO종합계좌번호
  sCHNG_AF_ACNT_PRDT_CD : string; // TO계좌상품코드
  sOPNT_ODNO1           : string; // To주문지번호
  sPDNO                 : string; // 상품코드
  sF_TRTX_TXTN_YN       : string; // From과세여부
  sT_TRTX_TXTN_YN       : string; // To과세여부
  sEXCG_DVSN_CD         : string; // 장구분
  sTRAN_MTD             : string; // 매매방법
  sCOM_TYPE             : string; // 매체종류
  sSLL_BUY_DVSN_CD      : string; // 매매구분
  sGUBUN                : string; // 작업구분
  sMTRL_DVSN_CD         : string; // 자료구분

  dTRAD_FEE_RT          : double; // 수수료율
  dAVG_UNPR             : double; // 평균단가
  dSTTL_QTY             : double; // 수량
  dAGRM_AMT             : double; // 약정금액
  dFEE                  : double; // 수수료
  dTAXA                 : double; // 제세금

  sTRAD_FEE_RT          : string; // 수수료율
  sAVG_UNPR             : string; // 평균단가
  sSTTL_QTY             : string; // 수량
  sAGRM_AMT             : string; // 약정금액
  sFEE                  : string; // 수수료
  sTAXA                 : string; // 제세금

  // Input [Single]
  sWORK_DVSN_CD         : string;
  sADMN_ORGNO           : string;
  sTRAD_DT              : string;
  sDATA_CNT             : string;

  iLoofCnt: Integer;
begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TTC6317U] 주식 매매 정정/분할 내역 업로드 시작.');

  Result := false;

  iDataSeq := 0;

  sCustDept := '0' + gvDeptCode;

  gvMCAReceive := False;
  iResult := 0;

  // 헤더 정보
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


  // Input 정보
  with DataModule_SettleNet.ADOQuery_Main do
  begin

    // !!01:입력 외에는 데이터 필요없음.
    if sWorkCode = '01' then
    begin
      // 업로드 데이터 가져오기(SEUPLOAD2_TBL)
      if Not GetSEUPLOAD2_TBL(DataModule_SettleNet.ADOQuery_Main,
              sFileName, sDate, sOut) then
      begin
        sOut := 'gf_tf_HostMCAsnprocessUploadData: ' + sOut;
        Exit;
      end;
      gf_MCALog('Upload Data GET. (SEUPLOAD2_TBL)');

    end; // if sWorkCode = '01' then

    // Input Structure 스페이스 초기화
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
        // ArraySize만큼 루프: 데이터 올리고 초기화
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

          // 꽉 찬 데이터 내보내기
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
                sOut := '원장 호출 오류: ' + IntToStr(iResult);
                exit;
              end;

            end else
            begin
              sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
                  gf_MCALog('원장 처리 오류.');
                  sOut := '원장 처리 오류.';
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
              sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
              Exit;
            end;
          End;

          // 초기화
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

        // 상품번호(종목코드)
        sZeroSpace := '';
        for iStrCnt:=1 to SizeOf(InputData.OCCURS_IN1[i].PDNO)-
                          Length(Trim(FieldByName('ISSUE_CODE').AsString)) do
        begin
          sZeroSpace := sZeroSpace + '0';
        end;
        sPDNO := sZeroSpace + Trim(FieldByName('ISSUE_CODE').AsString);

        // From과세여부
        sF_TRTX_TXTN_YN      := Trim(FieldByName('F_TAXGBJJ_YN').AsString);
        // To과세여부
        sT_TRTX_TXTN_YN      := Trim(FieldByName('T_TAXGBJJ_YN').AsString);

        // 장구분
        sEXCG_DVSN_CD        := Copy(Trim(FieldByName('TRAN_CODE').AsString),2,1);
        // 매매방법
        sTRAN_MTD            := Copy(Trim(FieldByName('TRAN_CODE').AsString),3,1);
        // 매체종류
        sCOM_TYPE            := Copy(Trim(FieldByName('TRAN_CODE').AsString),4,1);

        // 매매구분
        sSLL_BUY_DVSN_CD     := Trim(FieldByName('TRADE_TYPE').AsString);

        // 작업구분
        sGUBUN               := Trim(FieldByName('GUBUN').AsString);
        // 자료구분
        if Trim(FieldByName('DATA_GB').AsString) = 'T' then
          sMTRL_DVSN_CD      := '1'
        else
          sMTRL_DVSN_CD      := '2';

        // 수수료율
        dTRAD_FEE_RT         := (FieldByName('COMM_RATE').AsFloat);
        // 평균단가
        dAVG_UNPR            := (FieldByName('EXEC_PRICE').AsFloat);
        // 수량
        dSTTL_QTY            := (FieldByName('EXEC_QTY').AsFloat);
        // 약정금액
        dAGRM_AMT            := (FieldByName('EXEC_AMT').AsFloat);
        // 수수료
        dFEE                 := (FieldByName('COMM').AsFloat);
        // 세금
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
        // 변수 초기화
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
        sOut := '원장 호출 오류: ' + IntToStr(iResult);
        exit;
      end;

    end else
    begin
      sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
          gf_MCALog('원장 처리 오류.');
          sOut := '원장 처리 오류.';
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
      sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
      Exit;
    end;
  End;

  Result := true;

  gf_MCALog('MCA: [TTC6317U] 주식 매매 정정/분할 내역 업로드 종료.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
//MCA 계좌별 Upload Call
//WorkCode : 입력 '01', 삭제 '02'
// todo: 주식 계좌별 업로드 - gf_HostMCAsnprocessUploadACData
//------------------------------------------------------------------------------
function gf_tf_HostMCAsnprocessUploadACData(sDate, sFileName, sWorkCode, sDelType:string;
          var sOut:string) : boolean;
var
  sCustDept, sZeroSpace : string;

  iResult, i, iDataSeq, iStrCnt: integer;

  headerInfo : TMCAHeader; // 헤더 정보
  InputData : TTSC6307UI; // Input

  // Input
  sSize                 : string;
  sCHNG_BF_CANO         : string; // 변경전종합계좌번호
  sCHNG_BF_ACNT_PRDT_CD : string; // 변경전계좌상품코드
  sCHNG_AF_CANO         : string; // 변경후종합계좌번호
  sCHNG_AF_ACNT_PRDT_CD : string; // 변경후계좌상품코드
  sPDNO                 : string; // 상품번호          
  sEXCG_DVSN_CD         : string; // 거래소구분코드    
  sTRTX_TXTN_YN         : string; // 거래세과세여부    
  sSTTL_ORD_DVSN_CD     : string; // 결제주문구분코드  
  sORD_MDIA_DVSN_CD     : string; // 주문매체구분코드
  sSLL_BUY_DVSN_CD      : string; // 매도매수구분코드
  sMTRL_DVSN_CD         : string; // 자료구분코드      
  
  dSTTL_QTY             : double; // 결제수량
  dSTTL_PRIC            : double; // 결제가격
  dAVG_UNPR             : double; // 평균단가
  dSTTL_AMT             : double; // 결제금액
  dFEE                  : double; // 수수료
  dTAX_SMTL_AMT         : double; // 세금합계금액

  sSTTL_QTY             : string; // 결제수량    
  sSTTL_PRIC            : string; // 결제가격    
  sAVG_UNPR             : string; // 평균단가    
  sSTTL_AMT             : string; // 결제금액    
  sFEE                  : string; // 수수료      
  sTAX_SMTL_AMT         : string; // 세금합계금액

  sWORK_DVSN_CD         : string;
  sORGNO                : string;
  sTRAD_DT              : string;
  sDATA_CNT             : string;
begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TSC6307U] 주식 매매 최종 내역 업로드 시작.');

  Result := false;

  iDataSeq := 0;

  sCustDept := '0' + gvDeptCode;

  gvMCAReceive := False;
  iResult := 0;

  // 헤더 정보
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
                           
  // Input 정보
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

    // Input Structure 스페이스 초기화
    FillChar(InputData,SizeOf(InputData),#32);

    // TSC6307UI2
    sSize := FormatFloat('0000', gcMCA_IN_ARRAY_SIZE_UPLOAD_ACC);
    myStr2NotNilChar(InputData.SIZE, sSize, Length(sSize) );

    gf_MCALog('InputData.SIZE              : ' + InputData.SIZE  );

    i:= 0;

    First;
    while Not Eof do
    begin

      // ArraySize만큼 루프: 데이터 올리고 초기화
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

        // 꽉 찬 데이터 내보내기
        Try
          if (m_hHKCommDLL <> 0) then
          begin
            Sleep(1000);
            //
            iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                        sizeof(TMCAHeader), sizeof(TTSC6307UI));

            if iResult = 0 then
            begin
              sOut := '원장 호출 오류: ' + IntToStr(iResult);
              exit;
            end;

          end else
          begin
            sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
                gf_MCALog('원장 처리 오류.');
                sOut := '원장 처리 오류.';
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
            sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
            Exit;
          end;
        End;

        // 초기화
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

      // 상품번호(종목코드)
      sZeroSpace := '';
      for iStrCnt:=1 to SizeOf(InputData.OCCURS_IN1[i].PDNO)-
                        Length(Trim(FieldByName('ISSUE_CODE').AsString)) do
      begin
        sZeroSpace := sZeroSpace + '0';
      end;
      sPDNO := sZeroSpace + Trim(FieldByName('ISSUE_CODE').AsString);

      // 거래소구분코드(01:장외, 02:거래소, 03:코스닥, 04:프리보드)
      if (Copy(Trim(FieldByName('TRAN_CODE').AsString),3,1) = '2') then
        sEXCG_DVSN_CD        := '01'  // 장외(단주)
      else
      if (Copy(Trim(FieldByName('TRAN_CODE').AsString),2,1) = '1') then
        sEXCG_DVSN_CD        := '02'  // 거래소
      else
      if (Copy(Trim(FieldByName('TRAN_CODE').AsString),2,1) = '2') then
        sEXCG_DVSN_CD        := '03'  // 코스닥
      else
        sEXCG_DVSN_CD        := '01'; // 그 외(장외)

      // 거래세과세여부(기존f/t가 나뉘어짐)(Y:과세, N:비과세)
      sTRTX_TXTN_YN        := Trim(FieldByName('T_TAXGBJJ_YN').AsString);

      // 결제주문구분코드(01:일반, 02:차익(or프로그램), 11:비회원위탁, 12:비회원상품)
      if (Copy(Trim(FieldByName('TRAN_CODE').AsString),3,1) = '4') then
        sSTTL_ORD_DVSN_CD    := '02'
      else
        sSTTL_ORD_DVSN_CD    := '01';


      // 주문매체구분코드(01:OFFLINE, 02: ONLINE, 03:ARS, 04: 그 외)
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

      // 자료구분코드  
      sMTRL_DVSN_CD        := Trim(FieldByName('DATA_GB').AsString);
      dSTTL_QTY            :=     (FieldByName('EXEC_QTY').AsFloat);
      dSTTL_PRIC           :=     (FieldByName('EXEC_PRICE').AsFloat);
      dAVG_UNPR            := 0; //  평균단가(0으로 채우기)
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

      // 변수 초기화
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
        sOut := '원장 호출 오류: ' + IntToStr(iResult);
        exit;
      end;

    end else
    begin
      sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
          gf_MCALog('원장 처리 오류.');
          sOut := '원장 처리 오류.';
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
      sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
      Exit;
    end;
  End;

  Result := true;

  gf_MCALog('MCA: [TSC6307U] 주식 매매 최종 내역 업로드 종료.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
//주식 수수료 계산 처리 Call (한투용)
// TODO: 주식 수수료계산 처리 - gf_HostMCACalculate()
//------------------------------------------------------------------------------
function gf_tf_HostMCACalculate(
          sIssueCode, sTranCode, sTrdType, sAccNo, sStlDate: string;
          dAvrExecPrice, dTotExecQty, dTotExecAmt: double;
          var dComm, dTrdTax, dAgcTax, dCpgTax, dNetAmt, dHCommRate: double;
          var sOut : string) : boolean;
var
  sCustDept, sZeroSpace: string;

  iResult, i, iDataSeq, iStrCnt: integer;

  headerInfo : TMCAHeader; // 헤더 정보
  InputData  : TTSC3220RI1; // Input

  // Input
  sEXCG_DVSN_CD     : string; // 거래소구분코드
  sPDNO             : string; // 상품번호
  sPRDT_TYPE_CD     : string; // 상품유형코드
  sSLL_BUY_DVSN_CD  : string; // 매도매수구분코드
  sTRTX_TXTN_YN     : string; // 거래세과세여부
  sORD_MDIA_DVSN_CD : string; // 주문매체구분코드
  sCANO             : string; // 종합계좌번호
  sACNT_PRDT_CD     : string; // 계좌상품코드
  sSTTL_DT          : string; // 결제일자

  sAVG_UNPR         : string; // 평균단가
  sTOT_CCLD_QTY     : string; // 총체결수량
  sTOT_CCLD_AMT     : string; // 총체결금액

  sComm,   sTrdTax, sAgcTax,
  sCpgTax, sNetAmt, sHCommRate : string;
begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TSC3220R] 주식 수수료 계산 시작.');
  
  Result := false;

  iDataSeq := 0;

  sCustDept := '0' + gvDeptCode;

  gvMCAReceive := False;
  iResult := 0;

  // 헤더 정보
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

  // Input Structure 스페이스 초기화
  FillChar(InputData,SizeOf(InputData),#32);

  // 거래소구분코드
  if (Copy(sTranCode,2,1) = '1') then sEXCG_DVSN_CD := '02'
  else
  if (Copy(sTranCode,2,1) = '2') then sEXCG_DVSN_CD := '03'
  else
    sEXCG_DVSN_CD := '01';

  // 상품번호(종목코드)
  sZeroSpace := '';
  for iStrCnt:=1 to SizeOf(InputData.PDNO)-
                    Length(sIssueCode) do
  begin
    sZeroSpace := sZeroSpace + '0';
  end;
  sPDNO := sZeroSpace + sIssueCode;

  // 상품유형코드
  sPRDT_TYPE_CD := '300';

  // 매도매수구분코드
  if (sTrdType = 'S') then sSLL_BUY_DVSN_CD     := '01'
  else
  if (sTrdType = 'B') then sSLL_BUY_DVSN_CD     := '02';

  // 거래세과세여부
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

  // 주문매체구분코드
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

  // 종합계좌번호
  sCANO := LeftStr(sAccNo,8);

  // 계좌상품코드
  sACNT_PRDT_CD := Copy(sAccNo,9,2);

  // 결제일자
  sSTTL_DT := sStlDate;

  // 평균단가
  sAVG_UNPR     := FormatFloat('0000000000.0000000000',dAvrExecPrice);
  sAVG_UNPR     := StringReplace(sAVG_UNPR,'.','',[rfReplaceAll]);

  // 총체결수량
  sTOT_CCLD_QTY := FormatFloat('0000000000', dTotExecQty);

  // 총체결금액
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
        sOut := '원장 호출 오류: ' + IntToStr(iResult);
        exit;
      end;

    end else
    begin
      sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
          gf_MCALog('원장 처리 오류.');
          sOut := '원장 처리 오류.';
          Exit;
        end else
        // 정상처리 데이터 수수료계산 값 넣기
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

          // 현재 처리 대기중인 자료인지 확인.
          if (Trim(InputData.EXCG_DVSN_CD    ) <> Trim(gvMCAInputData_CalcComm.EXCG_DVSN_CD    )) or
             (Trim(InputData.PDNO            ) <> Trim(gvMCAInputData_CalcComm.PDNO            )) or
             (Trim(InputData.SLL_BUY_DVSN_CD ) <> Trim(gvMCAInputData_CalcComm.SLL_BUY_DVSN_CD )) or
             (Trim(InputData.TRTX_TXTN_YN    ) <> Trim(gvMCAInputData_CalcComm.TRTX_TXTN_YN    )) or
             (Trim(InputData.ORD_MDIA_DVSN_CD) <> Trim(gvMCAInputData_CalcComm.ORD_MDIA_DVSN_CD)) or
             (Trim(InputData.CANO            ) <> Trim(gvMCAInputData_CalcComm.CANO            )) or
             (Trim(InputData.ACNT_PRDT_CD    ) <> Trim(gvMCAInputData_CalcComm.ACNT_PRDT_CD    )) then
          begin
            gf_MCALog('요청자료 Input 값 불일치.');
            sOut := '요청자료 Input 값 불일치.';
            Exit;
          end;

          gf_MCALog('계산된 수수료 : '   + gvMCAOutputData_CalcComm.FEE     );
          gf_MCALog('계산된 거래세 : '   + gvMCAOutputData_CalcComm.TRTX    );
          gf_MCALog('계산된 농특세 : '   + gvMCAOutputData_CalcComm.FSTX    );
          gf_MCALog('계산된 양도세 : '   + gvMCAOutputData_CalcComm.TRFX    );
          gf_MCALog('계산된 결제금액 : ' + gvMCAOutputData_CalcComm.EXCC_AMT);
          gf_MCALog('계산전 수수료율 : ' + gvMCAOutputData_CalcComm.FEE_RT  );
          Try
            StrToFloat(gvMCAOutputData_CalcComm.FEE_RT);
          Except
            gf_MCALog('수수료율 값 오류.');
          End;
          gf_MCALog('계산된 수수료율 : ' + FloatToStr(StrToFloat(gvMCAOutputData_CalcComm.FEE_RT) / 100000000) );

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
              sOut := '수수료계산 중 변환 에러. ' + E.Message;
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
      sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
      Exit;
    end;
  End;

  Result := true;

  gf_MCALog('MCA: [TSC3220R] 주식 수수료 계산 종료.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;


//------------------------------------------------------------------------------
//선물 계좌 Import Using MCA
// todo: 선물 계좌 Import - gf_HostMCAsngetFACInfo()
//------------------------------------------------------------------------------
function gf_tf_HostMCAsngetFAcInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;
var
  sCustDept : string;

  iResult, i, iComPos: integer;

  sAccNo,
  sAccFileName: string;

  headerInfo : TMCAHeader; // 한투 차세대 DLL 헤더 정보

  InputData : TTFO6137RI1; // 선물 계좌정보 Input

  // Input 정보
  sACNT_ADMN_ORGNO : string;
  sINQR_DT         : string;
  sCANO            : string;
  sACNT_PRDT_CD    : string;
  sPOUT_FILE_NAME  : string;
  sITFC_ID         : string;

begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TFO6137R] 선물 계좌 파일 생성 시작.');

  Result := false;

  sCustDept := '0' + gvDeptCode;

  gvMCAReceive := False;
  iResult := 0;

  //-- 헤더 초기화 -----------------------------------------------------------
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

  // 대상 계좌수 만큼 루프
  if (sAccList > '') then
  begin
    while (sAccList > '') do
    begin
      gf_MCALog('계좌별 계좌정보 자료 생성.');
      Inc(gvMCAFileCnt);

      if Pos(',', sAccList) > 0 then
      begin
        // 처리 대상 계좌 찾기.
        iComPos := Pos(',', sAccList);
        sAccNo := LeftStr(sAccList,iComPos-1);
        sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);

        // 타부서 계좌 체크(타부서 계좌이면 부서코드 공란)
        if AcEtcYn(sAccNo) then sCustDept := '';
      end else
      begin
        sAccNo := '';
      end;

      //
      sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // 기존 파일명
                    + FormatFloat('000', gvMCAFileCnt)                   // 순번
                    + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // 확장자
      gvMCAFtpFileList.Add(sAccFileName);

      gf_MCALog('sAccNo: ' + sAccNo);
      gf_MCALog('sAccList: ' + sAccList);

      //-- Input 정보 ------------------------------------------------------------
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

      // Input 정보
      Try
         if (m_hHKCommDLL <> 0) then
        begin
          Sleep(1000);
          //
          iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                      sizeof(TMCAHeader), sizeof(TTFO6137RI1));

          if iResult = 0 then
          begin
            sOut := '원장 호출 오류: ' + IntToStr(iResult);
            exit;
          end;
        end else
        begin
          sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
              gf_MCALog('원장 처리 오류.');
              sOut := '원장 처리 오류.';
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
            sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
            Exit;
         end;
      End;
    end; // while (sAccList > '') do

  end else
  begin
    gf_MCALog('전체 계좌정보 자료 생성.');
    Inc(gvMCAFileCnt);

    if Pos(',', sAccList) > 0 then
    begin
      // 처리 대상 계좌 찾기.
      iComPos := Pos(',', sAccList);
      sAccNo := LeftStr(sAccList,iComPos-1);
      sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);
    end else
    begin
      sAccNo := '';
    end;

    //
    sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // 기존 파일명
                  + FormatFloat('000', gvMCAFileCnt) + 'T'        // 순번
                  + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // 확장자
    gvMCAFtpFileList.Add(sAccFileName);

    //-- Input 정보 ------------------------------------------------------------
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

    // Input 정보
    Try
       if (m_hHKCommDLL <> 0) then
      begin
        Sleep(1000);
        //
        iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                    sizeof(TMCAHeader), sizeof(TTFO6137RI1));

        if iResult = 0 then
        begin
           sOut := '원장 호출 오류: ' + IntToStr(iResult);
           exit;
        end;
      end else
      begin
        sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
            gf_MCALog('원장 처리 오류.');
            sOut := '원장 처리 오류.';
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
          sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
          Exit;
       end;
    End;
  end; // if (sAccList > '') then

  gf_MCALog('MCA: [TFO6137R] 선물 계좌 파일 생성 종료.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
//선물 수수료정보 Import Using MCA
// todo: 선물 수수료코드 Import - gf_tf_HostMCAsngetFCmInfo()
//------------------------------------------------------------------------------
function gf_tf_HostMCAsngetFCmInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;
var
  sCustDept : string;

  iResult, i, iComPos: integer;

  sAccNo,
  sAccFileName: string;

  headerInfo : TMCAHeader; // 헤더 정보
  InputData : TTFO6142RI1; // Input

  // Input 정보
  sACNT_ADMN_ORGNO : string;
  sINQR_DT         : string;
  sCANO            : string;
  sACNT_PRDT_CD    : string;
  sPOUT_FILE_NAME  : string;
  sITFC_ID         : string;

begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TFO6142R] 선물 수수료정보 파일 생성 시작.');

  Result := false;

  sCustDept := '0' + gvDeptCode;

  gvMCAReceive := False;
  iResult := 0;

  // 헤더 정보
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

  // 대상 계좌수 만큼 루프
  if (sAccList > '') then
  begin
    while (sAccList > '') do
    begin
      gf_MCALog('계좌별 수수료정보 자료 생성.');
      Inc(gvMCAFileCnt);

      if Pos(',', sAccList) > 0 then
      begin
        // 처리 대상 계좌 찾기.
        iComPos := Pos(',', sAccList);
        sAccNo := LeftStr(sAccList,iComPos-1);
        sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);

        // 타부서 계좌 체크(타부서 계좌이면 부서코드 공란)
        if AcEtcYn(sAccNo) then sCustDept := '';
      end else
      begin
        sAccNo := '';
      end;

      //
      sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // 기존 파일명
                    + FormatFloat('000', gvMCAFileCnt)                  // 순번
                    + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // 확장자
      gvMCAFtpFileList.Add(sAccFileName);

      gf_MCALog('sAccNo: ' + sAccNo);
      gf_MCALog('sAccList: ' + sAccList);

      // Input 정보
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

      // Input 정보
      Try
         if (m_hHKCommDLL <> 0) then
        begin
          Sleep(1000);
          // 
          iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                      sizeof(TMCAHeader), sizeof(TTFO6142RI1));

          if iResult = 0 then
          begin
             sOut := '원장 호출 오류: ' + IntToStr(iResult);
             exit;
          end;
        end else
        begin
          sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
              gf_MCALog('원장 처리 오류.');
              sOut := '원장 처리 오류.';
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
            sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
            Exit;
         end;
      End;
    end; // while (sAccList > '') do
  end else
  begin
    gf_MCALog('전체 수수료정보 자료 생성.');
    Inc(gvMCAFileCnt);

    if Pos(',', sAccList) > 0 then
    begin
      // 처리 대상 계좌 찾기.
      iComPos := Pos(',', sAccList);
      sAccNo := LeftStr(sAccList,iComPos-1);
      sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);
    end else
    begin
      sAccNo := '';
    end;

    //
    sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // 기존 파일명
                  + FormatFloat('000', gvMCAFileCnt) + 'T'                  // 순번
                  + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // 확장자
    gvMCAFtpFileList.Add(sAccFileName);

    // Input 정보
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

    // Input 정보
    Try
       if (m_hHKCommDLL <> 0) then
      begin
        Sleep(1000);
        // 
        iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                    sizeof(TMCAHeader), sizeof(TTFO6142RI1));

        if iResult = 0 then
        begin
           sOut := '원장 호출 오류: ' + IntToStr(iResult);
           exit;
        end;
      end else
      begin
        sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
            gf_MCALog('원장 처리 오류.');
            sOut := '원장 처리 오류.';
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
          sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
          Exit;
       end;
    End;
  end; // if (sAccList > '') then

  gf_MCALog('MCA: [TFO6142R] 선물 수수료정보 파일 생성 종료.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
//선물 예탁 Import Using MCA
// todo: 선물 예탁 Import - gf_HostMCAsngetFDPInfo()
//------------------------------------------------------------------------------
function gf_tf_HostMCAsngetFDPInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;
var
  sCustDept : string;
  
  iResult, i, iComPos: integer;

  sAccNo,
  sAccFileName: string;

  headerInfo : TMCAHeader; // 헤더 정보

  InputData : TTFO6138RI1; // Input

  // Input 정보
  sACNT_ADMN_ORGNO : string;
  sINQR_DT         : string;
  sCANO            : string;
  sACNT_PRDT_CD    : string;
  sPOUT_FILE_NAME  : string;
  sITFC_ID         : string;

begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TFO6138R] 선물 예탁 파일 생성 시작.');

  Result := false;

  // 타부서 계좌는 부서코드(계좌관리조직번호) 공란으로
  sCustDept := '0' + gvDeptCode;

  gvMCAReceive := False;
  iResult := 0;

  // 헤더 초기화
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
    // 대상 계좌수 만큼 루프
    while (sAccList > '') do
    begin
      gf_MCALog('계좌별 예탁 자료 생성.');
      Inc(gvMCAFileCnt);

      if Pos(',', sAccList) > 0 then
      begin
        // 처리 대상 계좌 찾기.
        iComPos := Pos(',', sAccList);
        sAccNo := LeftStr(sAccList,iComPos-1);
        sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);

        // 타부서 계좌 체크(타부서 계좌이면 부서코드 공란)
        if AcEtcYn(sAccNo) then sCustDept := '';
      end else
      begin
        sAccNo := '';
      end;

      //
      sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // 기존 파일명
                    + FormatFloat('000', gvMCAFileCnt)              // 순번
                    + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // 확장자
      gvMCAFtpFileList.Add(sAccFileName);

      gf_MCALog('sAccNo: ' + sAccNo);
      gf_MCALog('sAccList: ' + sAccList);

      // Input 정보
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

      // Input 정보
      Try
         if (m_hHKCommDLL <> 0) then
        begin
          Sleep(1000);
          //
          iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                      sizeof(TMCAHeader), sizeof(TTFO6138RI1));

          if iResult = 0 then
          begin
             sOut := '원장 호출 오류: ' + IntToStr(iResult);
             exit;
          end;
        end else
        begin
          sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
              gf_MCALog('원장 처리 오류.');
              sOut := '원장 처리 오류.';
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
            sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
            Exit;
         end;
      End;
    end; // while
  end else
  begin
    gf_MCALog('전체 예탁 자료 생성.');
    Inc(gvMCAFileCnt);

    if Pos(',', sAccList) > 0 then
    begin
      // 처리 대상 계좌 찾기.
      iComPos := Pos(',', sAccList);
      sAccNo := LeftStr(sAccList,iComPos-1);
      sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);
    end else
    begin
      sAccNo := '';
    end;

    //
    sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // 기존 파일명
                  + FormatFloat('000', gvMCAFileCnt) + 'T'              // 순번
                  + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // 확장자
    gvMCAFtpFileList.Add(sAccFileName);

    // Input 정보
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

    // Input 정보
    Try
       if (m_hHKCommDLL <> 0) then
      begin
        Sleep(1000);
        // 매매
        iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                    sizeof(TMCAHeader), sizeof(TTFO6138RI1));

        if iResult = 0 then
        begin
           sOut := '원장 호출 오류: ' + IntToStr(iResult);
           exit;
        end;
      end else
      begin
        sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
            gf_MCALog('원장 처리 오류.');
            sOut := '원장 처리 오류.';
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
          sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
          Exit;
       end;
    End;
  end; // if (sAccList > '') then

  gf_MCALog('MCA: [TFO6138R] 선물 예탁 파일 생성 종료.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
//선물 매매 Import Using MCA
// todo: 선물 매매 Import - gf_HostMCAsngetFTRInfo()
//------------------------------------------------------------------------------
function gf_tf_HostMCAsngetFTRInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;
var
  sCustDept : string;
  
  iResult, i, iComPos: integer;

  sAccNo,
  sAccFileName: string;

  headerInfo : TMCAHeader; // 헤더 정보

  InputData : TTTO9008RI1; // Input

  // Input 정보
  sACNT_ADMN_ORGNO : string;
  sINQR_DT         : string;
  sCANO            : string;
  sACNT_PRDT_CD    : string;
  sPOUT_FILE_NAME  : string;
  sITFC_ID         : string;

begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TFO6139R] 선물 매매 파일 생성 시작.');

  Result := false;

  sCustDept := '0' + gvDeptCode;

  gvMCAReceive := False;
  iResult := 0;

  // 헤더 초기화
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
    // 대상 계좌수 만큼 루프
    while (sAccList > '') do
    begin
      gf_MCALog('계좌별 매매 자료 생성.');
      Inc(gvMCAFileCnt);


      if Pos(',', sAccList) > 0 then
      begin
        // 처리 대상 계좌 찾기.
        iComPos := Pos(',', sAccList);
        sAccNo := LeftStr(sAccList,iComPos-1);
        sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);

        // 타부서 계좌 체크(타부서 계좌이면 부서코드 공란)
        if AcEtcYn(sAccNo) then sCustDept := '';
      end else
      begin
        sAccNo := '';
      end;

      //
      sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // 기존 파일명
                    + FormatFloat('000', gvMCAFileCnt)                   // 순번
                    + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // 확장자
      gvMCAFtpFileList.Add(sAccFileName);

      gf_MCALog('sAccNo: ' + sAccNo);
      gf_MCALog('sAccList: ' + sAccList);

      // Input 정보
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

      // Input 정보
      Try
         if (m_hHKCommDLL <> 0) then
        begin
          Sleep(1000);
          // 매매
          iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                      sizeof(TMCAHeader), sizeof(TTFO6138RI1));

          if iResult = 0 then
          begin
             sOut := '원장 호출 오류: ' + IntToStr(iResult);
             exit;
          end;
        end else
        begin
          sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
              gf_MCALog('원장 처리 오류.');
              sOut := '원장 처리 오류.';
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
            sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
            Exit;
         end;
      End;
    end; // while (sAccList > '') do
  end else
  begin
    gf_MCALog('전체 매매 자료 생성.');
    Inc(gvMCAFileCnt);


    if Pos(',', sAccList) > 0 then
    begin
      // 처리 대상 계좌 찾기.
      iComPos := Pos(',', sAccList);
      sAccNo := LeftStr(sAccList,iComPos-1);
      sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);
    end else
    begin
      sAccNo := '';
    end;

    //
    sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // 기존 파일명
                  + FormatFloat('000', gvMCAFileCnt) + 'T'                   // 순번
                  + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // 확장자
    gvMCAFtpFileList.Add(sAccFileName);

    gf_MCALog('sAccNo: ' + sAccNo);
    gf_MCALog('sAccList: ' + sAccList);

    // Input 정보
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

    // Input 정보
    Try
       if (m_hHKCommDLL <> 0) then
      begin
        Sleep(1000);
        //
        iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                    sizeof(TMCAHeader), sizeof(TTFO6138RI1));

        if iResult = 0 then
        begin
           sOut := '원장 호출 오류: ' + IntToStr(iResult);
           exit;
        end;
      end else
      begin
        sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
            gf_MCALog('원장 처리 오류.');
            sOut := '원장 처리 오류.';
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
          sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
          Exit;
       end;
    End;
  end; // if (sAccList > '') then

  gf_MCALog('MCA: [TFO6139R] 선물 매매 파일 생성 종료.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
//선물 미결제 Import Using MCA
// todo: 선물 미결제 Import - gf_HostMCAsngetFOPInfo()
//------------------------------------------------------------------------------
function gf_tf_HostMCAsngetFOPInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;
var
  sCustDept : string;

  iResult, i, iComPos: integer;

  sAccNo,
  sAccFileName: string;

  headerInfo : TMCAHeader; // 한투 차세대 DLL 헤더 정보

  InputData : TTFO6140RI1; // 선물 매매 Input

  // Input 정보
  sACNT_ADMN_ORGNO : string;
  sINQR_DT         : string;
  sCANO            : string;
  sACNT_PRDT_CD    : string;
  sPOUT_FILE_NAME  : string;
  sITFC_ID         : string;

begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TFO6140R] 선물 미결제 파일 생성 시작.');

  Result := false;

  sCustDept := '0' + gvDeptCode;

  gvMCAReceive := False;
  iResult := 0;

  // 헤더 초기화
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
    // 대상 계좌수 만큼 루프
    while (sAccList > '') do
    begin
      gf_MCALog('계좌별 미결제 자료 생성.');
      Inc(gvMCAFileCnt);

      if Pos(',', sAccList) > 0 then
      begin
        // 처리 대상 계좌 찾기.
        iComPos := Pos(',', sAccList);
        sAccNo := LeftStr(sAccList,iComPos-1);
        sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);

        // 타부서 계좌 체크(타부서 계좌이면 부서코드 공란)
        if AcEtcYn(sAccNo) then sCustDept := '';
      end else
      begin
        sAccNo := '';
      end;

      //
      sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // 기존 파일명
                    + FormatFloat('000', gvMCAFileCnt)                   // 순번
                    + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // 확장자
      gvMCAFtpFileList.Add(sAccFileName);

      gf_MCALog('sAccNo: ' + sAccNo);
      gf_MCALog('sAccList: ' + sAccList);

      // Input 정보
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

      // Input 정보
      Try
         if (m_hHKCommDLL <> 0) then
        begin
          Sleep(1000);
          //
          iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                      sizeof(TMCAHeader), sizeof(TTFO6140RI1));

          if iResult = 0 then
          begin
             sOut := '원장 호출 오류: ' + IntToStr(iResult);
             exit;
          end;
        end else
        begin
          sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
              gf_MCALog('원장 처리 오류.');
              sOut := '원장 처리 오류.';
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
            sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
            Exit;
         end;
      End;
    end;
  end else
  begin
    gf_MCALog('전체 미결제 자료 생성.');
    Inc(gvMCAFileCnt);

    if Pos(',', sAccList) > 0 then
    begin
      // 처리 대상 계좌 찾기.
      iComPos := Pos(',', sAccList);
      sAccNo := LeftStr(sAccList,iComPos-1);
      sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);
    end else
    begin
      sAccNo := '';
    end;

    //
    sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // 기존 파일명
                  + FormatFloat('000', gvMCAFileCnt) + 'T'                   // 순번
                  + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // 확장자
    gvMCAFtpFileList.Add(sAccFileName);

    // Input 정보
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

    // Input 정보
    Try
       if (m_hHKCommDLL <> 0) then
      begin
        Sleep(1000);
        //
        iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                    sizeof(TMCAHeader), sizeof(TTFO6140RI1));

        if iResult = 0 then
        begin
           sOut := '원장 호출 오류: ' + IntToStr(iResult);
           exit;
        end;
      end else
      begin
        sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
            gf_MCALog('원장 처리 오류.');
            sOut := '원장 처리 오류.';
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
          sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
          Exit;
       end;
    End;
  end;
  
  gf_MCALog('MCA: [TFO6140R] 선물 미결제 파일 생성 종료.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
//선물 대용 Import Using MCA
// todo: 선물 대용 Import - gf_HostMCAsngetFLNInfo()
//------------------------------------------------------------------------------
function gf_tf_HostMCAsngetFLNInfo(sDate,sAccList,sFileName:string;
                           var sOut:string) : boolean;
var
  sCustDept : string;

  iResult, i, iComPos, iFileSeq: integer;

  sAccNo,
  sAccFileName: string;

  headerInfo : TMCAHeader; // 헤더 정보

  InputData : TTFO6141RI1; // Input

  // Input 정보
  sACNT_ADMN_ORGNO : string;
  sINQR_DT         : string;
  sCANO            : string;
  sACNT_PRDT_CD    : string;
  sPOUT_FILE_NAME  : string;
  sITFC_ID         : string;

begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TFO6141R] 선물 대용 파일 생성 시작.');
  
  Result := false;

  sCustDept := '0' + gvDeptCode;

  gvMCAReceive := False;
  iResult := 0;

  // 헤더 초기화
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
    // 대상 계좌수 만큼 루프
    while (sAccList > '') do
    begin
      gf_MCALog('계좌별 대용 자료 생성.');
      Inc(gvMCAFileCnt);

      if Pos(',', sAccList) > 0 then
      begin
        // 처리 대상 계좌 찾기.
        iComPos := Pos(',', sAccList);
        sAccNo := LeftStr(sAccList,iComPos-1);
        sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);

        // 타부서 계좌 체크(타부서 계좌이면 부서코드 공란)
        if AcEtcYn(sAccNo) then sCustDept := '';
      end else
      begin
        sAccNo := '';
      end;

      //
      sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // 기존 파일명
                    + FormatFloat('000', gvMCAFileCnt)                   // 순번
                    + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // 확장자
      gvMCAFtpFileList.Add(sAccFileName);

      gf_MCALog('sAccNo: ' + sAccNo);
      gf_MCALog('sAccList: ' + sAccList);

      // Input 정보
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

      // Input 정보
      Try
         if (m_hHKCommDLL <> 0) then
        begin
          Sleep(1000);
          //
          iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                      sizeof(TMCAHeader), sizeof(TTFO6141RI1));

          if iResult = 0 then
          begin
             sOut := '원장 호출 오류: ' + IntToStr(iResult);
             exit;
          end;
        end else
        begin
          sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
              gf_MCALog('원장 처리 오류.');
              sOut := '원장 처리 오류.';
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
            sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
            Exit;
         end;
      End;
    end; // while (sAccList > '') do
  end else
  begin
    gf_MCALog('전체 대용 자료 생성.');
    Inc(gvMCAFileCnt);

    if Pos(',', sAccList) > 0 then
    begin
      // 처리 대상 계좌 찾기.
      iComPos := Pos(',', sAccList);
      sAccNo := LeftStr(sAccList,iComPos-1);
      sAccList := Copy(sAccList,iComPos+1,Length(sAccList)-iComPos);
    end else
    begin
      sAccNo := '';
    end;

    //
    sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '-' // 기존 파일명
                  + FormatFloat('000', gvMCAFileCnt) + 'T'                   // 순번
                  + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // 확장자
    gvMCAFtpFileList.Add(sAccFileName);

    // Input 정보
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

    // Input 정보
    Try
       if (m_hHKCommDLL <> 0) then
      begin
        Sleep(1000);
        // 매매
        iResult := m_pRequestData(PCHAR(@headerInfo), PCHAR(@InputData),
                    sizeof(TMCAHeader), sizeof(TTFO6141RI1));

        if iResult = 0 then
        begin
           sOut := '원장 호출 오류: ' + IntToStr(iResult);
           exit;
        end;
      end else
      begin
        sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
            gf_MCALog('원장 처리 오류.');
            sOut := '원장 처리 오류.';
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
          sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
          Exit;
       end;
    End;
  end; // if (sAccList > '') then

  gf_MCALog('MCA: [TFO6141R] 선물 대용 파일 생성 종료.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
//   Log File 기록(Thread Safe)
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
//  TR별 인터페이스ID 가져오기( T:매매계(개발툴:C), C: 계정계(개발툴:JAVA) )
//------------------------------------------------------------------------------
procedure gf_tf_GetIDFC_ID(pInterfaceID: string);
begin

  with DataModule_SettleNet.ADOQuery_Main do
  begin
    //-- MCA Interface ID 정보 CALL. -----------------------------------------
    gf_Log('MCA Interface ID 정보 CALL.');
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
        // Database 오류
        gf_Log('FTP INFO QUERY [SUGRPCD_TBL(11)]');
        gf_ShowDlgMessage(0, mtError, 9001, 'FTP INFO QUERY [SUGRPCD_TBL(11)]' + E.Message, [mbOK], 0); // Database 오류
        Exit;
      end;
    End;

    if (RecordCount = 1) then
    begin
      // 파일 생성 위치 지정용
      gvMCAInterfaceID := Trim(FieldByName('ETC2').AsString);
      gf_MCALog('gvMCAInterfaceID: ' + gvMCAInterfaceID);
    end else
    begin
      gf_Log('MCA 인터페이스ID 정보를 가져올 수 없습니다. [SUGRPCD_TBL(11)]');
      gf_ShowDlgMessage(0, mtError, 0, 'MCA 인터페이스ID 정보를 가져올 수 없습니다. [SUGRPCD_TBL(11)]', [mbOK], 0); // Database 오류
      Exit;
    end;
  end; // with DataModule_SettleNet.ADOQuery_Main do

end;

// 타부서 계좌 리스트 생성
procedure CreateAcEtcList;
begin

  with DataModule_SettleNet.ADOQuery_Main do
  begin
    //-- MCA Interface ID 정보 CALL. -----------------------------------------
    gf_Log('MCA Interface ID 정보 CALL.');
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
        // Database 오류
        gf_Log('타부서 계좌 쿼리 오류. [SFACETC_TBL]');
        gf_ShowDlgMessage(0, mtError, 9001, '타부서 계좌 쿼리 오류.  [SFACETC_TBL]' + E.Message, [mbOK], 0); // Database 오류
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

// 타부서 계좌 여부 체크
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
// 금융상품 계좌&수신처 Import Using MCA
//------------------------------------------------------------------------------
function gf_tf_HostMCAsngetZACInfo(sDate, sChgDate, sAccList, sFileName:string;
                           var sOut:string) : boolean;
var
//  sCustDept : string;

  iResult, i, iComPos: integer;

  sAccFileName: string;

  headerInfo : TMCAHeader; // 헤더 정보
  InputData : TT_FI_ACCI1; // Input

  // Input 정보
  sCANO           : string;
  sACNT_PRDT_CD   : string;
  sITFC_ID        : string;
  sPOUT_FILE_NAME : string;

begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TTC3808U] 금융상품 계좌&수신처 파일 생성 시작.');

  Result := false;

//  sCustDept := '0' + gvDeptCode;

  //----------------------------------------------------------------------------
  // RequestData
  //---------------------------------------------------------------------------
  gvMCAReceive := False;
  iResult := 0;

  // 헤더 정보
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

  // 계좌 임포트
  Inc(gvMCAFileCnt);
  sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '_' // 기존 파일명
                + FormatFloat('000', gvMCAFileCnt)        // 순번
                + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // 확장자
  gvMCAFtpFileList.Add(sAccFileName);

  // Input 정보
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
         sOut := '원장 호출 오류: ' + IntToStr(iResult);
         exit;
      end;
    end else
    begin
      sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
          sOut := '원장 처리 오류.';
          gf_MCALog('원장 처리 오류.');
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
        sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
        Exit;
     end;
  End;

  gf_MCALog('MCA: [T_FI_ACC] 금융상품 계좌 파일 생성 종료.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;

//------------------------------------------------------------------------------
// 금융상품 보고서 전문 Import Using MCA
//------------------------------------------------------------------------------
function gf_tf_HostMCAsngetZRPTInfo(sDate, sAccList, sFileName:string;
                           var sOut:string) : boolean;
var
//  sCustDept : string;

  iResult, i, iComPos: integer;

  sAccFileName: string;

  headerInfo : TMCAHeader; // 헤더 정보
  InputData : TT_FI_RPTI1; // Input

  // Input 정보
  sCANO           : string;
  sITFC_ID        : string;
  sPOUT_FILE_NAME : string;

begin
  gf_MCALog('MCA: --------------------------------------------------------------');
  gf_MCALog('MCA: [TTC3808U] 금융상품 보고서 전문 파일 생성 시작.');

  Result := false;

//  sCustDept := '0' + gvDeptCode;

  //----------------------------------------------------------------------------
  // RequestData
  //---------------------------------------------------------------------------
  gvMCAReceive := False;
  iResult := 0;

  // 헤더 정보
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

  // 보고서 전문 임포트
  Inc(gvMCAFileCnt);
  sAccFileName := Copy(sFileName, 1, Length(sFileName)-4) + '_' // 기존 파일명
                + FormatFloat('000', gvMCAFileCnt)        // 순번
                + Copy(sFileName, Length(sFileName)-3, Length(sFileName)); // 확장자
  gvMCAFtpFileList.Add(sAccFileName);

  // Input 정보
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
         sOut := '원장 호출 오류: ' + IntToStr(iResult);
         exit;
      end;
    end else
    begin
      sOut := '원장 호출 오류: DLL Load Error. (HKServerCommDLL.dll)';
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
          sOut := '원장 처리 오류.';
          gf_MCALog('원장 처리 오류.');
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
        sOut := '원장 처리 오류(): ' + E.Message + ': ' + IntToStr(iResult);
        Exit;
     end;
  End;

  gf_MCALog('MCA: [T_FI_ACC] 금융상품 보고서 전문 파일 생성 종료.');
  gf_MCALog('MCA: --------------------------------------------------------------');
end;


end.
