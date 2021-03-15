object MailGroupDlg: TMailGroupDlg
  Left = 399
  Top = 169
  BorderStyle = bsDialog
  Caption = 'Create mailing list'
  ClientHeight = 472
  ClientWidth = 410
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 62
    Height = 13
    Caption = '&Group name:'
    FocusControl = edName
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 57
    Height = 13
    Caption = '&Description:'
    FocusControl = edDescription
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
    TabOrder = 3
  end
  object CancelBtn: TButton
    Left = 328
    Top = 440
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 112
    Width = 393
    Height = 321
    ActivePage = TabSheet1
    TabOrder = 2
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
      Caption = 'E-Mail Addresses'
      ImageIndex = 1
      object Label3: TLabel
        Left = 8
        Top = 240
        Width = 100
        Height = 13
        Caption = 'Mail &routing address:'
      end
      object mail: TListBox
        Left = 8
        Top = 8
        Width = 369
        Height = 195
        ItemHeight = 13
        TabOrder = 0
        OnClick = mailClick
        OnDblClick = EditMailBtnClick
      end
      object AddMailBtn: TButton
        Left = 8
        Top = 208
        Width = 65
        Height = 25
        Caption = '&Add'
        TabOrder = 1
        OnClick = AddMailBtnClick
      end
      object EditMailBtn: TButton
        Left = 80
        Top = 208
        Width = 65
        Height = 25
        Caption = '&Edit'
        Enabled = False
        TabOrder = 2
        OnClick = EditMailBtnClick
      end
      object DelMailBtn: TButton
        Left = 152
        Top = 208
        Width = 65
        Height = 25
        Caption = '&Remove'
        Enabled = False
        TabOrder = 3
        OnClick = DelMailBtnClick
      end
      object edMailRoutingAddress: TEdit
        Left = 8
        Top = 256
        Width = 369
        Height = 21
        TabOrder = 4
        OnChange = edMailRoutingAddressChange
      end
    end
  end
end
