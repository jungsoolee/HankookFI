//==============================================================================
//   [LHA] 2001/01/12
//==============================================================================
unit SCCISRLib;

interface

Uses
  Windows, SysUtils, SCCGlobalType, SCCISRType, SCCCmuLib;

//------------------------------------------------------------------------------
// 운용지시 자료 Decompress작업
//------------------------------------------------------------------------------
function gf_SRESettleDecompress(sCommonData : String;
                                iInfoDataCnt: Integer;
                                sInfoData   : String;
                                sMainData   : String;
                                ptSettleData : pTEB0I0_Data) : Boolean;
procedure gf_SRESettleClearList(ptSettleData : pTEB0I0_Data);

function gf_SRESettleDecompress_C(sCommonData : String;
                                iInfoDataCnt: Integer;
                                sInfoData   : String;
                                sMainData   : String;
                                ptSettleData : pTEC0I0_Data) : Boolean;
procedure gf_SRESettleClearList_C(ptSettleData : pTEC0I0_Data);

implementation

//------------------------------------------------------------------------------
// 운용지시 자료 Decompress작업 (Investor --> Broker)
//------------------------------------------------------------------------------
function gf_SRESettleDecompress(sCommonData : String;
                                iInfoDataCnt: Integer;
                                sInfoData   : String;
                                sMainData   : String;
                                ptSettleData : pTEB0I0_Data) : Boolean;
type
  ptTInfoData = ^TInfoData;
  TInfoData = record
    csTableName : Array [0..9] of Char;
    cDelIns     : Char;
    csStartPos  : Array [0..4] of Char;
    csDataSize  : Array [0..4] of Char;
    csRepetCnt  : Array [0..2] of Char;
  end;

var
  tTempInfoData : Array [0..9] of TInfoData;
  I,J : Integer;
  iIndex : Integer;
  sData  : String;
  iStartPos,iDataSize,iRepetCnt : Integer;
  ptTEB0I0_STLIS : pTEB0I0_STLIS;
begin
  if not Assigned(ptSettleData.tBSTLIS) then
  begin
    gvErrorNo := 9005; //데이터 오류
    gvExtMsg  := 'ptSettleData.tBSTLIS is Nil';
    Result := False;
    Exit;
  end;
  gf_SRESettleClearList(ptSettleData);

  //----------------------------------------------------------------------------
  // COMMON부 -> 결제일(8) + 매매일(8)
  //----------------------------------------------------------------------------
  I := 1;
  ptSettleData.StlDate   := Copy(sCommonData,I,SizeOf(ptSettleData.StlDate)-1);
  Inc(I,SizeOf(ptSettleData.StlDate)-1);
  ptSettleData.TradeDate := Copy(sCommonData,I,SizeOf(ptSettleData.TradeDate)-1);
  //----------------------------------------------------------------------------

  MoveDataChar(@tTempInfoData,sInfoData,SizeOf(TInfoData)*iInfoDataCnt);

  //----------------------------------------------------------------------------
  // 윤용지시의 Information Data
  //----------------------------------------------------------------------------
  iIndex := 0;
  if CharCharCmp(tTempInfoData[iIndex].csTableName,'SESTLIS',7) <> 0 then
  begin
    gvErrorNo := 1048; //데이터 포맷 오류
    gvExtMsg  := 'csTableName오류';
    Result := False;
    Exit;
  end;
  iStartPos := StrToInt(tTempInfoData[iIndex].csStartPos);
  iDataSize := StrToInt(tTempInfoData[iIndex].csDataSize);
  iRepetCnt := StrToInt(tTempInfoData[iIndex].csRepetCnt);

  sData := Copy(sMainData,iStartPos,iDataSize*iRepetCnt);

  I := 1;
  for J := 0 to iRepetCnt - 1 do
  begin
    New(ptTEB0I0_STLIS);
    ptTEB0I0_STLIS.StlBankCode := Copy(sData,I,SizeOf(ptTEB0I0_STLIS.StlBankCode)-1);
    Inc(I,SizeOf(ptTEB0I0_STLIS.StlBankCode)-1);
    ptTEB0I0_STLIS.FundType    := Copy(sData,I,SizeOf(ptTEB0I0_STLIS.FundType)-1);
    Inc(I,SizeOf(ptTEB0I0_STLIS.FundType)-1);
    ptTEB0I0_STLIS.IssueCode   := Copy(sData,I,SizeOf(ptTEB0I0_STLIS.IssueCode)-1);
    Inc(I,SizeOf(ptTEB0I0_STLIS.IssueCode)-1);
    ptTEB0I0_STLIS.TradeType   := Copy(sData,I,SizeOf(ptTEB0I0_STLIS.TradeType)-1);
    Inc(I,SizeOf(ptTEB0I0_STLIS.TradeType)-1);
    ptTEB0I0_STLIS.StlQty      := Copy(sData,I,SizeOf(ptTEB0I0_STLIS.StlQty)-1);
    Inc(I,SizeOf(ptTEB0I0_STLIS.StlQty)-1);
    ptTEB0I0_STLIS.StlAmt      := Copy(sData,I,SizeOf(ptTEB0I0_STLIS.StlAmt)-1);
    Inc(I,SizeOf(ptTEB0I0_STLIS.StlAmt)-1);
    ptSettleData.tBSTLIS.Add(ptTEB0I0_STLIS);
  end;
  //----------------------------------------------------------------------------
  Result := True;
