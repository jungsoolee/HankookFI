//==============================================================================
//   [LMS] 2000/12/18
//==============================================================================
unit SCCPSInputBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCCDlgForm, StdCtrls, Buttons, DRAdditional, ExtCtrls, DRStandard,
  DRSpecial, DRDialogs, DB, ADODB;

type
  TDlgForm_PSInputBox = class(TForm_Dlg)
    DRPanel_Top: TDRPanel;
    DRMemo_LineNo: TDRMemo;
    DRMemo_PS: TDRMemo;
    DRPanel_Left: TDRPanel;
    DRMemo1: TDRMemo;
    DRMemo_LeftPS: TDRMemo;
    DRPanel_Right: TDRPanel;
    DRMemo3: TDRMemo;
    DRMemo_RightPS: TDRMemo;
    DRPanel1: TDRPanel;
    DRLabel1: TDRLabel;
    ADOQuery_InputPS: TADOQuery;
    DRPanel2: TDRPanel;
    DRLabel4: TDRLabel;
    procedure FormCreate(Sender: TObject);
    //
    procedure DRMemo_PSKeyPress(Sender: TObject; var Key: Char);
    procedure DRMemo_PSKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DRMemo_LineNoKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
    //
    procedure DRBitBtn3Click(Sender: TObject);  //삭제
    procedure DRBitBtn4Click(Sender: TObject);
    procedure DRBitBtn2Click(Sender: TObject);  //입력
  private
    { Private declarations }
    function PSDataInsert: Boolean;
  public
    TradeDate : String;
    AccNm     : String;
    SubAccNo  : String;
    MediaNo   : String;
    ReportID  : String;
    Grptype   : String;

    MaxColCnt, MaxRowCnt : Integer;  // 최대 입력 가능 Col, Row 수
  end;

var
  DlgForm_PSInputBox: TDlgForm_PSInputBox;
  function PSDataDelete: Boolean;

implementation

{$R *.DFM}

uses
  SCCLib,SCCGlobalType;

const
   All_Height    = 319;
   Normal_Height = 205;

procedure TDlgForm_PSInputBox.DRMemo_PSKeyPress(Sender: TObject; var Key: Char);
var
   Line, Col : Integer;
   MxRowCnt  : Integer;
