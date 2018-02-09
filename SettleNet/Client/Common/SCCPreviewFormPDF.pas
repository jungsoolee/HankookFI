//==============================================================================
//   [KJY] 2001/06/27
//==============================================================================
unit SCCPreviewFormPDF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Buttons, Menus, StdCtrls, DRStandard, DRAdditional,
  DRDialogs, ToolWin, ComCtrls, AppEvnts, OleCtrls, DynamicPDFViewer_TLB,
  DB, ADODB;

type
  TRepForm_PreviewPDF = class(TForm)
    SpeedPanel: TDRPanel;
    BtnShowLast: TDRSpeedButton;
    BtnShowPreview: TDRSpeedButton;
    BtnShowNext: TDRSpeedButton;
    BtnShowFirst: TDRSpeedButton;
    BtnPrintNow: TDRSpeedButton;
    BtnExport: TDRSpeedButton;
    BtnExit: TDRSpeedButton;
    ComboBox_Percent: TDRComboBox;
    Total: TDRLabel;
    DREdit_CurPage: TDREdit;
    DRLabel1: TDRLabel;
    DRLabel2: TDRLabel;
    DRLabel3: TDRLabel;
    DynamicPDFViewer: TDynamicPDFViewer;
    DRSaveDialog1: TDRSaveDialog;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure BtnShowFirstClick(Sender: TObject);
    procedure BtnShowPreviewClick(Sender: TObject);
    procedure BtnShowNextClick(Sender: TObject);
    procedure BtnShowLastClick(Sender: TObject);
    procedure BtnPrintNowClick(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox_PercentClick(Sender: TObject);
    procedure ComboBox_PercentKeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox_PercentKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DynamicPDFViewerZoomChange(Sender: TObject);
    procedure DynamicPDFViewerPageChange(Sender: TObject);
    procedure DynamicPDFViewerRButtonClick(ASender: TObject; hWnd, ClientX,
      ClientY: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure DynamicPDFViewerContextMenuIndex(ASender: TObject;
      nIndex: Smallint);
  private
    { Private declarations }
    F_Creating : boolean;

    procedure EventHooking(var Msg: TMsg; var Handled: Boolean);
  public
    TmpPDFFileName : string;
  end;

var
  RepForm_PreviewPDF: TRepForm_PreviewPDF;

implementation

{$R *.DFM}

uses SCCLib, SCCDataModule, SCCGlobalType, Printers;


//------------------------------------------------------------------------------
// FormCreate
//------------------------------------------------------------------------------
procedure TRepForm_PreviewPDF.FormCreate(Sender: TObject);
begin
   //Application.OnMessage := EventHooking;

   gf_DisableMainMenu;
   F_Creating := true;

  // DynamicPDF Viewer License
  DynamicPDFViewer.AddLicense('VWR20X1DAHOLEEfCKV3IylOvuua8JEA9Z+sJ2XLtyMbI12JwirkR8XACBQk6uqVkff1wSHU1VEZLEmPra7Mh2YJ6DHjvAKcHIpgg');
end;

//------------------------------------------------------------------------------
// FormShow
//------------------------------------------------------------------------------
procedure TRepForm_PreviewPDF.FormShow(Sender: TObject);
var s : string;
begin
  Screen.Cursor := crHourGlass;

  with DynamicPDFViewer do
  begin
    Parent := Self;//RepForm_Preview; //RepForm_PreviewPDF.DRPanel1;
    Align := alClient;

    ShowStatusBar(False);
    ShowTitleBar(False);
    ShowToolBar(False);

    // 마우스 우 클릭 메뉴 생성.
    SetContextMenuString('Go Next,Go Back,SelectSize,FullSize,FitWidth,FullPage');

    // PDF 파일 불러오기.
    if (Trim(TmpPDFFileName) <> '') then
      if not OpenFile(TmpPDFFileName, '') then
      begin
        Close;
        Exit;
      end;

    Total.Caption := ' ' + inttostr(PageCount);
    DREdit_CurPage.Text := '1';
  end;

  // 보기 배율 콤보박스 항목 추가.
  ComboBox_Percent.Items.Add('400');
  ComboBox_Percent.Items.Add('300');
  ComboBox_Percent.Items.Add('200');
  ComboBox_Percent.Items.Add('150');
  ComboBox_Percent.Items.Add('100');
  ComboBox_Percent.Items.Add(' 80');
  ComboBox_Percent.Items.Add(' 75');
  ComboBox_Percent.Items.Add(' 50');
  ComboBox_Percent.Items.Add(' 25');

  F_Creating := false;

  s := IntToStr(gvPreviewPercent);

  if Length(s) = 2 then s := ' ' + s;

  if ComboBox_Percent.Items.IndexOf(s) < 0 then
    ComboBox_Percent.ItemIndex := ComboBox_Percent.Items.IndexOf('100')
  else
    ComboBox_Percent.ItemIndex := ComboBox_Percent.Items.IndexOf(s);

  ComboBox_PercentClick(ComboBox_Percent);

  Screen.Cursor := crDefault;
end;

//------------------------------------------------------------------------------
// FormClose
//------------------------------------------------------------------------------
procedure TRepForm_PreviewPDF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if ComboBox_Percent.Items.IndexOf(ComboBox_Percent.Text) < 0 then
   begin
     gf_WriteFormIntInfo(gvRoleCode + gcCommonSection, 'Preview Percent',
                              100);
     gf_RefreshGlobalVar(gcGLOB_GCPREVIEW_PERCENT,100);
   end
   else
   begin
     gf_WriteFormIntInfo(gvRoleCode + gcCommonSection, 'Preview Percent',
                              StrToInt(ComboBox_Percent.Text));
     //Refresh
     gf_RefreshGlobalVar(gcGLOB_GCPREVIEW_PERCENT,StrToInt(ComboBox_Percent.Text));
   end;

   DynamicPDFViewer.CloseFile;
   DynamicPDFViewer.Free;
   DynamicPDFViewer := nil;

   DeleteFile(TmpPDFFileName);

   if RepForm_PreviewPDF.Visible then
     RepForm_PreviewPDF.SetFocus;

   Action := caFree;
   RepForm_PreviewPDF := nil;

   //Application.OnMessage := nil;

   gf_EnableMainMenu;
end;

//------------------------------------------------------------------------------
// FormResize
//------------------------------------------------------------------------------
procedure TRepForm_PreviewPDF.FormResize(Sender: TObject);
var
   MyWindow : hWnd;
begin
  if F_Creating then Exit;

  MyWindow := DynamicPDFViewer.Handle;

  SetWindowPos(MyWindow, HWND_TOP, 0, SpeedPanel.Height, Self.ClientWidth-1,
  Self.ClientHeight-Self.SpeedPanel.Height, SWP_NOACTIVATE or SWP_NOOWNERZORDER); //SWP_NOZORDER, SWP_NOMOVE
end;

//------------------------------------------------------------------------------
// 처음 페이지로 이동
//------------------------------------------------------------------------------
procedure TRepForm_PreviewPDF.BtnShowFirstClick(Sender: TObject);
begin
  DynamicPDFViewer.GoToPage(1-1);
  DREdit_CurPage.Text := IntToStr(1);
end;

//------------------------------------------------------------------------------
// 이전 페이지로 이동
//------------------------------------------------------------------------------
procedure TRepForm_PreviewPDF.BtnShowPreviewClick(Sender: TObject);
var
  Textpage : integer;
begin
  TextPage := StrToint(Trim(DREdit_CurPage.Text));

  if (Trim(DREdit_CurPage.Text)) <> '1'  then
  begin
    DynamicPDFViewer.GoToPage(Textpage-1-1);
    DREdit_CurPage.Text := intTostr(TextPage - 1);
  end;
end;

//------------------------------------------------------------------------------
// 다음 페이지로 이동
//------------------------------------------------------------------------------
procedure TRepForm_PreviewPDF.BtnShowNextClick(Sender: TObject);
var
   Textpage : integer;
begin
   TextPage := StrToint(Trim(DREdit_CurPage.Text));

   if (Trim(DREdit_CurPage.Text)) <> (Trim(Total.caption))  then
   begin
      DynamicPDFViewer.GoToPage(Textpage+1-1);
      DREdit_CurPage.Text := intTostr(TextPage + 1);
   end;

end;

//------------------------------------------------------------------------------
// 마지막 페이지로 이동
//------------------------------------------------------------------------------
procedure TRepForm_PreviewPDF.BtnShowLastClick(Sender: TObject);
begin
  DynamicPDFViewer.GoToPage(DynamicPDFViewer.PageCount-1);
  DREdit_CurPage.Text := (Trim(Total.caption));
end;

//------------------------------------------------------------------------------
// 인쇄 버튼 클릭 이벤트
//------------------------------------------------------------------------------
procedure TRepForm_PreviewPDF.BtnPrintNowClick(Sender: TObject);
const
  PAGE_SCALE_FIT_TO_PAPER = 0; // Fit to Paper
  PAGE_SCALE_ACTUAL_SIZE  = 1; // Actual Size
var
  iPageHeight, iPageWidth : Single;
begin
  with DynamicPDFViewer do
  begin
    if gvDefaultPrinterUseYN <> 'Y' then
    begin
      Printer.printerName := gvPrinter.PrinterName;
    end;

    //iPageHeight := GetPageHeight(0); // 페이지 높이
    //iPageWidth  := GetPageWidth(0);  // 페이지 너비

    Printer.AutoRotate := True; // 페이지 방향 자동 설정.
    //if (iPageHeight >= iPageWidth) then
    if gvFaxReportDirection = '1' then
      Printer.AutoCenter := False // 세로방향
    else
      Printer.AutoCenter := True; // 가로방향
    // Page Scaling
    // 0 : Fit to Paper
    // 1 : Actual Size
    // 2 ~ : 배율 지정(%)
    Printer.Scaling := PAGE_SCALE_FIT_TO_PAPER;
    PrintWithDialog;
  end;
end;

//------------------------------------------------------------------------------
// Export 버튼 클릭 이벤트
//------------------------------------------------------------------------------
procedure TRepForm_PreviewPDF.BtnExportClick(Sender: TObject);
const
  FILE_EXT_PDF = '.pdf';
var
  sFileName, sFileExt : string;
begin
  with DRSaveDialog1 do
  begin
    InitialDir := gvDirExport; // 기본 Export 경로
    sFileName := ExtractFileName(ChangeFileExt(DynamicPDFViewer.FilePath, '.pdf'));
    FileName   := sFileName; // 파일명 설정.
    if Execute then
    begin
      // 확장자 체크.
      sFileExt := ExtractFileExt(FileName);
      if (Trim(sFileExt) = '') then
      begin
        // 파일 형식에 따른 처리.
        if (FilterIndex = 1) then
          FileName := Trim(FileName) + FILE_EXT_PDF;
      end;
      
      // 다른이름으로 저장.
      DynamicPDFViewer.SaveAs(FileName);
    end;
  end; // with DRSaveDialog1 do
end;

//------------------------------------------------------------------------------
// 종료 버튼 클릭 이벤트
//------------------------------------------------------------------------------
procedure TRepForm_PreviewPDF.BtnExitClick(Sender: TObject);
begin
   Close;
end;

procedure TRepForm_PreviewPDF.ComboBox_PercentClick(Sender: TObject);
var
   TempIn : Boolean;
   InValue: Integer;
   TmpStr : string;
begin
   TmpStr := Copy(ComboBox_Percent.Items[ComboBox_Percent.ItemIndex],1,3);
//   if TmpStr = '' then TmpStr := ComboBox_Percent.Text;
   Invalue := strToInt(TmpStr);
   TempIn := True;

   while TempIn = True do
   begin
       If (InValue >= 25) and (InValue <= 400) then
       begin
          DynamicPDFViewer.ZoomLevel := (InValue);
          TempIn := False;
       end;
   end;
   //RepForm_PreviewPDF.SetFocus;
//   DynamicPDFViewer.SetFocus;
end;


procedure TRepForm_PreviewPDF.ComboBox_PercentKeyPress(Sender: TObject;
  var Key: Char);
var
   inValue : string;
begin
   inValue := Trim(ComboBox_Percent.Text);

   if (Key = #13) then
   begin
       if Invalue = '' then
       begin
          gf_ShowErrDlgMessage(0,8009,'',0);
          ComboBox_Percent.SetFocus;
       end
       else If (strToInt(InValue) >= 25) and (strToInt(InValue) <= 400) then
       begin
          DynamicPDFViewer.ZoomLevel := (strToInt(InValue));
          ComboBox_Percent.Text  := inValue;
//          DynamicPDFViewer.SetFocus;
       end
       else
       begin
          gf_ShowErrDlgMessage(0,8009,'',0);
//          MessageDlg('Input a Zoom Level (25..400)!!', mtError, [mbOK], 0);
//          DynamicPDFViewer.SetFocus;
       end;
   end;
end;  

procedure TRepForm_PreviewPDF.ComboBox_PercentKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //Delete키를 막았다.
  if Key = 46 then Key := 0;
end;

//------------------------------------------------------------------------------
// DynamicPDFViewerZoomChange
//------------------------------------------------------------------------------
procedure TRepForm_PreviewPDF.DynamicPDFViewerZoomChange(Sender: TObject);
begin
  ComboBox_Percent.Text := IntToStr(DynamicPDFViewer.ZoomLevel);
end;

//------------------------------------------------------------------------------
// DynamicPDFViewerPageChange
//------------------------------------------------------------------------------
procedure TRepForm_PreviewPDF.DynamicPDFViewerPageChange(Sender: TObject);
begin
  DREdit_CurPage.Text := IntToStr(DynamicPDFViewer.CurPage+1);
end;

//------------------------------------------------------------------------------
// DynamicPDFViewerRButtonClick
//------------------------------------------------------------------------------
procedure TRepForm_PreviewPDF.DynamicPDFViewerRButtonClick(
  ASender: TObject; hWnd, ClientX, ClientY: Integer);
var
  ScreenP: TPoint;
begin
  //GetCursorPos(ScreenP);
  //PopupMenu1.Popup(ScreenP.X, ScreenP.Y);
end;

//------------------------------------------------------------------------------
// FormMouseWheel
//------------------------------------------------------------------------------
procedure TRepForm_PreviewPDF.FormMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  //DynamicPDFViewer.SetFocus;
end;

//------------------------------------------------------------------------------
// EventHooking
//------------------------------------------------------------------------------
procedure TRepForm_PreviewPDF.EventHooking(var Msg: TMsg;
  var Handled: Boolean);
begin
  // 마우스 우 클릭 이벤트 강제 종료.
  if (Msg.message = WM_RBUTTONUP) then
  begin
    Handled := true;
    Exit;
  end;
end;

procedure TRepForm_PreviewPDF.DynamicPDFViewerContextMenuIndex(
  ASender: TObject; nIndex: Smallint);
const
  IDX_POP_UP_GO_NEXT     = 1;
  IDX_POP_UP_GO_BACK     = 2;
  IDX_POP_UP_SELECT_SIZE = 3;
  IDX_POP_UP_FULL_SIZE   = 4;
  IDX_POP_UP_FIT_WIDTH   = 5;
  IDX_POP_UP_FULL_PAGE   = 6;
var
   Textpage : integer;
   TempIn : Boolean;
   InValue: string;   
begin
  TextPage := StrToint(Trim(DREdit_CurPage.Text)); // 현재 페이지

  case nIndex of
    IDX_POP_UP_GO_NEXT :     // 다음 페이지로 이동.
      begin
        if (Trim(DREdit_CurPage.Text)) <> (Trim(Total.caption))  then
        begin
           DynamicPDFViewer.GoToPage(Textpage+1-1);
           DREdit_CurPage.Text := intTostr(TextPage + 1);
        end;
      end;
    IDX_POP_UP_GO_BACK :     // 이전 페이지로 이동.
      begin
        if (Trim(DREdit_CurPage.Text)) <> '1'  then
        begin
          DynamicPDFViewer.GoToPage(Textpage-1-1);
          DREdit_CurPage.Text := intTostr(TextPage - 1);
        end;
      end;
    IDX_POP_UP_SELECT_SIZE : // 보기 배율: 입력 창 열기.
      begin
        InValue := '75';
        TempIn := True;
        while TempIn = True do
        begin
          If InputQuery('SettleNet', 'Input a Zoom Level (25..400)', InValue) then
          begin
            If (StrToInt(InValue) >= 25) and (StrToInt(InValue) <= 400) then
            begin
               DynamicPDFViewer.ZoomLevel := StrToInt(InValue);
               ComboBox_Percent.Text  := inValue;
               TempIn := False;
            end
            else
               gf_ShowErrDlgMessage(0,8009,'',0);
          end
          else
            TempIn := False;
          ComboBox_Percent.Text  := InValue;
        end;
      end;
    IDX_POP_UP_FULL_SIZE :   // 보기 배율: 100%
      begin
        DynamicPDFViewer.ZoomLevel := 100;
      end;
    IDX_POP_UP_FIT_WIDTH :   // 보기 배율: 너비 맞춤
      begin
        DynamicPDFViewer.ZoomLevel := 2;
      end;
    IDX_POP_UP_FULL_PAGE :   // 보기 배율: 높이 맞춤
      begin
        DynamicPDFViewer.ZoomLevel := 1;
      end;
  end

end;

end.



