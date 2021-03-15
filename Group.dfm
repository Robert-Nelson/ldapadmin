object GroupDlg: TGroupDlg
  Left = 396
  Top = 179
  BorderStyle = bsDialog
  Caption = 'Create group'
  ClientHeight = 472
  ClientWidth = 411
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 61
    Height = 13
    Caption = '&Group name:'
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 56
    Height = 13
    Caption = '&Description:'
  end
  object edName: TEdit
    Left = 16
    Top = 32
    Width = 377
    Height = 21
    TabOrder = 0
    OnChange = edNameChange
  end
  object edDescription: TEdit
    Left = 16
    Top = 80
    Width = 377
    Height = 21
    TabOrder = 1
    OnChange = edDescriptionChange
  end
  object OkBtn: TButton
    Left = 248
    Top = 440
    Width = 75
    Height = 25
    Caption = '&OK'
    Enabled = False
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 328
    Top = 440
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 112
    Width = 393
    Height = 321
    ActivePage = TabSheet1
    TabOrder = 4
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = '&Members'
      object UserList: TListView
        Left = 8
        Top = 8
        Width = 369
        Height = 249
        Columns = <
          item
            Caption = 'Name'
            Width = 120
          end
          item
            Caption = 'Path'
            Width = 220
          end>
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = ListViewColumnClick
        OnCompare = ListViewCompare
        OnDeletion = UserListDeletion
      end
      object AddUserBtn: TButton
        Left = 8
        Top = 264
        Width = 75
        Height = 25
        Caption = '&Add'
        TabOrder = 1
        OnClick = AddUserBtnClick
      end
      object RemoveUserBtn: TButton
        Left = 88
        Top = 264
        Width = 75
        Height = 25
        Caption = '&Remove'
        Enabled = False
        TabOrder = 2
        OnClick = RemoveUserBtnClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = '&Advanced'
      ImageIndex = 2
      object Label3: TLabel
        Left = 24
        Top = 112
        Width = 73
        Height = 13
        Caption = 'Samba domain:'
      end
      object Label4: TLabel
        Left = 272
        Top = 112
        Width = 37
        Height = 13
        Caption = 'NT-Rid:'
      end
      object Bevel1: TBevel
        Left = 24
        Top = 40
        Width = 337
        Height = 9
        Shape = bsBottomLine
      end
      object Label5: TLabel
        Left = 24
        Top = 64
        Width = 66
        Height = 13
        Caption = 'Display name:'
      end
      object cbSambaDomain: TComboBox
        Left = 24
        Top = 128
        Width = 233
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 2
        OnChange = cbSambaDomainChange
      end
      object RadioGroup1: TRadioGroup
        Left = 24
        Top = 160
        Width = 337
        Height = 113
        Caption = 'Group type:'
        ItemIndex = 0
        Items.Strings = (
          'Domain group'
          'Local group'
          'Built-in group:')
        TabOrder = 4
        OnClick = RadioGroup1Click
      end
      object cbBuiltin: TComboBox
        Left = 128
        Top = 232
        Width = 209
        Height = 21
        Style = csDropDownList
        Color = clBtnFace
        Enabled = False
        ItemHeight = 13
        TabOrder = 5
        OnChange = cbBuiltinChange
        Items.Strings = (
          'Domain Admins'
          'Domain Users'
          'Domain Guests')
      end
      object edRid: TEdit
        Left = 272
        Top = 128
        Width = 89
        Height = 21
        TabOrder = 3
      end
      object cbSambaGroup: TCheckBox
        Left = 24
        Top = 24
        Width = 153
        Height = 17
        Caption = 'Samba domain mapping'
        TabOrder = 0
        OnClick = cbSambaGroupClick
      end
      object edDisplayName: TEdit
        Left = 24
        Top = 80
        Width = 337
        Height = 21
        TabOrder = 1
      end
    end
    object TabSheet3: TTabSheet
      Caption = '&Resources'
      ImageIndex = 1
      object AddResBtn: TButton
        Left = 8
        Top = 248
        Width = 75
        Height = 25
        Caption = '&Add'
        TabOrder = 0
        OnClick = AddResBtnClick
      end
      object DelResBtn: TButton
        Left = 168
        Top = 248
        Width = 75
        Height = 25
        Caption = '&Remove'
        Enabled = False
        TabOrder = 1
        OnClick = DelResBtnClick
      end
      object EditResBtn: TButton
        Left = 88
        Top = 248
        Width = 75
        Height = 25
        Caption = '&Edit...'
        Enabled = False
        TabOrder = 2
        OnClick = EditResBtnClick
      end
      object ResourceList: TListBox
        Left = 8
        Top = 8
        Width = 369
        Height = 233
        ItemHeight = 13
        TabOrder = 3
        OnClick = ResourceListClick
      end
    end
  end
end
