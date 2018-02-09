//==============================================================================
//   [KJY] 2001/06/27
//==============================================================================
unit SCCPreviewForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UCrpe32, ExtCtrls, Buttons, Menus, StdCtrls, DRStandard, DRAdditional,
  DRDialogs, ToolWin, ComCtrls, UCrpeClasses, AppEvnts;

type
  TRepForm_Preview = class(TForm)
    SpeedPanel: TDRPanel;
    BtnShowLast: TDRSpeedButton;
    BtnShowPreview: TDRSpeedButton;
    BtnShowNext: TDRSpeedButton;
    BtnShowFirst: TDRSpeedButton;
    BtnPrintNow: TDRSpeedButton;
    BtnExport: TDRSpeedButton;
    BtnExit: TDRSpeedButton;
    ComboBox_Percent: TDRComboBox;
    PopupMenu1: TDRPopupMenu;
    SelectSiZe1: TMenuItem;
    N1: TMenuItem;
    FullSize1: TMenuItem;
    FitPage1: TMenuItem;
    FullPage1: TMenuItem;
    N2: TMenuItem;
    Next1: TMenuItem;
    GoBack1: TMenuItem;
    Total: TDRLabel;
    DREdit_CurPage: TDREdit;
    DRLabel1: TDRLabel;
    DRLabel2: TDRLabel;
    DRLabel3: TDRLabel;
    ApplicationEvents1: TApplicationEvents;
    Timer1: TTimer;
    Crpe_Temp: TCrpe;
    DRPanel1: TDRPanel;
    procedure DRButton1Click(Sender: TObject);
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
    procedure BtnFullSizeClick(Sender: TObject);
    procedure FullSize1Click(Sender: TObject);
    procedure FitPage1Click(Sender: TObject);
    procedure FullPage1Click(Sender: TObject);
    procedure SelectSiZe1Click(Sender: TObject);
    procedure Next1Click(Sender: TObject);
    procedure GoBack1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox_PercentClick(Sender: TObject);
    procedure ComboBox_PercentKeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox_PercentKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    F_Creating: boolean;
    procedure OnRcvAfterFormShow(var msg: TMessage); message WM_USER + 101;
  public
    TmpRptFileName: string;
  end;

var
  RepForm_Preview: TRepForm_Preview;

implementation

{$R *.DFM}

uses SCCLib, SCCDataModule, SCCGlobalType, Printers;

procedure TRepForm_Preview.FormShow(Sender: TObject);
var s: string;
begin
  Screen.Cursor := crHourGlass;

  with Datamodule_Settlenet.Crpe1 do
  begin
    WindowParent := Self; //RepForm_Preview; //RepForm_Preview.DRPanel1;
    WindowSize.Top := Self.SpeedPanel.Height;
    WindowSize.Left := 1;

    WindowState := wsMaximized;
    WindowStyle.SystemMenu := False;
    WindowStyle.BorderStyle := bsNone;
    WindowButtonBar.Visible := False;

 // 위치를 조절한다.
//     SetWindowPos(MyWindow, HWND_TOP, 0, 0, DRPanel1.Width, DRPanel1.Height, SWP_NOACTIVATE or SWP_NOOWNERZORDER);

    ComboBox_Percent.Items.Add('400');
    ComboBox_Percent.Items.Add('300');
    ComboBox_Percent.Items.Add('200');
    ComboBox_Percent.Items.Add('150');
    ComboBox_Percent.Items.Add('100');
    ComboBox_Percent.Items.Add(' 80');
    ComboBox_Percent.Items.Add(' 75');
    ComboBox_Percent.Items.Add(' 50');
    ComboBox_Percent.Items.Add(' 25');

  end;

  F_Creating := false;
   //ComboBox_Percent.Text  := IntToStr(gvPreviewPercent);
//   ComboBox_Percent.ItemIndex := ComboBox_Percent.Items.IndexOf(IntToStr(gvPreviewPercent));

  s := IntToStr(gvPreviewPercent);

  if Length(s) = 2 then s := ' ' + s;

  if ComboBox_Percent.Items.IndexOf(s) < 0 then
    ComboBox_Percent.ItemIndex := ComboBox_Percent.Items.IndexOf('100')
  else
    ComboBox_Percent.ItemIndex := ComboBox_Percent.Items.IndexOf(s);

  ComboBox_PercentClick(ComboBox_Percent);


   //Datamodule_Settlenet.Crpe1.WindowZoom.Magnification := 100;

//  InvalidateRect(0, nil, false);
  Timer1.Enabled := true;

  Screen.Cursor := crDefault;
end;

