//==============================================================================
//   [LMS] 2001/02/12
//==============================================================================

unit SCCUserToolBar;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCCDlgForm, StdCtrls, Buttons, DRAdditional, ExtCtrls, DRStandard,
  DRSpecial, DRCodeControl, Grids, DRStringgrid, IniFiles, Menus, Db, ADODB,
  DRDialogs;

type
  TDlgForm_UserToolBar = class(TForm_Dlg)
    DRFramePanel1: TDRFramePanel;
    DRFramePanel2: TDRFramePanel;
    DRLabel1: TDRLabel;
    DRSecTypeCombo1: TDRSecTypeCombo;
    DRLabel2: TDRLabel;
    DRLabel3: TDRLabel;
    DRStrGrid_UserMenu: TDRStringGrid;
    DRStrGrid_AllMenu: TDRStringGrid;
    DRPopupMenu_Property: TDRPopupMenu;
    MenuItem_Property: TMenuItem;
    ADOQuery_Main: TADOQuery;
    procedure ClearToolBarList(pList: TList);
    procedure CopyToolBarList(pSrcList: TList; var pDesList: TList);
    procedure DeleteUserMenu(iDeleteIdx: Integer);
    procedure InsertUserMenu(iTrCode, iInsertIdx: Integer);
    procedure DisplayAllMenuList;
    procedure DisplayUserMenuList;
    procedure FormCreate(Sender: TObject);
    procedure DRSecTypeCombo1CodeChange(Sender: TObject);
    procedure DRStrGrid_UserMenuDrawCell(Sender: TObject; ACol,
      ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure DRStrGrid_MenuMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DRStrGrid_AllMenuSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure DRStrGrid_UserMenuSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure DRStrGrid_AllMenuDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure DRStrGrid_UserMenuDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure DRStrGrid_UserMenuDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure DRStrGrid_AllMenuDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure DRBitBtn3Click(Sender: TObject);
    procedure DRBitBtn2Click(Sender: TObject);
    procedure DRBitBtn1Click(Sender: TObject);
    procedure MenuItem_PropertyClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DlgForm_UserToolBar: TDlgForm_UserToolBar;

implementation

{$R *.DFM}

uses
   SCCGlobalType, SCCLib, SCCDataModule;

const
   DEF_IMAGE_IDX = 0;

var
   TmpToolBarList : TList;
   CurBtnInfoList : TList;
   AllMenuRowIdx, UserMenuRowIdx : Integer;

procedure TDlgForm_UserToolBar.FormCreate(Sender: TObject);
begin
  inherited;
   // Create TmpToolBarList
   TmpToolBarList := TList.Create;
   if not Assigned(TmpToolBarList) then
   begin
      gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); // List ���� ����
      Close;
      Exit;
   end;

   // Copy gvUsrToolBarList to TmpToolBarList
   CopyToolBarList(gvUsrToolBarList, TmpToolBarList);

   DRSecTypeCombo1.AssignCode(gvCurSecType);   // ���� ������� ����
   DRSecTypeCombo1CodeChange(DRSecTypeCombo1); // �ش� ������ Display �� ó��
end;

procedure TDlgForm_UserToolBar.DRSecTypeCombo1CodeChange(Sender: TObject);
var
   I : Integer;
   ToolItem : pTUserToolBar;
begin
  inherited;
   CurBtnInfoList := nil;      // �������� ���� BtnInfoList
   for I := 0 to TmpToolBarList.Count -1 do
   begin
      ToolItem := TmpToolBarList.Items[I];
      if ToolItem.SecType = DRSecTypeCombo1.Code then
         CurBtnInfoList := ToolItem.BtnInfoList;
   end;  // end of for

   if not Assigned(CurBtnInfoList) then
   begin   // List ���� ����
      gf_ShowErrDlgMessage(Self.Tag, 9004, '(' + DRSecTypeCombo1.CodeName + ')', 0);
      Close;
      Exit;
   end;

   DisplayAllMenuList;   // Display �޴�����Ʈ
   DisplayUserMenuList;  // Display ��������Ǹ���Ʈ
end;

//------------------------------------------------------------------------------
//  Display AllMenuList
//------------------------------------------------------------------------------
procedure TDlgForm_UserToolBar.DisplayAllMenuList;
var
   I, iTotCnt, iRow : Integer;
   MenuItem : pTMenuInfo;
