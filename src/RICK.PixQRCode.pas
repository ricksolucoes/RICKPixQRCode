unit RICK.PixQRCode;

interface

uses
  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
    Vcl.Graphics,
    Vcl.Imaging.jpeg,
    Vcl.Imaging.pngimage,
    System.Classes,
    System.SysUtils,
    RICK.QRCode,
  {$ELSE} // VCL prior to XE2
    Graphics,
    pngimage,
    JPEG ,
    Classes,
    SysUtils,
    ACBrDFeReport,
    ACBrDelphiZXingQRCode,
  {$IFEND}


  RICK.PixQRCode.Utils,
  RICK.PixQRCode.Types,
  RICK.PixQRCode.Interfaces,


  IdSSL,
  IdHTTP,
  IdIOHandler,
  IdTCPClient,
  IdComponent,
  IdSSLOpenSSL,
  IdBaseComponent,
  IdTCPConnection,
  IdIOHandlerStack,
  IdIOHandlerSocket,
  IdSSLOpenSSLHeaders;

type
  TRICKPixQRCode = class(TInterfacedObject, iPixQRCode, iPixQRCodeTipoChave,
                          iPixQRCodeDados, iAPIGeraQRCodePIX, iImageQRCodePIX,
                          iGeraQRCodePIX)
  private
    FIdSSL                                      : TIdSSLIOHandlerSocketOpenSSL;
    FIDHTTP                                     : TIdHTTP;
    FTipoChavePix                               : TTipoChave;
    FMemoryStream                               : TMemoryStream;
    FPNG                                        : {$IFDEF MSWINDOWS}{$IF CompilerVersion >= 23.0}TPngImage{$ELSE}TPNGObject{$IFEND}{$ENDIF};
    FJPGE                                       : {$IFDEF MSWINDOWS}TJPEGImage{$ENDIF};
    FBitmap                                     : {$IFDEF MSWINDOWS}TBitmap{$ENDIF};
    FNome                                       : string;
    FCidade                                     : string;
    FValor                                      : string;
    FChavePix                                   : string;
    FChavePixCopiaCola                          : string;
    FRetornoPix                                 : string;
    FPathDLL                                    : string;
    FIdentificador                              : string;
    FSizeBrCode                                 : Integer;

    procedure GetAPIGerarQRCode(AQueryParam:string);
    {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
    procedure GetGerarQRCode(AWidth, AHeight: Integer; AChavePix: String;
      ACanvas: TCanvas);
    {$IFEND}
    procedure GetGerarChaveQRCode;

  protected
    function PathDLL(AValue: string)            : iPixQRCodeDados;
    function TipoChave                          : iPixQRCodeTipoChave;
    function Dados                              : iPixQRCodeDados;
    function APIGeraQRCodePIX                   : iAPIGeraQRCodePIX;
    function GeraQRCodePIX                      : iGeraQRCodePIX;
    function Imagem                             : iImageQRCodePIX;
    function ChavePixCopiaCola                  : string; overload;


    //Tipos de Chaves Pix
    function Telefone                           : iPixQRCodeTipoChave;
    function CPF                                : iPixQRCodeTipoChave;
    function CNPJ                               : iPixQRCodeTipoChave;
    function EMail                              : iPixQRCodeTipoChave;
    function Aleatoria                          : iPixQRCodeTipoChave;

    //Dados do Pix
    function Nome(AValue: string)               : iPixQRCodeDados;
    function Cidade(AValue: string)             : iPixQRCodeDados;
  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
    function Valor(AValue: Extended80)          : iPixQRCodeDados; overload;
  {$IFEND}

    function Valor(AValue: Double)              : iPixQRCodeDados; overload;
    function Valor(AValue: string)              : iPixQRCodeDados; overload;
    function ChavePix(AValue: string)           : iPixQRCodeDados;
    function ChavePixCopiaCola(AValue: string)  : iPixQRCodeDados; overload;
    function RetornoPix(AValue: string)         : iPixQRCodeDados;
    function Identificador(AValue: string)      : iPixQRCodeDados;
    function SizeBrCode(AValue: Integer)        : iPixQRCodeDados;

    //API Gerar Code PIX - https://gerarqrcodepix.com.br/ - https://github.com/ceciliadeveza/gerarqrcodepix
    function Estatico                           : iAPIGeraQRCodePIX;
    function Dinamico                           : iAPIGeraQRCodePIX;
    function BrCode                             : iAPIGeraQRCodePIX;

    //Gerar Code PIX
    function DadosEstatico                      : iGeraQRCodePIX;
    function CopiaCola                          : iGeraQRCodePIX;


   //Imagem do Pix QRCode
    function QRBitmap                           : TBitmap;
    function QRJPEG                             : TJPEGImage;
  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
    function QRPNG                              : TPngImage;
  {$ELSE} // VCL prior to XE2
    function QRPNG                              : TPNGObject;
  {$IFEND}
    function QRStream                           : TMemoryStream;


    function EndReturn                          : iPixQRCode;

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
  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  FTipoChavePix:= TTipoChave.EMail;
  {$ELSE} // VCL prior to XE2
  FTipoChavePix:= tpEMail;
  {$IFEND}
end;

function TRICKPixQRCode.EndReturn: iPixQRCode;
begin
  Result:= Self;
end;

function TRICKPixQRCode.Estatico: iAPIGeraQRCodePIX;
var
  LQueryParam : string;
begin
  Result:= Self;

  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  if FNome.Trim.IsEmpty then
  {$ELSE} // VCL prior to XE2
  if Trim(FNome) = EmptyStr then
  {$IFEND}
    raise Exception.Create('Informe o nome do recebedor do Pix');

  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  if FCidade.Trim.IsEmpty then
  {$ELSE} // VCL prior to XE2
  if Trim(FCidade) = EmptyStr then
  {$IFEND}
    raise Exception.Create('Informe a cidade do recebedor do PIX');

  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  if FChavePix.Trim.IsEmpty then
    raise Exception.Create(Format('Informe a Chave Pix (%s) cadastrada em qualquer PSP',
                                    [FTipoChavePix.ToString]));
  {$ELSE} // VCL prior to XE2
  if Trim(FChavePix) = EmptyStr then
    raise Exception.Create('Informe a Chave Pix cadastrada em qualquer PSP');
  {$IFEND}

  LQueryParam:= Format('saida=qr&nome=%s&cidade=%s&chave=%s',
                      [FNome, FCidade, FChavePix]);

  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  if not FValor.Trim.IsEmpty then
  {$ELSE} // VCL prior to XE2
  if not (Trim(FValor) = EmptyStr) then
  {$IFEND}
    LQueryParam:= Format('%s&valor=%s', [LQueryParam, FValor]);


  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  if not FIdentificador.Trim.IsEmpty then
  {$ELSE} // VCL prior to XE2
  if not (Trim(FIdentificador) = EmptyStr) then
  {$IFEND}
    LQueryParam:= Format('%s&txid=%s', [LQueryParam, FIdentificador]);

  GetAPIGerarQRCode(LQueryParam);
end;

function TRICKPixQRCode.GeraQRCodePIX: iGeraQRCodePIX;
begin
  Result:= Self;
end;

procedure TRICKPixQRCode.GetAPIGerarQRCode(AQueryParam:string);
begin

  IdSSLOpenSSLHeaders.IdOpenSSLSetLibPath(FPathDLL);
  FIdSSL.SSLOptions.Method:= sslvTLSv1_2;
  FIdSSL.SSLOptions.SSLVersions:= [sslvTLSv1_2];

  FIDHTTP.ConnectTimeout  := 10000;
  FIDHTTP.ReadTimeout     := 10000;
  FIDHTTP.HandleRedirects := True;
  FIDHTTP.Request.Accept  := 'image/png';
  FIDHTTP.IOHandler       := FIdSSL;

  FIDHTTP.Get(Format('%s%s', [_URL, AQueryParam]), FMemoryStream);

  FMemoryStream.Position:= 0;
  FPNG.LoadFromStream(FMemoryStream);
  FBitmap.Assign(FPNG);
  FJPGE.Assign(FBitmap);

  FChavePixCopiaCola:= FIDHTTP.Response.RawHeaders.Values['brcode'];

end;

procedure TRICKPixQRCode.GetGerarChaveQRCode;
const
  _PIXKEY = '00020126%s%s%s520400005303986%s5802BR%s%s%s%s6304';
  _DOMINIOREVERSO = '0014br.gov.bcb.pix';
var
  LPIXKey : string;
  LChavePix: string;
  LTotalDominioReversoChavePix: string;
  LValorPix: string;
  LNome :string;
  LCidade: string;
  LIDPix: string;
  LTotalIDCCT: string;
begin
  LValorPix:= EmptyStr;
  LIDPix   := EmptyStr;

  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  if not FValor.Trim.IsEmpty then
    LValorPix:= Format('54%2.2d%s', [FValor.Length, FValor]);

  if FIdentificador.Trim.IsEmpty then
    LIDPix:= '0503***'
  else
    LIDPix:= Format('05%2.2d%s', [FIdentificador.Length, FIdentificador]);

  LTotalIDCCT:= Format('62%2.2d', [LIDPix.Length]);

  LNome:= Format('59%2.2d%s', [FNome.Length, FNome]);
  LCidade:= Format('60%2.2d%s', [FCidade.Length, FCidade]);
  LChavePix := Format('01%2.2d%s', [FChavePix.Length, FChavePix]);

  LTotalDominioReversoChavePix:= Format('%2.2d', [(_DOMINIOREVERSO.Length + LChavePix.Length)]);
  {$ELSE} // VCL prior to XE2
  if not (Trim(FValor) = EmptyStr) then
    LValorPix:= Format('54%2.2d%s', [Length(FValor), FValor]);

  if (Trim(FIdentificador) = EmptyStr)then
    LIDPix:= '0503***'
  else
    LIDPix:= Format('05%2.2d%s', [Length(FIdentificador), FIdentificador]);

  LTotalIDCCT:= Format('62%2.2d', [Length(LIDPix)]);

  LNome:= Format('59%2.2d%s', [Length(FNome), FNome]);
  LCidade:= Format('60%2.2d%s', [Length(FCidade), FCidade]);
  LChavePix := Format('01%2.2d%s', [Length(FChavePix), FChavePix]);

  LTotalDominioReversoChavePix:= Format('%2.2d', [(Length(_DOMINIOREVERSO) + Length(LChavePix))]);
  {$IFEND}


  LPIXKey:= Format(_PIXKEY, [LTotalDominioReversoChavePix,
                              _DOMINIOREVERSO,
                              LChavePix,
                              LValorPix,
                              LNome,
                              LCidade,
                              LTotalIDCCT,
                              LIDPix]);

  LPIXKey:= Format('%s%s', [LPIXKey, TRICKPixQrCodeUtils.GerarCRCPix(LPIXKey)]);

  FChavePixCopiaCola:= LPIXKey;
end;

{$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
procedure TRICKPixQRCode.GetGerarQRCode(AWidth, AHeight: Integer; AChavePix: String;
      ACanvas: TCanvas);
var
  LBitmap: TBitmap;
  LRICKQRCode: TRICKQRCode;
  LRows: Integer;
  LColumns: Integer;
  LScala: Double;
begin
  LBitmap := TBitmap.create;
  try
    LRICKQRCode := TRICKQRCode.create;
    try
      LRICKQRCode.Data := AChavePix;

      // ajuta o tamanho do LBitmap para o tamanho do qrcode
      LBitmap.SetSize(LRICKQRCode.Rows, LRICKQRCode.Columns);

      // copia o qrcode para o LBitmap
      for LRows := 0 to Pred(LRICKQRCode.Rows) do
        for LColumns := 0 to Pred(LRICKQRCode.Columns) do
          if LRICKQRCode.IsBlack[LRows, LColumns] then
            LBitmap.Canvas.Pixels[LColumns, LRows] := clBlack
          else
            LBitmap.Canvas.Pixels[LColumns, LRows] := clWhite;

      // prepara para redimensionar o qrcode para o tamanho do canvas
      if (AWidth < LBitmap.Height) then
      begin
        LScala := AWidth / LBitmap.Width;
      end
      else
      begin
        LScala := AHeight / LBitmap.Height;
      end;

      // transfere o LBitmap para a imagem
      ACanvas.StretchDraw(Rect(0, 0, Trunc(LScala * LBitmap.Width),
        Trunc(LScala * LBitmap.Height)), LBitmap);

    finally
      LRICKQRCode.Free;
    end;
  finally
    LBitmap.Free;
  end;
end;
{$IFEND}

function TRICKPixQRCode.Identificador(AValue: string): iPixQRCodeDados;
begin
  Result:= Self;

  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  FIdentificador:= AValue.Trim;
  {$ELSE} // VCL prior to XE2
  FIdentificador:= Trim(AValue);
  {$IFEND}

  FIdentificador:= TRICKPixQrCodeUtils.CopyData(FIdentificador, 25);

end;

function TRICKPixQRCode.Imagem: iImageQRCodePIX;
begin
  Result:= Self;
end;

function TRICKPixQRCode.Aleatoria: iPixQRCodeTipoChave;
begin
  Result:= Self;
  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  FTipoChavePix:= TTipoChave.Aleatoria;
  {$ELSE} // VCL prior to XE2
  FTipoChavePix:= tpAleatoria;
  {$IFEND}
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

  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  if FChavePixCopiaCola.Trim.IsEmpty then
  {$ELSE} // VCL prior to XE2
  if Trim(FChavePixCopiaCola) = EmptyStr then
  {$IFEND}
    raise Exception.Create('Informe a Chave Copia e Cola cadastrada em qualquer PSP');

  LQueryParam:= Format('brcode=%s', [FChavePixCopiaCola]);

  GetAPIGerarQRCode(LQueryParam);
end;

function TRICKPixQRCode.ChavePix(AValue: string): iPixQRCodeDados;
var
  LChave : string;
begin
  Result:= Self;
  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  LChave:= AValue.Trim;
  {$ELSE} // VCL prior to XE2
  LChave:= Trim(AValue);
  {$IFEND}

  case FTipoChavePix of
  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
    TTipoChave.Telefone   :
  {$ELSE} // VCL prior to XE2
    tpTelefone   :
  {$IFEND}
    begin
  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
      if not LChave.Contains('+55') then
  {$ELSE} // VCL prior to XE2
      if Pos('+55', LChave) <> 0 then
  {$IFEND}
        LChave:= Format('+55%s', [LChave]);

      LChave:= Format('+%s', [TRICKPixQrCodeUtils.GetSomenteNumero(LChave)]);

  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
      if (not (LChave.Length = 14) or (LChave.Length = 13)) then
  {$ELSE} // VCL prior to XE2
      if (not (Length(LChave) = 14) or (Length(LChave) = 13)) then
  {$IFEND}
        raise Exception.Create('O telefone informado é inválido');

    end;
  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
    TTipoChave.CPF        :
  {$ELSE} // VCL prior to XE2
    tpCPF        :
  {$IFEND}
    begin
      LChave:= TRICKPixQrCodeUtils.GetSomenteNumero(LChave);

      if not TRICKPixQrCodeUtils.IsValidCPF(LChave) then
        raise Exception.Create('O CPF informado é inválido');
    end;
  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
    TTipoChave.CNPJ       :
  {$ELSE} // VCL prior to XE2
    tpCNPJ       :
  {$IFEND}
    begin
      LChave:= TRICKPixQrCodeUtils.GetSomenteNumero(LChave);

      if not TRICKPixQrCodeUtils.IsValidCNPJ(LChave) then
        raise Exception.Create('O CNPJ informado é inválido');
    end;
  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
    TTipoChave.Email       :
  {$ELSE} // VCL prior to XE2
    tpEmail       :
  {$IFEND}
    begin
      if not TRICKPixQrCodeUtils.IsValidEmail(LChave) then
        raise Exception.Create('O E-Mail informado é inválido');
    end;

  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
    TTipoChave.Aleatoria  : ;
  {$ELSE} // VCL prior to XE2
    tpAleatoria           : ;
  {$IFEND}
  else
    raise Exception.Create('Informe o tipo da chave');
  end;

  FChavePix:= LChave;
end;

function TRICKPixQRCode.ChavePixCopiaCola: string;
begin
  Result:= FChavePixCopiaCola;
end;

function TRICKPixQRCode.ChavePixCopiaCola(AValue: string): iPixQRCodeDados;
begin
  Result:= Self;
  FChavePixCopiaCola:= AValue;
end;

function TRICKPixQRCode.Cidade(AValue: string): iPixQRCodeDados;
begin
  Result:= Self;
  FCidade:= TRICKPixQrCodeUtils.CopyData(
              TRICKPixQrCodeUtils.RemoveAcento(AValue),
              15);

end;

function TRICKPixQRCode.CNPJ: iPixQRCodeTipoChave;
begin
  Result:= Self;
  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  FTipoChavePix:= TTipoChave.CNPJ;
  {$ELSE} // VCL prior to XE2
  FTipoChavePix:= tpCNPJ;
  {$IFEND}

end;

function TRICKPixQRCode.CopiaCola: iGeraQRCodePIX;
var
  LMemoryStream: TMemoryStream;
begin
  Result:= Self;
  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  if FChavePixCopiaCola.Trim.IsEmpty then
  {$ELSE} // VCL prior to XE2
  if Trim(FChavePixCopiaCola) = EmptyStr then
  {$IFEND}
    raise Exception.Create('Chave pix não informado');

  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  FBitmap.SetSize(FSizeBrCode, FSizeBrCode);
  GetGerarQRCode(FBitmap.Width, FBitmap.Height, FChavePixCopiaCola, FBitmap.Canvas);
  {$ELSE} // VCL prior to XE2
  PintarQRCode(FChavePixCopiaCola, FBitmap, qrUTF8BOM);
  {$IFEND}

  FPNG.Assign(FBitmap);
  FJPGE.Assign(FBitmap);
  LMemoryStream:= TMemoryStream.Create;
  try
    FBitmap.SaveToStream(LMemoryStream);
    FMemoryStream.LoadFromStream(LMemoryStream);
  finally
    FreeAndNil(LMemoryStream);
  end;

end;

function TRICKPixQRCode.CPF: iPixQRCodeTipoChave;
begin
  Result:= Self;
  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  FTipoChavePix:= TTipoChave.CPF;
  {$ELSE} // VCL prior to XE2
  FTipoChavePix:= tpCPF;
  {$IFEND}
end;

constructor TRICKPixQRCode.Create;
begin
  FPathDLL:= GetCurrentDir;

  if not Assigned(FIDHTTP) then
    FIDHTTP := TIdHTTP.Create;

  if not Assigned(FMemoryStream) then
    FMemoryStream := TMemoryStream.Create;

  if not Assigned(FPNG) then
    FPNG := {$IFDEF MSWINDOWS}{$IF CompilerVersion >= 23.0}TPngImage{$ELSE}TPNGObject{$IFEND}{$ENDIF}.Create;

  if not Assigned(FBitmap) then
    FBitmap := {$IFDEF MSWINDOWS}TBitmap.Create{$ENDIF};

  if not Assigned(FJPGE) then
    FJPGE := {$IFDEF MSWINDOWS}TJPEGImage.Create{$ENDIF};

  if not Assigned(FIdSSL) then
    FIdSSL := TIdSSLIOHandlerSocketOpenSSL.Create(Nil);

  FSizeBrCode := 250;
end;

function TRICKPixQRCode.Dados: iPixQRCodeDados;
begin
  Result:= Self;
end;

function TRICKPixQRCode.DadosEstatico: iGeraQRCodePIX;
begin
  Result:= Self;
  GetGerarChaveQRCode;
  CopiaCola;
end;

destructor TRICKPixQRCode.Destroy;
begin
  if Assigned(FIDHTTP) then
    FIDHTTP.Free;

  if Assigned(FMemoryStream) then
    FMemoryStream.Free;

  if Assigned(FPNG) then
    FPNG.Free;

  if Assigned(FBitmap) then
    FBitmap.Free;

  if Assigned(FJPGE) then
    FJPGE.Free;

  if Assigned(FIdSSL) then
    FIdSSL.Free;

  inherited;
end;

function TRICKPixQRCode.Dinamico: iAPIGeraQRCodePIX;
var
  LQueryParam: string;
begin
  Result:= Self;

  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  if FNome.Trim.IsEmpty then
  {$ELSE} // VCL prior to XE2
  if Trim(FNome) = EmptyStr then
  {$IFEND}
    raise Exception.Create('Informe o nome do recebedor do Pix');

  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  if FCidade.Trim.IsEmpty then
  {$ELSE} // VCL prior to XE2
  if Trim(FCidade) = EmptyStr then
  {$IFEND}
    raise Exception.Create('Informe a cidade do recebedor do PIX');

  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  if FRetornoPix.Trim.IsEmpty then
  {$ELSE} // VCL prior to XE2
  if Trim(FRetornoPix) = EmptyStr then
  {$IFEND}
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
  FNome:= TRICKPixQrCodeUtils.CopyData(
            TRICKPixQrCodeUtils.RemoveAcento(AValue),
            25);
end;

function TRICKPixQRCode.PathDLL(AValue: string): iPixQRCodeDados;
begin
  Result:= Self;
  FPathDLL:= AValue;
end;

function TRICKPixQRCode.QRBitmap: TBitmap;
begin
  Result:= FBitmap;
end;

function TRICKPixQRCode.QRJPEG: TJPEGImage;
begin
  Result:= FJPGE;
end;

{$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
function TRICKPixQRCode.QRPNG: TPngImage;
{$ELSE} // VCL prior to XE2
function TRICKPixQRCode.QRPNG: TPNGObject;
{$IFEND}

begin
  Result:= FPNG;
end;

function TRICKPixQRCode.QRStream: TMemoryStream;
begin
  FMemoryStream.Position:= 0;
  Result:= FMemoryStream;
end;

function TRICKPixQRCode.RetornoPix(AValue: string): iPixQRCodeDados;
begin
  Result:= Self;
  FRetornoPix:= AValue;
end;

function TRICKPixQRCode.SizeBrCode(AValue: Integer): iPixQRCodeDados;
begin
  Result:= Self;
  FSizeBrCode:= AValue;
end;

function TRICKPixQRCode.Telefone: iPixQRCodeTipoChave;
begin
  Result:= Self;
{$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  FTipoChavePix:= TTipoChave.Telefone;
{$ELSE} // VCL prior to XE2
  FTipoChavePix:= tpTelefone;
{$IFEND}
end;

function TRICKPixQRCode.TipoChave: iPixQRCodeTipoChave;
begin
  Result:= Self;
end;

function TRICKPixQRCode.Valor(AValue: string): iPixQRCodeDados;
var
{$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  LValor : Extended80;
{$ELSE} // VCL prior to XE2
  LValor : Extended;
{$IFEND}
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
{$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  Valor(AValue.ToString);
{$ELSE} // VCL prior to XE2
  Valor(FloatToStr(AValue));
{$IFEND}
end;

{$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
function TRICKPixQRCode.Valor(AValue: Extended80): iPixQRCodeDados;
begin
  Result:= Self;
  Valor(FloatToStr(AValue));
end;
{$IFEND}

end.
