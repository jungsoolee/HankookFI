//==============================================================================
//  [jykim] 2001/12/27
//==============================================================================
unit SCCRegEmailAddr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCCDlgForm, Buttons, DRAdditional, DRStandard, ComCtrls, DRWin32,
  StdCtrls, ExtCtrls, DRSpecial, Db, ADODB, Grids, DRStringgrid, DRDialogs,
  DrStringPrintU;

type
  TDlgForm_RegEmailAddr = class(TForm_Dlg)
    DRPanel1: TDRPanel;
    ADOQuery_SUMELAD: TADOQuery;
    DRPanel: TDRPanel;
    DRPanel_Edit: TDRPanel;
    DRLabel1: TDRLabel;
    DRLabel2: TDRLabel;
    DRLabel25: TDRLabel;
    DREdit_OprID: TDREdit;
    DREdit_OprTime: TDREdit;
    DREdit_MailRcv: TDREdit;
    DRStrGrid_MailAddrInsert: TDRStringGrid;
    DREdit_SendSeq: TDREdit;
    DRBitBtn5: TDRBitBtn;
    DRBitBtn6: TDRBitBtn;
    DREdit_Addr1: TDREdit;
    DREdit_Addr2: TDREdit;
    DREdit_Addr3: TDREdit;
    DREdit_Addr4: TDREdit;
    DREdit_Addr5: TDREdit;
    DrStringPrint1: TDrStringPrint;
    function  QueryToList : boolean;
    function  SearchList(pMailRcv, pMailAddr : string) : integer;
    procedure DisplayData;
    procedure ClearInputValue;
    procedure ClearMailAddrBookList;
    procedure FormCreate(Sender: TObject);
    procedure DRBitBtn4Click(Sender: TObject);
    procedure DRBitBtn3Click(Sender: TObject);
    procedure DRBitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DRStrGrid_MailAddrInsertMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure DRStrGrid_MailAddrInsertDblClick(Sender: TObject);
    procedure DRBitBtn5Click(Sender: TObject);
    procedure DREdit_MailRcvKeyPress(Sender: TObject; var Key: Char);
    procedure DREdit_MailAddrKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure DRStrGrid_MailAddrInsertFiexedRowClick(Sender: TObject;
      ACol: Integer);
    procedure DRBitBtn6Click(Sender: TObject);
    procedure DRMemo_MailAddrKeyPress(Sender: TObject; var Key: Char);
    procedure DREdit_Addr1KeyPress(Sender: TObject; var Key: Char);
    procedure DREdit_Addr5KeyPress(Sender: TObject; var Key: Char);
  private
    function GetAllAddr: string;
    procedure AddrToEdit(sAddr: string);
    function HintAddr(sAddr: string): string;
    function CheckAddr: Boolean;
    { Private declarations }
  public
    { Public declarations }
    PubMailRcv : string;
    PubMailAddr : string;
  end;

var
  DlgForm_RegEmailAddr: TDlgForm_RegEmailAddr;

implementation

{$R *.DFM}
uses
  SCCGlobalType,SCCLib, SCCCmuLib, StrUtils;
//  SCCLib, SCCGlobalType, SCCCmuLib;

Type
  TMailAddrBook = record
     SendSeq      : integer;
     MailRcv      : string;
     MailAddr     : string;
     OprId        : string;
     OprDate      : string;
     OprTime      : string;
  end;
  pTMailAddrBook = ^TMailAddrBook;

Const
  RCV_COMP_IDX = 0;
  MailAddr_IDX = 1;

var
   MailAddrBook : TList;
   InsFlag, ModFlag : boolean;          // 입력, 수정, 삭제 여부
   SelRowIdx : integer;
   SortIdx     : Integer;               // Sorting 기준 Column Index
   SortFlag : array [0..1] of boolean;  // Column별 Sort Status



//------------------------------------------------------------------------------
//  List Sorting
//------------------------------------------------------------------------------
function MailAddrBookCompare(Item1, Item2: Pointer): Integer;
begin
   case SortIdx of
      // 수신처
      0: Result := gf_ReturnStrComp(pTMailAddrBook(Item1).MailRcv,
                                    pTMailAddrBook(Item2).MailRcv,
                                    SortFlag[SortIdx]);
      // 이메일주소
      1: Result := gf_ReturnStrComp(pTMailAddrBook(Item1).MailAddr,
                                    pTMailAddrBook(Item2).MailAddr,
                                    SortFlag[SortIdx]);
      else
         Result := 0;                              
   end;
end;
         
//------------------------------------------------------------------------------
// Form Create
//------------------------------------------------------------------------------
procedure TDlgForm_RegEmailAddr.FormCreate(Sender: TObject);
begin
  inherited;
   with DRStrGrid_MailAddrInsert do
   begin
      Color             := gcGridBackColor;
      SelectedCellColor := gcGridSelectColor;
      RowCount := 2;
      Rows[1].Clear;
   end;  // end of with

   DREdit_MailRcv.Color  := gcQueryEditColor;
//   DREdit_MailAddr.Color := gcQueryEditColor;
   DREdit_Addr1.Color := gcQueryEditColor;

   SortIdx   := RCV_COMP_IDX;        // 수신처명
   SortFlag[RCV_COMP_IDX] := True;   // Ascending Sorting

   InsFlag := False;  // 입력
   ModFlag := False;  // 수정, 삭제

  if gvDeptCode = gcDEPT_CODE_INT then // 국제부
      DREdit_MailRcv.ImeMode := imSAlpha;


   MailAddrBook := TList.Create;
   if not Assigned(MailAddrBook) then
   begin
      gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); // List 생성 오류
      Close;
      Exit;
   end;

   if not QueryToList then
   begin
      Close;
      Exit;
   end;
   DisplayData;

