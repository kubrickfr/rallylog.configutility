program rallylog;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, sdposeriallaz, tachartlazaruspkg, pl_zeosdbocomp, pl_luicontrols,
  pl_visualplanitcomp, pl_excontrols, mainform, datamodule, clockUtility,
  ftd2xxdevice;

{$R *.res}

begin
  Application.Title:='Rallylog Configuration Utility';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmMain, dmMain);
  Application.Run;
end.

