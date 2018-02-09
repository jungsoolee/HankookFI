//==============================================================================
//   [LHA] 2001/10/22
//==============================================================================
unit SCCShowAttDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DRStandard, ExtCtrls, DRAdditional, Db, ADODB, ShellAPI,
  DRDialogs, FileCtrl, SCCGlobalType;

type
  TForm_ShowAttDlg = class(TForm)
    DRImage1: TDRImage;
    DRLabel1: TDRLabel;
    DRLabel_AttFileName: TDRLabel;
    DRBevel1: TDRBevel;
    DRLabel2: TDRLabel;
    DRLabel3: TDRLabel;
    DRLabel4: TDRLabel;
    DRLabel5: TDRLabel;
    DRRadioBtn_Open: TDRRadioButton;
    DRRadioBtn_Save: TDRRadioButton;
    DRButton_Ok: TDRButton;
    DRButton_Cancel: TDRButton;
    ADOQuery_SCMELATT: TADOQuery;
    DRSaveDialog1: TDRSaveDialog;
    procedure DRButton_OkClick(Sender: TObject);
    procedure DRButton_CancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
     pbSndDate     : string;    // 전송일자
     pbAttSeqNo    : Integer;   // AttachSeqNo
     pFreqItem     : pTFreqMail;  // AttFile List
  end;

var
  Form_ShowAttDlg: TForm_ShowAttDlg;

implementation

{$R *.DFM}

uses
   SCCLib;


procedure TForm_ShowAttDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := caFree;
end;

//------------------------------------------------------------------------------
// 촥인버튼 클릭
//------------------------------------------------------------------------------
procedure TForm_ShowAttDlg.DRButton_OkClick(Sender: TObject);
var
   sFileName, sDirName : string;
   AttItem : pTAttFile;

begin
   if not Assigned(pFreqItem.AttFileList) then Exit;
   AttItem := pFreqItem.AttFileList.Items[pbAttSeqNo];
   // 열기
   if DRRadioBtn_Open.Checked then
   begin
      sFileName := gvDirTemp + ExtractFileName(AttItem.FileName);
      if FileExists(sFileName) then DeleteFile(sFileName);
      if not gf_SaveMailAttachToFile(pbSndDate, pFreqItem.CurTotSeqNo, AttItem.AttSeqNo, sFileName) then
      begin
         gf_ShowErrDlgMessage(0, gvErrorNo, gvExtMsg, 0);  // Error 발생
         Exit;
      end;
      if ShellExecute(Handle, 'open', Pchar(sFileName), nil, nil, SW_SHOW) = SE_ERR_NOASSOC then
         WinExec(PChar('rundll32.exe shell32.dll, OpenAs_RunDLL ' +  sFileName), SW_SHOW);
      Self.Close;  // Form Close
   end;

   // 저장
   if DRRadioBtn_Save.Checked then
   begin
      sDirName := gf_ReadFormStrInfo(Self.Name, 'Default Dir', gf_GetAppRootPath);
      if DirectoryExists(sDirName) then
         DRSaveDialog1.InitialDir := sDirName
      else
         DRSaveDialog1.InitialDir := gf_GetAppRootPath;
      DRSaveDialog1.FileName := AttItem.FileName;
      if DRSaveDialog1.Execute then  // 저장
      begin
         sFileName := DRSaveDialog1.FileName;
         sDirName  := ExtractFileDir(sFileName);
         gf_WriteFormStrInfo(Self.Name, 'Default Dir', sDirName);
         if not gf_SaveMailAttachToFile(pbSndDate, pFreqItem.CurTotSeqNo, AttItem.AttSeqNo, sFileName) then
         begin
            gf_ShowErrDlgMessage(0, gvErrorNo, gvExtMsg, 0);  // Error 발생
            Exit;
         end;
         Self.Close;  // Form Close
      end;
   end;
end;

//------------------------------------------------------------------------------
// 취소버튼 클릭
//------------------------------------------------------------------------------
procedure TForm_ShowAttDlg.DRButton_CancelClick(Sender: TObject);
begin
  Close;
end;


end.
