//==============================================================================
//   [jykim] 2001/12/12
//==============================================================================
unit SCCSelectEmail;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCCDlgForm, Buttons, DRAdditional, DRStandard, ComCtrls, DRWin32,
  StdCtrls, ExtCtrls, DRSpecial, Db, ADODB, Menus, DRDialogs;

type
  TDlgForm_SelectEmail = class(TForm_Dlg)
    DRSpeedBtn_MailRcv: TDRSpeedButton;
    DRSpeedBtn_CCMailRcv: TDRSpeedButton;
    DRSpeedBtn_CCBlindMailRcv: TDRSpeedButton;
    DRGroupBox1: TDRGroupBox;
    DRSpeedButton_RegEmailAddr: TDRSpeedButton;
    DRListView_CCBlindMailRcv: TDRListView;
    DRListView_CCMailRcv: TDRListView;
    DRListView_MailRcv: TDRListView;
    ADOQuery_MailList: TADOQuery;
    DRListView_MailList: TDRListView;
    PopupMenuMailRcv: TDRPopupMenu;
    MenuItem_DelJobMail: TMenuItem;
    PopupMenuCCMailRcv: TDRPopupMenu;
    MenuItem_DelJobCC: TMenuItem;
    PopupMenuCCBlindRcv: TDRPopupMenu;
    MenuItem_DelJobBlind: TMenuItem;
    PopupMenuAllMailList: TDRPopupMenu;
    MenuItem1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    DRLabel_Title: TDRLabel;
    function  BuildListViewAllMailAddr : boolean;
    procedure DisplayAllMailAddr;
    function SearchRcvTypeItem(pRcvType,pSendSeq : string) : integer;
    procedure ClearSUMELADList;
    procedure ClearRcvTypeList;
    procedure RefreshRcvTypeItem;
    procedure ListDelJob(pRcvtype : string;  pListView : TDrListView);
    procedure DisplayRcvData(pRcvType : string; pListView : TDrListView);
    procedure FormCreate(Sender: TObject);
    procedure DRSpeedButton_RegEmailAddrClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure DRSpeedBtn_MailRcvClick(Sender: TObject);
    procedure DRSpeedBtn_CCMailRcvClick(Sender: TObject);
    procedure DRSpeedBtn_CCBlindMailRcvClick(Sender: TObject);
    procedure DRBitBtn3Click(Sender: TObject);
    procedure DRBitBtn2Click(Sender: TObject);
    procedure DRListView_MailListDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure DRListView_MailRcvDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure DRListView_CCMailRcvDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure DRListView_CCBlindMailRcvDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure DRListView_MailListDblClick(Sender: TObject);
    procedure DRListView_MailListMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DRListView_MailRcvDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure DRListView_MailListColumnClick(Sender: TObject;
      Column: TListColumn);
    procedure DRListView_CCMailRcvMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DRListView_CCBlindMailRcvMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DRListView_MailRcvMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MenuItem_DelJobMailClick(Sender: TObject);
    procedure MenuItem_DelJobCCClick(Sender: TObject);
    procedure MenuItem_DelJobBlindClick(Sender: TObject);
    procedure DRListView_MailRcvKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DRListView_CCMailRcvKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DRListView_CCBlindMailRcvKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure DRListView_MailRcvKeyPress(Sender: TObject; var Key: Char);
    procedure DRListView_CCMailRcvKeyPress(Sender: TObject; var Key: Char);
    procedure DRListView_CCBlindMailRcvKeyPress(Sender: TObject;
      var Key: Char);
    procedure DRListView_MailListDragDrop(Sender, Source: TObject; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    DefMailAddrList    : TStringList;
    DefCCMailAddrList  : TStringList;
    DefCCBlindAddrList : TStringList;
    DefRcvType    : string;
    DefTitle      : string;
  end;

var
  DlgForm_SelectEmail: TDlgForm_SelectEmail;

implementation
{$R *.DFM}
uses
  SCCLib, SCCGlobalType;
type
  //-- SUMELAD_TBL의 DATA
  TSUMELADData = record
     SendSeq    : string;
     MailRcv    : string;
     MailAddr   : string;
  end;
  pTSUMELADData = ^TSUMELADData;

  TRcvTypeData = record
     ListViewIDx :integer;
     RcvType    : string;    //R,C,B
     SendSeq    : string;
     MailRcv    : string;
     DelMod     : boolean;
     Selected   : boolean;
  end;
  pTRcvTypeData = ^TRcvTypeData;

const
   CtrlA = #1;
   
var
   SUMELADList    : TList;           //모든 수신처
   RcvTypeList    : TList;
   SeqPos : string;
   SortIdx    : Integer;                     // 현재 Sort Column의 Index
   SortFlag   : Array [0..1] of Boolean;  

//------------------------------------------------------------------------------
//  List Sorting
//------------------------------------------------------------------------------
function MailListCompare(Item1, Item2: Pointer): Integer;
begin
   case SortIdx of
      // 수신처
      0: Result := gf_ReturnStrComp(pTSUMELADData(Item1).MailRcv,
                                    pTSUMELADData(Item2).MailRcv,
                                    SortFlag[SortIdx]);
      // 이메일주소
      1: Result := gf_ReturnStrComp(pTSUMELADData(Item1).MailAddr,
                                    pTSUMELADData(Item2).MailAddr,
                                    SortFlag[SortIdx]);
      else
         Result := 0;
   end;
end;


//------------------------------------------------------------------------------
// FormCreate
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.FormCreate(Sender: TObject);
begin
  inherited;
  SeqPos := gcMAIL_RCV_TYPE; //기본으로 수신처에 입력가능하도록

  SUMELADList := TList.Create;
  RcvTypeList := TList.Create;
  if not Assigned(SUMELADList) or
     not Assigned(RcvTypeList)  then
  begin
      gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); // List 생성 오류
      Close;
      Exit;
  end;

  if not BuildListViewAllMailAddr then Exit;  //전체 수신처 주소
  DisplayAllMailAddr;
