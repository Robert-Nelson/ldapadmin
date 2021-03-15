object AboutDlg: TAboutDlg
  Left = 415
  Top = 198
  BorderStyle = bsDialog
  Caption = 'Info'
  ClientHeight = 256
  ClientWidth = 265
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 56
    Top = 16
    Width = 160
    Height = 37
    Caption = 'LDAP Admin'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -32
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 8
    Top = 56
    Width = 249
    Height = 145
    BevelOuter = bvLowered
    TabOrder = 1
    object Label2: TLabel
      Left = 24
      Top = 24
      Width = 38
      Height = 13
      Caption = 'Version:'
    end
    object Label3: TLabel
      Left = 24
      Top = 48
      Width = 34
      Height = 13
      Caption = 'Author:'
    end
    object Label4: TLabel
      Left = 24
      Top = 72
      Width = 26
      Height = 13
      Caption = 'Web:'
    end
    object Label5: TLabel
      Left = 72
      Top = 24
      Width = 37
      Height = 13
      Caption = '0.9.51'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 72
      Top = 48
      Width = 92
      Height = 13
      Caption = 'Tihomir Karlovic'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 72
      Top = 72
      Width = 156
      Height = 13
      Cursor = crHandPoint
      Caption = 'http://ldapadmin.sourceforge.net'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = Label7Click
    end
    object Label8: TLabel
      Left = 56
      Top = 112
      Width = 144
      Height = 13
      Caption = '(c) 2003-2004 Tihomir Karlovic'
    end
  end
  object BtnClose: TButton
    Left = 80
    Top = 216
    Width = 113
    Height = 25
    Caption = '&Close'
    ModalResult = 1
    TabOrder = 0
  end
end
