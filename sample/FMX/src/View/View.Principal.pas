unit View.Principal;

interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Surfaces, FMX.Graphics, FMX.Dialogs,

  RICK.PixQRCode,
  RICK.PixQRCode.Interfaces,

  IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects,
  FMX.Edit, FMX.TabControl, FMX.ListBox, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo

  ;


type
  TPagePrincipal = class(TForm)
    btGerar: TSpeedButton;
    imgQRCode: TImage;
    TabControl: TTabControl;
    tbiDados: TTabItem;
    edtNome: TEdit;
    lnNome: TLine;
    edtCidade: TEdit;
    lnCidade: TLine;
    cbxGeradorQrCode: TComboBox;
    lblGeradorQrCode: TLabel;
    TabControlpixComplemento: TTabControl;
    tiEstatico: TTabItem;
    tiDinamico: TTabItem;
    edtValor: TEdit;
    Line2: TLine;
    cbxTipo: TComboBox;
    edtChavePix: TEdit;
    lnChavePix: TLine;
    tiBrCode: TTabItem;
    MemoPixCopiaCola: TMemo;
    lblPixCopiaCola: TLabel;
    MemoRetornoPix: TMemo;
    lblRetornoPix: TLabel;
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

{$R *.fmx}


procedure TPagePrincipal.cbxGeradorQrCodeChange(Sender: TObject);
begin
  TabControl.Enabled:= False;
  try
    edtNome.ReadOnly := False;
    edtCidade.ReadOnly:= False;

    case TComboBox(Sender).ItemIndex of
      0: TabControlpixComplemento.ActiveTab:= tiEstatico;
      1: TabControlpixComplemento.ActiveTab:= tiDinamico;
      2:
      begin
        edtNome.ReadOnly := True;
        edtCidade.ReadOnly:= True;
        TabControlpixComplemento.ActiveTab:= tiBrCode;
      end;
    end;
  finally
    TabControl.Enabled:= True;
  end;
end;

procedure TPagePrincipal.cbxTipoChange(Sender: TObject);
begin
  case TComboBox(Sender).ItemIndex of
    0:
    begin
      FPixQRCode.TipoChave.Telefone;
      edtChavePix.TextPrompt:= 'Chave Pix Telefone';
    end;
    1:
    begin
      FPixQRCode.TipoChave.CPF;
      edtChavePix.TextPrompt:= 'Chave Pix CPF';
    end;
    2:
    begin
      FPixQRCode.TipoChave.CNPJ;
      edtChavePix.TextPrompt:= 'Chave Pix CNPJ';
    end;
    3:
    begin
      FPixQRCode.TipoChave.EMail;
      edtChavePix.TextPrompt:= 'Chave Pix EMail';
    end;
    4:
    begin
      FPixQRCode.TipoChave.Aleatoria;
      edtChavePix.TextPrompt:= 'Chave Pix Aleatória';
    end;
  end;
end;

procedure TPagePrincipal.FormCreate(Sender: TObject);
begin
  FPixQRCode:= TRICKPixQRCode.New.TipoChave.Telefone.EndReturn;
  cbxGeradorQrCode.ItemIndex:= 0;
  TabControlpixComplemento.TabPosition:= TTabPosition.None;
  TabControlpixComplemento.ActiveTab:= tiEstatico;
  {$IFDEF DEBUG}
  cbxTipo.ItemIndex:= 3;
  edtNome.Text := 'Ricardo Rocha Pereira';
  edtCidade.Text:= 'Rio de Janeiro';
  edtChavePix.Text := 'serpentedodeserto@gmail.com';
  edtValor.Text:= '1.234,94';
  MemoPixCopiaCola.Lines.Add('00020126490014br.gov.bcb.pix0127serpentedodeserto@gmail.com52040000530398654040.015802BR5921RICARDO ROCHA PEREIRA6011NOVA IGUACU62150511DividaTeste63042EA0');
  {$ENDIF}

end;

procedure TPagePrincipal.btGerarClick(Sender: TObject);
begin
  case cbxGeradorQrCode.ItemIndex of
    0:
    begin
      FPixQRCode
        .Dados
          .Nome(edtNome.Text)
          .Cidade(edtCidade.Text)
          .ChavePix(edtChavePix.Text)
          .Valor(edtValor.Text)
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

  imgQRCode.Bitmap:= FPixQRCode.Imagem.QRBitmap;

end;

end.
