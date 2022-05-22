unit RICK.PixQRCode.Types;

interface
type
{$SCOPEDENUMS ON}
  TTipoChave = (Null, Telefone, CPF, CNPJ, EMail, Aleatoria);
{$SCOPEDENUMS OFF}

  TTipoChaveHelper  = record helper for TTipoChave
    function ToString: string;
  end;
implementation

uses
  System.SysUtils;

{ TTipoChaveHelper }

function TTipoChaveHelper.ToString: string;
begin
  case Self of
    TTipoChave.Null     : Result:= EmptyStr;
    TTipoChave.Telefone : Result:= 'Telefone';
    TTipoChave.CPF      : Result:= 'CPF';
    TTipoChave.CNPJ     : Result:= 'CNPJ';
    TTipoChave.EMail    : Result:= 'E-Mail';
    TTipoChave.Aleatoria: Result:= 'Aleatorio';
  end;
end;

end.
