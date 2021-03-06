unit Test1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UCrpe32, ADODB, ComObj, ADOInt, ExtCtrls, SCCPreviewForm, SCCGlobalType,
  StrUtils, DB, SCCLib;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    InputMemo: TMemo;
    Panel2: TPanel;
    OutputMemo: TMemo;
    ADOConnection_TFJS: TADOConnection;
    ADOQuery_GetData: TADOQuery;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Button4: TButton;
    Edit1: TEdit;
    Button3: TButton;
    Button2: TButton;
    Button1: TButton;
    Button_CreateRecSet: TButton;
    Button5: TButton;
    Edit2: TEdit;
    Button6: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button_CreateRecSetClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
    RecSet: _Recordset;  //declare recordset
    procedure Log(KeyWord, s: String);
    procedure GetDLL;
    procedure ClearDataList;
  public
    { Public declarations }
    procedure SetColumnList;
    procedure StrToCol;
  end;

  TDataRec = Record
    ArrCol : Array of String;
  end;
  DataRec = ^TdataRec;

var
  Form1: TForm1;
  Crpe1 : TCrpe;
  adoRs : _Recordset;
  ColStrList: TStringList;

  DataList : TList;

  OneDataList: TStringList;

implementation

uses Math;

var
  ColCount, RealColCount: Integer;
  DataCount: Integer;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  InputMemo.Clear;
  OutputMemo.Clear;
  Edit1.Clear;
  Edit2.Clear;

  Crpe1 := TCrpe.Create(nil);
  Crpe1.ReportName := 'C:\SettleNetTF\Test\rpt\Test_Report.rpt';

  ColStrList := TStringList.Create;
  OneDataList := TStringList.Create;
  DataList := TList.Create;
end;

procedure TForm1.ClearDataList;
var
  I : Integer;
  Data : DataRec;
begin
  if not Assigned(DataList) then Exit;
  for I := 0 to DataList.Count -1 do
  begin
    Data := DataList.Items[I];
    Dispose(Data);
  end;
  DataList.Clear;
end;

procedure TForm1.Button_CreateRecSetClick(Sender: TObject);
var
  i, j: Integer;
  varCol, varDat: Variant;
  Data : DataRec;
  tmpArrCol, tmpArrData : Array of Variant;
  StartTime, FinishTime: TDateTime;
begin
  ClearDataList;

  StartTime := Now;
  Log('RecordSet', 'Start to set Records, Time: ' + FormatDateTime('hh:mm:ss:mm', StartTime));

//  StrToCol;
//
//  if (DataList.Count < 1) then
//  begin
//    Log('RecordSet', 'No data !!! - data Count: ' + IntToStr(DataList.Count));
//    Exit;
//  end;


  Crpe1 := TCrpe.Create(nil);
  Crpe1.ReportName := 'C:\SettleNetTF\Test\rpt\Test_Report2.rpt';

  begin
  //recordset is com object create recordset
    RecSet:= CreateComObject(CLASS_Recordset) as _Recordset;

    Log('RecordSet', 'Before Fields-Append, Time: ' + FormatDateTime('hh:mm:ss:mm', Now));
  //add fields (field types in adoint.pas)
    for i := 0 to ColCount - 1 do
    begin
      olevariant(RecSet).Fields.Append(ColStrList.Strings[i],adVarWChar,3000,0);
    end;
    Log('RecordSet', 'After Fields-Append, Time: ' + FormatDateTime('hh:mm:ss:mm', Now));

  //open empty recordset
    olevariant(RecSet).open;
  end;

  Log('RecordSet', 'Before set column array, Time: ' + FormatDateTime('hh:mm:ss:mm', Now));
//  SetLength(tmpArrCol, ColCount);
//  for i:= 0 to Length(tmpArrCol) - 1 do
//  begin
//    tmpArrCol[i] := ColStrList.Strings[i];
//  end;

SetLength(tmpArrCol, 1);
tmpArrCol[0]:= ColStrList.Strings[0];
  varCol := vararrayof(tmpArrCol);
  Log('RecordSet', 'After set column array, Time: ' + FormatDateTime('hh:mm:ss:mm', Now));

  Log('RecordSet', 'Before set Data array, Time: ' + FormatDateTime('hh:mm:ss:mm', Now));
