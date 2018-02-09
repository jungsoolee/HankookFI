//==============================================================================
//   SettleNet Global Type (Only 한국증권)
//   [Y.K.J] 2011.08.08
//           추가: 한국투자증권 차세대 시스템(MCA)으로 인한 추가
//==============================================================================

unit SCCTFGlobalType;

interface

uses
  Windows, Classes;

const
  // MCA TR명 정의
  gcMCA_TR_E_ACC        = 'TTC3808U'; // 주식 계좌정보 Import TR명
  gcMCA_TR_E_TRADE      = 'TTC3809U'; // 주식 매매정보 Import TR명
  gcMCA_TR_E_CLOSE      = 'TSC6315U'; // 주식 결제 업무 마감 체크 TR명
  gcMCA_TR_E_CALC_COMM  = 'TSC3220R'; // 주식 수수료 계산 TR명
  gcMCA_TR_E_UPLOAD_ACC = 'TSC6307U'; // 주식 최종내역 업로드 TR명
  gcMCA_TR_E_UPLOAD     = 'TTC6317U'; // 주식 정정내역 업로드 TR명

  gcMCA_TR_F_ACC        = 'TFO6137R'; // 선물 계좌정보 Import TR명
  gcMCA_TR_F_DEPOSIT    = 'TFO6138R'; // 선물 예탁정보 Import TR명
  gcMCA_TR_F_TRADE      = 'TTO9008R'; // 선물 매매정보 Import TR명
  gcMCA_TR_F_OPEN       = 'TFO6140R'; // 선물 미결제정보 Import TR명
  gcMCA_TR_F_COLT       = 'TFO6141R'; // 선물 대용정보 Import TR명
  gcMCA_TR_F_COMM_INFO  = 'TFO6142R'; // 선물 계좌별 수수료정보 Import TR명

  gcMCA_TR_Z_ACC        = ''; // 금융상품 계좌&수신처 정보 Import TR명
  gcMCA_TR_Z_RPT        = ''; // 금융상품 보고서 전문 정보 Import TR명

  // 헤더정보의 인터페이스 ID 정의
  gcMCA_INTERFACE_ID_T = 'T'; // 헤더정보의 인터페이스 ID (매매계:T)
  gcMCA_INTERFACE_ID_C = 'C'; // 헤더정보의 인터페이스 ID (계정계:C)

  // COPYDATA 처리 결과 리턴.
  gcMCA_SOCKET_DATA  = 1000;
  gcMCA_SOCKET_CLOSE = 1001;

  gcMCA_IN_ARRAY_SIZE_CLOSE      =  50;  // 주식 결제업무 마감 체크 Array 자료 갯수
                                        // (!! 부서 추가 되면 변경해야 함.)
  gcMCA_IN_ARRAY_SIZE_UPLOAD     = 40;  // 주식 정정내역 업로드 Array 자료 갯수
  gcMCA_IN_ARRAY_SIZE_UPLOAD_ACC = 50;  // 주식 계좌최종내역 업로드 Array 자료 갯수

  gcMCA_IN_STRING_SIZE_TRADE     = 400; // 주식 매매내역 계좌리스트 자료 최대 갯수

Type
  // MCA 서버 접속 function()
  CONNECTMCASERVER = function
    (pszIP: pchar; nPort: integer; szRegClientValue : PChar; hRetWindow: HWND):integer; cdecl;

  // MCA 서버 Data Request function()
  REQUESTDATA = function
    (szHeaderOpt, szBodyData: pChar; nHeaderOptLen, nBodyDataLen: integer):integer; cdecl;

  // MCA 서버 접속 종료 function()
  DISCONNECTMCASERVER = function
    ():integer; cdecl;

