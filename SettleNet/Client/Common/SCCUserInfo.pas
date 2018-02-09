//------------------------------------------------------------------------------
//   [C.I.K] 2001.08.20
//          : 사용자 정보 관리
//   [O.J.E] 2002.11.22
//          : 비번문자제약(문자+숫자,길이..)
//------------------------------------------------------------------------------
unit SCCUserInfo;  

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCCDlgForm, StdCtrls, Buttons, DRAdditional, ExtCtrls, DRStandard,
  DRSpecial, DRColorTab, Db, ADODB, DRDialogs;

type
  TForm_UserInfo = class(TForm_Dlg)
    DRPageControl_UserInfo: TDRPageControl;
    DRTabSheet_SecretNum: TDRTabSheet;
    ADOQuery_Main: TADOQuery;
    ADOQuery_Temp: TADOQuery;
    DRTabSheet_Mail: TDRTabSheet;
    DRLabel1: TDRLabel;
    DREdit_UserName: TDREdit;
    DREdit_MailAdd: TDREdit;
    DRLabel2: TDRLabel;
    DRBevel1: TDRBevel;
    DRLabel3: TDRLabel;
    DRMemo_Sign: TDRMemo;
    DRPanel1: TDRPanel;
    DRLabel4: TDRLabel;
    DREdit_UserID: TDREdit;
    DRLabel5: TDRLabel;
    DREdit_CurPswrd: TDREdit;
    DRLabel6: TDRLabel;
    DREdit_NewPswrd: TDREdit;
    DRLabel7: TDRLabel;
    DREdit_ConfirmPswrd: TDREdit;
    ADOQuery_TempA: TADOQuery;
    procedure FormCreate(Sender: TObject);
    function InitDataDisplay: boolean;
    procedure DRBitBtn2Click(Sender: TObject);
    procedure ClearDisplayData;
    procedure DRBitBtn3Click(Sender: TObject);
    function EditDataCheck: boolean;
    function DataExistCheck: boolean;
    function DataExistSUAccconCheck : boolean;
    procedure InsertData;
    procedure UpDateData;
    procedure DREdit_UserNameKeyPress(Sender: TObject; var Key: Char);
    procedure DREdit_MailAddKeyPress(Sender: TObject; var Key: Char);
    procedure CancelSecretNumPage;
    procedure CancelMailPage;
    procedure ConfirmSecretNumPage;
    procedure ConfirmMailPage;
    procedure DREdit_CurPswrdKeyPress(Sender: TObject; var Key: Char);
    procedure DREdit_NewPswrdKeyPress(Sender: TObject; var Key: Char);
    procedure DREdit_ConfirmPswrdKeyPress(Sender: TObject; var Key: Char);
    procedure DRPageControl_UserInfoChange(Sender: TObject);
    procedure DRMemo_SignChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_UserInfo: TForm_UserInfo;

implementation

{$R *.DFM}

uses
  SCCLib, SCCGlobalType, SCCPassHistory;

const
  TAB_IDX_SECNUM = 0;
  TAB_IDX_MAIL   = 1;

//------------------------------------------------------------------------------
//  폼 생성
//------------------------------------------------------------------------------
procedure TForm_UserInfo.FormCreate(Sender: TObject);
begin
  inherited;
  DREdit_UserID.Text := gvOprUsrNo;
  ClearDisplayData;
  if not InitDataDisplay then
  begin
    DREdit_UserName.Text := gvOprUsrName;
  end;
end;


