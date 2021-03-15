object PrefDlg: TPrefDlg
  Left = 688
  Top = 198
  BorderStyle = bsDialog
  Caption = 'Edit preferences'
  ClientHeight = 435
  ClientWidth = 554
  Color = clBtnFace
  ParentFont = True
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
          Left = 36
          Top = 92
          Width = 78
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
          Left = 63
          Top = 28
          Width = 52
          Height = 13
          Alignment = taRightJustify
          Caption = 'Username:'
        end
        object lblDisplayname: TLabel
          Left = 47
          Top = 60
          Width = 67
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
          Left = 51
          Top = 31
          Width = 61
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
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object gbUserLimits: TGroupBox
        Left = 16
        Top = 136
        Width = 249
        Height = 113
        Caption = 'User ID limitations:'
        TabOrder = 1
        object lblFirstUId: TLabel
          Left = 38
          Top = 36
          Width = 46
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
          Left = 35
          Top = 32
          Width = 46
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
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object gbServer: TGroupBox
        Left = 16
        Top = 16
        Width = 513
        Height = 105
        Caption = 'Server:'
        TabOrder = 0
        object lblNetbios: TLabel
          Left = 28
          Top = 36
          Width = 77
          Height = 13
          Alignment = taRightJustify
          Caption = 'NETBIOS Name:'
        end
        object lblDomainName: TLabel
          Left = 36
          Top = 68
          Width = 69
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
          TabOrder = 1
        end
      end
      object PageControl1: TPageControl
        Left = 16
        Top = 136
        Width = 513
        Height = 201
        ActivePage = TabSheet1
        TabOrder = 1
        object TabSheet1: TTabSheet
          Caption = 'Default &paths'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object lblScript: TLabel
            Left = 71
            Top = 91
            Width = 31
            Height = 13
            Alignment = taRightJustify
            Caption = 'Script:'
          end
          object lblHomeShare: TLabel
            Left = 42
            Top = 27
            Width = 61
            Height = 13
            Alignment = taRightJustify
            Caption = 'Home share:'
          end
          object lblProfilePath: TLabel
            Left = 45
            Top = 123
            Width = 59
            Height = 13
            Alignment = taRightJustify
            Caption = 'Profile path:'
          end
          object lblHomeDrive: TLabel
            Left = 47
            Top = 59
            Width = 58
            Height = 13
            Alignment = taRightJustify
            Caption = 'Home drive:'
          end
          object edScript: TEdit
            Left = 112
            Top = 87
            Width = 353
            Height = 21
            TabOrder = 0
          end
          object edHomeShare: TEdit
            Left = 112
            Top = 23
            Width = 353
            Height = 21
            TabOrder = 1
          end
          object edProfilePath: TEdit
            Left = 112
            Top = 119
            Width = 353
            Height = 21
            TabOrder = 2
          end
          object cbHomeDrive: TComboBox
            Left = 112
            Top = 55
            Width = 65
            Height = 21
            Style = csDropDownList
            TabOrder = 3
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
        end
        object TabSheet2: TTabSheet
          Caption = '&Options'
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Bevel1: TBevel
            Left = 24
            Top = 112
            Width = 465
            Height = 42
            Shape = bsFrame
          end
          object cbxLMPasswords: TCheckBox
            Left = 40
            Top = 125
            Width = 249
            Height = 17
            Caption = 'LANMAN Passwords'
            TabOrder = 0
          end
          object rgRid: TRadioGroup
            Left = 24
            Top = 16
            Width = 465
            Height = 81
            Caption = 'RID method'
            ItemIndex = 0
            Items.Strings = (
              'Use algorithmic RID assignment'
              'Use sambaNextRid for RID generation')
            TabOrder = 1
          end
        end
      end
    end
    object tsMAil: TTabSheet
      Caption = '&Mail'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object gbMailDefaults: TGroupBox
        Left = 16
        Top = 24
        Width = 513
        Height = 297
        Caption = 'Default settings:'
        TabOrder = 0
        object lblMD: TLabel
          Left = 62
          Top = 84
          Width = 82
          Height = 13
          Alignment = taRightJustify
          Caption = 'Default Maildrop:'
        end
        object lblMA: TLabel
          Left = 38
          Top = 44
          Width = 102
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
