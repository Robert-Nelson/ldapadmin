  {      LDAPAdmin - Cert.pas
  *      Copyright (C) 2003-2011 Tihomir Karlovic
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

unit Cert;

interface

uses WinLdap, wcrypt2, Windows;

procedure ShowCert(x509Cert: Pointer; x509CertLen: Cardinal);
procedure ShowContext(x509Cert: Pointer; x509CertLen: Cardinal; ContextType: DWORD);
function  VerifyCert(Connection: PLDAP; pServerCert: PCCERT_CONTEXT): BOOLEAN; cdecl ;

const
  ctxAuto        = 0;
  ctxCertificate = CERT_STORE_CERTIFICATE_CONTEXT;
  ctxCRL         = CERT_STORE_CRL_CONTEXT;
  ctxCTL         = CERT_STORE_CTL_CONTEXT;

{ Global variables used by VerifyCert }
var
  CertUserAbort: Boolean;
  CertServerName: string;

implementation

uses Controls, sysutils, Dialogs, Misc, Constant,Classes;

type
  {TCryptUIDlgViewCertificate = function (
                           pViewCertificateInfo: PCCRYPTUI_VIEWCERTIFICATE_STRUCT;
                           pfPropertiesChanged: PBOOL
                           ): DWORD; stdcall;}

  TCryptUIDlgViewContext = function (
                           dwContextType: DWORD;
                           pvContext: PCCERT_CONTEXT;
                           hwnd: HWND;
                           pwszTitle: LPCWSTR;
                           dwFlags: DWORD;
                           pvReserved: Pointer): DWORD; stdcall;

  TUIDlg = class
  private
    Handle: THandle;
    fContextType: DWORD;
    //CryptUIDlgViewCertificate: TCryptUIDlgViewCertificate;
    CryptUIDlgViewContext: TCryptUIDlgViewContext;
    pCertContext: PCCERT_CONTEXT;
    Caption: string;
    procedure OnClick(Sender: TObject);
    procedure ShowCert;
  public
    OnClickProc: TNotifyEvent;
    constructor Create(ApCertContext: PCCERT_CONTEXT; ContextType: DWORD; ACaption: string);
    destructor Destroy; override;
  end;


constructor TUIDlg.Create(ApCertContext: PCCERT_CONTEXT; ContextType: DWORD; ACaption: string);
begin
  Handle := LoadLibrary(CRYPTUI);
  if Handle <> 0 then
  begin
    (*{$IFDEF UNICODE}
    @CryptUIDlgViewCertificate := GetProcAddress(Handle, 'CryptUIDlgViewCertificateW');
    {$ELSE}
    @CryptUIDlgViewCertificate :=  GetProcAddress(Handle, 'CryptUIDlgViewCertificateA');
    {$ENDIF}

    if @CryptUIDlgViewCertificate <> nil then*)

    fContextType := ContextType;
    @CryptUIDlgViewContext :=  GetProcAddress(Handle, 'CryptUIDlgViewContext');
    if @CryptUIDlgViewContext <> nil then
    begin
      OnClickProc := OnClick;
      Caption := ACaption;
      pCertContext := ApCertContext;
    end;
  end;
end;

destructor TUIDlg.Destroy;
begin
  FreeLibrary(Handle);
  inherited;
end;

procedure TUIDlg.OnClick(Sender: TObject);
begin
  ShowCert;
end;

{procedure TUIDlg.ShowCert;
var
  pvcStruct: PCCRYPTUI_VIEWCERTIFICATE_STRUCT;
  PropChanged: BOOL;
begin
  New(pvcStruct);
  try
    PropChanged := false;
    fillchar(pvcStruct^, SizeOf(CRYPTUI_VIEWCERTIFICATE_STRUCT), 0);
    pvcStruct.dwSize := SizeOf(CRYPTUI_VIEWCERTIFICATE_STRUCT);
    pvcStruct.pCertContext := pCertContext;
    pvcStruct.szTitle := PChar(Caption);
    pvcStruct.nStartPage := 0;
    CryptUIDlgViewCertificate(pvcStruct, @PropChanged) ; //show the cert
  finally
    Dispose(pvcStruct);
  end;
end;}

procedure TUIDlg.ShowCert;
begin
    CryptUIDlgViewContext(fContextType, pCertContext, 0, nil, 0, nil);
end;

procedure ShowContext(x509Cert: Pointer; x509CertLen: Cardinal; ContextType: DWORD);
var
  pCertContext: Pointer;
  uiDlg: TUIDlg;

  function AutoGetContext: Pointer;
  begin
    Result := CertCreateCertificateContext(X509_ASN_ENCODING + PKCS_7_ASN_ENCODING, x509Cert, x509CertLen);
    if not Assigned(Result) then
    begin
      Result := CertCreateCRLContext(X509_ASN_ENCODING + PKCS_7_ASN_ENCODING, x509Cert, x509CertLen);
      if not Assigned(Result) then
      begin
        Result := CertCreateCTLContext(X509_ASN_ENCODING + PKCS_7_ASN_ENCODING, x509Cert, x509CertLen);
        if Assigned(Result) then
          ContextType := ctxCTL
      end
      else
        ContextType := ctxCRL;
    end
    else
      ContextType := ctxCertificate;
  end;

begin
  { Could use CertCreateContext instead }
  pCertContext := nil;
  case ContextType of
    ctxAuto:        pCertContext := AutoGetContext;
    ctxCertificate: pCertContext := CertCreateCertificateContext(X509_ASN_ENCODING + PKCS_7_ASN_ENCODING, x509Cert, x509CertLen);
    ctxCRL:         pCertContext := CertCreateCRLContext(X509_ASN_ENCODING + PKCS_7_ASN_ENCODING, x509Cert, x509CertLen);
    ctxCTL:         pCertContext := CertCreateCTLContext(X509_ASN_ENCODING + PKCS_7_ASN_ENCODING, x509Cert, x509CertLen);
  end;

  if Assigned(pCertContext) then
  try
    uiDlg := TUIDlg.Create(pCertContext, ContextType, 'Certificate');
    try
      uidlg.ShowCert;
    finally
      uiDlg.Free;
    end;
  finally
     CertFreeCertificateContext(pCertContext);
  end;
end;

procedure ShowCert(x509Cert: Pointer; x509CertLen: Cardinal);
var
  pCertContext: PCCERT_CONTEXT;
  uiDlg: TUIDlg;
begin
  pCertContext := CertCreateCertificateContext(X509_ASN_ENCODING + PKCS_7_ASN_ENCODING, x509Cert, x509CertLen);
  if Assigned(pCertContext) then
  try
    uiDlg := TUIDlg.Create(pCertContext, CERT_STORE_CERTIFICATE_CONTEXT, 'Certificate');
    try
      uidlg.ShowCert;
    finally
      uiDlg.Free;
    end;
  finally
     CertFreeCertificateContext(pCertContext);
  end;
end;

function VerifyCertHostName(pCertContext: PCCERT_CONTEXT; HostName: string): boolean;
type
  PCERT_ALT_NAME_ENTRY = array of CERT_ALT_NAME_ENTRY;
var
  cbStructInfo, dwCommonNameLength, i: Cardinal;
  szOID: LPSTR;
  pvStructInfo: Cardinal;
  CommonName, DNSName: string;
  pExtension: PCERT_EXTENSION;
  pNameInfo: PCERT_ALT_NAME_INFO;
begin

  Result := false;

  if hostname = '' then Exit;

  // Try SUBJECT_ALT_NAME2 first - it supercedes SUBJECT_ALT_NAME
  szOID := szOID_SUBJECT_ALT_NAME2;
  pExtension := CertFindExtension(szOID, pCertContext^.pCertInfo^.cExtension,
                                  pCertContext^.pCertInfo^.rgExtension);
  if not Assigned(pExtension) then
  begin
    szOID := szOID_SUBJECT_ALT_NAME;
    pExtension := CertFindExtension(szOID, pCertContext^.pCertInfo^.cExtension,
                                    pCertContext^.pCertInfo^.rgExtension);
  end;

  if (Assigned(pExtension) and CryptDecodeObject(X509_ASN_ENCODING, szOID,
      pExtension^.Value.pbData, pExtension^.Value.cbData, 0, nil, @cbStructInfo)) then
  begin
    pvStructInfo := LocalAlloc(LMEM_FIXED, cbStructInfo);
    if pvStructInfo <> 0 then
    begin
      CryptDecodeObject(X509_ASN_ENCODING, szOID, pExtension^.Value.pbData,
                        pExtension^.Value.cbData, 0, Pointer(pvStructInfo), @cbStructInfo);
      pNameInfo := PCERT_ALT_NAME_INFO(pvStructInfo);
      i := 0;
      while (not Result and (i < pNameInfo^.cAltEntry)) do
      begin
        if (PCERT_ALT_NAME_ENTRY(pNameInfo^.rgAltEntry)[i].dwAltNameChoice = CERT_ALT_NAME_DNS_NAME) then
        begin
          DNSName := WideCharToString(PCERT_ALT_NAME_ENTRY(pNameInfo^.rgAltEntry)[i].pwszDNSName);
          if (CompareText(HostName, DNSName) = 0) then
          begin
            Result := true;
            break;
          end;
        end;
        inc(i);
      end;
      LocalFree(pvStructInfo);
      if Result then
        Exit;
    end;
  end;

  // No subjectAltName extension -- check commonName

  dwCommonNameLength := CertGetNameString(pCertContext, {CERT_NAME_ATTR_TYPE}3, 0,
                                          PChar(szOID_COMMON_NAME), nil, 0);
  if (dwCommonNameLength <> 0) then
  begin

    SetLength(CommonName, dwCommonNameLength);

    CertGetNameString(pCertContext, {CERT_NAME_ATTR_TYPE}3, 0, PChar(szOID_COMMON_NAME),
                       PChar(CommonName), dwCommonNameLength);
    if AnsiCompareStr(HostName, CommonName) = 0 then // compare null terminated
      Result := true;
  end;

end;

{ VERIFYSERVERCERT callback function }

function VerifyCert(Connection: PLDAP; pServerCert: PCCERT_CONTEXT): BOOLEAN; cdecl ;
var
  Collect: HCERTSTORE;
  MyStore, CaStore, RootStore: HCERTSTORE;
  flags: DWORD;
  iCert, pSub: PCCERT_CONTEXT;
  err: Cardinal;
  errStr, cap: string;
  uidlg: TUIDlg;
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
    //CertGetNameString(pSub, {CERT_NAME_SIMPLE_DISPLAY_TYPE}4, 0, nil, pszNameString, 128);
    if flags and CERT_STORE_SIGNATURE_FLAG <> 0 then
      errStr := #9 + '- ' + stCertInvalidSig + #10#13;
    if flags and CERT_STORE_TIME_VALIDITY_FLAG <> 0 then
      errStr := errStr + #9 + '- ' + stCertInvalidTime + #10#13;
    if not VerifyCertHostName(pSub, CertServerName) then
      errStr := errStr + #9 + '- ' + stCertInvalidName + #10#13;
    CertFreeCertificateContext(iCert);
  end;
  if errStr = '' then
    Result := true
  else
  begin
    uiDlg := TUIDlg.Create(pSub, CERT_STORE_CERTIFICATE_CONTEXT, cCert);
    if Assigned(UIDlg.OnClickProc) then
      cap := cView
    else
      cap := '';
    if MessageDlgEx(Format(stCertConfirmConn, [errStr]), mtWarning, [mbYes, mbNo, mbHelp], ['','',cap], [nil,nil,uiDlg.OnClickProc]) = mrYes then
      Result := true
    else
      CertUserAbort := true;
    uiDlg.Free;
  end;
  CertCloseStore(collect, 0);
  CertFreeCertificateContext(pSub);
end;

end.
