object Form1: TForm1
  Left = 280
  Top = 179
  Width = 587
  Height = 395
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 577
    Height = 313
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = '&Posix'
      object Label1: TLabel
        Left = 16
        Top = 24
        Width = 44
        Height = 13
        Caption = 'First UID:'
      end
      object Label2: TLabel
        Left = 16
        Top = 72
        Width = 45
        Height = 13
        Caption = 'Last UID:'
      end
      object Label3: TLabel
        Left = 16
        Top = 120
        Width = 44
        Height = 13
        Caption = 'First GID:'
      end
      object Label4: TLabel
        Left = 16
        Top = 168
        Width = 45
        Height = 13
        Caption = 'Last GID:'
      end
      object Label5: TLabel
        Left = 160
        Top = 24
        Width = 76
        Height = 13
        Caption = 'Home Directory:'
      end
      object Label6: TLabel
        Left = 160
        Top = 72
        Width = 53
        Height = 13
        Caption = 'Login shell:'
      end
      object Edit1: TEdit
        Left = 16
        Top = 40
        Width = 121
        Height = 21
        TabOrder = 0
        Text = 'Edit1'
      end
      object Edit2: TEdit
        Left = 16
        Top = 88
        Width = 121
        Height = 21
        TabOrder = 1
        Text = 'Edit2'
      end
      object Edit3: TEdit
        Left = 16
        Top = 136
        Width = 121
        Height = 21
        TabOrder = 2
        Text = 'Edit3'
      end
      object Edit4: TEdit
        Left = 16
        Top = 184
        Width = 121
        Height = 21
        TabOrder = 3
        Text = 'Edit4'
      end
      object Edit5: TEdit
        Left = 160
        Top = 40
        Width = 121
        Height = 21
        TabOrder = 4
        Text = 'Edit5'
      end
      object Edit6: TEdit
        Left = 160
        Top = 88
        Width = 121
        Height = 21
        TabOrder = 5
        Text = 'Edit6'
      end
    end
    object TabSheet2: TTabSheet
      Caption = '&Samba'
      ImageIndex = 1
      object Label7: TLabel
        Left = 16
        Top = 16
        Width = 65
        Height = 13
        Caption = 'Server Name:'
      end
      object Label8: TLabel
        Left = 16
        Top = 72
        Width = 30
        Height = 13
        Caption = 'Script:'
      end
      object Label9: TLabel
        Left = 160
        Top = 16
        Width = 60
        Height = 13
        Caption = 'Home share:'
      end
      object Label10: TLabel
        Left = 160
        Top = 72
        Width = 56
        Height = 13
        Caption = 'Profile path:'
      end
      object Label11: TLabel
        Left = 296
        Top = 16
        Width = 57
        Height = 13
        Caption = 'Home drive:'
      end
      object Edit7: TEdit
        Left = 16
        Top = 32
        Width = 121
        Height = 21
        TabOrder = 0
        Text = 'Edit7'
      end
      object Edit8: TEdit
        Left = 16
        Top = 88
        Width = 121
        Height = 21
        TabOrder = 1
        Text = 'Edit8'
      end
      object Edit9: TEdit
        Left = 160
        Top = 32
        Width = 121
        Height = 21
        TabOrder = 2
        Text = 'Edit9'
      end
      object Edit10: TEdit
        Left = 160
        Top = 88
        Width = 121
        Height = 21
        TabOrder = 3
        Text = 'Edit10'
      end
      object ComboBox1: TComboBox
        Left = 296
        Top = 32
        Width = 145
        Height = 21
        ItemHeight = 13
        TabOrder = 4
        Text = 'ComboBox1'
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Mail'
      ImageIndex = 2
      object Label12: TLabel
        Left = 24
        Top = 24
        Width = 43
        Height = 13
        Caption = 'Maildrop:'
      end
      object Label13: TLabel
        Left = 24
        Top = 72
        Width = 59
        Height = 13
        Caption = 'Mail domain:'
      end
      object Edit11: TEdit
        Left = 24
        Top = 40
        Width = 121
        Height = 21
        TabOrder = 0
        Text = 'Edit11'
      end
      object Edit12: TEdit
        Left = 24
        Top = 88
        Width = 121
        Height = 21
        TabOrder = 1
        Text = 'Edit12'
      end
    end
  end
end
