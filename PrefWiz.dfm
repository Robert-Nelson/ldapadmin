object PrefWizDlg: TPrefWizDlg
  Left = 405
  Top = 278
  BorderStyle = bsDialog
  Caption = 'Profile Wizard'
  ClientHeight = 306
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 256
    Width = 467
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    object Bevel3: TBevel
      Left = 0
      Top = 0
      Width = 467
      Height = 25
      Align = alTop
      Shape = bsTopLine
    end
  end
  object Notebook: TNotebook
    Left = 0
    Top = 0
    Width = 467
    Height = 256
    Align = alClient
    TabOrder = 0
    OnPageChanged = NotebookPageChanged
    object TPage
      Left = 0
      Top = 0
      Caption = '0'
      object Label1: TLabel
        Left = 16
        Top = 224
        Width = 128
        Height = 13
        Caption = 'Click on Next to continue...'
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 467
        Height = 65
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 0
        object Label2: TLabel
          Left = 16
          Top = 24
          Width = 359
          Height = 13
          Caption = 
            'This wizard helps you to create default preference profile for t' +
            'his connection.'
        end
        object Bevel4: TBevel
          Left = 0
          Top = 40
          Width = 467
          Height = 25
          Align = alBottom
          Shape = bsBottomLine
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = '1'
      object ListView1: TListView
        Left = 56
        Top = 96
        Width = 353
        Height = 137
        Columns = <
          item
            Caption = 'Type'
            Width = 200
          end
          item
            Caption = 'Example'
            Width = 70
          end
          item
            Caption = 'Setting'
            Width = 70
          end>
        Items.Data = {
          6A0100000600000000000000FFFFFFFFFFFFFFFF020000000000000015466972
          7374206E616D65202E4C617374206E616D65086A6F686E2E646F650525662E25
          6C00000000FFFFFFFFFFFFFFFF0200000000000000144C617374206E616D652E
          4669727374206E616D6508646F652E6A6F686E05256C2E256600000000FFFFFF
          FFFFFFFFFF020000000000000027496E697469616C206C6574746572206F6620
          6669727374206E616D652C204C617374206E616D65046A646F65042546256C00
          000000FFFFFFFFFFFFFFFF020000000000000027496E697469616C206C657474
          6572206F66206C617374206E616D652C204669727374206E616D6505646A6F68
          6E04254C256600000000FFFFFFFFFFFFFFFF0200000000000000094C61737420
          6E616D6503646F6502256C00000000FFFFFFFFFFFFFFFF02000000000000000A
          4669727374206E616D65046A6F686E022566FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFF}
        TabOrder = 0
        ViewStyle = vsReport
      end
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 467
        Height = 65
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 1
        object Bevel5: TBevel
          Left = 0
          Top = 40
          Width = 467
          Height = 25
          Align = alBottom
          Shape = bsBottomLine
        end
        object Label3: TLabel
          Left = 16
          Top = 24
          Width = 135
          Height = 13
          Caption = 'Choose format for username:'
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = '2'
      object ListView2: TListView
        Left = 56
        Top = 96
        Width = 353
        Height = 137
        Columns = <
          item
            Caption = 'Type'
            Width = 200
          end
          item
            Caption = 'Example'
            Width = 70
          end
          item
            Caption = 'Setting'
            Width = 70
          end>
        Items.Data = {
          D40000000300000000000000FFFFFFFFFFFFFFFF0200000000000000154C6173
          74206E616D652C204669727374206E616D6509446F652C204A6F686E06256C2C
          20256600000000FFFFFFFFFFFFFFFF0200000000000000154669727374206E61
          6D652C204C617374206E616D65094A6F686E2C20446F650625662C20256C0000
          0000FFFFFFFFFFFFFFFF020000000000000027496E697469616C206C65747465
          72206F66206669727374206E616D652C204C617374206E616D65064A2E20446F
          650625462E20256CFFFFFFFFFFFFFFFFFFFFFFFF}
        TabOrder = 0
        ViewStyle = vsReport
      end
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 467
        Height = 65
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 1
        object Bevel6: TBevel
          Left = 0
          Top = 40
          Width = 467
          Height = 25
          Align = alBottom
          Shape = bsBottomLine
        end
        object Label11: TLabel
          Left = 16
          Top = 24
          Width = 150
          Height = 13
          Caption = 'Choose format for display name:'
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = '3'
      object Label5: TLabel
        Left = 72
        Top = 124
        Width = 113
        Height = 13
        Alignment = taRightJustify
        Caption = 'Server NETBIOS name:'
      end
      object Label6: TLabel
        Left = 83
        Top = 164
        Width = 102
        Height = 13
        Alignment = taRightJustify
        Caption = 'Samba domain name:'
      end
      object wedServer: TEdit
        Left = 192
        Top = 120
        Width = 193
        Height = 21
        TabOrder = 0
      end
      object wcbDomain: TComboBox
        Left = 192
        Top = 160
        Width = 193
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 1
      end
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 467
        Height = 65
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 2
        object Bevel1: TBevel
          Left = 0
          Top = 40
          Width = 467
          Height = 25
          Align = alBottom
          Shape = bsBottomLine
        end
        object Label4: TLabel
          Left = 16
          Top = 24
          Width = 233
          Height = 13
          Caption = 'Enter Samba NETBIOS server and domain name:'
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = '4'
      object Label8: TLabel
        Left = 126
        Top = 124
        Width = 59
        Height = 13
        Alignment = taRightJustify
        Caption = 'Mail domain:'
      end
      object Label9: TLabel
        Left = 110
        Top = 164
        Width = 75
        Height = 13
        Alignment = taRightJustify
        Caption = 'Maildrop server:'
      end
      object wedMail: TEdit
        Left = 192
        Top = 120
        Width = 193
        Height = 21
        TabOrder = 0
      end
      object wedMaildrop: TEdit
        Left = 192
        Top = 160
        Width = 193
        Height = 21
        TabOrder = 1
      end
      object Panel6: TPanel
        Left = 0
        Top = 0
        Width = 467
        Height = 65
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 2
        object Bevel2: TBevel
          Left = 0
          Top = 40
          Width = 467
          Height = 25
          Align = alBottom
          Shape = bsBottomLine
        end
        object Label7: TLabel
          Left = 16
          Top = 24
          Width = 268
          Height = 13
          Caption = 'Enter your mail domain and maildrop adress (Postfix only):'
        end
      end
    end
  end
  object btnNext: TButton
    Left = 296
    Top = 272
    Width = 75
    Height = 25
    Caption = '&Next >'
    Default = True
    TabOrder = 2
    OnClick = btnNextClick
  end
  object btnBack: TButton
    Left = 220
    Top = 272
    Width = 75
    Height = 25
    Caption = '< &Back'
    Enabled = False
    TabOrder = 1
    OnClick = btnBackClick
  end
  object btnCancel: TButton
    Left = 384
    Top = 272
    Width = 75
    Height = 25
    Caption = '&Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
end
