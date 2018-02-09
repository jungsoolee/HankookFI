//==============================================================================
//   송수신 Manager Send Form
//   [LMS] 2001/02/06
//==============================================================================

unit SCCSRMgrForm_SND;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCCSRMgrForm, DRSpecial, StdCtrls, Buttons, DRAdditional, ExtCtrls,
  DRStandard, Grids, DRStringgrid, DRColorTab, ComCtrls, DRWin32, menus,
  DRDialogs, ComObj,OleServer, IniFiles, Excel97, Variants;

type
  TForm_SCF_SND = class(TForm_SRMgrForm)
    DRFramePanel_Query: TDRFramePanel;
    ProcessPanel: TDRPanel;
    ProcPanel_Label_Msg: TDRLabel;
    ProcPanel_Label_TotalCnt: TDRLabel;
    ProcPanel_Label_ProcCnt: TDRLabel;
    ProcPanel_ProgressBar: TDRProgressBar;
    ProcPanel_BitBtn_Confirm: TDRBitBtn;
    ProcPanel_Animate: TDRAnimate;
    DRPageControl_Main: TDRPageControl;
    DRTabSheet_Data: TDRTabSheet;
    DRSplitter_Data: TDRSplitter;
    DRPanel_SndData: TDRPanel;
    DRPanel_SndDataTitle: TDRPanel;
    DRLabel_SndData: TDRLabel;
    DRStrGrid_SndData: TDRStringGrid;
    DRPanel_SntData: TDRPanel;
    DRPanel_SntDataTitle: TDRPanel;
    DRLabel_SntData: TDRLabel;
    DRPanel_SntDataSelect: TDRPanel;
    DRRadioBtn_DataSend: TDRRadioButton;
    DRRadioBtn_DataError: TDRRadioButton;
    DRRadioBtn_DataAll: TDRRadioButton;
    DRCheckBox_DataTotFreq: TDRCheckBox;
    DRStrGrid_SntData: TDRStringGrid;
    DRTabSheet_FaxTlx: TDRTabSheet;
    DRSplitter_FaxTlx: TDRSplitter;
    DRPanel_SndFaxTlx: TDRPanel;
    DRStrGrid_SndFaxTlx: TDRStringGrid;
    DRPanel_SndFaxTlxTitle: TDRPanel;
    DRLabel_SndFaxTlx: TDRLabel;
    DRSpeedBtn_SndFaxTlxPrint: TDRSpeedButton;
    DRPanel_SntFaxTlx: TDRPanel;
    DRPanel_SntFaxTlxTitle: TDRPanel;
    DRLabel_SntFaxTlx: TDRLabel;
    DRSpeedBtn_SntFaxTlxPrint: TDRSpeedButton;
    DRSpeedBtn_FaxTlxResend: TDRSpeedButton;
    DRSpeedBtn_FaxTlxExport: TDRSpeedButton;
    DRPanel_SntFaxTlxSelect: TDRPanel;
    DRRadioBtn_FaxTlxSend: TDRRadioButton;
    DRRadioBtn_FaxTlxError: TDRRadioButton;
    DRRadioBtn_FaxTlxAll: TDRRadioButton;
    DRStrGrid_SntFaxTlx: TDRStringGrid;
    DRTabSheet_EMail: TDRTabSheet;
    DRCheckBox_FaxTlxTotFreq: TDRCheckBox;
    DRPanel_SndMail: TDRPanel;
    DRSpeedBtn_SndFaxTlxSelect: TDRSpeedButton;
    DRSpeedBtn_SntFaxTlxSelect: TDRSpeedButton;
    DRSplitter_EMail: TDRSplitter;
    DRPanel_SndEmail: TDRPanel;
    DRPanel_SndMailTitle: TDRPanel;
    DRLabel_SndMail: TDRLabel;
    DRSpeedBtn_SndMailDir: TDRSpeedButton;
    DRLabel_SndMailDir: TDRLabel;
    DRSpeedBtn_Export: TDRSpeedButton;
    DREdit_SndMailDir: TDREdit;
    DRStrGrid_SndMail: TDRStringGrid;
    DRPanel_SntEmail: TDRPanel;
    DRPanel1: TDRPanel;
    DRLabel_SntMail: TDRLabel;
    DRSpeedBtn_SntEmailPrint: TDRSpeedButton;
    DRSpeedBtn_EmailResend: TDRSpeedButton;
    DRSpeedBtn_EmailExport: TDRSpeedButton;
    DRSpeedBtn_SntEmailSelect: TDRSpeedButton;
    DRPanel4: TDRPanel;
    DRRadioBtn_EmailSend: TDRRadioButton;
    DRRadioBtn_EmailError: TDRRadioButton;
    DRRadioBtn_EmailAll: TDRRadioButton;
    DRCheckBox_EmailTotFreq: TDRCheckBox;
    DRStrGrid_SntMail: TDRStringGrid;
    DRSaveDialog_GridExport: TDRSaveDialog;
    DRPanel3: TDRPanel;
    DRPanel2: TDRPanel;
    DRCheckBox_ClientNM: TDRCheckBox;
    DRCheckBox_View: TDRCheckBox;
    DRPanel5: TDRPanel;
    //--- Process Panel Procedure ---
    procedure ShowProcessPanel(pMsg: string; pTotSendCount: Integer; pShowProgressBar, pShowAVI : boolean);
    procedure IncProcessPanel(pProcessCount, pStepBy: Integer);
    procedure ErrorProcessPanel(pErrorMsg: string; pEnableOKBtn: boolean);
    procedure HideProcessPanel;
    //--------------------------------------------------------------------------
    procedure ChangeViewType(pViewType: Integer; pParentTabSheet : TDRTabSheet;
                            pSndPanel, pSntPanel: TPanel; pSplitter: TSplitter);
    procedure FormCreate(Sender: TObject);
    procedure DRPageControl_MainChange(Sender: TObject);
    procedure DRPanel_SndDataTitleDblClick(Sender: TObject);
    procedure DRPanel_SntDataTitleDblClick(Sender: TObject);
    procedure DRPanel_SndFaxTlxTitleDblClick(Sender: TObject);
    procedure DRPanel_SntFaxTlxTitleDblClick(Sender: TObject);
    procedure ProcPanel_BitBtn_ConfirmClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DRLabel_SndMailClick(Sender: TObject);
    procedure DRLabel_SntMailClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ChildFormGridExport(DRGrid1: TDRStringGrid);

  private
    procedure TopBtnClick(sCaption: string);
    { Private declarations }
  public
    SndOnlyViewFlag : boolean;   // View Type
    SntOnlyViewFlag : boolean;   // View Type
    SndOnlyEMailViewFlag : boolean;   // View Type
    SntOnlyEMailViewFlag : boolean;   // View Type
  end;

