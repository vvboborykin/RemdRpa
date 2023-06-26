{*******************************************************
* Project: RemdRpa.Console
* Unit: AppOptionsLoaderUnit.pas
* Description: загрузчик параметров работы приложения
* 
* Created: 23.06.2023 13:51:45
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit AppOptionsLoaderUnit;

interface

uses
  SysUtils, Classes, Variants, StrUtils, DateUtils, AppOptionsUnit,
  RegExpr, NativeXml, uCryptoServ, LoggedObjectUnit,
  CommandLineControllerUnit;

type
  /// <summary>TAppOptionsLoader
  /// загрузчик параметров работы приложения
  /// </summary>
  TAppOptionsLoader = class(TLoggedObject)
  private
    FAppOptions: TAppOptions;
    function DecryptBytesToString(AStream: TStream): String;
    function GetConfigFileNameFromCommandLine: String;
    procedure LoadAppOptionsPropertiesFromXmlDoc(vXmlDoc: TNativeXml);
    procedure LoadFromConfigXmlString(AXmlString: string);
    function ReadConfigFileText(AFileName: string): String;
    function ReadStringFromFileStream(vFileStream: TFileStream): string;
    function ReadXmlInt(vXmlDoc: TNativeXml; AName: string; ADefaultValue:
        Integer): Integer;
    function ReadXmlBool(vXmlDoc: TNativeXml; AName: string; ADefaultValue:
        Boolean): Boolean;
    function ReadXmlString(vXmlDoc: TNativeXml; AName, ADefaultValue: string):
        string;
  public
    /// <summary>TAppOptionsLoader.LoadAppOptions
    /// загрузить параметры работы приложения из файла
    /// </summary>
    /// <param name="AppOptions"> (TAppOptions) объект параметров для заполнения</param>
    /// <param name="AFileName"> (string) имя файла параметров</param>
    procedure LoadAppOptions(AppOptions: TAppOptions; AFileName: string = '');
    /// <summary>TAppOptionsLoader.GetFileName
    /// получить имя файла с параметрами для загрузки
    /// </summary>
    /// <returns> string
    /// </returns>
    function GetFileName: string;
  end;

implementation

uses
  RemdRpaStringsUnit;


function TAppOptionsLoader.DecryptBytesToString(AStream: TStream): String;
begin
  Logger.LogDebug(SAppOptionsDecrypting, []);
  Result := CryptoService.DecryptStreamToString(AStream);
end;

function TAppOptionsLoader.GetConfigFileNameFromCommandLine: String;
var
  I: Integer;
  vFileName: string;
begin
  if TCommandLineController.TryGetValue('config', Result) then
    Logger.LogDebug(SConfigFileNameFoundInCmdParams, [Result])
  else
    Result := '';
end;

function TAppOptionsLoader.GetFileName: string;
var
  I: Integer;
  vFileName: string;
begin
  Logger.LogDebug(SGettingConfigFileName, []);
  Result := GetConfigFileNameFromCommandLine();
  if Result = '' then
  begin
    vFileName := 'RemdRpa.config';
    Result := vFileName + '.xml';
    if not FileExists(Result) then
      Result := vFileName + '.dat';
  end;
end;

procedure TAppOptionsLoader.LoadAppOptions(AppOptions: TAppOptions; AFileName:
    string = '');
begin
  if AppOptions = nil then
    raise Exception.Create(SAppOptionsIsNil);

  FAppOptions := AppOptions;

  if AFileName = '' then
    AFileName := GetFileName();

  Logger.LogDebug(SAppOptionsLoadingFromFile, [AFileName]);

  if FileExists(AFileName) then
    LoadFromConfigXmlString(ReadConfigFileText(AFileName))
  else
    raise Exception.CreateFmt(SConfigFileNotFound, [AFileName]);
end;

procedure TAppOptionsLoader.LoadAppOptionsPropertiesFromXmlDoc(vXmlDoc:
    TNativeXml);
begin
  Logger.LogDebug(SReadAppOptionsFromXmlDoc, []);


  FAppOptions.LoadTimeoutSec := ReadXmlInt(vXmlDoc,
    'LoadTimeoutSec', FAppOptions.LoadTimeoutSec);

  FAppOptions.LoginName := ReadXmlString(vXmlDoc,
    'LoginName', FAppOptions.LoginName);

  FAppOptions.LoginTimeoutSec := ReadXmlInt(vXmlDoc,
    'LoginTimeoutSec', FAppOptions.LoginTimeoutSec);

  FAppOptions.Password := ReadXmlString(vXmlDoc,
    'Password', FAppOptions.Password);

  FAppOptions.RemdExeFileName := ReadXmlString(vXmlDoc,
    'RemdExeFileName', FAppOptions.RemdExeFileName);

  FAppOptions.RemdStartParams := ReadXmlString(vXmlDoc,
    'RemdStartParams', FAppOptions.RemdStartParams);

  FAppOptions.SendEnabled := ReadXmlBool(vXmlDoc,
    'SendEnabled', FAppOptions.SendEnabled);

  FAppOptions.SendTimeoutSec := ReadXmlInt(vXmlDoc,
    'SendTimeoutSec', FAppOptions.SendTimeoutSec);

  FAppOptions.SignEnabled := ReadXmlBool(vXmlDoc,
    'SignEnabled', FAppOptions.SignEnabled);

  FAppOptions.SignTimeoutSec := ReadXmlInt(vXmlDoc,
    'SignTimeoutSec', FAppOptions.SignTimeoutSec);
end;

procedure TAppOptionsLoader.LoadFromConfigXmlString(AXmlString: string);
var
  vStream: TMemoryStream;
  vXmlDoc: TNativeXml;
begin
  Logger.LogDebug(SLoadingAppOptionsFromXmlString, [AXmlString]);

  vStream := TMemoryStream.Create();
  vXmlDoc := TNativeXml.Create(nil);
  try
    vStream.Write(PChar(AXmlString)^, Length(AXmlString));
    vStream.Seek(0, 0);
    vXmlDoc.LoadFromStream(vStream);

    LoadAppOptionsPropertiesFromXmlDoc(vXmlDoc);

  finally
    vXmlDoc.Free;
    vStream.Free;
  end;
end;

function TAppOptionsLoader.ReadConfigFileText(AFileName: string): String;
var
  vFileStream: TFileStream;
begin
  Logger.LogDebug(SReadingAppOptionsFromFile, [AFileName]);

  Result := '';
  vFileStream := TFileStream.Create(AFileName, fmOpenRead + fmShareDenyNone);
  try
    if AnsiSameText(ExtractFileExt(AFileName), '.xml') then
      Result := ReadStringFromFileStream(vFileStream)
    else
      Result := DecryptBytesToString(vFileStream);
  finally
    vFileStream.Free;
  end;
end;

function TAppOptionsLoader.ReadStringFromFileStream(vFileStream: TFileStream):
    string;
var
  vString: String;
begin
  with vFileStream do
  begin
    SetLength(vString, Size);
    Read(PChar(vString)^, Size);
    Result := Trim(vString);
  end;
end;

function TAppOptionsLoader.ReadXmlInt(vXmlDoc: TNativeXml; AName: string;
    ADefaultValue: Integer): Integer;
var
  vNode: TXmlNode;
  vString: string;
begin
  Result := ADefaultValue;
  vNode := vXmlDoc.Root.FindNode(AName);
  if (vNode <> nil) and (vNode is TsdElement) then
  begin
    vString := (vNode as TsdElement).Value;
    TryStrToInt(vString, Result);
  end;
end;

function TAppOptionsLoader.ReadXmlBool(vXmlDoc: TNativeXml; AName: string;
    ADefaultValue: Boolean): Boolean;
var
  vNode: TXmlNode;
  vString: string;
begin
  Result := ADefaultValue;
  vNode := vXmlDoc.Root.FindNode(AName);
  if (vNode <> nil) and (vNode is TsdElement) then
  begin
    vString := (vNode as TsdElement).Value;
    TryStrToBool(vString, Result);
  end;
end;

function TAppOptionsLoader.ReadXmlString(vXmlDoc: TNativeXml; AName,
    ADefaultValue: string): string;
var
  vNode: TXmlNode;
  vString: string;
begin
  Result := ADefaultValue;
  vNode := vXmlDoc.Root.FindNode(AName);
  if (vNode <> nil) and (vNode is TsdElement) then
    Result := (vNode as TsdElement).Value;
end;

end.
