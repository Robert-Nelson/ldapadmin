object AdComputerDlg: TAdComputerDlg
  Left = 396
  Top = 179
  ActiveControl = cn
  BorderStyle = bsDialog
  Caption = 'Create computer'
  ClientHeight = 376
  ClientWidth = 411
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poMainFormCenter
  OnClose = FormClose
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object OkBtn: TButton
    Left = 167
    Top = 343
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 247
    Top = 343
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 411
    Height = 337
    ActivePage = GeneralSheet
    Align = alTop
    TabOrder = 2
    OnChange = PageControlChange
    object GeneralSheet: TTabSheet
      Caption = '&General'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label5: TLabel
        Left = 16
        Top = 112
        Width = 46
        Height = 13
        Caption = 'NT name:'
      end
      object Label3: TLabel
        Left = 16
        Top = 160
        Width = 44
        Height = 13
        Caption = 'Location:'
      end
      object Label1: TLabel
        Left = 16
        Top = 16
        Width = 80
        Height = 13
        Caption = 'Computer &name:'
      end
      object Label2: TLabel
        Left = 16
        Top = 64
        Width = 57
        Height = 13
        Caption = 'D&escription:'
      end
      object samAccountName: TEdit
        Left = 16
        Top = 128
        Width = 374
        Height = 21
        MaxLength = 15
        TabOrder = 2
        OnChange = samAccountNameChange
      end
      object location: TEdit
        Left = 16
        Top = 176
        Width = 374
        Height = 21
        TabOrder = 3
        OnChange = EditChange
      end
      object cbxServerTrustAccount: TCheckBox
        Left = 16
        Top = 224
        Width = 374
        Height = 17
        Caption = 'Assign this computer account as backup domain controller'
        TabOrder = 4
      end
      object cbxNTAccount: TCheckBox
        Left = 16
        Top = 256
        Width = 374
        Height = 17
        Caption = 'Assign this computer account as a pre'#8211'Windows 2000 computer'
        TabOrder = 5
      end
      object cn: TEdit
        Left = 16
        Top = 32
        Width = 374
        Height = 21
        MaxLength = 63
        TabOrder = 0
        OnChange = cnChange
      end
      object description: TEdit
        Left = 16
        Top = 80
        Width = 374
        Height = 21
        TabOrder = 1
        OnChange = EditChange
      end
      object Panel1: TPanel
        Left = 0
        Top = 206
        Width = 403
        Height = 103
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 6
        Visible = False
        object Label4: TLabel
          Left = 16
          Top = 4
          Width = 45
          Height = 13
          Caption = 'Function:'
        end
        object edFunction: TEdit
          Left = 16
          Top = 23
          Width = 374
          Height = 21
          Enabled = False
          TabOrder = 0
        end
        object cbxTrustForDelegation: TCheckBox
          Left = 16
          Top = 64
          Width = 374
          Height = 17
          Caption = 'Trust this computer for delegation '
          TabOrder = 1
          OnClick = cbxTrustForDelegationClick
        end
      end
    end
    object MembershipSheet: TTabSheet
      Caption = 'Membership'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label34: TLabel
        Left = 8
        Top = 51
        Width = 55
        Height = 13
        Caption = 'Member of:'
      end
      object Label33: TLabel
        Left = 8
        Top = 8
        Width = 71
        Height = 13
        Caption = '&Primary group:'
      end
      object MembershipList: TListView
        Left = 8
        Top = 70
        Width = 385
        Height = 196
        Columns = <
          item
            Caption = 'Name'
            Width = 140
          end
          item
            Caption = 'Path'
            Width = 220
          end>
        HideSelection = False
        TabOrder = 2
        ViewStyle = vsReport
      end
      object RemoveGroupBtn: TButton
        Left = 89
        Top = 272
        Width = 75
        Height = 25
        Caption = '&Remove'
        Enabled = False
        TabOrder = 4
        OnClick = RemoveGroupBtnClick
      end
      object AddGroupBtn: TButton
        Left = 8
        Top = 272
        Width = 75
        Height = 25
        Caption = '&Add'
        TabOrder = 3
        OnClick = AddGroupBtnClick
      end
      object PrimaryGroupBtn: TButton
        Left = 312
        Top = 22
        Width = 81
        Height = 25
        Caption = '&Set...'
        TabOrder = 1
        OnClick = PrimaryGroupBtnClick
      end
      object edPrimaryGroup: TEdit
        Left = 8
        Top = 24
        Width = 298
        Height = 21
        Enabled = False
        TabOrder = 0
      end
    end
  end
  object ApplyBtn: TButton
    Left = 328
    Top = 343
    Width = 75
    Height = 25
    Caption = 'Appl&y'
    Enabled = False
    TabOrder = 3
    OnClick = ApplyBtnClick
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 24
    Top = 336
  end
end
