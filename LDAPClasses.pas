  {      LDAPAdmin - LDAPClasses.pas
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

unit LDAPClasses;

interface

uses Windows, Sysutils, WinLDAP, Classes, Constant;

type
  ErrLDAP = class(Exception);
  PCharArray = array of PChar;
  PPLDAPMod = array of PLDAPMod;


  TLDAPSession = class
  private
    ldappld: PLDAP;
    ldapServer: string;
    ldapUser, ldapPassword: string;
    ldapPort: Integer;
    ldapVersion: Integer;
    ldapBase: string;
    ldapSSL: Boolean;
    procedure SetServer(Server: string);
    procedure SetUser(User: string);
    procedure SetPassword(Password: string);
    procedure SetPort(Port: Integer);
    procedure SetVersion(Version: Integer);
    procedure SetConnect(DoConnect: Boolean);
    procedure SetSSL(SSL: Boolean);
    function ISConnected: Boolean;
  public
    procedure Connect;
    procedure Disconnect;
    property pld: PLDAP read ldappld;
    property Server: string read ldapServer write SetServer;
    property User: string read ldapUser write SetUser;
    property Password: string read ldapPassword write SetPassword;
    property Port: Integer read ldapPort write SetPort;
    property Version: Integer read ldapVersion write SetVersion;
    property SSL: Boolean read ldapSSL write SetSSL;
    property Base: string read ldapBase write ldapBase;
    property Connected: Boolean read IsConnected write SetConnect;
    function CanonicalName(dn: string): string;
    function Lookup(sBase, sFilter, sResult: string; Scope: ULONG): string;
    function GetDN(sFilter: string): string;
    function GetFreeNumber(const Min, Max: Integer; const Objectclass, id: string): Integer;
    function GetFreeUidNumber(const MinUid, MaxUID: Integer): Integer;
    function GetFreeGidNumber(const MinGid, MaxGID: Integer): Integer;
    function GetNameFromDN(dn: string): string;
    function GetDirFromDN(dn: string): string;
    function Search(const Filter, dn: string; const Scope: Cardinal): TStringList;
  end;


  TLDAPEntry = class
  private
    lpld: PLDAP;
    ldn: PChar;
    Count: Integer;
    attrs: PPLdapMod;
    fItems: TStringList;
    function IndexOf(entryName: string; Mode: ULONG): Integer;
  protected
    procedure SetDn(const Dn: PChar);
  public
    property dn: PChar read ldn write SetDn;
    constructor Create(apld: PLDAP; adn: string); virtual;
    constructor Copy(const CEntry: TLdapEntry); virtual;
    destructor Destroy; override;
    procedure Read; virtual;
    procedure AddAttr(attrName, attrValue: string; Mode: ULONG);
    procedure ClearAttrs;
    procedure New; virtual;
    procedure Modify; virtual;
    procedure ToLDIF(var F: TextFile; const Wrap: Integer);
    property Items: TStringList read fItems;
  end;


procedure LDAPCheck(err: ULONG);

implementation

uses base64;

procedure LDAPCheck(err: ULONG);
begin
  if (err <> LDAP_SUCCESS) then
    raise ErrLDAP.Create('LDAP Fehler: ' + ldap_err2string(err));
end;

function TLDAPSession.CanonicalName(dn: string): string;
var
  comp: PPChar;
  i: Integer;
begin
  Result := '';
  comp := ldap_explode_dn(PChar(dn), 1);
  i := 0;
  if Assigned(comp) then
  while PCharArray(comp)[i] <> nil do
  begin
    Result := Result + PCharArray(comp)[i] + '/';
    inc(i);
  end;
  ldap_value_free(comp);
end;

function TLDAPSession.GetDN(sFilter: string): string;
var
  plmSearch, plmEntry: PLDAPMessage;
  attrs: PCharArray;
begin
    // set result to dn only
    SetLength(attrs, 2);
    attrs[0] := 'objectclass';
    attrs[1] := nil;
    Result := '';
    // perform search
    LdapCheck(ldap_search_s(pld, PChar(ldapBase), LDAP_SCOPE_SUBTREE, PChar(sFilter), PChar(attrs), 1, plmSearch));
    try
      plmEntry := ldap_first_entry(pld, plmSearch);
      if Assigned(plmEntry) then
        Result := ldap_get_dn(pld, plmEntry);
    finally
      // free search results
      LDAPCheck(ldap_msgfree(plmSearch));
    end;
end;

function TLDAPSession.GetNameFromDN(dn: string): string;
var
  p, p1: PChar;
begin
  p := PChar(dn);
  while (p^ <> #0) and (p^ <> '=') do
    p := CharNext(p);
  p := CharNext(p);
  p1 := p;
  while (p1^ <> #0) and (p1^ <> ',') do
    p1 := CharNext(p1);
  SetString(Result, P, P1 - P);
end;

function TLDAPSession.GetDirFromDN(dn: string): string;
var
  p: PChar;
begin
  p := PChar(dn);
  while (p^ <> #0) do
  begin
    if (p^ = ',') then
    begin
      p := CharNext(p);
      break;
    end;
    p := CharNext(p);
  end;
  Result := p;
end;

function TLDAPSession.Search(const Filter, dn: string; const Scope: Cardinal): TStringList;
var
  plmSearch, plmEntry: PLDAPMessage;
  attrs: PCharArray;
  pszdn: PChar;
begin

  Result := TStringList.Create;
  // set result to objectclass only
  SetLength(attrs, 2);
  attrs[0] := 'objectclass';
  attrs[1] := nil;
  LdapCheck(ldap_search_s(pld, PChar(dn), Scope, PChar(Filter), PChar(attrs), 1, plmSearch));

  try

    plmEntry := ldap_first_entry(pld, plmSearch);

    while Assigned(plmEntry) do
    begin

      pszdn := ldap_get_dn(pld, plmEntry);

      if Assigned(pszdn) then
      try
        Result.Add(pszdn);
      finally
        ldap_memfree(pszdn);
      end;

      plmEntry := ldap_next_entry(pld, plmEntry);

    end;
  finally
    // free search results
    LDAPCheck(ldap_msgfree(plmSearch));
  end;

end;

{ Get random free uidNumber from the pool of available numbers, return -1 if
  no more free numbers available }
function TLDAPSession.GetFreeNumber(const Min, Max: Integer; const Objectclass, id: string): Integer;
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

function TLDAPSession.GetFreeUidNumber(const MinUid, MaxUID: Integer): Integer;
begin
  Result := GetFreeNumber(MinUid, MaxUid, 'posixAccount', 'uidNumber');
  if Result = -1 then
    raise Exception.Create(Format(stNoMoreNums, ['uidNumber']));
end;

function TLDAPSession.GetFreeGidNumber(const MinGid, MaxGid: Integer): Integer;
begin
  Result := GetFreeNumber(MinGid, MaxGid, 'posixGroup', 'gidNumber');
  if Result = -1 then
    raise Exception.Create(Format(stNoMoreNums, ['gidNumber']));
end;

function TLDAPSession.Lookup(sBase, sFilter, sResult: string; Scope: ULONG): string;
var
  plmSearch, plmEntry: PLDAPMessage;
  attrs: PCharArray;
  ppcVals: PPCHAR;
begin
    // set result to sResult only
    SetLength(attrs, 2);
    attrs[0] := PChar(sResult);
    attrs[1] := nil;
    Result := '';
    // perform search
    LdapCheck(ldap_search_s(pld, PChar(sBase), Scope, PChar(sFilter), PChar(attrs), 0, plmSearch));
    try
      plmEntry := ldap_first_entry(pld, plmSearch);
      if Assigned(plmEntry) then
      begin
        ppcVals := ldap_get_values(pld, plmEntry, attrs[0]);
        try
          if Assigned(ppcVals) then
            Result := pchararray(ppcVals)[0];
        finally
          LDAPCheck(ldap_value_free(ppcVals));
        end;
      end;
    finally
      // free search results
      LDAPCheck(ldap_msgfree(plmSearch));
    end;
end;

procedure TLDAPSession.SetServer(Server: string);
begin
  Disconnect;
  ldapServer := Server;
end;
procedure TLDAPSession.SetUser(User: string);
begin
  Disconnect;
  ldapUser := USer;
end;
procedure TLDAPSession.SetPassword(Password: string);
begin
  Disconnect;
  ldapPassword := Password;
end;
procedure TLDAPSession.SetPort(Port: Integer);
begin
  Disconnect;
  ldapPort := Port;
end;
procedure TLDAPSession.SetVersion(Version: Integer);
begin
  Disconnect;
  ldapVersion := Version;
end;

procedure TLDAPSession.SetSSL(SSL: Boolean);
begin
  Disconnect;
  ldapSSL := SSL;
end;

procedure TLDAPSession.SetConnect(DoConnect: Boolean);
begin
  if not Connected then
    Connect;
end;

function TLDAPSession.IsConnected: Boolean;
begin
  Result := Assigned(pld);
end;

procedure TLDAPSession.Connect;
begin

  if ldapSSL then
    ldappld := ldap_sslinit(PChar(ldapServer), ldapPort,1)
  else
    ldappld := ldap_init(PChar(ldapServer), ldapPort);

  if Assigned(pld) then
  try
    LdapCheck(ldap_set_option(pld,LDAP_OPT_PROTOCOL_VERSION,@ldapVersion));
    LdapCheck(ldap_simple_bind_s(ldappld, PChar(ldapUser), PChar(ldapPassword)));
  except
    // close connection
    LdapCheck(ldap_unbind_s(pld));
    ldappld := nil;
    raise;
  end;

end;

procedure TLDAPSession.Disconnect;
begin
  if Connected then
  begin
    LdapCheck(ldap_unbind_s(pld));
    ldappld := nil;
  end;
end;

{ TLDAPEntry }

procedure TLDAPEntry.SetDn(const Dn: PChar);
begin
  ldn := Dn;
end;

constructor TLDAPEntry.Create(apld: PLDAP; adn: string);
begin
  inherited Create;
  ldn := PChar(adn);
  lpld := apld;
  SetLength(attrs, 10);
end;

constructor TLDAPEntry.Copy(const CEntry: TLdapEntry);
var
  i, j, h: Integer;
  cMod: PLdapMod;
begin
  inherited Create;
  lpld := CEntry.lpld;
  ldn := CEntry.ldn;
  Count := CEntry.Count;
  SetLength(attrs, High(Centry.Attrs));

  i := 0;
  while CEntry.Attrs[i] <> nil do
  begin
    cMod := CEntry.Attrs[i];
    GetMem(attrs[i], SizeOf(LDAPMod));
    with attrs[i]^ do
    begin
      mod_op := cMod.mod_op;
      mod_type := cMod.mod_type;
      if cMod.modv_strvals <> nil then
      begin
        h := High(PCharArray(cMod.modv_strvals));
        modv_strvals := nil; // Prepare for SetLength
        SetLength(PCharArray(modv_strvals), h + 1);
        for j := 0 to h - 1 do
          PCharArray(modv_strvals)[j] := StrNew(PCharArray(cMod.modv_strvals)[j]);
        PCharArray(modv_strvals)[h] := nil;   // trailing NULL
      end;
    end;
    inc(i);
  end;

  if Assigned(CEntry.Items) then
  begin
    fItems := TStringList.Create;
    for i := 0 to CEntry.Items.Count - 1 do
    begin
      fItems.Add(CEntry.Items[i]);
      fItems.Objects[i] := Pointer(StrNew(PChar(CEntry.Items.Objects[i])));
    end;
  end;
end;

destructor TLDAPEntry.Destroy;
var
  i: Integer;
begin

  ClearAttrs;

  // finalize the attrs array
  attrs := nil;

  if Assigned(fItems) then
    for i := 0 to fItems.Count - 1 do
      StrDispose(PChar(fItems.Objects[i]));

  inherited Destroy;
end;

procedure TLDAPEntry.Read;
var
  pszAttr: PChar;
  pbe: PBerElement;
  plmSearch, plmEntry: PLDAPMessage;
  ppcVals: PPChar;
  I, idx: Integer;
begin

  if not Assigned(fItems) then
    fItems := TStringList.Create
  else
  begin
    for i := 0 to fItems.Count - 1 do
      StrDispose(PChar(fItems.Objects[i]));
    fItems.Clear;
  end;

  LdapCheck(ldap_search_s(lpld, ldn, LDAP_SCOPE_BASE, '(objectclass=*)', nil, 0, plmSearch));

  try

    // loop thru entries
    plmEntry := ldap_first_entry(lpld, plmSearch);
    while Assigned(plmEntry) do
    begin

      // loop thru attributes
      pszAttr := ldap_first_attribute(lpld, plmEntry, pbe);
      while Assigned(pszAttr) do
      begin

        // get value
        ppcVals := ldap_get_values(lpld, plmEntry, pszAttr);
        if Assigned(ppcVals) then
        try

            I := 0;
            while Assigned(PCharArray(ppcVals)[I]) do
            begin
              idx := fItems.Add(pszAttr);
              fItems.Objects[idx] := Pointer(StrNew(PCharArray(ppcVals)[I]));
              Inc(I);
            end;

        finally
          LDAPCheck(ldap_value_free(ppcVals));
        end;

        ber_free(pbe, 0);
        pszAttr := ldap_next_attribute(lpld, plmEntry, pbe);
      end;

      plmEntry := ldap_next_entry(lpld, plmEntry);
    end;

  finally
    // free search results
    LDAPCheck(ldap_msgfree(plmSearch));
  end;

end;

function TLDAPEntry.IndexOf(entryName: string; Mode: ULONG): Integer;
var
  I: Integer;
begin
  I := Count - 1;
  while I >= 0 do
  begin
    If (attrs[i].mod_op = Mode) and (StrIComp(PChar(entryName), attrs[i].mod_type) = 0) then
      break;
    Dec(I);
  end;
  Result := I;
end;

procedure TLDAPEntry.AddAttr(attrName, attrValue: string; Mode: ULONG);
var
  I: Integer;
begin

    // Check if this attribute-operation entry is allready in list
    I := IndexOf(attrName, Mode);
    if I < 0 then  // new entry
    begin
      if Count = High(attrs) then            // we need trailing NULL
        SetLength(attrs, Count + 10);        // expand array if neccessary
      GetMem(attrs[Count], SizeOf(LDAPMod));
      with attrs[Count]^ do
      begin
        mod_op := Mode;
        mod_type := PChar(attrName);
        modv_strvals := nil;        // MUST be nil before call to SetLength!
        if attrValue <> '' then
        begin
          SetLength(PCharArray(modv_strvals), 2);
          PCharArray(modv_strvals)[0] := StrNew(PChar(attrValue));
          PCharArray(modv_strvals)[1] := nil;   // trailing NULL
        end;
      end;
      Inc(Count);
      attrs[Count] := nil;            // trailing NULL
    end
    else begin
      with attrs[I]^ do begin
        I := Length(PCharArray(modv_strvals));
        PCharArray(modv_strvals)[I - 1] := StrNew(PChar(attrValue));
        Setlength(PCharArray(modv_strvals), I + 1);
        PCharArray(modv_strvals)[I] := nil;  // trailing NULL
      end;
    end;
end;

procedure TLDAPEntry.ClearAttrs;
var
  i, j: Integer;
begin
  Count := 0;
  i := 0;
  while attrs[i] <> nil do with attrs[i]^ do
  begin
    if Assigned(modv_strvals) then
    begin
      j := 0;
      while PCharArray(modv_strvals)[j] <> nil do
      begin
        StrDispose(PCharArray(modv_strvals)[j]);   // dispose of the strings
        inc(j);
      end;
    end;
    modv_strvals := nil;                         // finalize the string array
    FreeMem(attrs[i]);                           // dispose of the PLDAPMod record
    attrs[i] := nil;
    Inc(i);
  end;
end;

procedure TLDAPEntry.New;
begin
  if Count > 0 then
    LdapCheck(ldap_add_s(lpld, ldn, PLDAPMod(attrs)));
end;

procedure TLDAPEntry.Modify;
begin
  if Count > 0 then
    LdapCheck(ldap_modify_s(lpld, ldn, PLDAPMod(attrs)));
end;

procedure TLDAPEntry.ToLDIF(var F: TextFile; const Wrap: Integer);
const
  SafeChar:     set of Char = [#$01..#09, #$0B..#$0C, #$0E..#$7F];
  SafeInitChar: set of Char = [#$01..#09, #$0B..#$0C, #$0E..#$1F, #$21..#$39, #$3B, #$3D..#$7F];
var
  i: Integer;

  { Tests whether string contains only safe chars }
  function IsSafe(const s: string): Boolean;
  var
    p: PChar;
  begin
    Result := true;
    p := PChar(s);
    if not (p^ in SafeInitChar) then
    begin
      Result := false;
      exit;
    end;
    while (p^ <> #0) do
    begin
      if not (p^ in SafeChar) then
      begin
        Result := false;
        break;
      end;
      p := CharNext(p);
    end;
  end;

  { Converts string to UTF8 format }
  function StringToUTF8(const src: string): string;
  var
    Dest, UTF8: array [0..1] of WideChar;
    p: PChar;
    c: string;
  begin
    Result := '';
    p := PChar(src);
    while (p^ <> #0) do
    begin
      if p^ < #128 then
        Result := Result + p^
      else
      begin
        c := p^;
        StringToWideChar(c, @Dest, SizeOf(Dest));
        WideCharToMultiByte(CP_UTF8, 0, @Dest, 1, LPSTR(@Utf8), SizeOf(UTF8), nil, nil);
        Result := Result + Char(Lo(Integer(UTF8))) + Char(Hi(Integer(UTF8)));
      end;
      p := CharNext(p);
    end;
  end;

  { If neccessary converts value to base64 coding and dumps the string to file
    wrapping the line so that max length doesn't exceed Wrap count of chars }
  procedure PutLine(var F: Text; const attrib, value: string; const Wrap: Integer);
  var
    p1, len: Integer;
    line, utfstr, s: string;
  begin

    line := attrib + ':';

    if value <> '' then
    begin
      // Check if we need to encode to base64
      if IsSafe(value) then
        line := line + ' ' + value
      else
      begin
        utfstr := StringToUTF8(value);
        SetLength(s, Base64Size(Length(utfstr)*SizeOf(Char)));
        Base64Encode(utfstr[1], Length(utfstr)*SizeOf(Char), s[1]);
        line := line + ': ' + s;
      end;
    end;

    len := Length(line);
    p1 := 1;
    while p1 < len do
    begin
      if p1 = 1 then
      begin
        WriteLn(F, System.Copy(line, p1, wrap));
        inc(p1, wrap);
      end
      else begin
        WriteLn(F, ' ' + System.Copy(line, P1, wrap - 1));
        inc(p1, wrap - 1);
      end;
    end;
  end;

begin
  // Dump this entry to LDIF record
  try
    PutLine(F, 'dn', ldn, Wrap);
    for i := 0 to Items.Count - 1 do
      PutLine(F, Items[i], PChar(Items.Objects[i]), Wrap);
    WriteLn(F);
  except
    RaiseLastWin32Error;
  end;

end;

end.
