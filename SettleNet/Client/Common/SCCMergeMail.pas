unit SCCMergeMail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SCCDlgForm, DRDialogs, StdCtrls, Buttons, DRAdditional,
  ExtCtrls, DRStandard, DRSpecial, ComCtrls, DRWin32, DRCodeControl, DB,
  ADODB, SCCGlobalType, SCCLib;


type
  TDlgForm_MergeMail = class(TForm_Dlg)
    DRPanel1: TDRPanel;
    DRSpeedButton_MailRcv: TDRSpeedButton;
    DREdit_MailAddr: TDREdit;
    DRSpeedButton_CCMailRcv: TDRSpeedButton;
    DREdit_CCMailAddr: TDREdit;
    DREdit_CCBlindMailAddr: TDREdit;
    DRSpeedButton_CCBlindMailRcv: TDRSpeedButton;
    DREdit_Title: TDREdit;
    DRLabel15: TDRLabel;
    DRLabel27: TDRLabel;
    DRMemo_Body: TDRMemo;
    DRPanel2: TDRPanel;
    DRLabel13: TDRLabel;
    DRUserCodeCombo_MailForm: TDRUserCodeCombo;
    DRUserCodeCombo_MailGrp: TDRUserCodeCombo;
    DRLabel4: TDRLabel;
    DRPanel5: TDRPanel;
    DRListView_MailList: TDRListView;
    DRSpeedBtn_MailRcv: TDRSpeedButton;
    DRListView_MailMergeList: TDRListView;
    ADOQuery_Temp: TADOQuery;
    DRPanel6: TDRPanel;
    DRPanel7: TDRPanel;
    DRPanel8: TDRPanel;
    DRRadioGrp_RptType: TDRRadioGroup;
    DRChkBox_InsertUpdate: TDRCheckBox;
    function RefreshGrpCombo: boolean;
    function RefreshMailForm(GrpName: string): boolean;
    function ShowMailMerge(GrpName, MailFormID: string): Boolean;
    function DisplayMailMerge(GrpName, MailFormID: string): Boolean;


    function SUGPMELDataInsert(MailFormID: string): boolean;
    function SUGPMELDataUpdate: boolean;


    function MailStopFlag(GrpName, MailFormID, Flag: string): Boolean;
    function UpdateListMailStopFlag(Flag: string): Boolean;


    function SCMELIDDataInsert(MailformID, MailNameKor, MailMergeId, ExceptDeptCode: string;
      HelpText: WideString): boolean;

    function SCMELIDDataUpdate(MailformID, MailMergeId, ExceptDeptCode: string;
      HelpText: WideString): boolean;

    function SCMELIDDelete: Boolean;
    function SUGPMADDelete: Boolean;
    function SUGPMELDelete: Boolean;
    function ReturnMailType: string;
    function ReturnGrpType(iType: Integer): Integer;




    function RefreshMailQuery(GrpName, SerchMergeYN: string; MailfromID: string = ''): Boolean;

    function RefreshMailListview(GrpName: string): Boolean;

    function RefreshMergeMailListview(GrpName, MailformID: string): Boolean;
    function RefreshDisplayList(GrpName, MailformID: string): Boolean;
    //------------------------------------------------------------------------------
    // SUGPMAD_TBL에 Insert
    //------------------------------------------------------------------------------
    function RealSUGPMADInsert(pRcvtypeList: TStringList;
      pRcvType, MailFormID: string): boolean;

    function MailIDMake(var MailFormID: string): Boolean;
    function ExceptDeptCodeMerge(var ExceptDeptCode: string): Boolean;    

    //------------------------------------------------------------------------------
    // 입력누락 확인
    //------------------------------------------------------------------------------
    function CheckKeyEditEmpty: boolean;
    function returnMailFormName(MailformId: string): string;


    procedure ClearText;
    procedure FormCreate(Sender: TObject);
    procedure DRSpeedBtn_MailRcvClick(Sender: TObject);
    procedure DRListView_MailMergeListDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure DRListView_MailListKeyPress(Sender: TObject; var Key: Char);
    procedure DRListView_MailMergeListKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure DRListView_MailListDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure DRListView_MailListDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure DRListView_MailMergeListDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure DRListView_MailListDblClick(Sender: TObject);
    procedure DRListView_MailListMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DRListView_MailMergeListMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DRListView_MailMergeListDblClick(Sender: TObject);
    procedure DRSpeedButton_MailRcvClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MailAddrRcvToEdit(pMailAddrList, pCCMailAddrList, pCCBlindList: TSTringList;
      pMailEdit, pCCMailEdit, pCCBlindEdit: TDREdit);
    procedure DRUserCodeCombo_MailGrpCodeChange(Sender: TObject);
    procedure DRUserCodeCombo_MailFormCodeChange(Sender: TObject);
    procedure DRBitBtn4Click(Sender: TObject);
    procedure MakeMailNameHelpText(var MailMergeId: string; var HelpText: WideString);
    procedure DRBitBtn3Click(Sender: TObject);
    procedure DRBitBtn2Click(Sender: TObject);
    procedure DRRadioGrp_RptTypeClick(Sender: TObject);
    procedure DRUserCodeCombo_MailGrpEditKeyPress(Sender: TObject;
      var Key: Char);
    procedure FormShow(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
  end;
const
  RPTIDX_TRADE = 0; // 매매내역
  RPTIDX_DPST = 1; // 예탁현황
  RPTIDX_INOUT = 2; // 입출금통지
  RPTIDX_PGM = 3; // 프로그램매매
var
  //ChkInsertUpdateBool : Boolean;
  DlgForm_MergeMail: TDlgForm_MergeMail;
  // SEC_TPYE
  sSEC_TYPE: string;
  MailAddrList: TStringList; //수신처List
  CCMailAddrList: TStringList; //참조List
  CCBlindAddrList: TStringList; //숨은참조 List
  RptTypeClickBool : Boolean;

  // 입력 수정 삭제 체크


implementation

{$R *.dfm}

function TDlgForm_MergeMail.RefreshGrpCombo: boolean;
begin
  Result := False;
  with ADOQuery_Temp do
  begin
    // 메일 수신처에 등록된 그룹명
    Close;
    SQL.Clear;
    SQL.Add(' Select DISTINCT GRP_NAME '
      + ' From SUGPMEL_TBL '
      + ' Where DEPT_CODE = ''' + gvDeptCode + ''' '
      + '   And SEC_TYPE  = ''' + sSEC_TYPE + ''' '
      // 선물일 경우 분리
      + '   and Substring(MAILFORM_ID,2,1) = ''' + ReturnMailType + ''' '
      + ' Order By GRP_NAME ');
    try
      gf_ADOQueryOpen(ADOQuery_Temp);
    except
      on E: Exception do
      begin // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SUGPMEL_TBL : Select DISTINCT]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SUGPMEL_TBL : Select DISTINCT]'); //Database 오류
        Exit;
      end;
    end;

    DRUserCodeCombo_MailGrp.ClearItems;
    if recordcount = 0 then
    begin
      DRUserCodeCombo_MailGrp.AddItem('NOT',
        '메일서식 등록된 그룹 없음');
      DRUserCodeCombo_MailGrp.AssignCode('NOT');
      Result := True;
      Exit;
    end;


    while not EOF do
    begin
      DRUserCodeCombo_MailGrp.AddItem(Trim(FieldByName('GRP_NAME').asString),
        Trim(FieldByName('GRP_NAME').asString));
      Next;
    end;
    First;
    DRUserCodeCombo_MailGrp.AssignCode(Trim(FieldByName('GRP_NAME').asString));
  end; // end of with
  Result := True;
end;

function TDlgForm_MergeMail.RefreshMailQuery(GrpName, SerchMergeYN: string; MailfromID: string = ''): Boolean;
begin
  Result := False;
  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select DISTINCT G.MAILFORM_ID, M.MAILFORM_NAME_KOR, M.MAIL_MERGE_ID   ');
    SQL.Add('  From SUGPMEL_TBL G, SCMELID_TBL M         ');
    SQL.Add(' WHERE G.SEC_TYPE  = ''' + sSEC_TYPE + '''  ');
    SQL.Add('   AND G.DEPT_CODE = ''' + gvDeptCode + ''' ');
    SQL.Add('   AND G.MAILFORM_ID = M.MAILFORM_ID        ');
    SQL.Add('   AND Substring(G.MAILFORM_ID,2,1) = ''' + ReturnMailType + ''' ');

    if MailfromID <> '' then
      sql.add('   and M.MAILFORM_ID = ''' + MailfromID + ''' ');

    SQL.Add('   AND GRP_NAME =  ''' + GrpName + ''' ');

    if SerchMergeYN = 'Y' then
      SQL.Add('   AND G.MAIL_MERGE_YN = ''Y''              ')
    else
      SQL.Add('   AND G.MAIL_MERGE_YN <> ''Y''              ');

    SQL.Add('Order By MAILFORM_NAME_KOR                  ');

    try

      gf_ADOQueryOpen(ADOQuery_Temp);
    except
      on E: Exception do
      begin // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SUGPMEL_TBL/SCMELID_TBL : select]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SUGPMEL_TBL/SCMELID_TBL : select]'); //Database 오류
        Exit;
      end;
    end;
  end;
  Result := True;
end;



function TDlgForm_MergeMail.RefreshMailForm(GrpName: string): boolean;
begin
  Result := False;
  with ADOQuery_Temp do
  begin
    //그룹별 메일 묶음서식
    RefreshMailQuery(GrpName, 'Y');

    DRUserCodeCombo_MailForm.ClearItems; // 메일서식
    DRUserCodeCombo_MailForm.AddItem('NEW', '신규메일묶음');

    while not EOF do
    begin
      DRUserCodeCombo_MailForm.AddItem(Trim(FieldByName('MAILFORM_ID').asString),
        Trim(FieldByName('MAILFORM_NAME_KOR').asString));
      Next;
    end;
  end; // end of with
  Result := True;
end;

procedure TDlgForm_MergeMail.FormCreate(Sender: TObject);
begin
  inherited;
  MailAddrList := TStringList.Create;
  CCMailAddrList := TStringList.Create;
  CCBlindAddrList := TStringList.Create;
  DRChkBox_InsertUpdate.Checked := False;
end;

function TDlgForm_MergeMail.ShowMailMerge(GrpName, MailFormId: string): Boolean;
begin
  Result := False;

  //주식용
  if Copy(MailFormId, 1, 1) = gcSEC_EQUITY then
  begin
    sSEC_TYPE := gcSEC_EQUITY;
    DRPanel2.Visible := False;
  end
  // 선물임
  else if Copy(MailFormId, 1, 1) = gcSEC_FUTURES then
  begin
    sSEC_TYPE := gcSEC_FUTURES;
  end;

  if sSEC_TYPE = gcSEC_FUTURES then
  begin
    RptTypeClickBool := False;
    DRRadioGrp_RptType.ItemIndex := ReturnGrpType(StrToIntDef(Copy(MailFormId, 2, 1), 1));
    //라디오 버튼 체인지 이벤트 다시 활성화
    RptTypeClickBool := True;
  end;
  if not RefreshGrpCombo then Exit;

  if not DisplayMailMerge(GrpName, mailformid) then Exit;

  Result := True;
end;

function TDlgForm_MergeMail.RefreshMailListview(GrpName: string): Boolean;
var
  MailItem: TListItem;
begin
  Result := False;
  with ADOQuery_Temp do
  begin
    // 메일서식목록 생성 => 묶음그룹 제외
    RefreshMailQuery(GrpName, 'N');

    DRListView_MailList.Clear;

    //DRListView_MailList.Items.BeginUpdate;
    while not EOF do
    begin
      MailItem := DRListView_MailList.Items.Add;
      MailItem.Caption := Trim(FieldByName('MAILFORM_NAME_KOR').asString);
      MailItem.SubItems.Add(Trim(FieldByName('MAILFORM_ID').asString));
      Next;
    end;
    DRListView_MailList.Items.EndUpdate;

  end; // end of with
  Result := True;

end;




function TDlgForm_MergeMail.RefreshMergeMailListview(
  GrpName, MailformID: string): Boolean;
var
  Templist: TStringList;
  i: integer;
  MailItem: TListItem;
begin
  Result := False;
  //선택된 메일서식이 묶음메일서식일때만 가능
  RefreshMailQuery(GrpName, 'Y', MailformID);
  Templist := TStringList.Create;
  Templist.CommaText := Trim(ADOQuery_Temp.FieldByName('MAIL_MERGE_ID').asString);
  DRListView_MailMergeList.Clear;
  for i := 0 to Templist.Count - 1 do
  begin
    MailItem := DRListView_MailMergeList.Items.Add;
    MailItem.Caption := returnMailFormName(Templist.Strings[i]);
    MailItem.SubItems.Add(Templist.Strings[i]);
  end;
  DRListView_MailMergeList.Items.EndUpdate;
  Result := True;
end;

procedure TDlgForm_MergeMail.DRSpeedBtn_MailRcvClick(Sender: TObject);
var
  i, j: Integer;
  FindMail: boolean;
  MailItem: TListItem;
begin
  inherited;

  for i := 0 to DRListView_MailList.Items.Count - 1 do
  begin
    if DRListView_MailList.Items.Item[i].Selected then
    begin
      FindMail := False;
      for j := 0 to DRListView_MailMergeList.Items.Count - 1 do
      begin
        // 같은 메일서식 존재 하면 목록 넣는것에서 제외
        if DRListView_MailList.Items.Item[i].SubItems.Strings[0]
          = DRListView_MailMergeList.Items.item[j].SubItems.Strings[0] then
        begin
          FindMail := True;
          Break;
        end;
      end;
      // 없으면 추가
      if not FindMail then
      begin
        MailItem := DRListView_MailMergeList.Items.Add;
        MailItem.Caption := DRListView_MailList.Items.Item[i].Caption;
        MailItem.SubItems.Add(DRListView_MailList.Items.Item[i].SubItems.Strings[0]);
      end;
      DRListView_MailMergeList.Items.EndUpdate;
    end;
  end;

  for i := 0 to DRListView_MailList.Items.Count - 1 do
    DRListView_MailList.Items.Item[i].Selected := False;

//  DRListView_MailMergeList.SetFocus;
  DRListView_MailMergeList.AlphaSort;
  DRListView_MailMergeList.Refresh;
  DRListView_MailList.Refresh;

end;

procedure TDlgForm_MergeMail.DRListView_MailMergeListDragDrop(Sender,
  Source: TObject; X, Y: Integer);
begin
  inherited;
  DRSpeedBtn_MailRcvClick(nil);

end;

procedure TDlgForm_MergeMail.DRListView_MailListKeyPress(Sender: TObject;
  var Key: Char);
var
  i: Integer;
begin
  inherited;
  if Key = #1 then
  begin
    //for i := 0 to  TListView(Sender).Items.Count - 1 do
    //  TListView(Sender).Items.Item[i].Selected := true;
    TListView(Sender).SelectAll;
  end;
end;

procedure TDlgForm_MergeMail.DRListView_MailMergeListKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);

begin
  inherited;
  if Key = VK_DELETE then //DeleteKey
  begin
    DRListView_MailMergeListDblClick(nil);
  end;
end;

procedure TDlgForm_MergeMail.DRListView_MailListDragDrop(Sender,
  Source: TObject; X, Y: Integer);
begin
  DRListView_MailMergeListDblClick(nil);

end;

procedure TDlgForm_MergeMail.DRListView_MailListDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  if Source = DRListView_MailMergeList then
    Accept := True
  else
    Accept := False;
end;

procedure TDlgForm_MergeMail.DRListView_MailMergeListDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  if Source = DRListView_MailList then
    Accept := True
  else
    Accept := False;

end;

procedure TDlgForm_MergeMail.DRListView_MailListDblClick(Sender: TObject);
begin
  inherited;
  DRSpeedBtn_MailRcvClick(nil);

end;

procedure TDlgForm_MergeMail.DRListView_MailListMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then { 왼쪽버튼을 눌렀을 때만 Drag시작 }
    DRListView_MailList.BeginDrag(false);
end;

procedure TDlgForm_MergeMail.DRListView_MailMergeListMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  if Button = mbLeft then { 왼쪽버튼을 눌렀을 때만 Drag시작 }
    DRListView_MailMergeList.BeginDrag(false);
end;

procedure TDlgForm_MergeMail.DRListView_MailMergeListDblClick(
  Sender: TObject);
var
  i: Integer;
begin
  inherited;
  for i := DRListView_MailMergeList.Items.count - 1 downto 0 do
  begin
    if DRListView_MailMergeList.Items.Item[i].Selected then
      DRListView_MailMergeList.Items.Item[i].Delete;
  end;
  DRListView_MailMergeList.Items.EndUpdate;
  DRListView_MailMergeList.AlphaSort;

  DRListView_MailMergeList.Refresh;
  DRListView_MailList.Refresh;
end;

procedure TDlgForm_MergeMail.DRSpeedButton_MailRcvClick(Sender: TObject);
var
  TmpTitle: string;
  MailType: string;
begin
  inherited;
  //--- 수신처 등록
  if sender = DRSpeedButton_MailRcv then
    MailType := gcMAIL_RCV_TYPE
  else if sender = DRSpeedButton_CCMailRcv then
    MailType := gcCCMAIL_RCV_TYPE
  else if sender = DRSpeedButton_CCBlindMailRcv then
    MailType := gcCCBLIND_RCV_TYPE;


  TmpTitle := '';
  if Trim(DRUserCodeCombo_MailGrp.Code) <> '' then
    TmpTitle := '그룹명 : ' + Trim(DRUserCodeCombo_MailGrp.Code);
  if Trim(DRUserCodeCombo_MailForm.Code) <> '' then
    TmpTitle := TmpTitle + '   메일서식 : ' + Trim(DRUserCodeCombo_MailForm.CodeName);

  gf_ShowSelectEmail(MailAddrList, CCMailAddrList, CCBlindAddrList,
    MailType, TmpTitle); //수신처
  MailAddrRcvToEdit(MailAddrList, CCMailAddrList, CCBlindAddrList,
    DREdit_MailAddr, DREdit_CCMailAddr, DREdit_CCBlindMailAddr);
  // 포커스 작업 안함.

end;

procedure TDlgForm_MergeMail.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if Assigned(MailAddrList) then MailAddrList.Free;
  if Assigned(CCMailAddrList) then CCMailAddrList.Free;
  if Assigned(CCBlindAddrList) then CCBlindAddrList.Free;
  RptTypeClickBool := True;

end;

procedure TDlgForm_MergeMail.MailAddrRcvToEdit(pMailAddrList,
  pCCMailAddrList, pCCBlindList: TSTringList; pMailEdit, pCCMailEdit,
  pCCBlindEdit: TDREdit);
var
  i: integer;
  RcvStr: string;
begin
   //수신처
  RcvStr := '';
  for i := 0 to pMailAddrList.Count - 1 do
  begin
    RcvStr := RcvStr + gcSPLIT_MAILADDR +
      gf_SendSeqToRcvName(pMailAddrList.Strings[i]);
  end;
  pMailEdit.Text := Copy(RcvStr, 2, Length(RcvStr));
   //참조
  RcvStr := '';
  for i := 0 to pCCMailAddrList.Count - 1 do
  begin
    RcvStr := RcvStr + gcSPLIT_MAILADDR +
      gf_SendSeqToRcvName(pCCMailAddrList.Strings[i]);
  end;
  pCCMailEdit.Text := Copy(RcvStr, 2, Length(RcvStr));
   //숨은참조
  RcvStr := '';
  for i := 0 to pCCBlindList.Count - 1 do
  begin
    RcvStr := RcvStr + gcSPLIT_MAILADDR +
      gf_SendSeqToRcvName(pCCBlindList.Strings[i]);
  end;
  pCCBlindEdit.Text := Copy(RcvStr, 2, Length(RcvStr));

end;

function TDlgForm_MergeMail.RefreshDisplayList(GrpName,
  MailformID: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select GA.RCV_TYPE, GA.SEND_SEQ,              ');
    SQL.Add('   GP.SUBJECT_DATA, GP.MAIL_BODY_DATA         ');
    SQL.Add('from SUGPMAD_TBL GA , SUGPMEL_TBL GP          ');
    SQL.Add(' WHERE GA.SEC_TYPE  = ''' + sSEC_TYPE + '''  ');
    SQL.Add('   AND GA.DEPT_CODE = ''' + gvDeptCode + '''  ');
    SQL.Add('   AND GP.DEPT_CODE = GA.DEPT_CODE            ');
    SQL.Add('   AND GP.SEC_TYPE  = GA.SEC_TYPE             ');
    SQL.Add('   AND GP.GRP_NAME  = GA.GRP_NAME             ');
    SQL.Add('   AND GP.MAILFORM_ID  = GA.MAILFORM_ID       ');
    Sql.Add('   AND Substring(GP.MAILFORM_ID,2,1) = ''' + ReturnMailType + ''' ');
    SQL.Add('   AND GA.GRP_NAME =    ''' + GrpName + '''     ');
    SQL.add('   AND GP.MAILFORM_ID = ''' + MailformID + ''' ');

    try
      gf_ADOQueryOpen(ADOQuery_Temp);
    except
      on E: Exception do
      begin // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SUGPMAD_TBL/SUGPMEL_TBL : select]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SUGPMAD_TBL/SUGPMEL_TBL : select]'); //Database 오류
        Exit;
      end;
    end;


    // 멜 수신처 초기화
    MailAddrList.Clear;
    CCMailAddrList.Clear;
    CCBlindAddrList.Clear;

    DREdit_Title.Text := Trim(FieldByName('SUBJECT_DATA').asString);
    DRMemo_Body.Text := Trim(FieldByName('MAIL_BODY_DATA').asString);

    while not Eof do
    begin
      if Trim(FieldByName('RCV_TYPE').asString) = gcMAIL_RCV_TYPE then
        MailAddrList.Add(FieldByName('SEND_SEQ').asString)
      else if Trim(FieldByName('RCV_TYPE').asString) = gcCCMAIL_RCV_TYPE then
        CCMailAddrList.Add(FieldByName('SEND_SEQ').asString)
      else if Trim(FieldByName('RCV_TYPE').asString) = gcCCBLIND_RCV_TYPE then
        CCBlindAddrList.Add(FieldByName('SEND_SEQ').asString);
      Next;
    end;
  end;

  // 화면에 수신처 뿌림
  MailAddrRcvToEdit(MailAddrList, CCMailAddrList, CCBlindAddrList,
    DREdit_MailAddr, DREdit_CCMailAddr, DREdit_CCBlindMailAddr);


  Result := True;
end;

procedure TDlgForm_MergeMail.DRUserCodeCombo_MailGrpCodeChange(
  Sender: TObject);
begin
  inherited;
  ClearText;
  DisplayMailMerge(DRUserCodeCombo_MailGrp.CodeName, '');


end;

procedure TDlgForm_MergeMail.DRUserCodeCombo_MailFormCodeChange(
  Sender: TObject);
begin
  inherited;
  ClearText;
  DRListView_MailMergeList.Clear;
  if Copy(DRUserCodeCombo_MailForm.Code, 3, 1) = 'M' then
  begin
    // 수신처 제목 본문 List
    if not RefreshDisplayList(DRUserCodeCombo_MailGrp.Code, DRUserCodeCombo_MailForm.Code) then exit;
    // 메일 서식 목록 정리
    if not RefreshMergeMailListview(DRUserCodeCombo_MailGrp.Code, DRUserCodeCombo_MailForm.Code) then exit;
  end;
end;

procedure TDlgForm_MergeMail.ClearText;
begin
  DREdit_MailAddr.Clear;
  DREdit_CCMailAddr.Clear;
  DREdit_CCBlindMailAddr.Clear;
  DREdit_Title.Clear;
  DRMemo_Body.Clear;
  MailAddrList.Clear;
  CCMailAddrList.Clear;
  CCBlindAddrList.Clear;
end;

procedure TDlgForm_MergeMail.DRBitBtn4Click(Sender: TObject);
var
  sMailFormID, sMailName, sMailMergeID, sMailNameKor, sExceptDeptCode: string;
  sHelpText: WideString;
begin
  inherited;
  // 입력했음
  DRChkBox_InsertUpdate.Checked := True;

  // 체크사항
  if CheckKeyEditEmpty then Exit; //입력 누락 항목 확인

  // NEW묶음서식 신규 아님
  if DRUserCodeCombo_MailForm.Code <> 'NEW' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1024, ''); //해당 자료가 이미 존재합니다.
    exit;
  end;

  if DRListView_MailMergeList.Items.Count <= 1 then
  begin
    gf_ShowMessage(MessageBar, mtError, 0, '묶을메일서식이 2개이상 일때만 처리 가능 합니다');
    exit;
  end;



  gf_ShowMessage(MessageBar, mtInformation, 1010, ''); //입력 중입니다.
  DisableForm;
  // 메일 묶음 ID List 및 HelpText 만들기
  MakeMailNameHelpText(sMailMergeID, sHelpText);
  // MailID 만들기
  if not MailIDMake(sMailFormID) then exit;
  // 제외부서코드 병합
  if not ExceptDeptCodeMerge(sExceptDeptCode) then exit;
  // Mail Name 만들기
  sMailNameKor := gcSIGMA + '메일묶음'
    + inttostr(StrToIntDef(Copy(sMailFormID, 4, 4), 1))
    + '[' + DRUserCodeCombo_MailGrp.CodeName + ']';
  gf_BeginTransaction;
  if not SCMELIDDataInsert(sMailformID,
    sMailNameKor, sMailMergeId, sExceptDeptCode, sHelpText) then
  begin
    gf_RollBackTransaction;
    EnableForm;
    exit;
  end;
  if not SUGPMELDataInsert(sMailFormID) then
  begin
    gf_RollBackTransaction;
    EnableForm;
    exit;
  end;

  // 메일묶은것들은 정지
  if not UpdateListMailStopFlag('Y') then
  begin
    gf_RollBackTransaction;
    EnableForm;
    exit;
  end;
  gf_CommitTransaction;

  // 조회
  if not DisplayMailMerge(DRUserCodeCombo_MailGrp.Code, sMailFormID) then
  begin
    EnableForm;
    exit;
  end;
  EnableForm;

  gf_ShowMessage(MessageBar, mtInformation, 1011, ''); // 입력 완료
end;

//------------------------------------------------------------------------------
// 입력누락 확인
//------------------------------------------------------------------------------

function TDlgForm_MergeMail.CheckKeyEditEmpty: boolean;
begin
  Result := true;
  // 그룹 미존제
  if DRUserCodeCombo_MailGrp.Code = 'NOT' then
  begin
    gf_ShowMessage(MessageBar, mtError, 0, '그룹이 존재 하지 않습니다.'); // 그룹 X
    DRUserCodeCombo_MailGrp.SetFocus;
    Exit;
  end;

  //그룹명
  if DRUserCodeCombo_MailGrp.Code = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, ''); //입력 오류
    DRUserCodeCombo_MailGrp.SetFocus;
    Exit;
  end;
   //메일서식
  if DRUserCodeCombo_MailForm.Code = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, ''); //입력 오류
    DRUserCodeCombo_MailForm.SetFocus;
    Exit;
  end;
   //제목
  if DREdit_Title.TEXT = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, ''); //입력 오류
    DREdit_Title.SetFocus;
    Exit;
  end;
   //수신처 목록
  if (MailAddrList.Count <= 0) then
      // and (CCMailAddrList.Count <= 0) and
      //(CCBlindAddrList.Count <= 0) then
  begin
    gf_ShowMessage(MessageBar, mtError, 1103, ''); //수신처 정보를 입력하여 주십시요.
    DREdit_MailAddr.SetFocus;
    Exit;
  end;
  Result := false;
end;



function TDlgForm_MergeMail.SUGPMELDataInsert(MailFormID: string): boolean;
begin
  Result := false;
   //Insert SUGPMEL_TBL
  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' INSERT  SUGPMEL_TBL     '
      + '   (DEPT_CODE, SEC_TYPE, GRP_NAME, MAILFORM_ID               '
      + '   ,SUBJECT_DATA, MAIL_BODY_DATA, MAIL_MERGE_YN    '
      + '   ,OPR_ID, OPR_DATE, OPR_TIME)  '
      + ' VALUES   '
      + '   ( :pDeptCode, :pSecType, :pGrpName, :pMailformId          '
      + '   , :pSubJectData, :pMailBodyData,  :pMailMergeYn  '
      + '   , :pOprId, :pOprDate, :pOprTime)  ');

    //부서코드
    Parameters.ParamByName('pDeptCode').Value := gvDeptCode;
    //업무구분
    Parameters.ParamByName('pSecType').Value := sSEC_TYPE;
    //그룹명
    Parameters.ParamByName('pGrpName').Value := Trim(DRUserCodeCombo_MailGrp.Code);
    //메일서식
    Parameters.ParamByName('pMailformId').Value := MailFormID;
    //제목
    Parameters.ParamByName('pSubJectData').Value := Trim(DREdit_Title.Text);
    //내용
    Parameters.ParamByName('pMailBodyData').DataType := ftWideString;
    Parameters.ParamByName('pMailBodyData').Value := DRMemo_Body.Text;
    // 묶음 처리
    Parameters.ParamByName('pMailMergeYn').Value := 'Y';
    //조작자
    Parameters.ParamByName('pOprId').Value := gvOprUsrNo;
    //조작일자
    Parameters.ParamByName('pOprDate').Value := gvCurDate;
    //조작시간
    Parameters.ParamByName('pOprTime').Value := gf_GetCurTime;


    try
      gf_ADOExecSQL(ADOQuery_Temp);
    except
      on E: Exception do
      begin // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SUGPMEL_TBL :Insert]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SUGPMEL_TBL :Insert]'); //Database 오류
        Exit;
      end;
    end;
  end;
   //Insert SUGPMAD_TBL
  if not RealSUGPMADInsert(MailAddrList, gcMail_Rcv_Type, MailFormID) then exit;
  if not RealSUGPMADInsert(CCMailAddrList, gcCCMail_Rcv_Type, MailFormID) then exit;
  if not RealSUGPMADInsert(CCBlindAddrList, gcCCBlind_Rcv_Type, MailFormID) then exit;

  Result := true;
end;

//------------------------------------------------------------------------------
// SUGPMAD_TBL에 Insert
//------------------------------------------------------------------------------

function TDlgForm_MergeMail.RealSUGPMADInsert(pRcvtypeList: TStringList;
  pRcvType, MailFormID: string): boolean;
var
  i: integer;
begin
  Result := false;
  for i := 0 to pRcvTypeList.Count - 1 do
  begin
    with ADOQuery_Temp do
    begin
      Close;
      SQL.Clear;
      SQL.Add(' INSERT  SUGPMAD_TBL     '
        + '   (DEPT_CODE, SEC_TYPE, GRP_NAME, MAILFORM_ID         '
        + '   ,SEND_SEQ,  RCV_TYPE                                 '
        + '   ,OPR_ID, OPR_DATE, OPR_TIME)  '
        + ' VALUES   '
        + '   ( :pDeptCode, :pSecType, :pGrpName, :pMailformId    '
        + '   , :pSendSeq, :pRcvType                              '
        + '   , :pOprId, :pOprDate, :pOprTime)  ');

      Parameters.ParamByName('pDeptCode').Value := gvDeptCode;
      Parameters.ParamByName('pSecType').Value := sSEC_TYPE;
      Parameters.ParamByName('pGrpName').Value := Trim(DRUserCodeCombo_MailGrp.Code);
      Parameters.ParamByName('pMailformId').Value := MailFormID;
      Parameters.ParamByName('pSendSeq').Value := pRcvTypeList.Strings[i];
      Parameters.ParamByName('pRcvType').Value := pRcvType;
      Parameters.ParamByName('pOprId').Value := gvOprUsrNo;
      Parameters.ParamByName('pOprDate').Value := gvCurDate;
      Parameters.ParamByName('pOprTime').Value := gf_GetCurTime;

      try
        gf_ADOExecSQL(ADOQuery_Temp);
      except
        on E: Exception do
        begin // DataBase 오류
          gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SUGPMAD_TBL :Insert]: ' + E.Message, 0);
          gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SUGPMAD_TBL :Insert]'); //Database 오류
          Exit;
        end;
      end;
    end;
  end;
  Result := true;
end;

function TDlgForm_MergeMail.MailIDMake(var MailFormID: string): Boolean;
begin
  MailFormID := '';
  Result := False;
  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select substring(isnull(max(MAILFORM_ID),''' +
      sSEC_TYPE + ReturnMailType + 'M0000''),4,4) + 1 AS NUM         ');
    SQL.Add('from SCMELID_TBL                                        ');
    //   주식 예 E1M 선물 예 F1M, F3M, F6M
    SQL.Add('WHERE Substring(MAILFORM_ID,1,3) = ''' + sSEC_TYPE + ReturnMailType + 'M'' ');
    try
      gf_ADOQueryOpen(ADOQuery_Temp);
    except
      on E: Exception do
      begin // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SCMELID_TBL : MailMake]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SCMELID_TBL : MailMake]'); //Database 오류
        Exit;
      end;
    end;
    if recordcount = 0 then Exit;

    MailFormID := sSEC_TYPE + ReturnMailType +
      'M' + FormatFloat('0000', FieldByName('NUM').asinteger);
  end;

  Result := True;
end;

function TDlgForm_MergeMail.SCMELIDDataInsert(MailformID, MailNameKor, MailMergeId, ExceptDeptCode: string;
  HelpText: WideString): boolean;



begin
  Result := false;

  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' INSERT  SCMELID_TBL                           '
      + '   (MAILFORM_ID, MAILFORM_NAME_KOR                  '
      + '   ,COMPUTE_YN, HELP_TEXT                           '
      + '   ,OPR_ID, OPR_DATE, OPR_TIME, MAIL_MERGE_ID, EXCEPT_DEPT_CODE)        '
      + ' VALUES                                            '
      + '   ( :pMailFormId, :pMailFormNameKor               '
      + '   , :pComputeYn, :pHelpText                       '
      + '   , :pOprId, :pOprDate, :pOprTime, :pMailMergeId, :pExceptDeptCode) ');

    // 메일서식
    Parameters.ParamByName('pMailFormId').Value := MailFormID;
    // 메일서식명
    Parameters.ParamByName('pMailFormNameKor').Value := MailNameKor;
    // Y
    Parameters.ParamByName('pComputeYn').Value := 'Y';
    // Help Text
    Parameters.ParamByName('pHelpText').DataType := ftWideString;
    Parameters.ParamByName('pHelpText').Value := HelpText;

    //조작자
    Parameters.ParamByName('pOprId').Value := gvOprUsrNo;
    //조작일자
    Parameters.ParamByName('pOprDate').Value := gvCurDate;
    //조작시간
    Parameters.ParamByName('pOprTime').Value := gf_GetCurTime;
    //실제 멜 ID들
    Parameters.ParamByName('pMailMergeId').Value := MailMergeId;
    //제외부서
    Parameters.ParamByName('pExceptDeptCode').Value := ExceptDeptCode;

    try
      gf_ADOExecSQL(ADOQuery_Temp);
    except
      on E: Exception do
      begin // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SCMELID_TBL :Insert]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SCMELID_TBL :Insert]'); //Database 오류
        Exit;
      end;
    end;
  end;

   //Insert SUGPMAD_TBL
  Result := true;
