  {      LDAPAdmin - Passdlg.pas
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

unit PassDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons;

type
  TPasswordDlg = class(TForm)
    Label1: TLabel;
    Password: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    Password2: TEdit;
    Label2: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    function PutUniCode(var adst; src: PChar): Integer;
    function HashToHex(Hash: PByteArray; len: Integer): string;
    function GetNTPassword: string;
    function GetlmPassword: string;
    function GetMD5Password: string;
  public
    property NTPassword: string read GetNTPassword;
    property lmPassword: string read GetlmPassword;
    property md5Password: string read GetMD5Password;
  end;

var
  PasswordDlg: TPasswordDlg;

implementation

{$R *.DFM}

uses md4, md5, smbdes, base64, Constant;

{ This function is ported from mkntpwd.c by Anton Roeckseisen (anton@genua.de) }

function TPasswordDlg.PutUniCode(var adst; src: PChar): Integer;
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


function TPasswordDlg.HashToHex(Hash: PByteArray; len: Integer): string;
var
  i: Integer;
begin
  for i := 0 to len - 1 do
    Result := Result + IntToHex(Hash[i], 2);
end;


function TPasswordDlg.GetNTPassword: string;
var
  Passwd: array[0..255] of Byte;
  Hash: array[0..16] of Byte;
  slen: Integer;
begin
  fillchar(passwd, 255, 0);
  slen := PutUniCode(Passwd, PChar(Password.text));
  fillchar(hash, 17, 0);
  mdfour(hash, Passwd, slen);
  Result := HashToHex(@Hash, 16);
end;

function TPasswordDlg.GetlmPassword: string;
begin
  Result := HashToHex(PByteArray(e_p16(UpperCase(Password.Text))), 16);
end;

function TPasswordDlg.GetMD5Password: string;
var
  adigest: digest;
begin
  md5digest(PChar(Password.Text), length(Password.Text), adigest);
  //Result := '{MD5}' + HashToHex(PByteArray(@adigest), 16);
  SetLength(Result, Base64Size(SizeOf(digest)));
  Base64Encode(adigest, SizeOf(digest), Result[1]);
  Result := '{MD5}' + Result;
end;

procedure TPasswordDlg.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if (ModalResult = mrOk) and (Password.Text <> Password2.Text) then
    raise Exception.Create(sPassDiff);
end;

end.

