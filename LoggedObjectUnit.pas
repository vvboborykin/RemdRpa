{*******************************************************
* Project: RemdRpa.Console
* Unit: LoggedObjectUnit.pas
* Description: ������ ��������������� ���� �������� � ������� ������ ����������
* 
* Created: 23.06.2023 13:55:31
* Copyright (C) 2023 ��������� �.�. (bpost@yandex.ru)
*******************************************************}
unit LoggedObjectUnit;

interface

uses
  SysUtils, Classes, Variants, StrUtils, DateUtils, LoggerUnit, NullLoggerUnit;

type
  /// <summary>TLoggedObject
  /// ������ ��������������� ���� �������� � ������� ������ ����������
  /// </summary>
  TLoggedObject = class
  private
    FLogger: ILogger;
    procedure SetLogger(const Value: ILogger);
  public
    constructor Create(ALogger: ILogger);
    /// <summary>TLoggedObject.Logger
    /// ������ ������ ����������
    /// </summary>
    /// type:ILogger
    property Logger: ILogger read FLogger write SetLogger;
  end;

implementation

constructor TLoggedObject.Create(ALogger: ILogger);
begin
  inherited Create;
  FLogger := ALogger;

  // ���� ������� ������ ������, �� ������ ��������
  if FLogger = nil then
    FLogger := TNullLogger.Create();
end;

procedure TLoggedObject.SetLogger(const Value: ILogger);
begin
  FLogger := Value;
end;

end.
