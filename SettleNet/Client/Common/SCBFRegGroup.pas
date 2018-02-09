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
  TAllAccItem = record           // 그룹관리 전체계좌List
    FmtAccNo     : string;
    AccName      : string;
    AccComp      : string;
    BookName      : string;
    CompName     : string;
  end;
  pTAllAccItem = ^TAllAccItem;

  TSelectAccItem = record        // 그룹관리 등록계좌List
    FmtAccNo     : string;
    AccName      : string;
    ExceptFlag   : Boolean;
  end;
  pTSelectAccItem = ^TSelectAccItem;

const
  IDXA_ACC_NO      = 0;   // 계좌번호 Col Index
  PEXCEPTFAX       = 'pExceptFax';
var
  sCallFlag       : string;
  MgrAllSortIdx, MgrSelSortIdx : Integer;     // MgrGrp Sort Column의 Index
  MgrAllSortFlag : Array [0..3] of Boolean;   // DRListView_AllAcc에서 각Column의 Sort 정보
  MgrSelSortFlag : Array [0..1] of Boolean;   // DRListView_SelectAcc에서 각 Column의 Sort 정보
  AllAccList     : TList;                     // 그룹관리 DRListView_AllAcc List
  GrpAccList     : TList;                     // 그룹관리 DRListView_SelectAcc List
  GrpFlag : Boolean; // 그룹관리 여부
  SelMgrGrpRow : integer;

//------------------------------------------------------------------------------
//  등록계좌 Sorting 함수 (Select)
//------------------------------------------------------------------------------
function MgrSelListCompare(Item1, Item2: Pointer): Integer;
begin
  case MgrSelSortIdx of
    // 계좌번호
    0: Result := gf_ReturnStrComp(pTSelectAccItem(Item1).FmtAccNo,
                                  pTSelectAccItem(Item2).FmtAccNo,
                                  MgrSelSortFlag[MgrSelSortIdx]);
    // 계좌명
    1: Result := gf_ReturnStrComp(pTSelectAccItem(Item1).AccName,
                     		  pTSelectAccItem(Item2).AccName,
                     		  MgrSelSortFlag[MgrSelSortIdx]);
    else
       Result := 0;
  end;  // end of case

end;
//------------------------------------------------------------------------------
//  전체계좌 Sorting 함수 (All)
//------------------------------------------------------------------------------
function MgrAllListCompare(Item1, Item2: Pointer): Integer;
var
  StdStr1, StdStr2 : string;
begin
  StdStr1 :=  pTAllAccItem(Item1).FmtAccNo;
  StdStr2 :=  pTAllAccItem(Item2).FmtAccNo;

  case MgrAllSortIdx of
    // 계좌번호
    0: Result := gf_ReturnStrComp(StdStr1, StdStr2,
                                  MgrAllSortFlag[MgrAllSortIdx]);
    // 계좌명
    1: Result := gf_ReturnStrComp(pTAllAccItem(Item1).AccName,
                     		  pTAllAccItem(Item2).AccName,
                     		  MgrAllSortFlag[MgrAllSortIdx]);
    // 부기명
    2: Result := gf_ReturnStrComp(pTAllAccItem(Item1).BookName,
                     		  pTAllAccItem(Item2).BookName,
                     		  MgrAllSortFlag[MgrAllSortIdx]);
    // 투자자
    3: Result := gf_ReturnStrComp(pTAllAccItem(Item1).CompName,
                     		  pTAllAccItem(Item2).CompName,
                     		  MgrAllSortFlag[MgrAllSortIdx]);

    else
       Result := 0;
  end;  // end of case

end;

