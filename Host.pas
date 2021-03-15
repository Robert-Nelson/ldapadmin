  {      LDAPAdmin - Host.pas
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

unit Host;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, LDAPClasses, Constant;

type
  THostDlg = class(TForm)
    NameLabel: TLabel;
    _cn: TEdit;
    GroupBox1: TGroupBox;
    OKBtn: TButton;
    CancelBtn: TButton;
    ipHostNumber: TEdit;
    IPLabel: TLabel;
    cn: TListBox;
    AddHostBtn: TButton;
    EditHostBtn: TButton;
    DelHostBtn: TButton;
    UpBtn: TButton;
    DownBtn: TButton;
    description: TEdit;
    Label2: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddHostBtnClick(Sender: TObject);
    procedure EditHostBtnClick(Sender: TObject);
    procedure DelHostBtnClick(Sender: TObject);
    procedure UpBtnClick(Sender: TObject);
    procedure DownBtnClick(Sender: TObject);
    procedure cnClick(Sender: TObject);
  private
    dn: string;
    Session: TLDAPSession;
    EditMode: TEditMode;
    Entry: TLDAPEntry;
    procedure Save;
  public
    constructor Create(AOwner: TComponent; dn: string; Session: TLDAPSession; Mode: TEditMode); reintroduce;
  private
    procedure HostButtons(Enable: Boolean);
  end;

var
  OuDlg: THostDlg;

implementation

uses WinLDAP, Input;

{$R *.DFM}

procedure THostDlg.Save;
var
  C, Mode: Integer;

  procedure AddModEntry(Entry: TLDAPEntry; Name, Value: String; Modified: boolean = true);
  begin
    if EditMode = EM_ADD then
    begin
      if Value <> '' then
        Entry.AddAttr(Name, Value, LDAP_MOD_ADD);
    end
    else
      if Modified then
      begin
        if Value = '' then
          Mode := LDAP_MOD_DELETE
        else
          Mode := LDAP_MOD_REPLACE;

        Entry.AddAttr(Name, Value, Mode)
       end;
  end;

begin
  if _cn.Text = '' then
    raise Exception.Create(Format(stReqNoEmpty, [NameLabel.Caption]));
  if ipHostNumber.Text = '' then
    raise Exception.Create(Format(stReqNoEmpty, [IPLabel.Caption]));

  try
    if EditMode = EM_ADD then
    begin
      Entry := TLDAPEntry.Create(Session, 'cn=' + _cn.Text + ',' + dn);
      Entry.AddAttr('objectclass', 'top', LDAP_MOD_ADD);
      Entry.AddAttr('objectclass', 'device', LDAP_MOD_ADD);
      Entry.AddAttr('objectclass', 'ipHost', LDAP_MOD_ADD);
//      Entry.AddAttr('cn', _cn.Text, LDAP_MOD_ADD);
    end;

    AddModEntry(Entry, 'ipHostNumber', ipHostNumber.Text, ipHostNumber.Modified);
    AddModEntry(Entry, 'description', description.Text, description.Modified);

    if cn.Tag = 1 then
    begin
      AddModEntry(Entry, 'cn', _cn.Text);

      for C := 0 to cn.Items.Count - 1 do
        if cn.Items[C] <> '' then
          AddModEntry(Entry, 'cn', cn.Items[C]);
    end;

    if EditMode = EM_ADD then
      Entry.New
    else
      Entry.Modify;
  except
    raise;
  end;
end;


constructor THostDlg.Create(AOwner: TComponent; dn: string; Session: TLDAPSession; Mode: TEditMode);
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
    _cn.Enabled := False;
    _cn.text := Session.GetNameFromDN(dn);
    Caption := Format(cPropertiesOf, [_cn.Text]);
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
          if Components[C] is TListBox then
          begin
            if attrValue <> _cn.Text then
              TListBox(Components[C]).Items.Add(attrValue);
          end
          else
            TEdit(Components[C]).Text := attrValue;
        end;
      end;
    end;
  end
  else
    cn.Tag := 1;
end;

procedure THostDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOK then
    Save;
  Action := caFree;
end;

procedure THostDlg.HostButtons(Enable: Boolean);
begin
  Enable := Enable and (cn.ItemIndex > -1);
  DelHostBtn.Enabled := Enable;
  EditHostBtn.Enabled := Enable;
  UpBtn.Enabled := Enable;
  DownBtn.Enabled := Enable;
end;

procedure THostDlg.AddHostBtnClick(Sender: TObject);
var
  s: string;
begin
  s := '';
  if InputDlg(cAddHost, cHostName, s) and (s <> '') then
  begin
    cn.Items.Add(s);
    cn.tag := 1;
    HostButtons(true);
  end;
end;

procedure THostDlg.EditHostBtnClick(Sender: TObject);
var
  s: string;
begin
  s := cn.Items[cn.ItemIndex];
  if InputDlg(cEditHost, cHostName, s) then
  begin
    cn.Items[cn.ItemIndex] := s;
    cn.tag := 1;
  end;
end;

procedure THostDlg.DelHostBtnClick(Sender: TObject);
var
  idx: Integer;
begin
  with cn do begin
    idx := ItemIndex;
    Items.Delete(idx);
    if idx < Items.Count then
      ItemIndex := idx
    else
      ItemIndex := Items.Count - 1;
    Tag := 1;
    if Items.Count = 0 then
      HostButtons(false);
  end;
end;

procedure THostDlg.UpBtnClick(Sender: TObject);
var
  idx: Integer;
begin
  with cn do begin
    idx := ItemIndex;
    if idx > 0 then
    begin
      Items.Move(idx, idx - 1);
      ItemIndex := idx - 1;
    end;
    Tag := 1;
  end;
end;

procedure THostDlg.DownBtnClick(Sender: TObject);
var
  idx: Integer;
begin
  with cn do begin
    idx := ItemIndex;
    if idx < Items.Count - 1 then
    begin
      Items.Move(idx, idx + 1);
      ItemIndex := idx + 1;
    end;
    Tag := 1;
  end;
end;

procedure THostDlg.cnClick(Sender: TObject);
begin
  HostButtons(true);
end;

end.
