//==============================================================================
//   SettleNet �ֻ�����
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
    procedure DecBtnClick(Sender: TObject);  // ���� ��ư ó��
    procedure ShowDecMessage(pMsgType: TMsgDlgType; pMsg: string);  // ���� �޼��� ó��
    procedure ClearDecMessage;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FormDisabled : boolean;      // Form�� Disable �Ǿ� �ִ��� ����
    CompStatList : TStringList;  // Component�� Enable/Disable ���¸� ����
    gDecStlDate  : string;       // ������ο����� ��������
    DecLabelList : TList;   // ����ó������ Label List
    DecBtnList   : TList;   // ����ó������ Button List
    CxlBtnList   : TList;   // ����ó������ Button List
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
//  ����
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
// TRȭ�� ����� gc
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
   //Grid�� ���� Column�� FixedRowClick Button�� ���̰� Ȱ��ȭ ��Ű����
   //Grid�� ��ũ���� �������� �Ѵ�.
   //������Ʈ�� ���׸� ���ϰ��� �ļ��� ��.
   //����Size�� �÷ȴٰ� ���̸鼭 Grid�� ��ũ���� �����̰� ��.
   //��,Grid�� Align�� alNone�� �ƴϸ� �ƴ� �ļ��� ���� ���ɼ��� ŭ.
   //FormCreate ���� �÷ȴٰ�
   //FormShow���� ���󺹱�
   ug_OriFormWidth  := Width ;
   ug_OriFormHeight := Height ;
   Width  := Width + 1024;
   Height := Height + 1024;
}
  // Function Key ����� : Caption�� �̸���.
  for i := 0 to DRPanel_Top.ControlCount -1 do
  begin
    if DRPanel_Top.Controls[i].ClassName = 'TDRBitBtn' then
    begin
      s := (DRPanel_Top.Controls[i] as TDRBitBtn).Caption;
      if s = '��ȸ' then
        (DRPanel_Top.Controls[i] as TDRBitBtn).Caption := s + '(F3)'
      else if s = '�Է�' then
        (DRPanel_Top.Controls[i] as TDRBitBtn).Caption := s + '(F4)'
      else if s = '����' then
        (DRPanel_Top.Controls[i] as TDRBitBtn).Caption := s + '(F5)'
      else if s = '����' then
        (DRPanel_Top.Controls[i] as TDRBitBtn).Caption := s + '(F6)'
      else if s = '�μ�' then
        (DRPanel_Top.Controls[i] as TDRBitBtn).Caption := s + '(F7)'
      else if s = '����' then
        (DRPanel_Top.Controls[i] as TDRBitBtn).Caption := s + '(F9)';
    end;  // end of if
  end; //For

//==============================================================================
// TRȭ�� ����� gc
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
   if not FormDisabled then Exit; // �̹� Form Enable ����

   Screen.Cursor := crDefault;
   iStatIdx := -1;
   for I := 0 to ComponentCount -1 do
   begin
      if (Components[I] is TButton) or
         (Components[I] is TSpeedButton) then // Button ó��
//         (Components[I] is TPanel) then     // Panel ���� ����: Active Form�ڿ����� Popup Jumping�� ���� �߻� ����
      begin
         Inc(iStatIdx);
         (Components[I] as TControl).Enabled := False;
         if CompStatList.Strings[iStatIdx] = 'E' then  // Enable ����
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
   if FormDisabled then Exit;  // �̹� Form Disable ����

   Screen.Cursor := crHourGlass;
   CompStatList.Clear;
   for I := 0 to ComponentCount -1 do
   begin
      if (Components[I] is TButton) or
         (Components[I] is TSpeedButton) then // Button�� ó��
//         (Components[I] is TPanel) then  // Panel ���� ����: Active Form�ڿ����� Popup Jumping�� ���� �߻� ����
      begin
         // ���� ���� ����
         if (Components[I] as TControl).Enabled then // Enable ����
             CompStatList.Add('E')
         else  // Disable ����
             CompStatList.Add('D');
         (Components[I] as TControl).Enabled := False;
      end;
   end;
   gf_DisableMainMenu;
   
   FormDisabled := True;
