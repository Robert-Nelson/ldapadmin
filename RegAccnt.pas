  {      LDAPAdmin - Regaccnt.pas
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

unit RegAccnt;

interface

uses Constant;

type
  TAccountEntry = class
    Name,
    ldapServer,
    ldapBase,
    ldapUser,
    ldapPassword: string;
    ldapPort: Integer;
    ldapUseSSL: Boolean;
    ldapVersion: Integer;
    posixFirstUID,
    posixLastUID,
    posixFirstGID,
    posixLastGID: Integer;
    posixUserName,
    inetDisplayName,
    posixHomeDir,
    posixLoginShell: string;
    posixGroup: Integer;
    sambaNetbiosName,
    sambaDomainName,
    sambaHomeShare,
    sambaHomeDrive,
    sambaScript,
    sambaProfilePath,
    postfixMailAddress,
    postfixMaildrop: string;
    Reserved: Integer;

  public
    constructor Create(AccName: string);
    procedure Read;
    procedure Write;
    function GetConnDataSize: Integer;
    function GetPrefDataSize: Integer;
    function GetDataSize: Integer;
    property ConnDataSize: Integer read GetConnDataSize;
    property PrefDataSize: Integer read GetPrefDataSize;
    property DataSize: Integer read GetDataSize;
  end;

implementation

uses Windows, WinLDAP, Registry, SysUtils;

function TAccountEntry.GetConnDataSize: Integer;
begin
  Result := Length(ldapServer) +
            Length(ldapBase) +
            Length(ldapUser) +
            Length(ldapPassword) +
            6 * SizeOf(Integer) +
            SizeOf(Boolean);
end;
function TAccountEntry.GetPrefDataSize: Integer;
begin
      Result := Length(posixUserName) +
                Length(inetDisplayName) +
                Length(posixHomeDir) +
                Length(posixLoginShell) +
                Length(sambaNetbiosName) +
                Length(sambaDomainName) +
                Length(sambaHomeShare) +
                Length(sambaHomeDrive) +
                Length(sambaScript) +
                Length(sambaProfilePath) +
                Length(postfixMailAddress) +
                Length(postfixMaildrop) +
                18 * SizeOf(Integer);
end;

function TAccountEntry.GetDataSize: Integer;
begin
  Result := ConnDataSize + PrefDataSize;
end;

constructor TAccountEntry.Create(AccName: string);
begin
  inherited Create;
  Name := AccName;
  { defaults }
  ldapPort := LDAP_PORT;
  ldapVersion := LDAP_VERSION3;
  posixFirstUID := FIRST_UID;
  posixLastUID := LAST_UID;
  posixFirstGID := FIRST_GID;
  posixLastGID := LAST_GID;
  Reserved := 0;
  if Name <> '' then
    Read
end;

procedure TAccountEntry.Read;
var
  Reg: TRegistry;
  RegDataSize, Offset: Integer;
  Buffer: PByteArray;
  lver: Integer;

  function ReadString: string;
  var
    StrLen: Integer;
  begin
    StrLen := Integer(Buffer[Offset]);
    Inc(Offset, SizeOf(Integer));
    SetString(Result,PChar(@Buffer[offset]),StrLen);
    Inc(Offset, StrLen);
  end;

  function ReadInteger: Integer;
  var
    pint: ^Integer;
  begin
    pint := @Buffer[Offset];
    Result := pInt^;
    inc(Offset, SizeOf(Integer));
  end;

  function ReadBoolean: Boolean;
  var
    pBool: ^Boolean;
  begin
    pBool := @Buffer[Offset];
    Result := pBool^;
    inc(Offset, SizeOf(Boolean));
  end;

begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(REG_KEY + REG_ACCOUNT, false) then
    begin
      RegDataSize := Reg.GetDataSize(Name);
      if RegDataSize > 0 then
      begin
        GetMem(Buffer, RegDataSize);
        Reg.ReadBinaryData(Name, Buffer^, RegDataSize);
        Offset := 0;
        ldapServer := ReadString;
        ldapBase := ReadString;
        ldapUser := ReadString;
        ldapPassword := ReadString;
        ldapPort := ReadInteger;
        ldapUseSSL := ReadBoolean;
        lver := ReadInteger;
        if (lver <> LDAP_VERSION2) and (lver <> LDAP_VERSION3) then
          LdapVersion := LDAP_VERSION3
        else
          LdapVersion := lver;
        if RegDataSize > ConnDataSize then // Compatibility
          begin
            posixFirstUID := ReadInteger;
            posixLastUID := ReadInteger;
            posixFirstGID := ReadInteger;
            posixLastGID := ReadInteger;
            posixUserName := ReadString;
            inetDisplayName := ReadString;
            posixHomeDir := ReadString;
            posixLoginShell := ReadString;
            posixGroup := ReadInteger;
            sambaNetbiosName := ReadString;
            sambaDomainName := ReadString;
            sambaHomeShare := ReadString;
            sambaHomeDrive := ReadString;
            sambaScript := ReadString;
            sambaProfilePath := ReadString;
            postfixMailAddress := ReadString;
            postfixMaildrop := ReadString;
            Reserved := ReadInteger;
          end;
      end
      else
        raise Exception.Create(stRegAccntErr);
    end;
  finally
    Reg.CloseKey;
    Reg.Free;
    Dispose(Buffer);
  end;
end;

procedure TAccountEntry.Write;
var
  Reg: TRegistry;
  Offset: Integer;
  Buffer: PByteArray;

  procedure WriteStr(s: string);
  var
    StrLen: Integer;
  begin
    StrLen := Length(s);
    Move(StrLen,Buffer[offset],SizeOf(Integer));
    Inc(Offset, SizeOf(Integer));
    Move(Pointer(s)^,Buffer[offset],StrLen);
    Inc(Offset, StrLen);
  end;

  procedure WriteInteger(i: Integer);
  var
    pint: ^Integer;
  begin
    pInt := @Buffer[Offset];
    pInt^ := i;
    inc(Offset,SizeOf(Integer));
  end;

  procedure WriteBoolean(b: Boolean);
  var
    pBool: ^Boolean;
  begin
    pBool := @Buffer[Offset];
    pBool^ := b;
    inc(Offset,SizeOf(Boolean));
  end;

begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(REG_KEY + REG_ACCOUNT, true) then
    begin
      GetMem(Buffer, DataSize);
      Offset := 0;
      WriteStr(ldapServer);
      WriteStr(ldapBase);
      WriteStr(ldapUser);
      WriteStr(ldapPassword);
      WriteInteger(ldapPort);
      WriteBoolean(ldapUseSSL);
      WriteInteger(LdapVersion);
      WriteInteger(posixFirstUID);
      WriteInteger(posixLastUID);
      WriteInteger(posixFirstGID);
      WriteInteger(posixLastGID);
      WriteStr(posixUserName);
      WriteStr(inetDisplayName);
      WriteStr(posixHomeDir);
      WriteStr(posixLoginShell);
      WriteInteger(posixGroup);
      WriteStr(sambaNetbiosName);
      WriteStr(sambaDomainName);
      WriteStr(sambaHomeShare);
      WriteStr(sambaHomeDrive);
      WriteStr(sambaScript);
      WriteStr(sambaProfilePath);
      WriteStr(postfixMailAddress);
      WriteStr(postfixMaildrop);
      WriteInteger(Reserved);
      Reg.WriteBinaryData(Name, Buffer^, DataSize);
    end;
  finally
    Reg.CloseKey;
    Reg.Free;
    Dispose(Buffer);
  end;
end;

end.
