unit SCCXLInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SCCDlgForm, StdCtrls, DRStandard, Buttons, DRAdditional,
  DRSpecial, DRDialogs, ExtCtrls, Grids, DRStringgrid, DB, ADODB;

type
  TDlgForm_XLInput = class(TForm_Dlg)
    DRFramePanel_T: TDRFramePanel;
    DRLabel_FileCap: TDRLabel;
    DRSpeedBtn_FileName: TDRSpeedButton;
    DREdit_FileName: TDREdit;
    DRButton_Import: TDRButton;
    DRStringGrid_InputInfo: TDRStringGrid;
    DRPanel_Title: TDRPanel;
    DROpenDialog_Input: TDROpenDialog;
    ADOQuery_ICodeCheck: TADOQuery;
    ADOQuery_ANoCheck: TADOQuery;
    ADOQuery_Main: TADOQuery;
    ADOQuery_Temp: TADOQuery;
    function TradeCount_QueryOpen: integer;
    procedure DRSpeedBtn_FileNameClick(Sender: TObject);
    procedure InputFileOpen;
    procedure XLOpen(FileName : String);
    function DataCheck: Boolean;
    procedure CompareData_Query(FIssueCodeList, FAccNoList: TStringList);
    function FileOverlapCheck(sIssueCode, sAccNo: string):integer;
    procedure DispStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DRButton_ImportClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  DlgForm_XLInput: TDlgForm_XLInput;


implementation

{$R *.dfm}
uses
  SCCLib, ComObj, SCCDllLib, SCCGlobalType;

type
  TIPOData = record
    IpoIssueCode : string;
    IpoAccNo     : string;
    IpoQty       : Double;
    IpoComm      : Double;
    IpoDate      : string;
    IpoConfirm   : string;
    IpoSeq       : string;
    IpoAmt       : Double;
    IpoCommRate  : Double;
    IpoOverLapCnt: integer;
    IpoHintCell  : string;
  end;
  pIPOData = ^TIPOData;

  TIssueInfo = record
    IpoIssueCode  : string;
    IpoIssueSeq   : string;
    IpoIssuePrice : Double;
    IpoCommRate   : Double;
  end;
  pIssueInfo = ^TIssueInfo;

const
  // List Index
  IDX_IPO_ISSUE_CODE = 1;
  IDX_IPO_ACC_NO     = 2;
  IDX_IPO_QTY        = 3;
  IDX_IPO_COMM       = 4;
  IDX_IPO_DATE       = 5;
  IDX_IPO_CONFIRM    = 6;
  IDX_IPO_ISSUE_SEQ  = 7;
  IDX_IPO_AMT        = 8;
  IDX_IPO_COMM_RATE  = 9;

  // StringGrid Index
  DP_IDX_IPO_ISSUE_CODE = 1;
  DP_IDX_IPO_ACC_NO     = 2;
  DP_IDX_IPO_QTY        = 3;
  DP_IDX_IPO_COMM       = 4;
  DP_IDX_IPO_COMM_RATE  = 5;
  DP_IDX_IPO_AMT        = 6;
  DP_IDX_IPO_DATE       = 7;
  DP_IDX_IPO_CONFIRM    = 8;
var
  IPOList : TList;
  IssueInfoList : TList;
  iRecordCnt : integer;
  iErrCnt : integer;
  iData: integer;
  ErrIssueCodeList :TStringList;
  ErrAccNoList : TStringList;

//------------------------------------------------------------------------------
// û�� ���� ���� ��������
//------------------------------------------------------------------------------
function TDlgForm_XLInput.TradeCount_QueryOpen: integer;
begin
  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' SELECT TRADE_CNT = COUNT(*) FROM SETRADE_IPO ');

    gf_ADOQueryOpen(ADOQuery_Temp);

    Result := FieldByName('TRADE_CNT').AsInteger;

  end;
end;

//------------------------------------------------------------------------------
// ���� ����
//------------------------------------------------------------------------------
procedure TDlgForm_XLInput.DRSpeedBtn_FileNameClick(Sender: TObject);
begin
  InputFileOpen;
end;

//------------------------------------------------------------------------------
// ���� ��� üũ �� INI���Ͽ� ����
//------------------------------------------------------------------------------
procedure TDlgForm_XLInput.InputFileOpen;
var
  sDirName, sFileName : String;
  SearchRec : TSearchRec;
