//==============================================================================
//   [HALEE] ?
//     UPDATE : [JYKIM] 2001/10/22
//==============================================================================
unit SCCAccNoSearch;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCCDlgForm, StdCtrls, Buttons, DRAdditional, ExtCtrls, DRStandard,
  DRSpecial, ComCtrls, DRWin32, DRCodeControl, Db, ADODB, Grids,
  DRStringgrid, DRDialogs;

type
  TDlgForm_AccNoSearch = class(TForm_Dlg)
    DRPanel1: TDRPanel;
    DRPanel7: TDRPanel;
    DRLabel4: TDRLabel;
    DRBitBtn6: TDRBitBtn;
    ADOQuery_Temp: TADOQuery;
    DREdit_Data: TDREdit;
    DRStrGrid_Acc: TDRStringGrid;
    DRButton1: TDRButton;
    DRLabel1: TDRLabel;


    procedure FormCreate(Sender: TObject);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DRStrGrid_AccFiexedRowClick(Sender: TObject; ACol: Integer);
    procedure DRButton1Click(Sender: TObject);
    procedure DRBitBtn1Click(Sender: TObject);
    procedure DRBitBtn2Click(Sender: TObject);
    procedure DRStrGrid_AccSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormShow(Sender: TObject);
    procedure DREdit_DataKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DRStrGrid_AccDblClick(Sender: TObject);
  private
    FormCreated : boolean;
    procedure ClearAccList;
    function AccSearch(sSecType, sData : string): boolean;
    procedure DisplayGrid;
  public
    InSecType : string; //E, F
    InAccNo   : string; //formatted
    InAccName : string;
  end;

var
  DlgForm_AccNoSearch: TDlgForm_AccNoSearch;

implementation

uses
  SCCLib, SCCGlobalType, SCCCmuLib;
{$R *.DFM}


type
  TAccItem = record           // �׷���� ��ü����List
    AccNo        : string;
    AccName      : string;
    BookName      : string;
  end;
  pTAccItem = ^TAccItem;

const
  IDX_ACC_NO      = 0;
  IDX_ACC_NAME    = 1;
  IDX_BOOK_NAME    = 2;
var
  AccSortIdx : Integer;     // MgrGrp Sort Column�� Index
  AccSortFlag : Array [0..2] of Boolean;   // DRListView_SelectAcc���� �� Column�� Sort ����
  AccList     : TList;                     // �׷���� DRListView_AllAcc List
  SelRow : integer;

//------------------------------------------------------------------------------
//  ��ϰ��� Sorting �Լ� (Select)
//------------------------------------------------------------------------------
function AccListCompare(Item1, Item2: Pointer): Integer;
begin
  case AccSortIdx of
    // ���¹�ȣ
    0: Result := gf_ReturnStrComp(pTAccItem(Item1).AccNo,
                                  pTAccItem(Item2).AccNo,
                                  AccSortFlag[AccSortIdx]);
    // ���¸�
    1: Result := gf_ReturnStrComp(pTAccItem(Item1).AccName,
                     		  pTAccItem(Item2).AccName,
                     		  AccSortFlag[AccSortIdx]);
    // �α��
    2: Result := gf_ReturnStrComp(pTAccItem(Item1).BookName,
                     		  pTAccItem(Item2).BookName,
                     		  AccSortFlag[AccSortIdx]);
    else
       Result := 0;
  end;  // end of case

end;

//------------------------------------------------------------------------------
// �������
//------------------------------------------------------------------------------
procedure TDlgForm_AccNoSearch.FormCreate(Sender: TObject);
begin
  inherited;
  FormCreated := False;

  //�˻���� Clear
  gvSearchOutAccNo    := '';
  gvSearchOutSubAccNo := '';
  gvSearchOutAccName  := '';

  // �˻���
  DREdit_Data.Color    := gcQueryEditColor;

  AccSortIdx := IDX_ACC_NO;           // ���¹�ȣ Sorting
  AccSortFlag[AccSortIdx] := True;  // Ascending

  //List ����
  AccList    := TList.Create;

  if not Assigned(AccList) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); // List ���� ����
    Close;
    Exit;
  end;

  DRStrGrid_Acc.RowCount := 2;
  DRStrGrid_Acc.Rows[1].Clear;

  FormCreated := True;
