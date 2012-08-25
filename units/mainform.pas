unit mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls, DBGrids, EditBtn, Menus, Buttons,
  SharedLogger, filechannel, SdpoSerial, FTChipID, ConnectedDevice;

type



  { TfrmMain }

  TfrmMain = class(TForm)
    Chart1: TChart;
    EditButton1: TEditButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblSerialNumber: TLabel;
    lblBatteryStatus: TLabel;
    lblSystemTime: TLabel;
    lblDeviceTime: TLabel;
    Label8: TLabel;
    MainMenu: TMainMenu;
    menuFile: TMenuItem;
    MenuItem1: TMenuItem;
    menuLoggingEnabled: TMenuItem;
    menuSettings: TMenuItem;
    menuFileExit: TMenuItem;
    menuHelp: TMenuItem;
    menuHelpAbout: TMenuItem;
    menuAutoSetTime: TMenuItem;
    Panel3: TPanel;
    serialPort: TSdpoSerial;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    ToolBar1: TToolBar;
    btnFindDevices: TToolButton;
    toolButtonExit: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;

    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure menuLoggingEnabledClick(Sender: TObject);
    procedure btnFindDevicesClick(Sender: TObject);

    procedure DeviceConnected(Sender: TObject);
    procedure DeviceDisconnected(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

    procedure toolButtonExitClick(Sender: TObject);
  private
    { private declarations }
     ConnectedDevice: TConnectedDevice;
  public
    { public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.toolButtonExitClick(Sender: TObject);
begin
    Close;
end;

procedure TfrmMain.menuLoggingEnabledClick(Sender: TObject);
begin
    if (menuLoggingEnabled.Checked) then
      Logger.Enabled := True
    else
      Logger.Enabled := False;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
   Logger.Channels.Add(TFileChannel.Create('logfile.log'));
   if (menuLoggingEnabled.Checked) then
      Logger.Enabled := True
   else
      Logger.Enabled := False;

   ConnectedDevice := TConnectedDevice.Create(self);
   ConnectedDevice.onDeviceConnected:= @DeviceConnected;
   ConnectedDevice.onDeviceDisconnected:= @DeviceDisconnected;

end;

procedure TfrmMain.FormShow(Sender: TObject);
begin

end;

procedure TfrmMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin

end;

procedure TfrmMain.btnFindDevicesClick(Sender: TObject);
var
     vSerialNumber: String;
begin

     if (ConnectedDevice.isConnected) then
        begin
          vSerialNumber := ConnectedDevice.GetSerialNumber;
          Logger.Send('[FindDevices] Device Connected - Serial #: %s', [vSerialNumber]);
          StatusBar1.Panels.Items[1].Text:='Serial #: ' + vSerialNumber;
        end;
end;


procedure TfrmMain.DeviceConnected(Sender: TObject);
var
  vSerialNumber: String;
begin
      vSerialNumber := ConnectedDevice.GetSerialNumber;
      Logger.Send('[DeviceConnected] Serial #: %s', [vSerialNumber]);
      StatusBar1.Panels.Items[3].Text:='Connected';
      btnFindDevices.Enabled:=false;
      StatusBar1.Panels.Items[1].Text:='Serial #: ' + vSerialNumber;
      lblSerialNumber.Caption:= vSerialNumber;
end;

procedure TfrmMain.DeviceDisconnected(Sender: TObject);
var
  vSerialNumber: String;
begin
       vSerialNumber := ConnectedDevice.GetSerialNumber;
       Logger.Send('[DeviceDisconnected]');
       StatusBar1.Panels.Items[3].Text:='Searching...';
       btnFindDevices.Enabled:=true;
       StatusBar1.Panels.Items[1].Text:='Serial #: ' + vSerialNumber;
       lblSerialNumber.Caption:= vSerialNumber;
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
     lblSystemTime.Caption:=TimeToStr(time);
end;


end.

