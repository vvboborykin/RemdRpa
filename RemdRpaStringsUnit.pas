{*******************************************************
* Project: RemdRpa.EncryptConfig
* Unit: RemdRpaStringsUnit.pas
* Description: Локализуемые строки приложения
* 
* Created: 26.06.2023 12:03:00
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit RemdRpaStringsUnit;

interface

resourcestring
  SFileIsNotFound = 'File "%s" is not found';
  SFileShoundHaveXMLExtension = 'File "%s" shound have XML extension';
  SEncryptionCompleted = 'Encryption completed';
  SEncryptingFileToFile = 'Encrypting file "%s" to file "%s" ...';
  SSingStarted = 'Начато подпись документов';
  SSendStarted = 'Начата отправка документов';
  SReadingAppOptionsFromFile = 'Чтение параметров приложения из файла "%s"';
  SLoadingAppOptionsFromXmlString = 'Загружаем параметры из XML строки "%s"';
  SReadAppOptionsFromXmlDoc = 'Читаем параметры приложения их XML документа';
  SConfigFileNotFound = 'Файл конфигурации %s не найден';
  SAppOptionsLoadingFromFile = 'Загрузка параметров из файла "%s"';
  SAppOptionsIsNil = 'Пустое значение AppOptions';
  SGettingConfigFileName = 'Получаем имя файла конфигурации';
  SConfigFileNameFoundInCmdParams = 'В параметрах командной строки найдено имя файла конфигурации "%s"';
  SAppOptionsDecrypting = 'Расшифровка параметров';
  SRemdStarted = 'Программа РЭМД запущена';
  SRemdLaunch = 'Запуск программы РЭМД %s %s';
  SAppExit = 'Выход из программы';
  SUserLoginTry = 'Вход в программу РЭМД пользователя %s';
  SLoginError = 'Ошибка входа пользователя %s';
  SUserLoggedIn = 'Вход пользователя %s произведен';
  SRefreshButtonNotFound = 'Не найдена кнопка "%s" на главной форме РЭМД';
  SProcessTimeout = 'Тайм аут ожидания процесса';
  SWindowTimeout = 'Таймаут ожидания окна %s';
  SMainFormNotFound = 'Главная форма РЭМД с заголовком "%s" не найдена';
  SModeComboBoxNotFoundOnMainForm = 'На главной форме не найден список режимов';
  SSignAllButtonNotFound = 'Не найдена кнопка "%s" на главной форме приложения';
  SOkButtonNotFoundOnLoginForm = 'Не найдена кнопка OK на форме регистрации';
  SUsersComboBoxNotFountOnLoginForm = 'Не найден список пользователей на форме регистрации';
  SPasswordTextBoxNotFoundOnLogonForm = 'Не найдено поле ввода пароля на форме регистрации';

implementation

end.




























