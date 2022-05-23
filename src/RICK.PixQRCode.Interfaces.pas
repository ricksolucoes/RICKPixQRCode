unit RICK.PixQRCode.Interfaces;

interface
uses
  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
    Vcl.Graphics,
    Vcl.Imaging.jpeg,
    Vcl.Imaging.pngimage,
    System.Classes,
  {$ELSE} // VCL prior to XE2
    Graphics,
    pngimage,
    JPEG ,
    Classes,
  {$IFEND}

  RICK.PixQRCode.Types;

type
  iPixQRCodeTipoChave             = interface;
  iPixQRCodeDados                 = interface;
  iAPIGeraQRCodePIX               = interface;
  iImageQRCodePIX                 = interface;

  iPixQRCode                      = interface
    ['{F4334CE7-3AEA-4FD2-B1C2-C7B754CE5A2E}']
    function PathDLL(AValue: string)            : iPixQRCodeDados;
    function TipoChave                          : iPixQRCodeTipoChave;
    function Dados                              : iPixQRCodeDados;
    function APIGeraQRCodePIX                   : iAPIGeraQRCodePIX;
    function Imagem                             : iImageQRCodePIX;
    function ChavePixCopiaCola                  : string; overload;
  end;
  iPixQRCodeTipoChave             = interface
    ['{C64329B9-9AE3-4B00-866C-E447D3F250D3}']
    function Telefone                           : iPixQRCodeTipoChave;
    function CPF                                : iPixQRCodeTipoChave;
    function CNPJ                               : iPixQRCodeTipoChave;
    function EMail                              : iPixQRCodeTipoChave;
    function Aleatoria                          : iPixQRCodeTipoChave;

    function EndReturn                          : iPixQRCode;
  end;

  iPixQRCodeDados                 = interface
    ['{8EF593D5-C480-4170-9D26-5C6BAA9C0950}']
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

    function EndReturn                          : iPixQRCode;

  end;


  iAPIGeraQRCodePIX               = interface
    ['{8DD79126-5C20-4B0C-A1A3-89AB6723EF62}']
    function Estatico                           : iAPIGeraQRCodePIX;
    function Dinamico                           : iAPIGeraQRCodePIX;
    function BrCode                             : iAPIGeraQRCodePIX;

    function EndReturn                          : iPixQRCode;

  end;

  iImageQRCodePIX                 = interface
    ['{D5FD4165-EE62-4ABA-B3B1-50F88B8F4EF8}']
    function QRBitmap                           : TBitmap;
    function QRJPEG                             : TJPEGImage;
  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
    function QRPNG                              : TPngImage;
  {$ELSE} // VCL prior to XE2
    function QRPNG                              : TPNGObject;
  {$IFEND}
    function QRStream                           : TMemoryStream;
  end;




implementation

end.
