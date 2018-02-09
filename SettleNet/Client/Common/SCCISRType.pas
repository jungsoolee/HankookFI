//==============================================================================
//   [LHA] 2001/01/12
//==============================================================================
unit SCCISRType;

interface

uses classes;

type

//--------------------------------------------------------
// [EB0I0] Investor -> Broker: 운용 지시 내역
//--------------------------------------------------------
  pTEB0I0_STLIS = ^TEB0I0_STLIS;
  TEB0I0_STLIS = Record
    StlBankCode : string[4];    // 결제은행
    FundType    : string[1];    // 펀드타입
    IssueCode   : string[12];   // 종목코드
    TradeType   : string[1];    // 매매구분
    StlQty      : string[10];   // 결제수량
    StlAmt      : string[15];   // 결제금액
  end;

  pTEB0I0_DATA = ^TEB0I0_DATA;
  TEB0I0_DATA = Record
    StlDate   : string[8];
    TradeDate : string[8];
    tBSTLIS   : TList;          // TEB0I0_STLIS의 List
  end;

//--------------------------------------------------------
// [EC0I0] Investor -> Custody: 운용 지시 내역
//--------------------------------------------------------
  pTEC0I0_STLIS = ^TEC0I0_STLIS;
  TEC0I0_STLIS = Record
    BrkCompCode : string[4];    // 증권사
    FundCode    : string[10];   // 펀드코드
    IssueCode   : string[12];   // 종목코드
    TradeType   : string[1];    // 매매구분
    StlQty      : string[10];   // 결제수량
    StlAmt      : string[15];   // 결제금액
  end;

  pTEC0I0_DATA = ^TEC0I0_DATA;
  TEC0I0_DATA = Record
    StlDate   : string[8];
    TradeDate : string[8];
    tCSTLIS   : TList;          // TEC0I0_STLIS의 List
  end;


implementation

end.
