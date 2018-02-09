unit SCCRegGroup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCCDlgForm, StdCtrls, Buttons, DRAdditional, ExtCtrls, DRStandard,
  DRSpecial, ComCtrls, DRWin32, DRCodeControl, Db, ADODB, DRDialogs;

type
  TDlgForm_RegGroup = class(TForm_Dlg)
    DRPanel1: TDRPanel;
    DRPanel2: TDRPanel;
    DRPanel6: TDRPanel;
    DRSpeedButton_FindAcc: TDRSpeedButton;
    DRUserDblCodeCombo_GrpFAcc: TDRUserDblCodeCombo;
    DRTreeView_MgrAcc: TDRTreeView;
    DRPanel7: TDRPanel;
    DRLabel4: TDRLabel;
    DRLabel8: TDRLabel;
    DREdit_GrpName: TDREdit;
    DREdit_MgrOprId: TDREdit;
    DREdit_MgrOprTime: TDREdit;
    DRPanel3: TDRPanel;
    DRPanel4: TDRPanel;
    DRLabel1: TDRLabel;
    DRLabel6: TDRLabel;
    DRListView_AllAcc: TDRListView;
    DRUserDblCodeCombo_GrpAcc: TDRUserDblCodeCombo;
    DRPanel5: TDRPanel;
    DRLabel2: TDRLabel;
    DRLabel20: TDRLabel;
    DRCheckBox_ExcepAll: TDRCheckBox;
    DRListView_SelectAcc: TDRListView;
    DRBitBtn6: TDRBitBtn;
    ADOQuery_Temp: TADOQuery;
    ADOQuery_SUAGPAC: TADOQuery;
    DRTreeView_MgrGrp: TDRTreeView;
    DRSpeedBtn_Insert: TDRSpeedButton;
    DRSpeedBtn_Delete: TDRSpeedButton;


    procedure FormCreate(Sender: TObject);
    function  InitializeData: boolean;

    //--- Grp Mgr ---//
    function  QueryAllAcc    : integer;
    function  QuerySelectAcc : boolean;
    procedure InsertGrpMgr;
    procedure UpdateGrpMgr;
    procedure DeleteGrpMgr;
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
    function  SelectTreeViewMgrGrp(pHeaderTag: string): Integer;
    function  SelectTreeViewMgrAcc(pHeaderTag: string): Integer;
    function  ExistListViewSelAcc(pHeaderTag: string) : Integer;
    function  ExistInTreeViewMgrGrp(pHeaderTag: string): Integer;
    function  ExistInTreeViewMgrAcc(pHeaderTag: string): Integer;
    procedure DRListView_AllAccData(Sender: TObject; Item: TListItem);
    function  MgrGrpCheckKeyEditEmpty: boolean;
    procedure AccSelectedCheck;
    procedure AccFindSelect;
    procedure GrpFindSelect;




    procedure DRBitBtn5Click(Sender: TObject);
    procedure DRBitBtn6Click(Sender: TObject);
    procedure DRBitBtn4Click(Sender: TObject);
    procedure DRBitBtn3Click(Sender: TObject);
    procedure DRTreeView_MgrAccChange(Sender: TObject; Node: TTreeNode);
    procedure DRTreeView_MgrGrpChange(Sender: TObject; Node: TTreeNode);
    procedure DRUserDblCodeCombo_GrpFAccCodeChange(Sender: TObject);
    procedure DRUserDblCodeCombo_GrpFAccEditKeyPress(Sender: TObject;
      var Key: Char);
    procedure DRSpeedButton_FindAccClick(Sender: TObject);
    procedure DRCheckBox_ExcepAllClick(Sender: TObject);
    procedure DRUserDblCodeCombo_GrpAccEditKeyPress(Sender: TObject;
      var Key: Char);
    procedure DRListView_SelectAccColumnClick(Sender: TObject;
      Column: TListColumn);
    procedure DRListView_SelectAccDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure DRListView_SelectAccDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure DRListView_SelectAccEndDrag(Sender, Target: TObject; X,
      Y: Integer);
    procedure DRListView_SelectAccKeyPress(Sender: TObject; var Key: Char);
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
    procedure DRListView_AllAccKeyPress(Sender: TObject; var Key: Char);
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



  private
    FormCreated : boolean;

  public
    DefGrpName  : string;
    DefCallFlag : string;
  end;

var
  DlgForm_RegGroup: TDlgForm_RegGroup;

implementation

uses
  SCCLib, SCCGlobalType, SCCCmuLib;
{$R *.DFM}


type
  TAllAccItem = record           // �׷���� ��ü����List
    AccNo        : string;
    AccName      : string;
    AccComp      : string;
  end;
  pTAllAccItem = ^TAllAccItem;

  TSelectAccItem = record        // �׷���� ��ϰ���List
    AccNo        : string;
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
  MgrAllSortFlag : Array [0..2] of Boolean;   // DRListView_AllAcc���� ��Column�� Sort ����
  MgrSelSortFlag : Array [0..1] of Boolean;   // DRListView_SelectAcc���� �� Column�� Sort ����
  AllAccList     : TList;                     // �׷���� DRListView_AllAcc List
  GrpAccList     : TList;                     // �׷���� DRListView_SelectAcc List
  ListFlag       : Boolean;		      // �׷���� ��� List Flag


//------------------------------------------------------------------------------
//  DRListView_SelectAcc Sorting �Լ� (Select)
//------------------------------------------------------------------------------
function MgrSelListCompare(Item1, Item2: Pointer): Integer;
var
  StdStr1, StdStr2 : string;
begin
  StdStr1 :=  pTSelectAccItem(Item1).AccNo + pTSelectAccItem(Item1).AccName;
  StdStr2 :=  pTSelectAccItem(Item2).AccNo + pTSelectAccItem(Item2).AccName;

  case MgrSelSortIdx of
    // ���¹�ȣ
    0: Result := gf_ReturnStrComp(pTSelectAccItem(Item1).AccNo + StdStr1,
                                  pTSelectAccItem(Item2).AccNo + StdStr2,
                                  MgrSelSortFlag[MgrSelSortIdx]);
    // ���¸�
    1: Result := gf_ReturnStrComp(pTSelectAccItem(Item1).AccName + StdStr1,
                     		  pTSelectAccItem(Item2).AccName + StdStr2,
                     		  MgrSelSortFlag[MgrSelSortIdx]);
    else
       Result := 0;
  end;  // end of case

