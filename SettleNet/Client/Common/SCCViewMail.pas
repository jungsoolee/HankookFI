//==============================================================================
//   [LHA] 2001/10/22
//==============================================================================
unit SCCViewMail;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCCDlgForm, Db, ADODB, ImgList, DRWin32, ComCtrls, StdCtrls, DRStandard,
  ExtCtrls, DRAdditional, Buttons, DRSpecial, SCCGlobalType, ShellAPI, FileCtrl,
  DRDialogs;

type
  TDlgForm_ViewMail = class(TForm_Dlg)
    DRPanel1: TDRPanel;
    DRLabel1: TDRLabel;
    DRLabel2: TDRLabel;
    DRLabel3: TDRLabel;
    DRLabel4: TDRLabel;
    DRLabel_Sender: TDRLabel;
    DRLabel_Receiver: TDRLabel;
    DRLabel_CCList: TDRLabel;
    DRLabel_BlindCCList: TDRLabel;
    DRLabel7: TDRLabel;
    DRLabel_SendDate: TDRLabel;
    DRLabel9: TDRLabel;
    DRLabel_Status: TDRLabel;
    DRLabel5: TDRLabel;
    DRPanel2: TDRPanel;
    DRSplitter1: TDRSplitter;
    DRMemo_MailBody: TDRMemo;
    DRListView_SndAttFile: TDRListView;
    DRImageList_File: TDRImageList;
    ADOQuery_SCMELSND: TADOQuery;
    DREdit_SubjectData: TDREdit;
    ADOQuery_Temp: TADOQuery;
    DRListView_SntAttFile: TDRListView;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DRListView_SndAttFileDblClick(Sender: TObject);
    function  BuildMailStrList(pSndItem: TStringList):string;
    procedure DRBitBtn2Click(Sender: TObject);
    procedure DREdit_SubjectDataKeyPress(Sender: TObject; var Key: Char);
    procedure DRListView_SntAttFileDblClick(Sender: TObject);
    procedure DRMemo_MailBodyChange(Sender: TObject);
    procedure DREdit_SubjectDataChange(Sender: TObject);
  private
    { Private declarations }
  public
    function ShowMailSnd(pJobDate : string; SndMailData : pTFSndMail): boolean;
    function ShowMailSnt(pSndDate: string; FreqItem: pTFreqMail): boolean;
  end;

var
  DlgForm_ViewMail: TDlgForm_ViewMail;

implementation

{$R *.DFM}

uses
   SCCLib, SCCCmuLib;

var
  AttSeqNoList : TStringList;
  gSndDate     : string;
  gJobDate     : string;
  SndItem      : pTFSndMail;
  gFreqItem    : pTFreqMail;
  sDirectory   : string;

//------------------------------------------------------------------------------
// 전송전  Mail 내용보기
//------------------------------------------------------------------------------
function TDlgForm_ViewMail.ShowMailSnd(pJobDate : string; SndMailData: pTFSndMail): boolean;
var
   ListItem : TListItem;
   AttItem  : pTAttFile;
   iRspFlag, I : Integer;
