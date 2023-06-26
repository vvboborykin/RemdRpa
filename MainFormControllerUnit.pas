{*******************************************************
* Project: RemdRpa.Console
* Unit: MainFormControllerUnit.pas
* Description: контроллер для работы с главной формой РЭМД
*
* Created: 23.06.2023 14:00:41
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit MainFormControllerUnit;

interface

uses
  SysUtils, Classes, Variants, StrUtils, DateUtils, Windows,
  RpaFormControllerUnit, RpaWindowsUtilsUnit,
  LoggerUnit, AppOptionsUnit;

type
  /// <summary>TMainFormController
  /// контроллер для работы с главной формой РЭМД
  /// </summary>
  TMainFormController = class(TRpaFormController)
  private
    FMainFormWindowTimeout: Integer;
    FSendAllButton: HWND;
    FSignAllButton: HWND;
    procedure ClickSendAllButton;
    procedure ClickSignAllButton;
    procedure DoSend;
    procedure DoSign;
    procedure EnterCryptoContainerPassword;
    procedure FindSendAllButton;
    procedure FindSignAllButton;
    procedure PressRefreshButton;
    procedure SelectMainFormSendMode;
    procedure SelectMainFormMode(AMode, ATimeout: Integer);
    procedure SelectMainFormSignMode;
    function SendAllButtonEnabled: Boolean;
    procedure SetMainFormWindowTimeout(const Value: Integer);
    function SignAllButtonEnabled: Boolean;
    procedure WaitForIdleMainForm(ATimeout: Integer = 0);
    procedure WaitForMainForm;
  public
    constructor Create(ALogger: ILogger; APrc: TProcessWindowController;
        AppOptions: TAppOptions; AFormHandler: HWND = 0);
    /// <summary>TMainFormController.RunMainForm
    /// подписать и отправить документы
    /// </summary>
    procedure RunMainForm;
    /// <summary>TMainFormController.MainFormWindowTimeout
    /// тайм-аут главной формы по умолчанию
    /// </summary>
    /// type:Integer
    property MainFormWindowTimeout: Integer read FMainFormWindowTimeout write
        SetMainFormWindowTimeout;
  end;

implementation

uses LoggedObjectUnit, RemdRpaStringsUnit;

const
  SRefreshButtonText = 'Обновить';
  SSendAllButtonText = 'Отправить все';
  SSignedForSendToRemd = 'Подписанные (для отправки в РЭМД)';
  SPasswordWindowCaption = 'ПАРОЛЬ';
  SForSing = 'На подпись';
  SSignAllButtonText = 'Подписать все';
  SMainFormCaption = 'ФЕДЕРАЛЬНЫЙ РЕЕСТР ЭЛЕКТРОННЫХ МЕДИЦИНСКИХ ДОКУМЕНТОВ';

constructor TMainFormController.Create(ALogger: ILogger; APrc:
    TProcessWindowController; AppOptions: TAppOptions; AFormHandler: HWND = 0);
begin
  inherited Create(ALogger, APrc, AppOptions, AFormHandler);
  FMainFormWindowTimeout := 120;
end;

procedure TMainFormController.ClickSendAllButton;
begin
  Logger.LogInfo(SSendStarted, []);
  ProcessController.PostClickButton(FSendAllButton);
end;

procedure TMainFormController.ClickSignAllButton;
begin
  Logger.LogInfo(SSingStarted, []);
  ProcessController.PostClickButton(FSignAllButton);
end;

procedure TMainFormController.DoSend;
begin
  FindSendAllButton();
  SelectMainFormSendMode();
  if SendAllButtonEnabled then
  begin
    ClickSendAllButton;
    EnterCryptoContainerPassword();
    WaitForIdleMainForm;
  end;
end;

procedure TMainFormController.DoSign;
begin
  SelectMainFormSignMode();
  FindSignAllButton();
  if SignAllButtonEnabled then
  begin
    ClickSignAllButton;
    EnterCryptoContainerPassword();
    WaitForIdleMainForm;
  end;
end;

procedure TMainFormController.EnterCryptoContainerPassword;
var
  vOkButton: HWND;
  vPasswordDialog: HWND;
  vPasswordEdit: HWND;
begin
  vPasswordDialog := ProcessController.FindChildWindow(FormHandler, '',
    SPasswordWindowCaption);

  if vPasswordDialog <> 0 then
  begin
    vPasswordEdit := ProcessController.FindChildWindow(vPasswordDialog,
      SDialogEditControlClass, '');

    vOkButton := ProcessController.FindChildWindow(vPasswordDialog,
      SOkButtonClass, SOkButtonText);

    ProcessController.SetEditText(vPasswordEdit, AppOptions.SignPassword);
    ProcessController.PostClickButton(vOkButton);

    WaitForIdleMainForm;
  end;
end;

procedure TMainFormController.FindSendAllButton;
begin
  Sleep(1000);
  FSendAllButton := FindChildAndRiseOnError(STButton, SSendAllButtonText,
    Format(SSignAllButtonNotFound, [SSendAllButtonText]));
  WaitForIdleMainForm;
end;

procedure TMainFormController.FindSignAllButton;
begin
  FSignAllButton := FindChildAndRiseOnError(STButton, SSignAllButtonText,
    Format(SSignAllButtonNotFound, [SSignAllButtonText]));
  WaitForIdleMainForm;
end;

procedure TMainFormController.PressRefreshButton;
var
  vBtn: HWND;
begin
  vBtn := FindChildAndRiseOnError(STButton, SRefreshButtonText,
    Format(SRefreshButtonNotFound, [SRefreshButtonText]));
  ProcessController.PostClickButton(vBtn);
end;

procedure TMainFormController.RunMainForm;
begin
  WaitForMainForm();

  if AppOptions.SignEnabled then
    DoSign();

  if AppOptions.SendEnabled then
    DoSend();
end;

procedure TMainFormController.SelectMainFormSendMode;
var
  vModeComboBoxHandle: HWND;
begin
  WaitForIdleMainForm(AppOptions.SendTimeoutSec);

  vModeComboBoxHandle := FindChildAndRiseOnError(STComboBox, '',
    Format(SModeComboBoxNotFoundOnMainForm, []));

  ProcessController.PressKey(vModeComboBoxHandle, VK_DOWN);
  WaitForIdleMainForm(AppOptions.SendTimeoutSec);

  PressRefreshButton();
  WaitForIdleMainForm(AppOptions.SendTimeoutSec);
end;

procedure TMainFormController.SelectMainFormMode(AMode, ATimeout: Integer);
var
  vModeComboBoxHandle: HWND;
begin
  WaitForIdleMainForm(AppOptions.SendTimeoutSec);

  vModeComboBoxHandle := FindChildAndRiseOnError(STComboBox, '',
    Format(SModeComboBoxNotFoundOnMainForm, []));

  ProcessController.SetComboBoxItemIndex(vModeComboBoxHandle, AMode);
  WaitForIdleMainForm(AppOptions.SendTimeoutSec);

  PressRefreshButton();
  WaitForIdleMainForm(AppOptions.SendTimeoutSec);
end;

procedure TMainFormController.SelectMainFormSignMode;
begin
  SelectMainFormMode(0, AppOptions.SignTimeoutSec);
end;

function TMainFormController.SendAllButtonEnabled: Boolean;
begin
  Result := ButtonEnabled(FSendAllButton);
end;

procedure TMainFormController.SetMainFormWindowTimeout(const Value: Integer);
begin
  FMainFormWindowTimeout := Value;
end;

function TMainFormController.SignAllButtonEnabled: Boolean;
begin
  Result := ButtonEnabled(FSignAllButton);
end;

procedure TMainFormController.WaitForIdleMainForm(ATimeout: Integer = 0);
begin
  Sleep(500);
  if ATimeout = 0 then
    ATimeout := WaitForIdleTime;
  ProcessController.WaitForWindowIdle(FormHandler, ATimeout);
end;

procedure TMainFormController.WaitForMainForm;
begin
  WaitForIdleForm;

  FormHandler := ProcessController.WaitForWindow(SMainFormCaption, '',
    MainFormWindowTimeout);

  if FormHandler = 0 then
    raise Exception.CreateFmt(SMainFormNotFound, [SMainFormCaption]);
end;

end.
