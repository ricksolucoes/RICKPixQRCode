program RICKPixQRCodeVCL;

uses
  Vcl.Forms,
  View.Principal in 'src\View\View.Principal.pas' {PagePrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TPagePrincipal, PagePrincipal);
  Application.Run;
end.
