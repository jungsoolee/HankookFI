unit EditEmailMeassge;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, ImgList, DB, ADODB, DRStandard, ComCtrls, DRWin32,
  Dialogs, DRDialogs, DRAdditional, DRSpecial, SCCLib, ShellAPI, CommCtrl,
  Math;

type
  TEditMail_Form = class(TForm)
    MessageBar: TDRMessageBar;
    DRPanel_Btn: TDRPanel;
    DRBitBtn1: TDRBitBtn;
    DRBitBtn2: TDRBitBtn;
    DRPanel1: TDRPanel;
    DRLabel1: TDRLabel;
    DRLabel2: TDRLabel;
    DRLabel5: TDRLabel;
    DRLabel6: TDRLabel;
    DRListView_SndAttFile: TDRListView;
    DRPanel2: TDRPanel;
    DRMemo_MailBody: TDRMemo;
    DREdit1: TDREdit;
    DREdit2: TDREdit;
    DREdit3: TDREdit;
    DRImg_Popup: TImageList;
    DRLabel3: TDRLabel;
    DREdit4: TDREdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function GetShellImage(FileName: PChar) : Integer;
    function SizetoStrSize(iFileSize: Extended): string;
    function FileNamedim(Str: string; count: Integer): string;
    function GetFileSize(sFileName: String): Extended;
  public
    { Public declarations }
  end;
var
  EditMail_Form: TEditMail_Form;


implementation

const
  ONE_FILE_NAME = 'C:\SettleNetTF\WorkingFI\HankookFI\SettleNet\Image\OneMail\������ǰ �ŷ���û Ȯ�μ�(���ȭ�ϸ�) - 12345678(���¹�ȣ) - 20180123(��������).pdf';
  TIE_FILE_NAME_1 = 'C:\SettleNetTF\WorkingFI\HankookFI\SettleNet\Image\TieMail\������ǰ �ŷ���û Ȯ�μ�(���ȭ�ϸ�) - 12345678(���¹�ȣ) - 20180123(��������) - 1.pdf';
  TIE_FILE_NAME_2 = 'C:\SettleNetTF\WorkingFI\HankookFI\SettleNet\Image\TieMail\������ǰ �ŷ���û Ȯ�μ�(���ȭ�ϸ�) - 12345678(���¹�ȣ) - 20180123(��������) - 2.pdf';
  TIE_FILE_NAME_3 = 'C:\SettleNetTF\WorkingFI\HankookFI\SettleNet\Image\TieMail\������ǰ �ŷ���û Ȯ�μ�(���ȭ�ϸ�) - 12345678-12(���¹�ȣ) - 20180123(��������).pdf';
  MAXLEN = 100;
{$R *.dfm}

function TEditMail_Form.FileNamedim(Str: string; count: Integer): string;

  function ExtractFileShortName(
    FileFullName: string): string;
  begin
    FileFullName := ExpandFileName(FileFullName);

    Result :=
      Copy(ExtractFileName(FileFullName), 1,
      Pos(ExtractFileExt(FileFullName),
      ExtractFileName(FileFullName)) - 1);
  end;

var
  FileName: string;
begin
  Result := ExtractFileName(Str);
  FileName := ExtractFileShortName(Str);
  if Length(FileName) > count then
    Result := Copy(FileName, 1, Count) + '..' + ExtractFileExt(str)

end;

function TEditMail_Form.GetFileSize(sFileName: String): Extended;
  function FileSize(hi, lo: Extended): Extended;
  begin
    Result := (hi * MAXDWORD) + lo;
  end;
var

  FindHandle: THandle;
       // iFileSize : LongInt;
  FindData: TWin32FindData;
begin
  try
    FindHandle := 0;
    if FileExists(sFileName) then
    begin
      FindHandle := Windows.FindFirstFile(PChar(sFileName), FindData);

      Result := Trunc(FileSize(FindData.nFileSizeHigh, FindData.nFileSizeLow));
    end else
      Result := -1;

  finally
    if FindHandle <> 0 then
      Windows.FindClose(FindHandle);
  end;

end;

