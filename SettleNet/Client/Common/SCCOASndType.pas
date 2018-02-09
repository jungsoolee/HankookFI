unit SCCOASndType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SCCDlgForm, DRDialogs, StdCtrls, Buttons, DRAdditional,
  ExtCtrls, DRStandard, DRSpecial, DB, ADODB;

type
  TDlgForm_OASndType = class(TForm_Dlg)
    DRPanel1: TDRPanel;
    ADOQuery_Tmp: TADOQuery;
    DRGroupBox1: TDRGroupBox;
    DRRadioButton_AutoOK: TDRRadioButton;
    DRRadioButton_AutoNO: TDRRadioButton;
    procedure DRBitBtn2Click(Sender: TObject);
    procedure DRBitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    OASndType_AutoOK : string;
  end;

var
  DlgForm_OASndType: TDlgForm_OASndType;

implementation

{$R *.dfm}

uses
  SCCLib,SCCGlobalType;

procedure TDlgForm_OASndType.DRBitBtn2Click(Sender: TObject);
var
   sOptCode : String;
begin
  inherited;
   if DRRadioButton_AutoOK.Checked then OASndType_AutoOK := 'Y'
                                   else OASndType_AutoOK := 'N';

   gf_ShowMessage(MessageBar, mtInformation, 1010, ''); //입력 중입니다.
   DisableForm;

   if gvDeptCode = gcDEPT_CODE_INT then  //국제부주식
      sOptCode := 'HO2' else sOptCode := 'HO6';

   with ADOQuery_Tmp do
   begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE SUSYOPT_TBL SET OPT_VALUE = ''' + OASndType_AutoOK + ''''
             +'WHERE OPT_CODE = ''' + sOptCode + '''');

      try
         gf_ADOExecSQL(ADOQuery_Tmp);
      except
         on E : Exception do
         begin
           gf_ShowErrDlgMessage(Self.Tag, 9001, 'ADOQuery_Tmp[Update]: ' + E.Message,0);
           Exit;
         end;
      end;
   end;

   EnableForm;
   gf_ShowMessage(MessageBar, mtInformation, 1011, ''); //입력 완료

end;

procedure TDlgForm_OASndType.DRBitBtn1Click(Sender: TObject);
begin
  inherited;

   ModalResult := mrOK;

end;

end.
