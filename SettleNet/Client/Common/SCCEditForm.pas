//==============================================================================
//   [LMS] 2000/12/20
// P.H.S 2006.08.25   OpenReadFile(pFreqNo(회차) default='') 추가
//                    FreqNo : String; 변수 추가
//==============================================================================

unit SCCEditForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, DRAdditional, ExtCtrls, DRStandard, StdCtrls, ComCtrls, DRWin32,
  Menus, DRColorTab, DRSpecial, DRDialogs;

type
  TForm_Edit = class(TForm)
    DRPanel_Btn: TDRPanel;
    DRMainMenu_EditForm: TDRMainMenu;
    N1: TMenuItem;
    Menu_Save: TMenuItem;
    Menu_Close: TMenuItem;
    N6: TMenuItem;
    Menu_Undo: TMenuItem;
    Menu_Copy: TMenuItem;
    Menu_Cut: TMenuItem;
    Menu_Paste: TMenuItem;
    DRBitBtn_Close: TDRBitBtn;
    DRBitBtn_Print: TDRBitBtn;
    DRBitBtn_Save: TDRBitBtn;
    N3: TMenuItem;
    MessageBar: TDRMessageBar;
    DRLabel_Title: TDRLabel;
    DRPageControl_Main: TDRPageControl;
    Menu_Print: TMenuItem;
    N10: TMenuItem;
    DRPopupMenu_EditForm: TDRPopupMenu;
    Popup_DeleteTab: TMenuItem;
    DRBitBtn_Printer: TDRBitBtn;
    DRPrinterSetupDlg_Main: TDRPrinterSetupDialog;
    DRBitBtn_Export: TDRBitBtn;
    procedure ClearMemoList;
    procedure ClearPageList;
    procedure CreateMemo(var pMemo: TDRMemo; pOwner: TComponent; pParent: TWinControl);
    procedure CreateTabSheet(var pTabSheet: TDRTabSheet; pOwner: TComponent;
                                                       pParent: TDRPageControl);
    procedure DRMemo_CommonKeyDown(Sender: TObject;  var Key: Word;
                                                            Shift: TShiftState);
    procedure DRMemo_CommonKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure DRBitBtn_CloseClick(Sender: TObject);
    procedure DRBitBtn_SaveClick(Sender: TObject);
    procedure DRBitBtn_PrintClick(Sender: TObject);
    procedure Menu_SaveClick(Sender: TObject);
    procedure Menu_PrintClick(Sender: TObject);
    procedure Menu_CloseClick(Sender: TObject);
    procedure Menu_UndoClick(Sender: TObject);
    procedure Menu_CopyClick(Sender: TObject);
    procedure Menu_CutClick(Sender: TObject);
    procedure Menu_PasteClick(Sender: TObject);
    procedure Popup_DeleteTabClick(Sender: TObject);
    procedure DRPopupMenu_EditFormPopup(Sender: TObject);
    procedure DRPageControl_MainMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DRPageControl_MainMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DRBitBtn_PrinterClick(Sender: TObject);
    procedure DRBitBtn_ExportClick(Sender: TObject);
  private
    PageList       : TList;        // TDRTabSheet List
    MemoList       : TList;        // TMemo List
    SaveFileName   : string;       // Save될 File Name
    FreqNo         : string;       // 송신된 FAX화면 출력시 회차정보
    PSTabSheet     : TDRTabSheet;  // PS의 Tab Sheet
    EditPSStrList  : TStringList;  // PS의 StringList
    DeletedTab     : boolean;      // Tab이 Delete 되었는지 여부
    PrnOrientation : string;       // Print 출력 방향
  public
    function OpenEditFile(pOpenFileName, pSaveFileName, pOrientation, pExpFileNameBody: string;
                                          var pPSStrList: TStringList): boolean;
    function OpenReadFile(pOpenFileName, pOrientation, pTitle, pTxtUnitInfo, pExpFileNameBody: string; pFreqNo: String = ''): boolean;
  end;

var
  Form_Edit: TForm_Edit;
  sExpFileNameBody: string;

implementation

{$R *.DFM}

uses
   SCCLib, SCCCmuLib, SCCGlobalType, Printers;

