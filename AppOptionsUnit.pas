{*******************************************************
* Project: RemdRpa.Console
* Unit: AppOptionsUnit.pas
* Description: Параметры работы приложения
* 
* Created: 23.06.2023 13:47:43
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit AppOptionsUnit;

interface

uses
  SysUtils, Classes, Variants, StrUtils, DateUtils;

type
  /// <summary>TAppOptions
  /// Параметры работы приложения
  /// </summary>
  TAppOptions = class
  private
    FLoadTimeoutSec: Cardinal;
    FLoginName: string;
    FLoginTimeoutSec: Cardinal;
    FPassword: string;
    FRemdExeFileName: string;
    FRemdStartParams: string;
    FSendEnabled: Boolean;
    FSendTimeoutSec: Cardinal;
    FSignTimeoutSec: Cardinal;
    FSignEnabled: Boolean;
    FSignPassword: string;
    procedure SetLoadTimeoutSec(const Value: Cardinal);
    procedure SetLoginName(const Value: string);
    procedure SetLoginTimeoutSec(const Value: Cardinal);
    procedure SetPassword(const Value: string);
    procedure SetRemdExeFileName(const Value: string);
    procedure SetRemdStartParams(const Value: string);
    procedure SetSendEnabled(const Value: Boolean);
    procedure SetSendTimeoutSec(const Value: Cardinal);
    procedure SetSignTimeoutSec(const Value: Cardinal);
    procedure SetSignEnabled(const Value: Boolean);
    procedure SetSignPassword(const Value: string);
  public
    constructor Create;
  published
    /// <summary>TAppOptions.LoadTimeoutSec
    /// Таймаут загрузки РЭМД
    /// </summary>
    /// type:Cardinal
    property LoadTimeoutSec: Cardinal read FLoadTimeoutSec write SetLoadTimeoutSec;
    /// <summary>TAppOptions.LoginName
    /// логическое имя для входа в РЭМД
    /// </summary>
    /// type:string
    property LoginName: string read FLoginName write SetLoginName;
    /// <summary>TAppOptions.LoginTimeoutSec
    /// таймут входа в РЭМД
    /// </summary>
    /// type:Cardinal
    property LoginTimeoutSec: Cardinal read FLoginTimeoutSec write
        SetLoginTimeoutSec;
    /// <summary>TAppOptions.Password
    /// пароль для входа в РЭМД
    /// </summary>
    /// type:string
    property Password: string read FPassword write SetPassword;
    /// <summary>TAppOptions.RemdExeFileName
    /// имя исполняемого файла РЭМД
    /// </summary>
    /// type:string
    property RemdExeFileName: string read FRemdExeFileName write SetRemdExeFileName;
    /// <summary>TAppOptions.RemdStartParams
    /// параметры запуска РЭМД
    /// </summary>
    /// type:string
    property RemdStartParams: string read FRemdStartParams write SetRemdStartParams;
    /// <summary>TAppOptions.SendEnabled
    /// производить отправку документов
    /// </summary>
    /// type:Boolean
    property SendEnabled: Boolean read FSendEnabled write SetSendEnabled;
    /// <summary>TAppOptions.SendTimeoutSec
    /// тайм-аут отправки документов
    /// </summary>
    /// type:Cardinal
    property SendTimeoutSec: Cardinal read FSendTimeoutSec write SetSendTimeoutSec;
    /// <summary>TAppOptions.SignTimeoutSec
    /// тайм-аут подписи документов
    /// </summary>
    /// type:Cardinal
    property SignTimeoutSec: Cardinal read FSignTimeoutSec write SetSignTimeoutSec;
    /// <summary>TAppOptions.SignEnabled
    /// производить подпись документов
    /// </summary>
    /// type:Boolean
    property SignEnabled: Boolean read FSignEnabled write SetSignEnabled;
    /// <summary>TAppOptions.SignPassword
    /// пароль контейнера электронной подписи
    /// </summary>
    /// type:string
    property SignPassword: string read FSignPassword write SetSignPassword;
  end;

implementation

constructor TAppOptions.Create;
begin
  inherited Create;
  FLoadTimeoutSec := 120;
  FLoginTimeoutSec := 120;
  FRemdExeFileName := 'c:\somiac\remd\remd.exe';
  FSendEnabled := True;
  FSendTimeoutSec := 600;
  FSignTimeoutSec := 600;
  FSignEnabled := True;
  FPassword := '12345678';
end;

procedure TAppOptions.SetLoadTimeoutSec(const Value: Cardinal);
begin
  FLoadTimeoutSec := Value;
end;

procedure TAppOptions.SetLoginName(const Value: string);
begin
  FLoginName := Value;
end;

procedure TAppOptions.SetLoginTimeoutSec(const Value: Cardinal);
begin
  FLoginTimeoutSec := Value;
end;

procedure TAppOptions.SetPassword(const Value: string);
begin
  FPassword := Value;
end;

procedure TAppOptions.SetRemdExeFileName(const Value: string);
begin
  FRemdExeFileName := Value;
end;

procedure TAppOptions.SetRemdStartParams(const Value: string);
begin
  FRemdStartParams := Value;
end;

procedure TAppOptions.SetSendEnabled(const Value: Boolean);
begin
  FSendEnabled := Value;
end;

procedure TAppOptions.SetSendTimeoutSec(const Value: Cardinal);
begin
  FSendTimeoutSec := Value;
end;

procedure TAppOptions.SetSignTimeoutSec(const Value: Cardinal);
begin
  FSignTimeoutSec := Value;
end;

procedure TAppOptions.SetSignEnabled(const Value: Boolean);
begin
  FSignEnabled := Value;
end;

procedure TAppOptions.SetSignPassword(const Value: string);
begin
  FSignPassword := Value;
end;

end.