end;
//------------------------------------------------------------------------------
//  DRListView_AllAcc Sorting �Լ� (All)
//------------------------------------------------------------------------------
function MgrAllListCompare(Item1, Item2: Pointer): Integer;
var
  StdStr1, StdStr2 : string;
begin
  StdStr1 :=  pTAllAccItem(Item1).AccNo + pTAllAccItem(Item1).AccName
            + pTAllAccItem(Item1).AccComp;
  StdStr2 :=  pTAllAccItem(Item2).AccNo + pTAllAccItem(Item2).AccName
            + pTAllAccItem(Item2).AccComp;

  case MgrAllSortIdx of
    // ���¹�ȣ
    0: Result := gf_ReturnStrComp(pTAllAccItem(Item1).AccNo + StdStr1,
                                  pTAllAccItem(Item2).AccNo + StdStr2,
                                  MgrAllSortFlag[MgrAllSortIdx]);
    // ���¸�
    1: Result := gf_ReturnStrComp(pTAllAccItem(Item1).AccName + StdStr1,
                     		  pTAllAccItem(Item2).AccName + StdStr2,
                     		  MgrAllSortFlag[MgrAllSortIdx]);
    // ������
    2: Result := gf_ReturnStrComp(pTAllAccItem(Item1).AccComp + StdStr1,
                     		  pTAllAccItem(Item2).AccComp + StdStr2,
                     		  MgrAllSortFlag[MgrAllSortIdx]);

    else
       Result := 0;
  end;  // end of case

end;

//------------------------------------------------------------------------------
// �������
//------------------------------------------------------------------------------
procedure TDlgForm_RegGroup.FormCreate(Sender: TObject);
begin
  inherited;
  FormCreated := False;
  // �׷���� �׷���
  DRTreeView_MgrGrp.Color    := gcTreeViewColor;

  // Mgr Grp
  DREdit_GrpName.Color :=  gcQueryEditColor;
  MgrAllSortIdx := IDXA_ACC_NO;           // ���¹�ȣ Sorting
  MgrAllSortFlag[MgrAllSortIdx] := True;  // Ascending
  MgrSelSortIdx := IDXA_ACC_NO;           // ���¹�ȣ Sorting
  MgrSelSortFlag[MgrSelSortIdx] := True;  // Ascending
  ListFlag := True;                       // ���LIst�� �׷�����
  DRSpeedButton_FindAcc.Hint := '���¹�ȣ��';
  DRTreeView_MgrAcc.visible := False;
  DRUserDblCodeCombo_GrpFAcc.Visible := False;


  //List ����
  AllAccList    := TList.Create;
  GrpAccList    := TList.Create;
  // MgrGrp ���� ��ü ����List ����
  DRListView_AllAcc.Items.Count := QueryAllAcc;

  if (not Assigned(AllAccList)) or (not Assigned(GrpAccList))  then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); // List ���� ����
    Close;
    Exit;
  end;

  // �ʱ�ȭ
  if not InitializeData then
  begin
    Close;
    Exit;
  end;

  FormCreated := True;
end;

//------------------------------------------------------------------------------
// ���ʱ�ȭ
//------------------------------------------------------------------------------
function TDlgForm_RegGroup.InitializeData: boolean;
var
  sFormatAccNo : string;
