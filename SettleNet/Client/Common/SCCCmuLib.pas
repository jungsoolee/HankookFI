(*
----------------------------------------------------------------------------

	PROGRAM NAME : DATAROAD Comunication Lib정의
		       (SCCCmuLib.pas)
	PROGRAM TYPE : Lib File
	최종  작성일 : 1998/8/13

 * LMS Modify 2004.01.15 WaitForServiceToReachState Function Optimize
                         gfFormatMessage Function Add
----------------------------------------------------------------------------
*)

{$DEFINE NSW_LOG}

unit SCCCmuLib;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Winsock, Buttons, ExtCtrls, Menus, StdCtrls, ComCtrls, IniFiles, WinSvc,
  DRSHMQueue,SCCCmuGlobal;

function Str2Long(str : PChar; len : longint) : longint;
procedure Long2Str(str : PChar; value : longint; len : longint);
function Char2Str(str : PChar; len : longint):string;
procedure Str2Char(str : PChar; instr : string; len : longint);
function CharCharCmp(str1 :PChar; str2 : PChar; len : longint) : longint;
procedure CharCharCpy(dest :PChar; src : PChar; len : longint);
function fnDelChar(str : PChar; cDelChar : Char; len : longint):integer;
function fnSpaceDel(_In:PChar; _Out:PChar):integer;
function fnCharDel(_In:PChar; _InCh:Char):string;
function fnChangeChar(_In:PChar; _InCh:Char; _OutCh:Char; _InLen:Integer):String;
function fnLogFileOpen(var flog:TextFile; szFileName: PChar):Integer;
function fnLogger(var flog:Textfile; pcFormat: PChar; const Args: array of const):integer;
function fnLoggerHex(var flog:TextFile; iDataLen:LongInt; csData: PChar):integer;
function fnLogFileClose(var flog:TextFile):integer;
function fnMask(_InPut : PChar; _OutPut : PChar; _Mode : PChar):integer;
function fnMaskStr(_InPut : string; _Mode : PChar):string;
function fnItoA(_Input : LongInt; _OutPut : PChar):integer;
function fnGetDate : String;
function fnGetTime : String;
function fnDiffTimeSec(sFromTime,sToTime : String) : Integer;
function fnCharSet(ib: PChar; _InCh:Char; _InLen:LongInt):integer;
function fnIntSet(var ib: Array of LongInt; _InInt:LongInt; _InLen:LongInt):integer;
function fnErrorMsg( ErrorCode : LongInt) : String;
function fnGetTokenNull(_InChar : PChar; _InSize:Integer; _Delimiter : Char; _Count : Integer; _OutChar : PChar):Integer;
function fnGetTokenStr(_InStr : String; _Delimiter : Char; _SearchCnt:Integer):String;
function fnGetTokenStrR(_InStr : String; _Delimiter : Char):String;
function fnGetComputerName(var sComputerName : String) : Boolean;
function fnTcpDataSend(TsockID_Local:Tsocket;
                            iPacketNo:LongInt;      iRawLen:LongInt;
                            lanRawBuff:PChar):integer;
function fnTcpDataRecv(TsockID_Local:Tsocket;  lanPBuff:PChar;
                            var iDecodeLen:LongInt;
                            var iPacketNO:LongInt):integer;
function fnTcpDataSendExternal(TSockID_Local : TSocket;
                               pSendBuff     : PChar;
                               iSendLen      : Integer) : Boolean;
function fnTcpDataRecvExternal(TSockID_Local : TSocket;
                               pRecvBuff     : PChar;
                               iRecvLen      : Integer;
                               iTimeOut      : Integer) : Boolean;
function TcpOpen(cpServerIP:PChar; iPortID:Integer):integer;
procedure TcpClose(TSockID_Local:Integer);
function WinsockInit:integer;
procedure WinsockTerm;

function fnThreadKilled(TThreadID:TThread;
                        bTerminateThreadFlag : Boolean):integer;
function MoveDataStr(Source : String; iSize : Integer) : String;
procedure MoveDataChar(Dest : PChar; Source : String; iSize : Integer);
function fnThreadAlive(hThreadHandle : THandle) : Boolean;
function fnQueueOpen(var MyQueue     : TDRSHMQueue;
                     MyQueueName : String;
                     MyQueueSize : Integer;
                     bCreateFlag : Boolean) : Boolean;
procedure fnQueueClose(MyQueue : TDRSHMQueue);
function MyStartService(pszInternalName : PChar) : Boolean;
function MyStopService(pszInternalName : PChar) : Boolean;
function WaitForServiceToReachState(
                                  pszInternalName: PChar;
                                  dwDesiredState : DWord;
                                  dwMilliSecond  : DWord) : Boolean;
function  fnGetSysErrStr(sErrCode: DWORD): string; // LMS Add

////////////////////////////////////////////////////////////////
//  Data Conversion Functions
function  fnAtoI(ib: pChar; ibl: Longint): Longint;
function  fnAtoF(ib: pChar; ibl: LongInt):Extended;
function  fnAtoS(str : PChar; len : longint):string;
function  fnSpaceToZero(InStr : String) : Extended;
function  fnBcdToInt(ib:PChar;  ibl: Longint):Longint;
function  fnBcdToDbl(ib: PChar; ibl: Longint): double;
procedure fnBcdToAsc(ib: PChar; ibl: Longint; ob: PChar; obl: Longint);
procedure fnAscToBcd(ob: PChar; obl: Longint; ib: PChar; ibl: Longint);
procedure fnBcdToStr(ib: PChar; ibl: Longint; var ob: string; obl: Longint);
function  fnBccCheck(ib: PChar) : LongInt;

implementation

{$IFDEF NSW_LOG}
uses SCCLib;
{$ENDIF}

function Str2Long(str :PChar; Len : Longint) : Longint;
var
    i : integer;
    ResultTmp : Longint;
begin
    ResultTmp := 0;
    for i := 0 to len - 1 do
    begin
       ResultTmp := ResultTmp * 10 + byte(str^) - $30;
       inc(str);
    end;

    Result := ResultTmp;
end;


procedure Long2Str(str : PChar; value : Longint; Len : Longint);
var
    i : integer;
begin
    FillChar(str^, len, $30);
    for i := len - 1  downto 0 do
    begin
        str[i] := Char((value mod 10) + $30);
        value := value div 10;
    end;
end;

function Char2Str(str : PChar; len : longint):string;
var
    //StrTmp : array[0..8196] of char;
    StrTmp : array of char;
begin
    SetLength(StrTmp, 100000);

    strLcopy(PChar(StrTmp), Str, len);
    StrTmp[len+1] := #0;
    Result := StrPas(PChar(StrTmp));
end;

function fnDelChar(str : PChar; cDelChar : Char; len : longint):integer;
var
   StrTmp : array [0..8196] of char;
   iILen,iJLen   : longint;
begin
     if (len >= 8196) then
     begin
          result := -1;
          exit;
     end;

     StrLcopy(StrTmp,str,len);
     iJLen := 0;
     for iILen := 0 to len do
     begin
          if StrTmp[iILen] <> cDelChar then
          begin
             StrTmp[iJLen] := StrTmp[iILen];
             iJLen := iJLen + 1;
          end;
     end;
     StrTmp[iJLen+1] := #0;
     StrCopy(str,StrTmp);
     result := 1;
end;

function  fnAtoS(str : PChar; len : longint):string;
var
    StrTmp : array[0..8196] of char;
begin
    strLcopy(StrTmp, Str, len);
    StrTmp[len+1] := #0;
    Result := StrPas(StrTmp);
end;

procedure Str2Char(str : PChar; instr : string; len : longint);
var
    i : integer;
    //StrTmp : array[0..8196] of char;
    StrTmp : array of char;
begin
    SetLength(StrTmp, 100000);

    FillChar(str^, len, $30);

    strPLcopy(PChar(StrTmp), instr, len);
    for i := 0 to len - 1 do
        str[i] := StrTmp[i];
    str[len] := #0;
end;


function CharCharCmp(str1 :PChar; str2 : PChar; len : longint) : longint;
var
    i : integer;
begin
    for i := 0 to len - 1 do
    begin
       if byte(str1^) > byte(str2^) then
       begin
           Result := 1;
           exit;
       end
       else if byte(str1^) < byte(str2^) then
       begin
           Result := -1;
           exit;
       end;
       inc(str1);
       inc(str2);
    end;

    Result := 0;
end;


procedure CharCharCpy(dest :PChar; src : PChar; len : longint);
var
    i : integer;
begin
    for i := 0 to len - 1 do
    begin
       dest^ := src^;
       inc(dest);
       inc(src);
    end;
end;

