unit SCCPasswd2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DRStringgrid, DRSpecial, StdCtrls, DRStandard, Buttons,
  DRAdditional, ExtCtrls, DB, ADODB;

type
  TForm_Passwd2 = class(TForm)
    DRPanel_Top: TDRPanel;
    DRBitBtn1: TDRBitBtn;
    DRBitBtn2: TDRBitBtn;
    DRPanel1: TDRPanel;
    DRLabel1: TDRLabel;
    DRLabel3: TDRLabel;
    DREdit_UserID: TDREdit;
    DREdit_NewPasswd: TDREdit;
    MessageBar: TDRMessageBar;
    DRStringGrid1: TDRStringGrid;
    ADOQuery_Main: TADOQuery;
    procedure DRBitBtn1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DRStringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure DRStringGrid1DblClick(Sender: TObject);
    procedure DRBitBtn2Click(Sender: TObject);
    procedure DREdit_NewPasswdKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure InitComponents;
    procedure SelectGridData;
    function DisplayGrid: boolean;
    function UserTrCheck(var GrpName: string): boolean;
    function UserGrpNum(GrpName: string; var UserID: string): boolean;
    procedure MoveData;
  public
    { Public declarations }
  end;

var
  Form_Passwd2: TForm_Passwd2;

implementation

{$R *.dfm}

uses
  SCCLib, SCCGlobalType, SCCPasswd, SCCPassHistory;

var
  sCurDeptCode, sCurUserID: string;
  DeptOpt, UserOpt: string;
  iSelRow, iSelCol: integer;

//------------------------------------------------------------------------------
// FormCreate
//------------------------------------------------------------------------------

procedure TForm_Passwd2.FormCreate(Sender: TObject);
begin
  InitComponents;

  with ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' Select OPT_VALUE '
      + ' From SUSYOPT_TBL '
      + ' Where OPT_CODE = ''S11'' ');
    try
      gf_ADOQueryOpen(ADOQuery_Main);
    except
      on E: Exception do
      begin
        gf_ShowErrDlgMessage(Self.Tag, 9001, //Database ����
          'ADOQuery_Main: ' + E.Message, 0);
        Exit;
      end;
    end;
    if RecordCount = 1 then DeptOpt := Trim(FieldByName('OPT_VALUE').asString);

    Close;
    SQL.Clear;
    SQL.Add(' Select OPT_VALUE '
      + ' From SUSYOPT_TBL '
      + ' Where OPT_CODE = ''S12'' ');
    try
      gf_ADOQueryOpen(ADOQuery_Main);
    except
      on E: Exception do
      begin
        gf_ShowErrDlgMessage(Self.Tag, 9001, //Database ����
          'ADOQuery_Main: ' + E.Message, 0);
        Exit;
      end;
    end;
    if RecordCount = 1 then UserOpt := Trim(FieldByName('OPT_VALUE').asString);
  end; // with ADOQuery_Temp do

end;

//------------------------------------------------------------------------------
// FormActivate
//------------------------------------------------------------------------------

procedure TForm_Passwd2.FormActivate(Sender: TObject);
begin
  if ((gvB9101Data.sDeptCode = '') or
    (gvB9101Data.sUserID = '')) then Exit;

  sCurDeptCode := gvB9101Data.sDeptCode;
  sCurUserID := gvB9101Data.sUserID;

  gvB9101Data.sDeptCode := '';
  gvB9101Data.sUserID := '';

  DisplayGrid;
  SelectGridData;

end;

//------------------------------------------------------------------------------
// ���� ��ư
//------------------------------------------------------------------------------

procedure TForm_Passwd2.DRBitBtn1Click(Sender: TObject);
begin
  ModalResult := IDCLOSE;
end;

//------------------------------------------------------------------------------
// InitComponents
//------------------------------------------------------------------------------

procedure TForm_Passwd2.InitComponents;
var
  i: integer;
begin

  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TDREdit) then
      TDREdit(Components[i]).Clear
  end; // for i:=0 to ComponentCount-1 do
end;

//------------------------------------------------------------------------------
// DisplayGrid
//------------------------------------------------------------------------------

function TForm_Passwd2.DisplayGrid: boolean;
var
  iRow: integer;
