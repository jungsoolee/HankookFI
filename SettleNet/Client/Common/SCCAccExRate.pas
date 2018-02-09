unit SCCAccExRate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SCCChildForm, Grids, DRStringgrid, DRCodeControl, StdCtrls,
  Mask, DRAdditional, DRStandard, DRSpecial, DRDialogs, DB, ADODB, Buttons,
  ExtCtrls;

type
  //=== SUAXRAT_TBL 정보
  TExRateItem = record
    Grdidx       : Integer;
    DeptCode     : string[2];
    TradeDate    : string[8];
    AccNo        : string[20];
    AccName      : string[60];
    CurType      : string[1];
    BuyRate      : double;
    SelRate      : double;
    BuyMktRate   : double;
    SelMktRate   : double;
    IsUpdate     : Boolean;
    IsDataYN     : String[1];
  end;

type
  TForm_SCF_ExRate = class(TForm_SCF)
    DRFramePanel2: TDRFramePanel;
    DRLabel_TradeDate: TDRLabel;
    DRLabel_AccNo: TDRLabel;
    DRMaskEdit_TradeDate: TDRMaskEdit;
    DRStrGrid_Main: TDRStringGrid;
    ADOQuery_TEMP: TADOQuery;
    ADOQuery_Exchange: TADOQuery;
    DRCheckBox_ApplyALL: TDRCheckBox;
    DRUserCodeCombo_Currency: TDRUserCodeCombo;
    ADOQuery_Update: TADOQuery;
    ADOQuery_Insert: TADOQuery;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    //
    procedure DRBitBtn3Click(Sender: TObject);  //조회
    procedure DRBitBtn2Click(Sender: TObject);  //적용
    //
    procedure DRStrGrid_MainAfterEdit(Sender: TObject; col, row: Integer);
    procedure DRMaskEdit_KeyPress(Sender: TObject; var Key: Char);
    procedure DRUserCodeCombo_CurrencyEditKeyPress(Sender: TObject;
      var Key: Char);
    procedure DRStrGrid_MainSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure DRUserCodeCombo_CurrencyCodeChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function  CurrencyList : Boolean;               //통화리스트
    function  GetItemidx(GrdNo : Integer): Integer; //작업대상 index

    function  GetACCExchange(Currency, TradeDate : String) : Boolean; //조회 Query
    function  DisplayGrid : Boolean;                       //그리드 Draw
    procedure ClearDisplayGrid;                            //그리드 Clear

    procedure InsertParamData(ADOQuery : TADOQuery; idx : Integer); //적용시 Insert & Update Query
  end;

var
  Form_SCF_ExRate: TForm_SCF_ExRate;
  ExRateLst : array of TExRateItem;  //조회 Item
  ExRateCnt : Integer;               //조회 Count

  OldSelRowIdx : Integer;  //StringGrid의 Select Old Row Index
  SelColIdx : Integer;
  SelRowIdx : Integer;


const
   ACCNO_COL   = 0;
   ACCNAME_COL = 1;
   BUYRATE_COL = 2;
   SELRATE_COL = 3;
   BUYMKT_COL  = 4;
   SELMKT_COL  = 5;


implementation

uses SCCDataModule, SCCLib, SCCGlobalType;

{$R *.dfm}

//---------------------------------------------------------------------------
//  계좌별 환율 조회
//  조회 Button Click Event
//---------------------------------------------------------------------------
procedure TForm_SCF_ExRate.DRBitBtn3Click(Sender: TObject);
begin
  inherited;

   if (DRMaskEdit_TRADEDate.Text <> '') or
      (DRUserCodeCombo_Currency.Code <> '') then begin

      if not gf_CheckValidDate(DRMaskEdit_TRADEDate.Text) then begin
         gf_ShowMessage(MessageBar, mtError, 1040, ''); // 매매일자 입력오류
         DRMaskEdit_TRADEDate.SetFocus;
      end
      else begin
         // 조회내역 Clear
         ClearDisplayGrid;

         ExRateCnt := 0;
         SetLength(ExRateLst, ExRateCnt);
         DisableForm;
         gf_ShowMessage(MessageBar, mtInformation, 1020, ''); //조회 중입니다.

         GetACCExchange(DRUserCodeCombo_Currency.Code, DRMaskEdit_TradeDate.Text);
         // 조회내역 Grid Draw
         DisplayGrid;

         EnableForm;
         DRUserCodeCombo_Currency.SetFocus;
      end;
   end;

end;

procedure TForm_SCF_ExRate.DRBitBtn2Click(Sender: TObject);
var
   i : Integer;
