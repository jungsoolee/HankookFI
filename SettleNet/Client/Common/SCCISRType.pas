//==============================================================================
//   [LHA] 2001/01/12
//==============================================================================
unit SCCISRType;

interface

uses classes;

type

//--------------------------------------------------------
// [EB0I0] Investor -> Broker: ��� ���� ����
//--------------------------------------------------------
  pTEB0I0_STLIS = ^TEB0I0_STLIS;
  TEB0I0_STLIS = Record
    StlBankCode : string[4];    // ��������
    FundType    : string[1];    // �ݵ�Ÿ��
    IssueCode   : string[12];   // �����ڵ�
    TradeType   : string[1];    // �Ÿű���
    StlQty      : string[10];   // ��������
    StlAmt      : string[15];   // �����ݾ�
  end;

  pTEB0I0_DATA = ^TEB0I0_DATA;
  TEB0I0_DATA = Record
    StlDate   : string[8];
    TradeDate : string[8];
    tBSTLIS   : TList;          // TEB0I0_STLIS�� List
  end;

//--------------------------------------------------------
// [EC0I0] Investor -> Custody: ��� ���� ����
//--------------------------------------------------------
  pTEC0I0_STLIS = ^TEC0I0_STLIS;
  TEC0I0_STLIS = Record
    BrkCompCode : string[4];    // ���ǻ�
    FundCode    : string[10];   // �ݵ��ڵ�
    IssueCode   : string[12];   // �����ڵ�
    TradeType   : string[1];    // �Ÿű���
    StlQty      : string[10];   // ��������
    StlAmt      : string[15];   // �����ݾ�
  end;

  pTEC0I0_DATA = ^TEC0I0_DATA;
  TEC0I0_DATA = Record
    StlDate   : string[8];
    TradeDate : string[8];
    tCSTLIS   : TList;          // TEC0I0_STLIS�� List
  end;


implementation

end.