var
  Form_SCF_SND: TForm_SCF_SND;

implementation

{$R *.DFM}

uses
   SCCGlobalType, SCCLib;

const
   PAGE_IDX_DATA         = 0;   // Data Page Tab Index
   PAGE_IDX_FAXTLX       = 1;   // Fax/Tlx Page Tab Index
   PAGE_IDX_EMAIL        = 2;   // EMail Page Tab Index


procedure TForm_SCF_SND.FormCreate(Sender: TObject);
begin
  inherited;
   //=== Assign Variable
   SndOnlyViewFlag := False;                     // 전체 보기
   SntOnlyViewFlag := False;                     // 전체 보기
   SndOnlyEmailViewFlag := False;                     // 전체 보기
   SntOnlyEmailViewFlag := False;                     // 전체 보기
end;
   
//------------------------------------------------------------------------------
//  Show Process Panel
//------------------------------------------------------------------------------
procedure TForm_SCF_SND.ShowProcessPanel(pMsg: string;
                   pTotSendCount: Integer; pShowProgressBar, pShowAVI: boolean);
begin
   ProcPanel_Label_Msg.Font.Color := ClNavy;
   ProcPanel_Label_Msg.Caption    := pMsg;
   ProcPanel_ProgressBar.Visible  := False;
   ProcPanel_Animate.Visible      := False;
   if pShowProgressBar then
   begin
      ProcPanel_ProgressBar.Visible  := True;
      ProcPanel_ProgressBar.Position := 0;
      ProcPanel_ProgressBar.Max      := pTotSendCount;
   end;
   if pShowAVI then
   begin
      ProcPanel_Animate.Visible := True;
