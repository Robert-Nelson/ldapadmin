object AdPrefDlg: TAdPrefDlg
  Left = 688
  Top = 198
  ActiveControl = edCN
  BorderStyle = bsDialog
  Caption = 'Edit preferences'
  ClientHeight = 416
  ClientWidth = 500
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 359
    Width = 500
    Height = 57
    Align = alBottom
    TabOrder = 0
    object OkBtn: TButton
      Left = 334
      Top = 17
      Width = 75
      Height = 25
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
    object CancelBtn: TButton
      Left = 414
      Top = 17
      Width = 75
      Height = 25
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 2
    end
    object BtnDefault: TButton
      Left = 8
      Top = 17
      Width = 121
      Height = 25
      Caption = 'Default values'
      TabOrder = 0
      OnClick = BtnDefaultClick
    end
  end
  object gbDefaults: TGroupBox
    Left = 8
    Top = 8
    Width = 481
    Height = 193
    Caption = 'Account:'
    TabOrder = 1
    object lblUPN: TLabel
      Left = 52
      Top = 91
      Width = 62
      Height = 13
      Alignment = taRightJustify
      Caption = 'Logon name:'
    end
    object lblNTLogon: TLabel
      Left = 39
      Top = 123
      Width = 75
      Height = 13
      Alignment = taRightJustify
      Caption = 'NT logon name:'
    end
    object lblCN: TLabel
      Left = 40
      Top = 27
      Width = 74
      Height = 13
      Alignment = taRightJustify
      Caption = 'Common name:'
    end
    object lblDisplayname: TLabel
      Left = 47
      Top = 59
      Width = 67
      Height = 13
      Alignment = taRightJustify
      Caption = 'Display name:'
    end
    object Label1: TLabel
      Left = 46
      Top = 156
      Width = 68
      Height = 13
      Alignment = taRightJustify
      Caption = 'Domain name:'
    end
    object edUPN: TEdit
      Left = 120
      Top = 88
      Width = 161
      Height = 21
      TabOrder = 2
    end
    object edNTLoginName: TEdit
      Left = 120
      Top = 120
      Width = 344
      Height = 21
      TabOrder = 4
    end
    object edDisplayName: TEdit
      Left = 120
      Top = 56
      Width = 344
      Height = 21
      TabOrder = 1
    end
    object edCN: TEdit
      Left = 120
      Top = 24
      Width = 344
      Height = 21
      TabOrder = 0
    end
    object cbUpnDomain: TComboBox
      Left = 288
      Top = 88
      Width = 177
      Height = 21
      Style = csDropDownList
      TabOrder = 3
    end
    object edNTDomain: TEdit
      Left = 120
      Top = 153
      Width = 344
      Height = 21
      TabOrder = 5
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 207
    Width = 481
    Height = 156
    Caption = '&Paths:'
    TabOrder = 2
    object lblScript: TLabel
      Left = 83
      Top = 90
      Width = 31
      Height = 13
      Alignment = taRightJustify
      Caption = 'Script:'
    end
    object lblHomeShare: TLabel
      Left = 53
      Top = 27
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Caption = 'Home share:'
    end
    object lblProfilePath: TLabel
      Left = 55
      Top = 123
      Width = 59
      Height = 13
      Alignment = taRightJustify
      Caption = 'Profile path:'
    end
    object lblHomeDrive: TLabel
      Left = 56
      Top = 59
      Width = 58
      Height = 13
      Alignment = taRightJustify
      Caption = 'Home drive:'
    end
    object edScript: TEdit
      Left = 120
      Top = 87
      Width = 345
      Height = 21
      TabOrder = 2
    end
    object edHomeDir: TEdit
      Left = 120
      Top = 24
      Width = 344
      Height = 21
      TabOrder = 0
    end
    object edProfilePath: TEdit
      Left = 120
      Top = 120
      Width = 344
      Height = 21
      TabOrder = 3
    end
    object cbHomeDrive: TComboBox
      Left = 120
      Top = 56
      Width = 65
      Height = 21
      Style = csDropDownList
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
  end
end
