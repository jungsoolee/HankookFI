//==============================================================================
//  [LMS] 2001/06/25
//  UPDATE [JYKIM] 2001/12/29
//==============================================================================
//!!! SUCOMAD_TBL, SUCORPT_TBL 데이터 삭제시 SEC_TYPE은 고려하지 않음
unit SCCRegFaxTlxAddr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCCDlgForm, StdCtrls, Buttons, DRAdditional, ExtCtrls, DRStandard,
  DRSpecial, Grids, DRStringgrid, Db, ADODB, DRDialogs, DrStringPrintU;

type
  TDlgForm_RegFaxTlxAddr = class(TForm_Dlg)
    DRFramePanel_Top: TDRFramePanel;
    DRStrGrid_Main: TDRStringGrid;
    DRLabel4: TDRLabel;
    DRLabel1: TDRLabel;
    DRLabel2: TDRLabel;
    DRLabel5: TDRLabel;
    DREdit_RcvCompKor: TDREdit;
    DREdit_MediaNo: TDREdit;
    DREdit_OprId: TDREdit;
    DREdit_OprTime: TDREdit;
    DRBitBtn5: TDRBitBtn;
    ADOQuery_SUPRTAD: TADOQuery;
    ADOQuery_Temp: TADOQuery;
    DRBitBtn6: TDRBitBtn;
    DREdit_FaxGubun: TDREdit;
    DRLabel6: TDRLabel;
    DrStringPrint1: TDrStringPrint;
    procedure ClearInputValue;
    function  SelectGridData(pSendMtd, pNatCode, pMediaNo, pIntTelYn: string): Integer;
    function  CheckKeyEditEmpty(DeleteFlag: boolean): boolean;
    function  GetAddrListIdx(pSendMtd, pNatCode, pMediaNo, pIntTelYn: string): Integer;
    procedure FormCreate(Sender: TObject);
    procedure ClearAddrList;
    function  QueryToList: boolean;
    procedure DisplayGridData;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DRStrGrid_MainSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure DRStrGrid_MainDblClick(Sender: TObject);
    procedure DRRadioGroup_SendMtdClick(Sender: TObject);
    procedure DRBitBtn6Click(Sender: TObject);
    procedure DRBitBtn4Click(Sender: TObject);
    procedure DRBitBtn3Click(Sender: TObject);
    procedure DRBitBtn5Click(Sender: TObject);
    procedure DRBitBtn2Click(Sender: TObject);
    procedure DREdit_RcvCompKorKeyPress(Sender: TObject; var Key: Char);
    procedure DREdit_MediaNoKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure DRStrGrid_MainFiexedRowClick(Sender: TObject; ACol: Integer);
    procedure DREdit_FaxGubunKeyPress(Sender: TObject; var Key: Char);
    procedure DREdit_FaxGubunChange(Sender: TObject);
  private
  public
    DefSendMtd : string;
    DefSendSeq : Integer;
  end;

var
  DlgForm_RegFaxTlxAddr: TDlgForm_RegFaxTlxAddr;

implementation
{$R *.DFM}

uses
   SCCGlobalType, SCCLib;

type
  //=== SUPRTAD_TBL  Data
  TSUPRTADData = record
    DeptCode    : string;
    SendMtd     : string;
    SendSeq     : Integer;
    RcvCompKor  : string;
    NatCode     : string;
    MediaNo     : string;
    IntTelYN    : string;
    OprId       : string;
    OprDate     : string;
    OprTime     : string;
  end;
  pTSUPRTADData = ^TSUPRTADData;

const
   NNAT_NAME_IDX  = 0;    // DRStrGrid_Nat의  국가명 ColIdx
   NNAT_CODE_IDX  = 1;    // DRStrGrid_Nat의  국가코드 ColIdx
   NNAT_TLXNO_IDX = 3;    // DRStrGrid_Nat의  Telex번호 ColIdx

   ITEM_IDX_DOMFAX = 0;   // DRRadioGroup_SendMtd의 국내 Fax Index
   ITEM_IDX_INTFAX = 1;   // DRRadioGroup_SendMtd의 국제 Fax Index
   ITEM_IDX_TELEX  = 2;   // DRRadioGroup_SendMtd의 Telex Index

   RCV_COMP_IDX    = 0;   // DRStrGrid_Main의 수신처명 ColIndex
   
var
   AddrList : TList;
   MainRowIdx  : Integer;               // Select DRStrGrid_Main의 RowIdx
   SelectIdx   : Integer;               // 입력이나 삭제를 위해 선택된 AddrList의 Index
   SortIdx     : Integer;               // Sorting 기준 Column Index
   NatCodeRowIdx : Integer;             // Select DRStrGrid_NatCode의 RowIdx
   InsFlag, ModFlag : boolean;          // 입력, 수정, 삭제 여부
   SortFlag : array [0..3] of boolean;  // Column별 Sort Status

