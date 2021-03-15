  {      LDAPAdmin - NetUtil.pas
  *      Copyright (C) 2017 Tihomir Karlovic
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


unit NetUtil;

interface

uses Windows, Connection;

type
  TTrustConnection = class
  private
    FShare:     string;
    FServer:    string;
    FUsername:  string;
    FPassword:  string;
    FErrCode:   Cardinal;
  public
    constructor Create(AConnection: TConnection);
    procedure   Connect;
    procedure   Disconnect;
    destructor  Destroy; override;
    property    ErrorCode: Cardinal read FErrCode;
  end;

function AddConnection(Share, UserName, Password: string; Flags: DWORD): Cardinal;
function RemoveConnection(Share: string): Boolean;

implementation

uses SysUtils, LdapClasses;

function AddConnection(Share, UserName, Password: string; Flags: DWORD): Cardinal;
var
  nr: NETRESOURCE;
  Res: DWORD;
begin
  nr.dwType := RESOURCETYPE_ANY;
  nr.lpLocalName := '';
  nr.lpRemoteName := PChar(Share);
  nr.lpProvider := nil;
  Result := WNetAddConnection2(nr, PChar(Password), PChar(UserName), Flags);
end;

function RemoveConnection(Share: string): Boolean;
begin
  Result := WNetCancelConnection2(PChar(Share), 0, FALSE) = NO_ERROR;
end;

procedure TTrustConnection.Connect;
var
  Msg: string;
begin
  FErrCode := AddConnection(FShare, FUsername, FPassword, CONNECT_INTERACTIVE);
  if FErrCode <> NO_ERROR then
    RaiseLastOSError;
end;

procedure TTrustConnection.Disconnect;
begin
  RemoveConnection(FShare);
end;

constructor TTrustConnection.Create(AConnection: TConnection);
begin
  FServer := AConnection.Server;
  FUsername := GetNameFromDn(AConnection.User);
  if FUsername = '' then
    FUsername := AConnection.User;
  FPassword := AConnection.Password;
  FShare := '\\' + FServer + '\IPC$';
  Connect;
end;

destructor  TTrustConnection.Destroy;
begin
  Disconnect;
  inherited;
end;

end.
