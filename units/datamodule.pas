unit datamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, process, FileUtil, ZConnection, ZDataset;

type

  { TdmMain }

  TdmMain = class(TDataModule)
    procedure ZConnection1AfterConnect(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  dmMain: TdmMain;

implementation

{$R *.lfm}

{ TdmMain }

procedure TdmMain.ZConnection1AfterConnect(Sender: TObject);
begin

end;

end.

