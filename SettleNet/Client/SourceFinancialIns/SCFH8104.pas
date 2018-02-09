unit SCFH8104;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Printers,
  Dialogs, SCCChildForm, DRDialogs, DB, ADODB, DRSpecial, StdCtrls, Buttons,
  DRAdditional, ExtCtrls, DRStandard, Grids, DRStringgrid, DrStringPrintU;

type
  TForm_SCFH8104 = class(TForm_SCF)
    DRPanel1: TDRPanel;
    DRPanel2: TDRPanel;
    DRStrGrid_Report: TDRStringGrid;
    DRPanel3: TDRPanel;
    DRLabel1: TDRLabel;
    DRLabel2: TDRLabel;
    DRLabel3: TDRLabel;
    DRLabel4: TDRLabel;
    DRLabel5: TDRLabel;
    DRLabel6: TDRLabel;
    DRLabel7: TDRLabel;
    DREdit_MgrOprTime: TDREdit;
    DREdit_MgrOprId: TDREdit;
    DREdit_ReportID: TDREdit;
    DREdit_ReportName: TDREdit;
    DREdit_ViewFileName: TDREdit;
    DREdit_AddFileName: TDREdit;
    DREdit_SubjectData: TDREdit;
    DRLabel8: TDRLabel;
    DREdit_FileNameInfo: TDREdit;
    DRMemo_MailBodyData: TDRMemo;
    DrStringPrint1: TDrStringPrint;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure DRStrGrid_ReportDblClick(Sender: TObject);
    procedure DRStrGrid_ReportSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);

    procedure DRBitBtn2Click(Sender: TObject);
    procedure DRBitBtn3Click(Sender: TObject);
    procedure DRBitBtn4Click(Sender: TObject);

    procedure DREdit_KeyPress(Sender: TObject; var Key: Char);


    // ����� ����
    function QueryAllReport: integer; // ���� ���� ��ȸ
    procedure ClearReportList;  // ���� List Clear

    procedure InputValueClear;  // Edit Clear

    function DisplayGridReport: Boolean;  // StrGrid�� ���� DATA INPUT
    function ReportCheckKeyEditEmpty: boolean;
    procedure FormShow(Sender: TObject);  // �ʼ��Է»��� ���� üũ


  private
    procedure DefClearStrGrid(pStrGrid: TDRStringGrid); // StrGrid Clear
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_SCFH8104: TForm_SCFH8104;

implementation

uses
  SCCLib, SCCGlobalType, SCCCmuLib;
{$R *.dfm}

type
  TAllReportItem = record           // ��ü ���� List
    ReportCode       : string;
    ReportNameKor   : string;
  end;
  pTAllReportItem = ^TAllReportItem;
{
  TSelectReportItem = record           // ��ü ���� List
    ReportCode        : string;
    LedgerTrCode      : string;
    FileNameInfo      : string;
    ViewFileName      : string;
    AddFileName       : string;
    SubjectData       : string;
    MailBodyData      : string;
    OprId             : string;
    OprDate           : string;
    OprTime           : string;
  end;
  pTSelectReportItem = ^TSelectReportItem;
}

const
  IDX_REPORT_CODE     = 0;   // ����ID  Col Index
  IDX_REPORT_NAME_KOR      = 1;   // ������ Col Index

var
  AllReportList     : TList;                     // �׷���� DRListView_AllAcc List
  SelColIdx : Integer;                          // StrGrid ���õ� Col Index
  SelRowIdx : Integer;                          // StrGrid ���õ� Row Index


procedure TForm_SCFH8104.DefClearStrGrid(pStrGrid: TDRStringGrid);
begin
  with pStrGrid do
  begin
    Color             := gcGridBackColor;
    SelectedCellColor := gcGridSelectColor;
    RowCount := 2;
    Rows[1].Clear;
  end;  // end of with
end;

//==============================================================================
//  Clear ReportList (����)
//==============================================================================
procedure TForm_SCFH8104.ClearReportList;
var
  I : Integer;
  ReportItem : pTAllReportItem;
begin
  if not Assigned(AllReportList) then Exit;
  for I := 0 to AllReportList.Count -1 do
  begin
    ReportItem := AllReportList.Items[I];
    Dispose(ReportItem);
  end;
  AllReportList.Clear;
end;