end;

//------------------------------------------------------------------------------
// FromClose
//------------------------------------------------------------------------------
procedure TDlgForm_AccNoSearch.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  ClearAccList;
end;

//------------------------------------------------------------------------------
//  Clear AccList
//------------------------------------------------------------------------------
procedure TDlgForm_AccNoSearch.ClearAccList;
var
  I : Integer;
  AccItem : pTAccItem;
begin
  if not Assigned(AccList) then Exit;
  for I := 0 to AccList.Count -1 do
  begin
    AccItem := AccList.Items[I];
    Dispose(AccItem);
  end;
  AccList.Clear;
end;


//------------------------------------------------------------------------------
// �˻�
//------------------------------------------------------------------------------
function TDlgForm_AccNoSearch.AccSearch(sSecType, sData : string): boolean;
var
  sFormatAccNo, sAccNo, sSubAccNo, sSubDirectGB: string;
  iRow : integer;
  AccItem : pTAccItem;
begin
  Result := False;

  ClearAccList;

  gf_UnformatAccNo(sData, sAccNo, sSubAccNo);

  sSubDirectGB := 'N';
  if (gf_StrToFloat(sAccNo) > 0) then //���¹�ȣ
  begin
    if (sSubAccNo > '') then
    begin
      sSubDirectGB := 'Y';
    end;
  end;

  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    if sSecType = 'E' then
    begin
      if (sSubDirectGB = 'Y') then
      begin
        SQL.Add(' select ACC_NO, SUB_ACC_NO, ACC_NAME_KOR = SUB_NAME_KOR, BOOK_NAME = SUB_BOOK_KOR '
              + ' from SESACIF_TBL                                              '
              + ' where DEPT_CODE = ''' + gvDeptCode + '''                      '
              + ' and   ACC_NO    = ''' + sAccNo + '''          '
              + ' and   SUB_ACC_NO= ''' + sSubAccNo + '''         '
              + ' ORDER BY ACC_NO, SUB_ACC_NO                                   '
              );
      end
      else
      begin
        SQL.Add(' select ACC_NO, '''' as SUB_ACC_NO, ACC_NAME_KOR, BOOK_NAME = BOOK_NAME_KOR               '
              + ' from SEACBIF_TBL                                              '
              + ' where DEPT_CODE = ''' + gvDeptCode + '''                      '
              + ' and   (  (UPPER(ACC_NAME_KOR) like ''' + uppercase(sData) + '%'')          '
              + '       or (ACC_NO       like ''' + sData + '%''))         '
              + ' union                                                         '
              + ' select ACC_NO, SUB_ACC_NO, SUB_NAME_KOR, BOOK_NAME = SUB_BOOK_KOR                       '
              + ' from SESACIF_TBL                                              '
              + ' where DEPT_CODE = ''' + gvDeptCode + '''                      '
              + ' and   (  (UPPER(SUB_NAME_KOR) like ''' + uppercase(sData) + '%'')          '
              + '       or (ACC_NO       like ''' + sData + '%''))         '
              + ' ORDER BY ACC_NO, SUB_ACC_NO                                   '
              );
      end;
    end
    else
    begin
      if (sSubDirectGB = 'Y') then
      begin
        SQL.Add(' select ACC_NO, SUB_ACC_NO, ACC_NAME_KOR = SUB_NAME_KOR, BOOK_NAME = SUB_BOOK_KOR                       '
              + ' from  SFSACIF_TBL                                              '
              + ' where DEPT_CODE = ''' + gvDeptCode + '''                      '
              + ' and   ACC_NO    = ''' + sAccNo + '''          '
              + ' and   SUB_ACC_NO= ''' + sSubAccNo + '''         '
              + ' ORDER BY ACC_NO, SUB_ACC_NO                                   '
              );
      end
      else
      begin

        SQL.Add(' select ACC_NO, '''' as SUB_ACC_NO , ACC_NAME_KOR , BOOK_NAME = BOOK_NAME_KOR             '
              + ' from SFACBIF_TBL                                              '
              + ' where DEPT_CODE = ''' + gvDeptCode + '''                      '
              + ' and   (  (UPPER(ACC_NAME_KOR) like ''' + uppercase(sData) + '%'')          '
              + '       or (ACC_NO       like ''' + sData + '%''))         '
              + ' union                                                         '
              + ' select ACC_NO, SUB_ACC_NO, SUB_NAME_KOR, BOOK_NAME = SUB_BOOK_KOR                       '
              + ' from SFSACIF_TBL                                              '
              + ' where DEPT_CODE = ''' + gvDeptCode + '''                      '
              + ' and   (  (UPPER(SUB_NAME_KOR) like ''' + uppercase(sData) + '%'')          '
              + '       or (ACC_NO       like ''' + sData + '%''))         '
              + ' ORDER BY ACC_NO, SUB_ACC_NO                                   '
              );
      end;
    end;

    Try
      gf_ADOQueryOpen(ADOQuery_Temp);
    Except
      on E : Exception do
      begin  // DataBase ����
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SFACBIF_TBL]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SFACBIF_TBL]'); //Database ����
        Exit;
      end;
    End;

    while not EOF do
    begin
      New(AccItem);
      AccList.Add(AccItem);

      sFormatAccNo := gf_FormatAccNo(Trim(FieldByName('ACC_NO').asString),
                                     Trim(FieldByName('SUB_ACC_NO').asString));

      AccItem.AccNo := sFormatAccNo;
      AccItem.AccName := Trim(FieldByName('ACC_NAME_KOR').asString);
      AccItem.BookName := Trim(FieldByName('BOOK_NAME').asString);
      Next;
    end;

  end; //end of with
  Result := True;
