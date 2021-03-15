object PrefDlg: TPrefDlg
  Left = 688
  Top = 198
  BorderStyle = bsDialog
  Caption = 'Edit preferences'
  ClientHeight = 435
  ClientWidth = 554
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 554
    Height = 378
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = '&Posix'
      object GroupBox3: TGroupBox
        Left = 16
        Top = 16
        Width = 513
        Height = 185
        Caption = 'Defaults:'
        TabOrder = 0
        object Label5: TLabel
          Left = 38
          Top = 100
          Width = 76
          Height = 13
          Caption = 'Home Directory:'
        end
        object Label6: TLabel
          Left = 62
          Top = 132
          Width = 53
          Height = 13
          Caption = 'Login shell:'
        end
        object Label16: TLabel
          Left = 64
          Top = 36
          Width = 51
          Height = 13
          Caption = 'Username:'
        end
        object Label17: TLabel
          Left = 48
          Top = 68
          Width = 66
          Height = 13
          Caption = 'Display name:'
        end
        object edHomeDir: TEdit
          Left = 120
          Top = 96
          Width = 353
          Height = 21
          TabOrder = 2
        end
        object edLoginShell: TEdit
          Left = 120
          Top = 128
          Width = 353
          Height = 21
          TabOrder = 3
        end
        object edDisplayName: TEdit
          Left = 120
          Top = 64
          Width = 353
          Height = 21
          TabOrder = 1
        end
        object edUsername: TEdit
          Left = 120
          Top = 32
          Width = 353
          Height = 21
          TabOrder = 0
        end
      end
      object GroupBox7: TGroupBox
        Left = 16
        Top = 216
        Width = 513
        Height = 105
        Caption = 'Groups:'
        TabOrder = 1
        object Label15: TLabel
          Left = 52
          Top = 31
          Width = 60
          Height = 13
          Caption = 'Posix Group:'
        end
        object edGroup: TEdit
          Left = 120
          Top = 28
          Width = 305
          Height = 21
          TabOrder = 0
        end
        object SetBtn: TButton
          Left = 432
          Top = 26
          Width = 59
          Height = 25
          Caption = '&Set...'
          TabOrder = 1
          OnClick = SetBtnClick
        end
        object cbxExtendGroups: TCheckBox
          Left = 120
          Top = 63
          Width = 140
          Height = 17
          Caption = 'Extend Posix groups with:'
          TabOrder = 2
          OnClick = cbxExtendGroupsClick
        end
        object cbExtendGroups: TComboBox
          Left = 264
          Top = 60
          Width = 161
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 3
          Items.Strings = (
            'GroupOfUniqueNames'
            'GroupOfNames')
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = '&ID Settings'
      ImageIndex = 3
      object GroupBox1: TGroupBox
        Left = 16
        Top = 136
        Width = 249
        Height = 113
        Caption = 'User ID limitations:'
        TabOrder = 1
        object Label1: TLabel
          Left = 40
          Top = 36
          Width = 44
          Height = 13
          Caption = 'First UID:'
        end
        object Label2: TLabel
          Left = 40
          Top = 68
          Width = 45
          Height = 13
          Caption = 'Last UID:'
        end
        object edFirstUID: TEdit
          Left = 88
          Top = 32
          Width = 121
          Height = 21
          TabOrder = 0
        end
        object edLastUID: TEdit
          Left = 88
          Top = 64
          Width = 121
          Height = 21
          TabOrder = 1
        end
      end
      object GroupBox2: TGroupBox
        Left = 280
        Top = 136
        Width = 249
        Height = 113
        Caption = 'Group ID limitations:'
        TabOrder = 2
        object Label3: TLabel
          Left = 37
          Top = 32
          Width = 44
          Height = 13
          Caption = 'First GID:'
        end
        object Label4: TLabel
          Left = 36
          Top = 64
          Width = 45
          Height = 13
          Caption = 'Last GID:'
        end
        object edFirstGID: TEdit
          Left = 88
          Top = 28
          Width = 121
          Height = 21
          TabOrder = 0
        end
        object edLastGID: TEdit
          Left = 88
          Top = 60
          Width = 121
          Height = 21
          TabOrder = 1
        end
      end
      object IDGroup: TRadioGroup
        Left = 16
        Top = 16
        Width = 513
        Height = 105
        Caption = 'ID Creation:'
        ItemIndex = 1
        Items.Strings = (
          'Do not create user and group ID'#39's'
          'Create random user and group ID'#39's (default)'
          'Create sequential user and group ID'#39's')
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = '&Samba'
      ImageIndex = 1
      object GroupBox4: TGroupBox
        Left = 16
        Top = 138
        Width = 513
        Height = 196
        Caption = 'Default settings:'
        TabOrder = 1
        object Label8: TLabel
          Left = 72
          Top = 99
          Width = 30
          Height = 13
          Caption = 'Script:'
        end
        object Label9: TLabel
          Left = 48
          Top = 35
          Width = 60
          Height = 13
          Caption = 'Home share:'
        end
        object Label10: TLabel
          Left = 48
          Top = 131
          Width = 56
          Height = 13
          Caption = 'Profile path:'
        end
        object Label11: TLabel
          Left = 48
          Top = 67
          Width = 57
          Height = 13
          Caption = 'Home drive:'
        end
        object edScript: TEdit
          Left = 112
          Top = 95
          Width = 353
          Height = 21
          TabOrder = 2
        end
        object edHomeShare: TEdit
          Left = 112
          Top = 31
          Width = 353
          Height = 21
          TabOrder = 0
        end
        object edProfilePath: TEdit
          Left = 112
          Top = 127
          Width = 353
          Height = 21
          TabOrder = 3
        end
        object cbHomeDrive: TComboBox
          Left = 112
          Top = 63
          Width = 65
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
          Items.Strings = (
            'C:'
            'D:'
            'E:'
            'F:'
            'G:'
            'H:'
            'I:'
            'J:'
            'K:'
            'L:'
            'M:'
            'N:'
            'O:'
            'P:'
            'Q:'
            'R:'
            'S:'
            'T:'
            'U:'
            'V:'
            'W:'
            'X:'
            'Y:'
            'Z:')
        end
        object cbxLMPasswords: TCheckBox
          Left = 112
          Top = 160
          Width = 129
          Height = 17
          Caption = 'LANMAN Passwords'
          TabOrder = 4
        end
      end
      object GroupBox6: TGroupBox
        Left = 16
        Top = 16
        Width = 513
        Height = 105
        Caption = 'Server:'
        TabOrder = 0
        object Label7: TLabel
          Left = 24
          Top = 36
          Width = 81
          Height = 13
          Alignment = taRightJustify
          Caption = 'NETBIOS Name:'
        end
        object Label14: TLabel
          Left = 35
          Top = 68
          Width = 70
          Height = 13
          Alignment = taRightJustify
          Caption = 'Domain Name:'
        end
        object edNetbios: TEdit
          Left = 112
          Top = 32
          Width = 353
          Height = 21
          TabOrder = 0
        end
        object cbDomain: TComboBox
          Left = 112
          Top = 64
          Width = 353
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 1
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = '&Mail'
      ImageIndex = 2
      object GroupBox5: TGroupBox
        Left = 16
        Top = 24
        Width = 513
        Height = 297
        Caption = 'Default settings:'
        TabOrder = 0
        object Label12: TLabel
          Left = 64
          Top = 84
          Width = 80
          Height = 13
          Caption = 'Default Maildrop:'
        end
        object Label13: TLabel
          Left = 40
          Top = 44
          Width = 100
          Height = 13
          Caption = 'Default Mail Address:'
        end
        object edMaildrop: TEdit
          Left = 152
          Top = 80
          Width = 321
          Height = 21
          TabOrder = 1
        end
        object edMailAddress: TEdit
          Left = 152
          Top = 40
          Width = 177
          Height = 21
          TabOrder = 0
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 378
    Width = 554
    Height = 57
    Align = alBottom
    TabOrder = 1
    object OkBtn: TButton
      Left = 384
      Top = 16
      Width = 75
      Height = 25
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
    object CancelBtn: TButton
      Left = 464
      Top = 16
      Width = 75
      Height = 25
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 2
    end
    object BtnWizard: TButton
      Left = 24
      Top = 16
      Width = 121
      Height = 25
      Caption = 'Create default...'
      TabOrder = 0
      OnClick = BtnWizardClick
    end
  end
end