begin

  // INI ���Ͽ��� ��� �ҷ���
  sDirName := gf_ReadFormStrInfo(Self.Name, 'Default Dir', gvDirDefault);
  if (DirectoryExists(sDirName)) then
    DROpenDialog_Input.InitialDir := sDirName
  else
    DROpenDialog_Input.InitialDir := gvDirDefault;


  if (not DROpenDialog_Input.Execute) then
  begin
     DREdit_FileName.Text := '';
     Exit;
  end;

  Screen.Cursor := crHourGlass;
  sDirName := ExtractFileDir(DROpenDialog_Input.FileName);
  //INI ���Ͽ� ��� ����
  gf_WriteFormStrInfo(Self.Name, 'Default Dir', sDirName);
  DREdit_FileName.Text := DROpenDialog_Input.FileName;

  sFileName := Trim(DREdit_FileName.Text);
  if (sFileName = '') then
  begin
    gf_showmessage(MessageBar, mtError, 1034, ''); // ������ �����Ͻʽÿ�
    Exit;
  end;

  { FindFirst - sFileName ��ο��� � �����̵�(faAnyFile) ã�ƿͶ� : ã���� Return 0
   => ���� �����ϴ��� Ȯ���ϴ� �Լ� : ���� ������ Retrun Error Code  }
  if (FindFirst(sFileName, faAnyFile, SearchRec) <> 0) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 1027, DREdit_FileName.Text, 0); //List ���� ����
    gf_Showmessage(MessageBar, mtError, 1027, ''); // �ش� ������ �������� �ʽ��ϴ�.
    Screen.Cursor := crDefault;
    Exit;
  end;

  // Excel ���� �ҷ�����
  XLOpen(sFileName);
  Screen.Cursor := crDefault;

end;

//------------------------------------------------------------------------------
// Excel ���� ���� �� Record �� �Է�
//------------------------------------------------------------------------------
procedure TDlgForm_XLInput.XLOpen(FileName : string);
  procedure FreeList(pTList: TList);
  var
     I : Integer;
     IpoItem : pIPOData;
  begin
     if not Assigned(pTList) then Exit;
     for I := 0 to pTList.Count -1 do
     begin
        IpoItem := pTList.Items[I];
        Dispose(IpoItem);
     end;
     pTList.Clear;
     //pTList.Free;
  end;
var
  XL, XLBook, XLSheet : Variant;
  bData : Boolean;
  iRow: integer;
  dIpoQTy, dIpoComm : Double;
  IPOData : pIPOData;
  FIssueCodeList, FAccNoList : TStringList;
  sIssueCode, sAccNo, sTemp : string;
  ExtMsg : string;
