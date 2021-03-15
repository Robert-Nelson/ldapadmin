  {      LDAPAdmin - Posix.pas
  *      Copyright (C) 2003 Tihomir Karlovic
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

unit Posix;

interface

uses LDAPClasses, Winldap, Classes;

type
  TProperties = integer;

const
    eUidNumber           = 0;
    eGidNumber           = 1;
    eUid                 = 2;
    eCn                  = 3;
    eUserPassword        = 4;
    eHomeDirectory       = 5;
    eLoginShell          = 6;
    eGecos               = 7;
    eDescription         = 8;
    eShadowFlag          = 9;
    eShadowMin           = 10;
    eShadowMax           = 11;
    eShadowWarning       = 12;
    eShadowInactive      = 13;
    eShadowLastChange    = 14;
    eShadowExpire        = 15;
    eGivenName           = 16;
    eInitials            = 17;
    eSn                  = 18;
    eDisplayName         = 19;

const
  PropAttrNames: array[eUidNumber..eDisplayName] of string = (
    'uidNumber',
    'gidNumber',
    'uid',
    'Cn',
    'userPassword',
    'homeDirectory',
    'loginShell',
    'gecos',
    'description',
    'shadowFlag',
    'shadowMin',         // min number of days between password changes
    'shadowMax',         // max number of days password is valid
    'shadowWarning',     // numer of days before password expiry to warn user
    'shadowInactive',    // numer of days to allow account to be inactive
    'shadowLastChange',  // last change of shadow info, int value
    'shadowExpire',      // absolute date to expire account counted in days since 1.1.1970
    'givenName',         // following are InetOrg attributes but I consider them to be part of the user account
    'initials',
    'sn',
    'displayName'
    );

const
  SHADOW_FLAG            = 0;
  SHADOW_MIN_DATE        = 0;
  SHADOW_MAX_DATE        = 99999;
  SHADOW_WARNING         = 0;
  SHADOW_INACTIVE        = 99999;
  SHADOW_LAST_CHANGE     = 12011;
  SHADOW_EXPIRE          = 99999;

type
  TPosixAccount = class(TLDAPEntry)
  private
    fShadow: Boolean;
    fInetOrg: Boolean;
    Properties: array [eUidNumber..eDisplayName] of string;
    procedure SetInt(Index: TProperties; Value: Integer);
    function  GetInt(Index: TProperties): Integer;
  protected
    procedure SetInetOrgProp(Index: TProperties; const Value: string); virtual;
    procedure SetProperty(Index: TProperties; Value: string; var AProperty: string); virtual;
    procedure SetShadow(Value: Boolean); virtual;
    procedure SetInetOrg(Value: Boolean); virtual;
    procedure SetUserPassword(const Password: string); virtual;
    procedure SetByName(var Properties, PropAttrNames: array of string; const AProperty, AValue: string);
    procedure SyncProperties(var Properties, PropAttrNames: array of string);
    procedure FlushProperties(var Properties, PropAttrNames: array of string);
  public
    constructor Create(apld: PLDAP; adn: string); override;
    constructor Copy(const CEntry: TLdapEntry); override;
    procedure New; override;
    procedure Modify; override;
    procedure Read; override;
    property Shadow: Boolean read fShadow write SetShadow;
    property InetOrg: Boolean read fInetOrg write SetInetOrg;
    property uidNumber: Integer index eUidNumber read GetInt write SetInt;
    property gidNumber: Integer index eGidNumber read GetInt write SetInt;
    property uid: string read Properties[eUid] write Properties[eUid];
    property Cn: string read Properties[eCn] write Properties[eCn];
    property UserPassword: string read Properties[eUserPassword] write SetUserPassword;
    property HomeDirectory: string read Properties[eHomeDirectory] write Properties[eHomeDirectory];
    property LoginShell: string read Properties[eLoginShell] write Properties[eLoginShell];
    property Gecos: string read Properties[eGecos] write Properties[eGecos];
    property Description: string read Properties[eDescription] write Properties[eDescription];
    property ShadowFlag: Integer index eShadowFlag read GetInt write SetInt;
    property ShadowMin: Integer index eShadowMin read GetInt write SetInt;
    property ShadowMax: Integer index eShadowMax read GetInt write SetInt;
    property ShadowWarning: Integer index eShadowWarning read GetInt write SetInt;
    property ShadowInactive: Integer index eShadowInactive read GetInt write SetInt;
    property ShadowLastChange: Integer index eShadowLastChange read GetInt write SetInt;
    property ShadowExpire: Integer index eShadowExpire read GetInt write SetInt;
    property GivenName: string index eGivenName read Properties[eGivenName] write SetInetOrgProp;
    property Initials: string index eInitials read Properties[eInitials] write SetInetOrgProp;
    property Sn: string index eSn read Properties[eSn] write SetInetOrgProp;
    property DisplayName: string index eDisplayName read Properties[eDisplayName] write SetInetOrgProp;
  end;

const
  USR_ADD           =  1;
  USR_DEL           = -1;

type
  TPosixGroup = class(TLDAPEntry)
  private
    fGidNumber: Integer;
    fCn: string;
    fDescription: string;
    fMembers: TStringList;
  procedure HandleMemberList(mdn: string; ModOp: Integer);
  protected
    procedure SyncProperties; virtual;
    procedure FlushProperty(const attrn, attrv: string);
    procedure FlushProperties; virtual;
  public
    constructor Create(apld: PLDAP; adn: string); override;
    constructor Copy(const CEntry: TLdapEntry); override;
    procedure AddMember(const AMember: string); virtual;
    procedure RemoveMember(const AMember: string); virtual;
    procedure New; override;
    procedure Modify; override;
    procedure Read; override;
    property GidNumber: Integer read fGidNumber write fGidNumber;
    property Cn: string read fCn write fCn;
    property Description: string read fDescription write fDescription;
    property Members: TStringList read fMembers;
  end;

implementation

uses Sysutils, md5, base64, Constant;

procedure TPosixAccount.SetInt(Index: TProperties; Value: Integer);
begin
  if not fShadow and (Index >= eShadowFlag) and (Index <= eShadowExpire) then
    raise Exception.Create('Shadow properties not allowed!');
  SetProperty(Index, IntToStr(Value), Properties[Index]);
end;

function TPosixAccount.GetInt(Index: TProperties): Integer;
begin
  Result := StrToInt(Properties[Index]);
end;

procedure TPosixAccount.SetInetOrgProp(Index: TProperties; const Value: string);
begin
  if not fInetOrg then
    raise Exception.Create('InetOrg properties not allowed!');
  Properties[Index] := Value;
end;

procedure TPosixAccount.SetProperty(Index: TProperties; Value: string; var AProperty: string);
begin
  AProperty := Value;
end;

procedure TPosixAccount.SetShadow(Value: Boolean);
var
  i: TProperties;
begin
  if Assigned(Items) then
    raise Exception.Create('Shadow property locked!');
  fShadow := Value;
  if Value then
  begin
    shadowFlag := SHADOW_FLAG;
    shadowMin := SHADOW_MIN_DATE;
    shadowMax := SHADOW_MAX_DATE;
    shadowWarning := SHADOW_WARNING;
    shadowInactive := SHADOW_INACTIVE;
    shadowLastChange := SHADOW_LAST_CHANGE;
    shadowExpire := SHADOW_EXPIRE;
  end
  else
    for i := eShadowFlag to eShadowExpire do
      Properties[i] := '';
end;

procedure TPosixAccount.SetInetOrg(Value: Boolean);
var
  i: TProperties;
begin
  if Assigned(Items) then
    raise Exception.Create('InetOrg property locked!');
  if not Value then
    for i := eGivenName to eDisplayName do
      Properties[i] := '';
  fInetOrg := Value;
end;

procedure TPosixAccount.SetUserPassword(const Password: string);
var
  adigest: digest;
  passwd: string;
begin
  md5digest(PChar(Password), length(Password), adigest);
  SetLength(passwd, Base64Size(SizeOf(digest)));
  Base64Encode(adigest, SizeOf(digest), passwd[1]);
  Properties[eUserPassword] := '{MD5}' + passwd;
end;

procedure TPosixAccount.SetByName(var Properties, PropAttrNames: array of string; const AProperty, AValue: string);
var
  i: Integer;
begin
  for i := Low(Properties) to High(Properties) do
    if AnsiStrIComp(PChar(PropAttrNames[i]), PChar(AProperty)) = 0 then
      Properties[i] := AValue;
end;

procedure TPosixAccount.SyncProperties(var Properties, PropAttrNames: array of string);
var
  i: Integer;
  p: PChar;
begin
  for i := 0 to Items.Count-1 do
  begin
    p := PChar(Items.Objects[i]);
    if AnsiStrIComp(p, 'shadowaccount') = 0 then
      fShadow := true
    else
    if AnsiStrIComp(p, 'inetorgperson') = 0 then
      fInetOrg := true;
    SetByName(Properties, PropAttrNames, Items[i], PChar(Items.Objects[i]));
  end;
end;

procedure TPosixAccount.FlushProperties(var Properties, PropAttrNames: array of string);
var
  i: Integer;
  idx: Integer;
  attrn, attrv: string;
begin
  for i := Low(Properties) to High(Properties) do
  begin
    attrn := PropAttrNames[i];
    attrv := Properties[i];
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
  end;
end;

constructor TPosixAccount.Create(apld: PLDAP; adn: string);
begin
  inherited;
  { Set defaults, note that we assign values to properties here }
  //userPassword := '';
end;

constructor TPosixAccount.Copy(const CEntry: TLdapEntry);
var
  i: TProperties;
begin
  inherited;
  if CEntry is TPosixAccount then
  begin
    fShadow := TPosixAccount(CEntry).fShadow;
    fInetOrg := TPosixAccount(CEntry).fInetOrg;
    for i := Low(Properties) to High(Properties) do
      Properties[i] := TPosixAccount(CEntry).Properties[i];
  end
  else
    SyncProperties(Properties, PropAttrNames)
end;

procedure TPosixAccount.New;
var
  i: TProperties;
begin
  AddAttr('objectclass', 'top', LDAP_MOD_ADD);
  AddAttr('objectclass', 'posixAccount', LDAP_MOD_ADD);
  if fShadow then
    AddAttr('objectclass', 'shadowAccount', LDAP_MOD_ADD);
  if fInetOrg then
    AddAttr('objectclass', 'inetOrgPerson', LDAP_MOD_ADD)
  else
    AddAttr('objectclass', 'account', LDAP_MOD_ADD);
  for i := Low(Properties) to High(Properties) do
    if Properties[i] <> '' then
      AddAttr(PropAttrNames[i], Properties[i], LDAP_MOD_ADD);
  inherited;
end;

procedure TPosixAccount.Modify;
begin
  if not Assigned(Items) then
    raise Exception.Create(stObjnRetrvd);
  FlushProperties(Properties, PropAttrNames);
  inherited;
end;

procedure TPosixAccount.Read;
begin
  inherited;
  SyncProperties(Properties, PropAttrNames);
end;

{ TPosixGroup }

{ This works as follows: if dn is new member then it wont be in fMembers list so
  we add it there. If its already there add operation modus to its tag value
  (which is casted Objects array). This way we can handle repeatingly adding and
  removing of same users: if it sums up to 0 we dont have to do anything, if
  its > 0 we add member to this group in LDAP directory and if its < 0 we remove
  member from this group in LDAP directory }
procedure TPosixGroup.HandleMemberList(mdn: string; ModOp: Integer);
var
  i,v: Integer;

begin
  i := fMembers.IndexOf(mdn);
  if i < 0 then
  begin
    i := fMembers.Add(mdn);
    fMembers.Objects[i] := Pointer(USR_ADD);
  end
  else begin
    v := Integer(fMembers.Objects[I]) + ModOp;
    fMembers.Objects[i] := Pointer(v);
  end;
end;

procedure TPosixGroup.SyncProperties;
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

      if attrName = 'gidnumber' then
        fGidNumber := StrToInt(PChar(Items.Objects[i]))
      else
      if attrName = 'cn' then
        fCn := PChar(Items.Objects[i])
      else
      if attrName = 'description' then
        fDescription := PChar(Items.Objects[i])
      else
      if attrName = 'memberuid' then
        fMembers.Add(PChar(Items.Objects[i]));
    end;
  end;
end;

procedure TPosixGroup.FlushProperty(const attrn, attrv: string);
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

procedure TPosixGroup.FlushProperties;
var
  i, Modop: Integer;
begin
  FlushProperty('gidNumber', IntToStr(fGidNumber));
  FlushProperty('cn', fCn);
  FlushProperty('description', fDescription);

  for i := 0 to fMembers.Count - 1 do
  begin
    modop := Integer(fMembers.Objects[i]);
    if modop > 0 then
      AddAttr('memberuid', fMembers[i], LDAP_MOD_ADD)
    else
    if modop < 0 then
      AddAttr('memberuid', fMembers[i], LDAP_MOD_DELETE)
  end;
end;

constructor TPosixGroup.Create(apld: PLDAP; adn: string);
begin
  inherited;
  fMembers := TStringList.Create;
end;

constructor TPosixGroup.Copy(const CEntry: TLdapEntry);
var
  i: Integer;
begin
  inherited;
  if CEntry is TPosixGroup then
  begin
    fGidNumber := TPosixGroup(CEntry).fGidNumber;
    fCn := TPosixGroup(CEntry).fCn;
    fDescription := TPosixGroup(CEntry).fDescription;
    fMembers := TStringList.Create;
    for i := 0 to TPosixGroup(CEntry).fMembers.Count - 1 do
    begin
      fMembers.Add(TPosixGroup(CEntry).fMembers[i]);
      fMembers.Objects[i] := TPosixGroup(CEntry).fMembers.Objects[i];
    end;
  end;
end;

procedure TPosixGroup.AddMember(const AMember: string);
begin
  HandleMemberList(AMember, USR_ADD);
end;

procedure TPosixGroup.RemoveMember(const AMember: string);
begin
  HandleMemberList(AMember, USR_DEL);
end;

procedure TPosixGroup.New;
begin
  AddAttr('objectclass', 'top', LDAP_MOD_ADD);
  AddAttr('objectclass', 'posixGroup', LDAP_MOD_ADD);
  FlushProperties;
  inherited;
end;

procedure TPosixGroup.Modify;
begin
  FlushProperties;
  inherited;
end;

procedure TPosixGroup.Read;
begin
  inherited;
  SyncProperties;
end;

end.
