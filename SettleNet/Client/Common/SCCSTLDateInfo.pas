unit SCCSTLDateInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SCCDlgForm, DB, ADODB, StdCtrls, DRStandard, Mask, DRAdditional,
  DRDialogs, Buttons, ExtCtrls, DRSpecial;

type
  TForm_Dlg_STLDate = class(TForm_Dlg)
    DRPanel_Title: TDRPanel;
    DRPanel1: TDRPanel;
    DRGroupBox_mandaRtoRry: TDRGroupBox;
    DRLabel1: TDRLabel;
    DRLabel2: TDRLabel;
    DRLabel10: TDRLabel;
    DRLabel65: TDRLabel;
    DRMaskEdit_TRADEDate: TDRMaskEdit;
    DRMaskEdit_STLDate: TDRMaskEdit;
    DRMaskEdit_BUYDate: TDRMaskEdit;
    DRMaskEdit_SELDate: TDRMaskEdit;
    DRLabel4: TDRLabel;
    DREdit_OprID: TDREdit;
    DRLabel5: TDRLabel;
    DREdit_OprTime: TDREdit;
    ADOQuery_SUSTLDT: TADOQuery;
    ADOQuery_SUSTLDT_Insert: TADOQuery;
    ADOQuery_SETRADE_Update: TADOQuery;

    procedure FormCreate(Sender: TObject);
    procedure DRMaskEdit_TRADEDateKeyPress(Sender: TObject; var Key: Char);

    procedure DRBitBtn3Click(Sender: TObject);    //��ȸ
    procedure DRBitBtn2Click(Sender: TObject);
    procedure DRMaskEdit_DateKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);    //����
  private
    { Private declarations }
  public
    { Public declarations }
    IsInsert : Boolean;  // [Insert : TRUE, Update : FALSE]
    IsUpdate : Boolean;  // [Update : TRUE, NoUpdate : FALSE]

    function  GetSTLDate(pTRDate:String) : Boolean;  //��ȸ

    function  InsertSTLData : Boolean;               //�Է�
    function  UpdateSTLData : Boolean;               //����

    procedure InsertParamData;                       //�Է�&������ �Ķ���Ͱ�
    function  IsValidData  : Boolean;                //����Ÿ ��ȿ��
    function  GetTradeData : Boolean;                //���۾� ������ ��ȿ

  end;

var
  Form_Dlg_STLDate: TForm_Dlg_STLDate;

implementation

uses SCCDataModule, SCCLib, SCCGlobalType;

{$R *.dfm}

//******************************************************************************
//***  ���ó�¥ ���� �������� ��ȸ�̵�
//***  Create
//******************************************************************************
procedure TForm_Dlg_STLDate.FormCreate(Sender: TObject);
begin
  inherited;
   DRMaskEdit_TRADEDate.Clear;
   DRMaskEdit_STLDate.Clear;
   DRMaskEdit_BUYDate.Clear;
   DRMaskEdit_SELDate.Clear;

   DRBitBtn4.Hide;

   IsInsert := TRUE;
   IsUpdate := TRUE;

   DRMaskEdit_TRADEDate.Text := FormatDateTime('YYYYMMDD',now);

end;

//******************************************************************************
//***  �Ÿ����� �Է»��� Enter�� ��ȸ�̵�
//***  KeyPress
//******************************************************************************
procedure TForm_Dlg_STLDate.DRMaskEdit_TRADEDateKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

   if Key = #13 then
   begin
      DRBitBtn3.SetFocus;
      DRBitBtn3Click(Sender);
   end;

end;
//******************************************************************************
//*** ������, �ż��ŵ��ڱݰ����� SETRADE_TBL�� ������Ʈ
//*** ����Button
//******************************************************************************
procedure TForm_Dlg_STLDate.DRBitBtn2Click(Sender: TObject);
var
   IsSuccess : Boolean;
