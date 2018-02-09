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
// 청약 내역 갯수 가져오기
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
// 파일 오픈
//------------------------------------------------------------------------------
procedure TDlgForm_XLInput.DRSpeedBtn_FileNameClick(Sender: TObject);
begin
  InputFileOpen;
end;

//------------------------------------------------------------------------------
// 파일 경로 체크 및 INI파일에 저장
//------------------------------------------------------------------------------
procedure TDlgForm_XLInput.InputFileOpen;
var
  sDirName, sFileName : String;
  SearchRec : TSearchRec;
begin

  // INI 파일에서 경로 불러옴
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
  //INI 파일에 경로 저장
  gf_WriteFormStrInfo(Self.Name, 'Default Dir', sDirName);
  DREdit_FileName.Text := DROpenDialog_Input.FileName;

  sFileName := Trim(DREdit_FileName.Text);
  if (sFileName = '') then
  begin
    gf_showmessage(MessageBar, mtError, 1034, ''); // 파일을 선택하십시요
    Exit;
  end;

  { FindFirst - sFileName 경로에서 어떤 파일이든(faAnyFile) 찾아와라 : 찾으면 Return 0
   => 파일 존재하는지 확인하는 함수 : 파일 없으면 Retrun Error Code  }
  if (FindFirst(sFileName, faAnyFile, SearchRec) <> 0) then
  begin
    gf_ShowErrDlgMessage(Self.Tag, 1027, DREdit_FileName.Text, 0); //List 생성 오류
    gf_Showmessage(MessageBar, mtError, 1027, ''); // 해당 파일이 존재하지 않습니다.
    Screen.Cursor := crDefault;
    Exit;
  end;

  // Excel 파일 불러오기
  XLOpen(sFileName);
  Screen.Cursor := crDefault;

end;

