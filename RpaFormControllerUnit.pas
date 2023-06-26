unit RpaFormControllerUnit;

interface

uses
  SysUtils, Classes, Variants, StrUtils, DateUtils, Windows,
  RpaWindowsUtilsUnit, LoggedObjectUnit, LoggerUnit, AppOptionsUnit;

type
  TRpaFormController = class(TLoggedObject)
  private
    FAppOptions: TAppOptions;
    FProcessController: TProcessWindowController;
    FFormHandler: HWND;
    FWaitForIdleTime: Integer;
    procedure SetAppOptions(const Value: TAppOptions);
    procedure SetFormHandler(const Value: HWND);
    procedure SetWaitForIdleTime(const Value: Integer);
  protected
    function FindChildAndRiseOnError(AClassName, AText, AExceptionMessage: string):
        HWND;
    function FindAndCloseErrorWindow(AParent: HWND; ATimeOut: Integer): Boolean;
    procedure WaitProcess(ATimeOut: Integer);
    function ButtonEnabled(AButtonHandler: HWND): Boolean;
    procedure WaitForIdleForm(ATimeout: Integer = 0);
  public
    constructor Create(ALogger: ILogger; APrc: TProcessWindowController;
        AAppOptions: TAppOptions; AFormHandler: HWND = 0);
    property AppOptions: TAppOptions read FAppOptions write SetAppOptions;
    property FormHandler: HWND read FFormHandler write SetFormHandler;
    property ProcessController: TProcessWindowController read FProcessController;
    property WaitForIdleTime: Integer read FWaitForIdleTime write
        SetWaitForIdleTime;
  end;

const
  SOkButtonText = 'ОК';
  SOkButtonClass = 'Button';
  SErrorDialogCaption = 'Ошибка';
  STEdit = 'TEdit';
  STButton = 'TButton';
  STComboBox = 'TComboBox';
  SDialogEditControlClass = 'Text'; 

implementation


constructor TRpaFormController.Create(ALogger: ILogger; APrc:
    TProcessWindowController; AAppOptions: TAppOptions; AFormHandler: HWND = 0);
begin
  inherited Create(ALogger);
  FFormHandler := AFormHandler;
  FProcessController := APrc;
  FWaitForIdleTime := 5000;
  FAppOptions := AAppOptions;
end;

function TRpaFormController.ButtonEnabled(AButtonHandler: HWND): Boolean;
begin
  Result := IsWindowEnabled(AButtonHandler)
end;

function TRpaFormController.FindChildAndRiseOnError(AClassName, AText,
    AExceptionMessage: string): HWND;
begin
  Result := ProcessController.FindChildWindow(FFormHandler, AClassName, AText);
  if Result = 0 then
    raise Exception.Create(AExceptionMessage);
end;

function TRpaFormController.FindAndCloseErrorWindow(AParent: HWND; ATimeOut:
    Integer): Boolean;
var
  vErrorHandle: HWnd;
  vOkHandle: HWND;
begin
  vErrorHandle := FindWindow(nil, PChar(SErrorDialogCaption));
  Result := vErrorHandle <> 0;
  if Result then
  begin
    // ОК русскими
    vOkHandle := ProcessController.FindChildWindow(vErrorHandle,
      SOkButtonClass, SOkButtonText);
    ProcessController.PostClickButton(vOkHandle);
    Sleep(100);
  end;
end;

procedure TRpaFormController.SetAppOptions(const Value: TAppOptions);
begin
  FAppOptions := Value;
end;

procedure TRpaFormController.SetFormHandler(const Value: HWND);
begin
  FFormHandler := Value;
end;

procedure TRpaFormController.SetWaitForIdleTime(const Value: Integer);
begin
  FWaitForIdleTime := Value;
end;

procedure TRpaFormController.WaitForIdleForm(ATimeout: Integer = 0);
begin
  if ATimeout = 0 then
    ATimeout := WaitForIdleTime;
  WaitProcess(ATimeout);
end;

procedure TRpaFormController.WaitProcess(ATimeOut: Integer);
begin
  Sleep(100);
  ProcessController.WaitForIdleProcess(ATimeOut);
end;

end.
