//==============================================================================
//   SettleNet Global Type (Only �ѱ�����)
//   [Y.K.J] 2011.08.08
//           �߰�: �ѱ��������� ������ �ý���(MCA)���� ���� �߰�
//==============================================================================

unit SCCTFGlobalType;

interface

uses
  Windows, Classes;

const
  // MCA TR�� ����
  gcMCA_TR_E_ACC        = 'TTC3808U'; // �ֽ� �������� Import TR��
  gcMCA_TR_E_TRADE      = 'TTC3809U'; // �ֽ� �Ÿ����� Import TR��
  gcMCA_TR_E_CLOSE      = 'TSC6315U'; // �ֽ� ���� ���� ���� üũ TR��
  gcMCA_TR_E_CALC_COMM  = 'TSC3220R'; // �ֽ� ������ ��� TR��
  gcMCA_TR_E_UPLOAD_ACC = 'TSC6307U'; // �ֽ� �������� ���ε� TR��
  gcMCA_TR_E_UPLOAD     = 'TTC6317U'; // �ֽ� �������� ���ε� TR��

  gcMCA_TR_F_ACC        = 'TFO6137R'; // ���� �������� Import TR��
  gcMCA_TR_F_DEPOSIT    = 'TFO6138R'; // ���� ��Ź���� Import TR��
  gcMCA_TR_F_TRADE      = 'TTO9008R'; // ���� �Ÿ����� Import TR��
  gcMCA_TR_F_OPEN       = 'TFO6140R'; // ���� �̰������� Import TR��
  gcMCA_TR_F_COLT       = 'TFO6141R'; // ���� ������� Import TR��
  gcMCA_TR_F_COMM_INFO  = 'TFO6142R'; // ���� ���º� ���������� Import TR��

  gcMCA_TR_Z_ACC        = ''; // ������ǰ ����&����ó ���� Import TR��
  gcMCA_TR_Z_RPT        = ''; // ������ǰ ���� ���� ���� Import TR��

  // ��������� �������̽� ID ����
  gcMCA_INTERFACE_ID_T = 'T'; // ��������� �������̽� ID (�ŸŰ�:T)
  gcMCA_INTERFACE_ID_C = 'C'; // ��������� �������̽� ID (������:C)

  // COPYDATA ó�� ��� ����.
  gcMCA_SOCKET_DATA  = 1000;
  gcMCA_SOCKET_CLOSE = 1001;

  gcMCA_IN_ARRAY_SIZE_CLOSE      =  50;  // �ֽ� �������� ���� üũ Array �ڷ� ����
                                        // (!! �μ� �߰� �Ǹ� �����ؾ� ��.)
  gcMCA_IN_ARRAY_SIZE_UPLOAD     = 40;  // �ֽ� �������� ���ε� Array �ڷ� ����
  gcMCA_IN_ARRAY_SIZE_UPLOAD_ACC = 50;  // �ֽ� ������������ ���ε� Array �ڷ� ����

  gcMCA_IN_STRING_SIZE_TRADE     = 400; // �ֽ� �Ÿų��� ���¸���Ʈ �ڷ� �ִ� ����

Type
  // MCA ���� ���� function()
  CONNECTMCASERVER = function
    (pszIP: pchar; nPort: integer; szRegClientValue : PChar; hRetWindow: HWND):integer; cdecl;

  // MCA ���� Data Request function()
  REQUESTDATA = function
    (szHeaderOpt, szBodyData: pChar; nHeaderOptLen, nBodyDataLen: integer):integer; cdecl;

  // MCA ���� ���� ���� function()
  DISCONNECTMCASERVER = function
    ():integer; cdecl;