begin
   Result := False;
   Screen.Cursor := crHourGlass;
   gJobDate     := pJobDate;
   DRListView_SntAttFile.Visible := False;
   SndItem := SndMailData;
   // 파일저장 디렉토리
   If SndItem.AccGrpType = gcRGroup_Grp then
      sDirectory := SndItem.AccGrpName  + '\'
   else
      sDirectory := SndItem.AccList.Strings[0] + '\';

   // Screen Clear
   Caption := '';
   DRLabel_Sender.Caption      := '';
   DRLabel_SendDate.Caption    := '';
   DRLabel_Receiver.Caption    := '';
   DRLabel_CCList.Caption      := '';
   DRLabel_BlindCCList.Caption := '';
   DRLabel_Status.Caption      := '';
   DREdit_SubjectData.Text     := '';
   DRMemo_MailBody.Clear;

   DRLabel7.Caption            := '매매일자';
   DRListView_SndAttFile.Items.Clear;


   // Title
   Caption := 'To. ' + SndItem.AccGrpName ;

   // 보낸사람
   DRLabel_Sender.Caption := gvMailOprName;

   DRLabel_Sender.Caption := DRLabel_Sender.Caption + ' [' + gvRtnMailAddr + ']';

   // 보낸일자
   DRLabel_SendDate.Caption := gf_FormatDate(gJobDate);

   // 받는사람
   DRLabel_Receiver.Caption := BuildMailStrList(SndItem.MailRcv);
   DRLabel_Receiver.Hint    := BuildMailStrList(SndItem.MailAddr);

   // 참조
   DRLabel_CCList.Caption   := BuildMailStrList(SndItem.CCMailRcv);
   DRLabel_CCList.Hint      := BuildMailStrList(SndItem.CCMailAddr);

   // 숨은참조
   DRLabel_BlindCCList.Caption := BuildMailStrList(SndItem.CCBlindRcv);
   DRLabel_BlindCCList.Hint    := BuildMailStrList(SndItem.CCBlindAddr);

   //제목
   DREdit_SubjectData.Text := SndItem.SubjectData;

   // 전송상태
   if (SndItem.SendFlag) and (Trim(SndItem.ErrMsg) = '') then
      DRLabel_Status.Caption := '전송' + gwRSPOK;  // 전송

   DRMemo_MailBody.Text := SndItem.MailBodyData;

   if not Assigned(SndItem.AttFileList) then Exit;
   for I:= 0 to SndItem.AttFileList.Count -1 do
   begin
      AttItem := SndItem.AttFileList.Items[I];
      ListItem := DRListView_SndAttFile.Items.Add;
      ListItem.Caption := ExtractFileName(AttItem.FileName);
      ListItem.ImageIndex := 0;
      ListItem.StateIndex := 3;
   end;

   Screen.Cursor := crDefault;

   Result := True;

end;
//------------------------------------------------------------------------------
//  전송후 Mail 내용보기
//------------------------------------------------------------------------------
function TDlgForm_ViewMail.ShowMailSnt(pSndDate: string;
                                              FreqItem: pTFreqMail): boolean;
var
   iRspFlag , I: Integer;
   sStatus  : string;
   ListItem : TListItem;
   AttItem  : pTAttFile;
begin
   Result := False;
   Screen.Cursor := crHourGlass;
   gSndDate     := pSndDate;
   gFreqItem  := FreqItem;

   // Screen Clear
   Caption := '';
   DRLabel_Sender.Caption      := '';
   DRLabel_SendDate.Caption    := '';
   DRLabel_Receiver.Caption    := '';
   DRLabel_CCList.Caption      := '';
   DRLabel_BlindCCList.Caption := '';
   DRLabel_Status.Caption      := '';
   DREdit_SubjectData.Text     := '';
   DRMemo_MailBody.Clear;
   DREdit_SubjectData.ReadOnly  := True;
   DRMemo_MailBody.ReadOnly     := True;
   DRBitBtn2.Visible           := False;
   DRListView_SndAttFile.Visible := False;

   DRLabel7.Caption            := '전송일자';
   DRListView_SntAttFile.Items.Clear;
   AttSeqNoList.Clear;

   // Title
   Caption := 'To. ' + FreqItem.AccGrpName ;

   // 보낸사람
   DRLabel_Sender.Caption := gvMailOprName;

   DRLabel_Sender.Caption := DRLabel_Sender.Caption + ' [' + gvRtnMailAddr + ']';

   // 보낸일자
   DRLabel_SendDate.Caption := gf_FormatDate(gSndDate);

   // 받는사람
   DRLabel_Receiver.Caption := FreqItem.RcvMailName;
   DRLabel_Receiver.Hint    := FreqItem.RcvMailAddr;

   // 참조
   DRLabel_CCList.Caption   := FreqItem.CCMailName;
   DRLabel_CCList.Hint      := FreqItem.CCMailAddr;

   // 숨은참조
   DRLabel_BlindCCList.Caption := FreqItem.CCBlindName;
   DRLabel_BlindCCList.Hint    := FreqItem.CCBlindAddr;

   //제목
   DREdit_SubjectData.Text := FreqItem.SubjectData;

      // 전송상태
   iRspFlag := FreqItem.RSPFlag;
   case iRspFlag of
      gcEMAIL_RSPF_WAIT : sStatus := '전송 대기 중...';
      gcEMAIL_RSPF_SEND : sStatus := '전송 중...';
      gcEMAIL_RSPF_CANC : sStatus := '전송 취소!';
      gcEMAIL_RSPF_FIN  :
      begin
         sStatus := '전송 완료!';
         if FreqItem.ErrCode <> '' then  // Error 발생
            sStatus := '전송 중 오류 발생 - ';// +  gf_ReturnMsg(SntItem.ErrCode) + '(' + SntItem.ExtMsg + ')' );
      end;
   end; // end of case
   DRLabel_Status.Caption := sStatus;
   DRMemo_MailBody.Text := FreqItem.MailBodyData;
   if not Assigned(FreqItem.AttFileList) then Exit;
   for I:= 0 to FreqItem.AttFileList.Count -1 do
   begin
      AttItem := FreqItem.AttFileList.Items[I];
      ListItem := DRListView_SntAttFile.Items.Add;
      ListItem.Caption := ExtractFileName(AttItem.FileName);
      ListItem.ImageIndex := 0;
      ListItem.StateIndex := 3;
      AttSeqNoList.Add(AttItem.FileName);
   end;

   Screen.Cursor := crDefault;
   Result := True;