//------------------------------------------------------------------------------
// Excel 파일 오픈 및 Record 값 입력
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
    gf_ShowMessage(MessageBar, mtError, 0, '청산 내역 List가 생성되지 않았습니다.');
    DRSpeedBtn_FileName.Enabled := false;
    Exit;
  end;

  if (not Assigned(ErrIssueCodeList)) then
  begin
    gf_ShowMessage(MessageBar, mtError, 0, 'ErrIssueList가 생성되지 않았습니다.');
    DRSpeedBtn_FileName.Enabled := false;
    Exit;
  end;

  if (not Assigned(ErrAccNoList)) then
  begin
    gf_ShowMessage(MessageBar, mtError, 0, 'ErrAccNoList가 생성되지 않았습니다.');
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

  //TStringList 중복문자 제거
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

      if ((Trim(XLSheet.Cells[iRow, IDX_IPO_ISSUE_CODE]) <> '종목코드') or
         (Trim(XLSheet.Cells[iRow, IDX_IPO_ACC_NO]) <> '계좌번호')      or
         (Trim(XLSheet.Cells[iRow, IDX_IPO_QTY]) <> '수량')             or
         (Trim(XLSheet.Cells[iRow, IDX_IPO_COMM]) <> '수수료')          or
         (Trim(XLSheet.Cells[iRow, IDX_IPO_DATE]) <> '청약일'))  then
      begin
        raise Exception.Create('엑셀 파일 양식 오류');
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

        // 종목코드 빈칸 체크
        if (Trim(XLSheet.Cells[iRow, IDX_IPO_ISSUE_CODE]) = '') then
        begin
          IPOData.IpoConfirm   := 'X';
          ExtMsg := '종목코드를 입력해 주십시오.';
        end;

        sTemp := Trim(XLSheet.Cells[iRow, IDX_IPO_ACC_NO]);
        // 계좌번호 빈칸 체크
        if (sTemp = '') then
        begin
          IPOData.IpoConfirm   := 'X';
          if ExtMsg <> '' then
            ExtMsg := ExtMsg + chr(10) + chr(13);
          ExtMsg := ExtMsg + '계좌번호를 입력해 주십시오.';
        end else begin
           sTemp := StringReplace(sTemp, '-', '', [rfReplaceAll]);
        end;

        // StringGrid HintCell
        IPOData.IpoHintCell  := ExtMsg;
        // 1. 종목코드
        IPOData.IpoIssueCode := Trim(XLSheet.Cells[iRow, IDX_IPO_ISSUE_CODE]);
        // 2. 계좌번호
        IPOData.IpoAccNo     := sTemp;

        // StrtoFloat형 변환 할때 빈값 나오면 에러남 -> if문으로 처리
        if (Trim(XLSheet.Cells[iRow, IDX_IPO_QTY]) = '') then
          dIpoQTy := 0
        else
          dIpoQTy := StrToFloat(Trim(XLSheet.Cells[iRow, IDX_IPO_QTY]));
        // 3. 수량
        IPOData.IpoQty       := dIpoQTy;

        // StrtoFloat형 변환 할때 빈값 나오면 에러남 -> if문으로 처리
        if (Trim(XLSheet.Cells[iRow, IDX_IPO_COMM]) = '') then
          dIpoComm := 0
        else
          dIpoComm := StrToFloat(Trim(XLSheet.Cells[iRow, IDX_IPO_COMM]));
        // 4. 수수료
        IPOData.IpoComm      := dIpoComm;

        // 5. 청약일
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
        gf_ShowMessage(MessageBar, mtInformation, 0, '파일에 내역이 존재하지 않습니다.');
        exit;
      end;

      if ((FIssueCodeList.Count > 0) or (FAccNoList.Count > 0)) then
      begin
        CompareData_Query(FIssueCodeList, FAccNoList);
      end else begin
        gf_ShowMessage(MessageBar, mtError, 0, '종목코드와 계좌번호를 확인하세요');
        exit;
      end;

    except
      on E : Exception do
      begin
        gf_ShowMessage(MessageBar, mtError, 0, 'Excel Error : ' + IntToStr(iRecordCnt) + ' 번째 줄 '+  E.Message);
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
// Data Check ( 존재 유무, 중복 )
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
  
  // IPORecord 잘못된 계좌번호 체크
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
          ExtMsg := '계좌번호가 존재하지 않습니다.';
          IPOData.IpoHintCell := IPOData.IpoHintCell + ExtMsg;
        end;
      end;
    end;
  end;

  // IPORecord 잘못된 종목코드 체크
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
          ExtMsg := '종목코드가 존재하지 않습니다.';
          if IPOData.IpoHintCell <> '' then
            IPOData.IpoHintCell := IPOData.IpoHintCell + chr(10) + chr(13) + ExtMsg
          else
            IPOData.IpoHintCell := IPOData.IpoHintCell + ExtMsg;
        end;
      end;
    end;
  end;

  // 시퀀스, 수수료율, 결제금액 넣기
  for i:= 0 to iRecordCnt-1 do
  begin
    IPOData:= IPOList.Items[i];

    IPOData.IpoSeq := '';
    IPOData.IpoAmt := 0;
    IPOData.IpoCommRate := 0;

    // XLOpen()에서 Cell중 정상인 Cell만 체크
    if IPOData.IpoConfirm = 'O' then
    begin
      for j:=0 to IssueInfoList.Count-1 do
      begin
        IssueInfo:= IssueInfoList.Items[j];

        // IssueCode, Seq, Amt 체크 및 계산
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

  //파일내 중복 데이터 체크
  for i:= 0 to iRecordCnt-1 do
  begin
    IPOData:= IPOList.Items[i];
    if (IPOData.IpoConfirm = 'O') then
    begin
      IssueCode := IPOData.IpoIssueCode;
      AccNo := IPOData.IpoAccNo;

      IPOData.IpoOverLapCnt := IPOData.IpoOverLapCnt + FileOverlapCheck(IssueCode, AccNo);

      // IpoOverLapCnt = 0 - 위에 체크 부분에서 필터링 된 데이터
      // IpoOverLapCnt = 1 - 정상 데이터
      // IpoOverLapCnt > 1 - 파일 내에서 겹치는 데이터
      if (IPOData.IpoOverLapCnt > 1) then
      begin
        IPOData.IpoConfirm  := 'X';
        IPOData.IpoHintCell := '파일내에 같은 정보가 존재합니다.';
      end;
    end;
  end;

  // 중복 데이터 체크
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
          gf_ShowErrDlgMessage(Self.Tag, 9001,  // Database 오류
                     'ADOQuery_Temp[DataCheck()]: ' + E.Message, 0);
          gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Temp[DataCheck()]'); //Database 오류
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
          IPOData.IpoHintCell := '기존내역에 해당 정보가 존재합니다.';
        end;
      end;
      Next;
    end;
  end;

  DispStringGrid;

  Result:= True;
end;

