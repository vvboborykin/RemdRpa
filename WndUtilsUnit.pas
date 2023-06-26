unit WndUtilsUnit;

interface

uses
  SysUtils, Classes, Variants, StrUtils, DateUtils, Windows, RegExpr;

type
  TProcessWindowController = class
  private
    FProcessInfo: TProcessInformation;
    function FindMainWindow: DWORD;
    function GetWindowClassString(AHandle: HWND): string;
    function GetWindowTextString(AHandle: HWND): string;
    function StringMatches(AExpr: String; AInput: String): Boolean;
  public
    constructor Create(AProcessInfo: TProcessInformation);
    function ButtonEnabled(hButton: HWND): Boolean;
    procedure ClickButton(hButton: HWND);
    function FindChildWindow(hwndParent: HWnd; AClassName, AText: string): HWnd;
    function FindChildWindowWithTimeOut(hwndParent: HWnd; AClassName, AText:string;
        ATimeOut: Integer): HWnd;
    procedure PostClickButton(hButton: HWND);
    procedure SetComboBoxText(hComboBox: HWND; AText: String);
    procedure SetEditText(hEdit: HWND; AText: String);
    procedure WaitForIdleProcess(ATimeOut: Integer);
    function WaitForWindow(AText, AClassName: string; ATimeOut: Integer): HWND;
  end;

implementation


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



function EnumWindowsForFindChildWindowProc(WHandle: HWND; var vParam: TClassAndText): BOOL; stdcall;
var
  nHandle: HWnd;
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
Const
  BM_CLICK = $F5;
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

    EnumChildWindows(hwndParent, @EnumWindowsForFindChildWindowProc, Integer(@vChildWindowInfo));

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
Const
  BM_CLICK = $F5;
begin
  PostMessage(hButton, BM_CLICK, 0, 0);
end;

procedure TProcessWindowController.SetComboBoxText(hComboBox: HWND; AText:
    String);
const
  CB_SELECTSTRING = $014d;
begin
  SendMessage(hComboBox, CB_SELECTSTRING, -1, Integer(PChar(AText)));
end;

procedure TProcessWindowController.SetEditText(hEdit: HWND; AText: String);
const
  WM_SETTEXT = $000C;
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
    raise Exception.Create('Тайм аут ожидания процесса');
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
    raise Exception.CreateFmt('Таймаут ожидания окна %s', [AText]);
end;

end.
