object SearchFrm: TSearchFrm
  Left = 499
  Top = 118
  Width = 481
  Height = 436
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
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 8
    Top = 16
    Width = 48
    Height = 13
    Caption = 'Search &in:'
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 72
    Width = 361
    Height = 153
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = '&Search'
      object Label2: TLabel
        Left = 16
        Top = 16
        Width = 31
        Height = 13
        Caption = '&Name:'
      end
      object Label3: TLabel
        Left = 16
        Top = 64
        Width = 32
        Height = 13
        Caption = '&E-Mail:'
      end
      object edName: TEdit
        Left = 16
        Top = 32
        Width = 321
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
      object edEmail: TEdit
        Left = 16
        Top = 80
        Width = 321
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
      end
    end
    object TabSheet2: TTabSheet
      Caption = '&Advanced'
      ImageIndex = 1
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 25
        Height = 13
        Caption = 'Filter:'
      end
      object Memo1: TMemo
        Left = 8
        Top = 24
        Width = 337
        Height = 97
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
    end
  end
  object SBCombo: TComboBox
    Left = 8
    Top = 32
    Width = 361
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 1
  end
  object SearchBtn: TButton
    Left = 376
    Top = 32
    Width = 89
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Browse...'
    TabOrder = 2
    OnClick = SearchBtnClick
  end
  object StartBtn: TButton
    Left = 376
    Top = 96
    Width = 89
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'S&tart'
    Default = True
    TabOrder = 3
    OnClick = StartBtnClick
  end
  object CloseBtn: TButton
    Left = 376
    Top = 136
    Width = 89
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Close'
    TabOrder = 4
    OnClick = CloseBtnClick
  end
  object ListView: TListView
    Left = 0
    Top = 229
    Width = 473
    Height = 161
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Search results'
        Width = 600
      end>
    PopupMenu = PopupMenu
    TabOrder = 5
    ViewStyle = vsReport
    OnColumnClick = ListViewColumnClick
    OnCompare = ListViewCompare
    OnDblClick = ListViewDblClick
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 390
    Width = 473
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 8
    Top = 336
    object pbGoto: TMenuItem
      Caption = 'Go to ...'
      OnClick = ListViewDblClick
    end
  end
end
