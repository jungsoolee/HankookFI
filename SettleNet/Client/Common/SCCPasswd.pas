unit SCCPasswd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DRStandard, Db, ADODB, ExtCtrls, DRCodeControl;

type
  TForm_Passwd = class(TForm)
    DRLabel1: TDRLabel;
    DRButton1: TDRButton;
    DRButton2: TDRButton;
    ADOQuery_Temp: TADOQuery;
    ADOQuery1: TADOQuery;
    ADOQuery2: TADOQuery;
    DREdit1: TDREdit;
    DRLabel2: TDRLabel;
    DRUserDblCodeCombo_Admin: TDRUserDblCodeCombo;
    drpnl_msg: TDRPanel;
    procedure DRButton1Click(Sender: TObject);
    function UserTrCheck(var GrpName : string): boolean;
    procedure DRButton2Click(Sender: TObject);
    procedure DREdit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DRUserDblCodeCombo_AdminEditKeyPress(Sender: TObject;
      var Key: Char);
    procedure DRUserDblCodeCombo_AdminCodeChange(Sender: TObject);
  private
    { Private declarations }
    function InitializeComboBox : Boolean;
  public
    { Public declarations }
  end;

var
  Form_Passwd: TForm_Passwd;
  GrpList : TStringList;

implementation

{$R *.DFM}
uses
  SCCLib, SCCGlobalType, SCCCmuGlobal, SCCCmuLib, SCCTcpIp;

const
  MsgColor = $00E1FFFF;

//------------------------------------------------------------------------------
// 입력버튼
//------------------------------------------------------------------------------
procedure TForm_Passwd.DRButton1Click(Sender: TObject);
var
 GrpName : String;
 strShortPass : string;
  i : Integer;
  EqlPassWd : Boolean;
  sAdminID, sAdminPW : String;
