unit TextFileLoggerUnit;

interface

uses
  SysUtils, Classes, Variants, StrUtils, DateUtils, LoggerUnit, SyncObjs,
  RegExpr, CommandLineControllerUnit;

type
  TTextFileLogger = class(TInterfacedObject, ILogger)
  private
    FFileName: String;
    FLock: TCriticalSection;
    FSeverity: TLogRecordType;
    procedure AddLogRecord(ARecordType: TLogRecordType; AText: string; AParams:
        array of const); stdcall;
    procedure EnsureForLogDir(AFileName: String);
    function GetDefaultFileName: String;
    function GetDefaultSeverity: TLogRecordType;
    procedure LogDebug(AText: string; AParams: array of const); stdcall;
    procedure LogError(AText: string; AParams: array of const); stdcall;
    procedure LogInfo(AText: string; AParams: array of const); stdcall;
    procedure LogWarning(AText: string; AParams: array of const); stdcall;
    procedure SetFileName(const Value: String);
    procedure SetSeverity(const Value: TLogRecordType);
    property FileName: String read FFileName write SetFileName;
  public
    constructor Create(AFileName: String = '');
    destructor Destroy; override;
    property Severity: TLogRecordType read FSeverity write SetSeverity;
  end;

implementation

constructor TTextFileLogger.Create(AFileName: String = '');
begin
  inherited Create;
  FLock := TCriticalSection.Create();
  FSeverity := GetDefaultSeverity();
  FFileName := AFileName;
  if FFileName = '' then
    FFileName := GetDefaultFileName();
end;

destructor TTextFileLogger.Destroy;
begin
  FreeAndNil(FLock);
  inherited Destroy;
end;

procedure TTextFileLogger.AddLogRecord(ARecordType: TLogRecordType; AText:
    string; AParams: array of const);
var
  vRecordText: string;
  vTypeName: string;
  vFile: Text;
  vFileName: string;
begin
  if ARecordType >= FSeverity then
  begin
    FLock.Enter;
    try
      vTypeName := LogRecordTypeNames[ARecordType];

      vRecordText := Format('%s'#9'%s'#9'%s',
        [DateTimeToStr(Now), vTypeName, Format(AText, AParams)]);

      vFileName := ExtractFilePath(FileName) +
        FormatDateTime('yyyy-mm-dd_', Now) + ExtractFileName(FileName);

      EnsureForLogDir(vFileName);
      AssignFile(vFile, vFileName);
      
      if FileExists(vFileName) then
        Append(vFile)
      else
        Rewrite(vFile);

      WriteLn(vFile, vRecordText);
      Closefile(vFile);
    finally
      FLock.Leave;
    end;
  end;
end;

procedure TTextFileLogger.EnsureForLogDir(AFileName: String);
var
  vLogDir: string;
begin
  vLogDir := ExtractFilePath(AFileName);
  if not DirectoryExists(vLogDir) then
    ForceDirectories(vLogDir);
end;

function TTextFileLogger.GetDefaultFileName: String;
var
  vFileName: string;
  vLogDir: string;
begin
  vLogDir := ExtractFilePath(ParamStr(0)) + 'Logs\';
  Result := vLogDir + ExtractFileName(ParamStr(0)) + '.log';
  vFileName := '';
  if TCommandLineController.TryGetValue('LogFileName', vFileName) then
    Result := vFileName;
end;

function TTextFileLogger.GetDefaultSeverity: TLogRecordType;
var
  vIndex: Integer;
  vText: string;
begin
  Result := lrtInfo;
  if TCommandLineController.TryGetValue('LogLevel', vText) then
  begin
    vIndex := AnsiIndexText(vText, LogRecordTypeNames);
    if vIndex >= 0 then
      Result := TLogRecordType(vIndex);
  end;
end;

procedure TTextFileLogger.LogDebug(AText: string; AParams: array of const);
begin
  AddLogRecord(lrtDebug, AText, AParams);
end;

procedure TTextFileLogger.LogError(AText: string; AParams: array of const);
begin
  AddLogRecord(lrtError, AText, AParams);
end;

procedure TTextFileLogger.LogInfo(AText: string; AParams: array of const);
begin
  AddLogRecord(lrtInfo, AText, AParams);
end;

procedure TTextFileLogger.LogWarning(AText: string; AParams: array of const);
begin
  AddLogRecord(lrtWarning, AText, AParams);
end;

procedure TTextFileLogger.SetFileName(const Value: String);
begin
  FFileName := Value;
end;

procedure TTextFileLogger.SetSeverity(const Value: TLogRecordType);
begin
  FSeverity := Value;
end;

end.