begin
  Result := False;

  with ADOQuery_Temp do
  begin
      // ���¹�ȣ
      Close;
      SQL.Clear;
      SQL.Add('  Select ACC_NO, SUB_ACC_NO = '''', ACC_NAME = ACC_NAME_KOR '
            + '  From SFACBIF_TBL '
            + '  Where DEPT_CODE = ''' + gvDeptCode + ''' '
            + '  Order By ACC_NO, SUB_ACC_NO ' );  // �ش� �μ� ����
      {!!! �ΰ��� ó�� ����
            + '  Union '
            + '  Select ACC_NO, SUB_ACC_NO , ACC_NAME = SUB_NAME_KOR '
            + '  From SESACIF_TBL '
            + '  Where DEPT_CODE = ''' + gvDeptCode + ''') ' }

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

      // �׷���� ���¹�ȣ
      DRUserDblCodeCombo_GrpAcc.ClearItems;
      // �׷���� ����ã�� ��ȣ
      DRUserDblCodeCombo_GrpFAcc.ClearItems;
      while not EOF do
      begin
        sFormatAccNo := gf_FormatAccNo(Trim(FieldByName('ACC_NO').asString),
                                       Trim(FieldByName('SUB_ACC_NO').asString));
        DRUserDblCodeCombo_GrpAcc.AddItem(sFormatAccNo, Trim(FieldByName('ACC_NAME').asString));
        DRUserDblCodeCombo_GrpFAcc.AddItem(sFormatAccNo, Trim(FieldByName('ACC_NAME').asString));
        Next;
      end;

      if not BuildTreeViewMgrGrp then Exit;     // DRTreeView_MgrGrp ������ ����

  end; //end of with
  Result := True;
end;

//------------------------------------------------------------------------------
// �׷���� DRTreeView_MgrGrp ���¹�ȣ Search
//------------------------------------------------------------------------------
procedure TDlgForm_RegGroup.AccFindSelect;
var
  sAccNo : string;
  I : integer;
begin
  sAccNo := DRUserDblCodeCombo_GrpFAcc.Code;
  if sAccNo = '' then Exit;

  for I := 0 to  DRTreeView_MgrAcc.Items.Count -1 do
  begin
    if sAccNO = DRTreeView_MgrAcc.Items[I].Text then
    begin
       DRTreeView_MgrAcc.Items[I].Selected := True;
       DRUserDblCodeCombo_GrpFAcc.Clear;
       exit;
    end;
    next;
  end;

end;

//------------------------------------------------------------------------------
// Row Selected ��ȯ(��ü���� -> ��ϰ���)
//------------------------------------------------------------------------------
procedure TDlgForm_RegGroup.AccSelectedCheck;
var
  AccItem      : pTSelectAccItem;
  SelAccIdx, SelAccCNT, I   : integer;
  List_Item : TListItem;
begin
  // ���¹�ȣ �Է�
  if (DRUserDblCodeCombo_GrpAcc.Code <> '') then
  begin
    for I := 0 to DRListView_SelectAcc.Items.Count - 1 do  // ��ϰ��� List
      begin
        List_Item := DRListView_SelectAcc.Items[I];
        If  Trim(DRUserDblCodeCombo_GrpAcc.Code)
          = List_Item.Caption then
          List_Item.Selected := True;
        next;
      end;  // end of for
    DRUserDblCodeCombo_GrpAcc.Clear;
  end
  // Multi Select
  else if  (DRListView_AllAcc.SelCount > 0) then
  begin
    SelAccCNT   := DRListView_AllAcc.SelCount;               // ���ð��� Count
    SelAccIdx  := DRListView_AllAcc.Selected.Index;          // ���ð��� Index

    while (SelAccCNT > 0) do
    begin
      if  DRListView_AllAcc.Items[SelAccIdx].Selected then   // ���������� ���õ� Data
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
          next;
        end;  // end of for
        SelAccCNT := SelAccCNT - 1;
      end; // end of if
      SelAccIdx := SelAccIdx + 1;
      Next;
    end; // end of while
  end
  // NO Selected
  else
    gf_ShowMessage(MessageBar, mtError, 1142, ''); //�ϳ� �̻��� Report�� �����ϼž� �մϴ�.

end;

//------------------------------------------------------------------------------
// ���� ���� �߰�
//------------------------------------------------------------------------------
procedure TDlgForm_RegGroup.AddSelectData;
var
  AccItem      : pTSelectAccItem;
  SelAccIdx, SelAccCNT   : integer;
begin

  // ���¹�ȣ �����Է�
  if (DRUserDblCodeCombo_GrpAcc.Code <> '') then
  begin
    New(AccItem);
    GrpAccList.Add(AccItem);
    AccItem.AccNo      :=  DRUserDblCodeCombo_GrpAcc.Code;
    AccItem.AccName    :=  DRUserDblCodeCombo_GrpAcc.CodeName;
    AccItem.ExceptFlag :=  False;
  end;

  // Multi Select
  if DRListView_AllAcc.SelCount > 0 then
  begin
    SelAccCNT   := DRListView_AllAcc.SelCount;               // ���ð��� Count
    SelAccIdx  := DRListView_AllAcc.Selected.Index;          // ���ð��� Index

    while (SelAccCNT > 0) do
    begin
      if  DRListView_AllAcc.Items[SelAccIdx].Selected then   // ���õ� Data
      begin
        New(AccItem);
        GrpAccList.Add(AccItem);
        AccItem.AccNo   :=   DRListView_AllAcc.Items[SelAccIdx].Caption;
        AccItem.AccName :=   DRListView_AllAcc.Items[SelAccIdx].SubItems.Strings[0];  // ���¸�
        AccItem.ExceptFlag := False;
        SelAccCNT := SelAccCNT - 1;
      end; // end of if
      SelAccIdx := SelAccIdx + 1;
      Next;
    end; // end of while
  end; // end of if

  ListViewSelectData;
  AccSelectedCheck;               // ���ܰ��� ���� Check
end;

//------------------------------------------------------------------------------
// �׷����  DRTreeView_MgrGrp ���¹�ȣList ����
//------------------------------------------------------------------------------
function TDlgForm_RegGroup.BuildTreeViewMgrAcc: boolean;
var
  GItem, CItem : TTreeNode;
  sAccNo : string;
begin
  Result := False;
  DRTreeView_MgrGrp.Visible := False;
  DRTreeView_MgrAcc.Visible := True;

  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' Select DISTINCT ACC_NO, GRP_NAME  '
          + ' From SUAGPAC_TBL '
          + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
          + ' And   SEC_TYPE  = ''' + gcSEC_FUTURES  + ''' '
          + ' Order By ACC_NO ');
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
    DRTreeView_MgrAcc.OnChange := nil;  // Event �߻� ����

    // Clear TreeView
    DRTreeView_MgrAcc.Items.Clear;
    // Add TreeView
    GItem := nil;
    sAccNo := '';
    while not EOF do
    begin
      if sAccNo <> Trim(FieldByName('ACC_NO').asString) then
      begin
        sAccNo :=  Trim(FieldByName('ACC_NO').asString);
        GItem  := DRTreeView_MgrAcc.Items.Add(nil, Trim(FieldByName('ACC_NO').asString));
        CItem  := DRTreeView_MgrAcc.Items.AddChild(GItem, Trim(FieldByName('GRP_NAME').asString));
      end
      else
        CItem := DRTreeView_MgrAcc.Items.AddChild(GItem, Trim(FieldByName('GRP_NAME').asString));
      Next;
    end;   // end of while
    DRTreeView_MgrAcc.OnChange := DRTreeView_MgrAccChange;  // Event ����
  end;  // end of with

  Result := True;
end;

//------------------------------------------------------------------------------
// �׷��� TreeView ����
//------------------------------------------------------------------------------
function TDlgForm_RegGroup.BuildTreeViewMgrGrp: boolean;
var
  GItem : TTreeNode;
begin
  Result := False;
  DRTreeView_MgrAcc.Visible := False;
  DRTreeView_MgrGrp.Visible := True;
  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' Select DISTINCT GRP_NAME '
          + ' From SUAGPAC_TBL '
          + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
          + ' And   SEC_TYPE  = ''' + gcSEC_FUTURES  + ''' '
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
    DRTreeView_MgrGrp.OnChange := nil;  // Event �߻� ����

    // Clear TreeView
    DRTreeView_MgrGrp.Items.Clear;
    // Add TreeView
    GItem := nil;

    while not EOF do
    begin
      GItem := DRTreeView_MgrGrp.Items.Add(nil, Trim(FieldByName('GRP_NAME').asString));
      Next;
    end;   // end of while
    DRTreeView_MgrGrp.OnChange := DRTreeView_MgrGrpChange;  // Event ����
  end;  // end of with

  Result := True;

end;

//------------------------------------------------------------------------------
//  Clear AllAccList (��ü����)
//------------------------------------------------------------------------------
procedure TDlgForm_RegGroup.ClearAllAccList;
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
procedure TDlgForm_RegGroup.ClearGrpAccList;
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
// Delete Grp
//------------------------------------------------------------------------------
procedure TDlgForm_RegGroup.DeleteGrpMgr;
begin
  gf_ShowMessage(MessageBar, mtInformation, 1005, ''); //���� ���Դϴ�.

  if MgrGrpCheckKeyEditEmpty then Exit;   //�Է� ���� �׸� Ȯ��


  // ������ ��ϵǾ� �ִ��� Ȯ��
  if Not ExistInSUAGPAC then
  begin
    gf_ShowMessage(MessageBar, mtError, 1025, ''); //�ش� �ڷᰡ �������� �ʽ��ϴ�.
    DREdit_GrpName.SetFocus;
    Exit;
  end;

  DisableForm;
  with ADOQuery_SUAGPAC do
  begin
    //------------------
    gf_BeginTransaction;
    //------------------
    //--- Delete SUACCAD_TBL
    Close;
    SQL.Clear;
    SQL.Add(' Delete SUAGPAC_TBL '
          + ' Where DEPT_CODE = ''' + gvDeptCode + ''''
          + '   and SEC_TYPE  = ''' + gcSEC_FUTURES + ''''
          + '   and GRP_NAME  = ''' + DREdit_GrpName.Text + '''');

    Try
      gf_ADOExecSQL(ADOQuery_SUAGPAC);
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
    //-------------------
    gf_CommitTransaction;
    //-------------------
  end;  // end of with

  if ListFlag then
    BuildTreeViewMgrGrp
  else
    BuildTreeViewMgrAcc;
  EnableForm;
  gf_ShowMessage(MessageBar, mtInformation, 1006, DREdit_GrpName.Text ); // ���� �Ϸ�
end;

//------------------------------------------------------------------------------
// ���� ���� ����
//------------------------------------------------------------------------------
procedure TDlgForm_RegGroup.DelSelectData;
var
  AccItem      : pTSelectAccItem;
  SelAccIdx, SelAccCNT, I   : integer;
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
        AccItem.AccNo   :=   DRListView_SelectAcc.Items[SelAccIdx].Caption;
        AccItem.AccName :=   DRListView_SelectAcc.Items[SelAccIdx].SubItems.Strings[0];  // ���¸�
        AccItem.ExceptFlag := DRListView_SelectAcc.Items[SelAccIdx].Checked;
        SelAccCNT := SelAccCNT - 1;
      end; // end of if
      SelAccIdx := SelAccIdx + 1;
      Next;
    end; // end of while
  end; // end of if

  ListViewSelectData;
end;


//---------------------------------------------------
//  �׷���� :  ��ü ���� ����Ʈ�� ����
//---------------------------------------------------
procedure TDlgForm_RegGroup.DRListView_AllAccData(Sender: TObject;
  Item: TListItem);
var
  I : Integer;
  AccItem : pTAllAccItem;

begin
  inherited;
  AccItem := AllAccList.Items[Item.Index];
  Item.Caption    := AccItem.AccNo;
  Item.SubItems.Add(AccItem.AccName);
  Item.SubItems.Add(gf_CompCodeToName(AccItem.AccComp));

end;

//------------------------------------------------------------------------------
// Mgr Grp - ���ð����� Duplication Check
//------------------------------------------------------------------------------
function TDlgForm_RegGroup.DupDataDelete: boolean;
var
  I, Cnt : integer;
  AccItem : pTSelectAccItem;
  sAccNo, sAccName : String;
begin
  Result := False;
  sAccNo   := '';
  sAccName := '';
  Cnt      := GrpAccList.Count;
  I        := 0;
  while Cnt > 0 do
  begin
    AccItem := GrpAccList.Items[I];
    // ���ϰ��°� �ƴѰ�츸 List����
    if  ((sAccNo = AccItem.AccNo) and (sAccName = AccItem.AccName)) then
    begin
      GrpAccList.Remove(AccItem);
      Cnt := Cnt -1;
    end
    else
    begin
      sAccNo   := AccItem.AccNo;
      sAccName := AccItem.AccName;
      I := I + 1;
      Cnt := Cnt -1;
    end; // end of if
  end; // end of while
  Result := True;

end;

//------------------------------------------------------------------------------
//  SUAGPAC_TBL�� �ش� �׷� �����ϴ��� �Ǵ�
//------------------------------------------------------------------------------
function TDlgForm_RegGroup.ExistInSUAGPAC: boolean;
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
          + '   and GRP_NAME = ''' +  DREdit_GrpName.Text + ''' ');
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
function TDlgForm_RegGroup.ExistInTreeViewMgrAcc(
  pHeaderTag: string): Integer;
var
  I : Integer;
begin
  Result := -1;
  for I := 0 to DRTreeView_MgrAcc.Items.Count -1 do
  begin
    if UpperCase(DRTreeView_MgrAcc.Items[I].Text) =
      UpperCase(pHeaderTag) then
    begin
      Result := I;
      Break;
    end;  // end of if
  end; // end of for
end;
//------------------------------------------------------------------------------
// DRTreeView_MgrGrp Index Search
//------------------------------------------------------------------------------
function  TDlgForm_RegGroup.ExistListViewSelAcc(pHeaderTag: string) : Integer;
var
  I : Integer;
  AccItem      : pTSelectAccItem;
begin
  Result := -1;
  if not Assigned(GrpAccList) then Exit;
  for I := 0 to GrpAccList.Count -1 do
  begin
    AccItem := GrpAccList.Items[I];

    if AccItem.AccNo = pHeaderTag then
    begin
      Result := I;
      Break;
    end;  // end of if
  end; // end of for
end;


//------------------------------------------------------------------------------
// DRTreeView_MgrGrp Index Search
//------------------------------------------------------------------------------
function TDlgForm_RegGroup.ExistInTreeViewMgrGrp(pHeaderTag: string): Integer;
var
  I : Integer;
begin
  Result := -1;
  for I := 0 to DRTreeView_MgrGrp.Items.Count -1 do
  begin
    if UpperCase(DRTreeView_MgrGrp.Items[I].Text) =
      UpperCase(pHeaderTag) then
    begin
      Result := I;
      Break;
    end;  // end of if
  end; // end of for
end;


//------------------------------------------------------------------------------
// Insert Grp
//------------------------------------------------------------------------------
procedure TDlgForm_RegGroup.InsertGrpMgr;
var
  I       : Integer;
  AccItem :  pTSelectAccItem;
begin
  gf_ShowMessage(MessageBar, mtInformation, 1010, ''); //�Է� ���Դϴ�.

  if MgrGrpCheckKeyEditEmpty then Exit;   //�Է� ���� �׸� Ȯ��


  // ������ ��ϵǾ� �ִ��� Ȯ��
  if ExistInSUAGPAC then
  begin
    gf_ShowMessage(MessageBar, mtError, 1066, ''); // �ش� ����ó�� �̹� ��ϵǾ� �ֽ��ϴ�.
    DREdit_GrpName.SetFocus;
    Exit;
  end;

  DisableForm;
  SelectAccCheck;
  with ADOQuery_SUAGPAC do
  begin
    //------------------
    gf_BeginTransaction;
    //------------------
    for I := 0 to GrpAccList.Count-1 do
    begin
      AccItem := GrpAccList.Items[I];
      //--- Insert SUACCAD_TBL
      Close;
      SQL.Clear;
      SQL.Add(' Insert SUAGPAC_TBL '
            + ' ( DEPT_CODE, SEC_TYPE, GRP_NAME, ACC_NO, SUB_ACC_NO, ');
      if sCallFlag = gcSEND_FAX then
      SQL.Add('   EXCEPT_FAX, ');
      if sCallFlag = gcSEND_EMAIL then
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
      Parameters.ParamByName('pGrpName').Value  := DREdit_GrpName.Text;
      // ���¹�ȣ
      Parameters.ParamByName('pAccNo').Value    := AccItem.AccNo;
      // �ΰ��¹�ȣ
      Parameters.ParamByName('pSubAccNo').Value := '';

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
          gf_RollBackTransaction;
          EnableForm;
          Exit;
        end;
      End;
    end; //end of for

    //-------------------
    gf_CommitTransaction;
    //-------------------
  end;  // end of with

  if ListFlag then
    BuildTreeViewMgrGrp
  else
    BuildTreeViewMgrAcc;

  EnableForm;
  gf_ShowMessage(MessageBar, mtInformation, 1011, ''); // �Է� �Ϸ�
end;

//---------------------------------------------------
//  �׷���� : ��� ���� ����Ʈ�� ����
//---------------------------------------------------
procedure TDlgForm_RegGroup.ListViewSelectData;
var
  I : Integer;
  AccItem : pTSelectAccItem;
  List_Item : TListItem;
  sAccNo, sAccName : String;

begin
  inherited;
  DRListView_SelectAcc.Items.Clear;
  GrpAccList.Sort(MgrSelListCompare);
  if not DupDataDelete then Exit;

  sAccNo   := '';
  sAccName := '';

  for I := 0 to GrpAccList.Count -1 do
  begin
    AccItem   := GrpAccList.Items[I];
    List_Item := DRListView_SelectAcc.Items.Add;
    sAccNo    := AccItem.AccNo;
    sAccName  := AccItem.AccName;
    List_Item.Caption    := sAccNo;
    List_Item.SubItems.Add(sAccName);
    If AccItem.ExceptFlag then
      List_Item.Checked := True;
  end;
end;

//------------------------------------------------------------------------------
// �ʼ��Է��׸� check (�׷����)
//------------------------------------------------------------------------------
function TDlgForm_RegGroup.MgrGrpCheckKeyEditEmpty: boolean;
var
  I : Integer;
begin
  Result := True;

  // �׷��
  if Trim(DREdit_GrpName.Text) = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, ''); //�Է� ����
    DREdit_GrpName.SetFocus;
    Exit;
  end;

  // ����ó
  if  DRListView_SelectAcc.Items.Count < 1 then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, ''); //�Է� ����
    DRUserDblCodeCombo_GrpAcc.SetFocus;
    Exit;
  end;

  Result := False;
end;

//---------------------------------------------------
//  �׷���� : ��ü ���¹�ȣ Query
//---------------------------------------------------
function TDlgForm_RegGroup.QueryAllAcc: integer;
var
  AccItem      : pTAllAccItem;
begin

  Result  :=  0;
  with ADOQuery_Temp do
  begin
         // ��ü ���¹�ȣ
    Close;
    SQL.Clear;
    SQL.Add('  Select ACC_NO,  ACC_NAME = ACC_NAME_KOR,           '
          + '         INV_COMP_CODE                     '
          + '  From SFACBIF_TBL '
          + '  Where DEPT_CODE = ''' + gvDeptCode + ''' '
          + '  Order By ACC_NO, ACC_NAME_KOR ' );  // �ش� �μ� ����

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
      AccItem.AccNo    :=  Trim(FieldByName('ACC_NO').asString);
      AccItem.AccName  :=  Trim(FieldByName('ACC_NAME').asString);
      AccItem.AccComp  :=  Trim(FieldByName('INV_COMP_CODE').asString);
      Next;
    end;   // end of while
    AllAccList.Sort(MgrAllListCompare);
  end;  // end of with

  Result  :=  AllAccList.Count;

end;


//-----------------------------------------------
// �׷���� : ��� ���� Query
//-----------------------------------------------
function TDlgForm_RegGroup.QuerySelectAcc: boolean;
var
  AccItem      : pTSelectAccItem;
  sGrpName     : string;
  stmpStr      : string;
begin

  Result := False;
  sGrpName     := DREdit_GrpName.Text;
//  ClearFaxGrpList;
  ClearGrpAccList;
  with ADOQuery_Temp do
  begin
         // ��� ���¹�ȣ
    Close;
    SQL.Clear;
    SQL.Add('  Select ag.ACC_NO,  ACC_NAME = ac.ACC_NAME_KOR,  ');
      if sCallFlag = gcSEND_FAX then
         SQL.Add('   ag.EXCEPT_FAX ');
      if sCallFlag = gcSEND_EMAIL then
         SQL.Add('   ag.EXCEPT_EMAIL ');
      SQL.Add('From SUAGPAC_TBL ag, SFACBIF_TBL ac             '
          + '  Where ag.DEPT_CODE = ''' + gvDeptCode + '''     '
          + '  And   ag.SEC_TYPE  = ''' + gcSEC_FUTURES + '''  '
          + '  And   ag.GRP_NAME  = ''' + sGrpName + '''       '
          + '  And   ag.DEPT_CODE = ac.DEPT_CODE  '
          + '  And   ag.ACC_NO    = ac.ACC_NO     '
          + '  Order By ag.ACC_NO, ac.ACC_NAME_KOR ' );  // �ش� �μ� ����

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
      AccItem.AccNo    :=  Trim(FieldByName('ACC_NO').asString);
      AccItem.AccName  :=  Trim(FieldByName('ACC_NAME').asString);
      if sCallFlag = gcSEND_FAX then
        stmpStr :=  Trim(FieldByName('EXCEPT_FAX').asString);
      if sCallFlag = gcSEND_EMAIL then
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
function TDlgForm_RegGroup.SelectAccCheck: boolean;
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
function TDlgForm_RegGroup.SelectTreeViewMgrAcc(pHeaderTag: string): Integer;
var
  SelectIdx : Integer;
  PreSelected : boolean;
begin
  SelectIdx := ExistInTreeViewMgrAcc(pHeaderTag);
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
//  �ش�׷��Ͽ� ���յǴ� TreeViewMgrGrp�� Index Return
//------------------------------------------------------------------------------
function TDlgForm_RegGroup.SelectTreeViewMgrGrp(pHeaderTag: string): Integer;
var
  SelectIdx : Integer;
  PreSelected : boolean;
begin
  SelectIdx := ExistInTreeViewMgrGrp(pHeaderTag);
  if SelectIdx > -1 then  // DRTreeView_MgrGrp�� �ش� �׷� ����
  begin
    PreSelected := DRTreeView_MgrGrp.Items[SelectIdx].Selected;
    DRTreeView_MgrGrp.Items[SelectIdx].Selected := True;
    if PreSelected then // ������ Select�Ǿ��� ����
      DRTreeView_MgrGrpChange(DRTreeView_MgrGrp,
                              DRTreeView_MgrGrp.Items[SelectIdx]);
  end;
  Result := SelectIdx;
end;

//------------------------------------------------------------------------------
// Update Grp (Group�� ���µ��� �����۾�)
//------------------------------------------------------------------------------
procedure TDlgForm_RegGroup.UpdateGrpMgr;
var
  sDelAccList : TStringList; //Delete �ؾ��� Acc List
// �׷��� ���� ���� Select
function SelectAccNo(AccItem : pTSelectAccItem; sGrpName : string): boolean;
begin
  Result := False;
  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('  Select ACC_NO  ');
    SQL.Add('  From   SUAGPAC_TBL '
          + '  Where DEPT_CODE = ''' + gvDeptCode + '''     '
          + '  And   SEC_TYPE  = ''' + gcSEC_FUTURES + '''  '
          + '  And   GRP_NAME  = ''' + sGrpName + '''       '
          + '  And   ACC_NO    = ''' + AccItem.AccNo   + '''       '
          + '  And   SUB_ACC_NO = ''''     '
          + '  Order By ACC_NO ' );

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
// �׷��� Delete �ؾ��� ���¹�ȣ�� List  ����
procedure CreateDelAccList(sGrpName : string);
begin
  with ADOQuery_SUAGPAC do
  begin
    Close;
    SQL.Clear;
    SQL.Add('  Select ACC_NO  ');
    SQL.Add('  From   SUAGPAC_TBL '
          + '  Where DEPT_CODE = ''' + gvDeptCode + '''     '
          + '  And   SEC_TYPE  = ''' + gcSEC_FUTURES + '''  '
          + '  And   GRP_NAME  = ''' + sGrpName + '''       '
          + '  Order By ACC_NO ' );

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
      if ExistListViewSelAcc(Trim(FieldByName('ACC_NO').asString)) = -1 then
      begin
        if Assigned(sDelAccList) then
          sDelAccList.Add((Trim(FieldByName('ACC_NO').asString)));
      end;
      Next;
    end; // end of while
  end;  // end of with
end;

// �׷��� ���� ���¹�ȣ Delete
procedure DeleteAccNo(sAccNo: string; sGrpName : string);
begin
  with ADOQuery_SUAGPAC do
  begin

    //--- Delete SUACCAD_TBL
    Close;
    SQL.Clear;
    SQL.Add(' Delete SUAGPAC_TBL '
          + ' Where DEPT_CODE = ''' + gvDeptCode + ''''
          + '   and SEC_TYPE  = ''' + gcSEC_FUTURES + ''''
          + '   and GRP_NAME  = ''' + sGrpName + ''' '
          + '   and ACC_NO    = ''' + sAccNo   + ''' '
          + '   and SUB_ACC_NO = '''' ');

    Try
      gf_ADOExecSQL(ADOQuery_SUAGPAC);
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

  end;  // end of with
