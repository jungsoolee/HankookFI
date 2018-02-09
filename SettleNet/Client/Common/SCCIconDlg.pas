//==============================================================================
//   [LMS] 2001/02/12
//==============================================================================

unit SCCIconDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, DRAdditional, StdCtrls;

const
   MAX_ICON_CNT = 100;

type
  TDlgForm_Icon = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DRSpeedBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
     IconArr: Array [0..MAX_ICON_CNT-1] of TDRSpeedButton;
  end;

var
  DlgForm_Icon: TDlgForm_Icon;

implementation

{$R *.DFM}

uses
   SCCDataModule;

const
   MAX_COL_CNT  = 10;
   ICON_MARGIN  = 3;
   ICON_HEIGHT  = 22;
   ICON_WIDTH   = 22;


procedure TDlgForm_Icon.FormCreate(Sender: TObject);
var
   iLeft, iTop, iRowCnt: Integer;
   I : Integer;
begin
   iTop    := 0;
   iLeft   := 0;
   iRowCnt := 0;
   // Create Icon Button
   for I := 0 to MAX_ICON_CNT-1 do
   begin
      if (I mod MAX_COL_CNT) = 0 then  // Ã¹¹øÂ° Column
      begin
         Inc(iRowCnt);
         iTop  := ICON_MARGIN + ((iRowCnt-1) * ICON_HEIGHT);
         iLeft := ICON_MARGIN;  // clear
      end
      else
         iLeft := iLeft + ICON_MARGIN + ICON_WIDTH;

      IconArr[I] := TDRSpeedButton.Create(Self);
      IconArr[I].Parent     := Self;
      IconArr[I].Top        := iTop;
      IconArr[I].Left       := iLeft;
      IconArr[I].Height     := ICON_HEIGHT;
      IconArr[I].Width      := ICON_WIDTH;
      IconArr[I].Tag        := I;
      IconArr[I].AllowAllUp := True;
      IconArr[I].Flat       := True;
      IconArr[I].GroupIndex := 1;
      IconArr[I].OnClick    := DRSpeedBtnClick;
      IconArr[I].Visible    := False;
      if I <= DataModule_SettleNet.DRImageList_User.Count-1 then
      begin
         DataModule_SettleNet.DRImageList_User.GetBitmap(I, IconArr[I].Glyph); ;
         IconArr[I].Visible := True;
      end;
   end;  // end of for
   ClientWidth  := MAX_COL_CNT * (ICON_WIDTH + ICON_MARGIN);
   ClientHeight := iRowCnt * (ICON_HEIGHT + ICON_MARGIN);
end;

procedure TDlgForm_Icon.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caHide;
end;

procedure TDlgForm_Icon.DRSpeedBtnClick(Sender: TObject);
begin
   Close;
end;

end.