begin
   with DRStrGrid_AllMenu do
   begin
      iTotCnt := 0;
      for I := 0 to gvMenuList.Count -1 do
      begin
         MenuItem := gvMenuList.Items[I];
         if ((MenuItem.SecCode = DRSecTypeCombo1.Code) or (MenuItem.SecCode = 'C')) // ���þ��� or �������
         and (MenuItem.MenuType = 'B') then  // BizMenu
            Inc(iTotCnt);
      end;  // end of for

      if iTotCnt > 0 then   // Data �����
      begin
         RowCount := iTotCnt;
         iRow := 0;
         for I := 0 to gvMenuList.Count -1 do
         begin
            MenuItem := gvMenuList.Items[I];
            if ((MenuItem.SecCode = DRSecTypeCombo1.Code) or (MenuItem.SecCode = 'C')) // ���þ��� or �������
            and (MenuItem.MenuType = 'B') then  // BizMenu
            begin
                Cells[0, iRow] := '[' +  MenuItem.TrCode + '] ' + MenuItem.MenuName;
                Inc(iRow);
            end;
         end;  // end of for
      end
      else
      begin
         RowCount := 1;
         Rows[0].Clear;
      end;
   end;  // end of with
end;

//------------------------------------------------------------------------------
//  Display UserMenuList
//------------------------------------------------------------------------------
procedure TDlgForm_UserToolBar.DisplayUserMenuList;
var
   I : Integer;
   BtnItem  : pTBtnInfo;
   sFullName, sShrtName : string;
begin
   with DRStrGrid_UserMenu do
   begin
      if CurBtnInfoList.Count > 0 then   // Data �����
      begin
         RowCount := CurBtnInfoList.Count;
         for I := 0 to CurBtnInfoList.Count -1 do
         begin
            BtnItem := CurBtnInfoList.Items[I];
            gf_TrCodeToMenuName(BtnItem.TrCode, sFullName, sShrtName);
            Cells[0, I] := sFullName;
         end;  // end of for
      end
      else
      begin
         RowCount := 1;
         Rows[0].Clear;
      end;
   end;  // end of with
end;

