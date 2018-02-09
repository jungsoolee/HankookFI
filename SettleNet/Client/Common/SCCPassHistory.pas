unit SCCPassHistory;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, ADODB, Grids, DRStringgrid, StdCtrls, Buttons, DRAdditional, DRSpecial;
  
type
  TfrmPWHistory = class(TForm)
    ADOQuery_History: TADOQuery;
    DRStringGrid1: TDRStringGrid;
    DRBtnOK: TDRBitBtn;
    procedure DRBtnOKClick(Sender: TObject);
    procedure DRStringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPWHistory: TfrmPWHistory;

  function IsBigCharacter(OprPassWD:String) : Boolean;
  function InsertHistoryPWD(OprUsrID, OprPassWD : String) : Boolean;
  function IsValidPassWD(OprUsrID, OprPassWD:String; var MsgBar : TControl) : Boolean;

implementation

{$R *.DFM}

uses
  SCCLib, SCCDataModule, SCCGlobalType;

{ TForm1 }

// 대문자 1자이상 포함여부 확인
function IsBigCharacter(OprPassWD : String) : Boolean;
var
   Chr : Char;
   i : Integer;
   BigChrYN : String;
   ADOQuery_Temp : TADOQuery;
begin
   try
      try
         result := False;

         BigChrYN := '';
         ADOQuery_Temp := TADOQuery.Create(nil);

         with ADOQuery_Temp do begin
            Connection := DataModule_SettleNet.ADOConnection_Main;
            Close;
            SQL.Clear;
            SQL.Add('SELECT ISNULL(BIGCHR_YN, ''N'') AS BIGCHR_YN '
                   +'  FROM SUACCCON_TBL                          ');

            gf_ADOQueryOpen(ADOQuery_Temp);

            if RecordCount <> 0 then
               BigChrYN := Trim(FieldByName('BIGCHR_YN').AsString);
         end;

         finally
            if Assigned(ADOQuery_Temp) then
            begin
               ADOQuery_Temp.Close;
               ADOQuery_Temp.Free;
            end;
         end;
   except
      on E : Exception do
      begin
         gf_ShowErrDlgMessage(0, 0, 'SUACCCON_TBL: ' + E.Message,0);
         result := False;
         Exit;
      end;
   end;

   if BigChrYN = 'N' then begin
      result := True;
      Exit;
   end;

   for i:= 1 to Length(OprPassWD) do begin
      Chr := OprPassWD[i];
      if (Chr >= #65) and (Chr <= #90) then result := True;
   end;

end;
// 바뀐 패스워드 저장
function InsertHistoryPWD(OprUsrID, OprPassWD : String) : Boolean;
var
   ADOQuery_Temp : TADOQuery;
begin
   try
      try
         result := True;

         ADOQuery_Temp := TADOQuery.Create(nil);

         with ADOQuery_Temp do begin
            Connection :=  DataModule_SettleNet.ADOConnection_Main;
            Close;
            SQL.Clear;
            SQL.Add('INSERT INTO SUPWHIS_TBL (USER_ID,PASSWD,DEPT_CODE,PWCHGE_DATE)'
                   +'       VALUES (:USER_ID, :PASSWD, :DEPT_CODE, :PWCHGE_DATE)       ');
            Parameters.ParamByName('USER_ID').Value     := OprUsrID;
            Parameters.ParamByName('PASSWD').Value      := OprPassWD;
            Parameters.ParamByName('DEPT_CODE').Value   := gvDeptCode;
            Parameters.ParamByName('PWCHGE_DATE').Value := gvCurDate;

            gf_ADOExecSQL(ADOQuery_Temp);
         end;
      finally
         if Assigned(ADOQuery_Temp) then
         begin
            ADOQuery_Temp.Close;
            ADOQuery_Temp.Free;
         end;
      end;
   except
      on E : Exception do
      begin
         gf_ShowErrDlgMessage(0, 0, 'ADOQuery_Temp: ' + E.Message,0);
         result := False;
         Exit;
      end;
   end;

end;

// 히스토리 패스워드 비교
function IsValidPassWD(OprUsrID, OprPassWD:String; var MsgBar : TControl): Boolean;
var
   strPssWd, strFullPassWd : String;
   iRow, cnt : Integer;
begin
   result := True;

   frmPWHistory := TfrmPWHistory.Create(nil);

   cnt := 0;

   with frmPWHistory.ADOQuery_History, frmPWHistory.DRStringGrid1 do begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT ISNULL(HISTORY_RCNT,0) AS HISTORY_RCNT FROM SUACCCON_TBL');

      Try
         gf_ADOQueryOpen(frmPWHistory.ADOQuery_History);
      Except on E: Exception do
         begin
            gf_ShowErrDlgMessage(0, 0, 'ADOQuery_History: ' + E.Message, 0);
            result := False;
            Exit;
         end
      End;

      if RecordCount >= 1 then cnt := FieldByName('HISTORY_RCNT').AsInteger;

      Close;
      SQL.Clear;
      SQL.Add('if not exists(SELECT 1 FROM SUPWHIS_TBL WHERE USER_ID = ''' + OprUsrID + ''')'
            +' begin                                              '
            +'		 SELECT PWCHGE_DATE, PASSWD FROM SUUSER_TBL U   '
            +' 	 WHERE  U.USER_ID = ''' + OprUsrID + '''        '
            +'		 ORDER BY PWCHGE_DATE DESC                      '
            +' end                                                '
            +' else begin                                         '
            +'	    SELECT TOP '+InttoStr(cnt)+ ' PWCHGE_DATE, PASSWD FROM SUPWHIS_TBL P '
            +'     WHERE P.USER_ID = ''' + OprUsrID + '''         '
            +'		 ORDER BY PWCHGE_DATE DESC                      '
            +' end                                                ');

      Try
         gf_ADOQueryOpen(frmPWHistory.ADOQuery_History);
      Except on E: Exception do
         begin
            gf_ShowErrDlgMessage(0, 0, 'ADOQuery_History: ' + E.Message, 0);
            result := False;
            Exit;
         end
      End;

      gfEncryption(OprPassWD, gvUserEnrpYN, strFullPassWd);

      Filtered := False;
      Filter   := '  PASSWD = ''' + strFullPassWd + '''';
      Filtered := True;

      if RecordCount >= 1 then // 입력된 기존비밀번호 오류
      begin
         Filtered := False;
         Filter   := '';
         Filtered := True;

         First;
         iRow := 1;

         RowCount := RowCount + RecordCount-1;

         try
            while not EOF do begin
               Cells[0, iRow] := Trim(FieldByName('PWCHGE_DATE').AsString);
               Cells[1, iRow] := gfDecryption(Trim(FieldByName('PASSWD').AsString), gvUserEnrpYN);

               Inc(iRow);
               Next;
            end;

            except
            on E : Exception do begin
               gf_ShowErrDlgMessage(0, 0, 'ADOQuery_History: ' + E.Message, 0);
               result := False;
               Exit;
            end;
         end;

         result := False;

         gf_ShowMessage(TDRMessageBar(MsgBar), mtError, 0, '신규비밀번호는 기존에 이미 사용하셨습니다.');

         if frmPWHistory.ShowModal = mrOK then frmPWHistory.Free;

      end;

   end;
end;

procedure TfrmPWHistory.DRBtnOKClick(Sender: TObject);
begin
   ModalResult := mrOK;
end;

procedure TfrmPWHistory.DRStringGrid1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if (Key = vk_Return) then DRBtnOK.SetFocus;
end;

end.
