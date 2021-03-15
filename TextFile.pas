  {      LDAPAdmin - TextFile.pas
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

unit TextFile;

interface

uses SysUtils, Classes;

const
  BUF_SIZE = 4096;

type
  TTextFile = class(TFileStream)
  private
    fBuffer: array[0..BUF_SIZE-1] of Char;
    fPos: Integer;
    fNumRead: Integer;
    fUnixWrite: Boolean;
    function IsEof: Boolean;
  public
    function  ReadLn: string;
    procedure WriteLn(Value: string);
    property Eof: Boolean read IsEof;
    property UnixWrite: Boolean read fUnixWrite write fUnixWrite;
  end;

implementation

function TTextFile.IsEof: Boolean;
begin
  Result := (Position = Size) and (fPos = fNumRead);
end;

function TTextFile.ReadLn: string;
var
  p1, s1, len: Integer;
begin
  if Eof then
    raise Exception.Create('EOF!');
  s1 := 0;
  Result := '';
  repeat
    if fPos = fNumRead then
    begin
      fNumRead := Read(fBuffer, BUF_SIZE);
      if fNumRead = 0 then
        break;
      fPos := 0;
    end;
    p1 := fPos;
    while (p1 < fNumRead) and  (fBuffer[p1] <> #10) do
      inc(p1);
    len := p1 - fPos;
    if len > 0 then
    begin
      if fBuffer[p1 - 1] = #13 then
        dec(len);
      SetLength(Result, s1 + len);
      Move(fBuffer[fPos], Result[s1 + 1], len);
      s1 := s1 + len;
      fPos := p1;
    end;
    if fPos < fNumRead then // EOL found
    begin
      inc(fPos);
      break;
    end;
  until Eof;
end;

procedure TTextFile.WriteLn(Value: string);
var
  len: Integer;
begin
  len := Length(Value) + 1;
  SetLength(Value, len + Ord(not UnixWrite));
  if not UnixWrite then
  begin
    Value[Len] := #13;
    inc(Len);
  end;
  Value[Len] := #10;
  Write(Value[1], Length(Value));
end;

end.
