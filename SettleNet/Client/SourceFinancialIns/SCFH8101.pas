unit SCFH8101;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SCCChildForm, DRDialogs, DB, ADODB, DRSpecial, StdCtrls,
  Buttons, DRAdditional, ExtCtrls, DRStandard, Grids, DRStringgrid,
  DrStringPrintU;

type
  TForm_SCFH8101 = class(TForm_SCF)
    DRPanel2: TDRPanel;
    DRLabel1: TDRLabel;
    DRLabel2: TDRLabel;
    DRLabel3: TDRLabel;
    DRLabel4: TDRLabel;
    DRFramePanel1: TDRFramePanel;
    DREdit_AccNo: TDREdit;
    DREdit_AccNameKor: TDREdit;
    DREdit_MgrOprTime: TDREdit;
    DREdit_MgrOprID: TDREdit;
    DREdit_ImportTime: TDREdit;
    DREdit_ImportID: TDREdit;
    DRStrGrid_Acc: TDRStringGrid;
    DrStringPrint1: TDrStringPrint;
    ADOQuery_Log: TADOQuery;
    procedure FormCreate(Sender: TObject); 
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);

    procedure DRStrGrid_AccSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure DRStrGrid_AccDblClick(Sender: TObject);
    procedure DREdit_AccNoKeyPress(Sender: TObject; var Key: Char);

    procedure DRBitBtn2Click(Sender: TObject);
    procedure DRBitBtn3Click(Sender: TObject);
    procedure DRBitBtn4Click(Sender: TObject);
    procedure DRBitBtn5Click(Sender: TObject);
    procedure DRBitBtn6Click(Sender: TObject);

    // ����� ����
    function QueryAllAcc: integer; // ���� ���� ��ȸ
    procedure ClearAccList;

    procedure ClearInputEdit(key : string = '');

    function DisplayGridAcc: Boolean;  // StrGrid�� ���� DATA INPUT

    function AccCheckKeyEditEmpty: boolean;

    function DisplayToEdit_Acc(pAccNo: string): boolean;
    function SelectGridData_Acc(pAccNo: string): Integer;

    function DataInsert_Acc: boolean;
    function DataUpdate_Acc: boolean;
    function DataDelete_Acc: boolean;

    procedure MoveInsertData_Acc;
    procedure MoveUpdateData_Acc;

    function AccNoChk(pAccNo: string): boolean; // DB�� Insert�� ���̺� ���� �����ϴ��� ���� üũ
    function UpdateDel_AccNoChk(pAccNo: string): boolean; // DB�� Update / Delete�� ���̺� ���� �����ϴ��� ���� üũ

    function InsertLog(pTRGGB:string; pOriginAccNameKor:string = ''; pCurAccNameKor: string = ''): boolean;         // SZTRLOG_HIS�� INSERT�ϴ� �Լ�
    procedure MoveInsertData_Log(pTRGGB: string);                                                                   // �Է¹�ư ������ �� SZTRLOG_HIS�� �ִ��Լ�
    procedure MoveUpdateData_Log(pTRGGB, pOriginAccNameKor, pCurAccNameKor: string);                                // ������ư ������ �� SZTRLOG_HIS�� �ִ��Լ�
    procedure MoveDeleteData_Log(pTRGGB: string);                                                                   // ������ư ������ �� SZTRLOG_HIS�� �ִ��Լ�
  private
    procedure DefClearStrGrid(pStrGrid: TDRStringGrid); // StrGrid Clear
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_SCFH8101: TForm_SCFH8101;

implementation

uses
  SCCLib, SCCGlobalType, SCCCmuLib;
{$R *.dfm}

type
  TAllAccItem = record           // ��ü ���� List
    AccNo       : string;
    AccNameKor   : string;
  end;
  pTAllAccItem = ^TAllAccItem;

const
  IDX_ACC_NO     = 0;   // ���¹�ȣ  Col Index
  IDX_ACC_NAME_KOR      = 1;   // ���¸� Col Index

  LOG_JOB_GB        = 'A';     // �۾����� '��������'
  LOG_TRG_GB_ADD    = 'I';     // �Է½� SZTRLOG_HIS ���̺� TRG_GB
  LOG_TRG_GB_UPDATE = 'U';     // ������ SZTRLOG_HIS ���̺� TRG_GB
  LOG_TRG_GB_DELETE = 'D';     // ������ SZTRLOG_HIS ���̺� TRG_GB
var
  AllAccList     : TList;                       // Acc List
  SelColIdx : Integer;                          // StrGrid ���õ� Col Index
  SelRowIdx : Integer;                          // StrGrid ���õ� Row Index


