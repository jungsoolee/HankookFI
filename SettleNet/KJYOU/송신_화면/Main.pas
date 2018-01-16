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
    DRLabel1: TDRLabel;
    DRPanel6: TDRPanel;
    DRPanel2: TDRPanel;
    DRBitBtn5: TDRBitBtn;
    DRLabel6: TDRLabel;
    DRMaskEdit1: TDRMaskEdit;
    DRLabel7: TDRLabel;
    DRUserDblCodeCombo1: TDRUserDblCodeCombo;
    DRPanel7: TDRPanel;
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
    DRStrGrid_SntFaxTlx: TDRStringGrid;
    DRPanel8: TDRPanel;
    DRStrGrid_SndMail_Total: TDRStringGrid;
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
    DRUserDblCodeCombo2: TDRUserDblCodeCombo;
    DRStrGrid_SndMail_NotSend: TDRStringGrid;
    DRStrGrid_SndMail_OnlyFax: TDRStringGrid;
    DRStrGrid_SndMail_OnlyEmail: TDRStringGrid;
    DRStrGrid_SndMail_WorkNo: TDRStringGrid;
    DRStrGrid_SndMail_CreateTime: TDRStringGrid;
    DRStrGrid_SndMail_AccNo: TDRStringGrid;
    DRStringGrid1: TDRStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure DRCheckBox1Click(Sender: TObject);
    procedure DRRadioButton4Click(Sender: TObject);
    procedure DRUserDblCodeCombo1CodeChange(Sender: TObject);
    procedure DRUserDblCodeCombo2CodeChange(Sender: TObject);
    procedure DRMaskEdit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure DRStringGridUnVisiable(pTag: Integer);
  public
    { Public declarations }
  end;

  TMyGrid = Class(TDRStringGrid)
  public
    procedure DeleteRow(pRow: LongInt); override;
  end;

var
  Form1: TForm1;

implementation

uses Math;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  // 사번
  begin
    DRUserDblCodeCombo1.AddItem('전체', '전체');
    DRUserDblCodeCombo1.AddItem('975001', '이재성');
    DRUserDblCodeCombo1.AddItem('975023', '조성은');
    DRUserDblCodeCombo1.AddItem('123456', '황선아');
    DRUserDblCodeCombo1.AddItem('000000', '이순애');
  end;

  // 계좌번호
  begin
    DRUserDblCodeCombo2.AddItem('전체', '전체');
    DRUserDblCodeCombo2.AddItem('99999999-98', '데이터로드_계좌_1');
    DRUserDblCodeCombo2.AddItem('12345678-01', '금융상품계좌2');
    DRUserDblCodeCombo2.AddItem('00000000-00', '경남은행_계좌_1');
    DRUserDblCodeCombo2.AddItem('99999999-99', '데이터로드_계좌_2');
    DRUserDblCodeCombo2.AddItem('AA001', '데이터로드');
    DRUserDblCodeCombo2.AddItem('BB001', '거래기관_1');
    DRUserDblCodeCombo2.AddItem('AB003', '거래기관_2');
  end;

  begin
    DRUserDblCodeCombo1.AssignCode('전체');
    DRUserDblCodeCombo2.AssignCode('전체');
  end;

  DRStringGridUnVisiable(0);

  // Edit StringGrid
  begin
    // Tag: 0(전체)
    with DRStrGrid_SndMail_Total do
    begin

    end;

    // Tag: 1(미전송)
    with DRStrGrid_SndMail_NotSend do
    begin
      for i:= 1 to 3 do
        TMyGrid(DRStrGrid_SndMail_NotSend).DeleteRow(6);

    end;

    // Tag: 2(팩스만)
    with DRStrGrid_SndMail_OnlyFax do
    begin
      for i:= 1 to 5 do
        TMyGrid(DRStrGrid_SndMail_OnlyFax).DeleteRow(5);
    end;

    // Tag: 3(이메일만)
    with DRStrGrid_SndMail_OnlyEmail do
    begin
      for i:= 1 to 4 do
        TMyGrid(DRStrGrid_SndMail_OnlyEmail).DeleteRow(1);

      TMyGrid(DRStrGrid_SndMail_OnlyEmail).DeleteRow(6);
    end;

    // Tag: 4(사번만)
    with DRStrGrid_SndMail_WorkNo do
    begin
      for i:= 1 to 7 do
        TMyGrid(DRStrGrid_SndMail_WorkNo).DeleteRow(1);
    end;

    // Tag: 5(생성시간만)
    with DRStrGrid_SndMail_CreateTime do
    begin
      for i:= 1 to 8 do
        TMyGrid(DRStrGrid_SndMail_CreateTime).DeleteRow(1);
    end;

    // Tag: 6(계좌번호만)
    with DRStrGrid_SndMail_AccNo do
    begin
      for i:= 1 to 3 do
        TMyGrid(DRStrGrid_SndMail_AccNo).DeleteRow(8);
    end;
  end;
end;

procedure TForm1.DRCheckBox1Click(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then DRStringGridUnVisiable(1)
  else DRStringGridUnVisiable(0);
end;

procedure TForm1.DRStringGridUnVisiable(pTag: Integer);
var
  i: Integer;
begin
  with DRPanel8 do
  begin
    for i:= 0 to ControlCount-1 do
    begin
      if Controls[i] is TDRStringGrid then
      begin
        TDRStringGrid(Controls[i]).Align := alClient;
        if TDRStringGrid(Controls[i]).Tag <> pTag then
          TDRStringGrid(Controls[i]).Visible := False
        else
          TDRStringGrid(Controls[i]).Visible := True;
      end;
    end;
  end;
end;

procedure TForm1.DRRadioButton4Click(Sender: TObject);
begin
  if DRRadioButton4.Checked then DRStringGridUnVisiable(0)
  else if DRRadioButton5.Checked then DRStringGridUnVisiable(2)
  else if DRRadioButton6.Checked then DRStringGridUnVisiable(3);
end;

procedure TForm1.DRUserDblCodeCombo1CodeChange(Sender: TObject);
begin
  If DRUserDblCodeCombo1.Code <> '전체' then DRStringGridUnVisiable(4)
  else DRStringGridUnVisiable(0);
end;

procedure TForm1.DRUserDblCodeCombo2CodeChange(Sender: TObject);
begin
  If DRUserDblCodeCombo2.Code <> '전체' then DRStringGridUnVisiable(6)
  else DRStringGridUnVisiable(0);
end;

{ TMyGrid }

procedure TMyGrid.DeleteRow(pRow: Integer);
begin
  inherited DeleteRow(pRow);
end;

procedure TForm1.DRMaskEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if DRMaskEdit1.EditText <> '' then DRStringGridUnVisiable(5);
  end;
end;

end.
