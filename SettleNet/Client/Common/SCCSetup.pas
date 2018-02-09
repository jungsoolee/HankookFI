unit SCCSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SCCDlgForm, DRDialogs, StdCtrls, Buttons, DRAdditional, SCCGlobalType, SCCLib,
  ExtCtrls, DRStandard, DRSpecial, DRColorTab, Grids, DRStringgrid, IniFiles,
  DB, ADODB;

type
  TForm_Setup = class(TForm_Dlg)
    DRPageControl_SystemSetup: TDRPageControl;
    DRTabSheet_User: TDRTabSheet;
    DRTabSheetSystem: TDRTabSheet;
    DRLabel1: TDRLabel;
    DRPanel1: TDRPanel;
    DRCheckBox_Today: TDRCheckBox;
    DRStringGrid_System: TDRStringGrid;
    ADOQuery_temp: TADOQuery;
    DRLabel2: TDRLabel;
    DRPanel2: TDRPanel;
    DRLabel_UserLocale: TDRLabel;
    DRBitBtn_ConfirmLocale: TDRBitBtn;
    procedure DRBitBtn2Click(Sender: TObject);
    Procedure UserSetup;
    Procedure SystemSetup;
    Procedure SystemQuery;

    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function GetSystemLanguage: String;
    procedure DRBitBtn_ConfirmLocaleClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Setup: TForm_Setup;
  EnvSetupInfo : TIniFile;
  SNDFORM     : String;
implementation

{$R *.dfm}

procedure TForm_Setup.DRBitBtn2Click(Sender: TObject);
begin
  inherited;
  //
  Case DRPageControl_SystemSetup.ActivePage.PageIndex of
    0: UserSetup;
    1: SystemSetup;
  end;


end;

procedure TForm_Setup.UserSetup;
begin
   if DRCheckBox_Today.Checked then
      EnvSetupInfo.WriteString(SNDFORM, 'TradeTodayCheck', 'Y')
   else
      EnvSetupInfo.WriteString(SNDFORM, 'TradeTodayCheck', 'N');

end;

procedure TForm_Setup.FormShow(Sender: TObject);

begin
   inherited;
   if gvCurSecType = gcSEC_EQUITY then
      SNDFORM := '2801'
   else
   if gvCurSecType = gcSEC_FUTURES then
      SNDFORM := '3801'
   else
   if gvCurSecType = gcSEC_BOND then
      SNDFORM := '7801';

   DRLabel1.Caption := '[' + SNDFORM + ']매매 송수신 Manager';

   EnvSetupInfo := TIniFile.Create(gvDirCfg + gcMainIniFileName);

   if EnvSetupInfo.ReadString(SNDFORM, 'TradeTodayCheck', 'N') = 'Y' then
      DRCheckBox_Today.Checked := True
   else
      DRCheckBox_Today.Checked := False;

   SystemQuery;

   DRLabel_UserLocale.Caption := GetSystemLanguage;

end;

procedure TForm_Setup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   inherited;
   FreeAndNil(EnvSetupInfo);
end;

procedure TForm_Setup.SystemSetup;
begin
  //
end;

procedure TForm_Setup.SystemQuery;
var
   iRow : Integer;
begin
   iRow := 0;
   with ADOQuery_temp, DRStringGrid_System do
   begin
      Close;
      SQL.Clear;

      SQL.Add(  'Select OPT_CODE, OPT_VALUE, INFO '
            + ' from SUSYOPT_TBL  ');

      Try
         gf_ADOQueryOpen(ADOQuery_temp);
         Except
         on E : Exception do
         begin    // Database 오류
            gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_temp[환경설정]: ' + E.Message, 0);
            gf_ShowMessage(MessageBar, mtError, 9001, 'ADOQuery_temp[환경설정]'); //Database 오류
            Exit;
         end;
      End;
      Rowcount := 2;
      Rows[1].Clear;
      while not Eof do
      begin
         inc(iRow);
         Cells[0,iRow] := Trim(FieldByname('OPT_CODE').asString);
         Cells[1,iRow] := Trim(FieldByname('OPT_VALUE').asString);
         Cells[2,iRow] := Trim(FieldByname('INFO').asString);
         Next;
      end;
      RowCount := iRow + 1;



   end;

end;