//------------------------------------------------------------------------------
//  헤더 정보
//------------------------------------------------------------------------------
  TMCAHeader = Packed Record
    TR_TYPE          : Array[0..1 -1]  of char;
    INTERFACE_ID     : Array[0..1 -1]  of char;
    ENCRYPT_FLAG     : Array[0..1 -1]  of char;
    TR_NAME          : Array[0..12-1]  of char;
    SCR_NO           : Array[0..5 -1]  of char;
    LANG_ID          : Array[0..1 -1]  of char;
    MODE_FLAG        : Array[0..1 -1]  of char;
    TR_CONT          : Array[0..1 -1]  of char;
    CO_CD            : Array[0..1 -1]  of char;
    MEDIA_CD1        : Array[0..2 -1]  of char;
    MEDIA_CD2        : Array[0..5 -1]  of char;
    ORG_CD           : Array[0..5 -1]  of char;
    SEQ_NO           : Array[0..3 -1]  of char;
    DEPT_CD          : Array[0..5 -1]  of char;
    EMP_ID           : Array[0..6 -1]  of char;
    EMP_SEQ          : Array[0..1 -1]  of char;
    USER_ID          : Array[0..8 -1]  of char;
    BR_OPEN_CD       : Array[0..5 -1]  of char;
    ACCT_NO          : Array[0..10-1]  of char;
    MEDIAFLAG        : Array[0..2 -1]  of char;
    MEDIAFLAG_DETAIL : Array[0..3 -1]  of char;
    RT_CD            : Array[0..1 -1]  of char;
  end;
  pMCAHeader = ^TMCAHeader;

//------------------------------------------------------------------------------
//  [TTC3808U] 주식 계좌 파일생성
//------------------------------------------------------------------------------
  TTTC3808UI1 = Packed Record // INPUT
     CANO           : Array[0..8  -1] of char; // 종합계좌번호
    _CANO           : char;
     ACNT_PRDT_CD   : Array[0..2  -1] of char; // 계좌상품코드
    _ACNT_PRDT_CD   : char;
     SETN_BRNO      : Array[0..3  -1] of char; // 세틀넷지점번호
    _SETN_BRNO      : char;
     WORK_DT        : Array[0..8  -1] of char; // 작업일자
    _WORK_DT        : char;
     ITFC_ID        : Array[0..12 -1] of char; // 인터페이스ID
    _ITFC_ID        : char;
     POUT_FILE_NAME : Array[0..200-1] of char; // 출력파일명
    _POUT_FILE_NAME : char;
  end;
  pTTC3808UI1 = ^TTTC3808UI1;

  TTTC3808UO2 = Packed Record // OUTPUT
     NRML_PRCS_YN : Array[0..1  -1] of char; // 정상처리여부
    _NRML_PRCS_YN : char;
     PRCS_MSG     : Array[0..100-1] of char; // 처리메세지
    _PRCS_MSG     : char;
  end;
  pTTC3808UO2 = ^TTTC3808UO2;

//------------------------------------------------------------------------------
//  [TTC3809U] 주식 매매 파일생성
//------------------------------------------------------------------------------
  TTTC3809UI1 = Packed Record // INPUT
     CANO           : Array[0..8  -1] of char; // 종합계좌번호
    //_CANO           : char;
     ACNT_PRDT_CD   : Array[0..2  -1] of char; // 계좌상품코드
    //_ACNT_PRDT_CD   : char;
  end;
  pTTC3809UI1 = ^TTTC3809UI1;

  TTTC3809UI = Packed Record // INPUT
    //SIZE      : Array[0..4 -1] of char;  // Array 사이즈

     ACC_NO         : Array[0..gcMCA_IN_STRING_SIZE_TRADE -1] of TTTC3809UI1;
    _ACC_NO         : char;

     SETN_BRNO      : Array[0..3  -1] of char; // 세틀넷지점번호
    _SETN_BRNO      : char;
     WORK_DT        : Array[0..8  -1] of char; // 작업일자
    _WORK_DT        : char;
     ITFC_ID        : Array[0..12 -1] of char; // 인터페이스ID
    _ITFC_ID        : char;
     POUT_FILE_NAME : Array[0..200-1] of char; // 출력파일명
    _POUT_FILE_NAME : char;
     DATA_CNT       : Array[0..3-1] of char; // 데이터 건수
    _DATA_CNT       : char;
  end;
  pTTC3809UI = ^TTTC3809UI;

  TTTC3809UO2 = Packed Record // OUTPUT
     NRML_PRCS_YN : Array[0..1  -1] of char; // 정상처리여부
    _NRML_PRCS_YN : char;
     PRCS_MSG     : Array[0..100-1] of char; // 처리메세지
    _PRCS_MSG     : char;
  end;
  pTTC3809UO2 = ^TTTC3809UO2;

