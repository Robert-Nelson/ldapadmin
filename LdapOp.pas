  {      LDAPAdmin - LdapOp.pas
  *      Copyright (C) 2004-2007 Tihomir Karlovic
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
    ProgressBar: TProgressBar;
    PathLabel: TLabel;
  private
    fSrcSession: TLDAPSession;
    fDstSession: TLDAPSession;
    fShowProgress: Boolean;
    fSmartDelete: Boolean;
    fDeleteAll: Boolean;
    procedure SetShowProgress(Value: Boolean);
    function GetDstSession: TLDAPSession;
    procedure Prepare(const dn: string); overload;
    procedure Prepare(List: TStringList); overload;
    procedure DeleteLeaf(const Entry: TLdapEntry);
    procedure DeleteChildren(const dn: string);
    procedure Copy(const dn, pdn, rdn: string; Move: Boolean);
  public
    constructor Create(AOwner: TComponent; ASession: TLDAPSession); reintroduce;
    procedure CopyTree(const dn, pdn, rdn: string; Move: Boolean); overload;
    procedure CopyTree(List: TStringList; const DestDn: string; Move: Boolean); overload;
    procedure DeleteTree(const adn: string); overload;
    procedure DeleteTree(List: TStringList); overload;
    property SourceSession: TLDAPSession read fSrcSession;
    property DestSession: TLDAPSession read GetDstSession write fDstSession;
    property ShowProgress: Boolean read fShowProgress write SetShowProgress;
    property DeleteAll: Boolean read fDeleteAll write fDeleteAll;
  end;

var
  LdapOpDlg: TLdapOpDlg;

implementation

{$R *.DFM}

uses Misc, Dialogs, Config, Constant;

procedure TLdapOpDlg.SetShowProgress(Value: Boolean);
begin
  fShowProgress := Value;
  ProgressBar.Visible := Value;
end;

function TLdapOpDlg.GetDstSession: TLDAPSession;
begin
  if Assigned(fDstSession) then
    Result := fDstSession
  else
    Result := fSrcSession
end;

procedure TLdapOpDlg.Prepare(const dn: string);
var
  EntryList: TLdapEntryList;
begin
  if not fShowProgress then
    Exit;
  Message.Caption := cPreparing;
  Message.Refresh;
  EntryList := TLdapEntryList.Create;
  try
    Screen.Cursor := crAppStart;
    SourceSession.Search(sANYCLASS, dn, LDAP_SCOPE_SUBTREE, ['objectclass'], false, EntryList{, SearchCallback});
    if ModalResult = mrCancel then
      Abort;
    ProgressBar.Max := EntryList.Count;
  finally
    Screen.Cursor := crDefault;
    EntryList.Free;
  end;
end;

procedure TLdapOpDlg.Prepare(List: TStringList);
var
  EntryList: TLdapEntryList;
  c, i: Integer;
begin
  if not fShowProgress then
    Exit;
  Message.Caption := cPreparing;
  Message.Refresh;
  EntryList := TLdapEntryList.Create;
  try
    Screen.Cursor := crAppStart;
    c := 0;
    for i := 0 to List.Count - 1 do
    begin
      SourceSession.Search(sANYCLASS, List[i], LDAP_SCOPE_SUBTREE, ['objectclass'], false, EntryList{, SearchCallback});
      if ModalResult = mrCancel then
        Abort;
      inc(c, EntryList.Count);
    end;
    ProgressBar.Max := c;
  finally
    Screen.Cursor := crDefault;
    EntryList.Free;
  end;
end;

{ This procedure copies entire subtree to a different location (dn). If Move is
  set to true then the source entries are deleted, effectivly moving the tree }
procedure TLdapOpDlg.Copy(const dn, pdn, rdn: string; Move: Boolean);
var
  EntryList: TLdapEntryList;
  srcEntry, dstEntry: TLDAPEntry;
  srdn, newdn: string;
  i, j: Integer;
  Attr: TLdapAttribute;
begin

  { Copy base entry }
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

  if Move and fSmartDelete then
  begin
    newdn := srdn + ',' + pdn;
    if SourceSession = DestSession then
      { Adjust group references to new dn }
      SourceSession.ModifySet( Format(sMY_DN_GROUPS,[dn]),
                               SourceSession.Base, LDAP_SCOPE_SUBTREE,
                               ['member', 'uniqueMember'],
                               [dn, dn],
                               [newdn, newdn],
                               LdapOpReplace)
    else
      { Remove group references }
      SourceSession.ModifySet( Format(sMY_DN_GROUPS,[dn]),
                               SourceSession.Base, LDAP_SCOPE_SUBTREE,
                               ['member', 'uniqueMember'],
                               [dn, dn],
                               [newdn, newdn],
                               LdapOpReplace)
    end;

  if fShowProgress then
    ProgressBar.StepIt;

  { Copy subentries }
  EntryList := TLdapEntryList.Create;
  try
    SourceSession.Search(sANYCLASS, dn, LDAP_SCOPE_ONELEVEL, nil, false, EntryList);

    if not Visible and  (EntryList.Count > 0) then
      Show;

    for i := 0 to EntryList.Count - 1 do with EntryList[i] do
    begin
      if ModalResult <> mrNone then
        Break;
      PathLabel.Caption := dn;
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

  if fSmartDelete then with Entry.AttributesByName['objectclass'] do
  for i := 0 to ValueCount - 1 do
  begin
    s := lowercase(Values[i].AsString);
    if s = 'posixaccount' then with SourceSession do
    begin
      { Remove any references to uid from groups before deleting user itself; }
      //TODO: Entry := TPosixAccount.Create(SourceSession, dn);
      uid := GetNameFromDN(Entry.dn);
      ModifySet(Format(sMY_GROUPS,[uid, Entry.dn]), Base, LDAP_SCOPE_SUBTREE,
                ['memberUid', 'uniqueMember', 'member'],
                [uid, Entry.dn, Entry.dn], [], LdapOpDelete);
      break;
    end;
  end;
end;

{ This procedure checks for leaf's children and deletes them recursively if
  boolean fDeleteAll is set to true. Otherwise, user is prompted to delete }
procedure TLdapOpDlg.DeleteChildren(const dn: string);
var
  EntryList: TLdapEntryList;
  i: Integer;
begin
  EntryList := TLdapEntryList.Create;
  try
    SourceSession.Search(sANYCLASS, dn, LDAP_SCOPE_ONELEVEL, ['objectclass'], false, EntryList);
    if not fDeleteAll and (EntryList.Count > 0) then
    begin
      if CheckedMessageDlg(PChar(Format(stDeleteAll, [dn])), mtWarning, [mbYes, mbNo], cSmartDelete, fSmartDelete) <> mrYes then
      begin
        ModalResult := mrCancel;
        Exit;
      end;
      fDeleteAll := true;
      Show;
    end;
    for i := 0 to EntryList.Count - 1 do with EntryList[i] do
    begin
      DeleteChildren(dn);
      if ModalResult <> mrNone then
        Break;
      PathLabel.Caption := dn;
      Application.ProcessMessages;
      if ModalResult <> mrNone then
        Break;
      Delete;
      if fShowProgress then
        ProgressBar.StepIt;
    end;
  finally
    EntryList.Free;
  end;
end;

constructor TLdapOpDlg.Create(AOwner: TComponent; ASession: TLDAPSession);
begin
  inherited Create(AOwner);
  fSrcSession := ASession;
  fSmartDelete := GlobalConfig.ReadBool(rSmartDelete, true);
end;

procedure TLdapOpDlg.CopyTree(const dn, pdn, rdn: string; Move: Boolean);
begin
 if Move and (System.Copy(pdn, Pos(dn, pdn), Length(pdn)) = dn) then
   raise Exception.Create(stMoveOverlap);
  Prepare(dn);
  if Move then
    Message.Caption := cMoving
  else
    Message.Caption := cCopying;
  ModalResult := mrNone;
  Copy(dn, pdn, rdn, Move);
  if Move and (ModalResult = mrNone) then // if not interrupted by user
  begin
    SourceSession.DeleteEntry(dn);
    if rdn <> '' then // base entry renamed, adjust posix group references
      with SourceSession do
      ModifySet(Format(sMY_POSIX_GROUPS,[GetNameFromDn(dn)]), Base, LDAP_SCOPE_SUBTREE,
                ['memberUid'],
                [GetNameFromDn(dn)],
                [GetNameFromDn(rdn)], LdapOpReplace);
  end;
end;

procedure TLdapOpDlg.CopyTree(List: TStringList; const DestDn: string; Move: Boolean);
var
  i: Integer;
  dn: string;
begin
  Prepare(List);
  if Move then
    Message.Caption := cMoving
  else
    Message.Caption := cCopying;
  ModalResult := mrNone;
  for i := 0 to List.Count - 1 do
  begin
    if Move then
    begin
      dn := List[i];
      if System.Copy(DestDn, Pos(dn, DestDn), Length(DestDn)) = dn then
        raise Exception.Create(stMoveOverlap);
    end;
    Copy(List[i], DestDn, '', Move);
    if ModalResult = mrCancel then
      Break;
    if Move then
    begin
      SourceSession.DeleteEntry(dn);
      if List.Objects[i] is TTreeNode then
        TTreeNode(List.Objects[i]).Delete;
    end;
  end;
end;

procedure TLdapOpDlg.DeleteTree(const adn: string);
var
  Entry: TLdapEntry;
begin
  Prepare(adn);
  Message.Caption := cDeleting;
  ModalResult := mrNone;
  DeleteChildren(adn);
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

procedure TLdapOpDlg.DeleteTree(List: TStringList);
var
  Entry: TLdapEntry;
  i: Integer;
begin
  Message.Caption := cDeleting;
  ModalResult := mrNone;
  Prepare(List);
  for i := 0 to List.Count - 1 do
  begin
    DeleteChildren(List[i]);
    if ModalResult = mrCancel then
      Break;
    Entry := TLdapEntry.Create(SourceSession, List[i]);
    try
      Entry.Read;
      DeleteLeaf(Entry);
    finally
      Entry.Free;
    end;
  end;
end;

end.