//------------------------------------------------------------------------------
// 폼만들기
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.FormCreate(Sender: TObject);
begin
  inherited;
  FormCreated := False;
  // 그룹명
  DREdit_GrpName.Color    := gcQueryEditColor;

  DRTreeView_MgrAcc.Color := gcTreeViewColor;

  MgrAllSortIdx := IDXA_ACC_NO;           // 계좌번호 Sorting
  MgrAllSortFlag[MgrAllSortIdx] := True;  // Ascending
  MgrSelSortIdx := IDXA_ACC_NO;           // 계좌번호 Sorting
  MgrSelSortFlag[MgrSelSortIdx] := True;  // Ascending

  GrpFlag := True;                       // 목록LIst를 그룹으로 보여준다.
  DRSpeedButton_FindAcc.Hint := '계좌번호별';
  if not BuildTreeViewMgrGrp then Exit;     // DRTreeView_MgrGrp 데이터 생성

  if gvDeptCode = gcDEPT_CODE_INT then // 국제부
      DREdit_GrpName.ImeMode := imSAlpha;

  //List 생성
  AllAccList    := TList.Create;
  GrpAccList    := TList.Create;
  // MgrGrp 에서 전체 계좌List 생성
  DRListView_AllAcc.Items.Count := 0;//QueryAllAcc;

  if (not Assigned(AllAccList)) or (not Assigned(GrpAccList))  then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); // List 생성 오류
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
// Row Selected 변환(전체계좌 -> 등록계좌)
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.AccSelectedCheck;
var
  List_Item : TListItem;
  SelAccIdx, SelAccCNT, I   : integer;
begin
{
  // 계좌번호 입력
  if (DRUserDblCodeCombo_GrpAcc.Code <> '') then
  begin
    for I := 0 to DRListView_SelectAcc.Items.Count -1  do  // 등록계좌 List
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
    SelAccCNT  := DRListView_AllAcc.SelCount;               // 선택계좌 Count
    SelAccIdx  := DRListView_AllAcc.Selected.Index;          // 선택계좌 Index

    while (SelAccCNT > 0) do
    begin
      if  DRListView_AllAcc.Items[SelAccIdx].Selected then   // 전체계좌의 선택된 Data
      begin
        for I := 0 to DRListView_SelectAcc.Items.Count - 1 do  // 등록계좌 List
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
    gf_ShowMessage(MessageBar, mtError, 1009, ''); //선택 항목이 없습니다.

end;

//------------------------------------------------------------------------------
// 선택 계좌 추가
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
    SelAccCNT  := DRListView_AllAcc.SelCount;               // 선택계좌 Count
    SelAccIdx  := DRListView_AllAcc.Selected.Index;          // 선택계좌 Index

    while (SelAccCNT > 0) do
    begin
      if  DRListView_AllAcc.Items[SelAccIdx].Selected then   // 선택된 Data
      begin
        New(AccItem);
        GrpAccList.Add(AccItem);
        AccItem.FmtAccNo   := DRListView_AllAcc.Items[SelAccIdx].Caption;
        AccItem.AccName    := DRListView_AllAcc.Items[SelAccIdx].SubItems.Strings[0];  // 계좌명
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
// 그룹관리  DRTreeView_MgrAcc 계좌번호List 생성
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
      begin  // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SUAGPAC_TBL]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SUAGPAC_TBL]'); //Database 오류
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
    DRTreeView_MgrAcc.OnChange := DRTreeView_MgrAccChange;  // Event 연결
    DRTreeView_MgrAcc.Align := alClient; //@@
    DRTreeView_MgrAcc.Visible := True; //@@

  end;  // end of with

  Result := True;
end;

//------------------------------------------------------------------------------
// 그룹목록 TreeView 생성
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
      begin  // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SUAGPAC_TBL]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SUAGPAC_TBL]'); //Database 오류
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
//  Clear AllAccList (전체계좌)
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
//  Clear GrpAccList (등록계좌)
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
// 등록계좌 List에서 삭제
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
    SelAccCNT   := (DRListView_SelectAcc.Items.Count - DRListView_SelectAcc.SelCount);               // 선택계좌 Count
    SelAccIdx  := 0;          // 선택계좌 Index

    while (SelAccCNT > 0) do
    begin
      if  not (DRListView_SelectAcc.Items[SelAccIdx].Selected) then   // 선택된 Data
      begin
        New(AccItem);
        GrpAccList.Add(AccItem);
        AccItem.FmtAccNo  := DRListView_SelectAcc.Items[SelAccIdx].Caption;
        AccItem.AccName    := DRListView_SelectAcc.Items[SelAccIdx].SubItems.Strings[0];  // 계좌명
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
//  그룹관리 :  전체 계좌 리스트뷰 생성
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
// Mgr Grp - 선택계좌의 Duplication Check
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
    // 동일계좌가 아닌경우만 List생성
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
//  SUAGPAC_TBL에 해당 그룹 존재하는지 판단
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
      begin  // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SUGRPAD_TBL]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SUGRPAD_TBL]'); //Database 오류
        Exit;
      end;
    End;

    if RecordCount > 0 then Result := True; // Data 존재
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
//  그룹관리 : 등록 계좌 리스트뷰 생성
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
// 필수입력항목 check (그룹관리)
//------------------------------------------------------------------------------
function TDlgForm_FRegGroup.MgrGrpCheckKeyEditEmpty: boolean;
begin
  Result := True;

  // 그룹명
  if Trim(DREdit_GrpName.Text) = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, ''); //입력 오류
    DREdit_GrpName.SetFocus;
    Exit;
  end;


  if  DRListView_SelectAcc.Items.Count < 1 then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, ''); //입력 오류
    DREdit_GrpName.SetFocus;
    Exit;
  end;

  Result := False;