end;

// �׷��� ���� ���¹�ȣ Insert
procedure InsertAccNo(AccItem : pTSelectAccItem; sGrpName : string);
begin
  with ADOQuery_SUAGPAC do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' Insert SUAGPAC_TBL '
          + ' ( DEPT_CODE, SEC_TYPE, GRP_NAME, ACC_NO, SUB_ACC_NO, ');
    if sCallFlag = gcSEND_FAX then
    SQL.Add('   EXCEPT_FAX, ');
    if sCallFlag = gcSEND_EMAIL then
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
    Parameters.ParamByName('pAccNo').Value    := AccItem.AccNo;
    // �ΰ��¹�ȣ
    Parameters.ParamByName('pSubAccNo').Value := '';

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
        gf_RollBackTransaction;
        EnableForm;
        Exit;
      end;
    End;
  end; //end of with
end;
// �׷��� ���� ���¹�ȣ Update
procedure UpdateAccNo(AccItem : pTSelectAccItem; sGrpName : string);
begin
  with ADOQuery_SUAGPAC do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' Update SUAGPAC_TBL Set ');
    if sCallFlag = gcSEND_FAX then
    SQL.Add('   EXCEPT_FAX = :pExceptFlag, ');
    if sCallFlag = gcSEND_EMAIL then
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
    Parameters.ParamByName('pAccNo').Value    := ACCItem.AccNo;
    // �ΰ��¹�ȣ
    Parameters.ParamByName('pSubAccNo').Value := '';
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
        gf_RollBackTransaction;
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

  DisableForm;
  SelectAccCheck;
  //�������� ����
  //------------------
  gf_BeginTransaction;
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
  gf_CommitTransaction;
  //-------------------

  if ListFlag then
    BuildTreeViewMgrGrp
  else
    BuildTreeViewMgrAcc;

  EnableForm;

  if ListFlag then
    SelectTreeViewMgrGrp(DREdit_GrpName.Text)
  else
    SelectTreeViewMgrAcc(DREdit_GrpName.Text);

  gf_ShowMessage(MessageBar, mtInformation, 1008, ''); // ���� �Ϸ�
end;

procedure TDlgForm_RegGroup.DRBitBtn5Click(Sender: TObject);
begin
  inherited;
  gf_ShowMessage(MessageBar, mtInformation, 1020, ''); //��ȸ ���Դϴ�.
  Screen.Cursor := crHourGlass;
  InitializeData;  // �Է� Control Data Update
  QuerySelectAcc;
  Screen.Cursor := crDefault;
  gf_ShowMessage(MessageBar, mtInformation, 1021, ''); // ��ȸ �Ϸ�

end;

procedure TDlgForm_RegGroup.DRBitBtn6Click(Sender: TObject);
begin
  inherited;
  gf_ShowMessage(MessageBar, mtInformation, 1020, ''); //��ȸ ���Դϴ�.
  Screen.Cursor := crHourGlass;
  InitializeData;  // �Է� Control Data Update
  QuerySelectAcc;
  Screen.Cursor := crDefault;
  gf_ShowMessage(MessageBar, mtInformation, 1021, ''); // ��ȸ �Ϸ�

end;

procedure TDlgForm_RegGroup.DRBitBtn4Click(Sender: TObject);
begin
  inherited;
  InsertGrpMgr;
end;

procedure TDlgForm_RegGroup.DRBitBtn3Click(Sender: TObject);
begin
  inherited;
  UpdateGrpMgr;
