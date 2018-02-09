//==============================================================================
//   [HALEE] ?
//     UPDATE : [JYKIM] 2001/10/22
//==============================================================================
unit SCBFRegGroup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCCDlgForm, StdCtrls, Buttons, DRAdditional, ExtCtrls, DRStandard,
  DRSpecial, ComCtrls, DRWin32, DRCodeControl, Db, ADODB, Mask, Grids,
  DRStringgrid, DRDialogs;

type
  TDlgForm_FRegGroup = class(TForm_Dlg)
    DRPanel1: TDRPanel;
    DRPanel2: TDRPanel;
    DRPanel6: TDRPanel;
    DRSpeedButton_FindAcc: TDRSpeedButton;
    DRPanel7: TDRPanel;
    DRLabel4: TDRLabel;
    DRLabel8: TDRLabel;
    DREdit_GrpName: TDREdit;
    DREdit_MgrOprId: TDREdit;
    DREdit_MgrOprTime: TDREdit;
    DRPanel3: TDRPanel;
    DRPanel4: TDRPanel;
    DRListView_AllAcc: TDRListView;
    DRPanel5: TDRPanel;
    DRLabel2: TDRLabel;
    DRCheckBox_ExcepAll: TDRCheckBox;
    DRListView_SelectAcc: TDRListView;
    DRBitBtn6: TDRBitBtn;
    ADOQuery_Temp: TADOQuery;
    ADOQuery_SUAGPAC: TADOQuery;
    DRSpeedBtn_Insert: TDRSpeedButton;
    DRSpeedBtn_Delete: TDRSpeedButton;
    ADOCommand1: TADOCommand;
    DRStrGrid_MgrGrp: TDRStringGrid;
    DRLabel1: TDRLabel;
    DRLabel6: TDRLabel;
    DREdit_AccNo: TDREdit;
    DRTreeView_MgrAcc: TDRTreeView;


    procedure FormCreate(Sender: TObject);

    //--- Grp Mgr ---//
    function  QueryAllAcc    : integer;
    function  QuerySelectAcc : boolean;
    procedure ListViewSelectData;
    procedure ClearAllAccList;
    procedure ClearGrpAccList;
    procedure AddSelectData;
    procedure DelSelectData;
    function  DupDataDelete  : boolean;
    function  SelectAccCheck : boolean;
    function  BuildTreeViewMgrGrp: boolean;
    function  BuildTreeViewMgrAcc: boolean;
    function  ExistInSUAGPAC : boolean;

    function  SelectTreeViewMgrAcc(pGrpName: string): Integer;
    function  ExistInTreeViewMgrAcc(pGrpName: string): Integer;
    function  ExistListViewSelAcc(pFmtAccNo: string) : Integer;

    procedure DRListView_AllAccData(Sender: TObject; Item: TListItem);
    function  MgrGrpCheckKeyEditEmpty: boolean;
    procedure AccSelectedCheck;
    procedure InputValueClear;

    procedure DRBitBtn6Click(Sender: TObject);
    procedure DRBitBtn4Click(Sender: TObject);
    procedure DRBitBtn3Click(Sender: TObject);
    procedure DRTreeView_MgrAccChange(Sender: TObject; Node: TTreeNode);
    procedure DRSpeedButton_FindAccClick(Sender: TObject);
    procedure DRCheckBox_ExcepAllClick(Sender: TObject);
    procedure DRListView_SelectAccDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure DRListView_SelectAccDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure DRListView_SelectAccEndDrag(Sender, Target: TObject; X,
      Y: Integer);
    procedure DRListView_SelectAccMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DRListView_AllAccColumnClick(Sender: TObject;
      Column: TListColumn);
    procedure DRListView_AllAccDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure DRListView_AllAccDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure DRListView_AllAccEndDrag(Sender, Target: TObject; X,
      Y: Integer);
    procedure DRListView_AllAccMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DRSpeedBtn_InsertClick(Sender: TObject);
    procedure DRSpeedBtn_DeleteClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure DRBitBtn2Click(Sender: TObject);
    procedure DRListView_SelectAccKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DRListView_AllAccDblClick(Sender: TObject);
    procedure DRListView_SelectAccDblClick(Sender: TObject);
    procedure DREdit_GrpNameKeyPress(Sender: TObject; var Key: Char);
    procedure DRStrGrid_MgrGrpSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure DRStrGrid_MgrGrpDblClick(Sender: TObject);
    procedure DREdit_AccNoKeyPress(Sender: TObject; var Key: Char);
  private
    FormCreated : boolean;
    function AccSearch(sData: string): boolean;
    function ExistInGridMgrGrp(pGrpName: string): Integer;
    function SelectGridMgrGrp(pGrpName: string): Integer;
    procedure DRListView_SelectAccColumnClick(Sender: TObject;
      Column: TListColumn);
  public
    DefGrpName  : string;
    DefCallFlag : string;
    DefAccNo    : string;
    DefSubAccNo : string;
    OldEditWndProc: TWndMethod;
    procedure EditWndProc(var Message: TMessage);
  end;

var
  DlgForm_FRegGroup: TDlgForm_FRegGroup;

implementation

uses
  SCCLib, SCCGlobalType, SCCCmuLib;
{$R *.DFM}


type
  TAllAccItem = record           // �׷���� ��ü����List
    FmtAccNo     : string;
    AccName      : string;
    AccComp      : string;
    BookName      : string;
    CompName     : string;
  end;
  pTAllAccItem = ^TAllAccItem;

  TSelectAccItem = record        // �׷���� ��ϰ���List
    FmtAccNo     : string;
    AccName      : string;
    ExceptFlag   : Boolean;
  end;
  pTSelectAccItem = ^TSelectAccItem;

const
  IDXA_ACC_NO      = 0;   // ���¹�ȣ Col Index
  PEXCEPTFAX       = 'pExceptFax';
var
  sCallFlag       : string;
  MgrAllSortIdx, MgrSelSortIdx : Integer;     // MgrGrp Sort Column�� Index
  MgrAllSortFlag : Array [0..3] of Boolean;   // DRListView_AllAcc���� ��Column�� Sort ����
  MgrSelSortFlag : Array [0..1] of Boolean;   // DRListView_SelectAcc���� �� Column�� Sort ����
  AllAccList     : TList;                     // �׷���� DRListView_AllAcc List
  GrpAccList     : TList;                     // �׷���� DRListView_SelectAcc List
  GrpFlag : Boolean; // �׷���� ����
  SelMgrGrpRow : integer;

//------------------------------------------------------------------------------
//  ��ϰ��� Sorting �Լ� (Select)
//------------------------------------------------------------------------------
function MgrSelListCompare(Item1, Item2: Pointer): Integer;
begin
  case MgrSelSortIdx of
    // ���¹�ȣ
    0: Result := gf_ReturnStrComp(pTSelectAccItem(Item1).FmtAccNo,
                                  pTSelectAccItem(Item2).FmtAccNo,
                                  MgrSelSortFlag[MgrSelSortIdx]);
    // ���¸�
    1: Result := gf_ReturnStrComp(pTSelectAccItem(Item1).AccName,
                     		  pTSelectAccItem(Item2).AccName,
                     		  MgrSelSortFlag[MgrSelSortIdx]);
    else
       Result := 0;
  end;  // end of case

end;
//------------------------------------------------------------------------------
//  ��ü���� Sorting �Լ� (All)
//------------------------------------------------------------------------------
function MgrAllListCompare(Item1, Item2: Pointer): Integer;
var
  StdStr1, StdStr2 : string;
begin
  StdStr1 :=  pTAllAccItem(Item1).FmtAccNo;
  StdStr2 :=  pTAllAccItem(Item2).FmtAccNo;

  case MgrAllSortIdx of
    // ���¹�ȣ
    0: Result := gf_ReturnStrComp(StdStr1, StdStr2,
                                  MgrAllSortFlag[MgrAllSortIdx]);
    // ���¸�
    1: Result := gf_ReturnStrComp(pTAllAccItem(Item1).AccName,
                     		  pTAllAccItem(Item2).AccName,
                     		  MgrAllSortFlag[MgrAllSortIdx]);
    // �α��
    2: Result := gf_ReturnStrComp(pTAllAccItem(Item1).BookName,
                     		  pTAllAccItem(Item2).BookName,
                     		  MgrAllSortFlag[MgrAllSortIdx]);
    // ������
    3: Result := gf_ReturnStrComp(pTAllAccItem(Item1).CompName,
                     		  pTAllAccItem(Item2).CompName,
                     		  MgrAllSortFlag[MgrAllSortIdx]);

    else
       Result := 0;
  end;  // end of case

end;

//------------------------------------------------------------------------------
// �������
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.FormCreate(Sender: TObject);
begin
  inherited;
  FormCreated := False;
  // �׷��
  DREdit_GrpName.Color    := gcQueryEditColor;

  DRTreeView_MgrAcc.Color := gcTreeViewColor;

  MgrAllSortIdx := IDXA_ACC_NO;           // ���¹�ȣ Sorting
  MgrAllSortFlag[MgrAllSortIdx] := True;  // Ascending
  MgrSelSortIdx := IDXA_ACC_NO;           // ���¹�ȣ Sorting
  MgrSelSortFlag[MgrSelSortIdx] := True;  // Ascending

  GrpFlag := True;                       // ���LIst�� �׷����� �����ش�.
  DRSpeedButton_FindAcc.Hint := '���¹�ȣ��';
  if not BuildTreeViewMgrGrp then Exit;     // DRTreeView_MgrGrp ������ ����

  if gvDeptCode = gcDEPT_CODE_INT then // ������
      DREdit_GrpName.ImeMode := imSAlpha;

  //List ����
  AllAccList    := TList.Create;
  GrpAccList    := TList.Create;
  // MgrGrp ���� ��ü ����List ����
  DRListView_AllAcc.Items.Count := 0;//QueryAllAcc;

  if (not Assigned(AllAccList)) or (not Assigned(GrpAccList))  then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); // List ���� ����
    Close;
    Exit;
  end;

  FormCreated := True;
end;

//------------------------------------------------------------------------------
// FromClose
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  ClearAllAccList;
  ClearGrpAccList;
end;



//------------------------------------------------------------------------------
// Row Selected ��ȯ(��ü���� -> ��ϰ���)
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.AccSelectedCheck;
var
  List_Item : TListItem;
  SelAccIdx, SelAccCNT, I   : integer;
