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
// ������  Mail ���뺸��
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
   // �������� ���丮
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

   DRLabel7.Caption            := '�Ÿ�����';
   DRListView_SndAttFile.Items.Clear;


   // Title
   Caption := 'To. ' + SndItem.AccGrpName ;

   // �������
   DRLabel_Sender.Caption := gvMailOprName;

   DRLabel_Sender.Caption := DRLabel_Sender.Caption + ' [' + gvRtnMailAddr + ']';

   // ��������
   DRLabel_SendDate.Caption := gf_FormatDate(gJobDate);

   // �޴»��
   DRLabel_Receiver.Caption := BuildMailStrList(SndItem.MailRcv);
   DRLabel_Receiver.Hint    := BuildMailStrList(SndItem.MailAddr);

   // ����
   DRLabel_CCList.Caption   := BuildMailStrList(SndItem.CCMailRcv);
   DRLabel_CCList.Hint      := BuildMailStrList(SndItem.CCMailAddr);

   // ��������
   DRLabel_BlindCCList.Caption := BuildMailStrList(SndItem.CCBlindRcv);
   DRLabel_BlindCCList.Hint    := BuildMailStrList(SndItem.CCBlindAddr);

   //����
   DREdit_SubjectData.Text := SndItem.SubjectData;

   // ���ۻ���
   if (SndItem.SendFlag) and (Trim(SndItem.ErrMsg) = '') then
      DRLabel_Status.Caption := '����' + gwRSPOK;  // ����

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
//  ������ Mail ���뺸��
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

   DRLabel7.Caption            := '��������';
   DRListView_SntAttFile.Items.Clear;
   AttSeqNoList.Clear;

   // Title
   Caption := 'To. ' + FreqItem.AccGrpName ;

   // �������
   DRLabel_Sender.Caption := gvMailOprName;

   DRLabel_Sender.Caption := DRLabel_Sender.Caption + ' [' + gvRtnMailAddr + ']';

   // ��������
   DRLabel_SendDate.Caption := gf_FormatDate(gSndDate);

   // �޴»��
   DRLabel_Receiver.Caption := FreqItem.RcvMailName;
   DRLabel_Receiver.Hint    := FreqItem.RcvMailAddr;

   // ����
   DRLabel_CCList.Caption   := FreqItem.CCMailName;
   DRLabel_CCList.Hint      := FreqItem.CCMailAddr;

   // ��������
   DRLabel_BlindCCList.Caption := FreqItem.CCBlindName;
   DRLabel_BlindCCList.Hint    := FreqItem.CCBlindAddr;

   //����
   DREdit_SubjectData.Text := FreqItem.SubjectData;

      // ���ۻ���
   iRspFlag := FreqItem.RSPFlag;
   case iRspFlag of
      gcEMAIL_RSPF_WAIT : sStatus := '���� ��� ��...';
      gcEMAIL_RSPF_SEND : sStatus := '���� ��...';
      gcEMAIL_RSPF_CANC : sStatus := '���� ���!';
      gcEMAIL_RSPF_FIN  :
      begin
         sStatus := '���� �Ϸ�!';
         if FreqItem.ErrCode <> '' then  // Error �߻�
            sStatus := '���� �� ���� �߻� - ';// +  gf_ReturnMsg(SntItem.ErrCode) + '(' + SntItem.ExtMsg + ')' );
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
//  ������ ���� ����
//------------------------------------------------------------------------------
procedure TDlgForm_ViewMail.DRListView_SndAttFileDblClick(Sender: TObject);
var
   ListItem : TListItem;
   AttItem  : pTAttfile;
   iSelIdx, iAttSeqNo, I : Integer;
   sFileName, sFilePath, sDirName : string;

begin
   ListItem := DRListView_SndAttFile.Selected;
   if not Assigned(ListItem)  then Exit;   // ���� ���� ����
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
      gf_ShowMessage(MessageBar, mtError, 9006, '');   // ���� ���� ����
   end else
   begin