//------------------------------------------------------------------------------
//  [TSC6307U] 주식 업로드 (계좌별 매매 내역)
//------------------------------------------------------------------------------
  TTSC6307UI1 = Packed Record
     CHNG_BF_CANO         : Array[0..8 -1] of char;
    _CHNG_BF_CANO         : char;
     CHNG_BF_ACNT_PRDT_CD : Array[0..2 -1] of char;
    _CHNG_BF_ACNT_PRDT_CD : char;
     CHNG_AF_CANO         : Array[0..8 -1] of char;
    _CHNG_AF_CANO         : char;
     CHNG_AF_ACNT_PRDT_CD : Array[0..2 -1] of char;
    _CHNG_AF_ACNT_PRDT_CD : char;
     PDNO                 : Array[0..12-1] of char;
    _PDNO                 : char;
     EXCG_DVSN_CD         : Array[0..2 -1] of char;
    _EXCG_DVSN_CD         : char;
     TRTX_TXTN_YN         : Array[0..1 -1] of char;
    _TRTX_TXTN_YN         : char;
     STTL_ORD_DVSN_CD     : Array[0..2 -1] of char;
    _STTL_ORD_DVSN_CD     : char;
     ORD_MDIA_DVSN_CD     : Array[0..2 -1] of char;
    _ORD_MDIA_DVSN_CD     : char;
     SLL_BUY_DVSN_CD      : Array[0..2 -1] of char;
    _SLL_BUY_DVSN_CD      : char;
     MTRL_DVSN_CD         : Array[0..1 -1] of char;
    _MTRL_DVSN_CD         : char;
     STTL_QTY             : Array[0..10 -1] of char;
    _STTL_QTY             : char;
     STTL_PRIC            : Array[0..10 -1] of char;
    _STTL_PRIC            : char;
     AVG_UNPR             : Array[0..20 -1] of char;
    _AVG_UNPR             : char;
     STTL_AMT             : Array[0..18 -1] of char;
    _STTL_AMT             : char;
     FEE                  : Array[0..18 -1] of char;
    _FEE                  : char;
     TAX_SMTL_AMT         : Array[0..18 -1] of char;
    _TAX_SMTL_AMT         : char;

  end;

  // Main
  TTSC6307UI = Packed Record
    SIZE      : Array[0..4 -1] of char;  // Array 사이즈

    OCCURS_IN1 : Array[0..gcMCA_IN_ARRAY_SIZE_UPLOAD_ACC -1] of TTSC6307UI1;
    // TSC6307UI2
     WORK_DVSN_CD : Array[0..2-1] of char;
    _WORK_DVSN_CD : char;
     ORGNO        : Array[0..5-1] of char;
    _ORGNO        : char;
     TRAD_DT      : Array[0..8-1] of char;
    _TRAD_DT      : char;
     DATA_CNT     : Array[0..8-1] of char;
    _DATA_CNT     : char;
  end;
  pTSC6307UI = ^TTSC6307UI;

  TTSC6307UO3 = Packed Record // OUTPUT
     NRML_PRCS_YN : Array[0..1  -1] of char; // 정상처리여부
    _NRML_PRCS_YN : char;
  end;
  pTSC6307UO3 = ^TTSC6307UO3;

