unit SCOAAcronym;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SCCDlgForm, DRDialogs, StdCtrls, Buttons, DRAdditional,
  ExtCtrls, DRStandard, DRSpecial, DB, ADODB, DRCodeControl, Grids,
  DRStringgrid;


type
  TDlgForm_OAAcronym = class(TForm_Dlg)
    DRPanel1: TDRPanel;
    ADOQuery_Tmp: TADOQuery;
    DRPanel2: TDRPanel;
    DRStrGrid_AcronymLst: TDRStringGrid;
    DRPanel3: TDRPanel;
    DRLabel1: TDRLabel;
    DRLabel_Group: TDRLabel;
    DRUserCodeCombo_Group: TDRUserCodeCombo;
    DREdit_Acronym: TDREdit;
    procedure DRBitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DRStrGrid_AcronymLstDblClick(Sender: TObject);
    procedure DRStrGrid_AcronymLstSelectCell(Sender: TObject; ACol,ARow: Integer; var CanSelect: Boolean);
    procedure DRUserCodeCombo_GroupCodeChange(Sender: TObject);
    procedure DRBitBtn3Click(Sender: TObject);
    procedure DRBitBtn2Click(Sender: TObject);
    procedure DRUserCodeCombo_GroupEditKeyPress(Sender: TObject; var Key: Char);
    procedure DREdit_AcronymKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }

    function GetComboClientNM  : boolean;
    function QueryToAcronymLst : boolean;

    function SOAcronymDelete(sClient : String) : boolean;
    function SOAcronymInsert(sClient, sAcronym : String) : boolean;
    function IsSOACDataCheck(sClient : String) : Integer;
  end;

var
  DlgForm_OAAcronym: TDlgForm_OAAcronym;

implementation

{$R *.dfm}

uses
  SCCLib, SCCGlobalType;

var
   gvSelRow : Integer;    // Select Row

const
   IDX_CLIENT  = 0;  // client
   IDX_ACRONYM = 1;  // alert acronym

procedure TDlgForm_OAAcronym.DRBitBtn1Click(Sender: TObject);
begin
  inherited;

   ModalResult := mrOK;

end;

procedure TDlgForm_OAAcronym.FormCreate(Sender: TObject);
begin
  inherited;


   GetComboClientNM;
   QueryToAcronymLst;


end;

function TDlgForm_OAAcronym.QueryToAcronymLst: boolean;
var
   iRow : Integer;
