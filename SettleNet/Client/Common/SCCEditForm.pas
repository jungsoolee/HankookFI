//==============================================================================
//   [LMS] 2000/12/20
// P.H.S 2006.08.25   OpenReadFile(pFreqNo(ȸ��) default='') �߰�
//                    FreqNo : String; ���� �߰�
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
    SaveFileName   : string;       // Save�� File Name
    FreqNo         : string;       // �۽ŵ� FAXȭ�� ��½� ȸ������
    PSTabSheet     : TDRTabSheet;  // PS�� Tab Sheet
    EditPSStrList  : TStringList;  // PS�� StringList
    DeletedTab     : boolean;      // Tab�� Delete �Ǿ����� ����
    PrnOrientation : string;       // Print ��� ����
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
   LBL_TITLE_IDX = 2;  // TextFile���� ���� ������ ������ �з� Index - Title
   LBL_TAB_IDX   = 3;  // TextFile���� ���� ������ ������ �з� Index - Tab

procedure TForm_Edit.FormCreate(Sender: TObject);
begin
   PageList  := TList.Create;
   MemoList  := TList.Create;
   if (not Assigned(PageList)) or (not Assigned(MemoList)) then
   begin
      gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); //List ���� ����
      Close;
      Exit;
   end;
   PSTabSheet := nil;   // Clear
   gf_DisableMainMenu;  // Disable Menu
   DeletedTab := False; // Tab ���� ���� �ʱ�ȭ
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

   if (Modified) or (DeletedTab) then  // �������� �ִ� ���
   begin
      //���� ������ �����Ͻðڽ��ϱ�?
      RtnValue := gf_ShowDlgMessage(0, mtConfirmation, 1124, '', mbYesNoCancel, 0);
      if RtnValue = idYes then
         DRBitBtn_SaveClick(DRBitBtn_Save)  // ���� ��ư Ŭ��
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
//  ���� ��ư
//------------------------------------------------------------------------------
procedure TForm_Edit.DRBitBtn_CloseClick(Sender: TObject);
begin
   Close;
end;

//------------------------------------------------------------------------------
//  ���� ��ư
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
      gf_ShowMessage(MessageBar, mtError, 1125, '���� ���ϸ� ����'); // ���� �� ���� �߻�
      Exit;
   end;

   gf_ShowMessage(MessageBar, mtInformation, 1126, ''); // ���� ���Դϴ�.

   // ���� ����
   AssignFile(wTextFile, SaveFileName);
   {$I-}
   Rewrite(wTextFile);
   {$I+}
   if IOResult <> 0 then
   begin
      gf_ShowMessage(MessageBar, mtError, 9006, ''); //���� ���� ����
      CloseFile(wTextFile);
      Exit;
   end;

   for I := 0 to PageList.Count -1 do
   begin
      PageItem := PageList.Items[I];
      MemoItem := MemoList.Items[I];
      MemoItem.Modified := False;
      if PageItem <> PSTabSheet then   // PS Tab�� �ƴ� ���
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
      else  // PS ó��
      begin
         EditPSStrList.Clear;
         for K := 0 to MemoItem.Lines.Count -1 do
            EditPSStrList.Add(MemoItem.Lines[K]);
      end;
   end;  // end of for I

   // �����ϴ� PS�� �����Ǿ����� Ȯ��
   if (EditPSStrList.Count > 0) and (not Assigned(PSTabSheet)) then
      EditPSStrList.Clear;
   CloseFile(wTextFile);
   DeletedTab := False;  // Tab ���� ���� �ʱ�ȭ
   gf_ShowMessage(MessageBar, mtInformation, 1127, '');  //����Ǿ����ϴ�.
   //----------------------
   gvSRMgrEdited := True;
   //----------------------
end;

//------------------------------------------------------------------------------
//  �μ� ��ư
//------------------------------------------------------------------------------
procedure TForm_Edit.DRBitBtn_PrintClick(Sender: TObject);
var
   MemoItem : TDRMemo;
begin
   Screen.Cursor := crHourGlass;
   gf_ShowMessage(MessageBar, mtInformation, 1100, '');  // �μ� ���Դϴ�.
   MemoItem := MemoList.Items[DRPageControl_Main.ActivePage.TabIndex];
   if Assigned(MemoItem) then
   begin
      if gf_PrintMemo(MemoItem, PrnOrientation, gcRTYPE_TEXT_MAX_LINE) then
         gf_ShowMessage(MessageBar, mtInformation, 1101, '')  // �μ� �Ϸ�
      else
         gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg);  // ���� �߻�
   end
   else
      gf_ShowMessage(MessageBar, mtError, 1009, '');  // ���� �׸��� �����ϴ�.
   Screen.Cursor := crDefault;
