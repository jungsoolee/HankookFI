//==============================================================================
//   [LMS] 2002/02/09
//==============================================================================
unit SCCEnvSetup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DRStandard, DRColorTab, Buttons, DRAdditional, ExtCtrls, IniFiles,
  Grids, Outline, DirOutln, FileCtrl, ComCtrls;

type
  TForm_EnvSetup = class(TForm)
    DRPanel_Bottom: TDRPanel;
    DRPanel1: TDRPanel;
    DRPageControl_EnvSetup: TDRPageControl;
    DRTabSheet_Server: TDRTabSheet;
    DRBitBtn_Cancel: TDRBitBtn;
    DRBitBtn_Ok: TDRBitBtn;
    DRLabel1: TDRLabel;
    DRLabel2: TDRLabel;
    DRLabel3: TDRLabel;
    DRLabel4: TDRLabel;
    DRLabel5: TDRLabel;
    DREdit_PrimarySvr: TDREdit;
    DREdit_BackupSvr: TDREdit;
    DREdit_Port: TDREdit;
    DREdit_TimeOut: TDREdit;
    DRRadioGroup_CurSvr: TDRRadioGroup;
    DRPanel_Msg: TDRPanel;
    DRImage1: TDRImage;
    DRTabSheet_EnvSetup: TDRTabSheet;
    DRGroupBox1: TDRGroupBox;
    DRLabel6: TDRLabel;
    DRLabel7: TDRLabel;
    DREdit_OprUsrNo: TDREdit;
    DREdit_Pswrd: TDREdit;
    DRCheckBox_SavePswrd: TDRCheckBox;
    procedure DisplayMsg(pMsg: string);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DRBitBtn_OkClick(Sender: TObject);
    procedure DRBitBtn_CancelClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure DRTabSheet_EnvSetupEnter(Sender: TObject);
    procedure DRTabSheet_ServerEnter(Sender: TObject);
    procedure DRPageControl_EnvSetupChange(Sender: TObject);
    procedure DREdit_ImportDirChange(Sender: TObject);
  private
    FormCreated : boolean;
  public
    { Public declarations }
  end;

var
  Form_EnvSetup: TForm_EnvSetup;

implementation

{$R *.DFM}

uses
   SCCLib, SCCGlobalType, SCCLogin;

var
   EnvSetupInfo : TIniFile;   // Ini File
   sDirCfg      : string;

const
   DIR_IMPORT = 1;  // Import
   DIR_EXPORT = 2;  // Export
   DIR_KSDACC = 3;  // KsdAcc

//------------------------------------------------------------------------------
//   Form Create
//------------------------------------------------------------------------------
procedure TForm_EnvSetup.FormCreate(Sender: TObject);
var
   CurSvr : string;
begin
   sDirCfg := gf_GetAppRootPath + 'Cfg/';
   DRPageControl_EnvSetup.ActivePage := DRPageControl_EnvSetup.Pages[0];

   //=== Server 설정 정보
   EnvSetupInfo := TIniFile.Create(gvDirCfg + gcMainIniFileName);
   DREdit_PrimarySvr.Text := EnvSetupInfo.ReadString('Communication Setup', 'PrimaryServer', '');
   DREdit_BackupSvr.Text  := EnvSetupInfo.ReadString('Communication Setup', 'BackupServer', '');
   DREdit_Port.Text       := EnvSetupInfo.ReadString('Communication Setup', 'Port', '3001');
   DREdit_TimeOut.Text    := EnvSetupInfo.ReadString('Communication Setup', 'TimeOut', '60');
   CurSvr                 := EnvSetupInfo.ReadString('Communication Setup', 'CurrentServer', 'Primary');

   if CurSvr = 'Primary' then
      DRRadioGroup_CurSvr.ItemIndex := 0
   else  // CurSvr = 'Backup'
      DRRadioGroup_CurSvr.ItemIndex := 1;

   //=== 환경 설정 정보
   // 사용자 정보
   DREdit_OprUsrNo.Text   := EnvSetupInfo.ReadString('User Information', 'UserID', '');

   FormCreated := True;
end;

//------------------------------------------------------------------------------
//   Form Close
//------------------------------------------------------------------------------
procedure TForm_EnvSetup.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   EnvSetupInfo.Free;
   Action := CaFree;
end;

//------------------------------------------------------------------------------
//   확인
//------------------------------------------------------------------------------
procedure TForm_EnvSetup.DRBitBtn_OkClick(Sender: TObject);
begin
   if not DirectoryExists(sDirCfg) then   // 저장 전 Directory 존재 여부 확인
      if not CreateDir(sDirCfg) then
         raise Exception.Create('Cannot Create ' + sDirCfg);

   //=== Server 설정 정보
   EnvSetupInfo.WriteString('Communication Setup','PrimaryServer', DREdit_PrimarySvr.Text);
   EnvSetupInfo.WriteString('Communication Setup','BackupServer', DREdit_BackupSvr.Text);
   EnvSetupInfo.WriteString('Communication Setup','Port', DREdit_Port.Text);
   EnvSetupInfo.WriteString('Communication Setup','TimeOut', DREdit_TimeOut.Text);
   EnvSetupInfo.WriteString('Communication Setup','CurrentServer',
                             DRRadioGroup_CurSvr.Items[DRRadioGroup_CurSvr.ItemIndex]);
   //=== 사용자 설정 정보
   EnvSetupInfo.WriteString('User Information','UserID', DREdit_OprUsrNo.Text);
   DisplayMsg('저장되었습니다.');

   //=== 사용자 설정 적용
   if Trim(DREdit_OprUsrNo.Text) <> '' then
      Form_Login.DREdit_OprUsrNo.Text := DREdit_OprUsrNo.Text;
   Close;
end;

//------------------------------------------------------------------------------
//   취소
//------------------------------------------------------------------------------
procedure TForm_EnvSetup.DRBitBtn_CancelClick(Sender: TObject);
begin
   Close;
end;

//------------------------------------------------------------------------------
//   Display Message
//------------------------------------------------------------------------------
procedure TForm_EnvSetup.DisplayMsg(pMsg: string);
begin
   DRPanel_Msg.Visible := True;
   DRPanel_Msg.Caption := pMsg;
   DRPanel_Msg.Repaint;
   Sleep(500);
   DRPanel_Msg.Visible := False;
end;

//------------------------------------------------------------------------------
//   Enter Key 입력시 Control Focus 이동
//------------------------------------------------------------------------------
procedure TForm_EnvSetup.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if Key = #13 then
      SelectNext(ActiveControl as TWinControl, True, True);
end;

procedure TForm_EnvSetup.DRTabSheet_EnvSetupEnter(Sender: TObject);
begin
   DREdit_OprUsrNo.SetFocus;
end;

procedure TForm_EnvSetup.DRTabSheet_ServerEnter(Sender: TObject);
begin
   DREdit_PrimarySvr.SetFocus;
end;

procedure TForm_EnvSetup.DRPageControl_EnvSetupChange(Sender: TObject);
begin
   case DRPageControl_EnvSetup.ActivePage.PageIndex of
      0 : if FormCreated then DREdit_PrimarySvr.SetFocus;
      1 : if FormCreated then DREdit_OprUsrNo.SetFocus;
   end;  // end of case
end;

procedure TForm_EnvSetup.DREdit_ImportDirChange(Sender: TObject);
begin
   (Sender as TEdit).Hint := (Sender as TEdit).Text;  
end;

end.
