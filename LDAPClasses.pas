  {      LDAPAdmin - LDAPClasses.pas
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

unit LDAPClasses;

interface

uses Windows, Sysutils, WinLDAP, Classes, Constant;

const
  LdapOpRead            = $FFFFFFFF;
  LdapOpNoop            = $FFFFFFFE;
  LdapOpAdd             = LDAP_MOD_ADD;
  LdapOpReplace         = LDAP_MOD_REPLACE;
  LdapOpDelete          = LDAP_MOD_DELETE;

type
  ErrLDAP = class(Exception);
  PBytes = array of Byte;
  PCharArray = array of PChar;
  PPLDAPMod = array of PLDAPMod;
  PPLdapBerValA = array of PLdapBerVal;

  TLdapAttributeData = class;
  TLdapAttribute     = class;
  TLdapAttributeList = class;
  TLdapEntry         = class;
  TLdapEntryList     = class;

  TDataType = (dtUnknown, dtText, dtBinary);
  TLdapAttributeStates = set of (asNew, asBrowse, asModified, asDeleted);
  TLdapEntryStates = set of (esNew, esBrowse, esReading, esWriting, esModified);
  TLdapAttributeSortType = (AT_Attribute, AT_DN, AT_RDN, AT_Path);

  TSearchCallback = procedure (Sender: TLdapEntryList; var AbortSearch: Boolean) of object;

  TCompareLdapEntry = procedure(Entry1, Entry2: TLdapEntry; Data: pointer; out Result: Integer) of object;
  TDataNotifyEvent = procedure(Sender: TLdapAttributeData) of object;

  TLdapAttributeData = class
  private
    fBerval: record
      Bv_Len: Cardinal;
      Bv_Val: PBytes;
    end;
    fAttribute: TLdapAttribute;
    fEntry: TLdapEntry;
    fModOp: Cardinal;
    fType: TDataType;
    function GetType: TDataType;
    function GetString: string;
    procedure SetString(AValue: string);
    function BervalAddr: PLdapBerval;
  public
    constructor Create(Attribute: TLdapAttribute); virtual;
    function CompareData(P: Pointer; Length: Integer): Boolean;
    procedure SetData(AData: Pointer; ADataSize: Cardinal);
    procedure Delete;
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    property DataType: TDataType read GetType;
    property AsString: string read GetString write SetString;
    property DataSize: Cardinal read fBerval.Bv_Len;
    property Data: PBytes read fBerval.Bv_Val;
    property Berval: PLdapBerval read BervalAddr;
    property ModOp: Cardinal read fModOp;
    property Attribute: TLdapAttribute read fAttribute;
  end;

  TLdapAttribute = class
  private
    fState: TLdapAttributeStates;
    fName: string;
    fValues: TList;
    fOwnerList: TLdapAttributeList;
    fEntry: TLdapEntry;
    function GetCount: Integer;
    function GetValue(Index: Integer): TLdapAttributeData;
    function GetString: string;
    procedure SetString(AValue: string);
  public
    constructor Create(const AName: string; OwnerList: TLdapAttributeList); virtual;
    destructor Destroy; override;
    function  AddValue: TLdapAttributeData; overload;
    procedure AddValue(const AValue: string); overload; virtual;
    procedure AddValue(const AData: Pointer; const ADataSize: Cardinal); overload; virtual;
    procedure DeleteValue(const AValue: string); virtual;
    procedure Delete;
    function IndexOf(const AValue: string): Integer; overload;
    function IndexOf(const AData: Pointer; const ADataSize: Cardinal): Integer; overload;
    property State: TLdapAttributeStates read fState;
    property Name: string read fName;
    property Values[Index: Integer]: TLdapAttributeData read GetValue; default;
    property ValueCount: Integer read GetCount;
    property AsString: string read GetString write SetString;
    property Entry: TLdapEntry read fEntry;
  end;

  TLdapAttributeList = class
  private
    fList: TList;
    fEntry: TLdapEntry;
    function GetCount: Integer;
    function GetNode(Index: Integer): TLdapAttribute;
  public
    constructor Create(Entry: TLdapEntry); virtual;
    destructor Destroy; override;
    function Add(const AName: string): TLdapAttribute;
    //procedure Delete(const Index: Integer);
    function IndexOf(const Name: string): Integer;
    function AttributeOf(const Name: string): TLdapAttribute;
    procedure Clear;
    property Items[Index: Integer]: TLdapAttribute read GetNode; default;
    property Count: Integer read GetCount;
  end;

  TLDAPSession = class
  private
    ldappld: PLDAP;
    ldapServer: string;
    ldapUser, ldapPassword: string;
    ldapPort: Integer;
    ldapVersion: Integer;
    ldapBase: string;
    ldapSSL: Boolean;
    fNoPagedQueries: Boolean;
    procedure LDAPCheck(err: ULONG);
    procedure SetServer(Server: string);
    procedure SetUser(User: string);
    procedure SetPassword(Password: string);
    procedure SetPort(Port: Integer);
    procedure SetVersion(Version: Integer);
    procedure SetConnect(DoConnect: Boolean);
    procedure SetSSL(SSL: Boolean);
    function ISConnected: Boolean;
    procedure ProcessSearchEntry(const plmEntry: PLDAPMessage; Attributes: TLdapAttributeList);
    procedure ProcessSearchMessage(const plmSearch: PLDAPMessage; const NoValues: LongBool; Result: TLdapEntryList);
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
    function Lookup(sBase, sFilter, sResult: string; Scope: ULONG): string;
    function GetDn(sFilter: string): string;
    function GetFreeNumber(const Min, Max: Integer; const Objectclass, id: string): Integer;
    function GetFreeUidNumber(const MinUid, MaxUID: Integer): Integer;
    function GetFreeGidNumber(const MinGid, MaxGID: Integer): Integer;
    procedure Search(const Filter, Base: string; const Scope: Cardinal; QueryAttrs: array of string; const NoValues: LongBool; Result: TLdapEntryList; SearchProc: TSearchCallback = nil); overload;
    procedure Search(const Filter, Base: string; const Scope: Cardinal; attrs: PCharArray; const NoValues: LongBool; Result: TLdapEntryList; SearchProc: TSearchCallback = nil); overload;
    procedure ModifySet(const Filter, Base: string;
                        const Scope: Cardinal;
                        const AttrName, AttrValue, NewValue: string;
                        const ModOp: Cardinal);
    procedure WriteEntry(Entry: TLdapEntry);
    procedure ReadEntry(Entry: TLdapEntry);
    procedure DeleteEntry(const adn: string);

  end;

  TLDAPEntry = class
  private
    fSession: TLDAPSession;
    fdn: string;
    fAttributes: TLdapAttributeList;
    fState: TLdapEntryStates;
    fOnChangeProc: TDataNotifyEvent;
    function GetNamedAttribute(const AName: string): TLdapAttribute;
  protected
    procedure SetDn(const adn: string);
  public
    Tag: Integer;
    property Session: TLDAPSession read fSession;
    property dn: string read fdn write SetDn;
    constructor Create(const ASession: TLDAPSession; const adn: string); virtual;
    destructor Destroy; override;
    procedure Read; virtual;
    procedure Write; virtual;
    procedure Delete; virtual;
    property State: TLdapEntryStates read fState;
    property Attributes: TLdapAttributeList read fAttributes;
    property AttributesByName[const Name: string]: TLdapAttribute read GetNamedAttribute;
    property OnChange: TDataNotifyEvent read fOnChangeProc write fOnChangeProc;
  end;

  TLdapEntryList = class
  private
    fList:        TList;
    function      GetCount: Integer;
    function      GetNode(Index: Integer): TLdapEntry;
  public
    constructor   Create;
    destructor    Destroy; override;
    procedure     Add(Entry: TLdapEntry);
    procedure     Clear;
    property      Items[Index: Integer]: TLdapEntry read GetNode; default;
    property      Count: Integer read GetCount;
    procedure     Sort(const Attributes: array of string; const Asc: boolean); overload;
    procedure     Sort(const Compare: TCompareLdapEntry; const Asc: boolean; const Data: pointer=nil); overload;
  end;

{ Name handling routines }
function  CanonicalName(dn: string): string;
procedure SplitRdn(const dn: string; var attrib, value: string);
function  GetAttributeFromDn(const dn: string): string;
function  GetNameFromDn(const dn: string): string;
function  GetRdnFromDn(const dn: string): string;
function  GetDirFromDn(const dn: string): string;

{ String conversion routines }
function UTF8ToStringLen(const src: PChar; const Len: Cardinal): widestring;
function StringToUTF8Len(const src: PChar; const Len: Cardinal): string;

function GetAttributeSortType(Attribute: string): TLdapAttributeSortType;

const
  PSEUDOATTR_DN         = '*DN*';
  PSEUDOATTR_RDN        = '*RDN*';
  PSEUDOATTR_PATH       = '*PATH*';

implementation

uses Input, dialogs, wcrypt2;

{ VERIFYSERVERCERT callback function }

{ Global variables used by VerifyCert }
var
  CertUserAbort: Boolean;
  CertServerName: string;

function VerifyCert(Connection: PLDAP; pServerCert: PCCERT_CONTEXT): BOOLEAN; cdecl ;
var
  Collect: HCERTSTORE;
  MyStore, CaStore, RootStore: HCERTSTORE;
  flags: DWORD;
  iCert, pSub: PCCERT_CONTEXT;
  err: Cardinal;
  errStr: string;
  pszNameString: array [0..127] of Char;
begin
  Result := false;
  psub := PCCERT_CONTEXT(Pointer(pServerCert)^);
  Collect:= CertOpenStore ({CERT_STORE_PROV_COLLECTION}LPCSTR(11), 0, 0, 0, nil);
  MyStore:= CertOpenSystemStore (0, 'MY');
  if MyStore <> nil then
  begin
    CertAddStoreToCollection(Collect, MyStore, 0, 0);
    CertCloseStore(MyStore, 0);
  end;
  CaStore:= CertOpenSystemStore (0, 'CA');
  if CaStore <> nil then
  begin
    CertAddStoreToCollection (Collect, CaStore, 0, 2);
    CertCloseStore(CaStore, 0);
  end;
  RootStore:= CertOpenSystemStore (0, 'ROOT');
  if RootStore <> nil then
  begin
    CertAddStoreToCollection (Collect, RootStore, 0, 1);
    CertCloseStore(RootStore, 0);
  end;

  flags:= CERT_STORE_SIGNATURE_FLAG or CERT_STORE_TIME_VALIDITY_FLAG;
  iCert:= CertGetIssuerCertificateFromStore(collect, pSub, nil, @flags);
  if icert = nil then
  begin
    err := GetLastError;
    case err of
       {CRYPT_E_NOT_FOUND} $80092004: errStr := #9 + '- ' + stCertNotFound + #10#13;
       {CRYPT_E_SELF_SIGNED} $80092007: errStr := #9 + '- ' + stCertSelfSigned + #10#13;
    else
      errStr := #9 + '- ' + SysErrorMessage(err);
    end;
  end
  else
  begin
    CertGetNameString(pSub, {CERT_NAME_SIMPLE_DISPLAY_TYPE}4, 0, nil, pszNameString, 128);
    if flags and CERT_STORE_SIGNATURE_FLAG <> 0 then
      errStr := #9 + '- ' + stCertInvalidSig + #10#13;
    if flags and CERT_STORE_TIME_VALIDITY_FLAG <> 0 then
      errStr := errStr + #9 + '- ' + stCertInvalidTime + #10#13;
    if AnsiCompareStr(pszNameString, CertServerName) <> 0 then
      errStr := errStr + #9 + '- ' + stCertInvalidName + #10#13;
    CertFreeCertificateContext(iCert);
  end;
  if errStr = '' then
    Result := true
  else
  begin
    if MessageDlg(Format(stCertConfirmConn, [errStr]), mtWarning, [mbYes, mbNo], 0) = idYes then
      Result := true
    else
      CertUserAbort := true;
  end;
  CertCloseStore(collect, 0);
  CertFreeCertificateContext(pSub);
end;

{ Name handling routines }

function CanonicalName(dn: string): string;
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

procedure SplitRdn(const dn: string; var attrib, value: string);
var
  p, p0, p1: PChar;
begin
  p := PChar(dn);
  p0 := p;
  while (p^ <> #0) and (p^ <> '=') do
    p := CharNext(p);
  SetString(attrib, p0, p - p0);
  p := CharNext(p);
  p1 := p;
  while (p1^ <> #0) and (p1^ <> ',') do
    p1 := CharNext(p1);
  SetString(value, P, P1 - P);
end;

function GetAttributeFromDn(const dn: string): string;
var
  p, p1: PChar;
begin
  p := PChar(dn);
  p1 := p;
  while (p1^ <> #0) and (p1^ <> '=') do
    p1 := CharNext(p1);
  SetString(Result, P, P1 - P);
end;

function GetNameFromDn(const dn: string): string;
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

function GetRdnFromDn(const dn: string): string;
var
  p, p1: PChar;
begin
  p := PChar(dn);
  p1 := p;
  while (p1^ <> #0) and (p1^ <> ',') do
    p1 := CharNext(p1);
  SetString(Result, P, P1 - P);
end;

function GetDirFromDn(const dn: string): string;
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

{ String conversion routines }

{ Note: these functions ignore conversion errors }
function UTF8ToStringLen(const src: PChar; const Len: Cardinal): widestring;
var
  l: Integer;
begin
  SetLength(Result, Len);
  l := MultiByteToWideChar( CP_UTF8, 0, src, Len, PWChar(Result), Len*SizeOf(WideChar));
  SetLength(Result, l);
end;

function StringToUTF8Len(const src: PChar; const Len: Cardinal): string;
var
  bsiz: Integer;
  Temp: string;
begin
  bsiz := Len * 3;
  SetLength(Temp, bsiz);
  if bsiz > 0 then
  begin
    StringToWideChar(src, PWideChar(Temp), bsiz);
    SetLength(Result, bsiz);
    bsiz := WideCharToMultiByte(CP_UTF8, 0, PWideChar(Temp), Len, PChar(Result), bsiz, nil, nil);
    SetLength(Result, bsiz);
  end;
end;

function GetAttributeSortType(Attribute: string): TLdapAttributeSortType;
begin
  if Attribute=PSEUDOATTR_DN   then result:=AT_DN   else
  if Attribute=PSEUDOATTR_RDN  then result:=AT_RDN  else
  if Attribute=PSEUDOATTR_PATH then result:=AT_Path else
  result:=AT_Attribute;
end;

{ TLdapSession }

procedure TLdapSession.LDAPCheck(err: ULONG);
var
  ErrorEx: PChar;
begin
  if (err = LDAP_SUCCESS) then exit;
  if ((ldap_get_option(pld, LDAP_OPT_SERVER_ERROR, @ErrorEx)=LDAP_SUCCESS) and Assigned(ErrorEx)) then
  begin
    raise ErrLDAP.Create(Format(stLdapErrorEx, [ldap_err2string(err), ErrorEx]));
    ldap_memfree(ErrorEx);
  end
  else
    raise ErrLDAP.Create(Format(stLdapError, [ldap_err2string(err)]));
end;

procedure TLdapSession.ProcessSearchEntry(const plmEntry: PLDAPMessage; Attributes: TLdapAttributeList);
var
  Attr: TLdapAttribute;
  i: Integer;
  pszAttr: PChar;
  pbe: PBerElement;
  ppBer: PPLdapBerVal;
begin
  // loop thru attributes
  pszAttr := ldap_first_attribute(pld, plmEntry, pbe);
  while Assigned(pszAttr) do
  begin
    Attr := Attributes.Add(pszattr);
    Attr.fState := Attr.fState + [asBrowse];
    // get value
    ppBer := ldap_get_values_len(pld, plmEntry, pszAttr);
    if Assigned(ppBer) then
    try
      i := 0;
      while Assigned(PPLdapBervalA(ppBer)[i]) do
      begin
        Attr.AddValue(PPLdapBervalA(ppBer)[i]^.bv_val, PPLdapBervalA(ppBer)[i]^.bv_len);
        Inc(I);
      end;
    finally
      LDAPCheck(ldap_value_free_len(ppBer));
    end;
    ber_free(pbe, 0);
    pszAttr := ldap_next_attribute(pld, plmEntry, pbe);
  end;
end;

procedure TLDAPSession.ProcessSearchMessage(const plmSearch: PLDAPMessage; const NoValues: LongBool; Result: TLdapEntryList);
var
  pszdn: PChar;
  plmEntry: PLDAPMessage;
  Entry: TLdapEntry;
begin
  try
    // loop thru entries
    plmEntry := ldap_first_entry(pld, plmSearch);
    while Assigned(plmEntry) do
    begin
      pszdn := ldap_get_dn(pld, plmEntry);
      Entry := TLdapEntry.Create(Self, pszdn);
      Result.Add(Entry);
      if not NoValues then
      begin
        Entry.fState := [esReading];
        try
          ProcessSearchEntry(plmEntry, Entry.Attributes);
          Entry.fState := Entry.fState + [esBrowse]; 
        finally
          Entry.fState := Entry.fState - [esReading];
        end;
      end;
      if Assigned(pszdn) then
        ldap_memfree(pszdn);
      plmEntry := ldap_next_entry(pld, plmEntry);
    end;
  finally
    // free search results
    LDAPCheck(ldap_msgfree(plmSearch));
  end;
end;

procedure TLDAPSession.Search(const Filter, Base: string; const Scope: Cardinal; attrs: PCharArray; const NoValues: LongBool; Result: TLdapEntryList; SearchProc: TSearchCallback = nil);
var
  plmSearch: PLDAPMessage;
  Err: Integer;
  ServerControls: PLDAPControlA;
  ClientControls: PLDAPControlA;
  SortKeys: PLDAPSortKeyA;
  HSrch: PLDAPSearch;
  TotalCount: Cardinal;
  Timeout: LDAP_TIMEVAL;
  AbortSearch: Boolean;
begin

  if fNoPagedQueries then
  begin
    Err := ldap_search_s(pld, PChar(Base), Scope, PChar(Filter), PChar(attrs), Ord(NoValues), plmSearch);
    if Err = LDAP_SIZELIMIT_EXCEEDED then
      MessageDlg(ldap_err2string(err), mtWarning, [mbOk], 0)
    else
      LdapCheck(Err);
    ProcessSearchMessage(plmSearch, NoValues, Result);
    Exit;
  end;

  ServerControls:=nil;
  ClientControls:=nil;
  SortKeys:=nil;
  hsrch:=ldap_search_init_page(pld, PChar(Base), Scope, PChar(Filter), PPCharA(attrs), Ord(NoValues),
                                   ServerControls, ClientControls, 60, 0, SortKeys);
  if not Assigned(hsrch) then
  begin
    Err := LdapGetLastError;
    if Err <> LDAP_NOT_SUPPORTED then
      LdapCheck(Err); // raises exception
    fNoPagedQueries := true;
    LdapCheck(ldap_search_s(pld, PChar(Base), Scope, PChar(Filter), PChar(attrs), Ord(NoValues), plmSearch)); // try ordinary search
    ProcessSearchMessage(plmSearch, NoValues, Result);
    Exit;
  end;

  Timeout.tv_sec := 60;
  while true do
  begin
    Err := ldap_get_next_page_s(pld, hsrch, Timeout, 100, TotalCount, plmSearch);
    case Err of
      LDAP_UNAVAILABLE_CRIT_EXTENSION:
          begin
            fNoPagedQueries := true;
            ldap_search_abandon_page(pld, hsrch);
            LdapCheck(ldap_search_s(pld, PChar(Base), Scope, PChar(Filter), PChar(attrs), Ord(NoValues), plmSearch)); // try ordinary search
            ProcessSearchMessage(plmSearch, NoValues, Result);
            Break;
          end;
    LDAP_NO_RESULTS_RETURNED, LDAP_SIZELIMIT_EXCEEDED:
        begin
          if Err = LDAP_SIZELIMIT_EXCEEDED then
          begin
            ProcessSearchMessage(plmSearch, NoValues, Result);
            MessageDlg(ldap_err2string(err), mtWarning, [mbOk], 0)
          end;
          LdapCheck(ldap_search_abandon_page(pld, hsrch));
          break;
        end;
    LDAP_SUCCESS:
        begin
          if not Assigned(plmSearch) then
            Continue;
          ProcessSearchMessage(plmSearch, NoValues, Result);
          if Assigned(SearchProc) then
          begin
            AbortSearch := false;
            SearchProc(Result, AbortSearch);
            if AbortSearch then
            begin
              LdapCheck(ldap_search_abandon_page(pld, hsrch));
              break;
            end;
          end;
        end
    else
      LdapCheck(Err);
    end;
  end;
end;


procedure TLdapSession.Search(const Filter, Base: string; const Scope: Cardinal; QueryAttrs: array of string; const NoValues: LongBool; Result: TLdapEntryList; SearchProc: TSearchCallback = nil);
var
  attrs: PCharArray;
  len: Integer;
begin
  len := Length(QueryAttrs);
  if Len > 0 then
  begin
    SetLength(attrs, len + 1);
    attrs[len] := nil;
    repeat
      dec(len);
      attrs[len] := PChar(QueryAttrs[len]);
    until len = 0;
  end;
  Search(Filter, Base, Scope, attrs, NoValues, Result, SearchProc);
end;

{ Modify one attribute in every entry in set returned by search filter }
procedure TLDAPSession.ModifySet(const Filter, Base: string;
                                 const Scope: Cardinal;
                                 const AttrName, AttrValue, NewValue: string;
                                 const ModOp: Cardinal);
var
  List: TLdapEntryList;
  attrs: PCharArray;
  Entry: TLDapEntry;
  i: Integer;
begin
  List := TLdapEntryList.Create;
  try
    SetLength(attrs, 2);
    attrs[0] := PChar(AttrName);
    attrs[1] := nil;
    Search(Filter, Base, Scope, attrs, false, List);
    for i := 0 to List.Count - 1 do
    begin
      Entry := TLdapEntry(List[i]);
      with Entry.AttributesByName[AttrName] do
      begin
        DeleteValue(AttrValue);
        if ModOp <> LdapOpDelete then
          AddValue(NewValue);
        Entry.Write;
      end;
    end;
  finally
    List.Free;
  end;
end;

procedure TLDAPSession.WriteEntry(Entry: TLdapEntry);
var
  i, j, acnt, addidx, delidx, repidx: Integer;
  attrs: PPLDapMod;
  AttributeList: TLdapAttributeList;

  procedure ValueModOp(AValue: TLdapAttributeData; var idx: Integer);
  var
    pix: Integer;
  begin
    if idx < 0 then  // new entry
    begin
      if acnt = High(attrs) then            // we need trailing NULL
        SetLength(attrs, acnt + 10);        // expand array if neccessary
      idx := acnt;
      GetMem(attrs[acnt], SizeOf(LDAPMod));
      with attrs[acnt]^ do
      begin
        mod_op := AValue.ModOp or LDAP_MOD_BVALUES;
        mod_type := PChar(AValue.fAttribute.Name);
        modv_bvals := nil;        // MUST be nil before call to SetLength!
        SetLength(PPLdapBervalA(modv_bvals), 2);
        PPLdapBervalA(modv_bvals)[0] := AValue.BerVal;
        PPLdapBervalA(modv_bvals)[1] := nil;   // trailing NULL
      end;
      Inc(acnt);
    end
    else begin
      with attrs[idx]^ do begin
        pix := Length(PPLdapBervalA(modv_bvals));
        PPLdapBervalA(modv_bvals)[pix - 1] := AValue.BerVal;
        Setlength(PPLdapBervalA(modv_bvals), pix + 1);
        PPLdapBervalA(modv_bvals)[pix] := nil;  // trailing NULL
      end;
    end;
  end;

  procedure DeleteAll(const AttributeName: string);
  begin
    if acnt = High(attrs) then            // we need trailing NULL
      SetLength(attrs, acnt + 10);        // expand array if neccessary
    GetMem(attrs[acnt], SizeOf(LDAPMod));
    with attrs[acnt]^ do
    begin
      mod_op := LDAP_MOD_DELETE;
      mod_type := PChar(AttributeName);
      modv_bvals := nil;
    end;
    Inc(acnt);
  end;

begin
  AttributeList := Entry.Attributes; // for faster access
  SetLength(attrs, 10); // TODO ModopCount, acnt -> ModopCount
  acnt := 0;
  try
    for i := 0 to AttributeList.Count - 1 do
    begin
      if asDeleted in AttributeList[i].State then
        DeleteAll(AttributeList[i].Name)
      else
      if asModified in AttributeList[i].State then
      begin
        addidx := -1;
        delidx := -1;
        repidx := -1;
        for j := 0 to AttributeList[i].ValueCount - 1 do
          case AttributeList[i][j].ModOp of
            LDAP_MOD_ADD:     ValueModop(AttributeList[i][j], addidx);
            LDAP_MOD_DELETE:  ValueModop(AttributeList[i][j], delidx);
            LDAP_MOD_REPLACE: ValueModop(AttributeList[i][j], repidx);
          end;
      end;
    end;
    attrs[acnt] := nil;  // trailing NULL
    if acnt > 0 then
    begin
      if esNew in Entry.State then
        LdapCheck(ldap_add_s(pld, PChar(Entry.dn), PLDAPMod(attrs)))
      else
        LdapCheck(ldap_modify_s(pld, PChar(Entry.dn), PLDAPMod(attrs)));
    end;
  finally
    for i := 0 to acnt - 1 do
      FreeMem(attrs[i]);
  end;
end;

procedure TLDAPSession.ReadEntry(Entry: TLdapEntry);
var
  plmEntry: PLDAPMessage;
begin
  LdapCheck(ldap_search_s(pld, PChar(Entry.dn), LDAP_SCOPE_BASE, sANYCLASS, nil, 0, plmEntry));
  try
    if Assigned(plmEntry) then
       ProcessSearchEntry(plmEntry, Entry.Attributes);
  finally
    // free search results
    LDAPCheck(ldap_msgfree(plmEntry));
  end;
end;

procedure TLdapSession.DeleteEntry(const adn: string);
begin
  LdapCheck(ldap_delete_s(pld, PChar(adn)));
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

function TLDAPSession.GetDn(sFilter: string): string;
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

procedure TLDAPSession.SetServer(Server: string);
begin
  Disconnect;
  ldapServer := Server;
end;

procedure TLDAPSession.SetUser(User: string);
begin
  Disconnect;
  ldapUser := User;
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
var
  res: Cardinal;
begin
  if (ldapUser<>'') and (ldapPassword='') then
    if not InputDlg(cEnterPasswd, Format(stPassFor, [ldapUser]), ldapPassword, '*', true) then Abort;
  if ldapSSL then
    ldappld := ldap_sslinit(PChar(ldapServer), ldapPort,1)
  else
    ldappld := ldap_init(PChar(ldapServer), ldapPort);
  if Assigned(pld) then
  try
    LdapCheck(ldap_set_option(pld,LDAP_OPT_PROTOCOL_VERSION,@ldapVersion));
    res := ldap_set_option(pld, LDAP_OPT_SERVER_CERTIFICATE, @VerifyCert);
    if (res <> LDAP_SUCCESS) and (res <> LDAP_PARAM_ERROR) then
      LdapCheck(res);
    CertUserAbort := false;
    CertServerName := PChar(ldapServer);
    res := ldap_simple_bind_s(ldappld, PChar(ldapUser), PChar(ldapPassword));
    if CertUserAbort then
      Abort;
    LdapCheck(res);
    if ldapVersion < 3 then
      fNoPagedQueries := false;
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
    fNoPagedQueries := false;
  end;
end;

{ TLDapAttributeData }

function TLDapAttributeData.GetType: TDataType;
var
  l: Integer;
begin
  if (fType = dtUnknown) and (DataSize > 0) then
  begin
    l := MultiByteToWideChar( CP_UTF8, 8{MB_ERR_INVALID_CHARS}, PChar(Data), DataSize, nil, 0);
    if l <> 0 then
      fType := dtText
    else
      fType := dtBinary;
  end;
  Result := fType;
end;

function TLDapAttributeData.GetString: string;
begin
 if Assigned(Self) and (ModOp <> LdapOpNoop) and (ModOp <> LdapOpDelete) then
    Result := UTF8ToStringLen(PChar(Data), DataSize)
  else
    Result := '';
end;

procedure TLDapAttributeData.SetString(AValue: string);
var
  s: string;
begin
  s := StringToUtf8Len(PChar(AValue), Length(AValue));
  SetData(PChar(s), Length(s));
end;

procedure TLDapAttributeData.LoadFromStream(Stream: TStream);
var
  p: Pointer;
begin
  with Stream do
  begin
    GetMem(P, Size);
    try
      ReadBuffer(P^, Size);
      SetData(P, Size);
    finally
      FreeMem(P);
    end;
  end;
end;

procedure TLDapAttributeData.SaveToStream(Stream: TStream);
begin
  if Assigned(Self) and (ModOp <> LdapOpNoop) and (ModOp <> LdapOpDelete) then
    Stream.WriteBuffer(Berval.bv_Val^, fBerval.Bv_Len);
end;

function TLDapAttributeData.BervalAddr: PLdapBerval;
begin
  Result := Addr(fBerval);
end;

constructor TLDapAttributeData.Create(Attribute: TLdapAttribute);
begin
  fAttribute := Attribute;
  fEntry := Attribute.fEntry;
  fType := dtUnknown;
  inherited Create;
end;

{ Same as Result := (DataSize <> ADataSize) or not (Assigned(fBerval.Bv_Val) and CompareMem(AData, Data, ADataSize)); }
function TLDapAttributeData.CompareData(P: Pointer; Length: Integer): Boolean; assembler;
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,P
        MOV     EDX,EAX
        XOR     EAX,EAX
        MOV     EDI,[edx + fBerval.Bv_Val]
        CMP     ECX,[edx + fBerval.Bv_Len]
        JNE     @@2
        CMP     ESI,EDI
        JE      @@1
        REPE    CMPSB
        JNE     @@2
@@1:    INC     EAX
@@2:    POP     EDI
        POP     ESI
end;

procedure TLDapAttributeData.SetData(AData: Pointer; ADataSize: Cardinal);
var
  i: Integer;
begin
  if ADataSize = 0 then
    Delete
  else
  begin
    fAttribute.fState := fAttribute.fState - [asDeleted];
    if not CompareData(AData, ADataSize) then
    begin
      fType := dtUnknown;
      fBerval.Bv_Len := ADataSize;
      SetLength(fBerval.Bv_Val, ADataSize);
      Move(AData^, Pointer(fBerval.Bv_Val)^, ADataSize);
      if esReading in fEntry.State then
        fModOp := LdapOpRead
      else
      begin
        if ModOp = LdapOpNoop then
          fModOp := LDAP_MOD_ADD
        else
        if ModOp <> LDAP_MOD_ADD then
        begin
          for i := 0 to fAttribute.ValueCount - 1 do
            fAttribute.Values[i].fModOp := LDAP_MOD_REPLACE;
        end;
        fEntry.fState := fEntry.fState + [esModified];
        fAttribute.fState := fAttribute.fState + [asModified];
      end;
    end
    else begin
      if ModOp = LdapOpNoop then
        fModOp := LDAP_MOD_ADD
      else
      if ModOp = LDAP_MOD_DELETE then
        fModOp := LdapOpRead;
    end;
  end;
  if Assigned(fEntry.OnChange) then fEntry.OnChange(Self);
end;

procedure TLDapAttributeData.Delete;
var
  i: Integer;
begin
  if (fModOp = LdapOpNoop) then Exit;
  //if (fModOp = LDAP_MOD_ADD) or (fModOp = LDAP_MOD_REPLACE) then
  if fModOp = LDAP_MOD_ADD then
    fModOp := LdapOpNoop
  else
  begin
    if (fModOp = LdapOpReplace) and (fAttribute.fValues.Count > 1) then
    begin
      fModOp := LdapOpRead;
      with fAttribute do
      begin
        i := fValues.Count - 1;
        while i >= 0 do with Values[i] do
        begin
          if ModOp = LdapOpReplace then
            Exit;
          dec(i);
        end;
      end;
    end;

    fModOp := LDAP_MOD_DELETE;
    fAttribute.fState := fAttribute.fState + [asModified];
    fEntry.fState := fEntry.fState + [esModified];
    { Added to handle attributes with no equality matching rule.
    { Check if all single values are deleted, if so delete attribute as whole. }
    with fAttribute do
    begin
      i := fValues.Count - 1;
      while i >= 0 do with Values[i] do
      begin
        if (ModOp <> LdapOpDelete) and (ModOp <> LdapOpNoop) then
          break;
        dec(i);
      end;
      if i = -1 then
        fAttribute.fState := fAttribute.fState + [asDeleted];
    end;
    { end change }
  end;
  if Assigned(fEntry.OnChange) then fEntry.OnChange(Self);
end;

{ TLdapAttribute }

function TLdapAttribute.GetCount: Integer;
begin
  Result := fValues.Count;
end;

function TLdapAttribute.GetValue(Index: Integer): TLdapAttributeData;
begin
  if fValues.Count > 0 then
    Result := fValues[Index]
  else
    Result := nil;
end;

function TLdapAttribute.AddValue: TLdapAttributeData;
begin
  Result := TLdapAttributeData.Create(Self);
  fValues.Add(Result);
  //fState := fState - [asDeleted];
end;

procedure TLdapAttribute.AddValue(const AValue: string);
var
  idx: Integer;
  Value: TLdapAttributeData;
begin
  idx := IndexOf(AValue);
  if idx = -1 then
  begin
    Value := TLdapAttributeData.Create(Self);
    fValues.Add(Value);
  end
  else
    Value := TLdapAttributeData(fValues[idx]);
  Value.AsString := AValue;
end;

procedure TLdapAttribute.AddValue(const AData: Pointer; const ADataSize: Cardinal);
var
  idx: Integer;
  Value: TLdapAttributeData;
begin
  idx := IndexOf(AData, ADataSize);
  if idx = -1 then
  begin
    Value := TLdapAttributeData.Create(Self);
    fValues.Add(Value);
  end
  else
    Value := TLdapAttributeData(fValues[idx]);
  Value.SetData(AData, ADataSize);
end;


function TLdapAttribute.GetString: string;
begin
  if fValues.Count > 0 then
    Result := TLdapAttributeData(fValues[0]).AsString
  else
    Result := '';
end;

procedure TLdapAttribute.SetString(AValue: string);
begin
  // Setting string value(s) to '' means deleting of the attribute
  if AValue = '' then
    Delete
  else
  if fValues.Count = 0 then
    AddValue(AValue)
  else
    TLdapAttributeData(fValues[0]).AsString := PChar(AValue);
end;

constructor TLdapAttribute.Create(const AName: string; OwnerList: TLdapAttributeList);
begin
  fName := AName;
  fOwnerList := OwnerList;
  fEntry := OwnerList.fEntry;
  fValues := TList.Create;
end;

destructor TLdapAttribute.Destroy;
var
  i: Integer;
begin
  for i := 0 to fValues.Count - 1 do
    TLDapAttributeData(fValues[i]).Free;
  fValues.Free;
end;

procedure TLdapAttribute.DeleteValue(const AValue: string);
var
  idx: Integer;
begin
  idx := IndexOf(AValue);
  if idx > -1 then
    TLdapAttributeData(fValues[idx]).Delete;
end;

procedure TLdapAttribute.Delete;
var
  i: Integer;
begin
  if asBrowse in State then
  begin
    fState := fState + [asDeleted];
    fEntry.fState := fEntry.fState + [esModified];
  end;
  for i := 0 to fValues.Count - 1 do
    //TLdapAttributeData(fValues[i]).fModOp := LdapOpDelete;
    TLdapAttributeData(fValues[i]).Delete;
end;

function TLdapAttribute.IndexOf(const AValue: string): Integer;
begin
  Result := fValues.Count - 1;
  while Result >= 0 do begin
    if AnsiCompareText(AValue, TLdapAttributeData(fValues[Result]).AsString) = 0 then
      break;
    dec(Result);
  end;
end;

function TLdapAttribute.IndexOf(const AData: Pointer; const ADataSize: Cardinal): Integer;
begin
  Result := fValues.Count - 1;
  while Result >= 0 do begin
    if TLdapAttributeData(fValues[Result]).CompareData(AData, ADataSize) then
      break;
    dec(Result);
  end;
end;

{ TLdapAttributeList }

function TLdapAttributeList.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TLdapAttributeList.GetNode(Index: Integer): TLdapAttribute;
begin
  Result := TLdapAttribute(fList[Index]);
end;

constructor TLdapAttributeList.Create(Entry: TLdapEntry);
begin
  fEntry := Entry;
  fList := TList.Create;
end;

destructor TLdapAttributeList.Destroy;
var
  i: Integer;
begin
  for i := 0 to fList.Count - 1 do
    TLdapAttribute(fList[i]).Free;
  fList.Free;
  inherited Destroy;
end;

function TLdapAttributeList.Add(const AName: string): TLdapAttribute;
begin
  Result := TLdapAttribute.Create(AName, Self);
  fList.Add(Result);
end;

function TLdapAttributeList.IndexOf(const Name: string): Integer;
begin
  Result := fList.Count - 1;
  while Result >= 0 do
  begin
    if AnsiCompareText(Name, Items[Result].Name) = 0 then
      break;
    dec(Result);
  end;
end;

function TLdapAttributeList.AttributeOf(const Name: string): TLdapAttribute;
var
  idx: Integer;
begin
  Result := nil;
  for idx := 0 to fList.Count - 1 do
    if AnsiCompareText(Name, Items[idx].Name) = 0 then
    begin
      Result := Items[idx];
      break;
    end;
end;

procedure TLdapAttributeList.Clear;
var
  i: Integer;
begin
  for i := 0 to fList.Count - 1 do
    TLdapAttribute(fList[i]).Free;
  fList.Clear;
end;

{ TLdapEntry }

procedure TLDAPEntry.SetDn(const adn: string);
var
  attrib, value: string;
  i, j: Integer;
begin
  if esBrowse in State then
  begin
    if GetRdnFromDn(adn) <> GetRdnFromDn(fdn) then
    begin
      SplitRDN(adn, attrib, value);
      with AttributesByName[attrib] do
        if AsString <> '' then
          AsString := value;
    end;
    // Reset all flags
    i := Attributes.Count - 1;
    while i >= 0 do with Attributes[i] do
    begin
      fState := [asNew, asModified];
      j := ValueCount - 1;
      while j >= 0 do with Values[j] do
      begin
        if ModOp = LdapOpDelete then
        begin
          Free;
          fValues.Delete(j);
        end
        else
        if ModOp <> LdapOpNoop then
          fModOp := LdapOpAdd;
        dec(j);
      end;
      dec(i);
    end;
    fState := [esNew];
  end;
  fdn := adn;
end;

constructor TLDAPEntry.Create(const ASession: TLDAPSession; const adn: string);
begin
  inherited Create;
  fdn := adn;
  fSession := ASession;
  fState := [esNew];
  fAttributes := TLdapAttributeList.Create(Self);
end;

destructor TLDAPEntry.Destroy;
begin
  fAttributes.Free;
  inherited;
end;

procedure TLDAPEntry.Read;
begin
  fAttributes.Clear;
  fState := [esReading];
  try
    fSession.ReadEntry(Self);
    fState := fState + [esBrowse];
  finally
    fState := fState - [esReading];
  end;
end;

procedure TLDAPEntry.Write;
begin
  Session.WriteEntry(Self);
end;

procedure TLDAPEntry.Delete;
begin
  Session.DeleteEntry(dn);
end;

function TLDAPEntry.GetNamedAttribute(const AName: string): TLdapAttribute;
var
  i: Integer;
begin
  i := fAttributes.IndexOf(AName);
  if i < 0 then
    Result := fAttributes.Add(AName)
  else
    Result := fAttributes[i];
end;

{ TLdapEntryList }

function TLdapEntryList.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TLdapEntryList.GetNode(Index: Integer): TLdapEntry;
begin
  Result := TLdapEntry(fList[Index]);
end;

constructor TLdapEntryList.Create;
begin
  fList := TList.Create;
end;

destructor TLdapEntryList.Destroy;
var
  i: Integer;
begin
  for i := 0 to fList.Count - 1 do
    TLdapEntry(fList[i]).Free;
  fList.Free;
  inherited Destroy;
end;

procedure TLdapEntryList.Add(Entry: TLdapEntry);
begin
  fList.Add(Entry);
end;

procedure TLdapEntryList.Clear;
var
  i: Integer;
begin
  for i := 0 to fList.Count - 1 do
    TLdapEntry(fList[i]).Free;
  fList.Clear;
end;

procedure TLdapEntryList.Sort(const Attributes: array of string; const Asc: boolean);
var
  AttrTypes: array of TLdapAttributeSortType;
  i: integer;

  function  DoCompare(Entry1, Entry2: TLdapEntry): Integer;
  var
    i: integer;
  begin
    result := 0;
    for i:=0 to length(AttrTypes)-1 do begin
      case AttrTypes[i] of
        AT_DN:   result:=AnsiCompareStr(Entry1.DN, Entry2.DN);
        AT_RDN:  result:=AnsiCompareStr(GetRdnFromDn(Entry1.DN), GetRdnFromDn(Entry2.DN));
        AT_PATH: result:=AnsiCompareStr(CanonicalName(GetDirFromDn(Entry1.DN)),
                                        CanonicalName(GetDirFromDn(Entry2.DN)));
        else     result:=AnsiCompareStr(Entry1.AttributesByName[Attributes[i]].AsString,
                                         Entry2.AttributesByName[Attributes[i]].AsString)
      end;
      if result<>0 then break;
    end;

    if result=0 then result:=integer(Entry1)-integer(Entry2); // Delete QuickSort instability.
    if not Asc then result:=-result;
  end;

  procedure DoSort(L, R: Integer);
  var
    I, J: Integer;
    E: TLdapEntry;
    T: Pointer;
  begin
    repeat
      I := L;
      J := R;
      E := TLdapEntry(fList[(L + R) shr 1]);
      repeat
        while DoCompare(TLdapEntry(fList[I]), E) < 0 do Inc(I);
        while DoCompare(TLdapEntry(fList[J]), E) > 0 do Dec(J);
        if I <= J then
        begin
          T := fList[I];
          fList[I] := fList[J];
          fList[J] := T;
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then
        DoSort(L, J);
      L := I;
    until I >= R;
  end;

begin
  if (length(Attributes)=0) or (fList.Count = 0) then exit;
  setlength(AttrTypes, length(Attributes));
  for i:=0 to length(Attributes)-1 do AttrTypes[i]:=GetAttributeSortType(Attributes[i]);

  DoSort(0, fList.Count-1);
end;

procedure TLdapEntryList.Sort(const Compare: TCompareLdapEntry; const Asc: boolean; const Data: pointer=nil);

  function  DoCompare(Entry1, Entry2: TLdapEntry): Integer;
  begin
    Compare(Entry1, Entry2, Data, result);
    if result=0 then result:=integer(Entry1)-integer(Entry2); // Delete QuickSort instability.
    if not Asc then result:=-result;
  end;

  procedure DoSort(L, R: Integer);
  var
    I, J: Integer;
    E: TLdapEntry;
    T: Pointer;
  begin
    repeat
      I := L;
      J := R;
      E := TLdapEntry(fList[(L + R) shr 1]);
      repeat
        while DoCompare(TLdapEntry(fList[I]), E) < 0 do Inc(I);
        while DoCompare(TLdapEntry(fList[J]), E) > 0 do Dec(J);
        if I <= J then
        begin
          T := fList[I];
          fList[I] := fList[J];
          fList[J] := T;
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then
        DoSort(L, J);
      L := I;
    until I >= R;
  end;

begin
  if fList.Count = 0 then exit;
  DoSort(0, fList.Count-1);
end;

end.
