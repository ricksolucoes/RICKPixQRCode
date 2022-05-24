unit View.Principal;

interface

uses
  Winapi.Windows,
  Winapi.Messages,

  System.SysUtils,
  System.Variants,
  System.Classes,

  Vcl.Forms,
  Vcl.Buttons,
  Vcl.Dialogs,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,

  RICK.PixQRCode,
  RICK.PixQRCode.Interfaces;

type
  TPagePrincipal = class(TForm)
    PageControl: TPageControl;
    tsDados: TTabSheet;
    lblGeradorQrCode: TLabel;
    cbxGeradorQrCode: TComboBox;
    edtNome: TLabeledEdit;
    edtCidade: TLabeledEdit;
    PageControlComplemento: TPageControl;
    tsEstatico: TTabSheet;
    tsDinamico: TTabSheet;
    tsBrCode: TTabSheet;
    cbxTipo: TComboBox;
    edtChavePix: TLabeledEdit;
    edtValor: TLabeledEdit;
    btGerar: TSpeedButton;
    imgQRCode: TImage;
    MemoChaveCopiaCola: TMemo;
    edtIdentificador: TLabeledEdit;
    lblRetornoPix: TLabel;
    lblPixCopiaCola: TLabel;
    MemoRetornoPix: TMemo;
    MemoPixCopiaCola: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btGerarClick(Sender: TObject);
    procedure cbxTipoChange(Sender: TObject);
    procedure cbxGeradorQrCodeChange(Sender: TObject);
    procedure PageControlComplementoChange(Sender: TObject);
  private
    FPixQRCode : iPixQRCode;

  end;

var
  PagePrincipal: TPagePrincipal;

implementation

uses
  RICK.PixQRCode.Utils;

{$R *.dfm}

procedure TPagePrincipal.btGerarClick(Sender: TObject);
begin
  MemoChaveCopiaCola.Lines.Clear;

  case cbxGeradorQrCode.ItemIndex of
    0:
    begin
      FPixQRCode
        .Dados
          .Nome(edtNome.Text)
          .Cidade(edtCidade.Text)
          .ChavePix(edtChavePix.Text)
          .Valor(edtValor.Text)
          .Identificador(edtIdentificador.Text)
        .EndReturn
        .APIGeraQRCodePIX
          .Estatico
        .EndReturn;
    end;
    1:
    begin
      FPixQRCode
        .Dados
          .Nome(edtNome.Text)
          .Cidade(edtCidade.Text)
          .RetornoPix(MemoRetornoPix.Text)
        .EndReturn
        .APIGeraQRCodePIX
          .Dinamico
        .EndReturn;
    end;
    2:
    begin
      FPixQRCode
        .Dados
          .ChavePixCopiaCola(MemoPixCopiaCola.Lines.Text)
        .EndReturn
        .APIGeraQRCodePIX
          .BrCode
        .EndReturn;
    end;
    3:
    begin
      FPixQRCode
        .Dados
          .ChavePixCopiaCola(MemoPixCopiaCola.Lines.Text)
        .EndReturn
        .GeraQRCodePIX
          .CopiaCola
        .EndReturn;
    end;
    4:
    begin
      FPixQRCode
        .Dados
          .Nome(edtNome.Text)
          .Cidade(edtCidade.Text)
          .ChavePix(edtChavePix.Text)
          .Valor(edtValor.Text)
          .Identificador(edtIdentificador.Text)
        .EndReturn
        .GeraQRCodePIX
          .DadosEstatico
        .EndReturn;
    end;
  end;

  imgQRCode.Picture.Bitmap.Assign(FPixQRCode.Imagem.QRPNG);
  MemoChaveCopiaCola.Lines.Add(FPixQRCode.ChavePixCopiaCola);


end;

procedure TPagePrincipal.cbxGeradorQrCodeChange(Sender: TObject);
begin
  PageControl.Enabled:= False;
  try
    edtNome.ReadOnly    := False;
    edtCidade.ReadOnly  := False;

    case TComboBox(Sender).ItemIndex of
      0, 4: PageControlComplemento.ActivePage:= tsEstatico;
      1: PageControlComplemento.ActivePage:= tsDinamico;
      2, 3:
      begin
        edtNome.ReadOnly    := True;
        edtCidade.ReadOnly  := True;
        PageControlComplemento.ActivePage:= tsBrCode;
      end;
    end;
  finally
    PageControl.Enabled:= True;
  end;

end;

procedure TPagePrincipal.cbxTipoChange(Sender: TObject);
begin
  case TComboBox(Sender).ItemIndex of
    0: FPixQRCode.TipoChave.Telefone;
    1: FPixQRCode.TipoChave.CPF;
    2: FPixQRCode.TipoChave.CNPJ;
    3: FPixQRCode.TipoChave.EMail;
    4: FPixQRCode.TipoChave.Aleatoria;
  end;

end;

procedure TPagePrincipal.FormCreate(Sender: TObject);
begin
  FPixQRCode:= TRICKPixQRCode.New.TipoChave.Telefone.EndReturn;
  cbxGeradorQrCode.ItemIndex:= 0;
  PageControlComplemento.TabPosition:= TTabPosition.tpBottom;
  PageControlComplemento.ActivePage:= tsEstatico;
  {$IFDEF DEBUG}
  cbxTipo.ItemIndex:= 3;
  FPixQRCode.TipoChave.EMail;
  edtNome.Text := 'Ricardo Rocha Pereira';
  edtCidade.Text:= 'Rio de Janeiro';
  edtChavePix.Text := 'serpentedodeserto@gmail.com';
  edtValor.Text:= '1.234,94';
  edtIdentificador.Text:= TRICKPixQrCodeUtils.CopyReverse('33220430852342000109650010000015961009667212', 25); //podemos pegar os 25 ultimos caracteres da chave de nfce
  MemoPixCopiaCola.Lines.Add('00020126490014br.gov.bcb.pix0127serpentedodeserto@gmail.com52040000530398654040.015802BR5921RICARDO ROCHA PEREIRA6011NOVA IGUACU62150511DividaTeste63042EA0');
  {$ENDIF}

end;

procedure TPagePrincipal.PageControlComplementoChange(Sender: TObject);
begin
  case cbxGeradorQrCode.ItemIndex of
    0: TPageControl(Sender).ActivePage:= tsEstatico;
    1: TPageControl(Sender).ActivePage:= tsDinamico;
    2: TPageControl(Sender).ActivePage:= tsBrCode;
    3: TPageControl(Sender).ActivePage:= tsBrCode;
    4: TPageControl(Sender).ActivePage:= tsEstatico;
  end;
end;

end.