//------------------------------------------------------------------------------
//  List Sorting
//------------------------------------------------------------------------------
function AddrListCompare(Item1, Item2: Pointer): Integer;
begin
   case SortIdx of
      // 수신처
      0: Result := gf_ReturnStrComp(pTSUPRTADData(Item1).RcvCompKor,
                                    pTSUPRTADData(Item2).RcvCompKor,
                                    SortFlag[SortIdx]);
      // 전송구분
      1: Result := gf_ReturnStrComp(pTSUPRTADData(Item1).SendMtd + pTSUPRTADData(Item1).IntTelYN,
                                    pTSUPRTADData(Item2).SendMtd + pTSUPRTADData(Item2).IntTelYN,
                                    SortFlag[SortIdx]);
      // 국가
      2: Result := gf_ReturnStrComp(pTSUPRTADData(Item1).NatCode,
                                    pTSUPRTADData(Item2).NatCode,
                                    SortFlag[SortIdx]);
      // 매체번호
      3: Result := gf_ReturnStrComp(pTSUPRTADData(Item1).MediaNo,
                                    pTSUPRTADData(Item2).MediaNo,
                                    SortFlag[SortIdx]);
      else
         Result := 0;                              
   end;
end;

procedure TDlgForm_RegFaxTlxAddr.FormCreate(Sender: TObject);
var
   I : Integer;
begin
  inherited;
   SelectIdx := -1;
   SortIdx   := RCV_COMP_IDX;        // 수신처명
   SortFlag[RCV_COMP_IDX] := True;   // Ascending Sorting
   InsFlag := False;  // 입력
   ModFlag := False;  // 수정, 삭제
   DREdit_RcvCompKor.Color := gcQueryEditColor;
   DREdit_MediaNo.Color    := gcQueryEditColor;
   DREdit_FaxGubun.Color    := gcQueryEditColor;

   // 수신처 Ime Mode Setting
   DREdit_RcvCompKor.ImeMode := imSHanguel;  // 한글
   if gvDeptCode = gcDEPT_CODE_INT then  // 국제부
      DREdit_RcvCompKor.ImeMode := imSAlpha;   // 영문

   //--- List 생성
   AddrList := TList.Create;
   if not Assigned(AddrList) then
   begin
      gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); // List 생성 오류
      Close;
      Exit;
   end;
{
   //--- 국가코드
   with ADOQuery_Temp, DRStrGrid_NatCode do
   begin
      Close;
      SQL.Clear;
      SQL.Add(' Select NAT_CODE, NAT_NAME, TLX_DIAL_IN, FAX_DIAL_IN '
            + ' From SCNATCD_TBL '
            + ' Order By NAT_NAME ');
      Try
         gf_ADOQueryOpen(ADOQuery_Temp);
      Except
         on E : Exception do
         begin  // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SCNATCD_TBL]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SCNATCD_TBL]'); //Database 오류
            Close;
            Exit;
         end;
      End;

      RowCount := RecordCount + 1;
      I := 0;
      while not Eof do
      begin
         Inc(I);
         Cells[0, I] := Trim(FieldByName('NAT_NAME').asString);
         Cells[1, I] := Trim(FieldByName('NAT_CODE').asString);
         Cells[2, I] := Trim(FieldByName('FAX_DIAL_IN').asString);
         Cells[3, I] := Trim(FieldByName('TLX_DIAL_IN').asString);
         Next;
      end;  // end of while
   end; // end of with
}
   //--- Display
   if not QueryToList then
   begin
      Close;
      Exit;
   end;
   DisplayGridData;
end;

procedure TDlgForm_RegFaxTlxAddr.FormClose(Sender: TObject; var Action: TCloseAction);
var
   iRtnValue : Integer;
begin
  inherited;
   ClearAddrList;
   AddrList.Free;

   // Data 변경 여부 리턴
   iRtnValue := gcMR_NONE;
   if InsFlag then  // Insert
      iRtnValue := gcMR_INSERTED;
   if ModFlag then  // Update, Delete
      iRtnValue := gcMR_MODIFIED;
   ModalResult := iRtnValue;
end;

//------------------------------------------------------------------------------
//  Clear AddrList
//------------------------------------------------------------------------------
procedure TDlgForm_RegFaxTlxAddr.ClearAddrList;
var
   I : Integer;
   AddrItem : pTSUPRTADData;
begin
   if not Assigned(AddrList) then Exit;
   for I := 0 to AddrList.Count -1 do
   begin
      AddrItem := AddrList.Items[I];
      Dispose(AddrItem);
   end;  // end of for
   AddrList.Clear;
end;

//------------------------------------------------------------------------------
//  Query의 Result Set으로 List 생성
//------------------------------------------------------------------------------
function TDlgForm_RegFaxTlxAddr.QueryToList: boolean;
var
   AddrItem : pTSUPRTADData;