//      ProcPanel_Animate.FileName := gvDirResource + 'Process.avi';
      ProcPanel_Animate.Active := True;
   end;
   ProcessPanel.Enabled := True;
   ProcPanel_Label_Msg.Enabled := True;
   ProcPanel_ProgressBar.Enabled := True;
   ProcPanel_Label_TotalCnt.Enabled := True;
   ProcPanel_Label_ProcCnt.Enabled := True;
   ProcPanel_BitBtn_Confirm.Enabled := False;
   ProcPanel_Label_TotalCnt.Caption := 'Total Count: ' +  IntToStr(pTotSendCount);
   ProcPanel_Label_ProcCnt.Caption := 'Process No : 0';
   ProcessPanel.Visible := True;
   ProcessPanel.BringToFront;
   ProcessPanel.Repaint;
end;

//------------------------------------------------------------------------------
//  Increse Process Panel ProgressBar
//------------------------------------------------------------------------------
procedure TForm_SCF_SND.IncProcessPanel(pProcessCount, pStepBy: Integer);
begin
   ProcPanel_ProgressBar.StepBy(pStepBy);
   ProcPanel_ProgressBar.Repaint;
   ProcPanel_Label_ProcCnt.Caption := 'Process No : ' + IntToStr(pProcessCount);
   ProcessPanel.Repaint;
end;

//------------------------------------------------------------------------------
//  Show Error Message in Process Panel
//------------------------------------------------------------------------------
procedure TForm_SCF_SND.ErrorProcessPanel(pErrorMsg: string;
  pEnableOKBtn: boolean);
begin
   if ProcPanel_Animate.Active then
      ProcPanel_Animate.Active := False;
   ProcPanel_Label_Msg.Font.Color := ClMaroon;
   ProcPanel_Label_Msg.Caption    := pErrorMsg;
   Screen.Cursor := crDefault;
   ProcPanel_BitBtn_Confirm.Enabled := pEnableOKBtn;
   ProcessPanel.Repaint;
end;

//------------------------------------------------------------------------------
//  Hide Process Panel
//------------------------------------------------------------------------------
procedure TForm_SCF_SND.HideProcessPanel;
begin
   if ProcPanel_Animate.Active then
      ProcPanel_Animate.Active := False;
   ProcessPanel.Hide;
end;

//------------------------------------------------------------------------------
//  매체 변경시
//------------------------------------------------------------------------------
procedure TForm_SCF_SND.DRPageControl_MainChange(Sender: TObject);
begin
  inherited;
   case DRPageControl_Main.ActivePage.PageIndex of
      PAGE_IDX_DATA:  // Data
      begin
         if SndOnlyViewFlag then
            ChangeViewType(gcVIEW_SEND,DRTabSheet_Data, DRPanel_SndData, DRPanel_SntData ,DRSplitter_Data)
         else if  SntOnlyViewFlag then
            ChangeViewType(gcVIEW_SENT,DRTabSheet_Data, DRPanel_SndData, DRPanel_SntData ,DRSplitter_Data)
         else
            ChangeViewType(gcVIEW_ALL,DRTabSheet_Data, DRPanel_SndData, DRPanel_SntData ,DRSplitter_Data);
      end;

      PAGE_IDX_FAXTLX:  // Fax/Tlx
      begin
         if SndOnlyViewFlag then
            ChangeViewType(gcVIEW_SEND,DRTabSheet_FaxTlx, DRPanel_SndFaxTlx, DRPanel_SntFaxTlx ,DRSplitter_FaxTlx)
         else if  SntOnlyViewFlag then
            ChangeViewType(gcVIEW_SENT,DRTabSheet_FaxTlx, DRPanel_SndFaxTlx, DRPanel_SntFaxTlx ,DRSplitter_FaxTlx)
         else
            ChangeViewType(gcVIEW_ALL,DRTabSheet_FaxTlx, DRPanel_SndFaxTlx, DRPanel_SntFaxTlx ,DRSplitter_FaxTlx);
      end;

      PAGE_IDX_EMAIL: // EMail
      begin
      end;
   end; // end of case
end;

//------------------------------------------------------------------------------
//  Display 변경 : 자료 전송 Only, 송신 확인 Only, 둘다
//  pViewType : gcVIEW_SEND, gcVIEW_SENT, gcVIEW_ALL
//------------------------------------------------------------------------------
procedure TForm_SCF_SND.ChangeViewType(pViewType: Integer;
  pParentTabSheet: TDRTabSheet; pSndPanel, pSntPanel: TPanel;
  pSplitter: TSplitter);
