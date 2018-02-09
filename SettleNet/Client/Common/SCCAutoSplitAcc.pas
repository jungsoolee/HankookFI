unit SCCAutoSplitAcc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  SCCDlgForm, DB, ADODB, DRCodeControl, Grids, DRStringgrid,
  DRDialogs, StdCtrls, Buttons, DRAdditional, ExtCtrls, DRStandard,
  DRSpecial, Dialogs;  


type
  TAutoSplitList = record   // 일괄 분할 대상 계좌 저장
    sAccNo : string;
    sAccId : string;
    sHwAccNo : string;
    sHwAccId : string;
    sBrkShtNo : string;
    sIssueCode : string;
    sTranCode  : String;
    sTranName  : String;
    sTradeType : String;
    sSptMtd    : String; // 부계좌 분할  체크용도
    sDpSptMtd : string; // 분할방법
  end;
  pAutoSplitList =^TAutoSplitList;


type
  THWAccList = record      // 하위계좌 콤보박스 list
    sAccNo : string;
    sHwAccNo : string;
    sHwAccId : string;
    dCommRate  : Double;
end;
  pHWAccList =^THWAccList;


type
  TDlgForm_AutoSplitAcc = class(TForm_Dlg)
    DRPanel1: TDRPanel;
    DRStringGrid_Main: TDRStringGrid;
    ADOQuery_Main: TADOQuery;
    DRUserDblCodeCombo_HwAcc: TDRUserDblCodeCombo;
    ADOQuery_Temp: TADOQuery;
    ADOSP_SBP2701_AO_Bef: TADOCommand;
    ADOSP_SBPTax_SettleSplit: TADOCommand;
    ADOSP_SBP2701_AO: TADOCommand;
    pnl1: TPanel;
    DRStringGrid_HwAcc: TDRStringGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    function  QueryToList: boolean;
    function InsertSplitData : boolean;
    function  IsSubSplit(pAccNo, pIssueCode, pTranCode, pTradeType, pBrkShtNo : String) : String; //부계좌분할확인

    function  MakeTradeDataList : Boolean;
    procedure RemoveMemoryTRADE;       // 매매정보     LIST Remove
    procedure RemoveMemoryHWAccList;
    procedure DisplayGridData;
    procedure DisplayGridData_HwAcc;
    procedure DRStringGrid_MainDrawCell(Sender: TObject; ACol,
      ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure DRUserDblCodeCombo_HwAccEditKeyPress(Sender: TObject;
      var Key: Char);
    procedure DRUserDblCodeCombo_HwAccCodeChange(Sender: TObject);
    procedure DRBitBtn2Click(Sender: TObject);
    procedure DisplayTradeGridData;
    procedure DRStringGrid_MainSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure DRStringGrid_HwAccSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure DRStringGrid_HwAccDblClick(Sender: TObject);
    procedure DRStringGrid_MainClick(Sender: TObject);              //매매자료

  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  DlgForm_AutoSplitAcc: TDlgForm_AutoSplitAcc;
  AutoSplitList   : TList;   // 일괄 분할 대상 계좌 저장.
  HwAccList       : TList;   // 하위계좌 Combo list 저장
  FormCreated : boolean;
  iACol, iARow, iHwACol, iHwARow : Integer;

implementation

{$R *.dfm}

uses
  SCCGlobalType, SCCLib, Types, SCFH2356, SCCTFLib, SCCTFGlobalType, SCCChildForm;

const
   // DRStrGrid_TRADE IDX
   IDX_ACC_ID     = 0;
   IDX_ACC_NO     = 1;
   IDX_HW_ID      = 2;
   IDX_HW_ACC_NO  = 3;
   IDX_SPLIT_TYPE = 4;

   IDX_HW_ID_R      = 0;
   IDX_HW_ACC_NO_R  = 1;
   IDX_HW_COMM_RATE = 2;


   HIS_TYPE_DP_SPLIT = '3';
   ACC_TYPE_DP       = 'F'; //계좌정보 대표계좌타입
   ACC_TYPE_HW       = 'T'; //계좌정보 하위계좌타입


//------------------------------------------------------------------------------
//  분할대상내역 Sorting 함수
//------------------------------------------------------------------------------
function TradeListCompare(Item1, Item2: Pointer): Integer;
var
  StdStr1, StdStr2 : string;
begin
  if bDaeTooCheck then
  begin
    StdStr1 := pTradeList(Item1).sIdent +
               pTradeList(Item1).sAccNO +
               pTradeList(Item1).sIssueName;

    StdStr2 := pTradeList(Item2).sIdent +
               pTradeList(Item2).sAccNO +
               pTradeList(Item2).sIssueName;
  end else
  begin
    StdStr1 := pTradeList(Item1).sIdent +
               pTradeList(Item1).sAccNO +
               pTradeList(Item1).sIssueCode;

    StdStr2 := pTradeList(Item2).sIdent +
               pTradeList(Item2).sAccNO +
               pTradeList(Item2).sIssueCode;
  end;

  case SortIdx_TrLst of
    // ACC_NO
    2, 3: Result := gf_ReturnStrComp(StdStr1, StdStr2, SortFlag_TrLst[SortIdx_TrLst]);

    // ISSUE_CODE
    6:
      if pTradeList(Item1).sAccNo <> pTradeList(Item2).sAccNo then
      begin
         Result := gf_ReturnStrComp(StdStr1, StdStr2, False);
      end
      else begin
         Result :=  gf_ReturnStrComp(pTradeList(Item1).sIssueCode + pTradeList(Item1).sTradeType + FloatToStr(pTradeList(Item1).dTotQty),
                                     pTradeList(Item2).sIssueCode + pTradeList(Item2).sTradeType + FloatToStr(pTradeList(Item2).dTotQty),
                                     SortFlag_TrLst[SortIdx_TrLst]);
      end;

    // ISSUE_NAME_KOR
    7:
      if pTradeList(Item1).sAccNo <> pTradeList(Item2).sAccNo then
      begin
         Result := gf_ReturnStrComp(StdStr1, StdStr2, False);
      end
      else begin
         Result :=  gf_ReturnStrComp(pTradeList(Item1).sIssueName + pTradeList(Item1).sTradeType + FloatToStr(pTradeList(Item1).dTotQty),
                                     pTradeList(Item2).sIssueName + pTradeList(Item2).sTradeType + FloatToStr(pTradeList(Item2).dTotQty),
                                     SortFlag_TrLst[SortIdx_TrLst]);
      end;

    // TRADE_TYPE
    9:
      if pTradeList(Item1).sAccNO <> pTradeList(Item2).sAccNO then
      begin
         Result := gf_ReturnStrComp(pTradeList(Item1).sIdent + pTradeList(Item1).sAccNO + pTradeList(Item1).sTrTypeName,
                                    pTradeList(Item2).sIdent + pTradeList(Item2).sAccNO + pTradeList(Item2).sTrTypeName,
                                    False);
      end
      else begin
         Result := gf_ReturnStrComp(pTradeList(Item1).sTrTypeName + FloatToStr(pTradeList(Item1).dTotQty),
                                    pTradeList(Item2).sTrTypeName + FloatToStr(pTradeList(Item2).dTotQty), SortFlag_TrLst[SortIdx_TrLst]);

      end;
    // QTY
    11:
      if pTradeList(Item1).sAccNO <> pTradeList(Item2).sAccNO then
      begin
         Result := gf_ReturnStrComp(pTradeList(Item1).sIdent + pTradeList(Item1).sAccNO + FloatToStr(pTradeList(Item1).dTotQty),
                                    pTradeList(Item2).sIdent + pTradeList(Item2).sAccNO + FloatToStr(pTradeList(Item2).dTotQty),
                                    False);
      end
      else begin
         Result := gf_ReturnFloatComp(pTradeList(Item1).dTotQty,
                                      pTradeList(Item2).dTotQty, SortFlag_TrLst[SortIdx_TrLst]);

      end;
    else
      Result := 0;
  end;  // end of case

end;   

procedure TDlgForm_AutoSplitAcc.DisplayGridData;
var
  I, j, iRow : Integer;
  AccItem   : pAutoSplitList;
  HwAccItem : pHWAccList;
  Combo : TComboBox;
  sAccNo : string;
begin
  iRow := 1;
  sAccNo := '';
  //DRUserDblCodeCombo_HwAcc.ClearItems;

  with DRStringGrid_Main do
  begin

    for i:= 0 to AutoSplitList.Count -1 do //
    begin
      AccItem := AutoSplitList.Items[i];
      Rows[iRow].clear;

      ColorRow[iRow] := gcSubGridSelectColor;
      RowFont[iRow].Color := clBlack;

      if (sAccNO <> AccItem.sAccNo) or (sAccNO = '')  then  // 같은 대표계좌는 하나만 뿌린다.
      begin
        Cells[IDX_ACC_ID, iRow] := AccItem.sAccId;
        Cells[IDX_ACC_NO, iRow] := AccItem.sAccNo;
  //      Cells[, iRow] := AccItem.sIssueCode;
        Cells[IDX_SPLIT_TYPE, iRow] := AccItem.sDpSptMtd;

        Inc(iRow);
        sAccNO := accitem.saccno;
      end;

    end;
    RowCount := iRow;

  end;


end;

procedure TDlgForm_AutoSplitAcc.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FormCreated := false;
//  Action := caFree;
end;

procedure TDlgForm_AutoSplitAcc.FormCreate(Sender: TObject);
begin
  inherited;
  FormCreated := true;
  //DRUserDblCodeCombo_HwAcc.ClearItems;

  DRStringGrid_Main.RowCount := 2;
  DRStringGrid_Main.Rows[1].Clear;

  DRStringGrid_HwAcc.RowCount := 2;
  DRStringGrid_HwAcc.Rows[1].Clear;

  // HWACCLIST CLEAR
  RemoveMemoryHWAccList;

  //--- Display
  DisplayGridData;

end;

function TDlgForm_AutoSplitAcc.QueryToList: boolean;
var
  AccItem : pHWAccList;
  SplitItem : pAutoSplitList;
  i, j, iIdx : integer;
  AccNo : string;
  sIssueCode,  sTranCode, sTradeType, sBrkShtNo : string;
begin
  Result := False;
  iIdx := 0;
  AccNo := DRStringGrid_Main.Cells[IDX_ACC_NO, iARow];

   for i:= 0 to AutoSplitList.Count -1 do
   begin
     SplitItem := AutoSplitList.Items[i];

     if (SplitItem.sAccNo = AccNo) then
     begin
       sIssueCode := SplitItem.sIssueCode;
       sTranCode  := SplitItem.sTranCode;
       sTradeType := SplitItem.sTradeType;
       sBrkShtNo  := SplitItem.sBrkShtNo;
     end;
   end;


  with ADOQuery_Main do
  begin
    EnableBCD := False;
    Close;
    SQL.Clear;
    SQL.ADD('      SELECT  DISTINCT               ');
    SQL.ADD('              h.ACC_NO,              ');
    SQL.ADD('              h.HW_ACC_NO,           ');
    SQL.ADD('              H_COMM_RATE = dbo.fn_GetCommRate(''' + gvDeptCode + ''',                   ');
    SQL.ADD('                              ''' + TradeDate  + ''', h.HW_ACC_NO, ''' + sTranCode + ''' ');
    SQL.ADD('                              ,''N''),                                                   ');
    SQL.ADD('              a.IDENTIFICATION      ');
    SQL.ADD('      from SEHWACC_TBL h, SETSPTM_TBL m, SEACBIF_TBL a                                   ');
    SQL.ADD('      where h.DEPT_CODE  = ''' + gvDeptCode + '''                                        ');
    SQL.ADD('        and h.DEPT_CODE  *= m.DEPT_CODE                                                  ');
    SQL.ADD('        and h.ACC_NO     *= m.ACC_NO                                                     ');
    SQL.ADD('        and h.HW_ACC_NO  *= m.HW_ACC_NO                                                  ');
    SQL.ADD('        and h.DEPT_CODE  = a.DEPT_CODE                                                   ');
    SQL.ADD('        and h.HW_ACC_NO  = a.ACC_NO                                                      ');
    SQL.ADD('        and m.TRADE_DATE = ''' + TradeDate  + '''                                        ');
    SQL.ADD('        and m.ISSUE_CODE = ''' + sIssueCode + '''                                        ');
    SQL.ADD('        and m.TRAN_CODE  = ''' + sTranCode  + '''                                        ');
    SQL.ADD('        and m.BRK_SHT_NO = ''' + sBrkShtNo  + '''                                        ');
    SQL.ADD('        and m.TRADE_TYPE = ''' + sTradeType + '''                                        ');

    SQL.Add(' and h.ACC_NO = ''' + AccNo + ''' ');
    {
    if AutoSplitList.Count > 0 then
    begin
      SQL.Add(' AND (');
      for i:= 0 to AutoSplitList.Count -2 do begin
//        AccItem := AutoSplitList.Items[i];
        SQL.Add(' ( h.ACC_NO = ''' + AccNo + ''') OR ');   // 계좌는 선택된 셀의 계좌 ㅠ_ㅠㅋㅋㅋ
      end;
//      AccItem := AutoSplitList.Items[AutoSplitList.Count -1];
      SQL.Add(' ( h.ACC_NO = ''' + AccNo + ''')) ');
    end;
    }
    SQL.Add('ORDER BY a.IDENTIFICATION, h.HW_ACC_NO');

//SQL.SaveToFile('c:\SCCAutoSplitAcc.sql');

    try
      gf_ADOQueryOpen(ADOQuery_Main);
    except
      on E : Exception do
      begin
        // Database 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Main[Query]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Main[Query]'); // Database 오류
        Exit;
      end;
    end;

    RemoveMemoryHWAccList;
    first;
    while not Eof do
    begin
      New(AccItem);
      HwAccList.Add(AccItem);
      AccItem.sAccNo := Trim(FieldByName('ACC_NO').AsString);
      AccItem.sHwAccNo := Trim(FieldByName('HW_ACC_NO').AsString);
      AccItem.sHwAccId := Trim(FieldByName('IDENTIFICATION').AsString);
      AccItem.dCommRate := (FieldByName('H_COMM_RATE').AsFloat) * 100;
      next;
    end;
  end;
  Result := True;



end;

procedure TDlgForm_AutoSplitAcc.DRStringGrid_MainDrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  inherited;
//  DRStringGrid_Main.DoubleBuffered := true;
end;

procedure TDlgForm_AutoSplitAcc.FormShow(Sender: TObject);
begin
  inherited;
//  DRStringGrid_Main.DoubleBuffered := true;
end;

procedure TDlgForm_AutoSplitAcc.DRUserDblCodeCombo_HwAccEditKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
    DRBitBtn2.SetFocus;
    
end;

procedure TDlgForm_AutoSplitAcc.DRUserDblCodeCombo_HwAccCodeChange(
  Sender: TObject);
var
  i : integer;
  HwAccItem : pHWAccList;
begin
  inherited;
  if Trim(DRUserDblCodeCombo_HwAcc.Code) = '' then
  begin
    DRStringGrid_Main.Cells[IDX_HW_ID, 1] := '';
  end else
  begin
    for i:= 0 to HwAccList.Count -1 do
    begin
      HwAccItem := HwAccList.Items[i];
      if (HwAccItem.sHwAccNo = DRUserDblCodeCombo_HwAcc.Code) then
      begin
        DRStringGrid_Main.Cells[IDX_HW_ID, 1] := HwAccItem.sHwAccId;
        Break;
      end;
    end;

  end;
end;

procedure TDlgForm_AutoSplitAcc.DRBitBtn2Click(Sender: TObject);
var
  pTempTradeList : pTradeLIst;
  pAutoSplitItem : pAutoSplitList;
  i, iRow, SelIdx : Integer;
  sMsg: string;
  CheckData : boolean; // 처리대상 자료 존재 여부.
begin
  inherited;

  DisableForm;


   gf_ClearMessage(MessageBar);

   // 처리대상 자료 존재 체크.
   CheckData := False;

   if (DRStringGrid_Main.Cells[IDX_HW_ID, 1] <> '') then  // 하위계좌 선택 안했으면 에러.
   begin
     CheckData := True;
   end;

   if not CheckData then
   begin
     EnableForm;
     gf_ShowMessage(MessageBar, mtError, 1009, ''); // 선택 항목이 없습니다.
     DRStringGrid_Main.SetFocus;
     Exit;
   end;


   // [한투] 결제업무 마감 체크
   if gvHostCallUseYN = 'Y' then // HostCall 연동 여부, dataroad N, 한국증권 Y, 하나대투 Y
   begin
     if gvHostGWUseYN = 'N' then // HostGW 사용 여부, Default N, 한국증권 N, 하나대투 Y
     begin
       //----------------------------------------------------------------------------
       // Connect MCA
       //----------------------------------------------------------------------------
       if Not gf_tf_HostMCAConnect(False, sMsg) then
       begin
         gf_ShowErrDlgMessage(Self.Tag,0, 'MCA 접속 에러.'
         + #13#10 + #13#10 + sMsg,0);
         EnableForm;
         Exit;
       end;


       // 결제업무 마감 여부 체크
       if not gf_tf_HostMCAprocessStlClose(Trim(Form_SCFH2356.DRInputMaskEdit_Date.Text), '01', 'SN', sMsg) then
       begin
         gf_ShowMessage(MessageBar, mtError, 0, '원장 결제업무마감 체크 오류(MCA)');
         gf_ShowErrDlgMessage(Self.Tag,0, '원장 결제업무마감 체크 오류(MCA)'
                              + #13#10 + #13#10 + sMsg,0);
         EnableForm;
         Exit;
       end;

       if gvMCACloseResult = 'Y' then
       begin
         gf_ShowMessage(MessageBar, mtError, 0, '해당일은 이미 마감되었습니다.[결제업무부]');
         Form_SCFH2356.DRInputMaskEdit_Date.SetFocus;
         EnableForm;
         Exit;
       end;
     end; // if gvHostGWUseYN   = 'N' then
   end; // if gvHostCallUseYN = 'Y' then

//   ShowProcessMsgBar;

   sMsg := '';


//   for i:= 0 to TradeList.Count -1 do
//   begin                          // 안에서 루프돈다~~

     if not InsertSplitData then    // 평균가 분할
     begin

       EnableForm;

       if not MakeTradeDataList then
       begin
         RemoveMemoryTRADE;
         Exit;
       end;
         // 잠시주석
       TradeList.Sort(TradeListCompare);
       DisplayTradeGridData;

       CurRow := iRow;
       gf_SelectStrGridRow(Form_SCFH2356.DRStrGrid_TRADE, CurRow);
       Form_SCFH2356.EnabledButton(True, True, False); //조회, 분할
       //igTradeMemIndex := SearchTradeMemoryIndexForRow(CurRow);
       exit;
       {}
     end;
//   end;




   Form_SCFH2356.ClearPanelAverage;
   Form_SCFH2356.ClearPanelAverageInput;

  // TRADE Grid Refresh
  with Form_SCFH2356.DRStrGrid_TRADE do
  begin
    RowCount := 2;
    Rows[1].Clear;
    Cells[0, 0] := '';

    if not MakeTradeDataList then
    begin
      RemoveMemoryTRADE;
      Exit;
    end;

    TradeList.Sort(TradeListCompare);
    DisplayTradeGridData;

    //
    if (SpritCellRow > 0) then
    begin
      gf_SelectStrGridRow(Form_SCFH2356.DRStrGrid_TRADE, SpritCellRow);
      CurRow := SpritCellRow;
      CurCol := 1;
      Form_SCFH2356.DRStrGrid_TRADEDblClick(Form_SCFH2356.DRStrGrid_TRADE);
    end;
  end;

  Form_SCFH2356.DRInputMaskEdit_Date.SetFocus;
  gf_ShowMessage(MessageBar, mtInformation, 1016, '');  //처리 완료

  Form_SCFH2356.HideProcessMsgBar;
  EnableForm;
  FormCreated := false;
  Close;
end;


function TDlgForm_AutoSplitAcc.InsertSplitData: boolean;

  //------------------------------------------------------------------------------
  //  TEST 수수료 구하는함수
  //------------------------------------------------------------------------------
  function gf_GetCommCalculate(TradeDate, gvDeptCode, sAccNo,
                         sBrkShtNo,  sIssueCode,
                         sTranCode,  sTradeType : String; dAmt : Double;
                         var dCommRate, dComm, dTradeTax, dAgctTax, dCapgainTax:Double):Boolean;
  begin
     result := False;
        dComm       := Trunc(dAmt*dCommRate);
        dTradeTax   := Trunc(dAmt*dCommRate*0.1);
        dAgctTax    := Trunc(dAmt*dCommRate*0.1);
        dCapgainTax := Trunc(dAmt*dCommRate*0.1);
     result := True;
  end;

var
  pTempTRADEList : pTRADEList;
  pAutoSplitItem : pAutoSplitList;
  i, j : integer;
  sOaAutoSndYN, sHwAccNo, sOutRtc : String;
  sAccno,sCTMWorkFlow,sIssueCode,sTranCode,sTranName,sTradeType,sBrkShtNo,sDpSptMtd,sSptType,sStlDate  : string;
  dCommRate, dAmt, dComm, dTradeTax, dCapgainTax, dAgctTax, dNetAmt : Double;
  dTotComm : Double; // 수수료 합계
  dGetComm, dGetTTax, dGetATax, dGetCTax, dGetNAmt, dGetCommRate : Double;
  sOut : String;
  iCnt : integer; // 분할 처리된 계좌 개수 세기
begin
  Result := false;

  if AutoSplitList.Count = 0 then
  begin
     gf_ShowMessage(MessageBar, mtInformation, 1025, ''); // 해당 자료가 존재하지 않습니다.
     Exit;
  end;

  if (sCTMWorkFlow = 'B') or (sCTMWorkFlow = 'A') then //2012-05-22
      sDpSptMtd := 'C'
   else
      sDpSptMtd := 'A';                               //평균가

  // 분할방법 구분
   sSptType := 'A';

  if gvDeptCode = gcDEPT_CODE_INT then  //국제부주식
      sOaAutoSndYN := gf_GetSystemOptionValue('HO2','N')//OASYS 자동분할및 자동전송 여부, Default N
   else
      sOaAutoSndYN := gf_GetSystemOptionValue('HO6','N');//OASYS 자동분할및 자동전송 여부, Default N

  iCnt := 0;
  dCommRate  := 0;
  dTotComm   := 0;



  for j:= 1 to DRStringGrid_Main.RowCount  do
  begin
    for i:= 0 to AutoSplitList.Count -1 do // 분할 대상..
    begin
        pAutoSplitItem := AutoSplitList.Items[i];

      if (pAutoSplitItem.sAccNo = DRStringGrid_Main.Cells[IDX_ACC_NO, j]) then
      begin
        pAutoSplitItem.sHwAccNo := DRStringGrid_Main.Cells[IDX_HW_ACC_NO, j]; // DRUserDblCodeCombo_HwAcc.Code;
        pAutoSplitItem.sHwAccId := DRStringGrid_Main.Cells[IDX_HW_ID, j];
      end;
    end;

  end;

  for i:= 0 to AutoSplitList.Count -1 do // 분할 대상.. 만큼 루프
  begin
    pAutoSplitItem := AutoSplitList.Items[i];

    for j:= 0 to TradeList.Count -1 do // 매매 정보
    begin
      pTempTRADEList := TradeList.Items[j];

      sAccNO     := pTempTRADEList.sAccNO;
      sBrkShtNo  := pTempTRADEList.sBrkShtNo;
      sIssueCode := pTempTRADEList.sIssueCode;
      sTranCode  := pTempTRADEList.sTranCode;
      sTranName  := pTempTRADEList.sTranName;
      sTradeType := pTempTRADEList.sTradeType;
      sCTMWorkFlow:= pTempTRADEList.sCTMWorkFlow;
      sStlDate   := pTempTRADEList.sStlDate;

      if (pAutoSplitItem.sAccNo = pTempTRADEList.sAccNO) and
         (pAutoSplitItem.sBrkShtNo = pTempTRADEList.sBrkShtNo) and
         (pAutoSplitItem.sIssueCode = pTempTRADEList.sIssueCode) and
         (pAutoSplitItem.sTranCode = pTempTRADEList.sTranCode) and
         (pAutoSplitItem.sTranName = pTempTRADEList.sTranName) and
         (pAutoSplitItem.sTradeType = pTempTRADEList.sTradeType) then
      begin
        Inc(iCnt);

       {  // OASYS 자동분할 사용 안함으로 인해서 주석 처리 !!!!!!!!!!!!!!!!!!! 2016-02-03 (부장님 컨펌받음)
       // OASYS 자동분할설정 상태일때... (OASYS전송 화면에서 설정)
       if (sDpSptMtd = 'O') and (sOaAutoSndYN = 'Y') then
       begin
          gf_ShowMessage(MessageBar,mtError,1046,'OASYS 자동분할 상태입니다. ' + //#13#10 +
                                                 'OASYS 전송화면에서 자동분할상태를 확인하십시오.');
          Exit;
       end;
       }
       if Copy(sTranCode,3,1) = '2' then
       begin
          gf_ShowMessage(MessageBar,mtError,1046,'단주매매 오류 - ' +// #13#10 +
                                                 '단주매매는 분할할 수 없습니다.');
          Exit;
       end;
       //부계좌분할 체크
       if (pTempTRADEList.sSptMtd <> '') or (IsSubSplit(sAccNO, sIssueCode, sTranCode, sTradeType, sBrkShtNo) <> '') then
       begin
          gf_ShowMessage(MessageBar, mtError,1046,'부계좌 분할을 취소하고 다시 분할하십시오.'); //이미 분할된 자료입니다.
          Exit;
       end;
       //대표계좌분할 체크
       if (pTempTRADEList.sDpSptMtd <> '') then
       begin
          gf_ShowMessage(MessageBar, mtError,1046,'대표계좌 분할을 취소하고 다시 분할하십시오.'); //이미 분할된 자료입니다.
          Exit;
       end;
       {
       //OASYS 분할일때 등록되지않은 계좌체크
       for iRow := 1 to DRStrGrid_SplitA.RowCount - 1 do
       begin
          if Trim(DRStrGrid_SplitA.Cells[IDX_ACC_NO, iRow]) = '' then
          begin
             gf_ShowMessage(MessageBar, mtError,1046,'등록되지않은 계좌가 있습니다.'); //등록되지않은 계좌입니다.
             Exit;
          end;
       end;
       }
       gf_BeginTransaction; //2011.10.13 2010.10에 주석처리된 것을 원상복귀. 2010년에는 왜그랬을까....

       With ADOQuery_Temp do
       begin
          //-------------------------------------------------------------------------
          // SETSPTM_TBL DELETE
          //-------------------------------------------------------------------------
          Close;
          SQL.Clear;
          SQL.Add('DELETE SETSPTM_TBL ' +
                  'WHERE TRADE_DATE = ''' + TradeDate  + '''' +
                  '  AND DEPT_CODE  = ''' + gvDeptCode + '''' +
                  '  AND ACC_NO     = ''' + sAccNO     + '''' +
                  '  AND BRK_SHT_NO = ''' + sBrkShtNo  + '''' +
                  '  AND ISSUE_CODE = ''' + sIssueCode + '''' +
                  '  AND TRAN_CODE  = ''' + sTranCode  + '''' +
                  '  AND TRADE_TYPE = ''' + sTradeType + '''');
          try
            gf_ADOExecSQL(ADOQuery_Temp);
          Except
            on E : Exception do
            begin
              gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[DELETE SETSPTC_TBL]: ' + E.Message, 0); //Database 오류
              gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[DELETE SETSPTC_TBL]');  //Database 오류
              gf_RollbackTransaction;
              Exit;
            end;
          End;
          //-------------------------------------------------------------------------
          // SETSPTC_TBL INSERT (분할임시테이블)
          //-------------------------------------------------------------------------

             sHwAccNo := pAutoSplitItem.sHwAccNo;
             Close;
             SQL.Clear;
             SQL.Add('INSERT SETSPTM_TBL ' +
                    ' (TRADE_DATE,    DEPT_CODE,     ACC_NO,       BRK_SHT_NO, ' +
                    '  ISSUE_CODE,    TRAN_CODE,     TRADE_TYPE,   DPSPLIT_MTD,' +
                    '  QTY,           HW_ACC_NO,     RMD_YN,       H_COMM_RATE,' +
    //                '  O_ACCESS_CODE, O_ACRONYM,                               ' + //2012-05-22 ctm에서는 사용안함
                    '  OPR_ID,        OPR_DATE,      OPR_TIME)                 ' +
                    'VALUES ' +
                    ' (:pTradeDate,  :pDeptCode,     :pAccNo,      :pBrkShtNo,  ' +
                    '  :pIssueCode,  :pTranCode,     :pTradeType,  :pDpSplitMtd,' +
                    '  :pQty,        :pHwAccNo,      :pRmdYn,      :pCommRate,  ' +
    //                '  :pAccessCode, :pAcronym,                                 ' + //2012-05-22 ctm에서는 사용안함
                    '  :pOprID,      :pOprDate,      :pOprTime)                 ');

             Parameters.ParamByName('pTradeDate').Value := TradeDate;
             Parameters.ParamByName('pDeptCode').Value  := gvDeptCode;
             Parameters.ParamByName('pAccNo').Value     := sAccNO;
             Parameters.ParamByName('pBrkShtNo').Value  := sBrkShtNo;
             Parameters.ParamByName('pIssueCode').Value := sIssueCode;
             Parameters.ParamByName('pTranCode').Value  := sTranCode;
             Parameters.ParamByName('pTradeType').Value := sTradeType;
             Parameters.ParamByName('pDpSplitMtd').Value:= sDpSptMtd;
             Parameters.ParamByName('pQty').Value       := pTempTRADEList.dTotQty;
             Parameters.ParamByName('pHwAccNo').Value   := sHwAccNo;
             Parameters.ParamByName('pRmdYn').Value     := ''; // 나머지 ???????????? DRStrGrid_SplitA.Cells[7,iRow];
             Parameters.ParamByName('pCommRate').Value  := pTempTRADEList.dCommRate; // 수수료율 ???????????
             {
             if gf_CurrencyToFloat(DRStrGrid_SplitA.Cells[8,iRow]) < 0 then //임시적용수수료율 없을때
                Parameters.ParamByName('pCommRate').Value  := gf_CurrencyToFloat(DRStrGrid_SplitA.Cells[6,iRow]) * 0.01
             else                                                           //임시적용수수료율 있을때
                Parameters.ParamByName('pCommRate').Value  := gf_CurrencyToFloat(DRStrGrid_SplitA.Cells[8,iRow]) * 0.01;
             }
    //         Parameters.ParamByName('pAccessCode').Value := DRStrGrid_SplitA.Cells[9, iRow];  //2012-05-22 ctm에서는 사용안함
    //         Parameters.ParamByName('pAcronym').Value    := DRStrGrid_SplitA.Cells[10, iRow]; //2012-05-22 ctm에서는 사용안함
             Parameters.ParamByName('pOprId').Value      := gvOprUsrNo;
             Parameters.ParamByName('pOprDate').Value    := gvCurDate;
             Parameters.ParamByName('pOprTime').Value    := gf_GetCurTime;
            try
             //SHOWMESSAGE(ADOQUERY_TEMP.SQL.Text);
              gf_ADOExecSQL(ADOQuery_Temp);
            Except
              on E : Exception do
              begin
                gf_ShowErrDlgMessage(Self.Tag, 9001,
                           'ADOQuery_Temp[INSERT SETSPTM_TBL]: ' + E.Message, 0); //Database 오류
                gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[INSERT SETSPTM_TBL]');  //Database 오류
                gf_RollbackTransaction;
                Exit;
              end;
            End;

        end; //end With ADOQuery_Main

       //-------------------------------------------------------------------------
       // SETSPTC_TBL UPDATE (분할임시테이블) -- 약정금액 분할
       // : CICS에서 수수료와 세금을 구하기위해서 약정금액을 미리 구해야한다. 작업두번하게 만듬..
       //-------------------------------------------------------------------------
        with ADOSP_SBP2701_AO_Bef do
        begin
          try

             Parameters.ParamByName('@in_trade_date').Value := TradeDate;
             Parameters.ParamByName('@in_dept_code').Value  := gvDeptCode;
             Parameters.ParamByName('@in_acc_no').Value     := sAccNO;
             Parameters.ParamByName('@in_brk_sht_no').Value := sBrkShtNo;
             Parameters.ParamByName('@in_issue_code').Value := sIssueCode;
             Parameters.ParamByName('@in_tran_code').Value  := sTranCode;
             Parameters.ParamByName('@in_trade_type').Value := sTradeType;

             Execute;

           except
             on E : Exception do
             begin
                gf_ShowErrDlgMessage(Self.Tag, 9002, 'ADOSP_SBP2701_AO_Bef: ' + E.Message, 0); // Stored Procedure 실행 오류
                gf_ShowMessage(MessageBar, mtError, 9002, 'ADOSP_SBP2701_AO_Bef'); // Stored Procedure 실행 오류
                gf_RollBackTransaction;
                Exit;
             end;
           end;

           sOutRtc := Trim(Parameters.ParamByName('@out_rtc').Value);
           if sOutRtc <> '' then
           begin
             gf_ShowMessage(MessageBar, mtError, 9002, 'ADOSP_SBP2701_AO_Bef: ' +    //Stored Procedure 실행 오류
                               '['+ gf_ReturnMsg(StrToInt(sOutRtc)) +'] ' + Parameters.ParamByName('@out_kor_msg').Value
                            );
             gf_RollBackTransaction;
             Exit;
           end;

           if Parameters.ParamByName('@RETURN_VALUE').Value < 0 then
           begin
             gf_ShowMessage(MessageBar, mtError, 9002, 'ADOSP_SBP2701_AO_Bef: ErrNo' + //Stored Procedure 실행 오류
                               '['+ IntToStr(Parameters.ParamByName('@RETURN_VALUE').Value) +']'
                            );
             gf_RollBackTransaction;
             Exit;
           end;

       end;  // end with ADOSP_SBP2701

       with ADOQuery_Temp do
       begin
          //-------------------------------------------------------------------------
          // SETSPTC_TBL INSERT (분할임시테이블)
          //-------------------------------------------------------------------------

             dCommRate := pTempTRADEList.dCommRate;

             //-------------------------------------------------------------------------
             // 하나대투일때 : HostGW
             // 한국증권일때 : CICS 실제 (하위계좌의 수수료계산후 SESPTM_TBL 에 업데이트)
             //-------------------------------------------------------------------------
             if gvHostCallUseYN = 'Y' then  // 하나대투
             begin
                //2010.09.29
                //자기자신에게 몰빵한 경우, 즉,
                //대표와 하위계좌가 동일하고( Z계좌와 Z제거계좌)
                //수량이 동일한 경우
                //수수료,제세금 계산을 하지 않는다. 당근 보정도 없다.
                //즉,하위의 수수료,수수료율,제세금을 대표계좌의 그것으로 대입한다.
                //SETRADE의 결제금액등은 뒤에서 처리된다. 위의 것은 임시테이블에만 작업하면 된다.
                if (sAccNo = Trim(sHwAccNo)+'Z') and
                   (pTempTRADEList.dTotQty = pTempTRADEList.dTotQty) then
                begin //자기자신몰빵 Start

                  dComm := pTempTRADEList.dComm;//
                  dCommRate   := pTempTRADEList.dCommRate;
                  dTradeTax   := pTempTRADEList.dTradeTax;
                  dAgctTax    := pTempTRADEList.dEtcTax;
                  dCapgainTax := pTempTRADEList.dCapGainTax;

                  Close;
                  SQL.Clear;
                  SQL.Add(' UPDATE  SETSPTM_TBL    ' +
                          '    SET  H_COMM_RATE  = ' + FloatToStr(dCommRate)   + ',' +
                          '         COMM         = ' + FloatToStr(dComm)       + ',' +
                          '         TRADE_TAX    = ' + FloatToStr(dTradeTax)   + ',' +
                          '         AGCT_TAX     = ' + FloatToStr(dAgctTax)    + ',' +
                          '         CAP_GAIN_TAX = ' + FloatToStr(dCapgainTax) +
                          ' WHERE	TRADE_DATE	 = ''' + TradeDate  + ''' '+
                          '   AND   DEPT_CODE	 = ''' + gvDeptCode + ''' '+
                          '   AND   ACC_NO       = ''' + sAccNo     + ''' '+
                          '   AND   HW_ACC_NO	 = ''' + sHwAccNo + ''' '+
                          '   AND   ISSUE_CODE	 = ''' + sIssueCode + ''' '+
                          '   AND   TRAN_CODE	 = ''' + sTranCode  + ''' '+
                          '   AND   TRADE_TYPE	 = ''' + sTradeType + ''' '+
                          '   AND   BRK_SHT_NO   = ''' + sBrkShtNo  + ''' ');

                  try
                     gf_ADOExecSQL(ADOQuery_Temp);
                  Except
                  on E : Exception do
                  begin
                     gf_ShowErrDlgMessage(Self.Tag, 9001,'ADOQuery_Temp[UPDATE44 SETSPTM_TBL]: ' + E.Message, 0); //Database 오류
                     gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[UPDATE44 SETSPTM_TBL]');  //Database 오류
                     gf_RollbackTransaction;
                     Exit;
                  end;
                  End;

                end //자기자신몰빵 end
                else //일반적인 경우================================================
                begin
                  // 하위계좌의 수수료계산후 SESPTM_TBL 에 업데이트
                  if not gf_GetCommnTax( ADOQuery_Temp, TradeDate, gvDeptCode, sAccNo, sHwAccNo,
                                         sIssueCode, sTranCode, sTradeType, sBrkShtNo, sStlDate, sOutRtc) then
                  begin
                     gf_ShowErrDlgMessage(Self.Tag, 0,'gf_GetCommnTax : ' + sOutRtc, 0);
                     gf_ShowMessage(MessageBar, mtError, 0, 'gf_GetCommnTax ' + sOutRtc);
                     gf_RollbackTransaction;
                     Exit;
                  end;
                end;

             end
             //-------------------------------------------------------------------------
             // 테스트일때 수수료계산
             //-------------------------------------------------------------------------
             else begin
                Close;
                SQL.Clear;
                SQL.Add(' SELECT   QTY, AMT  FROM SETSPTM_TBL ' +
                        ' WHERE	TRADE_DATE	 = ''' + TradeDate  + ''' '+
                        '   AND   DEPT_CODE	 = ''' + gvDeptCode + ''' '+
                        '   AND   ACC_NO       = ''' + sAccNo     + ''' '+
                        '   AND   HW_ACC_NO	 = ''' + sHwAccNo + ''' '+
                        '   AND   ISSUE_CODE	 = ''' + sIssueCode + ''' '+
                        '   AND   TRAN_CODE	 = ''' + sTranCode  + ''' '+
                        '   AND   TRADE_TYPE	 = ''' + sTradeType + ''' '+
                        '   AND   BRK_SHT_NO   = ''' + sBrkShtNo  + ''' ');

                try
                   gf_ADOQueryOpen(ADOQuery_Temp);
                Except
                on E : Exception do
                begin
                   gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SELECT SETSPTM_TBL]: ' + E.Message, 0); //Database 오류
                   gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SELECT SETSPTM_TBL]');  //Database 오류
                   gf_RollbackTransaction;
                   Exit;
                end;
                End;

                if RecordCount <= 0 then
                begin
                   continue;
                end;

                dAmt  := 0;
                dComm := 0;
                dCommRate   := 0.0;
                dTradeTax   := 0;
                dAgctTax    := 0;
                dCapgainTax := 0;

                dAmt := FieldByName('AMT').AsFloat;

                if dAmt <= 0 then continue;


                //수수료율에따른 수수료계산 function Call
                gf_GetCommCalculate(TradeDate, gvDeptCode, sAccNo,
                                    sBrkShtNo,  sIssueCode,
                                    sTranCode,  sTradeType, dAmt,
                                    dCommRate, //CommRate
                                    dComm, dTradeTax, dAgctTax, dCapgainTax);
                //수수료 보정
                //if (iRow = DRStrGrid_SplitA.RowCount -1) then dComm := dComm - dTotComm
                //                                         else dTotComm := dTotComm + dComm;

                Close;
                SQL.Clear;
                SQL.Add(' UPDATE  SETSPTM_TBL    ' +
                        '    SET  H_COMM_RATE  = ' + FloatToStr(dCommRate)   + ',' +
                        '         COMM         = ' + FloatToStr(dComm)       + ',' +
                        '         TRADE_TAX    = ' + FloatToStr(dTradeTax)   + ',' +
                        '         AGCT_TAX     = ' + FloatToStr(dAgctTax)    + ',' +
                        '         CAP_GAIN_TAX = ' + FloatToStr(dCapgainTax) +
                        ' WHERE	TRADE_DATE	 = ''' + TradeDate  + ''' '+
                        '   AND   DEPT_CODE	 = ''' + gvDeptCode + ''' '+
                        '   AND   ACC_NO       = ''' + sAccNo     + ''' '+
                        '   AND   HW_ACC_NO	 = ''' + sHwAccNo + ''' '+
                        '   AND   ISSUE_CODE	 = ''' + sIssueCode + ''' '+
                        '   AND   TRAN_CODE	 = ''' + sTranCode  + ''' '+
                        '   AND   TRADE_TYPE	 = ''' + sTradeType + ''' '+
                        '   AND   BRK_SHT_NO   = ''' + sBrkShtNo  + ''' ');

                try
                   gf_ADOExecSQL(ADOQuery_Temp);
                Except
                on E : Exception do
                begin
                   gf_ShowErrDlgMessage(Self.Tag, 9001,'ADOQuery_Temp[UPDATE SETSPTM_TBL]: ' + E.Message, 0); //Database 오류
                   gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[UPDATE SETSPTM_TBL]');  //Database 오류
                   gf_RollbackTransaction;
                   Exit;
                end;
                End;
               // if gvHostCallUseYN =
             end; //end For SETSPTC_TBL INSERT (분할임시테이블)


          // 하나대투증권의 세금은 세틀넷에서 자체 계산한다.
          if gvHostGWUseYN = 'Y' then
          begin
             //-------------------------------------------------------------------
             // [Y.K.J] 2013.01.29 하나대투 세금 배분 작업
             //         : 원장에서 받아오던 세금을 세틀넷에서 비율배분 처리 함.
             //-------------------------------------------------------------------
             with ADOSP_SBPTax_SettleSplit do
             begin
               try
                  Parameters.ParamByName('@in_trade_date').Value := TradeDate;
                  Parameters.ParamByName('@in_dept_code').Value  := gvDeptCode;
                  Parameters.ParamByName('@in_acc_no').Value     := sAccno;
                  Parameters.ParamByName('@in_brk_sht_no').Value := sBrkShtNo;
                  Parameters.ParamByName('@in_issue_code').Value := sIssueCode;
                  Parameters.ParamByName('@in_tran_code').Value  := sTranCode;
                  Parameters.ParamByName('@in_trade_type').Value := sTradeType;

                  Execute;
               except
               on E : Exception do
                  begin
                     gf_ShowErrDlgMessage(Self.Tag, 9002, 'ADOSP_SBPTax_SettleSplit: ' + E.Message, 0); // Stored Procedure 실행 오류
                     gf_ShowMessage(MessageBar, mtError, 9002, 'ADOSP_SBPTax_SettleSplit'); // Stored Procedure 실행 오류
                     gf_RollBackTransaction;
                     Exit;
                  end;
               end;

               sOutRtc := Trim(Parameters.ParamByName('@out_rtc').Value);
               if sOutRtc <> '' then
               begin
                  gf_ShowMessage(MessageBar, mtError, 9002, 'ADOSP_SBPTax_SettleSplit: ' +    //Stored Procedure 실행 오류
                                    '['+ gf_ReturnMsg(StrToInt(sOutRtc)) +'] ' + Parameters.ParamByName('@out_kor_msg').Value
                                 );
                  gf_RollBackTransaction;
                  Exit;
               end;
             end; // with ADOSP_SBPTax_SettleSplit do
          end; // if gvHostGWUseYN = 'Y' then

       end; // with ADOQuery_Temp do

       //-------------------------------------------------------------------------
       // 분할시작 인제 정말 분할 (spCall)
       //  SETRADE_TBL, SESPEXE_TBL, SETRADE_HIS, SESPEXE_HIS 지지고볶고 분할입력
       //-------------------------------------------------------------------------
       with ADOSP_SBP2701_AO do
       begin
          try
             Parameters.ParamByName('@in_trade_date').Value := TradeDate;
             Parameters.ParamByName('@in_dept_code').Value  := gvDeptCode;
             Parameters.ParamByName('@in_acc_no').Value     := sAccNO;
             Parameters.ParamByName('@in_brk_sht_no').Value := sBrkShtNo;
             Parameters.ParamByName('@in_issue_code').Value := sIssueCode;
             Parameters.ParamByName('@in_tran_code').Value  := sTranCode;
             Parameters.ParamByName('@in_trade_type').Value := sTradeType;
             Parameters.ParamByName('@in_dpsplit_Mtd').Value:= sDpSptMtd;
             Parameters.ParamByName('@in_split_type').Value := sSptType;
             Parameters.ParamByName('@in_opr_id').Value     := Trim(gvOprUsrNo);
             Parameters.ParamByName('@in_imp_cnt').Value    := '';
             Execute;
          except
          on E : Exception do
             begin
                gf_ShowErrDlgMessage(Self.Tag, 9002, 'ADOSP_SBP2701: ' + E.Message, 0); // Stored Procedure 실행 오류
                gf_ShowMessage(MessageBar, mtError, 9002, 'ADOSP_SBP2701'); // Stored Procedure 실행 오류
                gf_RollBackTransaction;
                Exit;
             end;
          end;

          sOutRtc := Trim(Parameters.ParamByName('@out_rtc').Value);
          if sOutRtc <> '' then
          begin
             gf_ShowMessage(MessageBar, mtError, 9002, 'ADOSP_SBP2701: ' +    //Stored Procedure 실행 오류
                               '['+ gf_ReturnMsg(StrToInt(sOutRtc)) +'] ' + Parameters.ParamByName('@out_kor_msg').Value
                            );
             gf_RollBackTransaction;
             Exit;
          end;

          if Parameters.ParamByName('@RETURN_VALUE').Value < 0 then
          begin
             gf_ShowMessage(MessageBar, mtError, 9002, 'ADOSP_SBP2701: ErrNo' + //Stored Procedure 실행 오류
                               '['+ IntToStr(Parameters.ParamByName('@RETURN_VALUE').Value) +']'
                            );
             gf_RollBackTransaction;
             Exit;
          end;

          //-------------------------------------------------------------------------
          // 하나대투일때 : HostGW
          // 한국증권일때 : CICS 실제 (대표계좌에게도 수수료보정이 필요)
          //-------------------------------------------------------------------------
          if gvHostCallUseYN = 'Y' then
          begin

             dGetComm := 0;
             dGetTTax := 0;
             dGetATax := 0;
             dGetCTax := 0;
             dGetNAmt := 0;
             dGetCommRate := 0;

             if not gf_GetCommnTax2(TradeDate,sBrkShtNo, sIssueCode, sTranCode, sTradeType, sAccNo, sStlDate, 0, 0, 0,
                                    dGetComm, dGetTTax, dGetATax, dGetCTax, dGetNAmt, dGetCommRate, sOut) then
             begin
                gf_ShowErrDlgMessage(Self.Tag, 0,'대표계좌 gf_GetCommnTax2 Error ' + sOut, 0);
                gf_ShowMessage(MessageBar, mtError, 0, '대표계좌 gf_GetCommnTax2 Error ' + sOut);
                gf_RollbackTransaction;
                Exit;
             end;

             if (dGetComm <> 0) or
                (dGetTTax <> 0) or
                (dGetATax <> 0) or
                (dGetCTax <> 0) then
             begin
                gf_ShowErrDlgMessage(Self.Tag, 0,'gf_GetCommnTax2 Error : 0이 아닌값을 Return Error', 0);
                gf_ShowMessage(MessageBar, mtError, 0, 'gf_GetCommnTax2 Error : 0이 아닌값을 Return Error');
                gf_RollbackTransaction;
                Exit;
             end;
          end;
          //---------------------------------------

       end;  // end with ADOSP_SBP2701    

      end else
      begin
        if (iCnt > 0) and (iCnt = AutoSplitList.Count) then break;
      end;

    end; // 매매 정보 list
  end; // for i:= 0 to AutoSplitList.Count -1 do // 분할 대상.. 만큼 루프
  gf_CommitTransaction;
  Result := true;

end;

function TDlgForm_AutoSplitAcc.IsSubSplit(pAccNo, pIssueCode, pTranCode,
  pTradeType, pBrkShtNo: String): String;
var
   sQuery : String;
begin
   result := '';

   sQuery := 'SELECT STR = (SPLIT_MTD) FROM SETRADE_TBL '
            +' WHERE ACC_NO       = ''' + pAccNo + ''''
            +'   AND DEPT_CODE    = ''' + gvDeptCode + ''''
            +'   AND TRADE_DATE   = ''' + TradeDate  + ''''
            +'   AND ISSUE_CODE   = ''' + pIssueCode + ''''
            +'   AND TRAN_CODE    = ''' + pTranCode  + ''''
            +'   AND TRADE_TYPE   = ''' + pTradeType + ''''
            +'   AND BRK_SHT_NO   = ''' + pBrkShtNo  + '''';

   result := gf_ReturnStrQuery(sQuery);

end;


function TDlgForm_AutoSplitAcc.MakeTradeDataList: Boolean;
var
   pTempTradeLIst : pTradeLIst;
   sFilter1, sFilter2, sFilter3 : String;
   sTradeName : String;
begin
  Result := False;

   //기존자료 Clear
   RemoveMemoryTRADE;
   //gf_ClearMessage(MessageBar);

   sFilter1 := '';
   sFilter2 := '';
   if Form_SCFH2356.DRUserCodeCombo_AccGroup.Code <> '' then
   begin
      // 계좌그룹
      with ADOQuery_Temp do
      begin
         Close;
         SQL.Clear;
         SQL.Add('SELECT ACC_NO FROM SUAGPAC_TBL '+
                 ' WHERE DEPT_CODE =  ''' + gvDeptCode + '''' +
                 '   AND SEC_TYPE  =  ''' + gcSEC_EQUITY + ''' '+
                 '   AND GRP_NAME  =  ''' + Form_SCFH2356.DRUserCodeCombo_AccGroup.Code + '''');

         try
            gf_ADOQueryOpen(ADOQuery_Temp);
         except
            on E : Exception do
            begin
               gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SELECT SUAGPAC_TBL]: ' + E.Message, 0);  //Database 오류
               gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SELECT SUAGPAC_TBL]'); //Database 오류
               Result := False;
               Exit;
            end;
         end;

         if RecordCount <> 0 then
         begin
            While not EOF do
            begin
               if sFilter1 <> '' then
                  sFilter1 := sFilter1 + ' OR ';
               sFilter1 := sFilter1 + '( B.ACC_NO = ''' + Trim(FieldByName('ACC_NO').AsString) + ''')';
               if sFilter2 <> '' then
                  sFilter2 := sFilter2 + ' OR ';
               sFilter2 := sFilter2 + '( I.ACC_NO = ''' + Trim(FieldByName('ACC_NO').AsString) + ''')';
               Next;
            end;
         end;

      end; // with ADOQuery_Temp
   end;  // DRUserCodeCombo_AccGroup

   if Form_SCFH2356.DRUserCodeCombo_Client.Code <> '' then
   begin
      // Client
      if (sFilter1 <> '') or (sFilter2 <> '') then sFilter3 := ' OR ';
      sFilter3 := ' ( CLIENT = ''' + Form_SCFH2356.DRUserCodeCombo_Client.Code + ''')';
   end;

   if sFilter1 <> '' then sFilter1 := 'AND ( ' + sFilter1 + sFilter3 + ' )';
   if sFilter2 <> '' then sFilter2 := 'AND ( ' + sFilter2 + sFilter3 + ' )';

   With ADOQuery_Main do
   begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT A.DEPT_CODE,      A.TRADE_DATE,              ');
      SQL.Add('       A.ACC_NO,         A.ISSUE_CODE,              ');
      SQL.Add('       A.TRAN_CODE,      A.TRADE_TYPE,              ');
      SQL.Add('       B.CTM_WORKFLOW,   A.STL_DATE,  A.COMM_RATE,  ');
      SQL.Add('       B.IDENTIFICATION, C.ISSUE_NAME_KOR,          ');
      SQL.Add('       B.ACC_NAME_KOR,   A.DPSPLIT_MTD,             ');
      SQL.Add('       BRK_SHT_NO = ISNULL(A.BRK_SHT_NO, '' ''),    ');
      SQL.Add('       A.SPLIT_MTD,      A.TOT_ORD_QTY,             ');
      SQL.Add('       A.TOT_EXEC_QTY,   A.TOT_EXEC_AMT,            ');
      SQL.Add('       A.AVR_EXEC_PRICE, A.NET_AMT,                 ');
      SQL.Add('       A.COMM,           A.TRADE_TAX,               ');
      SQL.Add('       A.AGCT_TAX,       A.CAP_GAIN_TAX,            ');

      if (gf_GetSystemOptionValue('HXX','H') = 'D') then //하나대투
      begin
        SQL.Add('       TRAN_NAME = A.TRAN_CODE                      ');
      end else
      begin
        SQL.Add('       TRAN_NAME = (SELECT TRAN_NAME_KOR            ');
        SQL.Add('                      FROM SUTRNCD_TBL              ');
        SQL.Add('                     WHERE TRAN_CODE = A.TRAN_CODE) ');
      end;
      
      SQL.Add(' FROM SETRADE_TBL A, SEACBIF_TBL B, SCISSIF_TBL C   ');
      SQL.Add('   WHERE B.DEPT_CODE  = ''' + gvDeptCode + '''      ');
      SQL.Add('     AND B.ACC_NO     = A.ACC_NO                    ');
      SQL.Add('     AND ISNULL(A.SUB_ACC_NO, '''') = ''''          ');
      SQL.Add('     AND B.DEPT_CODE  = A.DEPT_CODE                 ');
      SQL.Add('     AND B.DP_ACC_YN  = ''Y''                       ');
      SQL.Add('     AND A.TRADE_DATE = ''' + TradeDate + '''       ');
      SQL.Add('     AND A.ISSUE_CODE = C.ISSUE_CODE                ');
      SQL.Add('     AND ((A.TOT_EXEC_QTY > 0) AND (ISNULL(A.DPSPLIT_ACC_TYPE,'''') = '''')) ');
      SQL.Add('     AND EXISTS (SELECT 1 FROM SEHWACC_TBL                ');
      SQL.Add('                  WHERE DEPT_CODE = ''' + gvDeptCode + '''');
      SQL.Add('                    AND ACC_NO    = A.ACC_NO)             ');
      SQL.Add(' '+        sFilter1 +'                                ');
      SQL.Add('UNION                                                 ');
      SQL.Add('SELECT H.DEPT_CODE,    H.TRADE_DATE,                  ');
      SQL.Add('       H.F_ACC_NO,     H.ISSUE_CODE,                  ');
      SQL.Add('       H.TRAN_CODE,    H.TRADE_TYPE,                  ');
      SQL.Add('       MAX(I.CTM_WORKFLOW)  AS CTM_WORKFLOW,          ');
      SQL.Add('       MAX(E.STL_DATE) AS STL_DATE, max(E.COMM_RATE) as COMM_RATE, ');
      SQL.Add('       MAX(I.IDENTIFICATION) AS IDENTIFICATION,       ');
      SQL.Add('       MAX(J.ISSUE_NAME_KOR) AS ISSUE_NAME_KOR,       ');
      SQL.Add('       MAX(I.ACC_NAME_KOR) AS ACC_NAME_KOR,           ');
      SQL.Add('       MAX(E.DPSPLIT_MTD) AS DPSPLIT_MTD,             ');
      SQL.Add('       BRK_SHT_NO = ISNULL(H.F_BRK_SHT_NO, '' ''),    ');
      SQL.Add('       MAX(E.SPLIT_MTD) AS SPLIT_MTD,                 ');
      SQL.Add('       MAX(H.FB_TOT_ORD_QTY) AS TOT_ORD_QTY,          ');
      SQL.Add('       MAX(H.FB_TOT_EXEC_QTY) AS TOT_EXEC_QTY,        ');
      SQL.Add('       MAX(H.FB_TOT_EXEC_AMT) AS TOT_EXEC_AMT,        ');
      SQL.Add('       MAX(H.FB_AVR_EXEC_PRICE) AS AVR_EXEC_PRICE,    ');
      SQL.Add('       MAX(H.FB_NET_AMT) AS NET_AMT,                  ');
      SQL.Add('       MAX(H.FB_COMM) AS COMM,                        ');
      SQL.Add('       MAX(H.FB_TRADE_TAX) AS TRADE_TAX,              ');
      SQL.Add('       MAX(H.FB_AGCT_TAX) AS AGCT_TAX,                ');
      SQL.Add('       MAX(H.FB_CAP_GAIN_TAX) AS CAP_GAIN_TAX,        ');

      if (gf_GetSystemOptionValue('HXX','H') = 'D') then //하나대투
      begin
        SQL.Add('       TRAN_NAME = H.TRAN_CODE                                             ');
      end else
      begin
        SQL.Add('       TRAN_NAME = (SELECT TRAN_NAME_KOR                                   ');
        SQL.Add('                      FROM SUTRNCD_TBL                                     ');
        SQL.Add('                     WHERE TRAN_CODE = MIN(H.TRAN_CODE))                   ');
      end;
      SQL.Add('FROM SETRADE_HIS H, SETRADE_TBL E, SEACBIF_TBL I, SCISSIF_TBL J            ');
      SQL.Add('WHERE I.DEPT_CODE  = ''' + gvDeptCode + '''                                ');
      SQL.Add('  AND I.ACC_NO     = H.F_ACC_NO                                            ');
      SQL.Add('  AND I.DEPT_CODE  = H.DEPT_CODE                                           ');
      SQL.Add('  AND I.DP_ACC_YN  = ''Y''                                                 ');
      SQL.Add('  AND H.TRADE_DATE = ''' + TradeDate + '''                                 ');
      SQL.Add('  AND H.ISSUE_CODE = J.ISSUE_CODE                                          ');
      SQL.Add('  AND ISNULL(H.HIS_DEL_YN, '''')  <> ''Y''                                 ');
      SQL.Add('  AND H.HIS_TYPE   = ''' + HIS_TYPE_DP_SPLIT + '''                         ');
      SQL.Add('  AND E.DEPT_CODE  = H.DEPT_CODE                                           ');
      SQL.Add('  AND E.TRADE_DATE = H.TRADE_DATE                                          ');
      SQL.Add('  AND E.ACC_NO     = H.F_ACC_NO                                            ');
      SQL.Add('  AND E.BRK_SHT_NO = H.F_BRK_SHT_NO                                        ');
      SQL.Add('  AND ISNULL(E.SUB_ACC_NO, '''') = ''''                                    ');
      SQL.Add('  AND E.ISSUE_CODE = H.ISSUE_CODE                                          ');
      SQL.Add('  AND E.TRADE_TYPE = H.TRADE_TYPE                                          ');
      SQL.Add('  AND E.TRAN_CODE  = H.TRAN_CODE                                           ');
      SQL.Add('  AND ((E.TOT_EXEC_QTY = 0) OR (ISNULL(E.DPSPLIT_ACC_TYPE,'''') = ''' + ACC_TYPE_DP + ''')) ');  //대표계좌 내역 'F'
      SQL.Add('  AND EXISTS (SELECT 1 FROM SEHWACC_TBL                                    ');
      SQL.Add('               WHERE DEPT_CODE = ''' + gvDeptCode + '''                    ');
      SQL.Add('                 AND ACC_NO    = I.ACC_NO)                                 ');
      SQL.Add(' '+        sFilter2 +'                                                     ');
      SQL.Add('  GROUP BY H.DEPT_CODE, H.TRADE_DATE, H.F_ACC_NO, H.ISSUE_CODE,            ');
      SQL.Add('           H.TRAN_CODE, H.TRADE_TYPE, H.F_BRK_SHT_NO                       ');
      SQL.Add(' ORDER BY B.IDENTIFICATION, A.ACC_NO, A.BRK_SHT_NO ');//, B.ACC_NAME_KOR, C.ISSUE_NAME_KOR, A.TRADE_TYPE ');
//SQL.SaveToFile('c:\SCFH2356_MakeTradeDataList().sql');
      try
         gf_ADOQueryOpen(ADOQuery_Main);
      except
         on E : Exception do
         begin
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Main[SELECT SETRADE_TBL]: ' + E.Message, 0);  //Database 오류
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Main[SELECT SETRADE_TBL]'); //Database 오류
            Result := False;
            Exit;
         end;
      end;

      if RecordCount <= 0 then
      begin
         Result := True;
         Exit;
      end;

      while not EOF do
      begin
         //--------------------------------------------------------------------
         // TRADE List Save
         //--------------------------------------------------------------------
         New(pTempTradeLIst);
         TradeList.Add(pTempTradeLIst);

         pTempTradeLIst.sTradeDate := TradeDate;
         pTempTradeLIst.sStlDate   := Trim(FieldByName('STL_DATE').AsString);
         pTempTradeLIst.sAccNO     := Trim(FieldByName('ACC_NO').asString);
         pTempTradeLIst.sAccName   := Trim(FieldByName('ACC_NAME_KOR').asString);
         pTempTradeLIst.sCTMWorkFlow:= Trim(FieldByName('CTM_WORKFLOW').AsString);
         pTempTradeLIst.sIssueCode := Trim(FieldByName('ISSUE_CODE').asString);
         pTempTradeLIst.sIssueName := Trim(FieldByName('ISSUE_NAME_KOR').asString);
         pTempTradeLIst.sTranCode  := Trim(FieldByName('TRAN_CODE').asString);
         pTempTradeLIst.sBrkShtNo  := Trim(FieldByName('BRK_SHT_NO').AsString);
         pTempTradeLIst.sTranName  := Trim(FieldByName('TRAN_NAME').asString);
         pTempTradeLIst.sIdent     := Trim(FieldByName('IDENTIFICATION').asString);
         pTempTradeLIst.dAvrExecPri:= FieldByName('AVR_EXEC_PRICE').asFloat;
         pTempTradeLIst.sTradeType := Trim(FieldByName('TRADE_TYPE').asString);

         sTradeName := gf_SellBuyCodeToName(pTempTradeLIst.sTradeType);
         if Copy(pTempTradeList.sTranCode, 3,1) = '4' then // 프로그램매매일때,
         sTradeName := sTradeName + 'P';

         pTempTradeLIst.sTrTypeName:= sTradeName;

         pTempTradeLIst.dOrdQty    := FieldByName('TOT_ORD_QTY').AsFloat;
         pTempTradeLIst.dTotQty    := FieldByName('TOT_EXEC_QTY').asFloat;
         pTempTradeLIst.dTotExecAmt:= FieldByName('TOT_EXEC_AMT').asFloat;
         pTempTradeLIst.dComm      := FieldByName('COMM').asFloat;
         pTempTradeLIst.dTradeTax  := FieldByName('TRADE_TAX').asFloat;
         pTempTradeLIst.dCapGainTax:= FieldByName('CAP_GAIN_TAX').asFloat;
         pTempTradeLIst.dNetAmt    := FieldByName('NET_AMT').asFloat;
         pTempTradeLIst.dEtcTax    := FieldByName('AGCT_TAX').asFloat;
         pTempTradeLIst.sDpSptMtd  := Trim(FieldByName('DPSPLIT_MTD').asString);
         pTempTradeLIst.sSptMtd    := Trim(FieldByName('SPLIT_MTD').AsString);
         //20100928
         pTempTradeLIst.dCommRate  := FieldByName('COMM_RATE').AsFloat;
         Next;
      end;
   End; //end ADOQueyr_Main

   Result := True;
end;

procedure TDlgForm_AutoSplitAcc.RemoveMemoryTRADE;
var
  pTempTradeList : pTradeList;
  I  : Integer;
begin
   if not Assigned(tradeList) then Exit;

   for I := 0 to TradeList.Count -1 do
   begin
      pTempTradeList := TradeList[I];
      Dispose(pTempTradeList);
   end;
   TradeList.Clear;
end;

procedure TDlgForm_AutoSplitAcc.DisplayTradeGridData;
var
   pTempTradeList : pTradeList;
   sTempAccNo, sTempShtNo : string;
   iIndex, iRow, iCol : integer;
   bChangeFlag, bChangeShtNo : boolean;
   sTradeName : String;
begin
   With Form_SCFH2356.DRStrGrid_TRADE do
   begin
     RowCount := 2;
     Rows[1].Clear;
     Cells[0, 0] := '';
  //   DRStrGrid_TRADE.HintCell[IssueCodeColIdx,1] := '';
  //   DRStrGrid_TRADE.HintCell[SptMtdColIdx,1]:= '';
     HintCell[IDX_TR_ISSUE_NAME, 1] := '';
     HintCell[IDX_TR_TRADE_TYPE, 1] := '';
     HintCell[IDX_TR_SPLIT_TYPE, 1] := '';

     if TradeList.Count = 0 then
     begin
        gf_ShowMessage(MessageBar, mtInformation, 1025, ''); // 해당 자료가 존재하지 않습니다.
        Exit;
     end;

     sTempAccNo := '';
     sTempShtNo := '';
     sTradeName := '';
     iRow := 1;

     for iIndex := 0 to TradeList.Count -1 do
     begin
        pTempTradeList := TradeList[iIndex];


         RowCount := iRow + 1;

         // ColorRow[iRow] := gcSubGridSelectColor;
{
         if pTempTradeLIst.sDpSptMtd = 'O' then   //하위계좌 OASYS분할 'O'
            RowFont[iRow].Color := gcManualColor
         else
}
         RowFont[iRow].Color := clBlack;

         //계좌번호
         bChangeFlag  := False;
         if sTempAccNo <> pTempTradeLIst.sAccNO then
         begin
            sTempAccNo  := pTempTradeLIst.sAccNO;
            bChangeFlag := True;
         end;
         //주문지번호
{
         bChangeShtNo := False;
         if sTempShtNo <> pTempTradeLIst.sBrkShtNo then
         begin
            sTempShtNo    := pTempTradeLIst.sBrkShtNo;
            bChangeShtNo  := True;
         end;
}
         //Colum 1
         iCol := 0;
         Cells[iCol,iRow] := '';
         Inc(iCol,1);

         //Colum 2
         Cells[iCol,iRow] := '';
         Inc(iCol,1);

         //ID
         if bChangeFlag then
            Cells[iCol,iRow] := pTempTradeLIst.sIdent
         else
            Cells[iCol,iRow] := '';
         Inc(iCol,1);

         //계좌번호
         if bChangeFlag then
            Cells[iCol,iRow] := pTempTradeLIst.sAccNO
         else
            Cells[iCol,iRow] := '';
         Inc(iCol,1);

         //계좌명
         if bChangeFlag then
         begin
            Cells[iCol,iRow] := pTempTradeLIst.sAccName;
            if pTempTradeLIst.sCTMWorkFlow = 'B' then
            begin
              CellFont[iCol,iRow].Color := clBlue;
              SelectedFontColorCell[iCol,iRow] := clBlue;
            end
            else
            if pTempTradeLIst.sCTMWorkFlow = 'A' then
            begin
              CellFont[iCol,iRow].Color := clRed;
              SelectedFontColorCell[iCol,iRow] := clRed;
            end
            else
            begin
              CellFont[iCol,iRow].Color := clBlack;
              SelectedFontColorCell[iCol,iRow] := clBlack;
            end;
         end
         else
            Cells[iCol,iRow] := '';
         Inc(iCol,1);

         //주문지No
         Cells[iCol,iRow] := pTempTradeLIst.sBrkShtNo;
{
         if (bChangeFlag or bChangeShtNo) then
            Cells[iCol,iRow] := pTempTradeLIst.sBrkShtNo
         else
            Cells[iCol,iRow] := '';
}
         Inc(iCol,1);

         //종목코드
         Cells[iCol,iRow] := pTempTradeLIst.sIssueCode;
         Inc(iCol,1);

         //종목명
         if bDaeTooCheck then //하나대투
           HintCell[iCol,iRow] := pTempTradeLIst.sIssueCode
         else
           HintCell[iCol,iRow] := '';

         Cells[iCol,iRow] := pTempTradeLIst.sIssueName;
         Inc(iCol,1);

         //거래구분
         if pTempTradeLIst.sTranName <> '' then
            Cells[iCol,iRow] := pTempTradeLIst.sTranName
         else
            Cells[iCol,iRow] := pTempTradeLIst.sTranCode;
         Inc(iCol,1);

         //매매구분  //거래구분 Hint
         sTradeName := gf_SellBuyCodeToName(pTempTradeLIst.sTradeType);
         if bDaeTooCheck then  // 하나대투
         begin
            if Copy(pTempTradeList.sTranCode, 3,1) = '4' then // 프로그램매매일때,
            sTradeName := sTradeName + 'P';
         end;

         Cells[iCol,iRow] := sTradeName;
         if pTempTradeLIst.sTranName <> '' then
            HintCell[iCol,iRow] := pTempTradeLIst.sTranName
         else
            HintCell[iCol,iRow] := pTempTradeLIst.sTranCode;
         Inc(iCol,1);

         //평균단가
         Cells[iCol,iRow] := FormatFloat('#,###,##0.00',pTempTradeLIst.dAvrExecPri);
         Inc(iCol,1);

         //수량
         Cells[iCol,iRow] := FormatFloat('#,###,##0',pTempTradeLIst.dTotQty);
         Inc(iCol,1);

         //약정금액
         Cells[iCol,iRow] := FormatFloat('#,###,###,##0',pTempTradeLIst.dTotExecAmt);
         Inc(iCol,1);
{
         //분할방법
         if pTempTradeLIst.sDpSptMtd = 'A' then
         begin
            HintCell[iCol,iRow] := '평균가';
         end else
         if pTempTradeLIst.sDpSptMtd = 'O' then
         begin
            HintCell[iCol,iRow] := 'CTM 평균가';
         end else
         if pTempTradeLIst.sDpSptMtd = 'I' then
         begin
            HintCell[iCol,iRow] := '평균가입력';
         end else
         if pTempTradeLIst.sDpSptMtd = 'C' then
         begin
            HintCell[iCol,iRow] := 'CTM 평균가입력';
         end else
         begin
            HintCell[iCol,iRow] := '';
         end;
}
         //분할방법
         if pTempTradeLIst.sDpSptMtd = 'A' then
         begin
            HintCell[iCol,iRow] := '평균가';
         end else
         if pTempTradeLIst.sDpSptMtd = 'O' then
         begin
            HintCell[iCol,iRow] := 'OASYS';
         end else
         if pTempTradeLIst.sDpSptMtd = 'I' then
         begin
            HintCell[iCol,iRow] := '평균가입력';
         end else
         if pTempTradeLIst.sDpSptMtd = 'C' then
         begin
            HintCell[iCol,iRow] := 'CTM 평균가';
         end else
         if pTempTradeLIst.sDpSptMtd = 'T' then
         begin
            HintCell[iCol,iRow] := 'CTM 평균가입력';
         end else
         begin
            HintCell[iCol,iRow] := '';
         end;
         Cells[iCol,iRow] := pTempTradeLIst.sDpSptMtd;
      

        Inc(iRow,1);
     End; //end For
   end; //end With DRStrGrid_TRADE
   //gf_ShowMessage(MessageBar, mtInformation, 1021, gwQueryCnt + IntToStr(iRow)) // 조회 완료

end;

procedure TDlgForm_AutoSplitAcc.RemoveMemoryHWAccList;
var
  HwAccListItem : pHWAccList;
  i : Integer;
begin
  if not Assigned(HwAccList) then Exit;

  for i:= 0 to HwAccList.Count -1 do
  begin
    HwAccListItem := HwAccList[i];
    Dispose(HwAccListItem);
  end;
  HwAccList.Clear;
end;

procedure TDlgForm_AutoSplitAcc.DisplayGridData_HwAcc;
var
  I, j, iRow : Integer;
  HwAccItem : pHWAccList;
  Combo : TComboBox;
  sAccNo : string;
begin
  iRow := 1;
  sAccNo := '';
  //DRUserDblCodeCombo_HwAcc.ClearItems;

  with DRStringGrid_HwAcc do
  begin
    RowCount := HwAccList.Count +1;

    for i:= 0 to HwAccList.Count -1 do //
    begin
      HwAccItem := HwAccList.Items[i];
      Rows[iRow].clear;

      ColorRow[iRow] := gcSubGridSelectColor;
      RowFont[iRow].Color := clBlack;

      Cells[IDX_HW_ID_R, iRow] := HwAccItem.sHwAccId;
      Cells[IDX_HW_ACC_NO_R, iRow] := HwAccItem.sHwAccNo;
      Cells[IDX_HW_COMM_RATE, iRow] := FormatFloat('#,###,##0.000', HwAccItem.dCommRate);


      Inc(iRow);

    end;
  end;
end;

procedure TDlgForm_AutoSplitAcc.DRStringGrid_MainSelectCell(
  Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  iACol := ACol;
  iARow := ARow;  

end;

procedure TDlgForm_AutoSplitAcc.DRStringGrid_HwAccSelectCell(
  Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  iHwACol := ACol;
  iHwARow := ARow;
                                                                      
end;

procedure TDlgForm_AutoSplitAcc.DRStringGrid_HwAccDblClick(
  Sender: TObject);
begin
  inherited;
  with DRStringGrid_Main do
  begin
    Cells[IDX_HW_ID, iARow] := DRStringGrid_HwAcc.Cells[IDX_ACC_ID, iHwARow];
    Cells[IDX_HW_ACC_NO, iARow] := DRStringGrid_HwAcc.Cells[IDX_ACC_NO, iHwARow];
  end;
end;

procedure TDlgForm_AutoSplitAcc.DRStringGrid_MainClick(Sender: TObject);
begin
  inherited;
  
  if not QueryToList then
  begin
     FormCreated := false;
     Close;
     Exit;
  end;

  DRStringGrid_HwAcc.RowCount := 2;
  DRStringGrid_HwAcc.Rows[1].Clear;

  DisplayGridData_HwAcc;
end;

end.

