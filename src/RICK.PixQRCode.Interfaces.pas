unit RICK.PixQRCode.Interfaces;

interface
uses
  RICK.PixQRCode.Types;

type
  iPixQRCodeTipoChave             = interface;
  iPixQRCodeDados                 = interface;
  iAPIGeraQRCodePIX               = interface;

  iPixQRCode                      = interface
    ['{F4334CE7-3AEA-4FD2-B1C2-C7B754CE5A2E}']
    function PathDLL(AValue: string)            : iPixQRCodeDados;
    function TipoChave                          : iPixQRCodeTipoChave;
    function Dados                              : iPixQRCodeDados;
    function APIGeraQRCodePIX                   : iAPIGeraQRCodePIX;

  end;
  iPixQRCodeTipoChave             = interface
    ['{C64329B9-9AE3-4B00-866C-E447D3F250D3}']
    function Telefone                           : iPixQRCodeTipoChave;
    function CPF                                : iPixQRCodeTipoChave;
    function CNPJ                               : iPixQRCodeTipoChave;
    function EMail                              : iPixQRCodeTipoChave;
    function Aleatoria                          : iPixQRCodeTipoChave;

    function &End                               : iPixQRCode;
  end;

  iPixQRCodeDados                 = interface
    ['{8EF593D5-C480-4170-9D26-5C6BAA9C0950}']
    function Nome(AValue: string)               : iPixQRCodeDados;
    function Cidade(AValue: string)             : iPixQRCodeDados;
    function Valor(AValue: Extended80)          : iPixQRCodeDados; overload;
    function Valor(AValue: Double)              : iPixQRCodeDados; overload;
    function Valor(AValue: string)              : iPixQRCodeDados; overload;
    function ChavePix(AValue: string)           : iPixQRCodeDados;
    function ChavePixCopiaCola(AValue: string)  : iPixQRCodeDados;

    function &End                               : iPixQRCode;

  end;


  iAPIGeraQRCodePIX               = interface
    ['{8DD79126-5C20-4B0C-A1A3-89AB6723EF62}']
    function Estatico                           : iAPIGeraQRCodePIX;
    function Dinamico                           : iAPIGeraQRCodePIX;
    function BrCode                             : iAPIGeraQRCodePIX;

    function &End                               : iPixQRCode;

  end;





implementation

end.
