{*******************************************************
* Project: RemdRpa.Console
* Unit: LoggerUnit.pas
* Description: ������ ������ ����������
* 
* Created: 23.06.2023 13:56:58
* Copyright (C) 2023 ��������� �.�. (bpost@yandex.ru)
*******************************************************}
unit LoggerUnit;

interface

uses
  SysUtils, Classes, Variants, StrUtils, DateUtils;

type
  // ��� ������ �������
  TLogRecordType = (lrtDebug, lrtInfo, lrtWarning, lrtError);

  /// <summary>ILogger
  /// ������ ������ ����������
  /// </summary>
  ILogger = interface
  ['{873A3689-1AAA-4632-8840-49C61E83182A}']
    /// <summary>ILogger.AddLogRecord
    /// �������� ������ ��������� � ������ ������ ����������
    /// </summary>
    /// <param name="ARecordType"> (TLogRecordType) ��� ������</param>
    /// <param name="AText"> (string) ������ �����������</param>
    /// <param name="AParams"> (array of const) ���������</param>
    procedure AddLogRecord(ARecordType: TLogRecordType; AText: string; AParams: array of const); stdcall;
    /// <summary>ILogger.LogDebug
    /// �������� ���������� ������ � ������
    /// </summary>
    /// <param name="AText"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure LogDebug(AText: string; AParams: array of const); stdcall;
    /// <summary>ILogger.LogInfo
    /// �������� �������������� ������ � ������
    /// </summary>
    /// <param name="AText"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure LogInfo(AText: string; AParams: array of const); stdcall;
    /// <summary>ILogger.LogWarning
    /// �������� ������ � ��������������� ������
    /// </summary>
    /// <param name="AText"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure LogWarning(AText: string; AParams: array of const); stdcall;
    /// <summary>ILogger.LogError
    /// �������� ������ �� ������ � ������
    /// </summary>
    /// <param name="AText"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure LogError(AText: string; AParams: array of const); stdcall;
  end;

const
  LogRecordTypeNames: array [Low(TLogRecordType) .. High(TLogRecordType)] of string =
    ('�������', '����������', '��������������', '������');

implementation

end.
