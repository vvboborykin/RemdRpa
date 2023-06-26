program RemdRpa.Console;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  AppOptionsUnit in 'AppOptionsUnit.pas',
  AppOptionsLoaderUnit in 'AppOptionsLoaderUnit.pas',
  RpaRemdServiceUnit in 'RpaRemdServiceUnit.pas',
  RpaWindowsUtilsUnit in 'RpaWindowsUtilsUnit.pas',
  RemdRpaStringsUnit in 'RemdRpaStringsUnit.pas',
  LogonFormControllerUnit in 'LogonFormControllerUnit.pas',
  RpaFormControllerUnit in 'RpaFormControllerUnit.pas',
  MainFormControllerUnit in 'MainFormControllerUnit.pas',
  LoggerUnit in 'LoggerUnit.pas',
  TextFileLoggerUnit in 'TextFileLoggerUnit.pas',
  LoggedObjectUnit in 'LoggedObjectUnit.pas',
  CommandLineControllerUnit in 'CommandLineControllerUnit.pas',
  NullLoggerUnit in 'NullLoggerUnit.pas';

var
  vLogger: ILogger;
begin
  vLogger := TTextFileLogger.Create();
  with TRpaRemdService.Create(vLogger) do
  begin
    try
      Execute();
    except
      on E: Exception do
        vLogger.LogError('Œÿ»¡ ¿: %s', [E.Message]);
    end;
    Free;
  end;
end.
