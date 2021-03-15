object CustomMenuDlg: TCustomMenuDlg
  Left = 428
  Top = 183
  ActiveControl = TreeView
  Caption = 'Customize menu'
  ClientHeight = 510
  ClientWidth = 679
  Color = clBtnFace
  ParentFont = True
  Menu = MainMenu
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 305
    Top = 0
    Width = 11
    Height = 464
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
  end
  object Panel3: TPanel
    Left = 0
    Top = 464
    Width = 679
    Height = 46
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      679
      46)
    object btnCancel: TButton
      Left = 599
      Top = 12
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object btnOK: TButton
      Left = 519
      Top = 12
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&OK'
      ModalResult = 1
      TabOrder = 0
    end
  end
  object Panel4: TPanel
    Left = 673
    Top = 0
    Width = 6
    Height = 464
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
  end
  object Panel6: TPanel
    Left = 0
    Top = 0
    Width = 6
    Height = 464
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 316
    Top = 0
    Width = 357
    Height = 464
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 4
    object Panel5: TPanel
      Left = 0
      Top = 0
      Width = 357
      Height = 464
      Align = alClient
      BevelInner = bvLowered
      BevelOuter = bvNone
      TabOrder = 0
      object Panel8: TPanel
        Left = 1
        Top = 1
        Width = 355
        Height = 72
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Label1: TLabel
          Left = 16
          Top = 16
          Width = 41
          Height = 13
          Caption = 'Ca&ption:'
        end
        object edCaption: TEdit
          Left = 16
          Top = 32
          Width = 329
          Height = 21
          TabOrder = 0
          OnChange = edCaptionChange
        end
      end
      object GroupBox1: TGroupBox
        Left = 16
        Top = 72
        Width = 329
        Height = 169
        Caption = ' &Action '
        TabOrder = 1
        object rbDisabled: TRadioButton
          Left = 24
          Top = 32
          Width = 105
          Height = 17
          Caption = '&Disabled'
          TabOrder = 0
          OnClick = rbClick
        end
        object rbDefaultAction: TRadioButton
          Left = 24
          Top = 72
          Width = 105
          Height = 17
          Caption = 'Defaul&t action'
          TabOrder = 1
          OnClick = rbClick
        end
        object rbTemplate: TRadioButton
          Left = 24
          Top = 112
          Width = 105
          Height = 17
          Caption = '&Template'
          TabOrder = 2
          OnClick = rbClick
        end
        object cbTemplate: TComboBox
          Left = 128
          Top = 110
          Width = 185
          Height = 22
          Style = csOwnerDrawFixed
          Enabled = False
          TabOrder = 3
          OnChange = cbTemplateChange
          OnDrawItem = cbTemplateDrawItem
        end
        object cbDefaultAction: TComboBox
          Left = 128
          Top = 70
          Width = 185
          Height = 22
          Style = csOwnerDrawFixed
          TabOrder = 4
          OnChange = cbDefaultActionChange
          OnDrawItem = cbDefaultActionDrawItem
          Items.Strings = (
            'Entry'
            'User'
            'Computer'
            'Group'
            'Mailing list'
            'Transport table'
            'Organizational unit'
            'Group of unique names')
        end
        object ComboText: TStaticText
          Left = 32
          Top = 136
          Width = 4
          Height = 4
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnShadow
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsItalic]
          ParentFont = False
          TabOrder = 5
          OnMouseDown = ComboTextMouseDown
        end
      end
      object GroupBox2: TGroupBox
        Left = 16
        Top = 256
        Width = 329
        Height = 89
        Caption = 'Hotkey'
        TabOrder = 2
        object cbShortcutKey: TComboBox
          Left = 200
          Top = 40
          Width = 97
          Height = 21
          TabOrder = 0
        end
        object cbCtrl: TCheckBox
          Left = 24
          Top = 40
          Width = 57
          Height = 17
          Caption = 'Ctrl'
          TabOrder = 1
        end
        object cbShift: TCheckBox
          Left = 80
          Top = 40
          Width = 57
          Height = 17
          Caption = 'Shift'
          TabOrder = 2
        end
        object cbAlt: TCheckBox
          Left = 136
          Top = 40
          Width = 57
          Height = 17
          Caption = 'Alt'
          TabOrder = 3
        end
      end
    end
  end
  object TreeView: TTreeView
    Left = 6
    Top = 0
    Width = 299
    Height = 464
    Align = alClient
    DragCursor = crDefault
    DragMode = dmAutomatic
    HideSelection = False
    Indent = 19
    PopupMenu = PopupMenu
    ReadOnly = True
    TabOrder = 5
    OnChange = TreeViewChange
    OnChanging = TreeViewChanging
    OnContextPopup = TreeViewContextPopup
    OnCustomDrawItem = TreeViewCustomDrawItem
    OnDragDrop = TreeViewDragDrop
    OnDragOver = TreeViewDragOver
    OnEndDrag = TreeViewEndDrag
    OnStartDrag = TreeViewStartDrag
  end
  object MainMenu: TMainMenu
    Left = 96
    Top = 352
    object mbTest: TMenuItem
      Caption = '&Test'
    end
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 160
    Top = 352
    object mbAddItem: TMenuItem
      Caption = 'Add &item'
      OnClick = mbAddItemClick
    end
    object mbAddSubmenu: TMenuItem
      Caption = 'Add &submenu'
      OnClick = mbAddSubmenuClick
    end
    object mbAddSeparator: TMenuItem
      Caption = 'Add &separator'
      OnClick = mbAddSeparatorClick
    end
    object mbDelete: TMenuItem
      Caption = 'Delete...'
      OnClick = mbDeleteClick
    end
  end
  object ScrollTimer: TTimer
    Enabled = False
    OnTimer = ScrollTimerTimer
    Left = 32
    Top = 352
  end
end
