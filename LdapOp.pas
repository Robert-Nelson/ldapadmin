  {      LDAPAdmin - LdapOp.pas
  *      Copyright (C) 2004-2005 Tihomir Karlovic
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
    fSrcSession: TLDAPSession;
    fDstSession: TLDAPSession;
    function GetDstSession: TLDAPSession;
    procedure DeleteLeaf(const Entry: TLdapEntry);
    procedure DeleteChildren(const dn: string; Children: Boolean);
    procedure Copy(const dn, pdn, rdn: string; Move: Boolean);
  public
    constructor Create(AOwner: TComponent; ASession: TLDAPSession); reintroduce;
    procedure CopyTree(const dn, pdn, rdn: string);
    procedure MoveTree(const dn, pdn, rdn: string);
    procedure DeleteTree(const adn: string);
    property SourceSession: TLDAPSession read fSrcSession;
    property DestSession: TLDAPSession read GetDstSession write fDstSession;
  end;

var
  LdapOpDlg: TLdapOpDlg;

implementation

{$R *.DFM}

uses Constant;

function TLdapOpDlg.GetDstSession: TLDAPSession;
begin
  if Assigned(fDstSession) then
    Result := fDstSession
  else
    Result := fSrcSession
end;

{ This procedure copies entire subtree to a different location (dn). If Move is
  set to true then the source entries are deleted, effectivly moving the tree }
procedure TLdapOpDlg.Copy(const dn, pdn, rdn: string; Move: Boolean);
var
  EntryList: TLdapEntryList;
  srcEntry, dstEntry: TLDAPEntry;
  srdn: string;
  i, j: Integer;
  Attr: TLdapAttribute;
begin

  //Copy base entry
  if rdn = '' then
    srdn := GetRdnFromDn(dn)
  else
    srdn := rdn;
  srcEntry := TLDAPEntry.Create(SourceSession, dn);
  if SourceSession <> DestSession then
    dstEntry := TLDAPEntry.Create(DestSession, dn)
  else
    dstEntry := srcEntry;
  with srcEntry do
  try
    Read;
    if SourceSession <> DestSession then
    begin
      for i := 0 to srcEntry.Attributes.Count - 1 do with srcEntry.Attributes[i] do
      begin
        Attr := dstEntry.Attributes.Add(Name);
        for j := 0 to ValueCount - 1 do with Values[j] do
          Attr.AddValue(Data, DataSize);
      end;
    end;
    dstEntry.dn := srdn + ',' + pdn;
    dstEntry.Write;
  finally
    if dstEntry <> srcEntry then
      dstEntry.Free;
    Free;
  end;

  if Move then
  begin
    if SourceSession = DestSession then
      // Adjust mailgroup references to new dn
      SourceSession.ModifySet(Format(sMY_MAILGROUP,[dn]), SourceSession.Base, LDAP_SCOPE_SUBTREE,
                              'member', dn, PChar(srdn + ',' + pdn), LDAP_MOD_REPLACE)
    else
      // Remove mailgroup references
      SourceSession.ModifySet(Format(sMY_MAILGROUP,[dn]),
                              SourceSession.Base, LDAP_SCOPE_SUBTREE, 'member', dn, '', LDAP_MOD_DELETE);
    end;

  // Copy subentries
  EntryList := TLdapEntryList.Create;
  try
    SourceSession.Search(sANYCLASS, dn, LDAP_SCOPE_ONELEVEL, nil, false, EntryList);

    if not Visible and  (EntryList.Count > 0) then
      Show;

    for i := 0 to EntryList.Count - 1 do with EntryList[i] do
    begin
      if ModalResult <> mrNone then
        Break;
      Exporting.Caption := dn;
      Application.ProcessMessages;
      if ModalResult <> mrNone then
        Break;
      Copy(dn, srdn +',' + pdn, '', Move);
      if Move then
        Delete;
    end;
  finally
    EntryList.Free;
  end;
end;

{ Deletes one leaf. If the leaf is simple entry it just deletes it, if the leaf
  represents posixAccount it removes memberUid from groups before deleting) }
procedure TLdapOpDlg.DeleteLeaf(const Entry: TLdapEntry);
var
  i: Cardinal;
  s, uid: string;
begin
  Entry.Delete;
  with Entry.AttributesByName['objectclass'] do
  for i := 0 to ValueCount - 1 do
  begin
    s := lowercase(Values[i].AsString);
    if s = 'posixaccount' then with SourceSession do
    begin
      // Remove any references to uid from groups before deleting user itself;
      //TODO: Entry := TPosixAccount.Create(SourceSession, dn);
      uid := GetNameFromDN(Entry.dn);
      ModifySet(Format(sMY_GROUP,[uid]), Base, LDAP_SCOPE_SUBTREE,
                'memberUid', uid, '', LDAP_MOD_DELETE);
      break;
    end;
  end;
end;

{ This procedure checks for leaf's children and deletes them recursively if
  boolean Children is set to true. Otherwise, user is prompted to delete }
procedure TLdapOpDlg.DeleteChildren(const dn: string; Children: Boolean);
var
  EntryList: TLdapEntryList;
  i: Integer;
begin
  EntryList := TLdapEntryList.Create;
  try
    SourceSession.Search(sANYCLASS, dn, LDAP_SCOPE_ONELEVEL, ['objectclass'], false, EntryList);
    if not Children and (EntryList.Count > 0) then
    begin
      if MessageBox(Handle, PChar(Format(stDeleteAll, [dn])), PChar(cConfirm), MB_YESNO + MB_ICONQUESTION) <> IDYES then
      begin
        ModalResult := mrCancel;
        Exit;
      end;
      Show;
    end;
    for i := 0 to EntryList.Count - 1 do with EntryList[i] do
    begin
      DeleteChildren(dn, true);
      if ModalResult <> mrNone then
        Break;
      Exporting.Caption := dn;
      Application.ProcessMessages;
      if ModalResult <> mrNone then
        Break;
      Delete;
    end;
  finally
    EntryList.Free;
  end;
end;

constructor TLdapOpDlg.Create(AOwner: TComponent; ASession: TLDAPSession);
begin
  inherited Create(AOwner);
  fSrcSession := ASession;
end;

procedure TLdapOpDlg.CopyTree(const dn, pdn, rdn: string);
begin
  Message.Caption := cCopying;
  ModalResult := mrNone;
  Copy(dn, pdn, rdn, false);
end;

procedure TLdapOpDlg.MoveTree(const dn, pdn, rdn: string);
begin
  if System.Copy(pdn, Pos(dn, pdn), Length(pdn)) = dn then
    raise Exception.Create(stMoveOverlap);
  Message.Caption := cMoving;
  ModalResult := mrNone;
  Copy(dn, pdn, rdn, true);
  if ModalResult = mrNone then // if not interrupted by user
    SourceSession.DeleteEntry(dn);
end;

procedure TLdapOpDlg.DeleteTree(const adn: string);
var
  Entry: TLdapEntry;
begin
  Message.Caption := cDeleting;
  ModalResult := mrNone;
  DeleteChildren(adn, false);
  if ModalResult = mrNone then
  begin
    Entry := TLdapEntry.Create(SourceSession, adn);
    try
      Entry.Read;
      DeleteLeaf(Entry);
    finally
      Entry.Free;
    end;
  end;
end;

end.