//------------------------------------------------------------------------------
//  [TTC6317U] 주식 업로드 (정정/분할 내역)
//------------------------------------------------------------------------------
  TTTC6317UI1 = Packed Record
     CHNG_BF_CANO         : Array[0..8 -1] of char; // FROM종합계좌번호
    _CHNG_BF_CANO         : char;
     CHNG_BF_ACNT_PRDT_CD : Array[0..2 -1] of char; // FROM계좌상품코드
    _CHNG_BF_ACNT_PRDT_CD : char;
     ORGT_ODNO            : Array[0..3 -1] of char; // From주문지번호
    _ORGT_ODNO            : char;
     CHNG_AF_CANO         : Array[0..8 -1] of char; // TO종합계좌번호
    _CHNG_AF_CANO         : char;
     CHNG_AF_ACNT_PRDT_CD : Array[0..2 -1] of char; // TO계좌상품코드
    _CHNG_AF_ACNT_PRDT_CD : char;
     OPNT_ODNO1           : Array[0..3 -1] of char; // To주문지번호
    _OPNT_ODNO1           : char;
     PDNO                 : Array[0..12-1] of char; // 상품코드
    _PDNO                 : char;
     F_TRTX_TXTN_YN       : Array[0..1 -1] of char; // From과세여부
    _F_TRTX_TXTN_YN       : char;
     T_TRTX_TXTN_YN       : Array[0..1 -1] of char; // To과세여부
    _T_TRTX_TXTN_YN       : char;
     EXCG_DVSN_CD         : Array[0..1 -1] of char; // 장구분
    _EXCG_DVSN_CD         : char;
     TRAN_MTD             : Array[0..1 -1] of char; // 매매방법
    _TRAN_MTD             : char;
     COM_TYPE             : Array[0..1 -1] of char; // 매체종류
    _COM_TYPE             : char;
     SLL_BUY_DVSN_CD      : Array[0..1 -1] of char; // 매매구분
    _SLL_BUY_DVSN_CD      : char;
     GUBUN                : Array[0..1 -1] of char; // 작업구분
    _GUBUN                : char;
     MTRL_DVSN_CD         : Array[0..1 -1] of char; // 자료구분
    _MTRL_DVSN_CD         : char;
     TRAD_FEE_RT          : Array[0..23-1] of char; // 수수료율
    _TRAD_FEE_RT          : char;
     AVG_UNPR             : Array[0..18-1] of char; // 평균단가
    _AVG_UNPR             : char;
     STTL_QTY             : Array[0..10-1] of char; // 수량
    _STTL_QTY             : char;
     AGRM_AMT             : Array[0..18-1] of char; // 약정금액
    _AGRM_AMT             : char;
     FEE                  : Array[0..18-1] of char; // 수수료
    _FEE                  : char;
     TAXA                 : Array[0..18-1] of char; // 제세금
    _TAXA                 : char;
  end;

  // Main
  TTTC6317UI = Packed Record // INPUT
    SIZE      : Array[0..4 -1] of char;  // Array 사이즈

    OCCURS_IN1 : Array[0..gcMCA_IN_ARRAY_SIZE_UPLOAD -1] of TTTC6317UI1;
    // TTC6317UI2
     WORK_DVSN_CD  : Array[0..2 -1] of char;
    _WORK_DVSN_CD  : char;
     ADMN_ORGNO    : Array[0..3 -1] of char;
    _ADMN_ORGNO    : char;
     TRAD_DT       : Array[0..8 -1] of char;
    _TRAD_DT       : char;
     DATA_CNT      : Array[0..3 -1] of char;
    _DATA_CNT      : char;
  end;
  pTTC6317UI = ^TTTC6317UI;

  TTTC6317UO3 = Packed Record // OUTPUT
     NRML_PRCS_YN : Array[0..1  -1] of char; // 정상처리여부
    _NRML_PRCS_YN : char;
  end;
  pTTC6317UO3 = ^TTTC6317UO3;

