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
        gf_ShowErrDlgMessage(Self.Tag, 9001, //Database 오류
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
        gf_ShowErrDlgMessage(Self.Tag, 9001, //Database 오류
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
// 종료 버튼
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

    // user_id 선택
    if (iSelRow > 0) then
    begin
      gf_SelectStrGridRow(DRStringGrid1, iSelRow);
      DREdit_UserID.Text := Cells[0, iSelRow];
    end;

  end; // with DRStringGrid1 do

end;

//------------------------------------------------------------------------------
// 수정 버튼 클릭
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

  // 사용자 ID 입력 체크
  if (DREdit_UserID.Text = '') then
  begin
    gf_ShowMessage(MessageBar, mtError, 0, '사용자 ID 오류.');
    Exit;
  end;
  //
  if (DREdit_NewPasswd.Text = '') then
  begin
    gf_ShowMessage(MessageBar, mtError, 0, '입력 항목 누락');
    DREdit_NewPasswd.SetFocus;
    Exit;
  end;

  sCurUserID := Trim(DREdit_UserID.Text);
  GrpName := DRStringGrid1.Cells[3, iSelRow];
  UserID := '';


  gf_ShowMessage(MessageBar, mtInformation, 0, '처리 중입니다.');

  with ADOQuery_Main do
  begin
      // 기존비밀번호 입력 확인
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
        gf_ShowMessage(MessageBar, mtError, 0, '처리불가 - DB를 읽어오는 동안 오류가 발생하였습니다.');
        Exit;
      end
    end;

    // access control 체크--------------------------------------------------------
    IF (Trim(FieldByName('ACONT_YN').asString)='Y') and (not ((Pos('data', trim(DREdit_UserID.Text)) > 0) and (Length(trim(DREdit_UserID.Text)) <= 6))) THEN // ACCESS CONTROL 사용~~~~~~~~~~~~~
    begin

  //******P.H.S*******2006.06.09************************************************************************
      if not IsBigCharacter(DREdit_NewPasswd.Text) then                                // 대문자 포함여부
      begin
         gf_ShowMessage(MessageBar, mtError, 0, '비밀번호는 대문자가 1자이상 포함되어야 합니다.');
         DREdit_NewPasswd.SetFocus;
         Exit;
      end;

      // 비밀번호의 히스토리 일치 확인
      if not (IsValidPassWD(DREdit_UserID.Text, DREdit_NewPasswd.Text, TControl(MessageBar))) then
      begin
         //gf_ShowMessage(MessageBar, mtError, 0, '신규비밀번호는 기존에 이미 사용하셨습니다.');
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
          gf_ShowMessage(MessageBar, mtError, 0, '문자와 숫자를 조합하셔야 합니다.');
          DREdit_NewPasswd.SetFocus;
          Exit;
        end;

      end; //  if FieldByName('PWANMIX_YN').asString = 'Y'

      len := FieldByName('PWMINI_LENGTH').asFloat;
      strlen := FieldByName('PWMINI_LENGTH').asString;
      if Length(DREdit_NewPasswd.Text) < len then
      begin
          gf_ShowMessage(MessageBar, mtError, 0, strlen +  '자 이상 입력해 주세요.');
          DREdit_NewPasswd.SetFocus;
          Exit;
      end; //if Length(DREdit_NewPasswd.Text) < 4

      // 1. ID포함 안되게
      if FieldByName('PWEXCEPTID_YN').asString = 'Y' then
      begin
        if Pos(UpperCase(Trim(DREdit_UserID.Text)), UpperCase(Trim(DREdit_NewPasswd.Text))) > 0 then
        begin
          gf_ShowMessage(MessageBar, mtError, 0, '비밀번호에는 ID가 포함되지 않아야 합니다.');
            DREdit_NewPasswd.SetFocus;
            Exit;
        end;
      end;

      // 2. 특수문자
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
          gf_ShowMessage(MessageBar, mtError, 0, '특수문자를 조합하셔야 합니다.');
          DREdit_NewPasswd.SetFocus;
          Exit;
        end;

      end; //  FieldByName('PWSPECIAL_YN').asString = 'Y' then

      // 3.동일숫자 연속3번제한
      if FieldByName('PWSAMENO_YN').asString = 'Y' then
      begin
        for i:= 0 to Length(trim(DREdit_NewPasswd.Text)) -3 do
        begin
          sChr := copy(DREdit_NewPasswd.Text, i+1 ,1);
          if Pos(sChr + sChr + sChr, DREdit_NewPasswd.Text) > 0 then
          begin
            gf_ShowMessage(MessageBar, mtError, 0, '동일숫자 연속3번 사용 불가합니다.');
            DREdit_NewPasswd.SetFocus;
            Exit;
          end;
        end;
      end; // 3.동일숫자 연속3번제한

      // 4.연속 문자, 숫자 3번 제한
      if FieldByName('PWCONNO_YN').asString = 'Y' then
      begin
        sChr := DREdit_NewPasswd.Text;

        // 오름차순 검사
        for i:=1 to Length(sChr) do
        begin
          // 연속 3자리가 안되는 문자, 숫자 제외
          if (sChr[i] = 'y') or (sChr[i] = 'z') or
            (sChr[i] = 'Y') or (sChr[i] = 'Z') or
            (sChr[i] = '8') or (sChr[i] = '9') then Continue;

          if (Pos(Char(Ord(sChr[i])) + Char(Ord(sChr[i])+1) + Char(Ord(sChr[i])+2), sChr) > 0) then
          begin
            gf_ShowMessage(MessageBar, mtError, 0, '3번 연속된 문자, 숫자는 사용 불가합니다. (오름차순)');
            DREdit_NewPasswd.SetFocus;
            Exit;
          end;
        end;

        // 내림차순 검사
        for i:=1 to Length(sChr) do
        begin
          // 연속 3자리가 안되는 문자, 숫자 제외
          if (sChr[i] = 'y') or (sChr[i] = 'z') or
            (sChr[i] = 'Y') or (sChr[i] = 'Z') or
            (sChr[i] = '8') or (sChr[i] = '9') then Continue;

          if (Pos(Char(Ord(sChr[i])+2) + Char(Ord(sChr[i])+1) + Char(Ord(sChr[i])), sChr) > 0) then
          begin
            gf_ShowMessage(MessageBar, mtError, 0, '3번 연속된 문자, 숫자는 사용 불가합니다. (내림차순)');
            DREdit_NewPasswd.SetFocus;
            Exit;
          end;
        end;
      end; // 4.연속 문자, 숫자 3번 제한

    end; //IF Trim(FieldByName('ACONT_YN').asString)='Y'
  end; with ADOQuery_Main do

  // 관리자 처리 체크
  if UserTrCheck(GrpName) then // [9104]이 포함된 그룹이 존재하면..
  begin
    if UserGrpNum(GrpName, UserID) then //그 그룹 가진 놈이 있다.
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

  // 수정 시작
  with ADOQuery_Main do
  begin
    //=== 수정
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
      begin // DataBase 오류
        //gf_ShowErrDlgMessage(Self.Tag, 9001, 'SUUSER_TBL[Update]: ' + E.Message,0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'SUUSER_TBL[Update] ' + E.Message); //Database 오류
        Exit;
      end;
    end;
  end;

  InitComponents;
  DisplayGrid;

  gf_ShowMessage(MessageBar, mtInformation, 1008, ''); // 수정 완료

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
    except // DataBase 오류입니다.
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
    except // DataBase 오류입니다.
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
    // 부서코드
    Parameters.ParamByName('pDeptCode').Value := sCurDeptCode;
    // 사용자 ID
    Parameters.ParamByName('pUserId').Value := sCurUserID;
    // Password
    Parameters.ParamByName('pPasswd').Value := sOprShotPass;
    // Hash Password
    Parameters.ParamByName('pNewPasswd').Value := sOprFullPass;
    // 조작자 ID
    Parameters.ParamByName('pOprId').Value := gvOprUsrNo;
    // 조작일자
    Parameters.ParamByName('pOprDate').Value := gf_GetCurDate;
    // 조작시간
    Parameters.ParamByName('pOprTime').Value := gf_GetCurTime;
    // 비밀번호변경일
    Parameters.ParamByName('pPwchgeDate').Value := gf_GetCurDate;
    // 비밀번호변경시간
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

