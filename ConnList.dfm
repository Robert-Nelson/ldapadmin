object ConnListFrm: TConnListFrm
  Left = 334
  Top = 192
  Width = 507
  Height = 333
  ActiveControl = ListView
  Caption = 'Connections'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object OkBtn: TButton
    Left = 328
    Top = 272
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 1
  end
  object CancelBtn: TButton
    Left = 416
    Top = 272
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object ListView: TListView
    Left = 8
    Top = 8
    Width = 481
    Height = 257
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <>
    HideSelection = False
    LargeImages = ImageList1
    PopupMenu = PopupMenu
    TabOrder = 0
    OnClick = ListViewClick
    OnDblClick = ListViewDblClick
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 16
    Top = 272
    object pbNew: TMenuItem
      Caption = 'Neu...'
      OnClick = pbNewClick
    end
    object pbDelete: TMenuItem
      Caption = '&L�schen'
      OnClick = pbDeleteClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object pbProperties: TMenuItem
      Caption = '&Eigenschaften'
      OnClick = pbPropertiesClick
    end
  end
  object ImageList1: TImageList
    Left = 56
    Top = 272
    Bitmap = {
      494C010101000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000001911
      11004235350056464600503F3F00302323000402020000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000905050074656500CDC2
      C200DFD5D500E2D2D200D2B6B600C19C9C009E7A7A002F202100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000071606000F2EFEF00EFF1
      F100E4E4E400DAD1D100C3ACAC00A68D8D00CA9F9F00BB908E000C0808000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000907E7E00FEFEFE00FAFD
      FE00ECF0F100D8D0D000C5A1A100AF7F7E00C6999800C6989600100909004B32
      2A00756163000F0A090000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004D3A3A00D4BBBB00DDB8
      B800DFD0D800CEBCC200C5868900BE696900CC8D8D00BB9186006C5B7800DDDA
      E900F7EDE700BCACB100554A4A000B0808000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000047313700DC90
      5600F1A54800D7938600C96B7800C44C5100E7A19900CFB7C100118BFB0089B5
      E600B8776500AE8E9200C1C0B20049413E000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004A373D00F2A5
      4A00FFB40D00FCA90B00C383360096463000A16D7B00198EF8007BC8FA00F7CB
      B300B78C8800A1797800B58A89004D3938000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000755B5A00FEBD
      5700F8AD1800BFA6B500F9FBF700F4EDB600A7968300778B8100F2AAA100E3C1
      C400B9888B00C2909000C38F8E004E3838000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000003030400A1817A00FFCD
      5100BF902F00FFFFFF00FFFFFF00FFFFE800FCEAB500BD5C0E00DFA5A600DABD
      C100B9878500BA878700C58D8D00503737000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000016141800C8A69300FFD1
      5D00C8A16300FFFFFF00FFFFFF00FFFFFF00FEF9D500A56D4500D7B0B500DCBB
      BA00B8858600BB8A8A00C28A8A00513535000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000038323700DCBE9B00FFD8
      7400E5C07600FEEED800FFFF1700FFFFFF00FBF8F600B5754700D8B3BC00D8B3
      B200BD787800BA7D7D00C1868600523434000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000615C6200E6C99C00FFE7
      8700FFEBA000E3C49F00E4AB9200BC92BF00E5CB8300D49C6D00D8BBC400E3CA
      CC00D99A9A00CB757500CF747400573333000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009B979A00CDBCAA00D6C0
      9600E5D2A300F5EEBD00F8F6C500FCF5B300FFF39900DEAF9500F4DDE100FBE9
      E900F5E1E100E3C4C400CA8D8D00482B2B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007877770097949600A499
      9E00B5A3A400BFA7A600CEB2A900D8BFA800E5C49A00BE928700997C7E007761
      6100514141002E25250011111100030202000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000332F
      2F004D46460063565700766466008E747800B48E910060464700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00C03F000000000000801F000000000000
      801700000000000080010000000000008000000000000000C000000000000000
      C000000000000000C00000000000000080000000000000008000000000000000
      8000000000000000800000000000000080000000000000008000000000000000
      E01F000000000000FFFF00000000000000000000000000000000000000000000
      000000000000}
  end
end