begin
{
  // ���¹�ȣ �Է�
  if (DRUserDblCodeCombo_GrpAcc.Code <> '') then
  begin
    for I := 0 to DRListView_SelectAcc.Items.Count -1  do  // ��ϰ��� List
    begin
       List_Item := DRListView_SelectAcc.Items[I];

       if  Trim(DRUserDblCodeCombo_GrpAcc.Code)  = List_Item.Caption then
       begin
          List_Item.Selected := True;
//          exit;
       end;
    end;  // end of for
    DRUserDblCodeCombo_GrpAcc.Clear;
  end
  // Multi Select
  else
  }
  if  (DRListView_AllAcc.SelCount > 0) then
  begin
    SelAccCNT  := DRListView_AllAcc.SelCount;               // ���ð��� Count
    SelAccIdx  := DRListView_AllAcc.Selected.Index;          // ���ð��� Index

    while (SelAccCNT > 0) do
    begin
      if  DRListView_AllAcc.Items[SelAccIdx].Selected then   // ��ü������ ���õ� Data
      begin
        for I := 0 to DRListView_SelectAcc.Items.Count - 1 do  // ��ϰ��� List
        begin
          List_Item := DRListView_SelectAcc.Items[I];
          If  Trim(DRListView_AllAcc.Items[SelAccIdx].Caption)
                          = List_Item.Caption then
          begin
            DRListView_AllAcc.Items[SelAccIdx].Selected := False;
            List_Item.Selected := True;
          end; // end of if
        end;  // end of for
        SelAccCNT := SelAccCNT - 1;
      end; // end of if
      SelAccIdx := SelAccIdx + 1;
      Next;
    end; // end of while
  end
  // NO Selected
  else
    gf_ShowMessage(MessageBar, mtError, 1009, ''); //���� �׸��� �����ϴ�.

end;

//------------------------------------------------------------------------------
// ���� ���� �߰�
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.AddSelectData;
var
  AccItem      : pTSelectAccItem;
  SelAccIdx, SelAccCNT   : integer;
begin
{
  if (DRUserDblCodeCombo_GrpAcc.Code <> '') then
  begin
    New(AccItem);
    GrpAccList.Add(AccItem);

    AccItem.FmtAccNo   := DRUserDblCodeCombo_GrpAcc.Code;
    AccItem.AccName    := DRUserDblCodeCombo_GrpAcc.CodeName;
    AccItem.ExceptFlag := False;
  end else
  // Multi Select
}
  if DRListView_AllAcc.SelCount > 0 then
  begin
    SelAccCNT  := DRListView_AllAcc.SelCount;               // ���ð��� Count
    SelAccIdx  := DRListView_AllAcc.Selected.Index;          // ���ð��� Index

    while (SelAccCNT > 0) do
    begin
      if  DRListView_AllAcc.Items[SelAccIdx].Selected then   // ���õ� Data
      begin
        New(AccItem);
        GrpAccList.Add(AccItem);
        AccItem.FmtAccNo   := DRListView_AllAcc.Items[SelAccIdx].Caption;
        AccItem.AccName    := DRListView_AllAcc.Items[SelAccIdx].SubItems.Strings[0];  // ���¸�
        AccItem.ExceptFlag := False;
        SelAccCNT := SelAccCNT - 1;
      end; // end of if
      SelAccIdx := SelAccIdx + 1;
      Next;
    end; // end of while
  end; // end of if

  ListViewSelectData;
  AccSelectedCheck;
end;

//------------------------------------------------------------------------------
// �׷����  DRTreeView_MgrAcc ���¹�ȣList ����
//------------------------------------------------------------------------------
function TDlgForm_FRegGroup.BuildTreeViewMgrAcc: boolean;
var
  GItem, CItem : TTreeNode;
  FmtAccNo : string;