end;


//------------------------------------------------------------------------------
// FormClose
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
   iRtnValue : Integer;
begin
  inherited;

   if Assigned(SUMELADList) then
   begin
      ClearSUMELADList;
      SUMELADList.Free;
   end;

   if Assigned(RcvTypeList) then
   begin
      ClearRcvTypeList;
      RcvTypeList.Free;
   end;

   // Data 변경 여부 리턴
{
   iRtnValue := gcMR_NONE;
   if InsFlag then  // Insert
      iRtnValue := gcMR_INSERTED;
   if ModFlag then  // Update, Delete
      iRtnValue := gcMR_MODIFIED;
   ModalResult := iRtnValue;
}
end;


//------------------------------------------------------------------------------
// Clearlist
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.ClearSUMELADList;
var
   SUMELADItem : pTSUMELADData;
   i : integer;
begin
   if not Assigned(SUMELADList) then Exit;
   for I := 0 to SUMELADList.Count -1 do
   begin
      SUMELADItem := SUMELADList.Items[i];
      Dispose(SUMELADItem);
   end;  // end of for
   SUMELADList.Clear;
end;

procedure TDlgForm_SelectEmail.ClearRcvTypeList;
var
   RcvTypeItem : pTRcvTypeData;
   i : integer;
begin
   if not Assigned(RcvTypeList) then Exit;
   for I := 0 to RcvTypeList.Count -1 do
   begin
      RcvTypeItem := RcvTypeList.Items[i];
      Dispose(RcvTypeItem);
   end;  // end of for
   RcvTypeList.Clear;
end;


//------------------------------------------------------------------------------
// 수신처 등록정보
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.DRSpeedButton_RegEmailAddrClick(Sender: TObject);
var
   MailAddr, MailRcv : string;
   iRtnValue, i : Integer;
begin
  inherited;
   MailRcv  := '';
   MailAddr := ''; // Clear
//   if DRListView_MailList.Selected  = nil then exit;
   for i := 0  to DRListView_MailList.Items.Count -1 do
   begin
      if DRListView_MailList.items.Item[i].Selected then
      begin
         MailRcv := DRListView_MailList.Items.Item[i].Caption;
