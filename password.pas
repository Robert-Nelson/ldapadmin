  {      LDAPAdmin - Password.pas
  *      Copyright (C) 2005 Tihomir Karlovic
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

unit Password;

interface

uses LdapClasses, MessageDigests;

type
  THashType = (chCrypt, chMd5Crypt, chMd2, chMd4, chMd5, chSha1, chRipemd);


const
  HashClasses: array [chMd2..chRipemd] of TMessageDigestClass = (
   TMD2, TMD4, TMD5, TSHA1, TRIPEMD160
  );
  IdStrings: array [chCrypt..chRipemd] of string = (
  '{CRYPT}','{CRYPT}','{MD2}','{MD4}','{MD5}','{SHA}','{RMD160}');

  sUserPassword: string = 'userPassword';

type
  TPasswordObject = class
  private
    fEntry: TLdapEntry;
    fHashType: THashType;
    procedure SetPassword(AValue: string);
    function  GetPassword: string;
    function Digest(const AValue: string): string;
    function Crypt(const AValue: string): string;
  public
    constructor Create(const Entry: TLdapEntry);
    property HashType: THashType read fHashType write fHashType;
    property Password: string read GetPassword write SetPassword;
  end;

implementation

uses Sysutils, Unixpass, md5crypt, base64;

function GetSalt(Len: Integer): string;
const
  SaltChars: array[0..63] of AnsiChar =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789./';
var
  i: Integer;
begin
  SetLength(Result, Len);
  for i := 1 to Len do
    Result[i] := SaltChars[Random(64)];
end;

function TPasswordObject.Digest(const AValue: string): string;
var
  md: TMessageDigest;
begin
  md := HashClasses[fHashType].Create;
  try
    md.TransformString(AValue);
    md.Complete;
    SetLength(Result, Base64encSize(md.DigestSize));
    Base64Encode(md.HashValueBytes^, md.DigestSize, Result[1]);
  finally
    md.Free;
  end;
end;

function TPasswordObject.Crypt(const AValue: string): string;
const
  SaltChars: array[0..63] of AnsiChar =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789./';
var
  Buff : array[0..30] of char;
begin
  UnixCrypt(PChar(GetSalt(2)), StrPCopy(Buff, AValue));
  Result := StrPas(Buff);
end;

procedure TPasswordObject.SetPassword(AValue: string);
var
  passwd: string;
begin
  case fHashType of
    chCrypt:     passwd := Crypt(AValue);
    chMd5Crypt:  passwd := md5_crypt(PChar(AValue), PChar(GetSalt(8)));
  else
    passwd := Digest(AValue);
  end;
  fEntry.AttributesByName[sUserPassword].AsString := IdStrings[fHashType] + passwd;
end;

function TPasswordObject.GetPassword: string;
begin
  Result := fEntry.AttributesByName[sUserPassword].AsString;
end;

constructor TPasswordObject.Create(const Entry: TLdapEntry);
begin
  fEntry := Entry;
  fHashType := chSha1;
end;

end.