begin
   pSplitter.Align   := alNone;
   pSplitter.Visible := False;
   pSndPanel.Align   := alNone;
   pSntPanel.Align   := alNone;

   if pViewType = gcVIEW_ALL then         // 전체 보기
   begin
      pSndPanel.Height  := pParentTabSheet.Height div 2;
      pSndPanel.Align   := alTop;
      pSplitter.Align   := alTop;
      pSplitter.Visible := True;
      pSntPanel.Align   := alClient;
   end
   else if pViewType = gcVIEW_SEND then   // 자료 전송
   begin
      pSndPanel.Align := alClient;
      pSplitter.Align := alTop;
      pSndPanel.BringToFront;
   end
   else if pViewType = gcVIEW_SENT then   // 송신 확인
   begin
      pSplitter.Align := alTop;
      pSntPanel.Align := alClient;
      pSntPanel.BringToFront;
   end;
end;

//------------------------------------------------------------------------------
//  Send Data - Change View Type
//------------------------------------------------------------------------------
procedure TForm_SCF_SND.DRPanel_SndDataTitleDblClick(Sender: TObject);
begin
  inherited;
{
   SndOnlyViewFlag := not SndOnlyViewFlag;
   SntOnlyViewFlag := False;

   if SndOnlyViewFlag then   // 자료 전송만 보기
      ChangeViewType(gcVIEW_SEND, DRTabSheet_Data, DRPanel_SndData, DRPanel_SntData ,DRSplitter_Data)
   else  // 전체 보기
      ChangeViewType(gcVIEW_ALL, DRTabSheet_Data, DRPanel_SndData, DRPanel_SntData ,DRSplitter_Data);
}
end;

//------------------------------------------------------------------------------
//  Sent Data -Change View Type
//------------------------------------------------------------------------------
procedure TForm_SCF_SND.DRPanel_SntDataTitleDblClick(Sender: TObject);
begin
  inherited;
{
   SntOnlyViewFlag := not SntOnlyViewFlag;
   SndOnlyViewFlag := False;

   if SntOnlyViewFlag then   // 전송 확인만 보기
      ChangeViewType(gcVIEW_SENT, DRTabSheet_Data, DRPanel_SndData, DRPanel_SntData ,DRSplitter_Data)
   else
      ChangeViewType(gcVIEW_ALL, DRTabSheet_Data, DRPanel_SndData, DRPanel_SntData ,DRSplitter_Data);
}      
end;

//------------------------------------------------------------------------------
//  Send Fax/Tlx - Change View Type
//------------------------------------------------------------------------------
procedure TForm_SCF_SND.DRPanel_SndFaxTlxTitleDblClick(Sender: TObject);
begin
  inherited;
   SndOnlyViewFlag := not SndOnlyViewFlag;
   SntOnlyViewFlag := False;

   if SndOnlyViewFlag then   // 자료 전송만 보기
      ChangeViewType(gcVIEW_SEND, DRTabSheet_FaxTlx, DRPanel_SndFaxTlx, DRPanel_SntFaxTlx ,DRSplitter_FaxTlx)
   else  // 전체 보기
      ChangeViewType(gcVIEW_ALL, DRTabSheet_FaxTlx, DRPanel_SndFaxTlx, DRPanel_SntFaxTlx ,DRSplitter_FaxTlx);
end;

//------------------------------------------------------------------------------
//  Sent Fax/Tlx - Change View Type
//------------------------------------------------------------------------------
procedure TForm_SCF_SND.DRPanel_SntFaxTlxTitleDblClick(Sender: TObject);
begin
  inherited;
   SntOnlyViewFlag := not SntOnlyViewFlag;
   SndOnlyViewFlag := False;

   if SntOnlyViewFlag then   // 전송 확인만 보기
      ChangeViewType(gcVIEW_SENT, DRTabSheet_FaxTlx, DRPanel_SndFaxTlx, DRPanel_SntFaxTlx ,DRSplitter_FaxTlx)
   else
      ChangeViewType(gcVIEW_ALL, DRTabSheet_FaxTlx, DRPanel_SndFaxTlx, DRPanel_SntFaxTlx ,DRSplitter_FaxTlx);
end;