end;


//------------------------------------------------------------------------------
//  그룹관리 : 전체 계좌번호 Query
//------------------------------------------------------------------------------
function TDlgForm_FRegGroup.QueryAllAcc: integer;
var
  AccItem      : pTAllAccItem;
begin

  Result  :=  0;
  with ADOQuery_Temp do
  begin
         // 전체 계좌번호
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
      begin  // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Acc[SFACBIF_TBL]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Acc[SFACBIF_TBL]'); //Database 오류
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
// 그룹관리 : 등록 계좌 Query
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
     // 등록 계좌번호
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
      begin  // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Acc[SUAGPAC_TBL]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Acc[SUAGPAC_TBL]'); //Database 오류
        Exit;
      end;
    End;

    If RecordCount <= 0 then
    begin
      gf_ShowMessage(MessageBar, mtInformation, 1018, ''); //해당 내역이 없습니다.
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
// 제외계좌 Check 표시 반영
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
//  해당그룹목록에 부합되는 TreeViewMgrAcc의 Index Return
//------------------------------------------------------------------------------
function TDlgForm_FRegGroup.SelectTreeViewMgrAcc(pGrpName: string): Integer;
var
  SelectIdx : Integer;
  PreSelected : boolean;
begin
  SelectIdx := ExistInTreeViewMgrAcc(pGrpName);
  if SelectIdx > -1 then  // DRTreeView_MgrGrp에 해당 그룹 존재
  begin
    PreSelected := DRTreeView_MgrAcc.Items[SelectIdx].Selected;
    DRTreeView_MgrAcc.Items[SelectIdx].Selected := True;
    if PreSelected then // 이전에 Select되었던 상태
        DRTreeView_MgrAccChange(DRTreeView_MgrAcc,
                                DRTreeView_MgrAcc.Items[SelectIdx]);
  end;
  Result := SelectIdx;
end;

//------------------------------------------------------------------------------
// 조회
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRBitBtn6Click(Sender: TObject);
begin
  inherited;
  gf_ShowMessage(MessageBar, mtInformation, 1020, ''); //조회 중입니다.
  Screen.Cursor := crHourGlass;
  QuerySelectAcc;
  Screen.Cursor := crDefault;
  gf_ShowMessage(MessageBar, mtInformation, 1021, ''); // 조회 완료

end;

//------------------------------------------------------------------------------
// 입력
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRBitBtn4Click(Sender: TObject);
var
  I       : Integer;
  AccItem :  pTSelectAccItem;
  AccNo, SubAccNo :string;
begin
  inherited;
  gf_ShowMessage(MessageBar, mtInformation, 1010, ''); //입력 중입니다.

  if MgrGrpCheckKeyEditEmpty then Exit;   //입력 누락 항목 확인


  // 기존에 등록되어 있는지 확인
  if ExistInSUAGPAC then
  begin