end;

function TDlgForm_MergeMail.returnMailFormName(MailformId: string): string;
begin
  Result := '';
  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.add('SELECT MAILFORM_NAME_KOR ');
    sql.Add('  FROM SCMELID_TBL     ');
    sql.Add('Where  MAILFORM_ID = ''' + MailformId + '''    ');

    try
      gf_ADOQueryOpen(ADOQuery_Temp);
    except
      on E: Exception do
      begin // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SCMELID_TBL]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SCMELID_TBL]'); //Database 오류
        Exit;
      end;
    end;
    Result := Trim(ADOQuery_Temp.FieldByName('MAILFORM_NAME_KOR').asString);
  end;
end;

procedure TDlgForm_MergeMail.MakeMailNameHelpText(var MailMergeId: string;
  var HelpText: WideString);
var
  i: Integer;
begin
  HelpText := '다음과 같은 메일서식이 병합되었습니다.' + #13#10;
  MailMergeId := '';

  for i := 0 to DRListView_MailMergeList.Items.Count - 2 do
  begin
    HelpText := HelpText
      + DRListView_MailMergeList.Items.Item[i].Caption + ',';

    MailMergeId := MailMergeId + DRListView_MailMergeList.Items.Item[i].SubItems.Strings[0] + ',';

  end;
  HelpText := HelpText +
    DRListView_MailMergeList.Items.Item[DRListView_MailMergeList.Items.Count - 1].Caption;

  MailMergeId := MailMergeId +
    DRListView_MailMergeList.Items.Item[DRListView_MailMergeList.Items.Count - 1].SubItems.Strings[0];

end;

function TDlgForm_MergeMail.MailStopFlag(GrpName, MailFormID,
  Flag: string): Boolean;
var
  sDate: string;
begin
  Result := false;
  sDate := '';
  if Flag = 'Y' then
    sDate := gvCurDate;

  //Insert SUGPMEL_TBL
  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' UPDATE SUGPMEL_TBL     ');
    SQL.Add('    SET SEND_STOP  =  ''' + Flag + ''',  ');
    SQL.Add('    SEND_STOP_DATE =  ''' + sDate + ''',  ');
    SQL.Add('    OPR_ID         =  ''' + gvOprUsrNo + ''',  ');
    SQL.Add('    OPR_DATE       =  ''' + gvCurDate + ''',  ');
    SQL.Add('    OPR_TIME       =  ''' + gf_GetCurTime + '''  ');
    SQL.Add('  WHERE SEC_TYPE = ''' + sSEC_TYPE + '''  ');
    sql.add('    and DEPT_CODE = ''' + gvDeptCode + '''  ');
    sql.add('    and GRP_NAME  = ''' + GrpName + '''  ');
    sql.add('    and MAILFORM_ID = ''' + MailFormID + '''  ');

    try
      gf_ADOExecSQL(ADOQuery_Temp);
    except
      on E: Exception do
      begin // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SUGPMEL_TBL : MailStopFlag]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SUGPMEL_TBL : MailStopFlag]'); //Database 오류
        Exit;
      end;
    end;
  end;
  Result := true;
end;

function TDlgForm_MergeMail.UpdateListMailStopFlag(Flag: string): Boolean;
var
  i: Integer;
  GrpName, MailformID: string;

begin
  Result := False;
  GrpName := Trim(DRUserCodeCombo_MailGrp.Code);
  for i := 0 to DRListView_MailMergeList.Items.Count - 1 do
  begin
    // MailFromID
    MailformID := Trim(DRListView_MailMergeList.Items.Item[i].SubItems.Strings[0]);
    if not MailStopFlag(GrpName, MailformID, Flag) then Exit;

  end;
  Result := True;

end;

procedure TDlgForm_MergeMail.DRBitBtn3Click(Sender: TObject);
var
  sMailFormID, sMailName, sMailMergeID, sMailNameKor, sExceptDeptCode: string;
  sHelpText: WideString;
begin
  inherited;
  // 체크사항
  DRChkBox_InsertUpdate.Checked := True;

  if CheckKeyEditEmpty then Exit; //입력 누락 항목 확인

  // NEW면 수정 할수 없음
  if DRUserCodeCombo_MailForm.Code = 'NEW' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1025, '');
    exit;
  end;

  if DRListView_MailMergeList.Items.Count <= 1 then
  begin
    gf_ShowMessage(MessageBar, mtError, 0, '묶을메일서식이 2개 이상 일때만 처리 가능 합니다');
    exit;
  end;

  gf_ShowMessage(MessageBar, mtInformation, 1007, ''); //수정 중입니다.
  DisableForm;
  // 메일 묶음 ID List 및 HelpText 다시 만들기
  MakeMailNameHelpText(sMailMergeID, sHelpText);
  // MailID
  sMailFormID := DRUserCodeCombo_MailForm.Code;
  // 제외부서코드 병합
  if not ExceptDeptCodeMerge(sExceptDeptCode) then exit;
  // Mail Name
  //sMailNameKor :=  DRUserCodeCombo_MailForm.CodeName;

  gf_BeginTransaction;
  if not SCMELIDDataUpdate(sMailformID,
    sMailMergeId, sExceptDeptCode, sHelpText) then
  begin
    gf_RollBackTransaction;
    EnableForm;
    exit;
  end;

  if not SUGPMELDataUpdate then
  begin
    gf_RollBackTransaction;
    EnableForm;
    exit;
  end;

  // 메일묶은것들은 정지
  if not UpdateListMailStopFlag('Y') then
  begin
    gf_RollBackTransaction;
    EnableForm;
    exit;
  end;
  gf_CommitTransaction;

  // 조회
  if not DisplayMailMerge(DRUserCodeCombo_MailGrp.Code, sMailFormID) then
  begin
    EnableForm;
    exit;
  end;
  EnableForm;

  gf_ShowMessage(MessageBar, mtInformation, 1008, ''); // 수정  완료

end;



function TDlgForm_MergeMail.SCMELIDDataUpdate(MailformID,
  MailMergeId, ExceptDeptCode: string; HelpText: WideString): boolean;
begin
  Result := false;

  //Insert SCMELID_TBL
  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' UPDATE SCMELID_TBL     ');
    SQL.Add('    SET MAIL_MERGE_ID  =  :pMailMergeId  ,  ');
    SQL.Add('    HELP_TEXT       =  :pHelpText, ');
    SQL.Add('    EXCEPT_DEPT_CODE       =  :pExceptDeptCode ');
    SQL.Add('  WHERE MAILFORM_ID = :MailformId  ');

    //실제 멜 ID들
    Parameters.ParamByName('pMailMergeId').Value := MailMergeId;
    // Help Text
    Parameters.ParamByName('pHelpText').DataType := ftWideString;
    Parameters.ParamByName('pHelpText').Value := HelpText;
    //멜아뒤
    Parameters.ParamByName('MailformId').Value := MailformID;
    //제외부서
    Parameters.ParamByName('pExceptDeptCode').Value := ExceptDeptCode;


    try
      gf_ADOExecSQL(ADOQuery_Temp);
    except
      on E: Exception do
      begin // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SCMELID_TBL :Update]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SCMELID_TBL :Update]'); //Database 오류
        Exit;
      end;
    end;
  end;
  Result := true;
end;

function TDlgForm_MergeMail.SUGPMELDataUpdate: boolean;
begin
  Result := false;
   //Insert SUGPMEL_TBL
  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' Update  SUGPMEL_TBL     '
      + '     Set  SUBJECT_DATA = :pSubJectData ,   '
      + '        MAIL_BODY_DATA = :pMailBodyData ,  '
      + '        OPR_ID         = :pOprId ,         '
      + '        OPR_DATE       = :pOprDate ,       '
      + '        OPR_TIME       = :pOprTime         '
      + '  where DEPT_CODE      = :pDeptCode        '
      + '    and SEC_TYPE       = :pSecType         '
      + '    and GRP_NAME       = :pGrpName         '
      + '    and MAILFORM_ID    = :pMailformId      ');
    //제목
    Parameters.ParamByName('pSubJectData').Value := Trim(DREdit_Title.Text);
    //내용
    Parameters.ParamByName('pMailBodyData').DataType := ftWideString;
    Parameters.ParamByName('pMailBodyData').Value := DRMemo_Body.Text;
    //조작자
    Parameters.ParamByName('pOprId').Value := gvOprUsrNo;
    //조작일자
    Parameters.ParamByName('pOprDate').Value := gvCurDate;
    //조작시간
    Parameters.ParamByName('pOprTime').Value := gf_GetCurTime;

    //부서코드
    Parameters.ParamByName('pDeptCode').Value := gvDeptCode;
    //업무구분
    Parameters.ParamByName('pSecType').Value := sSEC_TYPE;
    //그룹명
    Parameters.ParamByName('pGrpName').Value := Trim(DRUserCodeCombo_MailGrp.Code);
    //메일서식
    Parameters.ParamByName('pMailformId').Value := Trim(DRUserCodeCombo_MailForm.Code);

    try
      gf_ADOExecSQL(ADOQuery_Temp);
    except
      on E: Exception do
      begin // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SUGPMEL_TBL : Update]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SUGPMEL_TBL : Update]'); //Database 오류
        Exit;
      end;
    end;



  end;
  //Delete SUGPMAD_TBL
  if not SUGPMADDelete then exit;
  //Insert SUGPMAD_TBL
  if not RealSUGPMADInsert(MailAddrList, gcMail_Rcv_Type, DRUserCodeCombo_MailForm.Code) then exit;
  if not RealSUGPMADInsert(CCMailAddrList, gcCCMail_Rcv_Type, DRUserCodeCombo_MailForm.Code) then exit;
  if not RealSUGPMADInsert(CCBlindAddrList, gcCCBlind_Rcv_Type, DRUserCodeCombo_MailForm.Code) then exit;

  Result := true;
end;

procedure TDlgForm_MergeMail.DRBitBtn2Click(Sender: TObject);
var
  sMailFormID, sMailName, sMailMergeID, sMailNameKor: string;
  sHelpText: WideString;
begin
  inherited;
  // 체크사항
  DRChkBox_InsertUpdate.Checked := True;

  if CheckKeyEditEmpty then Exit; //입력 누락 항목 확인

  // NEW면 삭제 할수 없음
  if DRUserCodeCombo_MailForm.Code = 'NEW' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1025, ''); //해당 자료가 존재하지 않습니다.
    exit;
  end;

  gf_ShowMessage(MessageBar, mtInformation, 1005, ''); //삭제중입니다.
  DisableForm;

  gf_BeginTransaction;

  // 메일 묶었던것들 중지 해제
  {if not UpdateListMailStopFlag('N') then
  begin
    gf_RollBackTransaction;
    EnableForm;
    exit;
  end; }

  if not SCMELIDDelete then
  begin
    gf_RollBackTransaction;
    EnableForm;
    exit;
  end;

  if not SUGPMADDelete then
  begin
    gf_RollBackTransaction;
    EnableForm;
    exit;
  end;

  if not SUGPMELDelete then
  begin
    gf_RollBackTransaction;
    EnableForm;
    exit;
  end;

  gf_CommitTransaction;

  ClearText;
  // 조회 해당 그룹으로 재조회
  if not DisplayMailMerge(DRUserCodeCombo_MailGrp.Code, '') then
  begin
    EnableForm;
    exit;
  end;
  EnableForm;

  gf_ShowMessage(MessageBar, mtInformation, 1006, ''); // 삭제 완료

end;

function TDlgForm_MergeMail.SCMELIDDelete: Boolean;
begin
  Result := False;
  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' DELETE SCMELID_TBL     '
      + ' WHERE MAILFORM_ID = ''' + Trim(DRUserCodeCombo_MailForm.Code) + ''' ');

    try
      gf_ADOExecSQL(ADOQuery_Temp);
    except
      on E: Exception do
      begin // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SCMELID_TBL :DELETE]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SCMELID_TBL :DELETE]'); //Database 오류
        Exit;
      end;
    end;
  end;
  Result := True;
end;

function TDlgForm_MergeMail.SUGPMADDelete: Boolean;
begin
  Result := False;
  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' DELETE SUGPMAD_TBL     '
      + ' WHERE  DEPT_CODE = ''' + gvDeptCode + ''' '
      + '  AND   SEC_TYPE  = ''' + sSEC_TYPE + ''' '
      + '  AND   GRP_NAME  = ''' + Trim(DRUserCodeCombo_MailGrp.Code) + ''' '
      + '  AND   MAILFORM_ID = ''' + Trim(DRUserCodeCombo_MailForm.Code) + ''' ');

    try
      gf_ADOExecSQL(ADOQuery_Temp);
    except
      on E: Exception do
      begin // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SUGPMAD_TBL :DELETE]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SUGPMAD_TBL :DELETE]'); //Database 오류
        Exit;
      end;
    end;
  end;
  Result := True;
end;

function TDlgForm_MergeMail.SUGPMELDelete: Boolean;
begin
  Result := False;
  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' DELETE SUGPMEL_TBL     '
      + ' WHERE  DEPT_CODE = ''' + gvDeptCode + ''' '
      + '  AND   SEC_TYPE  = ''' + sSEC_TYPE + ''' '
      + '  AND   GRP_NAME  = ''' + Trim(DRUserCodeCombo_MailGrp.Code) + ''' '
      + '  AND   MAILFORM_ID = ''' + Trim(DRUserCodeCombo_MailForm.Code) + ''' ');

    try
      gf_ADOExecSQL(ADOQuery_Temp);
    except
      on E: Exception do
      begin // DataBase 오류
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SUGPMEL_TBL :DELETE]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SUGPMEL_TBL :DELETE]'); //Database 오류
        Exit;
      end;
    end;
  end;
  Result := True;
end;

function TDlgForm_MergeMail.ReturnMailType: string;
begin
  Result := '';
  case DRRadioGrp_RptType.ItemIndex of
    RPTIDX_TRADE:
      Result := '1'; // 선물 F1
    RPTIDX_PGM:
      Result := '6'; // 프로그램 F6
    RPTIDX_INOUT:
      Result := '3'; // 입출금  F3
    RPTIDX_DPST:
      Result := '2'; // 예탁 F2
  end;
end;

procedure TDlgForm_MergeMail.DRRadioGrp_RptTypeClick(Sender: TObject);
begin
  inherited;

  if RptTypeClickBool then
  begin
    if not RefreshGrpCombo then exit;
    ClearText;
    DRListView_MailList.Clear;
    DRListView_MailMergeList.Clear;
    DisplayMailMerge(DRUserCodeCombo_MailGrp.Code, '');
  end;
end;

function TDlgForm_MergeMail.ReturnGrpType(iType: Integer): Integer;
begin
  Result := 1;
  case iType of
    1: Result := RPTIDX_TRADE; // 선물 F1
    6: Result := RPTIDX_PGM; // 프로그램 F6
    3: Result := RPTIDX_INOUT; // 입출금  F3
    2: Result := RPTIDX_DPST; // 예탁 F2
  end;
end;

function TDlgForm_MergeMail.DisplayMailMerge(GrpName,
  MailFormID: string): Boolean;
begin
  Result := False;

  //그룹 매칭
  DRUserCodeCombo_MailGrp.AssignCode(GrpName);
  //묶음 메일 목록 가져오기
  if not RefreshMailForm(GrpName) then Exit;

  // 묶음 메일 매칭
  if Copy(MailFormId, 3, 1) = 'M' then
    DRUserCodeCombo_MailForm.AssignCode(MailFormId)
  else
    DRUserCodeCombo_MailForm.AssignCode('NEW');

  if not RefreshMailListview(GrpName) then exit;

  DRListView_MailMergeList.Clear;

  // 들어오는데로 MailformId 체크해서 해당 메일 수신처 뿌림
  if (Trim(MailFormId) <> '') or
     (Length(MailFormId) <> 1) then
  begin
    // 수신처 제목 본문 List
    if not RefreshDisplayList(GrpName, MailFormId) then exit;

    // 메일 서식 목록 정리
    if not RefreshMergeMailListview(GrpName, MailFormId) then exit;
  end;

  Result := True;
end;

procedure TDlgForm_MergeMail.DRUserCodeCombo_MailGrpEditKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
  if (Key = #13) and (ActiveControl is TWinControl) then // 다음 Control로 이동
  begin
    gf_ClearMessage(MessageBar);
    SelectNext(ActiveControl as TWinControl, True, True);
  end;
  {else if gvGrpNameUpperOnly then
    gf_ToUpper(Key); }
end;

procedure TDlgForm_MergeMail.FormShow(Sender: TObject);
begin
  inherited;
  //포커스 안보이게..
  DRListView_MailMergeList.SetFocus;
end;

// 제외부서 병합하기
function TDlgForm_MergeMail.ExceptDeptCodeMerge(var ExceptDeptCode: string): Boolean;
var
  sTempList: TStringList;
  i: integer;
begin
  try
    Result := False;

    sTempList := TStringList.Create;

    with ADOQuery_Temp do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT EXCEPT_DEPT_CODE = ISNULL(EXCEPT_DEPT_CODE,'''')     ');
      SQL.Add('FROM SCMELID_TBL                         ');
      //   주식 예 E1M 선물 예 F1M, F3M, F6M
      SQL.Add('WHERE MAILFORM_ID <> ''''  ');

      if DRListView_MailMergeList.Items.count > 0 then
      begin
        SQL.ADD(' AND (');
        for i := 0 to DRListView_MailMergeList.Items.Count - 2 do
        begin
          SQL.ADD(' (MAILFORM_ID = ''' + DRListView_MailMergeList.Items.Item[i].SubItems.Strings[0] + ''')        OR ');
        end;
        SQL.ADD(' (MAILFORM_ID = ''' + DRListView_MailMergeList.Items.Item[DRListView_MailMergeList.Items.Count - 1].SubItems.Strings[0] + '''))           ');
      end;

      try
        gf_ADOQueryOpen(ADOQuery_Temp);
      except
        on E: Exception do
        begin // DataBase 오류
          gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Temp[SCMELID_TBL : ExceptDeptCodeMerge]: ' + E.Message, 0);
          gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[SCMELID_TBL : ExceptDeptCodeMerge]'); //Database 오류
          Exit;
        end;
      end;
      if recordcount = 0 then Exit;

      first;
      while not EOF do
      begin
        gf_DelimiterStringList(',', Trim(FieldByName('EXCEPT_DEPT_CODE').asString), sTempList);

        //for i := 0 to sExcpetDeptCodeList.Count -1 do
        //begin
        for i := 0 to sTempList.Count - 1 do
        begin
          if Pos(sTempList.Strings[i], ExceptDeptCode) > 0 then
          begin
            continue;
          end else
          begin
            if Trim(ExceptDeptCode) = '' then
            begin
              ExceptDeptCode := sTempList.Strings[i];
            end else
            begin
              ExceptDeptCode := ExceptDeptCode + ',' + sTempList.Strings[i];
            end;
          end;
        end;
        next;
      end;
    end;

    Result := True;

  finally
    if Assigned(sTempList) then
      FreeAndNil(sTempList);
  end;
end;

end.

