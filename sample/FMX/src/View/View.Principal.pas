unit View.Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,

  RICK.PixQRCode,
  RICK.PixQRCode.Interfaces,

  IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, FMX.Controls.Presentation, FMX.StdCtrls

  ;

type
  TPagePrincipal = class(TForm)
    IdHTTP1: TIdHTTP;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
  private
    FPixQRCode : iPixQRCode;
  end;

var
  PagePrincipal: TPagePrincipal;

implementation

{$R *.fmx}

procedure TPagePrincipal.FormCreate(Sender: TObject);
begin
  FPixQRCode:= TRICKPixQRCode.New.Dados.Valor('1.0001,00523').ChavePix('camelo').&End;

end;

end.