begin
   inherited;

   if TDRMemo(Sender).Tag = 0 then MxRowCnt := MaxRowCnt else MxRowCnt := 3;

   with (Sender as TMemo) do
   begin
      Line := Perform(EM_LINEFROMCHAR, SelStart, 0);
      Col  := SelStart - Perform(EM_LINEINDEX, Line, 0);
      if Key = #8 then  // Back Space
      begin
         if (Col = 0) and (Line > 0) then
         begin
            if (Length(Lines[Line]) + Length(Lines[Line-1])) > MaxColCnt then
               Key := #0;
         end;
      end
      else if Key in [#13, #10] then  // Enter, Ctrl+Enter
      begin
         if Lines.Count >= MxRowCnt then
         begin
            Key := #0;
            if Line = (MxRowCnt -1) then
               SelStart := Perform(EM_LINEINDEX, Line, 0)
            else
               SelStart := Perform(EM_LINEINDEX, Line+1, 0);
         end;
      end
      else if Key >= '' then
      begin
         if Length(Lines[Line]) >= MaxColCnt then
            Key := #0;
      end;
   end;  // end of with
   if Key = #0 then Beep;
end;

procedure TDlgForm_PSInputBox.DRMemo_PSKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
   Line, Col : Integer;
   MxRowcnt  : Integer;
begin
  inherited;

   if TDRMemo(Sender).Tag = 0 then MxRowCnt := MaxRowCnt else MxRowCnt := 3;

   with (Sender as TMemo) do
   begin
      Line := Perform(EM_LINEFROMCHAR, SelStart, 0);
      Col  := SelStart - Perform(EM_LINEINDEX, Line, 0);
      if Key = VK_DELETE then
      begin
         if Col = Length(Lines[Line]) then
         begin
            if (Line < (MxRowCnt -1)) and
               ((Length(Lines[Line]) + Length(Lines[Line+1]))> MaxColCnt) then
            begin
               Key := 0;
               Beep;
            end;
         end;
      end
      else if Key = VK_DOWN then
      begin
         if Line = MxRowCnt -1 then
         begin
            Key := 0;
            Beep;
         end;
      end;
   end;  // end of with
end;

procedure TDlgForm_PSInputBox.FormCreate(Sender: TObject);
begin
  inherited;
//   SendMessage(DRMemo_PS.Handle, EM_SETMARGINS, EC_LEFTMARGIN, MEMO_LEFT_MARGIN);
   if (gvDeptCode = '03') or
      (gvDeptCode = '04') then
   begin
      Height := Normal_Height;
      DRPanel_Left.Visible := False;
      DRPanel_Right.Visible := False;
      DRPanel1.Visible := False;
      DRPanel2.Visible := False;
   end;
end;

procedure TDlgForm_PSInputBox.DRBitBtn3Click(Sender: TObject);
begin
//  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1005, ''); //삭제 중입니다.

   PSDataDelete;
   DRMemo_PS.Lines.Clear;
   DRMemo_LeftPS.Lines.Clear;
   DRMemo_RightPS.Lines.Clear;

   gf_ShowMessage(MessageBar, mtInformation, 1006, '');  //삭제 완료

end;

procedure TDlgForm_PSInputBox.DRMemo_LineNoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
   Key := 0;
end;

procedure TDlgForm_PSInputBox.DRBitBtn4Click(Sender: TObject);
begin
  inherited;
   if (Trim(DRMemo_PS.Lines.Text)      = '') and
      (Trim(DRMemo_LeftPS.Lines.Text)  = '') and
      (Trim(DRMemo_RightPS.Lines.Text) = '') then
   begin
      gf_ShowMessage(MessageBar, mtError, 1012, '입력할 내용이 없습니다.'); //입력 오류
      Exit;
   end;
   
   gf_ShowMessage(MessageBar, mtInformation, 1010, ''); //입력 중입니다.
   DisableForm;

   gf_BeginTransaction;
   if not PSDataDelete then
   begin
      gf_RollBackTransaction;
      EnableForm;
      exit;
   end;
   if not PSDataInsert then
   begin
      gf_RollBackTransaction;
      EnableForm;
      exit;
   end;
   gf_CommitTransaction;

   EnableForm;
   gf_ShowMessage(MessageBar, mtInformation, 1011, ''); //입력 완료

   //ModalResult := mrOK;
end;

function TDlgForm_PSInputBox.PSDataInsert: Boolean;
begin
  result := False;
  with ADOQuery_InputPS do
  begin
    //=== 삽입
    Close;
    SQL.Clear;
    SQL.Add(' Insert SCFAXPS_TBL '
          + ' ( DEPT_CODE, SEC_TYPE, TRADE_DATE, ACC_NAME, SUB_ACC_NO, MEDIA_NO, REPORT_ID, GRP_TYPE, '
          + '   PS_DEFAULT, PS_LEFT, PS_RIGHT, OPR_ID, OPR_DATE, OPR_TIME )                           '
          + ' Values                                                                                  '
          + ' ( :pDeptCode, :pSecType, :pTradeDate, :pAccName, :pSubAccNo, :pMediaNo, :pReportID, :pGroupType, '
          + '   :pPSDefault, :pPSLeft,  :pPSRight,  :pOprId, :pOprDate, :pOprTime )');
    // 부서코드
    Parameters.ParamByName('pDeptCode').Value  := gvDeptCode;
    // SECType
    Parameters.ParamByName('pSecType').Value   := gcSEC_EQUITY;
    // 매매일자
    Parameters.ParamByName('pTradeDate').Value := TradeDate;
    // 계좌번호 or 그룹명
    Parameters.ParamByName('pAccName').Value   := AccNm;
    // 부계좌번호
    Parameters.ParamByName('pSubAccNo').Value  := SubAccNo;
    // 수신처 No
    Parameters.ParamByName('pMediaNo').Value   := MediaNo;
    // 레포트id
    Parameters.ParamByName('pReportID').Value  := ReportID;
    // 그룹타입
    Parameters.ParamByName('pGroupType').Value := Grptype;
    // PS
    Parameters.ParamByName('pPSDefault').Value := DRMemo_PS.Text;
    // Left PS
    Parameters.ParamByName('pPSLeft').Value    := DRMemo_LeftPS.Text;
    // Right PS
    Parameters.ParamByName('pPSRight').Value   := DRMemo_RightPS.Text;
    // 조작자
    Parameters.ParamByName('pOprId').Value     := gvOprUsrNo;
    // 조작일자
    Parameters.ParamByName('pOprDate').Value   := gvCurDate;
    // 조작시간
    Parameters.ParamByName('pOprTime').Value   := gf_GetCurTime;

    Try
      gf_ADOExecSQL(ADOQuery_InputPS);
    Except
      on E : Exception do
      begin  // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_InputPS[Insert]: ' + E.Message,0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_InputPS[Insert]'); //Database 오류
        EnableForm;
        Exit;
      end;
    End;
  end; // end of with
  EnableForm;
  result := True;

end;

function PSDataDelete: Boolean;
begin
  result := False;
  with DlgForm_PSInputBox.ADOQuery_InputPS do
  begin
    //=== 삭제
    Close;
    SQL.Clear;
    SQL.Add(' DELETE FROM SCFAXPS_TBL '
          + ' WHERE DEPT_CODE = ''' + gvDeptCode   + ''' '
          + '   AND SEC_TYPE  = ''' + gcSEC_EQUITY + ''' '
          + '   AND TRADE_DATE = ''' + DlgForm_PSInputBox.TradeDate   + ''' '
          + '   AND ACC_NAME   = ''' + DlgForm_PSInputBox.AccNm       + ''' '
          + '   AND SUB_ACC_NO = ''' + DlgForm_PSInputBox.SubAccNo    + ''' '
          + '   AND GRP_TYPE   = ''' + DlgForm_PSInputBox.Grptype     + ''' '
          + '   AND MEDIA_NO   = ''' + DlgForm_PSInputBox.MediaNo     + ''' '
          + '   AND REPORT_ID  = ''' + DlgForm_PSInputBox.ReportID    + ''' ');

    Try
      gf_ADOExecSQL(DlgForm_PSInputBox.ADOQuery_InputPS);
    Except
      on E : Exception do
      begin  // DataBase 오류
        gf_ShowErrDlgMessage(DlgForm_PSInputBox.Tag, 9001, 'ADOQuery_InputPS[Delete]: ' + E.Message,0);
        Exit;
      end;
    End;
  end; // end of with
  result := True;

end;

procedure TDlgForm_PSInputBox.DRBitBtn2Click(Sender: TObject);
begin
  inherited;

   ModalResult := mrOK;
end;

end.
