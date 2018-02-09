//==============================================================================
//   송수신 Manager Child Form
//   [LMS] 2001/08/13
//==============================================================================

unit SCCSRMgrForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, DRAdditional, ExtCtrls, DRStandard, DRSpecial,
  ComCtrls, DRWin32, SCCSRMgrFrame;

type
  TForm_SRMgrForm = class(TForm)
    DRPanel_Top: TDRPanel;
    DRPanel_Title: TDRPanel;
    DRBitBtn1: TDRBitBtn;
    DRBitBtn2: TDRBitBtn;
    DRBitBtn3: TDRBitBtn;
    DRBitBtn4: TDRBitBtn;
    ProcessMsgBar: TDRPanel;
    MessageBar: TDRMessageBar;
    procedure ShowProcessMsgBar;
    procedure HideProcessMsgBar;
    procedure EnableForm;
    procedure DisableForm;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DRBitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FormDisabled : boolean;      // Form이 Disable 되어 있는지 여부
    CompStatList : TStringList;  // Component의 Enable/Disable 상태를 저장
  public
    Authority    : Integer; 
    ParentForm   : TForm_SRMgrFrame;    // Parent Form
  end;

var
  Form_SRMgrForm: TForm_SRMgrForm;

implementation

{$R *.DFM}

uses
   SCCGlobalType, SCCLib;

procedure TForm_SRMgrForm.FormCreate(Sender: TObject);
begin
   FormDisabled := False;
   CompStatList := TStringList.Create;
end;

procedure TForm_SRMgrForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   CompStatList.Free;
   Action := CaFree;
end;

//------------------------------------------------------------------------------
//  Show ProcessMsgBar
//------------------------------------------------------------------------------
procedure TForm_SRMgrForm.ShowProcessMsgBar;
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
procedure TForm_SRMgrForm.HideProcessMsgBar;
begin
   EnableForm;
   ProcessMsgBar.Visible := False;
   Repaint;
end;

//------------------------------------------------------------------------------
//  Enable Form
//------------------------------------------------------------------------------
procedure TForm_SRMgrForm.EnableForm;
var
   I, iStatIdx : Integer;
begin
   if not FormDisabled then Exit; // 이미 Form Enable 상태

   Screen.Cursor := crDefault;
   iStatIdx := -1;
   for I := 0 to ComponentCount -1 do
   begin
      if (Components[I] is TButton) or
         (Components[I] is TSpeedButton)or
         (Components[I] is TPanel) then   // Button & Panel만 처리
      begin
         Inc(iStatIdx);
         (Components[I] as TControl).Enabled := False;
         if CompStatList.Strings[iStatIdx] = 'E' then  // Enable 상태
         begin
               (Components[I] as TControl).Enabled := True
         end;  // end of if
      end;
   end;
   gf_EnableMainMenu;

   FormDisabled := False;
end;

//------------------------------------------------------------------------------
//  Disable Form
//------------------------------------------------------------------------------
procedure TForm_SRMgrForm.DisableForm;
var
   I : Integer;
begin
   if FormDisabled then Exit;  // 이미 Form Disable 상태

   Screen.Cursor := crHourGlass;
   CompStatList.Clear;
   for I := 0 to ComponentCount -1 do
   begin
      if (Components[I] is TButton) or
         (Components[I] is TSpeedButton) or
         (Components[I] is TPanel) then  // Button & Panel만 처리
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
//  종료 Button
//------------------------------------------------------------------------------
procedure TForm_SRMgrForm.DRBitBtn1Click(Sender: TObject);
begin
   Close;
   if Assigned(Self.Parent.Parent) then
      (Self.Parent.Parent as TForm).Close;
end;

//------------------------------------------------------------------------------
//  버튼 권한 부여
//------------------------------------------------------------------------------
procedure TForm_SRMgrForm.FormShow(Sender: TObject);
var
   I : Integer;
begin
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
end;

end.