//------------------------------------------------------------------------------
//  [TSC3220R] 주식 수수료계산
//------------------------------------------------------------------------------
  TTSC3220RI1 = Packed Record // INPUT
     EXCG_DVSN_CD     : Array[0..2 -1] of char;  // 거래소구분코드
    _EXCG_DVSN_CD     : char;
     PDNO             : Array[0..12-1] of char;  // 상품번호
    _PDNO             : char;
     PRDT_TYPE_CD     : Array[0..3 -1] of char;  // 상품유형코드
    _PRDT_TYPE_CD     : char;
     SLL_BUY_DVSN_CD  : Array[0..2 -1] of char;  // 매도매수구분코드
    _SLL_BUY_DVSN_CD  : char;
     TRTX_TXTN_YN     : Array[0..1 -1] of char;  // 거래세과세여부
    _TRTX_TXTN_YN     : char;
     ORD_MDIA_DVSN_CD : Array[0..2 -1] of char;  // 주문매체구분코드
    _ORD_MDIA_DVSN_CD : char;
     CANO             : Array[0..8 -1] of char;  // 종합계좌번호
    _CANO             : char;
     ACNT_PRDT_CD     : Array[0..2 -1] of char;  // 계좌상품코드
    _ACNT_PRDT_CD     : char;
     STTL_DT          : Array[0..8 -1] of char;  // 결제일자
    _STTL_DT          : char;
     AVG_UNPR         : Array[0..20 -1] of char;
    _AVG_UNPR         : char;
     TOT_CCLD_QTY     : Array[0..10 -1] of char;
    _TOT_CCLD_QTY     : char;
     TOT_CCLD_AMT     : Array[0..18 -1] of char;
    _TOT_CCLD_AMT     : char;

  end;
  pTSC3220RI1 = ^TTSC3220RI1;

  TTSC3220RO2 = Packed Record // OUTPUT
     FEE      : Array[0..18-1] of char; // 수수료
    _FEE      : char;
     TRTX     : Array[0..18-1] of char; // 거래세
    _TRTX     : char;
     FSTX     : Array[0..18-1] of char; // 농특세
    _FSTX     : char;
     TRFX     : Array[0..18-1] of char; // 양도세
    _TRFX     : char;
     EXCC_AMT : Array[0..18-1] of char; // 정산금액
    _EXCC_AMT : char;
     FEE_RT   : Array[0..23-1] of char; // 수수료율
    _FEE_RT   : char;
  end;
  pTSC3220RO2 = ^TTSC3220RO2;

//------------------------------------------------------------------------------
//  [TSC6315U] 결제업무 마감 관리
//------------------------------------------------------------------------------
  TTSC6315UO3 = Packed Record
     ORGNO     : Array[0..5 -1] of char; // 조직번호
    _ORGNO     : char;
     ORG_NAME  : Array[0..60-1] of char; // 조직명
    _ORG_NAME  : char;
     CLSG_YN   : Array[0..1 -1] of char; // 마감여부
    _CLSG_YN   : char;
     CLSG_TMD  : Array[0..6 -1] of char; // 마감시각
    _CLSG_TMD  : char;
     OPTR_NAME : Array[0..60-1] of char; // 조작자명
    _OPTR_NAME : char;
  end;

  // Main
  TTSC6315UI = Packed Record // INPUT
    // TSC6315UI2
     PRCS_DVSN_CD  : Array[0..2 -1] of char;  // 처리구분코드
    _PRCS_DVSN_CD  : char;
     TRAD_DT       : Array[0..8 -1] of char;  // 매매일자
    _TRAD_DT       : char;
     TRAD_STTL_PRCS_AFRS_DVSN_CD : Array[0..2 -1] of char;  // 매매결제처리업무구분코드
    _TRAD_STTL_PRCS_AFRS_DVSN_CD : char;
     ORGNO         : Array[0..5 -1] of char;  // 조직번호
    _ORGNO         : char;
     CLSG_YN       : Array[0..1 -1] of char;  // 마감여부
    _CLSG_YN       : char;    
  end;
  pTSC6315UI = ^TTSC6315UI;

  TTSC6315UO = Packed Record // OUTPUT
    SIZE       : Array[0..4 -1] of char;  // Array 사이즈

    OCCURS_OUT1 : Array[0..gcMCA_IN_ARRAY_SIZE_CLOSE -1] of TTSC6315UO3;

    // TSC6315UO4
     NRML_PRCS_YN : Array[0..1  -1] of char; // 정상처리여부
    _NRML_PRCS_YN : char;

  end;
  pTSC6315UO = ^TTSC6315UO;

