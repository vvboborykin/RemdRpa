program RemdRpa.EncryptConfig;

{$APPTYPE CONSOLE}

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  SysUtils,
  CommandLineControllerUnit in 'CommandLineControllerUnit.pas',
  AppOptionsLoaderUnit in 'AppOptionsLoaderUnit.pas',
  ConfigEncryptorServiceUnit in 'ConfigEncryptorServiceUnit.pas',
  NullLoggerUnit in 'NullLoggerUnit.pas',
  LoggerUnit in 'LoggerUnit.pas',
  RemdRpaStringsUnit in 'RemdRpaStringsUnit.pas';

var
  vService: TConfigEncryptorService;
begin
  vService := TConfigEncryptorService.Create;
  try
    vService.EncryptConfigFile();
  finally
    vService.Free;
  end;
end.