end;

//------------------------------------------------------------------------------
// Form Close
//------------------------------------------------------------------------------
procedure TDlgForm_RegEmailAddr.FormClose(Sender: TObject; var Action: TCloseAction);
var
   iRtnValue : Integer;
begin
  inherited;
   if Assigned(MailAddrBook) then
   begin
      ClearMailAddrBookList;
      MailAddrBook.Free;
   end;
   // Data 변경 여부 리턴
   iRtnValue := gcMR_NONE;
   if InsFlag then  // Insert
      iRtnValue := gcMR_INSERTED;
   if ModFlag then  // Update, Delete
      iRtnValue := gcMR_MODIFIED;
   ModalResult := iRtnValue;

end;


//------------------------------------------------------------------------------
// QueryToList
//------------------------------------------------------------------------------
function TDlgForm_RegEmailAddr.QueryToList: boolean;
var
   MailAddrItem : pTMailAddrBook;
begin
   Result := false;
   ClearMailAddrBookList;
   with ADOQuery_SUMELAD do
   begin
      Close;
      SQL.Clear;
      SQL.Add(' SELECT SEND_SEQ, MAIL_ADDR, RCV_COMP_KOR '
            + '        ,OPR_ID,    OPR_DATE, OPR_TIME    '
            + ' FROM   SUMELAD_TBL '
            + ' WHERE DEPT_CODE = ''' + gvDeptCode + ''' '
            + ' ORDER BY RCV_COMP_KOR  ');

      Try
         gf_ADOQueryOpen(ADOQuery_SUMELAD);
      Except
         on E : Exception do
         begin
            // Database 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUMELAD[SUMELAD_TBL]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUMELAD[SUMELAD_TBL]'); // Database 오류
            Exit;
         end;
      end;

      while not EOF do
      begin
         new(MailAddrITem);
         MailAddrBook.Add(MailAddrITem);

         MailAddrItem.SendSeq := FieldbyName('SEND_SEQ').asInteger;

         MailAddrITem.MailRcv := Trim(FieldByname('RCV_COMP_KOR').asString);
         MailAddrItem.MailAddr:= Trim(FieldByname('MAIL_ADDR').asString);
         MailAddrItem.OprId   := Trim(FieldByname('OPR_ID').asString);
         MailAddrITem.OprDate := Trim(FieldByname('OPR_DATE').asString);
         MailAddrITem.OprTime := Trim(FieldByname('OPR_TIME').asString);

         next;
      end;
      // List Sorting
      MailAddrbook.Sort(MailAddrBookCompare);

   end;
   Result := true;
end;


//------------------------------------------------------------------------------
// DataDisplayToGrid
//------------------------------------------------------------------------------
procedure TDlgForm_RegEmailAddr.DisplayData;
var
    iRow, i : integer;
    MailAddrItem : pTMailAddrBook;
begin
   if MailAddrBook.Count <= 0 then
   begin
      DRStrGrid_MailAddrInsert.RowCount := 2;
      DRStrGrid_MailAddrInsert.Rows[1].Clear;
      DRStrGrid_MailAddrInsert.HintCell[MailAddr_IDX, 1] := ''; 
      exit;
   end;

   with  DRStrGrid_MailAddrInsert do
   begin
      Rowcount := MailAddrBook.Count + 1;
      iRow := 0;
      for i := 0 to MailAddrBook.Count -1 do
      begin
         MailAddrItem := MailAddrBook.Items[i];
         inc(iRow);
         Cells[Rcv_Comp_IDx, iRow] := MailAddrITem.MailRcv;
         Cells[MailAddr_IDX, iRow] := MailAddrITem.MailAddr;
         HintCell[MailAddr_IDX, iRow] := HintAddr(MailAddrITem.MailAddr);
      end;
   end;
end;

//------------------------------------------------------------------------------
// 조회
//------------------------------------------------------------------------------
procedure TDlgForm_RegEmailAddr.DRBitBtn6Click(Sender: TObject);
begin
  inherited;
   gf_ClearMessage(MessageBar);
   ClearInputValue;  // Clear
   DisableForm;
   if not QueryToList then
   begin
      EnableForm;
      Exit;
   end;
   DisplayData;
   EnableForm;
   DREdit_MailRcv.SetFocus;

   InsFlag := False;  // 입력
   ModFlag := False;  // 수정, 삭제

end;

function TDlgForm_RegEmailAddr.GetAllAddr : string;
var sAddr : string;
begin
  Result := '';

  DREdit_Addr1.Text := StringReplace(DREdit_Addr1.Text,',','',[rfReplaceAll]);
  DREdit_Addr2.Text := StringReplace(DREdit_Addr2.Text,',','',[rfReplaceAll]);
  DREdit_Addr3.Text := StringReplace(DREdit_Addr3.Text,',','',[rfReplaceAll]);
  DREdit_Addr4.Text := StringReplace(DREdit_Addr4.Text,',','',[rfReplaceAll]);
  DREdit_Addr5.Text := StringReplace(DREdit_Addr5.Text,',','',[rfReplaceAll]);

  DREdit_Addr1.Text := StringReplace(DREdit_Addr1.Text,';;',';',[rfReplaceAll]);
  DREdit_Addr2.Text := StringReplace(DREdit_Addr2.Text,';;',';',[rfReplaceAll]);
  DREdit_Addr3.Text := StringReplace(DREdit_Addr3.Text,';;',';',[rfReplaceAll]);
  DREdit_Addr4.Text := StringReplace(DREdit_Addr4.Text,';;',';',[rfReplaceAll]);
  DREdit_Addr5.Text := StringReplace(DREdit_Addr5.Text,';;',';',[rfReplaceAll]);


  sAddr := '';
  if (DREdit_Addr1.Text > '') then
  begin
    if (Copy(DREdit_Addr1.Text, Length(DREdit_Addr1.Text), 1) <> ';') then sAddr := sAddr + DREdit_Addr1.Text +';'
    else sAddr := sAddr + DREdit_Addr1.Text;
  end;

  if (DREdit_Addr2.Text > '') then
  begin
    if (Copy(DREdit_Addr2.Text, Length(DREdit_Addr2.Text), 1) <> ';') then sAddr := sAddr + DREdit_Addr2.Text +';'
    else sAddr := sAddr + DREdit_Addr2.Text;
  end;

  if (DREdit_Addr3.Text > '') then
  begin
    if (Copy(DREdit_Addr3.Text, Length(DREdit_Addr3.Text), 1) <> ';') then sAddr := sAddr + DREdit_Addr3.Text +';'
    else  sAddr := sAddr + DREdit_Addr3.Text ;
  end;
  if (DREdit_Addr4.Text > '') then
  begin
    if (Copy(DREdit_Addr4.Text, Length(DREdit_Addr4.Text), 1) <> ';') then sAddr := sAddr + DREdit_Addr4.Text +';'
    else  sAddr := sAddr + DREdit_Addr4.Text;
  end;
  if (DREdit_Addr5.Text > '') then
  begin
    if (Copy(DREdit_Addr5.Text, Length(DREdit_Addr5.Text), 1) <> ';') then sAddr := sAddr + DREdit_Addr5.Text +';'
    else sAddr := sAddr + DREdit_Addr5.Text;

  end;

  Result := sAddr;
end;

//------------------------------------------------------------------------------
// 입력
//------------------------------------------------------------------------------
procedure TDlgForm_RegEmailAddr.DRBitBtn5Click(Sender: TObject);
var
   iSendSeq, i : Integer;
   MailRcv, MailAddr, sTemp : string;
begin
  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1010, ''); //입력 중입니다.

   //입력누락확인
   if DREdit_MailRcv.text = '' then
   begin
      gf_ShowMessage(MessageBar, mtError, 1012, ''); //입력 오류
      DREdit_MailRcv.SetFocus;
      Exit;
   end;

   if Not (CheckAddr) then
   begin
      gf_ShowErrDlgMessage(0,0,'이메일주소란에 콤마(,)는 입력 불가합니다.' // 세미콜론(;)과 콤마(,)는 입력 불가합니다. 2017.10.16 세미콜론(;) 허용..! 한투 윤선주
                             +#13#10+#13#10 + '이메일주소는 최대 5개까지만 입력가능합니다.'  ,0);
      gf_ShowMessage(MessageBar, mtError, 1012, ''); //입력 오류
      //DREdit_Addr1.SetFocus;
      Exit;
   end;


   MailAddr := GetAllAddr;
   if MailAddr = '' then
   begin
      gf_ShowMessage(MessageBar, mtError, 1012, ''); //입력 오류
      DREdit_Addr1.SetFocus;
      Exit;
   end;

   {
   if (Copy(MailAddr, Length(MailAddr), 1)) = ';' then
   begin
      MailAddr := Copy(MailAddr, 1, Length(MailAddr)-1);
      //showmessage(MailAddr);
   end;
   }

   if Length(MailAddr) > 210 then
   begin
      gf_ShowErrDlgMessage(0,0,'이메일주소 자릿수 합이 200을 초과할 수 없습니다.'
                             +#13#10+#13#10 + '다른 이름으로 추가 입력하십시오.'  ,0);
      gf_ShowMessage(MessageBar, mtError, 1012, ''); //입력 오류
      DREdit_Addr1.SetFocus;
      Exit;
   end;


   MailRcv  := Trim(DREdit_MailRcv.Text);

   DisableForm;
   //-------------------
   gf_BeginTransaction;    // 채번을 위해!
   //-------------------
   with ADOQuery_SUMELAD do
   begin
      // 해당 데이터 존재하는지 확인
      Close;
      SQL.Clear;
      SQL.Add(' Select SEND_SEQ, RCV_COMP_KOR '
            + ' From SUMELAD_TBL with (TABLOCKX, HOLDLOCK) ' // Locking-!
            + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
//            + '   and RCV_COMP_KOR = ''' + MailRcv + ''' '
            + '   and MAIL_ADDR = ''' + MailAddr + ''' ');
      Try
         gf_ADOQueryOpen(ADOQuery_SUMELAD);
      Except
         on E : Exception do
         begin // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUMELAD[SendSeq]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUMELAD[SendSeq]'); //Database 오류
            gf_RollbackTransaction;
            EnableForm;
            Exit;
         end;
      End;

      if RecordCount > 0 then // 해당 데이터가 존재하는 경우
      begin
         gf_ShowMessage(MessageBar, mtError, 1066, ''); // 해당 수신처는 이미 등록되어 있습니다.
         gf_RollbackTransaction;
         EnableForm;
         SearchList('',MailAddr);
         DREdit_Addr1.SetFocus;
         Exit;
      end;

      // 채번
      Close;
      SQL.Clear;
      SQL.Add(' Select MAX_SEND_SEQ = ISNULL(MAX(SEND_SEQ), 0) '
            + ' From SUMELAD_TBL '
            + ' Where DEPT_CODE = ''' + gvDeptCode + ''' ');

      Try
         gf_ADOQueryOpen(ADOQuery_SUMELAD);
      Except
         on E : Exception do
         begin // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUMELAD[SendSeq]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUMELAD[SendSeq]'); //Database 오류
            gf_RollbackTransaction;
            EnableForm;
            Exit;
         end;
      End;
      iSendSeq := FieldByName('MAX_SEND_SEQ').asInteger + 1;

      // Insert
      Close;
      SQL.Clear;
      SQL.Add(' Insert SUMELAD_TBL '
            + ' (DEPT_CODE, SEND_SEQ, MAIL_ADDR, RCV_COMP_KOR, '
            + '  OPR_ID, OPR_DATE, OPR_TIME) '
            + ' Values '
            + ' (:pDeptCode, :pSendSeq, :pMailAddr, :pRcvCompKor, '
            + '  :pOprId, :pOprDate, :pOprTime) ');
      Parameters.ParamByName('pDeptCode').Value   := gvDeptCode;
      Parameters.ParamByName('pSendSeq').Value    := iSendSeq;
      Parameters.ParamByName('pRcvCompKor').Value := DREdit_MailRcv.Text;
      Parameters.ParamByName('pMailAddr').Value   := MailAddr;
      Parameters.ParamByName('pOprId').Value      := gvOprUsrNo;
      Parameters.ParamByName('pOprDate').Value    := gvCurDate;
      Parameters.ParamByName('pOprTime').Value    := gf_GetCurTime;
      Try
         gf_ADOExecSQL(ADOQuery_SUMELAD);
      Except
         on E : Exception do
         begin // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUMELAD[Insert]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUMELAD[Insert]'); //Database 오류
            gf_RollbackTransaction;
            EnableForm;
            Exit;
         end;
      End;
   end;
   
   //-------------------
   gf_CommitTransaction;
   //-------------------
   InsFlag := True;

   if not QueryToList then
   begin
      EnableForm;
      Exit;
   end;
   DisplayData;
   EnableForm;
   SearchList(MailRcv, MailAddr);
   ClearInputValue;  // Clear
   DREdit_MailRcv.SetFocus;
   gf_ShowMessage(MessageBar, mtInformation, 1011, ''); // 입력 완료
end;


//------------------------------------------------------------------------------
// 수정
//------------------------------------------------------------------------------
procedure TDlgForm_RegEmailAddr.DRBitBtn4Click(Sender: TObject);
var
   i : integer;
   MailRcv, MailAddr, iSendSeq : string;
begin
  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1007, ''); // 수정 중입니다.
   //입력누락확인
   if DREdit_MailRcv.text = '' then
   begin
      gf_ShowMessage(MessageBar, mtError, 1012, ''); //입력 오류
      DREdit_MailRcv.SetFocus;
      Exit;
   end;

   if Not (CheckAddr) then
   begin
      gf_ShowErrDlgMessage(0,0,'이메일주소란에 콤마(,)는 입력 불가합니다.'
                             +#13#10+#13#10 + '이메일주소는 최대 5개까지만 입력가능합니다.'  ,0);
      gf_ShowMessage(MessageBar, mtError, 1012, ''); //입력 오류
      DREdit_Addr1.SetFocus;
      Exit;
   end;

   MailAddr := GetAllAddr;
   if MailAddr = '' then
   begin
      gf_ShowMessage(MessageBar, mtError, 1012, ''); //입력 오류
      DREdit_Addr1.SetFocus;
      Exit;
   end;
   {
   if (Copy(MailAddr, Length(MailAddr), 1)) = ';' then
   begin
      MailAddr := Copy(MailAddr, 1, Length(MailAddr)-1);
      //showmessage(MailAddr);
   end;
   }

   if Length(MailAddr) > 210 then
   begin
      gf_ShowErrDlgMessage(0,0,'이메일주소 자릿수 합이 200을 초과할 수 없습니다.'
                             +#13#10+#13#10 + '다른 이름으로 추가 입력하십시오.'  ,0);
      gf_ShowMessage(MessageBar, mtError, 1012, ''); //입력 오류
      DREdit_Addr1.SetFocus;
      Exit;
   end;
   
   MailRcv  := Trim(DREdit_MailRcv.Text);
//   MailAddr := Trim(DREdit_MailAddr.Text);
   iSendSeq := Trim(DREdit_SendSeq.Text);

   DisableForm;
   with ADOQuery_SUMELAD do
   begin
      //--- 해당 데이터 존재하는지 iSendSeq로 비교
      Close;
      SQL.Clear;
      SQL.Add(' Select RCV_COMP_KOR '
            + ' From SUMELAD_TBL '
            + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
            + '   and SEND_SEQ = ''' + iSendSeq + ''' ');
      Try
         gf_ADOQueryOpen(ADOQuery_SUMELAD);
      Except
         on E : Exception do
         begin // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUMELAD[Select]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUMELAD[Select]'); //Database 오류
            EnableForm;
            Exit;
         end;
      End;

      if RecordCount <= 0 then  // 해당 데이터 존재하지 않는경우
      begin
         gf_ShowMessage(MessageBar, mtError, 1025, ''); //해당 자료가 존재하지 않습니다.
         EnableForm;
         DREdit_Addr1.SetFocus;
         Exit;
      end;

      //--- 해당 데이터 존재하는지 MailAddr로 비교
      Close;
      SQL.Clear;
      SQL.Add(' Select SEND_SEQ, RCV_COMP_KOR '
            + ' From SUMELAD_TBL '
            + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
            + '   and MAIL_ADDR = ''' + MailAddr + ''' ');

      Try
         gf_ADOQueryOpen(ADOQuery_SUMELAD);
      Except
         on E : Exception do
         begin // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUMELAD[Select]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUMELAD[Select]'); //Database 오류
            EnableForm;
            Exit;
         end;
      End;

      if RecordCount > 0 then // 해당 데이터가 존재하는 경우
      begin
         if iSendSeq <> Trim(FieldByname('SEND_SEQ').asString) then
         begin
            gf_ShowMessage(MessageBar, mtError, 1066, ''); // 해당 수신처는 이미 등록되어 있습니다.
            EnableForm;
            SearchList('',MailAddr);
            DREdit_Addr1.SetFocus;
            Exit;
         end;
      end;

      //--- Update
      Close;
      SQL.Clear;
      SQL.Add(' Update SUMELAD_TBL '
            + ' Set RCV_COMP_KOR = ''' + DREdit_MailRcv.Text + ''', '
            + '     MAIL_ADDR    = ''' + MailAddr + ''', '
            + '     OPR_ID       = ''' + gvOprUsrNo + ''', '
            + '     OPR_DATE     = ''' + gvCurDate + ''', '
            + '     OPR_TIME     = ''' + gf_GetCurTime + ''' '
            + ' Where DEPT_CODE  = ''' + gvDeptCode + ''' '
            + '   and SEND_SEQ   = ''' + iSendSeq + ''' ');
      Try
         gf_ADOExecSQL(ADOQuery_SUMELAD);
      Except
         on E : Exception do
         begin // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUMELAD[Update]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUMELAD[Update]'); //Database 오류
            EnableForm;
            Exit;
         end;
      End;
   end; // end of if Update

   ModFlag := True;
   if not QueryToList then
   begin
      EnableForm;
      Exit;
   end;
   DisplayData;
   EnableForm;
   SearchList(MailRcv, MailAddr);
   ClearInputValue;  // Clear
   DREdit_MailRcv.SetFocus;
   gf_ShowMessage(MessageBar, mtInformation, 1008, ''); // 수정 완료
end;

//------------------------------------------------------------------------------
// 삭제
//------------------------------------------------------------------------------
procedure TDlgForm_RegEmailAddr.DRBitBtn3Click(Sender: TObject);
var
   iUsedGrpCnt, i : Integer;
   UsedList, MailRcv, MailAddr, iSendSeq, DeleteStr : string;
begin
  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1005, ''); // 삭제 중입니다.

   //입력누락확인
   if DREdit_MailRcv.text = '' then
   begin
      gf_ShowMessage(MessageBar, mtError, 1012, ''); //입력 오류
      DREdit_MailRcv.SetFocus;
      Exit;
   end;

   MailAddr := GetAllAddr;
   if MailAddr = '' then
   begin
      gf_ShowMessage(MessageBar, mtError, 1012, ''); //입력 오류
      DREdit_Addr1.SetFocus;
      Exit;
   end;

   MailRcv  := Trim(DREdit_MailRcv.Text);
//   MailAddr := Trim(DREdit_MailAddr.Text);

   iSendSeq := Trim(DREdit_SendSeq.Text);

   DeleteStr := '( 수신처 :' + MailRcv + ')';

   DisableForm;
   with ADOQuery_SUMELAD do
   begin
      //--- 해당 데이터 존재하는지 재확인
      Close;
      SQL.Clear;
      SQL.Add(' Select RCV_COMP_KOR '
            + ' From SUMELAD_TBL '
            + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
            + '   and SEND_SEQ = ''' + iSendSeq + ''' ');
      Try
         gf_ADOQueryOpen(ADOQuery_SUMELAD);
      Except
         on E : Exception do
         begin // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUMELAD[SUMELAD_TBL SELECT]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUMELAD[SUMELAD_TBL SELECT]'); //Database 오류
            EnableForm;
            Exit;
         end;
      End;

      if RecordCount <= 0 then  // 해당 데이터 존재하지 않는경우
      begin
         gf_ShowMessage(MessageBar, mtError, 1025, ''); //해당 자료가 존재하지 않습니다.
         EnableForm;
         DREdit_Addr1.SetFocus;
         Exit;
      end;

      //--- SUGPMAD_TBL에서  해당 수신처가 사용되는지 확인
      Close;
      SQL.Clear;
      SQL.Add(' Select M.GRP_NAME, M.SEC_TYPE        '
            + ' From SUGPMAD_TBL M, SUAGPAC_TBL C    '
            + ' Where M.DEPT_CODE = ''' + gvDeptCode + ''' '
            + '   and M.SEND_SEQ  = ''' + iSendSeq   + ''' '
            + '   AND M.DEPT_CODE = C.DEPT_CODE      '
            + '   AND M.SEC_TYPE  = C.SEC_TYPE       '
            + '   AND M.GRP_NAME  = C.GRP_NAME       '
            + '  Group by M.GRP_NAME, M.SEC_TYPE ');
      Try
         gf_ADOQueryOpen(ADOQuery_SUMELAD);
      Except
         on E : Exception do
         begin // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUMELAD[SUGPMAD_TBL SELECT]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUMELAD[SUGPMAD_TBL SELECT]'); //Database 오류
            EnableForm;
            Exit;
         end;
      End;

      UsedList := '';  // Clear
      iUsedGrpCnt := RecordCount;
      if iUsedGrpCnt > 0 then // 사용기관 있는경우
      begin
         while not Eof do
         begin
            UsedList := UsedList + ' [등록그룹] ' +
                         gf_SecTypeToName(Trim(FieldByName('SEC_TYPE').asString)) +
                         '-' +
                         Trim(FieldByName('GRP_NAME').asString) +  Chr(13);
            Next;
         end;  // end of while
      end;  // end of if

      if iUsedGrpCnt > 0 then // Data 없는 경우
      begin
          gf_ShowDlgMessage(Self.Tag, mtWarning, 1141, //해당 수신처를 참조하는 계좌 및 그룹 전송이 있습니다.
          UsedList + Chr(13) + '삭제할 수 없습니다', [mbOK], 0);
          gf_ShowMessage(MessageBar, mtInformation, 1082, ''); //작업이 취소되었습니다.
          EnableForm;
          Exit;
      end; // end of if

      //-------------------
      gf_BeginTransaction;
      //-------------------
      //--- Delete SUMELAD_TBL
      Close;
      SQL.Clear;
      SQL.Add(' Delete SUMELAD_TBL '
            + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
            + '   and SEND_SEQ = ''' + iSendSeq + ''' ' );
      Try
         gf_ADOExecSQL(ADOQuery_SUMELAD);
      Except
         on E : Exception do
         begin // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUMELAD[SUMELAD_TBL DELETE]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUMELAD[SUMELAD_TBL DELETE]'); //Database 오류
            gf_RollBackTransaction;
            EnableForm;
            Exit;
         end;
      End;
{
      if iUsedGrpCnt > 0 then  // 사용그룹 있는 경우
      begin
         //--- Delete SUGPMAD_TBL
         Close;
         SQL.Clear;
         SQL.Add(' Delete SUGPMAD_TBL '
               + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
               + '   and SEND_SEQ  = ''' + iSendSeq + '''' );
         Try
            gf_ADOExecSQL(ADOQuery_SUMELAD);
         Except
            on E : Exception do
            begin // DataBase 오류
               gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUMELAD[SUGPMAD_TBL DELETE]: ' + E.Message, 0);
               gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUMELAD[SUGPMAD_TBL DELETE]'); //Database 오류
               gf_RollBackTransaction;
               EnableForm;
               Exit;
            end;
         End;

         //--- Delete SUGPMEL_TBL : SUGPMAD_TBL에 없는 데이타 지우기
         Close;
         SQL.Clear;
         SQL.Add( '  DELETE SUGPMEL_TBL                                         '
                + '  FROM  (SELECT DEPT_CODE, SEC_TYPE, GRP_NAME, MAILFORM_ID   '
                + '         FROM   SUGPMEL_TBL A                                '
                + '         WHERE NOT EXISTS ( SELECT 1                         '
                + '                            FROM SUGPMAD_TBL B               '
                + '                            WHERE A.DEPT_CODE = B.DEPT_CODE AND   '
                + '                                  A.SEC_TYPE = B.SEC_TYPE AND     '
                + '                                  A.GRP_NAME =B.GRP_NAME AND      '
                + '                                  A.MAILFORM_ID = B.MAILFORM_ID))  AS T1  '
                + '  WHERE SUGPMEL_TBL.DEPT_CODE = T1.DEPT_CODE AND  '
                + '        SUGPMEL_TBL.SEC_TYPE = T1.SEC_TYPE AND    '
                + '        SUGPMEL_TBL.GRP_NAME = T1.GRP_NAME AND    '
                + '        SUGPMEL_TBL.MAILFORM_ID = T1.MAILFORM_ID  ');

         Try
            gf_ADOExecSQL(ADOQuery_SUMELAD);
         Except
            on E : Exception do
            begin // DataBase 오류
               gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUMELAD[SUGPMEL_TBL DELETE]: ' + E.Message, 0);
               gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUMELAD[SUGPMEL_TBL DELETE]'); //Database 오류
               gf_RollBackTransaction;
               EnableForm;
               Exit;
            end;
         End;
      end;


      if iUsedAccCnt > 0 then  // 사용계좌 있는 경우
      begin
         //--- Delete SUACMAD_TBL
         Close;
         SQL.Clear;
         SQL.Add(' Delete SUACMAD_TBL '
               + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
               + '   and SEND_SEQ  = ''' + iSendSeq + '''' );
         Try
            gf_ADOExecSQL(ADOQuery_SUMELAD);
         Except
            on E : Exception do
            begin // DataBase 오류
               gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUMELAD[SUACMAD_TBL DELETE]: ' + E.Message, 0);
               gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUMELAD[SUACMAD_TBL DELETE]'); //Database 오류
               gf_RollBackTransaction;
               EnableForm;
               Exit;
            end;
         End;

         //--- Delete SUACMEL_TBL : SUACMAD_TBL에 없는 데이타 지우기
         Close;
         SQL.Clear;
         SQL.Add( '  DELETE SUACMEL_TBL                                         '
                + '  FROM  (SELECT DEPT_CODE, ACC_NO, SUB_ACC_NO,  MAILFORM_ID   '
                + '         FROM   SUACMEL_TBL A                                '
                + '         WHERE NOT EXISTS ( SELECT 1                         '
                + '                            FROM SUACMAD_TBL B               '
                + '                            WHERE A.DEPT_CODE  = B.DEPT_CODE AND   '
                + '                                  A.ACC_NO     = B.ACC_NO AND     '
                + '                                  A.SUB_ACC_NO = B.SUB_ACC_NO AND      '
                + '                                  A.MAILFORM_ID= B.MAILFORM_ID))  AS T1  '
                + '  WHERE SUACMEL_TBL.DEPT_CODE   = T1.DEPT_CODE AND  '
                + '        SUACMEL_TBL.ACC_NO      = T1.ACC_NO AND    '
                + '        SUACMEL_TBL.SUB_ACC_NO  = T1.SUB_ACC_NO AND    '
                + '        SUACMEL_TBL.MAILFORM_ID = T1.MAILFORM_ID  ');

         Try
            gf_ADOExecSQL(ADOQuery_SUMELAD);
         Except
            on E : Exception do
            begin // DataBase 오류
               gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUMELAD[SUACMEL_TBL DELETE]: ' + E.Message, 0);
               gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUMELAD[SUACMEL_TBL DELETE]'); //Database 오류
               gf_RollBackTransaction;
               EnableForm;
               Exit;
            end;
         End;
      end;
}
   end;  // end of with

   //-------------------
   gf_CommitTransaction;
   //-------------------

   ModFlag := True;
   if not QueryToList then
   begin
      EnableForm;
      Exit;
   end;
   DisplayData;
   EnableForm;
   ClearInputValue;  // Clear
   DREdit_MailRcv.SetFocus;
   gf_ShowMessage(MessageBar, mtInformation, 1006, DeleteStr ); // 삭제 완료
end;

//------------------------------------------------------------------------------
// 인쇄
//------------------------------------------------------------------------------
procedure TDlgForm_RegEmailAddr.DRBitBtn2Click(Sender: TObject);
begin
  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1100, ''); // 인쇄 중입니다.
   with DrStringPrint1 do
   begin
      // Report Title
      Title  := Trim(Self.Caption);
      UserText1  := '';
      UserText2  := '';
      StringGrid   := DRStrGrid_MailAddrInsert;
      Print;
   end;

   gf_ShowMessage(MessageBar, mtInformation, 1101, ''); // 인쇄 완료
end;



//------------------------------------------------------------------------------
// 입.수.삭 후 Edit Clear;
//------------------------------------------------------------------------------
procedure TDlgForm_RegEmailAddr.ClearInputValue;
begin
   DREdit_MailRcv.Clear;
   DREdit_Addr1.Clear;
   DREdit_Addr2.Clear;
   DREdit_Addr3.Clear;
   DREdit_Addr4.Clear;
   DREdit_Addr5.Clear;
   DREdit_SendSeq.clear;
   DREdit_OprID.Clear;
   DREdit_OprTime.Clear;
end;

//------------------------------------------------------------------------------
// 마우스 더블클릭
//------------------------------------------------------------------------------
procedure TDlgForm_RegEmailAddr.DRStrGrid_MailAddrInsertMouseMove(
  Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
   ACol, ARow : integer;
begin
  inherited;
  DRStrGrid_MailAddrInsert.MouseToCell(x,y,ACol, ARow);

  SelRowIdx := ARow;
//
end;

procedure TDlgForm_RegEmailAddr.DRStrGrid_MailAddrInsertDblClick(Sender: TObject);
var
   MailAddrItem : pTMailAddrBook;
begin
  inherited;
   gf_ClearMessage(MessageBar);
   if (SelRowIdx <= 0) then Exit;
   if MailAddrBook.Count <= 0 then exit;

   MailAddrITem := MailAddrBook.Items[SelRowIDx -1];
   //채번
   DREdit_SendSeq.Text := IntToStr(MailAddrITem.sendSeq);
   //수신처
   DREdit_MailRcv.Text  := MailAddrITem.MailRcv;
   //이메일주소
   AddrToEdit(MailAddrITem.MailAddr);
   // 조작자
   DREdit_OprId.Text    := MailAddrITem.OprId;
   // 조작시간
   DREdit_OprTime.Text := gf_FormatDate(MailAddrItem.OprDate)
                           + ' ' + gf_FormatTime(MailAddrITem.OprTime);

end;


procedure TDlgForm_RegEmailAddr.AddrToEdit(sAddr : string);
var i, iCnt : integer;
     sTemp : string;
begin
  DREdit_Addr1.Clear;
  DREdit_Addr2.Clear;
  DREdit_Addr3.Clear;
  DREdit_Addr4.Clear;
  DREdit_Addr5.Clear;

  if RightStr(sAddr,1) <> ';' then sAddr := sAddr + ';';
  iCnt := 1;
  while True do
  begin
    sTemp := fnGetTokenStr(sAddr,';',iCnt);
    if trim(sTemp) = '' then Break;
    case iCnt of
      1: DREdit_Addr1.Text := trim(sTemp);
      2: DREdit_Addr2.Text := trim(sTemp);
      3: DREdit_Addr3.Text := trim(sTemp);
      4: DREdit_Addr4.Text := trim(sTemp);
      5: DREdit_Addr5.Text := trim(sTemp);
    end;
    if iCnt > 5 then DREdit_Addr5.Text := DREdit_Addr5.Text + ';' + trim(sTemp);
    Inc(iCnt);
  end;

end;

function TDlgForm_RegEmailAddr.HintAddr(sAddr : string) : string;
var i, iCnt : integer;
     sTemp, sResult : string;
begin
  Result := '';
  if RightStr(sAddr,1) <> ';' then sAddr := sAddr + ';';
  iCnt := 1;
  sResult := '';
  while True do
  begin
    sTemp := fnGetTokenStr(sAddr,';',iCnt);
    if trim(sTemp) = '' then Break;
    sResult := sResult + sTemp + #13#10 ;
    Inc(iCnt);
  end;
  Result := sResult;
end;

function TDlgForm_RegEmailAddr.CheckAddr : Boolean;
var i, iCnt : integer;
     sTemp, sResult : string;
begin
  Result := False;
//  if Pos(';',DREdit_Addr1.Text) > 0 then Exit;
  if Pos(',',DREdit_Addr1.Text) > 0 then Exit;
//  if Pos(';',DREdit_Addr2.Text) > 0 then Exit;
  if Pos(',',DREdit_Addr2.Text) > 0 then Exit;
//  if Pos(';',DREdit_Addr3.Text) > 0 then Exit;
  if Pos(',',DREdit_Addr3.Text) > 0 then Exit;
//  if Pos(';',DREdit_Addr4.Text) > 0 then Exit;
  if Pos(',',DREdit_Addr4.Text) > 0 then Exit;
//  if Pos(';',DREdit_Addr5.Text) > 0 then Exit;
  if Pos(',',DREdit_Addr5.Text) > 0 then Exit;
  Result := True;
end;

//------------------------------------------------------------------------------
// List Clear;
//------------------------------------------------------------------------------
procedure TDlgForm_RegEmailAddr.ClearMailAddrBookList;
var
   MailAddrITem : pTMailAddrBook;
   i : integer;
begin
   if not Assigned(MailAddrBook) then Exit;
   for I := 0 to MailAddrBook.Count -1 do
   begin
      MailAddrITem := MailAddrBook.Items[I];
      Dispose(MailAddrITem);
   end;  // end of for
   MailAddrBook.Clear;
end;

//------------------------------------------------------------------------------
// List Clear;
//------------------------------------------------------------------------------
function TDlgForm_RegEmailAddr.SearchList(pMailRcv, pMailAddr: string): integer;
var
   MailAddrITem : pTMailAddrBook;
   i, iSearchIDx : integer;
begin
   Result := -1;
   iSearchIdx := -1;
   if pMailRcv = '' then
   begin
      for I := 0 to MailAddrBook.Count -1 do
      begin
         MailAddrITem := MailAddrBook.Items[I];
         if (MailAddrITem.MailAddr = pMailAddr) then
         begin
            iSearchIdx := i;
            Break;
         end;
      end;  // end of for
   end else
   if pMailAddr = '' then
   begin
      for I := 0 to MailAddrBook.Count -1 do
      begin
         MailAddrITem := MailAddrBook.Items[I];
         if (MailAddrITem.MailRcv = pMailRcv) then
         begin
            iSearchIdx := i;
            Break;
         end;
      end;  // end of for
   end else
   begin
      for I := 0 to MailAddrBook.Count -1 do
      begin
         MailAddrITem := MailAddrBook.Items[I];
         if (MailAddrITem.MailRcv = pMailRcv) and
             (MailAddrITem.MailAddr = pMailAddr) then
         begin
            iSearchIdx := i;
            Break;
         end;
      end;  // end of for
   end;

   if iSearchIdx > -1 then  //해당 데이터 존재시
   begin
      gf_SelectStrGridRow(DRStrGrid_MailAddrInsert, iSearchIdx + 1);
      Result := iSearchIdx;
   end
   else  //해당 데이터 존재하지 않을 경우 첫Row Select
      gf_SelectStrGridRow(DRStrGrid_MailAddrInsert, 1);
end;


//------------------------------------------------------------------------------
// 다음 KeyPoint
//------------------------------------------------------------------------------
procedure TDlgForm_RegEmailAddr.DREdit_MailRcvKeyPress(Sender: TObject; var Key: Char);
var
   iSearchIDx : integer;
begin
  inherited;
  if key = #13 then
  begin
     DREdit_SendSeq.clear;
     DREdit_Addr1.Clear;
     DREdit_Addr2.Clear;
     DREdit_Addr3.Clear;
     DREdit_Addr4.Clear;
     DREdit_Addr5.Clear;
     DREdit_OprID.clear;
     DREdit_OprTime.Clear;
     iSearchIDx := SearchList(Trim(DREdit_MailRcv.text), '');
     SelRowIdx := iSearchIdx +1;
     DRStrGrid_MailAddrInsertDblClick(DRStrGrid_MailAddrInsert);
     DREdit_Addr1.SetFocus;
  end;
//
end;

//------------------------------------------------------------------------------
// 다음 KeyPoint
//------------------------------------------------------------------------------
procedure TDlgForm_RegEmailAddr.DREdit_MailAddrKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if key = #13 then DRBitBtn5.SetFocus;
end;

//------------------------------------------------------------------------------
// formCreate - > FormActive
//------------------------------------------------------------------------------
procedure TDlgForm_RegEmailAddr.FormActivate(Sender: TObject);
var
   iSearchIDx : integer;
begin
  inherited;

   if not Assigned(MailAddrBook) then Exit;
   if Trim(PubMailRcv) = '' then exit;   // Default Data 없는 경우
//   if Trim(PubMailAddr) = '' then exit;

   iSearchIDx := SearchList(PubMailRcv, PubMailAddr);
   SelRowIdx := iSearchIdx +1;
   DRStrGrid_MailAddrInsertDblClick(DRStrGrid_MailAddrInsert);

end;

//------------------------------------------------------------------------------
// Sorting
//------------------------------------------------------------------------------
procedure TDlgForm_RegEmailAddr.DRStrGrid_MailAddrInsertFiexedRowClick(
  Sender: TObject; ACol: Integer);
begin
  inherited;
   Screen.Cursor := crHourGlass;
   SortIdx := ACol;
   SortFlag[ACol] := not SortFlag[ACol];
   MailAddrBook.Sort(MailAddrBookCompare);
   DisplayData;
   Screen.Cursor := crDefault;

end;


procedure TDlgForm_RegEmailAddr.DRMemo_MailAddrKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if key = #13 then DRBitBtn5.SetFocus;
end;

procedure TDlgForm_RegEmailAddr.DREdit_Addr1KeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
   if (Key = #13) and (ActiveControl is TWinControl) then   // 다음 Control로 이동
   begin
      gf_ClearMessage(MessageBar);
      SelectNext(ActiveControl as TWinControl, True, True);
   end;

end;

procedure TDlgForm_RegEmailAddr.DREdit_Addr5KeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
   if (Key = #13) and (ActiveControl is TWinControl) then   // 다음 Control로 이동
   begin
      gf_ClearMessage(MessageBar);
      DRBitBtn5.SetFocus;
   end;
end;

end.