//    SelectTreeViewGrpName(DREdit_GrpName.Text, false);
    DREdit_GrpName.SetFocus;
    gf_ShowMessage(MessageBar, mtError, 1024, ''); // 해당 자료가 이미 존재합니다.
    Exit;
  end;
  SelectAccCheck;     // 제외계좌 표시
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
        // 부서코드
        Parameters.ParamByName('pDeptCode').Value := gvDeptCode;
        // 주식구분
        Parameters.ParamByName('pSecType').Value  := gcSEC_FUTURES;
        // 그룹이름
        Parameters.ParamByName('pGrpName').Value  := Trim(DREdit_GrpName.Text);
        // 계좌번호
        Parameters.ParamByName('pAccNo').Value    := AccNo;
        // 부계좌번호
        Parameters.ParamByName('pSubAccNo').Value := SubAccNo;

        // 제외계좌
        If AccItem.ExceptFlag Then
          Parameters.ParamByName('pExceptFlag').Value := 'Y'
        else
          Parameters.ParamByName('pExceptFlag').Value := 'N';

        // 조작자
        Parameters.ParamByName('pOprId').Value := gvOprUsrNo;
        // 조작일자
        Parameters.ParamByName('pOprDate').Value := gvCurDate;
        // 조작시간
        Parameters.ParamByName('pOprTime').Value := gf_GetCurTime;
        Try
          gf_ADOExecSQL(ADOQuery_SUAGPAC);
        Except
          on E : Exception do
          begin  // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, '[Insert]: ' + E.Message,0);
            gf_ShowMessage(MessageBar, mtError, 9001, '[Insert]'); //Database 오류
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

//  if not GrpINSAccNo then exit;     //그룹에 등록된 계좌번호
  if GrpFlag then
    BuildTreeViewMgrGrp
  else
    BuildTreeViewMgrAcc;

  EnableForm;
  SelectGridMgrGrp(DREdit_GrpName.Text);
  InputValueClear;
  DREdit_GrpName.SetFocus;
  gf_ShowMessage(MessageBar, mtInformation, 1011, ''); // 입력 완료
end;

//------------------------------------------------------------------------------
// 수정
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRBitBtn3Click(Sender: TObject);
var
  sDelAccList : TStringList; //Delete 해야할 Acc List

//-------------------------
// 그룹의 개별 계좌 Select
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
      begin  // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Acc[SUAGPAC_TBL]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Acc[SUAGPAC_TBL]'); //Database 오류
        Exit;
      end;
    End;
    If RecordCount <= 0 then
      Result := True;   // Insert
  end; // end of with
end;

//-------------------------
// 그룹의 Delete 해야할 계좌번호의 List  생성
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
      begin  // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Acc[SUAGPAC_TBL All Query]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Acc[SUAGPAC_TBL All Query]'); //Database 오류
        Exit;
      end;
    End;
    // 테이블에는 있고 list에는 없는 경우 (Delete)
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
// 그룹의 개별 계좌번호 Delete
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
      begin  // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, '[Delete]: ' + E.Message,0);
        gf_ShowMessage(MessageBar, mtError, 9001, '[Delete]'); //Database 오류
//        gf_RollBackTransaction;
        EnableForm;
        Exit;
      end;
    End;

  end;  // end of with
end;

//-------------------------
// 그룹의 개별 계좌번호 Insert
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
    // 부서코드
    Parameters.ParamByName('pDeptCode').Value := gvDeptCode;
    // 주식구분
    Parameters.ParamByName('pSecType').Value  := gcSEC_FUTURES;
    // 그룹이름
    Parameters.ParamByName('pGrpName').Value  := sGrpName;
    // 계좌번호
    Parameters.ParamByName('pAccNo').Value    := AccNo;
    // 부계좌번호
    Parameters.ParamByName('pSubAccNo').Value := SubAccNo;

    // 제외계좌
    If AccItem.ExceptFlag Then
      Parameters.ParamByName('pExceptFlag').Value := 'Y'
    else
      Parameters.ParamByName('pExceptFlag').Value := 'N';

    // 조작자
    Parameters.ParamByName('pOprId').Value := gvOprUsrNo;
    // 조작일자
    Parameters.ParamByName('pOprDate').Value := gvCurDate;
    // 조작시간
    Parameters.ParamByName('pOprTime').Value := gf_GetCurTime;
    Try
      gf_ADOExecSQL(ADOQuery_SUAGPAC);
    Except
      on E : Exception do
      begin  // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, '[계좌별 Insert]: ' + E.Message,0);
        gf_ShowMessage(MessageBar, mtError, 9001, '[계좌별Insert]'); //Database 오류
