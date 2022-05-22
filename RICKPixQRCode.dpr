program RICKPixQRCode;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  RICK.PixQRCode.Interfaces in 'src\RICK.PixQRCode.Interfaces.pas',
  RICK.PixQRCode in 'src\RICK.PixQRCode.pas',
  RICK.PixQRCode.Types in 'src\RICK.PixQRCode.Types.pas',
  RICK.PixQRCode.Utils in 'src\RICK.PixQRCode.Utils.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
