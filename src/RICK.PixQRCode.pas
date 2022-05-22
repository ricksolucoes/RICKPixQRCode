unit RICK.PixQRCode;

interface

uses
  System.Classes,
  System.SysUtils,

  RICK.PixQRCode.Utils,
  RICK.PixQRCode.Types,
  RICK.PixQRCode.Interfaces,

  IdHTTP,
  IdTCPClient,
  IdComponent,
  IdBaseComponent,
  IdTCPConnection;

type
  TTipoChave = RICK.PixQRCode.Types.TTipoChave;

  TRICKPixQRCode = class(TInterfacedObject, iPixQRCode, iPixQRCodeTipoChave,
                          iPixQRCodeDados, iAPIGeraQRCodePIX)
  private
    FIDHTTP                                     : TIdHTTP;
    FTipoChavePix                               : TTipoChave;
    FMemoryStream                               : TMemoryStream;
    FNome                                       : string;
    FCidade                                     : string;
    FValor                                      : string;
    FChavePix                                   : string;
    FChavePixCopiaCola                          : string;
    FRetornoPix                                 : string;
    FPathDLL                                    : string;

    procedure GetAPIGerarQRCode(AQueryParam:string);

  protected
    function PathDLL(AValue: string)            : iPixQRCodeDados;
    function TipoChave                          : iPixQRCodeTipoChave;
    function Dados                              : iPixQRCodeDados;
    function APIGeraQRCodePIX                   : iAPIGeraQRCodePIX;


    //Tipos de Chaves Pix
    function Telefone                           : iPixQRCodeTipoChave;
    function CPF                                : iPixQRCodeTipoChave;
    function CNPJ                               : iPixQRCodeTipoChave;
    function EMail                              : iPixQRCodeTipoChave;
    function Aleatoria                          : iPixQRCodeTipoChave;

    //Dados do Pix
    function Nome(AValue: string)               : iPixQRCodeDados;
    function Cidade(AValue: string)             : iPixQRCodeDados;
    function Valor(AValue: Extended80)          : iPixQRCodeDados; overload;
    function Valor(AValue: Double)              : iPixQRCodeDados; overload;
    function Valor(AValue: string)              : iPixQRCodeDados; overload;
    function ChavePix(AValue: string)           : iPixQRCodeDados;
    function ChavePixCopiaCola(AValue: string)  : iPixQRCodeDados;
    function RetornoPix(AValue: string)         : iPixQRCodeDados;

    //API Gerar Code PIX - https://gerarqrcodepix.com.br/ - https://github.com/ceciliadeveza/gerarqrcodepix
    function Estatico                           : iAPIGeraQRCodePIX;
    function Dinamico                           : iAPIGeraQRCodePIX;
    function BrCode                             : iAPIGeraQRCodePIX;

    function &End                               : iPixQRCode;

    constructor Create;
  public
    destructor Destroy; override;
    class function New: iPixQRCode;
  end;
implementation

Const
  _URL = 'https://gerarqrcodepix.com.br/api/v1?';

function TRICKPixQRCode.EMail: iPixQRCodeTipoChave;
begin
  Result:= Self;
  FTipoChavePix:= TTipoChave.EMail;
end;

function TRICKPixQRCode.&End: iPixQRCode;
begin
  Result:= Self;
end;

function TRICKPixQRCode.Estatico: iAPIGeraQRCodePIX;
var
  LQueryParam : string;
begin
  Result:= Self;

  if FNome.Trim.IsEmpty then
    raise Exception.Create('Informe o nome do recebedor do Pix');

  if FCidade.Trim.IsEmpty then
    raise Exception.Create('Informe a cidade do recebedor do PIX');

  if FChavePix.Trim.IsEmpty then
    raise Exception.Create('Informe a Chave Pix cadastrada em qualquer PSP');

  LQueryParam:= Format('saida=qr&nome=%s&cidade=%s&chave=%s',
                      [FNome, FCidade, FChavePix]);

  if not FValor.Trim.IsEmpty then
    LQueryParam:= Format('%s&valor=%s', [LQueryParam, FValor]);


  GetAPIGerarQRCode(LQueryParam);



end;

procedure TRICKPixQRCode.GetAPIGerarQRCode(AQueryParam:string);
begin
  FIDHTTP.Request.Accept := 'image/png';

  FIDHTTP.Get(Format('%s%s', [_URL, AQueryParam]), FMemoryStream);
end;

function TRICKPixQRCode.Aleatoria: iPixQRCodeTipoChave;
begin
  Result:= Self;
  FTipoChavePix:= TTipoChave.Aleatoria;
end;

function TRICKPixQRCode.APIGeraQRCodePIX: iAPIGeraQRCodePIX;
begin
  Result:= Self;
end;

function TRICKPixQRCode.BrCode: iAPIGeraQRCodePIX;
var
  LQueryParam: string;
begin
  Result:= Self;

  if FChavePixCopiaCola.Trim.IsEmpty then
    raise Exception.Create('Informe a Chave Copia e Cola cadastrada em qualquer PSP');

  LQueryParam:= Format('brcode=%s', [FChavePixCopiaCola]);

  GetAPIGerarQRCode(LQueryParam);
end;

function TRICKPixQRCode.ChavePix(AValue: string): iPixQRCodeDados;
var
  LChave : string;
