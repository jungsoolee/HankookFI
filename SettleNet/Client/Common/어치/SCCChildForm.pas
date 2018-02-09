//==============================================================================
//   SettleNet 최상위폼
//   [LMS] 2001/11/27
//   Max Size : Height 606, Width 1013
//==============================================================================

unit SCCChildForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DRSpecial, ExtCtrls, DRStandard, StdCtrls, Buttons, DRAdditional, SCCGlobalType,
  Printers, DRCodeControl, Db, ADODB, DRStringgrid, DRDialogs,
  ComObj,OleServer, IniFiles, Excel2000, Variants;

type
  TForm_SCF = class(TForm)
    DRPanel_Top: TDRPanel;
    MessageBar: TDRMessageBar;
    DRPanel_Title: TDRPanel;
    DRBitBtn1: TDRBitBtn;
    DRBitBtn2: TDRBitBtn;
    DRBitBtn3: TDRBitBtn;
    DRBitBtn4: TDRBitBtn;
    DRBitBtn5: TDRBitBtn;
    DRBitBtn6: TDRBitBtn;
    ProcessMsgBar: TDRPanel;
    DRPanel_Decision: TDRPanel;
    DRPanel_DecBack: TDRPanel;
    DRPanel_DecTitle: TDRPanel;
    DRBitBtn_DecRefresh: TDRBitBtn;
    DRBitBtn_DecClose: TDRBitBtn;
    DRPanel_DecTray: TDRPanel;
    ADOQuery_DECLN: TADOQuery;
    DRPanel_DecMsg: TDRPanel;
    DRSaveDialog_GridExport: TDRSaveDialog;
    procedure DRBitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ShowProcessMsgBar;
    procedure HideProcessMsgBar;
    procedure EnableForm;
    procedure DisableForm;
    procedure FormShow(Sender: TObject);
    procedure DRBitBtn_DecCloseClick(Sender: TObject);
    procedure DRBitBtn_DecRefreshClick(Sender: TObject);
    procedure ProcessDecision(pStlDate: string);
    procedure DestroyDecControl;
    procedure DecBtnClick(Sender: TObject);  // 결재 버튼 처리
    procedure ShowDecMessage(pMsgType: TMsgDlgType; pMsg: string);  // 결재 메세지 처리
    procedure ClearDecMessage;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FormDisabled : boolean;      // Form이 Disable 되어 있는지 여부
    CompStatList : TStringList;  // Component의 Enable/Disable 상태를 저장
    gDecStlDate  : string;       // 결재라인에서의 결제일자
    DecLabelList : TList;   // 결재처리관련 Label List
    DecBtnList   : TList;   // 결재처리관련 Button List
    CxlBtnList   : TList;   // 결재처리관련 Button List
    procedure OnRcvRefreshCodeControl(var Msg: TMessage); message WM_USER_REFRESH_CODECONTROL;
    procedure ChildFormGridExport(DRGrid1: TDRStringGrid);
    procedure CxlBtnClick(Sender: TObject);
    procedure TopBtnClick(sCaption : string);
  public
    DefFormHeight, DefFormWidth: Integer;
    Authority : Integer;
    FJobDate : string;
    function CheckJobDate(ctr : TDRMaskEdit): boolean;
    procedure SetJobDate(ctr : TDRMaskEdit);

    procedure RefreshForm; virtual;
  end;

var
  Form_SCF: TForm_SCF;

implementation

{$R *.DFM}

uses
   SCCLib, SCCCmuLib;

//var
//   ug_OriFormWidth, ug_OriFormHeight : integer;
//------------------------------------------------------------------------------
//  Refresh Code Component
//------------------------------------------------------------------------------
procedure TForm_SCF.OnRcvRefreshCodeControl(var Msg: TMessage);
var
   I : Integer;
begin

   //=== Team_Code
   if (Msg.WParam = gcCODE_TABLE_SETEMCD) then
   begin
      for I := 0 to ComponentCount -1 do
      begin
         if Components[I] is TDRTeamCodeCombo then
            (Components[I] as TDRTeamCodeCombo).Refresh;
      end;
   end;

   //=== Fund_Type
   if (Msg.WParam = gcCODE_TABLE_SCFTYPE) then
   begin
      for I := 0 to ComponentCount -1 do
      begin
         if Components[I] is TDRFundTypeCombo then
            (Components[I] as TDRFundTypeCombo).Refresh;
      end;
   end;

   //=== Send_Mtd
   if (Msg.WParam = gcCODE_TABLE_SCSNDMT) then
   begin
      for I := 0 to ComponentCount -1 do
      begin
         if Components[I] is TDRSendMtdCombo then
            (Components[I] as TDRSendMtdCombo).Refresh;
      end;
   end;

   //=== ISSUE_CODE (Equity)
   if (Msg.WParam = gcCODE_TABLE_SCISSIF) then
   begin
      for I := 0 to ComponentCount -1 do
      begin
         if Components[I] is TDRIssueCodeCombo then
            (Components[I] as TDRIssueCodeCombo).Refresh;
      end;
   end;

   //=== PARTY_ID, DEPT_CODE
   if (Msg.WParam = gcCODE_TABLE_SCPARTY) then
   begin
      for I := 0 to ComponentCount -1 do
      begin
         if Components[I] is TDRPartyIDCombo then
            (Components[I] as TDRPartyIDCombo).Refresh
         else if Components[I] is TDRDeptCodeCombo then
            (Components[I] as TDRDeptCodeCombo).Refresh;
      end;
   end;

   //=== DEPT_CODE
   if (Msg.WParam = gcCODE_TABLE_SUDEPCD) then
   begin
      for I := 0 to ComponentCount -1 do
      begin
         if Components[I] is TDRDeptCodeCombo then
            (Components[I] as TDRDeptCodeCombo).Refresh;
      end;
   end;

   //=== TRAN_CODE
   if (Msg.WParam = gcCODE_TABLE_SUTRNCD) then
   begin
      for I := 0 to ComponentCount -1 do
      begin
         if Components[I] is TDRTranCodeCombo then
            (Components[I] as TDRTranCodeCombo).Refresh;
      end;
   end;

   //=== COMP_CODE
   if (Msg.WParam = gcCODE_TABLE_SUCOMCD) then
   begin
      for I := 0 to ComponentCount -1 do
      begin
         if Components[I] is TDRCompCodeCombo then
            (Components[I] as TDRCompCodeCombo).Refresh
         else if Components[I] is TDRCompCodeDblCombo then
            (Components[I] as TDRCompCodeDblCombo).Refresh
      end;
   end;
