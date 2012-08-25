unit ConnectedDevice;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SdpoSerial,ComCtrls,ExtCtrls,D2XXUnit, contnrs,
  SharedLogger, filechannel;



type
    TDeviceState = (STATE_SEARCHING, STATE_CONNECTED);
    TReceiveState = (STATE_START, STATE_CMD, STATE_ADDR, STATE_DATA, STATE_PROCESSING);
    TCommandByte = (A, C, R);

    const MAX_NUM_SERIAL_NUMBER_CHARS = 50;

type TSerialNumber = array [0..(MAX_NUM_SERIAL_NUMBER_CHARS - 1)] of Char;
type PSerialNumber = ^TSerialNumber;

    TConnectedDevice = Class(TComponent)
      private
         fOnDeviceConnect: TNotifyEvent;
         fOnDeviceDisconnect: TNotifyEvent;
         connectTimer : TTimer;
         protocolTimer: TTimer;
         fDeviceState : TDeviceState;
         FSdpoSerial  : TSdpoSerial;
         rxQueue: TQueue;
         rxData, txData: String;         //constructed rx/tx Packet
         rxState: TReceiveState;
         stationAddress: String;
         rxCount: Integer;
         procedure SetSdpoSerial(const value : TSdpoSerial);
         procedure  onDeviceTimer(Sender: TObject);
      protected
         Function GetDeviceCount: DWord;
      public
        constructor Create(AOwner: TComponent); override;
        Destructor Destroy; override;
        procedure OpenPort;
        procedure ClosePort;

        //FTDI DLL Functions
        Function isConnected: Boolean;
        Function getSerialNumber : String;

      published
        property Serial : TSdpoSerial read FSdpoSerial write SetSdpoSerial;
        property onDeviceConnected: TNotifyEvent read fOnDeviceConnect write fOnDeviceConnect;
        property onDeviceDisconnected: TNotifyEvent read fOnDeviceDisconnect write fOnDeviceDisconnect;
    end;

  implementation

    Constructor TConnectedDevice.Create(AOwner: TComponent);
    begin
      inherited Create(aOwner);
      //Logger.Send('[TConnectedDevice] created');
      fDeviceState := STATE_SEARCHING;          // initial device state

      connectTimer := TTimer.Create(self);      // device connection timer
      connectTimer.OnTimer:= @onDeviceTimer;
      connectTimer.Interval:=1000;              // 1 second
      connectTimer.Enabled:=true;               // start the timer

    end;

    Destructor TConnectedDevice.Destroy;
    begin

      connectTimer.Free;
      inherited Destroy;
    end;

    procedure TConnectedDevice.OpenPort;
    begin
      FSdpoSerial.Open;
    end;

    procedure TConnectedDevice.ClosePort;
    begin
      FSdpoSerial.Close;
    end;

    procedure  TConnectedDevice.SetSdpoSerial(const value : TSdpoSerial);
    begin
         if Assigned(value) then
          FSdpoSerial := value;
    end;

    function TConnectedDevice.GetDeviceCount: DWord;
    begin
         if (GetFTDeviceCount = FT_OK) THEN
            result := FT_Device_Count
         ELSE
             result := 0;
    end;

    function TConnectedDevice.GetSerialNumber: String;
    begin
      if(isConnected) THEN
         begin
          if (GetFTDeviceSerialNo(0) = FT_OK) THEN
             begin
              if Length(SerialNumber)>0 then
                 SetString(Result, PChar(@SerialNumber[0]), Length(SerialNumber))
              else
                 Result := '';
             end;
         end
      else
          result := '';
    end;

    function TConnectedDevice.isConnected: Boolean;
    begin
      if(GetDeviceCount <> 0 ) then
         result := true
      else
         result := false;
    end;

    procedure TConnectedDevice.onDeviceTimer(Sender: TObject);
    begin
      //Logger.send('[TConnectedDevice.onDeviceTimer]');
      case fDeviceState of
           STATE_SEARCHING:
             begin
              if (isConnected) then
                 begin
                      fDeviceState := STATE_CONNECTED;
                      if assigned(fOnDeviceConnect) then
                         fOnDeviceConnect(self);     // Send Notification Event
                 end
             end;

           STATE_CONNECTED:
             begin
             if (not(isConnected)) then
                begin
                     fDeviceState := STATE_SEARCHING;
                     if assigned(fOnDeviceDisconnect) then
                        fOnDeviceDisconnect(self);   // Send Notification Event
                end
             end;
      end;

    end;

end.

