program rallylog;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, zcomponent, sdposeriallaz, tachartlazaruspkg, mainform, datamodule,
  clockUtility
  { you can add units after this };

{$R *.res}

begin
  Application.Title:='Rallylog Configuration Utility';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TDMMain, DMMain);
  Application.Run;
end.

