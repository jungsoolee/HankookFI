unit SCCFEAccMove;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCCDlgForm, DRDialogs, StdCtrls, Buttons, DRAdditional, ExtCtrls,
  DRStandard, DRSpecial, DRCodeControl, Db, ADODB, SCCGlobalType, 
  Mask ;

type
  TForm_SCCFEAccMove = class(TForm_Dlg)
    DRPanel1: TDRPanel;
    DRLabel1: TDRLabel;
    DRLabel2: TDRLabel;
    DRUserDblCodeCombo_ToAccNo: TDRUserDblCodeCombo;
    DRUserDblCodeCombo_FromAccNo: TDRUserDblCodeCombo;
    ADOQuery_Temp: TADOQuery;
    ADOQuery1: TADOQuery;
    ADOQuery2: TADOQuery;
    ADOQuery_Trade: TADOQuery;
    DRLabel3: TDRLabel;
    DRMaskEdit_TradeDate: TDRMaskEdit;
    DRCheckBox1: TDRCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function  InitializeData: boolean;
    procedure FormCreate(Sender: TObject);
    procedure DRBitBtn2Click(Sender: TObject);
    procedure ClearTradeList;
    procedure DRMaskEdit_TradeDateKeyPress(Sender: TObject; var Key: Char);
    procedure DRUserDblCodeCombo_ToAccNoEditKeyPress(Sender: TObject;
      var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_SCCFEAccMove : TForm_SCCFEAccMove;
implementation

{$R *.DFM}
uses
   SCCLib;

type
   //=== SFETRAD_TBL 정보
   TTradeList = record
      TradeDate    : string;
      DeptCode     : string;
      AccNo        : string;
      SubAccNo     : string;
      IssueCode    : string;
      TranCode     : string;
      TradeType    : string;
      TotExecQty   : double;
      AvrExecPrice : double;
      TotExecAmt   : double;
      NetAmt       : double;
      Comm         : double;
      TradeTax     : double;
      AgctTax      : double;
      CapGainTax   : double;
   end;
   pTTradeList = ^TTradeList;

   //=== SFESPEX_TBL 정보
   TTradeExecList = record
      TradeDate    : string;
      DeptCode     : string;
      AccNo        : string;
      SubAccNo     : string;
      IssueCode    : string;
      TranCode     : string;
      TradeType    : string;
      ExecQty   : double;
      ExecPrice : double;
      ExecAmt   : double;
   end;
   pTTradeExecList = ^TTradeExecList;

   //=== SFORDTD_TBL 정보
   TOrdList = record
      TradeDate    : string;
      DeptCode     : string;
      AccNo        : string;
      SubAccNo     : string;
      IssueCode    : string;
      TranCode     : string;
      TradeType    : string;
      OrdNo        : String;
      TotExecQty   : double;
      TotExecAmt   : double;
   end;
   pTOrdList = ^TOrdList;

   //=== SFESPEX_TBL 정보
   TOrdExecList = record
      TradeDate    : string;
      DeptCode     : string;
      AccNo        : string;
      SubAccNo     : string;
      IssueCode    : string;
      TranCode     : string;
      TradeType    : string;
      ExecPrice    : double;
      OrdNo        : String;
      ExecQty      : double;
      ExecAmt      : double;
   end;
   pTOrdExecList = ^TOrdExecList;

var
   TradeList     : TList;        // Trade 내역 List
   TradeExecList : TList;        // Spexe 내역 List
   OrdList       : TList;        // Ord 내역 List
   OrdExecList   : TList;        // Ordpexe 내역 List

procedure TForm_SCCFEAccMove.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if (Assigned(TradeList)) or (Assigned(TradeExecList)) or (Assigned(OrdList)) or (Assigned(OrdExecList))then  // TradeList Free
  begin
   ClearTradeList;
   TradeList.Free;
   TradeExecList.Free;
   OrdList.Free;
   OrdExecList.Free;
  end;

  Action := caFree;
end;

//------------------------------------------------------------------------------
//  TradeList Clear
//------------------------------------------------------------------------------
procedure TForm_SCCFEAccMove.ClearTradeList;
var
   TradeItem : pTTradeList;
   TradeExecItem : pTTradeExecList;
   OrdItem       : pTOrdList;
   OrdExecItem   : pTOrdExecList;
   I : Integer;
begin
   if not Assigned(TradeList) then Exit;
   for I := 0 to TradeList.Count -1 do
   begin
      TradeItem := TradeList.Items[I];
      Dispose(TradeItem);
   end;
   TradeList.Clear;

   if not Assigned(TradeExecList) then Exit;
   for I := 0 to TradeExecList.Count -1 do
   begin
      TradeExecItem := TradeExecList.Items[I];
      Dispose(TradeExecItem);
   end;
   TradeExecList.Clear;

   if not Assigned(OrdList) then Exit;
   for I := 0 to OrdList.Count -1 do
   begin
      OrdItem := OrdList.Items[I];
      Dispose(OrdItem);
   end;
   OrdList.Clear;

   if not Assigned(OrdExecList) then Exit;
   for I := 0 to OrdExecList.Count -1 do
   begin
      OrdExecItem := OrdExecList.Items[I];
      Dispose(OrdExecItem);
   end;
   OrdExecList.Clear;

end;

//------------------------------------------------------------------------------
//  데이터 초기화
//------------------------------------------------------------------------------
function TForm_SCCFEAccMove.InitializeData: boolean;
begin
   Result := False;
   with ADOQuery_Temp do
   begin
      //=== 계좌번호
      Close;
      SQL.Clear;
      SQL.Add(' Select ACC_NO, ACC_NAME_KOR                       '
            + ' From SFACBIF_TBL                                  '
            + ' Where DEPT_CODE = ''' + gvDeptCode + '''          '
//            + '   AND ((ACC_ATTR  = ''3'') OR (ACC_ATTR = ''4'')) '
            );
      Try
         gf_ADOQueryOpen(ADOQuery_Temp);
      Except
         on E : Exception do
         begin  // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SFACBIF_TBL]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SFACBIF_TBL]');
            Exit;
         end;
      End;

      DRUserDblCodeCombo_ToAccNo.ClearItems;
      DRUserDblCodeCombo_FromAccNo.ClearItems;
      while not EOF do
      begin
         DRUserDblCodeCombo_ToAccNo.AddItem(Trim(FieldByName('ACC_NO').asString),
                                 Trim(FieldByName('ACC_NAME_KOR').asString));
         DRUserDblCodeCombo_FromAccNo.AddItem(Trim(FieldByName('ACC_NO').asString),
                                 Trim(FieldByName('ACC_NAME_KOR').asString));

         Next;
      end;

   end;
   Result := True;
end;

procedure TForm_SCCFEAccMove.FormCreate(Sender: TObject);
begin
  inherited;
  InitializeData;

   TradeList := TList.Create;
   if not Assigned(TradeList) then
   begin
      gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); //List 생성 오류
      Close;
      Exit;
   end;

   TradeExecList := TList.Create;
   if not Assigned(TradeExecList) then
   begin
      gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); //List 생성 오류
      Close;
      Exit;
   end;

   OrdList := TList.Create;
   if not Assigned(OrdList) then
   begin
      gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); //List 생성 오류
      Close;
      Exit;
   end;

   OrdExecList := TList.Create;
   if not Assigned(OrdExecList) then
   begin
      gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); //List 생성 오류
      Close;
      Exit;
   end;

   DRMaskEdit_TradeDate.Text := gvCurDate;

end;

//------------------------------------------------------------------------------
//  Move Btn Click
//------------------------------------------------------------------------------
procedure TForm_SCCFEAccMove.DRBitBtn2Click(Sender: TObject);
var
   ToAccNo, FromAccNo, TradeDate : String;
   TradeItem     : pTTradeList;
   TradeExecItem : pTTradeExecList;
   OrdItem       : pTOrdList;
   OrdExecItem   : pTOrdExecList;
   I : Integer;
   OrdNo : String;
   TotExecQty, AvrExecPrice, TotExecAmt, NetAmt, Comm, TradeTax, AgctTax, CapGainTax : Double;
   ExecQty,ExecPrice, ExecAmt  : Double;
   StrExecPrice, StrOrdNo      : String;
begin
  inherited;

   TradeDate := DRMaskEdit_TradeDate.Text;
   ToAccNo   := DRUserDblCodeCombo_ToAccNo.Code;
   FromAccNo := DRUserDblCodeCombo_FromAccNo.Code;

   if TradeDate = '' then
   begin
     gf_ShowMessage(MessageBar, mtInformation, 0, '일자를 입력하세요');
     Exit;
   end;
   if (ToAccNo = '') or (FromAccNo = '') then
   begin
     gf_ShowMessage(MessageBar, mtInformation, 0, '계좌를 선택하세요');
     Exit;
   end;

   // Confirm - 정말 저장하시겠습니까?
   if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 0,ToAccNo + '계좌를 ' + FromAccNo + '계좌에 복사합니다.'  , [mbYes, mbNo], 0) = idNo then
   begin
      gf_ShowMessage(MessageBar, mtInformation, 0, '취소됐습니다');
      Exit;
   end;
    gf_ShowMessage(MessageBar, mtInformation, 0, '저장중....'); //조회 중입니다.
    DisableForm;

   ClearTradeList;         // List Clear

   TradeItem     := nil;
   TradeExecItem := nil;
   OrdItem       := nil;
   OrdExecItem   := nil;

   ////======= SFETRAD_TBL Move ================================================
   with ADOQuery_Temp do
   begin
     if DRCheckBox1.Checked = True then
     begin
       Close;
       sql.clear;
       sql.add(
           '  DELETE FROM  SFETRAD_TBL                     '+
           '  WHERE  DEPT_CODE = ''' + gvDeptCode + '''    '+
           '     AND ACC_NO    = ''' + FromAccNo + '''     '+
           '     AND TRADE_DATE = ''' + TradeDate + '''    ');
       Try
          gf_ADOExecSQL(ADOQuery_Temp);
       Except
          on E : Exception do
          begin
             gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SFETRAD_TBL : DELETE]: ' + E.Message, 0);
             gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SFETRAD_TBL : DELETE]'); // Database 오류
             EnableForm;
             Exit;
          end;
       end;  //try

       Close;
       sql.clear;
       sql.add(
           '  DELETE FROM  SFESPEX_TBL                     '+
           '  WHERE  DEPT_CODE = ''' + gvDeptCode + '''    '+
           '     AND ACC_NO    = ''' + FromAccNo + '''     '+
           '     AND TRADE_DATE = ''' + TradeDate + '''    ');
       Try
          gf_ADOExecSQL(ADOQuery_Temp);
       Except
          on E : Exception do
          begin
             gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SFESPEX_TBL : DELETE]: ' + E.Message, 0);
             gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SFESPEX_TBL : DELETE]'); // Database 오류
             EnableForm;
             Exit;
          end;
       end;  //try

       Close;
       sql.clear;
       sql.add(
           '  DELETE FROM  SFORDTD_TBL                     '+
           '  WHERE  DEPT_CODE = ''' + gvDeptCode + '''    '+
           '     AND ACC_NO    = ''' + FromAccNo + '''     '+
           '     AND TRADE_DATE = ''' + TradeDate + '''    ');
       Try
          gf_ADOExecSQL(ADOQuery_Temp);
       Except
          on E : Exception do
          begin
             gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SFORDTD_TBL : DELETE]: ' + E.Message, 0);
             gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SFORDTD_TBL : DELETE]'); // Database 오류
             EnableForm;
             Exit;
          end;
       end;  //try

       Close;
       sql.clear;
       sql.add(
           '  DELETE FROM  SFORDEX_TBL                     '+
           '  WHERE  DEPT_CODE = ''' + gvDeptCode + '''    '+
           '     AND ACC_NO    = ''' + FromAccNo + '''     '+
           '     AND TRADE_DATE = ''' + TradeDate + '''    ');
       Try
          gf_ADOExecSQL(ADOQuery_Temp);
       Except
          on E : Exception do
          begin
             gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SFORDEX_TBL : DELETE]: ' + E.Message, 0);
             gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SFORDEX_TBL : DELETE]'); // Database 오류
             EnableForm;
             Exit;
          end;
       end;  //try
     end; // if DRCheckBox1.Checked = True then
      Close;
      SQL.Clear;
      SQL.Add(' Select TRADE_DATE, DEPT_CODE, ACC_NO, SUB_ACC_NO, ISSUE_CODE,  '
            + '        TRAN_CODE, TRADE_TYPE, TOT_EXEC_QTY, AVR_EXEC_PRICE,    '
            + '        TOT_EXEC_AMT, NET_AMT, COMM, TRADE_TAX, AGCT_TAX, CAP_GAIN_TAX '
            + ' From SFETRAD_TBL '
            + ' Where TRADE_DATE = ''' + TradeDate + ''''
            + '   and DEPT_CODE  = ''' + gvDeptCode + ''''
            + '   and ACC_NO     = ''' + ToAccNo + '''');
      Try
         gf_ADOQueryOpen(ADOQuery_Temp);
      Except
         on E: Exception do
         begin
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SFETRAD_TBL]: ' + E.Message, 0);
            EnableForm;
            Exit;
         end;
      End;

      while not Eof do
      begin
        New(TradeItem);
        TradeList.Add(TradeItem);
        TradeItem.TradeDate    := Trim(FieldByName('TRADE_DATE').asString);
        TradeItem.DeptCode     := Trim(FieldByName('DEPT_CODE').asString);
        TradeItem.AccNo        := Trim(FieldByName('ACC_NO').asString);
        TradeItem.SubAccNo     := Trim(FieldByName('SUB_ACC_NO').asString);
        TradeItem.IssueCode    := Trim(FieldByName('ISSUE_CODE').asString);
        TradeItem.TranCode     := Trim(FieldByName('TRAN_CODE').asString);
        TradeItem.TradeType    := Trim(FieldByName('TRADE_TYPE').asString);
        TradeItem.TotExecQty   := FieldByName('TOT_EXEC_QTY').asFloat;
        TradeItem.AvrExecPrice := FieldByName('AVR_EXEC_PRICE').asFloat;
        TradeItem.TotExecAmt   := FieldByName('TOT_EXEC_AMT').asFloat;
        TradeItem.NetAmt       := FieldByName('NET_AMT').asFloat;
        TradeItem.Comm         := FieldByName('COMM').asFloat;
        TradeItem.TradeTax     := FieldByName('TRADE_TAX').asFloat;
        TradeItem.AgctTax      := FieldByName('AGCT_TAX').asFloat;
        TradeItem.CapGainTax   := FieldByName('CAP_GAIN_TAX').asFloat;
        next;
      end; // while not Eof do

      for I := 0 to TradeList.Count -1 do
      begin
         TradeItem := TradeList.Items[I];
        Close;
        SQL.Clear;
        SQL.Add(' Select TRADE_DATE, DEPT_CODE, ACC_NO, SUB_ACC_NO, ISSUE_CODE,  '
              + '        TRAN_CODE, TRADE_TYPE, TOT_EXEC_QTY, AVR_EXEC_PRICE,    '
              + '        TOT_EXEC_AMT, NET_AMT, COMM, TRADE_TAX, AGCT_TAX, CAP_GAIN_TAX '
              + ' From SFETRAD_TBL                              '
              + ' Where TRADE_DATE  = ''' + TradeDate  + '''    '
              + '   and DEPT_CODE   = ''' + gvDeptCode + '''    '
              + '   and ACC_NO      = ''' + FromAccNo  + '''     '
              + '   and SUB_ACC_NO  = ''' + TradeItem.SubAccNo  + '''  '
              + '   and ISSUE_CODE  = ''' + TradeItem.IssueCode + '''  '
              + '   and TRAN_CODE   = ''' + TradeItem.TranCode  + '''  '
              + '   and TRADE_TYPE  = ''' + TradeItem.TradeType + '''  ');
        Try
           gf_ADOQueryOpen(ADOQuery_Temp);
        Except
           on E: Exception do
           begin
              gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SFETRAD_TBL]: ' + E.Message, 0);
              EnableForm;
              Exit;
           end;
        End;
        TotExecQty   := FieldByName('TOT_EXEC_QTY').asFloat;
        AvrExecPrice := FieldByName('AVR_EXEC_PRICE').asFloat;
        TotExecAmt   := FieldByName('TOT_EXEC_AMT').asFloat;
        NetAmt       := FieldByName('NET_AMT').asFloat;
        Comm         := FieldByName('COMM').asFloat;
        TradeTax     := FieldByName('TRADE_TAX').asFloat;
        AgctTax      := FieldByName('AGCT_TAX').asFloat;
        CapGainTax   := FieldByName('CAP_GAIN_TAX').asFloat;

        if RecordCount = 0 then  // Insert
        begin
          Close;
          SQL.Clear;
          SQL.Add(' Insert SFETRAD_TBL                                                   '
                + ' (TRADE_DATE, DEPT_CODE, ACC_NO, SUB_ACC_NO, ISSUE_CODE, TRAN_CODE,   '
                + ' TRADE_TYPE, TOT_EXEC_QTY, AVR_EXEC_PRICE,                            '
                + ' TOT_EXEC_AMT, NET_AMT, COMM, TRADE_TAX, AGCT_TAX,CAP_GAIN_TAX)       '
                + ' Values                                                               '
                + ' (:pTradeDate, :pDeptCode, :pAccNo, :pSubAccNo, :pIssueCode, :pTranCode, '
                + ' :pTradeType,  :pTotExecQty, :pAvrExecPrice,                          '
                + ' :pTotExecAmt, :pNetAmt, :pComm, :pTradeTax, :pAgctTax, :pCapGainTax) ');
          Parameters.ParamByName('pTradeDate').Value    := TradeItem.TradeDate;
          Parameters.ParamByName('pDeptCode').Value     := TradeItem.DeptCode;
          Parameters.ParamByName('pAccNo').Value        := FromAccNo;
          Parameters.ParamByName('pSubAccNo').Value     := TradeItem.SubAccNo;
          Parameters.ParamByName('pIssueCode').Value    := TradeItem.IssueCode;
          Parameters.ParamByName('pTranCode').Value     := TradeItem.TranCode;
          Parameters.ParamByName('pTradeType').Value    := TradeItem.TradeType;
          Parameters.ParamByName('pTotExecQty').Value   := TradeItem.TotExecQty;
          Parameters.ParamByName('pAvrExecPrice').Value := TradeItem.TotExecAmt/TradeItem.TotExecQty;
          Parameters.ParamByName('pTotExecAmt').Value   := TradeItem.TotExecAmt;
          Parameters.ParamByName('pNetAmt').Value       := TradeItem.NetAmt;
          Parameters.ParamByName('pComm').Value         := TradeItem.Comm;
          Parameters.ParamByName('pTradeTax').Value     := TradeItem.TradeTax;
          Parameters.ParamByName('pAgctTax').Value      := TradeItem.AgctTax;
          Parameters.ParamByName('pCapGainTax').Value   := TradeItem.CapGainTax;

          Try
             gf_ADOExecSQL(ADOQuery_Temp);
          Except
             on E: Exception do
             begin
                raise Exception.Create('ADOQuery_Temp[SFETRAD_TBL Insert]: ' + E.Message);
                EnableForm;
                Exit;
             end;
          End;
        end else                 // Update
        begin
          Close;
          SQL.Clear;
          SQL.Add(' UPDATE SFETRAD_TBL                                         '
                + ' SET                                                        '
                + '   TOT_EXEC_QTY   =    :pTotExecQty,                        '
                + '   TOT_EXEC_AMT   =    :pTotExecAmt,                        '
                + '   AVR_EXEC_PRICE =    :pAvrExecPrice,                      '
                + '   NET_AMT        =    :pNetAmt,                            '
                + '   COMM           =    :pComm,                              '
                + '   TRADE_TAX      =    :pTradeTax,                          '
                + '   AGCT_TAX       =    :pAgctTax,                           '
                + '   CAP_GAIN_TAX   =    :pCapGainTax                        '
                + ' WHERE DEPT_CODE  = ''' + TradeItem.DeptCode + '''    '
                + '   AND TRADE_DATE = ''' + TradeItem.TradeDate + '''   '
                + '   AND ACC_NO     = ''' + FromAccNo + '''       '
                + '   AND SUB_ACC_NO = ''' + TradeItem.SubAccNo + '''    '
                + '   AND ISSUE_CODE = ''' + TradeItem.IssueCode + '''   '
                + '   AND TRAN_CODE  = ''' + TradeItem.TranCode + '''    '
                + '   AND TRADE_TYPE = ''' + TradeItem.TradeType + '''   ');

          Parameters.ParamByName('pTotExecQty').Value   := TotExecQty + TradeItem.TotExecQty;
          Parameters.ParamByName('pTotExecAmt').Value   := TotExecAmt + TradeItem.TotExecAmt;
          Parameters.ParamByName('pAvrExecPrice').Value := (TotExecAmt + TradeItem.TotExecAmt)/ (TotExecQty + TradeItem.TotExecQty);
          Parameters.ParamByName('pNetAmt').Value       := NetAmt + TradeItem.NetAmt;
          Parameters.ParamByName('pComm').Value         := Comm  +  TradeItem.Comm;
          Parameters.ParamByName('pTradeTax').Value     := TradeTax + TradeItem.TradeTax;
          Parameters.ParamByName('pAgctTax').Value      := AgctTax + TradeItem.AgctTax;
          Parameters.ParamByName('pCapGainTax').Value   := CapGainTax + TradeItem.CapGainTax;

          Try
             gf_ADOExecSQL(ADOQuery_Temp);
          Except
             on E: Exception do
             begin
                raise Exception.Create('ADOQuery_Temp[SFETRAD_TBL : UPDATE]: ' + E.Message);
                EnableForm;
                Exit;
             end;
          End;
        end;

      end; // for I := 0 to TradeList.Count -1 do


   /////========= SFESPEX_TBL Move =============================================
      Close;
      SQL.Clear;
      SQL.Add(' Select TRADE_DATE, DEPT_CODE, ACC_NO, SUB_ACC_NO, ISSUE_CODE,  '
            + '        TRAN_CODE, TRADE_TYPE, EXEC_QTY, EXEC_PRICE, EXEC_AMT   '
            + ' From SFESPEX_TBL '
            + ' Where TRADE_DATE = ''' + TradeDate + ''''
            + '   and DEPT_CODE  = ''' + gvDeptCode + ''''
            + '   and ACC_NO     = ''' + ToAccNo + '''');
      Try
         gf_ADOQueryOpen(ADOQuery_Temp);
      Except
         on E: Exception do
         begin
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SFETRAD_TBL]: ' + E.Message, 0);
            EnableForm;
            Exit;
         end;
      End;

      while not Eof do
      begin
        New(TradeExecItem);
        TradeExecList.Add(TradeExecItem);
        TradeExecItem.TradeDate    := Trim(FieldByName('TRADE_DATE').asString);
        TradeExecItem.DeptCode     := Trim(FieldByName('DEPT_CODE').asString);
        TradeExecItem.AccNo        := Trim(FieldByName('ACC_NO').asString);
        TradeExecItem.SubAccNo     := Trim(FieldByName('SUB_ACC_NO').asString);
        TradeExecItem.IssueCode    := Trim(FieldByName('ISSUE_CODE').asString);
        TradeExecItem.TranCode     := Trim(FieldByName('TRAN_CODE').asString);
        TradeExecItem.TradeType    := Trim(FieldByName('TRADE_TYPE').asString);
        TradeExecItem.ExecQty      := FieldByName('EXEC_QTY').asFloat;
        TradeExecItem.ExecPrice    := FieldByName('EXEC_PRICE').asFloat;
        TradeExecItem.ExecAmt      := FieldByName('EXEC_AMT').asFloat;
        next;
      end; // while not Eof do

      for I := 0 to TradeExecList.Count -1 do
      begin
         TradeExecItem := TradeExecList.Items[I];
         StrExecPrice  := FloatToStr(TradeExecItem.ExecPrice);
        Close;
        SQL.Clear;
        SQL.Add(' Select TRADE_DATE, DEPT_CODE, ACC_NO, SUB_ACC_NO, ISSUE_CODE,  '
              + '        TRAN_CODE, TRADE_TYPE, EXEC_QTY, EXEC_PRICE, EXEC_AMT   '
              + ' From SFESPEX_TBL                              '
              + ' Where TRADE_DATE  = ''' + TradeDate  + '''    '
              + '   and DEPT_CODE   = ''' + gvDeptCode + '''    '
              + '   and ACC_NO      = ''' + FromAccNo  + '''     '
              + '   and SUB_ACC_NO  = ''' + TradeExecItem.SubAccNo  + '''  '
              + '   and ISSUE_CODE  = ''' + TradeExecItem.IssueCode + '''  '
              + '   and TRAN_CODE   = ''' + TradeExecItem.TranCode  + '''  '
              + '   and TRADE_TYPE  = ''' + TradeExecItem.TradeType + '''  '
              + '   and EXEC_PRICE  = '   + StrExecPrice            + '    ');
        Try
           gf_ADOQueryOpen(ADOQuery_Temp);
        Except
           on E: Exception do
           begin
              gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SFETRAD_TBL]: ' + E.Message, 0);
              EnableForm;
              Exit;
           end;
        End;
        ExecQty   := FieldByName('EXEC_QTY').asFloat;
        ExecPrice := FieldByName('EXEC_PRICE').asFloat;
        ExecAmt   := FieldByName('EXEC_AMT').asFloat;

        if RecordCount = 0 then  // Insert
        begin
          Close;
          SQL.Clear;
          SQL.Add(' Insert SFESPEX_TBL                                                   '
                + ' (TRADE_DATE, DEPT_CODE, ACC_NO, SUB_ACC_NO, ISSUE_CODE, TRAN_CODE,   '
                + ' TRADE_TYPE, EXEC_QTY, EXEC_PRICE, EXEC_AMT)                          '
                + ' Values                                                               '
                + ' (:pTradeDate, :pDeptCode, :pAccNo, :pSubAccNo, :pIssueCode, :pTranCode, '
                + ' :pTradeType,  :pExecQty, :pExecPrice, :pExecAmt)                    ');
          Parameters.ParamByName('pTradeDate').Value    := TradeExecItem.TradeDate;
          Parameters.ParamByName('pDeptCode').Value     := TradeExecItem.DeptCode;
          Parameters.ParamByName('pAccNo').Value        := FromAccNo;
          Parameters.ParamByName('pSubAccNo').Value     := TradeExecItem.SubAccNo;
          Parameters.ParamByName('pIssueCode').Value    := TradeExecItem.IssueCode;
          Parameters.ParamByName('pTranCode').Value     := TradeExecItem.TranCode;
          Parameters.ParamByName('pTradeType').Value    := TradeExecItem.TradeType;
          Parameters.ParamByName('pExecQty').Value      := TradeExecItem.ExecQty;
          Parameters.ParamByName('pExecPrice').Value    := TradeExecItem.ExecPrice;
          Parameters.ParamByName('pExecAmt').Value      := TradeExecItem.ExecAmt;

          Try
             gf_ADOExecSQL(ADOQuery_Temp);
          Except
             on E: Exception do
             begin
                raise Exception.Create('ADOQuery_Temp[SFESPEX_TBL Insert]: ' + E.Message);
                EnableForm;
                Exit;
             end;
          End;
        end else                 // Update
        begin
          Close;
          SQL.Clear;
          SQL.Add(' UPDATE SFESPEX_TBL                                       '
                + ' SET                                                      '
                + '   EXEC_QTY   =    :pExecQty,                             '
                + '   EXEC_AMT   =    :pExecAmt                              '
                + ' WHERE DEPT_CODE  = ''' + TradeExecItem.DeptCode + '''    '
                + '   AND TRADE_DATE = ''' + TradeExecItem.TradeDate + '''   '
                + '   AND ACC_NO     = ''' + FromAccNo + '''                 '
                + '   AND SUB_ACC_NO = ''' + TradeExecItem.SubAccNo + '''    '
                + '   AND ISSUE_CODE = ''' + TradeExecItem.IssueCode + '''   '
                + '   AND TRAN_CODE  = ''' + TradeExecItem.TranCode + '''    '
                + '   AND TRADE_TYPE = ''' + TradeExecItem.TradeType + '''   '
                + '   AND EXEC_PRICE = '   + StrExecPrice            + '     ');

          Parameters.ParamByName('pExecQty').Value   := ExecQty + TradeExecItem.ExecQty;
          Parameters.ParamByName('pExecAmt').Value   := ExecAmt + TradeExecItem.ExecAmt;

          Try
             gf_ADOExecSQL(ADOQuery_Temp);
          Except
             on E: Exception do
             begin
                raise Exception.Create('ADOQuery_Temp[SFESPEX_TBL : UPDATE]: ' + E.Message);
                EnableForm;
                Exit;
             end;
          End;
        end;

      end; // for I := 0 to TradeExecList.Count -1 do

   ////=========== SFORDTD_TBL Move ============================================
      Close;
      SQL.Clear;
      SQL.Add(' Select TRADE_DATE, DEPT_CODE, ACC_NO, SUB_ACC_NO, ISSUE_CODE,     '
            + '        TRAN_CODE, TRADE_TYPE, ORD_NO, TOT_EXEC_QTY, TOT_EXEC_AMT  '
            + ' From SFORDTD_TBL '
            + ' Where TRADE_DATE = ''' + TradeDate + ''''
            + '   and DEPT_CODE  = ''' + gvDeptCode + ''''
            + '   and ACC_NO     = ''' + ToAccNo + '''');
      Try
         gf_ADOQueryOpen(ADOQuery_Temp);
      Except
         on E: Exception do
         begin
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SFORDTD_TBL]: ' + E.Message, 0);
            EnableForm;
            Exit;
         end;
      End;

      while not Eof do
      begin
        New(OrdItem);
        OrdList.Add(OrdItem);
        OrdItem.TradeDate    := Trim(FieldByName('TRADE_DATE').asString);
        OrdItem.DeptCode     := Trim(FieldByName('DEPT_CODE').asString);
        OrdItem.AccNo        := Trim(FieldByName('ACC_NO').asString);
        OrdItem.SubAccNo     := Trim(FieldByName('SUB_ACC_NO').asString);
        OrdItem.IssueCode    := Trim(FieldByName('ISSUE_CODE').asString);
        OrdItem.TranCode     := Trim(FieldByName('TRAN_CODE').asString);
        OrdItem.TradeType    := Trim(FieldByName('TRADE_TYPE').asString);
        OrdItem.OrdNo        := Trim(FieldByName('ORD_NO').asString);
        OrdItem.TotExecQty   := FieldByName('TOT_EXEC_QTY').asFloat;
        OrdItem.TotExecAmt   := FieldByName('TOT_EXEC_AMT').asFloat;
        next;
      end; // while not Eof do

      for I := 0 to OrdList.Count -1 do
      begin
         OrdItem  := OrdList.Items[I];
         StrOrdNo := Trim(OrdItem.OrdNo);
        Close;
        SQL.Clear;
        SQL.Add(' Select TRADE_DATE, DEPT_CODE, ACC_NO, SUB_ACC_NO, ISSUE_CODE,  '
              + '        TRAN_CODE, TRADE_TYPE, ORD_NO, TOT_EXEC_QTY, TOT_EXEC_AMT       '
              + ' From SFORDTD_TBL                              '
              + ' Where TRADE_DATE  = ''' + TradeDate  + '''    '
              + '   and DEPT_CODE   = ''' + gvDeptCode + '''    '
              + '   and ACC_NO      = ''' + FromAccNo  + '''     '
              + '   and SUB_ACC_NO  = ''' + OrdItem.SubAccNo  + '''  '
              + '   and ISSUE_CODE  = ''' + OrdItem.IssueCode + '''  '
              + '   and TRAN_CODE   = ''' + OrdItem.TranCode  + '''  '
              + '   and TRADE_TYPE  = ''' + OrdItem.TradeType + '''  '
              + '   and ORD_NO      = '''   + StrOrdNo        + '''   ');
        Try
           gf_ADOQueryOpen(ADOQuery_Temp);
        Except
           on E: Exception do
           begin
              gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SFORDTD_TBL]: ' + E.Message, 0);
              EnableForm;
              Exit;
           end;
        End;
        TotExecQty   := FieldByName('TOT_EXEC_QTY').asFloat;
        TotExecAmt   := FieldByName('TOT_EXEC_AMT').asFloat;
        OrdNo        := Trim(FieldByName('ORD_NO').asString);

        if RecordCount = 0 then  // Insert
        begin
          Close;
          SQL.Clear;
          SQL.Add(' Insert SFORDTD_TBL                                                   '
                + ' (TRADE_DATE, DEPT_CODE, ACC_NO, SUB_ACC_NO, ISSUE_CODE, TRAN_CODE,   '
                + ' TRADE_TYPE, ORD_NO, TOT_EXEC_QTY, TOT_EXEC_AMT)                      '
                + ' Values                                                               '
                + ' (:pTradeDate, :pDeptCode, :pAccNo, :pSubAccNo, :pIssueCode, :pTranCode, '
                + ' :pTradeType,  :pOrdNo, :pTotExecQty, :pTotExecAmt)                      ');

          Parameters.ParamByName('pTradeDate').Value    := OrdItem.TradeDate;
          Parameters.ParamByName('pDeptCode').Value     := OrdItem.DeptCode;
          Parameters.ParamByName('pAccNo').Value        := FromAccNo;
          Parameters.ParamByName('pSubAccNo').Value     := OrdItem.SubAccNo;
          Parameters.ParamByName('pIssueCode').Value    := OrdItem.IssueCode;
          Parameters.ParamByName('pTranCode').Value     := OrdItem.TranCode;
          Parameters.ParamByName('pTradeType').Value    := OrdItem.TradeType;
          Parameters.ParamByName('pOrdNo').Value        := OrdItem.OrdNo;
          Parameters.ParamByName('pTotExecQty').Value   := OrdItem.TotExecQty;
          Parameters.ParamByName('pTotExecAmt').Value   := OrdItem.TotExecAmt;


          Try
             gf_ADOExecSQL(ADOQuery_Temp);
          Except
             on E: Exception do
             begin
                raise Exception.Create('ADOQuery_Temp[SFORDTD_TBL Insert]: ' + E.Message);
                EnableForm;
                Exit;
             end;
          End;
        end else                 // Update
        begin
          Close;
          SQL.Clear;
          SQL.Add(' UPDATE SFORDTD_TBL                                         '
                + ' SET                                                        '
                + '   TOT_EXEC_QTY   =    :pTotExecQty,                        '
                + '   TOT_EXEC_AMT   =    :pTotExecAmt                         '
                + ' WHERE DEPT_CODE  = ''' + OrdItem.DeptCode + '''    '
                + '   AND TRADE_DATE = ''' + OrdItem.TradeDate + '''   '
                + '   AND ACC_NO     = ''' + FromAccNo + '''           '
                + '   AND SUB_ACC_NO = ''' + OrdItem.SubAccNo + '''    '
                + '   AND ISSUE_CODE = ''' + OrdItem.IssueCode + '''   '
                + '   AND TRAN_CODE  = ''' + OrdItem.TranCode + '''    '
                + '   AND TRADE_TYPE  = ''' + OrdItem.TradeType + '''  '
                + '   AND ORD_NO      = '''   + StrOrdNo          + '''    ');
          Parameters.ParamByName('pTotExecQty').Value   := TotExecQty + OrdItem.TotExecQty;
          Parameters.ParamByName('pTotExecAmt').Value   := TotExecAmt + OrdItem.TotExecAmt;

          Try
             gf_ADOExecSQL(ADOQuery_Temp);
          Except
             on E: Exception do
             begin
                raise Exception.Create('ADOQuery_Temp[SFORDTD_TBL : UPDATE]: ' + E.Message);
                EnableForm;
                Exit;
             end;
          End;
        end;
      end; // for I := 0 to OrdList.Count -1 do

   ////=========== SFORDEX_TBL Move ============================================
      Close;
      SQL.Clear;
      SQL.Add(' Select TRADE_DATE, DEPT_CODE, ACC_NO, SUB_ACC_NO, ISSUE_CODE,     '
            + '        TRAN_CODE, TRADE_TYPE, ORD_NO, EXEC_PRICE, EXEC_QTY, EXEC_AMT  '
            + ' From SFORDEX_TBL '
            + ' Where TRADE_DATE = ''' + TradeDate + ''''
            + '   and DEPT_CODE  = ''' + gvDeptCode + ''''
            + '   and ACC_NO     = ''' + ToAccNo + '''');
      Try
         gf_ADOQueryOpen(ADOQuery_Temp);
      Except
         on E: Exception do
         begin
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SFORDEX_TBL]: ' + E.Message, 0);
            EnableForm;
            Exit;
         end;
      End;

      while not Eof do
      begin
        New(OrdExecItem);
        OrdExecList.Add(OrdExecItem);
        OrdExecItem.TradeDate    := Trim(FieldByName('TRADE_DATE').asString);
        OrdExecItem.DeptCode     := Trim(FieldByName('DEPT_CODE').asString);
        OrdExecItem.AccNo        := Trim(FieldByName('ACC_NO').asString);
        OrdExecItem.SubAccNo     := Trim(FieldByName('SUB_ACC_NO').asString);
        OrdExecItem.IssueCode    := Trim(FieldByName('ISSUE_CODE').asString);
        OrdExecItem.TranCode     := Trim(FieldByName('TRAN_CODE').asString);
        OrdExecItem.TradeType    := Trim(FieldByName('TRADE_TYPE').asString);
        OrdExecItem.OrdNo        := Trim(FieldByName('ORD_NO').asString);
        OrdExecItem.ExecPrice    := FieldByName('EXEC_PRICE').asFloat;
        OrdExecItem.ExecQty      := FieldByName('EXEC_QTY').asFloat;
        OrdExecItem.ExecAmt      := FieldByName('EXEC_AMT').asFloat;
        next;
      end; // while not Eof do

      for I := 0 to OrdExecList.Count -1 do
      begin
         OrdExecItem  := OrdExecList.Items[I];
         StrOrdNo     := Trim(OrdExecItem.OrdNo);
         StrExecPrice := FloatToStr(OrdExecItem.ExecPrice);
        Close;
        SQL.Clear;
        SQL.Add(' Select TRADE_DATE, DEPT_CODE, ACC_NO, SUB_ACC_NO, ISSUE_CODE,  '
              + '        TRAN_CODE, TRADE_TYPE, ORD_NO, EXEC_PRICE, EXEC_QTY, EXEC_AMT       '
              + ' From SFORDEX_TBL                              '
              + ' Where TRADE_DATE  = ''' + TradeDate  + '''    '
              + '   and DEPT_CODE   = ''' + gvDeptCode + '''    '
              + '   and ACC_NO      = ''' + FromAccNo  + '''     '
              + '   and SUB_ACC_NO  = ''' + OrdExecItem.SubAccNo  + '''  '
              + '   and ISSUE_CODE  = ''' + OrdExecItem.IssueCode + '''  '
              + '   and TRAN_CODE   = ''' + OrdExecItem.TranCode  + '''  '
              + '   and TRADE_TYPE  = ''' + OrdExecItem.TradeType + '''  '
              + '   and ORD_NO      = ''' + StrOrdNo            + '''    '
              + '   and EXEC_PRICE  = '   + StrExecPrice          + '    ');
        Try
           gf_ADOQueryOpen(ADOQuery_Temp);
        Except
           on E: Exception do
           begin
              gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SFORDEX_TBL]: ' + E.Message, 0);
              EnableForm;
              Exit;
           end;
        End;
        ExecQty   := FieldByName('EXEC_QTY').asFloat;
        ExecAmt   := FieldByName('EXEC_AMT').asFloat;
        OrdNo     := Trim(FieldByName('ORD_NO').asString);
        ExecPrice := FieldByName('EXEC_PRICE').asFloat;

        if RecordCount = 0 then  // Insert
        begin
          Close;
          SQL.Clear;
          SQL.Add(' Insert SFORDEX_TBL                                                   '
                + ' (TRADE_DATE, DEPT_CODE, ACC_NO, SUB_ACC_NO, ISSUE_CODE, TRAN_CODE,   '
                + ' TRADE_TYPE, ORD_NO, EXEC_PRICE, EXEC_QTY, EXEC_AMT)                  '
                + ' Values                                                               '
                + ' (:pTradeDate, :pDeptCode, :pAccNo, :pSubAccNo, :pIssueCode, :pTranCode, '
                + ' :pTradeType,  :pOrdNo, :pExecPrice, :pExecQty, :pExecAmt)            ');

          Parameters.ParamByName('pTradeDate').Value    := OrdExecItem.TradeDate;
          Parameters.ParamByName('pDeptCode').Value     := OrdExecItem.DeptCode;
          Parameters.ParamByName('pAccNo').Value        := FromAccNo;
          Parameters.ParamByName('pSubAccNo').Value     := OrdExecItem.SubAccNo;
          Parameters.ParamByName('pIssueCode').Value    := OrdExecItem.IssueCode;
          Parameters.ParamByName('pTranCode').Value     := OrdExecItem.TranCode;
          Parameters.ParamByName('pTradeType').Value    := OrdExecItem.TradeType;
          Parameters.ParamByName('pOrdNo').Value        := OrdExecItem.OrdNo;
          Parameters.ParamByName('pExecPrice').Value    := OrdExecItem.ExecPrice;
          Parameters.ParamByName('pExecQty').Value      := OrdExecItem.ExecQty;
          Parameters.ParamByName('pExecAmt').Value      := OrdExecItem.ExecAmt;


          Try
             gf_ADOExecSQL(ADOQuery_Temp);
          Except
             on E: Exception do
             begin
                raise Exception.Create('ADOQuery_Temp[SFORDEX_TBL Insert]: ' + E.Message);
                EnableForm;
                Exit;
             end;
          End;
        end else                 // Update
        begin
          Close;
          SQL.Clear;
          SQL.Add(' UPDATE SFORDEX_TBL                                     '
                + ' SET                                                    '
                + '   EXEC_QTY   =    :pExecQty,                           '
                + '   EXEC_AMT   =    :pExecAmt                            '
                + ' WHERE DEPT_CODE  = ''' + OrdExecItem.DeptCode + '''    '
                + '   AND TRADE_DATE = ''' + OrdExecItem.TradeDate + '''   '
                + '   AND ACC_NO     = ''' + FromAccNo + '''               '
                + '   AND SUB_ACC_NO = ''' + OrdExecItem.SubAccNo + '''    '
                + '   AND ISSUE_CODE = ''' + OrdExecItem.IssueCode + '''   '
                + '   AND TRAN_CODE  = ''' + OrdExecItem.TranCode + '''    '
                + '   AND TRADE_TYPE  = ''' + OrdExecItem.TradeType + '''  '
                + '   AND ORD_NO      = '''   + StrOrdNo            + '''    '
                + '   AND EXEC_PRICE  = '   + StrExecPrice          + '    ');
          Parameters.ParamByName('pExecQty').Value   := ExecQty + OrdExecItem.ExecQty;
          Parameters.ParamByName('pExecAmt').Value   := ExecAmt + OrdExecItem.ExecAmt;

          Try
             gf_ADOExecSQL(ADOQuery_Temp);
          Except
             on E: Exception do
             begin
                raise Exception.Create('ADOQuery_Temp[SFORDEX_TBL : UPDATE]: ' + E.Message);
                EnableForm;
                Exit;
             end;
          End;
        end;

      end; // for I := 0 to OrdList.Count -1 do

   end; // with ADOQuery_Temp do
     EnableForm;
     gf_ShowMessage(MessageBar, mtInformation, 0, '저장완료'); // 조회 완료
end;

procedure TForm_SCCFEAccMove.DRMaskEdit_TradeDateKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
   if Key = #13 then
   begin
      // 입력 일자 확인
      if (Trim(DRMaskEdit_TradeDate.Text) = '') or
         (gf_CheckValidDate(DRMaskEdit_TradeDate.Text) = False) then
      begin
         gf_ShowMessage(MessageBar, mtError, 1040, ''); //일자 입력 오류
         DRMaskEdit_TradeDate.SetFocus;
         DRMaskEdit_TradeDate.SelectAll;
         Exit;
      end;

      DRUserDblCodeCombo_ToAccNo.SetFocus;
   end;

end;

procedure TForm_SCCFEAccMove.DRUserDblCodeCombo_ToAccNoEditKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then DRUserDblCodeCombo_FromAccNo.SetFocus
end;

end.