const
   LBL_TITLE_IDX = 2;  // TextFile에서 구분 라인의 데이터 분류 Index - Title
   LBL_TAB_IDX   = 3;  // TextFile에서 구분 라인의 데이터 분류 Index - Tab

procedure TForm_Edit.FormCreate(Sender: TObject);
begin
   PageList  := TList.Create;
   MemoList  := TList.Create;
   if (not Assigned(PageList)) or (not Assigned(MemoList)) then
   begin
      gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); //List 생성 오류
      Close;
      Exit;
   end;
   PSTabSheet := nil;   // Clear
   gf_DisableMainMenu;  // Disable Menu
   DeletedTab := False; // Tab 삭제 여부 초기화
end;

procedure TForm_Edit.FormClose(Sender: TObject; var Action: TCloseAction);
var
   I : Integer;
   MemoItem : TDRMemo;
   Modified : boolean;
   RtnValue : Integer;
begin
   Modified := False;
   if Assigned(MemoList) then
   begin
      for I := 0 to MemoList.Count -1 do
      begin
         MemoItem := MemoList.Items[I];
         if (not MemoItem.ReadOnly) and (MemoItem.Modified) then
         begin
            Modified := True;
            break;
         end;  // end of if
      end;  // end of for
   end;  // end of if

   if (Modified) or (DeletedTab) then  // 수정내역 있는 경우
   begin
      //수정 사항을 저장하시겠습니까?
      RtnValue := gf_ShowDlgMessage(0, mtConfirmation, 1124, '', mbYesNoCancel, 0);
      if RtnValue = idYes then
         DRBitBtn_SaveClick(DRBitBtn_Save)  // 저장 버튼 클릭
      else if RtnValue = idCancel then
      begin
         Action := caNone;
         Exit;
      end;
   end;
   Action := caFree;
   ClearMemoList;
   ClearPageList;
   MemoList.Free;
   PageList.Free;
   gf_EnableMainMenu;  // Enable Menu
end;

//------------------------------------------------------------------------------
//  Clear MemoList
//------------------------------------------------------------------------------
procedure TForm_Edit.ClearMemoList;
var
   I : Integer;
   MemoItem : TDRMemo;
begin
   if not Assigned(MemoList) then Exit;
   for I := 0 to MemoList.Count -1 do
   begin
      MemoItem := MemoList.Items[I];
      if Assigned(MemoItem) then  MemoItem.Free;
   end;
   MemoList.Clear;
end;

//------------------------------------------------------------------------------
//  Clear PageList
//------------------------------------------------------------------------------
procedure TForm_Edit.ClearPageList;
var
   I : Integer;
   PageItem : TDRTabSheet;
begin
   if not Assigned(PageList) then Exit;
   for I := 0 to PageList.Count -1 do
   begin
      PageItem := PageList.Items[I];
      if Assigned(PageItem) then PageItem.Free;
   end;
   PageList.Clear;
end;

//------------------------------------------------------------------------------
//  종료 버튼
//------------------------------------------------------------------------------
procedure TForm_Edit.DRBitBtn_CloseClick(Sender: TObject);
begin
   Close;
end;

//------------------------------------------------------------------------------
//  저장 버튼
//------------------------------------------------------------------------------
procedure TForm_Edit.DRBitBtn_SaveClick(Sender: TObject);
var
   wTextFile : TextFile;
   PageItem : TDRTabSheet;
   MemoItem : TDRMemo;
   I, K : Integer;
   sSplitStr : string;