end;

//------------------------------------------------------------------------------
//  종료
//------------------------------------------------------------------------------
procedure TForm_SCF.DRBitBtn1Click(Sender: TObject);
begin
   Close;
end;

//------------------------------------------------------------------------------
//  Form Close
//------------------------------------------------------------------------------
procedure TForm_SCF.FormClose(Sender: TObject; var Action: TCloseAction);
var
   sCurTime, sCurDate : String;
begin
   SendMessage(gvMainFrameHandle, WM_USER_BF_FORM_CLOSE, Self.Tag, 0);
   CompStatList.Free;
   Action := caFree;

//==============================================================================
// TR화면 사용기록 gc
//==============================================================================
  sCurTime := gf_GetCurTime;
  sCurDate := gf_GetCurDate;
  gf_LogLstWrite(nil, gvDeptCode, gcDisINF_tr, gvOprUsrNo,
                 sCurDate, '', sCurTime, gvLocalIP, '', IntToStr(Tag), Caption, 'U');
end;

//------------------------------------------------------------------------------
//  Form Create
//------------------------------------------------------------------------------
procedure TForm_SCF.FormCreate(Sender: TObject);
var  i : integer;
     s : string;
   sCurTime, sCurDate : String;
begin
  Top  := 5;
  Left := 5;
  gDecStlDate  := ''; // Clear;
  FormDisabled := False;
  CompStatList := TStringList.Create;
{
   //Grid의 숨은 Column의 FixedRowClick Button을 보이고 활성화 시키려면
   //Grid의 스크롤을 움직여야 한다.
   //콤포넌트의 버그를 피하고자 꼼수를 씀.
   //윈도Size를 늘렸다가 줄이면서 Grid의 스크롤을 움직이게 함.
   //즉,Grid가 Align이 alNone만 아니면 아니 꼼수가 먹힐 가능성이 큼.
   //FormCreate 에서 늘렸다가
   //FormShow에서 원상복구
   ug_OriFormWidth  := Width ;
   ug_OriFormHeight := Height ;
   Width  := Width + 1024;
   Height := Height + 1024;
}
  // Function Key 만들기 : Caption에 이름만.
  for i := 0 to DRPanel_Top.ControlCount -1 do
  begin
    if DRPanel_Top.Controls[i].ClassName = 'TDRBitBtn' then
    begin
      s := (DRPanel_Top.Controls[i] as TDRBitBtn).Caption;
      if s = '조회' then
        (DRPanel_Top.Controls[i] as TDRBitBtn).Caption := s + '(F3)'
      else if s = '입력' then
        (DRPanel_Top.Controls[i] as TDRBitBtn).Caption := s + '(F4)'
      else if s = '수정' then
        (DRPanel_Top.Controls[i] as TDRBitBtn).Caption := s + '(F5)'
      else if s = '삭제' then
        (DRPanel_Top.Controls[i] as TDRBitBtn).Caption := s + '(F6)'
      else if s = '인쇄' then
        (DRPanel_Top.Controls[i] as TDRBitBtn).Caption := s + '(F7)'
      else if s = '종료' then
        (DRPanel_Top.Controls[i] as TDRBitBtn).Caption := s + '(F9)';
    end;  // end of if
  end; //For

//==============================================================================
// TR화면 사용기록 gc
//==============================================================================
  sCurTime := gf_GetCurTime;
  sCurDate := gf_GetCurDate;
  gf_LogLstWrite(nil, gvDeptCode, gcDisINF_tr, gvOprUsrNo,
                 sCurDate, sCurTime, '', gvLocalIP, '', IntToStr(Tag), Caption, 'I');
end;

//------------------------------------------------------------------------------
//  Show ProcessMsgBar
//------------------------------------------------------------------------------
procedure TForm_SCF.ShowProcessmsgBar;
begin
   ProcessMsgBar.BringToFront;
   ProcessMsgBar.Visible := True;
   ProcessMsgBar.Repaint;
   DisableForm;
   Sleep(500);
end;

//------------------------------------------------------------------------------
//  Hide ProcessMsgBar
//------------------------------------------------------------------------------
procedure TForm_SCF.HideProcessMsgBar;
begin
   EnableForm;
   ProcessMsgBar.Visible := False;
   Repaint;
end;

//------------------------------------------------------------------------------
//  Enable Form
//------------------------------------------------------------------------------
procedure TForm_SCF.EnableForm;
var
   I, iStatIdx : Integer;
begin
   if not FormDisabled then Exit; // 이미 Form Enable 상태

   Screen.Cursor := crDefault;
   iStatIdx := -1;
   for I := 0 to ComponentCount -1 do
   begin
      if (Components[I] is TButton) or
         (Components[I] is TSpeedButton) then // Button 처리
//         (Components[I] is TPanel) then     // Panel 차리 삭제: Active Form뒤에서의 Popup Jumping시 오류 발생 방지
      begin
         Inc(iStatIdx);
         (Components[I] as TControl).Enabled := False;
         if CompStatList.Strings[iStatIdx] = 'E' then  // Enable 상태
         begin
            (Components[I] as TControl).Enabled := True;
         end;
      end;
   end;  // end of for
   gf_EnableMainMenu;

   FormDisabled := False;
end;

//------------------------------------------------------------------------------
//  Disable Form
//------------------------------------------------------------------------------
procedure TForm_SCF.DisableForm;
var
   I : Integer;
begin
   if FormDisabled then Exit;  // 이미 Form Disable 상태

   Screen.Cursor := crHourGlass;
   CompStatList.Clear;
   for I := 0 to ComponentCount -1 do
   begin
      if (Components[I] is TButton) or
         (Components[I] is TSpeedButton) then // Button만 처리
//         (Components[I] is TPanel) then  // Panel 차리 삭제: Active Form뒤에서의 Popup Jumping시 오류 발생 방지
      begin
         // 현재 상태 저장
         if (Components[I] as TControl).Enabled then // Enable 상태
             CompStatList.Add('E')
         else  // Disable 상태
             CompStatList.Add('D');
         (Components[I] as TControl).Enabled := False;
      end;
   end;
   gf_DisableMainMenu;
   
   FormDisabled := True;