end;


procedure TDlgForm_ViewMail.FormCreate(Sender: TObject);
begin
  inherited;
   AttSeqNoList := TStringList.Create;
end;

procedure TDlgForm_ViewMail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
   if Assigned(AttSeqNoList) then AttSeqNoList.Free;
   Action := caFree;
end;

//------------------------------------------------------------------------------
//  전송전 파일 열기
//------------------------------------------------------------------------------
procedure TDlgForm_ViewMail.DRListView_SndAttFileDblClick(Sender: TObject);
var
   ListItem : TListItem;
   AttItem  : pTAttfile;
   iSelIdx, iAttSeqNo, I : Integer;
   sFileName, sFilePath, sDirName : string;

begin
   ListItem := DRListView_SndAttFile.Selected;
   if not Assigned(ListItem)  then Exit;   // 선택 파일 없음
   iSelIdx  := ListItem.Index;

//   if not Assigned(SndItem.AttFileList) then Exit;

//   AttItem := SndItem.AttFileList.Items[iSelIdx];
//   sFileName := ExtractFileName(AttItem.FileName);

   sDirName := gvDirUserData + sDirectory;
   if not DirectoryExists(sDirName) then
       if not CreateDir(sDirName) then Exit;

   Screen.Cursor := crHourGlass;
   sFilePath := gf_ViewMailFile(SndItem, gJobDate);
   if sFilePath = '' then
   begin
      SndItem.ErrMsg := gf_ReturnMsg(gvErrorNo) + ' (' + gvExtMsg + ')';
      gf_ShowMessage(MessageBar, mtError, 9006, '');   // 파일 생성 오류
   end else
   begin
//      sFileName := sDirName + ListItem.Caption;
      sFileName := fnGetTokenStr(sFilePath, gcSPLIT_MAILADDR, iSelIdx+1);

      if ShellExecute(Handle, 'open', Pchar(sFileName), nil, nil, SW_SHOW) = SE_ERR_NOASSOC then
        WinExec(PChar('rundll32.exe shell32.dll, OpenAs_RunDLL ' +  sFileName), SW_SHOW);

      // 파일이 열렸으므로 편집여부 True
      SndItem.EditFlag := True;
      ListItem.Caption := '';
      for I := 0 to SndItem.AttFileList.Count - 1  do
      begin
        AttItem := SndItem.AttFileList.Items[I];
        AttItem.FileName := fnGetTokenStr(sFilePath, gcSPLIT_MAILADDR, I+1);
        ListItem.Caption := ExtractFileName(AttITem.FileName);
      end;
   end; // end of else
   Screen.Cursor := crDefault;
end;

//------------------------------------------------------------------------------
//  전송후 파일 열기
//------------------------------------------------------------------------------
procedure TDlgForm_ViewMail.DRListView_SntAttFileDblClick(Sender: TObject);
var
   ListItem : TListItem;
   AttItem  : pTAttfile;
   iSelIdx, iAttSeqNo : Integer;
   sAttFileName : string;
