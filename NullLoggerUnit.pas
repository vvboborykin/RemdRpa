{*******************************************************
* Project: RemdRpa.EncryptConfig
* Unit: NullLoggerUnit.pas
* Description: "������" ���������� ������� ������ ����������
* 
* Created: 26.06.2023 12:03:37
* Copyright (C) 2023 ��������� �.�. (bpost@yandex.ru)
*******************************************************}
unit NullLoggerUnit;

interface

uses
  SysUtils, Classes, Variants, StrUtils, DateUtils, LoggerUnit;

type
  /// <summary>TNullLogger
  /// "������" ���������� ������� ������ ����������
  /// </summary>
  TNullLogger = class(TInterfacedObject, ILogger)
  private
    procedure AddLogRecord(ARecordType: TLogRecordType; AText: string; AParams:
        array of const); stdcall;
    procedure LogDebug(AText: string; AParams: array of const); stdcall;
    procedure LogError(AText: string; AParams: array of const); stdcall;
    procedure LogInfo(AText: string; AParams: array of const); stdcall;
    procedure LogWarning(AText: string; AParams: array of const); stdcall;
  end;

implementation

procedure TNullLogger.AddLogRecord(ARecordType: TLogRecordType; AText: string;
    AParams: array of const);
begin
end;

procedure TNullLogger.LogDebug(AText: string; AParams: array of const);
begin
end;

procedure TNullLogger.LogError(AText: string; AParams: array of const);
begin
end;

procedure TNullLogger.LogInfo(AText: string; AParams: array of const);
begin
end;

procedure TNullLogger.LogWarning(AText: string; AParams: array of const);
begin
end;

end.