end;

//------------------------------------------------------------------------------
//  버튼 권한 부여
//------------------------------------------------------------------------------
procedure TForm_SCF.FormShow(Sender: TObject);
var
   I : Integer;
begin
//   Width := ug_OriFormWidth;
//   Height := ug_OriFormHeight;
   
   Authority := gcAUTH_QUERY_ONLY;   // 조회만 가능
   if gf_CanUseTrCode(Self.Tag) then
      Authority := gcAUTH_ALL;       // 모든권한

   for I := 0 to ComponentCount -1 do
   begin
      if ((Components[I] is TButton) or (Components[I] is TSpeedButton)) and
         ((Components[I] as TControl).Enabled) then  // Enable인 Component만
      begin
         gf_EnableBtn(Self.Tag, (Components[I] as TControl));
      end;
   end;  // end of for

   gf_ControlCenterAllign(Self,DRPanel_Decision);
   gf_ControlCenterAllign(Self,ProcessMsgBar);
end;

//==============================================================================
//  결재라인 처리
//==============================================================================
//------------------------------------------------------------------------------
//  결재판 숨김
//------------------------------------------------------------------------------
procedure TForm_SCF.DRBitBtn_DecCloseClick(Sender: TObject);
begin
   gDecStlDate := '';  // Clear;
   DestroyDecControl;  // Free Control
   DRPanel_Decision.Visible := False;
   EnableForm;
end;

//------------------------------------------------------------------------------
//  결재판 갱신
//------------------------------------------------------------------------------
procedure TForm_SCF.DRBitBtn_DecRefreshClick(Sender: TObject);
var
   PreProcessed : boolean;
   iDecLevel, I : Integer;
   DecLabel : TDRLabel;
   DecBtn,CxlBtn   : TDRBitBtn;
   sMainOprId, sOprId, sOprName : string;