function fnSpaceDel(_In:PChar; _Out:PChar):integer;
begin
     FillChar(_Out^,strlen(_In),' ');
     while Byte(_In^) <> Byte(#0) do
     begin
          if Byte(_In^) <> Byte(' ') then
          begin
               _Out^ := _In^;
               Inc(_Out);
          end;

          Inc(_In);
     end;
     
     _Out^ := #0;
     
     result := 1;
end;

function fnCharDel(_In:PChar; _InCh:Char):String;
var
   sTemp : array [0..8196] of char;
   _Out : PChar;
begin
     if strlen(_In) > 8196 then
     begin
          result := #0;
          exit;
     end;
     _Out := @sTemp[0];
     FillChar(_Out^,strlen(_In),' ');
     while Byte(_In^) <> Byte(#0) do
     begin
          if Byte(_In^) <> Byte(_InCh) then
          begin
               _Out^ := _In^;
               Inc(_Out);
          end;

          Inc(_In);
     end;

     _Out^ := #0;
     result := StrPas(sTemp);
end;

function fnChangeChar(_In:PChar; _InCh:Char; _OutCh:Char; _InLen:Integer):String;
var
   sTemp : array [0..8196] of char;
   _Out : PChar;
   i : Integer;
begin
     if strlen(_In) > 8196 then
     begin
          result := #0;
          exit;
     end;
     _Out := @sTemp[0];

     for i := 0 to _InLen do
     begin
          if Byte(_In^) <> Byte(_InCh) then
          begin
               _Out^ := _In^;
          end else
          begin
               _Out^ := _OutCh;
          end;
          Inc(_Out);
          Inc(_In);          
     end;

     _Out^ := #0;
     result := StrPas(sTemp);
end;

function fnLogFileOpen(var flog:TextFile;szFileName: PChar):Integer;
begin
{$ifdef FILE_HANDLE}
   flog := FileCreate(szFileName);
   if flog < 0 then
   begin
      result :=  -1;
      exit;
   end;
   result := 1;
{$else}
   AssignFile(flog,szFileName);
   {$I-}
   rewrite(flog); // file create
   if IOResult <> 0 then
   begin
//        reset(flog); // 기존 file Open
        {$I+}
//        if IOResult <> 0 then
        begin
             result := -1;
             exit;
        end;
   end;
   {$I+}
   result := 1;
{$endif}
end;

function fnLogger(var flog:TextFile; pcFormat: PChar; const Args: array of const):integer;
var
   csLogBuf : array [0..8196] of char;
begin
     strfmt(csLogBuf,pcFormat,Args);
{$ifdef FILE_HANDLE}
     if (FileWrite(flog,csLogBuf,strlen(csLogBuf)) < 0) then //writeln(flog,csLogBuf);
     begin
          result := -1;
          exit;
     end;
{$else}
     {$I-}
     writeln(flog,csLogBuf);
     {$I+}
     if IOResult = 0 then
         flush(flog)
     else
     begin
          result := -1;
          exit;
     end;
{$endif}

     result := 1;
end;

function fnLoggerHex(var flog:TextFile; iDataLen:LongInt; csData: PChar):integer;
var
   csHexaBuf : array [0..80] of char;
   iIndex,iHexaIndex : LongInt;
begin
     iHexaIndex := 0;
     for iIndex := 1 to iDataLen do
     begin
          if (iIndex mod 20) = 0 then
          begin
               csHexaBuf[iHexaIndex] := #0;
               {$I-}
               writeln(flog,csHexaBuf);
               {$I+}
               if IOResult = 0 then
                    flush(flog)
               else
               begin
                    result := -1;
                    exit;
               end;
               iHexaIndex := 0;
          end;

          strfmt(@csHexaBuf[iHexaIndex],'%.2s ',
                          [IntToHex(Ord(csData[iIndex-1]),2)]);
          Inc(iHexaIndex,3);
     end;

     if iHexaIndex > 0 then
     begin
          csHexaBuf[iHexaIndex] := #0;     
          {$I-}
          writeln(flog,csHexaBuf);
          {$I+}
          if IOResult = 0 then
             flush(flog)
          else
          begin
             result := -1;
             exit;
          end;
     end;

     result := 1;
end;

function fnLogFileClose(var flog:TextFile):integer;
begin
{$ifdef FILE_HANDLE}
     FileClose(flog);
{$else}
     {$I-}
     CloseFile(flog);
     {$I+}
     if IOResult = 0 then
     begin
          result := -1;
          exit;
     end;
{$endif}
     result := 1;
end;

function fnMask(_InPut : PChar; _OutPut : PChar; _Mode : PChar):integer;
var
   job,modelen, inlen, asno, inno, injob : LongInt;
   inppoint, inminus, modeminus, stdigit : LongInt;
   inrno, morno, rjob, spcnt : LongInt;
   modepcnt: LongInt;
   _TMP,_IN : array [0..251] of char;
begin
	inno:=0;asno:=0; injob:=0;
	inppoint:=0; inminus:=0; modeminus :=0; stdigit := -1;
	inrno :=0; morno:=0; spcnt :=0;
	modepcnt :=0;

	CharCharCpy(_IN, _Input,strlen(_Input)); _IN[strlen(_input)] := #0;

	for job :=0 to strlen(_IN)-1 do
		if _IN[job] = ' ' then	Inc(spcnt);

	if spcnt > 0 then
        begin
		CharCharCpy(@_IN[0], @_IN[spcnt], LongInt(strlen(_IN))-spcnt);
		_IN[LongInt(strlen(_IN))-spcnt] := #0;
	end;

	modelen := strlen(_Mode);
	if(_IN[0] = '-') then
        begin
		_TMP[0]:=_IN[0]; _TMP[1] := '0';
		CharCharCpy(@_TMP[2], @_IN[1], strlen(_IN)-1); _TMP[strlen(_IN)+1] := #0;
		CharCharCpy(_IN, _TMP,strlen(_TMP)); _IN[strlen(_TMP)] := #0;
	end;
	inlen := strlen(_IN);

	CharCharCpy(_TMP, _Mode,strlen(_Mode)); _TMP[strlen(_Mode)] := #0;

	for job:=0 to modelen-1 do
        begin
		if (_mode[job] ='9') or (_mode[job] ='Z') or (_mode[job]='z') then ; //Inc(z9no);
		if(_mode[job]='*') then		Inc(asno);
		if(_mode[job]='-') then		Inc(modeminus);
		if(_mode[job]='.') then
                begin
			//modeppoint:=job;
			for rjob:=job+1 to modelen-1 do
                        begin
                        	if (_mode[rjob]='Z') or (_mode[rjob]='z') or
				   (_mode[rjob]='9') then Inc(morno);
                        end;
			Inc(modepcnt);
		end;
        end; // end for

//	if( modepcnt=1) and ((_mode[modeppoint-1]<'0') or (_mode[modeppoint-1]>'9') ) then
//		Inc(z9no);

	for job:=0 to inlen-1 do
        begin
		if(_IN[job]>'0') and (_IN[job]<='9') and (stdigit=-1) then	stdigit:=job;
		if(_IN[job]>='0') and (_IN[job]<='9') then Inc(inno);
		if(_IN[job]='.') then
                begin
			for rjob:=job+1 to inlen-1 do
				if(_IN[rjob]>='0') and (_IN[rjob]<='9') then Inc(inrno);
			inppoint:=job;
		end;
		if(_IN[job]='-') then	Inc(inminus);
        end;

	if(inppoint > 0) then
        begin
		for job:=0 to inlen-1 do
			if(_IN[job]='.') then	inppoint:=job;
		CharCharCpy(@_IN[inppoint], @_IN[inppoint+1], inlen-1);
		_IN[inlen-1]:=#0;
		if(inrno<morno) then
			for job:=0 to morno-inrno-1 do strcat(_IN, '0');
		inlen := strlen(_IN);
		Inc(inno,morno-inrno);
	end;

	if(morno < inrno) then
        begin
		_IN[inlen-(inrno-morno)]:=#0;
		inlen := inlen-(inrno-morno);
		inno:=inlen-inminus;
	end;

	for job:=0 to modelen-1 do
        begin
		case _mode[modelen-job-1] of
			'/', 	'(',
			')', 	'<',
			'>', 	'|',
			'=', 	'!',
			'@', 	'#',
			'%', 	'^',
			'&', 	'_',
			'?', 	'"',
			'{', 	'}',
			':', 	'.':
                        begin
//				Inc(job);
                        end;
			'-':
                        begin
//				Inc(job);
				if(inminus=0) and (_mode[0]='-') and (modeminus=1) then
					_TMP[modelen-job-1]:= ' ';
                        end;
			',':
                        begin
//				Inc(job);
				if _TMP[modelen-job+1] = ' ' then
					_TMP[modelen-job-1] := ' ';
                        end;
			'9':
                        begin
//				Inc(job);
				Inc(injob);
//				Inc(z9job);
				if ((inno-injob+inminus)<stdigit) or (fnAtoF(_IN,strlen(_IN))=0) then
					_TMP[modelen-job-1]:= '0'
				else 	_TMP[modelen-job-1] := _IN[inno-injob+inminus];
				//* 93/02/15 TEST */
				if (inno-injob+inminus > inppoint-1) and (modepcnt=1) then
				 	_TMP[modelen-job-1] := _IN[inno-injob+inminus];
                        end;
			'z',
			'Z':
                        begin
//				Inc(job);
				Inc(injob);
//				Inc(z9job);
				if ((inno-injob+inminus)<stdigit) or (fnAtoF(_IN,strlen(_IN))=0) then
					_TMP[modelen-job-1]:= ' '
				else 	_TMP[modelen-job-1] := _IN[inno-injob+inminus];
				//* 93/02/15 TEST */
				if (inno-injob+inminus > inppoint-1) and
				  (modepcnt=1) and (_IN[inno-injob+inminus] <> '0') then
					_TMP[modelen-job-1] := _IN[inno-injob+inminus];
                        end;
			'*':
                        begin
//				Inc(job);
				Inc(injob);
				if ((inno-injob+inminus)<0) or
				    (_IN[inno-injob+inminus]='0') and
				    ((inno-injob+inminus)<stdigit) then
					 //astrue := 1
				else 	_TMP[modelen-job-1] := _IN[inno-injob+inminus];
                        end;
			'$':
                        begin
//				Inc(job);
				Inc(injob);
				if ((inno-injob+inminus)<0) or
				    (_IN[inno-injob+inminus]='0') and (asno=0) then
					_TMP[modelen-job-1] := '$'
				else 	_TMP[modelen-job-1]:=_IN[inno-injob+inminus];
                        end;
			'b',
			'B':
                        begin
//				Inc(job);
				if  _TMP[modelen-job-1] <> 'D'  then
					 _TMP[modelen-job-1] := ' ';
                        end;
			'd',
			'D':
                        begin
//				Inc(job);
				if( inminus=0 )	then
                                begin
					 _TMP[modelen-job-1] := ' ';
					 _TMP[modelen-job-1+1]:= ' ';
				end;
				if (_TMP[modelen-job+1]='B') or
				   (_TMP[modelen-job+1]='b') then
					; //dbtrue := 1;
                        end
			else
                        begin
				;
                        end;
                end; // end case
	end; // end for

	for job:=0 to strlen(_TMP)-1 do
        begin
		if(_TMP[job]='-') and (_TMP[job+1]='-') then _TMP[job]:=' ';
		if(_TMP[job]='$') and (_TMP[job+1]='$') then _TMP[job]:=' ';
		if(_TMP[job]='*') and (_TMP[job+1]='*') then _TMP[job]:=' ';
		if(_TMP[job]=' ') and (_TMP[job+1]=',') then _TMP[job+1]:=' ';
		if(_TMP[job]='-') and (_TMP[job+1]=',') then _TMP[job+1]:=' ';
		if(_TMP[job]='.') and (_TMP[job+1]=' ') and (fnAtoF(_IN,strlen(_IN))=0) then
				 _TMP[job] :=' ';
		if (_TMP[job]='-') and (_TMP[job+1]=' ')
		                 and (modeminus=1) and (inminus=1) then
                begin
		    	_TMP[job]:=' '; _TMP[job+1]:='-';
		end;
	end; //end for

	CharCharCpy(_OutPut, _TMP,strlen(_TMP));
        _OutPut[strlen(_TMP)] := #0;
        result := 1;
end;

function fnMaskStr(_InPut : String; _Mode : PChar):string;
var
   job,modelen, inlen, asno, inno, injob : LongInt;
   inppoint, inminus, modeminus, stdigit : LongInt;
   inrno, morno, rjob, spcnt : LongInt;
   modepcnt: LongInt;
   _TMP,_IN : array [0..251] of char;
begin
	inno:=0;asno:=0; injob:=0;
	inppoint:=0; inminus:=0; modeminus :=0; stdigit := -1;
	inrno :=0; morno:=0;  spcnt :=0;
	modepcnt :=0;

	StrPCopy(_IN, _Input);

	for job :=0 to strlen(_IN)-1 do
		if _IN[job] = ' ' then	Inc(spcnt);

	if spcnt > 0 then
        begin
		CharCharCpy(@_IN[0], @_IN[spcnt], LongInt(strlen(_IN))-spcnt);
		_IN[LongInt(strlen(_IN))-spcnt] := #0;
	end;

	modelen := strlen(_Mode);
	if(_IN[0] = '-') then
        begin
		_TMP[0]:=_IN[0]; _TMP[1] := '0';
		CharCharCpy(@_TMP[2], @_IN[1], strlen(_IN)-1); _TMP[strlen(_IN)+1] := #0;
		CharCharCpy(_IN, _TMP,strlen(_TMP)); _IN[strlen(_TMP)] := #0;
	end;
	inlen := strlen(_IN);

	CharCharCpy(_TMP, _Mode,strlen(_Mode)); _TMP[strlen(_Mode)] := #0;

	for job:=0 to modelen-1 do
        begin
		if (_mode[job] ='9') or (_mode[job] ='Z') or (_mode[job]='z') then ; //Inc(z9no);
		if(_mode[job]='*') then		Inc(asno);
		if(_mode[job]='-') then		Inc(modeminus);
		if(_mode[job]='.') then
                begin
			//modeppoint:=job;
			for rjob:=job+1 to modelen-1 do
                        begin
                        	if (_mode[rjob]='Z') or (_mode[rjob]='z') or
				   (_mode[rjob]='9') then Inc(morno);
                        end;
			Inc(modepcnt);
		end;
        end; // end for

//	if( modepcnt=1) and ((_mode[modeppoint-1]<'0') or (_mode[modeppoint-1]>'9') ) then
//		Inc(z9no);

	for job:=0 to inlen-1 do
        begin
		if(_IN[job]>'0') and (_IN[job]<='9') and (stdigit=-1) then	stdigit:=job;
		if(_IN[job]>='0') and (_IN[job]<='9') then Inc(inno);
		if(_IN[job]='.') then
                begin
			for rjob:=job+1 to inlen-1 do
				if(_IN[rjob]>='0') and (_IN[rjob]<='9') then Inc(inrno);
			inppoint:=job;
		end;
		if(_IN[job]='-') then	Inc(inminus);
        end;

	if(inppoint > 0) then
        begin
		for job:=0 to inlen-1 do
			if(_IN[job]='.') then	inppoint:=job;
		CharCharCpy(@_IN[inppoint], @_IN[inppoint+1], inlen-1);
		_IN[inlen-1]:=#0;
		if(inrno<morno) then
			for job:=0 to morno-inrno-1 do strcat(_IN, '0');
		inlen := strlen(_IN);
		Inc(inno,morno-inrno);
	end;

	if(morno < inrno) then
        begin
		_IN[inlen-(inrno-morno)]:=#0;
		inlen := inlen-(inrno-morno);
		inno:=inlen-inminus;
	end;

	for job:=0 to modelen-1 do
        begin
		case _mode[modelen-job-1] of
			'/', 	'(',
			')', 	'<',
			'>', 	'|',
			'=', 	'!',
			'@', 	'#',
			'%', 	'^',
			'&', 	'_',
			'?', 	'"',
			'{', 	'}',
			':', 	'.':
                        begin
//				Inc(job);
                        end;
			'-':
                        begin
//				Inc(job);
				if(inminus=0) and (_mode[0]='-') and (modeminus=1) then
					_TMP[modelen-job-1]:= ' ';
                        end;
			',':
                        begin
//				Inc(job);
				if _TMP[modelen-job+1] = ' ' then
					_TMP[modelen-job-1] := ' ';
                        end;
			'9':
                        begin
//				Inc(job);
				Inc(injob);
//				Inc(z9job);
				if ((inno-injob+inminus)<stdigit) or (fnAtoF(_IN,strlen(_IN))=0) then
					_TMP[modelen-job-1]:= '0'
				else 	_TMP[modelen-job-1] := _IN[inno-injob+inminus];
				//* 93/02/15 TEST */
				if (inno-injob+inminus > inppoint-1) and (modepcnt=1) then
				 	_TMP[modelen-job-1] := _IN[inno-injob+inminus];
                        end;
			'z',
			'Z':
                        begin
//				Inc(job);
				Inc(injob);
//				Inc(z9job);
				if ((inno-injob+inminus)<stdigit) or (fnAtoF(_IN,strlen(_IN))=0) then
					_TMP[modelen-job-1]:= ' '
				else 	_TMP[modelen-job-1] := _IN[inno-injob+inminus];
				//* 93/02/15 TEST */
				if (inno-injob+inminus > inppoint-1) and
				  (modepcnt=1) and (_IN[inno-injob+inminus] <> '0') then
					_TMP[modelen-job-1] := _IN[inno-injob+inminus];
                        end;
			'*':
                        begin
//				Inc(job);
				Inc(injob);
				if ((inno-injob+inminus)<0) or
				    (_IN[inno-injob+inminus]='0') and
				    ((inno-injob+inminus)<stdigit) then
					 //astrue := 1
				else 	_TMP[modelen-job-1] := _IN[inno-injob+inminus];
                        end;
			'$':
                        begin
//				Inc(job);
				Inc(injob);
				if ((inno-injob+inminus)<0) or
				    (_IN[inno-injob+inminus]='0') and (asno=0) then
					_TMP[modelen-job-1] := '$'
				else 	_TMP[modelen-job-1]:=_IN[inno-injob+inminus];
                        end;
			'b',
			'B':
                        begin
//				Inc(job);
				if  _TMP[modelen-job-1] <> 'D'  then
					 _TMP[modelen-job-1] := ' ';
                        end;
			'd',
			'D':
                        begin
//				Inc(job);
				if( inminus=0 )	then
                                begin
					 _TMP[modelen-job-1] := ' ';
					 _TMP[modelen-job-1+1]:= ' ';
				end;
				if (_TMP[modelen-job+1]='B') or
				   (_TMP[modelen-job+1]='b') then
					; //dbtrue := 1;
                        end
			else
                        begin
				;
                        end;
                end; // end case
	end; // end for

	for job:=0 to strlen(_TMP)-1 do
        begin
		if(_TMP[job]='-') and (_TMP[job+1]='-') then _TMP[job]:=' ';
		if(_TMP[job]='$') and (_TMP[job+1]='$') then _TMP[job]:=' ';
		if(_TMP[job]='*') and (_TMP[job+1]='*') then _TMP[job]:=' ';
		if(_TMP[job]=' ') and (_TMP[job+1]=',') then _TMP[job+1]:=' ';
		if(_TMP[job]='-') and (_TMP[job+1]=',') then _TMP[job+1]:=' ';
		if(_TMP[job]='.') and (_TMP[job+1]=' ') and (fnAtoF(_IN,strlen(_IN))=0) then
				 _TMP[job] :=' ';
		if (_TMP[job]='-') and (_TMP[job+1]=' ')
		                 and (modeminus=1) and (inminus=1) then
                begin
		    	_TMP[job]:=' '; _TMP[job+1]:='-';
		end;
	end; //end for

//	CharCharCpy(_OutPut, _TMP,strlen(_TMP));
//        _OutPut[strlen(_TMP)] := #0;
        result := _TMP;
end;

function fnItoA(_Input : LongInt; _OutPut : PChar):integer;
begin
     StrPCopy(_OutPut,IntToStr(_Input));
     result := 1;
end;

function fnGetDate : String;
{
var
   TDatePresent: TDateTime;
   wYear, wMonth, wDay: Word;
   iIndex : LongInt;
}   
begin
{
  TDatePresent:= Now;
  DecodeDate(TDatePresent, wYear, wMonth, wDay);
  strfmt(_OutPut,'%4d%2d%2d',[wYear,wMonth,wDay]);
  for iIndex:=0 to 7 do
  begin
   if _OutPut[iIndex] = ' ' then _OutPut[iIndex] := '0';
  end;
  _OutPut[8] := #0;
}
  ShortDateFormat := 'yyyymmdd';
  Result := DateToStr(Now);
end;

function fnGetTime : String;
begin
  LongTimeFormat := 'hhnnss';
  Result := TimeToStr(Now);
end;

function fnDiffTimeSec(sFromTime,sToTime : String) : Integer;
var
  iFromTime, iToTime : Integer;
  iHour, iMin, iSec : Integer;
begin
  if (Length(sFromTime) < 6) or (Length(sToTime) < 6) then
  begin
    Result := -1;
    Exit;
  end;

  iHour := StrToIntDef(Copy(sFromTime,1,2),-1);
  iMin  := StrToIntDef(Copy(sFromTime,3,2),-1);
  iSec  := StrToIntDef(Copy(sFromTime,5,2),-1);
  if (iHour = -1) or (iMin = -1) or (iSec = -1) then
  begin
    Result := -1;
    Exit;
  end;
  iFromTime := (iHour*60*60) + (iMin*60) + iSec;

  iHour := StrToIntDef(Copy(sToTime,1,2),-1);
  iMin  := StrToIntDef(Copy(sToTime,3,2),-1);
  iSec  := StrToIntDef(Copy(sToTime,5,2),-1);
  if (iHour = -1) or (iMin = -1) or (iSec = -1) then
  begin
    Result := -1;
    Exit;
  end;
  iToTime := (iHour*60*60) + (iMin*60) + iSec;

  Result := iToTime - iFromTime;
end;

function fnAtoF(ib: pChar; ibl: LongInt):Extended;
var
   sTemp : String;
//   csInTemp,csOutTemp: array [0..8196] of char;
   iIndex : LongInt;
begin
//     CharCharCpy(csInTemp,ib,ibl);
//     csInTemp[ibl] := #0;
//     fnSpaceDel(csInTemp,csOutTemp);
     for iIndex:=0 to ibl-1 do
     begin
          if ((Ord(ib[iIndex]) < 48) or (Ord(ib[iIndex]) > 57)) and
              (ib[iIndex] <> '.')  and (ib[iIndex] <> ' ') and
              (ib[iIndex] <> '-')  and (ib[iIndex] <> '+') then
          begin
               result := -1;
               exit;
          end;
     end;
     sTemp := Char2Str(ib,ibl);
     result := StrToFloat(sTemp);
end;

function  fnSpaceToZero(InStr : String) : Extended;
var
  eResult : Extended;
begin
  if InStr = '' then
  begin
    Result := 0;
    Exit;
  end;
  
  { Convert spaces to zeroes }
  while Pos(' ', InStr) > 0 do
    InStr[Pos(' ', InStr)] := '0';
  eResult := StrToFloat(InStr);
  Result := eResult;
end;

function fnCharSet(ib: PChar; _InCh:Char; _InLen:LongInt):integer;
var
   iIndex : LongInt;
begin
     for iIndex := 0 to _InLen-1 do
     begin
          ib[iIndex] := _InCh;
     end;

     result := 1;
end;

function fnIntSet(var ib: array of LongInt; _InInt:LongInt; _InLen:LongInt):integer;
var
   iIndex : LongInt;
begin
     for iIndex := 0 to _InLen-1 do
     begin
          ib[iIndex] := _InInt;
     end;

     result := 1;
end;

////////////////////////////////////////////////////////////////
//  Data Conversion Functions
function fnAtoI(ib: pChar; ibl: Longint): Longint;
var
   ival, minus, i : Longint;
begin
   minus := 1;
   ival := 0;
   for i := 0 to ibl - 1 do
   begin
      if (byte(ib^) < $30) or (byte(ib^) > $39) then
      begin
    	 if ival = 0 then
         begin
     	    if (byte(ib^) = $20) or (Char(ib^) = '+') then
            begin
               inc(ib);
               continue;
            end;
	    if Char(ib^) = '-' then
            begin
	       minus := -1;
               inc(ib);
	       continue;
            end;
         end;
   	 break;
      end;
      ival := ival * 10;
      ival := ival + (byte(ib^) - $30);
      inc(ib);
  end;
   Result := ival * minus;
end;

function fnBcdToInt( ib:PChar; ibl:Longint):Longint;
var
    val , i : Longint;
    ch      : BYTE;
begin
    val := 0;
    for i := 0 to ibl - 1 do
    begin
       val := val * 10;
       if BYTE(ib^) < $20 then
       begin
          Result := 0;
          exit;
       end;
       ch  := BYTE(ib^) - $20;
       val := val + LongInt( (ch shr 4) and $0f);
       val := val * 10;
       val := val + LongInt( ch and $0f);
       inc(ib);
    end;
    result := val;
end;

function fnBcdToDbl(ib:PChar; ibl:Longint):double;
begin
    Result := fnBcdToInt(ib, ibl)/100.00;
end;

procedure fnBcdToAsc(ib:PChar; ibl:Longint; ob:PChar; obl:LongInt);
var
    i, j : Longint;
    ch         : BYTE;
begin
//    val := 0;
    j   := 0;
    for i := 0 to ibl - 1 do
    begin
       if j >= obl then
          break;
       if BYTE(ib^) < $20 then
       begin
          exit;
       end;
       ch  := BYTE(ib^) - $20;
       BYTE(ob^) := BYTE( (ch shr 4) and $0f) + $30;
       Inc(ob);
       BYTE(ob^) := BYTE( ch and $0f) + $30;
       Inc(ob);
       inc(ib);
    end;
end;

procedure fnAscToBcd( ob:PChar; obl:LongInt; ib:PChar; ibl:Longint);
var
    i : Longint;
begin
    if (obl*2) > ibl then
    begin
         fnCharSet(ob,Char($ff),obl); // AscToBcd error
         exit;
    end;

    fnCharSet(ob,'0',obl);

    for i := obl-1 downto 0 do
    begin

       Dec(ibl);
       BYTE(ob[i]) := BYTE(ib[ibl]) and $0f;
       Dec(ibl);
       BYTE(ob[i]) := (BYTE(ob[i]) or ((BYTE(ib[ibl]) and $0f) shl 4));
       BYTE(ob[i]) := BYTE(ob[i]) + $20;
    end;
end;

procedure fnBcdToStr(ib:PChar; ibl:Longint; var ob:string; obl:LongInt);
var
//    i, j : Longint;
//    ch         : BYTE;
    a_tmp      : array[0..20] of char;
begin
    fnBcdToAsc(ib, ibl, a_tmp, obl);
    a_tmp[obl] := #0;
    ob := StrPas(a_tmp);
end;

function  fnBccCheck( ib : PChar) : LongInt;
var
   tlen , i, nstp : Integer;
   bcc, Rbcc : char;
   o_stx, n_stx : Pchar;
begin

   i := 0;
   bcc := #0;
   Rbcc := #0;

   tlen := StrLen(ib);
   if (tlen < 3) then
   begin
        result := -1;
        exit;
   end;

   o_stx := ib;
   n_stx := StrPos(ib, gcSTX);

   if (n_stx = Nil) then
   begin
        result := -2;
        exit;
   end;

   nstp := n_stx - o_stx;
   tlen := tlen - nstp;

   // Bcc계산
   while True do
   begin
        if ( i > tlen ) then
        begin
             // Etx Not Found
             result := -3;
             exit;
        end;

        BYTE(bcc) := BYTE(bcc) xor BYTE(ib[i+nstp]);
        if ( BYTE(ib[i+nstp]) = BYTE(gcETX) ) then
        begin
             if (BYTE(bcc) < $20) then BYTE(bcc) := BYTE(bcc) + $20;
             BYTE(Rbcc) := BYTE(ib[i+nstp+1]);
             break;
        end;

        Inc(i);
   end;

   // Bcc틀림
   if ( BYTE(Rbcc) <> BYTE(bcc)) then
   begin
        result := -4;
        exit;
   end;

   result := tlen;
end;

///
function fnErrorMsg( ErrorCode : LongInt) : String;
var
   Msg : string;
begin
//   Result := gf_ReturnMsg(ErrorCode);
   case ErrorCode of
   0                                     : Msg := 'SUCCESS';
 // CLIENT에서 발생하는 에러코드
   4000 : Msg := 'CL - System Error(4000)';
   4030 : Msg := 'CL - Server ABNORMAL_DATA(4030)';    
   4032 : Msg := 'CL - Disconnect Server(4032)';    //4032
   4033 : Msg := 'CL - Server Connect Time Out(4002)'; //4033
   4034 : Msg := 'CL - Server Data Context Error(4003)';//4034
   4035 : Msg := 'CL - Network Thread Create Error(4004)';//4035

 //SERVER에서 발생하는 에러코드
   4036 : Msg := 'SV - NetWork Header Error(5001)'; // 4036
   4037 : Msg := 'SV - Already User Login(5002)'; // 4037
   4038 : Msg := 'SV - Users FULL(5003)'; // 4038
   4039 : Msg := 'SV - Server Application Data Send Error(5004) '; //4039
   4040 : Msg := 'SV - Server Process Error';//4040
   4041 : Msg := 'SV - Server Process Error(Pipe)'; //4041
   4042 : Msg := 'SV - Server Client Address Get Error';//4042
   4043 : Msg := 'SV - Reject Server Connection';//4043
   else   Msg := 'UNKNOWN ERROR CODE #' + IntToStr(ErrorCode);
   end;
   Result := Msg;
end;

function fnGetTokenNull(_InChar : PChar; _InSize : Integer; _Delimiter : Char; _Count : Integer; _OutChar : PChar):Integer;
var
  PTempInData,PTemp : PChar;
  iIndex : Integer;
  iDataLen : Integer;
  iDelSearchCnt : Integer;
  bSearchFlag : Boolean;
begin
  PTemp := Nil;
  PTempInData := _InChar;
  iDelSearchCnt := 1;
  bSearchFlag := False;
  for iIndex := 0 to _InSize-1 do
  begin
      if _InChar[iIndex] = _Delimiter then
      begin
          if iDelSearchCnt = _Count then
          begin
             pTemp := @_InChar[iIndex];
             bSearchFlag := True;
             break;
          end;
          pTempInData := @_InChar[iIndex+1];
          Inc(iDelSearchCnt,1);
      end;
  end;

  if bSearchFlag = False then
  begin
       Result := -1;
       Exit;
  end;

  iDataLen := PTemp - PTempInData;
  CharCharCpy(_OutChar,PTempInData, iDataLen);
  _OutChar[iDataLen] := #0;
  Result := iDataLen;
end;

function fnGetTokenStr(_InStr : String; _Delimiter : Char; _SearchCnt:Integer):String;
var
//  iPos : Integer;
  //_InChar  : Array [0..8196] of Char;
  //_OutChar : Array [0..8196] of Char;
  _InChar  : Array of Char;
  _OutChar : Array of Char;
  _InSize  : Integer;
  _OutLen  : Integer;
begin
  SetLength(_InChar, 100000);
  SetLength(_OutChar, 100000);

  _InSize := Length(_InStr);
  //if _InSize >= 8196 then
  if _InSize >= 100000-1 then
  begin
    Result := '';
    Exit;
  end;

  Str2Char(PChar(_InChar),_InStr,_InSize);
  _OutLen := fnGetTokenNull(PChar(_InChar),_InSize,_Delimiter,_SearchCnt,PChar(_OutChar));
  if _OutLen < 0 then
  begin
    Result := '';
    Exit;
  end;

  Result := Char2Str(PChar(_OutChar),_OutLen);
(*
  iPos := Pos(_Delimiter,_InStr);
  if iPos <= 0 then
  begin
    Result := '';
    Exit;
  end;
  Result := Copy(_InStr,1,iPos-1);
*)  
end;

function fnGetTokenStrR(_InStr : String; _Delimiter : Char):String;
var
  iPos : Integer;
begin
  iPos := LastDelimiter(_Delimiter,_InStr);
  if iPos <= 0 then
  begin
    Result := '';
    Exit;
  end;

  Result := Copy(_InStr,iPos+1,Length(_Instr)-1);
end;

function fnGetComputerName(var sComputerName : String) : Boolean;
var
  csComputerName : Array [0..MAX_COMPUTERNAME_LENGTH] of char;
  iLength : LongWord;
begin
  // Get My Computer Name
  iLength := MAX_COMPUTERNAME_LENGTH+1;
  if not GetComputerName(csComputerName,iLength) then
  begin
    Result := False;
    Exit;
  end;
  sComputerName := strpas(csComputerName);
  Result := True;
end;

//*=======================================================================*/
// Tcp/Ip Data Send
//*=======================================================================*/
//{$DEFINE COMPRESS}
//{$DEFINE GETMEM_USE}
function fnTcpDataSend(TsockID_Local:Tsocket;
                                 iPacketNo:LongInt;
                                 iRawLen:LongInt;
                                 lanRawBuff:PChar):integer;
var
{$ifdef COMPRESS}
    lanEncodeBuff : PChar; // Encode Buff
    iEncodeLen : LongInt;
{$endif}
{$ifdef GETMEM_USE}
    PSendBuff : PChar; // Send Buff
{$else}
    PSendBuff : array [0..gcMAX_COMM_BUFF_SIZE] of char; // Send Buff
{$endif}
    iSendLen : LongInt;
    iSendErrno : LongInt;
    iNetHeadLen : Integer;
begin
     // NetWork Header Length
     iNetHeadLen := sizeof(NetHead_R);

     // Send Length Check
     if iRawLen > (gcMAX_COMM_BUFF_SIZE - iNetHeadLen - 1) then
     begin
{$ifdef DEBUG}
          fnLogger(flog,'>> Send Length Check[%d]',[iRawLen]);
{$endif}
          result := -1;
          exit;
     end;

    // Encode성공시만 GetMem이됨 -> FreeMem은 성공시만
{$ifdef COMPRESS}
    iEncodeLen := LZW_Encode(@lanEncodeBuff,@lanRawBuff^,iRawLen);
    lanEncodeBuff := Nil;
    iEncodeLen := 0;
{$endif}

    //----------------------------------------------------------------------
    // Send Format : STX(0X02) + SEND LENGTH(4) + 건수(2) +
    //            Compress구분(1) +  Uncompress후 길이(4) + DATA1..DATAn
    //----------------------------------------------------------------------

{$ifdef GETMEM_USE}
    // Send Memory Get
try
    GetMem(PSendBuff,iRawlen+COMM_HEADER_LENGTH+1);
except
{$ifdef DEBUG}
    fnLogger(flog,'>> Send GetMem Error[%d]',[GetLastError()]);
{$endif}
    result := SYSTEM_ERROR;
    exit;
end;
{$endif}

    iSendLen := 0;
{$ifdef COMPRESS}
    if iEncodeLen > 0 then
    begin
         // Compress
         PSendBuff[iSendLen] := STX;
         StrFmt(PSendBuff+iSendLen+1,'%.4d%.2d%.1s%.4d',
                [iEncodeLen+COMM_HEADER_LENGTH,iPacketNo,COMPRESS_GUBUN,iRawLen]);
         Inc(iSendLen,COMM_HEADER_LENGTH);

         CharCharCpy(PSendBuff+iSendLen,lanEncodeBuff,iEncodeLen);
         Inc(iSendLen,iEncodeLen);
         PSendBuff[iSendLen] := #0;
         FreeMem(lanEncodeBuff);
    end else
{$endif}
    begin
         // No Compress
         PSendBuff[iSendLen] := gcSTX;
         StrFmt(PSendBuff+iSendLen+1,'%.4d%.2d%.1s%.4d',
                [iRawLen+iNetHeadLen,iPacketNo,gcNOCOMPRESS_GUBUN,iRawLen]);

         Inc(iSendLen,iNetHeadLen);
         CharCharCpy(PSendBuff+iSendLen,lanRawBuff,iRawLen);
         Inc(iSendLen,iRawLen);
{$ifdef DEBUG}
         fnLogger(flog,'>> Send No Compress[%s]',[PSendBuff]);
{$endif}
    end;

{$ifdef DEBUG}
//fnLoggerHex(flog,iSendLen,PSendBuff);
    fnLogger(flog,'>> SEND Head[%.*s] PacketNo[%d] Len[%.4d]:[%.3s%.*s]',
        [iNetHeadLen,PSendBuff,iPacketNO,iSendLen,sGubun,iRawLen,lanRawBuff]);
{$endif}

{$ifdef GETMEM_USE}
    if send(TSockId_Local,PSendBuff^,iSendLen,0) < 0 then
    begin
         FreeMem(PSendBuff);
{$else}
    if send(TSockId_Local,PSendBuff,iSendLen,0) < 0 then
    begin
{$endif}
         iSendErrno := WSAGetLastError();
         if (iSendErrno = WSAECONNRESET) or (iSendErrno =  WSAECONNABORTED) then
         begin
{$ifdef DEBUG}
              fnLogger(flog,'>> Connection Terminate[%s] : errno[%d]',
                                      [TimeToStr(Now),iSendErrno]);
{$endif}
         end  else
         begin
{$ifdef DEBUG}
              fnLogger(flog,'>> Tcp Send error errno[%d]',[iSendErrno]);
{$endif}
         end;

         result := gcCOMM_TERMINATE;
         exit;
    end;

{$ifdef GETMEM_USE}
    FreeMem(PSendBuff);
{$endif}
    result := 1;
end;

//*=======================================================================*/
// Tcp/Ip Data Recv
//*=======================================================================*/
function fnTcpDataRecv(TsockID_Local:Tsocket;lanPBuff:PChar;
                                 var iDecodeLen:LongInt;
                                 var iPacketNO:LongInt):integer;
var
   lanRawBuff:array[0..gcMAX_COMM_BUFF_SIZE] of char;
   iRawLen,iReadDataLen : LongInt;
   iReadAddlen : LongInt;
{$ifdef COMPRESS}
   lanDecodeBuff : PChar;
   iUnCompLen,iCompRc : Integer;
{$endif}
   iRecvErrno : LongInt;
   iSelectRc  : LongInt;
   timeout    : TTimeVal;
   Tfd        : TFDSet;
   NetHead    : ptNetHead_R;
   iNetHeadLen : Integer;
begin

{$ifdef DEBUG}
    fnLogger(flog,'>> Recv Ready....',[NULL]);
{$endif}

    FD_ZERO(Tfd);
    FD_SET(TSockID_Local,Tfd);
    
    // TimeOut 20초
    timeout.tv_sec := 120; //20초
    timeout.tv_usec := 0;

    iSelectRc := Select(1,@Tfd,Nil,Nil,@timeout);

    // Error발생이면
    if iSelectRc < 0 then
    begin
{$ifdef DEBUG}
         fnLogger(flog,'>> SELECT Error[%d]',[WSAGetLastError()]);
{$endif}         
         result := gcCOMM_TERMINATE;
         exit;
    end;
(*
    // TimeOut발생이면
    if iSelectRc = 0 then
    begin
{$ifdef DEBUG}
         fnLogger(flog,'>> Recv TimeOut발생',[NULL]);
{$endif}
         result := gcERROR_TIME_OUT;
         exit;
    end;
*)
    //----------------------------------------------------------------------
    // Recv Format : STX(0X02) + SEND LENGTH(4) + 건수(2) +
    //            Compress구분(1) +  Uncompress후 길이(4) + DATA1..DATAn
    //----------------------------------------------------------------------

    // NetWork Header
    iNetHeadLen := sizeof(NetHead_R);

    // Main Form Kill시 recv errno = WSAEINTR 발생 TSockID => close
    // 되므로 정상적으로 Thread Kill됨
    // 먼저 Header만큼 Read
    iRawLen := recv(TSockId_Local, lanRawBuff,iNetHeadLen,0);
    if iRawLen <= 0 then
    begin
          iRecvErrno := WSAGetLastError();
          if (iRecvErrno = WSAECONNRESET) or (iRecvErrno =  WSAECONNABORTED) then
          begin
{$ifdef DEBUG}
              fnLogger(flog,'>> Connection Terminate[%s] : errno[%d]',
                                      [TimeToStr(Now),iRecvErrno]);
{$endif}                                      
          end  else
          begin
{$ifdef DEBUG}
              fnLogger(flog,'>> [Header] Tcp Recv error size[%d] : errno[%d]',
                                [iRawLen,iRecvErrno]);
{$endif}                                
          end;

          result := gcCOMM_TERMINATE;
          exit;
    end;

    // 통신Header Assign
    NetHead := ptNetHead_R(@lanRawBuff[0]);

    //READ한 자료의 처음이 STX가 아니면
    if NetHead^.stx <> gcSTX then
    begin
{$ifdef DEBUG}
         fnLogger(flog,'>> Recv Header Gubun Error[%.*s]',
                                 [sizeof(NetHead_R),lanRawBuff]);
{$endif}                                 
         result := gcERROR_DATA_CONTEXT;
         exit;
    end;

    //SERVER에서 전송한갯수만큼read
    iReadAddLen := 0;
    iReadDataLen := fnAtoI(NetHead^.SendLength,sizeof(NetHead^.SendLength));
    Dec(iReadDataLen,sizeof(NetHead_R));

    while TRUE do
    begin
        FD_ZERO(Tfd);
        FD_SET(TSockID_Local,Tfd);

        // TimeOut 20초
        timeout.tv_sec := 20; //20초
        timeout.tv_usec := 0;

        iSelectRc := Select(1,@Tfd,Nil,Nil,@timeout);

        // Error발생이면
        if iSelectRc < 0 then
        begin
{$ifdef DEBUG}
             fnLogger(flog,'>> SELECT Error[%d]',[WSAGetLastError()]);
{$endif}             
             result := gcCOMM_TERMINATE;
             exit;
        end;

        // TimeOut발생이면
        if iSelectRc = 0 then
        begin
{$ifdef DEBUG}
             fnLogger(flog,'>> Recv TimeOut발생',[NULL]);
{$endif}
             result := gcERROR_TIME_OUT;
             exit;
        end;

        iRawLen := recv(TSockId_Local, lanRawBuff[iNetHeadLen+iReadAddLen],iReadDataLen,0);
        if iRawLen <= 0 then
        begin
              iRecvErrno := WSAGetLastError();
              if (iRecvErrno = WSAECONNRESET) or (iRecvErrno =  WSAECONNABORTED) then
              begin
{$ifdef DEBUG}
                  fnLogger(flog,'>> Connection Terminate[%s] : errno[%d]',
                                          [TimeToStr(Now),iRecvErrno]);
{$endif}                                          
              end  else
              begin
{$ifdef DEBUG}
                  fnLogger(flog,'>> [Main Data]Tcp Recv error [%d] : errno[%d]',
                                    [iRawLen,iRecvErrno]);
{$endif}                                    
              end;

              result := gcCOMM_TERMINATE;
              exit;
        end;

        // Read개수증가
        Inc(iReadAddLen,iRawLen);

        if iRawLen < iReadDataLen then
        begin
             // Read한개수만큼 감소(다시 읽어야할 개수)
             Dec(iReaddataLen,iRawLen);
        end else
        if iRawLen > iReadDataLen then
        begin
{$ifdef DEBUG}
            fnLogger(flog,'>> Recv요청한 자료보다많이 들어옴 ReqLen[%d],ReadLen[%d]',
                                 [iReadDataLen,iRawLen]);
{$endif}
            result := gcERROR_DATA_CONTEXT;
            exit;
        end else
        begin
             break;
        end;
    end;

    //----------------------------------------------------------------------
    // Recv Format : STX(0X02) + SEND LENGTH(4) + 건수(2) +
    //            Compress구분(1) +  Uncompress후 길이(4) + DATA1..DATAn
    //----------------------------------------------------------------------

    iPacketNo := fnAtoI(@lanRawBuff[5],2);
    if (iPacketNO > 10) or (iPacketNo <= 0) then
    begin
{$ifdef DEBUG}
         fnLogger(flog,'>> Read DATA RecvLen[%d] PacketNo[%d] Data Check[%.14s]',
                             [iRawLen,iPacketNO,lanRawBuff]);
//         fnLoggerHex(flog,iRawLen,lanRawBuff);
{$endif}
         result := gcERROR_DATA_CONTEXT;
         exit;
    end;

    iDecodeLen := fnAtoI(@lanRawBuff[8],4);
    if NetHead^.CompGbn = gcCOMPRESS_GUBUN then // compress data
    begin
{$ifdef COMPRESS}
         iReadDataLen := fnAtoI(@lanRawBuff[1],4);
         iCompRc :=  bcompress(2,@lanRawBuff[iNetHeadLen],
                              iReadDataLen-iNetHeadLen,lanPbuff,@iUnCompLen);

         if iCompRc < 0 then
         begin
              result := ERROR_DATA_CONTEXT;
              Exit;
         end;

         if iDecodeLen <> iUnCompLen then
         begin
              result := ERROR_DATA_CONTEXT;
              Exit;
         end;
         lanPbuff[iDecodeLen] := #0;
{$endif}
    end else
    begin
         CharCharCpy(lanPbuff,@lanRawBuff[iNetHeadLen],iDecodeLen);
         lanPbuff[iDecodeLen] := #0;
    end;

{$ifdef DEBUG}
    // Logger Write
    fnLogger(flog,'>> RECV Head[%.12s] PacketNo[%d] Len[%4d]:[%.100s]',
            [lanRawBuff,iPacketNO,iDecodeLen,lanPbuff]);
{$endif}
    result := 1;
end;

//=======================================================================*/
// fnTcpDataSendExternal
//=======================================================================*/
function fnTcpDataSendExternal(TSockID_Local : TSocket;
                               pSendBuff     : PChar;
                               iSendLen      : Integer) : Boolean;
begin
  Result := False;
  Exit;

  // Send시 pSendBuff가 변형되는것 같음
  if Send(TSockId_Local,pSendBuff,iSendLen,0) <= 0 then
  begin
    gf_Log('TCPSENDEX>> SEND ERROR : Errno['+ IntToStr(WSAGetLastError())+ ']');
    Result := False;
    Exit;
  end;
  Result := True;
end;

//=======================================================================*/
// fnTcpDataRecvExternal
//=======================================================================*/
function fnTcpDataRecvExternal(TSockID_Local : TSocket;
                               pRecvBuff     : PChar;
                               iRecvLen      : Integer;
                               iTimeOut      : Integer) : Boolean;
var
   iRawLen,iReadDataLen : LongInt;
   iReadAddlen : LongInt;
   iSelectRc  : LongInt;
   timeout    : TTimeVal;
   Tfd        : TFDSet;
begin
    FD_ZERO(Tfd);
    FD_SET(TSockID_Local,Tfd);
    
    // TimeOut 
    Timeout.tv_sec := iTimeOut; 
    Timeout.tv_usec := 0;

    iSelectRc := Select(1,@Tfd,Nil,Nil,@timeout);

    // Error발생이면
    if iSelectRc < 0 then
    begin
      gf_Log('TCPRECVEX>> SELECT Error ['+IntToStr(WSAGetLastError())+']');
      Result := False;
      Exit;
    end;

    // TimeOut발생이면
    if iSelectRc = 0 then
    begin
      gf_Log('TCPRECVEX>> RECV Time Out 발생');
      Result := False;
      Exit;
    end;

    // READ할갯수만큼read
    iReadAddLen := 0;
    iReadDataLen := iRecvLen;
    
    while TRUE do
    begin
      FD_ZERO(Tfd);
      FD_SET(TSockID_Local,Tfd);

      // TimeOut
      timeout.tv_sec := iTimeOut;
      timeout.tv_usec := 0;

      iSelectRc := Select(1,@Tfd,Nil,Nil,@timeout);

      // Error발생이면
      if iSelectRc < 0 then
      begin
        gf_Log('TCPRECVEX>> SELECT Error ['+IntToStr(WSAGetLastError())+']');
        Result := False;
        Exit;
      end;

      // TimeOut발생이면
      if iSelectRc = 0 then
      begin
        gf_Log('TCPRECVEX>> RECV Time Out 발생 : iReadAddLen = ['+IntToStr(iReadAddLen)+']');
        Result := False;
        Exit;
      end;

      iRawLen := Recv(TSockId_Local, pRecvBuff[iReadAddLen],iReadDataLen,0);
      if iRawLen <= 0 then
      begin
        gf_Log('TCPRECVEX >> [Main Data]Tcp Recv Error Errno[' +
                           IntToStr(WSAGetLastError()) + '] : iReadAddLen = [' +
                           IntToStr(iReadAddLen)+']');
        Result := False;
        Exit;
      end;

      // Read개수증가
      Inc(iReadAddLen,iRawLen);

      if iRawLen < iReadDataLen then
      begin
        // Read한개수만큼 감소(다시 읽어야할 개수)
        Dec(iReaddataLen,iRawLen);
      end else
      if iRawLen > iReadDataLen then
      begin
         gf_Log('TCPRECVEX>> Recv요청한 자료보다많이 들어옴 ReqLen[' +
                            IntToStr(iReadDataLen) + '] ReadLen[' +
                            IntToStr(iRawLen) + ']');
         Result := False;
         Exit;
      end else
      begin
        Break;
      end;
    end; // end While

    Result := True;
end;

//*=======================================================================*/
//* TCP Open
//*=======================================================================*/
{$DEFINE CLIENT}
//{$DEFINE SERVER}
function TcpOpen(cpServerIP:PChar; iPortID:Integer):integer;
var
//   len:integer;
   TSockID_Local : TSocket;
   my_addr:TSockAddrIn;
   iSndRcvBuff : integer;
   iStatus     : Integer;
begin
   // socket : create socket...
   TSockId_Local := Socket(AF_INET,SOCK_STREAM,0);
        // AF_INET : Unix internal protocols...
        // SOCK_STREAM : datagram socket...
        // AF_INET + SOCK_DGRAM => UDP...
        // return : success > 0, fail < 0...

   // socket function error check...
   if TSockId_Local < 0 then
   begin
        iStatus := WSAGetLastError();
        gf_Log('TcpOpen Error1>> '+ IntToStr(iStatus)+ '');
        result:=-iStatus;
        exit;
   end;

   my_addr.sin_family:=AF_INET;
   my_addr.sin_port:=htons(iPortId);
                   // host byte order : pc...(little endian)
                   // network byte order : Unix,Mac...(big endian)
                   // htons : converts a u_shortw(16 bit) from host byte order
                   //                                to network byte order.
//     len:=sizeof(TSockAddrIn);
{$ifdef CLIENT}
   my_addr.sin_addr.s_addr:=inet_addr(cpServerIP);
{$endif}
{$ifdef SERVER}
   my_addr.sin_addr.s_addr:=htonl(INADDR_ANY);
{$endif}
                          // htonl : converts a u_long(32 bit) from host
                          //                         to network byte order.

{$ifdef CLIENT}
   if connect(TSockId_Local,my_addr,sizeof(my_addr)) < 0 then
   begin
        // bind function error check
        iStatus := WSAGetLastError();
        gf_Log('TcpOpen Error2>> '+ IntToStr(iStatus)+ '');
        CloseSocket(TSockId_Local);
        result:=-iStatus;
        exit;
   end;
{$endif}  // ifdef client

{$ifdef SERVER}
   // bind : assigns a name to an unnamed socket...
   if bind(TSockId_Local, my_addr, sizeof(my_addr))<0 then
          // sock : socket function return value( new socket )
          // my_addr, sizeof(my_addr) : pointer to a socket address, length
   begin
        // bind function error check
        iStatus:=WSAGetLastError();
        CloseSocket(TSockId_Local);
        result:=-iStatus;
        exit;
   end;
{$endif} // ifdef server

   //Send,Recv Buff Size Increment
   iSndRcvBuff := 8192;
   if SetSockOpt(TsockID_Local,SOL_SOCKET,SO_SNDBUF,@iSndRcvBuff,sizeof(iSndRcvBuff)) < 0 then
   begin
        iStatus:=WSAGetLastError();
        gf_Log('TcpOpen Error3>> '+ IntToStr(iStatus)+ '');
        result := -iStatus;
        exit;
   end;
   if SetSockOpt(TsockID_Local,SOL_SOCKET,SO_RCVBUF,@iSndRcvBuff,sizeof(iSndRcvBuff)) < 0 then
   begin
     iStatus:=WSAGetLastError();
     gf_Log('TcpOpen Error4>> '+ IntToStr(iStatus)+ '');
     result := -iStatus;
     exit;
   end;

   result := TSockID_Local;
end;

//*=======================================================================*/
//* TCP Close
//*=======================================================================*/
procedure TcpClose(TSockID_Local:Integer);
begin
  if TSockId_Local > 0 then
  begin
    { Close the socket }
    ShutDown(TsockID_Local,2);
    CloseSocket(TSockId_Local);
  end;
end;

//*=======================================================================*/
//* WinSockInit
//*=======================================================================*/
function WinsockInit:integer;
var
   wVersionRequested:word;
   wdata:TWSAData;
begin
   { Start up Winsock }
   wVersionRequested := MAKEWORD(1,1);
   if WSASTartup({\$0101}wVersionRequested,wdata)<>0 then // success --> 0...
   begin
     result:= -WSAGetLastError(); //SOCKET_ERROR;
     exit;
   end;
   if ((LOBYTE(wdata.wVersion)<>1) or (HIBYTE(wdata.wVersion)<>1) )then
   begin
     WSACleanup();
     WSASetLastError(WSAEINVAL);
     result:= -1; //SOCKET_ERROR;
     exit;
   end;
   WSASetLastError(0);
   result := 1;
end;

//*=======================================================================*/
//* WinSockTerm
//*=======================================================================*/
procedure WinsockTerm;
begin
     // Attempt to shut down winsock
     WSACleanup();
end;

//*=======================================================================*/
// fnThreadKilled()
//*=======================================================================*/
function fnThreadKilled(TThreadID:TThread;
                        bTerminateThreadFlag : Boolean):integer;
var
   iCount : LongInt;
   bFreeOnTerminate : Boolean;
   dCheck : DWord;
   bCheck : Boolean;
   MyHandle : Integer;
begin
  if TThreadID = Nil then
  begin
{$IFDEF NSW_LOG}
gf_Log('fnThreadKilled : ThreadID Nil -> Exit');
{$ENDIF}
    result := -1;
    exit;
  end;

{$IFDEF NSW_LOG}
MyHandle := TThreadID.Handle;
gf_Log('fnThreadKilled : Thread Killed Start ['+IntToStr(MyHandle)+']');
{$ENDIF}

  try
    bCheck := False;
    bFreeOnTerminate := False;

    if not bTerminateThreadFlag then
    begin
      bFreeOnTerminate := TThreadID.FreeOnTerminate;
      TThreadID.terminate;
    end;

    if bTerminateThreadFlag then
    begin
      // TerminateThread는 강제적으로 Kill되므로 Thread가 I/O발생시 D/B손상
      // 여기에서는 accept,recv가 Blocking Mode일때 사용
      bCheck := TerminateThread(TThreadID.Handle, 0); // API함수
    end;

    iCount := 0;
    While True do
    begin
      if iCount > 300 then  // Max 30초까지 기다림
      begin
{$IFDEF NSW_LOG}
gf_Log('fnThreadKilled : No Terminated -> TerminateThread Call ['+IntToStr(MyHandle)+']');
{$ENDIF}
        TerminateThread(TThreadID.Handle, 0); // API함수
        Result := -1;
        Exit;
      end;

      Inc(iCount);

      if not bTerminateThreadFlag then
      begin
         dCheck := WaitForSingleObject(TThreadID.Handle,0);
         if dCheck = WAIT_OBJECT_0 then // Killed
         begin
{$IFDEF NSW_LOG}
gf_Log('fnThreadKilled : Terminated Success['+IntToStr(MyHandle)+']');
{$ENDIF}
            break;
         end
         else if dCheck = WAIT_TIMEOUT then // running
         begin
           sleep(100);
           continue;
         end else // Abort
         begin
           // FreeOnTerminate = True일경우 Handle까지 반환됨
           // 그러므로 WAIT_ABANDONED될수 있다.
{$IFDEF NSW_LOG}
gf_Log('fnThreadKilled : Terminated Success WAIT_ABANDONED['+IntToStr(MyHandle)+']');
{$ENDIF}
           break;
         end;
      end;

      if bTerminateThreadFlag then
      begin
        // TerminateThread는 강제적으로 Kill되므로 Thread가 I/O발생시 D/B손상
        // 여기에서는 accept,recv가 Blocking Mode이므로사용
        if bCheck = True then Break;
        bCheck := TerminateThread(TThreadID.Handle, 0); // API함수
        sleep(100);
      end;
    end; // end while

    if not bTerminateThreadFlag then
    begin
      if not bFreeOnTerminate then
        TThreadID.free; //destroy call
    end;
  except
    on E : Exception do
    begin
      // TThreadID변수가 해당 Thread가 Kill되면서 Nil로 만드므로 TThreadID.Handle
      // 이 Access Viroation발생 가능함 -> 여기서는 Kill된것으로 간주함
    end;
  end;

{$IFDEF NSW_LOG}
gf_Log('fnThreadKilled : Thread Kill Success['+IntToStr(MyHandle)+']');
{$ENDIF}

  result := 1;
end; // end thread killed function

function MoveDataStr(Source : String; iSize : Integer) : String;
var
  I : Integer;
begin
  Result := Source;
  for I := iSize - Length(Result) - 1 downto 1 do
    Result := Result + ' ';
  Result := copy(Result, 1, iSize-1);
end;

procedure MoveDataChar(Dest : PChar; Source : String; iSize : Integer);
var
  I : Integer;
  iSourceSize : Integer;
  iMoveLen : Integer;
begin
  fnCharSet(Dest,' ',iSize);
  iSourceSize := Length(Source);
  iMoveLen := iSourceSize;
  if iSize < iSourceSize then
    iMoveLen := iSize;

  for I := 1 to iMoveLen do
    Dest[I-1] := Char(Source[I]);
end;

function fnThreadAlive(hThreadHandle : THandle) : Boolean;
var
  dCheck : DWord;
begin
  dCheck := WaitForSingleObject(hThreadHandle,0);
  if dCheck = WAIT_OBJECT_0 then // Killed
    Result := False
  else if dCheck = WAIT_TIMEOUT then // running
    Result := True
  else
    Result := False;
end;

function fnQueueOpen(var MyQueue     : TDRSHMQueue;
                     MyQueueName : String;
                     MyQueueSize : Integer;
                     bCreateFlag : Boolean) : Boolean;
begin
  if MyQueueName = '' then
  begin
    Result := False;
    Exit;
  end;
  
  MyQueue := TDRSHMQueue.Create(Nil);
  MyQueue.Visible     := False;
  MyQueue.QMemoryName := MyQueueName;
  MyQueue.QueSize     := MyQueueSize;

  MyQueue.QOpen;
  if MyQueue.RerrorNo < 0 then
  begin
    if bCreateFlag then
    begin
      MyQueue.QCreate;
      if MyQueue.RerrorNo < 0 then
      begin
        Result := False;
        Exit;
      end;
    end else
    begin
      Result := False;
      Exit;
    end;
  end;

  Result := True;
end;

procedure fnQueueClose(MyQueue : TDRSHMQueue);
begin
  MyQueue.QClose;
  MyQueue.Destroy;
end;

//-----------------------------------------------------------------------
// MyStartService
//-----------------------------------------------------------------------
function MyStartService(pszInternalName : PChar) : Boolean;
var
  hSCM      : THANDLE;
  hService  : THANDLE;
  cpTemp    : PChar;
  ErrorCode : Integer;
begin
   // Open the SCM and the desired service.
   hSCM     := OpenSCManager(Nil, Nil, SC_MANAGER_CONNECT);
   if hSCM = 0 then
   begin
     ErrorCode := GetLastError;
     gvSvrErrorNo := ErrorCode;
     gvSvrExtMsg := '[SVC_START]>> Error OpenSCManager (' + IntToStr(ErrorCode) + ')';
     Result := False;
     Exit;
   end;

   hService := OpenService(hSCM, pszInternalName, SERVICE_START);
   if hService = 0 then
   begin
     ErrorCode := GetLastError;
     gvSvrErrorNo := ErrorCode;
     gvSvrExtMsg  := '[SVC_START]>> Error OpenService (' + IntToStr(ErrorCode) + ')';
     CloseServiceHandle(hSCM);
     Result := False;
     Exit;
   end;

   // Tell the service to start.
   if not StartService(hService, 0, cpTemp) then
   begin
     ErrorCode := GetLastError;
     if ErrorCode = ERROR_SERVICE_ALREADY_RUNNING then
     begin
       // Close the service and the SCM.
       CloseServiceHandle(hService);
       CloseServiceHandle(hSCM);
       Result := True;
       Exit;
     end;
     
     gvSvrErrorNo := ErrorCode;     
     gvSvrExtMsg := '[SVC_START]>> Error StartService (' + IntToStr(ErrorCode) + ')';
     // Close the service and the SCM.
     CloseServiceHandle(hService);
     CloseServiceHandle(hSCM);
     Result := False;
     Exit;
   end;

   // Wait for the service to Start.
   if not WaitForServiceToReachState(pszInternalName, SERVICE_RUNNING, gcSVC_CTRL_TIMEOUT) then
   begin
     // Close the service and the SCM.
     CloseServiceHandle(hService);
     CloseServiceHandle(hSCM);
     Result := False;
     Exit;
   end;

   // Close the service and the SCM.
   CloseServiceHandle(hService);
   CloseServiceHandle(hSCM);
   Result := True;
end;

//-----------------------------------------------------------------------
// MyStopService
//-----------------------------------------------------------------------
function MyStopService(pszInternalName : PChar) : Boolean;
var
  hSCM,hService : THandle;
  ss            : SERVICE_STATUS;
  ErrorCode     : Integer;
begin
   // Open the SCM and the desired service.
   hSCM := OpenSCManager(Nil, Nil, SC_MANAGER_CONNECT);
   if hSCM = 0 then
   begin
     ErrorCode := GetLastError;
     gvSvrErrorNo := ErrorCode;
     gvSvrExtMsg := '[SVC_STOP]>> Error OpenSCManager (' + IntToStr(ErrorCode) + ')';
     Result := False;
     Exit;
   end;

   hService := OpenService(hSCM, pszInternalName, SERVICE_STOP);
   if hService = 0 then
   begin
     ErrorCode := GetLastError;
     gvSvrErrorNo := ErrorCode;
     gvSvrExtMsg := '[SVC_STOP]>> Error OpenService (' + IntToStr(ErrorCode) + ')';
     CloseServiceHandle(hSCM);
     Result := False;
     Exit;
   end;

   // Tell the service to stop.
   if not ControlService(hService, SERVICE_CONTROL_STOP, ss) then
   begin
     ErrorCode := GetLastError;
     if ErrorCode = ERROR_SERVICE_NOT_ACTIVE then
     begin
       // Close the service and the SCM.
       CloseServiceHandle(hService);
       CloseServiceHandle(hSCM);
       Result := True;
       Exit;
     end else
     gvSvrErrorNo := ErrorCode;
     gvSvrExtMsg := '[SVC_STOP]>> Error ControlService (' + IntToStr(ErrorCode) + ')';
     // Close the service and the SCM.
     CloseServiceHandle(hService);
     CloseServiceHandle(hSCM);
     Result := False;
     Exit;
   end;

   // Wait for the service to stop.
   if not WaitForServiceToReachState(pszInternalName, SERVICE_STOPPED, gcSVC_CTRL_TIMEOUT) then
   begin
     // Close the service and the SCM.
     CloseServiceHandle(hService);
     CloseServiceHandle(hSCM);
     Result := False;
     Exit;
   end;

   // Close the service and the SCM.
   CloseServiceHandle(hService);
   CloseServiceHandle(hSCM);
   Result := True;

end;

//-----------------------------------------------------------------------
// WaitForServiceToReachState
// LMS Modify 2004.01.15
//-----------------------------------------------------------------------
function WaitForServiceToReachState(
                                  pszInternalName: PChar;
                                  dwDesiredState : DWord;
                                  dwMilliSecond  : DWord) : Boolean;
var
   hSCM      : THANDLE;
   hService  : THANDLE;
   ErrorCode : Integer;
   ss        : SERVICE_STATUS;
   dwTimeOut, dwChkP : DWord;
begin
   // Open the SCM and the desired service.
   hSCM := OpenSCManager(Nil, Nil, SC_MANAGER_CONNECT);
   if hSCM = 0 then
   begin
     ErrorCode    := GetLastError;
     gvSvrErrorNo := ErrorCode;
     gvSvrExtMsg := '[SVC_WAIT]>> Error OpenSCManager (' + IntToStr(ErrorCode) + ')';
     Result := False;
     Exit;
   end;

   hService := OpenService(hSCM, pszInternalName, SERVICE_QUERY_STATUS);
   if hService = 0 then
   begin
     ErrorCode    := GetLastError;
     gvSvrErrorNo := ErrorCode;
     gvSvrExtMsg  := '[SVC_WAIT]>> Error OpenService( ' + IntToStr(ErrorCode) + ')';
     CloseServiceHandle(hSCM);
     Result := False;
     Exit;
   end;

   // Check service status
   if not QueryServiceStatus(hService, ss) then
   begin
     ErrorCode    := GetLastError;
     gvSvrErrorNo := ErrorCode;
     gvSvrExtMsg  := '[SVC_WAIT]>> Error QueryServiceStatus (' + IntToStr(ErrorCode) + ')';
     CloseServiceHandle(hService);
     CloseServiceHandle(hSCM);
     Result := False;
     Exit;
   end;

   ss.dwCurrentState := 0;
   dwTimeOut := GetTickCount() + dwMilliSecond;

   // Check service status unitil current service status is desired status
   While (ss.dwCurrentState <> dwDesiredState) do
   begin
     dwChkP := ss.dwCheckPoint;

     // Wait a bit before checking status again
     Sleep(ss.dwWaitHint);

     if not QueryServiceStatus(hService, ss) then
     begin
       ErrorCode    := GetLastError;
       gvSvrErrorNo := ErrorCode;
       gvSvrExtMsg  := '[SVC_WAIT]>> Error QueryServiceStatus (' + IntToStr(ErrorCode) + ')';
       break;
     end;

     // Check timeout
     if ((dwMilliSecond <> INFINITE) and (dwTimeOut < GetTickCount())) then
     begin
       ErrorCode    := ERROR_TIMEOUT;
       SetLastError(ErrorCode);
       gvSvrErrorNo := ErrorCode;
       gvSvrExtMsg  := '[SVC_WAIT]>> Error Timeout (' + IntToStr(ErrorCode) + ')';
       break;
     end;

     // Timeout이 없을 경우에만 확인 (무한 Loop 방지)
     if ((dwMilliSecond = INFINITE) and (ss.dwCheckPoint < dwChkP)) then
     begin
       // QueryServiceStatus didn't increment dwCheckPoint as it should have
       ErrorCode    := GetLastError;
       gvSvrErrorNo := ErrorCode;
       gvSvrExtMsg  := '[SVC_WAIT]>> Error QueryServiceStatus ('
                       + IntToStr(ErrorCode) + ')';
       break;
     end;
   end;

   // Close the service and the SCM.
   CloseServiceHandle(hService);
   CloseServiceHandle(hSCM);
   Result := ss.dwCurrentState = dwDesiredState;
end;

//-----------------------------------------------------------------------
// Get System Error Message String
// LMS Add 2004.01.15
//-----------------------------------------------------------------------
function  fnGetSysErrStr(sErrCode: DWORD): string;
var
  lpMsgBuf: pChar;
  msgStr  : string;
begin
  FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM,
                NIL,
                sErrCode,
                $00000400, // MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
                @lpMsgBuf,
                0,
                NIL);

  msgStr := '';
  if (lpMsgBuf <> NIL) then
    msgStr := string(lpMsgBuf);

  // Free the buffer.
  LocalFree(Integer(lpMsgBuf));

  Result := msgStr;
end;
end.