end;

//------------------------------------------------------------------------------
//  ������ ����
//------------------------------------------------------------------------------
procedure TForm_Edit.DRBitBtn_PrinterClick(Sender: TObject);
begin
   if gvDefaultPrinterUseYN = 'Y' then  //2007.05.23
   begin
     gf_ShowErrDlgMessage(0,0,
     '�ش� PC�� �������� �⺻ �����͸��� ����ϵ��� �����Ǿ� �ֽ��ϴ�.'
     + #13#10 + #13#10 + '�����ͷε忡 �����Ͻñ� �ٶ��ϴ�.',0);
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
     if Printer.Printers.Count = 0 then  // ��밡�� Printer����
     begin
        gvPrinter.PrinterIdx  := gcNonePrinter;
        gvPrinter.PrinterName := '';
        gvPrinter.Copies      := 1;
        gvPrinter.Orientation := poPortrait;
     end
     else  //��밡�� Printer����
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
   pMemo := TDRMemo.Create(pOwner);   // Memo ����
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
   pTabSheet := TDRTabSheet.Create(pOwner);  // TabSheet ����
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
//  Open �Է� ���� File - �ڷ� ����
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

   sExpFileNameBody := pExpFileNameBody; //���� ���� ����, ���ϸ�

   SaveFileName := pSaveFileName;    // Save File Name
   PrnOrientation := pOrientation;   // Printer Orientation

   if not FileExists(pOpenFileName) then
   begin
      gvErrorNo := 1027;  // �ش� ������ �������� �ʽ��ϴ�.
      gvExtMsg  := '';
      Exit;
   end;

   AssignFile(rTextFile, pOpenFileName);
   {$I-}
   Reset(rTextFile);
   {$I+}
   if IOResult <> 0 then
   begin
      gvErrorNo := 1027;  // �ش� ������ �������� �ʽ��ϴ�.
      gvExtMsg  := '';
      CloseFile(rTextFile);
      Exit;
   end;

   iStrIdx := -1;
   RptDataList := TStringList.Create;

   // PS ó��
   EditPSStrList := pPSStrList;
   if EditPSStrList.Count > 0 then
   begin
      for I := 0 to EditPSStrList.Count -1 do
      begin
         RptDataList.Add(EditPSStrList.Strings[I]);
         Inc(iStrIdx);
      end;  // end of for
      RptDataList.Add(gcSPLIT_CHAR + gcPS_MARK + gcSPLIT_CHAR + gcPS_MARK + gcSPLIT_CHAR);  // PS ǥ��
      Inc(iStrIdx);
   end;  // end of if

   // ���� Line ���� �� RptDataList�� ����
   while not Eof(rTextFile) do
   begin
      Readln(rTextFile, sReadBuff);
      sReadBuff := StringReplace(sReadBuff,#12,'',[rfReplaceAll]);
      if copy(sReadBuff, 1, 1) <> gcSPLIT_CHAR then
      begin
         RptDataList.Add(sReadBuff);
         Inc(iStrIdx);
      end
      else  //  ������ ���� Line�� �ִ��� Ȯ�� �� ����
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
   iStrIdx := RptDataList.Count -1;  // ������ Index
   while Trim(RptDataList.Strings[iStrIdx]) = '' do
   begin
      RptDataList.Delete(iStrIdx);
      dec(iStrIdx);
   end;  // end of while

   ClearMemoList;
   ClearPageList;

   if RptDataList.Count <= 0 then
   begin
      gvErrorNo := 1018;  // �ش� ������ �����ϴ�.
      gvExtMsg  := '';
      CloseFile(rTextFile);
      if Assigned(RptDataList) then RptDataList.Free;
      Exit;
   end;

   // TabSheet ����
   CreateTabSheet(PageItem, nil, DRPageControl_Main);
   PageList.Add(PageItem);

   // Memo ����
   CreateMemo(MemoItem, nil, PageItem);
   MemoList.Add(MemoItem);

   for I := 0 to RptDataList.Count -1 do
   begin
      sReadBuff := RptDataList.Strings[I];
      if copy(sReadBuff, 1, 1) <> gcSPLIT_CHAR then
         MemoItem.Lines.Add(sReadBuff)
      else
      begin
         if fnGetTokenStr(sReadBuff, gcSPLIT_CHAR, LBL_TITLE_IDX) <> gcPS_MARK then  // PS �ƴ� ���
           PageAccNo := fnGetTokenStr(sReadBuff, gcSPLIT_CHAR, LBL_TITLE_IDX)
         else begin  // PS
            PSTabSheet := PageItem;
            PageAccNo  := fnGetTokenStr(sReadBuff, gcSPLIT_CHAR, LBL_TAB_IDX);
         end;
         PageItem.Caption  := PageAccNo;//fnGetTokenStr(sReadBuff, gcSPLIT_CHAR, LBL_TAB_IDX);

         // TabSheet ����
         if I < RptDataList.Count -1 then   // ������ �����Ͱ� �ƴ� ���
         begin
            CreateTabSheet(PageItem, nil, DRPageControl_Main);
            PageList.Add(PageItem);

            // Memo ����
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

   // Save��ư ó��
   DRBitBtn_Save.Enabled   := True;
   // ���� Popup ó��
   Popup_DeleteTab.Visible := True;

   Result := True;
end;

//------------------------------------------------------------------------------
// Open Read Only File -- ���� ���� Ȯ��
// PDF���ϸ� : ExportDir + YYYYMMDD_���¹�ȣ(ID)_FaxNumber_���ĸ�_ȸ��
// pFreqNo Param �߰�
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

   sExpFileNameBody := pExpFileNameBody; //���� ���� ����, ���ϸ�
   FreqNo := pFreqNo;

   PrnOrientation := pOrientation;   // Printer Orientation
   if not FileExists(pOpenFileName) then
   begin
      gvErrorNo := 1027;  // �ش� ������ �������� �ʽ��ϴ�.
      gvExtMsg  := '';
      Exit;
   end;

   AssignFile(rTextFile, pOpenFileName);
   {$I-}
   Reset(rTextFile);
   {$I+}
   if IOResult <> 0 then
   begin
      gvErrorNo := 1027;  // �ش� ������ �������� �ʽ��ϴ�.
      gvExtMsg  := '';
      CloseFile(rTextFile);
      Exit;
   end;

   DRLabel_Title.Caption := pTitle;  // Display Title

   // Text Unit Info : �����ں� TabSheet ����
   iReadCnt := 1;
   ClearMemoList;
   ClearPageList;
   TabPageNoList := TStringList.Create;
   while True do
   begin
      sTmpStr := fnGetTokenStr(pTxtUnitInfo, gcSPLIT_CHAR, iReadCnt);
      if sTmpStr = '' then break;

      // TabSheet ����
      CreateTabSheet(PageItem, nil, DRPageControl_Main);
      PageList.Add(PageItem);
      PageItem.Caption := fnGetTokenStr(sTmpStr, gcSUB_SPLIT_CHAR, 1);

      // Memo ����
      CreateMemo(MemoItem, nil, PageItem);
      MemoList.Add(MemoItem);

      TabPageNoList.Add(fnGetTokenStr(sTmpStr, gcSUB_SPLIT_CHAR, 2)); // Text ���� page
      Inc(iReadCnt);
   end;  // end of while

   iPageNo   := 1;
   iNextLine := 1;
   for I := 0 to TabPageNoList.Count -1 do
   begin
      if I < TabPageNoList.Count -1 then
         iNextPageNo := StrToInt(TabPageNoList.Strings[I+1])
      else  // ������ ����
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

   // Save ��ư ó��
   SaveFileName := '';  // Clear;
   DRBitBtn_Save.Enabled := False;
   // ���� Popup ó��
   Popup_DeleteTab.Visible := False;

   Result := True;
end;

//------------------------------------------------------------------------------
// RunTime ������ Memo�� Key Down
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
// RunTime ������ Memo�� Key Press
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
   if PageItem = PSTabSheet then PSTabSheet := nil;  // ���� Tab�� PS Tab�� ���

   iActIdx := iTabIdx -1;
   if iActIdx < 0 then iActIdx := 0;
   DRPageControl_Main.ActivePage := DRPageControl_Main.Pages[iActIdx];
   DeletedTab := True;
end;

//------------------------------------------------------------------------------
// MENU] ����
//------------------------------------------------------------------------------
procedure TForm_Edit.Menu_SaveClick(Sender: TObject);
begin
   DRBitBtn_SaveClick(DRBitBtn_Save);
end;

//------------------------------------------------------------------------------
// MENU] �μ�
//------------------------------------------------------------------------------
procedure TForm_Edit.Menu_PrintClick(Sender: TObject);
begin
   DRBitBtn_PrintClick(DRBitBtn_Print);
end;

//------------------------------------------------------------------------------
// MENU] ����
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
// MENU] ����
//------------------------------------------------------------------------------
procedure TForm_Edit.Menu_CopyClick(Sender: TObject);
var
   MemoItem : TDRMemo;
begin
   MemoItem := MemoList.Items[DRPageControl_Main.ActivePage.TabIndex];
   if Assigned(MemoItem) then MemoItem.CopyToClipboard;
end;

//------------------------------------------------------------------------------
// MENU] �߶󳻱�
//------------------------------------------------------------------------------
procedure TForm_Edit.Menu_CutClick(Sender: TObject);
var
   MemoItem : TDRMemo;
begin
   MemoItem := MemoList.Items[DRPageControl_Main.ActivePage.TabIndex];
   if Assigned(MemoItem) then MemoItem.CutToClipboard;
end;

//------------------------------------------------------------------------------
// MENU] �ٿ��ֱ�
//------------------------------------------------------------------------------
procedure TForm_Edit.Menu_PasteClick(Sender: TObject);
var
   MemoItem : TDRMemo;
begin
   MemoItem := MemoList.Items[DRPageControl_Main.ActivePage.TabIndex];
   if Assigned(MemoItem) then MemoItem.PasteFromClipboard;
end;

//------------------------------------------------------------------------------
//  Popup Caption ó��
//------------------------------------------------------------------------------
procedure TForm_Edit.DRPopupMenu_EditFormPopup(Sender: TObject);
begin
   Popup_DeleteTab.Caption := DRPageControl_Main.ActivePage.Caption
                              + ' ' + '����';
end;

//------------------------------------------------------------------------------
//  Tab�� 2�̻��� ��쿡�� ���� ���� ó��
//------------------------------------------------------------------------------
procedure TForm_Edit.DRPageControl_MainMouseUp(Sender: TObject;
                       Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   ScreenP : TPoint;
   I, iPageCnt : Integer;
begin
   if Button = mbRight then
   begin
      // Tab Delete ���� ���� Ȯ��
      Popup_DeleteTab.Enabled := True;
      if DRPageControl_Main.ActivePage <> PSTabSheet then  // PSTabSheet�� �׻� Delete ����
      begin
         iPageCnt := 0;
         for I := 0 to DRPageControl_Main.PageCount -1 do
         begin
            if DRPageControl_Main.Pages[I] <> PSTabSheet then   // PS Tab�� �ƴ� ���
               Inc(iPageCnt);
         end;  // end of for
         if iPageCnt < 2 then // PSTabSheet�� �ƴ� TabSheet�� 2���̻� �����ؾ� ����
            Popup_DeleteTab.Enabled := False;
      end;
      GetCursorPos(ScreenP);
      DRPopupMenu_EditForm.Popup(ScreenP.X, ScreenP.Y);
   end;  // end of if
end;

//------------------------------------------------------------------------------
//  Right Button Click�� Left Button Click�� ȿ��
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

   //������� ��������
   if DRBitBtn_Save.Enabled then DRBitBtn_SaveClick(Sender) ;
   //Export����
   gf_ShowMessage(MessageBar, mtInformation, 1131, ''); // Export ���Դϴ�.

   sTmpFileName := gvDirTemp + 'EXP' + Self.Name + '.tmp'; //@@

   // ���� ����
   AssignFile(wTextFile, sTmpFileName);
   {$I-}
   Rewrite(wTextFile);
   {$I+}
   if IOResult <> 0 then
   begin
      gf_ShowMessage(MessageBar, mtError, 9006, ''); //���� ���� ����
      CloseFile(wTextFile);
      Exit;
   end;

   for I := 0 to PageList.Count -1 do
   begin
      PageItem := PageList.Items[I];
      MemoItem := MemoList.Items[I];
      MemoItem.Modified := False;
//      if PageItem <> PSTabSheet then   // PS Tab�� �ƴ� ���
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
        // PS ó���� ����ó������ ��.
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
      gf_ShowMessage(MessageBar, mtError, gvErrorNo, gvExtMsg); // Error �߻�
      DeleteFile(sTmpFileName);
      DeleteFile(sExpFileName);
      Exit;
   end;

   DeleteFile(sTmpFileName);
   DeleteFile(sExpFileName);

   gf_ShowMessage(MessageBar, mtInformation, 1133, ''); // Export �Ϸ�

end;

end.