end;

procedure gf_SRESettleClearList(ptSettleData : pTEB0I0_Data);
var
  I : Integer;
  ptTEB0I0_STLIS : pTEB0I0_STLIS;
begin
  if not Assigned(ptSettleData.tBSTLIS) then Exit;
  for I := 0 to ptSettleData.tBSTLIS.Count -1 do
  begin
     ptTEB0I0_STLIS := ptSettleData.tBSTLIS.Items[I];
     Dispose(ptTEB0I0_STLIS);
  end;
  ptSettleData.tBSTLIS.Clear;
end;

//------------------------------------------------------------------------------
// 운용지시 자료 Decompress작업 (Investor --> Custody)
//------------------------------------------------------------------------------
function gf_SRESettleDecompress_C(sCommonData : String;
                                iInfoDataCnt: Integer;
                                sInfoData   : String;
                                sMainData   : String;
                                ptSettleData : pTEC0I0_DATA) : Boolean;
type
  ptTInfoData = ^TInfoData;
  TInfoData = record
    csTableName : Array [0..9] of Char;
    cDelIns     : Char;
    csStartPos  : Array [0..4] of Char;
    csDataSize  : Array [0..4] of Char;
    csRepetCnt  : Array [0..2] of Char;
  end;

var
  tTempInfoData : Array [0..9] of TInfoData;
  I,J : Integer;
  iIndex : Integer;
  sData  : String;
  iStartPos,iDataSize,iRepetCnt : Integer;
  ptTEC0I0_STLIS : pTEC0I0_STLIS;
begin
  if not Assigned(ptSettleData.tCSTLIS) then
  begin
    gvErrorNo := 9005; //데이터 오류
    gvExtMsg  := 'ptSettleData.tCSTLIS is Nil';
    Result := False;
    Exit;
  end;
  gf_SRESettleClearList_C(ptSettleData);

  //----------------------------------------------------------------------------
  // COMMON부 -> 결제일(8) + 매매일(8)
  //----------------------------------------------------------------------------
  I := 1;
  ptSettleData.StlDate   := Copy(sCommonData,I,SizeOf(ptSettleData.StlDate)-1);
  Inc(I,SizeOf(ptSettleData.StlDate)-1);
  ptSettleData.TradeDate := Copy(sCommonData,I,SizeOf(ptSettleData.TradeDate)-1);
  //----------------------------------------------------------------------------

  MoveDataChar(@tTempInfoData,sInfoData,SizeOf(TInfoData)*iInfoDataCnt);

  //----------------------------------------------------------------------------
  // 윤용지시의 Information Data
  //----------------------------------------------------------------------------
  iIndex := 0;
  if CharCharCmp(tTempInfoData[iIndex].csTableName,'SESTLIS',7) <> 0 then
  begin
    gvErrorNo := 1048; //데이터 포맷 오류
    gvExtMsg  := 'csTableName오류';
    Result := False;
    Exit;
  end;
  iStartPos := StrToInt(tTempInfoData[iIndex].csStartPos);
  iDataSize := StrToInt(tTempInfoData[iIndex].csDataSize);
  iRepetCnt := StrToInt(tTempInfoData[iIndex].csRepetCnt);

  sData := Copy(sMainData,iStartPos,iDataSize*iRepetCnt);

  I := 1;
  for J := 0 to iRepetCnt - 1 do
  begin
    New(ptTEC0I0_STLIS);
    ptTEC0I0_STLIS.FundCode    := Copy(sData,I,SizeOf(ptTEC0I0_STLIS.FundCode)-1);
    Inc(I,SizeOf(ptTEC0I0_STLIS.FundCode)-1);
    ptTEC0I0_STLIS.IssueCode   := Copy(sData,I,SizeOf(ptTEC0I0_STLIS.IssueCode)-1);
    Inc(I,SizeOf(ptTEC0I0_STLIS.IssueCode)-1);
    ptTEC0I0_STLIS.TradeType   := Copy(sData,I,SizeOf(ptTEC0I0_STLIS.TradeType)-1);
    Inc(I,SizeOf(ptTEC0I0_STLIS.TradeType)-1);
    ptTEC0I0_STLIS.StlQty      := Copy(sData,I,SizeOf(ptTEC0I0_STLIS.StlQty)-1);
    Inc(I,SizeOf(ptTEC0I0_STLIS.StlQty)-1);
    ptTEC0I0_STLIS.StlAmt      := Copy(sData,I,SizeOf(ptTEC0I0_STLIS.StlAmt)-1);
    Inc(I,SizeOf(ptTEC0I0_STLIS.StlAmt)-1);
    ptSettleData.tCSTLIS.Add(ptTEC0I0_STLIS);
  end;
  //----------------------------------------------------------------------------
  Result := True;
end;

procedure gf_SRESettleClearList_C(ptSettleData : pTEC0I0_DATA);
var
  I : Integer;
  ptTEC0I0_STLIS : pTEC0I0_STLIS;
begin
  if not Assigned(ptSettleData.tCSTLIS) then Exit;
  for I := 0 to ptSettleData.tCSTLIS.Count -1 do
  begin
     ptTEC0I0_STLIS := ptSettleData.tCSTLIS.Items[I];
     Dispose(ptTEC0I0_STLIS);
  end;
  ptSettleData.tCSTLIS.Clear;
end;

end.