begin
   if Trim(SaveFileName) = '' then
   begin
      gf_ShowMessage(MessageBar, mtError, 1125, '저장 파일명 부재'); // 저장 중 오류 발생
      Exit;
   end;

   gf_ShowMessage(MessageBar, mtInformation, 1126, ''); // 저장 중입니다.

   // 파일 생성
   AssignFile(wTextFile, SaveFileName);
   {$I-}
   Rewrite(wTextFile);
   {$I+}
   if IOResult <> 0 then
   begin
      gf_ShowMessage(MessageBar, mtError, 9006, ''); //파일 생성 오류
      CloseFile(wTextFile);
      Exit;
   end;

   for I := 0 to PageList.Count -1 do
   begin
      PageItem := PageList.Items[I];
      MemoItem := MemoList.Items[I];
      MemoItem.Modified := False;
      if PageItem <> PSTabSheet then   // PS Tab이 아닌 경우
      begin
         for K := 0 to MemoItem.Lines.Count -1 do
            Writeln(wTextFile, MemoItem.Lines[K]);
         sSplitStr := gcSPLIT_CHAR + PageItem.Caption + gcSPLIT_CHAR
                      + gcSPLIT_CHAR;
{
         sSplitStr := gcSPLIT_CHAR + DRLabel_Title.Caption + gcSPLIT_CHAR
                      + PageItem.Caption + gcSPLIT_CHAR;
}
         Writeln(wTextFile, sSplitStr);
      end
      else  // PS 처리
      begin
         EditPSStrList.Clear;
         for K := 0 to MemoItem.Lines.Count -1 do
            EditPSStrList.Add(MemoItem.Lines[K]);
      end;
   end;  // end of for I

   // 존재하던 PS가 삭제되었는지 확인
   if (EditPSStrList.Count > 0) and (not Assigned(PSTabSheet)) then
      EditPSStrList.Clear;
   CloseFile(wTextFile);
   DeletedTab := False;  // Tab 삭제 여부 초기화
   gf_ShowMessage(MessageBar, mtInformation, 1127, '');  //저장되었습니다.
   //----------------------
   gvSRMgrEdited := True;
   //----------------------
end;

//------------------------------------------------------------------------------
//  인쇄 버튼
//------------------------------------------------------------------------------
procedure TForm_Edit.DRBitBtn_PrintClick(Sender: TObject);
var
   MemoItem : TDRMemo;
begin
   Screen.Cursor := crHourGlass;
   gf_ShowMessage(MessageBar, mtInformation, 1100, '');  // 인쇄 중입니다.
   MemoItem := MemoList.Items[DRPageControl_Main.ActivePage.TabIndex];
   if Assigned(MemoItem) then
   begin
      if gf_PrintMemo(MemoItem, PrnOrientation, gcRTYPE_TEXT_MAX_LINE) then
         gf_ShowMessage(MessageBar, mtInformation, 1101, '')  // 인쇄 완료
      else
         gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg);  // 오류 발생
   end
   else
      gf_ShowMessage(MessageBar, mtError, 1009, '');  // 선택 항목이 없습니다.
   Screen.Cursor := crDefault;
end;