begin
  Result:= Self;
  LChave:= AValue.Trim;

  case FTipoChavePix of
    TTipoChave.Telefone   :
    begin
      if not LChave.Contains('+55') then
        LChave:= Format('+55', [LChave]);

      LChave:= Format('+%s', [TRICKPixQrCodeUtils.GetSomenteNumero(LChave)]);

      if (not (LChave.Length = 14) or (LChave.Length = 13)) then
        raise Exception.Create('O telefone informado é inválido');

    end;
    TTipoChave.CPF        :
    begin
      LChave:= TRICKPixQrCodeUtils.GetSomenteNumero(LChave);

      if not TRICKPixQrCodeUtils.IsValidCPF(LChave) then
        raise Exception.Create('O CPF informado é inválido');
    end;
    TTipoChave.CNPJ       :
    begin
      LChave:= TRICKPixQrCodeUtils.GetSomenteNumero(LChave);

      if not TRICKPixQrCodeUtils.IsValidCNPJ(LChave) then
        raise Exception.Create('O CNPJ informado é inválido');
    end;
    TTipoChave.EMail      :
    begin
      if not TRICKPixQrCodeUtils.IsValidEmail(LChave) then
        raise Exception.Create('O E-Mail informado é inválido');
    end;
    TTipoChave.Aleatoria  : ;
  else
    raise Exception.Create('Informe o tipo da chave');
  end;

  FChavePix:= LChave;
end;

function TRICKPixQRCode.ChavePixCopiaCola(AValue: string): iPixQRCodeDados;
begin
  Result:= Self;
  FChavePixCopiaCola:= AValue;
end;

function TRICKPixQRCode.Cidade(AValue: string): iPixQRCodeDados;
begin
  Result:= Self;
  FCidade:= AValue;
end;

function TRICKPixQRCode.CNPJ: iPixQRCodeTipoChave;
begin
  Result:= Self;
  FTipoChavePix:= TTipoChave.CNPJ;
end;

function TRICKPixQRCode.CPF: iPixQRCodeTipoChave;
begin
  Result:= Self;
  FTipoChavePix:= TTipoChave.CPF;
end;

constructor TRICKPixQRCode.Create;
begin
  FPathDLL:= GetCurrentDir;

  if not Assigned(FIDHTTP) then
    FIDHTTP := TIdHTTP.Create;

  if not Assigned(FMemoryStream) then
    FMemoryStream := TMemoryStream.Create;

end;

function TRICKPixQRCode.Dados: iPixQRCodeDados;
begin
  Result:= Self;
end;

destructor TRICKPixQRCode.Destroy;
begin
  if Assigned(FIDHTTP) then
    FIDHTTP.Free;

  if Assigned(FMemoryStream) then
    FMemoryStream.Free;

  inherited;
end;

function TRICKPixQRCode.Dinamico: iAPIGeraQRCodePIX;
var
  LQueryParam: string;
begin
  Result:= Self;

  if FNome.Trim.IsEmpty then
    raise Exception.Create('Informe o nome do recebedor do Pix');

  if FCidade.Trim.IsEmpty then
    raise Exception.Create('Informe a cidade do recebedor do PIX');

  if FRetornoPix.Trim.IsEmpty then
    raise Exception.Create('Informe a URL do payload retornada por uma API Pix.');

  LQueryParam:= Format('saida=qr&nome=%s&cidade=%s&location=%s',
                      [FNome, FCidade, FRetornoPix]);

  GetAPIGerarQRCode(LQueryParam);
end;

class function TRICKPixQRCode.New: iPixQRCode;
begin
  Result:= Self.Create;
end;

function TRICKPixQRCode.Nome(AValue: string): iPixQRCodeDados;
begin
  Result:= Self;
  FNome:= AValue;
end;

function TRICKPixQRCode.PathDLL(AValue: string): iPixQRCodeDados;
begin
  Result:= Self;
  FPathDLL:= AValue;
end;

function TRICKPixQRCode.RetornoPix(AValue: string): iPixQRCodeDados;
begin
  Result:= Self;
  FRetornoPix:= AValue;
end;

function TRICKPixQRCode.Telefone: iPixQRCodeTipoChave;
begin
  Result:= Self;
  FTipoChavePix:= TTipoChave.Telefone;
end;

function TRICKPixQRCode.TipoChave: iPixQRCodeTipoChave;
begin
  Result:= Self;
end;

function TRICKPixQRCode.Valor(AValue: string): iPixQRCodeDados;
var
  LValor : Extended80;
begin
  Result:= Self;

  LValor:= StrToFloatDef(StringReplace(AValue,
                                        '.', '',
                                        [rfReplaceAll, rfIgnoreCase]),
                          0);

  FValor:= FloatToStr(LValor);

  FValor:= StringReplace(FValor,',', '.',[rfReplaceAll, rfIgnoreCase]);
end;

function TRICKPixQRCode.Valor(AValue: Double): iPixQRCodeDados;
begin
  Result:= Self;
  Valor(AValue.ToString);
end;

function TRICKPixQRCode.Valor(AValue: Extended80): iPixQRCodeDados;
begin
  Result:= Self;
  Valor(FloatToStr(AValue));
end;

end.
