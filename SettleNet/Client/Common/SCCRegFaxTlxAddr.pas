//==============================================================================
//  [LMS] 2001/06/25
//  UPDATE [JYKIM] 2001/12/29
//==============================================================================
//!!! SUCOMAD_TBL, SUCORPT_TBL ������ ������ SEC_TYPE�� ������� ����
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
   NNAT_NAME_IDX  = 0;    // DRStrGrid_Nat��  ������ ColIdx
   NNAT_CODE_IDX  = 1;    // DRStrGrid_Nat��  �����ڵ� ColIdx
   NNAT_TLXNO_IDX = 3;    // DRStrGrid_Nat��  Telex��ȣ ColIdx

   ITEM_IDX_DOMFAX = 0;   // DRRadioGroup_SendMtd�� ���� Fax Index
   ITEM_IDX_INTFAX = 1;   // DRRadioGroup_SendMtd�� ���� Fax Index
   ITEM_IDX_TELEX  = 2;   // DRRadioGroup_SendMtd�� Telex Index

   RCV_COMP_IDX    = 0;   // DRStrGrid_Main�� ����ó�� ColIndex
   
var
   AddrList : TList;
   MainRowIdx  : Integer;               // Select DRStrGrid_Main�� RowIdx
   SelectIdx   : Integer;               // �Է��̳� ������ ���� ���õ� AddrList�� Index
   SortIdx     : Integer;               // Sorting ���� Column Index
   NatCodeRowIdx : Integer;             // Select DRStrGrid_NatCode�� RowIdx
   InsFlag, ModFlag : boolean;          // �Է�, ����, ���� ����
   SortFlag : array [0..3] of boolean;  // Column�� Sort Status

//------------------------------------------------------------------------------
//  List Sorting
//------------------------------------------------------------------------------
function AddrListCompare(Item1, Item2: Pointer): Integer;
begin
   case SortIdx of
      // ����ó
      0: Result := gf_ReturnStrComp(pTSUPRTADData(Item1).RcvCompKor,
                                    pTSUPRTADData(Item2).RcvCompKor,
                                    SortFlag[SortIdx]);
      // ���۱���
      1: Result := gf_ReturnStrComp(pTSUPRTADData(Item1).SendMtd + pTSUPRTADData(Item1).IntTelYN,
                                    pTSUPRTADData(Item2).SendMtd + pTSUPRTADData(Item2).IntTelYN,
                                    SortFlag[SortIdx]);
      // ����
      2: Result := gf_ReturnStrComp(pTSUPRTADData(Item1).NatCode,
                                    pTSUPRTADData(Item2).NatCode,
                                    SortFlag[SortIdx]);
      // ��ü��ȣ
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
   SortIdx   := RCV_COMP_IDX;        // ����ó��
   SortFlag[RCV_COMP_IDX] := True;   // Ascending Sorting
   InsFlag := False;  // �Է�
   ModFlag := False;  // ����, ����
   DREdit_RcvCompKor.Color := gcQueryEditColor;
   DREdit_MediaNo.Color    := gcQueryEditColor;
   DREdit_FaxGubun.Color    := gcQueryEditColor;

   // ����ó Ime Mode Setting
   DREdit_RcvCompKor.ImeMode := imSHanguel;  // �ѱ�
   if gvDeptCode = gcDEPT_CODE_INT then  // ������
      DREdit_RcvCompKor.ImeMode := imSAlpha;   // ����

   //--- List ����
   AddrList := TList.Create;
   if not Assigned(AddrList) then
   begin
      gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); // List ���� ����
      Close;
      Exit;
   end;
{
   //--- �����ڵ�
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
         begin  // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SCNATCD_TBL]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SCNATCD_TBL]'); //Database ����
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

   // Data ���� ���� ����
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
//  Query�� Result Set���� List ����
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
            // Database ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Query]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Query]'); // Database ����
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
         gf_ShowMessage(MessageBar, mtInformation, 1018, ''); //�ش� ������ �����ϴ�.
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

         // ����ó
         if sRcvCompKor <> AddrItem.RcvCompKor then
         begin
            sRcvCompKor := AddrItem.RcvCompKor;
            Cells[0, iRow] := AddrItem.RcvCompKor;
         end;

         // ���۱���
         if AddrItem.SendMtd = gcSEND_FAX then
         begin
            if AddrItem.IntTelYN = 'N' then  // ���� Fax
            begin
               Cells[1, iRow] := '����FAX';
               CellFont[1, iRow].Color := clNavy;
            end
            else   // ���� Fax
            begin
               Cells[1, iRow] := '����FAX';
               CellFont[1, iRow].Color := $00FD5A02;
            end;
         end
         else // Telex
         begin
            Cells[1, iRow] := 'TELEX';
            CellFont[1, iRow].Color := clPurple;
         end;
         SelectedFontColorCell[1, iRow] := CellFont[1, iRow].Color;

         // �����ڵ�
         Cells[2, iRow] := AddrItem.NatCode;

         // ��ü��ȣ
         Cells[3, iRow] := AddrItem.MediaNo;
      end;  // end of for
      gf_ShowMessage(MessageBar, mtInformation, 1021, gwQueryCnt + IntToStr(AddrList.Count)); // ��ȸ �Ϸ�
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

      // ����ó
      DREdit_RcvCompKor.Text := AddrItem.RcvCompKor;

      // ���۱���
      if AddrItem.SendMtd = gcSEND_FAX then
      begin
         if AddrItem.IntTelYN = 'N' then   // ����
            DREdit_FaxGubun.Text := '1'
         else   // ����
            DREdit_FaxGubun.Text := '2';
      end;

      // ��ü��ȣ
      DREdit_MediaNo.Text := AddrItem.MediaNo;
      
      // ������
      DREdit_OprId.Text := AddrItem.OprId;

      // ���۽ð�
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
//  ��ȸ
//------------------------------------------------------------------------------
procedure TDlgForm_RegFaxTlxAddr.DRBitBtn6Click(Sender: TObject);
begin
  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1020, ''); //��ȸ ���Դϴ�.
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
//  �Է�
//------------------------------------------------------------------------------
procedure TDlgForm_RegFaxTlxAddr.DRBitBtn5Click(Sender: TObject);
var
   iSendSeq : Integer;
   sSendMtd, sNatCode, sMediaNo, sIntTelYn : string;
