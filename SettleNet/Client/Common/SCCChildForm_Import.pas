//==============================================================================
//   [LMS] 2001/02/22
//==============================================================================
// Process Panel 관련 Function 처리
// File 선택 및 File 정보 Display
// Text File Load to RichEdit
unit SCCChildForm_Import;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCCChildForm, DRSpecial, StdCtrls, Buttons, DRAdditional, ExtCtrls,
  DRStandard, DRDialogs, Mask, ComCtrls, DRWin32, ADODB, Db, FileCtrl;

type
  TForm_SCF_Import = class(TForm_SCF)
    DRFramePanel_T: TDRFramePanel;
    DRLabel_FileCap: TDRLabel;
    DRSpeedBtn_FileName: TDRSpeedButton;
    DREdit_FileName: TDREdit;
    DRFramePanel_M: TDRFramePanel;
    DRLabel_FileSizeCap: TDRLabel;
    DRLabel_FileDateCap: TDRLabel;
    DRLabel_FileDate: TDRLabel;
    DRLabel_FileSize: TDRLabel;
    DRLabel_BaseDateCap: TDRLabel;
    DRLabel_FileNameCap: TDRLabel;
    DRLabel_FileName: TDRLabel;
    DROpenDialog_Import: TDROpenDialog;
    DRLabel_TodayImpCap: TDRLabel;
    DRLabel_TodayImp: TDRLabel;
    DRRichEdit_File: TDRRichEdit;
    ProcessPanel: TDRPanel;
    ProcPanel_Label_Msg: TDRLabel;
    ProcPanel_Label_TotalCnt: TDRLabel;
    ProcPanel_BitBtn_Confirm: TDRBitBtn;
    ProcPanel_Animate: TAnimate;
    ADOQuery_Temp: TADOQuery;
    ADOQuery_Main: TADOQuery;
    DRPanel_Additional: TDRPanel;
    DRLabel_AddTitle: TDRLabel;
    DRLabel_AddMsg: TDRLabel;
    DRLabel_AddMsgCap: TDRLabel;
    DRListBox_AddList: TDRListBox;
    DRButton_AddConf: TDRButton;
    DRButton_AddRegs: TDRButton;
    DRLabel_BaseDate: TDRLabel;
    Timer1: TTimer;
    //--- Process Panel Procedure ---
    procedure ShowProcessPanel(pMsg: string; pTotCount: Integer);
    procedure ErrorProcessPanel(pErrorMsg: string; pEnableOKBtn: boolean);
    procedure HideProcessPanel;
    //--------------------------------------------------------------------------
    procedure FormCreate(Sender: TObject);
    procedure DRSpeedBtn_FileNameClick(Sender: TObject);
    procedure ProcPanel_BitBtn_ConfirmClick(Sender: TObject);
    procedure DRButton_AddConfClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_SCF_Import: TForm_SCF_Import;

implementation

{$R *.DFM}

uses
  SCCLib, SCCCmuLib, SCCGlobalType;

//------------------------------------------------------------------------------
//  Show Process Panel
//------------------------------------------------------------------------------
procedure TForm_SCF_Import.ShowProcessPanel(pMsg: string; pTotCount: Integer);
begin
   gf_ControlCenterAllign(Self,ProcessPanel);
   ProcPanel_Label_Msg.Font.Color := ClNavy;
   ProcPanel_Label_Msg.Caption    := pMsg;
//   ProcPanel_Animate.FileName     := gvDirResource + 'Process.avi';
   ProcPanel_Animate.Visible      := True;
   ProcPanel_Animate.Active       := True;

   ProcessPanel.Enabled := True;
   ProcPanel_Label_Msg.Enabled := True;
   ProcPanel_Label_TotalCnt.Enabled := True;
   ProcPanel_BitBtn_Confirm.Enabled := False;
   if pTotCount = 0 then
      ProcPanel_Label_TotalCnt.Caption := ''
   else
      ProcPanel_Label_TotalCnt.Caption := 'Total Count: ' +  IntToStr(pTotCount);
   ProcessPanel.Visible := True;
   ProcessPanel.BringToFront;
   ProcessPanel.Repaint;
//   Timer1.Enabled := True;
end;

//------------------------------------------------------------------------------
//  Show Error Message in Process Panel
//------------------------------------------------------------------------------
procedure TForm_SCF_Import.ErrorProcessPanel(pErrorMsg: string;
                                                         pEnableOKBtn: boolean);
begin
   if ProcPanel_Animate.Active then
      ProcPanel_Animate.Active := False;
   ProcPanel_Label_Msg.Font.Color := ClMaroon;
   ProcPanel_Label_Msg.Caption    := pErrorMsg;
   Screen.Cursor := crDefault;
   ProcPanel_BitBtn_Confirm.Enabled := pEnableOKBtn;
   ProcessPanel.Repaint;
//   Timer1.Enabled := True;
end;

