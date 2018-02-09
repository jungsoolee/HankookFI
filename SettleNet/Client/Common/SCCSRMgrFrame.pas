//==============================================================================
//   �ۼ��� Manager�� Frame
//   [LMS] 2000/12/22
//==============================================================================
unit SCCSRMgrFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, DRStandard, ImgList, DRWin32, ComCtrls, StdCtrls, Mask,
  DRAdditional, ExtCtrls, Buttons, DRCodeControl,
  SCCCmuGlobal, SCCGlobalType;

type
  TForm_SRMgrFrame = class(TForm)
    DRPanel_TreeView: TDRPanel;
    DRPanel2: TDRPanel;
    DRLabel2: TDRLabel;
    DRMaskEdit_Date: TDRMaskEdit;
    DRPanel3: TDRPanel;
    DRLabel4: TDRLabel;
    DRLabel_TreeErrCnt: TDRLabel;
    DRPanel_MSQ: TDRPanel;
    DRImageList_Tree: TDRImageList;
    DRPopupMenu_TreeView: TDRPopupMenu;
    N1: TMenuItem;
    DRSplitter1: TDRSplitter;
    DRPanel_Form: TDRPanel;
    DRSpeedBtn_Rcv: TDRSpeedButton;
    DRSpeedBtn_Snd: TDRSpeedButton;
    function  ShowChildForm(pForm: TForm):boolean;
    procedure CloseActiveChildForm;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DRMaskEdit_DateKeyPress(Sender: TObject; var Key: Char);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DRMaskEdit_DateChange(Sender: TObject);
  private
    procedure OnRcvMsmqResult(var msg: TMessage);   message WM_USER_MSMQ_RESULT;
    procedure OnRcvFaxResult(var msg: TMessage);    message WM_USER_FAX_RESULT;
    procedure OnRcvEMailResult(var msg: TMessage);  message WM_USER_EMAIL_RESULT;
    procedure OnRcvEnableFrame(var msg: TMessage);  message WM_USER_ENABLE_SRMGRFRAME;
    procedure OnRcvDisableFrame(var msg: TMessage); message WM_USER_DISABLE_SRMGRFRAME;
  public
    JobDate : string;              // ���õ� ��������
    ActiveChildForm : TForm;       // ���� ����� Form
    ActiveTranCode : string;       // ���� ����� TrCode
    DefFormHeight, DefFormWidth: Integer;
    FormDisabled : boolean;
  end;

var
  Form_SRMgrFrame: TForm_SRMgrFrame;

implementation

{$R *.DFM}

uses
   SCCLib, SCCSRMgrForm;

const
   ChildWidth  = 950;
   ChildHeight = 595;

//------------------------------------------------------------------------------
//   WM_USER_MSMQ_RESULT Broadcast
//------------------------------------------------------------------------------
procedure TForm_SRMgrFrame.OnRcvMsmqResult(var msg: TMessage);
begin
   if Assigned(ActiveChildForm) then
      SendMessage(ActiveChildForm.Handle, WM_USER_MSMQ_RESULT, msg.WParam, msg.LParam);
end;

//------------------------------------------------------------------------------
//   WM_USER_FAX_RESULT Broadcast
//------------------------------------------------------------------------------
procedure TForm_SRMgrFrame.OnRcvFaxResult(var msg: TMessage);
begin
   if Assigned(ActiveChildForm) then
      SendMessage(ActiveChildForm.Handle, WM_USER_FAX_RESULT, msg.WParam, msg.LParam);
end;

//------------------------------------------------------------------------------
//   WM_USER_EMAIL_RESULT Broadcast
//------------------------------------------------------------------------------
procedure TForm_SRMgrFrame.OnRcvEMailResult(var msg: TMessage);
begin
   if Assigned(ActiveChildForm) then
      SendMessage(ActiveChildForm.Handle, WM_USER_EMAIL_RESULT, msg.WParam, msg.LParam);
end;

//------------------------------------------------------------------------------
//  Enable TreeView
//------------------------------------------------------------------------------
procedure TForm_SRMgrFrame.OnRcvEnableFrame(var msg: TMessage);
begin
   DRPanel_TreeView.Enabled := True;
   FormDisabled := False;
end;

//------------------------------------------------------------------------------
//  Disable TreeView
//------------------------------------------------------------------------------
procedure TForm_SRMgrFrame.OnRcvDisableFrame(var msg: TMessage);
begin
   DRPanel_TreeView.Enabled := False;
   FormDisabled := True;
end;

//------------------------------------------------------------------------------
//  SCCSRMgrForm Create ���� ó�� (Set Data & Query & Display)
//------------------------------------------------------------------------------
function TForm_SRMgrFrame.ShowChildForm(pForm: TForm):boolean;
begin
   if not Assigned(pForm) then  // Create ������ Error �߻�
   begin
      ActiveChildForm := nil;
      Result := False;
      Exit;
   end;

   ActiveChildForm := pForm;
   with (pForm as TForm_SRMgrForm) do
   begin
      Parent := DRPanel_Form;
      ParentForm := Self;
      // ChildForm Query & Display (ParentForm.JobDate�� Query ����....)
      SendMessage(ActiveChildForm.Handle, WM_USER_CHANGE_JOBDATE, 0, 0);
      Show;
   end;
   Result := True;
end;

//------------------------------------------------------------------------------
//  SCCSRMgrForm Create Close
//------------------------------------------------------------------------------
procedure TForm_SRMgrFrame.CloseActiveChildForm;
begin
   if Assigned(ActiveChildForm) then
   begin
      ActiveChildForm.Close;
      ActiveChildForm := nil;
   end;
end;


procedure TForm_SRMgrFrame.FormCreate(Sender: TObject);
begin
   DRPanel_TreeView.Width := -1;
   Top := 2;
   Left := 2;
   ClientHeight := ChildHeight;
   ClientWidth  := ChildWidth + DRPanel_TreeView.Width;
   DRMaskEdit_Date.Text := gvCurDate;
   FormDisabled := False;
end;

procedure TForm_SRMgrFrame.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   SendMessage(gvMainFrameHandle, WM_USER_BF_FORM_CLOSE, Self.Tag, 0);
   Action := CaFree;
end;

//------------------------------------------------------------------------------
//  ���� ����
//------------------------------------------------------------------------------
procedure TForm_SRMgrFrame.DRMaskEdit_DateKeyPress(Sender: TObject;
  var Key: Char);
begin
{
   if Key = #13 then
   begin
      if not gf_CheckValidDate(DRMaskEdit_Date.Text) then
         gf_ShowErrDlgMessage(Self.Tag, 1040, '', 0); // ���� �Է� ����
      if not Assigned(ActiveChildForm) then Exit;
      SendMessage(ActiveChildForm.Handle, WM_USER_CHANGE_JOBDATE, 0, 0);
      DRMaskEdit_Date.SetFocus;
      DRMaskEdit_Date.SelectAll;
   end;
}
end;

//------------------------------------------------------------------------------
//  Form Enable ���¿����� ���� �����ϵ��� ó��
//------------------------------------------------------------------------------
procedure TForm_SRMgrFrame.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
   CanClose := not FormDisabled;  // Form Enable ���¿����� ���� ����
end;

//------------------------------------------------------------------------------
//  Assign Job Date
//------------------------------------------------------------------------------
procedure TForm_SRMgrFrame.DRMaskEdit_DateChange(Sender: TObject);
begin
   JobDate := DRMaskEdit_Date.Text;
end;

end.
