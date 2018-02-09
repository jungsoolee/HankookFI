//==============================================================================
//   �ۼ��� Manager Receive Form
//   [LMS] 2000/12/20
//==============================================================================
// !!! Display Routine Optimize...
//  < ����� �ڵ���... >
// - FormCreate�� Inherited ���� RcvTrxCode Assign
// - InitCodeComboParty, QueryToList Coding
// - Popup_DetailClick Coding - �� ����

unit SCCSRMgrForm_RCV;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCCSRMgrForm, Menus, DRStandard, Db, ADODB, DRAdditional, ExtCtrls,
  Grids, DRStringgrid, StdCtrls, DRCodeControl, DRSpecial, Buttons,
  SCCGlobalType;

type
  TForm_SCF_RCV = class(TForm_SRMgrForm)
    DRFramePanel_Query: TDRFramePanel;
    DRLabel_Party: TDRLabel;
    DRUserCodeCombo_Party: TDRUserCodeCombo;
    DRPanel_DataTitle: TDRPanel;
    DRLabel_Data: TDRLabel;
    DRPanel_FaxRadioBtnGroup: TDRPanel;
    DRLabel_B1: TDRLabel;
    DRLabel_B2: TDRLabel;
    DRRadioBtn_DataProcess: TDRRadioButton;
    DRRadioBtn_DataError: TDRRadioButton;
    DRRadioBtn_DataTotal: TDRRadioButton;
    DRCheckBox_DataTotFreq: TDRCheckBox;
    DRStrGrid_RcvData: TDRStringGrid;
    ADOQuery_Temp: TADOQuery;
    ADOQuery_Rcv: TADOQuery;
    DRPopupMenu_Data: TDRPopupMenu;
    Popup_Detail: TMenuItem;
    //-------------------------------------------------------
    function  InitCodeComboParty: boolean; virtual; abstract;
    function  QueryToList: boolean; virtual; abstract;
    //-------------------------------------------------------
    procedure DisplayGridData;
    procedure ClearRcvDataList;
    function  GetRcvDataListIdx(pGridRowIdx: Integer;
                                  var pDataListIdx, pFreqIdx: Integer): boolean;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DRCheckBox_DataTotFreqClick(Sender: TObject);
    procedure DRUserCodeCombo_PartyCodeChange(Sender: TObject);
    procedure DRStrGrid_RcvDataDblClick(Sender: TObject);
    procedure DRBitBtn2Click(Sender: TObject);
    procedure DRRadioBtn_DataProcessClick(Sender: TObject);
    procedure DRStrGrid_RcvDataMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    procedure OnRcvMsmqResult(var msg: TMessage); message WM_USER_MSMQ_RESULT;
  public
    RcvTrxCode   : string;        // ���� TRX Code
    RcvDataList  : TList;         // ���� ���� ����Ʈ
    SelRowIdx    : Integer;       // DRStrGrid_RcvData�� ���� Row Index
    DataTotFreqChecked : string;  // ���೻�� ��ȸ�� ��ȸ������ üũ�ڽ� ���󺹱��� ���
  end;

var
  Form_SCF_RCV: TForm_SCF_RCV;

type
  //=== �Ǽ��� ������ ����
  TComRcvData = Record
     PartyId    : string;
     PartyName  : string;
     DisplayAll : boolean;   // ��ȸ�� ���� �������� ����
     FreqList   : TList;
  end;
  pTComRcvData = ^TComRcvData;

  //=== ȸ�� ����
  TRcvDataFreq = Record
     FreqNo     : Integer;   // Party�� Seq ȸ��
     SentCnt    : Integer;   // ���� ȸ��
     SentTotSeq : Integer;   // �� ���۰Ǽ�
     RecvTotSeq : Integer;   // �� ���ŰǼ�
     ErrorCnt   : Integer;   // Error�Ǽ�
     RecvTime   : string;    // ȸ���� ù��° RECV_TIME
     SentTime   : string;    // ȸ���� ù��° TO_SENT_TIME
     GridRowIdx : Integer;   // StrGrid_Main�� display�� RowIndex
  end;
  pTRcvDataFreq = ^TRcvDataFreq;

  function RcvDataListCompare(Item1, Item2: Pointer): Integer;
  function RcvFreqListCompare(Item1, Item2: Pointer): Integer;
implementation

{$R *.DFM}

uses
   SCCLib, SCCCmuGlobal;

