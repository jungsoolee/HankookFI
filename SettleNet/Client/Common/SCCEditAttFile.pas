unit SCCEditAttFile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCCDlgForm, OleCtnrs, StdCtrls, Buttons, DRAdditional, ExtCtrls,
  DRStandard, DRSpecial, DRDialogs;

type
  TForm_EditAttFile = class(TForm_Dlg)
    DRPanel1: TDRPanel;
    OleContainer_EditForm: TOleContainer;
    procedure DRBitBtn3Click(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    sFullFileName : string;
    procedure LoadAttFile(DefFileName : string);


  end;

var
  Form_EditAttFile: TForm_EditAttFile;




implementation

{$R *.DFM}

{ TForm_Dlg1 }
uses
  SCCLib, SCCGlobalType, SCCCmuLib;

procedure TForm_EditAttFile.LoadAttFile(DefFileName : string);
begin

  sFullFileName := DefFileName;
  //OleContainer_EditForm.SetFocus;

  with OleContainer_EditForm do
  begin
    CreateLinkToFile(sFullFileName, false);         // ����
//  CreateObject('Excel.Application', False);
//  CreateObjectFromFile(sFullFileName, False);       // ����
    Iconic := False;    // ���� �Ǵ� ������ ������Ʈ�� ������ ǥ��
    DoVerb(ovPrimary);  // OLE ���� Ȱ��ȭ

  end; // end of with

end;



procedure TForm_EditAttFile.DRBitBtn3Click(Sender: TObject);
var
  DirUserData : string;
  sFileName   : string;

begin
  inherited;
  //sFileName := fnGetTokenStr(sFullFileName, '\', 1);
  sFileName := '���ο���20010531.xls';
  DirUserData := gvDirUserData;
  with OleContainer_EditForm do
  begin
    //OleObject.ActiveDocument.SaveAs(DirUserData+sFileName);

    //SaveAsDocument(DirUserData+sFileName);
    //SaveToFile(DirUserData+sFileName);
    if Modified then
      ShowMessage('�ٲ��?');

  end;
end;

end.