//------------------------------------------------------------------------------
//  [TFO6137R] 선물 계좌 파일생성
//------------------------------------------------------------------------------
  TTFO6137RI1 = Packed Record // INPUT
     ACNT_ADMN_ORGNO : Array[0..5  -1] of char; // 계좌관리조직번호
    _ACNT_ADMN_ORGNO : char;
     INQR_DT         : Array[0..8  -1] of char; // 조회일자
    _INQR_DT         : char;
     CANO            : Array[0..8  -1] of char; // 종합계좌번호
    _CANO            : char;
     ACNT_PRDT_CD    : Array[0..2  -1] of char; // 계좌상품코드
    _ACNT_PRDT_CD    : char;
     POUT_FILE_NAME  : Array[0..200-1] of char; // 출력파일명
    _POUT_FILE_NAME  : char;
     ITFC_ID         : Array[0..12 -1] of char; // 인터페이스ID
    _ITFC_ID         : char;
  end;
  pTFO6137RI1 = ^TTFO6137RI1;

  TTFO6137RO2 = Packed Record // OUTPUT
     NRML_PRCS_YN : Array[0..1  -1] of char; // 정상처리여부
    _NRML_PRCS_YN : char;
  end;
  pTFO6137RO2 = ^TTFO6137RO2;

//------------------------------------------------------------------------------
//  [TFO6142R] 선물 수수료코드 파일생성
//------------------------------------------------------------------------------
  TTFO6142RI1 = Packed Record // INPUT
     ACNT_ADMN_ORGNO : Array[0..5  -1] of char; // 계좌관리조직번호
    _ACNT_ADMN_ORGNO : char;
     INQR_DT         : Array[0..8  -1] of char; // 조회일자
    _INQR_DT         : char;
     CANO            : Array[0..8  -1] of char; // 종합계좌번호
    _CANO            : char;
     ACNT_PRDT_CD    : Array[0..2  -1] of char; // 계좌상품코드
    _ACNT_PRDT_CD    : char;
     POUT_FILE_NAME  : Array[0..200-1] of char; // 출력파일명
    _POUT_FILE_NAME  : char;
     ITFC_ID         : Array[0..12 -1] of char; // 인터페이스ID
    _ITFC_ID         : char;
  end;
  pTFO6142RI1 = ^TTFO6142RI1;

  TTFO6142RO2 = Packed Record // OUTPUT
     NRML_PRCS_YN : Array[0..1  -1] of char; // 정상처리여부
    _NRML_PRCS_YN : char;
  end;
  pTFO6142RO2 = ^TTFO6142RO2;

//------------------------------------------------------------------------------
//  [TFO6138R] 선물 예탁 파일생성
//------------------------------------------------------------------------------
  TTFO6138RI1 = Packed Record // INPUT
     ACNT_ADMN_ORGNO : Array[0..5  -1] of char; // 계좌관리조직번호
    _ACNT_ADMN_ORGNO : char;
     INQR_DT         : Array[0..8  -1] of char; // 조회일자
    _INQR_DT         : char;
     CANO            : Array[0..8  -1] of char; // 종합계좌번호
    _CANO            : char;
     ACNT_PRDT_CD    : Array[0..2  -1] of char; // 계좌상품코드
    _ACNT_PRDT_CD    : char;
     POUT_FILE_NAME  : Array[0..200-1] of char; // 출력파일명
    _POUT_FILE_NAME  : char;
     ITFC_ID         : Array[0..12 -1] of char; // 인터페이스ID
    _ITFC_ID         : char;
  end;
  pTFO6138RI1 = ^TTFO6138RI1;

  TTFO6138RO2 = Packed Record // OUTPUT
     NRML_PRCS_YN : Array[0..1  -1] of char; // 정상처리여부
    _NRML_PRCS_YN : char;
  end;
  pTFO6138RO2 = ^TTFO6138RO2;

//------------------------------------------------------------------------------
//  [TTO9008R] 선물 매매 파일생성
//------------------------------------------------------------------------------
  TTTO9008RI1 = Packed Record // INPUT
     ACNT_ADMN_ORGNO : Array[0..5  -1] of char; // 계좌관리조직번호
    _ACNT_ADMN_ORGNO : char;
     INQR_DT         : Array[0..8  -1] of char; // 조회일자
    _INQR_DT         : char;
     CANO            : Array[0..8  -1] of char; // 종합계좌번호
    _CANO            : char;
     ACNT_PRDT_CD    : Array[0..2  -1] of char; // 계좌상품코드
    _ACNT_PRDT_CD    : char;
     POUT_FILE_NAME  : Array[0..200-1] of char; // 출력파일명
    _POUT_FILE_NAME  : char;
     ITFC_ID         : Array[0..12 -1] of char; // 인터페이스ID
    _ITFC_ID         : char;
  end;
  pTTO9008RI1 = ^TTTO9008RI1;

  TTTO9008RO2 = Packed Record // OUTPUT
     NRML_PRCS_YN : Array[0..1  -1] of char; // 정상처리여부
    _NRML_PRCS_YN : char;
  end;
  pTTO9008RO2 = ^TTTO9008RO2;