//        gf_RollBackTransaction;
        EnableForm;
        Exit;
      end;
    End;
  end; //end of with
end;

//-------------------------
// 그룹의 개별 계좌번호 Update
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
    // 부서코드
    Parameters.ParamByName('pDeptCode').Value := gvDeptCode;
    // 주식구분
    Parameters.ParamByName('pSecType').Value  := gcSEC_FUTURES;
    // 그룹이름
    Parameters.ParamByName('pGrpName').Value  := sGrpName;
    // 계좌번호
    Parameters.ParamByName('pAccNo').Value    := AccNo;
    // 부계좌번호
    Parameters.ParamByName('pSubAccNo').Value := SubAccNo;
    // 제외계좌
    if AccItem.ExceptFlag then
      Parameters.ParamByName('pExceptFlag').Value    := 'Y'
    else
      Parameters.ParamByName('pExceptFlag').Value    := 'N';
    // 조작자
    Parameters.ParamByName('pOprId').Value := gvOprUsrNo;
    // 조작일자
    Parameters.ParamByName('pOprDate').Value := gvCurDate;
    // 조작시간
    Parameters.ParamByName('pOprTime').Value := gf_GetCurTime;
    Try
      gf_ADOExecSQL(ADOQuery_SUAGPAC);
    Except
      on E : Exception do
      begin  // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, '[Update]: ' + E.Message,0);
        gf_ShowMessage(MessageBar, mtError, 9001, '[Update]'); //Database 오류
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
  gf_ShowMessage(MessageBar, mtInformation, 1007, ''); //수정 중입니다.
  if MgrGrpCheckKeyEditEmpty then Exit;   //입력 누락 항목 확인

  // 그룹이 기존에 등록되어 있는지 확인
  if Not ExistInSUAGPAC then
  begin
    gf_ShowMessage(MessageBar, mtError, 1025, ''); //해당 자료가 존재하지 않습니다.
    DREdit_GrpName.SetFocus;
    Exit;
  end;

  SelectAccCheck;
  DisableForm;
  //개별계좌 수정
  //------------------
//  gf_BeginTransaction;
  //------------------
  // 1. Delete : 계좌List에서 삭제된 데이터가 테이블에 있는 경우 삭제
  CreateDelAccList(sGrpName);       // AccList 와 테이블과 비교하여 삭제 계좌 List 생성
  if Assigned(sDelAcclist) then
  begin
    for I:= 0 to sDelAccList.Count-1 do
    begin
      DeleteAccNo(sDelAccList.Strings[I], sGrpName);
    end; // end of for
    sDelAccList.Free
  end; // end of if

  // 2. Update : 테이블에 없는 계좌는 Insert하고 이미 있는 계좌는 Update
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

//  if not GrpINSAccNo then exit;             //그룹에 등록된 계좌번호
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
  gf_ShowMessage(MessageBar, mtInformation, 1008, ''); // 수정 완료
end;


//------------------------------------------------------------------------------
// 삭제
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRBitBtn2Click(Sender: TObject);
var
  iUsedEMailGrpCnt, iUsedFaxTlxGrpCnt: integer;
  UsedList : String;
