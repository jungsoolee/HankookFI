inherited Form_SCF_AC: TForm_SCF_AC
  Left = 369
  Top = 191
  Caption = 'Form_SCF_AC'
  ClientWidth = 706
  KeyPreview = True
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  inherited DRPanel_Top: TDRPanel
    Width = 706
    DesignSize = (
      706
      27)
    inherited DRBitBtn1: TDRBitBtn
      Left = 639
    end
    inherited DRBitBtn2: TDRBitBtn
      Left = 573
    end
    inherited DRBitBtn3: TDRBitBtn
      Left = 507
    end
    inherited DRBitBtn4: TDRBitBtn
      Left = 441
    end
  end
  inherited ProcessMsgBar: TDRPanel
    Left = 208
    Top = 204
  end
  inherited MessageBar: TDRMessageBar
    Width = 706
  end
  object DRSaveDialog_GridExport: TDRSaveDialog
    DefaultExt = '*.xls'
    Filter = 'MS EXCEL(*.xls)|*.xls'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Grid Export'
    Left = 288
  end
end
