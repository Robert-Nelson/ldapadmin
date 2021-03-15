unit BatchExec;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, LDapClasses, Schema;

const
  PANEL_HEIGHT       = 65;
  PANEL_LEFT_IND     = 8;
  PANEL_LABEL_TOP    = 8;
  PANEL_CTRL_TOP     = 24;
  PANEL_CTRL_SPACING = 8;
  OP_COMBO_WIDTH     = 97;

  LABEL_CAPTIONS: array[1..3] of string = ('Attribute:','','');

type
  TBatchDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    ScrollBox: TScrollBox;
    Label1: TLabel;
    edBase: TEdit;
    Label2: TLabel;
    edFilter: TEdit;
    Label3: TLabel;
    btnBrowse: TButton;
    btnTest: TButton;
    procedure btnBrowseClick(Sender: TObject);
  private
    fSchema:    TLdapSchema;
    procedure   AddPanel;
    procedure   OpComboChange(Sender: TObject);
  public
    constructor Create(AOwner: TComponent; const dn: string; const ASession: TLDAPSession); reintroduce;
  end;

var
  BatchDlg: TBatchDlg;

implementation

{$R *.DFM}

uses Constant, Main;

procedure TBatchDlg.AddPanel;
var
  Panel: TPanel;
begin
  Panel := TPanel.Create(ScrollBox);
  Panel.Parent := ScrollBox;
  Panel.Align := alBottom;
  Panel.Align := alTop;
  Panel.Height := PANEL_HEIGHT;
  with TComboBox.Create(ScrollBox) do
  begin
    Parent := Panel;
    Style := csDropDownList;
    Items.CommaText := 'Add,Replace,Delete';
    Width := OP_COMBO_WIDTH;
    Top := PANEL_CTRL_TOP;
    Left := PANEL_LEFT_IND;
    OnChange := OpComboChange;
  end;
  with TLabel.Create(ScrollBox) do
  begin
    Caption := 'Operation:';
    Top := PANEL_LABEL_TOP;
    Left := PANEL_LEFT_IND;
    Parent := Panel;
  end;
end;

constructor TBatchDlg.Create(AOwner: TComponent; const dn: string; const ASession: TLDAPSession);
begin
  inherited Create(AOwner);
  edBase.Text := dn;
  fSchema := LdapSchema(ASession);
  AddPanel;
end;

procedure TBatchDlg.OpComboChange(Sender: TObject);
var
  i, l: Integer;

  function NewControl(AControl: TControlClass; ACaption: string): TControl;
  var
    i: Integer;
    p: TWinControl;
  begin
    p := TWinControl(Sender).Parent;
    with TLabel.Create(p) do begin
      Left := l;
      Top := PANEL_LABEL_TOP;
      Caption := ACaption;
      Parent := p;
    end;
    Result := AControl.Create(p);
    with Result do begin
      Left := l;
      Top := PANEL_CTRL_TOP;
      Parent := p;
      inc(l, Width + PANEL_CTRL_SPACING);
    end;
    if AControl = TComboBox then
    begin
      TComboBox(Result).DropDownCount := 16;
      TComboBox(Result).Sorted := true;
      if fSchema.Loaded then
        for i := 0 to fSchema.Attributes.Count - 1 do
          TComboBox(Result).Items.Add(fSchema.Attributes[i].Name[0]);
    end;
  end;

begin
  with (Sender as TComboBox) do
  begin
    if Tag = 0 then
    begin
      AddPanel;
      Tag := 1;
    end;

    { Operation combo und it's label are owned by ScrollBox and therefore not freed }
    for i := Parent.ComponentCount - 1 downto 0 do
      Parent.Components[i].Free;

    l := PANEL_LEFT_IND + OP_COMBO_WIDTH + PANEL_CTRL_SPACING;
    case ItemIndex of
      0: begin
           NewControl(TComboBox, cAttribute);
           NewControl(TEdit, cValue);
         end;
      1: begin
           NewControl(TComboBox, cAttribute);
           NewControl(TEdit, cOldValue);
           NewControl(TEdit, cNewValue);
         end;
      2: begin
           NewControl(TComboBox, cAttribute);
           TEdit(NewControl(TEdit, cValue)).Text := '*';
         end;
    end;
  end;
end;

procedure TBatchDlg.btnBrowseClick(Sender: TObject);
var
  s: string;
begin
  s := MainFrm.PickEntry('Search base');
  if s <> '' then
    edBase.Text := s;
end;

end.

