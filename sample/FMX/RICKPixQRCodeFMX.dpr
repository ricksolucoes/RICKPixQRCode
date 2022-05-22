program RICKPixQRCodeFMX;

uses
  System.StartUpCopy,
  FMX.Forms,
  View.Principal in 'src\View\View.Principal.pas' {PagePrincipal};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown:= True;
  Application.Initialize;
  Application.CreateForm(TPagePrincipal, PagePrincipal);
  Application.Run;
end.