procedure TRepForm_Preview.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  if ComboBox_Percent.Items.IndexOf(ComboBox_Percent.Text) < 0 then
  begin
    gf_WriteFormIntInfo(gvRoleCode + gcCommonSection, 'Preview Percent',
      100);
    gf_RefreshGlobalVar(gcGLOB_GCPREVIEW_PERCENT, 100);
  end
  else
  begin
    gf_WriteFormIntInfo(gvRoleCode + gcCommonSection, 'Preview Percent',
      StrToInt(ComboBox_Percent.Text));
     //Refresh
    gf_RefreshGlobalVar(gcGLOB_GCPREVIEW_PERCENT, StrToInt(ComboBox_Percent.Text));
  end;

  Datamodule_Settlenet.crpe1.CloseJob;
  if not (gvDirRptUseYN = 'Y') then DeleteFile(TmpRptFileName);
  Action := caFree;
  RepForm_Preview := nil;
  gf_EnableMainMenu;
end;

procedure TRepForm_Preview.FormResize(Sender: TObject);
var
  MyWindow: hWnd;
begin
  if F_Creating then Exit;

  MyWindow := Datamodule_Settlenet.Crpe1.ReportWindowHandle;

//     Datamodule_Settlenet.Crpe1.WindowSize.Top := SpeedPanel.Height;//DRPanel1.Top;//
//     WindowSize.Top := DRPanel1.Top;
//     Datamodule_Settlenet.Crpe1.WindowSize.Left := 1;
//     Datamodule_Settlenet.Crpe1.WindowSize.Width := Self.ClientWidth; //
//     Datamodule_Settlenet.Crpe1.WindowSize.Height := Self.ClientHeight-Self.SpeedPanel.Height;//
//     Datamodule_Settlenet.Crpe1.WindowStyle.


//     Datamodule_Settlenet.Crpe1.WindowState := wsMaximized;

  SetWindowPos(MyWindow, HWND_TOP, 0, SpeedPanel.Height, Self.ClientWidth - 1,
    Self.ClientHeight - Self.SpeedPanel.Height, SWP_NOACTIVATE or SWP_NOOWNERZORDER); //SWP_NOZORDER, SWP_NOMOVE

end;

procedure TRepForm_Preview.BtnShowFirstClick(Sender: TObject);
begin
  Datamodule_Settlenet.Crpe1.Pages.First;
  DREdit_CurPage.Text := '1';
end;

procedure TRepForm_Preview.BtnShowPreviewClick(Sender: TObject);
var
  Textpage: integer;
begin
  TextPage := StrToint(Trim(DREdit_CurPage.Text));

  if (Trim(DREdit_CurPage.Text)) <> '1' then
  begin
    Datamodule_Settlenet.Crpe1.Pages.Previous;
    DREdit_CurPage.Text := intTostr(TextPage - 1);
  end;
end;

procedure TRepForm_Preview.BtnShowNextClick(Sender: TObject);
var
  Textpage: integer;
begin
  TextPage := StrToint(Trim(DREdit_CurPage.Text));

  if (Trim(DREdit_CurPage.Text)) <> (Trim(Total.caption)) then
  begin
    Datamodule_Settlenet.Crpe1.Pages.Next;
    DREdit_CurPage.Text := intTostr(TextPage + 1);
  end;

end;

procedure TRepForm_Preview.BtnShowLastClick(Sender: TObject);
begin
  Datamodule_Settlenet.Crpe1.Pages.Last;
  DREdit_CurPage.Text := (Trim(Total.caption));
end;

procedure TRepForm_Preview.BtnPrintNowClick(Sender: TObject);
  function Uf_MytmpRpt: string;
  var
    dTime: TDateTime;
  begin
     // 리포트 이름이 같을때 SettleNet 두개 뛰우면 문제 가 있어서 Const에서 변경함
    dTime := Now;
    Result := 'MytmpRpt' + FormatDateTime('YYMMDDhhmmss', dTime) + '.rpt';
  end;
var

  TmpRptFileName : String;