function TForm_Setup.GetSystemLanguage: String;
var
  wLang : LangID;
  szLang: Array [0..254] of Char;
  Buffer : PChar;
  Size : integer;
  sNation : String;
  
  function GetLocalNameFromID(LocalID : LangID) : String;
  var
    sResult : String;
  begin
    case LocalID of
      1078 :   sResult := 'Afrikaans';
      1052 :   sResult := 'Albanian';
      1025 :   sResult := 'Arabic'; 
      1069 :   sResult := 'Basque'; 
      1059 :   sResult := 'Belarusian';
      5146 :   sResult := 'Bosnian'; 
      1150 :   sResult := 'Breton'; 
      1026 :   sResult := 'Bulgarian'; 
      1027 :   sResult := 'Catalan'; 
      1050 :   sResult := 'Croatian';
      1029 :   sResult := 'Czech';
      1030 :   sResult := 'Danish';
      1043 :   sResult := 'Dutch'; 
      1033 :   sResult := 'English';
      9998 :   sResult := 'Esperanto';
      1061 :   sResult := 'Estonian'; 
      1065 :   sResult := 'Farsi';
      1035 :   sResult := 'Finnish';
      1036 :   sResult := 'French';
      1110 :   sResult := 'Galician'; 
      1031 :   sResult := 'German';
      1032 :   sResult := 'Greek';
      1037 :   sResult := 'Hebrew';
      1038 :   sResult := 'Hungarian';
      15   :   sResult := 'Icelandic';
      1057 :   sResult := 'Indonesian';
      2108 :   sResult := 'Irish';
      1040 :   sResult := 'Italian';
      1041 :   sResult := 'Japanese';
      1042 :   sResult := 'Korean';
      9999 :   sResult := 'Kurdish';
      1062 :   sResult := 'Latvian';
      1063 :   sResult := 'Lithuanian';
      4103 :   sResult := 'Luxembourgish';
      1071 :   sResult := 'Macedonian';
      1086 :   sResult := 'Malay';
      1104 :   sResult := 'Mongolian';
      1044 :   sResult := 'Norwegian';
      2068 :   sResult := 'NorwegianNynorsk';
      1045 :   sResult := 'Polish';
      2070 :   sResult := 'Portuguese';
      1046 :   sResult := 'PortugueseBR';
      1048 :   sResult := 'Romanian';
      1049 :   sResult := 'Russian';
      3098 :   sResult := 'Serbian';
      2074 :   sResult := 'SerbianLatin';
      2052 :   sResult := 'SimpChinese';
      1051 :   sResult := 'Slovak';
      1060 :   sResult := 'Slovenian';
      1034 :   sResult := 'Spanish';
      3082 :   sResult := 'SpanishInternational';
      1053 :   sResult := 'Swedish';
      1054 :   sResult := 'Thai';
      1028 :   sResult := 'TradChinese';
      1055 :   sResult := 'Turkish';
      1058 :   sResult := 'Ukrainian';
      1091 :   sResult := 'Uzbek';
      1160 :   sResult := 'Welsh';

      else Result := '';
    end;

    Result := sResult;
  end;
begin
  Result  := '형식 : 알 수 없음' + '              '
           + '시스템 로캘 : 알 수 없음';

  sNation := '';
  // wLang  : 국가 및 언어 - 형식(한국 - 1042)
  // Buffer : 국가 및 언어 - 시스템 로캘(한국 - Korean)
  wLang := GetSystemDefaultLCID;
  Size := GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_SENGLANGUAGE, nil, 0);
  GetMem(Buffer, Size);
  try
    GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_SENGLANGUAGE, Buffer, Size);
    sNation := GetLocalNameFromID(wLang);
    
    if sNation <> '' then
    begin
      Result := '형식 : ' + StrPas(Buffer) +'              '
              + '시스템 로캘 : ' + sNation;
    end else begin
      Result := '형식 : ' + StrPas(Buffer) +'              '
              + '시스템 로캘 : 알 수 없음';
    end;

  finally
    FreeMem(Buffer);
  end;
end;

procedure TForm_Setup.DRBitBtn_ConfirmLocaleClick(Sender: TObject);
begin
  inherited;
  DRLabel_UserLocale.Caption := GetSystemLanguage;
end;

end.
