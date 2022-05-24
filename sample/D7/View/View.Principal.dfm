object PagePrincipal: TPagePrincipal
  Left = 331
  Top = 147
  Width = 766
  Height = 519
  Caption = 'PagePrincipal'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    750
    480)
  PixelsPerInch = 96
  TextHeight = 13
  object imgQRCode: TImage
    Left = 368
    Top = 18
    Width = 360
    Height = 343
    Anchors = [akLeft, akTop, akRight, akBottom]
    Stretch = True
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 335
    Height = 480
    ActivePage = tsDados
    Align = alLeft
    TabOrder = 0
    object tsDados: TTabSheet
      Caption = 'Dados'
      DesignSize = (
        327
        452)
      object lblGeradorQrCode: TLabel
        Left = 0
        Top = 0
        Width = 327
        Height = 13
        Align = alTop
        Caption = 'Gerador QrCode'
      end
      object btGerar: TSpeedButton
        Left = 64
        Top = 400
        Width = 175
        Height = 41
        Cursor = crHandPoint
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'Gerar'
        OnClick = btGerarClick
      end
      object cbxGeradorQrCode: TComboBox
        Left = 3
        Top = 21
        Width = 321
        Height = 22
        AutoDropDown = True
        AutoCloseUp = True
        Style = csOwnerDrawFixed
        ItemHeight = 16
        ItemIndex = 0
        TabOrder = 0
        Text = '(API) Gerador de QrCode Pix - (Estatico)'
        OnChange = cbxGeradorQrCodeChange
        Items.Strings = (
          '(API) Gerador de QrCode Pix - (Estatico)'
          '(API) Gerador de QrCode Pix - (Dinamico)'
          '(API) Gerador de QrCode Pix - (BrCode)'
          'Gerar QR-Code Copia/Cola'
          'Gerar QR-Code')
      end
      object edtNome: TLabeledEdit
        Left = 0
        Top = 72
        Width = 324
        Height = 21
        EditLabel.Width = 28
        EditLabel.Height = 13
        EditLabel.Caption = 'Nome'
        TabOrder = 1
      end
      object edtCidade: TLabeledEdit
        Left = 0
        Top = 120
        Width = 324
        Height = 21
        EditLabel.Width = 33
        EditLabel.Height = 13
        EditLabel.Caption = 'Cidade'
        TabOrder = 2
      end
      object PageControlComplemento: TPageControl
        Left = 0
        Top = 160
        Width = 321
        Height = 177
        ActivePage = tsEstatico
        TabOrder = 3
        TabPosition = tpBottom
        OnChange = PageControlComplementoChange
        object tsEstatico: TTabSheet
          Caption = 'Estatico'
          object cbxTipo: TComboBox
            Left = 0
            Top = 16
            Width = 81
            Height = 22
            AutoDropDown = True
            AutoCloseUp = True
            Style = csOwnerDrawFixed
            ItemHeight = 16
            ItemIndex = 0
            TabOrder = 0
            Text = 'Telefone'
            OnChange = cbxTipoChange
            Items.Strings = (
              'Telefone'
              'CPF'
              'CNPJ'
              'EMail'
              'Aleatoria')
          end
          object edtChavePix: TLabeledEdit
            Left = 90
            Top = 16
            Width = 215
            Height = 21
            EditLabel.Width = 48
            EditLabel.Height = 13
            EditLabel.Caption = 'Chave Pix'
            TabOrder = 1
          end
          object edtValor: TLabeledEdit
            Left = 3
            Top = 67
            Width = 302
            Height = 21
            EditLabel.Width = 24
            EditLabel.Height = 13
            EditLabel.Caption = 'Valor'
            TabOrder = 2
          end
          object edtIdentificador: TLabeledEdit
            Left = 0
            Top = 111
            Width = 302
            Height = 21
            EditLabel.Width = 217
            EditLabel.Height = 13
            EditLabel.Caption = 'Identificador da Opera'#231'ao (At'#233' 25 Caracteres)'
            MaxLength = 25
            TabOrder = 3
          end
        end
        object tsDinamico: TTabSheet
          Caption = 'Dinamico'
          ImageIndex = 1
          object lblRetornoPix: TLabel
            Left = 0
            Top = 0
            Width = 313
            Height = 13
            Align = alTop
            Caption = 'Retorno Pix'
          end
          object MemoRetornoPix: TMemo
            Left = 0
            Top = 13
            Width = 313
            Height = 138
            Align = alClient
            TabOrder = 0
          end
        end
        object tsBrCode: TTabSheet
          Caption = 'BRCode'
          ImageIndex = 2
          object Label1: TLabel
            Left = 0
            Top = 0
            Width = 313
            Height = 13
            Align = alTop
            Caption = 'Pix Copia Cola'
          end
          object MemoPixCopiaCola: TMemo
            Left = 0
            Top = 13
            Width = 313
            Height = 138
            Align = alClient
            TabOrder = 0
          end
        end
      end
    end
  end
  object MemoChaveCopiaCola: TMemo
    Left = 368
    Top = 376
    Width = 361
    Height = 89
    BorderStyle = bsNone
    ReadOnly = True
    TabOrder = 1
  end
end
