unit FTChipID;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, dynlibs;

type FTID_STATUS = Integer;

const MAX_NUM_SERIAL_NUMBER_CHARS = 50;

type TSerialNumber = array [0..(MAX_NUM_SERIAL_NUMBER_CHARS - 1)] of Char;
type PSerialNumber = ^TSerialNumber;

const MAX_NUM_DESCRIPTION_CHARS = 256;

type TDescription = array [0..(MAX_NUM_DESCRIPTION_CHARS - 1)] of Char;
type PDescription = ^TDescription;

const MAX_NUM_DLL_VERSION_CHARS = 10;

type TDllVersion = array [0..(MAX_NUM_DLL_VERSION_CHARS - 1)] of Char;
type PDllVersion = ^TDllVersion;

const MAX_NUM_ERROR_MESSAGE_CHARS = 100;

type TErrorMessage = array [0..(MAX_NUM_ERROR_MESSAGE_CHARS - 1)] of Char;
type PErrorMessage = ^TErrorMessage;

type CFTChipID = class(TObject)
 private
  hLib: TlibHandle;
 public
  constructor create;
  destructor destroy; override;
  function  GetNumDevices(pNumDevices: PLongword): FTID_STATUS;
  function  GetDeviceSerialNumber(SerialNumberIndex: Longword; pSerialNumberBuffer: PSerialNumber): FTID_STATUS;
  function  GetDeviceDescription(DescriptionIndex: Longword; pDescriptionBuffer: PDescription): FTID_STATUS;
  function  GetDeviceLocationID(LocationIDIndex: Longword; pLocationIDBuffer: PLongword): FTID_STATUS;
  function  GetDeviceChipID(ChipIDIndex: Longword; pChipIDBuffer: PLongword): FTID_STATUS;
  function  GetDllVersion(DllVersionBuffer: pDllVersion): FTID_STATUS;
  function  GetErrorCodeString(Language: String; StatusCode: FTID_STATUS; pErrorMessageBuffer: PErrorMessage): FTID_STATUS;
end;

const
// FT_Status Values
  FTID_SUCCESS = 0;
  FTID_INVALID_HANDLE = 1;         // FT_INVALID_HANDLE
  FTID_DEVICE_NOT_FOUND	= 2;       // FT_DEVICE_NOT_FOUND
  FTID_DEVICE_NOT_OPENED = 3;      // FT_DEVICE_NOT_OPENED
  FTID_IO_ERROR =	4;         // FT_IO_ERROR
  FTID_INSUFFICIENT_RESOURCES =	5; // FT_INSUFFICIENT_RESOURCES
  FTID_INVALID_PARAMETER = 6;      // FT_INVALID_PARAMETER

  FTID_BUFFER_SIZE_TOO_SMALL = 20;
  FTID_PASSED_NULL_POINTER = 21;
  FTID_INVALID_LANGUAGE_CODE = 22;
  FTID_INVALID_STATUS_CODE = $FFFFFFFF;

  FT_ChipID_DLL_Name = 'FTChipID.dll';

implementation

function FTID_GetNumDevices(Devices: PLongword) : FTID_STATUS; stdcall; External FT_ChipID_DLL_Name name 'FTID_GetNumDevices';
function FTID_GetDeviceSerialNumber(DeviceIndex: Longword ; SerialBuffer: Pointer ; SerialBufferLength: Longword) : FTID_STATUS; stdcall; External FT_ChipID_DLL_Name name 'FTID_GetDeviceSerialNumber';
function FTID_GetDeviceDescription(DeviceIndex: Longword ; DescriptionBuffer: Pointer ; DescriptionBufferLength: Longword) : FTID_STATUS; stdcall; External FT_ChipID_DLL_Name name 'FTID_GetDeviceDescription';
function FTID_GetDeviceLocationID(DeviceIndex: Longword ; LocationIDBuffer: Pointer) : FTID_STATUS; stdcall; External FT_ChipID_DLL_Name name 'FTID_GetDeviceLocationID';
function FTID_GetDeviceChipID(DeviceIndex: Longword ; ChipIDBuffer: Pointer) : FTID_STATUS; stdcall; External FT_ChipID_DLL_Name name 'FTID_GetDeviceChipID';
function FTID_GetDllVersion(DllVersionBuffer: pDllVersion; BufferSize: Longword) : FTID_STATUS; stdcall; External FT_ChipID_DLL_Name name 'FTID_GetDllVersion';
function FTID_GetErrorCodeString(Language: PChar; StatusCode: FTID_STATUS; ErrorMessageBuffer: PErrorMessage; BufferSize: Longword) : FTID_STATUS; stdcall; External FT_ChipID_DLL_Name name 'FTID_GetErrorCodeString';

constructor CFTChipID.create;
begin
  inherited create;
  if fileexists(FT_ChipID_DLL_Name) then  { just a sanity check, could extend this }
    hLib:= LoadLibrary(FT_ChipID_DLL_Name);
end;

destructor CFTChipID.destroy;
begin
  if hLib <> 0 then UnloadLibrary(hLib); { release DLL library }
  hLib:= 0; { again sanity }
end;

function  CFTChipID.GetNumDevices(pNumDevices: PLongword): FTID_STATUS;
begin
  if hLib <> 0 then
     Result := FTID_GetNumDevices(pNumDevices);
end;

function  CFTChipID.GetDeviceSerialNumber(SerialNumberIndex: Longword ; pSerialNumberBuffer: PSerialNumber): FTID_STATUS;
begin
  if hLib <> 0 then
     Result := FTID_GetDeviceSerialNumber(SerialNumberIndex, pSerialNumberBuffer, MAX_NUM_SERIAL_NUMBER_CHARS);

end;

function  CFTChipID.GetDeviceDescription(DescriptionIndex: Longword ; pDescriptionBuffer: PDescription): FTID_STATUS;
begin
  if hLib <> 0 then
     Result := FTID_GetDeviceDescription(DescriptionIndex, pDescriptionBuffer, MAX_NUM_DESCRIPTION_CHARS);
end;

function  CFTChipID.GetDeviceLocationID(LocationIDIndex: Longword ; pLocationIDBuffer: PLongword): FTID_STATUS;
begin
  if hLib <> 0 then
     Result := FTID_GetDeviceLocationID(LocationIDIndex, pLocationIDBuffer);
end;

function  CFTChipID.GetDeviceChipID(ChipIDIndex: Longword ; pChipIDBuffer: PLongword): FTID_STATUS;
begin
  if hLib <> 0 then
     Result := FTID_GetDeviceChipID(ChipIDIndex, pChipIDBuffer);
end;

function  CFTChipID.GetDllVersion(DllVersionBuffer: pDllVersion): FTID_STATUS;
begin
  if hLib <> 0 then
     Result := FTID_GetDllVersion(DllVersionBuffer, MAX_NUM_DLL_VERSION_CHARS);
end;

function  CFTChipID.GetErrorCodeString(Language: String ; StatusCode: FTID_STATUS;
                                      pErrorMessageBuffer: PErrorMessage): FTID_STATUS;
begin
  if hLib <> 0 then
     Result := FTID_GetErrorCodeString(PChar(Language), StatusCode, pErrorMessageBuffer, MAX_NUM_ERROR_MESSAGE_CHARS);
end;

end.
