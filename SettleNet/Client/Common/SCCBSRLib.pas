//==============================================================================
//   [LMS] 2001/01/12
//==============================================================================
unit SCCBSRLib;

interface

Uses
  Windows, SysUtils, SCCGlobalType, SCCBSRType, SCCCmuLib;


//------------------------------------------------------------------------------
// 주식매매 자료 Decompress작업
//------------------------------------------------------------------------------
function gf_SRETradeDecompress(sCommonData : String;
                               iInfoDataCnt: Integer;
                               sInfoData   : String;
                               sMainData   : String;
                               ptEquityData : pTEI0I0_Data) : Boolean;

implementation

//------------------------------------------------------------------------------
// 주식 자료 Decompress작업
//------------------------------------------------------------------------------
function gf_SRETradeDecompress(sCommonData : String;
                              iInfoDataCnt: Integer;
                              sInfoData   : String;
                              sMainData   : String;
                              ptEquityData : pTEI0I0_Data) : Boolean;
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
  iIndex,iLen : Integer;
  sTemp,sTemp2 : String;
  iStartPos,iDataSize,iRepetCnt : Integer;
begin
  //----------------------------------------------------------------------------
  // COMMON부 -> SETRADE_TBL의 Key Field
  //----------------------------------------------------------------------------
  I := 1;
  ptEquityData.TradeDate := Copy(sCommonData,I,SizeOf(ptEquityData.TradeDate)-1);
  Inc(I,SizeOf(ptEquityData.TradeDate)-1);
  ptEquityData.DeptCode  := Copy(sCommonData,I,SizeOf(ptEquityData.DeptCode)-1);
  Inc(I,SizeOf(ptEquityData.DeptCode)-1);
  ptEquityData.AccNo     := Copy(sCommonData,I,SizeOf(ptEquityData.AccNo)-1);
  Inc(I,SizeOf(ptEquityData.AccNo)-1);
  ptEquityData.SubAccNo  := Copy(sCommonData,I,SizeOf(ptEquityData.SubAccNo)-1);
  Inc(I,SizeOf(ptEquityData.SubAccNo)-1);
  ptEquityData.IssueCode := Copy(sCommonData,I,SizeOf(ptEquityData.IssueCode)-1);
  Inc(I,SizeOf(ptEquityData.IssueCode)-1);
  ptEquityData.TranCode  := Copy(sCommonData,I,SizeOf(ptEquityData.TranCode)-1);
  Inc(I,SizeOf(ptEquityData.TranCode)-1);
  ptEquityData.TradeType := Copy(sCommonData,I,SizeOf(ptEquityData.TranCode)-1);
  //----------------------------------------------------------------------------


  MoveDataChar(@tTempInfoData,sInfoData,SizeOf(TInfoData)*iInfoDataCnt);

  //----------------------------------------------------------------------------
  // SCISSIF_TBL의 Information
  //----------------------------------------------------------------------------
  iIndex := 0;
  if CharCharCmp(tTempInfoData[iIndex].csTableName,'SCISSIF',7) <> 0 then
  begin
    gvErrorNo := 1048; //데이터 포맷 오류
    gvExtMsg  := 'csTableName오류';
    Result := False;
    Exit;
  end;
  iStartPos := StrToInt(tTempInfoData[iIndex].csStartPos);
  iDataSize := StrToInt(tTempInfoData[iIndex].csDataSize);

  sTemp := Copy(sMainData,iStartPos,iDataSize);

  I := 1;
  ptEquityData.tISSIF.IssueCode := Copy(sTemp,I,SizeOf(ptEquityData.tISSIF.IssueCode)-1);
  Inc(I,SizeOf(ptEquityData.tISSIF.IssueCode)-1);
  ptEquityData.tISSIF.SecType   := Copy(sTemp,I,SizeOf(ptEquityData.tISSIF.SecType)-1);
  Inc(I,SizeOf(ptEquityData.tISSIF.SecType)-1);
  ptEquityData.tISSIF.SecDetailType:= Copy(sTemp,I,SizeOf(ptEquityData.tISSIF.SecDetailType)-1);
  Inc(I,SizeOf(ptEquityData.tISSIF.SecDetailType)-1);
  ptEquityData.tISSIF.IssueFullCode:= Copy(sTemp,I,SizeOf(ptEquityData.tISSIF.IssueFullCode)-1);
  Inc(I,SizeOf(ptEquityData.tISSIF.IssueFullCode)-1);
  ptEquityData.tISSIF.IssueNameKor:= Copy(sTemp,I,SizeOf(ptEquityData.tISSIF.IssueNameKor)-1);
  Inc(I,SizeOf(ptEquityData.tISSIF.IssueNameKor)-1);
  ptEquityData.tISSIF.IssueNameEng:= Copy(sTemp,I,SizeOf(ptEquityData.tISSIF.IssueNameEng)-1);
  Inc(I,SizeOf(ptEquityData.tISSIF.IssueNameEng)-1);
  ptEquityData.tISSIF.IssueShrtKor:= Copy(sTemp,I,SizeOf(ptEquityData.tISSIF.IssueShrtKor)-1);
  Inc(I,SizeOf(ptEquityData.tISSIF.IssueShrtKor)-1);
  ptEquityData.tISSIF.IssueShrtEng:= Copy(sTemp,I,SizeOf(ptEquityData.tISSIF.IssueShrtEng)-1);
  Inc(I,SizeOf(ptEquityData.tISSIF.IssueShrtEng)-1);
  ptEquityData.tISSIF.OprID        := Copy(sTemp,I,SizeOf(ptEquityData.tISSIF.OprID)-1);
  Inc(I,SizeOf(ptEquityData.tISSIF.OprID)-1);
  ptEquityData.tISSIF.OprDate      := Copy(sTemp,I,SizeOf(ptEquityData.tISSIF.OprID)-1);
  Inc(I,SizeOf(ptEquityData.tISSIF.OprDate)-1);
  ptEquityData.tISSIF.OPrTime      := Copy(sTemp,I,SizeOf(ptEquityData.tISSIF.OPrTime)-1);
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // SETRADE_TBL의 Information
  //----------------------------------------------------------------------------
  Inc(iIndex,1);

  if CharCharCmp(tTempInfoData[iIndex].csTableName,'SETRADE',7) <> 0 then
  begin
    gvErrorNo := 1048; //데이터 포맷 오류
    gvExtMsg  := 'csTableName오류';
    Result := False;
    Exit;
  end;
  iStartPos := StrToInt(tTempInfoData[iIndex].csStartPos);
  iDataSize := StrToInt(tTempInfoData[iIndex].csDataSize);

  sTemp := Copy(sMainData,iStartPos,iDataSize);

  I := 1;
  ptEquityData.tTRADE.StlDate   := Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.StlDate)-1);
  Inc(I,SizeOf(ptEquityData.tTRADE.StlDate)-1);
  ptEquityData.tTRADE.TotExecQty:= Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.TotExecQty)-1);
  Inc(I,SizeOf(ptEquityData.tTRADE.TotExecQty)-1);
  ptEquityData.tTRADE.TotColtQty:= Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.TotColtQty)-1);
  Inc(I,SizeOf(ptEquityData.tTRADE.TotColtQty)-1);
  ptEquityData.tTRADE.AvrExecPrice:= Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.AvrExecPrice)-1);
  Inc(I,SizeOf(ptEquityData.tTRADE.AvrExecPrice)-1);
  ptEquityData.tTRADE.TotExecAmt:= Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.TotExecAmt)-1);
  Inc(I,SizeOf(ptEquityData.tTRADE.TotExecAmt)-1);
  ptEquityData.tTRADE.TotColtAmt:= Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.TotColtAmt)-1);
  Inc(I,SizeOf(ptEquityData.tTRADE.TotColtAmt)-1);
  ptEquityData.tTRADE.NetAmt    := Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.NetAmt)-1);
  Inc(I,SizeOf(ptEquityData.tTRADE.NetAmt)-1);
  ptEquityData.tTRADE.Comm      := Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.Comm)-1);
  Inc(I,SizeOf(ptEquityData.tTRADE.Comm)-1);
  ptEquityData.tTRADE.TradeTax  := Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.TradeTax)-1);
  Inc(I,SizeOf(ptEquityData.tTRADE.TradeTax)-1);
  ptEquityData.tTRADE.AgctTax   := Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.AgctTax)-1);
  Inc(I,SizeOf(ptEquityData.tTRADE.AgctTax)-1);
  ptEquityData.tTRADE.CapGainTax:= Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.CapGainTax)-1);
  Inc(I,SizeOf(ptEquityData.tTRADE.CapGainTax)-1);
  ptEquityData.tTRADE.ImportTime:= Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.ImportTime)-1);
  Inc(I,SizeOf(ptEquityData.tTRADE.ImportTime)-1);
  ptEquityData.tTRADE.SentCnt   := Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.SentCnt)-1);
  Inc(I,SizeOf(ptEquityData.tTRADE.SentCnt)-1);
  ptEquityData.tTRADE.DeltCnf   := Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.DeltCnf)-1);
  Inc(I,SizeOf(ptEquityData.tTRADE.DeltCnf)-1);
  ptEquityData.tTRADE.MsgCnt    := Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.MsgCnt)-1);
  Inc(I,SizeOf(ptEquityData.tTRADE.MsgCnt)-1);
  ptEquityData.tTRADE.ManualYn  := Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.ManualYn)-1);
  Inc(I,SizeOf(ptEquityData.tTRADE.ManualYn)-1);
  ptEquityData.tTRADE.SplitMtd     := Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.SplitMtd)-1);
  Inc(I,SizeOf(ptEquityData.tTRADE.SplitMtd)-1);
  ptEquityData.tTRADE.CommRate     := Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.CommRate)-1);
  Inc(I,SizeOf(ptEquityData.tTRADE.CommRate)-1);
  ptEquityData.tTRADE.CommBasicAmt := Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.CommBasicAmt)-1);
  Inc(I,SizeOf(ptEquityData.tTRADE.CommBasicAmt)-1);
  ptEquityData.tTRADE.LastExecTime := Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.LastExecTime)-1);
  Inc(I,SizeOf(ptEquityData.tTRADE.LastExecTime)-1);
  ptEquityData.tTRADE.OprID     := Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.OprID)-1);
  Inc(I,SizeOf(ptEquityData.tTRADE.OprID)-1);
  ptEquityData.tTRADE.OprDate   := Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.OprDate)-1);
  Inc(I,SizeOf(ptEquityData.tTRADE.OprDate)-1);
  ptEquityData.tTRADE.OPrTime   := Copy(sTemp,I,SizeOf(ptEquityData.tTRADE.OPrTime)-1);
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // SESPEXE_TBL의 Information
  //----------------------------------------------------------------------------
  Inc(iIndex,1);

  if CharCharCmp(tTempInfoData[iIndex].csTableName,'SESPEXE',7) <> 0 then
  begin
    gvErrorNo := 1048; //데이터 포맷 오류
    gvExtMsg  := 'csTableName오류';
    Result := False;
    Exit;
  end;
  iStartPos := StrToInt(tTempInfoData[iIndex].csStartPos);
  iDataSize := StrToInt(tTempInfoData[iIndex].csDataSize);
  iRepetCnt := StrToInt(tTempInfoData[iIndex].csRepetCnt);

  sTemp := Copy(sMainData,iStartPos,iDataSize*iRepetCnt);

  ptEquityData.iSpExeCnt := iRepetCnt;

  iLen := 1;
  for J := 0 to iRepetCnt - 1 do
  begin
    sTemp2 := Copy(sTemp,iLen,iDataSize);
    Inc(iLen,iDataSize);
    I := 1;
    ptEquityData.tSPEXE[J].ExecPrice := Copy(sTemp2,I,SizeOf(ptEquityData.tSPEXE[J].ExecPrice)-1);
    Inc(I,SizeOf(ptEquityData.tSPEXE[J].ExecPrice)-1);
    ptEquityData.tSPEXE[J].ExecQty   := Copy(sTemp2,I,SizeOf(ptEquityData.tSPEXE[J].ExecQty)-1);
    Inc(I,SizeOf(ptEquityData.tSPEXE[J].ExecQty)-1);
    ptEquityData.tSPEXE[J].ExecAmt   := Copy(sTemp2,I,SizeOf(ptEquityData.tSPEXE[J].ExecAmt)-1);
    Inc(I,SizeOf(ptEquityData.tSPEXE[J].ExecAmt)-1);
    ptEquityData.tSPEXE[J].ColtExecQty:= Copy(sTemp2,I,SizeOf(ptEquityData.tSPEXE[J].ColtExecQty)-1);
    Inc(I,SizeOf(ptEquityData.tSPEXE[J].ColtExecQty)-1);
    ptEquityData.tSPEXE[J].ColtExecAmt:= Copy(sTemp2,I,SizeOf(ptEquityData.tSPEXE[J].ColtExecAmt)-1);
    Inc(I,SizeOf(ptEquityData.tSPEXE[J].ColtExecAmt)-1);
    ptEquityData.tSPEXE[J].OprID     := Copy(sTemp,I,SizeOf(ptEquityData.tSPEXE[J].OprID)-1);
    Inc(I,SizeOf(ptEquityData.tSPEXE[J].OprID)-1);
    ptEquityData.tSPEXE[J].OprDate   := Copy(sTemp,I,SizeOf(ptEquityData.tSPEXE[J].OprDate)-1);
    Inc(I,SizeOf(ptEquityData.tSPEXE[J].OprDate)-1);
    ptEquityData.tSPEXE[J].OPrTime   := Copy(sTemp,I,SizeOf(ptEquityData.tSPEXE[J].OPrTime)-1);
  end;
  //----------------------------------------------------------------------------

  Result := True;
end;

end.