end;

procedure TDlgForm_AccNoSearch.DRStrGrid_AccFiexedRowClick(Sender: TObject;
  ACol: Integer);
begin
  inherited;
  Screen.Cursor := crHourGlass;
  AccSortIdx := ACol;
  AccSortFlag[ACol] := not AccSortFlag[ACol];
  AccList.Sort(AccListCompare);
  DisplayGrid;
  Screen.Cursor := crDefault;
end;


procedure TDlgForm_AccNoSearch.DisplayGrid;
var i, iRow : integer;
    AccItem : pTAccItem;
begin
  DRStrGrid_Acc.RowCount := 2;
  DRStrGrid_Acc.Rows[1].Clear;

  iRow := 0;

  for i := 0 to AccList.Count -1 do
  begin
    AccItem := AccList.Items[i];
    inc(iRow);
    DRStrGrid_Acc.Rows[iRow].Clear;
    DRStrGrid_Acc.Cells[IDX_ACC_NO, iRow] := AccItem.AccNo;
    DRStrGrid_Acc.Cells[IDX_ACC_NAME, iRow] := AccItem.AccName;
    DRStrGrid_Acc.Cells[IDX_BOOK_NAME, iRow] := AccItem.BookName;
  end;

  if iRow <= 1 then
  begin
    DRStrGrid_Acc.RowCount := 2;
  end
  else
    DRStrGrid_Acc.RowCount := iRow + 1;

  if AccList.Count <= 0 then
    gf_ShowMessage(MessageBar, mtInformation,0,'�ش� ���°� �������� �ʽ��ϴ�')
  else
    gf_ShowMessage(MessageBar, mtInformation,0,'��ȸ�Ϸ�' + InttoStr(AccList.Count) + '��') ;

end;

