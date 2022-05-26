
unit RICK.PixQRCode.Utils;

interface
uses
  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  System.StrUtils;
  {$ELSE} // VCL prior to XE2
  StrUtils;
  {$IFEND}
type
  TRICKPixQrCodeUtils = class
  public
    class function IsValidCPF(Const ACPF: string): Boolean;
    class function IsValidCNPJ(Const ACNPJ : string) : Boolean;
    class function IsValidEmail(const AValue: string): Boolean;
    class function IsValidCaracterEmail(const AValue: string): Boolean;
    class function GetSomenteNumero(const AValue: string): string;
    class function CopyReverse(AValue: String; ACount, AIndex : Integer) : String; overload;
    class function CopyReverse(AValue: String; ACount : Integer) : String; overload;
    class function CopyData(AValue: String; ACount, AIndex : Integer) : String; overload;
    class function CopyData(AValue: String; ACount : Integer) : String; overload;
    class function RemoveAcento(AValue : string) : string; overload;
    class function RemoveAcento(Const AValue : string;
      Const aExtras: boolean) : string; overload;
    class function CRC16CCITT(AValeu: string): WORD;
    class function GerarCRCPix(Const AValue: string) :string;
  end;
implementation

uses
  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
    System.Math,
    System.SysUtils;
  {$ELSE} // VCL prior to XE2
    Math,
    SysUtils;
  {$IFEND}

{ TRICKPixQrCodeUtils }

class function TRICKPixQrCodeUtils.CopyData(AValue: String;
  ACount: Integer): String;
begin
  Result:= CopyData(AValue, ACount, 1);
end;

class function TRICKPixQrCodeUtils.CopyData(AValue: String; ACount,
  AIndex: Integer): String;
begin
  Result:= Copy(AValue, AIndex, ACount);
end;

class function TRICKPixQrCodeUtils.CopyReverse(AValue: String;
  ACount: Integer): String;
begin
  Result:= CopyReverse(AValue, ACount, 1);

end;

class function TRICKPixQrCodeUtils.CRC16CCITT(AValeu: string): WORD;
const
  LPolynomial = $1021;
var
  LCRC: WORD;
  I, J: Integer;
  LByte: Byte;
  LBit, LC15: Boolean;
begin
  LCRC := $FFFF;
  for I := 1 to length(AValeu) do
  begin
    LByte := Byte(AValeu[I]);
    for J := 0 to 7 do
    begin
      LBit := (((LByte shr (7 - J)) and 1) = 1);
      LC15 := (((LCRC shr 15) and 1) = 1);
      LCRC := LCRC shl 1;
      if (LC15 xor LBit) then
        LCRC := LCRC xor LPolynomial;
    end;
  end;
  Result := LCRC and $FFFF;
end;

class function TRICKPixQrCodeUtils.CopyReverse(AValue: String; ACount,
  AIndex: Integer): String;
begin
  Result := ReverseString(AValue);
  Result := Copy(Result, AIndex, ACount);
  Result := ReverseString(Result);
end;

class function TRICKPixQrCodeUtils.GerarCRCPix(const AValue: string): string;
begin
  Result:= IntToHex(CRC16CCITT(AValue), 4);
end;

class function TRICKPixQrCodeUtils.GetSomenteNumero(const AValue: string): string;
var
  LText : PChar;