//         MailAddr := DRListView_MailList.Items.Item[i].SubItems.Text;
         break;
      end;
   end;

   //--- 수신처 등록
   iRtnValue := gf_ShowRegEmailAddr(MailRcv, MailAddr);

   Screen.Cursor := crHourGlass;
   if (iRtnValue = gcMR_INSERTED) or (iRtnValue = gcMR_MODIFIED) then
   begin
      if not BuildListViewAllMailAddr then
      begin
         Screen.Cursor := crDefault;
         exit;
      end;
      DisplayAllMailAddr;
      RefreshRcvTypeItem;
      DisplayRcvData(gcMAil_Rcv_type, DRListView_MailRcv);
      DisplayRcvData(gcCCMAil_Rcv_type, DRListView_CCMailRcv);
      DisplayRcvData(gcCCBlind_Rcv_type, DRListView_CCBlindMailRcv);
   end;
   Screen.Cursor := crDefault;
end;

//------------------------------------------------------------------------------
// 수신처 등록정보를 통해 지운 수신처 항목을 RcvType별로 Refresh해준다.
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.RefreshRcvTypeItem;
   function  SearchALLListItem(pSendSeq : string) : integer;
   var
      i  : integer;
      SUMELADItem : pTSUMELADData;
   begin
      Result := -1;
      for i := 0 to SUMELADList.Count -1 do
      begin
         SUMELADItem := SUMELADList.Items[i];

         if SUMELADItem.SendSeq = pSEndSeq then
         begin
            Result := i;
            exit;
         end;
      end;
   end;
var
    i, J, SearchIDx, NotExistCnt : integer;
    RcvTypeItem : pTRcvTypeData;
    SUMELADItem : pTSUMELADData;
begin
  inherited;

   SearchIDx   := -1;
   NotExistCnt := 0;
   for i := 0 to RcvTypeList.Count -1 do
   begin
      RcvtypeITem := RcvTypeList.Items[i];
      SearchIDx   := SearchALLListItem(RcvTypeITem.SendSeq);
      if SearChIdx < 0 then  //못찾았으면 지워야 함
      begin
         NotExistCnt := NotExistCnt + 1;
         RcvTypeITem.DelMod := true;
         Break;
      end;
      //찾았을 경우 수신처명이나 주소가 바꼈을 경우
      SUMELADItem := SUMELADList.Items[SearchIdx];
      RcvtypeITem.MailRcv := SUMELADItem.MailRcv;
   end;

   for i := 0 to NotExistCnt -1 do
   begin
      for j := 0 to RcvTypeList.Count -1 do
      begin
         RcvtypeItem := RcvTypeList.Items[J];
         if RcvTypeItem.DelMod  then
         begin
            Dispose(RcvTypeItem);
            RcvTypeList.Delete(J);
            Break;
         end;
      end;
   end;




end;



//------------------------------------------------------------------------------
// 전체 사용자   이메일 List
//------------------------------------------------------------------------------
function TDlgForm_SelectEmail.BuildListViewAllMailAddr: boolean;
var
   SUMELADItem : pTSUMELADData;