procedure TEditMail_Form.FormCreate(Sender: TObject);
var
  sFullpathName : String;
  ListItem: TListItem;
  iFileSize: Extended;
begin
  ListItem := DRListView_SndAttFile.Items.Add;
  ListItem.ImageIndex := GetShellImage(pchar(ONE_FILE_NAME));
  iFileSize := GetFileSize(ONE_FILE_NAME);
  ListItem.Caption := FileNamedim(ONE_FILE_NAME, MAXLEN) + ' (' + SizetoStrSize(iFileSize) + ')';

//  ListItem := DRListView_SndAttFile.Items.Add;
//  ListItem.ImageIndex := GetShellImage(pchar(TIE_FILE_NAME_1));
//  iFileSize := GetFileSize(TIE_FILE_NAME_1);
//  ListItem.Caption := FileNamedim(TIE_FILE_NAME_1, MAXLEN) + ' (' + SizetoStrSize(iFileSize) + ')';
//
//  ListItem := DRListView_SndAttFile.Items.Add;
//  ListItem.ImageIndex := GetShellImage(pchar(TIE_FILE_NAME_2));
//  iFileSize := GetFileSize(TIE_FILE_NAME_2);
//  ListItem.Caption := FileNamedim(TIE_FILE_NAME_2, MAXLEN) + ' (' + SizetoStrSize(iFileSize) + ')';
//
//  ListItem := DRListView_SndAttFile.Items.Add;
//  ListItem.ImageIndex := GetShellImage(pchar(TIE_FILE_NAME_3));
//  iFileSize := GetFileSize(TIE_FILE_NAME_3);
//  ListItem.Caption := FileNamedim(TIE_FILE_NAME_3, MAXLEN) + ' (' + SizetoStrSize(iFileSize) + ')';

  begin
    DREdit1.Text := 'settlenet1@dataroad.co.kr';
    DREdit4.Text := '�α���;������;';
    DREdit3.Text := 'in@dr.com;yk@dr.com;';
    DREdit2.Text := '[�ѱ���������] ������ǰ �ŷ���û Ȯ�μ�';
    DRMemo_MailBody.Text := '������ǰ �ŷ���û Ȯ�μ�' + #13 + #10 +
                            '�����մϴ�.';
//    DREdit2.Text := '[�ѱ���������] ������ǰ �ŷ���û Ȯ�μ� �� 2��';
//    DRMemo_MailBody.Text := DRMemo_MailBody.Text + '������ǰ �ŷ���û Ȯ�μ� - 1' + #13 + #10 +
//                                                   '������ǰ �ŷ���û Ȯ�μ� - 2' + #13 + #10 +
//                                                   '������ǰ �ŷ���û Ȯ�μ� - 3' + #13 + #10 +
//                                                   '�����մϴ�.';

  end;
end;

function TEditMail_Form.GetShellImage(FileName: PChar): Integer;
var
  FileInfo: TSHFileInfo;
  Flags: Integer;
  Icn: Ticon;
begin
  try
    FillChar(FileInfo, SizeOf(FileInfo), #0);
    Flags := SHGFI_USEFILEATTRIBUTES or SHGFI_ICON or ILD_TRANSPARENT;

    //if Large then Flags := Flags or SHGFI_LARGEICON
    //else
    Flags := Flags or SHGFI_SMALLICON;

    SHGetFileInfo(FileName, 0, FileInfo, SizeOf(FileInfo), Flags);

    Icn := TIcon.Create;
    Icn.Handle := FileInfo.hIcon;

    Result := DRImg_Popup.AddIcon(Icn);

  finally
    FreeAndNil(Icn);
  end;

end;

function TEditMail_Form.SizetoStrSize(iFileSize: Extended): string;
begin
  if iFileSize < 0 then
    Result := '?? B'
  else if iFileSize < 1000 then
    Result := floattostr(iFileSize) + ' B'
  else if iFileSize < power(1000, 2) then
    Result := floattostr(round(iFileSize / 1000)) + ' KB'
  else
    Result := floattostr(round(iFileSize / power(1000, 2))) + ' MB';
end;

end.