procedure TForm_SCFH8101.DefClearStrGrid(pStrGrid: TDRStringGrid);
begin
  with pStrGrid do
  begin
    Color             := gcGridBackColor;
    SelectedCellColor := gcGridSelectColor;
    RowCount := 2;
    Rows[1].Clear;
  end;  // end of with
end;

//==============================================================================
//  Clear AccList (����)
//==============================================================================
procedure TForm_SCFH8101.ClearAccList;
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

//==============================================================================
//  Form Create
//==============================================================================
procedure TForm_SCFH8101.FormCreate(Sender: TObject);
begin
  inherited;
  ClearInputEdit;
  AllAccList := TList.Create;

  if (not Assigned(AllAccList)) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); // List ���� ����
    Close;
    Exit;
  end;

  QueryAllAcc;

  DisplayGridAcc;

  // �ʼ��Է� Edit
  DREdit_AccNo.Color          := gcQueryEditColor;
  DREdit_AccNameKor.Color     := gcQueryEditColor;
end;

//==============================================================================
//  Edit Clear
//==============================================================================
procedure TForm_SCFH8101.ClearInputEdit(key : string = '');
begin
  if key = '' then
  begin
    DREdit_AccNo.Clear;
    DREdit_AccNameKor.Clear;
  end;
  DREdit_ImportID.Clear;
  DREdit_ImportTime.Clear;
  DREdit_MgrOprID.Clear;
  DREdit_MgrOprTime.Clear;
end;

//==============================================================================
// ��ü ���� Query
//==============================================================================
function TForm_SCFH8101.QueryAllAcc: integer;
var
  AccItem : pTAllAccItem;