const
  PARTY_NAME_COLIDX = 0;     // DRStrGrid_RcvData�� ����ó Col Index
  FREQ_NO_COLIDX    = 1;     // DRStrGrid_RcvData�� ȸ�� Col Index
  ERROR_CNT_COLIDX  = 4;     // DRStrGrid_RcvData�� Error Count Col Index
  PROCESS_COLIDX    = 7;     // DRStrGrid_RcvData�� Process State Col Index

//------------------------------------------------------------------------------
//  Party Name ������ List Sorting
//------------------------------------------------------------------------------
function RcvDataListCompare(Item1, Item2: Pointer): Integer;
begin
   Result := gf_ReturnStrComp(pTComRcvData(Item1).PartyName,
                              pTComRcvData(Item2).PartyName,
                              True);
end;

//------------------------------------------------------------------------------
//  ȸ�� �������� List Sorting
//------------------------------------------------------------------------------
function RcvFreqListCompare(Item1, Item2: Pointer): Integer;
begin
   Result := gf_ReturnFloatComp(pTRcvDataFreq(Item1).FreqNo,
                                pTRcvDataFreq(Item2).FreqNo,
                                False);
end;

//------------------------------------------------------------------------------
//  Receive MSMQ Result
//------------------------------------------------------------------------------
procedure TForm_SCF_RCV.OnRcvMsmqResult(var msg: TMessage);
var
   I, K : Integer;
   DataItem : pTComRcvData;
   FreqItem : pTRcvDataFreq;
   iSentCnt : Integer;
   sSentPartyId, sCurPartyId : string;
