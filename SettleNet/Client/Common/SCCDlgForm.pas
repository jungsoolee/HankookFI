//==============================================================================
//   SettleNet Dlg Form
//   [LMS] 2001/03/13
//==============================================================================
unit SCCDlgForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DRSpecial, StdCtrls, Buttons, DRAdditional, ExtCtrls, DRStandard,
  DRStringgrid, DRDialogs, ComObj,OleServer, IniFiles, Excel97, Variants;

type
  TForm_Dlg = class(TForm)
    MessageBar: TDRMessageBar;
    DRPanel_Btn: TDRPanel;
    DRBitBtn1: TDRBitBtn;
    DRBitBtn2: TDRBitBtn;
    DRBitBtn3: TDRBitBtn;
    DRBitBtn4: TDRBitBtn;
    DRSaveDialog_GridExport: TDRSaveDialog;
    procedure EnableForm;
    procedure DisableForm;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DRBitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FormDisabled : boolean;      // Form�� Disable �Ǿ� �ִ��� ����
    CompStatList : TStringList;
    procedure ChildFormGridExport(DRGrid1: TDRStringGrid);
    procedure TopBtnClick(sCaption: string);  // Component�� Enable/Disable ���¸� ����
  public
    { Public declarations }
  end;

var
  Form_Dlg: TForm_Dlg;

implementation

{$R *.DFM}

uses
   SCCLib, SCCGlobalType;

//------------------------------------------------------------------------------
//  Form Create
//------------------------------------------------------------------------------
procedure TForm_Dlg.FormCreate(Sender: TObject);
var  i : integer;
     s : string;
begin
   FormDisabled := False;
   CompStatList := TStringList.Create;

  // Function Key ����� : Caption�� �̸���.
  for i := 0 to DRPanel_Btn.ControlCount -1 do
  begin
    if DRPanel_Btn.Controls[i].ClassName = 'TDRBitBtn' then
    begin
      s := (DRPanel_Btn.Controls[i] as TDRBitBtn).Caption;
      if s = '��ȸ' then
        (DRPanel_Btn.Controls[i] as TDRBitBtn).Caption := s + '(F3)'
      else if s = '�Է�' then
        (DRPanel_Btn.Controls[i] as TDRBitBtn).Caption := s + '(F4)'
      else if s = '����' then
        (DRPanel_Btn.Controls[i] as TDRBitBtn).Caption := s + '(F5)'
      else if s = '����' then
        (DRPanel_Btn.Controls[i] as TDRBitBtn).Caption := s + '(F6)'
      else if s = '�μ�' then
        (DRPanel_Btn.Controls[i] as TDRBitBtn).Caption := s + '(F7)'
      else if s = '����' then
        (DRPanel_Btn.Controls[i] as TDRBitBtn).Caption := s + '(F9)';
    end;  // end of if
  end; //For

end;

//------------------------------------------------------------------------------
//  Form Close
//------------------------------------------------------------------------------
procedure TForm_Dlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   CompStatList.Free;
   Action := CaFree;
end;

//------------------------------------------------------------------------------
//  ����
//------------------------------------------------------------------------------
procedure TForm_Dlg.DRBitBtn1Click(Sender: TObject);
begin
   Close;
end;

//------------------------------------------------------------------------------
//  Enable Form
//------------------------------------------------------------------------------
procedure TForm_Dlg.EnableForm;
var
   I, iStatIdx : Integer;
begin
   if not FormDisabled then Exit; // �̹� Form Enable ����

   Screen.Cursor := crDefault;
   iStatIdx := -1;
   for I := 0 to ComponentCount -1 do
   begin
      if (Components[I] is TButton) or
         (Components[I] is TSpeedButton) or
         (Components[I] is TPanel) then   // Button & Panel�� ó��
      begin
         Inc(iStatIdx);
         (Components[I] as TControl).Enabled := False;
         if CompStatList.Strings[iStatIdx] = 'E' then  // Enable ����
         begin
            (Components[I] as TControl).Enabled := True
         end;  // end of if
      end;
   end;  // end of for
   gf_EnableMainMenu;

   FormDisabled := False;
end;

//------------------------------------------------------------------------------
//  Disable Form
//------------------------------------------------------------------------------
procedure TForm_Dlg.DisableForm;
var
   I : Integer;
begin
   if FormDisabled then Exit;  // �̹� Form Disable ����

   Screen.Cursor := crHourGlass;
   CompStatList.Clear;
   for I := 0 to ComponentCount -1 do
   begin
      if (Components[I] is TButton) or
         (Components[I] is TSpeedButton) or
         (Components[I] is TPanel) then  // Button & Panel�� ó��
      begin
         // ���� ���� ����
         if (Components[I] as TControl).Enabled then // Enable ����
             CompStatList.Add('E')
         else  // Disable ����
             CompStatList.Add('D');
         (Components[I] as TControl).Enabled := False;
      end;
   end;
   gf_DisableMainMenu;
   
   FormDisabled := True;
end;

//------------------------------------------------------------------------------
//  ��ư ���� �ο� - TrCode�� �������� �����Ƿ� ó������ ����!!!
//------------------------------------------------------------------------------
procedure TForm_Dlg.FormShow(Sender: TObject);
//var
//   I : Integer;
begin
{
   for I := 0 to ComponentCount -1 do
   begin
      if (Components[I] is TButton) or (Components[I] is TSpeedButton) then
      begin
         if (Components[I] as TControl).Enabled then  // Enable�� Component��
         begin
            (Components[I] as TControl).Enabled := False;
            if (Components[I] as TControl).Tag <= gvAuthority then
               (Components[I] as TControl).Enabled := True
         end;
      end;
   end;  // end of for
}   
end;

procedure TForm_Dlg.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = VK_F8) then
  begin
    if (ActiveControl is TDRStringGrid) then
    begin
       ChildFormGridExport(TDRStringGrid(ActiveControl));
    end;
  end
  else if (Key = VK_F2) then
  begin
    TopBtnClick('F2');
    Key := word(#27);
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

procedure TForm_Dlg.TopBtnClick(sCaption:string);
var  i : integer;
begin
  // Funtion Key �������� ��ȸ��ư Ŭ���ϰ�
  for i := 0 to DRPanel_Btn.ControlCount -1 do
  begin
    if DRPanel_Btn.Controls[i].ClassName = 'TDRBitBtn' then
    begin
      if pos(sCaption, (DRPanel_Btn.Controls[i] as TDRBitBtn).Caption) > 0 then
      begin
        if (DRPanel_Btn.Controls[i] as TDRBitBtn).Enabled then
          (DRPanel_Btn.Controls[i] as TDRBitBtn).Click;
        Exit;
      end;
    end;  // end of if
  end; //For
end;

procedure TForm_Dlg.ChildFormGridExport(DRGrid1:TDRStringGrid);
var
  XL, XLBook, XLSheet: Variant;  // Excel���� ����
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
  gf_ShowMessage(MessageBar, mtInformation, 0, '����������....'); //���� ���Դϴ�.
  DisableForm;

  XL := gf_GetExcelOleObject;//CreateOLEObject('Excel.Application');          //������ ����
  XL.DefaultFilePath  := sDirFilePath;
  XL.DisplayAlerts := false;

  XLBook := XL.WorkBooks.Add;
//  XLBook.WorkSheets[1].Name := TForm_Dlg(Self).Title;
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
  gf_ShowMessage(MessageBar, mtInformation, 0, '����Ϸ�-' + sFileName);

end;

end.