begin
  inherited;
  gf_ShowMessage(MessageBar, mtInformation, 1005, ''); //삭제 중입니다.

  // 그룹명
  if Trim(DREdit_GrpName.Text) = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, ''); //입력 오류
    DREdit_GrpName.SetFocus;
    Exit;
  end;

  // 기존에 등록되어 있는지 확인
  if Not ExistInSUAGPAC then
  begin
    gf_ShowMessage(MessageBar, mtError, 1025, ''); //해당 자료가 존재하지 않습니다.
    DREdit_GrpName.SetFocus;
    Exit;
  end;

  UsedList := '';
  DisableForm;
  with ADOQuery_SUAGPAC do
  begin
      //--- SUGPMEL_TBL에서  해당 그룹이 사용되는지 확인
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
         begin // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUMELAD[SUGPMEL_TBL SELECT]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUMELAD[SUGPMEL_TBL SELECT]'); //Database 오류
            EnableForm;
            Exit;
         end;
      End;

      iUsedEMailGrpCnt := RecordCount;
      if iUsedEMailGrpCnt > 0 then
         UsedList :=  '  - EMail 수신처 관리' + Chr(13);

      //--- SUGRPAD_TBL에서  해당 그룹이 사용되는지 확인
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
         begin // DataBase 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUMELAD[SUGRPAD_TBL SELECT]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUMELAD[SUGRPAD_TBL SELECT]'); //Database 오류
            EnableForm;
            Exit;
         end;
      End;

      iUsedFaxTlxGrpCnt := RecordCount;
      if iUsedFaxTlxGrpCnt > 0 then
         UsedList := UsedList + '  - Fax/Telex 수신처 관리'+ Chr(13);
      
      if (iUsedEMailGrpCnt > 0) or (iUsedFaxTlxGrpCnt > 0)then // Data 있는 경우
      begin
         if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 1150, //해당 그룹은 수신처에 등록되어 있습니다.
            UsedList + Chr(13) + ' 삭제하시겠습니까? ',
            [mbYes, mbCancel], 0) = idCancel then
         begin
            gf_ShowMessage(MessageBar, mtInformation, 1082, ''); //작업이 취소되었습니다.
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
        begin  // DataBase 오류
          gf_ShowErrDlgMessage(Self.Tag, 9001, '[Delete]: ' + E.Message,0);
          gf_ShowMessage(MessageBar, mtError, 9001, '[Delete]'); //Database 오류
          gf_RollBackTransaction;
          EnableForm;
          Exit;
        end;
      End;

      if iUsedEMailGrpCnt > 0 then  // 사용그룹 있는 경우
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
            begin // DataBase 오류
               gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Delete SUGPMAD_TBL]: ' + E.Message, 0);
               gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Delete SUGPMAD_TBL]'); //Database 오류
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
            begin // DataBase 오류
               gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Delete SUGPMEL_TBL]: ' + E.Message, 0);
               gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Delete SUGPMEL_TBL]'); //Database 오류
               gf_RollBackTransaction;
               EnableForm;
               Exit;
            end;
         End;
      end;

      if iUsedFaxTlxGrpCnt > 0 then  // 사용그룹 있는 경우
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
            begin // DataBase 오류
               gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Delete SUGPRPT_TBL]: ' + E.Message, 0);
               gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Delete SUGPRPT_TBL]'); //Database 오류
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
            begin // DataBase 오류
               gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SUPRTAD[Delete SUGPMEL_TBL]: ' + E.Message, 0);
               gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUPRTAD[Delete SUGPMEL_TBL]'); //Database 오류
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
//  if not GrpINSAccNo then exit;             //그룹에 등록된 계좌번호
  if GrpFlag then
    BuildTreeViewMgrGrp
  else
    BuildTreeViewMgrAcc;
  EnableForm;
  InputValueClear;
  DREdit_GrpName.SetFocus;
  gf_ShowMessage(MessageBar, mtInformation, 1006, '' ); // 삭제 완료
end;



//------------------------------------------------------------------------------
//  TreeView의 계좌번호 선택시
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
  Screen.Cursor := crHourGlass;   //마우스 모래시계
  gf_ShowMessage(MessageBar, mtInformation, 1020, ''); //조회 중입니다.

  if DRTreeView_MgrAcc.Selected.Level = 0 then // 계좌 선택
    DREdit_GrpName.Text := ''
  else  begin
    iMgrGrpIdx := DRTreeView_MgrAcc.Selected.AbsoluteIndex;
    DREdit_GrpName.Text := DRTreeView_MgrAcc.Items[iMgrGrpIdx].Text;
  end;

  //Clear
  DREdit_MgrOprId.Text   := '';
  DREdit_MgrOprTime.Text := '';
  ClearGrpAccList;

  // 해당 그룹목록에 대한 등록계좌 Query
  with ADOQuery_Temp do
  begin
     // 등록 계좌번호
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
    Except  // DataBase 오류입니다.
       On E: Exception do
       begin
          gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SUAGPAC]: ' + E.Message, 0);
          gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SUAGPAC]');
          Exit;
       end;
    End;
    // 조작자
    DREdit_MgrOprId.Text := Trim(FieldByName('OPR_ID').asString);

    // 조작시간
    DREdit_MgrOprTime.Text := gf_FormatDate(Trim(FieldByName('OPR_DATE').asString))
                              + ' ' + gf_FormatTime(Trim(FieldByName('OPR_TIME').asString));
    // 등록계좌 List 생성
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
  Screen.Cursor := crDefault;   //마우스 화살표
  gf_ShowMessage(MessageBar, mtInformation, 1021, ''); //조회 완료
