  {      LDAPAdmin - LdapOp.pas
  *      Copyright (C) 2004 Tihomir Karlovic
  *
  *      Author: Tihomir Karlovic
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

unit LdapOp;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, ComCtrls, LDAPClasses, WinLdap, Posix;

type
  TLdapOpDlg = class(TForm)
    CancelBtn: TButton;
    Message: TLabel;
    Exporting: TLabel;
  private
    Session: TLDAPSession;
    Running: Boolean;
    procedure DeleteLeaf(const dn: PChar; const pld: PLDAP; const plmEntry: PLDAPMessage);
    procedure DeleteChildren(const dn: string; Children: Boolean);
    procedure Copy(const dn, pdn, rdn: string; Move: Boolean);
  public
    constructor Create(AOwner: TComponent; ASession: TLDAPSession); reintroduce;
    procedure CopyTree(const dn, pdn, rdn: string);
    procedure MoveTree(const dn, pdn, rdn: string);
    procedure DeleteTree(const adn: string);
  end;

var
  LdapOpDlg: TLdapOpDlg;

implementation

{$R *.DFM}

uses Constant;

{ This procedure copies entire subtree to a different location (dn). If Move is
  set to true then the source entries are deleted, effectivly moving the tree }

procedure TLdapOpDlg.Copy(const dn, pdn, rdn: string; Move: Boolean);
var
  Entry: TLDAPEntry;
  srdn: string;
  plmSearch, plmEntry: PLDAPMessage;
  pld: PLDAP;
  attrs: PCharArray;
  pszdn: PChar;
  i: Integer;
begin
  // Search for subentries
  SetLength(attrs, 2);
  attrs[0] := 'objectclass';
  attrs[1] := nil;
  pld := Session.pld;
  LdapCheck(ldap_search_s(pld, PChar(dn), LDAP_SCOPE_ONELEVEL, PChar(sANYCLASS), PChar(attrs), 0, plmSearch));

  if not Visible and (ldap_count_entries(pld, plmSearch) > 0) then
    Show;

  try
    //Copy entry
    if rdn = '' then
      srdn := Session.GetRDN(dn)
    else
      srdn := rdn;
    Entry := TLDAPEntry.Create(Session, dn);
    with Entry do
    try
      Read;
      dn := PChar(srdn + ',' + pdn);
      for i := 0 to Items.Count - 1 do
        AddAttr(Entry.Items[i],PChar(Entry.Items.Objects[i]), LDAP_MOD_ADD);
      New;
    finally
      Free;
    end;

    plmEntry := ldap_first_entry(pld, plmSearch);
    while Assigned(plmEntry) do
    begin
      pszdn := ldap_get_dn(pld, plmEntry);
      if Assigned(pszdn) then
      try
        if not Running then
          Abort;
        Exporting.Caption := pszdn;
        Application.ProcessMessages;
        if ModalResult <> mrNone then
        begin
          Running := false;
          Abort;
        end;
        Copy(pszdn, srdn +',' + pdn, '', Move);
        if Move then
          LdapCheck(ldap_delete_s(pld, pszdn));
      finally
        ldap_memfree(pszdn);
      end;
      plmEntry := ldap_next_entry(pld, plmEntry);
    end;
  finally
    LDAPCheck(ldap_msgfree(plmSearch));
  end;
end;

{ Deletes one leaf. If the leaf is simple entry it just deletes it, otherwise
  object instance is created and its Delete method is called. In this way it is
  assured that deleting of special objects, such as Posix or Samba users is
  handeled properly (i.e memberUid is removed from groups before deleting) }

procedure TLdapOpDlg.DeleteLeaf(const dn: PChar; const pld: PLDAP; const plmEntry: PLDAPMessage);
var
  ppcVals: PPChar;
  I: Cardinal;
  s: string;
  Entry: TLDAPEntry;
begin
  Entry := nil;
  ppcVals := ldap_get_values(pld, plmEntry, 'objectclass');
  if Assigned(ppcVals) then
  try
    I := 0;
    while Assigned(PCharArray(ppcVals)[I]) do
    begin
      s := lowercase(PCharArray(ppcVals)[I]);
      if (s = 'posixaccount') or (s = 'sambaaccount') or (s = 'sambasamaccount') then
      begin
        Entry := TPosixAccount.Create(Session, dn);
        break;
      end;
      Inc(I);
    end;
  finally
    LDAPCheck(ldap_value_free(ppcVals));
  end;

  if Assigned(Entry) then
  try
    Entry.Delete
  finally
    Entry.Free;
  end
  else
    LdapCheck(ldap_delete_s(pld, dn));
end;

{ This procedure checks for leaf's children and deletes them recursively if
  boolean Children is set to true. Otherwise, user is prompted to delete }

procedure TLdapOpDlg.DeleteChildren(const dn: string; Children: Boolean);
var
  plmSearch, plmEntry: PLDAPMessage;
  pld: PLDAP;
  attrs: PCharArray;
  pszdn: PChar;
begin

  // set result to objectclass only
  SetLength(attrs, 2);
  attrs[0] := 'objectclass';
  attrs[1] := nil;
  pld := Session.pld;
  LdapCheck(ldap_search_s(pld, PChar(dn), LDAP_SCOPE_ONELEVEL, PChar(sANYCLASS), PChar(attrs), 0, plmSearch));

  if not Children and (ldap_count_entries(pld, plmSearch) > 0) then
  begin
    if MessageBox(Handle, PChar(stDeleteAll), PChar(cConfirm), MB_YESNO + MB_ICONQUESTION) <> IDYES then
      Abort;
    Show;
  end;

  try
    plmEntry := ldap_first_entry(pld, plmSearch);
    while Assigned(plmEntry) do
    begin
      pszdn := ldap_get_dn(pld, plmEntry);
      if Assigned(pszdn) then
      try
        DeleteChildren(pszdn, true);
        if not Running then
          Abort;
        Exporting.Caption := pszdn;
        Application.ProcessMessages;
        if ModalResult <> mrNone then
        begin
          Running := false;
          Abort;
        end;
        DeleteLeaf(pszdn, pld, plmEntry);
      finally
        ldap_memfree(pszdn);
      end;

      plmEntry := ldap_next_entry(pld, plmEntry);
    end;
  finally
    LDAPCheck(ldap_msgfree(plmSearch));
  end;
end;

constructor TLdapOpDlg.Create(AOwner: TComponent; ASession: TLDAPSession);
begin
  inherited Create(AOwner);
  Session := ASession;
end;

procedure TLdapOpDlg.CopyTree(const dn, pdn, rdn: string);
begin
  Message.Caption := cCopying;
  //Show;
  Running := true;
  Copy(dn, pdn, rdn, false);
end;

procedure TLdapOpDlg.MoveTree(const dn, pdn, rdn: string);
begin
  if System.Copy(pdn, Pos(dn, pdn), Length(pdn)) = dn then
    raise Exception.Create(stMoveOverlap);
  Message.Caption := cMoving;
  //Show;
  Running := true;
  Copy(dn, pdn, rdn, true);
  if Running then // if not interrupted by user
    LdapCheck(ldap_delete_s(Session.pld, PChar(dn)));
end;

procedure TLdapOpDlg.DeleteTree(const adn: string);
var
  attrs: PCharArray;
  plmEntry: PLDAPMessage;
begin
  Message.Caption := cDeleting;
  Running := true;
  DeleteChildren(adn, false);
  if Running then
  begin
    SetLength(attrs, 2);
    attrs[0] := 'objectclass';
    attrs[1] := nil;
    LdapCheck(ldap_search_s(Session.pld, PChar(adn), LDAP_SCOPE_BASE, PChar(sANYCLASS), PChar(attrs), 0, plmEntry));
    DeleteLeaf(PChar(adn), Session.pld, plmEntry);
  end;
end;

end.