begin
   Result := false;
   ClearSUMELADList;

   with ADOQuery_MailList do
   begin
      Close;
      SQL.Clear;
      SQL.Add( '  SELECT RCV_COMP_KOR, MAIL_ADDR,   '
             + '         SEND_SEQ = CONVERT(CHAR, SEND_SEQ)  '
             + '  FROM   SUMELAD_TBL              '
             + '  WHERE  DEPT_CODE = ''' + gvDeptCode + ''' '
             + '  ORDER BY RCV_COMP_KOR                 ');
      Try
         gf_ADOQueryOpen(ADOQuery_MailList);
      Except  // DataBase 오류입니다.
         On E: Exception do
         begin
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_MailList[SUMELAD_TBL]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_MailList[SUMELAD_TBL]');
            Exit;
         end;
      End;

      while not Eof do
      begin
         new(SUMELADItem);
         SUMELADList.Add(SUMELADItem);

         SUMELADItem.SendSeq := Trim(fieldByName('SEND_SEQ').asString);
         SUMELADItem.MailRcv := Trim(FieldbyName('RCV_COMP_KOR').asString);
         SUMELADItem.MailAddr := Trim(FieldbyName('MAIL_ADDR').asString);

         next;
      end;
   end;
   SUMELADList.Sort(MailListCompare);
   Result := true;
end;

procedure TDlgForm_SelectEmail.DisplayAllMailAddr;
var
   SUMELADItem : pTSUMELADData;
   TmpItem : TListItem;
   i : integer;
begin

   DRListView_MailList.Items.Clear;
   for i := 0 to SUMELADList.count - 1 do
   begin
      SUMELADItem := SUMELADList.Items[i];

      TmpItem := DRListView_MailList.Items.Add;
      TmpItem.Caption := SUMELADItem.MailRcv;
      TmpItem.SubItems.Add(SUMELADItem.MailAddr);
   end;  // end of with

end;

//------------------------------------------------------------------------------
// Rcvtype별 수신처 이메일 List
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.DisplayRcvData(pRcvType: string; pListView: TDrListView);
var
   TmpItem : TListItem;
   RcvTypeItem : pTRcvTypeData;
   i, iListIDx : integer;
begin
   pListView.Items.Clear;
   iListIDx := -1;
   for i := 0 to RcvTypeList.Count -1 do
   begin
      RcvTypeITem := RcvtypeList.Items[i];

      if RcvtypeITem.RcvType = pRcvType then
      begin
         iListIdx := iListIdx + 1;
         TmpItem := pListview.Items.Add;
         TmpItem.Caption := RcvTypeItem.MailRcv;
         // 찾은 아이템을 강제로 선택시킴
         TmpItem.Selected := RcvTypeItem.Selected;
         TmpItem.MakeVisible(RcvTypeItem.Selected);
         pListView.SetFocus;
         //Clear;
         RcvTypeITem.ListViewIDx := iListIDx;
         RcvTypeItem.Selected := false;
      end;  // end of while
      pListView.Items.EndUpdate;
   end;

end;



//------------------------------------------------------------------------------
// Form Active 될때
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.FormActivate(Sender: TObject);
   procedure  ParamStrListToTmpItem(pStrList : TSTringList; pRcvType : string);
   var
      i  : integer;
      RcvTypeItem : pTRcvTypeData;
   begin
      for i := 0 to pStrList.Count -1 do
      begin
         New(RcvTypeItem);
         RcvTypeList.Add(RcvTypeITem);

         RcvTypeItem.ListViewIDx := i;
         RcvTypeItem.RcvType := pRcvType;
         RcvTypeItem.SendSeq := pStrList.Strings[i];
         RcvTypeItem.MailRcv := gf_SendSeqToRcvName(pStrList.Strings[i]);
         RcvTypeITem.DelMod   := false;
         RcvTypeITem.Selected := false;
      end;
   end;
begin
  inherited;
//  Display

  ClearRcvTypeList;
  ParamStrListToTmpItem(DefMailAddrList, gcMAIL_RCV_TYPE);
  ParamStrListToTmpItem(DEFCCMailAddrList, gcCCMAIL_RCV_TYPE);
  ParamStrListToTmpItem(DEFCCBlindAddrList, gcCCBlind_RCV_TYPE);

  DRLabel_Title.Caption := DefTitle;
  DisplayRcvData(gcMAil_Rcv_type, DRListView_MailRcv);
  DisplayRcvData(gcCCMAil_Rcv_type, DRListView_CCMailRcv);
  DisplayRcvData(gcCCBlind_Rcv_type, DRListView_CCBlindMailRcv);
  SeqPos := DefRcvType;

  gf_ShowMessage(MessageBar, mtInformation, 1103, ''); //수신처 정보를 입력하여 주십시오.


end;

//------------------------------------------------------------------------------
// 받는사람 ->
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.DRSpeedBtn_MailRcvClick(Sender: TObject);
var
  i,SearchIdx   : integer;
  SUMELADItem : pTSUMELADData;
  RcvTypeItem : pTRcvTypeData;
begin
   if DRListView_MailList.Selected  = nil then exit;
   gf_ClearMessage(MessageBar);
   SearchIDx := -1;
   for i := 0 to DRListView_MailList.Items.Count -1 do
   begin
      if  DRListView_MailList.items.Item[i].Selected then
      begin
         SUMELADITem := SUMELADList.Items[i];
         SearchIdx := SearchRcvTypeItem(gcMAIL_RCV_TYPE, SUMELADItem.SendSeq);
         if SearchIdx >= 0 then
         begin
            RcvTypeItem  := RcvTypeList.Items[SearchIdx];
            RcvTypeITem.Selected := true;
            continue;  //찾음
         end;
         New(RcvTypeItem);
         RcvTypeLIst.Add(RcvTypeItem);

         RcvTypeITem.ListViewIDx := -1;
         RcvTypeItem.SendSeq := SUMELADItem.SendSeq;
         RCVTypeITem.RcvType := gcMAIL_RCV_TYPE;
         RcvTypeItem.MailRcv := SUMELADItem.MailRcv;
         RcvTypeItem.DelMod  := false;
         RcvTypeItem.Selected := true;
         //Clear;
         DRListView_MailList.items.Item[i].Selected := false;
      end;
   end;
   DisplayRcvData(gcMAIL_RCV_TYPE,DRListView_MailRcv);
   DRListView_MailRcv.SetFocus;

   SeqPos := gcMAIL_RCV_TYPE;
end;



//------------------------------------------------------------------------------
// 기존 RCVType List SElection
//------------------------------------------------------------------------------
function TDlgForm_SelectEmail.SearchRcvTypeItem(pRcvType,pSendSeq : string): integer;
var
  i   : integer;
  RcvTypeItem : pTRcvTypeData;
begin
   Result := -1;

   for i:= 0 to RcvTypeList.Count -1 do
   begin
      RcvTypeITem := RcvTypeList.Items[i];

      if (RcvTypeITem.RcvType = pRcvType) and (RcvtypeItem.SendSeq = pSendSeq) then
      begin
         Result := i;
         exit;
      end;
   end;
//
end;



//------------------------------------------------------------------------------
// 참조 ->
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.DRSpeedBtn_CCMailRcvClick(Sender: TObject);
var
  i,SearchIdx   : integer;
  SUMELADItem : pTSUMELADData;
  RcvTypeItem : pTRcvTypeData;
begin
   if DRListView_MailList.Selected  = nil then exit;
   gf_ClearMessage(MessageBar);
   SearchIDx := -1;

   for i := 0 to DRListView_MailList.Items.Count -1 do
   begin
      if  DRListView_MailList.items.Item[i].Selected then
      begin
         SUMELADITem := SUMELADList.Items[i];
         SearchIdx := SearchRcvTypeItem(gcCCMAIL_RCV_TYPE, SUMELADItem.SendSeq);
         if SearchIdx >= 0 then
         begin
            RcvTypeItem  := RcvTypeList.Items[SearchIdx];
            RcvTypeITem.Selected := true;
            continue;  //찾음
         end;
         New(RcvTypeItem);
         RcvTypeLIst.Add(RcvTypeItem);

         RcvTypeITem.ListViewIDx := -1;
         RcvTypeItem.SendSeq := SUMELADItem.SendSeq;
         RCVTypeITem.RcvType := gcCCMAIL_RCV_TYPE;
         RcvTypeItem.MailRcv := SUMELADItem.MailRcv;
         RcvTypeItem.DelMod  := false;
         RcvTypeItem.Selected := true;
         //Clear;
         DRListView_MailList.items.Item[i].Selected := false;
      end;
   end;
   DisplayRcvData(gcCCMAIL_RCV_TYPE,DRListView_CCMailRcv);
   DRListView_CCMailRcv.SetFocus;
   SeqPos := gcCCMAIL_RCV_TYPE;
end;

//------------------------------------------------------------------------------
// 숨은참조 ->
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.DRSpeedBtn_CCBlindMailRcvClick(Sender: TObject);
var
  i,SearchIdx   : integer;
  SUMELADItem : pTSUMELADData;
  RcvTypeItem : pTRcvTypeData;
begin
   if DRListView_MailList.Selected  = nil then exit;
   gf_ClearMessage(MessageBar);
   SearchIDx := -1;

   for i := 0 to DRListView_MailList.Items.Count -1 do
   begin
      if  DRListView_MailList.items.Item[i].Selected then
      begin
         SUMELADITem := SUMELADList.Items[i];
         SearchIdx := SearchRcvTypeItem(gcCCBLIND_RCV_TYPE, SUMELADItem.SendSeq);
         if SearchIdx >= 0 then
         begin
            RcvTypeItem  := RcvTypeList.Items[SearchIdx];
            RcvTypeITem.Selected := true;
            continue;  //찾음
         end;
         New(RcvTypeItem);
         RcvTypeLIst.Add(RcvTypeItem);

         RcvTypeITem.ListViewIDx := -1;
         RcvTypeItem.SendSeq := SUMELADItem.SendSeq;
         RCVTypeITem.RcvType := gcCCBLIND_RCV_TYPE;
         RcvTypeItem.MailRcv := SUMELADItem.MailRcv;
         RcvTypeItem.DelMod  := false;
         RcvTypeItem.Selected := true;
         //Clear;
         DRListView_MailList.items.Item[i].Selected := false;
      end;
   end;
   DisplayRcvData(gcCCBLIND_RCV_TYPE,DRListView_CCBlindMailRcv);
   DRListView_CCBlindMailRcv.SetFocus;
   SeqPos := gcCCBLIND_RCV_TYPE;
end;

//------------------------------------------------------------------------------
// 조회
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.DRBitBtn3Click(Sender: TObject);
begin
  inherited;
  DisableForm;
  if not BuildListViewAllMailAddr then
  begin
     EnableForm;
     Exit;  //전체 수신처 주소
  end;
  DisplayAllMailAddr;
  EnableForm;
  FormActivate(nil);
  gf_ShowMessage(MessageBar, mtInformation, 1021, ''); // 조회 완료

end;

//------------------------------------------------------------------------------
// 적용
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.DRBitBtn2Click(Sender: TObject);
var
   i : integer;
   RcvTypeITem : pTRcvTypeData;
begin
  inherited;
{
  if RcvTypeList.Count <= 0 then
  begin
      gf_ShowMessage(MessageBar, mtError, 1103, ''); //수신처 정보를 입력하여 주십시오.
      Exit;
  end;
}
  DefMailAddrList.Clear;
  DefCCMailAddrList.Clear;
  DefCCBlindAddrList.Clear;
  DisableForm;
  for i := 0 to RcvTypeList.Count -1 do
  begin
     RcvTypeITem := RcvTypeList.Items[i];
     if RcvTypeItem.RcvType = gcMail_Rcv_Type then
        DefMailAddrList.Add(RcvTypeItem.Sendseq)
     else if RcvTypeItem.RcvType = gcCCMail_Rcv_Type then
        DefCCMailAddrList.Add(RcvTypeItem.Sendseq)
     else
        DefCCBlindAddrList.Add(RcvTypeItem.Sendseq);
  end;
  enableform;
   gf_ShowMessage(MessageBar, mtInformation, 1116, ''); //적용 완료
end;

//------------------------------------------------------------------------------
// 전체 -> 해당 수신처로 move
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.DRListView_MailListDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;

  if  Source = DRListView_MailRcv then
  begin
     SeqPos := gcMAIL_RCV_TYPE;
     Accept := True;
  end else
  if Source = DRListView_CCMailRcv then
  begin
     SeqPos := gcCCMAIL_RCV_TYPE;
     Accept := True;
  end else
  if Source = DRListView_CCBlindMailRcv then
  begin
     SeqPos := gcCCBLIND_RCV_TYPE;
     Accept := True;
  end else
     Accept := False;

end;

//------------------------------------------------------------------------------
// 해당 수신처에서 삭제
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.DRListView_MailListDragDrop(Sender,
  Source: TObject; X, Y: Integer);
begin
  inherited;
  if  SeqPos = gcMAIL_RCV_TYPE then
  begin
     MenuItem_DelJobMailClick(nil);
  end else
  if SeqPos = gcCCMAIL_RCV_TYPE then
  begin
     MenuItem_DelJobCCClick(nil);
  end else
  begin
     MenuItem_DelJobBlindClick(nil);
  end;

end;

//------------------------------------------------------------------------------
// 수신처  btn
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.DRListView_MailRcvDragDrop(Sender,
  Source: TObject; X, Y: Integer);
begin
  inherited;
   DRSpeedBtn_MailRcvClick(nil);
end;

//------------------------------------------------------------------------------
// 참조  btn
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.DRListView_CCMailRcvDragDrop(Sender,
  Source: TObject; X, Y: Integer);
begin
  inherited;
   DRSpeedBtn_CCMailRcvClick(nil);
end;

//------------------------------------------------------------------------------
// 숨은참조 btn
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.DRListView_CCBlindMailRcvDragDrop(Sender,
  Source: TObject; X, Y: Integer);
begin
  inherited;
   DRSpeedBtn_CCBlindMailRcvClick(nil);
end;


//------------------------------------------------------------------------------
// dblClick
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.DRListView_MailListDblClick(Sender: TObject);
begin
  inherited;
  if SeqPos = gcMAIL_RCV_TYPE then
      DRSpeedBtn_MailRcvClick(nil)
  else if SeqPos = gcCCMAIL_RCV_TYPE then
      DRSpeedBtn_CCMailRcvClick(nil)
  else if SeqPos = gcCCBLIND_RCV_TYPE then
      DRSpeedBtn_CCBlindMailRcvClick(nil);
//
end;

//------------------------------------------------------------------------------
// Drag  시작
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.DRListView_MailListMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
   ScreenP : TPoint;
begin
  inherited;
   if Button = mbLeft then  { 왼쪽버튼을 눌렀을 때만 Drag시작 }
   DRListView_MailList.BeginDrag(false)
   else if Button = mbRight then
   begin
      GetCursorPos(ScreenP);
      PopupMenuAllMailList.Popup(ScreenP.X, ScreenP.Y);
   end;
end;

procedure TDlgForm_SelectEmail.DRListView_MailRcvDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  if  Source = DRListView_MailList then
     Accept := True
   else
     Accept := False;
end;


//------------------------------------------------------------------------------
// Sorting
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.DRListView_MailListColumnClick(
  Sender: TObject; Column: TListColumn);
var
  ACol : integer;
begin
  inherited;
   ACol := Column.Index;

   Screen.Cursor := crHourGlass;
   SortIdx := ACol;
   SortFlag[ACol] := not SortFlag[ACol];
   SUMELADList.Sort(MailListCompare);
   DisplayAllMailAddr;
   Screen.Cursor := crDefault;
end;


//------------------------------------------------------------------------------
// Popup창[제거] 뛰우기
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.DRListView_MailRcvMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   ScreenP : TPoint;
begin
  inherited;
   if DRListView_MailRcv.Selected = nil then exit;
   if Button = mbLeft then  { 왼쪽버튼을 눌렀을 때만 Drag시작 }
      DRListView_MailRcv.BeginDrag(false)
   else if Button = mbRight then
   begin
      GetCursorPos(ScreenP);
      PopupMenuMailRcv.Popup(ScreenP.X, ScreenP.Y);
   end;
end;

procedure TDlgForm_SelectEmail.DRListView_CCMailRcvMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
var
   ScreenP : TPoint;
begin
  inherited;
   if DRListView_CCMailRcv.Selected = nil then exit;
   if Button = mbLeft then  { 왼쪽버튼을 눌렀을 때만 Drag시작 }
      DRListView_CCMailRcv.BeginDrag(false)
   else if Button = mbRight then
   begin
      GetCursorPos(ScreenP);
      PopupMenuCCMailRcv.Popup(ScreenP.X, ScreenP.Y);
   end;
end;

procedure TDlgForm_SelectEmail.DRListView_CCBlindMailRcvMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   ScreenP : TPoint;
begin
  inherited;
   if DRListView_CCBlindMailRcv.Selected = nil then exit;
   if Button = mbLeft then  { 왼쪽버튼을 눌렀을 때만 Drag시작 }
      DRListView_CCBlindMailRcv.BeginDrag(false)
   else if Button = mbRight then
   begin
      GetCursorPos(ScreenP);
      PopupMenuCCBlindRcv.Popup(ScreenP.X, ScreenP.Y);
   end;
end;

//------------------------------------------------------------------------------
// 해당 수신처에서 PupUp메뉴로 제거한다.
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.MenuItem_DelJobMailClick(Sender: TObject);
begin
  inherited;
  ListDelJob(gcMAil_Rcv_Type, DRListView_MailRcv);
  DisplayRcvData(gcMAIL_RCV_TYPE, DRListView_MailRcv);

end;

procedure TDlgForm_SelectEmail.MenuItem_DelJobCCClick(Sender: TObject);
begin
  inherited;
  ListDelJob(gcCCMAil_Rcv_Type, DRListView_CCMailRcv);
  DisplayRcvData(gcCCMAil_Rcv_Type, DRListView_CCMailRcv);
end;

procedure TDlgForm_SelectEmail.MenuItem_DelJobBlindClick(Sender: TObject);
begin
  inherited;
  ListDelJob(gcCCBLIND_RCV_TYPE, DRListView_CCBlindMailRcv);
  DisplayRcvData(gcCCBLIND_RCV_TYPE, DRListView_CCBlindMailRcv);
end;

procedure TDlgForm_SelectEmail.ListDelJob(pRcvtype: string; pListView: TDrListView);
var
   i,j,iListIdx : integer;
   RcvTypeItem : pTRcvTypeData;
   DelCnt : integer;
begin
  DelCnt := 0;
  iListIdx := 0;
  for i := 0 to pListView.Items.Count -1 do
  begin
     iListIdx := i;
     if  pListView.Items[i].Selected then
     begin
        for j := 0 to RcvTypeList.Count -1 do
        begin
           RcvtypeItem := RcvTypeList.Items[j];

           if (RcvTypeItem.RcvType = pRcvType) and
              (RcvTypeItem.ListViewIDx = iListIdx) then
           begin
              DelCnt := DelCnt + 1;
              RcvTypeItem.DelMod := true;
              Break;
           end;
        end;
     end;
  end;

  for i := 0 to DelCnt -1 do
  begin
     for j := 0 to RcvTypeList.Count -1 do
     begin
        RcvtypeItem := RcvTypeList.Items[J];
        if (RcvTypeItem.DelMod) and  (RcvTypeItem.RcvType = pRcvType) then
        begin
           Dispose(RcvTypeItem);
           RcvTypeList.Delete(J);
           Break;
        end;
     end;
  end;
end;


//------------------------------------------------------------------------------
// Delete Key로 수신처를 삭제할 수 있다.
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.DRListView_MailRcvKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
   if Key = VK_DELETE then  //DeleteKey
      MenuItem_DelJobMailClick(nil);
end;
procedure TDlgForm_SelectEmail.DRListView_MailRcvKeyPress(Sender: TObject;
  var Key: Char);
var
   i : integer;
begin
  inherited;
   if Key = CtrlA then
   begin
      for i := 0 to  DRListView_MailRcv.Items.Count -1 do
         DRListView_MailRcv.Items.Item[i].Selected := true;
   end;
end;

//------------------------------------------------------------------------------
// Delete Key로 참조 수신처를 삭제할 수 있다.
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.DRListView_CCMailRcvKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
   if Key = VK_DELETE then  //DeleteKey
      MenuItem_DelJobCCClick(nil);
end;
procedure TDlgForm_SelectEmail.DRListView_CCMailRcvKeyPress(
  Sender: TObject; var Key: Char);
var
   i : integer;
begin
  inherited;
   if Key = CtrlA then
   begin
      for i := 0 to  DRListView_CCMailRcv.Items.Count -1 do
         DRListView_CCMailRcv.Items.Item[i].Selected := true;
   end;
end;



//------------------------------------------------------------------------------
// Delete Key로 숨은참조 수신처를 삭제할 수 있다.
//------------------------------------------------------------------------------
procedure TDlgForm_SelectEmail.DRListView_CCBlindMailRcvKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
   if Key = VK_DELETE then  //DeleteKey
      MenuItem_DelJobBlindClick(nil);
end;

procedure TDlgForm_SelectEmail.DRListView_CCBlindMailRcvKeyPress(
  Sender: TObject; var Key: Char);
var
   i : integer;
begin
  inherited;
   if Key = CtrlA then
   begin
      for i := 0 to  DRListView_CCBlindMailRcv.Items.Count -1 do
         DRListView_CCBlindMailRcv.Items.Item[i].Selected := true;
   end;
end;


end.