//------------------------------------------------------------------------------
//  프린터 설정
//------------------------------------------------------------------------------
procedure TForm_Edit.DRBitBtn_PrinterClick(Sender: TObject);
begin
   if gvDefaultPrinterUseYN = 'Y' then  //2007.05.23
   begin
     gf_ShowErrDlgMessage(0,0,
     '해당 PC는 윈도우즈 기본 프린터만을 사용하도록 설정되어 있습니다.'
     + #13#10 + #13#10 + '데이터로드에 문의하시기 바랍니다.',0);
     Exit;
   end;

   if gvPrinter.PrinterName > '' then
   begin
     Printers.Printer.PrinterIndex := Printers.Printer.Printers.IndexOf(gvPrinter.PrinterName);
     Printers.Printer.Orientation := gvPrinter.Orientation;
   end;
   if DRPrinterSetupDlg_Main.Execute then
   begin
     // Printer Setup Variable
     if Printer.Printers.Count = 0 then  // 사용가능 Printer없음
     begin
        gvPrinter.PrinterIdx  := gcNonePrinter;
        gvPrinter.PrinterName := '';
        gvPrinter.Copies      := 1;
        gvPrinter.Orientation := poPortrait;
     end
     else  //사용가능 Printer있음
     begin
        gvPrinter.PrinterIdx  := Printer.PrinterIndex;
        gvPrinter.PrinterName := Printer.Printers[gvPrinter.PrinterIdx];
        gvPrinter.Copies      := Printer.Copies;
        gvPrinter.Orientation := Printer.Orientation;
     end;

     gf_WriteFormStrInfo(gcPrinterSection,gcPrinterNameKey,gvPrinter.PrinterName);
     if Printer.Orientation = poPortrait then
       gf_WriteFormStrInfo(gcPrinterSection,gcOrientationKey,'P')
     else
       gf_WriteFormStrInfo(gcPrinterSection,gcOrientationKey,'L');

  end;  // end of if
end;

//------------------------------------------------------------------------------
// Create Memo
//------------------------------------------------------------------------------
procedure TForm_Edit.CreateMemo(var pMemo: TDRMemo; pOwner: TComponent; pParent: TWinControl);
begin
   pMemo := TDRMemo.Create(pOwner);   // Memo 생성
   with pMemo do  // Assign Property
   begin
      Parent     := pParent;
      Align      := alClient;
      ImeMode    := imSAlpha;
      ScrollBars := ssBoth;
      ParentFont := True;
      Clear;
      OnKeyDown  := DRMemo_CommonKeyDown;
      OnKeyPress := DRMemo_CommonKeyPress;
   end;
end;

//------------------------------------------------------------------------------
// Create TabSheet
//------------------------------------------------------------------------------
procedure TForm_Edit.CreateTabSheet(var pTabSheet: TDRTabSheet; pOwner: TComponent;
                                                     pParent: TDRPageControl);
begin
   pTabSheet := TDRTabSheet.Create(pOwner);  // TabSheet 생성
   with pTabSheet do  // Assign Property
   begin
      Parent := pParent;
      Align  := alClient;
      Font.Name   := 'Courier';
      Font.Size   := 10;
      Font.Color  := clBlack;
      PageControl := pParent;
   end;
end;

//------------------------------------------------------------------------------
//  Open 입력 가능 File - 자료 전송
//------------------------------------------------------------------------------
function TForm_Edit.OpenEditFile(pOpenFileName, pSaveFileName,
                    pOrientation, pExpFileNameBody: string; var pPSStrList: TStringList): boolean;
var
   rTextFile : TextFile;
   sReadBuff : string;
   PageItem : TDRTabSheet;
   MemoItem : TDRMemo;
   I, iStrIdx : Integer;
   RptDataList : TStringList;
   PageAccNo : String;
begin
   //-----------------------
   gvSRMgrEdited := False;
   //-----------------------
   Result := False;

   sExpFileNameBody := pExpFileNameBody; //전역 변수 세팅, 파일명

   SaveFileName := pSaveFileName;    // Save File Name
   PrnOrientation := pOrientation;   // Printer Orientation

   if not FileExists(pOpenFileName) then
   begin
      gvErrorNo := 1027;  // 해당 파일이 존재하지 않습니다.
      gvExtMsg  := '';
      Exit;
   end;

   AssignFile(rTextFile, pOpenFileName);
   {$I-}
   Reset(rTextFile);
   {$I+}
   if IOResult <> 0 then
   begin
      gvErrorNo := 1027;  // 해당 파일이 존재하지 않습니다.
      gvExtMsg  := '';
      CloseFile(rTextFile);
      Exit;
   end;

   iStrIdx := -1;
   RptDataList := TStringList.Create;

   // PS 처리
   EditPSStrList := pPSStrList;
   if EditPSStrList.Count > 0 then
   begin
      for I := 0 to EditPSStrList.Count -1 do
      begin
         RptDataList.Add(EditPSStrList.Strings[I]);
         Inc(iStrIdx);
      end;  // end of for
      RptDataList.Add(gcSPLIT_CHAR + gcPS_MARK + gcSPLIT_CHAR + gcPS_MARK + gcSPLIT_CHAR);  // PS 표시
      Inc(iStrIdx);
   end;  // end of if

   // 공백 Line 제거 후 RptDataList에 저장
   while not Eof(rTextFile) do
   begin
      Readln(rTextFile, sReadBuff);
      sReadBuff := StringReplace(sReadBuff,#12,'',[rfReplaceAll]);
      if copy(sReadBuff, 1, 1) <> gcSPLIT_CHAR then
      begin
         RptDataList.Add(sReadBuff);
         Inc(iStrIdx);
      end
      else  //  이전에 공백 Line이 있는지 확인 후 제거
      begin
         while Trim(RptDataList.Strings[iStrIdx]) = '' do
         begin
            RptDataList.Delete(iStrIdx);
            dec(iStrIdx);
         end;  // end of while
         RptDataList.Add(sReadBuff);
         Inc(iStrIdx);
      end;  // end of else
   end;  // end of while
   iStrIdx := RptDataList.Count -1;  // 마지막 Index
   while Trim(RptDataList.Strings[iStrIdx]) = '' do
   begin
      RptDataList.Delete(iStrIdx);
      dec(iStrIdx);
   end;  // end of while

   ClearMemoList;
   ClearPageList;

   if RptDataList.Count <= 0 then
   begin
      gvErrorNo := 1018;  // 해당 내역이 없습니다.
      gvExtMsg  := '';
      CloseFile(rTextFile);
      if Assigned(RptDataList) then RptDataList.Free;
      Exit;
   end;

   // TabSheet 생성
   CreateTabSheet(PageItem, nil, DRPageControl_Main);
   PageList.Add(PageItem);

   // Memo 생성
   CreateMemo(MemoItem, nil, PageItem);
   MemoList.Add(MemoItem);

   for I := 0 to RptDataList.Count -1 do
   begin
      sReadBuff := RptDataList.Strings[I];
      if copy(sReadBuff, 1, 1) <> gcSPLIT_CHAR then
         MemoItem.Lines.Add(sReadBuff)
      else
      begin
         if fnGetTokenStr(sReadBuff, gcSPLIT_CHAR, LBL_TITLE_IDX) <> gcPS_MARK then  // PS 아닌 경우
           PageAccNo := fnGetTokenStr(sReadBuff, gcSPLIT_CHAR, LBL_TITLE_IDX)
         else begin  // PS
            PSTabSheet := PageItem;
            PageAccNo  := fnGetTokenStr(sReadBuff, gcSPLIT_CHAR, LBL_TAB_IDX);
         end;
         PageItem.Caption  := PageAccNo;//fnGetTokenStr(sReadBuff, gcSPLIT_CHAR, LBL_TAB_IDX);

         // TabSheet 생성
         if I < RptDataList.Count -1 then   // 마지막 데이터가 아닌 경우
         begin
            CreateTabSheet(PageItem, nil, DRPageControl_Main);
            PageList.Add(PageItem);

            // Memo 생성
            CreateMemo(MemoItem, nil, PageItem);
            MemoList.Add(MemoItem);
         end;
      end;  // end of else
   end;  // end of for

   CloseFile(rTextFile);
   if Assigned(RptDataList) then RptDataList.Free;

   // Reset Memo Modified
   for I := 0 to MemoList.Count -1 do
   begin
      MemoItem := MemoList.Items[I];
      MemoItem.Modified := False;
      MemoItem.ReadOnly := False;
   end;  // end of for

   // Save버튼 처리
   DRBitBtn_Save.Enabled   := True;
   // 삭제 Popup 처리
   Popup_DeleteTab.Visible := True;

   Result := True;
end;

//------------------------------------------------------------------------------
// Open Read Only File -- 전송 내역 확인
// PDF파일명 : ExportDir + YYYYMMDD_계좌번호(ID)_FaxNumber_서식명_회차
// pFreqNo Param 추가
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function TForm_Edit.OpenReadFile(pOpenFileName, pOrientation, pTitle, pTxtUnitInfo, pExpFileNameBody: string; pFreqNo : String): boolean;

var
   I, iReadCnt, iPageNo, iNextLine, iNextPageNo : Integer;
   rTextFile : TextFile;
   sReadBuff, sTmpStr : string;
   PageItem : TDRTabSheet;
   MemoItem : TDRMemo;
   TabPageNoList : TStringList;
begin
   Result := False;

   sExpFileNameBody := pExpFileNameBody; //전역 변수 세팅, 파일명
   FreqNo := pFreqNo;

   PrnOrientation := pOrientation;   // Printer Orientation
   if not FileExists(pOpenFileName) then
   begin
      gvErrorNo := 1027;  // 해당 파일이 존재하지 않습니다.
      gvExtMsg  := '';
      Exit;
   end;

   AssignFile(rTextFile, pOpenFileName);
   {$I-}
   Reset(rTextFile);
   {$I+}
   if IOResult <> 0 then
   begin
      gvErrorNo := 1027;  // 해당 파일이 존재하지 않습니다.
      gvExtMsg  := '';
      CloseFile(rTextFile);
      Exit;
   end;

   DRLabel_Title.Caption := pTitle;  // Display Title

   // Text Unit Info : 구분자별 TabSheet 생성
   iReadCnt := 1;
   ClearMemoList;
   ClearPageList;
   TabPageNoList := TStringList.Create;
   while True do
   begin
      sTmpStr := fnGetTokenStr(pTxtUnitInfo, gcSPLIT_CHAR, iReadCnt);
      if sTmpStr = '' then break;

      // TabSheet 생성
      CreateTabSheet(PageItem, nil, DRPageControl_Main);
      PageList.Add(PageItem);
      PageItem.Caption := fnGetTokenStr(sTmpStr, gcSUB_SPLIT_CHAR, 1);

      // Memo 생성
      CreateMemo(MemoItem, nil, PageItem);
      MemoList.Add(MemoItem);

      TabPageNoList.Add(fnGetTokenStr(sTmpStr, gcSUB_SPLIT_CHAR, 2)); // Text 구분 page
      Inc(iReadCnt);
   end;  // end of while

   iPageNo   := 1;
   iNextLine := 1;
   for I := 0 to TabPageNoList.Count -1 do
   begin
      if I < TabPageNoList.Count -1 then
         iNextPageNo := StrToInt(TabPageNoList.Strings[I+1])
      else  // 마지막 구분
         iNextPageNo := 0;

      MemoItem := MemoList.Items[I];
      while not Eof(rTextFile) do
      begin
         Readln(rTextFile, sReadBuff);
         MemoItem.Lines.Add(sReadBuff);
         Inc(iNextLine);
         if iNextLine = gcRTYPE_TEXT_MAX_LINE + 1 then
         begin
            Inc(iPageNo);
            iNextLine := 1;
            if iPageNo = iNextPageNo then Break;
         end;
      end;  // end of while
   end;  // end of for
   CloseFile(rTextFile);
   if Assigned(TabPageNoList) then TabPageNoList.Free;

   // Reset Memo Modified
   for I := 0 to MemoList.Count - 1 do
   begin
      MemoItem := MemoList.Items[I];
      MemoItem.Modified := False;
      MemoItem.ReadOnly := True;
   end;

   // Save 버튼 처리
   SaveFileName := '';  // Clear;
   DRBitBtn_Save.Enabled := False;
   // 삭제 Popup 처리
   Popup_DeleteTab.Visible := False;

   Result := True;
end;

//------------------------------------------------------------------------------
// RunTime 생성된 Memo의 Key Down
//------------------------------------------------------------------------------
procedure TForm_Edit.DRMemo_CommonKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
   iCol, iLine : Integer;
begin
   if Key = VK_DELETE then
   begin
      with (Sender as TMemo) do
      begin
         iLine := Perform(EM_LINEFROMCHAR, SelStart, 0);
         iCol  := SelStart - Perform(EM_LINEINDEX, iLine, 0);
         if (iCol = Length(Lines[iLine])) and
            ((Length(Lines[iLine]) + Length(Lines[iLine+1]))> gcRTYPE_TEXT_MAX_CHAR) then
         begin
            Key := 0;
            Beep;
         end;  // end of if
      end;  // end of with
   end;  // end of if
end;

//------------------------------------------------------------------------------
// RunTime 생성된 Memo의 Key Press
//------------------------------------------------------------------------------
procedure TForm_Edit.DRMemo_CommonKeyPress(Sender: TObject; var Key: Char);
var
   iLine, iCol : Integer;
begin
   inherited;
   with (Sender as TMemo) do
   begin
      iLine := Perform(EM_LINEFROMCHAR, SelStart, 0);
      iCol  := SelStart - Perform(EM_LINEINDEX, iLine, 0);
      if Key = #8 then  // Back Space
      begin
         if (iCol = 0) and (iLine > 0) then
         begin
            if (Length(Lines[iLine]) + Length(Lines[iLine-1])) > gcRTYPE_TEXT_MAX_CHAR then
               Key := #0;
         end;
      end
      else if (Key >= '') and (not (Key in [#13, #10])) then  // Enter, Ctrl+Enter
      begin
         if Length(Lines[iLine]) >= gcRTYPE_TEXT_MAX_CHAR then
            Key := #0;
      end;
   end;  // end of with
   if Key = #0 then Beep;
end;

//------------------------------------------------------------------------------
// Delete Tab
//------------------------------------------------------------------------------
procedure TForm_Edit.Popup_DeleteTabClick(Sender: TObject);
var
   iTabIdx, iActIdx  : Integer;
   PageItem : TDRTabSheet;
   MemoItem : TDRMemo;
begin
   iTabIdx  := DRPageControl_Main.ActivePage.PageIndex;
   PageItem := PageList.Items[iTabIdx];
   MemoItem := MemoList.Items[iTabIdx];

   if Assigned(MemoItem) then MemoItem.Free;
   MemoList.Delete(iTabIdx);

   if Assigned(PageItem) then PageItem.Free;
   PageList.Delete(iTabIdx);
   if PageItem = PSTabSheet then PSTabSheet := nil;  // 삭제 Tab이 PS Tab일 경우

   iActIdx := iTabIdx -1;
   if iActIdx < 0 then iActIdx := 0;
   DRPageControl_Main.ActivePage := DRPageControl_Main.Pages[iActIdx];
   DeletedTab := True;
end;

//------------------------------------------------------------------------------
// MENU] 저장
//------------------------------------------------------------------------------
procedure TForm_Edit.Menu_SaveClick(Sender: TObject);
begin
   DRBitBtn_SaveClick(DRBitBtn_Save);
end;

//------------------------------------------------------------------------------
// MENU] 인쇄
//------------------------------------------------------------------------------
procedure TForm_Edit.Menu_PrintClick(Sender: TObject);
begin
   DRBitBtn_PrintClick(DRBitBtn_Print);
end;

//------------------------------------------------------------------------------
// MENU] 종료
//------------------------------------------------------------------------------
procedure TForm_Edit.Menu_CloseClick(Sender: TObject);
begin
   Close;
end;

//------------------------------------------------------------------------------
// MENU] Undo
//------------------------------------------------------------------------------
procedure TForm_Edit.Menu_UndoClick(Sender: TObject);
var
   MemoItem : TDRMemo;
begin
   MemoItem := MemoList.Items[DRPageControl_Main.ActivePage.TabIndex];
   if Assigned(MemoItem) then MemoItem.Undo;
end;

//------------------------------------------------------------------------------
// MENU] 복사
//------------------------------------------------------------------------------
procedure TForm_Edit.Menu_CopyClick(Sender: TObject);
var
   MemoItem : TDRMemo;
begin
   MemoItem := MemoList.Items[DRPageControl_Main.ActivePage.TabIndex];
   if Assigned(MemoItem) then MemoItem.CopyToClipboard;
end;

//------------------------------------------------------------------------------
// MENU] 잘라내기
//------------------------------------------------------------------------------
procedure TForm_Edit.Menu_CutClick(Sender: TObject);
var
   MemoItem : TDRMemo;
begin
   MemoItem := MemoList.Items[DRPageControl_Main.ActivePage.TabIndex];
   if Assigned(MemoItem) then MemoItem.CutToClipboard;
end;

//------------------------------------------------------------------------------
// MENU] 붙여넣기
//------------------------------------------------------------------------------
procedure TForm_Edit.Menu_PasteClick(Sender: TObject);
var
   MemoItem : TDRMemo;
begin
   MemoItem := MemoList.Items[DRPageControl_Main.ActivePage.TabIndex];
   if Assigned(MemoItem) then MemoItem.PasteFromClipboard;
end;

//------------------------------------------------------------------------------
//  Popup Caption 처리
//------------------------------------------------------------------------------
procedure TForm_Edit.DRPopupMenu_EditFormPopup(Sender: TObject);
begin
   Popup_DeleteTab.Caption := DRPageControl_Main.ActivePage.Caption
                              + ' ' + '삭제';
end;

//------------------------------------------------------------------------------
//  Tab이 2이상일 경우에만 삭제 가능 처리
//------------------------------------------------------------------------------
procedure TForm_Edit.DRPageControl_MainMouseUp(Sender: TObject;
                       Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   ScreenP : TPoint;
   I, iPageCnt : Integer;
begin
   if Button = mbRight then
   begin
      // Tab Delete 가능 여부 확인
      Popup_DeleteTab.Enabled := True;
      if DRPageControl_Main.ActivePage <> PSTabSheet then  // PSTabSheet는 항상 Delete 가능
      begin
         iPageCnt := 0;
         for I := 0 to DRPageControl_Main.PageCount -1 do
         begin
            if DRPageControl_Main.Pages[I] <> PSTabSheet then   // PS Tab이 아닌 경우
               Inc(iPageCnt);
         end;  // end of for
         if iPageCnt < 2 then // PSTabSheet가 아닌 TabSheet이 2개이상 존재해야 가능
            Popup_DeleteTab.Enabled := False;
      end;
      GetCursorPos(ScreenP);
      DRPopupMenu_EditForm.Popup(ScreenP.X, ScreenP.Y);
   end;  // end of if
end;

//------------------------------------------------------------------------------
//  Right Button Click시 Left Button Click의 효과
//------------------------------------------------------------------------------
procedure TForm_Edit.DRPageControl_MainMouseDown(Sender: TObject;
                       Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   Msg : TMessage;
begin
   if Button = mbRight then
   begin
      Msg.LParamLo := X;
      Msg.LParamHi := Y;
      DRPageControl_Main.Perform(WM_LBUTTONDOWN, 0, Msg.LParam);
      DRPageControl_Main.Perform(WM_LBUTTONUP, 0, Msg.LParam);
   end;
end;

//------------------------------------------------------------------------------
// Export
//------------------------------------------------------------------------------
procedure TForm_Edit.DRBitBtn_ExportClick(Sender: TObject);
var
   wTextFile : TextFile;
   PageItem : TDRTabSheet;
   MemoItem : TDRMemo;
   I, K, iTotPageCnt : Integer;
   sSplitStr, sTmpFileName, sExpFileName, sFileName, sTxtUnitInfo, sLogoPageNo : string;
   xList :TStringList;
begin

   //저장먼저 실행한후
   if DRBitBtn_Save.Enabled then DRBitBtn_SaveClick(Sender) ;
   //Export실행
   gf_ShowMessage(MessageBar, mtInformation, 1131, ''); // Export 중입니다.

   sTmpFileName := gvDirTemp + 'EXP' + Self.Name + '.tmp'; //@@

   // 파일 생성
   AssignFile(wTextFile, sTmpFileName);
   {$I-}
   Rewrite(wTextFile);
   {$I+}
   if IOResult <> 0 then
   begin
      gf_ShowMessage(MessageBar, mtError, 9006, ''); //파일 생성 오류
      CloseFile(wTextFile);
      Exit;
   end;

   for I := 0 to PageList.Count -1 do
   begin
      PageItem := PageList.Items[I];
      MemoItem := MemoList.Items[I];
      MemoItem.Modified := False;
//      if PageItem <> PSTabSheet then   // PS Tab이 아닌 경우
//      begin
         for K := 0 to MemoItem.Lines.Count -1 do
            Writeln(wTextFile, MemoItem.Lines[K]);
         sSplitStr := gcSPLIT_CHAR + PageItem.Caption + gcSPLIT_CHAR
                      + gcSPLIT_CHAR;
{
         sSplitStr := gcSPLIT_CHAR + DRLabel_Title.Caption + gcSPLIT_CHAR
                      + PageItem.Caption + gcSPLIT_CHAR;
}
         Writeln(wTextFile, sSplitStr);
//      end ;
        // PS 처리는 저장처리에서 함.
   end;  // end of for I

   CloseFile( wTextFile );

   sExpFileName := gvDirTemp + 'EXP' + gf_GetCurTime + '.tmp'; //@@
   sFileName := sExpFileNameBody;

   xList := TStringList.Create;
   if not gf_ConvertPageText(sTmpFileName, sExpFileName,   // Conversion to Page Text
      xList, iTotPageCnt, sLogoPageNo, sTxtUnitInfo) then
   begin
      gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg);
      Exit;
   end;
   xList.Free;

   if not gf_SplitTextFile(sExpFileName, sFileName, sTxtUnitInfo, FreqNo) then
   begin
      gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg); // Error 발생
      DeleteFile(sTmpFileName);
      DeleteFile(sExpFileName);
      Exit;
   end;

   DeleteFile(sTmpFileName);
   DeleteFile(sExpFileName);

   gf_ShowMessage(MessageBar, mtInformation, 1133, ''); // Export 완료

end;

end.
