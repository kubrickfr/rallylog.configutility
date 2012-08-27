unit ftd2xxdevice;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

 // forward declarations
 TPort = class;
 TDeviceDescriptor = class;
 TEEprom = class;

 // Exceptions
 EFTD2xxException = Class(Exception);

 TDevice = Class(TComponent)
 private
      fPort: TPort;
      fEEprom: TEEprom;
      fHandle: Longint;

      fReadTimeout: Longint;
      fWriteTimeout: Longint;

      fLocationID: Longint;                 // devices location in the USB Tree
      //fDeviceType: DeviceType;

      const
        // default timeout values as specified by the ftd2xx API
       fDEFAULT_TX_TIMEOUT = 300;
       fDEFAULT_RX_TIMEOUT = 300;

       function getDeviceDescriptor: TDeviceDescriptor;

 public

      constructor Create(aOwner: TComponent); override;
      Destructor Destroy(); override;

      procedure open;
      procedure close;


      class property DEFAULT_TX_TIMEOUT: Longint default fDEFAULT_TX_TIMEOUT;
      class property DEFAULT_RX_TIMEOUT: Longint default fDEFAULT_RX_TIMEOUT;


 published
      property port: TPort read fPort write fPort;
      property readTimeout: Integer read fReadTimeout write fReadTimeout default fDEFAULT_RX_TIMEOUT;
      property writeTimeout: Integer read fWriteTimeout write fWriteTimeout default fDEFAULT_TX_TIMEOUT;
      property deviceDescriptor: TDeviceDescriptor read getDeviceDescriptor;
 end;

 TPort = Class(TComponent)
   private

   public
     constructor Create(aOwner: TDevice);
     Destructor Destroy(); override;

     procedure reset;

   published
 end;

 TDeviceDescriptor = Class(TComponent)

  private

  public
     constructor Create(aOwner: TDevice);
     Destructor Destroy(); override;

     published

  end;


 TEEprom = class (TComponent)
   private
     fDeviceDescriptor: TDeviceDescriptor;
   public
     constructor Create(aOwner: TDevice);
     Destructor Destroy(); override;
     function getDeviceDescriptor: TDeviceDescriptor;
 end;



implementation


///////////////////////////////////////////////
//   TDevice Class Implementation
//
{$Region 'TDevice'}
Constructor TDevice.Create(aOwner: TComponent);
begin
     inherited create(aOwner);
     fPort := TPort.create(self);
     fEEprom := TEEprom.create(self);
end;

Destructor TDevice.Destroy();
begin

     inherited Destroy;
end;

procedure TDevice.open;
begin

end;

procedure TDevice.close;
begin

end;


function TDevice.getDeviceDescriptor: TDeviceDescriptor;
begin
     result := fEEprom.getDeviceDescriptor();
end;

{$EndRegion}


///////////////////////////////////////////////
//   TPort Class Implementation
//
{$Region 'TPort'}
Constructor TPort.Create(aOwner: TDevice);
begin
     inherited create(aOwner);

end;

Destructor TPort.Destroy();
begin

     inherited Destroy;
end;

procedure TPort.reset;
begin
end;

{$EndRegion}

///////////////////////////////////////////////
//   TDeviceDescriptor Class Implementation
//
{$REGION 'TDeviceDescriptor'}
 Constructor TDeviceDescriptor.Create(aOwner: TDevice);
begin
     inherited create(aOwner);

end;

Destructor TdeviceDescriptor.Destroy();
begin

     inherited Destroy;
end;

{$EndRegion}

///////////////////////////////////////////////
//   TEEprom Class Implementation
//

{$Region 'TEEprom'}
 Constructor TEEprom.Create(aOwner: TDevice);
begin
     inherited create(aOwner);

end;

 Destructor TEEprom.Destroy();
begin

     inherited Destroy;
end;

 function TEEprom.getDeviceDescriptor: TDeviceDescriptor ;
begin
   result := nil;
end;

 {$EndRegion}

end.

