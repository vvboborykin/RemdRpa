{*******************************************************
* Project: RemdRpa.Console
* Unit: RpaRemdServiceUnit.pas
* Description: главный сервис приложение
* 
* Created: 26.06.2023 11:34:20
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit RpaRemdServiceUnit;

interface

uses
  SysUtils, Classes, Variants, StrUtils, DateUtils, Windows, ShellAPI, RegExpr,
  AppOptionsUnit, RpaWindowsUtilsUnit, LoggedObjectUnit, LoggerUnit;

type
  /// <summary>TRpaRemdService
  /// главный сервис приложение
  /// </summary>
  TRpaRemdService = class(TLoggedObject)
  private
    FAppOptions: TAppOptions;
    FProcessInfor: TProcessInformation;
    FPrc: TProcessWindowController;
    function DoLogin: Boolean;
    procedure ExecuteMainForm;
    procedure FinishRemdProcess;
    procedure LoadAppOptions;
    function StartRemdProcess: Boolean;
  public
    constructor Create(ALogger: ILogger);
    destructor Destroy; override;
    /// <summary>TRpaRemdService.Execute
    /// выполнить цикл подписывания и отправки документов H"VL
    /// </summary>
    procedure Execute;
  end;

implementation

uses
  AppOptionsLoaderUnit, RemdRpaStringsUnit, LogonFormControllerUnit,
  MainFormControllerUnit;


constructor TRpaRemdService.Create(ALogger: ILogger);
begin
  inherited Create(ALogger);
  FAppOptions := TAppOptions.Create();
end;

destructor TRpaRemdService.Destroy;
begin
  FreeAndNil(FAppOptions);
  inherited Destroy;
end;

function TRpaRemdService.DoLogin: Boolean;
var
  vLogonFormController: TLogonFormController;
begin
  Logger.LogInfo(SUserLoginTry, [FAppOptions.LoginName]);
  vLogonFormController := TLogonFormController.Create(Logger, FPrc, FAppOptions);
  try
    Result := vLogonFormController.DoLogin();
  finally
    vLogonFormController.Free;
  end;
end;

procedure TRpaRemdService.Execute;
begin
  Logger.LogInfo(StringOfChar('-', 80), []);
  LoadAppOptions();
  if StartRemdProcess() then
  begin
    try
      if DoLogin() then
        ExecuteMainForm();
    finally
      FinishRemdProcess();
      Logger.LogInfo(SAppExit, []);
    end;
  end;
end;

procedure TRpaRemdService.ExecuteMainForm;
var
  vMainFormController: TMainFormController;
begin
  vMainFormController := TMainFormController.Create(Logger, FPrc, FAppOptions);
  try
    vMainFormController.RunMainForm();
  finally
    vMainFormController.Free;
  end;
end;

procedure TRpaRemdService.FinishRemdProcess;
begin
  if FProcessInfor.hProcess > 0 then
  begin
    TerminateProcess(FProcessInfor.hProcess, 0);
    FPrc.Free;
  end;
end;

procedure TRpaRemdService.LoadAppOptions;
var
  vLoader: TAppOptionsLoader;
begin
  vLoader := TAppOptionsLoader.Create(Logger);
  try
    vLoader.LoadAppOptions(FAppOptions);
  finally
    vLoader.Free;
  end;
end;

function TRpaRemdService.StartRemdProcess: Boolean;
var
  lpStartupInfo: TStartupInfo;
begin
  Logger.LogDebug(SRemdLaunch,
    [FAppOptions.RemdExeFileName, FAppOptions.RemdStartParams]);

  ZeroMemory(@lpStartupInfo, SizeOf(TStartupInfo));
  lpStartupInfo.cb := SizeOf(TStartupInfo);

  Result := CreateProcess(PAnsiChar(FAppOptions.RemdExeFileName),
    PAnsiChar(FAppOptions.RemdStartParams),
    nil, nil, False, 0, nil, nil, lpStartupInfo, FProcessInfor);

  if not Result then
    RaiseLastOSError();

  FPrc := TProcessWindowController.Create(FProcessInfor);

  Logger.LogDebug(SRemdStarted, []);
end;


end.

