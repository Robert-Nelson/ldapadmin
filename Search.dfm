object SearchFrm: TSearchFrm
  Left = 368
  Top = 193
  Width = 730
  Height = 537
  ActiveControl = edName
  Caption = 'Search'
  Color = clBtnFace
  Constraints.MinHeight = 409
  Constraints.MinWidth = 473
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 491
    Width = 722
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 722
    Height = 169
    Align = alTop
    BorderWidth = 3
    TabOrder = 1
    object PickListBox: TListBox
      Left = 4
      Top = 4
      Width = 105
      Height = 161
      Align = alLeft
      Color = clAppWorkSpace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 32
      Items.Strings = (
        'Search'
        'Advanced'
        'Options')
      ParentFont = False
      Style = lbOwnerDrawFixed
      TabOrder = 0
      OnClick = PickListBoxClick
      OnDrawItem = PickListBoxDrawItem
    end
    object Panel2: TPanel
      Left = 109
      Top = 4
      Width = 609
      Height = 161
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Panel3: TPanel
        Left = 504
        Top = 0
        Width = 105
        Height = 161
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
        object StartBtn: TBitBtn
          Left = 16
          Top = 16
          Width = 83
          Height = 25
          Action = ActStart
          Caption = '&Start'
          TabOrder = 0
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF004A66
            7C00BE959600FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF006B9CC3001E89
            E8004B7AA300C8969300FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF004BB4FE0051B5
            FF002089E9004B7AA200C6959200FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0051B7
            FE0051B3FF001D87E6004E7AA000CA979200FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF0051B7FE004EB2FF001F89E6004E7BA200B9949700FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF0052B8FE004BB1FF002787D9005F6A7600FF00FF00B0857F00C09F
            9400C09F9600BC988E00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF0055BDFF00B5D6ED00BF9D9200BB9B8C00E7DAC200FFFF
            E300FFFFE500FDFADA00D8C3B300B58D8500FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00CEA79500FDEEBE00FFFFD800FFFF
            DA00FFFFDB00FFFFE600FFFFFB00EADDDC00AE837F00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00C1A09100FBDCA800FEF7D000FFFF
            DB00FFFFE300FFFFF800FFFFFD00FFFFFD00C6A99C00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00C1A09100FEE3AC00F1C49100FCF2CA00FFFF
            DD00FFFFE400FFFFF700FFFFF700FFFFE900EEE5CB00B9948C00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00C2A19100FFE6AE00EEB58100F7DCAE00FEFD
            D800FFFFDF00FFFFE300FFFFE400FFFFE000F3ECD200BB968E00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00BC978C00FBE7B700F4C79100F2C99400F8E5
            B900FEFCD800FFFFDD00FFFFDC00FFFFE000E2D2BA00B68E8600FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00D9C3A900FFFEE500F7DCB800F2C9
            9400F5D4A500FAE8BD00FDF4C900FDFBD600B6908900FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00B58D8500E8DEDD00FFFEF200F9D8
            A300F4C48C00F9D49F00FDEAB800D0B49F00B8908600FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00AD827F00C9AA9E00EFE0
            B700EFDFB200E7CEAC00B8908600B8908600FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00BA96
            8A00BB988C00B7918800FF00FF00FF00FF00FF00FF00FF00FF00}
        end
        object GotoBtn: TBitBtn
          Left = 16
          Top = 48
          Width = 83
          Height = 25
          Action = ActGoto
          Caption = '&Go to...'
          TabOrder = 1
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00008020000080
            200000802000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000080200040C0
            400040C0400000802000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000080200040C0
            400040C040000080200000800000FF00FF00FF00FF00FF00FF00008020000080
            20000080200000802000008020000080200000802000008020000080200040C0
            400040C0400040C040000080200000802000FF00FF00FF00FF00008020000080
            200080E0A00040E0800040E0800040E0800040E0800040E0800040C0600040C0
            600040C0600040C0400040C0400040C0400000802000FF00FF00008020000080
            200080E0A00040E0800040E0800040E0800040E0800040E0800040C0600040C0
            600040C0600040C0400040C0400040C040000080200000802000008020000080
            200080E0A00080E0A00080E0A00080E0A00040E0800040E0800040E0800040E0
            800040E0800040C0600040C0600040C060000080200000802000008020000080
            20000080200000802000008020000080200000802000008020000080200040E0
            800040E0800040E0800040C060000080200000802000FF00FF00008020000080
            20000080200000802000008020000080200000802000008020000080200040E0
            800040E0800040E080000080200000802000FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000080200040E0
            800040E080000080200000802000FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00008020000080
            20000080200000802000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00008020000080
            200000802000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
        end
        object SaveBtn: TBitBtn
          Left = 16
          Top = 80
          Width = 83
          Height = 25
          Action = ActSave
          Caption = 'S&ave'
          TabOrder = 2
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF0097433F0097433F00B59A9B00B59A9B00B59A9B00B59A9B00B59A9B00B59A
            9B00B59A9B009330300097433F00FF00FF00FF00FF00FF00FF00FF00FF009743
            3F00D6686800C6606000E5DEDF0092292A0092292A00E4E7E700E0E3E600D9DF
            E000CCC9CC008F201F00AF46460097433F00FF00FF00FF00FF00FF00FF009743
            3F00D0656600C25F5F00E9E2E20092292A0092292A00E2E1E300E2E6E800DDE2
            E400CFCCCF008F222200AD46460097433F00FF00FF00FF00FF00FF00FF009743
            3F00D0656500C15D5D00ECE4E40092292A0092292A00DFDDDF00E1E6E800E0E5
            E700D3D0D2008A1E1E00AB44440097433F00FF00FF00FF00FF00FF00FF009743
            3F00D0656500C15B5C00EFE6E600EDE5E500E5DEDF00E0DDDF00DFE0E200E0E1
            E300D6D0D200962A2A00B24A4A0097433F00FF00FF00FF00FF00FF00FF009743
            3F00CD626300C8606000C9676700CC727200CA727100C6696900C4646400CC6D
            6C00CA666700C55D5D00CD65650097433F00FF00FF00FF00FF00FF00FF009743
            3F00B6555300C27B7800D39D9C00D7A7A500D8A7A600D8A6A500D7A09F00D5A0
            9F00D7A9A700D8ABAB00CC66670097433F00FF00FF00FF00FF00FF00FF009743
            3F00CC666700F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9
            F900F9F9F900F9F9F900CC66670097433F00FF00FF00FF00FF00FF00FF009743
            3F00CC666700F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9
            F900F9F9F900F9F9F900CC66670097433F00FF00FF00FF00FF00FF00FF009743
            3F00CC666700F9F9F900CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCD
            CD00CDCDCD00F9F9F900CC66670097433F00FF00FF00FF00FF00FF00FF009743
            3F00CC666700F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9
            F900F9F9F900F9F9F900CC66670097433F00FF00FF00FF00FF00FF00FF009743
            3F00CC666700F9F9F900CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCD
            CD00CDCDCD00F9F9F900CC66670097433F00FF00FF00FF00FF00FF00FF009743
            3F00CC666700F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9
            F900F9F9F900F9F9F900CC66670097433F00FF00FF00FF00FF00FF00FF00FF00
            FF0097433F00F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9
            F900F9F9F900F9F9F90097433F00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
        end
        object CloseBtn: TBitBtn
          Left = 16
          Top = 120
          Width = 83
          Height = 25
          Action = ActClose
          Cancel = True
          Caption = '&Close'
          TabOrder = 3
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF00FF00
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF00FF00FF00FF00FF00FF008596
            DC001031B5001737B8001B3AB8001B3AB700193ABB00183AB9001438BD000E36
            C0000B33C0000830BE00032DC0000127B6008090D100FF00FF00FFFFFF001239
            D4002045D9002B4EDA003052DA002F52DB002D52DB002A52DC002550DF001D4C
            E0001648E0000E43E000063BE0000233D7000127B500FFFFFF00FFFFFF001A42
            DE002D51E100385AE3004565E5007F94ED00E2E8FB00FFFFFF00FFFFFF00DCE4
            FB007292F100144CE9000B44E800053AE000032CBE00FFFFFF00FFFFFF002349
            DF00395BE3004464E400A2B2F200FFFFFF00BBC8F600738FEE00708FEF00BACA
            F800FFFFFF0098B1F6000F49E900093FE100062FC100FFFFFF00FFFFFF002D52
            E1004362E4008B9EEE00FFFFFF008398EE00476AE6004167E7003864E8002D5E
            E9007394F100FFFFFF006C8DF0001044E1000C34C100FFFFFF00FFFFFF003659
            E2004C69E500EBEFFC00BBC6F5004F6EE6004A6BE600FFFFFF00FFFFFF002E5D
            E8002557E800B6C7F800DBE3FB001949E0001339C200FFFFFF00FFFFFF004060
            E4005470E700FFFFFF008195ED00516EE6004969E500FFFFFF00FFFFFF002D59
            E6002453E6006687EE00FFFFFF00204DDF00193DC000FFFFFF00FFFFFF004665
            E5005B76E800FFFFFF008195ED00516DE6004968E500FFFFFF00FFFFFF002D56
            E4002551E4006583EC00FFFFFF00264FDE001E40BF00FFFFFF00FFFFFF00506D
            E600647EE800EFF1FD00B7C2F500526DE6004966E400FFFFFF00FFFFFF002D53
            E200274FE200B0BFF500E0E6FB002B51DC002242BF00FFFFFF00FFFFFF005470
            E7006D85EA0097A9F100FFFFFF008193ED004D68E5004362E4003B5CE3003155
            E2006D86EB00FFFFFF00738AEC002E52DC002443BE00FFFFFF00FFFFFF005F7A
            E8007B91EC007189EB00A6B5F200FFFFFF00B1BDF4007186EA006C83E900B0BD
            F400FFFFFF0095A8F0003154E1003053DB002443BD00FFFFFF00FFFFFF006C85
            EA008DA1EF008197ED007088EB0097A8F000EEF0FC00FFFFFF00FFFFFF00E9ED
            FC00899DEE004263E4003B5DE3003154DC001F3FBC00FFFFFF00FFFFFF00788E
            EC009DAEF1008CA0EF007A90EC007189EB006B83E900667FE900637DE9005E79
            E8005774E7004F6DE6004263E4003053DB001A3ABA00FFFFFF00FF00FF00B2BF
            F400778DEC006881EA005C77E8005571E700506DE6004B6AE6004C6AE5004766
            E5004061E3003C5EE3003255E2002448D8008A9BDE00FF00FF00FF00FF00FF00
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF00FF00FF00FF00}
        end
      end
      object Panel40: TPanel
        Left = 0
        Top = 0
        Width = 504
        Height = 161
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object Panel41: TPanel
          Left = 0
          Top = 0
          Width = 504
          Height = 57
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Label5: TLabel
            Left = 8
            Top = 18
            Width = 25
            Height = 13
            Caption = 'Path:'
          end
          object Bevel2: TBevel
            Left = 48
            Top = 48
            Width = 449
            Height = 9
            Anchors = [akLeft, akTop, akRight]
            Shape = bsBottomLine
          end
          object cbBasePath: TComboBox
            Left = 48
            Top = 16
            Width = 377
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            ItemHeight = 13
            TabOrder = 0
          end
          object PathBtn: TButton
            Left = 436
            Top = 15
            Width = 65
            Height = 23
            Anchors = [akTop, akRight]
            Caption = '&Browse...'
            TabOrder = 1
            OnClick = PathBtnClick
          end
        end
        object Panel42: TPanel
          Left = 0
          Top = 57
          Width = 504
          Height = 104
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object Panel6: TPanel
            Left = 0
            Top = 0
            Width = 504
            Height = 104
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            Visible = False
            object GroupBox5: TGroupBox
              Left = 48
              Top = 16
              Width = 449
              Height = 97
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Result set'
              TabOrder = 0
              object Label4: TLabel
                Left = 16
                Top = 44
                Width = 47
                Height = 13
                Caption = 'Attributes:'
              end
              object cbAttributes: TComboBox
                Left = 72
                Top = 40
                Width = 289
                Height = 21
                Anchors = [akLeft, akTop, akRight]
                ItemHeight = 13
                TabOrder = 0
              end
              object edAttrBtn: TButton
                Left = 368
                Top = 40
                Width = 67
                Height = 23
                Anchors = [akTop, akRight]
                Caption = 'Edit...'
                TabOrder = 1
                OnClick = edAttrBtnClick
              end
            end
            object GroupBox3: TGroupBox
              Left = 48
              Top = 128
              Width = 449
              Height = 97
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Search level:'
              TabOrder = 1
              object Label2: TLabel
                Left = 16
                Top = 44
                Width = 93
                Height = 13
                Caption = 'Select search level:'
              end
              object cbSearchLevel: TComboBox
                Left = 120
                Top = 40
                Width = 241
                Height = 21
                Style = csDropDownList
                Anchors = [akLeft, akTop, akRight]
                ItemHeight = 13
                TabOrder = 0
                Items.Strings = (
                  'This entry only'
                  'Next level'
                  'Entire subtree')
              end
            end
            object GroupBox4: TGroupBox
              Left = 48
              Top = 240
              Width = 449
              Height = 97
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Alias options:'
              TabOrder = 2
              object Label3: TLabel
                Left = 16
                Top = 44
                Width = 97
                Height = 13
                Caption = 'Dereference aliases:'
              end
              object cbDerefAliases: TComboBox
                Left = 120
                Top = 40
                Width = 241
                Height = 21
                Style = csDropDownList
                Anchors = [akLeft, akTop, akRight]
                ItemHeight = 13
                TabOrder = 0
                Items.Strings = (
                  'Never'
                  'When searching'
                  'When finding'
                  'Always')
              end
            end
          end
          object Panel5: TPanel
            Left = 0
            Top = 0
            Width = 504
            Height = 104
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            Visible = False
            object Label1: TLabel
              Left = 8
              Top = 8
              Width = 25
              Height = 13
              Caption = 'Filter:'
            end
            object Memo1: TMemo
              Left = 48
              Top = 8
              Width = 449
              Height = 65
              Anchors = [akLeft, akTop, akRight]
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Courier New'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
            end
            object cbFilters: TComboBox
              Left = 48
              Top = 80
              Width = 305
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              ItemHeight = 13
              TabOrder = 1
              OnChange = cbFiltersChange
              OnDropDown = cbFiltersDropDown
            end
            object SaveFilterBtn: TButton
              Left = 364
              Top = 79
              Width = 65
              Height = 23
              Anchors = [akTop, akRight]
              Caption = 'Sa&ve'
              Enabled = False
              TabOrder = 2
              OnClick = SaveFilterBtnClick
            end
            object DeleteFilterBtn: TButton
              Left = 436
              Top = 79
              Width = 65
              Height = 23
              Anchors = [akTop, akRight]
              Caption = '&Delete'
              Enabled = False
              TabOrder = 3
              OnClick = DeleteFilterBtnClick
            end
          end
          object Panel4: TPanel
            Left = 0
            Top = 0
            Width = 504
            Height = 104
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 2
            object Label6: TLabel
              Left = 8
              Top = 23
              Width = 31
              Height = 13
              Caption = '&Name:'
            end
            object Label7: TLabel
              Left = 8
              Top = 66
              Width = 32
              Height = 13
              Caption = '&E-Mail:'
            end
            object edName: TEdit
              Left = 48
              Top = 20
              Width = 449
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 0
            end
            object edEmail: TEdit
              Left = 48
              Top = 64
              Width = 449
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 1
            end
          end
        end
      end
    end
  end
  object ResultPanel: TPanel
    Left = 0
    Top = 169
    Width = 722
    Height = 322
    Align = alClient
    BorderWidth = 3
    TabOrder = 2
  end
  object PopupMenu1: TPopupMenu
    Images = MainFrm.ImageList
    Left = 8
    Top = 448
    object pbGoto: TMenuItem
      Action = ActGoto
    end
    object Editentry1: TMenuItem
      Action = ActEdit
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object pbProperties: TMenuItem
      Action = ActProperties
    end
  end
  object ActionList: TActionList
    Images = MainFrm.ImageList
    OnUpdate = ActionListUpdate
    Left = 40
    Top = 448
    object ActStart: TAction
      Caption = '&Start'
      Hint = 'Start searching'
      ImageIndex = 20
      OnExecute = ActStartExecute
    end
    object ActGoto: TAction
      Caption = '&Go to...'
      Hint = 'Find entry in LDAP tree'
      ImageIndex = 30
      OnExecute = ActGotoExecute
    end
    object ActProperties: TAction
      Caption = '&Properties...'
      Hint = 'Edit object properties'
      ImageIndex = 16
      OnExecute = ActPropertiesExecute
    end
    object ActSave: TAction
      Caption = '&Save'
      Hint = 'Save search results in LDIF file'
      ImageIndex = 31
      OnExecute = ActSaveExecute
    end
    object ActEdit: TAction
      Caption = '&Edit entry...'
      Hint = 'Edit with raw editor'
      ImageIndex = 14
      OnExecute = ActEditExecute
    end
    object ActClose: TAction
      Caption = '&Close'
      Hint = 'Close'
      ImageIndex = 18
      OnExecute = ActCloseExecute
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '*.ldif'
    Filter = 
      'Ldif file, Windows format (CR/LF) (*.ldif)|*.ldif|Ldif file, Uni' +
      'x format (LF only) (*.ldif)|*.ldif|CSV (Comma-separated) (*.csv)' +
      '|*.csv|XML (*.xml)|*.xml'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 72
    Top = 448
  end
end
