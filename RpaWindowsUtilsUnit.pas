{*******************************************************
* Project: RemdRpa.Console
* Unit: RpaWindowsUtilsUnit.pas
* Description: утилита работы с окнами Windows через Win32 API
* 
* Created: 26.06.2023 11:32:52
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit RpaWindowsUtilsUnit;

interface

uses
  SysUtils, Classes, Variants, StrUtils, DateUtils, Windows, RegExpr;

type
  /// <summary>TProcessWindowController
  /// утилита работы с окнами Windows через Win32 API
  /// </summary>
  TProcessWindowController = class
  private
    FProcessInfo: TProcessInformation;
    function FindMainWindow: DWORD;
    function GetWindowClassString(AHandle: HWND): string;
    function GetWindowTextString(AHandle: HWND): string;
    function StringMatches(AExpr: String; AInput: String): Boolean;
  public
    constructor Create(AProcessInfo: TProcessInformation);
    /// <summary>TProcessWindowController.ButtonEnabled
    /// определить находится ли заданная кнопка в активном состоянии
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    /// <param name="hButton"> (HWND) кнопка</param>
    function ButtonEnabled(hButton: HWND): Boolean;
    /// <summary>TProcessWindowController.ClickButton
    /// имитировать щелчок мыши по кнопке
    /// </summary>
    /// <param name="hButton"> (HWND) кнопка</param>
    procedure ClickButton(hButton: HWND);
    /// <summary>TProcessWindowController.FindChildWindow
    /// найти дочернюю окно
    /// </summary>
    /// <returns> HWnd
    /// </returns>
    /// <param name="hwndParent"> (HWnd) Родительское окно</param>
    /// <param name="AClassName"> (string) имя класса искомого окна или пустая
    /// строка</param>
    /// <param name="AText"> (string) текст искомого окна или пустая строка</param>
    function FindChildWindow(hwndParent: HWnd; AClassName, AText: string): HWnd;
    /// <summary>TProcessWindowController.FindChildWindowWithTimeOut
    /// найти дочернее окно за заданный интервал времени
    /// </summary>
    /// <returns> HWnd
    /// </returns>
    /// <param name="hwndParent"> (HWnd) Родительское окно</param>
    /// <param name="AClassName"> (string) имя класса или пустая строка</param>
    /// <param name="AText"> (string) текст или пустая строка</param>
    /// <param name="ATimeOut"> (Integer) интервал времени в секундах в течение
    /// которого надо проводить поиск</param>
    function FindChildWindowWithTimeOut(hwndParent: HWnd; AClassName, AText:string;
        ATimeOut: Integer): HWnd;
    /// <summary>TProcessWindowController.PostClickButton
    /// имитировать щелчок мышью по кнопке с постановкой сообщения в очередь
    /// </summary>
    /// <param name="hButton"> (HWND) кнопка</param>
    procedure PostClickButton(hButton: HWND);
    /// <summary>TProcessWindowController.PressKey
    /// имитировать нажатие клавиши клавиатуры
    /// </summary>
    /// <param name="hWindow"> (HWND) Control который можно вводить нажатие
    /// клавиши</param>
    /// <param name="AKey"> (Cardinal) под клавиши</param>
    procedure PressKey(hWindow: HWND; AKey: Cardinal);
    /// <summary>TProcessWindowController.SetComboBoxText
    /// установить текст в раскрывающемся списке
    /// </summary>
    /// <param name="hComboBox"> (HWND) раскрывающийся список</param>
    /// <param name="AText"> (String) текст который надо установить</param>
    procedure SetComboBoxText(hComboBox: HWND; AText: String);
    /// <summary>TProcessWindowController.SetComboBoxItemIndex
    /// выбрать элемент раскрывающегося списка по его номеру
    /// </summary>
    /// <param name="hComboBox"> (HWND) раскрывающийся список</param>
    /// <param name="AItemIndex"> (Integer) номер выбираемого элемента</param>
    procedure SetComboBoxItemIndex(hComboBox: HWND; AItemIndex: Integer);
    /// <summary>TProcessWindowController.SetEditText
    /// установить текст в поле ввода
    /// </summary>
    /// <param name="hEdit"> (HWND) поле ввода</param>
    /// <param name="AText"> (String) устанавливаемый текст</param>
    procedure SetEditText(hEdit: HWND; AText: String);
    /// <summary>TProcessWindowController.WaitForIdleProcess
    /// подождать пока процесс не перейдёт в состояние ожидания ввода
    /// </summary>
    /// <param name="ATimeOut"> (Integer) время в секундах которые необходимо
    /// подождать</param>
    procedure WaitForIdleProcess(ATimeOut: Integer);
    /// <summary>TProcessWindowController.WaitForWindow
    /// подождать появление окна верхнего уровня с заданными параметрами
    /// </summary>
    /// <returns> HWND
    /// найденную окно или ноль если окно не найдено
    /// </returns>
    /// <param name="AText"> (string) текст окна</param>
    /// <param name="AClassName"> (string) класс окна</param>
    /// <param name="ATimeOut"> (Integer) время в секундах которые необходимо
    /// подождать</param>
    function WaitForWindow(AText, AClassName: string; ATimeOut: Integer): HWND;
    /// <summary>TProcessWindowController.WaitForWindowIdle
    /// подождать пока окно не перейдёт в состояние ожидания ввода
    /// </summary>
    /// <returns> Boolean
    /// True если окно перешло в состояние ввода до истечения заданного времени,
    /// False если за заданное время окно не перешло в состояние ожидания ввода
    /// </returns>
    /// <param name="hWindow"> (HWND) окно</param>
    /// <param name="ATimeout"> (Integer) Время ожидания</param>
    function WaitForWindowIdle(hWindow: HWND; ATimeout: Integer): Boolean;
  end;

implementation

uses
  RemdRpaStringsUnit, StdCtrls;

const
  CB_SETCURSEL = $014e;
  CB_SHOWDROPDOWN = $014f;
  WM_KEYDOWN = $0100;
  WM_KEYUP = $0101;
  WM_NULL = 0;
  SMTO_ABORTIFHUNG = $0002;
  WM_SETTEXT = $000C;
  CB_SELECTSTRING = $014d;
  BM_CLICK = $F5;



type
  PClassAndText =^ TClassAndText;

  TClassAndText = record
    AClassName: string;
    AText: String;
    AResult: HWND;
    AController: TProcessWindowController;
  end;

  PEnumInfo = ^TEnumInfo;

  TEnumInfo = record
    ProcessID: DWORD;
    HWND: THandle;
    AController: TProcessWindowController;
  end;

function EnumWindowsForFindChildWindowProc(WHandle: HWND;
   var vParam: TClassAndText): BOOL; stdcall;
var
  sCurrClassName: string;
  bResult: Boolean;
  sCurrText: string;
begin
  sCurrClassName := vParam.AController.GetWindowClassString(WHandle);
  sCurrText := vParam.AController.GetWindowTextString(WHandle);

  bResult := vParam.AController.StringMatches(vParam.AClassName, sCurrClassName)
    and vParam.AController.StringMatches(vParam.AText, sCurrText);

  Result := True;

  If (bResult) then
  begin
    vParam.AResult := WHandle;
    Result := False;
  end
  else
  begin
    vParam.AResult := vParam.AController.FindChildWindow(WHandle,
      vParam.AClassName, vParam.AText);
      
    if vParam.AResult > 0 then
      Result := False;
  end;
end;

function EnumWindowsProc(Wnd: DWORD; var EI: TEnumInfo): Bool; stdcall;
var
  PID: DWORD;
begin
  GetWindowThreadProcessID(Wnd, @PID);
  Result := (PID <> EI.ProcessID) or (not IsWindowVisible(Wnd)) or (not
    IsWindowEnabled(Wnd));

  if not Result then
    EI.HWND := Wnd;
end;

constructor TProcessWindowController.Create(AProcessInfo: TProcessInformation);
begin
  inherited Create;
  FProcessInfo := AProcessInfo;
end;

function TProcessWindowController.ButtonEnabled(hButton: HWND): Boolean;
var
  vWindowStyle: Longint;
begin
  vWindowStyle := GetWindowLong(hButton, GWL_STYLE);
  Result := (WS_DISABLED and vWindowStyle) = 0;
end;

procedure TProcessWindowController.ClickButton(hButton: HWND);
begin
  SendMessage(hButton, BM_CLICK, 0, 0);
end;

function TProcessWindowController.FindChildWindow(hwndParent: HWnd; AClassName,
    AText: string): HWnd;
var
  vChildWindowInfo: TClassAndText;
begin
  try
    vChildWindowInfo.AClassName := AClassName;
    vChildWindowInfo.AText := AText;
    vChildWindowInfo.AResult := 0;
    vChildWindowInfo.AController := Self;

    EnumChildWindows(hwndParent, @EnumWindowsForFindChildWindowProc,
      Integer(@vChildWindowInfo));

    Result := vChildWindowInfo.AResult;
  except
    on Exception do
      Result := 0;
  end;
end;

function TProcessWindowController.FindChildWindowWithTimeOut(hwndParent: HWnd;
    AClassName, AText:string; ATimeOut: Integer): HWnd;
var
  vFinishTime: TDateTime;
  vStartTime: TDateTime;
begin
  vStartTime := Now;
  vFinishTime := IncSecond(vStartTime, ATimeOut);
  while Now < vFinishTime do
  begin
    Result := FindChildWindow(hwndParent, AClassName, AText);
    if Result <> 0 then
      Break;
  end;
end;

function TProcessWindowController.FindMainWindow: DWORD;
var
  EI: TEnumInfo;
begin
  EI.ProcessID := FProcessInfo.dwProcessId;
  EI.HWND := 0;
  EI.AController := Self;
  EnumWindows(@EnumWindowsProc, Integer(@EI));
  Result := EI.HWND;
end;

function TProcessWindowController.GetWindowClassString(AHandle: HWND): string;
var
  len: Integer;
begin
  SetLength(Result, 256);
  len := GetClassName(AHandle, PChar(Result), Length(Result));
  if len=0 then
    Result := ''
  else
    SetLength(Result, len);
end;

function TProcessWindowController.GetWindowTextString(AHandle: HWND): string;
var
  len: Integer;
begin
  SetLength(Result, 256);
  len := GetWindowText(AHandle, PChar(Result), Length(Result));
  if len=0 then
    Result := ''
  else
    SetLength(Result, len);
end;

procedure TProcessWindowController.PostClickButton(hButton: HWND);
begin
  PostMessage(hButton, BM_CLICK, 0, 0);
end;

procedure TProcessWindowController.PressKey(hWindow: HWND; AKey: Cardinal);
begin
  SendMessage(hWindow, WM_KEYDOWN, AKey, 0);
  Sleep(100);

  SendMessage(hWindow, WM_KEYUP, AKey, 0);
  Sleep(100);

  WaitForIdleProcess(5000);
end;

procedure TProcessWindowController.SetComboBoxItemIndex(hComboBox: HWND;
    AItemIndex: Integer);
begin
  PostMessage(hComboBox, CB_SHOWDROPDOWN, 1, 0);
  Sleep(100);

  PostMessage(hComboBox, CB_SETCURSEL, AItemIndex, 0);
  Sleep(100);

  SendMessage(hComboBox, WM_KEYDOWN, VK_RETURN, 0);
  Sleep(100);
  SendMessage(hComboBox, WM_KEYUP, VK_RETURN, 0);
  Sleep(100);

  WaitForIdleProcess(5000);
end;

procedure TProcessWindowController.SetComboBoxText(hComboBox: HWND; AText:
    String);
begin
  SendMessage(hComboBox, CB_SELECTSTRING, -1, Integer(PChar(AText)));
  Sleep(100);
end;

procedure TProcessWindowController.SetEditText(hEdit: HWND; AText: String);
begin
  SendMessage(hEdit, WM_SETTEXT, 0, Integer(PChar(AText)));
end;

function TProcessWindowController.StringMatches(AExpr: String; AInput: String):
    Boolean;
begin
  Result := (AExpr = '') or ExecRegExpr(AExpr, AInput);
end;

procedure TProcessWindowController.WaitForIdleProcess(ATimeOut: Integer);
begin
  if WaitForInputIdle(FProcessInfo.hProcess, ATimeOut * 1000) <> 0 then
    raise Exception.Create(SProcessTimeout);
end;

function TProcessWindowController.WaitForWindow(AText, AClassName: string;
    ATimeOut: Integer): HWND;
var
  vCaptionText: string;
  vClassText: string;
  vFound: Boolean;
  vLimitTime: TDateTime;
  vStartTime: TDateTime;
  vWindowText: string;
begin
  vStartTime := Now;
  vLimitTime := IncSecond(vStartTime, ATimeOut);
  vFound := False;
  while (Now < vLimitTime) and not vFound do
  begin
    Result := FindMainWindow();
    if Result <> 0 then
    begin
      vCaptionText := GetWindowTextString(Result);
      vClassText := GetWindowClassString(Result);

      vFound := StringMatches(AText, vCaptionText)
        and StringMatches(AClassName, vClassText);
    end;
    Sleep(100);
  end;

  if Now > vLimitTime then
    raise Exception.CreateFmt(SWindowTimeout, [AText]);
end;

function TProcessWindowController.WaitForWindowIdle(hWindow: HWND; ATimeout:
    Integer): Boolean;
var
  lpdwResult: Cardinal;
  vFinishTime: TDateTime;
  vStartTime: TDateTime;
begin
  vStartTime := Now;
  vFinishTime := IncSecond(vStartTime, ATimeout);
  while Now < vFinishTime do
  begin
    if SendMessageTimeout(hWindow, WM_NULL, 0, 0,
      SMTO_ABORTIFHUNG, 100, lpdwResult) <> 0 then
        Break
    else
      Sleep(100);
  end;
  Result := Now >= vFinishTime;
end;

end.
