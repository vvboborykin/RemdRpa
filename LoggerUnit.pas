{*******************************************************
* Project: RemdRpa.Console
* Unit: LoggerUnit.pas
* Description: журнал работы приложения
* 
* Created: 23.06.2023 13:56:58
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit LoggerUnit;

interface

uses
  SysUtils, Classes, Variants, StrUtils, DateUtils;

type
  // тип записи журнала
  TLogRecordType = (lrtDebug, lrtInfo, lrtWarning, lrtError);

  /// <summary>ILogger
  /// журнал работы приложения
  /// </summary>
  ILogger = interface
  ['{873A3689-1AAA-4632-8840-49C61E83182A}']
    /// <summary>ILogger.AddLogRecord
    /// Добавить запись протокола в журнал работы приложения
    /// </summary>
    /// <param name="ARecordType"> (TLogRecordType) тип записи</param>
    /// <param name="AText"> (string) шаблон содержимого</param>
    /// <param name="AParams"> (array of const) параметры</param>
    procedure AddLogRecord(ARecordType: TLogRecordType; AText: string; AParams: array of const); stdcall;
    /// <summary>ILogger.LogDebug
    /// Добавить отладочную запись в журнал
    /// </summary>
    /// <param name="AText"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure LogDebug(AText: string; AParams: array of const); stdcall;
    /// <summary>ILogger.LogInfo
    /// Добавить информационную запись в журнал
    /// </summary>
    /// <param name="AText"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure LogInfo(AText: string; AParams: array of const); stdcall;
    /// <summary>ILogger.LogWarning
    /// Добавить запись к предупреждением журнал
    /// </summary>
    /// <param name="AText"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure LogWarning(AText: string; AParams: array of const); stdcall;
    /// <summary>ILogger.LogError
    /// Добавить запись об ошибке в журнал
    /// </summary>
    /// <param name="AText"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure LogError(AText: string; AParams: array of const); stdcall;
  end;

const
  LogRecordTypeNames: array [Low(TLogRecordType) .. High(TLogRecordType)] of string =
    ('Отладка', 'Информация', 'Предупреждение', 'ОШИБКА');

implementation

end.
