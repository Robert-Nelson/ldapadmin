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
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 554
    Height = 378
    ActivePage = tsPosix
    Align = alClient
    TabOrder = 0
    OnChange = PageControlChange
    object tsPosix: TTabSheet
      Caption = '&Posix'
      object gbDefaults: TGroupBox
        Left = 16
        Top = 16
        Width = 513
        Height = 169
        Caption = 'Defaults:'
        TabOrder = 0
        object lblHomeDir: TLabel
          Left = 38
          Top = 92
          Width = 76
          Height = 13
          Alignment = taRightJustify
          Caption = 'Home Directory:'
        end
        object lblLoginShell: TLabel
          Left = 62
          Top = 124
          Width = 53
          Height = 13
          Alignment = taRightJustify
          Caption = 'Login shell:'
        end
        object lblUsername: TLabel
          Left = 64
          Top = 28
          Width = 51
          Height = 13
          Alignment = taRightJustify
          Caption = 'Username:'
        end
        object lblDisplayname: TLabel
          Left = 48
          Top = 60
          Width = 66
          Height = 13
          Alignment = taRightJustify
          Caption = 'Display name:'
        end
        object edHomeDir: TEdit
          Left = 120
          Top = 88
          Width = 353
          Height = 21
          TabOrder = 2
        end
        object edLoginShell: TEdit
          Left = 120
          Top = 120
          Width = 353
          Height = 21
          TabOrder = 3
        end
        object edDisplayName: TEdit
          Left = 120
          Top = 56
          Width = 353
          Height = 21
          TabOrder = 1
        end
        object edUsername: TEdit
          Left = 120
          Top = 24
          Width = 353
          Height = 21
          TabOrder = 0
        end
      end
      object gbGroups: TGroupBox
        Left = 16
        Top = 200
        Width = 513
        Height = 129
        Caption = 'Groups:'
        TabOrder = 1
        object lblPosixGroup: TLabel
          Left = 52
          Top = 31
          Width = 60
          Height = 13
          Alignment = taRightJustify
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
          Width = 233
          Height = 17
          Caption = 'Extend Posix groups with:'
          TabOrder = 2
          OnClick = cbxExtendGroupsClick
        end
        object cbExtendGroups: TComboBox
          Left = 120
          Top = 84
          Width = 233
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
    object tsID: TTabSheet
      Caption = '&ID Settings'
      ImageIndex = 3
      object gbUserLimits: TGroupBox
        Left = 16
        Top = 136
        Width = 249
        Height = 113
        Caption = 'User ID limitations:'
        TabOrder = 1
        object lblFirstUId: TLabel
          Left = 40
          Top = 36
          Width = 44
          Height = 13
          Alignment = taRightJustify
          Caption = 'First UID:'
        end
        object lblLastUid: TLabel
          Left = 40
          Top = 68
          Width = 45
          Height = 13
          Alignment = taRightJustify
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
      object gbGroupLimits: TGroupBox
        Left = 280
        Top = 136
        Width = 249
        Height = 113
        Caption = 'Group ID limitations:'
        TabOrder = 2
        object lblFirstGid: TLabel
          Left = 37
          Top = 32
          Width = 44
          Height = 13
          Alignment = taRightJustify
          Caption = 'First GID:'
        end
        object lblLastGid: TLabel
          Left = 36
          Top = 64
          Width = 45
          Height = 13
          Alignment = taRightJustify
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
      object gbID: TRadioGroup
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
    object tsSamba: TTabSheet
      Caption = '&Samba'
      ImageIndex = 1
      object gbSambaDefaults: TGroupBox
        Left = 16
        Top = 138
        Width = 513
        Height = 196
        Caption = 'Default settings:'
        TabOrder = 1
        object lblScript: TLabel
          Left = 72
          Top = 99
          Width = 30
          Height = 13
          Alignment = taRightJustify
          Caption = 'Script:'
        end
        object lblHomeShare: TLabel
          Left = 48
          Top = 35
          Width = 60
          Height = 13
          Alignment = taRightJustify
          Caption = 'Home share:'
        end
        object lblProfilePath: TLabel
          Left = 48
          Top = 131
          Width = 56
          Height = 13
          Alignment = taRightJustify
          Caption = 'Profile path:'
        end
        object lblHomeDrive: TLabel
          Left = 48
          Top = 67
          Width = 57
          Height = 13
          Alignment = taRightJustify
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
          Width = 225
          Height = 17
          Caption = 'LANMAN Passwords'
          TabOrder = 4
        end
      end
      object gbServer: TGroupBox
        Left = 16
        Top = 16
        Width = 513
        Height = 105
        Caption = 'Server:'
        TabOrder = 0
        object lblNetbios: TLabel
          Left = 24
          Top = 36
          Width = 81
          Height = 13
          Alignment = taRightJustify
          Caption = 'NETBIOS Name:'
        end
        object lblDomainName: TLabel
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
    object tsMAil: TTabSheet
      Caption = '&Mail'
      ImageIndex = 2
      object gbMailDefaults: TGroupBox
        Left = 16
        Top = 24
        Width = 513
        Height = 297
        Caption = 'Default settings:'
        TabOrder = 0
        object lblMD: TLabel
          Left = 64
          Top = 84
          Width = 80
          Height = 13
          Alignment = taRightJustify
          Caption = 'Default Maildrop:'
        end
        object lblMA: TLabel
          Left = 40
          Top = 44
          Width = 100
          Height = 13
          Alignment = taRightJustify
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