begin
   // 해당 화면의 결재 상태 Setting
   ClearDecMessage;
   with ADOQuery_DECLN do
   begin
      Close;
      SQL.Clear;
      SQL.Add(' select t.DEC_LEVEL, t.MAIN_OPR_ID, '
            + '        OPR_ID = ISNull(a.OPR_ID, ''''), a.OPR_DATE, a.OPR_TIME, '
            + '        OPR_NAME = (select u.USER_NAME '
            + '                    from SUUSER_TBL u '
            + '                    where u.USER_ID = a.OPR_ID) '
            + ' from  SUTRDEC_TBL t, SUDAILD_TBL a '
            + ' where t.DEPT_CODE = ''' + gvDeptCode + ''' '
            + '     and t.TR_CODE = ''' + IntToStr(Self.Tag) + ''' '
            + '     and t.DEPT_CODE *= a.DEPT_CODE '
            + '     and t.TR_CODE *= a.TR_CODE '
            + '     and t.DEC_LEVEL *= a.DEC_LEVEL '
            + '     and a.STL_DATE = ''' + gDecStlDate + ''' '
            + '     and t.DEC_LEVEL < 8 '
            + ' order by t.DEC_LEVEL' );
      Try
         gf_ADOQueryOpen(ADOQuery_DECLN);
      Except
         on E : Exception do
         begin  // DataBase 오류
            ShowDecMessage(mtError, '결재 처리중 오류 발생!');
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SUTRDEC_TBL]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SUTRDEC_TBL]'); //Database 오류
            Exit;
         end;
      End;

      PreProcessed := True;
      while not Eof do
      begin
         iDecLevel  := FieldByName('DEC_LEVEL').asInteger;
         sMainOprId := FieldByName('MAIN_OPR_ID').asString;
         sOprId     := FieldByName('OPR_ID').asString;
         sOprName   := FieldByName('OPR_NAME').asString;

         // 해당 Label, 버튼 처리
         for I := 0 to DecBtnList.Count -1 do
         begin
            DecBtn   := DecBtnList.Items[I];
            DecLabel := DecLabelList.Items[I];
            CxlBtn   := CxlBtnList.Items[I];
            if DecBtn.Tag = iDecLevel then  // 해당 결재 단계
            begin
               DecLabel.Caption := MoveDataStr(DecBtn.Caption, 9) + ' : ' +  sOprName;
               if Trim(sOprId) <> '' then  // 결재 처리 - 결재시간출력
                  DecLabel.Caption := DecLabel.Caption + ' (' +
                           copy(gf_FormatDate(Trim(FieldByName('OPR_DATE').asString)), 6, 5) + ',' +
                           copy(gf_FormatTime(Trim(FieldByName('OPR_TIME').asString)), 1, 8) + ')';

               // 결재 Button
               DecBtn.Enabled := False;
               CxlBtn.Enabled := False;
               if (PreProcessed) and               // 선행 결재 수행
                  (gvOprUsrNo = sMainOprId) then   // 담당자인 경우
               begin
                  DecBtn.Enabled := True;
                  if Trim(sOprId) > '' then CxlBtn.Enabled := True;
                  if I > 0 then //현 결재단계가 Enable이므로 그전단계는 Disable임.
                  begin
                    TDRBitBtn(DecBtnList.Items[I-1]).Enabled := false;
                    TDRBitBtn(CxlBtnList.Items[I-1]).Enabled := false;
                  end;
               end
               else if Trim(sOprId) > '' then //현재 결재단계가 이미 처리되었으면 그 전 Enable된것은 모두 Disable
               begin
                  if I > 0 then
                  begin
                    TDRBitBtn(DecBtnList.Items[I-1]).Enabled := false;
                    TDRBitBtn(CxlBtnList.Items[I-1]).Enabled := false;
                  end;
               end;
               break;
            end;
         end; // end of for

         PreProcessed := False;
         if Trim(sOprId) <> '' then PreProcessed :=  True;
         Next;
      end;  // end of while
   end;   // end of with

   // 처리 가능 버튼 Set Focus
   if DRPanel_Decision.Visible then
   begin
      for I := 0 to DecBtnList.Count -1 do
      begin
         DecBtn   := DecBtnList.Items[I];
         if DecBtn.Enabled then
         begin
            DecBtn.SetFocus;
            ShowDecMessage(mtInformation, '<' + DecBtn.Caption + '> 처리 가능!');
         end;
      end;  // end of for
   end;  // end of if
end;

//------------------------------------------------------------------------------
//  결재정보 Control Free
//------------------------------------------------------------------------------
procedure TForm_SCF.DestroyDecControl;
var
   I : Integer;
   DecLabel : TDRLabel;
   DecBtn   : TDRBitBtn;
begin
   if Assigned(DecLabelList) then
   begin
      for I := 0 to DecLabelList.Count -1 do
      begin
          DecLabel := DecLabelList.Items[I];
          DecLabel.Free;
      end;  // end of for
      DeclabelList.Free;
   end;

   if Assigned(DecBtnList) then
   begin
      for I := 0 to DecBtnList.Count -1 do
      begin
         DecBtn := DecBtnList.Items[I];
         DecBtn.Free;
      end;  // end of for
      DecBtnList.Free;
   end;

   if Assigned(CxlBtnList) then
   begin
      for I := 0 to CxlBtnList.Count -1 do
      begin
         DecBtn := CxlBtnList.Items[I];
         DecBtn.Free;
      end;  // end of for
      CxlBtnList.Free;
   end;

end;

//------------------------------------------------------------------------------
// 결재 라인 처리
//------------------------------------------------------------------------------
procedure TForm_SCF.ProcessDecision(pStlDate: string);
var
   DecLabel : TDRLabel;
   DecBtn   : TDRBitBtn;
   iTop, I  : Integer;
begin
   ClearDecMessage;
   if not gvUseDecLine then // 결재라인을 사용하지 않는 경우
      Exit;

   gDecStlDate := pStlDate;

   if DRPanel_Decision.Visible then // 이미 결재 수행중
   begin
      DRBitBtn_DecRefreshClick(DRBitBtn_DecRefresh);  // 갱신버튼 Click
      Exit;
   end;

   DisableForm;
   // 해당 화면의 결재라인이 존재하는지 판단
   with ADOQuery_DECLN do
   begin
      Close;
      SQL.Clear;
      SQL.Add(' select d.DEC_LEVEL, d.DEC_NAME '
            + ' from SUDECLN_TBL d, SUTRDEC_TBL t '
            + ' where t.DEPT_CODE = ''' + gvDeptCode + ''' '
            + '     and t.TR_CODE = ''' + IntToStr(Self.Tag) + ''' '
            + '     and t.DEPT_CODE = d.DEPT_CODE '
            + '     and t.DEC_LEVEL = d.DEC_LEVEL '
            + '     and t.DEC_LEVEL < 8 '
            + ' order by d.DEC_LEVEL ');
      Try
         gf_ADOQueryOpen(ADOQuery_DECLN);
      Except
         on E : Exception do
         begin  // DataBase 오류
            ShowDecMessage(mtError, '결재 처리중 오류 발생!');
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SUDECLN_TBL]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SUDECLN_TBL]'); //Database 오류
            EnableForm;
            Exit;
         end;
      End;

      if RecordCount = 0 then   // 화면 결재 없음
      begin
         EnableForm;
         Exit;
      end;

      //--- 화면결재 있는 경우

      // 결재 관련 Control Enable
      Screen.Cursor := crDefault;
      DRPanel_Decision.Enabled := True;
      DRPanel_DecBack.Enabled := True;
      for I := 0 to DRPanel_DecBack.ControlCount -1 do
         DRPanel_DecBack.Controls[I].Enabled := True;

      //결재정보 Control 생성
      DecLabelList := TList.Create;
      DecBtnList   := TList.Create;
      CxlBtnList   := TList.Create;

      iTop := 35;  // Label 기준
      while not Eof do
      begin
         DecLabel := TDRLabel.Create(nil);
         DecLabelList.Add(DecLabel);
         DecLabel.Parent := DRPanel_DecTray;
         DecLabel.Top    := iTop;
         DecLabel.Left   := 20;

         DecBtn   := TDRBitBtn.Create(nil);
         DecBtnList.Add(DecBtn);
         DecBtn.Parent     := DRPanel_DecTray;
         DecBtn.Top        := iTop -5;
         DecBtn.Left       := 240;
         DecBtn.Width      := 70;
         DecBtn.Font.Color := clPurple;
         DecBtn.Font.Style := [fsBold];
         DecBtn.Tag        := FieldByName('DEC_LEVEL').asInteger;
         DecBtn.Caption    := FieldByName('DEC_NAME').asString;
         DecBtn.OnClick    := DecBtnClick;

         DecBtn   := TDRBitBtn.Create(nil);
         CxlBtnList.Add(DecBtn);
         DecBtn.Parent     := DRPanel_DecTray;
         DecBtn.Top        := iTop -5;
         DecBtn.Left       := 311;
         DecBtn.Width      := 70;
         DecBtn.Font.Color := clPurple;
         DecBtn.Font.Style := [fsBold];
         DecBtn.Tag        := FieldByName('DEC_LEVEL').asInteger;
         DecBtn.Caption    := 'CANCEL' ; //FieldByName('DEC_NAME').asString;
         DecBtn.OnClick    := CxlBtnClick;

         Inc(iTop, 33);
         Next;
      end;  // end of while
   end;  // end of with
   DRPanel_Decision.Top  := (Self.ClientHeight - DRPanel_Decision.Height) div 2;
   DRPanel_Decision.Left := (Self.ClientWidth - DRPanel_Decision.Width) div 2;
   DRPanel_Decision.BringToFront;
   DRBitBtn_DecRefreshClick(DRBitBtn_DecRefresh);  // 상태 Setting

   DRPanel_Decision.Visible := True;

   // 처리 가능 버튼 Set Focus
   for I := 0 to DecBtnList.Count -1 do
   begin
      DecBtn   := DecBtnList.Items[I];
      if DecBtn.Enabled then
      begin
         DecBtn.SetFocus;
         ShowDecMessage(mtInformation, '<' + DecBtn.Caption + '> 처리 가능!');
      end;
   end;  // end of for
end;

//------------------------------------------------------------------------------
//  결재 버튼 처리
//------------------------------------------------------------------------------
procedure TForm_SCF.DecBtnClick(Sender: TObject);
var
   iDecLevel : Integer;
   bConfirmed : boolean;
   sMsgStr, sQueryStr : string;
begin
   ClearDecMessage;
   iDecLevel := (Sender as TDRBitBtn).Tag;

   with ADOQuery_DECLN do
   begin
      // 선행 단계의 결재가 처리되었는지 확인
      Close;
      SQL.Clear;
      {$IFDEF SETTLENET_A}  // 회계
      sQueryStr := ' select r.REF_TR_CODE,  m.MENU_NAME_KOR, '
                 + '        t.DEC_LEVEL, l.DEC_NAME,  t.MAIN_OPR_ID, '
                 + '        OPR_ID = ISNull(a.OPR_ID, '''') '
                 + ' from SCREFTR_TBL r, SUTRDEC_TBL t,  SUDAILD_TBL a, '
                 + '      SUDECLN_TBL l, SAMENU_TBL m '
                 + ' where r.REF_TYPE = ''P'' '
                 + '    and r.TR_CODE = ''' + IntToStr(Self.Tag) + ''' '
                 + '    and t.DEPT_CODE = ''' + gvDeptCode + ''' '
                 + '    and t.TR_CODE = r.REF_TR_CODE '
                 + '    and t.DEPT_CODE *= a.DEPT_CODE '
                 + '    and t.TR_CODE *= a.TR_CODE '
                 + '    and t.DEC_LEVEL *= a.DEC_LEVEL '
                 + '    and a.STL_DATE = ''' + gDecStlDate + ''' '
                 + '    and l.DEPT_CODE = t.DEPT_CODE '
                 + '    and l.DEC_LEVEL = t.DEC_LEVEL '
                 + '    and m.ROLE_CODE = ''' + gvRoleCode + ''' '
                 + '    and m.SEC_CODE = ''' + gvCurSecType + ''' '
                 + '    and m.TR_CODE = r.REF_TR_CODE '
                 + '    and r.TR_CODE <> r.REF_TR_CODE '
                 + '    and l.DEC_LEVEL < 8 '
                 + ' order by r.REF_TR_CODE, t.DEC_LEVEL ';
      {$ELSE}  // SettleNet
      sQueryStr := ' select r.REF_TR_CODE,  m.MENU_NAME_KOR, '
                 + '        t.DEC_LEVEL, l.DEC_NAME,  t.MAIN_OPR_ID, '
                 + '        OPR_ID = ISNull(a.OPR_ID, '''') '
                 + ' from SCREFTR_TBL r, SUTRDEC_TBL t,  SUDAILD_TBL a, '
                 + '      SUDECLN_TBL l, SUMENU_TBL m '
                 + ' where r.REF_TYPE = ''P'' '
                 + '    and r.TR_CODE = ''' + IntToStr(Self.Tag) + ''' '
                 + '    and t.DEPT_CODE = ''' + gvDeptCode + ''' '
                 + '    and t.TR_CODE = r.REF_TR_CODE '
                 + '    and t.DEPT_CODE *= a.DEPT_CODE '
                 + '    and t.TR_CODE *= a.TR_CODE '
                 + '    and t.DEC_LEVEL *= a.DEC_LEVEL '
                 + '    and a.STL_DATE = ''' + gDecStlDate + ''' '
                 + '    and l.DEPT_CODE = t.DEPT_CODE '
                 + '    and l.DEC_LEVEL = t.DEC_LEVEL '
                 + '    and m.ROLE_CODE = ''' + gvRoleCode + ''' '
                 + '    and m.SEC_CODE = ''' + gvCurSecType + ''' '
                 + '    and m.TR_CODE = r.REF_TR_CODE '
                 + '    and r.TR_CODE <> r.REF_TR_CODE '
                 + '    and l.DEC_LEVEL < 8 '
                 + ' order by r.REF_TR_CODE, t.DEC_LEVEL ';
      {$ENDIF}
      SQL.Add(sQueryStr);
      Try
         gf_ADOQueryOpen(ADOQuery_DECLN);
      Except
         on E : Exception do
         begin  // DataBase 오류
            ShowDecMessage(mtError, '결재 처리중 오류 발생!');
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[PRE_DEC_CHECK]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[PRE_DEC_CHECK]'); //Database 오류
            Exit;
         end;
      End;

      if RecordCount > 0 then  // 선행 결재 여부 판단
      begin
         bConfirmed := True;
         sMsgStr := '';
         while not Eof do
         begin
            if Trim(FieldByName('OPR_ID').asString) = '' then // 미결재 내역 존재
            begin
               bConfirmed := False;
               sMsgStr := sMsgStr +
                       '[' + Trim(FieldByName('REF_TR_CODE').asString) + '] ' +
                       Trim(FieldByName('MENU_NAME_KOR').asString) + ': ' +
                       Trim(FieldByName('DEC_NAME').asString)  + Chr(13);
            end;
            Next;
         end;
         if not bConfirmed then  // 미결재 내역 존재시
         begin
            sMsgStr := sMsgStr + Chr(13) +
                 '선행 결재가 처리되지 않았으므로 해당 작업을 진행할 수 없습니다.';
            gf_ShowDlgMessage(Self.Tag, mtError, 0, sMsgStr, [mbOk] , 0);
            DRBitBtn_DecRefreshClick(DRBitBtn_DecRefresh);
//            ShowDecMessage(mtInformation, '취소되었습니다.');
//            gf_ShowMessage(MessageBar, mtInformation, 1082, ''); //작업이 취소되었습니다.
            Exit;
         end;
      end;  // end of if

      // 다음 단계의 결재가 처리되었는지 확인
      Close;
      SQL.Clear;
      {$IFDEF SETTLENET_A}  // 회계
      sQueryStr := ' Select t.TR_CODE, m.MENU_NAME_KOR, '
                 + '        d.DEC_LEVEL, l.DEC_NAME '
                 + ' From SUDAILD_TBL d, SUTRDEC_TBL t, SUDECLN_TBL l, SAMENU_TBL m '
                 + ' Where t.DEPT_CODE = ''' + gvDeptCode + ''' '
                 + '   and t.TR_CODE = ''' + IntToStr(Self.Tag) + ''' '
                 + '   and d.STL_DATE = ''' + gDecStlDate + ''' '
                 + '   and d.DEC_LEVEL > ' + IntToStr(iDecLevel)
                 + '   and t.DEPT_CODE = d.DEPT_CODE '
                 + '   and t.TR_CODE = d.TR_CODE '
                 + '   and t.DEC_LEVEL  = d.DEC_LEVEL '
                 + '   and l.DEPT_CODE = t.DEPT_CODE '
                 + '   and l.DEC_LEVEL = t.DEC_LEVEL '
                 + '   and m.ROLE_CODE = ''' + gvRoleCode + ''' '
                 + '   and m.SEC_CODE = ''' + gvCurSecType + ''' '
                 + '   and m.TR_CODE  = t.TR_CODE '
                 + '   and l.DEC_LEVEL < 8 '
                 + ' Union '
                 + ' Select TR_CODE = r.REF_TR_CODE,  m.MENU_NAME_KOR, '
                 + '        t.DEC_LEVEL, l.DEC_NAME '
                 + ' From SCREFTR_TBL r, SUTRDEC_TBL t,  SUDAILD_TBL d, '
                 + '      SUDECLN_TBL l, SAMENU_TBL m '
                 + ' Where r.REF_TYPE = ''C'' '
                 + '    and r.TR_CODE = ''' + IntToStr(Self.Tag) + ''' '
                 + '    and t.DEPT_CODE = ''' + gvDeptCode + ''' '
                 + '    and t.TR_CODE = r.REF_TR_CODE '
                 + '    and t.DEPT_CODE = d.DEPT_CODE '
                 + '    and t.TR_CODE = d.TR_CODE '
                 + '    and t.DEC_LEVEL = d.DEC_LEVEL '
                 + '    and d.STL_DATE = ''' + gDecStlDate + ''' '
                 + '    and l.DEPT_CODE = t.DEPT_CODE '
                 + '    and l.DEC_LEVEL = t.DEC_LEVEL '
                 + '    and m.ROLE_CODE = ''' + gvRoleCode + ''' '
                 + '    and m.SEC_CODE = ''' + gvCurSecType + ''' '
                 + '    and m.TR_CODE = r.REF_TR_CODE '
                 + '   and l.DEC_LEVEL < 8 '
                 + '    and r.TR_CODE <> r.REF_TR_CODE';
      {$ELSE}  // SettleNet
      sQueryStr := ' Select t.TR_CODE, m.MENU_NAME_KOR, '
                 + '        d.DEC_LEVEL, l.DEC_NAME '
                 + ' From SUDAILD_TBL d, SUTRDEC_TBL t, SUDECLN_TBL l, SUMENU_TBL m '
                 + ' Where t.DEPT_CODE = ''' + gvDeptCode + ''' '
                 + '   and t.TR_CODE = ''' + IntToStr(Self.Tag) + ''' '
                 + '   and d.STL_DATE = ''' + gDecStlDate + ''' '
                 + '   and d.DEC_LEVEL > ' + IntToStr(iDecLevel)
                 + '   and t.DEPT_CODE = d.DEPT_CODE '
                 + '   and t.TR_CODE = d.TR_CODE '
                 + '   and t.DEC_LEVEL  = d.DEC_LEVEL '
                 + '   and l.DEPT_CODE = t.DEPT_CODE '
                 + '   and l.DEC_LEVEL = t.DEC_LEVEL '
                 + '   and m.ROLE_CODE = ''' + gvRoleCode + ''' '
                 + '   and m.SEC_CODE = ''' + gvCurSecType + ''' '
                 + '   and m.TR_CODE  = t.TR_CODE '
                 + '   and l.DEC_LEVEL < 8 '
                 + ' Union '
                 + ' Select TR_CODE = r.REF_TR_CODE,  m.MENU_NAME_KOR, '
                 + '        t.DEC_LEVEL, l.DEC_NAME '
                 + ' From SCREFTR_TBL r, SUTRDEC_TBL t,  SUDAILD_TBL d, '
                 + '      SUDECLN_TBL l, SUMENU_TBL m '
                 + ' Where r.REF_TYPE = ''C'' '
                 + '    and r.TR_CODE = ''' + IntToStr(Self.Tag) + ''' '
                 + '    and t.DEPT_CODE = ''' + gvDeptCode + ''' '
                 + '    and t.TR_CODE = r.REF_TR_CODE '
                 + '    and t.DEPT_CODE = d.DEPT_CODE '
                 + '    and t.TR_CODE = d.TR_CODE '
                 + '    and t.DEC_LEVEL = d.DEC_LEVEL '
                 + '    and d.STL_DATE = ''' + gDecStlDate + ''' '
                 + '    and l.DEPT_CODE = t.DEPT_CODE '
                 + '    and l.DEC_LEVEL = t.DEC_LEVEL '
                 + '    and m.ROLE_CODE = ''' + gvRoleCode + ''' '
                 + '    and m.SEC_CODE = ''' + gvCurSecType + ''' '
                 + '    and m.TR_CODE = r.REF_TR_CODE '
                 + '   and l.DEC_LEVEL < 8 '
                 + '    and r.TR_CODE <> r.REF_TR_CODE ';
      {$ENDIF}
      SQL.Add(sQueryStr);
      Try
         gf_ADOQueryOpen(ADOQuery_DECLN);
      Except
         on E : Exception do
         begin  // DataBase 오류
            ShowDecMessage(mtError, '결재 처리중 오류 발생!');
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[AFT_DEC_CHECK]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[AFT_DEC_CHECK]'); //Database 오류
            Exit;
         end;
      End;

      if RecordCount > 0 then  // 다음 단계의 결재가 진행된 상태
      begin
         sMsgStr := '실행할 수 없습니다.' + Char(13)+ Char(13);
         while not Eof do
         begin
            sMsgStr := sMsgStr +
                       '[' + Trim(FieldByName('TR_CODE').asString) + '] ' +
                       Trim(FieldByName('MENU_NAME_KOR').asString) + ': ' +
                       FieldByName('DEC_NAME').asString  + Chr(13);
            Next;
         end;
         sMsgStr := sMsgStr + Chr(13) +
                    '위의 결재 사항을 취소하셔야 합니다.';

         gf_ShowDlgMessage(Self.Tag, mtConfirmation, 0, sMsgStr, [mbYes], 0);
         DRBitBtn_DecRefreshClick(DRBitBtn_DecRefresh);
//         ShowDecMessage(mtInformation, '취소되었습니다.');
//         gf_ShowMessage(MessageBar, mtInformation, 1082, ''); //작업이 취소되었습니다.
         Exit;
      end;  // end of if

      // 현재 및 다음 단계의 결재 처리 삭제
      Close;
      SQL.Clear;
      SQL.Add( ' Delete SUDAILD_TBL '
             + ' From SCREFTR_TBL r '
             + ' Where SUDAILD_TBL.DEPT_CODE = ''' + gvDeptCode + ''' '
             + '   and SUDAILD_TBL.STL_DATE = ''' + gDecStlDate + ''' '
             + '   and ((SUDAILD_TBL.TR_CODE = ''' + IntToStr(Self.Tag) + ''' '
             + '         and SUDAILD_TBL.DEC_LEVEL >=' + IntToStr(iDecLevel) + ') or '
             + '        (r.REF_TYPE = ''C'' '
             + '         and r.TR_CODE = ''' + IntToStr(Self.Tag) + ''' '
             + '         and SUDAILD_TBL.TR_CODE = r.REF_TR_CODE '
             + '         and r.TR_CODE <> r.REF_TR_CODE )) ');
      Try
         gf_ADOExecSQL(ADOQuery_DECLN);
      Except
         on E : Exception do
         begin  // DataBase 오류
            ShowDecMessage(mtError, '결재 처리중 오류 발생!');
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[Delete]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[Delete]'); //Database 오류
            Exit;
         end;
      End;

      // Insert
      Close;
      SQL.Clear;
      SQL.Add(' Insert SUDAILD_TBL '
            + ' (DEPT_CODE, STL_DATE, TR_CODE, DEC_LEVEL, '
            + '  OPR_ID, OPR_DATE, OPR_TIME) '
            + '  Values '
            + ' (:pDeptCode, :pStlDate, :pTrCode, :pDecLevel, '
            + '  :pOprId, :pOprDate, :pOprTime) ');
      Parameters.ParamByName('pDeptCode').Value     := gvDeptCode;
      Parameters.ParamByName('pStlDate').Value      := gDecStlDate;
      Parameters.ParamByName('pTrCode').Value       := Self.Tag;
      Parameters.ParamByName('pDecLevel').Value     := iDecLevel;
      Parameters.ParamByName('pOprID').Value        := gvOprUsrNo;
      Parameters.ParamByName('pOprDate').Value      := gvCurDate;
      Parameters.ParamByName('pOprTime').Value      := gf_GetCurTime;
      Try
         gf_ADOExecSQL(ADOQuery_DECLN);
      Except
         on E : Exception do
         begin  // DataBase 오류
            ShowDecMessage(mtError, '결재 처리중 오류 발생!');
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[Insert]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[Insert]'); //Database 오류
            Exit;
         end;
      End;
   end;  // end of with

   // 결재 내역 갱신
   DRBitBtn_DecRefreshClick(DRBitBtn_DecRefresh);
   ShowDecMessage(mtInformation, '<' +  (Sender as TDRBitBtn).Caption + '> 처리 완료!');
end;

//------------------------------------------------------------------------------
// 결재 메세지 처리
//------------------------------------------------------------------------------
procedure TForm_SCF.ShowDecMessage(pMsgType: TMsgDlgType; pMsg: string);
begin
   if pMsgType <> mtError then
   begin
      DRPanel_DecMsg.Color      := clWhite;
      DRPanel_DecMsg.Font.Color := clPurple;
   end
   else
   begin
      DRPanel_DecMsg.Color      := clRed;
      DRPanel_DecMsg.Font.Color := clWhite;
   end;

   DRPanel_DecMsg.Caption := '  ' + pMsg;
end;

//------------------------------------------------------------------------------
// 결재 메세지 Clear
//------------------------------------------------------------------------------
procedure TForm_SCF.ClearDecMessage;
begin
   DRPanel_DecMsg.Caption := '';
end;

procedure TForm_SCF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = VK_F8) then
  begin
    if (ActiveControl is TDRStringGrid) then
    begin
       ChildFormGridExport(TDRStringGrid(ActiveControl));
    end;
  end
  else if (ssCtrl in Shift) and (Key = VK_F5) then
  begin
    RefreshForm;
  end
  else if (Key = VK_F2) then
  begin
    TopBtnClick('F2');
    Key := word(#27);
  end
  else if (Key = VK_F3) then
  begin
    TopBtnClick('F3');
    Key := word(#27);
  end
  else if (Key = VK_F4) then
  begin
    TopBtnClick('F4');
    Key := word(#27);
  end
  else if (Key = VK_F5) then
  begin
    TopBtnClick('F5');
    Key := word(#27);
  end
  else if (Key = VK_F6) then
  begin
    TopBtnClick('F6');
    Key := word(#27);
  end
  else if (Key = VK_F7) then
  begin
    TopBtnClick('F7');
    Key := word(#27);
  end
  else if (Key = VK_F8) then
  begin
    TopBtnClick('F8');
    Key := word(#27);
  end
  else if (Key = VK_F9) then
  begin
    TopBtnClick('F9');;
    Key := word(#27);
  end;

{
  else if (Key = VK_F3) then
    TopBtnClick('조회')
  else if (Key = VK_F4) then
    TopBtnClick('입력')
  else if (Key = VK_F5) then
    TopBtnClick('수정')
  else if (Key = VK_F6) then
    TopBtnClick('삭제')
  else if (Key = VK_F7) then
    TopBtnClick('인쇄')
  else if (Key = VK_F9) then
    TopBtnClick('종료');

}
end;

procedure TForm_SCF.TopBtnClick(sCaption:string);
var  i : integer;
begin
  // Funtion Key 눌렀을때 조회버튼 클릭하게
  for i := 0 to DRPanel_Top.ControlCount -1 do
  begin
    if DRPanel_Top.Controls[i].ClassName = 'TDRBitBtn' then
    begin
      if pos(sCaption, (DRPanel_Top.Controls[i] as TDRBitBtn).Caption) > 0 then
      begin
        if (DRPanel_Top.Controls[i] as TDRBitBtn).Enabled then
          (DRPanel_Top.Controls[i] as TDRBitBtn).Click;
        Exit;
      end;
    end;  // end of if
  end; //For
end;

procedure TForm_SCF.ChildFormGridExport(DRGrid1:TDRStringGrid);
var
  XL, XLBook, XLSheet: Variant;  // Excel관련 변수
  iRow, iCol             : integer;
  sFileName, sDirFilePath   : String;
  EnvSetupInfo : TIniFile;   // Ini File
  lcid: integer;
begin

  EnvSetupInfo := TIniFile.Create(gvDirCfg + gcMainIniFileName);
  sDirFilePath  := EnvSetupInfo.ReadString('GridExport', 'Dir', '');
  DRSaveDialog_GridExport.InitialDir := sDirFilePath;
  if Not DRSaveDialog_GridExport.Execute then Exit;

  sFileName := DRSaveDialog_GridExport.FileName;
  sDirFilePath := ExtractFileDir(DRSaveDialog_GridExport.FileName);
  //
  gf_ShowMessage(MessageBar, mtInformation, 0, '파일저장중....'); //저장 중입니다.
  DisableForm;

  XL := gf_GetExcelOleObject;//CreateOLEObject('Excel.Application');          //엑셀을 실행

  XL.DefaultFilePath  := sDirFilePath;
  XL.DisplayAlerts := false;

  XLBook := XL.WorkBooks.Add;

  //  XLBook.WorkSheets[1].Name := DRPanel_Title.Caption; 특수문자들어간경우에러나서
  XLSheet := XLBook.WorkSheets[1];

 with DRGrid1 do
  begin
    for iCol := 0 to ColCount -1 do
    begin
        if AlignCol[iCol] = AlLeft then
        begin
          XL.Range[GridColToXLCol(iCol) + IntToStr(FixedRows), GridColToXLCol(iCol) + IntToStr(RowCount -1 + FixedRows) ].Select;
          XL.Selection.HorizontalAlignment := xlLeft;
          XL.Selection.NumberFormatLocal := '@';
        end
        else
        if AlignCol[iCol] = AlCenter then
        begin
          XL.Range[GridColToXLCol(iCol) + IntToStr(FixedRows), GridColToXLCol(iCol) + IntToStr(RowCount -1 + FixedRows) ].Select;
          XL.Selection.HorizontalAlignment := xlCenter;
          XL.Selection.NumberFormatLocal := '@';
        end;
    end;

    for iRow := 0 to RowCount -1 do
    begin
      for iCol := 0 to ColCount -1 do
      begin
        XLSheet.Cells[iRow +1,iCol+1] := Cells[iCol,iRow];
      end; //iCol
    end; //iRow

    XLSheet.Range['A1', GridColToXLCol(ColCount-1)+IntToStr(RowCount)].Columns.AutoFit;
    XL.Range['A1','A1'].Select;

//    XL.ActiveWorkBook.SaveAs(sFileName , xlExcel9795);
    gf_ExcelSaveAs(XL,sFileName,xlExcel9795);

  end; //with

  if not VarIsEmpty(XL) then
  begin
    if not VarIsEmpty(XL.ActiveWorkBook) then
      XL.ActiveWorkBook.Close;
//    XL.Quit;// @@@@@@@@@@@@@@@@2임시
  end;

  XLSheet  := UnAssigned;
  XLBook   := UnAssigned;
  XL       := UnAssigned;

  EnvSetupInfo.WriteString('GridExport', 'Dir', sDirFilePath);

  EnvSetupInfo.Free;

  EnableForm;
  gf_ShowMessage(MessageBar, mtInformation, 0, '저장완료-' + sFileName);

end;

//------------------------------------------------------------------------------
//  CANCEL 버튼 처리
//------------------------------------------------------------------------------
procedure TForm_SCF.CxlBtnClick(Sender: TObject);
var
   iDecLevel : Integer;
   bConfirmed : boolean;
   sMsgStr, sQueryStr, sMsg : string;
begin
   ClearDecMessage;
   iDecLevel := (Sender as TDRBitBtn).Tag;

   // 취소가능하냐? 후행 결재 상태 확인
   if gf_CanCancelDecLine(Self.Tag, gDecStlDate, iDecLevel,sMsg) then
   begin
     gf_ShowDlgMessage(Self.Tag, mtError, 0, sMsg, [mbYes] , 0);
     DRBitBtn_DecRefreshClick(DRBitBtn_DecRefresh);
     Exit;
   end;

   with ADOQuery_DECLN do
   begin

      // 현재 결재 처리 삭제
      Close;
      SQL.Clear;
      SQL.Add( ' Delete SUDAILD_TBL '
             + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
             + '   and STL_DATE = ''' + gDecStlDate + ''' '
             + '   and TR_CODE = ''' + IntToStr(Self.Tag) + ''' '
             + '   and DEC_LEVEL =' + IntToStr(iDecLevel) + ' '
             );
      Try
         gf_ADOExecSQL(ADOQuery_DECLN);
      Except
         on E : Exception do
         begin  // DataBase 오류
            ShowDecMessage(mtError, '결재 처리중 오류 발생!');
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[Delete]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[Delete]'); //Database 오류
            Exit;
         end;
      End;

   end;  // end of with

   // 결재 내역 갱신
   DRBitBtn_DecRefreshClick(DRBitBtn_DecRefresh);
   ShowDecMessage(mtInformation, '<' +  (Sender as TDRBitBtn).Caption + '> 처리 완료!');
end;

//조회 Script에서 조회 완료(성공)(DisplayGrid)후 넣을 것, 조회결과 없어도 넣을 것.
procedure TForm_SCF.setJobDate(ctr : TDRMaskEdit);
begin
  FJobDate := ctr.Text;
end;

//입,수,삭등 조회결과를 토대로 작업시
//처리 전에 넣을 것 (날짜체크등 기본 체크후)
function TForm_SCF.checkJobDate(ctr : TDRMaskEdit) : boolean;
begin
  Result := false;
  if FJobDate = '' then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 0,
    '처리할 수 없습니다. ' + #13#10 + #13#10 +
    '조회한 날짜가 없습니다.', 0);
    gf_ShowMessage(MessageBar, mtError, 0, '조회한 날짜가 없습니다.');
    Exit;
  end;

  if FJobDate <> ctr.Text then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 0,
    '처리할 수 없습니다. ' + #13#10 + #13#10 +
    '조회한 날짜[' + FJobDate +']와 작업날짜[' + ctr.Text +']가 다릅니다.', 0);
    gf_ShowMessage(MessageBar, mtError, 0, '조회한 날짜와 작업날짜가 다릅니다.');
    Exit;
  end;
  Result := true;
end;

procedure TForm_SCF.RefreshForm;
begin
  // [L.J.S] 2018.01.31 자식폼에서 코드 작성해서 사용 KEY DOWN -> CTRL + F5
end;

end.
