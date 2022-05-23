program RICKPixQRCodeD7;

uses
  ExceptionLog,
  Forms,
  View.Principal in 'View\View.Principal.pas' {PagePrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TPagePrincipal, PagePrincipal);
  Application.Run;
end.
