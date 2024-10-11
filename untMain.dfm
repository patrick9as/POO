object Form11: TForm11
  Left = 0
  Top = 0
  Caption = 'Form11'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnInserir: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'btnInserir'
    TabOrder = 0
    OnClick = btnInserirClick
  end
  object btnConsultar: TButton
    Left = 89
    Top = 8
    Width = 75
    Height = 25
    Caption = 'btnConsultar'
    TabOrder = 1
    OnClick = btnConsultarClick
  end
  object btnEditar: TButton
    Left = 170
    Top = 8
    Width = 75
    Height = 25
    Caption = 'btnEditar'
    TabOrder = 2
    OnClick = btnEditarClick
  end
  object btnExcluir: TButton
    Left = 251
    Top = 8
    Width = 75
    Height = 25
    Caption = 'btnExcluir'
    TabOrder = 3
    OnClick = btnExcluirClick
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 39
    Width = 619
    Height = 252
    DataSource = DataSource1
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'ID'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Nome'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Identidade'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Detalhe'
        Visible = True
      end>
  end
  object VirtualTable1: TVirtualTable
    Left = 312
    Top = 152
    Data = {04000000000000000000}
    object VirtualTable1ID: TIntegerField
      FieldName = 'ID'
    end
    object VirtualTable1Nome: TStringField
      FieldName = 'Nome'
      Size = 120
    end
    object VirtualTable1Identidade: TStringField
      FieldName = 'Identidade'
      Size = 14
    end
    object VirtualTable1Detalhe: TStringField
      FieldName = 'Detalhe'
    end
  end
  object DataSource1: TDataSource
    DataSet = VirtualTable1
    Left = 448
    Top = 160
  end
end
