unit Ou;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, LDAPClasses, Constant;

type
  TOuDlg = class(TForm)
    NameLabel: TLabel;
    ou: TEdit;
    GroupBox1: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    Label24: TLabel;
    Label31: TLabel;
    postalAddress: TMemo;
    st: TEdit;
    postalCode: TEdit;
    l: TEdit;
    Label1: TLabel;
    description: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    dn: string;
    Session: TLDAPSession;
    EditMode: TEditMode;
    Entry: TLDAPEntry;
    procedure Save;
  public
    constructor Create(AOwner: TComponent; dn: string; Session: TLDAPSession; Mode: TEditMode); reintroduce;
  end;

var
  OuDlg: TOuDlg;

implementation

uses WinLDAP;

{$R *.DFM}

// TODO: those are used by USerDlg too, put them in common unit
// ************************************************************
{ Address fields take $ sign as newline tag so we have to convert this to LF/CR }

function FormatMemoInput(Text: string): string;
var
  p: PChar;
begin
  Result := '';
  p := PChar(Text);
  while p^ <> #0 do begin
    if p^ = '$' then
      Result := Result + #$D#$A
    else
      Result := Result + p^;
    p := CharNext(p);
  end;
end;

function FormatMemoOutput(Text: string): string;
var
  p, p1: PChar;
begin
  Result := '';
  p := PChar(Text);
  while p^ <> #0 do begin
    p1 := CharNext(p);
    if (p^ = #$D) and (p1^ = #$A) then
    begin
      Result := Result + '$';
      p1 := CharNext(p1);
    end
    else
      Result := Result + p^;
    p := p1;
  end;
end;
//*************

procedure TOuDlg.Save;
var
  C, Mode: Integer;
  Component: TComponent;
  s: string;
begin

  if ou.Text = '' then
    raise Exception.Create(Format(stReqNoEmpty, [NameLabel.Caption]));

  try
    if EditMode = EM_ADD then
    begin
      Entry := TLDAPEntry.Create(Session.pld, 'ou=' + ou.Text + ',' + dn);
      Entry.AddAttr('objectclass', 'top', LDAP_MOD_ADD);
      Entry.AddAttr('objectclass', 'organizationalUnit', LDAP_MOD_ADD);
      Entry.AddAttr('ou', ou.Text, LDAP_MOD_ADD);
    end;

    for C := 0 to GroupBox1.ControlCount - 1 do
    begin
      Component := GroupBox1.Controls[c];
      if (Component is TCustomEdit) and (TCustomEdit(Component).Modified) then
      begin
        if Component is TMemo then
          s := FormatMemoOutput(TMemo(Component).Text)
        else
          s := TEdit(Component).Text;
        if EditMode = EM_ADD then
        begin
          if s <> '' then
            Entry.AddAttr(Component.Name, s, LDAP_MOD_ADD);
        end
        else begin
          if s = '' then
            Mode := LDAP_MOD_DELETE
          else
            Mode := LDAP_MOD_REPLACE;
          Entry.AddAttr(Component.Name, s, Mode)
        end;
      end;
    end;

    if EditMode = EM_ADD then
      Entry.Add
    else
      Entry.Modify;
  except
    {Entry.ClearAttrs;}
    raise;
  end;

end;


constructor TOuDlg.Create(AOwner: TComponent; dn: string; Session: TLDAPSession; Mode: TEditMode);
var
  I, C: Integer;
  attrName, attrValue: string;
begin
  inherited Create(AOwner);
  Self.dn := dn;
  Self.Session := Session;
  EditMode := Mode;
  if EditMode = EM_MODIFY then
  begin
    ou.Enabled := False;
    ou.text := Session.GetNameFromDN(dn);
    Caption := Format(cPropertiesOf, [ou.Text]);
    Entry := TLDAPEntry.Create(Session.pld, dn);
    Entry.Read;

    for I := 0 to Entry.Items.Count - 1 do
    begin
      attrName := lowercase(Entry.Items[i]);
      attrValue := PChar(Entry.Items.Objects[i]);
      for C := 0 to ComponentCount - 1 do
      begin
        if AnsiStrIComp(PChar(Components[C].Name), PChar(attrName)) = 0 then
        begin
          if Components[C] is TMemo then
            TMemo(Components[C]).Text := FormatMemoInput(attrValue)
          else
            TEdit(Components[C]).Text := attrValue;
        end;
      end;
    end;

  end;

end;

procedure TOuDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOK then
    Save;
  Action := caFree;
end;

end.