begin
  LText := PChar(AValue);
  Result := '';

  while (LText^ <> #0) do
  begin
    {$IFDEF UNICODE}
    if CharInSet(LText^, ['0'..'9']) then
    {$ELSE}
    if LText^ in ['0'..'9'] then
    {$ENDIF}
      Result := Result + LText^;

    Inc(LText);
  end;
end;

class function TRICKPixQrCodeUtils.IsValidCaracterEmail(
  const AValue: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 1 to Length(AValue) do
  {$IF RTLVersion > 19}
    if not (CharInSet(AValue[I], ['a'..'z', 'A'..'Z', '0'..'9', '_', '-', '.'])) then
      Exit;
  {$ELSE}
    if not(AValue[I] in ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '_', '-', '.']) then
      Exit;
  {$IFEND}

  Result := True;
end;

class function TRICKPixQrCodeUtils.IsValidCNPJ(Const ACNPJ : string) : Boolean;
var
  LArrayWord: array[1..2] of Word;
  LArrayByte: array[1..14] of Byte;
  LByte: Byte;
  LCNPJ : string;
begin
  Result := False;

  LCNPJ:= GetSomenteNumero(ACNPJ);


  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  if not (LCNPJ.Length = 14) then
  {$ELSE} // VCL prior to XE2
  if not (Length(LCNPJ) = 14) then
  {$IFEND}
    Exit;

  { Conferindo se todos dígitos são iguais }
  if LCNPJ = StringOfChar('0', 14) then
    Exit;

  if LCNPJ = StringOfChar('1', 14) then
    Exit;

  if LCNPJ = StringOfChar('2', 14) then
    Exit;

  if LCNPJ = StringOfChar('3', 14) then
    Exit;

  if LCNPJ = StringOfChar('4', 14) then
    Exit;

  if LCNPJ = StringOfChar('5', 14) then
    Exit;

  if LCNPJ = StringOfChar('6', 14) then
    Exit;

  if LCNPJ = StringOfChar('7', 14) then
    Exit;

  if LCNPJ = StringOfChar('8', 14) then
    Exit;

  if LCNPJ = StringOfChar('9', 14) then
    Exit;

  try
    for LByte := 1 to 14 do
      LArrayByte[LByte] := StrToInt(LCNPJ[LByte]);

    //Nota: Calcula o primeiro dígito de verificação.
    LArrayWord[1] := 5*LArrayByte[1] + 4*LArrayByte[2]  + 3*LArrayByte[3]  + 2*LArrayByte[4];
    LArrayWord[1] := LArrayWord[1] + 9*LArrayByte[5] + 8*LArrayByte[6]  + 7*LArrayByte[7]  + 6*LArrayByte[8];
    LArrayWord[1] := LArrayWord[1] + 5*LArrayByte[9] + 4*LArrayByte[10] + 3*LArrayByte[11] + 2*LArrayByte[12];
    LArrayWord[1] := 11 - LArrayWord[1] mod 11;
    LArrayWord[1] := IfThen(LArrayWord[1] >= 10, 0, LArrayWord[1]);

    //Nota: Calcula o segundo dígito de verificação.
    LArrayWord[2] := 6*LArrayByte[1] + 5*LArrayByte[2]  + 4*LArrayByte[3]  + 3*LArrayByte[4];
    LArrayWord[2] := LArrayWord[2] + 2*LArrayByte[5] + 9*LArrayByte[6]  + 8*LArrayByte[7]  + 7*LArrayByte[8];
    LArrayWord[2] := LArrayWord[2] + 6*LArrayByte[9] + 5*LArrayByte[10] + 4*LArrayByte[11] + 3*LArrayByte[12];
    LArrayWord[2] := LArrayWord[2] + 2*LArrayWord[1];
    LArrayWord[2] := 11 - LArrayWord[2] mod 11;
    LArrayWord[2] := IfThen(LArrayWord[2] >= 10, 0, LArrayWord[2]);

    //Nota: Verdadeiro se os dígitos de verificação são os esperados.
    Result := ((LArrayWord[1] = LArrayByte[13]) and (LArrayWord[2] = LArrayByte[14]));
  except on E: Exception do
    Result := False;
  end;
end;

class function TRICKPixQrCodeUtils.IsValidCPF(Const ACPF: string): Boolean;
var
  LArrayWord: array [0 .. 1] of Word;
  LArrayByte: array [0 .. 10] of Byte;
  LByte: Byte;
  LCPF: string;
begin
  Result := False;

  LCPF:= GetSomenteNumero(ACPF);

  {$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
  if not (LCPF.Length = 11) then
  {$ELSE} // VCL prior to XE2
  if not (Length(LCPF) = 11) then
  {$IFEND}
    Exit;

  { Conferindo se todos dígitos são iguais }
  if LCPF = StringOfChar('0', 11) then
    Exit;

  if LCPF = StringOfChar('1', 11) then
    Exit;

  if LCPF = StringOfChar('2', 11) then
    Exit;

  if LCPF = StringOfChar('3', 11) then
    Exit;

  if LCPF = StringOfChar('4', 11) then
    Exit;

  if LCPF = StringOfChar('5', 11) then
    Exit;

  if LCPF = StringOfChar('6', 11) then
    Exit;

  if LCPF = StringOfChar('7', 11) then
    Exit;

  if LCPF = StringOfChar('8', 11) then
    Exit;

  if LCPF = StringOfChar('9', 11) then
    Exit;

  try
    for LByte := 1 to 11 do
      LArrayByte[LByte - 1] := StrToInt(LCPF[LByte]);

    // Nota: Calcula o primeiro dígito de verificação.
    LArrayWord[0] := 10 * LArrayByte[0] + 9 * LArrayByte[1] + 8 * LArrayByte[2];
    LArrayWord[0] := LArrayWord[0] + 7 * LArrayByte[3] + 6 * LArrayByte[4] + 5 * LArrayByte[5];
    LArrayWord[0] := LArrayWord[0] + 4 * LArrayByte[6] + 3 * LArrayByte[7] + 2 * LArrayByte[8];
    LArrayWord[0] := 11 - LArrayWord[0] mod 11;
    LArrayWord[0] := IfThen(LArrayWord[0] >= 10, 0, LArrayWord[0]);

    // Nota: Calcula o segundo dígito de verificação.
    LArrayWord[1] := 11 * LArrayByte[0] + 10 * LArrayByte[1] + 9 * LArrayByte[2];
    LArrayWord[1] := LArrayWord[1] + 8 * LArrayByte[3] + 7 * LArrayByte[4] + 6 * LArrayByte[5];
    LArrayWord[1] := LArrayWord[1] + 5 * LArrayByte[6] + 4 * LArrayByte[7] + 3 * LArrayByte[8];
    LArrayWord[1] := LArrayWord[1] + 2 * LArrayWord[0];
    LArrayWord[1] := 11 - LArrayWord[1] mod 11;
    LArrayWord[1] := IfThen(LArrayWord[1] >= 10, 0, LArrayWord[1]);

    // Nota: Verdadeiro se os dígitos de verificação são os esperados.
    Result := ((LArrayWord[0] = LArrayByte[9]) and (LArrayWord[1] = LArrayByte[10]));
  except
    on E: Exception do
      Result := False;
  end;
end;


class function TRICKPixQrCodeUtils.IsValidEmail(const AValue: string): Boolean;
var
  I: Integer;
  LNomeEmail, LNomeDominio: string;
begin
  Result := False;
  I := Pos('@', AValue);
  if I = 0 then
    Exit;
  LNomeEmail := Copy(AValue, 1, I - 1);
  LNomeDominio := Copy(AValue, I + 1, Length(AValue));
  if (Length(LNomeEmail) = 0) or ((Length(LNomeDominio) < 5)) then
    Exit;
  I := Pos('.', LNomeDominio);
  if (I = 0) or (I > (Length(LNomeDominio) - 2)) then
    Exit;
  Result := IsValidCaracterEmail(LNomeEmail) and IsValidCaracterEmail(LNomeDominio);
end;

class function TRICKPixQrCodeUtils.RemoveAcento(Const AValue: string;
  Const aExtras: boolean): string;
const
  //Lista de caracteres especiais
  _ESPECIAL: array[1..38] of String = ('á', 'à', 'ã', 'â', 'ä','Á', 'À', 'Ã', 'Â', 'Ä',
                                     'é', 'è','É', 'È','í', 'ì','Í', 'Ì',
                                     'ó', 'ò', 'ö','õ', 'ô','Ó', 'Ò', 'Ö', 'Õ', 'Ô',
                                     'ú', 'ù', 'ü','Ú','Ù', 'Ü','ç','Ç','ñ','Ñ');
  //Lista de caracteres para troca
  _NORMAL: array[1..38] of String = ('a', 'a', 'a', 'a', 'a','A', 'A', 'A', 'A', 'A',
                                     'e', 'e','E', 'E','i', 'i','I', 'I',
                                     'o', 'o', 'o','o', 'o','O', 'O', 'O', 'O', 'O',
                                     'u', 'u', 'u','u','u', 'u','c','C','n', 'N');
  //Lista de Caracteres Extras
  _EXTRAS: array[1..49] of string = ('<','>','!','@','#','$','%','¨','&','*',
                                     '(',')','_','+','=','{','}','[',']','?',
                                     ';',':',',','|','*','"','~','^','´','`',
                                     '¨','æ','Æ','ø','£','Ø','ƒ','ª','º','¿',
                                     '®','½','¼','ß','µ','þ','ý','Ý', '-');
var
  LTexto : string;
  I : Integer;
begin
   LTexto := AValue;
   for I:=1 to 38 do
     LTexto := StringReplace(LTexto, _ESPECIAL[I], _NORMAL[I], [rfreplaceall]);
   //De acordo com o parâmetro aExtras, elimina caracteres extras.
   if (aExtras) then
     for I:=1 to 49 do
       LTexto := StringReplace(LTexto, _EXTRAS[I], '', [rfreplaceall]);
   Result := LTexto;
end;

class function TRICKPixQrCodeUtils.RemoveAcento(AValue: string): string;
{$IF CompilerVersion >= 23.0} // 23 is Delphi XE2
type
  USAscii20127 = type AnsiString(20127);
begin
  Result := string(USAscii20127(AValue));
end;
{$ELSE} // VCL prior to XE2
const
  ComAcento = 'àâêôûãõáéíóúçüñýÀÂÊÔÛÃÕÁÉÍÓÚÇÜÑÝ';
  SemAcento = 'aaeouaoaeioucunyAAEOUAOAEIOUCUNY';
var
  x: Cardinal;
begin;
  for x := 1 to Length(AValue) do
  try
    if (Pos(AValue[x], ComAcento) <> 0) then
      AValue[x] := SemAcento[ Pos(AValue[x], ComAcento) ];
  except on E: Exception do
    raise Exception.Create('Erro no processo.');
  end;
 
  Result := AValue;
end;
{$IFEND}

end.