//==============================================================================
//  Form Create
//==============================================================================
procedure TForm_SCFH8104.FormCreate(Sender: TObject);
begin
  inherited;
  InputValueClear;
  
  AllReportList := TList.Create;

  if (not Assigned(AllReportList)) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 9004, '', 0); // List ���� ����
    Close;
    Exit;
  end;

  QueryAllReport;

  DisplayGridReport;

  // �ʼ��Է� Edit
  DREdit_ViewFileName.Color    := gcQueryEditColor;
  DREdit_FileNameInfo.Color     := gcQueryEditColor;
  DREdit_AddFileName.Color     := gcQueryEditColor;
  DREdit_SubjectData.Color     := gcQueryEditColor;
end;

//==============================================================================
//  Edit Clear
//==============================================================================
procedure TForm_SCFH8104.InputValueClear;
begin
  DREdit_ReportID.Clear;
  DREdit_ReportName.Clear;
  DREdit_ViewFileName.Clear;
  DREdit_FileNameInfo.Clear;
  DREdit_AddFileName.Clear;
  DREdit_SubjectData.Clear;
  DRMemo_MailBodyData.Clear;
  DREdit_MgrOprId.Clear;
  DREdit_MgrOprTime.Clear;
end;

//==============================================================================
// ��ü ���� Query
//==============================================================================
function TForm_SCFH8104.QueryAllReport: integer;
var
  ReportItem : pTAllReportItem;
begin
  Result := 0;

  ClearReportList;

  with ADOQuery_DECLN do
  begin
    // ��ü ����
    Close;
    SQL.Clear;
    SQL.Add(' SELECT D.REPORT_CODE, D.REPORT_NAME_KOR                   '
          + ' FROM SZREPIF_INS F, SZREPID_INS D                   '
          + ' WHERE F.REPORT_CODE = D.REPORT_CODE                 '
          + ' ORDER BY D.REPORT_CODE                              ');

    Try
      gf_ADOQueryOpen(ADOQuery_DECLN);
    Except
      on E : Exception do
      begin  // DataBase ����
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZREPIF_INS]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZREPIF_INS]'); //Database ����
        Exit;
      end;
    End;


    while not Eof do
    begin
      New(ReportItem);
      AllReportList.Add(ReportItem);
      ReportItem.ReportCode := Trim(FieldByName('REPORT_CODE').AsString);
      ReportItem.ReportNameKor := Trim(FieldByName('REPORT_NAME_KOR').AsString);

      Next;
    end;  // end while

  end;

  Result := AllReportList.Count;
end;

//==============================================================================
// Form Close
//==============================================================================
procedure TForm_SCFH8104.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
   if Assigned(AllReportList) then
   begin
     ClearReportList;
     AllReportList.Free;
   end;
end;

//==============================================================================
// DRStrGrid_Report ����ƮList ����
//==============================================================================
function TForm_SCFH8104.DisplayGridReport: Boolean;
var
  I, K, iRow : Integer;
  ReportItem : pTAllReportItem;
  sReportName, sReportCode : string;
begin
  Result := false;

  with DRStrGrid_Report do
  begin
    if AllReportList.Count <= 0 then
    begin
      RowCount := 2;
      Rows[1].Clear;
      gf_ShowMessage(MessageBar, mtInformation, 1018, ''); //�ش� ������ �����ϴ�.
      Exit;
    end;
    DefClearStrGrid(DRStrGrid_Report);

    RowCount := AllReportList.Count + 1;

    iRow := 0;
    sReportCode := '';
    sReportName := '';

    // StrGrid Input
    for i := 0 to AllReportList.Count - 1 do
    begin
      ReportItem := AllReportList.Items[i];

      Inc(iRow);
      Rows[iRow].Clear;

      sReportCode := ReportItem.ReportCode;
      sReportName := ReportItem.ReportNameKor;

      // ����ID
      Cells[IDX_REPORT_CODE, iRow] := sReportCode;
      // ������
      Cells[IDX_REPORT_NAME_KOR, iRow] := sReportName;
    end;

  end;
end;

//==============================================================================
// �����ư Click
//==============================================================================
procedure TForm_SCFH8104.DRBitBtn3Click(Sender: TObject);
var
  sReportId: string;
begin
  inherited;

   // Confirm - ���� �����Ͻðڽ��ϱ�?
   if gf_ShowDlgMessage(Self.Tag, mtConfirmation, 0, '���� �Ͻðڽ��ϱ�?', mbOKCancel, 0) = idCancel then
   begin
      gf_ShowMessage(MessageBar, mtInformation, 0, '������ ��� �ƽ��ϴ�');
      Exit;
   end;

  gf_ShowMessage(MessageBar, mtInformation, 1010, ''); // ���� ���Դϴ�.