//------------------------------------------------------------------------------
//  [TFO6140R] 선물 미결제 파일생성
//------------------------------------------------------------------------------
  TTFO6140RI1 = Packed Record // INPUT
     ACNT_ADMN_ORGNO : Array[0..5  -1] of char; // 계좌관리조직번호
    _ACNT_ADMN_ORGNO : char;
     INQR_DT         : Array[0..8  -1] of char; // 조회일자
    _INQR_DT         : char;
     CANO            : Array[0..8  -1] of char; // 종합계좌번호
    _CANO            : char;
     ACNT_PRDT_CD    : Array[0..2  -1] of char; // 계좌상품코드
    _ACNT_PRDT_CD    : char;
     POUT_FILE_NAME  : Array[0..200-1] of char; // 출력파일명
    _POUT_FILE_NAME  : char;
     ITFC_ID         : Array[0..12 -1] of char; // 인터페이스ID
    _ITFC_ID         : char;
  end;
  pTFO6140RI1 = ^TTFO6140RI1;

  TTFO6140RO2 = Packed Record // OUTPUT
     NRML_PRCS_YN : Array[0..1  -1] of char; // 정상처리여부
    _NRML_PRCS_YN : char;
  end;
  pTFO6140RO2 = ^TTFO6140RO2;

//------------------------------------------------------------------------------
//  [TFO6141R] 선물 매매 파일생성
//------------------------------------------------------------------------------
  TTFO6141RI1 = Packed Record // INPUT
     ACNT_ADMN_ORGNO : Array[0..5  -1] of char; // 계좌관리조직번호
    _ACNT_ADMN_ORGNO : char;
     INQR_DT         : Array[0..8  -1] of char; // 조회일자
    _INQR_DT         : char;
     CANO            : Array[0..8  -1] of char; // 종합계좌번호
    _CANO            : char;
     ACNT_PRDT_CD    : Array[0..2  -1] of char; // 계좌상품코드
    _ACNT_PRDT_CD    : char;
     POUT_FILE_NAME  : Array[0..200-1] of char; // 출력파일명
    _POUT_FILE_NAME  : char;
     ITFC_ID         : Array[0..12 -1] of char; // 인터페이스ID
    _ITFC_ID         : char;
  end;
  pTFO6141RI1 = ^TTFO6141RI1;

  TTFO6141RO2 = Packed Record // OUTPUT
     NRML_PRCS_YN : Array[0..1  -1] of char; // 정상처리여부
    _NRML_PRCS_YN : char;
  end;
  pTFO6141RO2 = ^TTFO6141RO2;


//------------------------------------------------------------------------------
//  [T_FI_ACC] 금융상품 계좌 & 수신처 파일 생성
//------------------------------------------------------------------------------
  TT_FI_ACCI1 = Packed Record // INPUT
     CANO           : Array[0..8  -1] of char; // 종합계좌번호
    _CANO           : char;
     ACNT_PRDT_CD   : Array[0..2  -1] of char; // 계좌상품코드
    _ACNT_PRDT_CD   : char;
     CRE_DT         : Array[0..8  -1] of char; // 개설일자
    _CRE_DT         : char;
     CHG_DT         : Array[0..8  -1] of char; // 계좌 수신처 정보 변경일
    _CHG_DT         : char;
     ITFC_ID        : Array[0..12 -1] of char; // 인터페이스ID
    _ITFC_ID        : char;
     POUT_FILE_NAME : Array[0..200-1] of char; // 출력파일명
    _POUT_FILE_NAME : char;
  end;
  pT_FI_ACCI1 = ^TT_FI_ACCI1;

  TT_FI_ACCO2 = Packed Record // OUTPUT
     NRML_PRCS_YN : Array[0..1  -1] of char; // 정상처리여부
    _NRML_PRCS_YN : char;
     PRCS_MSG     : Array[0..100-1] of char; // 처리메세지
    _PRCS_MSG     : char;
  end;
  pT_FI_ACCO2 = ^TT_FI_ACCO2;

