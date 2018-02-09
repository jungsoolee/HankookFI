unit SCFH8801;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SCCSRMgrFrame, Menus, DRStandard, ImgList, DRWin32, StdCtrls,
  Mask, DRAdditional, Buttons, ExtCtrls;

type
  TForm_SCFH8801 = class(TForm_SRMgrFrame)
    function  RunTran(pTranCode: string): boolean;
    procedure FormCreate(Sender: TObject);
    procedure DRSpeedBtn_SndClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_SCFH8801: TForm_SCFH8801;

implementation

{$R *.dfm}

uses
  SCCLib, SCCGlobalType,
  SCFH8801_SND;

procedure TForm_SCFH8801.FormCreate(Sender: TObject);
var
  sCurTime, sCurDate : String;
begin
  inherited;
  DRSpeedBtn_SndClick(DRSpeedBtn_Snd);  // Default �ڷ� ���� ����
  DRMaskEdit_Date.SelectAll;

//==============================================================================
// TRȭ�� ����� gc
//==============================================================================
  sCurTime := gf_GetCurTime;
  sCurDate := gf_GetCurDate;
  gf_LogLstWrite(nil, gvDeptCode, gcDisINF_tr, gvOprUsrNo,
                 sCurDate, sCurTime, '', gvLocalIP, '', IntToStr(Tag), Caption, 'I');
end;

procedure TForm_SCFH8801.DRSpeedBtn_SndClick(Sender: TObject);
begin
  inherited;
  Screen.Cursor := crHourGlass;
  RunTran('SND');
  Screen.Cursor := crDefault;
end;

function TForm_SCFH8801.RunTran(pTranCode: string): boolean;
begin
  Result := True;
  if pTranCode = ActiveTranCode then  Exit;  // ���� �̹� ����Ǿ� �ִ� ���
  
  if pTranCode = 'SND' then
  begin
     CloseActiveChildForm;
     Application.CreateForm(TForm_SCFH8801_SND, Form_SCFH8801_SND);
     Result := ShowChildForm(Form_SCFH8801_SND); // Query & Display
  end;
  
  if Result then // Form Create �� ������ ���
     ActiveTranCode := pTranCode
  else
     ActiveTranCode := '';  // Clear: �ٽ� ����� �ش� TranCode �߻��� �� �ֵ���
end;

procedure TForm_SCFH8801.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  Form_SCFH8801_SND.FormKeyDown(Sender, Key, Shift);
end;

procedure TForm_SCFH8801.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
 sCurTime, sCurDate : String;
begin
  inherited;
  if Assigned(Form_SCFH8801_SND) then
  Form_SCFH8801_SND.Close;

//==============================================================================
// TRȭ�� ����� gc
//==============================================================================
  sCurTime := gf_GetCurTime;
  sCurDate := gf_GetCurDate;
  gf_LogLstWrite(nil, gvDeptCode, gcDisINF_tr, gvOprUsrNo,
                 sCurDate, '', sCurTime, gvLocalIP, '', IntToStr(Tag), Caption, 'U');
end;

end.