//------------------------------------------------------------------------------
//  ��� ����
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
//  [TTC3808U] �ֽ� ���� ���ϻ���
//------------------------------------------------------------------------------
  TTTC3808UI1 = Packed Record // INPUT
     CANO           : Array[0..8  -1] of char; // ���հ��¹�ȣ
    _CANO           : char;
     ACNT_PRDT_CD   : Array[0..2  -1] of char; // ���»�ǰ�ڵ�
    _ACNT_PRDT_CD   : char;
     SETN_BRNO      : Array[0..3  -1] of char; // ��Ʋ��������ȣ
    _SETN_BRNO      : char;
     WORK_DT        : Array[0..8  -1] of char; // �۾�����
    _WORK_DT        : char;
     ITFC_ID        : Array[0..12 -1] of char; // �������̽�ID
    _ITFC_ID        : char;
     POUT_FILE_NAME : Array[0..200-1] of char; // ������ϸ�
    _POUT_FILE_NAME : char;
  end;
  pTTC3808UI1 = ^TTTC3808UI1;

  TTTC3808UO2 = Packed Record // OUTPUT
     NRML_PRCS_YN : Array[0..1  -1] of char; // ����ó������
    _NRML_PRCS_YN : char;
     PRCS_MSG     : Array[0..100-1] of char; // ó���޼���
    _PRCS_MSG     : char;
  end;
  pTTC3808UO2 = ^TTTC3808UO2;

//------------------------------------------------------------------------------
//  [TTC3809U] �ֽ� �Ÿ� ���ϻ���
//------------------------------------------------------------------------------
  TTTC3809UI1 = Packed Record // INPUT
     CANO           : Array[0..8  -1] of char; // ���հ��¹�ȣ
    //_CANO           : char;
     ACNT_PRDT_CD   : Array[0..2  -1] of char; // ���»�ǰ�ڵ�
    //_ACNT_PRDT_CD   : char;
  end;
  pTTC3809UI1 = ^TTTC3809UI1;

  TTTC3809UI = Packed Record // INPUT
    //SIZE      : Array[0..4 -1] of char;  // Array ������

     ACC_NO         : Array[0..gcMCA_IN_STRING_SIZE_TRADE -1] of TTTC3809UI1;
    _ACC_NO         : char;

     SETN_BRNO      : Array[0..3  -1] of char; // ��Ʋ��������ȣ
    _SETN_BRNO      : char;
     WORK_DT        : Array[0..8  -1] of char; // �۾�����
    _WORK_DT        : char;
     ITFC_ID        : Array[0..12 -1] of char; // �������̽�ID
    _ITFC_ID        : char;
     POUT_FILE_NAME : Array[0..200-1] of char; // ������ϸ�
    _POUT_FILE_NAME : char;
     DATA_CNT       : Array[0..3-1] of char; // ������ �Ǽ�
    _DATA_CNT       : char;
  end;
  pTTC3809UI = ^TTTC3809UI;

  TTTC3809UO2 = Packed Record // OUTPUT
     NRML_PRCS_YN : Array[0..1  -1] of char; // ����ó������
    _NRML_PRCS_YN : char;
     PRCS_MSG     : Array[0..100-1] of char; // ó���޼���
    _PRCS_MSG     : char;
  end;
  pTTC3809UO2 = ^TTTC3809UO2;

//------------------------------------------------------------------------------
//  [TSC6307U] �ֽ� ���ε� (���º� �Ÿ� ����)
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
    SIZE      : Array[0..4 -1] of char;  // Array ������

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
     NRML_PRCS_YN : Array[0..1  -1] of char; // ����ó������
    _NRML_PRCS_YN : char;
  end;
  pTSC6307UO3 = ^TTSC6307UO3;