end;



//------------------------------------------------------------------------------
//  계좌번호/그룹명 Search Toggle
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRSpeedButton_FindAccClick(Sender: TObject);
begin
  inherited;
  GrpFlag := Not GrpFlag;
  if Not GrpFlag then //계좌별
  begin
    gf_ShowMEssage(MessageBar,mtInformation,0,'계좌별 그룹목록 조회중입니다.');
    DRSpeedButton_FindAcc.Hint := '그룹목록별 보기';
    DRPanel6.Caption := '  >> 계좌별 그룹 목록';
    DRTreeView_MgrAcc.Visible := True;
    DRStrGrid_MgrGrp.Visible := False;
    BuildTreeViewMgrAcc;
  end  else //그룹별
  begin
    gf_ShowMEssage(MessageBar,mtInformation,0,'그룹목록 조회중입니다.');
    DRSpeedButton_FindAcc.Hint := '계좌번호별 보기';
    DRPanel6.Caption := '  >> 그룹 목록';
    DRTreeView_MgrAcc.Visible := False;
    DRStrGrid_MgrGrp.Visible := True;    
    BuildTreeViewMgrGrp;
  end;
  gf_ShowMEssage(MessageBar,mtInformation,0,'조회완료');

end;

//------------------------------------------------------------------------------
// 제외계좌 전체 선택시
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
// 선택 계좌 sorting
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
  if Button = mbLeft then  { 왼쪽버튼을 눌렀을 때만 드랙시작 }
    DRListView_SelectAcc.BeginDrag(False);  { 있다면 드랙을 시작한다. }
end;



//------------------------------------------------------------------------------
// 전체 계좌 sorting
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRListView_AllAccColumnClick(Sender: TObject;
  Column: TListColumn);
var
  iCol : integer;
begin
  inherited;
  iCol := Column.Index;

  DRListView_AllAcc.OnData := nil ; //Event 발생 방지
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
  if Button = mbLeft then  { 왼쪽버튼을 눌렀을 때만 Drag시작 }
    DRListView_AllAcc.BeginDrag(False);  { 있다면 Drag을 시작한다. }

end;


//------------------------------------------------------------------------------
// 전체계좌에서 선택계좌로 추가
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRSpeedBtn_InsertClick(Sender: TObject);
begin
  inherited;
  AddSelectData;
end;

//------------------------------------------------------------------------------
// 전체계좌에서 선택계좌로 삭제
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRSpeedBtn_DeleteClick(Sender: TObject);
begin
  inherited;
  DelSelectData;
end;

//------------------------------------------------------------------------------
//  폼 활성화 될때.
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.FormActivate(Sender: TObject);
begin
  inherited;

  if DefCallFlag = gcSEND_FAX then
  begin
    sCallFlag  := gcSEND_FAX;
    DlgForm_FRegGroup.Caption := 'Fax Group 등록';
  end else
  begin
    sCallFlag  := gcSEND_EMAIL;
    DlgForm_FRegGroup.Caption := 'Email Group 등록';
  end;
  DREdit_AccNo.Text := gf_FormatAccNo(DefAccNO, DefSubAccNo);
  if (DefAccNo > '') then //add 20050907
  begin
     DRListView_AllAcc.OnData := nil ; //Event 발생 방지

     AccSearch(DREdit_AccNo.text);
     DRListView_AllAcc.Items.Count := AllAccList.Count;//QueryAllAcc;

     AllAccList.Sort(MgrAllListCompare);
     DRListView_AllAcc.OnData := DRListView_AllAccData ;
     DRListView_AllAcc.Refresh;

     if DRListView_AllAcc.Items.Count = 1 then //1개시 바로 Select View로
     begin
       DRListView_AllAcc.Selected := DRListView_AllAcc.Items[0];
       AddSelectData;
     end;
  end;
  
  if Trim(DefGrpName) = '' then  exit;  // Default Data 없는 경우
  DREdit_GrpName.Text := DefGrpName;
  DREdit_AccNo.SetFocus;
  SelectGridMgrGrp(DefGrpName);