end;

procedure TDlgForm_RegGroup.DRTreeView_MgrAccChange(Sender: TObject;
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
    else
    begin
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
    Close;
    SQL.Clear;
    SQL.Add('  Select ag.ACC_NO,  ACC_NAME = ac.ACC_NAME_KOR,');
      if sCallFlag = gcSEND_FAX then
      SQL.Add('   ag.EXCEPT_FAX, ');
      if sCallFlag = gcSEND_EMAIL then
      SQL.Add('   ag.EXCEPT_EMAIL, ');
      SQL.Add('   ag.OPR_ID, ag.OPR_DATE, ag.OPR_TIME             '
          + '  From SUAGPAC_TBL ag, SFACBIF_TBL ac'
          + '  Where ag.DEPT_CODE = ''' + gvDeptCode + '''   '
          + '  And   ag.SEC_TYPE  = ''' + gcSEC_FUTURES + '''         '
          + '  And   ag.GRP_NAME  = ''' + DREdit_GrpName.Text + ''' '
          + '  And   ag.DEPT_CODE = ac.DEPT_CODE  '
          + '  And   ag.ACC_NO    = ac.ACC_NO     '
          + '  Order By ag.ACC_NO, ac.ACC_NAME_KOR ' );  // �ش� �μ� ����
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
      AccItem.AccNo    :=  Trim(FieldByName('ACC_NO').asString);
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


procedure TDlgForm_RegGroup.DRTreeView_MgrGrpChange(Sender: TObject;
  Node: TTreeNode);
var
  iMgrGrpIdx : Integer;
  AccItem    : pTSelectAccItem;
  stmpStr    : string;
begin
  inherited;
  if not Assigned(DRTreeView_MgrGrp.Selected) then Exit;

  Screen.Cursor := crHourGlass;   //���콺 �𷡽ð�
  gf_ShowMessage(MessageBar, mtInformation, 1020, ''); //��ȸ ���Դϴ�.

  iMgrGrpIdx := DRTreeView_MgrGrp.Selected.AbsoluteIndex;
  DREdit_GrpName.Text := DRTreeView_MgrGrp.Items[iMgrGrpIdx].Text;


  //Clear
  DREdit_MgrOprId.Text   := '';
  DREdit_MgrOprTime.Text := '';
  ClearGrpAccList;

  // �ش� �׷��Ͽ� ���� ��ϰ��� Query
  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('  Select ag.ACC_NO,  ACC_NAME = ac.ACC_NAME_KOR, ');
      if sCallFlag = gcSEND_FAX then
      SQL.Add('  ag.EXCEPT_FAX, ');
      if sCallFlag = gcSEND_EMAIL then
      SQL.Add('  ag.EXCEPT_EMAIL, ');
      SQL.Add('  ag.OPR_ID, ag.OPR_DATE, ag.OPR_TIME             '
          + '  From SUAGPAC_TBL ag, SFACBIF_TBL ac'
          + '  Where ag.DEPT_CODE = ''' + gvDeptCode + '''   '
          + '  And   ag.SEC_TYPE  = ''' + gcSEC_FUTURES + '''         '
          + '  And   ag.GRP_NAME  = ''' + DREdit_GrpName.Text + ''' '
          + '  And   ag.DEPT_CODE = ac.DEPT_CODE  '
          + '  And   ag.ACC_NO    = ac.ACC_NO     '
          + '  Order By ag.ACC_NO, ac.ACC_NAME_KOR ' );  // �ش� �μ� ����
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
      AccItem.AccNo    :=  Trim(FieldByName('ACC_NO').asString);
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
  gf_ShowMessage(MessageBar, mtInformation, 1021, ''); //��ȸ �Ϸ�
end;


procedure TDlgForm_RegGroup.DRUserDblCodeCombo_GrpFAccCodeChange(
  Sender: TObject);
begin
  inherited;
  AccFindSelect;
end;

procedure TDlgForm_RegGroup.DRUserDblCodeCombo_GrpFAccEditKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
    AccFindSelect;
end;

procedure TDlgForm_RegGroup.DRSpeedButton_FindAccClick(Sender: TObject);
begin
  inherited;
  if ListFlag then
  begin
    ListFlag := False;
    DRSpeedButton_FindAcc.Hint := '�׷��Ϻ�';
    DRTreeView_MgrAcc.Visible := True;
    DRUserDblCodeCombo_GrpFAcc.Visible := True;
//    DRTreeView_MgrGrp.Items.Clear;
    BuildTreeViewMgrAcc;
  end
  else
  begin
    ListFlag := True;
    DRSpeedButton_FindAcc.Hint := '���¹�ȣ��';
    DRTreeView_MgrAcc.Visible := False;
    DRUserDblCodeCombo_GrpFAcc.Visible := False;
//    DRTreeView_MgrAcc.Items.Clear;
    BuildTreeViewMgrGrp;
  end;

end;

procedure TDlgForm_RegGroup.DRCheckBox_ExcepAllClick(Sender: TObject);
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


procedure TDlgForm_RegGroup.DRUserDblCodeCombo_GrpAccEditKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
  If Key = #13 then
  AddSelectData;

end;

procedure TDlgForm_RegGroup.DRListView_SelectAccColumnClick(
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


procedure TDlgForm_RegGroup.DRListView_SelectAccDragDrop(Sender,
  Source: TObject; X, Y: Integer);
var
  AccItem      : pTSelectAccItem;
begin
  inherited;
  If Source = DRListView_AllAcc then
    AddSelectData;
end;

procedure TDlgForm_RegGroup.DRListView_SelectAccDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  If Source = DRListView_AllAcc then
    Accept := True
  else
    Accept := False;

end;

procedure TDlgForm_RegGroup.DRListView_SelectAccEndDrag(Sender,
  Target: TObject; X, Y: Integer);
begin
  inherited;
  if Target <> nil then DRListView_SelectAcc.Update;
end;

procedure TDlgForm_RegGroup.DRListView_SelectAccKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  If Key = #13 then
  DelSelectData;

end;

procedure TDlgForm_RegGroup.DRListView_SelectAccMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then  { ���ʹ�ư�� ������ ���� �巢���� }
    DRListView_SelectAcc.BeginDrag(False);  { �ִٸ� �巢�� �����Ѵ�. }

end;

procedure TDlgForm_RegGroup.DRListView_AllAccColumnClick(Sender: TObject;
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

procedure TDlgForm_RegGroup.DRListView_AllAccDragDrop(Sender,
  Source: TObject; X, Y: Integer);
begin
  inherited;
  If Source = DRListView_SelectAcc then
    DelSelectData;

end;

procedure TDlgForm_RegGroup.DRListView_AllAccDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  If Source = DRListView_SelectAcc then
    Accept := True
  else
    Accept := False;

end;

procedure TDlgForm_RegGroup.DRListView_AllAccEndDrag(Sender,
  Target: TObject; X, Y: Integer);
begin
  inherited;
  if Target <> nil then DRListView_AllAcc.Update;
end;

procedure TDlgForm_RegGroup.DRListView_AllAccKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  If Key = #13 then
  AddSelectData;

end;

procedure TDlgForm_RegGroup.DRListView_AllAccMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then  { ���ʹ�ư�� ������ ���� Drag���� }
    DRListView_AllAcc.BeginDrag(False);  { �ִٸ� Drag�� �����Ѵ�. }

end;


procedure TDlgForm_RegGroup.DRSpeedBtn_InsertClick(Sender: TObject);
begin
  inherited;
  AddSelectData;
end;

procedure TDlgForm_RegGroup.DRSpeedBtn_DeleteClick(Sender: TObject);
begin
  inherited;
  DelSelectData;
end;

procedure TDlgForm_RegGroup.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  ClearAllAccList;
  ClearGrpAccList;
end;

procedure TDlgForm_RegGroup.FormActivate(Sender: TObject);
begin
  inherited;

  if Trim(DefGrpName) <> '' then   // Default Data ���� ���
    DREdit_GrpName.Text := DefGrpName;
  if DefCallFlag = gcSEND_FAX then
    sCallFlag  := gcSEND_FAX
  else if DefCallFlag = gcSEND_EMAIL then
    sCallFlag  := gcSEND_EMAIL;
  GrpFindSelect;
end;

procedure TDlgForm_RegGroup.GrpFindSelect;
var
  I : integer;
begin


  for I := 0 to DRTreeView_MgrGrp.Items.Count - 1 do
  begin
    if DRTreeView_MgrGrp.Items[I].Text = DefGrpName then
      DRTreeView_MgrGrp.Items[I].Selected := True;
  end;
  DRTreeView_MgrGrp.OnChange := nil;  // Event �߻� ����
  DRTreeView_MgrGrp.OnChange := DRTreeView_MgrGrpChange;  // Event ����
end;

procedure TDlgForm_RegGroup.DRBitBtn2Click(Sender: TObject);
begin
  inherited;
  DeleteGrpMgr;
end;

procedure TDlgForm_RegGroup.DRListView_SelectAccKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_DELETE then  //DeleteKey
    DelSelectData;
end;

procedure TDlgForm_RegGroup.DRListView_AllAccDblClick(Sender: TObject);
begin
  inherited;
  AddSelectData;
end;

procedure TDlgForm_RegGroup.DRListView_SelectAccDblClick(Sender: TObject);
begin
  inherited;
  DelSelectData;
end;

procedure TDlgForm_RegGroup.DREdit_GrpNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key = #13 then
    DRUserDblCodeCombo_GrpAcc.SetFocus;
end;

end.