begin
  iRow := 1;
  iRecordCnt := 0;
  DRStringGrid_InputInfo.RowCount := 2;
  DRStringGrid_InputInfo.Rows[1].Clear;
  MessageBar.ClearMessage;

  IPOList := TList.Create;
  ErrIssueCodeList := TStringList.create;
  ErrAccNoList := TStringList.Create;


  if (not Assigned(IPOList)) then
  begin
    gf_ShowMessage(MessageBar, mtError, 0, 'û�� ���� List�� �������� �ʾҽ��ϴ�.');
    DRSpeedBtn_FileName.Enabled := false;
    Exit;
  end;

  if (not Assigned(ErrIssueCodeList)) then
  begin
    gf_ShowMessage(MessageBar, mtError, 0, 'ErrIssueList�� �������� �ʾҽ��ϴ�.');
    DRSpeedBtn_FileName.Enabled := false;
    Exit;
  end;

  if (not Assigned(ErrAccNoList)) then
  begin
    gf_ShowMessage(MessageBar, mtError, 0, 'ErrAccNoList�� �������� �ʾҽ��ϴ�.');
    DRSpeedBtn_FileName.Enabled := false;
    Exit;
  end;

  if (Assigned(FIssueCodeList)) then
    FIssueCodeList.Clear
  else
    FIssueCodeList := TStringList.Create;

  if (Assigned(FAccNoList)) then
    FAccNoList.Clear
  else
    FAccNoList := TstringList.Create;

  //TStringList �ߺ����� ����
  FIssueCodeList.Sorted := True;
  FIssueCodeList.Duplicates := dupIgnore;
  FAccNoList.Sorted := True;
  FAccNoList.Duplicates := dupIgnore;

  try
    try
      XL := CreateOLEObject('Excel.Application');
      XLBook := XL.WorkBooks.Open(FileName);
      XLSheet := XLBook.WorkSheets[1];

      bData := True;
      sIssueCode := '';
      sAccNo := '';
      sTemp := '';
      dIpoQTy := 0;
      dIpoComm := 0;

      if ((Trim(XLSheet.Cells[iRow, IDX_IPO_ISSUE_CODE]) <> '�����ڵ�') or
         (Trim(XLSheet.Cells[iRow, IDX_IPO_ACC_NO]) <> '���¹�ȣ')      or
         (Trim(XLSheet.Cells[iRow, IDX_IPO_QTY]) <> '����')             or
         (Trim(XLSheet.Cells[iRow, IDX_IPO_COMM]) <> '������')          or
         (Trim(XLSheet.Cells[iRow, IDX_IPO_DATE]) <> 'û����'))  then
      begin
        raise Exception.Create('���� ���� ��� ����');
      end;

      FreeList(IPOList);

      while bData do
      begin
        Inc(iRow);
        Inc(iRecordCnt);

        ExtMsg := '';

        if ((sIssueCode <> Trim(XLSheet.Cells[iRow, IDX_IPO_ISSUE_CODE])) and
           (Trim(XLSheet.Cells[iRow, IDX_IPO_ISSUE_CODE]) <> '')) then
        begin
          FIssueCodeList.Add(Trim(XLSheet.Cells[iRow, IDX_IPO_ISSUE_CODE]));
        end;
        if ((sAccNo <> Trim(XLSheet.Cells[iRow, IDX_IPO_ACC_NO])) and
           (Trim(XLSheet.Cells[iRow, IDX_IPO_ACC_NO]) <> '')) then
        begin
          FAccNoList.Add(Trim(XLSheet.Cells[iRow, IDX_IPO_ACC_NO]))
        end;

        New(IPOData);
        IPOList.Add(IPOData);

        IPOData.IpoOverLapCnt := 0;
        IPOData.IpoHintCell   := '';
        IPOData.IpoConfirm   := 'O';

        // �����ڵ� ��ĭ üũ
        if (Trim(XLSheet.Cells[iRow, IDX_IPO_ISSUE_CODE]) = '') then
        begin
          IPOData.IpoConfirm   := 'X';
          ExtMsg := '�����ڵ带 �Է��� �ֽʽÿ�.';
        end;

        sTemp := Trim(XLSheet.Cells[iRow, IDX_IPO_ACC_NO]);
        // ���¹�ȣ ��ĭ üũ
        if (sTemp = '') then
        begin
          IPOData.IpoConfirm   := 'X';
          if ExtMsg <> '' then
            ExtMsg := ExtMsg + chr(10) + chr(13);
          ExtMsg := ExtMsg + '���¹�ȣ�� �Է��� �ֽʽÿ�.';
        end else begin
           sTemp := StringReplace(sTemp, '-', '', [rfReplaceAll]);
        end;

        // StringGrid HintCell
        IPOData.IpoHintCell  := ExtMsg;
        // 1. �����ڵ�
        IPOData.IpoIssueCode := Trim(XLSheet.Cells[iRow, IDX_IPO_ISSUE_CODE]);
        // 2. ���¹�ȣ
        IPOData.IpoAccNo     := sTemp;

        // StrtoFloat�� ��ȯ �Ҷ� �� ������ ������ -> if������ ó��
        if (Trim(XLSheet.Cells[iRow, IDX_IPO_QTY]) = '') then
          dIpoQTy := 0
        else
          dIpoQTy := StrToFloat(Trim(XLSheet.Cells[iRow, IDX_IPO_QTY]));
        // 3. ����
        IPOData.IpoQty       := dIpoQTy;

        // StrtoFloat�� ��ȯ �Ҷ� �� ������ ������ -> if������ ó��
        if (Trim(XLSheet.Cells[iRow, IDX_IPO_COMM]) = '') then
          dIpoComm := 0
        else
          dIpoComm := StrToFloat(Trim(XLSheet.Cells[iRow, IDX_IPO_COMM]));
        // 4. ������
        IPOData.IpoComm      := dIpoComm;

        // 5. û����
        if (Length(Trim(XLSheet.Cells[iRow, IDX_IPO_DATE])) = 8) then
          IPOData.IpoDate  := Trim(XLSheet.Cells[iRow, IDX_IPO_DATE])
        else
          IPOData.IpoDate  := '';

        sIssueCode := Trim(XLSheet.Cells[iRow, IDX_IPO_ISSUE_CODE]);
        sAccNo := Trim(XLSheet.Cells[iRow, IDX_IPO_ACC_NO]);

        if ((Trim(XLSheet.Cells[iRow+1, IDX_IPO_ISSUE_CODE]) = '') and
            (Trim(XLSheet.Cells[iRow+1, IDX_IPO_ACC_NO]) = '')     and
            (Trim(XLSheet.Cells[iRow+1, IDX_IPO_QTY]) = '')        and
            (Trim(XLSheet.Cells[iRow+1, IDX_IPO_COMM]) = '')       and
            (Trim(XLSheet.Cells[iRow+1, IDX_IPO_DATE]) = ''))      then
        begin
          bData := False;
        end;

      end;

      if (iRecordCnt < 1) then
      begin
        gf_ShowMessage(MessageBar, mtInformation, 0, '���Ͽ� ������ �������� �ʽ��ϴ�.');
        exit;
      end;

      if ((FIssueCodeList.Count > 0) or (FAccNoList.Count > 0)) then
      begin
        CompareData_Query(FIssueCodeList, FAccNoList);
      end else begin
        gf_ShowMessage(MessageBar, mtError, 0, '�����ڵ�� ���¹�ȣ�� Ȯ���ϼ���');
        exit;
      end;

    except
      on E : Exception do
      begin
        gf_ShowMessage(MessageBar, mtError, 0, 'Excel Error : ' + IntToStr(iRecordCnt) + ' ��° �� '+  E.Message);
        Screen.Cursor := crDefault;
        Exit;
      end;
    end;
  finally
    if (not VarIsEmpty(XL)) then begin
      XL.IgnoreRemoteRequests := false;
      if (not VarIsEmpty(XL.ActiveWorkBook)) then
        XL.ActiveWorkBook.Close;
      XL.Quit;
    end;

    XLSheet := Unassigned;
    XLBook  := Unassigned;
    XL      := Unassigned;

    if (Assigned(FIssueCodeList)) then
      FreeAndNil(FIssueCodeList);
    if (Assigned(FAccNoList)) then
      FreeAndNil(FAccNoList);
  end;