begin
  EqlPassWd := False;

  // 관리자 입력 체크
  if Trim(DRUserDblCodeCombo_Admin.Code) = '' then
  begin
    drpnl_msg.Color   := MsgColor;
    drpnl_msg.Caption := '관리자를 선택하여 주십시오.';
    DRUserDblCodeCombo_Admin.SetFocus;
    Exit;
  end;
  sAdminID := Trim(DRUserDblCodeCombo_Admin.Code);

  // 관리자 암호 입력 체크
  if Trim(DREdit1.text) = '' then
  begin
    drpnl_msg.Color   := MsgColor;
    drpnl_msg.Caption := '암호를 입력하여 주십시오.';
    DREdit1.SetFocus;
    Exit;
  end;
  sAdminPW := Trim(DREdit1.text);

  //if not UserTrCheck(GrpName) then    // [9104]이 포함된 그룹이 존재안하면..
  //  Exit;

  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT PASSWD, NEW_PASSWD ');
    SQL.Add('FROM SUUSER_TBL ');
    SQL.Add('WHERE USER_ID = '''+ sAdminID +''' ');
//SQL.SaveToFile('c:\SCCPasswd.sql');

    Try
      gf_ADOQueryOpen(ADOQuery_Temp);
    Except  // DataBase 오류입니다.
      On E: Exception do
      begin
        Exit;
      end;
    End;

    if (RecordCount > 0) then
    begin
      // MD5
      if (Length(Trim(FieldByName('PASSWD').asString)) < 64) and
         (gvUserEnrpYN = 'Y') then
      begin
        if (Trim(FieldByName('NEW_PASSWD').asString) =
              gfEncryption(DREdit1.Text, 'O', strShortPass))
        then
          EqlPassWd := True;
      end else
      // 일반, SHA256
      begin
        if (Trim(FieldByName('PASSWD').asString) =
              gfEncryption(DREdit1.Text, gvUserEnrpYN, strShortPass))
        then
          EqlPassWd := True;
      end;

    end;

    if EqlPassWd then
    begin
      ModalResult := idOK;
    end else
    begin
      drpnl_msg.Color   := MsgColor;
      drpnl_msg.Caption := '비밀번호 불일치.';
      DREdit1.SetFocus;
      Exit;
    end;
  end; // with ADOQuery_Temp do
end;

//------------------------------------------------------------------------------
// Tr[9104]가 있는 그룹이름 찾기
//------------------------------------------------------------------------------
function TForm_Passwd.UserTrCheck(var GrpName : string): boolean;
begin
   Result := false;
      with ADOQuery_Temp do
      begin
         Close;
         SQL.Clear;
         SQL.Add( ' SELECT USER_GRP_CODE FROM SUUGPTR_TBL       '
//                + ' WHERE  DEPT_CODE =  ''' + gvDeptCode + '''  '
                + '   WHERE   TR_CODE = ''9104''                  ');
        Try
           gf_ADOQueryOpen(ADOQuery_Temp);
        Except  // DataBase 오류입니다.
           On E: Exception do
           begin
              Exit;
           end;
        End;

        if RecordCount > 0 then
        begin
          while not Eof do begin
            GrpList.Add(Trim(FieldByName('USER_GRP_CODE').asString));

            Next;
          end;
          Result := True;
        end; // while not Eof do
{
//        while not Eof do
        if RecordCount > 0 then
        begin
//          If Trim(FieldByName('TR_CODE').asString) = '9104' then
//          begin
           GrpName :=  Trim(FieldByName('USER_GRP_CODE').asString);
           Result := True;
           Exit;
//          end;
//          Next;
        end; // while not Eof do
}

      end; // with ADOQuery_Main do
end;

//------------------------------------------------------------------------------
// 취소버튼
//------------------------------------------------------------------------------
procedure TForm_Passwd.DRButton2Click(Sender: TObject);
begin
   ModalResult := idAbort;
//   Close;
end;

procedure TForm_Passwd.DREdit1KeyPress(Sender: TObject; var Key: Char);
var i : integer;
begin
   if Key = #13 then
     DRButton1Click(Sender)
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

procedure TForm_Passwd.FormShow(Sender: TObject);
begin
  DRUserDblCodeCombo_Admin.SetFocus;
end;

procedure TForm_Passwd.FormCreate(Sender: TObject);
begin
  GrpList := TStringList.Create;
  InitializeComboBox;
end;

procedure TForm_Passwd.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  GrpList.Free;
end;

// 콤보박스 초기화
function TForm_Passwd.InitializeComboBox: Boolean;
var
  GrpName : String;
  i : Integer;
begin
  Result := False;

  if not UserTrCheck(GrpName) then    // [9104]이 포함된 그룹이 존재안하면..
    Exit;

  with ADOQuery_Temp do
  begin
    //--- FaxTlx 수신처
    Close;
    SQL.Clear;
    SQL.Add(' SELECT USER_ID, USER_NAME FROM SUUSER_TBL ');
    SQL.Add(' WHERE USER_GRP_CODE IN ( ');
    for i:=0 to GrpList.Count-1 do begin
       if (i <> 0) then SQL.Add(', ');
         SQL.Add(' '''+ GrpList.Strings[i] +''' ');
    end;
    SQL.Add(' ) ');
    Try
      gf_ADOQueryOpen(ADOQuery_Temp);
    Except
      on E : Exception do
      begin  // DataBase 오류
        drpnl_msg.Color   := MsgColor;
        drpnl_msg.Caption := 'ADOQuery_Temp[SUUSER_TBL]: ' + E.Message;
        //gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SUUSER_TBL]: ' + E.Message, 0);
      end;
    End;

    DRUserDblCodeCombo_Admin.ClearItems;
    if RecordCount > 0 then begin
       while not Eof do
       begin
         DRUserDblCodeCombo_Admin.AddItem(Trim(FieldByName('USER_ID').AsString)
                                             ,Trim(FieldByName('USER_NAME').AsString));
         Next;
       end;  // end of while
    end else begin
      Exit;
    end;
    Close;  // Query Close
  end;  // end of with

  Result := True;
end;


procedure TForm_Passwd.DRUserDblCodeCombo_AdminEditKeyPress(
  Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    DREdit1.SetFocus;
  end;
end;


procedure TForm_Passwd.DRUserDblCodeCombo_AdminCodeChange(Sender: TObject);
begin
  DREdit1.SetFocus;
end;

end.