begin
  Result := 0;

  ClearAccList;

  with ADOQuery_DECLN do
  begin
    // ��ü ����
    Close;
    SQL.Clear;
    SQL.Add(' SELECT A.ACC_NO, A.ACC_NAME_KOR                     '
          + ' FROM SZACBIF_INS A                                   '
          + ' WHERE A.DEPT_CODE = ''' + gvDeptCode + '''             '
          + ' ORDER BY A.ACC_NO                                    ');

    Try
      gf_ADOQueryOpen(ADOQuery_DECLN);
    Except
      on E : Exception do
      begin  // DataBase ����
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZACBIF_INS]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZACBIF_INS]'); //Database ����
        Exit;
      end;
    End;


    while not Eof do
    begin
      New(AccItem);
      AllAccList.Add(AccItem);
      AccItem.AccNo := Trim(FieldByName('ACC_NO').AsString);
      AccItem.AccNameKor := Trim(FieldByName('ACC_NAME_KOR').AsString);

      Next;
    end;  // end while

  end;

  Result := AllAccList.Count;
end;

//==============================================================================
// Form Close
//==============================================================================
procedure TForm_SCFH8101.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
   if Assigned(AllAccList) then
   begin
     ClearAccList;
     AllAccList.Free;
   end;
end;

//==============================================================================
// Form Show
//==============================================================================
procedure TForm_SCFH8101.FormShow(Sender: TObject);
begin
  inherited;
  DREdit_AccNo.SetFocus;
end;

//==============================================================================
// DRStrGrid_Acc ����List ����
//==============================================================================
function TForm_SCFH8101.DisplayGridAcc: Boolean;
var
  I, K, iRow : Integer;
  AccItem : pTAllAccItem;
  sAccNo, sAccNameKor : string;
begin
  Result := false;

  with DRStrGrid_Acc do
  begin
    if AllAccList.Count <= 0 then
    begin
      RowCount := 2;
      Rows[1].Clear;
      gf_ShowMessage(MessageBar, mtInformation, 1018, ''); //�ش� ������ �����ϴ�.
      Exit;
    end;
    DefClearStrGrid(DRStrGrid_Acc);

    RowCount := AllAccList.Count + 1;

    iRow := 0;
    sAccNo := '';
    sAccNameKor := '';

    // StrGrid Input
    for i := 0 to AllAccList.Count - 1 do
    begin
      AccItem := AllAccList.Items[i];

      Inc(iRow);
      Rows[iRow].Clear;

      sAccNo := AccItem.AccNo;
      sAccNameKor := AccItem.AccNameKor;

      // ���¹�ȣ
      Cells[IDX_ACC_NO, iRow] := sAccNo;
      // ���¸�
      Cells[IDX_ACC_NAME_KOR, iRow] := sAccNameKor;
    end;
  end;

  Result := True;
end;

//==============================================================================
// �ʼ��Է� �׸� ���� Ȯ��
//==============================================================================
function TForm_SCFH8101.AccCheckKeyEditEmpty: boolean;
var
  I : Integer;
  Checked : boolean;
begin
  Result := True;

  // ���¹�ȣ
  if Trim(DREdit_AccNo.Text) = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, '���¹�ȣ'); //�Է� ����
    DREdit_AccNo.SetFocus;
    Exit;
  end;

  // ���¸�
  if Trim(DREdit_AccNameKor.Text) = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, '���¸�'); //�Է� ����
    DREdit_AccNameKor.SetFocus;
    Exit;
  end;

  Result := false;
end;

//==============================================================================
// ���� �׸��� ����Ŭ��
//==============================================================================
procedure TForm_SCFH8101.DRStrGrid_AccSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  SelRowIdx := ARow;
end;

//==============================================================================
// ���� �׸��� ����Ŭ��
//==============================================================================
procedure TForm_SCFH8101.DRStrGrid_AccDblClick(Sender: TObject);
var
  AccItem : pTAllAccItem;
begin
  inherited;
  gf_ClearMessage(MessageBar);

  if SelRowIdx <= 0 then Exit;
  if AllAccList.Count <= 0 then Exit;

  // ����Ŭ���� ���� ���� ��������
  AccItem := AllAccList.Items[SelRowIdx -1];

  DisplayToEdit_Acc(AccItem.AccNo);
  DREdit_AccNameKor.SetFocus;
end;

//==============================================================================
// ���¹�ȣ Enter ��
//==============================================================================
procedure TForm_SCFH8101.DREdit_AccNoKeyPress(Sender: TObject;
  var Key: Char);
var
 TmpAccNo  : string;
begin
  inherited;

  TmpAccNo := '';

  if Key = #13 then
  begin
     gf_ClearMessage(MessageBar);
     if Trim(DREdit_AccNo.Text) <> '' then
     begin
        TmpAccNo := Trim(DREdit_AccNo.Text);
        ClearInputEdit;
        DREdit_AccNo.Text := TmpAccNo;
        if not DisplayToEdit_Acc(TmpAccNo) then exit;
        SelectGridData_Acc(TmpAccNO);
     end;
     DREdit_AccNameKor.SetFocus;
  end
  else if (key in ['0'..'9']) then
  begin
     TmpAccNo := TmpAccNo + Key;

     ClearInputEdit(Key);
  end
  else if (not (Key in ['0'..'9'])) and (Key <> #8) then
  begin
    key := #0;
    gf_ShowMessage(MessageBar, mtError, 1045,''); // ���ڸ� �Է��Ͻʽÿ�.
  end;
end;

//==============================================================================
// �ش� ���� ������
//==============================================================================
function TForm_SCFH8101.DisplayToEdit_Acc(pAccNo: string): boolean;
begin

   Result := false;
   with  ADOQuery_DECLN do
   begin
      EnableBCD := False;
      Close;
      SQL.Clear;
      SQL.Add(' SELECT ACC_NO, ACC_NAME_KOR,                              '
            + ' OPR_ID, OPR_DATE, OPR_TIME,                               '
            + ' IMPORT_ID, IMPORT_DATE, IMPORT_TIME                       '
            + ' FROM SZACBIF_INS                                         '
            + ' WHERE DEPT_CODE = ''' + gvDeptCode + '''                  '
            + ' AND   ACC_NO  = ''' + pAccNo + '''                  ');

      Try
         gf_ADOQueryOpen(ADOQuery_DECLN);
      Except
         on E : Exception do
         begin  // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZACBIF_INS]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZACBIF_INS]'); //Database ����
            Exit;
         end;
      End;

      if RecordCount <= 0 then
      begin
         Result := true;
         Exit;
      end;
      // �� Edit Input
      DREdit_AccNo.Text := Trim(FieldByName('ACC_NO').asString);
      DREdit_AccNameKor.Text := Trim(FieldByName('ACC_NAME_KOR').asString);
      DREdit_MgrOprId.Text := Trim(FieldByName('OPR_ID').asString);
      DREdit_MgrOprTime.Text := gf_FormatDate(Trim(FieldByName('OPR_DATE').asString))
                            + ' ' + gf_FormatTime(Trim(FieldByName('OPR_TIME').asString));
      DREdit_ImportID.Text := Trim(FieldByName('IMPORT_ID').asString);
      DREdit_ImportTime.Text := gf_FormatDate(Trim(FieldByName('IMPORT_DATE').asString))
                            + ' ' + gf_FormatTime(Trim(FieldByName('IMPORT_TIME').asString));



   end;

   Result := true;
end;

//==============================================================================
// StrGrid���� �ش� �����Ϳ� �ش�Ǵ� RowIndex ã�� Select
//==============================================================================
function TForm_SCFH8101.SelectGridData_Acc(pAccNo: string): Integer;
var
   I, SearchIdx : Integer;
begin
   SearchIdx := -1;
   for I := 1 to DRStrGrid_Acc.RowCount -1 do
   begin
      if (DRStrGrid_Acc.Cells[IDX_ACC_NO, I] = pAccNo) then
      begin
          SearchIdx := I;
          break;
      end;
   end;
   if SearchIdx > -1 then  //�ش� ������ �����
      gf_SelectStrGridRow(DRStrGrid_Acc, SearchIdx)
   else  //�ش� ������ �������� ���� ��� ùRow Select
      gf_SelectStrGridRow(DRStrGrid_Acc, 1);
   Result := SearchIdx;
end;

//==============================================================================
// ��ȸ ��ư Click
//==============================================================================
procedure TForm_SCFH8101.DRBitBtn6Click(Sender: TObject);
var
  AccRowCount : Integer;
begin
  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1020, ''); //��ȸ ���Դϴ�.
   DisableForm;

   ClearInputEdit;
   AccRowCount := QueryAllAcc;  // ���� ���� ��� �� ��
   DisplayGridAcc;  // ��Ʈ���׸��忡 ������ Input

   if AccRowCount <= 0 then
       gf_ShowMessage(MessageBar, mtInformation, 1018, '') //�ش� ������ �����ϴ�.
   else
       gf_ShowMessage(MessageBar, mtInformation, 1021,
               gwQueryCnt + IntToStr(AccRowCount)); // ��ȸ �Ϸ�
   DREdit_AccNo.SetFocus;

   EnableForm;
end;

//==============================================================================
// �Է� ��ư Click
//==============================================================================
procedure TForm_SCFH8101.DRBitBtn5Click(Sender: TObject);
begin
  inherited;
  if not DataInsert_Acc then Exit;
end;

//==============================================================================
// DB Insert
//==============================================================================
function TForm_SCFH8101.DataInsert_Acc: boolean;
var
   CurAccNo : string;
begin
  inherited;
  Result := false;

  gf_ShowMessage(MessageBar, mtInformation, 1010, ''); //�Է� ���Դϴ�.

  if AccCheckKeyEditEmpty then Exit;   //�Է� ���� �׸� Ȯ��

  CurAccNo := Trim(DREdit_AccNo.Text);

  DisableForm;
  // ���·� ���� ��� Check
  if not AccNoChk(CurAccNo) then
  begin
     EnableForm;
     SelectGridData_Acc(CurAccNo);
     DREdit_AccNo.SetFocus;
     Exit;
  end;

  with ADOQuery_DECLN do
  begin
     Close;
     sql.clear;
     sql.add(   // ���� ���̺� �Է�
              ' INSERT SZACBIF_INS                                                '
            + '  (DEPT_CODE,    ACC_NO,         ACC_NAME_KOR,                     '
            + '   MANUAL_YN,                                                      '
            + '   OPR_ID,       OPR_DATE,       OPR_TIME                    )     '
//            + '   IMPORT_ID,    IMPORT_DATE,    IMPORT_TIME     )                 '
            + ' VALUES                                                            '
            + '  (:pDEPT_CODE,   :pACC_NO,       :pACC_NAME_KOR,                  '
            + '   :pMANUAL_YN,                                                    '
            + '   :pOPR_ID,      :pOPR_DATE,     :pOPR_TIME                  )  '
//            + '   :pIMPORT_ID,   :pIMPORT_DATE,  :pIMPORT_TIME                )  '
            );

     MoveInsertData_Acc;

     Try
        gf_ADOExecSQL(ADOQuery_DECLN);
     Except
        on E : Exception do
        begin
           gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZACBIF_INS :INSERT]: ' + E.Message, 0);
           gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZACBIF_INS : INSERT]'); // Database ����
           EnableForm;
           Exit;
        end;
     end;
  end;

  InsertLog(LOG_TRG_GB_ADD);  // SZTRLOG_HIS Insert

  QueryAllAcc;   // ��ü���� ��ȸ����
  DisplayGridAcc; // �׸��忡 ������ INPUT

  SelectGridData_Acc(CurAccNo);
  ClearInputEdit;

  EnableForm;
  DREdit_AccNo.SetFocus;
  gf_ShowMessage(MessageBar, mtInformation, 1011, ''); // �Է� �Ϸ�
  Result := true;
end;

//==============================================================================
// ���¹�ȣ �����ϴ��� Check
//==============================================================================
function TForm_SCFH8101.AccNoChk(pAccNo: string): boolean;
begin
   Result := false;
   with  ADOQuery_DECLN do
   begin
      Close;
      SQL.Clear;
      SQL.Add(' SELECT ACC_NO                             '
            + ' FROM SZACBIF_INS                          '
            + ' WHERE DEPT_CODE = ''' + gvDeptcode  + ''' '
            + '   and ACC_NO    = ''' + pAccNO + '''      ');
      Try
         gf_ADOQueryOpen(ADOQuery_DECLN);
      Except
         on E : Exception do
         begin  // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZACBIF_INS]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZACBIF_INS]'); //Database ����
            Exit;
         end;
      End;

      if RecordCount >= 1  then
      begin
         gf_ShowMessage(MessageBar, mtError, 1003, ''); // �ش� ���°� �����մϴ�.
         exit;
      end;
   end;
   Result := true;
end;

//==============================================================================
// ���� ���� Insert
//==============================================================================
procedure TForm_SCFH8101.MoveInsertData_Acc;
begin
  with ADOQuery_DECLN do
  begin
    // ���μ�
    Parameters.ParamByName('pDEPT_CODE').Value := gvDeptCode;
    // ���¹�ȣ
    Parameters.ParamByName('pACC_NO').Value := Trim(DREdit_AccNo.Text);
    // ���¸�
    Parameters.ParamByName('pACC_NAME_KOR').Value := Trim(DREdit_AccNameKor.Text);
    // ���۾�����
    Parameters.ParamByName('pMANUAL_YN').Value := 'N';
    // ������ ID
    Parameters.ParamByName('pOPR_ID').Value := gvOprUsrNo;
    // ��������
    Parameters.ParamByName('pOPR_DATE').Value := gvCurDate;
    // ���۽ð�
    Parameters.ParamByName('pOPR_TIME').Value := gf_GetCurTime;
{
    // Import ID
    Parameters.ParamByName('pIMPORT_ID').Value := Trim(DREdit_ImportID);
    // Import����
    Parameters.ParamByName('pIMPORT_DATE').Value := '';
    // Import�ð�
    Parameters.ParamByName('pIMPORT_TIME').Value := '';
}
  end;
end;

//==============================================================================
// ���� ��ư Click
//==============================================================================
procedure TForm_SCFH8101.DRBitBtn4Click(Sender: TObject);
begin
  inherited;
  if not DataUpdate_Acc then Exit;
end;

//==============================================================================
// ���� ����
//==============================================================================
function TForm_SCFH8101.DataUpdate_Acc: boolean;
var
   OriginAccNameKor : string;
   CurAccNameKor : string;
   CurAccNo: string;
begin
   Result := false;
   gf_ShowMessage(MessageBar, mtInformation, 1007, ''); //���� ���Դϴ�.

   if AccCheckKeyEditEmpty then Exit;   // Key Field Edit�� ���� �׸�

   CurAccNo := Trim(DREdit_AccNo.Text);

   DisableForm;

   // ���·� ���� ��� Check
   if not UpdateDel_AccNoChk(CurAccNo) then
   begin
      EnableForm;
      DREdit_AccNo.SetFocus;
      Exit;
   end;

   // ���� ���¸�
   OriginAccNameKor := Trim(ADOQuery_DECLN.FieldByName('ACC_NAME_KOR').AsString);
   // ���� ���¸�
   CurAccNameKor    := Trim(DREdit_AccNameKor.Text);

   // ���泻�� ������
   if OriginAccNameKor = CurAccNameKor then
   begin
     SelectGridData_Acc(CurAccNo);
     EnableForm;
     DREdit_AccNo.SetFocus;
     gf_ShowMessage(MessageBar, mtInformation, 0, '��������� �����ϴ�.'); // ���� X
     Exit;
   end;

   with ADOQuery_DECLN do
   begin
      Close;
      sql.clear;
      sql.add(   // ���� ���̺� ����
             ' UPDATE SZACBIF_INS                       '
           + ' SET                                      '
           + ' DEPT_CODE        =  :pDEPT_CODE,       '
//           + ' ACC_NO           =  :pACC_NO,          '
           + ' ACC_NAME_KOR     =  :pACC_NAME_KOR,    '
           + ' OPR_ID           =  :pOPR_ID,          '
           + ' OPR_DATE         =  :pOPR_DATE,        '
           + ' OPR_TIME         =  :pOPR_TIME         '
//           + ' IMPORT_ID        =  :pIMPORT_ID,       '
//           + ' IMPORT_DATE      =  :pIMPORT_DATE,     '
//           + ' IMPORT_TIME      =  :pIMPORT_TIME      '
           + ' WHERE DEPT_CODE  = ''' + gvDeptCode + ''' '
           + ' AND   ACC_NO     = ''' + CurAccNo   + ''' ');
      MoveUpdateData_Acc;

      Try
         gf_ADOExecSQL(ADOQuery_DECLN);
      Except
         on E : Exception do
         begin
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZACBIF_INS :UPDATE]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZACBIF_INS : UPDATE]'); // Database ����
            EnableForm;
            Exit;
         end;
      end;//try
   end; //with

   InsertLog(LOG_TRG_GB_UPDATE, OriginAccNameKor, CurAccNameKor);  // SZTRLOG_HIS Insert

   QueryAllAcc;   // ��ü���� ��ȸ����
   DisplayGridAcc; // �׸��忡 ������ INPUT

   SelectGridData_Acc(CurAccNo);
   ClearInputEdit;

   EnableForm;
   DREdit_AccNo.SetFocus;
   gf_ShowMessage(MessageBar, mtInformation, 1008, ''); // ���� �Ϸ�
   Result := true;
end;

//==============================================================================
// ���µ�� check -update/delete�� check
//==============================================================================
function TForm_SCFH8101.UpdateDel_AccNoChk(pAccNo: string): boolean;
begin
   Result := false;
   with  ADOQuery_DECLN do
   begin
      Close;
      SQL.Clear;
      SQL.Add(
             ' SELECT ACC_NO, ACC_NAME_KOR                       '+
             ' FROM SZACBIF_INS                          '+
             ' WHERE DEPT_CODE = ''' + gvDeptcode  + ''' '+
             ' AND   ACC_NO    = ''' + pAccNO + ''' ');
      Try
         gf_ADOQueryOpen(ADOQuery_DECLN);
      Except
         on E : Exception do
         begin  // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZACBIF_INS]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZACBIF_INS]'); //Database ����
            Exit;
         end;
      End;

      if RecordCount <= 0  then
      begin
         gf_ShowMessage(MessageBar, mtError, 1004, ''); //�ش� ���´� �������� �ʽ��ϴ�.
         exit;
      end;
   end;
   Result := true;
end;

//==============================================================================
// ���� ���� Update
//==============================================================================
procedure TForm_SCFH8101.MoveUpdateData_Acc;
begin
  with ADOQuery_DECLN do
  begin
    // ���μ�
    Parameters.ParamByName('pDEPT_CODE').Value := gvDeptCode;
    // ���¸�
    Parameters.ParamByName('pACC_NAME_KOR').Value := Trim(DREdit_AccNameKor.Text);
    // ������ ID
    Parameters.ParamByName('pOPR_ID').Value := gvOprUsrNo;
    // ��������
    Parameters.ParamByName('pOPR_DATE').Value := gvCurDate;
    // ���۽ð�
    Parameters.ParamByName('pOPR_TIME').Value := gf_GetCurTime;
{
    // Import ID
    Parameters.ParamByName('pIMPORT_ID').Value := Trim(DREdit_ImportID);
    // Import����
    Parameters.ParamByName('pIMPORT_DATE').Value := '';
    // Import�ð�
    Parameters.ParamByName('pIMPORT_TIME').Value := '';
}
  end;
end;
//==============================================================================
// ������ư Click
//==============================================================================
procedure TForm_SCFH8101.DRBitBtn3Click(Sender: TObject);
begin
  inherited;
  if not DataDelete_Acc then exit;
end;

//==============================================================================
// ���� ����
//==============================================================================
function TForm_SCFH8101.DataDelete_Acc: boolean;
var
   CurAccNo : string;
   DeleteStr : string;
begin
   inherited;
   Result := false;
   if Trim(DREdit_AccNo.Text) = '' then  // ���� ��� ����
   begin
      gf_ShowMessage(MessageBar, mtError, 1012, '���¹�ȣ'); //�Է� ����
      DREdit_AccNo.SetFocus;
      Exit;
   end;

   CurAccNo := Trim(DREdit_AccNo.Text);
   DeleteStr := '(' + CurAccNo + ': ' + DREdit_AccNameKor.Text + ')';


   try

      // ���·� ���� ��� Check
      if not UpdateDel_AccNoChk(CurAccNo) then
      begin
//         EnableForm;
         DREdit_AccNo.SetFocus;
         Exit;
      end;

      // Confirm - ���� �����Ͻðڽ��ϱ�?
      if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 0, '���� �����Ͻðڽ��ϱ�?', mbOKCancel, 0) = idcancel then
      begin
        gf_ShowMessage(MessageBar, mtInformation, 1082, '');  // �۾��� ��ҵǾ����ϴ�.
        Exit;
      end;

      DisableForm;
      gf_ShowMessage(MessageBar, mtInformation, 1005, ''); //���� ���Դϴ�.

      with ADOQuery_DECLN do
      begin
        Close;
        sql.clear;
        sql.add(   // ���� ���̺� ����
            '  DELETE FROM  SZACBIF_INS   '+
            '  WHERE  DEPT_CODE = ''' + gvDeptCode + ''' '+
            '     AND ACC_NO    = ''' + CurAccNo + ''' ');
        Try
           gf_ADOExecSQL(ADOQuery_DECLN);
        Except
           on E : Exception do
           begin
              gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZACBIF_INS : DELETE]: ' + E.Message, 0);
              gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZACBIF_INS : DELETE]'); // Database ����
 //                  EnableForm;
              Exit;
           end;
        end;  //try
      end; //  with

      InsertLog(LOG_TRG_GB_DELETE);  // SZTRLOG_HIS Insert

      QueryAllAcc;   // ��ü���� ��ȸ����
      DisplayGridAcc; // �׸��忡 ������ INPUT

      ClearInputEdit;
//      EnableForm;
      DREdit_AccNo.SetFocus;
      gf_ShowMessage(MessageBar, mtInformation, 1006, DeleteStr ); // ���� �Ϸ�
      Result := true;
   finally
      EnableForm;
   end;
end;

//==============================================================================
// �μ� ��ư Click
//==============================================================================
procedure TForm_SCFH8101.DRBitBtn2Click(Sender: TObject);
begin
  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1100, ''); // �μ� ���Դϴ�.

   with DrStringPrint1 do
   begin
      Title  := DRPanel_Title.Caption;
      UserText1  := '';
      UserText2  := '';

      StringGrid := DRStrGrid_Acc;
//      Orientation  := poPortrait;   //poLandscape;

      Print;
   end;

   gf_ShowMessage(MessageBar, mtInformation, 1101, ''); // �μ� �Ϸ�
end;

//==============================================================================
// SZTRLOG_HIS Insert
//==============================================================================
function TForm_SCFH8101.InsertLog(pTRGGB: string; pOriginAccNameKor: string = ''; pCurAccNameKor: string = ''): boolean;
begin
   Result := false;
   with  ADOQuery_Log do
   begin
     Close;
     sql.clear;
     sql.add(   // LOG ���̺� �Է�
              ' INSERT SZTRLOG_HIS                                                '
            + '  (DEPT_CODE,    OPR_DATE,         OPR_TIME,                     '
            + '   ACC_NO,                                                      '
            + '   JOB_GB,       TRG_GB,           TR_CODE,                        '
            + '   OPR_ID,       COMMENT                                   )     '
            + ' VALUES                                                            '
            + '  (:pDEPT_CODE,   :pOPR_DATE,       :pOPR_TIME,                  '
            + '   :pACC_NO,                                                      '
            + '   :pJOB_GB,      :pTRG_GB,         :pTR_CODE,                        '
            + '   :pOPR_ID,      :pCOMMENT                                )  '
            );
{
       case pTRGGB[1] of
          LOG_TRG_GB_ADD   : MoveInsertData_Log(pTRGGB);                                    // �Է¹�ư
          LOG_TRG_GB_UPDATE:
          begin
            if pOriginAccNameKor = pCurAccNameKor then Exit;
            MoveUpdateData_Log(pTRGGB, pOriginAccNameKor, pCurAccNameKor); // ������ư
          end;
          LOG_TRG_GB_DELETE: MoveDeleteData_Log(pTRGGB);                                    // ������ư
       end;
}

      if pTRGGB = LOG_TRG_GB_ADD then  // �Է��� ��
      begin
        MoveInsertData_Log(pTRGGB);
      end
      else if pTRGGB = LOG_TRG_GB_UPDATE then// ������ ��
      begin
        if pOriginAccNameKor = pCurAccNameKor then
          Exit;
        MoveUpdateData_Log(pTRGGB, pOriginAccNameKor, pCurAccNameKor);
      end
      else                                // ������ ��
      begin
        MoveDeleteData_Log(pTRGGB);
      end;

      Try
        gf_ADOExecSQL(ADOQuery_Log);
      Except
         on E : Exception do
         begin  // DataBase ����
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Log[SZTRLOG_HIS]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Log[SZTRLOG_HIS]'); //Database ����
            Exit;
         end;
      End;

   end;
   Result := true;
end;

//==============================================================================
// �Է¹�ư ������ �� SZTRLOG_HIS�� �ֱ�
//==============================================================================
procedure TForm_SCFH8101.MoveInsertData_Log(pTRGGB: string);
begin
  with ADOQuery_Log do
  begin
    // ���μ�
    Parameters.ParamByName('pDEPT_CODE').Value := gvDeptCode;
    // ��������
    Parameters.ParamByName('pOPR_DATE').Value := gvCurDate;
    // ���۽ð�
    Parameters.ParamByName('pOPR_TIME').Value := gf_GetCurTime;
    // ���¹�ȣ
    Parameters.ParamByName('pACC_NO').Value := Trim(DREdit_AccNo.Text);
    // �۾�����
    Parameters.ParamByName('pJOB_GB').Value := LOG_JOB_GB;
    // ó������
    Parameters.ParamByName('pTRG_GB').Value := pTRGGB;
    // ȭ��TR
    Parameters.ParamByName('pTR_CODE').Value := Trim(IntToStr(Self.Tag));
    // �۾���
    Parameters.ParamByName('pOPR_ID').Value := gvOprUsrNo;
    // �۾�����
    Parameters.ParamByName('pCOMMENT').Value := '[' + Trim(DREdit_AccNo.Text) + '] ' + '�Է�';
  end;
end;

//==============================================================================
// ������ư ������ �� SZTRLOG_HIS�� �ֱ�
//==============================================================================
procedure TForm_SCFH8101.MoveUpdateData_Log(pTRGGB, pOriginAccNameKor, pCurAccNameKor: string);
begin
  with ADOQuery_Log do
  begin
    // ���μ�
    Parameters.ParamByName('pDEPT_CODE').Value := gvDeptCode;
    // ��������
    Parameters.ParamByName('pOPR_DATE').Value := gvCurDate;
    // ���۽ð�
    Parameters.ParamByName('pOPR_TIME').Value := gf_GetCurTime;
    // ���¹�ȣ
    Parameters.ParamByName('pACC_NO').Value := Trim(DREdit_AccNo.Text);
    // �۾�����
    Parameters.ParamByName('pJOB_GB').Value := LOG_JOB_GB;
    // ó������
    Parameters.ParamByName('pTRG_GB').Value := pTRGGB;
    // ȭ��TR
    Parameters.ParamByName('pTR_CODE').Value := Trim(IntToStr(Self.Tag));
    // �۾���
    Parameters.ParamByName('pOPR_ID').Value := gvOprUsrNo;
    // �۾�����
    Parameters.ParamByName('pCOMMENT').Value := '[' + Trim(DREdit_AccNo.Text) + '] '
                                              + '���¸�: ' + pOriginAccNameKor + ' -> ' +  pCurAccNameKor;
  end;
end;

//==============================================================================
// ������ư ������ �� SZTRLOG_HIS�� �ֱ�
//==============================================================================
procedure TForm_SCFH8101.MoveDeleteData_Log(pTRGGB: string);
begin
  with ADOQuery_Log do
  begin
    // ���μ�
    Parameters.ParamByName('pDEPT_CODE').Value := gvDeptCode;
    // ��������
    Parameters.ParamByName('pOPR_DATE').Value := gvCurDate;
    // ���۽ð�
    Parameters.ParamByName('pOPR_TIME').Value := gf_GetCurTime;
    // ���¹�ȣ
    Parameters.ParamByName('pACC_NO').Value := Trim(DREdit_AccNo.Text);
    // �۾�����
    Parameters.ParamByName('pJOB_GB').Value := LOG_JOB_GB;
    // ó������
    Parameters.ParamByName('pTRG_GB').Value := pTRGGB;
    // ȭ��TR
    Parameters.ParamByName('pTR_CODE').Value := Trim(IntToStr(Self.Tag));
    // �۾���
    Parameters.ParamByName('pOPR_ID').Value := gvOprUsrNo;
    // �۾�����
    Parameters.ParamByName('pCOMMENT').Value := '[' + Trim(DREdit_AccNo.Text) + '] ' + '����';
  end;
end;

end.