begin
   if gvpTMSMQResult.sCurDate <> gvCurDate then Exit;
   if gvpTMSMQResult.sTranCode <> RcvTrxCode then Exit;
   if not Assigned(RcvDataList) then Exit;

   iSentCnt     := gf_StrToInt(Trim(gvpTMSMQResult.sSentCnt));   // ȸ��
   sSentPartyId := gvpTMSMQResult.sPartyId;   // Party Id

   // RcvDataList ���� �� DRStrGrid_Data ����
   for I := 0 to RcvDataList.Count -1 do
   begin
      DataItem := RcvDataList.Items[I];

      if (DataItem.PartyId = sSentPartyId) and
         (pTRcvDataFreq(DataItem.FreqList.Items[0]).SentCnt < iSentCnt) then
      begin    // ��ȸ�� Party�� ���� ȸ������ �� ���� ȸ��
         New(FreqItem);
         FreqItem.FreqNo     := pTRcvDataFreq(DataItem.FreqList.Items[0]).FreqNo + 1;  // ������ ȸ�� + 1
         FreqItem.SentCnt    := gf_StrToInt(Trim(gvpTMSMQResult.sSentCnt));
         FreqItem.SentTotSeq := gf_StrToInt(Trim(gvpTMSMQResult.sSendTotSeq));
         FreqItem.RecvTotSeq := gf_StrToInt(Trim(gvpTMSMQResult.sSeqNo));
         FreqItem.ErrorCnt   := gf_StrToInt(Trim(gvpTMSMQResult.sTotErrCnt));
         FreqItem.RecvTime   := gvpTMSMQResult.sRecvTime;
         FreqItem.SentTime   := gvpTMSMQResult.sSendTime;
         DataItem.FreqList.Add(FreqItem);
         // List Sorting (ȸ�� ����)
         DataItem.FreqList.Sort(RcvFreqListCompare);
         DisplayGridData;
         Exit;
      end;

      // �ش� Party, ȸ�� Search
      if DataItem.PartyId = sSentPartyId then
      begin
         for K := 0 to DataItem.FreqList.Count -1 do
         begin
            FreqItem := DataItem.FreqList.Items[K];
            if FreqItem.SentCnt = iSentCnt then
            begin
               FreqItem.RecvTotSeq := gf_StrToInt(Trim(gvpTMSMQResult.sSeqNo));
               FreqItem.ErrorCnt   := gf_StrToInt(Trim(gvpTMSMQResult.sTotErrCnt));
               if gf_StrToInt(Trim(gvpTMSMQResult.sSeqNo)) = 1 then  // ȸ���� ó�� ������
               begin
                  FreqItem.RecvTime   := gvpTMSMQResult.sRecvTime;
                  FreqItem.SentTime   := gvpTMSMQResult.sSendTime;
               end;

               if (K = 0) or (DataItem.DisplayAll) then // ������ ȸ���̰ų� ��ȸ�������� ���
               begin
                  if FreqItem.GridRowIdx < 0 then Exit;

                  with DRStrGrid_RcvData do
                  begin
                     // Font Color
                     if FreqItem.RecvTotSeq < FreqItem.SentTotSeq then     // ������
                        RowFont[FreqItem.GridRowIdx].Color := gcProcessColor
                     else if FreqItem.ErrorCnt > 0 then // Error �߻�
                        RowFont[FreqItem.GridRowIdx].Color := gcErrorColor
                     else
                        RowFont[FreqItem.GridRowIdx].Color := clBlack;
                     SelectedFontColorRow[FreqItem.GridRowIdx] := RowFont[FreqItem.GridRowIdx].Color;
                     Cells[3, FreqItem.GridRowIdx] := IntToStr(FreqItem.RecvTotSeq);
                     Cells[4, FreqItem.GridRowIdx] := IntToStr(FreqItem.ErrorCnt);
                     Cells[5, FreqItem.GridRowIdx] := gf_FormatTime(FreqItem.RecvTime);
                     Cells[6, FreqItem.GridRowIdx] := gf_FormatTime(FreqItem.SentTime);
                     if FreqItem.RecvTotSeq < FreqItem.SentTotSeq then
                        Cells[7, FreqItem.GridRowIdx] := gwRSProcessing
                     else
                     begin
                        if FreqItem.ErrorCnt > 0 then
                           Cells[7, FreqItem.GridRowIdx] := gwRSNotFinishAll
                        else
                           Cells[7, FreqItem.GridRowIdx] := gwRSFinishAll;
                     end;
                  end;  // end of with
               end;  // end of if
               Exit;
            end;  // end of if FreqItem.SentCnt = iSentCnt
         end;  // end of for K
      end;
   end; // end of for I

   // �������� �ʴ� Party (RcvDataList�� Party �߰�, �۽�ó Update)
   New(DataItem);
   RcvDataList.Add(DataItem);
   DataItem.PartyId    := sSentPartyId;
   DataItem.PartyName  := gf_PartyIdToName(sSentPartyId);
   DataItem.DisplayAll := DRCheckBox_DataTotFreq.Checked;
   DataItem.FreqList   := TList.Create;
   RcvDataList.Sort(RcvDataListCompare);

   New(FreqItem);
   FreqItem.FreqNo     := 1;
   FreqItem.SentCnt    := gf_StrToInt(Trim(gvpTMSMQResult.sSentCnt));
   FreqItem.SentTotSeq := gf_StrToInt(Trim(gvpTMSMQResult.sSendTotSeq));
   FreqItem.RecvTotSeq := gf_StrToInt(Trim(gvpTMSMQResult.sSeqNo));
   FreqItem.ErrorCnt   := gf_StrToInt(Trim(gvpTMSMQResult.sTotErrCnt));
   FreqItem.RecvTime   := gvpTMSMQResult.sRecvTime;
   FreqItem.SentTime   := gvpTMSMQResult.sSendTime;
   DataItem.FreqList.Add(FreqItem);
   // List Sorting
   DataItem.FreqList.Sort(RcvFreqListCompare);

   // �۽�ó Update (RcvDataList ����)
   sCurPartyId := DRUserCodeCombo_Party.Code;
   DRUserCodeCombo_Party.ClearItems;
   DRUserCodeCombo_Party.InsertAllItem := False;
   for I := 0 to RcvDataList.Count -1 do
   begin
      DataItem := RcvDataList.Items[I];
      DRUserCodeCombo_Party.AddItem(DataItem.PartyId, DataItem.PartyName);
   end;
   DRUserCodeCombo_Party.InsertAllItem := True;  // ��ü �׸� �߰�
   if not DRUserCodeCombo_Party.AssignCode(sCurPartyId) then
      DRUserCodeCombo_Party.AssignCode(gwTotal);

   // Data Display
   DisplayGridData;
end;