begin
  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1010, ''); //�Է� ���Դϴ�.

   if CheckKeyEditEmpty(False) then Exit;   //�Է� ���� �׸� Ȯ��

   sSendMtd := gcSEND_FAX;

   sMediaNo := Trim(DREdit_MediaNo.Text);
   sIntTelYn := 'N';
   if DREdit_FaxGubun.Text = '2' then  // ����Fax
      sIntTelYn := 'Y';

   DisableForm;
   //-------------------
   gf_BeginTransaction;    // ä���� ����!
   //-------------------
   with ADOQuery_SUPRTAD do
   begin
      // �ش� ������ �����ϴ��� Ȯ��
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
         begin // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[SendSeq]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[SendSeq]'); //Database ����
            gf_RollbackTransaction;
            EnableForm;
            Exit;
         end;
      End;

      if RecordCount > 0 then // �ش� �����Ͱ� �����ϴ� ���
      begin
         gf_ShowMessage(MessageBar, mtError, 1066, ''); // �ش� ����ó�� �̹� ��ϵǾ� �ֽ��ϴ�.
         gf_RollbackTransaction;
         EnableForm;
         if SelectGridData(sSendMtd, sNatCode, sMediaNo, sIntTelYn) <= 0 then  // Grid Search Fail
         begin
            // List Refresh & Display
            if QueryToList then
            begin
               DisplayGridData;
               SelectGridData(sSendMtd, sNatCode, sMediaNo, sIntTelYn);
               gf_ShowMessage(MessageBar, mtError, 1066, ''); // �ش� ����ó�� �̹� ��ϵǾ� �ֽ��ϴ�.
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

      // ä��
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
         begin // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[SendSeq]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[SendSeq]'); //Database ����
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
         begin // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Insert]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Insert]'); //Database ����
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
   gf_ShowMessage(MessageBar, mtInformation, 1011, ''); // �Է� �Ϸ�
end;

//------------------------------------------------------------------------------
//  ����
//------------------------------------------------------------------------------
procedure TDlgForm_RegFaxTlxAddr.DRBitBtn4Click(Sender: TObject);
var
   AddrItem : pTSUPRTADData;
   iChkListIdx, iSendSeq : Integer;
   sSendMtd, sNatCode, sMediaNo, sIntTelYn : string;