procedure TDlgForm_AccNoSearch.DRButton1Click(Sender: TObject);
begin
  inherited;
  if (InSecType <> 'E')
  and (InSecType <> 'F') then
  begin
    gf_ShowMessage(MessageBar, mtInformation, 0, '�������� ���� ����');
    Exit;
  end;

  if Length(DREdit_Data.Text) >= 4 then
  begin
    Screen.Cursor := crHourGlass;
    AccSearch(InSecType, DREdit_Data.Text);
    DisplayGrid;
    Screen.Cursor := crDefault;
  end
  else
  begin
    gf_ShowMessage(messageBar, mtError, 0, '�˻���� 4Byte(�ѱ۵���)�̻� �Է��Ͻʽÿ�');
  end;

end;

procedure TDlgForm_AccNoSearch.DRBitBtn1Click(Sender: TObject);
begin
  inherited;
  ModalResult := idAbort;
end;

procedure TDlgForm_AccNoSearch.DRBitBtn2Click(Sender: TObject);
var sAccNo, sSubAccNo : string;
begin
  inherited;

  gf_UnformatAccNo(DRStrGrid_Acc.Cells[IDX_ACC_NO, SelRow], sAccNo, sSubAccNo);
  if sAccNo = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 0, '���¸� �����ϰų� �ݱ⸦ �����ʽÿ�');
    Exit;
  end;

  gvSearchOutAccNo := sAccNo;
  gvSearchOutSubAccNo := sSubAccNo;
  gvSearchOutAccName := DRStrGrid_Acc.Cells[IDX_ACC_NAME, SelRow];
  ModalResult := idOK;
end;

procedure TDlgForm_AccNoSearch.DRStrGrid_AccSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  SelRow := ARow;
end;

procedure TDlgForm_AccNoSearch.FormShow(Sender: TObject);
var sAccNo, sSubAccNo : string;
begin
  inherited;

  Screen.Cursor := crHourGlass;
  if FormCreated then
  begin
    InSecType := trim(InSecType);
    if (InSecType <> 'E')
    and (InSecType <> 'F') then
    begin
      gf_ShowMessage(MessageBar, mtInformation, 0, '�������� ���� ����');
    end
    else if InAccNo > '' then
    begin
      InAccNo := trim(InAccNo);
      InAccName := '';
      DREdit_Data.Text := InAccNo;
      gf_UnformatAccNo(InAccNo, sAccNo, sSubAccNo);
      if Length(DREdit_Data.Text) >= 4 then
      begin
        AccSearch(InSecType, sAccNo);
        DisplayGrid;
      end
      else
      begin
        gf_ShowMessage(messageBar, mtError, 0, '�˻���� 4Byte(�ѱ۵���)�̻� �Է��Ͻʽÿ�');
      end;
    end
    else if InAccName > '' then
    begin
      InAccNo := '';
      InAccName := trim(InAccName);
      DREdit_Data.Text := InAccName;
      if Length(DREdit_Data.Text) >= 4 then
      begin
        AccSearch(InSecType, DREdit_Data.Text);
        DisplayGrid;
      end
      else
      begin
        gf_ShowMessage(messageBar, mtError, 0, '�˻���� 4Byte(�ѱ۵���)�̻� �Է��Ͻʽÿ�');
      end;
    end;

    DREdit_Data.SetFocus;
  end;
  Screen.Cursor := crDefault;
end;

procedure TDlgForm_AccNoSearch.DREdit_DataKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_Return then
  begin
    DRButton1Click(nil);
  end;
end;

procedure TDlgForm_AccNoSearch.DRStrGrid_AccDblClick(Sender: TObject);
var sAccNo, sSubAccNo : string;
begin
  inherited;

  gf_UnformatAccNo(DRStrGrid_Acc.Cells[IDX_ACC_NO, SelRow], sAccNo, sSubAccNo);
  if sAccNo = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 0, '���¸� �����ϰų� �ݱ⸦ �����ʽÿ�');
    Exit;
  end;

  gvSearchOutAccNo := sAccNo;
  gvSearchOutSubAccNo := sSubAccNo;
  gvSearchOutAccName := DRStrGrid_Acc.Cells[IDX_ACC_NAME, SelRow];
  ModalResult := idOK;
end;

end.