//  Screen.Cursor := crHourGlass;
//  DisableForm;
  if ReportCheckKeyEditEmpty then Exit;   //�Է� ���� �׸� Ȯ��

  sReportId := DREdit_ReportID.Text;
  with ADOQuery_DECLN do
  begin
    //====================
    gf_BeginTransaction;
    //====================

    //=== Update SZREPIF_INS
    Close;
    SQL.Clear;
    SQL.Add(' UPDATE SZREPIF_INS        '
//          + ' SET REPORT_CODE     =   :pReportCode,      '
          + ' SET FILENAME_INFO   =   :pFileNameInfo,    '
          + '     VIEW_FILENAME   =   :pViewFileName,    '
          + '     ADD_FILENAME    =   :pAddFileName,     '
          + '     SUBJECT_DATA    =   :pSubJectData,     '
          + '     MAIL_BODY_DATA  =   :pMailBodyData,    '
          + '     OPR_ID          =   :pOprId,           '
          + '     OPR_DATE        =   :pOprDate,         '
          + '     OPR_TIME        =   :pOprTime          '
          + ' WHERE REPORT_CODE = ''' + sReportId + '''  ');

    // View
    Parameters.ParamByName('pViewFileName').Value := Trim(DREdit_ViewFileName.Text);
    // ������ϸ�
    Parameters.ParamByName('pFileNameInfo').Value := Trim(DREdit_FileNameInfo.Text);
    // ÷�����ϸ�
    Parameters.ParamByName('pAddFileName').Value := Trim(DREdit_AddFileName.Text);
    // ��������
    Parameters.ParamByName('pSubJectData').Value := Trim(DREdit_SubjectData.Text);
    // ���Ϻ���
    Parameters.ParamByName('pMailBodyData').Value := DRMemo_MailBodyData.Text;
    // ������
    Parameters.ParamByName('pOprId').Value := gvOprUsrNo;
    // ��������
    Parameters.ParamByName('pOprDate').Value := gvCurDate;
    // ���۽ð�
    Parameters.ParamByName('pOprTime').Value := gf_GetCurTime;

    Try
      gf_ADOExecSQL(ADOQuery_DECLN);
    Except
      on E : Exception do
      begin  // DataBase ����
        gf_ShowErrDlgMessage(Self.Tag, 9001, '[Update]: ' + E.Message,0);
        gf_ShowMessage(MessageBar, mtError, 9001, '[Update]'); //Database ����
        gf_RollBackTransaction;
//        EnableForm;
        Exit;
      end;
    end;
  end;
    //====================
    gf_CommitTransaction;
    //====================

    DREdit_ViewFileName.SetFocus;
//  Screen.Cursor := crDefault;
//  EnableForm;
  gf_ShowMessage(MessageBar, mtInformation, 1008, ''); // ���� �Ϸ�
end;

//==============================================================================
// �ʼ��Է� �׸� ���� Ȯ��
//==============================================================================
function TForm_SCFH8104.ReportCheckKeyEditEmpty: boolean;
var
  I : Integer;
  Checked : boolean;
begin
  Result := True;

  // ����ID
  // ����ID�� �Է¾ȵ����� �翬�� ������ �Է¾ȵ�.
  if Trim(DREdit_ReportID.Text) = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, ''); //�Է� ����
    DREdit_ViewFileName.SetFocus;
    Exit;
  end;

  // ȭ����¸�
  if Trim(DREdit_ViewFileName.Text) = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, ''); //�Է� ����
    DREdit_ViewFileName.SetFocus;
    Exit;
  end;

  // ������ϸ�
  if Trim(DREdit_FileNameInfo.Text) = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, ''); //�Է� ����
    DREdit_FileNameInfo.SetFocus;
    Exit;
  end;

  // ÷�����ϸ�
  if Trim(DREdit_AddFileName.Text) = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, ''); //�Է� ����
    DREdit_AddFileName.SetFocus;
    Exit;
  end;

  // ��������
  if Trim(DREdit_SubjectData.Text) = '' then
  begin
    gf_ShowMessage(MessageBar, mtError, 1012, ''); //�Է� ����
    DREdit_SubjectData.SetFocus;
    Exit;
  end;

  Result := false;
end;

//==============================================================================
// ����Ʈ �׸��� ����Ŭ��
//==============================================================================
procedure TForm_SCFH8104.DRStrGrid_ReportDblClick(Sender: TObject);
var
  ReportItem : pTAllReportItem;
begin
  inherited;
  gf_ClearMessage(MessageBar);

  if SelRowIdx <= 0 then Exit;
  if AllReportList.Count <= 0 then Exit;

  // ����Ŭ���� ���� ���� ��������
  ReportItem := AllReportList.Items[SelRowIdx -1];

  // ���� �������� ��������.(���õ� ����Ʈ�ڵ忡 ���ؼ�)
  with ADOQuery_DECLN do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' SELECT REPORT_CODE, LEDGER_TR_CODE, FILENAME_INFO,             '
          + ' VIEW_FILENAME, ADD_FILENAME, SUBJECT_DATA, MAIL_BODY_DATA,     '
          + ' OPR_ID, OPR_DATE, OPR_TIME                                       '
          + ' FROM SZREPIF_INS                                                '
          + ' WHERE REPORT_CODE = ''' + ReportItem.ReportCode + '''           ');

    Try
      gf_ADOQueryOpen(ADOQuery_DECLN);
    Except
      on E : Exception do
      begin  // DataBase ����
        gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_DECLN[SZREPIF_INS]: ' + E.Message, 0);
        gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_DECLN[SZREPIF_INS]'); //Database ����
        Exit;
      end;
    End;

    // �� Edit Input
    DREdit_ReportID.Text := Trim(FieldByName('REPORT_CODE').asString);
    DREdit_ReportName.Text := ReportItem.ReportNameKor;
    DREdit_ViewFileName.Text := Trim(FieldByName('VIEW_FILENAME').asString);
    DREdit_FileNameInfo.Text := Trim(FieldByName('FILENAME_INFO').asString);
    DREdit_AddFileName.Text := Trim(FieldByName('ADD_FILENAME').asString);
    DREdit_SubjectData.Text := Trim(FieldByName('SUBJECT_DATA').asString);
    DRMemo_MailBodyData.Text := Trim(FieldByName('MAIL_BODY_DATA').asString);
    DREdit_MgrOprId.Text := Trim(FieldByName('OPR_ID').asString);
    DREdit_MgrOprTime.Text := gf_FormatDate(Trim(FieldByName('OPR_DATE').asString))
                          + ' ' + gf_FormatTime(Trim(FieldByName('OPR_TIME').asString));

  end;

end;

//==============================================================================
// ����Ʈ �׸��� ����Ŭ��
//==============================================================================
procedure TForm_SCFH8104.DRStrGrid_ReportSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  SelRowIdx := ARow;
end;

//==============================================================================
//  ��ȸ ��ư Click
//==============================================================================
procedure TForm_SCFH8104.DRBitBtn4Click(Sender: TObject);
begin
  inherited;
  gf_ShowMessage(MessageBar, mtInformation, 1020, ''); //��ȸ ���Դϴ�.
//  DisableForm;

  // Edit Ŭ����
  InputValueClear;

  QueryAllReport;
  DisplayGridReport;

//  EnableForm;
  gf_ShowMessage(MessageBar, mtInformation, 1021, ''); // ��ȸ �Ϸ�
end;

procedure TForm_SCFH8104.DREdit_KeyPress(Sender: TObject; var Key: Char);
begin
   if (Key = #13) and (ActiveControl is TWinControl) then   // ���� Control�� �̵�
   begin
      gf_ClearMessage(MessageBar);
      SelectNext(ActiveControl as TWinControl, True, True);
   end;
end;

//==============================================================================
//  �μ� ��ư Click
//==============================================================================
procedure TForm_SCFH8104.DRBitBtn2Click(Sender: TObject);
begin
  inherited;
   gf_ShowMessage(MessageBar, mtInformation, 1100, ''); // �μ� ���Դϴ�.
   with DrStringPrint1 do
   begin
      // Report Title
      Title  := DRPanel_Title.Caption;
      UserText1  := '';
      UserText2  := '';
      StringGrid   := DRStrGrid_Report;
      Orientation  := poPortrait;   //poLandscape; 

      Print;
   end;

   gf_ShowMessage(MessageBar, mtInformation, 1101, ''); // �μ� �Ϸ�
end;

procedure TForm_SCFH8104.FormShow(Sender: TObject);
begin
  inherited;
  DRStrGrid_Report.SetFocus;
end;

end.

