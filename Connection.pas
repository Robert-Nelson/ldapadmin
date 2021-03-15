  {      LDAPAdmin - Connection.pas
  *      Copyright (C) 2012 Tihomir Karlovic
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

unit Connection;

interface

uses Config, Sorter, Schema, LdapClasses, Controls;

type

  TDirectoryType = (dtAutodetect, dtPosix, dtActiveDirectory);

  TConnection = class;

  IDirectoryIdentity = Interface
    procedure ClassifyLdapEntry(Entry: TLdapEntry; out Container: Boolean; out ImageIndex: Integer);
    function  SupportedPropertyObjects(const Index: Integer): Boolean;
    function  NewProperty(Owner: TControl; Connection: TConnection; const Index: Integer; const dn: string): Boolean;
    function  EditProperty(Owner: TControl; Connection: TConnection; const Index: Integer; const dn: string): Boolean;
    function  ChangePassword(Entry: TLdapEntry): Boolean;
    //function  IsContainer(Entry: TLdapEntry; Index: Integer): Boolean;
  end;

  TConnection = class(TLdapSession)
  private
    FAccount: TAccount;
    FLVSorter: TListViewSorter;
    FSchema: TLdapSchema;
    FSelected: string;
    FDirectoryIdentity: IDirectoryIdentity;
    function GetDirectoryType: TDirectoryType;
    function GetDirectoryIdentity: IDirectoryIdentity;
    function GetSchema: TLdapSchema;
    function GetFreeRandomNumber(const Min, Max: Integer; const Objectclass, id: string): Integer;
    function GetSequentialNumber(const Min, Max: Integer; const Objectclass, id: string): Integer;
  public
    constructor Create(Account: TAccount);
    destructor Destroy; override;
    function GetFreeUidNumber(const MinUid, MaxUID: Integer; const Sequential: Boolean): Integer;
    function GetFreeGidNumber(const MinGid, MaxGid: Integer; const Sequential: Boolean): Integer;
    function GetUid: Integer;
    function GetGid: Integer;
    property Account: TAccount read FAccount;
    property LVSorter: TListViewSorter read FLVSorter write FLVSorter;
    property Schema: TLdapSchema read GetSchema;
    property Selected: string read FSelected write FSelected;
    property DirectoryType: TDirectoryType read GetDirectoryType;
    property DI: IDirectoryIdentity read GetDirectoryIdentity;
  end;

procedure InitTemplateIcons(ImageList: TImageList);

var
  UseTemplateImages: Boolean;

implementation

uses SysUtils, WinLdap, Constant, User, Host, Locality, Computer, Group,
     MailGroup, Transport, Ou, Classes, Templates, PassDlg, ADPassDlg;

var
  TemplateIcons: TList;
  IconIndexBase: Integer;

procedure InitTemplateIcons(ImageList: TImageList);
var
  i: Integer;
begin
  if Assigned(TemplateIcons) then exit;
  IconIndexBase := ImageList.Count;
  TemplateIcons := TList.Create;
  for i := 0 to TemplateParser.Count - 1 do
    if Assigned(TemplateParser.Templates[i].Icon) then
    begin
      TemplateIcons.Add(TemplateParser.Templates[i]);
      ImageList.AddMasked(TemplateParser.Templates[i].Icon, TemplateParser.Templates[i].Icon.TransparentColor);
    end;
end;

function GetTemplateIconIndex(ObjectClass: TLdapAttribute): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to TemplateIcons.Count - 1 do
    if TTemplate(TemplateIcons[i]).Matches(ObjectClass) then
    begin
      Result := i;
      break;
    end;
end;

{ IDirectoryIdentity }

type
  TPosixDirectoryIdentity = class(TInterfacedObject, IDirectoryIdentity)
  public
    procedure ClassifyLdapEntry(Entry: TLdapEntry; out Container: Boolean; out ImageIndex: Integer);
    function  SupportedPropertyObjects(const Index: Integer): Boolean;
    function  NewProperty(Owner: TControl; Connection: TConnection; const Index: Integer; const dn: string): Boolean;
    function  EditProperty(Owner: TControl; Connection: TConnection; const Index: Integer; const dn: string): Boolean;
    function  ChangePassword(Entry: TLdapEntry): Boolean;
    //function  IsContainer(Entry: TLdapEntry; Index: Integer): Boolean;
  end;

  TADDirectoryIdentity = class(TInterfacedObject, IDirectoryIdentity)
  public
    procedure ClassifyLdapEntry(Entry: TLdapEntry; out Container: Boolean; out ImageIndex: Integer);
    function  SupportedPropertyObjects(const Index: Integer): Boolean;
    function  NewProperty(Owner: TControl; Connection: TConnection; const Index: Integer; const dn: string): Boolean;
    function  EditProperty(Owner: TControl; Connection: TConnection; const Index: Integer; const dn: string): Boolean;
    function  ChangePassword(Entry: TLdapEntry): Boolean;
    //function  IsContainer(Entry: TLdapEntry; Index: Integer): Boolean;
  end;

function TConnection.GetDirectoryType: TDirectoryType;
begin
  Result := TDirectoryType(Account.ReadInteger(rDirectoryType, Integer(dtAutodetect)));
  if (Result = dtAutodetect) and Connected then
  begin
    if Lookup('', sAnyClass,'defaultNamingContext', LDAP_SCOPE_BASE) <> '' then
      Result := dtActiveDirectory;
    Account.WriteInteger(rDirectoryType, Integer(Result));
  end;
end;

function TConnection.GetSchema: TLdapSchema;
begin
  if not Assigned(FSchema) then
    FSchema := TLdapSchema.Create(Self);
  Result := FSchema;
end;

function TConnection.GetDirectoryIdentity: IDirectoryIdentity;
begin
  if not Assigned(FDirectoryIdentity) then
  begin
    case DirectoryType of
      dtActiveDirectory: fDirectoryIdentity := TADDirectoryIdentity.Create;
    else
      fDirectoryIdentity := TPosixDirectoryIdentity.Create;
    end;
  end;
  Result := FDirectoryIdentity;
end;

constructor TConnection.Create(Account: TAccount);
begin
  inherited Create;
  FAccount := Account;
  FLVSorter := TListViewSorter.Create;
end;

destructor TConnection.Destroy;
begin
  FSchema.Free;
  FLVSorter.Free;
  inherited;
end;

{ Get random free uidNumber from the pool of available numbers, return -1 if
  no more free numbers are available }
function TConnection.GetFreeRandomNumber(const Min, Max: Integer; const Objectclass, id: string): Integer;
var
  i: Integer;
  uidpool: array of Word;
  r, N: Word;
begin
  N := Max - Min + 1;
  SetLength(uidpool, N);
  { Initialize the array }
  for i := 0 to N - 1 do
    uidpool[i] := i;
  Randomize;
  while N > 0 do
  begin
    r := Random(N);
    Result := Min + uidpool[r];
    if Lookup(Base, Format('(&(objectclass=%s)(%s=%d))', [Objectclass, id, Result]), 'objectclass', LDAP_SCOPE_SUBTREE) = '' then
      exit;
    uidpool[r] := uidpool[N - 1];
    dec(N);
  end;
  Result := -1;
end;

{ Get sequential free uidNumber from the pool of available numbers, return -1 if
  no more free numbers are available }
function TConnection.GetSequentialNumber(const Min, Max: Integer; const Objectclass, id: string): Integer;
var
  attrs: PCharArray;
  i, n: Integer;
  SearchList: TLdapEntryList;
begin
  Result := Min;
  SetLength(attrs, 2);
  attrs[0] := PChar(id);
  attrs[1] := nil;

  SearchList := TLdapEntryList.Create;
  try
    Search(Format('(objectclass=%s)', [Objectclass]), Base, LDAP_SCOPE_ONELEVEL, attrs, false, SearchList);
    for i := 0 to SearchList.Count - 1 do
    begin
      n := StrToInt(SearchList[i].Attributes[0].AsString);
      if (n <= Max) and (n >= Result) then
      begin
        Result :=  n + 1;
        if Result > Max then
        begin
          Result := -1;
          break;
        end;
      end;
    end;
  finally
    SearchList.Free;
  end;
end;

function TConnection.GetFreeUidNumber(const MinUid, MaxUID: Integer; const Sequential: Boolean): Integer;
begin
  if Sequential then
    Result := GetSequentialNumber(MinUid, MaxUid, 'posixAccount', 'uidNumber')
  else
    Result := GetFreeRandomNumber(MinUid, MaxUid, 'posixAccount', 'uidNumber');
  if Result = -1 then
    raise Exception.Create(Format(stNoMoreNums, ['uidNumber']));
end;

function TConnection.GetFreeGidNumber(const MinGid, MaxGid: Integer; const Sequential: Boolean): Integer;
begin
  if Sequential then
    Result := GetSequentialNumber(MinGid, MaxGid, 'posixGroup', 'gidNumber')
  else
    Result := GetFreeRandomNumber(MinGid, MaxGid, 'posixGroup', 'gidNumber');
  if Result = -1 then
    raise Exception.Create(Format(stNoMoreNums, ['gidNumber']));
end;

function TConnection.GetUid: Integer;
var
  IdType: Integer;
begin
  Result := -1;
  idType := Account.ReadInteger(rPosixIDType, POSIX_ID_RANDOM);
  if idType <> POSIX_ID_NONE then
    Result := GetFreeUidNumber(Account.ReadInteger(rposixFirstUID, FIRST_UID),
                               Account.ReadInteger(rposixLastUID, LAST_UID),
                               IdType = POSIX_ID_SEQUENTIAL);
end;

function TConnection.GetGid: Integer;
var
  IdType: Integer;
begin
  Result := -1;
  idType := Account.ReadInteger(rPosixIDType, POSIX_ID_RANDOM);
  if idType <> POSIX_ID_NONE then
    Result := GetFreeGidNumber(Account.ReadInteger(rposixFirstGid, FIRST_GID),
                               Account.ReadInteger(rposixLastGID, LAST_GID),
                               IdType = POSIX_ID_SEQUENTIAL);
end;

{ TPosixDirectoryIDentity }

procedure TPosixDirectoryIdentity.ClassifyLdapEntry(Entry: TLdapEntry; out Container: Boolean; out ImageIndex: Integer);
var
  Attr: TLdapAttribute;
  i: integer;
  s: string;

  function IsComputer(const s: string): Boolean;
  var
    i: Integer;
  begin
    i := Pos(',', s);
    Result := (i > 1) and (s[i - 1] = '$');
  end;

begin
  Container := true;
  ImageIndex := bmEntry;
  Attr := Entry.AttributesByName['objectclass'];
  i := Attr.ValueCount - 1;
  while i >= 0 do
  begin
    s := lowercase(Attr.Values[i].AsString);
    if s = 'organizationalunit' then
      ImageIndex := bmOu
    else if s = 'posixaccount' then
    begin
      if ImageIndex = bmEntry then // if not yet assigned to Samba account
      begin
        ImageIndex := bmPosixUser;
        Container := false;
      end;
    end
    else if s = 'sambasamaccount' then
    begin
      if IsComputer(Entry.dn) then             // it's samba computer account
        ImageIndex := bmComputer               // else
      else                                     // it's samba user account
        ImageIndex := bmSamba3User;
      Container := false;
    end
    else if s = 'sambagroupmapping' then
    begin
      ImageIndex := bmSambaGroup;
      Container := false;
    end
    else if s = 'mailgroup' then
    begin
      ImageIndex := bmMailGroup;
      Container := false;
    end
    else if s = 'posixgroup' then
    begin
      if ImageIndex = bmEntry then // if not yet assigned to Samba group
      begin
        ImageIndex := bmGroup;
        Container := false;
      end;
    end
    else if s = 'groupofuniquenames' then
    begin
      ImageIndex := bmGrOfUnqNames;
      Container := false;
    end
    else if s = 'transporttable' then
    begin
      ImageIndex := bmTransport;
      Container := false;
    end
    else if s = 'sudorole' then
    begin
      ImageIndex := bmSudoer;
      Container := false;
    end
    else if s = 'iphost' then
    begin
      ImageIndex := bmHost;
      Container := false;
    end
    else if s = 'locality' then
      ImageIndex := bmLocality
    else if s = 'sambadomain' then
    begin
      ImageIndex := bmSambaDomain;
      Container := false;
    end
    else if s = 'sambaunixidpool' then
    begin
      ImageIndex := bmIdPool;
      //Container := false;
    end;
    Dec(i);
  end;
  if (UseTemplateImages) and (ImageIndex = bmEntry) then
  begin
    i := GetTemplateIconIndex(Attr);
    if i <> -1 then
      ImageIndex := i + IconIndexBase;
  end;
end;

function TPosixDirectoryIdentity.SupportedPropertyObjects(const Index: Integer): Boolean;
begin
  case Index of
    bmSamba2User,
    bmSamba3User,
    bmPosixUser,
    bmGroup,
    bmSambaGroup,
    bmGrOfUnqNames,
    bmMailGroup,
    bmComputer,
    bmTransport,
    bmOu,
    bmLocality,
    bmHost: Result := true;
  else
    Result := false;
  end;
end;

function  TPosixDirectoryIdentity.NewProperty(Owner: TControl; Connection: TConnection; const Index: Integer; const dn: string): Boolean;
begin
  Result := true;
  case Index of
    2: TUserDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    3: TComputerDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    4: TGroupDlg.Create(Owner, dn, Connection, EM_ADD, true, Connection.Account.ReadInteger(rPosixGroupOfUnames, 0)).ShowModal;
    5: TMailGroupDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    6: TTransportDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    7: TOuDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    8: THostDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    9: TLocalityDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
   10: TGroupDlg.Create(Owner, dn, Connection, EM_ADD, false, 1).ShowModal;
  else
    Result := false;
  end;
end;

function TPosixDirectoryIdentity.EditProperty(Owner: TControl; Connection: TConnection; const Index: Integer; const dn: string): Boolean;
begin
  Result := true;
    case Index of
      bmSamba2User,
      bmSamba3User,
      bmPosixUser:    TUserDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
      bmGroup,
      bmSambaGroup,
      bmGrOfUnqNames: TGroupDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
      bmMailGroup:    TMailGroupDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
      bmComputer:     TComputerDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
      bmTransport:    TTransportDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
      bmOu:           TOuDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
      bmLocality:     TLocalityDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
      bmHost:         THostDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
    else
      Result := false;
    end;
end;

function TPosixDirectoryIdentity.ChangePassword(Entry: TLdapEntry): Boolean;
begin
  with TPasswordDlg.Create(nil, Entry) do
  try
    if ShowModal = mrOk then
    begin
      Entry.Write;
      Result := true;
    end
    else
      Result := false;
  finally
    Free;
  end;
end;

{function TPosixDirectoryIdentity.IsContainer(Entry: TLdapEntry; Index: Integer): Boolean;
begin
  Result := Index in [bmOu, bmLocality, bmEntry, bmRoot];
end;}

{ TADDirectoryIdentity }

procedure TADDirectoryIdentity.ClassifyLdapEntry(Entry: TLdapEntry; out Container: Boolean; out ImageIndex: Integer);
var
  Attr: TLdapAttribute;
  i: integer;
  s: string;
begin
  Container := true;
  ImageIndex := bmEntry;
  Attr := Entry.AttributesByName['objectclass'];
  i := Attr.ValueCount - 1;
  while i >= 0 do
  begin
    s := lowercase(Attr.Values[i].AsString);
    if s = 'organizationalunit' then
      ImageIndex := bmOu
    else if s = 'container' then
      ImageIndex := bmContainer
    else if s = 'user' then
    begin
      if ImageIndex = bmEntry then // if not yet assigned to computer account
      begin
        ImageIndex := bmADUser;
        Container := false;
      end;
    end
    else
    if s = 'computer' then
    begin
      ImageIndex := bmComputer;
      Container := false;
    end
    else if s = 'group' then
    begin
      ImageIndex := bmADGroup;
      Container := false;
    end
    else if s = 'locality' then
      ImageIndex := bmLocality
    else if s = 'configuration' then
      ImageIndex := bmConfiguration
    else if s = 'classschema' then
    begin
      ImageIndex := bmClassSchema;
      Container := false;
    end
    else if s = 'attributeschema' then
    begin
      ImageIndex := bmAttributeSchema;
      Container := false;
    end
    else if (s = 'dmd') or (s = 'subschema') then
      ImageIndex := bmSchema;
    Dec(i);
  end;
  if (UseTemplateImages) and (ImageIndex = bmEntry) then
  begin
    i := GetTemplateIconIndex(Attr);
    if i <> -1 then
      ImageIndex := i + IconIndexBase;
  end;
end;

function TADDirectoryIdentity.SupportedPropertyObjects(const Index: Integer): Boolean;
begin
  case Index of
    bmOu,
    bmHost,
    bmLocality: Result := true;
  else
    Result := false;
  end;
end;

function  TADDirectoryIdentity.NewProperty(Owner: TControl; Connection: TConnection; const Index: Integer; const dn: string): Boolean;
begin
  Result := true;
  case Index of
    7: TOuDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    8: THostDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
    9: TLocalityDlg.Create(Owner, dn, Connection, EM_ADD).ShowModal;
  else
    Result := false;
  end;
end;

function TADDirectoryIdentity.EditProperty(Owner: TControl; Connection: TConnection; const Index: Integer; const dn: string): Boolean;
begin
  Result := true;
    case Index of
      bmOu:           TOuDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
      bmLocality:     TLocalityDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
      bmHost:         THostDlg.Create(Owner, dn, Connection, EM_MODIFY).ShowModal;
    else
      Result := false;
    end;
end;

function TADDirectoryIdentity.ChangePassword(Entry: TLdapEntry): Boolean;
begin
  with TADPassDlg.Create(nil, Entry) do
  try
    Result := ShowModal = mrOk;
  finally
    Free;
  end;
end;

{function TADDirectoryIdentity.IsContainer(Entry: TLdapEntry; Index: Integer): Boolean;
begin
  Result := Entry.AttributesByName['objectclass'].IndexOf('container') <> -1;
end;}

initialization

  TemplateIcons := nil;

finalization

  TemplateIcons.Free;

end.