begin
  Try
    // 프린터를 변환할 파일 생성
    TmpRptFileName := gvDirTemp + Uf_MytmpRpt;
    with Datamodule_Settlenet.Crpe1 do
    begin
      ProgressDialog := False;
      Output :=  toExport;
      ExportOptions.Destination := toFile;
      ExportOptions.FileType := CrystalReportRPT; //RPT
      // Temp Img
      ExportOptions.FileName := TmpRptFileName;
      Execute;
    end;

    Crpe_Temp.ReportName := TmpRptFileName;
    //with Datamodule_Settlenet.Crpe1 do
    with Crpe_Temp do
    begin
      //대우만 FinePrint로 Set
      // 대우사용 안하고 실제 적용 되지 않으므로 제외 시킴
      // [Y.S.M]
      //gf_finePrint('SCCPreviewForm [BtnPrintNowClick]>>');
      Printer.Clear;
      if gvDefaultPrinterUseYN <> 'Y' then
      begin
        Printer.PreserveRptSettings := [prOrientation];
        Printers.Printer.PrinterIndex := Printers.Printer.Printers.IndexOf(gvPrinter.PrinterName);
        Printer.GetCurrent(False);
        Printer.Name := gvPrinter.PrinterName;
      end;
      //Crpe_Temp windowParent를 보이지 않는 판넬로 지정함
      // Execute를 해야지만.. 프린터가 변경됨.. 꼼수처리
      ProgressDialog := false;
      Output := toWindow;
      Execute;
      if PrintOptions.Prompt then PrintWindow;
    end;
  finally
    Crpe_Temp.CloseJob;
    DeleteFile(TmpRptFileName);
  end;
end;

procedure TRepForm_Preview.BtnExportClick(Sender: TObject);
begin
  Datamodule_Settlenet.Crpe1.ExportWindow(False);
end;

procedure TRepForm_Preview.BtnExitClick(Sender: TObject);
begin
  Datamodule_Settlenet.Crpe1.CloseWindow;
  Close;
end;

procedure TRepForm_Preview.BtnFullSizeClick(Sender: TObject);
begin
  Datamodule_Settlenet.Crpe1.WindowZoom.Preview := pwNormal;
end;

procedure TRepForm_Preview.FullSize1Click(Sender: TObject);
begin
  FitPage1.Checked := false;
  FullPage1.Checked := false;
  Datamodule_Settlenet.Crpe1.WindowZoom.Preview := pwNormal;
  FullSize1.Checked := true;
end;

procedure TRepForm_Preview.FitPage1Click(Sender: TObject);
begin
  FullPage1.Checked := false;
  FullSize1.Checked := false;
  Datamodule_Settlenet.Crpe1.WindowZoom.Preview := pwPageWidth;
  FitPage1.Checked := true;
end;

procedure TRepForm_Preview.FullPage1Click(Sender: TObject);
begin
  FullSize1.Checked := false;
  FitPage1.Checked := false;
  DataModule_Settlenet.Crpe1.WindowZoom.Preview := pwWholePage;
  FullPage1.Checked := true;
end;

procedure TRepForm_Preview.SelectSiZe1Click(Sender: TObject);
var
  TempIn: Boolean;
  InValue: string;
begin
  InValue := '75';
  TempIn := True;
  while TempIn = True do
  begin
    if InputQuery('SettleNet', 'Input a Zoom Level (25..400)', InValue) then
    begin
      if (StrToInt(InValue) >= 25) and (StrToInt(InValue) <= 400) then
      begin
        Datamodule_Settlenet.Crpe1.WindowZoom.Magnification := StrToInt(InValue);
        ComboBox_Percent.Text := inValue;
        TempIn := False;
      end
      else
        gf_ShowErrDlgMessage(0, 8009, '', 0);
//          MessageDlg('Input a Zoom Level (25..400)!!', mtError, [mbOK], 0);
    end
    else
      TempIn := False;
    ComboBox_Percent.Text := inValue;
  end;
end;


procedure TRepForm_Preview.Next1Click(Sender: TObject);
var
  Textpage: integer;
begin
  TextPage := StrToint(Trim(DREdit_CurPage.Text));

  if (Trim(DREdit_CurPage.Text)) <> (Trim(Total.caption)) then
  begin
    GoBack1.Checked := false;
    Datamodule_Settlenet.Crpe1.Pages.Next;
    DREdit_CurPage.Text := intTostr(TextPage + 1);
  end;
  Next1.Checked := true;
end;

procedure TRepForm_Preview.GoBack1Click(Sender: TObject);
var
  Textpage: integer;
begin
  TextPage := StrToint(Trim(DREdit_CurPage.Text));

  if (Trim(DREdit_CurPage.Text)) <> '1' then
  begin
    Next1.Checked := false;
    Datamodule_Settlenet.Crpe1.Pages.Previous;
    DREdit_CurPage.Text := intTostr(TextPage - 1);
  end;
  GoBack1.Checked := true;
end;

procedure TRepForm_Preview.FormCreate(Sender: TObject);
begin

  gf_DisableMainMenu;
  F_Creating := true;
end;



procedure TRepForm_Preview.ComboBox_PercentClick(Sender: TObject);
var
  TempIn: Boolean;
  InValue: Integer;
  TmpStr: string;
begin
  TmpStr := Copy(ComboBox_Percent.Items[ComboBox_Percent.ItemIndex], 1, 3);
