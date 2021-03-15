  {      LDAPAdmin - Samba.pas
  *      Copyright (C) 2003-2005 Tihomir Karlovic
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

uses Classes, PropertyObject, Posix, LDAPClasses, WinLDAP, Constant;

const
  WKRids: array[0..4] of Integer  = (
                                          500,    // Administrator
                                          501,    // Guest
                                          512,    // Domain Admins
                                          513,    // Domain Users
                                          514     // Domain Guests
                                     );

  { TDateTime value equivalent to Unix timestamp of 2147483647 }
  SAMBA_MAX_KICKOFF_TIME          = 50424.134803;

{ TDomainList }

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


{ TSambaAccount }

const
    eSambaSID                  = 00;
    eSambaPrimaryGroupSID      = 01;
    eSambaPwdMustChange        = 02;
    eSambaPwdCanChange         = 03;
    eSambaPwdLastSet           = 04;
    eSambaKickoffTime          = 05;
    eSambaLogOnTime            = 06;
    eSambaLogoffTime           = 07;
    eSambaAcctFlags            = 08;
    eSambaNTPassword           = 09;
    eSambaLMPassword           = 10;
    eSambaHomeDrive            = 11;
    eSambaHomePath             = 12;
    eSambaLogonScript          = 13;
    eSambaProfilePath          = 14;
    eSambaUserWorkstations     = 15;
    eSambaDomainName           = 16;
    eSambaPasswordHistory      = 17;
    esambaMungedDial           = 18;
    esambaBadPasswordCount     = 19;
    esambaBadPasswordTime      = 20;
    sambaLogonHours            = 21;
    eSambaGroupType            = 22;
    eInetOrgDisplayName        = 23;

const
  Prop3AttrNames: array[eSambaSid..eInetOrgDisplayName] of string = (
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
    'sambaPasswordHistory',
    'sambaMungedDial',
    'sambaBadPasswordCount',
    'sambaBadPasswordTime',
    'sambaLogonHours',
    'sambaGroupType',
    'displayName'
    );

type
  TSamba3Account = class(TPropertyObject)
  private
    pDomainData: PDomainRec;
    fPosixAccount: TPosixAccount;
    procedure SetSid(Value: Integer);
    procedure SetUidNumber(Value: Integer);
    function  GetUidNumber: Integer;
    procedure SetGidNumber(Value: Integer);
    function  GetGidNumber: Integer;
    procedure SetDomainRec(pdr: PDomainRec);
    procedure SetFlag(Index: Integer; Value: Boolean);
    function  GetFlag(Index: Integer): Boolean;
    function  GetDomainSid: string;
    function  GetRid: string;
    function  GetDomainName: string;
  public
    constructor Create(const Entry: TLdapEntry); override;
    procedure New; override;
    procedure Remove; override;
    procedure SetUserPassword(const Password: string); virtual;
    property DomainData: PDomainRec write SetDomainRec;
    property UidNumber: Integer read GetUidNumber write SetUidNumber;
    property GidNumber: Integer read GetGidNumber write SetGidNumber;
    property Sid: string index eSambaSID read GetString;// write SetString;
    property DomainSID: string read GetDomainSid;
    property Rid: string read GetRid;
    property GroupSID: string index eSambaPrimaryGroupSID read GetString write SetString;
    property PwdMustChange: Integer index eSambaPwdMustChange read GetInt write SetInt;
    property PwdCanChange: Integer index eSambaPwdCanChange read GetInt write SetInt;
    property PwdLastSet: TDateTime index eSambaPwdLastSet read GetFromUnixTime;
    property KickoffTime: TDateTime index eSambaKickoffTime read GetFromUnixTime write SetAsUnixTime;
    property LogonTime: Integer index eSambaLogonTime read GetInt;
    property LogoffTime: Integer index eSambaLogoffTime read GetInt;
    property AcctFlags: string index eSambaAcctFlags read GetString;// write Properties[eSambaAcctFlags];
    property NTPassword: string index eSambaNTPassword read GetString;
    property LMPassword: string index eSambaLMPassword read GetString;
    property HomeDrive: string index eSambaHomeDrive read GetString write SetString;
    property HomePath: string index eSambaHomePath read GetString write SetString;
    property LogonScript: string index eSambaLogonScript read GetString write SetString;
    property ProfilePath: string index eSambaProfilePath read GetString write SetString;
    property UserWorkstations: string index eSambaUserWorkstations read GetString write SetString;
    property DomainName: string read GetDomainName;
    property GroupType: string index eSambaGroupType read GetString write SetString;
    property UserAccount: Boolean Index Ord('U') read GetFlag write SetFlag;
    property ComputerAccount: Boolean Index Ord('W') read GetFlag write SetFlag;
    property DomainTrust: Boolean Index Ord('I') read GetFlag write SetFlag;
    property ServerTrust: Boolean Index Ord('S') read GetFlag write SetFlag;
    property Disabled: Boolean Index Ord('D') read GetFlag write SetFlag;
    property RequestHomeDir: Boolean Index Ord('H') read GetFlag write SetFlag;
    property NoPasswordExpiration: Boolean Index Ord('X') read GetFlag write SetFlag;
  end;

  TSamba3Computer = class(TSamba3Account)
  private
    function  GetUid: string;
    procedure SetUid(Value: string);
    function  GetDescription: string;
    procedure SetDescription(Value: string);
  public
    procedure New; override;
    property ComputerName: string read GetUid write SetUid;
    property Description: string read GetDescription write SetDescription;
  end;

  TSamba3Group = class(TPropertyObject)
  private
    function GetDomainSid: string;
    function GetRid: string;
  public
    constructor Create(const Entry: TLdapEntry); override;
    procedure New; override;
    procedure Remove; override;
    property GroupType: Integer index eSambaGroupType read GetInt write SetInt;
    property Sid: string index eSambaSID read GetString write SetString;
    property DomainSID: string read GetDomainSid;
    property Rid: string read GetRid;
    property DisplayName: string index eInetOrgDisplayName read GetString write SetString;
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
  pDom: PDomainRec;
  attrs: PCharArray;
  EntryList: TLdapEntryList;
  i: Integer;
begin
  inherited Create;
  // set result fields
  SetLength(attrs, 4);
  attrs[0] := 'sambaDomainName';
  attrs[1] := 'sambaAlgorithmicRIDBase';
  attrs[2] := 'sambaSID';
  attrs[3] := nil;
  EntryList := TLdapEntryList.Create;
  try
    Session.Search('(objectclass=sambadomain)', Session.Base, LDAP_SCOPE_SUBTREE,
                   attrs, false, EntryList);
    for i := 0 to EntryList.Count - 1 do with EntryList[i] do
    begin
      New(pDom);
      Add(pDom);
      with pDom^ do
      begin
        DomainName := AttributesByName[attrs[0]].AsString;
        AlgorithmicRidBase := StrToInt(AttributesByName[attrs[1]].AsString);
        SID := AttributesByName[attrs[2]].AsString;
      end;
    end;
  finally
    EntryList.Free;
  end;
end;
function TDomainList.Get(Index: Integer): PDomainRec;
begin
  Result := inherited Items[Index];
end;

{ TSambaAccount }

procedure TSamba3Account.SetSid(Value: Integer);
begin
  if not Assigned(pDomaindata) then
    SetString(eSambaSID, '')
  else
  if IsNull(eSambaSid) then
    SetString(eSambaSID, Format('%s-%d', [pDomainData^.SID, pDomainData^.AlgorithmicRIDBase + 2 * Value]))
end;

procedure TSamba3Account.SetDomainRec(pdr: PDomainRec);
begin
  pDomainData := pdr;
  if Assigned(pDomaindata) then
  begin
    SetString(eSambaDomainName, pDomainData^.DomainName);
    if not fPosixAccount.IsNull(eUidNumber) then
      SetSid(UidNumber);
    if IsNull(eSambaPrimaryGroupSID) and not fPosixAccount.IsNull(eGidNumber) then
      //SetString(eSambaPrimaryGroupSID, Format('%s-%d', [pDomainData^.SID, 2 * GidNumber + 1001]));
      SetGidNumber(fPosixAccount.GidNumber)
  end;
end;

procedure TSamba3Account.SetUidNumber(Value: Integer);
begin
  fPosixAccount.UidNumber := Value;
  SetSid(Value);
end;

function TSamba3Account.GetUidNumber: Integer;
begin
  Result := fPosixAccount.UidNumber;
end;

procedure TSamba3Account.SetGidNumber(Value: Integer);
var
  gsid: string;
begin
  if Assigned(pDomainData) then
  begin
    gsid := fEntry.Session.Lookup(fEntry.Session.Base, Format(sGROUPBYGID, [Value]), 'sambasid', LDAP_SCOPE_SUBTREE);
    if gsid <> '' then
      SetString(eSambaPrimaryGroupSID, gsid)
    else
      SetString(eSambaPrimaryGroupSID, Format('%s-%d', [pDomainData^.SID, 2 * Value + 1001]))
  end
  else
    SetString(eSambaPrimaryGroupSID, '');
  fPosixAccount.GidNumber := Value;
end;

function TSamba3Account.GetGidNumber: Integer;
begin
  Result := fPosixAccount.GidNumber;
end;

function TSamba3Account.GetFlag(Index: Integer): Boolean;
begin
  Result := Pos(Char(Index), GetString(eSambaAcctFlags)) <> 0;
end;

procedure TSamba3Account.SetFlag(Index: Integer; Value: Boolean);
var
  i: Integer;
  s: string;
begin
  s := GetString(eSambaAcctFlags);
  i := Pos(Char(Index), s);
  if Value then // set
  begin
    if i = 0 then
      Insert(Char(Index), s, 2);
  end
  else begin    // unset
    if i <> 0 then
      System.Delete(s, i, 1);
  end;
  SetString(eSambaAcctFlags, s);
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
  // TODO use pDomainData
  //if not IsNull(eSambaDomainName) then
  Result := GetString(eSambaDomainName);
  if Result = '' then // try to get domain name from sid
  begin
    with TDomainList.Create(fEntry.Session) do
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
  SetString(eSambaNTPassword, HashToHex(@Hash, 16));
  { Get Lanman Password }
  SetString(eSambaLMPassword, HashToHex(PByteArray(e_p16(UpperCase(Password))), 16));
  { Set changetime attribute }
  SetAsUnixTime(eSambaPwdLastSet, Now);
end;

constructor TSamba3Account.Create(const Entry: TLdapEntry);
begin
  inherited Create(Entry, 'sambaSamAccount', @Prop3AttrNames);
  fPosixAccount := TPosixAccount.Create(Entry);
end;

procedure TSamba3Account.New;
begin
  AddObjectClass(['sambaSamAccount']);
  SetString(eSambaAcctFlags, '[]');
  SetSid(UidNumber);
end;

procedure TSamba3Account.Remove;
var
  i: Integer;
begin
  RemoveObjectClass(['sambaSamAccount']);
  for i := eSambaSid to eSambaGroupType do
    SetString(i, '');
end;

{ TSamba3Computer }

function TSamba3Computer.GetUid: string;
begin
  Result := fPosixAccount.uid;
end;

procedure TSamba3Computer.SetUid(Value: string);
begin
  Value := UpperCase(Value);
  if Value[Length(Value)] <> '$' then
    Value := Value + '$';
  fPosixAccount.Uid := Value;
  fPosixAccount.Cn := Value;
end;

function TSamba3Computer.GetDescription: string;
begin
  Result := fPosixAccount.Description;
end;

procedure TSamba3Computer.SetDescription(Value: string);
begin
  fPosixAccount.Description := Value;
end;

procedure TSamba3Computer.New;
begin
  inherited;
  AddObjectClass(['top', 'account', 'posixAccount', 'shadowAccount']);
  fPosixAccount.LoginShell := '/bin/false';
  fPosixAccount.HomeDirectory := '/dev/null';
  GidNumber := COMPUTER_GROUP;
  ComputerAccount := true;
end;

{ TSamba3Group }

function TSamba3Group.GetDomainSid: string;
var
  p: Integer;
begin
  p := LastDelimiter('-', Sid);
  Result := System.Copy(Sid, 1, p - 1);
end;

function TSamba3Group.GetRid: string;
var
  p: Integer;
begin
  p := LastDelimiter('-', Sid);
  Result := PChar(@Sid[p + 1]);
end;

constructor TSamba3Group.Create(const Entry: TLdapEntry);
begin
  inherited Create(Entry, 'sambaGroupMapping', @Prop3AttrNames);
end;

procedure TSamba3Group.New;
begin
  inherited;
  GroupType := 2;
end;

procedure TSamba3Group.Remove;
begin
  inherited;
  SetString(eSambaGroupType, '');
  Sid := '';
  DisplayName := '';
end;

end.
