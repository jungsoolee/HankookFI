unit SCCSRDlgForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DRSpecial, StdCtrls, Buttons, DRAdditional, ExtCtrls, DRStandard;

type
  TForm_SRDlg = class(TForm)
    MessageBar: TDRMessageBar;
    DRPanel_Btn: TDRPanel;
    DRBitBtn1: TDRBitBtn;
    DRBitBtn2: TDRBitBtn;
    DRBitBtn3: TDRBitBtn;
    DRBitBtn4: TDRBitBtn;
    procedure EnableForm;
    procedure DisableForm;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DRBitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FormDisabled : boolean;      // Form�� Disable �Ǿ� �ִ��� ����
    CompStatList : TStringList;  // Component�� Enable/Disable ���¸� ����
  public
    { Public declarations }
  end;

var
  Form_SRDlg: TForm_SRDlg;

implementation

{$R *.DFM}

uses
   SCCLib, SCCGlobalType;

procedure TForm_SRDlg.FormCreate(Sender: TObject);
begin
   FormDisabled := False;
   CompStatList := TStringList.Create;
end;


procedure TForm_SRDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   CompStatList.Free;
   Action := caFree;
end;

procedure TForm_SRDlg.DRBitBtn1Click(Sender: TObject);
begin
   Close;
end;

//------------------------------------------------------------------------------
//  Enable Form
//------------------------------------------------------------------------------
procedure TForm_SRDlg.EnableForm;
var
   I : Integer;
begin
   if not FormDisabled then Exit; // �̹� Form Enable ����

   Screen.Cursor := crDefault;
   for I := 0 to ComponentCount -1 do
   begin
      if (Components[I] is TControl) then
      begin
         if CompStatList.Strings[I] = 'E' then  // Enable ����
            (Components[I] as TControl).Enabled := True
         else
            (Components[I] as TControl).Enabled := False;
      end;
   end;
   gf_EnableMainMenu;

   FormDisabled := False;
end;

//------------------------------------------------------------------------------
//  Disable Form
//------------------------------------------------------------------------------
procedure TForm_SRDlg.DisableForm;
var
   I : Integer;
begin
   if FormDisabled then Exit;  // �̹� Form Disable ����

   Screen.Cursor := crHourGlass;
   CompStatList.Clear;
   for I := 0 to ComponentCount -1 do
   begin
      if (Components[I] is TControl) then
      begin
         // ���� ���� ����
         if (Components[I] as TControl).Enabled then // Enable ����
             CompStatList.Add('E')
         else  // Disable ����
             CompStatList.Add('D');
         (Components[I] as TControl).Enabled := False;
      end;
   end;
   gf_DisableMainMenu;
   
   FormDisabled := True;
end;
end.
