  {      LDAPAdmin - MailGroup.pas
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

unit Postfix;

interface

uses Classes, LDAPClasses;

const
  USR_ADD           =  1;
  USR_DEL           = -1;

type
  TMailGroup = class(TLDAPEntry)
  private
    fCn: string;
    fDescription: string;
    fMails: TStringList;
    fMembers: TStringList;
  procedure HandleList(l: TStringList; mdn: string; ModOp: Integer);
  protected
    procedure SyncProperties; virtual;
    procedure FlushProperty(const attrn, attrv: string);
    procedure FlushProperties; virtual;
  public
    constructor Create(const ASession: TLDAPSession; const adn: string); override;
    constructor Copy(const CEntry: TLdapEntry); override;
    destructor Destroy; override;
    procedure AddMail(const AMail: string); virtual;
    procedure ModifyMail(const OMail, AMail: string); virtual;
    procedure RemoveMail(const AMail: string); virtual;
    procedure AddMember(const AMember: string); virtual;
    procedure RemoveMember(const AMember: string); virtual;
    procedure New; override;
    procedure Modify; override;
    //procedure Delete; override;
    procedure Read; override;
    property Cn: string read fCn write fCn;
    property Description: string read fDescription write fDescription;
    property Mails: TStringList read fMails;
    property Members: TStringList read fMembers;
  end;


implementation

uses Winldap, Sysutils;

{ TMailGroup }

procedure TMailGroup.HandleList(l: TStringList; mdn: string; ModOp: Integer);
var
  i,v: Integer;
begin
  i := l.IndexOf(mdn);
  if i < 0 then
  begin
    i := l.Add(mdn);
    l.Objects[i] := Pointer(USR_ADD);
  end
  else begin
    v := Integer(l.Objects[I]) + ModOp;
    l.Objects[i] := Pointer(v);
  end;
end;

procedure TMailGroup.SyncProperties;
var
  i: integer;
  attrName: string;
begin
  inherited;
  fMembers.Clear;
  if Assigned(Items) then
  begin
    for i := 0 to Items.Count - 1 do
    begin
      attrName := lowercase(Items[i]);

      if attrName = 'cn' then
        fCn := PChar(Items.Objects[i])
      else
      if attrName = 'description' then
        fDescription := PChar(Items.Objects[i])
      else
      if attrName = 'mail' then
        fMails.Add(PChar(Items.Objects[i]))
      else
      if attrName = 'member' then
        fMembers.Add(PChar(Items.Objects[i]));
    end;
  end;
end;

procedure TMailGroup.FlushProperty(const attrn, attrv: string);
var
  idx: Integer;
begin
  if Assigned(Items) then
  begin
    idx := Items.IndexOf(attrn);
    if idx <> -1 then // Atribute already exists, modify
    begin
      if attrv = '' then
        AddAttr(attrn, PChar(Items.Objects[idx]), LDAP_MOD_DELETE)
      else
        if attrv <> PChar(Items.Objects[idx]) then
            AddAttr(attrn, attrv, LDAP_MOD_REPLACE)
    end
    else
      if attrv <> '' then
        AddAttr(attrn, attrv, LDAP_MOD_ADD);
  end
  else
    if attrv <> '' then
      AddAttr(attrn, attrv, LDAP_MOD_ADD);
end;

procedure TMailGroup.FlushProperties;
var
  i, Modop: Integer;
begin
  FlushProperty('cn', fCn);
  FlushProperty('description', fDescription);
//  FlushProperty('mail', fMail);

  for i := 0 to fMails.Count - 1 do
  begin
    modop := Integer(fMails.Objects[i]);
    if modop > 0 then
      AddAttr('mail', fMails[i], LDAP_MOD_ADD)
    else
    if modop < 0 then
      AddAttr('mail', fMails[i], LDAP_MOD_DELETE)
  end;

  for i := 0 to fMembers.Count - 1 do
  begin
    modop := Integer(fMembers.Objects[i]);
    if modop > 0 then
      AddAttr('member', fMembers[i], LDAP_MOD_ADD)
    else
    if modop < 0 then
      AddAttr('member', fMembers[i], LDAP_MOD_DELETE)
  end;
end;

constructor TMailGroup.Create(const ASession: TLDAPSession; const adn: string);
begin
  inherited;
  fMembers := TStringList.Create;
  fMails := TStringList.Create;
end;

constructor TMailGroup.Copy(const CEntry: TLdapEntry);
var
  i: Integer;
begin
  inherited;
  if CEntry is TMailGroup then
  begin
    fCn := TMailGroup(CEntry).fCn;
    fDescription := TMailGroup(CEntry).fDescription;
    fMails := TStringList.Create;
    for i := 0 to TMailGroup(CEntry).fMails.Count - 1 do
    begin
      fMails.Add(TMailGroup(CEntry).fMails[i]);
      fMails.Objects[i] := TMailGroup(CEntry).fMails.Objects[i];
    end;
    fMembers := TStringList.Create;
    for i := 0 to TMailGroup(CEntry).fMembers.Count - 1 do
    begin
      fMembers.Add(TMailGroup(CEntry).fMembers[i]);
      fMembers.Objects[i] := TMailGroup(CEntry).fMembers.Objects[i];
    end;
  end;
end;

destructor TMailGroup.Destroy;
begin
  FreeAndNil(fMails);
  FreeAndNil(fMembers);
  
  inherited;
end;

procedure TMailGroup.AddMail(const AMail: string);
begin
  HandleList(fMails, AMail, USR_ADD);
end;

procedure TMailGroup.ModifyMail(const OMail, AMail: string);
begin
  HandleList(fMails, OMail, USR_DEL);
  HandleList(fMails, AMail, USR_ADD);
end;

procedure TMailGroup.RemoveMail(const AMail: string);
begin
  HandleList(fMails, AMail, USR_DEL);
end;

procedure TMailGroup.AddMember(const AMember: string);
begin
  HandleList(fMembers, AMember, USR_ADD);
end;

procedure TMailGroup.RemoveMember(const AMember: string);
begin
  HandleList(fMembers, AMember, USR_DEL);
end;

procedure TMailGroup.New;
begin
  AddAttr('objectclass', 'mailGroup', LDAP_MOD_ADD);
  AddAttr('objectclass', 'top', LDAP_MOD_ADD);
  FlushProperties;
  inherited;
end;

procedure TMailGroup.Modify;
begin
  FlushProperties;
  inherited;
end;

procedure TMailGroup.Read;
begin
  inherited;
  SyncProperties;
end;

end.