begin
  inherited;

   with ADOQuery_Update do begin
      Close;
      SQL.Clear;
      SQL.Add(' UPDATE SUAXRAT_TBL SET                    '
             +'        BUY_RATE = :BUY_RATE,              '
             +'        SELL_RATE = :SELL_RATE,            '
             +'        BUY_MKT_RATE = :BUY_MKT_RATE,      '
             +'        SELL_MKT_RATE = :SELL_MKT_RATE,    '
             +'        OPR_ID = :OPR_ID,                  '
             +'        OPR_DATE = :OPR_DATE,              '
             +'        OPR_TIME = :OPR_TIME               '
             +'  WHERE DEPT_CODE = :DEPT_CODE             '
             +'    AND ACC_NO    = :ACC_NO                '
             +'    AND TRADE_DATE = :TRADE_DATE           '
             +'    AND CUR_TYPE   = :CUR_TYPE             ');
   end;

   with ADOQuery_Insert do begin
      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO SUAXRAT_TBL                    '
             +'      (DEPT_CODE, TRADE_DATE, ACC_NO,      '
             +'       CUR_TYPE, BUY_RATE, SELL_RATE,      '
             +'       BUY_MKT_RATE, SELL_MKT_RATE,        '
             +'       OPR_ID, OPR_DATE, OPR_TIME)         '
             +' VALUES                                    '
             +'      (:DEPT_CODE, :TRADE_DATE, :ACC_NO,   '
             +'       :CUR_TYPE, :BUY_RATE, :SELL_RATE,   '
             +'       :BUY_MKT_RATE, :SELL_MKT_RATE,      '
             +'       :OPR_ID, :OPR_DATE, :OPR_TIME)      ');
   end;

   for i:=0 to ExRateCnt-1 do begin
      if not ExRateLst[i].IsUpdate then continue;

      if ExRateLst[i].IsDataYN = 'Y' then InsertParamData(ADOQuery_Update, i)
      else InsertParamData(ADOQuery_Insert, i);
   end;

   DRBitBtn3Click(Sender);
end;

procedure TForm_SCF_ExRate.FormCreate(Sender: TObject);
begin
  inherited;
   DRStrGrid_Main.Color := gcGridBackColor;
   DRStrGrid_Main.SelectedCellColor := gcGridSelectColor;
   //Grid Clear
   ClearDisplayGrid;

   DRMaskEdit_TradeDate.Clear;
   DRMaskEdit_TradeDate.Text := FormatDateTime('yyyymmdd',now);

   if not CurrencyList then Exit;
   DRUserCodeCombo_Currency.AssignCode('2');
end;

procedure TForm_SCF_ExRate.FormShow(Sender: TObject);
begin
  inherited;
   DRBitBtn3Click(Sender); //조회
end;

//---------------------------------------------------------------------------
// 사용통화
//---------------------------------------------------------------------------
function TForm_SCF_ExRate.CurrencyList : Boolean;
begin
   result := False;

   with ADOQuery_TEMP do
   begin
      Close;
      SQL.Clear;
      SQL.Add(' SELECT CUR_TYPE, CUR_ABBR, CUR_NAME_KOR '+
              ' FROM   SCCURTP_TBL                      '+
              ' ORDER  BY CUR_ABBR                      ');
      try
         gf_ADOQueryOpen(ADOQuery_TEMP);
      except
         on E : Exception do
         begin
            gf_ShowErrDlgMessage(Self.Tag, 9001,
                                 'ADOQuery_TEMP[SCCURTP_TBL]: ' + E.Message, 0);// DataBase 오류
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_TEMP[SCCURTP_TBL]'); //Database 오류
            Exit;
         end;
      end;

      DRUserCodeCombo_Currency.ClearItems;
      while not Eof do
      begin
         DRUserCodeCombo_Currency.AddItem(Trim(FieldByName('CUR_TYPE').asString),
             Trim(FieldByName('CUR_ABBR').asString) + ' -' +
             Trim(FieldByName('CUR_NAME_KOR').asString));
         Next;
      end;

   end; //end of with

   result := True;
end;

//---------------------------------------------------------------------------
//  계좌별 환율 조회
//  [SUAXRAT_TBL]
//---------------------------------------------------------------------------
function TForm_SCF_ExRate.GetACCExchange(Currency, TradeDate: String): Boolean;
var
   iRow : Integer;