//------------------------------------------------------------------------------
//  화면 생성시 초기화
//------------------------------------------------------------------------------
function TForm_UserInfo.InitDataDisplay: boolean;
begin
  Result := False;
  With ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' SELECT MAIL_USER_NAME, MAIL_ADDR, MAIL_TAIL    '
          + ' FROM SUMYINF_TBL                               '
          + ' WHERE USER_ID = ''' + gvOprUsrNo + '''         ');

    Try
      gf_ADOQueryOpen(ADOQuery_Main);
    Except
      on E : Exception do
      begin
        gf_ShowErrDlgMessage(Self.Tag, 9001,
                             'ADOQuery_Main[Query]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Main[Query]'); // Database 오류
        Exit;
      end;
    end;

    if RecordCount = 0 then
    begin
      Exit;
    end;

    While not Eof do
    begin
      DREdit_UserName.Text := Trim(FieldByName('MAIL_USER_NAME').asString);
      DREdit_MailAdd.Text := Trim(FieldByName('MAIL_ADDR').asString);
      DRMemo_Sign.Lines.Add(Trim(FieldByName('MAIL_TAIL').asString));
      DRMemo_Sign.SelStart  := 0;
      DRMemo_Sign.SelLength := 0;
      Next;
    end;
  end;
  Result := True;
end;


//------------------------------------------------------------------------------
//  취소 버튼을 누른 경우
//------------------------------------------------------------------------------
procedure TForm_UserInfo.DRBitBtn2Click(Sender: TObject);
begin
  inherited;
  case DRPageControl_UserInfo.ActivePage.PageIndex of
    TAB_IDX_SECNUM : CancelSecretNumPage;
    TAB_IDX_MAIL : CancelMailPage;
  end; // end of case
end;


//------------------------------------------------------------------------------
//  화면 데이타 초기화
//------------------------------------------------------------------------------
procedure TForm_UserInfo.ClearDisplayData;
begin
  DREdit_UserName.Clear;
  DREdit_MailAdd.Clear;
  DRMemo_Sign.Lines.Clear;
  gf_ClearMessage(MessageBar);
end;


//------------------------------------------------------------------------------
//  확인 버튼을 누른 경우
//------------------------------------------------------------------------------
procedure TForm_UserInfo.DRBitBtn3Click(Sender: TObject);
begin
  inherited;
  case DRPageControl_UserInfo.ActivePage.PageIndex of
    TAB_IDX_SECNUM : ConfirmSecretNumPage;
    TAB_IDX_MAIL   : ConfirmMailPage;
  end; // end of case
end;


//------------------------------------------------------------------------------
//  입력된 데이타 존재하는지 체크
//------------------------------------------------------------------------------
function TForm_UserInfo.DataExistCheck: boolean;
begin
  Result := False;
  With ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' SELECT USER_ID                             '
          + ' FROM SUMYINF_TBL                           '
          + ' WHERE USER_ID = ''' + gvOprUsrNo + '''     ');

    Try
      gf_ADOQueryOpen(ADOQuery_Temp);
    Except
      on E : Exception do
      begin
        gf_ShowErrDlgMessage(Self.Tag, 9001,
                             'ADOQuery_Temp[Query]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[Query]'); // Database 오류
        Exit;
      end;
    end;

    if RecordCount = 0 then
    begin
      Exit;
    end;
  end;
  Result := True;
end;
//------------------------------------------------------------------------------
//  입력된 데이타가 SUACCCON_TBL에  존재하는지 체크
//------------------------------------------------------------------------------

function TForm_UserInfo.DataExistSUAccconCheck: boolean;
begin
  Result := False;
  With ADOQuery_TempA do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' SELECT OPR_ID                             '
          + ' FROM SUACCCON_TBL                           '
          + ' WHERE OPR_ID = ''' + gvOprUsrNo + '''     ');

    Try
      gf_ADOQueryOpen(ADOQuery_TempA);
    Except
      on E : Exception do
      begin
        gf_ShowErrDlgMessage(Self.Tag, 9001,
                             'ADOQuery_TempA[Query]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_TempA[Query]'); // Database 오류
        Exit;
      end;
    end;

    if RecordCount = 0 then
    begin
      Exit;
    end;
  end;
  Result := True;
end;



//------------------------------------------------------------------------------
//  데이타 입력하기
//------------------------------------------------------------------------------
procedure TForm_UserInfo.InsertData;
var
  sFileName : String;
  sSignFile : TextFile;
  i : integer;
begin
  DisableForm;

  // Header File 생성
  sFileName := gvDirTemp + Self.Name;
  AssignFile(sSignFile, sFileName);
  {$I-}
  Rewrite(sSignFile);
  {$I+}
  if IOResult <> 0 then
  begin
    gf_ShowMessage(MessageBar, mtError, 9006, 'Saving Text Field'); //파일 생성 오류
    CloseFile(sSignFile);
    EnableForm;
    Exit;
  end;

  for i := 0 to DRMemo_Sign.Lines.Count -1 do
  begin
    WriteLn(sSignFile, DRMemo_Sign.Lines[i]);
  end;

  CloseFile(sSignFile);

  With ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' INSERT SUMYINF_TBL                                     '
          + ' (USER_ID, MAIL_USER_NAME, MAIL_ADDR, MAIL_TAIL,        '
          + '  OPR_ID, OPR_DATE, OPR_TIME)                           '
          + ' VALUES                                                 '
          + ' (:pUserID, :pMailUserName, :pMailAddr, :pMailTail,     '
          + '  :pOprId, :pOprDate, :pOprTime )                       ');

    // 사용자 ID
    Parameters.ParamByName('pUserID').Value := gvOprUsrNo;
    // 사용자명
    Parameters.ParamByName('pMailUserName').Value := Trim(DREdit_UserName.Text);
    // 메일주소
    Parameters.ParamByName('pMailAddr').Value := Trim(DREdit_MailAdd.Text);
    // 서명
    Parameters.ParamByName('pMailTail').LoadFromFile(sFileName, ftMemo);
    // 조작자
    Parameters.ParamByName('pOprId').Value    := gvOprUsrNo;
    // 조작일자
    Parameters.ParamByName('pOprDate').Value  := gvCurDate;
    // 조작시간
    Parameters.ParamByName('pOprTime').Value  := gf_GetCurTime;

    Try
      gf_ADOExecSQL(ADOQuery_Main);
    Except
      on E : Exception do
      begin  // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Main[Insert]: ' + E.Message,0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Main[Insert]'); //Database 오류
        EnableForm;
        Exit;
      end;
    End;
  end; // end of with
  EnableForm;
  DeleteFile(sFileName);
  DREdit_UserName.SetFocus;
  gf_ShowMessage(MessageBar, mtInformation, 1011, ''); // 입력 완료
end;


//------------------------------------------------------------------------------
//  입력한 데이타가 맞는지 체크
//------------------------------------------------------------------------------
function TForm_UserInfo.EditDataCheck: boolean;
var
   sMailAdd : string;
   sCheck : string;
   i, j : integer;
   eCount, cCount : Integer;
begin
  Result := False;
  eCount := 0;
  cCount := 0;
  sCheck := '';

  if Trim(DREdit_UserName.Text) = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, '사용자명을 입력하세요.'); //입력 오류
    DREdit_UserName.SetFocus;
    Exit;
  end;

  if Trim(DREdit_MailAdd.Text) = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, '메일주소를 입력하세요.'); //입력 오류
    DREdit_MailAdd.SetFocus;
    Exit;
  end;

  sMailAdd := DREdit_MailAdd.Text;

  for i:=1 to Length(sMailAdd) do
  begin
    if (sMailAdd[i] = #64) then Inc(eCount);
  end;

  if  (eCount <> 1) or
      (sMailAdd[1] = #64) or
      (sMailAdd[length(sMailAdd)] = #64) then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, '올바른 메일주소를 입력하세요.'); //입력 오류
    DREdit_MailAdd.SetFocus;
    Exit;
  end else
  begin
    sCheck := Copy(sMailAdd, Pos(#64,sMailAdd)+1, length(sMailAdd));

    for j:=1 to Length(sCheck) do
    begin
      if (sCheck[j] = #46) then Inc(cCount);
    end;

    if (cCount < 1) or
       (sCheck[1] = #46) or
       (sCheck[Length(sCheck)] = #46) then
    begin
      gf_ShowMessage(MessageBar, mtError, 1012, '올바른 메일주소를 입력하세요.'); //입력 오류
      DREdit_MailAdd.SetFocus;
      Exit;
    end;
  end;

  Result := True;
end;


//------------------------------------------------------------------------------
//  데이타 수정하기
//------------------------------------------------------------------------------
procedure TForm_UserInfo.UpDateData;
var
  sFileName : String;
  sSignFile : TextFile;
  i : integer;
begin
  DisableForm;

  // Header File 생성
  sFileName := gvDirTemp + Self.Name;
  AssignFile(sSignFile, sFileName);
  {$I-}
  Rewrite(sSignFile);
  {$I+}
  if IOResult <> 0 then
  begin
    gf_ShowMessage(MessageBar, mtError, 9006, 'Saving Text Field'); //파일 생성 오류
    CloseFile(sSignFile);
    EnableForm;
    Exit;
  end;

  for i := 0 to DRMemo_Sign.Lines.Count -1 do
  begin
    WriteLn(sSignFile, DRMemo_Sign.Lines[i]);
  end;

  CloseFile(sSignFile);

  With ADOQuery_Main do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' UPDATE SUMYINF_TBL                        '
          + ' SET                                       '
          + '   MAIL_USER_NAME = :pMailUserName,        '
          + '   MAIL_ADDR = :pMailAddr,                 '
          + '   MAIL_TAIL = :pMailTail,                 '
          + '   OPR_ID = :pOprId,                       '
          + '   OPR_DATE = :pOprDate,                   '
          + '   OPR_TIME = :pOprTime                    '
          + ' WHERE USER_ID = ''' + gvOprUsrNo + '''    ');

    // 사용자명
    Parameters.ParamByName('pMailUserName').Value := Trim(DREdit_UserName.Text);
    // 메일주소
    Parameters.ParamByName('pMailAddr').Value := Trim(DREdit_MailAdd.Text);
    // 서명
    Parameters.ParamByName('pMailTail').LoadFromFile(sFileName, ftMemo);
    // 조작자
    Parameters.ParamByName('pOprId').Value    := gvOprUsrNo;
    // 조작일자
    Parameters.ParamByName('pOprDate').Value  := gvCurDate;
    // 조작시간
    Parameters.ParamByName('pOprTime').Value  := gf_GetCurTime;

    Try
      gf_ADOExecSQL(ADOQuery_Main);
    Except
      on E : Exception do
      begin  // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Main[Update]: ' + E.Message,0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Main[Update]'); //Database 오류
        EnableForm;
        Exit;
      end;
    End;
  end; // end of with
  EnableForm;
  DeleteFile(sFileName);
  DREdit_UserName.SetFocus;
  gf_ShowMessage(MessageBar, mtInformation, 1011, ''); // 입력 완료
end;


//------------------------------------------------------------------------------
//  사용자명 입력시 KeyPress 처리
//------------------------------------------------------------------------------
procedure TForm_UserInfo.DREdit_UserNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if (Key = #39) or (Key= #58) or
     (Key = #60) or (Key = #62) then  // 특수문자 ( ', :, < ,> )  입력제한
  begin
     Key := #0;
     gf_ShowMessage(MessageBar, mtError, 0, '허용되지 않는 특수문자를 입력하셨습니다.');
  end;
  If Key = #13 Then
    DREdit_MailAdd.SetFocus;
end;



//------------------------------------------------------------------------------
//  메일주소 입력시 KeyPress 처리
//------------------------------------------------------------------------------
procedure TForm_UserInfo.DREdit_MailAddKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if (Key = #39) or (Key= #58) then // 특수문자 ( ', : )  입력제한
  begin
     Key := #0;
     gf_ShowMessage(MessageBar, mtError, 0, '허용되지 않는 특수문자를 입력하셨습니다.');
  end;
  If Key = #13 Then
    DRMemo_Sign.SetFocus;
end;


//------------------------------------------------------------------------------
//  비밀번호에서 취소를 누른 경우
//------------------------------------------------------------------------------
procedure TForm_UserInfo.CancelSecretNumPage;
begin
  DREdit_CurPswrd.Clear;
  DREdit_NewPswrd.Clear;
  DREdit_ConfirmPswrd.Clear;
  DREdit_CurPswrd.SetFocus;
end;


//------------------------------------------------------------------------------
//  메일에서 취소를 누른 경우
//------------------------------------------------------------------------------
procedure TForm_UserInfo.CancelMailPage;
begin
  ClearDisplayData;
  if not InitDataDisplay then
  begin
    DREdit_UserName.Text := gvOprUsrName;
  end;
  DREdit_UserName.SetFocus;
end;


//------------------------------------------------------------------------------
//  비밀번호에서 확인을 누른 경우
//------------------------------------------------------------------------------
procedure TForm_UserInfo.ConfirmSecretNumPage;
VAR
  i, j, iChr: Integer;
  number,character,ascii, sp_character: boolean;
  test,strlen : string;
  len : Double;
  strFullPass, strShortPass, sTime : string;
  sChr : string;
begin
   number    := false;
   character := false;
   sp_character := False;
   test      := '';
   strlen := '';
   sChr := '';
   len := 0;

   gf_ClearMessage(MessageBar);
   if Trim(DREdit_CurPswrd.Text) = '' then
   begin
      gf_ShowMessage(MessageBar, mtError, 0, '입력 항목 누락');
      DREdit_CurPswrd.SetFocus;
      Exit;
   end;
   if Trim(DREdit_NewPswrd.Text) = '' then
   begin
      gf_ShowMessage(MessageBar, mtError, 0, '입력 항목 누락');
      DREdit_NewPswrd.SetFocus;
      Exit;
   end;
   if Trim(DREdit_ConfirmPswrd.Text) = '' then
   begin
      gf_ShowMessage(MessageBar, mtError, 0, '입력 항목 누락');
      DREdit_ConfirmPswrd.SetFocus;
      Exit;
   end;

   DisableForm;
   gf_ShowMessage(MessageBar, mtInformation, 0, '처리 중입니다.');

   with ADOQuery_Main do
   begin
      // 기존비밀번호 입력 확인
      Close;
      SQL.Clear;
      SQL.Add('SELECT USER_ID, PASSWD,                                                         ');
      SQL.Add('       OPR_ID        = ISNULL((SELECT OPR_ID        FROM SUACCCON_TBL), ''''),  ');
      SQL.Add('       ACONT_YN      = ISNULL((SELECT ACONT_YN      FROM SUACCCON_TBL), ''N''), ');
      SQL.Add('       PWMINI_LENGTH = ISNULL((SELECT PWMINI_LENGTH FROM SUACCCON_TBL), ''0''), ');
      SQL.Add('       PWANMIX_YN    = ISNULL((SELECT PWANMIX_YN    FROM SUACCCON_TBL), ''N''), ');
      SQL.Add('       PWEXCEPTID_YN = ISNULL((SELECT PWEXCEPTID_YN FROM SUACCCON_TBL), ''N''), ');
      SQL.Add('       PWSPECIAL_YN  = ISNULL((SELECT PWSPECIAL_YN  FROM SUACCCON_TBL), ''N''), ');
      SQL.Add('       PWSAMENO_YN   = ISNULL((SELECT PWSAMENO_YN   FROM SUACCCON_TBL), ''N''), ');
      SQL.Add('       PWCONNO_YN    = ISNULL((SELECT PWCONNO_YN    FROM SUACCCON_TBL), ''N'')  ');
      SQL.Add('FROM SUUSER_TBL          ');
      SQL.Add('WHERE USER_ID = :pUserID ');

      Parameters.ParamByName('pUserID').Value := DREdit_UserID.Text;
      Try
         gf_ADOQueryOpen(ADOQuery_Main);
      Except on E: Exception do
         begin
            gf_ShowErrDlgMessage(Self.Tag, 0, 'ADOQuery_Main: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 0, '처리불가 - DB를 읽어오는 동안 오류가 발생하였습니다.');
            EnableForm;
            Exit;
         end
      End;

      gfEncryption(DREdit_CurPswrd.Text, gvUserEnrpYN, strShortPass);
      if Trim(FieldByName('PASSWD').asString) <> strShortPass then // 입력된 기존비밀번호 오류
      begin
         gf_ShowMessage(MessageBar, mtError, 0, '기존비밀번호를 잘못 입력하셨습니다.');
         EnableForm;
         DREdit_CurPswrd.SetFocus;
         Exit;
      end;

      gfEncryption(DREdit_NewPswrd.Text, gvUserEnrpYN, strShortPass);
      if Trim(FieldByName('PASSWD').asString) = strShortPass then // 기존번호와 새비번비교
      begin
         gf_ShowMessage(MessageBar, mtError, 0, '기존비밀번호와 신규비밀번호가 같습니다.');
         EnableForm;
         DREdit_NewPswrd.SetFocus;
         Exit;
      end;

      // 신규비밀번호와 확인비밀번호의 일치 확인
      if DREdit_NewPswrd.Text <> DREdit_ConfirmPswrd.Text then
      begin
         gf_ShowMessage(MessageBar, mtError, 0, '신규비밀번호와 확인비밀번호가 일치하지 않습니다.');
         EnableForm;
         DREdit_NewPswrd.SetFocus;
         Exit;
      end;

      IF (Trim(FieldByName('ACONT_YN').asString)='Y') and (not((Pos('data', trim(gvOprUsrNo)) > 0) and (Length(trim(gvOprUsrNo)) <= 6))) THEN // ACCESS CONTROL 사용~~~~~~~~~~~~~
      begin

//******P.H.S*******2006.06.09************************************************************************
        if not IsBigCharacter(DREdit_NewPswrd.Text) then                                // 대문자 포함여부
        begin
           gf_ShowMessage(MessageBar, mtError, 0, '신규비밀번호는 대문자가 1자이상 포함되어야 합니다.');
           EnableForm;
           DREdit_NewPswrd.SetFocus;
           Exit;
        end;

        // 비밀번호의 히스토리 일치 확인
        if not (IsValidPassWD(DREdit_UserID.Text, DREdit_NewPswrd.Text, TControl(MessageBar))) then
        begin
           //gf_ShowMessage(MessageBar, mtError, 0, '신규비밀번호는 기존에 이미 사용하셨습니다.');
           EnableForm;
           DREdit_NewPswrd.SetFocus;
           Exit;
        end;

//******P.H.S*******2006.06.09************************************************************************

        if FieldByName('PWANMIX_YN').asString = 'Y' then
        begin
          for i:=1 to Length(DREdit_NewPswrd.Text) do
          begin
           test := copy(DREdit_NewPswrd.Text, i, 1);
           if ((test >= '0') and (test <= '9')) then number := true
           else if  ((test >= 'A') and (test <= 'Z')) or ((test >= 'a') and (test <= 'z')) then character := true
           else ascii := true;
          end; //for
{
             if ((number = true) and  (character = false) and (ascii = false) ) or
                ((number = false) and  (character = true) and (ascii = false) ) or
                ((number = false) and  (character = false) and (ascii = true) ) then
             begin
}
          if ((number = true) and  (character = false)) or
             ((number = false) and  (character = true)) then
          begin
             gf_ShowMessage(MessageBar, mtError, 0, '문자와 숫자를 조합하셔야 합니다.');
             EnableForm;
             DREdit_NewPswrd.SetFocus;
             Exit;
           end;
        end; //  if FieldByName('PWANMIX_YN').asString = 'Y'

        len := FieldByName('PWMINI_LENGTH').asFloat;
        strlen := FieldByName('PWMINI_LENGTH').asString;
        if Length(DREdit_NewPswrd.Text) < len then
        begin
            gf_ShowMessage(MessageBar, mtError, 0, strlen +  '자 이상 입력해 주세요.');
            EnableForm;
            DREdit_NewPswrd.SetFocus;
            Exit;
        end; //if Length(DREdit_NewPswrd.Text) < 4

        // 1. ID포함 안되게
        if FieldByName('PWEXCEPTID_YN').asString = 'Y' then
        begin
          if Pos(UpperCase(Trim(DREdit_UserID.Text)), UpperCase(Trim(DREdit_NewPswrd.Text))) > 0 then
          begin
            gf_ShowMessage(MessageBar, mtError, 0, '비밀번호에는 ID가 포함되지 않아야 합니다.');
              EnableForm;
              DREdit_NewPswrd.SetFocus;
              Exit;
          end;
        end;

        // 2. 특수문자
        if FieldByName('PWSPECIAL_YN').asString = 'Y' then
        begin
          for i:=1 to Length(DREdit_NewPswrd.Text) do
          begin
           test := copy(DREdit_NewPswrd.Text, i, 1);

           if not (((test >= '0') and (test <= '9')) or
                  (((test >= 'A') and (test <= 'Z')) or ((test >= 'a') and (test <= 'z'))) or
                  ((test = '#9') or (test = '#10') or (test = '#11') or (test = '#12') or
                  (test = '#13') or (test = '#32'))) then sp_character := true

          end; //for
          
          if (sp_character <> true) then
          begin
            gf_ShowMessage(MessageBar, mtError, 0, '특수문자를 조합하셔야 합니다.');
            EnableForm;
            DREdit_NewPswrd.SetFocus;
            Exit;
          end;

        end; //  FieldByName('PWSPECIAL_YN').asString = 'Y' then

        // 3.동일숫자 연속3번제한
        if FieldByName('PWSAMENO_YN').asString = 'Y' then
        begin
          for i:= 0 to Length(trim(DREdit_NewPswrd.Text)) -3 do
          begin
            sChr := copy(DREdit_NewPswrd.Text, i+1 ,1);
            if Pos(sChr + sChr + sChr, DREdit_NewPswrd.Text) > 0 then
            begin
              gf_ShowMessage(MessageBar, mtError, 0, '동일숫자 연속3번 사용 불가합니다.');
              EnableForm;
              DREdit_NewPswrd.SetFocus;
              Exit;
            end;
          end;
        end; // 3.동일숫자 연속3번제한

        // 4.연속 문자, 숫자 3번 제한
        if FieldByName('PWCONNO_YN').asString = 'Y' then
        begin
          sChr := DREdit_NewPswrd.Text;

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
              EnableForm;
              DREdit_NewPswrd.SetFocus;
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
              EnableForm;
              DREdit_NewPswrd.SetFocus;
              Exit;
            end;
          end;
        end; // 4.연속 문자, 숫자 3번 제한
      end; //IF Trim(FieldByName('ACONT_YN').asString)='Y'

      //------------------
      gf_BeginTransaction;
      //------------------

      strFullPass := gfEncryption(DREdit_NewPswrd.Text, gvUserEnrpYN, strShortPass);

      // 비밀번호 수정
      Close;
      SQL.Clear;
      SQL.Add(' UPDATE SUUSER_TBL                                                 '
            + ' SET                                                               '
            + '        PASSWD = :pPasswd,                                         '
            + '        NEW_PASSWD = :pNewPasswd,                                  '
            + '        FIRST_FLAG = :pFirst_Flag,                                 '
            + '        PWCHGE_DATE = :pPWChge_Date,                               '
            + '        PWCHGE_TIME = :pPWChge_Time,                               '
            + '        OPR_ID = :pOprID, OPR_DATE = :pOprDate, OPR_TIME = :pOprTime '
            + ' WHERE USER_ID = :pUserID                                          ');

      Parameters.ParamByName('pUserID').Value := DREdit_UserID.Text;
      Parameters.ParamByName('pPasswd').Value := strShortPass;
      Parameters.ParamByName('pNewPasswd').Value := strFullPass;
      //수정날짜
      Parameters.ParamByName('pPWChge_Date').Value   := gvCurDate;
      sTime := gf_GetCurTime;
      Parameters.ParamByName('pPWChge_Time').Value  := sTime;
      Parameters.ParamByName('pFirst_Flag').Value   := 'N';

      Parameters.ParamByName('pOprID').Value   := gvOprUsrNo;
      Parameters.ParamByName('pOprDate').Value := gvCurDate;
      Parameters.ParamByName('pOprTime').Value := sTime;


      Try
         gf_ADOExecSQL(ADOQuery_Main);
      Except on E: Exception do
         begin
            gf_ShowErrDlgMessage(Self.Tag, 0, 'ADOQuery_Main: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 0, '처리불가 - 수정중 오류가 발생하였습니다.');
            gf_RollbackTransaction;
            EnableForm;
            Exit;
         end
      End;
//******P.H.S*******2006.06.12************************************************************************

      if not InsertHistoryPWD(DREdit_UserID.Text, gfEncryption(DREdit_NewPswrd.Text, gvUserEnrpYN, strShortPass)) then
      begin
         gf_ShowMessage(MessageBar, mtError, 0, '처리불가 - 수정중 오류가 발생하였습니다.');
         gf_RollbackTransaction;
         EnableForm;
         Exit;
      end;

      //------------------
      gf_CommitTransaction;
      //------------------
//******P.H.S*******2006.06.12************************************************************************

      EnableForm;
      DREdit_CurPswrd.SetFocus;
      gf_ShowMessage(MessageBar, mtInformation, 0, '처리 완료');
   end; // end of with
end;


//------------------------------------------------------------------------------
//  메일에서 확인을 누른 경우
//------------------------------------------------------------------------------
procedure TForm_UserInfo.ConfirmMailPage;
begin
  if not EditDataCheck then
  begin
    Exit;
  end;

  if not DataExistCheck then
  begin
    InsertData;
  end

  else
  begin
    UpDateData;
  end;
  gf_RefreshGlobalVar(gcGLOB_GMAIL_INFO);
end;


//------------------------------------------------------------------------------
//  기존비밀번호 입력 후 엔터를 누른 경우
//------------------------------------------------------------------------------
procedure TForm_UserInfo.DREdit_CurPswrdKeyPress(Sender: TObject;
  var Key: Char);
var i : integer;
begin
  inherited;
  If Key = #13 Then
    DREdit_NewPswrd.SetFocus
  else
  begin
     i := integer(Key);

     if  (i < 33) or (i > 126) then
     begin
       if i <> 8 then Key := #0; //backspace oK
     end;

    { if  (i < 48) //숫자, 영문만 받음.
     or ((i > 57) and (i <65))
     or ((i > 90) and (i <97))
     or  (i > 122) then
     begin
       if i <> 8 then Key := #0; //backspace oK
     end; }
  end;
end;


//------------------------------------------------------------------------------
//  신규비밀번호 입력후 엔터를 누른 경우
//------------------------------------------------------------------------------
procedure TForm_UserInfo.DREdit_NewPswrdKeyPress(Sender: TObject;  var Key: Char);
var
  i: Integer;
  number,character,ascii: boolean;
  test : string;
begin
  inherited;

  if Key = #13 Then
  begin
     DREdit_ConfirmPswrd.SetFocus;
  end
  else
  begin
     i := integer(Key);

     if  (i < 33) or (i > 126) then
     begin
       if i <> 8 then Key := #0; //backspace oK
     end;

    { if  (i < 48) //숫자, 영문만 받음.
     or ((i > 57) and (i <65))
     or ((i > 90) and (i <97))
     or  (i > 122) then
     begin
       if i <> 8 then Key := #0; //backspace oK
     end; }
  end;
end;


//------------------------------------------------------------------------------
//  비밀번호확인 입력후 엔터를 누른 경우
//------------------------------------------------------------------------------
procedure TForm_UserInfo.DREdit_ConfirmPswrdKeyPress(Sender: TObject;
  var Key: Char);
var i : integer;
begin
  inherited;
  If Key = #13 Then
    DRBitBtn3.SetFocus
  else
  begin
     i := integer(Key);

     if  (i < 33) or (i > 126) then
     begin
       if i <> 8 then Key := #0; //backspace oK
     end;
          
    { if  (i < 48) //숫자, 영문만 받음.
     or ((i > 57) and (i <65))
     or ((i > 90) and (i <97))
     or  (i > 122) then
     begin
       if i <> 8 then Key := #0; //backspace oK
     end; }
  end;

end;

//------------------------------------------------------------------------------
//  탭을 바꾼 경우 초기화
//------------------------------------------------------------------------------
procedure TForm_UserInfo.DRPageControl_UserInfoChange(Sender: TObject);
begin
  inherited;
  DRBitBtn2Click(Self);
end;

procedure TForm_UserInfo.DRMemo_SignChange(Sender: TObject);
var
   sbody : string;
   i : Integer;
begin
  inherited;
   sbody := DRMemo_Sign.Text;

   for i:=1 to Length(sbody) do
   begin
      if (sbody[i] = #39) or (sbody[i] = #58) then  // 특수문자 (' :) 두가지를 스페이스처리
      begin
         sbody[i] := #32;                           // 쿼리문에서 에러발생하기때문에 처리해줌.
         gf_ShowMessage(MessageBar, mtError, 0, '허용되지않는 특수문자를 입력하셨습니다. 자동으로 Space처리됩니다. [:, '']'); // Database 오류
      end;
   end;
   DRMemo_Sign.Text := sbody;
   DRMemo_Sign.SelStart := Length(DRMemo_Sign.Text);
end;

procedure TForm_UserInfo.FormShow(Sender: TObject);
begin
  inherited;
  DRPageControl_UserInfo.ActivePage :=  DRTabSheet_SecretNum;
end;

end.


