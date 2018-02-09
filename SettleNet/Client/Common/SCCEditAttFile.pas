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
    CreateLinkToFile(sFullFileName, false);         // 연결
//  CreateObject('Excel.Application', False);
//  CreateObjectFromFile(sFullFileName, False);       // 포함
    Iconic := False;    // 연결 또는 삽입한 오브젝트의 아이콘 표시
    DoVerb(ovPrimary);  // OLE 서버 활성화

  end; // end of with

end;



procedure TForm_EditAttFile.DRBitBtn3Click(Sender: TObject);
var
  DirUserData : string;
  sFileName   : string;

begin
  inherited;
  //sFileName := fnGetTokenStr(sFullFileName, '\', 1);
  sFileName := '국민연금20010531.xls';
  DirUserData := gvDirUserData;
  with OleContainer_EditForm do
  begin
    //OleObject.ActiveDocument.SaveAs(DirUserData+sFileName);

    //SaveAsDocument(DirUserData+sFileName);
    //SaveToFile(DirUserData+sFileName);
    if Modified then
      ShowMessage('바꿨냐?');

  end;
end;

end.