begin
  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1007, ''); // ���� ���Դϴ�.

   if CheckKeyEditEmpty(False) then Exit;   //�Է� ���� �׸� Ȯ��

   sSendMtd := gcSEND_FAX;
   sMediaNo := Trim(DREdit_MediaNo.Text);
   sIntTelYn := 'N';
   if DREdit_FaxGubun.Text = '2' then  // ����Fax
      sIntTelYn := 'Y';

   iChkListIdx := GetAddrListIdx(sSendMtd, sNatCode, sMediaNo, sIntTelYn);
   if (iChkListIdx >= 0) and (SelectIdx <> iChkListIdx) then   // ������
   begin
      if SelectIdx < 0 then
         SelectIdx := iChkListIdx
      else   // SelectIdx�� �ڷḦ ������ ���� �ϴ� �ڷ�� �����Ϸ� ��
      begin
         gf_ShowMessage(MessageBar, mtError, 1148, '');  // ���� ��ü ��ȣ�� ����ó�� �̹� �����մϴ�. Ȯ�ιٶ��ϴ�.
         SelectGridData(sSendMtd, sNatCode, sMediaNo, sIntTelYn);
         DREdit_MediaNo.SetFocus;
         Exit;
      end;
   end;

   if SelectIdx < 0 then
   begin
      gf_ShowMessage(MessageBar, mtError, 1025, ''); //�ش� �ڷᰡ �������� �ʽ��ϴ�.
      DREdit_RcvCompKor.SetFocus;
      Exit;
   end;

   AddrItem := AddrList.Items[SelectIdx];
   iSendSeq := AddrItem.SendSeq;

   DisableForm;
   with ADOQuery_SUPRTAD do
   begin
      //--- �ش� ������ �����ϴ��� ��Ȯ��
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
         begin // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Select]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Select]'); //Database ����
            EnableForm;
            Exit;
         end;
      End;

      if RecordCount <= 0 then  // �ش� ������ �������� �ʴ°��
      begin
         // List Refresh & Display
         if QueryToList then
            DisplayGridData
         else
         begin
            DRStrGrid_Main.RowCount := 2;
            DRStrGrid_Main.Rows[1].Clear;
         end;
         gf_ShowMessage(MessageBar, mtError, 1025, ''); //�ش� �ڷᰡ �������� �ʽ��ϴ�.
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
         begin // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Update]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Update]'); //Database ����
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
   gf_ShowMessage(MessageBar, mtInformation, 1008, ''); // ���� �Ϸ�
end;

//------------------------------------------------------------------------------
//  ����
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
   gf_ShowMessage(MessageBar, mtInformation, 1005, ''); // ���� ���Դϴ�.

   if CheckKeyEditEmpty(True) then Exit;   //�Է� ���� �׸� Ȯ��

   sSendMtd := gcSEND_FAX;

   sMediaNo := Trim(DREdit_MediaNo.Text);
   sIntTelYn := 'N';
   if DREdit_FaxGubun.Text = '2' then  // ����Fax
      sIntTelYn := 'Y';

   sDeleteStr := '(' + Trim(DREdit_RcvCompKor.Text) + ' ' + Trim(sNatCode) + ' '
                 + Trim(sMediaNo) + ')';

   iChkListIdx := GetAddrListIdx(sSendMtd, sNatCode, sMediaNo, sIntTelYn);
   if iChkListIdx >= 0 then   // ������
      SelectIdx := iChkListIdx;
   if SelectIdx < 0 then
   begin
      gf_ShowMessage(MessageBar, mtError, 1025, ''); //�ش� �ڷᰡ �������� �ʽ��ϴ�.
      DREdit_RcvCompKor.SetFocus;
      Exit;
   end;

   AddrItem := AddrList.Items[SelectIdx];
   iSendSeq := AddrItem.SendSeq;

   DisableForm;
   with ADOQuery_SUPRTAD do
   begin
      //--- �ش� ������ �����ϴ��� ��Ȯ��
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
         begin // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Select]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Select]'); //Database ����
            EnableForm;
            Exit;
         end;
      End;

      if RecordCount <= 0 then  // �ش� ������ �������� �ʴ°��
      begin
         // List Refresh & Display
         if QueryToList then
            DisplayGridData
         else
         begin
            DRStrGrid_Main.RowCount := 2;
            DRStrGrid_Main.Rows[1].Clear;
         end;
         gf_ShowMessage(MessageBar, mtError, 1025, ''); //�ش� �ڷᰡ �������� �ʽ��ϴ�.
         EnableForm;
         SelectIdx := -1;  // Clear
         DREdit_RcvCompKor.SetFocus;
         Exit;
      end;

      //--- SUACCAD_TBL����  �ش� ����ó�� ���Ǵ��� Ȯ��
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
         begin // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[SUACCAD_TBL]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[SUACCAD_TBL]'); //Database ����
            EnableForm;
            Exit;
         end;
      End;

      sUsedList := '';  // Clear
      iUsedAccCnt := RecordCount;
      if iUsedAccCnt > 0 then  // ������ �ִ� ���
      begin
         while not Eof do
         begin
            sUsedList := sUsedList + ' [��ϰ���] ' +
                         gf_FormatAccNo(Trim(FieldByName('ACC_NO').asString),
                                        Trim(FieldByName('SUB_ACC_NO').asString)) +
                         Chr(13);
            Next;
         end;  // end of while
      end;  // end of if

      //--- SUCOMAD_TBL����  �ش� ����ó�� ���Ǵ��� Ȯ��
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
         begin // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[SUGRPAD_TBL]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[SUGRPAD_TBL]'); //Database ����
            EnableForm;
            Exit;
         end;
      End;

      iUsedComCnt := RecordCount;
      if iUsedComCnt > 0 then // ����� �ִ°��
      begin
         while not Eof do
         begin
            sUsedList := sUsedList + ' [��ϱ׷�] ' +
                         gf_SecTypeToName(Trim(FieldByName('SEC_TYPE').asString)) +
                         '-' +
                         Trim(FieldByName('GRP_NAME').asString) + Chr(13);
            Next;
         end;  // end of while
      end;  // end of if

      if (iUsedAccCnt > 0) or (iUsedComCnt > 0) then // Data �ִ� ���
      begin
         if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 1141, //�ش� ����ó�� �����ϴ� ���� �� ��� ������ �ֽ��ϴ�.
            sUsedList + Chr(13) + ' �����Ͻðڽ��ϱ�? ',
            [mbYes, mbCancel], 0) = idCancel then
         begin
            gf_ShowMessage(MessageBar, mtInformation, 1082, ''); //�۾��� ��ҵǾ����ϴ�.
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
         begin // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Delete SUPRTAD]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Delete SUPRTAD]'); //Database ����
            gf_RollBackTransaction;
            EnableForm;
            Exit;
         end;
      End;

      if iUsedAccCnt > 0 then  // ������ �ִ� ���
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
            begin // DataBase ����
               gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Delete SUACRPT]: ' + E.Message, 0);
               gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Delete SUACRPT]'); //Database ����
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
            begin // DataBase ����
               gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Delete SUACCAD]: ' + E.Message, 0);
               gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Delete SUACCAD]'); //Database ����
               gf_RollBackTransaction;
               EnableForm;
               Exit;
            end;
         End;
      end;

      if iUsedComCnt > 0 then  // ���׷� �ִ� ���
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
            begin // DataBase ����
               gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Delete SUGPRPT_TBL]: ' + E.Message, 0);
               gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Delete SUGPRPT_TBL]'); //Database ����
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
            begin // DataBase ����
               gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Delete SUGRPAD_TBL]: ' + E.Message, 0);
               gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Delete SUGRPAD_TBL]'); //Database ����
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
   gf_ShowMessage(MessageBar, mtInformation, 1006, sDeleteStr ); // ���� �Ϸ�
end;

//------------------------------------------------------------------------------
//  �μ�
//------------------------------------------------------------------------------
procedure TDlgForm_RegFaxTlxAddr.DRBitBtn2Click(Sender: TObject);
begin
  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1100, ''); // �μ� ���Դϴ�.
   with DrStringPrint1 do
   begin
      // Report Title
      Title  := Trim(Self.Caption);
      UserText1  := '';
      UserText2  := '';
      StringGrid   := DRStrGrid_Main;
      Print;
   end;

   gf_ShowMessage(MessageBar, mtInformation, 1101, ''); // �μ� �Ϸ�
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
   if iSearchIdx > -1 then  //�ش� ������ �����
   begin
      gf_SelectStrGridRow(DRStrGrid_Main, iSearchIdx + 1);
      Result := iSearchIdx + 1;
   end
   else  //�ش� ������ �������� ���� ��� ùRow Select
      gf_SelectStrGridRow(DRStrGrid_Main, 1);
end;

//------------------------------------------------------------------------------
//  �Է� ���� �׸� �ִ��� Ȯ��
//------------------------------------------------------------------------------
function TDlgForm_RegFaxTlxAddr.CheckKeyEditEmpty(DeleteFlag: boolean): boolean;
begin
   Result := True;

   // �ѽ���ȣ
   if Trim(DREdit_MediaNo.Text) = '' then
   begin
      gf_ShowMessage(MessageBar, mtError, 1012, '�ѽ���ȣ'); //�Է� ����
      DREdit_MediaNo.SetFocus;
      Exit;
   end;

   // �ѽ�����
   if Trim(DREdit_FaxGubun.Text) = '' then
   begin
      gf_ShowMessage(MessageBar, mtError, 1012, '���۱���'); //�Է� ����
      DREdit_FaxGubun.SetFocus;
      Exit;
   end;



   if not DeleteFlag then  //�Է�, �����ø� Ȯ��
   begin
      // ����ó
      if Trim(DREdit_RcvCompKor.Text) = '' then
      begin
         gf_ShowMessage(MessageBar, mtError, 1012, ''); //�Է� ����
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
      DRBitBtn5.SetFocus;  // �Է� ��ư Focus
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
   if Trim(DefSendMtd) = '' then Exit;  // Default Data ���� ���

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
      gf_ShowMessage(MessageBar,mtError,0,'���۱����� 1 Ȥ�� 2�̾�� �մϴ�.');
      DREdit_FaxGubun.Text := '';
      Exit;
    end;
  end;
end;

end.