//------------------------------------------------------------------------------
//  [TTC6317U] �ֽ� ���ε� (����/���� ����)
//------------------------------------------------------------------------------
  TTTC6317UI1 = Packed Record
     CHNG_BF_CANO         : Array[0..8 -1] of char; // FROM���հ��¹�ȣ
    _CHNG_BF_CANO         : char;
     CHNG_BF_ACNT_PRDT_CD : Array[0..2 -1] of char; // FROM���»�ǰ�ڵ�
    _CHNG_BF_ACNT_PRDT_CD : char;
     ORGT_ODNO            : Array[0..3 -1] of char; // From�ֹ�����ȣ
    _ORGT_ODNO            : char;
     CHNG_AF_CANO         : Array[0..8 -1] of char; // TO���հ��¹�ȣ
    _CHNG_AF_CANO         : char;
     CHNG_AF_ACNT_PRDT_CD : Array[0..2 -1] of char; // TO���»�ǰ�ڵ�
    _CHNG_AF_ACNT_PRDT_CD : char;
     OPNT_ODNO1           : Array[0..3 -1] of char; // To�ֹ�����ȣ
    _OPNT_ODNO1           : char;
     PDNO                 : Array[0..12-1] of char; // ��ǰ�ڵ�
    _PDNO                 : char;
     F_TRTX_TXTN_YN       : Array[0..1 -1] of char; // From��������
    _F_TRTX_TXTN_YN       : char;
     T_TRTX_TXTN_YN       : Array[0..1 -1] of char; // To��������
    _T_TRTX_TXTN_YN       : char;
     EXCG_DVSN_CD         : Array[0..1 -1] of char; // �屸��
    _EXCG_DVSN_CD         : char;
     TRAN_MTD             : Array[0..1 -1] of char; // �ŸŹ��
    _TRAN_MTD             : char;
     COM_TYPE             : Array[0..1 -1] of char; // ��ü����
    _COM_TYPE             : char;
     SLL_BUY_DVSN_CD      : Array[0..1 -1] of char; // �Ÿű���
    _SLL_BUY_DVSN_CD      : char;
     GUBUN                : Array[0..1 -1] of char; // �۾�����
    _GUBUN                : char;
     MTRL_DVSN_CD         : Array[0..1 -1] of char; // �ڷᱸ��
    _MTRL_DVSN_CD         : char;
     TRAD_FEE_RT          : Array[0..23-1] of char; // ��������
    _TRAD_FEE_RT          : char;
     AVG_UNPR             : Array[0..18-1] of char; // ��մܰ�
    _AVG_UNPR             : char;
     STTL_QTY             : Array[0..10-1] of char; // ����
    _STTL_QTY             : char;
     AGRM_AMT             : Array[0..18-1] of char; // �����ݾ�
    _AGRM_AMT             : char;
     FEE                  : Array[0..18-1] of char; // ������
    _FEE                  : char;
     TAXA                 : Array[0..18-1] of char; // ������
    _TAXA                 : char;
  end;

  // Main
  TTTC6317UI = Packed Record // INPUT
    SIZE      : Array[0..4 -1] of char;  // Array ������

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
     NRML_PRCS_YN : Array[0..1  -1] of char; // ����ó������
    _NRML_PRCS_YN : char;
  end;
  pTTC6317UO3 = ^TTTC6317UO3;

//------------------------------------------------------------------------------
//  [TSC3220R] �ֽ� ��������
//------------------------------------------------------------------------------
  TTSC3220RI1 = Packed Record // INPUT
     EXCG_DVSN_CD     : Array[0..2 -1] of char;  // �ŷ��ұ����ڵ�
    _EXCG_DVSN_CD     : char;
     PDNO             : Array[0..12-1] of char;  // ��ǰ��ȣ
    _PDNO             : char;
     PRDT_TYPE_CD     : Array[0..3 -1] of char;  // ��ǰ�����ڵ�
    _PRDT_TYPE_CD     : char;
     SLL_BUY_DVSN_CD  : Array[0..2 -1] of char;  // �ŵ��ż������ڵ�
    _SLL_BUY_DVSN_CD  : char;
     TRTX_TXTN_YN     : Array[0..1 -1] of char;  // �ŷ�����������
    _TRTX_TXTN_YN     : char;
     ORD_MDIA_DVSN_CD : Array[0..2 -1] of char;  // �ֹ���ü�����ڵ�
    _ORD_MDIA_DVSN_CD : char;
     CANO             : Array[0..8 -1] of char;  // ���հ��¹�ȣ
    _CANO             : char;
     ACNT_PRDT_CD     : Array[0..2 -1] of char;  // ���»�ǰ�ڵ�
    _ACNT_PRDT_CD     : char;
     STTL_DT          : Array[0..8 -1] of char;  // ��������
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
     FEE      : Array[0..18-1] of char; // ������
    _FEE      : char;
     TRTX     : Array[0..18-1] of char; // �ŷ���
    _TRTX     : char;
     FSTX     : Array[0..18-1] of char; // ��Ư��
    _FSTX     : char;
     TRFX     : Array[0..18-1] of char; // �絵��
    _TRFX     : char;
     EXCC_AMT : Array[0..18-1] of char; // ����ݾ�
    _EXCC_AMT : char;
     FEE_RT   : Array[0..23-1] of char; // ��������
    _FEE_RT   : char;
  end;
  pTSC3220RO2 = ^TTSC3220RO2;