//   if TmpStr = '' then TmpStr := ComboBox_Percent.Text;
  Invalue := strToInt(TmpStr);
  TempIn := True;

  while TempIn = True do
  begin
    if (InValue >= 25) and (InValue <= 400) then
    begin
      Datamodule_Settlenet.Crpe1.WindowZoom.Magnification := (InValue);
      TempIn := False;
    end;
  end;
  RepForm_Preview.SetFocus;
end;


procedure TRepForm_Preview.ComboBox_PercentKeyPress(Sender: TObject;
  var Key: Char);
var
  inValue: string;
begin
  inValue := Trim(ComboBox_Percent.Text);

  if (Key = #13) then
  begin
    if Invalue = '' then
    begin
      gf_ShowErrDlgMessage(0, 8009, '', 0);
      ComboBox_Percent.SetFocus;
    end
    else if (strToInt(InValue) >= 25) and (strToInt(InValue) <= 400) then
    begin
      Datamodule_Settlenet.Crpe1.WindowZoom.Magnification := (strToInt(InValue));
      ComboBox_Percent.Text := inValue;
      RepForm_Preview.SetFocus;
    end
    else
    begin
      gf_ShowErrDlgMessage(0, 8009, '', 0);
//          MessageDlg('Input a Zoom Level (25..400)!!', mtError, [mbOK], 0);
      ComboBox_Percent.SetFocus;
    end;
  end;
end;


procedure TRepForm_Preview.ComboBox_PercentKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //Delete키를 막았다.
  if Key = 46 then Key := 0;
end;

procedure TRepForm_Preview.FormKeyPress(Sender: TObject; var Key: Char);
begin
//  if Key = 46 then Key := 0;

end;


procedure TRepForm_Preview.DRButton1Click(Sender: TObject);
var
  aHandle: THandle;
  Buffer: array[0..255] of Char;
begin
//ComboBox_PercentClick(nil);
//aHandle := Datamodule_Settlenet.Crpe1.ReportWindowHandle;
//SendMessage(aHandle, WM_PAINT, 0, 0); //

//InvalidateRect(aHandle, nil,TRUE);

//  aHandle := FindWindowEx(aHandle, 0, 'AfxFrameOrView42su', 0);
  InvalidateRect(0, nil, false);
//    InvalidateRect(aHandle, nil, true);





//  FitPage1.Checked := false;
//  FullPage1.Checked := false;
//  Datamodule_Settlenet.Crpe1.WindowZoom.Preview := pwNormal;
//  FullSize1.Checked := true;

//Datamodule_Settlenet.Crpe1.Pages.Last;
//Datamodule_Settlenet.Crpe1.Pages.First;
{
BtnShowLastClick(nil);
Sleep(1000);
BtnShowFirstClick(nil);
BtnShowFirstClick(nil);
BtnShowFirstClick(nil);
BtnShowFirstClick(nil);
}
//  Self.Update;
//  Self.Repaint;
//  Self.Update;
//  Self.Refresh;
////Datamodule_Settlenet.Crpe1.Refresh;
//Datamodule_Settlenet.Crpe1.WindowZoom.Magnification := Datamodule_Settlenet.Crpe1.WindowZoom.Magnification;
//Datamodule_Settlenet.Crpe1.WindowZoom := Datamodule_Settlenet.Crpe1.WindowZoom +1;
end;

procedure TRepForm_Preview.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
var
  aHandle: THandle;
// aPoint : TPoint;
begin

  if (Msg.message = WM_MouseWheel) then
  begin
//     GetCursorPos(aPoint);
//     ScreenToClient(aPoint);
//     aHandle := ChildWindowFromPoint(Self.Handle, aPoint);
    aHandle := Datamodule_Settlenet.Crpe1.ReportWindowHandle;
    if Msg.wParam > 0 then
    begin
      SendMessage(aHandle, WM_VSCROLL, SB_PAGEUP, 0); //
    end
    else
    begin
      SendMessage(aHandle, WM_VSCROLL, SB_PAGEDOWN, 0);
    end;
    Msg.wParam := 0; //scroll시 송수신 Grid가 scroll되는 희한한 현상이 발생되어 이를 막기 위함.
  end;
end;

procedure TRepForm_Preview.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
//  InvalidateRect(0, nil, false);
//  PostMessage(Self.Handle, WM_USER + 101, 0, 0);
  Datamodule_Settlenet.Crpe1.WindowZoom.Magnification := Datamodule_Settlenet.Crpe1.WindowZoom.Magnification;
  Screen.Cursor := crDefault;
end;

procedure TRepForm_Preview.OnRcvAfterFormShow(var msg: TMessage);
begin
//  Sleep(1000);
//  InvalidateRect(0, nil, false);
end;

end.

