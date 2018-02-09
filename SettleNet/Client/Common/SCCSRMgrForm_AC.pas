unit SCCSRMgrForm_AC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SCCSRMgrForm, DRSpecial, StdCtrls, Buttons, DRAdditional, menus,
  ExtCtrls, DRStandard, DRStringgrid, ComObj,OleServer, IniFiles, Excel97,
  DRDialogs;

type
  TForm_SCF_AC = class(TForm_SRMgrForm)
    DRSaveDialog_GridExport: TDRSaveDialog;

    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    procedure TopBtnClick(sCaption: string);
    procedure ChildFormGridExport(DRGrid1:TDRStringGrid);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_SCF_AC: TForm_SCF_AC;

implementation

uses
   SCCGlobalType, SCCLib;

{$R *.dfm}

//------------------------------------------------------------------------------
//  사용자 권한 처리
//------------------------------------------------------------------------------
procedure TForm_SCF_AC.FormShow(Sender: TObject);
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

   {
   gvSendUseYN := gf_GetSystemOptionValue('S10','Y'); //송수신화면에서 전송 사용여부 Default Y
   if gvSendUseYN = 'N' then
   begin
      DRPanel_SndFaxTlxTitleDblClick(nil);
      DRLabel_SndMailClick(nil);
   end;
   }
end;

procedure TForm_SCF_AC.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TForm_SCF_AC.TopBtnClick(sCaption:string);
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

procedure TForm_SCF_AC.FormCreate(Sender: TObject);
var  i : integer;
     s : string;
begin
  inherited;
  Top  := 5;
  Left := 5;

  // Function Key 만들기 : Caption에 이름만.
  for i := 0 to DRPanel_Top.ControlCount -1 do
  begin
    if DRPanel_Top.Controls[i].ClassName = 'TDRBitBtn' then
    begin
      s := (DRPanel_Top.Controls[i] as TDRBitBtn).Caption;
      if s = '조회' then
        (DRPanel_Top.Controls[i] as TDRBitBtn).Caption := s + '(F3)'
      else if s = '입력' then
        (DRPanel_Top.Controls[i] as TDRBitBtn).Caption := s + '(F4)'
      else if s = '수정' then
        (DRPanel_Top.Controls[i] as TDRBitBtn).Caption := s + '(F5)'
      else if s = '삭제' then
        (DRPanel_Top.Controls[i] as TDRBitBtn).Caption := s + '(F6)'
      else if s = '인쇄' then
        (DRPanel_Top.Controls[i] as TDRBitBtn).Caption := s + '(F7)'
      else if s = '종료' then
        (DRPanel_Top.Controls[i] as TDRBitBtn).Caption := s + '(F9)';
    end;  // end of if
  end; //For

end;

procedure TForm_SCF_AC.ChildFormGridExport(DRGrid1:TDRStringGrid);
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