end;

//------------------------------------------------------------------------------
// Data Check ( ���� ����, �ߺ� )
//------------------------------------------------------------------------------
function TDlgForm_XLInput.DataCheck: Boolean;
var
  i, j: integer;
  RecCnt: integer;
  IPOData :pIPOData;
  IssueInfo : pIssueInfo;
  sIpoSeq , sAccNo, sSubAccNo :string;
  ExtMsg : string;
  IssueCode, AccNo : string;
begin
  Result:= False;
  RecCnt:= 0;
  
  // IPORecord �߸��� ���¹�ȣ üũ
  if (ErrAccNoList.Count > 0) then
  begin
    for i:= 0 to ErrAccNoList.Count-1 do
    begin
      for j:= 0 to iRecordCnt-1 do
      begin
        IPOData:= IPOList.Items[j];
        ExtMsg:= '';
        if (IPOData.IpoAccNo = ErrAccNoList.Strings[i]) then
        begin
          IPOData.IpoConfirm := 'X';
          ExtMsg := '���¹�ȣ�� �������� �ʽ��ϴ�.';
          IPOData.IpoHintCell := IPOData.IpoHintCell + ExtMsg;
        end;
      end;
    end;
  end;

  // IPORecord �߸��� �����ڵ� üũ
  if (ErrIssueCodeList.Count > 0) then
  begin
    for i:= 0 to ErrIssueCodeList.Count-1 do
    begin
      for j:= 0 to iRecordCnt-1 do
      begin
        IPOData:= IPOList.Items[j];
        ExtMsg:= '';
        if (IPOData.IpoIssueCode = ErrIssueCodeList.Strings[i]) then
        begin
          IPOData.IpoConfirm := 'X';
          ExtMsg := '�����ڵ尡 �������� �ʽ��ϴ�.';
          if IPOData.IpoHintCell <> '' then
            IPOData.IpoHintCell := IPOData.IpoHintCell + chr(10) + chr(13) + ExtMsg
          else
            IPOData.IpoHintCell := IPOData.IpoHintCell + ExtMsg;
        end;
      end;
    end;
  end;

  // ������, ��������, �����ݾ� �ֱ�
  for i:= 0 to iRecordCnt-1 do
  begin
    IPOData:= IPOList.Items[i];

    IPOData.IpoSeq := '';
    IPOData.IpoAmt := 0;
    IPOData.IpoCommRate := 0;

    // XLOpen()���� Cell�� ������ Cell�� üũ
    if IPOData.IpoConfirm = 'O' then
    begin
      for j:=0 to IssueInfoList.Count-1 do
      begin
        IssueInfo:= IssueInfoList.Items[j];

        // IssueCode, Seq, Amt üũ �� ���
        if (IPOData.IpoIssueCode = IssueInfo.IpoIssueCode) then
        begin
          IPOData.IpoSeq := IssueInfo.IpoIssueSeq;
          IPOData.IpoCommRate := IssueInfo.IpoCommRate;
          IPOData.IpoAmt := IPOData.IpoQty * Issueinfo.IpoIssuePrice;

          if ((IssueInfo.IpoCommRate > 0) and
               (IPOData.IpoComm <= 0)      and
               (IPOData.IpoAmt > 0)) then
          begin
            IPOData.IpoComm := IPOData.IpoAmt * IPOData.IpoCommRate;
          end;

          break;
        end;
      end;
    end;
   end;

  //���ϳ� �ߺ� ������ üũ
  for i:= 0 to iRecordCnt-1 do
  begin
    IPOData:= IPOList.Items[i];
    if (IPOData.IpoConfirm = 'O') then
    begin
      IssueCode := IPOData.IpoIssueCode;
      AccNo := IPOData.IpoAccNo;

      IPOData.IpoOverLapCnt := IPOData.IpoOverLapCnt + FileOverlapCheck(IssueCode, AccNo);

      // IpoOverLapCnt = 0 - ���� üũ �κп��� ���͸� �� ������
      // IpoOverLapCnt = 1 - ���� ������
      // IpoOverLapCnt > 1 - ���� ������ ��ġ�� ������
      if (IPOData.IpoOverLapCnt > 1) then
      begin
        IPOData.IpoConfirm  := 'X';
        IPOData.IpoHintCell := '���ϳ��� ���� ������ �����մϴ�.';
      end;
    end;
  end;

  // �ߺ� ������ üũ
  with ADOQuery_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' SELECT IPO_SEQ, ACC_NO, SUB_ACC_NO       '+
            ' FROM SETRADE_IPO                         '+
            ' WHERE ');
    for i:= 0 to iRecordCnt-2 do
    begin
      IPOData:= IPOList.Items[i];

      sIpoSeq := IPOData.IpoSeq;
      sAccNo  := IPOData.IpoAccNo;
      sSubAccNo := '';

      SQL.Add(' (DEPT_CODE = '''+ gvDeptCode +'''  '+
              ' AND    IPO_SEQ = '''+ sIpoSeq +'''     '+
              ' AND     ACC_NO = '''+ sAccNo +'''      '+
              ' AND SUB_ACC_NO = '''+ sSubAccNo +''') OR   ');

    end;

    IPOData:= IPOList.Items[iRecordCnt-1];
    sIpoSeq := IPOData.IpoSeq;
    sAccNo  := IPOData.IpoAccNo;
    sSubAccNo := '';

    SQL.Add(' (DEPT_CODE = '''+ gvDeptCode +''''+
              ' AND    IPO_SEQ = '''+ sIpoSeq +''''+
              ' AND     ACC_NO = '''+ sAccNo +''''+
              ' AND SUB_ACC_NO = '''+ sSubAccNo +''')' +
              'ORDER BY IPO_SEQ');

    Try
      gf_ADOQueryOpen(ADOQuery_Temp);
    Except
    on E : Exception do
       begin
          gf_ShowErrDlgMessage(Self.Tag, 9001,  // Database ����
                     'ADOQuery_Temp[DataCheck()]: ' + E.Message, 0);
          gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[DataCheck()]'); //Database ����
          Exit;
       end;
    end;

    while not Eof do
    begin
      for i:= 0 to iRecordCnt-1 do
      begin
        IPOData:= IPOList.Items[i];
        if ((IPOData.IpoConfirm = 'O') and
           (IPOData.IpoSeq = Trim(FieldByName('IPO_SEQ').AsString)) and
           (IPOData.IpoAccNo = Trim(FieldByName('ACC_NO').AsString))) then
        begin
          IPOData.IpoConfirm  := 'X';
          IPOData.IpoHintCell := '���������� �ش� ������ �����մϴ�.';
        end;
      end;
      Next;
    end;
  end;

  DispStringGrid;

  Result:= True;
end;

//------------------------------------------------------------------------------
// ���ϳ� �ߺ� ������ üũ
//------------------------------------------------------------------------------
function TDlgForm_XLInput.FileOverlapCheck(sIssueCode, sAccNo: string): integer;
var
  i: integer;
  iCnt : integer;
  TempItem : pIPOData;
begin
  iCnt:= 0;
  for i:= 0 to iRecordCnt -1  do
  begin
    TempItem := IPOList.Items[i];
    if ((sIssueCode = TempItem.IpoIssueCode) and
        (sAccNo     = TempItem.IpoAccNo)) then
    begin
      Inc(iCnt);
    end;
  end;
  Result := iCnt;
end;

//------------------------------------------------------------------------------
// StringGrid �� ���
//------------------------------------------------------------------------------
procedure TDlgForm_XLInput.DispStringGrid;
var
  iRow: integer;
  IPOData :pIPOData;
begin
  DRStringGrid_InputInfo.RowCount := iRecordCnt+1;
  iErrCnt:= 0;
  iData:= 0;
  try
    with DRStringGrid_InputInfo do
    begin
      for iRow:= 0 to iRecordCnt-1 do
      begin

        IPOData:= IPOList.Items[iRow];
        HintCell[DP_IDX_IPO_CONFIRM-1, iRow+1] := '';
        // IssueCode
        Cells[DP_IDX_IPO_ISSUE_CODE-1, iRow+1] := IPOData.IpoIssueCode;
        // AccNo
        Cells[DP_IDX_IPO_ACC_NO-1    , iRow+1] := IPOData.IpoAccNo;
        // Qty
        Cells[DP_IDX_IPO_QTY-1       , iRow+1] := gf_FormatNumberToIntDec(IPOData.IpoQty);
        // Comm
        Cells[DP_IDX_IPO_COMM-1      , iRow+1] := gf_FormatNumberToIntDec(IPOData.IpoComm);
        // CommRate
        Cells[DP_IDX_IPO_COMM_RATE-1 , iRow+1] := gf_FormatNumberToIntDec(IPOData.IpoCommRate) + ' %';
        // Amt
        Cells[DP_IDX_IPO_AMT-1       , iRow+1] := gf_FormatNumberToIntDec(IPOData.IpoAmt);
        // SbDate
        if (Length(IPOData.IpoDate) = 8) then
          Cells[DP_IDX_IPO_DATE-1      , iRow+1] := gf_FormatDate(IPOData.IpoDate)
        else
          Cells[DP_IDX_IPO_DATE-1      , iRow+1] := '���Է�';
        // Confirm
        Cells[DP_IDX_IPO_CONFIRM-1   , iRow+1] := IPOData.IpoConfirm;

        ColorRow[iRow+1] := gcGridBackColor;

        if (UpperCase(IPOData.IpoConfirm) = 'X') then
        begin
          ColorRow[iRow+1] := gcGridTotSumColor;
          HintCell[DP_IDX_IPO_CONFIRM-1, iRow+1] := IPOData.IpoHintCell;
          // MessageDlg ��� ���ǹ��� ���
          Inc(iErrCnt);
        end;
      end;
    end;
  except
    on E : Exception do
    begin
      gf_ShowErrDlgMessage(Self.Tag, 0, '[DispStringGrid()]:' + IntToStr(iRow) + ' ��° �� ' + e.Message, 0);
      gf_ShowMessage(MessageBar, mtError, 0, '[DispStringGrid()]:' + IntToStr(iRow) + ' ��° �� '  + e.Message);

      Exit;
    end;
  end;
  gf_ShowMessage(MessageBar, mtInformation, 0,
                  '��ȸ���� : ' + IntToStr(iRecordCnt) + ' ��, '
                + '���� : '     + IntToStr(iErrCnt) + ' ��');
end;

//------------------------------------------------------------------------------
// �Է��Ϸ��� �����ڵ� & ���¹�ȣ DB���� üũ �� ��������
//------------------------------------------------------------------------------
procedure TDlgForm_XLInput.CompareData_Query(FIssueCodeList, FAccNoList: TStringList);
var
  i, j : integer;
  bChk : Boolean;
  IssueInfo : pIssueInfo;
  DBAccNoList : TStringList;
begin
  IssueInfoList := TList.Create;
  DBAccNoList := TStringList.Create;

  // ���� �� �����ڵ� & ���¹�ȣ �з� ����
  bChk := False;

  try
    try
      // �������� ��������
      if (FIssueCodeList.Count > 0) then
      begin
        with ADOQuery_ICodeCheck do
        begin
          CLose;
          SQL.Clear;
          SQL.Add(' SELECT ISSUE_CODE, IPO_SEQ, IPO_PRICE, IPO_COMM_RATE FROM SCISSIF_IPO ');
          SQL.Add('WHERE (');

          for i:= 0 to FIssueCodeList.Count-2 do
          begin
            SQL.Add(' ISSUE_CODE = ''' + FIssueCodeList.Strings[i] + ''' OR ');
          end;
          SQL.Add(' ISSUE_CODE = ''' + FIssueCodeList.Strings[FIssueCodeList.Count-1] + ''')'+
                  ' AND ISSUE_CODE <> '''' ' +
                  ' AND DEPT_CODE = ''' + gvDeptCode +'''');
          SQL.Add(' ORDER BY ISSUE_CODE');

          gf_ADOQueryOpen(ADOQuery_ICodeCheck);

          // ��������(�ڵ�, Seq, �ܰ�, ��������) Record�� ����
          while not EOF do
          begin
            New(IssueInfo);
            IssueInfoList.Add(IssueInfo);

            IssueInfo.IpoIssueCode  := Trim(FieldByName('ISSUE_CODE').AsString);
            IssueInfo.IpoIssueSeq   := Trim(FieldByName('IPO_SEQ').AsString);
            IssueInfo.IpoIssuePrice := FieldByName('IPO_PRICE').AsFloat;
            IssueInfo.IpoCommRate   := FieldByName('IPO_COMM_RATE').AsFloat;

            Next;
          end;

          // DB�� �������� �ʴ� ���Ͼ� �����ڵ� �з�(TStringList�� ����)
          for i:= 0 to FIssueCodeList.Count-1 do
          begin
            bChk:= False;

            for j:= 0 to IssueInfoList.Count-1 do
            begin
              IssueInfo := IssueInfoList.Items[j];

              if (FIssueCodeList.Strings[i] = IssueInfo.IpoIssueCode) then
              begin
                bChk := True;
                Continue;
              end;
            end;

            if (not bChk) then
              ErrIssueCodeList.Add(FIssueCodeList.Strings[i]);
          end;
        end;
      end else begin
        raise Exception.Create('���� �� �����ڵ尡 �������� �ʽ��ϴ�.');
      end;

      // ���¹�ȣ ��������
      if (FAccNoList.Count > 0) then
      begin
        with ADOQuery_ANoCheck do
        begin
          Close;
          SQL.Clear;
          SQL.Add(' SELECT ACC_NO FROM SEACBIF_TBL ');
          SQL.Add('WHERE (');

          for i:= 0 to FAccNoList.Count-2 do
          begin
            SQL.Add(' ACC_NO = ''' + FAccNoList.Strings[i] + ''' OR ');
          end;
          SQL.Add(' ACC_NO = ''' + FAccNoList.Strings[FAccNoList.Count-1] + ''')'+
                  ' AND ACC_NO <> '''' '+
                  ' AND DEPT_CODE = ''' + gvDeptCode + '''');
          SQL.Add(' ORDER BY ACC_NO');

          gf_ADOQueryOpen(ADOQuery_ANoCheck);

          while not EOF do
          begin
            DBAccNoList.Add(Trim(FieldByName('ACC_NO').AsString));

            Next;
          end;

          // DB�� �������� �ʴ� ���Ͼ� ���¹�ȣ �з�(TStringList�� ����)
          for i:= 0 to FAccNoList.Count-1 do
          begin

            bChk:= False;

            for j:= 0 to DBAccNoList.Count-1 do
            begin
              if (FAccNoList.Strings[i] = DBAccNoList.Strings[j]) then
              begin
                bChk := True;
                Continue;
              end;
            end;

            if (not bChk) then
              ErrAccNoList.Add(FAccNoList.Strings[i]);
          end;
        end;
      end else begin
        raise Exception.Create('���� �� ���¹�ȣ�� �������� �ʽ��ϴ�.');
      end;

      if (not DataCheck) then
      begin
        gf_ShowErrDlgMessage(Self.Tag, 0, '������ üũ �����Դϴ�.', 0);
        Exit;
      end;

    except
      on E : Exception do
      begin
          gf_ShowErrDlgMessage(Self.Tag, 0,  // Database ����
                     '[CompareData_Query()]: ' + E.Message, 0);
          gf_ShowMessage(MessageBar, mtError, 0, '[CompareData_Query()]:' + E.Message); //Database ����
          Exit;
      end;
    end;

  finally
    if (Assigned(DBAccNoList)) then
      FreeAndNil(DBAccNoList);
  end;

end;

//------------------------------------------------------------------------------
// FormCreate
//------------------------------------------------------------------------------
procedure TDlgForm_XLInput.FormCreate(Sender: TObject);
begin
  inherited;

  DRSpeedBtn_FileName.Enabled := True;
  DREdit_FileName.Text := '';
  DRStringGrid_InputInfo.RowCount := 2;
  DRStringGrid_InputInfo.Rows[1].Clear;
  MessageBar.ClearMessage;

end;

//------------------------------------------------------------------------------
// �Ҵ� ���� �ڿ� ���� ��ȯ
//------------------------------------------------------------------------------
procedure TDlgForm_XLInput.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;

  //TList
  if (Assigned(IPOList)) then
    FreeAndNil(IPOList);
  if (Assigned(ErrIssueCodeList)) then
    FreeAndNil(ErrIssueCodeList);
  if (Assigned(ErrAccNoList)) then
    FreeAndNil(ErrAccNoList);
  if (Assigned(IssueInfoList)) then
    FreeAndNil(IssueInfoList);

  // ADO
  if (Assigned(ADOQuery_ICodeCheck)) then
  begin
    ADOQuery_ICodeCheck.Close;
    ADOQuery_ICodeCheck.Free;
  end;
  if (Assigned(ADOQuery_ANoCheck)) then
  begin
    ADOQuery_ANoCheck.Close;
    ADOQuery_ANoCheck.Free;
  end;
  if (Assigned(ADOQuery_Main)) then
  begin
    ADOQuery_Main.Close;
    ADOQuery_Main.Free;
  end;
  if (Assigned(ADOQuery_Temp)) then
  begin
    ADOQuery_Temp.Close;
    ADOQuery_Temp.Free;
  end;

end;

//------------------------------------------------------------------------------
// ���� ������ �Է� �� ȭ�� ����(Close)
//------------------------------------------------------------------------------
procedure TDlgForm_XLInput.DRButton_ImportClick(Sender: TObject);
var
  i: integer;
  iListCnt, TotErrCnt: integer;
  iMeaageResult : integer;
  IPOData :pIPOData;
  sIpoSeq, sAccNo, sSubAccNo, sSbDate : string;
  sFileName : string;
  dIpoQty, dIpoComm, dIpoAmt : double;
  iBfCnt, iAfCnt, iTotCnt : Integer;
begin
  inherited;

  sIpoSeq   := '';
  sAccNo    := '';
  sSubAccNo := '';
  sSbDate   := '';
  iListCnt := 0;
  dIpoQty  := 0;
  dIpoComm := 0;
  dIpoAmt  := 0;
  iTotCnt  := 0;
  TotErrCnt := iErrCnt;
  // 0, 1 : �Է� (0�� ��� ������ ��� ����, 1�� ��� ���� ������ ������ �Է�)
  // 2 : ���
  iMeaageResult := 0;

  // Ok : 1
  // Cancle : 2
  if (iErrCnt > 0) then
    iMeaageResult:= MessageDlg('�߸��� ������ (' + IntToStr(iErrCnt) + ' ��) �� �����մϴ�.' + Chr(10) + chr(13) +
                             '�����ϰ� �Է��Ͻðڽ��ϱ�? ', mtWarning, [mbOK, mbCancel], 0);

  if (iMeaageResult < 2) then
  begin
    gf_ShowMessage(MessageBar, mtError, 1010, ''); // �Է� ���Դϴ�.

    if (IPOList.Count = 0) then
    begin
      gf_ShowMessage(MessageBar, mtError, 0, '�ڷᰡ �������� �ʽ��ϴ�.');
      exit;
    end;

    DisableForm;

    // �Է��ϱ� �� �Ÿų��� ����
    iBfCnt := TradeCount_QueryOpen;

    with ADOQuery_Main do
    begin
      Close;
      SQL.Clear;
      for i:= 0 to IPOList.Count -1 do
      begin
        IPOData:= IPOList.Items[i];

        if (IPOData.IpoConfirm = 'O') then
        begin
          sIpoSeq := IPOData.IpoSeq;
          sAccNo  := IPOData.IpoAccNo;
          sSbDate := IPOData.IpoDate;

          dIpoQty  := IPOData.IpoQty;
          dIpoComm := IPOData.IpoComm;
          dIpoAmt  := IPOData.IpoAmt;

          SQL.Add('  INSERT INTO SETRADE_IPO      '+
                  '   (DEPT_CODE, '+
                  '    IPO_SEQ, '+
                  '    ACC_NO, '+
                  '    SUB_ACC_NO, '+
                  '    SB_DATE, '+
                  '    IPO_QTY, '+
                  '    IPO_AMT, '+
                  '    COMM, '+
                  '    OPR_ID, '+
                  '    OPR_DATE, '+
                  '    OPR_TIME) '+
                  ' VALUES '+
                  '   (''' + gvDeptCode    + ''', '+
                  '    ''' + sIpoSeq       + ''', '+
                  '    ''' + sAccNo        + ''', '+
                  '    ''' + sSubAccNo     + ''', '+
                  '    ''' + sSbDate       + ''', '+
                  '    '   + FloatToStr(dIpoQty)   + ', '+
                  '    '   + FloatToStr(dIpoAmt)   + ', '+
                  '    '   + FloatToStr(dIpoComm)  + ', '+
                  '    ''' + gvOprUsrNo    + ''', '+
                  '    ''' + gf_GetCurDate + ''', '+
                  '    ''' + gf_GetCurTime + ''')');

          Inc(iListCnt);
        end;
      end;

      Try
        if iListCnt < 1 then
        begin
          gf_ShowMessage(MessageBar, mtError, 0, '�Է� �Ϸ� : 0 ��');
          EnableForm;
          Exit
        end else
        begin
          gf_ADOExecSQL(ADOQuery_Main);
        end;

      Except
        on E : Exception do
        begin
           gf_ShowErrDlgMessage(Self.Tag, 9001,  // Database ����
                                         'ADOQuery_Main[INSERT]: ' + E.Message, 0);
           gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Main[INSERT]'); //Database ����
           EnableForm;
           Exit;
        end;
      End;

    end;

    iAfCnt := TradeCount_QueryOpen;
    if iAfCnt >= iBfCnt then
      iTotCnt := iAfCnt - iBfCnt;

    sFileName := Trim(DREdit_FileName.Text);
    XLOpen(sFileName);

    gf_ShowMessage(MessageBar, mtInformation, 1011, '�� ' + IntToStr(iTotCnt) +
                                        '�� (���� ' + IntToStr(TotErrCnt) + '��)');//, �ߺ� ' + IntToStr(iData) + '��)'); //�Է� �Ϸ�
  end
  else if iMeaageResult = 2 then
    gf_ShowMessage(MessageBar, mtInformation, 0, '�Է� ���'); //�Է� ���


  EnableForm;

end;

end.
