object UserDlg: TUserDlg
  Left = 423
  Top = 181
  ActiveControl = givenName
  BorderStyle = bsDialog
  Caption = 'Create User'
  ClientHeight = 451
  ClientWidth = 394
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poMainFormCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 394
    Height = 396
    ActivePage = AccountSheet
    Align = alClient
    MultiLine = True
    TabOrder = 0
    OnChange = PageControlChange
    OnChanging = PageControlChanging
    OnResize = PageControlResize
    object AccountSheet: TTabSheet
      Caption = '&Account'
      object Label1: TLabel
        Left = 16
        Top = 16
        Width = 54
        Height = 13
        Caption = '&First name:'
      end
      object Label2: TLabel
        Left = 224
        Top = 16
        Width = 68
        Height = 13
        Caption = '&Second name:'
      end
      object Label3: TLabel
        Left = 16
        Top = 64
        Width = 67
        Height = 13
        Caption = '&Display name:'
      end
      object Label4: TLabel
        Left = 16
        Top = 112
        Width = 52
        Height = 13
        Caption = '&Username:'
      end
      object Label5: TLabel
        Left = 160
        Top = 16
        Width = 35
        Height = 13
        Caption = '&Initials:'
      end
      object Label9: TLabel
        Left = 16
        Top = 160
        Width = 78
        Height = 13
        Caption = '&Home Directory:'
      end
      object Label12: TLabel
        Left = 16
        Top = 208
        Width = 33
        Height = 13
        Caption = 'Gecos:'
      end
      object Label14: TLabel
        Left = 208
        Top = 112
        Width = 53
        Height = 13
        Caption = '&Login shell:'
      end
      object GroupBox1: TGroupBox
        Left = 16
        Top = 256
        Width = 353
        Height = 105
        Caption = 'Account properties'
        TabOrder = 8
        object Bevel1: TBevel
          Left = 176
          Top = 28
          Width = 9
          Height = 57
          Shape = bsLeftLine
        end
        object cbShadow: TCheckBox
          Left = 24
          Top = 24
          Width = 121
          Height = 17
          Caption = 'Shadow Account'
          TabOrder = 0
          OnClick = cbShadowClick
        end
        object cbMail: TCheckBox
          Left = 24
          Top = 72
          Width = 97
          Height = 17
          Caption = 'Mail Account'
          TabOrder = 2
          OnClick = cbMailClick
        end
        object cbSamba: TCheckBox
          Left = 24
          Top = 48
          Width = 97
          Height = 17
          Caption = 'Samba Account'
          TabOrder = 1
          OnClick = cbSambaClick
        end
        object CheckListBox: TCheckListBox
          Left = 200
          Top = 21
          Width = 137
          Height = 72
          OnClickCheck = CheckListBoxClickCheck
          BorderStyle = bsNone
          Enabled = False
          Flat = False
          IntegralHeight = True
          ItemHeight = 24
          Sorted = True
          Style = lbOwnerDrawFixed
          TabOrder = 3
          OnClick = CheckListBoxClick
          OnDrawItem = CheckListBoxDrawItem
        end
      end
      object givenName: TEdit
        Left = 16
        Top = 32
        Width = 137
        Height = 21
        TabOrder = 0
        OnChange = EditChange
      end
      object sn: TEdit
        Left = 224
        Top = 32
        Width = 145
        Height = 21
        TabOrder = 2
        OnChange = EditChange
        OnExit = snExit
      end
      object displayName: TEdit
        Left = 16
        Top = 80
        Width = 353
        Height = 21
        TabOrder = 3
        OnChange = EditChange
      end
      object uid: TEdit
        Left = 16
        Top = 128
        Width = 185
        Height = 21
        TabOrder = 4
        OnChange = EditChange
        OnExit = uidExit
      end
      object initials: TEdit
        Left = 160
        Top = 32
        Width = 57
        Height = 21
        TabOrder = 1
        OnChange = EditChange
      end
      object homeDirectory: TEdit
        Left = 16
        Top = 176
        Width = 353
        Height = 21
        TabOrder = 6
        OnChange = EditChange
      end
      object gecos: TEdit
        Left = 16
        Top = 224
        Width = 353
        Height = 21
        TabOrder = 7
        OnChange = EditChange
      end
      object loginShell: TEdit
        Left = 208
        Top = 128
        Width = 161
        Height = 21
        TabOrder = 5
        OnChange = EditChange
      end
    end
    object ShadowSheet: TTabSheet
      Caption = 'Shadow'
      ImageIndex = 6
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object RadioGroup1: TRadioGroup
        Left = 16
        Top = 264
        Width = 353
        Height = 89
        Caption = '&Account expires'
        ItemIndex = 0
        Items.Strings = (
          'Never'
          'On:')
        TabOrder = 1
        OnClick = RadioGroup1Click
      end
      object DateTimePicker: TDateTimePicker
        Left = 72
        Top = 320
        Width = 97
        Height = 21
        Date = 38076.771625092600000000
        Time = 38076.771625092600000000
        Color = clBtnFace
        Enabled = False
        TabOrder = 2
        OnChange = DateTimePickerChange
      end
      object ShadowPropertiesGroup: TGroupBox
        Left = 16
        Top = 24
        Width = 353
        Height = 233
        Caption = 'Shadow Properties'
        TabOrder = 0
        object Label35: TLabel
          Left = 32
          Top = 40
          Width = 61
          Height = 13
          Caption = 'Min Shadow:'
        end
        object Label37: TLabel
          Left = 200
          Top = 40
          Width = 83
          Height = 13
          Caption = 'Shadow warning:'
        end
        object Label38: TLabel
          Left = 200
          Top = 96
          Width = 62
          Height = 13
          Caption = 'Last change:'
        end
        object Label39: TLabel
          Left = 32
          Top = 96
          Width = 65
          Height = 13
          Caption = 'Max Shadow:'
        end
        object Label40: TLabel
          Left = 32
          Top = 160
          Width = 84
          Height = 13
          Caption = 'Shadow Inactive:'
        end
        object ShadowMin: TEdit
          Left = 32
          Top = 56
          Width = 121
          Height = 21
          TabOrder = 0
          OnChange = EditChange
        end
        object ShadowWarning: TEdit
          Left = 200
          Top = 56
          Width = 121
          Height = 21
          TabOrder = 1
          OnChange = EditChange
        end
        object ShadowInactive: TEdit
          Left = 32
          Top = 176
          Width = 121
          Height = 21
          TabOrder = 4
          OnChange = EditChange
        end
        object ShadowLastChange: TEdit
          Left = 200
          Top = 112
          Width = 121
          Height = 21
          Enabled = False
          TabOrder = 3
        end
        object ShadowMax: TEdit
          Left = 32
          Top = 112
          Width = 121
          Height = 21
          TabOrder = 2
          OnChange = EditChange
        end
      end
    end
    object SambaSheet: TTabSheet
      Caption = '&Samba'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label6: TLabel
        Left = 16
        Top = 120
        Width = 31
        Height = 13
        Caption = 'S&cript:'
      end
      object Label7: TLabel
        Left = 312
        Top = 72
        Width = 59
        Height = 13
        Caption = 'H&ome Drive:'
      end
      object Label8: TLabel
        Left = 16
        Top = 168
        Width = 59
        Height = 13
        Caption = '&Profile path:'
      end
      object Label13: TLabel
        Left = 16
        Top = 72
        Width = 62
        Height = 13
        Caption = '&Home Share:'
      end
      object Label21: TLabel
        Left = 16
        Top = 216
        Width = 57
        Height = 13
        Caption = 'D&escription:'
      end
      object Label36: TLabel
        Left = 16
        Top = 24
        Width = 39
        Height = 13
        Caption = '&Domain:'
      end
      object sambaLogonScript: TEdit
        Left = 16
        Top = 136
        Width = 353
        Height = 21
        TabOrder = 3
        OnChange = EditChange
      end
      object sambaHomeDrive: TComboBox
        Left = 312
        Top = 88
        Width = 57
        Height = 21
        Style = csDropDownList
        TabOrder = 2
        OnChange = sambaHomeDriveChange
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
      object sambaProfilePath: TEdit
        Left = 16
        Top = 184
        Width = 353
        Height = 21
        TabOrder = 4
        OnChange = EditChange
      end
      object sambaHomePath: TEdit
        Left = 16
        Top = 88
        Width = 289
        Height = 21
        TabOrder = 1
        OnChange = EditChange
      end
      object description: TMemo
        Left = 16
        Top = 232
        Width = 353
        Height = 57
        TabOrder = 5
        OnChange = EditChange
      end
      object cbDomain: TComboBox
        Left = 16
        Top = 40
        Width = 353
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        OnChange = cbDomainChange
      end
      object cbPwdMustChange: TCheckBox
        Left = 24
        Top = 320
        Width = 353
        Height = 17
        Caption = 'User &must change the password on next logon'
        TabOrder = 7
        OnClick = cbPwdMustChangeClick
      end
      object cbPwdCantChange: TCheckBox
        Left = 24
        Top = 296
        Width = 265
        Height = 17
        Caption = 'User can &not change the password'
        TabOrder = 6
        OnClick = cbPwdCantChangeClick
      end
      object BtnAdvanced: TButton
        Left = 296
        Top = 293
        Width = 75
        Height = 25
        Caption = '&Advanced...'
        TabOrder = 9
        OnClick = BtnAdvancedClick
      end
      object cbAccntDisabled: TCheckBox
        Left = 24
        Top = 344
        Width = 345
        Height = 17
        Caption = 'Account is &disabled'
        TabOrder = 8
        OnClick = cbAccntDisabledClick
      end
    end
    object MailSheet: TTabSheet
      Caption = '&Mail'
      ImageIndex = 6
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label10: TLabel
        Left = 16
        Top = 24
        Width = 44
        Height = 13
        Caption = 'Maildrop:'
      end
      object Label11: TLabel
        Left = 16
        Top = 72
        Width = 85
        Height = 13
        Caption = 'E-Mail Addresses:'
      end
      object maildrop: TEdit
        Left = 16
        Top = 40
        Width = 353
        Height = 21
        TabOrder = 0
        OnChange = EditChange
      end
      object mail: TListBox
        Left = 16
        Top = 88
        Width = 353
        Height = 241
        ItemHeight = 13
        TabOrder = 1
        OnClick = mailClick
        OnDblClick = EditMailBtnClick
      end
      object AddMailBtn: TButton
        Left = 16
        Top = 336
        Width = 75
        Height = 25
        Caption = '&Add'
        TabOrder = 2
        OnClick = AddMailBtnClick
      end
      object EditMailBtn: TButton
        Left = 96
        Top = 336
        Width = 75
        Height = 25
        Caption = '&Edit'
        Enabled = False
        TabOrder = 3
        OnClick = EditMailBtnClick
      end
      object DelMailBtn: TButton
        Left = 176
        Top = 336
        Width = 75
        Height = 25
        Caption = '&Remove'
        Enabled = False
        TabOrder = 4
        OnClick = DelMailBtnClick
      end
    end
    object OfficeSheet: TTabSheet
      Caption = '&Business'
      ImageIndex = 7
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label15: TLabel
        Left = 208
        Top = 208
        Width = 32
        Height = 13
        Caption = 'P&ager:'
      end
      object Label18: TLabel
        Left = 16
        Top = 64
        Width = 34
        Height = 13
        Caption = '&Street:'
      end
      object Label19: TLabel
        Left = 16
        Top = 208
        Width = 75
        Height = 13
        Caption = 'State/&Province:'
      end
      object Label22: TLabel
        Left = 208
        Top = 112
        Width = 34
        Height = 13
        Caption = 'P&hone:'
      end
      object Label24: TLabel
        Left = 112
        Top = 208
        Width = 46
        Height = 13
        Caption = '&Zip Code:'
      end
      object Label25: TLabel
        Left = 208
        Top = 64
        Width = 33
        Height = 13
        Caption = '&Office:'
      end
      object Label27: TLabel
        Left = 208
        Top = 16
        Width = 41
        Height = 13
        Caption = 'P&osition:'
      end
      object Label29: TLabel
        Left = 16
        Top = 16
        Width = 49
        Height = 13
        Caption = 'C&ompany:'
      end
      object Label30: TLabel
        Left = 208
        Top = 160
        Width = 22
        Height = 13
        Caption = '&Fax:'
      end
      object Label31: TLabel
        Left = 16
        Top = 160
        Width = 23
        Height = 13
        Caption = '&City:'
      end
      object pager: TEdit
        Left = 208
        Top = 224
        Width = 161
        Height = 21
        TabOrder = 9
        OnChange = EditChange
      end
      object postalAddress: TMemo
        Left = 16
        Top = 80
        Width = 177
        Height = 73
        TabOrder = 1
        OnChange = EditChange
      end
      object st: TEdit
        Left = 16
        Top = 224
        Width = 89
        Height = 21
        TabOrder = 3
        OnChange = EditChange
      end
      object telephoneNumber: TEdit
        Left = 208
        Top = 128
        Width = 161
        Height = 21
        TabOrder = 7
        OnChange = EditChange
      end
      object postalCode: TEdit
        Left = 112
        Top = 224
        Width = 81
        Height = 21
        TabOrder = 4
        OnChange = EditChange
      end
      object physicalDeliveryOfficeName: TEdit
        Left = 208
        Top = 80
        Width = 161
        Height = 21
        TabOrder = 6
        OnChange = EditChange
      end
      object o: TEdit
        Left = 16
        Top = 32
        Width = 177
        Height = 21
        TabOrder = 0
        OnChange = EditChange
      end
      object facsimileTelephoneNumber: TEdit
        Left = 208
        Top = 176
        Width = 161
        Height = 21
        TabOrder = 8
        OnChange = EditChange
      end
      object l: TEdit
        Left = 16
        Top = 176
        Width = 177
        Height = 21
        TabOrder = 2
        OnChange = EditChange
      end
      object title: TEdit
        Left = 208
        Top = 32
        Width = 161
        Height = 21
        TabOrder = 5
        OnChange = EditChange
      end
    end
    object PrivateSheet: TTabSheet
      Caption = '&Personal'
      ImageIndex = 8
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label17: TLabel
        Left = 16
        Top = 24
        Width = 43
        Height = 13
        Caption = '&Address:'
      end
      object Label23: TLabel
        Left = 16
        Top = 192
        Width = 22
        Height = 13
        Caption = '&Fax:'
      end
      object Label26: TLabel
        Left = 16
        Top = 144
        Width = 34
        Height = 13
        Caption = '&Phone:'
      end
      object Label28: TLabel
        Left = 16
        Top = 240
        Width = 34
        Height = 13
        Caption = '&Mobile:'
      end
      object Label41: TLabel
        Left = 224
        Top = 144
        Width = 32
        Height = 13
        Caption = 'Photo:'
      end
      object homePostalAddress: TMemo
        Left = 16
        Top = 40
        Width = 353
        Height = 89
        TabOrder = 0
        OnChange = EditChange
      end
      object otherFacsimiletelephoneNumber: TEdit
        Left = 16
        Top = 208
        Width = 185
        Height = 21
        Color = clBtnFace
        Enabled = False
        TabOrder = 2
      end
      object homePhone: TEdit
        Left = 16
        Top = 160
        Width = 185
        Height = 21
        TabOrder = 1
        OnChange = EditChange
      end
      object mobile: TEdit
        Left = 16
        Top = 256
        Width = 185
        Height = 21
        TabOrder = 3
        OnChange = EditChange
      end
      object ImagePanel: TPanel
        Left = 224
        Top = 160
        Width = 145
        Height = 169
        BevelOuter = bvLowered
        Caption = 'JPeg Image'
        TabOrder = 4
        object Image1: TImage
          Left = 1
          Top = 1
          Width = 143
          Height = 167
          Align = alClient
          Center = True
        end
      end
      object OpenPictureBtn: TButton
        Left = 224
        Top = 332
        Width = 73
        Height = 25
        Caption = 'Open...'
        TabOrder = 5
        OnClick = OpenPictureBtnClick
      end
      object DeleteJpegBtn: TButton
        Left = 304
        Top = 332
        Width = 67
        Height = 25
        Caption = 'Delete'
        Enabled = False
        TabOrder = 6
        OnClick = DeleteJpegBtnClick
      end
    end
    object GroupSheet: TTabSheet
      Caption = '&Membership'
      ImageIndex = 9
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label34: TLabel
        Left = 16
        Top = 72
        Width = 42
        Height = 13
        Caption = 'M&ember:'
      end
      object Label33: TLabel
        Left = 16
        Top = 24
        Width = 71
        Height = 13
        Caption = '&Primary group:'
      end
      object GroupList: TListView
        Left = 16
        Top = 88
        Width = 353
        Height = 241
        Columns = <
          item
            Caption = 'Name'
            Width = 160
          end
          item
            Caption = 'Description'
            Width = 250
          end>
        HideSelection = False
        TabOrder = 2
        ViewStyle = vsReport
        OnColumnClick = ListViewColumnClick
        OnCompare = ListViewCompare
        OnDeletion = GroupListDeletion
      end
      object AddGroupBtn: TButton
        Left = 16
        Top = 336
        Width = 75
        Height = 25
        Caption = '&Add'
        Enabled = False
        TabOrder = 3
        OnClick = AddGroupBtnClick
      end
      object RemoveGroupBtn: TButton
        Left = 96
        Top = 336
        Width = 75
        Height = 25
        Caption = '&Remove'
        Enabled = False
        TabOrder = 4
        OnClick = RemoveGroupBtnClick
      end
      object PrimaryGroupBtn: TButton
        Left = 312
        Top = 40
        Width = 59
        Height = 25
        Caption = '&Set...'
        TabOrder = 1
        OnClick = PrimaryGroupBtnClick
      end
      object edGidNumber: TEdit
        Left = 16
        Top = 40
        Width = 289
        Height = 21
        Enabled = False
        TabOrder = 0
      end
      object cbxGroups: TComboBox
        Left = 200
        Top = 336
        Width = 169
        Height = 21
        Style = csDropDownList
        TabOrder = 5
        OnChange = cbxGroupsChange
        Items.Strings = (
          'All groups'
          'Posix groups'
          'Samba groups'
          'Mail groups')
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 396
    Width = 394
    Height = 55
    Align = alBottom
    TabOrder = 1
    object OkBtn: TButton
      Left = 120
      Top = 16
      Width = 75
      Height = 25
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object CancelBtn: TButton
      Left = 200
      Top = 16
      Width = 75
      Height = 25
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    Left = 316
    Top = 400
  end
end