begin

  Result := True;

  iRow := 0;

  with ADOQuery_Main, DRStringGrid1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT USER_ID, USER_NAME,       ');
    SQL.Add('       PASSWD, NEW_PASSWD,       ');
    SQL.Add('	      PWCHGE_DATE, PWCHGE_TIME, ');
    SQL.Add('	      USER_GRP_CODE             ');
    SQL.Add('FROM SUUSER_TBL                  ');
    SQL.Add('WHERE DEPT_CODE = ''' + sCurDeptCode + ''' ');

    try
      gf_ADOQueryOpen(ADOQuery_Main);
    except
      on E: Exception do
      begin
        gf_ShowMessage(MessageBar, mtError, 0, 'ADO Err. [DisplayGrid] ' + E.Message);
        Result := False;
      end;
    end;

    RowCount := 2;
    Rows[1].Clear;

    if RecordCount > 0 then
    begin
      First;
      while not Eof do
      begin
        Inc(iRow);
        Cells[0, iRow] := Trim(FieldByName('USER_ID').AsString);
        Cells[1, iRow] := Trim(FieldByName('USER_NAME').AsString);
        Cells[2, iRow] := gf_FormatDate(Trim(FieldByName('PWCHGE_DATE').asString)) + ' '
          + gf_FormatTime(Trim(FieldByName('PWCHGE_TIME').asString));
        Cells[3, iRow] := Trim(FieldByName('USER_GRP_CODE').asString);

        Next;
      end; // while Not Eof do
    end; // if RecordCount > 0 then

    RowCount := iRow + 1;

  end; // with ADOQuery_Main do

end;

//------------------------------------------------------------------------------
// DRStringGrid1SelectCell
//------------------------------------------------------------------------------

procedure TForm_Passwd2.DRStringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  iSelRow := ARow;
  iSelCol := ACol;
end;

//------------------------------------------------------------------------------
// DRStringGrid1DblClick
//------------------------------------------------------------------------------

procedure TForm_Passwd2.DRStringGrid1DblClick(Sender: TObject);
begin
  if (iSelRow > 0) then
  begin
    InitComponents;
    sCurUserID := Trim(DRStringGrid1.Cells[0, iSelRow]);
    DREdit_UserID.Text := sCurUserID;
  end;
end;

//------------------------------------------------------------------------------
// SelectGridData
//------------------------------------------------------------------------------

procedure TForm_Passwd2.SelectGridData;
var
  i: integer;
begin

  i := 0;

  with DRStringGrid1 do
  begin

    for i := 1 to RowCount - 1 do
    begin
      if (Cells[0, i] = sCurUserID) then
      begin
        iSelRow := i;
        Break;
      end;
    end; // for i:=1 to RowCount-1 do

    // user_id ����
    if (iSelRow > 0) then
    begin
      gf_SelectStrGridRow(DRStringGrid1, iSelRow);
      DREdit_UserID.Text := Cells[0, iSelRow];
    end;

  end; // with DRStringGrid1 do

end;

//------------------------------------------------------------------------------
// ���� ��ư Ŭ��
//------------------------------------------------------------------------------

procedure TForm_Passwd2.DRBitBtn2Click(Sender: TObject);
var
  GrpName, UserID: string;
  strShortPass, test, strlen: string;
  len: Double;
  i, j, iChr: integer;
  number, character, ascii, sp_character: boolean;
  sChr: string;
begin
  sp_character := false;
  sChr := '';

  // ����� ID �Է� üũ
  if (DREdit_UserID.Text = '') then
  begin
    gf_ShowMessage(MessageBar, mtError, 0, '����� ID ����.');
    Exit;
  end;
  //
  if (DREdit_NewPasswd.Text = '') then
  begin
    gf_ShowMessage(MessageBar, mtError, 0, '�Է� �׸� ����');
    DREdit_NewPasswd.SetFocus;
    Exit;
  end;

  sCurUserID := Trim(DREdit_UserID.Text);
  GrpName := DRStringGrid1.Cells[3, iSelRow];
  UserID := '';


  gf_ShowMessage(MessageBar, mtInformation, 0, 'ó�� ���Դϴ�.');

  with ADOQuery_Main do
  begin
      // ������й�ȣ �Է� Ȯ��
    Close;
    SQL.Clear;
    SQL.Add('SELECT u.USER_ID,a.OPR_ID,a.ACONT_YN, ');
    SQL.Add('       a.PWMINI_LENGTH,a.PWANMIX_YN, a.PWEXCEPTID_YN,  ');
    SQL.Add('       u.NEW_PASSWD, u.PASSWD, a.PWSPECIAL_YN, a.PWSAMENO_YN, a.PWCONNO_YN   ');
    SQL.Add('FROM SUUSER_TBL u,SUACCCON_TBL a      ');
    SQL.Add('WHERE u.USER_ID = :pUserID            ');
//      SQL.Add('  and a.OPR_ID  =* u.USER_ID          ');
    Parameters.ParamByName('pUserID').Value := DREdit_UserID.Text;
    try
      gf_ADOQueryOpen(ADOQuery_Main);
    except on E: Exception do
      begin
        gf_ShowErrDlgMessage(Self.Tag, 0, 'ADOQuery_Main: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 0, 'ó���Ұ� - DB�� �о���� ���� ������ �߻��Ͽ����ϴ�.');
        Exit;
      end
    end;

    // access control üũ--------------------------------------------------------
    IF (Trim(FieldByName('ACONT_YN').asString)='Y') and (not ((Pos('data', trim(DREdit_UserID.Text)) > 0) and (Length(trim(DREdit_UserID.Text)) <= 6))) THEN // ACCESS CONTROL ���~~~~~~~~~~~~~
    begin

  //******P.H.S*******2006.06.09************************************************************************
      if not IsBigCharacter(DREdit_NewPasswd.Text) then                                // �빮�� ���Կ���
      begin
         gf_ShowMessage(MessageBar, mtError, 0, '��й�ȣ�� �빮�ڰ� 1���̻� ���ԵǾ�� �մϴ�.');
         DREdit_NewPasswd.SetFocus;
         Exit;
      end;

      // ��й�ȣ�� �����丮 ��ġ Ȯ��
      if not (IsValidPassWD(DREdit_UserID.Text, DREdit_NewPasswd.Text, TControl(MessageBar))) then
      begin
         //gf_ShowMessage(MessageBar, mtError, 0, '�űԺ�й�ȣ�� ������ �̹� ����ϼ̽��ϴ�.');
         DREdit_NewPasswd.SetFocus;
         Exit;
      end;

  //******P.H.S*******2006.06.09************************************************************************

      if FieldByName('PWANMIX_YN').asString = 'Y' then
      begin
        for i:=1 to Length(DREdit_NewPasswd.Text) do
        begin
         test := copy(DREdit_NewPasswd.Text, i, 1);
         if ((test >= '0') and (test <= '9')) then number := true
         else if  ((test >= 'A') and (test <= 'Z')) or ((test >= 'a') and (test <= 'z')) then character := true
         else ascii := true;
        end; //for
        {
        if ((number = true) and  (character = false) and (ascii = false) ) or
           ((number = false) and  (character = true) and (ascii = false) ) or
           ((number = false) and  (character = false) and (ascii = true) ) then
        }
        if ((number = true) and  (character = false)) or
           ((number = false) and  (character = true)) then
        begin
          gf_ShowMessage(MessageBar, mtError, 0, '���ڿ� ���ڸ� �����ϼž� �մϴ�.');
          DREdit_NewPasswd.SetFocus;
          Exit;
        end;

      end; //  if FieldByName('PWANMIX_YN').asString = 'Y'

      len := FieldByName('PWMINI_LENGTH').asFloat;
      strlen := FieldByName('PWMINI_LENGTH').asString;
      if Length(DREdit_NewPasswd.Text) < len then
      begin
          gf_ShowMessage(MessageBar, mtError, 0, strlen +  '�� �̻� �Է��� �ּ���.');
          DREdit_NewPasswd.SetFocus;
          Exit;
      end; //if Length(DREdit_NewPasswd.Text) < 4

      // 1. ID���� �ȵǰ�
      if FieldByName('PWEXCEPTID_YN').asString = 'Y' then
      begin
        if Pos(UpperCase(Trim(DREdit_UserID.Text)), UpperCase(Trim(DREdit_NewPasswd.Text))) > 0 then
        begin
          gf_ShowMessage(MessageBar, mtError, 0, '��й�ȣ���� ID�� ���Ե��� �ʾƾ� �մϴ�.');
            DREdit_NewPasswd.SetFocus;
            Exit;
        end;
      end;

      // 2. Ư������
      if FieldByName('PWSPECIAL_YN').asString = 'Y' then
      begin
        for i:=1 to Length(DREdit_NewPasswd.Text) do
        begin
         test := copy(DREdit_NewPasswd.Text, i, 1);

         if not (((test >= '0') and (test <= '9')) or
                (((test >= 'A') and (test <= 'Z')) or ((test >= 'a') and (test <= 'z'))) or
                ((test = '#9') or (test = '#10') or (test = '#11') or (test = '#12') or
                (test = '#13') or (test = '#32'))) then sp_character := true

        end; //for

        if (sp_character <> true) then
        begin
          gf_ShowMessage(MessageBar, mtError, 0, 'Ư�����ڸ� �����ϼž� �մϴ�.');
          DREdit_NewPasswd.SetFocus;
          Exit;
        end;

      end; //  FieldByName('PWSPECIAL_YN').asString = 'Y' then

      // 3.���ϼ��� ����3������
      if FieldByName('PWSAMENO_YN').asString = 'Y' then
      begin
        for i:= 0 to Length(trim(DREdit_NewPasswd.Text)) -3 do
        begin
          sChr := copy(DREdit_NewPasswd.Text, i+1 ,1);
          if Pos(sChr + sChr + sChr, DREdit_NewPasswd.Text) > 0 then
          begin
            gf_ShowMessage(MessageBar, mtError, 0, '���ϼ��� ����3�� ��� �Ұ��մϴ�.');
            DREdit_NewPasswd.SetFocus;
            Exit;
          end;
        end;
      end; // 3.���ϼ��� ����3������

      // 4.���� ����, ���� 3�� ����
      if FieldByName('PWCONNO_YN').asString = 'Y' then
      begin
        sChr := DREdit_NewPasswd.Text;

        // �������� �˻�
        for i:=1 to Length(sChr) do
        begin
          // ���� 3�ڸ��� �ȵǴ� ����, ���� ����
          if (sChr[i] = 'y') or (sChr[i] = 'z') or
            (sChr[i] = 'Y') or (sChr[i] = 'Z') or
            (sChr[i] = '8') or (sChr[i] = '9') then Continue;

          if (Pos(Char(Ord(sChr[i])) + Char(Ord(sChr[i])+1) + Char(Ord(sChr[i])+2), sChr) > 0) then
          begin
            gf_ShowMessage(MessageBar, mtError, 0, '3�� ���ӵ� ����, ���ڴ� ��� �Ұ��մϴ�. (��������)');
            DREdit_NewPasswd.SetFocus;
            Exit;
          end;
        end;

        // �������� �˻�
        for i:=1 to Length(sChr) do
        begin
          // ���� 3�ڸ��� �ȵǴ� ����, ���� ����
          if (sChr[i] = 'y') or (sChr[i] = 'z') or
            (sChr[i] = 'Y') or (sChr[i] = 'Z') or
            (sChr[i] = '8') or (sChr[i] = '9') then Continue;

          if (Pos(Char(Ord(sChr[i])+2) + Char(Ord(sChr[i])+1) + Char(Ord(sChr[i])), sChr) > 0) then
          begin
            gf_ShowMessage(MessageBar, mtError, 0, '3�� ���ӵ� ����, ���ڴ� ��� �Ұ��մϴ�. (��������)');
            DREdit_NewPasswd.SetFocus;
            Exit;
          end;
        end;
      end; // 4.���� ����, ���� 3�� ����

    end; //IF Trim(FieldByName('ACONT_YN').asString)='Y'
  end; with ADOQuery_Main do

  // ������ ó�� üũ
  if UserTrCheck(GrpName) then // [9104]�� ���Ե� �׷��� �����ϸ�..
  begin
    if UserGrpNum(GrpName, UserID) then //�� �׷� ���� ���� �ִ�.
    begin
      if UserOpt = 'Y' then
      begin
        Application.CreateForm(TForm_Passwd, Form_Passwd);
        Form_Passwd.ShowModal;
        if (Form_Passwd.ModalResult = IdAbort) or (Form_Passwd.ModalResult = IdCancel) then
        begin
          gf_ShowMessage(MessageBar, mtError, 1082, '');
             //DREdit_UserId.SetFocus;
          Exit;
        end;
        Form_Passwd.Free;
      end;
    end;
  end;

  // ���� ����
  with ADOQuery_Main do
  begin
    //=== ����
    Close;
    SQL.Clear;
    SQL.Add('Update SUUSER_TBL                 ');
    SQL.Add('Set                               ');
    SQL.Add('    PASSWD        = :pPasswd,     ');
    SQL.Add('    NEW_PASSWD    = :pNewPasswd,  ');
    SQL.Add('    OPR_ID        = :pOprId,      ');
    SQL.Add('    OPR_DATE      = :pOprDate,    ');
    SQL.Add('    OPR_TIME      = :pOprTime,    ');
    SQL.Add('    PWCHGE_DATE   = :pPwchgeDate, ');
    SQL.Add('    PWCHGE_TIME   = :pPwchgeTime  ');
    SQL.Add('Where DEPT_CODE = :pDeptCode      ');
    SQL.Add('  AND USER_ID   = :pUserID        ');
    MoveData; // Parameter Passing

    try
      gf_ADOExecSQL(ADOQuery_Main);
    except
      on E: Exception do
      begin // DataBase ����
        //gf_ShowErrDlgMessage(Self.Tag, 9001, 'SUUSER_TBL[Update]: ' + E.Message,0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'SUUSER_TBL[Update] ' + E.Message); //Database ����
        Exit;
      end;
    end;
  end;

  InitComponents;
  DisplayGrid;

  gf_ShowMessage(MessageBar, mtInformation, 1008, ''); // ���� �Ϸ�

end;

function TForm_Passwd2.UserTrCheck(var GrpName: string): boolean;
begin
  Result := false;

  with ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    if DeptOpt = 'Y' then
    begin
      SQL.Add(' SELECT USER_GRP_CODE, TR_CODE FROM SUUGPTR_TBL    '
        + ' WHERE  DEPT_CODE =  ''' + gvDeptCode + '''        ');
    end else
      SQL.Add(' SELECT USER_GRP_CODE, TR_CODE FROM SUUGPTR_TBL    ');

    try
      gf_ADOQueryOpen(ADOQuery_Main);
    except // DataBase �����Դϴ�.
      on E: Exception do
      begin
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Main[SUUSER_TBL]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Main[SUUSER_TBL]');
        Exit;
      end;
    end;

    while not Eof do
    begin
      if Trim(FieldByName('TR_CODE').asString) = '9104' then
      begin
        GrpName := Trim(FieldByName('USER_GRP_CODE').asString);
        Result := True;
        Exit;
      end;
      Next;
    end; // while not Eof do
  end; // with ADOQuery_SUUSER do
end;

function TForm_Passwd2.UserGrpNum(GrpName: string;
  var UserID: string): boolean;
begin
  Result := false;
  with ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    if DeptOpt = 'Y' then
    begin
      SQL.Add(' SELECT U.* FROM SUUSER_TBL U '
        + ' WHERE  U.USER_GRP_CODE = ''' + GrpName + '''        '
        + '   AND  U.DEPT_CODE =  ''' + gvDeptCode + '''        ');
    end else
    begin
      SQL.Add(' SELECT U.* FROM SUUSER_TBL U '
        + ' WHERE  U.USER_GRP_CODE = ''' + GrpName + '''        ');
    end;
    try
      gf_ADOQueryOpen(ADOQuery_Main);
    except // DataBase �����Դϴ�.
      on E: Exception do
      begin
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Main[SUUSER_TBL]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Main[SUUSER_TBL]');
        Exit;
      end;
    end;
    if RecordCount > 0 then
    begin
      UserID := trim(FieldByName('USER_ID').asstring);
      Result := True;
    end;

  end; // with ADOQuery_SUUSER do
end;

procedure TForm_Passwd2.MoveData;
var
  sOprShotPass, sOprFullPass: string;
begin

  sOprFullPass := gfEncryption(DREdit_NewPasswd.Text, gvUserEnrpYN, sOprShotPass);

  with ADOQuery_Main do
  begin
    // �μ��ڵ�
    Parameters.ParamByName('pDeptCode').Value := sCurDeptCode;
    // ����� ID
    Parameters.ParamByName('pUserId').Value := sCurUserID;
    // Password
    Parameters.ParamByName('pPasswd').Value := sOprShotPass;
    // Hash Password
    Parameters.ParamByName('pNewPasswd').Value := sOprFullPass;
    // ������ ID
    Parameters.ParamByName('pOprId').Value := gvOprUsrNo;
    // ��������
    Parameters.ParamByName('pOprDate').Value := gf_GetCurDate;
    // ���۽ð�
    Parameters.ParamByName('pOprTime').Value := gf_GetCurTime;
    // ��й�ȣ������
    Parameters.ParamByName('pPwchgeDate').Value := gf_GetCurDate;
    // ��й�ȣ����ð�
    Parameters.ParamByName('pPwchgeTime').Value := gf_GetCurTime;
  end;
end;

procedure TForm_Passwd2.DREdit_NewPasswdKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key = #13) then
    DRBitBtn2.SetFocus;
end;

end.