SetLength(tmpArrData, ColCount);
tmpArrData[0]:= OneDataList.Strings[0];
varDat := vararrayof(tmpArrData);
RecSet.AddNew(varCol, varDat);
//  SetLength(tmpArrData, ColCount);
//  for i:= 0 to DataList.Count - 1 do
//  begin
//    Data := DataList.Items[i];
//
//    for j:= 0 to ColCount - 1 do
//    begin
//      if j < RealColCount then tmpArrData[j] := Data.ArrCol[j]
//      else tmpArrData[j] := '';
//    end;
//
////    tmpArrData[0] := Data.Col1;
////    tmpArrData[1] := Data.Col2;
////    tmpArrData[2] := Data.Col3;
////    tmpArrData[3] := Data.Col4;
////    tmpArrData[4] := Data.Col5;
////    tmpArrData[5] := Data.Col6;
//
//    varDat := vararrayof(tmpArrData);
//    RecSet.AddNew(varCol, varDat);
//  end;
  Log('RecordSet', 'After set Data array, Time: ' + FormatDateTime('hh:mm:ss:mm', Now));

  FinishTime := Now;
  Log('RecordSet', 'Finish to set Records, Time: ' + FormatDateTime('hh:mm:ss:mm', FinishTime));

  Log('RecordSet', 'Succed to Set Records, Required Time(Start - Finish): '
       + FormatDateTime('hh:mm:ss:mm', StartTime - FinishTime)
       + ' --- Column Count: ' + IntToStr(Length(tmpArrData))
       + ', Data Count: '      + IntToStr(DataList.Count));
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  StartTime, FinishTime: TDateTime;
begin
  with Crpe1 do
  begin
    StartTime := Now;
    Log('Crpe', 'Start to Crystal Reports data mapping, Time: '+ FormatDateTime('hh:mm:ss:mm', StartTime));

    adoRs := RecSet as AdoInt.Recordset;
    Tables[0].DataPointer := @adoRs;

    FinishTime := Now;
    Log('Crpe', 'Finish to Crystal Reports data mapping, Time: ' + FormatDateTime('hh:mm:ss:mm', FinishTime));

    Log('Crpe', 'Succed to map Crystal Reports data, Required Time(Start - Finish): ' + FormatDateTime('hh:mm:ss:mm', StartTime - FinishTime));

    StartTime := Now;
    Log('Crpe', 'Start to Crystal Reports Program: ' + FormatDateTime('hh:mm:ss:mm', StartTime));
    if not Assigned(RepForm_Preview) then
    begin
       Application.CreateForm(TRepForm_Preview, RepForm_Preview);
       RepForm_Preview.Parent := Form1;//gvMainFrame;
    end;
    RepForm_Preview.TmpRptFileName := 'C:\SettleNetTF\Test\rpt\Test_Report.rpt';

    Printer.Clear;
    Output := toWindow;
    WindowZoom.Magnification := 100;//gvPreviewPercent;

    try
       Execute;
    Except
    on E : Exception do
       begin
          gvErrorNo := 8003;    //Preview Execute 오류
          gvExtMsg := E.Message;
          RepForm_preview.Close;
          screen.cursor := crDefault;
          Exit;
       end;
    end; //try
    RepForm_preView.Total.Caption  := ' ' + inttostr(Pages.Count);
    RepForm_PreView.DREdit_CurPage.Text := '1';
  end;
  FinishTime := Now;

  Log('Crpe', 'Start to Crystal Reports Program: ' + FormatDateTime('hh:mm:ss:mm', FinishTime));
  Log('Crpe', 'Succed to excute Crystal Reports, Required Time(Start - Finish): ' + FormatDateTime('hh:mm:ss:mm', StartTime - FinishTime));
  Log('Crpe', 'Show Reports');
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ColStrList.Clear;
  ColStrList.Free;

  ADOQuery_GetData.Close;
  ADOQuery_GetData.Free;


  ClearDataList;

  if Assigned(Crpe1) then Crpe1.Free;
end;

procedure TForm1.StrToCol;
var
  i, j, iLastPos, iPos: Integer;
  sValue : String;
  Data : DataRec;