end;

//------------------------------------------------------------------------------
//  ��ư ���� �ο�
//------------------------------------------------------------------------------
procedure TForm_SCF.FormShow(Sender: TObject);
var
   I : Integer;
begin
//   Width := ug_OriFormWidth;
//   Height := ug_OriFormHeight;
   
   Authority := gcAUTH_QUERY_ONLY;   // ��ȸ�� ����
   if gf_CanUseTrCode(Self.Tag) then
      Authority := gcAUTH_ALL;       // ������

   for I := 0 to ComponentCount -1 do
   begin
      if ((Components[I] is TButton) or (Components[I] is TSpeedButton)) and
         ((Components[I] as TControl).Enabled) then  // Enable�� Component��
      begin
         gf_EnableBtn(Self.Tag, (Components[I] as TControl));
      end;
   end;  // end of for

   gf_ControlCenterAllign(Self,DRPanel_Decision);
   gf_ControlCenterAllign(Self,ProcessMsgBar);
end;

//==============================================================================
//  ������� ó��
//==============================================================================
//------------------------------------------------------------------------------
//  ������ ����
//------------------------------------------------------------------------------
procedure TForm_SCF.DRBitBtn_DecCloseClick(Sender: TObject);
begin
   gDecStlDate := '';  // Clear;
   DestroyDecControl;  // Free Control
   DRPanel_Decision.Visible := False;
   EnableForm;
end;

//------------------------------------------------------------------------------
//  ������ ����
//------------------------------------------------------------------------------
procedure TForm_SCF.DRBitBtn_DecRefreshClick(Sender: TObject);
var
   PreProcessed : boolean;
   iDecLevel, I : Integer;
   DecLabel : TDRLabel;
   DecBtn,CxlBtn   : TDRBitBtn;
   sMainOprId, sOprId, sOprName : string;
begin
   // �ش� ȭ���� ���� ���� Setting
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
         begin  // DataBase ����
            ShowDecMessage(mtError, '���� ó���� ���� �߻�!');
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SUTRDEC_TBL]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SUTRDEC_TBL]'); //Database ����
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

         // �ش� Label, ��ư ó��
         for I := 0 to DecBtnList.Count -1 do
         begin
            DecBtn   := DecBtnList.Items[I];
            DecLabel := DecLabelList.Items[I];
            CxlBtn   := CxlBtnList.Items[I];
            if DecBtn.Tag = iDecLevel then  // �ش� ���� �ܰ�
            begin
               DecLabel.Caption := MoveDataStr(DecBtn.Caption, 9) + ' : ' +  sOprName;
               if Trim(sOprId) <> '' then  // ���� ó�� - ����ð����
                  DecLabel.Caption := DecLabel.Caption + ' (' +
                           copy(gf_FormatDate(Trim(FieldByName('OPR_DATE').asString)), 6, 5) + ',' +
                           copy(gf_FormatTime(Trim(FieldByName('OPR_TIME').asString)), 1, 8) + ')';

               // ���� Button
               DecBtn.Enabled := False;
               CxlBtn.Enabled := False;
               if (PreProcessed) and               // ���� ���� ����
                  (gvOprUsrNo = sMainOprId) then   // ������� ���
               begin
                  DecBtn.Enabled := True;
                  if Trim(sOprId) > '' then CxlBtn.Enabled := True;
                  if I > 0 then //�� ����ܰ谡 Enable�̹Ƿ� �����ܰ�� Disable��.
                  begin
                    TDRBitBtn(DecBtnList.Items[I-1]).Enabled := false;
                    TDRBitBtn(CxlBtnList.Items[I-1]).Enabled := false;
                  end;
               end
               else if Trim(sOprId) > '' then //���� ����ܰ谡 �̹� ó���Ǿ����� �� �� Enable�Ȱ��� ��� Disable
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

   // ó�� ���� ��ư Set Focus
   if DRPanel_Decision.Visible then
   begin
      for I := 0 to DecBtnList.Count -1 do
      begin
         DecBtn   := DecBtnList.Items[I];
         if DecBtn.Enabled then
         begin
            DecBtn.SetFocus;
            ShowDecMessage(mtInformation, '<' + DecBtn.Caption + '> ó�� ����!');
         end;
      end;  // end of for
   end;  // end of if