begin
   result := False;

   iRow := 0;
   ExRateCnt := 0;

   with ADOQuery_Exchange do begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT A.DEPT_CODE, A.ACC_NO, A.ACC_NAME_KOR,'
             +'       X.BUY_MKT_RATE, X.SELL_MKT_RATE,      '
             +'       X.BUY_RATE, X.SELL_RATE, A.CUR_TYPE,  '
             +'       ISDAT = CASE ISNULL(X.ACC_NO,'''') WHEN '''' THEN ''N'' '
             +'				   ELSE ''Y'' END                '
             +'   FROM SEACBIF_TBL A, SUAXRAT_TBL X         '
             +'  WHERE A.DEPT_CODE *= X.DEPT_CODE           '
             +'    AND A.ACC_NO    *= X.ACC_NO              '
             +'    AND A.CUR_TYPE   = ''' + Currency + '''  '
             +'    AND X.TRADE_DATE = ''' + TradeDate + ''' '
             +'    ORDER BY A.ACC_NO                        ');

      try
         gf_ADOQueryOpen(ADOQuery_Exchange);
      except
         on E : Exception do
         begin
            gf_ShowMessage(MessageBar, mtError, 9001, 'SUSTLDT_TBL[Select]'); //Database 오류
            Exit;
         end;
      end;

      if RecordCount <= 0 then Exit;

      while not EOF do begin
         Inc(iRow);
         SetLength(ExRateLst, iRow);

         ExRateLst[iRow-1].Grdidx    := iRow;
         ExRateLst[iRow-1].DeptCode  := Trim(FieldByName('DEPT_CODE').AsString);
         ExRateLst[iRow-1].TradeDate := DRMaskEdit_TradeDate.Text;
         ExRateLst[iRow-1].AccNo     := Trim(FieldByName('ACC_NO').AsString);
         ExRateLst[iRow-1].AccName   := Trim(FieldByName('ACC_NAME_KOR').AsString);
         ExRateLst[iRow-1].CurType   := Trim(FieldByName('CUR_TYPE').AsString);
         ExRateLst[iRow-1].BuyRate   := FieldByName('BUY_RATE').AsFloat;
         ExRateLst[iRow-1].SelRate   := FieldByName('SELL_RATE').AsFloat;
         ExRateLst[iRow-1].BuyMktRate:= FieldByName('BUY_MKT_RATE').AsFloat;
         ExRateLst[iRow-1].SelMktRate:= FieldByName('SELL_MKT_RATE').AsFloat;
         ExRateLst[iRow-1].IsUpdate  := False;
         ExRateLst[iRow-1].IsDataYN  := FieldByName('ISDAT').AsString;

         Next;
      end;

      ExRateCnt := iRow;

   end;
   result := True;
end;

function TForm_SCF_ExRate.DisplayGrid: Boolean;
var
   i : Integer;
begin

   if ExRateCnt <=0 then begin
      gf_ShowMessage(MessageBar, mtInformation, 1021, '자료갯수' + '(0)');
      Exit;
   end;

   with DRStrGrid_Main do begin

      for i:=0 to ExRateCnt-1 do begin
         Rows[i+1].Clear;
         ColorRow[i+1] := gcSubGridSelectColor;

         {
         RowFont[i+1].Color        := CurFontColor;
         SelectedFontColorRow[i+1] := CurFontColor;
         if CurAccNo <> ExRateLst[i].AccNo then begin
            CurIdx     := ExRateLst[i].CurIdx;
            CurAccNo   := ExRateLst[i].AccNo;
            CurAccName := ExRateLst[i].AccName;
         end;
         }

         //계좌번호
         Cells[ACCNO_COL,   i+1] := ExRateLst[i].AccNo;
         //계좌명
         Cells[ACCNAME_COL, i+1] := ExRateLst[i].AccName;
         //적용매수
         Cells[BUYRATE_COL, i+1] := FloattoStr(ExRateLst[i].BuyRate);
         //적용매도
         Cells[SELRATE_COL, i+1] := FloattoStr(ExRateLst[i].SelRate);
         //시장매수
         Cells[BUYMKT_COL,  i+1] := FloattoStr(ExRateLst[i].BuyMktRate);
         //시장매도
         Cells[SELMKT_COL,  i+1] := FloattoStr(ExRateLst[i].SelMktRate);

      end;

      RowCount := ExRateCnt + 1;
   end;

   gf_ShowMessage(MessageBar, mtInformation, 1021, '자료갯수' + '(' + IntToStr(ExRateCnt) + ')');
end;

//------------------------------------------------------------------------------
//  화면 초기화
//------------------------------------------------------------------------------
procedure TForm_SCF_ExRate.ClearDisplayGrid;
begin
  DRStrGrid_Main.RowCount := 2;
  DRStrGrid_Main.Rows[1].Clear;
  gf_ClearMessage(MessageBar);
end;

procedure TForm_SCF_ExRate.DRStrGrid_MainAfterEdit(Sender: TObject; col, row: Integer);
var
   i, idx : Integer;
   nValue : Double;
begin
  inherited;

   if row <= 0 then Exit;
   if col <= 1 then Exit;
   if DRStrGrid_Main.Cells[col,row] = '' then Exit;
   if ExRateCnt = 0 then Exit;

   idx := GetItemidx(row);

   if idx < 0 then Exit;

   nValue := StrToFloat(DRStrGrid_Main.Cells[col, row]);

   case col of
      BUYRATE_COL  : ExRateLst[idx].BuyRate    := nValue;
      SELRATE_COL  : ExRateLst[idx].SelRate    := nValue;
      BUYMKT_COL   : ExRateLst[idx].BuyMktRate := nValue;
      SELMKT_COL   : ExRateLst[idx].SelMktRate := nValue;
   end;
   ExRateLst[idx].IsUpdate  := True;

   if not DRCheckBox_ApplyALL.Checked then Exit;

   for i:=row + 1 to DRStrGrid_Main.RowCount-1 do begin
      idx := GetItemidx(i);
      case col of
         BUYRATE_COL  : ExRateLst[idx].BuyRate    := nValue;
         SELRATE_COL  : ExRateLst[idx].SelRate    := nValue;
         BUYMKT_COL   : ExRateLst[idx].BuyMktRate := nValue;
         SELMKT_COL   : ExRateLst[idx].SelMktRate := nValue;
      end;
      ExRateLst[idx].IsUpdate  := True;
   end;

   DisplayGrid;

end;

function TForm_SCF_ExRate.GetItemidx(GrdNo: Integer): Integer;
var
   i : Integer;
begin
   for i:=0 to ExRateCnt-1 do begin

      if ExRateLst[i].Grdidx <> GrdNo then continue;
      result := i;
      Exit;
   end;
end;

procedure TForm_SCF_ExRate.InsertParamData(ADOQuery: TADOQuery; idx : Integer);
begin
   with ADOQuery do begin
      Parameters.ParamByName('DEPT_CODE').Value  := ExRateLst[idx].DeptCode;
      Parameters.ParamByName('TRADE_DATE').Value := ExRateLst[idx].TradeDate;
      Parameters.ParamByName('ACC_NO').Value     := ExRateLst[idx].AccNo;
      Parameters.ParamByName('CUR_TYPE').Value   := ExRateLst[idx].CurType;
      Parameters.ParamByName('BUY_RATE').Value   := ExRateLst[idx].BuyRate;
      Parameters.ParamByName('SELL_RATE').Value  := ExRateLst[idx].SelRate;
      Parameters.ParamByName('BUY_MKT_RATE').Value  := ExRateLst[idx].BuyMktRate;
      Parameters.ParamByName('SELL_MKT_RATE').Value := ExRateLst[idx].SelMktRate;
      Parameters.ParamByName('OPR_ID').Value   := gvOprUsrNo;
      Parameters.ParamByName('OPR_DATE').Value := FormatDateTime('yyyymmdd', now);
      Parameters.ParamByName('OPR_TIME').Value := FormatDateTime('hhmmssnnn',now);
   end;

   try
      gf_ADOExecSQL(ADOQuery);
   except
      on E : Exception do
      begin
         Exit;
      end;
   end;
end;

procedure TForm_SCF_ExRate.DRMaskEdit_KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

   if Key = #13 then
   begin
      // 입력 일자 확인
      if (Trim(DRMaskEdit_TradeDate.Text) = '') or
       (not gf_CheckValidDate(DRMaskEdit_TradeDate.Text)) then
      begin
         gf_ShowMessage(MessageBar, mtError, 1040, ''); //일자 입력 오류
         DRMaskEdit_TradeDate.SetFocus;
         DRMaskEdit_TradeDate.SelectAll;
         Exit;
      end
      else
      begin
        if DRUserCodeCombo_Currency.Code > '' then
        begin
          DRBitBtn3Click(nil);
          Exit;
        end;
      end;
      DRUserCodeCombo_Currency.SetFocus;
   end;

end;

procedure TForm_SCF_ExRate.DRUserCodeCombo_CurrencyEditKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
   if Key = #13 then DRBitBtn3Click(Sender);
end;

procedure TForm_SCF_ExRate.DRStrGrid_MainSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  OldSelRowIdx := SelRowIdx;
  SelColIdx := ACol;
  SelRowIdx := ARow;

//  if BlockStartRowIdx <= 0 then BlockStartRowIdx := OldSelRowIdx;

  if OldSelRowIdx > 0 then DRStrGrid_Main.ColorRow[OldSelRowIdx] := gcSubGridSelectColor;
  if SelRowIdx > 0 then DRStrGrid_Main.ColorRow[SelRowIdx] := gcGridSelectColor;

end;

procedure TForm_SCF_ExRate.DRUserCodeCombo_CurrencyCodeChange(
  Sender: TObject);
begin
  inherited;
  if DRMaskEdit_TradeDate.Text > '' then DRBitBtn3Click(nil);

end;

end.