begin
   ListItem := DRListView_SntAttFile.Selected;
   if not Assigned(ListItem)  then Exit;   // 선택 파일 없음

   iSelIdx  := ListItem.Index;
   sAttFileName := ListItem.Caption;
   if (iSelIdx < 0) or (iSelIdx > AttSeqNoList.Count -1 ) then
   begin
      gf_ShowErrDlgMessage(0, 1145, 'List Index Out of Bound', 0);
      Exit;
   end;
   {//AH
   iAttSeqNo := StrToIntDef(AttSeqNoList.Strings[iSelIdx], -1);
   if iAttSeqNo < 0 then
   begin
      gf_ShowErrDlgMessage(0, 1145, '', 0);
      Exit;
   end;
   }
   gf_ShowAttDlg(gSndDate, gFreqItem, iSelIdx);
end;


//------------------------------------------------------------------------------
// 메일주소 생성
//------------------------------------------------------------------------------
function TDlgForm_ViewMail.BuildMailStrList(pSndItem: TStringList): string;
var
  I : integer;
  sTmpStr : string;
begin
  sTmpSTr := '';
  if not Assigned(pSndItem) then Exit;
  for I := 0 to pSndItem.Count -1 do
  begin
    sTmpStr  := sTmpStr  + pSndItem.Strings[I] + gcSPLIT_MAILADDR;
  end; // end of for
  Result := sTmpStr;
end;

procedure TDlgForm_ViewMail.DRBitBtn2Click(Sender: TObject);
// Query : Select
function ExcuteSqlSelect(sQuery : string) : boolean;
begin
  Result := False;
  with ADOQuery_Temp do
  begin
     Close;
     SQL.Clear;
     SQL.Add(sQuery);
     Try
           gf_ADOQueryOpen(ADOQuery_Temp)
     Except
        on E : Exception do
        begin    // Database 오류
           Screen.Cursor := crDefault;
           gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SCMELSND[SUDGPML_TBL]: ' + E.Message, 0);
           gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Snd[SUDGPML_TBL]'); //Database 오류
           Exit;
        end;
     End;
        if RecordCount < 1 then
           Result := True;   // True : Insert False : Upate
  end; // end of with
end;
// SQL 실행 : Insert or Update
procedure ExcuteSqlChange(sQuery : string);
begin
  with ADOQuery_Temp do
  begin
     Close;
     SQL.Clear;
     SQL.Add(sQuery);

     // 특수문자 ' 처리위해 Parameter 사용
     Parameters.ParamByName('pSubjectData').Value := DREdit_SubjectData.Text;
     Parameters.ParamByName('pBodyData').Value    := DRMemo_MailBody.Text;

     Try
           gf_ADOExecSQL(ADOQuery_Temp);
     Except
        on E : Exception do
        begin    // Database 오류
           Screen.Cursor := crDefault;
           gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SCMELSND[SUDGPML_TBL]: ' + E.Message, 0);
           gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Snd[SUDGPML_TBL]'); //Database 오류
           Exit;
        end;
     End;
  end; // end of with
end;

var
  sQuery  : string;
  sInsert : string;
  sUpdate : string;
  sSubjectData, sBodyData, sWhere : string;