//------------------------------------------------------------------------------
//  Send Email - Change View Type
//------------------------------------------------------------------------------
procedure TForm_SCF_SND.DRLabel_SndMailClick(Sender: TObject);
begin
  inherited;
{
###막아놓은 이유...
   Flag를 팩스랑 이메일이랑 같이 써야 하는가..?  분리해야 될 것 같은데..?
}

   SndOnlyEmailViewFlag := not SndOnlyEmailViewFlag;
   SntOnlyEmailViewFlag := False;

   if SndOnlyEmailViewFlag then   // 자료 전송만 보기
      ChangeViewType(gcVIEW_SEND, DRTabSheet_EMail, DRPanel_SndEMail, DRPanel_SntEMail ,DRSplitter_EMail)
   else  // 전체 보기
      ChangeViewType(gcVIEW_ALL, DRTabSheet_EMail, DRPanel_SndEMail, DRPanel_SntEMail ,DRSplitter_EMail);
end;

//------------------------------------------------------------------------------
//  Sent Email - Change View Type
//------------------------------------------------------------------------------
procedure TForm_SCF_SND.DRLabel_SntMailClick(Sender: TObject);
begin
  inherited;
{
###막아놓은 이유...
   Flag를 팩스랑 이메일이랑 같이 써야 하는가..?  분리해야 될 것 같은데..?
}
   SntOnlyEmailViewFlag := not SntOnlyEmailViewFlag;
   SndOnlyEmailViewFlag := False;

   if SntOnlyEmailViewFlag then   // 전송 확인만 보기
      ChangeViewType(gcVIEW_SENT, DRTabSheet_EMail, DRPanel_SndEMail, DRPanel_SntEMail ,DRSplitter_EMail)
   else
      ChangeViewType(gcVIEW_ALL, DRTabSheet_EMail, DRPanel_SndEMail, DRPanel_SntEMail ,DRSplitter_EMail);

end;


procedure TForm_SCF_SND.ProcPanel_BitBtn_ConfirmClick(Sender: TObject);
begin
  inherited;
   HideProcessPanel;
   EnableForm;
   gf_EnableSRMgrFrame(ParentForm);
end;


//------------------------------------------------------------------------------
//  사용자 권한 처리
//------------------------------------------------------------------------------
procedure TForm_SCF_SND.FormShow(Sender: TObject);
var
   I, K : Integer;
   VisibleFlag : boolean;
begin
  inherited;
   VisibleFlag := False;
   if gf_CanUseTrCode(Self.Tag) then
      VisibleFlag := True;

   for I := 0 to ComponentCount -1 do
   begin
      if (Components[I] is TPopupMenu) then  // Popup Menu 처리
      begin
         for K := 0 to (Components[I] as TPopupMenu).Items.Count -1 do
         begin
            (Components[I] as TPopupMenu).Items[K].Visible := VisibleFlag;
         end;  // end of for K
      end;  // end of if PopupMenu
   end;  // end of for I

   gvSendUseYN := gf_GetSystemOptionValue('S10','Y'); //송수신화면에서 전송 사용여부 Default Y
   if gvSendUseYN = 'N' then
   begin
      DRPanel_SndFaxTlxTitleDblClick(nil);
      DRLabel_SndMailClick(nil);
   end;
end;

procedure TForm_SCF_SND.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = VK_F8) then
  begin
    if (ActiveControl is TDRStringGrid) then //ActiveControl을 가져올 수 없음.
    begin
       ChildFormGridExport(TDRStringGrid(ActiveControl));
    end;
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
end;

procedure TForm_SCF_SND.TopBtnClick(sCaption:string);
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

procedure TForm_SCF_SND.ChildFormGridExport(DRGrid1:TDRStringGrid);
var
  XL, XLBook, XLSheet: Variant;  // Excel관련 변수
  iRow, iCol             : integer;
  sFileName, sDirFilePath   : String;
  EnvSetupInfo : TIniFile;   // Ini File
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
//  XLBook.WorkSheets[1].Name := DRPanel_Title.Caption;
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

    //XL.ActiveWorkBook.SaveAs(sFileName , xlExcel9795);
    gf_ExcelSaveAs(XL,sFileName);

  end; //with

  if not VarIsEmpty(XL) then
  begin
    if not VarIsEmpty(XL.ActiveWorkBook) then
        XL.ActiveWorkBook.Close;
//     XL.Quit;
  end;

  XLSheet  := UnAssigned;
  XLBook   := UnAssigned;
  XL       := UnAssigned;

  EnvSetupInfo.WriteString('GridExport', 'Dir', sDirFilePath);
  EnvSetupInfo.Free;
  EnableForm;
  gf_ShowMessage(MessageBar, mtInformation, 0, '저장완료-' + sFileName);

end;
end.