//------------------------------------------------------------------------------
//  Hide Process Panel
//------------------------------------------------------------------------------
procedure TForm_SCF_Import.HideProcessPanel;
begin
//   Timer1.Enabled := False;
   if ProcPanel_Animate.Active then
      ProcPanel_Animate.Active := False;
   ProcessPanel.Hide;
end;

//------------------------------------------------------------------------------
//  Clear Label Caption
//------------------------------------------------------------------------------
procedure TForm_SCF_Import.FormCreate(Sender: TObject);
begin
  inherited;
   DREdit_FileName.Color    := gcQueryEditColor;
   DRLabel_FileName.Caption := '';
   DRLabel_BaseDate.Caption := '';
   //DRLabel_DataCnt.Caption  := '';
   DRLabel_FileDate.Caption := '';
   DRLabel_FileSize.Caption := '';
   DRLabel_TodayImp.Caption := '';
end;

//---------------------------------------------------------------------------
//  FileName Button Click - Select & Load Text File
//---------------------------------------------------------------------------
procedure TForm_SCF_Import.DRSpeedBtn_FileNameClick(Sender: TObject);
var
   I : Integer;
   SearchRec : TSearchRec;
   sDirName  : string;
   DataList  : TStringList;
begin
  inherited;
   gf_ClearMessage(MessageBar);
   DRLabel_FileName.Caption := '';
   DRLabel_BaseDate.Caption := '';
   //DRLabel_DataCnt.Caption  := '';
   DRLabel_FileDate.Caption := '';
   DRLabel_FileSize.Caption := '';
   DRRichEdit_File.Lines.Clear;

   //--- 파일 선택 (Ini에서 Defualt Dir 읽어오기, 선택 후 저장)
   sDirName := gf_ReadFormStrInfo(Self.Name, 'Default Dir', gvDirImport);
   if DirectoryExists(sDirName) then
      DROpenDialog_Import.InitialDir := sDirName
   else
      DROpenDialog_Import.InitialDir := gvDirImport;
   if not DROpenDialog_Import.Execute then
   begin
      DREdit_FileName.Text := '';
      Exit;
   end;

   Screen.Cursor := crHourGlass;
   sDirName := ExtractFileDir(DROpenDialog_Import.FileName);
   gf_WriteFormStrInfo(Self.Name, 'Default Dir', sDirName);

   DREdit_FileName.Text := DROpenDialog_Import.FileName;
   if FindFirst(DROpenDialog_Import.FileName, faAnyFile, SearchRec) <> 0 then
   begin
      gf_ShowMessage(MessageBar, mtError, 1027, ''); // 해당 파일이 존재하지 않습니다.
      Exit;
   end;

   //--- 빈줄 제외 처리
   Try                            
      DataList := TStringList.Create;
      DataList.LoadFromFile(DROpenDialog_Import.FileName);
      DRRichEdit_File.Lines.Clear;
      for I := 0 to DataList.Count -1 do
      begin
        if I > 99 then
        begin
           Break;
        end else
        begin
          if Trim(DataList.Strings[I]) <> '' then
             DRRichEdit_File.Lines.Add(DataList.Strings[I]);
        end;
      end;
   Finally
      if Assigned(DataList) then DataList.Free;
   End;

   //--- Display to RichEdit
   //DRRichEdit_File.Lines.LoadFromFile(DROpenDialog_Import.FileName);

   //--- Display File Info.
   DRLabel_FileName.Caption := ExtractFileName(DROpenDialog_Import.FileName);
   //DRLabel_DataCnt.Caption := IntToStr(DRRichEdit_File.Lines.Count);
   DRLabel_FileDate.Caption :=
       DateTimeToStr(FileDateToDateTime(FileAge(DROpenDialog_Import.FileName)));
   DRLabel_FileSize.Caption := IntToStr(SearchRec.Size);

   if DRRichEdit_File.Lines.Count <= 0 then
      gf_ShowMessage(MessageBar, mtError, 1018, ''); // 해당 내역이 없습니다.
   Screen.Cursor := crDefault;   
end;

//------------------------------------------------------------------------------
//   확인 버튼 Click
//------------------------------------------------------------------------------
procedure TForm_SCF_Import.ProcPanel_BitBtn_ConfirmClick(Sender: TObject);
begin
  inherited;
   HideProcessPanel;
   EnableForm;
end;

//------------------------------------------------------------------------------
//   확인 버튼 Click
//------------------------------------------------------------------------------
procedure TForm_SCF_Import.DRButton_AddConfClick(Sender: TObject);
begin
  inherited;
   DRPanel_Additional.Visible := False;
   EnableForm;
end;

procedure TForm_SCF_Import.Timer1Timer(Sender: TObject);
begin
  inherited;
//  ProcessPanel.SetFocus;
//  ProcessPanel.Repaint;
//  ProcPanel_Animate.Repaint;
//  Application.ProcessMessages;
end;

end.