begin

   result := False;

   DRStrGrid_AcronymLst.RowCount := 2;
   DRStrGrid_AcronymLst.Rows[1].Clear;

   with ADOQuery_Tmp do
   begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM SOACRONYM_TBL  '+
              ' WHERE DEPT_CODE = ''' + gvDeptCode + '''');

      try
         gf_ADOQueryOpen(ADOQuery_Tmp);
      except
      on E : Exception do
      begin
         gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Tmp[SOACRONYM_TBL select]: ' + E.Message,0);
         Exit;
      end;
      end;

      if RecordCount <= 0 then
      begin
         Exit;
      end;

      iRow := 0;
      while not EOF do
      begin
         Inc(iRow);

         DRStrGrid_AcronymLst.Cells[IDX_CLIENT,  iRow] := Trim(FieldByName('CLIENT').AsString);
         DRStrGrid_AcronymLst.Cells[IDX_ACRONYM, iRow] := Trim(FieldByName('O_ACRONYM').AsString);

         Next;
      end;

      DRStrGrid_AcronymLst.RowCount := iRow + 1;

      result := True;

   end;

end;

function TDlgForm_OAAcronym.GetComboClientNM: boolean;
begin

   result := False;

   with ADOQuery_Tmp do
   begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT distinct GRP_NAME FROM SUAGPAC_TBL  '+
              ' WHERE DEPT_CODE     = ''' + gvDeptCode + ''' '+
              '   AND SEC_TYPE      = ''' + gcSEC_EQUITY + ''' '+
              '   AND CLIENT_GRP_YN = ''Y'' '+
              ' ORDER BY GRP_NAME ');

      try
         gf_ADOQueryOpen(ADOQuery_Tmp);
      except
      on E : Exception do
      begin
         gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Tmp[SUAGPAC_TBL select]: ' + E.Message,0);
         Exit;
      end;
      end;

      if RecordCount <= 0 then
      begin
         Exit;
      end;

      while not EOF do
      begin

         DRUserCodeCombo_Group.AddItem(Trim(FieldByName('GRP_NAME').AsString),Trim(FieldByName('GRP_NAME').AsString));

         Next;
      end;

      result := True;

   end;

end;

function TDlgForm_OAAcronym.SOAcronymDelete(sClient: String): boolean;
begin

   result := False;

   with ADOQuery_Tmp do
   begin
      Close;
      SQL.Clear;
      SQL.Add('DELETE FROM SOACRONYM_TBL '+
              ' WHERE DEPT_CODE     = ''' + gvDeptCode + ''' '+
              '   AND CLIENT        = ''' + sClient    + ''' ');

      try
         gf_ADOExecSQL(ADOQuery_Tmp);
      except
      on E : Exception do
      begin
         gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Tmp[SOACRONYM_TBL Delete]: ' + E.Message,0);
         Exit;
      end;
      end;

      result := True;

   end;

end;

function TDlgForm_OAAcronym.SOAcronymInsert(sClient, sAcronym: String): boolean;
begin

   result := False;
   
   with ADOQuery_Tmp do
   begin
      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO SOACRONYM_TBL (DEPT_CODE, CLIENT, O_ACRONYM, OPR_ID, OPR_DATE, OPR_TIME)   '+
              'VALUES (:pDeptCode, :pClient, :pAcronym, :pOprID, :pOprDate, :pOprTime)');

      Parameters.ParamByName('pDeptCode').Value := gvDeptCode;
      Parameters.ParamByName('pClient').Value   := sClient;
      Parameters.ParamByName('pAcronym').Value  := sAcronym;
      Parameters.ParamByName('pOprID').Value    := gvOprUsrNo;
      Parameters.ParamByName('pOprDate').Value  := gf_GetCurDate;
      Parameters.ParamByName('pOprTime').Value  := gf_GetCurTime;

      try
         gf_ADOExecSQL(ADOQuery_Tmp);
      except
      on E : Exception do
      begin
         gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Tmp[SOACRONYM Insert]: ' + E.Message,0);
         Exit;
      end;
      end;

      result := True;

   end;

end;

procedure TDlgForm_OAAcronym.DRStrGrid_AcronymLstDblClick(Sender: TObject);
begin
  inherited;

   DRUserCodeCombo_Group.AssignCode(Trim(DRStrGrid_AcronymLst.Cells[IDX_CLIENT, gvSelRow]));
   DREdit_Acronym.Text := Trim(DRStrGrid_AcronymLst.Cells[IDX_ACRONYM, gvSelRow]);

end;

procedure TDlgForm_OAAcronym.DRStrGrid_AcronymLstSelectCell(
  Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  inherited;

   gvSelRow := ARow;

end;

procedure TDlgForm_OAAcronym.DRUserCodeCombo_GroupCodeChange(Sender: TObject);
var
   i, iSelRow : Integer;
   sClient : string;
begin
  inherited;

   DREdit_Acronym.Text := '';

   sClient := DRUserCodeCombo_Group.CodeName;

   iSelRow := -1;
   for i:=1 to DRStrGrid_AcronymLst.RowCount-1 do
   begin
      if sClient = Trim(DRStrGrid_AcronymLst.Cells[IDX_CLIENT, i]) then
      begin
         iSelRow := i;
         DREdit_Acronym.Text := Trim(DRStrGrid_AcronymLst.Cells[IDX_ACRONYM, i]);
         break;
      end;
   end;

   if iSelRow > -1 then
      gf_SelectStrGridRow(DRStrGrid_AcronymLst, iSelRow);

end;

procedure TDlgForm_OAAcronym.DRBitBtn3Click(Sender: TObject);
var
   sClient, sAcronym : string;
begin
  inherited;

   // 그룹명
   if DRUserCodeCombo_Group.CodeName = '' then
   begin
      gf_ShowMessage(MessageBar, mtError, 1012, ''); //입력 오류
      DRUserCodeCombo_Group.SetFocus;
      Exit;
   end;
   // Alert Acronym
   if DREdit_Acronym.Text = '' then
   begin
      gf_ShowMessage(MessageBar, mtError, 1012, ''); //입력 오류
      DREdit_Acronym.SetFocus;
      Exit;
   end;

   gf_ShowMessage(MessageBar, mtInformation, 1010, ''); //입력중입니다.
   DisableForm;

   sClient  := Trim(DRUserCodeCombo_Group.CodeName);
   sAcronym := Trim(DREdit_Acronym.Text);

   if SOAcronymDelete(sClient) then
   begin
     SOAcronymInsert(sClient, sAcronym);
   end;

   QueryToAcronymLst;

   EnableForm;
   gf_ShowMessage(MessageBar, mtInformation, 1011, ''); //입력완료

end;

procedure TDlgForm_OAAcronym.DRBitBtn2Click(Sender: TObject);
var
   sClient : string;
   RecCnt : Integer;
begin
  inherited;

   // 그룹명
   if DRUserCodeCombo_Group.CodeName = '' then
   begin
      gf_ShowMessage(MessageBar, mtError, 1012, ''); //입력 오류
      DRUserCodeCombo_Group.SetFocus;
      Exit;
   end;

   sClient  := Trim(DRUserCodeCombo_Group.CodeName);

   //중복데이타
   RecCnt := -1;
   RecCnt := IsSOACDataCheck(sClient);
   if RecCnt = 0   then
   begin
      gf_ShowMessage(MessageBar, mtError, 1025, ''); //해당 자료가 존재하지 않습니다.
      DRUserCodeCombo_Group.SetFocus;
      Exit;
   end else
   if RecCnt < 0 then exit;

   gf_ShowMessage(MessageBar, mtInformation, 0, '삭제중입니다.');
   DisableForm;

   SOAcronymDelete(sClient);
   QueryToAcronymLst;

   DRUserCodeCombo_Group.Clear;
   DREdit_Acronym.Text := '';

   EnableForm;
   gf_ShowMessage(MessageBar, mtConfirmation,0,'삭제완료.');

end;

procedure TDlgForm_OAAcronym.DRUserCodeCombo_GroupEditKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
  gf_ToUpper(key);

   if Key = #13 then
      DREdit_Acronym.SetFocus;
end;

procedure TDlgForm_OAAcronym.DREdit_AcronymKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
   if Key = #13 then
      DRBitBtn3.SetFocus;
end;

function TDlgForm_OAAcronym.IsSOACDataCheck(sClient: String): Integer;
begin
   result := 0;

   with ADOQuery_Tmp do
   begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT O_ACRONYM FROM SOACRONYM_TBL '
             +' WHERE DEPT_CODE = ''' + gvDeptCode + ''' '
             +'   AND CLIENT    = ''' + sClient    + ''' ');

      try
         gf_ADOQueryOpen(ADOQuery_Tmp);
      except
      on E : Exception do
      begin
         gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Tmp[SOACRONYM SELECT]: ' + E.Message,0);
         Exit;
      end;
      end;

      if RecordCount >= 1 then
         result := RecordCount;
   end;

end;

end.
