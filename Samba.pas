  {      LDAPAdmin - Samba.pas
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

unit Samba;

interface

uses Classes, Posix, LDAPClasses, WinLDAP;

const
  WKRids: array[0..4] of Integer  = (
                                          500,    // Administrator
                                          501,    // Guest
                                          512,    // Domain Admins
                                          513,    // Domain Users
                                          514     // Domain Guests
                                     );

type
  PDomainRec = ^TDomainRec;
  TDomainRec = record
      AlgorithmicRIDBase: Integer;
      DomainName: string;
      SID: string;
  end;

  TDomainList = class(TList)
    private
      function Get(Index: Integer): PDomainRec;
    public
      constructor Create(Session: TLDAPSession);
      property Items[Index: Integer]: PDomainRec read Get;
    end;

const
    eRid              = 100;
    ePrimaryGroupID   = 101;
    ePwdMustChange    = 102;
    ePwdCanChange     = 103;
    ePwdLastSet       = 104;
    eKickoffTime      = 105;
    eLogOnTime        = 106;
    eLogoffTime       = 107;
    eAcctFlags        = 108;
    eNTPassword       = 109;
    eLMPassword       = 110;
    ehomeDrive        = 111;
    esmbHome          = 112;
    escriptPath       = 113;
    eprofilePath      = 114;

const
  PropAttrNames: array[eRid..eProfilePath] of string = (
    'rid',
    'primaryGroupID',
    'pwdMustChange',
    'pwdCanChange',
    'pwdLastSet',
    'kickoffTime',
    'logOnTime',
    'logoffTime',
    'acctFlags',
    'ntPassword',
    'lmPassword',
    'homeDrive',
    'smbHome',
    'scriptPath',
    'profilePath'
);

type
  TSambaAccount = class(TPosixAccount)
  private
    Properties: array[eRid..eProfilePath] of string;
    procedure SetInt(Index: TProperties; Value: Integer);
    function  GetInt(Index: TProperties): Integer;
    procedure SetFlag(Index: Integer; Value: Boolean);
    function  GetFlag(Index: Integer): Boolean;
  protected
    procedure SetUserPassword(const Password: string); override;
  public
    constructor Create(const ASession: TLDAPSession; const adn: string); override;
    constructor Copy(const CEntry: TLdapEntry); override;
    procedure New; override;
    procedure Modify; override;
    procedure Read; override;
    procedure Add; virtual;
    procedure Remove; virtual;
    property Rid: Integer index eRid read GetInt write SetInt;
    property PrimaryGroupID: Integer index ePrimaryGroupID read GetInt write SetInt;
    property PwdLastSet: Integer index ePwdLastSet read GetInt;
    property AcctFlags: string read Properties[eAcctFlags];// write Properties[eAcctFlags];
    property NTPassword: string read Properties[eNTPassword];
    property LMPassword: string read Properties[eLMPassword];
    property HomeDrive: string read Properties[eHomeDrive] write Properties[eHomeDrive];
    property SmbHome: string read Properties[eSmbHome] write Properties[eSmbHome];
    property ScriptPath: string read Properties[eScriptPath] write Properties[eScriptPath];
    property ProfilePath: string read Properties[eProfilePath] write Properties[eProfilePath];
    property UserAccount: Boolean Index Ord('U') read GetFlag write SetFlag;
    property ComputerAccount: Boolean Index Ord('W') read GetFlag write SetFlag;
    property DomainTrust: Boolean Index Ord('I') read GetFlag write SetFlag;
    property ServerTrust: Boolean Index Ord('S') read GetFlag write SetFlag;
    property Disabled: Boolean Index Ord('D') read GetFlag write SetFlag;
    property RequestHomeDir: Boolean Index Ord('H') read GetFlag write SetFlag;
    property NoPasswordExpiration: Boolean Index Ord('X') read GetFlag write SetFlag;
  end;

{ Samba 3 }

const
    eSambaSID                  = 200;
    eSambaPrimaryGroupSID      = 201;
    eSambaPwdMustChange        = 202;
    eSambaPwdCanChange         = 203;
    eSambaPwdLastSet           = 204;
    eSambaKickoffTime          = 205;
    eSambaLogOnTime            = 206;
    eSambaLogoffTime           = 207;
    eSambaAcctFlags            = 208;
    eSambaNTPassword           = 209;
    eSambaLMPassword           = 210;
    eSambaHomeDrive            = 211;
    eSambaHomePath             = 212;
    eSambaLogonScript          = 213;
    eSambaProfilePath          = 214;
    eSambaUserWorkstations     = 215;
    eSambaDomainName           = 216;
    eSambaGroupType            = 217;

const
  Prop3AttrNames: array[eSambaSID..eSambaGroupType] of string = (
    'sambaSID',
    'sambaPrimaryGroupSID',
    'sambaPwdMustChange',
    'sambaPwdCanChange',
    'sambaPwdLastSet',
    'sambaKickoffTime',
    'sambaLogOnTime',
    'sambaLogoffTime',
    'sambaAcctFlags',
    'sambaNTPassword',
    'sambaLMPassword',
    'sambaHomeDrive',
    'sambaHomePath',
    'sambaLogonScript',
    'sambaProfilePath',
    'sambaUserWorkstations',
    'sambaDomainName',
    'sambaGroupType'
    );

type
  TSamba3Account = class(TPosixAccount)
  private
    Properties: array[eSambaSID..eSambaGroupType] of string;
    procedure SetInt(Index: TProperties; Value: Integer);
    function  GetInt(Index: TProperties): Integer;
    procedure SetFlag(Index: Integer; Value: Boolean);
    function  GetFlag(Index: Integer): Boolean;
    function  GetDomainSid: string;
    function  GetRid: string;
    function  GetDomainName: string;
  protected
    procedure SetUserPassword(const Password: string); override;
    procedure SetProperty(Index: TProperties; Value: string; var AProperty: string); override;
  public
    constructor Create(const ASession: TLDAPSession; const adn: string); override;
    constructor Copy(const CEntry: TLdapEntry); override;
    procedure New; override;
    procedure Modify; override;
    procedure Read; override;
    procedure Add; virtual;
    procedure Remove; virtual;
    property Sid: string read Properties[eSambaSID] write Properties[eSambaSID];
    property DomainSID: string read GetDomainSid;
    property Rid: string read GetRid;
    property GroupSID: string read Properties[eSambaPrimaryGroupSID] write Properties[eSambaPrimaryGroupSID];
    property PwdMustChange: Integer index eSambaPwdMustChange read GetInt write SetInt;
    property PwdCanChange: Integer index eSambaPwdCanChange read GetInt write SetInt;
    property PwdLastSet: Integer index eSambaPwdLastSet read GetInt;
    property KickoffTime: Integer index eSambaKickoffTime read GetInt;
    property LogonTime: Integer index eSambaLogonTime read GetInt;
    property LogoffTime: Integer index eSambaLogoffTime read GetInt;
    property AcctFlags: string read Properties[eSambaAcctFlags];// write Properties[eSambaAcctFlags];
    property NTPassword: string read Properties[eSambaNTPassword];
    property LMPassword: string read Properties[eSambaLMPassword];
    property HomeDrive: string read Properties[eSambaHomeDrive] write Properties[eSambaHomeDrive];
    property HomePath: string read Properties[eSambaHomePath] write Properties[eSambaHomePath];
    property LogonScript: string read Properties[eSambaLogonScript] write Properties[eSambaLogonScript];
    property ProfilePath: string read Properties[eSambaProfilePath] write Properties[eSambaProfilePath];
    property UserWorkstations: string read Properties[eSambaUserWorkstations] write Properties[eSambaUserWorkstations];
    //property DomainName: string read Properties[eSambaDomainName] write Properties[eSambaDomainName];
    property DomainName: string read GetDomainName write Properties[eSambaDomainName];
    property GroupType: string read Properties[eSambaGroupType] write Properties[eSambaGroupType];
    property UserAccount: Boolean Index Ord('U') read GetFlag write SetFlag;
    property ComputerAccount: Boolean Index Ord('W') read GetFlag write SetFlag;
    property DomainTrust: Boolean Index Ord('I') read GetFlag write SetFlag;
    property ServerTrust: Boolean Index Ord('S') read GetFlag write SetFlag;
    property Disabled: Boolean Index Ord('D') read GetFlag write SetFlag;
    property RequestHomeDir: Boolean Index Ord('H') read GetFlag write SetFlag;
    property NoPasswordExpiration: Boolean Index Ord('X') read GetFlag write SetFlag;
  end;

type
  TSamba3Group = class(TPosixGroup)
  private
    fGroupType: string;
    fSid: string;
    fDisplayName: string;
    function GetDomainSid: string;
    function GetRid: string;
    procedure SetGroupType(const GroupType: Integer);
    function GetGroupType: Integer;
  protected
    procedure SyncProperties; override;
  public
    constructor Copy(const CEntry: TLdapEntry); override;
    procedure New; override;
    procedure Modify; override;
    procedure Read; override;
    procedure Add; virtual;
    procedure Remove; virtual;
    property GroupType: Integer read GetGroupType write SetGroupType;
    property Sid: string read fSid write fSid;
    property DomainSID: string read GetDomainSid;
    property Rid: string read GetRid;
    property DisplayName: string read fDisplayName write fDisplayName;
  end;

implementation

uses md4, smbdes, Sysutils;

{ This function is ported from mkntpwd.c written by Anton Roeckseisen (anton@genua.de) }

function PutUniCode(var adst; src: PChar): Integer;
var
  i,ret: Integer;
  dst: array[0..255] of Byte absolute adst;
begin
  ret := 0;
  i := 0;
  while PByteArray(src)[i] <> 0 do
  begin
    dst[ret] := PByteArray(src)[i];
    inc(ret);
    dst[ret] := 0;
    inc(ret);
    Inc(i);
  end;
  dst[ret] := 0;
  dst[ret+1] := 0;
  Result := ret; { the way they do the md4 hash they don't represent
                    the last null. ie 'A' becomes just 0x41 0x00 - not
                    0x41 0x00 0x00 0x00 }
end;

function HashToHex(Hash: PByteArray; len: Integer): string;
var
  i: Integer;
begin
  for i := 0 to len - 1 do
    Result := Result + IntToHex(Hash[i], 2);
end;

{ TDomainList}

constructor TDomainList.Create(Session: TLDAPSession);
var
  plmSearch, plmEntry: PLDAPMessage;
  ppcVals: PPChar;
  pld: PLDAP;
  pDom: PDomainRec;
  attrs: PCharArray;
begin

  inherited Create;

  pld := Session.pld;

  // set result fields
  SetLength(attrs, 4);
  attrs[0] := 'sambaDomainName';
  attrs[1] := 'sambaAlgorithmicRIDBase';
  attrs[2] := 'sambaSID';
  attrs[3] := nil;

  LdapCheck(ldap_search_s(pld, PChar(Session.Base), LDAP_SCOPE_SUBTREE,
                               '(objectclass=sambadomain)', PChar(attrs), 0, plmSearch));
  try
    plmEntry := ldap_first_entry(pld, plmSearch);
    while Assigned(plmEntry) do
    begin
      New(pDom);
      Add(pDom);
      with pDom^ do
      begin

        ppcVals := ldap_get_values(pld, plmEntry, attrs[0]);
        if not Assigned(ppcVals) then
          fail;
          //raise Exception.Create( TODO
        pDom^.DomainName := PCharArray(ppcVals)[0];

        ppcVals := ldap_get_values(pld, plmEntry, attrs[1]);
        if not Assigned(ppcVals) then
          fail;
          //raise Exception.Create( TODO
        AlgorithmicRIDBase := StrToInt(PCharArray(ppcVals)[0]);

        ppcVals := ldap_get_values(pld, plmEntry, attrs[2]);
        if not Assigned(ppcVals) then
          fail;
          //raise Exception.Create( TODO
        SID := PCharArray(ppcVals)[0];
      end;

      plmEntry := ldap_next_entry(pld, plmEntry);

    end;
  finally
    // free search results
    LDAPCheck(ldap_msgfree(plmSearch));
  end;

end;

function TDomainList.Get(Index: Integer): PDomainRec;
begin
  Result := inherited Items[Index];
end;

{ TSambaAccount }

procedure TSambaAccount.SetInt(Index: TProperties; Value: Integer);
begin
  SetProperty(Index, IntToStr(Value), Properties[Index]);
end;

function TSambaAccount.GetInt(Index: TProperties): Integer;
begin
  Result := StrToInt(Properties[Index]);
end;

function TSambaAccount.GetFlag(Index: Integer): Boolean;
begin
  Result := Pos(Char(Index), Properties[eAcctFlags]) <> 0;
end;

procedure TSambaAccount.SetFlag(Index: Integer; Value: Boolean);
var
  i: Integer;
begin
  i := Pos(Char(Index), Properties[eAcctFlags]);
  if Value then // set
  begin
    if i = 0 then
      Insert(Char(Index), Properties[eAcctFlags], 2);
  end
  else begin    // unset
    if i <> 0 then
      System.Delete(Properties[eAcctFlags], i, 1);
  end;
end;

procedure TSambaAccount.SetUserPassword(const Password: string);
var
  Passwd: array[0..255] of Byte;
  Hash: array[0..16] of Byte;
  slen: Integer;
begin
  inherited;
  { Get NT Password }
  fillchar(passwd, 255, 0);
  slen := PutUniCode(Passwd, PChar(Password));
  fillchar(hash, 17, 0);
  mdfour(hash, Passwd, slen);
  Properties[eNTPassword] := HashToHex(@Hash, 16);
  { Get Lanman Password }
   Properties[eLMPassword] := HashToHex(PByteArray(e_p16(UpperCase(Password))), 16);
end;

constructor TSambaAccount.Create(const ASession: TLDAPSession; const adn: string);
begin
  inherited;
  Properties[eAcctFlags] := '[]';
end;

constructor TSambaAccount.Copy(const CEntry: TLdapEntry);
var
  i: TProperties;
begin
  inherited;
  if CEntry is TSambaAccount then
  begin
    for i := Low(Properties) to High(Properties) do
      Properties[i] := (CEntry as TSambaAccount).Properties[i];
  end
  else
    SyncProperties(Properties, PropAttrNames)
end;

procedure TSambaAccount.New;
var
  i: TProperties;
begin
  Add;
  for i := eRid to eProfilePath do
    if Properties[i] <> '' then
      AddAttr(PropAttrNames[i], Properties[i], LDAP_MOD_ADD);
  inherited;
end;

procedure TSambaAccount.Modify;
begin
  FlushProperties(Properties, PropAttrNames);
  inherited;
end;

procedure TSambaAccount.Read;
begin
  inherited;
  SyncProperties(Properties, PropAttrNames);
end;

procedure TSambaAccount.Add;
begin
  AddAttr('objectclass', 'sambaAccount', LDAP_MOD_ADD);
end;

procedure TSambaAccount.Remove;
var
  i: TProperties;
begin
  AddAttr('objectclass', 'sambaAccount', LDAP_MOD_DELETE);
  for i := eRid to eProfilePath do
    Properties[i] := '';
end;

{ TSamba3Account }

procedure TSamba3Account.SetInt(Index: TProperties; Value: Integer);
begin
  SetProperty(Index, IntToStr(Value), Properties[Index]);
end;

function TSamba3Account.GetInt(Index: TProperties): Integer;
begin
  Result := StrToInt(Properties[Index]);
end;

function TSamba3Account.GetFlag(Index: Integer): Boolean;
begin
  Result := Pos(Char(Index), Properties[eSambaAcctFlags]) <> 0;
end;

procedure TSamba3Account.SetFlag(Index: Integer; Value: Boolean);
var
  i: Integer;
begin
  i := Pos(Char(Index), Properties[eSambaAcctFlags]);
  if Value then // set
  begin
    if i = 0 then
      Insert(Char(Index), Properties[eSambaAcctFlags], 2);
  end
  else begin    // unset
    if i <> 0 then
      System.Delete(Properties[eSambaAcctFlags], i, 1);
  end;
end;

function TSamba3Account.GetDomainSid: string;
var
  p: Integer;
begin
  p := LastDelimiter('-', Sid);
  Result := System.Copy(Sid, 1, p - 1);
end;

function TSamba3Account.GetRid: string;
var
  p: Integer;
begin
  p := LastDelimiter('-', Sid);
  Result := PChar(@Sid[p + 1]);
end;

function TSamba3Account.GetDomainName: string;
var
  i: Integer;
begin
  if Properties[eSambaDomainName] <> '' then
    Result := Properties[eSambaDomainName]
  else // try to get domain name from sid
  begin
    with TDomainList.Create(Session) do
    try
      for i := 0 to Count - 1 do
        if Items[i].SID = DomainSID then
          Result := Items[i].DomainName;
    finally
      Free;
    end;
  end;
end;

procedure TSamba3Account.SetUserPassword(const Password: string);
var
  Passwd: array[0..255] of Byte;
  Hash: array[0..16] of Byte;
  slen: Integer;
begin
  inherited;
  { Get NT Password }
  fillchar(passwd, 255, 0);
  slen := PutUniCode(Passwd, PChar(Password));
  fillchar(hash, 17, 0);
  mdfour(hash, Passwd, slen);
  Properties[eSambaNTPassword] := HashToHex(@Hash, 16);
  { Get Lanman Password }
  Properties[eSambaLMPassword] := HashToHex(PByteArray(e_p16(UpperCase(Password))), 16);
  { Set changetime attribute }
  //TODO: this should probably be UTC?
  Properties[eSambaPwdLastSet] := IntToStr(Trunc((Now - 25569.0)*24*60*60));
end;

procedure TSamba3Account.SetProperty(Index: TProperties; Value: string; var AProperty: string);
begin
  inherited;
  if Index = eShadowExpire then
  begin
    if StrToInt(Value) = SHADOW_MAX_DATE then
      Properties[eSambaKickoffTime] := ''
    else
      Properties[eSambaKickoffTime] := IntToStr(StrToInt(Value)*24*60*60);
  end;
end;

constructor TSamba3Account.Create(const ASession: TLDAPSession; const adn: string);
begin
  inherited;
  Properties[eSambaAcctFlags] := '[]';
end;

constructor TSamba3Account.Copy(const CEntry: TLdapEntry);
var
  i: TProperties;
begin
  inherited;
  if CEntry is TSamba3Account then
  begin
    for i := Low(Properties) to High(Properties) do
      Properties[i] := (CEntry as TSamba3Account).Properties[i];
  end
  else
    SyncProperties(Properties, Prop3AttrNames)
end;

procedure TSamba3Account.New;
var
  i: TProperties;
begin
  Add;
  for i := Low(Properties) to High(Properties) do
    if Properties[i] <> '' then
      AddAttr(Prop3AttrNames[i], Properties[i], LDAP_MOD_ADD);
  inherited;
end;

procedure TSamba3Account.Modify;
begin
  FlushProperties(Properties, Prop3AttrNames);
  inherited;
end;

procedure TSamba3Account.Read;
begin
  inherited;
  SyncProperties(Properties, Prop3AttrNames);
end;

procedure TSamba3Account.Add;
begin
  AddAttr('objectclass', 'sambaSamAccount', LDAP_MOD_ADD);
end;

procedure TSamba3Account.Remove;
var
  i: TProperties;
begin
  AddAttr('objectclass', 'sambaSamAccount', LDAP_MOD_DELETE);
  for i := Low(Properties) to High(Properties) do
    Properties[i] := '';
end;

{ TSamba3Group }

function TSamba3Group.GetDomainSid: string;
var
  p: Integer;
begin
  p := LastDelimiter('-', Sid);
  Result := System.Copy(fSid, 1, p - 1);
end;

function TSamba3Group.GetRid: string;
var
  p: Integer;
begin
  p := LastDelimiter('-', Sid);
  Result := PChar(@Sid[p + 1]);
end;

procedure TSamba3Group.SetGroupType(const GroupType: Integer);
begin
  fGroupType := IntToStr(GroupType);
end;

function TSamba3Group.GetGroupType: Integer;
begin
  Result := StrToInt(fGroupType);
end;

procedure TSamba3Group.SyncProperties;
var
  i: Integer;
  attrname: string;
begin
  //inherited; 
  if Assigned(Items) then
  begin
    for i := 0 to Items.Count - 1 do
    begin
      attrname := lowercase(Items[i]);
      if attrname = 'sambagrouptype' then
        fGroupType := PChar(Items.Objects[i])
      else
      if attrname = 'sambasid' then
        fSid := PChar(Items.Objects[i])
      else
      if attrname = 'displayname' then
        fDisplayName := PChar(Items.Objects[i]);
    end;
  end;
end;

constructor TSamba3Group.Copy(const CEntry: TLdapEntry);
begin
  inherited;
  if CEntry is TSamba3Group then
  begin
    fGroupType := TSamba3Group(CEntry).fGroupType;
    fSid := TSamba3Group(CEntry).fSid;
  end
  else
    SyncProperties;
end;

procedure TSamba3Group.New;
begin
  Add;
  FlushProperty('sambaGroupType', fGroupType);
  FlushProperty('sambaSID', fSid);
  FlushProperty('displayName', fDisplayName);
  inherited;
end;

procedure TSamba3Group.Modify;
begin
  FlushProperty('sambaGroupType', fGroupType);
  FlushProperty('sambaSID', fSid);
  FlushProperty('displayName', fDisplayName);
  inherited;
end;

procedure TSamba3Group.Read;
begin
  inherited;
  SyncProperties;
end;

procedure TSamba3Group.Add;
begin
  AddAttr('objectclass', 'sambaGroupMapping', LDAP_MOD_ADD);
end;

procedure TSamba3Group.Remove;
begin
  AddAttr('objectclass', 'sambaGroupMapping', LDAP_MOD_DELETE);
  fGroupType := '';
  fSid := '';
  fDisplayName := '';
end;

end.