//      sFileName := sDirName + ListItem.Caption;
      sFileName := fnGetTokenStr(sFilePath, gcSPLIT_MAILADDR, iSelIdx+1);

      if ShellExecute(Handle, 'open', Pchar(sFileName), nil, nil, SW_SHOW) = SE_ERR_NOASSOC then
        WinExec(PChar('rundll32.exe shell32.dll, OpenAs_RunDLL ' +  sFileName), SW_SHOW);

      // ������ �������Ƿ� �������� True
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
//  ������ ���� ����
//------------------------------------------------------------------------------
procedure TDlgForm_ViewMail.DRListView_SntAttFileDblClick(Sender: TObject);
var
   ListItem : TListItem;
   AttItem  : pTAttfile;
   iSelIdx, iAttSeqNo : Integer;
   sAttFileName : string;
begin
   ListItem := DRListView_SntAttFile.Selected;
   if not Assigned(ListItem)  then Exit;   // ���� ���� ����

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
// �����ּ� ����
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
        begin    // Database ����
           Screen.Cursor := crDefault;
           gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SCMELSND[SUDGPML_TBL]: ' + E.Message, 0);
           gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Snd[SUDGPML_TBL]'); //Database ����
           Exit;
        end;
     End;
        if RecordCount < 1 then
           Result := True;   // True : Insert False : Upate
  end; // end of with
end;
// SQL ���� : Insert or Update
procedure ExcuteSqlChange(sQuery : string);
begin
  with ADOQuery_Temp do
  begin
     Close;
     SQL.Clear;
     SQL.Add(sQuery);

     // Ư������ ' ó������ Parameter ���
     Parameters.ParamByName('pSubjectData').Value := DREdit_SubjectData.Text;
     Parameters.ParamByName('pBodyData').Value    := DRMemo_MailBody.Text;

     Try
           gf_ADOExecSQL(ADOQuery_Temp);
     Except
        on E : Exception do
        begin    // Database ����
           Screen.Cursor := crDefault;
           gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_SCMELSND[SUDGPML_TBL]: ' + E.Message, 0);
           gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Snd[SUDGPML_TBL]'); //Database ����
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
  // Query �� Setting
  if SndItem.AccGrpType = gcRGROUP_GRP then   // �׷캰
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
  else                                        // ���º�
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

  // Query �� ����
  if ExcuteSqlSelect(sQuery+sWhere) then
     ExcuteSqlchange(sInsert)
  else
     ExcuteSqlChange(sUpdate+sWhere);

  SndItem.SubjectData  := sSubjectData;
  SndItem.MailBodyData := sBodyDAta;
  gf_ShowMessage(MessageBar, mtInformation, 1008, ''); // ���� �Ϸ�
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
      if (sbody[i] = #39) or (sbody[i] = #58) then  // Ư������ (' :) �ΰ����� �����̽�ó��
      begin
         sbody[i] := #32;                           // ���������� �����߻��ϱ⶧���� ó������.
         gf_ShowMessage(MessageBar, mtError, 0, '�������ʴ� Ư�����ڸ� �Է��ϼ̽��ϴ�. �ڵ����� Spaceó���˴ϴ�. [:, '']'); // Database ����
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
      if (sSubjec[i] = #39) or (sSubjec[i] = #58) then  // Ư������ (' :) �ΰ����� �����̽�ó��
      begin
         sSubjec[i] := #32;                           // ���������� �����߻��ϱ⶧���� ó������.
         gf_ShowMessage(MessageBar, mtError, 0, '�������ʴ� Ư�����ڸ� �Է��ϼ̽��ϴ�. �ڵ����� Spaceó���˴ϴ�. [:, '']'); // Database ����
      end;
   end;
   DREdit_SubjectData.Text := sSubjec;
   DREdit_SubjectData.SelStart := Length(DREdit_SubjectData.Text);

end;

end.