begin
  Result := False;

  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' Select ACC_NO, SUB_ACC_NO, GRP_NAME  '
          + ' From SUAGPAC_TBL '
          + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
          + ' And   SEC_TYPE  = ''' + gcSEC_FUTURES  + ''' '
          + ' Group by ACC_NO, SUB_ACC_NO, GRP_NAME  '
          + ' Order By ACC_NO, SUB_ACC_NO, GRP_NAME  ');
    Try
      gf_ADOQueryOpen(ADOQuery_Temp);
    Except
      on E : Exception do
      begin  // DataBase ����
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SUAGPAC_TBL]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SUAGPAC_TBL]'); //Database ����
        Exit;
      end;
    End;

    DRTreeView_MgrAcc.Visible := False; //@@

    // Clear TreeView
    DRTreeView_MgrAcc.Items.Clear;
    // Add TreeView
    GItem := nil;
    FmtAccNo := '';

    while not EOF do
    begin
      if FmtAccNo <> gf_FormatAccNo(Trim(FieldByName('ACC_NO').asString),
                                    Trim(FieldByName('SUB_ACC_NO').asString)) then
      begin
        FmtAccNo := gf_FormatAccNo(Trim(FieldByName('ACC_NO').asString),
                                       Trim(FieldByName('SUB_ACC_NO').asString));
        GItem  := DRTreeView_MgrAcc.Items.Add(nil, FmtAccNo);
        CItem  := DRTreeView_MgrAcc.Items.AddChild(GItem, Trim(FieldByName('GRP_NAME').asString));
      end
      else
        CItem := DRTreeView_MgrAcc.Items.AddChild(GItem, Trim(FieldByName('GRP_NAME').asString));
      Next;
    end;   // end of while
    DRTreeView_MgrAcc.OnChange := DRTreeView_MgrAccChange;  // Event ����
    DRTreeView_MgrAcc.Align := alClient; //@@
    DRTreeView_MgrAcc.Visible := True; //@@

  end;  // end of with

  Result := True;
end;

//------------------------------------------------------------------------------
// �׷��� TreeView ����
//------------------------------------------------------------------------------
function TDlgForm_FRegGroup.BuildTreeViewMgrGrp: boolean;
var iRow : integer;
begin
  Result := False;
  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' Select GRP_NAME '
          + ' From SUAGPAC_TBL '
          + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
          + ' And   SEC_TYPE  = ''' + gcSEC_FUTURES  + ''' '
          + ' Group By GRP_NAME  '
          + ' Order By GRP_NAME ');
    Try
      gf_ADOQueryOpen(ADOQuery_Temp);
    Except
      on E : Exception do
      begin  // DataBase ����
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SUAGPAC_TBL]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SUAGPAC_TBL]'); //Database ����
        Exit;
      end;
    End;

    DRTreeView_MgrAcc.Visible := False; //@@
    DRStrGrid_MgrGrp.Visible := False; //@@

    // Clear TreeView
    DRStrGrid_MgrGrp.RowCount := 2;
    DRSTrGrid_MgrGrp.Rows[1].Clear;

    iRow := 0;
    while not EOF do
    begin
      inc(iRow);
      DRStrGrid_MgrGrp.Rows[iRow].Clear;
      DRStrGrid_MgrGrp.Cells[0,iRow] := Trim(FieldByName('GRP_NAME').asString);
      Next;
    end;   // end of while

    if RecordCount <= 1 then
    begin
      DRStrGrid_MgrGrp.RowCount := 2;
    end
    else
    begin
      DRStrGrid_MgrGrp.RowCount := iRow + 1;
    end;

    DRStrGrid_MgrGrp.Visible := True; //@@
  end;  // end of with
  Result := True;

end;

//------------------------------------------------------------------------------
//  Clear AllAccList (��ü����)
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.ClearAllAccList;
var
  I : Integer;
  AccItem : pTAllAccItem;
begin
  if not Assigned(AllAccList) then Exit;
  for I := 0 to AllAccList.Count -1 do
  begin
    AccItem := AllAccList.Items[I];
    Dispose(AccItem);
  end;
  AllAccList.Clear;
end;

//------------------------------------------------------------------------------
//  Clear GrpAccList (��ϰ���)
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.ClearGrpAccList;
var
  I : Integer;
  AccItem : pTSelectAccItem;
begin
  if not Assigned(GrpAccList) then Exit;
  for I := 0 to GrpAccList.Count -1 do
  begin
    AccItem := GrpAccList.Items[I];
    Dispose(AccItem);
  end;
  GrpAccList.Clear;
end;

//------------------------------------------------------------------------------
// ��ϰ��� List���� ����
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DelSelectData;
var
  AccItem      : pTSelectAccItem;
  SelAccIdx, SelAccCNT   : integer;
begin
  // Multi Select
  if DRListView_SelectAcc.SelCount > 0 then
  begin
    ClearGrpAccList;
    SelAccCNT   := (DRListView_SelectAcc.Items.Count - DRListView_SelectAcc.SelCount);               // ���ð��� Count
    SelAccIdx  := 0;          // ���ð��� Index

    while (SelAccCNT > 0) do
    begin
      if  not (DRListView_SelectAcc.Items[SelAccIdx].Selected) then   // ���õ� Data
      begin
        New(AccItem);
        GrpAccList.Add(AccItem);
        AccItem.FmtAccNo  := DRListView_SelectAcc.Items[SelAccIdx].Caption;
        AccItem.AccName    := DRListView_SelectAcc.Items[SelAccIdx].SubItems.Strings[0];  // ���¸�
        AccItem.ExceptFlag := DRListView_SelectAcc.Items[SelAccIdx].Checked;
        SelAccCNT := SelAccCNT - 1;
      end; // end of if
      SelAccIdx := SelAccIdx + 1;
      Next;
    end; // end of while
  end; // end of if

  ListViewSelectData;
end;


//------------------------------------------------------------------------------
//  �׷���� :  ��ü ���� ����Ʈ�� ����
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRListView_AllAccData(Sender: TObject;
  Item: TListItem);
var
  AccItem : pTAllAccItem;
begin
  inherited;
  AccItem := AllAccList.Items[Item.Index];
  Item.Caption   := AccITem.FmtAccNo;
  Item.SubItems.Add(AccItem.AccName);
  Item.SubItems.Add(AccItem.BookName);
  Item.SubItems.Add(AccITem.CompName);

end;

//------------------------------------------------------------------------------
// Mgr Grp - ���ð����� Duplication Check
//------------------------------------------------------------------------------
function TDlgForm_FRegGroup.DupDataDelete: boolean;
var
  I, Cnt     : integer;
  AccItem    : pTSelectAccItem;
  sFmtAccNo  : String;
begin
  Result    := False;
  sFmtAccNo := '';
  Cnt       := GrpAccList.Count;
  I         := 0;
  while Cnt > 0 do
  begin
    AccItem := GrpAccList.Items[I];
    // ���ϰ��°� �ƴѰ�츸 List����
    if  ((sFmtAccNo = AccItem.FmtAccNo)) then
    begin
      GrpAccList.Remove(AccItem);
      Cnt := Cnt -1;
    end  else
    begin
      sFmtAccNo   := AccItem.FmtAccNo;
      I := I + 1;
      Cnt := Cnt -1;
    end; // end of if
  end; // end of while
  Result := True;

end;

//------------------------------------------------------------------------------
//  SUAGPAC_TBL�� �ش� �׷� �����ϴ��� �Ǵ�
//------------------------------------------------------------------------------
function TDlgForm_FRegGroup.ExistInSUAGPAC: boolean;
begin
  Result := False;
  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' Select GRP_NAME '
          + ' From SUAGPAC_TBL '
          + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
          + '   and SEC_TYPE  = ''' + gcSEC_FUTURES + ''' '
          + '   and GRP_NAME = ''' +  Trim(DREdit_GrpName.Text) + ''' ');
    Try
      gf_ADOQueryOpen(ADOQuery_Temp);
    Except
      on E : Exception do
      begin  // DataBase ����
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SUGRPAD_TBL]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SUGRPAD_TBL]'); //Database ����
        Exit;
      end;
    End;

    if RecordCount > 0 then Result := True; // Data ����
  end; // end of with
end;



//------------------------------------------------------------------------------
// DRTreeView_MgrAcc Index Search
//------------------------------------------------------------------------------
function TDlgForm_FRegGroup.ExistInTreeViewMgrAcc(pGrpName: string): Integer;
var
  I : Integer;
begin
  Result := -1;
  for I := 0 to DRTreeView_MgrAcc.Items.Count -1 do
  begin
    if UpperCase(DRTreeView_MgrAcc.Items[I].Text) = UpperCase(pGrpName) then
    begin
      Result := I;
      Break;
    end;  // end of if
  end; // end of for
end;
//------------------------------------------------------------------------------
// DRTreeView_MgrGrp Index Search
//------------------------------------------------------------------------------
function  TDlgForm_FRegGroup.ExistListViewSelAcc(pFmtAccNo: string) : Integer;
var
  I : Integer;
  AccItem      : pTSelectAccItem;
begin
  Result := -1;
  if not Assigned(GrpAccList) then Exit;
  for I := 0 to GrpAccList.Count -1 do
  begin
    AccItem := GrpAccList.Items[I];

    if AccItem.FmtAccNo = pFmtAccNo then
    begin
      Result := I;
      Break;
    end;  // end of if
  end; // end of for
end;


//------------------------------------------------------------------------------
// DRTreeView_MgrGrp Index Search
//------------------------------------------------------------------------------
function TDlgForm_FRegGroup.ExistInGridMgrGrp(pGrpName: string): Integer;
var
  I : Integer;
begin
  Result := -1;
  for I := 1 to DRStrGrid_MgrGrp.RowCount -1 do
  begin
    if UpperCase(DRStrGrid_MgrGrp.Cells[0,I]) = UpperCase(pGrpName) then
    begin
      Result := I;
      Break;
    end;  // end of if
  end; // end of for
end;


//------------------------------------------------------------------------------
//  �׷���� : ��� ���� ����Ʈ�� ����
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.ListViewSelectData;
var
  I : Integer;
  AccItem : pTSelectAccItem;
  List_Item : TListItem;
  sFmtAccNo, sAccName : String;
begin
  inherited;
  DRListView_SelectAcc.Items.Clear;
  GrpAccList.Sort(MgrSelListCompare);
  if not DupDataDelete then Exit;

  sFmtAccNo := '';
  sAccName  := '';

  if GrpAccList.Count > 0 then
  begin
    for I := 0 to GrpAccList.Count -1 do
    begin
      AccItem   := GrpAccList.Items[I];
      List_Item := DRListView_SelectAcc.Items.Add;
      sFmtAccNo := AccItem.FmtAccNo;
      sAccName  := AccItem.AccName;
      List_Item.Caption  := sFmtAccNo;
      List_Item.SubItems.Add(sAccName);
      If AccItem.ExceptFlag then   List_Item.Checked := True;
    end;
  end;
end;

//------------------------------------------------------------------------------
// �ʼ��Է��׸� check (�׷����)
//------------------------------------------------------------------------------
function TDlgForm_FRegGroup.MgrGrpCheckKeyEditEmpty: boolean;
begin
  Result := True;

  // �׷��
  if Trim(DREdit_GrpName.Text) = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, ''); //�Է� ����
    DREdit_GrpName.SetFocus;
    Exit;
  end;


  if  DRListView_SelectAcc.Items.Count < 1 then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, ''); //�Է� ����
    DREdit_GrpName.SetFocus;
    Exit;
  end;

  Result := False;
end;


//------------------------------------------------------------------------------
//  �׷���� : ��ü ���¹�ȣ Query
//------------------------------------------------------------------------------
function TDlgForm_FRegGroup.QueryAllAcc: integer;
var
  AccItem      : pTAllAccItem;
begin

  Result  :=  0;
  with ADOQuery_Temp do
  begin
         // ��ü ���¹�ȣ
    Close;
    SQL.Clear;
    SQL.Add('  SELECT ACC_NO, SUB_ACC_NO = '''', ACC_NAME = ACC_NAME_KOR, PARTY_COMP = INV_COMP_CODE '
          + '        , PARTY_NAME = (SELECT ISNULL(COMP_NAME_KOR, '''')             '
          + '                        FROM SCCOMCD_TBL                               '
          + '                        WHERE SCCOMCD_TBL.COMP_CODE = SFACBIF_TBL.INV_COMP_CODE) '
          + '  FROM SFACBIF_TBL '
          + '  WHERE DEPT_CODE = ''' + gvDeptCode + ''' '
          + '  UNION '
          + '  SELECT ACC_NO, SUB_ACC_NO , ACC_NAME = SUB_NAME_KOR, PARTY_COMP = ''''  '
          + '        , PARTY_NAME = ''''                                               '
          + '  FROM SFSACIF_TBL '
          + '  WHERE DEPT_CODE = ''' + gvDeptCode + '''  '
          + '  ORDER BY ACC_NO, SUB_ACC_NO, ACC_NAME, PARTY_NAME');

    Try
      gf_ADOQueryOpen(ADOQuery_Temp);
    Except
      on E : Exception do
      begin  // DataBase ����
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Acc[SFACBIF_TBL]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Acc[SFACBIF_TBL]'); //Database ����
        Exit;
      end;
    End;

    while not Eof do
    begin
      New(AccItem);
      AllAccList.Add(AccItem);
      AccItem.FmtAccNo    :=  gf_FormatAccNo(Trim(FieldByName('ACC_NO').asString),
                                       Trim(FieldByName('SUB_ACC_NO').asString));
      AccItem.AccName  :=  Trim(FieldByName('ACC_NAME').asString);
      AccItem.AccComp  :=  Trim(FieldByName('PARTY_COMP').asString);
      AccItem.CompName :=  Trim(FieldByName('PARTY_NAME').asString);
      Next;
    end;   // end of while
    AllAccList.Sort(MgrAllListCompare);
  end;  // end of with

  Result  :=  AllAccList.Count;

end;


//------------------------------------------------------------------------------
// �׷���� : ��� ���� Query
//------------------------------------------------------------------------------
function TDlgForm_FRegGroup.QuerySelectAcc: boolean;
var
  AccItem      : pTSelectAccItem;
  sGrpName     : string;
  stmpStr      : string;
begin
  Result := False;
  sGrpName  := Trim(DREdit_GrpName.Text);

  ClearGrpAccList;
  with ADOQuery_Temp do
  begin
     // ��� ���¹�ȣ
    Close;
    SQL.Clear;
    SQL.Add(' SELECT AG.ACC_NO, AG.SUB_ACC_NO,  TMP.ACC_NAME,    ');
      if sCallFlag = gcSEND_FAX then
         SQL.Add('   AG.EXCEPT_FAX ')
      else
         SQL.Add('   AG.EXCEPT_EMAIL ');
    SQL.Add(' From SUAGPAC_TBL AG,                                                   '
          + '     (SELECT  AC.ACC_NO, SUB_ACC_NO = '''', ACC_NAME = AC.ACC_NAME_KOR '
          + '      FROM SFACBIF_TBL AC                                             '
          + '      WHERE AC.DEPT_CODE = ''' + gvDeptCode + '''                      '
          + '      UNION                                                           '
          + '      SELECT  SA.ACC_NO, SUB_ACC_NO = SA.SUB_ACC_NO, ACC_NAME = SA.SUB_NAME_KOR '
          + '      FROM SFSACIF_TBL SA                                              '
          + '      WHERE SA.DEPT_CODE = ''' + gvDeptCode + ''' ) TMP                '
          + ' WHERE AG.DEPT_CODE = ''' + gvDeptCode + '''                           '
          + '   AND AG.SEC_TYPE  = ''' + gcSEC_FUTURES + '''                         '
          + '   AND AG.GRP_NAME  =  ''' + sGrpName + '''                            '
          + '   AND AG.ACC_NO    = TMP.ACC_NO                                       '
          + '   AND AG.SUB_ACC_NO = TMP.SUB_ACC_NO                                  '
          + ' ORDER BY AG.ACC_NO, AG.SUB_ACC_NO                         ');

    Try
      gf_ADOQueryOpen(ADOQuery_Temp);
    Except
      on E : Exception do
      begin  // DataBase ����
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Acc[SUAGPAC_TBL]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Acc[SUAGPAC_TBL]'); //Database ����
        Exit;
      end;
    End;

    If RecordCount <= 0 then
    begin
      gf_ShowMessage(MessageBar, mtInformation, 1018, ''); //�ش� ������ �����ϴ�.
      Exit;
    end;

    while not Eof do
    begin
      New(AccItem);
      GrpAccList.Add(AccItem);
      AccItem.FmtAccNo := gf_formatAccNo(Trim(FieldByName('ACC_NO').asString),
                                         Trim(FieldByName('SUB_ACC_NO').asString));
      AccItem.AccName  := Trim(FieldByName('ACC_NAME').asString);

      if sCallFlag = gcSEND_FAX then
        stmpStr :=  Trim(FieldByName('EXCEPT_FAX').asString)
      else
        stmpStr :=  Trim(FieldByName('EXCEPT_EMAIL').asString);

      If stmpSTr= 'Y' then
        AccItem.ExceptFlag := True
      else
        AccItem.ExceptFlag := False;

      Next;
    end;   // end of while
    GrpAccList.Sort(MgrSelListCompare);
    Result := True;
  end;  // end of with
  ListViewSelectData;
end;

//------------------------------------------------------------------------------
// ���ܰ��� Check ǥ�� �ݿ�
//------------------------------------------------------------------------------
function TDlgForm_FRegGroup.SelectAccCheck: boolean;
var
  I : Integer;
  AccItem : pTSelectAccItem;
  List_Item : TListItem;
begin
  Result := False;
  for I := 0 to GrpAccList.Count -1 do
  begin
    AccItem   := GrpAccList.Items[I];
    List_Item :=  DRListView_SelectAcc.Items[I];
    AccItem.ExceptFlag := List_Item.Checked;
  end;
  Result := True;
end;

//------------------------------------------------------------------------------
//  �ش�׷��Ͽ� ���յǴ� TreeViewMgrAcc�� Index Return
//------------------------------------------------------------------------------
function TDlgForm_FRegGroup.SelectTreeViewMgrAcc(pGrpName: string): Integer;
var
  SelectIdx : Integer;
  PreSelected : boolean;
begin
  SelectIdx := ExistInTreeViewMgrAcc(pGrpName);
  if SelectIdx > -1 then  // DRTreeView_MgrGrp�� �ش� �׷� ����
  begin
    PreSelected := DRTreeView_MgrAcc.Items[SelectIdx].Selected;
    DRTreeView_MgrAcc.Items[SelectIdx].Selected := True;
    if PreSelected then // ������ Select�Ǿ��� ����
        DRTreeView_MgrAccChange(DRTreeView_MgrAcc,
                                DRTreeView_MgrAcc.Items[SelectIdx]);
  end;
  Result := SelectIdx;
end;

//------------------------------------------------------------------------------
// ��ȸ
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRBitBtn6Click(Sender: TObject);
begin
  inherited;
  gf_ShowMessage(MessageBar, mtInformation, 1020, ''); //��ȸ ���Դϴ�.
  Screen.Cursor := crHourGlass;
  QuerySelectAcc;
  Screen.Cursor := crDefault;
  gf_ShowMessage(MessageBar, mtInformation, 1021, ''); // ��ȸ �Ϸ�

end;

//------------------------------------------------------------------------------
// �Է�
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRBitBtn4Click(Sender: TObject);
var
  I       : Integer;
  AccItem :  pTSelectAccItem;
  AccNo, SubAccNo :string;
begin
  inherited;
  gf_ShowMessage(MessageBar, mtInformation, 1010, ''); //�Է� ���Դϴ�.

  if MgrGrpCheckKeyEditEmpty then Exit;   //�Է� ���� �׸� Ȯ��


  // ������ ��ϵǾ� �ִ��� Ȯ��
  if ExistInSUAGPAC then
  begin
//    SelectTreeViewGrpName(DREdit_GrpName.Text, false);
    DREdit_GrpName.SetFocus;
    gf_ShowMessage(MessageBar, mtError, 1024, ''); // �ش� �ڷᰡ �̹� �����մϴ�.
    Exit;
  end;
  SelectAccCheck;     // ���ܰ��� ǥ��
  DisableForm;
  //------------------
 //  gf_BeginTransaction;
  //------------------
  with ADOQuery_SUAGPAC do
  begin
     for I := 0 to GrpAccList.Count-1 do
     begin
        AccItem := GrpAccList.Items[I];
        gf_unformatAccNo(AccITem.FmtAccNo, AccNo, SubAccNo);

        //--- Insert SUACCAD_TBL
        Close;
        SQL.Clear;
        SQL.Add(' Insert SUAGPAC_TBL '
              + ' ( DEPT_CODE, SEC_TYPE, GRP_NAME, ACC_NO, SUB_ACC_NO, ');

        if sCallFlag = gcSEND_FAX then
           SQL.Add('   EXCEPT_FAX, ')
        else   SQL.Add('   EXCEPT_EMAIL, ');

        SQL.Add('   OPR_ID, OPR_DATE, OPR_TIME ) '
              + ' Values '
              + ' ( :pDeptCode, :pSecType, :pGrpName, :pAccNo, :pSubAccNo, :pExceptFlag, '
              + '   :pOprId, :pOprDate, :pOprTime )');
        // �μ��ڵ�
        Parameters.ParamByName('pDeptCode').Value := gvDeptCode;
        // �ֽı���
        Parameters.ParamByName('pSecType').Value  := gcSEC_FUTURES;
        // �׷��̸�
        Parameters.ParamByName('pGrpName').Value  := Trim(DREdit_GrpName.Text);
        // ���¹�ȣ
        Parameters.ParamByName('pAccNo').Value    := AccNo;
        // �ΰ��¹�ȣ
        Parameters.ParamByName('pSubAccNo').Value := SubAccNo;

        // ���ܰ���
        If AccItem.ExceptFlag Then
          Parameters.ParamByName('pExceptFlag').Value := 'Y'
        else
          Parameters.ParamByName('pExceptFlag').Value := 'N';

        // ������
        Parameters.ParamByName('pOprId').Value := gvOprUsrNo;
        // ��������
        Parameters.ParamByName('pOprDate').Value := gvCurDate;
        // ���۽ð�
        Parameters.ParamByName('pOprTime').Value := gf_GetCurTime;
        Try
          gf_ADOExecSQL(ADOQuery_SUAGPAC);
        Except
          on E : Exception do
          begin  // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, '[Insert]: ' + E.Message,0);
            gf_ShowMessage(MessageBar, mtError, 9001, '[Insert]'); //Database ����
    //          gf_RollBackTransaction;
            EnableForm;
            Exit;
          end;
        End;
     end; //end of for
  end;  // end of with
  //-------------------
//gf_CommitTransaction;
  //-------------------

//  if not GrpINSAccNo then exit;     //�׷쿡 ��ϵ� ���¹�ȣ
  if GrpFlag then
    BuildTreeViewMgrGrp
  else
    BuildTreeViewMgrAcc;

  EnableForm;
  SelectGridMgrGrp(DREdit_GrpName.Text);
  InputValueClear;
  DREdit_GrpName.SetFocus;
  gf_ShowMessage(MessageBar, mtInformation, 1011, ''); // �Է� �Ϸ�
end;

//------------------------------------------------------------------------------
// ����
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRBitBtn3Click(Sender: TObject);
var
  sDelAccList : TStringList; //Delete �ؾ��� Acc List

//-------------------------
// �׷��� ���� ���� Select
//-------------------------
function SelectAccNo(AccItem : pTSelectAccItem; sGrpName : string): boolean;
var
   AccNo, SubAccNo : string;
begin
  Result := False;
  gf_UnformatAccNo(AccITem.FmtAccNo, AccNO, SubAccno);
  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('  Select ACC_NO, SUB_ACC_NO ');
    SQL.Add('  From   SUAGPAC_TBL '
          + '  Where DEPT_CODE = ''' + gvDeptCode + '''     '
          + '  And   SEC_TYPE  = ''' + gcSEC_FUTURES + '''  '
          + '  And   GRP_NAME  = ''' + sGrpName + '''       '
          + '  And   ACC_NO    = ''' + AccNO   + '''       '
          + '  And   SUB_ACC_NO = ''' + SubAccno   + '''       '
          + '  Order By ACC_NO, SUB_ACC_NO ' );

    Try
      gf_ADOQueryOpen(ADOQuery_Temp);
    Except
      on E : Exception do
      begin  // DataBase ����
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Acc[SUAGPAC_TBL]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Acc[SUAGPAC_TBL]'); //Database ����
        Exit;
      end;
    End;
    If RecordCount <= 0 then
      Result := True;   // Insert
  end; // end of with
end;

//-------------------------
// �׷��� Delete �ؾ��� ���¹�ȣ�� List  ����
//-------------------------
procedure CreateDelAccList(sGrpName : string);
var
   FmtAccNo : string;
begin
  with ADOQuery_SUAGPAC do
  begin
    Close;
    SQL.Clear;
    SQL.Add('  Select ACC_NO, SUB_ACC_NO  ');
    SQL.Add('  From   SUAGPAC_TBL '
          + '  Where DEPT_CODE = ''' + gvDeptCode + '''     '
          + '  And   SEC_TYPE  = ''' + gcSEC_FUTURES + '''  '
          + '  And   GRP_NAME  = ''' + sGrpName + '''       '
          + '  Order By ACC_NO, SUB_ACC_NO ' );

    Try
      gf_ADOQueryOpen(ADOQuery_SUAGPAC);
    Except
      on E : Exception do
      begin  // DataBase ����
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Acc[SUAGPAC_TBL All Query]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Acc[SUAGPAC_TBL All Query]'); //Database ����
        Exit;
      end;
    End;
    // ���̺��� �ְ� list���� ���� ��� (Delete)
    if RecordCount > 0 then
      sDelAccList := TStringList.Create;
    while not EOF do
    begin
      FmtAccNo := gf_formatAccNo(Trim(FieldByName('ACC_NO').asString),
                                 Trim(FieldByName('SUB_ACC_NO').asString));
      if ExistListViewSelAcc(FmtAccNo) = -1 then
      begin
        if Assigned(sDelAccList) then
          sDelAccList.Add(FmtAccNo);
      end;
      Next;
    end; // end of while
  end;  // end of with
end;

//-------------------------
// �׷��� ���� ���¹�ȣ Delete
//-------------------------
procedure DeleteAccNo(sFmtAccNo: string; sGrpName : string);
var
  AccNo, SubAccNo : string;
begin
  gf_unformatAccNo(sFmtAccNo, Accno, Subaccno);
  with ADOQuery_SUAGPAC do
  begin
    //--- Delete SUACCAD_TBL
    Close;
    SQL.Clear;
    SQL.Add(' Delete SUAGPAC_TBL '
          + ' Where DEPT_CODE = ''' + gvDeptCode + ''''
          + '   and SEC_TYPE  = ''' + gcSEC_FUTURES + ''''
          + '   and GRP_NAME  = ''' + sGrpName + ''' '
          + '   and ACC_NO    = ''' + Accno   + ''' '
          + '   and SUB_ACC_NO =  ''' + Subaccno   + ''' ');

    Try
      gf_ADOExecSQL(ADOQuery_SUAGPAC);
    Except
      on E : Exception do
      begin  // DataBase ����
        gf_ShowErrDlgMessage(Self.Tag, 9001, '[Delete]: ' + E.Message,0);
        gf_ShowMessage(MessageBar, mtError, 9001, '[Delete]'); //Database ����
//        gf_RollBackTransaction;
        EnableForm;
        Exit;
      end;
    End;

  end;  // end of with
end;

//-------------------------
// �׷��� ���� ���¹�ȣ Insert
//-------------------------
procedure InsertAccNo(AccItem : pTSelectAccItem; sGrpName : string);
var
  AccNo, SubAccNo : string;
begin
  gf_unformatAccNo(AccItem.FmtAccNo, Accno, Subaccno);
  with ADOQuery_SUAGPAC do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' Insert SUAGPAC_TBL '
          + ' ( DEPT_CODE, SEC_TYPE, GRP_NAME, ACC_NO, SUB_ACC_NO, ');
    if sCallFlag = gcSEND_FAX then
       SQL.Add('   EXCEPT_FAX, ')
    else
       SQL.Add('   EXCEPT_EMAIL, ');
    SQL.Add('   OPR_ID, OPR_DATE, OPR_TIME ) '
          + ' Values '
          + ' ( :pDeptCode, :pSecType, :pGrpName, :pAccNo, :pSubAccNo, :pExceptFlag, '
          + '   :pOprId, :pOprDate, :pOprTime )');
    // �μ��ڵ�
    Parameters.ParamByName('pDeptCode').Value := gvDeptCode;
    // �ֽı���
    Parameters.ParamByName('pSecType').Value  := gcSEC_FUTURES;
    // �׷��̸�
    Parameters.ParamByName('pGrpName').Value  := sGrpName;
    // ���¹�ȣ
    Parameters.ParamByName('pAccNo').Value    := AccNo;
    // �ΰ��¹�ȣ
    Parameters.ParamByName('pSubAccNo').Value := SubAccNo;

    // ���ܰ���
    If AccItem.ExceptFlag Then
      Parameters.ParamByName('pExceptFlag').Value := 'Y'
    else
      Parameters.ParamByName('pExceptFlag').Value := 'N';

    // ������
    Parameters.ParamByName('pOprId').Value := gvOprUsrNo;
    // ��������
    Parameters.ParamByName('pOprDate').Value := gvCurDate;
    // ���۽ð�
    Parameters.ParamByName('pOprTime').Value := gf_GetCurTime;
    Try
      gf_ADOExecSQL(ADOQuery_SUAGPAC);
    Except
      on E : Exception do
      begin  // DataBase ����
        gf_ShowErrDlgMessage(Self.Tag, 9001, '[���º� Insert]: ' + E.Message,0);
        gf_ShowMessage(MessageBar, mtError, 9001, '[���º�Insert]'); //Database ����
//        gf_RollBackTransaction;
        EnableForm;
        Exit;
      end;
    End;
  end; //end of with
end;

//-------------------------
// �׷��� ���� ���¹�ȣ Update
//-------------------------
procedure UpdateAccNo(AccItem : pTSelectAccItem; sGrpName : string);
var
  AccNo, SubAccNo : string;
begin
  gf_unformatAccNo(AccItem.FmtAccNo, Accno, Subaccno);
  with ADOQuery_SUAGPAC do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' Update SUAGPAC_TBL Set ');
    if sCallFlag = gcSEND_FAX then
    SQL.Add('   EXCEPT_FAX = :pExceptFlag, ')
    else
    SQL.Add('   EXCEPT_EMAIL = :pExceptFlag, ');

    SQL.Add('   OPR_ID = :pOprId, OPR_DATE = :pOprDate, OPR_TIME = :pOprTime '
          + ' Where DEPT_CODE = :pDeptCode '
          + '   and SEC_TYPE  = :pSecType  '
          + '   and GRP_NAME  = :pGrpName  '
          + '   and ACC_NO    = :pAccNo '
          + '   and SUB_ACC_NO = :pSubAccNo ');
    // �μ��ڵ�
    Parameters.ParamByName('pDeptCode').Value := gvDeptCode;
    // �ֽı���
    Parameters.ParamByName('pSecType').Value  := gcSEC_FUTURES;
    // �׷��̸�
    Parameters.ParamByName('pGrpName').Value  := sGrpName;
    // ���¹�ȣ
    Parameters.ParamByName('pAccNo').Value    := AccNo;
    // �ΰ��¹�ȣ
    Parameters.ParamByName('pSubAccNo').Value := SubAccNo;
    // ���ܰ���
    if AccItem.ExceptFlag then
      Parameters.ParamByName('pExceptFlag').Value    := 'Y'
    else
      Parameters.ParamByName('pExceptFlag').Value    := 'N';
    // ������
    Parameters.ParamByName('pOprId').Value := gvOprUsrNo;
    // ��������
    Parameters.ParamByName('pOprDate').Value := gvCurDate;
    // ���۽ð�
    Parameters.ParamByName('pOprTime').Value := gf_GetCurTime;
    Try
      gf_ADOExecSQL(ADOQuery_SUAGPAC);
    Except
      on E : Exception do
      begin  // DataBase ����
        gf_ShowErrDlgMessage(Self.Tag, 9001, '[Update]: ' + E.Message,0);
        gf_ShowMessage(MessageBar, mtError, 9001, '[Update]'); //Database ����
//        gf_RollBackTransaction;
        EnableForm;
        Exit;
      end;
    End;
  end; // end of with
end;


var
  I        : Integer;
  AccItem  :  pTSelectAccItem;
  sGrpName : string;
begin
  inherited;
  sGrpName := Trim(DREdit_GrpName.Text);
  gf_ShowMessage(MessageBar, mtInformation, 1007, ''); //���� ���Դϴ�.
  if MgrGrpCheckKeyEditEmpty then Exit;   //�Է� ���� �׸� Ȯ��

  // �׷��� ������ ��ϵǾ� �ִ��� Ȯ��
  if Not ExistInSUAGPAC then
  begin
    gf_ShowMessage(MessageBar, mtError, 1025, ''); //�ش� �ڷᰡ �������� �ʽ��ϴ�.
    DREdit_GrpName.SetFocus;
    Exit;
  end;

  SelectAccCheck;
  DisableForm;
  //�������� ����
  //------------------
//  gf_BeginTransaction;
  //------------------
  // 1. Delete : ����List���� ������ �����Ͱ� ���̺� �ִ� ��� ����
  CreateDelAccList(sGrpName);       // AccList �� ���̺�� ���Ͽ� ���� ���� List ����
  if Assigned(sDelAcclist) then
  begin
    for I:= 0 to sDelAccList.Count-1 do
    begin
      DeleteAccNo(sDelAccList.Strings[I], sGrpName);
    end; // end of for
    sDelAccList.Free
  end; // end of if

  // 2. Update : ���̺� ���� ���´� Insert�ϰ� �̹� �ִ� ���´� Update
  for I := 0 to GrpAccList.Count-1 do
  begin
    AccItem := GrpAccList.Items[I];
    if SelectAccNo(AccItem, sGrpName) then
      InsertAccNo(AccItem, sGrpName)
    else
      UpdateAccNo(AccItem, sGrpName);
  end; //end of for
  //-------------------
//gf_CommitTransaction;
  //-------------------

//  if not GrpINSAccNo then exit;             //�׷쿡 ��ϵ� ���¹�ȣ
  if GrpFlag then
    BuildTreeViewMgrGrp
  else
    BuildTreeViewMgrAcc;

  EnableForm;
  if GrpFlag then
    SelectGridMgrGrp(sGrpName)
  else
    SelectTreeViewMgrAcc(sGrpName);

  SelectGridMgrGrp(DREdit_GrpName.Text);
  InputValueClear;
  DREdit_GrpName.SetFocus;
  gf_ShowMessage(MessageBar, mtInformation, 1008, ''); // ���� �Ϸ�
end;


//------------------------------------------------------------------------------
// ����
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRBitBtn2Click(Sender: TObject);
var
  iUsedEMailGrpCnt, iUsedFaxTlxGrpCnt: integer;
  UsedList : String;
begin
  inherited;
  gf_ShowMessage(MessageBar, mtInformation, 1005, ''); //���� ���Դϴ�.

  // �׷��
  if Trim(DREdit_GrpName.Text) = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, ''); //�Է� ����
    DREdit_GrpName.SetFocus;
    Exit;
  end;

  // ������ ��ϵǾ� �ִ��� Ȯ��
  if Not ExistInSUAGPAC then
  begin
    gf_ShowMessage(MessageBar, mtError, 1025, ''); //�ش� �ڷᰡ �������� �ʽ��ϴ�.
    DREdit_GrpName.SetFocus;
    Exit;
  end;

  UsedList := '';
  DisableForm;
  with ADOQuery_SUAGPAC do
  begin
      //--- SUGPMEL_TBL����  �ش� �׷��� ���Ǵ��� Ȯ��
      Close;
      SQL.Clear;
      SQL.Add(' Select GRP_NAME,SEC_TYPE  '
            + ' From SUGPMEL_TBL  '
            + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
            + '   AND SEC_TYPE  = ''' + gcSEC_FUTURES + ''' '
            + '   and GRP_NAME = ''' + Trim(DREdit_GrpName.Text) + ''' '
            + ' Group by GRP_NAME, SEC_TYPE '  );
      Try
         gf_ADOQueryOpen(ADOQuery_SUAGPAC);
      Except
         on E : Exception do
         begin // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUMELAD[SUGPMEL_TBL SELECT]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUMELAD[SUGPMEL_TBL SELECT]'); //Database ����
            EnableForm;
            Exit;
         end;
      End;

      iUsedEMailGrpCnt := RecordCount;
      if iUsedEMailGrpCnt > 0 then
         UsedList :=  '  - EMail ����ó ����' + Chr(13);

      //--- SUGRPAD_TBL����  �ش� �׷��� ���Ǵ��� Ȯ��
      Close;
      SQL.Clear;
      SQL.Add(' Select GRP_NAME,SEC_TYPE  '
            + ' From SUGRPAD_TBL  '
            + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
            + '   AND SEC_TYPE  = ''' + gcSEC_FUTURES + ''' '
            + '   and GRP_NAME = ''' + Trim(DREdit_GrpName.Text) + ''' '
            + ' Group by GRP_NAME, SEC_TYPE '  );
      Try
         gf_ADOQueryOpen(ADOQuery_SUAGPAC);
      Except
         on E : Exception do
         begin // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUMELAD[SUGRPAD_TBL SELECT]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUMELAD[SUGRPAD_TBL SELECT]'); //Database ����
            EnableForm;
            Exit;
         end;
      End;

      iUsedFaxTlxGrpCnt := RecordCount;
      if iUsedFaxTlxGrpCnt > 0 then
         UsedList := UsedList + '  - Fax/Telex ����ó ����'+ Chr(13);
      
      if (iUsedEMailGrpCnt > 0) or (iUsedFaxTlxGrpCnt > 0)then // Data �ִ� ���
      begin
         if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 1150, //�ش� �׷��� ����ó�� ��ϵǾ� �ֽ��ϴ�.
            UsedList + Chr(13) + ' �����Ͻðڽ��ϱ�? ',
            [mbYes, mbCancel], 0) = idCancel then
         begin
            gf_ShowMessage(MessageBar, mtInformation, 1082, ''); //�۾��� ��ҵǾ����ϴ�.
            EnableForm;
            Exit;
         end;
      end; // end of if
  end;

  with ADOCommand1 do
  begin
      //------------------
      gf_BeginTransaction;
      //------------------
      //--- Delete SUACCAD_TBL
      CommandText :=      
              ' Delete SUAGPAC_TBL '
            + ' Where DEPT_CODE = ''' + gvDeptCode + ''''
            + '   and SEC_TYPE  = ''' + gcSEC_FUTURES + ''''
            + '   and GRP_NAME  = ''' + Trim(DREdit_GrpName.Text) + '''';

      Try
        Execute;
      Except
        on E : Exception do
        begin  // DataBase ����
          gf_ShowErrDlgMessage(Self.Tag, 9001, '[Delete]: ' + E.Message,0);
          gf_ShowMessage(MessageBar, mtError, 9001, '[Delete]'); //Database ����
          gf_RollBackTransaction;
          EnableForm;
          Exit;
        end;
      End;

      if iUsedEMailGrpCnt > 0 then  // ���׷� �ִ� ���
      begin
         //--- Delete SUGPMAD_TBL
         CommandText :=
                 ' Delete SUGPMAD_TBL  '
               + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
               + '   and SEC_TYPE  = ''' + gcSEC_FUTURES + '''  '
               + '   and GRP_NAME  = ''' + Trim(DREdit_GrpName.Text) + '''';
         Try
            Execute;
         Except
            on E : Exception do
            begin // DataBase ����
               gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Delete SUGPMAD_TBL]: ' + E.Message, 0);
               gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Delete SUGPMAD_TBL]'); //Database ����
               gf_RollBackTransaction;
               EnableForm;
               Exit;
            end;
         End;
         //--- Delete SUGPMEL_TBL
         CommandText :=
                 ' Delete SUGPMEL_TBL '
               + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
               + '   and SEC_TYPE  = ''' + gcSEC_FUTURES + '''  '
               + '   and GRP_NAME  = ''' + Trim(DREdit_GrpName.Text) + '''';
         Try
            Execute;
         Except
            on E : Exception do
            begin // DataBase ����
               gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Delete SUGPMEL_TBL]: ' + E.Message, 0);
               gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Delete SUGPMEL_TBL]'); //Database ����
               gf_RollBackTransaction;
               EnableForm;
               Exit;
            end;
         End;
      end;

      if iUsedFaxTlxGrpCnt > 0 then  // ���׷� �ִ� ���
      begin
         //--- Delete SUGPRPT_TBL
         CommandText :=
                 ' Delete SUGPRPT_TBL  '
               + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
               + '   and SEC_TYPE  = ''' + gcSEC_FUTURES + '''  '
               + '   and GRP_NAME  = ''' + Trim(DREdit_GrpName.Text) + '''';
         Try
            Execute;
         Except
            on E : Exception do
            begin // DataBase ����
               gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Delete SUGPRPT_TBL]: ' + E.Message, 0);
               gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Delete SUGPRPT_TBL]'); //Database ����
               gf_RollBackTransaction;
               EnableForm;
               Exit;
            end;
         End;
         //--- Delete SUGPMEL_TBL
         CommandText :=
                 ' Delete SUGRPAD_TBL '
               + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
               + '   and SEC_TYPE  = ''' + gcSEC_FUTURES + '''  '
               + '   and GRP_NAME  = ''' + Trim(DREdit_GrpName.Text) + '''';
         Try
            Execute;
         Except
            on E : Exception do
            begin // DataBase ����
               gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Delete SUGPMEL_TBL]: ' + E.Message, 0);
               gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Delete SUGPMEL_TBL]'); //Database ����
               gf_RollBackTransaction;
               EnableForm;
               Exit;
            end;
         End;
      end;
      //-------------------
      gf_CommitTransaction;
      //-------------------
    end;  // end of with
//  if not GrpINSAccNo then exit;             //�׷쿡 ��ϵ� ���¹�ȣ
  if GrpFlag then
    BuildTreeViewMgrGrp
  else
    BuildTreeViewMgrAcc;
  EnableForm;
  InputValueClear;
  DREdit_GrpName.SetFocus;
  gf_ShowMessage(MessageBar, mtInformation, 1006, '' ); // ���� �Ϸ�
end;



//------------------------------------------------------------------------------
//  TreeView�� ���¹�ȣ ���ý�
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRTreeView_MgrAccChange(Sender: TObject;
  Node: TTreeNode);
var
  iMgrGrpIdx : Integer;
  AccItem      : pTSelectAccItem;
  stmpStr : string;
begin
  inherited;
  if not Assigned(DRTreeView_MgrAcc.Selected) then Exit;
  Screen.Cursor := crHourGlass;   //���콺 �𷡽ð�
  gf_ShowMessage(MessageBar, mtInformation, 1020, ''); //��ȸ ���Դϴ�.

  if DRTreeView_MgrAcc.Selected.Level = 0 then // ���� ����
    DREdit_GrpName.Text := ''
  else  begin
    iMgrGrpIdx := DRTreeView_MgrAcc.Selected.AbsoluteIndex;
    DREdit_GrpName.Text := DRTreeView_MgrAcc.Items[iMgrGrpIdx].Text;
  end;

  //Clear
  DREdit_MgrOprId.Text   := '';
  DREdit_MgrOprTime.Text := '';
  ClearGrpAccList;

  // �ش� �׷��Ͽ� ���� ��ϰ��� Query
  with ADOQuery_Temp do
  begin
     // ��� ���¹�ȣ
    Close;
    SQL.Clear;
    SQL.Add(' SELECT AG.ACC_NO, AG.SUB_ACC_NO,  TMP.ACC_NAME,    ');
      if sCallFlag = gcSEND_FAX then
         SQL.Add('   AG.EXCEPT_FAX, ')
      else
         SQL.Add('   AG.EXCEPT_EMAIL, ');
    SQL.Add('      AG.OPR_ID, AG.OPR_DATE, AG.OPR_TIME             '
          + ' From SUAGPAC_TBL AG,                                                   '
          + '     (SELECT  AC.ACC_NO, SUB_ACC_NO = '''', ACC_NAME = AC.ACC_NAME_KOR '
          + '      FROM SFACBIF_TBL AC                                             '
          + '      WHERE AC.DEPT_CODE = ''' + gvDeptCode + '''                      '
          + '      UNION                                                           '
          + '      SELECT  SA.ACC_NO, SUB_ACC_NO = SA.SUB_ACC_NO, ACC_NAME = SA.SUB_NAME_KOR '
          + '      FROM SFSACIF_TBL SA                                              '
          + '      WHERE SA.DEPT_CODE = ''' + gvDeptCode + ''' ) TMP                '
          + ' WHERE AG.DEPT_CODE = ''' + gvDeptCode + '''                           '
          + '   AND AG.SEC_TYPE  = ''' + gcSEC_FUTURES + '''                         '
          + '   AND AG.GRP_NAME  =  ''' + Trim(DREdit_GrpName.Text)  + '''                            '
          + '   AND AG.ACC_NO    = TMP.ACC_NO                                       '
          + '   AND AG.SUB_ACC_NO = TMP.SUB_ACC_NO                                  '
          + ' ORDER BY AG.ACC_NO, AG.SUB_ACC_NO                         ');
    Try
       gf_ADOQueryOpen(ADOQuery_Temp);
    Except  // DataBase �����Դϴ�.
       On E: Exception do
       begin
          gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SUAGPAC]: ' + E.Message, 0);
          gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SUAGPAC]');
          Exit;
       end;
    End;
    // ������
    DREdit_MgrOprId.Text := Trim(FieldByName('OPR_ID').asString);

    // ���۽ð�
    DREdit_MgrOprTime.Text := gf_FormatDate(Trim(FieldByName('OPR_DATE').asString))
                              + ' ' + gf_FormatTime(Trim(FieldByName('OPR_TIME').asString));
    // ��ϰ��� List ����
    while not Eof do
    begin
       New(AccItem);
       GrpAccList.Add(AccItem);
       AccItem.FmtAccNo := gf_FormatAccNo(Trim(FieldByName('ACC_NO').asString),
                                          Trim(FieldByName('SUB_ACC_NO').asString));
       AccItem.AccName  :=  Trim(FieldByName('ACC_NAME').asString);
       if sCallFlag = gcSEND_FAX then
          stmpStr := Trim(FieldByName('EXCEPT_FAX').asString)
       else if  sCallFlag = gcSEND_EMAIL then
          stmpStr := Trim(FieldByName('EXCEPT_EMAIL').asString);
       if  stmpStr = 'Y' then
         AccItem.ExceptFlag := True
       else
         AccItem.ExceptFlag := False;

       Next;
    end;   // end of while
    ListViewSelectData;
  end; // end of with
  Screen.Cursor := crDefault;   //���콺 ȭ��ǥ
  gf_ShowMessage(MessageBar, mtInformation, 1021, ''); //��ȸ �Ϸ�
end;



//------------------------------------------------------------------------------
//  ���¹�ȣ/�׷�� Search Toggle
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRSpeedButton_FindAccClick(Sender: TObject);
begin
  inherited;
  GrpFlag := Not GrpFlag;
  if Not GrpFlag then //���º�
  begin
    gf_ShowMEssage(MessageBar,mtInformation,0,'���º� �׷��� ��ȸ���Դϴ�.');
    DRSpeedButton_FindAcc.Hint := '�׷��Ϻ� ����';
    DRPanel6.Caption := '  >> ���º� �׷� ���';
    DRTreeView_MgrAcc.Visible := True;
    DRStrGrid_MgrGrp.Visible := False;
    BuildTreeViewMgrAcc;
  end  else //�׷캰
  begin
    gf_ShowMEssage(MessageBar,mtInformation,0,'�׷��� ��ȸ���Դϴ�.');
    DRSpeedButton_FindAcc.Hint := '���¹�ȣ�� ����';
    DRPanel6.Caption := '  >> �׷� ���';
    DRTreeView_MgrAcc.Visible := False;
    DRStrGrid_MgrGrp.Visible := True;    
    BuildTreeViewMgrGrp;
  end;
  gf_ShowMEssage(MessageBar,mtInformation,0,'��ȸ�Ϸ�');

end;

//------------------------------------------------------------------------------
// ���ܰ��� ��ü ���ý�
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRCheckBox_ExcepAllClick(Sender: TObject);
var
  I : Integer;
  List_Item : TListItem;
begin
  inherited;
  for I := 0 to GrpAccList.Count -1 do
  begin
    List_Item :=  DRListView_SelectAcc.Items[I];
    List_Item.Checked := DRCheckBox_ExcepAll.Checked;
  end;

end;


//------------------------------------------------------------------------------
// ���� ���� sorting
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRListView_SelectAccColumnClick(
  Sender: TObject; Column: TListColumn);
var
  iCol : integer;
begin
  inherited;
  iCol := Column.Index;

  Screen.Cursor := crHourGlass;
  MgrSelSortIdx := iCol;
  MgrSelSortFlag[iCol] := not MgrSelSortFlag[iCol];
  GrpAccList.Sort(MgrSelListCompare);
  ListViewSelectData;
  Screen.Cursor := crDefault;
end;


//------------------------------------------------------------------------------
//  DragDrop
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRListView_SelectAccDragDrop(Sender,
  Source: TObject; X, Y: Integer);
begin
  inherited;
  If Source = DRListView_AllAcc then AddSelectData;
end;

procedure TDlgForm_FRegGroup.DRListView_SelectAccDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  If Source = DRListView_AllAcc then
    Accept := True
  else
    Accept := False;
end;

procedure TDlgForm_FRegGroup.DRListView_SelectAccEndDrag(Sender,
  Target: TObject; X, Y: Integer);
begin
  inherited;
  DRListView_AllAcc.OnData := DRListView_AllAccData;
  if Target <> nil then DRListView_SelectAcc.Update;
end;

procedure TDlgForm_FRegGroup.DRListView_SelectAccMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then  { ���ʹ�ư�� ������ ���� �巢���� }
    DRListView_SelectAcc.BeginDrag(False);  { �ִٸ� �巢�� �����Ѵ�. }
end;



//------------------------------------------------------------------------------
// ��ü ���� sorting
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRListView_AllAccColumnClick(Sender: TObject;
  Column: TListColumn);
var
  iCol : integer;
begin
  inherited;
  iCol := Column.Index;

  DRListView_AllAcc.OnData := nil ; //Event �߻� ����
  Screen.Cursor := crHourGlass;
  MgrAllSortIdx := iCol;
  MgrAllSortFlag[iCol] := not MgrAllSortFlag[iCol];
  AllAccList.Sort(MgrAllListCompare);
  DRListView_AllAcc.OnData := DRListView_AllAccData ;
  DRListView_AllAcc.Refresh;
  Screen.Cursor := crDefault;
end;

//------------------------------------------------------------------------------
//  DragDrop
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRListView_AllAccDragDrop(Sender,
  Source: TObject; X, Y: Integer);
begin
  inherited;
  If Source = DRListView_SelectAcc then   DelSelectData;
  DRListView_AllAcc.OnData := nil;
end;

procedure TDlgForm_FRegGroup.DRListView_AllAccDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  If Source = DRListView_SelectAcc then
    Accept := True
  else
    Accept := False;

end;

procedure TDlgForm_FRegGroup.DRListView_AllAccEndDrag(Sender,
  Target: TObject; X, Y: Integer);
begin
  inherited;
  if Target <> nil then DRListView_AllAcc.Update;
end;

procedure TDlgForm_FRegGroup.DRListView_AllAccMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then  { ���ʹ�ư�� ������ ���� Drag���� }
    DRListView_AllAcc.BeginDrag(False);  { �ִٸ� Drag�� �����Ѵ�. }

end;


//------------------------------------------------------------------------------
// ��ü���¿��� ���ð��·� �߰�
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRSpeedBtn_InsertClick(Sender: TObject);
begin
  inherited;
  AddSelectData;
end;

//------------------------------------------------------------------------------
// ��ü���¿��� ���ð��·� ����
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRSpeedBtn_DeleteClick(Sender: TObject);
begin
  inherited;
  DelSelectData;
end;

//------------------------------------------------------------------------------
//  �� Ȱ��ȭ �ɶ�.
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.FormActivate(Sender: TObject);
begin
  inherited;

  if DefCallFlag = gcSEND_FAX then
  begin
    sCallFlag  := gcSEND_FAX;
    DlgForm_FRegGroup.Caption := 'Fax Group ���';
  end else
  begin
    sCallFlag  := gcSEND_EMAIL;
    DlgForm_FRegGroup.Caption := 'Email Group ���';
  end;
  DREdit_AccNo.Text := gf_FormatAccNo(DefAccNO, DefSubAccNo);
  if (DefAccNo > '') then //add 20050907
  begin
     DRListView_AllAcc.OnData := nil ; //Event �߻� ����

     AccSearch(DREdit_AccNo.text);
     DRListView_AllAcc.Items.Count := AllAccList.Count;//QueryAllAcc;

     AllAccList.Sort(MgrAllListCompare);
     DRListView_AllAcc.OnData := DRListView_AllAccData ;
     DRListView_AllAcc.Refresh;

     if DRListView_AllAcc.Items.Count = 1 then //1���� �ٷ� Select View��
     begin
       DRListView_AllAcc.Selected := DRListView_AllAcc.Items[0];
       AddSelectData;
     end;
  end;
  
  if Trim(DefGrpName) = '' then  exit;  // Default Data ���� ���
  DREdit_GrpName.Text := DefGrpName;
  DREdit_AccNo.SetFocus;
  SelectGridMgrGrp(DefGrpName);
end;

//------------------------------------------------------------------------------
// ���õ� ���� �����
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRListView_SelectAccKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_DELETE then  //DeleteKey
    DelSelectData;
end;

//------------------------------------------------------------------------------
// ���õ� ���� �߰�
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRListView_AllAccDblClick(Sender: TObject);
begin
  inherited;
  AddSelectData;
end;

//------------------------------------------------------------------------------
// ���õ� ���� ���� Ŭ���ϸ� �����
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRListView_SelectAccDblClick(Sender: TObject);
begin
  inherited;
  DelSelectData;
end;

//------------------------------------------------------------------------------
// �׷�� enter
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DREdit_GrpNameKeyPress(Sender: TObject;var Key: Char);
var
  tmpGrpName : string;

begin
  inherited;

{  GrpName := Trim(DREdit_GrpName.Text);

      If (Pos(#34,GrpName) > 0) or
         (Pos(#42,GrpName) > 0) or
         (Pos(#47,GrpName) > 0) or
         (Pos(#58,GrpName) > 0) or
         (Pos(#60,GrpName) > 0) or
         (Pos(#62,GrpName) > 0) or
         (Pos(#63,GrpName) > 0) or
         (Pos(#92,GrpName) > 0) or
         (Pos(#124,GrpName) > 0) or Then
         Application.MessageBox(
             pChar('���� �̸��� ���� ���ڰ� �� �� �����ϴ�.' + #13#10 + #13#10 +
             '/ : * ? " < > |'),
             '�˸�',
             MB_OK);
}
   if (Key = #34) or (Key = #39) or
      (Key = #42) or (Key = #47) or
      (Key = #58) or (Key = #60) or
      (Key = #62) or (Key = #63) or
      (Key = #92) or (Key = #124)then
   begin
     Key:=#0 ;
     gf_ShowMessage(MessageBar, mtError, 1012, '�ش繮��(/ : * ? " < > |)�� �׷������ ����Ҽ� �����ϴ�.'); //�Է� ����
   end
   else if Key = #13 then
   begin
     tmpGrpName := Trim(DREdit_GrpName.Text);
     InputValueClear;
     DREdit_GrpName.Text := TmpGrpName;
     SelectGridMgrGrp(tmpGrpName);
     DREdit_AccNo.SetFocus;
   end;
end;

procedure TDlgForm_FRegGroup.InputValueClear;
begin
   ClearGrpAccList;
   DREdit_GrpName.Clear;
   DREdit_MgrOprId.Clear;
   DREdit_MgrOprTime.Clear;
//   DRUserDblCodeCombo_GrpAcc.Clear;
   DRCheckBox_ExcepAll.Checked := false;
   DRListView_SelectAcc.Items.Clear;
end;

procedure TDlgForm_FRegGroup.DRStrGrid_MgrGrpSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  SelMgrGrpRow := ARow;
end;

procedure TDlgForm_FRegGroup.DRStrGrid_MgrGrpDblClick(Sender: TObject);
var
  iMgrGrpIdx : Integer;
  AccItem    : pTSelectAccItem;
  stmpStr    : string;
begin
  inherited;
  if DRStrGrid_MgrGrp.Cells[0,SelMgrGrpRow] = '' then Exit;

  gf_ClearMessage(MessageBar);
  Screen.Cursor := crHourGlass;   //���콺 �𷡽ð�

  DREdit_GrpName.Text := DRStrGrid_MgrGrp.Cells[0,SelMgrGrpRow];
  //Clear
  DREdit_MgrOprId.Text   := '';
  DREdit_MgrOprTime.Text := '';
  ClearGrpAccList;

  // �ش� �׷��Ͽ� ���� ��ϰ��� Query
  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' SELECT AG.ACC_NO, AG.SUB_ACC_NO,  TMP.ACC_NAME,    ');
      if sCallFlag = gcSEND_FAX then
         SQL.Add('   AG.EXCEPT_FAX, ')
      else
         SQL.Add('   AG.EXCEPT_EMAIL, ');
    SQL.Add('      AG.OPR_ID, AG.OPR_DATE, AG.OPR_TIME             '
          + ' From SUAGPAC_TBL AG,                                                   '
          + '     (SELECT  AC.ACC_NO, SUB_ACC_NO = '''', ACC_NAME = AC.ACC_NAME_KOR '
          + '      FROM SFACBIF_TBL AC                                             '
          + '      WHERE AC.DEPT_CODE = ''' + gvDeptCode + '''                      '
          + '      UNION                                                           '
          + '      SELECT  SA.ACC_NO, SUB_ACC_NO = SA.SUB_ACC_NO, ACC_NAME = SA.SUB_NAME_KOR '
          + '      FROM SFSACIF_TBL SA                                              '
          + '      WHERE SA.DEPT_CODE = ''' + gvDeptCode + ''' ) TMP                '
          + ' WHERE AG.DEPT_CODE = ''' + gvDeptCode + '''                           '
          + '   AND AG.SEC_TYPE  = ''' + gcSEC_FUTURES + '''                         '
          + '   AND AG.GRP_NAME  =  ''' + Trim(DREdit_GrpName.Text)  + '''                            '
          + '   AND AG.ACC_NO    = TMP.ACC_NO                                       '
          + '   AND AG.SUB_ACC_NO = TMP.SUB_ACC_NO                                  '
          + ' ORDER BY AG.ACC_NO, AG.SUB_ACC_NO                         ');

    Try
       gf_ADOQueryOpen(ADOQuery_Temp);
    Except  // DataBase �����Դϴ�.
       On E: Exception do
       begin

          gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SUAGPAC]: ' + E.Message, 0);
          gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SUAGPAC]');
          Exit;
       end;
    End;
    // ������
    DREdit_MgrOprId.Text := Trim(FieldByName('OPR_ID').asString);

    // ���۽ð�
    DREdit_MgrOprTime.Text := gf_FormatDate(Trim(FieldByName('OPR_DATE').asString))
                              + ' ' + gf_FormatTime(Trim(FieldByName('OPR_TIME').asString));
    // ��ϰ��� List ����
    while not Eof do
    begin
      New(AccItem);
      GrpAccList.Add(AccItem);
      AccItem.FmtAccNo := gf_FormatAccNo(Trim(FieldByName('ACC_NO').asString),
                                         Trim(FieldByName('SUB_ACC_NO').asString));
      AccItem.AccName  :=  Trim(FieldByName('ACC_NAME').asString);
      if sCallFlag = gcSEND_FAX then
        stmpStr := Trim(FieldByName('EXCEPT_FAX').asString)
      else if sCallFlag = gcSEND_EMAIL then
        stmpStr := Trim(FieldByName('EXCEPT_EMAIL').asString);
      if stmpStr = 'Y' then
        AccItem.ExceptFlag := True
      else
        AccItem.ExceptFlag := False;

      Next;
    end;   // end of while
    ListViewSelectData;
  end; // end of with
  Screen.Cursor := crDefault;   //���콺 ȭ��ǥ
//  gf_ShowMessage(MessageBar, mtInformation, 1021, ''); //��ȸ �Ϸ�
end;

procedure TDlgForm_FRegGroup.DREdit_AccNoKeyPress(Sender: TObject;
  var Key: Char);
var
  AccItem      : pTSelectAccItem;
begin
  inherited;
  if (Key = #13) or (Key = #9) then
  begin
     Screen.Cursor := CrHourGlass;
     DRListView_AllAcc.OnData := nil ; //Event �߻� ����
     Screen.Cursor := crHourGlass;

     AccSearch(DREdit_AccNo.text);
     DRListView_AllAcc.Items.Count := AllAccList.Count;//QueryAllAcc;
//     DisplayGridData;

{     if (DRStrGrid_AllAcc.RowCount = 2)
     and (DRStrGrid_AllAcc.Cells[0,1] > '') then
     begin
       New(AccItem);
       GrpAccList.Add(AccItem);

       AccItem.FmtAccNo   := DREdit_AccNo.Text;
       AccItem.AccName    := DRLabel_AccName.Caption;
       AccItem.ExceptFlag := False;
     end;
}
//     ListViewSelectData;
//     AccSelectedCheck;

     AllAccList.Sort(MgrAllListCompare);
     DRListView_AllAcc.OnData := DRListView_AllAccData ;
     DRListView_AllAcc.Refresh;

     if DRListView_AllAcc.Items.Count = 1 then //1���� �ٷ� Select View��
     begin
       DRListView_AllAcc.Selected := DRListView_AllAcc.Items[0];
       AddSelectData;
     end;

     Screen.Cursor := CrDefault;
  end;
end;

//------------------------------------------------------------------------------
// �˻�
//------------------------------------------------------------------------------
function TDlgForm_FRegGroup.AccSearch(sData : string): boolean;
var
  sFormatAccNo, sAccNo, sSubAccNo, sSubDirectGB: string;
  iRow : integer;
  AccItem      : pTAllAccItem;
begin
  Result := False;

  ClearAllAccList;

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
    if (sSubDirectGB = 'Y') then
    begin
      SQL.Add(' select SFSACIF_TBL.ACC_NO, SFSACIF_TBL.SUB_ACC_NO, ACC_NAME = SUB_NAME_KOR, PARTY_COMP = INV_COMP_CODE, BOOK_NAME = SFSACIF_TBL.SUB_BOOK_KOR '
            + '        , PARTY_NAME = (SELECT ISNULL(COMP_NAME_KOR, '''')             '
            + '                        FROM SCCOMCD_TBL                               '
            + '                        WHERE SCCOMCD_TBL.COMP_CODE = SFACBIF_TBL.INV_COMP_CODE )'
            + ' from SFSACIF_TBL, SFACBIF_TBL                                              '
            + ' where SFSACIF_TBL.DEPT_CODE = ''' + gvDeptCode + '''                      '
            + ' and   SFSACIF_TBL.ACC_NO    = ''' + sAccNo + '''  '
            + ' and   SFSACIF_TBL.SUB_ACC_NO= ''' + sSubAccNo + ''' '
            + ' and   SFACBIF_TBL.DEPT_CODE = SFSACIF_TBL.DEPT_CODE '
            + ' and   SFACBIF_TBL.ACC_NO = SFSACIF_TBL.ACC_NO '
            + ' ORDER BY SFSACIF_TBL.ACC_NO, SFSACIF_TBL.SUB_ACC_NO     '
            );
    end
    else
    begin
      SQL.Add(' select ACC_NO, SUB_ACC_NO = '''', ACC_NAME = ACC_NAME_KOR, PARTY_COMP = INV_COMP_CODE, BOOK_NAME = BOOK_NAME_KOR '
            + '        , PARTY_NAME = (SELECT ISNULL(COMP_NAME_KOR, '''')             '
            + '                        FROM SCCOMCD_TBL                               '
            + '                        WHERE SCCOMCD_TBL.COMP_CODE = SFACBIF_TBL.INV_COMP_CODE) '
            + ' from SFACBIF_TBL                                              '
            + ' where DEPT_CODE = ''' + gvDeptCode + '''                      '
            + ' and   (  (UPPER(ACC_NAME_KOR) like ''' + uppercase(sData) + '%'')          '
            + '       or (ACC_NO       like ''' + sData + '%''))         '
            + ' union                                                         '
            + ' select SFSACIF_TBL.ACC_NO, SFSACIF_TBL.SUB_ACC_NO, ACC_NAME = SUB_NAME_KOR, PARTY_COMP = INV_COMP_CODE, BOOK_NAME = SFSACIF_TBL.SUB_BOOK_KOR '
            + '        , PARTY_NAME = (SELECT ISNULL(COMP_NAME_KOR, '''')             '
            + '                        FROM SCCOMCD_TBL                               '
            + '                        WHERE SCCOMCD_TBL.COMP_CODE = SFACBIF_TBL.INV_COMP_CODE )'
            + ' from SFSACIF_TBL, SFACBIF_TBL                                              '
            + ' where SFSACIF_TBL.DEPT_CODE = ''' + gvDeptCode + '''                      '
            + ' and   (  (UPPER(SFSACIF_TBL.SUB_NAME_KOR) like ''' + uppercase(sData) + '%'')          '
            + '       or (SFSACIF_TBL.ACC_NO       like ''' + sData + '%''))         '
            + ' and   SFACBIF_TBL.DEPT_CODE = SFSACIF_TBL.DEPT_CODE '
            + ' and   SFACBIF_TBL.ACC_NO = SFSACIF_TBL.ACC_NO '
            + ' ORDER BY ACC_NO, SUB_ACC_NO                                   '
            );
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

    while not Eof do
    begin
      New(AccItem);
      AllAccList.Add(AccItem);
      AccItem.FmtAccNo    :=  gf_FormatAccNo(Trim(FieldByName('ACC_NO').asString),
                                       Trim(FieldByName('SUB_ACC_NO').asString));
      AccItem.AccName  :=  Trim(FieldByName('ACC_NAME').asString);
      AccItem.AccComp  :=  Trim(FieldByName('PARTY_COMP').asString);
      AccItem.BookName  :=  Trim(FieldByName('BOOK_NAME').asString);
      AccItem.CompName :=  Trim(FieldByName('PARTY_NAME').asString);
      Next;
    end;   // end of while
    AllAccList.Sort(MgrAllListCompare);

  end; //end of with
  Result := True;
end;

procedure TDlgForm_FRegGroup.EditWndProc(var Message: TMessage);
begin
   case Message.Msg of
   WM_GETDLGCODE : Message.Result := Message.Result or DLGC_WANTTAB;
   else OldEditWndProc( Message );
   end;
end;


//------------------------------------------------------------------------------
//  �ش�׷��Ͽ� ���յǴ� TreeViewMgrGrp�� Index Return
//------------------------------------------------------------------------------
function TDlgForm_FRegGroup.SelectGridMgrGrp(pGrpName: string): Integer;
var
  SelectIdx : Integer;
  PreSelected : boolean;
begin
  SelectIdx := ExistInGridMgrGrp(pGrpName);
  if SelectIdx > 0 then  // DRTreeView_MgrGrp�� �ش� �׷� ����
  begin
    SelMgrGrpRow := SelectIdx;
    gf_SelectStrGridRow(DRStrgrid_MgrGrp, SelectIdx);
    DRStrGrid_MgrGrpDblClick(nil);
  end;
  Result := SelectIdx;
end;


end.