procedure TForm_SCF_RCV.FormCreate(Sender: TObject);
begin
  inherited;
   with DRStrGrid_RcvData do
   begin
      Color := gcGridBackColor;
      SelectedCellColor := gcGridSelectColor;
      RowCount := 2;
      Rows[1].Clear;
   end;

   RcvDataList := TList.Create;        // List ����
   if not Assigned(RcvDataList) then
   begin
      gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); //List ���� ����
      Close;
      Exit;
   end;
   if not InitCodeComboParty then
   begin
      gf_ShowErrDlgMessage(Self.Tag, 1030, '', 0); //ȭ�� �ʱ�ȭ �� ���� �߻�
      Close;
      Exit;
   end;
   DataTotFreqChecked := '';
   DRUserCodeCombo_Party.AssignCode(gwTotal);
   if QueryToList then
      DisplayGridData
   else   // ���� �߻�
   begin
      DRStrGrid_RcvData.RowCount := 2;
      DRStrGrid_RcvData.Rows[1].Clear;
   end;
end;

procedure TForm_SCF_RCV.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
   ClearRcvDataList;
   if Assigned(RcvDataList) then RcvDataList.Free;
   Form_SCF_RCV := nil;
end;

//------------------------------------------------------------------------------
//  Clear RcvDataList
//------------------------------------------------------------------------------
procedure TForm_SCF_RCV.ClearRcvDataList;
var
   I, K : Integer;
   DataItem : pTComRcvData;
   FreqItem : pTRcvDataFreq;
begin
   if not Assigned(RcvDataList) then Exit;
   for I := 0 to RcvDataList.Count -1 do
   begin
      DataItem := RcvDataList.Items[I];
      if Assigned(DataItem.FreqList) then
      begin
         for K := 0 to DataItem.FreqList.Count -1 do
         begin
            FreqItem := DataItem.FreqList.Items[K];
            Dispose(FreqItem);
         end;
         DataItem.FreqList.Free;
      end;
      Dispose(DataItem);
   end;
   RcvDataList.Clear;
end;

//------------------------------------------------------------------------------
//  RcvDataList ���� Display
//------------------------------------------------------------------------------
procedure TForm_SCF_RCV.DisplayGridData;
var
   DataItem : pTComRcvData;
   FreqItem : pTRcvDataFreq;
   iRow, TotRowCount : Integer;
   I, K : Integer;
begin
   DRLabel_Data.Caption := '>> ���� DATA ���� ����';
   with DRStrGrid_RcvData do
   begin
      // GridRowidx Clear
      for I := 0 to RcvDataList.Count -1 do
      begin
         DataItem := RcvDataList.Items[I];
         for K := 0 to DataItem.FreqList.Count -1 do
         begin
            FreqItem := DataItem.FreqList.Items[K];
            FreqItem.GridRowIdx := -1;
         end;
      end;

      // Row Count ���
      TotRowCount := 0;
      for I := 0 to RcvDataList.Count -1 do
      begin
         DataItem := RcvDataList.Items[I];
         //=== Data ���� Ȯ��
         if (DRUserCodeCombo_Party.Code <> gwTotal) and   // ����ó
            (DRUserCodeCombo_Party.Code <> DataItem.PartyId) then Continue;

         for K := 0 to DataItem.FreqList.Count -1 do
         begin
            if (not DataItem.DisplayAll) and (K > 0) then Break;

            FreqItem := DataItem.FreqList.Items[K];
            //=== Data ���� Ȯ��
            if (DRRadioBtn_DataProcess.Checked) and      // ������
               (FreqItem.RecvTotSeq >= FreqItem.SentTotSeq) then Continue;
            if (DRRadioBtn_DataError.Checked) and        // ���� �߻�
               (FreqItem.ErrorCnt = 0) then Continue;

            Inc(TotRowCount);
         end;
      end;

      if TotRowCount <= 0 then
      begin
         RowCount := 2;
         Rows[1].Clear;
         gf_ShowMessage(MessageBar, mtInformation, 1018, ''); //�ش� ������ �����ϴ�.
         Exit;
      end;
      RowCount := TotRowCount + 1;

      iRow := 0;
      for I := 0 to RcvDataList.Count -1 do
      begin
         DataItem := RcvDataList.Items[I];

         //=== Data ���� Ȯ��
         if (DRUserCodeCombo_Party.Code <> gwTotal) and
            (DRUserCodeCombo_Party.Code <> DataItem.PartyId) then Continue;

         for K := 0 to DataItem.FreqList.Count -1 do
         begin
            if (not DataItem.DisplayAll) and (K > 0) then Break; // ������ ȸ���� ����� ���

            FreqItem := DataItem.FreqList.Items[K];
            //=== Data ���� Ȯ��
            if (DRRadioBtn_DataProcess.Checked) and      // ������
               (FreqItem.RecvTotSeq >= FreqItem.SentTotSeq) then Continue;
            if (DRRadioBtn_DataError.Checked) and        // ���� �߻�
               (FreqItem.ErrorCnt = 0) then Continue;

            Inc(iRow);
            FreqItem.GridRowIdx := iRow;
            Rows[iRow].Clear;
            // Font Color
            if FreqItem.RecvTotSeq < FreqItem.SentTotSeq then     // ������
               RowFont[iRow].Color := gcProcessColor
            else if FreqItem.ErrorCnt > 0 then // Error �߻�
               RowFont[iRow].Color := gcErrorColor
            else
               RowFont[iRow].Color := clBlack;
            SelectedFontColorRow[iRow] := RowFont[iRow].Color;

            if K = 0 then  // ������ ȸ��
            begin
               ColorRow[iRow] := gcSubGridSelectColor;
               Cells[0, iRow] := DataItem.PartyName;
            end
            else
               ColorRow[iRow] := gcGridBackColor;

            Cells[1, iRow] := IntToStr(FreqItem.FreqNo);          // Party�� Seq ȸ��
            Cells[2, iRow] := IntToStr(FreqItem.SentTotSeq);      // Party�� �����۰Ǽ�
            Cells[3, iRow] := IntToStr(FreqItem.RecvTotSeq);      // Party�� �Ѽ��ŰǼ�
            Cells[4, iRow] := IntToStr(FreqItem.ErrorCnt);        // Party�� Error�Ǽ�
            Cells[5, iRow] := gf_FormatTime(FreqItem.RecvTime);   // ù��° ������ ���Žð�
            Cells[6, iRow] := gf_FormatTime(FreqItem.SentTime);   // ù��° ������ ���� �ð�
            if FreqItem.RecvTotSeq < FreqItem.SentTotSeq then     // ������
               Cells[7, iRow] := gwRSProcessing
            else  // �Ϸ�
            begin
               if FreqItem.ErrorCnt > 0 then
                  Cells[7, iRow] := gwRSNotFinishAll
               else
                  Cells[7, iRow] := gwRSFinishAll;
            end;
         end;  // end of for K
      end;  // end of for I
   end;  // end of with
   DRLabel_Data.Caption := DRLabel_Data.Caption + ' (' + gwQueryCnt
                           + IntToStr(TotRowCount) + ')';
   gf_ShowMessage(MessageBar, mtInformation, 1021, gwQueryCnt + IntToStr(TotRowCount)); //��ȸ �Ϸ�

end;

//------------------------------------------------------------------------------
//  ��ȸ������ ���� Click
//------------------------------------------------------------------------------
procedure TForm_SCF_RCV.DRCheckBox_DataTotFreqClick(Sender: TObject);
var
   I : Integer;
   DataItem : pTComRcvData;
   MyOrgChecked : boolean;
begin
  inherited;
   if Trim(DataTotFreqChecked) <> '' then
   begin
      if DataTotFreqChecked = 'T' then
         MyOrgChecked := True
      else
         MyOrgChecked := False;
      DataTotFreqChecked := '';

      if MyOrgChecked <> DRCheckBox_DataTotFreq.Checked then
      begin
         DRCheckBox_DataTotFreq.Checked := MyOrgChecked;
         Exit;
      end;
   end;

   for I := 0 to RcvDataList.Count -1 do
   begin
      DataItem := RcvDataList.Items[I];
      DataItem.DisplayAll := DRCheckBox_DataTotFreq.Checked;
   end;
   DisplayGridData;
end;

//------------------------------------------------------------------------------
//  �۽�ó�� ��ȸ
//------------------------------------------------------------------------------
procedure TForm_SCF_RCV.DRUserCodeCombo_PartyCodeChange(Sender: TObject);
begin
  inherited;
   DisplayGridData;
end;

//------------------------------------------------------------------------------
//  StrGrid_RcvData�� RowIndex�� RcvDataList�� Index Return
//------------------------------------------------------------------------------
function TForm_SCF_RCV.GetRcvDataListIdx(pGridRowIdx: Integer;
                                  var pDataListIdx, pFreqIdx: Integer): boolean;
var
   I, K : Integer;
   DataItem : pTComRcvData;
   FreqItem : pTRcvDataFreq;