begin
  inherited;
  sSubjectData := DREdit_SubjectData.Text;
  sBodyData    := DRMemo_MailBody.Text;
  // Query 문 Setting
  if SndItem.AccGrpType = gcRGROUP_GRP then   // 그룹별
  begin
    sQuery  :=  'Select SUBJECT_DATA, MAIL_BODY_DATA           '
              + '  From SUDGPML_TBL                            ';
    sInsert :=  'Insert SUDGPML_TBL  '
              + 'Values (''' + gvDeptCode + ''', ''' + gJobDate + ''', '
              + '        ''' + gvCurSecType + ''', ''' + SndItem.AccGrpName + ''', '
              + '        ''' + SndItem.MailFormId + ''', '
              + '        :pSubjectData , :pBodyData , '
              + '        ''' + gvOprUsrNo +''', '
              + '        ''' + gvCurDate + ''', ''' + gf_GetCurTime +''') ';
    sUpdate :=  'Update SUDGPML_TBL SET  '
              + '       SUBJECT_DATA =  :pSubjectData , '
              + '       MAIL_BODY_DATA = :pBodyData     ';
    sWhere  :=  ' Where DEPT_CODE = ''' + gvDeptCode + '''  '
              + '   and SND_DATE  = ''' + gJobDate + ''' '
              + '   and SEC_TYPE  = ''' + gvCurSecType + ''' '
              + '   and GRP_NAME = ''' + SndItem.AccGrpName + '''    '
              + '   and MAILFORM_ID = ''' + SndItem.MailFormId + ''' ';
  end
  else                                        // 계좌별
  begin
    sQuery   := 'Select SUBJECT_DATA, MAIL_BODY_DATA           '
              + ' From SUDACML_TBL                             ';
    sInsert :=  'Insert SUDACML_TBL  '
              + 'Values (''' + gvDeptCode + ''', ''' + gJobDate + ''', '
              + '        ''' + SndItem.AccList.Strings[0] + ''', '''', '
              + '        ''' + SndItem.MailFormId + ''', '
              + '        :pSubjectData, :pBodyData, '
              + '        ''' + gvOprUsrNo + ''', '
              + '        ''' + gvCurDate + ''', ''' + gf_GetCurTime + ''') ';
    sUpdate :=  'Update SUDACML_TBL SET  '
              + '       SUBJECT_DATA =  ''' + sSubjectData + ''', '
              + '       MAIL_BODY_DATA = ''' + sBodyData + '''   ';
    sWhere  :=  ' Where DEPT_CODE   = ''' + gvDeptCode + ''' '
              + '   and SND_DATE    = ''' + gJobDate + ''' '
              + '   and ACC_NO      = ''' + SndItem.AccList.Strings[0] + '''    '
              + '   and MAILFORM_ID = ''' + SndItem.MailFormID + ''' ';
  end;

  // Query 문 실행
  if ExcuteSqlSelect(sQuery+sWhere) then
     ExcuteSqlchange(sInsert)
  else
     ExcuteSqlChange(sUpdate+sWhere);

  SndItem.SubjectData  := sSubjectData;
  SndItem.MailBodyData := sBodyDAta;
  gf_ShowMessage(MessageBar, mtInformation, 1008, ''); // 수정 완료
end;

procedure TDlgForm_ViewMail.DREdit_SubjectDataKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key = #13 then
     DRMemo_MailBody.SetFocus;
end;


procedure TDlgForm_ViewMail.DRMemo_MailBodyChange(Sender: TObject);
var
   sbody : string;
   i : Integer;
begin
  inherited;
   sbody := DRMemo_MailBody.Text;

   for i:=1 to Length(sbody) do
   begin
      if (sbody[i] = #39) or (sbody[i] = #58) then  // 특수문자 (' :) 두가지를 스페이스처리
      begin
         sbody[i] := #32;                           // 쿼리문에서 에러발생하기때문에 처리해줌.
         gf_ShowMessage(MessageBar, mtError, 0, '허용되지않는 특수문자를 입력하셨습니다. 자동으로 Space처리됩니다. [:, '']'); // Database 오류
      end;
   end;
   DRMemo_MailBody.Text := sbody;
   DRMemo_MailBody.SelStart := Length(DRMemo_MailBody.Text);
end;

procedure TDlgForm_ViewMail.DREdit_SubjectDataChange(Sender: TObject);
var
   sSubjec : string;
   i : Integer;
begin
  inherited;
   sSubjec := DREdit_SubjectData.Text;

   for i:=1 to Length(sSubjec) do
   begin
      if (sSubjec[i] = #39) or (sSubjec[i] = #58) then  // 특수문자 (' :) 두가지를 스페이스처리
      begin
         sSubjec[i] := #32;                           // 쿼리문에서 에러발생하기때문에 처리해줌.
         gf_ShowMessage(MessageBar, mtError, 0, '허용되지않는 특수문자를 입력하셨습니다. 자동으로 Space처리됩니다. [:, '']'); // Database 오류
      end;
   end;
   DREdit_SubjectData.Text := sSubjec;
   DREdit_SubjectData.SelStart := Length(DREdit_SubjectData.Text);

end;

end.
