//==============================================================================
//  [LMS] 2000/09/25
//==============================================================================

unit SCCAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, DRAdditional, DRStandard, ExtCtrls, ShellApi, TlHelp32,
  Grids, DRStringgrid, Db, ADODB, ComCtrls, IniFiles, SCCCmuLib, SCCTcpIp,
  ZipMstr19;

type
  TForm_About = class(TForm)
    DRPanel1: TDRPanel;
    DRLabel1: TDRLabel;
    DRLabel_Version: TDRLabel;
    DRBitBtn1: TDRBitBtn;
    DRLabel3: TDRLabel;
    DRLabel_DataRoadUrl: TDRLabel;
    DRLabel2: TDRLabel;
    DRPanel3: TDRPanel;
    DRLabel_ServerInfo: TDRLabel;
    DRLabel_DBInfo: TDRLabel;
    DRLabel_Used: TDRLabel;
    DRLabel_CPU: TDRLabel;
    DRLabel_memory: TDRLabel;
    DRLabel_VerSync: TDRLabel;
    ADOQuery_VersionSync: TADOQuery;
    DRPanel_VerSync: TDRPanel;
    StatusBar1: TStatusBar;
    procedure DRBitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DRLabel_DataRoadUrlClick(Sender: TObject);
    procedure ShowDBSpaceUsedInfo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_About: TForm_About;

//  function SettleNetUpdateDll(App : TApplication; MainADOC: TADOConnection) : Boolean; external 'ESettleNet_U.dll';

implementation

{$R *.DFM}

uses
   SCCGlobalType, SCCLib, SCCDataModule, registry;

function utl_GetTotalMemory() : LongInt;
var
 MemStat : TMemoryStatus;
begin
 MemStat.dwLength := sizeof(TMemoryStatus);
 GlobalMemoryStatus(MemStat);
 Result := MemStat.dwTotalPhys;
end;

// ----------------------------------------------------------------------------------
// 사용메모리 크기 구하기
function utl_GetUseMemory() : LongInt;
var
 MemStat : TMemoryStatus;
begin
 MemStat.dwLength := sizeof(TMemoryStatus);
 GlobalMemoryStatus(MemStat);
 Result := MemStat.dwAvailPhys;
end;
// ----------------------------------------------------------------------------------
// CPU 속도 구하기
function utl_GetCPUSpeed() : LongInt;
var
 TimerHi, TimerLo: DWORD;
 PriorityClass, Priority: Integer;
begin
 PriorityClass := GetPriorityClass( GetCurrentProcess );
 Priority := GetThreadPriority( GetCurrentThread );
 SetPriorityClass( GetCurrentProcess, REALTIME_PRIORITY_CLASS );
 SetThreadPriority( GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL );

 Sleep(10);
 asm
   DW 310Fh
   MOV TimerLo, EAX
   MOV TimerHi, EDX
 end;

 Sleep( 500 );
 asm
   DW 310Fh
   SUB EAX, TimerLo
   SBB EDX, TimerHi
   MOV TimerLo, EAX
   MOV TimerHi, EDX
 end;

 SetThreadPriority( GetCurrentThread, Priority );
 SetPriorityClass( GetCurrentProcess, PriorityClass );

 Result := Trunc(TimerLo / ( 1000 * 500 ));  // 단위 MHz
end;
// ----------------------------------------------------------------------------------
// CPU 종류 구하기
function utl_GetCPUInfo() : String;
var
  Registry: TRegistry;
begin
  Registry:=TRegistry.Create;

  Registry.RootKey:=HKEY_LOCAL_MACHINE;
  Registry.OpenKey('HARDWARE\DESCRIPTION\System\CentralProcessor\0',False);

  Result := Registry.ReadString('Identifier');
  Registry.Free;
end;
// ----------------------------------------------------------------------------------

procedure TForm_About.DRBitBtn1Click(Sender: TObject);
begin
   Close;
end;

