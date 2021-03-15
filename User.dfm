object UserDlg: TUserDlg
  Left = 423
  Top = 181
  BorderStyle = bsDialog
  Caption = 'User Properties'
  ClientHeight = 463
  ClientWidth = 394
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 394
    Height = 399
    ActivePage = AccountSheet
    Align = alClient
    TabOrder = 0
    OnChange = PageControlChange
    object AccountSheet: TTabSheet
      Caption = '&Account'
      object Label1: TLabel
        Left = 16
        Top = 24
        Width = 51
        Height = 13
        Caption = '&First name:'
      end
      object Label2: TLabel
        Left = 224
        Top = 24
        Width = 69
        Height = 13
        Caption = '&Second name:'
      end
      object Label3: TLabel
        Left = 16
        Top = 72
        Width = 66
        Height = 13
        Caption = '&Display name:'
      end
      object Label4: TLabel
        Left = 16
        Top = 120
        Width = 51
        Height = 13
        Caption = '&Username:'
      end
      object Label5: TLabel
        Left = 160
        Top = 24
        Width = 32
        Height = 13
        Caption = '&Initials:'
      end
      object Label9: TLabel
        Left = 16
        Top = 168
        Width = 76
        Height = 13
        Caption = '&Home Directory:'
      end
      object Label12: TLabel
        Left = 16
        Top = 216
        Width = 34
        Height = 13
        Caption = 'Gecos:'
      end
      object Label14: TLabel
        Left = 208
        Top = 120
        Width = 53
        Height = 13
        Caption = '&Login shell:'
      end
      object GroupBox1: TGroupBox
        Left = 16
        Top = 272
        Width = 353
        Height = 73
        Caption = 'Account properties'
        TabOrder = 10
      end
      object givenName: TEdit
        Left = 16
        Top = 40
        Width = 137
        Height = 21
        TabOrder = 0
      end
      object sn: TEdit
        Left = 224
        Top = 40
        Width = 145
        Height = 21
        TabOrder = 2
        OnExit = snExit
      end
      object displayName: TEdit
        Left = 16
        Top = 88
        Width = 353
        Height = 21
        TabOrder = 3
      end
      object uid: TEdit
        Left = 16
        Top = 136
        Width = 185
        Height = 21
        TabOrder = 4
        OnExit = uidExit
      end
      object initials: TEdit
        Left = 160
        Top = 40
        Width = 57
        Height = 21
        TabOrder = 1
      end
      object homeDirectory: TEdit
        Left = 16
        Top = 184
        Width = 353
        Height = 21
        TabOrder = 6
      end
      object gecos: TEdit
        Left = 16
        Top = 232
        Width = 353
        Height = 21
        TabOrder = 7
      end
      object loginShell: TEdit
        Left = 208
        Top = 136
        Width = 161
        Height = 21
        TabOrder = 5
      end
      object cbSamba: TCheckBox
        Left = 56
        Top = 304
        Width = 97
        Height = 17
        Caption = 'Samba Account'
        TabOrder = 8
        OnClick = cbSambaClick
      end
      object cbMail: TCheckBox
        Left = 216
        Top = 304
        Width = 97
        Height = 17
        Caption = 'Mail account'
        TabOrder = 9
        OnClick = cbMailClick
      end
    end
    object SambaSheet: TTabSheet
      Caption = '&Samba'
      ImageIndex = 5
      object Label6: TLabel
        Left = 16
        Top = 72
        Width = 30
        Height = 13
        Caption = 'S&cript:'
      end
      object Label7: TLabel
        Left = 312
        Top = 24
        Width = 59
        Height = 13
        Caption = 'H&ome Drive:'
      end
      object Label8: TLabel
        Left = 16
        Top = 128
        Width = 56
        Height = 13
        Caption = '&Profile path:'
      end
      object Label13: TLabel
        Left = 16
        Top = 24
        Width = 62
        Height = 13
        Caption = '&Home Share:'
      end
      object Label21: TLabel
        Left = 16
        Top = 184
        Width = 56
        Height = 13
        Caption = '&Description:'
      end
      object scriptPath: TEdit
        Left = 16
        Top = 88
        Width = 353
        Height = 21
        TabOrder = 2
      end
      object homeDrive: TComboBox
        Left = 312
        Top = 40
        Width = 57
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        OnChange = ComboChange
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
      object profilePath: TEdit
        Left = 16
        Top = 144
        Width = 353
        Height = 21
        TabOrder = 3
      end
      object smbHome: TEdit
        Left = 16
        Top = 40
        Width = 289
        Height = 21
        TabOrder = 0
      end
      object description: TMemo
        Left = 16
        Top = 200
        Width = 353
        Height = 89
        TabOrder = 4
      end
    end
    object MailSheet: TTabSheet
      Caption = '&Mail'
      ImageIndex = 6
      object Label10: TLabel
        Left = 16
        Top = 24
        Width = 43
        Height = 13
        Caption = 'Maildrop:'
      end
      object Label11: TLabel
        Left = 16
        Top = 72
        Width = 84
        Height = 13
        Caption = 'E-Mail Addresses:'
      end
      object maildrop: TEdit
        Left = 16
        Top = 40
        Width = 353
        Height = 21
        TabOrder = 0
      end
      object mail: TListBox
        Left = 16
        Top = 88
        Width = 353
        Height = 233
        ItemHeight = 13
        TabOrder = 1
        OnClick = mailClick
      end
      object AddMailBtn: TButton
        Left = 16
        Top = 328
        Width = 65
        Height = 25
        Caption = '&Add'
        TabOrder = 2
        OnClick = AddMailBtnClick
      end
      object EditMailBtn: TButton
        Left = 88
        Top = 328
        Width = 65
        Height = 25
        Caption = '&Edit'
        Enabled = False
        TabOrder = 3
        OnClick = EditMailBtnClick
      end
      object DelMailBtn: TButton
        Left = 160
        Top = 328
        Width = 65
        Height = 25
        Caption = '&Remove'
        Enabled = False
        TabOrder = 4
        OnClick = DelMailBtnClick
      end
      object UpBtn: TButton
        Left = 232
        Top = 328
        Width = 65
        Height = 25
        Caption = '&Up'
        Enabled = False
        TabOrder = 5
        OnClick = UpBtnClick
      end
      object DownBtn: TButton
        Left = 304
        Top = 328
        Width = 65
        Height = 25
        Caption = '&Down'
        Enabled = False
        TabOrder = 6
        OnClick = DownBtnClick
      end
    end
    object OfficeSheet: TTabSheet
      Caption = '&Business'
      ImageIndex = 7
      object Label15: TLabel
        Left = 208
        Top = 216
        Width = 31
        Height = 13
        Caption = 'P&ager:'
      end
      object Label16: TLabel
        Left = 16
        Top = 312
        Width = 47
        Height = 13
        Caption = '&Web Site:'
      end
      object Label18: TLabel
        Left = 16
        Top = 72
        Width = 31
        Height = 13
        Caption = '&Street:'
      end
      object Label19: TLabel
        Left = 16
        Top = 216
        Width = 78
        Height = 13
        Caption = 'State/&Province::'
      end
      object Label20: TLabel
        Left = 208
        Top = 264
        Width = 52
        Height = 13
        Caption = 'IP-&Telefon:'
      end
      object Label22: TLabel
        Left = 208
        Top = 120
        Width = 34
        Height = 13
        Caption = 'P&hone:'
      end
      object Label24: TLabel
        Left = 112
        Top = 216
        Width = 46
        Height = 13
        Caption = '&Zip Code:'
      end
      object Label25: TLabel
        Left = 208
        Top = 72
        Width = 31
        Height = 13
        Caption = '&Office:'
      end
      object Label27: TLabel
        Left = 208
        Top = 24
        Width = 40
        Height = 13
        Caption = 'P&osition:'
      end
      object Label29: TLabel
        Left = 16
        Top = 24
        Width = 47
        Height = 13
        Caption = 'C&ompany:'
      end
      object Label30: TLabel
        Left = 208
        Top = 168
        Width = 20
        Height = 13
        Caption = '&Fax:'
      end
      object Label31: TLabel
        Left = 16
        Top = 168
        Width = 20
        Height = 13
        Caption = '&City:'
      end
      object Label32: TLabel
        Left = 16
        Top = 264
        Width = 39
        Height = 13
        Caption = 'Countr&y:'
      end
      object pager: TEdit
        Left = 208
        Top = 232
        Width = 161
        Height = 21
        TabOrder = 10
      end
      object URL: TEdit
        Left = 16
        Top = 328
        Width = 353
        Height = 21
        TabOrder = 12
      end
      object postalAddress: TMemo
        Left = 16
        Top = 88
        Width = 177
        Height = 73
        TabOrder = 1
      end
      object st: TEdit
        Left = 16
        Top = 232
        Width = 89
        Height = 21
        TabOrder = 3
      end
      object IPPhone: TEdit
        Left = 208
        Top = 280
        Width = 161
        Height = 21
        TabOrder = 11
      end
      object telephoneNumber: TEdit
        Left = 208
        Top = 136
        Width = 161
        Height = 21
        TabOrder = 8
      end
      object postalCode: TEdit
        Left = 112
        Top = 232
        Width = 81
        Height = 21
        TabOrder = 4
      end
      object physicalDeliveryOfficeName: TEdit
        Left = 208
        Top = 88
        Width = 161
        Height = 21
        TabOrder = 7
      end
      object title: TComboBox
        Left = 208
        Top = 40
        Width = 161
        Height = 21
        ItemHeight = 13
        TabOrder = 6
        OnChange = ComboChange
      end
      object o: TEdit
        Left = 16
        Top = 40
        Width = 177
        Height = 21
        TabOrder = 0
      end
      object facsimileTelephoneNumber: TEdit
        Left = 208
        Top = 184
        Width = 161
        Height = 21
        TabOrder = 9
      end
      object l: TEdit
        Left = 16
        Top = 184
        Width = 177
        Height = 21
        TabOrder = 2
      end
      object c: TEdit
        Left = 16
        Top = 280
        Width = 177
        Height = 21
        TabOrder = 5
      end
    end
    object PrivateSheet: TTabSheet
      Caption = '&Personal'
      ImageIndex = 8
      object Label17: TLabel
        Left = 24
        Top = 24
        Width = 41
        Height = 13
        Caption = '&Address:'
      end
      object Label23: TLabel
        Left = 24
        Top = 192
        Width = 20
        Height = 13
        Caption = '&Fax:'
      end
      object Label26: TLabel
        Left = 24
        Top = 144
        Width = 34
        Height = 13
        Caption = '&Phone:'
      end
      object Label28: TLabel
        Left = 24
        Top = 240
        Width = 34
        Height = 13
        Caption = '&Mobile:'
      end
      object homePostalAddress: TMemo
        Left = 24
        Top = 40
        Width = 337
        Height = 89
        TabOrder = 0
      end
      object otherFacsimiletelephoneNumber: TEdit
        Left = 24
        Top = 208
        Width = 185
        Height = 21
        TabOrder = 2
      end
      object homePhone: TEdit
        Left = 24
        Top = 160
        Width = 185
        Height = 21
        TabOrder = 1
      end
      object mobile: TEdit
        Left = 24
        Top = 256
        Width = 185
        Height = 21
        TabOrder = 3
      end
    end
    object GroupSheet: TTabSheet
      Caption = '&Membership'
      ImageIndex = 9
      object Label34: TLabel
        Left = 16
        Top = 72
        Width = 44
        Height = 13
        Caption = 'M&ember::'
      end
      object Label33: TLabel
        Left = 16
        Top = 24
        Width = 70
        Height = 13
        Caption = '&Primary group::'
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
      object gidNumber: TEdit
        Left = 16
        Top = 40
        Width = 289
        Height = 21
        Enabled = False
        TabOrder = 0
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 399
    Width = 394
    Height = 64
    Align = alBottom
    TabOrder = 1
    object OkBtn: TButton
      Left = 120
      Top = 24
      Width = 75
      Height = 25
      Caption = '&OK'
      ModalResult = 1
      TabOrder = 0
    end
    object CancelBtn: TButton
      Left = 200
      Top = 24
      Width = 75
      Height = 25
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
