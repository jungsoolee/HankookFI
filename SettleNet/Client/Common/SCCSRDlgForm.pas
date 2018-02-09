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
    FormDisabled : boolean;      // Form이 Disable 되어 있는지 여부
    CompStatList : TStringList;  // Component의 Enable/Disable 상태를 저장
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
   if not FormDisabled then Exit; // 이미 Form Enable 상태

   Screen.Cursor := crDefault;
   for I := 0 to ComponentCount -1 do
   begin
      if (Components[I] is TControl) then
      begin
         if CompStatList.Strings[I] = 'E' then  // Enable 상태
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
   if FormDisabled then Exit;  // 이미 Form Disable 상태

   Screen.Cursor := crHourGlass;
   CompStatList.Clear;
   for I := 0 to ComponentCount -1 do
   begin
      if (Components[I] is TControl) then
      begin
         // 현재 상태 저장
         if (Components[I] as TControl).Enabled then // Enable 상태
             CompStatList.Add('E')
         else  // Disable 상태
             CompStatList.Add('D');
         (Components[I] as TControl).Enabled := False;
      end;
   end;
   gf_DisableMainMenu;
   
   FormDisabled := True;
end;
end.