//------------------------------------------------------------------------------
//  [TSC6315U] �������� ���� ����
//------------------------------------------------------------------------------
  TTSC6315UO3 = Packed Record
     ORGNO     : Array[0..5 -1] of char; // ������ȣ
    _ORGNO     : char;
     ORG_NAME  : Array[0..60-1] of char; // ������
    _ORG_NAME  : char;
     CLSG_YN   : Array[0..1 -1] of char; // ��������
    _CLSG_YN   : char;
     CLSG_TMD  : Array[0..6 -1] of char; // �����ð�
    _CLSG_TMD  : char;
     OPTR_NAME : Array[0..60-1] of char; // �����ڸ�
    _OPTR_NAME : char;
  end;

  // Main
  TTSC6315UI = Packed Record // INPUT
    // TSC6315UI2
     PRCS_DVSN_CD  : Array[0..2 -1] of char;  // ó�������ڵ�
    _PRCS_DVSN_CD  : char;
     TRAD_DT       : Array[0..8 -1] of char;  // �Ÿ�����
    _TRAD_DT       : char;
     TRAD_STTL_PRCS_AFRS_DVSN_CD : Array[0..2 -1] of char;  // �ŸŰ���ó�����������ڵ�
    _TRAD_STTL_PRCS_AFRS_DVSN_CD : char;
     ORGNO         : Array[0..5 -1] of char;  // ������ȣ
    _ORGNO         : char;
     CLSG_YN       : Array[0..1 -1] of char;  // ��������
    _CLSG_YN       : char;    
  end;
  pTSC6315UI = ^TTSC6315UI;

  TTSC6315UO = Packed Record // OUTPUT
    SIZE       : Array[0..4 -1] of char;  // Array ������

    OCCURS_OUT1 : Array[0..gcMCA_IN_ARRAY_SIZE_CLOSE -1] of TTSC6315UO3;

    // TSC6315UO4
     NRML_PRCS_YN : Array[0..1  -1] of char; // ����ó������
    _NRML_PRCS_YN : char;

  end;
  pTSC6315UO = ^TTSC6315UO;

//------------------------------------------------------------------------------
//  [TFO6137R] ���� ���� ���ϻ���
//------------------------------------------------------------------------------
  TTFO6137RI1 = Packed Record // INPUT
     ACNT_ADMN_ORGNO : Array[0..5  -1] of char; // ���°���������ȣ
    _ACNT_ADMN_ORGNO : char;
     INQR_DT         : Array[0..8  -1] of char; // ��ȸ����
    _INQR_DT         : char;
     CANO            : Array[0..8  -1] of char; // ���հ��¹�ȣ
    _CANO            : char;
     ACNT_PRDT_CD    : Array[0..2  -1] of char; // ���»�ǰ�ڵ�
    _ACNT_PRDT_CD    : char;
     POUT_FILE_NAME  : Array[0..200-1] of char; // ������ϸ�
    _POUT_FILE_NAME  : char;
     ITFC_ID         : Array[0..12 -1] of char; // �������̽�ID
    _ITFC_ID         : char;
  end;
  pTFO6137RI1 = ^TTFO6137RI1;

  TTFO6137RO2 = Packed Record // OUTPUT
     NRML_PRCS_YN : Array[0..1  -1] of char; // ����ó������
    _NRML_PRCS_YN : char;
  end;
  pTFO6137RO2 = ^TTFO6137RO2;