//------------------------------------------------------------------------------
//  Icon ���
//------------------------------------------------------------------------------
procedure TDlgForm_UserToolBar.DRStrGrid_UserMenuDrawCell(Sender: TObject;
                       ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
   sText : string;
   BtnItem : pTBtnInfo;
   Image : TBitmap;
   SRect, DRect : TRect;
   iLeft, iTop : Integer;
begin
  inherited;
   with (Sender as TDRStringGrid).Canvas do
   begin
      sText:= (Sender as TDRStringGrid).Cells[ACol, ARow];
      FillRect(Rect);

      Image := TBitmap.Create;
      if Trim(sText) <> '' then  // Get Menu Image
      begin
         if Assigned(CurBtnInfoList) then
         begin
            BtnItem := CurBtnInfoList.Items[ARow];
            if (BtnItem.ImageIdx >= 0) and
               (BtnItem.ImageIdx < DataModule_SettleNet.DRImageList_User.Count) then
            begin
               DataModule_SettleNet.DRImageList_User.GetBitmap(BtnItem.ImageIdx, Image);
            end;
         end;
      end;

      // Display Text
      iTop  := (Rect.Bottom - Rect.Top - TextHeight(sText)) div 2 + Rect.Top;
      iLeft := Rect.Left + Image.Width + 10;
      TextRect(Rect, iLeft, iTop, sText);

      if Image.Width > 0 then  // Display Menu Image
      begin
         SRect := Classes.Rect(0, 0, Image.Width, Image.Height);
         DRect.Left   := iLeft - Image.Width -2;
         DRect.Top    := Rect.Top + (Rect.Bottom - Rect.Top - Image.Height) div 2;
         DRect.Right  := DRect.Left + SRect.Right + 1;
         DRect.Bottom := DRect.Top + SRect.Bottom + 1;
         if DRect.Left >= (Rect.Left - (Image.Width div 4)) then
            BrushCopy(DRect, Image, SRect, clOlive);
      end;
      Image.Free;
   end;   // end of with
end;

procedure TDlgForm_UserToolBar.DRStrGrid_MenuMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   ACol, ARow : Integer;
   ScreenP : TPoint;
begin
  inherited;
   with (Sender as TDRStringGrid) do
   begin
      MouseToCell(X, Y, ACol, ARow);
      if (ARow < FixedRows) or (ARow > RowCount-1) then Exit;
      if Trim(Cells[0, ARow]) = '' then Exit;  // Data ���� ���

      if Button = mbLeft then  // Drag
         BeginDrag(False)

      else if Button = mbRight then
      begin
         // ��������� �ʾ��޴�
         if Name = 'DRStrGrid_UserMenu' then
         begin
            gf_SelectStrGridRow((Sender as TDRStringGrid), ARow);
            GetCursorPos(ScreenP);
            DRPopupMenu_Property.Popup(ScreenP.X, ScreenP.Y);
         end;
      end;  // end of else if
   end;  // end of with
end;

procedure TDlgForm_UserToolBar.DRStrGrid_AllMenuSelectCell(Sender: TObject;
                                   ACol, ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
   AllMenuRowIdx := ARow;
end;

procedure TDlgForm_UserToolBar.DRStrGrid_UserMenuSelectCell(
                  Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
   UserMenuRowIdx := ARow;
end;

procedure TDlgForm_UserToolBar.DRStrGrid_AllMenuDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
   if (Source as TDRStringGrid).Name = 'DRStrGrid_UserMenu' then
      Accept := True
   else
      Accept := False;
end;

procedure TDlgForm_UserToolBar.DRStrGrid_UserMenuDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
   if ((Source as TDRStringGrid).Name = 'DRStrGrid_AllMenu') or
      ((Source as TDRStringGrid).Name = 'DRStrGrid_UserMenu') then
      Accept := True
   else
      Accept := False;
end;

//------------------------------------------------------------------------------
//  �����׸��� ����ڸ޴�����Ʈ �߰� or ��ġ ����
//------------------------------------------------------------------------------
procedure TDlgForm_UserToolBar.DRStrGrid_UserMenuDragDrop(Sender,
                                                Source: TObject; X, Y: Integer);
var
   ACol, ARow : Integer;
   sTrCode : string;
begin
  inherited;
   with (Sender as TDRStringGrid) do
   begin
      MouseToCell(X, Y, ACol, ARow);

      //--- �׸� �߰�
      if (Source as TDRStringGrid).Name = 'DRStrGrid_AllMenu' then
      begin
         sTrCode := copy((Source as TDRStringGrid).Cells[0, AllMenuRowIdx], 2, 4);
         if (ARow >= FixedRows) and (ARow <= RowCount-1) then
            InsertUserMenu(StrToIntDef(sTrCode, 0), ARow)
         else
         begin
            if CurBtnInfoList.Count <= 0 then
               InsertUserMenu(StrToIntDef(sTrCode, 0), 0)
            else
               InsertUserMenu(StrToIntDef(sTrCode, 0), RowCount);
         end;
      end
      else  //--- DRStrGrid_UserMenu ��ü �̵�
      begin
         if ARow < 0 then
            CurBtnInfoList.Move(UserMenuRowIdx, RowCount-1)
         else
            CurBtnInfoList.Move(UserMenuRowIdx, ARow);
      end;
   end;  // end of with
   DisplayUserMenuList;
end;

//------------------------------------------------------------------------------
//  �����׸��� ����ڸ޴�����Ʈ ����
//------------------------------------------------------------------------------
procedure TDlgForm_UserToolBar.DRStrGrid_AllMenuDragDrop(Sender,
                                                Source: TObject; X, Y: Integer);
begin
  inherited;
   DeleteUserMenu(UserMenuRowIdx);
   DisplayUserMenuList;
end;

//------------------------------------------------------------------------------
//  ��������� BtnInfoList�� �߰�
//------------------------------------------------------------------------------
Procedure TDlgForm_UserToolBar.InsertUserMenu(iTrCode, iInsertIdx: Integer);
var
   BtnItem : pTBtnInfo;
   I : Integer;
begin
   gf_ClearMessage(MessageBar);
   if iTrCode <= 0 then Exit;

   if CurBtnInfoList.Count >= gcMAX_USER_TOOLBTN then  // ��� �ѵ� �ʰ�
   begin
      gf_ShowMessage(MessageBar, mtError, 1138,
                     '(' + IntToStr(gcMAX_USER_TOOLBTN) + '��)');; //��� ���� ���� �ʰ�
      Exit;
   end;

   // ������ ��ϵǾ� �ִ��� Ȯ��
   for I := 0 to CurBtnInfoList.Count -1 do
   begin
      BtnItem := CurBtnInfoList.Items[I];
      if BtnItem.TrCode = iTrCode then
      begin
         gf_SelectStrGridRow(DRStrGrid_UserMenu, I);
         Exit;
      end;
   end;  // end of for

   New(BtnItem);
   CurBtnInfoList.Insert(iInsertIdx, BtnItem);
   BtnItem.TrCode   := iTrCode;
   BtnItem.ImageIdx := DEF_IMAGE_IDX;
   gf_SelectStrGridRow(DRStrGrid_UserMenu, iInsertIdx);
end;

//------------------------------------------------------------------------------
//  �ش� Index Item�� ��������� BtnInfoList�� ����
//------------------------------------------------------------------------------
procedure TDlgForm_UserToolBar.DeleteUserMenu(iDeleteIdx: Integer);
begin
   if (iDeleteIdx >= 0) and
      (iDeleteIdx < CurBtnInfoList.Count) then
   begin
      CurBtnInfoList.Delete(iDeleteIdx);
   end;
end;

//------------------------------------------------------------------------------
//  Ȯ�ι�ư Ŭ��
//------------------------------------------------------------------------------
procedure TDlgForm_UserToolBar.DRBitBtn3Click(Sender: TObject);
var
   I, K : Integer;
   ToolItem : pTUserToolBar;
   BtnItem  : pTBtnInfo;
begin
  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1015, '');  // ó�� ���Դϴ�.
   Screen.Cursor := crHourGlass;

   // SUUSRTB_TBL ����
   with ADOQuery_Main do
   begin
      Try
         gf_BeginTransaction;

         // ���� ��ϵ� ������ ����
         Close;
         SQL.Clear;
         SQL.Add(' Delete SUUSRTB_TBL '
               + ' Where USER_ID = ''' + gvOprUsrNo + ''' ');
         gf_ADOExecSQL(ADOQuery_Main);

         // ������ ��������� �޴� �߰�
         Close;
         SQL.Clear;
         SQL.Add('Insert SUUSRTB_TBL '
               + '( USER_ID, SEC_TYPE, SEQ_NO, TR_CODE, IMAGE_IDX, '
               + '  OPR_ID, OPR_DATE, OPR_TIME ) Values '
               + '( :pUserId, :pSecType, :pSeqNo, :pTrCode, :pImageIdx, '
               + '  :pOprId, :pOprDate, :pOprTime) ');
         for I := 0 to TmpToolBarList.Count -1 do
         begin
            ToolItem := TmpToolBarList.Items[I];
            if ToolItem.BtnInfoList.Count <= 0 then Continue;

            for K := 0 to ToolItem.BtnInfoList.Count -1 do
            begin
               BtnItem := ToolItem.BtnInfoList.Items[K];
               Close;
               Parameters.ParamByName('pUserId').Value   := gvOprUsrNo;
               Parameters.ParamByName('pSecType').Value  := ToolItem.SecType;
               Parameters.ParamByName('pSeqNo').Value    := (K + 1);
               Parameters.ParamByName('pTrCode').Value   := IntToStr(BtnItem.TrCode);
               Parameters.ParamByName('pImageIdx').Value := BtnItem.ImageIdx;
               Parameters.ParamByName('pOprID').Value    := gvOprUsrNo;
               Parameters.ParamByName('pOprDate').Value  := gvCurDate;
               Parameters.ParamByName('pOprTime').Value  := gf_GetCurTime;
               gf_ADOExecSQL(ADOQuery_Main);
            end;  // end of for
         end;  // end of for I

         gf_CommitTransaction;
      Except
         on E: Exception do
         begin
            gf_RollbackTransaction;
            gf_ShowErrDlgMessage(Self.Tag, 9001, E.Message, 0);  //Database ����
            gf_ShowMessage(MessageBar, mtError, 1017, '');       // ó�� �� ���� �߻�
         end;
      End;
   end;  // end of with

   CopyToolBarList(TmpToolBarList, gvUsrToolBarList);       // ���� ���� ����

   gf_ResetUserToolBar;  // ��������� ToolBar �籸��

   Screen.Cursor := crDefault;
   gf_ShowMessage(MessageBar, mtInformation, 1016, '');  // ó�� �Ϸ�
end;

//------------------------------------------------------------------------------
//  ��ҹ�ư Ŭ��
//------------------------------------------------------------------------------
procedure TDlgForm_UserToolBar.DRBitBtn2Click(Sender: TObject);
begin
  inherited;
   gf_ClearMessage(MessageBar);
   Screen.Cursor := crHourGlass;

   CopyToolBarList(gvUsrToolBarList, TmpToolBarList);  // ���������� ����

   DRSecTypeCombo1CodeChange(DRSecTypeCombo1);      // Redisplay

   Screen.Cursor := crDefault;
   gf_ShowMessage(MessageBar, mtInformation, 1082, '');  // �۾��� ��ҵǾ����ϴ�.
end;

//------------------------------------------------------------------------------
//  �����ư Ŭ��
//------------------------------------------------------------------------------
procedure TDlgForm_UserToolBar.DRBitBtn1Click(Sender: TObject);
begin
  inherited;
   Close;
end;

//------------------------------------------------------------------------------
//  Copy ToolBarList pSrtList to pDesList
//------------------------------------------------------------------------------
procedure TDlgForm_UserToolBar.CopyToolBarList(pSrcList: TList; var pDesList: TList);
var
   I, K : Integer;
   SToolItem, DToolItem : pTUserToolBar;
   SBtnItem, DBtnItem : pTBtnInfo;
begin
   ClearToolBarList(pDesList);  // Clear pDesList

   // Copy pSrcList to pDesList
   for I := 0 to pSrcList.Count -1 do
   begin
      SToolItem := pSrcList.Items[I];
      New(DToolItem);
      pDesList.Add(DToolItem);
      DToolItem.SecType := SToolItem.SecType;
      DToolItem.BtnInfoList := TList.Create;
      for K := 0 to SToolItem.BtnInfoList.Count -1 do
      begin
         SBtnItem := SToolItem.BtnInfoList.Items[K];
         New(DBtnItem);
         DToolItem.BtnInfoList.Add(DBtnItem);
         DBtnItem.TrCode   := SBtnItem.TrCode;
         DBtnItem.ImageIdx := SBtnItem.ImageIdx;
      end;  // end of for K
   end;  // end of for I
end;

//------------------------------------------------------------------------------
// ICON ����
//------------------------------------------------------------------------------
procedure TDlgForm_UserToolBar.MenuItem_PropertyClick(Sender: TObject);
var
   ScreenP : TPoint;
   BtnItem : pTBtnInfo;
begin
  inherited;
   BtnItem := CurBtnInfoList.Items[UserMenuRowIdx];
   GetCursorPos(ScreenP);
   BtnItem.ImageIdx := gf_ShowIconDlg(ScreenP.x, ScreenP.y, BtnItem.ImageIdx);
   DRStrGrid_UserMenu.Repaint;
end;

//------------------------------------------------------------------------------
// Clear ToolBarList
//------------------------------------------------------------------------------
procedure TDlgForm_UserToolBar.ClearToolBarList(pList: TList);
var
   I, K : Integer;
   ToolItem : pTUserToolBar;
   BtnItem  : pTBtnInfo;
begin
   for I := 0 to pList.Count -1 do
   begin
      ToolItem := pList.Items[I];
      if Assigned(ToolItem.BtnInfoList) then
      begin
         for K := 0 to ToolItem.BtnInfoList.Count -1 do
         begin
            BtnItem := ToolItem.BtnInfoList.Items[K];
            Dispose(BtnItem);
         end;  // end of for K
         ToolItem.BtnInfoList.Free;
      end;  // end of if
      Dispose(ToolItem);
   end;  // end of for
   pList.Clear;
end;

procedure TDlgForm_UserToolBar.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
   if Assigned(TmpToolBarList) then
   begin
      ClearToolBarList(TmpToolBarList);
      TmpToolBarList.Free;
   end;
end;

end.