begin
   Result := False;
   ClearAddrList;
   with ADOQuery_SUPRTAD do
   begin
      Close;
      SQL.Clear;
      SQL.Add(' Select * From SUPRTAD_TBL '
            + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
            + '   and (SEND_MTD = ''' + gcSEND_FAX + ''' or '
            + '        SEND_MTD = ''' + gcSEND_TLX + ''') '   // Fax or Telex
            + ' Order By RCV_COMP_KOR, SEND_MTD, NAT_CODE, MEDIA_NO ');
      Try
         gf_ADOQueryOpen(ADOQuery_SUPRTAD);
      Except
         on E : Exception do
         begin
            // Database 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Query]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Query]'); // Database 오류
            Exit;
         end;
      end;

      while not EOF do
      begin
         New(AddrItem);
         AddrList.Add(AddrItem);
         AddrItem.DeptCode   := Trim(FieldByName('DEPT_CODE').asString);
         AddrItem.SendMtd    := Trim(FieldByName('SEND_MTD').asString);
         AddrItem.SendSeq    := FieldByName('SEND_SEQ').asInteger;
         AddrItem.RcvCompKor := Trim(FieldByName('RCV_COMP_KOR').asString);
         AddrItem.NatCode    := Trim(FieldByName('NAT_CODE').asString);
         AddrItem.MediaNo    := Trim(FieldByName('MEDIA_NO').asString);
         AddrItem.IntTelYN   := Trim(FieldByName('INTTEL_YN').asString);
         AddrItem.OprId      := Trim(FieldByName('OPR_ID').asString);
         AddrItem.OprDate    := Trim(FieldByName('OPR_DATE').asString);
         AddrItem.OprTime    := Trim(FieldByName('OPR_TIME').asString);
         Next;
      end;  // end of while

      // List Sorting
      AddrList.Sort(AddrListCompare);
      
      Close;  // Query Close
      Result := True;
   end;  // end of with
end;

//------------------------------------------------------------------------------
//  Display AddrList to StrGrid_Main
//------------------------------------------------------------------------------
procedure TDlgForm_RegFaxTlxAddr.DisplayGridData;
var
   I, iRow: Integer;
   AddrItem : pTSUPRTADData;
   sRcvCompKor : string;
begin
   with DRStrGrid_Main do
   begin
      if AddrList.Count <= 0 then
      begin
         RowCount := 2;
         Rows[1].Clear;
         gf_ShowMessage(MessageBar, mtInformation, 1018, ''); //해당 내역이 없습니다.
         Exit;
      end;
      RowCount := AddrList.Count + 1;

      iRow := 0;
      sRcvCompKor := '';
      for I := 0 to AddrList.Count -1 do
      begin
         AddrItem := AddrList.Items[I];

         Inc(iRow);
         Rows[iRow].Clear;

         // 수신처
         if sRcvCompKor <> AddrItem.RcvCompKor then
         begin
            sRcvCompKor := AddrItem.RcvCompKor;
            Cells[0, iRow] := AddrItem.RcvCompKor;
         end;

         // 전송구분
         if AddrItem.SendMtd = gcSEND_FAX then
         begin
            if AddrItem.IntTelYN = 'N' then  // 국내 Fax
            begin
               Cells[1, iRow] := '국내FAX';
               CellFont[1, iRow].Color := clNavy;
            end
            else   // 국제 Fax
            begin
               Cells[1, iRow] := '국제FAX';
               CellFont[1, iRow].Color := $00FD5A02;
            end;
         end
         else // Telex
         begin
            Cells[1, iRow] := 'TELEX';
            CellFont[1, iRow].Color := clPurple;
         end;
         SelectedFontColorCell[1, iRow] := CellFont[1, iRow].Color;

         // 국가코드
         Cells[2, iRow] := AddrItem.NatCode;

         // 매체번호
         Cells[3, iRow] := AddrItem.MediaNo;
      end;  // end of for
      gf_ShowMessage(MessageBar, mtInformation, 1021, gwQueryCnt + IntToStr(AddrList.Count)); // 조회 완료
   end;  // end of with
end;

procedure TDlgForm_RegFaxTlxAddr.DRStrGrid_MainSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
   MainRowIdx := ARow;
end;

procedure TDlgForm_RegFaxTlxAddr.DRStrGrid_MainDblClick(Sender: TObject);
var
   iItemIdx : Integer;
   AddrItem : pTSUPRTADData;
begin
  inherited;

   iItemIdx := MainRowIdx -1;
   if (iItemIdx >= 0) and (iItemIdx < AddrList.Count) then
   begin
      SelectIdx := iItemIdx;
      AddrItem  := AddrList.Items[iItemIdx];

      // 수신처
      DREdit_RcvCompKor.Text := AddrItem.RcvCompKor;

      // 전송구분
      if AddrItem.SendMtd = gcSEND_FAX then
      begin
         if AddrItem.IntTelYN = 'N' then   // 국내
            DREdit_FaxGubun.Text := '1'
         else   // 국외
            DREdit_FaxGubun.Text := '2';
      end;

      // 매체번호
      DREdit_MediaNo.Text := AddrItem.MediaNo;
      
      // 조작자
      DREdit_OprId.Text := AddrItem.OprId;

      // 조작시간
      DREdit_OprTime.Text := gf_FormatDate(AddrItem.OprDate)
                             + ' ' + gf_FormatTime(AddrItem.OprTime);

      if Self.Active then
         DREdit_RcvCompKor.SetFocus;
   end;  // end of if
end;

procedure TDlgForm_RegFaxTlxAddr.DRRadioGroup_SendMtdClick(Sender: TObject);
begin
   inherited;

end;


//------------------------------------------------------------------------------
//  조회
//------------------------------------------------------------------------------
procedure TDlgForm_RegFaxTlxAddr.DRBitBtn6Click(Sender: TObject);
begin
  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1020, ''); //조회 중입니다.
   DisableForm;
   if QueryToList then
      DisplayGridData
   else  // Error
   begin
      DRStrGrid_Main.RowCount := 2;
      DRStrGrid_Main.Rows[1].Clear;
   end;
   EnableForm;
end;

//------------------------------------------------------------------------------
//  입력
//------------------------------------------------------------------------------
procedure TDlgForm_RegFaxTlxAddr.DRBitBtn5Click(Sender: TObject);
var
   iSendSeq : Integer;
   sSendMtd, sNatCode, sMediaNo, sIntTelYn : string;
begin
  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1010, ''); //입력 중입니다.

   if CheckKeyEditEmpty(False) then Exit;   //입력 누락 항목 확인

   sSendMtd := gcSEND_FAX;

   sMediaNo := Trim(DREdit_MediaNo.Text);
   sIntTelYn := 'N';
   if DREdit_FaxGubun.Text = '2' then  // 국제Fax
      sIntTelYn := 'Y';

   DisableForm;
   //-------------------
   gf_BeginTransaction;    // 채번을 위해!
   //-------------------
   with ADOQuery_SUPRTAD do
   begin
      // 해당 데이터 존재하는지 확인
      Close;
      SQL.Clear;
      SQL.Add(' Select SEND_SEQ, RCV_COMP_KOR '
            + ' From SUPRTAD_TBL with (TABLOCKX, HOLDLOCK) ' // Locking-!
            + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
            + '   and SEND_MTD = ''' + sSendMtd + ''' '
            + '   and NAT_CODE = ''' + sNatCode + ''' '
            + '   and MEDIA_NO = ''' + sMediaNo + ''' '
            + '   and INTTEL_YN = ''' + sIntTelYn + ''' ');
      Try
         gf_ADOQueryOpen(ADOQuery_SUPRTAD);
      Except
         on E : Exception do
         begin // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[SendSeq]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[SendSeq]'); //Database 오류
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
         if SelectGridData(sSendMtd, sNatCode, sMediaNo, sIntTelYn) <= 0 then  // Grid Search Fail
         begin
            // List Refresh & Display
            if QueryToList then
            begin
               DisplayGridData;
               SelectGridData(sSendMtd, sNatCode, sMediaNo, sIntTelYn);
               gf_ShowMessage(MessageBar, mtError, 1066, ''); // 해당 수신처는 이미 등록되어 있습니다.
            end
            else
            begin
               DRStrGrid_Main.RowCount := 2;
               DRStrGrid_Main.Rows[1].Clear;
            end;
         end;
         SelectIdx := -1;  // Clear
         DREdit_RcvCompKor.SetFocus;
         Exit;
      end;

      // 채번
      Close;
      SQL.Clear;
      SQL.Add(' Select MAX_SEND_SEQ = ISNULL(MAX(SEND_SEQ), 0) '
            + ' From SUPRTAD_TBL '
            + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
            + '   and SEND_MTD = ''' + sSendMtd + ''' ');
      Try
         gf_ADOQueryOpen(ADOQuery_SUPRTAD);
      Except
         on E : Exception do
         begin // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[SendSeq]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[SendSeq]'); //Database 오류
            gf_RollbackTransaction;
            EnableForm;
            Exit;
         end;
      End;
      iSendSeq := FieldByName('MAX_SEND_SEQ').asInteger + 1;

      // Insert
      Close;
      SQL.Clear;
      SQL.Add(' Insert SUPRTAD_TBL '
            + ' (DEPT_CODE, SEND_MTD, SEND_SEQ, NAT_CODE, MEDIA_NO, RCV_COMP_KOR, '
            + '  INTTEL_YN, OPR_ID, OPR_DATE, OPR_TIME) '
            + ' Values '
            + ' (:pDeptCode, :pSendMtd, :pSendSeq, :pNatCode, :pMediaNo, :pRcvCompKor, '
            + '  :pIntTelYN, :pOprId, :pOprDate, :pOprTime) ');
      Parameters.ParamByName('pDeptCode').Value   := gvDeptCode;
      Parameters.ParamByName('pSendMtd').Value    := sSendMtd;
      Parameters.ParamByName('pSendSeq').Value    := iSendSeq;
      Parameters.ParamByName('pNatCode').Value    := sNatCode;
      Parameters.ParamByName('pMediaNo').Value    := sMediaNo;
      Parameters.ParamByName('pRcvCompKor').Value := DREdit_RcvCompKor.Text;
      Parameters.ParamByName('pIntTelYN').Value   := sIntTelYN;
      Parameters.ParamByName('pOprId').Value      := gvOprUsrNo;
      Parameters.ParamByName('pOprDate').Value    := gvCurDate;
      Parameters.ParamByName('pOprTime').Value    := gf_GetCurTime;
      Try
         gf_ADOExecSQL(ADOQuery_SUPRTAD);
      Except
         on E : Exception do
         begin // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Insert]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Insert]'); //Database 오류
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
   if QueryToList then
      DisplayGridData
   else
   begin
      DRStrGrid_Main.RowCount := 2;
      DRStrGrid_Main.Rows[1].Clear;
   end;
   EnableForm;
   SelectGridData(sSendMtd, sNatCode, sMediaNo, sIntTelYn);
//   ClearInputValue;  // Clear
//   DREdit_RcvCompKor.Clear;
   SelectIdx := -1;  // Clear
   DREdit_RcvCompKor.SetFocus;
   DREdit_RcvCompKor.SelectAll;
   gf_ShowMessage(MessageBar, mtInformation, 1011, ''); // 입력 완료
end;

//------------------------------------------------------------------------------
//  수정
//------------------------------------------------------------------------------
procedure TDlgForm_RegFaxTlxAddr.DRBitBtn4Click(Sender: TObject);
var
   AddrItem : pTSUPRTADData;
   iChkListIdx, iSendSeq : Integer;
   sSendMtd, sNatCode, sMediaNo, sIntTelYn : string;
begin
  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1007, ''); // 수정 중입니다.

   if CheckKeyEditEmpty(False) then Exit;   //입력 누락 항목 확인

   sSendMtd := gcSEND_FAX;
   sMediaNo := Trim(DREdit_MediaNo.Text);
   sIntTelYn := 'N';
   if DREdit_FaxGubun.Text = '2' then  // 국제Fax
      sIntTelYn := 'Y';

   iChkListIdx := GetAddrListIdx(sSendMtd, sNatCode, sMediaNo, sIntTelYn);
   if (iChkListIdx >= 0) and (SelectIdx <> iChkListIdx) then   // 존재함
   begin
      if SelectIdx < 0 then
         SelectIdx := iChkListIdx
      else   // SelectIdx의 자료를 기존의 존재 하는 자료로 수정하려 함
      begin
         gf_ShowMessage(MessageBar, mtError, 1148, '');  // 동일 매체 번호의 수신처가 이미 존재합니다. 확인바랍니다.
         SelectGridData(sSendMtd, sNatCode, sMediaNo, sIntTelYn);
         DREdit_MediaNo.SetFocus;
         Exit;
      end;
   end;

   if SelectIdx < 0 then
   begin
      gf_ShowMessage(MessageBar, mtError, 1025, ''); //해당 자료가 존재하지 않습니다.
      DREdit_RcvCompKor.SetFocus;
      Exit;
   end;

   AddrItem := AddrList.Items[SelectIdx];
   iSendSeq := AddrItem.SendSeq;

   DisableForm;
   with ADOQuery_SUPRTAD do
   begin
      //--- 해당 데이터 존재하는지 재확인
      Close;
      SQL.Clear;
      SQL.Add(' Select RCV_COMP_KOR '
            + ' From SUPRTAD_TBL '
            + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
            + '   and SEND_MTD = ''' + sSendMtd + ''' '
            + '   and SEND_SEQ = ' + IntToStr(iSendSeq));
      Try
         gf_ADOQueryOpen(ADOQuery_SUPRTAD);
      Except
         on E : Exception do
         begin // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Select]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Select]'); //Database 오류
            EnableForm;
            Exit;
         end;
      End;

      if RecordCount <= 0 then  // 해당 데이터 존재하지 않는경우
      begin
         // List Refresh & Display
         if QueryToList then
            DisplayGridData
         else
         begin
            DRStrGrid_Main.RowCount := 2;
            DRStrGrid_Main.Rows[1].Clear;
         end;
         gf_ShowMessage(MessageBar, mtError, 1025, ''); //해당 자료가 존재하지 않습니다.
         EnableForm;
         SelectIdx := -1;  // Clear
         DREdit_RcvCompKor.SetFocus;
         Exit;
      end;

      //--- Update
      Close;
      SQL.Clear;
      SQL.Add(' Update SUPRTAD_TBL '
            + ' Set RCV_COMP_KOR = ''' + DREdit_RcvCompKor.Text + ''', '
            + '     NAT_CODE  = ''' + sNatCode + ''', '
            + '     MEDIA_NO  = ''' + sMediaNo + ''', '
            + '     INTTEL_YN = ''' + sIntTelYN + ''', '
            + '     OPR_ID = ''' + gvOprUsrNo + ''', '
            + '     OPR_DATE = ''' + gvCurDate + ''', '
            + '     OPR_TIME = ''' + gf_GetCurTime + ''' '
            + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
            + '   and SEND_MTD = ''' + sSendMtd + ''' '
            + '   and SEND_SEQ = ' + IntToStr(iSendSeq) );
      Try
         gf_ADOExecSQL(ADOQuery_SUPRTAD);
      Except
         on E : Exception do
         begin // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Update]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Update]'); //Database 오류
            EnableForm;
            Exit;
         end;
      End;
   end; // end of if Update

   ModFlag := True;
   if QueryToList then
      DisplayGridData
   else
   begin
      DRStrGrid_Main.RowCount := 2;
      DRStrGrid_Main.Rows[1].Clear;
   end;
   EnableForm;
   SelectGridData(sSendMtd, sNatCode, sMediaNo, sIntTelYn);
   ClearInputValue;  // Clear
   SelectIdx := -1;  // Clear
   DREdit_RcvCompKor.SetFocus;
   gf_ShowMessage(MessageBar, mtInformation, 1008, ''); // 수정 완료
end;

//------------------------------------------------------------------------------
//  삭제
//------------------------------------------------------------------------------
procedure TDlgForm_RegFaxTlxAddr.DRBitBtn3Click(Sender: TObject);
var
   AddrItem : pTSUPRTADData;
   sUsedList, sDeleteStr : string;
   iChkListIdx, iSendSeq : Integer;
   iUsedAccCnt, iUsedComCnt : Integer;
   sSendMtd, sNatCode, sMediaNo, sIntTelYn : string;
begin
  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1005, ''); // 삭제 중입니다.

   if CheckKeyEditEmpty(True) then Exit;   //입력 누락 항목 확인

   sSendMtd := gcSEND_FAX;

   sMediaNo := Trim(DREdit_MediaNo.Text);
   sIntTelYn := 'N';
   if DREdit_FaxGubun.Text = '2' then  // 국제Fax
      sIntTelYn := 'Y';

   sDeleteStr := '(' + Trim(DREdit_RcvCompKor.Text) + ' ' + Trim(sNatCode) + ' '
                 + Trim(sMediaNo) + ')';

   iChkListIdx := GetAddrListIdx(sSendMtd, sNatCode, sMediaNo, sIntTelYn);
   if iChkListIdx >= 0 then   // 존재함
      SelectIdx := iChkListIdx;
   if SelectIdx < 0 then
   begin
      gf_ShowMessage(MessageBar, mtError, 1025, ''); //해당 자료가 존재하지 않습니다.
      DREdit_RcvCompKor.SetFocus;
      Exit;
   end;

   AddrItem := AddrList.Items[SelectIdx];
   iSendSeq := AddrItem.SendSeq;

   DisableForm;
   with ADOQuery_SUPRTAD do
   begin
      //--- 해당 데이터 존재하는지 재확인
      Close;
      SQL.Clear;
      SQL.Add(' Select RCV_COMP_KOR '
            + ' From SUPRTAD_TBL '
            + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
            + '   and SEND_MTD = ''' + sSendMtd + ''' '
            + '   and SEND_SEQ = ' + IntToStr(iSendSeq));
      Try
         gf_ADOQueryOpen(ADOQuery_SUPRTAD);
      Except
         on E : Exception do
         begin // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Select]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Select]'); //Database 오류
            EnableForm;
            Exit;
         end;
      End;

      if RecordCount <= 0 then  // 해당 데이터 존재하지 않는경우
      begin
         // List Refresh & Display
         if QueryToList then
            DisplayGridData
         else
         begin
            DRStrGrid_Main.RowCount := 2;
            DRStrGrid_Main.Rows[1].Clear;
         end;
         gf_ShowMessage(MessageBar, mtError, 1025, ''); //해당 자료가 존재하지 않습니다.
         EnableForm;
         SelectIdx := -1;  // Clear
         DREdit_RcvCompKor.SetFocus;
         Exit;
      end;

      //--- SUACCAD_TBL에서  해당 수신처가 사용되는지 확인
      Close;
      SQL.Clear;
      SQL.Add(' Select ACC_NO, SUB_ACC_NO '
            + ' From SUACCAD_TBL  '
            + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
            + '   and SEND_MTD  = ''' + sSendMtd + ''' '
            + '   and SEND_SEQ = ' + IntToStr(iSendSeq));
      Try
         gf_ADOQueryOpen(ADOQuery_SUPRTAD);
      Except
         on E : Exception do
         begin // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[SUACCAD_TBL]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[SUACCAD_TBL]'); //Database 오류
            EnableForm;
            Exit;
         end;
      End;

      sUsedList := '';  // Clear
      iUsedAccCnt := RecordCount;
      if iUsedAccCnt > 0 then  // 사용계좌 있는 경우
      begin
         while not Eof do
         begin
            sUsedList := sUsedList + ' [등록계좌] ' +
                         gf_FormatAccNo(Trim(FieldByName('ACC_NO').asString),
                                        Trim(FieldByName('SUB_ACC_NO').asString)) +
                         Chr(13);
            Next;
         end;  // end of while
      end;  // end of if

      //--- SUCOMAD_TBL에서  해당 수신처가 사용되는지 확인
      Close;
      SQL.Clear;
      SQL.Add(' Select ca.GRP_NAME, ca.SEC_TYPE '
            + ' From SUGRPAD_TBL ca '
            + ' Where ca.DEPT_CODE = ''' + gvDeptCode + ''' '
            + '   AND ca.SEC_TYPE  = ''' + gvCurSecType + '''  '
            + '   and ca.SEND_MTD = ''' + sSendMtd + ''' '
            + '   and ca.SEND_SEQ = ' + IntToStr(iSendSeq));
      Try
         gf_ADOQueryOpen(ADOQuery_SUPRTAD);
      Except
         on E : Exception do
         begin // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[SUGRPAD_TBL]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[SUGRPAD_TBL]'); //Database 오류
            EnableForm;
            Exit;
         end;
      End;

      iUsedComCnt := RecordCount;
      if iUsedComCnt > 0 then // 사용기관 있는경우
      begin
         while not Eof do
         begin
            sUsedList := sUsedList + ' [등록그룹] ' +
                         gf_SecTypeToName(Trim(FieldByName('SEC_TYPE').asString)) +
                         '-' +
                         Trim(FieldByName('GRP_NAME').asString) + Chr(13);
            Next;
         end;  // end of while
      end;  // end of if

      if (iUsedAccCnt > 0) or (iUsedComCnt > 0) then // Data 있는 경우
      begin
         if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 1141, //해당 수신처를 참조하는 계좌 및 기관 전송이 있습니다.
            sUsedList + Chr(13) + ' 삭제하시겠습니까? ',
            [mbYes, mbCancel], 0) = idCancel then
         begin
            gf_ShowMessage(MessageBar, mtInformation, 1082, ''); //작업이 취소되었습니다.
            EnableForm;
            Exit;
         end;
      end; // end of if

      //-------------------
      gf_BeginTransaction;
      //-------------------
      //--- Delete SUPRTAD_TBL
      Close;
      SQL.Clear;
      SQL.Add(' Delete SUPRTAD_TBL '
            + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
            + '   and SEND_MTD = ''' + sSendMtd + ''' '
            + '   and SEND_SEQ = ' + IntToStr(iSendSeq));
      Try
         gf_ADOExecSQL(ADOQuery_SUPRTAD);
      Except
         on E : Exception do
         begin // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Delete SUPRTAD]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Delete SUPRTAD]'); //Database 오류
            gf_RollBackTransaction;
            EnableForm;
            Exit;
         end;
      End;

      if iUsedAccCnt > 0 then  // 사용계좌 있는 경우
      begin
         //--- Delete SUACRPT_TBL
         Close;
         SQL.Clear;
         SQL.Add(' Delete SUACRPT_TBL '
               + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
               + '   and SEND_MTD  = ''' + sSendMtd + ''' '
               + '   and SEND_SEQ  = ' + IntToStr(iSendSeq));
         Try
            gf_ADOExecSQL(ADOQuery_SUPRTAD);
         Except
            on E : Exception do
            begin // DataBase 오류
               gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Delete SUACRPT]: ' + E.Message, 0);
               gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Delete SUACRPT]'); //Database 오류
               gf_RollBackTransaction;
               EnableForm;
               Exit;
            end;
         End;

         //--- Delete SUACCAD_TBL
         Close;
         SQL.Clear;
         SQL.Add(' Delete SUACCAD_TBL '
               + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
               + '   and SEND_MTD  = ''' + sSendMtd + ''' '
               + '   and SEND_SEQ  = ' + IntToStr(iSendSeq));
         Try
            gf_ADOExecSQL(ADOQuery_SUPRTAD);
         Except
            on E : Exception do
            begin // DataBase 오류
               gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Delete SUACCAD]: ' + E.Message, 0);
               gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Delete SUACCAD]'); //Database 오류
               gf_RollBackTransaction;
               EnableForm;
               Exit;
            end;
         End;
      end;

      if iUsedComCnt > 0 then  // 사용그룹 있는 경우
      begin
         //--- Delete SUCORPT_TBL
         Close;
         SQL.Clear;
         SQL.Add(' Delete SUGPRPT_TBL '
               + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
               + '   and SEC_TYPE  = ''' + gcSEC_EQUITY + '''  '
               + '   and SEND_MTD  = ''' + sSendMtd + ''' '
               + '   and SEND_SEQ  = ' + IntToStr(iSendSeq));
         Try
            gf_ADOExecSQL(ADOQuery_SUPRTAD);
         Except
            on E : Exception do
            begin // DataBase 오류
               gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Delete SUGPRPT_TBL]: ' + E.Message, 0);
               gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Delete SUGPRPT_TBL]'); //Database 오류
               gf_RollBackTransaction;
               EnableForm;
               Exit;
            end;
         End;
         //--- Delete SUCOMAD_TBL
         Close;
         SQL.Clear;
         SQL.Add(' Delete SUGRPAD_TBL '
               + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
               + '   and SEC_TYPE  = ''' + gcSEC_EQUITY + '''  '
               + '   and SEND_MTD  = ''' + sSendMtd + ''' '
               + '   and SEND_SEQ  = ' + IntToStr(iSendSeq));
         Try
            gf_ADOExecSQL(ADOQuery_SUPRTAD);
         Except
            on E : Exception do
            begin // DataBase 오류
               gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Delete SUGRPAD_TBL]: ' + E.Message, 0);
               gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Delete SUGRPAD_TBL]'); //Database 오류
               gf_RollBackTransaction;
               EnableForm;
               Exit;
            end;
         End;
      end;
   end;  // end of with
   
   //-------------------
   gf_CommitTransaction;
   //-------------------

   ModFlag := True;
   if QueryToList then
      DisplayGridData
   else
   begin
      DRStrGrid_Main.RowCount := 2;
      DRStrGrid_Main.Rows[1].Clear;
   end;
   EnableForm;
   SelectGridData(sSendMtd, sNatCode, sMediaNo, sIntTelYn);
   ClearInputValue;  // Clear
   SelectIdx := -1;  // Clear
   DREdit_RcvCompKor.SetFocus;
   gf_ShowMessage(MessageBar, mtInformation, 1006, sDeleteStr ); // 삭제 완료
end;

//------------------------------------------------------------------------------
//  인쇄
//------------------------------------------------------------------------------
procedure TDlgForm_RegFaxTlxAddr.DRBitBtn2Click(Sender: TObject);
begin
  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1100, ''); // 인쇄 중입니다.
   with DrStringPrint1 do
   begin
      // Report Title
      Title  := Trim(Self.Caption);
      UserText1  := '';
      UserText2  := '';
      StringGrid   := DRStrGrid_Main;
      Print;
   end;

   gf_ShowMessage(MessageBar, mtInformation, 1101, ''); // 인쇄 완료
end;

//------------------------------------------------------------------------------
//  Return AddrList
//------------------------------------------------------------------------------
function TDlgForm_RegFaxTlxAddr.GetAddrListIdx(pSendMtd, pNatCode, pMediaNo,
  pIntTelYn: string): Integer;
var
   I : Integer;
   AddrItem : pTSUPRTADData;
begin
   Result := -1;
   for I := 0 to AddrList.Count -1 do
   begin
      AddrItem := AddrList.Items[I];
      if (AddrItem.SendMtd = pSendMtd) and
         (AddrItem.NatCode = pNatCode) and
         (AddrItem.MediaNo = pMediaNo) and
         (AddrItem.IntTelYN = pIntTelYn) then
      begin
         Result := I;
         Break;
      end;  // end of if
   end;  // end of for
end;

//------------------------------------------------------------------------------
//  Select GridData
//------------------------------------------------------------------------------
function TDlgForm_RegFaxTlxAddr.SelectGridData(pSendMtd, pNatCode, pMediaNo,
  pIntTelYn: string): Integer;
var
   I, iSearchIdx : Integer;
   AddrItem : pTSUPRTADData;
begin
   Result     := -1;
   iSearchIdx := -1;
   for I := 0 to AddrList.Count -1 do
   begin
      AddrItem := AddrList.Items[I];
      if (AddrItem.SendMtd = pSendMtd) and
         (AddrItem.NatCode = pNatCode) and
         (AddrItem.MediaNo = pMediaNo) and
         (AddrItem.IntTelYN = pIntTelYn) then
      begin
         iSearchIdx := I;
         Break;
      end;  // end of if
   end;  // end of for
   if iSearchIdx > -1 then  //해당 데이터 존재시
   begin
      gf_SelectStrGridRow(DRStrGrid_Main, iSearchIdx + 1);
      Result := iSearchIdx + 1;
   end
   else  //해당 데이터 존재하지 않을 경우 첫Row Select
      gf_SelectStrGridRow(DRStrGrid_Main, 1);
end;

//------------------------------------------------------------------------------
//  입력 누락 항목 있는지 확인
//------------------------------------------------------------------------------
function TDlgForm_RegFaxTlxAddr.CheckKeyEditEmpty(DeleteFlag: boolean): boolean;
begin
   Result := True;

   // 팩스번호
   if Trim(DREdit_MediaNo.Text) = '' then
   begin
      gf_ShowMessage(MessageBar, mtError, 1012, '팩스번호'); //입력 오류
      DREdit_MediaNo.SetFocus;
      Exit;
   end;

   // 팩스구분
   if Trim(DREdit_FaxGubun.Text) = '' then
   begin
      gf_ShowMessage(MessageBar, mtError, 1012, '전송구분'); //입력 오류
      DREdit_FaxGubun.SetFocus;
      Exit;
   end;



   if not DeleteFlag then  //입력, 수정시만 확인
   begin
      // 수신처
      if Trim(DREdit_RcvCompKor.Text) = '' then
      begin
         gf_ShowMessage(MessageBar, mtError, 1012, ''); //입력 오류
         DREdit_RcvCompKor.SetFocus;
         Exit;
      end;
   end;

   Result := False;
end;

//------------------------------------------------------------------------------
//  Clear Input Value
//------------------------------------------------------------------------------
procedure TDlgForm_RegFaxTlxAddr.ClearInputValue;
var
   I : Integer;
begin
   with DRFramePanel_Top do
   begin
      for I := 0 to ControlCount -1 do
      begin
         if (Controls[I] is TDREdit) then
            TDREdit(Controls[I]).Clear
      end;  // end of for
   end;  // end of with
end;

procedure TDlgForm_RegFaxTlxAddr.DREdit_RcvCompKorKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
   if Key = #13 then
     DREdit_FaxGubun.SetFocus;
//      (DRRadioGroup_SendMtd.Controls[DRRadioGroup_SendMtd.ItemIndex] as TRadioButton).SetFocus;
end;

procedure TDlgForm_RegFaxTlxAddr.DREdit_MediaNoKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
   if Key = #13 then
      DRBitBtn5.SetFocus;  // 입력 버튼 Focus
end;

//------------------------------------------------------------------------------
//  Set Default Data
//------------------------------------------------------------------------------
procedure TDlgForm_RegFaxTlxAddr.FormActivate(Sender: TObject);
var
   I : Integer;
   AddrItem : pTSUPRTADData;
begin
   inherited;
   if not Assigned(AddrList) then Exit;
   if Trim(DefSendMtd) = '' then Exit;  // Default Data 없는 경우

   for I := 0 to AddrList.Count -1 do
   begin
      AddrItem := AddrList.Items[I];
      if (AddrItem.SendMtd = DefSendMtd) and (AddrItem.SendSeq = DefSendSeq) then
      begin
         MainRowIdx := I + 1;
         gf_SelectStrGridRow(DRStrGrid_Main, MainRowIdx);
         DRStrGrid_MainDblClick(DRStrGrid_Main);
      end;
   end;  // end of for
end;

procedure TDlgForm_RegFaxTlxAddr.DRStrGrid_MainFiexedRowClick(
  Sender: TObject; ACol: Integer);
begin
  inherited;
   Screen.Cursor := crHourGlass;
   SortIdx := ACol;
   SortFlag[ACol] := not SortFlag[ACol];
   AddrList.Sort(AddrListCompare);
   DisplayGridData;
   Screen.Cursor := crDefault;
end;

procedure TDlgForm_RegFaxTlxAddr.DREdit_FaxGubunKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key = #13 then
     DREdit_MediaNo.SetFocus;
end;

procedure TDlgForm_RegFaxTlxAddr.DREdit_FaxGubunChange(Sender: TObject);
begin
  inherited;
  if (DREdit_FaxGubun.Text > '') then
  begin
    if  (DREdit_FaxGubun.Text <> '1')
    and (DREdit_FaxGubun.Text <> '2') then
    begin
      gf_ShowMessage(MessageBar,mtError,0,'전송구분은 1 혹은 2이어야 합니다.');
      DREdit_FaxGubun.Text := '';
      Exit;
    end;
  end;
end;

end.
