{*******************************************************
* Project: RemdRpa.Console
* Unit: CommandLineControllerUnit.pas
* Description: ���������� ��� ������ � ��������� ������� ����������
* 
* Created: 23.06.2023 13:53:44
* Copyright (C) 2023 ��������� �.�. (bpost@yandex.ru)
*******************************************************}
unit CommandLineControllerUnit;

interface

uses
  SysUtils, Classes, Variants, StrUtils, DateUtils;

type
  /// <summary>TCommandLineController
  /// ���������� ��� ������ � ��������� ������� ����������
  /// </summary>
  TCommandLineController = class
  public
    /// <summary>TCommandLineController.TryGetValue
    /// ���������� �������� �������� ��������� ��������� ������
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    /// <param name="AName"> (string) ��� ���������</param>
    /// <param name="AResult"> (String) �������������� �������� ��� �������������
    /// ������</param>
    class function TryGetValue(AName: string; out AResult: String): Boolean;
  end;

implementation

uses
  RegExpr;

class function TCommandLineController.TryGetValue(AName: string; out AResult:
    String): Boolean;
var
  I: Integer;
  vParam: string;
  vRegExpr: TRegExpr;
begin
  Result := False;
  AResult := '';
  vRegExpr := TRegExpr.Create();
  try
    vRegExpr.Expression := AName + '\s*=\s*(.*)';
    for I := 1 to ParamCount do
    begin
      vParam := ParamStr(I);
      if vRegExpr.Exec(vParam) then
      begin
        AResult := AnsiDequotedStr(vRegExpr.Match[1], '"');
        Result := True;
        Break;
      end;
    end;
  finally
    vRegExpr.Free;
  end;
end;

end.
