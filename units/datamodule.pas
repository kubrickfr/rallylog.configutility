unit datamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, process, FileUtil, ZConnection, ZDataset;

type

  { TDMMain }

  TDMMain = class(TDataModule)
    Datasource1: TDatasource;
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    ZTable1: TZTable;
    procedure ZConnection1AfterConnect(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  DMMain: TDMMain;

implementation

{$R *.lfm}

{ TDMMain }

procedure TDMMain.ZConnection1AfterConnect(Sender: TObject);
begin

end;

end.

