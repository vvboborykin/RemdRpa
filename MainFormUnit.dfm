object MainForm: TMainForm
  Left = 654
  Top = 144
  Width = 827
  Height = 541
  Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1079#1072#1094#1080#1103' '#1056#1069#1052#1044
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 19
  object lacMain: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 811
    Height = 502
    Align = alClient
    TabOrder = 0
    object layRoot: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      ButtonOptions.Buttons = <>
      Hidden = True
      ShowBorder = False
      Index = -1
    end
  end
  object lafMain: TdxLayoutLookAndFeelList
    Left = 472
    Top = 32
  end
  object vtOptions: TVirtualTable
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'LoadTimeout'
        DataType = ftInteger
      end
      item
        Name = 'LoginName'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Password'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'LoginTimeout'
        DataType = ftInteger
      end>
    Left = 448
    Top = 120
    Data = {
      04000500020049640100FF00000000000B004C6F616454696D656F7574030000
      000000000009004C6F67696E4E616D650100FF0000000000080050617373776F
      72640100FF00000000000C004C6F67696E54696D656F75740300000000000000
      000000000000}
  end
end
