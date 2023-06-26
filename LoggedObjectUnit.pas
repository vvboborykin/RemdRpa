{*******************************************************
* Project: RemdRpa.Console
* Unit: LoggedObjectUnit.pas
* Description: объект протоколирующий свои действия в журнале работы приложения
* 
* Created: 23.06.2023 13:55:31
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit LoggedObjectUnit;

interface

uses
  SysUtils, Classes, Variants, StrUtils, DateUtils, LoggerUnit, NullLoggerUnit;

type
  /// <summary>TLoggedObject
  /// объект протоколирующий свои действия в журнале работы приложения
  /// </summary>
  TLoggedObject = class
  private
    FLogger: ILogger;
    procedure SetLogger(const Value: ILogger);
  public
    constructor Create(ALogger: ILogger);
    /// <summary>TLoggedObject.Logger
    /// журнал работы приложения
    /// </summary>
    /// type:ILogger
    property Logger: ILogger read FLogger write SetLogger;
  end;

implementation

constructor TLoggedObject.Create(ALogger: ILogger);
begin
  inherited Create;
  FLogger := ALogger;

  // если передан пустой журнал, то создаём заглушку
  if FLogger = nil then
    FLogger := TNullLogger.Create();
end;

procedure TLoggedObject.SetLogger(const Value: ILogger);
begin
  FLogger := Value;
end;

end.
