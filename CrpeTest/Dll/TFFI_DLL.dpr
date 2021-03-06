// [L.J.S] 2017.12.27 한투금상 CRPE DLL TEST FILE

library TFFI_DLL;

uses
  SysUtils,
  Windows,
  Classes,
  Dialogs;

const
  gcRPT_A_COLUMN_COUNT = 10;

  // [x, 0] -> 컬럼 이름
  // [x, 1] -> 컬럼 타입
  // [x, 2] -> 컬럼 사이즈
  // [x, 3] -> 컬럼 소수점
  gvRpt_A_ColArr:
    array[gcRPT_A_COLUMN_COUNT * 4] of String =  ('COL_1',  'string', '1000', '',
                                                  'COL_2',  'string', '500',  '',
                                                  'COL_3',  'double', '21',   '7',
                                                  'COL_4',  'double', '21',   '2',
                                                  'COL_5',  'string', '100',  '',
                                                  'COL_6',  'string', '100',  '',
                                                  'COL_7',  'string', '100',  '',
                                                  'COL_8',  'string', '100',  '',
                                                  'COL_9',  'string', '100',  '',
                                                  'COL_10', 'string', '100',  '');

type
  pRptCol = ^TRptCol;
  TRptCol = record
    ColCnt : Integer;
    ColArr : array of array of string;
  end;

var
  recRptCol : pRptCol;

{$R *.res}

procedure SetColRec;
var
  i, j: integer;
begin
//  New(recRptCol);
//
//  SetLength(recRptCol.ColArr, gcRPT_A_COLUMN_COUNT);
//
//  for i:= 0 to gcRPT_A_COLUMN_COUNT - 1 do
//  begin
//    SetLength(recRptCol.ColArr[0], 4);
//  end;
//
//  for i:= 0 to gcRPT_A_COLUMN_COUNT - 1 do
//  begin
//    for j:= 0 to 3 do
//    begin
//      recRptCol.ColArr[i, j] := gvRpt_A_ColArr[i, j];
//    end;
//  end;
//
//  recRptCol.ColCnt := gcRPT_A_COLUMN_COUNT;

end;

function ReturnRptCol: pRptCol; stdcall;
var
  i, j: Integer;
  tmp : array of array of String;
begin
//  SetColRec;
  SetLength(tmp, gcRPT_A_COLUMN_COUNT);

  for i:= 0 to gcRPT_A_COLUMN_COUNT - 1 do
  begin
    SetLength(tmp[0], 4);
  end;

  for i:= 0 to gcRPT_A_COLUMN_COUNT - 1 do
  begin
    for j:= 0 to 3 do
    begin
      tmp[i, j] := gvRpt_A_ColArr[i, j];
    end;
  end;

  ShowMessage(tmp[1,0]);

//  Dispose(recRptCol);
end;

exports
  ReturnRptCol;

begin
end.