end;

//------------------------------------------------------------------------------
//  �������� Control Free
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
// ���� ���� ó��
//------------------------------------------------------------------------------
procedure TForm_SCF.ProcessDecision(pStlDate: string);
var
   DecLabel : TDRLabel;
   DecBtn   : TDRBitBtn;
   iTop, I  : Integer;
begin
   ClearDecMessage;
   if not gvUseDecLine then // ��������� ������� �ʴ� ���
      Exit;

   gDecStlDate := pStlDate;

   if DRPanel_Decision.Visible then // �̹� ���� ������
   begin
      DRBitBtn_DecRefreshClick(DRBitBtn_DecRefresh);  // ���Ź�ư Click
      Exit;
   end;

   DisableForm;
   // �ش� ȭ���� ��������� �����ϴ��� �Ǵ�
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
         begin  // DataBase ����
            ShowDecMessage(mtError, '���� ó���� ���� �߻�!');
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SUDECLN_TBL]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SUDECLN_TBL]'); //Database ����
            EnableForm;
            Exit;
         end;
      End;

      if RecordCount = 0 then   // ȭ�� ���� ����
      begin
         EnableForm;
         Exit;
      end;

      //--- ȭ����� �ִ� ���

      // ���� ���� Control Enable
      Screen.Cursor := crDefault;
      DRPanel_Decision.Enabled := True;
      DRPanel_DecBack.Enabled := True;
      for I := 0 to DRPanel_DecBack.ControlCount -1 do
         DRPanel_DecBack.Controls[I].Enabled := True;

      //�������� Control ����
      DecLabelList := TList.Create;
      DecBtnList   := TList.Create;
      CxlBtnList   := TList.Create;

      iTop := 35;  // Label ����
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
   DRBitBtn_DecRefreshClick(DRBitBtn_DecRefresh);  // ���� Setting

   DRPanel_Decision.Visible := True;

   // ó�� ���� ��ư Set Focus
   for I := 0 to DecBtnList.Count -1 do
   begin
      DecBtn   := DecBtnList.Items[I];
      if DecBtn.Enabled then
      begin
         DecBtn.SetFocus;
         ShowDecMessage(mtInformation, '<' + DecBtn.Caption + '> ó�� ����!');
      end;
   end;  // end of for
end;

//------------------------------------------------------------------------------
//  ���� ��ư ó��
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
      // ���� �ܰ��� ���簡 ó���Ǿ����� Ȯ��
      Close;
      SQL.Clear;
      {$IFDEF SETTLENET_A}  // ȸ��
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
         begin  // DataBase ����
            ShowDecMessage(mtError, '���� ó���� ���� �߻�!');
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[PRE_DEC_CHECK]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[PRE_DEC_CHECK]'); //Database ����
            Exit;
         end;
      End;

      if RecordCount > 0 then  // ���� ���� ���� �Ǵ�
      begin
         bConfirmed := True;
         sMsgStr := '';
         while not Eof do
         begin
            if Trim(FieldByName('OPR_ID').asString) = '' then // �̰��� ���� ����
            begin
               bConfirmed := False;
               sMsgStr := sMsgStr +
                       '[' + Trim(FieldByName('REF_TR_CODE').asString) + '] ' +
                       Trim(FieldByName('MENU_NAME_KOR').asString) + ': ' +
                       Trim(FieldByName('DEC_NAME').asString)  + Chr(13);
            end;
            Next;
         end;
         if not bConfirmed then  // �̰��� ���� �����
         begin
            sMsgStr := sMsgStr + Chr(13) +
                 '���� ���簡 ó������ �ʾ����Ƿ� �ش� �۾��� ������ �� �����ϴ�.';
            gf_ShowDlgMessage(Self.Tag, mtError, 0, sMsgStr, [mbOk] , 0);
            DRBitBtn_DecRefreshClick(DRBitBtn_DecRefresh);