//------------------------------------------------------------------------------
//  [TFO6142R] ���� �������ڵ� ���ϻ���
//------------------------------------------------------------------------------
  TTFO6142RI1 = Packed Record // INPUT
     ACNT_ADMN_ORGNO : Array[0..5  -1] of char; // ���°���������ȣ
    _ACNT_ADMN_ORGNO : char;
     INQR_DT         : Array[0..8  -1] of char; // ��ȸ����
    _INQR_DT         : char;
     CANO            : Array[0..8  -1] of char; // ���հ��¹�ȣ
    _CANO            : char;
     ACNT_PRDT_CD    : Array[0..2  -1] of char; // ���»�ǰ�ڵ�
    _ACNT_PRDT_CD    : char;
     POUT_FILE_NAME  : Array[0..200-1] of char; // ������ϸ�
    _POUT_FILE_NAME  : char;
     ITFC_ID         : Array[0..12 -1] of char; // �������̽�ID
    _ITFC_ID         : char;
  end;
  pTFO6142RI1 = ^TTFO6142RI1;

  TTFO6142RO2 = Packed Record // OUTPUT
     NRML_PRCS_YN : Array[0..1  -1] of char; // ����ó������
    _NRML_PRCS_YN : char;
  end;
  pTFO6142RO2 = ^TTFO6142RO2;

//------------------------------------------------------------------------------
//  [TFO6138R] ���� ��Ź ���ϻ���
//------------------------------------------------------------------------------
  TTFO6138RI1 = Packed Record // INPUT
     ACNT_ADMN_ORGNO : Array[0..5  -1] of char; // ���°���������ȣ
    _ACNT_ADMN_ORGNO : char;
     INQR_DT         : Array[0..8  -1] of char; // ��ȸ����
    _INQR_DT         : char;
     CANO            : Array[0..8  -1] of char; // ���հ��¹�ȣ
    _CANO            : char;
     ACNT_PRDT_CD    : Array[0..2  -1] of char; // ���»�ǰ�ڵ�
    _ACNT_PRDT_CD    : char;
     POUT_FILE_NAME  : Array[0..200-1] of char; // ������ϸ�
    _POUT_FILE_NAME  : char;
     ITFC_ID         : Array[0..12 -1] of char; // �������̽�ID
    _ITFC_ID         : char;
  end;
  pTFO6138RI1 = ^TTFO6138RI1;

  TTFO6138RO2 = Packed Record // OUTPUT
     NRML_PRCS_YN : Array[0..1  -1] of char; // ����ó������
    _NRML_PRCS_YN : char;
  end;
  pTFO6138RO2 = ^TTFO6138RO2;

//------------------------------------------------------------------------------
//  [TTO9008R] ���� �Ÿ� ���ϻ���
//------------------------------------------------------------------------------
  TTTO9008RI1 = Packed Record // INPUT
     ACNT_ADMN_ORGNO : Array[0..5  -1] of char; // ���°���������ȣ
    _ACNT_ADMN_ORGNO : char;
     INQR_DT         : Array[0..8  -1] of char; // ��ȸ����
    _INQR_DT         : char;
     CANO            : Array[0..8  -1] of char; // ���հ��¹�ȣ
    _CANO            : char;
     ACNT_PRDT_CD    : Array[0..2  -1] of char; // ���»�ǰ�ڵ�
    _ACNT_PRDT_CD    : char;
     POUT_FILE_NAME  : Array[0..200-1] of char; // ������ϸ�
    _POUT_FILE_NAME  : char;
     ITFC_ID         : Array[0..12 -1] of char; // �������̽�ID
    _ITFC_ID         : char;
  end;
  pTTO9008RI1 = ^TTTO9008RI1;

  TTTO9008RO2 = Packed Record // OUTPUT
     NRML_PRCS_YN : Array[0..1  -1] of char; // ����ó������
    _NRML_PRCS_YN : char;
  end;
  pTTO9008RO2 = ^TTTO9008RO2;

