object SearchFrm: TSearchFrm
  Left = 482
  Top = 181
  Width = 730
  Height = 537
  Caption = 'Search'
  Color = clBtnFace
  Constraints.MinHeight = 409
  Constraints.MinWidth = 473
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 491
    Width = 722
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 29
    Width = 722
    Height = 164
    Align = alTop
    BorderWidth = 3
    TabOrder = 1
    object Panel2: TPanel
      Left = 4
      Top = 4
      Width = 714
      Height = 156
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object Panel40: TPanel
        Left = 0
        Top = 0
        Width = 714
        Height = 156
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object Panel41: TPanel
          Left = 0
          Top = 0
          Width = 714
          Height = 49
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Label5: TLabel
            Left = 8
            Top = 12
            Width = 25
            Height = 13
            Caption = 'Path:'
          end
          object Bevel1: TBevel
            Left = 8
            Top = 28
            Width = 702
            Height = 10
            Anchors = [akLeft, akTop, akRight]
            Shape = bsBottomLine
          end
          object cbBasePath: TComboBox
            Left = 48
            Top = 8
            Width = 570
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            ItemHeight = 13
            TabOrder = 0
          end
          object PathBtn: TButton
            Left = 625
            Top = 7
            Width = 81
            Height = 23
            Anchors = [akTop, akRight]
            Caption = '&Browse...'
            TabOrder = 1
            OnClick = PathBtnClick
          end
        end
        object Panel4: TPanel
          Left = 0
          Top = 49
          Width = 714
          Height = 107
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object PageControl: TPageControl
            Left = 0
            Top = 0
            Width = 617
            Height = 107
            ActivePage = TabSheet1
            Align = alClient
            TabOrder = 0
            object TabSheet1: TTabSheet
              Caption = '&Search'
              object Label6: TLabel
                Left = 8
                Top = 15
                Width = 31
                Height = 13
                Caption = '&Name:'
              end
              object Label7: TLabel
                Left = 8
                Top = 42
                Width = 32
                Height = 13
                Caption = '&E-Mail:'
              end
              object edName: TEdit
                Left = 48
                Top = 12
                Width = 546
                Height = 21
                Anchors = [akLeft, akTop, akRight]
                TabOrder = 0
              end
              object edEmail: TEdit
                Left = 48
                Top = 40
                Width = 546
                Height = 21
                Anchors = [akLeft, akTop, akRight]
                TabOrder = 1
              end
            end
            object TabSheet2: TTabSheet
              Caption = '&Custom'
              ImageIndex = 1
              OnResize = TabSheet2Resize
              object Label1: TLabel
                Left = 8
                Top = 8
                Width = 25
                Height = 13
                Caption = 'Filter:'
              end
              object Memo1: TMemo
                Left = 40
                Top = 8
                Width = 563
                Height = 41
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'Courier New'
                Font.Style = []
                ParentFont = False
                TabOrder = 0
              end
              object cbFilters: TComboBox
                Left = 40
                Top = 52
                Width = 426
                Height = 21
                ItemHeight = 0
                TabOrder = 1
                OnChange = cbFiltersChange
                OnDropDown = cbFiltersDropDown
              end
              object SaveFilterBtn: TButton
                Left = 469
                Top = 52
                Width = 65
                Height = 23
                Anchors = []
                Caption = 'Sa&ve'
                Enabled = False
                TabOrder = 2
                OnClick = SaveFilterBtnClick
              end
              object DeleteFilterBtn: TButton
                Left = 538
                Top = 52
                Width = 65
                Height = 23
                Anchors = []
                Caption = '&Delete'
                Enabled = False
                TabOrder = 3
                OnClick = DeleteFilterBtnClick
              end
            end
            object TabSheet3: TTabSheet
              Caption = '&Options'
              ImageIndex = 2
              OnResize = TabSheet3Resize
              object Label4: TLabel
                Left = 20
                Top = 12
                Width = 47
                Height = 13
                Caption = 'Attributes:'
              end
              object Label2: TLabel
                Left = 4
                Top = 44
                Width = 62
                Height = 13
                Caption = 'Search level:'
              end
              object Label3: TLabel
                Left = 248
                Top = 44
                Width = 97
                Height = 13
                Caption = 'Dereference aliases:'
              end
              object cbAttributes: TComboBox
                Left = 72
                Top = 8
                Width = 458
                Height = 21
                Anchors = [akLeft, akTop, akRight]
                ItemHeight = 0
                TabOrder = 0
              end
              object edAttrBtn: TButton
                Left = 537
                Top = 8
                Width = 67
                Height = 23
                Anchors = [akTop]
                Caption = 'Edit...'
                TabOrder = 1
                OnClick = edAttrBtnClick
              end
              object cbSearchLevel: TComboBox
                Left = 72
                Top = 40
                Width = 169
                Height = 21
                Style = csDropDownList
                ItemHeight = 13
                TabOrder = 2
                Items.Strings = (
                  'This entry only'
                  'Next level'
                  'Entire subtree')
              end
              object cbDerefAliases: TComboBox
                Left = 352
                Top = 40
                Width = 178
                Height = 21
                Style = csDropDownList
                Anchors = [akLeft, akTop, akRight]
                ItemHeight = 13
                TabOrder = 3
                Items.Strings = (
                  'Never'
                  'When searching'
                  'When finding'
                  'Always')
              end
            end
          end
          object Panel3: TPanel
            Left = 617
            Top = 0
            Width = 97
            Height = 107
            Align = alRight
            BevelOuter = bvNone
            TabOrder = 1
            object StartBtn: TBitBtn
              Left = 8
              Top = 20
              Width = 83
              Height = 25
              Action = ActStart
              Caption = 'Sta&rt'
              ParentShowHint = False
              ShowHint = True
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
            object ClearAllBtn: TButton
              Left = 8
              Top = 52
              Width = 83
              Height = 25
              Action = ActClearAll
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
            end
          end
        end
      end
    end
  end
  object ResultPanel: TPanel
    Left = 0
    Top = 193
    Width = 722
    Height = 298
    Align = alClient
    BorderWidth = 3
    TabOrder = 2
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 722
    Height = 29
    ButtonHeight = 28
    ButtonWidth = 28
    Caption = 'ToolBar1'
    DisabledImages = MainFrm.ImageList
    Flat = True
    Images = MainFrm.ImageList
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    object btnSearch: TToolButton
      Left = 0
      Top = 0
      Hint = 'Search'
      Caption = 'Search'
      Down = True
      Grouped = True
      ImageIndex = 20
      Style = tbsCheck
      OnClick = btnSearchModifyClick
    end
    object btnModify: TToolButton
      Left = 28
      Top = 0
      Hint = 'Modify'
      Caption = 'Modify'
      Grouped = True
      ImageIndex = 38
      Style = tbsCheck
      OnClick = btnSearchModifyClick
    end
    object ToolButton7: TToolButton
      Left = 56
      Top = 0
      Width = 8
      Caption = 'ToolButton7'
      ImageIndex = 6
      Style = tbsSeparator
    end
    object ToolButton3: TToolButton
      Left = 64
      Top = 0
      Action = ActEdit
    end
    object ToolButton4: TToolButton
      Left = 92
      Top = 0
      Action = ActProperties
    end
    object ToolButton5: TToolButton
      Left = 120
      Top = 0
      Action = ActGoto
    end
    object ToolButton6: TToolButton
      Left = 148
      Top = 0
      Action = ActSave
    end
    object ToolButton8: TToolButton
      Left = 176
      Top = 0
      Width = 8
      Caption = 'ToolButton8'
      ImageIndex = 32
      Style = tbsSeparator
    end
    object ToolButton9: TToolButton
      Left = 184
      Top = 0
      Action = ActClose
    end
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
      Hint = 'Save search results'
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
    object ActClearAll: TAction
      Caption = 'Clear a&ll'
      Hint = 'Clear all search results'
      OnExecute = ActClearAllExecute
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