//            ShowDecMessage(mtInformation, '��ҵǾ����ϴ�.');
//            gf_ShowMessage(MessageBar, mtInformation, 1082, ''); //�۾��� ��ҵǾ����ϴ�.
            Exit;
         end;
      end;  // end of if

      // ���� �ܰ��� ���簡 ó���Ǿ����� Ȯ��
      Close;
      SQL.Clear;
      {$IFDEF SETTLENET_A}  // ȸ��
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
         begin  // DataBase ����
            ShowDecMessage(mtError, '���� ó���� ���� �߻�!');
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[AFT_DEC_CHECK]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[AFT_DEC_CHECK]'); //Database ����
            Exit;
         end;
      End;

      if RecordCount > 0 then  // ���� �ܰ��� ���簡 ����� ����
      begin
         sMsgStr := '������ �� �����ϴ�.' + Char(13)+ Char(13);
         while not Eof do
         begin
            sMsgStr := sMsgStr +
                       '[' + Trim(FieldByName('TR_CODE').asString) + '] ' +
                       Trim(FieldByName('MENU_NAME_KOR').asString) + ': ' +
                       FieldByName('DEC_NAME').asString  + Chr(13);
            Next;
         end;
         sMsgStr := sMsgStr + Chr(13) +
                    '���� ���� ������ ����ϼž� �մϴ�.';

         gf_ShowDlgMessage(Self.Tag, mtConfirmation, 0, sMsgStr, [mbYes], 0);
         DRBitBtn_DecRefreshClick(DRBitBtn_DecRefresh);
//         ShowDecMessage(mtInformation, '��ҵǾ����ϴ�.');
//         gf_ShowMessage(MessageBar, mtInformation, 1082, ''); //�۾��� ��ҵǾ����ϴ�.
         Exit;
      end;  // end of if

      // ���� �� ���� �ܰ��� ���� ó�� ����
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
         begin  // DataBase ����
            ShowDecMessage(mtError, '���� ó���� ���� �߻�!');
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[Delete]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[Delete]'); //Database ����
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
         begin  // DataBase ����
            ShowDecMessage(mtError, '���� ó���� ���� �߻�!');
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[Insert]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[Insert]'); //Database ����
            Exit;
         end;
      End;
   end;  // end of with

   // ���� ���� ����
   DRBitBtn_DecRefreshClick(DRBitBtn_DecRefresh);
   ShowDecMessage(mtInformation, '<' +  (Sender as TDRBitBtn).Caption + '> ó�� �Ϸ�!');
end;

//------------------------------------------------------------------------------
// ���� �޼��� ó��
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
// ���� �޼��� Clear
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
    TopBtnClick('��ȸ')
  else if (Key = VK_F4) then
    TopBtnClick('�Է�')
  else if (Key = VK_F5) then
    TopBtnClick('����')
  else if (Key = VK_F6) then
    TopBtnClick('����')
  else if (Key = VK_F7) then
    TopBtnClick('�μ�')
  else if (Key = VK_F9) then
    TopBtnClick('����');

}
end;