//------------------------------------------------------------------------------
//  [TFO6140R] ���� �̰��� ���ϻ���
//------------------------------------------------------------------------------
  TTFO6140RI1 = Packed Record // INPUT
     ACNT_ADMN_ORGNO : Array[0..5  -1] of char; // ���°���������ȣ
    _ACNT_ADMN_ORGNO : char;
     INQR_DT         : Array[0..8  -1] of char; // ��ȸ����
    _INQR_DT         : char;
     CANO            : Array[0..8  -1] of char; // ���հ��¹�ȣ
    _CANO            : char;
     ACNT_PRDT_CD    : Array[0..2  -1] of char; // ���»�ǰ�ڵ�
    _ACNT_PRDT_CD    : char;
     POUT_FILE_NAME  : Array[0..200-1] of char; // ������ϸ�
    _POUT_FILE_NAME  : char;
     ITFC_ID         : Array[0..12 -1] of char; // �������̽�ID
    _ITFC_ID         : char;
  end;
  pTFO6140RI1 = ^TTFO6140RI1;

  TTFO6140RO2 = Packed Record // OUTPUT
     NRML_PRCS_YN : Array[0..1  -1] of char; // ����ó������
    _NRML_PRCS_YN : char;
  end;
  pTFO6140RO2 = ^TTFO6140RO2;

//------------------------------------------------------------------------------
//  [TFO6141R] ���� �Ÿ� ���ϻ���
//------------------------------------------------------------------------------
  TTFO6141RI1 = Packed Record // INPUT
     ACNT_ADMN_ORGNO : Array[0..5  -1] of char; // ���°���������ȣ
    _ACNT_ADMN_ORGNO : char;
     INQR_DT         : Array[0..8  -1] of char; // ��ȸ����
    _INQR_DT         : char;
     CANO            : Array[0..8  -1] of char; // ���հ��¹�ȣ
    _CANO            : char;
     ACNT_PRDT_CD    : Array[0..2  -1] of char; // ���»�ǰ�ڵ�
    _ACNT_PRDT_CD    : char;
     POUT_FILE_NAME  : Array[0..200-1] of char; // ������ϸ�
    _POUT_FILE_NAME  : char;
     ITFC_ID         : Array[0..12 -1] of char; // �������̽�ID
    _ITFC_ID         : char;
  end;
  pTFO6141RI1 = ^TTFO6141RI1;

  TTFO6141RO2 = Packed Record // OUTPUT
     NRML_PRCS_YN : Array[0..1  -1] of char; // ����ó������
    _NRML_PRCS_YN : char;
  end;
  pTFO6141RO2 = ^TTFO6141RO2;


//------------------------------------------------------------------------------
//  [T_FI_ACC] ������ǰ ���� & ����ó ���� ����
//------------------------------------------------------------------------------
  TT_FI_ACCI1 = Packed Record // INPUT
     CANO           : Array[0..8  -1] of char; // ���հ��¹�ȣ
    _CANO           : char;
     ACNT_PRDT_CD   : Array[0..2  -1] of char; // ���»�ǰ�ڵ�
    _ACNT_PRDT_CD   : char;
     CRE_DT         : Array[0..8  -1] of char; // ��������
    _CRE_DT         : char;
     CHG_DT         : Array[0..8  -1] of char; // ���� ����ó ���� ������
    _CHG_DT         : char;
     ITFC_ID        : Array[0..12 -1] of char; // �������̽�ID
    _ITFC_ID        : char;
     POUT_FILE_NAME : Array[0..200-1] of char; // ������ϸ�
    _POUT_FILE_NAME : char;
  end;
  pT_FI_ACCI1 = ^TT_FI_ACCI1;

  TT_FI_ACCO2 = Packed Record // OUTPUT
     NRML_PRCS_YN : Array[0..1  -1] of char; // ����ó������
    _NRML_PRCS_YN : char;
     PRCS_MSG     : Array[0..100-1] of char; // ó���޼���
    _PRCS_MSG     : char;
  end;
  pT_FI_ACCO2 = ^TT_FI_ACCO2;