end;

//------------------------------------------------------------------------------
// 선택된 계좌 지우기
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRListView_SelectAccKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_DELETE then  //DeleteKey
    DelSelectData;
end;

//------------------------------------------------------------------------------
// 선택된 계좌 추가
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRListView_AllAccDblClick(Sender: TObject);
begin
  inherited;
  AddSelectData;
end;

//------------------------------------------------------------------------------
// 선택된 계좌 더블 클릭하면 지운다
//------------------------------------------------------------------------------
procedure TDlgForm_FRegGroup.DRListView_SelectAccDblClick(Sender: TObject);
begin
  inherited;
  DelSelectData;
end;

//------------------------------------------------------------------------------
// 그룹명 enter
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
             pChar('파일 이름에 다음 문자가 올 수 없습니다.' + #13#10 + #13#10 +
             '/ : * ? " < > |'),
             '알림',
             MB_OK);
}
   if (Key = #34) or (Key = #39) or
      (Key = #42) or (Key = #47) or
      (Key = #58) or (Key = #60) or
      (Key = #62) or (Key = #63) or
      (Key = #92) or (Key = #124)then
   begin
     Key:=#0 ;
     gf_ShowMessage(MessageBar, mtError, 1012, '해당문자(/ : * ? " < > |)는 그룹명으로 사용할수 없습니다.'); //입력 오류
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
  Screen.Cursor := crHourGlass;   //마우스 모래시계

  DREdit_GrpName.Text := DRStrGrid_MgrGrp.Cells[0,SelMgrGrpRow];
  //Clear
  DREdit_MgrOprId.Text   := '';
  DREdit_MgrOprTime.Text := '';
  ClearGrpAccList;

  // 해당 그룹목록에 대한 등록계좌 Query
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
    Except  // DataBase 오류입니다.
       On E: Exception do
       begin

          gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SUAGPAC]: ' + E.Message, 0);
          gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SUAGPAC]');
          Exit;
       end;
    End;
    // 조작자
    DREdit_MgrOprId.Text := Trim(FieldByName('OPR_ID').asString);

    // 조작시간
    DREdit_MgrOprTime.Text := gf_FormatDate(Trim(FieldByName('OPR_DATE').asString))
                              + ' ' + gf_FormatTime(Trim(FieldByName('OPR_TIME').asString));
    // 등록계좌 List 생성
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
  Screen.Cursor := crDefault;   //마우스 화살표
//  gf_ShowMessage(MessageBar, mtInformation, 1021, ''); //조회 완료
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
     DRListView_AllAcc.OnData := nil ; //Event 발생 방지
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

     if DRListView_AllAcc.Items.Count = 1 then //1개시 바로 Select View로
     begin
       DRListView_AllAcc.Selected := DRListView_AllAcc.Items[0];
       AddSelectData;
     end;

     Screen.Cursor := CrDefault;
  end;
end;

//------------------------------------------------------------------------------
// 검색
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
  if (gf_StrToFloat(sAccNo) > 0) then //계좌번호
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
      begin  // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SFACBIF_TBL]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SFACBIF_TBL]'); //Database 오류
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
//  해당그룹목록에 부합되는 TreeViewMgrGrp의 Index Return
//------------------------------------------------------------------------------
function TDlgForm_FRegGroup.SelectGridMgrGrp(pGrpName: string): Integer;
var
  SelectIdx : Integer;
  PreSelected : boolean;
begin
  SelectIdx := ExistInGridMgrGrp(pGrpName);
  if SelectIdx > 0 then  // DRTreeView_MgrGrp에 해당 그룹 존재
  begin
    SelMgrGrpRow := SelectIdx;
    gf_SelectStrGridRow(DRStrgrid_MgrGrp, SelectIdx);
    DRStrGrid_MgrGrpDblClick(nil);
  end;
  Result := SelectIdx;
end;


end.