procedure TForm_SCF.TopBtnClick(sCaption:string);
var  i : integer;
begin
  // Funtion Key �������� ��ȸ��ư Ŭ���ϰ�
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
  XL, XLBook, XLSheet: Variant;  // Excel���� ����
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
  gf_ShowMessage(MessageBar, mtInformation, 0, '����������....'); //���� ���Դϴ�.
  DisableForm;

  XL := gf_GetExcelOleObject;//CreateOLEObject('Excel.Application');          //������ ����

  XL.DefaultFilePath  := sDirFilePath;
  XL.DisplayAlerts := false;

  XLBook := XL.WorkBooks.Add;

  //  XLBook.WorkSheets[1].Name := DRPanel_Title.Caption; Ư�����ڵ���쿡������
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
//    XL.Quit;// @@@@@@@@@@@@@@@@2�ӽ�
  end;

  XLSheet  := UnAssigned;
  XLBook   := UnAssigned;
  XL       := UnAssigned;

  EnvSetupInfo.WriteString('GridExport', 'Dir', sDirFilePath);

  EnvSetupInfo.Free;

  EnableForm;
  gf_ShowMessage(MessageBar, mtInformation, 0, '����Ϸ�-' + sFileName);

end;

//------------------------------------------------------------------------------
//  CANCEL ��ư ó��
//------------------------------------------------------------------------------
procedure TForm_SCF.CxlBtnClick(Sender: TObject);
var
   iDecLevel : Integer;
   bConfirmed : boolean;
   sMsgStr, sQueryStr, sMsg : string;
begin
   ClearDecMessage;
   iDecLevel := (Sender as TDRBitBtn).Tag;

   // ��Ұ����ϳ�? ���� ���� ���� Ȯ��
   if gf_CanCancelDecLine(Self.Tag, gDecStlDate, iDecLevel,sMsg) then
   begin
     gf_ShowDlgMessage(Self.Tag, mtError, 0, sMsg, [mbYes] , 0);
     DRBitBtn_DecRefreshClick(DRBitBtn_DecRefresh);
     Exit;
   end;

   with ADOQuery_DECLN do
   begin

      // ���� ���� ó�� ����
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
         begin  // DataBase ����
            ShowDecMessage(mtError, '���� ó���� ���� �߻�!');
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[Delete]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[Delete]'); //Database ����
            Exit;
         end;
      End;

   end;  // end of with

   // ���� ���� ����
   DRBitBtn_DecRefreshClick(DRBitBtn_DecRefresh);
   ShowDecMessage(mtInformation, '<' +  (Sender as TDRBitBtn).Caption + '> ó�� �Ϸ�!');
end;

//��ȸ Script���� ��ȸ �Ϸ�(����)(DisplayGrid)�� ���� ��, ��ȸ��� ��� ���� ��.
procedure TForm_SCF.setJobDate(ctr : TDRMaskEdit);
begin
  FJobDate := ctr.Text;
end;

//��,��,��� ��ȸ����� ���� �۾���
//ó�� ���� ���� �� (��¥üũ�� �⺻ üũ��)
function TForm_SCF.checkJobDate(ctr : TDRMaskEdit) : boolean;
begin
  Result := false;
  if FJobDate = '' then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 0,
    'ó���� �� �����ϴ�. ' + #13#10 + #13#10 +
    '��ȸ�� ��¥�� �����ϴ�.', 0);
    gf_ShowMessage(MessageBar, mtError, 0, '��ȸ�� ��¥�� �����ϴ�.');
    Exit;
  end;

  if FJobDate <> ctr.Text then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 0,
    'ó���� �� �����ϴ�. ' + #13#10 + #13#10 +
    '��ȸ�� ��¥[' + FJobDate +']�� �۾���¥[' + ctr.Text +']�� �ٸ��ϴ�.', 0);
    gf_ShowMessage(MessageBar, mtError, 0, '��ȸ�� ��¥�� �۾���¥�� �ٸ��ϴ�.');
    Exit;
  end;
  Result := true;
end;

procedure TForm_SCF.RefreshForm;
begin
  // [L.J.S] 2018.01.31 �ڽ������� �ڵ� �ۼ��ؼ� ��� KEY DOWN -> CTRL + F5
end;

end.