//------------------------------------------------------------------------------
// 파일내 중복 데이터 체크
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
// StringGrid 에 출력
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
          Cells[DP_IDX_IPO_DATE-1      , iRow+1] := '미입력';
        // Confirm
        Cells[DP_IDX_IPO_CONFIRM-1   , iRow+1] := IPOData.IpoConfirm;

        ColorRow[iRow+1] := gcGridBackColor;

        if (UpperCase(IPOData.IpoConfirm) = 'X') then
        begin
          ColorRow[iRow+1] := gcGridTotSumColor;
          HintCell[DP_IDX_IPO_CONFIRM-1, iRow+1] := IPOData.IpoHintCell;
          // MessageDlg 띄울 조건문에 사용
          Inc(iErrCnt);
        end;
      end;
    end;
  except
    on E : Exception do
    begin
      gf_ShowErrDlgMessage(Self.Tag, 0, '[DispStringGrid()]:' + IntToStr(iRow) + ' 번째 줄 ' + e.Message, 0);
      gf_ShowMessage(MessageBar, mtError, 0, '[DispStringGrid()]:' + IntToStr(iRow) + ' 번째 줄 '  + e.Message);

      Exit;
    end;
  end;
  gf_ShowMessage(MessageBar, mtInformation, 0,
                  '조회내역 : ' + IntToStr(iRecordCnt) + ' 건, '
                + '에러 : '     + IntToStr(iErrCnt) + ' 건');
end;

//------------------------------------------------------------------------------
// 입력하려는 종목코드 & 계좌번호 DB에서 체크 후 가져오기
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

  // 파일 내 종목코드 & 계좌번호 분류 변수
  bChk := False;

  try
    try
      // 종목정보 가져오기
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

          // 종목정보(코드, Seq, 단가, 수수료율) Record에 저장
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

          // DB에 존재하지 않는 파일안 종목코드 분류(TStringList에 저장)
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
        raise Exception.Create('파일 내 종목코드가 존재하지 않습니다.');
      end;

      // 계좌번호 가져오기
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

          // DB에 존재하지 않는 파일안 계좌번호 분류(TStringList에 저장)
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
        raise Exception.Create('파일 내 계좌번호가 존재하지 않습니다.');
      end;

      if (not DataCheck) then
      begin
        gf_ShowErrDlgMessage(Self.Tag, 0, '데이터 체크 오류입니다.', 0);
        Exit;
      end;

    except
      on E : Exception do
      begin
          gf_ShowErrDlgMessage(Self.Tag, 0,  // Database 오류
                     '[CompareData_Query()]: ' + E.Message, 0);
          gf_ShowMessage(MessageBar, mtError, 0, '[CompareData_Query()]:' + E.Message); //Database 오류
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
// 할당 받은 자원 최종 반환
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
// 최종 데이터 입력 후 화면 종료(Close)
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
  // 0, 1 : 입력 (0일 경우 데이터 모두 정상, 1일 경우 에러 데이터 있지만 입력)
  // 2 : 취소
  iMeaageResult := 0;

  // Ok : 1
  // Cancle : 2
  if (iErrCnt > 0) then
    iMeaageResult:= MessageDlg('잘못된 데이터 (' + IntToStr(iErrCnt) + ' 건) 가 존재합니다.' + Chr(10) + chr(13) +
                             '무시하고 입력하시겠습니까? ', mtWarning, [mbOK, mbCancel], 0);

  if (iMeaageResult < 2) then
  begin
    gf_ShowMessage(MessageBar, mtError, 1010, ''); // 입력 중입니다.

    if (IPOList.Count = 0) then
    begin
      gf_ShowMessage(MessageBar, mtError, 0, '자료가 존재하지 않습니다.');
      exit;
    end;

    DisableForm;

    // 입력하기 전 매매내역 갯수
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
          gf_ShowMessage(MessageBar, mtError, 0, '입력 완료 : 0 건');
          EnableForm;
          Exit
        end else
        begin
          gf_ADOExecSQL(ADOQuery_Main);
        end;

      Except
        on E : Exception do
        begin
           gf_ShowErrDlgMessage(Self.Tag, 9001,  // Database 오류
                                         'ADOQuery_Main[INSERT]: ' + E.Message, 0);
           gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_Main[INSERT]'); //Database 오류
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

    gf_ShowMessage(MessageBar, mtInformation, 1011, '총 ' + IntToStr(iTotCnt) +
                                        '건 (에러 ' + IntToStr(TotErrCnt) + '건)');//, 중복 ' + IntToStr(iData) + '건)'); //입력 완료
  end
  else if iMeaageResult = 2 then
    gf_ShowMessage(MessageBar, mtInformation, 0, '입력 취소'); //입력 취소


  EnableForm;

end;

end.