procedure TForm_About.FormCreate(Sender: TObject);
function ExeVersion(sExeFullPathFileName: string): string;
var
  Size, Size2: DWord;
  Pt, Pt2: Pointer;
  SZfULLPATH: PChar;
begin

  Result := '';
  SZfULLPATH := pchar(sExeFullPathFileName);

  Size := GetFileVersionInfoSize(szFullPath, Size2);
  if Size > 0 then begin
    GetMem(Pt, Size);
    try
      GetFileVersionInfo(szFullPath, 0, Size, Pt);
      VerQueryValue(Pt, '\', Pt2, Size2);
      with TVSFixedFileInfo(Pt2^) do begin
        Result := Format('%d.%d.%d.%d', [HiWord(dwFileVersionMS),
          LoWord(dwFileVersionMS),
            HiWord(dwFileVersionLS),
            LoWord(dwFileVersionLS)]);
      end;
    finally
      FreeMem(Pt);
    end;
  end;
end;
begin
   DRLabel_Version.Caption    := 'Ver. ' +
                                 ExeVersion(Application.ExeName);
   DRLabel_ServerInfo.Caption := 'Server :   ' + gvDBServerName + '(' +
                                 gvUserSvrIP + ')';
   DRLabel_DBInfo.Caption     := 'DataBase : ' + gvDefaultDB;

   ShowDBSpaceUsedInfo();

   DRLabel_CPU.Caption := 'CPU : ' + utl_GetCPUInfo() ;
   DRLabel_Memory.Caption := 'SPEED : ' + IntToStr(utl_GetCPUSpeed())+'MHz';
end;

procedure TForm_About.DRLabel_DataRoadUrlClick(Sender: TObject);
var
   TempString : array[0..255] of char;
begin
   StrPCopy(TempString, DRLabel_DataRoadUrl.Caption);
   ShellExecute(0, nil, TempString, nil, nil, SW_NORMAL);
end;

procedure TForm_About.ShowDBSpaceUsedInfo();
var pagesperMB : integer;
    dbfilesize, used: double;
    dbfilename : string;
begin
   with DataModule_SettleNet.ADOQuery_Main do
   begin
      // pagesperMB 가져오기
      Close;
      sql.clear;
      sql.add(  ' select   1048576 / low as pagesperMB ' +
                ' from     master.dbo.spt_values       ' +
                ' where    number = 1                  ' +
                ' and      type = ''E''                ' );
      Try
         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
      Except
         on E : Exception do Exit;
      end;

      if RecordCount <= 0 then Exit;

      pagesperMB := FieldByName('pagesperMB').AsInteger;
      if pagesperMB = 0 then Exit;

      // dbfilesize,  dbfilename 가져오기
      Close;
      sql.clear;
      sql.add(  ' select   sum(convert(dec(15,2),size)) / ' +
                intToStr(pagesperMB) + ' as dbfilesize,   ' +
                '          min(name) as dbfilename        ' +
                ' from     dbo.sysfiles                   ' +
                ' where    (status & 64 = 0)              ' );
      Try
         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
      Except
         on E : Exception do Exit;
      end;

      if RecordCount <= 0 then Exit;

      dbfilesize := FieldByName('dbfilesize').AsFloat;
      dbfilename := Trim(FieldByName('dbfilename').AsString);

      // used 가져오기
      Close;
      sql.clear;
      sql.add(  ' select   sum(convert(dec(15,2),reserved)) / ' +
                intToStr(pagesperMB) + ' as used              ' +
                ' from     sysindexes                         ' +
                ' where     indid in (0,1,255)               ' );
      Try
         gf_ADOQueryOpen(DataModule_SettleNet.ADOQuery_Main);
      Except
         on E : Exception do Exit;
      end;

      if RecordCount <= 0 then Exit;

      used := FieldByName('used').AsFloat;

      DRLabel_Used.Caption := 'Used : ' + floatToStr(round(used / dbfilesize * 10000)/100) + '%';

   end;  // end of with

end;

end.
