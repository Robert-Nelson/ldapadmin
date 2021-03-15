  {      LDAPAdmin - Locality.pas
  *      Copyright (C) 2003 Tihomir Karlovic
  *
  *      Author: Simon Zsolt
  *
  *
  * This file is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  *
  * This file is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
  }

unit Locality;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, LDAPClasses, Constant;

type
  TLocalityDlg = class(TForm)
    NameLabel: TLabel;
    l: TEdit;
    GroupBox1: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    street: TMemo;
    st: TEdit;
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
  LocalityDlg: TLocalityDlg;

implementation

uses Misc, WinLDAP;

{$R *.DFM}

procedure TLocalityDlg.Save;
var
  C, Mode: Integer;
  Component: TComponent;
  s: string;
begin

  if l.Text = '' then
    raise Exception.Create(Format(stReqNoEmpty, [NameLabel.Caption]));

  try
    if EditMode = EM_ADD then
    begin
      Entry := TLDAPEntry.Create(Session, 'l=' + l.Text + ',' + dn);
      Entry.AddAttr('objectclass', 'top', LDAP_MOD_ADD);
      Entry.AddAttr('objectclass', 'locality', LDAP_MOD_ADD);
      Entry.AddAttr('l', l.Text, LDAP_MOD_ADD);
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
      Entry.New
    else
      Entry.Modify;
  except
    {Entry.ClearAttrs;}
    raise;
  end;

end;


constructor TLocalityDlg.Create(AOwner: TComponent; dn: string; Session: TLDAPSession; Mode: TEditMode);
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
    l.Enabled := False;
    l.text := Session.GetNameFromDN(dn);
    Caption := Format(cPropertiesOf, [l.Text]);
    Entry := TLDAPEntry.Create(Session, dn);
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

procedure TLocalityDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOK then
    Save;
  Action := caFree;
end;

end.