begin
  Log('StringToColumn', 'Start from one row to filed data.' + FormatDateTime('hh:mm:ss:mm', Now));
  try
    for j:= 0 to OneDataList.Count-1 do
    begin
      i := 0;
      iLastPos := 0;
      iPos := PosEx(#44, OneDataList.Strings[j], iLastPos + 1);

      New(Data);
      SetLength(Data.ArrCol, RealColCount);
      
      while iPos > 0 do
      begin
        inc(i);
        sValue := copy(OneDataList.Strings[j], iLastPos + 1, iPos - iLastPos - 1);

        Data.ArrCol[i-1] := trim(sValue);
        
//        case i of
//          1: Data.Col1 := trim(sValue);
//          2: Data.Col2 := trim(sValue);
//          3: Data.Col3 := trim(sValue);
//          4: Data.Col4 := StrToInt(trim(sValue));
//          5: Data.Col5 := trim(sValue);
//          6: Data.Col6 := StrToInt(trim(sValue));
//        end;
        iLastPos := iPos;
        iPos := PosEx(#44, OneDataList.Strings[j], iLastPos + 1);
      end;

      DataList.Add(Data);
    end;

  finally
    OneDataList.Clear;
    OneDataList.Free;
  end;
  Log('StringToColumn', 'Finish from one row to filed data.' + FormatDateTime('hh:mm:ss:mm', Now));
end;

procedure TForm1.Log(KeyWord, s: String);
begin
  OutputMemo.Text := OutputMemo.Text + '[' + KeyWord + '] : ' + S + Chr(13) + Chr(10);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  with ADOQuery_GetData do
  begin
    Log('DB','DataBase Connecting...');
    Connection := ADOConnection_TFJS;
    Log('DB', 'Succeed to DataBase Connected');
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i, j, iLastPos, iPos: Integer;
begin
  if OneDataList.Count > 0 then OneDataList.Clear;

  InputMemo.Clear;
  
  with ADOQuery_GetData do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM TEST');

    try
      gf_ADOQueryOpen(ADOQuery_GetData);             
      Log('DB', 'Data Count : ' + IntToStr(RecordCount));

      while not Eof do
      begin
        OneDataList.Add(Trim(FieldByName('COL_2').AsString));

        Next;
      end;

      i := 0;
      iLastPos := 0;
      iPos := PosEx(#44, OneDataList.Strings[0], iLastPos + 1);
      while iPos > 0 do
      begin
        inc(i);
        iLastPos := iPos;
        iPos := PosEx(#44, OneDataList.Strings[0], iLastPos + 1);
      end;

      RealColCount := i+1;

//      InputMemo.Lines := OneDataList;
    except
      on E:Exception do
      begin
        Log('DB', 'Error!! Can not open SQL Query' + e.Message);
        Exit;
      end;
    end;

  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  ColCount:= StrToInt(Edit1.Text);
  Log('Column', 'Column Count ' + Edit1.Text);

  // Set Column List
  SetColumnList;
end;

procedure TForm1.SetColumnList;
var
  i: Integer;
begin
  if ColStrList.Count > 0 then ColStrList.Clear;

  for i:= 1 to ColCount do
  begin
    ColStrList.Add('COL_' + IntToStr(i));
  end;
end;

procedure TForm1.GetDLL;
type
  TCall_TFFI_DLL = function: TList; stdcall;
  

const
  DLL_NAME = 'TFFI_DLL.dll';
var
  Call_TFFI_DLL : TCall_TFFI_DLL;
  DllHandle: THandle;
  DllPath: String;

  DllFuncName: String;
begin
  DllPath := 'C:\Users\jslee\Desktop\한투_금융상품\CrpeTest\Dll\';//ExtractFilePath(Application.ExeName) + '\Dll\';
  DllHandle:= LoadLibrary(pChar(DllPath + DLL_NAME));

  DllFuncName := 'ReturnRptCol';

//  ShowMessage(DllPath + DLL_NAME);
  @Call_TFFI_DLL := GetProcAddress(DllHandle, pChar(DllFuncName));

  try
    if @Call_TFFI_DLL <> nil then
    begin
      Call_TFFI_DLL;
    end



  finally

  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
//  GetDLL;
end;



procedure TForm1.Button6Click(Sender: TObject);
var
  i: Integer;
begin
  DataCount := StrToInt(Edit2.Text);
end;

end.
