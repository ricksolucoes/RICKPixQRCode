unit RICK.PixQRCode.Types;

interface
type
  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
{$SCOPEDENUMS ON}
  TTipoChave = (Null, Telefone, CPF, CNPJ, EMail, Aleatoria);
  TQRCodeEncoding = (qrAuto, qrNumeric, qrAlphanumeric, qrISO88591, qrUTF8NoBOM, qrUTF8BOM);
{$SCOPEDENUMS OFF}
  T2DBooleanArray = array of array of Boolean;

  {$ELSE} // VCL prior to XE2
  TTipoChave = (tpNull, tpTelefone, tpCPF, tpCNPJ, tpEMail, tpAleatoria);
  {$IFEND}

{$IF CompilerVersion >= 23.0}
  TTipoChaveHelper  = record helper for TTipoChave
    function ToString: string;
  end;
{$IFEND}
implementation

uses
  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  System.SysUtils;
  {$ELSE} // VCL prior to XE2
  SysUtils;
  {$IFEND}

{ TTipoChaveHelper }
{$IF CompilerVersion >= 23.0}
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
{$IFEND}
end.