//------------------------------------------------------------------------------
//  [T_FI_RPT] 금융상품 보고서 파일 생성
//------------------------------------------------------------------------------
  TT_FI_RPTI1 = Packed Record // INPUT
     CANO           : Array[0..8  -1] of char; // 종합계좌번호
    _CANO           : char;
     ITFC_ID        : Array[0..12 -1] of char; // 인터페이스ID
    _ITFC_ID        : char;
     POUT_FILE_NAME : Array[0..200-1] of char; // 출력파일명
    _POUT_FILE_NAME : char;
  end;
  pT_FI_RPTI1 = ^TT_FI_RPTI1;

  TT_FI_RPTO2 = Packed Record // OUTPUT
     NRML_PRCS_YN : Array[0..1  -1] of char; // 정상처리여부
    _NRML_PRCS_YN : char;
     PRCS_MSG     : Array[0..100-1] of char; // 처리메세지
    _PRCS_MSG     : char;
  end;
  pT_FI_RPTO2 = ^TT_FI_RPTO2;


//------------------------------------------------------------------------------
// 금융상품 Import 전문 공통 영역 (Header)
//------------------------------------------------------------------------------
  TSamHeadRec_FI = Packed record
    Version   : String;
    SecType   : String;
    ReportID  : String;
    CreDate   : String;
    CreTime   : String;
    SeqNo     : String;
    EmpId     : String;
    BrnCode   : String;
    AccNo     : String;
    PrdNo     : String;
    BlcNo     : String;
  end;

  
var
  m_hHKCommDLL : THandle; // MCA CALL DLL HANDLE 할당
	m_pConnectMCAServer    : CONNECTMCASERVER;     // 한투 차세대 서버 접속
	m_pRequestData         : REQUESTDATA;          // 한투 차세대 서버 데이터 전송
	m_pDisConnectMCAServer : DISCONNECTMCASERVER ; // 한투 차세대 서버 접속 종료

  gvMCACriticalSection: TRTLCriticalSection;

  gvMCAReceive: boolean; // 원장 메세지 리턴 체크

  gvMCAConnectIP   : string;    // MCA 서버 IP
  gvMCAConnectPort : integer; // MCA 서버 접속 PORT

  gvMCAFileFtpIP : string; // MCA 생성 파일 FTP IP
  gvMCAFileFtpID : string; // MCA 생성 파일 FTP ID
  gvMCAFileFtpPW : string; // MCA 생성 파일 FTP PW
  gvMCAFileFtpMode : string;  // MCA 생성 파일 FTP Mode
  gvMCAFileFtpPort : Integer; // MCA 생성 파일 FTP Port
  gvMCAFileFtpPath : string;  // MCA 생성 파일 FTP Path

  gvMCAInterfaceID : string; // MCA Interface ID

  gvMCAFtpFileList: TStringList; // 생성 파일 리스트
  
  gvMCAConnectYn: Boolean;       // MCA 서버 접속 유무 체크
  gvMCAResult: String;           // MCA 서버 인풋데이터 정상 처리 여부
  gvMCACloseResult: string;       // TSC6315U(결제업무마감관리) 부서 마감 여부

  gvMCAFileCnt: Integer; // 임포트 파일 생성 갯수 체크

  gvMCAInputData_CalcComm  : TTSC3220RI1; // 수수료계산 Input데이터 저장
  gvMCAOutputData_CalcComm : TTSC3220RO2; // 수수료계산 Output데이터 저장

  gvMCALogFile : TextFile;  // MCA Log File
  gvMCALogFlag : boolean;   // MCA Log On/Off
  gvMCALogPath : string;    // MCA Log File Directory
  gvMCALogCriticalSection   // MCA Log File을 위한 CriticalSection
    : TRtlCriticalSection;

  gvAcEtcList: TStringList; // 타부서 계좌 리스트

implementation

end.
