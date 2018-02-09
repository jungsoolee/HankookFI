//==============================================================================
//   [LMS] 2001/01/12
//==============================================================================
unit SCCBSRType;

interface

uses classes;

type

//--------------------------------------------------------
// [EI0I0] Broker -> INvetstor: 주식 매매 내역
//--------------------------------------------------------
  pTEI0I0_ISSIF = ^TEI0I0_ISSIF;
  TEI0I0_ISSIF = Record
    IssueCode     : string[12];
    SecType       : string[1];
    SecDetailType : string[1];
    IssueFullCode : string[12];
    IssueNameKor  : string[60];
    IssueNameEng  : string[60];
    IssueShrtKor  : string[30];
    IssueShrtEng  : string[30];
    OprID         : string[8];
    OprDate       : string[8];
    OprTime       : string[8];
  end;

  pTEI0I0_SPEXE = ^TEI0I0_SPEXE;
  TEI0I0_SPEXE = Record
    ExecPrice     : string[9];
    ExecQty       : string[13];
    ExecAmt       : string[15];
    ColtExecQty   : string[13];
    ColtExecAmt   : string[15];
    OprID         : string[8];
    OprDate       : string[8];
    OPrTime       : string[8];
  end;

  pTEI0I0_TRADE = ^TEI0I0_TRADE;
  TEI0I0_TRADE = Record
    StlDate      : string[8];
    TotExecQty   : string[13];
    TotColtQty   : string[13];
    AvrExecPrice : string[18];
    TotExecAmt   : string[15];
    TotColtAmt   : string[15];
    NetAmt       : string[15];
    Comm         : string[13];
    TradeTax     : string[13];
    AgctTax      : string[13];
    CapGainTax   : string[13];
    ImportTime   : string[8];
    SentCnt      : string[5];
    DeltCnf      : string[1];
    MsgCnt       : string[5];
    ManualYn     : string[1];
    SplitMtd     : string[1];
    CommRate     : string[9];
    CommBasicAmt : string[11];
    LastExecTime : string[8];
    OprID        : string[8];
    OprDate      : string[8];
    OprTime      : string[8];
  end;

  pTEI0I0_DATA = ^TEI0I0_DATA;
  TEI0I0_DATA = Record
    TradeDate : string[8];
    DeptCode  : string[2];
    AccNo     : string[20];
    SubAccNo  : string[4];
    IssueCode : string[12];
    TranCode  : string[4];
    TradeType : string[1];
    iSpExeCnt : Integer;
    tSPEXE    : Array [0..244] of TEI0I0_SPEXE;
    tISSIF    : TEI0I0_ISSIF;
    tTRADE    : TEI0I0_TRADE;
  end;

implementation

end.
