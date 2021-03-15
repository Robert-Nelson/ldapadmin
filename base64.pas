  {      LDAPAdmin - base64.pas
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

unit base64;

interface

const
  CRLF : String = #13#10;

function Base64Size(InSize: Cardinal): Cardinal;
procedure Base64Encode(const InBuf; const Length: Cardinal; var OutBuf);

implementation

uses SysUtils;

function Base64Size(InSize: Cardinal): Cardinal;
begin
  Result := 4 * (InSize div 3);
  if (Insize mod 3) <> 0 then
    Inc(Result, 4);
end;

procedure Base64Encode(const InBuf; const Length: Cardinal; var OutBuf);
var
  idx, mdx, pad: Integer;
  b24: Cardinal;
  pIn, pOut: PByteArray;
const
  Base64Set: array[0..63] of AnsiChar =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

begin

    mdx := Length div 3;
    pad := Length mod 3;

    pIn := @InBuf;
    pOut := @OutBuf;
    for idx := 0 to mdx - 1 do
    begin
        b24 := pIn^[0] shl 16 + pIn^[1] shl 8 + pIn^[2];
        pOut^[3] := Byte(Base64Set[b24 and $3F]);
        b24 := b24 shr 6;
        pOut^[2] := Byte(Base64Set[b24 and $3F]);
        b24 := b24 shr 6;
        pOut^[1] := Byte(Base64Set[b24 and $3F]);
        pOut^[0] := Byte(Base64Set[b24 shr 6]);
        inc(Cardinal(pIn), 3);
        inc(Cardinal(pOut), 4);
    end;

    case pad of
      1: begin
           pOut^[0] := Byte(Base64Set[pIn^[0] shr 2]);
           pOut^[1] := Byte(Base64Set[(pIn^[0] shl 4) and $3F]);
           pOut^[2] := Byte('=');
           pOut^[3] := Byte('=');
         end;
      2: begin
           b24 := pIn^[0] shl 8 + pIn^[1];
           pOut^[2] := Byte(Base64Set[b24 and $3F]) shl 2;
           b24 := b24 shr 4;
           pOut^[1] := Byte(Base64Set[b24 and $3F]);
           pOut^[0] := Byte(Base64Set[b24 shr 6]);
           pOut^[3] := Byte('=');
         end;
    else
      //raise Exception.Create('This shouldn't happend!');
    end;
end;
end.
