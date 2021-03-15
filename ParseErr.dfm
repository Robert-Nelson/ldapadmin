object ParseErrDlg: TParseErrDlg
  Left = 508
  Top = 266
  ActiveControl = SrcMemo
  Caption = 'Parse error'
  ClientHeight = 347
  ClientWidth = 531
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  DesignSize = (
    531
    347)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 521
    Height = 57
    Anchors = [akLeft, akTop, akRight]
  end
  object TLabel
    Left = 16
    Top = 16
    Width = 3
    Height = 13
  end
  object Label2: TLabel
    Left = 56
    Top = 32
    Width = 466
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    WordWrap = True
  end
  object Image1: TImage
    Left = 16
    Top = 20
    Width = 33
    Height = 33
  end
  object Label1: TLabel
    Left = 56
    Top = 16
    Width = 465
    Height = 13
    AutoSize = False
  end
  object btnClose: TButton
    Left = 454
    Top = 318
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 0
  end
  object SrcMemo: TMemo
    Left = 8
    Top = 72
    Width = 521
    Height = 233
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
    WordWrap = False
  end
end