begin
   Result := False;
   pDataListIdx := -1;
   pFreqIdx     := -1;
   if pGridRowIdx <= 0 then Exit;

   for I := 0 to RcvDataList.Count -1 do
   begin
      DataItem := RcvDataList.Items[I];
      for K := 0 to DataItem.FreqList.Count -1 do
      begin
         FreqItem := DataItem.FreqList.Items[K];
         if FreqItem.GridRowIdx = pGridRowIdx then
         begin
            pDataListIdx := I;
            pFreqIdx     := K;
            Result       := True;
            Exit;
         end;
      end;  // end of for K
   end; // end of for I
end;

//------------------------------------------------------------------------------
//  ��ȸ�� ���� ���� <-> ������ ȸ�� ���� ����
//------------------------------------------------------------------------------
procedure TForm_SCF_RCV.DRStrGrid_RcvDataDblClick(Sender: TObject);
var
   iDataIdx, iFreqIdx : Integer;
   DataItem : pTComRcvData;
begin
  inherited;
   gf_ClearMessage(MessageBar);
   if SelRowIdx <= 0 then Exit;
   if Trim(DRStrGrid_RcvData.Cells[PARTY_NAME_COLIDX, SelRowIdx]) = '' then Exit;

   if not GetRcvDataListIdx(SelRowIdx, iDataIdx, iFreqIdx) then
   begin
      gf_ShowMessage(MessageBar, mtError, 1068, ''); //�ش� ������ �о�� �� �����ϴ�.
      Exit;
   end;

   if (iDataIdx < 0) or (iDataIdx > RcvDataList.Count -1) then
   begin
      gf_ShowMessage(MessageBar, mtError, 1068, ''); //�ش� ������ �о�� �� �����ϴ�.
      Exit;
   end;

   DataItem := RcvDataList.Items[iDataIdx];
   DataItem.DisplayAll := not DataItem.DisplayAll;
   DisplayGridData;
end;

//------------------------------------------------------------------------------
//  ���� ��ư Ŭ��
//------------------------------------------------------------------------------
procedure TForm_SCF_RCV.DRBitBtn2Click(Sender: TObject);
var
   CurPartyCode : string;
begin
  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1020, ''); //��ȸ ���Դϴ�.
   DisableForm;

   CurPartyCode := DRUserCodeCombo_Party.Code;
   InitCodeComboParty;
   if not DRUserCodeCombo_Party.AssignCode(CurPartyCode) then
      DRUserCodeCombo_Party.AssignCode(gwTotal);

   if QueryToList then
      DisplayGridData
   else   // ���� �߻�
   begin
      DRStrGrid_RcvData.RowCount := 2;
      DRStrGrid_RcvData.Rows[1].Clear;
   end;
   EnableForm;
end;

//------------------------------------------------------------------------------
//  ���� ���º� ��ȸ
//------------------------------------------------------------------------------
procedure TForm_SCF_RCV.DRRadioBtn_DataProcessClick(Sender: TObject);
var
   PreState : boolean;
begin
  inherited;
   // ��ü or ���� �߻�
   if (DRRadioBtn_DataTotal.Checked) or (DRRadioBtn_DataError.Checked) then
   begin
      DRCheckBox_DataTotFreq.Enabled := True;
      if Trim(DataTotFreqChecked) <> '' then
         DRCheckBox_DataTotFreqClick(DRCheckBox_DataTotFreq);  //���󺹱�
   end
   // ������ ���� (DRRadioBtn_DataProcess.Checked)
   else
   begin
      PreState := DRCheckBox_DataTotFreq.Checked;
      DRCheckBox_DataTotFreq.Enabled := False;
      DRCheckBox_DataTotFreq.Checked := True;
      if PreState then
         DataTotFreqChecked := 'T'
      else
         DataTotFreqChecked := 'F';
   end;
   DisplayGridData;
end;

procedure TForm_SCF_RCV.DRStrGrid_RcvDataMouseUp(Sender: TObject;
                       Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   ACol, ARow : Integer;
   ScreenP : TPoint;
begin
  inherited;
   with (Sender as TDRStringGrid) do
   begin
      MouseToCell(X, Y, ACol, ARow);

      if (ARow <= 0) or (ACol < 0) then Exit;
      SelRowIdx := ARow;

      if (Trim(Cells[FREQ_NO_COLIDX, ARow]) = '') then Exit;

      if Button = mbRight then
      begin
         gf_SelectStrGridRow((Sender as TDRStringGrid), ARow);
         GetCursorPos(ScreenP);
         DRPopupMenu_Data.Popup(ScreenP.X, ScreenP.Y);
      end;
   end;
end;

end.
