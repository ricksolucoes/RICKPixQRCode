object PagePrincipal: TPagePrincipal
  Left = 0
  Top = 0
  Caption = 'PagePrincipal'
  ClientHeight = 480
  ClientWidth = 750
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    750
    480)
  PixelsPerInch = 96
  TextHeight = 15
  object imgQRCode: TImage
    Left = 360
    Top = 8
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
      ExplicitLeft = 8
      ExplicitTop = 30
      object lblGeradorQrCode: TLabel
        Left = 0
        Top = 0
        Width = 327
        Height = 15
        Align = alTop
        Caption = 'Gerador QrCode'
        ExplicitWidth = 86
      end
      object btGerar: TSpeedButton
        Left = 0
        Top = 400
        Width = 327
        Height = 50
        Cursor = crHandPoint
        Align = alBottom
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
        ItemIndex = 0
        TabOrder = 0
        Text = '(API) Gerador de QrCode Pix - (Estatico)'
        OnChange = cbxGeradorQrCodeChange
        Items.Strings = (
          '(API) Gerador de QrCode Pix - (Estatico)'
          '(API) Gerador de QrCode Pix - (Dinamico)'
          '(API) Gerador de QrCode Pix - (BrCode)')
      end
      object edtNome: TLabeledEdit
        Left = 0
        Top = 72
        Width = 324
        Height = 23
        EditLabel.Width = 33
        EditLabel.Height = 15
        EditLabel.Caption = 'Nome'
        TabOrder = 1
      end
      object edtCidade: TLabeledEdit
        Left = 0
        Top = 120
        Width = 324
        Height = 23
        EditLabel.Width = 37
        EditLabel.Height = 15
        EditLabel.Caption = 'Cidade'
        TabOrder = 2
      end
      object PageControlComplemento: TPageControl
        Left = 5
        Top = 160
        Width = 313
        Height = 177
        ActivePage = tsEstatico
        MultiLine = True
        TabOrder = 3
        TabPosition = tpBottom
        object tsEstatico: TTabSheet
          Caption = 'Estatico'
          ExplicitHeight = 79
          object cbxTipo: TComboBox
            Left = 0
            Top = 16
            Width = 81
            Height = 22
            AutoDropDown = True
            AutoCloseUp = True
            Style = csOwnerDrawFixed
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
            Left = 87
            Top = 16
            Width = 215
            Height = 23
            EditLabel.Width = 52
            EditLabel.Height = 15
            EditLabel.Caption = 'Chave Pix'
            TabOrder = 1
          end
          object edtValor: TLabeledEdit
            Left = 0
            Top = 67
            Width = 302
            Height = 23
            EditLabel.Width = 26
            EditLabel.Height = 15
            EditLabel.Caption = 'Valor'
            TabOrder = 2
          end
          object edtIdentificador: TLabeledEdit
            Left = 0
            Top = 119
            Width = 302
            Height = 23
            EditLabel.Width = 239
            EditLabel.Height = 15
            EditLabel.Caption = 'Identificador da Opera'#231'ao (At'#233' 25 Caracteres)'
            MaxLength = 25
            TabOrder = 3
          end
        end
        object tsDinamico: TTabSheet
          Caption = 'Dinamico'
          ImageIndex = 1
          ExplicitHeight = 79
          object lblPixCopiaCola: TLabel
            Left = 0
            Top = 0
            Width = 305
            Height = 15
            Align = alTop
            Caption = 'Pix Copia Cola'
            ExplicitWidth = 77
          end
          object MemoPixCopiaCola: TMemo
            Left = 0
            Top = 15
            Width = 305
            Height = 134
            Align = alClient
            TabOrder = 0
            ExplicitLeft = 64
            ExplicitTop = 8
            ExplicitWidth = 185
            ExplicitHeight = 89
          end
        end
        object tsBrCode: TTabSheet
          Caption = 'BRCode'
          ImageIndex = 2
          ExplicitHeight = 79
          object lblRetornoPix: TLabel
            Left = 0
            Top = 0
            Width = 305
            Height = 15
            Align = alTop
            Caption = 'Retorno Pix'
            ExplicitWidth = 61
          end
          object MemoRetornoPix: TMemo
            Left = 0
            Top = 15
            Width = 305
            Height = 134
            Align = alClient
            TabOrder = 0
            ExplicitLeft = 64
            ExplicitTop = 8
            ExplicitWidth = 185
            ExplicitHeight = 89
          end
        end
      end
    end
  end
  object MemoChaveCopiaCola: TMemo
    Left = 360
    Top = 368
    Width = 361
    Height = 89
    BorderStyle = bsNone
    ReadOnly = True
    TabOrder = 1
  end
end