//------------------------------------------------------------------------------
//  [T_FI_RPT] ������ǰ ���� ���� ����
//------------------------------------------------------------------------------
  TT_FI_RPTI1 = Packed Record // INPUT
     CANO           : Array[0..8  -1] of char; // ���հ��¹�ȣ
    _CANO           : char;
     ITFC_ID        : Array[0..12 -1] of char; // �������̽�ID
    _ITFC_ID        : char;
     POUT_FILE_NAME : Array[0..200-1] of char; // ������ϸ�
    _POUT_FILE_NAME : char;
  end;
  pT_FI_RPTI1 = ^TT_FI_RPTI1;

  TT_FI_RPTO2 = Packed Record // OUTPUT
     NRML_PRCS_YN : Array[0..1  -1] of char; // ����ó������
    _NRML_PRCS_YN : char;
     PRCS_MSG     : Array[0..100-1] of char; // ó���޼���
    _PRCS_MSG     : char;
  end;
  pT_FI_RPTO2 = ^TT_FI_RPTO2;


//------------------------------------------------------------------------------
// ������ǰ Import ���� ���� ���� (Header)
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
  m_hHKCommDLL : THandle; // MCA CALL DLL HANDLE �Ҵ�
	m_pConnectMCAServer    : CONNECTMCASERVER;     // ���� ������ ���� ����
	m_pRequestData         : REQUESTDATA;          // ���� ������ ���� ������ ����
	m_pDisConnectMCAServer : DISCONNECTMCASERVER ; // ���� ������ ���� ���� ����

  gvMCACriticalSection: TRTLCriticalSection;

  gvMCAReceive: boolean; // ���� �޼��� ���� üũ

  gvMCAConnectIP   : string;    // MCA ���� IP
  gvMCAConnectPort : integer; // MCA ���� ���� PORT

  gvMCAFileFtpIP : string; // MCA ���� ���� FTP IP
  gvMCAFileFtpID : string; // MCA ���� ���� FTP ID
  gvMCAFileFtpPW : string; // MCA ���� ���� FTP PW
  gvMCAFileFtpMode : string;  // MCA ���� ���� FTP Mode
  gvMCAFileFtpPort : Integer; // MCA ���� ���� FTP Port
  gvMCAFileFtpPath : string;  // MCA ���� ���� FTP Path

  gvMCAInterfaceID : string; // MCA Interface ID

  gvMCAFtpFileList: TStringList; // ���� ���� ����Ʈ
  
  gvMCAConnectYn: Boolean;       // MCA ���� ���� ���� üũ
  gvMCAResult: String;           // MCA ���� ��ǲ������ ���� ó�� ����
  gvMCACloseResult: string;       // TSC6315U(����������������) �μ� ���� ����

  gvMCAFileCnt: Integer; // ����Ʈ ���� ���� ���� üũ

  gvMCAInputData_CalcComm  : TTSC3220RI1; // �������� Input������ ����
  gvMCAOutputData_CalcComm : TTSC3220RO2; // �������� Output������ ����

  gvMCALogFile : TextFile;  // MCA Log File
  gvMCALogFlag : boolean;   // MCA Log On/Off
  gvMCALogPath : string;    // MCA Log File Directory
  gvMCALogCriticalSection   // MCA Log File�� ���� CriticalSection
    : TRtlCriticalSection;

  gvAcEtcList: TStringList; // Ÿ�μ� ���� ����Ʈ

implementation

end.
