object ADUserDlg: TADUserDlg
  Left = 423
  Top = 181
  ActiveControl = givenName
  BorderStyle = bsDialog
  Caption = 'Create User'
  ClientHeight = 450
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
    Height = 395
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
        Top = 208
        Width = 187
        Height = 13
        Caption = '&User logon name (user principal name):'
      end
      object Label5: TLabel
        Left = 160
        Top = 16
        Width = 35
        Height = 13
        Caption = '&Initials:'
      end
      object Label21: TLabel
        Left = 16
        Top = 112
        Width = 57
        Height = 13
        Caption = 'D&escription:'
      end
      object Label12: TLabel
        Left = 16
        Top = 256
        Width = 78
        Height = 13
        Caption = '&NT Logon name:'
      end
      object Label10: TLabel
        Left = 16
        Top = 160
        Width = 52
        Height = 13
        Caption = 'Username:'
      end
      object Label13: TLabel
        Left = 16
        Top = 304
        Width = 50
        Height = 13
        Caption = 'Pass&word:'
        Visible = False
      end
      object Label14: TLabel
        Left = 196
        Top = 304
        Width = 90
        Height = 13
        Caption = 'Confirm password:'
        Visible = False
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
      object userPrincipalName: TEdit
        Left = 16
        Top = 224
        Width = 174
        Height = 21
        TabOrder = 6
        OnChange = userPrincipalNameChange
        OnExit = userPrincipalNameExit
      end
      object initials: TEdit
        Left = 160
        Top = 32
        Width = 57
        Height = 21
        TabOrder = 1
        OnChange = EditChange
      end
      object samAccountName: TEdit
        Left = 196
        Top = 272
        Width = 173
        Height = 21
        TabOrder = 8
        OnChange = EditChange
      end
      object description: TEdit
        Left = 16
        Top = 128
        Width = 353
        Height = 21
        TabOrder = 4
        OnChange = EditChange
      end
      object cbUPNDomain: TComboBox
        Left = 196
        Top = 224
        Width = 173
        Height = 21
        TabOrder = 7
        OnChange = cbUPNDomainChange
        OnDropDown = cbUPNDomainDropDown
      end
      object NTDomain: TEdit
        Left = 16
        Top = 272
        Width = 174
        Height = 21
        Enabled = False
        TabOrder = 9
      end
      object cn: TEdit
        Left = 16
        Top = 176
        Width = 353
        Height = 21
        Enabled = False
        TabOrder = 5
        OnChange = EditChange
      end
      object edPassword1: TEdit
        Left = 16
        Top = 320
        Width = 174
        Height = 21
        PasswordChar = '*'
        TabOrder = 10
        Visible = False
      end
      object edPassword2: TEdit
        Left = 196
        Top = 320
        Width = 173
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        PasswordChar = '*'
        TabOrder = 11
        Visible = False
      end
    end
    object OptionsSheet: TTabSheet
      Caption = 'Account options'
      ImageIndex = 6
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object rgAccountExpires: TRadioGroup
        Left = 16
        Top = 238
        Width = 353
        Height = 89
        Caption = '&Account expires'
        ItemIndex = 0
        Items.Strings = (
          'Never'
          'On:')
        TabOrder = 3
        OnClick = rgAccountExpiresClick
      end
      object DatePicker: TDateTimePicker
        Left = 78
        Top = 294
        Width = 107
        Height = 21
        Date = 38076.771625092600000000
        Time = 38076.771625092600000000
        Color = clBtnFace
        Enabled = False
        TabOrder = 4
        OnChange = DatePickerChange
      end
      object clbxAccountOptions: TCheckListBox
        Left = 16
        Top = 51
        Width = 353
        Height = 150
        OnClickCheck = clbxAccountOptionsClickCheck
        ItemHeight = 13
        Items.Strings = (
          'User must change the password on next logon'
          'User cannot change password'
          'Password never expires'
          'Store password using reversible encryption'
          'Account is disabled'
          'Smartcard is required for interactive logon'
          'Account is enabled for delegation'
          'Account is sensitive and cannot be delegated'
          'Use Kerberos DES encryption'
          'Do not require Kerberos preauthentication'
          'Password is not required')
        TabOrder = 1
      end
      object BtnAdditional: TButton
        Left = 277
        Top = 207
        Width = 92
        Height = 25
        Caption = '&Additional...'
        TabOrder = 2
        OnClick = BtnAdditionalClick
      end
      object cbAccountLockout: TCheckBox
        Left = 16
        Top = 20
        Width = 345
        Height = 17
        Caption = 'Account is locked out'
        Enabled = False
        TabOrder = 0
        OnClick = cbAccountLockoutClick
      end
      object TimePicker: TDateTimePicker
        Left = 244
        Top = 294
        Width = 108
        Height = 21
        Date = 42745.000000000000000000
        Time = 42745.000000000000000000
        ShowCheckbox = True
        Enabled = False
        Kind = dtkTime
        TabOrder = 5
        OnChange = TimePickerChange
      end
      object TimeLabel: TStaticText
        Left = 219
        Top = 298
        Width = 19
        Height = 17
        Alignment = taRightJustify
        Caption = 'At:'
        TabOrder = 6
      end
    end
    object ProfileSheet: TTabSheet
      Caption = '&Profile'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label6: TLabel
        Left = 18
        Top = 80
        Width = 31
        Height = 13
        Caption = 'S&cript:'
      end
      object Label7: TLabel
        Left = 312
        Top = 29
        Width = 59
        Height = 13
        Caption = 'H&ome Drive:'
      end
      object Label8: TLabel
        Left = 18
        Top = 131
        Width = 59
        Height = 13
        Caption = '&Profile path:'
      end
      object Label9: TLabel
        Left = 17
        Top = 29
        Width = 78
        Height = 13
        Caption = '&Home Directory:'
      end
      object scriptPath: TEdit
        Left = 17
        Top = 96
        Width = 353
        Height = 21
        TabOrder = 2
        OnChange = EditChange
      end
      object homeDrive: TComboBox
        Left = 312
        Top = 45
        Width = 57
        Height = 21
        Style = csDropDownList
        TabOrder = 1
        OnChange = homeDriveChange
        Items.Strings = (
          ''
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
      object profilePath: TEdit
        Left = 18
        Top = 147
        Width = 353
        Height = 21
        TabOrder = 3
        OnChange = EditChange
      end
      object homeDirectory: TEdit
        Left = 18
        Top = 45
        Width = 288
        Height = 21
        TabOrder = 0
        OnChange = EditChange
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
        Top = 192
        Width = 32
        Height = 13
        Caption = 'P&ager:'
      end
      object Label18: TLabel
        Left = 16
        Top = 56
        Width = 34
        Height = 13
        Caption = '&Street:'
      end
      object Label19: TLabel
        Left = 16
        Top = 192
        Width = 75
        Height = 13
        Caption = 'State/&Province:'
      end
      object Label22: TLabel
        Left = 208
        Top = 98
        Width = 34
        Height = 13
        Caption = 'P&hone:'
      end
      object Label24: TLabel
        Left = 112
        Top = 192
        Width = 46
        Height = 13
        Caption = '&Zip Code:'
      end
      object Label25: TLabel
        Left = 208
        Top = 53
        Width = 33
        Height = 13
        Caption = '&Office:'
      end
      object Label27: TLabel
        Left = 208
        Top = 8
        Width = 41
        Height = 13
        Caption = 'P&osition:'
      end
      object Label29: TLabel
        Left = 16
        Top = 8
        Width = 49
        Height = 13
        Caption = 'C&ompany:'
      end
      object Label30: TLabel
        Left = 208
        Top = 144
        Width = 22
        Height = 13
        Caption = '&Fax:'
      end
      object Label31: TLabel
        Left = 16
        Top = 144
        Width = 23
        Height = 13
        Caption = '&City:'
      end
      object Label11: TLabel
        Left = 16
        Top = 242
        Width = 74
        Height = 13
        Caption = 'E-Mail Address:'
      end
      object Label16: TLabel
        Left = 16
        Top = 290
        Width = 53
        Height = 13
        Caption = 'Web page:'
      end
      object pager: TEdit
        Left = 208
        Top = 208
        Width = 161
        Height = 21
        TabOrder = 9
        OnChange = EditChange
      end
      object streetAddress: TMemo
        Left = 16
        Top = 72
        Width = 186
        Height = 64
        TabOrder = 1
        OnChange = EditChange
      end
      object st: TEdit
        Left = 16
        Top = 208
        Width = 89
        Height = 21
        TabOrder = 3
        OnChange = EditChange
      end
      object telephoneNumber: TEdit
        Left = 208
        Top = 115
        Width = 161
        Height = 21
        TabOrder = 7
        OnChange = EditChange
      end
      object postalCode: TEdit
        Left = 112
        Top = 208
        Width = 90
        Height = 21
        TabOrder = 4
        OnChange = EditChange
      end
      object physicalDeliveryOfficeName: TEdit
        Left = 208
        Top = 72
        Width = 161
        Height = 21
        TabOrder = 6
        OnChange = EditChange
      end
      object o: TEdit
        Left = 16
        Top = 24
        Width = 186
        Height = 21
        TabOrder = 0
        OnChange = EditChange
      end
      object facsimileTelephoneNumber: TEdit
        Left = 208
        Top = 160
        Width = 161
        Height = 21
        TabOrder = 8
        OnChange = EditChange
      end
      object l: TEdit
        Left = 16
        Top = 160
        Width = 186
        Height = 21
        TabOrder = 2
        OnChange = EditChange
      end
      object title: TEdit
        Left = 208
        Top = 24
        Width = 161
        Height = 21
        TabOrder = 5
        OnChange = EditChange
      end
      object mail: TEdit
        Left = 16
        Top = 257
        Width = 186
        Height = 21
        TabOrder = 10
        OnChange = EditChange
      end
      object wWWHomePage: TEdit
        Left = 16
        Top = 305
        Width = 353
        Height = 21
        TabOrder = 11
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
        Left = 15
        Top = 12
        Width = 24
        Height = 13
        Caption = '&Info:'
      end
      object Label23: TLabel
        Left = 16
        Top = 184
        Width = 22
        Height = 13
        Caption = '&Fax:'
      end
      object Label26: TLabel
        Left = 16
        Top = 136
        Width = 34
        Height = 13
        Caption = '&Phone:'
      end
      object Label28: TLabel
        Left = 16
        Top = 232
        Width = 34
        Height = 13
        Caption = '&Mobile:'
      end
      object Label41: TLabel
        Left = 224
        Top = 136
        Width = 32
        Height = 13
        Caption = 'Photo:'
      end
      object info: TMemo
        Left = 15
        Top = 31
        Width = 353
        Height = 89
        TabOrder = 0
        OnChange = EditChange
      end
      object otherFacsimiletelephoneNumber: TEdit
        Left = 16
        Top = 200
        Width = 185
        Height = 21
        Color = clBtnFace
        Enabled = False
        TabOrder = 2
        OnChange = EditChange
      end
      object homePhone: TEdit
        Left = 16
        Top = 155
        Width = 185
        Height = 21
        TabOrder = 1
        OnChange = EditChange
      end
      object mobile: TEdit
        Left = 16
        Top = 251
        Width = 185
        Height = 21
        TabOrder = 3
        OnChange = EditChange
      end
      object ImagePanel: TPanel
        Left = 224
        Top = 152
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
        Top = 324
        Width = 73
        Height = 25
        Caption = 'Open...'
        TabOrder = 5
        OnClick = OpenPictureBtnClick
      end
      object DeleteJpegBtn: TButton
        Left = 301
        Top = 324
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
        Top = 56
        Width = 42
        Height = 13
        Caption = 'M&ember:'
      end
      object Label33: TLabel
        Left = 16
        Top = 8
        Width = 71
        Height = 13
        Caption = '&Primary group:'
      end
      object GroupList: TListView
        Left = 16
        Top = 73
        Width = 353
        Height = 241
        Columns = <
          item
            Caption = 'Name'
            Width = 140
          end
          item
            Caption = 'Path'
            Width = 205
          end>
        HideSelection = False
        TabOrder = 2
        ViewStyle = vsReport
        OnColumnClick = ListViewColumnClick
        OnCompare = ListViewCompare
      end
      object AddGroupBtn: TButton
        Left = 16
        Top = 320
        Width = 75
        Height = 25
        Caption = '&Add'
        TabOrder = 3
        OnClick = AddGroupBtnClick
      end
      object RemoveGroupBtn: TButton
        Left = 97
        Top = 320
        Width = 75
        Height = 25
        Caption = '&Remove'
        Enabled = False
        TabOrder = 4
        OnClick = RemoveGroupBtnClick
      end
      object PrimaryGroupBtn: TButton
        Left = 296
        Top = 22
        Width = 75
        Height = 25
        Caption = '&Set...'
        TabOrder = 1
        OnClick = PrimaryGroupBtnClick
      end
      object edPrimaryGroup: TEdit
        Left = 17
        Top = 24
        Width = 273
        Height = 21
        Enabled = False
        TabOrder = 0
      end
    end
    object TemplateSheet: TTabSheet
      Caption = '&Templates'
      ImageIndex = 7
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object CheckListBox: TCheckListBox
        Left = 3
        Top = 25
        Width = 380
        Height = 312
        OnClickCheck = CheckListBoxClickCheck
        ItemHeight = 24
        Sorted = True
        Style = lbOwnerDrawFixed
        TabOrder = 0
        OnClick = CheckListBoxClick
        OnDrawItem = CheckListBoxDrawItem
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 395
    Width = 394
    Height = 55
    Align = alBottom
    TabOrder = 1
    object OkBtn: TButton
      Left = 119
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
    object ApplyBtn: TButton
      Left = 281
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Appl&y'
      Enabled = False
      TabOrder = 2
      OnClick = ApplyBtnClick
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    Filter = 
      'All image files(*.gif;*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff;*.em' +
      'f;*.wmf)|*.gif;*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff;*.emf;*.wmf' +
      '|All files (*.*)|*.*|GIF Image (*.gif)|*.gif|JPEG Image File (*.' +
      'jpg)|*.jpg|JPEG Image File (*.jpeg)|*.jpeg|Portable Network Grap' +
      'hics (*.png)|*.png|Bitmaps (*.bmp)|*.bmp|TIFF Images (*.tif)|*.t' +
      'if|TIFF Images (*.tiff)|*.tiff|Enhanced Metafiles (*.emf)|*.emf|' +
      'Metafiles (*.wmf)|*.wmf'
    Left = 52
    Top = 400
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 16
    Top = 403
  end
end