begin
  inherited;

   //����Ÿ ��ȿ���˻�
   if not IsValidData then Exit;
   //SETRADE_TBL ���۾�����
   if not GetTradeData then Exit;
   //�߰� OR ����
   if IsInsert then IsSuccess := InsertSTLData else IsSuccess := UpdateSTLData;

   if not IsSuccess then Exit;

   with ADOQuery_SETRADE_Update do begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE SETRADE_TBL SET                                  '
             +'       STL_DATE   = ''' + DRMaskEdit_STLDate.Text + ''' '
             +'      ,STL_DATE2  = CASE TRADE_TYPE WHEN ''B'' THEN ''' + DRMaskEdit_BUYDate.Text + ''' '
             +'                    ELSE CASE TRADE_TYPE WHEN ''S'' THEN ''' + DRMaskEdit_SELDate.Text + ''' '
             +'                    END END                             '
             +' WHERE DEPT_CODE  = ''' + gvDeptCode + '''              '
             +'   AND TRADE_DATE = ''' + DRMaskEdit_TRADEDate.Text + ''' ');

      if not IsUpdate then
         SQL.Add(' AND MANUAL_YN = ''N'' ');

      try
         gf_ADOExecSQL(ADOQuery_SETRADE_Update);
      except
         on E : Exception do begin
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SETRADE_Update'); //DB����
            Exit;
         end;
      end;

      DRBitBtn3Click(Sender);

      gf_ShowMessage(MessageBar, mtInformation, 1008, ''); //������Ʈ �Ϸ�

   end;
end;
//******************************************************************************
//***  �Ÿ����ڷ� �������� ��ȸ
//***   ��ȸ button
//******************************************************************************
procedure TForm_Dlg_STLDate.DRBitBtn3Click(Sender: TObject);
begin
  inherited;

   if DRMaskEdit_TRADEDate.Text <> '' then begin

      if not gf_CheckValidDate(DRMaskEdit_TRADEDate.Text) then begin
         gf_ShowMessage(MessageBar, mtError, 1040, ''); // �Ÿ����� �Է¿���
         DRMaskEdit_TRADEDate.SetFocus;
      end
      else begin
         GetSTLDate(DRMaskEdit_TRADEDate.Text);
         DRMaskEdit_STLDate.SetFocus;
      end;
   end;
end;



//******************************************************************************
//***  �Ÿ����ڷ� �������� ��ȸ
//***  [SUSTLDT_TBL]
//******************************************************************************
function TForm_Dlg_STLDate.GetSTLDate(pTRDate:String): Boolean;
var
   STDate, BUDate, SEDate : String;
begin
   result := False;

   gf_ClearMessage(MessageBar);

   with ADOQuery_SUSTLDT do begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT DEPT_CODE, TRADE_DATE, SEC_TYPE, STL_DATE,  '+
              '       BUY_STL_DATE2, SELL_STL_DATE2, OPR_ID,      '+
              '       OPR_DATE, OPR_TIME                          '+
              '  FROM SUSTLDT_TBL                                 '+
              '  WHERE TRADE_DATE = ''' + pTRDate + '''           '+
              '    AND DEPT_CODE  = ''' + gvDeptCode + '''        '+
              '    AND SEC_TYPE   = ''E''                         ');
      try
         gf_ADOQueryOpen(ADOQuery_SUSTLDT);
      except
         on E : Exception do
         begin
            gf_ShowMessage(MessageBar, mtError, 9001, 'SUSTLDT_TBL[Select]'); //Database ����
            Exit;
         end;
      end;

      if RecordCount <= 0 then begin
         IsInsert := TRUE;
         gf_ShowMessage(MessageBar, mtInformation, 1021, '�Էµ� �ڷᰡ �����ϴ�.');
         Exit;
      end;

      DRMaskEdit_STLDate.Text := Trim(FieldByName('STL_DATE').AsString);
      DRMaskEdit_BUYDate.Text := Trim(FieldByName('BUY_STL_DATE2').AsString);
      DRMaskEdit_SELDate.Text := Trim(FieldByName('SELL_STL_DATE2').AsString);

      DREdit_OprID.Text   := Trim(FieldByName('OPR_ID').AsString);
      DREdit_OprTime.Text := gf_FormatDate(Trim(FieldByName('OPR_DATE').asString))
                             + ' '
                             + gf_FormatTime(Trim(FieldByName('OPR_TIME').asString));
      IsInsert := FALSE;
   end;

   gf_ShowMessage(MessageBar, mtInformation, 1021, '�������� ��ȸ �Ϸ�');

   result := True;
end;

//******************************************************************************
//***  ������ & �ŵ��ż��ڱݰ����� �Է�
//***  [SUSTLDT_TBL]
//******************************************************************************
function TForm_Dlg_STLDate.InsertSTLData : Boolean;
begin
   result := False;

   with ADOQuery_SUSTLDT_Insert do begin
      Close;
      SQL.Clear;
      SQL.Add('INSERT SUSTLDT_TBL                                     '
             +'       (DEPT_CODE, TRADE_DATE, SEC_TYPE,               '
             +'        STL_DATE, BUY_STL_DATE2, SELL_STL_DATE2,       '
             +'        OPR_ID, OPR_DATE, OPR_TIME )                   '
             +'VALUES                                                 '
             +'       (:pDEPT_CODE, :pTRADE_DATE, :pSEC_TYPE,         '
             +'        :pSTL_DATE, :pBUY_STL_DATE2, :pSELL_STL_DATE2, '
             +'        :pOPR_ID,   :pOPR_DATE, :pOPR_TIME )           ');

      InsertParamData;

      try
         gf_ADOExecSQL(ADOQuery_SUSTLDT_Insert);
      except
         on E : Exception do
         begin
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUSTLDT Insert' );
            Exit;
         end;
      end;

   end;

   result := True;
end;
//******************************************************************************
//***  ������ & �ŵ��ż��ڱݰ����� �����ڷ� ����
//***  [SUSTLDT_TBL]
//******************************************************************************
function TForm_Dlg_STLDate.UpdateSTLData : Boolean;
begin
   result := False;

   with ADOQuery_SUSTLDT_Insert do begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE SUSTLDT_TBL SET                    '
             +'       DEPT_CODE     = :pDEPT_CODE,       '
             +'       TRADE_DATE    = :pTRADE_DATE,      '
             +'       SEC_TYPE      = :pSEC_TYPE,        '
             +'       STL_DATE      = :pSTL_DATE,        '
             +'       BUY_STL_DATE2 = :pBUY_STL_DATE2,   '
             +'       SELL_STL_DATE2= :pSELL_STL_DATE2,  '
             +'       OPR_ID        = :pOPR_ID,          '
             +'       OPR_DATE      = :pOPR_DATE,        '
             +'       OPR_TIME      = :pOPR_TIME         '
             +'WHERE  DEPT_CODE  = ''' + gvDeptCode + ''''
             +'  AND  TRADE_DATE = ''' + DRMaskEdit_TRADEDate.Text + ''''
             +'  AND  SEC_TYPE   = ''E''                 ');

      InsertParamData;

      try
         gf_ADOExecSQL(ADOQuery_SUSTLDT_Insert);
      except
         on E : Exception do
         begin
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_SUSTLDT Update' );
            Exit;
         end;
      end;

   end;

   result := True;
end;

//******************************************************************************
//***  ������ & �ŵ��ż��ڱݰ����� �Է�&������ �Ķ���Ͱ� �Է�
//***  [SUSTLDT_TBL]
//******************************************************************************
procedure TForm_Dlg_STLDate.InsertParamData;
begin
   with ADOQuery_SUSTLDT_Insert do begin
      //�ڵ�
      Parameters.ParamByName('pDEPT_CODE').Value  := gvDeptCode;
      //�Ÿ�����
      Parameters.ParamByName('pTRADE_DATE').Value := DRMaskEdit_TRADEDate.Text;
      //�Ÿ�Ÿ��
      Parameters.ParamByName('pSEC_TYPE').Value   := 'E';
      //��������
      Parameters.ParamByName('pSTL_DATE').Value   := DRMaskEdit_STLDate.Text;
      //�ż������ڱ�����
      Parameters.ParamByName('pBUY_STL_DATE2').Value  := DRMaskEdit_BUYDate.Text;
      //�ŵ������ڱ�����
      Parameters.ParamByName('pSELL_STL_DATE2').Value := DRMaskEdit_SELDate.Text;
      //������
      Parameters.ParamByName('pOPR_ID').Value   := gvOprUsrNo;
      //������
      Parameters.ParamByName('pOPR_DATE').Value := FormatDateTime('YYYYMMDD',now);
      //���۽ð�
      Parameters.ParamByName('pOPR_TIME').Value := FormatDateTime('hhmmssnn',now);
   end;
end;
//******************************************************************************
//***  �Է»��� ��������
//******************************************************************************
function TForm_Dlg_STLDate.IsValidData: Boolean;
begin
   result := False;

   //�Ÿ�����
   if DRMaskEdit_TRADEDate.Text = '' then begin
      gf_ShowMessage(MessageBar, mtError, 1040, '');
      DRMaskEdit_TRADEDate.SetFocus;
      Exit;
   end;
   if not gf_CheckValidDate(DRMaskEdit_TRADEDate.Text) then begin
      gf_ShowMessage(MessageBar, mtError, 1040, '');
      DRMaskEdit_TRADEDate.SetFocus;
      Exit;
   end;
   //��������
   if DRMaskEdit_STLDate.Text = '' then begin
      gf_ShowMessage(MessageBar, mtError, 1040, '');
      DRMaskEdit_STLDate.SetFocus;
      Exit;
   end;
   if not gf_CheckValidDate(DRMaskEdit_STLDate.Text) then begin
      gf_ShowMessage(MessageBar, mtError, 1040, '');
      DRMaskEdit_STLDate.SetFocus;
      Exit;
   end;
   //�ż��ڱݰ�������
   if DRMaskEdit_BUYDate.Text = '' then begin
      gf_ShowMessage(MessageBar, mtError, 1040, '');
      DRMaskEdit_BUYDate.SetFocus;
      Exit;
   end;
   if not gf_CheckValidDate(DRMaskEdit_BUYDate.Text) then begin
      gf_ShowMessage(MessageBar, mtError, 1040, '');
      DRMaskEdit_BUYDate.SetFocus;
      Exit;
   end;
   //�ŵ��ڱݰ�������
   if DRMaskEdit_SELDate.Text = '' then begin
      gf_ShowMessage(MessageBar, mtError, 1040, '');
      DRMaskEdit_SELDate.SetFocus;
      Exit;
   end;
   if not gf_CheckValidDate(DRMaskEdit_SELDate.Text) then begin
      gf_ShowMessage(MessageBar, mtError, 1040, '');
      DRMaskEdit_SELDate.SetFocus;
      Exit;
   end;

   result := True;
end;
//******************************************************************************
//*** ���۾� ���ο����� ������Ʈ ���� MANUAL_YN = 'Y'�� ���۾�������
//*** [SETRADE_TBL]
//******************************************************************************
function  TForm_Dlg_STLDate.GetTradeData : Boolean;
var
   iYesNoCancel : Integer;
begin
   result := False;

   with ADOQuery_SUSTLDT do begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COUNT(STL_DATE) as CNT FROM SETRADE_TBL            '+
              ' WHERE TRADE_DATE = ''' + DRMaskEdit_TRADEDate.Text + ''' '+
              '   AND DEPT_CODE  = ''' + gvDeptCode + '''                '+
              '   AND MANUAL_YN  = ''Y''                                 ');

      try
         gf_ADOQueryOpen(ADOQuery_SUSTLDT);
      except
         on E : Exception do begin
            Exit;
         end;
      end;

      if FieldByName('CNT').AsInteger > 0 then begin

         iYesNoCancel := gf_ShowDlgMessage(Self.Tag, mtConfirmation, 0,
                           gcMsgLineInterval + gwManualWarning +  // ���� ���۾� �ڷᰡ �����ϴ�. ���� :
                           FieldByName('CNT').AsString + gcMsgLineInterval +
                           '���� ���۾��ڷḦ ������Ʈ �Ͻðڽ��ϱ�?',
                           mbYesNoCancel, 0);
              if iYesNoCancel = idYes then IsUpdate  := True
         else if iYesNoCancel = idNo  then IsUpdate  := False
         else Exit;

      end;

   end;

   result := True;
end;

//******************************************************************************
//*** �Է»��� ENTER�� NEXT TAB MOVE
//*** ������(1), �ż��ڱݰ�����(2), �ŵ��ڱݰ�����(3)
//******************************************************************************
procedure TForm_Dlg_STLDate.DRMaskEdit_DateKeyPress(Sender: TObject;  var Key: Char);
begin
  inherited;
   if Key = #13 then begin
      Case (TDRMaskEdit(Sender).Tag) of
         1: DRMaskEdit_BUYDate.SetFocus;
         2: DRMaskEdit_SELDate.SetFocus;
         3: begin DRBitBtn2.SetFocus; DRBitBtn2Click(Sender); end;
      end;
   end;

end;

procedure TForm_Dlg_STLDate.FormShow(Sender: TObject);
begin
  inherited;
   DRBitBtn3Click(Sender);

end;

end.
