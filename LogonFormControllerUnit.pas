{*******************************************************
* Project: RemdRpa.Console
* Unit: LogonFormControllerUnit.pas
* Description: контроллер для работы с формой регистрации РЭМД
*
* Created: 23.06.2023 13:59:00
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit LogonFormControllerUnit;

interface

uses
  SysUtils, Classes, Variants, StrUtils, DateUtils, Windows,
  RpaFormControllerUnit, RpaWindowsUtilsUnit, LoggerUnit,
  AppOptionsUnit;

type
  /// <summary>TLogonFormController
  /// контроллер для работы с формой регистрации РЭМД
  /// </summary>
  TLogonFormController = class(TRpaFormController)
  private
    FFindErrorTime: Integer;
    FLoginName: HWND;
    FOkButton: HWND;
    FPasswordEdit: HWND;
    FSleepAfterOkTime: Integer;
    procedure ClickOkButton;
    procedure FindLoginNameComboBox;
    procedure FindOkButtonOnLogonForm;
    procedure FindPasswordEditOnLogonForm;
    procedure SetFindErrorTime(const Value: Integer);
    procedure SetLoginName(ALoginName: string);
    procedure SetPassword(APassword: string);
    procedure SetSleepAfterOkTime(const Value: Integer);
    procedure WaitForLogonWindow;
  public
    constructor Create(ALogger: ILogger; APrc: TProcessWindowController;
        AppOptions: TAppOptions; AFormHandler: HWND = 0);
    /// <summary>TLogonFormController.DoLogin
    /// войти в РЭМД используя параметры работы приложения
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    function DoLogin: Boolean;
    /// <summary>TLogonFormController.FindErrorTime
    /// время отводимое на поиск сообщения об ошибке
    /// </summary>
    /// type:Integer
    property FindErrorTime: Integer read FFindErrorTime write SetFindErrorTime;
    /// <summary>TLogonFormController.SleepAfterOkTime
    /// время паузы После нажатия на кнопку OK
    /// </summary>
    /// type:Integer
    property SleepAfterOkTime: Integer read FSleepAfterOkTime write
        SetSleepAfterOkTime;
  end;

implementation

uses
  RemdRpaStringsUnit;

const
  SOKButtonText = 'OK';
  SLogonFormClass = 'TfmInputPassw';
  SLogonFormCaption = 'Регистрация';

constructor TLogonFormController.Create(ALogger: ILogger; APrc:
    TProcessWindowController; AppOptions: TAppOptions; AFormHandler: HWND = 0);
begin
  inherited Create(ALogger, APrc, AppOptions, AFormHandler);
  FSleepAfterOkTime := 500;
  FFindErrorTime := 2000;
end;


procedure TLogonFormController.ClickOkButton;
begin
  ProcessController.PostClickButton(FOkButton);
  Sleep(SleepAfterOkTime);
end;

function TLogonFormController.DoLogin: Boolean;
begin
  AppOptions := AppOptions;
  WaitForLogonWindow;
  Result := (FormHandler <> 0);
  if Result then
  begin
    FindLoginNameComboBox;
    FindOkButtonOnLogonForm;
    FindPasswordEditOnLogonForm;
    SetLoginName(AppOptions.LoginName);
    SetPassword(AppOptions.Password);
    ClickOkButton();
    Result := not FindAndCloseErrorWindow(FormHandler, FindErrorTime);
    if Result then
      Logger.LogInfo(SUserLoggedIn, [AppOptions.LoginName])
    else
      Logger.LogError(SLoginError, [AppOptions.LoginName]);
  end;
end;

procedure TLogonFormController.FindLoginNameComboBox;
begin
  FLoginName := FindChildAndRiseOnError(STComboBox, '',
    SUsersComboBoxNotFountOnLoginForm);
end;

procedure TLogonFormController.FindOkButtonOnLogonForm;
begin
  FOkButton := FindChildAndRiseOnError(STButton, SOKButtonText,
    SOkButtonNotFoundOnLoginForm);
end;

procedure TLogonFormController.FindPasswordEditOnLogonForm;
begin
  FPasswordEdit := FindChildAndRiseOnError(STEdit, '',
    SPasswordTextBoxNotFoundOnLogonForm);
end;

procedure TLogonFormController.SetFindErrorTime(const Value: Integer);
begin
  FFindErrorTime := Value;
end;

procedure TLogonFormController.SetLoginName(ALoginName: string);
begin
  ProcessController.SetComboBoxText(FLoginName, ALoginName);
  ProcessController.WaitForWindowIdle(FormHandler, 3000);
end;

procedure TLogonFormController.SetPassword(APassword: string);
begin
  ProcessController.SetEditText(FPasswordEdit, APassword);
  ProcessController.WaitForWindowIdle(FormHandler, 3000);
end;

procedure TLogonFormController.SetSleepAfterOkTime(const Value: Integer);
begin
  FSleepAfterOkTime := Value;
end;

procedure TLogonFormController.WaitForLogonWindow;
begin
  WaitProcess(AppOptions.LoginTimeoutSec);

  FormHandler := ProcessController.WaitForWindow(SLogonFormCaption,
    SLogonFormClass, WaitForIdleTime);

  ProcessController.WaitForWindowIdle(FormHandler, AppOptions.LoginTimeoutSec);
end;

end.
