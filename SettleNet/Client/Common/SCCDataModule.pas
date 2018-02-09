//==============================================================================
//   SettleNet DataModule
//   [LMS] 2001/02/12
//==============================================================================
// DataModule_SettleNet.ADOConnection_Main

unit SCCDataModule;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ScktComp, ADODB, UCrpe32, DRPrintDrv, ImgList, DRWin32,
  UCrpeClasses;

type
  TDataModule_SettleNet = class(TDataModule)
    ADOConnection_Main: TADOConnection;
    ADOQuery_Msg: TADOQuery;
    ADOQuery_Main: TADOQuery;
    ADOQuery_RepMain: TADOQuery;
    ADOQuery_RepTemp: TADOQuery;
    Crpe1: TCrpe;
    ADOQuery_RepSub1: TADOQuery;
    ADOQuery_RepSub2: TADOQuery;
    ADOQuery_RepSub3: TADOQuery;
    DRImageList_User: TDRImageList;
    ADOCommand_Main: TADOCommand;
    ADOSP_SP0001: TADOCommand;
    ADOSP_SP0002: TADOCommand;
    ADOSP_SP0103: TADOCommand;
    ADOSP_SP0019: TADOCommand;
    ADOQuery_RepSub4: TADOQuery;
    ADOQuery_RepSub5: TADOQuery;
    ADOQuery_RepSub7: TADOQuery;
    ADOQuery_RepSub8: TADOQuery;
    ADODataSet_RepMain: TADODataSet;
    ADODataSet_RepTemp: TADODataSet;
    ADODataSet_RepSub1: TADODataSet;
    ADOConnection_Thread: TADOConnection;
    ADOQuery_Thread: TADOQuery;
    ADOQuery_RepSub9: TADOQuery;
    ADOSPEForeign_Rpt: TADOCommand;
    ADOSP_ManualChainUpdate: TADOCommand;
    ADOSP_CommBojung: TADOCommand;
    ADOSP_TaxBojung: TADOCommand;
    DRImageList_AppIcon: TDRImageList;
    ADOQuery_Thread2: TADOQuery;
    ADOSPEForeignIPO_Rpt: TADOCommand;
    ADOQuery_RepSubA: TADOQuery;
    ADOSP_SP8201_1: TADOCommand;
    ADOSP_SP8201_2: TADOCommand;
    ADOSP_SP8201_3: TADOCommand;
    ADOSP_SP0100_1: TADOCommand;
    ADOSP_SP0100_2: TADOCommand;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule_SettleNet: TDataModule_SettleNet;

implementation

{$R *.DFM}

uses
   SCCGlobalType;

{ TDR_DataModule }
end.
