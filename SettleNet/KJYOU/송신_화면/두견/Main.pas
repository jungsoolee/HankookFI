unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, DRWin32, Grids, DRStringgrid, DRStandard, StdCtrls,
  Mask, DRAdditional, Buttons, DRSpecial, ExtCtrls, DRColorTab,
  DRCodeControl;

type
  TForm1 = class(TForm)
    DRPanel1: TDRPanel;
    DRPanel3: TDRPanel;
    DRBitBtn1: TDRBitBtn;
    DRBitBtn2: TDRBitBtn;
    MessageBar: TDRMessageBar;
    DRBitBtn3: TDRBitBtn;
    DRBitBtn4: TDRBitBtn;
    DRFramePanel_Query: TDRFramePanel;
    DRLabel3: TDRLabel;
    DRLabel5: TDRLabel;
    DRMaskEdit_Date1: TDRMaskEdit;
    DRComboBox1: TDRComboBox;
    DRLabel1: TDRLabel;
    DRPanel6: TDRPanel;
    DRPanel2: TDRPanel;
    DRBitBtn5: TDRBitBtn;
    DRLabel6: TDRLabel;
    DRMaskEdit1: TDRMaskEdit;
    DRLabel7: TDRLabel;
    DRUserDblCodeCombo1: TDRUserDblCodeCombo;
    DRPanel7: TDRPanel;
    DRStrGrid_SntFaxTlx: TDRStringGrid;
    DRPanel4: TDRPanel;
    DRLabel_SntMail: TDRLabel;
    DRSpeedBtn_SntEmailPrint: TDRSpeedButton;
    DRSpeedBtn_EmailResend: TDRSpeedButton;
    DRSpeedBtn_EmailExport: TDRSpeedButton;
    DRSpeedBtn_SntEmailSelect: TDRSpeedButton;
    DRSpeedBtn_SntMailRefresh: TDRSpeedButton;
    DRSpeedBtn_SntMailPDFExport: TDRSpeedButton;
    DRSpeedButton_SntMail: TDRSpeedButton;
    DRPanel5: TDRPanel;
    DRRadioBtn_EmailSend: TDRRadioButton;
    DRRadioBtn_EmailError: TDRRadioButton;
    DRRadioBtn_EmailAll: TDRRadioButton;
    DRCheckBox_EmailTotFreq: TDRCheckBox;
    DRRadioButton1: TDRRadioButton;
    DRRadioButton2: TDRRadioButton;
    DRRadioButton3: TDRRadioButton;
    DRPanel8: TDRPanel;
    DRPanel_SndMailTitle: TDRPanel;
    DRLabel_SndMail: TDRLabel;
    DRSpeedBtn_SndMailDir: TDRSpeedButton;
    DRSpeedBtn_Export: TDRSpeedButton;
    DRSpeedBtn_SndMailRefresh: TDRSpeedButton;
    DRSpeedBtn_SndMailPDFExport: TDRSpeedButton;
    DRSpeedButton_SndMail: TDRSpeedButton;
    DRRadioButton4: TDRRadioButton;
    DRRadioButton5: TDRRadioButton;
    DRRadioButton6: TDRRadioButton;
    DRCheckBox1: TDRCheckBox;
    DRStrGrid_SndMail_Total: TDRStringGrid;
    DRStringGrid1: TDRStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure DRCheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  // 사번
  begin
    DRUserDblCodeCombo1.AddItem('전체', '전체');
    DRUserDblCodeCombo1.AddItem('975001', '금상1');
    DRUserDblCodeCombo1.AddItem('975023', '금상2');
    DRUserDblCodeCombo1.AddItem('000000', '금상3');
    DRUserDblCodeCombo1.AddItem('123456', '금상4');
  end;

  begin
    for i:= 0 to DRPanel8.ControlCount-1 do
    begin
      if DRPanel8.Controls[i] is TDRStringGrid then
      begin
        TDRStringGrid(DRPanel8.Controls[i]).Align := alClient;
        if TDRStringGrid(DRPanel8.Controls[i]).Tag <> 0 then
          TDRStringGrid(DRPanel8.Controls[i]).Visible := False;
      end;
    end;

//    for i:= 0 to DRPanel8.ControlCount-1 do
//    begin
//      ShowMessage(DRPanel8.Controls[i].Name);
//    end;


  end;

end;

procedure TForm1.DRCheckBox1Click(Sender: TObject);
begin
//  if (Sender as TDRCheckBox).Checked then
//  begin
//    DRStrGrid_SndMail_Total.Visible := False;
//    DRStrGrid_SndMail_NoSend.Visible := True;
//  end else begin
//    DRStrGrid_SndMail_Total.Visible := True;
//    DRStrGrid_SndMail_NoSend.Visible := False;
//  end;
end;

end.
