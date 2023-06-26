unit ConfigEncryptorServiceUnit;

interface

uses
  SysUtils, Classes, Variants, StrUtils, DateUtils,
  AppOptionsUnit, uCryptoServ;

type
  /// <summary>TConfigEncryptorService
  /// Сервис шифрования файла конфигурации
  /// </summary>
  TConfigEncryptorService = class
  private
    /// <summary>TConfigEncryptorService.GetXmlFileName
    /// Получить имя XML файла конфигурации
    /// </summary>
    /// <returns> string
    /// </returns>
    function GetXmlFileName: string;
  public
    /// <summary>TConfigEncryptorService.EncryptConfigFile
    /// Зашифровать файл XML конфигурации
    /// </summary>
    /// <param name="AFileName"> (String) </param>
    procedure EncryptConfigFile(AFileName: String = '');
  end;

implementation

uses
  AppOptionsLoaderUnit, RemdRpaStringsUnit;

procedure TConfigEncryptorService.EncryptConfigFile(AFileName: String = '');
var
  vEncryptedFileName: string;
  vExt: string;
  vFileName: string;
begin
  vFileName := GetXmlFileName;
  if FileExists(vFileName) then
  begin
    vExt := ExtractFileExt(vFileName);
    if AnsiSameText(vExt, '.xml') then
    begin
      vEncryptedFileName := StringReplace(vFileName, '.xml', '.dat',
        [rfIgnoreCase]);

      Writeln(Format(SEncryptingFileToFile,
        [vFileName, vEncryptedFileName]));

      CryptoService.EncryptFile(vFileName, vEncryptedFileName, '');

      Writeln(Format(SEncryptionCompleted, []));
    end
    else
      Writeln(Format(SFileShoundHaveXMLExtension, [vFileName]));
  end
  else
    Writeln(Format(SFileIsNotFound, [vFileName]));
end;

function TConfigEncryptorService.GetXmlFileName: string;
var
  vFileName: string;
  vOptionsLoader: TAppOptionsLoader;
begin
  vOptionsLoader := TAppOptionsLoader.Create(nil);
  try
    vFileName := vOptionsLoader.GetFileName();
  finally
    vOptionsLoader.Free;
  end;
  Result := vFileName;
end;

end.
