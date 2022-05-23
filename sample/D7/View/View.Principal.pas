unit View.Principal;
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons,

  RICK.PixQRCode,
  RICK.PixQRCode.Utils,
  RICK.PixQRCode.Interfaces;

type
  TPagePrincipal = class(TForm)
    imgQRCode: TImage;
    PageControl: TPageControl;
    tsDados: TTabSheet;
    cbxGeradorQrCode: TComboBox;
    edtNome: TLabeledEdit;
    edtCidade: TLabeledEdit;
    lblGeradorQrCode: TLabel;
    PageControlComplemento: TPageControl;
    tsEstatico: TTabSheet;
    tsDinamico: TTabSheet;
    tsBrCode: TTabSheet;
    cbxTipo: TComboBox;
    edtChavePix: TLabeledEdit;
    edtValor: TLabeledEdit;
    Label1: TLabel;
    MemoPixCopiaCola: TMemo;
    MemoRetornoPix: TMemo;
    lblRetornoPix: TLabel;
    btGerar: TSpeedButton;
    MemoChaveCopiaCola: TMemo;
    edtIdentificador: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure btGerarClick(Sender: TObject);
    procedure cbxTipoChange(Sender: TObject);
    procedure cbxGeradorQrCodeChange(Sender: TObject);
  private
    FPixQRCode : iPixQRCode;

  end;

var
  PagePrincipal: TPagePrincipal;

implementation

{$R *.dfm}

procedure TPagePrincipal.FormCreate(Sender: TObject);
begin
  FPixQRCode:= TRICKPixQRCode.New.TipoChave.Telefone.EndReturn;

  cbxGeradorQrCode.ItemIndex:= 0;
  PageControlComplemento.TabPosition:= tpBottom;
  PageControlComplemento.ActivePage:= tsEstatico;

  cbxTipo.ItemIndex:= 3;
  FPixQRCode.TipoChave.EMail;
  edtNome.Text := 'Ricardo Rocha Pereira';
  edtCidade.Text:= 'Rio de Janeiro';
  edtChavePix.Text := 'serpentedodeserto@gmail.com';
  edtValor.Text:= '1.234,94';
  edtIdentificador.Text:= TRICKPixQrCodeUtils.CopyReverse('33220430852342000109650010000015961009667212', 25); //podemos pegar os 25 ultimos caracteres da chave de nfce
  MemoPixCopiaCola.Lines.Add('00020126490014br.gov.bcb.pix0127serpentedodeserto@gmail.com52040000530398654040.015802BR5921RICARDO ROCHA PEREIRA6011NOVA IGUACU62150511DividaTeste63042EA0');

end;

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
  end;

  imgQRCode.Picture.Bitmap.Assign(FPixQRCode.Imagem.QRJPEG);
  MemoChaveCopiaCola.Lines.Add(FPixQRCode.ChavePixCopiaCola);

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

procedure TPagePrincipal.cbxGeradorQrCodeChange(Sender: TObject);
begin
  PageControl.Enabled:= False;
  try
    edtNome.ReadOnly := False;
    edtCidade.ReadOnly:= False;

    case TComboBox(Sender).ItemIndex of
      0: PageControlComplemento.ActivePage:= tsEstatico;
      1: PageControlComplemento.ActivePage:= tsDinamico;
      2:
      begin
        edtNome.ReadOnly := True;
        edtCidade.ReadOnly:= True;
        PageControlComplemento.ActivePage:= tsBrCode;
      end;
    end;
  finally
    PageControl.Enabled:= True;
  end;

end;

end.
